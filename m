Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26A034CEBD4
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 15:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiCFOIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 09:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiCFOH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 09:07:59 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC3440928;
        Sun,  6 Mar 2022 06:07:06 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v1-20020a17090a088100b001bf25f97c6eso4727105pjc.0;
        Sun, 06 Mar 2022 06:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ne/srXllW5XhA4je5FxIoFQvDEfC1aYr6Qjodnicalw=;
        b=Of21wL8noNb8+DiQW45qxkn3DvZuDRQ4knJNvDONsiJXsLfDWB7fuvXNrA62lKjrrQ
         X+a4mG7Re0rSfRy5w9HmQFSrt3Xp4xlWW9WPU0XvtMUYArwBQWBLz7rgHFXK1imf/KOv
         aMOiyuqIP6tXJ/vqjB1G6YTxHOOGPRRicUV3048ZJH9AA4leUiwgcVx6nOWz4F5qTefr
         yAIu/DKvVwwyApUEX9KN2jKdlifuYfbo1XQNkWCp8JIyWJbZaLwJY1gxw5mVWbFKloMh
         2zvRJnb0xIUIrtdCRhStv5IsOQ2YPqs43n1XVq20tPZtAUeNHHtjjE/UyLeAR1HjuJlq
         +I3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ne/srXllW5XhA4je5FxIoFQvDEfC1aYr6Qjodnicalw=;
        b=kdmESnY74GC6ZTO7nCnvAvZmhjjPyFffRpb9vh9Dz0UM7HA0orppmPnXHVQ4CYJh3z
         439cOjUS5BtAfDwKCUxdsKv+oBC7shi5F/blok/N0VqyQgNfukevnBE3dwiqTS4wMHJT
         DWzT7Hzm/Hkg/3ZzIDcPJSBsXg2T3M05CfiCK8gpkkZld7CnSfrUXdxPcwDi/okMqqja
         8CSUnB/Gry/maKbJ5fmIzwPcRQIpKej3PgtF/+VgC0f48CDZ8LBRRZgDmHycgbYa4e5d
         zk3wmKFZRaalhwLgGJ2xsoQJJg2V/PU6vtKdM171rIsP8en0kFdZ+7JVlqKWHxvhHKlp
         1wnA==
X-Gm-Message-State: AOAM530Wl/lD9bz2ybJqCkLV/wU1Q0gQ23xXkPpqK9YZXNtErZTFT5mp
        C90me2O9BmymWib15L/p/ok=
X-Google-Smtp-Source: ABdhPJxU1K2NBiGk9ibM3CEkcT5aNEp7zE82ixtszkyo4ESEXjpxTfn7bWoRgG5ED/ZqOhZHxsCpbw==
X-Received: by 2002:a17:902:e943:b0:14f:4a2b:203 with SMTP id b3-20020a170902e94300b0014f4a2b0203mr7859228pll.113.1646575625956;
        Sun, 06 Mar 2022 06:07:05 -0800 (PST)
Received: from localhost.localdomain ([115.195.172.162])
        by smtp.googlemail.com with ESMTPSA id j14-20020aa78dce000000b004f6db5478c3sm4807040pfr.131.2022.03.06.06.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Mar 2022 06:07:05 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, jakobkoschel@gmail.com,
        jannh@google.com, keescook@chromium.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable outside the loop
Date:   Sun,  6 Mar 2022 22:06:55 +0800
Message-Id: <20220306140655.19177-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
References: <CAHk-=wiacQM76xec=Hr7cLchVZ8Mo9VDHmXRJzJ_EX4sOsApEA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Mar 2022 16:35:36 -0800 Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Mar 5, 2022 at 1:09 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Now, I'd love for the list head entry itself to "declare the type",
> > and solve it that way. That would in many ways be the optimal
> > situation, in that when a structure has that
> >
> >         struct list_head xyz;
> >
> > entry, it would be lovely to declare *there* what the list entry type
> > is - and have 'list_for_each_entry()' just pick it up that way.
> >
> > It would be doable in theory - with some preprocessor trickery [...]
> 
> Ok, I decided to look at how that theory looks in real life.
> 
> The attached patch does actually work for me. I'm not saying this is
> *beautiful*, but I made the changes to kernel/exit.c to show how this
> can be used, and while the preprocessor tricks and the odd "unnamed
> union with a special member to give the target type" is all kinds of
> hacky, the actual use case code looks quite nice.
> 
> In particular, look at the "good case" list_for_each_entry() transformation:
> 
>    static int do_wait_thread(struct wait_opts *wo, struct task_struct *tsk)
>    {
>   -     struct task_struct *p;
>   -
>   -     list_for_each_entry(p, &tsk->children, sibling) {
>   +     list_traverse(p, &tsk->children, sibling) {
> 
> IOW, it avoided the need to declare 'p' entirely, and it avoids the
> need for a type, because the macro now *knows* the type of that
> 'tsk->children' list and picks it out automatically.
> 
> So 'list_traverse()' is basically a simplified version of
> 'list_for_each_entry()'.
>

Yes, brilliant! It is tricky and hacky. In your example: &tsk->children
will be expanded to &tsk->children_traversal_type.
And it also reduces column of the calling line with simplified version
of list_for_each_entry.

But, maybe there are some more cases the union-based way need to handle.
Such as, in your example, if the &HEAD passing to list_for_each_entry is
*not* "&tsk->children", but just a *naked head* with no any extra
information provoided:
void foo(...) {
    bar(&tsk->children);
}
noinline void bar(struct list_head *naked_head) {
    struct task_struct *p;
    list_for_each_entry(p, naked_head, sibling) {
    ...
    }
}
you should change all declares like "struct list_head" here with the union
one, but not only in the structure of task_struct itself.

I'm going to dig into this union-base way and re-send a patch if necessary.

> That patch also has - as another example - the "use outside the loop"
> case in mm_update_next_owner(). That is more of a "rewrite the loop
> cleanly using list_traverse() thing, but it's also quite simple and
> natural.
> 

Yes, the "c" is as the found entry for outside use -- it is natural.
And the "pos" as a inside-defined variable -- it is our goal.
And the "continue" trick to reduce 1 line -- it is nice.

> One nice part of this approach is that it allows for incremental changes.
> 
> In fact, the patch very much is meant to demonstrate exactly that:
> yes, it converts the uses in kernel/exit.c, but it does *not* convert
> the code in kernel/fork.c, which still does that old-style traversal:
> 
>                 list_for_each_entry(child, &parent->children, sibling) {
> 
> and the kernel/fork.c code continues to work as well as it ever did.
> 
> So that new 'list_traverse()' function allows for people to say "ok, I
> will now declare that list head with that list_traversal_head() macro,
> and then I can convert 'list_for_each_entry()' users one by one to
> this simpler syntax that also doesn't allow the list iterator to be
> used outside the list.
> 

Yes, i am very glad that you accepted and agreed my suggestion for the
*incremental changes* part, just like my "_inside" way used.
It means a lot for me to have your approval.

> What do people think? Is this clever and useful, or just too subtle
> and odd to exist?
> 
> NOTE! I decided to add that "name of the target head in the target
> type" to the list_traversal_head() macro, but it's not actually used
> as is. It's more of a wishful "maybe we could add some sanity checking
> of the target list entries later".
> 
> Comments?
> 
>                    Linus

--
Xiaomeng Tong
