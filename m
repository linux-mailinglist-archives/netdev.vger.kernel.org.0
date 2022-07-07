Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020F756AEF8
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 01:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiGGXXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 19:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbiGGXXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 19:23:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D1917A9F
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 16:23:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 554926257F
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 23:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79095C3411E;
        Thu,  7 Jul 2022 23:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657236208;
        bh=q6+0b37N3R2mo8kDeuRYPEafPr+SCa+6Oc9srmlpHKc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=By6vZP6evDKQSmHbpAlnvX3klaIM2twjt2gyVquBVcpA8wN5bz35jpKXQJzfCFB8v
         HWdmjMuHdVQsPZR11HQ2PlvpK55r+24zlZbQuVkegJcUdjx/gwGC2OljRKAkJ7mFZ0
         2UE8l/Mq94NlD4wqEuHzvzUzo8g/O44ZkJKpM7YTzYuERfMq9xjPcKw8MjTkqSkNzt
         oee/KYlqGb56bRncswTSUn2CZHH//qWJQ1QX0b2dEgye6P/ZJXCSFFOfHqmI+3jlPH
         bxKzYFE7PF8gb64oMGqe273ljsNRiLTmKglz/vc7e/+vO4RdY8yfk++Dj4eVIFRMxh
         McQZ2vLHC/qsw==
Date:   Thu, 7 Jul 2022 16:23:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksey Shumnik <ashumnik9@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, kuznet@ms2.inr.ac.ru,
        xeb@mail.ru
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
Message-ID: <20220707162319.49c25e90@kernel.org>
In-Reply-To: <CAJGXZLj2pMki+88OO_fDf-KO1jehEKWg2m5yKTeB0K4yKuMmmg@mail.gmail.com>
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
        <20220622171929.77078c4d@kernel.org>
        <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
        <20220623202602.650ed2e6@kernel.org>
        <CAJGXZLg9Z3O8w_bTLhyU1m7Oemfx561X0ji0MdYRZG8XKmxBpg@mail.gmail.com>
        <20220624101743.78d0ece7@kernel.org>
        <CAJGXZLhJd4xYQhvhb8r0QYhjSjNUCe6nmvi5TA_Ma6LO992KYw@mail.gmail.com>
        <20220701183151.1d623693@kernel.org>
        <20220701184222.34b75a77@kernel.org>
        <CAJGXZLj2pMki+88OO_fDf-KO1jehEKWg2m5yKTeB0K4yKuMmmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jul 2022 19:41:23 +0300 Aleksey Shumnik wrote:
> On Sat, Jul 2, 2022 at 4:42 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 1 Jul 2022 18:31:51 -0700 Jakub Kicinski wrote:  
> > > On Tue, 28 Jun 2022 18:18:27 +0300 Aleksey Shumnik wrote:  
> > > > pre-up ip tunnel add mgre0 mode ip6gre local 4444::1111 key 1 ttl 64 tos inherit  
> > >
> > > I can't get GRE6 tunnels to work as NBMA net at all.
> > > AFAICT ip6gre_tunnel_xmit() takes the endpoint addresses straight
> > > from the netdev, only ip6tnl seems to be doing a lookup.
> > > Am I doing it wrong?  
> 
> What exactly is the problem, may you describe it?
> Have you added entries to the neighbors table?

Yeah, I've added the neigh entries (although the v6 addresses had to 
be massaged a little for ip neigh to take them, the commands from the
email don't work cause iproute2 doesn't support :: in lladdr, AFAICT).

What I've seen in tracing was that I hit:

ip6gre_tunnel_xmit() -> ip6_tnl_xmit_ctl() -> ip6_tnl_get_cap()

that returns IP6_TNL_F_CAP_PER_PACKET

so back to ip6gre_tunnel_xmit() -> goto tx_err -> error, drop

packet never leaves the interface.

> > If it's just v4 could perhaps be commit fdafed459998 ("ip_gre: set
> > dev->hard_header_len and dev->needed_headroom properly"). Would you
> > be able to try some kernel older than 5.8?  
> 
> I'll try.
> dev->hard_header_len and dev->needed_headroom are set properly, but
> the problem remains.
> The problem with v4 is that the ip and gre headers are created 2 times
> (1st in ipgre_header() and 2nd in gre_build_header() and
> iptunnel_xmit()), they are overwritten, so that there is one gre and
> one ip header in the packet.
> Why take unnecessary actions if it could be created once.
> v6 has the same problem, but also the packet has 2 same ip6 and gre
> headers, duplication occurs, that is, they are not overwritten as in
> v4.
> v6 doesn't even have dev->hard_header_len.

Hm, so you did get v6 to repro? Not sure what I'm doing wrong, I'm
trying to repro with a net namespace over veth but that can't be it...
