Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF9E5FD2E0
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbiJMBn3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Oct 2022 21:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJMBnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:43:21 -0400
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7678936DEB;
        Wed, 12 Oct 2022 18:43:19 -0700 (PDT)
Received: from omf20.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay02.hostedemail.com (Postfix) with ESMTP id 640C9120237;
        Thu, 13 Oct 2022 01:37:28 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf20.hostedemail.com (Postfix) with ESMTPA id 56EDD20026;
        Thu, 13 Oct 2022 01:37:01 +0000 (UTC)
Message-ID: <3f527ec95a12135eb40f5f2d156a2954feb7fbfe.camel@perches.com>
Subject: Re: [PATCH v1 3/5] treewide: use get_random_u32() when possible
From:   Joe Perches <joe@perches.com>
To:     David Laight <David.Laight@ACULAB.COM>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-actions@lists.infradead.org" 
        <linux-actions@lists.infradead.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "cake@lists.bufferbloat.net" <cake@lists.bufferbloat.net>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
        <linux-f2fs-devel@lists.sourceforge.net>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Date:   Wed, 12 Oct 2022 18:37:11 -0700
In-Reply-To: <d45bd258e033453b85a137112e7694e1@AcuMS.aculab.com>
References: <20221005214844.2699-1-Jason@zx2c4.com>
         <20221005214844.2699-4-Jason@zx2c4.com>
         <f8ad3ba44d28dec1a5f7626b82c5e9c2aeefa729.camel@perches.com>
         <d45bd258e033453b85a137112e7694e1@AcuMS.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Stat-Signature: jmxt1u5agdpi9w76hr4tp6uotie3p373
X-Rspamd-Server: rspamout03
X-Rspamd-Queue-Id: 56EDD20026
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18KEIRmyyr9pSEavQqF5X0dTzAEITyiJq4=
X-HE-Tag: 1665625021-540494
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-10-12 at 21:29 +0000, David Laight wrote:
> From: Joe Perches
> > Sent: 12 October 2022 20:17
> > 
> > On Wed, 2022-10-05 at 23:48 +0200, Jason A. Donenfeld wrote:
> > > The prandom_u32() function has been a deprecated inline wrapper around
> > > get_random_u32() for several releases now, and compiles down to the
> > > exact same code. Replace the deprecated wrapper with a direct call to
> > > the real function.
> > []
> > > diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> > []
> > > @@ -734,7 +734,7 @@ static int send_connect(struct c4iw_ep *ep)
> > >  				   &ep->com.remote_addr;
> > >  	int ret;
> > >  	enum chip_type adapter_type = ep->com.dev->rdev.lldi.adapter_type;
> > > -	u32 isn = (prandom_u32() & ~7UL) - 1;
> > > +	u32 isn = (get_random_u32() & ~7UL) - 1;
> > 
> > trivia:
> > 
> > There are somewhat odd size mismatches here.
> > 
> > I had to think a tiny bit if random() returned a value from 0 to 7
> > and was promoted to a 64 bit value then truncated to 32 bit.
> > 
> > Perhaps these would be clearer as ~7U and not ~7UL
> 
> That makes no difference - the compiler will generate the same code.

True, more or less.  It's more a question for the reader.

> The real question is WTF is the code doing?

True.

> The '& ~7u' clears the bottom 3 bits.
> The '- 1' then sets the bottom 3 bits and decrements the
> (random) high bits.

Right.

> So is the same as get_random_u32() | 7.

True, it's effectively the same as the upper 29 bits are random
anyway and the bottom 3 bits are always set.

> But I bet the coder had something else in mind.

Likely.

And it was also likely copy/pasted a few times.
