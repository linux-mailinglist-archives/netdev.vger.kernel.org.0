Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 701371534CC
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 16:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBEPzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 10:55:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31950 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726678AbgBEPzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 10:55:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580918150;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JbXnDG/6nNKeQdTAz2d1XZx/5OAa043KSPnkNaGe/nM=;
        b=RPN1E12aOgN1eYpA6bnWPJKd6jijnQA7DTK16+K0tLx+GfR0lGhxiPN/42wPQS2rY+9Qlz
        sJAdmlwF92ElAQ6GUR9OzZ/wKH2OnsoEEV7QK+k3v/Dff7v9pxoO0kJLPcnicH8XxSPCBy
        NI0kygDlvw+NRmcxZJ1G5E91irxdbJk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-mVkB4wfSN1i86NdE0zPOmg-1; Wed, 05 Feb 2020 10:55:48 -0500
X-MC-Unique: mVkB4wfSN1i86NdE0zPOmg-1
Received: by mail-lf1-f72.google.com with SMTP id k26so709561lfm.0
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 07:55:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=JbXnDG/6nNKeQdTAz2d1XZx/5OAa043KSPnkNaGe/nM=;
        b=Q2HzENOSc+Q1SdA7ZIfyxMT95zpQ14AImIhTZHwusTMPb/zzxsmNOmei9bzf7PVU2o
         Lg9g6Z1y/HKnpTJ5jAgS3GR/qhgSrQooB1XNBDB5G6BJtMYqC38YVE6EkmJLN9S6lkBu
         SxTiyB88gVFFTTKozKpy8ylyx+jMk0fu9BO3+hm1WWvUZysYF4TqMAalYf6ACFrcCa7C
         s2g3oebp5OL6LFS4cdHtBuKTUjisJmL7fDdjPzg9c1z4+g3Gn2a5KhET+yt5mQS4zDrs
         tgx/OWMEaCMrTZtOe8kJDsvobFXIIvlUJfmAZTgMrxiufO6LDrdJj09zDfiQHW/SRGw1
         XyqQ==
X-Gm-Message-State: APjAAAV1+d48wnU2Apy/z7zLdKY3uqrcFfQENFxUBIE7rtzXut9c8Utj
        xzzNCRm39jZB+ziYfHZcBkRjUdqiTw1kFsGS4s8KxZ/MthmcvCsFsmU8FphqszJs3Zo/JElABOJ
        R2yQ1dqnlgWvLbo59
X-Received: by 2002:a2e:b017:: with SMTP id y23mr20634669ljk.229.1580918146912;
        Wed, 05 Feb 2020 07:55:46 -0800 (PST)
X-Google-Smtp-Source: APXvYqyOnCfiBNRR4QuFU2V7Ts67R/IlY+A16BxHP7Ss6R58TOm3JL1VxqoQIXJKZxa6qgD81gDhuQ==
X-Received: by 2002:a2e:b017:: with SMTP id y23mr20634655ljk.229.1580918146701;
        Wed, 05 Feb 2020 07:55:46 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f5sm12458582lfh.32.2020.02.05.07.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 07:55:46 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5DE171802D4; Wed,  5 Feb 2020 16:55:45 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Luigi Rizzo <rizzo@iet.unipi.it>
Cc:     Luigi Rizzo <lrizzo@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jubran\, Samih" <sameehj@amazon.com>
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
In-Reply-To: <CA+hQ2+hnqifXzyHjjc5TXJmJz_EVCbuF6vGchKjaWccfK2ZA4g@mail.gmail.com>
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk> <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <87blqui1zu.fsf@toke.dk> <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com> <875zh2hx20.fsf@toke.dk> <CAMOZA0JSZ2iDBk4NOUyNLVE_KmRzYHyEBmQWF+etnpcp=fe0kQ@mail.gmail.com> <b22e86ef-e4dd-14a3-fb1b-477d9e61fefa@iogearbox.net> <87r1zpgosp.fsf@toke.dk> <CAMOZA0+neBeXKDyQYxwP0MqC9TqGWV-d3S83z_EACH=iOEb6mw@mail.gmail.com> <87r1zog9cj.fsf@toke.dk> <CAMOZA0KZOyEjJj3N7WQNRYi+n91UKkWihQRjxdrbCs9JdM5cbg@mail.gmail.com> <87a76cfstd.fsf@toke.dk> <CA+hQ2+hnqifXzyHjjc5TXJmJz_EVCbuF6vGchKjaWccfK2ZA4g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 05 Feb 2020 16:55:45 +0100
Message-ID: <874kw5do5a.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luigi Rizzo <rizzo@iet.unipi.it> writes:

> On Fri, Jan 24, 2020 at 1:28 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com>
> wrote:
>
>> Luigi Rizzo <lrizzo@google.com> writes:
>>
>> > On Fri, Jan 24, 2020 at 7:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com>
>> wrote:
>> >>
>> >> Luigi Rizzo <lrizzo@google.com> writes:
>> >>
>> > ...
>> >> > My motivation for this change is that enforcing those guarantees has
>> >> > significant cost (even for native xdp in the cases I mentioned - mt=
u >
>> >> > 1 page, hw LRO, header split), and this is an interim solution to m=
ake
>> >> > generic skb usable without too much penalty.
>> >>
>> >> Sure, that part I understand; I just don't like that this "interim"
>> >> solution makes generic and native XDP diverge further in their
>> >> semantics...
>> >
>> > As a matter of fact I think it would make full sense to use the same
>> approach
>> > to control whether native xdp should pay the price converting to linear
>> buffers
>> > when the hw cannot guarantee that.
>> >
>> > To me this seems to be a case of "perfect is enemy of good":..
>>
>> Hmm, I can kinda see your point (now that I've actually grok'ed how the
>> length works with skbs and generic XDP :)). I would still worry that
>> only having the header there would lead some XDP programs to just
>> silently fail. But on the other hand, this is opt-in... so IDK - maybe
>> this is fine to merge as-is, and leave improvements for later?
>>
>
> Sorry I let this slip, any consensus on this patch?

Dunno if there's a consensus, but I certainly ran out of objections ;)

-Toke

