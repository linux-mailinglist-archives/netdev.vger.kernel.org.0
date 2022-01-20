Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14F0495709
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 00:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiATXgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 18:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348220AbiATXgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 18:36:06 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235FDC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 15:36:06 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id e8so6779304plh.8
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 15:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=34g3rMl550+BWcq65fs37Qd2djk3J9CHromgZfLekh8=;
        b=n+FvnS9FtpGiN0Jo4Br5Lsk1SdYPHYAHTBu01eApe3SbtAZJS9kXJ9gY55vTpAhId8
         baZlUlbg3Q6ArIDkDcmQw/NuwQcnFeg2jW0NrefC1mH/f4X8BScyiZLO1nJ39DDKJ0RV
         MwDLJFUnUJodyAeX9o3OLFagjqaZ/LmM5tR6VEX9ZOV8sB8ndUsmsP7kdKxBCg+JZRu4
         20dAnOo+EbQaejkJR1rYpqd7Gk1Os4lW2jtJzd137RhW+4MGhLwTsWZ1+uHAw1SJ9VEh
         NU6GDAMpNASFX8xDWDuMey574KyHlBlIro3sBG75aZRCbddCPJFD5d7SHUJ7oNx5ehGj
         tPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=34g3rMl550+BWcq65fs37Qd2djk3J9CHromgZfLekh8=;
        b=u2K/McrOW1ff5hhqYV2P/Hdp9A3/gq3GS4WhaFBsK0kjMy99tmxugGrktU0OwBLc1u
         4NVqijKL+2v7Co58P35vUvVRlRwOdpnj4/OJAEuxsbGLY2MYKWw6aFx6CYB+M1u51bs2
         Fyq7Tk5eI67Ynkgdm4U/oM3MLpjX0aQOMBfY1fxKwha7gMfFI8Xm6QPU1VMFknW2i3k4
         VOmzMZfJJg5AyfHutqQISJ8xZHu6XZozdsmDUbkYIJXc5Z28rPllDfJcqnNWKVRlcCZx
         S51qi+igAl1V0Ida0ZhBpWpD5HqtCnbSHh+/fYySYU7TmOWPdXMJDMEAms569AKSgbf2
         TCag==
X-Gm-Message-State: AOAM530owiqkdwhnbxCY8evgR5soHPrTbra8zzKeBt7grOVsspcMsyJ2
        BpZrXF8JPTivMqyBASpxVev9d0SaEwu1LM23RfTw808F7ayXR1sC
X-Google-Smtp-Source: ABdhPJzWMo/x8K+yAVYwDA7UfQfTJMOwqpAv6Bps+SlSmO0nHUYITX/a/aG9VQOwHsSYoJ6wwV4Uv2eH8Zwx5JJnvSQ=
X-Received: by 2002:a17:902:8544:b0:14a:bea3:1899 with SMTP id
 d4-20020a170902854400b0014abea31899mr1110784plo.143.1642721765572; Thu, 20
 Jan 2022 15:36:05 -0800 (PST)
MIME-Version: 1.0
References: <20220105031515.29276-1-luizluca@gmail.com> <20220105031515.29276-12-luizluca@gmail.com>
 <87ee5fd80m.fsf@bang-olufsen.dk> <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk> <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
 <87v8ynbylk.fsf@bang-olufsen.dk> <trinity-d858854a-ff84-4b28-81f4-f0becc878017-1642089370117@3c-app-gmx-bap49>
 <CAJq09z7jC8EpJRGF2NLsSLZpaPJMyc_TzuPK_BJ3ct7dtLu+hw@mail.gmail.com>
 <Yea+uTH+dh9/NMHn@lunn.ch> <20220120151222.dirhmsfyoumykalk@skbuf>
In-Reply-To: <20220120151222.dirhmsfyoumykalk@skbuf>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 20 Jan 2022 20:35:54 -0300
Message-ID: <CAJq09z6UE72zSVZfUi6rk_nBKGOBC0zjeyowHgsHDHh7WyH0jA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> And what is the problem if the hardware cannot calculate the checksum
> with an unknown EtherType? Is it the DSA master that drops the packets
> in hardware? What is the reported error counter?

No, the issue is with outgoing packets and nothing is dropped inside
the DSA device.

If the OS is configured to offload (I'm using OpenWrt.), it will send
a packet with the wrong checksum expecting that the HW will fix that.
After DSA is brought up, the OS is still expecting the HW to calculate
the checksums. However, with the EtherType DSA tag from a , it cannot
understand it anymore, leaving the checksum as is. The DSA switch
(Realtek) passes the packet to the network and the other end receives
a broken packet. Maybe if the DSA knew that the CPU Ethernet HW cannot
handle that DSA tag, it could disable checksums by default. But it is
difficult to foresee how each offload HW will digest each type of CPU
tag.

Is the kernel enabling checksum by default when the driver reports it
is supported? If so, it would be nice to somehow disable offloading
with some kind of device-tree dsa cpu port property.

Regards,

Luiz
