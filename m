Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F35BB64673D
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 03:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiLHCuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 21:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLHCuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 21:50:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855048DFE0
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 18:50:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AB19B821FF
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 02:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F50C433C1;
        Thu,  8 Dec 2022 02:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670467803;
        bh=13/FVdYcynbRYEJWUDea9gU9DPHUF+Tt+ehmlzsQpi8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vt8DJi4pCEJg/LxCYSdHu6Fu6i2f4C0QM6AR3idWZFe25BYej620RNEX8OEPHvYiP
         qE+6aEeryYTiqP6/y8TvbnWlOpcWh4KjUpEzapdhv1VVzN5o+pLO2Tfq6gv7A+du6X
         gdNuVBe2GPUF4Zh7OYINcYffcaqyOnlM9++1jwml3q8I97CeG8NGMcacYojO4w0Do4
         OAQctNCbo+oATiH+DOlWVPoV0tBUl9pdAPCXegiOe4R/yilB3P1s3z3Kt31SYhsnzb
         n2vhnww1utpXvysPHyZP3G8yv3vMhX42oRYTVgM/vJyhzlct1QbWCq+6HkOaGqIF5+
         tGiTpFDVbi97w==
Date:   Wed, 7 Dec 2022 18:50:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH net v2 0/4] net: don't call dev_kfree_skb() under
 spin_lock_irqsave()
Message-ID: <20221207185002.5ed72235@kernel.org>
In-Reply-To: <20221207135258.34193-1-yangyingliang@huawei.com>
References: <20221207135258.34193-1-yangyingliang@huawei.com>
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

On Wed, 7 Dec 2022 21:52:54 +0800 Yang Yingliang wrote:
> It is not allowed to call consume_skb() from hardware interrupt context
> or with interrupts being disabled. This patchset replace dev_kfree_skb()
> with dev_consume_skb_irq() under spin_lock_irqsave() in some drivers, or
> move dev_kfree_skb() after spin_unlock_irqrestore().

You must CC all authors / reviewers of commits under Fixes:
Run get_maintainer on the _patch file_ not on the path.
