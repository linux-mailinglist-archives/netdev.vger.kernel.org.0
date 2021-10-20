Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CBB435278
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhJTSQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbhJTSQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:16:41 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FC4C061755;
        Wed, 20 Oct 2021 11:14:26 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id o134so12401334ybc.2;
        Wed, 20 Oct 2021 11:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1uAuokvXAbmeDYnFOBcpg3SXbMkS3XLhbWYOJ/jeY0w=;
        b=pZNqne4TE8IpF/3sb8Ue++kABh+8oZFGLJF96rxCfggUtdwS8NFaIiMnhEq4vFL5M1
         6+EjMpT7wNQ2RFB0Slrya+wr5VOQYg6hKCVnm9zWKAGBtv4/+eky/WPPZ+3EccwXzRtG
         dK8vm77R3aOr3GcSszCu7CJqAaCgDHGqN82xFzBC9rrQ9+p5HWSfv+DNsi6AbGK/CKYW
         rH023GveKv8P1cY45XgllZvH8ZVoyMOc+/ZI8bo1jH//xSw4XdoZbz0oNBPgIUAbJB/g
         R4HzjgStm8zrExyG8kCE6YBAns/KFpJVcB0VOIkcA81SWUrwykk2V4WuxyPGdUnhMWM/
         fppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1uAuokvXAbmeDYnFOBcpg3SXbMkS3XLhbWYOJ/jeY0w=;
        b=Auowcri7shG3wTzwurhTv2AG9vqPrXPwmYbXo84EhdlI9fV0qm9gc1o2FSgATnGnOG
         RK78vMbEo1OBeJ4x9taLTtBppf9kRqaGEbU+Y047DVkS6dxmRhnaJHIVKJfiuQZxKJHq
         2nWlxj+qxRtmCnL/OEs8r/IKAXIoV1TVloFouRt2qQ8LAph4j8WcDORc83ZxH7/0EZmw
         FDA0vZR1KdzdVd4T9bpxq80eHckYsA6fIvSI/H7j/mt2btk2Rh1o8D0bIDIaWrVwqxJQ
         azi7546o0tybKrjXlSBAGkEZZp2sGkM/3nBStc8k8WitcEflTiy+jwxYM+HXD7hP72Ru
         5xew==
X-Gm-Message-State: AOAM533IM/CiTf50+c3jhWtyTyzfwy2xlGvPJrK/3KjRXVqbDPISpLhe
        mW5B3gRqGRvxgHMcNqpjxOZWJHhPjJ2t2KbM/ELwr5WWSmU=
X-Google-Smtp-Source: ABdhPJw03BYRqfPyxjEDkqkMAr5s7kH9jG9hBUg/T/bx9lsulPoOiVEeOakjgHmhIVQ6l/AStIjFy9xoiEUrOIEIJ2Q=
X-Received: by 2002:a05:6902:154d:: with SMTP id r13mr799135ybu.114.1634753664662;
 Wed, 20 Oct 2021 11:14:24 -0700 (PDT)
MIME-Version: 1.0
References: <20211012161544.660286-1-sdf@google.com>
In-Reply-To: <20211012161544.660286-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 11:14:13 -0700
Message-ID: <CAEf4BzZ0-BeNmd9AuyLF1QZvmH4xNjAXPC2TsUN++D2WkuN5UQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/3] libbpf: use func name when pinning
 programs with LIBBPF_STRICT_SEC_NAME
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 9:15 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Commit 15669e1dcd75 ("selftests/bpf: Normalize all the rest SEC() uses")
> broke flow dissector tests. With the strict section names, bpftool isn't
> able to pin all programs of the objects (all section names are the
> same now). To bring it back to life let's do the following:
>
> - teach libbpf to pin by func name with LIBBPF_STRICT_SEC_NAME
> - enable strict mode in bpftool (breaking cli change)
> - fix custom flow_dissector loader to use strict mode
> - fix flow_dissector tests to use new pin names (func vs sec)
>
> v2:
> - add github issue (Andrii Nakryiko)
> - remove sec_name from bpf_program.pin_name comment (Andrii Nakryiko)
> - clarify program pinning in LIBBPF_STRICT_SEC_NAME (Andrii Nakryiko)

I could not find this, can you please point me to where this is
clarified/explained in your patches?

> - add cover letter (Andrii Nakryiko)
>
> Stanislav Fomichev (3):
>   libbpf: use func name when pinning programs with
>     LIBBPF_STRICT_SEC_NAME
>   bpftool: don't append / to the progtype
>   selftests/bpf: fix flow dissector tests
>
>  tools/bpf/bpftool/main.c                       |  4 ++++
>  tools/bpf/bpftool/prog.c                       | 15 +--------------
>  tools/lib/bpf/libbpf.c                         | 10 ++++++++--
>  .../selftests/bpf/flow_dissector_load.c        | 18 +++++++++++-------
>  .../selftests/bpf/flow_dissector_load.h        | 10 ++--------
>  .../selftests/bpf/test_flow_dissector.sh       | 10 +++++-----
>  6 files changed, 31 insertions(+), 36 deletions(-)
>
> --
> 2.33.0.882.g93a45727a2-goog
>
