Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BF130AE1F
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbhBARk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:40:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231872AbhBARkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:40:12 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 111HWU28097813
        for <netdev@vger.kernel.org>; Mon, 1 Feb 2021 12:39:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=nYY2tANT/jUfH6pamZh5ixK126xYwjKi0JqBPDQyLMY=;
 b=DXKYAuMz8WKu8Tc/oFBmMbnKscpfKL23YwAFEcy6I5ae5ZB3hozme2N7Ra9wFygziS85
 1ClWHtnBhIIw+MIe627xVDW8hQBuHSwWTdbWb7v+04bH4KwesDAjP2b2uMyuFbQs2F8T
 ciMfONBLzXBlp/PiYqWlw03nkQzVKDstMQS5JDhMNZd1z8kuXGNtdCQf1CSOMbbeIIO0
 WBtSwLCqxJnPYIZuJ7Fa3rjKqRx8q4xxcB3adQEArxu9RiEG24Kh/eeFqubwN654XaJ+
 z/nB8ltLvBc4q/qamnCRIzn5o7ebaUWS93NUqczkdd5McGj+9OYNALVj3tWJyAyuoq/I fQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36emrgkgrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 12:39:32 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 111Hc6V8003639
        for <netdev@vger.kernel.org>; Mon, 1 Feb 2021 17:39:31 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 36cy38ra03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 17:39:31 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111HdTwB30736850
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 17:39:29 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B93B928059;
        Mon,  1 Feb 2021 17:39:29 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6969728058;
        Mon,  1 Feb 2021 17:39:29 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  1 Feb 2021 17:39:29 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 09:39:29 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com
Subject: Re: [PATCH net 1/2] ibmvnic: fix a race between open and reset
In-Reply-To: <20210129034711.518250-1-sukadev@linux.ibm.com>
References: <20210129034711.518250-1-sukadev@linux.ibm.com>
Message-ID: <eddd62ab4e7f2a91b5544df709ecc0d3@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_06:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 lowpriorityscore=0 mlxscore=0 malwarescore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102010087
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-28 19:47, Sukadev Bhattiprolu wrote:
> __ibmvnic_reset() currently reads the adapter->state before getting the
> rtnl and saves that state as the "target state" for the reset. If this
> read occurs when adapter is in PROBED state, the target state would be
> PROBED.
> 
> Just after the target state is saved, and before the actual reset 
> process
> is started (i.e before rtnl is acquired) if we get an ibmvnic_open() 
> call
> we would move the adapter to OPEN state.
> 
> But when the reset is processed (after ibmvnic_open()) drops the rtnl),
> it will leave the adapter in PROBED state even though we already moved
> it to OPEN.
> 
> To fix this, use the RTNL to improve the serialization when 
> reading/updating
> the adapter state. i.e determine the target state of a reset only after
> getting the RTNL. And if a reset is in progress during an open, simply
> set the target state of the adapter and let the reset code finish the
> open (like we currently do if failover is pending).
> 
> One twist to this serialization is if the adapter state changes when we
> drop the RTNL to update the link state. Account for this by checking if
> there was an intervening open and update the target state for the reset
> accordingly (see new comments in the code). Note that only the reset
> functions and ibmvnic_open() can set the adapter to OPEN state and this
> must happen under rtnl.
> 
> Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during
> device reset")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 72 +++++++++++++++++++++++++++---
>  1 file changed, 65 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 8820c98ea891..cb7ddfefb03e 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1197,12 +1197,26 @@ static int ibmvnic_open(struct net_device 
> *netdev)
>  	struct ibmvnic_adapter *adapter = netdev_priv(netdev);
>  	int rc;
> 
> -	/* If device failover is pending, just set device state and return.
> -	 * Device operation will be handled by reset routine.
> +	WARN_ON_ONCE(!rtnl_is_locked());
> +
> +	/**
> +	 * If device failover is pending or we are about to reset, just set
> +	 * device state and return. Device operation will be handled by reset
> +	 * routine.
> +	 *
> +	 * It should be safe to overwrite the adapter->state here. Since
> +	 * we hold the rtnl, either the reset has not actually started or
> +	 * the rtnl got dropped during the set_link_state() in do_reset().
> +	 * In the former case, no one else is changing the state (again we
> +	 * have the rtnl) and in the latter case, do_reset() will detect and
> +	 * honor our setting below.
>  	 */
> -	if (adapter->failover_pending) {
> +	if (adapter->failover_pending || (test_bit(0, &adapter->resetting))) 
> {
> +		netdev_dbg(netdev, "[S:%d FOP:%d] Resetting, deferring open\n",
> +			   adapter->state, adapter->failover_pending);
>  		adapter->state = VNIC_OPEN;
> -		return 0;
> +		rc = 0;
> +		goto out;
>  	}
> 
>  	if (adapter->state != VNIC_CLOSED) {
> @@ -1222,10 +1236,12 @@ static int ibmvnic_open(struct net_device 
> *netdev)
> 
>  out:
>  	/*
> -	 * If open fails due to a pending failover, set device state and
> -	 * return. Device operation will be handled by reset routine.
> +	 * If open failed and there is a pending failover or in-progress 
> reset,
> +	 * set device state and return. Device operation will be handled by
> +	 * reset routine. See also comments above regarding rtnl.
>  	 */
> -	if (rc && adapter->failover_pending) {
> +	if (rc &&
> +	    (adapter->failover_pending || (test_bit(0, 
> &adapter->resetting)))) {
>  		adapter->state = VNIC_OPEN;
>  		rc = 0;
>  	}
> @@ -1939,6 +1955,14 @@ static int do_change_param_reset(struct
> ibmvnic_adapter *adapter,
>  	netdev_dbg(adapter->netdev, "Change param resetting driver (%d)\n",
>  		   rwi->reset_reason);
> 
> +	/* read the state and check (again) after getting rtnl */
> +	reset_state = adapter->state;
> +
> +	if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
> +		rc = -EBUSY;
> +		goto out;
> +	}
> +
>  	netif_carrier_off(netdev);
>  	adapter->reset_reason = rwi->reset_reason;
> 
> @@ -2037,6 +2061,14 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  	if (rwi->reset_reason == VNIC_RESET_FAILOVER)
>  		adapter->failover_pending = false;
> 
> +	/* read the state and check (again) after getting rtnl */
> +	reset_state = adapter->state;
> +
> +	if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
> +		rc = -EBUSY;
> +		goto out;
> +	}
> +
>  	netif_carrier_off(netdev);
>  	adapter->reset_reason = rwi->reset_reason;
> 
> @@ -2063,7 +2095,25 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  		if (rc)
>  			goto out;
> 
> +		if (adapter->state == VNIC_OPEN) {
> +			/**
> +			 * When we dropped rtnl, ibmvnic_open() got it and
> +			 * noticed that we are resetting and set the adapter
> +			 * state to OPEN. Update our new "target" state,
> +			 * and resume the reset from VNIC_CLOSING state.
> +			 */
> +			netdev_dbg(netdev,
> +				   "Open changed state from %d, updating.\n",
> +				    reset_state);
> +			reset_state = VNIC_OPEN;
> +			adapter->state = VNIC_CLOSING;
> +		}
> +
>  		if (adapter->state != VNIC_CLOSING) {
> +			/**
> +			 * If someone else changed the adapter state
> +			 * when we dropped the rtnl, fail the reset
> +			 */
>  			rc = -1;
>  			goto out;
>  		}
> @@ -2197,6 +2247,14 @@ static int do_hard_reset(struct ibmvnic_adapter 
> *adapter,
>  	netdev_dbg(adapter->netdev, "Hard resetting driver (%d)\n",
>  		   rwi->reset_reason);
> 
> +	/* read the state and check (again) after getting rtnl */
> +	reset_state = adapter->state;
> +
> +	if (reset_state == VNIC_REMOVING || reset_state == VNIC_REMOVED) {
> +		rc = -EBUSY;
> +		goto out;
> +	}
> +
>  	netif_carrier_off(netdev);
>  	adapter->reset_reason = rwi->reset_reason;
