Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD856E8B3E
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 09:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbjDTHRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 03:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDTHRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 03:17:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E28935BE
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 00:17:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AC3064556
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 07:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00562C433EF;
        Thu, 20 Apr 2023 07:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681975021;
        bh=GLvKieoBphGZGiZJfMqJBiEaCNVIJZNgZ2twytIVJc0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MlBJraL0KiyJb4F/uTbn49kuAjMFWM7k84j3dHNCcXDlIvQ+1u6tRQrFZf0siJwPs
         kzPEJqKguzi81zhwCUi7pUpCCo8hLIGF7ZCBr9mighhizRW21UjKmWVqEAx7lXLHJa
         XTVA6CHVCX3FHdr94rZRaL8hGb8lSmwsMQbXev5gjtKFMrkkAzMzwNhgMdJBEczzBb
         wldZI1D0ASW2pj6UH0ES9I5AYPTql02rDgh9Wa1hf1YO4/D/awTnxPkYixWXTJhKCH
         03p/0o5f8SOTRvD+2dyfI05BesfRtqwtwVt9tk6DZDgP+JlGSMT7/SfL3mqqcZu8UG
         gnVAQ7JdDS6aA==
Date:   Thu, 20 Apr 2023 10:16:57 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Bizon <mbizon@freebox.fr>, davem@davemloft.net,
        edumazet@google.com, tglx@linutronix.de, wangyang.guo@intel.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dst: fix missing initialization of
 rt_uncached
Message-ID: <20230420071657.GA4423@unreal>
References: <20230418165426.1869051-1-mbizon@freebox.fr>
 <20230419085802.GD44666@unreal>
 <20230419154123.298941e2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419154123.298941e2@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 03:41:23PM -0700, Jakub Kicinski wrote:
> On Wed, 19 Apr 2023 11:58:02 +0300 Leon Romanovsky wrote:
> > It should go to net. Right now -rc7 is broken.
> 
> That's not true, right? The bad commit is in net-next only.

Sorry, I was wrong, it is net-next.

My mistake was to combine two bugs in the same bucket as they came
together in our tests. This rt_uncached thing and XFRM fix which I
sent to ipsec-rc.

Thanks
