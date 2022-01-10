Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CCB488E93
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 03:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbiAJCHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 21:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiAJCHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 21:07:45 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D9AC06173F;
        Sun,  9 Jan 2022 18:07:45 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id w22so5100145iov.3;
        Sun, 09 Jan 2022 18:07:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ILAgxz/MUsEIzatCyjcXIF+/3AVeoAEkSaEJYYkCIeQ=;
        b=K+5j8XiU3kx3z+i6KILaiZcycze9cqXx2iRlsCftGCzIcOEcYgvYJuH3WZVjvJsuVU
         OgEkWuXWVtWgSq4bCR86OsN43qztsv2XXAal1PLCt6WpafZ/yc4gNEaU+jgFI1awnQEv
         Q+VbZzMlWoKFpeoCTTRAIKne68YSSWXRn5nJFu+mJSJ5doBhjqZaI78T1dkunyE4gwMd
         dUl9LmIpmF6kXHA7kpzm3NuvAYyn2BePm0SPIzTt6vA5VzK0huBLhhhcOU1xvCUfgnHc
         G4mImQtxZ52TEO4pZbbFrLbOD0PdYgINxTloqHUfIvbG0mwkqGxXx4CKNSwDjk5GgZKT
         Galw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ILAgxz/MUsEIzatCyjcXIF+/3AVeoAEkSaEJYYkCIeQ=;
        b=r0EsRjjVuz+IYFaCfxcHeu4Omi8SZzJGWHwv2niI+WRm70zMEV/7lvSVJXZvUXV8f+
         WGyoxTZux3ZBH92jFe8aTSJEhtlwE7LAj1nL/cDM3sn2aKfR3DnVRnRWosE0jHi7Oi/Q
         P3jEEj5O50/6+lzytKanRTzcpnqKNAdAuI8T/4Jf8xG9iKgpfDx+b6fejQs0YT9Z6NL0
         K8/WX5xIMiDVkG18yJHdSqXRYkydk56D8S9/6BMsOTsArF5g7hl8xG+vj5oMTXnUxR+0
         WNkkqvy1aStTaF7M9UzRwJ8QI3mIetwOzHo7sj2C9GGH2Wcrjz2ql3+CEjLXVHz1jhcv
         niFg==
X-Gm-Message-State: AOAM5330qHh3I4NqtooZFkJqKrQY56Nt7JQcxyEAbcjHUTkF+5PFyIkw
        aDva++TA1BldaBrczpJSGfgh18hYvp4fAMGvfYnC2dLK7kUbYg==
X-Google-Smtp-Source: ABdhPJwP5oUkIzGVb0ceZahTRQrJW12Ap7UnW/q9mWjGAB6T2IceCFGBaTlQrRnSAUMslb1Ta2UmG8eaHKQmifF69jk=
X-Received: by 2002:a6b:1452:: with SMTP id 79mr34429455iou.62.1641780464448;
 Sun, 09 Jan 2022 18:07:44 -0800 (PST)
MIME-Version: 1.0
From:   Benjamin Yim <yan2228598786@gmail.com>
Date:   Mon, 10 Jan 2022 10:07:33 +0800
Message-ID: <CALcyL7gK6xBLkuUAc6hJmiKwddjh8uhP1F1oCEdb+YTy-XTXiQ@mail.gmail.com>
Subject: Re: [PATCH] net: skb: introduce kfree_skb_reason()
To:     imagedong@tencent.com
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jan 2022 14:36:26 +0800 Menglong Dong wrote:

> Introduce the interface kfree_skb_reason(), which is able to pass
> the reason why the skb is dropped to 'kfree_skb' tracepoint.

> Add the 'reason' field to 'trace_kfree_skb', therefor user can get
> more detail information about abnormal skb with 'drop_monitor' or
> eBPF.

> All drop reasons are defined in the enum 'skb_drop_reason', and
> they will be print as string in 'kfree_skb' tracepoint in format
> of 'reason: XXX'.

> ( Maybe the reasons should be defined in a uapi header file, so that
> user space can use them? )

Since these drops are hardly hot path, why not simply use a string ?
An ENUM will not really help grep games.

tcp_drop(sk, skb, "csum error");


can refer to the previous discussion: https://lkml.org/lkml/2021/8/25/613
