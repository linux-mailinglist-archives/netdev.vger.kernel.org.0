Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 239AE642B8B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiLEPWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiLEPVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:21:44 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9451EC7C;
        Mon,  5 Dec 2022 07:20:04 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id g10so11087552plo.11;
        Mon, 05 Dec 2022 07:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dV7aKa56ibaWCF0fScgffCWPLWMG3qY+09NbkLnEHyw=;
        b=aomiFspej4HizuZJYTvyarnC8Vhm2Pd9q93oE30Ve+E/rqqWLB0hFEzOivHHXQ4Qc2
         Td93qQXrEP5w1Lycb5ce7g3FVcwhKAWKZMN+jUbAjExlRbnWHVt29ujjVbv/3AHe42Rl
         dWcmf8BeFiFMw2yxEB3uduHQq8g3k0tDf2Ihdr00fMChc4CELf8JZB2k+3WQUMh31wtU
         57olOyg+WwrJF7dSPDU5eXDb/hNOOOXeoOclmt4BZc1OxFOZTaukZMalzh37TWcBJUUJ
         jnI/pufbuah0u73N37rrHxHLqcxchq+iy/St0GonOpZUkR0qQ8Y6WTlWKxih68RWPMPg
         jLRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dV7aKa56ibaWCF0fScgffCWPLWMG3qY+09NbkLnEHyw=;
        b=JNYL1ClfusLMRXDMEyEvA02mH0B9VK246Ouird1xAmrImeS93uVoKWXhdR7o/J39FF
         8Ea2qzaexE4kgDlUIfOMcfwtTtO4YJgfyL6w1Mjsay2+WrBDlSmXqr6BSL7nFL2zt5DU
         B7/u8V31l7kL6Uv0Q3WstQ+w/MM5f8xGsLeSOti3kKVFchn2j/pcudr7j6WfgxnS7nGm
         RigETXqUAeYAG8gmlF1Gbztfr7aYVgjy6hH6ccdfF33v5c0Jt9LIY6VYl6nCNkLY7WUt
         DIhKg3dfez7z9hcC0WuTgBx/CndznIjB1vUbELXaUNhLuUq1mhOibD8yfkQEATYcZydE
         rLEg==
X-Gm-Message-State: ANoB5pk0TdLfDAEnEPWQ3m/vwaOI8TuyAeOz+CA37/o7PNpCTtKiAcPT
        sLymKaQ+xUXA8PqvCBpmUh0=
X-Google-Smtp-Source: AA0mqf5aPYhGHwQpk/9/19rKsVis29Hjb8LZbiqLXx/XQ7kq+tRVSYO9QdhX7wKDAb4OGBlESOS+7Q==
X-Received: by 2002:a17:90a:5103:b0:219:b374:6a7d with SMTP id t3-20020a17090a510300b00219b3746a7dmr10307602pjh.22.1670253604200;
        Mon, 05 Dec 2022 07:20:04 -0800 (PST)
Received: from localhost ([1.83.244.162])
        by smtp.gmail.com with ESMTPSA id s9-20020a170902b18900b0017f8094a52asm10696595plr.29.2022.12.05.07.20.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:20:03 -0800 (PST)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     xiyou.wangcong@gmail.com
Cc:     18801353760@163.com, cong.wang@bytedance.com, davem@davemloft.net,
        dvyukov@google.com, edumazet@google.com, jhs@mojatatu.com,
        jiri@resnulli.us, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yin31149@gmail.com
Subject: Re: [PATCH v3] net: sched: fix memory leak in tcindex_set_parms
Date:   Mon,  5 Dec 2022 23:19:56 +0800
Message-Id: <20221205151956.28422-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <Y4uvQA2xxtJXltSM@pop-os.localdomain>
References: <Y4uvQA2xxtJXltSM@pop-os.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

On Sun, 4 Dec 2022 at 04:19, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Tue, Nov 29, 2022 at 10:52:49AM +0800, Hawkins Jiawei wrote:
> > Kernel uses tcindex_change() to change an existing
> > filter properties. During the process of changing,
> > kernel uses tcindex_alloc_perfect_hash() to newly
> > allocate filter results, uses tcindex_filter_result_init()
> > to clear the old filter result.
> >
> > Yet the problem is that, kernel clears the old
> > filter result, without destroying its tcf_exts structure,
> > which triggers the above memory leak.
> >
> > Considering that there already extis a tc_filter_wq workqueue
> > to destroy the old tcindex_data by tcindex_partial_destroy_work()
> > at the end of tcindex_set_parms(), this patch solves this memory
> > leak bug by removing this old filter result clearing part,
> > and delegating it to the tc_filter_wq workqueue.
>
> Hmm?? The tcindex_partial_destroy_work() is to destroy 'oldp' which is
> different from 'old_r'. I mean, you seem assuming that struct
> tcindex_filter_result is always from struct tcindex_data, which is not
> true, check the following tcindex_lookup() which retrieves tcindex_filter_result
> from struct tcindex_filter.
>
> static struct tcindex_filter_result *tcindex_lookup(struct tcindex_data *p,
>                                                     u16 key)
> {
>         if (p->perfect) {
>                 struct tcindex_filter_result *f = p->perfect + key;
>
>                 return tcindex_filter_is_set(f) ? f : NULL;
>         } else if (p->h) {
>                 struct tcindex_filter __rcu **fp;
>                 struct tcindex_filter *f;
>
>                 fp = &p->h[key % p->hash];
>                 for (f = rcu_dereference_bh_rtnl(*fp);
>                      f;
>                      fp = &f->next, f = rcu_dereference_bh_rtnl(*fp))
>                         if (f->key == key)
>                                 return &f->result;
>         }
>
>         return NULL;
> }

Oh, thanks for correcting me! You are right, I wrongly assuming that
struct tcindex_filter_result is always from struct tcindex_data
`perfect` field.

But I think this patch still can fix this problem, after reviewing
the tcindex_set_parms(). Because only the `tcindex_filter_result` is
from `struct tcindex_data`, can the code reaches the deleted part
in this patch.

To be more specific, the simplified logic about original
tcindex_set_parms() is as below:

static int
tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
		  u32 handle, struct tcindex_data *p,
		  struct tcindex_filter_result *r, struct nlattr **tb,
		  struct nlattr *est, u32 flags, struct netlink_ext_ack *extack)
{
	...
	if (p->perfect) {
		int i;

		if (tcindex_alloc_perfect_hash(net, cp) < 0)
			goto errout;
		cp->alloc_hash = cp->hash;
		for (i = 0; i < min(cp->hash, p->hash); i++)
			cp->perfect[i].res = p->perfect[i].res;
		balloc = 1;
	}
	cp->h = p->h;

	...

	if (cp->perfect)
		r = cp->perfect + handle;
	else
		r = tcindex_lookup(cp, handle) ? : &new_filter_result;

	if (old_r && old_r != r) {
		err = tcindex_filter_result_init(old_r, cp, net);
		if (err < 0) {
			kfree(f);
			goto errout_alloc;
		}
	}
	...
}

- cp's h field is directly copied from p's h field

- if `old_r` is retrieved from struct tcindex_filter, in other word,
is retrieved from p's h field. Then the `r` should get the same value
from `tcindex_loopup(cp, handle)`.

- so `old_r == r` is true, code will never uses tcindex_filter_result_init()
to clear the old_r in such case.

So I think this patch still can fix this memory leak caused by 
tcindex_filter_result_init(), But maybe I need to improve my
commit message.

Please correct me If I am wrong.

> > diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
> > index 1c9eeb98d826..3f4e7a6cdd96 100644
> > --- a/net/sched/cls_tcindex.c
> > +++ b/net/sched/cls_tcindex.c
> > @@ -478,14 +478,6 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
> >               tcf_bind_filter(tp, &cr, base);
> >       }
> > 
> > -     if (old_r && old_r != r) {
> > -             err = tcindex_filter_result_init(old_r, cp, net);
> > -             if (err < 0) {
> > -                     kfree(f);
> > -                     goto errout_alloc;
> > -             }
> > -     }
> > -
>
> Even if your above analysis is correct, 'old_r' becomes unused (set but not used)
> now, I think you should get some compiler warning.


Oh, it actually didn't trigger any compiler warning,
because there is still a used place as below:

static int
tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
		  u32 handle, struct tcindex_data *p,
		  struct tcindex_filter_result *r, struct nlattr **tb,
		  struct nlattr *est, u32 flags, struct netlink_ext_ack *extack)
{
	struct tcindex_filter_result new_filter_result, *old_r = r;
	...
	err = tcindex_filter_result_init(&new_filter_result, cp, net);
	if (err < 0)
		goto errout_alloc;
	if (old_r)
		cr = r->res;
	...
}

But the `old_r` and `r` has the same value here, so we can just replace
the `old_r` with `r` here, and delete the `old_r` as you suggested.

Thanks for your suggestion!

>
> Thanks.
