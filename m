Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE51D3FD0C2
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241558AbhIABew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:34:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23242 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241332AbhIABev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:34:51 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1811WSA5063648
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:33:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=LJmLdQbntuq9ybd+QCFpUIkzz5cCnmpITpFZmbS32QA=;
 b=ZXG4qxJSF4V98WW1ndautmWbvFNvb2+M3uKqi63v6oIKJMU8A9ZDL8dbKWW358zSN6d2
 y+AVKwOQ/4KIZGEZD88vTQgM9+ROy+tapXDxG7dqX7yFAyKIFzb+YBFyLSczs/XzDXoj
 MxPwvKekJYkqgrTauAHf+6GYDb6EIUvvaPo76P5yA9MVVoCcvuvREhwLf6LNYPdBQuFr
 cJsDeD5D0WskqxxoqMmUL2EoOL9d6W18xlwi6GtignpWJhCJJW/eOKURUnJHAjetyPWX
 Fe37/3rTv3vFidZKrXKUKlQ/m5OUd2Z81MYHw2omGDjHXY4GHkAb+Ml0D5+sU9cp3x6x uw== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3asyfh0kme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:33:55 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1811ScmL028702
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 01:33:54 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3aqcsdkn3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:33:54 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1811XrDc38076904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 01:33:53 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94A1C12405B;
        Wed,  1 Sep 2021 01:33:53 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 40501124066;
        Wed,  1 Sep 2021 01:33:53 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 01:33:53 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Aug 2021 18:33:52 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 6/9] ibmvnic: Use bitmap for LTB map_ids
In-Reply-To: <20210901000812.120968-7-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
 <20210901000812.120968-7-sukadev@linux.ibm.com>
Message-ID: <7ca16990a95b30c2f6387e4b4cebda55@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cU15OnMFIuoS4c4JYYKSMgukeQE22UrB
X-Proofpoint-ORIG-GUID: cU15OnMFIuoS4c4JYYKSMgukeQE22UrB
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 priorityscore=1501 suspectscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 impostorscore=0 clxscore=1015 phishscore=0
 adultscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2109010007
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-31 17:08, Sukadev Bhattiprolu wrote:
> In a follow-on patch, we will reuse long term buffers when possible.
> When doing so we have to be careful to properly assign map ids. We
> can no longer assign them sequentially because a lower map id may be
> available and we could wrap at 255 and collide with an in-use map id.
> 
> Instead, use a bitmap to track active map ids and to find a free map 
> id.
> Don't need to take locks here since the map_id only changes during 
> reset
> and at that time only the reset worker thread should be using the 
> adapter.
> 
> Noticed this when analyzing an error Dany Madden ran into with the
> patch set.
> 
> Reported-by: Dany Madden <drt@linux.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 12 ++++++++----
>  drivers/net/ethernet/ibm/ibmvnic.h |  3 ++-
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 8894afdb3cb3..30153a8bb5ec 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -228,8 +228,9 @@ static int alloc_long_term_buff(struct
> ibmvnic_adapter *adapter,
>  		dev_err(dev, "Couldn't alloc long term buffer\n");
>  		return -ENOMEM;
>  	}
> -	ltb->map_id = adapter->map_id;
> -	adapter->map_id++;
> +	ltb->map_id = find_first_zero_bit(adapter->map_ids,
> +					  MAX_MAP_ID);
> +	bitmap_set(adapter->map_ids, ltb->map_id, 1);
> 
>  	mutex_lock(&adapter->fw_lock);
>  	adapter->fw_done_rc = 0;
> @@ -284,6 +285,8 @@ static void free_long_term_buff(struct
> ibmvnic_adapter *adapter,
>  	dma_free_coherent(dev, ltb->size, ltb->buff, ltb->addr);
> 
>  	ltb->buff = NULL;
> +	/* mark this map_id free */
> +	bitmap_clear(adapter->map_ids, ltb->map_id, 1);
>  	ltb->map_id = 0;
>  }
> 
> @@ -1231,8 +1234,6 @@ static int init_resources(struct ibmvnic_adapter 
> *adapter)
>  		return rc;
>  	}
> 
> -	adapter->map_id = 1;
> -
>  	rc = init_napi(adapter);
>  	if (rc)
>  		return rc;
> @@ -5553,6 +5554,9 @@ static int ibmvnic_probe(struct vio_dev *dev,
> const struct vio_device_id *id)
>  	adapter->vdev = dev;
>  	adapter->netdev = netdev;
>  	adapter->login_pending = false;
> +	memset(&adapter->map_ids, 0, sizeof(adapter->map_ids));
> +	/* map_ids start at 1, so ensure map_id 0 is always "in-use" */
> +	bitmap_set(adapter->map_ids, 0, 1);
> 
>  	ether_addr_copy(adapter->mac_addr, mac_addr_p);
>  	ether_addr_copy(netdev->dev_addr, adapter->mac_addr);
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h
> b/drivers/net/ethernet/ibm/ibmvnic.h
> index 5652566818fb..e97f1aa98c05 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -979,7 +979,8 @@ struct ibmvnic_adapter {
>  	u64 opt_tx_entries_per_subcrq;
>  	u64 opt_rxba_entries_per_subcrq;
>  	__be64 tx_rx_desc_req;
> -	u8 map_id;
> +#define MAX_MAP_ID	255
> +	DECLARE_BITMAP(map_ids, MAX_MAP_ID);
>  	u32 num_active_rx_scrqs;
>  	u32 num_active_rx_pools;
>  	u32 num_active_rx_napi;
