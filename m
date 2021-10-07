Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69FB425562
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242038AbhJGO3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233375AbhJGO3r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:29:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16201610E6;
        Thu,  7 Oct 2021 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633616873;
        bh=OUDtHv9D7wI/MWFyw8NMUCU3Td9FtIyM3D79kD2hZAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lP1JnDIuAbwwTH8gLflWLfd1B3OZ6lKM8evdGfL3Lu1GxUMiPvYNP9VDbLi2k4SOa
         eZ81Dw63TSyQQyg+0Sx0thQdOAkKKwLwqQn5u+Yoek82U0GIfMxeBhCK5eWH3/MpNo
         nxLEQtqthW7X2INJpkgUw7SfKBpJKpsvil1Xa+BCqiQ5QMQrcAJqTJAkAAWVCPW6bI
         8NNKDseC9hKXM+5T/BG5fZWspJlIb0w3ykGtJ5TbzcyszQrqKsY+KPJrMv3AbfImPI
         HQle0d27DHFwDP1GH0+3ulfPc8s33iG0VhPw6wi14Hr8aOjcBRCjKSAR4+3BaMM7Tn
         Iv5CflXA0+9eQ==
Date:   Thu, 7 Oct 2021 07:27:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>,
        Mike Manning <mvrmanning@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Saikrishna Arcot <sarcot@microsoft.com>
Subject: Re: [PATCH] net: prefer socket bound to interface when not in VRF
Message-ID: <20211007072752.257c3bcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9907e6ff-3904-fa66-6562-c3b885eebd34@gmail.com>
References: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
        <20211007070720.31dd17bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9907e6ff-3904-fa66-6562-c3b885eebd34@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Oct 2021 08:10:17 -0600 David Ahern wrote:
> On 10/7/21 8:07 AM, Jakub Kicinski wrote:
> > On Tue, 5 Oct 2021 14:03:42 +0100 Mike Manning wrote:  
> >> The commit 6da5b0f027a8 ("net: ensure unbound datagram socket to be
> >> chosen when not in a VRF") modified compute_score() so that a device
> >> match is always made, not just in the case of an l3mdev skb, then
> >> increments the score also for unbound sockets. This ensures that
> >> sockets bound to an l3mdev are never selected when not in a VRF.
> >> But as unbound and bound sockets are now scored equally, this results
> >> in the last opened socket being selected if there are matches in the
> >> default VRF for an unbound socket and a socket bound to a dev that is
> >> not an l3mdev. However, handling prior to this commit was to always
> >> select the bound socket in this case. Reinstate this handling by
> >> incrementing the score only for bound sockets. The required isolation
> >> due to choosing between an unbound socket and a socket bound to an
> >> l3mdev remains in place due to the device match always being made.
> >> The same approach is taken for compute_score() for stream sockets.
> >>
> >> Fixes: 6da5b0f027a8 ("net: ensure unbound datagram socket to be chosen when not in a VRF")
> >> Fixes: e78190581aff ("net: ensure unbound stream socket to be chosen when not in a VRF")
> >> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>  
>
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thanks!
