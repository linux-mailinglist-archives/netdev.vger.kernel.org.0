Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9231DC561
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 04:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgEUCvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 22:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbgEUCvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 22:51:02 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49F7C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 19:51:00 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id v16so6424243ljc.8
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 19:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mfPmF8CZW8EXsBz+QWv7G7NwnU9zJQy+FUFmHM3B2mE=;
        b=ut9X6Y4aY/BBoqcE4I/bMDJscYI+ssyMALJE7nSNW8pUhCt6oxF8faCKhGqXVSC1hA
         7KJvY1WAkWdtCWSkMOci2E6DnBwk28JPT4Abn5NV9Wds+JsHuVPTD1UE9jEu/txFM/bU
         ciUT2qYOKh13+IhFMCVJrYIf7LJ5gWfJpjD0opr1/cZBXvXrPc87FjM7pSKica9QCrOj
         CDPR8AgGKde+/h3gPBNA84Ml7u3C1Q93bEr4F4WIe6ElkYghp5OpQyOjFY7+EVESoUyu
         Hv/NjCTRBccxgWPEZtOHKrLuWh4cBs2q60AWNPUPtdKdJUVqGbke6DnIrObRILJ3f9GM
         AqGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mfPmF8CZW8EXsBz+QWv7G7NwnU9zJQy+FUFmHM3B2mE=;
        b=qU6F5J1OvFvWcFDfbdtjaqNO3oRBshjeYaP3uV22QdF2EwgDT5mNn6tVh/yyiWe9je
         OEU/se6UUfaSIFRUTCe/3y+DPIXpQ2uQGsPhtctTIwZuGC37lJnm9pc+ul8swNDd1AI8
         wtSgjbRet6yxovXkM+xD0tEanT0UdbnGj+RcRWmBLVyOTneNu0XTAeEWFuRmUe3kjvun
         B50OHKIxCYPLi8HJIVhf6drhUiyEmKrCd/8cKykXpoq9zc0rM3SQA+3PBi/mMPOsdl6f
         zzwtcZA+40MhT4WLv5CA1wPXBZRRda9opUWoatwuhY5+uG/c9Z6jW7MuQyv0U7Gb+cyz
         OjFQ==
X-Gm-Message-State: AOAM5312IOT5rWszmbDhSvec9DP06nHYr0ORHmLXruFVfjwbfvaey29o
        ad/2WEzxJ7lggwGTeog/h93KilMGwdisDaLs5hekLw==
X-Google-Smtp-Source: ABdhPJwfbj9o5yrn6xw2Lu2H3OcYejKsUW8kSMaSfUHPzs2h2gQlO0YtY/Jp0YSHRxYkttkk5WxyMfdYopr0Y6DLOf4=
X-Received: by 2002:a2e:91c3:: with SMTP id u3mr2071288ljg.365.1590029458705;
 Wed, 20 May 2020 19:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200519053824.1089415-1-andriin@fb.com>
In-Reply-To: <20200519053824.1089415-1-andriin@fb.com>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 21 May 2020 04:50:32 +0200
Message-ID: <CAG48ez2HZfjCKG+coVq2k9eE_Hm0rsdQE=O=5nVyKL80QncVZA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: prevent mmap()'ing read-only maps as writable
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 7:38 AM Andrii Nakryiko <andriin@fb.com> wrote:
> As discussed in [0], it's dangerous to allow mapping BPF map, that's meant to
> be frozen and is read-only on BPF program side, because that allows user-space
> to actually store a writable view to the page even after it is frozen. This is
> exacerbated by BPF verifier making a strong assumption that contents of such
> frozen map will remain unchanged. To prevent this, disallow mapping
> BPF_F_RDONLY_PROG mmap()'able BPF maps as writable, ever.
>
>   [0] https://lore.kernel.org/bpf/CAEf4BzYGWYhXdp6BJ7_=9OQPJxQpgug080MMjdSB72i9R+5c6g@mail.gmail.com/
>
> Suggested-by: Jann Horn <jannh@google.com>
> Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Reviewed-by: Jann Horn <jannh@google.com>
