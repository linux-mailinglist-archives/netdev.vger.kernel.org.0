Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED45F486849
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 18:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241640AbiAFRS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 12:18:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241570AbiAFRS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 12:18:58 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F14DC061245;
        Thu,  6 Jan 2022 09:18:57 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id n16so2951892plc.2;
        Thu, 06 Jan 2022 09:18:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=337hGQeJ0LKZsB4NQFcCjomjrUZtsHvl7DSAEMot8No=;
        b=Xnf27MykMqSNKie5yqb5mkze89KxBSpd/8HyzmA2KIil2lbHlu4ANlxBzPBdFNWVoP
         3Hn5lmd6okCRZACZNPYiGtaizUntJ7yRbOV788/cVa1XYfzK6MVWDuqc++sarXz2YH5/
         3zCBOO1KnmkpY50VaiKhzqbO+KmzDX4YaSj8U02hfmX/NjTB3pvTlQ+GdqIwAQij/v8n
         5kdel06ntL423N/vHDxZSZLDOp9979kewxDilLXeYM+bvey1SACFVKh7Q6Gb9Qt3f75X
         Lg0XogxY/SRoJFxTpy6n212u66YjWEHzsj2bzpErR6IqZCNyo8BjrSAXPsgZvvwzHiuO
         Qu4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=337hGQeJ0LKZsB4NQFcCjomjrUZtsHvl7DSAEMot8No=;
        b=p6gKWYKuqt8WsSshkjmi+qeHuzLqMeBtl5q8ikGsgAox9PeGI5JobiCOIUZVFpmib5
         cZUXLWOO1fP18thUT7hoVQ1qI3emBfnWdWttOyVMFu2gMl6YYhLWVWk0TfemWkE9lqBz
         nEnkrQzrSWC0ilCKrV59fdfyeosKkWq1cxP8zbbIfURQWemiUEcdGsbNp0vbm2Qe7KQq
         sXvIAk4/fvmK0PArr+J40PDSCD+6NKjk2YtU2oitzrUDRNcxXQ0ghjeIz/2pbLbETZNv
         +6r+mBg28QC3RNuRe+/3U3cu0yFnHGCTC2L1r5M0S81RxH8DpehT3Sqy3DTjJ8xgSQMq
         gLNA==
X-Gm-Message-State: AOAM532B0TdH65tKd1S+JyLNpqPS43oVS1jfzhFg64gS+FHAgMuVK1hd
        N72CPfcPo+DYOQIEP/GtboKPHJ4w25xs+iU5RMoZ2mai
X-Google-Smtp-Source: ABdhPJyAsawMUKKhXuYxw2yiqBiEDR8hLd3K7UJ0FFt+vc43qXlHxD1P+H9BOED33+fGS3Djco89MU5E5GDWexgV5PU=
X-Received: by 2002:a17:902:6502:b0:149:1162:f0b5 with SMTP id
 b2-20020a170902650200b001491162f0b5mr58652949plk.126.1641489536809; Thu, 06
 Jan 2022 09:18:56 -0800 (PST)
MIME-Version: 1.0
References: <20220103150812.87914-1-toke@redhat.com> <20220103150812.87914-8-toke@redhat.com>
 <20220106042027.zy6j4a72nxaqmocw@ast-mbp.dhcp.thefacebook.com> <87y23t9blc.fsf@toke.dk>
In-Reply-To: <87y23t9blc.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jan 2022 09:18:45 -0800
Message-ID: <CAADnVQ+j=DO8fMCcpoHmAjrW5sTbhHp_OA4eVpcKcwwRzsvKTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 7/7] selftests/bpf: Add selftest for
 XDP_REDIRECT in bpf_prog_run()
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 6, 2022 at 6:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Mon, Jan 03, 2022 at 04:08:12PM +0100, Toke H=C3=B8iland-J=C3=B8rgen=
sen wrote:
> >> +
> >> +#define NUM_PKTS 3
> >
> > May be send a bit more than 3 packets?
> > Just to test skb_list logic for XDP_PASS.
>
> OK, can do.
>
> >> +
> >> +    /* We setup a veth pair that we can not only XDP_REDIRECT packets
> >> +     * between, but also route them. The test packet (defined above) =
has
> >> +     * address information so it will be routed back out the same int=
erface
> >> +     * after it has been received, which will allow it to be picked u=
p by
> >> +     * the XDP program on the destination interface.
> >> +     *
> >> +     * The XDP program we run with bpf_prog_run() will cycle through =
all
> >> +     * four return codes (DROP/PASS/TX/REDIRECT), so we should end up=
 with
> >> +     * NUM_PKTS - 1 packets seen on the dst iface. We match the packe=
ts on
> >> +     * the UDP payload.
> >> +     */
> >> +    SYS("ip link add veth_src type veth peer name veth_dst");
> >> +    SYS("ip link set dev veth_src address 00:11:22:33:44:55");
> >> +    SYS("ip link set dev veth_dst address 66:77:88:99:aa:bb");
> >> +    SYS("ip link set dev veth_src up");
> >> +    SYS("ip link set dev veth_dst up");
> >> +    SYS("ip addr add dev veth_src fc00::1/64");
> >> +    SYS("ip addr add dev veth_dst fc00::2/64");
> >> +    SYS("ip neigh add fc00::2 dev veth_src lladdr 66:77:88:99:aa:bb")=
;
> >> +    SYS("sysctl -w net.ipv6.conf.all.forwarding=3D1");
> >
> > These commands pollute current netns. The test has to create its own ne=
tns
> > like other tests do.
>
> Right, will fix.
>
> > The forwarding=3D1 is odd. Nothing in the comments or commit logs
> > talks about it.
>
> Hmm, yeah, should probably have added an explanation, sorry about that :)
>
> > I'm guessing it's due to patch 6 limitation of picking loopback
> > for XDP_PASS and XDP_TX, right?
> > There is ingress_ifindex field in struct xdp_md.
> > May be use that to setup dev and rxq in test_run in patch 6?
> > Then there will be no need to hack through forwarding=3D1 ?
>
> No, as you note there's already ingress_ifindex to set the device, and
> the test does use that:
>
> +       memcpy(skel->rodata->expect_dst, &pkt_udp.eth.h_dest, ETH_ALEN);
> +       skel->rodata->ifindex_out =3D ifindex_src;
> +       ctx_in.ingress_ifindex =3D ifindex_src;

My point is that this ingress_ifindex should be used instead of loopback.
Otherwise the test_run infra is lying to the xdp program.

> I enable forwarding because the XDP program that counts the packets is
> running on the other end of the veth pair (on veth_dst), while the
> traffic gen is using veth_src as its ingress ifindex. So for XDP_TX and
> XDP_REDIRECT we send the frame back out the veth device, and it ends up
> being processed by the XDP program on veth_dst, and counted.

Not for XDP_TX. If I'm reading patch 6 correctly it gets xmited
out of loopback.

> But when
> the test program returns XDP_PASS, the packet will go up the frame; so
> to get it back to the counting program I enable forwarding and set the
> packet dst IP so that the stack routes it back out the same interface.
>
> I'll admit this is a bit hacky; I guess I can add a second TC ingress
> program that will count the packets being XDP_PASS'ed instead...

No. Please figure out how to XDP_PASS and XDP_TX without enabling forward
and counting in different places.
imo the forwarding hides the issue in the design that should be addressed.
When rx ifindex is an actual ifindex given by user space instead of
loopback all problems go away.
