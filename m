Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F1A63CE87
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 06:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiK3FC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 00:02:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiK3FC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 00:02:27 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A3C6F820
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:02:26 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-3bfd998fa53so107144557b3.5
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 21:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AQfI9itT56aGkQXPmrJoqcBSs6MMztV/FP9e3fo34YE=;
        b=gfcNra0cbSMcEsa9a6u7N6E+fn9tqIWr7b5nZhCPU+3qqkjLm76Gro9nvAwB0oGlq6
         k6Xnd4JvXTRnEXry2GvzBvSf2gusHv164kEtbCgPrXC6zr475X/EPwsWTjr4GmzL8s0L
         3bQQVffgXdW1LqoKMsZpgDqOwaDtDtuBvxbt6Gp1fwZ0PGDLRdUAjrgcWellpuoB4SXW
         kvIsFCAIivvJMAtSwH4d4t930DuuIeLxWjNLREjM0rLNdyF5WNB8PMJuQPlxWZ+NnOAb
         463l3iBrFzdDhYNfM1tQzTnkYVtuS4J3domqcCJem7h4VdMb1wsPhuOrhx1KwrQlEMuQ
         nBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AQfI9itT56aGkQXPmrJoqcBSs6MMztV/FP9e3fo34YE=;
        b=hWlqt2V7hs6Blk+BMhB5VlIyuGtOkDIXjYc6a7Cc1nzHLycu+KF+A/7D7x8lCJcXyH
         I9bDUTOYPY6U30CRUQBD2qfN/nw7d9GXmu0uLumY2uccygAl1gWa4PlkwFKyV0wNjjvR
         1sT2h/bYxa0ZLx8la6nxPy8+SVCoM+tZrJPdCSjN2lSGIei/joB/Qz9Nz6+uJzZ2pXos
         S7sFB70eDe5ALME5kQeS+NpG/Ere2X6uyiDtdiurvhuxoud9N9vrfZ6NpvJ0W1dHhSpK
         iVgpxMuvqQsG84qUm5EDHZkuZb8Hwn0hvB5IovA2CpzUQbjcfTlET/JU9TaVADIu9kdL
         5BIA==
X-Gm-Message-State: ANoB5pm+Z/HPGvoePEpDNyXwawLRiMK/dLdg/vnBKOCt+1VfT3swsUVA
        +TQK1H88buwsAIrKFrsBx/6ZOcdGePRvC6cn5TVv6g==
X-Google-Smtp-Source: AA0mqf7zVAnnD/UlTCjMZ1by0J8F4WRMqduoFzjwV2cFa/ztIR/2VbOlT17w6zKgggS27T6ehDgQSeqjUikjBpGPyVk=
X-Received: by 2002:a81:9b83:0:b0:381:2226:74ff with SMTP id
 s125-20020a819b83000000b00381222674ffmr56493985ywg.102.1669784545693; Tue, 29
 Nov 2022 21:02:25 -0800 (PST)
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
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 29 Nov 2022 21:02:11 -0800
Message-ID: <CA+khW7hsvueaRRFX3m-gxtW0A7fYEOJLfDTSTVMY-OLn_si1hQ@mail.gmail.com>
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Hou Tao <houtao@huaweicloud.com>
Cc:     Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Waiman Long <longman@redhat.com>,
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 8:13 PM Hou Tao <houtao@huaweicloud.com> wrote:
>
> On 11/30/2022 10:47 AM, Tonghao Zhang wrote:
<...>
> >         if (in_nmi()) {
> >                 if (!raw_spin_trylock_irqsave(&b->raw_lock, flags))
> >                         return -EBUSY;
>
> The only purpose of trylock here is to make lockdep happy and it may lead to
> unnecessary -EBUSY error for htab operations in NMI context. I still prefer add
> a virtual lock-class for map_locked to fix the lockdep warning. So could you use
> separated patches to fix the potential dead-lock and the lockdep warning ? It
> will be better you can also add a bpf selftests for deadlock problem as said before.
>

Agree with Tao here. Tonghao, could you send another version which:

- separates the fix to deadlock and the fix to lockdep warning
- includes a bpf selftest to verify the fix to deadlock
- with bpf-specific tag: [PATCH bpf-next]

There are multiple ideas on the fly in this thread, it's easy to lose
track of what has been proposed and what change you intend to make.

Thanks,
Hao
