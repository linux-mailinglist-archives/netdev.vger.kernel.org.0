Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 343A918E40B
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 20:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgCUTlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 15:41:06 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39263 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727573AbgCUTlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 15:41:05 -0400
Received: by mail-qk1-f193.google.com with SMTP id b62so1635021qkf.6;
        Sat, 21 Mar 2020 12:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L6YfcU5ciYiVu9dVxdXUXzsZPZvcMDslIUHUIQLiIJM=;
        b=kFe/VmiMS1X5q6jbvhGEXTmiwIwdXjtkSuWV9Jk21f3KTrX4K32Bb+oLXn0a0V0+5q
         un0rdMhKRKvJd3M7Xv1ha3/OJJUoVAPTjibmF5ZP5fDTFjh7FHzPX7mcXo4r5Yu4+lLW
         diJeFSzmDmaxqpVr0KM0sPiaPPP2DzNxLSWsofvfvK61Jiys4fatxbeULlG9x/i88GEF
         UifC9VfedbyqQLQYgR52Sn122KC85RGSer8T+hX+U0Y9CSdEKxqTIBHxkbQT79wLOBOA
         y+AP1p550F8uYRp2eUlFT4t1//1Sy+XRyBmCaH+H+auPxthUkrprS77iyxrZGcOiymw+
         6BvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L6YfcU5ciYiVu9dVxdXUXzsZPZvcMDslIUHUIQLiIJM=;
        b=J/asvO7nbqiuDGtdmozuL8FVDhrUgNppl6sA2za7825NY4/ncWHfy0+MrMrVb8Pl3u
         MXgSRTnYvQ3HubxXyoTYTWyRIiwMNKD3uD3oZ5bAxbCFJAiOhAGaxNTYkGknRlHNp/K3
         YANDMDQU9ZjLGpJQJvbGCTtHHi4KjJHD8efFGvbkBRTNb4LbMaFNTXG8v2os/qAzfEKM
         OaZrrPEVp2PaSoKUYNXLM1XHb2VJ4YzwtxFNKPfw41/Hqo5xcYGPMOLD46CzOFmW+rE+
         mn7vVTvnmbQnRYhBNXIWqMZwWLMcpqNLBkHhx5XKFLP9Sy2rD+6QeWPMwL8o6JQugFFi
         Dp0Q==
X-Gm-Message-State: ANhLgQ0kExkOa0g+CtS/WWqkq12yg/lrD+MQQ0z/2HdGLQEmFbJh9Yp3
        vpveDSuurrdR9cWsc7KJpVBLYSqomSAs6vGrDzV1hA==
X-Google-Smtp-Source: ADFU+vsT8PuBCSkIqzr9o/1m72QPPpyLOoTl31Qf7msFlf1wYybvOvtKh+Eez/wXI7e8kwjK0/XZtXKgwynzzwKSjDM=
X-Received: by 2002:a37:6411:: with SMTP id y17mr14556052qkb.437.1584819663923;
 Sat, 21 Mar 2020 12:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200321100424.1593964-1-danieltimlee@gmail.com> <20200321100424.1593964-2-danieltimlee@gmail.com>
In-Reply-To: <20200321100424.1593964-2-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 21 Mar 2020 12:40:53 -0700
Message-ID: <CAEf4BzZZgpwVNMEnH72-dQXL+W9ROKSdX2+pmExhgXAGSjT02A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/2] samples: bpf: move read_trace_pipe to trace_helpers
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 3:04 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> To reduce the reliance of trace samples (trace*_user) on bpf_load,
> move read_trace_pipe to trace_helpers. By moving this bpf_loader helper
> elsewhere, trace functions can be easily migrated to libbbpf.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/Makefile                        |  4 ++--
>  samples/bpf/bpf_load.c                      | 20 ------------------
>  samples/bpf/bpf_load.h                      |  1 -
>  samples/bpf/tracex1_user.c                  |  1 +
>  samples/bpf/tracex5_user.c                  |  1 +
>  tools/testing/selftests/bpf/trace_helpers.c | 23 +++++++++++++++++++++
>  tools/testing/selftests/bpf/trace_helpers.h |  1 +
>  7 files changed, 28 insertions(+), 23 deletions(-)
>

[...]
