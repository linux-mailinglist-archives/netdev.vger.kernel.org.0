Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6783D63CDD8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 04:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiK3DdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 22:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbiK3DdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 22:33:10 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE346868D;
        Tue, 29 Nov 2022 19:33:08 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id bx10so13029221wrb.0;
        Tue, 29 Nov 2022 19:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hPe6Bo+klJPOK265AmVbyFv7LmjiWI49kHeaTnnk2us=;
        b=Ra41FxWaQ7TZL3Xt+jXN3jG3QaeKCUdiRuB1b+bG/BnjdmkTdvoWY2jXJCD2CgzAWb
         NrN55ID93XMV+MtJFn7faELFHj2SOgsHyZ0uPoodL1wo75OVUASQtG7QBQciwDDPEUM4
         q5luZRdnd2pxlGUXWbepz9tN+b9QIEyELkPe0SF7zVhQsXgp6ZOrr2dGxKENHjwudOua
         iGp6zeDo6+FNnFBhAJo23FTrgV//ciK8c3w8ZrrwGNE7/QNVag+b3HC7ZOQE+sNS71EW
         W3V28NzDOFxXLnwlXBKyjkdwmkSOysDsuW5ogAkPFK7EKd1RpozGx20V0cptjPjSlW2E
         Z1Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPe6Bo+klJPOK265AmVbyFv7LmjiWI49kHeaTnnk2us=;
        b=XyjJxWLu/OC1hT0IYtNokQMjn7gLWBGSOwsJOc2boqXcBf6Ag0YXtH2PmvKh4Ugc66
         HTzp4Yu5uRwaplM69m3NqaTkHfguXRslZxrYS3nhvfDu9qhhV141iU5Sj356x0ocRpcT
         S91J0I4F4avIqHwYQdNjcwozHOaIhK8SIsEU9F6MkTXtPWNcQx0al3uRFmwiUup5lT09
         Dft1yJ8EgXHsW6lW5V4UEXViYCy0WQTD7ksObZoRVRZCm9+oOqMxgoRtUtDDAOWE3ikO
         3eTtWvJvjaSxomkoOhkQPrNdBANUT1FgH0giNXS+KiEuBKJk+cm9j0eVgGthPmnOyLoB
         He1g==
X-Gm-Message-State: ANoB5pkCSjTIpWIarl94yYasDLIBsgCsIQQTTdA8OvmuA12D//js7IhY
        CXF37Odv0RAbty/ZGXOOOqSQJNNCnhTZ7NE/gIQ=
X-Google-Smtp-Source: AA0mqf53E+XTIUX6FDcFj7RnEiXrHfS7WV2U4RdPmRHjVcdndP/jIpzmrKCdmakupT26yJ42kMXNLaLJCs5cfSVeWNU=
X-Received: by 2002:adf:d231:0:b0:241:e2d1:ec92 with SMTP id
 k17-20020adfd231000000b00241e2d1ec92mr23510034wrh.408.1669779186919; Tue, 29
 Nov 2022 19:33:06 -0800 (PST)
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
 <9455ff51-098c-87f0-dc83-2303921032a2@redhat.com>
In-Reply-To: <9455ff51-098c-87f0-dc83-2303921032a2@redhat.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 30 Nov 2022 11:32:30 +0800
Message-ID: <CAMDZJNUdE7BKL6COF3xZD04iPn_4n5ZFmmoNB-y566QSVrct5w@mail.gmail.com>
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Waiman Long <longman@redhat.com>, Hou Tao <houtao1@huawei.com>
Cc:     Hou Tao <houtao@huaweicloud.com>, Hao Luo <haoluo@google.com>,
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

On Wed, Nov 30, 2022 at 11:07 AM Waiman Long <longman@redhat.com> wrote:
>
> On 11/29/22 21:47, Tonghao Zhang wrote:
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
> >
> > * for lockdep warning, we should use in_nmi check with map_locked.
> >
> > BTW, the patch doesn't work, so we can remove the lock_key
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c50eb518e262fa06bd334e6eec172eaf5d7a5bd9
> >
> > static inline int htab_lock_bucket(const struct bpf_htab *htab,
> >                                     struct bucket *b, u32 hash,
> >                                     unsigned long *pflags)
> > {
> >          unsigned long flags;
> >
> >          hash = hash & min(HASHTAB_MAP_LOCK_MASK, htab->n_buckets -1);
> >
> >          preempt_disable();
> >          if (unlikely(__this_cpu_inc_return(*(htab->map_locked[hash])) != 1)) {
> >                  __this_cpu_dec(*(htab->map_locked[hash]));
> >                  preempt_enable();
> >                  return -EBUSY;
> >          }
> >
> >          if (in_nmi()) {
> >                  if (!raw_spin_trylock_irqsave(&b->raw_lock, flags))
> >                          return -EBUSY;
> That is not right. You have to do the same step as above by decrementing
> the percpu count and enable preemption. So you may want to put all these
> busy_out steps after the return 0 and use "goto busy_out;" to jump there.
Yes, thanks Waiman, I should add the busy_out label.
> >          } else {
> >                  raw_spin_lock_irqsave(&b->raw_lock, flags);
> >          }
> >
> >          *pflags = flags;
> >          return 0;
> > }
>
> BTW, with that change, I believe you can actually remove all the percpu
> map_locked count code.
there are some case, for example, we run the bpf_prog A B in task
context on the same cpu.
bpf_prog A
update map X
    htab_lock_bucket
        raw_spin_lock_irqsave()
    lookup_elem_raw()
        // bpf prog B is attached on lookup_elem_raw()
        bpf prog B
            update map X again and update the element
                htab_lock_bucket()
                    // dead-lock
                    raw_spinlock_irqsave()
> Cheers,
> Longman
>


-- 
Best regards, Tonghao
