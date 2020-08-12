Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D970C242409
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 04:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726430AbgHLCZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 22:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgHLCZb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 22:25:31 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87342C06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 19:25:31 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id k23so985755iom.10
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 19:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lOhPkOVf6eksGF3MTC8QbHXU2MaE02R97fSDrpg/mSM=;
        b=YNAzvtU7/KZJa1kM8hw7UdpInLqLehneLtoVNQUoXtgKfvUgzxVSSY+EGeNI7xzpmB
         H7c4LDHAB1sVnITdIP2vkXoI+/k8sgRJ3uoK5Ef4SuceeN4sM8mrY+/OhMYSMmklUJiT
         UUMmXQdQ+xkHNH+alAXGwXbnO8c/m9hqIya7BozOyv9zsKR8EX49KisUh+EifoGELkWD
         R84sVhnTL+A3NhAujt67kmhHQVg6EOyfM2tf4SG4CL9mpUgiY36/mLsTivUNNvs89f8g
         OQSe6SM35AUWsi4DC0DpwpyKLWcsfesCA4Ac5HoYZhhH95Sqx/2k/51g8sukJoPOj8F1
         GDiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lOhPkOVf6eksGF3MTC8QbHXU2MaE02R97fSDrpg/mSM=;
        b=f2LTl2CRGeSWvsXBpBsKcwCsS1mf4NKjL2olwqBWcLVfbtTYUfsy7MqWvCR+EpGFwd
         7ArxiW5G/2y25274kQ050wlL04ilzH6esguGNX9o6Y21ydJ2l3yhBlm97A28sTdOvhaf
         rDSLDp7xOae/lU+cpF2kM593Gq1yVDfYzm+71ejI6H56hOO6LXjuObzSbxQ5qHBzVsNW
         tjvVD0sY0US4YUreHypX52dMQB3SPo1ijJIWRZz7ChdsSg19ACi+yStakfqLpkK7p267
         3Fq0UW/Uxk8YtYEl1UgyqIk4jV/FIeOcP+h7NZ2qjvuKrEn+bCHQc1gTuuaDaAGXD+jd
         U89A==
X-Gm-Message-State: AOAM532VxzoNdUdSaGbLXq5/yrXBVL8j2fZswGgis97xN4VIm9tkKOHn
        mm4/Qod9dLI4+aRyzszETY+6lTqoMk5l36m7+peOIQ==
X-Google-Smtp-Source: ABdhPJwnE2VWVzfjsMuoyoIrAS5LO7fVZTXv1xvjtdwwo25QmluABscTbGile/aGlYsF1zmrReGv87zWGaJHfdvjCyU=
X-Received: by 2002:a05:6638:22d0:: with SMTP id j16mr29270233jat.97.1597199130649;
 Tue, 11 Aug 2020 19:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200812013440.851707-1-edumazet@google.com>
In-Reply-To: <20200812013440.851707-1-edumazet@google.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Tue, 11 Aug 2020 19:25:18 -0700
Message-ID: <CANP3RGfi3Uo2Rf_w_sidBjd3FY5CtzDsnAYOapzaYPEL6LkGwQ@mail.gmail.com>
Subject: Re: [PATCH net] net: accept an empty mask in /sys/class/net/*/queues/rx-*/rps_cpus
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alex Belits <abelits@marvell.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reviewed-by: Maciej =C5=BBenczykowski <maze@google.com>
