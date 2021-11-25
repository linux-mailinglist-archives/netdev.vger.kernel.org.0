Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB39D45D481
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 07:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhKYGGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346357AbhKYGEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 01:04:41 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317CAC061746
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 22:01:02 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id n12so13525231lfe.1
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 22:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dPupwsrytkX4f6TjUKDkfvkvZARFfjXKHG9DzShvmaI=;
        b=HLhsqbCh6JoKMt2JVsMeXUgfz7lhLEA/WgOU48kc9eNi7HwToRa7IviokA5oNXxRpz
         BuqZIQwixQB8vFTBND5GjpE6ohBy7hL8q51mJVofHWHmWCcNvqn1JZKysGyD7w1B8qV0
         x/XziNNk8fZcHWZuzHjWcxCdEnFSLrSVzoz3ND1dvE6vyhkgm2gLYxxcn17Txhg9Fy4E
         Zghh96w6NpMcO0YCnyn7lZPrwffyIl7B2j1OAdVnTVfdK3TK4ZXXngSqxaKFQafXrSI6
         XA8lUXeoAbGKtx/VjudVEnrjPfC4tGQ/wND33W4UpnNihdOVmTxpmFjJvMnEaTF/m4C4
         moLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dPupwsrytkX4f6TjUKDkfvkvZARFfjXKHG9DzShvmaI=;
        b=SII+Dp69GOh/QywUSL4oIw/am86UcotGOaOP7Saz/BT/FvD8G7dLX1vWAlspmRxBDA
         fEPj7JX0uv7qKsfPZ0taGH+jj9x4xL9HS+Zl3KBNSlKZhunYpGkHeyfuenqMAolm8GGJ
         ZP35JCK7RJe61mvGjmMx+1oqNC/bx/sR59eSrYVXAzrP8acV1XjiC2BESN7kncTB0i8f
         Ew3b0P5ozMCWRbYtfYJR8Q5a0znLgMwIFUeHFSoxIZxA4v4PxDPdVO1pmXkrHgsDM3wM
         B+lcTFJ3at4omtd0HENuy82B0JAI9+90ZAJmmHvqw+D1yHQ/Tq2uLXGms3z6ByodoR5i
         irRg==
X-Gm-Message-State: AOAM530GtDEVadbVgzUx8sfDai97Ur1m9RXs3tUsgGjdfJ9v0p+NAoRS
        QRKf3H9rutwBJX/n7XLJbyB5cblGvTcRok1WvZWLGlKQ
X-Google-Smtp-Source: ABdhPJwnZ8KTgDgxgpadGRvgYwacMJGG/3x+0nyWMpbKBLnzWVf2p25RbKHNyScv1altF0D23LSYMfYWPzCAnVKMW3Y=
X-Received: by 2002:a05:6512:ac5:: with SMTP id n5mr20558835lfu.246.1637820060362;
 Wed, 24 Nov 2021 22:01:00 -0800 (PST)
MIME-Version: 1.0
References: <20211125021822.6236-1-radhac@marvell.com> <CAC8NTUX1-p24ZBGvwa7YcYQ_G+A_kn3f_GeTofKhO7ELB2bn8g@mail.gmail.com>
 <20211124192710.438657ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124192710.438657ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Radha Mohan <mohun106@gmail.com>
Date:   Wed, 24 Nov 2021 22:00:49 -0800
Message-ID: <CAC8NTUUdZSuNtjczBvEZPaAbzaP4rWyR9fDOWC9mdMHEqiEVNw@mail.gmail.com>
Subject: Re: [PATCH] octeontx2-nicvf: Add netdev interface support for SDP VF devices
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sgoutham@marvell.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 7:27 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Nov 2021 18:21:04 -0800 Radha Mohan wrote:
> > This patch adds netdev interface for SDP VFs. This interface can be used
> > to communicate with a host over PCIe when OcteonTx is in PCIe Endpoint
> > mode.
>
> All your SDP/SDK/management interfaces do not fit into our netdev
> model of the world and should be removed upstream.

SDP is our System DMA Packet Interface which sends/receives network
packets to NIX block. It is similar to CGX, LBK blocks but only
difference is the medium being PCIe. So if you have accepted that I
believe you can accept this as well.

>
> The pleasure I have from marking this as rejected is slightly
> undermined by the fact that the patch isn't even correctly formatted :/
Apologies for that. Something messed up the tabs to spaces. I can
correct that in next version.
