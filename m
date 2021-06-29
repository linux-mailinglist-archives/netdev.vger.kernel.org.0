Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A6E3B746A
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234472AbhF2Oht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:37:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35200 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234256AbhF2Ohq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:37:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624977317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e7T8EidlcQ2MrjAqYf6GFDN4Bmw64AXZix3bXf9swxs=;
        b=iwl8eP1YNMenRbS7s1EtHy5SwCZzfuuly7c5XTHWV9aA9hjB7l/6rlvoblbNapKdINAk5V
        cL+J7HauAygTWiKjB2DN5zeYxos7mDyeTwEKnXSF0q2hSS/mTJIrGydxVzvHgH76GgJbSD
        s4zXAIojrIDPbnbj51za+StZJ+YmeCY=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-B_05ZhADNcacDC5Vvffkpg-1; Tue, 29 Jun 2021 10:35:15 -0400
X-MC-Unique: B_05ZhADNcacDC5Vvffkpg-1
Received: by mail-ed1-f70.google.com with SMTP id d5-20020a0564020785b02903958939248aso177445edy.15
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=e7T8EidlcQ2MrjAqYf6GFDN4Bmw64AXZix3bXf9swxs=;
        b=lkEz5qyctje2sreqnRqZmWsW5JtWQ2kR+NQWqE6rSXEBYUCi/zieiPf7Bs9A3FQQ53
         MEnSdW5U6GRycGwPrnh5JBFjBInwVzTnibjgTmCUwGVL76gSPe6byluzJo8RkI9pptBX
         C79SoweV142hjZVyvyn2ygxybjExUSwvHkKzKzw2qjg9RA1OT1Omowuw6N2fxAmdMbPR
         hVs93qgTFMMBoOWWPGt4a4YmXFRTJvKl1rQIdcBrU+OmxunRQZEyvdcbZwfMARn6jIbx
         9X3CPKMmHGrdfecOFE2FZHuSftQ6nUnXQlQEOvXstC7eS2a4knozH9OcgqAGDsJg8hrE
         xZYw==
X-Gm-Message-State: AOAM530dZtWdItk5N2vAaTdnYPd2NbpgrONGAkAMv7HywrKXSk6Tkil9
        e2hEAkrg2GP9nT2FIAJEcT9aKVobArafDBU1qdwXyqKdBFS1riRMBuNpxMTG9vvlh75OvgHT3GZ
        3vAKa6eSRBmveN0ur
X-Received: by 2002:a17:906:1953:: with SMTP id b19mr30873823eje.541.1624977314384;
        Tue, 29 Jun 2021 07:35:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNk8pPC31oMLLHCm33OC3Wf4FDFEJsWTHkvcXQjWfKRdTMCjbb3VTCyZy+/r6MuFsSruGENg==
X-Received: by 2002:a17:906:1953:: with SMTP id b19mr30873800eje.541.1624977314124;
        Tue, 29 Jun 2021 07:35:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q5sm8211556ejc.117.2021.06.29.07.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:35:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1974318071E; Tue, 29 Jun 2021 16:35:11 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Niclas Hedam <nhed@itu.dk>
Cc:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH v2] net: sched: Add support for packet bursting.
In-Reply-To: <B95D6635-02AE-4912-B521-2BECEE16927E@itu.dk>
References: <532A8EEC-59FD-42F2-8568-4C649677B4B0@itu.dk>
 <877diekybt.fsf@toke.dk> <B28935AB-6078-4258-8E7C-14E11D1AD57F@itu.dk>
 <87wnqeji2n.fsf@toke.dk> <B95D6635-02AE-4912-B521-2BECEE16927E@itu.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 29 Jun 2021 16:35:11 +0200
Message-ID: <87zgv8ivs0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Niclas Hedam <nhed@itu.dk> writes:

> Thanks for the valuable thoughts, Toke.
>
> The patch started with me being tasked to try and mitigate timing
> attacks caused by network latencies. I scouted over the current
> network stack and didn't find anything that fully matched my use-case.
> While I now understand that you can actually leverage the slots
> functionality for this, I would still opt for a new interface and
> implementation.

So what is the actual use case for this? If this is something you're
actually planning to deploy this in production, I'm not sure netem is
the best place for it...

> I have not done any CPU benchmarks on the slots system, so I'm not
> approaching this from the practical performance side per se.
>
> Instead, I argue for seperation with reference to the Seperation of
> Concern design principle. The slots functionality is not
> built/designed to cater security guarantees, and my patch is not built
> to cater duty cycles, etc.

Separation of concerns is all well and good, but you're still adding
this to an existing qdisc (and one mostly used for emulating networks,
at that), in a way that will silently disable most of the other
functionality. I.e., if the 'bursting' field is set, 'rate' and
'latency' will just silently stop working because you're skipping the
code path that uses those.

So you'll need to reject invalid combinations at configure time, which
AFAICT is any other feature combined with bursting. Also, please add an
unlikely() around the check for the bursting parameter to hint the
compiler that this is not the most commonly used feature.

> If we opt to merge these two functionalities or discard mine, we have
> to implement some guarantee that the slots functionality won't become
> significantly slower or complex, which in my opinion is less
> maintainable than two similar systems. Also, this patch is very
> limited in lines of code, so maintaining it is pretty trivial.

Maintenance is not just about lines of code, it is also about
combination of features (e.g., dealing with things like "my rate limiter
stopped working after I turned on this 'security' feature"). At the very
least you'll need to clearly document interactions (and refuse invalid
combinations as mentioned above).

-Toke

