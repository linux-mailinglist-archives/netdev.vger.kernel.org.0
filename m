Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F18440019
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 18:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbhJ2QPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 12:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhJ2QPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 12:15:02 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4148C061714
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 09:12:33 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id f3so13839033lfu.12
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 09:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j7zbgZHDKtsXiybM6IPBrydvS6VzArmkgJP+XJA+q3o=;
        b=N7E7kD7SO6XMgzKiV9CEhACjob4NtxQtBLF8SuPY4D18ZwAmBVd/1my4Ab8wn9N6pE
         6gkcgBsgGV0197ku+dLvLIqTKHTCRMaAS3mc5v8gXW3PpJATdbOM0u/ZzizYKxVDgdmk
         95eG0ds7bXEIvgqMytap2F+8tgXIBOgUSPZlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j7zbgZHDKtsXiybM6IPBrydvS6VzArmkgJP+XJA+q3o=;
        b=y8v7zQeI955GMzKGYIfINJNFISSiSIRCcroWgm+jEEawM5/+hxQfYEGQMq4vXw6O+T
         obauT/hA6+5h3qjoZsdTkYPhq6e4Y/9K8KWjlbGkGoUfNEja4zQjFN+DcEN9jn1c/Xul
         EwTVQjQKPzmT+SOz2xURQUn8rsa9BFSuW69Ru+3iy+uHiU/XMjqDTYEyVg320EzlZGSq
         20Uz7NFc8LUGhZ8/bEUyqJRe3rhhp7WRWuadTzV39LYmmgTgTQU4n18O1lmaSNX5sGe2
         6E3qMLbi7GVlpI92LjIR+aoJ2dvUf0dFSjaspgfLJcuoHK9H/5NDV93j76imzwITG5IQ
         tfhw==
X-Gm-Message-State: AOAM5303y31M1M7pj70fCoADvnicHb9c7c+uwyst2HRGVzK3wdsYgm3i
        CM1BiH+WE4Zf7dFt/hv72DK3P3Z5ZOf31bL2GcsWhw==
X-Google-Smtp-Source: ABdhPJy31SCB2gaQpLv+o80ZkBwICMfuT5eqnX5NT1sHDQqq+eNINFqEwbLugosNMzkqxkmBMH7sZw2LNhttFOP+J60=
X-Received: by 2002:ac2:4823:: with SMTP id 3mr4268821lft.56.1635523951944;
 Fri, 29 Oct 2021 09:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
In-Reply-To: <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Fri, 29 Oct 2021 11:12:20 -0500
Message-ID: <CAHap4zt7B1Zb56rr55Q8_cy8qdyaZsYcWt7ZHrs3EKr50fsA+A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] libbpf: Implement BTF Generator API
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Tracing progs will be peeking into task_struct.
> To describe it in the reduced BTF most of the kernel types would be needed,

That's the point of our algorithm. If a program is only accessing
'pid' on 'task_struct' we'll generate a BTF representation of
task_struct that only contains the 'pid' member with the right offset,
other members are not included and hence we don't need to carry on all
those types that are not used by the program.

> Have you considered generating kernel BTF with fields that are accessed
> by bpf prog only and replacing all other fields with padding ?

Yeah. We're implicitly doing it as described above.

> I think the algo would be quite different from the actual CO-RE logic
> you're trying to reuse.

I'm not 100% sure it's so easy to do without reimplementing much of
the actual CO-RE logic. We don't want to copy all type members but
only the ones actually used. So I'm not sure if Andrii's idea of
performing the matching based only on the type name will work. I'll
try to get deep into the details and will be back to you soon.

> If CO-RE matching style is necessary and it's the best approach then please
> add new logic to bpftool. I'm not sure such api would be
> useful beyond this particular case to expose as stable libbpf api.

I agree 100%. Our goal is to have this available on bpftool so all the
community can use it. However it'd be a shame if we can't use some of
the existing logic in libbpf.
