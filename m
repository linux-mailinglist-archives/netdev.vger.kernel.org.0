Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892771FFD0E
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 23:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgFRVCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 17:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgFRVCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 17:02:17 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31C3C06174E;
        Thu, 18 Jun 2020 14:02:16 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a9so8984751ljn.6;
        Thu, 18 Jun 2020 14:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TMDMECxtDyrKw7UR9Mx7zsMc3I+ujgCjjWQyhNCKNAU=;
        b=JIpHXpZh15j6uf54OZ0ZaYctdkQNVT6WZHwFCP1LiZwKNzvnBVF+8tjbMrEc88y5AQ
         miDd3UrB7aKm6rDb7mO19hDBDXrpnwDSwdGMSDeRpxlVbgFdf0FL/pk21CFdgHsY17fk
         xOby98ybU65IY5qMB4KNYVwds9cwYmD4q7ZK//AQy0FB5CFh6vn7EQaSUMrJQ3+Udn2X
         3IOs1361+GsLreppwlLNHbaEXuSQdoKa2eJKSayOgkDmRixQYALgeX0rhdNZ878UQJ2l
         9G0ZWePa4mdDWeXl3I863UtIrJQGwgKGjhg1IUnlN6vpzrn7PCISfSaJF9RVEfVdDu+a
         AXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TMDMECxtDyrKw7UR9Mx7zsMc3I+ujgCjjWQyhNCKNAU=;
        b=CbLPeiZ51L5Tbdh/AWkHZ7ZP2RurCufbVYAS0Ym08kjifyfPEOc1UasmO5Ijz8zLcc
         +Tule4ebPWyy5KBsRKIKKzFDcZCmDYc8Z461NvWIaUAnrutU4ZaytREWfO7VhukfaOY+
         hU1WlabcPt2g53ay56GzrjE/jAnotTUCfvmMuHL3KxEjuDEGakclhax2zsWC3XAHhFG3
         Bp9YROBRGk2xq8H0OiijWgc8s7twW6naMiK0KqPtPslI29jLtBI3F/qzMt6VSJwMbvAi
         kJjWpxzm+4VzjU1SfRBQVZvgRyOWmpV33OuJRDlvs6tOJ5HKpzgORd5O2NkVb0K6/Dqs
         KFkg==
X-Gm-Message-State: AOAM530ws0s5CeFbQ/7okqK+oYYwwT2kI5OiHNJgisLvkeVOEmMS6Qbr
        ATt/gn0J8TEx/5ZOZH1nTNy/ackvSqbflUbdMuo=
X-Google-Smtp-Source: ABdhPJxFENU0n/CIub2ELxobC9S6sSTeFivCPAONBxIvjJt9i55UJif8lUyl0SU+Y60it3IJHnYrMzgihE2p4fr35D0=
X-Received: by 2002:a2e:974a:: with SMTP id f10mr128843ljj.283.1592514135166;
 Thu, 18 Jun 2020 14:02:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-OoyU5OHQuqpTEo-uAQcwcLpzkXezFY6Re-Hv6jGM9aSFSA@mail.gmail.com>
 <20200618195956.73967-1-zenczykowski@gmail.com>
In-Reply-To: <20200618195956.73967-1-zenczykowski@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 18 Jun 2020 14:02:03 -0700
Message-ID: <CAADnVQ+BqPeVqbgojN+nhYTE0nDcGF2-TfaeqyfPLOF-+DLn5Q@mail.gmail.com>
Subject: Re: [PATCH] restore behaviour of CAP_SYS_ADMIN allowing the loading
 of net bpf program
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 1:00 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> This is a 5.8-rc1 regression.

Please add full explanation here.

Also use [PATCH bpf] in the subject for future submission.

> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")

Reported-by: John
is missing?

> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> ---
>  kernel/bpf/syscall.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 8da159936bab..7d946435587d 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2121,7 +2121,7 @@ static int bpf_prog_load(union bpf_attr *attr, unio=
n bpf_attr __user *uattr)
>             !bpf_capable())
>                 return -EPERM;
>
> -       if (is_net_admin_prog_type(type) && !capable(CAP_NET_ADMIN))
> +       if (is_net_admin_prog_type(type) && !capable(CAP_NET_ADMIN) && !c=
apable(CAP_SYS_ADMIN))
>                 return -EPERM;
>         if (is_perfmon_prog_type(type) && !perfmon_capable())
>                 return -EPERM;
> --
> 2.27.0.290.gba653c62da-goog
>
