Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D178A109A49
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 09:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbfKZIhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 03:37:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:39227 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725862AbfKZIhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 03:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574757428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CiThcm+OInD3gyIGSpze6EFepWoQ5Vi4p+3RZ0sOOSQ=;
        b=XqIzJ6Q9rOBnP4bzhy25odCXLT5yrTEW9WNwEWQURl2swJ2yQgTdTUn6jdPBOSHuoeM9EP
        0ihC/tCsRZhbs8w8eD632RLbrDKOF0g6vdnuYxPtfAwgG5gWdY8xl/hamYrSp9+EjtL/Pl
        vm+MX0vQaKAXWyRnlTJZOATt/ubtEzE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-JVVd3_CTPQGJ8I16SRiuvw-1; Tue, 26 Nov 2019 03:37:07 -0500
Received: by mail-lf1-f71.google.com with SMTP id m2so3715348lfo.20
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 00:37:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=CiThcm+OInD3gyIGSpze6EFepWoQ5Vi4p+3RZ0sOOSQ=;
        b=iNvlIXOSGvaQ/RehVuhAeyVuPMbRXosqBCiL00IaJMVO15m6FsedF8vTmiV1WzJDXQ
         QiRnqW4IECaaKxKXvZEOfbYkd9MIHWtoKMotbICq1gIJt+7kAHOUTeQ3QIdpOd8Bj/bG
         fjQXHp9avswRN0FnG+ezSrNAkbqCzNMRV98910u+xW/fFjSC5wLn2SqjP8NEIdv5YaPK
         4M69ApMUs190DPg3Qcj5d8Gdnitq4+RCVx8daKxAflrATou5cYfFkZuT1UTV4pS+0NxA
         qbq1ep+IMEyEjXqmYXQR+aOb9YxBG8FbQ+N9uBADwu+Gte/y5Q6KiaCWMgEYprTUvIlQ
         sYfg==
X-Gm-Message-State: APjAAAVcbQQmnVwdSi8JtV2WsEqRjR/xdvSEaoCCyOH6PFNur57K+oqB
        a2upYZ9Z0k8wP7pW47qCtyeN5q6Sf8kWGJnseNotrmdUEEkoyF3X+XTJBtJgYSPNNdZc4a3/6MW
        SIeDuJdWR6xk0PAHf
X-Received: by 2002:a2e:3c08:: with SMTP id j8mr25147616lja.28.1574757426174;
        Tue, 26 Nov 2019 00:37:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqwaiaQ1OIfy0q38rI5PM7IFy5ExCSJqnKE1HS++di5Xihmi+hAb45fkzM7FT30t3Xwxq++qvw==
X-Received: by 2002:a2e:3c08:: with SMTP id j8mr25147595lja.28.1574757425975;
        Tue, 26 Nov 2019 00:37:05 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id m124sm4933576lfd.44.2019.11.26.00.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 00:37:05 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7D1761818BF; Tue, 26 Nov 2019 09:37:03 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: Re: [PATCH bpf-next v2 2/6] xdp: introduce xdp_call
In-Reply-To: <CAJ+HfNhSba7B=SFK0-zjYqFMfwjiq-AVY2Ar7E0P5Pw6gNqTJA@mail.gmail.com>
References: <20191123071226.6501-1-bjorn.topel@gmail.com> <20191123071226.6501-3-bjorn.topel@gmail.com> <875zj82ohw.fsf@toke.dk> <CAJ+HfNhFERV+xE7EUup-tu_nBTTqG=7L8bWm+W8h_Lzth4zuKQ@mail.gmail.com> <87d0dg0x17.fsf@toke.dk> <CAJ+HfNhSba7B=SFK0-zjYqFMfwjiq-AVY2Ar7E0P5Pw6gNqTJA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 26 Nov 2019 09:37:03 +0100
Message-ID: <87o8wzyqxc.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: JVVd3_CTPQGJ8I16SRiuvw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Mon, 25 Nov 2019 at 16:56, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>>
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>
>> > On Mon, 25 Nov 2019 at 12:18, Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
>> >>
>> >> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>> >>
>> >> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>> >> >
>> >> > The xdp_call.h header wraps a more user-friendly API around the BPF
>> >> > dispatcher. A user adds a trampoline/XDP caller using the
>> >> > DEFINE_XDP_CALL macro, and updates the BPF dispatcher via
>> >> > xdp_call_update(). The actual dispatch is done via xdp_call().
>> >> >
>> >> > Note that xdp_call() is only supported for builtin drivers. Module
>> >> > builds will fallback to bpf_prog_run_xdp().
>> >>
>> >> I don't like this restriction. Distro kernels are not likely to start
>> >> shipping all the network drivers builtin, so they won't benefit from =
the
>> >> performance benefits from this dispatcher.
>> >>
>> >> What is the reason these dispatcher blocks have to reside in the driv=
er?
>> >> Couldn't we just allocate one system-wide, and then simply change
>> >> bpf_prog_run_xdp() to make use of it transparently (from the driver
>> >> PoV)? That would also remove the need to modify every driver...
>> >>
>> >
>> > Good idea! I'll try that out. Thanks for the suggestion!
>>
>> Awesome! I guess the table may need to be a bit bigger if it's
>> system-wide? But since you've already gone to all that trouble with the
>> binary search, I guess that shouldn't have too much of a performance
>> impact? Maybe the size could even be a config option so users/distros
>> can make their own size tradeoff?
>>
>
> My bigger concern is not the dispatcher size, but that any XDP update
> will be a system wide text-poke. OTOH, this is still the case even if
> there are multiple dispatchers. No more "quickly swap XDP program in
> one packet latency".

Ah, right. I don't actually know the details of how all this kernel text
rewriting happens. I just assumed it was magic faerie dust that just
made everything faster; but now you're telling me there are tradeoffs?! ;)

When you say "no more quickly swap XDP programs" you mean that the
attach operation itself will take longer, right? I.e., it's not that it
will disrupt packet flow to the old program while it's happening? Also,
how much longer?

-Toke

