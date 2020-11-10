Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841502ADCC7
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 18:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbgKJRUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 12:20:49 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34251 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730468AbgKJRUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 12:20:47 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 577A65C0227;
        Tue, 10 Nov 2020 12:20:46 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 10 Nov 2020 12:20:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=84MVI1hJhNT31Xk7TQ7ZgqM+LNd
        Ht8JzQKvLOm0WCEc=; b=kdqVWYehZC/aHJyxtQ+tj/Ohs/Zas9NrBwM/FFDhcx5
        aZwawoaY/mPL+U5S1+y2PoVNtkXgnL8f8ouX29KS/G4V36cH8+yOAKNT7gS5ji3G
        wSUVKSVo+lYoB4IUUgWNNReZO6zfv2ctOJ25HjFCLLeOJZUjM6D9Zr4HRFPwGjfH
        qJxjyjox/xavsVeCHSX5oGyBM5j0FNUbTfwxNtFis8DZOJdtxTxI5YljnibPvYbn
        1BaL6n82Tx+Rl3vIRG+odBt0Ezi5ms+1ugRuGRIVqxMBOTc1utTt5KzMcsjMoplO
        xBBBElzdVi7KFlCdkxtnT7sCjnX0NcBvMi+uuMFOfIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=84MVI1
        hJhNT31Xk7TQ7ZgqM+LNdHt8JzQKvLOm0WCEc=; b=qB9Ue4GLLKOXJg+rs92yf3
        WW2umT4OlL9XVnMwIES9rl22vJCJG/+mWs/ctaO6KGIwnLMtJr4JpWZzXpsBTG4Q
        UcAJ9b9tza9dw3tQBg7J17TTW9EBfZW0V4SgpxLntUT5fPwOMoiKqlczmpJtkljr
        xxwKHo2iPUFbpPFs0G4haZk1NEF4IABi/TM8gTR5fN369nvXk2GCp/6RYCzXThpU
        03zt5NcPEHtAiJ6x7Fq1TDTlMveu5oRqP4U4DsgQRYQfUx4sQto6DHP8p+jNxZkN
        y6KeCNglmoUXqGx8knYvLTVQ4Mo8A3tyxfq3slFkJhcLYhKAmpToVj5emVvof0OQ
        ==
X-ME-Sender: <xms:7cuqX83THI0Wx-mWTuW12d61OQuNTvGuEWqKvAqPCu2x1vXWsjSTsA>
    <xme:7cuqX3F4gkpwKiK49h8zym036jhHnvwkwmlcR9BEWEIde3KDHny9cn9aBryoh0j7_
    hHGyDBz4f7Fzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghh
    rdgtohhm
X-ME-Proxy: <xmx:7cuqX04mT--RAeg3q5caIeIpiPOfR0Qm2zX-EP7024Ggv2dvXtpiSg>
    <xmx:7cuqX13P6DleW_YxwdgC_9XVJVRNrIRtaA4W4c98Dnlh9fYrp8EHKw>
    <xmx:7cuqX_Gcbd4lFZ7P7ZBfTEChKELmmTwZzNEvQnB0uGMXdOsOD5L2qA>
    <xmx:7suqX07GSpL2fXrH9qG9rX8bJb2MSonT7Vw9TEFYLtG2kRuAUhJlBA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CA2C2328006B;
        Tue, 10 Nov 2020 12:20:44 -0500 (EST)
Date:   Tue, 10 Nov 2020 18:21:41 +0100
From:   Greg KH <greg@kroah.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Chen Minqiang <ptpt52@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 26/55] wireguard: selftests: check that
 route_me_harder packets use the right sk
Message-ID: <X6rMJe+bF+/ZyyTz@kroah.com>
References: <20201110035318.423757-1-sashal@kernel.org>
 <20201110035318.423757-26-sashal@kernel.org>
 <CAHmME9pPbitUYU4CcLaikQLOMjj-=b16nVXgp6+jh1At4Y=vNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9pPbitUYU4CcLaikQLOMjj-=b16nVXgp6+jh1At4Y=vNg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 01:29:41PM +0100, Jason A. Donenfeld wrote:
> Note that this requires
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=46d6c5ae953cc0be38efd0e469284df7c4328cf8
> And that commit should be backported to every kernel ever, since the
> bug is so old.

Sasha queued this up to 5.4.y and 5.9.y, but it looks like it doesn't
easily apply to older kernels.  If you think that it's needed beyond
that, I'll gladly take backported patches.

thanks,

greg k-h
