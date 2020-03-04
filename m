Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A99178DC7
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 10:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729144AbgCDJsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 04:48:05 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45436 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgCDJsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 04:48:05 -0500
Received: by mail-qk1-f193.google.com with SMTP id z12so918761qkg.12
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 01:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zscJ32P56RkRvka1xpCzk5fGOD6b0wJkX5evmg+s5yE=;
        b=CGadJ0YknLaDTzeaRdUgsmZ4v28SpzNM5az3jG0P7N23Kk7a/amQJqsSi/dZmPvtWo
         FgJAd6D8Xo8HkSByFJhQVVJawQW6syNPKG5F9FQq2QKF4PMpJiZBFoSg6B8jg+PKaq/Q
         7y9FecGIzefooqVtRPjiWGSG00VzaKLty9BooQcSZZASFW9cV6EMf9qmgadkfl3Db0Zw
         rn4WotvGAglc1LQgjVktpHUr6bH9YZ3pNy2Idq/cveI8Bo9lVMsHzFPnBB0PTvfTSQUD
         4aX9FYeSTugRvEt/KEVsw7JMnIo/rua1699FgRgXlsFLnnzOwUb26Olly9lnIbQe1VFk
         uREA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zscJ32P56RkRvka1xpCzk5fGOD6b0wJkX5evmg+s5yE=;
        b=aTQdtisdimsLtuAsJZrMxT17RM2LtuhOXqmkUn5qqVNC2D2me2/Jr1WI3ilhSTIzyr
         xaMTzHK6K1fPiYOBjEZeNnFpmhtPUey2Ai5rfjca+b4h/YtE1dH6WWGazM0tgKydoGDy
         TUSSSzCHzyh+4ZQbl0K+cLxM1IYIHhTMOOdaOOtAY0ZQ3djaus+r9Oqgl66BrrzKjXHi
         17WrHXEULLj1jnkJ5kS86tcv8meTZqhAV2za8+OGxekGFd7P6rqu/AqRQldp1twL68Yi
         R+/isY4c5kXpw8mn9bU2r61vAc2yf3oJBeZb+EdYonAMudIqX2FBc08MDENK3/r8GGtY
         wrxw==
X-Gm-Message-State: ANhLgQ2/icXnfnWXMSwgf99GDZtUVOsVJVkBrtAM8skKlUpxLUedP7zT
        Icmr5PfzmyHCxlQ+Da3+38bVW5KwOmRoAjX6yH0=
X-Google-Smtp-Source: ADFU+vsO0qVPR7N2vyWIYzH/UsXMDCRj870Sux/XbtY92GKc09GONJKct2ks4i8nJtLw2qXHzmhm5i8lZo04+sAW2yk=
X-Received: by 2002:a05:620a:1458:: with SMTP id i24mr2125436qkl.435.1583315283551;
 Wed, 04 Mar 2020 01:48:03 -0800 (PST)
MIME-Version: 1.0
References: <CAA85sZsO9EaS8fZJqx6=QJA+7epe88UE2zScqw-KHZYDRMjk5A@mail.gmail.com>
 <32234f4c5b4adcaf2560098a01b1544d8d8d3c2c.camel@mellanox.com>
 <CAA85sZuoiWSfMt8H+pjN-Ly=f2wNwG5tPiFZzcc6-1F3fqcO9Q@mail.gmail.com> <CAA85sZv+6UGXoN-eHysfojK8JtvWnRiJ8xs_QZ6hM=SveQ5CpQ@mail.gmail.com>
In-Reply-To: <CAA85sZv+6UGXoN-eHysfojK8JtvWnRiJ8xs_QZ6hM=SveQ5CpQ@mail.gmail.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Wed, 4 Mar 2020 10:47:52 +0100
Message-ID: <CAA85sZvi+7NLdacfhp=_VA5nAtpbcN6XYwF0+vvtwkFnZK8pBA@mail.gmail.com>
Subject: Re: [VXLAN] [MLX5] Lost traffic and issues
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 3, 2020 at 11:23 AM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> On Mon, Mar 2, 2020 at 11:45 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > On Mon, Mar 2, 2020 at 8:10 PM Saeed Mahameed <saeedm@mellanox.com> wrote:
>
> [... 8< ...]
>
> > > What type of mlx5 configuration you have (Native PV virtualization ?
> > > SRIOV ? legacy mode or switchdev mode ? )
> >
> > We have:
> > tap -> bridge -> ovs -> bond (one legged) -switch-fabric-> <other-end>
> >
> > So a pretty standard openstack setup
>
> Oh, the L3 nodes are also MLX5s (50gbit) and they do report the lag map thing
>
> [   37.389366] mlx5_core 0000:04:00.0 ens1f0: S-tagged traffic will be
> dropped while C-tag vlan stripping is enabled
> [77126.178520] mlx5_core 0000:04:00.0: modify lag map port 1:2 port 2:2
> [77131.485189] mlx5_core 0000:04:00.0 ens1f0: Link down
> [77337.033686] mlx5_core 0000:04:00.0 ens1f0: Link up
> [77344.338901] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
> [78098.028670] mlx5_core 0000:04:00.0: modify lag map port 1:2 port 2:2
> [78103.479494] mlx5_core 0000:04:00.0 ens1f0: Link down
> [78310.028518] mlx5_core 0000:04:00.0 ens1f0: Link up
> [78317.797155] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
> [78504.893590] mlx5_core 0000:04:00.0: modify lag map port 1:2 port 2:2
> [78511.277529] mlx5_core 0000:04:00.0 ens1f0: Link down
> [78714.526539] mlx5_core 0000:04:00.0 ens1f0: Link up
> [78720.422078] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
> [78720.838063] mlx5_core 0000:04:00.0: modify lag map port 1:2 port 2:2
> [78727.226433] mlx5_core 0000:04:00.0 ens1f0: Link down
> [78929.575826] mlx5_core 0000:04:00.0 ens1f0: Link up
> [78935.422600] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
> [79330.519516] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:1
> [79330.831447] mlx5_core 0000:04:00.0: modify lag map port 1:2 port 2:2
> [79336.073520] mlx5_core 0000:04:00.1 ens1f1: Link down
> [79336.279519] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:1
> [79541.272469] mlx5_core 0000:04:00.1 ens1f1: Link up
> [79546.664008] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
> [82107.461831] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:1
> [82113.859238] mlx5_core 0000:04:00.1 ens1f1: Link down
> [82320.458475] mlx5_core 0000:04:00.1 ens1f1: Link up
> [82327.774289] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
> [82490.950671] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:1
> [82497.307348] mlx5_core 0000:04:00.1 ens1f1: Link down
> [82705.956583] mlx5_core 0000:04:00.1 ens1f1: Link up
> [82714.055134] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
> [83100.804620] mlx5_core 0000:04:00.0 ens1f0: Link down
> [83100.860943] mlx5_core 0000:04:00.0: modify lag map port 1:2 port 2:2
> [83319.953296] mlx5_core 0000:04:00.0 ens1f0: Link up
> [83327.984559] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
> [83924.600444] mlx5_core 0000:04:00.0 ens1f0: Link down
> [83924.656321] mlx5_core 0000:04:00.0: modify lag map port 1:2 port 2:2
> [84312.648630] mlx5_core 0000:04:00.0 ens1f0: Link up
> [84319.571326] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
> [84946.495374] mlx5_core 0000:04:00.1 ens1f1: Link down
> [84946.588637] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:1
> [84946.692596] mlx5_core 0000:04:00.0: modify lag map port 1:2 port 2:2
> [84949.188628] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:1
> [85363.543475] mlx5_core 0000:04:00.1 ens1f1: Link up
> [85371.093484] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
> [624051.460733] mlx5_core 0000:04:00.0: modify lag map port 1:2 port 2:2
> [624053.644769] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:1
> [624053.674747] mlx5_core 0000:04:00.0: modify lag map port 1:1 port 2:2
>
> Sorry, it's been a long couple of weeks ;)

I made them one-legged but it doesn't seem to help

Someone also posted this:
https://marc.info/?l=linux-netdev&m=158330796503347&w=2

While I don't use IPVS - I do use VXLAN and if checksums are incorrectly tagged
the nic might drop it?

> > > The only change that i could think of is the lag multi-path support we
> > > added, Roi can you please take a look at this ?
> >
> > I'm also trying to get a setup working where i could try reverting changes
> > but so far we've only had this problem with mlx5_core...
> > Also the intermittent but reliable patterns are really weird...
> >
> > All traffic seems fine, except vxlan traffic :/
> >
> > (The problem is that the actual machines that has the issue is in production
> > with 8x V100 nvidia cards... Kinda hard to justify having them "offline" ;))
