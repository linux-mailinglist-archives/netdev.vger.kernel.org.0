Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E74B14901A
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgAXV2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:28:06 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54335 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725747AbgAXV2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 16:28:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579901284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j3hS2Y+apGC6o9b0+sPiHrHavwxAiQEEfKpHkoIkn8s=;
        b=MXZwCgIxMKhtmW9V4pgwDmpytBoUWNYADc0KZ/z0HAR9dfWFFu3j8fTVsh+wDGoV6nXfmh
        8wKdS9xojFgOty61O/nmwM5dJ2u8ZFA1Kt0ynGAHMFDdrJWpN6LIOiK1dovTmB0PljjsiO
        0qKu6tT2XUE/GKLWJ9trOa4+zT5MusA=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-iEK1YlowN9GLvkbqUUyLIw-1; Fri, 24 Jan 2020 16:28:02 -0500
X-MC-Unique: iEK1YlowN9GLvkbqUUyLIw-1
Received: by mail-lj1-f198.google.com with SMTP id k21so899621ljg.3
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 13:28:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=j3hS2Y+apGC6o9b0+sPiHrHavwxAiQEEfKpHkoIkn8s=;
        b=T1+9aejNok5tDiO47vTis8NntvjochAlqIXkeYMYSqeiRR1noex1CM9ApOpRf6D/J5
         9vHwjPpiqnk0s3GQeh476aJ9LjnykRv8Ytv2mKdjnw6cBAP4ct5uQDni7EV2b6rxlu6M
         rpj9HBkh2RCQpBpYyFVgC6NWfZiz0daqAls76EtLgPayYJKSsttnQUnBevMnPbhYA4iS
         ZMfRTqp4tF01nlx92dKvDB0G9Z4ydyw0Uyvvgd/r3qFMmKAsajvAyzrIkoBOfJjzT5D4
         MqzAvsQEDPCTEaxwkEsETBUkhLqmQMDy0P2e5p81yPsvpjZ/FLJSo7WplPCmLU8BHB2h
         cmFA==
X-Gm-Message-State: APjAAAUFuD8ZM3gt0edpnAnTBiWYTPDQklajTZXL2VL2mMNHaNk6Z+0R
        LwfLoLf+XaUcn6Phhlr8l5letfJRhoyGqoLqhL8uxP6Zs1lA4mq2qQiKAefhfyCX9s3TAUV8XrT
        CIl/mA5UlPWUMg0hp
X-Received: by 2002:a2e:1459:: with SMTP id 25mr1994880lju.189.1579901280552;
        Fri, 24 Jan 2020 13:28:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqwL7A9ZessnB3WyntrB9qegzGEm+IFRxd30+KduTeVOpjOlpSat1WY2iRzk7mVCXxOG6EDnZw==
X-Received: by 2002:a2e:1459:: with SMTP id 25mr1994866lju.189.1579901280315;
        Fri, 24 Jan 2020 13:28:00 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id a11sm3363644lfb.34.2020.01.24.13.27.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 13:27:59 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B1D2B180073; Fri, 24 Jan 2020 22:27:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Luigi Rizzo <lrizzo@google.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com
Subject: Re: [PATCH] net-xdp: netdev attribute to control xdpgeneric skb linearization
In-Reply-To: <CAMOZA0KZOyEjJj3N7WQNRYi+n91UKkWihQRjxdrbCs9JdM5cbg@mail.gmail.com>
References: <20200122203253.20652-1-lrizzo@google.com> <875zh2bis0.fsf@toke.dk> <953c8fee-91f0-85e7-6c7b-b9a2f8df5aa6@iogearbox.net> <87blqui1zu.fsf@toke.dk> <CAMOZA0Kmf1=ULJnbBUVKKjUyzqj2JKfp5ub769SNav5=B7VA5Q@mail.gmail.com> <875zh2hx20.fsf@toke.dk> <CAMOZA0JSZ2iDBk4NOUyNLVE_KmRzYHyEBmQWF+etnpcp=fe0kQ@mail.gmail.com> <b22e86ef-e4dd-14a3-fb1b-477d9e61fefa@iogearbox.net> <87r1zpgosp.fsf@toke.dk> <CAMOZA0+neBeXKDyQYxwP0MqC9TqGWV-d3S83z_EACH=iOEb6mw@mail.gmail.com> <87r1zog9cj.fsf@toke.dk> <CAMOZA0KZOyEjJj3N7WQNRYi+n91UKkWihQRjxdrbCs9JdM5cbg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Jan 2020 22:27:58 +0100
Message-ID: <87a76cfstd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luigi Rizzo <lrizzo@google.com> writes:

> On Fri, Jan 24, 2020 at 7:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Luigi Rizzo <lrizzo@google.com> writes:
>>
> ...
>> > My motivation for this change is that enforcing those guarantees has
>> > significant cost (even for native xdp in the cases I mentioned - mtu >
>> > 1 page, hw LRO, header split), and this is an interim solution to make
>> > generic skb usable without too much penalty.
>>
>> Sure, that part I understand; I just don't like that this "interim"
>> solution makes generic and native XDP diverge further in their
>> semantics...
>
> As a matter of fact I think it would make full sense to use the same appr=
oach
> to control whether native xdp should pay the price converting to linear b=
uffers
> when the hw cannot guarantee that.
>
> To me this seems to be a case of "perfect is enemy of good":..

Hmm, I can kinda see your point (now that I've actually grok'ed how the
length works with skbs and generic XDP :)). I would still worry that
only having the header there would lead some XDP programs to just
silently fail. But on the other hand, this is opt-in... so IDK - maybe
this is fine to merge as-is, and leave improvements for later?

-Toke

