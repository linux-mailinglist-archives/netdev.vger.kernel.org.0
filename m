Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45E1285B50
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 10:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbgJGIwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 04:52:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:55232 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbgJGIwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 04:52:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D83F4ACF5;
        Wed,  7 Oct 2020 08:52:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6A66C603A9; Wed,  7 Oct 2020 10:52:47 +0200 (CEST)
Date:   Wed, 7 Oct 2020 10:52:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com, jiri@resnulli.us,
        andrew@lunn.ch, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v2 0/7] ethtool: allow dumping policies to user
 space
Message-ID: <20201007085247.g4vb5kate74s45eo@lion.mk-sys.cz>
References: <20201005220739.2581920-1-kuba@kernel.org>
 <7586c9e77f6aa43e598103ccc25b43415752507d.camel@sipsolutions.net>
 <20201006.062618.628708952352439429.davem@davemloft.net>
 <20201007062754.GU1874917@unreal>
 <cf5fdfa13cce37fe7dcf46a4e3a113a64c927047.camel@sipsolutions.net>
 <20201007082437.GV1874917@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007082437.GV1874917@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 11:24:37AM +0300, Leon Romanovsky wrote:
> Yes, it fixed KASAN, but it we got new failure after that.
> 
> 11:07:51 player_id: 1 shell.py:62 [LinuxEthtoolAgent] DEBUG : running command(/opt/mellanox/ethtool/sbin/ethtool --set-channels eth2 combined 3) with pid: 13409
> 11:07:51 player_id: 1 protocol.py:605 [OpSetChannels] ERROR : RC:1, STDERR:
> netlink error: Unknown attribute type (offset 36)
> netlink error: Invalid argument

For the record, when reporting issues like this, it's useful to enable
pretty printing and showing the messages with "--debug 0x12", e.g.

  ethtool --debug 0x12 --setchannels eth2 combined 3

That will show both requests and replies and will also highlight the
offending attribute.

Michal
