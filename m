Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF962645DC7
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiLGPmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLGPmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:42:06 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE9D60B6E;
        Wed,  7 Dec 2022 07:42:05 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id f7so25442046edc.6;
        Wed, 07 Dec 2022 07:42:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OwH4Gcv5FX9Ez7R0y/eSqA6CTqQLAguixPLNHBhie6U=;
        b=goeqfASTX5lCuxyfo1TbHWXrIzFXfbhVoRJ/xt2x+08aKMjEeJ2LkACRwMUP0hT6KI
         v6o70BZKwQFFU+QKFBuJGQmErWRlWoOXT898wjEBvKiVNl113lXTJhtTtSTWJ9aXUBib
         lDzE2kp4EqPXmMm0kQPJasS4HyKy1+sEIJYhPMC4UnykbSzcJz2hkTkITHvDSou4vhEN
         ZgL3uk+y96l1KSH8RimXq+SYbJIUFAr8pSubggGo6dRSt9QWEoEnXBEN55J13UJ31PIQ
         fmL4lrjJZdILcAJEJGtRqHJIO2F6GZxzqiRdFY8y0FKCHXrnraQj7+Hj9LMj4xGuusBC
         Sx2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OwH4Gcv5FX9Ez7R0y/eSqA6CTqQLAguixPLNHBhie6U=;
        b=xj042L07C+FZjlAgeXoMd2de2mIo49nBph82AP6kXY8UpLhiqaVSZd8CWl3VDEr1KI
         NQvVDA4YDktx9bvzOOw9vNFizfk9bjP5a4yp84NG9bdGl6+HiFalo0HWw8IdsP0s0FI7
         durZYC9J/XdenVYmi2YasYU2De3McXLwwvmVzBxBKN8O1pE2dP1GQu71L4XTxJbtL7Eh
         HLRfetxtGgjcfhe/FIslpvWd1b7PJr0MrqQZr2cQ/Am/vUrrPmnGflE0+EZ/GFcNKe6P
         xBIiy6++FEPgkHpJrcbX/WaDwgqhkcIupYxcSBzdRJz8P92Tt4EAHli8hxFk5UCgU/UZ
         hntg==
X-Gm-Message-State: ANoB5pkuTYHNfbN8zZ5skmvVMZ0fWjHdfnGpa+gXFsZw3gY+cqoG0TAW
        hwn34AEztQ/MJJnjDn5+s9M=
X-Google-Smtp-Source: AA0mqf51a/63Urivpl9xqLseyeQIr6ko65qJhVWeB7WY2Td1bjdAYAL7YOLHLnhMxvP6OjgpSyLHFQ==
X-Received: by 2002:a05:6402:3441:b0:46b:2aaf:754e with SMTP id l1-20020a056402344100b0046b2aaf754emr39976106edc.139.1670427723383;
        Wed, 07 Dec 2022 07:42:03 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id ck3-20020a0564021c0300b0046778ce5fdfsm2352977edb.10.2022.12.07.07.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 07:42:02 -0800 (PST)
Date:   Wed, 7 Dec 2022 16:42:15 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y5C0V52DjS+1GNhJ@gvm01>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
 <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
 <20221206195014.10d7ec82@kernel.org>
 <Y5CQY0pI+4DobFSD@gvm01>
 <Y5CgIL+cu4Fv43vy@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y5CgIL+cu4Fv43vy@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 03:16:00PM +0100, Andrew Lunn wrote:
> > > TBH I can't parse the "ETHTOOL_A_PLCA_VERSION is reported as 0Axx
> > > where.." sentence. Specifically I'm confused about what the 0A is.
> > How about this: "When this standard is supported, the upper byte of
> > ``ETHTOOL_A_PLCA_VERSION`` shall be 0x0A (see Table A.1.0 — IDVER 
> > bits assignment).
> 
> I think the 0x0A is pointless and should not be included here. If the
> register does not contain 0x0A, the device does not follow the open
> alliance standard, and hence the lower part of the register is
> meaningless.
> 
> This is why i suggested -ENODEV should actually be returned on invalid
> values in this register.
I already integrated this change in v5 (returning -ENODEV). Give what you're
saying, I can just remove that sentence from the documentations. Agreed?

> 
> > > >   * struct ethtool_phy_ops - Optional PHY device options
> > > >   * @get_sset_count: Get number of strings that @get_strings will write.
> > > >   * @get_strings: Return a set of strings that describe the requested objects
> > > >   * @get_stats: Return extended statistics about the PHY device.
> > > > + * @get_plca_cfg: Return PLCA configuration.
> > > > + * @set_plca_cfg: Set PLCA configuration.
> > > 
> > > missing get status in kdoc
> > Fixed. Good catch.
> 
> Building with W=1 C=2 will tell you about kerneldoc issues. Ideally we
> want all network code to be clean with these two options.
Ok thanks. I probably need to upgrade my machine to achieve this. Will
do.
