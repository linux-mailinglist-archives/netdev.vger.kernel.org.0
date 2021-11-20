Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD878457B04
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 05:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbhKTEGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 23:06:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:40388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234687AbhKTEGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 23:06:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1518F6056B;
        Sat, 20 Nov 2021 04:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637381012;
        bh=51WzQPXgZ+W6ytS6wuHkN3sJVsppST5XCPMDtE7TDPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VWE4bqLwk8R9MJtzzyaeStDHDiiVTqsuXAG7uyfdtTt62npCqV3fq5rbL+1COTTgb
         qf7J556hEPdSWyi3li8ZQ7ll47BhLzU9vL/cBQoDkTKCRzy3Yh2AyD4qWauqdLZioG
         Z8Ya/a+oOnqAKuIBoyEuud1uaAJ7PWBg4OYbafm76v11l4+k9ejWF+C5/RPx0O6/zW
         OGpjSsQW4B67AFUEVeFr54R6JHnWmunARvWDtcl2zuI9VpsMmf976HvvwrIdMUjHDg
         gsO1OYk2nPG2A52TEaQrTfv3S5Z3oMsBRnFx5PFgBEntVSjjNVtgCllTUkY5pEWzG5
         j9puKq4OxSmtQ==
Date:   Fri, 19 Nov 2021 20:03:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Lama Kayal <lkayal@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 10/10] net/mlx5e: Do synchronize_net only once when
 deactivating channels
Message-ID: <20211119200330.20f0b6d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211119195813.739586-11-saeed@kernel.org>
References: <20211119195813.739586-1-saeed@kernel.org>
        <20211119195813.739586-11-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Nov 2021 11:58:13 -0800 Saeed Mahameed wrote:
> Synchronize_net takes time, and given that it's called multiple times
> per channel on deactivation, it accumulates to a significant amount,
> which causes timeouts in some applications (for example, when using
> bonding with NetworkManager).
> 
> This commit fixes the timing issue by restructuring the code, so that
> synchronize_net is only called once per deactivation of all channels.
> It's entirely valid, because we only need one synchronization point with
> NAPI between deactivation and closing the channels.

Since you're pushing this as a fix can we please see the benchmarks
/ numbers to justify this? The patch in Fixes was in tree for 1.5yrs.
