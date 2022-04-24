Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB5B50D601
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 01:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239891AbiDXX3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 19:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233081AbiDXX3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 19:29:14 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA8536A043;
        Sun, 24 Apr 2022 16:26:11 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id 901EF92009C; Mon, 25 Apr 2022 01:26:10 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id 8248092009B;
        Mon, 25 Apr 2022 00:26:10 +0100 (BST)
Date:   Mon, 25 Apr 2022 00:26:10 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Andrew Lunn <andrew@lunn.ch>
cc:     Wan Jiabing <wanjiabing@vivo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@yeah.net
Subject: Re: [PATCH] FDDI: defxx: simplify if-if to if-else
In-Reply-To: <YmXMcUAhUg/p1X3R@lunn.ch>
Message-ID: <alpine.DEB.2.21.2204250009240.9383@angie.orcam.me.uk>
References: <20220424092842.101307-1-wanjiabing@vivo.com> <alpine.DEB.2.21.2204241137440.9383@angie.orcam.me.uk> <YmXMcUAhUg/p1X3R@lunn.ch>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Apr 2022, Andrew Lunn wrote:

> >  NAK.  The first conditional optionally sets `bp->mmio = false', which 
> > changes the value of `dfx_use_mmio' in some configurations:
> > 
> > #if defined(CONFIG_EISA) || defined(CONFIG_PCI)
> > #define dfx_use_mmio bp->mmio
> > #else
> > #define dfx_use_mmio true
> > #endif
> 
> Which is just asking for trouble like this.
> 
> Could i suggest dfx_use_mmio is changed to DFX_USE_MMIO to give a hint
> something horrible is going on.

 There's legacy behind it, `dfx_use_mmio' used to be a proper variable and 
references were retained not to obfuscate the changes that ultimately led 
to the current arrangement.  I guess at this stage it could be changed to 
a function-like macro or a static inline function taking `bp' as the 
argument.

> It probably won't stop the robots finding this if (x) if (!x), but
> there is a chance the robot drivers will wonder why it is upper case.

 Well, blindly relying on automation is bound to cause trouble.  There has 
to be a piece of intelligence signing the results off at the end.

 And there's nothing wrong with if (x) if (!x) in the first place; any 
sane compiler will produce reasonable output from it.  Don't fix what 
ain't broke!  And watch out for volatiles!

  Maciej
