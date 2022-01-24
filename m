Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D59F499EB6
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 00:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383277AbiAXWmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 17:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588118AbiAXWbh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 17:31:37 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4820AC02B869
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:56:11 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id d10so24911419eje.10
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PXXWYqQ+OHmAmIfanlX1WgJr55Hoqmk3V7j28R+7R5M=;
        b=VBbFxR3IHW5AJtYnaHr9MtP4KkdoeW++K0tkwQL2isqg8ieEMvLKp1Iq8icHNL1Mz0
         5WYzj2ATC9Wu6HzP5bdhXFpF9kBQ7hcPBQXNt0MbFwmot0n2nJ7i8rK7iKbl/vGeaGpp
         R1S5bpeQjQB7kKHDNqQUYoZ092f1JYri+RQhSUIYWASsYqp4e031WpgxczmY+vArQ8JW
         ye0ZcGiRB2c98ncGhxQ+T/dASd8gjbqyiDgn5B6tFTSmUGQMDjHUd3p5QhaplvYpbW7X
         380qb/KjBBX46clxldPrWqsNNUS+urHlWt4dlMj6RnhcHL+KqdicJpMnv1jh+Sg/vd9+
         Ovzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PXXWYqQ+OHmAmIfanlX1WgJr55Hoqmk3V7j28R+7R5M=;
        b=8LpcJ7CKY2vBEw3XSIY1RhDdskEhN1iC6LgLC8JDqGLTNBHRNyx4R9MYOomWBUTome
         0A9o4QO+wEPideRPrSfngvhJHeuhKLEJLZepCFBOqstQDgWBEwiYvZw6MYlKkoYlPOAQ
         B2JJlCVvnWu+AFnnap6BOMnIF2VPQJxwwCTlw0oObMWH6e70N53urW3gbDgRjnd2s9AE
         /kt41Af/8s21o4SjVHH+xfRdZFdgDQDjcJyirbUmDdzVXb1szwB7MbDPKew0gqU5mvyL
         iLHko1zL9QBB/kVmG5yti6cUJoDZeHId1lPvrqRNbOmlhkB35cHkZWpXHf+Uyk0/Ci/A
         p4zg==
X-Gm-Message-State: AOAM5329tHXRVey/M6cSBFYmBgDzykZNnpfuVT+DfOygw/LKMBhzt3qf
        ulNKdszyl94zPKaImFDBm98=
X-Google-Smtp-Source: ABdhPJwx0GPrui5SFXB23A0+v9KRd7v4cUJ88VNCZfgjiXOYCYpI9NDLkMneHyuUdruaN6Ihil5mKA==
X-Received: by 2002:a17:907:9495:: with SMTP id dm21mr13545950ejc.467.1643057769455;
        Mon, 24 Jan 2022 12:56:09 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id h3sm5257566ejl.193.2022.01.24.12.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:56:08 -0800 (PST)
Date:   Mon, 24 Jan 2022 22:56:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Message-ID: <20220124205607.kugsccikzgmbdgmf@skbuf>
References: <CAJq09z6aYKhjdXm_hpaKm1ZOXNopP5oD5MvwEmgRwwfZiR+7vg@mail.gmail.com>
 <20220124153147.agpxxune53crfawy@skbuf>
 <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124165535.tksp4aayeaww7mbf@skbuf>
 <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
 <20220124172158.tkbfstpwg2zp5kaq@skbuf>
 <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124190845.md3m2wzu7jx4xtpr@skbuf>
 <20220124113812.5b75eaab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124113812.5b75eaab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 11:38:12AM -0800, Jakub Kicinski wrote:
> On Mon, 24 Jan 2022 21:08:45 +0200 Vladimir Oltean wrote:
> > On Mon, Jan 24, 2022 at 10:20:51AM -0800, Jakub Kicinski wrote:
> > > On Mon, 24 Jan 2022 09:35:56 -0800 Jakub Kicinski wrote:
> > > > Sorry I used "geometry" loosely.
> > > >
> > > > What I meant is simply that if the driver uses NETIF_F_IP*_CSUM
> > > > it should parse the packet before it hands it off to the HW.
> > > >
> > > > There is infinity of protocols users can come up with, while the device
> > > > parser is very much finite, so it's only practical to check compliance
> > > > with the HW parser in the driver. The reverse approach of adding
> > > > per-protocol caps is a dead end IMO. And we should not bloat the stack
> > > > when NETIF_F_HW_CSUM exists and the memo that parsing packets on Tx is
> > > > bad b/c of protocol ossification went out a decade ago.
> > >
> > > > It's not about DSA. The driver should not check
> > > >
> > > > if (dsa())
> > > > 	blah;
> > > >
> > > > it should check
> > > >
> > > > if (!(eth [-> vlan] -> ip -> tcp/udp))
> > > > 	csum_help();
> > >
> > > Admittedly on a quick look thru the drivers which already do this
> > > I only see L3, L4 and GRE/UDP encap checks. Nothing validates L2.
> >
> > So before we declare that any given Ethernet driver is buggy for declaring
> > NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM and not checking that skb->csum_start
> > points where it expects it to (taking into consideration potential VLAN
> > headers, IPv6 extension headers),
>
> Extension headers are explicitly not supported by NETIF_F_IPV6_CSUM.
>
> IIRC Tom's hope was to delete NETIF_F_IP*_CSUM completely once all
> drivers are converted to parsing and therefore can use NETIF_F_HW_CSUM.

IIUC, NETIF_F_IP*_CSUM vs NETIF_F_HW_CSUM doesn't make that big of a
difference in terms of what the driver should check for, if the hardware
checksum offload engine can't directly be given the csum_start and
csum_offset, wherever they may be.

> > is there any driver that _does_ perform these checks correctly, that
> > could be used as an example?
>
> I don't think so. Let me put it this way - my understanding is that up
> until now we had been using the vlan_features, mpls_features etc to
> perform L2/L2.5/below-IP feature stripping. This scales poorly to DSA
> tags, as discussed in this thread.
>
> I'm suggesting we extend the kind of checking we already do to work
> around inevitable deficiencies of device parsers for tunnels to DSA
> tags.

Sorry, I'm very tired and I probably don't understand what you're
saying, so excuse the extra clarification questions.

The typical protocol checking that drivers with NETIF_F_HW_CSUM do seems
to be based on vlan_get_protocol()/skb->protocol/skb_network_header()/
skb_transport_header() values, all of which make DSA invisible. So they
don't work if the underlying hardware really doesn't like seeing an
unexpected DSA header.

When you say "I'm suggesting we extend the kind of checking we already do",
do you mean we should modify the likes of e1000e and igb such that, if
they're ever used as DSA masters, they do a full header parse of the
packet (struct ethhdr :: h_proto, check if VLAN, struct iphdr/ipv6hdr,
etc.) instead of the current logic? It will be pretty convoluted unless
we have some helper. Because if I follow through, for a DSA-tagged IP
packet on xmit, skb->protocol is certainly htons(ETH_P_IP):

ntohs(skb->protocol) = 0x800, csum_offset = 16, csum_start = 280, skb_checksum_start_offset = 54, skb->network_header = 260, skb_network_header_len = 20

skb_dump output:
skb len=94 headroom=226 headlen=94 tailroom=384
mac=(226,34) net=(260,20) trans=280
shinfo(txflags=0 nr_frags=0 gso(size=0 type=1 segs=1))
csum(0x100118 ip_summed=3 complete_sw=0 valid=0 level=0)
hash(0x7710ee84 sw=0 l4=1) proto=0x0800 pkttype=0 iif=0
dev name=eno2 feat=0x00020100001149a9
sk family=2 type=1 proto=6
skb headroom: 00000000: 6c 00 03 02 64 65 76 00 fe ed ca fe 28 00 00 00
...(junk)...
skb headroom: 000000e0: 5f 43
                        20 byte DSA tag
                        |
                        v
skb linear:   00000000: 88 80 00 0a 80 00 00 00 00 00 00 00 08 00 30 00
                                    skb_mac_header()
                                    |
                                    v
skb linear:   00000010: 00 00 00 00 68 05 ca 92 af 20 00 04 9f 05 f6 28
                              skb_network_header()
                              |
                              v
skb linear:   00000020: 08 00 45 00 00 3c 26 47 40 00 40 06 00 49 0a 00
                                          skb_checksum_start_offset
                                          |
                                          |                       csum_offset
                                          v                       v
skb linear:   00000030: 00 2c 0a 00 00 01 b6 08 14 51 11 1f 91 4f 00 00
skb linear:   00000040: 00 00 a0 02 fa f0 14 5b 00 00 02 04 05 b4 04 02
skb linear:   00000050: 08 0a 2e 00 e5 b8 00 00 00 00 01 03 03 07

I don't know, I just don't expect that non-DSA users of those drivers
will be very happy about such changes. Do these existing protocol
checking schemes qualify as buggy?

If this is the convention that we want to enforce, then I can't really
help Luiz with fixing the OpenWRT mtk_eth_soc.c - he'll have to figure
out a way to parse the packets for which his hardware will accept the
checksumming offload, and call skb_checksum_help() otherwise.

> We can come up with various schemes of expressing capabilities
> between underlying driver and tag driver. I'm not aware of similar
> out-of-band schemes existing today so it'd be "DSA doing it's own
> thing", which does not seem great.

It at least seems less complex to me, and less checking in the fast path
if I understand everything that's been said correctly.
