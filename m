Return-Path: <netdev+bounces-8264-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26A2F723572
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 04:47:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF4782814E4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:47:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6E437B;
	Tue,  6 Jun 2023 02:47:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D5D361
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0ECC433EF;
	Tue,  6 Jun 2023 02:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686019666;
	bh=3rkJBlmVsHScoahu0gLiLxVKbOsS87fP4LTbCBUZWfw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SeLN1yTBOL0GIwQ7su3nnvPMY/xZ7BFs/6OVT54nsbvLgYA9d/yFC1pFtOZoajbuJ
	 xMPaA4MwQnLJ5A6W2l2n6xuppn3pW1YpFvM/anGiGqj7fHTgGulElk2oc6KzPT3HkC
	 XuNf2LYZtYSyN7FF1B15J2+DjbI43ZElmOwhGXzB/4QGDNepIXVHyOt7eghr1AgO4r
	 yn6WTVi/Mr4AZGSsixuvvYIQOFnUL9qGHofXR26ZM8oKCyMDQkVWae1+odqYbY7edM
	 Y7Ufx4yWHjU/UHH4jIjvxJt4Kvphn/ULG9fad3LdoPpCTXS5GVbmHDrWIyUkwNDcwJ
	 yOOqePBPAkcVQ==
Message-ID: <d82b1644-31fa-3c03-50d6-ebb5f0d584c2@kernel.org>
Date: Mon, 5 Jun 2023 20:47:45 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/2] tcp: Set route scope properly in
 cookie_v4_check().
Content-Language: en-US
To: Guillaume Nault <gnault@redhat.com>, David Miller <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
References: <cover.1685999117.git.gnault@redhat.com>
 <045a05d5134c2443600589377a9c37b40581595c.1685999117.git.gnault@redhat.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <045a05d5134c2443600589377a9c37b40581595c.1685999117.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/23 3:55 PM, Guillaume Nault wrote:
> RT_CONN_FLAGS(sk) overloads flowi4_tos with the RTO_ONLINK bit when
> sk has the SOCK_LOCALROUTE flag set. This allows
> ip_route_output_key_hash() to eventually adjust flowi4_scope.
> 
> Instead of relying on special handling of the RTO_ONLINK bit, we can
> just set the route scope correctly. This will eventually allow to avoid
> special interpretation of tos variables and to convert ->flowi4_tos to
> dscp_t.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  net/ipv4/syncookies.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>



