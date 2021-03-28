Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B2234BC8C
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 16:11:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhC1OJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 10:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhC1OJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 10:09:10 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0F8C061756
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 07:09:10 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id w3so15475350ejc.4
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 07:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kA9wWs015IruYo5Hxi5eqEyz8ykc1vFh2cLrDk8n3Kk=;
        b=UdxUOuxoeuAxnACfx09ApwnTFCe15GI6btWX6XYOnazWGmfKCwoAKCOPlotvXXdvAx
         bz8v/eaBl+h5iXyXav0KfgSUlZoD1fB54iAC/3ActC0XCDtJ94Dz9bvbqR8R7GSpKdnG
         qqdb/sOGBC9Jwe62w+uWj7/60EMeSuxipRm1P/B8f4oyw778pfAOujNCDpQrQmbUi2ui
         U9Jv51+mP2L0ytnzrGNt2VS8J3tNGJo9MltUozPVNHR/gomcll32PEqTbm8RrMZpxJk2
         ktCzWFBcqYRi0qp1s3kds1lJE5S9tZVckAqXB/dxsCaurdzScOLRyxOHAVHhC9JX1S7K
         8qXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kA9wWs015IruYo5Hxi5eqEyz8ykc1vFh2cLrDk8n3Kk=;
        b=VscuZs5DsfLtRcMEzMSP+bX69YNsss5OBO0sRs34+qjWEfIttlPrd7bJ0FrU1SXii6
         x3KKgfbj5ys5uLEuxM+HPp8Y/wVyLG/2NlZLWZrkqlk0ghiQ5/5QolTb17uCo3Bg/nb+
         UJwzt7Ns+ezZX7aSyTlwadLFRpMCUFPwfzTbNvvoNLxCCwzEuJgYJXdq9f6wzeEJjxI5
         71Jk8Z304wDqtg/ruzCl3/YhGNXu8Nzs6IPYMXpHZMR+VHXS2BPG4ExNeauKlJBoF3MH
         LXzLB7GEloXR6AnTkbu8ZEBBJ6RvXATYHEG36wbuVGPJ4otluhwHGHXHhn6lvXUTiAvc
         Ek6Q==
X-Gm-Message-State: AOAM5318m441xwEcqUM7Le8ggdSNl5grwsZSRFosevoVYXQdNTIWDftc
        swaWYLqLYDRTJz94CDEyuEEtf9QO6Vg=
X-Google-Smtp-Source: ABdhPJxrchfTA2c5uCqP3JFm3K/57ejISVFK0YRPFcMOe9GGZ/Jy5MywkxWVXgupxq3J5yIgl0lNVw==
X-Received: by 2002:a17:906:4ada:: with SMTP id u26mr24496848ejt.129.1616940548764;
        Sun, 28 Mar 2021 07:09:08 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id n16sm7429282edr.42.2021.03.28.07.09.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Mar 2021 07:09:07 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id a132-20020a1c668a0000b029010f141fe7c2so7236951wmc.0
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 07:09:06 -0700 (PDT)
X-Received: by 2002:a1c:6855:: with SMTP id d82mr11628989wmc.169.1616940546507;
 Sun, 28 Mar 2021 07:09:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210326154835.21296-1-kurt@linutronix.de>
In-Reply-To: <20210326154835.21296-1-kurt@linutronix.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 28 Mar 2021 10:08:30 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfzoQ_b4mu-kbXa6Gz5g3ZV4kz+ygLb7x==BJVD_040sQ@mail.gmail.com>
Message-ID: <CA+FuTSfzoQ_b4mu-kbXa6Gz5g3ZV4kz+ygLb7x==BJVD_040sQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net/packet: Reset MAC header for direct packet transmission
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 11:49 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>
> Reset MAC header in case of using packet_direct_xmit(), e.g. by specifying
> PACKET_QDISC_BYPASS. This is needed, because other code such as the HSR layer
> expects the MAC header to be correctly set.
>
> This has been observed using the following setup:
>
> |$ ip link add name hsr0 type hsr slave1 lan0 slave2 lan1 supervision 45 version 1
> |$ ifconfig hsr0 up
> |$ ./test hsr0
>
> The test binary is using mmap'ed sockets and is specifying the
> PACKET_QDISC_BYPASS socket option.
>
> This patch resolves the following warning on a non-patched kernel:
>
> |[  112.725394] ------------[ cut here ]------------
> |[  112.731418] WARNING: CPU: 1 PID: 257 at net/hsr/hsr_forward.c:560 hsr_forward_skb+0x484/0x568
> |[  112.739962] net/hsr/hsr_forward.c:560: Malformed frame (port_src hsr0)
>
> The MAC header is also reset unconditionally in case of PACKET_QDISC_BYPASS is
> not used.

At the top of __dev_queue_xmit.

I think it is reasonable to expect the mac header to be set in
ndo_start_xmit. Not sure which other devices besides hsr truly
requires it.

> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

If this fixes a bug, it should target net.

Fixes: d346a3fae3ff ("packet: introduce PACKET_QDISC_BYPASS socket option")

This change belongs in __dev_direct_xmit unless all callers except
packet_direct_xmit do correctly set the mac header. xsk_generic_xmit
appears to miss it, too, so would equally trigger this warning.
