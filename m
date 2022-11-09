Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF4F86224C9
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 08:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiKIHmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 02:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiKIHmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 02:42:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0C01A04A;
        Tue,  8 Nov 2022 23:42:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC536616E4;
        Wed,  9 Nov 2022 07:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBB5C433B5;
        Wed,  9 Nov 2022 07:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667979731;
        bh=1HMVBU8FNkTDsc3uJV2sC86erzOihnDIe2G3LUvxAbs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=00Ndco2Lv3D4vZksG1Qs3mTUfeuaRxZCOXXYWnnszLap3axnKdd+E/caHX/lIQCS8
         ZGoYBeC1zrJvFG5/7oQ/IKmpCMNR24+EqMLdDJvJ2jB5HyA0qsf2ze/5iDjNTQwqRY
         EYqIIsPZvbtdCOoIKj3vtyjOIj0/pmQO8iDR9qhc=
Date:   Wed, 9 Nov 2022 08:42:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Albert Zhou <albert.zhou.50@gmail.com>
Cc:     linux-usb@vger.kernel.org, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next RFC 2/5] r8152: update to version two
Message-ID: <Y2tZ0KIaQSVtrREg@kroah.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
 <20221108153342.18979-3-albert.zhou.50@gmail.com>
 <Y2qRyqiVuJ0LwySh@kroah.com>
 <370e2420-e875-3543-0128-57f7bce6be40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <370e2420-e875-3543-0128-57f7bce6be40@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 09, 2022 at 03:50:59PM +1100, Albert Zhou wrote:
> On 9/11/22 04:28, Greg KH wrote:
> > >   // SPDX-License-Identifier: GPL-2.0-only
> > >   /*
> > > - *  Copyright (c) 2014 Realtek Semiconductor Corp. All rights reserved.
> > > + *  Copyright (c) 2021 Realtek Semiconductor Corp. All rights reserved.
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > + * modify it under the terms of the GNU General Public License
> > > + * version 2 as published by the Free Software Foundation.
> > To start with, this is not correct.  Don't add back license boiler-plate
> > code.
> 
> Hi Greg,
> 
> My apologies, I was unaware of this. This can be easily removed.
> 
> > 
> > And you just changed the copyright notice incorrectly, that is not ok.
> > 
> 
> When I replaced the version-one code with the version-two code, I assumed
> the authors' copyright would be correct. What is the correct copyright
> notice?

The correct way would be to list all years that the copyright was
asserted for the file.  Your patch removed the copyright notice for an
older year, which isn't ok.

But the larger issue here is that just wholesale replacing the in-tree
driver with an out-of-tree one isn't going to work.  As others have
pointed out, you need to break the changes up into
one-patch-per-logical-change and drag the driver forward that way.

The easiest way for you to do this is to clean up the out-of-tree driver
on its own, removing all the backwards compatibility stuff, and then try
to figure out what features are different and add them to the in-kernel
driver, one by one.

It's not an easy task, but as you have the hardware to test with, should
be doable.

good luck!

> > > + *
> > > + *  This product is covered by one or more of the following patents:
> > > + *  US6,570,884, US6,115,776, and US6,327,625.
> > Oh wow.  That's playing with fire...
> 
> Do you believe this prohibits the code from being in the kernel?

No I do not.  It's just not something that is normally advertised in the
kernel for obvious reasons :)

thanks,

greg k-h
