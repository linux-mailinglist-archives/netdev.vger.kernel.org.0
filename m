Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A62E28F471
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 16:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387861AbgJOOKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 10:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727988AbgJOOKE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 10:10:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602771003;
        bh=oPQVhL0mhmuyNOOvUefcZy/mbKTce+7oCdjoFqNr6ek=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sgs2XmQMmckTPigWnlBESF75XLbc5y0h5dlSnuam1m8YvRA5UQHUcKQn06cp26QUg
         79W+U9yySjzlm3+yBe7LhUx3zxGeB4bdNdx5nkVl/19mtBwxXywsvLA4+5HkGGBAXh
         HBa2tJsUhFkYvdzAXyhqSKRppeCS/YiSiyTG8rWU=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Fix register equivalence tracking.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160277100353.23379.5919005498443504637.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Oct 2020 14:10:03 +0000
References: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 14 Oct 2020 10:56:08 -0700 you wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> The 64-bit JEQ/JNE handling in reg_set_min_max() was clearing reg->id in either
> true or false branch. In the case 'if (reg->id)' check was done on the other
> branch the counter part register would have reg->id == 0 when called into
> find_equal_scalars(). In such case the helper would incorrectly identify other
> registers with id == 0 as equivalent and propagate the state incorrectly.
> Fix it by preserving ID across reg_set_min_max().
> In other words any kind of comparison operator on the scalar register
> should preserve its ID to recognize:
> r1 = r2
> if (r1 == 20) {
>   #1 here both r1 and r2 == 20
> } else if (r2 < 20) {
>   #2 here both r1 and r2 < 20
> }
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: Fix register equivalence tracking.
    https://git.kernel.org/bpf/bpf-next/c/e688c3db7ca6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


