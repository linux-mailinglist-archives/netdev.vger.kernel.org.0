Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7900314D8F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhBIKwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:52:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231876AbhBIKu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:50:28 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DB1C061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 02:49:47 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id l8so5343364ybe.12
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 02:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mWnGVpGdIniN/JBQucs5qFSgacY7h12miIr8vgpNNDk=;
        b=M6u3jS3Ck/wVDX/3hOEfLaVx4mode1StZcBVz6LY1LOOrwy0xw7FqRsHamdXVIvOwF
         muQbDwrpOFl5HLY2z0FdHRdW/reuuPosp4M446G9PGwfG2uDYj8h6jQLxHrDpVZMzUoy
         qcd9XB0xmgZuD56sTGFsBiygs08gZsZJdgh2oVJuDLb589AYbOsalsrd/s5J1waOF4Qi
         rG6zdkxiRMsuLM09aRXwCyzBewgJzPxYoAC0i0olFxyV0bIVMcYdDBPjJ4gDyOXSG+UB
         gKgFwq6oC5h8Eut5qJLT2vQMaUCwp+icaSJGeAYRXgNFHNZ1RS1FWYHJGNzauwT2IKBB
         /iOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mWnGVpGdIniN/JBQucs5qFSgacY7h12miIr8vgpNNDk=;
        b=GewUbQdrkwReDiUn+Io4HmYtlejT21BinOKUoy8ggRGIXxhdD0WyFgOL/UTPKfmGMA
         gplmoVOjhoJbHL2J/kOYisjZu65JJ894nZHko6/yUfxCBXCSkdhTsyCf4hDMpggz8tDv
         WULycp1NXZTrRlC0um3IMLs1iACEk02U3cTdR5OYFA0Kwa7dBxmifW1P6PgEaTaVBuyF
         XqcAIcHd0MICqvkxJcMamYYH1eBavDvnUN7XaLuY/1iJD9LTRXXZW0EK+BoaAGeIS8T4
         Ns8iR7AkngPHFcFpD1oSw7ejyS5qIv+3ZxVn4Hlj5rXrtE1NrD99Gw4dXUR2aBcti4Fz
         4qTw==
X-Gm-Message-State: AOAM531dEkumjUodUrSEMVKtIetGFWSl0lvqlsCXrhpSK5H62rhmDJ3u
        ST742pLfU2Nmi5FOUp4aFIeIzdAB12Kag15zKQvKL/+ZSVE=
X-Google-Smtp-Source: ABdhPJwTc1hwrjCvN1mpRFPSn1O68VHy+iD8al0fY6NCQAzsS0utVvGa0RQdYTljnOJmv/by0Vxx6nuX1l4wfAHfa0c=
X-Received: by 2002:a25:5388:: with SMTP id h130mr30799930ybb.329.1612867787011;
 Tue, 09 Feb 2021 02:49:47 -0800 (PST)
MIME-Version: 1.0
References: <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130144231.GA3329243@shredder.lan> <8924ef5a-a3ac-1664-ca11-5f2a1f35399a@nvidia.com>
 <20210201180837.GB3456040@shredder.lan> <20210208070350.GB4656@unreal>
 <20210208085746.GA179437@shredder.lan> <20210208090702.GB20265@unreal>
 <20210208170735.GA207830@shredder.lan> <20210209064702.GB139298@unreal>
 <CAJ3xEMh72mb9ZYd8umr-FTEO+MV6TNyqST2kLAz_wdLgPcFnww@mail.gmail.com> <20210209100119.GC139298@unreal>
In-Reply-To: <20210209100119.GC139298@unreal>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 9 Feb 2021 12:49:35 +0200
Message-ID: <CAJ3xEMiKokWFn8MKJoaDD=U80q7FzfRR9YH1ozFTUyR0yO5_TQ@mail.gmail.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 12:01 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Tue, Feb 09, 2021 at 11:25:33AM +0200, Or Gerlitz wrote:
> > On Tue, Feb 9, 2021 at 8:49 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > [..]
> >
> > > This is another problem with mlx5 - complete madness with config opti=
ons
> > > that are not possible to test.
> > > =E2=9E=9C  kernel git:(rdma-next) grep -h "config MLX" drivers/net/et=
hernet/mellanox/mlx5/core/Kconfig | awk '{ print $2}' | sort |uniq |wc -l
> > > 19
> >
> > wait, why do you call it madness? we were suggested by some users (do
> > git blame for the patches) to refine things with multiple configs and i=
t seem
> > to work quite well  -- what you don't like? and what's wrong with simpl=
e grep..
>
> Yes, I aware of these users and what and why they asked it.
>
> They didn't ask us to have new config for every feature/file, but to have
> light ethernet device.
>
> Other users are distributions and they enable all options that supported =
in
> the specific kernel they picked, because they don't know in advance where=
 their
> distro will be used.
>
> You also don't have capacity to test various combinations, so you
> test only small subset of common ones that are pretty standard. This is w=
hy
> you have this feeling of "work quite well".

ok, point taken

> And I'm not talking about compilations but actual regression runs.

understood

> I suggest to reduce number of configs to small amount, something like 3-5=
 options:
>  * Basic ethernet driver
>  * + ETH
>  * + RDMA
>  * + VDPA
>  * ....
>  * Full mlx5 driver

doesn't sound impossible

> And there is nothing wrong with simple grep [..]

no worries
