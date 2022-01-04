Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC5F48408B
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbiADLMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:12:14 -0500
Received: from mail-eopbgr130074.outbound.protection.outlook.com ([40.107.13.74]:34180
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231834AbiADLMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 06:12:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewwDfZJOXGvLnB4R6xX8+IaYN9Evjzidz1aEe6VnMQHRuaoVTU2lwkv0f6qbyCl+P+klu74gql7UQSx5T7VbaOe+GE0IyISlEIf1nhVBFJJcQw6Qi8Draxs4qWDjpwFO9Ve1I1e6V+KmQInWiHcxtFf6HGdvYHeFsi0o2N0qFL3nCmu3mmmS8OxWEikGyjrAfMRxYIBwTgl6LkxNL75Gkex+gctYDuImtYTomBPoOSV4+Qu9f9zEnXHHpUL8Zq680XZ9dTzJK359n+v1w6RKi4dVQR1nIQQtv5ykbnjqsyftqPfFapKJ87Jn6X4v18nQpS6p2aAJmRFDemKKQcTFJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAqhrpLYMvrzo2qIJzbctjXFvY48XNTHgvRH5RT0kok=;
 b=bfODrE+cpKBZz4YK774LRBk/ZWLJGT8Y4uTLLadDjlfjxvxkR60PEBcsnnnf1Ol8PwXxXwX6gSlYFl+jfyXGhwemXmPvri3RsoPTpn9up8iPGrkM32pBw6YXYDola46ZLsTENCjtmF73g+YLy2HKMJJUM3HJdVo18dNfz44ZXXk+kzvX2SDOSwYlopzimU7oEX9GSlL3mV9PMPbgl5Ua9YD+DNQaIm3tdSrMsFbBy9NvEcbIXc57pMiRPrUeXKkX6335ZXEea6f4xcU56ZaUJ/g0q864qtGV2DVL9R+Kev3jcGvSQjw7y9XYIhc89vDZgqfqG/RAm1vhjzlz1pcZdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yAqhrpLYMvrzo2qIJzbctjXFvY48XNTHgvRH5RT0kok=;
 b=sCdvHEnLDZqswxijB3s4eGgx1zFVXGH8lmz3x/rBerxoQwqStzRLaybMVeRHU7Tv0OFKO1Bj62lv3NDOCVDums7+C/Ud8Usdkb8W6tbIJfUOBDAyt+AayyHTs8pWdNTQrdbHUfgIXbmjvjdOs+PKbkBB6xRjhzjJNWYOWxxl5Q4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6701.eurprd04.prod.outlook.com (2603:10a6:803:124::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Tue, 4 Jan
 2022 11:12:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 11:12:10 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 3/3] net: lan966x: Extend switchdev with mdb
 support
Thread-Topic: [PATCH net-next v2 3/3] net: lan966x: Extend switchdev with mdb
 support
Thread-Index: AQHYAVQxqo6MQJKDGUai5dR5RhAdO6xStSuA
Date:   Tue, 4 Jan 2022 11:12:10 +0000
Message-ID: <20220104111209.2ky2n5gdqaxzf5fh@skbuf>
References: <20220104101849.229195-1-horatiu.vultur@microchip.com>
 <20220104101849.229195-4-horatiu.vultur@microchip.com>
In-Reply-To: <20220104101849.229195-4-horatiu.vultur@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82815b58-3ebb-4eac-74df-08d9cf730d8b
x-ms-traffictypediagnostic: VE1PR04MB6701:EE_
x-microsoft-antispam-prvs: <VE1PR04MB67015AA6BA437FA1D0C534BDE04A9@VE1PR04MB6701.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +P6hgKPTqd0b4NaOVMCIVG+78JWi8tLNbbhx93yPwUhOUm13jrCgtvWSQ7hlcnhNTgiJv2W9dg6O0rN4vHrmIXjcl4iRQoAFfWz5mxnLQNo6FDd81P45xI5oIcul3Fr2Kuc32kKCZZRp0fk53ROTydhzj1xBniGYFn6ibiU2Sf6vHI3LWejxZrJ/jJbyszgxrUlEGAvl00hOUslRXquaUgFLM9KSoFOdOrD0/G6QPmjtwih+EshZKRhFkMx7e0rezoHA+cRQ25W8N7iu0HIE65gA8SevnB1kY1yFrELdovzICU7lMnqB3Ya1zv1sDEXySPeKhVNFKOUBPIpRW/mISF6BOREzfoVzH+cAmt2NjM1SQ7Uo9LoIS33XLr7xe+dgXsxTCyMyspXhLHl167usa4YwbIOalo/4NXEU/B3mgqYMr5q8Ze7fpFRb7BjLNW7g+KZvhOmdXkKNe3ZLrRzYMRQOTM6xEjj073ykYNXUgyROfGYP9bYbbRAnbRryqUu10l4piMTs7eCY/sMwzfBJ4gHOqaCDK/de4Fr/XlDXLXa3ZgCYUe+nmnTZXMuHPz2NP+1SlNXFqZQqKPClsKJEH7qwbDfTxDwPWeg9WglQnalU3vgm4bs8cmBGkK2DKp9OOs+QeHfMblbsjZ3RaDzS/Msdy3Lc1LQrhVI5U2Fj2ooIed4khBML8FSMUWx9odBbPiz0upOiFhbuHzdzofiB4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(122000001)(26005)(66446008)(508600001)(54906003)(38100700002)(9686003)(66556008)(66476007)(6506007)(4326008)(186003)(316002)(44832011)(86362001)(6512007)(64756008)(1076003)(66946007)(38070700005)(33716001)(83380400001)(8936002)(6916009)(8676002)(71200400001)(5660300002)(76116006)(2906002)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u+HgKsS3V6knO1wB4P2O9ZlVzZyGOayJHHURm6qqa/vKZd0+o6vpGYTSWcQV?=
 =?us-ascii?Q?5tKsdCwcn7XHlLfctOz4+SAvQIJkbkauRHDdmpZGlppLyOjOi8mZWJt3EO/L?=
 =?us-ascii?Q?EetAgK0F4n32Td5JVi3zWEdYniPUPrsVaGDcpLTo+1uyENggXcVuc2zmDdTc?=
 =?us-ascii?Q?h66WEMg/YdOGEq4AKDTPsmKG/fqFdugfLTKOLEBmNa4cMLLNKZFP/gFW0ehZ?=
 =?us-ascii?Q?w1qgAAfqGqNAGjGfU6N4apT0G0yZ/+bFXE3d+mcahZZboSiZ+lPE3kqAmeQs?=
 =?us-ascii?Q?6jyG9p9Ii/Y3dOiX9C8RaovqwBBKvMxqhTfC9bFKNtZEh0wGQ8Ob8cmjdn18?=
 =?us-ascii?Q?tWw1gzCTNhI/Mm8CBPjujb/Qx7fmgv79cWCvXEr+dDhaFRiwDorlHp3FmSJe?=
 =?us-ascii?Q?tdhhbA8Z/Q7W2oUSe61iTa8lZLob3eSxPfTHUJcIdsqzeqa2Jvukd0aEPT7S?=
 =?us-ascii?Q?6U6PNNyWtnZMMgFffiDntfXuRkOjVm13y0fey0ZRj6nm7s6rdZqlvVQj9p64?=
 =?us-ascii?Q?SuPTec8cst2L8gfpDQeZYiZTpDPIMvqnnGwYfM2OzLyFpLnNxcYinG6yw2cB?=
 =?us-ascii?Q?nY7/TfaMrfS/PW5vMVRoJTsVKcRJ4KFF8Wr0whlUbebZ/WbRYruirDnd8Lu/?=
 =?us-ascii?Q?aS9JWGS6nZl7IgG13kZA34A9/x8BxPMBIPcrj0uLgFD1ve9OOWss4FYrAw0R?=
 =?us-ascii?Q?3VPgHIA+BpDgYiQ9U/vR3z0cMpYGkIAA8yo+6V5sCCKZ+b6FvFbKSLw0Kj40?=
 =?us-ascii?Q?U0DeIGKSQEEoB4GWg8jmyBD+wc7lQ8+jhFeHxyVd3uX2QWzi9nGKp5wUVw8c?=
 =?us-ascii?Q?diI5GvgEzqqT5glqMA7De/6nKiVgb6xOUPQvfgQKbJxfJqq3EfNUyaCLPQOm?=
 =?us-ascii?Q?ebJiZxplz/U1uK/nNAvbtjnG3Gfnv2lKui98sydQAW5DhXwDQjyRySz2GhhP?=
 =?us-ascii?Q?l9vx+AgMYF0N1ky4D96COL7AV7d+C31ecWiYYJ63n9DU4CuBcQVRfG86wFgd?=
 =?us-ascii?Q?+kq8ue8925HA+FVk/Zhc4bI4AtakEE7yvq1+uSOOteo3hQXfeO23l636GaJF?=
 =?us-ascii?Q?SPBowkA5fF5Au9tIXlj8E7ow7fgNYVqQhUrZ2SeSffPE0VqQS8qBdkbdseAu?=
 =?us-ascii?Q?dvGKYqIQvCQdDrcLkmN91sRULttnuE45tJ4MlT6JSpN0g+QI37AMdQXJswR1?=
 =?us-ascii?Q?+ughmzNQ3z730mQi3vzeC9zTvgmsLjRYXDr3h2AjFwA0Rt7lanpSoacoQzF3?=
 =?us-ascii?Q?ETJcR/B+NUu+2Po9LrdNSXobv3u9YZA6sgzMaV32JgabNoy4kYxTWiZKda1+?=
 =?us-ascii?Q?yFDI/FEq8EgU30exgJxTmyyO620MUzqRM+UH0qA7PtPwhwBdJFgROQBYnWAj?=
 =?us-ascii?Q?Af2QTaysL5W60NYKPUuISSNT+aIa+1QIgSINQfZNt8ux+f2Hv1eegit3exzl?=
 =?us-ascii?Q?SqC2Y1rTy+nCoNpsKzJRrE8KOdDNspHt20AVsNE+OxA9Yg/SncmXuuGigW9d?=
 =?us-ascii?Q?qP04ZSyiVo7UIu+NOMjCI40NY47QhFRmoGshKfxL4Y6RUiQ+FPykm1qUyiFW?=
 =?us-ascii?Q?kfAv9NXPSHZCFr77I+3dOM03qn8rROTlfDYWYlS0J6MOjdKw78oe4wlDtxkd?=
 =?us-ascii?Q?djIf7ncIHv2ggkkAIcVSfXA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <38D15186E08F85428CEC08ADAB59DFBA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82815b58-3ebb-4eac-74df-08d9cf730d8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 11:12:10.4130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p3LPSX/lRg0Dd25IxsnucbksHG+a2alqXW5Oc5qgI/cv4MY4UrWRvcnX0mnZAlVMx+G1fBEbpnxs8dG4/7RW5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 11:18:49AM +0100, Horatiu Vultur wrote:
> +static int lan966x_mdb_ip_del(struct lan966x_port *port,
> +			      const struct switchdev_obj_port_mdb *mdb,
> +			      enum macaccess_entry_type type)
> +{
> +	bool cpu_port =3D netif_is_bridge_master(mdb->obj.orig_dev);
> +	struct lan966x *lan966x =3D port->lan966x;
> +	struct lan966x_mdb_entry *mdb_entry;
> +	unsigned char mac[ETH_ALEN];
> +
> +	mdb_entry =3D lan966x_mdb_entry_get(lan966x, mdb->addr, mdb->vid);
> +	if (!mdb_entry)
> +		return -ENOENT;
> +
> +	lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +	lan966x_mac_forget(lan966x, mac, mdb_entry->vid, type);
> +
> +	if (cpu_port)
> +		mdb_entry->cpu_copy--;

Can you code this in such a way that you don't forget and then re-learn
the entry if you only do a cpu_copy-- which doesn't reach zero?

> +	else
> +		mdb_entry->ports &=3D ~BIT(port->chip_port);
> +
> +	if (!mdb_entry->ports && !mdb_entry->cpu_copy) {
> +		list_del(&mdb_entry->list);
> +		kfree(mdb_entry);
> +		return 0;
> +	}
> +
> +	lan966x_mdb_encode_mac(mac, mdb_entry, type);
> +	return lan966x_mac_ip_learn(lan966x, mdb_entry->cpu_copy,
> +				    mac, mdb_entry->vid, type);
> +}=
