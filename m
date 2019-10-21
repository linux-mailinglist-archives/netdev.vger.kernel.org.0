Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C02DF1D6
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 17:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbfJUPnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 11:43:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51536 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728263AbfJUPnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 11:43:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571672628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QgEDmlU4KjaRhi5tHWO//UYciXggsDsReZTGKN9sqhk=;
        b=dZmIxp5lWZb+1OPirrXi7So80VRuEMqGbXemS1jBQEwT98Q40o1LD/HYFnS557gvAxjtsW
        tA8SGsM7C+v0UeQocu2JWr3CADZMPLay/2UkQ3Bj8ummzNrAQPSlh7scG8yXr3nVKmXJPs
        zZ1sOxIocQNYRep2yTwVNShcsNGF+1Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-xrCoMDCYO4iZB2ZRvZZBng-1; Mon, 21 Oct 2019 11:43:46 -0400
Received: by mail-wr1-f72.google.com with SMTP id v7so5595243wrf.4
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 08:43:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QgEDmlU4KjaRhi5tHWO//UYciXggsDsReZTGKN9sqhk=;
        b=p4kFqORpTueVPgEPhZ+aSBzb4UF0vxOItOvl1F57psDcObQkeNVsRX5Au/SyYiu8H7
         di6T0kebvMYcisO+64Rt53IS9HLBHtIu6DhVGQzBq/NKLPT02C36jpzkmTUJfPN6gUth
         SaHbvRyxA+twJy33CnSy93++c8mQV0jHEpR+mi1gD8AU9x0y2twcdNpNUiH51kNRGbSU
         LDEQSIOBmVKyp4z5SaCTZU0hKjQoMSDMih8j75uGV3Jk2Tf9dNUDEnugnjGEnwiMbmXI
         u8U5hd8qnZR7M1xCMk9ouh2Dco8K5Yzw51y2eg6p8vmRlZhP5FbvhuIzJxXrpUO6lM3u
         R5+Q==
X-Gm-Message-State: APjAAAUihY8WA1yOFs9ZrBBBO6wCHt5qfsZUfWVsDKfxRw8DYwnzBVjM
        hEiRNWVZOV4dwfzMtEmXbM3yMrU/pCaB3UvlvaMp+81Jz+YejI8NVTSIxY53W/UYNSPcUCW4ErB
        VcWhF5suzgK/pz9rE
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr20784414wmh.116.1571672625124;
        Mon, 21 Oct 2019 08:43:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyn1RIfXMEBTKBOTUdIgXhn99H11738mV2Dt39dKUS2CrGW6MfogptkFIyTvCtnn5Qtlu1Evw==
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr20784397wmh.116.1571672624930;
        Mon, 21 Oct 2019 08:43:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id k8sm29648345wrg.15.2019.10.21.08.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 08:43:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 816071800E9; Mon, 21 Oct 2019 17:43:43 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        "Samudrala\, Sridhar" <sridhar.samudrala@intel.com>,
        Jiong Wang <jiong.wang@netronome.com>
Subject: Re: [PATCH bpf-next v2] libbpf: use implicit XSKMAP lookup from AF_XDP XDP program
In-Reply-To: <CAJ+HfNjd+eMAmeBnZ8iANjcea9ZT2cnvm3axuRwvUEMDpa5zHw@mail.gmail.com>
References: <20191021105938.11820-1-bjorn.topel@gmail.com> <87h842qpvi.fsf@toke.dk> <CAJ+HfNiNwTbER1NfaKamx0p1VcBHjHSXb4_66+2eBff95pmNFg@mail.gmail.com> <87bluaqoim.fsf@toke.dk> <CAJ+HfNgWeY7oLwun2Lt4nbT-Mh2yETZfHOGcYhvD=A+-UxWVOw@mail.gmail.com> <CAJ+HfNjd+eMAmeBnZ8iANjcea9ZT2cnvm3axuRwvUEMDpa5zHw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 21 Oct 2019 17:43:43 +0200
Message-ID: <87v9sip0i8.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: xrCoMDCYO4iZB2ZRvZZBng-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Mon, 21 Oct 2019 at 15:37, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.co=
m> wrote:
>>
>> On Mon, 21 Oct 2019 at 14:19, Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
>> >
>> > Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>> >
>> [...]
>> > >
>> > > bpf_redirect_map() returns a 32-bit signed int, so the upper 32-bit
>> > > will need to be cleared. Having an explicit AND is one instruction
>> > > less than two shifts. So, it's an optimization (every instruction is
>> > > sacred).
>> >
>> > OIC. Well, a comment explaining that might be nice (since you're doing
>> > per-instruction comments anyway)? :)
>> >
>>
>> Sure, I can do a v3 with a comment, unless someone has a better idea
>> avoiding both shifts and AND.
>>
>> Thanks for taking a look!
>>
>
> Now wait, there are the JMP32 instructions that Jiong added. So,
> shifts/AND can be avoided. Now, regarding backward compat... JMP32 is
> pretty new. I need to think a bit how to approach this. I mean, I'd
> like to be able to use new BPF instructions.

Well, they went into kernel 5.1 AFAICT; does AF_XDP even work properly
in kernels older than that? For the xdp-tutorial we've just been telling
people to upgrade their kernels to use it (see, e.g.,
https://github.com/xdp-project/xdp-tutorial/issues/76).

-Toke

