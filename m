Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7CE3C26C3
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 17:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhGIPZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 11:25:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50041 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231976AbhGIPZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 11:25:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625844185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/MSs7e9/5mFzT19cocOuGussgM186tNOiT4DybIex0o=;
        b=P9JoMzpwNy7ZQ7CuS1oglpa13sPQg4H6tNPYIHbxOYhccZ/HbWSd9Jh4nW3SCBktL8wfXy
        rPR6c2r1TxDlLJLcz3Bu1XsNPHZ5xUcDooA++8efAng7fjov3EAdC9FdNcyUUmoED0Ezuu
        pIUexhz1dnpixi/C47uAbc/JwlT1/h0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-NIXdOn31PSSc2amsa_682A-1; Fri, 09 Jul 2021 11:23:04 -0400
X-MC-Unique: NIXdOn31PSSc2amsa_682A-1
Received: by mail-ed1-f71.google.com with SMTP id p23-20020aa7cc970000b02903948bc39fd5so5437383edt.13
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 08:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/MSs7e9/5mFzT19cocOuGussgM186tNOiT4DybIex0o=;
        b=TG5KAiL6jWGWSs1/tJTvQVszb9L6fqsfm63uNY5TDSgPhmPCNXqWvNykx9qT0NHdVc
         bMN7iEGik5lYugMcYk4ebkbkwwOWb0jHS/Tnzl0K21Q/closYzHce7+ESH/EfQ95jgwS
         +ZwVTWozN/TJ2AUeDtkoyg6FRW1OWqngfzs6hdZZ+Ar8lA99gKKFnNJjveJdXi+fTfx0
         J9j07jH6s7dCZcx95iU6UOY5WZXdE+6Fov6MWpuWVe9oY8bKcyry7CY5KRaSVzmF5tvT
         nY6sNM+0fU0fjtLt85XYMIJiYdmyfIl7ddc/HGbpc4Xig7fN+dxNOpT9ImrghqELsl9n
         QC8Q==
X-Gm-Message-State: AOAM533XrwGrRFWAa7R4R9Sqqxpxd7KPa/Mb33DHT2uX45kWCaAWB+ZF
        29CIY4WRxKcaReea9BxchkyUyXQWCnWe7KLJsO3EhukPfQoo8dWeP93U8mzp2SG8tlcTOjBgyX3
        BShAx9caJoBcz7ZT6
X-Received: by 2002:a05:6402:7cf:: with SMTP id u15mr47276985edy.197.1625844182933;
        Fri, 09 Jul 2021 08:23:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxklF3rRQGtDd9KiCcbIUh4UI1WTjDB1ZcDA6Ffi+ReP8/Hffk1jdz3OZu0PhB2HhmYTX0jYw==
X-Received: by 2002:a05:6402:7cf:: with SMTP id u15mr47276922edy.197.1625844182309;
        Fri, 09 Jul 2021 08:23:02 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d25sm3157704edu.83.2021.07.09.08.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 08:23:01 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id D5CD3180733; Fri,  9 Jul 2021 17:23:00 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [RFC PATCH 1/3] veth: implement support for set_channel ethtool op
In-Reply-To: <9c451d25fb36bc82e602bb93e384b262be743fbf.camel@redhat.com>
References: <cover.1625823139.git.pabeni@redhat.com>
 <681c32be3a9172e9468893a89fb928b46c5c5ee6.1625823139.git.pabeni@redhat.com>
 <878s2fvln4.fsf@toke.dk>
 <1c3d691c01121e4110f23d5947b2809d5cce056b.camel@redhat.com>
 <9c451d25fb36bc82e602bb93e384b262be743fbf.camel@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 09 Jul 2021 17:23:00 +0200
Message-ID: <87lf6feckr.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> On Fri, 2021-07-09 at 12:49 +0200, Paolo Abeni wrote:
>> On Fri, 2021-07-09 at 12:15 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>> > > +	if (netif_running(dev))
>> > > +		veth_close(dev);
>> > > +
>> > > +	priv->num_tx_queues =3D ch->tx_count;
>> > > +	priv->num_rx_queues =3D ch->rx_count;
>> >=20
>> > Why can't just you use netif_set_real_num_*_queues() here directly (and
>> > get rid of the priv members as above)?
>>=20
>> Uhm... I haven't thought about it. Let me try ;)
>
> Here there is a possible problem: if the latter
> netif_set_real_num_*_queues() fails, we should not change the current
> configuration, so we should revert the
> first netif_set_real_num_*_queues() change.
>
> Even that additional revert operation could fail. If/when that happen
> set_channel() will leave the device in a different state from both the
> old one and the new one, possibly with an XDP-incompatible number of
> queues.
>
> Keeping the  netif_set_real_num_*_queues() calls in veth_open() avoid
> the above issue: if the queue creation is problematic, the device will
> stay down.
>
> I think the additional fields are worthy, WDYT?

Hmm, wouldn't the right thing to do be to back out the change and return
an error to userspace? Something like:

+	if (netif_running(dev))
+		veth_close(dev);
+
+	old_rx_queues =3D dev->real_num_rx_queues;
+	err =3D netif_set_real_num_rx_queues(dev, ch->rx_count);
+	if (err)
+		return err;
+
+	err =3D netif_set_real_num_tx_queues(dev, ch->tx_count);
+	if (err) {
+		netif_set_real_num_rx_queues(dev, old_rx_queues);
+		return err;
+	}
+
+	if (netif_running(dev))
+		veth_open(dev);
+	return 0;


(also, shouldn't the result of veth_open() be returned? bit weird if you
don't get an error but the device stays down...)

-Toke

