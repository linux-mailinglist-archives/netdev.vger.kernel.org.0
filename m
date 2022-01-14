Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8FE48E45F
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbiANGsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 01:48:05 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:59256
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231620AbiANGsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:48:03 -0500
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 90AE6402A3
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 06:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1642142881;
        bh=PKBAkmJ7or0T/bxHU0Wvyq29ugXtwBBaF+RK3mybysU=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=hDIiylRN/BhR3ijiiWn2wBFPyRwRb06nqYpmUx4C+aV6dTp5xI2nRrJGZ3n50E7O0
         CbS1pO8x86DkqH4QUbPue5kg/sSXD9bqZpvAf6m2k82QB941iO2baagLssj9WarLQp
         KLMiSonoqyTJSWEY/X1fHx6nD9jrRmdvDsSCvcQA131JdAOjfBHyzZEDjO6GLgkrRv
         T4f0LMD1m9xLE6iEabDWROdRNcJxN7SJ1YiYOJpqX0/n+K9GaTyTVxQWEqYSQ/CYe/
         G1NT0CiQdqFfO09vj0y7XGfVyJ8KK1+hN7FARhe5AJ5XMiXttlAht6j3CNnkTUH50B
         CeV74hekx6AnQ==
Received: by mail-oo1-f69.google.com with SMTP id z48-20020a4a9873000000b002c29a99164cso5426708ooi.20
        for <netdev@vger.kernel.org>; Thu, 13 Jan 2022 22:48:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PKBAkmJ7or0T/bxHU0Wvyq29ugXtwBBaF+RK3mybysU=;
        b=pPkuhcHbesOU0E+0zLg8EuSUPEQkpACwDaqNDfajm89W4/rW0Zk19KvpleNend7Y8z
         UeLa1JOHjlSV2mslPoqMzpfPeEcL9hEUND2M5/m9KiGBWK/OJBoeMdIlg0w7fsxf+GbP
         Ro5gRp88A+VbeR+vEwLw8NI57QfXRJMLMIUJPoiB6h92hw6uXAsxclqCAT+xaADWFjqR
         X5S+FuykD1Rp4SwZzUIRucvbQyOxWxauyIO+Yudls82FW1TPt0Mj9obuusSr7Rjn9Gdj
         tzylvDr68PRGNMlqFDsZEKBnmfn3ESe7VxdwEE3w4vhf8iO7Fm7W8+p7ENrnmEd8xEkR
         UgPw==
X-Gm-Message-State: AOAM531tCyJf5SoJJgFpSx467A45hA9dFptDcp1AHW8Dnz1881fWsmbA
        4yAGP1h2PWrG7ik2FtFswi6MuKUOGHl8ToAhlXemfcuaoFCZILkBb9bPuoudPnVpGAJmEDmERFD
        nK15FTXp+/CN49b4Z/zzxnoSYXsnVWSzYkjG4NLKffdl9b4s8vw==
X-Received: by 2002:a05:6808:293:: with SMTP id z19mr10972595oic.41.1642142879352;
        Thu, 13 Jan 2022 22:47:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJye/IK1OGddDRHlpoRSRDwJDrr3evy3FfczWQgU60l1SslTO9lJxeMi9V5rBVY0jKXg6Ly5r0DmOwSH1F8j5i0=
X-Received: by 2002:a05:6808:293:: with SMTP id z19mr10972566oic.41.1642142878837;
 Thu, 13 Jan 2022 22:47:58 -0800 (PST)
MIME-Version: 1.0
References: <20220114040755.1314349-1-kai.heng.feng@canonical.com>
 <20220114040755.1314349-2-kai.heng.feng@canonical.com> <20220113203523.310e13d3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220113203523.310e13d3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Date:   Fri, 14 Jan 2022 14:47:47 +0800
Message-ID: <CAAd53p6rW7PcugY7okKsXybK2O=pS8qAhctMzsa-MEgJrKhEdg@mail.gmail.com>
Subject: Re: [PATCH 2/2] stmmac: intel: Honor phy LED set by system firmware
 on a Dell hardware
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 14, 2022 at 12:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 14 Jan 2022 12:07:54 +0800 Kai-Heng Feng wrote:
> > BIOS on Dell Edge Gateway 3200 already makes its own phy LED setting, so
> > instead of setting another value, keep it untouched and restore the saved
> > value on system resume.
> >
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>
> I defer to PHY experts for review. Coincidentally the first Marvell
> flag appears dead, nobody sets it:
>
> $ git grep MARVELL_PHY_M1145_FLAGS_RESISTANCE
> drivers/net/phy/marvell.c:      if (phydev->dev_flags & MARVELL_PHY_M1145_FLAGS_RESISTANCE) {
> include/linux/marvell_phy.h:#define MARVELL_PHY_M1145_FLAGS_RESISTANCE  0x00000001
> $
>
> unless it's read from DT under different name or something.

It was introduced by 95d21ff4c645 without any user. Should we keep it?

>
>
> Once you get some reviews please wait for net-next to open:
>
> http://vger.kernel.org/~davem/net-next.html
>
> and repost. It should happen the week of Jan 24th. When you repost
> please drop the first patch, I believe Russell does not like the BIT()
> macro, his opinion overrides checkpatch.

Of course. I'll wait for the review and resubmit the 2nd patch.

Kai-Heng

>
> Thanks!
