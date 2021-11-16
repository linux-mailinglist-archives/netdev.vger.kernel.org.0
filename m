Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57DA6453A7E
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240141AbhKPUD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:03:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:38860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234090AbhKPUD4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:03:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36F7961BA1;
        Tue, 16 Nov 2021 20:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637092859;
        bh=OBsSPiNf60iHa63YYvPZGZuY9ZegzPJnCydPLxs+xtk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K+SLktM43KvfFmn8hY0FUeFIoJAgWDTmEwxtDb6Q2eKjmlFYrmq2+D79TWsmumOa3
         x0TKngwcZzG55KxewmIBrjH+5O8uJYBdSpX3IaliiC2LMZo87XJK7G8RTBEX8h/toa
         f76SiARH8yI4uAFqjgeiTtiNk3dVf0LiND5ZVS3GDHSDViDGvn2cHw6vhJJIdEZ3KA
         sI/2ASQx+YWSgkc3HUOHi4kumpCuqSbxsJk4mlXzo3gmFgnyOwHWxPXrC8zPCii6yO
         fP/NS3N6c+vCmnWQJG2LrjtZOeMKL+GnenPwW1Lfmu7zMJ603iyR3DJ9TmpaVrSPqZ
         CJcHNfgRSmyzQ==
Date:   Tue, 16 Nov 2021 12:00:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net-next] Bonding: add missed_max option
Message-ID: <20211116120058.494d6204@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211116084840.978383-1-liuhangbin@gmail.com>
References: <20211116084840.978383-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Nov 2021 16:48:40 +0800 Hangbin Liu wrote:
> +	[IFLA_BOND_MISSED_MAX]		= { .type = NLA_U32 },

Why NLA_U32...

>  
>  static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
> @@ -453,6 +454,15 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
>  			return err;
>  	}
>  
> +	if (data[IFLA_BOND_MISSED_MAX]) {
> +		int missed_max = nla_get_u8(data[IFLA_BOND_MISSED_MAX]);

If you read and write a u8?
