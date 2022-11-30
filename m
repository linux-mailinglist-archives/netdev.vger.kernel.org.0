Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E734B63D3F3
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiK3LHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbiK3LG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:06:59 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF9774A94;
        Wed, 30 Nov 2022 03:06:55 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 8C8A0C009; Wed, 30 Nov 2022 12:07:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669806422; bh=xf0zVpTlYde/bxu53jwBvwyrnmZDM6MyGXUmXHAVDU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mkfutD8yjATXqvMQIyS7YBDYJmrXAdQjSMkXquGYbIoZG9B8/HTz2olo5SB2grcd+
         WjjS0eHAT5nKpXOVZWj7VGdUfFymmFwRaiiDsTuhdoIIBeGTGX6TFcZBMq1F3UkfwC
         rw8X4X3EJ8Zd1XJ/mdpUFjtzEqdAXcEZjRpUo7fRp5bOL10j/Id5F/F+pFYWtS9acw
         3fWK61cf6aBauQH6Kl0fjIeP3vQhI3Rh1eq+SWPqTFSjNJpCt+0jMqONDOCzT3Yion
         YcPZmEEf8fjbLGOo6U5wILZEL7qCGj/eYwXyKcOXaOl/5kZSkAH8TCS8YOTUB8NigK
         Q2/Qdhi7SWOkA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id D3CBDC009;
        Wed, 30 Nov 2022 12:06:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1669806421; bh=xf0zVpTlYde/bxu53jwBvwyrnmZDM6MyGXUmXHAVDU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XhnFZc69CTBcQak7ujtOYC4fe3atj0S2rJqHvTI9blyQpo9/jCW0a+BCfH+FBp5+G
         a6SoU2byYmEuDkUD4fIzA+PaLxa8WvOJXCGx+G+1YgsqnUVl6LaWFQD/bhLBXEN/01
         6BY0BLVnP5muceuLbihVp95115ad7Zfc3llOHcuxT0MeF7bfBD3OWLEFntJXJ8pxXu
         DXjGmVdyAR8szwe9acx88ld+FfjSYB7urx7G/nPY3e1vTluGINzhy189/YEdnf7zgu
         jddY5LOFZGnvquZIwwOrv4CgiyCJtOVvU/EJlLeUPCn5Ydv92S7I+ZC4OiM+sit4dO
         LnMKzK5MlHYmA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 81d189f2;
        Wed, 30 Nov 2022 11:06:46 +0000 (UTC)
Date:   Wed, 30 Nov 2022 20:06:31 +0900
From:   asmadeus@codewreck.org
To:     Schspa Shi <schspa@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Message-ID: <Y4c5N/SAuszTLiEA@codewreck.org>
References: <20221129162251.90790-1-schspa@gmail.com>
 <Y4aJzjlkkt5VKy0G@codewreck.org>
 <m2r0xli1mq.fsf@gmail.com>
 <Y4b1MQaEsPRK+3lF@codewreck.org>
 <m2o7sowzas.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m2o7sowzas.fsf@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Schspa Shi wrote on Wed, Nov 30, 2022 at 04:14:32PM +0800:
> >  - reqs are alloced in a kmem_cache created with SLAB_TYPESAFE_BY_RCU.
> >  This means that if we get a req from idr_find, even if it has just been
> >  freed, it either is still in the state it was freed at (hence refcount
> >  0, we ignore it) or is another req coming from the same cache (if
> 
> If the req was newly alloced(It was at a new page), refcount maybe not
> 0, there will be problem in this case. It seems we can't relay on this.
> 
> We need to set the refcount to zero before add it to idr in p9_tag_alloc.

Hmm, if it's reused then it's zero by definition, but if it's a new
allocation (uninitialized) then anything goes; that lookup could find
and increase it before the refcount_set, and we'd have an off by one
leading to use after free. Good catch!

Initializing it to zero will lead to the client busy-looping until after
the refcount is properly set, which should work.
Setting refcount early might have us use an re-used req before the tag
has been changed so that one cannot move.

Could you test with just that changed if syzbot still reproduces this
bug? (perhaps add a comment if you send this)

------
diff --git a/net/9p/client.c b/net/9p/client.c
index aaa37b07e30a..aa64724f6a69 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -297,6 +297,7 @@ p9_tag_alloc(struct p9_client *c, int8_t type, uint t_size, uint r_size,
 	p9pdu_reset(&req->rc);
 	req->t_err = 0;
 	req->status = REQ_STATUS_ALLOC;
+	refcount_set(&req->refcount, 0);
 	init_waitqueue_head(&req->wq);
 	INIT_LIST_HEAD(&req->req_list);

----- 

> >  refcount isn't zero, we can check its tag)
> 
> As for the release case, the next request will have the same tag with
> high probability. It's better to make the tag value to be an increase
> sequence, thus will avoid very much possible req reuse.

I'd love to be able to do this, but it would break some servers that
assume tags are small (e.g. using it as an index for a tag array)
... I thought nfs-ganesha was doing this but they properly put in in
buckets, so that's one less server to worry about, but I wouldn't put
it past some simple servers to do that; having a way to lookup a given
tag for flush is an implementation requirement.

That shouldn't be a problem though as that will just lead to either fail
the guard check after lookup (m->rreq->status != REQ_STATUS_SENT) or be
processed as a normal reply if it's already been sent by the other
thread at this point.
OTOH, that m->rreq->status isn't protected by m->req_lock in trans_fd,
and that is probably another bug...

-- 
Dominique
