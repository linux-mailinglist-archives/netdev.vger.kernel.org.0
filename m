Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD67B67861E
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjAWTTg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:19:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbjAWTTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:19:15 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AB3360BC
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:18:50 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id v6so33264402ejg.6
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OySbQIeIKpn1mopN7ymhBvfDfct0BCJ6R0fXIVOhQd8=;
        b=ZeroQWrOU6JkTr6NEFXNkksMcuZFQvI+teGzNZSZe7nvi99WQ/QHluLLm93SCW5q7G
         Aqc6ynCbDStx1vNabTvWUaVA20nDKPMkJYOp843yLzk/oNcM17JlxE448/dL8HlHg2+T
         Zz1UrOzXHCyvFsPCul/C1TpCSHuPy/HadvznjxVKexir+Q5xmLyOuzLJzC2lnbWHgRBY
         AO8hiEg0yHDyGcZOVfzWteF5MoHlLQJVCCy9OlEQ78avvH2e+jIrOlmXZ/Kcrtl4v1D5
         QfZRj+jtUeEp2nYNgjDSoPGbC8rW2EpqCskT7mdJEsHbxuHkdYAUCKy/RLCCuZFHHT5L
         wGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OySbQIeIKpn1mopN7ymhBvfDfct0BCJ6R0fXIVOhQd8=;
        b=bxtxTzy/TMLAk1t0YAg19t59ITCEe5IHvVOJBo7nLBNRPhGmGakhpUXpfhv33Y93Qq
         ov6jhwj6aubyJre6t+Evtx+NAA4vJTkoJ/8RwBDYs0A9i6MJwriMoM9aRAB4ickC4yBw
         QTXdK5h3PZdBsbzZZ8hn2I5raALeCfnVh04LutlOFIxDfFZ7a2sFsduBbG6HNphT0+MI
         o1zh5AlJibd9Us2zQq64lYmjcOPUzSMNTVn40zc6Be0PTXijf9ZSquC97Qhb5Ogk7En2
         plFLDjRDkqz7wuXtOhrqoYVgALj+RaCNoeigImrDSGquNBeSUGPlJNpzIlTP6hG6Ca1z
         ieqQ==
X-Gm-Message-State: AFqh2kr+kFhtVR9/UHhaL4FpISP7nxr6kPVtrl/hKIFbxcz5wnla6RWu
        L2t4h5Xu5GKW8RP6Ajfw57c=
X-Google-Smtp-Source: AMrXdXuFqLnDm48Cpz6Q64wVhBYgHvX7BOWE7xY4oZ5ytsjApxgA6Iri6l3PwSwcTxOeXYwgDFhq+A==
X-Received: by 2002:a17:906:7e0c:b0:877:60b3:3fce with SMTP id e12-20020a1709067e0c00b0087760b33fcemr21051899ejr.45.1674501526944;
        Mon, 23 Jan 2023 11:18:46 -0800 (PST)
Received: from skbuf ([188.27.184.249])
        by smtp.gmail.com with ESMTPSA id sb25-20020a1709076d9900b0084c6581c16fsm22456765ejc.64.2023.01.23.11.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 11:18:46 -0800 (PST)
Date:   Mon, 23 Jan 2023 21:18:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <20230123191844.ltcm7ez5yxhismos@skbuf>
References: <5a746f99-8ded-5ef1-6b82-91cd662f986a@kernel-space.org>
 <Y7yIK4a8mfAUpQ2g@lunn.ch>
 <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
 <20230110222246.iy7m7f36iqrmiyqw@skbuf>
 <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 02:26:55PM +0100, Angelo Dureghello wrote:
> Hi Vladimir,
> 
> On Mon, 23 Jan 2023, Vladimir Oltean wrote:
> 
> > On Mon, Jan 23, 2023 at 09:52:15AM +0100, Angelo Dureghello wrote:
> > > I am now stuck to 5.4.70 due to freescale stuff in it.
> > > I tried shortly a downgrade of net/dsa part from 5.5,
> > > but, even if i have no errors, i can't ping out, something
> > > seems has gone wrong, i don't like too much this approach.
> > > 
> > > But of course, i could upgrade to 5.10 that's available
> > > from freescale, with some effort.
> > > Then, i still should apply a patch on the driver to have dual
> > > cpu running, if i understand properly, correct ?
> > 
> > What is the Freescale chip stuck on 5.4 (5.10 with some effort) if I may
> > ask? I got the impression that the vast majority of SoCs have good
> > enough mainline support to boot a development kernel and work on that,
> > the exception being some S32 platforms.
> > 
> 
> I think i tested mainline kernel, but the rpmsg part to
> communicate with M4 core and scu firmware seems not there.
> So i am stuck with freescale stuff now. Anyway, freescale
> released their 5.10 branch, so eventually i'll move
> to that.

Ok, SC firmware isn't something that I'd be able to assist with.
Isn't there a 5.15 kernel currently available too?
https://github.com/nxp-imx/linux-imx/tree/lf-5.15.y
And I guess a kernel based on 6.1 should become publicly available
soon too (your FAE should probably be able to say more).

The point is that multi-CPU-port support for mv88e6xxx isn't present in
the mainline kernel, no matter what kernel version we're talking about.
And even if you plan on adding this support yourself, doing so on a very
old kernel is a waste of time, because you won't be able to backport DSA
in a way in which the backported code base is similar enough to what's
upstream (and not to mention, behaves similarly enough).

I don't know what this means:

| I am now trying this way on mv88e6321,
| - one vlan using dsa kernel driver,
| - other vlan using dsdt userspace driver.

specifically what is "dsdt userspace driver".
