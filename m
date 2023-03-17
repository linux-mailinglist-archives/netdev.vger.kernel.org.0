Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E3A6BE008
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 05:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCQEMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 00:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjCQEML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 00:12:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA5219F16;
        Thu, 16 Mar 2023 21:12:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 984E3B82405;
        Fri, 17 Mar 2023 04:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AF1C433D2;
        Fri, 17 Mar 2023 04:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679026327;
        bh=v2zEYx2quVdWHyE4m+BHJg7VxqG48NX5bk+PdK53SKc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rTSWDI3mfJKKGhHTdkEc6wbjHhJWQdrojAI6fGLlVIBxOwZuxZ88Bxq+ezuuv4ggK
         Jg5tehC3W8eVEAqeXLgCOXp1J/eO7kRKt0t2vDtAhkqWRH9cu4Pn6LmbqL9vCdRQD2
         Qx0J7xash3y8rRx6b1VF0MeshXqX1QyAZW1r289UtrJyebpkQMToi5Ttkh5DOKWvTN
         y45+dK5DkApDUS3C4V+ZgBnQHmCeoIrTFPWKFnStlKUKVXGgRHKPSgfc00rfK+uW49
         y6GZ/2XtlgkGAPurMnSvWPAknf2A81DbYqqUdwe+bGcpKw5MBA/EoUhCp2+fnwju3j
         bHBIBlrOcKNmQ==
Date:   Thu, 16 Mar 2023 21:12:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kristian Overskeid <koverskeid@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] hsr: ratelimit only when errors are printed
Message-ID: <20230316211206.1c01b585@kernel.org>
In-Reply-To: <20230315-net-20230315-hsr_framereg-ratelimit-v1-1-61d2ef176d11@tessares.net>
References: <20230315-net-20230315-hsr_framereg-ratelimit-v1-1-61d2ef176d11@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Mar 2023 21:25:17 +0100 Matthieu Baerts wrote:
> Recently, when automatically merging -net and net-next in MPTCP devel
> tree, our CI reported [1] a conflict in hsr, the same as the one
> reported by Stephen in netdev [2].
> 
> When looking at the conflict, I noticed it is in fact the v1 [3] that
> has been applied in -net and the v2 [4] in net-next. Maybe the v1 was
> applied by accident.

Ah, thank you! I didn't even notice that the version which went into 
net was v1 :S
