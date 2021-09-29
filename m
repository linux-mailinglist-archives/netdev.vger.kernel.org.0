Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E8641C2AE
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245491AbhI2K1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:27:43 -0400
Received: from mail-eopbgr30065.outbound.protection.outlook.com ([40.107.3.65]:18750
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245324AbhI2K1m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:27:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S4pNDjkjgFiCaVQSJyYzI+nE4khuG+Q1OIMVjhNrwRQG8sXa5HwcsRYfC1Wzb7UjA1VDQetCH7Sd/GuHrtsB+rkzUwB1dqHH1bCxkwKbhyWWAd3sfVzqZoXO9NllrPDPwH16Knuz4rQVihw9sGk/5Wc3IaBmPcX6bzVdZjpRnqYGHT4W6evmqlSVEttqHoOKBNLKGM4bUyXL8ZxDZjuRqJdKkc45LWzgDzQTwpP2rGz/WapweFbXiOIgs/JTw7ZitUYKuYVdIUrvW5hhvXJzrXOJl972LGAZor9HrW6JOKltUHZOHQ1WDjwFC6Nuu57uoeHekn+4wzB8W4hUgEed5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TUXMraBVpLqtXzorxBMnik23BpBy0cD9eM0FrPIxE58=;
 b=Nsnck0mQlxRXBud2m8BMy5KdW+eoDpVSzKgf3thtxygQVjiIuKvOLqsmY+TpcvC2g5+zHy+Th/nbxUma7mHL6JZ4whZlBiSmZeP8GrdlYKHWE6yaJfMGzOXkXU4uiFtNNIePOZZ9OeLkqGmiE9ujI9/kTPfS818wcPK6Sw0fL2JlX19mtQREgmRcFYWpmkRqLuwggb++syvyh0Z645aeOBZJ7F7KwFrVy2pXUXNwByCZ1/VydHHJiLxALpr7QrmN6k1pQHsFIvSgCOo37ZnmFwF8qfcNyKSXWHSFvoCOFu6IUH7fjZLaQuYYMXZDbBJm+jM2TdvqXi+FSIrKHgdxxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TUXMraBVpLqtXzorxBMnik23BpBy0cD9eM0FrPIxE58=;
 b=QDRFS67frdxw84eyUT3leRyijNd6unKPHnFdbfF3iezbAXDL0MTWsh2wnyR/1/CRI4nAj57NkLKd2s6R29+NEXWvcVPEd2COL+G6Q6yuf7vsHCqP5Nrp1DuRFkoxSTL8l3ZH+BcXwDF+Un69oaoGuo92oD0od7ua/gOTFHwHgWg=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB8PR04MB5786.eurprd04.prod.outlook.com (2603:10a6:10:a8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Wed, 29 Sep
 2021 10:25:59 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::7c1f:f1c4:3d81:13fc%7]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 10:25:59 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>
Subject: RE: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
Thread-Topic: [EXT] Re: [RFC, net-next] net: qos: introduce a frer action to
 implement 802.1CB
Thread-Index: AQHXtFzn8xKeuQxfIEq7ve+HgUSpr6u6CVIAgAC5+yA=
Date:   Wed, 29 Sep 2021 10:25:58 +0000
Message-ID: <DB8PR04MB5785F3128FEB1FB1B2F9AC0DF0A99@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210928114451.24956-1-xiaoliang.yang_1@nxp.com>
 <87czos9vnj.fsf@linux.intel.com>
In-Reply-To: <87czos9vnj.fsf@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3861279-166e-4711-6e57-08d98333879a
x-ms-traffictypediagnostic: DB8PR04MB5786:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB5786E1D31D77F0B94D37AB75F0A99@DB8PR04MB5786.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4Av9vjk+v64NaxuwzyhHG+MoX9htTAHZU8pajzjL0O8HzHnG2BEqpGGradUsiBXzZ/HcrQPUz1X4vURzsuW4VC5bPLEp+Zw5h24RLdCSVJyE+RvafCmZmY6TCz227uyBPq4fPHmm3b7PC9+1s7a9HGIzCIMmVhC2IX0FdmpY2e1baXU9dS/bcqy5EVmhyf5QpFBwlbv5/3lUbeWd8FwNVAkRFJdASnQUnf6MUzJ3sGBuCNjYJCoXhgCdfdv9GgisLzwBFKfNJnMErCfzSgefX44SXPnScP9w4EDVByQf4R391Zg1/UfZng5zxbbtT54VCUH/XiZWtzvZlIeBEPwSA6FLr/ynZ70ga4qDgmAIvEDYPWPcFEzPeK12biqpREgbrCplBCymfbEzWG1YemnWluVSbVrjqeZDQp2uvucpdqjNvhJnZ7h5y70SDjc7IPxcL+bOT++hD6S4L5lPi18Nclhfm031/dJkr7/7ic6imatvvQONr7ehGFjA0ofo100LDlIdMCxnIwhzP5XW4SenFBYRMbRpC4B91I2SUTJB3wiiqQWGBLseLJx1VUIv5ZBkR2L0X8PfR+shNOoRwyvYJz+JmuL14LAWNcC5GYS84fjlhoAXZ+kTX2IAJON8qpXHMn7OqWqjvCPf7TrRC6Wm5UftwFbp0m99J2Q7L7ZouIXbORqZS4g6LeYeaTFd8I2jgLLQcFo+GMhtasu5nUM8EQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(9686003)(7416002)(55016002)(86362001)(83380400001)(508600001)(52536014)(33656002)(186003)(76116006)(71200400001)(316002)(38100700002)(54906003)(110136005)(26005)(4326008)(122000001)(38070700005)(66946007)(53546011)(5660300002)(6506007)(8676002)(66446008)(64756008)(2906002)(66556008)(66476007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Ga5lZowW+87rLTeuMr89LLCJjqyA1tTX/IE8hloBKKbJMrT9QYQp3CPRAIR?=
 =?us-ascii?Q?uRohnu/E/H4h7xFX2ERVvNj2UdwYtUucrti86EAM++4GJHcESobvnIBWUzmn?=
 =?us-ascii?Q?E853a070HWKm+Tvg2xhtt+ewwdaeCdIjaGXFdL6ay9U++lzi1UXn7FE8gL0p?=
 =?us-ascii?Q?h1BixQJtIQEK96M8nlk/7yt78mLcpZnE8oEnUXXgi/3scrRlibC6dgnRHYZy?=
 =?us-ascii?Q?Ok4VVGrfq7qlNk/VakEhyXmAAFcNI1wtQZOgDXAacW5jDH1goXTBQ32U9Wri?=
 =?us-ascii?Q?Wn7wGVgW5xLJIsgnQsTVnQxploJF4KMHZfTJwL+Iqod1DpqSo9bk8Ph2eVNj?=
 =?us-ascii?Q?tjrc4go0Cg5zvrnimrRgrfufLly2CEOwxiK6/kuRdCaSclksEfmnHrMFqHcd?=
 =?us-ascii?Q?3blsjAH7BXd8e2RPzh06tExoNzaHvDM8ombkH7g8IZ5S9ilx0hOqYsBRIlp9?=
 =?us-ascii?Q?ezjAX4liXTlhWtVP+QyZQtp9RcD6/sTzBc99FaqZJWSgVAJyPjwEr9YZ6odM?=
 =?us-ascii?Q?eeMiSis0Zko6dgnnlk4fYeNLdRK+Dc76K4v1pZQo7tDAwhCG+A3cE1nJdKz1?=
 =?us-ascii?Q?v4N26sKTjpTk6eMplvlgIhir1NXwa865f/wB9ktokqP/ktqPq2nma8WbzDBz?=
 =?us-ascii?Q?2zOpwdTFWTfvn2E4ppiOr+eMXEKJmlhipL5Yd9qsO+EvMPUt2M0phJmx0Kfo?=
 =?us-ascii?Q?9OqIY8GIWD2j75N2yAa1vMXmVCMmj8OEmVdioj3NutHM6uu2FGK1Dwu26lSQ?=
 =?us-ascii?Q?FS43ZE4GsEl9+1g8kUXWcCmkuG38v5eKJFxEyqmeEZXOjAlWVxgOkGdZ5IU1?=
 =?us-ascii?Q?9oj9e/jd/N/zIO0aUy6W1MIl4g9UNn7bvyEpf4h6aXkKkTHJ4yKx74lg11xg?=
 =?us-ascii?Q?c084bGGpNCOoT8xdP+G/1CpnO0MInN1q1b2Zq/9oSzlfIFUR7ZqFIXzQi+md?=
 =?us-ascii?Q?ZN0n5apDdY7BV7PfUcSul3OfaR304R3yGZVoIaHFWnr57q0cLhqF4H5xRxN2?=
 =?us-ascii?Q?hitFuN11xw06h/a5HW1Wtr4bQXKKiL269L3GvwVfzjiG++bhev7UkZwouwIZ?=
 =?us-ascii?Q?gYD9pi/Vs/nhAuyNXCCeMb4ZEUiP7mAl+u30pJmnozB0rtB5EtbLIjxGSn0T?=
 =?us-ascii?Q?FrxQdJceKmQ8/BMbYL9tg1khtBC3hhi0rPLAGGJ770Vr8S8/5PnRW/Skle+p?=
 =?us-ascii?Q?lmYJtAzqNHSvo64x3Fx2XwONUnTEGRzXXxlWqAR0fGPtCUr5G9nj5iTyf410?=
 =?us-ascii?Q?ZgHv/m01fQkF8hqOa2XuuXTgYXzVVIIDM7uIFYTuu/TBNPy0bUeAlnxbes0+?=
 =?us-ascii?Q?1dRGYXY4JDC3yL/V+ILryyU3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3861279-166e-4711-6e57-08d98333879a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 10:25:59.0022
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RpkwHBiZ4FqiOPMAEbxWeZoegReleudL3K+WrWIj6Vb0jE0xcq+x7BRT0SNFib91VVEd6l3WAK+ija5B77GqEY/C/jTDWuBji6nU5wNr8mY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5786
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Sep 29, 2021 at 6:35:59 +0000, Vinicius Costa Gomes wrote:
> > This patch introduce a frer action to implement frame replication and
> > elimination for reliability, which is defined in IEEE P802.1CB.
> >
>=20
> An action seems, to me, a bit too limiting/fine grained for a frame repli=
cation
> and elimination feature.
>=20
> At least I want to hear the reasons that the current hsr/prp support cann=
ot be
> extended to support one more tag format/protocol.
>=20
> And the current name for the spec is IEEE 802.1CB-2017.
>=20
802.1CB can be set on bridge ports, and need to use bridge forward
Function as a relay system. It only works on identified streams,
unrecognized flows still need to pass through the bridged network
normally.

But current hsr/prp seems only support two ports, and cannot use the
ports in bridge. It's hard to implement FRER functions on current HSR
driver.

You can see chapter "D.2 Example 2: Various stack positions" in IEEE 802.1C=
B-2017,
Protocol stack for relay system is like follows:

             Stream Transfer Function
                |             |
  				|    	Sequence generation
                |       	Sequence encode/decode
  Stream identification		Active Stream identification
				|			  |
  			    |		Internal LAN---- Relay system forwarding
				|						|		|
				MAC						MAC		MAC

Use port actions to easily implement FRER tag add/delete, split, and
recover functions.

Current HSR/PRP driver can be used for port HSR/PRP set, and tc-frer
Action to be used for stream RTAG/HSR/PRP set and recover.

Thanks,
Xiaoliang
