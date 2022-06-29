Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16AB55F95F
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbiF2Hlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 03:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbiF2Hlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 03:41:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F1236B42;
        Wed, 29 Jun 2022 00:41:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656488510; x=1688024510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=hRLWAheTUgpMqJ+CTyhb8q72eqCf5jXCD+qdlPmQdX8=;
  b=V7EsYYr9EIij1ip70+OQMY/gzrh5wyGiKcYp8AWCHb25bOJrQa8ldVVA
   WjfiGM9RSi7+O2v6aTzjnGFtciC06e+wwz660J8d1fRqDhDUuFa+GCisT
   rKUaoFvcqeLu972MEnNCCaodyFq5KFw65hrEObpxXK1USTMOqGTNjghk1
   M6eAb7r6RhwTd49jKSf+itMDaZ5Gu/jHoVMqNBN++BYhLvCzxTurIoN9M
   /3H0k+pz3CbrRrMwvdgEhSQ7BUW5H6fpDqV6CtG6BHjQGM7QYyLOK833q
   sD1PkwJUKQH1n3D/+a5t4ubmQSAULxHZs8gKZv4cjGcBr80q05Z6ghIMA
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="307444900"
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="307444900"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 00:41:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,230,1650956400"; 
   d="scan'208";a="733074160"
Received: from kuha.fi.intel.com ([10.237.72.185])
  by fmsmga001.fm.intel.com with SMTP; 29 Jun 2022 00:40:24 -0700
Received: by kuha.fi.intel.com (sSMTP sendmail emulation); Wed, 29 Jun 2022 10:40:23 +0300
Date:   Wed, 29 Jun 2022 10:40:23 +0300
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     Wolfram Sang <wsa@kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Russell King <linux@armlinux.org.uk>,
        Scott Wood <oss@buserror.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Robin van der Gracht <robin@protonic.nl>,
        Miguel Ojeda <ojeda@kernel.org>,
        Corey Minyard <minyard@acm.org>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Phong LE <ple@baylibre.com>,
        Adrien Grassein <adrien.grassein@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        Martin Donnelly <martin.donnelly@ge.com>,
        Martyn Welch <martyn.welch@collabora.co.uk>,
        Douglas Anderson <dianders@chromium.org>,
        Stefan Mavrodiev <stefan@olimex.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Florian Fainelli <f.fainelli@gmail.com>, Broad@vger.kernel.org
Subject: Re: [PATCH 6/6] i2c: Make remove callback return void
Message-ID: <YrwB5xPKZmHlXzrC@kuha.fi.intel.com>
References: <20220628140313.74984-1-u.kleine-koenig@pengutronix.de>
 <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 04:03:12PM +0200, Uwe Kleine-König wrote:
> diff --git a/drivers/usb/typec/hd3ss3220.c b/drivers/usb/typec/hd3ss3220.c
> index cd47c3597e19..2a58185fb14c 100644
> --- a/drivers/usb/typec/hd3ss3220.c
> +++ b/drivers/usb/typec/hd3ss3220.c
> @@ -245,14 +245,12 @@ static int hd3ss3220_probe(struct i2c_client *client,
>  	return ret;
>  }
>  
> -static int hd3ss3220_remove(struct i2c_client *client)
> +static void hd3ss3220_remove(struct i2c_client *client)
>  {
>  	struct hd3ss3220 *hd3ss3220 = i2c_get_clientdata(client);
>  
>  	typec_unregister_port(hd3ss3220->port);
>  	usb_role_switch_put(hd3ss3220->role_sw);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id dev_ids[] = {
> diff --git a/drivers/usb/typec/mux/fsa4480.c b/drivers/usb/typec/mux/fsa4480.c
> index 6184f5367190..d6495e533e58 100644
> --- a/drivers/usb/typec/mux/fsa4480.c
> +++ b/drivers/usb/typec/mux/fsa4480.c
> @@ -181,14 +181,12 @@ static int fsa4480_probe(struct i2c_client *client)
>  	return 0;
>  }
>  
> -static int fsa4480_remove(struct i2c_client *client)
> +static void fsa4480_remove(struct i2c_client *client)
>  {
>  	struct fsa4480 *fsa = i2c_get_clientdata(client);
>  
>  	typec_mux_unregister(fsa->mux);
>  	typec_switch_unregister(fsa->sw);
> -
> -	return 0;
>  }
>  
>  static const struct i2c_device_id fsa4480_table[] = {
> diff --git a/drivers/usb/typec/mux/pi3usb30532.c b/drivers/usb/typec/mux/pi3usb30532.c
> index 6ce9f282594e..1cd388b55c30 100644
> --- a/drivers/usb/typec/mux/pi3usb30532.c
> +++ b/drivers/usb/typec/mux/pi3usb30532.c
> @@ -160,13 +160,12 @@ static int pi3usb30532_probe(struct i2c_client *client)
>  	return 0;
>  }
>  
> -static int pi3usb30532_remove(struct i2c_client *client)
> +static void pi3usb30532_remove(struct i2c_client *client)
>  {
>  	struct pi3usb30532 *pi = i2c_get_clientdata(client);
>  
>  	typec_mux_unregister(pi->mux);
>  	typec_switch_unregister(pi->sw);
> -	return 0;
>  }
>  
>  static const struct i2c_device_id pi3usb30532_table[] = {
> diff --git a/drivers/usb/typec/rt1719.c b/drivers/usb/typec/rt1719.c
> index f1b698edd7eb..ea8b700b0ceb 100644
> --- a/drivers/usb/typec/rt1719.c
> +++ b/drivers/usb/typec/rt1719.c
> @@ -930,14 +930,12 @@ static int rt1719_probe(struct i2c_client *i2c)
>  	return ret;
>  }
>  
> -static int rt1719_remove(struct i2c_client *i2c)
> +static void rt1719_remove(struct i2c_client *i2c)
>  {
>  	struct rt1719_data *data = i2c_get_clientdata(i2c);
>  
>  	typec_unregister_port(data->port);
>  	usb_role_switch_put(data->role_sw);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id __maybe_unused rt1719_device_table[] = {
> diff --git a/drivers/usb/typec/stusb160x.c b/drivers/usb/typec/stusb160x.c
> index e7745d1c2a5c..8638f1d39896 100644
> --- a/drivers/usb/typec/stusb160x.c
> +++ b/drivers/usb/typec/stusb160x.c
> @@ -801,7 +801,7 @@ static int stusb160x_probe(struct i2c_client *client)
>  	return ret;
>  }
>  
> -static int stusb160x_remove(struct i2c_client *client)
> +static void stusb160x_remove(struct i2c_client *client)
>  {
>  	struct stusb160x *chip = i2c_get_clientdata(client);
>  
> @@ -823,8 +823,6 @@ static int stusb160x_remove(struct i2c_client *client)
>  
>  	if (chip->main_supply)
>  		regulator_disable(chip->main_supply);
> -
> -	return 0;
>  }
>  
>  static int __maybe_unused stusb160x_suspend(struct device *dev)
> diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
> index 96c55eaf3f80..5e9348f28d50 100644
> --- a/drivers/usb/typec/tcpm/fusb302.c
> +++ b/drivers/usb/typec/tcpm/fusb302.c
> @@ -1771,7 +1771,7 @@ static int fusb302_probe(struct i2c_client *client,
>  	return ret;
>  }
>  
> -static int fusb302_remove(struct i2c_client *client)
> +static void fusb302_remove(struct i2c_client *client)
>  {
>  	struct fusb302_chip *chip = i2c_get_clientdata(client);
>  
> @@ -1783,8 +1783,6 @@ static int fusb302_remove(struct i2c_client *client)
>  	fwnode_handle_put(chip->tcpc_dev.fwnode);
>  	destroy_workqueue(chip->wq);
>  	fusb302_debugfs_exit(chip);
> -
> -	return 0;
>  }
>  
>  static int fusb302_pm_suspend(struct device *dev)
> diff --git a/drivers/usb/typec/tcpm/tcpci.c b/drivers/usb/typec/tcpm/tcpci.c
> index f33e08eb7670..c48fca60bb06 100644
> --- a/drivers/usb/typec/tcpm/tcpci.c
> +++ b/drivers/usb/typec/tcpm/tcpci.c
> @@ -869,7 +869,7 @@ static int tcpci_probe(struct i2c_client *client,
>  	return 0;
>  }
>  
> -static int tcpci_remove(struct i2c_client *client)
> +static void tcpci_remove(struct i2c_client *client)
>  {
>  	struct tcpci_chip *chip = i2c_get_clientdata(client);
>  	int err;
> @@ -880,8 +880,6 @@ static int tcpci_remove(struct i2c_client *client)
>  		dev_warn(&client->dev, "Failed to disable irqs (%pe)\n", ERR_PTR(err));
>  
>  	tcpci_unregister_port(chip->tcpci);
> -
> -	return 0;
>  }
>  
>  static const struct i2c_device_id tcpci_id[] = {
> diff --git a/drivers/usb/typec/tcpm/tcpci_maxim.c b/drivers/usb/typec/tcpm/tcpci_maxim.c
> index df2505570f07..a11be5754128 100644
> --- a/drivers/usb/typec/tcpm/tcpci_maxim.c
> +++ b/drivers/usb/typec/tcpm/tcpci_maxim.c
> @@ -493,14 +493,12 @@ static int max_tcpci_probe(struct i2c_client *client, const struct i2c_device_id
>  	return ret;
>  }
>  
> -static int max_tcpci_remove(struct i2c_client *client)
> +static void max_tcpci_remove(struct i2c_client *client)
>  {
>  	struct max_tcpci_chip *chip = i2c_get_clientdata(client);
>  
>  	if (!IS_ERR_OR_NULL(chip->tcpci))
>  		tcpci_unregister_port(chip->tcpci);
> -
> -	return 0;
>  }
>  
>  static const struct i2c_device_id max_tcpci_id[] = {
> diff --git a/drivers/usb/typec/tcpm/tcpci_rt1711h.c b/drivers/usb/typec/tcpm/tcpci_rt1711h.c
> index b56a0880a044..9ad4924b4ba7 100644
> --- a/drivers/usb/typec/tcpm/tcpci_rt1711h.c
> +++ b/drivers/usb/typec/tcpm/tcpci_rt1711h.c
> @@ -263,12 +263,11 @@ static int rt1711h_probe(struct i2c_client *client,
>  	return 0;
>  }
>  
> -static int rt1711h_remove(struct i2c_client *client)
> +static void rt1711h_remove(struct i2c_client *client)
>  {
>  	struct rt1711h_chip *chip = i2c_get_clientdata(client);
>  
>  	tcpci_unregister_port(chip->tcpci);
> -	return 0;
>  }
>  
>  static const struct i2c_device_id rt1711h_id[] = {
> diff --git a/drivers/usb/typec/tipd/core.c b/drivers/usb/typec/tipd/core.c
> index dfbba5ae9487..b637e8b378b3 100644
> --- a/drivers/usb/typec/tipd/core.c
> +++ b/drivers/usb/typec/tipd/core.c
> @@ -857,15 +857,13 @@ static int tps6598x_probe(struct i2c_client *client)
>  	return ret;
>  }
>  
> -static int tps6598x_remove(struct i2c_client *client)
> +static void tps6598x_remove(struct i2c_client *client)
>  {
>  	struct tps6598x *tps = i2c_get_clientdata(client);
>  
>  	tps6598x_disconnect(tps, 0);
>  	typec_unregister_port(tps->port);
>  	usb_role_switch_put(tps->role_sw);
> -
> -	return 0;
>  }
>  
>  static const struct of_device_id tps6598x_of_match[] = {
> diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
> index 6db7c8ddd51c..920b7e743f56 100644
> --- a/drivers/usb/typec/ucsi/ucsi_ccg.c
> +++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
> @@ -1398,7 +1398,7 @@ static int ucsi_ccg_probe(struct i2c_client *client,
>  	return status;
>  }
>  
> -static int ucsi_ccg_remove(struct i2c_client *client)
> +static void ucsi_ccg_remove(struct i2c_client *client)
>  {
>  	struct ucsi_ccg *uc = i2c_get_clientdata(client);
>  
> @@ -1408,8 +1408,6 @@ static int ucsi_ccg_remove(struct i2c_client *client)
>  	ucsi_unregister(uc->ucsi);
>  	ucsi_destroy(uc->ucsi);
>  	free_irq(uc->irq, uc);
> -
> -	return 0;
>  }
>  
>  static const struct i2c_device_id ucsi_ccg_device_id[] = {
> diff --git a/drivers/usb/typec/wusb3801.c b/drivers/usb/typec/wusb3801.c
> index e63509f8b01e..3cc7a15ecbd3 100644
> --- a/drivers/usb/typec/wusb3801.c
> +++ b/drivers/usb/typec/wusb3801.c
> @@ -399,7 +399,7 @@ static int wusb3801_probe(struct i2c_client *client)
>  	return ret;
>  }
>  
> -static int wusb3801_remove(struct i2c_client *client)
> +static void wusb3801_remove(struct i2c_client *client)
>  {
>  	struct wusb3801 *wusb3801 = i2c_get_clientdata(client);
>  
> @@ -411,8 +411,6 @@ static int wusb3801_remove(struct i2c_client *client)
>  
>  	if (wusb3801->vbus_on)
>  		regulator_disable(wusb3801->vbus_supply);
> -
> -	return 0;
>  }

Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>

-- 
heikki
