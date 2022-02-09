Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735444AE6CB
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 03:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243121AbiBICkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 21:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241759AbiBIBDR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 20:03:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3132DC061576
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 17:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09566185A
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB65C004E1;
        Wed,  9 Feb 2022 01:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644368596;
        bh=8AmRWCKwQETrFpMvUmB/Vzx9Q3iqDD/ZetqTKkPvh2g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qLa8WMQQSFbSKDuZJdXyE23ECVMhgnt6YTYigsYL/fFTbG4s/82HXqRiFfHstrjrC
         Y1btV+VhnndDWswUJoxU631gU3JNqpRl9B55h8FaCrdZ/y5mxePFhVV0Fcwv0WeV34
         H63v5dGwCwJgd9uwgoOyAOhIQDjz9A+hbKoW/X+wu5Bc1wJ4RPWNY5baPKVX1oXwWB
         rcm/lvtg3GdTrC2xtbFPBGBOO/+ZdQ0ZFQkiqkfUmGc1EDFQHR8ps9nKjfXp/FAb51
         h8WnJ7BM0VjqOkhiLv83ZLfng2jDFOdc4IUOd/hGzynfyJy5dkSX4HA19odQb38qPR
         7CJ9ZWW4goFEw==
Date:   Tue, 8 Feb 2022 17:03:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        eric.dumazet@gmail.com, davem@davemloft.net, dsahern@kernel.org,
        efault@gmx.de, tglx@linutronix.de, yoshfuji@linux-ipv6.org,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH net v3] tcp: Don't acquire inet_listen_hashbucket::lock
 with disabled BH.
Message-ID: <20220208170314.7fbd85c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YgKh9fbQ2dcBu3e1@linutronix.de>
References: <YgKh9fbQ2dcBu3e1@linutronix.de>
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

On Tue, 8 Feb 2022 18:01:41 +0100 Sebastian Andrzej Siewior wrote:
>    Reposted with fixes and net-tree as requested. Please keep in mind that
>    this only effects the PREEMPT_RT preemption model and I'm posting this
>    as part of the merging efforts. Therefore I didn't add the Fixes: tag
>    and used net-next as I didn't expect any -stable backports (but then
>    Greg sometimes backports RT-only patches since "it makes the life of
>    some folks easier" as he puts it).

It says [PATCH net] in the the subject :S  net-next makes sense.
