Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8401560BA6
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 23:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiF2VUd convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 29 Jun 2022 17:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiF2VU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 17:20:29 -0400
Received: from hostingweb31-40.netsons.net (hostingweb31-40.netsons.net [89.40.174.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C99113F79;
        Wed, 29 Jun 2022 14:20:28 -0700 (PDT)
Received: from [37.161.29.0] (port=43545 helo=[192.168.131.30])
        by hostingweb31.netsons.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <luca@lucaceresoli.net>)
        id 1o6f6m-000BzC-Qd;
        Wed, 29 Jun 2022 23:20:25 +0200
Message-ID: <d682fb60-c254-f89e-5d6d-cdf7aa752939@lucaceresoli.net>
Date:   Wed, 29 Jun 2022 23:20:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
From:   Luca Ceresoli <luca@lucaceresoli.net>
Subject: Re: [PATCH 6/6] i2c: Make remove callback return void
To:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>
Cc:     linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        openipmi-developer@lists.sourceforge.net,
        linux-integrity@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-gpio@vger.kernel.org,
        dri-devel@lists.freedesktop.org, chrome-platform@lists.linux.dev,
        linux-rpi-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        patches@opensource.cirrus.com, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        acpi4asus-user@lists.sourceforge.net, linux-pm@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kasan-dev@googlegroups.com,
        linux-mediatek@lists.infradead.org
References: <20220628140313.74984-1-u.kleine-koenig@pengutronix.de>
 <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
Content-Language: en-US
In-Reply-To: <20220628140313.74984-7-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hostingweb31.netsons.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - lucaceresoli.net
X-Get-Message-Sender-Via: hostingweb31.netsons.net: authenticated_id: luca@lucaceresoli.net
X-Authenticated-Sender: hostingweb31.netsons.net: luca@lucaceresoli.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

[keeping only individuals and lists in Cc to avoid bounces]

On 28/06/22 16:03, Uwe Kleine-König wrote:
> From: Uwe Kleine-König <uwe@kleine-koenig.org>
> 
> The value returned by an i2c driver's remove function is mostly ignored.
> (Only an error message is printed if the value is non-zero that the
> error is ignored.)
> 
> So change the prototype of the remove function to return no value. This
> way driver authors are not tempted to assume that passing an error to
> the upper layer is a good idea. All drivers are adapted accordingly.
> There is no intended change of behaviour, all callbacks were prepared to
> return 0 before.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

For versaclock:

> diff --git a/drivers/clk/clk-versaclock5.c b/drivers/clk/clk-versaclock5.c
> index e7be3e54b9be..657493ecce4c 100644
> --- a/drivers/clk/clk-versaclock5.c
> +++ b/drivers/clk/clk-versaclock5.c
> @@ -1138,7 +1138,7 @@ static int vc5_probe(struct i2c_client *client)
>  	return ret;
>  }
>  
> -static int vc5_remove(struct i2c_client *client)
> +static void vc5_remove(struct i2c_client *client)
>  {
>  	struct vc5_driver_data *vc5 = i2c_get_clientdata(client);
>  
> @@ -1146,8 +1146,6 @@ static int vc5_remove(struct i2c_client *client)
>  
>  	if (vc5->chip_info->flags & VC5_HAS_INTERNAL_XTAL)
>  		clk_unregister_fixed_rate(vc5->pin_xin);
> -
> -	return 0;
>  }
>  
>  static int __maybe_unused vc5_suspend(struct device *dev)

Reviewed-by: Luca Ceresoli <luca@lucaceresoli.net>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

-- 
Luca
