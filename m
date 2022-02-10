Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E144B129B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244079AbiBJQWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:22:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbiBJQWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:22:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D376B137
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 08:22:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F22FB82657
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 16:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFDDC004E1;
        Thu, 10 Feb 2022 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644510171;
        bh=BOWidli9VWcup6o2AZ0Fstu/xaGVzpV6rKg3Oh1MajY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OqoZi0HkNLKSOS79/oiKVK0diXEwE3GkpY+QncziIBeiIOpTgFSQaqX0sC0DNoOru
         9r5KpxZk86Ki0/vhYIq4LBlO1dS+WrxSVGvFRwVtzri8lHV0I8IE8zWyiLmIfdKceJ
         uXRmv1tEjjaylOC5nvhDLrD6x4JGCiepJBikE7Jbodhv4jzqbyVihxBASs9xYXWJVH
         y3P/sFeP0VZsGfQcocGQxEoNPdcB3+F8wEhf2pFYEktMbO2+7CpKWM+0evN8QqZPwY
         7WxsebKso0VCG+a7mvvkeRuM4syHs4Mc9Z01hCBi+dlWpkTltkLy6JkP4vxjxeuKLd
         aE2eSVl/UUjfQ==
Date:   Thu, 10 Feb 2022 08:22:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] sfc: default config to 1 channel/core in
 local NUMA node only
Message-ID: <20220210082249.0e50668b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACT4oucCn2ixs8hCizGhvjLPOa90k3vEZEVbuY6nUF-M23B=yw@mail.gmail.com>
References: <20220128151922.1016841-1-ihuguet@redhat.com>
        <20220128151922.1016841-2-ihuguet@redhat.com>
        <20220128142728.0df3707e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACT4ouctx9+UP2BKicjk6LJSRcR2M_4yDhHmfDARcDuVj=_XAg@mail.gmail.com>
        <20220207085311.3f6d0d19@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACT4oucCn2ixs8hCizGhvjLPOa90k3vEZEVbuY6nUF-M23B=yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 10:35:53 +0100 =C3=8D=C3=B1igo Huguet wrote:
> On Mon, Feb 7, 2022 at 5:53 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Mon, 7 Feb 2022 16:03:01 +0100 =C3=8D=C3=B1igo Huguet wrote: =20
> > > I have a few busy weeks coming, but I can do this after that.
> > >
> > > With num_cores / 2 you divide by 2 because you're assuming 2 NUMA
> > > nodes, or just the plain number 2? =20
> >
> > Plain number 2, it's just a heuristic which seems to work okay.
> > One queue per core (IOW without the /2) is still way too many queues
> > for normal DC workloads.
>=20
> Maybe it's because of being quite special workloads, but I have
> encountered problems related to queues in different NUMA nodes in 2
> cases: XDP performance being almost half with more RX queues because
> of being in different node (the example in my patches) and a customer
> losing UDP packets which was solved reducing the number of RX queues
> so all them are in the same node.

Right, no argument, NUMA tuning will still be necessary.=20
I'm primarily concerned about providing a sensible default
for workloads which are not network heavy and therefore
nobody spends time tuning their queue configuration.
Any network-heavy workload will likely always benefit from tuning.

The status quo is that our current default returned by
netif_get_num_default_rss_queues() is 8 which is inadequate=20
for modern servers, and people end up implementing their own
logic in the drivers.

I'm fine with sfc doing its own thing (at least for now) and=20
therefore your patches as they are, but for new drivers I want
to be able to recommend netif_get_num_default_rss_queues() with
a clear conscience.

Does that make sense?
