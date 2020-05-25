Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143651E0B31
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 12:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389694AbgEYKAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 06:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389401AbgEYKAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 06:00:11 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC13C061A0E;
        Mon, 25 May 2020 03:00:10 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id 4so16881895ilg.1;
        Mon, 25 May 2020 03:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/HlZX9BfLNkxmxu/peNZlTEsIIbqtBbCJJ4S/yDGP3c=;
        b=qqBUiZiAO78fGq0DecwTUiZYY1Q/guXRaL4B2UwAtNeKi/QiWcsXPwEl7n2CxHtKJN
         lG03iVcgDUNDyzd6Z9xhwxIMr8pdP8jdgYEXPJvXw6CAGjBNJdgTpFttrDZUhltMLhar
         Ozmkh0EdFTryOb4G+j6kmoiONg+bRF7rZCVbiDQpZNpsNgpfF9XpPYhgOb8tzEKA+1db
         PpbMmqe57u+MTZE33tEbIDBWSVjudosBb2alHJtozMYzqn0wFzvGW0lUbydTPyMenD+b
         MbF4hxUkHTeTy2xSfNNB0nzOLFr3ZvHlNPDuViQT8W79A7zwYJQjeIBUWqxYqL4HY/kC
         SMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/HlZX9BfLNkxmxu/peNZlTEsIIbqtBbCJJ4S/yDGP3c=;
        b=hJ+zMiYgJtEvGB7boWgzrfhAqQyS8DK7OvH9EI9cF7J9WqyUWd1+HOr7Eqb5HR17fv
         iSkoiIFkVoEPZu/Ytpu4avUuPjCykQ8eHY3uVzKnZiPGjU6Le0Tz/dEtROFvpeCIUaYn
         J6mWnlz3g6oBtcKaVwnzD3pqGsar/ieuAvBMneyKzCkOi5fsAEXniFcNfYzpIxe4pIzD
         2ytqrWAbjiNycQ4ivZaAXrV4if2CLOomqR9GX0e+MAmQw7kuYcWFur8LiATzYaEn0CID
         ht1mY2kDHwyuTfhAuqa9szPqDYqpLmtKkSgJbJK42GfB7ZAVLf43BerKcUrIaoRSmteU
         Xr9Q==
X-Gm-Message-State: AOAM532ILCBk3S+kywf0Hrz8dI1JKTMF77pxktbu6wnLTd6FGsQqbZNr
        +2G3E0dwm4OpuPtll5KA8LBoUF+gS5tAPvnPGf0=
X-Google-Smtp-Source: ABdhPJyGYePvmuxuziYBNq5bY4eey/YTZ8/TMNjTJa07qL6vIS6+9Ts/v6YEt5nah+k+B5nJK7L/gY6pbC5s9sngqjk=
X-Received: by 2002:a92:8b0a:: with SMTP id i10mr23058915ild.245.1590400810150;
 Mon, 25 May 2020 03:00:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-8-andriin@fb.com>
In-Reply-To: <20200517195727.279322-8-andriin@fb.com>
From:   Alban Crequy <alban.crequy@gmail.com>
Date:   Mon, 25 May 2020 11:59:58 +0200
Message-ID: <CAMXgnP424S5s-mrwFB_nuZNSuqLyi1K8r519WKVkyMBPtv1PMQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 7/7] docs/bpf: add BPF ring buffer design notes
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        andrii.nakryiko@gmail.com, kernel-team@fb.com,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alban Crequy <alban@kinvolk.io>, mauricio@kinvolk.io,
        kai@kinvolk.io
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks. Both motivators look very interesting to me:

On Sun, 17 May 2020 at 21:58, Andrii Nakryiko <andriin@fb.com> wrote:
[...]
> +Motivation
> +----------
> +There are two distinctive motivators for this work, which are not satisfied by
> +existing perf buffer, which prompted creation of a new ring buffer
> +implementation.
> +  - more efficient memory utilization by sharing ring buffer across CPUs;

I have a use case with traceloop
(https://github.com/kinvolk/traceloop) where I use one
BPF_MAP_TYPE_PERF_EVENT_ARRAY per container, so when the number of
containers times the number of CPU is high, it can use a lot of
memory.

> +  - preserving ordering of events that happen sequentially in time, even
> +  across multiple CPUs (e.g., fork/exec/exit events for a task).

I had the problem to keep track of TCP connections and when
tcp-connect and tcp-close events can be on different CPUs, it makes it
difficult to get the correct order.

[...]
> +There are a bunch of similarities between perf buffer
> +(BPF_MAP_TYPE_PERF_EVENT_ARRAY) and new BPF ring buffer semantics:
> +  - variable-length records;
> +  - if there is no more space left in ring buffer, reservation fails, no
> +    blocking;
[...]

BPF_MAP_TYPE_PERF_EVENT_ARRAY can be set as both 'overwriteable' and
'backward': if there is no more space left in ring buffer, it would
then overwrite the old events. For that, the buffer needs to be
prepared with mmap(...PROT_READ) instead of mmap(...PROT_READ |
PROT_WRITE), and set the write_backward flag. See details in commit
9ecda41acb97 ("perf/core: Add ::write_backward attribute to perf
event"):

struct perf_event_attr attr = {0,};
attr.write_backward = 1; /* backward */
fd = perf_event_open_map(&attr, ...);
base = mmap(fd, 0, size, PROT_READ /* overwriteable */, MAP_SHARED);

I use overwriteable and backward ring buffers in traceloop: buffers
are continuously overwritten and are usually not read, except when a
user explicitly asks for it (e.g. to inspect the last few events of an
application after a crash). If BPF_MAP_TYPE_RINGBUF implements the
same features, then I would be able to switch and use less memory.

Do you think it will be possible to implement that in BPF_MAP_TYPE_RINGBUF?

Cheers,
Alban
