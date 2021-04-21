Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 897F93672E3
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245284AbhDUSw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243061AbhDUSw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:52:56 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8B2C06174A;
        Wed, 21 Apr 2021 11:52:23 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id p202so4740930ybg.8;
        Wed, 21 Apr 2021 11:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D/EZo6r3sPWCLKwMKMgTd+tOlzEgZfYGYUiK/hneHwI=;
        b=MfelRG6p6UDtz2dcVpfnUHevwmsoFCeJiMdgFDmlZK8AbOd4aYRp4Rni5oIIxX0wyz
         XCgRS5wvZw0nr6AWDWyUEmddgXBcbSYVAW3dk6WtjW0DcT/tbfQl8v+KsZ2569okZPuD
         9WXvj8IJUAgGztySGu+/maMJbEq8TtxzxGTHoagrNKqWO6glQgHn6nTXLIG+iBKnBIYx
         F/f9vN2RIEcg0aYwzvbCA+Vr72b4Su0RKy6iN9qyHisPpKO9n9RsK8acdrXRnbgb/xIZ
         +D3WHoTrw25+v8MhFkIMbkOE3ae2+rGY86yzox+UKDPFQJTEuksLDKCLGh1C51oq1OpW
         mrRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D/EZo6r3sPWCLKwMKMgTd+tOlzEgZfYGYUiK/hneHwI=;
        b=Ksrr6P/gOPiIL3MyFHQXla8QMDFoKrdJIKtgEBMu2pDI9bAniK7mFz56brmvqJEkCU
         hAsMkVJNbzA9xYRwofMCcRNwcsEiM+YA1N0LxmeyGygtAbzd+AN12sHIYj+2v4MoAryl
         LhG7Ukkvn+YRw24OPZxpsUTqe1DbAqpLLFAO56zB0hmvZfaHzjieSCrSfcbeIcA8Hhk2
         TObo8FqF3SeVbG/CQMpYY+xWN7JEuSnOVw1ly06QZUWENcWq2KmO7bCObWAsLA9fM387
         +E+WHCLwCPuygCpsxjd89sgthnE8psXuWvVVqTB5aeKfzqlVWSC1bsG5fQNCW0ju/llw
         blQw==
X-Gm-Message-State: AOAM533nXwQRVwvevt1X5YlKXOk4utUCscyIRU9c0miWNeShPuX8YNim
        /bxL7dmrfO//i5V40QPZqHPkMoULY0Lg5DBIGII=
X-Google-Smtp-Source: ABdhPJxZFUzAog/7gULk2KM5Vzcm+Q5rH68WmNuTLRoVhThMgXX6J39iQ43oPOJdB4jd5dRYK0nhMiaADbRCeKrVLAA=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr25489524ybg.459.1619031142500;
 Wed, 21 Apr 2021 11:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home> <CAEf4BzY=yBZH2Aad1hNcqCt51u0+SmNdkD6NfJRVMzF7DsvG+A@mail.gmail.com>
 <20210415170007.31420132@gandalf.local.home> <20210417000304.fc987dc00d706e7551b29c04@kernel.org>
 <20210416124834.05862233@gandalf.local.home> <YH7OXrjBIqvEZbsc@krava>
 <CAADnVQK55WzR6_JfxkMzEfUnLJnX75bRHjCkaptcVF=nQ_gWfw@mail.gmail.com>
 <YH8GxNi5VuYjwNmK@krava> <CAADnVQLh3tCWi=TiWnJVaMrYhJ=j-xSrJ72+XnZDP8CMZM+1mQ@mail.gmail.com>
 <YIArVa6IE37vsazU@krava> <20210421100541.3ea5c3bf@gandalf.local.home>
In-Reply-To: <20210421100541.3ea5c3bf@gandalf.local.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 21 Apr 2021 11:52:11 -0700
Message-ID: <CAEf4BzaYEOqVYBaxVSs8p6Nmy_giztaxTX9DtDk4N77NzsHbDQ@mail.gmail.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 7:05 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 21 Apr 2021 15:40:37 +0200
> Jiri Olsa <jolsa@redhat.com> wrote:
>

[...]

>
> >
> > perhaps this is a good topic to discuss in one of the Thursday's BPF mtg?
>
> I'm unaware of these meetings.

We have BPF office hours weekly meetings every Thursday at 9am PDT.
There is a spreadsheet ([0]) in which anyone can propose a topic for
deeper discussion over Zoom. I've already added the topic for the
discussion in this thread. It would be great if you and Jiri could
join tomorrow. See the first tab in the spreadsheet for Zoom link.
Thanks!

  [0] https://docs.google.com/spreadsheets/d/1LfrDXZ9-fdhvPEp_LHkxAMYyxxpwBXjywWa0AejEveU/edit#gid=883029154

>
>
> -- Steve
