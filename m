Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A939563CEF2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiK3F5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbiK3F4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:56:49 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF74037238;
        Tue, 29 Nov 2022 21:56:10 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id q7so24510777wrr.8;
        Tue, 29 Nov 2022 21:56:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MfF4ygUbOy4r9BRLeLJ9LFmBydVfI8Aj6mDHNVkLPn8=;
        b=gcxhkSvzOPgjvQRMzYbnvSGAlb4eJq+J5P04SEDVQX+Kx+DjMUENjGjZMkZ5tS78A9
         OHag0NHlwi8s0eR/hPoBcc8I070I0W1MBnq9ZHb/7Z3CJ7VlemQpnlmBMaEqzBYY51+j
         XSPuaPzsWFUeMbtOsoXjYZlhhk09df2LM6aDJ4MXeS1hFjY90ZoBxlpnMq9GAAJYNB4a
         nHyHorU7k5HLkhOhBSbyB5zPtJvLO1FrBDvgT7eYwQbCk50Swjfthsgz4Nc81CdBWSHN
         +LEGYIh3qpTrFvR5lF4aoM4JSB/ZBVscpYyI4JpJCfs5O65qJG4fvaM+bXs/j9noR0Vk
         HJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MfF4ygUbOy4r9BRLeLJ9LFmBydVfI8Aj6mDHNVkLPn8=;
        b=V4GwU+fpW5LkvBUotCXnfTwGvv2oQvUvjKXHMhrF3mxvI/vc41gxElz8G5TCoplCaI
         DXijJ3w+jPKaR4LNLN7Qp//bgpH9PEc+2ucjAOZ8G8aHpg+/qx+/tBX5AMghu9WjpdoE
         ZrJwSQmhSDUX6CTDl6mX6/obArDWXkV0WzdqsyXBcvlWUhQZnmRm3ZhgVk1qyN8ybiU6
         FwLf9LY/PVUtgHJgLe+XVkW9UwhyiKHOnWL1SLe6gDKU7EjMpbmctSYmBlj+NYt1UeEe
         ALaNX3ckeoP7QrHeBvd6OaYoG0au1qurvEYJQIyVDtGqjnWHFD6aG4MWSIwceK7ahYRz
         PqKA==
X-Gm-Message-State: ANoB5pnOnqcVZe8eYypaLP2UUKH4hWrg2lRPQLx6JS+wN8n5vkjJMq9A
        mtXwHyvTshnPDsBfE93HJjXSuhUFMnRBKagHSj8=
X-Google-Smtp-Source: AA0mqf5Qv+kD/cnvehrbrkXnxDlXa9v1LTZlDTOAaBOklGYkCCFpGpr107Xx7AHzy71ozi+0rmdPyCByblQJEo4lOak=
X-Received: by 2002:adf:e0c6:0:b0:22a:34a4:8831 with SMTP id
 m6-20020adfe0c6000000b0022a34a48831mr36576787wri.199.1669787769432; Tue, 29
 Nov 2022 21:56:09 -0800 (PST)
MIME-Version: 1.0
References: <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com> <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com> <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com> <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
 <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local> <Y4ZCKaQFqDY3aLTy@Boquns-Mac-mini.local>
 <CA+khW7hkQRFcC1QgGxEK_NeaVvCe3Hbe_mZ-_UkQKaBaqnOLEQ@mail.gmail.com>
 <23b5de45-1a11-b5c9-d0d3-4dbca0b7661e@huaweicloud.com> <CAMDZJNWtyanKtXtAxYGwvJ0LTgYLf=5iYFm63pbvvJLPE8oHSQ@mail.gmail.com>
 <8d424223-1da6-60bf-dd2c-cd2fe6d263fe@huaweicloud.com>
In-Reply-To: <8d424223-1da6-60bf-dd2c-cd2fe6d263fe@huaweicloud.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 30 Nov 2022 13:55:32 +0800
Message-ID: <CAMDZJNWv0Qv6LJ=APOj644vKfJttcQ4WHXFizxn_2hCeVzQcXA@mail.gmail.com>
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

On Wed, Nov 30, 2022 at 12:13 PM Hou Tao <houtao@huaweicloud.com> wrote:
>
> Hi,
>
> On 11/30/2022 10:47 AM, Tonghao Zhang wrote:
> > On Wed, Nov 30, 2022 at 9:50 AM Hou Tao <houtao@huaweicloud.com> wrote:
> >> Hi Hao,
> >>
> >> On 11/30/2022 3:36 AM, Hao Luo wrote:
> >>> On Tue, Nov 29, 2022 at 9:32 AM Boqun Feng <boqun.feng@gmail.com> wrote:
> >>>> Just to be clear, I meant to refactor htab_lock_bucket() into a try
> >>>> lock pattern. Also after a second thought, the below suggestion doesn't
> >>>> work. I think the proper way is to make htab_lock_bucket() as a
> >>>> raw_spin_trylock_irqsave().
> >>>>
> >>>> Regards,
> >>>> Boqun
> >>>>
> >>> The potential deadlock happens when the lock is contended from the
> >>> same cpu. When the lock is contended from a remote cpu, we would like
> >>> the remote cpu to spin and wait, instead of giving up immediately. As
> >>> this gives better throughput. So replacing the current
> >>> raw_spin_lock_irqsave() with trylock sacrifices this performance gain.
> >>>
> >>> I suspect the source of the problem is the 'hash' that we used in
> >>> htab_lock_bucket(). The 'hash' is derived from the 'key', I wonder
> >>> whether we should use a hash derived from 'bucket' rather than from
> >>> 'key'. For example, from the memory address of the 'bucket'. Because,
> >>> different keys may fall into the same bucket, but yield different
> >>> hashes. If the same bucket can never have two different 'hashes' here,
> >>> the map_locked check should behave as intended. Also because
> >>> ->map_locked is per-cpu, execution flows from two different cpus can
> >>> both pass.
> >> The warning from lockdep is due to the reason the bucket lock A is used in a
> >> no-NMI context firstly, then the same bucke lock is used a NMI context, so
> > Yes, I tested lockdep too, we can't use the lock in NMI(but only
> > try_lock work fine) context if we use them no-NMI context. otherwise
> > the lockdep prints the warning.
> > * for the dead-lock case: we can use the
> > 1. hash & min(HASHTAB_MAP_LOCK_MASK, htab->n_buckets -1)
> > 2. or hash bucket address.
> Use the computed hash will be better than hash bucket address, because the hash
> buckets are allocated sequentially.
> >
> > * for lockdep warning, we should use in_nmi check with map_locked.
> >
> > BTW, the patch doesn't work, so we can remove the lock_key
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c50eb518e262fa06bd334e6eec172eaf5d7a5bd9
> >
> > static inline int htab_lock_bucket(const struct bpf_htab *htab,
> >                                    struct bucket *b, u32 hash,
> >                                    unsigned long *pflags)
> > {
> >         unsigned long flags;
> >
> >         hash = hash & min(HASHTAB_MAP_LOCK_MASK, htab->n_buckets -1);
> >
> >         preempt_disable();
> >         if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
> >                 __this_cpu_dec(*(htab->map_locked[hash]));
> >                 preempt_enable();
> >                 return -EBUSY;
> >         }
> >
> >         if (in_nmi()) {
> >                 if (!raw_spin_trylock_irqsave(&b->raw_lock, flags))
> >                         return -EBUSY;
> The only purpose of trylock here is to make lockdep happy and it may lead to
> unnecessary -EBUSY error for htab operations in NMI context. I still prefer add
> a virtual lock-class for map_locked to fix the lockdep warning. So could you use
Hi, what is virtual lock-class ? Can you give me an example of what you mean?
> separated patches to fix the potential dead-lock and the lockdep warning ? It
> will be better you can also add a bpf selftests for deadlock problem as said before.
>
> Thanks,
> Tao
> >         } else {
> >                 raw_spin_lock_irqsave(&b->raw_lock, flags);
> >         }
> >
> >         *pflags = flags;
> >         return 0;
> > }
> >
> >
> >> lockdep deduces that may be a dead-lock. I have already tried to use the same
> >> map_locked for keys with the same bucket, the dead-lock is gone, but still got
> >> lockdep warning.
> >>> Hao
> >>> .
> >
>


-- 
Best regards, Tonghao
