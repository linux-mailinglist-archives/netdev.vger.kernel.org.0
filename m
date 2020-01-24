Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DE1147932
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 09:14:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727493AbgAXIOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 03:14:11 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48576 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726695AbgAXIOK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 03:14:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579853648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X+EFnGJpGD7BOakillThs59qTAXDMWK8v3DfAIAXlWo=;
        b=UXCRsAkZN07vYULHM/HbV49r6Zeyp9xtjNLZ4y+B/lE1nAHc06Bx7qdvcCeZVLBcfph0ez
        JKBom0rZi3txVgJIfgqH0FJS7V1T3i9y3SH84rRAO1c/Aw9DYV9/KhnpqsyQ9HGiOkpJ5Z
        C0StdPlAotB4EVWLYwefrqAJBTiOtt0=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-b3k_VVdCOPyETMDvLhQClA-1; Fri, 24 Jan 2020 03:14:05 -0500
X-MC-Unique: b3k_VVdCOPyETMDvLhQClA-1
Received: by mail-vk1-f197.google.com with SMTP id m25so475559vko.19
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 00:14:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X+EFnGJpGD7BOakillThs59qTAXDMWK8v3DfAIAXlWo=;
        b=aol/ETmHf9rGlAwK3xpThcYoR4oql1Z65E+wD/TMZi2HzYeIMOO/J3mD7pZMtxeuaj
         Ss23qL5oxM1zvWm5ZTz+9cfM3Pkky9aVMFV9itosqiS0ST6zbksccAZDRycbJaCdn6mJ
         EDbG2KoKEKjb21+w6Y4KQqg1wJM81aIqF4gqv7YH/uNm/ezI7O/ZJN/UHN/D0mijTRh9
         aVgq9TPfO5DeDoS3+wJRYQDUrAN0p6ZgEhV+kcgy5Kh6ZZR1CGoJ6ekYNkZm+aZmJlMa
         h8ZwR/M6BzYrvMRaf4HlgHln/bEq/5WpMqYpbl2Ldyesqqw4AbikAqsNjWYQUGxT/dpQ
         glIA==
X-Gm-Message-State: APjAAAUw6vauiPKro7bpGZj1y2zSKx0A7KWLfCQApsnemmwFyKG7NA6N
        yMVfwSRPNurKERwHIQCFAtF9Jh7EiXJcKCIOIGhlUJSTMWFKrhl98LQNW0WvgcET015k7N6mVqj
        y8INbWLKb/Rw5q1OyD+cmvm2HilUFP2CW
X-Received: by 2002:ab0:2408:: with SMTP id f8mr1078772uan.126.1579853644344;
        Fri, 24 Jan 2020 00:14:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqxr1tOLHfYUb+zS7CrQ2MSGRfW8uY3H6Cj5hdVp+YnPv9EKGcFY+4gFbLn6ZSNkULpi/bIZPglUU2TbtCfeWUE=
X-Received: by 2002:ab0:2408:: with SMTP id f8mr1078760uan.126.1579853643804;
 Fri, 24 Jan 2020 00:14:03 -0800 (PST)
MIME-Version: 1.0
References: <20200124072338.75163-1-sven.auhagen@voleatech.de>
In-Reply-To: <20200124072338.75163-1-sven.auhagen@voleatech.de>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 24 Jan 2020 09:13:52 +0100
Message-ID: <CAJ0CqmXf1Hw0rTkDiY=4Joyt0m9apFZ0y0+KwZhWSRixnBhhew@mail.gmail.com>
Subject: Re: [PATCH v3] mvneta driver disallow XDP program on hardware buffer management
To:     Sven Auhagen <sven.auhagen@voleatech.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "matteo.croce@redhat.com" <matteo.croce@redhat.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Recently XDP Support was added to the mvneta driver
> for software buffer management only.
> It is still possible to attach an XDP program if
> hardware buffer management is used.
> It is not doing anything at that point.
>
> The patch disallows attaching XDP programs to mvneta
> if hardware buffer management is used.
>
> Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
>
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet=
/marvell/mvneta.c
> index 71a872d46bc4..a2e9ba9b918f 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -2158,7 +2158,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  prefetch(data);
>
>  xdp->data_hard_start =3D data;
> -xdp->data =3D data + pp->rx_offset_correction + MVNETA_MH_SIZE;
> +xdp->data =3D data + pp->rx_offset_correction;

Hi Sven,

I think this is going to break XDP support for marvell espressobin (sw
buffer management).
I guess we need to identify when MH header is inserted.

Regards,
Lorenzo

>  xdp->data_end =3D xdp->data + data_len;
>  xdp_set_data_meta_invalid(xdp);
>
> @@ -4960,9 +4960,10 @@ static int mvneta_probe(struct platform_device *pd=
ev)
>   * NET_SKB_PAD, exceeds 64B. It should be 64B for 64-bit
>   * platforms and 0B for 32-bit ones.
>   */
> -pp->rx_offset_correction =3D max(0,
> -       NET_SKB_PAD -
> -       MVNETA_RX_PKT_OFFSET_CORRECTION);
> +if (pp->bm_priv)
> +pp->rx_offset_correction =3D max(0,
> +       NET_SKB_PAD -
> +       MVNETA_RX_PKT_OFFSET_CORRECTION);
>  }
>  of_node_put(bm_node);
>
>
> +++ Voleatech auf der E-World, 11. bis 13. Februar 2020, Halle 5, Stand 5=
21 +++
>
> Beste Gr=C3=BC=C3=9Fe/Best regards
>
> Sven Auhagen
> Dipl. Math. oec., M.Sc.
> Voleatech GmbH
> HRB: B 754643
> USTID: DE303643180
> Grathwohlstr. 5
> 72762 Reutlingen
> Tel: +49 7121539550
> Fax: +49 7121539551
> E-Mail: sven.auhagen@voleatech.de
> www.voleatech.de<https://www.voleatech.de>
> Diese Information ist ausschlie=C3=9Flich f=C3=BCr den Adressaten bestimm=
t und kann vertraulich oder gesetzlich gesch=C3=BCtzte Informationen enthal=
ten. Wenn Sie nicht der bestimmungsgem=C3=A4=C3=9Fe Adressat sind, unterric=
hten Sie bitte den Absender und vernichten Sie diese Mail. Anderen als dem =
bestimmungsgem=C3=A4=C3=9Fen Adressaten ist es untersagt, diese E-Mail zu l=
esen, zu speichern, weiterzuleiten oder ihren Inhalt auf welche Weise auch =
immer zu verwenden. F=C3=BCr den Adressaten sind die Informationen in diese=
r Mail nur zum pers=C3=B6nlichen Gebrauch. Eine Weiterleitung darf nur nach=
 R=C3=BCcksprache mit dem Absender erfolgen. Wir verwenden aktuelle Virensc=
hutzprogramme. F=C3=BCr Sch=C3=A4den, die dem Empf=C3=A4nger gleichwohl dur=
ch von uns zugesandte mit Viren befallene E-Mails entstehen, schlie=C3=9Fen=
 wir jede Haftung aus.
>

