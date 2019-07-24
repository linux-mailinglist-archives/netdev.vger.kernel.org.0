Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE0F729B3
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 10:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfGXIPg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 04:15:36 -0400
Received: from mail-eopbgr140085.outbound.protection.outlook.com ([40.107.14.85]:4769
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfGXIPg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 04:15:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ci6ms7VP5g1BEwnoBvQgRJvgI13Icr1KkvIVLy7bUGJG8Qp8GfH39Pd69l9YFutK+HCkWRxR6otXuOYYg6Spbvl4DZra72UByiQRT+qh/yg2Pl1c8tfaI2+WiytGgWt9Rpbxsdt+t/A68+HekLN99p7m7/f7tlYEFSnOPJxqqHoQjEzxhRNyAHA2XqljEZGWHCYEBF8Ubp279zDDewOVRydpzgxKmnj7s/8jCp//lVOZreRd1yNy3EwlFJceq6nVRTB+Ca3ZQrWAHNuu0z/hddrcUHxY6ruEKDInWqZoHns6RKyMySLxasdjfY1TUJdrkVYK8FhBKDvl6g+9m3V/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XemzRzbsUtnu5Yci51ux4oxyHOgybhFhX5ZhKpxjqoI=;
 b=D5J+Ys/iUNcG/9I19DrarD0PuCcgEDRXxqff+DI4eDC0RfRpCb+e2t1KmS3cgco7lA0wEXjS04rGYC5az3UnKtpiVEYvLWpkKxo/IEaP79rZ2+8ph1e5sxualRlcARW2ZAdv+V/v1XdWV+rK53l4nY8CVGeQiPGymocEVMv5pMyNhmqxblnMI84xKod5hlulswa3pvauTO5tFXElIvYueTXlGjegAPOnjFfZNWF8N1+/WwhRAggoi6jTWeIZh2SZP7QEYVMe+D5+0PbN3Jcb4+//Cxu0dxsruUNHnTQ0Oc2dxi7VnIKxec4aztLkqB/yUUHK9y/+112DB6YLfWmfpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XemzRzbsUtnu5Yci51ux4oxyHOgybhFhX5ZhKpxjqoI=;
 b=n7Tz3VmagaC+U7NObvkm3Bwhemp6CbV0BoQkT6qPvf+yfdMrFbcgGwusnp95LV37C1tbQf5vtdHoBNf2mrN3TKx3CA2nCVJuNHdPwd4+AzzHxMxgHUC0EKre3d7RqpmyculC//EQirQKvc3B5S7D/5SHVF87bNQ3t+4vNzp7lfI=
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com (20.176.215.215) by
 AM0PR04MB4020.eurprd04.prod.outlook.com (52.134.90.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Wed, 24 Jul 2019 08:15:30 +0000
Received: from AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::41a7:61ce:8705:d82d]) by AM0PR04MB4994.eurprd04.prod.outlook.com
 ([fe80::41a7:61ce:8705:d82d%2]) with mapi id 15.20.2094.017; Wed, 24 Jul 2019
 08:15:30 +0000
From:   Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Edward Cree <ecree@solarflare.com>
Subject: RE: [PATCH net-next] dpaa2-eth: Don't use netif_receive_skb_list for
 TCP frames
Thread-Topic: [PATCH net-next] dpaa2-eth: Don't use netif_receive_skb_list for
 TCP frames
Thread-Index: AQHVQXwUMRr/5Ct9vECiPXgDk60+H6bYsQaAgAC38NA=
Date:   Wed, 24 Jul 2019 08:15:30 +0000
Message-ID: <AM0PR04MB499429A871F6037E483CFDFA94C60@AM0PR04MB4994.eurprd04.prod.outlook.com>
References: <1563902923-26178-1-git-send-email-ruxandra.radulescu@nxp.com>
 <20190723.140255.1785812525450069326.davem@davemloft.net>
In-Reply-To: <20190723.140255.1785812525450069326.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ruxandra.radulescu@nxp.com; 
x-originating-ip: [213.233.88.236]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1c9d0f1c-1655-462d-0795-08d7100f17a4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR04MB4020;
x-ms-traffictypediagnostic: AM0PR04MB4020:
x-microsoft-antispam-prvs: <AM0PR04MB4020728E5721C7C1AD13E0FC94C60@AM0PR04MB4020.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(13464003)(199004)(189003)(52314003)(6116002)(81166006)(81156014)(53936002)(14454004)(55016002)(6246003)(9686003)(6436002)(86362001)(7736002)(305945005)(6916009)(8676002)(478600001)(25786009)(99286004)(3846002)(33656002)(316002)(54906003)(76116006)(26005)(74316002)(66946007)(64756008)(52536014)(66556008)(66446008)(14444005)(8936002)(256004)(11346002)(66066001)(102836004)(446003)(186003)(476003)(7696005)(486006)(76176011)(4326008)(68736007)(6506007)(71200400001)(71190400001)(2906002)(53546011)(229853002)(5660300002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR04MB4020;H:AM0PR04MB4994.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NH8FwPoU2KIsUqcbAAoVq/+tibIk9eINlhhwTAqacki94XSnYLNWjh2FfRXrnvzRnCyVTorTJlwW/240JaoV5NNEBQEtrUo1AfoUxzqnuXRDYq8z6VJUvccepLd/kSIHucSLJpZegKGXQzkDgz6vYxNzPnsLBqeGiNGyCM6Red/gEEMlT3OWTel0d6N5fCT+wJ7PsNmHg/q2auN+wGPnJGBuHn0DLP5YNoawEnt08pkfHtLvPeq9sE2pqJl76EXrGJgjecIggmXJSbWgtPbux2EYkpcOm/WyV1Yyop3EwjGr30Kwwh0gDXQg/NMfCXCNbKxKjdF8IrlGXYILYjbHrCMY/G4pxq3CtFLgxpQ8cVlDfbsn/z5zWZrSY5LROCwGaM+t4x5G0iqqKHtjwM6aYdJEv1qo5JdT6EMgLybKJbE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c9d0f1c-1655-462d-0795-08d7100f17a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 08:15:30.1865
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ruxandra.radulescu@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4020
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Wednesday, July 24, 2019 12:03 AM
> To: Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
> Cc: netdev@vger.kernel.org; Ioana Ciornei <ioana.ciornei@nxp.com>; Vladim=
ir
> Oltean <vladimir.oltean@nxp.com>
> Subject: Re: [PATCH net-next] dpaa2-eth: Don't use netif_receive_skb_list=
 for
> TCP frames
>=20
> From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> Date: Tue, 23 Jul 2019 20:28:43 +0300
>=20
> > Using Rx skb bulking for all frames may negatively impact the
> > performance in some TCP termination scenarios, as it effectively
> > bypasses GRO.
>=20
> "may"?
>=20
> Please provide numbers so that we know exactly whether it actually
> hurts performance one way or another.

We observed the worst degradation running netperf TCP_STREAM on a
setup with two 16cores LX2160A boards connected back-to-back, one
stream per cpu:
With netif_receive_skb_list() on all packets, we get a total bandwidth
of 41.6Gbps, with rx cpu load of 97%; after applying current patch, bw
increases to 45.8Gbps with rx cpu at 64%, which is similar to what we
got before using netif_receive_skb_list() in the first place.

On other platforms/setups the impact is lower, in some cases there is
no difference in throughput, only higher cpu load when skb batching
is used for TCP packets.

Anyway, based on feedback so far I guess the best path forward is to
withdraw this patch and wait for Edward's GRO batching work to be
accepted. I can help test those patches if needed.

Thanks,
Ioana


