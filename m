Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426C828F8F5
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391119AbgJOSym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgJOSym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 14:54:42 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DDD521527;
        Thu, 15 Oct 2020 18:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602788081;
        bh=UIkTh2LW6GxJ01HN/FOH/tzqZspvRrpV9rvLtD7I3Xs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Y8y2nsKTLb0TxsBSKYjAEtQNxFaok9hIyRyO49xkB/M9Bol9SHfbW5f8DGMpquLMY
         kZhq8Qjxbj6CwdWJBpUbZUtv+wN3j8BFTIN4VFdSOjN2BtjIo+oZM4bJhSQAFaPC8g
         o/hqq85JdJmyF/RRlqxt3QvBdjI34HTwQCSVcWRU=
Date:   Thu, 15 Oct 2020 11:54:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: nftables: allow re-computing sctp
 CRC-32C in 'payload' statements
Message-ID: <20201015115439.7791c3f9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015163927.28730-1-pablo@netfilter.org>
References: <20201015163927.28730-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 18:39:27 +0200 Pablo Neira Ayuso wrote:
> From: Davide Caratti <dcaratti@redhat.com>
> 
> nftables payload statements are used to mangle SCTP headers, but they can
> only replace the Internet Checksum. As a consequence, nftables rules that
> mangle sport/dport/vtag in SCTP headers potentially generate packets that
> are discarded by the receiver, unless the CRC-32C is "offloaded" (e.g the
> rule mangles a skb having 'ip_summed' equal to 'CHECKSUM_PARTIAL'.
> 
> Fix this extending uAPI definitions and L4 checksum update function, in a
> way that userspace programs (e.g. nft) can instruct the kernel to compute
> CRC-32C in SCTP headers. Also ensure that LIBCRC32C is built if NF_TABLES
> is 'y' or 'm' in the kernel build configuration.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Jakub: This is my last pending item in nf-next I think, I'm not planning to
> 	send a pull request for a single patch, so please directly apply this
> 	one to net-next. Thank you.

Applied, thanks!
