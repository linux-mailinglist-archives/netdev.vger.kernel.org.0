Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA28319A0F
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 08:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhBLHAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 02:00:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhBLHAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 02:00:06 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26B9C061756;
        Thu, 11 Feb 2021 22:59:25 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o10so6275wmc.1;
        Thu, 11 Feb 2021 22:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qWjrK2qjy+Eam4wEkxiLxJ2hyHOwQ+enLr9C2gKFEms=;
        b=YyjUnQg5+15zlYa6wLuZx3Ltyc/29fnyMbeVyHRSEDn+zawck0u4xLLMnNntLlBkiT
         PULZGnSgtjcLpRjDLxIyHhryPCp4lT0GUws4C58XYU/DZiRjbtZ9pVt1WBnM6SHQUAFK
         +cMalAIYebSOF4y+J1JxDDgAZatrtCczpW3rpaRRBSBcAmn/4CdiX5B7EYIO6n91NQ/I
         mtWZXfPME8txqO3V0HSAtM4gxshZG+/TiyjatE694QTPb90FgBqomhwUvHH58dAPqkRo
         ux3bT7R1VRa9UqGpajFyfRdZ/gJ5OCZReqHVZTW4W8V7prSGFBJTg36xginqxOkiLFne
         qMjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qWjrK2qjy+Eam4wEkxiLxJ2hyHOwQ+enLr9C2gKFEms=;
        b=cfkhhxE13GeQNZOjxK2HqEO+ZVD9gEZxaZFXSh6CrWuGNqkAntbL5AzmAtmd2vQvFQ
         hIdqF5k2pPqx6QngHCQDvko2CLtsSwEShVxiYkjSMHwZvZDkmHlHWcFr9OlVtZ5dcjsy
         Ewo80jAZE67FFzT8X7ZkCLq03BO2ilw147XvTrn0o8a3327N4ddvxM3fd5xsURf/ngW2
         Z8f/sXtG6ZNfzixt7VIZHQvTnAUjMiR14SkoevS3WW0w63pv4/VplYzYJJB2dZUrCNKo
         hfUHnLyOPeTy/ekkgvUwQy7wxcDTHn55WEEzYRLfTXyTd85mZolAmfsp+nxhZjnJgakT
         Woig==
X-Gm-Message-State: AOAM530FiqZsHuphGrqIPJJZwN39I1LJXxoYhJWP1sr0sufIN3ASTb1K
        Xix5CzVeF0gdARnttpV3EF4o+lEmDPbaxshnoyc=
X-Google-Smtp-Source: ABdhPJy5rjUT9frAQwzqR4FrJaz1+56BlfidWQC5XLJE2EZcfjsW5vnIU4E0nW5DJJJ5BAVD6pEx2yHqnL7qzUe5Z7Y=
X-Received: by 2002:a7b:c150:: with SMTP id z16mr1330747wmi.30.1613113164428;
 Thu, 11 Feb 2021 22:59:24 -0800 (PST)
MIME-Version: 1.0
References: <20210209221826.922940-1-sdf@google.com>
In-Reply-To: <20210209221826.922940-1-sdf@google.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 12 Feb 2021 07:59:12 +0100
Message-ID: <CAJ+HfNhtZvvqj0pvEu0bysrwAvxngtC3z-2RUpP1HY3iU7gg5w@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: use AF_LOCAL instead of AF_INET in xsk.c
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 at 23:50, Stanislav Fomichev <sdf@google.com> wrote:
>
> We have the environments where usage of AF_INET is prohibited
> (cgroup/sock_create returns EPERM for AF_INET). Let's use
> AF_LOCAL instead of AF_INET, it should perfectly work with SIOCETHTOOL.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Stanislav, apologies for the delay!

Tested-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>


Bj=C3=B6rn

> ---
>  tools/lib/bpf/xsk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 20500fb1f17e..ffbb588724d8 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -517,7 +517,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
>         struct ifreq ifr =3D {};
>         int fd, err, ret;
>
> -       fd =3D socket(AF_INET, SOCK_DGRAM, 0);
> +       fd =3D socket(AF_LOCAL, SOCK_DGRAM, 0);
>         if (fd < 0)
>                 return -errno;
>
> --
> 2.30.0.478.g8a0d178c01-goog
>
