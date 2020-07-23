Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0EBE22B28A
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 17:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729649AbgGWP1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 11:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729668AbgGWP1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 11:27:22 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E711DC0619DC;
        Thu, 23 Jul 2020 08:27:21 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id e8so6811607ljb.0;
        Thu, 23 Jul 2020 08:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=icDrOEVC/8epZOak8kb0H/2e+mCU2SCzkHlrnG8TscA=;
        b=X/ZmKmF04YhdoJNrfvi5V/RM9Nu870qnC3kLeTrtfFp73YnwrxcajumDhvPTNNAeyc
         XM6hIDpuoGyKCTYQ1gKKMllEzrGoXXAKCWYI+I8ruapSC2O5zvT5nc/AyevI1yGqQdso
         M0U0MOVYqoI/nrnIvkCeuJ+/qnpqER4ep0I0ZyZt/yt486bdv5POJFm9DbUBiK6RLxOE
         cKwYojbAoANHV4l/+I4koCRrxgOVVCpgBhHgUrBBKhg9JTQLEi/CVXkREgIjiEEpRUCT
         a5Q/xR2Yp4pK5BXYIp7x20LFymQ7XdSdZlzdTEkebQ5UjgyPI4nJHrznW0MYTt0w3/9s
         dDQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=icDrOEVC/8epZOak8kb0H/2e+mCU2SCzkHlrnG8TscA=;
        b=pVdqfDqKaZeAwp3gmkQTELfsJ8Ed4Wul+4nsoFYTJfzQP2WGzoi2/KLPZSfCmuMh7w
         RKLp2AZekV660wNmW1uUNCW7C0NOBZbhoDl0mQGJJO0AuuLqMTIIntSc3cOYqe96Xj69
         Ar8KkJixz4wDf5uhyx+lHeQ9uu1MerVPAXMZNkOvQV/y8K6RSMEPXlCCv5g6sz6dUKkO
         XdKB2j5Muo6AyZFFVDleV0Wx52XqWnuruBqYPsUVIXtDUoCjrgAgsTytTRFoFrdF+42j
         NND/CRhKMT4dnmSckU6n0bydV3sNpDHvQsJ7th+wA71lXKqe5MWXbJi3zldJdiL6TweG
         6EtA==
X-Gm-Message-State: AOAM5314D7no0ccKUAvwcfmJVhyb2YRXBOSyQo+vbFbs4c0mc+CXDMDr
        61h5fJPgBfqFvtm9UJ9SNPnEvD7wIBIR8Iv+mQQ=
X-Google-Smtp-Source: ABdhPJys2Y8KPPvvS8hAEOfeBh/cxXaslg/nRGG2CqfBBypTJG5NaYZw4bBCSPovLsojGPswX04aNzT3bZ73DvdQXCw=
X-Received: by 2002:a2e:90da:: with SMTP id o26mr2313514ljg.91.1595518040467;
 Thu, 23 Jul 2020 08:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200723141914.20722-1-trix@redhat.com>
In-Reply-To: <20200723141914.20722-1-trix@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 23 Jul 2020 08:27:08 -0700
Message-ID: <CAADnVQJYsqosZ804geM1Urrz73+z1fMZu1w76KN-847S3CL+nQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: BPF_SYSCALL depends INET
To:     trix@redhat.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Will Deacon <will@kernel.org>, krzk@kernel.org,
        patrick.bellasi@arm.com, David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 7:19 AM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> A link error
>
> kernel/bpf/net_namespace.o: In function `bpf_netns_link_release':
> net_namespace.c: undefined reference to `bpf_sk_lookup_enabled'
>
> bpf_sk_lookup_enabled is defined with INET
> net_namespace is controlled by BPF_SYSCALL

pls rebase. it was fixed already.
