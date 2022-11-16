Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0017A62BD4E
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 13:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbiKPMQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 07:16:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbiKPMQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 07:16:24 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8A83F05A;
        Wed, 16 Nov 2022 04:10:35 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id w3-20020a17090a460300b00218524e8877so2482801pjg.1;
        Wed, 16 Nov 2022 04:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xt1QsURs8dSzNQ+WHlj7oV4CqoPL0fiQE0UeKb8Zq/8=;
        b=T/HxHqwRNJefXpFUOTtsaXE4BZnCfPpY3R2h3RXPbWTAgzvZPUOsIOnm8RyiAexkWg
         YiS3nsV1WAvy3Va3Ik+A5JeXb3MnUOCauA8KJimmmzn0EWtVm9p4nMrlE/4xfPUKdvZd
         +CUFnpT/pgaHBIlUBNkmyLKDWdAkbs+zE2qLj2d7QBT8ePqcmAS9it8WH/FzAD8Cihbh
         8uXcWYvxTwVHnawTp6Y1/MG25gXRfH5Wbh+qgvEAwJVjboRALATGT2pIgDnkHIN6itLE
         DVE4L7MaJn9/ru23TqYflCXPe/ckdP31JPREwlsfTyIMpfWRX0xiJ6m3eSU+LKFfcnBT
         kFBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xt1QsURs8dSzNQ+WHlj7oV4CqoPL0fiQE0UeKb8Zq/8=;
        b=qbrguXCuA7opJkocKxLvArOe/uyu6m3X3o+yzqIn2i4+MVe+XqxlOD3BH0aWo5VyZJ
         RLrXxQtFNewxQHklSWzS58FfdRpJkY05m28TMh1hZBNbmK+r1Ayt7ZB9Vi2/A2smytlM
         NOXB88uqx2TC8C072IVfOMn+9TVPFK/u43QoL0trvP+acizTMzO9seyqXgmHe2/U3osB
         Fc3dfrPY6auh1e8XRxZ7Dcjaa/1Hu6sXUlp1icUfrYQnsbfE8AmQP3ycHhohRK+LjSo3
         wyNHAH05YyvC0QDObKA2CVmcgOGI85cLeNTIUZmBSy7EOvE8R0nEP4y4YcOl+TKdkLyn
         ke/A==
X-Gm-Message-State: ANoB5pm8v6kGcM1vVqmT5pWa+atB5gBUSyYNK9SSXsgdlRGBdEFbSxZY
        nGizA847GVWEQ51R36txCTc=
X-Google-Smtp-Source: AA0mqf6AxicNbrmQQOiMjHmkrqREXP7f4cqpC7FE0HOS5MwnsRlKv8MlI5QPM+jXrzOS3ggB7sLAjg==
X-Received: by 2002:a17:902:e951:b0:177:e4c7:e8b7 with SMTP id b17-20020a170902e95100b00177e4c7e8b7mr8727198pll.118.1668600634751;
        Wed, 16 Nov 2022 04:10:34 -0800 (PST)
Received: from localhost ([114.254.0.245])
        by smtp.gmail.com with ESMTPSA id k12-20020a17090a39cc00b0020d67a726easm1420084pjf.10.2022.11.16.04.10.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 04:10:34 -0800 (PST)
From:   Hawkins Jiawei <yin31149@gmail.com>
To:     kuba@kernel.org
Cc:     18801353760@163.com, cong.wang@bytedance.com, davem@davemloft.net,
        edumazet@google.com, jhs@mojatatu.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com,
        syzbot+232ebdbd36706c965ebf@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, xiyou.wangcong@gmail.com,
        yin31149@gmail.com
Subject: Re: [PATCH v2] net: sched: fix memory leak in tcindex_set_parms
Date:   Wed, 16 Nov 2022 20:10:10 +0800
Message-Id: <20221116121010.101577-1-yin31149@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115184442.272b6ea8@kernel.org>
References: <20221115184442.272b6ea8@kernel.org>
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

On Wed, 16 Nov 2022 at 10:44, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 15 Nov 2022 19:57:10 +0100 Paolo Abeni wrote:
> > This code confuses me more than a bit, and I don't follow ?!?
>
> It's very confusing :S
>
> For starters I don't know when r != old_r. I mean now it triggers
> randomly after the RCU-ification, but in the original code when
> it was just a memset(). When would old_r ever not be null and yet
> point to a different entry?

I am also confused about the code when I tried to fix this bug.

As for when `old_r != r`, according to the simplified
code below, this should be probably true if `p->perfect` is true
or `!p->perfect && !pc->h` is true(please correct me if I am wrong)

        struct tcindex_filter_result new_filter_result, *old_r = r;
        struct tcindex_data *cp = NULL, *oldp;
        struct tcf_result cr = {};

        /* tcindex_data attributes must look atomic to classifier/lookup so
         * allocate new tcindex data and RCU assign it onto root. Keeping
         * perfect hash and hash pointers from old data.
         */
        cp = kzalloc(sizeof(*cp), GFP_KERNEL);

        if (p->perfect) {
                if (tcindex_alloc_perfect_hash(net, cp) < 0)
                        goto errout;
                ...
        }
        cp->h = p->h;

        if (!cp->perfect && !cp->h) {
                if (valid_perfect_hash(cp)) {
                        if (tcindex_alloc_perfect_hash(net, cp) < 0)
                                goto errout_alloc;

                } else {
                        struct tcindex_filter __rcu **hash;

                        hash = kcalloc(cp->hash,
                                       sizeof(struct tcindex_filter *),
                                       GFP_KERNEL);

                        if (!hash)
                                goto errout_alloc;

                        cp->h = hash;
                }
        }
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

* If `p->perfect` is true, tcindex_alloc_perfect_hash() newly
alloctes cp->perfect.

* If `!p->perfect && !p->h` is true, cp->perfect or cp->h is
newly allocated.

In either case, r probably points to the newly allocated memory,
which should not equals to the old_r.

>
> > it looks like that at this point:
> >
> > * the data path could access 'old_r->exts' contents via 'p' just before
> > the previous 'tcindex_filter_result_init(old_r, cp, net);' but still
> > potentially within the same RCU grace period
> >
> > * 'tcindex_filter_result_init(old_r, cp, net);' has 'unlinked' the old
> > exts from 'p'  so that will not be freed by later
> > tcindex_partial_destroy_work()
> >
> > Overall it looks to me that we need some somewhat wait for the RCU
> > grace period,
>
> Isn't it better to make @cp a deeper copy of @p ?
> I thought it already is but we don't seem to be cloning p->h.
> Also the cloning of p->perfect looks quite lossy.

Yes, I also think @cp should be a deeper copy of @p.

But it seems that in tcindex_alloc_perfect_hash(),
each @cp ->exts will be initialized by tcf_exts_init()
as below, and tcindex_set_parms() forgets to free the
old ->exts content, triggering this memory leak.(Please
correct me if I am wrong)

        static int tcindex_alloc_perfect_hash(struct net *net,
                                              struct tcindex_data *cp)
        {
        	int i, err = 0;
        
        	cp->perfect = kcalloc(cp->hash, sizeof(struct tcindex_filter_result),
        			      GFP_KERNEL | __GFP_NOWARN);
        
        	for (i = 0; i < cp->hash; i++) {
        		err = tcf_exts_init(&cp->perfect[i].exts, net,
        				    TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
        		if (err < 0)
        			goto errout;
        		cp->perfect[i].p = cp;
        	}
        }

        static inline int tcf_exts_init(struct tcf_exts *exts, struct net *net,
        				int action, int police)
        {
        #ifdef CONFIG_NET_CLS_ACT
        	exts->type = 0;
        	exts->nr_actions = 0;
        	/* Note: we do not own yet a reference on net.
        	 * This reference might be taken later from tcf_exts_get_net().
        	 */
        	exts->net = net;
        	exts->actions = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
        				GFP_KERNEL);
        	if (!exts->actions)
        		return -ENOMEM;
        #endif
        	exts->action = action;
        	exts->police = police;
        	return 0;
        }

>
> > Somewhat side question: it looks like that the 'perfect hashing' usage
> > is the root cause of the issue addressed here, and very likely is
> > afflicted by other problems, e.g. the data curruption in 'err =
> > tcindex_filter_result_init(old_r, cp, net);'.
> >
> > AFAICS 'perfect hashing' usage is a sort of optimization that the user-
> > space may trigger with some combination of the tcindex arguments. I'm
> > wondering if we could drop all perfect hashing related code?
>
> The thought of "how much of this can we delete" did cross my mind :)
