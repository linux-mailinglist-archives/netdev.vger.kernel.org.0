Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED4D44056D
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhJ2W2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:28:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32016 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229546AbhJ2W2C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 18:28:02 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TMDE4q024754
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:25:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=fH6B1tHaNtk2oTwmSlgURUQa/BFj9bLrnQO1XahNNa4=;
 b=PAEbSbQiiIopomGEFXKSbHEKIxvJals0EvRBMidM5myCmP6xg5rgCOJU+3GLJWNc8XIh
 38v3JWIFBE6E35OAkucplVSrZ27IvQ74a+p9Du4W2bGJocpixLiQucSah+YKgurnf7ko
 YhcMl0RYCj6MtnrG5Is20dyT6a9MGc6F9EOxkbMrrAk4zMkg7V1Frw+F5Oi0xyjj8wlk
 MWX7qBUHfXZaERUdRhVYO6x7dlTqAl31XRPRpQKYIem0fc7NqckuD8NUqEzn+PV5eriX
 xyAmdhEr9V0jroEmfNWD9Z9AWOkAPR1bpH/zhBV+cPoUa5qZGjZHhZW2ub0XfPr3u7Ug Vg== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c0sje04ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:25:32 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19TMDKsH019761
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:25:31 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03wdc.us.ibm.com with ESMTP id 3bx4f29h1r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:25:31 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19TMPSrI33030496
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 22:25:28 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71B357805E;
        Fri, 29 Oct 2021 22:25:28 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 294777805C;
        Fri, 29 Oct 2021 22:25:28 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 29 Oct 2021 22:25:28 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 29 Oct 2021 15:25:27 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        abdhalee@in.ibm.com, vaish123@in.ibm.com
Subject: Re: [PATCH net 3/3] ibmvnic: delay complete()
In-Reply-To: <20211029220316.2003519-3-sukadev@linux.ibm.com>
References: <20211029220316.2003519-1-sukadev@linux.ibm.com>
 <20211029220316.2003519-3-sukadev@linux.ibm.com>
Message-ID: <1635ca9d242a7e22cc69cd0b9a0ad821@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tBJDCt67PslBzfhjtefxVbVO2Uec0PWo
X-Proofpoint-ORIG-GUID: tBJDCt67PslBzfhjtefxVbVO2Uec0PWo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_06,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 mlxscore=0 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 mlxlogscore=850 phishscore=0 lowpriorityscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110290123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-29 15:03, Sukadev Bhattiprolu wrote:
> If we get CRQ_INIT, we set errno to -EIO and first call complete() to
> notify the waiter. Then we try to schedule a FAILOVER reset. If this
> occurs while adapter is in PROBING state, ibmvnic_reset() changes the
> error code to EAGAIN and returns without scheduling the FAILOVER. The
> purpose of setting error code to EAGAIN is to ask the waiter to retry.
> 
> But due to the earlier complete() call, the waiter may already have 
> seen
> the -EIO response and decided not to retry. This can cause intermittent
> failures when bringing up ibmvnic adapters during boot, specially in
> in kexec/kdump kernels.
> 
> Defer the complete() call until after scheduling the reset.
> 
> Also streamline the error code to EAGAIN. Don't see why we need EIO
> sometimes. All 3 callers of ibmvnic_reset_init() can handle EAGAIN.
> 
> Fixes: 17c8705838a5 ("ibmvnic: Return error code if init interrupted
> by transport event")
> Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 50956f622b11..29cbf60dfd79 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2755,7 +2755,7 @@ static int ibmvnic_reset(struct ibmvnic_adapter 
> *adapter,
> 
>  	if (adapter->state == VNIC_PROBING) {
>  		netdev_warn(netdev, "Adapter reset during probe\n");
> -		adapter->init_done_rc = EAGAIN;
> +		adapter->init_done_rc = -EAGAIN;
>  		ret = EAGAIN;
>  		goto err;
>  	}
> @@ -5266,11 +5266,6 @@ static void ibmvnic_handle_crq(union ibmvnic_crq 
> *crq,
>  			 */
>  			adapter->login_pending = false;
> 
> -			if (!completion_done(&adapter->init_done)) {
> -				complete(&adapter->init_done);
> -				adapter->init_done_rc = -EIO;
> -			}
> -
>  			if (adapter->state == VNIC_DOWN)
>  				rc = ibmvnic_reset(adapter, VNIC_RESET_PASSIVE_INIT);
>  			else
> @@ -5291,6 +5286,13 @@ static void ibmvnic_handle_crq(union ibmvnic_crq 
> *crq,
>  					   rc);
>  				adapter->failover_pending = false;
>  			}
> +
> +			if (!completion_done(&adapter->init_done)) {
> +				complete(&adapter->init_done);
> +				if (!adapter->init_done_rc)
> +					adapter->init_done_rc = -EAGAIN;
> +			}
> +
>  			break;
>  		case IBMVNIC_CRQ_INIT_COMPLETE:
>  			dev_info(dev, "Partner initialization complete\n");
> @@ -5763,7 +5765,7 @@ static int ibmvnic_probe(struct vio_dev *dev,
> const struct vio_device_id *id)
>  		}
> 
>  		rc = ibmvnic_reset_init(adapter, false);
> -	} while (rc == EAGAIN);
> +	} while (rc == -EAGAIN);
> 
>  	/* We are ignoring the error from ibmvnic_reset_init() assuming that 
> the
>  	 * partner is not ready. CRQ is not active. When the partner becomes
