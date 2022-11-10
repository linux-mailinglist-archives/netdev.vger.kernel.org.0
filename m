Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C6962465F
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 16:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbiKJPxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 10:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbiKJPxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 10:53:32 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA382647
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 07:53:31 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id 4so1751550pli.0
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 07:53:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5P86D9RK9RsOZhFQ1kVEjHnky7/FDe539RdkNGf2ehk=;
        b=LbXEUIjmINR3rJf21+T46VcD4vG+u1IyzqOWGgxkI4R6RzNCNeu3rkWufgzYHOKeV1
         cPBKNLMudse4MEF218T3dPSlAPuSZ/qqNf91jnTv4Hs2o5u7tJgJRKYMTM49oKErIqIb
         QYhC1AAmPyR5b6HLj43tICzpKfetOt8KUnoetHgwEID4QUdleqI8VMnVoIaFU1vlx5Co
         XU8vvJkrk6ELsoNsyuexx+5xT7/3UvWpTATPm5UYH2hPp0mSF5MNFDVfyrmmUctTNXS5
         Ck7dPgs9TW1ocqLIa7jZk5iFCqu7kmPkWGCKpLgzvSaT8eIpw997M2/nVuIxF294l5GU
         3/ow==
X-Gm-Message-State: ACrzQf03L+WW5UTZJ6lDfn0/VlYV/s1Z4/TZK8YPU1TMSqSj5HC77LPr
        MODxTqXsCYFA3+l+F8OtEL09woCMzGbGP11STaHONuoxRELC1Q==
X-Google-Smtp-Source: AMsMyM6K9Hwy8c+8wE4qgBSxIWhb8e488HuCyHu3RyqJdgE22wXimHDweohnj9sjw6JKZZXN5xBEPlo9xCmTySa0xs8=
X-Received: by 2002:a17:90a:4b07:b0:20a:c032:da66 with SMTP id
 g7-20020a17090a4b0700b0020ac032da66mr1336603pjh.19.1668095610604; Thu, 10 Nov
 2022 07:53:30 -0800 (PST)
MIME-Version: 1.0
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
 <Y2vozcC2ahbhAvhM@unreal> <20221109122641.781b30d9@kernel.org>
 <CAMZ6Rq+K6oD9auaNzt1kJAW0nz9Hs=ODDvOiEaiKi2_1KVNA8g@mail.gmail.com>
 <Y2zASloeKjMMCgyw@unreal> <CAMZ6RqJ8P=WUCQQSZ=A_g0brdwDazqCDMUhU+_NN5NWajLFZng@mail.gmail.com>
 <Y2zn0YVlMaHNEOLR@unreal>
In-Reply-To: <Y2zn0YVlMaHNEOLR@unreal>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Fri, 11 Nov 2022 00:53:16 +0900
Message-ID: <CAMZ6RqKq_azrLSwXWgnjgKg_z9aczt-p1wuL5c2LD324FRNC2A@mail.gmail.com>
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate
 drvinfo fields even if callback exits
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu. 10 Nov. 2022 at 21:00, Leon Romanovsky <leon@kernel.org> wrote:
> On Thu, Nov 10, 2022 at 08:43:25PM +0900, Vincent MAILHOL wrote:
> > On Thu. 10 Nov. 2022 at 18:11, Leon Romanovsky <leon@kernel.org> wrote:
> > > On Thu, Nov 10, 2022 at 05:34:55PM +0900, Vincent MAILHOL wrote:
> > > > On Thu. 10 nov. 2022 at 05:26, Jakub Kicinski <kuba@kernel.org> wrote:
> > > > > On Wed, 9 Nov 2022 19:52:13 +0200 Leon Romanovsky wrote:
> > > > > > On Tue, Nov 08, 2022 at 12:57:54PM +0900, Vincent Mailhol wrote:
> > > > > > > If ethtool_ops::get_drvinfo() callback isn't set,
> > > > > > > ethtool_get_drvinfo() will fill the ethtool_drvinfo::name and
> > > > > > > ethtool_drvinfo::bus_info fields.
> > > > > > >
> > > > > > > However, if the driver provides the callback function, those two
> > > > > > > fields are not touched. This means that the driver has to fill these
> > > > > > > itself.
> > > > > >
> > > > > > Can you please point to such drivers?
> > > > >
> > > > > What you mean by "such drivers" is not clear from the quoted context,
> > > > > at least to me.
> > > >
> > > > An example:
> > > > https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/broadcom/bnx2.c#L7041
> > > >
> > > > This driver wants to set fw_version but needs to also fill the driver
> > > > name and bus_info. My patch will enable *such drivers* to only fill
> > > > the fw_version and delegate the rest to the core.
> > >
> > > Sorry for being misleading, It looks like I typed only part of the sentence
> > > which I had in my mind. I wanted to see if any driver exists which prints
> > > drv_name and bus_info different from default.
> > >
> > > >
> > > > > > One can argue that they don't need to touch these fields in a first
> > > > > > place and ethtool_drvinfo should always overwrite them.
> > > > >
> > > > > Quite likely most driver prints to .driver and .bus_info can be dropped
> > > > > with this patch in place. Then again, I'm suspecting it's a bit of a
> > > > > chicken and an egg problem with people adding new drivers not having
> > > > > an incentive to add the print in the core and people who want to add
> > > > > the print in the core not having any driver that would benefit.
> > > > > Therefore I'd lean towards accepting Vincent's patch as is even if
> > > > > the submission can likely be more thorough and strict.
> > > >
> > > > If we can agree that no drivers should ever print .driver and
> > > > .bus_info, then I am fine to send a clean-up patch to remove all this
> > > > after this one gets accepted. However, I am not willing to invest time
> > > > for nothing. So would one of you be ready to sign-off such a  clean-up
> > > > patch?
> > >
> > > I will be happy to see such patch and will review it, but can't add sign-off
> > > as I'm not netdev maintainer.
> >
> > Well, if you want to review, just have a look at:
> >   $ git grep -W "get_drvinfo(struct"
>
> BTW, in some of the callbacks, if driver doesn't exists, they print "N/A",
> while in your patch it will be empty string.

Indeed and this is inconsistent. For example, no one sets
.erom_version to "N/A". So you will have some of the fields set to
"N/A" and some others set to an empty string. The "N/A" thing was a
mistake to begin with. I will not change my patch.
