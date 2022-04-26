Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC59B510BB6
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 00:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244210AbiDZWOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 18:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbiDZWOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 18:14:45 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F68F3B002;
        Tue, 26 Apr 2022 15:11:36 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id c125so366712iof.9;
        Tue, 26 Apr 2022 15:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fILbKujbkDe+6LP+BCuA9mzMNH72AUuUy21C/WMJlAo=;
        b=FfGE58rDfk4rB9Q3BzlWqMhRUEY8Gt+cxWsblJTfWra/7D6XDgXLiYeWFfrP+WSP3E
         gAEpx1ZDq933dPra7qQd4CSZKKsH23P1YvRoHCxdTxa2l36eZShw6Z84W0Ph+rTEXy0j
         tql1olLJy6QCw4lke3j3f2jzcNRM702o38oWXrU3OCeI/SSzt0S6FhI1I4eXpkH1QJTZ
         WY+pwraSGx9ViRimTXV9ueai56cP2Xj868237/IOwmYizo5VRomBgW+FnH7tPkvNKhes
         iVhOnAp3HNLphl74qgCsbd3GmfqX4JbGEgwraMDylwbRRRRiwD7OgkVGSz0gbXbuQJh3
         nWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fILbKujbkDe+6LP+BCuA9mzMNH72AUuUy21C/WMJlAo=;
        b=yBc/QdHlYacimOe7jstf1cvX+odS/ZTRHS6tR/C/OvOXIHEiM+/CRbARtXoQWWBdBg
         XOCC0vFXEs8izRk9vdZ4IyDeIrR7EWMvBJuDIMZyDsIjKVUdGExPSrvMsth9+getz1OT
         31BVWW7SzFMgyH0X65HcEL/JmL2Kux79W3W6LbUGboyaOVE4lvO07Qx+3x0PJBvXjzec
         UY3G5q+r25efSwM3JbXzmnrm5NDO/7d0T5e/Q+jUA57MSkYjPqb/T8BaqGqleQPP+uLo
         hNztUqnBqL2f+YyHSCTfNWtUmKyvbj0X872UDw7LowKl5M+ILJ1Ziv4nOaXg8Bwk9R+q
         43Fw==
X-Gm-Message-State: AOAM533fH3DQNzynVkPA9wGHIVgggfrXnw4Spxy+aYj6x4jmrqxFETTO
        ptDzdZvL6lKBq+ooMheJpLoV2Gj2z7bV2v1Sq1M=
X-Google-Smtp-Source: ABdhPJwSb8LXHzHQ9W8IOU/qiWUFK5ABOYeynw6E1cE7hI8yCMmU6rsNLEL26TYmz5d2mbNaDrfUdHAjMzTAoVzeVLM=
X-Received: by 2002:a05:6638:2104:b0:326:1e94:efa6 with SMTP id
 n4-20020a056638210400b003261e94efa6mr11337361jaj.234.1651011095978; Tue, 26
 Apr 2022 15:11:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220422172422.4037988-1-maximmi@nvidia.com> <20220422172422.4037988-6-maximmi@nvidia.com>
 <20220426001223.wlnfd2kmmogip5d5@MBP-98dd607d3435.dhcp.thefacebook.com>
 <CAEf4BzaGjxsf46YPs1FRSp4kj+nkKhw7vLKAGwgrdnAuTW5+9Q@mail.gmail.com> <92e9eaf6-4d72-3173-3271-88e3b8637c7a@nvidia.com>
In-Reply-To: <92e9eaf6-4d72-3173-3271-88e3b8637c7a@nvidia.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 Apr 2022 15:11:25 -0700
Message-ID: <CAEf4BzZhjY+F9JYmT7k+m87UZ1qKuO8_Mjjq4CGgkr=z9BGDCg@mail.gmail.com>
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

On Tue, Apr 26, 2022 at 11:29 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2022-04-26 09:26, Andrii Nakryiko wrote:
> > On Mon, Apr 25, 2022 at 5:12 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> >>
> >> On Fri, Apr 22, 2022 at 08:24:21PM +0300, Maxim Mikityanskiy wrote:
> >>> +void test_xdp_synproxy(void)
> >>> +{
> >>> +     int server_fd = -1, client_fd = -1, accept_fd = -1;
> >>> +     struct nstoken *ns = NULL;
> >>> +     FILE *ctrl_file = NULL;
> >>> +     char buf[1024];
> >>> +     size_t size;
> >>> +
> >>> +     SYS("ip netns add synproxy");
> >>> +
> >>> +     SYS("ip link add tmp0 type veth peer name tmp1");
> >>> +     SYS("ip link set tmp1 netns synproxy");
> >>> +     SYS("ip link set tmp0 up");
> >>> +     SYS("ip addr replace 198.18.0.1/24 dev tmp0");
> >>> +
> >>> +     // When checksum offload is enabled, the XDP program sees wrong
> >>> +     // checksums and drops packets.
> >>> +     SYS("ethtool -K tmp0 tx off");
> >>
> >> BPF CI image doesn't have ethtool installed.
> >> It will take some time to get it updated. Until then we cannot land the patch set.
> >> Can you think of a way to run this test without shelling to ethtool?
> >
> > Good news: we got updated CI image with ethtool, so that shouldn't be
> > a problem anymore.
> >
> > Bad news: this selftest still fails, but in different place:
> >
> > test_synproxy:FAIL:iptables -t raw -I PREROUTING -i tmp1 -p tcp -m tcp
> > --syn --dport 8080 -j CT --notrack unexpected error: 512 (errno 2)
>
> That's simply a matter of missing kernel config options:
>
> CONFIG_NETFILTER_SYNPROXY=y
> CONFIG_NETFILTER_XT_TARGET_CT=y
> CONFIG_NETFILTER_XT_MATCH_STATE=y
> CONFIG_IP_NF_FILTER=y
> CONFIG_IP_NF_TARGET_SYNPROXY=y
> CONFIG_IP_NF_RAW=y
>
> Shall I create a pull request on github to add these options to
> https://github.com/libbpf/libbpf/tree/master/travis-ci/vmtest/configs?
>

Yes, please. But also for [0], that's the one that tests all the
not-yet-applied patches

  [0] https://github.com/kernel-patches/vmtest/

> > See [0].
> >
> >    [0] https://github.com/kernel-patches/bpf/runs/6169439612?check_suite_focus=true
>
