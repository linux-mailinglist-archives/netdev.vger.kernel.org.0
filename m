Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9012AC3D5
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 19:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730007AbgKIS2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 13:28:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgKIS2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 13:28:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C824020663;
        Mon,  9 Nov 2020 18:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604946523;
        bh=a4yqBufJSemR5x2xgiqTicc/PVnLKqBSHca/NqWDKvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QBYdDStOv6THWlQsDxEom5RCLNrlCwIFNiNcgvynCXtyozpBw2+DONHDqQYnFo0h8
         dCJvP5y/3GGp2h0+qauE4Viw8qIogc+vPyneVfRtk4X+iIBQ8UcGNIVfvx2dr97Kok
         3zR3dXkMLGA8lkhPJf77z0QHYmFroun10hhOyRx8=
Date:   Mon, 9 Nov 2020 10:28:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH] net: udp: remove redundant initialization in
 udp_gro_complete
Message-ID: <20201109102841.2d807fd6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604644960-48378-3-git-send-email-dong.menglong@zte.com.cn>
References: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
        <1604644960-48378-3-git-send-email-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 01:42:39 -0500 menglong8.dong@gmail.com wrote:
>  {
>  	__be16 newlen = htons(skb->len - nhoff);
>  	struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
> -	int err = -ENOSYS;
> +	int err;
>  	struct sock *sk;

You can also move the err declaration below struct sock *sk; to get
this closer to revert xmas tree order. In other patches it'd increase
change / potential conflict radius but here the correct position is
close enough so we can move.

