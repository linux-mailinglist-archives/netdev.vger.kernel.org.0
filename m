Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3313463FF55
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 05:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbiLBEJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 23:09:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbiLBEJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 23:09:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E671D038E;
        Thu,  1 Dec 2022 20:09:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9569060EA8;
        Fri,  2 Dec 2022 04:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0783C433D6;
        Fri,  2 Dec 2022 04:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669954195;
        bh=ubGorkvnG+fYZfKO1MSu0Vq8vrdN0JsKpKNkn8zefrg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mHBAPqLl/Oza2xOH739Dl2vFx5vT8VyCe0yr+iGFmkZI8X78b978HHrZLZlcCX+DT
         0KdmXfH3lbDu+IjDZt9afeg1xJ7NKILzn7mYQL+aMV96FiUYAqSvsI14Z8FbRKu9ka
         51CAztn8kq7vet+cKpx/s1Wru6vj4011GrvtyQRM1rVG1IlsOPpY7YqiaFvjLpGVP9
         MnEBAoW5ym04KItdqMi5/EVqoLYm28/2h5rzN+W3EgpKolWueoe5yIgmGmE1E427cN
         AIOgJjsOW5wnB1vG/hRovMWvor9f1QCddCBFp8nErni9iuJ76Z9u6VVNGfbOiRTlju
         ssBVWJeTgxPDw==
Date:   Thu, 1 Dec 2022 20:09:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/11] mptcp: PM listener events + selftests
 cleanup
Message-ID: <20221201200953.2944415e@kernel.org>
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
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

On Wed, 30 Nov 2022 15:06:22 +0100 Matthieu Baerts wrote:
> Thanks to the patch 6/11, the MPTCP path manager now sends Netlink events when
> MPTCP listening sockets are created and closed. The reason why it is needed is
> explained in the linked ticket [1]:
> 
>   MPTCP for Linux, when not using the in-kernel PM, depends on the userspace PM
>   to create extra listening sockets before announcing addresses and ports. Let's
>   call these "PM listeners".
> 
>   With the existing MPTCP netlink events, a userspace PM can create PM listeners
>   at startup time, or in response to an incoming connection. Creating sockets in
>   response to connections is not optimal: ADD_ADDRs can't be sent until the
>   sockets are created and listen()ed, and if all connections are closed then it
>   may not be clear to the userspace PM daemon that PM listener sockets should be
>   cleaned up.
> 
>   Hence this feature request: to add MPTCP netlink events for listening socket
>   close & create, so PM listening sockets can be managed based on application
>   activity.
> 
>   [1] https://github.com/multipath-tcp/mptcp_net-next/issues/313
> 
> Selftests for these new Netlink events have been added in patches 9,11/11.
> 
> The remaining patches introduce different cleanups and small improvements in
> MPTCP selftests to ease the maintenance and the addition of new tests.

Also could you warp you cover letters at 72 characters?
I need to reflow them before I can read them :(
