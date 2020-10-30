Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196A32A0E28
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbgJ3S4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:56:53 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726061AbgJ3S4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:56:52 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UIVLPQ041711
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 14:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=U+x1Cgn9aFwiaw3uS/iqVafJPG2Q9tFSk4OYInWyJJE=;
 b=dMHs3VvE7IghExVXx9g5XMhY943aSyTy7RTCgJy2y0gV3cpusJqncnA9EEwlCOmOyBFw
 o2OKJNAnbz8KCcnDVdll1ZROoILBXYjy9x2582+de732wV5rfePrf0ho3hoc2ge1V30B
 LDt60OgabrCNzT9QAQSFc/y/3AnsmhMv4nHeMpV2FrCY8vAYhCoAgWBjzi805B9awex0
 yJecrjhiwFPB6CRM2V7XLR/uIRlsCa+ZHv/xIG+YleA58hIvacdFkHbSCuu+BYclVEJ1
 Xoq9T7HJx98CWnPVSWn23m/GYssKX804h/lkf/oZbv+s1SSA+Q36VL5AwC/UhamcqoeT wg== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34gnqqng3w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 14:56:51 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UIVbtV016695
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 18:56:50 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 34g1e247ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 18:56:50 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UIunjg52953530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 18:56:49 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD725AE05C;
        Fri, 30 Oct 2020 18:56:49 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42ED4AE066;
        Fri, 30 Oct 2020 18:56:49 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 18:56:49 +0000 (GMT)
MIME-Version: 1.0
Date:   Fri, 30 Oct 2020 11:56:48 -0700
From:   drt <drt@linux.vnet.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Lijun Pan <ljp@linux.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/1] powerpc/vnic: Extend "failover pending" window
In-Reply-To: <20201030170711.1562994-1-sukadev@linux.ibm.com>
References: <20201030170711.1562994-1-sukadev@linux.ibm.com>
Message-ID: <41a6c64a2f8517e07f6fc4e6562863b6@linux.vnet.ibm.com>
X-Sender: drt@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_08:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1011 priorityscore=1501
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-30 10:07, Sukadev Bhattiprolu wrote:
> Commit 5a18e1e0c193b introduced the 'failover_pending' state to track
> the "failover pending window" - where we wait for the partner to become
> ready (after a transport event) before actually attempting to failover.
> i.e window is between following two events:
> 
>         a. we get a transport event due to a FAILOVER
> 
>         b. later, we get CRQ_INITIALIZED indicating the partner is
>            ready  at which point we schedule a FAILOVER reset.
> 
> and ->failover_pending is true during this window.
> 
> If during this window, we attempt to open (or close) a device, we 
> pretend
> that the operation succeded and let the FAILOVER reset path complete 
> the
> operation.
> 
> This is fine, except if the transport event ("a" above) occurs during 
> the
> open and after open has already checked whether a failover is pending. 
> If
> that happens, we fail the open, which can cause the boot scripts to 
> leave
> the interface down requiring administrator to manually bring up the 
> device.
> 
> This fix "extends" the failover pending window till we are _actually_
> ready to perform the failover reset (i.e until after we get the RTNL
> lock). Since open() holds the RTNL lock, we can be sure that we either
> finish the open or if the open() fails due to the failover pending 
> window,
> we can again pretend that open is done and let the failover complete 
> it.
> 
> We could try and block the open until failover is completed but a) that
> could still timeout the application and b) Existing code "pretends" 
> that
> failover occurred "just after" open succeeded, so marks the open 
> successful
> and lets the failover complete the open. So, mark the open successful 
> even
> if the transport event occurs before we actually start the open.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> ---
> Changelog [v3]:
> 	[Lijun Pan]: Add a few more notes to patch description.
> 
> Changelog [v2]:
> 	[Brian King] Ensure we clear failover_pending during hard reset
> ---

Thanks, Suka!

Acked-by: Dany Madden <drt@linux.ibm.com>

>  drivers/net/ethernet/ibm/ibmvnic.c | 36 ++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 1b702a43a5d0..2a0f6f6820db 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -1197,18 +1197,27 @@ static int ibmvnic_open(struct net_device 
> *netdev)
>  	if (adapter->state != VNIC_CLOSED) {
>  		rc = ibmvnic_login(netdev);
>  		if (rc)
> -			return rc;
> +			goto out;
> 
>  		rc = init_resources(adapter);
>  		if (rc) {
>  			netdev_err(netdev, "failed to initialize resources\n");
>  			release_resources(adapter);
> -			return rc;
> +			goto out;
>  		}
>  	}
> 
>  	rc = __ibmvnic_open(netdev);
> 
> +out:
> +	/*
> +	 * If open fails due to a pending failover, set device state and
> +	 * return. Device operation will be handled by reset routine.
> +	 */
> +	if (rc && adapter->failover_pending) {
> +		adapter->state = VNIC_OPEN;
> +		rc = 0;
> +	}
>  	return rc;
>  }
> 
> @@ -1931,6 +1940,13 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  		   rwi->reset_reason);
> 
>  	rtnl_lock();
> +	/*
> +	 * Now that we have the rtnl lock, clear any pending failover.
> +	 * This will ensure ibmvnic_open() has either completed or will
> +	 * block until failover is complete.
> +	 */
> +	if (rwi->reset_reason == VNIC_RESET_FAILOVER)
> +		adapter->failover_pending = false;
> 
>  	netif_carrier_off(netdev);
>  	adapter->reset_reason = rwi->reset_reason;
> @@ -2211,6 +2227,13 @@ static void __ibmvnic_reset(struct work_struct 
> *work)
>  			/* CHANGE_PARAM requestor holds rtnl_lock */
>  			rc = do_change_param_reset(adapter, rwi, reset_state);
>  		} else if (adapter->force_reset_recovery) {
> +			/*
> +			 * Since we are doing a hard reset now, clear the
> +			 * failover_pending flag so we don't ignore any
> +			 * future MOBILITY or other resets.
> +			 */
> +			adapter->failover_pending = false;
> +
>  			/* Transport event occurred during previous reset */
>  			if (adapter->wait_for_reset) {
>  				/* Previous was CHANGE_PARAM; caller locked */
> @@ -2275,9 +2298,15 @@ static int ibmvnic_reset(struct ibmvnic_adapter 
> *adapter,
>  	unsigned long flags;
>  	int ret;
> 
> +	/*
> +	 * If failover is pending don't schedule any other reset.
> +	 * Instead let the failover complete. If there is already a
> +	 * a failover reset scheduled, we will detect and drop the
> +	 * duplicate reset when walking the ->rwi_list below.
> +	 */
>  	if (adapter->state == VNIC_REMOVING ||
>  	    adapter->state == VNIC_REMOVED ||
> -	    adapter->failover_pending) {
> +	    (adapter->failover_pending && reason != VNIC_RESET_FAILOVER)) {
>  		ret = EBUSY;
>  		netdev_dbg(netdev, "Adapter removing or pending failover, skipping 
> reset\n");
>  		goto err;
> @@ -4653,7 +4682,6 @@ static void ibmvnic_handle_crq(union ibmvnic_crq 
> *crq,
>  		case IBMVNIC_CRQ_INIT:
>  			dev_info(dev, "Partner initialized\n");
>  			adapter->from_passive_init = true;
> -			adapter->failover_pending = false;
>  			if (!completion_done(&adapter->init_done)) {
>  				complete(&adapter->init_done);
>  				adapter->init_done_rc = -EIO;
