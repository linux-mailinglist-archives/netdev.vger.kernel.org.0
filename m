Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC4532B9D59
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgKSWFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgKSWFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:05:23 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14138C0613D4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:05:23 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id e139so10567443lfd.1
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=caVbQJgTNUd3ZyBW7a7yHO/mVe+/+dynQ8Kf/1ZeYWM=;
        b=jZ3KTQBKpps0OPiXvYOFLRGYnVQSV8UQx5Naaeo4ejKpoO68Nap6Q/ZOeoAuRo9dJI
         +k6J/WmjgoZ5TEHw9YkYFm0Oh5vB1p4PAYgmRroQD1P8MKDua1PuOix1olFyLDSyx/o5
         ltLlZKvBklVAuDrt9VCsiX6xp3ANEd8LHmnIk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=caVbQJgTNUd3ZyBW7a7yHO/mVe+/+dynQ8Kf/1ZeYWM=;
        b=GJfdtQ6FfZXYRhv0UUGvt+zIuUTh1po8NbV1Daua949dy0d+XAO55ASLmoZkR3RTOw
         fvzhe6g0blEP0s1cnqfr+ZMoupp5eOOFY7LZkKBOJPRL4gkYXet4PplV5H4ARZL+KN/g
         HZ2wfyN7pqsN1LA3JkSF9pA9g9WIGMMYtbvmoF+A5yNCxlSn/E55CzZSIxS/LZZfK77H
         NVdVhGb0P3NRXfjdo4xp8bXyVMpBuFE01FMObFmb7LfZqAuszz4mS4X079msb29ZhqZc
         RRbw8nTjyjtAB/vPJIHJeZ9PBdvjcDpbuJrTDoOyx0FsYIbtEcwR427gaQjTTWjajSxV
         do7Q==
X-Gm-Message-State: AOAM531cNM7fELU05o8sFbqLp1fLbng6axqryHc3ckdnugX3g40ei3dq
        gUOjLGT6ZbALmdOrPYSO2GM9LG4dW/it8xRNcW3R/A==
X-Google-Smtp-Source: ABdhPJykoD4e40Ht9VbmfCWlQEro37Hq5PyVDkPKQiE1le37+k8HUvT460q+r8/KCm8efY+hU9FmjEhGTBZs65Br5mo=
X-Received: by 2002:ac2:5591:: with SMTP id v17mr6402331lfg.562.1605823521321;
 Thu, 19 Nov 2020 14:05:21 -0800 (PST)
MIME-Version: 1.0
References: <20201119162654.2410685-1-revest@chromium.org> <20201119162654.2410685-3-revest@chromium.org>
In-Reply-To: <20201119162654.2410685-3-revest@chromium.org>
From:   KP Singh <kpsingh@chromium.org>
Date:   Thu, 19 Nov 2020 23:05:10 +0100
Message-ID: <CACYkzJ6rPmuOQbHYJyDGS77WFqZ1igHnuXyR=Go8Vpw=_h-TDg@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] bpf: Expose bpf_sk_storage_* to iterator programs
To:     Florent Revest <revest@chromium.org>
Cc:     bpf <bpf@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Florent Revest <revest@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 5:27 PM Florent Revest <revest@chromium.org> wrote:
>
> From: Florent Revest <revest@google.com>
>
> Iterators are currently used to expose kernel information to userspace
> over fast procfs-like files but iterators could also be used to
> manipulate local storage. For example, the task_file iterator could be
> used to initialize a socket local storage with associations between
> processes and sockets or to selectively delete local storage values.
>
> This exposes both socket local storage helpers to all iterators.
> Alternatively we could expose it to only certain iterators with strcmps
> on prog->aux->attach_func_name.

Since you mentioned the alternative here, maybe you can also
explain why you chose the current approach.
