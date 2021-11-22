Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4649459055
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236971AbhKVOl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:41:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235099AbhKVOlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 09:41:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637591898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QRmIAGPqwXnlRks2d1cwbTHEDrQ1Q+ulK/8aQg4dlNs=;
        b=XCJ0zXNMvCQgGpk/bgUc0bF1FdvkQfcaFHhmU2yfKHVtXdsxCOREwUHXdXMptny4wNeBnO
        Tb0Gs3P2xI0o0NYnUe4zbiZ6jewFnyxFyp2Sr2TO6z0b+T1WXhJ98EjkR8OIFBOg7nqaC5
        aByE6W6RK6NV4xCbWK3f1Bs629/vkpI=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-iwhgsYmaPSCXl5H5wA6eLw-1; Mon, 22 Nov 2021 09:38:17 -0500
X-MC-Unique: iwhgsYmaPSCXl5H5wA6eLw-1
Received: by mail-ed1-f69.google.com with SMTP id w18-20020a056402071200b003e61cbafdb4so14986969edx.4
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 06:38:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QRmIAGPqwXnlRks2d1cwbTHEDrQ1Q+ulK/8aQg4dlNs=;
        b=YDiNS5EwnQfwSUWQ02EQDB92WnuUEPvgfo9toAjZCW1I21EYkIG3qMGzGy/58NrnNQ
         tI0/quOATcX+jngeQ99++b37vQjuqaVXSAE9GcoW7J6Pp0ZHaA0K9AUNYyIR5GQ5FmQN
         5ESqyuLPqgd9XaGZ8IMikos5mWJrPIMvijcCHINievolYcl/eX31rlVUfcNj+fGTsItj
         VJ03e31CLDOdTNloL6xbeqeSStIHetf0HpAxk+GxzjIRxOEjPPQxQSHzTOWwNYDsopd8
         OfYNCf5JsrGddhDqLnKeZeZLMCL/e1jEU9iXjZGjLKDzuCbW7fAEo5z1FWWcDqNJh76Y
         XyKw==
X-Gm-Message-State: AOAM5324fneN2uTkHE9Iyke67abouZkLBU+ET+fc4LSG1JZZI7WM6gWn
        X1eNeofYAmzIJ6XVZp1o1RKsA569wJxb/NnQAuSbx9awDimIK22hXfZ3prQAaM8YBd/vXU7cV3F
        9DZpHOqHY/tx7jI2s
X-Received: by 2002:a05:6402:849:: with SMTP id b9mr33971793edz.371.1637591895756;
        Mon, 22 Nov 2021 06:38:15 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx5mfOko3YHpF1iUTnlUbefbUEAWQuN71vmGW587xwaHHCSvDd0W0UGjkOJB3hp6R/+JcQeGw==
X-Received: by 2002:a05:6402:849:: with SMTP id b9mr33971728edz.371.1637591895385;
        Mon, 22 Nov 2021 06:38:15 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id sc7sm4096953ejc.50.2021.11.22.06.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 06:38:14 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DD90F180270; Mon, 22 Nov 2021 15:38:13 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Loftus, Ciara" <ciara.loftus@intel.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Cc:     "brouer@redhat.com" <brouer@redhat.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Subject: RE: [RFC PATCH bpf-next 0/8] XDP_REDIRECT_XSK and Batched AF_XDP Rx
In-Reply-To: <PH0PR11MB4791ABCE7F631A4BBEAF1B5E8E9C9@PH0PR11MB4791.namprd11.prod.outlook.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
 <5a121fc4-fb6c-c70b-d674-9bf13c325b64@redhat.com>
 <PH0PR11MB4791D63AFE9595CAA9A6EC378E999@PH0PR11MB4791.namprd11.prod.outlook.com>
 <87mtm2g8r9.fsf@toke.dk>
 <PH0PR11MB4791ABCE7F631A4BBEAF1B5E8E9C9@PH0PR11MB4791.namprd11.prod.outlook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 22 Nov 2021 15:38:13 +0100
Message-ID: <87ilwkcl2i.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Loftus, Ciara" <ciara.loftus@intel.com> writes:

>> "Loftus, Ciara" <ciara.loftus@intel.com> writes:
>> 
>> >> I'm fine with adding a new helper, but I don't like introducing a new
>> >> XDP_REDIRECT_XSK action, which requires updating ALL the drivers.
>> >>
>> >> With XDP_REDIRECT infra we beleived we didn't need to add more
>> >> XDP-action code to drivers, as we multiplex/add new features by
>> >> extending the bpf_redirect_info.
>> >> In this extreme performance case, it seems the this_cpu_ptr "lookup" of
>> >> bpf_redirect_info is the performance issue itself.
>> >>
>> >> Could you experiement with different approaches that modify
>> >> xdp_do_redirect() to handle if new helper bpf_redirect_xsk was called,
>> >> prior to this_cpu_ptr() call.
>> >> (Thus, avoiding to introduce a new XDP-action).
>> >
>> > Thanks for your feedback Jesper.
>> > I understand the hesitation of adding a new action. If we can achieve the
>> same improvement without
>> > introducing a new action I would be very happy!
>> > Without new the action we'll need a new way to indicate that the
>> bpf_redirect_xsk helper was
>> > called. Maybe another new field in the netdev alongside the xsk_refcnt. Or
>> else extend
>> > bpf_redirect_info - if we find a new home for it that it's too costly to
>> access.
>> > Thanks for your suggestions. I'll experiment as you suggested and
>> > report back.
>> 
>> I'll add a +1 to the "let's try to solve this without a new return code" :)
>> 
>> Also, I don't think we need a new helper either; the bpf_redirect()
>> helper takes a flags argument, so we could just use ifindex=0,
>> flags=DEV_XSK or something like that.
>
> The advantage of a new helper is that we can access the netdev 
> struct from it and check if there's a valid xsk stored in it, before
> returning XDP_REDIRECT without the xskmap lookup. However,
> I think your suggestion could work too. We would just
> have to delay the check until xdp_do_redirect. At this point
> though, if there isn't a valid xsk we might have to drop the packet
> instead of falling back to the xskmap.

I think it's OK to require the user to make sure that there is such a
socket loaded before using that flag...

>> Also, I think the batching in the driver idea can be generalised: we
>> just need to generalise the idea of "are all these packets going to the
>> same place" and have a batched version of xdp_do_redirect(), no? The
>> other map types do batching internally already, though, so I'm wondering
>> why batching in the driver helps XSK?
>> 
>
> With the current infrastructure figuring out if "all the packets are going
> to the same place" looks like an expensive operation which could undo
> the benefits of the batching that would come after it. We would need
> to run the program N=batch_size times, store the actions and
> bpf_redirect_info for each run and perform a series of compares. The new
> action really helped here because it could easily indicate if all the
> packets in a batch were going to the same place. But I understand it's
> not an option. Maybe if we can mitigate the cost of accessing the
> bpf_redirect_info as Jesper suggested, we can use a flag in it to signal
> what the new action was signalling.

Yes, it would probably require comparing the contents of the whole
bpf_redirect_info, at least as it is now; but assuming we can find a way
to mitigate the cost of accessing that structure, this may not be so
bad, and I believe there is some potential for compressing the state
further so we can get down to a single, or maybe two, 64-bit compares...

-Toke

