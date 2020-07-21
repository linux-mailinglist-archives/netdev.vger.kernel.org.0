Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62F4228C20
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 00:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731332AbgGUWno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 18:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728014AbgGUWnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 18:43:43 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D29C061794;
        Tue, 21 Jul 2020 15:43:41 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id r19so373524ljn.12;
        Tue, 21 Jul 2020 15:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cAaXK7lO7E0sfa22BeOcHfPDdNwJneexEMiK9grJAq8=;
        b=sFJ02tBVNSJNZkVxndf5OQhTrGefYPmP7ZFh+Nu3oEnQ57Fwyi9fTKUqFcxmU5A653
         BQRx8vo6ccvmrrkp4KxjLitUsOA15ZxW+1x44c5vMgbWHEysKzvwOU8sw7Y/Ku7k9em7
         1xsWncwGaELKyTJTr0qWtW0M78mpAjI/micA6j0Ug2kE7Ce3zsfBKF2QlA4PRKZg1uaP
         osFp83WieUX9nfLEHECSJ1YyYoLv29ZO6h722kqlfYtARySQ+Yht1LQ/qUCXhlK+3Rum
         P7w6QA/Rjlu77QKu9Fwv/tSzcku6JLSBZuzqCDyK2HMnpOoDvO7HKXjkJUTbnBiXeMPF
         F1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cAaXK7lO7E0sfa22BeOcHfPDdNwJneexEMiK9grJAq8=;
        b=j/E7hzg9+XniQcVbuMdJLdISTWE0b3t+siCA7x9wG+ZYZ/Pa3szc+0z7oe4S6VgtRZ
         uEjlrB69ZX5FQwP6ZlzQuR4jDcgeZvvlob3v9Gq5DJkETrOBrekZC9Zu6wh3PLNrH8PJ
         B6jdlcp88DNSgDfId48PXpOk3CPSJXwXxIakEqI0CdkQQ4+jh/yX8mfWWG/I+BsmW4w8
         ZCP8YsAo9ohRK9JS6buPWh4NqIq5RMs8jh43SCrs/OeJf28c6lOGlGABiR7KxAEOeE2M
         B+2IOJfcJr4QFSPEow7JkpOTKAl9u2dV1xvQsYa4Yd7GhkOZfQrFKCp7yA4bQKf8YhY0
         t40g==
X-Gm-Message-State: AOAM533DX0juposV9Yh5EqqDRK+BX/EXW0kl20XyZ2j+SSpXefnQfWBf
        5bdrixllDC0bWadqbg/oBvGJvKW4rU5334sZf2A=
X-Google-Smtp-Source: ABdhPJwRDs0M7KhVLZnQ3eAXxJz5h35URF9O7UX58QiSiwYfFUJtCH7whpdc5rHDo8AlypqL5m4qVWzNzjf7VePhsFg=
X-Received: by 2002:a2e:8357:: with SMTP id l23mr12856199ljh.290.1595371419717;
 Tue, 21 Jul 2020 15:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200716225933.196342-1-songliubraving@fb.com>
 <20200716225933.196342-2-songliubraving@fb.com> <20200721191009.5khr7blivtuv3qfj@ast-mbp.dhcp.thefacebook.com>
 <42DEE452-F411-4098-917B-11B23AC99F5F@fb.com>
In-Reply-To: <42DEE452-F411-4098-917B-11B23AC99F5F@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jul 2020 15:43:27 -0700
Message-ID: <CAADnVQJPmo3He3cdUUbMm4DtTDNBeWRMRkNzPw8S3GdxxODemA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/2] bpf: separate bpf_get_[stack|stackid] for
 perf events BPF
To:     Song Liu <songliubraving@fb.com>
Cc:     open list <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 3:40 PM Song Liu <songliubraving@fb.com> wrote:
>
> We only need to block precise_ip >= 2. precise_ip == 1 is OK.

Are you sure?
intel_pmu_hw_config() has:
if (event->attr.precise_ip) {
    if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
            event->attr.sample_type |= __PERF_SAMPLE_CALLCHAIN_EARLY;
}
