Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E7E4BB8F9
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbiBRMRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:17:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234997AbiBRMRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:17:14 -0500
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3551428BF4C;
        Fri, 18 Feb 2022 04:16:55 -0800 (PST)
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 21ICCdAd007386;
        Fri, 18 Feb 2022 06:12:39 -0600
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 21ICCbi7007385;
        Fri, 18 Feb 2022 06:12:37 -0600
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Fri, 18 Feb 2022 06:12:37 -0600
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     David Laight <David.Laight@aculab.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v3] net: Force inlining of checksum functions in net/checksum.h
Message-ID: <20220218121237.GQ614@gate.crashing.org>
References: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu> <35bcd5df0fb546008ff4043dbea68836@AcuMS.aculab.com> <d38e5e1c-29b6-8cc6-7409-d0bdd5772f23@csgroup.eu> <9b8ef186-c7fe-822c-35df-342c9e86cc88@csgroup.eu> <3c2b682a7d804b5e8749428b50342c82@AcuMS.aculab.com> <CAK7LNASWTJ-ax9u5yOwHV9vHCBAcQTazV-oXtqVFVFedOA0Eqw@mail.gmail.com> <2e38265880db45afa96cfb51223f7418@AcuMS.aculab.com> <CAK7LNASvBLLWMa+kb5eGJ6vpSqob_dBUxwCnpHZfL-spzRG7qA@mail.gmail.com> <20220217180735.GM614@gate.crashing.org> <CAK7LNAQ3tdOEYP7LjSX5+vhy=eUf0q-YiktQriH-rcr1n2Q3aA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNAQ3tdOEYP7LjSX5+vhy=eUf0q-YiktQriH-rcr1n2Q3aA@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 10:35:48AM +0900, Masahiro Yamada wrote:
> On Fri, Feb 18, 2022 at 3:10 AM Segher Boessenkool
> <segher@kernel.crashing.org> wrote:
> > On Fri, Feb 18, 2022 at 02:27:16AM +0900, Masahiro Yamada wrote:
> > > On Fri, Feb 18, 2022 at 1:49 AM David Laight <David.Laight@aculab.com> wrote:
> > > > That description is largely fine.
> > > >
> > > > Inappropriate 'inline' ought to be removed.
> > > > Then 'inline' means - 'really do inline this'.
> > >
> > > You cannot change "static inline" to "static"
> > > in header files.
> >
> > Why not?  Those two have identical semantics!
> 
> e.g.)
> 
> 
> [1] Open  include/linux/device.h with your favorite editor,
>      then edit
> 
> static inline void *devm_kcalloc(struct device *dev,
> 
>     to
> 
> static void *devm_kcalloc(struct device *dev,
> 
> 
> [2] Build the kernel

You get some "defined but not used" warnings that are shushed for
inlines.  Do you see something else?

The semantics are the same.  Warnings are just warnings.  It builds
fine.


Segher
