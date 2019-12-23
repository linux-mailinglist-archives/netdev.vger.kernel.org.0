Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E330E129399
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 10:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfLWJZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 04:25:24 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41003 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726034AbfLWJZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 04:25:24 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1670A218C1;
        Mon, 23 Dec 2019 04:25:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 23 Dec 2019 04:25:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=vMMfxu/cPCNvuQ43lK6puzAyRLSCXYLtlGInr9Pdr
        jw=; b=HiOR9fpoB8tE9yUqqMVp9obC48Ts0NfzeUZqRL71Rl7YPwLuAweGP2cuQ
        KLy9uEAdSrXapunvKMaID6/cde0HT9v/MLf+8SF7NwymxKGJVCeWAqCVt4DaOkVR
        RDeyEMvIVvY2+4XtuL5jalQ3AfkBIHGwWQM5hw8WgzO1tP85xsRWw6P7S0GKCnH3
        80Z5Jiy8VoxpWo5dy3XOLRbmGLUaTkjLbAC1yQ2W/hZptBVM5dufcL01cv3jqo7T
        sIOtZV5rzoJf/XF/q5hkoOfqTL8tmSzojqW7yo/FbF4IWxI9M7m5MO9BOd8Y/e8C
        eYscpcXKeajuDqdUQiEBIbfZCJWpA==
X-ME-Sender: <xms:AogAXrMa5GK3Yf2fL6BqJ1TPy2CBg0R_WbI0navIai6FEbPn32WAvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddvtddgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuffhomhgrih
    hnpehkvghrnhgvlhdrohhrghdpghhithhhuhgsrdgtohhmnecukfhppeduleefrdegjedr
    udeihedrvdehudenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughosh
    gthhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:AogAXnwbyefyMoWrJd2SY6XvCBY9_vasxXVASl6nDIyLzBjEAaVb5g>
    <xmx:AogAXsBFB9zx-fQ8ik1KJC0jKobthDh9zz6jkYaDUChOsxr4xX1S7Q>
    <xmx:AogAXg795MxjLxl2BFHdUH2JZIR8XM9ufWNfkSS4uft-rJd3UbL5gQ>
    <xmx:A4gAXjScsjNJ-rF_86ZxPGuyyKq8rp5tJPnaNB7_s-IDlyAeKo1GxA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E9783060A6E;
        Mon, 23 Dec 2019 04:25:22 -0500 (EST)
Date:   Mon, 23 Dec 2019 11:25:20 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [RFC PATCH bpf-next] xdp: Add tracepoint on XDP program return
Message-ID: <20191223092520.GA838734@splinter>
References: <20191216152715.711308-1-toke@redhat.com>
 <CAJ+HfNhYG_hzuFzX5sAH7ReotLtZWTP_9D2jA_iVMg+jUtXXCw@mail.gmail.com>
 <20191217005944.s3mayy473ldlnldl@ast-mbp.dhcp.thefacebook.com>
 <87h81z8hcd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87h81z8hcd.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 09:52:02AM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Mon, Dec 16, 2019 at 07:17:59PM +0100, Björn Töpel wrote:
> >> On Mon, 16 Dec 2019 at 16:28, Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >> >
> >> > This adds a new tracepoint, xdp_prog_return, which is triggered at every
> >> > XDP program return. This was first discussed back in August[0] as a way to
> >> > hook XDP into the kernel drop_monitor framework, to have a one-stop place
> >> > to find all packet drops in the system.
> >> >
> >> > Because trace/events/xdp.h includes filter.h, some ifdef guarding is needed
> >> > to be able to use the tracepoint from bpf_prog_run_xdp(). If anyone has any
> >> > ideas for how to improve on this, please to speak up. Sending this RFC
> >> > because of this issue, and to get some feedback from Ido on whether this
> >> > tracepoint has enough data for drop_monitor usage.
> >> >
> >> 
> >> I get that it would be useful, but can it be solved with BPF tracing
> >> (i.e. tracing BPF with BPF)? It would be neat not adding another
> >> tracepoint in the fast-path...
> >
> > That was my question as well.
> > Here is an example from Eelco:
> > https://lore.kernel.org/bpf/78D7857B-82E4-42BC-85E1-E3D7C97BF840@redhat.com/
> > BPF_TRACE_2("fexit/xdp_prog_simple", trace_on_exit,
> >              struct xdp_buff*, xdp, int, ret)
> > {
> >      bpf_debug("fexit: [ifindex = %u, queue =  %u, ret = %d]\n",
> >                xdp->rxq->dev->ifindex, xdp->rxq->queue_index, ret);
> >
> >      return 0;
> > }
> > 'ret' is return code from xdp program.
> > Such approach is per xdp program, but cheaper when not enabled
> > and faster when it's triggering comparing to static tracepoint.
> > Anything missing there that you'd like to see?
> 
> For userspace, sure, the fentry/fexit stuff is fine. The main use case
> for this new tracepoint is to hook into the (in-kernel) drop monitor.
> Dunno if that can be convinced to hook into the BPF tracing
> infrastructure instead of tracepoints. Ido, WDYT?

Hi Toke,

Sorry for the delay. I wasn't available most of last week.

Regarding the tracepoint, the data it provides seems sufficient to me.
Regarding the fentry/fexit stuff, it would be great to hook it into drop
monitor, but I'm not sure how to do that at this point. It seems that at
minimum user would need to pass the XDP programs that need to be traced?

FYI, I'm not too happy with the current way of capturing the events via
nlmon, so I started creating a utility to directly output the events to
pcap [1] (inspired by Florian's nfqdump). Will send a pull request to
Neil when it's ready. You can do:

# dwdump -w /dev/stdout | tshark -V -r -

A recent enough wireshark will correctly dissect these events. My next
step is to add '--unique' which will load an eBPF program on the socket
and only allow unique events to be enqueued. The program will store
{5-tuple, IP/drop reason} in LRU hash with corresponding count. I can
then instrument the application for Prometheus so that it will export
the contents of the map as metrics.

Please let me know if you have more suggestions.

[1] https://github.com/idosch/dropwatch/blob/dwdump/src/dwdump.c
