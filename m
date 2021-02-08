Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1403313E9C
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 20:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235465AbhBHTNs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 14:13:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:36528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236032AbhBHTMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 14:12:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3F7264E85;
        Mon,  8 Feb 2021 19:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612811523;
        bh=K+7kvZpJ8F9GJoUZ5QdeCCZZTGeLPmT8NNE54CbRAwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gWIUx1nzlv6RKCQNeX+Te8vBaEu72OH3SLkbq9r4KUCXXDYv0Uf1O3rxggik/F76w
         urp+VOtz/iicLSUT7Z/PI9+rltHa4skiIMDG6gLYoA1sebvk6o7jZrj7rzFeJIXQ4O
         59xcGfbk5NeWBHVs2a/mxAb8G7d2HbYUJXUr22nMvaESmprmvVD118SEz2LNXvAcey
         9NoCU5oJ+quXyVCNRC/zcZyP18VJtbE/DSBdLsfYz7Oxp/AzItmLiZN7dbgJ8fJjG2
         KDZQwH9xx1l5cbH6etL4G1tgAwR58cQG+sPqTD7yd7nFnEtnChG0Vj2UtSxyETZy+Z
         5yaxNxcNenq/Q==
Date:   Mon, 8 Feb 2021 11:12:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Jorgen Hansen <jhansen@vmware.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Andy King <acking@vmware.com>, Wei Liu <wei.liu@kernel.org>,
        Dmitry Torokhov <dtor@vmware.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        George Zhang <georgezhang@vmware.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: Re: [PATCH net] vsock: fix locking in vsock_shutdown()
Message-ID: <20210208111200.467241da@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210208150431.jtgeyyf5qackl62b@steredhat>
References: <20210208144307.83628-1-sgarzare@redhat.com>
        <20210208150431.jtgeyyf5qackl62b@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Feb 2021 16:04:31 +0100 Stefano Garzarella wrote:
> What do you suggest?
> 
> I did it this way because by modifying only the caller, we would have a 
> nested lock.
> 
> This way instead we are sure that if we backport this patch, we don't 
> forget to touch hvs_shutdown() as well.

I'm not a socket expert but the approach seems reasonable to me.
