Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3724496F3E
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiAWAWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:22:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:52846 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbiAWAWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:22:14 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20MNL2tu000751
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:22:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=lwVY8bwbTnZQN45imQfZXFzLn+l9RFc0doVuTDtOJt8=;
 b=nGVSLRF/8wKo9qQqaeR2u2NU4C0AKMSmFNugn3Y3qUAXn/oc+hX9sEQgXJtG+DzmmX92
 UvVi+qjbUtwx9VLKojkba95qeEjppDjC0j56fgv0UR8RSVMqltcrPA7p56k1uVlUiOeb
 W8K9Ntq75hwhJ/DqtCPhUuv6BqaKPMG7NTuiKEgr8ZgevSSrowt6YXOc52BabA9VWyZF
 XFcUk1ZsOeNWKdWyDscypAtnzhSPXek8V1mpllkMGT1ee4MhL05i7T9zMsdwUx188kGK
 XwA8ABRWZUO7i04LWQiCGqO5gt1kz5ZWfP7khdwA30GUJX698BoBIdCXdSSFL/W2Gh+3 2A== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3druh4rkhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:22:13 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20N0CKCl021056
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:22:12 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 3dr9j8sppt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:22:12 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20N0MBBM17301890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jan 2022 00:22:11 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B29BBE053;
        Sun, 23 Jan 2022 00:22:11 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1CB0FBE05A;
        Sun, 23 Jan 2022 00:22:10 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sun, 23 Jan 2022 00:22:10 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 22 Jan 2022 16:22:10 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net 1/4] ibmvnic: Allow extra failures before disabling
In-Reply-To: <20220122025921.199446-1-sukadev@linux.ibm.com>
References: <20220122025921.199446-1-sukadev@linux.ibm.com>
Message-ID: <637f5bf73c395b49d1b615026d708d20@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dJ5AISaV0f0Q_nyuFgOyluIdL4Bt_gL0
X-Proofpoint-GUID: dJ5AISaV0f0Q_nyuFgOyluIdL4Bt_gL0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-22_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxscore=0 impostorscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201220174
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-21 18:59, Sukadev Bhattiprolu wrote:
> If auto-priority-failover (APF) is enabled and there are at least two
> backing devices of different priorities, some resets like fail-over,
> change-param etc can cause at least two back to back failovers. 
> (Failover
> from high priority backing device to lower priority one and then back
> to the higher priority one if that is still functional).
> 
> Depending on the timimg of the two failovers it is possible to trigger
> a "hard" reset and for the hard reset to fail due to failovers. When 
> this
> occurs, the driver assumes that the network is unstable and disables 
> the
> VNIC for a 60-second "settling time". This in turn can cause the 
> ethtool
> command to fail with "No such device" while the vnic automatically 
> recovers
> a little while later.
> 
> Given that it's possible to have two back to back failures, allow for 
> extra
> failures before disabling the vnic for the settling time.
> 
> Fixes: f15fde9d47b8 ("ibmvnic: delay next reset if hard reset fails")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 0bb3911dd014..9b2d16ad76f1 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2598,6 +2598,7 @@ static void __ibmvnic_reset(struct work_struct 
> *work)
>  	struct ibmvnic_rwi *rwi;
>  	unsigned long flags;
>  	u32 reset_state;
> +	int num_fails = 0;
>  	int rc = 0;
> 
>  	adapter = container_of(work, struct ibmvnic_adapter, ibmvnic_reset);
> @@ -2651,11 +2652,23 @@ static void __ibmvnic_reset(struct work_struct 
> *work)
>  				rc = do_hard_reset(adapter, rwi, reset_state);
>  				rtnl_unlock();
>  			}
> -			if (rc) {
> -				/* give backing device time to settle down */
> +			if (rc)
> +				num_fails++;
> +			else
> +				num_fails = 0;
> +
> +			/* If auto-priority-failover is enabled we can get
> +			 * back to back failovers during resets, resulting
> +			 * in at least two failed resets (from high-priority
> +			 * backing device to low-priority one and then back)
> +			 * If resets continue to fail beyond that, give the
> +			 * adapter some time to settle down before retrying.
> +			 */
> +			if (num_fails >= 3) {
>  				netdev_dbg(adapter->netdev,
> -					   "[S:%s] Hard reset failed, waiting 60 secs\n",
> -					   adapter_state_to_string(adapter->state));
> +					   "[S:%s] Hard reset failed %d times, waiting 60 secs\n",
> +					   adapter_state_to_string(adapter->state),
> +					   num_fails);
>  				set_current_state(TASK_UNINTERRUPTIBLE);
>  				schedule_timeout(60 * HZ);
>  			}
