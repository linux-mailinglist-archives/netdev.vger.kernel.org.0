Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A71A5A8BE4
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiIADUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 23:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiIADUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 23:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B333532EF7;
        Wed, 31 Aug 2022 20:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BF9661DEE;
        Thu,  1 Sep 2022 03:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB72C433C1;
        Thu,  1 Sep 2022 03:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662002418;
        bh=WxVhZYZDGjwG/Bood+luhm4SIxf9hQ3eu2NdLeQ6ikc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TtpuyB+bUa12LIRhXChFZqU/AxOT8TDqWz/Gam3ZxA4R/10uOie28ccBlI3c+dvZJ
         LpjHryUYs1ScsIwkw+LzhXtBdsHzEHwDnEgCKXtejnji5ok8SpN6o9lmJtTl4WO9fU
         JYF00y+QoT2INQpnw0SpmRb9mobuoFXJWA2AYeuhPkfaNMbXoT14U62wrNpydMMZx8
         S2aAnrGD3AGebXt/IeOG9VEb9pd5MLa6SGqg4cTbFE8+jLWlxudJ1K0NyBWg77eoaB
         3JfFhQY+381d0AnSlCfK33/tVZki5wemsdjLQBJ4dXfZfOK18/Ttomc5eOfKiAfH5r
         Ew/Dkg+W8nyrA==
Date:   Wed, 31 Aug 2022 20:20:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/2] netlink: Bounds-check struct nlmsgerr creation
Message-ID: <20220831202017.69838448@kernel.org>
In-Reply-To: <20220901030610.1121299-3-keescook@chromium.org>
References: <20220901030610.1121299-1-keescook@chromium.org>
        <20220901030610.1121299-3-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Aug 2022 20:06:10 -0700 Kees Cook wrote:
> For 32-bit systems, it might be possible to wrap lnmsgerr content
> lengths beyond SIZE_MAX. Explicitly test for all overflows, and mark the
> memcpy() as being unable to internally diagnose overflows.
> 
> This also excludes netlink from the coming runtime bounds check on
> memcpy(), since it's an unusual case of open-coded sizing and
> allocation.

This one you gotta rebase we just rewrote the af_netlink 
part last week :)
