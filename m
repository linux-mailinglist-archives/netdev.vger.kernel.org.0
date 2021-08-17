Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578E23EEBF9
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 13:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbhHQLza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 07:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236693AbhHQLz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 07:55:29 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6BBC061764;
        Tue, 17 Aug 2021 04:54:56 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so5946437pjb.2;
        Tue, 17 Aug 2021 04:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Bgl9uVhNiGx/pTbLvHKqn3TMS3R5Cf8IQxryvvFpcpI=;
        b=cJInMwbaIXud/uoN6772D3dlVO8hk6wPZwEBc1b20zqCuxPR10o71pegYZ93fdYyvN
         jmEn+EPbOSCvqRHC3i12bFQAxvbCc3Ve8+z38ya3gSsfBp+osbwJcckMwLZEWnl44ucV
         8tYt3fVdVOGtxBi8C7lPnL4CNNL3cWQPxfdm8m4QAB357NuIQviUoa8S87jjNI1g15bd
         h/+vy0sd4SUD5hY2l9c95k6cuJWFgKv6gMIaIGqHkBZ4SkiH7wLoHKM80sRzvPA0mTwq
         qTjWBpxTPeguzlHG5Z5tngp7J8Ip184D5xC/WMpC1f8j2xQ6/Tu+mxOXq+DAZB3Io4Rs
         ZndQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Bgl9uVhNiGx/pTbLvHKqn3TMS3R5Cf8IQxryvvFpcpI=;
        b=YXazFWG2lMuUL/HqMsLyWv4BV9MycY3WxLIuxV6Wnhjxb85hlUdVxE+szFMjbxmB9t
         8fuzKHdNiIP5XJhW70chs0xcFMGoPqgHCax5FL+LlWHxVq6ejiSMr5TcVM1bVxk3zsPT
         v8OGZRyOPc+XmLzeMM3/5+9KpmLEXdkA+S8aiXMIcYM1CXpG96UbVOR4nIIBVFEin4cm
         3ry8wXfxBMhnZvn9AxRAYugK8+wGH4S+5CcYGiCZ/qkfKUwBoTmLZNdEAjHHFnuUEd5o
         OEnHRwEtHNP2hi6x70NfPfbcHRgqa3nlKfqk8Tl+9/rAwv9S2490zdgBZo3UvIajR0BC
         O5dA==
X-Gm-Message-State: AOAM5319dHGTNnT/eiaPPzKGdtmA6rKsbpqFBGSy7Wmt0F67bLvVRPFh
        yVoupnlpp6lQ/N0p0CWONZJh2JwZcjSL77fS3r4=
X-Google-Smtp-Source: ABdhPJwUnyfxYGu+USswkUnXnwy2QG0hhxlTxixeZifys3CI5PQjx4UNNR+M+K6AuVSGar3L5o3DUlBB09aMOwa10Qg=
X-Received: by 2002:a17:902:ced0:b029:12d:4ce1:ce3a with SMTP id
 d16-20020a170902ced0b029012d4ce1ce3amr2608066plg.0.1629201296064; Tue, 17 Aug
 2021 04:54:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210817063521.22450-1-a.fatoum@pengutronix.de>
 <CAHp75Vfc_T04p95PgVUd+CK+ttPwX2aOC4WPD35Z01WQV1MxKw@mail.gmail.com> <3a9a3789-5a13-7e72-b909-8f0826b8ab86@pengutronix.de>
In-Reply-To: <3a9a3789-5a13-7e72-b909-8f0826b8ab86@pengutronix.de>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 17 Aug 2021 14:54:16 +0300
Message-ID: <CAHp75VfahF=_CmS7kw5PbKs46+hXFweweq=sjwd83hccRsrH9g@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: pcie: fix oops on failure to resume and reprobe
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 2:11 PM Ahmad Fatoum <a.fatoum@pengutronix.de> wrot=
e:
> On 17.08.21 13:02, Andy Shevchenko wrote:
> > On Tuesday, August 17, 2021, Ahmad Fatoum <a.fatoum@pengutronix.de> wro=
te:

...

> >>         err =3D brcmf_pcie_probe(pdev, NULL);
> >>         if (err)
> >> -               brcmf_err(bus, "probe after resume failed, err=3D%d\n"=
, err);
> >> +               __brcmf_err(NULL, __func__, "probe after resume failed=
,
> >> err=3D%d\n",
> >
> >
> > This is weird looking line now. Why can=E2=80=99t you simply use dev_er=
r() /
> > netdev_err()?
>
> That's what brcmf_err normally expands to, but in this file the macro
> is overridden to add the extra first argument.

So, then the problem is in macro here. You need another portion of
macro(s) that will use the dev pointer directly. When you have a valid
device, use it. And here it seems the case.

> The brcmf_ logging function write to brcmf trace buffers. This is not
> done with netdev_err/dev_err (and replacing the existing logging
> is out of scope for a regression fix anyway).

I see.

--=20
With Best Regards,
Andy Shevchenko
