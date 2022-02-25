Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3BC14C4D5C
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 19:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbiBYSL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 13:11:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiBYSLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 13:11:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA621D6CA6;
        Fri, 25 Feb 2022 10:10:50 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21PGtWDa023888;
        Fri, 25 Feb 2022 18:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=61BM7ilbHdY41DX4NxPizFOYioL+vFqBRklTl7njE+U=;
 b=CUU9ktTd6a88KWwqTlVE+K9Jlmdp5mKN0OtbfpziEY06lx6230AC91raCY5wMC6RKlHK
 srNxaomuq2P0V/uSNci1K/odMr76kBQdOoYwMajyBeHfPe77G3bUHe4NZVfnTarW6n2h
 oaxmjgV4/UI2/dFuSCGbwvkFqTxasbkE6v4LN9bgFDVvB4GEUj3yW01qX/dGRRx2/Xks
 gsGwOLA4QOSbw/Vs5wuMw3paUMxGcSDHVIB12MJZnulOmNsM+frrKM1TOzCt2ClKxQh/
 2+h/xLKPmKDSXtGpX1n+3dWqvYqsxa/f1YacE/x1uPpUWkus5AeOoA5t2X5Fphs5ThXp mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ef0p65yjm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 18:10:47 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21PHh3Ai031914;
        Fri, 25 Feb 2022 18:10:47 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ef0p65yj1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 18:10:46 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21PI8J50027951;
        Fri, 25 Feb 2022 18:10:44 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3eeg2s60n4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Feb 2022 18:10:44 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21PIAfPR57999804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Feb 2022 18:10:41 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 404AAA4059;
        Fri, 25 Feb 2022 18:10:41 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAA94A4051;
        Fri, 25 Feb 2022 18:10:40 +0000 (GMT)
Received: from [9.171.32.81] (unknown [9.171.32.81])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Feb 2022 18:10:40 +0000 (GMT)
Message-ID: <f2afb775-a156-2c32-a49a-225545dc2bf7@linux.ibm.com>
Date:   Fri, 25 Feb 2022 19:10:40 +0100
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
 <bc3252a3-5a84-63d4-dfc5-009f602a5bec@linux.ibm.com>
 <20220224020253.GF5443@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220224020253.GF5443@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: skg6BhqZDUbQHmjM1dW9jLR7TLWE9_S8
X-Proofpoint-ORIG-GUID: Dk2ZOabE8R8NupNi9xscmP9BkLaw1d_B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-25_09,2022-02-25_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 priorityscore=1501 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 clxscore=1015 phishscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202250102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/02/2022 03:02, dust.li wrote:
> On Wed, Feb 23, 2022 at 07:57:31PM +0100, Karsten Graul wrote:
>> On 19/02/2022 00:42, dust.li wrote:
>>> On Fri, Feb 18, 2022 at 05:03:56PM +0100, Karsten Graul wrote:
>>>> Right now for me it looks like there is no way to use netlink for container runtime
>>>> configuration, which is a pity.
>>>> We continue our discussions about this in the team, and also here on the list.
>>>
>>> Many thanks for your time on this topic !
>>
>> We checked more specs (like Container Network Interface (CNI) Specification) 
>> but all we found uses sysctl at the end. There is lot of infrastructure 
>> to use sysctls in a container environment.
>>
>> Establishing netlink-like controls for containers is by far out of our scope, and
>> would take a long time until it would be available in the popular projects.
>>
>> So at the moment I see no alternative to an additional sysctl interface in the 
>> SMC module that provides controls which are useful in container environments.
> 
> Got it, I will add sysctl interface and a switch with this function.
> 
> Thank again !

Can you explain again why this auto_cork needs a switch to disable it?
My understanding is that this auto_cork makes always sense and is triggered
when there are not enough resources.
