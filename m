Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5426A3165D0
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 12:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhBJL7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 06:59:23 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:15483 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbhBJL5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 06:57:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612958220; x=1644494220;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/nFWYpgDz2q9AGtCu9C5FQC0uPo0Ps2PgxNOaxfDfHQ=;
  b=GtGGnAIrfXusPUVPkdfeRIocr4pjCk+FgMB2n86McT2GMATjRKaodwfP
   bl7+uht6iRTvWRp25iljhU/W5HXQ5i4+wp1+vQtMI2/bkAB29GXN0gbK+
   8ZuVNZ4q/ZNhzDn982xgxWLI4lQH6H6qR/yYXGfc6oUteNzFsTGKgTwD7
   HywAeu8c6u5meGEh+1iuca7dfMZ0NNWxQOi3qGNSs69Pmn9dKpaBC78qs
   kChDHml/Uk484XZigTE6HBQZDX1IOn+AOf4j+gdhvC5/ENO7LaSIXUGDk
   m+ktlk2fqK/8YNnJzFBymL/RGD2Eak+AlqL/kWPGU303ZprFX05Q1pdtF
   Q==;
IronPort-SDR: xuR3FBea+DUDsOXUbIO+BYMXs1/9OOJi7SiDQoLABp1sn1qXUl3KwBHwB3vifdO1SKWaCVqglG
 sZxlQCN92sLzG15kPlfWnzB0JpAn+JeiLf/EcptpRW/DeoWpxjOllDTBZnrVi9fwJwz1qM7x8g
 MLhxw4pFLux6jd6TG+bPyakpYaBegjN/TNqFLJx6ycuXck/BExk1+c3LdjSfqjwAjA7u+gDeWd
 przWGaZXxz+ZDsvFL9ONdbewW4BVd3ChgrF8KxysFphUR7aLCy4KCn6RqbLtLrTdsKcvhn7XYw
 ee8=
X-IronPort-AV: E=Sophos;i="5.81,168,1610434800"; 
   d="scan'208";a="109199456"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Feb 2021 04:55:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 10 Feb 2021 04:55:45 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 10 Feb 2021 04:55:40 -0700
Message-ID: <fc0549661e10c28d6344be74eb8b29336c1ebdf5.camel@microchip.com>
Subject: Re: [PATCH net-next 2/8] net: dsa: tag_ksz: add tag handling for
 Microchip LAN937x
From:   Prasanna Vengateshan Varadharajan 
        <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Date:   Wed, 10 Feb 2021 17:25:38 +0530
In-Reply-To: <20210130022709.ai5kq7w52gpqrb4n@skbuf>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
         <20210128064112.372883-3-prasanna.vengateshan@microchip.com>
         <20210130022709.ai5kq7w52gpqrb4n@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-01-30 at 04:27 +0200, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> On Thu, Jan 28, 2021 at 12:11:06PM +0530, Prasanna Vengateshan wrote:
> > diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
> > index 4820dbcedfa2..6fac39c2b7d5 100644
> > --- a/net/dsa/tag_ksz.c
> > +++ b/net/dsa/tag_ksz.c
> > @@ -190,10 +190,84 @@ static const struct dsa_device_ops
> > ksz9893_netdev_ops = {
> >  DSA_TAG_DRIVER(ksz9893_netdev_ops);
> >  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_KSZ9893);
> > 
> > +/* For Ingress (Host -> LAN937x), 2 bytes are added before FCS.
> > + * -------------------------------------------------------------
> > --------------
> > + *
> > DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|tag1(1byte)|FCS
> > (4bytes)
> > + * -------------------------------------------------------------
> > --------------
> > + * tag0 : represents tag override, lookup and valid
> > + * tag1 : each bit represents port (eg, 0x01=port1, 0x02=port2,
> > 0x80=port8)
> > + *
> > + * For Egress (LAN937x -> Host), 1 byte is added before FCS.
> > + * -------------------------------------------------------------
> > --------------
> > + * DA(6bytes)|SA(6bytes)|....|Data(nbytes)|tag0(1byte)|FCS(4bytes)
> > + * -------------------------------------------------------------
> > --------------
> > + * tag0 : zero-based value represents port
> > + *     (eg, 0x00=port1, 0x02=port3, 0x07=port8)
> > + */
> 
> You messed up the comment, right now it's as good as not having it.
> The one-hot port encoding is for xmit. The zero-based encoding is for
> rcv, not the other way around.
I understand the problem is with the term Egress & Ingress w.r.to
LAN937x. I will make sure that the comment is added w.r.to xmit() &
rcv().

> 
> > +#define LAN937X_INGRESS_TAG_LEN              2
> > +
> > +#define LAN937X_TAIL_TAG_OVERRIDE    BIT(11)
> > +#define LAN937X_TAIL_TAG_LOOKUP              BIT(12)
> > +#define LAN937X_TAIL_TAG_VALID               BIT(13)
> > +#define LAN937X_TAIL_TAG_PORT_MASK   7
> > +
> > +static struct sk_buff *lan937x_xmit(struct sk_buff *skb,
> > +                                 struct net_device *dev)
> > +{
> > +     struct dsa_port *dp = dsa_slave_to_port(dev);
> > +     __be16 *tag;
> > +     u8 *addr;
> > +     u16 val;
> > +
> > +     /* Tag encoding */
> 
> Do we really need this comment and the one with "Tag decoding" from
> rcv?
Okay, will correct it.

> 
> > +     tag = skb_put(skb, LAN937X_INGRESS_TAG_LEN);
> > +     addr = skb_mac_header(skb);
> > +
> > +     val = BIT(dp->index);
> > +
> > +     if (is_link_local_ether_addr(addr))
> > +             val |= LAN937X_TAIL_TAG_OVERRIDE;
> > +
> > +     /* Tail tag valid bit - This bit should always be set by the
> > CPU*/
> > +     val |= LAN937X_TAIL_TAG_VALID;
> > +
> > +     *tag = cpu_to_be16(val);
> > +
> > +     return skb;
> > +}
> > +
> > +static struct sk_buff *lan937x_rcv(struct sk_buff *skb, struct
> > net_device *dev,
> > +                                struct packet_type *pt)
> 
> You can reuse ksz9477_rcv.
Sure, will reuse ksz9477_rcv. 

> 
> > +{
> > +     /* Tag decoding */
> > +     u8 *tag = skb_tail_pointer(skb) - KSZ_EGRESS_TAG_LEN;
> > +     unsigned int port = tag[0] & LAN937X_TAIL_TAG_PORT_MASK;
> > +     unsigned int len = KSZ_EGRESS_TAG_LEN;
> > +
> > +     /* Extra 4-bytes PTP timestamp */
> > +     if (tag[0] & KSZ9477_PTP_TAG_INDICATION)
> > +             len += KSZ9477_PTP_TAG_LEN;
> > +
> > +     return ksz_common_rcv(skb, dev, port, len);
> > +}
> > +
> > +static const struct dsa_device_ops lan937x_netdev_ops = {
> > +     .name   = "lan937x",
> > +     .proto  = DSA_TAG_PROTO_LAN937X,
> > +     .xmit   = lan937x_xmit,
> > +     .rcv    = lan937x_rcv,
> > +     .overhead = LAN937X_INGRESS_TAG_LEN,
> > +     .tail_tag = true,
> > +};
> > +
> > +DSA_TAG_DRIVER(lan937x_netdev_ops);
> > +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_LAN937X);
> > +
> >  static struct dsa_tag_driver *dsa_tag_driver_array[] = {
> >       &DSA_TAG_DRIVER_NAME(ksz8795_netdev_ops),
> >       &DSA_TAG_DRIVER_NAME(ksz9477_netdev_ops),
> >       &DSA_TAG_DRIVER_NAME(ksz9893_netdev_ops),
> > +     &DSA_TAG_DRIVER_NAME(lan937x_netdev_ops),
> >  };
> > 
> >  module_dsa_tag_drivers(dsa_tag_driver_array);
> > --
> > 2.25.1
> > 

