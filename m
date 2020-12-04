Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F55B2CF30F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgLDRW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:22:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726539AbgLDRW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:22:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607102462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U5IeZavI1slGOCHWtn0MYw9qDh47KRQr0SDzs5KB7WA=;
        b=FXCexHdcy3kCX/Ul5cRk4UQzV77xEQHABtSROuqgNbzTu4U2DYfBpfLh0mRkEJz2chEw0E
        2kOCyOvnVvhCNEMRhMQXeKn3KA1yCxWVo7JuR1QglslsgUXI74QW4d7JJaVZOqItF93LMu
        Ny0IJ/HuPmYh1hrbJ4pRMausXlGvYxg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-krTz-vi5PECQXxUlv__gUQ-1; Fri, 04 Dec 2020 12:21:00 -0500
X-MC-Unique: krTz-vi5PECQXxUlv__gUQ-1
Received: by mail-ej1-f69.google.com with SMTP id f12so2314845ejk.2
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 09:21:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=U5IeZavI1slGOCHWtn0MYw9qDh47KRQr0SDzs5KB7WA=;
        b=TKHNuSPO0jJrrEYrDG9eWl4QEXvHEPhZ2VHf447lCTgw3XpyiJsdbRsE9NFN+d5Ety
         IkK5+Re1FAWKZpj5lbQ1oYuNnzFQYqCsCAnjJQjr+epd6aWF/WgdzGO7F1UvMOhsVVGv
         iDD7VtE6y3/oyuTVZGtAFC0yzo/4g7K4+2tqCUNDJEaq7vDDzpcqkgvxFaqECuwKEtmq
         PYFnukpbMC9IDGrUxB93yGo0z/6HMHxq9uIyljz4Ctge6Dxm0l7hqDDfy6bA5DVHKbb7
         qZkWE/s1kJIC1nNBw8uPtj3mXuuLEdYm+Zq24XmuxK1QYhXALVAolnai7+HYNgruGZgh
         D0TQ==
X-Gm-Message-State: AOAM531iLbUB2XsHqRcJ4D3hi84urn2Xh5UxYw31AVWMxy5Xcag4fbl2
        AhG1cqUNvGFaJEfYsLfawTf0Qm3j3ekLCWeMgwOWYgj0dwbfgsd98Mg5uhe6O9syT0J2ejd+Tun
        j4/Y5KxVX5zLqDrTe
X-Received: by 2002:a17:906:6d0b:: with SMTP id m11mr7928006ejr.230.1607102459202;
        Fri, 04 Dec 2020 09:20:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhS7VA5Rc4xxMfbG2ag4DHR9oX3MJU8gZ42OYogNWOs5tsZLXm5ObLXgr0/bSOvze7SxxwxA==
X-Received: by 2002:a17:906:6d0b:: with SMTP id m11mr7927999ejr.230.1607102458975;
        Fri, 04 Dec 2020 09:20:58 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j22sm3112770ejy.106.2020.12.04.09.20.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 09:20:58 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E20DC182EEA; Fri,  4 Dec 2020 18:20:56 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, hawk@kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
In-Reply-To: <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk> <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 04 Dec 2020 18:20:56 +0100
Message-ID: <87pn3p7aiv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 12/4/20 1:46 PM, Maciej Fijalkowski wrote:
>> On Fri, Dec 04, 2020 at 01:18:31PM +0100, Toke H=C3=B8iland-J=C3=B8rgens=
en wrote:
>>> alardam@gmail.com writes:
>>>> From: Marek Majtyka <marekx.majtyka@intel.com>
>>>>
>>>> Implement support for checking what kind of xdp functionality a netdev
>>>> supports. Previously, there was no way to do this other than to try
>>>> to create an AF_XDP socket on the interface or load an XDP program and=
 see
>>>> if it worked. This commit changes this by adding a new variable which
>>>> describes all xdp supported functions on pretty detailed level:
>>>
>>> I like the direction this is going! :)
>>>
>>>>   - aborted
>>>>   - drop
>>>>   - pass
>>>>   - tx
>
> I strongly think we should _not_ merge any native XDP driver patchset
> that does not support/implement the above return codes. Could we
> instead group them together and call this something like XDP_BASE
> functionality to not give a wrong impression? If this is properly
> documented that these are basic must-have _requirements_, then users
> and driver developers both know what the expectations are.

I think there may have been drivers that only did DROP/PASS on first
merge; but adding TX to the "base set" is fine by me, as long as it's
actually enforced ;)

(As in, we originally said the same thing about the full feature set and
that never really worked out).

>>>>   - redirect
>>>
>>> Drivers can in principle implement support for the XDP_REDIRECT return
>>> code (and calling xdp_do_redirect()) without implementing ndo_xdp_xmit()
>>> for being the *target* of a redirect. While my quick grepping doesn't
>>> turn up any drivers that do only one of these right now, I think we've
>>> had examples of it in the past, so it would probably be better to split
>>> the redirect feature flag in two.
>>>
>>> This would also make it trivial to replace the check in __xdp_enqueue()
>>> (in devmap.c) from looking at whether the ndo is defined, and just
>>> checking the flag. It would be great if you could do this as part of
>>> this series.
>>>
>>> Maybe we could even make the 'redirect target' flag be set automatically
>>> if a driver implements ndo_xdp_xmit?
>>=20
>> +1
>>=20
>>>>   - zero copy
>>>>   - hardware offload.
>
> One other thing that is quite annoying to figure out sometimes and not al=
ways
> obvious from reading the driver code (and it may even differ depending on=
 how
> the driver was built :/) is how much XDP headroom a driver really provide=
s.
>
> We tried to standardize on a minimum guaranteed amount, but unfortunately=
 not
> everyone seems to implement it, but I think it would be very useful to qu=
ery
> this from application side, for example, consider that an app inserts a B=
PF
> prog at XDP doing custom encap shortly before XDP_TX so it would be usefu=
l to
> know which of the different encaps it implements are realistically possib=
le on
> the underlying XDP supported dev.

How many distinct values are there in reality? Enough to express this in
a few flags (XDP_HEADROOM_128, XDP_HEADROOM_192, etc?), or does it need
an additional field to get the exact value? If we implement the latter
we also run the risk of people actually implementing all sorts of weird
values, whereas if we constrain it to a few distinct values it's easier
to push back against adding new values (as it'll be obvious from the
addition of new flags).

-Toke

