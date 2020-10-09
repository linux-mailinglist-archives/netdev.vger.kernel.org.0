Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3873928914E
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 20:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbgJISmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 14:42:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35338 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727560AbgJISmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 14:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602268938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j/QOCkmnSN60NLNZzGXIUnDSHiaUJlDv+sgUSKbTTlc=;
        b=Q4iUp5+n97rE4TxAerrX5PJ15aLgrVgSD0C81N0RcgB7fNNnk+KCP8cM4uynyKc9KrvP3Y
        INWgHittMDTWlGQZAFBY09dv9kreId+UaYgJLmYyTya0bO+takqCVexyL4DTd8T/eI68Xe
        S1AzXdxMUuwZ+vs0TJj+Pk0AY+E12bg=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-od-7rRVmMny0EVFM4J08Uw-1; Fri, 09 Oct 2020 14:42:15 -0400
X-MC-Unique: od-7rRVmMny0EVFM4J08Uw-1
Received: by mail-vs1-f70.google.com with SMTP id d190so1486666vsc.15
        for <netdev@vger.kernel.org>; Fri, 09 Oct 2020 11:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=j/QOCkmnSN60NLNZzGXIUnDSHiaUJlDv+sgUSKbTTlc=;
        b=H2XiQAP7AJjCifB/qj9TQV/M+wo9QL+/GX8RG1ORTqhjkk+RXZx1zuIPW/Ut/QSHoU
         vEh9sUIJ8ELLOxjKC0Setn9UhJ8clFkn7pNzWNXPHKbUt28i9t+kXE0fWKv9TVEm3o/N
         hCKrb33BsVFGmoapx6nqaRIa5GWWCfV4clly9RDnxntBbjjKNgU9V3hKdhShzv5CsAB4
         oCkOTM8o3ItlE5QMhilQXaN7n9hAdUZ5rXFgQwtmNJTvaEGgpDe+Y6x8bToMIqSpxD6g
         8U0gkl21vEkevFBTnfX38S5n2hUJ34V2+VhN1t6j5n2nwmvRGJ6jFInzp2XGeInUzR+l
         z+2A==
X-Gm-Message-State: AOAM532Me1xPD5uV/F96SkdKxmwRjiFIsS0t3zUBZSWiaBgoofUqPFs/
        lsu72yj0IK9m9Mpp44aL+l2v7y6LeYDGOKKpQQWtJMZeHdwxhH2PIvAqdZSoKAGI2zKN/p7SO/h
        bXKfgWkGK9iRawC8X
X-Received: by 2002:a05:6102:9cd:: with SMTP id g13mr9279750vsi.44.1602268934925;
        Fri, 09 Oct 2020 11:42:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtDbskbMOrPHyCRlSH7KdeoQmVqkFNAKTzB/kCt5yfOLg+3nT+pjvny3KKWiLKl4R4yiSxqQ==
X-Received: by 2002:a05:6102:9cd:: with SMTP id g13mr9279735vsi.44.1602268934599;
        Fri, 09 Oct 2020 11:42:14 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a195sm1264285vka.42.2020.10.09.11.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 11:42:13 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id ADCF01837DC; Fri,  9 Oct 2020 20:42:10 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, daniel@iogearbox.net, ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH bpf-next v2] bpf_fib_lookup: optionally skip neighbour
 lookup
In-Reply-To: <0a463800-a663-3fd3-2e1a-eac5526ed691@gmail.com>
References: <20201009101356.129228-1-toke@redhat.com>
 <0a463800-a663-3fd3-2e1a-eac5526ed691@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Oct 2020 20:42:10 +0200
Message-ID: <87v9fjckcd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 10/9/20 3:13 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> The bpf_fib_lookup() helper performs a neighbour lookup for the destinat=
ion
>> IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
>> that the BPF program will pass the packet up the stack in this case.
>> However, with the addition of bpf_redirect_neigh() that can be used inst=
ead
>> to perform the neighbour lookup, at the cost of a bit of duplicated work.
>>=20
>> For that we still need the target ifindex, and since bpf_fib_lookup()
>> already has that at the time it performs the neighbour lookup, there is
>> really no reason why it can't just return it in any case. So let's just
>> always return the ifindex, and also add a flag that lets the caller turn
>> off the neighbour lookup entirely in bpf_fib_lookup().
>
> seems really odd to do the fib lookup only to skip the neighbor lookup
> and defer to a second helper to do a second fib lookup and send out.
>
> The better back-to-back calls is to return the ifindex and gateway on
> successful fib lookup regardless of valid neighbor. If the call to
> bpf_redirect_neigh is needed, it can have a flag to skip the fib lookup
> and just redirect to the given nexthop address + ifindex. ie.,
> bpf_redirect_neigh only does neighbor handling in this case.

Hmm, yeah, I guess it would make sense to cache and reuse the lookup -
maybe stick it in bpf_redirect_info()? However, given the imminent
opening of the merge window, I don't see this landing before then. So
I'm going to respin this patch with just the original change to always
return the ifindex, then we can revisit the flags/reuse of the fib
lookup later.

-Toke

