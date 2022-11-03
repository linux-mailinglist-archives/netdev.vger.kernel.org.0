Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AE1618C18
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbiKCW7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiKCW7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:59:04 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC84F1EEDA
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 15:59:00 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id o65so2622758iof.4
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 15:59:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p6xqdwu59pUUJrkE6Z09sEAyJTFaEXR5o8D6JzImHTI=;
        b=kEcNJj7LcD3fcM/CPWx9CLDfxe3y4tt3Y+3pgBZZTPQHmahXhq+m1TPA3jXkh4xiBa
         Lvk8exg9kCKVqZ9iZoh2uY7vW8d1n4z0eMFTxWVmlmRVRT3c9438LYBqv/+ZHDTJkjTr
         X13Y1tGMQqVpEGHvnIEu4htPuDlqjj69SnuUeU164Z3/IcEJoxuoqw7jUfb6dP+vznLa
         fGQHJjFIFcRXpW0vLSKYXGfDS6HuO8Pr+tXXpQ0tyD6i488E/ICGRGC67lW9AWhEFcJv
         EAJWBus1nyGZ7pWCG/ZaPFDu3jxtboogrAKVpmOo4AnpCdiRJyE7Pu2j6dFQN0+9AHRR
         rIbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p6xqdwu59pUUJrkE6Z09sEAyJTFaEXR5o8D6JzImHTI=;
        b=7aU49ZI78bTv/y9NF4scmI78iwWbnrcw417WfQNsUsNfK6f763L4vw6NmoK0hd8ehn
         khSUGifCXqamz49+53mOZqE2vk3dcar7wO2k2eN0FcPrHPdcEPO/JnTs2U1bHOb/Seci
         JcINDMb86VfCJTeq5OHM+wcVI6EwZpeFfwFIUghhawJ/F+rEbNrUkoqIHdJ4C2os6kOn
         xQr3tccB4nxXtT/0kgrEcJ4DULDHG+61pi1fBGkSB1ttyHJBfiPL772zbc4ujQW0S9JH
         rWNlzg0fd2vjSVCvWPCG2PyQpf7pupCCOrk8hQIvcVtfGQR40hdN34736HU7Et4zzPT2
         KHpw==
X-Gm-Message-State: ACrzQf3ZeqrQ6rH/lDc4w8hL4E9AMkxm40OXVqxeenSOdDM86hTEjtPf
        mJYqbUqpYO8w4XtAqtcpc5mYTErqoRnSWX6HDx1MnA==
X-Google-Smtp-Source: AMsMyM4Hu1cmv4ECZtnFnuGnUyP0kDTd2FfDL8jeMWhRGnbykk2h21W1+mMaCKKvJJ/1F+uteEB3KbvyPNLBPmYUk8c=
X-Received: by 2002:a05:6602:13d5:b0:6d6:1ea:3b0c with SMTP id
 o21-20020a05660213d500b006d601ea3b0cmr2984368iov.16.1667516340139; Thu, 03
 Nov 2022 15:59:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220715115559.139691-1-shaozhengchao@huawei.com>
 <f0bb3cd6-6986-6ca1-aa40-7a10302c8586@linux.dev> <CAKH8qBvLGaX_+ye5Wdmj1FS+p8K8gBsKUEDRb1x8KzxQE+oDuA@mail.gmail.com>
 <0e69cc92-fece-3673-f7f8-24f5397183b3@linux.dev>
In-Reply-To: <0e69cc92-fece-3673-f7f8-24f5397183b3@linux.dev>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 3 Nov 2022 15:58:49 -0700
Message-ID: <CAKH8qBtOoQ9ig-+rANhje=NCE7NE2bSAW2dBoGujApp-KxA=aw@mail.gmail.com>
Subject: Re: [PATCH v4,bpf-next] bpf: Don't redirect packets with invalid pkt_len
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Zhengchao Shao <shaozhengchao@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        bigeasy@linutronix.de, imagedong@tencent.com, petrm@nvidia.com,
        arnd@arndb.de, dsahern@kernel.org, talalahmad@google.com,
        keescook@chromium.org, haoluo@google.com, jolsa@kernel.org,
        weiyongjun1@huawei.com, yuehaibing@huawei.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hawk@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 3, 2022 at 3:42 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
>
> On 11/3/22 2:36 PM, Stanislav Fomichev wrote:
> > On Thu, Nov 3, 2022 at 2:07 PM Martin KaFai Lau <martin.lau@linux.dev> wrote:
> >>
> >> On 7/15/22 4:55 AM, Zhengchao Shao wrote:
> >>> Syzbot found an issue [1]: fq_codel_drop() try to drop a flow whitout any
> >>> skbs, that is, the flow->head is null.
> >>> The root cause, as the [2] says, is because that bpf_prog_test_run_skb()
> >>> run a bpf prog which redirects empty skbs.
> >>> So we should determine whether the length of the packet modified by bpf
> >>> prog or others like bpf_prog_test is valid before forwarding it directly.
> >>>
> >>> LINK: [1] https://syzkaller.appspot.com/bug?id=0b84da80c2917757915afa89f7738a9d16ec96c5
> >>> LINK: [2] https://www.spinics.net/lists/netdev/msg777503.html
> >>>
> >>> Reported-by: syzbot+7a12909485b94426aceb@syzkaller.appspotmail.com
> >>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> >>> ---
> >>> v3: modify debug print
> >>> v2: need move checking to convert___skb_to_skb and add debug info
> >>> v1: should not check len in fast path
> >>>
> >>>    include/linux/skbuff.h | 8 ++++++++
> >>>    net/bpf/test_run.c     | 3 +++
> >>>    net/core/dev.c         | 1 +
> >>>    3 files changed, 12 insertions(+)
> >>>
> >>> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> >>> index f6a27ab19202..82e8368ba6e6 100644
> >>> --- a/include/linux/skbuff.h
> >>> +++ b/include/linux/skbuff.h
> >>> @@ -2459,6 +2459,14 @@ static inline void skb_set_tail_pointer(struct sk_buff *skb, const int offset)
> >>>
> >>>    #endif /* NET_SKBUFF_DATA_USES_OFFSET */
> >>>
> >>> +static inline void skb_assert_len(struct sk_buff *skb)
> >>> +{
> >>> +#ifdef CONFIG_DEBUG_NET
> >>> +     if (WARN_ONCE(!skb->len, "%s\n", __func__))
> >>> +             DO_ONCE_LITE(skb_dump, KERN_ERR, skb, false);
> >>> +#endif /* CONFIG_DEBUG_NET */
> >>> +}
> >>> +
> >>>    /*
> >>>     *  Add data to an sk_buff
> >>>     */
> >>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> >>> index 2ca96acbc50a..dc9dc0bedca0 100644
> >>> --- a/net/bpf/test_run.c
> >>> +++ b/net/bpf/test_run.c
> >>> @@ -955,6 +955,9 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
> >>>    {
> >>>        struct qdisc_skb_cb *cb = (struct qdisc_skb_cb *)skb->cb;
> >>>
> >>> +     if (!skb->len)
> >>> +             return -EINVAL;
> >>
> >>   From another recent report [0], I don't think this change is fixing the report
> >> from syzbot.  It probably makes sense to revert this patch.
> >>
> >> afaict, This '!skb->len' test is done after
> >>          if (is_l2)
> >>                  __skb_push(skb, hh_len);
> >>
> >> Hence, skb->len is not zero in convert___skb_to_skb().  The proper place to test
> >> skb->len is before __skb_push() to ensure there is some network header after the
> >> mac or may as well ensure "data_size_in > ETH_HLEN" at the beginning.
> >
> > When is_l2==true, __skb_push will result in non-zero skb->len, so we
> > should be good, right?
> > The only issue is when we do bpf_redirect into a tunneling device and
> > do __skb_pull, but that's now fixed by [0].
> >
> > When is_l2==false, the existing check in convert___skb_to_skb will
> > make sure there is something in the l3 headers.
> >
> > So it seems like this patch is still needed. Or am I missing something?
>
> Replied in [0].  I think a small change in [0] will make this patch obsolete.
>
> My thinking is the !skb->len test in this patch does not address all cases, at
> least not the most common one (the sch_cls prog where is_l2 == true) and then it
> needs another change in __bpf_redirect_no_mac [0].  Then, instead of breaking
> the existing test cases,  may as well solely depend on the change in
> __bpf_redirect_no_mac which seems to be the only redirect function that does not
> have the len check now.

Removing this check in convert___skb_to_skb and moving the new one in
__bpf_redirect_no_mac out of (mlen) SGTM.
Can follow up unless you or Zhengchao prefer to do it.
There were some concerns about doing this len check at runtime per
packet, but not sure whether it really affects anything..

> >> The fix in [0] is applied.  If it turns out there are other cases caused by the
> >> skb generated by test_run that needs extra fixes in bpf_redirect_*,  it needs to
> >> revisit an earlier !skb->len check mentioned above and the existing test cases
> >> outside of test_progs would have to adjust accordingly.
> >>
> >> [0]: https://lore.kernel.org/bpf/20221027225537.353077-1-sdf@google.com/
> >>
> >>> +
> >>>        if (!__skb)
> >>>                return 0;
> >>>
> >>> diff --git a/net/core/dev.c b/net/core/dev.c
> >>> index d588fd0a54ce..716df64fcfa5 100644
> >>> --- a/net/core/dev.c
> >>> +++ b/net/core/dev.c
> >>> @@ -4168,6 +4168,7 @@ int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
> >>>        bool again = false;
> >>>
> >>>        skb_reset_mac_header(skb);
> >>> +     skb_assert_len(skb);
> >>>
> >>>        if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SCHED_TSTAMP))
> >>>                __skb_tstamp_tx(skb, NULL, NULL, skb->sk, SCM_TSTAMP_SCHED);
> >>
>
