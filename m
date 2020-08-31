Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7F94257843
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 13:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgHaLZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 07:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgHaLXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 07:23:24 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DA3C0619C5;
        Mon, 31 Aug 2020 04:12:18 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id o5so1622411wrn.13;
        Mon, 31 Aug 2020 04:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ly9kPFyj9YNDeKk+0uTjrZOCOJaE477kg5kn2ZpduOg=;
        b=F8wFm3EHMTa7z1LA2yUnSoJxnaM10+3TE1pOl9HB2vkb1aF8BLUVPu5n4V2IwFdx2N
         aHafKkvV2ENrsXuHRWCy9ny3EsSKrCVoR2nZgsZqy0qA6HmzlRmUKL15DAJ7G9XMUQPe
         B5OCA5ZjgmURjHFpMdKQ+MI/RmeDKazZ2YD9ljOGMXsvjni4lcX3+KqU2nabs5uNYyJq
         eKIjugxPVyPmAgCSSwh4/dP06bJ9ZD6VS1rzUxAVf/kdSiV3QgwyazrPn/SH4PjtvK7Y
         9PDQYG1aQHRVPCc/CGiNmiQaAGYk8pYY+viq0Imk/nT34HRn7uWSMaTpdfUlOLPgwsNb
         G17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ly9kPFyj9YNDeKk+0uTjrZOCOJaE477kg5kn2ZpduOg=;
        b=USNSxy9j9FNE4kBLovZIUfkY1DRf5KN9UNrxZblIui0AkEB6DAJLoR5LvGItdrOK5M
         XNP1DaUZxeZlUB+dpf2lNcrQppMtVmCLaKuw6Ir/vcJe4dCA2liYmrxJU01XdbE4Wqs7
         +fk4mdiNxlJcuJfsrgTx1Lbz6DCsukoYwoijs6wzjPiRYJsbnvkE1sIV0b7nvDYn687T
         za70wUJw7msLwrVQehXjLtqYTzbQ5M1wxjp+dzIkbZ0k+APoN4htjUfjWEmksYI1WmIJ
         aqaLMO3EjEHoMIe6Czo1aDu9HrJtDAwSCY1F4S1PZTHhcHm8y/L62u2vgC9pcIomUE0b
         tf6w==
X-Gm-Message-State: AOAM530iZLTXOAcD/ZS4gp/BNA7uuILWAmpghNXzXgP8F86y1VWrQW1x
        EvoRVlG58eM9AH4wqcIRZoTrTaJukm+ay8MSmmo=
X-Google-Smtp-Source: ABdhPJztN8XblvLiXaoKB/e2BP4/4ahDgy54IYTZjfGdtjbwLXRRN0uCpoIyFPF7g/8dUJ7Ocyb8ZDXcArHKP5kNQeo=
X-Received: by 2002:adf:e7d2:: with SMTP id e18mr1161685wrn.248.1598872326574;
 Mon, 31 Aug 2020 04:12:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200828161717.42705-1-weqaar.a.janjua@intel.com>
In-Reply-To: <20200828161717.42705-1-weqaar.a.janjua@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 31 Aug 2020 13:11:55 +0200
Message-ID: <CAJ+HfNhwu+r4fFpsDVOEaGyub-yD-R4uh5kQa-_dPHF_prWXPA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] samples/bpf: fix to xdpsock to avoid recycling frames
To:     Weqaar Janjua <weqaar.a.janjua@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Aug 2020 at 18:18, Weqaar Janjua <weqaar.a.janjua@intel.com> wro=
te:
>
> The txpush program in the xdpsock sample application is supposed
> to send out all packets in the umem in a round-robin fashion.
> The problem is that it only cycled through the first BATCH_SIZE
> worth of packets. Fixed this so that it cycles through all buffers
> in the umem as intended.
>
> Fixes: 248c7f9c0e21 ("samples/bpf: convert xdpsock to use libbpf for AF_X=
DP access")
> Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>

Thanks Weqaar!

Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

> ---
>  samples/bpf/xdpsock_user.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 19c679456a0e..c821e9867139 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -1004,7 +1004,7 @@ static void rx_drop_all(void)
>         }
>  }
>
> -static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb, int batch=
_size)
> +static void tx_only(struct xsk_socket_info *xsk, u32 *frame_nb, int batc=
h_size)
>  {
>         u32 idx;
>         unsigned int i;
> @@ -1017,14 +1017,14 @@ static void tx_only(struct xsk_socket_info *xsk, =
u32 frame_nb, int batch_size)
>         for (i =3D 0; i < batch_size; i++) {
>                 struct xdp_desc *tx_desc =3D xsk_ring_prod__tx_desc(&xsk-=
>tx,
>                                                                   idx + i=
);
> -               tx_desc->addr =3D (frame_nb + i) << XSK_UMEM__DEFAULT_FRA=
ME_SHIFT;
> +               tx_desc->addr =3D (*frame_nb + i) << XSK_UMEM__DEFAULT_FR=
AME_SHIFT;
>                 tx_desc->len =3D PKT_SIZE;
>         }
>
>         xsk_ring_prod__submit(&xsk->tx, batch_size);
>         xsk->outstanding_tx +=3D batch_size;
> -       frame_nb +=3D batch_size;
> -       frame_nb %=3D NUM_FRAMES;
> +       *frame_nb +=3D batch_size;
> +       *frame_nb %=3D NUM_FRAMES;
>         complete_tx_only(xsk, batch_size);
>  }
>
> @@ -1080,7 +1080,7 @@ static void tx_only_all(void)
>                 }
>
>                 for (i =3D 0; i < num_socks; i++)
> -                       tx_only(xsks[i], frame_nb[i], batch_size);
> +                       tx_only(xsks[i], &frame_nb[i], batch_size);
>
>                 pkt_cnt +=3D batch_size;
>
> --
> 2.20.1
>
> --------------------------------------------------------------
> Intel Research and Development Ireland Limited
> Registered in Ireland
> Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
> Registered Number: 308263
>
>
> This e-mail and any attachments may contain confidential material for the=
 sole
> use of the intended recipient(s). Any review or distribution by others is
> strictly prohibited. If you are not the intended recipient, please contac=
t the
> sender and delete all copies.
>
