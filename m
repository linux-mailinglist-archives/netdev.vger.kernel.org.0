Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7456432A1F
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhJRXQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhJRXQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 19:16:54 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF57C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 16:14:42 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id u21so3154336lff.8
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 16:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V/NRdFYpl80V08CXy6GOr+0sN8jJDwhtnVRIDOQ4/LY=;
        b=JhmLwbrpkZVaphRk6H3oEQPvbB97QjZF+XwmMO/7EUaHv/56cNV/67FXWFC7Oycyio
         q/4ynHZ42fj0LvRy8sWWGs5RMfT91y/oMbc5ly5bE/b54gFG9fNnAb2Tkv9ia7iqHh3Q
         Gx8PCA4TqE4tyyIBEwak+538iAHcMGkjf9D27UA3EwA9j37URr3LvbsaUkuH6WkYUgkO
         aeCnz0ff08C+eJFSRqBvrw9u46EMLX231iSxLNAIdePOeEPe+dYoSh22X0z3ILlfG9vr
         AMlUirc9vAHIH84UCOPXq8U6bVCZ5GC2ey/a3qIrSap97LUQDrxxVb8PEo7lb0eVkh27
         MefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V/NRdFYpl80V08CXy6GOr+0sN8jJDwhtnVRIDOQ4/LY=;
        b=W5hgEOrUCIMaaszzONdcHv1iDhBEDf/eZq5grL/9p+o5QYvgd7nmhd7NcHA618aIF8
         bYXbg2/f3wiudRDmQwNFTBF4ajiHhq7Hfgr27mGJGb5mtEeknyChl5MGRZcRJVpOX9sy
         ZlPX4RtogEmWdil7awNqE6deU5Kum6wmT0CyP8e/iFY2ZC/Z5PMynQm+aOZi8tuMlOqn
         wB4NzZp2PbUU9QqUlHVC3XCUV2IWb8CP5wDbFuQl+gYmvJcKla0d67k/TuP2Gllv/Xrg
         jaHfwK2DADwhrgxYCUrLXV4zT/zUt0Cbh/Ym6qOrwJUUq+Aphdqz9vIODJhERWiZUDJd
         LSFg==
X-Gm-Message-State: AOAM532iVPRZ58660CtaPdxfWMIUbU5sbEAK29SMAUbCoIZ5UiB0SkD4
        iz1H/02kaX+AA1xi6aj2rkK1YWuRZXLCWSVN14k=
X-Google-Smtp-Source: ABdhPJw5eCHPJOQD3Khf21jtbz2MulhjE9BybacJe5YE4JHEkNua8YaTpj93tRtZsCOH3rtakFokbwpuMKRZY/+dgd4=
X-Received: by 2002:a05:6512:1152:: with SMTP id m18mr2587872lfg.117.1634598880840;
 Mon, 18 Oct 2021 16:14:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211017145646.56-1-ansuelsmth@gmail.com> <20211018154812.54dbc3ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+_ehUzHm1+7MNNHg7CDmMpW5nZhzsyvG_pKm8drmSa6Mx5tNQ@mail.gmail.com> <20211018160614.4b24959c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211018160614.4b24959c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ansuel Smith <ansuelsmth@gmail.com>
Date:   Tue, 19 Oct 2021 01:14:30 +0200
Message-ID: <CA+_ehUzrSO39rAubFTf2Jvew_cp7aEJVwpE=qih9pWNQKht3NQ@mail.gmail.com>
Subject: Re: [net-next RESEND PATCH 1/2] net: dsa: qca8k: tidy for loop in
 setup and add cpu port check
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> On Tue, 19 Oct 2021 00:54:17 +0200 Ansuel Smith wrote:
> > > > Tidy and organize qca8k setup function from multiple for loop.
> > > > Change for loop in bridge leave/join to scan all port and skip cpu port.
> > > > No functional change intended.
> > > >
> > > > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> > >
> > > There's some confusion in patchwork. I think previous posting got
> > > applied, but patch 1 of this series git marked as applied.. while
> > > it was patch 2 that corresponds to previous posting..?
> > >
> > > Please make sure you mark new postings as v2 v3 etc. It's not a problem
> > > to post a vN+1 and say "no changes" in the change log, while it may be
> > > a problem if patchwork bot gets confused and doesn't mark series as
> > > superseded appropriately.
> > >
> > > I'm dropping the remainder of this series from patchwork, please rebase
> > > and resend what's missing in net-next.
> > >
> > > Thanks!
> >
> > Sorry for the mess. I think I got confused.
> > I resent these 2 patch (in one go) as i didn't add the net-next tag
> > and i thought they got ignored as the target was wrong.
> > I didn't receive any review or ack so i thought it was a good idea to
> > resend them in one go with the correct tag.
> > Hope it's not a stupid question but can you point me where should
> > i check to prevent this kind of error?
>
> You can check in patchwork if your submission was indeed ignored.
>
> All the "active" patches are here:
>
> https://patchwork.kernel.org/project/netdevbpf/list/
>
> You can also look up particular patch by using it's message ID:
>
> https://patchwork.kernel.org/project/netdevbpf/patch/<msg-id>/
>
> E.g.
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20211017145646.56-1-ansuelsmth@gmail.com/
>
> If the patch is in New, Under review or Needs ACK state then there's
> no need to resend.
>
> > So anyway i both send these 2 patch as a dedicated patch with the
> > absent tag.
>
> Ah! I see the first posting of both now, looks like patchwork realized
> it's a repost of patch 1 so it marked that as superseded.

Should I resend just that with the correct tag?
Thx a lot for the hint about patchwork
