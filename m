Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE284434402
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 06:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbhJTD6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 23:58:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhJTD6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 23:58:39 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCC64C06161C;
        Tue, 19 Oct 2021 20:56:25 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id q19so1782790pfl.4;
        Tue, 19 Oct 2021 20:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=op8GyiwFUTxPnKC1m15ZOngYa5VFL0Iokc2X0Lz1nP0=;
        b=EV3be/r3HVgCAuBfXGLAtOI96m941/bbUXolfVDmgyEeVVDASLJQhz5G4gEee2Q7hd
         7fBLe652ngvwaNfhdgdqSf6qusaRFMaZ4duRHhWKL4+K/FjAhvfWWGLPINeAvrAP+eY2
         yhUIxLOh5o+qIzpPJyRYgtSx6ufygLVoMXzuj344roaA3vy/l4n9B2mU5HEdZZXXWCvv
         9V/RBRc5KWOmWdtEO1OGnQIFmi8Cinjp39MRyvFWIx1CtmQoL8kq2yV8zHSZcpY2LBkm
         F1P5mPbDogWxmwg2SDR7zZGm6WciOxawqFgs2rnDEdn9Tssc4kPLFfDEH9JdYOCywo8R
         Ds3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=op8GyiwFUTxPnKC1m15ZOngYa5VFL0Iokc2X0Lz1nP0=;
        b=WWlRL2QQEAM/XyDTOeSSF36eJ5fAFIsmq3x16E+1T5Mnb+JN7mDF6NBdYoF/CsDmWu
         ynpNgtvN+Wv25VzWOhOPYwAmusRXsSdI3yOHIojSdVrDAOdqwBvqN7kDZWF9VVKimq3+
         xwnF00GW9SuR0CKWJnO+iF/pZ4o70TWwO9z+daUX93w/nuFhpAO6qUz+JOJ4eeUp06o7
         tKc8ogC250LZm2s4tA4yu7F/CCWZqSnai47WUthZIs9J3OtLq6CfrSA+OqHooOdCf9GQ
         8RoJ8YlG1tjckvkz2/IsE0r3rYqCxffbQJj8c7LwSf6qCfMIJSHFI3ltGnjoFOruFdWj
         yO5w==
X-Gm-Message-State: AOAM533qqz9PyCHsnuZpmmfv0iNQW3CJ7DOM3+0i29cmnJLSKykxI9qa
        1c1euVpoBdWU5vMaVhrjlAA=
X-Google-Smtp-Source: ABdhPJyNCnv4KtyFLVXCjzMAnfjJXKa64BYZ+97B9exFKEbWFf+hp/Zg63C0I4IMLkGauejAMj6WYg==
X-Received: by 2002:a63:b006:: with SMTP id h6mr24101108pgf.366.1634702185232;
        Tue, 19 Oct 2021 20:56:25 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id mq3sm2125712pjb.33.2021.10.19.20.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Oct 2021 20:56:24 -0700 (PDT)
Date:   Wed, 20 Oct 2021 09:26:22 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 07/10] bpf: Add helpers to query conntrack info
Message-ID: <20211020035622.lgrxnrwfeak2e75a@apollo.localdomain>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-8-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019144655.3483197-8-maximmi@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 08:16:52PM IST, Maxim Mikityanskiy wrote:
> The new helpers (bpf_ct_lookup_tcp and bpf_ct_lookup_udp) allow to query
> connection tracking information of TCP and UDP connections based on
> source and destination IP address and port. The helper returns a pointer
> to struct nf_conn (if the conntrack entry was found), which needs to be
> released with bpf_ct_release.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

The last discussion on this [0] suggested that stable BPF helpers for conntrack
were not desired, hence the recent series [1] to extend kfunc support to modules
and base the conntrack work on top of it, which I'm working on now (supporting
both CT lookup and insert).

[0]: https://lore.kernel.org/bpf/CAADnVQJTJzxzig=1vvAUMXELUoOwm2vXq0ahP4mfhBWGsCm9QA@mail.gmail.com
[1]: https://lore.kernel.org/bpf/CAADnVQKDPG+U-NwoAeNSU5Ef9ZYhhGcgL4wBkFoP-E9h8-XZhw@mail.gmail.com

--
Kartikeya
