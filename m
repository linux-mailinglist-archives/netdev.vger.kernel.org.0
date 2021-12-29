Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB19C48166D
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 20:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhL2Tq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 14:46:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhL2Tq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 14:46:56 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D7CC061574;
        Wed, 29 Dec 2021 11:46:55 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id t14so8888263ljh.8;
        Wed, 29 Dec 2021 11:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qVJ/y+64l3sbtg3AQgJAEvi8CQ3pfU+MbHqQhMEFY30=;
        b=OnPePvU1bXSMAsVXP285imYJz6zhETG+GPOpfoZ6DxhtUCSQK0UaoOIfelgIkSpDKH
         euAD/aGOfuwgYQvRqkTkO98XPCaFB2SS7DsTWe4y9V6WTDYU2qMDKrakn2DirBRKeTZf
         +pnVWKBCNyYSjNjztxOm81CwKnyhjayaLsNDYBG6Ltg2vsmtQdAXirfJ51TF/zTpN+0c
         T/wU5cArvxdDvNR+6hNhhfPllFyTrVzP0KCPBrRlPkrBvyIqhYVe/tyIn4wINrKMdv26
         VjSPoCruptHSYgxpIqWNwRo7K0A025nRUAWMZjBBUi3eaYLD2rrZRPPb6ikvRHwDxKNI
         MbXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qVJ/y+64l3sbtg3AQgJAEvi8CQ3pfU+MbHqQhMEFY30=;
        b=F3NT9GVs3vnyBy4y4YABGrWRiA2/F741nVOt1lQhVkXHAAx4XVWhqR5pmwTW5ipOGz
         sqhC2lf005VfosErb2YGDLNJuLrzbKX8I4X/cXYqgyT7oD0eZOP4KzUNyH1i2YiwdPSj
         ipe1t10PCdYXUGFZWus3OleAwrtsqs8WqTm/nCS5CwNIIH/mhyB4+H7J8Gabg4cCZsFY
         Ou6iUYS+nb/7kwGLcAVi7Ddww9Xw+3c3VImnV/TubOZtP3UBSTaYL/m33lgXR/0fdY5C
         Hpwac21qcuY4WsJJw4D39/pdjgwpEkc6KfQonNYDlYwJgenmKTLjI28w1XjITnNEnTUc
         CjPw==
X-Gm-Message-State: AOAM531j2W+Amp521Wcyp2jI5pLloxrCpa4zs0wwOPw7GjHUwooSY2w0
        sY50yNZ6llRXAy3PI9jtX+2IVJqheRqvQSKdxhhmkfGg1/M=
X-Google-Smtp-Source: ABdhPJyfY2mufyPMdyy8F9EqizAC9SnjkCDslGjUAcSoIKMi0atP4YtWsIy3x9E/30/JDqnUgrwOPzvgE2HTnEDkosM=
X-Received: by 2002:a05:651c:d5:: with SMTP id 21mr20529658ljr.433.1640807212809;
 Wed, 29 Dec 2021 11:46:52 -0800 (PST)
MIME-Version: 1.0
References: <CAJ-ks9kd6wWi1S8GSCf1f=vJER=_35BGZzLnXwz36xDQPacyRw@mail.gmail.com>
 <CAJ-ks9=41PuzGkXmi0-aZPEWicWJ5s2gW2zL+jSHuDjaJ5Lhsg@mail.gmail.com>
 <20211228155433.3b1c71e5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <CA+FuTSeDTJxbPvN6hkXFMaBspVHwL+crOxzC2ukWRzxvKma9bA@mail.gmail.com>
In-Reply-To: <CA+FuTSeDTJxbPvN6hkXFMaBspVHwL+crOxzC2ukWRzxvKma9bA@mail.gmail.com>
From:   Tamir Duberstein <tamird@gmail.com>
Date:   Wed, 29 Dec 2021 14:46:41 -0500
Message-ID: <CAJ-ks9=3o+rVJd5ztYbkgpcYiWjV+3qajCgOmM7AfjhoZvuOHw@mail.gmail.com>
Subject: Re: [PATCH] net: check passed optlen before reading
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm having some trouble sending this using git send-email because of
the firewall I'm behind.

Please pull from
  git://github.com/tamird/linux raw-check-optlen
to get these changes:
  280c5742aab2 ipv6: raw: check passed optlen before reading

If this is not acceptable, I'll send the patch again when I'm outside
the firewall. Apologies.

On Wed, Dec 29, 2021 at 10:09 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Tue, Dec 28, 2021 at 6:54 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Tue, 28 Dec 2021 16:02:29 -0500 Tamir Duberstein wrote:
> > > Errant brace in the earlier version.
> > >
> > > From 8586be4d72c6c583b1085d2239076987e1b7c43a Mon Sep 17 00:00:00 2001
> > > From: Tamir Duberstein <tamird@gmail.com>
> > > Date: Tue, 28 Dec 2021 15:09:11 -0500
> > > Subject: [PATCH v2] net: check passed optlen before reading
> > >
> > > Add a check that the user-provided option is at least as long as the
> > > number of bytes we intend to read. Before this patch we would blindly
> > > read sizeof(int) bytes even in cases where the user passed
> > > optlen<sizeof(int), which would potentially read garbage or fault.
> > >
> > > Discovered by new tests in https://github.com/google/gvisor/pull/6957 .
> > >
> > > Signed-off-by: Tamir Duberstein <tamird@gmail.com>
> >
> > Your patches are corrupted by your email client.
> >
> > Can you try sending the latest version with git send-email?
>
> Then perhaps also update the subject line to make it more clear where
> this applies: "ipv6: raw: check passed optlen before reading".
