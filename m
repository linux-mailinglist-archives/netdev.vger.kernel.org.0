Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFA51714D9
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 11:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728725AbgB0KTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 05:19:38 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32977 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728454AbgB0KTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 05:19:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582798776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=olxhZg+Lu0ojFRBIe5W7f9k+bGj829JWtT8ipS4rrQI=;
        b=gdVCHUH7OI5eZfsW54mVvBVwSrnULISL/6UepwMulTYnCRTqs/1k9a3CNDkleQct2ww4AJ
        3WwR7Iwe7/4nDz3kKSnPgVUdYXIrGzK51o7bqfEP2HPJKtrU/C84Czy8jGZ4n9LctjdJ81
        k6BVjvlyFOLVPtr6rAHG6MHi7mBhqRI=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-odDj0EPnPXKu1XH1hhMhPQ-1; Thu, 27 Feb 2020 05:19:28 -0500
X-MC-Unique: odDj0EPnPXKu1XH1hhMhPQ-1
Received: by mail-lj1-f200.google.com with SMTP id l14so735347ljb.10
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 02:19:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=olxhZg+Lu0ojFRBIe5W7f9k+bGj829JWtT8ipS4rrQI=;
        b=sjoxOQ/5yUTfi70qhDcNxFeXPZJH8IkDAj2TEh0zc3DaMzuyCT8caWyTbufYQAbqJP
         Eqo4frHzplVU89H0Hcq4MT2eXgfMbgVXgrJiKkUSHP8YEdaXhhJt1gpVgy3cK1YJaGzA
         Pb4bg988BiW1qbUb/MrgoPYqTilc8xfcizK5O8SUEydj6X9r6Tstu7OJbW6Exz8C0WiD
         aVoIJpMhWlF4gnAI33YJytyjVb0FyPdXf3977dbPFyhFhtFr7oq1FsZXEbNDFmxfGZns
         wBA9S2RUilSwRU0CxrPjDR0SPapK428qR2SAq27Dk75EMDF4pIJHvWUNbWiSlBlygH1+
         5wMQ==
X-Gm-Message-State: ANhLgQ2m1z0ngnjDh7faUwMsYV84ECniCEEVY/49/y9frgpRYJ7nnhTY
        DC+368U7iTFnp6/l2XxcqUakClW1q36XDl754urUVCLgAcyz5/UGMAXNTDGC6mc5WqsPq3710I1
        YazJNqZmEZrArdffx
X-Received: by 2002:a2e:7c08:: with SMTP id x8mr2318569ljc.185.1582798766837;
        Thu, 27 Feb 2020 02:19:26 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtwQk/Jef8wpAo4hy+RNQ/OQtGr4/GTjzfCpT7qlTzC82arClLScPygo97zJFMv6KLsiOX9MQ==
X-Received: by 2002:a2e:7c08:: with SMTP id x8mr2318559ljc.185.1582798766674;
        Thu, 27 Feb 2020 02:19:26 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id t1sm2849581lji.98.2020.02.27.02.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 02:19:25 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 59671180362; Thu, 27 Feb 2020 11:19:25 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dahern@digitalocean.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Subject: Re: [PATCH RFC net-next] virtio_net: Relax queue requirement for using XDP
In-Reply-To: <0dc879c5-12ce-0df2-24b0-97d105547150@digitalocean.com>
References: <20200226005744.1623-1-dsahern@kernel.org> <23fe48b6-71d1-55a3-e0e8-ca4b3fac1f7f@redhat.com> <9a5391fb-1d80-43d1-5e88-902738cc2528@gmail.com> <87wo89zroe.fsf@toke.dk> <20200226032204-mutt-send-email-mst@kernel.org> <87r1yhzqz8.fsf@toke.dk> <0dc879c5-12ce-0df2-24b0-97d105547150@digitalocean.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 27 Feb 2020 11:19:25 +0100
Message-ID: <87wo88wcwi.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dahern@digitalocean.com> writes:

> On 2/26/20 1:34 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> OK so basically there would be commands to configure which TX queue is
>>> used by XDP. With enough resources default is to use dedicated queues.
>>> With not enough resources default is to fail binding xdp program
>>> unless queues are specified. Does this sound reasonable?
>> Yeah, that was the idea. See this talk from LPC last year for more
>> details: https://linuxplumbersconf.org/event/4/contributions/462/
>>=20
>
> Can we use one of the breakout timeslots at netdevconf and discuss this
> proposal and status?

Adding in Magnus and Jesper; I won't be at netdevconf, sadly, but you
guys go ahead :)

Magnus indicated he may have some preliminary code to share soonish.
Maybe that means before netdevconf? ;)

-Toke

