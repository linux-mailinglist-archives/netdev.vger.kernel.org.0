Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73982157F35
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 16:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727704AbgBJPvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 10:51:20 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42064 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbgBJPvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 10:51:20 -0500
Received: by mail-qk1-f195.google.com with SMTP id q15so6931702qke.9;
        Mon, 10 Feb 2020 07:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YVjuzOjf5jIj1NQgZ5KfZIi1a0fBwZEsl9wI2Km+hW0=;
        b=DcElZ8FkTJSjTPoesg3yiaUvLuXZKrhCV8Y93Q4i7ckb//Kww1dVDRlPjO/AfDKzxB
         zkgNg1z94eXHlTZICKjPOvPOD3Xej/HFnPJiDJHSgLG11khSXjEyKYkdYJtfBEpJCpwR
         evuf7sNcAxh02SKkhshlmSSU3b3AuZiKkLJoBDbQQJJKIYsDZx4yeWK60T9BPChcsd11
         YsTSsdlUvswUl6NRiPLgnem0+ntlIepvKxobZfJcVqWJ3FkCB+bHPvlnd8yH5vO4CBpD
         lzfl86hOo0JWmuKD7I7U/sINsjaQ085E4EUAyuhOKwK8HXe00aZ/65sIsNkBgwk7zmcL
         ZOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YVjuzOjf5jIj1NQgZ5KfZIi1a0fBwZEsl9wI2Km+hW0=;
        b=VL06M8kMVNXnzako2yh2CDsaqhUO/htPNg9QpX0eJdHjSUhZwV1S1IVQpKt6Co7LGO
         rl4LyJ5BWQJOHLKHdLwITfCI2NuYAZ/y1qz3EHkvs7NcQpdwa1Mq5/odInulh7+tHa2V
         m/VCKoK9LmYAMOJNdMAyVsgDfULtbjmHLHKYWnx19X9PQgHEANelja0YDUJez16l4awz
         kG4dnEIBsJSf9pnRW21Mw6rlJ1AH/jGy281gL++rhT082AUUUU0U2dniKNEt3yplB2IU
         Tz8h4+9XL3Wy9Hx95yTIIvXxQB6trscMtNEUtVCODwCHRocvgX/3SKkZKNyFILzMuIga
         Dp5Q==
X-Gm-Message-State: APjAAAXUmHtVHv3JWRUJKwgGezSz0W1IyEYgLh0yA84jVD7UlVOO9M4D
        kibcplwBHpGAmaTkPp9BR/44d7YBG/AkSalvgV0=
X-Google-Smtp-Source: APXvYqw8zH1HreqSp2uI3VS9MsuFTrEZLbox+1tmNUYU7Th8P8emTHEfbeJNnQhk0hUJf8eEEa7umPpfdo6LSaiQomU=
X-Received: by 2002:ae9:e10a:: with SMTP id g10mr1929397qkm.493.1581349879337;
 Mon, 10 Feb 2020 07:51:19 -0800 (PST)
MIME-Version: 1.0
References: <20200208154209.1797988-1-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-1-jolsa@kernel.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 10 Feb 2020 16:51:08 +0100
Message-ID: <CAJ+HfNhBDU9c4-0D5RiHFZBq_LN7E=k8=rhL+VbmxJU7rdDBxQ@mail.gmail.com>
Subject: Re: [PATCH 00/14] bpf: Add trampoline and dispatcher to /proc/kallsyms
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 8 Feb 2020 at 16:42, Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> this patchset adds trampoline and dispatcher objects
> to be visible in /proc/kallsyms. The last patch also
> adds sorting for all bpf objects in /proc/kallsyms.
>

Thanks for working on this!

I'm probably missing something with my perf setup; I've applied your
patches, and everything seem to work fine from an kallsyms
perspective:

# grep bpf_dispatcher_xdp /proc/kallsyms
...
ffffffffc0511000 t bpf_dispatcher_xdp   [bpf]

However, when I run
# perf top

I still see the undecorated one:
0.90%  [unknown]                  [k] 0xffffffffc0511037

Any ideas?
Bj=C3=B6rn
