Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF8746FD9E
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239235AbhLJJ1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:27:45 -0500
Received: from smtp-relay-internal-1.canonical.com ([185.125.188.123]:49040
        "EHLO smtp-relay-internal-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236055AbhLJJ1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:27:44 -0500
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 48B8F3F1BC
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1639128249;
        bh=PhONVokzqhlQ6awh8S6WKaNUvrEjNYZlrDmnaqqI4qU=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=J9XfyT7zxh8NyzAH6kA4Qx2hxfc1IudTp6y9WKPBDzvdkrANGji5YBcf/yYUL4oHS
         2xtV2R/ofdqCDnKmCTNKMGTO+bJpHELH+xpmU2u+ar+TQ1l8DuOafpnUXbAXBtgrQL
         Ha5p0ivNbkApuqoYo6K93hWkBC8nSwha+ZTFmK1DWCBcabIrJ5EE/WW3lPM87rYAFE
         HWcGg69KMPRRRhsHk4xYcDNK2flmE3b9uODOfAyKR6Ok8svjSwZnJHojwhGKk/4cGp
         kiEHhN9KYsp919l7PRuz8whkMvFrmYq5wvGxicXl0nh+2JYKk3eCSlu5aIoxytpbJu
         AP50Hh2OEPNAg==
Received: by mail-ot1-f72.google.com with SMTP id q24-20020a9d7c98000000b0056ea09fce20so3048286otn.17
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 01:24:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PhONVokzqhlQ6awh8S6WKaNUvrEjNYZlrDmnaqqI4qU=;
        b=OrUX8WZ2ezB6uB5LG24JrNXw7nXkZUw6GD1RNYN4BbsLeYlans5+1Vh62nsRezZdPz
         99o1NVW2Hmxurhce7nvVmKpp2b6+C4KlJNdoN23oHYA3/z1mnJifksBOi3wNbsBg+ndq
         //3DBWmUNT3ew0QmaYgaxg6TM26drjBoLSwHl6IYf7tN2E+sZvnCIKaQzfEfXRKWdjPH
         zcHFYH5BAXB9kav8XfMBh1/7rqylvblMClu3KYpzpM+TVw0zNFGSyQcdBWGPkSxJe0fT
         eqHi/WjlWhA6lP74uOlXEmPqU9jBqJh3FJ7ZXRB2lXxAqyi75Ap8PxuhDtb3d6XpTU2Y
         oVfA==
X-Gm-Message-State: AOAM530ArJNwY0i82cVINTZndrpzpgfw35uIynbbnkVSIIOtKOhpc+XN
        ef8t017oRjui/s26fkKfnbXkrSPajBwlMbCTFknayfmDTcErKSn+xQSYHp1KveAHGL9srd6qrhR
        4KGB4t3FftQt5ZZZQPXD0p+qW64LhZw+CVsI61F0hZ7TkHILllw==
X-Received: by 2002:a05:6830:1f3a:: with SMTP id e26mr10386014oth.233.1639128246805;
        Fri, 10 Dec 2021 01:24:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFWMljnaxg0rbYulWWkC+p3vg8bNr5G9zKia3405F7FuRTmG5YE+bJKfQ0sJq4v0XazbboxKkICzh1Ry+LLFQ=
X-Received: by 2002:a05:6830:1f3a:: with SMTP id e26mr10385935oth.233.1639128245144;
 Fri, 10 Dec 2021 01:24:05 -0800 (PST)
MIME-Version: 1.0
References: <20211210081659.4621-1-jhp@endlessos.org> <6b0fcc8cf3bd4a77ad190dc6f72eb66f@realtek.com>
In-Reply-To: <6b0fcc8cf3bd4a77ad190dc6f72eb66f@realtek.com>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 10 Dec 2021 17:23:53 +0800
Message-ID: <CAAd53p66HPH9v0_hzOaQAydberd8JA4HthNVwpQ86xb-dSuUEA@mail.gmail.com>
Subject: Re: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
To:     Pkshih <pkshih@realtek.com>
Cc:     Jian-Hong Pan <jhp@endlessos.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessos.org" <linux@endlessos.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 5:00 PM Pkshih <pkshih@realtek.com> wrote:
>
> +Kai-Heng
>
> > -----Original Message-----
> > From: Jian-Hong Pan <jhp@endlessos.org>
> > Sent: Friday, December 10, 2021 4:17 PM
> > To: Pkshih <pkshih@realtek.com>; Yan-Hsuan Chuang <tony0620emma@gmail.com>; Kalle Valo
> > <kvalo@codeaurora.org>
> > Cc: linux-wireless@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux@endlessos.org; Jian-Hong Pan <jhp@endlessos.org>
> > Subject: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
> >
> > More and more laptops become frozen, due to the equipped RTL8821CE.
> >
> > This patch follows the idea mentioned in commits 956c6d4f20c5 ("rtw88:
> > add quirks to disable pci capabilities") and 1d4dcaf3db9bd ("rtw88: add
> > quirk to disable pci caps on HP Pavilion 14-ce0xxx"), but disables its
> > PCI ASPM capability of RTL8821CE directly, instead of checking DMI.
> >
> > Buglink:https://bugzilla.kernel.org/show_bug.cgi?id=215239
> > Fixes: 1d4dcaf3db9bd ("rtw88: add quirk to disable pci caps on HP Pavilion 14-ce0xxx")
> > Signed-off-by: Jian-Hong Pan <jhp@endlessos.org>
>
> We also discuss similar thing in this thread:
> https://bugzilla.kernel.org/show_bug.cgi?id=215131
>
> Since we still want to turn on ASPM to save more power, I would like to
> enumerate the blacklist. Does it work to you?

Too many platforms are affected, the blacklist method won't scale.
Right now it seems like only Intel platforms are affected, so can I
propose a patch to disable ASPM when its upstream port is Intel?

> If so, please help to add one quirk entry of your platform.
>
> Another thing is that "attachment 299735" is another workaround for certain
> platform. And, we plan to add quirk to enable this workaround.
> Could you try if it works to you?

When the hardware is doing DMA, it should initiate leaving ASPM L1,
correct? So in theory my workaround should be benign enough for most
platforms.

Kai-Heng

>
> Thank you
> --
> Ping-Ke
>
