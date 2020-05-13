Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40151D0FA9
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 12:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732603AbgEMKZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 06:25:18 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43906 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731466AbgEMKZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 06:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589365515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zy0H8xB+MNrP+FLSnh6gqUYpUw9pi7TNLyTMD+YbKFs=;
        b=XHk6JAAbAQSKBSHRBb2fwuSJpZBrnFZk2koGtTyA4Hvaker0vbhM0v91FSWkIaepgfpOya
        21RX/tXaN4ZdIoZh0F99KlAgsQW3h1uBbLYchRcdO+ZrM8HQGGbkjM8v9uiXKFhPxpD7td
        CKSkIcEbxPk3Y3DG7c8vrg7QbL09xwg=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-dHfqwaKxMa6rHSN5jiQWQw-1; Wed, 13 May 2020 06:25:13 -0400
X-MC-Unique: dHfqwaKxMa6rHSN5jiQWQw-1
Received: by mail-lj1-f200.google.com with SMTP id m15so2388158ljp.3
        for <netdev@vger.kernel.org>; Wed, 13 May 2020 03:25:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=zy0H8xB+MNrP+FLSnh6gqUYpUw9pi7TNLyTMD+YbKFs=;
        b=kPu7rnQPJGTVs9Kgj57/IjKEqs0a1LahaNhFHdkLk8jud6nJJykCtquXTci00TZGIl
         LPw0vENYg5wcA+ktbL+2vmY7QLfkrc8/Yv2tvDE1GHHapHRaFr//I+csr83s9ELreEGS
         mxqRjC6SMMKz4/2/4cMsGBSh7z3aiDHknZ2aXmcG+SpQwF7f03hE9uR6GakevA7luHMq
         LTHbc3oQeZ/cXYjK89vMtZUit2Z76PIxeS46DBNytcMB57tSI0reCx+ftg9I883MU1Ub
         7v7N1vB+QAbMsV+7q4Kuc0Oi1LdjnI7KGX81rQEUqF50NaItluBYhzi0/Z2XfDSjjbec
         myzA==
X-Gm-Message-State: AOAM5307iktIL/NKcSKTTXC61wL8ZJkUCBbigiL7QTRUp3rYIc1qKRRW
        9n3tSoGAHYQQ1xpKX+ux3r55gMv9sjrQ1YJKr/Vnsr7Xka0n+Mb7LioEChS8gFqEPVYbX5866P0
        qPYQyIn+ZB2a7/pO0
X-Received: by 2002:a2e:8949:: with SMTP id b9mr17202326ljk.108.1589365511897;
        Wed, 13 May 2020 03:25:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxqkQWFl50s+1zu5sW5FzsaxrR4uj6ztjozMReRLcibmdJ8afDSwDEX/liYYJ7IM/2hFSdZg==
X-Received: by 2002:a2e:8949:: with SMTP id b9mr17202314ljk.108.1589365511677;
        Wed, 13 May 2020 03:25:11 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o20sm15469274lfc.39.2020.05.13.03.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 03:25:10 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 91E2D18150C; Wed, 13 May 2020 12:25:09 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
In-Reply-To: <20200512230600.dxuvhy6cvwpkvlc5@ast-mbp>
References: <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com> <20200326195340.dznktutm6yq763af@ast-mbp> <87o8sim4rw.fsf@toke.dk> <20200402202156.hq7wpz5vdoajpqp5@ast-mbp> <87o8s9eg5b.fsf@toke.dk> <20200402215452.dkkbbymnhzlcux7m@ast-mbp> <87h7wlwnyl.fsf@toke.dk> <20200512230600.dxuvhy6cvwpkvlc5@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 13 May 2020 12:25:09 +0200
Message-ID: <87v9l0t9mi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, May 12, 2020 at 10:34:58AM +0200, Toke H=C3=83=C6=92=C3=82=C2=B8i=
land-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>=20
>> >> > Currently fentry/fexit/freplace progs have single prog->aux->linked=
_prog pointer.
>> >> > It just needs to become a linked list.
>> >> > The api extension could be like this:
>> >> > bpf_raw_tp_open(prog_fd, attach_prog_fd, attach_btf_id);
>> >> > (currently it's just bpf_raw_tp_open(prog_fd))
>> >> > The same pair of (attach_prog_fd, attach_btf_id) is already passed =
into prog_load
>> >> > to hold the linked_prog and its corresponding btf_id.
>> >> > I'm proposing to extend raw_tp_open with this pair as well to
>> >> > attach existing fentry/fexit/freplace prog to another target.
>> >> > Internally the kernel verify that btf of current linked_prog
>> >> > exactly matches to btf of another requested linked_prog and
>> >> > if they match it will attach the same prog to two target programs (=
in case of freplace)
>> >> > or two kernel functions (in case of fentry/fexit).
>> >>=20
>> >> API-wise this was exactly what I had in mind as well.
>> >
>> > perfect!
>>=20
>> Hi Alexei
>>=20
>> I don't suppose you've had a chance to whip up a patch for this, have
>> you? :)
>
> On my priority list it's after cap_bpf and sleepable.
> If it's urgent for you please start hacking.

OK, ACK. Not extremely urgent right now, just wanted to check in with
what your plans were. Thanks for letting me know!

-Toke

