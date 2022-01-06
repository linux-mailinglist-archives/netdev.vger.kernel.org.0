Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B70486AFE
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 21:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243651AbiAFUVA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 15:21:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243636AbiAFUU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 15:20:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641500457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uVPgqD2PlyQyW5KqK6Xa09cRn07PcS57Of9dZqeQYns=;
        b=G9lXQpCLlVtDF2X0NlW/w8lhveAlnuPAnDyww9fQauNmn570Ykqw8BoCltmjbVt44rHiTt
        uFJwFI+8u6EvLRFsfOiJo99oewoIM1DzP+CF/IlsjjQ09XJFrqqFhu0iKcdWB983kHg12z
        mtLF4XvENcr2CaWvt3Yjpmeyw01KCYY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-Q6sQgYCVOHe34FVxwIq_lQ-1; Thu, 06 Jan 2022 15:20:56 -0500
X-MC-Unique: Q6sQgYCVOHe34FVxwIq_lQ-1
Received: by mail-ed1-f72.google.com with SMTP id i5-20020a05640242c500b003f84839a8c3so2827823edc.6
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 12:20:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=uVPgqD2PlyQyW5KqK6Xa09cRn07PcS57Of9dZqeQYns=;
        b=MsD1R6BNW9OrKSdxnDhfKPOUNErawKlIsi7b/ip3OISBmv7DD//u483DHKbJoUBQKn
         5n0w3FpaA12fRyjqmaoQoHoUcX6pOgryBeST3FNWSMRtYy9BhSPvvM7Hx2Y55ykKMMBQ
         CNGffHQfMcY4TjKH2uK7KzJohI2tMHdAq8WNz/IAeLexxigUOGp/SIMhpWeK8VivX/as
         V+hrLTT9FQ8HaYaXSIr9rmTsITrG1Av3lTz42TD8rfhPd5I9fYP+/fABLJrKeZRHjjiQ
         n7rPBTqHm4Vf4mrUDVIHrOo3gnDY7l1hOLaQfmHFT/ZwR4kP/36VJhldpzhHWZIihUfE
         AZOQ==
X-Gm-Message-State: AOAM533U/nZTJ+N5YiPUaGAOVjoLTI+yG1A9wBvxED2bvrT8MxN92Bvt
        o3hrjEWh31CsNJ3mseci5MRFhp45X06cSneMZ4agjfQFj8/7evB53a9H+DdKUHkfc80m95ns95Y
        EIbpQUqBzWY31P/6r
X-Received: by 2002:a05:6402:5190:: with SMTP id q16mr60144589edd.332.1641500453886;
        Thu, 06 Jan 2022 12:20:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx607J+hqfiTtq8mJkPUIsvhlCsEcMGUzayoy5UsP40GeTlwvH/LAzG7BtX60oKed4m1VMzRw==
X-Received: by 2002:a05:6402:5190:: with SMTP id q16mr60144511edd.332.1641500452572;
        Thu, 06 Jan 2022 12:20:52 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 2sm759736ejx.123.2022.01.06.12.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 12:20:52 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 54970181F2A; Thu,  6 Jan 2022 21:20:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: [PATCH bpf-next v5 7/7] selftests/bpf: Add selftest for
 XDP_REDIRECT in bpf_prog_run()
In-Reply-To: <CAADnVQ+6-Q6N1t0UsmF=Rn1yP=KPo7Xc2Fiy1rzJ+Hb0oAr4Hw@mail.gmail.com>
References: <20220103150812.87914-1-toke@redhat.com>
 <20220103150812.87914-8-toke@redhat.com>
 <20220106042027.zy6j4a72nxaqmocw@ast-mbp.dhcp.thefacebook.com>
 <87y23t9blc.fsf@toke.dk>
 <CAADnVQ+j=DO8fMCcpoHmAjrW5sTbhHp_OA4eVpcKcwwRzsvKTA@mail.gmail.com>
 <87tuegafnw.fsf@toke.dk>
 <CAADnVQ+6-Q6N1t0UsmF=Rn1yP=KPo7Xc2Fiy1rzJ+Hb0oAr4Hw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 06 Jan 2022 21:20:51 +0100
Message-ID: <87mtk8aa58.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Jan 6, 2022 at 10:21 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Thu, Jan 6, 2022 at 6:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
>> >>
>> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>> >>
>> >> > On Mon, Jan 03, 2022 at 04:08:12PM +0100, Toke H=C3=B8iland-J=C3=B8=
rgensen wrote:
>> >> >> +
>> >> >> +#define NUM_PKTS 3
>> >> >
>> >> > May be send a bit more than 3 packets?
>> >> > Just to test skb_list logic for XDP_PASS.
>> >>
>> >> OK, can do.
>> >>
>> >> >> +
>> >> >> +    /* We setup a veth pair that we can not only XDP_REDIRECT pac=
kets
>> >> >> +     * between, but also route them. The test packet (defined abo=
ve) has
>> >> >> +     * address information so it will be routed back out the same=
 interface
>> >> >> +     * after it has been received, which will allow it to be pick=
ed up by
>> >> >> +     * the XDP program on the destination interface.
>> >> >> +     *
>> >> >> +     * The XDP program we run with bpf_prog_run() will cycle thro=
ugh all
>> >> >> +     * four return codes (DROP/PASS/TX/REDIRECT), so we should en=
d up with
>> >> >> +     * NUM_PKTS - 1 packets seen on the dst iface. We match the p=
ackets on
>> >> >> +     * the UDP payload.
>> >> >> +     */
>> >> >> +    SYS("ip link add veth_src type veth peer name veth_dst");
>> >> >> +    SYS("ip link set dev veth_src address 00:11:22:33:44:55");
>> >> >> +    SYS("ip link set dev veth_dst address 66:77:88:99:aa:bb");
>> >> >> +    SYS("ip link set dev veth_src up");
>> >> >> +    SYS("ip link set dev veth_dst up");
>> >> >> +    SYS("ip addr add dev veth_src fc00::1/64");
>> >> >> +    SYS("ip addr add dev veth_dst fc00::2/64");
>> >> >> +    SYS("ip neigh add fc00::2 dev veth_src lladdr 66:77:88:99:aa:=
bb");
>> >> >> +    SYS("sysctl -w net.ipv6.conf.all.forwarding=3D1");
>> >> >
>> >> > These commands pollute current netns. The test has to create its ow=
n netns
>> >> > like other tests do.
>> >>
>> >> Right, will fix.
>> >>
>> >> > The forwarding=3D1 is odd. Nothing in the comments or commit logs
>> >> > talks about it.
>> >>
>> >> Hmm, yeah, should probably have added an explanation, sorry about tha=
t :)
>> >>
>> >> > I'm guessing it's due to patch 6 limitation of picking loopback
>> >> > for XDP_PASS and XDP_TX, right?
>> >> > There is ingress_ifindex field in struct xdp_md.
>> >> > May be use that to setup dev and rxq in test_run in patch 6?
>> >> > Then there will be no need to hack through forwarding=3D1 ?
>> >>
>> >> No, as you note there's already ingress_ifindex to set the device, and
>> >> the test does use that:
>> >>
>> >> +       memcpy(skel->rodata->expect_dst, &pkt_udp.eth.h_dest, ETH_ALE=
N);
>> >> +       skel->rodata->ifindex_out =3D ifindex_src;
>> >> +       ctx_in.ingress_ifindex =3D ifindex_src;
>> >
>> > My point is that this ingress_ifindex should be used instead of loopba=
ck.
>> > Otherwise the test_run infra is lying to the xdp program.
>>
>> But it is already using that! There is just no explicit code in patch 6
>> to do that because that was already part of the XDP prog_run
>> functionality.
>>
>> Specifically, the existing bpf_prog_test_run_xdp() will pass the context
>> through xdp_convert_md_to_buff() which will resolve the ifindex and get
>> a dev reference. So the xdp_buff object being passed to the new
>> bpf_test_run_xdp_live() function already has the right device in
>> ctx->rxq.
>
> Got it. Please make it clear in the commit log.

Ah, sorry, already hit send on v6 before I saw this. If you want to fix
up the commit message while applying, how about a paragraph at the end
like:


The new mode reuses the setup code from the existing bpf_prog_run() for
XDP. This means that userspace can set the ingress ifindex and RXQ
number as part of the context object being passed to the kernel, in
which case packets will look like they arrived on that interface when
the test program returns XDP_PASS and the packets go up the stack.

>> No the problem of XDP_PASS going in the opposite direction of XDP_TX and
>> XDP_REDIRECT remains. This is just like on a physical interface: if you
>> XDP_TX a packet it goes back out, if you XDP_PASS it, it goes up the
>> stack. To intercept both after the fact, you need to look in two
>> different places.
>>
>> Anyhow, just using a TC hook for XDP_PASS works fine and gets rid of the
>> forwarding hack; I'll send a v6 with that just as soon as I verify that
>> I didn't break anything when running the traffic generator on bare metal=
 :)
>
> Got it. You mean a tc ingress prog attached to veth_src ? That should wor=
k.

Yup, exactly!

-Toke

