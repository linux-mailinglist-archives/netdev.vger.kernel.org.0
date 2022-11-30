Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506C963E119
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 21:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiK3UFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 15:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiK3UFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 15:05:06 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FD28565B;
        Wed, 30 Nov 2022 12:05:03 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id B3E7AC01D; Wed, 30 Nov 2022 21:05:10 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669838710; bh=PrVpEb8uC8MO75/KKnPwfTD4c6f26p9EYuEmyToPrZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v2cakNGE3wWtE7Olt8MHGLu+RZpRoUz1shSd2NYNGCmSURAp/GcsO+ieSXq0ZqvmA
         KiBHMLbDqVlPkiPENNprrrBSoBXSpjVnealaa34rS1sSlLTj0zu5azARKvI7BHySzS
         3tX0nLxwA0QDLxd+5R59MaXa7qqvT0A4nkaAPaol2+Ef6NQUwGmrK6S01DfNVeM7Ws
         0kzERfIE5ZC4tq3QaxDt4pvHyxcZWuakgaEy/5Y8lB4Sm7z3UluJEJHsH3iWguAxSd
         jud9apCXkYz9ZJGyDEmKyoQwGyGlaypuusuviUrrN1o+cbn3/mjACgqI04UgiV1yhd
         FAXGzaSnSVWBg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 02960C009;
        Wed, 30 Nov 2022 21:05:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669838710; bh=PrVpEb8uC8MO75/KKnPwfTD4c6f26p9EYuEmyToPrZc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v2cakNGE3wWtE7Olt8MHGLu+RZpRoUz1shSd2NYNGCmSURAp/GcsO+ieSXq0ZqvmA
         KiBHMLbDqVlPkiPENNprrrBSoBXSpjVnealaa34rS1sSlLTj0zu5azARKvI7BHySzS
         3tX0nLxwA0QDLxd+5R59MaXa7qqvT0A4nkaAPaol2+Ef6NQUwGmrK6S01DfNVeM7Ws
         0kzERfIE5ZC4tq3QaxDt4pvHyxcZWuakgaEy/5Y8lB4Sm7z3UluJEJHsH3iWguAxSd
         jud9apCXkYz9ZJGyDEmKyoQwGyGlaypuusuviUrrN1o+cbn3/mjACgqI04UgiV1yhd
         FAXGzaSnSVWBg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 83fc1053;
        Wed, 30 Nov 2022 20:04:55 +0000 (UTC)
Date:   Thu, 1 Dec 2022 05:04:40 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Marco Elver <elver@google.com>, rcu <rcu@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kunit-dev@googlegroups.com, lkft-triage@lists.linaro.org,
        kasan-dev <kasan-dev@googlegroups.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: arm64: allmodconfig: BUG: KCSAN: data-race in p9_client_cb /
 p9_client_rpc
Message-ID: <Y4e3WC4UYtszfFBe@codewreck.org>
References: <CA+G9fYsK5WUxs6p9NaE4e3p7ew_+s0SdW0+FnBgiLWdYYOvoMg@mail.gmail.com>
 <CANpmjNOQxZ--jXZdqN3tjKE=sd4X6mV4K-PyY40CMZuoB5vQTg@mail.gmail.com>
 <CA+G9fYs55N3J8TRA557faxvAZSnCTUqnUx+p1GOiCiG+NVfqnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+G9fYs55N3J8TRA557faxvAZSnCTUqnUx+p1GOiCiG+NVfqnw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Naresh Kamboju wrote on Wed, Nov 30, 2022 at 09:34:45PM +0530:
> > > [  424.418214] write to 0xffff00000a753000 of 4 bytes by interrupt on cpu 0:
> > > [  424.422437]  p9_client_cb+0x84/0x100
> >
> > Then we can look at git blame of the lines and see if it's new code.
> 
> True.
> Hope that tree and tag could help you get git details.

Even with the git tag, if we don't build for the same arch with the same
compiler version/options and the same .config we aren't likely to have
identical binaries, so we cannot make sense of these offsets without
much work.

As much as I'd like to investigate a data race in 9p (and geez that code
has been such a headache from syzbot already so I don't doubt there are
more), having line numbers is really not optional if we want to scale at
all.
If you still have the vmlinux binary from that build (or if you can
rebuild with the same options), running this text through addr2line
should not take you too long.
(You might need to build with at least CONFIG_DEBUG_INFO_REDUCED (or not
reduced), but that is on by default for aarch64)

--
Dominique
