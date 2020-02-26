Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C2F17059A
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgBZRIp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:08:45 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60913 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727635AbgBZRIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:08:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582736924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VIlcMhLq/QXZA/mTiSqGbuzjnWYKeRUaR0PLX/PhEUY=;
        b=NnmMHaaL/MzpIfSk19z50mG7zK9zgXRvZ7+sLVPMny3rNQw4+Okbzq/mFfpWzS0X/l9Ckn
        PcLARYKaiT0uQV32Merh290RyAEuyWfo8uXyR4/8kctMZ+pZkRW9DwuHYlsVoFxL4uGndE
        t/r4bVKY4AR7T2Wd33UWuHh/yzKC7CE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-wM1xYFenM3qIpbB8IOScpA-1; Wed, 26 Feb 2020 12:08:36 -0500
X-MC-Unique: wM1xYFenM3qIpbB8IOScpA-1
Received: by mail-qt1-f199.google.com with SMTP id f25so4712867qtp.12
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:08:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=VIlcMhLq/QXZA/mTiSqGbuzjnWYKeRUaR0PLX/PhEUY=;
        b=OPbcKrgG+FJTePASZmEAtqF5Cmy2bOtrbZSbhs876Uuyc3m9WTbipjzfLgC+CLURuj
         eeXYPWBe23ZXy8nlv8o7Syx6R8D9SeykDXJrvONVLwB1bO8YZKd1a+u6l074L4ezQnQ9
         YQF1u3SCoZj1UlNi2p2eyP/1aOH0uxVQDIhK88N4d6fGgXVv3TsEPXiW+rsLB5JaZ8IE
         UUld0ffz/ix4v/OB9yL3HKpF4hiSd7aDQyiCSgwaUHiCP/Egx5lFHzSawYc1trP4g45r
         GtrJbSTebdDLq6lvBhdbSQbvFE8CUNIPpA8qjwhOoa/cBGUzsjV9i9WOt1Vcbshm45lm
         gbOw==
X-Gm-Message-State: APjAAAUaDca3/Tmc95E9J4/2YS0sGYcCeBYjojiIvdDeNICYBojNJtJS
        ddMvLnJhaV/8rz4fdYx2WUjdUh5D2yqItMnPd7oh+RCvz+eH+fXm3HknrojH/0kzzixmQqkieQh
        /oSYufXcmx8iodfHg
X-Received: by 2002:ac8:59:: with SMTP id i25mr6602490qtg.110.1582736916428;
        Wed, 26 Feb 2020 09:08:36 -0800 (PST)
X-Google-Smtp-Source: APXvYqyS+HqsEp+u+RofwuLZvYoUP6zzNy7dMqOXjs98gLSQY/L68YAvDBdrObvy8dyF57oIYkFXQQ==
X-Received: by 2002:ac8:59:: with SMTP id i25mr6602466qtg.110.1582736916208;
        Wed, 26 Feb 2020 09:08:36 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id n5sm1427597qkk.121.2020.02.26.09.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:08:35 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:08:30 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dahern@digitalocean.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for
 using XDP
Message-ID: <20200226120706-mutt-send-email-mst@kernel.org>
References: <20200226005744.1623-1-dsahern@kernel.org>
 <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com>
 <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com>
 <87wo89zroe.fsf@toke.dk>
 <20200226032204-mutt-send-email-mst@kernel.org>
 <87r1yhzqz8.fsf@toke.dk>
 <e6f6aaaa-664b-e80d-05fd-9821e6ae75ef@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e6f6aaaa-664b-e80d-05fd-9821e6ae75ef@digitalocean.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 08:58:47AM -0700, David Ahern wrote:
> On 2/26/20 1:34 AM, Toke Høiland-Jørgensen wrote:
> >>
> >> OK so basically there would be commands to configure which TX queue is
> >> used by XDP. With enough resources default is to use dedicated queues.
> >> With not enough resources default is to fail binding xdp program
> >> unless queues are specified. Does this sound reasonable?
> > 
> > Yeah, that was the idea. See this talk from LPC last year for more
> > details: https://linuxplumbersconf.org/event/4/contributions/462/
> 
>  Hopefully such a design is only required for a program doing a Tx path
> (XDP_TX or XDP_REDIRECT). i.e., a program just doing basic ACL, NAT, or
> even encap, decap, should not have to do anything with Tx queues to load
> and run the program.

Well when XDP was starting up it wasn't too late to require
meta data about which codes can be returned (e.g. whether program
can do tx). But by now there's a body of binary programs out there,
it's probably too late ...


-- 
MST

