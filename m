Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B8433BEA
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbfFCX1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:27:37 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:32966 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFCX1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:27:37 -0400
Received: by mail-lf1-f68.google.com with SMTP id y17so14930501lfe.0;
        Mon, 03 Jun 2019 16:27:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o9KhBDmRSvyA17K9yLz93GnFppJZ9/pTjhne6a8KQc4=;
        b=dvwzkPELPl5nUZRVZU4gRYPnhCE55hxxM399myYdEENPvpGIE8RV7G9g73ozE+ApRw
         dJuqDbQdACfLbz60Tuqd9wyM78ah1m/nMlr997ItFEOHJhubidgZlOXj3Vi46T1mph5e
         EFWmMJV5idtQTYKRlkwXIbmz9AjLzCLzNLYH+MD3SZdEZXII665wE2hoL42y5KjN5F0Z
         I0nNupJH/f9mQKbJpDjqoTxTGmYE7U2PlXCO+wH1jTWVzNgVNcpwzxm4u6oV07Bxcq6t
         6vc5uJMNz5oJY9I4A6X/rGGqnSFbwz7QCIxB5ORArf/3pNlxirELVli+BHINObtCFGlM
         X1sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o9KhBDmRSvyA17K9yLz93GnFppJZ9/pTjhne6a8KQc4=;
        b=h0/GIW+khEMAGiGF33uKgLNJPXEc7CUwUjZkPtioQKLoC9C/Y0CD6IvUUWNZcOduUv
         S1SIueFPpDf/yDw/Ju/RzvSeni8QNAeYrazolH+0044VvMp+zjQhMlSnPHL3bulk/n53
         gNyIGd3iSc2Xv4NRG06EdWl2DJhO/qqWBMJu671b09t2mJhRwJKsjZkjfRqP59ZkarjG
         syRWKKr7Mg+33Gwq8eK1XSTaayxD5THPmFe0Ijgen/AZfrj9NJUX5D30KH/YXB7/OxFy
         Ct4SvNHCVE2OY/a+/6HG9wjk+oxdG55SZU4JyEQ5OhQtvJuddlMLF+MzmWeJd/CsMIKk
         /Ukg==
X-Gm-Message-State: APjAAAXA82n3naRa96Kq2ex1FG4DXGkJnIJc6UUQf0L6/36bTW/CmPLg
        ODF3Giu7SOg3HYl4oeg6vF8TGkYreFer3IsqbAlbTO4Q
X-Google-Smtp-Source: APXvYqz9hOL4RaiKfOlOB3Z42QvxuObHHBxVPqDnbWXCIStvl7miabWH+J5FaAVZ8iLPzbs/JlQZ0s2aIwOnIbw59D8=
X-Received: by 2002:ac2:4252:: with SMTP id m18mr14656401lfl.100.1559604454843;
 Mon, 03 Jun 2019 16:27:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190531223735.4998-1-mmullins@fb.com> <6c6a4d47-796a-20e2-eb12-503a00d1fa0b@iogearbox.net>
 <68841715-4d5b-6ad1-5241-4e7199dd63da@iogearbox.net> <05626702394f7b95273ab19fef30461677779333.camel@fb.com>
In-Reply-To: <05626702394f7b95273ab19fef30461677779333.camel@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 3 Jun 2019 16:27:23 -0700
Message-ID: <CAADnVQKAPTao3nE1AC5dvYtCKFhDHu9VeCnVE04TLjGpY6yANw@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
To:     Matt Mullins <mmullins@fb.com>
Cc:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Hall <hall@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 3:59 PM Matt Mullins <mmullins@fb.com> wrote:
>
> If these are invariably non-nested, I can easily keep bpf_misc_sd when
> I resubmit.  There was no technical reason other than keeping the two
> codepaths as similar as possible.
>
> What resource gives you worry about doing this for the networking
> codepath?

my preference would be to keep tracing and networking the same.
there is already minimal nesting in networking and probably we see
more when reuseport progs will start running from xdp and clsbpf

> > Aside from that it's also really bad to miss events like this as exporting
> > through rb is critical. Why can't you have a per-CPU counter that selects a
> > sample data context based on nesting level in tracing? (I don't see a discussion
> > of this in your commit message.)
>
> This change would only drop messages if the same perf_event is
> attempted to be used recursively (i.e. the same CPU on the same
> PERF_EVENT_ARRAY map, as I haven't observed anything use index !=
> BPF_F_CURRENT_CPU in testing).
>
> I'll try to accomplish the same with a percpu nesting level and
> allocating 2 or 3 perf_sample_data per cpu.  I think that'll solve the
> same problem -- a local patch keeping track of the nesting level is how
> I got the above stack trace, too.

I don't think counter approach works. The amount of nesting is unknown.
imo the approach taken in this patch is good.
I don't see any issue when event_outputs will be dropped for valid progs.
Only when user called the helper incorrectly without BPF_F_CURRENT_CPU.
But that's an error anyway.
