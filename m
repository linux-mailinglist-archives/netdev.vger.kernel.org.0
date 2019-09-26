Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C98A8BF3CF
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 15:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfIZNMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 09:12:36 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:35442 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726853AbfIZNMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 09:12:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1569503555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JSMLfK3pYPL1cVmk6h2CM/KHhT/OAXe1m21X5wqkJSY=;
        b=QjS8aZNutTX6EZTKJgnmKM/GJXR1TbANLmZnOoyJK3P+9xlrAk3GZPgo821nq67r5Cp6Wz
        +bxcprGiWhmR3A9KYxzw116CdVFIe7198am1KgThGCWy3ApUBOgpIyYATvH7HrvryMq8Xd
        49gWTYas62OKe8B6Gt35chccjU47isk=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-BsRxOeSROMC6mF-07EHOpQ-1; Thu, 26 Sep 2019 09:12:34 -0400
Received: by mail-ed1-f69.google.com with SMTP id y66so1312870ede.16
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 06:12:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=JSMLfK3pYPL1cVmk6h2CM/KHhT/OAXe1m21X5wqkJSY=;
        b=c6Z2PJXZshHaHkO+Pck2hE7DFbKzP6xiFXbQxkr/14Jh76T1PqoOPPELx2KhZZKzEs
         CgRBga4usVVJnWnzBdgwDMZG+FuvSmoaP48/v+VFip43PgBODluV2vspf++j7Gt/X/ce
         WNNjLAwzUsNCEl8BcTvlWmBDE4pIMy9uhJ3x7tc5qSlfOZxGnItHIo+9w8HE2bzSbbb8
         aQI4Ec0zj2VJBIZhlNGa5QwQQs3TXOD86XnY8bV5OxJbcn4W08AVSpIHeB0miRTzgRvG
         BJVth1GTcBJdBP/ahGb0jph3tIUWHUog0qqV44Dg2UNX4JIMZ0bGilhAfnCrKYCjcuEI
         KquQ==
X-Gm-Message-State: APjAAAW0QkaOoulgzsfy0vvYFzbocc7ShEoxhoHN9mZjDJRN5k5hoHqQ
        2YFXcJ+9SZpEk610lSKwbun5B2zb2o0RW5OWoyNenC4HpyPpx9n02Ln359tVamrIOKiVmwHvQb3
        HEuIIw8MwnyJkTn0A
X-Received: by 2002:aa7:dc55:: with SMTP id g21mr3502240edu.210.1569503552722;
        Thu, 26 Sep 2019 06:12:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqysfFqzMbAq1fGirMk9DgRDRLRtTNc1nuTuicrYtY2auNcoAVtqtld52F8WV3y9rTJF1aK0JQ==
X-Received: by 2002:aa7:dc55:: with SMTP id g21mr3502211edu.210.1569503552480;
        Thu, 26 Sep 2019 06:12:32 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id n1sm231174ejc.16.2019.09.26.06.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Sep 2019 06:12:31 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CE5CE18063D; Thu, 26 Sep 2019 15:12:30 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: Are BPF tail calls only supposed to work with pinned maps?
In-Reply-To: <20190926125347.GB6563@pc-63.home>
References: <874l0z2tdx.fsf@toke.dk> <20190926125347.GB6563@pc-63.home>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 26 Sep 2019 15:12:30 +0200
Message-ID: <87zhir19s1.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: BsRxOeSROMC6mF-07EHOpQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> Hi Toke,
>
> On Thu, Sep 26, 2019 at 01:23:38PM +0200, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> [...]
>> While working on a prototype of the XDP chain call feature, I ran into
>> some strange behaviour with tail calls: If I create a userspace program
>> that loads two XDP programs, one of which tail calls the other, the tail
>> call map would appear to be empty even though the userspace program
>> populates it as part of the program loading.
>>=20
>> I eventually tracked this down to this commit:
>> c9da161c6517 ("bpf: fix clearing on persistent program array maps")
>
> Correct.
>
>> Which clears PROG_ARRAY maps whenever the last uref to it disappears
>> (which it does when my loader exits after attaching the XDP program).
>>=20
>> This effectively means that tail calls only work if the PROG_ARRAY map
>> is pinned (or the process creating it keeps running). And as far as I
>> can tell, the inner_map reference in bpf_map_fd_get_ptr() doesn't bump
>> the uref either, so presumably if one were to create a map-in-map
>> construct with tail call pointer in the inner map(s), each inner map
>> would also need to be pinned (haven't tested this case)?
>
> There is no map in map support for tail calls today.

Not directly, but can't a program do:

tail_call_map =3D bpf_map_lookup(outer_map, key);
bpf_tail_call(tail_call_map, idx);

>> Is this really how things are supposed to work? From an XDP use case PoV
>> this seems somewhat surprising...
>>=20
>> Or am I missing something obvious here?
>
> The way it was done like this back then was in order to break up cyclic
> dependencies as otherwise the programs and maps involved would never get
> freed as they reference themselves and live on in the kernel forever
> consuming potentially large amount of resources, so orchestration tools
> like Cilium typically just pin the maps in bpf fs (like most other maps
> it uses and accesses from agent side) in order to up/downgrade the agent
> while keeping BPF datapath intact.

Right. I can see how the cyclic reference thing gets thorny otherwise.
However, the behaviour was somewhat surprising to me; is it documented
anywhere?

I think I'll probably end up creating a new map type for chaining
programs anyway, so this is not a huge show-stopper for me; but it had
me scratching my head for a while there... ;)

-Toke

