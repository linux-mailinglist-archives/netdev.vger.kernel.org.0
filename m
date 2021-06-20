Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2955E3ADFA2
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 19:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhFTRt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 13:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbhFTRt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 13:49:27 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF88C061574;
        Sun, 20 Jun 2021 10:47:13 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id h4so26146604lfu.8;
        Sun, 20 Jun 2021 10:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jSu0egrk+uJuS1JJk2PGJ2TdDHfXRrSYXAm3TLzkXqs=;
        b=BWgpf8jCgoGmhmrzJnePnAIfXCeFk5ITyr/MWWvt8BcV6lzf12/ZUOx9TE/ISEGrUs
         AkqtMWC5b2kB6ZC/BNb+9ps3eEFCUO3S221gp7jilCvOMSxlMGuUsvbKT6/KLt0yoZ2B
         4VZDggahWUM/UuoPOJns8/hKpF4elDh6DuqvGPU/I80GuRkGsVV9ybqmy5TlyAtOv4L9
         RaXvWZQHqsVkU6dB9vEGUrj2iYCbxh/oMTCWhYQiVMZTaaay5oAVuOlh0iJgJo1KcbX2
         nEA093aOUOhCMzJCbVU5rnSlYNbff74AVp4SF2fiWVnScC1ztVHbev5L9iYV9SsDQMAd
         8aRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jSu0egrk+uJuS1JJk2PGJ2TdDHfXRrSYXAm3TLzkXqs=;
        b=Q+Rxe9+O60p7J/KIgo77nncaYMnpWzXkJcbbSHPzmzkdNZbcLZ/M3JgtVkXZQ7JBTL
         4QJTHT5PA49QBDfbjt5KfmVKspdnRCm7S2/8XDe040Xxb5LtbsWGITUzTjxIh1ZBkA2V
         GQjJG3CE3CfNzHXasXes7pn9noW6sPhb3ycr71ALH3pQ2zaKRUqwAtpFIo+1lb/aFzft
         Upge4/r2iHfkHKqgVlWeaeZeN1Jyw8vkb90i6t37g+qkygnyNPZC2IePZZyTmkkpfU+E
         TXNOsmIgX2XUpqO/dRm7XH9khXnjODVnK6q2C06H0WSz9XyZ4X3lRB0/b5cfe7U8WpEl
         Z9wg==
X-Gm-Message-State: AOAM531NnizTKK3Jnj7gKjEHXsJhmQ3Zs4nByxZr7UqoEijfv5IPDZx/
        c8rVLDC8oShSN117Tv+Yh+8jwGkrUSP3HId4SYU=
X-Google-Smtp-Source: ABdhPJyeY4ZI9kOyU+NN3y95rXR3jqTYyAs+KReWga/bOW8fK4lJcVMkDqdROiqrirsg2Zv8XgR1v7lISI9LqD2g6aA=
X-Received: by 2002:ac2:4e82:: with SMTP id o2mr2444031lfr.38.1624211231674;
 Sun, 20 Jun 2021 10:47:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210605111034.1810858-1-jolsa@kernel.org> <CAEf4BzaK+t7zom6JHWf6XSPGDxjwhG4Wj3+CHKVshdmP3=FgnA@mail.gmail.com>
 <YM2r139rHuXialVG@krava> <4af931a5-3c43-9571-22ac-63e5d299fa42@fb.com>
 <YM4kxcCMHpIJeKum@krava> <e8f7ab9f-545a-2f43-82a6-91332a301a77@fb.com>
In-Reply-To: <e8f7ab9f-545a-2f43-82a6-91332a301a77@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 20 Jun 2021 10:47:00 -0700
Message-ID: <CAADnVQJFzGd-7C9Gn1XqhBWKY+fyr=4WooDSokkff+Ga-2U+nw@mail.gmail.com>
Subject: Re: [RFCv3 00/19] x86/ftrace/bpf: Add batch support for
 direct/tracing attach
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 20, 2021 at 9:57 AM Yonghong Song <yhs@fb.com> wrote:
> >
> > ah right, should have checked it.. so how about we change
> > trampoline code to store ip in ctx-8 and make bpf_get_func_ip(ctx)
> > to return [ctx-8]
>
> This should work. Thanks!

+1
and pls make it always inline into single LDX insn in the verifier.
For both mass attach and normal fentry/fexit.
