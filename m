Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362F92ACDCC
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 05:05:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733148AbgKJEFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 23:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:36944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732780AbgKJEFY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 23:05:24 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35F1E20663;
        Tue, 10 Nov 2020 04:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604981124;
        bh=XjcPe3ZKvGYixKKcUDGjtRvK8+Tci2+e6h+hX1vPkDo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uFkj2Z4FiElp+nwW9KGVBgAFzFDc8YUEaX5ArV8ABbnGyzNI7Hrp7Z/gaxYr0aU2u
         zejxHoKDswDKNIGawAmw+kVcrBdmsyImUir8jfOrnLYIpkZmGfH/gr2j7YFx5q64QL
         7KJtQkq/nZRsSnFmF0w/HwBtxwtR2y2V0BZBp5fY=
Date:   Mon, 9 Nov 2020 20:05:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Willem de Bruijn <willemb@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: skb_vlan_untag(): don't reset
 transport offset if set by GRO layer
Message-ID: <20201109200522.7a8fdecf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7JgIkgEztzt0W6ZtC9V9Cnk5qfkrUFYcpN871syCi8@cp4-web-040.plabs.ch>
References: <7JgIkgEztzt0W6ZtC9V9Cnk5qfkrUFYcpN871syCi8@cp4-web-040.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 09 Nov 2020 23:47:23 +0000 Alexander Lobakin wrote:
> Similar to commit fda55eca5a33f
> ("net: introduce skb_transport_header_was_set()"), avoid resetting
> transport offsets that were already set by GRO layer. This not only
> mirrors the behavior of __netif_receive_skb_core(), but also makes
> sense when it comes to UDP GSO fraglists forwarding: transport offset
> of such skbs is set only once by GRO receive callback and remains
> untouched and correct up to the xmitting driver in 1:1 case, but
> becomes junk after untagging in ingress VLAN case and breaks UDP
> GSO offload. This does not happen after this change, and all types
> of forwarding of UDP GSO fraglists work as expected.
> 
> Since v1 [1]:
>  - keep the code 1:1 with __netif_receive_skb_core() (Jakub).
> 
> [1] https://lore.kernel.org/netdev/zYurwsZRN7BkqSoikWQLVqHyxz18h4LhHU4NFa2Vw@cp4-web-038.plabs.ch
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Applied, thanks!
