Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E60057FEA1
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 13:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234780AbiGYLvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 07:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiGYLvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 07:51:08 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1554B6397;
        Mon, 25 Jul 2022 04:51:06 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id C658EC025; Mon, 25 Jul 2022 13:51:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1658749864; bh=2NwYAYhbN3OZMacClbvfMK5THoNrkzTnbrqS2W8AjRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F1EkmJq7oYZxD1SPqVkTKFxKzaoBVjIcqhtmGe7FxqT1OeYVmlJu6UDKFhAS8++oo
         IL7dbF8QVzmCJQI0J1KP3n4xb78VDtmGMVtY5tOlagsjYAqKwo+Yd5/XDaXUU+ABUe
         LV0ci89kTM3tZchfBw01mF6oopK+1N9G0oq6eUdPlfuP/h7PPoJw4GLCwzr5gI3S7P
         qUH9jfcWNedEP/hWS80owdax9dsGJNTlpdsvll6kHdiUTdyDUHtSH79ZemOTU22F7p
         UWLUG4j5cLc81MuR5rYRe6ST3nCVulBLICrmrZaqwtezUUB5Qq4bzEF3DXJcFzCcr2
         aoVgcgLg3ZjMQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 2E204C009;
        Mon, 25 Jul 2022 13:50:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1658749863; bh=2NwYAYhbN3OZMacClbvfMK5THoNrkzTnbrqS2W8AjRM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=riikSf24Vi05i2t4TF/OsIT9+NyLICgFe3t+4yLNy64GtLjskwd9PET5eKskZCBzq
         t3BVRH68lt0s79gqe0qhoEjbSwd7Z58pZLikgA12Q8hJopHtHmb3DpvK+m5fxyZsKr
         dzY8o7EPr8/Sdg0KhyTKVpB0pvp/3Q3bUwhLnX9kwyO3d4Ge64xox68paqN+d3XwEU
         aDU0TVVHafhILld1a32Huhxs0GGtdYJ8FqS42cq4PeMEHa5CQ+yvNGQIC+AMGOsWIM
         fw/h/MJpcu4sV5kmE7xIPNdUOz+AzcsXe6TGlag+CeVr8i6xeHyblOTCxW2mZ3TBVH
         usjc4I1NdOrfg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 69b53e8f;
        Mon, 25 Jul 2022 11:50:53 +0000 (UTC)
Date:   Mon, 25 Jul 2022 20:50:38 +0900
From:   asmadeus@codewreck.org
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     syzbot <syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, davem@davemloft.net,
        edumazet@google.com, elver@google.com, ericvh@gmail.com,
        hdanton@sina.com, k.kahurani@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux_oss@crudebyte.com,
        lucho@ionkov.net, netdev@vger.kernel.org, pabeni@redhat.com,
        rientjes@google.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, v9fs-developer@lists.sourceforge.net
Subject: Re: [syzbot] WARNING in p9_client_destroy
Message-ID: <Yt6DjrMdIhpQmm7V@codewreck.org>
References: <000000000000e6917605e48ce2bf@google.com>
 <fb9febe5-00a6-61e9-a2d0-40982f9721a3@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fb9febe5-00a6-61e9-a2d0-40982f9721a3@suse.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vlastimil Babka wrote on Mon, Jul 25, 2022 at 12:15:24PM +0200:
> On 7/24/22 15:17, syzbot wrote:
> > syzbot has bisected this issue to:
> > 
> > commit 7302e91f39a81a9c2efcf4bc5749d18128366945
> > Author: Marco Elver <elver@google.com>
> > Date:   Fri Jan 14 22:03:58 2022 +0000
> > 
> >     mm/slab_common: use WARN() if cache still has objects on destroy
> 
> Just to state the obvious, bisection pointed to a commit that added the
> warning, but the reason for the warning would be that p9 is destroying a
> kmem_cache without freeing all the objects there first, and that would be
> true even before the commit.

Probably true from the moment that cache/idr was introduced... I've got
a couple of fixes in next but given syzcaller claims that's the tree it
was produced on I guess there can be more such leaks.
(well, the lines it sent in the backtrace yesterday don't match next,
but I wouldn't count on it)

If someone wants to have a look please feel free, I would bet the
problem is just that p9_fd_close() doesn't call or does something
equivalent to p9_conn_cancel() and there just are some requests that
haven't been sent yet when the mount is closed..
But I don't have/can/want to take the time to check right now as I
consider such a leak harmless enough, someone has to be root or
equivalent to do 9p mounts in most cases.

-- 
Dominique
