Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDA133EB64
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 09:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCQIZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 04:25:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40992 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhCQIZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 04:25:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H8F5Uw194508;
        Wed, 17 Mar 2021 08:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pdZMzujUdwXM28Kiro9cV8IrchmYRMYL5a9SIEWpHbw=;
 b=sLVD2K/gAHk9idGSOetbGbCyWhrezihmP6dGOOEg2sDUND6TN8apTqR+lmPofzpoVemk
 +cwTEHHL7jrQUYF0NlWB38UpxfWIGDdp06y52OS+gT6/bRtWXjD4+b1KYlu+JeWzp5bM
 f17jJjLb7T6PeUxcUkOR70N5mlrgE7e5AoODM5WCCISzR0sI2QdMefh/G/M1TUEoJHNP
 HPVugdObIUHyWTb4uboce8qUpGie4ckPb8NgLp2YuE4hlPGWoatVjvX4sc0ucMvPCmh3
 LsibpDMrI96APOKYq3fkBmm8ePtmFjpGng2N3C1eJua0Vx5OByLVqn3BQV4c0gPL+d4r tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 378nbmb67f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 08:25:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H8AjRv057215;
        Wed, 17 Mar 2021 08:25:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3796yuhp34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 08:25:25 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12H8PNxu031044;
        Wed, 17 Mar 2021 08:25:24 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 17 Mar 2021 01:25:22 -0700
Date:   Wed, 17 Mar 2021 11:25:14 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Anish Udupa <udupa.anish@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: qlge: Fixed an alignment issue.
Message-ID: <20210317082514.GY2087@kadam>
References: <CAPDGunMo-ORwDme4ckui5kxxW6-Ho1J_MjcTkxdDdKLMDrCFdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPDGunMo-ORwDme4ckui5kxxW6-Ho1J_MjcTkxdDdKLMDrCFdg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170063
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 09:26:34PM +0530, Anish Udupa wrote:
> The * of the comment was not aligned properly. Ran checkpatch and
> found the warning. Resolved it in this patch.
> 
> Signed-off-by: Anish Udupa <udupa.anish@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index 5516be3af898..bfd7217f3953 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -3816,7 +3816,7 @@ static int qlge_adapter_down(struct qlge_adapter *qdev)
>   qlge_tx_ring_clean(qdev);
> 
>   /* Call netif_napi_del() from common point.
> - */
> + */

This has already been fixed upstream.  You should be working against
linux-next or staging-next.

https://lore.kernel.org/driverdev-devel/20210216101945.187474-1-ducheng2@gmail.com/

regards,
dan carpenter

