Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52DDB191FCE
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 04:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbgCYDh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 23:37:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:56668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbgCYDh0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 23:37:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64BA120724;
        Wed, 25 Mar 2020 03:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585107445;
        bh=bI2ei4oLpwHOVbGScpI4MdjFzaLxH6v1EbC6hdxP/WA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pVi09vnphKJtff7n+Xrbk9iWBeHX3aql/U8Tu0yRXIC2uYq3G1ZAtD+19Gp4VMLT6
         59YamqygDuZhTmhYMlaHsS35Y3w0udw9irL686T1e0i76zSq/lyjIIBYAtprQ8mhgN
         ruQ6QxNhjPn57kiJ2WnjF9VPxeHC0pdkop4u64qk=
Date:   Tue, 24 Mar 2020 20:37:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 01/15] devlink: Add packet trap policers
 support
Message-ID: <20200324203723.1187ab10@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200324193250.1322038-2-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
        <20200324193250.1322038-2-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 21:32:36 +0200 Ido Schimmel wrote:
>  static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {

Hm. looks like devlink doesn't have .strict_start_type set, yet.
Should we set it?

>  	[DEVLINK_ATTR_BUS_NAME] = { .type = NLA_NUL_STRING },
>  	[DEVLINK_ATTR_DEV_NAME] = { .type = NLA_NUL_STRING },
> @@ -6064,6 +6309,9 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>  	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
>  	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
>  	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
> +	[DEVLINK_ATTR_TRAP_POLICER_ID] = { .type = NLA_U32 },
> +	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
> +	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
>  };
