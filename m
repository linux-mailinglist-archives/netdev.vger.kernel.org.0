Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 920D1365625
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 12:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbhDTK3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 06:29:20 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:39650
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230264AbhDTK3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 06:29:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRDNQvLmt9IfOYydr+a/GSmh072MvGxAcNicziBoTaW7xqtEbCuDCgfP/cupPHsFXPZ99LfQSEiAqb+BSGAZQc6dqxOKH/+8MznmR/lMfpGJc1fg++cC08c5CQv+TZO3LBp81nbv8+VG9/OIctWK43rreQAzvx2xRYQVV/Np2xdamLlT9Eznt+owpFqOHmqauylN6f8bcisXeR8/VJHfa4qlBzOxEBmSy4HdY6GdpSQIv3HByeokzy4TjRHLiQyffZNBLc7GC4N+nMqVkZDeRrReVz9NOEyWsHd2d4UaBACZUQc8/QV5J7ZNYtwCav8O2ZsA8UWK5JyVIfMrk+X1jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7F88GfJyJSE7OqncaD18RyEXtLc5uS2n/K6qdXx+wJA=;
 b=U4Zl6JsD8dfSucRdF823NsrPizkTjm5aouUv1OGUnmu9BLB6BA9QC9kFOL7UEjDcGNVwMs6xabM/0DUZgEKcEEsDE533KpA8lBWiO6s+cIw4lJQCa32qPai1dH5rFtXxgsilF5L5syLLARDeXm8TssJf7XnHIcadVCnpwvix5EGSQzMbeA0YOMWard1qdLe8gDHuu3qcHc8mt06kzXqEQPmE6GRY2F9Pc2Kphhrwv6ADC9F9S16pYGdV4giIWSF4SQM+YUvJzid9G9z7kXdmi4KMm31EakqUQczuN4N7XFT0hSry1HKH87yolK7tFonM5+myewtSzLdegSB00R4qRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7F88GfJyJSE7OqncaD18RyEXtLc5uS2n/K6qdXx+wJA=;
 b=BU9nXA0w0Ooi7O+HzrhLwTvoO98b780o8pOPk2eAEhPV/1woXSeBa1zIbV2GFa9m3WcR7QIm5kkuzhjwbwbmfPTHBTyGhkF3kTaP7GminR/P2PceOQOQxjZf/S1B8XPtvOfLPt9F9teDorYaF1dPS0kbVsBJt2BEHVffENLH68w=
Received: from AM6PR04MB5782.eurprd04.prod.outlook.com (2603:10a6:20b:aa::17)
 by AM6PR04MB6231.eurprd04.prod.outlook.com (2603:10a6:20b:71::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Tue, 20 Apr
 2021 10:28:46 +0000
Received: from AM6PR04MB5782.eurprd04.prod.outlook.com
 ([fe80::8c4c:a6f6:3e91:2a52]) by AM6PR04MB5782.eurprd04.prod.outlook.com
 ([fe80::8c4c:a6f6:3e91:2a52%7]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 10:28:46 +0000
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        Po Liu <po.liu@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
Thread-Topic: [EXT] Re: [net-next] net: dsa: felix: disable always guard band
 bit for TAS config
Thread-Index: AQHXNQV6cbEkHp2uw0G0oLH1EhbdIaq7x7yAgADvIJCAAFzVAIAAAeSw
Date:   Tue, 20 Apr 2021 10:28:45 +0000
Message-ID: <AM6PR04MB5782BC6E45B98FDFBFB2EB1CF0489@AM6PR04MB5782.eurprd04.prod.outlook.com>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210419123825.oicleie44ms6zcve@skbuf>
 <DB8PR04MB5785E8D0499961D6C046092AF0489@DB8PR04MB5785.eurprd04.prod.outlook.com>
 <20210420082632.3fy4y3ftkhwrj7nm@skbuf>
In-Reply-To: <20210420082632.3fy4y3ftkhwrj7nm@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 167e0332-d5ab-43dc-e621-08d903e71458
x-ms-traffictypediagnostic: AM6PR04MB6231:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB6231E9585A77AF4DB6B55DE9F0489@AM6PR04MB6231.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kPbInWlTqaA/hFcgSBBtn8R76iPkUZsLQunnfOteWtc8Bfs9nW5yDSR6FnZ06fUkX94iAFJB08zlaippAeTenAxJmsLAkMwj+jm0ybk2K3W4lwfA/Ly4rZBfDGgbHAZPwqdpEXQYRrNumgAE3HDaUVzkYC7FyxqAXL0OqhYSpYr8YD5KwsXKU46rVxto1jx5Utzt7reIUcXHKlv/ph1ZPEqkde7ufIxwHCqoIw9r8KzxKGP5N39oCyzayhXzjWY9UeojbEmDbMQaKkGm3IS+MSYRhiBU7r9okjtIs0+v2LyEdBir0m/0zfudPoyfnn3jdHuH1GPJoYM83fm19tIE3etttoYg5gErQo0M0OAzfhtmbDQTLhTpt1R2kmGNkDrJk0QzX/0Fa1YpgXWn9GEvQxsMzSDy1+eigt7Lxtdo3ZDS21QQdyEHxhZmVcF4g+h5KVs6E3hKZhEsoEUzdQbt+Ol0FSpixx3B8U1NnA/gRM2ZyrvSIXZJ2C2ch6zj3DBgHNr6NlNHIh5B8JbiUaU40rNzYb8jpE65Fqa9tQj71cafz4ADq3+6gUAs8N6IImDST78BpxotOmiYfJSybqMrmzXlaxrh05R736V/xdOZluU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5782.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39850400004)(346002)(396003)(136003)(6506007)(5660300002)(86362001)(52536014)(71200400001)(186003)(6916009)(9686003)(64756008)(66476007)(8936002)(2906002)(54906003)(316002)(7696005)(66446008)(55016002)(33656002)(38100700002)(8676002)(26005)(4326008)(478600001)(122000001)(76116006)(7416002)(66946007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Nw0NVmSqRTJlMBoGFTX7Rexo+MROz64R2DqjYKIkKDk762zlkfUHq67HpcHR?=
 =?us-ascii?Q?VI59gVyZOh8gOSyDVwNcfyY+RgubDixKGly+TY/hAcVlOje4c6+VDSjmrJFt?=
 =?us-ascii?Q?Vo6QL9PTI9FwQYuLqz5ooX//ZLBnrc1rMNarrAqb/4YP3YIm78xCDtmdpv6C?=
 =?us-ascii?Q?xl7/9RMPrVoPMMlJoeeatXS3Zm3UP4LBJF3U01SKwHetvY/DFWsJGGjQYdvL?=
 =?us-ascii?Q?/UGOusBVevO6V9ey361IMjxrJOxfXwd8eOQsAuzB/5u3bfQZu59sYjdHb1NX?=
 =?us-ascii?Q?08nzPi5kXdJnavuSkFxS5I4MN+MGunyvaWKgm0sFYr9LBnShj+M6Z+adqyik?=
 =?us-ascii?Q?/6OM1tVMkNjy/ahU4vKc4kkartt1SLDTQA0z+jiChRHQboRum1ViHdH01wOw?=
 =?us-ascii?Q?BpRT31JqMTT4qv55B5AIoPfDlkg3tnzK7IyGX98rbyZSytRj59m7nuVaeWxb?=
 =?us-ascii?Q?c+HQWx5QSEWYi4yTPsGcd2kZl+DfPPy4/Sab0lG1uhsA7PUXKk9ZSuFR5IDF?=
 =?us-ascii?Q?zC566XAU7QdADPeGJFGweczchEIjpRBOoXZwiPxyGboZWaBSJ8HnGTy6PDOJ?=
 =?us-ascii?Q?4Burrgg8XhekhYhfn8irx9S/xD/GALo+wjJNfyQkn7PXx6W5skKpgOw5DwLb?=
 =?us-ascii?Q?rbFJlom2eQ9oADlCspJ/BxpeVViuIv6nCDDSmgwY+tSttmLXsYGbt9oGifAA?=
 =?us-ascii?Q?ddax1hfZiJqQQOaechkM8UhzEgB0GYwGdKQ5kzDlkJ4zV0k19QXvXeQ9e3EQ?=
 =?us-ascii?Q?32Suc//igDswGXSi0YSndPf8NX3PNLQ+SSrWQpWQI0mwlZtK9Xy4NUlQjQE9?=
 =?us-ascii?Q?F1kQLkVt0SVxzQYbKF+DZ387c0SZFBpeLTTcII8ztApWTIHDwMrLTyVjkZSG?=
 =?us-ascii?Q?xEMugJX5/8BjhZ8qDj+AggOyU3XuaE/eB+2gVntSw+klABUWwhnVi1qAKIcP?=
 =?us-ascii?Q?IIiVVWWAaiURb8xiHRHlYOXBTF+rB/GrdmPW7mZ12nawgVqadEhc3uoxujXw?=
 =?us-ascii?Q?dab6tml7vzEuK2Nh8askhKemzFJf7o4hAq7/ZeVHm5bzZOZOkSgSIB4/Xk9B?=
 =?us-ascii?Q?9FbvijtMUFl0aMdlBlBv1WaRl4zjTnEZd6y2a8iQzTsnP6nHnAMftQ2htdaq?=
 =?us-ascii?Q?1A44xr+ilbJDiFOn3SXdogRSGgQI5hPY16BCt4dZ/UvCHCxzqPgI/sjU9+N2?=
 =?us-ascii?Q?CyTj1/d2pE/ecFqhxMFx3J5I72B13keoddiLnzw2u86Lhxhz75WgR6hfatzk?=
 =?us-ascii?Q?w7eh2+wbJ4daaZc1Pd6/pEFkVmE5Mk+VnQx1j02yOslxlt1E3ynNWfo8lZ5q?=
 =?us-ascii?Q?0f0q24fhyyFWCr/rkYEblcWb?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5782.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 167e0332-d5ab-43dc-e621-08d903e71458
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 10:28:46.1815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: njc8s00XYK18pME1rpSISYqrqW+b3Q8t0xab4ed0FjUSY4Q8yw7yeRlJo1Algy/lcKR2DZA2U8TT0Zg2d95HeRzs3uaxDyY+Zaj/JsHthdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6231
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Tue, Apr 20, 2021 at 16:27:10AM +0800, Vladimir Oltean wrote:
>
> On Tue, Apr 20, 2021 at 03:06:40AM +0000, Xiaoliang Yang wrote:
>> Hi Vladimir.
>>
>> On Mon, Apr 19, 2021 at 20:38PM +0800, Vladimir Oltean wrote:
>> >
>> >What is a scheduled queue? When time-aware scheduling is enabled on=20
>> >the port, why are some queues scheduled and some not?
>>
>> The felix vsc9959 device can set SCH_TRAFFIC_QUEUES field bits to=20
>> define which queue is scheduled. Only the set queues serves schedule=20
>> traffic. In this driver we set all 8 queues to be scheduled in=20
>> default, so all the traffic are schedule queues to schedule queue.
>
> I understand this, what I don't really understand is the distinction that=
 the switch makes between 'scheduled' and 'non-scheduled' traffic.
> What else does this distinction affect, apart from the guard bands added =
implicitly here? The tc-taprio qdisc has no notion of 'scheduled'
> queues, all queues are 'scheduled'. Do we ever need to set the scheduled =
queues mask to something other than 0xff? If so, when and why?

Yes, it seems only affect the guard band. If disabling always guard band bi=
t, we can use SCH_TRAFFIC_QUEUES to determine which queue is non-scheduled =
queue. Only the non-scheduled queue traffic will reserve the guard band. Bu=
t tc-taprio qdisc cannot set scheduled or non-scheduled queue now. Adding t=
his feature can be discussed in future.=20

It is not reasonable to add guardband in each queue traffic in default, so =
I disable the always guard band bit for TAS config.

Thanks,
Xiaoliang Yang
