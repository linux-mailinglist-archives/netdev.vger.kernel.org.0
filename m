Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F706E9567
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 15:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjDTNIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 09:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjDTNIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 09:08:53 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EBD270E
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 06:08:51 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2a776fb84a3so4973391fa.1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 06:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1681996129; x=1684588129;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zLiYKPGa+jLztN9G8AvEojt4ND6qqBoW1hhdN7AIW1g=;
        b=jug9Eg+7ngGJQAgyRewMpowAswEe4IIhQ6epQkXW/P+NSQxBaMui+VFJJRq63R0jEv
         2+RpA44UJ+iHT49KMecmHcjC5bimwrw8rOoB3cGKw6cER8SyXvo6lTbIMQ+bnGgwsJba
         ZJnAVllYAduoiYwtDejIqP8r3Gixu0A4RqpW3kbwqTgEPSfphj3f4ya8VLhGas2ryc88
         BjK/HOByo4kixk1OMxymdgu/HH8MBGp+v0zxY7YtPzu+mcSjZfpRUSV3lf9wfFaNbxEN
         BrYt0TEZzEWqvfopyGPp2nohUQ9FVlVJvNk6zC+mEVlXGwagDGEXE064C5DCjq1V+cU6
         Y0yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681996129; x=1684588129;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zLiYKPGa+jLztN9G8AvEojt4ND6qqBoW1hhdN7AIW1g=;
        b=jWlCRxYiWD+0jxwvW+ICuNrGdJWFHEeaeoSuBYneozwzuEcBYtA9dEmb8vpjKkgNrj
         DeTfIYA81+i/18XkDs6Mban7bMZ6SpBltBPcg+xEjrNTVKkYku2HJ/W0UuxYKnYVtd4Z
         cCSSSJFMlzhviLS8ft3HzlBofk5SnlyFLZo+pu567aS9j4qgeInihpvSA3B6yVHny+od
         Xij9ePgaSY5+iFDMRkEj4dTzvRFVfEi+h8tkpCcFrq+59muOeQwLyZWxy+os4MgmjFBj
         k2GQZ3rJM3Ih0gy4evFFgRE8iTTqRHkQV1tQGxjs7mUySd3gDBV74L7oRBeHwIKgoe7e
         BxgA==
X-Gm-Message-State: AAQBX9daKxaPPjg2w/VgskNimpUueCcQ2ie2M2b7k/vBD2h0Bhp/K5Gg
        HmoZriAnQVFIbkUOKTmp9SuC6xN6TsF2tHZjcwg=
X-Google-Smtp-Source: AKy350Y+1K8PBOHzUtri3GB1hF5J+l28azC4lkc4Td7N6RjWHwBElD5j2HOIZ7fsIOnd4LsmG4i9qQ==
X-Received: by 2002:a05:6512:4ce:b0:4e9:ccff:daa6 with SMTP id w14-20020a05651204ce00b004e9ccffdaa6mr519362lfq.30.1681996129452;
        Thu, 20 Apr 2023 06:08:49 -0700 (PDT)
Received: from debian (c188-148-248-178.bredband.tele2.se. [188.148.248.178])
        by smtp.gmail.com with ESMTPSA id w18-20020a19c512000000b004e8448de1c0sm221522lfe.10.2023.04.20.06.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 06:08:49 -0700 (PDT)
Date:   Thu, 20 Apr 2023 15:08:47 +0200
From:   =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <ZEE5XwqYrZfyhNXT@debian>
References: <ZEATxeT+g5Bx5ml2@debian>
 <b93039ef-a593-4acd-b9c1-3f3e6b79497d@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b93039ef-a593-4acd-b9c1-3f3e6b79497d@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 02:43:45PM +0200, Andrew Lunn wrote:
> On Wed, Apr 19, 2023 at 06:16:05PM +0200, Ramón Nordin Rodriguez wrote:
> > Changes:
> >     v2:
> > - Removed mentioning of not supporting auto-negotiation from commit
> >   message
> > - Renamed file drivers/net/phy/lan867x.c ->
> >   drivers/net/phy/microchip_t1s.c
> > - Renamed Kconfig option to reflect implementation filename (from
> >   LAN867X_PHY to MICROCHIP_T1S_PHY)
> > - Moved entry in drivers/net/phy/KConfig to correct sort order
> > - Moved entry in drivers/net/phy/Makefile to correct sort order
> > - Moved variable declarations to conform to reverse christmas tree order
> >   (in func lan867x_config_init)
> > - Moved register write to disable chip interrupts to func lan867x_config_init, when omitting the irq disable all togheter I got null pointer dereference, see the call trace below:
> > 
> >     Call Trace:
> >      <TASK>
> >      phy_interrupt+0xa8/0xf0 [libphy]
> >      irq_thread_fn+0x1c/0x60
> >      irq_thread+0xf7/0x1c0
> >      ? __pfx_irq_thread_dtor+0x10/0x10
> >      ? __pfx_irq_thread+0x10/0x10
> >      kthread+0xe6/0x110
> >      ? __pfx_kthread+0x10/0x10
> >      ret_from_fork+0x29/0x50
> >      </TASK>
> > 
> > - Removed func lan867x_config_interrupt and removed the member
> >   .config_intr from the phy_driver struct
> > 
> >     v3:
> > - Indentation level in drivers/net/phy/Kconfig
> > - Moved const arrays into global scope and made them static in order to have
> >   them placed in the .rodata section
> > - Renamed array variables, since they are no longer as closely scoped as
> >   earlier
> > - Added comment about why phy_write_mmd is used over phy_modify_mmd
> >   (this should have been addressed in the V2 change since it was brought
> >   up in the V1 review)
> > - Return result of last call instead of saving it in a var and then
> >   returning the var (in lan867x_config_init)
> > 
> > Testing:
> > This has been tested with ethtool --set/get-plca-cfg and verified on an
> > oscilloscope where it was observed that:
> > - The PLCA beacon was enabled/disabled when setting the node-id to 0/not
> >   0
> > - The PLCA beacon is transmitted with the expected frequency when
> >   changing max nodes
> > - Two devices using the evaluation board EVB-LAN8670-USB could ping each
> >   other
> > 
> > 
> > This patch adds support for the Microchip LAN867x 10BASE-T1S family
> > (LAN8670/1/2). The driver supports P2MP with PLCA.
> > 
> > Signed-off-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
> 
> All the above ends up in the commit message, as you see in git log. So
> this last paragraph should really be first. As you have it, the
> history of the patch will also be included in the commit. Most Linux
> subsystems don't want that, although DaveM has argued it maybe should
> be in the commit message. But i personally think we have good archives
> of emails, and search engines for those archives, so i don't see the
> need.
> 

The intention was not to include the history in the commit message, as
you allude to this was a misstake on my part.

> Anything you put after the --- will get discarded when the Maintainers
> perform the merge. So i suggest you move most of what you have in the
> commit message below the ---. You can also have two ---, which is how
> i tend to do it, so i can keep the history in my git repo, but it then
> gets removed when merged upstream.

I'll move the history to after the ---

> 
> Additionally, you should add any Reviewed-by:, Acked-by: to your
> patches. Only discard them if you make major changed which invalidates
> any reviews.
> 
>     Andrew

I will post a V4 soon as the 24h window closes on V4, with
- history after the patch
- reviewers:
    - Andrew Lunn <andrew@lunn.ch>
    - Vladimir Oltean <olteanv@gmail.com>

Hoping this is the last of the newbie misstakes I've managed to pull
off.
Ramón
