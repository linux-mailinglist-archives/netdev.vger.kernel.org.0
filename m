Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A2550F0ED
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 08:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245125AbiDZG3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 02:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238318AbiDZG3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 02:29:32 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A612813D55;
        Mon, 25 Apr 2022 23:26:26 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id m13so4746714iob.4;
        Mon, 25 Apr 2022 23:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Njvj1KBr5lRxIqTHY3aarGqfWcahQ2OETUvHizWsQ5k=;
        b=exHBj0ijRuAsQEn18gYi/txSChryubGP03FFjcAGu0vBjhsp6reUD3PgC3VPokTJ4U
         R/cZLeeF3fMQJR6g139T1SL3AVICLVq/fzyP6z/TwDwIg4ikL6i1Uc9GnQeyZlWeZWwK
         uB4lEIZ86u8okmoljg9QMda1bAOQlb3GaIjFtztuhzQoGSlbQyN4+aYu0HE9slXbiTok
         KGi00EB2bMoWVJzDgP7wCFfTxF6nUI9iCHD7/TBXj7/dTfI7jMCxg6r057XN9NRikfRy
         QxzmBenbkR04HEiJZTBqP5la0ek+Yq2ILKc6RoLV+9bdATMAs0C1wku8bvfqsH9Vji9E
         irPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Njvj1KBr5lRxIqTHY3aarGqfWcahQ2OETUvHizWsQ5k=;
        b=p+FfQwfyyfsw9qB7m5UzqhbUsomeaxtuKs+X2Ymn498MTFRO3y1at/GJTl+CQvcVCs
         j0086EgRIiT5XiUbXkPwMkF/kFxjkLZYnzzhovdxE67iN2ukCT/SC0qcKStqWiX7bwsn
         vMf+q1MAvEE+WQPHPGIELdZPItva2baQHXVrxkpfnZxd2gBPS+VW+zNOw7wcj5xVR5dU
         g/tQAA1MUuR2ebrE0TaT19sDzgbrCeRyuc4sfU2aZJtJTHDYZQeH80FAl0sO/PUNpfP3
         4TojzK3o2hJ/laMT3e7Wdgq2ksKi/4gYiziMy7SATTWjTp1Tl4klCfoH4ZgHmLBKK19R
         +h1g==
X-Gm-Message-State: AOAM531jg1OhnBfxHssty4vndqE+MOZLPNMqnIVMFe0DzVq0fevBUvxk
        iotqBNJY9ZDkxbDnRzr6P/C/2WeaTOUbXygz2DU=
X-Google-Smtp-Source: ABdhPJz8pv6zY9PCDgvV/0Xllqm+GLTCXxOiJSBKtElyCjnfbyNz4Vnz5EHs5wSG4BXiP+I0hWOTfgqB3/rwFbouzMo=
X-Received: by 2002:a05:6638:3393:b0:32a:93cd:7e48 with SMTP id
 h19-20020a056638339300b0032a93cd7e48mr9236529jav.93.1650954385989; Mon, 25
 Apr 2022 23:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220422172422.4037988-1-maximmi@nvidia.com> <20220422172422.4037988-6-maximmi@nvidia.com>
 <20220426001223.wlnfd2kmmogip5d5@MBP-98dd607d3435.dhcp.thefacebook.com>
In-Reply-To: <20220426001223.wlnfd2kmmogip5d5@MBP-98dd607d3435.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Apr 2022 23:26:15 -0700
Message-ID: <CAEf4BzaGjxsf46YPs1FRSp4kj+nkKhw7vLKAGwgrdnAuTW5+9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 5/6] bpf: Add selftests for raw syncookie helpers
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        Florent Revest <revest@chromium.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 25, 2022 at 5:12 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Apr 22, 2022 at 08:24:21PM +0300, Maxim Mikityanskiy wrote:
> > +void test_xdp_synproxy(void)
> > +{
> > +     int server_fd = -1, client_fd = -1, accept_fd = -1;
> > +     struct nstoken *ns = NULL;
> > +     FILE *ctrl_file = NULL;
> > +     char buf[1024];
> > +     size_t size;
> > +
> > +     SYS("ip netns add synproxy");
> > +
> > +     SYS("ip link add tmp0 type veth peer name tmp1");
> > +     SYS("ip link set tmp1 netns synproxy");
> > +     SYS("ip link set tmp0 up");
> > +     SYS("ip addr replace 198.18.0.1/24 dev tmp0");
> > +
> > +     // When checksum offload is enabled, the XDP program sees wrong
> > +     // checksums and drops packets.
> > +     SYS("ethtool -K tmp0 tx off");
>
> BPF CI image doesn't have ethtool installed.
> It will take some time to get it updated. Until then we cannot land the patch set.
> Can you think of a way to run this test without shelling to ethtool?

Good news: we got updated CI image with ethtool, so that shouldn't be
a problem anymore.

Bad news: this selftest still fails, but in different place:

test_synproxy:FAIL:iptables -t raw -I PREROUTING -i tmp1 -p tcp -m tcp
--syn --dport 8080 -j CT --notrack unexpected error: 512 (errno 2)

See [0].

  [0] https://github.com/kernel-patches/bpf/runs/6169439612?check_suite_focus=true
