Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5D43119B5
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhBFDQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:16:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231259AbhBFDHl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 22:07:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FDAE64FCA;
        Sat,  6 Feb 2021 03:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612580821;
        bh=MrZUJ3hXkjjkOQYdKiXoplQY61TLzgCoi64RbR4/ua4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IQMVWgcRGr/fyFGMVwC8WEOfvNS7QdmAsJqpBWurzN0ZczBrCPSv7W7Qqz6+FQ387
         qZ+KhsG4jUuAl+yqAX1MNHE4JGEv/ScYZrwcT9Y2shlri9WwXP6wYgnpydMcEqbvnb
         LfzkA9jMhaRPvwWUapzR6mz4y1pCK86oL2PVWT2LtNzf7ArEWrGbw3cLglG2NyFmcj
         /GupdEZO9XX7F3icq8/i3WfckFi0V/zWQoim+dpyGKI+mwJjEOfWePkhZ4/vgS1eMR
         eW/yMLJFkFex2G7++iSdB2WYUQujPyGIzNgbenjhW7N+zIGsiLRjFpXj1dFXVIKW6/
         Kz6x6+16TU9Fw==
Date:   Fri, 5 Feb 2021 19:07:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Tj (Elloe Linux)" <ml.linux@elloe.vision>
Cc:     netdev <netdev@vger.kernel.org>,
        Callum O'Connor <callum.oconnor@elloe.vision>
Subject: Re: kernel BUG at net/core/skbuff.c:109!
Message-ID: <20210205190700.50f829e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <d7f38867-71d3-e91c-c71c-1dd37a4c3086@elloe.vision>
References: <d7f38867-71d3-e91c-c71c-1dd37a4c3086@elloe.vision>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 11:55:25 +0000 Tj (Elloe Linux) wrote:
> On a recent build (5.10.0) we've seen several hard-to-pinpoint complete
> lock-ups requiring power-off restarts.
> 
> Today we found a small clue in the kernel log but unfortunately the
> complete backtrace wasn't captured (presumably system froze before log
> could be flushed) but I thought I should share it for investigation.
> 
> kernel BUG at net/core/skbuff.c:109!
> 
> kernel: skbuff: skb_under_panic: text:ffffffffc103c622 len:1228 put:48

text:ffffffffc103c622

That's a return address, IOW address of the caller, if I'm reading the
code right. Any chance you could decode that?
./scripts/decode_stack_trace is your friend.

> head:ffffa00202858000 data:ffffa00202857ff2 tail:0x4be end:0x6c0 dev:wlp4s0

dev:wlp4s0

Can you tell us what driver drives this device?

> kernel: ------------[ cut here ]------------
> kernel: kernel BUG at net/core/skbuff.c:109!
