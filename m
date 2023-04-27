Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091166F0AEA
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 19:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244314AbjD0RgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 13:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244395AbjD0RgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 13:36:10 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2573584;
        Thu, 27 Apr 2023 10:35:58 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6a5fe1ebc42so3667284a34.1;
        Thu, 27 Apr 2023 10:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682616958; x=1685208958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JsWAUgO6fW04Ok+RjkKHL4mEg/xiIHYfiF+AoGZQ788=;
        b=RDHvIccQO7B/zuGFC/x5F2IrLVlMeKnuk7fSmKO8f4oujbdLDOlI711XP6opifONu4
         3qTMFpn/MSn/lftd+A+rt3wZ36FgRZzgThJYK+kxMSgY/BXXj6oWC9z3cjycdDwDx3ha
         d6O3+7XrzBr6o4F8NglB9hDTqsnPGnGw2NUkeB+nMMsjY4AD+pZrOVHBEZEoTGbLJw38
         WC6iNgTsH7bn7eLVVh8ewFNnIQcvh5tD85RsQ8AlZpo1ilKQnL49GMPOPRz8ZI2Kqqgn
         NjqAx0PnWgOGj5YecL0mxNR9ljFyLA9U+zmOJJrqIgFGUt1+344HG9Rys6mLr2y61k8S
         JQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682616958; x=1685208958;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JsWAUgO6fW04Ok+RjkKHL4mEg/xiIHYfiF+AoGZQ788=;
        b=GXPZS5Wg0mVHqD/Yjj252vWeTTF22AqUCW07IVuo66OcLTiVUm554IwdX2sU9Sldy6
         DlWgMkXt9XQPFnQ5P4wzxzjHRCfGn/pEAHEt8DnO7LJXfcqjiLJ2OTb0l5zjoeqcJkCJ
         BequhIj+Eq75JjtBkGNOPlDCRUt8j711BsxpMkos6jynwv7LiTCPo+QnG9XQ2cqHOYln
         17/iGIC+u5WLuW//0Upeu23BsjT0s18Zwwd4WbqVL0RrOvFe9+dOJMbFMGqNYAhSGL2U
         rh/GhxgbUvx8FpA7TNvZ+L72EeGzXGbncIzq02lfgMRGBvkr8C9XP0yn/8XjN35/uk4a
         ZJmQ==
X-Gm-Message-State: AC+VfDxMvZd5Lmp9xF1pjGO+w8b5WWX7yodh0XB6uI05rCb5HYGa1oc5
        zcHmk5cuW6o9m7pdtHTu3A==
X-Google-Smtp-Source: ACHHUZ66Ytt3OM1N5vIB0b6v0aMusytEm/+vlrJSq2LFyGnocICjTb3N24D7ONWS3r2YNvAv6/q5/Q==
X-Received: by 2002:a05:6830:c:b0:6a4:2dfa:360c with SMTP id c12-20020a056830000c00b006a42dfa360cmr1180144otp.1.1682616957571;
        Thu, 27 Apr 2023 10:35:57 -0700 (PDT)
Received: from bytedance ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id z18-20020a05683010d200b006a32ba92994sm3931041oto.23.2023.04.27.10.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 10:35:57 -0700 (PDT)
Date:   Thu, 27 Apr 2023 10:35:54 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Jakub Kicinski <kuba@kernel.org>,
        syzbot <syzbot+b53a9c0d1ea4ad62da8b@syzkaller.appspotmail.com>,
        davem@davemloft.net, edumazet@google.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        xiyou.wangcong@gmail.com, peilin.ye@bytedance.com, hdanton@sina.com
Subject: Re: [syzbot] [net?] KASAN: slab-use-after-free Write in
 mini_qdisc_pair_swap
Message-ID: <20230427173554.GA11725@bytedance>
References: <0000000000006cf87705f79acf1a@google.com>
 <20230328184733.6707ef73@kernel.org>
 <ZCOylfbhuk0LeVff@do-x1extreme>
 <b4d93f31-846f-3391-db5d-db8682ac3c34@mojatatu.com>
 <CAM0EoMn2LnhdeLcxCFdv+4YshthN=YHLnr1rvv4JoFgNS92hRA@mail.gmail.com>
 <20230417230011.GA41709@bytedance>
 <20230426233657.GA11249@bytedance>
 <877ctxsdnb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ctxsdnb.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Pedro, Vlad,

On Thu, Apr 27, 2023 at 03:26:03PM +0300, Vlad Buslov wrote:
> On Wed 26 Apr 2023 at 16:42, Peilin Ye <yepeilin.cs@gmail.com> wrote:
> > As we can see there're interleaving mini_qdisc_pair_swap() calls between
> > Qdisc A and B, causing all kinds of troubles, including the UAF (thread
> > 2 writing to mini Qdisc a1's rcu_state after Qdisc A has already been
> > freed) reported by syzbot.
> 
> Great analysis! However, it is still not quite clear to me how threads 1
> and 2 access each other RCU state when q->miniqp is a private memory of
> the Qdisc, so 1 should only see A->miniqp and 2 only B->miniqp. And both
> miniqps should be protected from deallocation by reference that lockless
> RTM_NEWTFILTER obtains.

Thanks for taking a look!

To elaborate, p_miniq is a pointer of pointer of struct mini_Qdisc,
initialized in ingress_init() to point to eth0->miniq_ingress, which
isn't private to A or B.

In other words, both A->miniqp->p_miniq and B->miniqp->p_miniq point to
eth0->miniq_ingress.

For your reference, roughly speaking, mini_qdisc_pair_swap() does this:

  miniq_old = dev->miniq_ingress;

  if (destroying) {
          dev->miniq_ingress = NULL;
  } else {
          rcu_wait();
          dev->miniq_ingress = miniq_new;
  }

  if (miniq_old)
          miniq_old->rcu_state = ...

On Wed 26 Apr 2023 at 16:42, Peilin Ye <yepeilin.cs@gmail.com> wrote:
>  Thread 1               A's refcnt   Thread 2
>   RTM_NEWQDISC (A, locked)
>    qdisc_create(A)               1
>    qdisc_graft(A)                9
>
>   RTM_NEWTFILTER (X, lockless)
>    __tcf_qdisc_find(A)          10
>    tcf_chain0_head_change(A)
>  ! mini_qdisc_pair_swap(A)

  1. A adds its first filter,
     miniq_old (eth0->miniq_ingress) is NULL,
     RCU wait starts,
     RCU wait ends,
     change eth0->miniq_ingress to A's mini Qdisc.

>             |                        RTM_NEWQDISC (B, locked)
>             |                    2    qdisc_graft(B)
>             |                    1    notify_and_destroy(A)
>             |
>             |                        RTM_NEWTFILTER (Y, lockless)
>             |                         tcf_chain0_head_change(B)
>             |                       ! mini_qdisc_pair_swap(B)

                      2. B adds its first filter,
                         miniq_old (eth0->miniq_ingress) is A's mini Qdisc,
                         RCU wait starts,

>    tcf_block_release(A)          0             |
>    qdisc_destroy(A)                            |
>    tcf_chain0_head_change_cb_del(A)            |
>  ! mini_qdisc_pair_swap(A)                     |

  3. A destroys itself,
     miniq_old (eth0->miniq_ingress) is A's mini Qdisc,
     (destroying, so no RCU wait)
     change eth0->miniq_ingress to NULL,
     update miniq_old, or A's mini Qdisc's RCU state,
     A is freed.

                      2. RCU wait ends,
		         change eth0->miniq_ingress to B's mini Qdisc,
	 use-after-free: update miniq_old, or A's mini Qdisc's RCU state.

I hope this helps.  Sorry I didn't go into details; this UAF isn't the
only thing that is unacceptable here:

Consider B.  We add a filter Y to B, expecting ingress packets on eth0
to go through Y.  Then all of a sudden, A sets eth0->miniq_ingress to
NULL during its destruction, so packets will not find Y at all on
datapath (sch_handle_ingress()).  New filter becomes invisible - this is
already buggy enough :-/

So I think B's first call to mini_qdisc_pair_swap() should happen after
A's last call (in ingress_destroy()), which is what I am trying to
achieve here.

Thanks,
Peilin Ye

