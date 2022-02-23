Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8834C1B45
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 19:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiBWS55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 13:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbiBWS54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 13:57:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0849B29837;
        Wed, 23 Feb 2022 10:57:27 -0800 (PST)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NHIZKu026532;
        Wed, 23 Feb 2022 18:57:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Mkh4dUQ5Ypka5egNRySemcws707R37tGQCEWyl/L/zM=;
 b=eQXGj3VOoZ15h1E8r+fcln3UCiifoo1uw6GBdVDQBXtV+ZoNvSwgiLQcMFfib/Z8fLAZ
 8aogfG3DYchVsFuvoi/tW8e23dtikyzfCZsCBENigP0Zs39FGnNNBrwBo+SvklcyePwf
 VTBMSropWUSz37zYT/JqWtZMKsg23r8SdaHuhhjv9U3i4U9Y39oe4HvxJ1zdz/CuS96K
 BDm48If2FyRE+G1Ese/0CT/9pBORlZrV9Eoy5l8axI5s0+0wz1LIhyX8pmuoLhnLBeiv
 a9To0Zxj9Tt1uDWnGJ7O0DMjUvjucdaJqILeFzSHMibCrBCOjFuJgOCrQsw1p/W4DxR3 GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ede6t15eh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 18:57:24 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NICCkm029389;
        Wed, 23 Feb 2022 18:57:24 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ede6t15dr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 18:57:23 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NIul4I026635;
        Wed, 23 Feb 2022 18:57:21 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3ear69ajcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 18:57:21 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NIvHbI30998894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 18:57:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF7B6AE053;
        Wed, 23 Feb 2022 18:57:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55042AE04D;
        Wed, 23 Feb 2022 18:57:17 +0000 (GMT)
Received: from [9.171.51.229] (unknown [9.171.51.229])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Feb 2022 18:57:17 +0000 (GMT)
Message-ID: <bc3252a3-5a84-63d4-dfc5-009f602a5bec@linux.ibm.com>
Date:   Wed, 23 Feb 2022 19:57:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net/smc: Add autocork support
Content-Language: en-US
To:     dust.li@linux.alibaba.com,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Cc:     Stefan Raspl <raspl@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20220216034903.20173-1-dust.li@linux.alibaba.com>
 <68e9534b-7ff5-5a65-9017-124dbae0c74b@linux.ibm.com>
 <20220216152721.GB39286@linux.alibaba.com>
 <454b5efd-e611-2dfb-e462-e7ceaee0da4d@linux.ibm.com>
 <20220217132200.GA5443@linux.alibaba.com> <Yg6Q2kIDJrhvNVz7@linux.ibm.com>
 <20220218073327.GB5443@linux.alibaba.com>
 <d4ce4674-3ced-da34-a8a4-30d74cbe24bb@linux.ibm.com>
 <20220218234232.GC5443@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220218234232.GC5443@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Fyp25lHlfm8BvSD9vJu8XFm7wJujfm-B
X-Proofpoint-ORIG-GUID: LAyXRrWZ9CuE87Jh0JCKLx0hV-ApzYV_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_09,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 mlxlogscore=999
 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0 suspectscore=0
 spamscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202230106
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/02/2022 00:42, dust.li wrote:
> On Fri, Feb 18, 2022 at 05:03:56PM +0100, Karsten Graul wrote:
>> Right now for me it looks like there is no way to use netlink for container runtime
>> configuration, which is a pity.
>> We continue our discussions about this in the team, and also here on the list.
> 
> Many thanks for your time on this topic !

We checked more specs (like Container Network Interface (CNI) Specification) 
but all we found uses sysctl at the end. There is lot of infrastructure 
to use sysctls in a container environment.

Establishing netlink-like controls for containers is by far out of our scope, and
would take a long time until it would be available in the popular projects.

So at the moment I see no alternative to an additional sysctl interface in the 
SMC module that provides controls which are useful in container environments.
