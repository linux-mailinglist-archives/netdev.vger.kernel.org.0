Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922821371F0
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 16:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgAJP5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 10:57:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:47331 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728363AbgAJP5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 10:57:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578671828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/RcvD6FKueQJNLgQiUovViahlrs5OaZtZ56HWTd/Suk=;
        b=gIMEqcL6M4uCvjHPMRGmwOktZMmL4APdco6O+bonx3BSFYkUvsfbQXM5czBux75DLVYK/6
        xTfmvM8GTbK2Ur0roIDX4o1UQ9Mf8OzeUuSGX7XW3NL8hsqp6JX8PU5nDivzj2oiwVUOyZ
        lUw/qxrlBQBfhVQSd2gyQ52ssjl4Tt4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-j1BJhNxYNNiIN3GmXhqukg-1; Fri, 10 Jan 2020 10:57:05 -0500
X-MC-Unique: j1BJhNxYNNiIN3GmXhqukg-1
Received: by mail-wr1-f70.google.com with SMTP id y7so1125671wrm.3
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 07:57:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/RcvD6FKueQJNLgQiUovViahlrs5OaZtZ56HWTd/Suk=;
        b=WMT64LDXJLwVdRfv4BuSQ2YIWnbJ1P234FmMPalv38JrCM64SwTlhYdA3IrGy6wheR
         dww1ORAB7Rh9W3jpAcG6QJJuWjWnFvoGHY5IO0GQUTvdKLgQLtY3Irl4f7Rts9OKOB0d
         AAxHhFmLvtaxnUx1Rw9Umw/+3SET9fvSoaidaFHchv4e90Fn0dRsk706iRbkPD8psfcW
         K9H7I62GDU8y2uO/DD2d3uzpqu6ajrDQITvl9EYspLmt9M8voX2xNntVj5ytHKHoyJPN
         ctDjr+WMIVGrSDl7Ukn/XJ07WhWPDgO6cIWMJPkyr/CILT1bxil4rmuQsic+QE/3eZhE
         TfTg==
X-Gm-Message-State: APjAAAXMfZwP5l16NyAJz1Rqkey5PcFtJZtbvgdkI/CWj0W9cETTlzHi
        hlm6h4oiBXf4lMNZk2jPDOq1nvtLF5/hmNuv+YKEQeqFrVks8TcGCx9A6BiHMlZFxqfb5zz6+6k
        wNygBoJqD9xWukDwZ
X-Received: by 2002:a1c:23d7:: with SMTP id j206mr4956207wmj.39.1578671824005;
        Fri, 10 Jan 2020 07:57:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqx6aX2tXH6n7HTBJHu9Ug+SiHHxXpcs6670AwkCZsHo0YFHEgeopo2vvyYbmh/lPCoQIXjMqA==
X-Received: by 2002:a1c:23d7:: with SMTP id j206mr4956195wmj.39.1578671823852;
        Fri, 10 Jan 2020 07:57:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id i11sm2694838wrs.10.2020.01.10.07.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 07:57:03 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 944EE18009F; Fri, 10 Jan 2020 16:57:02 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next 2/2] xdp: Use bulking for non-map XDP_REDIRECT
In-Reply-To: <CAJ+HfNhO9Mn-hzysEfri3hAH29HXiBWDZE1XUVhOj1UFbBrp4w@mail.gmail.com>
References: <157866612174.432695.5077671447287539053.stgit@toke.dk> <157866612392.432695.249078779633883278.stgit@toke.dk> <CAJ+HfNhM8SQK6dem9vhvAh68AqaxouSDhhWjXiidB3=LBRmsUA@mail.gmail.com> <87d0brxr9u.fsf@toke.dk> <CAJ+HfNhO9Mn-hzysEfri3hAH29HXiBWDZE1XUVhOj1UFbBrp4w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 10 Jan 2020 16:57:02 +0100
Message-ID: <87a76vxq29.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Fri, 10 Jan 2020 at 16:30, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>>
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>
> [...]
>> >
>> > After these changes, does the noinline (commit 47b123ed9e99 ("xdp:
>> > split code for map vs non-map redirect")) still make sense?
>>
>> Hmm, good question. The two code paths are certainly close to one
>> another; and I guess they could be consolidated further.
>>
>> The best case would be if we had a way to lookup the ifindex directly in
>> the helper. Do you know if there's a way to get the current net
>> namespace from the helper? Can we use current->nsproxy->net_ns in that
>> context?
>>
>
> Nope, interrupt context. :-( Another (ugly) way is adding a netns
> member to the bpf_redirect_info, that is populated by the driver
> (driver changes everywhere -- ick). So no.

Yup, that's what I thought. OK, too bad; I'll see what other
consolidation I can do with the current code, then.

> (And *if* one would go the route of changing all drivers, I think the
> percpu bpf_redirect_info should be replaced a by a context that is
> passed from the driver to the XDP program execution and
> xdp_do_redirect/flush. But that's a much bigger patch. :-))

Yeah, let's leave that until the next time we figure out we have to
change all the drivers, then ;)

-Toke

