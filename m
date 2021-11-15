Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C41E4523CE
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 02:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347669AbhKPBbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 20:31:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:58138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240295AbhKOSzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 13:55:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D961633CD;
        Mon, 15 Nov 2021 18:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636999912;
        bh=XnBUmT4IEfROVKFOF8iKEWFMoemrVZoFrufQvBgFHz8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IKfEUTaJulx86PU7vhUA6uoHMD3uhARDvITy708eFPKpVxE09UjvI8O3tc8TCIydW
         utRHO0Q3rVzDqpTteobX1aqM+l0EJ8B5fsbSPYvcGUJ0xcWS4qEQlWGNJCc5gCzbiR
         yWL6+qIpBjyaDdw2Xu9r8qCGv1+1QMXaqF41k6fpc2kXAtbIu+yrmPac6YklQ0fMMj
         wIt0ur8CZNixW2JQg65I130V6xU/XmxaUKYf8rgGg+eIwCj+3oAh0aJn6A8OatQv49
         zpyEhmEPvLqiYXshX+2MF7PDultGuMLgrIuBM38rkB2bPngwsYjwjR5IyQTMOXq3dN
         p2DrtSkF0K3JQ==
Date:   Mon, 15 Nov 2021 10:11:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, hawk@kernel.org,
        syzbot+4c63f36709a642f801c5@syzkaller.appspotmail.com
Subject: Re: [RFC net-next] net: guard drivers against shared skbs
Message-ID: <20211115101150.137485cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d719cc02-7963-bdf9-b6cd-494022b5d361@gmail.com>
References: <20211115163205.1116673-1-kuba@kernel.org>
        <88391a1a-b8e4-96ca-7d80-df5c6674796d@gmail.com>
        <20211115093512.63404c26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d719cc02-7963-bdf9-b6cd-494022b5d361@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 09:59:56 -0800 Eric Dumazet wrote:
> > The IFF_TX_SKB_SHARING flag is pretty toothless as it stands.
> 
> skb_padto() needs to be replaced by something better.
> so that skb can be cloned if needed.
> 
> 
> static inline int skb_padto(struct sk_buff *skb, unsigned int len)
> 
> ->  
> 
> static inline struct sk_buff *skb_padto(struct sk_buff *skb, unsigned int len)

Indeed, that was my first instinct but I wasn't up for fixing up all
the drivers which call skb_pad(), skb_cow_head() etc.

Let me leave this be for now..
