Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1DC41C56D
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 15:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344132AbhI2NUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 09:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:39158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344084AbhI2NUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 09:20:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A14B561216;
        Wed, 29 Sep 2021 13:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632921550;
        bh=YOTPuKRpRa0VhTwzDaPsBG0cS0KxZbsB5y2cprmKvy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z5zQKbf81EQiOsqUeMq/BJ2zVP3WMEtwSXVfT4/5kEamsR1XRVv7lZEgNc7YeQKM7
         gej1FXXZC1zISwPcH7Y5XZndZRQkys6DTf71XHzDGV0ytn/SnnnpC5FQzjfxH37DJA
         nL6mUfH8oHfqZPmXe450qUEP80e48q2hBsWO+SUOEayOSkDzScozrNwUGX1/n48D46
         7+IlDWHJQjulYITK4C7QbnZmYJ9Kq5T8HyZ1u9xHHCWYydY+dItQUGXouE3mtWuTqT
         PLFPNwNbvzHwg+GO3xOLUwY+dcBUt/GYgULTiEVyTwRxkmRiGgOctnXNZzgQLLHBmF
         n1rKJJPW0SxjA==
Date:   Wed, 29 Sep 2021 06:19:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Toms Atteka <cpp.code.lv@gmail.com>, netdev@vger.kernel.org,
        pshelar@ovn.org, davem@davemloft.net, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6] net: openvswitch: IPv6: Add IPv6 extension
 header support
Message-ID: <20210929061909.59c94eff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d1e5b178-47f5-9791-73e9-0c1f805b0fca@6wind.com>
References: <20210928194727.1635106-1-cpp.code.lv@gmail.com>
        <20210928174853.06fe8e66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d1e5b178-47f5-9791-73e9-0c1f805b0fca@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Sep 2021 08:19:05 +0200 Nicolas Dichtel wrote:
> > /* Insert a kernel only KEY_ATTR */
> > #define OVS_KEY_ATTR_TUNNEL_INFO	__OVS_KEY_ATTR_MAX
> > #undef OVS_KEY_ATTR_MAX
> > #define OVS_KEY_ATTR_MAX		__OVS_KEY_ATTR_MAX  
> Following the other thread [1], this will break if a new app runs over an old
> kernel.

Good point.

> Why not simply expose this attribute to userspace and throw an error if a
> userspace app uses it?

Does it matter if it's exposed or not? Either way the parsing policy
for attrs coming from user space should have a reject for the value.
(I say that not having looked at the code, so maybe I shouldn't...)
