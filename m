Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778106ED6D1
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 23:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbjDXVgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 17:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjDXVgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 17:36:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45FF59D1
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 14:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CB8462950
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 21:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D2CC433EF;
        Mon, 24 Apr 2023 21:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682372212;
        bh=6/SHzd1PqUbcCCsNzWqRtwyRlbaF+Npzd3NZJNHnvQ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VXlXMvIFa0UdmiGr6ZnmiRjuvfOqtIMZ3hbe1g9fp+ZpojKU9oUHps9WlPnl/C/vX
         bUt6L8TiA1bSqdSJWdQ4QuxdWTSkTqe3BhlEvSXqJvBngSvPi4mIa4LUvGdxfYjGPF
         kb54JLbiFChQi/7Ptf1NsOg8b6dQXgzdkltXHUFVDkrB4fuoZckp1EW4yKHt3aJwEA
         6f+aKog5KD+RVQ7myo1JGgdr0e6qMSGV4ybOkMqQgddp2e1x1E8ZbgOpaA/O510XQ9
         Terk1L//j6ohkbOCvueD+w6KCiVCLMc6tVTRDQP0J3z/6SVhOVP6uXOR5mFz3ef7Bb
         vjCz3t0aRLiQQ==
Date:   Mon, 24 Apr 2023 14:36:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Leon Romanovsky <leon@kernel.org>,
        Victor Nogueira <victor@mojatatu.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kernel@mojatatu.com
Subject: Re: [PATCH net v2] net/sched: act_mirred: Add carrier check
Message-ID: <20230424143651.53137be4@kernel.org>
In-Reply-To: <CAM0EoMnM-s4M4HFpK1MVr+ey6PkU=uzwYsUipc1zBA5RPhzt-A@mail.gmail.com>
References: <20230424170832.549298-1-victor@mojatatu.com>
        <20230424173602.GA27649@unreal>
        <20230424104408.63ba1159@hermes.local>
        <CAM0EoMnM-s4M4HFpK1MVr+ey6PkU=uzwYsUipc1zBA5RPhzt-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Apr 2023 13:59:15 -0400 Jamal Hadi Salim wrote:
> > Then fix the driver. It shouldn't hang.
> > Other drivers just drop packets if link is down.  
> 
> We didnt do extensive testing of drivers but consider this a safeguard
> against buggy driver (its a huge process upgrading drivers in some
> environments). It may even make sense to move this to dev_queue_xmit()
> i.e the arguement is: why is the core sending a packet to hardware
> that has link down to begin with? BTW, I believe the bridge behaves
> this way ...

I'm with Stephen, even if the check makes sense in general we should
first drill down into the real bug, and squash it.
-- 
pw-bot: cr
