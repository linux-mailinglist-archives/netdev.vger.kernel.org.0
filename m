Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B523AFDB9
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 09:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhFVHXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 03:23:09 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:65426 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhFVHXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 03:23:08 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M7GDmJ032136;
        Tue, 22 Jun 2021 07:20:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uZtpeCcW0/0ddJSUa4GkLD+7TtG1zH2UHC/nBMIUQhM=;
 b=a0e0YpU4SF96WFQSpNn854jaDwF/vh49UqhsJzN6mMAIkk2LMIpfC4Q38RwT1mrrhpCf
 w5TdqqLNYsOfFW/qGNYFeEsOfuCFPLGT6PpA2GFGCPBP8fEshCmmKq+AXzCBr6Ymjgsj
 RpKEYMWnmudOp4TmDfzF3V/jHk57Tb4va+J1B/D0KBhM3D2gQqGmcuKBdGRvM4Fo8GR7
 sK1S9l6yp7Zi8eYWIkNAy0q4BxeRvL/p9Samd610Xf4WqFHS6kmWxanenum8LPVQmFVy
 bowrQLOIXQq8Bgtpks6rhdxVyN31gNfeqv97JGuf5U3ix44veJ0Bmy8A7tXz/2hif3lD 8w== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39acyqb4hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 07:20:46 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15M7FFRM072448;
        Tue, 22 Jun 2021 07:20:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 3995pvs9e7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 07:20:45 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15M7KjTr090608;
        Tue, 22 Jun 2021 07:20:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3995pvs9du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 07:20:45 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15M7Kh5w014540;
        Tue, 22 Jun 2021 07:20:43 GMT
Received: from kadam (/102.222.70.252)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Jun 2021 00:20:43 -0700
Date:   Tue, 22 Jun 2021 10:20:36 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        Benjamin Poirier <benjamin.poirier@gmail.com>,
        Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 13/19] staging: qlge: rewrite do while loop as for loop in
 qlge_sem_spinlock
Message-ID: <20210622072036.GK1861@kadam>
References: <20210621134902.83587-1-coiby.xu@gmail.com>
 <20210621134902.83587-14-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621134902.83587-14-coiby.xu@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: 9WdfC9Sv-xDEwWU93ImiyD6OEuWdleHI
X-Proofpoint-ORIG-GUID: 9WdfC9Sv-xDEwWU93ImiyD6OEuWdleHI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 09:48:56PM +0800, Coiby Xu wrote:
> Since wait_count=30 > 0, the for loop is equivalent to do while
> loop. This commit also replaces 100 with UDELAY_DELAY.
> 
> Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> ---
>  drivers/staging/qlge/qlge_main.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> index c5e161595b1f..2d2405be38f5 100644
> --- a/drivers/staging/qlge/qlge_main.c
> +++ b/drivers/staging/qlge/qlge_main.c
> @@ -140,12 +140,13 @@ static int qlge_sem_trylock(struct qlge_adapter *qdev, u32 sem_mask)
>  int qlge_sem_spinlock(struct qlge_adapter *qdev, u32 sem_mask)
>  {
>  	unsigned int wait_count = 30;
> +	int count;
>  
> -	do {
> +	for (count = 0; count < wait_count; count++) {
>  		if (!qlge_sem_trylock(qdev, sem_mask))
>  			return 0;
> -		udelay(100);
> -	} while (--wait_count);
> +		udelay(UDELAY_DELAY);

This is an interesting way to silence the checkpatch udelay warning.  ;)

regards,
dan carpenter

