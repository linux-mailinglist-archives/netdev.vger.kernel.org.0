Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47BD69FDB2
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjBVVZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232489AbjBVVZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:25:33 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B6E5457DF;
        Wed, 22 Feb 2023 13:25:31 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id ck15so37211561edb.0;
        Wed, 22 Feb 2023 13:25:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pEqUumKr/EgaUao63hzIzbhv6Q14RxQUL9K8csLNy0c=;
        b=UlO0fTnerpkXyWlH4xzUuvPE57Pp79ZJMylCBCqhx4tgJK8fstRX/0N6rbNHySPNU7
         5kEple5GRiUhhY6Ck7m/AG0oyytSee5aGXaqMVlQ2JYT8Y+oDzfKKmkV6lwE53XGMpwM
         gsuvQvWEWGT8UzCVFLBnHp/4KcdCZc+ubm3yLHmEggPP4AAJBhxOdJrmU4C8GjCSh6Wa
         FL9UdzKUHUvKj+LfPexrhVpBmUIuN2qz2vd0JJqNrgRShDxL0MYCsJ04c1Z8TZfOpATN
         reUwvpAmyDhDExI6nADX1EnyhIWxsD2rZeFc0uwMNEwVv+sYQcZiGkJ2ai/qHnd77pAE
         CQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pEqUumKr/EgaUao63hzIzbhv6Q14RxQUL9K8csLNy0c=;
        b=OG9bG7iNVmUX/xKgDl0TIV97JeqETkdnmT07KjHoycilx8v1sY6RmuN7hVnGiA7g3M
         2n/gw0sLNv+QCVwdhf1/uyK0qa858d0QGKVWQWLQrCmA65ROaT0zzBxMk2h/DKlKliVE
         x2cIREo3/rhTi/yvit8jjv1qAQhM8bNJMu7qj41MD3TasAp7SE5b9gdv1ECHIv7nf0SL
         oG1m1+Ux9993qTu7H9fVP/PVdru0R4pXxisJLYmxa6nj72usnOIpFLtxcHfxQawOLV+2
         nCXnuf/i18ZQEsQZynOq7Y4h1gzs57OijGNLbscQ8ih6HgQxjGO3ZKxZsv3hJBCnztwn
         cPUw==
X-Gm-Message-State: AO0yUKU06Um2e+mErLkI1pE+SGwvCPaoCx0IhGxcTzyxgVCOWd36rb+6
        D18mMFlxOPfuuKFBDiuni8w=
X-Google-Smtp-Source: AK7set/6DMzeV/x3ymm7HjzSTpeVo7oY02ciicJFMq1wKBhb5UanoxyxDkqfU4a2IhxO8KBoAhh48g==
X-Received: by 2002:a17:906:2894:b0:8a0:7158:15dc with SMTP id o20-20020a170906289400b008a0715815dcmr19956507ejd.74.1677101129870;
        Wed, 22 Feb 2023 13:25:29 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u20-20020a1709064ad400b008d21431e705sm4429495ejt.84.2023.02.22.13.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 13:25:28 -0800 (PST)
Date:   Wed, 22 Feb 2023 23:25:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function
 for KSZ87xx
Message-ID: <20230222212526.bfcef4dsg6crwlmh@skbuf>
References: <20230222031738.189025-1-marex@denx.de>
 <Y/YPfxg8Ackb8zmW@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/YPfxg8Ackb8zmW@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 12:50:07PM +0000, Russell King (Oracle) wrote:
> Looking at this driver, I have to say that it looks utterly vile
> from the point of view of being sure that it is correct, and I
> think this patch illustrates why.
...
> Now, what about other KSZ devices - I've analysed this for the KSZ8795,
> but what about any of the others which use this register table? It
> looks to me like those that use ksz8795_regs[] all use ksz8_dev_ops
> and the same masks and bitvals, so they should be the same.
> 
> That is a hell of a lot of work to prove that setting both
> P_XMII_CTRL_0 and P_XMII_CTRL_1 to point at the same register is
> in fact safe. Given the number of registers, the masks, and bitval
> arrays, doing this to prove every combination and then analysing
> the code is utterly impractical - and thus why I label this driver
> as "vile". Is there really no better option to these register
> arrays, bitval arrays and mask arrays - something that makes it
> easier to review and prove correctness?

Only my 2 cents. What is utterly vile is the decision of hardware design
to break software compatibility in such a deliberate and gratuitous way
across switch generations. A driver can only do so much when fed with
such hardware as input.

The ksz driver could use struct reg_field from regmap to mitigate that
to a certain extent (like the ocelot driver does), but certain quirks
will still remain present in the ksz driver. For example, the "bitval"
array. The value "1" written to the P_GMII_1GBIT reg_field indicates
gigabit for ksz8795, but !gigabit on ksz9477. I am not aware of any
abstraction to mask that away in common code other than the bitvals.

Even with struct reg_field, it would still not address the fundamental
problem which is simply that the register fields responsible for a
certain function have hopped so much from generation to generation,
that getting all offsets and bits right for each generation is a
challenge in itself.
