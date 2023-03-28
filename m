Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24AED6CC5E2
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 17:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbjC1PTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 11:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjC1PSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 11:18:30 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77BE10433;
        Tue, 28 Mar 2023 08:17:21 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n10-20020a05600c4f8a00b003ee93d2c914so9334524wmq.2;
        Tue, 28 Mar 2023 08:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680016639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v0B6FpipeQ3bEbahSZbTSke5kYQ7TQ02Z97756jnvWc=;
        b=ip7+nB/YuCICS9SIjeL+kfF8bUfEk6Xl7SvvPDcxPv0KpsHhy0rYubc14JcsMyxSDt
         0uap/XhSGuvsJa69mrjjtNda375E0WUXEUl8rEIFAbSWEKULMfJpGdyM2Vy6jUEXZ4ev
         G6FkPhFD/wpWNYwQ8hdCAV/wqv2jKIwtRy0mi6mLceiZO++bZCTsdESLm9nK1jwLCxEF
         J6Eo+lk3MDNYXVO1gvNNpsJ4d9wHsDJ8BJ4QS0ipdrKsL6RTGMjxzYmHrGhWW7bdSMHH
         z82orrZcDLbiXnFQr7bXklYH+mg1/AxJDw319BGfzFad0kGDuznY7G3arZtS+3cvjP5f
         fCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680016639;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v0B6FpipeQ3bEbahSZbTSke5kYQ7TQ02Z97756jnvWc=;
        b=LbYRsuf20FS7cB/LtlsbpNgIWppHWoB098S0KQRm3oMDADKF06q+5QUifrLJQc5ydk
         EnQNLvAMlOsz2vc6s/xHga3PpfHVnbOBxGii8ZqlP4pXU2ypPRtZaHTwgIhQuFt2WqMP
         cTxh+jiFrnTa/IMdAiwp43YVce8l7HWNaFmi8lmVof/I4l/WlGFhGtsxmXF/JtgHHOO5
         4nfc4jdqWTuFowE25qcoIZpijyDlhlK5UOlfthfwIGTl3d9TLooGAqJT/11bSJA5vEq7
         y0JhYKXDHTcOiNXcFPvMauZeNVixnlOtbmyN7kSzdGPqLyMJIVdIhRJ20+lufVqAU5ZJ
         lPvA==
X-Gm-Message-State: AO0yUKWHb7dnt2FdHgDcJ/LodnHjD9BcxHXZOS1hdYT5b9XyIjaH3DED
        3tguLrcE4rhEsvF6726Ng5I=
X-Google-Smtp-Source: AK7set9+xJ6lxiwmZ7rSiH0SIWY/LrUgP/RDdq4LZDb5O8brLjg80BX+F6veKgLTz2gQ5hlPj7Af2g==
X-Received: by 2002:a7b:c444:0:b0:3eb:38b0:e757 with SMTP id l4-20020a7bc444000000b003eb38b0e757mr12632262wmi.10.1680016639297;
        Tue, 28 Mar 2023 08:17:19 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id l1-20020a1c7901000000b003eae73f0fc1sm17413419wme.18.2023.03.28.08.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:17:19 -0700 (PDT)
Date:   Tue, 28 Mar 2023 18:17:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next 2/2] net: dsa: mt7530: introduce MMIO driver
 for MT7988 SoC
Message-ID: <20230328151716.ulvfqrvgsffjnhgc@skbuf>
References: <ZCIML310vc8/uoM4@makrotopia.org>
 <a3458e6d-9a30-4ece-9586-18799f532580@lunn.ch>
 <ZCIML310vc8/uoM4@makrotopia.org>
 <a3458e6d-9a30-4ece-9586-18799f532580@lunn.ch>
 <ZCLmwm01FK7laSqs@makrotopia.org>
 <ZCLmwm01FK7laSqs@makrotopia.org>
 <20230328141628.ahteqtqniey45wb6@skbuf>
 <ZCMBDm31AzDGBKyL@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCMBDm31AzDGBKyL@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 04:00:30PM +0100, Daniel Golle wrote:
> On Tue, Mar 28, 2023 at 05:16:28PM +0300, Vladimir Oltean wrote:
> > On Tue, Mar 28, 2023 at 02:08:18PM +0100, Daniel Golle wrote:
> > > I agree that using regmap would be better and I have evaluated that
> > > approach as well. As regmap doesn't allow lock-skipping and mt7530.c is
> > > much more complex than xrs700x in the way indirect access to its MDIO bus
> > > and interrupts work, using regmap accessors for everything would not be
> > > trivial.
> > > 
> > > So here we can of course use regmap_read_poll_timeout and a bunch of
> > > readmap_write operations. However, each of them will individually acquire
> > > and release the mdio bus mutex while the current code acquires the lock
> > > at the top of the function and then uses unlocked operations.
> > > regmap currently doesn't offer any way to skip the locking and/or perform
> > > locking manually. regmap_read, regmap_write, regmap_update_bits, ... always
> > > acquire and release the lock on each operation.
> > 
> > What does struct regmap_config :: disable_locking do?
> 
> I thought I can't use that on a per-operation base because the
> instance of struct regmap_config itself isn't protected by any lock
> and hence setting disable_locking=false before calling one of the
> accessor functions may affect also other congruent calls to the
> accessors which will then ignore locking and screw things up.
> Please correct me if I'm wrong there.

It's not supposed to be used like that. You set disable_locking = true
once, and take care of locking from the mt7530 driver. Not before every
operation.

> Yet another way I thought about now could also be to have two regmap
> instances, one for locked and one for unlocked accessed to the same
> regmap_bus.

That would also be theoretically possible, but the above would be
equivalent and would require a single regmap.
