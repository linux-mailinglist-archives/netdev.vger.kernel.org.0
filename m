Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18436486AB7
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 20:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243486AbiAFT5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 14:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243460AbiAFT5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 14:57:08 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE65C061245;
        Thu,  6 Jan 2022 11:57:08 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id r14-20020a17090b050e00b001b3548a4250so1370285pjz.2;
        Thu, 06 Jan 2022 11:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wr+OYqxxLoTjP5us1mUsue+uQ072K41NX1xN3XRdfiM=;
        b=K9pYQZepTHuMeXTDcu9gHnz9AG0FDPGdfZSRa+Lb2H+qvtfuGXkVpyPtD9DP1NVC1l
         kk1XsmdkV6EraXZoMHUEsbZQO6Wt9WT6Ob1rY6HyniXfUKeiGfg777FZTkzQHV9PSafy
         L+liz/1PRovAscQaExzpUQPmSuSkpKVwPevip4uliuqT9IMmpSiOktvISi7gW/16VxUG
         g5pry2fwxGl4jukhAwiUmaaXzXpCm6BGNqLsj6yPfJ2Hag4UxxgLAKST1cbTcIruer0y
         Mc5L/pm9rTbOvor1BFCOES4OSM36an4pFvKKVCGhlV7OzzWBM1jfU22yOHjR8fsx9tec
         PvmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wr+OYqxxLoTjP5us1mUsue+uQ072K41NX1xN3XRdfiM=;
        b=NVyFnIUL18qjLE97u4EqORNr4AEVdZI/qT6BAyq0PtFmFxfqHVpsf2XRBW+yivjrOu
         gVXek9wmOM1ErKdFaeL/mxmRwudZkq74Gu25DDu5+FQnpkIincZ+wjfeZBjlNycc4GKm
         5ZdE9G7qGXiq7yLs382DDvtbn9iQ9nYQ3cWzTXVtS/nCD6X4VLq34pDhcQfWmnM/2Doq
         xLeKRqpn1lXtb1ix//qdlPLPTN5BA+zMeKW/al31nPVGT2yQrytw9y2Cjk0CrXhStX3l
         RoCa9E8aEFm7wm9ZCrLXk73ZXP5AKj1l4934ty2EpVlQzDSrVWXRWQvciZNoMuBABlW1
         3/GA==
X-Gm-Message-State: AOAM530EB33IWR7/Zrhgc+Y1z8aXo8YT6x+c9CF/HeviqyujZig+zpe6
        jlNL0QjpaZwxhT/sNGuYT5+yxSh+vM2f72xr6ik=
X-Google-Smtp-Source: ABdhPJxVqnB7pan7givu+7QsB6VcITZVTNEL2BgTE6vg5MObAE3waOATAewjmSkkwIEHLEmx9tVu7WIetv30WuXVPn0=
X-Received: by 2002:a17:902:860c:b0:149:1017:25f0 with SMTP id
 f12-20020a170902860c00b00149101725f0mr59632442plo.116.1641499027827; Thu, 06
 Jan 2022 11:57:07 -0800 (PST)
MIME-Version: 1.0
References: <20220103150812.87914-1-toke@redhat.com> <20220103150812.87914-8-toke@redhat.com>
 <20220106042027.zy6j4a72nxaqmocw@ast-mbp.dhcp.thefacebook.com>
 <87y23t9blc.fsf@toke.dk> <CAADnVQ+j=DO8fMCcpoHmAjrW5sTbhHp_OA4eVpcKcwwRzsvKTA@mail.gmail.com>
 <87tuegafnw.fsf@toke.dk>
In-Reply-To: <87tuegafnw.fsf@toke.dk>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Jan 2022 11:56:56 -0800
Message-ID: <CAADnVQ+6-Q6N1t0UsmF=Rn1yP=KPo7Xc2Fiy1rzJ+Hb0oAr4Hw@mail.gmail.com>
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

On Thu, Jan 6, 2022 at 10:21 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Thu, Jan 6, 2022 at 6:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>
> >> > On Mon, Jan 03, 2022 at 04:08:12PM +0100, Toke H=C3=B8iland-J=C3=B8r=
gensen wrote:
> >> >> +
> >> >> +#define NUM_PKTS 3
> >> >
> >> > May be send a bit more than 3 packets?
> >> > Just to test skb_list logic for XDP_PASS.
> >>
> >> OK, can do.
> >>
> >> >> +
> >> >> +    /* We setup a veth pair that we can not only XDP_REDIRECT pack=
ets
> >> >> +     * between, but also route them. The test packet (defined abov=
e) has
> >> >> +     * address information so it will be routed back out the same =
interface
> >> >> +     * after it has been received, which will allow it to be picke=
d up by
> >> >> +     * the XDP program on the destination interface.
> >> >> +     *
> >> >> +     * The XDP program we run with bpf_prog_run() will cycle throu=
gh all
> >> >> +     * four return codes (DROP/PASS/TX/REDIRECT), so we should end=
 up with
> >> >> +     * NUM_PKTS - 1 packets seen on the dst iface. We match the pa=
ckets on
> >> >> +     * the UDP payload.
> >> >> +     */
> >> >> +    SYS("ip link add veth_src type veth peer name veth_dst");
> >> >> +    SYS("ip link set dev veth_src address 00:11:22:33:44:55");
> >> >> +    SYS("ip link set dev veth_dst address 66:77:88:99:aa:bb");
> >> >> +    SYS("ip link set dev veth_src up");
> >> >> +    SYS("ip link set dev veth_dst up");
> >> >> +    SYS("ip addr add dev veth_src fc00::1/64");
> >> >> +    SYS("ip addr add dev veth_dst fc00::2/64");
> >> >> +    SYS("ip neigh add fc00::2 dev veth_src lladdr 66:77:88:99:aa:b=
b");
> >> >> +    SYS("sysctl -w net.ipv6.conf.all.forwarding=3D1");
> >> >
> >> > These commands pollute current netns. The test has to create its own=
 netns
> >> > like other tests do.
> >>
> >> Right, will fix.
> >>
> >> > The forwarding=3D1 is odd. Nothing in the comments or commit logs
> >> > talks about it.
> >>
> >> Hmm, yeah, should probably have added an explanation, sorry about that=
 :)
> >>
> >> > I'm guessing it's due to patch 6 limitation of picking loopback
> >> > for XDP_PASS and XDP_TX, right?
> >> > There is ingress_ifindex field in struct xdp_md.
> >> > May be use that to setup dev and rxq in test_run in patch 6?
> >> > Then there will be no need to hack through forwarding=3D1 ?
> >>
> >> No, as you note there's already ingress_ifindex to set the device, and
> >> the test does use that:
> >>
> >> +       memcpy(skel->rodata->expect_dst, &pkt_udp.eth.h_dest, ETH_ALEN=
);
> >> +       skel->rodata->ifindex_out =3D ifindex_src;
> >> +       ctx_in.ingress_ifindex =3D ifindex_src;
> >
> > My point is that this ingress_ifindex should be used instead of loopbac=
k.
> > Otherwise the test_run infra is lying to the xdp program.
>
> But it is already using that! There is just no explicit code in patch 6
> to do that because that was already part of the XDP prog_run
> functionality.
>
> Specifically, the existing bpf_prog_test_run_xdp() will pass the context
> through xdp_convert_md_to_buff() which will resolve the ifindex and get
> a dev reference. So the xdp_buff object being passed to the new
> bpf_test_run_xdp_live() function already has the right device in
> ctx->rxq.

Got it. Please make it clear in the commit log.

> No the problem of XDP_PASS going in the opposite direction of XDP_TX and
> XDP_REDIRECT remains. This is just like on a physical interface: if you
> XDP_TX a packet it goes back out, if you XDP_PASS it, it goes up the
> stack. To intercept both after the fact, you need to look in two
> different places.
>
> Anyhow, just using a TC hook for XDP_PASS works fine and gets rid of the
> forwarding hack; I'll send a v6 with that just as soon as I verify that
> I didn't break anything when running the traffic generator on bare metal =
:)

Got it. You mean a tc ingress prog attached to veth_src ? That should work.
