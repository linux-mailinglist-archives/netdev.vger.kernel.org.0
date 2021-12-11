Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876794711AD
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 06:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhLKFWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 00:22:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhLKFWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 00:22:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EEDC061714
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 21:18:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7B2DBCE2F26
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 05:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669DCC004DD;
        Sat, 11 Dec 2021 05:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639199932;
        bh=+pw/fkofJHIXQtzjo7nBmMq/bCOrRokCQ67DRSORStE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J2+zkhBRTYy40HaKTUBD5BIzeM6gXBQhsz9kHcTXFULZattUWsmIGwx30Xo3jxLtX
         bi/1bXPwMwHLxkHwm6xfPVJap4QLbw1NjM084w9ecbAHW/wEj963GQV/TnFZn3bobY
         7skJJeyeqblwhRkFKMkv1tW2j8Pk2lz/bUb32s+1JlewE1Hf/b/EuDOtHv9SzgMGMY
         OaijFeI3akmKh1PCIS65QagAloMxhNLBhpclpzslb96/6L+eJcmhu+omxOJ2UEz3jz
         rkdtHa++yCiCQ6kBZq0BzVnHRkdgmVpP+rwH9m0QnXznVyzu3QUme+a9FHh8Oc1qtN
         1OSt0kjgwovsQ==
Date:   Fri, 10 Dec 2021 21:18:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Add tx fwd offload PVT on
 intermediate devices
Message-ID: <20211210211851.6b8773e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211209222424.124791-1-tobias@waldekranz.com>
References: <20211209222424.124791-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Dec 2021 23:24:24 +0100 Tobias Waldekranz wrote:
> In a typical mv88e6xxx switch tree like this:
> 
>   CPU
>    |    .----.
> .--0--. | .--0--.
> | sw0 | | | sw1 |
> '-1-2-' | '-1-2-'
>     '---'
> 
> If sw1p{1,2} are added to a bridge that sw0p1 is not a part of, sw0
> still needs to add a crosschip PVT entry for the virtual DSA device
> assigned to represent the bridge.
> 
> Fixes: ce5df6894a57 ("net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT")

Hm, should this go to net? The commit above is in 5.15 it seems.
