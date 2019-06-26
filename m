Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A956955DA8
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 03:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfFZBfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 21:35:48 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46949 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbfFZBfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 21:35:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so610257qtn.13;
        Tue, 25 Jun 2019 18:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0jOVApdbcnmQ0gZ+s+iXjEnjmT2qng2C8MAWEXFhcLM=;
        b=D7uUPnY0JIqehepH86/rg5CV9NOaQrvG3BqpmFHjf6mMuP2rRQze8DKufn7mYx2ZAd
         wge+/l/A5dnUhkrbqswIWIKk9CZYofTFZyaj/lqvV85J1lLDAYfqxABlTKKNsvoByXUB
         O4YRz6320HaOIaW6pBhHr+1/5OXnwdhKNBZjaDckxbWoOyHvkDEm6LULYvGrUAZ4qFKf
         KatbGZKx/hCWWIwWTqi+krbMaf35cgwm5GRGkiCNhb1RhGFTChgut31GbwPL2HEkCwhY
         Q0GIhvzU2TSSLq4QtYhBFb+CLcL3jcSBsjJNVEXLXhR4onWZ05glVZig+X5uSc7RYV4E
         WTlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0jOVApdbcnmQ0gZ+s+iXjEnjmT2qng2C8MAWEXFhcLM=;
        b=q8oUS2tg2vGqTtNw4cbJTkUykSSIMj/hzvFwtWyFCyObS46OOTqUUTh5OuupK8QoZ/
         jOi17I1LZLnss+L+fVTAtcVXE+la0PdecpkzKl8eyZgrI8TQtEVGKapRVDG+7jIDAz42
         MUhOvY+fdMev8oIxcDvu5YtyBSM1/FIvMW8gyu93AE4P0oxZ11yjD+WsUkKMOkIAaPX+
         gm6IGGiocnlzXbQOh6CLscpxM0wEWja/qejgH3qdzV3PL7YGVtzQcD4/xDCpj8ni9ucE
         qQrAlRttZ/nFeRz4/TdmMsGYjHW4YqJxqIMPO/HPqH64yFawHnC9ZkvMKbcNacXoV6fx
         oV0Q==
X-Gm-Message-State: APjAAAUYloPckoW6EG/XO1U7cTAaOfiFHo/UXl22uI8gi0BY8e+hwp5B
        Wg2UQxhfe8IlBbSYCrBAZPC4JjnK66YITu+V/Yk=
X-Google-Smtp-Source: APXvYqzqQn3I+yuRy5UB66EDdkdlfdfXf+20eBNYN25S+bi1B5Ul4jyWQQqbEzJdDwwbejiFylmwtSgBMbjvcAd6eKs=
X-Received: by 2002:aed:38c2:: with SMTP id k60mr1262888qte.83.1561512945624;
 Tue, 25 Jun 2019 18:35:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190626003852.163986-1-allanzhang@google.com>
In-Reply-To: <20190626003852.163986-1-allanzhang@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Tue, 25 Jun 2019 18:35:34 -0700
Message-ID: <CAPhsuW7-gyJ0_8_YVhgEF-fYGmjuT=1m1+NkTa_7cwQdKdKLeg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 0/2] bpf: Allow bpf_skb_event_output for more
 prog types
To:     allanzhang <allanzhang@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 5:39 PM allanzhang <allanzhang@google.com> wrote:
>
> Software event output is only enabled by a few prog types right now (TC,
> LWT out, XDP, sockops). Many other skb based prog types need
> bpf_skb_event_output to produce software event.
>
> More prog types are enabled to access bpf_skb_event_output in this
> patch.
>
> v2 changes:
> Reformating log message.
>
> v3 changes:
> Reformating log message.
>
> v4 changes:
> Reformating log message.
>
> v5 changes:
> Fix typos, reformat comments in event_output.c, move revision history to
> cover letter.
>
> v6 changes:
> fix Signed-off-by, fix fixup map creation.
>
> allanzhang (2):

I guess you manually fixed the name in the other two patches, but forgot
this one. You can fix it in your .gitconfig file. Make sure to get the proper
capital letters.

Also, please run ./scripts/checkpatch.pl on your patch files. This will help
you find a lot of issues.

Thanks,
Song

>   bpf: Allow bpf_skb_event_output for a few prog types
>   bpf: Add selftests for bpf_perf_event_output
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
