Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5163431C3B5
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhBOVk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:40:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53226 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229672AbhBOVkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 16:40:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613425137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IxpTKqSAJdujWUQZD0dx8MvcWVHfhoD9kdfrZZUHBAg=;
        b=OuvfuS8Oq+/Uf46fqQR6c9Q/t/WKBqCLPobSbAHQzy7Bfn8dEsrzfLp/yl3TvWxIsGHC9Z
        t+oRa5rhT+xU1aFSY5tkBBwbzDOwokhX1SDKJI16Xc7XWdHo7UlWy2HALUio/dpa2fPci4
        UZqQhigGx+/BKBvZPeXGeedJ0XzWm74=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-JIIRJTL6OhaMiG9TdqfClA-1; Mon, 15 Feb 2021 16:38:55 -0500
X-MC-Unique: JIIRJTL6OhaMiG9TdqfClA-1
Received: by mail-ed1-f71.google.com with SMTP id m16so6195767edd.21
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 13:38:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IxpTKqSAJdujWUQZD0dx8MvcWVHfhoD9kdfrZZUHBAg=;
        b=r/qfpDIivTt6NvQxOkU0fwXZbpewybWfodzoeHEgHLsDPehSummuKYHN11LHsW/otu
         8x6Yhn+YKvs2n8uMb+03e47dWcjb/d7tpxmsJUShSXSfdJD00xi1qo2V04daHXZRASo6
         6LiKRQuDwfsBekqkjA8aCmVFd46Yvo7fvAi+C/SxEoo/Aw0SSsQmhWIZmZLJg9JJlEj7
         Qnaqzoppg+JLbjtQqlBzcv4jCriKd+8vQs6QegZBfpbgJBg9Tuc/K2w3hRxuXpj0u20m
         737iRmRrKOAUfx5LlvV8vE+ay42+qE+yeKrFTIuoO7h6j15kY3bcrpJ4C//UH8tGCawu
         CKyA==
X-Gm-Message-State: AOAM533ST1ssJs8CGoX0RDu3ZJlh66PapuCN6FUY4ioxxF81Adn1UkH6
        R7WP2QZleIPIFHikZkFoyoQMSWiIrdM6IGzKohlGgyYe8yiFL0zAh9RXE3EieUGZ3vRbfHiECgi
        MN+4hnD5tlmHmDGoD
X-Received: by 2002:a17:906:a2d2:: with SMTP id by18mr16904295ejb.262.1613425134553;
        Mon, 15 Feb 2021 13:38:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJynqSW4LP5F4oENAIG0stNeQBZsPNLQhzZNRr7kHjGfnf95VTpSx5CnFqXU+fRs1OdlW4E9IQ==
X-Received: by 2002:a17:906:a2d2:: with SMTP id by18mr16904277ejb.262.1613425134386;
        Mon, 15 Feb 2021 13:38:54 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id q3sm2956861eja.22.2021.02.15.13.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 13:38:54 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 848BE1805FB; Mon, 15 Feb 2021 22:38:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBl?= =?utf-8?B?bA==?= 
        <bjorn.topel@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
In-Reply-To: <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <87eehhcl9x.fsf@toke.dk> <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
 <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 15 Feb 2021 22:38:52 +0100
Message-ID: <8735xxc8pf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

>> > However, in libxdp we can solve the original problem in a different way,
>> > and in fact I already suggested to Magnus that we should do this (see
>> > [1]); so one way forward could be to address it during the merge in
>> > libxdp? It should be possible to address the original issue (two
>> > instances of xdpsock breaking each other when they exit), but
>> > applications will still need to do an explicit unload operation before
>> > exiting (i.e., the automatic detach on bpf_link fd closure will take
>> > more work, and likely require extending the bpf_link kernel support)...
>> >
>> 
>> I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
>> we're months ahead, then I'd really like to see this in libbpf until the
>> merge. However, I'll leave that for Magnus/you to decide!
>
> Did I miss some thread? What does this mean libbpf 1.0/libxdp merge?

The idea is to keep libbpf focused on bpf, and move the AF_XDP stuff to
libxdp (so the socket stuff in xsk.h). We're adding the existing code
wholesale, and keeping API compatibility during the move, so all that's
needed is adding -lxdp when compiling. And obviously the existing libbpf
code isn't going anywhere until such a time as there's a general
backwards compatibility-breaking deprecation in libbpf (which I believe
Andrii is planning to do in an upcoming and as-of-yet unannounced v1.0
release).

While integrating the XSK code into libxdp we're trying to make it
compatible with the rest of the library (i.e., multi-prog). Hence my
preference to avoid introducing something that makes this harder :)

-Toke

