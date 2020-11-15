Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB72E2B36E8
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 17:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgKOQ7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 11:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727042AbgKOQ7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 11:59:04 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678CEC0613D1;
        Sun, 15 Nov 2020 08:59:04 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id cq7so16264357edb.4;
        Sun, 15 Nov 2020 08:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w7mL2iRg/mInBs54fIX3rJ0Znez3wS1L6LbIDjQE9Qw=;
        b=oILdEVcpWtl4r1ydW78cb/WfUlDQF3N7VHncAaffvsIGb8N7DwziMJgQvQ9mP1q/Cc
         WbYeh1Kf1acDsQhQqNK090fho3forIolY4LZplpd+f2kd3WqhEKGZmhlyREl8qVMRqJ0
         +3DP8fGQf8N3LMv91RayZ8WN0AzH8sonXFHiOkz0POgEsPdxfChqZkdaQIrUmbSSsXNa
         0stgeiY9mP3IUBFwXDiqJyiSF8cQJm9/ntQeY9bPwHriyFuYvY5DPY4DFJZ1Y61exZN4
         GehjO8Xg4vLNN8vCkN99OoJfsLfjiSVFCMDSEqnUv9StQXN+nq6dLBaANeoBgVU9vP6L
         VACg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w7mL2iRg/mInBs54fIX3rJ0Znez3wS1L6LbIDjQE9Qw=;
        b=FPPuEX9mENatyY1f99lj+jOJ3WrCEgLjwxaEeijN4i0+qKwzEwNpLbH2SRThScA/3l
         TYZL1WUtN7fRuPbhUzqKQssFfx64W5ZI1I54GkaAOemegYDk3nvFQRUaoxz0Eu9XEHIj
         VSMpmnV09N86HW6fheyhqqrGoKkBxGw33T9lX+mm8xqmHbzmISO3jEEP3eonAPlhR0eK
         T7iicgdBZ4JtXWE4C/QKnPI18Vio0rR8Udccj0V2FzUNnBGq+un6E2rITiDhKNGfJDPb
         E2dNfkVljBguvINi0fJgLdIVwAURabSjc/QKETOA3LNA1gY3zm6gCf0qphefTXDQL/dC
         EOgA==
X-Gm-Message-State: AOAM531+oI/NQG9zJwnYzsFy9tgLLZhz4epOrPLqa4OOFihy5aqho64+
        zw/MVKTZDKI7QE4oVpN1vEvuBtGzdAtx8isOuSY=
X-Google-Smtp-Source: ABdhPJzx+f4P0oGzB/k0StBQNk3fG+LG+uXSoQxtEgvG4uZqfPQfhY6BdJMgNTUcG1WKpP7VDsoDXL6Nam3uMQyhNqw=
X-Received: by 2002:a05:6402:b35:: with SMTP id bo21mr12825628edb.52.1605459543089;
 Sun, 15 Nov 2020 08:59:03 -0800 (PST)
MIME-Version: 1.0
References: <20201115100623.257293-1-martin.blumenstingl@googlemail.com> <20201115155753.GC1701029@lunn.ch>
In-Reply-To: <20201115155753.GC1701029@lunn.ch>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 15 Nov 2020 17:58:52 +0100
Message-ID: <CAFBinCA8T6hcdkt72g_HRRuoaUzfb28C0C5feJL+BCSf6YsRTw@mail.gmail.com>
Subject: Re: [PATCH] net: lantiq: Wait for the GPHY firmware to be ready
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Hauke Mehrtens <hauke@hauke-m.de>, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Sun, Nov 15, 2020 at 4:57 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Add a 300ms delay after initializing all GPHYs to ensure that the GPHY
> > firmware had enough time to initialize and to appear on the MDIO bus.
> > Unfortunately there is no (known) documentation on what the minimum time
> > to wait after releasing the reset on an internal PHY so play safe and
> > take the one for the external variant. Only wait after the last GPHY
> > firmware is loaded to not slow down the initialization too much (
> > xRX200 has two GPHYs but newer SoCs have at least three GPHYs).
>
> Hi Martin
>
> Could this be moved into gswip_gphy_fw_list() where the actual
> firmware download happens?
>
> To me that seems like the more logical place.
good point, that's closer to the loop over all GPHY instances.
I've taken care of it in v2 - many thanks!


Best regards,
Martin
