Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06DF33B5DE7
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 14:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhF1MXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 08:23:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232833AbhF1MXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 08:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624882887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7DySyswlfe87nm5LPAvUQAuBcS2ywXAMZom2XmcAtdQ=;
        b=X5e3V+1FvXlKLgbIcZKhwOt+fLb0hrHtn4P5p4J5MnFHBq4bYa07hXOFKppQjGreEoP2p6
        s0aJGAm2weGU/ngyOkQ95JWzNiiDkjrxppIw2col9ejzOFFmHOR30Sn5FZPLPXtNQb0ojd
        Kfd7WL5R8qwijBnhGl9JWeKu1oUaRIM=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-1usAv248M028g3QjDIRcSQ-1; Mon, 28 Jun 2021 08:21:23 -0400
X-MC-Unique: 1usAv248M028g3QjDIRcSQ-1
Received: by mail-ed1-f69.google.com with SMTP id f20-20020a0564020054b0290395573bbc17so2179125edu.19
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 05:21:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7DySyswlfe87nm5LPAvUQAuBcS2ywXAMZom2XmcAtdQ=;
        b=VoIXt7QA37LDFsUpxNeSD1zjuzHFxYwNVlfIorDH6gZlAMvU+t/27xDD60tKzHKT5I
         j87tsm0RcDFMPYzfGQsHgAN5s3bP249yXTnk8649pxfDqDHo0zAcql6736/V3CjYrB0A
         cKWEDMDWsGa+el8hEn87+29ZNMTnZmqQqmukfQTvdGtu/YwE4gne7GIAgeRHfWDhxyQW
         uizjrk2kzdgd8Nw/geW6Zx14rRO0Y5qNj+7NPqCssaBrPL0yNkhxoNX53tLo92nyVPco
         c0JhiFB+UY6iVgyodOb5mO44YKi1k+qlFSJDswj1mTxm3giDXBumoBih05UaRAdBqLxx
         YVQg==
X-Gm-Message-State: AOAM530fKZnYLStKJnQxkGh6JJgsRSiK5cysaDifxJn8apoq8zEu2Pq/
        kj9AyQ3L1A+KNa7RkBlKwZZ26iXlPM+4PUG+Xe6Txq2QJMm4/k3emhQrGrf44Jca44Cfo62QORm
        MRnWPMYh426RwEMLB
X-Received: by 2002:a17:906:9be5:: with SMTP id de37mr2359698ejc.549.1624882882708;
        Mon, 28 Jun 2021 05:21:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCCTJsL7eCd8tO3CTaohACscZDFQuj/jU2zidvwTZigoCEauLOtGmJsCKN2Zr2qFvQ2zAsNA==
X-Received: by 2002:a17:906:9be5:: with SMTP id de37mr2359688ejc.549.1624882882565;
        Mon, 28 Jun 2021 05:21:22 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id yh13sm6730379ejb.28.2021.06.28.05.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 05:21:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6F35F18071E; Mon, 28 Jun 2021 14:21:20 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Niclas Hedam <nhed@itu.dk>
Cc:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH v2] net: sched: Add support for packet bursting.
In-Reply-To: <B28935AB-6078-4258-8E7C-14E11D1AD57F@itu.dk>
References: <532A8EEC-59FD-42F2-8568-4C649677B4B0@itu.dk>
 <877diekybt.fsf@toke.dk> <B28935AB-6078-4258-8E7C-14E11D1AD57F@itu.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 28 Jun 2021 14:21:20 +0200
Message-ID: <87wnqeji2n.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Niclas Hedam <nhed@itu.dk> writes:

>>> From 71843907bdb9cdc4e24358f0c16a8778f2762dc7 Mon Sep 17 00:00:00 2001
>>> From: Niclas Hedam <nhed@itu.dk>
>>> Date: Fri, 25 Jun 2021 13:37:18 +0200
>>> Subject: [PATCH] net: sched: Add support for packet bursting.
>> 
>> Something went wrong with the formatting here.
>
> I'll resubmit with fixed formatting. My bad.
>
>>> 
>>> This commit implements packet bursting in the NetEm scheduler.
>>> This allows system administrators to hold back outgoing
>>> packets and release them at a multiple of a time quantum.
>>> This feature can be used to prevent timing attacks caused
>>> by network latency.
>> 
>> How is this bursting feature different from the existing slot-based
>> mechanism?
>
> It is similar, but the reason for separating it is the audience that they are catering.
> The slots seems to be focused on networking constraints and duty cycles.
> My contribution and mechanism is mitigating timing attacks. The
> complexity of slots are mostly unwanted in this context as we want as
> few CPU cycles as possible.

(Adding Dave who wrote the slots code)

But you're still duplicating functionality, then? This has a cost in
terms of maintainability and interactions (what happens if someone turns
on both slots and bursting, for instance)?

If the concern is CPU cost (got benchmarks to back that up?), why not
improve the existing mechanism so it can be used for your use case as
well?

-Toke

