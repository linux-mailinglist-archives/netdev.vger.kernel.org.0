Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC777280F1F
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 10:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387716AbgJBIlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 04:41:08 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:17399
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725961AbgJBIlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 04:41:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUR67lxbOcU0LEMXBdyCJIe/rd+vakUDjrTUj10XJLGtL4hfgS+0RSUshiFydNIUpOdNoHSU445YTEeO2xh+lLYywNtS/rIgIHmO7e/LFeuoXATwB+KidovdYmhVkL6yxLb0/fByo3hHDaKb5tW8CNUUKeSeeRhpt1+ODxRXEdrCk5V+AwuPo6TXyMkvJo7jltbemxcD40cyPG7YSjrxh9TArGohUZ/8r1bnptGxB8O6KxVtryRAeBL7sPkDdfGyssglpN3zcAASGbBm4f/9WGFuSFdEneHH9/mgeLKaGY30UrUp/t60as5LPSbmY1HUA3AEd+792VEiy28akB+t1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AX+Jm6KjWogAjMgy7vr1S85fOoAhjvQ1E1KZqlEFa1M=;
 b=Jx0T9depVaAAdchmzKAG6D7QlFUazzw+cksxhQyv0NLdMRhKBNPtUqxz7kXutX2nI7t0gy/Ajcg2sWbJOxAduvfrLxf01bTbk3IBXCSXNDD1LMny3cJ1gjGpKRjspdrHR7LH10YlGwoZvEIbT8aL8++T8U1Yk5X1w3h+arXgwGwbpPMlKVu42i7sR2WkxgPjvSFJRPaabfkmOCo56i4RXIBa3LCiZWtohG3e0ejugWd5zTdJKcpAHQT7elB6cqqKLDXnZH+WFduiLo2C9Wdr+c9AMQfgFfU+WEZPNvDJWKpU3ZvNkHU3G9zUDaVIE2+vkLf7/Jgkyw06/NcxfbkaAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AX+Jm6KjWogAjMgy7vr1S85fOoAhjvQ1E1KZqlEFa1M=;
 b=Fk0JaxQA7vTwj3LvDXTwf+UTU3f8XHOrh7blArapXTXV4kiXKmzOjgPgJGGS+0zcL2D+AbMU+AJtuqSiOD22tqbDt5+EGJh72wPkkfJpBvaGJR4yXeRH6RayD/yukvmvLYGgOA7rtozhmbaQhxxZA4cBg8JvsXdJPdNfjo5FpD0=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (20.178.127.205) by
 VI1PR0402MB3615.eurprd04.prod.outlook.com (52.134.4.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.32; Fri, 2 Oct 2020 08:41:04 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.038; Fri, 2 Oct 2020
 08:41:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: Re: [PATCH net-next 3/4] net: dsa: Obtain VLAN protocol from
 skb->protocol
Thread-Topic: [PATCH net-next 3/4] net: dsa: Obtain VLAN protocol from
 skb->protocol
Thread-Index: AQHWmGW14uicr7mTFkCTbmtHLSILh6mD/rkA
Date:   Fri, 2 Oct 2020 08:41:03 +0000
Message-ID: <20201002084102.sf7w5d76lf2swatq@skbuf>
References: <20201002024215.660240-1-f.fainelli@gmail.com>
 <20201002024215.660240-4-f.fainelli@gmail.com>
In-Reply-To: <20201002024215.660240-4-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d0a87c55-3121-44cb-035f-08d866aee5f5
x-ms-traffictypediagnostic: VI1PR0402MB3615:
x-microsoft-antispam-prvs: <VI1PR0402MB36159E4A01952FE6CB6C81B7E0310@VI1PR0402MB3615.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z0uFahOWl/xFkvZv4ju9Wy6A8iS86+euHaUnESE9ngI/hnkEhGzDXB4kn/ZN/KZGQJ8UAPojlqkqKyW9BZQZA2haqxpScgVCaH8jgR9hKawYwM0uO39mLCMGZC9vwRfWGtNGF7XfGru1rTdKsOhd0elm8iGkSZuzEoLicfDTW8xWZPe5xosOM5qj0efTRuNsBX6wcesAbuFHQNQlGg3Wq9A9GdyUXLU/5ziUFQ5iTxWtiTu/d9DICu9YTovKqsEjTlCo0wF+46jESgRIT9q9Lj2HzYvnydJn/UNnLk6p7FcA61jCer9GToRFQ6BaCyw3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(346002)(376002)(136003)(366004)(39860400002)(6512007)(86362001)(6486002)(6916009)(66946007)(64756008)(8936002)(66556008)(66446008)(66476007)(5660300002)(316002)(8676002)(9686003)(83380400001)(44832011)(186003)(54906003)(26005)(33716001)(4326008)(2906002)(76116006)(478600001)(1076003)(6506007)(71200400001)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: HF+RlZA5WjeQoeWf8z4WcTYZEFOoOO5EH8OKs/q/1vBu2G2CjQPemtUKq6rD5SkwOFajp/RS1dALr8spsdoo12jJ/Z068CpsyWTaY8BxXPS7sP1Sv3fLxXErSLb0mzod+7DBfyJNNF5d06CN9leiEK93MddwsL71ngqzZ6+iB+WLhMGZjZ5ktIRAD8zqGCG7jjEyAcpNaVuDbKzTtvKoFT63bR+V9t7hjmHghT9xiC6AXOyEptHNR2/WYe+hTqAyfJdDh1L5EvhGCvbwL8PUTyqzOxa9HfjoUDJNJ/fAj2HCgA3CmyywXZF2lvD1qCYu17L/XWdvMkGTQA8XodHLH1v15lo22LJ6Fr1AWNAmjL+Lg8LU87EDP3AlFgXFId0xAP2dnjOmIrLbBANfAZV/st9PO1q2l/ryC+1bu9dvKOgg1Wia/nsBI1y9mKxGBo1pmIA0HU1AYZGGVeC490ACnkNsXKk9XZWd4XYnrKDMq7c9BQgWEkYwTrYOd0vnCnKPG1+HavPjF3F03DCYlM3d1ZLprpgnVsH2x7EN6Y0co0fEYyP3u9nETO8vzEX2r6RGqB1k1CSkVad6UDki6+uO7e/gvrnuOSI7tvF5O1ulL9MqnP/upEePxv6sesf4AtwLYahF5Je6c+7flXGYT8Tuxw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3912E8E4560C2459BD92D285D3D6F0C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0a87c55-3121-44cb-035f-08d866aee5f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2020 08:41:04.0168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G1m/CU72HzAOvI0DbSq7lUbdWQKJ+uVyGEMDN7DNdHiEOUiibVhowSIl0JBztl7Ar06337wmbn+rFzyOsHfEKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3615
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 01, 2020 at 07:42:14PM -0700, Florian Fainelli wrote:
> Now that dsa_untag_bridge_pvid() is called after eth_type_trans() we are
> guaranteed that skb->protocol will be set to a correct value, thus
> allowing us to avoid calling vlan_eth_hdr().
>=20
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

>  net/dsa/dsa_priv.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
> index 0348dbab4131..d6ce8c2a2590 100644
> --- a/net/dsa/dsa_priv.h
> +++ b/net/dsa/dsa_priv.h
> @@ -201,7 +201,6 @@ dsa_slave_to_master(const struct net_device *dev)
>  static inline struct sk_buff *dsa_untag_bridge_pvid(struct sk_buff *skb)
>  {
>  	struct dsa_port *dp =3D dsa_slave_to_port(skb->dev);
> -	struct vlan_ethhdr *hdr =3D vlan_eth_hdr(skb);
>  	struct net_device *br =3D dp->bridge_dev;
>  	struct net_device *dev =3D skb->dev;
>  	struct net_device *upper_dev;
> @@ -217,7 +216,7 @@ static inline struct sk_buff *dsa_untag_bridge_pvid(s=
truct sk_buff *skb)
>  		return skb;
> =20
>  	/* Move VLAN tag from data to hwaccel */
> -	if (!skb_vlan_tag_present(skb) && hdr->h_vlan_proto =3D=3D htons(proto)=
) {
> +	if (!skb_vlan_tag_present(skb) && skb->protocol =3D=3D htons(proto)) {
>  		skb =3D skb_vlan_untag(skb);
>  		if (!skb)
>  			return NULL;
> --=20
> 2.25.1
> =
