Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4842A641D83
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 15:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiLDOjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 09:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbiLDOi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 09:38:58 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E0BBE1D;
        Sun,  4 Dec 2022 06:38:55 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id c7so5705645pfc.12;
        Sun, 04 Dec 2022 06:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=61e5Of6HplrZC23fyHjHCQZlLVAB85wBc+j9pwB502M=;
        b=lxuSTXquHU/xTvRwvkdhDESHLUtf/bfs1iV3b5EpmPPzzALKb1oc1X/8XFf1rVbcrm
         5F/s+ixiv6an+GUk7H9ktzQz+2jkiieJmOx7/hj224/J2aJu2oCQVWSaDb4WLQhlgmCm
         dT1yvz5o9RGgEiJcxhenjdQpuVIu6ojhmaHu3cO8LZjcgYibFqXOiurzsqEW6L9Yf6w4
         XnVWL26cKhu0Fuco/TSC4XJOPhn5Hxor6fC07SIePXse1t5Qx+K7c8kKr3tAljwU1hpE
         LYPAubWCEvCbTQ3CRK4i9xU47IUR8OTHOkiEQbn9tc6c2/9NrRHB7gT9BK6FMvMgmbYq
         d82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61e5Of6HplrZC23fyHjHCQZlLVAB85wBc+j9pwB502M=;
        b=sldvBbOr/rvBC9WmOek7JIUNyCotMBeUb9QG0KneAX7hybDmBahfNNGbMpDg7WMAUf
         5M5FQE6QlvC/kC8dfrRgx4XtKtjHPIaCZBqIg/Td1si/RzmH5Z8MF6gdY9Q9gbgk8ZAP
         O1kaRWbFED0clG8Zp8dJJUYA5CVC8NDv+RIKPciaCLySVi6Wpr0ZBZ9VXYCGO9V48FYQ
         qpK0pfVyDrfKkJpPnGusncgzz8PIA0QSNKYLfdr+jH2uVjcEF/ZG0KfJ5uw3JQ0QzYLo
         hiE28mZrTLl8OcwLkJZC9Hq/jGI7//5pXs3FI9MKNWv9Du4tanjM9+kfHjtV3Jh9MOWC
         n4HQ==
X-Gm-Message-State: ANoB5pndniizzZ+v/xysPX6J+Gcvi/L6yQ1AXMHjy3516dfBKHNo99yu
        y+Pc6fCaDOQcfGOdlMCDnT8=
X-Google-Smtp-Source: AA0mqf60gFImrC47mMKRxryqhaP/EYvz2fKAjGesm2fe98CPJTY26516zkLJNHx85RC2KrGVefdp/Q==
X-Received: by 2002:a05:6a00:3398:b0:575:72f3:d4dc with SMTP id cm24-20020a056a00339800b0057572f3d4dcmr26986997pfb.6.1670164735130;
        Sun, 04 Dec 2022 06:38:55 -0800 (PST)
Received: from ArchLinux (ec2-18-117-95-84.us-east-2.compute.amazonaws.com. [18.117.95.84])
        by smtp.gmail.com with ESMTPSA id l5-20020a170903244500b00176b3c9693esm8870730pls.299.2022.12.04.06.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 06:38:53 -0800 (PST)
References: <4759293.MmlG3nAkEO@silver>
 <20221201033310.18589-1-schspa@gmail.com> <Y4oSQU4taHVQ0n2j@codewreck.org>
User-agent: mu4e 1.7.5; emacs 28.2
From:   Schspa Shi <schspa@gmail.com>
To:     asmadeus@codewreck.org
Cc:     Christian Schoenebeck <linux_oss@crudebyte.com>, ericvh@gmail.com,
        lucho@ionkov.net, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] 9p/fd: set req refcount to zero to avoid
 uninitialized usage
Date:   Sun, 04 Dec 2022 22:35:41 +0800
In-reply-to: <Y4oSQU4taHVQ0n2j@codewreck.org>
Message-ID: <m2tu2b5j4g.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


asmadeus@codewreck.org writes:

> Schspa Shi wrote on Thu, Dec 01, 2022 at 11:33:10AM +0800:
>> When the new request allocated, the refcount will be zero if it is resued
>> one. But if the request is newly allocated from slab, it is not fully
>> initialized before add it to idr.
>> 
>> If the p9_read_work got a response before the refcount initiated. It will
>> use a uninitialized req, which will result in a bad request data struct.
>> 
>> Here is the logs from syzbot.
>> 
>> Corrupted memory at 0xffff88807eade00b [ 0xff 0x07 0x00 0x00 0x00 0x00
>> 0x00 0x00 . . . . . . . . ] (in kfence-#110):
>>  p9_fcall_fini net/9p/client.c:248 [inline]
>>  p9_req_put net/9p/client.c:396 [inline]
>>  p9_req_put+0x208/0x250 net/9p/client.c:390
>>  p9_client_walk+0x247/0x540 net/9p/client.c:1165
>>  clone_fid fs/9p/fid.h:21 [inline]
>>  v9fs_fid_xattr_set+0xe4/0x2b0 fs/9p/xattr.c:118
>>  v9fs_xattr_set fs/9p/xattr.c:100 [inline]
>>  v9fs_xattr_handler_set+0x6f/0x120 fs/9p/xattr.c:159
>>  __vfs_setxattr+0x119/0x180 fs/xattr.c:182
>>  __vfs_setxattr_noperm+0x129/0x5f0 fs/xattr.c:216
>>  __vfs_setxattr_locked+0x1d3/0x260 fs/xattr.c:277
>>  vfs_setxattr+0x143/0x340 fs/xattr.c:309
>>  setxattr+0x146/0x160 fs/xattr.c:617
>>  path_setxattr+0x197/0x1c0 fs/xattr.c:636
>>  __do_sys_setxattr fs/xattr.c:652 [inline]
>>  __se_sys_setxattr fs/xattr.c:648 [inline]
>>  __ia32_sys_setxattr+0xc0/0x160 fs/xattr.c:648
>>  do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
>>  __do_fast_syscall_32+0x65/0xf0 arch/x86/entry/common.c:178
>>  do_fast_syscall_32+0x33/0x70 arch/x86/entry/common.c:203
>>  entry_SYSENTER_compat_after_hwframe+0x70/0x82
>> 
>> Below is a similar scenario, the scenario in the syzbot log looks more
>> complicated than this one, but this patch can fix it.
>> 
>>      T21124                   p9_read_work
>> ======================== second trans =================================
>> p9_client_walk
>>   p9_client_rpc
>>     p9_client_prepare_req
>>       p9_tag_alloc
>>         req = kmem_cache_alloc(p9_req_cache, GFP_NOFS);
>>         tag = idr_alloc
>>         << preempted >>
>>         req->tc.tag = tag;
>>                             /* req->[refcount/tag] == uninitialized */
>>                             m->rreq = p9_tag_lookup(m->client, m->rc.tag);
>>                               /* increments uninitalized refcount */
>> 
>>         refcount_set(&req->refcount, 2);
>>                             /* cb drops one ref */
>>                             p9_client_cb(req)
>>                             /* reader thread drops its ref:
>>                                request is incorrectly freed */
>>                             p9_req_put(req)
>>     /* use after free and ref underflow */
>>     p9_req_put(req)
>> 
>> To fix it, we can initize the refcount to zero before add to idr.
>
> (fixed initialize typo here)
>
>> Reported-by: syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
>> Signed-off-by: Schspa Shi <schspa@gmail.com>
>> 
>> --
>> 
>> Changelog:
>> v1 -> v2:
>>         - Set refcount to fix the problem.
>> v2 -> v3:
>>         - Comment messages improve as asmadeus suggested.
>
> Just a note: when applying a patch with git am, this goes into the
> commit message -- please include the changelog below the git's three
> dashes instead (anything between the three dashes and the 'diff --git'
> below:

Thanks for the reminder, I will pay attention to this next time.

>> ---
>>  net/9p/client.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>> 
>> diff --git a/net/9p/client.c b/net/9p/client.c
>
>
> Christian Schoenebeck wrote on Fri, Dec 02, 2022 at 12:48:39PM +0100:
>> > +	/* refcount needs to be set to 0 before inserting into the idr
>> > +	 * so p9_tag_lookup does not accept a request that is not fully
>> > +	 * initialized. refcount_set to 2 below will mark request live.
>> > +	 */
>> > +	refcount_set(&req->refcount, 0);
>> 
>> I would s/live/ready for being used/, but comment should be clear enough
>> anyway.
>
> I blame golfing to fit into three lines, sorry!
> Since it was my suggestion, I've taken the liberty to change 'live' to
> 'ready' as an half step; I think it's clearer than live and probably
> understandable enough.
>
> I've pushed this to my next branch and will submit to Linus for the
> merge window in a couple of weeks, no point in rushing this to stable
> unless it gets snatched through the net tree first...

Thanks.

-- 
BRs
Schspa Shi
