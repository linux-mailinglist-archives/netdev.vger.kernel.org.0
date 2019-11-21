Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7F61051F7
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 13:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfKUMAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 07:00:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22971 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726342AbfKUMAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 07:00:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574337634;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q5rBJ14foXXsUIH3cvZz1qwUhkNTdgEVQ2KMu92pgrc=;
        b=AyelN1s+AkXr34ib9Rkxq7/AZG9NJ49hakZrKNdFQAu39K6Be910XjW6TGCsHQ9FRXgVLZ
        UvVCq6oOC6Fa400cuU2vGcLcH8itmX3uYsiiVrpubHN4wzoiotgZNELLOk8Tp8THq1+S+u
        7qHPFRV16cWS9CRpjux7qEktpTFmQrw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-45-hWfkcAcKP_yGa-xu0F6F0Q-1; Thu, 21 Nov 2019 07:00:30 -0500
Received: by mail-lf1-f71.google.com with SMTP id v204so860746lfa.0
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 04:00:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=x7Br6MUt5GIrekmwoW3W/dVDofzaSmCZ4ehtQgntfJg=;
        b=AhhMUjbXCHn+4ZfiGWe+k0vqCbLO284lWD9aKUD3ywSLuusSgkvgHa0a2GUvvzm3t+
         HzfokuAO538OOmtWyw5WoezLPT4X5eJ0xSwSG1NjjRS4RxT8J/W8Hw+/+YHx8iNNdmKs
         SgAYVxZtikE6nGddT9ai2QmmUKCbstrdCkHOMX5D60acDFT+Avk37PjI0o5/LLbNZIL1
         2t8zQo7aKf+5yBKZpvAVdrlhoDPw0kGFscE0k6Q/VHb3H9S6kWMx0OXvotPeX51ighB/
         zjRyDhmRkxu+iA7iGbubdcrI9Q7ycu04te5E+8/VVz9ZZ+CRq00ETaq+0ZIfQ0c4i+au
         THQA==
X-Gm-Message-State: APjAAAWajYypaKJvJ1slgvqjGC2OrHNyBMTgsNcZcsaV7FB9/nuudgL/
        ddPGmDXmRTl12OYo/njSTdgbVzl4Cx9O+tvT3z0LVjEAWWIPhi5PSHTNsuTWdhId5JW7tXQ3yDq
        Z8tllmlx06/WliwOD
X-Received: by 2002:ac2:4a71:: with SMTP id q17mr7003192lfp.179.1574337629227;
        Thu, 21 Nov 2019 04:00:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqwoeKMb/g8JM/lXuuI1qNoHv9YuoiOe6iH1WkPLFXbg9oIhgY0S6Dx/PfPzgSPCEeKonyhh5w==
X-Received: by 2002:ac2:4a71:: with SMTP id q17mr7003168lfp.179.1574337628964;
        Thu, 21 Nov 2019 04:00:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id k25sm1144384ljg.22.2019.11.21.04.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 04:00:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C838A1818BA; Thu, 21 Nov 2019 13:00:26 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH RFC net-next] net: WireGuard secure network tunnel
In-Reply-To: <CAHmME9rmFw7xGKNMURBUSiezbsBEikOPiJxtEu=i2Quzf+JNDg@mail.gmail.com>
References: <20191120203538.199367-1-Jason@zx2c4.com> <877e3t8qv7.fsf@toke.dk> <CAHmME9rmFw7xGKNMURBUSiezbsBEikOPiJxtEu=i2Quzf+JNDg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 21 Nov 2019 13:00:26 +0100
Message-ID: <87lfs9782t.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: hWfkcAcKP_yGa-xu0F6F0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

>> > +     MAX_QUEUED_INCOMING_HANDSHAKES =3D 4096, /* TODO: replace this w=
ith DQL */
>> > +     MAX_STAGED_PACKETS =3D 128,
>> > +     MAX_QUEUED_PACKETS =3D 1024 /* TODO: replace this with DQL */
>>
>> Yes, please (on the TODO) :)
>>
>> FWIW, since you're using pointer rings I think the way to do this is
>> probably to just keep the limits in place as a maximum size, and then
>> use DQL (or CoDel) to throttle enqueue to those pointer rings instead of
>> just letting them fill.
>>
>> Happy to work with you on this (as I believe I've already promised), but
>> we might as well do that after the initial version is merged...
>
> I've actually implemented this a few times, but DQL always seems too
> slow to react properly, and I haven't yet been able to figure out
> what's happening. Let's indeed work on this after the initial version
> is merged. I think this change, and several more like it, will be the
> topic of some interesting discussions. But that doesn't need to happen
> /now/ I don't think.

Agreed. Let's wait until the initial version is merged and use that as a
base to benchmark against... :)

-Toke

