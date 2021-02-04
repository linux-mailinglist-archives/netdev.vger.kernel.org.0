Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C2030F790
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhBDQUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237866AbhBDQUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 11:20:11 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C43C0613D6
        for <netdev@vger.kernel.org>; Thu,  4 Feb 2021 08:19:26 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id e133so3768073iof.8
        for <netdev@vger.kernel.org>; Thu, 04 Feb 2021 08:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W4SEIsw/cse6byIrFcWwK7Gy1uRGvmSLkKIfeJJmkDg=;
        b=J7/dFqBtGhzidCblWVkOA0xYg+h9662Tb1/bGkOQ99JWlqha+wrRYRYXH+cteNiC62
         nmX5zyvQNdjQ0ku9FGrYXhWbHB+xledUQA1g9OtCJ0SCaW5R+VPjSQeR4MKlQf1NYx6l
         JCjfJwHsqye3DijQyGOLIHh18zbZR6tfDqs6d+20SGgHPsZ0ZTHNmnn/4vSv+Et6kDuQ
         6BdoRpv6MuFYngHFYXaEPyrJLVRejdLuD/uuMl3l08yHcdwTFG6o5ZcR9S7Mi8VtZshZ
         no6erjWwIF2g6MmcB9EPDLVHCtk+5oZ0l5b7X+sbUFWezgGXexYFB35GUW+GAHD+F8MD
         ifzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W4SEIsw/cse6byIrFcWwK7Gy1uRGvmSLkKIfeJJmkDg=;
        b=Gy6jPtBozLbS4psF+/HLfMPjnwPNVZhqDW1yb5JPe/JD+jcdHad1k/ksxArPB3R8qJ
         qbrTWvLkz5fvPCCxqmYB8t95Evzml1xmz5VuQVa+DdA+j92gqmUnmzUe7bt/jnTtWe5w
         QBsfbE0QQCxJDxXnMQzDcmiW3L88FCVpwHwVpUD3oKNk1A+FYOThHymU/JcNYAIDartD
         Pylyl+qHQ2NR1a7oEU09PmI2JXMJxpLHPCxm3ceHTAQlOIlFeBGFaFkHxVNyFhNC+/mB
         XG3rGDv98JSEpjfFJ1an7cxO0kinilac3pWJZIku4xRQPd3+0gC3B4MoAIrQg0WQTAsG
         9EGQ==
X-Gm-Message-State: AOAM5317gzJwbkHY5UIuHvnJetbjbsxj11HQZJpKasannYgAveXZzw4D
        LA5QTcPyWNXewPlBL+sYgf8Zw9ljqzTdHtieEoU=
X-Google-Smtp-Source: ABdhPJwvvKlIYoxzYgbeDd543I8dzUkX4GaUX9gsIOicvu/lH5UNx1ggvkBI7a5rSfDhNbX3rwR8rL07O56GJgbUwu8=
X-Received: by 2002:a05:6638:388e:: with SMTP id b14mr308289jav.96.1612455566188;
 Thu, 04 Feb 2021 08:19:26 -0800 (PST)
MIME-Version: 1.0
References: <20210204105638.1584-1-haokexin@gmail.com> <20210204105638.1584-3-haokexin@gmail.com>
In-Reply-To: <20210204105638.1584-3-haokexin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 4 Feb 2021 08:19:15 -0800
Message-ID: <CAKgT0UdrAABMsc9BoO1pkR1=ZXCWp4EvhJTT0Ow9cGeX2EvQMQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net: Introduce {netdev,napi}_alloc_frag_align()
To:     Kevin Hao <haokexin@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 4, 2021 at 3:06 AM Kevin Hao <haokexin@gmail.com> wrote:
>
> In the current implementation of {netdev,napi}_alloc_frag(), it doesn't
> have any align guarantee for the returned buffer address, But for some
> hardwares they do require the DMA buffer to be aligned correctly,
> so we would have to use some workarounds like below if the buffers
> allocated by the {netdev,napi}_alloc_frag() are used by these hardwares
> for DMA.
>     buf = napi_alloc_frag(really_needed_size + align);
>     buf = PTR_ALIGN(buf, align);
>
> These codes seems ugly and would waste a lot of memories if the buffers
> are used in a network driver for the TX/RX. We have added the align
> support for the page_frag functions, so add the corresponding
> {netdev,napi}_frag functions.
>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> ---
> v3: Use align mask and refactor the {netdev,napi}_alloc_frag_align() as
>     suggested by Alexander.
>
>  include/linux/skbuff.h | 36 ++++++++++++++++++++++++++++++++++--
>  net/core/skbuff.c      | 26 ++++++++++----------------
>  2 files changed, 44 insertions(+), 18 deletions(-)

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
