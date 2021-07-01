Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7523B95F7
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhGASOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233140AbhGASOC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 14:14:02 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7D5C061765
        for <netdev@vger.kernel.org>; Thu,  1 Jul 2021 11:11:31 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id r16so9691622ljk.9
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 11:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mhB/YI84F2jHO2Py8UfLFqOobb3dwNmtuci/rX0g1cM=;
        b=jasMDnHxjyvUllqlfSgbkf3lsM1C59ID2VwFAdbjR9jGHNGK1c2ePnhO1K6hQd4uHR
         VNFP4RkpTx7f7HnBJ1LkRS5Ak84RttR+CblcIUzjyT1uvl9F/Q9fYLgYsI7SIBGe0+VC
         MXZTwtPrF00/sqmgD0tpytwSPhW2eYdAr2tt1K86OJeSK4UdjflKRozDqyGvo2LnmGNd
         P5O4Ey4joC6Wkcv4izcVRLLTbA8iOYxYOUC/sk4kDRh+2zGG4mi+7NF5DdZbNBr7ASwH
         PDSFwbXmoTxzDNDMVAYbsyKsB8xS9Wr9Xfi4CGlSRBwXaPvtjjLSp+4TAns0df3xBvF5
         1HZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mhB/YI84F2jHO2Py8UfLFqOobb3dwNmtuci/rX0g1cM=;
        b=bcFmsS1ykC9hQDcQhEKQ12aUBl80+D88W/Lyg0yL1vu1pCaXI5UrSPCD7F9KcSJhlX
         DhUUbpfGj0tbUm8ahdBx4+W0OKT3Fiyf2Es2kihL+D3etyLEMK4y12NtaftLmpjTlEW3
         QeuwC3emdDoX/S16laiPt5DB4jTWytsOLT4hvQ0/6aFD2VN0wCQ0oHinsGYMh92iYspb
         lA0Aa4q/GXt8mZ10gKZ9PYbSjPM6/7begyqmodJt2TLvvkmrAI+CUkVOG/c9y86vTfZ8
         MDwhK5YsHiuf4yVxU+ati2Jt+QebYXS2y/PAkLUa5FY4zrTDu40dz/NUmxHd3ZsU8oWf
         o6vQ==
X-Gm-Message-State: AOAM531InDqJSK6mD2nlitsTg7P0GYmVI3efw6WScD17gCxwrWD4XwGX
        rJy+nKRunGrSUFwy3Rd3WIwmnzDN9jX/wGYOevCuag==
X-Google-Smtp-Source: ABdhPJzwrzWKarSKuQaZfnYcXLi//voBFmL1XAoyCfEpVCtf51jw2GU48PRryMrkCjV1uF3c6fUtqkW0zqveSiAJIiY=
X-Received: by 2002:a2e:9e04:: with SMTP id e4mr613052ljk.431.1625163089028;
 Thu, 01 Jul 2021 11:11:29 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1625118581.git.christophe.jaillet@wanadoo.fr>
 <CAErkTsQLP9_y-Am3MN-O4vZXe3cTKHfYMwkFk-9YWWPLAQM1cw@mail.gmail.com> <29632746-3234-1991-040d-3c0dfb3b3acb@wanadoo.fr>
In-Reply-To: <29632746-3234-1991-040d-3c0dfb3b3acb@wanadoo.fr>
From:   Jeroen de Borst <jeroendb@google.com>
Date:   Thu, 1 Jul 2021 11:11:17 -0700
Message-ID: <CAErkTsS36YV2f4sHMDyKMTteGOwF+wGmvqfpqj36vh41gPz-2A@mail.gmail.com>
Subject: Re: [PATCH 0/3] gve: Fixes and clean-up
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     csully@google.com, sagis@google.com, jonolson@google.com,
        davem@davemloft.net, kuba@kernel.org, awogbemila@google.com,
        willemb@google.com, yangchun@google.com, bcf@google.com,
        kuozhao@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 10:42 AM Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> Le 01/07/2021 =C3=A0 18:20, Jeroen de Borst a =C3=A9crit :
> > On Wed, Jun 30, 2021 at 10:58 PM Christophe JAILLET
> > <christophe.jaillet@wanadoo.fr> wrote:
> >>
> >> This serie is part of the effort to axe the wrappers in
> >> include/linux/pci-dma-compat.h
> >>
> >> While looking at it, I spotted:
> >>    - a resource leak in an error handling path (patch 1)
> >>    - an error code that could be propagated. (patch 2)
> >>      This patch could be ignored. It's only goal is to be more consist=
ent
> >>      with other drivers.
> >>
> >> These 2 paches are not related to the 'pci-dma-compat.h' stuff, which =
can
> >> be found in patch 3.
> >>
> >> Christophe JAILLET (3):
> >>    gve: Fix an error handling path in 'gve_probe()'
> >>    gve: Propagate error codes to caller
> >>    gve: Simplify code and axe the use of a deprecated API
> >>
> >>
> >
> > Thanks for these patches.
> >
> > Can split this into 2 patch series;
>
> Sure.
>
> > one for net (with the first 2
> > patches) and one for net-next (with the cleanup one)?
>
> I've never worked with net and net-next directly.
> If just adding net and net-next after [PATCH] in the subject of the
> mail, yes, I can do it if it helps.
>
>
> BTW, I gave a look at https://patchwork.kernel.org/project/netdevbpf/list=
/
> The patch 1/3 is marked as failed because "1 blamed authors not CCed:
> lrizzo@google.com; 1 maintainers not CCed: lrizzo@google.com"
>
> This author/blame was not spotted by get_maintainer.pl. Is it something
> I should worry about?
>
>
> > Also the label in the first patch should probably read
> > 'abort_with_gve_init' instead of 'abort_with_vge_init'.
>
> Good catch. Sorry about that.
>
> >
> > Jeroen
> >
>
> CJ
>

[again, now in plaintext, sorry for the spam]

You tag the patch sets with [PATCH net <n>/2] for the 2 fixes and just
[PATCH net-next] for the cleanup one.

You can cc Luigi (lrizzo@google.com) on that one patch for
completeness, but I think it shouldn't be necessary.

Thanks!
