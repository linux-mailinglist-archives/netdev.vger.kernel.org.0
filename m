Return-Path: <netdev+bounces-8263-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1285723571
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 04:47:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF8D11C20E2A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:47:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8121E37B;
	Tue,  6 Jun 2023 02:47:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8556A361
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:47:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C775BC433D2;
	Tue,  6 Jun 2023 02:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686019628;
	bh=qCSlsJPTwN1ZLzh887T2q4Gz/Ig6OnZKLxHkZQxhG9A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W4OAELkJ9ctO4cwruJ6F/VqeJl5SMm28/aSnMmEq0NuloN5XO58nlO97v2qBjf3jm
	 Z3XhutYkJ0qBTr3cylXI7H+qFVcI/u4sDGYpi/nexf5Ax2WAGM2vNtCHuJQIlHN3G7
	 YK20LmI0i6p92l+705JFepxZSnrllGAYMqrBqJpdjdk1MyhvgjsRGbmm2WvMV8AuXA
	 xDW9IEikyW83eJb+qbUrObUFS6HCqCKrJsdfo6VylHguyWttrSrI3bDLELiKyRhdSd
	 nIH7mfmmKK+EiS8hFdVx7OCFP0JeR1KYtR7EGradvvY03A2wGpJ/D1XhAIPqyboX6o
	 NlHmf/Pb7Ho3w==
Message-ID: <3df5cd7d-ef75-1397-bb35-d9c56d8acfd2@kernel.org>
Date: Mon, 5 Jun 2023 20:47:06 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] ipv4: Set correct scope in
 inet_csk_route_*().
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
References: <cover.1685999117.git.gnault@redhat.com>
 <08fb058e8cf99ab1f9178caac52e665f94fcba3c.1685999117.git.gnault@redhat.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <08fb058e8cf99ab1f9178caac52e665f94fcba3c.1685999117.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/23 3:55 PM, Guillaume Nault wrote:
> RT_CONN_FLAGS(sk) overloads the tos parameter with the RTO_ONLINK bit
> when sk has the SOCK_LOCALROUTE flag set. This is only useful for
> ip_route_output_key_hash() to eventually adjust the route scope.
> 
> Let's drop RTO_ONLINK and set the correct scope directly to avoid this
> special case in the future and to allow converting ->flowi4_tos to
> dscp_t.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/ipv4/inet_connection_sock.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



