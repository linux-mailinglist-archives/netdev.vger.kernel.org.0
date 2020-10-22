Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E21295E0E
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 14:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897913AbgJVMJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 08:09:06 -0400
Received: from mail-eopbgr130075.outbound.protection.outlook.com ([40.107.13.75]:11943
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2897910AbgJVMJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 08:09:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GCsSk0qrrbMphVTt2NCx1e6qorqtVA6gyEyihd3hWOnmA1YeMDAxqFo1mZGUWRhlSOzgPl2ewmy6tLxnQA4auSS4OlVlT79JWmaOEfat4D+RC21JbazSDcOiLyiNVce2pHdXUAukeIuSVJyWNppcOOpd65Tgn51elUpwV8FIHelrFhBGv7ih9vR2Djb40UOWNBn+owQRy/QBDh+UeShTmnGXjTT0BFNT5i9oDteY9NMyQ0mKShaiPYnLhGYs9oU6YhKt22QpzsiIYOLYLEbZc8jg/LCbI5AaUV/QMcGEipCjaXn3wudSSwLnd4v7Gdq0ocWVKV2ffY44kxYRZUUBsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWLlslJ4TEzXes9ELpw5Q7yx/bJan4R9x3okT+cWNcg=;
 b=PHcIYRmGmWsXfoXUuUr0BvRJZ2PwKrphqvC/v1WXuDoHYDDQ1V1FpQ0Bkb3GHHX5GkZYBHCylP23GQS0VKetIH/5Tgk/g16MZirSSsJk6mhV0Xltc/sRbf7XlvjrtdzguzH3MKEDCprv5I++cjZs7dT3kzl59gJ+fkhQ8Doe1fwctY4qFzPbv89pQhaFkwPFkjFWtwlajgEO4U6gWaXCKMAkskAiaFlrd1PFSinKpcypJD+pla1y7EVc+s9EVFCxyG+LDEIK4i1HLAhTErDMB5Kym3cAbv4SGRBp/t5F4hk1wl2TMIeY1hFmSgGrUJPND6AMXvi0lWH43lSl9u7otQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWLlslJ4TEzXes9ELpw5Q7yx/bJan4R9x3okT+cWNcg=;
 b=kH/OE7Q9vG7BvqqINdHNfPHJhlYlgmHRa+ZbmkWcaaVz4FKIQbj8uBhAygHdz3WGaU/QaP3AzF8E/F02YBTcI6b+MoWSVC3M97S/KKdCGBPw0Uu3dLc5YEccguytrfm1gtYXlks37PLe5Qy2F1/c9aH1TGfNFWAnGbc5+fTOoxo=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM9PR04MB7682.eurprd04.prod.outlook.com (2603:10a6:20b:2db::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 22 Oct
 2020 12:09:00 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3477.028; Thu, 22 Oct 2020
 12:09:00 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: RE: [PATCH net] gianfar: Account for Tx PTP timestamp in the skb
 headroom
Thread-Topic: [PATCH net] gianfar: Account for Tx PTP timestamp in the skb
 headroom
Thread-Index: AQHWpweGcRhcwMsnREqE1tK8TP9eu6miWc2AgAEekxA=
Date:   Thu, 22 Oct 2020 12:09:00 +0000
Message-ID: <AM0PR04MB6754877DC2BBA688F2DC249A961D0@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
        <20201020173605.1173-1-claudiu.manoil@nxp.com>
 <20201021105933.2cfa7176@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201021105933.2cfa7176@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 18ffde49-bce4-4c27-d340-08d876834294
x-ms-traffictypediagnostic: AM9PR04MB7682:
x-microsoft-antispam-prvs: <AM9PR04MB76825B8E7BFB9DD325860EC2961D0@AM9PR04MB7682.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h6nhBUKF9VgkD5gigK1fpY0pQwsfSBGV/wAzhfFDCz4NwDYtZbWD1NFzUs0t56yUx5IEZSZboK6dJA3rCWhIRsJTwNI7/LZuiwVm/m7Cx1GVq1OSh7QKKRHyylMqjEFD0WPWrtUwWxZb3iWaEtvAce30A7ozBQiu2NhcqvHCGpHLu4Okv2zDTvZD1mTpzZPB820DC2NbhMB2othNq470B5klFh+59mpM5ik9KBYfNkvNOwzDKhGfM6vqfzaM0unGJEXHhbGbne8gEAlpID/RKxPFLvvC2v70F+U5wmq0bz7RYLD+aZ0PZJCzpl7Q55OU8DYkcoTICt/EmLVQj62ubw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(54906003)(316002)(26005)(478600001)(66556008)(186003)(71200400001)(66946007)(66446008)(66476007)(6506007)(6916009)(86362001)(76116006)(64756008)(44832011)(7696005)(15650500001)(55016002)(5660300002)(52536014)(9686003)(4326008)(2906002)(8676002)(33656002)(83380400001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: prnmJ1b+/FCR3opZa7nX3OI7l7LjboIg6x5zZbgdUxHqN20ML0FTO4oRYV9pvc1HGuIo+K6PW6j7pqSRNzreoNDgnUmxdYUaffA/A8VWCpmMLTbl5UC31XjVqGhOZ+1fzY6/kXfmPJcr4S90GajpTAP8YqMRVEdnZpzHmL9HsbOh59llYbs2hjSfW2G5ai6jXyW+BXM6X79b4ZZa06QYTcW2Ai9oau+HnhewyPvW+kgm825Kom670yEFyhiSkiYPmSNRYTYbfzt2uElffxGUdwzKvYBMLpsBNc3WBh0X1jgTqcuNBFr+7o/yTkjIWOWR8vwE5ECwwQqYYCf0PWXE8BZRpcyWwqpOCp/sb96rEaM0L+Q7dbaxLF0krTpfLHm7OXyiWZcA2VF4UqwkZq0zy1BU0fci3ikK5yo0eZKt5OnGvkfMnEEZovKDGdsBblf58eayE2GeXhcOqII/pizimdDd6INxmIcrxi9ErT7atreUbgKn6fZ9tPm068aFTTLfwTY46A+SSF/w9BMKAV7nuN7LJ3Uvb1N/I74aX6kV045e7RX9iJNiyZDXqk8BiDuTiRXrYtpMY+pjBaBTChz+VcyqeLh8rhP8pU6btOsHNiUldiYDEF+GxMM7CLkv9BmhttrPOzpf1ujwXVGsdDh+ZQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18ffde49-bce4-4c27-d340-08d876834294
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 12:09:00.1658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PXynlSrP5bw3YbpHC96ib1t6Y960+ycZXpIC8oERChQ2fZErIs4x72XulYZd1qCX76Fjj7vjUi/etH6lU0E3NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7682
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Wednesday, October 21, 2020 9:00 PM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
>james.jurack@ametek.com
>Subject: Re: [PATCH net] gianfar: Account for Tx PTP timestamp in the skb
>headroom
>
>On Tue, 20 Oct 2020 20:36:05 +0300 Claudiu Manoil wrote:
[...]
>>
>>  	if (dev->features & NETIF_F_IP_CSUM ||
>>  	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
>> -		dev->needed_headroom =3D GMAC_FCB_LEN;
>> +		dev->needed_headroom =3D GMAC_FCB_LEN + GMAC_TXPAL_LEN;
>>
>>  	/* Initializing some of the rx/tx queue level parameters */
>>  	for (i =3D 0; i < priv->num_tx_queues; i++) {
>
>Claudiu, I think this may be papering over the real issue.
>needed_headroom is best effort, if you were seeing crashes
>the missing checks for skb being the right geometry are still
>out there, they just not get hit in the case needed_headroom
>is respected.
>
>So updating needed_headroom is definitely fine, but the cause of
>crashes has to be found first.

I agree Jakub, but this is a simple (and old) ring based driver. So the
question is what checks or operations may be missing or be wrong
in the below sequence of operations made on the skb designated for
timestamping?
As hinted in the commit description, the code is not crashing when
multiple TCP streams are transmitted alone (skb frags manipulation was
omitted for brevity below, and this is a well exercised path known to work)=
,
but only crashes when multiple TCP stream are run concurrently
with a PTP Tx packet flow taking the skb_realloc_headroom() path.
I don't find other drivers doing skb_realloc_headroom() for PTP packets,
so maybe is this an untested use case of skb usage?

init:
dev->needed_headroom =3D GMAC_FCB_LEN;

start_xmit:
netdev_tx_t gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
{
	do_tstamp =3D (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
		    priv->hwts_tx_en;
	fcb_len =3D GMAC_FCB_LEN; // can also be 0
	if (do_tstamp)
		fcb_len =3D GMAC_FCB_LEN + GMAC_TXPAL_LEN;

	if (skb_headroom(skb) < fcb_len) {
		skb_new =3D skb_realloc_headroom(skb, fcb_len);
		if (!skb_new) {
			dev_kfree_skb_any(skb);
			return NETDEV_TX_OK;
		}
		if (skb->sk)
			skb_set_owner_w(skb_new, skb->sk);
		dev_consume_skb_any(skb);
		skb =3D skb_new;
	}
	[...]
	if (do_tstamp)
		skb_push(skb, GMAC_TXPAL_LEN);
	if (fcb_len)
		skb_push(skb, GMAC_FCB_LEN);

	// dma map and send the frame
}

Tx napi (xmit completion):
gfar_clean_tx_ring()
{
	do_tstamp =3D (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
		    priv->hwts_tx_en;
	// dma unmap
	if (do_tstamp) {
		struct skb_shared_hwtstamps shhwtstamps;

		// read timestamp from skb->data and write it to shhwtstamps
		skb_pull(skb, GMAC_FCB_LEN + GMAC_TXPAL_LEN);
		skb_tstamp_tx(skb, &shhwtstamps);
	}
	dev_kfree_skb_any(skb);
}

