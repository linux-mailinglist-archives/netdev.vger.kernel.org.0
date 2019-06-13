Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E38449C2
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 19:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbfFMRec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 13:34:32 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44580 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfFMRec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 13:34:32 -0400
Received: by mail-qk1-f195.google.com with SMTP id p144so1167991qke.11
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 10:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=vjp8AzbzM7TyaR3koS56Ggcg0U3MN11dnEYbMbimRNs=;
        b=c/TOsKfmO2RxrfiSEbdqUmqoGCbiH0LE7TrGB2Wyw1RErNYq0UJXBUFjUok91petJV
         pZgYkNyskwdEWoMCFyGf/i8FRqaZQn/XfiOt6NCnFAGLDeHEWOSuZJ6XcSX67drfxVOk
         Bw2G/CIwqSt3e+mZKOcyRksp9x7xAZZLdwSC4pgClRFR0nUD7UjWYbDkvv6mwR2bJndp
         f4cCPJq9Z5owflyRKRyw4OkJvZgrCsuEt5NVj8S6ZAlxcVVLdcSzQfklZvLQKcneXv2H
         HihfxHoMS14GilknVKjpCiRgEdNGl5KPV0xdAL4yDPQGYzXIvGSzBr73IBZkneuu+ISw
         ZXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vjp8AzbzM7TyaR3koS56Ggcg0U3MN11dnEYbMbimRNs=;
        b=DKexMhDUbL5TmezPFavGnbfS1BMeUg13i0WCEb3fFgkUETnDCf1shPkGOdpuf8pJtk
         tCElgMXeMdyoWb1HGWsoNy+y2WXXRuLS3gVwg9sEYsK06jnI4SaqqeV+i5D/XWnSd5Ek
         mdLI6NVJ1EsKgHJSAo/rkKBInTGF8ddS+vTK9PXFytUuinMAs4LwZocbg4QR4JYoS4Tb
         FCcqF/6bErLVTDuWmS8vQAsSHJTxnm1D+RF8rG//UiqDyYZCbATDP3BEVzb2RwZo5Ttg
         /agCY+ttMGO90xER6YXcGj97r90L2ugWUuW/2udI95t+Eu3K+0rApgX0Q4MW5sPFvo7E
         3E2g==
X-Gm-Message-State: APjAAAWupiXO3u5emd1B/vJWK7+URUASIB3wGM5CZLynMzQeoLHDrqng
        fcs32sL0wTcuTVmeY967U80FZgW7iTI=
X-Google-Smtp-Source: APXvYqwBrqU7vjn1q5xplHNVYtQY4aU+s1Aku7I2GaXZeLJQUiuQ3J90bXbKYbOZh6LYPdZJzet4Ag==
X-Received: by 2002:a37:7a47:: with SMTP id v68mr57356837qkc.56.1560447271399;
        Thu, 13 Jun 2019 10:34:31 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m6sm145004qte.17.2019.06.13.10.34.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 13 Jun 2019 10:34:31 -0700 (PDT)
Date:   Thu, 13 Jun 2019 10:34:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?= 
        <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Message-ID: <20190613103426.76d3789e@cakuba.netronome.com>
In-Reply-To: <CAJ+HfNjp6DJe5xdWxe6pPysXu8D24P4Pp7WcEt4N4EhE1sZNGQ@mail.gmail.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
        <20190612155605.22450-8-maximmi@mellanox.com>
        <20190612132352.7ee27bf3@cakuba.netronome.com>
        <CAJ+HfNjp6DJe5xdWxe6pPysXu8D24P4Pp7WcEt4N4EhE1sZNGQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jun 2019 14:41:30 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> On Wed, 12 Jun 2019 at 22:24, Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
> >
> > On Wed, 12 Jun 2019 15:56:48 +0000, Maxim Mikityanskiy wrote: =20
> > > Currently, libbpf uses the number of combined channels as the maximum
> > > queue number. However, the kernel has a different limitation:
> > >
> > > - xdp_reg_umem_at_qid() allows up to max(RX queues, TX queues).
> > >
> > > - ethtool_set_channels() checks for UMEMs in queues up to
> > >   combined_count + max(rx_count, tx_count).
> > >
> > > libbpf shouldn't limit applications to a lower max queue number. Acco=
unt
> > > for non-combined RX and TX channels when calculating the max queue
> > > number. Use the same formula that is used in ethtool.
> > >
> > > Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> > > Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> > > Acked-by: Saeed Mahameed <saeedm@mellanox.com> =20
> >
> > I don't think this is correct.  max_tx tells you how many TX channels
> > there can be, you can't add that to combined.  Correct calculations is:
> >
> > max_num_chans =3D max(max_combined, max(max_rx, max_tx))
> > =20
>=20
> ...but the inner max should be min, right?
>=20
> Assuming we'd like to receive and send.

That was my knee jerk reaction too, but I think this is only use to
size the array (I could be wrong).  In which case we need an index for
unidirectional socks, too.  Perhaps the helper could be named better if
my understanding is correct :(
