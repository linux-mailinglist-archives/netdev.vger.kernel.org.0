Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0115B2D3B20
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 07:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727679AbgLIGEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 01:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbgLIGEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 01:04:41 -0500
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F65C0613CF;
        Tue,  8 Dec 2020 22:04:01 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id q25so585555oij.10;
        Tue, 08 Dec 2020 22:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xw4WlY+gecPL6DnhDENOYEz8RjK6qkVO+Z0UKbUq6rg=;
        b=blwLBC8I1ol4VExUBqHsBtI6x0pnw4U9cZxawk5zq5P+jhWlGmVILWBjufi50F8loU
         WojsXW9aVAUWw+4Y2PdjbPOPLwoIt0/7GeopTLMG/+jEXSEkZ5ecA+zXjjnTOk2uFwG7
         kmJYGE2S/K0UHiFUvZWmmh8ia3O7af3Mzii4qhds/1x8YS+2dCtKR6TVPDHsPBeuqZBH
         cmpb3ZwZM+WWRyXmI1MsedriU66ezUuOKPPIXns6a50R8arW1J2ghUj7okehG7uCsxYX
         q/+CVLJolt7dnHvij8gBSy5bmiRz9mSDVAW85kW5GawlUZMk5mJCo5pzhzdEMHHOAcz/
         EMug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xw4WlY+gecPL6DnhDENOYEz8RjK6qkVO+Z0UKbUq6rg=;
        b=GlZ9s5E3ItNFgzye+6/aTz1IwJNwcfLnaQRawVXhyB01D3egz9HCHN2OCfbVjANj/s
         YUix7XNVFdvbdtI+vWA7mU9E2sdZcArergx26qa/at3sVFayPomTeXoGx4NTx5RpbnZe
         xNt/q9YhCl11aItwTuYnhcVyCuuuOeYEfybwecw6NHCsbfMH1NqMu/aJXoJJZBTX2Uq3
         uYNJ3xi6Gj1sQA//BkPoQNey051Melbt0wVn9nrC/YfzIGQOja5pBZf0ZXYYzrisL4vy
         P2a84LuyYhEXaAVdkaQdxG1b53Yukg2ykd/3aXw0cNMNyjfCNFVuXlbqjl53BOkTEywL
         j25g==
X-Gm-Message-State: AOAM530IKbswzWAPAWYaMqpY9vz5h5SIt2trIY/CrvWeyaoAxO3QRxxb
        e5V6koq085B3T3YPiPsuIA5DELQfdBs=
X-Google-Smtp-Source: ABdhPJzV0J/ZAp54eywd2BpQ5szxmUsuNU04Mn+rnJMPMdPd0aR0tQNtc8qfELb8e1bBcroRKkVURA==
X-Received: by 2002:aca:6287:: with SMTP id w129mr702445oib.82.1607493840475;
        Tue, 08 Dec 2020 22:04:00 -0800 (PST)
Received: from localhost ([184.21.204.5])
        by smtp.gmail.com with ESMTPSA id v123sm159783oie.20.2020.12.08.22.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 22:03:59 -0800 (PST)
Date:   Tue, 08 Dec 2020 22:03:51 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Message-ID: <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
In-Reply-To: <20201207230755.GB27205@ranger.igk.intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <20201207230755.GB27205@ranger.igk.intel.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Dec 07, 2020 at 12:52:22PM -0800, John Fastabend wrote:
> > Jesper Dangaard Brouer wrote:
> > > On Fri, 4 Dec 2020 16:21:08 +0100
> > > Daniel Borkmann <daniel@iogearbox.net> wrote:

[...] pruning the thread to answer Jesper.

> > > 
> > > Use-case(2): Disable XDP_TX on a driver to save hardware TX-queue
> > > resources, as the use-case is only DDoS.  Today we have this problem
> > > with the ixgbe hardware, that cannot load XDP programs on systems with
> > > more than 192 CPUs.
> > 
> > The ixgbe issues is just a bug or missing-feature in my opinion.
> 
> Not a bug, rather HW limitation?

Well hardware has some max queue limit. Likely <192 otherwise I would
have kept doing queue per core on up to 192. But, ideally we should
still load and either share queues across multiple cores or restirct
down to a subset of CPUs. Do you need 192 cores for a 10gbps nic,
probably not. Yes, it requires some extra care, but should be doable
if someone cares enough. I gather current limitation/bug is because
no one has that configuration and/or has complained loud enough.

> 
> > 
> > I think we just document that XDP_TX consumes resources and if users
> > care they shouldn't use XD_TX in programs and in that case hardware
> > should via program discovery not allocate the resource. This seems
> > cleaner in my opinion then more bits for features.
> 
> But what if I'm with some limited HW that actually has a support for XDP
> and I would like to utilize XDP_TX?
> 
> Not all drivers that support XDP consume Tx resources. Recently igb got
> support and it shares Tx queues between netstack and XDP.

Makes sense to me.

> 
> I feel like we should have a sort-of best effort approach in case we
> stumble upon the XDP_TX in prog being loaded and query the driver if it
> would be able to provide the Tx resources on the current system, given
> that normally we tend to have a queue per core.

Why do we need to query? I guess you want some indication from the
driver its not going to be running in the ideal NIC configuraition?
I guess printing a warning would be the normal way to show that. But,
maybe your point is you want something easier to query?

> 
> In that case igb would say yes, ixgbe would say no and prog would be
> rejected.

I think the driver should load even if it can't meet the queue per
core quota. Refusing to load at all or just dropping packets on the
floor is not very friendly. I think we agree on that point.
