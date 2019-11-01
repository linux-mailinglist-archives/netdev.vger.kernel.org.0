Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED43ECBFB
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbfKAXk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:40:26 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38633 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAXk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:40:26 -0400
Received: by mail-qt1-f194.google.com with SMTP id t26so15194353qtr.5
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 16:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h7OSC7hGzqXcF9i4/Irx2uWsoIgb79lKNcgTIQkzeTU=;
        b=BjKgp62r62yC+7JaTk/hGbn9dnagUfE++UfUK2TPfvP8kdPJJKGzbA/WCZsh+KXvb0
         gQ729hPCDhwX5mcc4/iu0a5JUvhy3Y077FaeA1pBbGjBRA5qEFzmIqSZfiE924QSGxP3
         CWLn/LVzbXCa4i5qhatSzq1EU4IKxG18NDb7RjHkwVbefueT1LKY9RJHXcjhvFitbb6k
         xHncUOH/YzoWy5vhhaDtTvwbcMG5F8nwV124mrG0xh5uAuofVvi1RknnViVhHAa0IrMH
         5QeOxhDiP82h2boLEQT3e6nXNNdieKyGhTZnJ+q5G019Z4SkQWO9OmfKX9dCx8bnugRi
         /9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h7OSC7hGzqXcF9i4/Irx2uWsoIgb79lKNcgTIQkzeTU=;
        b=pVfmllvAwM8ZnmrAqZs+n5VSvnaUgDwRSWSsuG64Nue1LGxoRIri2h0Pt6ZcEdPSPG
         kJRxwxr5c+vOVSF8pqAb2dSwTBv8X5oLjeJtvExmuKNoLQOYL2+byItduc6Yzl9Y6K0m
         7OGUX1R3ESpR2lAZnq1TzlHUsi4h3mSKM7R46OMdNiKpVXKXNpnZVEUgi1N+QZcxFRHw
         L4BvBgfAuWcZBcfa+jz/LxrApkkEbeia4UmXUKZrV7se9HV9UKoUzXxsdFIcWq6nTW8V
         gQlgvkI99oHGkbdTOYWrWELlH0JN4HTkONP+Ip/XB5zdYASwYap703nIq2j7xs75Fdre
         TTOw==
X-Gm-Message-State: APjAAAWRynRqrE2VpXqUvZsOrohqajoKwrLuYAKrX4KLjjThjGO/Pdz9
        sivhcuHEW1EzjxMS0qek1y2OHLMkicQ+FeDEh/E=
X-Google-Smtp-Source: APXvYqzw5UyzQTdkjtO2QOq5atlvRW515/QX6GWEphsK4R/IEWY0VUBb78WL+IudJG+ma8UcrsHPOkpHHKxq1WQbwE8=
X-Received: by 2002:ac8:17ce:: with SMTP id r14mr2121244qtk.301.1572651623696;
 Fri, 01 Nov 2019 16:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com> <1572618234-6904-2-git-send-email-xiangxia.m.yue@gmail.com>
In-Reply-To: <1572618234-6904-2-git-send-email-xiangxia.m.yue@gmail.com>
From:   William Tu <u9012063@gmail.com>
Date:   Fri, 1 Nov 2019 16:39:45 -0700
Message-ID: <CALDO+Sb3aV=WreJWAGAPaS0eJ2NpAqcZhKnpzXdphEq8chHm8Q@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v6 01/10] net: openvswitch: add
 flow-mask cache for performance
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Greg Rose <gvrose8192@gmail.com>, pravin shelar <pshelar@ovn.org>,
        David Miller <davem@davemloft.net>,
        "<dev@openvswitch.org>" <dev@openvswitch.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 1, 2019 at 7:25 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The idea of this optimization comes from a patch which
> is committed in 2014, openvswitch community. The author
> is Pravin B Shelar. In order to get high performance, I
> implement it again. Later patches will use it.
>
> Pravin B Shelar, says:
> | On every packet OVS needs to lookup flow-table with every
> | mask until it finds a match. The packet flow-key is first
> | masked with mask in the list and then the masked key is
> | looked up in flow-table. Therefore number of masks can
> | affect packet processing performance.
>
> Link: https://github.com/openvswitch/ovs/commit/5604935e4e1cbc16611d2d97f50b717aa31e8ec5
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Greg Rose <gvrose8192@gmail.com>
> Acked-by: William Tu <u9012063@gmail.com>
> ---

Do you consider change author of this patch to Pravin?

Regards,
William

<snip>
