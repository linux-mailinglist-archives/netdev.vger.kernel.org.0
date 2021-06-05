Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C39739CA79
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 20:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhFESUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 14:20:22 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:33362 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhFESUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Jun 2021 14:20:22 -0400
Received: by mail-lj1-f175.google.com with SMTP id o8so16054501ljp.0
        for <netdev@vger.kernel.org>; Sat, 05 Jun 2021 11:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hWseLMsHC1Tl+tjltvawHbNPgfRx7qxCEi8/dkUNOU4=;
        b=dq91qTUDZfLAHHlQj01Xackwp7mLXGslcYSqKR8QjQWjay1MPlIiBx9Q2OjLRJv3Ny
         tUvoHIhp+fIOQUEt5cgx436HWwJytvd/+6hnvkb9my5cWuHI21RlTnevNOOSMWGTQ9Xp
         QlUNP5FJUEwnP+uHbMzVIztOiIoJLIajgm2Dk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hWseLMsHC1Tl+tjltvawHbNPgfRx7qxCEi8/dkUNOU4=;
        b=WTfKNWHCoO08bVJ0hdhoxbIKuESrCrL1s7xRsOp3Nm8w25iQtTXv3iybG3qJLiHBhP
         b0VrCw03jfawudUa/DpiL6Kejt7nciOJMNLGkauqwewswALDpG/3NQOgg1tlTYlA0huQ
         I9WU2NDH/Tv/JtQwBWteIvR4zKdtwWrBizhTZzEuF4lIxTFy2eT101P2Xqjq0jTWCTzc
         LmwLbClOJB8QNIoVbMmkUs9o9Una++o60a4qabzUtwyew9qtc2nOx3wwdGNI77YVcmiF
         jLfYASm4Gm8lzNRF6GE7K14+Leuk7Hy9sxhuhWsIiDkuwdjYHcWIBg1fp2pJ7SX3gtQ0
         wfGw==
X-Gm-Message-State: AOAM532DtXJng5wLszQIyGMn1Yvjk7TrOln9AFMd6I2SoSpOODcfjy4z
        p3sj17wKEqz9g4CVO6NEZGDErRX4dLNN2zs4JuM=
X-Google-Smtp-Source: ABdhPJwc5Cof2WLIllrjl9/IiCRvqxvUpyQqTfmdZIe+HPoK6sXZ0hMZETIyvmgPaMwj143gkgmm/Q==
X-Received: by 2002:a2e:b5b0:: with SMTP id f16mr414737ljn.221.1622917040558;
        Sat, 05 Jun 2021 11:17:20 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id v7sm1033331ljj.89.2021.06.05.11.17.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Jun 2021 11:17:18 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id i10so19079848lfj.2
        for <netdev@vger.kernel.org>; Sat, 05 Jun 2021 11:17:18 -0700 (PDT)
X-Received: by 2002:a05:6512:374b:: with SMTP id a11mr6305938lfs.377.1622917038058;
 Sat, 05 Jun 2021 11:17:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210517092006.803332-1-omosnace@redhat.com> <CAHC9VhTasra0tU=bKwVqAwLRYaC+hYakirRz0Mn5jbVMuDkwrA@mail.gmail.com>
 <01135120-8bf7-df2e-cff0-1d73f1f841c3@iogearbox.net> <CAHC9VhR-kYmMA8gsqkiL5=poN9FoL-uCyx1YOLCoG2hRiUBYug@mail.gmail.com>
 <c7c2d7e1-e253-dce0-d35c-392192e4926e@iogearbox.net> <CAHC9VhS1XRZjKcTFgH1+n5uA-CeT+9BeSP5jvT2+RE5ougLpUg@mail.gmail.com>
 <2e541bdc-ae21-9a07-7ac7-6c6a4dda09e8@iogearbox.net> <CAHC9VhT464vr9sWxqY3PRB4DAccz=LvRMLgWBsSViWMR0JJvOQ@mail.gmail.com>
 <3ca181e3-df32-9ae0-12c6-efb899b7ce7a@iogearbox.net> <CAHC9VhTuPnPs1wMTmoGUZ4fvyy-es9QJpE7O_yTs2JKos4fgbw@mail.gmail.com>
 <f4373013-88fb-b839-aaaa-3826548ebd0c@iogearbox.net> <CAHC9VhS=BeGdaAi8Ae5Fx42Fzy_ybkcXwMNcPwK=uuA6=+SRcg@mail.gmail.com>
 <c59743f6-0000-1b15-bc16-ff761b443aef@iogearbox.net> <CAHC9VhT1JhdRw9P_m3niY-U-vukxTWKTE9q6AMyQ=r_ohpPxMw@mail.gmail.com>
 <CAADnVQ+0bNtDj46Q8s-h=rqJgZz2JaGTeHpbmof3e7fBBQKuDQ@mail.gmail.com> <64552a82-d878-b6e6-e650-52423153b624@schaufler-ca.com>
In-Reply-To: <64552a82-d878-b6e6-e650-52423153b624@schaufler-ca.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 5 Jun 2021 11:17:02 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiUVqHN76YUwhkjZzwTdjMMJf_zN4+u7vEJjmEGh3recw@mail.gmail.com>
Message-ID: <CAHk-=wiUVqHN76YUwhkjZzwTdjMMJf_zN4+u7vEJjmEGh3recw@mail.gmail.com>
Subject: Re: [PATCH v2] lockdown,selinux: avoid bogus SELinux lockdown
 permission checks
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 5, 2021 at 11:11 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> You have fallen into a common fallacy. The fact that the "code runs"
> does not assure that the "system works right". In the security world
> we face this all the time, often with performance expectations. In this
> case the BPF design has failed [..]

I think it's the lockdown patches that have failed. They did the wrong
thing, they didn't work,

The report in question is for a regression.

THERE ARE NO VALID ARGUMENTS FOR REGRESSIONS.

Honestly, security people need to understand that "not working" is not
a success case of security. It's a failure case.

Yes, "not working" may be secure. But security in that case is *pointless*.

              Linus
