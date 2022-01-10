Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ADB489049
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235057AbiAJGmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiAJGmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:42:04 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1288EC06173F;
        Sun,  9 Jan 2022 22:42:04 -0800 (PST)
Date:   Mon, 10 Jan 2022 07:42:01 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1641796921;
        bh=qB4/ZCkV6Yn/0QFbhDvz9VnMhyqQ35EHcQ8g/7n7MsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WsMCCy1xHZJ7XnMbHsjqDmZsY0gjn3x2ZvHi7pdzwb1petcrQghPZ6pWVKfhVDQyD
         IEt1giuJdidx64WOrPCYmaCEcNhX4wIHTXml05yeayVD5vgFBEx3FM8Efzf0jQfzXp
         UGDlhTbgSOJNCzJ7LJNGgEkJNbd0TEqaxgM4AGq4=
From:   Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Stabellini <stefano@aporeto.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] 9p/trans_fd: split into dedicated module
Message-ID: <a168c7a0-aeb5-4eb1-8b26-751c0560b7ed@t-8ch.de>
References: <20211103193823.111007-1-linux@weissschuh.net>
 <20211103193823.111007-3-linux@weissschuh.net>
 <YduEira4sB0+ESYp@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YduEira4sB0+ESYp@codewreck.org>
Jabber-ID: thomas@t-8ch.de
X-Accept: text/plain, text/html;q=0.2, text/*;q=0.1
X-Accept-Language: en-us, en;q=0.8, de-de;q=0.7, de;q=0.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dominique,

On 2022-01-10 09:57+0900, Dominique Martinet wrote:
> Hi Thomas,
> 
> it's been a while but I had a second look as I intend on submitting this
> next week, just a small fixup on the Kconfig entry
> 
> Thomas Weißschuh wrote on Wed, Nov 03, 2021 at 08:38:21PM +0100:
> > diff --git a/net/9p/Kconfig b/net/9p/Kconfig
> > index 64468c49791f..af601129f1bb 100644
> > --- a/net/9p/Kconfig
> > +++ b/net/9p/Kconfig
> > @@ -15,6 +15,13 @@ menuconfig NET_9P
> >  
> >  if NET_9P
> >  
> > +config NET_9P_FD
> > +	depends on VIRTIO
> 
> I think that's just a copypaste leftover from NET_9P_VIRTIO ?
> Since it used to be code within NET_9P and it's within a if NET_9P it
> shouldn't depend on anything.
> 
> Also for compatibility I'd suggest we keep it on by default at this
> point, e.g. add 'default NET_9P' to this block:

Yes, you are correct on both points.

> diff --git a/net/9p/Kconfig b/net/9p/Kconfig
> index af601129f1bb..deabbd376cb1 100644
> --- a/net/9p/Kconfig
> +++ b/net/9p/Kconfig
> @@ -16,7 +16,7 @@ menuconfig NET_9P
>  if NET_9P
>  
>  config NET_9P_FD
> -       depends on VIRTIO
> +       default NET_9P
>         tristate "9P FD Transport"
>         help
>           This builds support for transports over TCP, Unix sockets and
> 
> 
> I'll just fixup the commit with a word in the message unless you have a
> problem with it, please let me know! :)

Looks good, thanks!

Thomas
