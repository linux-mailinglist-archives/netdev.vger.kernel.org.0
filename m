Return-Path: <netdev+bounces-8675-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E430725297
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 05:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B1A52811E2
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 03:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DD9C80B;
	Wed,  7 Jun 2023 03:54:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64447C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 03:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B54CC433EF;
	Wed,  7 Jun 2023 03:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686110079;
	bh=lipBdfsrWW5U0xjBpTPT3ABPpxcdQFIPfd2IFiOUgNc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QCV6XLflw/NJOGtOegGp36oA4bQY0p+0RGE1AEmJjv5H22cdKjzlh/chTPZSCqo7d
	 o4sUJdtoHGCBdw1euRdxLQB5HqDooBMdFj6eA4JnDP9gkY5j3epfFaobL4/4I7BQUq
	 j+nbKWAwIWKBpwLxea+zZPyAzAE6Sx6/QtsHM9gUPSJ9H+5+b5MBMX4wqIjBIrocGA
	 EoEdbZu11I60omxq/SZtoACfjxvGwvHFUH/xXfjzSxTy9XliOdyojXgk0ADcnjcRGM
	 OUrbNPCOazk3O6FKI7uVjlbMjTz3QIPDoo8z9LsFvWfTclJIiHwfHW86jvz88yys82
	 jIew+n89qRt3Q==
Date: Tue, 6 Jun 2023 20:54:37 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, simon.horman@corigine.com, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>, Daniil Tatianin
 <d-tatianin@yandex-team.ru>, Marco Bonelli <marco@mebeim.net>, Gal Pressman
 <gal@nvidia.com>, Jiri Pirko <jiri@resnulli.us>, Sean Anderson
 <sean.anderson@seco.com>, Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, linux-kernel@vger.kernel.org (open
 list)
Subject: Re: [PATCH net-next] ethtool: ioctl: improve error checking for
 set_wol
Message-ID: <20230606205437.49378d25@kernel.org>
In-Reply-To: <1685990778-34039-1-git-send-email-justin.chen@broadcom.com>
References: <1685990778-34039-1-git-send-email-justin.chen@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  5 Jun 2023 11:46:16 -0700 Justin Chen wrote:
> +	if (wol.wolopts & ~cur_wol.supported)
> +		return -EOPNOTSUPP;

One small comment - I think we should return -EINVAL here.
That's what netlink return and we seem to mostly return -EOPNOTSUPP
if the operation is completely not supported.
-- 
pw-bot: cr

