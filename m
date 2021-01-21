Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C030F2FF358
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 19:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbhAUSkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 13:40:35 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18014 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726202AbhAUS0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 13:26:01 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LIBGhM044882;
        Thu, 21 Jan 2021 13:24:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=Mg6re5QmA4AtijIQv5WI3wTkGejnJfeUGID6cqzZM6w=;
 b=QDOxrV8boTOTn4xP3ILtvAfzunjnbpH00gfVREz1tIo4r6kcaav29j/vrp3cvA1xURoh
 OKF8yxNXQO/ttmbxKUpdM3GHlhDUZoJLuoLm5xz+j+hnrwonfZu3FwJJy75bUlfUIUn7
 rnw8eLxHLi4ZQ/bjx9snn5mj6RpMHEZF3uFplaWcUCJClsC4FPALdV4VjkBuEcm5/Oab
 fnMV10t89TRn408nGbn+QLbp+3UzjrEo6xCIlp4T5qwBc0fSNs7tkZAc86BF5KPz9Yg+
 90doniXKom0efItAZWJOVuoo6QCmOeAe4iPys38WW1GgTKCJFQEQMmJs7fE+ZP6297l6 3g== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 367ens0byc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 13:24:05 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LICvcU010425;
        Thu, 21 Jan 2021 18:24:04 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 3668p31k38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 18:24:04 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LIO36Z14418322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 18:24:03 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D9572805E;
        Thu, 21 Jan 2021 18:24:03 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D961E28059;
        Thu, 21 Jan 2021 18:24:02 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 18:24:02 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 21 Jan 2021 10:24:02 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        sukadev@linux.ibm.com, mpe@ellerman.id.au,
        julietk@linux.vnet.ibm.com, benh@kernel.crashing.org,
        paulus@samba.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, kernel@pengutronix.de,
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH net] ibmvnic: device remove has higher precedence over
 reset
In-Reply-To: <20210121062005.53271-1-ljp@linux.ibm.com>
References: <20210121062005.53271-1-ljp@linux.ibm.com>
Message-ID: <c34816a13d857b7f5d1a25991b58ec63@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_09:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=946 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101210091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-20 22:20, Lijun Pan wrote:
> Returning -EBUSY in ibmvnic_remove() does not actually hold the
> removal procedure since driver core doesn't care for the return
> value (see __device_release_driver() in drivers/base/dd.c
> calling dev->bus->remove()) though vio_bus_remove
> (in arch/powerpc/platforms/pseries/vio.c) records the
> return value and passes it on. [1]
> 
> During the device removal precedure, we should not schedule
> any new reset (ibmvnic_reset check for REMOVING and exit),
> and should rely on the flush_work and flush_delayed_work
> to complete the pending resets, specifically we need to
> let __ibmvnic_reset() keep running while in REMOVING state since
> flush_work and flush_delayed_work shall call __ibmvnic_reset finally.
> So we skip the checking for REMOVING in __ibmvnic_reset.
> 
> [1]
> https://lore.kernel.org/linuxppc-dev/20210117101242.dpwayq6wdgfdzirl@pengutronix.de/T/#m48f5befd96bc9842ece2a3ad14f4c27747206a53
> Reported-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> Fixes: 7d7195a026ba ("ibmvnic: Do not process device remove during
> device reset")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> ---
> v1 versus RFC:
>   1/ articulate why remove the REMOVING checking in __ibmvnic_reset
>   and why keep the current checking for REMOVING in ibmvnic_reset.
>   2/ The locking issue mentioned by Uwe are being addressed separately
>      by	https://lists.openwall.net/netdev/2021/01/08/89
>   3/ This patch does not have merge conflict with 2/
> 
>  drivers/net/ethernet/ibm/ibmvnic.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index aed985e08e8a..11f28fd03057 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2235,8 +2235,7 @@ static void __ibmvnic_reset(struct work_struct 
> *work)
>  	while (rwi) {
>  		spin_lock_irqsave(&adapter->state_lock, flags);
> 
> -		if (adapter->state == VNIC_REMOVING ||
> -		    adapter->state == VNIC_REMOVED) {
> +		if (adapter->state == VNIC_REMOVED) {

If we do get here, we would crash because ibmvnic_remove() happened. It 
frees the adapter struct already.

>  			spin_unlock_irqrestore(&adapter->state_lock, flags);
>  			kfree(rwi);
>  			rc = EBUSY;
> @@ -5372,11 +5371,6 @@ static int ibmvnic_remove(struct vio_dev *dev)
>  	unsigned long flags;
> 
>  	spin_lock_irqsave(&adapter->state_lock, flags);
> -	if (test_bit(0, &adapter->resetting)) {
> -		spin_unlock_irqrestore(&adapter->state_lock, flags);
> -		return -EBUSY;
> -	}
> -
>  	adapter->state = VNIC_REMOVING;
>  	spin_unlock_irqrestore(&adapter->state_lock, flags);
