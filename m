Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA7E63C898
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237067AbiK2Tj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiK2TiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:38:12 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6B26E54C
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:36:35 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-3876f88d320so149394567b3.6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1bmuvgUk4OTyzS0cP/IZYe3bJ8nPbcieDdEYGxb93AQ=;
        b=ntXkEtvhVc/YnzEWpIUFZAj9rJeK2awgv14ux5liOk6ARFQ7QDmkY9WvWMn6EqOFU2
         n0pA2iVfSHzd+Pt8sMCAWm0CK60nTMK4dvyiY3Poqo2zPHY5NUEYZa1aSGTCWnh4Ym/6
         FI1Te3VLkqFV+1i2lu4M5DO0yWJBf5cq8aVFdwOJAFQ1nSnBIKa0RJYKkq24GZBrTmSk
         yg4RMe0/JV7RQAWFzsZR5jn7ePqPZQ1dqN2W0hi60e9o8c8NItwV6vTujonY0uxJhbCT
         cnopifUGk1l7GXsYdCiKrI8P9J0VYSn8g3mZvmOviAWx1ux5LIcU8jKeqjk5RhCWwhe0
         ByyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1bmuvgUk4OTyzS0cP/IZYe3bJ8nPbcieDdEYGxb93AQ=;
        b=7Hliz1H2H2jPaQaOt8EDuWzBGChlDodBHbOXb0/P5KFUPVoVziXioc8slaMAV92f3v
         z/zei7C68RQx2K4iQZHDtRExmvgnk09qcwjlHYiSF8Z1SGyEln7/1fc8RGgp6oNf6FDv
         Hgxxpt5aEm5ByxbFJP20yg9bJYjE1dFlezJP24tYrjVKyHCHq/xtFVOKf1179GfJcuEw
         Ww+CAza6KQ7EHVs3CNq1JRTReltXcVmDnsiR7mmI+G3omSvWeaCrLWwvFkWGBvMx5Lwx
         6dMQt7K8rG0PazK7NKRxDETOtTMZ6jjRwS12rtq8b9xLXKqcY76KMO6vSaNeZmsS0eYG
         27Nw==
X-Gm-Message-State: ANoB5pnDkC0k5bxU+lafyQqWSsXzbrUAzrTD63+f2qZPNj8wqW/nopV1
        uHGwnxuwcH1G5eVORKZ9H2ON7DJfZ+PFrzRYcApPEA==
X-Google-Smtp-Source: AA0mqf5x/Ru6NTcJ+v1hnT7joZwXyMEwRPWqS7UveTWznS2uwIh9Ynrw+Ypu1vGW+xSyi3PXx0C43GetrUd2VejyV+k=
X-Received: by 2002:a0d:f0c5:0:b0:373:4bf9:626e with SMTP id
 z188-20020a0df0c5000000b003734bf9626emr37357556ywe.173.1669750594587; Tue, 29
 Nov 2022 11:36:34 -0800 (PST)
MIME-Version: 1.0
References: <41eda0ea-0ed4-1ffb-5520-06fda08e5d38@huawei.com>
 <CAMDZJNVSv3Msxw=5PRiXyO8bxNsA-4KyxU8BMCVyHxH-3iuq2Q@mail.gmail.com>
 <fdb3b69c-a29c-2d5b-a122-9d98ea387fda@huawei.com> <CAMDZJNWTry2eF_n41a13tKFFSSLFyp3BVKakOOWhSDApdp0f=w@mail.gmail.com>
 <CA+khW7jgsyFgBqU7hCzZiSSANE7f=A+M-0XbcKApz6Nr-ZnZDg@mail.gmail.com>
 <07a7491e-f391-a9b2-047e-cab5f23decc5@huawei.com> <CAMDZJNUTaiXMe460P7a7NfK1_bbaahpvi3Q9X85o=G7v9x-w=g@mail.gmail.com>
 <59fc54b7-c276-2918-6741-804634337881@huaweicloud.com> <541aa740-dcf3-35f5-9f9b-e411978eaa06@redhat.com>
 <Y4ZABpDSs4/uRutC@Boquns-Mac-mini.local> <Y4ZCKaQFqDY3aLTy@Boquns-Mac-mini.local>
In-Reply-To: <Y4ZCKaQFqDY3aLTy@Boquns-Mac-mini.local>
From:   Hao Luo <haoluo@google.com>
Date:   Tue, 29 Nov 2022 11:36:23 -0800
Message-ID: <CA+khW7hkQRFcC1QgGxEK_NeaVvCe3Hbe_mZ-_UkQKaBaqnOLEQ@mail.gmail.com>
Subject: Re: [net-next] bpf: avoid hashtab deadlock with try_lock
To:     Boqun Feng <boqun.feng@gmail.com>
Cc:     Waiman Long <longman@redhat.com>, Hou Tao <houtao@huaweicloud.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
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
        LKML <linux-kernel@vger.kernel.org>
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

On Tue, Nov 29, 2022 at 9:32 AM Boqun Feng <boqun.feng@gmail.com> wrote:
>
> Just to be clear, I meant to refactor htab_lock_bucket() into a try
> lock pattern. Also after a second thought, the below suggestion doesn't
> work. I think the proper way is to make htab_lock_bucket() as a
> raw_spin_trylock_irqsave().
>
> Regards,
> Boqun
>

The potential deadlock happens when the lock is contended from the
same cpu. When the lock is contended from a remote cpu, we would like
the remote cpu to spin and wait, instead of giving up immediately. As
this gives better throughput. So replacing the current
raw_spin_lock_irqsave() with trylock sacrifices this performance gain.

I suspect the source of the problem is the 'hash' that we used in
htab_lock_bucket(). The 'hash' is derived from the 'key', I wonder
whether we should use a hash derived from 'bucket' rather than from
'key'. For example, from the memory address of the 'bucket'. Because,
different keys may fall into the same bucket, but yield different
hashes. If the same bucket can never have two different 'hashes' here,
the map_locked check should behave as intended. Also because
->map_locked is per-cpu, execution flows from two different cpus can
both pass.

Hao
