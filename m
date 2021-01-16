Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B85A2F8D45
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 13:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbhAPMVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 07:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725979AbhAPMVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 07:21:18 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598FAC0613D3
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 04:20:38 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id y22so13222176ljn.9
        for <netdev@vger.kernel.org>; Sat, 16 Jan 2021 04:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=SiWVoM0oRowUoVBZDq1/pucdgIHtbHisa51fOuFjozk=;
        b=K1H262tNdlEh4VL4V/QmSF7p/PQ6xtsnatw7yxxHuZZkJ2QRRGtNulgmL9tRzpNayU
         pWAUcD51+MMbXTuoUvOUC1Rk+6ikqx5he1Ca2G763fTGRK2rbBKRGVGuooUc9o9ZeBHX
         rY18sSo8ZhPWZ5lu5zS3odr47U0ebzX3sCpA/zq4M24JlOiy6WRiOJdRYI0bsnxKmrcl
         WeU6oS/BMa5dgkq1xJUfKyok8BlgXVbui3b+d7Q82MeUh6aL+zrclq4VvACstkxL72Tc
         eK5P5LxczmtxqMUOh1KMFQjbwQrXAv32VzTppoIp3y9+SvE0qSYSpV7VUA43W3yOIlun
         tkmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SiWVoM0oRowUoVBZDq1/pucdgIHtbHisa51fOuFjozk=;
        b=kFPpImWVcf9pCSwiwlnEgauFJ8MNrjDnsolmGewsNTOkNGmkRSr+XOAPLwRBvgh6Xh
         /FoCuAWJ3GT4ZrJcKMqX7IwV3B2BahKBd7TOEN8TvrHUvx827GT3gu1hMvm7Tb1Gi/Gx
         3ENDEhQ4ktxyLVwqw2ZOzgGANUAKPXMTlBiYFpKeat0UVfhrBnqoj5HBAvCsbaKzDAoH
         VSsxAJDwVcyNkICreK9g7iv2QC6h0g6YS9RdD+HSEKjpiXfRnhLwDyn8inwFixLgLtCW
         i5AR8ZxvBgTNNQJCv8c6DeNHbTWZTbXYKh8OVpdJJHFM8LldA5s/xzjhSUjBlbosaMQp
         2Okw==
X-Gm-Message-State: AOAM533gnCrvl8SML379ZOwIczty796QsdiiQKEoY7e82manTjf4/PKY
        E+KgC374OMYZOQLptyOkxhsuMw==
X-Google-Smtp-Source: ABdhPJx2IXH1z4kY/ISg/EFo/xQaJkbP/mzobHNnrJSUUsNDanTgZLF/sZc7vwYvT0UmJ3fWiUT+Ew==
X-Received: by 2002:a2e:97ce:: with SMTP id m14mr7275584ljj.380.1610799635840;
        Sat, 16 Jan 2021 04:20:35 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id t4sm1276643lff.260.2021.01.16.04.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 04:20:34 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext
In-Reply-To: <20210116023937.6225-2-rasmus.villemoes@prevas.dk>
References: <20210116023937.6225-1-rasmus.villemoes@prevas.dk> <20210116023937.6225-2-rasmus.villemoes@prevas.dk>
Date:   Sat, 16 Jan 2021 13:20:33 +0100
Message-ID: <87bldpkr8u.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 16, 2021 at 03:39, Rasmus Villemoes <rasmus.villemoes@prevas.dk> wrote:
> mv88e6xxx_port_vlan_join checks whether the VTU already contains an
> entry for the given vid (via mv88e6xxx_vtu_getnext), and if so, merely
> changes the relevant .member[] element and loads the updated entry
> into the VTU.
>
> However, at least for the mv88e6250, the on-stack struct
> mv88e6xxx_vtu_entry vlan never has its .state[] array explicitly
> initialized, neither in mv88e6xxx_port_vlan_join() nor inside the
> getnext implementation. So the new entry has random garbage for the
> STU bits, breaking VLAN filtering.
>
> When the VTU entry is initially created, those bits are all zero, and
> we should make sure to keep them that way when the entry is updated.
>
> Fixes: 92307069a96c (net: dsa: mv88e6xxx: Avoid VTU corruption on 6097)
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
Tested-by: Tobias Waldekranz <tobias@waldekranz.com>
