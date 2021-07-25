Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DE43D4FFE
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 22:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbhGYUGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 16:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhGYUG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 16:06:28 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6EDC061757;
        Sun, 25 Jul 2021 13:46:58 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 62D1CC01C; Sun, 25 Jul 2021 22:46:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1627246015; bh=QaQ6Aa01LbwwJwJo87IE3khSh4fiPa3LSlb58ZOkRyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+9EsSd+WBEmMSGIDwDRz86So3Gf8FX8dhRyaiqijFRZ/pb003a44OWn0TMPyfYLC
         fKRVMhGZBxeLjQlTCrSoqnLOPnsKlAwCldIMTVb9ci8dkR5dOb26JgzmcqrrhEoOJy
         Kb9g7a92muDKK8fM8/zZPLpOQj0wT1oNytmCYMQOWzWrmxIDBXyaTPlNgqwqiRcarR
         PrOgKNGeDHXNYaN14DgBiIkT3iB4+ylGRYKaK0s+DZybLO/FxCedSKuFLJz5H5+ZVy
         E15AKRlzwBVvAGqO0VBnrtIaP4hdsI0n+WjpfS3aCrI7rp3SPQlvDZc014rPEQAcx6
         XcEzSsWfiudbQ==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 04DBDC009;
        Sun, 25 Jul 2021 22:46:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1627246014; bh=QaQ6Aa01LbwwJwJo87IE3khSh4fiPa3LSlb58ZOkRyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BxnBpI1X8oXWd/Z4QFGZN8MfSLtg8Sxp2UbTdthAj/tTLPt6ikzb81i9L2hWmgSe9
         NBV+5m8lcbfYy+t6Xq6H3dCN7LaRP0ywzk9F8zBt9+AFrAQmgY96PCDHNL1CtEivnb
         FxHXrRTY8RpOvp8cPivb2dm/GqRjO4DZxXm7rGRuk79xuIF9IstqOwc6zQuFH0C7rs
         w17WEUrgDNWLp8FE7CgJPVKIvOKoffYuEYUGKgU1NJgMaS/w5xzbDjqVM0eyea7wLf
         GHxZRGlaCqneFWwGpUQIX3L4T651OQM7Wy/ba7xdi0B4mRl3I1To4c/hd2Aj65c5qI
         0LFEqNY8kC/yg==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id e9881dc2;
        Sun, 25 Jul 2021 20:46:48 +0000 (UTC)
Date:   Mon, 26 Jul 2021 05:46:33 +0900
From:   asmadeus@codewreck.org
To:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p/xen: Fix end of loop tests for list_for_each_entry
Message-ID: <YP3NqQ5NGF7phCQh@codewreck.org>
References: <20210725175103.56731-1-harshvardhan.jha@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210725175103.56731-1-harshvardhan.jha@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Harshvardhan Jha wrote on Sun, Jul 25, 2021 at 11:21:03PM +0530:
> The list_for_each_entry() iterator, "priv" in this code, can never be
> NULL so the warning would never be printed.

hm? priv won't be NULL but priv->client won't be client, so it will
return -EINVAL alright in practice?

This does fix an invalid read after the list head, so there's a real
bug, but the commit message needs fixing.

> 
> Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>
> ---
> From static analysis.  Not tested.

+Stefano in To - I also can't test xen right now :/
This looks functional to me but if you have a bit of time to spare just
a mount test can't hurt.

> ---
>  net/9p/trans_xen.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
> index f4fea28e05da..3ec1a51a6944 100644
> --- a/net/9p/trans_xen.c
> +++ b/net/9p/trans_xen.c
> @@ -138,7 +138,7 @@ static bool p9_xen_write_todo(struct xen_9pfs_dataring *ring, RING_IDX size)
>  
>  static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
>  {
> -	struct xen_9pfs_front_priv *priv = NULL;
> +	struct xen_9pfs_front_priv *priv;
>  	RING_IDX cons, prod, masked_cons, masked_prod;
>  	unsigned long flags;
>  	u32 size = p9_req->tc.size;
> @@ -151,7 +151,7 @@ static int p9_xen_request(struct p9_client *client, struct p9_req_t *p9_req)
>  			break;
>  	}
>  	read_unlock(&xen_9pfs_lock);
> -	if (!priv || priv->client != client)
> +	if (list_entry_is_head(priv, &xen_9pfs_devs, list))
>  		return -EINVAL;
>  
>  	num = p9_req->tc.tag % priv->num_rings;
-- 
Dominique
