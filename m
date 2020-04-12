Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930D91A5FD7
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 20:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgDLSfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 14:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727602AbgDLSfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 14:35:05 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01D8C0A3BFB;
        Sun, 12 Apr 2020 11:29:21 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id l84so4166602ybb.1;
        Sun, 12 Apr 2020 11:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l1Almi3+wVrvMuNfEcQY/Prsa5WLtQ5QpGWPkBf6vrw=;
        b=gZM+RofrEPBp0BKMgy6vVSgiZsYPbWYaL95wwk1AdKKF1ALYqeGH/XrTUAZ16/t3WR
         D/IHTastwy4i0lSMTbmPAQcJhX1BdN5l1LXK1bVOK/1VsoRyLW8izDgWEVhTzK1JMJZJ
         koKz8m18/a3LZxqN6HJOfPtSR/hZ5fykxLc43BO8fWO0bUS5sa5AwJSp6TTmVraPHkKq
         BwPI/4eTYPfJQ+Nv5Vx3d9eDTWiNjhdbKEwKYgEdcgX7Jd34nTex/oXN1jNZnCviX6p8
         xYIw24soVzNgkJA645sl14vyuHux3DK6Kvy6OU2GNvZpWS10AETxBP3ptpnTQvuQHdR0
         Ta9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l1Almi3+wVrvMuNfEcQY/Prsa5WLtQ5QpGWPkBf6vrw=;
        b=DGUT69iI/y+sUBWNTsKuS04KfGMe8K2Cq0J+Xr3a0mVUf4VgtIJdaUZ8+LKB/iLh3G
         3kVn7JEXSiZP9BffAOp/rFAvf2dblmf/69M6EjX/74QouvVKqPdihBR1/dcQpg4wZOCI
         ymBKe3ywnH/ajjewlnyrBbXr/2Eumug0Wddj+Avhd+dBAvLSuUCWN7SQnLMNwCulmh84
         G+leD8bAZ7MaZpNkw+/7zCvojwZ/v9P7ljxV3G72gfSI4iMA6/M5P6cNbwMGgsajNdN0
         w4sELSK3HNbk+JdOc/ImRTVrd6NTOvNpakM1LujGyDsJE5QccMe9bECPBY/4teH0cgkA
         vMVA==
X-Gm-Message-State: AGi0PuZXCAJQL4aGsO+51RnJJQBOyj12UCpG9eKtzV55YsgG3u+aGEc2
        S9XKx8uDFlIXHR4eGuwPEQnFTsVmlR5juWKBqsM=
X-Google-Smtp-Source: APiQypJ6bVLyDRYxQS/yMvjBoWiOIW0+5M1D3D+cItHTcdNdjlbxONqiEnZy1TbCebh2XUm6oLcLJihnX0eR6GX+L7o=
X-Received: by 2002:a25:c64b:: with SMTP id k72mr22720805ybf.177.1586716161083;
 Sun, 12 Apr 2020 11:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200411231413.26911-1-sashal@kernel.org> <20200411231413.26911-9-sashal@kernel.org>
 <CAJ3xEMhhtj77M5vercHDMAHPPVZ8ZF-eyCVQgD4ZZ1Ur3Erbdw@mail.gmail.com> <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200412105935.49dacbf7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Sun, 12 Apr 2020 21:29:10 +0300
Message-ID: <CAJ3xEMiS59mHtAhhejXNEknzq89841TWycZaiq=Q_50p-BqFpg@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.9 09/26] net/mlx5e: Init ethtool steering for representors
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     Sasha Levin <sashal@kernel.org>, Stable <stable@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 12, 2020 at 8:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Sun, 12 Apr 2020 10:10:22 +0300 Or Gerlitz wrote:
> > On Sun, Apr 12, 2020 at 2:16 AM Sasha Levin <sashal@kernel.org> wrote:
> >
> > > [ Upstream commit 6783e8b29f636383af293a55336f036bc7ad5619 ]
> >
> > Sasha,
> >
> > This was pushed to net-next without a fixes tag, and there're probably
> > reasons for that.
> > As you can see the possible null deref is not even reproducible without another
> > patch which for itself was also net-next and not net one.
> >
> > If a team is not pushing patch to net nor putting a fixes that, I
> > don't think it's correct
> > to go and pick that into stable and from there to customer production kernels.
> >
> > Alsom, I am not sure what's the idea behind the auto-selection concept, e.g for
> > mlx5 the maintainer is specifically pointing which patches should go
> > to stable and
> > to what releases there and this is done with care and thinking ahead, why do we
> > want to add on that? and why this can be something which is just
> > automatic selection?
> >
> > We have customers running production system with LTS 4.4.x and 4.9.y (along with
> > 4.14.z and 4.19.w) kernels, we put lots of care thinking if/what
> > should go there, I don't
> > see a benefit from adding auto-selection, the converse.
>
> FWIW I had the same thoughts about the nfp driver, and I indicated to
> Sasha to skip it in the auto selection, which AFAICT worked nicely.
>
> Maybe we should communicate more clearly that maintainers who carefully
> select patches for stable should opt out of auto-selection?

+1
