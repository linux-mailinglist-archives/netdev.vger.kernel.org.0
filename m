Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A90851E281
	for <lists+netdev@lfdr.de>; Sat,  7 May 2022 01:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444741AbiEFWa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 18:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444734AbiEFWa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 18:30:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83071838A
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 15:26:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 688ECB839E4
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 22:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3570C385A8;
        Fri,  6 May 2022 22:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651876002;
        bh=hnR/NT1kF0sv8ijGaNsE/LaITqVMCySf9KF/pIv0SvM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=avZQ9BWaz2QJrFaNREhtser0jW+V+ZfED7rjb2O86QuTWKUpULj1+c91F0zy7mQ/R
         de3Axrqokk65OsR2EHYiFmMXkCncoDfVYIPWTj0yTymPUXLM88LrYA/YKNnd5SQ+pO
         XO9tGyZRFa+XLocgiDy+gtSaYVYNVwlyc/D+1bsg3j2WAjMx7J82LtWXf8T1DdaNOu
         +aGpikwKOp6vUYssVBCijIZ+HJj4NCWFMwhMTo/05/RS+Lk/MzDFTPafBpmAm9M83L
         eMFtpN4lSdCRJCuIYk5oUrydyAbhk/8ohZtgu5J0t6SMNQD2ESRHe5FAzu17sNSu7A
         24U0UDVC+ZvQg==
Date:   Fri, 6 May 2022 15:26:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH v4 net-next 02/12] ipv6: add IFLA_GSO_IPV6_MAX_SIZE
Message-ID: <20220506152640.54b9d0ab@kernel.org>
In-Reply-To: <CAKgT0UfyUdPmYdShoadHorXX=Xene9WcEPQp2j2SPo-KyHQtWA@mail.gmail.com>
References: <20220506153048.3695721-1-eric.dumazet@gmail.com>
        <20220506153048.3695721-3-eric.dumazet@gmail.com>
        <e582432dbe85e743cc18d358d020711db5ddbf82.camel@gmail.com>
        <CANn89iL3sjnRKQNwbqxh_jh5cZ-Cxo58FKeqhP+mF969u4oQkA@mail.gmail.com>
        <CAKgT0Ud2YGhU1_z6xWmjdin5fT-VP7bAdnQrQcbMXULiFYJ3vQ@mail.gmail.com>
        <CANn89i+f0PGo86pD4XGS4FpjkcHwh-Nb2=r5D6=jp2jbgTY+nw@mail.gmail.com>
        <CAKgT0UfyUdPmYdShoadHorXX=Xene9WcEPQp2j2SPo-KyHQtWA@mail.gmail.com>
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

On Fri, 6 May 2022 15:16:21 -0700 Alexander Duyck wrote:
> On Fri, May 6, 2022 at 2:50 PM Eric Dumazet <edumazet@google.com> wrote:
> > gso_max_size can not exceed GSO_MAX_SIZE.
> > This will break many drivers.
> > I do not want to change hundreds of them.  
> 
> Most drivers will not be impacted because they cannot exceed
> tso_max_size. The tso_max_size is the limit, not GSO_MAX_SIZE. Last I
> knew this patch set is overwriting that value to increase it beyond
> the legacy limits.
> 
> Right now the check is:
> if (max_size > GSO_MAX_SIZE || max_size > dev->tso_max_size)
> 
> What I am suggesting is that tso_max_size be used as the only limit,
> which is already defaulted to cap out at TSO_LEGACY_MAX_SIZE. So just
> remove the "max_size > GSO_MAX_SIZE ||" portion of the call. Then when
> you call netif_set_tso_max_size in the driver to enable jumbograms you
> are good to set gso_max_size to something larger than the standard
> 65536.

TBH that was my expectation as well.

Drivers should not pay any attention to dev->gso_* any longer.

> > Look, we chose this implementation so that chances of breaking things
> > are very small.
> > I understand this is frustrating, but I suggest you take the
> > responsibility of breaking things,
> > and not add this on us.  
> 
> What I have been trying to point out is your patch set will break things.
> 
> For all those cases out there where people are using gso_max_size to
> limit things you just poked a hole in that for IPv6 cases. What I am
> suggesting is that we don't do that as it will be likely to trigger a
> number of problems for people.
> 
> The primary reason gso_max_size was added was because there are cases
> out there where doing too big of a TSO was breaking things. For
> devices that are being used for LSOv2 I highly doubt they need to
> worry about cases less than 65536. As such they can just max out at
> 65536 for all non-IPv6 traffic and instead use gso_max_size as the
> limit for the IPv6/TSO case.

Good point. GSO limit is expected to be a cap, so we shouldn't go above
it. At the same time nothing wrong with IPv4 continuing to generate 64k
GSOs after the user raises the limit.
