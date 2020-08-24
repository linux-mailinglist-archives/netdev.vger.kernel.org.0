Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA421250941
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 21:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHXT3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 15:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgHXT3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 15:29:43 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE81C061573;
        Mon, 24 Aug 2020 12:29:43 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i26so9127537edv.4;
        Mon, 24 Aug 2020 12:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tkyjDeEozETacXNRr3uxxFjEe+DOSkNiETr7ujJ7mA4=;
        b=gbLjbs+kaoh4rZOxABupqrCM4Qcd3bYtkfeVC/nRU8Z2Wz1U+JbkAQkArH4gmcAbQg
         +me959Drpnd4CjLnwv1i7I+n39T70i1k9MgfXmM4TdqSH5CHPeQQ704WlNRzvMmsCNE3
         mHOMfsb2nqxSIfJ5iG/uxSzInfGvZgulDJl2jhM0ZTUq12X/DcNPeCcreRhIEGU5c473
         tplXuWIWR80tZi94jsXsW9LbmVH0mU1xGrXQJgLidd+oqlPUkRSlZgZ3kJ1zt0Zs4Z/h
         iVwiFqFsoqXrzRsD/80e0iJI+ElqXVWr+zeUX5i662Lr58YYWQFbC+XEQHqwTrZ52/i7
         S1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tkyjDeEozETacXNRr3uxxFjEe+DOSkNiETr7ujJ7mA4=;
        b=rEgwT0ZbXNTE+tR82bQrOlKADOrPeQE9BzXIQ40wkQ3nALEqkuNPYO5uXNK6fTvf5L
         xkslt5ZEM1cN0pNvVQPDQD8+3SVVfNqhkbIrwYhKzrv6ymwVBkz+JLJh6fR8IKOIx6G6
         v0OddlOcBiWD+jA0M9w+I7dr2fPn7TFoubyzfGJ0cThELC+JFWgPe7XXRBOAWCxoTlKW
         LLUcA6kpZphz5aUDbASrhefDMDDFxgpC/LiNlN/gydahM9tcSNS1hnH4AcUGt42N1j01
         g4ViN6/jHTfacWAr4Z9VoUI1ms3XfQs5+3VwLsC1knpMg3lGoifpbyKKJhgkA33HPQk4
         H/lw==
X-Gm-Message-State: AOAM531nbeZ+mAt5m9q7abkJtViyJvbkbMUhO89+u+YS8rU7GQPh9Fag
        a81hGNWqixhUjVpouA5gmztu6EnCidt2h6ECb1c=
X-Google-Smtp-Source: ABdhPJy8zXxqgoqnCG7czfw4GIuDC9/xFzn6G7zIEQJby4+MpOb+8f/28WY9QeyW1U8+CILxKbHrHp2ZOuZ7tua7MN0=
X-Received: by 2002:aa7:c983:: with SMTP id c3mr6737425edt.383.1598297381878;
 Mon, 24 Aug 2020 12:29:41 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
 <20200819152120.GA106437@ravnborg.org> <20200819153045.GA18469@pendragon.ideasonboard.com>
 <CALAqxLUXnPRec3UYbMKge8yNKBagLOatOeRCagF=JEyPEfWeKA@mail.gmail.com>
 <20200820090326.3f400a15@coco.lan> <20200820100205.GA5962@pendragon.ideasonboard.com>
In-Reply-To: <20200820100205.GA5962@pendragon.ideasonboard.com>
From:   Dave Airlie <airlied@gmail.com>
Date:   Tue, 25 Aug 2020 05:29:29 +1000
Message-ID: <CAPM=9twzsw7T=GD6Jc1EFenXq9ZhTgf_Nuo71uLfX2W33oa=6w@mail.gmail.com>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        David Airlie <airlied@linux.ie>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        linuxarm@huawei.com, dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        linux-media <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Liwei Cai <cailiwei@hisilicon.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen Feng <puck.chen@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>, Rob Herring <robh+dt@kernel.org>,
        mauro.chehab@huawei.com, Rob Clark <robdclark@chromium.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Liuyao An <anliuyao@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        Rongrong Zou <zourongrong@gmail.com>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 at 20:02, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Mauro,
>
> On Thu, Aug 20, 2020 at 09:03:26AM +0200, Mauro Carvalho Chehab wrote:
> > Em Wed, 19 Aug 2020 12:52:06 -0700 John Stultz escreveu:
> > > On Wed, Aug 19, 2020 at 8:31 AM Laurent Pinchart wrote:
> > > > On Wed, Aug 19, 2020 at 05:21:20PM +0200, Sam Ravnborg wrote:
> > > > > On Wed, Aug 19, 2020 at 01:45:28PM +0200, Mauro Carvalho Chehab wrote:
> > > > > > This patch series port the out-of-tree driver for Hikey 970 (which
> > > > > > should also support Hikey 960) from the official 96boards tree:
> > > > > >
> > > > > >    https://github.com/96boards-hikey/linux/tree/hikey970-v4.9
> > > > > >
> > > > > > Based on his history, this driver seems to be originally written
> > > > > > for Kernel 4.4, and was later ported to Kernel 4.9. The original
> > > > > > driver used to depend on ION (from Kernel 4.4) and had its own
> > > > > > implementation for FB dev API.
> > > > > >
> > > > > > As I need to preserve the original history (with has patches from
> > > > > > both HiSilicon and from Linaro),  I'm starting from the original
> > > > > > patch applied there. The remaining patches are incremental,
> > > > > > and port this driver to work with upstream Kernel.
> > > > > >
> > > ...
> > > > > > - Due to legal reasons, I need to preserve the authorship of
> > > > > >   each one responsbile for each patch. So, I need to start from
> > > > > >   the original patch from Kernel 4.4;
> > > ...
> > > > > I do acknowledge you need to preserve history and all -
> > > > > but this patchset is not easy to review.
> > > >
> > > > Why do we need to preserve history ? Adding relevant Signed-off-by and
> > > > Co-developed-by should be enough, shouldn't it ? Having a public branch
> > > > that contains the history is useful if anyone is interested, but I don't
> > > > think it's required in mainline.
> > >
> > > Yea. I concur with Laurent here. I'm not sure what legal reasoning you
> > > have on this but preserving the "absolute" history here is actively
> > > detrimental for review and understanding of the patch set.
> > >
> > > Preserving Authorship, Signed-off-by lines and adding Co-developed-by
> > > lines should be sufficient to provide both atribution credit and DCO
> > > history.
> >
> > I'm not convinced that, from legal standpoint, folding things would
> > be enough. See, there are at least 3 legal systems involved here
> > among the different patch authors:
> >
> >       - civil law;
> >       - common law;
> >       - customary law + common law.
> >
> > Merging stuff altogether from different law systems can be problematic,
> > and trying to discuss this with experienced IP property lawyers will
> > for sure take a lot of time and efforts. I also bet that different
> > lawyers will have different opinions, because laws are subject to
> > interpretation. With that matter I'm not aware of any court rules
> > with regards to folded patches. So, it sounds to me that folding
> > patches is something that has yet to be proofed in courts around
> > the globe.
> >
> > At least for US legal system, it sounds that the Country of
> > origin of a patch is relevant, as they have a concept of
> > "national technology" that can be subject to export regulations.
> >
> > From my side, I really prefer to play safe and stay out of any such
> > legal discussions.
>
> Let's be serious for a moment. If you think there are legal issues in
> taking GPL-v2.0-only patches and squashing them while retaining
> authorship information through tags, the Linux kernel if *full* of that.
> You also routinely modify patches that you commit to the media subsystem
> to fix "small issues".
>
> The country of origin argument makes no sense either, the kernel code
> base if full of code coming from pretty much all country on the planet.
>
> Keeping the patches separate make this hard to review. Please squash
> them.

I'm inclined to agree with Laurent here.

Patches submitted as GPL-v2 with DCO lines and author names/companies
should be fine to be squashed and rearranged,
as long as the DCO and Authorship is kept somewhere in the new patch
that is applied.

Review is more important here.

Dave.
