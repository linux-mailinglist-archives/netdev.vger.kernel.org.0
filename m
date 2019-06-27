Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F82E58AD9
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:16:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfF0TQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:16:57 -0400
Received: from mail.us.es ([193.147.175.20]:54752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbfF0TQ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 15:16:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9B88C4140
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 21:16:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99226A7BD6
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 21:16:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8DB921021A7; Thu, 27 Jun 2019 21:16:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E39991E1;
        Thu, 27 Jun 2019 21:16:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 21:16:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5B7194265A31;
        Thu, 27 Jun 2019 21:16:52 +0200 (CEST)
Date:   Thu, 27 Jun 2019 21:16:51 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2 nf-next] netfilter:nft_meta: add NFT_META_VLAN support
Message-ID: <20190627191651.o4efhnjgmyrakvth@salvia>
References: <1561601357-20486-1-git-send-email-wenxu@ucloud.cn>
 <1561601357-20486-2-git-send-email-wenxu@ucloud.cn>
 <20190627123550.vx7r4rmzduzabig6@salvia>
 <c9ce6a77-a5db-b3a1-ab48-eb6bc97337e1@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c9ce6a77-a5db-b3a1-ab48-eb6bc97337e1@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 09:37:53PM +0800, wenxu wrote:
> 
> 在 2019/6/27 20:35, Pablo Neira Ayuso 写道:
> > On Thu, Jun 27, 2019 at 10:09:17AM +0800, wenxu@ucloud.cn wrote:
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> This patch provide a meta vlan to set the vlan tag of the packet.
> >>
> >> for q-in-q vlan id 20:
> >> meta vlan set 0x88a8:20
> > Actually, I think this is not very useful for stacked vlan since this
> > just sets/mangles the existing meta vlan data.
> >
> > We'll need infrastructure that uses skb_vlan_push() and _pop().
> >
> > Patch looks good anyway, such infrastructure to push/pop can be added
> > later on.
> >
> > Thanks.
> 
> yes, It's just ste/mangle the meta vlan data. I just wonder if we set for stacked vlan.
> vlan meta 0x88a8:20. The packet should contain a 0x8100 vlan tag, we just push the
> inner vlan and the the vlan meta with the outer 0x88a8:20. Or the packet don't contain
> only vlan tag, we add a inner 0x8100:20 tag and outer 0x88a8:20 tag?

You got me thinking here.

I wonder if we can just make this fit into nft_payload.

Or just add a new nft_vlan extension for this specifically, to push,
to mangle and to pop vlan headers. This would be a simple solution for
this.

I need to explore this by the weekend, will get back to you beginning
next week.

Feedback is welcome in any case :-), thanks.
