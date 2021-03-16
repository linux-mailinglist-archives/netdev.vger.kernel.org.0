Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E65333CD6B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 06:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbhCPFkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 01:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235522AbhCPFju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 01:39:50 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C9FC06174A;
        Mon, 15 Mar 2021 22:39:50 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id n195so35587780ybg.9;
        Mon, 15 Mar 2021 22:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yUWGHedf07OXbwwpngVBBhRyVCO6+4uBsfBCxG+Ja7w=;
        b=RYy8QZq8l6yQQpabcW6kfnUXenTzvUdg2hPDNL5MsDq6TqaPiUohIx6sNMkk4P/vbN
         HoVwho2YHscpNioP8OwAwV78zxHSoiQkthOukgOZba5rPQNwSKl6XsrsgoGK69yFXMGp
         cZ5+JK0iGmvZ0irS883hBCNGyjNh0zPuc2oIX2XhNpU1U0UXkZo7z0HhXx0a65LhBSxc
         FFcBf4kIS3Lv5XN/wTREV8S+R6mHTvTYeIKGLXPlCKVsL+Z9bWPA12hmntMKSwphpBtx
         +LfGAUl24B8GuYvVJiwE/XnNdGQazpPxX8d5OElcziIZU6J8fWXWnAEm/EZUFtTE/+J5
         HjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yUWGHedf07OXbwwpngVBBhRyVCO6+4uBsfBCxG+Ja7w=;
        b=P4LmEA5nBchy40DjBsR0ilPILqtoVWcc8RAufda1odQTHsuE2Iirp4lwo44J6GHr9F
         ZpP9CY6SJ0mB4DS/0W9v59OVfAbPjgnpaMzeOgVvpn1xQk+b8em/3uN8d+wA+Ci00W8q
         Rr2aU74qFUX/7QzmDSXa73/Ie7nt5VN15iPvPETAIBd1YwaacaQTZ1Y4NqJ4j3QqSzpp
         xN9cBzoGoyXt8VEgA+n4RXspHhQ51MFZN57jl7EIWERQIsFm+XWpSs44E7jkX50snken
         viCkycUAU0kxr9TfJEZ55zkKejs0IGZ62qaTtVfJUlGxH8v47LB6KO2OIO0pmPmSe4Ds
         Gqfw==
X-Gm-Message-State: AOAM532kX6LgQsV1+XTLuDrdpAzmOgStbXZSR5GtkZzrJwIom8eEsyKh
        vAyWRzTdnmUZBN3wtsQKdOPMAs0q3SuVJ72K5HE=
X-Google-Smtp-Source: ABdhPJzL9Qt+dYKBzoE4bTMJKIwB+RYI5QsAOYCm2C50/6kYKa3gXBBNJxTvjqzi6xPYqFGRdc85jpRTwkLLvUrP8rE=
X-Received: by 2002:a25:7d07:: with SMTP id y7mr4373972ybc.425.1615873189336;
 Mon, 15 Mar 2021 22:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com> <20210311152910.56760-15-maciej.fijalkowski@intel.com>
In-Reply-To: <20210311152910.56760-15-maciej.fijalkowski@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Mar 2021 22:39:38 -0700
Message-ID: <CAEf4BzZDW8V0SPzqWksR8fg=8xShvRQdN3rJr_H3zm-VoXtdNw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 14/17] selftests: xsk: implement bpf_link test
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        ciara.loftus@intel.com, john fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 7:43 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Introduce a test that is supposed to verify the persistence of BPF
> resources based on underlying bpf_link usage.
>
> Test will:
> 1) create and bind two sockets on queue ids 0 and 1
> 2) run a traffic on queue ids 0
> 3) remove xsk sockets from queue 0 on both veth interfaces
> 4) run a traffic on queues ids 1
>
> Running traffic successfully on qids 1 means that BPF resources were
> not removed on step 3).
>
> In order to make it work, change the command that creates veth pair to
> have the 4 queue pairs by default.
>
> Introduce the arrays of xsks and umems to ifobject struct but keep a
> pointers to single entities, so rest of the logic around Rx/Tx can be
> kept as-is.
>
> For umem handling, double the size of mmapped space and split that
> between the two sockets.
>
> Rename also bidi_pass to a variable 'second_step' of a boolean type as
> it's now used also for the test that is introduced here and it doesn't
> have anything in common with bi-directional testing.
>
> Drop opt_queue command line argument as it wasn't working before anyway.
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/test_xsk.sh  |   2 +-
>  tools/testing/selftests/bpf/xdpxceiver.c | 179 +++++++++++++++++------
>  tools/testing/selftests/bpf/xdpxceiver.h |   7 +-
>  3 files changed, 138 insertions(+), 50 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
> index 56d4474e2c83..2a00b8222475 100755
> --- a/tools/testing/selftests/bpf/test_xsk.sh
> +++ b/tools/testing/selftests/bpf/test_xsk.sh
> @@ -107,7 +107,7 @@ setup_vethPairs() {
>                 echo "setting up ${VETH0}: namespace: ${NS0}"
>         fi
>         ip netns add ${NS1}
> -       ip link add ${VETH0} type veth peer name ${VETH1}
> +       ip link add ${VETH0} numtxqueues 4 numrxqueues 4 type veth peer name ${VETH1} numtxqueues 4 numrxqueues 4
>         if [ -f /proc/net/if_inet6 ]; then
>                 echo 1 > /proc/sys/net/ipv6/conf/${VETH0}/disable_ipv6
>         fi
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index aef5840e1c24..dc775ee139c5 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -41,8 +41,12 @@
>   *            Reduce the size of the RX ring to a fraction of the fill ring size.
>   *       iv.  fill queue empty
>   *            Do not populate the fill queue and then try to receive pkts.
> + *    f. bpf_link resource persitence

typo: persistence

> + *       Configure sockets at indexes 0 and 1,run a traffic on queue ids 0,

while I'm here nitting :) space after comma?

> + *       then remove xsk sockets from queue 0 on both veth interfaces and
> + *       finally run a traffic on queues ids 1
>   *
> - * Total tests: 10
> + * Total tests: 12
>   *
>   * Flow:
>   * -----

[...]
