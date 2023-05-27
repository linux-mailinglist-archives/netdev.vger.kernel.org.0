Return-Path: <netdev+bounces-5837-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6A6B71314C
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 03:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 400D71C20F1B
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 01:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BDCE380;
	Sat, 27 May 2023 01:08:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D723737D
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 01:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECFFC433D2;
	Sat, 27 May 2023 01:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685149726;
	bh=5zHdJvK0bRkHVe/BmCiGndweGuWhBH6cjRIMmLkfBi8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Yn5ttwEb4eOBNsxFRNaaKLoRAE0oaarcy3jczitqa0fQZz9JIWsPlV+QDEjoOazUV
	 JeoDyIHBJEW1zs0+LkrRU3D4B0eb3PvBLeuri5uSFyD5UMg3QdX2JV9y3IYQv1BIlW
	 puUR5KhLkbtSPGR9HUhR6ZxrtxZFOot1yo8YBVmOye1fNsuPh4kzZgl00bOSU+vZfh
	 ayjW+kLDNYEYmSznXcLjQdTM/yIdiJUuil/DoaFN58Sb1dn8KIrXrU8jSNZSlfdLQB
	 RjyQ+iwmAxl/x94z8JS5lAZ5YBOa8lBvYztVJQOGK15c70HVS62KyyB566CnEW0lHQ
	 sm6Xh/p7tt7xw==
Date: Fri, 26 May 2023 18:08:44 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>, David Ahern <dsahern@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Chuck Lever
 <chuck.lever@oracle.com>, Boris Pismenny <borisp@nvidia.com>, John
 Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next 09/12] tls/sw: Support MSG_SPLICE_PAGES
Message-ID: <20230526180844.73745d78@kernel.org>
In-Reply-To: <20230524153311.3625329-10-dhowells@redhat.com>
References: <20230524153311.3625329-1-dhowells@redhat.com>
	<20230524153311.3625329-10-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 24 May 2023 16:33:08 +0100 David Howells wrote:
> +static int rls_sw_sendmsg_splice(struct sock *sk, struct msghdr *msg,

s/rls/tls/ ?

Will the TLS selftests under tools/.../net/tls.c exercise this?

