Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C47D2F9050
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 04:14:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728163AbhAQDNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 22:13:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728149AbhAQDNm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Jan 2021 22:13:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 859A422CB8;
        Sun, 17 Jan 2021 03:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610853181;
        bh=aSE/5fa+/d6n/5dgf7LQQDIvMYJeA4lIqvsklDX7xuw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q3QCkijLqDohihaw+k6eP2uGnxVreQQvwiTvk2YnxR0M8fI1veBZkFRFLqGq1Cu70
         1mt5k8X3kdPLWorfdGScU7Evr+MX8ywST/Y3ITncbpJQT2TR+9bSg5HRoxnimupAdM
         1EPN2N8i25edTn8DK3aKunGir4qXIPEbDNx2l9plnJ9PDu3RT5gM5n4TjmNnVpZ9W8
         RyYighelTxsqM2kfxXAN8D7vIFwDi1/y06mE8A11qkpDE3GfbhLpqCOIPLBkg/ibTx
         mL5PDoNMfzI+avmODnEJzgYYVXgSW0UtSc00iWjvZwTyD8d0gHOm6JCabXjE0oUMse
         jiorbGp66xkgw==
Date:   Sat, 16 Jan 2021 19:13:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCHv3 net-next 1/2] net: move the hsize check to the else
 block in skb_segment
Message-ID: <20210116191300.25c2bf27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKgT0Uc1iObzmeFL8G91jxKxvWARb4z2bJJxv6yJ+5QOYPJQsQ@mail.gmail.com>
References: <cover.1610703289.git.lucien.xin@gmail.com>
        <bfecc76748f5dc64eaddf501c258dca9efb92bdf.1610703289.git.lucien.xin@gmail.com>
        <CAKgT0Uc1iObzmeFL8G91jxKxvWARb4z2bJJxv6yJ+5QOYPJQsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 17:39:02 -0800 Alexander Duyck wrote:
> On Fri, Jan 15, 2021 at 1:36 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > After commit 89319d3801d1 ("net: Add frag_list support to skb_segment"),
> > it goes to process frag_list when !hsize in skb_segment(). However, when
> > using skb frag_list, sg normally should not be set. In this case, hsize
> > will be set with len right before !hsize check, then it won't go to
> > frag_list processing code.
> >
> > So the right thing to do is move the hsize check to the else block, so
> > that it won't affect the !hsize check for frag_list processing.
> >
> > v1->v2:
> >   - change to do "hsize <= 0" check instead of "!hsize", and also move
> >     "hsize < 0" into else block, to save some cycles, as Alex suggested.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>  
> 
> Looks good to me.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Applied, thanks!
