Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603292D4F31
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgLIX43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbgLIX4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 18:56:22 -0500
Date:   Wed, 9 Dec 2020 15:55:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607558141;
        bh=vnIhKzLqWSMeOScadAyG8pPEthL6+gnuy4rxw4k4uy8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=C52odV0iBs62mJknBjzp1YXeMob3a18SNsX4PST0OfJWw6shS+WMIKTCzG5/eKqGS
         GhPQFlg1CgARc5oOmuzMBPwaSnnaToZRSkKNE1bvdoMsGK0toWXSofOmga/Q7VISmK
         Q5WTVB41arR4Oq9Adiajoqlg79QFdGaQvg4hsuaLjMGhOjApmnVtjxxobLMcC8KlAb
         YuTTBFRTY6Yn2vMeSWGnX1T0JIK3kMm+IvWruDj+yDtKOYhmzhKJbfmhdB3vS5TmPd
         ZjdB5mCUoI3qo6JQJ9es6CoKnTAnn6K1qPP1tHtcfDydGwjNEyVHJc/zx8o0+gad4z
         csrNdBAyOin2w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: fix stack overflow in ethnl_parse_bitset()
Message-ID: <20201209155540.7217ee8a@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <3487ee3a98e14cd526f55b6caaa959d2dcbcad9f.1607465316.git.mkubecek@suse.cz>
References: <3487ee3a98e14cd526f55b6caaa959d2dcbcad9f.1607465316.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Dec 2020 23:13:51 +0100 (CET) Michal Kubecek wrote:
> Syzbot reported a stack overflow in bitmap_from_arr32() called from
> ethnl_parse_bitset() when bitset from netlink message is longer than
> target bitmap length. While ethnl_compact_sanity_checks() makes sure that
> trailing part is all zeros (i.e. the request does not try to touch bits
> kernel does not recognize), we also need to cap change_bits to nbits so
> that we don't try to write past the prepared bitmaps.
> 
> Fixes: 88db6d1e4f62 ("ethtool: add ethnl_parse_bitset() helper")
> Reported-by: syzbot+9d39fa49d4df294aab93@syzkaller.appspotmail.com
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>

Applied, thank you!
