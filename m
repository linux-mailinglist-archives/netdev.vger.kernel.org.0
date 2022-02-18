Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1B24BB89C
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234915AbiBRLqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:46:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234751AbiBRLqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:46:36 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70120.outbound.protection.outlook.com [40.107.7.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A297A15A14
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:46:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShIrMg9RbFTmkU4MIIdEhs0eAV7k6knQ3dxoVpiQ0ccwntoW0c4rOg7ObJ0YXe4ihvChE4LGt5BNurlvGV4aQH5DJBNAxsOhczy+mI2Ls8bSS/sjTC0URGTXO8W8vXepna6+UsOZsvMH+6E3LR4iadjlMrMjRruF+kxbLWdZd2Xq7fEPWXdO7mv6gquVC4cFihD3omq40Mbw/rhWQPpblsBqkyqAp2ukLvaMOms4JxEeiJMZ4AgWicByqLh5FpJnu1lVv/ZJ3XsJzB70N6bPzx3c5kZm6sVtwx/qRmUgRsOUpc1w7dXyPM+azrt5Z3iMC/wo71SUbZRAlLm45T8d2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=96iUhPvuw6M8TGs/hD+BhR6HSJ6WbZuGOR8uwMFz95k=;
 b=ep5MRHv8jh6iLMFcpZsVJyiWw8QzBrg0/xVEbktnF5BZTpDCIMYWD0OJxMFJhNEboCQN3XH10eu/p62yrg6FHFOg6MYx5nerEl3+kaGpv/zaGau6amC5M0+3wW3m/t5kAne4jFNTGXkHn0p1cfKVhnAzwNJDL+EWKtxQDvmNDIhemxBB0LQZGiPWt7szXdBx0oSmnoBCoKzn2jcH3cE0cvb9iyDOs9y7VzpFhJ09taUeB6ooYSW3+YDvgAZC0CmtJUaBOG+7mbb+IR8ZFEfnwuHyEyJF0DrwB/OrRszw6zG5uSfGsxf7L5PO9k0kOFlGAPcLAV6JviaNYZGN+2I5hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=96iUhPvuw6M8TGs/hD+BhR6HSJ6WbZuGOR8uwMFz95k=;
 b=hvRTt1qyWUsvPwdHuyuosGcbirrz0tE65UwhspkJ7wqwWvzvsHTuvibAb7Qu0Zi9mZTs00TSv7BrTizDeV+CVCQyKbspmSMY+HBMysu0/Zm6cxkRU6YozyznWhtWotQj/giA6LYEv7cW4QZ9923Uni2sRTxPs+Bb8b4GnmvDAxo=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB7PR03MB3980.eurprd03.prod.outlook.com (2603:10a6:5:3a::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Fri, 18 Feb
 2022 11:46:11 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.016; Fri, 18 Feb 2022
 11:46:11 +0000
From:   =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v2 1/2] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
Thread-Topic: [PATCH net-next v2 1/2] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
Thread-Index: AQHYJI5MkEfzwLVVY06CGviZiPWQVg==
Date:   Fri, 18 Feb 2022 11:46:11 +0000
Message-ID: <877d9spfct.fsf@bang-olufsen.dk>
References: <20220218060959.6631-1-luizluca@gmail.com>
        <20220218060959.6631-2-luizluca@gmail.com>
In-Reply-To: <20220218060959.6631-2-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Fri, 18 Feb 2022 03:09:58 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a564d0c1-c438-4459-41bb-08d9f2d44290
x-ms-traffictypediagnostic: DB7PR03MB3980:EE_
x-microsoft-antispam-prvs: <DB7PR03MB39801D4E03809EFD30FF796183379@DB7PR03MB3980.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XlKkhHxJXCQBbPyQUq9UrsEv4KYgLQdKTB14Eh8OswIhiaBFbOf+3TJ/dxnLwqK9r6iF8urxlJbWqTIGTbFfJclIftxlH2sGS6Pf1JNpRqf4P+v+aQOoeOKPmryioL8wc9PMYSbDuTGsTQmc3aDuTODP+iK096OmUDRM6Fio/govkNtCH5xF4Ry3TmugfvMXhhQxtckf4nlmypE4TjyjtUyPq9sds+CKxDpwca3rWMnOOErMKdM/G/HtF4ULPuOMErQAGTkwohKiSNLy8rr7pH5WoPqJUuD9MCcUyxbEIXOuxKhhX5+PtkD/0LXBwp71Zs6FBAdeEfKBAaFZBMkuorAo0i7mg7waIrKHaSB/RHgUYs/jXLzKA0ZicXt+36EE0o/T4esyTobiw6dMNGiuaN1fTdfl/6Qt/NG6ji86j/Zv2ulpmVX9hGb3IcSP7u1SVx9cwNOrEWNxn68DGu8/CZt1pcdjx3/cP5WEKGcggKoFaPZlARcXSqeNly7rOIT1pzwInpOd638v9E3z0Ouirb1/g57Y6P/HENZ+e3nbB5ks2afh1KY3yCcAzmSeNGy2u8g+WIFsMvKBIvmRncHTLgC3B8wfPPRV1wqi6NdT+KLR96m7cB5/CpweKgzDLiIeE/ujZYNAYbaj50DRo4DoMZwnw/wj9uY2TLz2l1WEINqL9JnH3izEdJf3NegYBd8Bp31ixO9uMa7KJwp6HwXuKQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(2616005)(26005)(38070700005)(8976002)(86362001)(54906003)(6512007)(122000001)(2906002)(76116006)(7416002)(5660300002)(508600001)(91956017)(4326008)(8936002)(186003)(8676002)(64756008)(71200400001)(6506007)(66946007)(83380400001)(66476007)(36756003)(66446008)(66556008)(6486002)(316002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?aLwDBwTRAWElNGpSbLG/3QyPks6GrPI7dEa2HTmNHEHgDVSRoGKCmv+G?=
 =?Windows-1252?Q?l2GlTTr78CwN6KREXifsF0VKc9gcyArkMsB6Rv+/UESD0Jkr/muK2IHM?=
 =?Windows-1252?Q?qj/y223SoOUdqUfUGnYUAvi7h/BGRjAe0t2TWJX5Ppv/7mgQpvEkY61T?=
 =?Windows-1252?Q?NJnOYXdaRXH34jGGECKsPOiShzIsc9JtQCZiovPr/jb3AP4OcElsC7qt?=
 =?Windows-1252?Q?JKvih3OgjRsRq/DDv71VYPfZ/BH3bX6vCiPIu5q/bYHwKR2m8HyQ3rRb?=
 =?Windows-1252?Q?NY3oKiYJk1h5UABXmgbRJKcVaNMaGhNVPgpACwwhMhkDwIYt5CDu7ssk?=
 =?Windows-1252?Q?yLvki4D/urn3pp3NrSn3pvDTeHVgUnSSO1qbeSbo+a1v0K9Yj9yKEfcN?=
 =?Windows-1252?Q?sew1uEfpEodF8x5kOFFFkOul8g7ilYuBEiPEQGJpYLvrkNZeYGu0ItJJ?=
 =?Windows-1252?Q?TW6VOKPAXOzigUgxxp6Zy8IHHac5SAFTVzN1sctwuAxT3M3kks09a3nq?=
 =?Windows-1252?Q?jQQb0YkRCvvJenogavf5nRefN/XJ2MlbBTKcoBlqgOKERA3g0YDj/aoL?=
 =?Windows-1252?Q?ORDY+eF3ETMFGcaKpzcRC3RcgLiT6P+ciqhq9rT1XRCXUpX0AcJeUdS8?=
 =?Windows-1252?Q?gif0UH8ozq/3V47FP2ws1O8t59R8t23tJ+uZwDizzGMRZSUGgMS+JZCP?=
 =?Windows-1252?Q?OTDCq7nepLGd02I1IdVUH5jbW1VnsgBF6XC65KGnpVGiAO0E6EvYZ+SK?=
 =?Windows-1252?Q?SGbJUunbXXXtmaMUa8pBjxVBaJ5o4jdqzRYtfS7p6OEc1bf7laWPGFcm?=
 =?Windows-1252?Q?IPG2x4wS8xgDL2aQnmWu4OyHnSwc9x+LoUjudC4PMXTQ+YsArdraeTxO?=
 =?Windows-1252?Q?HJyklQWqslX7y4iXR+lM/Rff9EDGo9XF+07kPNg+1uAKNKHzWHlDfiYE?=
 =?Windows-1252?Q?4uM6z663qktb+d8P+cBaE7xODy1Vm2uGKvnRsJrNzOtjk8aKrxHtQueQ?=
 =?Windows-1252?Q?ZNuw9iyw7EJCz3cmBC7MEWyWx2xLucZmbXk5j9kAeHiNJTFeJQIFdzOJ?=
 =?Windows-1252?Q?hwuZ/xHFxngUKySQ/4M60aYSeXWkDX3gx0EPcs2j2o9pXUmxK2m+5rNd?=
 =?Windows-1252?Q?8XDww5Vyb3ObKrWOq6V76SZo6YVycueBkSYFR1V/fKe/5tJ8GtasUBkD?=
 =?Windows-1252?Q?CXwdDbnxiThxzgU75IRtJksSIW0IYBTo3Exs2neL7Bgsakp0sxmLyh4W?=
 =?Windows-1252?Q?gsa6aJX3a4P91coozYIg1s51Vv6blhfeF5gG37Q2mGbWCrD7kjSX54mn?=
 =?Windows-1252?Q?Kgi220FZto/fENdG986xze/+e8CY7IQkzCuKgEHUjW0GLD+SY4vDMAxz?=
 =?Windows-1252?Q?HKqa06LiladiXzbxpA2gZaLiNJWIOYZYcJv87OPNeIcug8afaIEJwk5Z?=
 =?Windows-1252?Q?tAdm0xedhkYTR/Qo3XZU6+F19IyjOhTa7bien1BJz9Y9N+XIKVmrQiEW?=
 =?Windows-1252?Q?7crt+Zna8bkkzERvkT9qjgrBYKd4lQZyHE4GTrZeQ4plJvY/h7ISX5+M?=
 =?Windows-1252?Q?cp+3Z93raL/jat70p3K26PLEOadD2K3qY8RmQppEWCwRxQ3vYeRVJOev?=
 =?Windows-1252?Q?kXDMKpuUpHIvSZo1fKhGcb4JZ7X6hnkXUnhpcGGnvEp4PSGr5ADAg5jB?=
 =?Windows-1252?Q?umhEHnw8no53IA33Tr2UKMatVddvkiM7IHM14Y6URQ1imlXfCz8p+2ql?=
 =?Windows-1252?Q?QdhyHyXpcxOOBzXIrF0=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a564d0c1-c438-4459-41bb-08d9f2d44290
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 11:46:11.2749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qNyA6LdaajStN6kuPlCfy9g5BXt0tpprjtqqEI0iNAeWIk8Fkkv8Jacw3j/rNvcZPvHedXwYRspLKuUzhmt+yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3980
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

> The switch supports the same tag both before ethertype or before CRC.

s/The switch supports/Realtek switches support/?

I think you should update the documentation at the top of the file as
well.

>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  include/net/dsa.h    |   2 +
>  net/dsa/tag_rtl8_4.c | 127 +++++++++++++++++++++++++++++++++----------
>  2 files changed, 99 insertions(+), 30 deletions(-)
>
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index fd1f62a6e0a8..b688ced04b0e 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -52,6 +52,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_BRCM_LEGACY_VALUE		22
>  #define DSA_TAG_PROTO_SJA1110_VALUE		23
>  #define DSA_TAG_PROTO_RTL8_4_VALUE		24
> +#define DSA_TAG_PROTO_RTL8_4T_VALUE		25
> =20
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		=3D DSA_TAG_PROTO_NONE_VALUE,
> @@ -79,6 +80,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_SEVILLE		=3D DSA_TAG_PROTO_SEVILLE_VALUE,
>  	DSA_TAG_PROTO_SJA1110		=3D DSA_TAG_PROTO_SJA1110_VALUE,
>  	DSA_TAG_PROTO_RTL8_4		=3D DSA_TAG_PROTO_RTL8_4_VALUE,
> +	DSA_TAG_PROTO_RTL8_4T		=3D DSA_TAG_PROTO_RTL8_4T_VALUE,
>  };
> =20
>  struct dsa_switch;
> diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
> index 02686ad4045d..d80357cb74b0 100644
> --- a/net/dsa/tag_rtl8_4.c
> +++ b/net/dsa/tag_rtl8_4.c
> @@ -84,87 +84,133 @@
>  #define RTL8_4_TX			GENMASK(3, 0)
>  #define RTL8_4_RX			GENMASK(10, 0)
> =20
> -static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
> -				       struct net_device *dev)
> +static void rtl8_4_write_tag(struct sk_buff *skb, struct net_device *dev=
,
> +			     void *tag)
>  {
>  	struct dsa_port *dp =3D dsa_slave_to_port(dev);
> -	__be16 *tag;
> -
> -	skb_push(skb, RTL8_4_TAG_LEN);
> -
> -	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> -	tag =3D dsa_etype_header_pos_tx(skb);
> +	__be16 tag16[RTL8_4_TAG_LEN / 2];
> =20
>  	/* Set Realtek EtherType */
> -	tag[0] =3D htons(ETH_P_REALTEK);
> +	tag16[0] =3D htons(ETH_P_REALTEK);
> =20
>  	/* Set Protocol; zero REASON */
> -	tag[1] =3D htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365MB)=
);
> +	tag16[1] =3D htons(FIELD_PREP(RTL8_4_PROTOCOL, RTL8_4_PROTOCOL_RTL8365M=
B));
> =20
>  	/* Zero FID_EN, FID, PRI_EN, PRI, KEEP; set LEARN_DIS */
> -	tag[2] =3D htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
> +	tag16[2] =3D htons(FIELD_PREP(RTL8_4_LEARN_DIS, 1));
> =20
>  	/* Zero ALLOW; set RX (CPU->switch) forwarding port mask */
> -	tag[3] =3D htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
> +	tag16[3] =3D htons(FIELD_PREP(RTL8_4_RX, BIT(dp->index)));
> +
> +	memcpy(tag, tag16, RTL8_4_TAG_LEN);

Why not just cast tag to __be16 and avoid an extra memcpy for each xmit?

> +}
> +
> +static struct sk_buff *rtl8_4_tag_xmit(struct sk_buff *skb,
> +				       struct net_device *dev)
> +{
> +	skb_push(skb, RTL8_4_TAG_LEN);
> +
> +	dsa_alloc_etype_header(skb, RTL8_4_TAG_LEN);
> +
> +	rtl8_4_write_tag(skb, dev, dsa_etype_header_pos_tx(skb));
> =20
>  	return skb;
>  }
> =20
> -static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> -				      struct net_device *dev)
> +static struct sk_buff *rtl8_4t_tag_xmit(struct sk_buff *skb,
> +					struct net_device *dev)
> +{
> +	/* Calculate the checksum here if not done yet as trailing tags will
> +	 * break either software and hardware based checksum
> +	 */
> +	if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL && skb_checksum_help(skb))
> +		return NULL;
> +
> +	rtl8_4_write_tag(skb, dev, skb_put(skb, RTL8_4_TAG_LEN));
> +
> +	return skb;
> +}
> +
> +static int rtl8_4_read_tag(struct sk_buff *skb, struct net_device *dev,
> +			   void *tag)
>  {
> -	__be16 *tag;
>  	u16 etype;
>  	u8 reason;
>  	u8 proto;
>  	u8 port;
> +	__be16 tag16[RTL8_4_TAG_LEN / 2];

nit: Reverse christmas-tree order?

> =20
> -	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
> -		return NULL;
> -
> -	tag =3D dsa_etype_header_pos_rx(skb);
> +	memcpy(tag16, tag, RTL8_4_TAG_LEN);

Likewise can you avoid this memcpy?

> =20
>  	/* Parse Realtek EtherType */
> -	etype =3D ntohs(tag[0]);
> +	etype =3D ntohs(tag16[0]);
>  	if (unlikely(etype !=3D ETH_P_REALTEK)) {
>  		dev_warn_ratelimited(&dev->dev,
>  				     "non-realtek ethertype 0x%04x\n", etype);
> -		return NULL;
> +		return -EPROTO;
>  	}
> =20
>  	/* Parse Protocol */
> -	proto =3D FIELD_GET(RTL8_4_PROTOCOL, ntohs(tag[1]));
> +	proto =3D FIELD_GET(RTL8_4_PROTOCOL, ntohs(tag16[1]));
>  	if (unlikely(proto !=3D RTL8_4_PROTOCOL_RTL8365MB)) {
>  		dev_warn_ratelimited(&dev->dev,
>  				     "unknown realtek protocol 0x%02x\n",
>  				     proto);
> -		return NULL;
> +		return -EPROTO;
>  	}
> =20
>  	/* Parse REASON */
> -	reason =3D FIELD_GET(RTL8_4_REASON, ntohs(tag[1]));
> +	reason =3D FIELD_GET(RTL8_4_REASON, ntohs(tag16[1]));
> =20
>  	/* Parse TX (switch->CPU) */
> -	port =3D FIELD_GET(RTL8_4_TX, ntohs(tag[3]));
> +	port =3D FIELD_GET(RTL8_4_TX, ntohs(tag16[3]));
>  	skb->dev =3D dsa_master_find_slave(dev, 0, port);
>  	if (!skb->dev) {
>  		dev_warn_ratelimited(&dev->dev,
>  				     "could not find slave for port %d\n",
>  				     port);
> -		return NULL;
> +		return -ENOENT;
>  	}
> =20
> +	if (reason !=3D RTL8_4_REASON_TRAP)
> +		dsa_default_offload_fwd_mark(skb);
> +
> +	return 0;
> +}
> +
> +static struct sk_buff *rtl8_4_tag_rcv(struct sk_buff *skb,
> +				      struct net_device *dev)
> +{
> +	if (unlikely(!pskb_may_pull(skb, RTL8_4_TAG_LEN)))
> +		return NULL;
> +
> +	if (unlikely(rtl8_4_read_tag(skb, dev, dsa_etype_header_pos_rx(skb))))
> +		return NULL;
> +
>  	/* Remove tag and recalculate checksum */
>  	skb_pull_rcsum(skb, RTL8_4_TAG_LEN);
> =20
>  	dsa_strip_etype_header(skb, RTL8_4_TAG_LEN);
> =20
> -	if (reason !=3D RTL8_4_REASON_TRAP)
> -		dsa_default_offload_fwd_mark(skb);
> +	return skb;
> +}
> +
> +static struct sk_buff *rtl8_4t_tag_rcv(struct sk_buff *skb,
> +				       struct net_device *dev)
> +{

I wonder if it's necessary to check pskb_may_pull() here too.

> +	if (skb_linearize(skb))
> +		return NULL;
> +
> +	if (unlikely(rtl8_4_read_tag(skb, dev, skb_tail_pointer(skb) - RTL8_4_T=
AG_LEN)))
> +		return NULL;
> +
> +	if (pskb_trim_rcsum(skb, skb->len - RTL8_4_TAG_LEN))
> +		return NULL;
> =20
>  	return skb;
>  }
> =20
> +/* Ethertype version */
>  static const struct dsa_device_ops rtl8_4_netdev_ops =3D {
>  	.name =3D "rtl8_4",
>  	.proto =3D DSA_TAG_PROTO_RTL8_4,
> @@ -172,7 +218,28 @@ static const struct dsa_device_ops rtl8_4_netdev_ops=
 =3D {
>  	.rcv =3D rtl8_4_tag_rcv,
>  	.needed_headroom =3D RTL8_4_TAG_LEN,
>  };
> -module_dsa_tag_driver(rtl8_4_netdev_ops);
> =20
> -MODULE_LICENSE("GPL");
> +DSA_TAG_DRIVER(rtl8_4_netdev_ops);
> +
>  MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4);
> +
> +/* Tail version */
> +static const struct dsa_device_ops rtl8_4t_netdev_ops =3D {
> +	.name =3D "rtl8_4t",
> +	.proto =3D DSA_TAG_PROTO_RTL8_4T,
> +	.xmit =3D rtl8_4t_tag_xmit,
> +	.rcv =3D rtl8_4t_tag_rcv,
> +	.needed_tailroom =3D RTL8_4_TAG_LEN,
> +};
> +
> +DSA_TAG_DRIVER(rtl8_4t_netdev_ops);
> +
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4L);
> +
> +static struct dsa_tag_driver *dsa_tag_drivers[] =3D {
> +	&DSA_TAG_DRIVER_NAME(rtl8_4_netdev_ops),
> +	&DSA_TAG_DRIVER_NAME(rtl8_4t_netdev_ops),
> +};
> +module_dsa_tag_drivers(dsa_tag_drivers);
> +
> +MODULE_LICENSE("GPL");=
