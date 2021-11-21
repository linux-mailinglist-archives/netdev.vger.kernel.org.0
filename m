Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDCB04586B3
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 23:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhKUWPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 17:15:43 -0500
Received: from nautica.notk.org ([91.121.71.147]:48296 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhKUWPn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 17:15:43 -0500
Received: by nautica.notk.org (Postfix, from userid 108)
        id 606A9C01F; Sun, 21 Nov 2021 23:12:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1637532756; bh=Mbbq3vFIAl7yR7LhCVUJnt49ZvRT4nRHvt1yrfOvVuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y59cniNi01yboaBY01UCKnQHA8BRDLhn+ynh9LorIrC65FyEa4N2MTFmeq/emdo8q
         1na7PfwJw/+kk7JEPR41Qsi1XhVOuOLCoQEa0NM6UBfo2HM3hzMQ52yCm1vZzDgZQW
         rdcmWHPG4xZ8+6iGRlz9wyESr2dffO098mayFb7MH05bYxtSO/DGttGZsJrlRW5F32
         DlX+6CLjzVbRc4qXD2OavdQ1eHkTLXql4mN5oyBCdEcFFTMzd+iUvY9pTaJ9EMvWrl
         +GZ7XFiD23sKQfBUHK5JKNBOvq1dEaIuTBaY/isGFyJwmGlaE5mP2LcbwXrryBozTi
         xhho/ojBoasEw==
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on nautica.notk.org
X-Spam-Level: 
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=unavailable version=3.3.2
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 50402C009;
        Sun, 21 Nov 2021 23:12:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1637532755; bh=Mbbq3vFIAl7yR7LhCVUJnt49ZvRT4nRHvt1yrfOvVuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ISNbCRcA04xWfy17NSUUeMIQTQcXaaU9jdDrZJNBcz0Rh8CMe1quzYfL+zEk3s3M7
         oFUxFhF/hi+2hWPfcXFThsv7Du6yQl5yo3EG1cOkKuFqqNT7V0+6R1P5vXQVc6qOTD
         9EP3ORrj1ckAD74E/RHJFohGb4mHKI/zg6EfG24mFraifX51HfE50/o+xwOA0FBEhB
         Id7oN4wctWyhHuI8jHbe0+9OcWS9XxaADyXZFA2p3ZKwGFskhs+iHLyOxO6nNwqm3O
         GV0PlyXixudpYrtihQliaBqxW4NNcPJsyw92V+74RIWOP9C0NUDkBxm3GKW5XAtbG3
         Jfb25Y6kkEeZQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id d89f5d3a;
        Sun, 21 Nov 2021 22:12:29 +0000 (UTC)
Date:   Mon, 22 Nov 2021 07:12:14 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Nikolay Kichukov <nikolay@oldum.net>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 6/7] 9p/trans_virtio: support larger msize values
Message-ID: <YZrEPj9WLx36Pm3k@codewreck.org>
References: <YZl+eD6r0iIGzS43@codewreck.org>
 <4244024.q9Xco3kuGk@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4244024.q9Xco3kuGk@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Sun, Nov 21, 2021 at 05:57:30PM +0100:
> > Although frankly as I said if we're going to do this, we actual can
> > majorate the actual max for all operations pretty easily thanks to the
> > count parameter -- I guess it's a bit more work but we can put arbitrary
> > values (e.g. 8k for all the small stuff) instead of trying to figure it
> > out more precisely; I'd just like the code path to be able to do it so
> > we only do that rechurn once.
> 
> Looks like we had a similar idea on this. My plan was something like this:
> 
> static int max_msg_size(enum msg_type) {
>     switch (msg_type) {
>         /* large zero copy messages */
>         case Twrite:
>         case Tread:
>         case Treaddir:
>             BUG_ON(true);
> 
>         /* small messages */
>         case Tversion:
>         ....
>             return 8k; /* to be replaced with appropriate max value */
>     }
> }
> 
> That would be a quick start and allow to fine grade in future. It would also 
> provide a safety net, e.g. the compiler would bark if a new message type is 
> added in future.

I assume that'd only be used if the caller does not set an explicit
limit, at which point we're basically using a constant and the function
coud be replaced by a P9_SMALL_MSG_SIZE constant... But yes, I agree
with the idea, it's these three calls that deal with big buffers in
either emission or reception (might as well not allocate a 128MB send
buffer for Tread ;))

If you have a Plan for it I'll let you continue and review as things
come. Thanks a lot for the work!

-- 
Dominique
