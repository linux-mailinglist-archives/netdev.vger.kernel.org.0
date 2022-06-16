Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7FA54E8BB
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233708AbiFPRl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiFPRl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:41:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E95473A6
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51BBDB82523
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 17:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91568C34114;
        Thu, 16 Jun 2022 17:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655401282;
        bh=9dUn6fDXgCwUJBL8/GD501h2sKpgqEwUslRdLmqnxD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aMiDwHSubnr0Z9KpKHxFJwiSKcQQyYWdbFctwYRIwMVpjhPZzqmq93o3ml/lHnaqw
         FRome4h36oG9lyfm8p0H3tisADOL3rF4ZMrEz4W2mU4udKhoc7V+SZLTYqFQchic3g
         sGFtcQyXb6Zmrl4DNHR38roS6VZRtBAM3XGnvw9NSZf1c7+7Z4jaPUbTVQQ7qhXwBJ
         jhT65j4rOvVFBGakwdD/ztpfxnrNJxzTe681zOqG18AdeuX/DitX8Utfz7YTAgD6xY
         xTBtPEArleFDARmCg4y00PhnuY9m1Vy035+cuWuSYZpgGSbaMSz8dWZeMFSruYlR9u
         iaP76UpfXi3Ew==
Date:   Thu, 16 Jun 2022 10:41:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH net] Revert "net: Add a second bind table hashed by port
 and address"
Message-ID: <20220616104121.6d00ffb0@kernel.org>
In-Reply-To: <CANn89iJeXRnb5VPMgFatfn8v8OPRh7riwkhg33XWCGg6tusenw@mail.gmail.com>
References: <20220615193213.2419568-1-joannelkoong@gmail.com>
        <CANn89i+Gf_xbz_df21QSM8ddjKkFfk1h4Y=p4vHroPRAz0ZYrw@mail.gmail.com>
        <2271ed3c6cbc3cd65680734107d773ee22ccfb3d.camel@redhat.com>
        <20220616101823.1a12e5d1@kernel.org>
        <CANn89iJeXRnb5VPMgFatfn8v8OPRh7riwkhg33XWCGg6tusenw@mail.gmail.com>
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

On Thu, 16 Jun 2022 19:28:49 +0200 Eric Dumazet wrote:
> On Thu, Jun 16, 2022 at 7:18 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Let me take the revert in for today's PR. Hope that's okay. We can
> > revive the test in -next with the wrapper/setup issue addressed.
> > I don't want more people to waste time bisecting the warnings this
> > generates.  
> 
> Note we have missing Reported-... tags to please syzbot.

Eish, thanks! These two only:

Reported-by: syzbot+015d756bbd1f8b5c8f09@syzkaller.appspotmail.com
Reported-by: syzbot+98fd2d1422063b0f8c44@syzkaller.appspotmail.com

or this one as well?

Reported-by: syzbot+0a847a982613c6438fba@syzkaller.appspotmail.com
https://syzkaller.appspot.com/bug?id=a63b46bf74a20d1a6b2893cedcda421620344479
