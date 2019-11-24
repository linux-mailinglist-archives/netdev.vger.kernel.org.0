Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5151082FC
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 11:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfKXKwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 05:52:13 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:25389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725980AbfKXKwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 05:52:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574592731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mgrqyGrI4wz4JE0efwdw2KoDDevv1GGFzKxHMz7NT+E=;
        b=Dhk6rS05tH/5Kf+g8wNADtjIWmvzRVp/11LTQ4TFy74q+aB/ay6okc1ofy8R4EL9YTHj2J
        paEdnsWpYA8ACY6ly1nkuZY4jU7TI/cepqawAAKWMr7ksqZ6sOTNXJsJRSejcAqb0kd1jk
        vDd/jquK4kUpZ24JXWRUxEz3r3lpM0E=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-EZ8iaZvOMTyaADA0WQgEMw-1; Sun, 24 Nov 2019 05:52:09 -0500
Received: by mail-qt1-f197.google.com with SMTP id x8so6417018qtq.14
        for <netdev@vger.kernel.org>; Sun, 24 Nov 2019 02:52:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aYTE+708WYU/v6e61/u6H0iTp+/IB5KOl36q0rPST20=;
        b=nDXVgMzA7ZjIic6hI8nahe2AdBMufD54Yj0HJ0jvpxRTPJtGJmVTGX5FfuXUrsqk6K
         yDGI4tMvBzTbscSqlqhSOTTVS/l4qTUlUbFDNKFuKVHzjD2FM4w+0Jo0vm/yVv/fq1R/
         Gn5zujtBu1TdcevzD+DPOuDe2LaRrrPO7Eghe60G5Qwv2FLHVexRBVT9/C6wcvOw/NXt
         0HI8LZIVdRHG+Kv22Ai+AFqS5KaJiXfQNmxzipGhIQm2n7S+17iUnhki/gb7x8SmSTHm
         NJXg9llA6ZGJioF4OnleORGzPl/VzGX6V3ZS4Ecc8Lx+/CM3ONOZWTYNJIMpZCNGcFxB
         OYyw==
X-Gm-Message-State: APjAAAUSDmi64ld+Di2WAGivtH42TVBj7Pb8OxghdHWNMQH+vqU57Woq
        bQpQj3BnAMAy8rcCoVe1X5BiHqdaJZL8zW6crho5p0SzZU9XBwziNz5qVF6EEBJSydgPrVkdPb6
        6doXLIfWVOkCK7Bjo
X-Received: by 2002:a0c:fa05:: with SMTP id q5mr12215641qvn.182.1574592729397;
        Sun, 24 Nov 2019 02:52:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqwZ7wVd3gE/UE/n6wQWaImHjk1yL624O9bg+Y7VbNSDbwNBANSGUiP3UWpATNi251yCQNG6IQ==
X-Received: by 2002:a0c:fa05:: with SMTP id q5mr12215627qvn.182.1574592729167;
        Sun, 24 Nov 2019 02:52:09 -0800 (PST)
Received: from redhat.com (bzq-79-176-6-42.red.bezeqint.net. [79.176.6.42])
        by smtp.gmail.com with ESMTPSA id x8sm1983132qtp.75.2019.11.24.02.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2019 02:52:08 -0800 (PST)
Date:   Sun, 24 Nov 2019 05:52:02 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Julio Faracco <jcfaracco@gmail.com>
Cc:     netdev@vger.kernel.org, Daiane Mendes <dnmendes76@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] drivers: net: virtio_net: Implement a
 dev_watchdog handler
Message-ID: <20191124054916-mutt-send-email-mst@kernel.org>
References: <20191122013636.1041-1-jcfaracco@gmail.com>
 <20191122052506-mutt-send-email-mst@kernel.org>
 <CAENf94KX1XR4_KXz9KLZQ09Ngeaq2qzYY5OE68xJMXMu13SuEg@mail.gmail.com>
 <20191122080233-mutt-send-email-mst@kernel.org>
 <CAENf94L7zU6JoM+19F+__b6W4mpe5Na=ayd+eYe4aZ+EBABmiA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAENf94L7zU6JoM+19F+__b6W4mpe5Na=ayd+eYe4aZ+EBABmiA@mail.gmail.com>
X-MC-Unique: EZ8iaZvOMTyaADA0WQgEMw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 23, 2019 at 08:33:40PM -0200, Julio Faracco wrote:
> >
> > netdev: pass the stuck queue to the timeout handler
> >
> > This allows incrementing the correct timeout statistic without any mess=
.
> > Down the road, devices can learn to reset just the specific queue.
> >
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > Warning: untested.
> >
>=20
> Question...
> Wouldn't be better to create a module parameter instead change the
> function scope?

Passing the value in a global variable? That fails to be reentrant ...

> I'm asking it because how many modules would effectively take advantage o=
f it?

The cost is effectively 0 though.

--=20
MST

