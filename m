Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279891DD6C1
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730440AbgEUTJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730425AbgEUTJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 15:09:58 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6657C061A0E;
        Thu, 21 May 2020 12:09:56 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id ee19so3574053qvb.11;
        Thu, 21 May 2020 12:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4V3QDFKFZsXUI/pfICicsfUOUS9805zC9jDFYXssMow=;
        b=eSYhanAzQhGZEiY+3dCu1QiaG4ITdyGX6ae1gmfSbsm3f2/HIxaUV0umpnjYORaAAn
         v2HLmOP2W0saotJcQtTcVtzDo23F/xke6NCmpDfy0+GIffzPzYKR1MBCu4gif1hILRWd
         sjEh5JgoWf1gCSkR/HhmENEoq1lOzxxv91FPqEsUbVyQXKe7nCRgZi5GLQ1ogb5fZSk/
         gVgTEiwDjz2u4GbscR/g9oL7upJChTq/RMkKvNV/ohYHCYOtdGIsPfY8u62LUcvjp0W/
         o3DPzqmiGuaXh+aLthcAnVUp1sHwIY4zMXCzQR6ECGIgzZhqECwt4hXl1LaAaqDc1wK0
         0BJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4V3QDFKFZsXUI/pfICicsfUOUS9805zC9jDFYXssMow=;
        b=IC2V62o55hkf2sXrnBcwyhwfSAa4g17ZS+kVJ3yfTg7BrYnjUmcsPUNZgoYMBfWNoN
         dznX+CXl29/3V84d/s6jwKR5UbOO4qMUXXVcNFqOldSXT3cO7qHtqYtTd2sZ7Fjw3jRG
         UGfJQsGIsSkhZvPjhE9Eq3I7U6DBW/dSI8RLXyy7nLr5bYo4XLK+sgRknkHiBzYbIw6S
         0qfU3bpGgRLEaf4RnIqxPfPNLR4jLOfggqJLsFNLfAgfY7jiD5102iMbNCMdjb5NWIJg
         eFra1cVkDD5bE4BhaR0kyqD8s4tYzTvqdqvSpAuqWR59kEhZSbrUQsx2E9aCjP3oN4f4
         /sjA==
X-Gm-Message-State: AOAM530vIA1wi8USXeU1QiYxyCqDQKsHDZUIr4knNjPGPL5UTZH5Kkgl
        8ia6PZpC2FptFotsjoaYqUpbjEZ2izvtISqxwRg=
X-Google-Smtp-Source: ABdhPJxwY7wkwdwPPUpUKbQ9KmcRGuP5kLAjHm6RSFl1KIuQK/XEoCOpe7Q4V3p1Q5WeVohxLyfeX3oo1PNWJqCLoaE=
X-Received: by 2002:a0c:e4d4:: with SMTP id g20mr205248qvm.228.1590088195968;
 Thu, 21 May 2020 12:09:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200521125247.30178-1-fejes@inf.elte.hu>
In-Reply-To: <20200521125247.30178-1-fejes@inf.elte.hu>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 21 May 2020 12:09:45 -0700
Message-ID: <CAEf4BzYO-1UsmO6r3x2C95xLj+Lxg73c0hKF8-ZEnA8Bqy=pvg@mail.gmail.com>
Subject: Re: [PATCH net-next] Extending bpf_setsockopt with SO_BINDTODEVICE sockopt
To:     Ferenc Fejes <fejes@inf.elte.hu>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 5:54 AM Ferenc Fejes <fejes@inf.elte.hu> wrote:
>
> This option makes possible to programatically bind sockets to netdevices.
> With the help of this option sockets of VRF unaware applications
> could be distributed between multiple VRFs with eBPF sock_ops program.
> This let the applications benefit from the multiple possible routes.
>
> Signed-off-by: Ferenc Fejes <fejes@inf.elte.hu>
> ---
>  net/core/filter.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
>

I'll let more networking-familiar folks to comment on functionality,
but features like this needs tests in selftest/bpf.

> diff --git a/net/core/filter.c b/net/core/filter.c
> index 822d662f97ef..25dac75bfc5d 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c

[...]
