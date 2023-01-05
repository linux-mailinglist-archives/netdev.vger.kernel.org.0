Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146DB65F0F4
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 17:18:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234893AbjAEQSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 11:18:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234881AbjAEQST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 11:18:19 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE59F4E412
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 08:18:17 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id c9so20788029pfj.5
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 08:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NmOnbvbzPsM3UBiTW8b7sIm8/4Px8e8NnuSYjmEBarA=;
        b=BummfiJYiUs36pY/vWeArXspdkcludEXNneoXDD/35V7VoUFCzQxFkZbgfUOLFkmPq
         qbz0vVgmTCbdPwTSCST3fqYwqsNNgRt96ZraiCvzauKP+cbOgdtMk9s1yY/h57MCiQ2y
         x6MMnZ23MGyWfDSNTKm69Y1BIrVNDoVNK4G9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NmOnbvbzPsM3UBiTW8b7sIm8/4Px8e8NnuSYjmEBarA=;
        b=xF1fIx2R3Db9ZdPnDxWPjGfooL/FFAbj7qeXb/vn5KmDkwPcEAQog0OIGa/yJI9g01
         9RZ/BEgsvwDzIdIGhJDNrJDrciVa3brNYBJJBEGU97rH0Mk4XW8b6NcbCpO6+3v0kcjd
         /UyDhBgrbA8594x3G86v0JwpiF6Gqs/pXuWVN8XOZoNcESi0Oj1L6a5FR90zOnaRwtUb
         nBJlLXBP2WyRCcdIHKcN7KwYwPn54uW1qKYIlu4Y6piHqS1OxAKVK6DP0yrMkhkkd9U5
         vs+n1EgY62526UnjEbMbzBfKvnqzfUJuThdA3Dj+TL0GQw2V17i8+TkSPUQTMtgABK6L
         PIhw==
X-Gm-Message-State: AFqh2kqSikfRBiGBfzSOzzo7hhxrQeffD0A8A6IZTvnQjFZNFaPH+u8l
        hWUbt7DvlwCZD4gUt+XIQ7zohg==
X-Google-Smtp-Source: AMrXdXuXs24lvc5njAw1w5c4pxtYAKZk7O0A/9WswXqvoQjWus1dNuO2ckV5SA0LBtcyjxoqInduEg==
X-Received: by 2002:a05:6a00:706:b0:580:d409:396c with SMTP id 6-20020a056a00070600b00580d409396cmr46023525pfl.6.1672935497059;
        Thu, 05 Jan 2023 08:18:17 -0800 (PST)
Received: from C02YVCJELVCG.dhcp.broadcom.net ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id f26-20020aa7969a000000b0058103f45d9esm18129874pfk.82.2023.01.05.08.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 08:18:16 -0800 (PST)
From:   Andy Gospodarek <andrew.gospodarek@broadcom.com>
X-Google-Original-From: Andy Gospodarek <gospo@broadcom.com>
Date:   Thu, 5 Jan 2023 11:18:06 -0500
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, toke@redhat.com, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Message-ID: <Y7b4Pj0ASpV7Z8TS@C02YVCJELVCG.dhcp.broadcom.net>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 03, 2023 at 02:55:22PM +0200, Tariq Toukan wrote:
> 
> 
> On 21/06/2022 20:54, Andy Gospodarek wrote:
> > This changes the section name for the bpf program embedded in these
> > files to "xdp.frags" to allow the programs to be loaded on drivers that
> > are using an MTU greater than PAGE_SIZE.  Rather than directly accessing
> > the buffers, the packet data is now accessed via xdp helper functions to
> > provide an example for those who may need to write more complex
> > programs.
> > 
> > v2: remove new unnecessary variable
> > 
> 
> Hi,
> 
> I'm trying to understand if there are any assumptions/requirements on the
> length of the xdp_buf linear part when passed to XDP multi-buf programs?
> Can the linear part be empty, with all data residing in the fragments? Is it
> valid?

That's a great question.  The implementation in bnxt_en was based on the
implementation as I understood it in mvneta where the linear area
contained approx the first 4k of data - xdp headroom - dma_offset.  This
means that you have something that looks like this with a 9k MTU:

skb->data	[~3.6k of packet data]
skb->frag[0]	[4k of paket data]
     frag[1]	[remainder of packet data]

At some point, I'd like to take the opportunity to test something like
this:

skb->data	[header only + space for header expansion]
skb->frag[0]	[first 4k of data]
     frag[1]	[second 4k of data]
     frag[2]	[remainder of packet data]

Though this will use a bit more memory, I think it will be much more
performant for data that is ultimately consumed rather than forwarded
by the host as the actual packet data will be aligned on page boundaries.

With the ability to have packets that are handled by an XDP program
span buffers, I would also like to test out whether or not it would be
worthwhile to have standard MTU packets also look like this:

skb->data	[header only + space for header expansion]
skb->frag[0]	[packet data]

I think the overall system performance would be better in the XDP_PASS
case, but until there is data to back this up, that's just speculation. 

> Per the proposed pattern below (calling bpf_xdp_load_bytes() to memcpy
> packet data into a local buffer), no such assumption is required, and an
> xdp_buf created by the driver with an empty linear part is valid.
> 
> However, in the _xdp_tx_iptunnel example program, it fails (returns
> XDP_DROP) in case the headers are not in the linear part.
> 
> Regards,
> Tariq
> 
> > Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >   samples/bpf/xdp1_kern.c            | 11 ++++++++---
> >   samples/bpf/xdp2_kern.c            | 11 ++++++++---
> >   samples/bpf/xdp_tx_iptunnel_kern.c |  2 +-
> >   3 files changed, 17 insertions(+), 7 deletions(-)
> > 
> > diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
> > index f0c5d95084de..0a5c704badd0 100644
> > --- a/samples/bpf/xdp1_kern.c
> > +++ b/samples/bpf/xdp1_kern.c
> > @@ -39,11 +39,13 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
> >   	return ip6h->nexthdr;
> >   }
> > -SEC("xdp1")
> > +#define XDPBUFSIZE	64
> > +SEC("xdp.frags")
> >   int xdp_prog1(struct xdp_md *ctx)
> >   {
> > -	void *data_end = (void *)(long)ctx->data_end;
> > -	void *data = (void *)(long)ctx->data;
> > +	__u8 pkt[XDPBUFSIZE] = {};
> > +	void *data_end = &pkt[XDPBUFSIZE-1];
> > +	void *data = pkt;
> >   	struct ethhdr *eth = data;
> >   	int rc = XDP_DROP;
> >   	long *value;
> > @@ -51,6 +53,9 @@ int xdp_prog1(struct xdp_md *ctx)
> >   	u64 nh_off;
> >   	u32 ipproto;
> > +	if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)))
> > +		return rc;
> > +
> >   	nh_off = sizeof(*eth);
> >   	if (data + nh_off > data_end)
> >   		return rc;
> > diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
> > index d8a64ab077b0..3332ba6bb95f 100644
> > --- a/samples/bpf/xdp2_kern.c
> > +++ b/samples/bpf/xdp2_kern.c
> > @@ -55,11 +55,13 @@ static int parse_ipv6(void *data, u64 nh_off, void *data_end)
> >   	return ip6h->nexthdr;
> >   }
> > -SEC("xdp1")
> > +#define XDPBUFSIZE	64
> > +SEC("xdp.frags")
> >   int xdp_prog1(struct xdp_md *ctx)
> >   {
> > -	void *data_end = (void *)(long)ctx->data_end;
> > -	void *data = (void *)(long)ctx->data;
> > +	__u8 pkt[XDPBUFSIZE] = {};
> > +	void *data_end = &pkt[XDPBUFSIZE-1];
> > +	void *data = pkt;
> >   	struct ethhdr *eth = data;
> >   	int rc = XDP_DROP;
> >   	long *value;
> > @@ -67,6 +69,9 @@ int xdp_prog1(struct xdp_md *ctx)
> >   	u64 nh_off;
> >   	u32 ipproto;
> > +	if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)))
> > +		return rc;
> > +
> >   	nh_off = sizeof(*eth);
> >   	if (data + nh_off > data_end)
> >   		return rc;
> > diff --git a/samples/bpf/xdp_tx_iptunnel_kern.c b/samples/bpf/xdp_tx_iptunnel_kern.c
> > index 575d57e4b8d6..0e2bca3a3fff 100644
> > --- a/samples/bpf/xdp_tx_iptunnel_kern.c
> > +++ b/samples/bpf/xdp_tx_iptunnel_kern.c
> > @@ -212,7 +212,7 @@ static __always_inline int handle_ipv6(struct xdp_md *xdp)
> >   	return XDP_TX;
> >   }
> > -SEC("xdp_tx_iptunnel")
> > +SEC("xdp.frags")
> >   int _xdp_tx_iptunnel(struct xdp_md *xdp)
> >   {
> >   	void *data_end = (void *)(long)xdp->data_end;
