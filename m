Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB707609667
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 23:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJWVJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 17:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJWVJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 17:09:04 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D396686E;
        Sun, 23 Oct 2022 14:09:03 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 29NL7D2p025712
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Oct 2022 17:07:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1666559243; bh=zbENVyGNAon7zNh9ohkJFECSMTzXRXbcNrepMHxrEAM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=FXNrxCWraFmMAOW+vqR38ZOexAnGjiiR9A8LdOwTHYuoNMBlL77R2zP0ktOpr83lt
         VqRJZ2eM6bTmotP3IJ0ZjbLCm4EYxGWCpxZWFf6OGNB4ci103uHdfxC4WF6VQ2zTX/
         sdIQ8AMmuFf2tnrWyiobYzmlMOkVIMT/l7Xfqoj9INuJk54r2BALT8VjDgqDT3Zhdd
         VJdERnwc5/7VlgvkT7OeoHx0mHgokAaWpeUY/UYmdBjcPk3IReiiQVTczMP0A0m8lc
         roc5e18VhoTm14PI9JdmJ03W1yO7BPKEnbbIuJ9deFvxdyuN3p81VawGcIo+Cv1H4t
         KETGAaOyQuEfg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id BE8CB15C33A3; Sun, 23 Oct 2022 17:07:13 -0400 (EDT)
Date:   Sun, 23 Oct 2022 17:07:13 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christoph =?iso-8859-1?Q?B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        "Darrick J . Wong" <djwong@kernel.org>,
        SeongJae Park <sj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Helge Deller <deller@gmx.de>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org
Subject: Re: [PATCH v1 0/5] convert tree to
 get_random_u32_{below,above,between}()
Message-ID: <Y1WtAZfciG1z2CC7@mit.edu>
References: <20221022014403.3881893-1-Jason@zx2c4.com>
 <20221021205522.6b56fd24@kernel.org>
 <Y1NwJJOIB4gI5G11@zx2c4.com>
 <20221021223242.05df0a5b@kernel.org>
 <Y1OD2tdVwQsydSNV@zx2c4.com>
 <20221021230322.00dd045c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021230322.00dd045c@kernel.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 11:03:22PM -0700, Jakub Kicinski wrote:
> On Sat, 22 Oct 2022 07:47:06 +0200 Jason A. Donenfeld wrote:
> > On Fri, Oct 21, 2022 at 10:32:42PM -0700, Jakub Kicinski wrote:
> > > But whatever. I mean - hopefully there aren't any conflicts in the ~50
> > > networking files you touch. I just wish that people didn't pipe up with
> > > the tree wide changes right after the merge window. Feels like the
> > > worst possible timing.  
> > 
> > Oh, if the timing is what makes this especially worrisome, I have
> > no qualms about rebasing much later, and reposting this series then.
> > I'll do that.
> 
> Cool, thanks! I promise to not be grumpy if you repost around rc6 :)

One way of making things less painful for the stable branch and for
the upstream branch is to *add* new helpers instead of playing
replacement games like s/prandom_u32_max/get_random_u32_below/.  This
is what causes the patch conflict problems.

One advantage of at least adding the new functions to the stable
branches, even if we don't do the wholesale replacement, is that it
makes it much less likely that a backported patch, which uses the new
API, won't fail to compile --- and of course, the major headache case
is one where it's not noticed at first because it didn't get picked up
in people's test compiles until after the Linux x.y.z release has been
pushed out.

Whether it's worth doing the wholesale replacement is a different
question, but separating "add the new functions with one or two use
cases so the functions are actulaly _used_" from the "convert the
world to use the new functions" from the "remove the old functions",
might life easier.

					- Ted
