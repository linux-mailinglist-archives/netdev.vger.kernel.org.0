Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378A131564E
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 19:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbhBISr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 13:47:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:43958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233281AbhBISaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 13:30:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 069E864EC7;
        Tue,  9 Feb 2021 18:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612895354;
        bh=z3gp7IqSnOgt4sqW5F0NQl/rXX801bsfGe8VJ4YHbBE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xf+K1GT9kmSq80yI2J1YUQNEQUEMiTXHX6ic3h7tLbVees6AE8gPOli0z0RLFgi4B
         a8nwdo/mNQJHKUbd700YVlGm/7gyBZ9xVb0YEzS7a0na2gqThuB+QMjYYaiO/Z7N36
         GKuJFJ7bsaoUmxv3Fy5GNff6ijjyl7J78Xn3yKwh3RdFxqrA8N9k5Hsccs3mshwVjl
         5J+oD9iCHKE0Ho3rU85dKwNph2E8QPTV32tGWMrbZpAjNHPkd3IzhiWJeIm5padElq
         FvNFWfZCfbBO9Ah7nGca+WU2oGttsUnZKM3UX3jatQwvOPQ5h7QIv2tBWm2wasm97h
         xFC+9XOcTcvHw==
Date:   Tue, 9 Feb 2021 10:29:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Jian Yang <jianyang.kernel@gmail.com>,
        <davem@davemloft.net>, Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next] Revert "net-loopback: set lo dev initial state
 to UP"
Message-ID: <20210209102912.2ad7b2ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <565e72d78de80b2db767d172691bb4b682c6f4fd.1612893026.git.petrm@nvidia.com>
References: <565e72d78de80b2db767d172691bb4b682c6f4fd.1612893026.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Feb 2021 18:52:04 +0100 Petr Machata wrote:
> In commit c9dca822c729 ("net-loopback: set lo dev initial state to UP"),
> linux started automatically bringing up the loopback device of a newly
> created namespace. However, an existing user script might reasonably have
> the following stanza when creating a new namespace -- and in fact at least
> tools/testing/selftests/net/fib_nexthops.sh in Linux's very own testsuite
> does:
> 
>  # set -e
>  # ip netns add foo
>  # ip -netns foo addr add 127.0.0.1/8 dev lo
>  # ip -netns foo link set lo up
>  # set +e
> 
> This will now fail, because the kernel reasonably rejects "ip addr add" of
> a duplicate address. The described change of behavior therefore constitutes
> a breakage. Revert it.
> 
> Fixes: c9dca822c729 ("net-loopback: set lo dev initial state to UP")
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
