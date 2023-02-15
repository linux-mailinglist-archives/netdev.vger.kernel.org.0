Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702EE698892
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 00:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjBOXFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 18:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBOXFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 18:05:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4A5E0
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 15:05:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 766A561B43
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 23:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0FCC433EF;
        Wed, 15 Feb 2023 23:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676502341;
        bh=RtL6hxAnjuRBfbLz+i1e+w3LttK+qtO7rfCnUoaWFYw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zoay7Hmt9tmn4zStZNlWv2coQ+w92vsxNwqrNyeRmfEjlgCyjrKuMVMvE9NzKbdhE
         opJQeFqs0ooeBVAekhWaINq7gTvC10JMp+y18HnZHFF0zDSQKHS9ZbrgI9Sal82Bmg
         7eIFMW8rMp4ymHhxJASUqP5wwmQPNn3pMyyzJc/QFhWVWaef54KhmEQ4bCf8MQJLct
         pGVI+vqG7MJWADL4jsitJHllsiuXX0ghxQyEIhpSjKX7udEdkmUsVL1cJEZ4EAQygr
         mw9LSq6teXo+cQl5zJInihtT3FmtX9KniiX3Rfd/ANEJb3aQO6wbEWUyL2gUxc1ctu
         ntM2Lws0UzUxA==
Date:   Wed, 15 Feb 2023 15:05:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH net-next 0/2] net: default_rps_mask follow-up
Message-ID: <20230215150540.5441eb8c@kernel.org>
In-Reply-To: <df8772b86a072b21500392aa45b72ac86d6983e4.camel@redhat.com>
References: <cover.1676484775.git.pabeni@redhat.com>
        <20230215112954.7990caa5@kernel.org>
        <df8772b86a072b21500392aa45b72ac86d6983e4.camel@redhat.com>
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

On Wed, 15 Feb 2023 21:33:01 +0100 Paolo Abeni wrote:
> That is not needed, as every other devices forwarding packets to the
> netns has proper isolation (RPS or IRQ affinity) already set. If the
> child ns device RPS configuration is left unchanged, the incoming
> packets in the child netns go through an unneeded RPS stage, which
> could be a bad thing if the selected CPU is on a different NUMA node.

I see your point now. Must have been low on coffee in the morning.
Thanks!
