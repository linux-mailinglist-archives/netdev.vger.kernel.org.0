Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5825CF25A4
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732847AbfKGCxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:53:23 -0500
Received: from mail-qk1-f175.google.com ([209.85.222.175]:34535 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbfKGCxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 21:53:23 -0500
Received: by mail-qk1-f175.google.com with SMTP id 205so728257qkk.1;
        Wed, 06 Nov 2019 18:53:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vhei/0hIV+r2EIrjJPfM8OxIAgRHb70cTFpkJHf6HEU=;
        b=d5Kea3e9BbO/xouo+kv/mii90J6TCppluIY6iJVrtqWOvRJZcmt0ecNM3w995aSU23
         buo9ppddUO77y+DwYeeFhoOdrvq3+DTQ9eP9jdrMQAPhane3p6yvCalH+RejUN97y44h
         msZ3s1del1gUrb4vVVxE/PcJxFiAhbmpGpe9ZzbiwKILSHxXR729IjpiCxMnfV6ye2sR
         jI02BG7dTCg+h5Iz54WQ5Y6IXaJaVvWZQ1Hx1nA9ax5DCYbv/nDQLFZtAQQ+nU0CTQcN
         MquV9xJT/w06FqXfJXRbsW1T+UrY1nUQipAyytBdX1AQCQbdftkfc/ZoeMNwkOr4bj3Z
         Lu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vhei/0hIV+r2EIrjJPfM8OxIAgRHb70cTFpkJHf6HEU=;
        b=NhKidkGp5zkjuzg9Z7i0esor1+EwjAlNDiit0ug1f2qYYR6uj+fq8uAMz3kzgfvm3D
         Qo0DVlPOiXWFH3xH0zbg4SHw+j5R7MCHQeIQ2MDm2tVRp+aOBzpkFQQjYF+5OHs9DRo2
         c4OeRTD7cppWyJQmIaAjauslLH6kLm8sV3ccpj/47zCs83mue7zN9nmSA36S2L0YaS9z
         9r8hTwLm54yX016W1pgcB0IiW/zJoQUwV/Edbl/RKY2IXyePJyuPSLryZL72tC/x/tIn
         z/6qMEiEvdrdJr23+ddVZK+X1TAPJ0t/jzeB7NXQlTxins4fF9WeZ113RD8nCCjcdZbK
         7PVg==
X-Gm-Message-State: APjAAAWZGkwH7xAbAZpUw0x9tPCc8eN5vLoLMtco89pIEp4nabuqE7jx
        avEHm8+w2UHPxZ9kKWRytS+fzE8C8vW670ToDAUq4Q==
X-Google-Smtp-Source: APXvYqyR7qNUzIzSaZanDJAt6/EIO+1NX5ZKS5dvyVo5VfAv89ydipBHrjVI5ojRtcXFHxqCrAUg+AwxbPq8zrkj4hQ=
X-Received: by 2002:a05:620a:12b2:: with SMTP id x18mr651368qki.437.1573095201947;
 Wed, 06 Nov 2019 18:53:21 -0800 (PST)
MIME-Version: 1.0
References: <20191107005153.31541-1-danieltimlee@gmail.com> <20191107005153.31541-3-danieltimlee@gmail.com>
In-Reply-To: <20191107005153.31541-3-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Nov 2019 18:53:11 -0800
Message-ID: <CAEf4BzZpBqPAKy1fKUQYSm3Wxez29EuBYqu_n2SayCfDt_ziUg@mail.gmail.com>
Subject: Re: [PATCH,bpf-next v2 2/2] samples: bpf: update map definition to
 new syntax BTF-defined map
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 6, 2019 at 4:52 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Since, the new syntax of BTF-defined map has been introduced,
> the syntax for using maps under samples directory are mixed up.
> For example, some are already using the new syntax, and some are using
> existing syntax by calling them as 'legacy'.
>
> As stated at commit abd29c931459 ("libbpf: allow specifying map
> definitions using BTF"), the BTF-defined map has more compatablility
> with extending supported map definition features.
>
> The commit doesn't replace all of the map to new BTF-defined map,
> because some of the samples still use bpf_load instead of libbpf, which
> can't properly create BTF-defined map.
>
> This will only updates the samples which uses libbpf API for loading bpf
> program. (ex. bpf_prog_load_xattr)
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
> Changes in v2:
>  - stick to __type() instead of __uint({key,value}_size) where possible
>
>  samples/bpf/sockex1_kern.c          |  12 ++--
>  samples/bpf/sockex2_kern.c          |  12 ++--
>  samples/bpf/xdp1_kern.c             |  12 ++--
>  samples/bpf/xdp2_kern.c             |  12 ++--
>  samples/bpf/xdp_adjust_tail_kern.c  |  12 ++--
>  samples/bpf/xdp_fwd_kern.c          |  13 ++--
>  samples/bpf/xdp_redirect_cpu_kern.c | 108 ++++++++++++++--------------
>  samples/bpf/xdp_redirect_kern.c     |  24 +++----
>  samples/bpf/xdp_redirect_map_kern.c |  24 +++----
>  samples/bpf/xdp_router_ipv4_kern.c  |  64 ++++++++---------
>  samples/bpf/xdp_rxq_info_kern.c     |  37 +++++-----
>  samples/bpf/xdp_tx_iptunnel_kern.c  |  26 +++----
>  12 files changed, 178 insertions(+), 178 deletions(-)

Heh, 1-to-1 insertions/deletions, no excuse to use old syntax ;)

Thanks for completing conversion!

Acked-by: Andrii Nakryiko <andriin@fb.com>

[...]
