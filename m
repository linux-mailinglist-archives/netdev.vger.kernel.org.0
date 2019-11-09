Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D17BF5C76
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 01:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbfKIAoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 19:44:38 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:44290 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfKIAoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 19:44:37 -0500
Received: by mail-qt1-f195.google.com with SMTP id o11so8622186qtr.11;
        Fri, 08 Nov 2019 16:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Z9kVO/aI0vQCOguMnN3PqF5N+QLFFqD/sJOMV8589sA=;
        b=Q1eyHZXKUj2gI4YdlKteQ3Hwpnl+uDOF1DMg6KLUr7p71nK8PHkUTR9H4V7nvUEMzI
         2vg0KRIktP8XIPsyoQoO+PzZSg1MP1k46VhGRZnYelBpoIq2uYoET2Bzq1WpMeLmmc8f
         +nuK4p0x/L8+uXLp+vBFfUA8ezbVZgtPJjOmasK9nsd4dr5J+tXRCr/oLOF8wOcpeWd4
         KV8Qfu2eFZVc6E32rrLFgWmVn2HCCA2dBVxyZgEq8tRsfrdUmPJCE88zEfAA7wMbyO0s
         ydds18f3sR38FoUBYD+GguaoglLJi+9ObYeJLrfNtwrtboZZNPJEjcLo32fRbXP4REZS
         IEvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Z9kVO/aI0vQCOguMnN3PqF5N+QLFFqD/sJOMV8589sA=;
        b=kkARuqcDoy+9w28Ky4kVVWvasAINv9bNTPv+oF+V1Zu+r2kxyT30W92cZIVEmtiles
         VKZ/Piiba7LVFjOfQk/WfqxNbBeiDe4xte+rMbEkza2FEpImTTdWCD25k4rjeYmgwhYV
         CJ4pOlZoAvzV26lBUyaOBv8irLc97KWKlw8z8QVJrJM16zqmQ9NpUf0orFU73a2QwPzA
         3OX9AnjKFFZUfy/C90kSiDbsgKRJmS3Q4NEbEIFKgQuVXasbG7uNBx4yzE2KYzl+tRVS
         muesxpyMp5IUMBAt0KHX1gMM4DJ9SnfIYQ0RAzRjtLWGc6G9so7Ov6H5BBvDIF0pjZdc
         HWLA==
X-Gm-Message-State: APjAAAWnoXrhdtIADIH81HkyrlFyzjQkLh9wgM3bOeFWCM9TvyPDTQPK
        mITQmrufb4kYyOkrq7RJRhKEmfsMCq/DMyPvzoULRCzg
X-Google-Smtp-Source: APXvYqzX2a2HdcctkCayIFHJ2qylYLIcPsTZJiE0uupqgpcLs+O9j/JRPUQh/j2H1nEvIGOw8cQlyTLYYbXT84p0frE=
X-Received: by 2002:ac8:293a:: with SMTP id y55mr14310980qty.118.1573260275928;
 Fri, 08 Nov 2019 16:44:35 -0800 (PST)
MIME-Version: 1.0
References: <157325765467.27401.1930972466188738545.stgit@toke.dk> <157325765795.27401.949901357190446266.stgit@toke.dk>
In-Reply-To: <157325765795.27401.949901357190446266.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 16:44:24 -0800
Message-ID: <CAEf4Bza7OxXsc3Wh0Skw6PnoPaOKggBqxFn12g+Gi8CUvQBVqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/6] libbpf: Propagate EPERM to caller on
 program load
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 4:01 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> When loading an eBPF program, libbpf overrides the return code for EPERM
> errors instead of returning it to the caller. This makes it hard to figur=
e
> out what went wrong on load.
>
> In particular, EPERM is returned when the system rlimit is too low to loc=
k
> the memory required for the BPF program. Previously, this was somewhat
> obscured because the rlimit error would be hit on map creation (which doe=
s
> return it correctly). However, since maps can now be reused, object load
> can proceed all the way to loading programs without hitting the error;
> propagating it even in this case makes it possible for the caller to reac=
t
> appropriately (and, e.g., attempt to raise the rlimit before retrying).
>
> Acked-by: David S. Miller <davem@davemloft.net>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c |   27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
>

[...]
