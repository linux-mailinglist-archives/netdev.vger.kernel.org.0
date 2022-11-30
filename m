Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088B363CD80
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 03:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiK3Csc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 21:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiK3Cs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 21:48:29 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9C56CA1D;
        Tue, 29 Nov 2022 18:48:28 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id q7so24115426wrr.8;
        Tue, 29 Nov 2022 18:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TtkyVa2IrpwnujLbAlvNXcH3WzrDZO7fZhfeo5ojqx4=;
        b=Yys8xeVioelna9iNWiERvl5crZc+mVVlT+/OZm1LNnG4J2rCxTB+EJIklMMegkuscc
         lSsPxMzna89c6M//ei9tMuP1ATGqyC3dtCL3IquQxuTokBHVfGQNifV+4NriXFtI2X17
         fszP4brWR/Hx+1/LnduzDEDWLG2bW2wn+YiLZznjK3Bl6yjsYFGNitQ1NCRBg6VsdwA3
         mdvc/0pCR4hmvzoA9KsE/aXTinG4WlUei5trUCNevQehnnAyVeIxHs/rrX9R1ViLAbSq
         ugV0pwm7w1LorCZ+BNVB/yXIdQa79D+iw5qhGFXmZxo5o6Ez23tqKsvpa3jdwq/RxNVs
         BinQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TtkyVa2IrpwnujLbAlvNXcH3WzrDZO7fZhfeo5ojqx4=;
        b=4Q8gpUOG4ZS0u6BnZFgHhNs1Kp4k9IZ9oSILavaATvPoMwXWRSl+nZdtzVNjcpxeM0
         jMIflimS3goU7RNYmluXJ8GQhkjmbArxJEWsK/shlBJMnwjk13sO6n8DWjoj5UYsrkh9
         QcUsSA0m6qaQ8/6AnwKFH7nlvXFc4BSLBzz6DeL/BHoVB+/yzhX+AXYdQBD+3f43aA++
         MJDHlh7Src1ud4fKPLQlh0x7CKTKhrMFjpSt8zv9C89WQgYT4rF6s9Enl4KsSeAl/BAi
         ByBvOy2kuxXzGkblJ4p0N2ZR7j74T3fuO0d8m/rQC+s0np/c78Fe/wxN+eFWpSuqGhP0
         nr5w==
X-Gm-Message-State: ANoB5pmjLwPTQpd63w83pxxNMw8mJRgTghTzgDULghZRP+MWCTnG+UMs
        mUVN7lx6BjFSblcnUp2xGyZDyr61SWisMo252jE=
X-Google-Smtp-Source: AA0mqf7oM1xVfPZeEBeXoHPoEIp2eTKZPeY+uxONWEAQpo3ShqFa81+F9spvkCRBBnSaiGYb573NrE1KoDjO7rmL9G0=
X-Received: by 2002:adf:e68a:0:b0:242:1926:7838 with SMTP id
 r10-20020adfe68a000000b0024219267838mr7357388wrm.200.1669776506939; Tue, 29
 Nov 2022 18:48:26 -0800 (PST)
MIME-Version: 1.0
References: <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com> <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com> <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com> <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
 <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local> <Y4ZCKaQFqDY3aLTy@Boquns-Mac-mini.local>
 <CA+khW7hkQRFcC1QgGxEK_NeaVvCe3Hbe_mZ-_UkQKaBaqnOLEQ@mail.gmail.com> <23b5de45-1a11-b5c9-d0d3-4dbca0b7661e@huaweicloud.com>
In-Reply-To: <23b5de45-1a11-b5c9-d0d3-4dbca0b7661e@huaweicloud.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 30 Nov 2022 10:47:50 +0800
Message-ID: <CAMDZJNWtyanKtXtAxYGwvJ0LTgYLf=5iYFm63pbvvJLPE8oHSQ@mail.gmail.com>
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Hou Tao <houtao@huaweicloud.com>
Cc:     Hao Luo <haoluo@google.com>, Waiman Long <longman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, bpf <bpf@vger.kernel.org>,
        "houtao1@huawei.com" <houtao1@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 9:50 AM Hou Tao <houtao@huaweicloud.com> wrote:
>
> Hi Hao,
>
> On 11/30/2022 3:36 AM, Hao Luo wrote:
> > On Tue, Nov 29, 2022 at 9:32 AM Boqun Feng <boqun.feng@gmail.com> wrote:
> >> Just to be clear, I meant to refactor htab_lock_bucket() into a try
> >> lock pattern. Also after a second thought, the below suggestion doesn't
> >> work. I think the proper way is to make htab_lock_bucket() as a
> >> raw_spin_trylock_irqsave().
> >>
> >> Regards,
> >> Boqun
> >>
> > The potential deadlock happens when the lock is contended from the
> > same cpu. When the lock is contended from a remote cpu, we would like
> > the remote cpu to spin and wait, instead of giving up immediately. As
> > this gives better throughput. So replacing the current
> > raw_spin_lock_irqsave() with trylock sacrifices this performance gain.
> >
> > I suspect the source of the problem is the 'hash' that we used in
> > htab_lock_bucket(). The 'hash' is derived from the 'key', I wonder
> > whether we should use a hash derived from 'bucket' rather than from
> > 'key'. For example, from the memory address of the 'bucket'. Because,
> > different keys may fall into the same bucket, but yield different
> > hashes. If the same bucket can never have two different 'hashes' here,
> > the map_locked check should behave as intended. Also because
> > ->map_locked is per-cpu, execution flows from two different cpus can
> > both pass.
> The warning from lockdep is due to the reason the bucket lock A is used in a
> no-NMI context firstly, then the same bucke lock is used a NMI context, so
Yes, I tested lockdep too, we can't use the lock in NMI(but only
try_lock work fine) context if we use them no-NMI context. otherwise
the lockdep prints the warning.
* for the dead-lock case: we can use the
1. hash & min(HASHTAB_MAP_LOCK_MASK, htab->n_buckets -1)
2. or hash bucket address.

* for lockdep warning, we should use in_nmi check with map_locked.

BTW, the patch doesn't work, so we can remove the lock_key
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c50eb518e262fa06bd334e6eec172eaf5d7a5bd9

static inline int htab_lock_bucket(const struct bpf_htab *htab,
                                   struct bucket *b, u32 hash,
                                   unsigned long *pflags)
{
        unsigned long flags;

        hash = hash & min(HASHTAB_MAP_LOCK_MASK, htab->n_buckets -1);

        preempt_disable();
        if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
                __this_cpu_dec(*(htab->map_locked[hash]));
                preempt_enable();
                return -EBUSY;
        }

        if (in_nmi()) {
                if (!raw_spin_trylock_irqsave(&b->raw_lock, flags))
                        return -EBUSY;
        } else {
                raw_spin_lock_irqsave(&b->raw_lock, flags);
        }

        *pflags = flags;
        return 0;
}


> lockdep deduces that may be a dead-lock. I have already tried to use the same
> map_locked for keys with the same bucket, the dead-lock is gone, but still got
> lockdep warning.
> >
> > Hao
> > .
>


-- 
Best regards, Tonghao
