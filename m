Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4258A53B2C1
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 06:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiFBEhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 00:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiFBEhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 00:37:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451981146E
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 21:37:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C05FA616D4
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 04:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27DFC385A5;
        Thu,  2 Jun 2022 04:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654144619;
        bh=tWsPl1FNGIew2NPJBwVY1Hp6YVQ35Y5SWJKsnuafpaI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FEq7Fme9C1njoVopDCvH5xkPEa0TFoteR2zeN0vfDUcsV8wt3VuKX2oMQpRpVyCuX
         OUo3eMXMtjFWwPV4t3T9rzA+Py6uoJHt69ebISFGnqWkaL9c3WkExoWZ0Xkk/RBfs+
         dlnP7N7zJy9mBqlDlGEZ1UNLNfF6+e5gzs3PA2kaKL+wnR29xVDULeiM6b4b16R6SP
         X+sv8kE4ovpkuR7IgSpWFnQcGY6R7z5Wg0cpN/5CgqWgXRqDgAztwjOH+1ntNmZ+Y9
         xfocG5isDVh+MvOGFxnvxO6nbksutvPolX4XkPFbhnym2J6YrcW66AjBj1PVKxbOP/
         qUZ4IQxm2+9Nw==
Date:   Wed, 1 Jun 2022 21:36:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
Subject: Re: [net v2] tipc: check attribute length for bearer name
Message-ID: <20220601213657.0f9b6a27@kernel.org>
In-Reply-To: <20220602012313.4255-1-hoang.h.le@dektech.com.au>
References: <20220602012313.4255-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Jun 2022 08:23:13 +0700 Hoang Le wrote:
> syzbot reported uninit-value:
> =====================================================
> BUG: KMSAN: uninit-value in string_nocheck lib/vsprintf.c:644 [inline]
> BUG: KMSAN: uninit-value in string+0x4f9/0x6f0 lib/vsprintf.c:725

> Reported-by: syzbot+e820fdc8ce362f2dea51@syzkaller.appspotmail.com
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Fixes: a10bd924a421 ("[TIPC]: Enhanced & cleaned up system messages; fixed 2 obscure memory leaks.")

Correct?
