Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B032611ABD7
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 14:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbfLKNRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 08:17:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57229 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729131AbfLKNRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 08:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576070243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=euN1BL4YywoP7RbUg1LVqDst2OmJiHQIB5+Y09DMWek=;
        b=PaBuAEP9577FGxDa2OyWjw7WJIF5GVV9JIIeO/pUkBRLlvPemMi/hFmS/gHu/vVoNgNSBV
        OZGjlahgtOgivVBJ/+iJFUT4j3jZOq1TW8fZR/3BqA1GzdfniahUkP0BqJ1dZfnBhY79lG
        SMI5dxfV72z9spX2vGXYxR+vus6cgkQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-I_VnyzP-N-eq88RoSqKIRg-1; Wed, 11 Dec 2019 08:17:20 -0500
Received: by mail-lf1-f70.google.com with SMTP id q16so5032444lfa.13
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 05:17:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=WA9dD6PXu0G7afNTJEKi8tc4wSzduavlA73aFj9hvJg=;
        b=NWe+JnV0/GCMwIpGjy63n5JNGdekLGALaAUBHIVh8qb7tD4g9oj2TrsAvBIqT5pzBt
         4UtAD9qA9m053GOUNPlQOEjsYyB3bxsV1N4V+MJAJyTHBnsjgqFW24+mBqummnlgEPLM
         JO3iEdLet3cKHmx1Mqaj8DaWyn8+ZF1O1toh94Q0ZRB5YpF+4sLUbOg/8LcwLl3sn/CF
         00LklhZtftAyuq1x3BI3OJwyxoq04c93P+IgaNlmjtDzwCtrPdqjZ0rF+e4FQDeDzZkt
         GAPlgdlw2Xut5zu14uCLUo6IRUZNZyVoBrTf96t6W+/uy3/LDG6xTUZNKQrQDuqtm0lg
         7RLQ==
X-Gm-Message-State: APjAAAUKvlt9iM760q73dlHspYTc7dS/r7nXkRjnhIrMDs3/PzM0TfHV
        reyWJFy/Zhko8diW3rZukfqzuhUnH1TNmvztSdLoWhgFMDHTq93B8JK6CdAICOGxg0f2nqjxLde
        sJMb0lFXv7hcJbUA2
X-Received: by 2002:a19:6a06:: with SMTP id u6mr2208215lfu.187.1576070239173;
        Wed, 11 Dec 2019 05:17:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqyCWgPBIbmMy5trTf3w8CUkWk2zOkeDBJfB57rNVw5wVMlb19yY3qW7y54+PwtcC6QAtTxEHA==
X-Received: by 2002:a19:6a06:: with SMTP id u6mr2208200lfu.187.1576070238958;
        Wed, 11 Dec 2019 05:17:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x12sm1154992ljd.92.2019.12.11.05.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 05:17:18 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1EB6718033F; Wed, 11 Dec 2019 14:17:17 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rg?= =?utf-8?Q?ensen?= 
        <thoiland@redhat.com>, Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next v3 0/6] Introduce the BPF dispatcher
In-Reply-To: <CAJ+HfNiH4KUO-MXm3L8pka3dECC1S6rHUJ9NoMfyrhPD+9s9nw@mail.gmail.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com> <87h829ilwr.fsf@toke.dk> <CAJ+HfNjZnxrgYtTzbqj2VOP+5A81UW-7OKoReT0dMVBT0fQ1pg@mail.gmail.com> <CAJ+HfNiH4KUO-MXm3L8pka3dECC1S6rHUJ9NoMfyrhPD+9s9nw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Dec 2019 14:17:17 +0100
Message-ID: <8736drgfxe.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: I_VnyzP-N-eq88RoSqKIRg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Mon, 9 Dec 2019 at 18:42, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com=
> wrote:
>>
> [...]
>> > You mentioned in the earlier version that this would impact the time i=
t
>> > takes to attach an XDP program. Got any numbers for this?
>> >
>>
>> Ah, no, I forgot to measure that. I'll get back with that. So, when a
>> new program is entered or removed from dispatcher, it needs to be
>> re-jited, but more importantly -- a text poke is needed. I don't know
>> if this is a concern or not, but let's measure it.
>>
>
> Toke, I tried to measure the impact, but didn't really get anything
> useful out. :-(
>
> My concern was mainly that text-poking is a point of contention, and
> it messes with the icache. As for contention, we're already
> synchronized around the rtnl-lock. As for the icache-flush effects...
> well... I'm open to suggestions how to measure the impact in a useful
> way.

Hmm, how about:

Test 1:

- Run a test with a simple drop program (like you have been) on a
  physical interface (A), sampling the PPS with interval I.
- Load a new XDP program on interface B (which could just be a veth I
  guess?)
- Record the PPS delta in the sampling interval on which the program was
  loaded on interval B.

You could also record for how many intervals the throughput drops, but I
would guess you'd need a fairly short sampling interval to see anything
for this.

Test 2:

- Run an XDP_TX program that just reflects the packets.
- Have the traffic generator measure per-packet latency (from it's
  transmitted until the same packet comes back).
- As above, load a program on a different interface and look for a blip
  in the recorded latency.


Both of these tests could also be done with the program being replaced
being the one that processes packets on the physical interface (instead
of on another interface). That way you could also see if there's any
difference for that before/after patch...

-Toke

