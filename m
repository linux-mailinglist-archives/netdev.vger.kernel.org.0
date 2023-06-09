Return-Path: <netdev+bounces-9615-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FE8F72A044
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:36:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B156281A51
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0654B19BCC;
	Fri,  9 Jun 2023 16:36:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22869111B0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1142C433EF;
	Fri,  9 Jun 2023 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686328569;
	bh=C/0zvF3LbxzsYzTV8LNFkGL9FKxoXmKzW7f/HdTT+Go=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sioPIkQ+nhX3uBvnpEYHxACi0LitOQnHbDFZkon9/VW1KIhwxcGGxM4lorbdN15aZ
	 1ybACNA6LAMcbK2AEpJwJq0Sljq3KfgSFZW6nFZLjMlkoI/9MJqpEni/KixqXZaPmC
	 qzsBqwzDrHvVCQKlVthHTpkTzstUnCCmErxEKrdzL0UBWh6Gc91R9EUnmsn92qvRK7
	 wzjUdKtzgPw5cw+YlaWTHMIx6SJaxU9qZN9jwx+uJe2C6QYCXQbxXPjg8lqiZWVeQY
	 MxHnLDcYePN9bSMS7ZKWn3OGzkAarWxyRj+vHH9nh/THUZfay+dinlL89PPHemAM6L
	 M/RfkIubwDMYw==
Date: Fri, 9 Jun 2023 09:36:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, mkubecek@suse.cz, danieller@nvidia.com,
 idosch@nvidia.com, netdev@vger.kernel.org, vladyslavt@nvidia.com
Subject: Re: [PATCH ethtool-next] sff-8636: report LOL / LOS / Tx Fault
Message-ID: <20230609093607.72a8e3f2@kernel.org>
In-Reply-To: <ZINQ02Qrh/X+/Evy@shell.armlinux.org.uk>
References: <20230609004400.1276734-1-kuba@kernel.org>
	<7aaec2ea-5459-46c6-877c-41d9cf93bcc1@lunn.ch>
	<ZINQ02Qrh/X+/Evy@shell.armlinux.org.uk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Jun 2023 17:18:27 +0100 Russell King (Oracle) wrote:
> My mental stumbling block is that quad interfaces seem to act as either
> four separate network interfaces, or I think the lanes can be combined
> to double or quadruple the data bandwidth. How this looks from the
> firmware description perspective (in either DT or elsewhere) I don't
> know. Can they be dynamically changed too?

Last question I think I can answer at least from the uAPI perspective -
yes, via the devlink port split API. There's also an ethtool API for
configuring how many lanes are used within a single MAC (e.g. 2x25G vs
1x50G).

