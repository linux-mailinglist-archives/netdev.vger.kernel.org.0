Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBD6488D95
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 01:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234516AbiAJA6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 19:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiAJA6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 19:58:12 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7A7C06173F;
        Sun,  9 Jan 2022 16:58:12 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 6CB9EC009; Mon, 10 Jan 2022 01:58:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1641776289; bh=uRt8DC7aSOODc1J8lbTlNqkqIzph89yqmPrsx4NeG4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cHPqt7XNNOftLpstaYVnaGUIb9o7/kwYXWS5ral8oYtoOmfukwOYLGNPgTRGHK27B
         GvUH0SCVElXLYs+qUldr6GmornA42UR5d8KJDzgwQNwmZR3Lr6+o7+Oe4JszwwxPdD
         V2rBuGlcFoEZrD6l+1mazEDwNqoi9COXddfKzAsZDESvdCe7CWjwR5ooZCtBKHMXBn
         4mfV1ihXWU3XmMNnRrR9uLh8zqBadN/eatHeSZyAvktzCKt0UmMm6XsF0xsRLe/tAb
         BUJNYgELXsbQLVie6PcilCAO3Zbh3gnY0MoBLQHx/pG8vpioD96U5qs8+D5IE4b169
         T0BoQynyYKmsA==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 135C6C009;
        Mon, 10 Jan 2022 01:58:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1641776288; bh=uRt8DC7aSOODc1J8lbTlNqkqIzph89yqmPrsx4NeG4k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FeIl0b+QkCy2RI29bvXVS2zWPjDKARpjnKg9dDuj1cMtAEtjmKFQRSYJ2k08Xe7CF
         CISXm6pNP1CrVinaJOZP3HMUSXXA36a4OCtLrysofIiAzzvTUu+fErDx1ohl1j3wLM
         sx+IspaAn7GpOJUpe5D3CaOw+XdiUe8pVWwU3bhlVwlEaOLWqDumPc0YDe5+esQLwX
         OB2Q36B9N/IUNLLBJvCEwE+4AiayGR+ksgZ5Y75joOGEibIaEbVgq73dtxthfw9cHA
         UVacMY3Uhb4yCLGQl5L9BwJZDc/IZLUQFMbTa4aPo0lVUWh/Hg+nE38XJx7FGy+hwR
         b5YJ6FWXVsxsw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id a5dcf08b;
        Mon, 10 Jan 2022 00:58:01 +0000 (UTC)
Date:   Mon, 10 Jan 2022 09:57:46 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefano Stabellini <stefano@aporeto.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] 9p/trans_fd: split into dedicated module
Message-ID: <YduEira4sB0+ESYp@codewreck.org>
References: <20211103193823.111007-1-linux@weissschuh.net>
 <20211103193823.111007-3-linux@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211103193823.111007-3-linux@weissschuh.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

it's been a while but I had a second look as I intend on submitting this
next week, just a small fixup on the Kconfig entry

Thomas Weißschuh wrote on Wed, Nov 03, 2021 at 08:38:21PM +0100:
> diff --git a/net/9p/Kconfig b/net/9p/Kconfig
> index 64468c49791f..af601129f1bb 100644
> --- a/net/9p/Kconfig
> +++ b/net/9p/Kconfig
> @@ -15,6 +15,13 @@ menuconfig NET_9P
>  
>  if NET_9P
>  
> +config NET_9P_FD
> +	depends on VIRTIO

I think that's just a copypaste leftover from NET_9P_VIRTIO ?
Since it used to be code within NET_9P and it's within a if NET_9P it
shouldn't depend on anything.

Also for compatibility I'd suggest we keep it on by default at this
point, e.g. add 'default NET_9P' to this block:


diff --git a/net/9p/Kconfig b/net/9p/Kconfig
index af601129f1bb..deabbd376cb1 100644
--- a/net/9p/Kconfig
+++ b/net/9p/Kconfig
@@ -16,7 +16,7 @@ menuconfig NET_9P
 if NET_9P
 
 config NET_9P_FD
-       depends on VIRTIO
+       default NET_9P
        tristate "9P FD Transport"
        help
          This builds support for transports over TCP, Unix sockets and


I'll just fixup the commit with a word in the message unless you have a
problem with it, please let me know! :)

-- 
Dominique
