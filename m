Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDE148988B
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 13:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245431AbiAJM0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 07:26:01 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42242 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235973AbiAJMZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 07:25:57 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AAclNv005407;
        Mon, 10 Jan 2022 12:25:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PkvwHo51xgja/KUsAWlUBaTVsqGisgEduBZgUc75HO4=;
 b=mcFe1Ga0Fl1tRrCEwuepYy7E509imE1nuWm6i377HPLLtZLtdbbPxcCaYxjsu5hc55B+
 IR+aUNQS/zEUHNBE99gfXIxyIOmKrCrbCuczLTvChqXzLDUxnibBxIpZBJnZtfrOa4i9
 TeZAvc5RGrj1B1IOrH4tRh3eKsE16u3aFFjtaJqAiP9EiBASbbDCA5vBMpwxEi0VQidW
 HQrybPXBn/VlTRXcHbiWNrmIc79ry2clYrBKE9330EAcBB7jZg7cySTcjAWTWiiifLxv
 Lrh0LemCmbZVnxX3jW1+NjSXFsSZJtP+HbwILqrqdtw6njgrGI8AozRH9tUz4RCxZmT4 Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dfm1hsgsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 12:25:53 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20AAqELP018450;
        Mon, 10 Jan 2022 12:25:53 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dfm1hsgs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 12:25:53 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20ACC71M016309;
        Mon, 10 Jan 2022 12:25:51 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3df2893pcp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 12:25:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20ACPnSS44499208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 12:25:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 549C952059;
        Mon, 10 Jan 2022 12:25:49 +0000 (GMT)
Received: from [9.145.184.190] (unknown [9.145.184.190])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 02DFB5204F;
        Mon, 10 Jan 2022 12:25:48 +0000 (GMT)
Message-ID: <3525a4cd-1bc7-1008-910b-fb89597cc10a@linux.ibm.com>
Date:   Mon, 10 Jan 2022 13:25:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net 1/3] net/smc: Resolve the race between link group
 access and termination
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641806784-93141-1-git-send-email-guwen@linux.alibaba.com>
 <1641806784-93141-2-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1641806784-93141-2-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ipg6Qz8vft_IlIzO3S9Wu1lENxcquCCK
X-Proofpoint-ORIG-GUID: ZEkORhwhtGooLgfkp1OZdAuxrfJPzVOI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_05,2022-01-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 adultscore=0 spamscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201100085
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2022 10:26, Wen Gu wrote:
> We encountered some crashes caused by the race between the access
> and the termination of link groups.
> 
<snip>
> 
> diff --git a/net/smc/smc.h b/net/smc/smc.h
> index 1a4fc1c..3d0b8e3 100644
> --- a/net/smc/smc.h
> +++ b/net/smc/smc.h
> @@ -221,6 +221,7 @@ struct smc_connection {
>  						 */
>  	u64			peer_token;	/* SMC-D token of peer */
>  	u8			killed : 1;	/* abnormal termination */
> +	u8			freed : 1;	/* normal termiation */
>  	u8			out_of_sync : 1; /* out of sync with peer */
>  };
>  
> diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
> index cd3c3b8..26a113d 100644
> --- a/net/smc/smc_core.c
> +++ b/net/smc/smc_core.c
> @@ -186,6 +186,7 @@ static int smc_lgr_register_conn(struct smc_connection *conn, bool first)
>  			conn->alert_token_local = 0;
>  	}
>  	smc_lgr_add_alert_token(conn);
> +	smc_lgr_hold(conn->lgr); /* lgr_put in smc_conn_free() */
>  	conn->lgr->conns_num++;
>  	return 0;
>  }
> @@ -218,7 +219,6 @@ static void smc_lgr_unregister_conn(struct smc_connection *conn)
>  		__smc_lgr_unregister_conn(conn);
>  	}
>  	write_unlock_bh(&lgr->conns_lock);
> -	conn->lgr = NULL;
>  }
>  
>  int smc_nl_get_sys_info(struct sk_buff *skb, struct netlink_callback *cb)
> @@ -749,6 +749,7 @@ int smcr_link_init(struct smc_link_group *lgr, struct smc_link *lnk,
>  	lnk->path_mtu = lnk->smcibdev->pattr[lnk->ibport - 1].active_mtu;
>  	lnk->link_id = smcr_next_link_id(lgr);
>  	lnk->lgr = lgr;
> +	smc_lgr_hold(lgr); /* lgr_put in smcr_link_clear() */
>  	lnk->link_idx = link_idx;
>  	smc_ibdev_cnt_inc(lnk);
>  	smcr_copy_dev_info_to_link(lnk);
> @@ -841,6 +842,7 @@ static int smc_lgr_create(struct smc_sock *smc, struct smc_init_info *ini)
>  	lgr->terminating = 0;
>  	lgr->freeing = 0;
>  	lgr->vlan_id = ini->vlan_id;
> +	refcount_set(&lgr->refcnt, 1); /* set lgr refcnt to 1 */
>  	mutex_init(&lgr->sndbufs_lock);
>  	mutex_init(&lgr->rmbs_lock);
>  	rwlock_init(&lgr->conns_lock);
> @@ -1120,8 +1122,22 @@ void smc_conn_free(struct smc_connection *conn)
>  {
>  	struct smc_link_group *lgr = conn->lgr;
>  
> -	if (!lgr)
> +	if (!lgr || conn->freed)
> +		/* The connection has never been registered in a
> +		 * link group, or has already been freed.
> +		 *
> +		 * Check to ensure that the refcnt of link group
> +		 * won't be put incorrectly.

I would delete the second sentence here, its obvious enough.

> +		 */
>  		return;
> +
> +	conn->freed = 1;
> +	if (!conn->alert_token_local)
> +		/* The connection was registered in a link group
> +		 * defore, but now it is unregistered from it.

'before' ... But would maybe the following be more exact:

'Connection already unregistered from link group.'


We still review the patches...

> +		 */
> +		goto lgr_put;
> +
>  	if (lgr->is_smcd) {
>  		if (!list_empty(&lgr->list))
>  			smc_ism_unset_conn(conn);
> @@ -1138,6 +1154,8 @@ void smc_conn_free(struct smc_connection *conn)
>  
>  	if (!lgr->conns_num)
>  		smc_lgr_schedule_free_work(lgr);
> +lgr_put:
> +	smc_lgr_put(lgr); /* lgr_hold in smc_lgr_register_conn() */
>  }
>  
>  /* unregister a link from a buf_desc */
> @@ -1209,6 +1227,7 @@ void smcr_link_clear(struct smc_link *lnk, bool log)
>  	smc_ib_destroy_queue_pair(lnk);
>  	smc_ib_dealloc_protection_domain(lnk);
>  	smc_wr_free_link_mem(lnk);
> +	smc_lgr_put(lnk->lgr); /* lgr_hold in smcr_link_init() */
>  	smc_ibdev_cnt_dec(lnk);
>  	put_device(&lnk->smcibdev->ibdev->dev);
>  	smcibdev = lnk->smcibdev;
> @@ -1283,6 +1302,15 @@ static void smc_lgr_free_bufs(struct smc_link_group *lgr)
>  	__smc_lgr_free_bufs(lgr, true);
>  }
>  
> +/* won't be freed until no one accesses to lgr anymore */
> +static void __smc_lgr_free(struct smc_link_group *lgr)
> +{
> +	smc_lgr_free_bufs(lgr);
> +	if (!lgr->is_smcd)
> +		smc_wr_free_lgr_mem(lgr);
> +	kfree(lgr);
> +}
> +
>  /* remove a link group */
>  static void smc_lgr_free(struct smc_link_group *lgr)
>  {
> @@ -1298,7 +1326,6 @@ static void smc_lgr_free(struct smc_link_group *lgr)
>  		smc_llc_lgr_clear(lgr);
>  	}
>  
> -	smc_lgr_free_bufs(lgr);
>  	destroy_workqueue(lgr->tx_wq);
>  	if (lgr->is_smcd) {
>  		smc_ism_put_vlan(lgr->smcd, lgr->vlan_id);
> @@ -1306,11 +1333,21 @@ static void smc_lgr_free(struct smc_link_group *lgr)
>  		if (!atomic_dec_return(&lgr->smcd->lgr_cnt))
>  			wake_up(&lgr->smcd->lgrs_deleted);
>  	} else {
> -		smc_wr_free_lgr_mem(lgr);
>  		if (!atomic_dec_return(&lgr_cnt))
>  			wake_up(&lgrs_deleted);
>  	}
> -	kfree(lgr);
> +	smc_lgr_put(lgr); /* theoretically last lgr_put */
> +}
> +
> +void smc_lgr_hold(struct smc_link_group *lgr)
> +{
> +	refcount_inc(&lgr->refcnt);
> +}
> +
> +void smc_lgr_put(struct smc_link_group *lgr)
> +{
> +	if (refcount_dec_and_test(&lgr->refcnt))
> +		__smc_lgr_free(lgr);
>  }
>  
>  static void smc_sk_wake_ups(struct smc_sock *smc)
> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
> index 73d0c35..edbd401 100644
> --- a/net/smc/smc_core.h
> +++ b/net/smc/smc_core.h
> @@ -249,6 +249,7 @@ struct smc_link_group {
>  	u8			terminating : 1;/* lgr is terminating */
>  	u8			freeing : 1;	/* lgr is being freed */
>  
> +	refcount_t		refcnt;		/* lgr reference count */
>  	bool			is_smcd;	/* SMC-R or SMC-D */
>  	u8			smc_version;
>  	u8			negotiated_eid[SMC_MAX_EID_LEN];
> @@ -470,6 +471,8 @@ static inline void smc_set_pci_values(struct pci_dev *pci_dev,
>  
>  void smc_lgr_cleanup_early(struct smc_link_group *lgr);
>  void smc_lgr_terminate_sched(struct smc_link_group *lgr);
> +void smc_lgr_hold(struct smc_link_group *lgr);
> +void smc_lgr_put(struct smc_link_group *lgr);
>  void smcr_port_add(struct smc_ib_device *smcibdev, u8 ibport);
>  void smcr_port_err(struct smc_ib_device *smcibdev, u8 ibport);
>  void smc_smcd_terminate(struct smcd_dev *dev, u64 peer_gid,

-- 
Karsten
