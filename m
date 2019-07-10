Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4154364C83
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 21:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbfGJTGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 15:06:03 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37199 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727636AbfGJTGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 15:06:03 -0400
Received: by mail-qt1-f194.google.com with SMTP id y26so3654579qto.4;
        Wed, 10 Jul 2019 12:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9RyvAPs2B+lDGaQg0pJ3zzhP2875uGIFH6pz6Jrbd7s=;
        b=SlvGPtFiC6Ous3m7W7XIGLkIyN1fTOW0YK1Jeagc97fmtsOTIHNWt/+vnSR1fZB1zy
         /26pZGxrRfYVHmfeSD7y38I86+RulVTUmJv4bAES0Ah0h0sm0t5yvdcTDKghC4Ezznqv
         kxagQn44Y7MEfHx+RsYDVTVtRHzAPNfuUSXA9agha+JY1ATTEddjCy/0sX1qXF2dg7GQ
         w+QZ4rkYKRebtx35djwTJoxpY/ik3yolTj5CbeLHzBAPEXpzOWjVGJm6C89ssoJYQ+o4
         02VhULXgXEnfsA7laRaRyaBuZs5liX0Bl+SaJP9DbQXv9pdLqdxY8fTEB889rYUTGIYp
         jbmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9RyvAPs2B+lDGaQg0pJ3zzhP2875uGIFH6pz6Jrbd7s=;
        b=GbtVk9NzvptGhlUzjADQoc62woCJ64rjGUTxrk5tLbJXtAhNPgeex4tyb0rb0Pqfaa
         baRt99P6hnzxr4x78s1XC1DmEBx5ipUecFT6JYCmO/MbcUI4llkoyUi/WzKU5TK8JdY5
         jdgxuRo6gqcEat72xNp3w85c+MTtGVmBWK0MKGY/vnp3Mr/cCOYT6WbMnUi8xwSN3lpl
         7WnOssVtW92kW02A+3QySkqOx241w9N60aEDmIHg9Qx1OhSo5CA7PASRuxWlHYy+Y5m9
         tIgDv2RdTnKoyDuh2oavyH4Z46byb7314CxYUjhZzUAjYJdK3rMEWhhmiXe9snfR4bFm
         WTBw==
X-Gm-Message-State: APjAAAUXARRu2x8K42Qga7mjctofnk1wqTL5rxOTeRwslo01XyKekrU7
        EZ+nRCSASr8rvap9C5gz9KaRo+TvS7rqigoVgng=
X-Google-Smtp-Source: APXvYqzyjWCkV/G1WZOc2k5rWHtwPGl5jTpONIv0/teJjB65PhCpPL7EZgV2SLvpjP0KB2tJ+T3sHTJXFQvN9i3gO3M=
X-Received: by 2002:ac8:32a1:: with SMTP id z30mr15020986qta.117.1562785562303;
 Wed, 10 Jul 2019 12:06:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190710181811.127374-1-allanzhang@google.com>
In-Reply-To: <20190710181811.127374-1-allanzhang@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 12:05:51 -0700
Message-ID: <CAEf4BzbkVPk_Ugktgi+6NUmQzLxNsBN_MO48dPKA8qCF+28RTA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 0/2] bpf: Allow bpf_skb_event_output for more
 prog types
To:     Allan Zhang <allanzhang@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 11:18 AM Allan Zhang <allanzhang@google.com> wrote:
>
> Software event output is only enabled by a few prog types right now (TC,
> LWT out, XDP, sockops). Many other skb based prog types need
> bpf_skb_event_output to produce software event.
>
> More prog types are enabled to access bpf_skb_event_output in this
> patch.
>
> v9 changes:
> add "Acked-by" field.

Thanks! This looks good to me. Just FYI. Not sure if you followed, but
bpf-next is closed, so this can't go in until it's open. Maintainers
might ask you to resubmit at that time, if patches don't apply
cleanly.

>
> v8 changes:
> No actual change, just cc to netdev@vger.kernel.org and
> bpf@vger.kernel.org.
> v7 patches are acked by Song Liu.
>
> v7 changes:
> Reformat from hints by scripts/checkpatch.pl, including Song's comment
> on signed-off-by name to captical case in cover letter.
> 3 of hints are ignored:
> 1. new file mode.
> 2. SPDX-License-Identifier for event_output.c since all files under
>    this dir have no such line.
> 3. "Macros ... enclosed in parentheses" for macro in event_output.c
>    due to code's nature.
>
> Change patch 02 subject "bpf:..." to "selftests/bpf:..."
>
> v6 changes:
> Fix Signed-off-by, fix fixup map creation.
>
> v5 changes:
> Fix typos, reformat comments in event_output.c, move revision history to
> cover letter.
>
> v4 changes:
> Reformating log message.
>
> v3 changes:
> Reformating log message.
>
> v2 changes:
> Reformating log message.
>
> Allan Zhang (2):
>   bpf: Allow bpf_skb_event_output for a few prog types
>   selftests/bpf: Add selftests for bpf_perf_event_output
>
>  net/core/filter.c                             |  6 ++
>  tools/testing/selftests/bpf/test_verifier.c   | 12 ++-
>  .../selftests/bpf/verifier/event_output.c     | 94 +++++++++++++++++++
>  3 files changed, 111 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/event_output.c
>
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
