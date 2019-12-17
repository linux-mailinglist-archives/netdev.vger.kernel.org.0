Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC170122735
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfLQJAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:00:48 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27345 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726760AbfLQJAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 04:00:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576573245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J0PL74ASR1TdXnywuCXPlN+n1fNyedXo5p79c/b1ElQ=;
        b=T+OLpPInwaacyQCGlOXRGON7yanpfcRV5xcqVd+No/3xvysDVWqty0abW32DvuitqIv0DY
        eZC64IQQhU6Etws+L358tqT9XfrzD4X9RvKGRkSyEOJlZKEnXpjgV57sLLEyPPxwmtZf3S
        74K47xZozyewktIFLOWMnOculTgg3TI=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-6png6MpPOVanON1YVhO_rg-1; Tue, 17 Dec 2019 04:00:44 -0500
X-MC-Unique: 6png6MpPOVanON1YVhO_rg-1
Received: by mail-lj1-f199.google.com with SMTP id r14so2995660ljc.18
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 01:00:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=J0PL74ASR1TdXnywuCXPlN+n1fNyedXo5p79c/b1ElQ=;
        b=BvXy3TfBoOJVjzq6gk4MCeIPk8xJnOe0N4lwJpn72zwCiEPZPd1w+8YhGKZ+to4ni4
         5SXkqhwRgQW+0B1Wq100n7HC74+FIueDFZh4y1PN5PV6BvPZxmGi3HKE9BG0bEPqX/2w
         Ql/DWmsmHKyO/JI+asfr6fHf0XUM64+KkjsGk6K/d/LfXzDxYtZj4V4NZ78f9mxxtV5D
         819GSvwxYGwrHI8ZQ4KKhv7+OTMqhNoYPnBmEFPoJY3D1uph3YSE2cros2tPHm0Orb6/
         ZopKIXWr6bS98PNDwi7Jv13w8lVPzAzPSoo4SbS5u29FIpZaEwcTAfOvqLXLkbjZNEh8
         Po8A==
X-Gm-Message-State: APjAAAVXQ4oviZOTkbs4mOTELQsHio+SNQAsVDKzhKoWKd/aBQ0QeXD8
        ljQckinTV/cBKLL06gIjUG+WnAvSqw9Z+0FpBeEhMi8lkhviqk7g+eYk95ucELuyGwRAKzwGvhc
        cYVBukJlKw+eQJ+Q9
X-Received: by 2002:a2e:294e:: with SMTP id u75mr2335193lje.173.1576573243182;
        Tue, 17 Dec 2019 01:00:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqwXHi+d6mqMO+8A8HqhiaF9RRTm5EoAVaaXb3LzaZMsSfOhrZI1YPHNjDuxUBT8LVJ88sIhKg==
X-Received: by 2002:a2e:294e:: with SMTP id u75mr2335164lje.173.1576573242808;
        Tue, 17 Dec 2019 01:00:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u13sm10326716lfq.19.2019.12.17.01.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 01:00:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 09DF11800B3; Tue, 17 Dec 2019 10:00:41 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Luigi Rizzo <rizzo@iet.unipi.it>
Cc:     "Jubran\, Samih" <sameehj@amazon.com>,
        "Machulsky\, Zorik" <zorik@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Tzalik\, Guy" <gtzalik@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Kiyanovski\, Arthur" <akiyano@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, brouer@redhat.com
Subject: Re: XDP multi-buffer design discussion
In-Reply-To: <20191217094635.7e4cac1c@carbon>
References: <BA8DC06A-C508-402D-8A18-B715FBA674A2@amazon.com> <b28504a3-4a55-d302-91fe-63915e4568d3@iogearbox.net> <5FA3F980-29E6-4B91-8150-9F28C0E09C45@amazon.com> <20190823084704.075aeebd@carbon> <67C7F66A-A3F7-408F-9C9E-C53982BCCD40@amazon.com> <20191204155509.6b517f75@carbon> <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com> <20191216150728.38c50822@carbon> <CA+hQ2+jp471vBvRna7ugdYyFgEB63a9tgCXZCOjEQkT+tZTM1g@mail.gmail.com> <20191217094635.7e4cac1c@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 17 Dec 2019 10:00:41 +0100
Message-ID: <87eex38gxy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Mon, 16 Dec 2019 20:15:12 -0800
> Luigi Rizzo <rizzo@iet.unipi.it> wrote:
>
>> On Mon, Dec 16, 2019 at 6:07 AM Jesper Dangaard Brouer
>> <brouer@redhat.com> wrote:
>> >
>> >
>> > See answers inlined below (please get an email client that support
>> > inline replies... to interact with this community)
>> >
>> > On Sun, 15 Dec 2019 13:57:12 +0000
>> > "Jubran, Samih" <sameehj@amazon.com> wrote:  
>> ...
>> > > * Why should we provide the fragments to the bpf program if the
>> > > program doesn't access them? If validating the length is what
>> > > matters, we can provide only the full length info to the user with no
>> > > issues.  
>> >
>> > My Proposal#1 (in [base-doc]) is that XDP only get access to the
>> > first-buffer.  People are welcome to challenge this choice.
>> >
>> > There are a several sub-questions and challenges hidden inside this
>> > choice.
>> >
>> > As you hint, the total length... spawns some questions we should answer:
>> >
>> >  (1) is it relevant to the BPF program to know this, explain the use-case.
>> >
>> >  (2) if so, how does BPF prog access info (without slowdown baseline)  
>> 
>> For some use cases, the bpf program could deduct the total length
>> looking at the L3 header. 
>
> Yes, that actually good insight.  I guess the BPF-program could also
> use this to detect that it doesn't have access to the full-lineary
> packet this way(?)
>
>> It won't work for XDP_TX response though.
>
> The XDP_TX case also need to be discussed/handled. IMHO need to support
> XDP_TX for multi-buffer frames.  XDP_TX *can* be driver specific, but
> most drivers choose to convert xdp_buff to xdp_frame, which makes it
> possible to use/share part of the XDP_REDIRECT code from ndo_xdp_xmit.
>
> We also need to handle XDP_REDIRECT, which becomes challenging, as the
> ndo_xdp_xmit functions of *all* drivers need to be updated (or
> introduce a flag to handle this incrementally).

If we want to handle TX and REDIRECT (which I agree we do!), doesn't
that imply that we have to structure the drivers so the XDP program
isn't executed until we have the full packet (i.e., on the last
segment)?

-Toke

