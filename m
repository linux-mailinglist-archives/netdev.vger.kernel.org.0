Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE0AE19611D
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgC0W0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:26:44 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:52760 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727720AbgC0W0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585348002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s39pCd+uzGRntRwMjCABw0JVUciy3MD4An4VVp+JJiE=;
        b=ct3MmCVEv+vySkJODjwXKiGnzyeNg89AwSCLxOuyolTFRhdHr5iJUtwId600YEqzZJf+Nn
        /+6P5D+h5HKTodUS4JPjoh2QrySocMX5MqsXcIHQ/d5c4Qki52MLmSsqpu/B+2jSEsC0u4
        hDCu1OcH4rUhExYwqzpI92UP8thj++c=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-pRtGNmdfNFKk-EaLyiNLqA-1; Fri, 27 Mar 2020 18:26:41 -0400
X-MC-Unique: pRtGNmdfNFKk-EaLyiNLqA-1
Received: by mail-lf1-f69.google.com with SMTP id j3so4334422lfe.10
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 15:26:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=s39pCd+uzGRntRwMjCABw0JVUciy3MD4An4VVp+JJiE=;
        b=mBhW5GtjRN7zGeqdbbnNK7dATPxqjo42kcZrYO66zph9Q3G0+48/BbrXDj9HgZ43Rq
         uyt8mhUiri7NYOZvjdmyL1VdjMr/kadTdks4OMe+rVakIakqjQzZ2v6N9KFw2FR50mSx
         PstwNLjvJnDAeUKLHCBUoN5tmNJETPlVH8xm9g0wPhVCYRh+WSaSjzR6Y4LSSuazZ0pn
         3Q/j3SsdHL8Cor8rjXKPW1tlTDheZVWJYwznPav/gj6kLme8qA3pGiY/zdMW2AyWMnGe
         pyfx/GYgtLtAm1Zx9yKYN7l7VOreGP+tx1mp7FghRk/bOvuHaQ2AU7y0fmKCeL8WWQ8c
         Quxw==
X-Gm-Message-State: AGi0PuZw4HbDLrvZxnusRuZgAo43BQhx1kuDVnrTdaRNw5ulyYPTsbVr
        A/L5JCYjMkww4dcW8LTN8gJf8o0GEEGA3PYhQCkOcpCm3G637Ghrtt5B1eo9ipZpHkHS3rJo/q2
        2Z2JkCL7LRG4Zq+dW
X-Received: by 2002:a19:23d2:: with SMTP id j201mr950648lfj.78.1585347999092;
        Fri, 27 Mar 2020 15:26:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypK6xNB1txjhlRNudUTTfUGINcDKA93fU3V5JENt2BjDRGcvU/cMf+gfXhWINyY+glrgrz+Gew==
X-Received: by 2002:a19:23d2:: with SMTP id j201mr950638lfj.78.1585347998868;
        Fri, 27 Mar 2020 15:26:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h9sm3138437ljk.96.2020.03.27.15.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 15:26:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8459A18158B; Fri, 27 Mar 2020 23:26:37 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2] libbpf: Add getter for pointer to data area for internal maps
In-Reply-To: <CAEf4BzbEyYQeLEsw0tzYYHeKi+q7a+vxavya9O3jykwsH3ki9g@mail.gmail.com>
References: <20200326151741.125427-1-toke@redhat.com> <20200327125818.155522-1-toke@redhat.com> <CAEf4BzbEyYQeLEsw0tzYYHeKi+q7a+vxavya9O3jykwsH3ki9g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 27 Mar 2020 23:26:37 +0100
Message-ID: <87tv29l9ia.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Fri, Mar 27, 2020 at 5:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> For internal maps (most notably the maps backing global variables), libb=
pf
>> uses an internal mmaped area to store the data after opening the object.
>> This data is subsequently copied into the kernel map when the object is
>> loaded.
>>
>> This adds a getter for the pointer to that internal data store. This can=
 be
>> used to modify the data before it is loaded into the kernel, which is
>> especially relevant for RODATA, which is frozen on load. This same point=
er
>> is already exposed to the auto-generated skeletons, so access to it is
>> already API; this just adds a way to get at it without pulling in the fu=
ll
>> skeleton infrastructure.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>> v2:
>>   - Add per-map getter for data area instead of a global rodata getter f=
or bpf_obj
>>
>> tools/lib/bpf/libbpf.c   | 9 +++++++++
>>  tools/lib/bpf/libbpf.h   | 1 +
>>  tools/lib/bpf/libbpf.map | 1 +
>>  3 files changed, 11 insertions(+)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 085e41f9b68e..a0055f8908fd 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -6756,6 +6756,15 @@ void *bpf_map__priv(const struct bpf_map *map)
>>         return map ? map->priv : ERR_PTR(-EINVAL);
>>  }
>>
>> +void *bpf_map__data_area(const struct bpf_map *map, size_t *size)
>
> I'm not entirely thrilled about "data_area" name. This is entirely for
> providing initial value for maps, so maybe something like
> bpf_map__init_value() or something along those lines?
>
> Actually, how about a different API altogether:
>
> bpf_map__set_init_value(struct bpf_map *map, void *data, size_t size)?
>
> Application will have to prepare data of correct size, which will be
> copied to libbpf's internal storage. It also doesn't expose any of
> internal pointer. I don't think extra memcopy is a big deal here.
> Thoughts?

Huh, yeah, that's way better. Why didn't I think of that? Think maybe I
was too focused on doing this the same way the skeleton code is. I'll
send a v3 :)

-Toke

