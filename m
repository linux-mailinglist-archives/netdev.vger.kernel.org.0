Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7725A87A2
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 22:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiHaUm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 16:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiHaUm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 16:42:26 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95071E9900;
        Wed, 31 Aug 2022 13:42:24 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 94CF9C021; Wed, 31 Aug 2022 22:42:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1661978542; bh=2S8zNBkMltmRF/cvyoxKRx1ONepP3QD9MZcg6yVc+o8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d9P/NsNoX8MkIwSItZAKCOAi0leyFp63WG6GS46++sXtGbSot6NQi5KnDYcNbVZUJ
         GdhAe7Nds8tm6ZG6Tkt/+RTVNFpC5Euzv2ATZNTW7zE9zxwQySU/kJPtBr8aL3cLCa
         7Fs5DYYwQN9bkeoEFRnEEbM2fT0e/JmxOjrizXiGVshy0YWzIccCwrSfpZzq+04Btf
         PHZrabK4kCUWdi3JHieMwpP3e8rg47lARTGsTioaO5Q7x9knKS044hmURb5mMWBVeZ
         qncjFqE5a1BaEjWJew4htRgQfbHJ4CE0dN51+YD2ML/i1g2nAkhQtjsaZJW33PaO44
         CEs/1cbyynGFg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 966BAC009;
        Wed, 31 Aug 2022 22:42:18 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1661978541; bh=2S8zNBkMltmRF/cvyoxKRx1ONepP3QD9MZcg6yVc+o8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SjayXfD9nyhtO69rLqNAiqvy1T972+T12pYmOCjC9mXdTSMMeXwhUY5X0QYFM8Jlo
         HHY/0smde5bhP/o0/ZQHZbGgexcLtSwjFj9vL7+oBfYLp1C8jUwIaHFRjY7VLf2zgm
         wfYPsP80Rs3yQZU5d5IxgB8ANpSOVcRY+5u/P9DqX9Sm0ESTqz2waSypIQ51mNzltx
         Xr2uobUGC6VUewhQxFmw3PkuX4ygIOh/tGFHFLGK0c8Rf3s3IUmi/GDP9qL9IN9wwa
         IvjOqiTy7OpMVOUNrFf8v/A7EbWIeQ9n+53nU8ywX/cH+bYUjOUwxbd0Ds9HFxB1x/
         r1BqQviWbDSCw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id cb20c655;
        Wed, 31 Aug 2022 20:42:15 +0000 (UTC)
Date:   Thu, 1 Sep 2022 05:42:00 +0900
From:   asmadeus@codewreck.org
To:     Schspa Shi <schspa@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p9: trans_fd: Fix deadlock when connection cancel
Message-ID: <Yw/HmHcmXBVIg/SW@codewreck.org>
References: <20220831180950.76907-1-schspa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220831180950.76907-1-schspa@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Schspa Shi wrote on Thu, Sep 01, 2022 at 02:09:50AM +0800:
> To fix it, we can add extra reference counter to avoid deadlock, and
> decrease it after we unlock the client->lock.

Thanks for the patch!

Unfortunately I already sent a slightly different version to the list,
hidden in another syzbot thread, here:
https://lkml.kernel.org/r/YvyD053bdbGE9xoo@codewreck.org

(yes, sorry, not exactly somewhere I'd expect someone to find it... 9p
hasn't had many contributors recently)


Basically instead of taking an extra lock I just released the client
lock before calling p9_client_cb, so it shouldn't hang anymore.

We don't need the lock to call the cb as in p9_conn_cancel we already
won't accept any new request and by this point the requests are in a
local list that isn't shared anywhere.

If you have a test setup, would you mind testing my patch?
That's the main reason I was delaying pushing it.

Since you went out of your way to make this patch if you agree with my
approach I don't mind adding your sign off or another mark of having
worked on it.

Thank you,
--
Dominique
