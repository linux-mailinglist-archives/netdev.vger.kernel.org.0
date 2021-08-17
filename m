Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6363EED09
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 15:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237611AbhHQNH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 09:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237231AbhHQNH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 09:07:27 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12706C061764;
        Tue, 17 Aug 2021 06:06:54 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id j1so31921325pjv.3;
        Tue, 17 Aug 2021 06:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w7ix2zZqmBm81kbGN2enRhjSkmLWnqV9G1SCcb4ut9c=;
        b=hJ3qFQNaGJcjH9RT74EETLuvCYxHrDk0o9n2dFwLodCOY7nlfpC4P2ZxoptDzGI97T
         FckcMR5rX7dkY9R+bQ/wvIYrD/ulYhO3SLoeMZ0998G8SJvA+GAULEto/f6SRI+Grx8F
         4rV5WJ27Yotqc1ruyCeVzZ2dP7j/ZbhzVVaa5vB9X0S56E8iBEyXr7PFox7TwCAbACfZ
         mtO7pgvmbZQY5wKaJYjKPdtEd28P+gjBLuW6WM2WwMVU8PxugGDNm28/86Jv5c+u0fWN
         pzO+xR7T/6aO6HItnD/kUTgDpfSR4a/JTt/oZ5VISKsIl1DoARxNh4A43Yvje5gsmsuS
         UoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w7ix2zZqmBm81kbGN2enRhjSkmLWnqV9G1SCcb4ut9c=;
        b=cy2XYtd7Z+OqvIDBph+U2SmRLh2NeXy39H8lANlleUW9K1k2tOh25fKWTfW7GhxVxH
         iisPUatdaCoarzw/7V7WBFjuzlB0nsbG6wGbnrNXP7lJJTTy5qljVnEjyVdfJ7RnYUiG
         nlJmIdgO+9fjo93prW6uT3s4wHxqY+ZMt3nbW+zfASo2trmNQ/ZcFMOSZFJdF3SApvF/
         HBMxRNCP4ZyrBtDY+qexmMytsv6mqiYlXULk6i/LCi5OZqGoDWhC7VmPDLNT6QoYkUw+
         5oa2bBRUiBke6K81GwyBcXy4N7z3Sb9V2rg8mX9xw4kpSA3NjCIyGX0AYw7RUqxB0VSI
         Cr5w==
X-Gm-Message-State: AOAM532UmAAQf2pmFV8a8URCjkb+lXvTvvTl3H4W66csnbrYeTYNWxch
        VgNxRQRmS0IhEbX14KlzLhk2elRaCTN3Mx7v+z0=
X-Google-Smtp-Source: ABdhPJxaO+vWlcPYtwGx6S9ulRdAZTlGBtIGZ/Sgz2jxLsrS+K4UhShwkPuQ/hL+UAuwBxBIWWsZgXPQIcDB+5VilX0=
X-Received: by 2002:a17:902:e786:b029:12d:2a7:365f with SMTP id
 cp6-20020a170902e786b029012d02a7365fmr2746610plb.21.1629205613585; Tue, 17
 Aug 2021 06:06:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210817063521.22450-1-a.fatoum@pengutronix.de>
 <CAHp75Vfc_T04p95PgVUd+CK+ttPwX2aOC4WPD35Z01WQV1MxKw@mail.gmail.com>
 <3a9a3789-5a13-7e72-b909-8f0826b8ab86@pengutronix.de> <CAHp75VfahF=_CmS7kw5PbKs46+hXFweweq=sjwd83hccRsrH9g@mail.gmail.com>
 <e59b23ba-7e5b-00e3-e8c9-f5c2bb89b860@pengutronix.de> <85e30fb4-ce7d-6402-f93e-09efadbbcd06@pengutronix.de>
In-Reply-To: <85e30fb4-ce7d-6402-f93e-09efadbbcd06@pengutronix.de>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 17 Aug 2021 16:06:14 +0300
Message-ID: <CAHp75VfkOWk+CwSAOi-ibMcDOz5f0tOjxrygmUoMP1CEHxph-Q@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: pcie: fix oops on failure to resume and reprobe
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wright Feng <wright.feng@infineon.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 3:07 PM Ahmad Fatoum <a.fatoum@pengutronix.de> wrot=
e:
> On 17.08.21 14:03, Ahmad Fatoum wrote:
> > On 17.08.21 13:54, Andy Shevchenko wrote:
> >> On Tue, Aug 17, 2021 at 2:11 PM Ahmad Fatoum <a.fatoum@pengutronix.de>=
 wrote:
> >>> On 17.08.21 13:02, Andy Shevchenko wrote:
> >>>> On Tuesday, August 17, 2021, Ahmad Fatoum <a.fatoum@pengutronix.de> =
wrote:

...

> >>>>>         err =3D brcmf_pcie_probe(pdev, NULL);
> >>>>>         if (err)
> >>>>> -               brcmf_err(bus, "probe after resume failed, err=3D%d=
\n", err);
> >>>>> +               __brcmf_err(NULL, __func__, "probe after resume fai=
led,
> >>>>> err=3D%d\n",
> >>>>
> >>>>
> >>>> This is weird looking line now. Why can=E2=80=99t you simply use dev=
_err() /
> >>>> netdev_err()?
> >>>
> >>> That's what brcmf_err normally expands to, but in this file the macro
> >>> is overridden to add the extra first argument.
> >>
> >> So, then the problem is in macro here. You need another portion of
> >> macro(s) that will use the dev pointer directly. When you have a valid
> >> device, use it. And here it seems the case.
> >
> > Ah, you mean using pdev instead of the stale bus. Ye, I could do that.
> > Thanks for pointing out.
>
> Ah, not so easy: __brcmf_err accepts a struct brcmf_bus * as first argume=
nt,
> but there is none I can pass along. As the whole file uses the brcm_
> logging functions, I'd just leave this one without a device.

And what exactly prevents you to split that to something like

__brcm_dev_err() // as current __brcm_err with dev argument
{
...
}

__brsm_err(bus, ...)  __brcm_dev_err(bus->dev, ...)

?

--=20
With Best Regards,
Andy Shevchenko
