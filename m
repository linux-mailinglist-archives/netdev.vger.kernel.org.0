Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A583AD2AD
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhFRTWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:22:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232433AbhFRTWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F25F260041;
        Fri, 18 Jun 2021 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624044005;
        bh=G/EcdgQ0DuLYd012QCvOQ/+ir3Ksi0uVhS5PI/eSs2c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IRX9kqWnqQ03tXChz6xsOSTwwQtMvNfyyVtvA3t1Bqwiv8gMYFfshRRJQn6Ah9tT4
         7/0Wb6okHz0szVDcoZPT9Gq6AOS2hq1gDf2cKU8EniI/GY1tuUzKWJYxMMsdYZrjUl
         mP3YY5vAvhNR1sWxYy2nYKs/6qWca7r5feyP0KJkzIefDEcLowaZXdfR7B1KSDlyYS
         VciKkX+maVu8BjPNRlmiauu/KmnTFQYy0ipa5YY6SpLbPG8gf8iWM8K3vj7z5Ccn6f
         kPERmWWMkkfUTQ3Y8o1J8BYJAXVfDQ7/usJJAds2WuJHgw+mCY5/rf48Oa9EFJfH4b
         Ljd/yVxxyWFqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E128060C29;
        Fri, 18 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/2] icmp: don't send out ICMP messages with a source
 address of 0.0.0.0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404400491.12339.684843147892616211.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:20:04 +0000
References: <20210618110436.91700-1-toke@redhat.com>
In-Reply-To: <20210618110436.91700-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org, jch@irif.fr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 13:04:35 +0200 you wrote:
> When constructing ICMP response messages, the kernel will try to pick a
> suitable source address for the outgoing packet. However, if no IPv4
> addresses are configured on the system at all, this will fail and we end up
> producing an ICMP message with a source address of 0.0.0.0. This can happen
> on a box routing IPv4 traffic via v6 nexthops, for instance.
> 
> Since 0.0.0.0 is not generally routable on the internet, there's a good
> chance that such ICMP messages will never make it back to the sender of the
> original packet that the ICMP message was sent in response to. This, in
> turn, can create connectivity and PMTUd problems for senders. Fortunately,
> RFC7600 reserves a dummy address to be used as a source for ICMP
> messages (192.0.0.8/32), so let's teach the kernel to substitute that
> address as a last resort if the regular source address selection procedure
> fails.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] icmp: don't send out ICMP messages with a source address of 0.0.0.0
    https://git.kernel.org/netdev/net/c/321827477360
  - [net,v2,2/2] selftests/net: Add icmp.sh for testing ICMP dummy address responses
    https://git.kernel.org/netdev/net/c/7e9838b7915e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


