Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD212644CAE
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 20:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLFTzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 14:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLFTzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 14:55:21 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8166413DFD
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 11:55:20 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id ud5so8990847ejc.4
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 11:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EVSmmjU3TFpGAsAS/sxpDiu4gHHo8nJ+Jpt820gAQJo=;
        b=pdhDnJqq0FuD4LCK+UMZxn/7VC2GgxJuW/27pQ9p1udMWltIpt22BopnZ60UtekpMK
         Gn1wTbgyR2cJeCI/KYPKnKnMPIF4MUpayR70wqB7UeXU/iwNBDCcnq3M56ZFYrkpFyy3
         td/dD8OUP9Bx2o4AX/aOacoU8f4ZKDVR1tOiMV6KCDwYI5ceJyi+CafnX7A+D1Q8Bx//
         Mnr5KE/+zxujSGmAqAc0SOEV3YrKR5hvq/0irh6ibUXSRPlvI3sFDoGs32wQ0Xipytxw
         LB+DbjTeu79Svoua1rWuQ1PfF196bMetGhRff332ItFBJ7Aa7OJUvC9pIbZFt1M+Qw8Y
         fOBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EVSmmjU3TFpGAsAS/sxpDiu4gHHo8nJ+Jpt820gAQJo=;
        b=Rh3y0FAsp4OWThQBeiOXGhOMn/MZGQZPEhZNsHqbVxt/juTaxb1dtCLHAoFVhfgEVL
         J2de6X2lzNOFWFpZWVXCz61BLmdtw/3rQ2hRAsCeOXHzlqay2gnJDv1OWCKzEBSjBHpR
         KhKAhbSg2sMaiIRFOdOFJK5w1w8D83/9ULk5fSs+kjxqLNOXfzGIMjbyFhqgxaRZ5u4B
         KKTyTyV6niYK4QFTUat/TtCyOMd9z4fugcNB+75tPjUA0lTU39JcW+4HIXXeOucgATwt
         4yAMHAVXRmBWuQ9CBOSavnVMSlRRWc/hazlvFYq7YWxZ9dsdYmC5+fY48r4bVIZ3pyZH
         vGww==
X-Gm-Message-State: ANoB5pnuebS+4W+b3aocdekbLejEHAyA/OYLBZGSlci435uZ08RBE3/H
        MbyADcTLKE+Khk65oMitB9M=
X-Google-Smtp-Source: AA0mqf60EUKiUf7A7VnEOBg8Th2UEgACQF5xng7vXX0L8JX0SCDz85IHy97YmO1xj80rdCSATGkx3g==
X-Received: by 2002:a17:906:4cc8:b0:7c0:c4e6:eff6 with SMTP id q8-20020a1709064cc800b007c0c4e6eff6mr17120667ejt.465.1670356519059;
        Tue, 06 Dec 2022 11:55:19 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id o17-20020a170906769100b00782fbb7f5f7sm7680653ejm.113.2022.12.06.11.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 11:55:18 -0800 (PST)
Date:   Tue, 6 Dec 2022 21:55:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jerry.Ray@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4] dsa: lan9303: Add 3 ethtool stats
Message-ID: <20221206195516.vv57lab7p4iifar5@skbuf>
References: <20221130200804.21778-1-jerry.ray@microchip.com>
 <20221130205651.4kgh7dpqp72ywbuq@skbuf>
 <MWHPR11MB1693DA619CAC5AA135B47424EF149@MWHPR11MB1693.namprd11.prod.outlook.com>
 <20221201084559.5ac2f1e6@kernel.org>
 <MWHPR11MB169342D6B1CC71B8805A741AEF179@MWHPR11MB1693.namprd11.prod.outlook.com>
 <20221202113622.21289116@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202113622.21289116@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 11:36:22AM -0800, Jakub Kicinski wrote:
> On Fri, 2 Dec 2022 15:22:55 +0000 Jerry.Ray@microchip.com wrote:
> > >Huh? I'm guessing you're referring to some patches you have queued
> > >already and don't want to rebase across? Or some project planning?
> > >Otherwise I don't see a connection :S
> > 
> > In looking around at other implementations, I see where the link_up
> > and link_down are used to start or clean up the periodic workqueue
> > used to retrieve and accumulate the mib stats into the driver.  Can't tell
> > if that's a requirement or only needed when the device interface is
> > considered too slow.  The device interface is not atomic.
> 
> Atomic as in it reads over a bus which requires sleeping?
> Yes, the stats ndo can't sleep because of the old procfs interface
> which ifconfig uses and which is invoked under the RCU lock.

Jerry, did you respond to this (what do you mean by "device interface is
not atomic")?

Still not clear why transitioning to phylink is a requirement for
standardized statistics. You get your link up/link down events with
adjust_link too (phydev->link).

Some other drivers only perform periodic stats readout for ports that
are up, because those are the only ports where the stats can ever
change. That's about all that there is to know. There's no requirement
one way or another, it's an optimization.
