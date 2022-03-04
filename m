Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E30BD4CCFD1
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 09:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232172AbiCDIUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 03:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiCDIUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 03:20:10 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B5E195335;
        Fri,  4 Mar 2022 00:19:22 -0800 (PST)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2246ngvs017681;
        Fri, 4 Mar 2022 08:19:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jHJpfKXos8yxpcLzhydCzMHLSLVTL2iZSGKJQwvnrKI=;
 b=mbRxKDKM0L1ZYtdErnihnKLV1zX0UMDk5rm6IeAJxo2mh6Jq8em9EIjiPaYfGfmT/a3F
 e81iEnsfeYaUY32vo2oMv3eawxw+qEA3aSahNNMni7Jil5Z+iMR0w7ZrLXZC9li3nSAa
 fN16Mi3mbvc7liuxwB/HT1Q+1f9bwcsCXDIaA9tC1nNguThjb4JaRDJJ3uXW7QZBQTMv
 ctvX98ciQIjsThA5dfZZ06UzFhjp1f8039bjfLqc1UAB3Dm+3oEV45MuXjejMLLn7a0Z
 aldVTxogbY2tClhQ+7SElMNSicZ98Bae/rqUXx0++L+G7wZDlyeAny+z7fc0W0YkmZQN 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ekdugsdjx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 08:19:17 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 224832dK018346;
        Fri, 4 Mar 2022 08:19:16 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ekdugsdjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 08:19:16 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2248F6tf029193;
        Fri, 4 Mar 2022 08:19:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3ek4k416c7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 08:19:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2248JCLA55771442
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Mar 2022 08:19:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1CF14C046;
        Fri,  4 Mar 2022 08:19:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 25E834C040;
        Fri,  4 Mar 2022 08:19:12 +0000 (GMT)
Received: from [9.171.45.180] (unknown [9.171.45.180])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Mar 2022 08:19:12 +0000 (GMT)
Message-ID: <2a950f5a-d3be-0790-2487-9a3c37894b5b@linux.ibm.com>
Date:   Fri, 4 Mar 2022 09:19:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH net-next 6/7] net/smc: don't req_notify until all CQEs
 drained
Content-Language: en-US
To:     dust.li@linux.alibaba.com
Cc:     Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        Leon Romanovsky <leon@kernel.org>
References: <20220301094402.14992-1-dust.li@linux.alibaba.com>
 <20220301094402.14992-7-dust.li@linux.alibaba.com> <Yh3x93sPCS+w/Eth@unreal>
 <20220301105332.GA9417@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220301105332.GA9417@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P4CLBJSQkCY3EQiJOegY8KgiLmAA0veH
X-Proofpoint-GUID: eAgYhKH6nIIghlvYBjd8eCH-hcOxkym-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_02,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 mlxlogscore=806 malwarescore=0 lowpriorityscore=0 adultscore=0
 clxscore=1015 mlxscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/03/2022 11:53, dust.li wrote:
> On Tue, Mar 01, 2022 at 12:14:15PM +0200, Leon Romanovsky wrote:
>> On Tue, Mar 01, 2022 at 05:44:01PM +0800, Dust Li wrote:
>> 1. Please remove "--Guangguan Wang".
>> 2. We already discussed that. SMC should be changed to use RDMA CQ pool API
>> drivers/infiniband/core/cq.c.
>> ib_poll_handler() has much better implementation (tracing, IRQ rescheduling,
>> proper error handling) than this SMC variant.
> 
> OK, I'll remove this patch in the next version.

Looks like this one was accepted already, but per discussion (and I agree with that) -
please revert this patch. Thank you.


