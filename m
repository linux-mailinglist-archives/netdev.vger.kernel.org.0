Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9881025CECF
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 02:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbgIDAew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 20:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgIDAet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 20:34:49 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47836C061244;
        Thu,  3 Sep 2020 17:34:49 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id z17so2900331lfi.12;
        Thu, 03 Sep 2020 17:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zf9S2piXp30RkaJ2ipfBoaYTZaao4UDSG/OSRaoirlU=;
        b=l1YonLzO4TnrRRTqbgQdZYO/B5udRfOiFenBTzllYhmQs2ya/ZA1o9lGtWktnuHeDP
         2XyH7zGLFUilVCO9JEqXGmWT6Rt3szoSm1FbPQWLo8Nx3kHhAeP+LGFU2FrtFro6u09e
         HtRFzWoApRPRPnfdzhTyLiG2a/a0/pQFhYhpf6CSRcOPoxyz6s5aoWG7XTsXOlNrHDsr
         efqZWGAmmCS/wA8n4+zhr53jdIk7xm9CoNNJozbXODpYGvRyqABSnPMJMdJbK0egoH2j
         HyrODunsAbEXghg24sK7ILYjYhMC4o7YAlQ3XngLLS5L1e4hdnGhEGI4Fhgpxbx4Zgrq
         ODtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zf9S2piXp30RkaJ2ipfBoaYTZaao4UDSG/OSRaoirlU=;
        b=QNfiAlK34q59yxWL4RE+EKy+Hig/b9NHsyyitK2yHucEnS9VFxz/UJUWkQIkytKJYK
         ZIISQ1bJPL8ewrr+5BPgEjK7a/hCZC3gdHkKOotQbFvmfC130Wk3en7je96wrZ90FdqG
         I3cLvIuodtkx/a57P8BygVq/p/xNMcAasgYWRWF/MtJHlf0D+ceZilsh01VG9XmVn41B
         TVScoZBOEBB2OWSv6KcyzqlvfAkdFegMLS8jYXol3zuDlkAAfZEDvpQs7zbf97V2VdS5
         aIniti1Gg1uKY2IA0QWvmfhDR+0jogCISsX6paUEGxJfFm7LFKXPcjfYO+YEeLeJ42Td
         E2Ug==
X-Gm-Message-State: AOAM532rrFwlUJ4GjUME4LFcXAZgSt8wPS1TmLV559eOE5aZr2iBS+dR
        Ktl4WkMy5UGQABhz/TXIaVkxNdFk9RPBKusvHTM=
X-Google-Smtp-Source: ABdhPJyWDhHejTRyjPxyoAp33rJyDC4HRl0ogGbj6fFUS47jtnTzP4pgO97Ef1AMYlrtz+jm8azfGbMQ1LqXF0DHYqw=
X-Received: by 2002:a05:6512:2101:: with SMTP id q1mr2519517lfr.157.1599179687683;
 Thu, 03 Sep 2020 17:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200903200528.747884-1-haoluo@google.com> <CAEf4Bza6e+x8Rqy7cBzMG0F0D5WCzE7xPRoAqJgSbfyqXxtT5A@mail.gmail.com>
In-Reply-To: <CAEf4Bza6e+x8Rqy7cBzMG0F0D5WCzE7xPRoAqJgSbfyqXxtT5A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Sep 2020 17:34:36 -0700
Message-ID: <CAADnVQLASsjZ8W4Hi9R3ev0zVGvrCTyh8DzSYRpQFr1RB7ZV8g@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: Fix check in global_data_init.
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Hao Luo <haoluo@google.com>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 1:36 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Sep 3, 2020 at 1:06 PM Hao Luo <haoluo@google.com> wrote:
> >
> > The returned value of bpf_object__open_file() should be checked with
> > libbpf_get_error() rather than NULL. This fix prevents test_progs from
> > crash when test_global_data.o is not present.
> >
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
>
> thanks!
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
