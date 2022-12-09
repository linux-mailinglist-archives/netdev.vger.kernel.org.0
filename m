Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC2E647C1F
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 03:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiLICRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 21:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiLICRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 21:17:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29ECE1DDF0;
        Thu,  8 Dec 2022 18:17:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAD22B82607;
        Fri,  9 Dec 2022 02:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C94C433EF;
        Fri,  9 Dec 2022 02:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670552261;
        bh=jy4TXYOW1L8kAIgjEyfRm7pFWKk4DQK8fiyxC8IyzIM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q1oqiA/EVBymLnDzKwCLl7yjf8CGv8GcB4AoEvALYBNoOdq/6K95orLFCADGr+aKY
         PuOX9YUXYWKZTaJgGs+BR769ofMYZ0J2vqEc7AAJOhcQxM0Z++/Da28EcDh0qhH35j
         MnaAd+uASvaZ0O8nfayJnSOCJIvSYHfn6wMTS9nbGY8byCFJBah+6QRFffSX4zQXYQ
         a9C5swhNoqv0RWUwrLj+wE91B0vpzogk3hkQf49d/jGessM0NCDc8XMX4nX9vZSqiF
         9iBvdlt8n+F/BSZcYaQgLRjHUmBd394P1chsHqNYukPRJmoTQfaSCwGLmcBXYM/+9S
         uG2HX8OfZMaqg==
Date:   Thu, 8 Dec 2022 18:17:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: selftests: net: cmsg_so_mark.sh test hangs
Message-ID: <20221208181740.7a322a46@kernel.org>
In-Reply-To: <CA+G9fYsM2k7mrF7W4V_TrZ-qDauWM394=8yEJ=-t1oUg8_40YA@mail.gmail.com>
References: <CA+G9fYsM2k7mrF7W4V_TrZ-qDauWM394=8yEJ=-t1oUg8_40YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 5 Dec 2022 17:59:37 +0530 Naresh Kamboju wrote:
> The selftest net cmsg_so_mark.sh test hangs on all devices.
> Test case run with "set -x" to identify which steps are causing the hang.

Is it possible to get a stack trace of the script while it's blocked?
=46rom /proc/$pid/stack ?

The test takes 30sec on a debug-heavy build for me so capturing a stack
a couple of minutes after starting should should us where it's stuck?

> Am I missing any pre-requirements / setup ?

And it works here..

The only thing I can see that may be blocking is getaddrinfo()... maybe?
Is there anything special going on with address resolution?
