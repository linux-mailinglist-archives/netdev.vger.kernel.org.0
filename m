Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905F864A4A2
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 17:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiLLQPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 11:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbiLLQPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 11:15:20 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F2C1262E;
        Mon, 12 Dec 2022 08:15:19 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id q17-20020a17090aa01100b002194cba32e9so339444pjp.1;
        Mon, 12 Dec 2022 08:15:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HS57fphfFTIlMzwugZ21RzL6OQ71Fiy4HloGefZfE88=;
        b=PqssKBggY+VkFwF/yUyJov7nLggm1wBUnLrq6/DIltCxHAhU63PNf1/q6m5OQ01sy+
         /4ueqZ1GXg8mUoxDQjbCiyXhH3HusdMI/8CcdohKk5UVChLAwErMEBPqOHu7lGz7LHDF
         e609s/byD/3BH0ARoEYeWpoKLf9Gx+JEWx4MP+4RMZcVMSYBgYBQ00XfJkMePwm6KWgn
         eDG7UIGWQKTj685W18OvYYOXJWekX5oP83AmI+4IIFNNDUb+plrwCyoEtQSvn6ye6JrE
         cC6agR/FQLZ9/Bk5YzSjJqTQNv+BhS+p4sTXsN5LFxnsszM8RGI9LyfZK8OYGlhLt5CB
         YbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HS57fphfFTIlMzwugZ21RzL6OQ71Fiy4HloGefZfE88=;
        b=XL2BxKJ+E/sJB7HvgdI5ChJwDDrVaYZSey4fOxuQ2SUe+AYlsx9hwhfXIv+1Ev0/uP
         TE6dzIBkyQVk16a65Y2ty6UmsghhXsKILmLyc+Ub0Rv87/8zGODtorw9b2P4TfyiYb45
         Uh8eMMg6kEEiNCJ6k84E5XDZ7/CPR79viQdn1KBqWDzwVT7hbaKQJOzgKf/r5U1M7/Xd
         SeZzytolBpiTVFHj+FDh01QB+xEycIP6lDRJan9LYbbVnrZIQfRTGmCGBS4uF95vBzoK
         hBb02EfhtA73LixqC9rSN32JY2SvdW09JW7B75Kt7G9PcWr3qEQv+LkF+xrX7oU/5Z8+
         Qllw==
X-Gm-Message-State: ANoB5pnX6CNQHbKitlIRtIQVNecKcCBeJN6RWP2LEV+B9ZoC03Mot4Kv
        UY2rNlXqSwBpaOd/zjmhsPk=
X-Google-Smtp-Source: AA0mqf5uMvp0937uVwVDwegtQ/2ptKx8MdHduS5AA3tUNPLVj6h9At9b0V4aHGCCiXR3sZqdP1i8CQ==
X-Received: by 2002:a05:6a20:8b27:b0:ad:a09c:5734 with SMTP id l39-20020a056a208b2700b000ada09c5734mr3944892pzh.44.1670861719391;
        Mon, 12 Dec 2022 08:15:19 -0800 (PST)
Received: from localhost ([1.83.247.150])
        by smtp.gmail.com with ESMTPSA id w13-20020aa79a0d000000b0057709fd0fccsm5991989pfj.153.2022.12.12.08.15.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 08:15:18 -0800 (PST)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     xiyou.wangcong@gmail.com
Cc:     18801353760@163.com, cong.wang@bytedance.com, davem@davemloft.net,
        dvyukov@google.com, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH v3] net: sched: fix memory leak in tcindex_set_parms
Date:   Tue, 13 Dec 2022 00:14:06 +0800
Message-Id: <20221212161406.10137-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <Y5T6Mrb7cs6o/BqS@pop-os.localdomain>
References: <Y5T6Mrb7cs6o/BqS@pop-os.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Dec 2022 at 05:29, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Dec 05, 2022 at 11:19:56PM +0800, Hawkins Jiawei wrote:
> > To be more specific, the simplified logic about original
> > tcindex_set_parms() is as below:
> >
> > static int
> > tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >                 u32 handle, struct tcindex_data *p,
> >                 struct tcindex_filter_result *r, struct nlattr **tb,
> >                 struct nlattr *est, u32 flags, struct netlink_ext_ack *extack)
> > {
> >       ...
> >       if (p->perfect) {
> >               int i;
> >
> >               if (tcindex_alloc_perfect_hash(net, cp) < 0)
> >                       goto errout;
> >               cp->alloc_hash = cp->hash;
> >               for (i = 0; i < min(cp->hash, p->hash); i++)
> >                       cp->perfect[i].res = p->perfect[i].res;
> >               balloc = 1;
> >       }
> >       cp->h = p->h;
> >
> >       ...
> >
> >       if (cp->perfect)
> >               r = cp->perfect + handle;
>
> We can reach here if p->perfect is non-NULL.
>
> >       else
> >               r = tcindex_lookup(cp, handle) ? : &new_filter_result;
> >
> >       if (old_r && old_r != r) {
> >               err = tcindex_filter_result_init(old_r, cp, net);
> >               if (err < 0) {
> >                       kfree(f);
> >                       goto errout_alloc;
> >               }
> >       }
> >       ...
> > }
> >
> > - cp's h field is directly copied from p's h field
> >
> > - if `old_r` is retrieved from struct tcindex_filter, in other word,
> > is retrieved from p's h field. Then the `r` should get the same value
> > from `tcindex_loopup(cp, handle)`.
>
> See above, 'r' can be 'cp->perfect + handle' which is newly allocated,
> hence different from 'old_r'.

But if `r` is `cp->perfect + handle`, this means `cp->perfect` is not
NULL. So `p->perfect` should not be NULL, which means `old_r` should be
`p->perfect + handle`, according to tcindex_lookup(). This is not
correct with the assumption that `old_r` is retrieved from p's h field.

>
> >
> > - so `old_r == r` is true, code will never uses tcindex_filter_result_init()
> > to clear the old_r in such case.
>
> Not always.
>
> >
> > So I think this patch still can fix this memory leak caused by
> > tcindex_filter_result_init(), But maybe I need to improve my
> > commit message.
> >
>
> I think your patch may introduce other memory leaks and 'old_r' may
> be left as obsoleted too.

I still think this patch should not introduce any memory leaks.

* If the `old_r` is not NULL, it should have only two source according
to the tcindex_lookup() - `old_r` is retrieved from `p->perfect`; or
`old_r` is retrieved from `p->h`. And if `old_r` is retrieved from `p->h`,
this means `p->perfect` is NULL.


* If the `old_r` is retrieved from `p->perfect`, kernel uses
tcindex_alloc_perfect_hash() to newly allocate the filter results.
And `r` should be `cp->perfect + handle`, which is newly allocated.

So `r != old_r` in this situation, but kernel will clears the `old_r`
at tc_filter_wq workqueue in tcindex_partial_destroy_work(), by
destroying the p->perfect. So here kernel doesn't need
tcindex_filter_result_init() to clear the old filter result, and
there is no memory leak.


* If the `old_r` is retrieved from `p->h`, then `p->perfect` is NULL
discussed above. Considering that `cp->h` is directly copied from
`p->h`, `r` should get the same value as `old_r` from tcindex_lookup().

So `r == old_r`, it will ignore the part that kernel uses
tcindex_filter_result_init() to clear the old filter result. So removing
this part of code should have no effect in this situation.



It seems that whether `old_r` is retrived from `p->h` or `p->perfect`,
it is okay to directly deleting the part that kernel uses
tcindex_filter_result_init() to clear the old filter result, without any
memory leak. But this can fix the memory leak caused by
tcindex_filter_result_init().

As for `old_r` may be left as obsoleted, do you mean `old_r` becomes
unused(set but not used)? I think we can directly removing `old_r`.

>
> Thanks.
