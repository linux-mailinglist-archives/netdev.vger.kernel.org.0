Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C9B3B3432
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbhFXQyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:54:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229881AbhFXQyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 12:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C31D96140A;
        Thu, 24 Jun 2021 16:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624553502;
        bh=8VJ9gHpfNusEy0hnsToOzf7TUZAq4xvU5hO1AlbgRro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pq5SVqGhwbOimMrJsmsORyiGbAYYOTTL6ujg1C56oBKp9zZJhsWzg/zNRpvAVCL1t
         W4iw9z/Znfp6VjndwmcbTgWTviXGQA7kExYTPH2HiU0L1F8rrW9y0rnTUy5BrHlqM5
         FZL8G89I7CwqGIIunZk2ANNGuue/yUF6qRZvGEro=
Date:   Thu, 24 Jun 2021 18:51:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, bpf@vger.kernel.org,
        wsd_upstream@mediatek.com, chao.song@mediatek.com,
        kuohong.wang@mediatek.com
Subject: Re: [PATCH 4/4] drivers: net: mediatek: initial implementation of
 ccmni
Message-ID: <YNS4GzYHpxMWIH+1@kroah.com>
References: <YNR5QuYqknaZS9+j@kroah.com>
 <20210624155501.10024-1-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624155501.10024-1-rocco.yue@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 11:55:02PM +0800, Rocco Yue wrote:
> On Thu, 2021-06-24 at 14:23 +0200, Greg KH wrote:
> On Thu, Jun 24, 2021 at 07:53:49PM +0800, Rocco Yue wrote:
> >> 
> >> without MTK ap ccci driver (modem driver), ccmni_rx_push() and
> >> ccmni_hif_hook() are not be used.
> >> 
> >> Both of them are exported as symbols because MTK ap ccci driver
> >> will be compiled to the ccci.ko file.
> > 
> > But I do not see any code in this series that use these symbols.  We can
> 
> will delete these symbols.
> 
> > not have exports that no one uses.  Please add the driver to this patch
> > series when you resend it.
> > 
> 
> I've just took a look at what the Linux staging tree is. It looks like
> a good choice for the current ccmni driver.
> 
> honstly, If I simply upload the relevant driver code B that calls
> A (e.g. ccmni_rx_push), there is still a lack of code to call B.
> This seems to be a continuty problem, unless all drivers codes are
> uploaded (e.g. power on modem, get hardware status, complete tx/rx flow).

Great, send it all!  Why is it different modules, it's only for one
chunk of hardware, no need to split it up into tiny pieces.  That way
only causes it to be more code overall.

> >> In addition, the code of MTK's modem driver is a bit complicated,
> >> because this part has more than 30,000 lines of code and contains
> >> more than 10 modules. We are completeing the upload of this huge
> >> code step by step. Our original intention was to upload the ccmni
> >> driver that directly interacts with the kernel first, and then
> >> complete the code from ccmni to the bottom layer one by one from
> >> top to bottom. We expect the completion period to be about 1 year.
> > 
> > Again, we can not add code to the kernel that is not used, sorry.  That
> > would not make any sense, would you want to maintain such a thing?
> > 
> > And 30k of code seems a bit excesive for a modem driver.   Vendors find
> > that when they submit code for inclusion in the kernel tree, in the end,
> > they end up 1/3 the original size, so 10k is reasonable.
> > 
> > I can also take any drivers today into the drivers/staging/ tree, and
> > you can do the cleanups there as well as getting help from others.
> > 
> > 1 year seems like a long time to do "cleanup", good luck!
> > 
> 
> Thanks~
> 
> Can I resend patch set as follows:
> (1) supplement the details of pureip for patch 1/4;
> (2) the document of ccmni.rst still live in the Documentation/...
> (3) modify ccmni and move it into the drivers/staging/...

for drivers/staging/ the code needs to be "self contained" in that it
does not require adding anything outside of the directory for it.

If you still require this core networking change, that needs to be
accepted first by the networking developers and maintainers.

thanks,

greg k-h
