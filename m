Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAC79363204
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 21:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbhDQTo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 15:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237017AbhDQTot (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Apr 2021 15:44:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C839D61210;
        Sat, 17 Apr 2021 19:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618688663;
        bh=h/E3rQOGlJVBPrTwEb5Gif3pWtfnUnViktmEz87l4yw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=evZDx9GYNn5mmrUzW4oV40oQ0j2nhGq0a6EtTgMfCYAttqv6wHTXGAuCIdQIGHS28
         Wi5OsFY9u3IWAMfoBZcq3qkNF/x0CMw/MxRBSNxutP6ZMK4WeievHXquO64KWL73vq
         UWZk5M3SHY6Bj1caQmdDoFyNxtAjbRf6dDuTvN/Z2kRxdftxpce2Zz0aRDpv//mnHm
         WyNp4AeyRb5fRPqiqwUY6XllQltNwNLIrtdy0xfHMlSFyA5m3jkRPGHDO5XsnH6rvj
         1tJQlT00xm8TwHv1F89oUX9ZwgrakH4kBEBvxN0i9srH6RIKUpSqPq9qdhyMutoNeH
         9ikeKEHwFn19Q==
Date:   Sat, 17 Apr 2021 12:44:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, idosch@nvidia.com, mkubecek@suse.cz
Subject: Re: [RFC ethtool 6/6] netlink: add support for standard stats
Message-ID: <20210417124422.587df060@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YHs1kSQWxJf03uqV@shredder.lan>
References: <20210416160252.2830567-1-kuba@kernel.org>
        <20210416160252.2830567-7-kuba@kernel.org>
        <YHslkLKkb825OUEI@shredder.lan>
        <20210417114728.660490a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YHs1kSQWxJf03uqV@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Apr 2021 22:22:57 +0300 Ido Schimmel wrote:
> > > So you will have something like:
> > > 
> > > ETHTOOL_A_STATS_GRP_HIST_BKT_UNITS_BYTES  
> > 
> > Histogram has two dimensions, what's the second dimension for bytes?
> > Time? Packet arrival?  
> 
> Not sure what you mean. Here you are counting how many Rx/Tx packets are
> between N to M bytes in length. I meant to add two attributes. One that
> tells user space that you are counting Rx/Tx packets and the second that
> N to M are in bytes.

Ah, these were not part of the same enum, I get it now.

I thought maybe bytes were trying to cater to the queue length use case
and I wasn't sure how that histogram is constructed.

> But given your comment below about this histogram probably being a one
> time thing, I think maybe staying with the current attributes is OK.
> There is no need to over-engineer it if we don't see ourselves adding
> new histograms.
> 
> Anyway, these histograms are under ETHTOOL_A_STATS_GRP that should give
> user space all the context about what is being counted.

