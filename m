Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB3F5234A76
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbgGaRsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728758AbgGaRs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:48:29 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D749C061574;
        Fri, 31 Jul 2020 10:48:29 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id p191so421304ybg.0;
        Fri, 31 Jul 2020 10:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7yuTOXkhnjtQaEm9idGZaO/zfXegMB7ywvDDyNQyj/I=;
        b=Ia2KG8Dg+BQsHF7ZvXuqhVIIBXIEfPHODcfnL2p5ZboFoSn9gTATt5RC0apvua39Hk
         HdaIBqspB9J4V0exyzKhHQoo5hJcRMKO3jb99ftPqkLACSyTaBO+vU3hGwvRVG0Mkg3O
         XNcFh05JPS/txkOomOZQ0DqaK6erwgFsy2e5T1w2p562foq96lFZPfZ9oPSgHasLEuaS
         wAJLELm7a5mQXCzR4L68bqSRsxxXFcnI8mDwBw+9vth3cnfOu27NHeT8vn775fzCw3ku
         VajG0UgaXUiv0ntVgRB656n01g3b6EkUexByh7gvYQ6yz6rSP48rqTABWFwTKrPk0fBg
         waoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7yuTOXkhnjtQaEm9idGZaO/zfXegMB7ywvDDyNQyj/I=;
        b=F5q9nWq1kHBztZOJ/UJsWomdG5g0vu0/qg6DaQDReYgzZ1J2YFED6kZNZoGuSUafwZ
         p900L4VJ4t4V6FQteuyycKjshpWGopNivnVepnv9JbS1BvcewNwKvlfVlMgyhiQTdLB+
         F8luVizEZT315Ir5s4mVmm1xAXUgWo19BkvWI1wOjmf/4jfX7VVKtXn1jpoI9vzV9RYv
         K+j7eOuZlvK82mknz80JV1zsN4V5JbhbIUMkpb99bXaSIRlwsV7syY2cMtCJuv3ja77Z
         Y6hyk+5jfs2/ODgJ5k5yOnTcckYIO5sIt9wKaCHkcw9kfOaaAp9isLVEQFlm5w3FM6jX
         RBjQ==
X-Gm-Message-State: AOAM532G7FyX1/DHswYiIWIAGJCVf2rY2yj/0z0DwRz5Xw3jtkkRBksu
        pCegVUYhPyv6xeaQAsCn35WdItUn/JzNHpOKrrE=
X-Google-Smtp-Source: ABdhPJxIKeLVgVoTxPWDwUwBAi6m9zUbpLSULVkwM/J75oOYyUrhoQQj2Ky9cRsM5qWbNAOu69NDamEetiIgIjzJLpo=
X-Received: by 2002:a25:d84a:: with SMTP id p71mr8363157ybg.347.1596217708673;
 Fri, 31 Jul 2020 10:48:28 -0700 (PDT)
MIME-Version: 1.0
References: <1596170660-5582-1-git-send-email-komachi.yoshiki@gmail.com> <1596170660-5582-4-git-send-email-komachi.yoshiki@gmail.com>
In-Reply-To: <1596170660-5582-4-git-send-email-komachi.yoshiki@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 31 Jul 2020 10:48:18 -0700
Message-ID: <CAEf4BzaRKhJqFmXJEQy5LOjKx9nkPgAKHa3cesvywy2qqg93YA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 3/3] samples/bpf: Add a simple bridge example
 accelerated with XDP
To:     Yoshiki Komachi <komachi.yoshiki@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 9:45 PM Yoshiki Komachi
<komachi.yoshiki@gmail.com> wrote:
>
> This patch adds a simple example of XDP-based bridge with the new
> bpf_fdb_lookup helper. This program simply forwards packets based
> on the destination port given by FDB in the kernel. Note that both
> vlan filtering and learning features are currently unsupported in
> this example.
>
> There is another plan to recreate a userspace application
> (xdp_bridge_user.c) as a daemon process, which helps to automate
> not only detection of status changes in bridge port but also
> handling vlan protocol updates.
>
> Note: David Ahern suggested a new bpf helper [1] to get master
> vlan/bonding devices in XDP programs attached to their slaves
> when the master vlan/bonding devices are bridge ports. If this
> idea is accepted and the helper is introduced in the future, we
> can handle interfaces slaved to vlan/bonding devices in this
> sample by calling the suggested bpf helper (I guess it can get
> vlan/bonding ifindex from their slave ifindex). Notice that we
> don't need to change bpf_fdb_lookup() API to use such a feature,
> but we just need to modify bpf programs like this sample.
>
> [1]: http://vger.kernel.org/lpc-networking2018.html#session-1
>
> Signed-off-by: Yoshiki Komachi <komachi.yoshiki@gmail.com>
> ---

Have you tried using a BPF skeleton for this? It could have saved a
bunch of mechanical code for your example. Also libbpf supports map
pinning out of the box now, I wonder if it would just work in your
case. Also it would be nice if you tried using BPF link-based approach
for this example, to show how it can be used. Thanks!


>  samples/bpf/Makefile          |   3 +
>  samples/bpf/xdp_bridge_kern.c | 129 ++++++++++++++++++
>  samples/bpf/xdp_bridge_user.c | 239 ++++++++++++++++++++++++++++++++++
>  3 files changed, 371 insertions(+)
>  create mode 100644 samples/bpf/xdp_bridge_kern.c
>  create mode 100644 samples/bpf/xdp_bridge_user.c
>

[...]
