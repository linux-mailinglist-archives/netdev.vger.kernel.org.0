Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAF1DFE3C
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 09:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387614AbfJVH1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 03:27:10 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22185 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387791AbfJVH1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 03:27:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571729229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GT05HthJTrW7c4K3gTLDo8MsaDeqfweknqOj+D0OahU=;
        b=QUfDaASlv9wdy0cOowrpTMpIWHQzdogGGHvULAVkIuMFDcvU85kWZ+PDGKU/hdeHHcFDeW
        0WWjlQQZd66awUavdU+TdtEeBZ/ttF8b3NSFOn4wNDH8kRA/UlleMGtUazyXOn75Jzn3yU
        bpgP7Ob1m4GkXQqQwIPvj+9kF0sDrWo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-h3rJ5wlSP4-BVAmYjsxWSg-1; Tue, 22 Oct 2019 03:27:07 -0400
Received: by mail-wr1-f72.google.com with SMTP id a15so8715329wrr.0
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 00:27:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=V40UFYPSkCXYwl4O4Et5hQgR3UAKLwpf6CRuPrVQy1M=;
        b=Wx7Kdcv+0DJNqweTiPtG2gl3fzLqkhqY7I9c19GsBghga+tbjptmvQh1S6NCh4b8Ol
         0PZUfqfnafcu7C33W3Pg/g0mjsHWHeLLKVhHvMnrX9Jp0WNgTKF2miAXu7cmZTekKzcT
         8Yd/Ed8G2Ee/YQVIHgzWt3ETg0VOZ5ZibSYQLOMT1oY5nZm/oQm5/B8QhiZ3WmBQFSx9
         lF1GIU9BOqTFiM/GAtveqvgE01YHZ71nR2pbrltT5+hLnC1n73dZ3+lf4b6mcjJUxX3P
         aGIHzydxtyy4dRM7KHNUtgkb9WiSSc/8eKP+LiPk2+F8c0Sj901NJd3CE24ly6V6szdC
         X18w==
X-Gm-Message-State: APjAAAVoiGEiddS0+BwlWql7AZ4nMAyG4t2qrIwg1tI7s0R7mTkcBpg9
        dWF312baE6qA3RKvOpXurGMmpqGyltwPwLq7eOpz25d8jJnih71AisDjHyO6MTdXwja3wDqj3sF
        YF27rcD+kqSrGaABx
X-Received: by 2002:a7b:c4c6:: with SMTP id g6mr1596504wmk.126.1571729226413;
        Tue, 22 Oct 2019 00:27:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz2+PmYOvcKorzPwbtDvaLtXey5ex4I0xMrb5/iQdcke+WfKoxqxrnP4elZhngmygWjuRKrUA==
X-Received: by 2002:a7b:c4c6:: with SMTP id g6mr1596478wmk.126.1571729226173;
        Tue, 22 Oct 2019 00:27:06 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id a4sm16742655wmm.10.2019.10.22.00.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 00:27:05 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E62C51804B1; Tue, 22 Oct 2019 09:27:04 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: make LIBBPF_OPTS macro strictly a variable declaration
In-Reply-To: <CAEf4BzaWEJ1t-4rB9ZftiSEdSBToAjFvnheo2z+H+OsG=BqZzA@mail.gmail.com>
References: <20191021165744.2116648-1-andriin@fb.com> <87mudtdisk.fsf@cloudflare.com> <CAEf4BzaWEJ1t-4rB9ZftiSEdSBToAjFvnheo2z+H+OsG=BqZzA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Oct 2019 09:27:04 +0200
Message-ID: <87imohp7ef.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: h3rJ5wlSP4-BVAmYjsxWSg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Oct 21, 2019 at 12:01 PM Jakub Sitnicki <jakub@cloudflare.com> wr=
ote:
>>
>> On Mon, Oct 21, 2019 at 06:57 PM CEST, Andrii Nakryiko wrote:
>> > LIBBPF_OPTS is implemented as a mix of field declaration and memset
>> > + assignment. This makes it neither variable declaration nor purely
>> > statements, which is a problem, because you can't mix it with either
>> > other variable declarations nor other function statements, because C90
>> > compiler mode emits warning on mixing all that together.
>> >
>> > This patch changes LIBBPF_OPTS into a strictly declaration of variable
>> > and solves this problem, as can be seen in case of bpftool, which
>> > previously would emit compiler warning, if done this way (LIBBPF_OPTS =
as
>> > part of function variables declaration block).
>> >
>> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>> > ---
>>
>> Just a suggestion - macro helpers like this usually have DECLARE in
>> their name. At least in the kernel. For instance DECLARE_COMPLETION.
>
> Yes, it makes sense. This will cause some extra code churn, but it's
> not too late. Will rename in v2 and fix current usages.

While you're respinning, maybe add a comment explaining what it is
you're doing? It certainly broke the C parser in my head, so maybe a
hint would be good for others as well :)

-Toke

