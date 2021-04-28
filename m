Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3D236DF65
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 21:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243688AbhD1TOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 15:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232310AbhD1TOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 15:14:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A6E6613F1;
        Wed, 28 Apr 2021 19:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619637231;
        bh=tT66t63JdIpz5yQPVhQuv9m4JujetKOEC9l42sV1tMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gKJmJvCd/7xSOjayOgxjgKRuPikxnm25lQlzziciFQZALjJ2l7UIp6LQVe611ruzv
         SlFxm4DRSB0yL27OJCHGHItTEkE9Q28VCTxXZZuzV3WXLNQ74JG+7Rkag2QdAO0kDS
         nmV1nRxKbv/ExLd/6HTNg3LOTJ2mQjTugQtJMSqU5rpwjotlLbdKnmkwqHLDnN9nfb
         kw32jnw3m+MW7H7Wwh53EPlJt3uQiPccIxhwM2pnPNN0hSwzAeOBkxlKHOTbMsDevD
         7d42YayW0q3SEUfa31+IDN7o6ml1R3du+MWDAsU+5ZfJca7P3vp9qEcmDnBfMRog4X
         43vncnfASWyGA==
Date:   Wed, 28 Apr 2021 12:13:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     simon.horman@netronome.com, davem@davemloft.net,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfp: flower: Remove redundant assignment to mask
Message-ID: <20210428121350.20d10dcf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1619604330-122462-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1619604330-122462-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Apr 2021 18:05:30 +0800 Jiapeng Chong wrote:
> The value stored to mask in the calculations this patch removes is
> not used, so the calculation and the assignment can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> drivers/net/ethernet/netronome/nfp/flower/offload.c:1230:3: warning:
> Value stored to 'mask' is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Seems cleaner to always move ext and mask, in case some code 
is added later in the function and starts accessing mask.
