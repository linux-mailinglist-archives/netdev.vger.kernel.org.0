Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B324A7DDC
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 03:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbiBCCSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 21:18:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbiBCCSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 21:18:54 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71C0C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 18:18:54 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id 124so3825687ybw.6
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 18:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5VXumuQukBDW1MBigJIujh1Nw+gfiUTGM4JN8kQRBAE=;
        b=kPWjyiMgiDZtNXWNUjvjVeQMBm8qlYZmgxDXKmgAgyFU/Gn63PccCY7clS203G+h0s
         R9wAoRz+IdYzQU4bGRREYKarHP8JRhulWxnVREx6+xQjGFPjwnmww/HWBYdZvlk725DD
         QRIuEz0OJIljDMALJBQQzEzBsQetPscr3Ghfup5jjYtGQoXWbglO3pAt8SAmORKeXDZZ
         rJRGQTGAkQ6QgTuacCGYWA+01QxWc2XzOtc6QSwUeuYkk2Mb6Ceib66AwD4OVi3XytYF
         ISqYUUiTbsPo0cpxwKWX9GT3AaZCYvBZrxqfDzsFXNIppaE5WR8IRtlGw70j5+xE3zeE
         P5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5VXumuQukBDW1MBigJIujh1Nw+gfiUTGM4JN8kQRBAE=;
        b=fYXRN/aA7nITK54jHOzjjkcT7yrNkQLCIq7MNg/ZFEgH1j2o2ZU4TvQIAAYbgY8Umt
         JKA+r4V2yjwXgZtl/7RlFW9Wg92MEgbXztac6/0b85aibK533Ue4wWEwrZweLzqCYQWp
         XPq3Xknoq1RlbI0/mrmOrWfHcfNRWfBq//Ju/9tMxT423+jQ/mp/eYozbjQz0d7L7CdF
         cKaEdh/3kcHl1gNqL8Ymq6BKkHpgXh2VpQkrRD1MioIDfWgTiRKzPVkjf00UVu6jgGpJ
         +vNlct8v8g7qcl0FwYU7mjXm9zbELpN/TbLRNl+YBpGwcRYMvlP7nMRLjwAYshxhqZFQ
         NICQ==
X-Gm-Message-State: AOAM530NG/87TBuK9C4a4mmsPqvwWqkqT4uvArt+SWVU3NcznjGalLLK
        HigVV+UQ14Bx/9Qw7i6nish+Jt8iz1lXm0WxE863sQ==
X-Google-Smtp-Source: ABdhPJz/dnPJUUTUxbmiSZHB4fqeSGeO3X83B/QH8Br5qtIJgOrXWl7aaLAAzUsUmHxQF3Y5cq6LuE0kYotVFqguFHs=
X-Received: by 2002:a25:d2cb:: with SMTP id j194mr44686503ybg.277.1643854733486;
 Wed, 02 Feb 2022 18:18:53 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com> <20220203015140.3022854-8-eric.dumazet@gmail.com>
In-Reply-To: <20220203015140.3022854-8-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 2 Feb 2022 18:18:41 -0800
Message-ID: <CANn89iJNkEYqrFXhAUkWpghp-aHA5crCbMDi7M3z-RipcMB=1w@mail.gmail.com>
Subject: Re: [PATCH net-next 07/15] ipv6: add GRO_IPV6_MAX_SIZE
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 2, 2022 at 5:52 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: "Signed-off-by: Coco Li" <lixiaoyan@google.com>

Small glitch here, it should be:

From: Coco Li <lixiaoyan@google.com>

Fixed in my tree :)

>
> Enable GRO to have IPv6 specific limit for max packet size.
>
> This patch introduces new dev->gro_ipv6_max_size
> that is modifiable through ip link.
>
> ip link set dev eth0 gro_ipv6_max_size 185000
>
> Note that this value is only considered if bigger than
> gro_max_size, and for non encapsulated TCP/ipv6 packets.
>
> Signed-off-by: Coco Li <lixiaoyan@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
