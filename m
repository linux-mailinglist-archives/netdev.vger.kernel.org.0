Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56571494E0D
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 13:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiATMjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 07:39:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiATMjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 07:39:32 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4900EC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 04:39:32 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id g14so17298940ybs.8
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 04:39:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OtYThnuXZ64FC2xEm0MpHtJ+CGhuhRvjwKzN9HwfmLc=;
        b=p3YkqnswccgQPuT+ZJajrr+bnSGGlZF6WfQ2aQkKzNyTChQ/6GAiloPiWQKNOmnYNs
         yB7AYCLiuIq8ka2XTvTjdOjyvshaB6anjXlwUueG9wunDoNHV7UsU9e3ISpBtkkdn5yc
         EsP10nlJ2wiReieLWNrIiGmQ+S29YvHPbKOtKA+Q8dK28YQI47BataQH6GJT1TtNqEQ5
         CTEScHcOYlD7C/NL024M/mpQTe1NomVqfLpDazrPnGajY28I7++fE8AP66YP9KEELJdA
         8j2uRw4qlx2BuL/zf15REjxDTf2q3TjHSoM9aEKLtqsaeD8iR7L7jCpWZddjxK8Fb7Ni
         7JdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OtYThnuXZ64FC2xEm0MpHtJ+CGhuhRvjwKzN9HwfmLc=;
        b=wubPxjnHIksfVV09cu3D11aMlftwEOyWGqEWw+BFq5R8TYV4nt21Z0zBWryJ/54LhP
         WgkJsQ2YLxWi9b+o/fYZc3w9HxIqqS+sAc+Tzix90jgiRmqNJQnoOsX8O5OLzAo6YiCk
         te2PdXuZ2Fhh5o47KuEGjoCjkwqnu2TGmfgMwbZLGTaIO9eeK9h1EzSCi3VoIWmHbrdT
         OrUnVohGGQZuL1piTiz6Jtn7j/VNC/om7/lQVzI6iugG2MGF30bNW1oxnMW6JWPB0o0Q
         dfbiIwEzFdToLfvbcdL+GkX24O9WnyXyfpULGkaBLjqB2Y4aoGlg54QXWI9KMG8RvE2k
         RMSA==
X-Gm-Message-State: AOAM532vPtHCmmWdTkP/3igZ3MwCjx9YhctSmrwc3A9YakH8QJJ0KZW8
        5+rMjG6xVyg0dIeEevKscCmp0xCG2Y7xh6Pm0splMw==
X-Google-Smtp-Source: ABdhPJzXG1m8gXlv7TrnnVJOnyWQCKOwl2dhPM8jFwFAs3ExiMG7+UKM2K0DpIztiOo59jjS4140Ibs6YH7YinOXtVk=
X-Received: by 2002:a25:a10a:: with SMTP id z10mr49638116ybh.753.1642682371047;
 Thu, 20 Jan 2022 04:39:31 -0800 (PST)
MIME-Version: 1.0
References: <20220120123440.9088-1-gal@nvidia.com>
In-Reply-To: <20220120123440.9088-1-gal@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 20 Jan 2022 04:39:19 -0800
Message-ID: <CANn89iK=2cxKC+8AFEu_QbANd1-LU+aUxNOfPvrjVJT5-e0ubA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: Add a stub for sk_defer_free_flush()
To:     Gal Pressman <gal@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 4:34 AM Gal Pressman <gal@nvidia.com> wrote:
>
> When compiling the kernel with CONFIG_INET disabled, the
> sk_defer_free_flush() should be defined as a nop.
>
> This resolves the following compilation error:
>   ld: net/core/sock.o: in function `sk_defer_free_flush':
>   ./include/net/tcp.h:1378: undefined reference to `__sk_defer_free_flush'

Yes, this is one way to fix this, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
