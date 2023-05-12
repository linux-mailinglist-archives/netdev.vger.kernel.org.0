Return-Path: <netdev+bounces-2097-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DE217003C2
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 11:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F315E1C21078
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 09:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB350BE4D;
	Fri, 12 May 2023 09:30:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE31F321D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F12A5C433EF;
	Fri, 12 May 2023 09:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683883816;
	bh=ucRyiWiS/49sZE9D2FoxYxdmNrt+bTCuelZZyoYHDFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K54vvlC1sc4bgrunLxna6ZK4WGu751F6BeYpRVClMyrOewSWfrRQRnsQTLnUJn5h3
	 rELR2Lyg5McaesIxfEqYsH2FegQ7Olt7ap4cBOqNIky7K3RY51ug4baafqGgvNtmv6
	 eVWJCYV/24xC1GxEQjWsvLgZZtiVFwDYI068IG7r7/BiLmUP/I0qEYMR2yN8h3+Qqk
	 +GzNKjzoS06syk6XmQ5ywHHO2fJlAx+3xUzwxsz4dUGSMQfF3qV4mnSMCNSjKj7OCE
	 yQWXdatVf5D5l+BmX7S0QUlqwPvwxlS9uRWcXpUTzgL5QV82Pr1w3SkBHwpA+2QaZY
	 GICKaNYicnetg==
Date: Fri, 12 May 2023 11:30:12 +0200
From: Simon Horman <horms@kernel.org>
To: Jay Vosburgh <jay.vosburgh@canonical.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Andy Gospodarek <andy@greyhouse.net>,
	Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: Always assign be16 value to
 vlan_proto
Message-ID: <ZF4HJJm7Cw41M7id@kernel.org>
References: <20230420-bonding-be-vlan-proto-v2-1-9f594fabdbd9@kernel.org>
 <8715.1683848637@famine>
 <ZF4G1f2tr7SmjIs1@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZF4G1f2tr7SmjIs1@kernel.org>

On Fri, May 12, 2023 at 11:29:06AM +0200, Simon Horman wrote:
> On Thu, May 11, 2023 at 04:43:57PM -0700, Jay Vosburgh wrote:
> > Simon Horman <horms@kernel.org> wrote:
> > 
> > >The type of the vlan_proto field is __be16.
> > >And most users of the field use it as such.
> > >
> > >In the case of setting or testing the field for the special VLAN_N_VID
> > >value, host byte order is used. Which seems incorrect.
> > >
> > >It also seems somewhat odd to store a VLAN ID value in a field that is
> > >otherwise used to store Ether types.
> > >
> > >Address this issue by defining BOND_VLAN_PROTO_NONE, a big endian value.
> > >0xffff was chosen somewhat arbitrarily. What is important is that it
> > >doesn't overlap with any valid VLAN Ether types.
> > 
> > As I think you mentioned, 0xffff is marked as a reserved ethertype.
> 
> Yes, it seems that I did. It is reserved in RFC-1701.
> 
> I can work it into the patch description if you like - there is no
> particular reason I didn't for v2.
> 
> [1] https://lore.kernel.org/all/ZEI0zpDyJtfogO7s@kernel.org/
> [2] https://www.rfc-editor.org/rfc/rfc1701.html
> [3] https://www.iana.org/assignments/ieee-802-numbers/ieee-802-numbers.xhtml

I guess there will be no v2 as v2 was accepted :)

  - [net-next,v2] bonding: Always assign be16 value to vlan_proto
    https://git.kernel.org/netdev/net-next/c/c1bc7d73c964

In any case, this is now documented in the ML archives.



