Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2309428A98D
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 21:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgJKTIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 15:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgJKTIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 15:08:10 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87873C0613CE;
        Sun, 11 Oct 2020 12:08:10 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id u8so16127948lff.1;
        Sun, 11 Oct 2020 12:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GGPf0Ai+cdZzA8pg4bWhAmqLseFTaZSi05u7rjNimbU=;
        b=NGOJ/SWRY4H7gbvG6VzGLMX3GsPv/LWyxJN6wSy0KX5rKiYtswKKK6IDwzpY2gRpqv
         4cQwPMy1BjhPeGkQdiCsGtBwt5AHWBuK1B0yZFSwb/Yn8w/WOSjj8ja8o4d6q4CDKqoJ
         6EdtSXuMetdBIpVEp0DRk8BKUB9q+h+VFiVaX65beZoFfWxJIN1pjUvfy/TznWWkHKud
         XIpUPmacyVBl8QrVkAULFsWe9nUXiCXK9sdMsW66aBQramyBnDgtUaxWTjrqab54Mvcm
         eezM22QunvYG7KqLNE0INkyoYM22fG1rvX+NwsTK9rpO4m5Rh1Nk+mOpUXeFqKN6LfUR
         58yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GGPf0Ai+cdZzA8pg4bWhAmqLseFTaZSi05u7rjNimbU=;
        b=nwONFst3GvQGKYlr169dZP7e9aA9Kt0yQ6dMWLjk17z3Pl8w7JEoO1qLXHqj1ARgG3
         rVmsjCHVp+Q8krDy/ztVSpAEjmflflQn8WiZIpnDY0Ehy3DYiDlHEtIPjiM2EbNLV3XU
         X/4QOQBSt3eTaHtC1FYiBGH+AbxwdwQYIEU8B40VVmAV1JZ4aPGfT8WjLDccq7qnHRVB
         uO/x5CWQhColwOJpYBsM4mhu8MDT/G/OaTkaoS057cLbQdSqftLs9Y87hVH2DNvQbem2
         upD7kR1yZ6uLrVuKJuN7rl71PQNhZveErWvnCL3Ak2j7kjlNCrlY9/Hz0gtzmBdbIic0
         fo/A==
X-Gm-Message-State: AOAM530ET2dEUWzXRQRbzdyZveD084+mHwrN8NNBPndvH9iSCdKgjK5u
        PbrXiR0f0W/xoSy78wXgf32rHXr5EJvcyz3mvrI=
X-Google-Smtp-Source: ABdhPJyLSLt7KFipNUuTUDAvQzA7yv8F0RnrRzO0D6BvjarI40PRbp8W9O5OGB458/Lsjmxt6IF24FLEgnphbXwq1Wc=
X-Received: by 2002:a19:c68a:: with SMTP id w132mr6710919lff.106.1602443288614;
 Sun, 11 Oct 2020 12:08:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201010210929.620244-1-anmol.karan123@gmail.com> <20201011095436.06131ff3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011095436.06131ff3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Anmol karn <anmol.karan123@gmail.com>
Date:   Mon, 12 Oct 2020 00:37:56 +0530
Message-ID: <CAC+yH-YgC1r+-J50TFSkK=NvSE0eHiXNkvgVFuLRQq4daeQZJw@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH net] ethtool: strset: Fix out of
 bound read in strset_parse_request()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, mkubecek@suse.cz,
        andrew@lunn.ch, f.fainelli@gmail.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello sir,
On Sun, Oct 11, 2020 at 10:24 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 11 Oct 2020 02:39:29 +0530 Anmol Karn wrote:
> > Flag ``ETHTOOL_A_STRSET_COUNTS_ONLY`` tells the kernel to only return the string
> > counts of the sets, but, when req_info->counts_only tries to read the
> > tb[ETHTOOL_A_STRSET_COUNTS_ONLY] it gets out of bound.
> >
> > - net/ethtool/strset.c
> > The bug seems to trigger in this line:
> >
> > req_info->counts_only = tb[ETHTOOL_A_STRSET_COUNTS_ONLY];
> >
> > Fix it by NULL checking for req_info->counts_only while
> > reading from tb[ETHTOOL_A_STRSET_COUNTS_ONLY].
> >
> > Reported-by: syzbot+9d1389df89299fa368dc@syzkaller.appspotmail.com
> > Link: https://syzkaller.appspot.com/bug?id=730deff8fe9954a5e317924d9acff98d9c64a770
> > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
>
> I think the correct fix for this was already applied to net-next as:
>
>  commit db972e532518 ("ethtool: strset: allow ETHTOOL_A_STRSET_COUNTS_ONLY attr")

I am glad that it's fixed now.

Thanks,
Anmol
