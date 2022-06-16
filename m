Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4EF54E889
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378235AbiFPRSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378231AbiFPRS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:18:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0123B281
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 10:18:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C845B82531
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 17:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B761AC3411A;
        Thu, 16 Jun 2022 17:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655399905;
        bh=AI31dPnjTk8XjOWamI3liJ8yOk+mST3t3LMY20FVStQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MpF+xUVvcJHXdPBBFmWYD6dKpkRWvyeqUPYkRB0+IashGYd4ZIU3wCwstImQ5FUlR
         bpHQ8Kiabo0zmfMYK98HMKqkHrJUEq7u523aO6QCysLZdp76IGwzvYDdyplaQXyxiW
         ANbxlba/JyLzvYoFVNHF9kHmt2tmTIGNWmIJ9eNnGqZXP1rGYixjfHcd2dqKI6DxuC
         xAtXnkIO64oeyjYMDbiVQL3612VgGz+GMLFbn0HoX6AiM5k5hMTihVM8yDVELnm07N
         L/FGJoC6sHNwTAODD69KwyT5ikytLyByde9UUKdfPN7xVb9l13QPgYt0q4Z2kZOXFg
         pkGL/MGoAyVWA==
Date:   Thu, 16 Jun 2022 10:18:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        netdev <netdev@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH net] Revert "net: Add a second bind table hashed by port
 and address"
Message-ID: <20220616101823.1a12e5d1@kernel.org>
In-Reply-To: <2271ed3c6cbc3cd65680734107d773ee22ccfb3d.camel@redhat.com>
References: <20220615193213.2419568-1-joannelkoong@gmail.com>
        <CANn89i+Gf_xbz_df21QSM8ddjKkFfk1h4Y=p4vHroPRAz0ZYrw@mail.gmail.com>
        <2271ed3c6cbc3cd65680734107d773ee22ccfb3d.camel@redhat.com>
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

On Thu, 16 Jun 2022 12:01:36 +0200 Paolo Abeni wrote:
> > Do we really need to remove the test ? It is a benchmark, and should
> > not 'fail' on old kernels.  
> 
> I agree it's nice to keep the self-test alive.
> 
> Side notes, not strictly related to the revert: the self test is not
> currently executed by `make run_tests` and requires some additional
> setup: ulimit -n <high number>, 2001:db8:0:f101::1 being a locally
> available address, and a mandatory command line argument.
> 
> @Joanne: you should additionally provide a wrapper script to handle the
> above and update TEST_PROGS accordingly. As for this revert, could you
> please re-post it touching the kernel code only?

Let me take the revert in for today's PR. Hope that's okay. We can
revive the test in -next with the wrapper/setup issue addressed. 
I don't want more people to waste time bisecting the warnings this
generates.
