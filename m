Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61051364C38
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240972AbhDSUtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:49:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241075AbhDSUrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 16:47:17 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13JKWgVn105154
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 16:46:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=GHupeA9mDQhFjgWSw+UF8JINLN85rKKWuztsTeXqxSM=;
 b=XvttRuKnhP+bD3GUHHy9qzM13nexWTRFjl1yAkBU8ye5IztP02rBj7uiuunTOIyb7X7m
 2uQr89aLrCbfFhk8SfaachgTz1AKL6W4wxb0K03rQ2Sq0+Dol+UTRDJ7iksC/G5tEDaE
 9SIXMMQIgNhda5MYEarHaytO3YrtYms5pfZ60VYUCZd9lPRpyr3H2A378rCyaEUAC4b/
 ofegdtwXgi/hun12pyO3Wn91LfsnauaxVk50KghQqSpdjDENl5D0LNZwOpXGgHsBPSPE
 +q1rsAMxlWz2K5oCpiFibDQ3DYrQ2LrPEgfsK4G5rbHNGhrPg6wQKjN4vlyhHvSakSL+ PQ== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 380crtegw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 16:46:43 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13JKkPEi013168
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 20:46:42 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04wdc.us.ibm.com with ESMTP id 3813tad8kr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 19 Apr 2021 20:46:42 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13JKkfFQ26214764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Apr 2021 20:46:41 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F097BE04F;
        Mon, 19 Apr 2021 20:46:41 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 285D4BE054;
        Mon, 19 Apr 2021 20:46:41 +0000 (GMT)
Received: from Criss-MBP.lan (unknown [9.80.230.53])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon, 19 Apr 2021 20:46:40 +0000 (GMT)
From:   Cris Forno <cforno12@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>
Subject: Re: [PATCH net] ibmvnic: Allow device probe if the device is not
 ready at boot
In-Reply-To: <20210419172752.57089-1-cforno12@linux.ibm.com>
References: <20210419172752.57089-1-cforno12@linux.ibm.com>
Date:   Mon, 19 Apr 2021 15:46:39 -0500
Message-ID: <m2sg3mc89c.fsf@Criss-MBP.lan>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dAH-5ZyfP8s3jVsWujC1sw8dKzYgp3bD
X-Proofpoint-ORIG-GUID: dAH-5ZyfP8s3jVsWujC1sw8dKzYgp3bD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-19_11:2021-04-19,2021-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 priorityscore=1501 phishscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104190141
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cristobal Forno <cforno12@linux.ibm.com> writes:
> This patch will allow the device to be initialized at a later time if
> it is not available at boot. The device will be allowed to probe but
> will be given a "down" state. After completing device probe and
> registering the net device, the driver will await an interrupt signal
> from its partner device, indicating that it is ready for boot. The
> driver will schedule a work event to perform the necessary procedure
> and begin operation.
>
> Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>
> Co-developed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 145 ++++++++++++++++++++++++-----
>  drivers/net/ethernet/ibm/ibmvnic.h |   6 +-
>  2 files changed, 128 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index ffb2a91750c7..64798e1f429d 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -141,6 +141,30 @@ static const struct ibmvnic_stat ibmvnic_stats[] = {
>  	{"internal_mac_rx_errors", IBMVNIC_STAT_OFF(internal_mac_rx_errors)},
>  };
>  
> +static int send_crq_init_complete(struct ibmvnic_adapter *adapter)
> +{
> +	union ibmvnic_crq crq;
> +
> +	memset(&crq, 0, sizeof(crq));
> +	crq.generic.first = IBMVNIC_CRQ_INIT_CMD;
> +	crq.generic.cmd = IBMVNIC_CRQ_INIT_COMPLETE;
> +	netdev_dbg(adapter->netdev, "Sending CRQ init complete\n");
> +
> +	return ibmvnic_send_crq(adapter, &crq);
> +}
> +
> +static int send_version_xchg(struct ibmvnic_adapter *adapter)
> +{
> +	union ibmvnic_crq crq;
> +
> +	memset(&crq, 0, sizeof(crq));
> +	crq.version_exchange.first = IBMVNIC_CRQ_CMD;
> +	crq.version_exchange.cmd = VERSION_EXCHANGE;
> +	crq.version_exchange.version = cpu_to_be16(ibmvnic_version);
> +
> +	return ibmvnic_send_crq(adapter, &crq);
> +}
> +
>  static long h_reg_sub_crq(unsigned long unit_address, unsigned long token,
>  			  unsigned long length, unsigned long *number,
>  			  unsigned long *irq)
> @@ -2221,6 +2245,75 @@ static struct ibmvnic_rwi *get_next_rwi(struct ibmvnic_adapter *adapter)
>  	return rwi;
>  }
>  
> +/* ibmvnic_do_passive_init()
> + * Perform the initialization of the device at a later time
> + *
> + * If the ibmvnic was does not have a partner device to communicate with at boot
> + * and that partner device comes online at a later time, this function is called
> + * to complete the initalization process of ibmvnic.
> + * Caller should not hold rtnl_lock().
> + *
> + *
> + * Returns non-zero if sub-CRQs are not initialized properly leaving the device
> + * in the down state.
> + * Returns 0 upon success and the device is probed.
> + */
> +
> +static int do_passive_init(struct ibmvnic_adapter *adapter)
> +{
> +	unsigned long timeout = msecs_to_jiffies(30000);
> +	struct net_device *netdev = adapter->netdev;
> +	struct device *dev = &adapter->vdev->dev;
> +	int rc;
> +
> +	netdev_dbg(adapter->netdev, "Partner device not found, probing.\n");
> +
> +	adapter->state = VNIC_PROBING;
> +	reinit_completion(&adapter->init_done);
> +	adapter->init_done_rc = 0;
> +	adapter->crq.active = true;
> +
> +	rc = send_crq_init_complete(adapter);
> +	if (rc)
> +		goto out;
> +
> +	rc = send_version_xchg(adapter);
> +	netdev_dbg(adapter->netdev, "send_version_xchg rc=%d", rc);
> +
> +	if (!wait_for_completion_timeout(&adapter->init_done, timeout)) {
> +		dev_err(dev, "Initialization sequence timed out\n");
> +		rc = -ETIMEDOUT;
> +		goto out;
> +	}
> +
> +	rc = init_sub_crqs(adapter);
> +	if (rc) {
> +		dev_err(dev, "Initialization of sub crqs failed, rc=%d\n", rc);
> +		goto out;
> +	}
> +
> +	rc = init_sub_crq_irqs(adapter);
> +	if (rc) {
> +		dev_err(dev, "Failed to initialize sub crq irqs\n, rc=%d", rc);
> +		goto init_failed;
> +	}
> +
> +	netdev->mtu = adapter->req_mtu - ETH_HLEN;
> +	netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
> +	netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
> +
> +	adapter->state = VNIC_PROBED;
> +	netdev_dbg(adapter->netdev, "Probed successfully. Waiting for signal from partner device.\n");
> +
> +	return 0;
> +
> +init_failed:
> +	release_sub_crqs(adapter, 1);
> +out:
> +	adapter->state = VNIC_DOWN;
> +	return rc;
> +}
> +
>  static void __ibmvnic_reset(struct work_struct *work)
>  {
>  	struct ibmvnic_rwi *rwi;
> @@ -2256,7 +2349,13 @@ static void __ibmvnic_reset(struct work_struct *work)
>  		}
>  		spin_unlock_irqrestore(&adapter->state_lock, flags);
>  
> -		if (adapter->force_reset_recovery) {
> +		if (rwi->reset_reason == VNIC_RESET_PASSIVE_INIT) {
> +			rtnl_lock();
> +			rc = do_passive_init(adapter);
> +			rtnl_unlock();
> +			if (!rc)
> +				netif_carrier_on(adapter->netdev);
> +		} else if (adapter->force_reset_recovery) {
>  			/* Since we are doing a hard reset now, clear the
>  			 * failover_pending flag so we don't ignore any
>  			 * future MOBILITY or other resets.
> @@ -3724,18 +3823,6 @@ static int ibmvnic_send_crq_init(struct ibmvnic_adapter *adapter)
>  	return 0;
>  }
>  
> -static int send_version_xchg(struct ibmvnic_adapter *adapter)
> -{
> -	union ibmvnic_crq crq;
> -
> -	memset(&crq, 0, sizeof(crq));
> -	crq.version_exchange.first = IBMVNIC_CRQ_CMD;
> -	crq.version_exchange.cmd = VERSION_EXCHANGE;
> -	crq.version_exchange.version = cpu_to_be16(ibmvnic_version);
> -
> -	return ibmvnic_send_crq(adapter, &crq);
> -}
> -
>  struct vnic_login_client_data {
>  	u8	type;
>  	__be16	len;
> @@ -4855,7 +4942,12 @@ static void ibmvnic_handle_crq(union ibmvnic_crq *crq,
>  				complete(&adapter->init_done);
>  				adapter->init_done_rc = -EIO;
>  			}
> -			rc = ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
> +
> +			if (adapter->state == VNIC_DOWN)
> +				rc = ibmvnic_reset(adapter, VNIC_RESET_PASSIVE_INIT);
> +			else
> +				rc = ibmvnic_reset(adapter, VNIC_RESET_FAILOVER);
> +
>  			if (rc && rc != -EBUSY) {
>  				/* We were unable to schedule the failover
>  				 * reset either because the adapter was still
> @@ -5278,6 +5370,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  	struct ibmvnic_adapter *adapter;
>  	struct net_device *netdev;
>  	unsigned char *mac_addr_p;
> +	bool init_success;
>  	int rc;
>  
>  	dev_dbg(&dev->dev, "entering ibmvnic_probe for UA 0x%x\n",
> @@ -5324,6 +5417,7 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  	init_completion(&adapter->stats_done);
>  	clear_bit(0, &adapter->resetting);
>  
> +	init_success = false;
>  	do {
>  		rc = init_crq_queue(adapter);
>  		if (rc) {
> @@ -5333,10 +5427,16 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  		}
>  
>  		rc = ibmvnic_reset_init(adapter, false);
> -		if (rc && rc != EAGAIN)
> -			goto ibmvnic_init_fail;
>  	} while (rc == EAGAIN);
>  
> +	/* We are ignoring the error from ibmvnic_reset_init() assuming that the
> +	 * partner is not ready. When the partner becomes ready, we will do the
> +	 * passive init reset.
> +	 */
> +
> +	if (!rc)
> +		init_success = true;
> +
>  	rc = init_stats_buffers(adapter);
>  	if (rc)
>  		goto ibmvnic_init_fail;
> @@ -5345,10 +5445,6 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  	if (rc)
>  		goto ibmvnic_stats_fail;
>  
> -	netdev->mtu = adapter->req_mtu - ETH_HLEN;
> -	netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
> -	netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
> -
>  	rc = device_create_file(&dev->dev, &dev_attr_failover);
>  	if (rc)
>  		goto ibmvnic_dev_file_err;
> @@ -5361,7 +5457,14 @@ static int ibmvnic_probe(struct vio_dev *dev, const struct vio_device_id *id)
>  	}
>  	dev_info(&dev->dev, "ibmvnic registered\n");
>  
> -	adapter->state = VNIC_PROBED;
> +	if (init_success) {
> +		adapter->state = VNIC_PROBED;
> +		netdev->mtu = adapter->req_mtu - ETH_HLEN;
> +		netdev->min_mtu = adapter->min_mtu - ETH_HLEN;
> +		netdev->max_mtu = adapter->max_mtu - ETH_HLEN;
> +	} else {
> +		adapter->state = VNIC_DOWN;
> +	}
>  
>  	adapter->wait_for_reset = false;
>  	adapter->last_reset_time = jiffies;
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
> index 806aa75a4e86..98a383e89e44 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -945,14 +945,16 @@ enum vnic_state {VNIC_PROBING = 1,
>  		 VNIC_CLOSING,
>  		 VNIC_CLOSED,
>  		 VNIC_REMOVING,
> -		 VNIC_REMOVED};
> +		 VNIC_REMOVED,
> +		 VNIC_DOWN};
>  
>  enum ibmvnic_reset_reason {VNIC_RESET_FAILOVER = 1,
>  			   VNIC_RESET_MOBILITY,
>  			   VNIC_RESET_FATAL,
>  			   VNIC_RESET_NON_FATAL,
>  			   VNIC_RESET_TIMEOUT,
> -			   VNIC_RESET_CHANGE_PARAM};
> +			   VNIC_RESET_CHANGE_PARAM,
> +			   VNIC_RESET_PASSIVE_INIT};
>  
>  struct ibmvnic_rwi {
>  	enum ibmvnic_reset_reason reset_reason;
> -- 
> 2.30.0

Hi all,

Few things I failed to add to this patch:

1. Correctly format the Co-developed-by tag
2. CC all the maintainers
3. This patch doesn't fix a bug in a specific commit, therefore
I have to submit this to net-next.

I will submit a v2 shortly.

Best,
Cris Forno
