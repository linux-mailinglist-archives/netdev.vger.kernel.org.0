Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFD2584CDC
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 09:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235422AbiG2Hpf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 03:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbiG2Ho6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 03:44:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B15A820FC;
        Fri, 29 Jul 2022 00:44:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAD8561B53;
        Fri, 29 Jul 2022 07:44:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E4EC433C1;
        Fri, 29 Jul 2022 07:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659080684;
        bh=eNgc+xd6EKCnFcTzA3nXjMKDXkmbQ3zbhxeR9HD9n00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JzmS9fJ/jU6RD5w8rNQLml0UFhYK6zxgo1A2WnXt/ZWihBMWQRhYP05dyeQZMgSI+
         RV2lRByn06+NRdZGu9QZ5resZG5MvuH5QMkV7RU53Hd6ZLTdksI9JwfMjPQ9Cp4Cgd
         f8P5LTgrt7qFE1A5eDoTO6pYNX+kw1pQ1Ovto1tI=
Date:   Fri, 29 Jul 2022 09:44:41 +0200
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
Message-ID: <YuOP6Swa2E/npjWz@kroah.com>
References: <CANX2M5Yphi3JcCsMf3HgPPkk9XCfOKO85gyMdxQf3_O74yc1Hg@mail.gmail.com>
 <Ytzy9IjGXziLaVV0@kroah.com>
 <CANX2M5bxA5FF2Z8PFFc2p-OxkhOJQ8y=8PGF1kdLsJo+C92_gQ@mail.gmail.com>
 <Yt1MX1Z6z0y82i1I@kroah.com>
 <CANX2M5aX=JnKD-8kPyAN0Q64HvLoSO+3LvNvuaxkexCgeDWZHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANX2M5aX=JnKD-8kPyAN0Q64HvLoSO+3LvNvuaxkexCgeDWZHA@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 12:24:59PM -0700, Dipanjan Das wrote:
> On Sun, Jul 24, 2022 at 6:43 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > It is worth the effort if the problem is still in the latest kernel
> > release as that is the only place that new development happens.
> 
> The problem does not exist in the latest release.
> 
> > If the issue is not reproducible on Linus's current releases, then finding the
> > change that solved the problem is also good so that we can then backport
> > it to the stable/long term kernel release for everyone to benefit from.
> 
> The change that solved the issue in the mainline is this:
> 341adeec9adad0874f29a0a1af35638207352a39

As you must have tested this, can you provide a properly backported
version of this commit for the 5.4.y and 5.10.y trees, as it does not
apply cleanly as-is.

Please submit it to stable@vger.kernel.org and we will be glad to apply
it.

thanks,

greg k-h
