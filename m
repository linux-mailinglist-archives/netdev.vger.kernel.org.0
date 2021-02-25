Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F2732569E
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 20:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbhBYT1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 14:27:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbhBYTYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 14:24:54 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36272C061788
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 11:24:10 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id q23so7787948lji.8
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 11:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=qIMSZYz4O+UEzeljds81Cq69Bau93xPzFNuWkM+0bO0=;
        b=PFVsvb8NGo8Y0reAQq0DPD/DREy55044LOuIH1NUxfpjNkEbIC47Rptz9CmNZgVLFl
         XNdyOQhsFNGNMO+ZgteGmPxF9PLrfBEetHV4PEpevaPDKHMeziUNywYAIf02Xry3NhzR
         GnINfpwRwDDvF+VHo8AVi8uRF4FPv2JI4xY9kb5w92w9AsO9nTr6PTXgpHLJaJfGPnGm
         ymPYjHgfp8e6w3GrXDV3t7SFCJ/9mY+aZv7EgdCBj4NwNYTy/WyelnN06qM85uSVf9fZ
         hHo1RFaNuk5Hq5iNqkMwL+DWL+mJD3LMp7BfORn+81f2LYDyY+W6JbrmSzMnJwVgeXar
         vOUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=qIMSZYz4O+UEzeljds81Cq69Bau93xPzFNuWkM+0bO0=;
        b=k8/Q6nuzqaoRz37Uy+OJIxJaS8YRm+fBwJUfGQPfOdjU7xQs24bzB8VcKll6X0kPIj
         UfUzOwVv2HCHpuLzOBndFdX9F18pPIA6FMXB+mXXPhrxDA3eQ7HH8KYpmoXjZ0Sdg7le
         YIqxl4rd0VKD/NKBS9mMwFk/mfAkzSqpZ2k+/ipvNAIqXyePp68in/quty4PNi1dzApw
         z92DDcapK1BouqhrzOwiU+siF5I6d83hhQ7PxdJWdRUksrct2RUdVwc8hpbLyb03pDF7
         07d4IVubcpOj0YDqvU6gYO3ROqzw8Tdk1LV0nXs3JHalgFevjnI/dCYO3+44P6L5DPDv
         Wu+g==
X-Gm-Message-State: AOAM531ImJcotD0mOIea6+6G85+9f2YXH3pjBSs3SrfRZch0GSCnhOL+
        YCluDahPNA2Td5A7v0b8lGSa6Q==
X-Google-Smtp-Source: ABdhPJx2XN9lj9E1qpCWMGCLU4iMLrE9Upd8RRY/Otxya1noQuQEqGUewoUjrUWaZBCvbEKm73bexw==
X-Received: by 2002:a2e:5c02:: with SMTP id q2mr2383707ljb.81.1614281048731;
        Thu, 25 Feb 2021 11:24:08 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id w10sm1172425lji.46.2021.02.25.11.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 11:24:08 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Oleksij Rempel <linux@rempel-privat.de>
Subject: Re: [PATCH net-next 2/4] net: dsa: reject switchdev objects centrally from dsa_slave_port_obj_{add,del}
In-Reply-To: <20210214155326.1783266-3-olteanv@gmail.com>
References: <20210214155326.1783266-1-olteanv@gmail.com> <20210214155326.1783266-3-olteanv@gmail.com>
Date:   Thu, 25 Feb 2021 20:24:06 +0100
Message-ID: <87blc8rlwp.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 17:53, Vladimir Oltean <olteanv@gmail.com> wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> The dsa_port_offloads_netdev check is inside dsa_slave_vlan_{add,del},
> but outside dsa_port_mdb_{add,del}. We can reduce the number of
> occurrences of dsa_port_offloads_netdev by checking only once, at the
> beginning of dsa_slave_port_obj_add and dsa_slave_port_obj_del.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
