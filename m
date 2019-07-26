Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DDA75C68
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 03:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfGZBGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 21:06:17 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38988 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfGZBGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 21:06:17 -0400
Received: by mail-lj1-f196.google.com with SMTP id v18so49747084ljh.6;
        Thu, 25 Jul 2019 18:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jIMMWKYdalrCoGI5IqDUkHcz1U7npaq3PjgjWvZIBBk=;
        b=uaa0o86r/62Jwekx+q7n7RfrdVyOAISDGtZP3BRnOOGUDFaEkoEOePmEhabQE/kLww
         uO7idLyHfhCi8VDuGFaz3elwpnLYO4KiTgv3RsFY2yPM9XceOQC8dzvKYNdVU3t8Oigw
         1TD6bZTVehBg7vmVCYxfJH35pckCk1svGDVZD2BYpu7qvFnNe+TAoFdbjVr11pgQY3PN
         l2uABhYF0bsh/gk45rS/VBBhskj30ns/4/vFvy3p2Hr6MI4LZL+N4UOv5gk1feO+jcaW
         +bn6K1fC58l+WokLAIDSJt4aKvfFLQI3TlbH3JKVpctgs3XGqHWrToN13Zn2GwRQAqul
         edXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jIMMWKYdalrCoGI5IqDUkHcz1U7npaq3PjgjWvZIBBk=;
        b=DQayZyRpORmEgMUPWCZTFuWZkD0EAd9Hmo+4c9VDhkcehywPHomRIlbW8ifaT/xg0h
         xcZbqixP2wRO0wPKwBzrwfPfXgJ1u7g5FTw+KL6nRbPTPHQopzNsPHuGwGpesV5/mrL/
         vFTPSY6YYOsoJaR3xFlhWA0rAVki2BwZ7sG3VvW7zFd7WVGQZz/NcGUh9I+3gLCg6eSa
         EExtp+MwUk+getVTM0WiRe3qc+qNCn3XMN1KK3R6WwY6z/uxNBKVFkmv9/Dw0MJQ2JcC
         v79/852bNYZzg7YGpPlKLtH0ELmN3UqVZyhyx3mkf4PquQ9szg0ZcBUowad3OUofvJcU
         xbvw==
X-Gm-Message-State: APjAAAXFp2eYY4MPGfGGYMzNyKUMDEtJXmrgk0C6gn0PqsYjjIS2lXcz
        SNf5YY0JXMdOIrb0ReXhhGlBud9EMsUmB6Xe8uE=
X-Google-Smtp-Source: APXvYqyfU5LFaC9phrLnRdauiWeYv5h4VbHv/lIMC6B2WhBWdv4epY3pnwgE9iL/OMIS0Y8NMARVpHrI2HvglvkkUCA=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr46996040ljj.17.1564103174717;
 Thu, 25 Jul 2019 18:06:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190725225231.195090-1-sdf@google.com>
In-Reply-To: <20190725225231.195090-1-sdf@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 25 Jul 2019 18:06:03 -0700
Message-ID: <CAADnVQJDcWQp9ZJ5GTaKez3FjAUTPUPHWuJ7-dnnb9qm88He+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 0/7] bpf/flow_dissector: support input flags
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 3:52 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> C flow dissector supports input flags that tell it to customize parsing
> by either stopping early or trying to parse as deep as possible.
> BPF flow dissector always parses as deep as possible which is sub-optimal.
> Pass input flags to the BPF flow dissector as well so it can make the same
> decisions.
>
> Series outline:
> * remove unused FLOW_DISSECTOR_F_STOP_AT_L3 flag
> * export FLOW_DISSECTOR_F_XXX flags as uapi and pass them to BPF
>   flow dissector
> * add documentation for the export flags
> * support input flags in BPF_PROG_TEST_RUN via ctx_{in,out}
> * sync uapi to tools
> * support FLOW_DISSECTOR_F_PARSE_1ST_FRAG in selftest
> * support FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL in kernel and selftest
> * support FLOW_DISSECTOR_F_STOP_AT_ENCAP in selftest
>
> Pros:
> * makes BPF flow dissector faster by avoiding burning extra cycles
> * existing BPF progs continue to work by ignoring the flags and always
>   parsing as deep as possible
>
> Cons:
> * new UAPI which we need to support (OTOH, if we need to deprecate some
>   flags, we can just stop setting them upon calling BPF programs)
>
> Some numbers (with .repeat = 4000000 in test_flow_dissector):
>         test_flow_dissector:PASS:ipv4-frag 35 nsec
>         test_flow_dissector:PASS:ipv4-frag 35 nsec
>         test_flow_dissector:PASS:ipv4-no-frag 32 nsec
>         test_flow_dissector:PASS:ipv4-no-frag 32 nsec
>
>         test_flow_dissector:PASS:ipv6-frag 39 nsec
>         test_flow_dissector:PASS:ipv6-frag 39 nsec
>         test_flow_dissector:PASS:ipv6-no-frag 36 nsec
>         test_flow_dissector:PASS:ipv6-no-frag 36 nsec
>
>         test_flow_dissector:PASS:ipv6-flow-label 36 nsec
>         test_flow_dissector:PASS:ipv6-flow-label 36 nsec
>         test_flow_dissector:PASS:ipv6-no-flow-label 33 nsec
>         test_flow_dissector:PASS:ipv6-no-flow-label 33 nsec
>
>         test_flow_dissector:PASS:ipip-encap 38 nsec
>         test_flow_dissector:PASS:ipip-encap 38 nsec
>         test_flow_dissector:PASS:ipip-no-encap 32 nsec
>         test_flow_dissector:PASS:ipip-no-encap 32 nsec
>
> The improvement is around 10%, but it's in a tight cache-hot
> BPF_PROG_TEST_RUN loop.

Applied. Thanks
