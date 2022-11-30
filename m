Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB22E63CDA4
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 04:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiK3DEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 22:04:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiK3DEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 22:04:40 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61852AC58;
        Tue, 29 Nov 2022 19:04:39 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id b2so11494957iof.12;
        Tue, 29 Nov 2022 19:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=7XROP14rJYXzTuiWyk83t4xQBYY/HpEJYx05llAt13k=;
        b=cyY9BuXbzMD69BfeS2Dd6RN3Ry7Gv3A77tITGI6/lP9cguoyqH5AfI5WHC6RCheoBA
         +iD7K6IYuBwxKQiHSZeA0uEf7L6Jyd8w/S1coBbXGeKWV2fMDH35mZutTa+wMrA/uQXm
         jQ/Rxzw8W2JLQ+vE0XOy/MPvONypUsx56jgwoNYVzwV7K41ovOHCTiflRG0MQekiHbER
         ICDDd+WD6psqGVUqiGVuSNmU6LNzd2S5mD0dBSGC7Ag5medYm/G5GAJjcvyh8VtzlmDf
         WFA773NstUiaK0N47tzS4dYOWuyvOBDqORhJQtQpzGmZKJKeWLZgeEPgBQYPCAPev0tY
         /rTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XROP14rJYXzTuiWyk83t4xQBYY/HpEJYx05llAt13k=;
        b=cBST4Ueu8q9OjnstgZTMB5VIijVGv4QNpBDNc+q5NUW0gEVnt5FhQINNudOhdO83mp
         W+2OVgdDB1ur085aug3P6bhR3j7GSofn0KZYMBSGmpjYTd5/ZtaMOsBED3ZCteM/wqgd
         lcOY5mKukQSplptEzSAXgUHdQxnFJkBPo3p+XKqhqionyxsgWXoXle+If4KU4Oda5dDR
         z9dOka74qe2m9Yw/G2xBnl6WBsLC0juCkx/fdY9QQ6R/AiwenfTIcsw9/9Tr+nqm51pb
         imfbrwSKSWesHGRmTbnOuSy02wT66/e7E5r4wV5mxWY+oPfo4aGIyzGRW6X6FN1NTLX/
         X5fg==
X-Gm-Message-State: ANoB5pnTwl8bg21Xlu0QLB3f+QrlOiNvkOJMc9TcjicT7N4GVCpKocOc
        gMh4qYIBx82djWWfA05XLCK8F2p0wMm1vw==
X-Google-Smtp-Source: AA0mqf6oQ4P/klApsV6gYwa958mnSWHwAtPDRcf0GPh9AmhZNKq9TfbKoldVGzyn1LQdcWLyWFEJ3w==
X-Received: by 2002:a02:2710:0:b0:36c:c1d4:d3e0 with SMTP id g16-20020a022710000000b0036cc1d4d3e0mr28505285jaa.181.1669777479139;
        Tue, 29 Nov 2022 19:04:39 -0800 (PST)
Received: from MBP (ec2-18-117-95-84.us-east-2.compute.amazonaws.com. [18.117.95.84])
        by smtp.gmail.com with ESMTPSA id l66-20020a6b3e45000000b006dfbf3fe79dsm114587ioa.32.2022.11.29.19.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 19:04:38 -0800 (PST)
References: <20221129162251.90790-1-schspa@gmail.com>
 <Y4aJzjlkkt5VKy0G@codewreck.org>
User-agent: mu4e 1.8.10; emacs 28.2
From:   Schspa Shi <schspa@gmail.com>
To:     asmadeus@codewreck.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.co,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+8f1060e2aaf8ca55220b@syzkaller.appspotmail.com
Subject: Re: [PATCH] 9p: fix crash when transaction killed
Date:   Wed, 30 Nov 2022 10:22:44 +0800
In-reply-to: <Y4aJzjlkkt5VKy0G@codewreck.org>
Message-ID: <m2r0xli1mq.fsf@gmail.com>
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

> Schspa Shi wrote on Wed, Nov 30, 2022 at 12:22:51AM +0800:
>> The transport layer of fs does not fully support the cancel request.
>> When the request is in the REQ_STATUS_SENT state, p9_fd_cancelled
>> will forcibly delete the request, and at this time p9_[read/write]_work
>> may continue to use the request. Therefore, it causes UAF .
>> 
>> There is the logs from syzbot.
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
>> complicated than this one, but the root cause seems to be the same.
>> 
>>      T21124               p9_write_work        p9 read_work
>> ======================== first trans =================================
>> p9_client_walk
>>   p9_client_rpc
>>     p9_client_prepare_req
>>     /* req->refcount == 2 */
>>     c->trans_mod->request(c, req);
>>       p9_fd_request
>>         req move to unsent_req_list
>>                             req->status = REQ_STATUS_SENT;
>>                             req move to req_list
>>                             << send to server >>
>>     wait_event_killable
>>     << get kill signal >>
>>     if (c->trans_mod->cancel(c, req))
>>        p9_client_flush(c, req);
>>          /* send flush request */
>>          req = p9_client_rpc(c, P9_TFLUSH, "w", oldtag);
>> 		 if (c->trans_mod->cancelled)
>>             c->trans_mod->cancelled(c, oldreq);
>>               /* old req was deleted from req_list */
>>               /* req->refcount == 1 */
>>   p9_req_put
>>     /* req->refcount == 0 */
>>     << preempted >>
>>                                        << get response, UAF here >>
>>                                        m->rreq = p9_tag_lookup(m->client, m->rc.tag);
>>                                          /* req->refcount == 1 */
>>                                        << do response >>
>>                                        p9_client_cb(m->client, m->rreq, REQ_STATUS_RCVD);
>>                                          /* req->refcount == 0 */
>>                                          p9_fcall_fini
>>                                          /* request have been freed */
>>     p9_fcall_fini
>>      /* double free */
>>                                        p9_req_put(m->client, m->rreq);
>>                                          /* req->refcount == 1 */
>> 
>> To fix it, we can wait the request with status REQ_STATUS_SENT returned.
>
> Christian replied on this (we cannot wait) but I agree with him -- the

Yes, this is where I worry about too, this wait maybe cause a deadlock.

> scenario you describe is proteced by p9_tag_lookup checking for refcount
> with refcount_inc_not_zero (p9_req_try_get).

Thanks for pointing out the zero value check here, the scene in the
commit message does not hold.

>
> The normal scenarii for flush are as follow:
>  - cancel before request is sent: no flush, just free
>  - flush is ignored and reply comes first: we get reply from original
> request then reply from flush
>  - flush is handled and reply never comes: we only get reply from flush
>
> Protocol-wise, we can safely reuse the tag after the flush reply got
> received; and as far as I can follow the code we only ever free the tag
> (last p9_call_fini) after flush has returned so the entry should be
> protected.
>
> If we receive a response on the given tag between cancelled and the main
> thread going out the request has been marked as FLSHD and should be
> ignored. . . here is one p9_req_put in p9_read_work() in this case but
> it corresponds to the ref obtained by p9_tag_lookup() so it should be
> valid.
>
>
> I'm happy to believe we have a race somewhere (even if no sane server
> would produce it), but right now I don't see it looking at the code.. :/

And I think there is a race too. because the syzbot report about 9p fs
memory corruption multi times.

As for the problem, the p9_tag_lookup only takes the rcu_read_lock when
accessing the IDR, why it doesn't take the p9_client->lock? Maybe the
root cause is that a lock is missing here.

-- 
BRs
Schspa Shi
