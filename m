Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC91A4869AF
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 19:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbiAFSVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 13:21:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242676AbiAFSVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 13:21:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641493306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZIrk+bfFu7JK7es/+sJfTXkxXQZhqqBoOQaxDDJ4K7g=;
        b=ZZn1byIGRP3OnljeufsGIMsSvA7XryXRHZqLMkqOH/AdV1o5MLLOHOzQgVvIWy+Peb4kDI
        oxnvpjwrkhCnpkxNBjDr6WlRxEKMo89tLNngWMrXLfVDmk5y+GD6CWPpUVoMiMvqHhU36x
        atnRSclZgYpYokxmv/CPPGhZ126hgr4=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-rIybZupRNkWhx_GoXEvQ0Q-1; Thu, 06 Jan 2022 13:21:45 -0500
X-MC-Unique: rIybZupRNkWhx_GoXEvQ0Q-1
Received: by mail-ed1-f70.google.com with SMTP id i5-20020a05640242c500b003f84839a8c3so2605636edc.6
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 10:21:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=ZIrk+bfFu7JK7es/+sJfTXkxXQZhqqBoOQaxDDJ4K7g=;
        b=1OngfkywWso6ATKAs3cducDMn10lVhCjGSFHXAt2bcOm7SDesg/v2xWgmELxvoDcr/
         hqjXl0sODK4Kgad2YSnPpc2Kh9f73r0k2fd4zyY013fD7f8zLec5mI0ziIH38+Oxt5FC
         ERHbWGXGUosKS4JCViZFUBs+bqTo8S1IevOcvP3O36yqADWGu0APzkahJjqCIMZSX8uc
         fQIgfR2HZzttAPrlZum3Oyg9w5o9jGw+ytxP20WCrp+Ay54RzFWer9KiILf/iUenp6Vq
         YLvTfsgp2H0QvSv60kdotAMizkw/MnwntElnmsZfyO2k6g7yjShtfBcXQRMyr82CQjTZ
         4QQg==
X-Gm-Message-State: AOAM532uf/1kDYTkkBaN8vuKXSyT3QFZUPDQ7vSFyII8NutqmkpldR/s
        pZ5510LIELrDjAJ1tgUzXVYRiVD/XNkVdaBB1SDd86ODtjrqj9hx1SFr2h4HHlknipBAHSCGbBT
        66CkcNEHANlz6th5M
X-Received: by 2002:a05:6402:128e:: with SMTP id w14mr57918102edv.161.1641493303022;
        Thu, 06 Jan 2022 10:21:43 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxWddGHE5gYcGtu0TY/FiDON2PbAvku8S1l5WCHmXgXN6WJ4tE/0bTGd0asV9ALstp2FQxUgQ==
X-Received: by 2002:a05:6402:128e:: with SMTP id w14mr57918024edv.161.1641493301924;
        Thu, 06 Jan 2022 10:21:41 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h10sm1031718edj.1.2022.01.06.10.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 10:21:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 40DA1181F2A; Thu,  6 Jan 2022 19:21:39 +0100 (CET)
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
In-Reply-To: <CAADnVQ+j=DO8fMCcpoHmAjrW5sTbhHp_OA4eVpcKcwwRzsvKTA@mail.gmail.com>
References: <20220103150812.87914-1-toke@redhat.com>
 <20220103150812.87914-8-toke@redhat.com>
 <20220106042027.zy6j4a72nxaqmocw@ast-mbp.dhcp.thefacebook.com>
 <87y23t9blc.fsf@toke.dk>
 <CAADnVQ+j=DO8fMCcpoHmAjrW5sTbhHp_OA4eVpcKcwwRzsvKTA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 06 Jan 2022 19:21:39 +0100
Message-ID: <87tuegafnw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Thu, Jan 6, 2022 at 6:34 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Mon, Jan 03, 2022 at 04:08:12PM +0100, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> >> +
>> >> +#define NUM_PKTS 3
>> >
>> > May be send a bit more than 3 packets?
>> > Just to test skb_list logic for XDP_PASS.
>>
>> OK, can do.
>>
>> >> +
>> >> +    /* We setup a veth pair that we can not only XDP_REDIRECT packets
>> >> +     * between, but also route them. The test packet (defined above)=
 has
>> >> +     * address information so it will be routed back out the same in=
terface
>> >> +     * after it has been received, which will allow it to be picked =
up by
>> >> +     * the XDP program on the destination interface.
>> >> +     *
>> >> +     * The XDP program we run with bpf_prog_run() will cycle through=
 all
>> >> +     * four return codes (DROP/PASS/TX/REDIRECT), so we should end u=
p with
>> >> +     * NUM_PKTS - 1 packets seen on the dst iface. We match the pack=
ets on
>> >> +     * the UDP payload.
>> >> +     */
>> >> +    SYS("ip link add veth_src type veth peer name veth_dst");
>> >> +    SYS("ip link set dev veth_src address 00:11:22:33:44:55");
>> >> +    SYS("ip link set dev veth_dst address 66:77:88:99:aa:bb");
>> >> +    SYS("ip link set dev veth_src up");
>> >> +    SYS("ip link set dev veth_dst up");
>> >> +    SYS("ip addr add dev veth_src fc00::1/64");
>> >> +    SYS("ip addr add dev veth_dst fc00::2/64");
>> >> +    SYS("ip neigh add fc00::2 dev veth_src lladdr 66:77:88:99:aa:bb"=
);
>> >> +    SYS("sysctl -w net.ipv6.conf.all.forwarding=3D1");
>> >
>> > These commands pollute current netns. The test has to create its own n=
etns
>> > like other tests do.
>>
>> Right, will fix.
>>
>> > The forwarding=3D1 is odd. Nothing in the comments or commit logs
>> > talks about it.
>>
>> Hmm, yeah, should probably have added an explanation, sorry about that :)
>>
>> > I'm guessing it's due to patch 6 limitation of picking loopback
>> > for XDP_PASS and XDP_TX, right?
>> > There is ingress_ifindex field in struct xdp_md.
>> > May be use that to setup dev and rxq in test_run in patch 6?
>> > Then there will be no need to hack through forwarding=3D1 ?
>>
>> No, as you note there's already ingress_ifindex to set the device, and
>> the test does use that:
>>
>> +       memcpy(skel->rodata->expect_dst, &pkt_udp.eth.h_dest, ETH_ALEN);
>> +       skel->rodata->ifindex_out =3D ifindex_src;
>> +       ctx_in.ingress_ifindex =3D ifindex_src;
>
> My point is that this ingress_ifindex should be used instead of loopback.
> Otherwise the test_run infra is lying to the xdp program.

But it is already using that! There is just no explicit code in patch 6
to do that because that was already part of the XDP prog_run
functionality.

Specifically, the existing bpf_prog_test_run_xdp() will pass the context
through xdp_convert_md_to_buff() which will resolve the ifindex and get
a dev reference. So the xdp_buff object being passed to the new
bpf_test_run_xdp_live() function already has the right device in
ctx->rxq.

I'll add a check for this to the selftest to make it explicit.

>> I enable forwarding because the XDP program that counts the packets is
>> running on the other end of the veth pair (on veth_dst), while the
>> traffic gen is using veth_src as its ingress ifindex. So for XDP_TX and
>> XDP_REDIRECT we send the frame back out the veth device, and it ends up
>> being processed by the XDP program on veth_dst, and counted.
>
> Not for XDP_TX. If I'm reading patch 6 correctly it gets xmited
> out of loopback.

See above.

>> But when
>> the test program returns XDP_PASS, the packet will go up the frame; so
>> to get it back to the counting program I enable forwarding and set the
>> packet dst IP so that the stack routes it back out the same interface.
>>
>> I'll admit this is a bit hacky; I guess I can add a second TC ingress
>> program that will count the packets being XDP_PASS'ed instead...
>
> No. Please figure out how to XDP_PASS and XDP_TX without enabling forward
> and counting in different places.
> imo the forwarding hides the issue in the design that should be addressed.
> When rx ifindex is an actual ifindex given by user space instead of
> loopback all problems go away.

No the problem of XDP_PASS going in the opposite direction of XDP_TX and
XDP_REDIRECT remains. This is just like on a physical interface: if you
XDP_TX a packet it goes back out, if you XDP_PASS it, it goes up the
stack. To intercept both after the fact, you need to look in two
different places.

Anyhow, just using a TC hook for XDP_PASS works fine and gets rid of the
forwarding hack; I'll send a v6 with that just as soon as I verify that
I didn't break anything when running the traffic generator on bare metal :)

-Toke

