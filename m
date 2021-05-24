Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81CD238F31A
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 20:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbhEXSkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 14:40:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232547AbhEXSkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 14:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621881524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6kfBQcOOypFceqH2usmIITmz3BJPUgfGQcjFZT1RnX0=;
        b=FKTCfnCAPvUElIzSrBNBxi7h+abrMUyBSK44QaJJAGiGxfNh78fRTAnnTLp0ij1+5KXo8P
        jArsT71NpY0KYj9a1giLCPBJqcik6JMC3OV36lWLBbAgXgsrbEMgSxUk36KLeG/vQafA39
        Fh5L4j4QrxN5wSva5ZQg7Ahb8t7TKWc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-o9xhQOw_MBa8SLojB0DdOw-1; Mon, 24 May 2021 14:38:42 -0400
X-MC-Unique: o9xhQOw_MBa8SLojB0DdOw-1
Received: by mail-ej1-f71.google.com with SMTP id mp38-20020a1709071b26b02903df8ccd76fbso1127551ejc.23
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 11:38:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=6kfBQcOOypFceqH2usmIITmz3BJPUgfGQcjFZT1RnX0=;
        b=JWnkE6IUFm+wu80nQuAKFVacnPgjqELWv0298CpoMXlsl7i/UMcIqn5+/PFWam8sBG
         YQPn0urJpY2ubTTVWC7VJEJliWgOUTO3Cgy+R5PebFGT4h+T8+Q+bXi0VWaWkXe2vXtd
         Dgafamcd5ejIOcnHIifu0zovZ4EM27oe2CrQtpgGVf8vTgIXY6DPQifTy17gt2dmirVp
         g5vWTlKHMnMs/rJjRYb8LPsFWIBQ2usBo02rFO3tmUQIY1ew7DTKeAmtspLRtHXeiEVa
         RmUCJN1VRn77LuMhDaceBF5ar75aKT+FoN+CbOVtNDvNii0bej793M349CQqaarCWhxs
         vaoQ==
X-Gm-Message-State: AOAM532p0vk23HTjp35j6zty7T6npW2j5ohwCsoGv5Wiw+SpTuJBC9OI
        Xllg0ofhsIHaGTh0NvZ6hopkDO/2k6kfE/Zgo4cte95rVgfPK88PLDmy/dKxMDEM6fPd41uzP9Z
        RH3hoeUrfjXKS8AwI
X-Received: by 2002:a17:906:33d6:: with SMTP id w22mr24199445eja.222.1621881521406;
        Mon, 24 May 2021 11:38:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxs4NXcIQ/KGjvlP/nceh9M43tmZGNTdGambMuToDFEj03VFJY0GCKq8HwE7LKfr56CunAjeg==
X-Received: by 2002:a17:906:33d6:: with SMTP id w22mr24199421eja.222.1621881520872;
        Mon, 24 May 2021 11:38:40 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id i22sm8313352ejz.20.2021.05.24.11.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 11:38:39 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 69B41180275; Mon, 24 May 2021 20:38:38 +0200 (CEST)
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
In-Reply-To: <CAADnVQL9xKcdCyR+-8irH07Ws7iKHjrE4XNb4OA7BkpBrkkEuA@mail.gmail.com>
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <87o8d1zn59.fsf@toke.dk>
 <CAADnVQL9xKcdCyR+-8irH07Ws7iKHjrE4XNb4OA7BkpBrkkEuA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 24 May 2021 20:38:38 +0200
Message-ID: <87fsycyo29.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Sun, May 23, 2021 at 4:48 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Still wrapping my head around this, but one thing immediately sprang to
>> mind:
>>
>> > + * long bpf_timer_mod(struct bpf_timer *timer, u64 msecs)
>> > + *   Description
>> > + *           Set the timer expiration N msecs from the current time.
>> > + *   Return
>> > + *           zero
>>
>> Could we make this use nanoseconds (and wire it up to hrtimers) instead?
>> I would like to eventually be able to use this for pacing out network
>> packets, and msec precision is way too coarse for that...
>
> msecs are used to avoid exposing jiffies to bpf prog, since msec_to_jiffi=
es
> isn't trivial to do in the bpf prog unlike the kernel.
> hrtimer would be great to support as well.
> It could be implemented via flags (which are currently zero only)
> but probably not as a full replacement for jiffies based timers.
> Like array vs hash. bpf_timer can support both.

Okay, so this is really:

long bpf_timer_mod(struct bpf_timer *timer, u64 interval)

where 'interval' will be expressed in either milliseconds or nanoseconds
depending on which flags are passed to bpf_timer_init()? That's fine by
me, then; I just wanted to make sure that that 'msecs' was not an
indication that this was the only granularity these timers would
support... :)

-Toke

