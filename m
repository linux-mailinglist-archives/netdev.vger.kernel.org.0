Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C0856CF42
	for <lists+netdev@lfdr.de>; Sun, 10 Jul 2022 15:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiGJNV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jul 2022 09:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJNV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jul 2022 09:21:57 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F316C12D11;
        Sun, 10 Jul 2022 06:21:55 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 96E72C020; Sun, 10 Jul 2022 15:21:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657459314; bh=K7azBUtXb9QlU6M/oC4wUt3g0LkVwhsHRxrJ+2emkdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z232gDRtgVmB7mdntIImDT8XecmC5DWbBht8xmM+5sieGswOW2apv+23TO3SpEwoL
         lF6UNsQUOZXblJ7O35XdNUrui73dXa1gJzqqLhSrK0gc9i3Q89lJaHnKi8iMxarlQi
         pPJJEQEO0dAuvUCbFXwXoHsOychQN4kScyxL8Yi2zFhtccDQoezs0dIKq7GVG7Ou0d
         mdp5a0axxBkvAAd/ma/vawl3Ob0x8P3hhQo4OlAutRYAS0rdFboXU675JeD34t52ik
         j7jmYyiGDSilJ45WbeuLviDMDXKnShcYgTxXt3gHRUcevaumW1EPyzkd+mAsAVRepa
         9Yq/ewqhroisA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 62F05C009;
        Sun, 10 Jul 2022 15:21:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657459313; bh=K7azBUtXb9QlU6M/oC4wUt3g0LkVwhsHRxrJ+2emkdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bBVfSBX5Y0e/dgd4JveWnVnEfSnQEuvDoO7g4aons8iVKMy+maaeBXSwAJX28HC7g
         YcKLDHiV62wpmBBGEYeG3fE3TDmY7sLiwt0S/jusqVC9wuP6jZ4HWK6pEWahs4UbIj
         0JueGl8zHouoFUaoJPyxEMd5YFBfBz1KpajRCuqNvD0sF3vHTwUg+yWL6FN9FWspyk
         RyGn33MP0LOYTV/2NJY149KCQMz5L9zsLHynCoXsYXShwho+XockesY2VOC7kXs49j
         /qxOO6vDsqu8BBb7h5ehClBVV91hU1dTvUk2dtwjKUdylAuAsNvp8LS7x/7hZrzpMl
         b2TZeuak+IktA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id f2fe1c83;
        Sun, 10 Jul 2022 13:21:48 +0000 (UTC)
Date:   Sun, 10 Jul 2022 22:21:33 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Tyler Hicks <tyhicks@linux.microsoft.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/9p: Initialize the iounit field during fid creation
Message-ID: <YsrSXdGYQdtdqp9E@codewreck.org>
References: <20220709200005.681861-1-tyhicks@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220709200005.681861-1-tyhicks@linux.microsoft.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tyler Hicks wrote on Sat, Jul 09, 2022 at 03:00:05PM -0500:
> Ensure that the fid's iounit field is set to zero when a new fid is
> created. Certain 9P operations, such as OPEN and CREATE, allow the
> server to reply with an iounit size which the client code assigns to the
> fid struct shortly after the fid is created in p9_fid_create(). Other
> operations that follow a call to p9_fid_create(), such as an XATTRWALK,
> don't include an iounit value in the reply message from the server. In
> the latter case, the iounit field remained uninitialized. Depending on
> allocation patterns, the iounit value could have been something
> reasonable that was carried over from previously freed fids or, in the
> worst case, could have been arbitrary values from non-fid related usages
> of the memory location.
> 
> The bug was detected in the Windows Subsystem for Linux 2 (WSL2) kernel
> after the uninitialized iounit field resulted in the typical sequence of
> two getxattr(2) syscalls, one to get the size of an xattr and another
> after allocating a sufficiently sized buffer to fit the xattr value, to
> hit an unexpected ERANGE error in the second call to getxattr(2). An
> uninitialized iounit field would sometimes force rsize to be smaller
> than the xattr value size in p9_client_read_once() and the 9P server in
> WSL refused to chunk up the READ on the attr_fid and, instead, returned
> ERANGE to the client. The virtfs server in QEMU seems happy to chunk up
> the READ and this problem goes undetected there. However, there are
> likely other non-xattr implications of this bug that could cause
> inefficient communication between the client and server.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Tyler Hicks <tyhicks@linux.microsoft.com>

Thanks for the fix!

> ---
> 
> Note that I haven't had a chance to identify when this bug was
> introduced so I don't yet have a proper Fixes tag. The history looked a
> little tricky to me but I'll have another look in the coming days. We
> started hitting this bug after trying to move from linux-5.10.y to
> linux-5.15.y but I didn't see any obvious changes between those two
> series. I'm not confident of this theory but perhaps the fid refcounting
> changes impacted the fid allocation patterns enough to uncover the
> latent bug?
> 
>  net/9p/client.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/9p/client.c b/net/9p/client.c
> index 8bba0d9cf975..1dfceb9154f7 100644
> --- a/net/9p/client.c
> +++ b/net/9p/client.c
> @@ -899,6 +899,7 @@ static struct p9_fid *p9_fid_create(struct p9_client *clnt)
>  	fid->clnt = clnt;
>  	fid->rdir = NULL;
>  	fid->fid = 0;
> +	fid->iounit = 0;

ugh, this isn't the first we've missed so I'll be tempted to agree with
Christophe -- let's make that a kzalloc and only set non-zero fields.

--
Dominique
