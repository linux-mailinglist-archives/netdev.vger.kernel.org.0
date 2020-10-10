Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFA328A218
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388827AbgJJWyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731294AbgJJTH0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Oct 2020 15:07:26 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B013D2074D;
        Sat, 10 Oct 2020 19:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602356844;
        bh=U//J7oK8UOvI+D3yYVqvuZsZOskMm+fI+U2rL182sTE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zO/7fm+tmtpjVXBtWZu7GdMo1g0G71c6zWEX+4cEPdDvG054tHdomukeUVNp2cFBd
         jSfNS3YVuan1EZx7zuCM6aqPs9uuAS6Ft/dNCsDwO7cRnglDcqGoZ4R1GR/3FOujcq
         qVcu9TXo5hESVWiZ6rtXrX3EguaDicCmEX/+aCaI=
Date:   Sat, 10 Oct 2020 12:07:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH net-next] drivers/net/wan/hdlc_fr: Move the skb_headroom
 check out of fr_hard_header
Message-ID: <20201010120723.1558558a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007183203.445775-1-xie.he.0141@gmail.com>
References: <20201007183203.445775-1-xie.he.0141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 11:32:03 -0700 Xie He wrote:
> Move the skb_headroom check out of fr_hard_header and into pvc_xmit.
> This has two benefits:
> 
> 1. Originally we only do this check for skbs sent by users on Ethernet-
> emulating PVC devices. After the change we do this check for skbs sent on
> normal PVC devices, too.
> (Also add a comment to make it clear that this is only a protection
> against upper layers that don't take dev->needed_headroom into account.
> Such upper layers should be rare and I believe they should be fixed.)
> 
> 2. After the change we can simplify the parameter list of fr_hard_header.
> We no longer need to use a pointer to pointers (skb_p) because we no
> longer need to replace the skb inside fr_hard_header.
> 
> Cc: Krzysztof Halasa <khc@pm.waw.pl>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>

Applied, thanks!
