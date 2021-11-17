Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA93A454DB9
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhKQTQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:16:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233430AbhKQTQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 14:16:14 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52132C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:13:15 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id k83so2289676vke.7
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rjfNJXYss0yM1d0G3ZncAxHFz1pqCZPuxVhI/HjUUcw=;
        b=iLfpRASuYoy71DN7niN8lFYMGrBpObaI9d6bOAo995J38FUHRIQCuT/CgtCihL6Zkf
         RAIFGHUG91+ro/JDRE17HvLPKCsb56I1irDVWuCzFIoCnZy64qdi/4+ojImSECoswkPi
         cKikRBr4RFinRDI0TlxIg00slaJWSdnJIgv6ys5iNfT6sUSIET6BUQZ0HH5ZQdsOcy+9
         m4mA308Q6Yy4n0S4M+Jh0JAHKVJa4KW3XEjgLv4nSEkUIcjIU/ttd8pr72b2lPm4O83Z
         YQxuQB8W+8v2qwfsNYcJ7x3+VYhtb1pyKxyg8WXMNdT9UkNwfY2/MTU55WVvvXoukum0
         r7XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rjfNJXYss0yM1d0G3ZncAxHFz1pqCZPuxVhI/HjUUcw=;
        b=ZpCOwt4cSpfitZn2ZhbC0Z93IFVsovEOTf/Py8mG10+OaxbYMaqQilVHdsRRLu86mM
         sIAF2h7fTKtkiU8J+0gSCyeFiaD/Ab/6tKmEFVa8U9bu+NbjJjGK0VDYa+vvQMukbVda
         Wx0dPEqq0QM5FL44jgWHb/35MqFszeA8KiAFc7NqFDjfj7YumS3qcDxxU2ToDJDdrXOb
         aub7KOE3pYvKk79dIuh6pJSVcJ5xaSPN9FSNp8JBpVvdUD7k4Q8N4uHRbM3iz39DvZRB
         RaGtWwg5Q1XUUzi1EgLqTMrTQHGhSQhbp++54CN0/SVcLinG38DrjyLnATYJs+7aOsoS
         YiKQ==
X-Gm-Message-State: AOAM531VF8U4I44DF0yD3UzB+YU/93zH/T3zQaQ1+/EPN6aAVNR52tYa
        CB9felfGRo4BOWw6g5Iwjnayr3y6vkgG9iTPipEYSz57
X-Google-Smtp-Source: ABdhPJxmUaAw3MnJMcV9caDqaqSdkyrNRmsjdyNtIZ7bc8J6PuqmITslykA/a/RDUpCkjhGCL9Cb9rA4IcN+1+sY/08=
X-Received: by 2002:a05:6122:1812:: with SMTP id ay18mr93848051vkb.18.1637176394573;
 Wed, 17 Nov 2021 11:13:14 -0800 (PST)
MIME-Version: 1.0
References: <20211117174723.2305681-1-kuba@kernel.org> <20211117174723.2305681-2-kuba@kernel.org>
In-Reply-To: <20211117174723.2305681-2-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Wed, 17 Nov 2021 11:13:03 -0800
Message-ID: <CAL4WiipFY_YKMGbtEmYq0M=18yCEvLoGvXRSgui4+-NJR-ReiA@mail.gmail.com>
Subject: Re: [RFC net-next 1/2] net: add netdev_refs debug
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 17, 2021 at 9:47 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Debugging netdev ref leaks is still pretty hard. Eric added
> optional use of a normal refcount which is useful for tracking
> abuse of existing users.
>
> For new code, however, it'd be great if we could actually track
> the refs per-user. Allowing us to detect leaks where they happen.
> This patch introduces a netdev_ref type and uses the debug_objects
> infra to track refs being lost or misused.
>
> In the future we can extend this structure to also catch those
> who fail to release the ref on unregistering notification.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---

Interesting, I was working on something very different, let me send
the RFC (it is absolutely not complete at this point)
