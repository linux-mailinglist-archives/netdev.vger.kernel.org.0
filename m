Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F8424D481
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 19:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfFTRF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 13:05:26 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:37776 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726530AbfFTRF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 13:05:26 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1he0V0-0001Op-0g; Thu, 20 Jun 2019 19:05:22 +0200
Date:   Thu, 20 Jun 2019 19:05:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: bridge: Fix non-untagged fragment
 packet
Message-ID: <20190620170522.cn6utaviil7gmldo@breakpoint.cc>
References: <1560954907-20071-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560954907-20071-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> ip netns exec ns1 ip a a dev eth0 10.0.0.7/24
> ip netns exec ns2 ip link a link eth0 name vlan type vlan id 200
> ip netns exec ns2 ip a a dev vlan 10.0.0.8/24
> 
> ip l add dev br0 type bridge vlan_filtering 1
> brctl addif br0 veth1
> brctl addif br0 veth2
> 
> bridge vlan add dev veth1 vid 200 pvid untagged
> bridge vlan add dev veth2 vid 200
> 
> A two fragment packets send from ns2 contained with vlan tag 200.
> In the bridge conntrack, packet will defrag to one skb with fraglist.
> When the packet forward to ns1 through veth1, the first skb vlan tag
> will be cleared for "untagged" flags. But the vlan tag in the second
> skb still tagged, which lead the second fragment send with tag 200 to
> ns1.
> So if the first fragment packet don't contain vlan tag, all of the
> remain should not contain vlan tag..
> 
> Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Acked-by: Florian Westphal <fw@strlen.de>
