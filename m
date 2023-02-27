Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 655B56A4B3D
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:37:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjB0ThZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjB0ThP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:37:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BCFC27D60
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 11:36:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F35160F08
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 19:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502CDC433D2;
        Mon, 27 Feb 2023 19:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677526602;
        bh=k1n6LmRrnqG4OWHJkpU3zl1uPZonPElFUJW6Pv5eNpc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ohlI3J8IGfW9EmrV4sW2UetWnAPshO301gv7In8vEEp2fvNMWGCVAhePp8/13XL9p
         DoOqjvE6BK++A8HnDy2uVcshvN5Ky9DJlu1NBSLFhJU4zt8j9+B37WQld9V/EVFOQE
         7tVWMszqs0+A7Yoda0L+q9A08/MSvsU0Y4RfGQCfYa00PiaPnL7l08RN/6fpQz9Y9c
         bF7JkrNXJFHcthQsdVyIyq2QCcsDkP3rYTxjClHvWd70qFPLQ22Y1NGC/POJnfbbMK
         nerNli+lbYNHOiWOQlIJBOktXz7yVsdSiWgMKyNuXmv4K14r+qGYDmqQhDwG/jbWli
         Q+TtuCd9FL2Kw==
Date:   Mon, 27 Feb 2023 11:36:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        amir@vadai.me, dcaratti@redhat.com, willemb@google.com,
        ozsh@nvidia.com, paulb@nvidia.com
Subject: Re: [PATCH net 1/3] net/sched: act_pedit: fix action bind logic
Message-ID: <20230227113641.574dd3bf@kernel.org>
In-Reply-To: <Y/o0BDsoepfkakiG@corigine.com>
References: <20230224150058.149505-1-pctammela@mojatatu.com>
        <20230224150058.149505-2-pctammela@mojatatu.com>
        <Y/oIWNU5ryYmPPO1@corigine.com>
        <a15d21c6-8a88-6c9a-ca7e-77a31ecfbe28@mojatatu.com>
        <Y/o0BDsoepfkakiG@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 25 Feb 2023 17:15:00 +0100 Simon Horman wrote:
> > > OTOH, perhaps it's a regression wrt the oldest of
> > > the two patches references below.  
> > 
> > ...because filters and actions are completely separate TC objects.
> > There shouldn't be actions that can be created independently but can't be
> > really used.  
> 
> I agree that shouldn't be the case.
> For me that doesn't make it a bug, but I don't feel strongly about it.

I'm with Simon - this is a long standing problem, and we weren't getting
any user complaints about this. So I also prefer to route this via
net-next, without the Fixes tags.
