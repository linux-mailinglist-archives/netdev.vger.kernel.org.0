Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C9562E038
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbiKQPo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234811AbiKQPoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:44:24 -0500
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7630B5FC6;
        Thu, 17 Nov 2022 07:44:21 -0800 (PST)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 2AHFgbpU025691
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 10:42:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1668699767; bh=Z8eRjDyW5LkCGXRIWQ/ehJoBTxfA+rKV6G90HV/lnfI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=a5RGA55J01HygsEqMJNP2VrZPtI8ZaGUHt2dY2LY5wF8DMtynBL3gxe4ssBSltxUc
         tGBtVlIBAOfcvHXP8OxNBxX/rSKyMd0+qgQqEihqLCmIIT5R91T0BV2UToxLFXN9NK
         qLPI7qFXLd4XspU67nh5HMMeBw4NAJ1ReJokdr95mAlk7ege100zyHPP5eUMyPQkdJ
         2J/DoKBr5ulEfGsbUWpt2b/Jh4Fgk8Q/WSHSBEMDxX6G3lCTA/GKgvoNGo91ao1O85
         B0gVxshfsoXUb4HsVOvv2uuEHdk9gVaKkI7GIFJ0/jwX2DtNAGU82pYQXeJCXpebQn
         9YTcylqtbCwyg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 2CB0415C34C3; Thu, 17 Nov 2022 10:42:37 -0500 (EST)
Date:   Thu, 17 Nov 2022 10:42:37 -0500
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Kees Cook <kees@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
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
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org,
        ydroneaud@opteya.com
Subject: Re: [PATCH v2 3/3] treewide: use get_random_u32_between() when
 possible
Message-ID: <Y3ZWbcoGOdFjlPhS@mit.edu>
References: <20221114164558.1180362-1-Jason@zx2c4.com>
 <20221114164558.1180362-4-Jason@zx2c4.com>
 <202211161436.A45AD719A@keescook>
 <Y3V4g8eorwiU++Y3@zx2c4.com>
 <Y3V6QtYMayODVDOk@zx2c4.com>
 <202211161628.164F47F@keescook>
 <Y3WDyl8ArQgeEoUU@zx2c4.com>
 <0EE39896-C7B6-4CB6-87D5-22AA787740A9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0EE39896-C7B6-4CB6-87D5-22AA787740A9@kernel.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 04:47:27PM -0800, Kees Cook wrote:
> >> > - between
> >> > - ranged
> >> > - spanning
> >> > 
> >> > https://www.thefreedictionary.com/List-of-prepositions.htm
> >> > - amid
> >> > 
> >> > Sigh, names.
> >> 
> >> I think "inclusive" is best.
> >
> >I find it not very descriptive of what the function does. Is there one
> >you like second best? Or are you convinced they're all much much much
> >worse than "inclusive" that they shouldn't be considered?
> 
> Right, I don't think any are sufficiently descriptive. "Incluisve"
> with two arguments seems unambiguous and complete to me. :)

The problem with "between", "ranged", "spanning" is that they don't
tell the reader whether we're dealing with an "open interval" or a
"closed interval".  They are just different ways of saying that it's a
range between, say, 0 and 20.  But it doesn't tell you whether it
includes 0 or 20 or not.

The only way I can see for making it ambiguous is either to use the
terminology "closed interval" or "inclusive".  And "open" and "closed"
can have other meanings, so get_random_u32_inclusive() is going to be
less confusing than get_random_u32_closed().

Cheers,

					- Ted
