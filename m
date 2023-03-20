Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444D36C1C16
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjCTQkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232137AbjCTQjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:39:15 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7764112BCC;
        Mon, 20 Mar 2023 09:34:00 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o11-20020a05600c4fcb00b003eb33ea29a8so7910868wmq.1;
        Mon, 20 Mar 2023 09:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679330039;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cX8KlgrWKmB3FXjHkapylAo4MCiAP3BWza2EtPBzxYU=;
        b=eB866SGqHanTUqtUTJuZGjwSngVrG6odH5UrI3TYammU7sWeqF8Q9qzUOsXltCwNtt
         kRGYYT23O0ENMTWCQr89/lHlOB7ihamXET6n91ty11GCX8/D5EQcGHv4bzfR0WaJAXhs
         vNt2YEEiEgfanzTqTN9lmhLBmhs0FxR1Yq5JfCjhRWRVCMmmzQ7zGCQnoEiDscieDg9A
         uuLGjjCeuE/hak0YLf45HdVWSFJah5uh2tjh5KjGE5zEy6zzmrhijqlTkJmDWTMfW/ts
         8D9NkZ9fHHBEH/8k/GtX5YpbASkPU3kxDIQnRK4uynfbdb7yXVk4C8T28Qg37GagO8PE
         WUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679330039;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cX8KlgrWKmB3FXjHkapylAo4MCiAP3BWza2EtPBzxYU=;
        b=a/pV0IlPjZ45NjPcvSgu99FF5qXtdsQu6n3sUa1qGbVGQXYEhB4V5PLgbZD6DNrOCd
         Hl6MYhWCv5QCwxme3WKTZ9dqe3Y84iikRd0ntCiajYt5MPHpBTTqbjRSvXbe4hqLonKb
         R2+sicDSYFmC7eloMpjqxDZJP19GCqFAxlRZyPGwpiMoIJierK1RAfeGHHgKZw3KcmHY
         dgFVFORS9yZjQOSpjIXkYLAvjB+GkFydc6uCQE6ehE8mzzTzWBPh0NWzKL4uqJ0vroQE
         At82syINkGj2F14CAw0Yuysf4oAPw9jXYhIPNIuEr2pZTrz2ws0E0DCXDpz/M0ZdEvaJ
         sxbQ==
X-Gm-Message-State: AO0yUKV55CJZcaPJomVjOKX4PW1uQ+RUglMIh7KO0MX9B4P8Tee30rto
        hYTYE2cD3Qxku/1fV7EysoY=
X-Google-Smtp-Source: AK7set9o+8tkdMu+iaV/b3SeymKtnfydzAmGbhL7FTYNudrs6Z0syHqO0oNJnFGDIXVqSYGwXvTwaQ==
X-Received: by 2002:a05:600c:2114:b0:3ed:290b:dc68 with SMTP id u20-20020a05600c211400b003ed290bdc68mr151068wml.12.1679330038574;
        Mon, 20 Mar 2023 09:33:58 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id p11-20020a05600c1d8b00b003daffc2ecdesm16865837wms.13.2023.03.20.09.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 09:33:58 -0700 (PDT)
Message-ID: <64188af6.050a0220.c5fe1.1d96@mx.google.com>
X-Google-Original-Message-ID: <ZBiK9JXC7UxvQuJG@Ansuel-xps.>
Date:   Mon, 20 Mar 2023 17:33:56 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 02/15] net: dsa: qca8k: add LEDs basic support
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-3-ansuelsmth@gmail.com>
 <ZBiKDX/WJPfJey/+@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBiKDX/WJPfJey/+@localhost.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 05:30:05PM +0100, Michal Kubiak wrote:
> On Sun, Mar 19, 2023 at 08:18:01PM +0100, Christian Marangi wrote:
> > Add LEDs basic support for qca8k Switch Family by adding basic
> > brightness_set() support.
> > 
> > Since these LEDs refelect port status, the default label is set to
> > ":port". DT binding should describe the color, function and number of
> > the leds using standard LEDs api.
> > 
> > These LEDs supports only blocking variant of the brightness_set()
> > function since they can sleep during access of the switch leds to set
> > the brightness.
> > 
> > While at it add to the qca8k header file each mode defined by the Switch
> > Documentation for future use.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > ---
> 
> Hi Christian,
> 
> The patch looks good to me. I just found one nitpick in the comment.
> 
> Thanks,
> Michal
> 
> > +static int
> > +qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
> > +{
> > +	struct fwnode_handle *led = NULL, *leds = NULL;
> > +	struct led_init_data init_data = { };
> > +	enum led_default_state state;
> > +	struct qca8k_led *port_led;
> > +	int led_num, led_index;
> > +	int ret;
> > +
> > +	leds = fwnode_get_named_child_node(port, "leds");
> > +	if (!leds) {
> > +		dev_dbg(priv->dev, "No Leds node specified in device tree for port %d!\n",
> > +			port_num);
> > +		return 0;
> > +	}
> > +
> > +	fwnode_for_each_child_node(leds, led) {
> > +		/* Reg represent the led number of the port.
> > +		 * Each port can have at least 3 leds attached
> 
> Nitpick: "at least" -> "at most"
>

Oh god... I added the extra comment and totally missed the other.
Sorry!

Btw ok for the description of the LED mapping? It's a bit complex so
tried to do my best to describe them.

-- 
	Ansuel
