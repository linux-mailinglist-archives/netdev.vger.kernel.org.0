Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB33B38F322
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 20:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhEXSlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 14:41:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232803AbhEXSlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 14:41:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621881591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CMfHoa6IpM5dqXHEXR66ytrwQnf7YpLgYSvDY3BxGTE=;
        b=BIHJ1sYnNhwauRX84Kpy2M3bO3PVHGn4CuQvt57bjbQDDjycO2SpUolFTU5uxtWYZ4pZQW
        LIDhaHZMgEiH26n/0oz1wim64dvHjCqvQJJg6n9lBU9A14E4qCAATzJmEfxqP71ddzO6s6
        xvhR359gEwMFS6J6KYVJ9gD/T2D4oMY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-VdQH3Z-GN0GLBGx5f_ILJQ-1; Mon, 24 May 2021 14:39:49 -0400
X-MC-Unique: VdQH3Z-GN0GLBGx5f_ILJQ-1
Received: by mail-ej1-f72.google.com with SMTP id bw21-20020a170906c1d5b02903df8cbe09ccso1122268ejb.11
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 11:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=CMfHoa6IpM5dqXHEXR66ytrwQnf7YpLgYSvDY3BxGTE=;
        b=oysbPGrvywmIUjAgadLmBY1V3HtePcyg1vFvQejfQeF9ENjVGDycg9ID9bUPrkFF0K
         8wZ3YyD6wIkA7TVOLyWIR6xLO8nWGEoXPwZBPAYsfWy3odUQQNReoHYTbY36sHUt3Mtr
         5ud7lKNE3YALIZscK7V+mU3Uyw4k0Q13FeYtJ0xjPprgdy+E+0Z64pIwoO8GnjU1Og/V
         /tOKNGBM62vYp+ZFldo1fUKEta2QFmBDIIPX2At5og4OPC0weD721I3ziouSd+altQLM
         5Ve5kGHpi/8AypqRnI9rqa1mKASdDQ/WT1dXb/1Aby5IHzUfn1N32nJOD7EY0KHVQPD6
         pH1A==
X-Gm-Message-State: AOAM533eBc5O2rJ/s6uRbPG1GEsDZkS9/qcVGW9b6cq9AQ6SqjHuvTiL
        Zz8AqexvO4HR/wvhxlRBKgysNN2yLDXkQLVwwf9T37uYZHYMkoh4eP8ChhOILFa2AHZ1BwW5imM
        gt6xrkfWUwxvaSItW
X-Received: by 2002:a17:907:6289:: with SMTP id nd9mr24263314ejc.384.1621881588388;
        Mon, 24 May 2021 11:39:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0s9NTWgKCVyxamPFjeE/UY3/9N5lA2xB4zFvP0Y+X949wQSjY0Rv0+v1HZt7vBNADT66Ctg==
X-Received: by 2002:a17:907:6289:: with SMTP id nd9mr24263289ejc.384.1621881588036;
        Mon, 24 May 2021 11:39:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id h9sm9695640edt.18.2021.05.24.11.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 11:39:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 43C8F180275; Mon, 24 May 2021 20:39:46 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
In-Reply-To: <CAADnVQL8qw4OYQp+ozJpgPnimNYV7PtShZ-4tqdY7fTBhHf2ww@mail.gmail.com>
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <87o8d1zn59.fsf@toke.dk>
 <CAADnVQL9xKcdCyR+-8irH07Ws7iKHjrE4XNb4OA7BkpBrkkEuA@mail.gmail.com>
 <CAADnVQL8qw4OYQp+ozJpgPnimNYV7PtShZ-4tqdY7fTBhHf2ww@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 24 May 2021 20:39:46 +0200
Message-ID: <87cztgyo0d.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Sun, May 23, 2021 at 8:58 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Sun, May 23, 2021 at 4:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>> >
>> > Still wrapping my head around this, but one thing immediately sprang to
>> > mind:
>> >
>> > > + * long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
>> > > + *   Description
>> > > + *           Set the timer expiration N msecs from the current time.
>> > > + *   Return
>> > > + *           zero
>> >
>> > Could we make this use nanoseconds (and wire it up to hrtimers) instea=
d?
>> > I would like to eventually be able to use this for pacing out network
>> > packets, and msec precision is way too coarse for that...
>>
>> msecs are used to avoid exposing jiffies to bpf prog, since msec_to_jiff=
ies
>> isn't trivial to do in the bpf prog unlike the kernel.
>> hrtimer would be great to support as well.
>> It could be implemented via flags (which are currently zero only)
>> but probably not as a full replacement for jiffies based timers.
>> Like array vs hash. bpf_timer can support both.
>
> After reading the hrtimer code I might take the above statement back...
> hrtimer looks strictly better than timerwheel and jiffies.
> It scales well and there are no concerns with overload,
> since sys_nanonsleep and tcp are heavy users.
> So I'm thinking to drop jiffies approach and do hrtimer only.
> wdyt?

Oops, sorry, crossed streams, didn't see this before sending my other
reply. Yeah, hrtimers only SGTM :)

-Toke

