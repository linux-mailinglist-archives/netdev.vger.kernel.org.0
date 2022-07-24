Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBCC57F53D
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 15:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiGXNnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 09:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiGXNnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 09:43:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A30E0AA;
        Sun, 24 Jul 2022 06:43:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC27DB80D32;
        Sun, 24 Jul 2022 13:43:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9279CC3411E;
        Sun, 24 Jul 2022 13:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658670180;
        bh=maUBUTNvw0Eg0uVI0eTfJ37pCQzM3v+3MOLAjM/O4Dw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uhOxHNmuPO8N7ia5ENwOhWBb/UJwNbxm70SQCqg55A0iLJEuDHw86etfiTDFaGh0b
         RR4SiAf/Df2jO6UR7KI8Jwi6qYyVuDP7c073nCU4zPffAQiuNiIYwDm05Qy4cetjL6
         GAWflP+r3wDg1WrpfYq0NcYN4tPtSRLI60ZFfwfk=
Date:   Sun, 24 Jul 2022 15:42:55 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dipanjan Das <mail.dipanjan.das@gmail.com>
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sashal@kernel.org, edumazet@google.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        syzkaller@googlegroups.com, fleischermarius@googlemail.com,
        its.priyanka.bose@gmail.com
Subject: Re: general protection fault in sock_def_error_report
Message-ID: <Yt1MX1Z6z0y82i1I@kroah.com>
References: <CANX2M5Yphi3JcCsMf3HgPPkk9XCfOKO85gyMdxQf3_O74yc1Hg@mail.gmail.com>
 <Ytzy9IjGXziLaVV0@kroah.com>
 <CANX2M5bxA5FF2Z8PFFc2p-OxkhOJQ8y=8PGF1kdLsJo+C92_gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANX2M5bxA5FF2Z8PFFc2p-OxkhOJQ8y=8PGF1kdLsJo+C92_gQ@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 24, 2022 at 12:40:09AM -0700, Dipanjan Das wrote:
> On Sun, Jul 24, 2022 at 12:26 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Sat, Jul 23, 2022 at 03:07:09PM -0700, Dipanjan Das wrote:
> > > Hi,
> > >
> > > We would like to report the following bug which has been found by our
> > > modified version of syzkaller.
> >
> > Do you have a fix for this issue?  Without that, it's a bit harder as:
> 
> We will try to root cause the issue and provide a fix, if possible.
> 
> >
> > > ======================================================
> > > description: general protection fault in sock_def_error_report
> > > affected file: net/core/sock.c
> > > kernel version: 5.4.206
> >
> > You are using a very old kernel version, and we have loads of other
> > syzbot-reported issues to resolve that trigger on newer kernels.
> 
> Since 5.4.206 is a longterm release kernel, we were under the
> impression that the community is still accepting fixes and patches for
> the same. I understand that adding another bug to the already pending
> queue of syzbot reported issues is not going to help the developers
> much. Therefore, we will definitely try our best to analyze the issue
> and provide a fix in the coming days. Can you please confirm that it
> is worth the effort for the longterm release kernels?

It is worth the effort if the problem is still in the latest kernel
release as that is the only place that new development happens.  If the
issue is not reproducible on Linus's current releases, then finding the
change that solved the problem is also good so that we can then backport
it to the stable/long term kernel release for everyone to benefit from.

So does your reproducer still work on the latest 5.19-rc7 release?

thanks,

greg k-h
