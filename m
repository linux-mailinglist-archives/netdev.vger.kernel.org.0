Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0065957E0
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbiHPKRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiHPKQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:16:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD64B17A99;
        Tue, 16 Aug 2022 02:36:48 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27G9USWx021747;
        Tue, 16 Aug 2022 09:35:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=nCJHr1acNLMLVG9QC3Uc/OZmUsg9vYgpJuYgh6L0TMI=;
 b=RuhkAMjodgEZugZKEoL6Bh8hnbsidX4cNDdqJQofcEecF2N1knuc3+KDIuLKsQCJRDrx
 fGKdAJlH9J5F4ys+G6R0cbQWv2WmM+LQWcFI1J4AGzA45y83Io1CWuoyqkRjNTI6whWw
 jQggp9VB9oNJHyYAOm9CQoM53hwS+u8AAv9frWCwBjHGQBM8V8/0jLW0uj4U4debE33f
 vU7cX+Ut+O+I5Mm/3xfgXpi4yFC2WvKm4sOIybAC4QXRi2GpJcos0oFvJgc8Uw3TelVl
 e01E4bnekv9jcV2u7orKtqzEKm0NKwnK2wwkQUwsH6abGeQhJjaTSFJv/ZztjUbbAdy5 cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j08nkg3fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 09:35:23 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27G9VZRG029016;
        Tue, 16 Aug 2022 09:35:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j08nkg3ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 09:35:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27G9KgG2022415;
        Tue, 16 Aug 2022 09:35:20 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3hx3k9b09k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Aug 2022 09:35:20 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27G9ZHwm25297306
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Aug 2022 09:35:17 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51DA9AE061;
        Tue, 16 Aug 2022 09:35:17 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 93E3AAE05A;
        Tue, 16 Aug 2022 09:35:16 +0000 (GMT)
Received: from [9.171.58.165] (unknown [9.171.58.165])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 16 Aug 2022 09:35:16 +0000 (GMT)
Message-ID: <2182efbc-99f8-17ba-d344-95a467536b05@linux.ibm.com>
Date:   Tue, 16 Aug 2022 11:35:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH net-next 00/10] net/smc: optimize the parallelism of SMC-R
 connections
Content-Language: en-US
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <cover.1660152975.git.alibuda@linux.alibaba.com>
From:   Jan Karcher <jaka@linux.ibm.com>
In-Reply-To: <cover.1660152975.git.alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VG2nuOpx713STu1xwibBw5GqTQeovTSb
X-Proofpoint-ORIG-GUID: L3hK5E3pxDKeGVmdL1ebOmL1e8BPYD5z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-16_07,2022-08-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208160037
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10.08.2022 19:47, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> This patch set attempts to optimize the parallelism of SMC-R connections,
> mainly to reduce unnecessary blocking on locks, and to fix exceptions that
> occur after thoses optimization.
>

Thank you again for your submission!
Let me give you a quick update from our side:
We tested your patches on top of the net-next kernel on our s390 
systems. They did crash our systems. After verifying our environment we 
pulled console logs and now we can tell that there is indeed a problem 
with your patches regarding SMC-D. So please do not integrate this 
change as of right now. I'm going to do more in depth reviews of your 
patches but i need some time for them so here is a quick a description 
of the problem:

It is a SMC-D problem, that occurs while building up the connection. In 
smc_conn_create you set struct smc_lnk_cluster *lnkc = NULL. For the 
SMC-R path you do grab the pointer, for SMC-D that never happens. Still 
you are using this refernce for SMC-D => Crash. This problem can be 
reproduced using the SMC-D path. Here is an example console output:

[  779.516382] Unable to handle kernel pointer dereference in virtual 
kernel address space
[  779.516389] Failing address: 0000000000000000 TEID: 0000000000000483
[  779.516391] Fault in home space mode while using kernel ASCE.
[  779.516395] AS:0000000069628007 R3:00000000ffbf0007 
S:00000000ffbef800 P:000000000000003d
[  779.516431] Oops: 0004 ilc:2 [#1] SMP
[  779.516436] Modules linked in: tcp_diag inet_diag ism mlx5_ib 
ib_uverbs mlx5_core smc_diag smc ib_core nft_fib_inet nft_fib_ipv4
nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 
nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv
6 nf_defrag_ipv4 ip_set nf_tables n
[  779.516470] CPU: 0 PID: 24 Comm: kworker/0:1 Not tainted 
5.19.0-13940-g22a46254655a #3
[  779.516476] Hardware name: IBM 8561 T01 701 (z/VM 7.2.0)

[  779.522738] Workqueue: smc_hs_wq smc_listen_work [smc]
[  779.522755] Krnl PSW : 0704c00180000000 000003ff803da89c 
(smc_conn_create+0x174/0x968 [smc])
[  779.522766]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 
PM:0 RI:0 EA:3
[  779.522770] Krnl GPRS: 0000000000000002 0000000000000000 
0000000000000001 0000000000000000
[  779.522773]            000000008a4128a0 000003ff803f21aa 
000000008e30d640 0000000086d72000
[  779.522776]            0000000086d72000 000000008a412803 
000000008a412800 000000008e30d650
[  779.522779]            0000000080934200 0000000000000000 
000003ff803cb954 00000380002dfa88
[  779.522789] Krnl Code: 000003ff803da88e: e310f0e80024        stg 
%r1,232(%r15)
[  779.522789]            000003ff803da894: a7180000            lhi 
%r1,0
[  779.522789]           #000003ff803da898: 582003ac            l 
%r2,940
[  779.522789]           >000003ff803da89c: ba123020            cs 
%r1,%r2,32(%r3)
[  779.522789]            000003ff803da8a0: ec1603be007e        cij 
%r1,0,6,000003ff803db01c

[  779.522789]            000003ff803da8a6: 4110b002            la 
%r1,2(%r11)
[  779.522789]            000003ff803da8aa: e310f0f00024        stg 
%r1,240(%r15)
[  779.522789]            000003ff803da8b0: e310f0c00004        lg 
%r1,192(%r15)
[  779.522870] Call Trace:
[  779.522873]  [<000003ff803da89c>] smc_conn_create+0x174/0x968 [smc]
[  779.522884]  [<000003ff803cb954>] 
smc_find_ism_v2_device_serv+0x1b4/0x300 [smc]
01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP 
stop from CPU 01.
01: HCPGSP2629I The virtual machine is placed in CP mode due to a SIGP 
stop from CPU 00.
[  779.522894]  [<000003ff803cbace>] smc_listen_find_device+0x2e/0x370 [smc]


I'm going to send the review for the first patch right away (which is 
the one causing the crash), so far I'm done with it. The others are 
going to follow. Maybe you can look over the problem and come up with a 
solution, otherwise we are going to decide if we want to look into it as 
soon as I'm done with the reviews. Thank you for your patience.
