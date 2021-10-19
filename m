Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30D8433EDA
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhJSS5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhJSS5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 14:57:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBC14C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 11:55:37 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id d3so16991369edp.3
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 11:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j0FbMRMVQO/uuyhUYclxE9Tz2P/KHjeSyvUrDKisn6k=;
        b=3JQVcZjhVHVqZa5FsrzhUQ8jUoLuADiN0dNjUa+kFVCcwMDCi1ue0KsuEvAk/Q9Yy9
         YXw1IuyFnFmgH3N6QLhCeW0x39n/FIhXcVFfo/OgP/4pRwCYkGK+n+PW/9ZLAyf9U5fT
         1dqNajw/FoA+duTjEF4GIwO+w1ROXU8NqM5Y7TrKAb7TJcn+kYiNjnUDpk0NjnErzLr6
         9rAPCvNreAa8UJqHoLjB9+wYFmbxXBxgp+EZFw09sVWG8IGioGGWr6XD1eQH7dKS8hX6
         BSpMRJOeY/mYM0HL4V2TZGS9fV9j5v3D8LlM5lumUNaptGK91PcWEZpGaq/qqKokPxYL
         lAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j0FbMRMVQO/uuyhUYclxE9Tz2P/KHjeSyvUrDKisn6k=;
        b=HRHTqfGYoaPHswom0Gbe90bn2B67bhhHRiLa1bhAXACa87T14Hg0EJnp772u9Sw1zi
         CeoOTdg35uT3wn11lao067OC4Pr8URDqqqMXaDlpF1H2oi3lrbM9GZyPztzMunofCuh8
         kHsWAHScDcg163pkN29rsDbAS57cc2KLA6euO4eXkuZ35Z9JUWkm9Ac/oP/NCryiiPXM
         GCJyPdK4rLft8V5st8VjZB8WEAb31XeBo0YNZUxW0g8Ooe4HdruOQgcKr0NbgQBOAsD2
         9UifX/Q9pxpAuIOlMzjYZPS43CuhAdxTHccyGWqexWUxW9+PwzlFyemWn7NPtU+s9Dm8
         +WAg==
X-Gm-Message-State: AOAM531SQhl+mPF2rtC2AFFALR5yqtj8BHTtoevLxYr5j6BEW4eAYfbN
        OwNKJNimAhe0RqKE1+ECM897E8u/UpcJbHKliDpA8A==
X-Google-Smtp-Source: ABdhPJzEqeYW6siPsLj8BR3DileiSI4R33P4sS3Z8r7NbJp/SLjMBtq+l5Di02OC2fEr4zhQ4wCgST7LQhiqFReVp1Y=
X-Received: by 2002:a17:907:75e4:: with SMTP id jz4mr39195113ejc.106.1634669736438;
 Tue, 19 Oct 2021 11:55:36 -0700 (PDT)
MIME-Version: 1.0
References: <20211018183709.124744-1-erik@kryo.se> <YW7k6JVh5LxMNP98@lunn.ch>
 <20211019155306.ibxzmsixwb5rd6wx@gmail.com> <CAGgu=sAUj4g3v7u4ibW53js5U3M+9rdjW+jfcDdF1_A4H8ytaw@mail.gmail.com>
 <YW8N9RlRD8/15GLP@lunn.ch>
In-Reply-To: <YW8N9RlRD8/15GLP@lunn.ch>
From:   Erik Ekman <erik@kryo.se>
Date:   Tue, 19 Oct 2021 20:55:25 +0200
Message-ID: <CAGgu=sDh9DU+kUDgcZds5XRnRr=oLwGocQyQtMA-_Ta-mLp5fA@mail.gmail.com>
Subject: Re: [PATCH] sfc: Export fibre-specific link modes for 1/10G
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 at 20:27, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Oct 19, 2021 at 07:34:16PM +0200, Erik Ekman wrote:
> > On Tue, 19 Oct 2021 at 17:53, Martin Habets <habetsm.xilinx@gmail.com> =
wrote:
> > >
> > > On Tue, Oct 19, 2021 at 05:31:52PM +0200, Andrew Lunn wrote:
> > > > On Mon, Oct 18, 2021 at 08:37:08PM +0200, Erik Ekman wrote:
> > > > > These modes were added to ethtool.h in 5711a98221443 ("net: ethto=
ol: add support
> > > > > for 1000BaseX and missing 10G link modes") back in 2016.
> > > > >
> > > > > Only setting CR mode for 10G, similar to how 25/40/50/100G modes =
are set up.
> > > > >
> > > > > Tested using SFN5122F-R7 (with 2 SFP+ ports) and a 1000BASE-BX10 =
SFP module.
> > > >
> > > > Did you test with a Copper SFP modules?
> > > >
> >
> > I have tested it with a copper SFP PHY at 1G and that works fine.
>
> Meaning ethtool returns 1000BaseT_FULL? Does the SFP also support
> 10/100? Does ethtool list 10BaseT_Half, 10BaseT_Full, etc.
>

The supported modes do not change based on the module used.  From the
code it looks to only be based on the phy capability bits
(MC_CMD_PHY_CAP_1000FDX_LBN, MC_CMD_PHY_CAP_10000FDX_LBN).
The copper SFP does not link at 100Mbps, only at 1Gbps (from my testing).

From the 'Solarflare Server Adapter User Guide': "SFP 1000BASE=E2=80=90T
module, Autonegotiation: No, Speed:  1G, Comment: These modules
support only 1G and will not link up at 100Mbps"
10G SFP+ Base-T modules are not mentioned, maybe they did not exist
back then. Do you think the 1000BaseT_Full should be used because of
this?

Reading the user guide further I see lists of supported SFP+ -LR and
-SR modules as well as QSFP+ SR4 modules so I am planning to add them.

/Erik
