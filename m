Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C008D46A5F0
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348670AbhLFTu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 14:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245093AbhLFTuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 14:50:55 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3783DC061746
        for <netdev@vger.kernel.org>; Mon,  6 Dec 2021 11:47:26 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id f186so34395299ybg.2
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cN0+Y5eWc+w3iXRFFP7c0QYiQDJr9o9xl8FCMadS98w=;
        b=OUjyrLYdN/SqHit156tb8oGK3tPHlUmQG+hW0JntEy9wuTeHLt70Yg6T0xhqephKBX
         8kPVcwSPJdTP/OV8As3KaDxL4SkoWXl8zZ1JgX+rzqZ/P1f9GglpDDL7gg6L2zhQErZU
         5SVrJWZX2rbuf2vzWeCfaXUXkx5ZHsViztgrknfStyjrpAPCZyPK4ZGimMZG5AgMKgUr
         bWxqj+AarZSsyowfrIbVzj2b1UENrMF7asGJt7sSJQhn7pjc0I/PJDKNqh8iZRAU1Q2h
         MRgStqfomKioO1dT4YqRqfUu9Z6dqokIcqiiBw298FLmAg+k7bjboBUVwdHWaDC+HI8F
         Gcdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cN0+Y5eWc+w3iXRFFP7c0QYiQDJr9o9xl8FCMadS98w=;
        b=3HOjHYVuGDLXS2I8+AIXtfxIAZAf0nHm0wy88esT4MFJu7EeVGMXC5PpkWzF8fcm/C
         ye6GmPHWQ7lkk6n2kCt4qkaW8O4FurSYzz/39d1gTyHzWlXhwAwP8Lj+giuh4C9TwHvw
         169qcfTqnDWHYuMjT33gnkOp50hlYXDjlWYp+qPElP8zSA/VlLwj8SYqPyW6EmRMhO2s
         IAlF4b2f+GBYpxtW7j0OyPXpKJQBzHUt1tIQe4fAPQ/F76+p5Ukgg7L3/ENmR/Cf75jw
         PDT1MnIQwr8DG1dzIBmAg8Uzp1p1L3ALLCDZqGKdOSqOZaJtSmoes0xMZ6Fptr5v0cDu
         y0CQ==
X-Gm-Message-State: AOAM531wLNHFci9hn6ywqXYo8RfqVyhx2hz4Qt4i/PAARe60YsJj/uFX
        IJNbI5uKoZNxzcekIlRPlM9eYeQr5bd8slyYsgKwZXPchf0=
X-Google-Smtp-Source: ABdhPJwd46XfbOCUJfDKY8toonirWdmEGdGxDT1mveBhG6khbaV8OubVfs8hCth0EGmWEy279qh5L+JSjQBnUIZE4ew=
X-Received: by 2002:a05:6902:1025:: with SMTP id x5mr45981411ybt.156.1638820045131;
 Mon, 06 Dec 2021 11:47:25 -0800 (PST)
MIME-Version: 1.0
References: <20211025203521.13507-1-hmukos@yandex-team.ru> <20211206191111.14376-1-hmukos@yandex-team.ru>
 <20211206191111.14376-2-hmukos@yandex-team.ru>
In-Reply-To: <20211206191111.14376-2-hmukos@yandex-team.ru>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 6 Dec 2021 11:47:14 -0800
Message-ID: <CANn89iJ6VQHzPNHOBQdiwZW1p0eLQ0u7F2Ns_=QtYmHd-vubww@mail.gmail.com>
Subject: Re: [RFC PATCH v3 net-next 1/4] txhash: Make rethinking txhash
 behavior configurable via sysctl
To:     Akhmat Karakotov <hmukos@yandex-team.ru>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        mitradir@yandex-team.ru, tom@herbertland.com, zeil@yandex-team.ru
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 6, 2021 at 11:11 AM Akhmat Karakotov <hmukos@yandex-team.ru> wrote:
>
> Add a per ns sysctl that controls the txhash rethink behavior,
> sk_rethink_txhash. When enabled, the same behavior is retained, when
> disabled, rethink is not performed. Sysctl is enabled by default.
>
> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>

Reviewed-by: Eric Dumazet <edumazet@google.com>
