Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8404B6CEC
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 14:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbiBONCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 08:02:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235227AbiBONCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 08:02:54 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B72E38E191;
        Tue, 15 Feb 2022 05:02:44 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FBq8da023249;
        Tue, 15 Feb 2022 13:02:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5jNLfeML1Pf7f6SKsGY+wtoiphEm3qzr/iqbH036YpM=;
 b=UwzVCRN7xg9MbEnY8QCIYPXEoHIOnPu0UT6RUXC2GLG8PH4P++Vd2Od+i9gKpHxSw9/+
 pYyIUQYRuPIg30RhhGtDAF8eFbwDg7iNulm9LJOXadAd6Cy+YjmstZK+Zfu9g2eN8zFd
 O0wHxysUip1JSn0ylCSsj8oftZ4SpniMdUvFfp8hGq9BAjJ6CN1tUXgYECV++KxHYO+u
 wGrZREoVNKDFTMA/YpRb3xrWIz8RHuddR84LYnOeMhjqYw+q/f/1iAfEzCVGN48AtysL
 7K6DKC2A2mjg2R89XMWl5J3mENkHj2wlHY5RZoGz3nwfzO4mdM6rG8yEhDUoLfRhxq2N rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8bp8hksk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 13:02:40 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FCW0W8017170;
        Tue, 15 Feb 2022 13:02:40 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8bp8hkrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 13:02:40 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FCwMBl002028;
        Tue, 15 Feb 2022 13:02:38 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3e64h9y8wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 13:02:38 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FCqFAL46596366
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 12:52:15 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45C4042049;
        Tue, 15 Feb 2022 13:02:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB3BF42041;
        Tue, 15 Feb 2022 13:02:35 +0000 (GMT)
Received: from [9.145.16.31] (unknown [9.145.16.31])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 13:02:35 +0000 (GMT)
Message-ID: <c85310ed-fd9c-fa8c-88d2-862b5d99dbbe@linux.ibm.com>
Date:   Tue, 15 Feb 2022 14:02:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net-next] net/smc: return ETIMEDOUT when smc_connect_clc()
 timeout
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1644913490-21594-1-git-send-email-alibuda@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1644913490-21594-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4Qutm9-5QDCrq8MqlzuCbcaYrrTPgqST
X-Proofpoint-GUID: 3n-cAycSnlxacnzO4oQuJnQdEN-gF_eo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2022 09:24, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> When smc_connect_clc() times out, it will return -EAGAIN(tcp_recvmsg
> retuns -EAGAIN while timeout), then this value will passed to the
> application, which is quite confusing to the applications, makes
> inconsistency with TCP.
> 
> From the manual of connect, ETIMEDOUT is more suitable, and this patch
> try convert EAGAIN to ETIMEDOUT in that case.

You say that the sock_recvmsg() in smc_clc_wait_msg() returns -EAGAIN?
Is there a reason why you translate it in __smc_connect() and not already in
smc_clc_wait_msg() after the call to sock_recvmsg()?
