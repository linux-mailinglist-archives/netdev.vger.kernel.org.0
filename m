Return-Path: <netdev+bounces-4833-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 877CC70EA74
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 02:50:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51A431C209F7
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 00:50:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 559EAED8;
	Wed, 24 May 2023 00:50:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449C1ED5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 00:50:01 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33C4126;
	Tue, 23 May 2023 17:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=O4zO94iFTrLjEiMrq1dnb+x3JXQnGuk03+XEMWVY2So=; b=wYbhQOg5kZ7jk5zD083qFdm86E
	mhGO4DMm6pld8ANOD5zePR/6jmBHk9Wx+H89xqedEjfv2R88n8qQ06mvbH0lzhKzAWAEwzh7jzYEl
	bWMpoqMuScq2+pwbJw0xw2Y11uCSqKaJWVykww06h7OezfE2nHJ2AoRLzCKLM8L35s6s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q1cgw-00DjwO-8o; Wed, 24 May 2023 02:49:26 +0200
Date: Wed, 24 May 2023 02:49:26 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Kenny Ho <Kenny.Ho@amd.com>
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, y2kenny@gmail.com
Subject: Re: [PATCH] Remove hardcoded static string length
Message-ID: <01936d68-85d3-4d20-9beb-27ff9f62d826@lunn.ch>
References: <20230523223944.691076-1-Kenny.Ho@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523223944.691076-1-Kenny.Ho@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 06:39:44PM -0400, Kenny Ho wrote:
> UTS_RELEASE length can exceed the hardcoded length.  This is causing
> compile error when WERROR is turned on.
> 
> Signed-off-by: Kenny Ho <Kenny.Ho@amd.com>
> ---
>  net/rxrpc/local_event.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/rxrpc/local_event.c b/net/rxrpc/local_event.c
> index 19e929c7c38b..61d53ee10784 100644
> --- a/net/rxrpc/local_event.c
> +++ b/net/rxrpc/local_event.c
> @@ -16,7 +16,7 @@
>  #include <generated/utsrelease.h>
>  #include "ar-internal.h"
>  
> -static const char rxrpc_version_string[65] = "linux-" UTS_RELEASE " AF_RXRPC";
> +static const char rxrpc_version_string[] = "linux-" UTS_RELEASE " AF_RXRPC";

This is not an area of the network stack i know about, so please
excuse what might be a dumb question.

How is the protocol defined here? Is there an RFC or some other sort
of standard?

A message is being built and sent over a socket. The size of that
message was fixed, at 65 + sizeof(whdr). Now the message is variable
length. Does the protocol specification actually allow this?

	Andrew

