Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE22645AB2
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbiLGNVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLGNVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:21:14 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028A01408A;
        Wed,  7 Dec 2022 05:21:12 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id kw15so10491512ejc.10;
        Wed, 07 Dec 2022 05:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Oue94+Ik3eRv7cdb5g71pdk/j0xTlBWe2Mf1/zKEImI=;
        b=H3muc0jE053evwd95r//iMIDA0r9fh85T9SrJO9RMnfjaaEilI02fYT4y90uKCrER9
         cch1B/7qotOMQdGfCRcEGmnN6G/EN4l0hbiBeQdpHo03hYA5BWdJJGK/9P/6hUSYeRyO
         mdaaD5HU2eJAAwaaTR1hkHujW+FfZP3Yxy/848qutO6K4k9uY93UwU5jxNAOXaxze/bV
         ZgsSXeLP3eC4qEuJuQoPksZWxe4zAjv/xRNKZ3TdIEq+dkoy4ovMGVdCSpA99rdTpUR4
         rz+tH7eLvAfIII7Boq79rPmEljRGJET7lhoKn6mh7hrIZxvSlu5zsl6+xJXTbLsVKqYg
         LE0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oue94+Ik3eRv7cdb5g71pdk/j0xTlBWe2Mf1/zKEImI=;
        b=fSfL5k8hKav5R/5WU9VKUjVHu6s5xnUpmHCGfGvZkgM4j4PySCxO90ZNZVYXArZUsw
         vDv72OlKCLSS3Hw8VMnEt36rVbVU9s+P/hN0QHJ8uzk14FHU4KqWa0Cd/mlG2NeEy61S
         KwQwLgMdEgewd3iS/CMe60u0Cj74p2NjQ+86ucDqiObHvEUErkuVeZILb+hLzAMU6rij
         M9p9CSEOMzjEtCyhONUT+Zg2OtPzrae/DjRCrEy+ti7o1onPsVIQtBXYyLhvlPe2gskE
         Vd/D9GwtD4kgItNwerv7U61KRudZe62OZ51y6Tz5E9mLD9hBRaVyXULri8Nq1/SMpwkW
         3SWA==
X-Gm-Message-State: ANoB5pn66qITppXnUXJxsnUOy23HSPFJZ1IRjxvWP3pmkSL5WSOvjVGf
        nnxoZSr4EJv40smyauwNUdE=
X-Google-Smtp-Source: AA0mqf4kelmdfcsQEqZDqeJZLIam9TGWR0kzr38FgakyfUf+P2hxBMT1ddbfCFpEA7BpInWYnYFMYA==
X-Received: by 2002:a17:907:c296:b0:78d:fd4e:5da6 with SMTP id tk22-20020a170907c29600b0078dfd4e5da6mr341117ejc.26.1670419270531;
        Wed, 07 Dec 2022 05:21:10 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id vk2-20020a170907cbc200b007bf5250b515sm8535888ejc.29.2022.12.07.05.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:21:10 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:21:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rakesh.Sankaranarayanan@microchip.com
Cc:     kuba@kernel.org, andrew@lunn.ch, davem@davemloft.net,
        Woojung.Huh@microchip.com, linux-kernel@vger.kernel.org,
        f.fainelli@gmail.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, edumazet@google.com,
        pabeni@redhat.com, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC Patch net-next 3/5] net: dsa: microchip: add eth mac
 grouping for ethtool statistics
Message-ID: <20221207132107.3lefphupzpty4uoa@skbuf>
References: <20221130132902.2984580-1-rakesh.sankaranarayanan@microchip.com>
 <20221130132902.2984580-4-rakesh.sankaranarayanan@microchip.com>
 <20221201200230.0f1054fe@kernel.org>
 <6c1a53a825bee2b22f7e532885e6e777685c0726.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6c1a53a825bee2b22f7e532885e6e777685c0726.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 11:53:33AM +0000, Rakesh.Sankaranarayanan@microchip.com wrote:
> Hi Jakub,
> 
> Thanks for the review comment.
> 
> On Thu, 2022-12-01 at 20:02 -0800, Jakub Kicinski wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > know the content is safe
> > 
> > On Wed, 30 Nov 2022 18:59:00 +0530 Rakesh Sankaranarayanan wrote:
> > > +     mac_stats->FramesTransmittedOK = ctr[ksz9477_tx_mcast] +
> > > +                                      ctr[ksz9477_tx_bcast] +
> > > +                                      ctr[ksz9477_tx_ucast] +
> > > +                                      ctr[ksz9477_tx_pause];
> > 
> > do control frames count towards FramesTransmittedOK?
> > Please check the standard I don't recall.
> > 
> Yeah, I will check with the documentation.

Oleksij said that the hardware counts pause frames for the byte
counters, so at least for consistency, they should be counted in frame
counters too.
https://patchwork.kernel.org/project/netdevbpf/patch/20221205052904.2834962-1-o.rempel@pengutronix.de/
