Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 625E63D0899
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 08:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbhGUFZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 01:25:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233167AbhGUFZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 01:25:20 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16L63SoA052214;
        Wed, 21 Jul 2021 02:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=FjdZBfMp0ZIfjDi71zgzEcY5ZulQp++qwteT5R4B/oU=;
 b=f3eo8c66IycGmpF6xAFrJE/KwvGkwOSxKsFuuBxdMGWP/M3M0nYK5NFeeY9J8PGjIoeX
 irIer9LMYAk//X7o+P/BNGul5SlhVemrvfPMYZXA3Rfto25j/Li0e7T+H39Qdcv3Z9p0
 Sxas0Deq2MCiek1gvyJ5s05RHK03Pd5t9RRhXc+1an0l4c+/fgSkV8Q7kM5znd1eKqQ8
 ZcTNzepcHk6uMoM/wKu6A/u5WowE0T8cUr2wtPN/FxxfU3Cob0+NLvQDYywqqZ6yZJ4H
 Q32TYiotKwpNyXiPL4rLiVY7SqO9O68O3ECe8gjE/C197VkNUk2pounALSieUbfL+iwp IA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39xdbc8vn9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jul 2021 02:05:48 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16L63I5l026526;
        Wed, 21 Jul 2021 06:05:46 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 39upfh90qa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jul 2021 06:05:46 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16L65iO320644162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 06:05:44 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29F9452054;
        Wed, 21 Jul 2021 06:05:44 +0000 (GMT)
Received: from [9.145.54.186] (unknown [9.145.54.186])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 876BE5204E;
        Wed, 21 Jul 2021 06:05:43 +0000 (GMT)
Subject: Re: [PATCH net-next v2 16/31] qeth: use ndo_siocdevprivate
To:     Arnd Bergmann <arnd@kernel.org>, netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
 <20210720144638.2859828-17-arnd@kernel.org>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <ef625966-9ff3-5daf-889b-232e420d9e65@linux.ibm.com>
Date:   Wed, 21 Jul 2021 09:05:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210720144638.2859828-17-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tD72lntOvXh-7LCdIYB_CmmdYwUkKGGK
X-Proofpoint-GUID: tD72lntOvXh-7LCdIYB_CmmdYwUkKGGK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-21_04:2021-07-21,2021-07-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 suspectscore=0 phishscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107210027
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.07.21 17:46, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> qeth has both standard MII ioctls and custom SIOCDEVPRIVATE ones,
> all of which work correctly with compat user space.
> 
> Move the private ones over to the new ndo_siocdevprivate callback.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

your get_maintainers scripting seems broken, adding the usual suspects.

>  drivers/s390/net/qeth_core.h      |  5 ++++-
>  drivers/s390/net/qeth_core_main.c | 35 ++++++++++++++++++++++---------
>  drivers/s390/net/qeth_l3_main.c   |  6 +++---
>  3 files changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
> index f4d554ea0c93..89fd7432dbec 100644
> --- a/drivers/s390/net/qeth_core.h
> +++ b/drivers/s390/net/qeth_core.h
> @@ -790,7 +790,8 @@ struct qeth_discipline {
>  	void (*remove) (struct ccwgroup_device *);
>  	int (*set_online)(struct qeth_card *card, bool carrier_ok);
>  	void (*set_offline)(struct qeth_card *card);
> -	int (*do_ioctl)(struct net_device *dev, struct ifreq *rq, int cmd);
> +	int (*do_ioctl)(struct net_device *dev, struct ifreq *rq,
> +			void __user *data, int cmd);
>  	int (*control_event_handler)(struct qeth_card *card,
>  					struct qeth_ipa_cmd *cmd);
>  };
> @@ -1124,6 +1125,8 @@ int qeth_do_send_packet(struct qeth_card *card, struct qeth_qdio_out_q *queue,
>  			unsigned int offset, unsigned int hd_len,
>  			int elements_needed);
>  int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
> +int qeth_siocdevprivate(struct net_device *dev, struct ifreq *rq,
> +			void __user *data, int cmd);
>  void qeth_dbf_longtext(debug_info_t *id, int level, char *text, ...);
>  int qeth_configure_cq(struct qeth_card *, enum qeth_cq);
>  int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
> diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
> index 62f88ccbd03f..be19cfd05136 100644
> --- a/drivers/s390/net/qeth_core_main.c
> +++ b/drivers/s390/net/qeth_core_main.c
> @@ -6672,21 +6672,42 @@ struct qeth_card *qeth_get_card_by_busid(char *bus_id)
>  }
>  EXPORT_SYMBOL_GPL(qeth_get_card_by_busid);
>  
> -int qeth_do_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
> +int qeth_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *data, int cmd)
>  {
>  	struct qeth_card *card = dev->ml_priv;
> -	struct mii_ioctl_data *mii_data;
>  	int rc = 0;
>  
>  	switch (cmd) {
>  	case SIOC_QETH_ADP_SET_SNMP_CONTROL:
> -		rc = qeth_snmp_command(card, rq->ifr_ifru.ifru_data);
> +		rc = qeth_snmp_command(card, data);
>  		break;
>  	case SIOC_QETH_GET_CARD_TYPE:
>  		if ((IS_OSD(card) || IS_OSM(card) || IS_OSX(card)) &&
>  		    !IS_VM_NIC(card))
>  			return 1;
>  		return 0;
> +	case SIOC_QETH_QUERY_OAT:
> +		rc = qeth_query_oat_command(card, data);
> +		break;
> +	default:
> +		if (card->discipline->do_ioctl)
> +			rc = card->discipline->do_ioctl(dev, rq, data, cmd);
> +		else
> +			rc = -EOPNOTSUPP;
> +	}
> +	if (rc)
> +		QETH_CARD_TEXT_(card, 2, "ioce%x", rc);
> +	return rc;
> +}
> +EXPORT_SYMBOL_GPL(qeth_siocdevprivate);
> +

Looks like you missed to wire this up in our netdev_ops structs.
