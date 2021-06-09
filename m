Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4E1C3A0E7C
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 10:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236851AbhFIIIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 04:08:01 -0400
Received: from mail-am6eur05on2055.outbound.protection.outlook.com ([40.107.22.55]:10354
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235910AbhFIIH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 04:07:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b9zWP+a6uSYmKRYpw/w+4zuOV0+16T2j3UiiwyQUdQiS6eC4ARfPyPtZZUAmt1g1Kv285zVAgkxFoeix0GjXabTzeni0YCd7GK8tDvagHlN3hB2Mf1NctGF0b7RN6dlqZvCbKAE7RzX01/OzzG9vjYpvb7Yd68cR+WykUe1qY42MHlYKXIKUi8pB0JrosYibnl/VfkiCVJSGg5mkPRzsWySQ2r78tfx79oRi/IRV33MvI+sJ1a1Xxs4uMSwD/60AYiqRPxAbHkOWCrQs9+MnXUDmJcs7Nc+0Ea0CqKcxfjYP9Uay6UMkuOa5hk+dIIWv+jG6tn5gnEqcKfYXPBlrww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjO2goWVp3+yGxeEkDvuIQGPo54j04mAqxpaAI6XTAo=;
 b=Wtn9kq3zS5iPOE90XHH8V51QswqRn8Tt4W/H/djil+1U+iWt6GX1VQ9Ea1HjcFdogDGfQcmhz71tBC63U1Ymk2KbLaFIeGMac7q+SM43pweWTkHptkLV4DUqgjGz0sTtURC6X7IMet8Dq9he1GUiaMp28ogbT6VPrf9WyOTp3IvhM5EXy3UsoCo5qc+m1FYl4QdO+YmFM7mogdg+7qOaj8nUA/xMRyhtPsgaduQwoCPq1GICYKr1N8b1NOEC/ii/z+l+PTQsh8Cfy+NmZBYYXHogbZDe03TXF2mpEpdum6hKsYIj7cPlCGJ8QXk6sc5+C4uvZHlDeQQ5Sr559uCKWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DjO2goWVp3+yGxeEkDvuIQGPo54j04mAqxpaAI6XTAo=;
 b=H2u9aQk7Yj+q8MhbTdVHbbez66gWW7QA3yHQ7Jm0qrqpEJkdhaIOaG7IZdg3wxvcwyleTMI+vLyZZ1KeLTfr0T+l7gbP4SrqpKlYeG/C5t3vMtWnbH6AJqiKi2JF4KTWH9p/0qzNJer93Jb3fCX3fkeQbK10UmvEpN/JPJG17HU=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DB7PR04MB4522.eurprd04.prod.outlook.com (2603:10a6:5:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.25; Wed, 9 Jun
 2021 08:06:03 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::b463:c504:8081:dee5]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::b463:c504:8081:dee5%6]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 08:06:03 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Po Liu <po.liu@nxp.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>
Subject: RE: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
Thread-Topic: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
Thread-Index: AQHXQzswpEDnn4xhQEy35Y5IB0uagKsImWwAgALnfyA=
Date:   Wed, 9 Jun 2021 08:06:03 +0000
Message-ID: <DB8PR04MB5785C5BDBDD51401362563D6F0369@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <c7618025da6723418c56a54fe4683bd7@walle.cc>
 <20210504185040.ftkub3ropuacmyel@skbuf>
 <ccb40b7fd18b51ecfc3f849a47378c54@walle.cc>
 <20210504191739.73oejybqb6z7dlxr@skbuf>
 <d933eef300cb1e1db7d36ca2cb876ef6@walle.cc>
 <20210504213259.l5rbnyhxrrbkykyg@skbuf>
 <efe5ac03ceddc8ff472144b5fe9fd046@walle.cc>
 <DB8PR04MB5785A6A773FEA4F3E0E77698F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <2898c3ae1319756e13b95da2b74ccacc@walle.cc>
 <DB8PR04MB5785D01D2F9091FB9267D515F0579@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210507121909.ojzlsiexficjjjun@skbuf>
 <07b1bc11eee83d724d4ddc4ee8378a12@walle.cc>
In-Reply-To: <07b1bc11eee83d724d4ddc4ee8378a12@walle.cc>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28d66786-6214-4400-fc51-08d92b1d6d36
x-ms-traffictypediagnostic: DB7PR04MB4522:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB45220F49EA78FFAA054665ACF0369@DB7PR04MB4522.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u1isYf2JKMLsfxe4QtgqlBJtkht/4/KHE1080kd/Ev09LHQ3iK+nO5wiFfHyyEKZjpUv8+WeEn/T64Crr4v4BjcdFFcvu8YO1XBryydhWnzdj4w+gBxQ84iq7srgr+GEprS77N7V5vV3XIR2Qvd4N2muaxeZ6dlnR5TukYIW394fjdTOR9zxBi8n6XAtnUUhnm6t8IHqw1xjk/Sv3g/lfrj/3rUp6XMGZ6XKnPmrggumItS2FDYUshE4QpvY0VqP//PB9i3zNyIqHi1sYJFzRB5n9f1xLwu4L5UdVA+34ZWa5+4e+UYZGdQST4cHZvTuffUnijZhMKM+E/wC7AZKsCz/IxCZrvSVP7NreqIiWM+234pQY8BeySRqoF5kXbe6p4WcevebnvzWzPbOrzbB3l6nbj7FmF5pWuTJ/M3DL821TbB2gaAq0/5+/e3xkihvlrS8z30cqaFBc209PBqI0VuWcRVQO5hynJemX6JJF0y9/aXn5lWpSO3mcxZGVfjnfhbDx2jlGTsX3OEJUtVgEAJib2jG/5AXzBINwiE0KA9Ak40f8hlir3JXRWUFoagahtXos3VA6qIYfPrBqsHI7Zxsfe7CDWeDVTePfkzpWos=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(7696005)(53546011)(478600001)(186003)(26005)(316002)(76116006)(66556008)(6506007)(66946007)(54906003)(66476007)(8936002)(66446008)(4326008)(64756008)(86362001)(52536014)(110136005)(83380400001)(5660300002)(38100700002)(33656002)(2906002)(55016002)(71200400001)(6636002)(9686003)(122000001)(7416002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4/2G5RYXnqyIcHQoigksYDYF4R8188cli3u6R7WyvQjPQLnLmox0GpESRK5F?=
 =?us-ascii?Q?ErVUpWmVqBWcDn+2fFb1lbb+EYt3gmZ8R8PbPoFwBfDvnRO6zTttf64b0HZn?=
 =?us-ascii?Q?Cu/dPCZ1sWbksskOqBGN5COJhD1TQrLEUtH3p3y0LVFmsXaJfNvukdP2ox6+?=
 =?us-ascii?Q?FpHkfgaGrCUAonF4bL3hu0cQ8gzZHaF3cDUWFVoBmVwisWM4kxI3zhrD2KDr?=
 =?us-ascii?Q?cSYgbFPipENFd3aP3bmr2nBNzTNlZ1JWUJ8g06n9bRMlLYMrj/IyRKLcUNHq?=
 =?us-ascii?Q?fSVTBC6/UyLT51BuY1/vNB0MJLwgPbovKBXjrUTCeEcqkPcXJuaZSBc6++09?=
 =?us-ascii?Q?WQ7EstR1dQx6zCHqrufNhbSJ3NndSsC3WPlDGPYMn37CJ0BT5FE7V3/PvF4k?=
 =?us-ascii?Q?RHMvmDRLchRV1F5ezbFYNGHX8v4n4Hf1C1+4N3WXs6rSDtZGSRVRFUsFGvFo?=
 =?us-ascii?Q?vUYRnpssThppRiEXudafKexmo2gsGYnl2aASz+zJb/HQlaYkJHsm7cCilD5l?=
 =?us-ascii?Q?uKL+RVKkM+sI4M6yYMHzaygO0FIoLcvnP4rzCX0o+tsvA5crqjsIzSw80kDP?=
 =?us-ascii?Q?1A0iDdVZjPHySNHW2AfNnFR3txQxz04x9tqhSjPmm5k35fbE6Z9P5VBq/Fco?=
 =?us-ascii?Q?TzTvvyC28lNe4bhyNY9Jwm3MEvL9gEFKeMe57Jr794LW4KTMG5BFJKU9Qi5Q?=
 =?us-ascii?Q?Jrf6dz9bqGMbap/A+7aCkc70TZvkUiRPZHTOPJe9Kwsbjqf3XpB+5klqRe23?=
 =?us-ascii?Q?V/lkul4rbetInXkY9rlsv6VBZ3ltxidxsMB6ipSEedUV0Yu6uydtr1fW0Yce?=
 =?us-ascii?Q?KkpGN3ODcDUN/G1B4y4NfQoEkXNnemv7iAFm5dmM0hTg/emPVd8wXTin5D3A?=
 =?us-ascii?Q?YA0OdV7lxRSkRJekbToOzZLVBWg2jUSeBaZV9ccTQEQ2Ur2mzPonFlUVnhDA?=
 =?us-ascii?Q?f98dnyMvuObPnch46YT4E4oERfmDvLSYMUKC+c2uj7komnmB0zw1Ww1ph301?=
 =?us-ascii?Q?53JmDN6uwKT1aqLKToei0jcgDsFri1tq69TXf6F/VN6NQNEwXzXAy59cGFox?=
 =?us-ascii?Q?sQv/FkoTC8tNJCMPsb9K57GFXo7x24ntAyslEFkUTiZasn5MilZOM87LzOqS?=
 =?us-ascii?Q?87Q/+xe/d79oWl7S1fVEY8lAI8l/hfip4CpP9gB5WJQRBMmaDm0NWiDv0KsA?=
 =?us-ascii?Q?ZFRT1IRL3l+fj5nU8wQ3AyS6vALs274lTCFgncH6kO+OWjJC0fD/yp7ZdrzM?=
 =?us-ascii?Q?J1JTYZ1mvvxI6fBfaWjHIQNazbGI0FkRR40tpHtFgf25nkGKEiYlBgdOTR6K?=
 =?us-ascii?Q?H/EFl0AHnSZhcOavUKhUgbPV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d66786-6214-4400-fc51-08d92b1d6d36
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 08:06:03.4892
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jih+4+0REi1F0glhEJyX3i8cD7Y86rDd8/lhu5zw5Nspdbn9fXcgzmpYwAu+V9SJHRC2Kv1PDR1KVMCAjh9+fVqwZZQypLNu6aZufNbXdmM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4522
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-06-07 19:26, Michael Walle wrote:
>=20
> Hi Vladimir, Hi Xiaoliang,
>=20
> Am 2021-05-07 14:19, schrieb Vladimir Oltean:
> > Devices like Felix need the per-queue max SDU from the user - if that
> > isn's specified in the netlink message they'll have to default to the
> > interface's MTU.
>=20
> Btw. just to let you and Xiaoliang know:
>=20
> It appears that PORT_MAX_SDU isn't working as expected. It is used as a
> fallback if QMAXSDU_CFG_n isn't set for the guard band calculation. But i=
t
> appears to be _not_ used for discarding any frames. E.g. if you set
> PORT_MAX_SDU to 500 the port will still happily send frames larger than 5=
00
> bytes. (Unless of course you hit the guard band of 500 bytes). OTOH
> QMAXSDU_CFG_n works as expected, it will discard oversized frames - and
> presumly will set the guard band accordingly, I haven't tested this expli=
citly.
>=20
> Thus, I wonder what sense PORT_MAX_SDU makes at all. If you set the guard
> band to a smaller value than the MTU, you'll also need to make sure, ther=
e will
> be no larger frames scheduled on that port.
>=20
> In any case, the workaround is to set QMAXSDU_CFG_n (for all
> n=3D0..7) to the desired max_sdu value instead of using PORT_MAX_SDU.
>=20
> It might also make sense to check with the IP supplier.
>=20
> In the case anyone wants to implement that for (upstream) linux ;)
>=20
> -michael

Yes, PORT_MAX_SDU is only used for guard band calculation. DEV_GMII: MAC_MA=
XLEN_CFG
limited the frame length accepted by the MAC. I am worried that QMAXSDU is =
not a universal
setting, it may just be set on Felix, so there is no suitable place to add =
this configuration.

Thanks,
xiaoliang
