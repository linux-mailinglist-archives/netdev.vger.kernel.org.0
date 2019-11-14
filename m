Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71E4FC952
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 15:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKNOz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 09:55:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:30063 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726410AbfKNOz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 09:55:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573743357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uVXcjwtBf3NZ36Eq0yDSwVNdrCXxD9u9+76H1pXkzIY=;
        b=ip+icRCjP+6sVgcMiTTuv9s00GKLscPuxSB5MmXImDKJ9BKHe2YiHLa+PT45ifBFHhdI38
        G9QGKO2X+TfymNrvqrkMRVTcOJG3U/1EE1Avj8N7JHhkX1jAos2YvfsNwaErj5t2C6f8w2
        Up2dlxMYlfo/ao2UmQcxIMw8D4cqpu0=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-H_Z5yin4M8GfIybZkQZ03A-1; Thu, 14 Nov 2019 09:55:54 -0500
Received: by mail-lj1-f198.google.com with SMTP id i27so756419ljb.17
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 06:55:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=rIBZiL1FWythDUin873DaL6ByyNzCAJsvbPWa35uar8=;
        b=nibnjJV59rOk3og4Do6yaL+it2kqrei35cHHWwB+CiCvyv54rRZpKxvJrJCnMl31jW
         d31xTsR2HSijPUz892VkN6gPPo14YO06RrsFb922XRmbN3njBAgRVweTwL8FuXd2wERI
         KlNjf7af6wHZecMIKTxayzdrdB6GxQ7NIc6LBdG55q8IF3UoOkBqSYh49196ZgYVl+rS
         bA6mdEKOoYxslNxMW8oAmb7WO2/tpas7oOJuNar5DDv1Ydhek8vyIirtkDu2/yl0KIyM
         bESD0YZAblLmQmJMRqmGsb7eN0jnQYwENDQ7qKTv69mwqHNo0GF6dC6MPFk5MPXr3/2I
         onYg==
X-Gm-Message-State: APjAAAUmZVxQyqW03nBaC8i+B2D2Uey9EukZ5xzSp3z/FI6Mh1gLNzbW
        o/LFARM9QckMpEhi/sUOyMdMBlf26f9ImB9QeY8X/aumWEhyLq8DQTFWKpBf9ywmg9gOdHthF+P
        KmxFX+j6DmworY7IG
X-Received: by 2002:a19:ccd7:: with SMTP id c206mr6954014lfg.165.1573743352966;
        Thu, 14 Nov 2019 06:55:52 -0800 (PST)
X-Google-Smtp-Source: APXvYqyDdMh8yqEOtvSSTWb+aD+1/y4JfNENnZFitaJOBGmj/dwnGACpjvDyAvuaqu4R5CeK4afWRg==
X-Received: by 2002:a19:ccd7:: with SMTP id c206mr6953994lfg.165.1573743352754;
        Thu, 14 Nov 2019 06:55:52 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id d17sm2941336lja.27.2019.11.14.06.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 06:55:52 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3827B1803C7; Thu, 14 Nov 2019 15:55:51 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
In-Reply-To: <CAJ+HfNhPhCi4=taK7NcYuCvdcRBXVDobn7fpD3mi1eppTL7zLA@mail.gmail.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com> <20191113204737.31623-3-bjorn.topel@gmail.com> <87o8xeod0s.fsf@toke.dk> <7893c97d-3d3f-35cc-4ea0-ac34d3d84dbc@iogearbox.net> <CAJ+HfNhPhCi4=taK7NcYuCvdcRBXVDobn7fpD3mi1eppTL7zLA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 14 Nov 2019 15:55:51 +0100
Message-ID: <874kz6o6bs.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: H_Z5yin4M8GfIybZkQZ03A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Thu, 14 Nov 2019 at 14:03, Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>>
>> On 11/14/19 1:31 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>> >> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>> >>
>> >> The BPF dispatcher builds on top of the BPF trampoline ideas;
>> >> Introduce bpf_arch_text_poke() and (re-)use the BPF JIT generate
>> >> code. The dispatcher builds a dispatch table for XDP programs, for
>> >> retpoline avoidance. The table is a simple binary search model, so
>> >> lookup is O(log n). Here, the dispatch table is limited to four
>> >> entries (for laziness reason -- only 1B relative jumps :-P). If the
>> >> dispatch table is full, it will fallback to the retpoline path.
>> >
>> > So it's O(log n) with n =3D=3D 4? Have you compared the performance of=
 just
>> > doing four linear compare-and-jumps? Seems to me it may not be that bi=
g
>> > of a difference for such a small N?
>>
>> Did you perform some microbenchmarks wrt search tree? Mainly wondering
>> since for code emission for switch/case statements, clang/gcc turns off
>> indirect calls entirely under retpoline, see [0] from back then.
>>
>
> As Toke stated, binsearch is not needed for 4 entries. I started out
> with 16 (and explicit ids instead of pointers), and there it made more
> sense. If folks think it's a good idea to move forward -- and with 4
> entries, it makes sense to make the code generator easier, or maybe
> based on static_calls like Ed did.

I don't really have anything to back it up, but my hunch is that only 4
entries will end up being a limit that people are going to end up
hitting. And since the performance falls off quite the cliff after
hitting that limit, I do fear that this is something we will hear about
quite emphatically :)

-Toke

