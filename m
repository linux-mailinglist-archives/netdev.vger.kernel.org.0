Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA276568F44
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 18:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233277AbiGFQfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 12:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbiGFQfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 12:35:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5421915FF8
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 09:35:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E47B761D69
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 16:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19AB1C3411C;
        Wed,  6 Jul 2022 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657125301;
        bh=bijfADDn+ZItJgHnzPT74zBtXO7uW1PauEsCSA5HaI0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ECxKlIelFjGscOEY0S0WSeaataNtqzw1BozTmg1HV2959uUMvdx6iZpm1DMsC06qp
         pBg2ZJEgM8avc7zylala6IKf+Er8QlaBlVbckzXzYUIs3IdECzhYXEuJChJDlqH2yX
         4ZbImUdK9RQX0n1XK9tcdOfpFOhre2DnPE6hBEX5PRemxSYyov76u1Zh9Qu1GP188e
         CNbkjQlHIqycpPLKMrNnFKXXpfv/uKnTtE7KdTfhMuG7PlXUbXZ4FAxx21D36w7teN
         fhx7RF1kCuRnyXCFD0Kq72i5Na5L8fO9hjkR6uFLdxzUw5kx/cVboDwsu+++IU4QUz
         kqCobXAKEWsPA==
Date:   Wed, 6 Jul 2022 09:34:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Liang He" <windhl@126.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ftgmac100: Hold reference returned by
 of_get_child_by_name()
Message-ID: <20220706093459.2885de93@kernel.org>
In-Reply-To: <41ae7b8e.5fda.181d2b8d4ff.Coremail.windhl@126.com>
References: <20220704151819.279513-1-windhl@126.com>
        <20220705184805.2619caca@kernel.org>
        <41ae7b8e.5fda.181d2b8d4ff.Coremail.windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jul 2022 16:55:37 +0800 (CST) Liang He wrote:
> >Since we don't care about the value of the node we should add a helper
> >which checks for presence of the node and releases the reference,
> >rather than have to do that in this large function.
> >
> >Please also add a Fixes tag.  
> 
> Hi, Jakub,
> 
> Can you tell me where to add such helper?
> 
> you mean add a helper in of.h for common usasge or just add it in this file?

I was wondering about that. Since this is a fix let's keep it simple
and add the helper directly in the same source file.

If you have more time to spend on this try searching around the tree to
see if there are more places where such helper would help. If there are
we can move the helper to of.h and convert the users in -next.
