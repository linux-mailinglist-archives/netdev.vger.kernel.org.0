Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE61483E56
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 02:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfHGAaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 20:30:22 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37564 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727503AbfHGAaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 20:30:22 -0400
Received: by mail-lj1-f194.google.com with SMTP id z28so29563613ljn.4
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 17:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=04KeAaCHcaHA13etq10kb5eqtxQxSQGGJ3drhfuep0U=;
        b=fqRhCbgmWE11EYy3WIsEPjq48dq2jzTQOhZT7z7UW8KW//nC8dYqObDWTiTfCLO1kp
         kxxcmjUAd/qgJ4YzxnhotT/4QmTXeMCRqlRUH6vvg2rdYn3xcQosK24cTLIVKz6qhULf
         VJVsUbuWu0FTrMtZ86g1CyNgtVWby+VNSNh5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=04KeAaCHcaHA13etq10kb5eqtxQxSQGGJ3drhfuep0U=;
        b=i8XYkZ5CU85lrQKqlbJls8mrGApXgLmPdI2QkDv2e0sVGwHF7HcKu1DpAcxs+VSNe3
         Gl38ZpQPdMd0a99GG+R85dYzLSW26ULB4oCGN282uP7EMeQkXMrgTU3Fewn/oPZRBf+b
         WVd5+QqObK237t0W0IbMfH7pAtlu2f/de4akGVtL/nM5jzQpmI4Tlh6Dv8TaRV9r0xZS
         AjlOm1CqPWUC6PKTqdLVcZ5T9Cv4SoB9r3uM2sCPwd6xRVh0LLy2hogU2fA1TvAVf8pt
         MIQxTHOTqXKvRzD9ibVSI/1tueNBMZ8IhJqGM7ycd0kPgtoBEV99L6EmYUVprdgtjoeD
         UV5w==
X-Gm-Message-State: APjAAAWhM5HqeYoMOGDXtjnYzrXfmzGjCluD8jhGS2bf5mz+dGQojIgT
        Xojqhavz1p416jK1Hwj5GsOp1GiSejQ=
X-Google-Smtp-Source: APXvYqwTV6KM42nipv5wc2lkt8bs9jEtUons/993oXGLXKCyOBsC+/eORqHyeMeoYDGRtUv9nJ5epg==
X-Received: by 2002:a2e:80d6:: with SMTP id r22mr3171208ljg.83.1565137819975;
        Tue, 06 Aug 2019 17:30:19 -0700 (PDT)
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com. [209.85.167.45])
        by smtp.gmail.com with ESMTPSA id b68sm20648578ljb.0.2019.08.06.17.30.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 17:30:18 -0700 (PDT)
Received: by mail-lf1-f45.google.com with SMTP id c19so62639966lfm.10
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 17:30:17 -0700 (PDT)
X-Received: by 2002:a19:ed11:: with SMTP id y17mr4205590lfy.141.1565137817348;
 Tue, 06 Aug 2019 17:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAH040W7fdd-ND4-QG3DwGpFAPTMGB4zzuXYohMdfoSejV6XE_Q@mail.gmail.com>
In-Reply-To: <CAH040W7fdd-ND4-QG3DwGpFAPTMGB4zzuXYohMdfoSejV6XE_Q@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 6 Aug 2019 17:30:06 -0700
X-Gmail-Original-Message-ID: <CA+ASDXM6Jz7YY9XUj6QKv5VJCED-BnQ5K1UZHNApB9p6qTWtgg@mail.gmail.com>
Message-ID: <CA+ASDXM6Jz7YY9XUj6QKv5VJCED-BnQ5K1UZHNApB9p6qTWtgg@mail.gmail.com>
Subject: Re: Realtek r8822be wireless card fails to work with new rtw88 kernel module
To:     =?UTF-8?B?6rOg7KSA?= <gojun077@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Tony Chuang <yhchuang@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ yhchuang

On Tue, Aug 6, 2019 at 7:32 AM =EA=B3=A0=EC=A4=80 <gojun077@gmail.com> wrot=
e:
>
> Hello,
>
> I recently reported a bug to Ubuntu regarding a regression in wireless
> driver support for the Realtek r8822be wireless chipset. The issue
> link on launchpad is:
>
> https://bugs.launchpad.net/bugs/1838133
>
> After Canonical developers triaged the bug they determined that the
> problem lies upstream, and instructed me to send mails to the relevant
> kernel module maintainers at Realtek and to the general kernel.org
> mailing list.
>
> I built kernel 5.3.0-rc1+ with the latest realtek drivers from
> wireless-drivers-next but my Realtek r8822be doesn't work with
> rtw88/rtwpci kernel modules.
>
> Please let me know if there is any additional information I can
> provide that would help in debugging this issue.

Any chance this would help you?

https://patchwork.kernel.org/patch/11065631/

Somebody else was complaining about 8822be regressions that were fixed
with that.

Brian
