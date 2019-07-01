Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBE425C45F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfGAUlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:41:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46180 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfGAUlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:41:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61KdmZL079039;
        Mon, 1 Jul 2019 20:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=bBe36s3bg2kObvt/BO5jZnInXaNShaBTpTacLg64CXE=;
 b=bjMCIsKp35MwLRtSu12MC0KJ0xFVcpaRxRyymr83wRiUi7JY+zTjQGZjifYy+n/FuAIU
 qhmqH4t5IsTFcJ5Nxo/OE6GQZTrTXJ20HrIyzCKSTM196uzR2xk4TNqVrE6huzZkxZ68
 GQRJfr64Xmy3glbkuTI/v1lmrwrW4fgxTvKx7gID+IUO2S9BBabyLDWveqaoxDj8+/vw
 1+PtGhaDa4uqkszw89hMjNBtmp9HwG6P23HVot+q4cpROZ15Nsv3d9ppetjiCqq52D48
 FpbDOnbBF0biSsKjS3thQ4/SXkeyZaRzDnErIHrdOnd+9HkQJJqR90OHlwpM99/GMrk8 SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2te5tbfv1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:41:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x61Kbphp030751;
        Mon, 1 Jul 2019 20:41:03 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tebakcy4w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jul 2019 20:41:03 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x61Kf1Cr005619;
        Mon, 1 Jul 2019 20:41:01 GMT
Received: from [10.209.242.148] (/10.209.242.148)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jul 2019 13:41:01 -0700
Subject: Re: [PATCH net-next 3/7] net/rds: Wait for the FRMR_IS_FREE (or
 FRMR_IS_STALE) transition after posting IB_WR_LOCAL_INV
To:     Gerd Rausch <gerd.rausch@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <505e9af7-a0cd-bf75-4a72-5d883ee06bf1@oracle.com>
From:   santosh.shilimkar@oracle.com
Organization: Oracle Corporation
Message-ID: <c79821e0-307c-5736-6eb5-e20983097345@oracle.com>
Date:   Mon, 1 Jul 2019 13:41:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <505e9af7-a0cd-bf75-4a72-5d883ee06bf1@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907010239
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9305 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907010240
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/19 9:39 AM, Gerd Rausch wrote:
> In order to:
> 1) avoid a silly bouncing between "clean_list" and "drop_list"
>     triggered by function "rds_ib_reg_frmr" as it is releases frmr
>     regions whose state is not "FRMR_IS_FREE" right away.
> 
> 2) prevent an invalid access error in a race from a pending
>     "IB_WR_LOCAL_INV" operation with a teardown ("dma_unmap_sg", "put_page")
>     and de-registration ("ib_dereg_mr") of the corresponding
>     memory region.
> 
> Signed-off-by: Gerd Rausch <gerd.rausch@oracle.com>
> ---
>   net/rds/ib_frmr.c | 89 ++++++++++++++++++++++++++++++-----------------
>   net/rds/ib_mr.h   |  2 ++
>   2 files changed, 59 insertions(+), 32 deletions(-)
> 
> diff --git a/net/rds/ib_frmr.c b/net/rds/ib_frmr.c
> index 9f8aa310c27a..3c953034dca3 100644
> --- a/net/rds/ib_frmr.c
> +++ b/net/rds/ib_frmr.c
> @@ -76,6 +76,7 @@ static struct rds_ib_mr *rds_ib_alloc_frmr(struct rds_ib_device *rds_ibdev,
>   
>   	frmr->fr_state = FRMR_IS_FREE;
>   	init_waitqueue_head(&frmr->fr_inv_done);
> +	init_waitqueue_head(&frmr->fr_reg_done);
>   	return ibmr;
>   
>   out_no_cigar:
> @@ -124,6 +125,7 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
>   	 */
>   	ib_update_fast_reg_key(frmr->mr, ibmr->remap_count++);
>   	frmr->fr_state = FRMR_IS_INUSE;
> +	frmr->fr_reg = true;
>   
>   	memset(&reg_wr, 0, sizeof(reg_wr));
>   	reg_wr.wr.wr_id = (unsigned long)(void *)ibmr;
> @@ -144,7 +146,29 @@ static int rds_ib_post_reg_frmr(struct rds_ib_mr *ibmr)
>   		if (printk_ratelimit())
>   			pr_warn("RDS/IB: %s returned error(%d)\n",
>   				__func__, ret);
> +		goto out;
> +	}
> +
> +	if (!frmr->fr_reg)
> +		goto out;
> +
> +	/* Wait for the registration to complete in order to prevent an invalid
> +	 * access error resulting from a race between the memory region already
> +	 * being accessed while registration is still pending.
> +	 */
> +	wait_event_timeout(frmr->fr_reg_done, !frmr->fr_reg,
> +			   msecs_to_jiffies(100));
> +
This arbitrary timeout in this patch as well as pacth 1/7 which
Dave pointed out has any logic ?

MR registration command issued to hardware can at times take as
much as command timeout(e.g 60 seconds in CX3) and upto that its still
legitimate operation and not necessary failure. We shouldn't add
arbitrary time outs in ULPs.

Regards,
Santosh
