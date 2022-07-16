Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E864576B37
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 03:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbiGPBko convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 15 Jul 2022 21:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiGPBkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 21:40:43 -0400
Received: from relay4.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8264391CC6;
        Fri, 15 Jul 2022 18:40:42 -0700 (PDT)
Received: from omf07.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay02.hostedemail.com (Postfix) with ESMTP id 46EA234AD8;
        Sat, 16 Jul 2022 01:40:40 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf07.hostedemail.com (Postfix) with ESMTPA id EC0D22002F;
        Sat, 16 Jul 2022 01:40:36 +0000 (UTC)
Message-ID: <e3b59b09c958e420b74aab9f51d6eca0c63005ca.camel@perches.com>
Subject: Re: [PATCH] mediatek: mt7601u: fix clang -Wformat warning
From:   Joe Perches <joe@perches.com>
To:     Justin Stitt <justinstitt@google.com>
Cc:     Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
Date:   Fri, 15 Jul 2022 18:40:36 -0700
In-Reply-To: <CAFhGd8pJyRYq-3VrKM+6+k0AysfYbVJEJm3FMFt9eAysAKDUpQ@mail.gmail.com>
References: <20220711212932.1501592-1-justinstitt@google.com>
         <84e873c27f2426ce003e650004fe856bf72c634b.camel@perches.com>
         <CAFhGd8pJyRYq-3VrKM+6+k0AysfYbVJEJm3FMFt9eAysAKDUpQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Stat-Signature: 9arxp8zrxrtfhr9woubqw46ao9rxwyoi
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: EC0D22002F
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX188ldYAO7JJ3DMtC38rgMW1rKWpcluwGBk=
X-HE-Tag: 1657935636-65764
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-07-15 at 17:08 -0700, Justin Stitt wrote:
> On Thu, Jul 14, 2022 at 11:33 PM Joe Perches <joe@perches.com> wrote:
> > 
> > On Mon, 2022-07-11 at 14:29 -0700, Justin Stitt wrote:
> > > When building with Clang we encounter this warning:
> > > > drivers/net/wireless/mediatek/mt7601u/debugfs.c:92:6: error: format
> > > > specifies type 'unsigned char' but the argument has type 'int'
> > > > [-Werror,-Wformat] dev->ee->reg.start + dev->ee->reg.num - 1);
[]
> > I suggest s/%hh/%/ for all the uses here, not just this one.
> 
> I also contemplated this change but I think it might be a bit out of
> scope for https://github.com/ClangBuiltLinux/linux/issues/378  -- What
> do you think?

It would not be out of scope.

> It could be argued that every single instance of %hh[dux] should be
> replaced with %[dux].

All the vsprintf ones, but not the scanf ones.

