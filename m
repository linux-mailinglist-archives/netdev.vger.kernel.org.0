Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E83246AF23
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbhLGAaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:30:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56010 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378559AbhLGAaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 19:30:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5A09B81622
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 00:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AA6C004DD;
        Tue,  7 Dec 2021 00:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638836801;
        bh=3WQpXmEsz51Q1ImD6P3sfkdG47M1foM+xX1dCJAQF+g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PbD3b5xnJNsw5xY/E63usL1Krs5jSG0tMwNpnq2DfrwhxOQWxD7cm9H9JidL7puyJ
         VgbF0Btc8by3qYZ6UibxiYNw4oGtdo62FeHBLFppCfj7zSqgb81q+WO4Id4mv4xB46
         Jwp735jQ996TE2ryhTPN5nBcRLPi0MsiAridyvSerkMZbfsQetdP1KVCRIj/+6pRxC
         IlN64J8R3xgiee0CIrCtuullGZYaOy7/MKFUWMrC+yrxeWjOIlhze63+UGkz/IBipg
         MaiUp6ekwH/N3xUgYRoR/hYmPQb2vs6eLaFK+yFwEUz4f7wFpp6jveGH7KKF+bVtfB
         4FUr8vEQxWVLw==
Date:   Mon, 6 Dec 2021 16:26:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: [PATCH v3 net-next 00/23] net: add preliminary netdev refcount
 tracking
Message-ID: <20211206162640.6a6bfbac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211205042217.982127-1-eric.dumazet@gmail.com>
References: <20211205042217.982127-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Dec 2021 20:21:54 -0800 Eric Dumazet wrote:
> Two first patches add a generic infrastructure, that will be used
> to get tracking of refcount increments/decrements.
> 
> The general idea is to be able to precisely pair each decrement with
> a corresponding prior increment. Both share a cookie, basically
> a pointer to private data storing stack traces.
> 
> The third patch adds dev_hold_track() and dev_put_track() helpers
> (CONFIG_NET_DEV_REFCNT_TRACKER)
> 
> Then a series of 20 patches converts some dev_hold()/dev_put()
> pairs to new hepers : dev_hold_track() and dev_put_track().
> 
> Hopefully this will be used by developpers and syzbot to
> root cause bugs that cause netdevice dismantles freezes.
> 
> With CONFIG_PCPU_DEV_REFCNT=n option, we were able to detect
> some class of bugs, but too late (when too many dev_put()
> were happening).

Applied with minor fixes to patches 3 and 20. Thanks!
