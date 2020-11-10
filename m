Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4585D2AD275
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgKJJ2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:28:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45874 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgKJJ2m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:28:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605000520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DWQR4+lW8/3xvAUmgOI4OAJGMLTpJgUV2AdqwnurgMU=;
        b=Dd3DbTXId6bXakUrvmI7POLzHDRxb8elPXaDGYG4RoBHkPX0fnIB6o5e4lhfWT2+/BegpC
        w9dS/FVWjeU9CSliLFg6rdQYuD4AvFDFZLwtBU5iFujSw1dB6DWhEpZo5yQVN3iiB0IHBS
        qI5UrPDUlQCRffH/FdzqFD+Yd09H/Gw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-yiclEDiTOreTDBguXWjm0w-1; Tue, 10 Nov 2020 04:28:38 -0500
X-MC-Unique: yiclEDiTOreTDBguXWjm0w-1
Received: by mail-wr1-f70.google.com with SMTP id w17so4710226wrp.11
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 01:28:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DWQR4+lW8/3xvAUmgOI4OAJGMLTpJgUV2AdqwnurgMU=;
        b=DM9/ClLkta913uGp48bnZPavkP2sgDwAVdL9zdemCvyrJ0jDwu0qBl+447dKSjvT9m
         4TfB7EbLNYQtwRkiUwHpxNLxekUVCu7nLty5KDh/R0MPOoXkdmdSIYJOKzTgOydwGMro
         q8jm3EDqWzBFbPQbcWBBxa/qsuFFnbgwgdRYkf164SM0+FO1me3douyd09sgPtSiCnmG
         dGM1UNJCFyHnf/zmc2GYO+FPhjdbGEW+1BKXPTamzd3GdFxCVFOKhtwEl4D9QejzKmOd
         dJvrDE8HRa1qeEf6RWzWS2+g/n1N2xRy5v5TlxKyg4Q1NDbD7rPa2gwBLM/FJuquiN7Z
         usHg==
X-Gm-Message-State: AOAM531HKoIFIlZGhRpBgBpkSmTroB8xpDpHrf70j4jM1nBEl7MGCr4J
        ZM9Ipgz+bgOato8lyxCA3DexDOnuIlpCR8RJlBh7bKZbouZoLkmzkl7+mlisH5oSnFo3FHkf7TT
        f2qVjtPQ8qw7URrwR
X-Received: by 2002:a5d:67c4:: with SMTP id n4mr22503261wrw.125.1605000517243;
        Tue, 10 Nov 2020 01:28:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzYc0oOCKFX0b5cjD/y4zVsaE3tUiz0ba9Vk+gxIePK2ZBgfQAzd55fLJWJcPtXEfUYEp/3JA==
X-Received: by 2002:a5d:67c4:: with SMTP id n4mr22503244wrw.125.1605000517013;
        Tue, 10 Nov 2020 01:28:37 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id l13sm4711760wrm.24.2020.11.10.01.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 01:28:36 -0800 (PST)
Date:   Tue, 10 Nov 2020 10:28:34 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201110092834.GA30007@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 03:52:37PM -0800, Jakub Kicinski wrote:
> On Fri,  6 Nov 2020 18:16:45 +0000 Tom Parkin wrote:
> > This small RFC series implements a suggestion from Guillaume Nault in
> > response to my previous submission to add an ac/pppoe driver to the l2tp
> > subsystem[1].
> > 
> > Following Guillaume's advice, this series adds an ioctl to the ppp code
> > to allow a ppp channel to be bridged to another.  Quoting Guillaume:
> > 
> > "It's just a matter of extending struct channel (in ppp_generic.c) with
> > a pointer to another channel, then testing this pointer in ppp_input().
> > If the pointer is NULL, use the classical path, if not, forward the PPP
> > frame using the ->start_xmit function of the peer channel."
> > 
> > This allows userspace to easily take PPP frames from e.g. a PPPoE
> > session, and forward them over a PPPoL2TP session; accomplishing the
> > same thing my earlier ac/pppoe driver in l2tp did but in much less code!
> 
> I have little understanding of the ppp code, but I can't help but
> wonder why this special channel connection is needed? We have great
> many ways to redirect traffic between interfaces - bpf, tc, netfilter,
> is there anything ppp specific that is required here?

I can see two viable ways to implement this feature. The one described
in this patch series is the simplest. The reason why it doesn't reuse
existing infrastructure is because it has to work at the link layer
(no netfilter) and also has to work on PPP channels (no network
device).

The alternative, is to implement a virtual network device for the
protocols we want to support (at least PPPoE and L2TP, maybe PPTP)
and teach tunnel_key about them. Then we could use iproute2 commands
like:
 # ip link add name pppoe0 up type pppoe external
 # ip link add name l2tp0 up type l2tp external
 # tc qdisc add dev pppoe0 ingress
 # tc qdisc add dev l2tp0 ingress
 # tc filter add dev pppoe0 ingress matchall                        \
     action tunnel_key set l2tp_version 2 l2tp_tid XXX l2tp_sid YYY \
     action mirred egress redirect dev pppoe0
 # tc filter add dev l2tp0 ingress matchall  \
     action tunnel_key set pppoe_sid ZZZ     \
     action mirred egress redirect dev l2tp0

Note: I've used matchall for simplicity, but a real uses case would
have to filter on the L2TP session and tunnel IDs and on the PPPoE
session ID.

As I said in my reply to the original thread, I like this idea, but
haven't thought much about the details. So there might be some road
blocks. Beyond modernising PPP and making it better integrated into the
stack, that should also bring the possibility of hardware offload (but
would any NIC vendor be interested?).

I think the question is more about long term maintainance. Do we want
to keep PPP related module self contained, with low maintainance code
(the current proposal)? Or are we willing to modernise the
infrastructure, add support and maintain PPP features in other modules
like flower, tunnel_key, etc.?

Of course, I might have missed other ways to implement this feature.
But that's all I could think of for now.

And if anyone wants a quick recap about PPP (what are these PPP channel
and unit things? what's the relationship between PPPoE, L2TP and PPP?
etc.), just let me know.

Hope this clarifies the situation.

