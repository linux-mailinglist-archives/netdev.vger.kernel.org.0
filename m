Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9EBEE937B
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfJ2XUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:20:34 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:31337 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725840AbfJ2XUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:20:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572391232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zYrZ9qZ2zWpBH4PiUs3Dx0qyoqOMS6/RWHc3sb1XR3Y=;
        b=UcN4DTjVftYR/eccVBbVTxg3PfWB7DoPi42TX3QtEio+XNmlI0gQV14Aca2vN+jkb5AlNB
        raKH4H9DG+au20DWkmiT/4205BBWcOOThzFbbdkS/A4lfneoGL2FuuUFJHwIpztu4ep095
        qExPI3CA6kjbf5zbx5Gsbm4aoLMSjm0=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-6WjTO50RO3O40ZX8Dpq0YQ-1; Tue, 29 Oct 2019 19:20:29 -0400
Received: by mail-oi1-f198.google.com with SMTP id t185so219081oif.13
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 16:20:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y8T+eUd2N5DPhgiGOedRryry9FtRQaSq7h4Wr10JfYs=;
        b=ROxezqO2lysAE5LuS4W9LOHyQuLrKX4aU0ZUt4hstdSS5HlRNoQlYHqhwYXF+E2IXf
         lPKGbigroOknadHzX0gJSgG/G7QqRdfuQpCpCEw3Gm4iwTiBIW6YcjCOJHBTG3GnL/6s
         4/+Xgemi/hAbBYZtLuO8XzjpuRjcAkGhUD948KdQ3CpZrbVFbV4BDpkeicsRjZ0TCBuA
         V1RqaMzBCuwdzwunnEaRZ/TSBYMGIfkVAMq52xGzczQrGqMKWXf1oYlUotwNo84YgX0q
         jnfJu0cKzKWBlmZS3eYj40EGjk2YLoUAIxhFgUMz0a2VOQ4fVwvmlQ5XYlIsCf+cPs96
         RseQ==
X-Gm-Message-State: APjAAAWKOozsYaaXH3H/wegDwP/gC9BrnDVEGdhZPhpp+TrfVjvnfNS8
        5cOoimd1vWVaNsxR4N9Jv2MXZqee1ErwSsyufaMLZ/kqIdmslKCVCgjFLrncwKwuyqkXGVGzEkn
        7VmJSnuttwwcjW81wDvYlq3U5GA5juVAn
X-Received: by 2002:a9d:ef0:: with SMTP id 103mr19811695otj.2.1572391228946;
        Tue, 29 Oct 2019 16:20:28 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyX2+DJAAyNg860k7Boi5HEX3GTIpndbmJ3I5lT4rE07JAmXWIQisZEeV+os4zRBJoNncNLhedcRv1X9WtrxyI=
X-Received: by 2002:a9d:ef0:: with SMTP id 103mr19811680otj.2.1572391228689;
 Tue, 29 Oct 2019 16:20:28 -0700 (PDT)
MIME-Version: 1.0
References: <20191029135053.10055-1-mcroce@redhat.com> <20191029135053.10055-5-mcroce@redhat.com>
 <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com>
 <576a4a96-861b-6a86-b059-6621a22d191c@gmail.com> <CAGnkfhzEgaH1-YNWw1_HzB5FOhZHjKewLD9NP+rnTP21Htxnjw@mail.gmail.com>
 <43abab53-1425-0bff-9f79-50bd47567605@gmail.com>
In-Reply-To: <43abab53-1425-0bff-9f79-50bd47567605@gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 30 Oct 2019 00:19:52 +0100
Message-ID: <CAGnkfhyaXzMx608jZqqjdywv6BZst97QSmGe++aSc=-xOQSWzg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] bonding: balance ICMP echoes in layer3+4 mode
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>
X-MC-Unique: 6WjTO50RO3O40ZX8Dpq0YQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 12:14 AM Eric Dumazet <eric.dumazet@gmail.com> wrot=
e:
>
>
>
> On 10/29/19 4:03 PM, Matteo Croce wrote:
>
> > Hi Eric,
> >
> > this would work for locally generated echoes, but what about forwarded =
packets?
> > The point behind my changeset is to provide consistent results within
> > a session by using the same path for request and response,
> > but avoid all sessions flowing to the same path.
> > This should resemble what happens with TCP and UDP: different
> > connections, different port, probably a different path. And by doing
> > this in the flow dissector, other applications could benefit it.
>
> In principle it is fine, but I was not sure of overall impact of your cha=
nge
> on performance for 99.9% of packets that are not ICMP :)
>

Good point. I didn't measure it (I will) but all the code additions
are under some if (proto =3D=3D ICMP) or similar.
My guess is that performance shouldn't change for non ICMP traffic,
but I'm curious to test it.

--=20
Matteo Croce
per aspera ad upstream

