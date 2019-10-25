Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AABCCE51CA
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 18:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505774AbfJYQ7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 12:59:05 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33490 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502697AbfJYQ7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 12:59:04 -0400
Received: by mail-qt1-f196.google.com with SMTP id r5so4313090qtd.0;
        Fri, 25 Oct 2019 09:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rvKi/i+Tyee4cFcdz2c2Xy8hqQ7IiTEl+NCG1+kZZ98=;
        b=BPg3cThH+YtThwPubLteiNOzUFGRR14esJ5hHm5iqJZy6huPmLGDLguaRaVmPgvQ4t
         akEOcqJiJFA7P1HfB9vPrZlWRq5tOnpDGnQhfoQ/RARqFlxG/J4FJCHl+nS3kg+m0NqG
         NjYh8/C7pJCzTEMvS9zE3vod28g7Y3vadN2f0YKKHZv9O9Zd5N6bMXpL0y1NtqxcvllC
         44tb8DD8oKUlPrIcSeLjePkwl36QJuRYl6eHV82NZT+7qGaiUhlWHzoBMfeiayD5vgLL
         yLvlACf3Z3KqgXhAoMWef9Rrx3urA0wrlvWrdYnJLBa11Cu6zmq3KMM6LJ/xG3bge+mV
         DJWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rvKi/i+Tyee4cFcdz2c2Xy8hqQ7IiTEl+NCG1+kZZ98=;
        b=i1QVPx+M11hqUKjxmP1MMsaVoCzI/ot+MlQTSCsIh31SYgqvpNt4ed6RPslCTsSJ6L
         q4T1+032zZ1FChdPfzgJ/zfHZ4skfYYvNDDIk/tgOBMTt+E7XL20H5vqZQQJzBqNSeCd
         /vMk9bojZxBHZfLES2IUNLua6/J+EoXK3aZC+TitgghRQ3Uc99slbanTe9wkckb0Jh4T
         hb/1+JSfZIMUihl9NenrYLNtzp76Agj1Zx5bTfDrPOpMBrnESINywWnKRizp3Id2kZQh
         SECU8ErF7+YEYOTUwjlyf2hFJ4fH7UT75aHqosQfDqVkQyYlp24NA0QVHvI3AtAxkK7G
         KwoA==
X-Gm-Message-State: APjAAAXNRyN/Wt4EIkhiU4HMB9OpStjyISOOzuna2S5L12fM7NMKVte6
        VhtqmGEYEIhatIQK8pjkGDlmWRwwZFnO1nMX0K4=
X-Google-Smtp-Source: APXvYqz4Fxt4i8buB4XelIJF4Joba353chUndFCa0CZq0wkEYAgO08RD1G8l2JSrNKjzVU49fawEQPoShRPNJRH7SfI=
X-Received: by 2002:a05:6214:2aa:: with SMTP id m10mr2365848qvv.224.1572022743597;
 Fri, 25 Oct 2019 09:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20191024132107.237336-1-toke@redhat.com>
In-Reply-To: <20191024132107.237336-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 09:58:52 -0700
Message-ID: <CAEf4BzZAutRXf+W+ExaHjFMtWCfot9HkTWZNGuPckBiXqFcJeQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add libbpf_set_log_level() function to
 adjust logging
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Currently, the only way to change the logging output of libbpf is to
> override the print function with libbpf_set_print(). This is somewhat
> cumbersome if one just wants to change the logging level (e.g., to enable

No, it's not. Having one way of doing things is good, proliferation of
APIs is not a good thing. Either way you require application to write
some additional code. Doing simple vprintf-based (or whatever
application is using to print logs, which libbpf shouldn't care
about!) function with single if is not hard and is not cumbersome. If
you care about helping users to be less confused on how to do that, I
think it would be a good idea to have some sort of libbpf-specific FAQ
with code samples on how to achieve typical and common stuff, like
this one. So please instead consider doing that.


> debugging), so add another function that just adjusts the default output
> printing by adjusting the filtering of messages.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c   | 12 +++++++++++-
>  tools/lib/bpf/libbpf.h   |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 14 insertions(+), 1 deletion(-)
>

[...]
