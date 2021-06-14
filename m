Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4193A650A
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 13:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhFNLcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 07:32:41 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38572 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234858AbhFNLaj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 07:30:39 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15EBGNoM008371;
        Mon, 14 Jun 2021 11:28:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=UBr0mxXGOr/GU1YsyNaM9bJ9e+absS4JOoW0zLQJXyo=;
 b=Qidcon2UutIn59XAeII/SEUc0ae9kch0lwy6DQOboh+IhZSvGr3bRGbMU5eOz9+O79lF
 xhITHT+afs7LPB1Rr8zSgZdA1AdwbyEK7M4x7M73mG4/H1+Y+cV4KNX1LxYkNP4hWGbD
 QP8RdcChcV8i1r1fOJ96i6j9JRKxRG0AwSFiS3ravuf3QsYKbDcaoOKYT2Nj1Sfs48Ht
 iLLJ5JVYnQSp/cXov8foxVkxNylVe0escf3lSQHSBRNi520RRma9euoQ2lbv85aaUet/
 cJxrV+dHHd8D1idjXKG7fvP7fkQYqCUzhXgq6Ohz/7aKeVXURphPBFwB3/GuKs7EjqMM VQ== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 395y1kr451-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 11:28:28 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15EBNmM0148015;
        Mon, 14 Jun 2021 11:28:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 394mr68w0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 11:28:27 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15EBQthY159302;
        Mon, 14 Jun 2021 11:28:27 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 394mr68vyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Jun 2021 11:28:27 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 15EBSL4J001717;
        Mon, 14 Jun 2021 11:28:21 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 14 Jun 2021 04:28:20 -0700
Date:   Mon, 14 Jun 2021 14:28:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: b53: Fix dereference of null dev
Message-ID: <20210614112812.GL1955@kadam>
References: <20210612144407.60259-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210612144407.60259-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: HcFCDBaJcFp97NqqodYLJviMfx1GWnd_
X-Proofpoint-GUID: HcFCDBaJcFp97NqqodYLJviMfx1GWnd_
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 12, 2021 at 03:44:07PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently pointer priv is dereferencing dev before dev is being null
> checked so a potential null pointer dereference can occur. Fix this
> by only assigning and using priv if dev is not-null.
> 
> Addresses-Coverity: ("Dereference before null check")
> Fixes: 16994374a6fc ("net: dsa: b53: Make SRAB driver manage port interrupts")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/dsa/b53/b53_srab.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/b53/b53_srab.c b/drivers/net/dsa/b53/b53_srab.c
> index aaa12d73784e..e77ac598f859 100644
> --- a/drivers/net/dsa/b53/b53_srab.c
> +++ b/drivers/net/dsa/b53/b53_srab.c
> @@ -629,11 +629,13 @@ static int b53_srab_probe(struct platform_device *pdev)
>  static int b53_srab_remove(struct platform_device *pdev)
>  {
>  	struct b53_device *dev = platform_get_drvdata(pdev);
> -	struct b53_srab_priv *priv = dev->priv;
>  
> -	b53_srab_intr_set(priv, false);
> -	if (dev)
> +	if (dev) {

This is the remove function and "dev" can't be NULL at this point.
Better to just remove the NULL check.

regards,
dan carpenter

