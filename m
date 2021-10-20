Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA81B43527F
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhJTSTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbhJTSS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:18:59 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6932DC061749
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 11:16:44 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 4F0F592009C; Wed, 20 Oct 2021 20:16:42 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 4865F92009B;
        Wed, 20 Oct 2021 20:16:42 +0200 (CEST)
Date:   Wed, 20 Oct 2021 20:16:42 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 05/12] fddi: defxx,defza: use dev_addr_set()
In-Reply-To: <20211020155617.1721694-6-kuba@kernel.org>
Message-ID: <alpine.DEB.2.21.2110202009200.31442@angie.orcam.me.uk>
References: <20211020155617.1721694-1-kuba@kernel.org> <20211020155617.1721694-6-kuba@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Oct 2021, Jakub Kicinski wrote:

> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.

 FDDI does not have a concept of a VLAN, so I guess this is more of a 
cosmetic nature rather than addressing an actual problem, right?

 As I noted in the other message I think this might best be abstracted,
e.g. by calling the entry point here say `fddidev_addr_set' while the 
entry point used by Ethernet devices could be `etherdev_addr_set', so that 
it is immediately obvious that we have different data link layers, even if 
the implementation of the handler would be the same for both.

 Otherwise:

Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>

  Maciej
