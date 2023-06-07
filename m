Return-Path: <netdev+bounces-9053-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E77E726CF8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:38:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B4FE281242
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 986621ACB2;
	Wed,  7 Jun 2023 20:38:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193D819E58;
	Wed,  7 Jun 2023 20:38:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C530DC4339C;
	Wed,  7 Jun 2023 20:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686170287;
	bh=rPUHEPERLm0DXG4pXZwSjeSGww4CDsRDvqeL184e0ZI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RwPiP0ZqgMhbmO69KJMWKgjyDmw2DU+Uq2Q+wsJ6Ykw6Iz9jKpPLGiP3PtocJpEzk
	 2CVKCmg4yT/KV6j4mPpeqQ23pJX4t5g0IkDUFpHdc4i1cV1pmGSKQFB66jnXtL8JKO
	 OM7gV87EK/USNmftlnhvilSKzUYjImtHxRXUeqLzMxa8R9GJKTCtJLRqF7Y7bC8zBh
	 DyA12yt13ok4+AX2LQ1uRQPbTTBv7DlsQvU6ValAs4WzvW2hZ9ttvURzadLgLxRv4S
	 S+MHRjWomI2NgIqke51H4XpJUh8it8RmcI3ild6mST+lr74KeC0Sj6RMUc7L8985s2
	 CJyy9k+p5Ymbw==
Date: Wed, 7 Jun 2023 13:38:05 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
 olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
 wei.liu@kernel.org, edumazet@google.com, pabeni@redhat.com,
 leon@kernel.org, longli@microsoft.com, ssengar@linux.microsoft.com,
 linux-rdma@vger.kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
 bpf@vger.kernel.org, ast@kernel.org, sharmaajay@microsoft.com,
 hawk@kernel.org, tglx@linutronix.de, shradhagupta@linux.microsoft.com,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next,V2] net: mana: Add support for vlan tagging
Message-ID: <20230607133805.58161672@kernel.org>
In-Reply-To: <1686170042-10610-1-git-send-email-haiyangz@microsoft.com>
References: <1686170042-10610-1-git-send-email-haiyangz@microsoft.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  7 Jun 2023 13:34:02 -0700 Haiyang Zhang wrote:
> To support vlan, use MANA_LONG_PKT_FMT if vlan tag is present in TX
> skb. Then extract the vlan tag from the skb struct, and save it to
> tx_oob for the NIC to transmit. For vlan tags on the payload, they
> are accepted by the NIC too.
> 
> For RX, extract the vlan tag from CQE and put it into skb.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
> V2:
> Removed the code that extracts inband tag, because our NIC accepts
> inband tags too.

Please don't rush multiple versions, if your previous version is buggy
you have to reply to it saying so and then wait before posting v2.

Reviewing something just to find there is a v2 already posting is one
of the more annoying experiences for maintainers and reviewers.

Quoting documentation:

  Resending after review
  ~~~~~~~~~~~~~~~~~~~~~~
  
  Allow at least 24 hours to pass between postings. This will ensure reviewers
  from all geographical locations have a chance to chime in. Do not wait
  too long (weeks) between postings either as it will make it harder for reviewers
  to recall all the context.
  
  Make sure you address all the feedback in your new posting. Do not post a new
  version of the code if the discussion about the previous version is still
  ongoing, unless directly instructed by a reviewer.
  
See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#resending-after-review

