Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2662A88E3
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 22:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732397AbgKEVW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 16:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732376AbgKEVWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 16:22:24 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE2DC0613CF;
        Thu,  5 Nov 2020 13:22:24 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id f6so2621164ybr.0;
        Thu, 05 Nov 2020 13:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yYTJTg53Xg72p1C4V5hEjWcSKiZADCrOXW0m2fuo9GE=;
        b=eiiijZeoUcBS817KDPsT9SKp76IEUMs+bkmu5gYhjVGvRSi1aqfxFUHeeZlzcj9Zhd
         iClnf1Y5MPW6JeJ4Bm7yq5cOjKPQr3BX3y5+ErkTCByzpaF0SLTR3TOnSu0tt2XdYoYs
         8VNd5Bb6/x7REIO0l6/0pv/ZHV9P4Zenv8k71bhenyPxXPT8uaVspJYvmoAielZ/vMxa
         dwpNW93MJHpbwemSPrhEKF/lnRJXOjdqX3OsbkLslUCZWr+tvNlz10NyBK/Uyle8n64O
         kRo8qFV9Lz9nRjJjFw/88KR8L3nDm7G9vZB6rAeul7a/uvF2zSgl1V+kgdD06hKaxZOZ
         USAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yYTJTg53Xg72p1C4V5hEjWcSKiZADCrOXW0m2fuo9GE=;
        b=RK5p4S1tsicHcXqcDiJLpaFuhtoGHKwb5HvF37bV6Djo9bzS7nc0QeReZ4uoerHDYW
         0lpl30kDcQY/9JYaOrJVQUbV5voS/fTB3GKB4geJyEa7tLmtqMffu8FeiIq4CKwyvjR4
         3lHyhGXgpDw+/9g2+ET4QDiwEIevlzPZVwK7d26+koCEg6mpoO8R4XVmHJb23mVOT1IC
         Tpocy+V4nr4mnHKotTTyNjhMeDk2UDr6k1jEwn9qVA2B340HGMezAXywALkuirpS1Pc6
         Se2GY+7NAZmPOGtSVwYIlS0wRD5jZpRlZYpUxTZOnK2e+LH7ihEQ6f23NYQraBbQYN5o
         gV+A==
X-Gm-Message-State: AOAM531lkHKXIPTvjnloGWfhHQTzaNAp1erVbF37mAVEDkJ9ihOpsY9G
        kZGd53Dj7dwk+SEXciFnLonEl7f+h+QtAge8ifM=
X-Google-Smtp-Source: ABdhPJzjVmcUWNfVdInEO4HN37HghE7iCcS5LufYOXUcvmtgdykotx8xDuT03Aw36bGkH5MEZWV37+tcvXHIx7ZFOwA=
X-Received: by 2002:a25:afc1:: with SMTP id d1mr5986684ybj.27.1604611343541;
 Thu, 05 Nov 2020 13:22:23 -0800 (PST)
MIME-Version: 1.0
References: <20200423195850.1259827-1-andriin@fb.com> <20201105170202.5bb47fef@redhat.com>
In-Reply-To: <20201105170202.5bb47fef@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 5 Nov 2020 13:22:12 -0800
Message-ID: <CAEf4Bzb7r-9TEAnQC3gwiwX52JJJuoRd_ZHrkGviiuFKvy8qJg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] bpf: make verifier log more relevant by default
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 8:02 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> On Thu, 23 Apr 2020 12:58:50 -0700, Andrii Nakryiko wrote:
> > To make BPF verifier verbose log more releavant and easier to use to debug
> > verification failures, "pop" parts of log that were successfully verified.
> > This has effect of leaving only verifier logs that correspond to code branches
> > that lead to verification failure, which in practice should result in much
> > shorter and more relevant verifier log dumps. This behavior is made the
> > default behavior and can be overriden to do exhaustive logging by specifying
> > BPF_LOG_LEVEL2 log level.
>
> This patch broke the test_offload.py selftest:
>
> [...]
> Test TC offloads work...
> FAIL: Missing or incorrect message from netdevsim in verifier log
> [...]
>
> The selftest expects to receive "[netdevsim] Hello from netdevsim!" in
> the log (coming from nsim_bpf_verify_insn) but that part of the log is
> cleared by bpf_vlog_reset added by this patch.

Should we just drop check_verifier_log() checks?

>
> How can this be fixed? The log level 1 comes from the "verbose" keyword
> passed to tc, I don't think it should be increased to 2.
>
> On a related note, the selftest had to start failing after this commit.
> It's a bit surprising it did not get caught, is there a bug somewhere
> in the test matrix?

test_progs is the only test runner that's run continuously on every
patch. libbpf CI also runs test_maps and test_verifier. All the other
test binaries/scripts rely on humans to not forget about them. Which
works so-so, as you can see :)

>
> Thanks,
>
>  Jiri
>
