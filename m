Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E065393904
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbhE0XPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234964AbhE0XPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:15:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11562613BA;
        Thu, 27 May 2021 23:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622157236;
        bh=PxV0VFvJUbXepG5o+DjZWWqzm1cj6Ahmx3K9xTerrEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nGm/Jp6VldF70mNYkfttZykvhrblPlq/vqDshuRJh9XFUP2hWl1Yn3X04pjwgSXtc
         erx9fv7AtJ3ZpjvFDaJ21ouQbY6ST3i00x9CjgPSNKwsZNA3oUyDZhO9AdVJuvME72
         /lSmgIqTzq06qpEA4ES/V4nSPuPnQuQcIt9M7X2A4oqYIVKLzDDRzxA8XvM3iqwKVD
         mRlw8Q9s0/3BdxXq5hv61PJanpNxUlxz09QSQ6ho/yP5QHukr5oDq9qNj3DxTjpVjF
         CqwZYWi8nY8Q3HRIqDAuJHFBBkvrUgmPIwjMyppfa0qp+F6EoDcpmV1i6s7IraDzBY
         euIQLFQyR/HAw==
Date:   Thu, 27 May 2021 16:13:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tanner Love <tannerlove.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [PATCH net-next 1/3] net: flow_dissector: extend bpf flow
 dissector support with vnet hdr
Message-ID: <20210527161355.35cac718@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527211214.1960922-2-tannerlove.kernel@gmail.com>
References: <20210527211214.1960922-1-tannerlove.kernel@gmail.com>
        <20210527211214.1960922-2-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 17:12:12 -0400 Tanner Love wrote:
> @@ -915,7 +916,8 @@ bool __skb_flow_dissect(const struct net *net,
>  			const struct sk_buff *skb,
>  			struct flow_dissector *flow_dissector,
>  			void *target_container, const void *data,
> -			__be16 proto, int nhoff, int hlen, unsigned int flags)
> +			__be16 proto, int nhoff, int hlen, unsigned int flags,
> +			const struct virtio_net_hdr *vhdr)
>  {
>  	struct flow_dissector_key_control *key_control;
>  	struct flow_dissector_key_basic *key_basic;

net/core/flow_dissector.c:922: warning: Function parameter or member 'vhdr' not described in '__skb_flow_dissect'

Please try to check W=1 C=1 builds, you may want to compile only the
object files you changed otherwise for a change like this, touching
skbuff.h, you'll drown in old warnings.
