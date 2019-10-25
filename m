Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFC2E4208
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 05:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391987AbfJYDUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 23:20:09 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40491 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731941AbfJYDUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 23:20:09 -0400
Received: by mail-qt1-f195.google.com with SMTP id o49so1194591qta.7;
        Thu, 24 Oct 2019 20:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TXoMu70Skd+AjU0XvxD9gZV0D2TDPPVNchRF+onkavU=;
        b=oJ1CkIhGxUtW/fUs7P9kgo+4Me2erAFSX59kTV0sLQ6b8fK1SCYt85Af4vYpm9lmwl
         zALVByfZNlmdRuJ1fLSkyBF2XXHVISbcCoV9ecoJXu9LOLxGu+vZthckihmRx3zJzdRM
         /GtqphhI+K3WS5RDmu5W/s+XuL5cFqNV0anV/ixRm+agh9G+a1hYclUD45KxMXDwdxeP
         mGnWhibB6Yuhm7KSu2hSDmxWOY6Ina+nE4WuRdu7hqhL9ph4T46Q377mvQskJZUeYRN0
         0luq5nPHmaZCOEyuK6KViDnDj+sdq4yVHzwd1WwVMY9y5nu1P2irWVYQR/KmgWwpuJmC
         RIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TXoMu70Skd+AjU0XvxD9gZV0D2TDPPVNchRF+onkavU=;
        b=HLR9neT4D8N+9lW+ven/HCecvk2BsRLltNN27ogNiZfr5jsWbdnfXBVu3vHJz1K+Yn
         jHFnZnmZTUtR6kE+EDz6cZLn7t1RtJeIKzVqjKDh+4hHU9mBHmFru9s+LxrePWc+4Jsw
         qq3N6CX503uLrhjzaXfnIF490mv/ztknyJzGbD3l4GCiJc7k9wJmR1sFdR9dyFaGDXpw
         8L1XGNbVEaPfckiGzPvyHvC4fWxhZeR7L+VWFrS7kTLaKUb8ITxF+Xv9gBqALyNNdEuz
         Qj2aZwC6izEvP7vXu7eY5lDrhViBeKh7tRNasaCoYxF0w9KFYkWVhm9f/nM7wGXozu2A
         Fs0g==
X-Gm-Message-State: APjAAAVnF/VuhGnff3oYUEgQCjpySXr3I9sYi8gmyVTYItrm0tN4Wiej
        /7ajcv8W6x0wxsBXsCLDa6uaqFunRKIuQv1WIgA=
X-Google-Smtp-Source: APXvYqzSvHf+kdIRRSJY+Ggp0N0kupP7Hc+WUthE6IlMm9g4aSDtMz8IrDDFWj6k/y/gTUqlb7+Z8V9MSTFGrI1TF1Y=
X-Received: by 2002:a05:6214:16c5:: with SMTP id d5mr1145417qvz.247.1571973607706;
 Thu, 24 Oct 2019 20:20:07 -0700 (PDT)
MIME-Version: 1.0
References: <157192269744.234778.11792009511322809519.stgit@toke.dk> <157192270077.234778.5965993521171571751.stgit@toke.dk>
In-Reply-To: <157192270077.234778.5965993521171571751.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Oct 2019 20:19:56 -0700
Message-ID: <CAEf4BzYeMBYDx6TXAqdkpWpW43yKWNbGaA+67LV1zPao-u779A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/4] libbpf: Support configurable pinning of
 maps from BTF annotations
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

On Thu, Oct 24, 2019 at 6:11 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds support to libbpf for setting map pinning information as part o=
f
> the BTF map declaration. We introduce a version new
> bpf_object__map_pin_opts() function to pin maps based on this setting, as
> well as a getter and setter function for the pin information that callers
> can use after map load.
>
> The pinning type currently only supports a single PIN_BY_NAME mode, where
> each map will be pinned by its name in a path that can be overridden, but
> defaults to /sys/fs/bpf.
>
> The pinning options supports a 'pin_all' setting, which corresponds to th=
e
> old bpf_object__map_pin() function with an explicit path. In addition, th=
e
> function now defaults to just skipping over maps that are already
> pinned (since the previous commit started recording this in struct
> bpf_map). This behaviour can be turned off with the 'no_skip_pinned' opti=
on.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

I think you are overcomplicating this... Here's how I think we can
satisfy both simplicity goals, as well as good usability:

1. add `const char *pin_root_path` to bpf_object_open_opts. This
pinning path override doesn't need to leave in some separate set of
options, it's BPF object's parameter, so let's put it into open
settings.

2. If BTF-defined map definition has pinning set to PIN_BY_NAME, that
means bpf_object__load should do auto-pinning. If not, no
auto-pinning, only if manually requested by explicit bpf_map__pin.
Further, if someone wants to auto-pin map to a custom location, do
bpf_map__set_pin_path() before bpf_object__load(), and load should
auto-pin it as well.

3. bpf_map__get_pinning/bpf_map__set_pinning are unnecessary, at least
for now. Let's not add unnecessary APIs.

4. pin_all/skip_pinned seems unnecessary. What scenarios are you
solving with them? Given #1 and #4, just drop
bpf_object__pin_maps_opts().

The way I see it, libbpf should behave sanely for declarative use
case, but allow custom tuning programmatically. If map is set to
PIN_BY_NAME in map definition - we derive pin_path (potentially taking
into account custom pin root path from open opts) and auto-pin on load
(unless application set pin_path manually). In a weird case, where map
is declaratively defined as auto-pinnable, but application for
whatever reason decides not to do it - it can unset pin_path with
bpf_map__set_pin_path(NULL).

Full control, but simple and intuitive default behavior? Does it make sense=
?


>  tools/lib/bpf/bpf_helpers.h |    6 ++
>  tools/lib/bpf/libbpf.c      |  134 ++++++++++++++++++++++++++++++++++---=
------
>  tools/lib/bpf/libbpf.h      |   26 ++++++++
>  tools/lib/bpf/libbpf.map    |    3 +
>  4 files changed, 142 insertions(+), 27 deletions(-)
>
