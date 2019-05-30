Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC17302B2
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfE3TR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:17:58 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39431 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfE3TR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:17:58 -0400
Received: by mail-ed1-f66.google.com with SMTP id e24so10641035edq.6;
        Thu, 30 May 2019 12:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HW3dpChuW0VqGcfns2DNgGB3hG0bQH+HsGf5JJist6Q=;
        b=k7y11l3yE6l+5m9EKPBTcgr75u9xJfKMrVZqGAKoywOieq5CwPApyPzRtBxP/zCWJz
         +1MuZjhbUqyRijNeUlnFnhOJGTO3DbsupMjmB7vpG3RjmQSU1suuiE8l9tXX+dPh2VEy
         44xACzctJky8I9ejqQueeZZ8lUwJGJDgqcFEkqkca78PC/wXNeIRf3mLlH503odX2mUn
         iViCbLgN5ohGOSGEqpbHx48/XUSMG47AG0nVQG1ELh8iCr5rm3LIbhlZr9aTG687Zi2Q
         kHlQ0xebIyYf6nuH9xzKtRn8Ozj5zU2HWv36Udf/75s2CTGUEIqaKKLVKZFku8QhZNs9
         vKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HW3dpChuW0VqGcfns2DNgGB3hG0bQH+HsGf5JJist6Q=;
        b=F0d7xIhBGK0Re1noOhepsXG5nPDPjbFsDq/pZSdqO6AKy7R/0euYP6tSOf/MgihdHP
         5S7GDYhW7yO//88wHysUPp7XPDTVQ2MPugn4M8BUFxfa7vN7NkNiRoFp+g7tFewB33OV
         vS5oDmkjDbml8fvB/xHIbCMw/LMJVJE8HSPZ2JC/XVOcw+NxaUiScR/4uRZ1vOQ8ftwU
         y2VvDQtNKmy2ylIELkDTbRefTbnCS/+nITH+nCNI25Zlp+QRCyBIWPs3hPEFaVsB3bOF
         LviPxddWzuYd9fwnIBMyrRA5qMWrlyszfb/hGSaW8KEDOeU7DIUPiS91A4Xtk7MKXtc7
         UbBg==
X-Gm-Message-State: APjAAAVhArCrR8ugpJJ9m9P6Rs9UfW04cyh+FAJM7UI1aGdIcTCX9j0Y
        ny95HaQC6QwrIGsB4Dd68JJf7FD0GZMgMboeiW4=
X-Google-Smtp-Source: APXvYqwg8TgkuFLjdNp+D3qZoIhiEoCt9bRsOWm4dKWBGf8sr4f2GHLv9t+Z77guXkDhUJJSCkvmJvt4nEb9+9IIC20=
X-Received: by 2002:a17:906:2acf:: with SMTP id m15mr5191784eje.31.1559243876891;
 Thu, 30 May 2019 12:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190528184415.16020-1-fklassen@appneta.com> <20190528184415.16020-2-fklassen@appneta.com>
 <CAF=yD-JvNFdWCBJ6w1_XWSHu1CDiG_QimrUT8ZCxw=U+OVvBMA@mail.gmail.com> <8A1636C9-7476-43B2-BAE0-B03675B3920E@appneta.com>
In-Reply-To: <8A1636C9-7476-43B2-BAE0-B03675B3920E@appneta.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 30 May 2019 15:17:20 -0400
Message-ID: <CAF=yD-JW1ZA-LA6iJ0X83UMJxmNLh7VfmUK7B=7LbYMY--wO6w@mail.gmail.com>
Subject: Re: [PATCH net-next v3 1/1] net/udp_gso: Allow TX timestamp with UDP GSO
To:     Fred Klassen <fklassen@appneta.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Asked elsewhere, but best answered here: given that xmit_more delays
> > delivery to the NIC until the last segment in a train, is the first
> > segment in your opinion still the best to attach the timestamp request
> > to?
> >
> > To reiterate, we do not want to need a follow-up patch to disable
> > xmit_more when timestamps are requested.
> >
>
> I think it would be worthwhile. I was playing with this patch =E2=80=A6
>
> +               /* software TX timeststamps are sent immediately */
> +               if (tsflags & SKBTX_SW_TSTAMP)
> +                       seg->xmit_more =3D 0;
>
> =E2=80=A6 which attempts to address this issue. I believe that the patch
> should be applied for software timestamps only.

Disagree, sorry.

Timestamped packets should take the same path as non-timestamped, so
that sampled timestamps are representative of the overall workload.

Moreover, due to how xmit_more works, applying the timestamp request
to the last segment will give you exactly the behavior that you are
looking for (bar requeue events): a timestamp before the NIC starts
working on any byte in the request. And that approach will be useful
for measuring host latency as well, unlike timestamping the first
segment.

Timestamping the first, then arguing that it is not useful as is and
requires more changes is the wrong path imho.

Perhaps it is easiest to just not split off a segment from the GSO
train when timestamp that independently. That works today.

> However when
> I applied in net-next I got the following compile error, which suggests
> there is more investigation needed, and therefore requires a separate
> patch.
>
> net/ipv4/udp_offload.c: In function =E2=80=98__udp_gso_segment=E2=80=99:
> net/ipv4/udp_offload.c:251:7: error: =E2=80=98struct sk_buff=E2=80=99 has=
 no member named =E2=80=98xmit_more=E2=80=99
>     seg->xmit_more =3D 0;

Yes, this has been moved to a percpu variable.
