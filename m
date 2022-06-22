Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262145552F5
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 20:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358979AbiFVSHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 14:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbiFVSHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 14:07:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D10137A1A;
        Wed, 22 Jun 2022 11:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 052D9B8207C;
        Wed, 22 Jun 2022 18:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55A57C34114;
        Wed, 22 Jun 2022 18:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655921254;
        bh=9v6QXZNg0hA9ptWbQZ5AT1Ka8fcEQnwliWHpv9K1+O8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Jt7PLlEe9hAkCthzeSVOJH78NAAeRmmobELYd4a+JNk3+Q0JpEsVezqIB+k8OxWgb
         hOqgS/tg4dfasgfcwmMU8Lln80JQU35EYzxk9R1E4aOQna8WoiSrghIFiLZRxm5wfb
         lPKLZBihfsVjEsIRdroUTNtlv/Ky7S2k4CjBVnKATE/g0thG7bh2Q/X2pwssGCPNp+
         7SIRf5kH9TKdsDk9lyV7bXSgpDnLZTvSfocD0iD+bHfa8F0EI1FXRYI8w5g1618SL1
         zvs3+0ihE7FzLTPuV9zSO8gxnKnqejRe1OdulVHyFptNFswiAPsy5KBi9YglFi3yHK
         Tr9ccds5axntg==
Date:   Wed, 22 Jun 2022 11:07:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mainline build failure due to 281d0c962752 ("fortify: Add Clang
 support")
Message-ID: <20220622110733.1eba089c@kernel.org>
In-Reply-To: <YrMu5bdhkPzkxv/X@dev-arch.thelio-3990X>
References: <YrLtpixBqWDmZT/V@debian>
        <CAHk-=wiN1ujyVTgyt1GuZiyWAPfpLwwg-FY1V-J56saMyiA1Lg@mail.gmail.com>
        <YrMu5bdhkPzkxv/X@dev-arch.thelio-3990X>
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

On Wed, 22 Jun 2022 08:01:57 -0700 Nathan Chancellor wrote:
> On Wed, Jun 22, 2022 at 08:47:22AM -0500, Linus Torvalds wrote:
> > On Wed, Jun 22, 2022 at 5:23 AM Sudip Mukherjee
> > <sudipm.mukherjee@gmail.com> wrote:  
> > >
> > > I have recently (since yesterday) started building the mainline kernel
> > > with clang-14 and I am seeing a build failure with allmodconfig.  
> 
> Right, this is known. Kees sent a fix for that warning recently but it
> went to net-next instead of net it seems:
> 
> https://git.kernel.org/netdev/net-next/c/2c0ab32b73cfe39a609192f338464e948fc39117
> 
> I am not sure if that change could be cherry-picked or applied to net so
> that it could be fixed in mainline, I see the netdev maintainers are
> already on CC so maybe they can comment on that?

Sorry about the hassle, done now. It's commit 1e70212e0315 ("hinic:
Replace memcpy() with direct assignment") in net and should make it 
to Linus tomorrow.
