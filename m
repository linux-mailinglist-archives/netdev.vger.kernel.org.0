Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EB317042C
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 17:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgBZQVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 11:21:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39411 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726148AbgBZQVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 11:21:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582734072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+PZOrnclHlzyNyh6vayM0uYlmPcz0oG8mfIUPthLLKA=;
        b=IIC29785oMVGAi30fraX2Mqnk777E97T3GbpjFjZ3sbhkDFgb+EaeZ2+WAJhnq1YIEnpcu
        j0AU8wtkGxU082mLyeXyceXVVRIB2aQgTVKX649kywM8McH6j4p0jiD8E44XUBWL5NrxRp
        GCNwEpZOUTYM5F9RfLPeYIiEdvTGHQs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-nXG2wuFlORyZTbhQ0dVTrQ-1; Wed, 26 Feb 2020 11:21:05 -0500
X-MC-Unique: nXG2wuFlORyZTbhQ0dVTrQ-1
Received: by mail-lj1-f200.google.com with SMTP id d14so848813ljg.17
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 08:21:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=+PZOrnclHlzyNyh6vayM0uYlmPcz0oG8mfIUPthLLKA=;
        b=It/C9I7VqaIS9YftGz5C1zztL2nj0RJvQVY5lw+NZdCL9HypDMaM9yepG4yQ5lRgqX
         1kXZGoCPk1BdFCXezFP5/tRh6YEmbzwELjz/v5IlnVGU3ANA0UzgYLtSD+C7o675moBO
         536KZD3m22t/eECbSjqmxSm7Nfk4p7bn+6D1qhtyavRu4ULkcvwa3tK4oX/iY/8jaAtk
         EeV99flau3gkkMu8diOGi0/EHEjOI8aaXy4vWyQE+oB0o8BTX2wBOF0QgNLz179uV4Eb
         obOKLDhtl5vDtEPBq0SWwlI3Hx0esglKMk3HOVMo2wjDY9caBkMg4FiAzSB5FIMnY/xP
         J8fw==
X-Gm-Message-State: ANhLgQ3DHeJZHLa0pAmezq07cpwCxvzv+xynOnPVHcypoxL5cE4F3tHS
        89kf4QtySvE9R1AOSihVlCK4JklkBKeosXjdtJw7f7CJMD/oAlgvk5LoKcaFqtSYdL3P5aHaGUc
        jZcox6/xbRKGNStrl
X-Received: by 2002:a2e:9b90:: with SMTP id z16mr3658947lji.254.1582734062585;
        Wed, 26 Feb 2020 08:21:02 -0800 (PST)
X-Google-Smtp-Source: ADFU+vucAUgrMVWoBX0Jyf9aVoL1SCvhv053L//BO/+qISFkCs/i/XSXGJkYgzyzxpqyzJY/46Zipw==
X-Received: by 2002:a2e:9b90:: with SMTP id z16mr3658940lji.254.1582734062416;
        Wed, 26 Feb 2020 08:21:02 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id p24sm359265lfo.93.2020.02.26.08.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 08:21:01 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E52AF180362; Wed, 26 Feb 2020 17:21:00 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dahern@digitalocean.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for using XDP
In-Reply-To: <e6f6aaaa-664b-e80d-05fd-9821e6ae75ef@digitalocean.com>
References: <20200226005744.1623-1-dsahern@kernel.org> <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com> <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk> <20200226032204-mutt-send-email-mst@kernel.org> <87r1yhzqz8.fsf@toke.dk> <e6f6aaaa-664b-e80d-05fd-9821e6ae75ef@digitalocean.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 26 Feb 2020 17:21:00 +0100
Message-ID: <87tv3dxqtv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dahern@digitalocean.com> writes:

> On 2/26/20 1:34 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>
>>> OK so basically there would be commands to configure which TX queue is
>>> used by XDP. With enough resources default is to use dedicated queues.
>>> With not enough resources default is to fail binding xdp program
>>> unless queues are specified. Does this sound reasonable?
>>=20
>> Yeah, that was the idea. See this talk from LPC last year for more
>> details: https://linuxplumbersconf.org/event/4/contributions/462/
>
>  Hopefully such a design is only required for a program doing a Tx path
> (XDP_TX or XDP_REDIRECT). i.e., a program just doing basic ACL, NAT, or
> even encap, decap, should not have to do anything with Tx queues to load
> and run the program.

No but they may want to configure RX queues (for CPU affinity, etc).
Ideally we'd want both (TX and RX) to be configurable through the same
interface.

-Toke

