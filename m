Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69C932C4A23
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731797AbgKYVhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:37:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:32912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730249AbgKYVhP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 16:37:15 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E45D2206E0;
        Wed, 25 Nov 2020 21:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606340235;
        bh=qeHy2Hi/45MdNVl+LjVcj1DWGQYixf47oY7uFEc/2rE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kYiFNTE3GcCRh3q/svMqJZc/ZZ1PeNwYTPlJjfOzcmkchRIFtfGq9I/G4KQc0ywIh
         I2yghz1FGXlVfeoy8z1MeJKUiVH/0VG7teMAN4dk9NauXaYFW7g0HTnU4MbwXeO1a/
         KHCAFhWfENbPGaHvJX1B3mEtQikpIhQ8nwtLxUh0=
Date:   Wed, 25 Nov 2020 13:37:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net-next v2] mptcp: be careful on MPTCP-level ack.
Message-ID: <20201125133714.12245f6a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5370c0ae03449239e3d1674ddcfb090cf6f20abe.1606253206.git.pabeni@redhat.com>
References: <5370c0ae03449239e3d1674ddcfb090cf6f20abe.1606253206.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 22:51:24 +0100 Paolo Abeni wrote:
> We can enter the main mptcp_recvmsg() loop even when
> no subflows are connected. As note by Eric, that would
> result in a divide by zero oops on ack generation.
> 
> Address the issue by checking the subflow status before
> sending the ack.
> 
> Additionally protect mptcp_recvmsg() against invocation
> with weird socket states.
> 
> v1 -> v2:
>  - removed unneeded inline keyword - Jakub
> 
> Reported-and-suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thanks!
