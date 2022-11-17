Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE37B62D039
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 01:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbiKQAtp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 19:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238857AbiKQAt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 19:49:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513566EB5A;
        Wed, 16 Nov 2022 16:47:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 209FFB81F6A;
        Thu, 17 Nov 2022 00:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8FBC433C1;
        Thu, 17 Nov 2022 00:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668646047;
        bh=guj/solGyKYsGM3X50ye22aBLwCmKYGrl61AHGGkEhE=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=sjDtqHkF0xLcJiWNqyyDHGsDobgvPbfsokLdvow1ubzRNPmvBoIvJzHi8Yvqb4Pia
         HGnNQCiHG1RVXNT6hd1LZczDgT6F6qeXv8kJeuvGJn8/+br1/937HnYvk/G8IGtl+Q
         ZFQtIA7mOoXoRnyX6MG86ilsJRRpQYAqs3JYwVGnUz8zmv/S71R/vUNqVudKP5d8I/
         ngbo5GGVXMVg4tvgdFr9Scm7j09sy5k6AryrwAM5JfM8N31vtbPnEIZ3gh0dJd/VXg
         XOgCVYXFpotxvKQyMUSDn+SRaAJK+w/ApIZQhMRnYYGss7TFYZd8CE/hTnB50vXpx1
         xZriYx3JI13JA==
Date:   Wed, 16 Nov 2022 16:47:27 -0800
From:   Kees Cook <kees@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Kees Cook <keescook@chromium.org>
CC:     linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        =?ISO-8859-1?Q?Christoph_B=F6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Theodore Ts'o <tytso@mit.edu>,
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
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_3/3=5D_treewide=3A_use_ge?= =?US-ASCII?Q?t=5Frandom=5Fu32=5Fbetween=28=29_when_possible?=
User-Agent: K-9 Mail for Android
In-Reply-To: <Y3WDyl8ArQgeEoUU@zx2c4.com>
References: <20221114164558.1180362-1-Jason@zx2c4.com> <20221114164558.1180362-4-Jason@zx2c4.com> <202211161436.A45AD719A@keescook> <Y3V4g8eorwiU++Y3@zx2c4.com> <Y3V6QtYMayODVDOk@zx2c4.com> <202211161628.164F47F@keescook> <Y3WDyl8ArQgeEoUU@zx2c4.com>
Message-ID: <0EE39896-C7B6-4CB6-87D5-22AA787740A9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On November 16, 2022 4:43:54 PM PST, "Jason A=2E Donenfeld" <Jason@zx2c4=2E=
com> wrote:
>On Wed, Nov 16, 2022 at 04:31:18PM -0800, Kees Cook wrote:
>> On Thu, Nov 17, 2022 at 01:03:14AM +0100, Jason A=2E Donenfeld wrote:
>> > On Thu, Nov 17, 2022 at 12:55:47AM +0100, Jason A=2E Donenfeld wrote:
>> > > 2) What to call it:
>> > >    - between I still like, because it mirrors "I'm thinking of a nu=
mber
>> > >      between 1 and 10 and=2E=2E=2E" that everybody knows,
>> > >    - inclusive I guess works, but it's not a preposition,
>> > >    - bikeshed color #3?
>> >=20
>> > - between
>> > - ranged
>> > - spanning
>> >=20
>> > https://www=2Ethefreedictionary=2Ecom/List-of-prepositions=2Ehtm
>> > - amid
>> >=20
>> > Sigh, names=2E
>>=20
>> I think "inclusive" is best=2E
>
>I find it not very descriptive of what the function does=2E Is there one
>you like second best? Or are you convinced they're all much much much
>worse than "inclusive" that they shouldn't be considered?

Right, I don't think any are sufficiently descriptive=2E "Incluisve" with =
two arguments seems unambiguous and complete to me=2E :)


--=20
Kees Cook
