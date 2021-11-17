Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8130B453E87
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 03:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232479AbhKQCoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 21:44:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhKQCoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 21:44:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0ACC861BFB;
        Wed, 17 Nov 2021 02:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637116916;
        bh=2wKO4aZV/Ef6jWjcHPr52Bnu8Xgxou22b8sHQOvfvP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XfsfGBzvJqwSi0QVfz0nPOY0SmpJ0LRQyClQBNHiYgixkSqSq1ANfmu8fJp/NWxP3
         oEeSAPusT2kYvtnyP+5pyK3eQGg4rHf5oio5Y6hk6Ya7ORRm9qZpO1xI+zPAtsuSev
         70XKrQmgJhssLmOtMfNp4+OZN9RZU3ktGugHvsXNmxFZb/Qzq64xbNtE9zi64ihrKS
         l4fd/JkMUwOs8CAGDFXXmf5/TgQxJTikxuyOo9Y87HUo+JrdarsVKE4G2bKU1Vr2vj
         cQJ9aL0e5UE0P8P26ZLv1KII0tXL9iEEdFOxErsm7z3s1lSlfhVBA6cAKVGEUxl73l
         BrfjIxsEsoaUA==
Date:   Tue, 16 Nov 2021 18:41:55 -0800
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
Message-ID: <20211116184155.6c81b042@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YZRUW6wfMdI1aN1o@Laptop-X1>
References: <20211116084840.978383-1-liuhangbin@gmail.com>
        <20211116120058.494d6204@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZRUW6wfMdI1aN1o@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 09:01:15 +0800 Hangbin Liu wrote:
> > >  
> > >  static const struct nla_policy bond_slave_policy[IFLA_BOND_SLAVE_MAX + 1] = {
> > > @@ -453,6 +454,15 @@ static int bond_changelink(struct net_device *bond_dev, struct nlattr *tb[],
> > >  			return err;
> > >  	}
> > >  
> > > +	if (data[IFLA_BOND_MISSED_MAX]) {
> > > +		int missed_max = nla_get_u8(data[IFLA_BOND_MISSED_MAX]);  
> > 
> > If you read and write a u8?  
> 
> Ah, that's a typo. I planed to use nla_get_u32(). But looks NLA_U8 also should
> be enough. WDYT?

Either way is fine. To be sure we don't need to enforce any lower limit
here? 0 is a valid setting?
