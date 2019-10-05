Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CACABCCCC8
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 23:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbfJEVCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 17:02:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbfJEVCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 17:02:20 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1C80D369CA
        for <netdev@vger.kernel.org>; Sat,  5 Oct 2019 21:02:20 +0000 (UTC)
Received: by mail-io1-f69.google.com with SMTP id g8so19682236iop.19
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 14:02:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=utO2TErw4cr4wYW27laLdkb5rCwxlfgQ8WUaV+J+0ZA=;
        b=e00OniQ7HMQQBu8Ep4MuENpJczOkCSvsNJhAAUlHTpIFt4181hM9yDLfG0//w6LrkW
         y/YuRaAlP1Y+UOpywDY4HypJyJ2xkTtSOv/oJvKzpV1T1YnJRLIJuIDjXHJH+O05eM6O
         lV0BvIOwG5pXViolTbinU3QUbliocT6bLk3Vc7XoIKbXMt/QQPL8hPOC2oRFTPyTpOoj
         aZYk6iFNyYyNXxg9tMpovIs2JWbrBse3NtGoM19JEJnvEv/5Xpupqqo7DqTc0mIgizM4
         oO55ieA+w1wUCzGXwv1DQB6w9sLCF5WbnOzAN9gznjV2rEJzhjfzssGNLpVdCgGkkv6H
         Uvcg==
X-Gm-Message-State: APjAAAXkpFHbf4nATdVV+Nh6a5x2rTmwG5wJIz12xz7BUwMqw4s/USOW
        zpbaUQQLf9WXd1NpgAjneyXQ4Wqvz8QYubMh8HZDWPXc9gq1RzgNOrj4xA95d6WkN9uoqXrcxoH
        oXk3qHhnZXRZf0tUWAzLz6fdf8x232OPH
X-Received: by 2002:a6b:f315:: with SMTP id m21mr3439562ioh.12.1570309339327;
        Sat, 05 Oct 2019 14:02:19 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwVsu+N6hLAjqzXahsWjdy5O/ELNs7tr+6/YrInzW4T7R3edmZAvMeBqqaPhyg6ASeDnPzLXiQe5xh1qNlSHd8=
X-Received: by 2002:a6b:f315:: with SMTP id m21mr3439543ioh.12.1570309339016;
 Sat, 05 Oct 2019 14:02:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570307172.git.lorenzo@kernel.org>
In-Reply-To: <cover.1570307172.git.lorenzo@kernel.org>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 5 Oct 2019 23:02:08 +0200
Message-ID: <CAJ0CqmXqw6+bA+s-yRFa1gGHmme03yu5ByN8Odj4ibQCB93Qgw@mail.gmail.com>
Subject: Re: [PATCH 0/7] add XDP support to mvneta driver
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        thomas.petazzoni@bootlin.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        matteo.croce@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Add XDP support to mvneta driver for devices that rely on software
> buffer management. Supported verdicts are:
> - XDP_DROP
> - XDP_PASS
> - XDP_REDIRECT
> - XDP_TX
> Moreover set ndo_xdp_xmit net_device_ops function pointer in order to support
> redirecting from other device (e.g. virtio-net).
> Convert mvneta driver to page_pool API.
> This series is based on previous work done by Jesper and Ilias.
>
> Changes since RFC:
> - implement XDP_TX
> - make tx pending buffer list agnostic
> - code refactoring
> - check if device is running in mvneta_xdp_setup
>

This series is clearly intended for net-next :)

Regards,
Lorenzo

> Lorenzo Bianconi (7):
>   net: mvneta: introduce mvneta_update_stats routine
>   net: mvneta: introduce page pool API for sw buffer manager
>   net: mvneta: rely on build_skb in mvneta_rx_swbm poll routine
>   net: mvneta: add basic XDP support
>   net: mvneta: move header prefetch in mvneta_swbm_rx_frame
>   net: mvneta: make tx buffer array agnostic
>   net: mvneta: add XDP_TX support
>
>  drivers/net/ethernet/marvell/Kconfig  |   1 +
>  drivers/net/ethernet/marvell/mvneta.c | 627 +++++++++++++++++++-------
>  2 files changed, 468 insertions(+), 160 deletions(-)
>
> --
> 2.21.0
>
