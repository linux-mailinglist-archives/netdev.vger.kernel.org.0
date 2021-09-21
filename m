Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C641B413A09
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 20:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhIUSYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 14:24:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52509 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232729AbhIUSYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 14:24:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632248581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fCioJD4GXQ8rL7BZ9hZH89l38r2D+NX3fPR72Eu5Xs4=;
        b=iNghnsdLyIUMOYVls5OwNsyn7eWPJuG9nbeNxvY6eVh39O3+rKXaQyyjqMkvm+HtO6wLi6
        0jj4dNu/WpdM4Mx8y3sYTOovBzjqRSHT9KWxa6rTtI+JV56ijyKNDfoj9sYlTHzGUlhydM
        74S8STpH/eumctgQYqh6+S0I+yXBFJM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-acAhHqi4NYqxXJwBgrFvmA-1; Tue, 21 Sep 2021 14:22:59 -0400
X-MC-Unique: acAhHqi4NYqxXJwBgrFvmA-1
Received: by mail-ed1-f69.google.com with SMTP id h24-20020a50cdd8000000b003d8005fe2f8so15845051edj.6
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 11:22:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=fCioJD4GXQ8rL7BZ9hZH89l38r2D+NX3fPR72Eu5Xs4=;
        b=i8SlYHWzXnMoJccjMLqTGlXFbnw3L2On4Z1ZV2o0KFz+PAV40DkVzM6FYb+Y9iX5qu
         3URxvQKRpYtlVNnU8gQawMEDXMVY2kW6nDAvYhG+Wca0mwb4TQAZV2tOhgSeY7Oaj7q7
         sy8JTj9eCvMMxjDtRx2P6zdVkvuhnm1C6vdpnf4rSTwSxUdNhyJZhnIphg7x0HCXCXXa
         16zU9wjh5S7VYR0LVFVqKEqLbZl5Pc3QkgO+KkLSQ91Tk/vQxVob44H9L51pd+C5/ZN+
         JUEHvQl4YMmP4/nNPSStgKI3cD9albIDL8YnY3qA+7O12czDhw6JdOP6YsNLRnwrjdck
         U2/Q==
X-Gm-Message-State: AOAM5321jW2D2+F19G/3AFpb1eWzgK0diOS2sK2NdexPhfesC9gpEjQS
        MQHarHvy75MWYMLOpJgmyA5EE/RlqCDoXlhDwecVwPBKNDYfv+plwLDH/yeAzHk1hE+lyr3AHK6
        E5+3GC572hxqjuhin
X-Received: by 2002:a05:6402:c8b:: with SMTP id cm11mr36945301edb.368.1632248577187;
        Tue, 21 Sep 2021 11:22:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWZnPEEIEkqbkx5GE9LEeskOMg0msXbBPJpqTSqI4kp6TMb1xb7FdR2kHCNqXGcCixoh2+nw==
X-Received: by 2002:a05:6402:c8b:: with SMTP id cm11mr36945152edb.368.1632248575740;
        Tue, 21 Sep 2021 11:22:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c17sm8760153edu.11.2021.09.21.11.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 11:22:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 87F3118034A; Tue, 21 Sep 2021 20:22:53 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Zvi Effron <zeffron@riotgames.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Lorenzo Bianconi <lbianconi@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf <bpf@vger.kernel.org>
Subject: Re: Redux: Backwards compatibility for XDP multi-buff
In-Reply-To: <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
References: <87o88l3oc4.fsf@toke.dk>
 <CAC1LvL1xgFMjjE+3wHH79_9rumwjNqDAS2Yg2NpSvmewHsYScA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Sep 2021 20:22:53 +0200
Message-ID: <87ilyt3i0y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zvi Effron <zeffron@riotgames.com> writes:

> On Tue, Sep 21, 2021 at 9:06 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Hi Lorenz (Cc. the other people who participated in today's discussion)
>>
>> Following our discussion at the LPC session today, I dug up my previous
>> summary of the issue and some possible solutions[0]. Seems no on
>> actually replied last time, which is why we went with the "do nothing"
>> approach, I suppose. I'm including the full text of the original email
>> below; please take a look, and let's see if we can converge on a
>> consensus here.
>>
>> First off, a problem description: If an existing XDP program is exposed
>> to an xdp_buff that is really a multi-buffer, while it will continue to
>> run, it may end up with subtle and hard-to-debug bugs: If it's parsing
>> the packet it'll only see part of the payload and not be aware of that
>> fact, and if it's calculating the packet length, that will also only be
>> wrong (only counting the first fragment).
>>
>> So what to do about this? First of all, to do anything about it, XDP
>> programs need to be able to declare themselves "multi-buffer aware" (but
>> see point 1 below). We could try to auto-detect it in the verifier by
>> which helpers the program is using, but since existing programs could be
>> perfectly happy to just keep running, it probably needs to be something
>> the program communicates explicitly. One option is to use the
>> expected_attach_type to encode this; programs can then declare it in the
>> source by section name, or the userspace loader can set the type for
>> existing programs if needed.
>>
>> With this, the kernel will know if a given XDP program is multi-buff
>> aware and can decide what to do with that information. For this we came
>> up with basically three options:
>>
>> 1. Do nothing. This would make it up to users / sysadmins to avoid
>>    anything breaking by manually making sure to not enable multi-buffer
>>    support while loading any XDP programs that will malfunction if
>>    presented with an mb frame. This will probably break in interesting
>>    ways, but it's nice and simple from an implementation PoV. With this
>>    we don't need the declaration discussed above either.
>>
>> 2. Add a check at runtime and drop the frames if they are mb-enabled and
>>    the program doesn't understand it. This is relatively simple to
>>    implement, but it also makes for difficult-to-understand issues (why
>>    are my packets suddenly being dropped?), and it will incur runtime
>>    overhead.
>>
>> 3. Reject loading of programs that are not MB-aware when running in an
>>    MB-enabled mode. This would make things break in more obvious ways,
>>    and still allow a userspace loader to declare a program "MB-aware" to
>>    force it to run if necessary. The problem then becomes at what level
>>    to block this?
>>
>
> I think there's another potential problem with this as well: what happens=
 to
> already loaded programs that are not MB-aware? Are they forcibly unloaded?

I'd say probably the opposite: You can't toggle whatever switch we end
up with if there are any non-MB-aware programs (you'd have to unload
them first)...

>>    Doing this at the driver level is not enough: while a particular
>>    driver knows if it's running in multi-buff mode, we can't know for
>>    sure if a particular XDP program is multi-buff aware at attach time:
>>    it could be tail-calling other programs, or redirecting packets to
>>    another interface where it will be processed by a non-MB aware
>>    program.
>>
>>    So another option is to make it a global toggle: e.g., create a new
>>    sysctl to enable multi-buffer. If this is set, reject loading any XDP
>>    program that doesn't support multi-buffer mode, and if it's unset,
>>    disable multi-buffer mode in all drivers. This will make it explicit
>>    when the multi-buffer mode is used, and prevent any accidental subtle
>>    malfunction of existing XDP programs. The drawback is that it's a
>>    mode switch, so more configuration complexity.
>>
>
> Could we combine the last two bits here into a global toggle that doesn't
> require a sysctl? If any driver is put into multi-buffer mode, then the s=
ystem
> switches to requiring all programs be multi-buffer? When the last multi-b=
uffer
> enabled driver switches out of multi-buffer, remove the system-wide
> restriction?

Well, the trouble here is that we don't necessarily have an explicit
"multi-buf mode" for devices. For instance, you could raise the MTU of a
device without it necessarily involving any XDP multi-buffer stuff (if
you're not running XDP on that device). So if we did turn "raising the
MTU" into such a mode switch, we would end up blocking any MTU changes
if any XDP programs are loaded. Or having an MTU change cause a
force-unload of all XDP programs.

Neither of those are desirable outcomes, I think; and if we add a
separate "XDP multi-buff" switch, we might as well make it system-wide?

> Regarding my above question, if non-MB-aware XDP programs are not forcibly
> unloaded, then a global toggle is also insufficient. An existing non-MB-a=
ware
> XDP program would still beed to be rejected at attach time by the
> driver.

See above.

-Toke

