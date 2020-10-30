Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3184B2A0FFA
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727716AbgJ3VGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 17:06:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:47520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727715AbgJ3VGn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 17:06:43 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F8E62076D;
        Fri, 30 Oct 2020 21:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604092003;
        bh=/YSYg3MX1gmq60yBiMNI0M/GyW8FTSnsDYb125M+f1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qL1K8eKIujjdHMP+86gTqwBU4fxVuWCeq5i7LmSVccR/XTZwS6Y25IMZE2UaqggIu
         IX/AcGam0XLEbxNBoiVoDW2Hoi/yHXvf/7d2jwUWBm/hhNtfgEgR3Eo7SI3xHqK8eM
         72SUeIeUrC+E6W+nbR+PnjM7iK7sUBUfcZN0QWzo=
Date:   Fri, 30 Oct 2020 14:06:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, clang-built-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-safety@lists.elisa.tech
Subject: Re: [PATCH] net: cls_api: remove unneeded local variable in
 tc_dump_chain()
Message-ID: <20201030140641.4fbeb575@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028113533.26160-1-lukas.bulwahn@gmail.com>
References: <20201028113533.26160-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 12:35:33 +0100 Lukas Bulwahn wrote:
> make clang-analyzer on x86_64 defconfig caught my attention with:
> 
> net/sched/cls_api.c:2964:3: warning: Value stored to 'parent' is never read
>   [clang-analyzer-deadcode.DeadStores]
>                 parent = 0;
>                 ^
> 
> net/sched/cls_api.c:2977:4: warning: Value stored to 'parent' is never read
>   [clang-analyzer-deadcode.DeadStores]
>                         parent = q->handle;
>                         ^
> 
> Commit 32a4f5ecd738 ("net: sched: introduce chain object to uapi")
> introduced tc_dump_chain() and this initial implementation already
> contained these unneeded dead stores.
> 
> Simplify the code to make clang-analyzer happy.
> 
> As compilers will detect these unneeded assignments and optimize this
> anyway, the resulting binary is identical before and after this change.
> 
> No functional change. No change in object code.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> applies cleanly on current master and next-20201028
> 
> Jamal, Cong, Jiri, please ack.
> David, Jakub, please pick this minor non-urgent clean-up patch.

Applied, thanks!
