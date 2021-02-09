Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C54314A43
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhBII2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:28:02 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1788 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229671AbhBII12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:27:28 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11982TQg120319;
        Tue, 9 Feb 2021 03:26:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=sv3C7wF3oZoO7KAFaHZNqG/h7UkOmmw6GYJ5ZuzJXno=;
 b=HqW2R8hsOsMqdFDXa6GOdUCAPPJOC0lP3uIgwtdn2QZbKKWpd0fFsHKhq26ZyBweTGtX
 kY9u5ZWrxpX2ocHRvzDNCtoGFxetfwmBaOOGLM96xlB4xZOfFH5qQx9XQ2ttGhvn61ga
 3U7Gt+ETaRN7rNx+SPp1hq9KxvTsMNTty4qpj5jECoUqqP87pFQTXE1qzmMl4Bf24yKK
 GZEvG3qWoyxlVmBeftwEG8TRqb7mplrUb/dhYQyAH/mM9FehwCcqOvGTEfXfGbG0jrsK
 wfjXXVpNkbO4OKs/GXgJAgy8jeFFHl4AapW4KcQEwhj1xnHRqEO2U64onfLNjacWIMvF 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36knx0sk12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 03:26:31 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11982sYB122374;
        Tue, 9 Feb 2021 03:26:31 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36knx0sk0n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 03:26:31 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1198MaQB016670;
        Tue, 9 Feb 2021 08:26:29 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 36j94wj79v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 08:26:29 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1198QQnm41091386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Feb 2021 08:26:26 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB46DA4066;
        Tue,  9 Feb 2021 08:26:26 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46E93A405B;
        Tue,  9 Feb 2021 08:26:26 +0000 (GMT)
Received: from [9.145.24.142] (unknown [9.145.24.142])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Feb 2021 08:26:26 +0000 (GMT)
Subject: Re: [PATCH net-next 8/8] mld: change context of mld module
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, dsahern@kernel.org,
        xiyou.wangcong@gmail.com, kgraul@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, yoshfuji@linux-ipv6.org
References: <20210208175952.5880-1-ap420073@gmail.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <ed1965e9-f35b-ec9b-f3ae-20a7adba956d@linux.ibm.com>
Date:   Tue, 9 Feb 2021 09:26:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210208175952.5880-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_02:2021-02-08,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 malwarescore=0 suspectscore=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090036
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.02.21 18:59, Taehee Yoo wrote:
> MLD module's context is atomic although most logic is called from
> control-path, not data path. Only a few functions are called from
> datapath, most of the functions are called from the control-path.
> Furthermore, MLD's response is not processed immediately because
> MLD protocol is using delayed response.
> It means that If a query is received, the node should have a delay
> in response At this point, it could change the context.
> It means most of the functions can be implemented as the sleepable
> context so that mld functions can use sleepable functions.
> 
> Most resources are protected by spinlock and rwlock so the context
> of mld functions is atomic. So, in order to change context, locking
> scenario should be changed.
> It switches from spinlock/rwlock to mutex and rcu.
> 
> Some locks are deleted and added.
> 1. ipv6->mc_socklist->sflock is deleted
> This is rwlock and it is unnecessary.
> Because it protects ipv6_mc_socklist-sflist but it is now protected
> by rtnl_lock().
> 
> 2. ifmcaddr6->mca_work_lock is added.
> This lock protects ifmcaddr6->mca_work.
> This workqueue can be used by both control-path and data-path.
> It means mutex can't be used.
> So mca_work_lock(spinlock) is added.
> 
> 3. inet6_dev->mc_tomb_lock is deleted
> This lock protects inet6_dev->mc_bom_list.
> But it is protected by rtnl_lock().
> 
> 4. inet6_dev->lock is used for protecting workqueues.
> inet6_dev has its own workqueues(mc_gq_work, mc_ifc_work, mc_delrec_work)
> and it can be started and stop by both control-path and data-path.
> So, mutex can't be used.
> 
> Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  drivers/s390/net/qeth_l3_main.c |   6 +-
>  include/net/if_inet6.h          |  29 +-
>  net/batman-adv/multicast.c      |   4 +-
>  net/ipv6/addrconf.c             |   4 +-
>  net/ipv6/mcast.c                | 785 ++++++++++++++++----------------
>  5 files changed, 411 insertions(+), 417 deletions(-)
> 
> diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
> index e49abdeff69c..085afb24482e 100644
> --- a/drivers/s390/net/qeth_l3_main.c
> +++ b/drivers/s390/net/qeth_l3_main.c
> @@ -1098,8 +1098,8 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
>  	tmp.disp_flag = QETH_DISP_ADDR_ADD;
>  	tmp.is_multicast = 1;
>  
> -	read_lock_bh(&in6_dev->lock);
> -	list_for_each_entry(im6, in6_dev->mc_list, list) {
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(im6, in6_dev->mc_list, list) {

No need for the rcu_read_lock(), we're called under rtnl.
So if there's a v2, please just make this

	list_for_each_entry_rcu(im6, in6_dev->mc_list, list,
				lockdep_rtnl_is_held())

>  		tmp.u.a6.addr = im6->mca_addr;
>  
>  		ipm = qeth_l3_find_addr_by_ip(card, &tmp);
> @@ -1117,7 +1117,7 @@ static int qeth_l3_add_mcast_rtnl(struct net_device *dev, int vid, void *arg)
>  			 qeth_l3_ipaddr_hash(ipm));
>  
>  	}
> -	read_unlock_bh(&in6_dev->lock);
> +	rcu_read_unlock();
>  
>  out:
>  	return 0;


