Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6D3232A32B
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382023AbhCBIsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:48:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835223AbhCBEvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 23:51:03 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C081C061756;
        Mon,  1 Mar 2021 20:41:43 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id D0AE2C020; Tue,  2 Mar 2021 05:38:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1614659909; bh=fzTNoIzBbHR31iQXUPSLVB0C2nz82W+Ep7+3M20aQOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m/0eGE9M4O/xg+5IVrbVCVUg9axHbEh6li08QUJ5XKQo0JAMws92pVSZAPIAwzedo
         hauWxgPPtvst6YsRMtRP6YB5gtk1pmGqLMrjlyuFBmwvBMhk+Z74VaUGIAVil+PClX
         LKfLe0RfsmZEtlR9K0Jfba9sb8gSPVc6TMBbSk71NRcJeVF8ThUiaJzgw5U4usXgov
         FklMHFa0iKVGmsAxE1P2bj8EzazFVvl4t50qreA/ZEUIEyaga30Xw6CgAIIgekcHSk
         bOByPK2u3W73aeHrTs1F0pG5bG3+7Ho2dK6uWDIfuxumAlVdKFXGU6jJxKR1gDxfnT
         YUhKFRlrsZ7/A==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id AAE49C01B;
        Tue,  2 Mar 2021 05:38:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1614659909; bh=fzTNoIzBbHR31iQXUPSLVB0C2nz82W+Ep7+3M20aQOg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m/0eGE9M4O/xg+5IVrbVCVUg9axHbEh6li08QUJ5XKQo0JAMws92pVSZAPIAwzedo
         hauWxgPPtvst6YsRMtRP6YB5gtk1pmGqLMrjlyuFBmwvBMhk+Z74VaUGIAVil+PClX
         LKfLe0RfsmZEtlR9K0Jfba9sb8gSPVc6TMBbSk71NRcJeVF8ThUiaJzgw5U4usXgov
         FklMHFa0iKVGmsAxE1P2bj8EzazFVvl4t50qreA/ZEUIEyaga30Xw6CgAIIgekcHSk
         bOByPK2u3W73aeHrTs1F0pG5bG3+7Ho2dK6uWDIfuxumAlVdKFXGU6jJxKR1gDxfnT
         YUhKFRlrsZ7/A==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 7ce2726f;
        Tue, 2 Mar 2021 04:38:23 +0000 (UTC)
Date:   Tue, 2 Mar 2021 13:38:08 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 9p: free what was emitted when read count is 0
Message-ID: <YD3BMLuZXIcETtzp@codewreck.org>
References: <20210301103336.2e29da13@xhacker.debian>
 <YDxWrB8AoxJOmScE@odin>
 <20210301110157.19d9ad4e@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210301110157.19d9ad4e@xhacker.debian>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jisheng Zhang wrote on Mon, Mar 01, 2021 at 11:01:57AM +0800:
> Per my understanding of iov_iter, we need to call iov_iter_advance()
> even when the read out count is 0. I believe we can see this common style
> in other fs.

I'm not sure where you see this style, but I don't see exceptions for
0-sized read not advancing the iov in general, and I guess this makes
sense.


Rather than make an exception for 0, how about just removing the if as
follow ?

I've checked that the non_zc case (copy_to_iter with 0 size) also works
to the same effect, so I'm not sure why the check got added in the
first place... But then again this is old code so maybe the semantics
changed since 2015.


----
diff --git a/net/9p/client.c b/net/9p/client.c
index 4f62f299da0c..0a0039255c5b 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1623,11 +1623,6 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
        }

        p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
-       if (!count) {
-               p9_tag_remove(clnt, req);
-               return 0;
-       }
-
        if (non_zc) {
                int n = copy_to_iter(dataptr, count, to);


----

If you're ok with that, would you mind resending that way?

I'd also want the commit message to be reworded a bit, at least the
first line (summary) doesn't make sense right now: I have no idea
what you mean by "free what was emitted".
Just "9p: advance iov on empty read" or something similar would do.


> > cat version? coreutils' doesn't seem to do that on their git)
> 
> busybox cat

Ok, could reproduce with busybox cat, thanks.
As expected I can't reproduce with older kernels so will run a bisect
for the sake of it as time allows

-- 
Dominique
