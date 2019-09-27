Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E78F9C0004
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 09:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfI0H15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 03:27:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40981 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725820AbfI0H15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 03:27:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569569275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nCiWg7UjUdulJm0B8U7YHZnt9sksxapjetLgy8pdzo8=;
        b=WCLLPsCPDjmevisGVirt2m5WcwHWkX8kSo/JgzHtK6IMoPhJDkpLWMDCNQKD1HEo4o4Rax
        bsVAMTMr6GrwEB8v1wtH9UKiBMhYxSGZSslNmssjqXdXbg9AfF9nb4JB4QQ2GZjvtQR/gO
        4yFNa9uvs3DkSAzaAXkswjm96BvD1Wk=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-4pRh5ZePOxGiFH13t-ab3A-1; Fri, 27 Sep 2019 03:27:51 -0400
Received: by mail-lf1-f69.google.com with SMTP id p15so1179450lfc.20
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 00:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Y0+F3dpgEor0cGD/eDnJjGwWJI9IkOz05Hreggijlh8=;
        b=Yel2JChozv1S7GSElac+vXu3c6Rz8mb/iX7YnQCSLNo1OOMYdr64cJ1InHPvnAKLAy
         2WF6dPPzCT6zicyC4yaW3LrK5RWSbkgrIjouh1e8xF13CIKmls/rq0Epq3zQuXIiKJZu
         IseY8uBOigmnrVbVs+ZlSihlqfmMIr/IEf2gvspaTxGUYSPgkSboHZPvc4An+oKerkSJ
         oKd0odph2QB+lV5pedfy4cN8UBjHLOb2GzOA2HXOEC6uDRZ644nv/B3sT2s/U1kcazkZ
         DHEWra83JqGZFtg/pEUfohc48H2m863LVFrNKV+d/atAGtlIlQCs96XKk9+IrJE+SPEQ
         spGQ==
X-Gm-Message-State: APjAAAVRzaxsGRr+WOHciOz9+bZ+JH+N2F9PpoP8ETCaFP3yjXBa8HAw
        cG+O57qT3F+8rXlyw//oDaj3E7EcTzoIxEYWeeYK80+iylYFnCk+wr8TiAfWF6y7Uvr9Gr+HG5c
        H3S3carsL2qACpngZ
X-Received: by 2002:a2e:9a50:: with SMTP id k16mr1764882ljj.221.1569569270299;
        Fri, 27 Sep 2019 00:27:50 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwlVfRi8pgIgvNKWrXZvygEFVc0ZijPED3IkW6kpgEt7nt34YcMWk9wvluDWTSKtyzrj8ui6w==
X-Received: by 2002:a2e:9a50:: with SMTP id k16mr1764872ljj.221.1569569270073;
        Fri, 27 Sep 2019 00:27:50 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id b25sm338437ljj.36.2019.09.27.00.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 00:27:49 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 756DC18063D; Fri, 27 Sep 2019 09:27:48 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: Are BPF tail calls only supposed to work with pinned maps?
In-Reply-To: <20190926181457.GA6818@pc-63.home>
References: <874l0z2tdx.fsf@toke.dk> <20190926125347.GB6563@pc-63.home> <87zhir19s1.fsf@toke.dk> <20190926181457.GA6818@pc-63.home>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 27 Sep 2019 09:27:48 +0200
Message-ID: <87blv619mz.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 4pRh5ZePOxGiFH13t-ab3A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On Thu, Sep 26, 2019 at 03:12:30PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>> > On Thu, Sep 26, 2019 at 01:23:38PM +0200, Toke H=C3=B8iland-J=C3=B8rge=
nsen wrote:
>> > [...]
>> >> While working on a prototype of the XDP chain call feature, I ran int=
o
>> >> some strange behaviour with tail calls: If I create a userspace progr=
am
>> >> that loads two XDP programs, one of which tail calls the other, the t=
ail
>> >> call map would appear to be empty even though the userspace program
>> >> populates it as part of the program loading.
>> >>=20
>> >> I eventually tracked this down to this commit:
>> >> c9da161c6517 ("bpf: fix clearing on persistent program array maps")
>> >
>> > Correct.
>> >
>> >> Which clears PROG_ARRAY maps whenever the last uref to it disappears
>> >> (which it does when my loader exits after attaching the XDP program).
>> >>=20
>> >> This effectively means that tail calls only work if the PROG_ARRAY ma=
p
>> >> is pinned (or the process creating it keeps running). And as far as I
>> >> can tell, the inner_map reference in bpf_map_fd_get_ptr() doesn't bum=
p
>> >> the uref either, so presumably if one were to create a map-in-map
>> >> construct with tail call pointer in the inner map(s), each inner map
>> >> would also need to be pinned (haven't tested this case)?
>> >
>> > There is no map in map support for tail calls today.
>>=20
>> Not directly, but can't a program do:
>>=20
>> tail_call_map =3D bpf_map_lookup(outer_map, key);
>> bpf_tail_call(tail_call_map, idx);
>
> Nope, that is what I meant, bpf_map_meta_alloc() will bail out in that
> case.

Oohhh, right. Seems I reversed that if statement in my head. Silly me,
thanks for clarifying!

>> >> Is this really how things are supposed to work? From an XDP use case =
PoV
>> >> this seems somewhat surprising...
>> >>=20
>> >> Or am I missing something obvious here?
>> >
>> > The way it was done like this back then was in order to break up cycli=
c
>> > dependencies as otherwise the programs and maps involved would never g=
et
>> > freed as they reference themselves and live on in the kernel forever
>> > consuming potentially large amount of resources, so orchestration tool=
s
>> > like Cilium typically just pin the maps in bpf fs (like most other map=
s
>> > it uses and accesses from agent side) in order to up/downgrade the age=
nt
>> > while keeping BPF datapath intact.
>>=20
>> Right. I can see how the cyclic reference thing gets thorny otherwise.
>> However, the behaviour was somewhat surprising to me; is it documented
>> anywhere?
>
> Haven't updated the BPF guide in a while [0], I don't think I
> documented this detail back then, so right now only in the git log.
> Improvements to the reference guide definitely welcome.

Gotcha. I guess we should add something about tail calls (and chain
calls once we get them) to the XDP tutorial as well...

-Toke

