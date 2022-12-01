Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8E063FA8D
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiLAW3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiLAW3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:29:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3977BBE4F9
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 14:29:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD62F62067
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 22:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08ACC433C1;
        Thu,  1 Dec 2022 22:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669933793;
        bh=+xQbXoV/PZNrdLXanNhkb2XP4cq3hRdIlJ7muQjat3M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QBjoHSIKLtxrHBPuEjGkWTqurPSJVEx794Q5a4KABErqPfgiEzzIVY1RtP551F0gR
         UrayP9P99CaxwvCFK45Lqnz0NT+AGlxiBqp50exeoXMkBktK4fqyHosAPW/QoA0so4
         4A52oJ7n0BsBfDmhhl/eKP3tKPy5muOlSdMnNk8y5wm22ypkUzAsF29G4oETROr68Q
         hfTRIZdcprkxZJrVjw532DEXKqtAhAW4Ob0Q3Jot7T6zMGi42sObja3bAMlvn59tiA
         qz4aGcrYyoqxzrs9bmK5xggO6tIB3uIV1TLShJjulCqAAOjSs8Jbj+lWL0bcICrx+U
         KH2UbOHnxSebQ==
Date:   Thu, 1 Dec 2022 14:29:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Message-ID: <20221201142951.5f068079@kernel.org>
In-Reply-To: <6a174081-0187-551c-4b34-17a59ad38230@amd.com>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-9-snelson@pensando.io>
        <20221128102828.09ed497a@kernel.org>
        <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
        <20221128153719.2b6102cc@kernel.org>
        <75072b2a-0b69-d519-4174-6d61d027f7d4@amd.com>
        <20221128165522.62dcd7be@kernel.org>
        <51330a32-1fa1-cc0f-e06e-b4ac351cb820@amd.com>
        <20221128175448.3723f5ee@kernel.org>
        <fbf3266c-f125-c01a-fcc3-dc16b4055ed5@amd.com>
        <20221129180250.3320da56@kernel.org>
        <b839c112-df1f-a36a-0d89-39b336956492@amd.com>
        <20221130194506.642031db@kernel.org>
        <6a174081-0187-551c-4b34-17a59ad38230@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Dec 2022 11:19:51 -0800 Shannon Nelson wrote:
> > It simply does not compute for me. You're exposing a very advanced vDPA
> > interface, and yet you say you don't need any network configuration
> > beyond what Niantic had.  
> 
> Would you have the same responses if we were trying to do this same kind 
> of PF netdev on a simple Niantic-like device (simple sr-iov support, 
> little filtering capability)?

It is really hard for me to imagine someone building a Niantic-like
device today.

Recently I was thought-experiment-designing simplest Niantic-like device
for container workloads. And my conclusion was that yes, TC would
probably be the best way to control forwarding. (Sorry not really an
answer to your question, I don't know of any real Niantics of the day)

> > There are no upstream-minded users of IPUs, if it was up to me I'd flat
> > out ban them from the kernel.  
> 
> Yeah, there's a lot of hidden magic going on behind the PCI devices 
> presented to the host, and a lot of it depends on the use cases 
> attempting to be addressed by the different product vendors and their 
> various cloud and enterprise customers.  I tend to think that the most 
> friction here comes from us being more familiar and comfortable with the 
> enterprise use cases where we typically own the whole host, and not so 
> comfortable these newer cloud use cases with control and configuration 
> coming from outside the host.

I know about cloud as much as I know about enterprise, being a Meta's
employee. But those who do have public clouds seem to develop all the
meaningful tech behind closed doors, under NDAs. And at best "bless" 
us with a code dump which is under an open source license.

The community is where various developers should come together and
design together. If you do a full design internally and then come
upstream to just ship the code then it's a SW distribution channel,
not an open source project. That's what I am not comfortable with.
