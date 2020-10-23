Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C2A296DD0
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 13:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463112AbgJWLhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 07:37:48 -0400
Received: from mail-db8eur05on2060.outbound.protection.outlook.com ([40.107.20.60]:39744
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S463048AbgJWLhr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 07:37:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hAlibZdf7bG7TK8mNJ1/oL0q+wh84SH6yOFqGlBG6nZu3otW4xWu9jWx+u2rO4/l+6AxUbQXtSOHFPF98fRbJFNNaIJaqpA/s0yV9IE7iTQqDHhR8/PJdUzQCyND1xDycMQ6jdxL1yfF5mFE57/SGIwPGhllFxTfyVTv6CNjS7HhQf/CEiSkUe6BJj1QVASWWdbbYHV+UWNFIuszDcJlGWXe0rUBUBzGJE0HRUxMRvXn5OvPZsIlPrJvwQnR2X9AQDNz8nilecp5jQlLA5XrN5j7CG41jf7iQBb1Uxg2zPWbW1+dAd6ao0oycx7yCi9itvkSJcGmEheOxwfwtmBmHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLEr1K94IvAh4KDzSNGkju6vlNZ0CduPVEy6mPqrD4U=;
 b=JAgL4vLdJ0F68p9u2X1vcoP4De9IIQOVlRA82JOrnXLsUPStthRbJv3FYkv68BFe5ilImtSDmgxIgPeMNV+zEgE2pi4oOQCVe8FRCJzS0SrmhZWFVxj4MOSEsMeJ6+6xIbcKiUPp8MnwmlxCaeKQ26F+FpXAzTo1WMZORM/PmsoEtkSP0ijQDNr/76Z8OytMF6apbzAwvLleASMwEma6GaBvInt4LXpSc6tFxW0n4dj+nmqCgY9wYgehgdh84Lg5q/9lTaK5g5o1JTdRddtR8ApcejkL+XVgxV1TLoBVPtFCRQ/u92DfkDjOLupZzme5NlQyLCeRnh6UnaobtpmqcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NLEr1K94IvAh4KDzSNGkju6vlNZ0CduPVEy6mPqrD4U=;
 b=T7yyqQAWbWw3eN58CvVelC79Dql/iV2dBOIDi9T2iWp3cKDMAo3WfaALjEKPiFeNRsHz1sFXrKWyp2mDzqbhKWRLq29a4bRPLE2hJDFgRxfSIkYlUUWzE09P1cWcI+0flEPXT80HdMrbgVNj1dxRSWL0Awh/0ZusdOJrId8on9A=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB5364.eurprd04.prod.outlook.com (2603:10a6:208:11f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Fri, 23 Oct
 2020 11:37:45 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3477.028; Fri, 23 Oct 2020
 11:37:44 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: RE: [PATCH net] gianfar: Account for Tx PTP timestamp in the skb
 headroom
Thread-Topic: [PATCH net] gianfar: Account for Tx PTP timestamp in the skb
 headroom
Thread-Index: AQHWpweGcRhcwMsnREqE1tK8TP9eu6miWc2AgAEekxCAAQlWgIAAfBoA
Date:   Fri, 23 Oct 2020 11:37:44 +0000
Message-ID: <AM0PR04MB67541E97634368B5B2CF1D5C961A0@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
        <20201020173605.1173-1-claudiu.manoil@nxp.com>
        <20201021105933.2cfa7176@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR04MB6754877DC2BBA688F2DC249A961D0@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201022195455.09939040@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022195455.09939040@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.27.120.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2df2e8ff-8153-4082-62f0-08d877480f3d
x-ms-traffictypediagnostic: AM0PR04MB5364:
x-microsoft-antispam-prvs: <AM0PR04MB5364141BC51509E4DB95EDE2961A0@AM0PR04MB5364.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QrKbX3wC3L4oPhKtakY7l9yZvrA2zZ4Y/IBB2QxevV1mND7L+hb5qVKpeAE1Yv2oAhlH/+EHX1Ho/hL3uQIG+SzgVoty6+y4EAbT43XEPuGjhI6d+30RjeKwbKex1VA0jitvM1Kc9CFk8A4ZWHqyp06kJQQebdxn6lg0vTzkmDbYi+P9cvAFUWUeo49mnXzS6i8HKZkNe+0sXufswV5ZpLKHXvTMGgGx0BIgnXugPy6gu/0NSTEL8BfeyDb8020ZsH4n3YsXBypQJuLvH8HtI/ivcbthHlkj2eijNOUnNGajD5ZCovKIxhyUWV5tREPR5xodB4K85Hz01mnFIUEtHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39850400004)(346002)(366004)(316002)(86362001)(33656002)(478600001)(4326008)(8936002)(6506007)(9686003)(6916009)(55016002)(8676002)(26005)(2906002)(186003)(71200400001)(64756008)(76116006)(44832011)(66946007)(66476007)(7696005)(66556008)(83380400001)(5660300002)(66446008)(54906003)(15650500001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: e55PeHcLHAGxsnGAaH+RfB9mUGv3Sjrp67anN0yxJHPIabqGzJOFHCW/bLj/0sisuYZHXsT976b9wNOgNODks85zVT6NFShHF0C7rZQaLQPBq0qkO3w5sjzTjZAni8w8a+tO81fL06sAq7kNQcNUvGhUSqLweys+4BTqceLbncZNv9hgIW8PAcK92hCmxITXx2paIjolQrPafUbG2WeO1vvJ/WHO+nG/uueqK25Ql/6tjhEB+xtVJ/VI9h6fFnxWUDa1+ykeuC5b62dS08tU0glO3mkNV6XGQpozD5EGDB7XeqU5nTWY4Jo8rgXCttKL0ZKT1t+TLPbrFhP/2E9Sj7X7a6IdlAxXHeC7uB8T2hqGo3Xeo7QoePQ9UakPaHFiTbl+kYC1g8jSBXTS6tmhmOcbb5hFqry62TehVgvIBjPrNP35rwK26xfk/6KrDPN1RXgOn64cbW0u3dSc2+4MYfCs1d6Y/VBpSjYXY7lHH3+05NypQuay77OymK0ACavmSLIFW1aRbvSOLqhR1+n9QADezz0lzRd6WQzG5zfymBwHrBUGBcLsChhr0whVcvbCrfwoJSIZdxSNfzDafHWanvTLb1XaykthnPg/5E1VRD3BzKIcCyAVvM/6eu6OzBVoDPP8Nngq/TSJLNVcW0f5Vg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df2e8ff-8153-4082-62f0-08d877480f3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2020 11:37:44.9257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MuVmwRU+lP8gxNtwU1eXz0q6cI27MC3fhf2MAOjOCxXsbybBckfCyaJ5JjNWAezMBRoyo2OTP0x9x6MLk4ypyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Friday, October 23, 2020 5:55 AM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
>james.jurack@ametek.com
>Subject: Re: [PATCH net] gianfar: Account for Tx PTP timestamp in the skb
>headroom
>
>On Thu, 22 Oct 2020 12:09:00 +0000 Claudiu Manoil wrote:
>> >-----Original Message-----
>> >From: Jakub Kicinski <kuba@kernel.org>
>> >Sent: Wednesday, October 21, 2020 9:00 PM
>> >To: Claudiu Manoil <claudiu.manoil@nxp.com>
>> >Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
>> >james.jurack@ametek.com
>> >Subject: Re: [PATCH net] gianfar: Account for Tx PTP timestamp in the s=
kb
>> >headroom
>> >
>> >On Tue, 20 Oct 2020 20:36:05 +0300 Claudiu Manoil wrote:
>> [...]
>> >>
>> >>  	if (dev->features & NETIF_F_IP_CSUM ||
>> >>  	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
>> >> -		dev->needed_headroom =3D GMAC_FCB_LEN;
>> >> +		dev->needed_headroom =3D GMAC_FCB_LEN +
>GMAC_TXPAL_LEN;
>> >>
>> >>  	/* Initializing some of the rx/tx queue level parameters */
>> >>  	for (i =3D 0; i < priv->num_tx_queues; i++) {
>> >
>> >Claudiu, I think this may be papering over the real issue.
>> >needed_headroom is best effort, if you were seeing crashes
>> >the missing checks for skb being the right geometry are still
>> >out there, they just not get hit in the case needed_headroom
>> >is respected.
>> >
>> >So updating needed_headroom is definitely fine, but the cause of
>> >crashes has to be found first.
>>
>> I agree Jakub, but this is a simple (and old) ring based driver. So the
>> question is what checks or operations may be missing or be wrong
>> in the below sequence of operations made on the skb designated for
>> timestamping?
>> As hinted in the commit description, the code is not crashing when
>> multiple TCP streams are transmitted alone (skb frags manipulation was
>> omitted for brevity below, and this is a well exercised path known to wo=
rk),
>> but only crashes when multiple TCP stream are run concurrently
>> with a PTP Tx packet flow taking the skb_realloc_headroom() path.
>> I don't find other drivers doing skb_realloc_headroom() for PTP packets,
>> so maybe is this an untested use case of skb usage?
>>
>> init:
>> dev->needed_headroom =3D GMAC_FCB_LEN;
>>
>> start_xmit:
>> netdev_tx_t gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
>> {
>> 	do_tstamp =3D (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
>> 		    priv->hwts_tx_en;
>> 	fcb_len =3D GMAC_FCB_LEN; // can also be 0
>> 	if (do_tstamp)
>> 		fcb_len =3D GMAC_FCB_LEN + GMAC_TXPAL_LEN;
>>
>> 	if (skb_headroom(skb) < fcb_len) {
>> 		skb_new =3D skb_realloc_headroom(skb, fcb_len);
>> 		if (!skb_new) {
>> 			dev_kfree_skb_any(skb);
>> 			return NETDEV_TX_OK;
>> 		}
>> 		if (skb->sk)
>> 			skb_set_owner_w(skb_new, skb->sk);
>> 		dev_consume_skb_any(skb);
>> 		skb =3D skb_new;
>> 	}
>
>Try replacing this if () with skb_cow_head(). The skbs you're getting
>are probably cloned.
>

That seems to be it(!), Jakub.  With this change the test that was failing
immediately before passes now.  I'm going to do some more tests, and
I'll send 2 stable fixes for v2 if everything is fine.
Not sure if this particular breakage was triggered by cloned skbs, though
probably timestamping skbs can get cloned, but could also be other aspect
/ side effect of using skb_realloc_headroom/skb_set_owner_w vs skb_cow_head=
,
as the 2 APIs differ in many ways.

Thanks for the help.

Regards,
Claudiu


