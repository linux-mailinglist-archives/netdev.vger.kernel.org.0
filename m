Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750873B6B9E
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 02:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhF2AH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 20:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhF2AH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 20:07:57 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6EBC061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 17:05:30 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id i18so15088921yba.13
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 17:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=x64architecture.com; s=x64;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fZZJtUSCgkfnvfZjyclUt/ps5j/GT2thD/tXo+du3SA=;
        b=Cg1Hw6/dRkoOkruMR9qx3/5+X1ZQ/kiOgeGADfrZY8mS7SAfNEn89mNxuYD/R7efEv
         esIpj/E1Zx6lkg0Orlj/zoQDurpBJSQywlCpNvXdvkY9Cs8ZyOPP4ZnODoFSt46JpcbU
         CYzCtTfwFF2ai78j5SmfH7yLUQYdOZMpfvnH2HfBUCVYu9Lj0LqlgkHIdIQK+dZcOuve
         KgDBstZ6Y87US+pJrfuSN59rK38ESwSKO92cxrtiY/K3fE1vnksDN6EfS4nlH+0DnLE7
         t2Dqwv1/HoHqy6Gr9TKzVBVvTRhbBwmbBzNWpQieTK88HZ3VsDlD3JPyHDeRqWpbn2H8
         psFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fZZJtUSCgkfnvfZjyclUt/ps5j/GT2thD/tXo+du3SA=;
        b=mjoGhSsbACdUaI2Qvy083W0gHW8Rj0ZFQ9PKnRFd2KWkUj/AAwWXTUMPsmXfbDyyBZ
         gT2jcTynoQbBefpdlLjmNlSJUZJxo82vWuDQyP2QqickB1RZ87F0WlaTqTxBSYDfuywy
         fA8Euac+cJGnmdaRvQj1HfOzhH72OaV6srkcuDlA3Klxshg04v4XK/FnSVIQNETBIua1
         RIRAX3AssNfL+FQC3TDNBYEmCFekGSR1Tw0uQVhV0wsOLSgKyI3W9s21R6OKcnQwO53u
         e+eJQ6SZVPeP72dGTwDrKBWNNuW8E+wmC1w4nno3omftApmwF7+z4vBbTzyn+0GaPoDa
         NHxg==
X-Gm-Message-State: AOAM530NhQvM4Swh1cLS+Y+krQwlw/AHKE1ehwSlvGjgV6hI4qLSOXxO
        1tH5dnp2ofdNPDSZ/hKPl/MBVSlo9yhl3OrJjWUgkvG0RSTvK4Ev
X-Google-Smtp-Source: ABdhPJz9Ws6uXSusQ8lEaqINxkSRGYgRzMItbKoJROZu6kHau8RWoh6RJlsVgLLbckUtcovkTwS1nuUwFUylODeDcuo=
X-Received: by 2002:a5b:c83:: with SMTP id i3mr6315275ybq.41.1624925129396;
 Mon, 28 Jun 2021 17:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210628192826.1855132-1-kurt@x64architecture.com>
 <20210628192826.1855132-2-kurt@x64architecture.com> <20210629004958.40f3b98c@thinkpad>
 <CAPv3WKfcHZ642S1SczFNMruq64H9E6x0KD5+bYWHcs3uu058cQ@mail.gmail.com>
In-Reply-To: <CAPv3WKfcHZ642S1SczFNMruq64H9E6x0KD5+bYWHcs3uu058cQ@mail.gmail.com>
From:   Kurt Cancemi <kurt@x64architecture.com>
Date:   Mon, 28 Jun 2021 20:05:19 -0400
Message-ID: <CADujJWW=QbsRcrvF+7UxWZssMJ0iK1+xq+mfCTAVb7SkKKXcaA@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: phy: marvell: Fixed handing of delays with plain
 RGMII interface
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Well I'm sorry for the noise I was running into a lot of other DPAA
ethernet related issues and overlooked adding phy-mode =3D "rgmii-id";
that fixed the issue. I knew my patch was not correct (as I explained
in the cover email) but I was not sure why it was necessary but now I
see it was not necessary I just had "phy-connection-mode" instead of
"phy-mode".

May I ask what is the purpose of phy-connection-mode? And why did the
DPAA driver recognize the PHY interface mode as RGMII ID but the
Marvell PHY driver didn't?

On Mon, Jun 28, 2021 at 7:01 PM Marcin Wojtas <mw@semihalf.com> wrote:
>
> Hi Kurt,
>
>
> wt., 29 cze 2021 o 00:50 Marek Beh=C3=BAn <kabel@kernel.org> napisa=C5=82=
(a):
> >
> > On Mon, 28 Jun 2021 15:28:26 -0400
> > Kurt Cancemi <kurt@x64architecture.com> wrote:
> >
> > > This patch changes the default behavior to enable RX and TX delays fo=
r
> > > the PHY_INTERFACE_MODE_RGMII case by default.
> >
> > And why would we want that? I was under the impression that we have the
> > _ID variants for enabling these delays.
> >
>
> +1
>
> From Documentation/devicetree/bindings/net/ethernet-controller.yaml
>
>       # RGMII with internal RX and TX delays provided by the PHY,
>       # the MAC should not add the RX or TX delays in this case
>       - rgmii-id
>
> I guess you should rather fix the hardware description of your board,
> i.e. use `phy-mode =3D "rgmii-id"` instead of tweaking the PHY driver
> itself.
>
> Best regards,
> Marcin
