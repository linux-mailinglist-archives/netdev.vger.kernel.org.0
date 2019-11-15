Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD4DFE2DD
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 17:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbfKOQdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 11:33:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51486 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727585AbfKOQdX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 11:33:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573835603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z9RQTn/YJLEGGG4gIu+Q7/UtczBmDfvGFCl/8TZvJtg=;
        b=B6jyfsAU9zw3wkajmgutl6ahHU8Wa7XMx6toMv7DuLRuhQHVZCorDvSqXVLu/zI4RZzD+G
        YVKJRh8XJHjkkaJ557ULuqFFsF+bSVbRQp0HOvnwEfmbmBNu/gcQtIhEmyNM3fYq8iaJKK
        n3o7PIIA5bztY/FftAQstW8ReSG1Hsg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-p_Cxq5eKOTS281H-bda8xw-1; Fri, 15 Nov 2019 11:33:21 -0500
Received: by mail-lf1-f70.google.com with SMTP id h3so3171309lfp.17
        for <netdev@vger.kernel.org>; Fri, 15 Nov 2019 08:33:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=z9RQTn/YJLEGGG4gIu+Q7/UtczBmDfvGFCl/8TZvJtg=;
        b=LPtWFokaQ3lhj2OgjqwKcE3mBLZA2qsqFt8KkwkRry/gPMJmbBgcx0B/N6Q2wo6GuF
         5GnP66Sh1vvSDotT6WV3jHYN0DxWRq6UDSKmVeBE/ws5q4py87mT8elRfzedA1f03jRA
         4ToABzrFnBV5yydX0he/bLjBePlyTqftQ6c5/yUaFjwPBO0RvrGjVPt/8iCdikP3fuv3
         Gr8HvNPwhXUYKADUSbsKd3sUQtiQRkAiSENqVYuC+l9x28jyBoOjaAZVJeKVWEK/+4PG
         RWIFtcYsuY5bXvQOxfcRTOuhFLdhvWfKwN79uL3HbIDnclVQGzOD3K18SrnY5GRjw+2b
         bT2A==
X-Gm-Message-State: APjAAAXh1FIO9R5/17ku5GW+cqgDxkKl3KlZt3qK1+Rc+Zikd0i3VMop
        bvjjNjDBB8IPhufLcyPaWFE/j/8fRHzfLwnFnBz/xROADhkMRa776On/y+soWRa70+bdIFF++dt
        ulRBp/tWy95TiSKGQ
X-Received: by 2002:a2e:9699:: with SMTP id q25mr11814160lji.251.1573835600414;
        Fri, 15 Nov 2019 08:33:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqzCcKxBA+q8oImt2+X/igN9i2edkMayXMOVwuOXFuVPxEllAT9Y756hL0kQXy6zymAwf8wCeg==
X-Received: by 2002:a2e:9699:: with SMTP id q25mr11814150lji.251.1573835600248;
        Fri, 15 Nov 2019 08:33:20 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id r22sm4106880ljk.31.2019.11.15.08.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 08:33:19 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DB3CA1818F2; Fri, 15 Nov 2019 17:33:18 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next v1 PATCH 2/4] page_pool: add destroy attempts counter and rename tracepoint
In-Reply-To: <157383036409.3173.14386381829936652438.stgit@firesoul>
References: <157383032789.3173.11648581637167135301.stgit@firesoul> <157383036409.3173.14386381829936652438.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 15 Nov 2019 17:33:18 +0100
Message-ID: <87h835kskx.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: p_Cxq5eKOTS281H-bda8xw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> When Jonathan change the page_pool to become responsible to its
> own shutdown via deferred work queue, then the disconnect_cnt
> counter was removed from xdp memory model tracepoint.
>
> This patch change the page_pool_inflight tracepoint name to
> page_pool_release, because it reflects the new responsability
> better.  And it reintroduces a counter that reflect the number of
> times page_pool_release have been tried.
>
> The counter is also used by the code, to only empty the alloc
> cache once.  With a stuck work queue running every second and
> counter being 64-bit, it will overrun in approx 584 billion
> years. For comparison, Earth lifetime expectancy is 7.5 billion
> years, before the Sun will engulf, and destroy, the Earth.

I love how you just casually threw that last bit in there; and now I'm
thinking about under which conditions that would not be enough. Maybe
someone will put this code on a space probe bound for interstellar
space, which will escape the death of our solar system only to be
destined to increment this counter forever in the cold, dead void of
space?

I think that is a risk we can live with, so:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

