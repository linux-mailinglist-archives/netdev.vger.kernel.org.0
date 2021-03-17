Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA8233ECCC
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCQJQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhCQJQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 05:16:21 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DDAC06175F;
        Wed, 17 Mar 2021 02:16:21 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so4993014wma.0;
        Wed, 17 Mar 2021 02:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EhrLn9K7jXtJeHsVuu3CHu9Mty1Iq5Pz9r00EVn3xTM=;
        b=m14lguIYmfDD2/wElTZCkVUlIyrvdxXMNqpqNCIRogsZB0LhqcDYCfF0u1toycDxbg
         pplUxe8jD5ljRksbVhGzES17Fz8U/uG0s1gzExuiD55nAsB2WnNxV5306mO7YeC/mCiw
         PJDIsRf9o0jfoABfNbM9SDk2+f/iMVta6QsH8CGgcBCezapmDMQNLgLUJDr3nVnq8hlg
         41FTPF/fAcfHtMfPVw/KTtKzDMPDcIL6dip0SnhCeJ9Td3nwY2R1XQEqdUaUdBdLHJJ/
         Ni9JrW1a5mnY+DskyLJ1CxzvZLVOREOGfcttfmroInMycgEbwXut/9t2mqoWaT9DFLIS
         58lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=EhrLn9K7jXtJeHsVuu3CHu9Mty1Iq5Pz9r00EVn3xTM=;
        b=VqO4eKqS7vdmG7kCXeZkPOTnwIC+Spw7ziekfLS9dG4wfJjgiG3hjzZ5/m+Hx867qo
         B8zpqdT8OvHeR3nWXeCB5/4bR57PQxp2X0B2cLj2b3hIPYBIiCDk+PSA9SXeaHiw3sVr
         cWwQnql0hTzYALWsqu9tZsVWcZhJh8ugmp+bffjhkcB8IEBKkTfZ7MCxznHabr1FMrWk
         O8K/NHYXIUnGgxZa5t9TbFLyS7PLB9NaQaUSBtHCYw+hKnxymMDnr4or1rqf10t6H5ET
         l0b1LuNOOy1Yw3CrBnNum5IefMUSro5UiHxCn5Hzx50xcEWzp2lPvVX+USL1wk5RyKDW
         vyhw==
X-Gm-Message-State: AOAM531AtELzGpWOR3kP5bx4mvqOuNCn72AOwYXrH7ym8xBVAFK2+Xo0
        GN7n8jg9ed7PQBFlLhbR7JU=
X-Google-Smtp-Source: ABdhPJw0JYTht3/2AGmcfGV++mZ4Wp8KoFPY6hoSyjq0JXUHNWDqS66ZF/H/hY0jDbIq4baQ8Mz9Mg==
X-Received: by 2002:a7b:c308:: with SMTP id k8mr2683049wmj.54.1615972580103;
        Wed, 17 Mar 2021 02:16:20 -0700 (PDT)
Received: from macbook-pro-alvaro.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id w22sm1049242wmi.22.2021.03.17.02.16.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Mar 2021 02:16:19 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH net-next 1/2] net: dsa: tag_brcm: add support for legacy
 tags
From:   =?utf-8?Q?=C3=81lvaro_Fern=C3=A1ndez_Rojas?= <noltari@gmail.com>
In-Reply-To: <20210315212822.dibkci35efm5kgpy@skbuf>
Date:   Wed, 17 Mar 2021 10:16:16 +0100
Cc:     Jonas Gorski <jonas.gorski@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CDD9C1C6-AC7D-41C8-B2AF-6E84794F8C6B@gmail.com>
References: <20210315142736.7232-1-noltari@gmail.com>
 <20210315142736.7232-2-noltari@gmail.com>
 <20210315212822.dibkci35efm5kgpy@skbuf>
To:     Vladimir Oltean <olteanv@gmail.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> El 15 mar 2021, a las 22:28, Vladimir Oltean <olteanv@gmail.com> =
escribi=C3=B3:
>=20
> On Mon, Mar 15, 2021 at 03:27:35PM +0100, =C3=81lvaro Fern=C3=A1ndez =
Rojas wrote:
>> Add support for legacy Broadcom tags, which are similar to =
DSA_TAG_PROTO_BRCM.
>> These tags are used on BCM5325, BCM5365 and BCM63xx switches.
>>=20
>> Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
>> ---
>> include/net/dsa.h  |  2 +
>> net/dsa/Kconfig    |  7 ++++
>> net/dsa/tag_brcm.c | 96 =
++++++++++++++++++++++++++++++++++++++++++++++
>> 3 files changed, 105 insertions(+)
>>=20
>> diff --git a/include/net/dsa.h b/include/net/dsa.h
>> index 83a933e563fe..dac303edd33d 100644
>> --- a/include/net/dsa.h
>> +++ b/include/net/dsa.h
>> @@ -49,10 +49,12 @@ struct phylink_link_state;
>> #define DSA_TAG_PROTO_XRS700X_VALUE		19
>> #define DSA_TAG_PROTO_OCELOT_8021Q_VALUE	20
>> #define DSA_TAG_PROTO_SEVILLE_VALUE		21
>> +#define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
>>=20
>> enum dsa_tag_protocol {
>> 	DSA_TAG_PROTO_NONE		=3D DSA_TAG_PROTO_NONE_VALUE,
>> 	DSA_TAG_PROTO_BRCM		=3D DSA_TAG_PROTO_BRCM_VALUE,
>> +	DSA_TAG_PROTO_BRCM_LEGACY	=3D =
DSA_TAG_PROTO_BRCM_LEGACY_VALUE,
>=20
> Is there no better qualifier for this tagging protocol name than =
"legacy"?

It=E2=80=99s always referred to as =E2=80=9Clegacy=E2=80=9D, so that=E2=80=
=99s what I used.
Maybe @Florian can suggest a better name for this...

>=20
>> 	DSA_TAG_PROTO_BRCM_PREPEND	=3D =
DSA_TAG_PROTO_BRCM_PREPEND_VALUE,
>> 	DSA_TAG_PROTO_DSA		=3D DSA_TAG_PROTO_DSA_VALUE,
>> 	DSA_TAG_PROTO_EDSA		=3D DSA_TAG_PROTO_EDSA_VALUE,
>> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
>> index 58b8fc82cd3c..aaf8a452fd5b 100644
>> --- a/net/dsa/Kconfig
>> +++ b/net/dsa/Kconfig
>> @@ -48,6 +48,13 @@ config NET_DSA_TAG_BRCM
>> 	  Say Y if you want to enable support for tagging frames for the
>> 	  Broadcom switches which place the tag after the MAC source =
address.
>>=20
>> +config NET_DSA_TAG_BRCM_LEGACY
>> +	tristate "Tag driver for Broadcom legacy switches using in-frame =
headers"
>=20
> Aren't all headers in-frame?

I copied that from NET_DSA_TAG_BRCM:
=
https://github.com/torvalds/linux/blob/1df27313f50a57497c1faeb6a6ae4ca939c=
85a7d/net/dsa/Kconfig#L45

Do you want me to change it to "Tag driver for Broadcom legacy =
switches=E2=80=9D or  =E2=80=9CLegacy tag driver for Broadcom switches"?

>=20
>> +	select NET_DSA_TAG_BRCM_COMMON
>> +	help
>> +	  Say Y if you want to enable support for tagging frames for the
>> +	  Broadcom legacy switches which place the tag after the MAC =
source
>> +	  address.
>>=20
>> config NET_DSA_TAG_BRCM_PREPEND
>> 	tristate "Tag driver for Broadcom switches using prepended =
headers"
>> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
>> index e2577a7dcbca..9dbff771c9b3 100644
>> --- a/net/dsa/tag_brcm.c
>> +++ b/net/dsa/tag_brcm.c
>> @@ -9,9 +9,23 @@
>> #include <linux/etherdevice.h>
>> #include <linux/list.h>
>> #include <linux/slab.h>
>> +#include <linux/types.h>
>>=20
>> #include "dsa_priv.h"
>>=20
>> +struct bcm_legacy_tag {
>> +	uint16_t type;
>> +#define BRCM_LEG_TYPE	0x8874
>> +
>> +	uint32_t tag;
>> +#define BRCM_LEG_TAG_PORT_ID	(0xf)
>> +#define BRCM_LEG_TAG_MULTICAST	(1 << 29)
>> +#define BRCM_LEG_TAG_EGRESS	(2 << 29)
>> +#define BRCM_LEG_TAG_INGRESS	(3 << 29)
>> +} __attribute__((packed));
>> +
>> +#define BRCM_LEG_TAG_LEN	sizeof(struct bcm_legacy_tag)
>> +
>=20
> As Florian pointed out, tagging protocol parsing should be
> endian-independent, and mapping a struct over the frame header is =
pretty
> much not that.

Ok, I will change that in v2.

>=20
>> /* This tag length is 4 bytes, older ones were 6 bytes, we do not
>>  * handle them
>>  */
>> @@ -195,6 +209,85 @@ DSA_TAG_DRIVER(brcm_netdev_ops);
>> MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM);
>> #endif
>>=20
>> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_LEGACY)
>> +static struct sk_buff *brcm_leg_tag_xmit(struct sk_buff *skb,
>> +					 struct net_device *dev)
>> +{
>> +	struct dsa_port *dp =3D dsa_slave_to_port(dev);
>> +	struct bcm_legacy_tag *brcm_tag;
>> +
>> +	if (skb_cow_head(skb, BRCM_LEG_TAG_LEN) < 0)
>> +		return NULL;
>=20
> This is not needed since commit 2f0d030c5ffe ("net: dsa: tag_brcm: let
> DSA core deal with TX reallocation").

I=E2=80=99m testing this on v5.10 and I forgot to remove it, sorry :$.

>=20
>> +	/* The Ethernet switch we are interfaced with needs packets to =
be at
>> +	 * least 64 bytes (including FCS) otherwise they will be =
discarded when
>> +	 * they enter the switch port logic. When Broadcom tags are =
enabled, we
>> +	 * need to make sure that packets are at least 70 bytes
>> +	 * (including FCS and tag) because the length verification is =
done after
>> +	 * the Broadcom tag is stripped off the ingress packet.
>> +	 *
>> +	 * Let dsa_slave_xmit() free the SKB
>> +	 */
>> +	if (__skb_put_padto(skb, ETH_ZLEN + BRCM_LEG_TAG_LEN, false))
>> +		return NULL;
>=20
> Are you sure the switches you're working on need this, or is it just
> another copy-pasta?

Yes, I need that.

>=20
>> +	skb_push(skb, BRCM_LEG_TAG_LEN);
>> +
>> +	memmove(skb->data, skb->data + BRCM_LEG_TAG_LEN, 2 * ETH_ALEN);
>> +
>> +	brcm_tag =3D (struct bcm_legacy_tag *) (skb->data + 2 * =
ETH_ALEN);
>> +
>> +	brcm_tag->type =3D BRCM_LEG_TYPE;
>> +	brcm_tag->tag =3D BRCM_LEG_TAG_EGRESS;
>> +	brcm_tag->tag |=3D dp->index & BRCM_LEG_TAG_PORT_ID;
>> +
>> +	return skb;
>> +}
>> +
>> +
>=20
> Please remove the extra newline.

Ok.

>=20
>> +static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
>> +					struct net_device *dev,
>> +					struct packet_type *pt)
>> +{
>> +	int source_port;
>> +	struct bcm_legacy_tag *brcm_tag;
>=20
> Please declare the local variables in the order of decreasing line =
length.

Ok.

>=20
>> +
>> +	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_TAG_LEN)))
>> +		return NULL;
>> +
>> +	brcm_tag =3D (struct bcm_legacy_tag *) (skb->data - 2);
>=20
> Nitpick: the space between the *) and the (skb-> is not needed.

Ok, but this is going to disappear when I remove the struct usage.

>=20
>> +
>> +	source_port =3D brcm_tag->tag & BRCM_LEG_TAG_PORT_ID;
>> +
>> +	skb->dev =3D dsa_master_find_slave(dev, 0, source_port);
>> +	if (!skb->dev)
>> +		return NULL;
>> +
>> +	/* Remove Broadcom tag and update checksum */
>> +	skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
>> +
>> +	skb->offload_fwd_mark =3D 1;
>> +
>> +	/* Move the Ethernet DA and SA */
>> +	memmove(skb->data - ETH_HLEN,
>> +		skb->data - ETH_HLEN - BRCM_LEG_TAG_LEN,
>> +		2 * ETH_ALEN);
>> +
>> +	return skb;
>> +}
>> +
>> +static const struct dsa_device_ops brcm_legacy_netdev_ops =3D {
>> +	.name	=3D "brcm-legacy",
>> +	.proto	=3D DSA_TAG_PROTO_BRCM_LEGACY,
>> +	.xmit	=3D brcm_leg_tag_xmit,
>> +	.rcv	=3D brcm_leg_tag_rcv,
>> +	.overhead =3D BRCM_LEG_TAG_LEN,
>> +};
>> +
>> +DSA_TAG_DRIVER(brcm_legacy_netdev_ops);
>> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_LEGACY);
>> +#endif /* CONFIG_NET_DSA_TAG_BRCM_LEGACY */
>> +
>> #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
>> static struct sk_buff *brcm_tag_xmit_prepend(struct sk_buff *skb,
>> 					     struct net_device *dev)
>> @@ -227,6 +320,9 @@ static struct dsa_tag_driver =
*dsa_tag_driver_array[] =3D	{
>> #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
>> 	&DSA_TAG_DRIVER_NAME(brcm_netdev_ops),
>> #endif
>> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_LEGACY)
>> +	&DSA_TAG_DRIVER_NAME(brcm_legacy_netdev_ops),
>> +#endif
>> #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_PREPEND)
>> 	&DSA_TAG_DRIVER_NAME(brcm_prepend_netdev_ops),
>> #endif
>> --=20
>> 2.20.1

Best regards,
=C3=81lvaro.

