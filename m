Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327A0275309
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 10:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbgIWIO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 04:14:56 -0400
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:4737
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726332AbgIWIO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 04:14:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChlR2HokP1OSHtRgB9LvpWN8ejl6Z7rOq+VOFmsHmjGa2FkLM1PNm9Ub59X9kPEhVJnt/4/Jmhg5EZXEPQkVTlRB7Rbk8gctEiuHcg1q5s/znU78WjvA/GESprCfSAf4ROTm4+ef36AeK4IwB4VPQWkzVT8WnuL8gzDiUBsX7XfL1vERnKLQBM1HPonUXu5XMpuY3zatH17qY47+848qRHBbibNdKziQoVAsprhovsz/VHWC42vCf2wHJbkTQTPkpyFYoBr39O5qCrtDV4F5kR7HIfBJJ/bAaCBr2NwsyZwRpOtz4fYVWSsyI/Jck0HIr5sqjLdKW6I2VdxJaujTRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAZLN0lINzpkcuaEVG2Ae3K4V3KkAVhGlSKtBSRRPqI=;
 b=PFYPvTEoes/iFpRHlxluaJ2uxudQ2Um3ALgmfk1a9AjMdho2yXWxXxUrUuRMvSWna2cpqL0BH/f/rqgVQsqDvIxi0QvAFks/NJLAu8cX9SXo13ZyMcyqvy2o6F4vtmYfAnC0O0onE3tQSZatVV9C3uoQ3F617d3N6QIZC3AAqVHTmJj4+LLyPigTmLiujZzxLrZMa7K9WlkbJ0VeO86FAJhF+oLwA4w7+fz0NwF6iOTWaalj+aBzt1NqA58RvaFyyx6z+aslygxnfFE92OevrWSPa3nomNHgCPeraqBEe8MhPha9fC1/DN8tnSJIceZDtWHtrqdNuxFQi+UPXYUvFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAZLN0lINzpkcuaEVG2Ae3K4V3KkAVhGlSKtBSRRPqI=;
 b=YnKKNqhjMzLuT0JpMrTFAldCHhNVG//kedfdj9m5CR9NkEh6TAPxEtWGl3BQRrbH6RzOWZbdfzaB2MoDmSa387BY5sAMPQQcCD/2R0zfPoIwWVRmmtv7CgLcVHsqmjum0P110LMP84XGne9DmkoTIYTsTFWcZ0uZqxV5WUcwCug=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6701.eurprd04.prod.outlook.com (2603:10a6:803:124::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 23 Sep
 2020 08:14:51 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 08:14:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
Subject: Re: [PATCH net-next 1/2] net: dsa: untag the bridge pvid from rx skbs
Thread-Topic: [PATCH net-next 1/2] net: dsa: untag the bridge pvid from rx
 skbs
Thread-Index: AQHWkVdQ8QBtwDGDZECVVPbKJwPzZ6l14IgA
Date:   Wed, 23 Sep 2020 08:14:51 +0000
Message-ID: <20200923081450.2ghr6am4vjci6cd4@skbuf>
References: <20200923031155.2832348-1-f.fainelli@gmail.com>
 <20200923031155.2832348-2-f.fainelli@gmail.com>
In-Reply-To: <20200923031155.2832348-2-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3b609197-1c7c-422c-d483-08d85f98bf0f
x-ms-traffictypediagnostic: VE1PR04MB6701:
x-microsoft-antispam-prvs: <VE1PR04MB6701144803B682D2B48FFBCBE0380@VE1PR04MB6701.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZJT6mlITOcNLSJNVJxzhSquDrx3C2XQKoib7YA59+D5DpPERoTkCS1JqhickKlHnyECuM17LxiF8vGy0XZKD5zfgRCUpKIudeL/XX/mtemfInlXtpZm3ltwk/bgzLuRaEIbnymhJ4gJTjzyjLA55RjEbBkV2+XaPas4pKEw7JAZcsOiwrNMNvLyJWF4NwfIycMPL4THWcEV8GM24KsQXEX6Fy8ZqPLimJhBaGN8jpZqTDTQEHb47jpX3XqrLHvLbeXnyOEErXGLfwSfYHQPui4EbPvG35+6iJDNcOHP4VAEKa8FNvP/a1qB8UHTAIz5KiwN9E3BUBetzm38/2qabwSMpknJkfz3lsx2Deh0HbL58xCWtBvcyqr0arEek0mZn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(39860400002)(396003)(346002)(376002)(366004)(9686003)(33716001)(6916009)(54906003)(44832011)(186003)(8676002)(5660300002)(8936002)(478600001)(6512007)(71200400001)(86362001)(6506007)(316002)(66556008)(66446008)(2906002)(66946007)(91956017)(76116006)(64756008)(1076003)(83380400001)(26005)(66476007)(6486002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 542bPJHEKk9KXQjd0klOQbLHaTNrKUnraCwypou8ERzG8OXLjXAE2Cl2nPMgleJHKqg7lHhI4EJrqM6GA2mcLBzAjFXLsNnrUt4KoZLWlnhi67/O5IsAMGwc3QmhSlTzjx+nOEvCkMHpHgrFD3R3wZrgxRJqnTW4sWhsCg/taFGYSgBuu2dTs52TqDzRdXXKw0HMuBfAIBezBATsP/8tCAV6XAhne/il1MHZJhOHKRgSlGbL0j0y2lUwmZrvWvpBjQz+I7Hl/K/oJRxY/x/+iPKSeM/m67pHUNIdYxYkGfTR+FSFordeNUdPtur9KGYZOpmdSWPsaPfviBhaF+gMCr/Uo5V8Au1kt8vp4jm4nQF4tn4Nd5g53p8yR40eba9Jy39OH1m6PzbHPaTEopU6WRXSKGRkpbXooclVFoFeaXzHmHpJVaTj9JGC2Go06VYPGDlmX/q3gyZqMVybWP7f0y3g66rVA8D2fti9es1J0qZgIZ0GrsjxOf+k7/j/6ao8I7G2phewMn+bgw12MuXp42U3XbFnGrqQfqwMer38c4HKN3S7Ow/2Oc+9hZUkDinvtLreKU8PbmqUPyeg+eyc/h0FHl8otkIfMjoZSKSTBfWKSLtwVob7ibjlLbNNUCwiwuTBGCgeHDsgxTHINWdLlA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <514A92A2362A2C42A8A648BC225AAA14@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b609197-1c7c-422c-d483-08d85f98bf0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 08:14:51.7229
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xCNeR52+3qGbrL/Zn6h5BIKYZSxEsLCAxi2CFREX//tILwpOWPfafoCfe7QhJbmSC8zU7Ianweo7NpxNtVXhIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 08:11:54PM -0700, Florian Fainelli wrote:
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index d16057c5987a..b539241a7533 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -301,6 +301,14 @@ struct dsa_switch {
>  	 */
>  	bool			configure_vlan_while_not_filtering;
> =20
> +	/* If the switch driver always programs the CPU port as egress tagged
> +	 * despite the VLAN configuration indicating otherwise, then setting
> +	 * @untag_bridge_pvid will force the DSA receive path to pop the bridge=
's
> +	 * default_pvid VLAN tagged frames to offer a consistent behavior
> +	 * between a vlan_filtering=3D0 and vlan_filtering=3D1 bridge device.
> +	 */
> +	bool			untag_bridge_pvid;
> +
>  	/* In case vlan_filtering_is_global is set, the VLAN awareness state
>  	 * should be retrieved from here and not from the per-port settings.
>  	 */
> diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
> index 5c18c0214aac..dec4ab59b7c4 100644
> --- a/net/dsa/dsa.c
> +++ b/net/dsa/dsa.c
> @@ -225,6 +225,15 @@ static int dsa_switch_rcv(struct sk_buff *skb, struc=
t net_device *dev,
>  	skb->pkt_type =3D PACKET_HOST;
>  	skb->protocol =3D eth_type_trans(skb, skb->dev);
> =20
> +	if (unlikely(cpu_dp->ds->untag_bridge_pvid)) {
> +		nskb =3D dsa_untag_bridge_pvid(skb);
> +		if (!nskb) {
> +			kfree_skb(skb);
> +			return 0;
> +		}
> +		skb =3D nskb;
> +	}
> +
>  	s =3D this_cpu_ptr(p->stats64);
>  	u64_stats_update_begin(&s->syncp);
>  	s->rx_packets++;

I was thinking a lot simpler. Maybe you could just tail-call
dsa_untag_bridge_pvid(skb) at the end of your .rcv function instead of
putting it in the common receive path. I specifically wrote it to look
at hdr->h_vlan_proto instead of skb->protocol, so it wouldn't depend on
eth_type_trans().

Something like:

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 9c6c30649d13..118d253af5a7 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -192,7 +192,7 @@ static struct sk_buff *brcm_tag_rcv(struct sk_buff *skb=
, struct net_device *dev,
 		nskb->data - ETH_HLEN - BRCM_TAG_LEN,
 		2 * ETH_ALEN);
=20
-	return nskb;
+	return dsa_untag_bridge_pvid(nskb);
 }
=20
 static const struct dsa_device_ops brcm_netdev_ops =3D {
@@ -220,8 +220,14 @@ static struct sk_buff *brcm_tag_rcv_prepend(struct sk_=
buff *skb,
 					    struct net_device *dev,
 					    struct packet_type *pt)
 {
+	struct sk_buff *nskb;
+
 	/* tag is prepended to the packet */
-	return brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
+	nskb =3D brcm_tag_rcv_ll(skb, dev, pt, ETH_HLEN);
+	if (!nskb)
+		return nskb;
+
+	return dsa_untag_bridge_pvid(nskb);
 }
=20
 static const struct dsa_device_ops brcm_prepend_netdev_ops =3D {

Thanks,
-Vladimir=
