Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17C562AF0A
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 00:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238556AbiKOXCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 18:02:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiKOXCO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 18:02:14 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62B512C67B;
        Tue, 15 Nov 2022 15:02:11 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id i10so31281867ejg.6;
        Tue, 15 Nov 2022 15:02:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i1bi2KgOik0BJgrqTOkLO626dlyRqNG/k0Pt8yh+GI8=;
        b=c7hinHZD13uIeXD27stsQQGXPwFZhVLI48+Zy3BvZRiNxOzold4KncLYVDUC7PyVqU
         D/aiFKPiryug78Cf7+bhbkrK1GXs10x+FkfrryLTT9ORfRixyyaWAd002zhMBntDIJv9
         /VY8dq7c8UPOUnp+d+OuCbokWQj69rxJ141BruXSiwIqm/6J10I74PAX07TzgahA8imh
         N46smD8qJrxEzvEQHaCOF+Wy1q8BWrmsHLysuasahWTi+LCVOQgKjjT28ER5OWHMw658
         fGbyxuzqDBXFe5Z75e0Ms5+lREciyWTEHC399z8GY3O+6DpFvjDRl6dt3MC4mmN/40eC
         8VEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i1bi2KgOik0BJgrqTOkLO626dlyRqNG/k0Pt8yh+GI8=;
        b=3PV6Gy9eIM3pW2feKvoSKHepM4M6eEpDfhfqOtbCp6LuIyj4YUzK/1tgQjSmtEjXpO
         FsvOOD8Ny5i3ihqJ4H5Y0csQGtxQx3lMqylm2ntA5kf6cqntHXNGoxUWoIFElfLa1Miw
         APyvmrHFgsy7kLinZeabzweoaGRj/tZU8dFXeGTlDMyLpenViLLNVh19rkyBbj5rcMdp
         aRouu8sAC9b0yb1hiI/mhoJ+CPexzBQwVoN8n2Wg0fSL+Fsd6fYjYIQFhnT79XmW1eIm
         LKOZvHcGq6lEEo0L2+Zo0pCfYPUov+r+kEUYgX+Kprt35ySi+ji2HE6oB38nX7qZriqa
         nODQ==
X-Gm-Message-State: ANoB5plgNLrQgNM8Paxnz5tCmAiWApbeTs6rmfVeFo3gjVTBgsX5jeYb
        2087HfZ9uWU2ewEtHUBCs/0=
X-Google-Smtp-Source: AA0mqf7j03zdPFSJZ0f7Hy1McFF3zKaXi5Ry4nVXdAeGk0TxpCmuHEuyBzi4LgD0RRyUr151hpstfA==
X-Received: by 2002:a17:906:4456:b0:7b2:7e7a:11c1 with SMTP id i22-20020a170906445600b007b27e7a11c1mr1436499ejp.684.1668553329925;
        Tue, 15 Nov 2022 15:02:09 -0800 (PST)
Received: from skbuf ([188.26.57.19])
        by smtp.gmail.com with ESMTPSA id f24-20020a17090631d800b0073d81b0882asm6127366ejf.7.2022.11.15.15.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 15:02:09 -0800 (PST)
Date:   Wed, 16 Nov 2022 01:02:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Message-ID: <20221115230207.2e77pifwruzkexbr@skbuf>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf>
 <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 05:46:54PM -0500, Sean Anderson wrote:
> On 11/15/22 17:37, Vladimir Oltean wrote:
> > Was this patch tested and confirmed to do something sane on any platform
> > at all?
> 
> This was mainly intended for Tim to test and see if it fixed his problem.

And that is stated where? Does Tim know he should test it?
If you don't have the certainty that it works, do maintainers know not
to apply it, as many times unfortunately happens when there is no review
comment and the change looks innocuous?

Even if the change works, why would it be a good idea to overwrite some
random registers which are supposed to be configured correctly by the
firmware provided for the board? If the Linux fixup works for one board
with one firmware, how do we know it also works for another board with
the same PHY, but different firmware? Are you willing to take the risk
to break someone's system to find out?

As long as the Aquantia PHY driver doesn't contain all the necessary
steps for bringing the PHY up from a clean slate, but works on top of
what the firmware has done, changes like this make me very uncomfortable
to add any PHY ID to the Aquantia driver. I'd rather leave them with the
Generic C45 driver, even if that means I'll lose interrupt support, rate
matching and things like that.
