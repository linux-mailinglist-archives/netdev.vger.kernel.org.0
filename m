Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6872C13C5
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 20:09:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgKWSkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 13:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:41902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbgKWSkt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 13:40:49 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 726D120658;
        Mon, 23 Nov 2020 18:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606156848;
        bh=lKYaXTjHJn8GOjDGPFp/KXiJY5WjpK+thWbciPM8/6A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iQyM1nVnsVwDXya8I17ExQ3b2MUGNnMGMBF1moe9+O5JLuJUrDCWvW6JalvGBuP2J
         aND97Q6T1Kh8guM/UKMKX7zZE5lk3vLjUGk2ZqrpL27dGFsyfNl6Yx6xIYlE6had+D
         gPE2+Fk0IlgM0P44iZhiPJZmCbAvnmSOknBYjROs=
Date:   Mon, 23 Nov 2020 10:40:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5] net/tun: Call netdev notifiers
Message-ID: <20201123104047.3f7dd7d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a00d2725bce23f451cd030b9e621a764@dev.tdt.de>
References: <20201118063919.29485-1-ms@dev.tdt.de>
        <20201120102827.6b432dc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a00d2725bce23f451cd030b9e621a764@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Nov 2020 07:18:07 +0100 Martin Schiller wrote:
> On 2020-11-20 19:28, Jakub Kicinski wrote:
> > On Wed, 18 Nov 2020 07:39:19 +0100 Martin Schiller wrote:  
> >> Call netdev notifiers before and after changing the device type.
> >> 
> >> Signed-off-by: Martin Schiller <ms@dev.tdt.de>  
> > 
> > This is a fix, right? Can you give an example of something that goes
> > wrong without this patch?  
> 
> This change is related to my latest patches to the X.25 Subsystem:
> https://patchwork.kernel.org/project/netdevbpf/list/?series=388087
> 
> I use a tun interface in a XoT (X.25 over TCP) application and use the
> TUNSETLINK ioctl to change the device type to ARPHRD_X25.
> As the default device type is ARPHRD_NONE the initial NETDEV_REGISTER
> event won't be catched by the X.25 Stack.
> 
> Therefore I have to use the NETDEV_POST_TYPE_CHANGE to make sure that
> the corresponding neighbour structure is created.
> 
> I could imagine that other protocols have similar requirements.
> 
> Whether this is a fix or a functional extension is hard to say.
> 
> Some time ago there was also a corresponding patch for the WAN/HDLC
> subsystem:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit?id=2f8364a291e8

Thanks for this info, applied to net-next.
