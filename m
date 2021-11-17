Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE264548A6
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 15:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbhKQO1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 09:27:48 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34201 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235576AbhKQO1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 09:27:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637159087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JNxhMMv9WLzFtOM8A/ouPZ+Y/FyHktyeirSpwevwErI=;
        b=MoQNQIDbi85F3NRTtc/FRXBjbb0K8dWxklVyxuUL/j7wBo9sUyBor0Ve+xMgV+JSO40ZiF
        VGLX/xiOoN2j1nwBTAStCqeKQPjJZ10oJqTblgJDsBF1iD1mHUOMFxE8rcSPdR1/uvSOgI
        cM7aM7J/aqktlO6mIkiKRPjnAiC3mis=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-MGLs1oapNLCTVy52uEzLow-1; Wed, 17 Nov 2021 09:24:46 -0500
X-MC-Unique: MGLs1oapNLCTVy52uEzLow-1
Received: by mail-ed1-f69.google.com with SMTP id w18-20020a056402071200b003e61cbafdb4so2287377edx.4
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 06:24:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JNxhMMv9WLzFtOM8A/ouPZ+Y/FyHktyeirSpwevwErI=;
        b=43scgsXiq+SMBo9DIwtH+vhGoIXcgdD5Lwu5uunD1FRweZQ8NLvH+0llzXT1Zjp/Lt
         X/A7KRe3jzisqeQb7CVgsOV3r2AqUhA93JMlOxcnHx+BXkhRdC/xrEjB/GJscb1y3hZC
         1SCNOb1SQPviTRxG1KOTUfcOHxvUEgp0CSAOw/8lq4A8sbsxdHgakWyYYcL33iY05Wkq
         tFBf9MwILFIvzsV2fM7kHH2H21AXQLeJrzq4Xr72EYjgMrBw7RSkCw0iZZl/ba96f10B
         MsaJveyyBMvSTOpXdipAQlFoBdEeNQsXuU50UWvV8gjFAnyhACzgpIbPxOiKRdnlti3J
         CCxw==
X-Gm-Message-State: AOAM5309vEQIz2H5QqZbMHVxsfoCJlvueVcXs/RCtY8mMdVvW5hxyl9f
        QZCDezaPxLZ2/3n5uPEKSLFoB6c4yK0U7uR/BIQ+Sc0FBJCev0aq2t5Gd/Bsw4lr9+AITIEW+Ue
        GezxBwJP8Z3Ft4W/n
X-Received: by 2002:a17:907:1629:: with SMTP id hb41mr23732209ejc.328.1637159084804;
        Wed, 17 Nov 2021 06:24:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz6gSJ7bm8Z2mReanGuBMHxV3iNTM/dgEKPcIrf4ynzMyjPQFARy2J4oW9tzoxfa/53NTuTtw==
X-Received: by 2002:a17:907:1629:: with SMTP id hb41mr23732133ejc.328.1637159084381;
        Wed, 17 Nov 2021 06:24:44 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w3sm11174801edj.63.2021.11.17.06.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 06:24:43 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E9129180270; Wed, 17 Nov 2021 15:24:42 +0100 (CET)
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
In-Reply-To: <PH0PR11MB4791D63AFE9595CAA9A6EC378E999@PH0PR11MB4791.namprd11.prod.outlook.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
 <5a121fc4-fb6c-c70b-d674-9bf13c325b64@redhat.com>
 <PH0PR11MB4791D63AFE9595CAA9A6EC378E999@PH0PR11MB4791.namprd11.prod.outlook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 17 Nov 2021 15:24:42 +0100
Message-ID: <87mtm2g8r9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Loftus, Ciara" <ciara.loftus@intel.com> writes:

>> I'm fine with adding a new helper, but I don't like introducing a new
>> XDP_REDIRECT_XSK action, which requires updating ALL the drivers.
>> 
>> With XDP_REDIRECT infra we beleived we didn't need to add more
>> XDP-action code to drivers, as we multiplex/add new features by
>> extending the bpf_redirect_info.
>> In this extreme performance case, it seems the this_cpu_ptr "lookup" of
>> bpf_redirect_info is the performance issue itself.
>> 
>> Could you experiement with different approaches that modify
>> xdp_do_redirect() to handle if new helper bpf_redirect_xsk was called,
>> prior to this_cpu_ptr() call.
>> (Thus, avoiding to introduce a new XDP-action).
>
> Thanks for your feedback Jesper.
> I understand the hesitation of adding a new action. If we can achieve the same improvement without
> introducing a new action I would be very happy!
> Without new the action we'll need a new way to indicate that the bpf_redirect_xsk helper was
> called. Maybe another new field in the netdev alongside the xsk_refcnt. Or else extend
> bpf_redirect_info - if we find a new home for it that it's too costly to access.
> Thanks for your suggestions. I'll experiment as you suggested and
> report back.

I'll add a +1 to the "let's try to solve this without a new return code" :)

Also, I don't think we need a new helper either; the bpf_redirect()
helper takes a flags argument, so we could just use ifindex=0,
flags=DEV_XSK or something like that.

Also, I think the batching in the driver idea can be generalised: we
just need to generalise the idea of "are all these packets going to the
same place" and have a batched version of xdp_do_redirect(), no? The
other map types do batching internally already, though, so I'm wondering
why batching in the driver helps XSK?

-Toke

