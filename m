Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7883C7AB6
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 02:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbhGNAy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 20:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237113AbhGNAyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 20:54:55 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF46C0613DD;
        Tue, 13 Jul 2021 17:52:04 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id h6so29587922iok.6;
        Tue, 13 Jul 2021 17:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=icgf3yqZNru0Ph46l7DfzCfI9W0m9sMz9X1UBv2Jl7o=;
        b=mD8D9VKlOscgp9QrdFgUYcQwrq3Nr+s9LRFmS1KUEQ6s333ojouJ/dUmmDbnag8k4h
         GGS8XE2G2DyUrRVt8MpzBKL/OrUXtE73NIDGRNMCTT72mbEdIXsLN1GfaWSZivFUINSh
         DTsnoBQmpKbp4GoqxhSsAVofzI2Y9NKlE2RZqxyY+nTJb+aa0SELVaFtBY+KX4ScmHpb
         4tpZqUF525i4ew4DVx0l9V/W3xEvwzz2mFiRcLpqiXWDa1P2BueXKJz18zzpIgnGl1GY
         dIQvVwSjSAWA1nPPZMiywc5OOstNh45OIJw1bhiLHgU0h4t03SUddqLEFHQSUL77qjz/
         RfOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=icgf3yqZNru0Ph46l7DfzCfI9W0m9sMz9X1UBv2Jl7o=;
        b=Zz/VJ7MS06UR04Et4jMgjmgZ0A8YhMfW9Ei/xt+N6Z7b2O8+4kDi6W5tb4nXcIz6H/
         mrv4u9ByBLnTA5pRX8XYzMwhNBUhHwwic6Tj6tbVNk3IaZvObhjDAa213/eLSUqZ00dO
         qia/5sS0G8Bvqg8IDZbytXGCXE5UH8dwa/fSGpPDKtvHX2T1Gs9tnGz6zrFj89+fhlni
         ccMwp8urxwsLVQRcFsVpvWWbez0vpS9TcRX9T0zntO6yTOuagPwyisk7lvZyd3kxDsNQ
         JyJBt6HxvIpnSdXyRIekDytsEnMArieBTVP7AyxnzTsIAFGF5qnDcG3CFIzJ13ka5TF4
         S0Hw==
X-Gm-Message-State: AOAM533UXGAWX7rCoPq+rgWNwuSUz93zQtGoQpK9KptFYsAN/B7TtA5X
        FxXPTmwfyE9aHV0H7u44gDE+3G/ovTm2AnLbeXE=
X-Google-Smtp-Source: ABdhPJycjZqEHZYZzTbFxF623OsQYXJxQJjI+wupqu1Mw4Q4un3pDXcJZG0I6aPjNJrYu3JIlYlh5WnZ4mLgJG5x1kU=
X-Received: by 2002:a05:6638:1204:: with SMTP id n4mr6421242jas.135.1626223923467;
 Tue, 13 Jul 2021 17:52:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210713074401.475209-1-jakub@cloudflare.com>
In-Reply-To: <20210713074401.475209-1-jakub@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 13 Jul 2021 17:51:52 -0700
Message-ID: <CAM_iQpVV1XRTsbyEbG_GTb4GHHx47m+TOYYw_z3euX3UYvDt9Q@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf, sockmap, udp: sk_prot needs inuse_idx set for
 proc stats
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 12:44 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Proc socket stats use sk_prot->inuse_idx value to record inuse sock stats.
> We currently do not set this correctly from sockmap side. The result is
> reading sock stats '/proc/net/sockstat' gives incorrect values. The
> socket counter is incremented correctly, but because we don't set the
> counter correctly when we replace sk_prot we may omit the decrement.
>
> To get the correct inuse_idx value move the core_initcall that initializes
> the udp proto handlers to late_initcall. This way it is initialized after
> UDP has the chance to assign the inuse_idx value from the register protocol
> handler.

Interesting. What about IPv6 module? Based on my understanding, it should
always be loaded before we can trigger udp_bpf_check_v6_needs_rebuild().
If so, your patch is complete.

>
> Fixes: 5e21bb4e8125 ("bpf, test: fix NULL pointer dereference on invalid expected_attach_type")

Should be commit edc6741cc66059532ba621928e3f1b02a53a2f39
(bpf: Add sockmap hooks for UDP sockets), right?

Thanks.
