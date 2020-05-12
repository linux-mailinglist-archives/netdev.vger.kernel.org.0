Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6E41CEF37
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 10:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729116AbgELIfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 04:35:05 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45269 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725987AbgELIfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 04:35:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589272503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jcu7UayeiRoB+oPtxu5ro8xy76Yt5bLrrV9cfwYT0u4=;
        b=iJrsU4RpBOeI2JZmrs4gjEXDAw70a2sALlrFj6ODkZcIZf4xJsw1gbMamfgircUFcWQSPa
        5gBQUVEJHltE4NeJzJLMxXjg8SWozTG3kY5BUHaOZ2Qqy7M8FKzmvqpUT0R9K/fLkcg2RC
        wH8xk004Ln9Y4Wyqnz/dODXZfNMzOFg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-U-TncXLOMIqPoJonkjvbEg-1; Tue, 12 May 2020 04:35:02 -0400
X-MC-Unique: U-TncXLOMIqPoJonkjvbEg-1
Received: by mail-lj1-f198.google.com with SMTP id l5so1223022lje.23
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 01:35:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Jcu7UayeiRoB+oPtxu5ro8xy76Yt5bLrrV9cfwYT0u4=;
        b=UNwgV3sQVSwtnkKI2dhkCD40rskMyb5Ti5TL+bo60wvm65W5ixSiWKfSJqJJnoXOwz
         JRprOWa8njUP3maLoKtJWETykE3a10vTn07wpzFFsePmp+HMXmsfabd17KkFs9laA+So
         9t/14CbvFY8Or+CjMEcwKZZlRCMAFY138DkPy8oXSMdoP7V+uxTisu0usHHWT1BzsuhV
         ay3ljssQ51YFXHI5fPdvsFVtrPtZbSNlfJjoLy10bkYTHOVMvgISwr9kLi6dsZftubUh
         mLUy0vOC7OnwATWi2+2va+gdNrk+pft+tDWLDKZXFQMJT+6W13qsYkCoRBZ9WuhtziYS
         7n7A==
X-Gm-Message-State: AOAM531Nng6bn8O4DvmeyMqBOyjmwRro3gdF4Us2+STCqkYpbYPnJb95
        McUrsyzLIqnpPe+a+gSiJoIpwurlCIIEWZxi3jsBhnMg/VEOEgEWmqVMuxoBoMXjPdphdvyqfLJ
        jH3DoKCP+ijKaVQ6c
X-Received: by 2002:a2e:986:: with SMTP id 128mr9515209ljj.202.1589272500503;
        Tue, 12 May 2020 01:35:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFmvdz9SAXFfdnegZZctpbgnZj5hHOIAXiFoVO8Ry9W+nleEprJxW5rdu/858LPlqtM/tnwQ==
X-Received: by 2002:a2e:986:: with SMTP id 128mr9515196ljj.202.1589272500266;
        Tue, 12 May 2020 01:35:00 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id y9sm12081878ljy.31.2020.05.12.01.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 01:34:59 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BF311181509; Tue, 12 May 2020 10:34:58 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: bpf: ability to attach freplace to multiple parents
In-Reply-To: <20200402215452.dkkbbymnhzlcux7m@ast-mbp>
References: <CAEf4BzY+JsmxCfjMVizLWYU05VS6DiwKE=e564Egu1jMba6fXQ@mail.gmail.com> <87tv2e10ly.fsf@toke.dk> <CAEf4BzY1bs5WRsvr5UbfqV9UKnwxmCUa9NQ6FWirT2uREaj7_g@mail.gmail.com> <87369wrcyv.fsf@toke.dk> <CAEf4BzZKvuPz8NZODYnn4DOcjPnj5caVeOHTP9_D3=wL0nVFfw@mail.gmail.com> <CACAyw9-FrwgBGjGT1CYrKJuyRJtwn0XUsifF_uR6LpRbcucN+A@mail.gmail.com> <20200326195340.dznktutm6yq763af@ast-mbp> <87o8sim4rw.fsf@toke.dk> <20200402202156.hq7wpz5vdoajpqp5@ast-mbp> <87o8s9eg5b.fsf@toke.dk> <20200402215452.dkkbbymnhzlcux7m@ast-mbp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 12 May 2020 10:34:58 +0200
Message-ID: <87h7wlwnyl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

>> > Currently fentry/fexit/freplace progs have single prog->aux->linked_prog pointer.
>> > It just needs to become a linked list.
>> > The api extension could be like this:
>> > bpf_raw_tp_open(prog_fd, attach_prog_fd, attach_btf_id);
>> > (currently it's just bpf_raw_tp_open(prog_fd))
>> > The same pair of (attach_prog_fd, attach_btf_id) is already passed into prog_load
>> > to hold the linked_prog and its corresponding btf_id.
>> > I'm proposing to extend raw_tp_open with this pair as well to
>> > attach existing fentry/fexit/freplace prog to another target.
>> > Internally the kernel verify that btf of current linked_prog
>> > exactly matches to btf of another requested linked_prog and
>> > if they match it will attach the same prog to two target programs (in case of freplace)
>> > or two kernel functions (in case of fentry/fexit).
>> 
>> API-wise this was exactly what I had in mind as well.
>
> perfect!

Hi Alexei

I don't suppose you've had a chance to whip up a patch for this, have
you? :)

-Toke

