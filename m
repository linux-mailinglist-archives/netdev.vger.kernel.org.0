Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD7AD68A4
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388576AbfJNRjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:39:20 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:36295 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388572AbfJNRjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:39:20 -0400
Received: by mail-vs1-f67.google.com with SMTP id v19so11353172vsv.3
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 10:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=posk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VoI9PYiBRc2yFBeGZP+9iAWIgLPpQStt5BRdIAs4Iwc=;
        b=LOGjB5VXo3K65wKJyF8xGk0utXSe6PctPDTy1imQpoNczyzCVwIUKJIdfQ5ummqL/N
         d24+K5y1+TJbQ5oPH5lAqfB3xSw7+8G/M/nlZm6Y5psvQ5YiIJIoozwjN7zZ8HTkUZE3
         IJL4+BCk4PcV/zracg933bx8evkNh9A72R193ZZ1g6/tjlaevqyDxf1KzYMceulE0e6q
         jHZIfkK/H+iG9KPKFltQBk5m0BH4lUAlq4LolrqAMVA7jL5UDaNuRl9+E3fjJ/8Vqh/i
         Fb3BlKMHr4ZJCrFRDk9knAd1DH4sjC4gUJNY7RcJ0YvgaCKtV02lqrz37MiHBo1BG9GV
         3bLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VoI9PYiBRc2yFBeGZP+9iAWIgLPpQStt5BRdIAs4Iwc=;
        b=TcWOh6zkrJLMELSzDUllCGq7WQiPKOnGN49DzQMEj6IYBlrC7JOjWlVt/tL56OD5SB
         B339k/IR160kNANgJB8AACHdyiBtY75JBw7JjP3Drw+vjs9b0iIYOMBYhKOiO4t1rmyX
         vRV9wj8XWFGL0gFVNVQdR3J4Lxf1Ns8Y86xiCf5b3HPHBHD3pGQqZ43/shE1NkGY5qt7
         w6gL4TPmo6KRu2veoouBWKTKaZeZcXMpQSCC8r8JwtpTKUZD27C/JYKcQENvmy9jNZl3
         WZFAXeY+dxzZC4YflOpQS4v0gnunLpIXNVXtU5hAUpxspk57X3HryjIFJAq7vJp92tLP
         vMJg==
X-Gm-Message-State: APjAAAXJs4AMlwp0T9RiBrB3XG8NOjoRXUgz9xdk74rw+kxl/Uyw8xD6
        7Wp7ojBR45vkHtsPIYphOzRlwaRE6AoYezFvWYuZng==
X-Google-Smtp-Source: APXvYqxR4c2e6CtVileO9JfPm9wtZCUMOfQPW71Qva6YMgX83vcteA/M78BLQ0lpjvUSz1wMDHe82YIdxfMVs5dmE5I=
X-Received: by 2002:a05:6102:1252:: with SMTP id p18mr6056039vsg.32.1571074757566;
 Mon, 14 Oct 2019 10:39:17 -0700 (PDT)
MIME-Version: 1.0
References: <111664d58fe4e9dd9c8014bb3d0b2dab93086a9e.1570609794.git.jbenc@redhat.com>
 <CAADnVQKgXnmbEhBd1FvM16RP_i8s7+risvgM9yftwuP2DejFmA@mail.gmail.com>
In-Reply-To: <CAADnVQKgXnmbEhBd1FvM16RP_i8s7+risvgM9yftwuP2DejFmA@mail.gmail.com>
From:   Peter Oskolkov <posk@posk.io>
Date:   Mon, 14 Oct 2019 10:39:06 -0700
Message-ID: <CAFTs51WM7yC3Z2HDGy9APSgqy1LCczQtFVG_y+X0WdxY9WSd9Q@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: lwtunnel: fix reroute supplying invalid dst
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 9:59 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Oct 9, 2019 at 1:31 AM Jiri Benc <jbenc@redhat.com> wrote:
> >
> > The dst in bpf_input() has lwtstate field set. As it is of the
> > LWTUNNEL_ENCAP_BPF type, lwtstate->data is struct bpf_lwt. When the bpf
> > program returns BPF_LWT_REROUTE, ip_route_input_noref is directly called on
> > this skb. This causes invalid memory access, as ip_route_input_slow calls
> > skb_tunnel_info(skb) that expects the dst->lwstate->data to be
> > struct ip_tunnel_info. This results to struct bpf_lwt being accessed as
> > struct ip_tunnel_info.
> >
> > Drop the dst before calling the IP route input functions (both for IPv4 and
> > IPv6).
> >
> > Reported by KASAN.
> >
> > Fixes: 3bd0b15281af ("bpf: add handling of BPF_LWT_REROUTE to lwt_bpf.c")
> > Cc: Peter Oskolkov <posk@google.com>
> > Signed-off-by: Jiri Benc <jbenc@redhat.com>
>
> Peter and other google folks,
> please review.

selftests/bpf/test_lwt_ip_encap.sh passes. Seems OK.

Acked-by: Peter Oskolkov <posk@google.com>
