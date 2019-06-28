Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93AD459401
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 08:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfF1GGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 02:06:23 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:52772 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726553AbfF1GGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 02:06:22 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgk1Z-0000hi-GM; Fri, 28 Jun 2019 08:06:17 +0200
Date:   Fri, 28 Jun 2019 08:06:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 2/3 nf-next] netfilter:nf_flow_table: Support bridge type
 flow offload
Message-ID: <20190628060617.az2quv4bodrenuli@breakpoint.cc>
References: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
 <1561545148-11978-2-git-send-email-wenxu@ucloud.cn>
 <20190626183816.3ux3iifxaal4ffil@breakpoint.cc>
 <20190626191945.2mktaqrcrfcrfc66@breakpoint.cc>
 <dce5cba2-766c-063e-745f-23b3dd83494b@ucloud.cn>
 <20190627125839.t56fnptdeqixt7wd@salvia>
 <b2a48653-9f30-18a9-d0e1-eaa940a361a9@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b2a48653-9f30-18a9-d0e1-eaa940a361a9@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wenxu <wenxu@ucloud.cn> wrote:
> ns21 iperf to 10.0.0.8 with dport 22 in ns22
> first time with OFFLOAD enable
> 
> nft add flowtable bridge firewall fb2 { hook ingress priority 0 \; devices = { veth21, veth22 } \; }
> nft add chain bridge firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
> nft add rule bridge firewall ftb-all counter ct zone 2 ip protocol tcp flow offload @fb2
> 
> # iperf -c 10.0.0.8 -p 22 -t 60 -i2
[..]
> [  3]  0.0-60.0 sec   353 GBytes  50.5 Gbits/sec
> 
> The second time on any offload:
> # iperf -c 10.0.0.8 -p 22 -t 60 -i2
> [  3]  0.0-60.0 sec   271 GBytes  38.8 Gbits/sec

Wow, this is pretty impressive.  Do you have numbers without
offload and no connection tracking?

Is this with CONFIG_RETPOLINE=y (just curious)?
