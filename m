Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B6B5226C8
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbiEJWVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235631AbiEJWVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:21:07 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4DD60040;
        Tue, 10 May 2022 15:21:05 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id a21so459793edb.1;
        Tue, 10 May 2022 15:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bvOJEKEeTYGez3WYVMGA06O7z2nPgT8wUayrfQSacqo=;
        b=Xu6VPNk9lS6SHNbPoG0KD70TMmfwpkx73eO6c+4JBRTPJYX8D4zo+zfH9+NY6Ed3UW
         feQ7pGUXMgliDUim8/ry6bDBQH13HgnwB5zLTmTDxn6MB2CLPVzIEvlNzDDnJKEYJFRn
         s9azdkkGBys/sbeNfnasr0Pl40P3dILNYM72nI3LykjZisuEU94UHdHBt6NPvgkvVpbF
         c3FKAe6b9DOInAxTizW8WTwmFd7/MsdB6YIVLD+J88IQ/5Qc4pvEtrnHyPEb87YIehBk
         v0cUoaucn0wLvrNh0xdm41LmFuuOIm13760kNkl6Hvd8gdBVmd2iyeIauT/lV8fzslLh
         djTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bvOJEKEeTYGez3WYVMGA06O7z2nPgT8wUayrfQSacqo=;
        b=GHcNCF6Rcb4gXOCzXKyU9RdnOStlClS9S3qC+6bjmeNBedOPvKMso+DO/gFK8ckYm9
         B2QulL06PWvzQPWCa21JamDZJRAUw8foh6jfljBKZG5dnBXhNt6bu4ydW74h2dQh28gJ
         kW87JSm9dOA8lJEt3cpeiVG0TkflAH9Uhcb2NeYbzAZzxv8uLeDSGS59Q+Vkh/8rLdLT
         kwqoj/OdylH+5YPyXl6Cnvv2JOSz48+hTXuffAWpb9nhSADW37v9Dx8kgksCXhr2unnj
         XDzwCkoFPDbnkbTH2dt2W0dZO5ccPtixa0la/Lkti90ylR+tFBXg7h75FsojZoyND5Fm
         2glQ==
X-Gm-Message-State: AOAM531BtlsDkRllcG0m+ZICtIhQ1/lMZKKOUIKiVf1fxkTbf+fx4i/4
        qIamlxGIlDwNmylaimjA4zE=
X-Google-Smtp-Source: ABdhPJw4b0VxaMRGyqDttCMe2xNkxjWyC41rv+9eFQoaX2UiZZnHkDcccfnwH7w2aY6jsjvKgmuk7w==
X-Received: by 2002:aa7:c31a:0:b0:425:df3c:de8e with SMTP id l26-20020aa7c31a000000b00425df3cde8emr25141265edq.83.1652221263892;
        Tue, 10 May 2022 15:21:03 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id r9-20020aa7c149000000b0042617ba63a8sm174281edp.50.2022.05.10.15.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 15:21:03 -0700 (PDT)
Date:   Wed, 11 May 2022 01:21:01 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
Message-ID: <20220510222101.od3n7gk3cofwhbks@skbuf>
References: <20220510094014.68440-1-nbd@nbd.name>
 <20220510123724.i2xqepc56z4eouh2@skbuf>
 <5959946d-1d34-49b9-1abe-9f9299cc194e@nbd.name>
 <20220510165233.yahsznxxb5yq6rai@skbuf>
 <bc4bde22-c2d6-1ded-884a-69465b9d1dc7@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc4bde22-c2d6-1ded-884a-69465b9d1dc7@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 12:06:25AM +0200, Felix Fietkau wrote:
>
> On 10.05.22 18:52, Vladimir Oltean wrote:
> > On Tue, May 10, 2022 at 04:52:16PM +0200, Felix Fietkau wrote:
> > >
> > > On 10.05.22 14:37, Vladimir Oltean wrote:
> > > > On Tue, May 10, 2022 at 11:40:13AM +0200, Felix Fietkau wrote:
> > > > > Padding for transmitted packets needs to account for the special tag.
> > > > > With not enough padding, garbage bytes are inserted by the switch at the
> > > > > end of small packets.
> > > > > I don't think padding bytes are guaranteed to be zeroes. Aren't
> > > they
> > > > discarded? What is the issue?
> > > With the broken padding, ARP requests are silently discarded on the receiver
> > > side in my test. Adding the padding explicitly fixes the issue.
> > >
> > > - Felix
> >
> > Ok, I'm not going to complain too much about the patch, but I'm still
> > curious where are the so-called "broken" packets discarded.
> > I think the receiving MAC should be passing up to software a buffer
> > without the extra padding beyond the L2 payload length (at least that's
> > the behavior I'm familiar with).
>
> I don't know where exactly these packets are discarded.
> After digging through the devices I used during the tests, I just found some
> leftover pcap files that show the differences in the received packets. Since
> the packets are bigger after my patch, I can't rule out that packet size
> instead of the padding may have made a difference here in getting the ARP
> requests accepted by the receiver.
>
> I've extracted the ARP requests and you can find them here:
> http://nbd.name/arp-broken.pcap

arp-broken.pcap was collected at the receiver MAC, right? So the packets
actually exited the switch?

> http://nbd.name/arp-working.pcap
>
> - Felix

It sounds as if this is masking a problem on the receiver end, because
not only does my enetc port receive the packet, it also replies to the
ARP request.

pc # sudo tcpreplay -i eth1 arp-broken.pcap
root@debian:~# ip addr add 192.168.42.1/24 dev eno0
root@debian:~# tcpdump -i eno0 -e -n --no-promiscuous-mode arp
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eno0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
22:18:58.846753 f4:d4:88:5e:6f:d2 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Request who-has 192.168.42.1 tell 192.168.42.173, length 46
22:18:58.846806 00:04:9f:05:f4:ab > f4:d4:88:5e:6f:d2, ethertype ARP (0x0806), length 42: Reply 192.168.42.1 is-at 00:04:9f:05:f4:ab, length 28
^C
2 packets captured
2 packets received by filter
0 packets dropped by kernel

What MAC/driver has trouble with these packets? Is there anything wrong
in ethtool stats? Do they even reach software? You can also use
"dropwatch -l kas" for some hints if they do.
