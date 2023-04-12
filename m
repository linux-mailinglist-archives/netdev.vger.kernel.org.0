Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D39A46E0F7C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbjDMOBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjDMOBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:01:46 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBA211A;
        Thu, 13 Apr 2023 07:01:45 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v14-20020a05600c470e00b003f06520825fso13663741wmo.0;
        Thu, 13 Apr 2023 07:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681394504; x=1683986504;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uOHTamwKNL40GhmSChgfj+zLAbo8CbA29L61cgq0bpE=;
        b=G845KAhU6xI8AzEGleuaSgyKc/tkw+0l10Pgl2ql2iERI016euWl0ztj2Jtku9EWjE
         XzgnPXYm2rJ5Z6MWj7nAYfC0TKlTVvu7bv4z2MqcWqrmetcjpIngUnp/cep2byHpZyYy
         wlgwVKJvF7k2/EDrncZLO2rFwkZAogjbddoEBeGYvu6o0Qt2ztmcWk4RNW8DLOcKnIK3
         wfWN5QSsuK82eE17Ihl+xdy7oZFgAyCUMSRmAUTwxWQ7A1LgOU7NiKfhUcyIPRxR7+WT
         w79ZWayhGjAHDH+kh6FgI26OuDeliCOPiPiMeY81WyzZd8y0tmrAOQb0oo6BPUmj+3d6
         OJ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681394504; x=1683986504;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uOHTamwKNL40GhmSChgfj+zLAbo8CbA29L61cgq0bpE=;
        b=AthJ9/Sotjs+isjPGgkGbArTZNjrRsrD+9EBCQqbz+b5/KRqULw8Bkihm8OZMdckgr
         qLGfvHVz4S87cBU3bUwWbA6WYmN5Xh7Qw5CQ3k1ixDDlNwQe40Plgp3tWGd6jVwV3rLy
         kyW5nfe/k4KtcLRejrkAiDcxnRZQB92mQeCvEhVWXIb+e29Hk4L6ER5FODtm8vTyfMsO
         trrQ1wg5O1OtZhpKidxtbk303ClWXZkh3SvWkHctDTvAnvcsVITSb0PT+UafeMPF5WCT
         5TndlXBy6EK1AkwABqsy7ZILNmNSxhM01K6dJOdbgp5btEEW6ePLesOmso5g0kP9KHfI
         356A==
X-Gm-Message-State: AAQBX9c/O4odkYGUSvMy/hzMFeeNBCWBVlhxkJXCPTzMUmO4vLYqJnix
        50uYQYFxFfQ1EqYbfF1onns=
X-Google-Smtp-Source: AKy350aCOeLGVdCGwcMkMytZAVJF3k2hKosfOFGhq5NwBEjscTYcs49JjHc5JD4A851zKXAccyv3nw==
X-Received: by 2002:a05:600c:2304:b0:3f0:7f07:e617 with SMTP id 4-20020a05600c230400b003f07f07e617mr1969779wmo.8.1681394503378;
        Thu, 13 Apr 2023 07:01:43 -0700 (PDT)
Received: from Ansuel-xps. (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.gmail.com with ESMTPSA id k17-20020a7bc411000000b003f09fe8312csm1909489wmi.20.2023.04.13.07.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 07:01:42 -0700 (PDT)
Message-ID: <64380b46.7b0a0220.978a.1eb4@mx.google.com>
X-Google-Original-Message-ID: <ZDc6lf4+qd0Fm2j+@Ansuel-xps.>
Date:   Thu, 13 Apr 2023 01:11:17 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [net-next PATCH v6 06/16] net: phy: phy_device: Call into the
 PHY driver to set LED brightness
References: <20230327141031.11904-1-ansuelsmth@gmail.com>
 <20230327141031.11904-7-ansuelsmth@gmail.com>
 <202ae4b9-8995-474a-1282-876078e15e47@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202ae4b9-8995-474a-1282-876078e15e47@gmail.com>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 06:57:51AM -0700, Florian Fainelli wrote:
> 
> 
> On 3/27/2023 7:10 AM, Christian Marangi wrote:
> > From: Andrew Lunn <andrew@lunn.ch>
> > 
> > Linux LEDs can be software controlled via the brightness file in /sys.
> > LED drivers need to implement a brightness_set function which the core
> > will call. Implement an intermediary in phy_device, which will call
> > into the phy driver if it implements the necessary function.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> > +	int (*led_brightness_set)(struct phy_device *dev,
> > +				  u32 index, enum led_brightness value);
> 
> I think I would have made this an u8, 4 billion LEDs, man, that's a lot!

If andrew is ok we can still consider to reduce it. (but just to joke
about it... A MAN CAN DREAM OF A FULL HD SCREEN ON THEIR OWN SPECIAL
PORT)

-- 
	Ansuel
