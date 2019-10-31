Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DEA0EB495
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 17:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbfJaQXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 12:23:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45050 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726540AbfJaQXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 12:23:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572538981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RZGD6Pca66p5OqKCfFHPRMb7vejTA2ViSdqHSiuuHfA=;
        b=PX1zT8HVmnAUEwpQcrXSeip2qCJaIzVkjGWOLJiMeeW8iAN9SP5j+DK5BDpjRxLYqindwv
        Nxp3Cq2IZ1YMiZxEwqPfuaS6w20lyp3hFQ/ChU23yhnuNnMCFKakivfIgVy3rn2nS0t1lO
        m5g54PY0951qvwKsr09fM2KGAvOhT34=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-mJYShhaRNny9ElEeptZi6g-1; Thu, 31 Oct 2019 12:22:58 -0400
Received: by mail-lf1-f70.google.com with SMTP id c27so1551822lfj.19
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 09:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eAv0yHRWBIPIgHHe1zlsuAAt21y47eMoEjAinE7MfyI=;
        b=AvBQhItA8FI/4IwfUJ2tleLJkf3HUegyhZQOm27E6KYQlOI8hKkKLNR4zXoD5s/ZBM
         OPUAeNL+hQ9hf7dc9xmCyWXsOrh386S7ieNlOp5zx8XVP9ggfr74BMdfG9JgN31h0jfv
         L+svl3W2ZCJM3ircYSUFqkEVfomTi3EpsbcbQVw7Sr5EZsMotXd8IzfbXNDj8U6POk8L
         zVT2Ty6J3RsYcjy0xNDWaXUc9FaeuUISjONMg29padMVDf/WsRW1q7lppw7e5nRLJdVG
         DtBJ/50hxyZ1XaF5Qb6aHGcbudzef5Luh3/MVqeJreJ08dyk/E5P2aLxG2eTT+12JumP
         G0Hg==
X-Gm-Message-State: APjAAAXe6OrV16zUcuVrQ2i5rDtTBbMFszl4Yx3qz5SB6WkFhG6cXajQ
        eY5I4sX+HmFXJL4lIks8ivsGRIieu4ujwVoQIFWervl4ZeFyO2nY33ShqaoXvu0TjNPpnbUVvo1
        2VNVxQZf/W2HxpEm4CzKtvk8rpyw+uib0
X-Received: by 2002:ac2:5195:: with SMTP id u21mr4119352lfi.97.1572538977467;
        Thu, 31 Oct 2019 09:22:57 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxL300SMULllKwH7VWvDdiKCap6Fv+tAFO8sNUl58YhcqKjt43ZyLnKC2evCebrRPLnKKAh/6MyHQYa2nywefI=
X-Received: by 2002:ac2:5195:: with SMTP id u21mr4119340lfi.97.1572538977273;
 Thu, 31 Oct 2019 09:22:57 -0700 (PDT)
MIME-Version: 1.0
References: <20191029135053.10055-1-mcroce@redhat.com> <20191029135053.10055-5-mcroce@redhat.com>
 <5be14e4e-807f-486d-d11a-3113901e72fe@cumulusnetworks.com>
 <576a4a96-861b-6a86-b059-6621a22d191c@gmail.com> <CAGnkfhzEgaH1-YNWw1_HzB5FOhZHjKewLD9NP+rnTP21Htxnjw@mail.gmail.com>
 <43abab53-1425-0bff-9f79-50bd47567605@gmail.com> <CAGnkfhyaXzMx608jZqqjdywv6BZst97QSmGe++aSc=-xOQSWzg@mail.gmail.com>
In-Reply-To: <CAGnkfhyaXzMx608jZqqjdywv6BZst97QSmGe++aSc=-xOQSWzg@mail.gmail.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Thu, 31 Oct 2019 17:22:21 +0100
Message-ID: <CAGnkfhxvOdZgS90PittFgAtYnPzfQNVFsxsTpadzBcr1-mnD=Q@mail.gmail.com>
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
X-MC-Unique: mJYShhaRNny9ElEeptZi6g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 12:19 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> On Wed, Oct 30, 2019 at 12:14 AM Eric Dumazet <eric.dumazet@gmail.com> wr=
ote:
> >
> >
> >
> > On 10/29/19 4:03 PM, Matteo Croce wrote:
> >
> > > Hi Eric,
> > >
> > > this would work for locally generated echoes, but what about forwarde=
d packets?
> > > The point behind my changeset is to provide consistent results within
> > > a session by using the same path for request and response,
> > > but avoid all sessions flowing to the same path.
> > > This should resemble what happens with TCP and UDP: different
> > > connections, different port, probably a different path. And by doing
> > > this in the flow dissector, other applications could benefit it.
> >
> > In principle it is fine, but I was not sure of overall impact of your c=
hange
> > on performance for 99.9% of packets that are not ICMP :)
> >
>
> Good point. I didn't measure it (I will) but all the code additions
> are under some if (proto =3D=3D ICMP) or similar.
> My guess is that performance shouldn't change for non ICMP traffic,
> but I'm curious to test it.
>

Indeed if there is some impact it's way below the measurement uncertainty.
I've bonded two veth pairs and added a tc drop to the peers, then
started mausezahn to generate UDP traffic.
Traffic is measured on the veth peers:

Stock 5.4-rc5:

rx: 261.5 Mbps 605.4 Kpps
rx: 261.2 Mbps 604.6 Kpps
rx: 261.6 Mbps 605.5 Kpps

patched:

rx: 261.4 Mbps 605.1 Kpps
rx: 261.1 Mbps 604.4 Kpps
rx: 260.3 Mbps 602.5 Kpps

perf top shows no significatn change in bond* and skb_flow* functions

Regards,
--=20
Matteo Croce
per aspera ad upstream

