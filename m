Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04A0E5660
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 00:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfJYWJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 18:09:14 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43005 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfJYWJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 18:09:14 -0400
Received: by mail-qk1-f195.google.com with SMTP id m4so3176079qke.9;
        Fri, 25 Oct 2019 15:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8D2tsScit83wgK6jRPO+7PNaaB16wGVt+waNHUv1tO8=;
        b=kTL5Zx322wHMPzPTupd6uxs6Zg3jxm7ZD/pbiT5eIMSQKc7oibzVEAwzNTypdnsKj7
         FhT4E6AltVjHlpx/uoTamflTW23gm7PLKPg3mODD3o646rkvsabYgLGkm1PJ6E496HdR
         9m4cv5cuK1UpKuD2A9teO4SAYQFcoagorip9+31fec542ae+70BlED7gKXW2RvGql0uk
         T4da4Ll3CoJ+TSxXZalv8C3RrwUtTcyIcrZzK2DWnbVRIjrL5oTUzdZ/JG6Nol5nuDxb
         DjTRfT7nmtgG0t5+mSgavLBbjQP143TLsCxt49L+0nQrXAGPg0vn+9hL5FTP6onevPws
         3vKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8D2tsScit83wgK6jRPO+7PNaaB16wGVt+waNHUv1tO8=;
        b=jukS21ODHqJMhngKFtGmipWw3oao4U3a5JIMMpgMD++0G14OJurguXi+82uVWWDWco
         8bR23BoTzSXjfIudaupZZnGCjZydCaWO0k9Vam7VG9tBG96xtnenZPaagZnZCe81dav8
         t2rDBZokTS8wf9OnZD+pszywIp1eLtHn9RpjWe6ECOoUJQAh+lm0Dm8aer+PUdgiMBOL
         fK2lgdasRw2NEpm5eTPClGkVhJkLDeeB48bqPFXknur3JJzGLSe9vQvX8ozflVLnU17n
         U38vNlq2aG7WsKkJ5BjWkhc6xkdOmY+2TUdTJAaHtP/Sv2zqku6g5NqH+hxH3NAm+D/1
         8gPw==
X-Gm-Message-State: APjAAAXJDJbX4YrBgdwlqfQBLMbOjGeE6N81QlOVZUo2sI1F4A5sVcAA
        I2+KCEoE+zZhijbGbgCgp7HqAPKuTfByeox0S1U=
X-Google-Smtp-Source: APXvYqxhGCMvDo162Jf0DrZeyEdICwH0k6NLpjBnIhpi/56GOcRCKOwVhpCAwqmdZNj6wfrMk4+EeYRe34csxxU0HQM=
X-Received: by 2002:a37:8046:: with SMTP id b67mr5229158qkd.437.1572041352975;
 Fri, 25 Oct 2019 15:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1572010897.git.daniel@iogearbox.net> <d4ed775a802df0df6aeee84537bb9b3cad32746d.1572010897.git.daniel@iogearbox.net>
In-Reply-To: <d4ed775a802df0df6aeee84537bb9b3cad32746d.1572010897.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 25 Oct 2019 15:08:59 -0700
Message-ID: <CAEf4Bzauqivy_f2czAwoctHqug0dcSbOpnMTQ7h9rQ5hS=Cefg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/5] bpf, samples: Use bpf_probe_read_user where appropriate
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 1:46 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> Use bpf_probe_read_user() helper instead of bpf_probe_read() for samples that
> attach to kprobes probing on user addresses.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/map_perf_test_kern.c         | 4 ++--
>  samples/bpf/test_map_in_map_kern.c       | 4 ++--
>  samples/bpf/test_probe_write_user_kern.c | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
>

[...]
