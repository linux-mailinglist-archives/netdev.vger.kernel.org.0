Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF1446DD97
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbhLHV3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234732AbhLHV3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 16:29:08 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B04C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 13:25:35 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id j14so7113168uan.10
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 13:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qPeI5/clEODT582hPwenfvQnW3rNylut+fUamnF5AN8=;
        b=IFAwnTdEMdmlYbwYPRrBmKAeR4hIOeWN/xarpuaFzwG4gOGWi9df2vWAZ3J+3ufX3A
         q+rBb+2oRce1mlEkcm/SX6rllkcJ/2Xo2pD9OZQD4Mg3WrV1jalIm9+ITT17HZ36dxGI
         ERvz3ardX0xu3fVr8BOm5c9MjQkmIYdcE/c7DVmXO/4MGNmZXcEC/bvrSK1dGW4dUo5S
         l8fc/CyofTqQi9E6XflNiRUtXL7aav/1gU0muwlU3sH5pNQjjDS8MwasHzG7CCsiajmy
         tmAFVGK7YQGgOLn0y02nCA8i6WWXIkp/mSJqyBDByVnTA80qvUFdn9zvoQUayFnfZXGL
         woVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qPeI5/clEODT582hPwenfvQnW3rNylut+fUamnF5AN8=;
        b=1fTzf5FfjoOigBZA1R3mEtuflDtx7Ji1N1TMoWxJaWnBi39rwU9o41KAF9xbCYQW7V
         TCI1YMv4i8WwQo2yUSxBVuLrTw7iS62XO5jKa/lTivSPZBEyJ+jvFngH7c0tzGbju5+c
         kVq+ei4R8z2KwgEqZJZzY4C5JRe/4+HJSoVGI7KEd1tswDtK0fTB+YgkHZoyj5nnk4Zh
         XG+rZsIO8OWN0Iz+E6f50NEUsEsGPrWo1BDqNN2fJEHjJomSwAnx0f4seS4IECEgNHgT
         TyqOEKT6d4izvatGM+pLL2mWbiybL3u4Kk+yAewgKCvS6m+cGLNSTHe0vUywcP99OloS
         A4PA==
X-Gm-Message-State: AOAM533o/hKJowzaIBf4KawHyWB/MJ7+hxpGSSSgZ9v4RysToM+oqhlM
        P6HsJTzTt6ZSsg8MPFhZ4M6N1fnbrDw=
X-Google-Smtp-Source: ABdhPJzb5TWmD5vfPxkzWRUgFJFH04aoBcDQfMtE1yH+bAHXaW8W25swIu5cB9aE3OoNYSLpKUKk2Q==
X-Received: by 2002:a67:6684:: with SMTP id a126mr1544401vsc.22.1638998734969;
        Wed, 08 Dec 2021 13:25:34 -0800 (PST)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id a4sm2503608vkm.46.2021.12.08.13.25.33
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 13:25:34 -0800 (PST)
Received: by mail-ua1-f41.google.com with SMTP id n6so7216887uak.1
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 13:25:33 -0800 (PST)
X-Received: by 2002:a05:6102:3053:: with SMTP id w19mr1488312vsa.60.1638998733270;
 Wed, 08 Dec 2021 13:25:33 -0800 (PST)
MIME-Version: 1.0
References: <20211208173831.3791157-1-andrew@lunn.ch> <20211208173831.3791157-3-andrew@lunn.ch>
In-Reply-To: <20211208173831.3791157-3-andrew@lunn.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 8 Dec 2021 16:24:56 -0500
X-Gmail-Original-Message-ID: <CA+FuTScGS_s=PCYnXzJbkABOQ7nirg4aa-HwzHjk4crp9vic1w@mail.gmail.com>
Message-ID: <CA+FuTScGS_s=PCYnXzJbkABOQ7nirg4aa-HwzHjk4crp9vic1w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 1/3] seg6: export get_srh() for ICMP handling
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 12:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> From 387a5e9d6b2749d0457ccc760a5b785c2df8f799 Mon Sep 17 00:00:00 2001
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Sat, 20 Nov 2021 12:51:07 -0600
> Subject: [PATCH net-next v4 2/3] icmp: ICMPV6: Examine invoking packet for
>  Segment Route Headers.

Something went wrong when sending this patch series.

The above header is part of the commit message, and this patch is
marked as 1/3. See also in
https://patchwork.kernel.org/project/netdevbpf

Otherwise the code looks good to me.
