Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B578B6A4DB4
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 23:04:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjB0WEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 17:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230039AbjB0WEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 17:04:10 -0500
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66C326857;
        Mon, 27 Feb 2023 14:04:09 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id EA43332009A2;
        Mon, 27 Feb 2023 17:04:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 27 Feb 2023 17:04:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1677535448; x=1677621848; bh=BH7D1uVe+U
        vXxR2ch7fmh4n2whiW+tHnGTL+k/yaf4k=; b=ia2r8Ur9f4UChidSH9WsvSJC8f
        McuH62e6yJszVW7lU5TuvZ4wouqBMnydIoU1+Jqx7r/MGzD1hEV1gcstDOXsF8uL
        RYHSaSIwN1j/yULFJpC3UiUr1CpiV8gtxpc1vRh0iXt+gw9OfnoXk9VBxpfMIktN
        ipBPFO2Gy95ckscu+48IBTV2zW2JAqvSy48egtVkmJYdSNNqB1KghZQ2AwdGQilC
        ESYsPiMDByJDvT/qi5/ItGlW7Tf/KvAMtiqMG6oPP1Z0QYaPD+6NTcZydsNphhJK
        DupgWZvxytH124UQEieOs1aS6D+xg5YTaCZ4D1QDhjpU6v9hvG+GEIYx34rQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677535448; x=1677621848; bh=BH7D1uVe+UvXxR2ch7fmh4n2whiW
        +tHnGTL+k/yaf4k=; b=CctWlY8a8UTVKyYFiF22Kwg9kr79rdbggh1333KcSlPx
        m/hJGLKTrt1+bM0oanS3aMZciOCiL+JudiO9G8u6xQqQG3M48mWVPG26HGI626qW
        bksoUtiijiWTRrIwHHlMOaTVlX0hgV1BMWkoXinkvZBYlMndFV9L15xONjeK79rB
        HsjJt0szDTpMEG3FIS0CV0kCjzDalNN7dc/VUFWJRPJUQAZfvOoJ0ViziEJ6NPGp
        PPOCCEV7DlQKGZijtVO+YYczzHk8Sm2/BdPZPJlyiAieXeAm0Fk6vgoI0J4+dCqY
        Zkf8ZKCGRkQfqyZuYGuGSF5ATe62R/Qkd4NCzK1lVw==
X-ME-Sender: <xms:2Cj9Yz1CB0es4Kv3rPybFqO0kTfP652fR9bCBhqRFPu6UO2bTxuDsg>
    <xme:2Cj9YyEezAFpxERaGtfwIcAWjQ99SZia54F6y5XFiFlnGevhq2AG6xKpEaJwvFMTI
    Urx_36url7HVGTogQ>
X-ME-Received: <xmr:2Cj9Yz7SxoLXnawA_clG6n6BzZ0zkqbCfOnc9dXWNhZkhFrj7qvbfyhUux2RbUYY6IIechcxtS1WsJWwJ_5ikVqY8Mp3m2fez1n1TMc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeltddgudehvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhepff
    fhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpeevuddugeeihfdtff
    ehgffgudeggeegheetgfevhfekkeeileeuieejleekiedvgfenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:2Cj9Y42klikwa-jznNgKW_MBKnkM_LoLfcWpmrDFSdOxA8NvYUAeAQ>
    <xmx:2Cj9Y2GCOkGvIX49d1B3nIJwhs-T701Qf0CXh1BjmWOCNf6Am8bdqg>
    <xmx:2Cj9Y59FXyfXkKZFM6-ih1vWL3XVIxa4iyWG1pm1HDo5DZzZFmtnyA>
    <xmx:2Cj9YygNc_gARHIahPExwCt3fh3IHobAg1L3360sjATyPp0tiVWqRw>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Feb 2023 17:04:07 -0500 (EST)
Date:   Mon, 27 Feb 2023 15:04:06 -0700
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets
 in BPF
Message-ID: <20230227220406.4x45jcigpnjjpdfy@kashmir.localdomain>
References: <cover.1677526810.git.dxu@dxuuu.xyz>
 <cf49a091-9b14-05b8-6a79-00e56f3019e1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf49a091-9b14-05b8-6a79-00e56f3019e1@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ed,

Thanks for giving this a look.

On Mon, Feb 27, 2023 at 08:38:41PM +0000, Edward Cree wrote:
> On 27/02/2023 19:51, Daniel Xu wrote:
> > However, when policy is enforced through BPF, the prog is run before the
> > kernel reassembles fragmented packets. This leaves BPF developers in a
> > awkward place: implement reassembly (possibly poorly) or use a stateless
> > method as described above.
> 
> Just out of curiosity - what stops BPF progs using the middle ground of
>  stateful validation?  I'm thinking of something like:
> First-frag: run the usual checks on L4 headers etc, if we PASS then save
>  IPID and maybe expected next frag-offset into a map.  But don't try to
>  stash the packet contents anywhere for later reassembly, just PASS it.
> Subsequent frags: look up the IPID in the map.  If we find it, validate
>  and update the frag-offset in the map; if this is the last fragment then
>  delete the map entry.  If the frag-offset was bogus or the IPID wasn't
>  found in the map, DROP; otherwise PASS.
> (If re-ordering is prevalent then use something more sophisticated than
>  just expected next frag-offset, but the principle is the same. And of
>  course you might want to put in timers for expiry etc.)
> So this avoids the need to stash the packet data and modify/consume SKBs,
>  because you're not actually doing reassembly; the down-side is that the
>  BPF program can't so easily make decisions about the application-layer
>  contents of the fragmented datagram, but for the common case (we just
>  care about the 5-tuple) it's simple enough.
> But I haven't actually tried it, so maybe there's some obvious reason why
>  it can't work this way.

I don't believe full L4 headers are required in the first fragment.
Sufficiently sneaky attackers can, I think, send a byte at a time to
subvert your proposed algorithm. Storing skb data seems inevitable here.
Someone can correct me if I'm wrong here.

Reordering like you mentioned is another attack vector. Perhaps there
are more sophisticated semi-stateful algorithms that can solve the
problem, but it leads me to my next point.

A semi-stateful method like you are proposing is concerning to me from a
reliability and correctness stand point. Such a method can suffer from
impedance mismatches with the rest of the system. For example, whatever
map sizes you choose should probably be aligned with sysfs conntrack
values otherwise you may get some very interesting and unexpected pkt
drops. I think cilium had a talk about debugging a related conntrack
issue in the same vein a while ago. Furthermore, the debugging and
troubleshooting facilities will be different (counters, logs, etc).

Unless someone has had lots of experience writing an ip stack from
the ground up, I suspect there are quite a few more unknown-unknowns
here. What I find valuable about this patch series is that we can
leverage the well understood and battle hardened kernel facilities. So
avoid all the correctness and security issues that the kernel has spent
20+ years fixing. And make it trivial for the next person that comes
along to do the right thing.

Hopefully this all makes sense.

Thanks,
Daniel
