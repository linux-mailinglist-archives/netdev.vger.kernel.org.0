Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B748D64D267
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 23:36:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiLNWgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 17:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiLNWgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 17:36:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D371C36C61
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 14:36:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 903FFB81A2B
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 22:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2728AC433D2;
        Wed, 14 Dec 2022 22:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671057374;
        bh=/nYyJi1GJcayOcko803N1u+0e/rvcIFCDyVXBiAO1w4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rvy9mr+JhgbMqY4A9vtpBs8u8kptBybBAjPn7a4saef0jOBfTk9GtoIlBq4vZCB5O
         vweCIq0AL3saq3X+Nf/rW1w/rPMKbBqmSTOauQFWzlohLBFEDAOLZRSSXfhM1Eyp3I
         hLFouKbQe7SLIhFmdhuKvCmY3opelkVBJYonMY5A/RCOB8xNgbNjFYb3w1v161XZS/
         F0m/qYH8S9DX794zVmBBxt8253tRvnrH3uplferK46Yg2c5bkMPhGG2vvN+KHkWE39
         DwwUjKY1aQTqollJRw0NhsSuZAs5mbnqkTOI3LXP5a1QsKIj9XdaDJkeChx1vJcp6d
         Oh+FPEC0KvLfw==
Date:   Wed, 14 Dec 2022 14:36:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller <davem@davemloft.net>, Eric Dumazet
        <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Denis V. Lunev
        <den@openvz.org>, Kuniyuki Iwashima <kuni1840@gmail.com>," 
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 net] af_unix: Add error handling in af_unix_init().
Message-ID: <20221214143613.316aace2@kernel.org>
In-Reply-To: <CAKgT0UcDsUOD_rhg9tzWVJkiL+ihwcuvZQ-_6ovRcwT79j6NKw@mail.gmail.com>
References: <20221214092008.47330-1-kuniyu@amazon.com>
        <83daafadbf10945692689aa9431e42c8e790d3b7.camel@gmail.com>
        <20221214130131.17555240@kernel.org>
        <CAKgT0UcDsUOD_rhg9tzWVJkiL+ihwcuvZQ-_6ovRcwT79j6NKw@mail.gmail.com>
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

On Wed, 14 Dec 2022 14:27:23 -0800 Alexander Duyck wrote:
> > We ask people to add the "start of history" tag when the issue goes all
> > the way back.  
> 
> The point I was getting at is that this issue doesn't really go all
> the way back. Essentially sock_register could only fail if you were
> registering a proto over 32 or one that was already registered. So
> with 2.6.12-rc2 we should never see a failure without modifications to
> the kernel as we only register PF_UNIX once and the other functions at
> that time were void. This makes all the fixes tags suspect since the
> patch doesn't resolve any issue with that code.
> 
> More likely candidates would have been:
> Fixes: 94531cfcbe79 ("af_unix: Add unix_stream_proto for sockmap")
> Fixes: 097e66c57845 ("[NET]: Make AF_UNIX per network namespace safe [v2]")

I see! Makes sense.
