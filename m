Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8A71E735
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 05:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfEODmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 23:42:43 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43739 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbfEODmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 23:42:43 -0400
Received: by mail-lf1-f67.google.com with SMTP id u27so791535lfg.10;
        Tue, 14 May 2019 20:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FFidQgGHM8ZW3SzkzzPnIilrmplUNXp2TNPK2VNFwZ0=;
        b=rqOVpH/DqQ0WVS8oFdMiia8nP3Xb5hHdi0bAw82WrUSL+OLOuvDwc/7eU+jtk8bh14
         spIe9xAoHmwzG7XZR8vU7u0yUu9zl87s/jQeHuib/WnIZxE0bMxnLos6zjDW5pk24IWQ
         gFf2kNEwMMFfoD3y3Z25v4VISV8gcz66oINChePd+btX2xdSOaiyQ+Nplj+cjBNQjsQn
         STxdLVfT/tsuGtcNcszHBvnoZTtTbt5zvrXnR4OlW82a2vJa6I16TA8W6Fh2Ai1lK7Lj
         gp3fAqE262ZvVzb509M13bb+9bPxsBpnq2Fg1SAbB3ubDPjntI8Ls4VBR9hWBqkt9DVt
         3vNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FFidQgGHM8ZW3SzkzzPnIilrmplUNXp2TNPK2VNFwZ0=;
        b=lOI4w4X1ZgmTNvvs3SmiEKCbhvhLKFlDOU5wL1flUndhbSZEIRfLhH8hswqbP4yv63
         UOyg6WMu5i//LDeWv4tUc/z54xK8hoVpeL4LuIcjUOlvAA9Yp6mOcDvFnm/N2AyNi9S6
         vcTL1554jz1wymJCkrd39hsuNACmdkP8+BSBn/gP9mF3D42gYaumUySPmS1piWgo0p8z
         chTAm2rUIe27EAS7zFmIW7tRHJ1wCMSXa7pkRrlUcG9K2Ax0PyNV0jrMWI0nApa3NhC/
         DNPkfg7V0VFhLBAxBI+3FSx22yb9u4CnXLeH/mubqaRkdz0SvKBbrINEcs/vv15X8y6y
         p4XA==
X-Gm-Message-State: APjAAAWC4ZlahZV34g78BF2ApvT9DgKjDeyxmo7wXZGIoZxmeT00DDTB
        Od8OQeCrFAC5EgrNdMjCsI4k0A/Qj2G3TdSnwxE=
X-Google-Smtp-Source: APXvYqzKcbouNBTvd6P0ruJhjEHjDqPIEj4H+ugynANX0i7hBPN38y1F7AxT1S7CoL6I8Pw6jnJnNASJJxWX90J7aF4=
X-Received: by 2002:a19:480a:: with SMTP id v10mr7994654lfa.112.1557891761654;
 Tue, 14 May 2019 20:42:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190513185724.GB24057@mini-arch> <CAADnVQLX3EcbW=iVxjsjO38M3Lqw5TfCcZtmbnt1DJwDvp64dA@mail.gmail.com>
 <20190514173002.GB10244@mini-arch> <20190514174523.myybhjzfhmxdycgf@ast-mbp>
 <20190514175332.GC10244@mini-arch> <CAADnVQLAJ77XS8vfdnszHsw_KcmzrMDvPH0UxVXORN-wjc=rWQ@mail.gmail.com>
 <20190515021144.GD10244@mini-arch> <CAADnVQ+LPLfdfkv2otb6HRPeQiiDyr4ZO04B--vrXT_Tu=-9xQ@mail.gmail.com>
 <5ed25b81-fdd0-d707-f012-736fe6269a72@gmail.com> <20190515025636.GE10244@mini-arch>
 <20190515031643.blzxa3sgw42nelzd@ast-mbp.dhcp.thefacebook.com> <CAKH8qBuSM3a6j6xupaWOGqT3XM9rUzZRLujg_E_8WLjsd2t-DA@mail.gmail.com>
In-Reply-To: <CAKH8qBuSM3a6j6xupaWOGqT3XM9rUzZRLujg_E_8WLjsd2t-DA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 May 2019 20:42:29 -0700
Message-ID: <CAADnVQLnFr6hBM1BFTLY7FLDVR85-jQn4O9UtJLB0-a0WLjuiQ@mail.gmail.com>
Subject: Re: [PATCH bpf 0/4] bpf: remove __rcu annotations from bpf_prog_array
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 14, 2019 at 8:38 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Take a look at the patches 2-4 in the current series where I convert
> the callers.
>
> (Though, I'd rename xxx_dereference to xxx_rcu_dereference for clarity we
> get to a v2).

please make a fresh repost _after_ bpf-next opens.
