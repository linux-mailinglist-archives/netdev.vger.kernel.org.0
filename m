Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74BE0FAF3E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 12:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfKMLCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 06:02:55 -0500
Received: from cloudserver094114.home.pl ([79.96.170.134]:45734 "EHLO
        cloudserver094114.home.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726165AbfKMLCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 06:02:55 -0500
Received: from 79.184.253.153.ipv4.supernova.orange.pl (79.184.253.153) (HELO kreacher.localnet)
 by serwer1319399.home.pl (79.96.170.134) with SMTP (IdeaSmtpServer 0.83.292)
 id f9c9ec80f02b64f5; Wed, 13 Nov 2019 12:02:52 +0100
From:   "Rafael J. Wysocki" <rjw@rjwysocki.net>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Breno =?ISO-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David@rox.of.borg, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Casey Leedom <leedom@chelsio.com>,
        Shannon Nelson <snelson@pensando.io>,
        Pensando Drivers <drivers@pensando.io>,
        Kevin Hilman <khilman@kernel.org>, Nishanth Menon <nm@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] power: avs: smartreflex: Remove superfluous cast in debugfs_create_file() call
Date:   Wed, 13 Nov 2019 12:02:51 +0100
Message-ID: <2168390.66xqsT3ub9@kreacher>
In-Reply-To: <20191021145149.31657-5-geert+renesas@glider.be>
References: <20191021145149.31657-1-geert+renesas@glider.be> <20191021145149.31657-5-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, October 21, 2019 4:51:48 PM CET Geert Uytterhoeven wrote:
> There is no need to cast a typed pointer to a void pointer when calling
> a function that accepts the latter.  Remove it, as the cast prevents
> further compiler checks.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/power/avs/smartreflex.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
> index 4684e7df833a81e9..5376f3d22f31eade 100644
> --- a/drivers/power/avs/smartreflex.c
> +++ b/drivers/power/avs/smartreflex.c
> @@ -905,7 +905,7 @@ static int omap_sr_probe(struct platform_device *pdev)
>  	sr_info->dbg_dir = debugfs_create_dir(sr_info->name, sr_dbg_dir);
>  
>  	debugfs_create_file("autocomp", S_IRUGO | S_IWUSR, sr_info->dbg_dir,
> -			    (void *)sr_info, &pm_sr_fops);
> +			    sr_info, &pm_sr_fops);
>  	debugfs_create_x32("errweight", S_IRUGO, sr_info->dbg_dir,
>  			   &sr_info->err_weight);
>  	debugfs_create_x32("errmaxlimit", S_IRUGO, sr_info->dbg_dir,
> 

Applying as 5.5 material, thanks!




