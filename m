Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F69646388
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiLGV6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLGV6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:58:36 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CBB7B577;
        Wed,  7 Dec 2022 13:58:35 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id fc4so17126881ejc.12;
        Wed, 07 Dec 2022 13:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GlY7YKUGk/JMgLNRQtXaOgjE8d+PC1cuzdEgWl3757o=;
        b=BAyzgnrHLyxAF50YHNrs5KIo425dz9za57F2c/lVxwhJVBKsq4H9WgK/QAusXdE4gf
         qaISO8uNVXsDB1HbxSZghn8+QvZROOKatVWuzRd7uvJTJhlAbtq4aYmTOsetF18Ze3J3
         9fslDRY8G6PliNo1sXAvR57/+yW4Zx3BHvIUKbQc7nzTyQ8nfY/T1OK/QCn5m5AlsGhH
         hcj5wE1js3uMvNPACLPFMxGDX2chQ10t8pIPYouYBMLrOaKNZStqS0Q+NbyILzYyapcB
         14AFzI2/rEA8XAhma/ch9/HhPOPmZQwUOqC43c961sq6P2ci73nwo8j5aBycOgVapQ8B
         Mv8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GlY7YKUGk/JMgLNRQtXaOgjE8d+PC1cuzdEgWl3757o=;
        b=BJUJxOIY6XxPe3CZsB8ygUO+Vle5jetaxtazoXIabgxvNDYs6iNTMGOf0yjz8Fm8R+
         2pWU5I43DH5HjoMjjn/5lfQ/3x+YB8B7rO/Wby27+uECX5iKcYrZLLVnRK6IExBdh6fr
         eeEiR/eL+9hfdOJPqG1TD+/5zrYEqb/JL1lkYId0BNKmqzrkOrwr57O+vZteMzJlxsm2
         XUGDDgVkzt3MqJZDY+esO82dhkk/YTsB+KvPO8NKJS9r0ARaZfBZaC2egzza+1P0SDU2
         v/4I+ELlB0Jfbl4Fw/OPYha24ZO3x2+IvPX7Ic20Zm8xnjMqm1lv7pvf+PFaJruEfVR3
         a7OA==
X-Gm-Message-State: ANoB5pk4nPgIcol6h9PMOgLPCjGbdDTHXQtg3TY/7+oqM0x19CPHOpMR
        2HEr8IwSbo7Ble82QCVNnCUjo/W9q0+VC5QuJ+ztS5if
X-Google-Smtp-Source: AA0mqf4bKbYuwaeliXo6v5rh3dpgz6nAhFpmLnFw2/g1PqqFtKB3fCepDVQWgiYoe+GPT9+c6zTTAHefuEhzZ6BpLMA=
X-Received: by 2002:a17:907:76cb:b0:7c0:870b:3dda with SMTP id
 kf11-20020a17090776cb00b007c0870b3ddamr33725550ejc.676.1670450313417; Wed, 07
 Dec 2022 13:58:33 -0800 (PST)
MIME-Version: 1.0
References: <20221206145936.922196-1-benjamin.tissoires@redhat.com>
 <20221206145936.922196-2-benjamin.tissoires@redhat.com> <CAADnVQKTQMo3wvJWajQSgT5fTsH-rNsz1z8n9yeM3fx+015-jA@mail.gmail.com>
 <CAO-hwJJAGkcJnZ-q28zKBCX49cvSmp5b1qWJ33i0Ma-zZAi8ZQ@mail.gmail.com>
In-Reply-To: <CAO-hwJJAGkcJnZ-q28zKBCX49cvSmp5b1qWJ33i0Ma-zZAi8ZQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Dec 2022 13:58:22 -0800
Message-ID: <CAADnVQLAOmJ413X9C=RHzBq1qd-oNXzuFp6StVOKcXHguSodiA@mail.gmail.com>
Subject: Re: [PATCH HID for-next v3 1/5] bpf: do not rely on
 ALLOW_ERROR_INJECTION for fmod_ret
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Wed, Dec 7, 2022 at 6:57 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> On Tue, Dec 6, 2022 at 9:48 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Dec 6, 2022 at 6:59 AM Benjamin Tissoires
> > <benjamin.tissoires@redhat.com> wrote:
> > >
> > > The current way of expressing that a non-bpf kernel component is willing
> > > to accept that bpf programs can be attached to it and that they can change
> > > the return value is to abuse ALLOW_ERROR_INJECTION.
> > > This is debated in the link below, and the result is that it is not a
> > > reasonable thing to do.
> > >
> > > Reuse the kfunc declaration structure to also tag the kernel functions
> > > we want to be fmodret. This way we can control from any subsystem which
> > > functions are being modified by bpf without touching the verifier.
> > >
> > >
> > > Link: https://lore.kernel.org/all/20221121104403.1545f9b5@gandalf.local.home/
> > > Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> >
> > BPF CI couldn't do its job because of a merge conflict.
> > CI only tries to apply the whole series.
> > But I tested the patch 1 manually.
> > Everything is green on x86-64 and the patch looks good.
> >
> > Acked-by: Alexei Starovoitov <ast@kernel.org>
> >
> > Please send the set during the merge window.
> > If not we can take just this patch,
> > since the series from Viktor Malik would need this patch too.
> >
>
> Thanks a lot for the quick review/tests Alexei.
>
> I have now taken this patch and the next into the hid tree.
>
> I actually took this patch through a branch attached to our hid.git
> master branch so compared to Linus, it only has this one patch. I also
> tagged (and signed) that very same branch with "for-alexei-2022120701"
> in case you also want to bring this one in through the bpf tree too.

I didn't find such a branch in your tree, but found that tag
and pulled into bpf-next.
Thanks!
