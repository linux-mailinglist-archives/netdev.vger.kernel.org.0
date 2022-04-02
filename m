Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96AED4F03C3
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 16:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiDBOH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 10:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiDBOHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 10:07:51 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C616FD6DD
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 07:05:59 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id A64FAC01F; Sat,  2 Apr 2022 16:05:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1648908357; bh=QF/L8ZAU7j5y7JRj5btGXMpteEczUHnHYv99nubh5rY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Su+bW2Ho+2oWf869XR121/a7/9kR+aroOIlfBGj6Ptyrw3MdLxXkZSfgjzHHBrYmo
         UWNPqzYiDq4mQSBzTo9VFUJ9UsE7e4I6Cj79+YZ0hRjLAdZETJmz1NoKrI1CTUPF8j
         yHzyPIOuUmD34DQkE6gTbpDQqof+wmyeBlNESZrI6kJXvMIN6DBJLOsMT3onHQUxGl
         itjN4atQiDOdZCeAOpeoshylfoqTSz6PlM6KmHzPnVdjTHxHi2UAQCcMcRYYPCdUCn
         avgpL75lImUK/iNBYwBka3t8KjNJ6JZhwKTDCtIjrr633I2mQPvT3rJMe3CHIl43G7
         FWawrLRdzs9pQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 9A39BC009;
        Sat,  2 Apr 2022 16:05:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1648908356; bh=QF/L8ZAU7j5y7JRj5btGXMpteEczUHnHYv99nubh5rY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p1+fZsSBMPo5YaUvR39ibrs5HezA1QFmBvNjfzOIIzFZEhuJGVz0wWtcc2+9BkY1O
         i11i1quPvXJKpjuiqMOZNYT3ZRlreMQaaGbLXJQ7VGpwbCWcHHja8+VBIeVaWir7bE
         hzwp+9lziS7wO2Og4ZGPe8bLkJozFHo9vmyoU/NQfGpztyA5ndM7BfLo8uRVWTwift
         xbBDBZ55WY5Pa7rYDZKsvL+nxn4S1D5ARXbus4jAk30Zy9Z8jnN7/RjPbWYk8pim+T
         DAuNkwRIhJo5NjegZ2AnC8TznPzzzqvz4LTbGRYcknbrnzvTJKdMyFzVvxZCz7dDWy
         qYaqJZIyBlVrw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 4655c428;
        Sat, 2 Apr 2022 14:05:51 +0000 (UTC)
Date:   Sat, 2 Apr 2022 23:05:36 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [PATCH v4 12/12] net/9p: allocate appropriate reduced message
 buffers
Message-ID: <YkhYMFf63qnEhDd0@codewreck.org>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
 <8c305df4646b65218978fc6474aa0f5f29b216a0.1640870037.git.linux_oss@crudebyte.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8c305df4646b65218978fc6474aa0f5f29b216a0.1640870037.git.linux_oss@crudebyte.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Thu, Dec 30, 2021 at 02:23:18PM +0100:
> So far 'msize' was simply used for all 9p message types, which is far
> too much and slowed down performance tremendously with large values
> for user configurable 'msize' option.
> 
> Let's stop this waste by using the new p9_msg_buf_size() function for
> allocating more appropriate, smaller buffers according to what is
> actually sent over the wire.

By the way, thinking of protocols earlier made me realize this won't
work on RDMA transport...

unlike virtio/tcp/xen, RDMA doesn't "mailbox" messages: there's a pool
of posted buffers, and once a message has been received it looks for the
header in the received message and associates it with the matching
request, but there's no guarantee a small message will use a small
buffer...

This is also going to need some thought, perhaps just copying small
buffers and recycling the buffer if a large one was used? but there
might be a window with no buffer available and I'm not sure what'd
happen, and don't have any RDMA hardware available to test this right
now so this will be fun.


I'm not shooting this down (it's definitely interesting), but we might
need to make it optional until someone with RDMA hardware can validate a
solution.
-- 
Dominique
