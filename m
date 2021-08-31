Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E64783FC4EF
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbhHaJTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:19:03 -0400
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:17120
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240579AbhHaJTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 05:19:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dz4B80xlxCDP+Ig5B3MDzpwml613hBFeFWibGiVfkshjxqtAhFXzUO9hTPdV+LQQe8Uia3jcQS0ykuqcDJbfGfQrwzWqU4W1gr5EXXbuK47dBaZol9b2s7EUT+MWsW7iYEilGZtNiDalnYLTNk8TA9tSqLm4lv+ajniQhaeIsPEOgY8X3jCZ+21DQwFH9eBRavo3rNmEEp4991hThipqfLNESC16S3UEAPTl270bvz/9CZDFmob4XxteJtBKw+0sClFqDOryuBxXi2JVwteaN9KmJTqXvjfneKkQbXa9ISOGMzLPFbutmy1l0NpA8EZlcIJgmg5XmAR1UqDVw7bNwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4RpuPVzu6Ue9vS1JRaDWuD9xU/spraGiL71k2ymnTI=;
 b=gbJunIfd0V306XK3qTs+BA9QtmoLa6rlq77pmO4FBDgdDDW87DF5pY+NnSGKcqnxix/9TKJrtGr6ZpKtdmc9pGD2waSBMkHk+h50bK4ikHe9Iv6qu/RlLEJaKJTnN975WWClAlkA9unNETnvNPGbrBZeKDfSlRu+tIgzrE6Ntq/GxrqHjxK6+eJAtIRcHPNQE8vfOd1Yln19Fwh6kZsneCjmO8dKrJf/zo/CZq8C5nJxddgRG0/MMhJdfjAt/Sy7YAP3vTF69xYxNDIxRF8WDyu6jrdRzeLGgFtn6Q5h/q+aOCgiTLAaoBw5pybwu2ip4sx1V+FrabGz6XJymYxAUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4RpuPVzu6Ue9vS1JRaDWuD9xU/spraGiL71k2ymnTI=;
 b=RXShRfzGJzswnBy66wSvDP0Vfkaics+mSek/U8Pnr5rvtlP8oHGG5G5FoseG3UrYk/kj23ijP2TBWt/u6FYXuZUprW2HqpT1sCB6WbH5jnQr1JoftLqOwMyuofEqSi6hR9YGijxuQSTdqtzjuPYc7LLvcYgnP2vPmXPIJq/wg5A=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2797.eurprd04.prod.outlook.com (2603:10a6:800:ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Tue, 31 Aug
 2021 09:18:01 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.024; Tue, 31 Aug 2021
 09:18:01 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "kuba@kernel.org" <kuba@kernel.org>, Po Liu <po.liu@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: Re: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Topic: [PATCH v3 net-next 5/8] net: dsa: felix: support psfp filter on
 vsc9959
Thread-Index: AQHXnhk3bR+2BJOkCk2OO1PW76puEquNPsAAgAANEQCAAAFHAIAAA9qAgAACOACAAALRgA==
Date:   Tue, 31 Aug 2021 09:18:00 +0000
Message-ID: <20210831091759.dacg377d7jsiuylp@skbuf>
References: <20210831034536.17497-1-xiaoliang.yang_1@nxp.com>
 <20210831034536.17497-6-xiaoliang.yang_1@nxp.com>
 <20210831075450.u7smg5bibz3vvw4q@skbuf>
 <DB8PR04MB5785D9E678164B7CFE2A38CCF0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831084610.gadyyrkm4fwzf6hp@skbuf>
 <DB8PR04MB5785E37A5054FC94E4D6E7B5F0CC9@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210831090754.3z7ihy3iqn6ixyhh@skbuf>
In-Reply-To: <20210831090754.3z7ihy3iqn6ixyhh@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16a4371f-b9be-4673-5a26-08d96c603ae4
x-ms-traffictypediagnostic: VI1PR0402MB2797:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB27977FABDCA34CA98B3E240DE0CC9@VI1PR0402MB2797.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MinfeNT1+PjlXFM0tI2CO8F7KyTYD3tWa348dFuwWz0p63LNR3JJsBf5X7lrv0GpIFBHpm4lBRN9IIVbVxQOXcEcX62fVAQtPMuHYWqDW3U9xtmWBLlveVlfOYW6ef8TmfVuHMfQ3wLPB3kw/Jgib9gZkmi+T3EQMY8UUveiZQ5TPHVi3X5+7VSNIXhZCUsmzF3AoY3IKN6a9yAq/eLAib6WoJQpnru3INKKXCCg/PhV5CngBk6PgPrtHWTotu/Sr1e6Dv399LvjuRllGF9jzd+O4hjL03PeEMoHeFvr06fo4uMvpqGOwEkTE9sromeMB87dpYSe8sbcq2rpaEa84wnL9TzjCdTLDLTgZ5bc1MfiHT6NWuJF8ClZQuhT3LUo6DbcYhfIKpyczg4p5s1ErBX56kJfHlrgiRidgcDfWrlJWg48tAymXHzei4rrWQ31p7M54NstunHAV6qsNozUEfGZTDNxlQhxq/mNNCOlKGj0NuwMCRl7skINogQUycgimqW6cj6uWkotskx+Jsr6PFV+oiOiG6YHpFFszEEUlGwq47Cb0rAEeVSPaPhd0g9lXManrxImPVBUxn2nC+tM+ODx9bIFYlWewGrtva1SQE1/lepq6hvrI+qjB+vYX5NEngz+BpE3sS99xCI7KtbXqKZ30cnBp8cf8VxV2HD58HRLDcUMPZ0A3RZWRwKcJ8yZO+9QKkK11urhN2MPbBC6F9txALJq/sHdps4KZTyXWWG8XU+R72G8y0du22wFeui5rFg5HVDRg+76ZRff9J3Gmw2c6S1bs1PbFGZM8OJ8FLg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(346002)(396003)(136003)(376002)(76116006)(91956017)(71200400001)(38100700002)(1076003)(66946007)(122000001)(6486002)(2906002)(66476007)(8676002)(186003)(6506007)(38070700005)(66556008)(33716001)(44832011)(66446008)(6636002)(26005)(83380400001)(64756008)(7416002)(316002)(966005)(6862004)(5660300002)(478600001)(6512007)(9686003)(4326008)(54906003)(86362001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/WF6oLoj9OqWNdNX9dCF3HUYCmFPgbUk6T6jB+Okw6Sf5+5r+XUJNJUYfOKO?=
 =?us-ascii?Q?qo9W4v+HA4nmP0FWDwGywjTt9zw5I+1Gt5p2hGjz6Qojps1Y2dlpwoQ6flwH?=
 =?us-ascii?Q?vwE2aqKa+4EVyBdnRrlQDwSVcRFw6b99HP8dImBR0gDse2SdvsgaFOAoRhcw?=
 =?us-ascii?Q?zw7u87T6QjQ+nXHRkkj/tSeYyDQMtnuB4gpuR8yRMdc8JdEQZIbtBQZkEQNe?=
 =?us-ascii?Q?8S0kPo75qbA6+kSpQXcrsEg4lwNxIfspU5SdFPjtv80AVT1E9ltfnQou5/CL?=
 =?us-ascii?Q?7qQhJ9TEbbufheTjlFtfMbHHCzwg8T/BEQoKxOOeQTn+ezgS2txbunJHwlW4?=
 =?us-ascii?Q?vIl0RIGVPe/fw8dV8puSIRdlcVJJ1xO4wT51dB+NtvPF2GTETwWGJg4kESfU?=
 =?us-ascii?Q?G5RTXgBQ+1nP2bW8wB/1yRU9mzv1Qm3GvTHfMy3a9rLsugXx1+ioRb+jh6/p?=
 =?us-ascii?Q?cidOpV+0D4FIRAiCVJY61Fc3mJX/ly+CUyasgIAGX7RVEdiZwmsziyzoYYS3?=
 =?us-ascii?Q?S9ESoeJOrlFh/v7EYrHmQJM68G5MRz3S6bulLJTqLoC/n7sqDR3NIQhB30er?=
 =?us-ascii?Q?Qrrn4vp49T3/ZKaO70GRXKrYLiamoinNzIOU0phIuym5qg9Z2J8/HLpl/cPW?=
 =?us-ascii?Q?6C0HuxvyU9CgyrT56Lgt3QpLmGuLW2jPMCFEKEsw5ihHRIIk9kmmSLc+KgRB?=
 =?us-ascii?Q?iSqkzzQ1mHdLzCs7C1GWb5VEEGXAitjE8SeDVE6nK9UZ5U1RdBOTGd85DxNa?=
 =?us-ascii?Q?1l6ibfgsuiFuDy+0ScHmUgrKADcrwU/92hxEsmpUQc8pXQNEBNcn7qZtYVl8?=
 =?us-ascii?Q?E5cvn7mdNTFZWzEV+RuQEAVzVpXYafsjHnh/pc2eRCGivYzZUUtAfCw5S66J?=
 =?us-ascii?Q?OZy7p0K0b1UYITXUWEIOzd4j1CIRYy4KMxslNyDncvEX3ufFE5Q1X4uHk+Tm?=
 =?us-ascii?Q?+q2/bfmMZ3VfASfPorROfq31V+jm8KTEqzW12ie82mLZEPG/V/V1RUg8F8O8?=
 =?us-ascii?Q?7dwsw8IVQAEQIn1X91w9Knn+fzyLqtBy9+1WvjB+ZutrBq7oFnsCYdl/I59D?=
 =?us-ascii?Q?jU6d0v9l1TYzMEMojE3XsvIDl0QnagE1aGy5wug1MoaeS59Wbkfs6fnNZ8H/?=
 =?us-ascii?Q?zPtMFo8crz2SKmd8In2WYhOEzt4NCjxsYbhPl3X8GEylmQo3CrLtC2iEM2P6?=
 =?us-ascii?Q?aE9mNvUjEN9N2xZq1VfaRmjqSkxsBVFHRkRfPnsMsG2wciY2awV1ovZ5OwZz?=
 =?us-ascii?Q?gAM//JnL4zLm+sfzORHOlW1aiByNvcTVJkSeqFIvWDYoehtwr2lvT7Qp+FdN?=
 =?us-ascii?Q?NItF38Z5/VZAdOGyXMZjXgMWwX8mM35fffAfwudqQAVVVA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BFDE135D8FE73B42B0305F633762DA0D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a4371f-b9be-4673-5a26-08d96c603ae4
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 09:18:00.7661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RVXj1Z5H2TefuHZtGdGSWc60nW59XlQjmt4HBiNxqVBLEq5cflz1MgWdjNSH4WklCbDtogqK1pcisQOPg0wOeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2797
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 12:07:54PM +0300, Vladimir Oltean wrote:
> On Tue, Aug 31, 2021 at 08:59:57AM +0000, Xiaoliang Yang wrote:
> > > I think in previous versions you were automatically installing a stat=
ic MAC table
> > > entry when one was not present (either it was absent, or the entry wa=
s
> > > dynamically learned). Why did that change?
> >
> > The PSFP gate and police action are set on ingress port, and "
> > tc-filter" has no parameter to set the forward port for the filtered
> > stream. And I also think that adding a FDB mac entry in tc-filter
> > command is not good.
>
> Fair enough, but if that's what you want, we'll need to think a lot
> harder about how this needs to be modeled.
>
> Would you not have to protect against a 'bridge fdb del' erasing your
> MAC table entry after you've set up the TSN stream on it?
>
> Right now, DSA does not even call the driver's .port_fdb_del method from
> atomic context, just from deferred work context. So even if you wanted
> to complain and say "cannot remove FDB entry until SFID stops pointing
> at it", that would not be possible with today's code structure.
>
> And what would you do if the bridge wants to delete the FDB entry
> irrevocably, like when the user wants to delete the bridge in its
> entirety? You would still remain with filters in tc which are not backed
> by any MAC table entry.
>
> Hmm..
> Either the TSN standards for PSFP and FRER are meant to be implemented
> within the bridge driver itself, and not as part of tc, or the Microchip
> implementation is very weird for wiring them into the bridge MAC table.
>
> Microchip people, any comments?

In sja1105's implementation of PSFP (which is not standard-compliant as
it is based on TTEthernet, but makes more sense anyway), the Virtual
Links (SFIDs here) are not based on the FDB table, but match only on the
given source port. They behave much more like ACL entries.
The way I've modeled them in Linux was to force the user to offload
multiple actions for the same tc-filter, both a redirect action and a
police/gate action.
https://www.kernel.org/doc/html/latest/networking/dsa/sja1105.html#time-bas=
ed-ingress-policing

I'm not saying this helps you, I'm just saying maybe the Microchip
implementation is strange, but then again, I might be looking the wrong
way at it.=
