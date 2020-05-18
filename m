Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B970B1D82F7
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 20:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgERSAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 14:00:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20873 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732327AbgERSAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 14:00:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589824851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N1n0SR1PzeyLNd/iLZvoOiXdjg2LI5YRkH1aM1h/zGE=;
        b=co9SgQUouvK+SseMUimBhDZ89w7Ke6NKjTHIJoBqs4DxH0eslrdrUiOhYACjBVByttGv7a
        F4UvZpCk+7GPkpMc0SBOPhbDelBJPyEi2adEVZDtprl88nYblnDWNyaZaCK+JlhgDDKGEh
        fki4IEF8UnJ1vtzyLmXhtvI/27pQ8Us=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-oGd3P6MmOfC3jUUi9rEl6w-1; Mon, 18 May 2020 14:00:49 -0400
X-MC-Unique: oGd3P6MmOfC3jUUi9rEl6w-1
Received: by mail-lf1-f69.google.com with SMTP id j12so4220015lfe.7
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 11:00:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=N1n0SR1PzeyLNd/iLZvoOiXdjg2LI5YRkH1aM1h/zGE=;
        b=KPCMrLkuSioJHvDhHrCZNdDfMR0WmbByrbDnDT5y/vyJ7p4lilVJaRs+hgvDZQp14c
         307kHAXfYYDZInHYrLweCUU1xKt3spJhZq1FiYvjTCmNvIiRNBBCI0h4SFjJVVq0cNK7
         aTQkErg6JbbnbEjH4bpW/Xw9YPvzb3KbGSboZQ29ceHYXLWgtbwI5MY2sLs9pWnyymZq
         4iFZ4JIE8K+sT3lY9OzrnkXhP51VVkCKtP6nCZdicw8DhTpTqaDjTZs3CkzQkmbX36ZL
         4WoQSRgnAuGtVVcwTGDjs+xE8CjzhUPyfVFZaQuNu4vFpReDt7K0EOwDKoIIPQsp2rfS
         5K3Q==
X-Gm-Message-State: AOAM531CfrBwOecFdJ/vJ8iBzQBocq256E9Y5EuQSpzg8mZ5zmIBUjq7
        idAr6r7Xsb7bJ2DAiwCeNw+1QORzGfwaT2Avnq3uY2NbrGZuwUwEIjRytUZEWa2zGCUkbw74Dyy
        HJOI04r7glr1nlhuZ
X-Received: by 2002:ac2:599e:: with SMTP id w30mr12262381lfn.188.1589824847894;
        Mon, 18 May 2020 11:00:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxghbYyl6e2GD4YPbP+bvgDAPhaMss7cjkYsRMGEokg9r5ciI4MzjWu7kbpdCI7didJzco4JQ==
X-Received: by 2002:ac2:599e:: with SMTP id w30mr12262362lfn.188.1589824847598;
        Mon, 18 May 2020 11:00:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id n2sm7355128lfl.53.2020.05.18.11.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 11:00:46 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 09314181510; Mon, 18 May 2020 20:00:46 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
In-Reply-To: <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
References: <20200513014607.40418-1-dsahern@kernel.org> <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com> <87lflppq38.fsf@toke.dk> <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 May 2020 20:00:45 +0200
Message-ID: <87h7wdnmwi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 5/18/20 3:08 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> I can see your point that fixing up the whole skb after the program has
>> run is not a good idea. But to me that just indicates that the hook is
>> in the wrong place: that it really should be in the driver, executed at
>> a point where the skb data structure is no longer necessary (similar to
>> how the ingress hook is before the skb is generated).
>
> Have you created a cls_bpf program to modify skbs? Have you looked at
> the helpers, the restrictions and the tight management of skb changes?
> Have you followed the skb from create to device handoff through the
> drivers? Have you looked at the history of encapsulations, gso handling,
> offloads, ...?

Have you tried re-reading the first sentence of the paragraph you're
replying to? You know, the one that started with "I can see your point
that..."

>> Otherwise, what you're proposing is not an egress hook, but rather a
>> 'post-REDIRECT hook', which is strictly less powerful. This may or may
>> not be useful in its own right, but let's not pretend it's a full egress
>> hook. Personally I feel that the egress hook is what we should be going
>> for, not this partial thing.
>
> You are hand waving. Be specific, with details.

Are you deliberately trying to antagonise me or something? It's a really
odd way to try to make your case...

> Less powerful how? There are only so many operations you can do to a
> packet. What do you want to do and what can't be done with this proposed
> change? Why must it be done as XDP vs proper synergy between the 2 paths.

I meant 'less powerful' in the obvious sense: it only sees a subset of
the packets going out of the interface. And so I worry that it will (a)
make an already hard to use set of APIs even more confusing, and (b)
turn out to not be enough so we'll end up needing a "real" egress hook.

As I said in my previous email, a post-REDIRECT hook may or may not be
useful in its own right. I'm kinda on the fence about that, but am
actually leaning towards it being useful; however, I am concerned that
it'll end up being redundant if we do get a full egress hook.

-Toke

