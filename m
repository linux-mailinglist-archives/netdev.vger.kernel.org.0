Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5CF280F12
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbgJBIj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:39:29 -0400
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:7808
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbgJBIj2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 04:39:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DRbp0XOoqkrChJBLIkAiPFVlcsyDksV/rYF7PTQfcdbqDurH/x+sRLJif5QNrx0M6uAebfmtdZospUgpJY/NGgcMX+Q6AN3JxQrkzNltol9UKhQ+7UhxK3Kcd/6TAmXmQ52eVWFHGKMBU1Y95D95gW5g7o3CgxS569L473RUoJj7uWcJpA2558Tmb4WJekkyf5lXjIszhwYv4i6SXkJw0fUUlwrXo1fWtoBtJ40sPvPaLjQXzEmt70nMolGh0brhNQQINFIMTGA0e7VznBueUYjy6KjrOzJAMFc2/Z/hWmdoQsqmvlquyK5nR7mDrP9JFth1e6BeN3/B+XlV6oPLFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ra5xQJkCOMVZZPqKHXgFIM44LkATJUmGTDrN37q6co=;
 b=VXm2s/PusW46R5G7htgFrgc3I2hiQrgrKUM0lYRqhptiQksuEs5ZPu3gA/gIulquUzc0Rbz+THE6Or1eCfFd3mSPawUFhd3xl/LNyIsLszz9urJyzqISBwbdRJsh8pk3ABDTg2FjqQhJsgRpuyoXb2E0la698sCHQtsIA7XwgJ63FpYuOdw8p/4XFSGWHBZPi9v8sFt6rC+QIttRuN4qcENL4UpQOAgeQ3CZ+gaF9R2gy4klPd6hLdar6Zr7j9J6o1GnJjy6MASa6ZzZr2rpEOkEuBrjMJNjd9v3lta7SmbxfbBKxYBzIzE1qfnShmkQnntl839dlm5iwZGLXR99DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ra5xQJkCOMVZZPqKHXgFIM44LkATJUmGTDrN37q6co=;
 b=nuyRHvpnYyQRzAOAN5x/nwIUYKTmMJajvmZXBg9T9MsavI/IVBCPX/KETicY8OKwZXl9+HA10955+Veksrv/fjmIvlFFvqGO0o3+Sa1ACEUC/ZRO1AaSWZukS2cRfxzA+NKrk8Ou+2mCjijEkkpyLL6QP8jfVRikNp38YYwm6v8=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7325.eurprd04.prod.outlook.com (2603:10a6:800:1af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Fri, 2 Oct
 2020 08:39:24 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 08:39:24 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: Re: [PATCH net-next 1/4] net: dsa: Call dsa_untag_bridge_pvid() from
 dsa_switch_rcv()
Thread-Topic: [PATCH net-next 1/4] net: dsa: Call dsa_untag_bridge_pvid() from
 dsa_switch_rcv()
Thread-Index: AQHWmGWxf8PXZxnzlEqdeWnmxngZC6mD/kOA
Date:   Fri, 2 Oct 2020 08:39:24 +0000
Message-ID: <20201002083923.cki43bcnfnixku4l@skbuf>
References: <20201002024215.660240-1-f.fainelli@gmail.com>
 <20201002024215.660240-2-f.fainelli@gmail.com>
In-Reply-To: <20201002024215.660240-2-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7e220258-98e0-4657-d70d-08d866aeaa7a
x-ms-traffictypediagnostic: VE1PR04MB7325:
x-microsoft-antispam-prvs: <VE1PR04MB73251179ABC8AD25C2F29F02E0310@VE1PR04MB7325.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:514;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c6R3rX3Ppj8CnVytEpG2vUt5+SiL1AOZlrSvsSrWvNRACY3hE94cV14FsTB8eK6FizdmurNp3jaHp9eed78pilW8Khuc7oz3LCUg9ivY9vcVEZQsWuLQ5PD/uaEo0zgbUPD38osUgGS3VsHxUwXjFA2xxwdRMGJOrDl+5sT9pV/MhKfUfLL0LgGG/nHW1a2VI+XGapXJYUB1nhG9skp/3JaNaVmaOw3GeE/+Pax7+BecEiXsNT+T9mm5Ec6IC8Mdcsg6qby0Ce/u9oPLCm8p5NeNxxyZWynDDWd5j7GG+EleryP5tPI23TWhlPOkFAaOK3aL6nRYtnS62DcqFgs50LOkWxFjYh79b+MHXEDhn8Gzg7V3PayXWV34TKi8B9TZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(376002)(39860400002)(346002)(136003)(396003)(316002)(8936002)(186003)(4326008)(6486002)(26005)(6506007)(86362001)(8676002)(6916009)(5660300002)(1076003)(6512007)(9686003)(2906002)(478600001)(66556008)(64756008)(66476007)(66446008)(54906003)(71200400001)(66946007)(76116006)(91956017)(33716001)(83380400001)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xBuJcWrkdAlMRXRsnFF9oifVaxTbqBTOQMxXnuxpSDTzbpoacq6ejm4fpJotHq9e4ukcf0Nm1rjlaCeI6WMIK95hMZ+EiQ1YkL7ZyVqlcDzdZLOM0AXrR/H1br89J2IA13Dlwhxw84H1XWL0MsbMZeV2GFoSQPg6WyR0PmQ/qNhSbAaS+4PPfDzdbq8Xs8QQdDrP8YkLtAWptOxgnoVmddPe8V3CUECLmF9QLReYeULI0x2jorASzR7rVq5uC5LAQGjvMYdkaIqKTRczp7bJfmza3bwFxMRf+TotV1SLPOec7txsIgH21TnOPxm8PHqV9BDytLvmUFc9kKD+UCRftL9FwfRUXBm9lo0rcFpbfTQUX5KkNGqAA5F7+aMB6KXc2Hado26Tr+H3iRTw0DVufzOBrEbdJ7y9dCO8Fl2tjvO0QYSnYwaUGK9afEjxgDkMkMKkNBciBzllQ2O0rTAzMYhjZHztlNY0xiBGyYg75S8vh7q4cCVmblC+Iiq0x47k0fJEtsC0zYo+Y+QMhlvpwDu9YzJ4j8h3aRs7OYceucW1dtbpkYm1FEv5ENbZHEKLs0xYyL06k5ZJm1z36GaawrkX93v9QE41QG0sGUo0EzihnbEkk0g9G0nG7FdY5VcbTUaMZdLMPKaINHZ+AyvRxQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6BA5AF47B2E65E40A562905B6F9D7D48@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e220258-98e0-4657-d70d-08d866aeaa7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 08:39:24.2275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r7638IGLmtTHI0+Z4NpLWzYmaRrfovE7Jv3gF2cBmKAzl5RvElMFDVwPoF6fSbp+4No6QJhCwiaz0RGox5VJ5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7325
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 07:42:12PM -0700, Florian Fainelli wrote:
> When a DSA switch driver needs to call dsa_untag_bridge_pvid(), it can
> set dsa_switch::untag_brige_pvid to indicate this is necessary.
>=20
> This is a pre-requisite to making sure that we are always calling
> dsa_untag_bridge_pvid() after eth_type_trans() has been called.
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  include/net/dsa.h | 8 ++++++++
>  net/dsa/dsa.c     | 9 +++++++++
>  2 files changed, 17 insertions(+)
>=20
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index b502a63d196e..8b0696e08cac 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -308,6 +308,14 @@ struct dsa_switch {
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
> --=20
> 2.25.1
> =
