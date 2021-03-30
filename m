Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC2734F4F3
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 01:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233295AbhC3XRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 19:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbhC3XQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 19:16:57 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C47AC061574;
        Tue, 30 Mar 2021 16:16:57 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id r20so21700998ljk.4;
        Tue, 30 Mar 2021 16:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EWsgIY/KITNt+W2mkHu5D1R/oQVu42eT5oqQDwOADXc=;
        b=tBSG5Wgi9/tBMW9beWfY+aRlBjJplJr7iUTD5jTJMnfJEj7kGyHp9amEnNyujCAbRr
         vLmvAVyt23FvuHZvZbtv8O+ND0wE1MT4EDZrRHg+bOjAToRFkX9pQRjmotQUCm8wmpB7
         wtUiJIS542ias7HYx38wHPJ7cgp7rP40SD3rpAKN4Hle6IgykMHf0OKU9RqdqwLQHbyJ
         wBW1dDoQ/qpbUe6YV/lY7fv+5ANQ2FrH824WzSoOn1MyxnNvEBVtYPgCTKsJzOkdDNKb
         8Z+wz9QeGwrKR145Fs2H0eANh+uFERMXydsGg4n0rP19AuvXWci3QgE+K43ByiukVri2
         w1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EWsgIY/KITNt+W2mkHu5D1R/oQVu42eT5oqQDwOADXc=;
        b=eh0Lknn/FfSGRbGaRmooMOXwIAZVb6khEdDoXHwX/FsnKOT5OrayzhquG1tsZy2uot
         o8nKYd9hHFLWbsZrVecWBDJRy3Zn4BapY4LYqtY2ob5ONfWTxDo8T1NlBHO953u3/Zx8
         Rd4Ysa5kkCyUt3IBLpPFGyF9YmxpdZsZMsIphxwn7+uS0fd2a60PdwIU3t//tQPOn/nn
         2mDdQPTlCndWT1MD90gLuHKBuISqDJSoqIqFmPWFSEAl3tVDgEmwNlHo7VP9+ozSjOtF
         5HMvAvOpZtJboy5gvoJbEVnR5k03CPv+Na9S8xzhIF0kO7AzV1ry751JEw0wdjFoToMV
         IjHA==
X-Gm-Message-State: AOAM5339mBCp6Dqjkh3jHV5ku2VTsfvaIroKovxhSXO4tNuMYK3duo6E
        6KDFrwBTMyKYmMAB5eh7Q4h4bQG35mbuYdBxWrk=
X-Google-Smtp-Source: ABdhPJwR/ZiW/Ib8se1El1ywPeNU/uY0j6KlzbDaUWk8s1HXzKWJg38nH35PepRkwR6tApzoIOlUOKH5CD9Zp4fTyls=
X-Received: by 2002:a2e:900b:: with SMTP id h11mr259742ljg.258.1617146215959;
 Tue, 30 Mar 2021 16:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <20210330223748.399563-1-pctammela@mojatatu.com>
In-Reply-To: <20210330223748.399563-1-pctammela@mojatatu.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 30 Mar 2021 16:16:44 -0700
Message-ID: <CAADnVQK+n69_uUm6Ac1WgvqM4X0_74nXHwkYxbkWFc1F5hU98Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf: check flags in 'bpf_ringbuf_discard()'
 and 'bpf_ringbuf_submit()'
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 3:54 PM Pedro Tammela <pctammela@gmail.com> wrote:
>
>  BPF_CALL_2(bpf_ringbuf_submit, void *, sample, u64, flags)
>  {
> +       if (unlikely(flags & ~(BPF_RB_NO_WAKEUP | BPF_RB_FORCE_WAKEUP)))
> +               return -EINVAL;
> +
>         bpf_ringbuf_commit(sample, flags, false /* discard */);
> +
>         return 0;

I think ringbuf design was meant for bpf_ringbuf_submit to never fail.
If we do flag validation it probably should be done at the verifier time.
