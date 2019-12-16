Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044D71215EC
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 19:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732124AbfLPSZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 13:25:20 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37084 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731626AbfLPSSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 13:18:11 -0500
Received: by mail-qt1-f195.google.com with SMTP id w47so6535631qtk.4;
        Mon, 16 Dec 2019 10:18:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aVIdbmjhSDvYURdJGBO4hrAy6vilyOLyBTa9JUkr1Bc=;
        b=uNc57GS+pK9ryCHUL2YKrn+2eyUx9v0c7/GcpGykHEXM+J7jI4N7aKP1ir2aZsQ7aM
         LSiq6oZuIg7lhCngpRn8W21ORm5YdRq2+0xqFkRQNcdOcbbRWwY6hmEjYVS1RkiekbsC
         Mb/OZYvL5bQ+SIj1ne/rPXGOf9AXs+mJle60CXaXMSoNWP30OdEZ89ZuKeWEhbi0Sljq
         3Gn6DGbSfI7YZ3Y89wFqDzpcS7724iu/jKYVs9FZeEZ+O4Sb9GwwqhztumFOCQ8MHErJ
         lonrSxOKVC7+vFGho2O2PmrnJOliDA8RrKiY/bSe5amUGPBBWWZCRl4q1lC3GrO12XP6
         tj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aVIdbmjhSDvYURdJGBO4hrAy6vilyOLyBTa9JUkr1Bc=;
        b=PDdnGxliwX/3QU9dwVEw9mFmb0V3Ii6sY/EQ0MWYSUzQ//rq9yOKZrmMNRDE6v0o+T
         WIxGuNFYSTu+8RWFgSSDnKf4J6rrg5IEIp5ZMCtiaztcaaQ+6Tvn3FZIjSLc9fBcX1KB
         4M0przYAfPxtrr2FB883OUsm5YeTCTazpeb+7DdFeEbsJo28fdePr49qN/aIfjUElt6q
         kLllPpvfSPzQCyWqCKuLXNVWsdcKMG/wxRchogQYt9CyzEeH8nCe1bekPZwP2WN4BDZH
         hRgzBPyj6IVcvmyrCX/m0phaE8t5AR4S7QVBibK3mxs07Kzi+zgifW4w0sjd9z0LWO3C
         pl/Q==
X-Gm-Message-State: APjAAAXu2WBkr6v2dGrVMMvKAdBGSKTy0RyOE0LaWJZ63Y+K5HQzgaAk
        22IG15s4zBPq3m745WepsQo/7I4rB94D0EYKidM=
X-Google-Smtp-Source: APXvYqwNnMS/sGLMh1yvh3HaMoQe/JLQ94GhBaO27PGikqE7HgtGlM57avSLnco+xhHngt1Qye1+dTrwQFBq7nXFma4=
X-Received: by 2002:ac8:2310:: with SMTP id a16mr621495qta.46.1576520290280;
 Mon, 16 Dec 2019 10:18:10 -0800 (PST)
MIME-Version: 1.0
References: <20191216152715.711308-1-toke@redhat.com>
In-Reply-To: <20191216152715.711308-1-toke@redhat.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 16 Dec 2019 19:17:59 +0100
Message-ID: <CAJ+HfNhYG_hzuFzX5sAH7ReotLtZWTP_9D2jA_iVMg+jUtXXCw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] xdp: Add tracepoint on XDP program return
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ido Schimmel <idosch@idosch.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 at 16:28, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> This adds a new tracepoint, xdp_prog_return, which is triggered at every
> XDP program return. This was first discussed back in August[0] as a way t=
o
> hook XDP into the kernel drop_monitor framework, to have a one-stop place
> to find all packet drops in the system.
>
> Because trace/events/xdp.h includes filter.h, some ifdef guarding is need=
ed
> to be able to use the tracepoint from bpf_prog_run_xdp(). If anyone has a=
ny
> ideas for how to improve on this, please to speak up. Sending this RFC
> because of this issue, and to get some feedback from Ido on whether this
> tracepoint has enough data for drop_monitor usage.
>

I get that it would be useful, but can it be solved with BPF tracing
(i.e. tracing BPF with BPF)? It would be neat not adding another
tracepoint in the fast-path...
