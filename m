Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE0BC4D5336
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244489AbiCJUt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbiCJUt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:49:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8743119F3E;
        Thu, 10 Mar 2022 12:48:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47C4061802;
        Thu, 10 Mar 2022 20:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33309C340E8;
        Thu, 10 Mar 2022 20:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646945306;
        bh=v9KhSqMb17wFpYeglwv/RTvKZjpg+FHc03tMML1YW6I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q6S+i2favkSou+oXhtcAcmyTFB1ksDqZNOh1YVlh/gOonStz0Tt0gkI0G2zlxj5/Q
         dCvHFNFaejqB6i98raEaIhYq1KU33Kbmx/MJNinwwjCM3EXnkhOSta0TmLdIVYrjY3
         fEZItTLkThMYRhk/0dK/tOQ9PkY+5zcJDLAtiPb4Arn0wGd9yXwkINgIabS2pnLKH3
         l5rAoiP2tztPsbL2mxlvcV5xY76ypOKfk/UOvJtTqIQS7BP05M9Q1r5NRsH2JTSZNq
         hQhK0QlQWsSGsrHwUEm/KHv+mjgF8s5WMhQwp21m5sYnYSUDqLHMftyUmH9MwTnhKE
         alHmuVY9wpTdg==
Date:   Thu, 10 Mar 2022 12:48:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mingbao Sun <sunmingbao@tom.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        tyler.sun@dell.com, ping.gan@dell.com, yanxiu.cai@dell.com,
        libin.zhang@dell.com, ao.sun@dell.com
Subject: Re: [PATCH] tcp: export symbol tcp_set_congestion_control
Message-ID: <20220310124825.159ce624@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310134830.130818-1-sunmingbao@tom.com>
References: <20220310134830.130818-1-sunmingbao@tom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 21:48:30 +0800 Mingbao Sun wrote:
> Since the kernel API 'kernel_setsockopt' was removed, and since the
> function =E2=80=98tcp_set_congestion_control=E2=80=99 is just the real un=
derlying guy
> handling this job, so it makes sense to get it exported.

Do you happen to have a reference to the commit which removed
kernel_setsockopt and the justification?  My knee jerk reaction
would the that's a better path than allowing in-kernel socket users=20
to poke at internal functions even if that works as of today.
