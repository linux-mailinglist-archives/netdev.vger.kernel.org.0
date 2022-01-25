Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5143749BF92
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 00:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234828AbiAYXcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 18:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234817AbiAYXcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 18:32:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E713C06161C;
        Tue, 25 Jan 2022 15:32:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04ED5612F0;
        Tue, 25 Jan 2022 23:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A054C340E0;
        Tue, 25 Jan 2022 23:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643153536;
        bh=nox2JDb71V6+3/Gd1PXffpHZVO8KUrMDHzJBsxv8zZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ulnqkyNjHRFt55m6gwbrzidf8G7941AKR1UTrW1uB5eIegDxlJEEq1gbt/aOo8TxF
         dx8snYBt8qI5Fpfdz28I3kGf1KQ60e5El2cuHf0dvN8T1g2VouEt/cvbA7U9fbgHY8
         5i6aM3voVhftNCjD85Hc9YtRBwiqDfvjxWLNZPt2Tf209X49RX1JcyZp/mOOfQ+0Gy
         e6H4awicu2iqu5mJV4NAa86ZiJu8kHe5h/nx2KsvWd8vH8kWrDw4HcZHGr7nCFfFhi
         5JDXDUStGsJsFDDdW/moB9le3EbFj6INDuqbNCrJWj6VGHAlZ+yCwE7N+NMZ72lVzx
         +RtO2nShCTDkA==
Date:   Tue, 25 Jan 2022 15:32:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     pablo@netfilter.org
Cc:     menglong8.dong@gmail.com, rostedt@goodmis.org, mingo@redhat.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, paulb@nvidia.com,
        pabeni@redhat.com, talalahmad@google.com, haokexin@gmail.com,
        keescook@chromium.org, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com
Subject: Re: [PATCH net-next 1/6] net: netfilter: use kfree_drop_reason()
 for NF_DROP
Message-ID: <20220125153214.180d2c09@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124131538.1453657-2-imagedong@tencent.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
        <20220124131538.1453657-2-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 21:15:33 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() with kfree_skb_reason() in nf_hook_slow() when
> skb is dropped by reason of NF_DROP.

Netfilter folks, does this look good enough to you?

Do you prefer to take the netfilter changes via your tree? I'm asking
because enum skb_drop_reason is probably going to be pretty hot so if
the patch is simple enough maybe no point dealing with merge conflicts.
