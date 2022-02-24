Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB7E4C241E
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 07:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiBXGeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 01:34:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiBXGeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 01:34:04 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC89AC915;
        Wed, 23 Feb 2022 22:33:35 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3C97768AA6; Thu, 24 Feb 2022 07:33:30 +0100 (CET)
Date:   Thu, 24 Feb 2022 07:33:30 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Christoph Hellwig <hch@lst.de>, Baoquan He <bhe@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, cl@linux.com, 42.hyeyoo@gmail.com,
        penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com,
        vbabka@suse.cz, David.Laight@aculab.com, david@redhat.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, michael@walle.cc,
        linux-i2c@vger.kernel.org, wsa@kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>
Subject: Re: [PATCH 00/22] Don't use kmalloc() with GFP_DMA
Message-ID: <20220224063330.GB20383@lst.de>
References: <20220219005221.634-1-bhe@redhat.com> <YhOaTsWUKO0SWsh7@osiris> <20220222084422.GA6139@lst.de> <YhaIcPmc8qi1zmnj@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YhaIcPmc8qi1zmnj@osiris>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 08:18:08PM +0100, Heiko Carstens wrote:
> > The long term goal is to remove ZONE_DMA entirely at least for
> > architectures that only use the small 16MB ISA-style one.  It can
> > then be replaced with for example a CMA area and fall into a movable
> > zone.  I'd have to prototype this first and see how it applies to the
> > s390 case.  It might not be worth it and maybe we should replace
> > ZONE_DMA and ZONE_DMA32 with a ZONE_LIMITED for those use cases as
> > the amount covered tends to not be totally out of line for what we
> > built the zone infrastructure.
> 
> So probably I'm missing something; but for small systems where we
> would only have ZONE_DMA, how would a CMA area within this zone
> improve things?

It would not, but more importantly we would not need it at all.  The
thinking here is really about the nasty 16MB ISA-style zone DMA.
a 31-bit something rather different.
