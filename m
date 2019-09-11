Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED4AAB04DF
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 22:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730545AbfIKUaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 16:30:09 -0400
Received: from mail-vs1-f47.google.com ([209.85.217.47]:41893 "EHLO
        mail-vs1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729186AbfIKUaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 16:30:08 -0400
Received: by mail-vs1-f47.google.com with SMTP id g11so14299119vsr.8
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 13:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xR7hYe4cgaeRTX0oM2Y5DNYIJaqcoPBbVI2nTGUyj3I=;
        b=vtFM/wNP1cbgEAHfwr2tSf+02EhyZPlQI2hH6LIOAujE4b2dV5EHR8S/+jHn7mNh7A
         dRrbfqGWSphPeXOKuDHFAF8dSowLXFxxGC4FbANYtLHrM3nrSZyQ9oaRw41A+IdO0sj4
         1GAOBXo65OWgs2wVFbCoeMw+Yr371hSazFG6BZkeJuALvPJ1xKYzBUlq/rURdG4QGAn5
         VpjVi4GSiISma6lDJL/8xgI99P1xYQK9Y2lIfMB5ekxjPDcR8AXmp+X5hpzQCI25CfEV
         UYmYj407XQ1sV9i0WKofsgpXso5FGO6+l/h7TjL9t2k3GdcZM7+HsiugG/KPZnyQn0qg
         st1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xR7hYe4cgaeRTX0oM2Y5DNYIJaqcoPBbVI2nTGUyj3I=;
        b=j7RZbbvU/IWFp454+QVPTkDe2ayvEIaWHcIt5LAyuJNT747kRRaiPaVwjhPqu0Uocz
         OKOet/3W5aQPsuH8cXOHQXjVv2TrzvukeRf95TfQ6nRoTBu/GW6eNfgXItx6nvgeVJvv
         9jrUVSoznjS0lZSW+I0m/e0I4fLPJfDg+FBBe5Q8lXx3XQ5yu3b+T9I4YCdZe86M4f5L
         v38suspvxHNLHgliq/jqiM8u5hZz3eT0TCoAU3VkYZHZfgqs5XG70Iq/pm3K0TfyD4kL
         pT6RXnk3Jcfaqj8eJxzGYLcEOay0IjXVlqY7x2BT65VPrih8B429E8UI4BumitzX6awA
         Kp3Q==
X-Gm-Message-State: APjAAAV4nZBRdAObThCBFr2fHIrp3Ws2JavXwKFPFS+Mk3j/1fZwEoc4
        IQLlg0hqgTWByTXNKx5cI1N/s6YUAGSm8bkIh+OrkQ==
X-Google-Smtp-Source: APXvYqyti/BEpWt9VUm8RNlb1/OJ26SyVNVAoBMuidSB+6SFTYNd400N8tvIRMKnHXXEojW0z2LCqaCiSvDhOTHTQ8U=
X-Received: by 2002:a67:6d06:: with SMTP id i6mr21648978vsc.5.1568233807241;
 Wed, 11 Sep 2019 13:30:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190909223236.157099-1-samitolvanen@google.com>
 <4f4136f5-db54-f541-2843-ccb35be25ab4@fb.com> <20190910172253.GA164966@google.com>
 <c7c7668e-6336-0367-42b3-2f6026c466dd@fb.com>
In-Reply-To: <c7c7668e-6336-0367-42b3-2f6026c466dd@fb.com>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Wed, 11 Sep 2019 13:29:56 -0700
Message-ID: <CABCJKueLLs7nUFnQ-BHWE3cPJncWACy2tG196n01QPpShUwKEg@mail.gmail.com>
Subject: Re: [PATCH] bpf: validate bpf_func when BPF_JIT is enabled
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 12:43 AM Yonghong Song <yhs@fb.com> wrote:
> How about this:
>
>         if (!IS_ENABLED(CONFIG_BPF_JIT_ALWAYS_ON) && !prog->jited)
>                 goto out;
>
>         if (unlikely(hdr->magic != BPF_BINARY_HEADER_MAGIC ||
>             !arch_bpf_jit_check_func(prog))) {
>                 WARN(1, "attempt to jump to an invalid address");
>                 return 0;
>         }
> out:
>         return prog->bpf_func(ctx, prog->insnsi);

Sure, that does look cleaner. I'll use this in the next version. Thanks.

Sami
