Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D029407E20
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 17:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhILPuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 11:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbhILPtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 11:49:11 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0FEC061574;
        Sun, 12 Sep 2021 08:47:57 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id b4so7452850ilr.11;
        Sun, 12 Sep 2021 08:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8cPkzcfwNwxgJOxDHusgDua/GLlzUyV1sT7cRLrqVIY=;
        b=T0B9UeEXX6XuXChfxeEaa1HyFgsxyOEs0AvFV5fmc6Yl5dxyuQ8npoilTObmTPf07C
         Vz6dqthacOzTAI3kJR9r3U39J9lkkvCr3LGRiiql4QWpOMyC97HMjcxvQQ6LlJA59til
         s1AZetRTeTTNQlfOdM+cNjV/pxj9E4y3W8sZDBqOiLA5U63Fx0z8EfYP/01Oip61qXIP
         tGnsspjmBXHCYlkQksBbzusXi+hT5i/PtBnKS4Quug1OW4Gk9TUwnvvRR1HpTvl1mluS
         D8rJOPJzq5tMd/zONY/asv1nhUnXo3OEQfZ4XdGHdPhGBmtKcCms3Uq31lqe8/vbCZxJ
         2krQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8cPkzcfwNwxgJOxDHusgDua/GLlzUyV1sT7cRLrqVIY=;
        b=VNdSDboNIgNMM6XTXWVytbiqs2B1yWDx2hTF6WGout6uYONk5ZRw6OdsZfvdGi9V8l
         tGdP9iRmDdxDlFhRu7AgyOR2S76Rvr2xk3gVzkhRE4GPnrEjLiSjG1BiWF93o69jqW1R
         2Rh6IeJTNNfNzVkCsEMxNahK+hGsv+VRjkFGUXUVT2DRKHwctjH9C0UsRSaE+BrjBclt
         VTPxDJhYvJlmVnwI9buq6a/PeY7lpaFRkWsPVZfu5RUwgxSEA+IiBdCb/+Z1oGmOX7Vt
         Qzm4OxBfyhjDIJDDsGlQNAqQXfmePsyj6TvHkggpoLKWGmtf4azPcdfWnMedKA20n9Zy
         y0yg==
X-Gm-Message-State: AOAM5337UR206BqD7/oLW6c0obmAB8LBF9GpcIJdvfnU5xavq4Owm+EF
        nnIi+ViMh6nT3Ofn2iazHI8pLuJYyFTHk5PQDkA=
X-Google-Smtp-Source: ABdhPJx2+2K2twbtnoUH0gCCdBnbXVeSkbhjZE7YqcnTanAlNqyA0bYVUpRhFw4wE40mQOuL1FawwN02PbEtoEqVpU4=
X-Received: by 2002:a05:6e02:48d:: with SMTP id b13mr603680ils.171.1631461676527;
 Sun, 12 Sep 2021 08:47:56 -0700 (PDT)
MIME-Version: 1.0
References: <46a9dbf2-9748-330a-963e-57e615a15440@gmail.com>
 <20210701085117.19018-1-rocco.yue@mediatek.com> <62c9f5b7-84bd-d809-4e33-39fed7a9d780@gmail.com>
 <CAKD1Yr2aijPe_aq+SRm-xv0ZPoz_gKjYrEX97R1NJyYpSnv4zg@mail.gmail.com> <6a8f0e91-225a-e2a8-3745-12ff1710a8df@gmail.com>
In-Reply-To: <6a8f0e91-225a-e2a8-3745-12ff1710a8df@gmail.com>
From:   Mark Smith <markzzzsmith@gmail.com>
Date:   Mon, 13 Sep 2021 01:47:30 +1000
Message-ID: <CAO42Z2w-N6A4DmubhQsg6WbaApG+7sy2SVRRxMXtaLrTKYyieQ@mail.gmail.com>
Subject: Re: [PATCH] net: ipv6: don't generate link-local address in any addr_gen_mode
To:     David Ahern <dsahern@gmail.com>
Cc:     Lorenzo Colitti <lorenzo@google.com>,
        Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com, chao.song@mediatek.com,
        =?UTF-8?B?S3VvaG9uZyBXYW5nICjnjovlnIvptLsp?= 
        <kuohong.wang@mediatek.com>,
        =?UTF-8?B?Wmh1b2xpYW5nIFpoYW5nICjlvKDljZPkuq4p?= 
        <zhuoliang.zhang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is all going in the wrong direction. Link-local addresses are not
optional on an interface, all IPv6 enabled interfaces are required to
have one:

RFC4291, "IP Version 6 Addressing Architecture"

"2.1.  Addressing Model

All interfaces are required to have at least one Link-Local unicast
   address (see Section 2.8 for additional required addresses)."

Regards,
Mark.



On Fri, 10 Sept 2021 at 05:13, David Ahern <dsahern@gmail.com> wrote:
>
> On 9/9/21 12:20 AM, Lorenzo Colitti wrote:
> >> I think another addr_gen_mode is better than a separate sysctl. It looks
> >> like IN6_ADDR_GEN_MODE_STABLE_PRIVACY and IN6_ADDR_GEN_MODE_RANDOM are
> >> the ones used for RAs, so add something like:
> >>
> >> IN6_ADDR_GEN_MODE_STABLE_PRIVACY_NO_LLA,
> >> IN6_ADDR_GEN_MODE_RANDOM_NO_LLA,
> >
> > I think the real requirement here (which wasn't clear in this thread)
> > is that the network needs to control the interface ID (i.e., the
> > bottom 64 bits) of the link-local address, but the device is free to
> > use whatever interface IDs to form global addresses. See:
> > https://www.etsi.org/deliver/etsi_ts/129000_129099/129061/15.03.00_60/ts_129061v150300p.pdf
> >
> > How do you think that would best be implemented?
>
> There is an established paradigm for configuring how an IPv6 address is
> created or whether it is created at all - the IFLA_INET6_ADDR_GEN_MODE
> attribute.
>
> >
> > 1. The actual interface ID could be passed in using IFLA_INET6_TOKEN,
> > but there is only one token, so that would cause all future addresses
> > to use the token, disabling things like privacy addresses (bad).
> > 2. We could add new IN6_ADDR_GEN_MODE_STABLE_PRIVACY_LL_TOKEN,
> > IN6_ADDR_GEN_MODE_RANDOM_LL_TOKEN, etc., but we'd need to add one such
> > mode for every new mode we add.
> > 3. We could add a separate sysctl for the link-local address, but you
> > said that per-device sysctls aren't free.
>
> per-device sysctl's are one of primary causes of per netdev memory usage.
>
> Besides that there is no reason to add complexity by having a link
> attribute and a sysctl for this feature.
>
> > 4. We could change the behaviour so that if the user configures a
> > token and then sets IN6_ADDR_GEN_MODE_*, then we use the token only
> > for the link-local address. But that would impact backwards
> > compatibility.
> >
> > Thoughts?
>
> We can have up to 255 ADDR_GEN_MODEs (GEN_MODE is a u8). There is
> established code for handling the attribute and changes to it. Let's
> reuse it.
