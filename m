Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA665510CEB
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 01:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245577AbiD0AAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 20:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356358AbiD0AA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 20:00:29 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA784E3A2;
        Tue, 26 Apr 2022 16:57:17 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k23so206393ejd.3;
        Tue, 26 Apr 2022 16:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=226dFbtrPQIoFHWbTajhuZZyDWbBc2bREA3l7+aGRpU=;
        b=Jyzw4HuxsKM7Hu+oPvA2i5DvNqRk3iJheUk8PsqA2PIrvnvNCRSR1hzW0XzAc4d3Le
         r086uigB4IgWOAazr7oCU9tIV0vsFl06lDNlg18LnTCGFDA852D5XoskoSHo8ejGhIWC
         xi2CzU6rAlrTnAzIs7Zd2LqyjaSpLSL3McpZMconGThl3h091s0deH9lAok66IdeNwmE
         VbyNguKPd5AiQxpyicpPG5HbyJn2NqXd7lgVhrW/yaDlv4e2kocDGkfPzhMO7McgROyK
         wyn/6fOfCWxVtCtS/1yoy3m3RTFFc3tFxTZkbbr18tQ4wQCGzNorRBFZQ+qXcWDvgwqr
         3bgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=226dFbtrPQIoFHWbTajhuZZyDWbBc2bREA3l7+aGRpU=;
        b=lC+QzYNemueBQZ4g0jPnSDBFX5rUyw3C1NutDt6lKRKGRWnu/5l/EIf6o8a8qKzdR6
         PiBFyEpLR7p0C/LIDtG83clAEqxA2Dsf3nGpgub9HyzLpeePHua5SyUUz0rAdJFlYrze
         6eywIgb9D76LkKFII4t02pjkAcjZ8jYq3L6IYLlCK1NJuoaLr9SKdHmTsy/YE16dwKHN
         4EzNXYO56Bwy+6v8AdezI9sQgOzjLnNICI+gJYLm8/hS5Wn6UsrGefFB2YGbAs5DsSEu
         4Kp8S/Kn/F0EMbDLsvQpvHrULckn+nHUYHN/39c6uybtyjpMEa9lSSCG605oarBoVW9Y
         9Cpg==
X-Gm-Message-State: AOAM533chH8iRpfUZDuAfmED6poevwKujD1yUwItM2AMksaFok6VV+Rv
        UnD5wCyY+NZ1vPa4koPpmxE=
X-Google-Smtp-Source: ABdhPJyMFeRbcOlg0p93A4LH81VJTxOaIx6gVJpFUK3HMs+pAGtQLor2HZVvCnGiP8TcxEb+T95y8Q==
X-Received: by 2002:a17:906:7c96:b0:6f3:b6c4:7b2 with SMTP id w22-20020a1709067c9600b006f3b6c407b2mr4497132ejo.676.1651017436376;
        Tue, 26 Apr 2022 16:57:16 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id r13-20020a508d8d000000b00425d3555fc6sm5934416edh.30.2022.04.26.16.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 16:57:15 -0700 (PDT)
Date:   Wed, 27 Apr 2022 02:57:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v1 1/3] net: dsa: mt753x: make reset optional
Message-ID: <20220426235713.engzue7ujwqjdyjc@skbuf>
References: <20220426134924.30372-1-linux@fw-web.de>
 <20220426134924.30372-2-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426134924.30372-2-linux@fw-web.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 03:49:22PM +0200, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Currently a reset line is required, but on BPI-R2-Pro board
> this reset is shared with the gmac and prevents the switch to
> be initialized because mdio is not ready fast enough after
> the reset.
> 
> So make the reset optional to allow shared reset lines.

What does it mean "to allow shared reset lines"? Allow as in "allow them
to sit there, unused"?

> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
>  drivers/net/dsa/mt7530.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 19f0035d4410..ccf4cb944167 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2134,7 +2134,7 @@ mt7530_setup(struct dsa_switch *ds)
>  		reset_control_assert(priv->rstc);
>  		usleep_range(1000, 1100);
>  		reset_control_deassert(priv->rstc);
> -	} else {
> +	} else if (priv->reset) {

I don't really understand this patch. gpiod_set_value_cansleep() can
tolerate NULL GPIO descriptors.

>  		gpiod_set_value_cansleep(priv->reset, 0);
>  		usleep_range(1000, 1100);
>  		gpiod_set_value_cansleep(priv->reset, 1);
> @@ -2276,7 +2276,7 @@ mt7531_setup(struct dsa_switch *ds)
>  		reset_control_assert(priv->rstc);
>  		usleep_range(1000, 1100);
>  		reset_control_deassert(priv->rstc);
> -	} else {
> +	} else if (priv->reset) {
>  		gpiod_set_value_cansleep(priv->reset, 0);
>  		usleep_range(1000, 1100);
>  		gpiod_set_value_cansleep(priv->reset, 1);
> @@ -3272,8 +3272,7 @@ mt7530_probe(struct mdio_device *mdiodev)
>  		priv->reset = devm_gpiod_get_optional(&mdiodev->dev, "reset",
>  						      GPIOD_OUT_LOW);
>  		if (IS_ERR(priv->reset)) {
> -			dev_err(&mdiodev->dev, "Couldn't get our reset line\n");
> -			return PTR_ERR(priv->reset);
> +			dev_warn(&mdiodev->dev, "Couldn't get our reset line\n");

I certainly don't understand why you're suppressing the pointer-encoded
errors here. The function used is devm_gpiod_get_optional(), which
returns NULL for a missing reset-gpios, not IS_ERR(something). The
IS_ERR(something) is actually important to not ignore, maybe it's
IS_ERR(-EPROBE_DEFER). And this change breaks waiting for the descriptor
to become available.

>  		}
>  	}
>  
> -- 
> 2.25.1
> 

So what doesn't work without this patch, exactly?
