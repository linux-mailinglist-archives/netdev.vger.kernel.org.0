Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B205267D1
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382590AbiEMRBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382737AbiEMRAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:00:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215B120F59;
        Fri, 13 May 2022 10:00:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B916261F86;
        Fri, 13 May 2022 17:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D85C34100;
        Fri, 13 May 2022 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652461230;
        bh=dtccmH4YDFXmppBFKJRqTG14gV7vo6G4kTs/hPoTp2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NrtVMOS8YrvNoCTR5uBIe7gA1RHvj2J1juHKTwcQ5oyVEg8QZd09PL6AvTQdCw2FE
         t7Tz1DcTVrfVVh3V0dorWG+oqrp71ChDUDMb6M4PCzu6Oc86bf4CjD57bZC22FZ/Jp
         el8FnJAL5wHPHiCTGBARsAY2ghnYo2NUYiDxYhXP0Edji2BuQuH410IosvskxKYBsi
         3I7Mz0j2Bpm5W7+uIHf7wX5KKfsKznO//1YKKFsLXSKWvbGUDyMGqYTXQI1QiGRqYM
         2TVUUov0jpqpgvPqyFa/BpgQWiYbw6JpT3XFHPUrnrou1PzQjcNy/RqOjVVR0+NJkD
         3JCf/n1uXBfww==
Date:   Fri, 13 May 2022 10:00:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Subject: Re: [GIT PULL] virtio: last minute fixup
Message-ID: <20220513100028.5e7a80e8@kernel.org>
In-Reply-To: <87bkw1ecyx.fsf@email.froward.int.ebiederm.org>
References: <20220510082351-mutt-send-email-mst@kernel.org>
        <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com>
        <87czgk8jjo.fsf@mpe.ellerman.id.au>
        <CAHk-=wj9zKJGA_6SJOMPiQEoYke6cKX-FV3X_5zNXOcFJX1kOQ@mail.gmail.com>
        <87mtfm7uag.fsf@mpe.ellerman.id.au>
        <CAHk-=wgnYGY=10sRDzXCC2bmappjBTRNNbr8owvGLEW-xuV7Vw@mail.gmail.com>
        <CAHk-=wg=jfhgTkYBtY3LPPcUP=8A2bqH_iFezwOCDivuovE41w@mail.gmail.com>
        <87bkw1ecyx.fsf@email.froward.int.ebiederm.org>
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

On Fri, 13 May 2022 09:14:46 -0500 Eric W. Biederman wrote:
> I hate it when v1, v2, v3, v4, etc are not part of the same thread.
> 
> I find it very useful to go directly to the patch submission by
> following a single url and see the whole entire conversation right
> there.

I was gonna mention the --in-reply-to posting as a potential way around
the problem as well. But it comes with its own downsides - the threads
get huge and hard to keep track of at least in my patch flow.
