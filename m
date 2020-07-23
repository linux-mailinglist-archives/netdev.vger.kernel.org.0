Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4A922B0C7
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 15:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727940AbgGWNvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 09:51:41 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:45763 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgGWNvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 09:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595512300; x=1627048300;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=OZxAbUgwhFmbexC3IUgXHl1BNIxOTNlQLnSYWiurDlE=;
  b=YvDNJTJjdscqGFlAPDMXyDWwl2vrheCh5w09g/8S0w8NDcuVeQijNVj+
   hspGMYZ1gdQAfj8gdgCiLBXtFHf4BiANWJOqefSHFIJd5c/5DIbXZgKaA
   C0v6T2QOMNcPp529rSqIs6pI/FNSmjFSlV0lPdloQpjAQZTnMJCX8fmV1
   4=;
IronPort-SDR: gn/Od77Z+pPd2LfKwnGrREl5yLZislWPRo+ihg7xEP5t91AZYVgfVu4qVcbvksifp8v+XWSsXk
 GiMqUpCzckWw==
X-IronPort-AV: E=Sophos;i="5.75,386,1589241600"; 
   d="scan'208";a="43685292"
Subject: RE: [RFC net-next 01/22] xdp: introduce mb in xdp_buff/xdp_frame
Thread-Topic: [RFC net-next 01/22] xdp: introduce mb in xdp_buff/xdp_frame
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Jul 2020 13:51:39 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan3.iad.amazon.com [10.40.159.166])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id 8213EA03E5;
        Thu, 23 Jul 2020 13:51:36 +0000 (UTC)
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Jul 2020 13:51:35 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D11EUB003.ant.amazon.com (10.43.166.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 23 Jul 2020 13:51:34 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1497.006;
 Thu, 23 Jul 2020 13:51:34 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "lorenzo.bianconi@redhat.com" <lorenzo.bianconi@redhat.com>,
        "echaudro@redhat.com" <echaudro@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Thread-Index: AQHWYOZ1EY8s1ze5oEqOnEcaayrjwqkVLh2w
Date:   Thu, 23 Jul 2020 13:51:06 +0000
Deferred-Delivery: Thu, 23 Jul 2020 13:50:28 +0000
Message-ID: <31fe5dced5d6423b92914c8c6dae7bc3@EX13D11EUB003.ant.amazon.com>
References: <cover.1595503780.git.lorenzo@kernel.org>
 <1d3c0f39d41fd8268523c190c36fa7934d3b2e01.1595503780.git.lorenzo@kernel.org>
In-Reply-To: <1d3c0f39d41fd8268523c190c36fa7934d3b2e01.1595503780.git.lorenzo@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.155]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> Sent: Thursday, July 23, 2020 2:42 PM
> To: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org; davem@davemloft.net; ast@kernel.org;
> brouer@redhat.com; daniel@iogearbox.net; lorenzo.bianconi@redhat.com;
> echaudro@redhat.com; Jubran, Samih <sameehj@amazon.com>;
> kuba@kernel.org
> Subject: [EXTERNAL] [RFC net-next 01/22] xdp: introduce mb in
> xdp_buff/xdp_frame
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> Introduce multi-buffer bit (mb) in xdp_frame/xdp_buffer to specify if
> shared_info area has been properly initialized for non-linear xdp buffers
>=20
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/xdp.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/net/xdp.h b/include/net/xdp.h index
> dbe9c60797e1..2ef6935c5646 100644
> --- a/include/net/xdp.h
> +++ b/include/net/xdp.h
> @@ -72,7 +72,8 @@ struct xdp_buff {
>         void *data_hard_start;
>         struct xdp_rxq_info *rxq;
>         struct xdp_txq_info *txq;
> -       u32 frame_sz; /* frame size to deduce data_hard_end/reserved
> tailroom*/
> +       u32 frame_sz:31; /* frame size to deduce data_hard_end/reserved
> tailroom*/
It seems strange that you assign a 32 sized field to a 24 sized field.
Wouldn't it be better if we used the same size in all places?
> +       u32 mb:1; /* xdp non-linear buffer */
>  };
>=20
>  /* Reserve memory area at end-of data area.
> @@ -96,7 +97,8 @@ struct xdp_frame {
>         u16 len;
>         u16 headroom;
>         u32 metasize:8;
> -       u32 frame_sz:24;
> +       u32 frame_sz:23;
> +       u32 mb:1; /* xdp non-linear frame */
>         /* Lifetime of xdp_rxq_info is limited to NAPI/enqueue time,
>          * while mem info is valid on remote CPU.
>          */
> @@ -141,6 +143,7 @@ void xdp_convert_frame_to_buff(struct xdp_frame
> *frame, struct xdp_buff *xdp)
>         xdp->data_end =3D frame->data + frame->len;
>         xdp->data_meta =3D frame->data - frame->metasize;
>         xdp->frame_sz =3D frame->frame_sz;
> +       xdp->mb =3D frame->mb;
>  }
>=20
>  static inline
> @@ -167,6 +170,7 @@ int xdp_update_frame_from_buff(struct xdp_buff
> *xdp,
>         xdp_frame->headroom =3D headroom - sizeof(*xdp_frame);
>         xdp_frame->metasize =3D metasize;
>         xdp_frame->frame_sz =3D xdp->frame_sz;
> +       xdp_frame->mb =3D xdp->mb;
>=20
>         return 0;
>  }
> --
> 2.26.2

