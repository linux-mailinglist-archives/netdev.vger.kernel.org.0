Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA897262D84
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 12:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729298AbgIIK7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 06:59:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25605 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727856AbgIIK6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 06:58:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599649115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UlbYS18H011Iq6ivG1CppQuP+eHDYG6ZaZ6anysk7ww=;
        b=faOmRPSUSXCQZiU7nxRcJju7nKUkq42swD70j65WRPp9CggWx0mu2iOg8sGpdi4FzijBxg
        Na1LV+xxI7keCVUBzx1m/iJ16XSR4r12UbSF73CHZT+adUAGcWb1tEGftzLNAbMeY4X5B4
        dKfZv+2fgOYqgQnSKmBY2RZ74ew2PHs=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-ZHkjzXQSNY2EuqW56eTeSw-1; Wed, 09 Sep 2020 06:58:31 -0400
X-MC-Unique: ZHkjzXQSNY2EuqW56eTeSw-1
Received: by mail-wr1-f70.google.com with SMTP id a12so824840wrg.13
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 03:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=UlbYS18H011Iq6ivG1CppQuP+eHDYG6ZaZ6anysk7ww=;
        b=MuW30FVapTQLrFtlptncnLJ4iN38rPhyFtyWazFgBQbZL0iIDhj9aA819Ar7/Sky8F
         z42VzRkrJYpGktoPsSFG9KlxZA6YXXdBCI8KgdTSNsWOrHLx7+pUCA7aK391jtmmpWUw
         JMZrAZ0qNEi+avoRhz4Sg8WhY4pH0An+ITt6AJdpMt/fWd9BDulwM8d8CyoMIXz8aMPI
         JtXRzQw4HXU9rfWs5I2Xb5viKhEmgEWfMu/vUzRUJEYk/IPb9cvpZSPRoowschcqGbG5
         zYXF9dbixKUnDSurxs1BjOb4YAsukP9vXDBLpdd4XTCHoLeMeiY3ziQkvfjmg73MNIji
         9Syg==
X-Gm-Message-State: AOAM530EbiqLHr6g+NJaMNBnP+GZwlfvZstdScef/vFnbQaDm7XuGii0
        puwwgqpX59oQt2w9CfcHe+DFcaUY8wrm/YIf8QCSUsnh6/Vbse0QEjCHN0dYD4X6qHdiwvPWk04
        ub8y3GGP3skrCB6Mq
X-Received: by 2002:a1c:c256:: with SMTP id s83mr2997889wmf.93.1599649110646;
        Wed, 09 Sep 2020 03:58:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPISmCR4dgdVvk6g3iPoqMbDlKb6d0IuqTgppoeZFwa/r+l0GbHaZdcetlBRX8jYunT+93tQ==
X-Received: by 2002:a1c:c256:: with SMTP id s83mr2997872wmf.93.1599649110401;
        Wed, 09 Sep 2020 03:58:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 2sm3694235wrs.64.2020.09.09.03.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 03:58:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 307B51829D4; Wed,  9 Sep 2020 12:58:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>,
        Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall
 and use it on .metadata section
In-Reply-To: <CAEf4BzbywFBSW+KypeWkG7CF8rNSu5XxS8HZz7BFuUsC9kZ1ug@mail.gmail.com>
References: <20200828193603.335512-1-sdf@google.com>
 <20200828193603.335512-4-sdf@google.com>
 <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com>
 <20200904012909.c7cx5adhy5f23ovo@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZp4ODLbjEiv=W7byoR9XzTqAQ052wZM_wD4=aTPmkjbw@mail.gmail.com>
 <87mu22ottv.fsf@toke.dk>
 <CAEf4BzbywFBSW+KypeWkG7CF8rNSu5XxS8HZz7BFuUsC9kZ1ug@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 09 Sep 2020 12:58:29 +0200
Message-ID: <87eenbnrmy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Sep 7, 2020 at 1:49 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> >> May be we should talk about problem statement and goals.
>> >> Do we actually need metadata per program or metadata per single .o
>> >> or metadata per final .o with multiple .o linked together?
>> >> What is this metadata?
>> >
>> > Yep, that's a very valid question. I've also CC'ed Andrey.
>>
>> For the libxdp use case, I need metadata per program. But I'm already
>> sticking that in a single section and disambiguating by struct name
>> (just prefixing the function name with a _ ), so I think it's fine to
>> have this kind of "concatenated metadata" per elf file and parse out the
>> per-program information from that. This is similar to the BTF-encoded
>> "metadata" we can do today.
>>
>> >> If it's just unreferenced by program read only data then no special n=
ames or
>> >> prefixes are needed. We can introduce BPF_PROG_BIND_MAP to bind any m=
ap to any
>> >> program and it would be up to tooling to decide the meaning of the da=
ta in the
>> >> map. For example, bpftool can choose to print all variables from all =
read only
>> >> maps that match "bpf_metadata_" prefix, but it will be bpftool conven=
tion only
>> >> and not hard coded in libbpf.
>> >
>> > Agree as well. It feels a bit odd for libbpf to handle ".metadata"
>> > specially, given libbpf itself doesn't care about its contents at all.
>> >
>> > So thanks for bringing this up, I think this is an important
>> > discussion to have.
>>
>> I'm fine with having this be part of .rodata. One drawback, though, is
>> that if any metadata is defined, it becomes a bit more complicated to
>> use bpf_map__set_initial_value() because that now also has to include
>> the metadata. Any way we can improve upon that?
>
> I know that skeleton is not an answer for you, so you'll have to find
> DATASEC and corresponding variable offset and size (libbpf provides
> APIs for all those operations, but you'll need to combine them
> together). Then mmap() map and then you can do partial updates. There
> is no other way to update only portions of an ARRAY map, except
> through memory-mapping.

Well, I wouldn't mind having to go digging through the section. But is
it really possible to pick out and modify parts of it my mmap() before
the object is loaded (and the map frozen)? How? I seem to recall we
added bpf_map__set_initial_value() because this was *not* possible with
the public API?

Also, for this, a bpf_map__get_initial_value() could be a simple way to
allow partial modifications. The caller could just get the whole map
value, modify it, and set it again afterwards with
__set_initial_value(). Any objections to adding that?

-Toke

