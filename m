Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA65512534
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiD0W0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbiD0W0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:26:18 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891A22C656;
        Wed, 27 Apr 2022 15:23:06 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id f5so863276ilj.13;
        Wed, 27 Apr 2022 15:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m2zpAHo4N4DxJCqrpyoM9xFz6wA0o7g6EHge6QxNFRw=;
        b=M4f0SnMcYdS2+nYxMbjJ3i/Kje+3f0uHeSHyDJjdIt4L25doLpC23IpA0KMbRGvpe/
         Y5hBa6YaJ7PNTH/sPHBEXY8ZT47X52pvfq/fUHqisUvSmyhJ8M6UEb+7Ky0gogeXlW3D
         fjHqIhPueXD8lotAnrhhSuCYAvCTC/W+0Kv3UiQCG5Uu0gWV1c5dQnJ6tpT+zxEnbT9h
         t7fgoJVDENYDX1k7RdGFyv+NeG+Ip7f5AB5R/4Nxc+80Yok1zqSbeXbzvZDqZf1u2U3I
         8ep1xVDhOA+Clhi/Y68lIl4KfEGQnR3Xh5EJvlfW3QqTXJE0AeQXstMDf60Hb5s8JpHq
         4EmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m2zpAHo4N4DxJCqrpyoM9xFz6wA0o7g6EHge6QxNFRw=;
        b=fEwdhgkzOdux3crKVYuCsAWVmr0DM6Xxh0jSKXHM6V9KT+bTM09KZkESwRAx78qvV/
         F4eHHCNl9C82Ci9g+ZrA43RZfj+l7kLlAl7J2yDN7Oo5hkd4vDHia2o8MU/YWoOyJ5qd
         qjpKmO5Lm3KEiVIGx4FzEnhC+0zOeWwGU/zwkciQDqI0GBgFQOiWJb+42qieh1IlkNVJ
         kODcaaPFrp9y9i2Jm7ZuDv9vxLgho/S1Wo1V8tifyuHzmCh/K+Poamt7BrIIZyzc8Sqf
         xHKAoF8nCR3z03lW4es4zzzK+v0JS7ZjXupfH3Ih6cH/B+xyGrpi8nipO/juC44cShM0
         nDRA==
X-Gm-Message-State: AOAM532uTtOqMrXQwBO1eM88pGtyIVmJDpEADmOYZuSYpjhfpcAfppEg
        R7cTul5tnFOAbWtDba8omrugPcb8gDNRUevorCA=
X-Google-Smtp-Source: ABdhPJxqiR8j8bvemVOUtV1TwL7VR3W7PitBTYk8DangGIPNZSyDjL+UurL8eaT8ITiQYErdSEGqNLyFEWXCZnOoOq4=
X-Received: by 2002:a92:6406:0:b0:2bb:f1de:e13e with SMTP id
 y6-20020a926406000000b002bbf1dee13emr11721808ilb.305.1651098185982; Wed, 27
 Apr 2022 15:23:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220422172422.4037988-1-maximmi@nvidia.com> <20220422172422.4037988-6-maximmi@nvidia.com>
 <20220426001223.wlnfd2kmmogip5d5@MBP-98dd607d3435.dhcp.thefacebook.com>
 <CAEf4BzaGjxsf46YPs1FRSp4kj+nkKhw7vLKAGwgrdnAuTW5+9Q@mail.gmail.com>
 <92e9eaf6-4d72-3173-3271-88e3b8637c7a@nvidia.com> <CAEf4BzZhjY+F9JYmT7k+m87UZ1qKuO8_Mjjq4CGgkr=z9BGDCg@mail.gmail.com>
 <946b8928-56b6-b6ca-ec33-6ffe7af6a90c@nvidia.com>
In-Reply-To: <946b8928-56b6-b6ca-ec33-6ffe7af6a90c@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 15:22:55 -0700
Message-ID: <CAEf4BzZqZkDB8EJh3K3TpT7N556hxCRqMF7x_Y8D05wmBGDdvA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 5/6] bpf: Add selftests for raw syncookie helpers
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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

On Wed, Apr 27, 2022 at 10:19 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2022-04-27 01:11, Andrii Nakryiko wrote:
> > On Tue, Apr 26, 2022 at 11:29 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> >>
> >> On 2022-04-26 09:26, Andrii Nakryiko wrote:
> >>> On Mon, Apr 25, 2022 at 5:12 PM Alexei Starovoitov
> >>> <alexei.starovoitov@gmail.com> wrote:
> >>>>
> >>>> On Fri, Apr 22, 2022 at 08:24:21PM +0300, Maxim Mikityanskiy wrote:
> >>>>> +void test_xdp_synproxy(void)
> >>>>> +{
> >>>>> +     int server_fd = -1, client_fd = -1, accept_fd = -1;
> >>>>> +     struct nstoken *ns = NULL;
> >>>>> +     FILE *ctrl_file = NULL;
> >>>>> +     char buf[1024];
> >>>>> +     size_t size;
> >>>>> +
> >>>>> +     SYS("ip netns add synproxy");
> >>>>> +
> >>>>> +     SYS("ip link add tmp0 type veth peer name tmp1");
> >>>>> +     SYS("ip link set tmp1 netns synproxy");
> >>>>> +     SYS("ip link set tmp0 up");
> >>>>> +     SYS("ip addr replace 198.18.0.1/24 dev tmp0");
> >>>>> +
> >>>>> +     // When checksum offload is enabled, the XDP program sees wrong
> >>>>> +     // checksums and drops packets.
> >>>>> +     SYS("ethtool -K tmp0 tx off");
> >>>>
> >>>> BPF CI image doesn't have ethtool installed.
> >>>> It will take some time to get it updated. Until then we cannot land the patch set.
> >>>> Can you think of a way to run this test without shelling to ethtool?
> >>>
> >>> Good news: we got updated CI image with ethtool, so that shouldn't be
> >>> a problem anymore.
> >>>
> >>> Bad news: this selftest still fails, but in different place:
> >>>
> >>> test_synproxy:FAIL:iptables -t raw -I PREROUTING -i tmp1 -p tcp -m tcp
> >>> --syn --dport 8080 -j CT --notrack unexpected error: 512 (errno 2)
> >>
> >> That's simply a matter of missing kernel config options:
> >>
> >> CONFIG_NETFILTER_SYNPROXY=y
> >> CONFIG_NETFILTER_XT_TARGET_CT=y
> >> CONFIG_NETFILTER_XT_MATCH_STATE=y
> >> CONFIG_IP_NF_FILTER=y
> >> CONFIG_IP_NF_TARGET_SYNPROXY=y
> >> CONFIG_IP_NF_RAW=y
> >>
> >> Shall I create a pull request on github to add these options to
> >> https://github.com/libbpf/libbpf/tree/master/travis-ci/vmtest/configs?
> >>
> >
> > Yes, please. But also for [0], that's the one that tests all the
> > not-yet-applied patches
> >
> >    [0] https://github.com/kernel-patches/vmtest/
>
> Created pull requests:
>
> https://github.com/kernel-patches/vmtest/pull/79
> https://github.com/libbpf/libbpf/pull/490
>

Merged both, thanks.


> >>> See [0].
> >>>
> >>>     [0] https://github.com/kernel-patches/bpf/runs/6169439612?check_suite_focus=true
> >>
>
