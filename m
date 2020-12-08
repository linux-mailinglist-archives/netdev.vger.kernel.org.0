Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C282D34AE
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 22:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgLHUzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 15:55:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:50508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729304AbgLHUzi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 15:55:38 -0500
Date:   Tue, 8 Dec 2020 12:54:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607460898;
        bh=fEdhRm9lL9OjlycN6kt/uxjyoR1QjmzN4bXa/Dnwce4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=NxjmbkGt82RU/dwrMCIce64G9ZMB9Fn+sJe8sEPAstACzQ/XtflJ8yuEDcS4tUA5O
         QD0FhoqpleE5J/UZuFpdmN/xpqKCiAQAkeLHHaRvDzXqhOBlPJklW4yIdteT97vKYQ
         eoZOSw+pAV2JR97xj331Ylu5xImQE51VJ7lyoHWr9EnAkIbQUh91ZGah7dhKAdZqzm
         zUBlGiQ/HkxebiD5AHsQO2w7+m7sywo19CprjwHzDPJz/nBx9yYqGpZ1DM8Rq07By9
         dQunCDl51+MvE+jFUbL/QvPg36Nx0gRN8S6OMDOz5iIQfBqkGPzWbtUQdx06/AStaA
         pF/0sXojhkUfA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: Re: [PATCH net v2] net/tls: Fix kernel panic when socket is in tls
 toe mode
Message-ID: <20201208125457.05b6f323@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <3047d30a-0fc0-c241-e0e9-641ab99c243b@chelsio.com>
References: <20201205113529.14574-1-vinay.yadav@chelsio.com>
        <20201208101927.39dddc85@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <3047d30a-0fc0-c241-e0e9-641ab99c243b@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Dec 2020 00:46:23 +0530 Vinay Kumar Yadav wrote:
> On 12/8/2020 11:49 PM, Jakub Kicinski wrote:
> > On Sat,  5 Dec 2020 17:05:30 +0530 Vinay Kumar Yadav wrote:  
> >> When socket is in tls-toe (TLS_HW_RECORD) and connections
> >> are established in kernel stack, on every connection close
> >> it clears tls context which is created once on socket creation,
> >> causing kernel panic. fix it by not initializing listen in
> >> kernel stack incase of tls-toe, allow listen in only adapter.  
> > 
> > IOW the socket will no longer be present in kernel's hash tables?
>
> Yes, when tls-toe devices are present.

I don't think that's acceptable for a transparently enabled
netdev-sanctioned feature.

