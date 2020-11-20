Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E40B12BB982
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgKTXBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:01:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726255AbgKTXBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:01:12 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMX68Q006315
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 18:01:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=IWtWBX9O7wzrDY5cWi44rmlt+bGSYzVar+QcXO0IMgY=;
 b=tE3yicOmCmK20ACZEKo9wm9bmRDim6OLyFRf3zt2wYhSOaBemrkdgTUdmadKkcjLirBm
 OLYn2KT3sWsebYn31hWHjB3ZFJHh/VS86PdKeQtTt9hSKDRKz/dvdmd/Dk5hSWik+R6E
 fbOPZSm4thPBbaFEf+q0+P8VO3IbO3c56ej6KKye1ifCpXvXGyljgAYezB/967aeiR31
 xSfTPeSWN0ra+2QCrNTafFv73i3Uiyow2oKUp5I/uNMYAXeb4Pae7fp7rIjyFu1eTEFI
 I8aU0czU2HkderRiYlSoqXW11lGD/HRZArxGzv2PabLCxjGuQtXG4ag+tPuSrgJ1/zwd 5Q== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34xhk89abp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 18:01:11 -0500
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMr9Fw024169
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 23:01:10 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 34uttsb466-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 23:01:10 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKN1AsZ8782488
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 23:01:10 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDDB3B206B;
        Fri, 20 Nov 2020 23:01:09 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76570B2074;
        Fri, 20 Nov 2020 23:01:09 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 23:01:09 +0000 (GMT)
MIME-Version: 1.0
Date:   Fri, 20 Nov 2020 15:01:09 -0800
From:   drt <drt@linux.vnet.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net 10/15] ibmvnic: no reset timeout for 5 seconds after
 reset
In-Reply-To: <20201120224049.46933-11-ljp@linux.ibm.com>
References: <20201120224049.46933-1-ljp@linux.ibm.com>
 <20201120224049.46933-11-ljp@linux.ibm.com>
Message-ID: <eba79ebb8fdf4fd9993cdc7ff5d327ae@linux.vnet.ibm.com>
X-Sender: drt@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0
 adultscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-20 14:40, Lijun Pan wrote:
> From: Dany Madden <drt@linux.ibm.com>
> 
> Reset timeout is going off right after adapter reset. This patch 
> ensures
> that timeout is scheduled if it has been 5 seconds since the last 
> reset.
> 5 seconds is the default watchdog timeout.
> 

Suggested-by: Brian King <brking@linux.ibm.com>

> Signed-off-by: Dany Madden <drt@linux.ibm.com>

Sorry I missed this. Thanks, Brian!

Dany

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 11 +++++++++--
>  drivers/net/ethernet/ibm/ibmvnic.h |  2 ++
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 9d2eebd31ff6..252af4ab6468 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2291,6 +2291,7 @@ static void __ibmvnic_reset(struct work_struct 
> *work)
>  			rc = do_reset(adapter, rwi, reset_state);
>  		}
>  		kfree(rwi);
> +		adapter->last_reset_time = jiffies;
> 
>  		if (rc)
>  			netdev_dbg(adapter->netdev, "Reset failed, rc=%d\n", rc);
> @@ -2394,7 +2395,13 @@ static void ibmvnic_tx_timeout(struct
> net_device *dev, unsigned int txqueue)
>  			   "Adapter is resetting, skip timeout reset\n");
>  		return;
>  	}
> -
> +	/* No queuing up reset until at least 5 seconds (default watchdog 
> val)
> +	 * after last reset
> +	 */
> +	if (time_before(jiffies, (adapter->last_reset_time + 
> dev->watchdog_timeo))) {
> +		netdev_dbg(dev, "Not yet time to tx timeout.\n");
> +		return;
> +	}
>  	ibmvnic_reset(adapter, VNIC_RESET_TIMEOUT);
>  }
> 
> @@ -5316,7 +5323,7 @@ static int ibmvnic_probe(struct vio_dev *dev,
> const struct vio_device_id *id)
>  	adapter->state = VNIC_PROBED;
> 
>  	adapter->wait_for_reset = false;
> -
> +	adapter->last_reset_time = jiffies;
>  	return 0;
> 
>  ibmvnic_register_fail:
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.h
> b/drivers/net/ethernet/ibm/ibmvnic.h
> index 9b1f34602f33..d15866cbc2a6 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.h
> +++ b/drivers/net/ethernet/ibm/ibmvnic.h
> @@ -1089,6 +1089,8 @@ struct ibmvnic_adapter {
>  	unsigned long resetting;
>  	bool napi_enabled, from_passive_init;
>  	bool login_pending;
> +	/* last device reset time */
> +	unsigned long last_reset_time;
> 
>  	bool failover_pending;
>  	bool force_reset_recovery;
