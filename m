Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CF867E55C
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 13:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233910AbjA0Mfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 07:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbjA0Mfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 07:35:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BA274A45;
        Fri, 27 Jan 2023 04:35:23 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30RCCH08002914;
        Fri, 27 Jan 2023 12:35:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CUygpftfAY3MlvZJLjzKbejpfwPA9KzktpGl86IFHWU=;
 b=U+ZUjgiauh9kTLMsmaRI6ehBsjfy89Iaj7/ALfOW+BUeiUrXTbtpMGafJIzl2WvRlCfF
 V4YvffNyvZzQ/rNNZC1PZMIjzseASUVuvOjnpQR3XJkRItuje0OcThGZsMooK1dpB+fc
 slE6O77fmy+YyyqyrfNmN8etFGSzvaKlEEzH8fMmiCPxcI7wxbwfGA//Ne4WUwwfOU4m
 pIVdrAlrYQayhvuNFB1FuwuN6Rp92c/BHI5X7pf7DjgHjZdKqk9z3AtbAZ/lMQyzRipE
 jicq6bejJ1wm4Aq48tgzro9fSTD6mIXHTZV660glgM532N394auYcZhxQhHOs+kmmZOS EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ncedggjkk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 12:35:13 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30RCEtD4019163;
        Fri, 27 Jan 2023 12:35:12 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ncedggjjr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 12:35:12 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30RBCHbx025659;
        Fri, 27 Jan 2023 12:35:11 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([9.208.129.113])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3n87p82yc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Jan 2023 12:35:11 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30RCZ9lE29360574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 12:35:09 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 79D4D58064;
        Fri, 27 Jan 2023 12:35:09 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8762458056;
        Fri, 27 Jan 2023 12:35:07 +0000 (GMT)
Received: from [9.163.16.35] (unknown [9.163.16.35])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Jan 2023 12:35:07 +0000 (GMT)
Message-ID: <7b971e79-f301-e2fb-7cfe-1a3062ccc0f5@linux.ibm.com>
Date:   Fri, 27 Jan 2023 13:35:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 08/11] net: add missing includes of
 linux/splice.h
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        kgraul@linux.ibm.com, jaka@linux.ibm.com, kuniyu@amazon.com,
        linux-s390@vger.kernel.org
References: <20230126071424.1250056-1-kuba@kernel.org>
 <20230126071424.1250056-9-kuba@kernel.org>
From:   Wenjia Zhang <wenjia@linux.ibm.com>
In-Reply-To: <20230126071424.1250056-9-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ak_-mbGNVb6reh7k3HX1uk-bmHERRbz1
X-Proofpoint-ORIG-GUID: UiZQCUR1os64RIz04KWf5vDLqRAhg45P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_08,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270118
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 26.01.23 08:14, Jakub Kicinski wrote:
> Number of files depend on linux/splice.h getting included
> by linux/skbuff.h which soon will no longer be the case.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: kgraul@linux.ibm.com
> CC: wenjia@linux.ibm.com
> CC: jaka@linux.ibm.com
> CC: kuniyu@amazon.com
> CC: linux-s390@vger.kernel.org
> ---
>   net/smc/af_smc.c   | 1 +
>   net/smc/smc_rx.c   | 1 +
>   net/unix/af_unix.c | 1 +
>   3 files changed, 3 insertions(+)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 036532cf39aa..1c0fe9ba5358 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -27,6 +27,7 @@
>   #include <linux/if_vlan.h>
>   #include <linux/rcupdate_wait.h>
>   #include <linux/ctype.h>
> +#include <linux/splice.h>
>   
>   #include <net/sock.h>
>   #include <net/tcp.h>
> diff --git a/net/smc/smc_rx.c b/net/smc/smc_rx.c
> index 0a6e615f000c..4380d32f5a5f 100644
> --- a/net/smc/smc_rx.c
> +++ b/net/smc/smc_rx.c
> @@ -13,6 +13,7 @@
>   #include <linux/net.h>
>   #include <linux/rcupdate.h>
>   #include <linux/sched/signal.h>
> +#include <linux/splice.h>
>   

Thank you, Jakub!
Acked-by: Wenjia Zhang <wenjia@linux.ibm.com>

>   #include <net/sock.h>
>   #include <trace/events/sock.h>
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 009616fa0256..0be25e712c28 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -112,6 +112,7 @@
>   #include <linux/mount.h>
>   #include <net/checksum.h>
>   #include <linux/security.h>
> +#include <linux/splice.h>
>   #include <linux/freezer.h>
>   #include <linux/file.h>
>   #include <linux/btf_ids.h>


