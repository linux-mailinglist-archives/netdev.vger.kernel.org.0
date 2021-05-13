Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7AC37F4EA
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 11:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbhEMJmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 05:42:03 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60854 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbhEMJmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 05:42:00 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2708764151;
        Thu, 13 May 2021 11:39:59 +0200 (CEST)
Date:   Thu, 13 May 2021 11:40:47 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN
Message-ID: <20210513094047.GA24842@salvia>
References: <MW2PR2101MB0892FC0F67BD25661CDCE149BF529@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB0892864684CFDB096E0DBF02BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB08925E481FFFF8AB7A3ACDAFBF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <MW2PR2101MB089257F49E8FAA00CDA63A61BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB089257F49E8FAA00CDA63A61BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 06:19:38AM +0000, Dexuan Cui wrote:
> > From: Dexuan Cui
> > Sent: Wednesday, May 12, 2021 11:02 PM
> 
> BTW, I found a similar report in 2019:
> 
> "
> https://serverfault.com/questions/101022/error-applying-iptables-rules-using-iptables-restore
> I stumbled upon this issue on Ubuntu 18.04. The netfilter-persistent
> service failed randomly on boot while working ok when launched manually.
> Turned out it was conflicting with sshguard service due to systemd trying
> to load everything in parallel. What helped is to setting
> ENABLE_FIREWALL=0 in /etc/default/sshguard and then adding sshguard chain
> and rule manually to /etc/iptables/rules.v4 and /etc/iptables/rules.v6.
> "
> 
> The above report provided a workaround.

There's -w and -W to serialize ruleset updates. You could follow a
similar approach from userspace if you don't use iptables userspace
binary.

> I think we need a real fix.

iptables-nft already fixes this.
