Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A73650A6
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 05:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhDTDHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 23:07:18 -0400
Received: from mail-eopbgr70047.outbound.protection.outlook.com ([40.107.7.47]:48356
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229508AbhDTDHN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 23:07:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czE78zL8cKhLNS1YodL9DzbS7yfJKwRVtfwVUF3zljFfeB7eEF3/YAmBF+RibXHeyz5xzdvCLSan/IKkawAlCsn63iOvHDYZIi7IC1nqQtVociM8J9VjGFQHPFjooo9HeuIKwMegWlQtCbRKzqt6BKhRA/EpXly5h9la26VsGVISPAMDB1Jrr67GclXViVrDq0G+4Ut8x4FNHc6nuJzte7Q04otIqq9Rzvwi3lmrepz0j8vbQ9dEE078mZ/JErXtYAHb9JJ6nVUFabKW7tiZyttZDlSiQSN4RIjczI94a+01cGUtpSSeIVBL0Js4mw4Up1KqAxmlAvfMpp6S4xy13w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIcj/LSspHljyfakZ3HDelgpzlycRs1xUK9QO30AsDo=;
 b=UIrPLCB+t8ftJLIHQ7Hc2zYktw9kkMMfRxa2Wp0kTz+b8PUtYBcfjzdS7f6xoks77w4FOeQIYLOF5bUne86NS0zka6D5/M//jgtjk41gR++2IuUm/J7qjydGVvw4zZ8q7uJOE7BRbV3T7h0/MSYUwKzAzgJq+BsVFQxsDBhtGVwCVVokxbrEi7c2Q0c6MBU6ydKMBc3SkPCWZRptAeAsqG8NDZoYbCOJPb+9Lx4H15i79V2Znca3tdWFH4AyJjqLXDennM9o0b9mpDDh4wB8JMs2jAi103daZbEY9wf+3s4QF8cJmjmv9Gl4S9jQWxlzsU+XWKV5nJCU5rGyaVxcaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vIcj/LSspHljyfakZ3HDelgpzlycRs1xUK9QO30AsDo=;
 b=PdxRBO4//6Z3cFVChwVTl9Fh/9LDgIEnoHNQmXccMPbxKnn66D+Y3PpXUS2OTvBoYc5HVD1bYndizFG3xl30pnD9FGwablpHH1WxuquFGJmQOhtNu8VqyANgcr3nu6YON7SLi1m6lPLW4eQnfDitzIsp2SHLbMcd4aFggld9WCM=
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com (2603:10a6:10:b0::22)
 by DBAPR04MB7431.eurprd04.prod.outlook.com (2603:10a6:10:1a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Tue, 20 Apr
 2021 03:06:41 +0000
Received: from DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::8403:eeba:4caf:88d6]) by DB8PR04MB5785.eurprd04.prod.outlook.com
 ([fe80::8403:eeba:4caf:88d6%7]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 03:06:40 +0000
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
Thread-Index: AQHXNQV6cbEkHp2uw0G0oLH1EhbdIaq7x7yAgADvIJA=
Date:   Tue, 20 Apr 2021 03:06:40 +0000
Message-ID: <DB8PR04MB5785E8D0499961D6C046092AF0489@DB8PR04MB5785.eurprd04.prod.outlook.com>
References: <20210419102530.20361-1-xiaoliang.yang_1@nxp.com>
 <20210419123825.oicleie44ms6zcve@skbuf>
In-Reply-To: <20210419123825.oicleie44ms6zcve@skbuf>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 491e427b-d2ee-45cf-5c01-08d903a951ff
x-ms-traffictypediagnostic: DBAPR04MB7431:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB743192C03D3160A079798E9DF0489@DBAPR04MB7431.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8qdEhf7BeZ4SQlj6WG+q3/Oxtti5hH6O1U25prcoraZngoO3z6oo737InG5VG2CH7Ezfvr4+U0eqiJgiYbp2xJY6/FNugnyBZQaM1zuo8CUIqX7qxD/MOc31OTt4i/x3GkclvVE7TzVuTtRWf3mvG47BE6YtgONsR8I+Xm8+vS2HYg+oKkQn6wTRky1gCjsee2NDMEXtpGD9eMU7DYIBf2MsLSQnr/cdUdA69r52Eiyi58SL/JuZ9zOoJldZcVs9vQgnefk52dXQJD9Hrtb9uiGN+f5iGqGaC0UF+zOH+FgwOi18encQQyYwRB+qtLK1IDycosywM8I4AttNXA/twMYbYRi+cGjgHBl7mfJ9mZW4xz2oUXpyAUsP+/5KmsxdfY7706Q6Jv7gQCdtPNTVyEIHsUjg907X+YHpoysclFqBvKoV6oOTw+hvez4WahoviXJfElWof0BHSYS7dekIDOyRgmtfmE9eEboj7b/PS0VL/eonISGEptw5wlS6L+/XnYv9ovkiZPycrx9ZbLjmt1RmLxx3nqWm9Vz9ZR8liyTsBKuW81oZqmJTTj2Fs3NsH/2iT+IdS6hoyG8yRGrc18HD/RuRn9FLjogjxQU/lyA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB5785.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(366004)(136003)(376002)(4326008)(122000001)(86362001)(6916009)(7416002)(38100700002)(5660300002)(26005)(8676002)(7696005)(4744005)(8936002)(186003)(316002)(6506007)(66446008)(33656002)(478600001)(66946007)(76116006)(64756008)(66476007)(66556008)(52536014)(9686003)(55016002)(54906003)(2906002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?iCf1rWbH/6As0sknV0mrImyGF4U+wbPmUSAQIpEWiYR5Yf26U/h9vZfa9PSB?=
 =?us-ascii?Q?qC/cafQFnoYYNA+mcpy2xJ0MASmXHFjkZBDJUqLr2+aIcPnDWe60WTBd5Nk9?=
 =?us-ascii?Q?O/7GNWiClCtpzaWEIpSXWfA5XPEtXFIfg++XfOtGFVWuyjja3XA/0A/qaxog?=
 =?us-ascii?Q?5sPnSnEh0+Hzwuq3Cn3EpLow8N8FmAc7/uzx4xrDnaa7CNyZv9MC+ZxGMq+Y?=
 =?us-ascii?Q?iCxUXTGpNn6NiSLczNo/HbNxkdzynvaNircyPAofUdn83HSb34+80NcN2rCU?=
 =?us-ascii?Q?fkplcsdq0C2sIeQvTXAHcBqIbWF3pCatSvXhvtfCG/NYrEJmoeb78siBpq8y?=
 =?us-ascii?Q?nljFDEVKLAM9/qBM21IFOvIbtBoOtilX/EwwXIQSGLRI8vw921gNXS9GZj10?=
 =?us-ascii?Q?NCzsioh7/XFZZE48vDH12CjLiQER1mtF/1UeMvMGbwHV78slK/PJmM8Oz1+3?=
 =?us-ascii?Q?8ooEWseFN9syuZCvg/On3riZb1QJg50602f5JVONuhVAVb7axmGgNh2BV7sQ?=
 =?us-ascii?Q?rk/bprvTzIAUfkCpuLgYj2wvW3Tj4PyQ4XIN2oxijFLE6ipkAZtjlMKVVjB7?=
 =?us-ascii?Q?5zgAP7Ykst3Xwz9Bysm29HxQBECywkIHo2NkBTSH6lOtxlf8ZbmqQXx2nTkd?=
 =?us-ascii?Q?njsVfk8R35uN0MG9Dq9YaHSYGmvLW/KTTqPnO2oRlalW8zpBV9PSJAbudbC2?=
 =?us-ascii?Q?vrA2cXsdUhr9lVh3AXAJGZ1e/xUVCrNZ60JGBeIGORFBpZ7gozJiE+Eo8ajo?=
 =?us-ascii?Q?KLSMuLriavVCz/kI8vpEej7gYbdB4jRfxl179NrL0CWFsTkISuXXc2CF56l2?=
 =?us-ascii?Q?uHSayDGoD2banrJH33NVST22oj1Jm8ewrCqpH30bA8Hpmj3GEBa1LkSi6myR?=
 =?us-ascii?Q?ZLqj4M557snvJSgxp+Y1iGAPzh8u6WS5xT3/FfpUOWN9T7tnpt7tudBxgjdr?=
 =?us-ascii?Q?+tbeSWUu//URvgtZ5xmWRDYWbhIiVQ5OWeIgsHYWezlB+FiGa68e155PBBh1?=
 =?us-ascii?Q?hWVu/0ziINFj1jgZdSC5Z6GSmBu6PDaoZqQIxjmZJcSjobM78ftSqyyxZF+/?=
 =?us-ascii?Q?pLjhmgV+Dh+jtmqKv/GLGSCguaqHjT0iKW+VwwaM7XCuVgoq0okSXC7TixlW?=
 =?us-ascii?Q?LLZya7sI/gyuiiptfCDpbKfFSvPRyMituTknEjpL2yUzF4U5Oe4ISv4Zk/el?=
 =?us-ascii?Q?4dLiSwXYBl3yL4bPj63YN2oDrdbjtssDhZoUaRuwlaLAwjPwBxgolmp0bL25?=
 =?us-ascii?Q?di9/gtjVwIs69BXAXGvS76U5kMBdP2Ckv6FQKkHznNlHi7Imq7gpygyjaVqt?=
 =?us-ascii?Q?7iKsqvlMr6TvA2QszVu+sdaj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB5785.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491e427b-d2ee-45cf-5c01-08d903a951ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 03:06:40.7992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zvTYKd/wByu4DU9t5VKXNC9C253fTYJRzWJAjvWEdHu39isfV4teW8ihaEKsh46ypZS4lRWKwNOI2Kr7iNARtsAFfW1LPkfelPvI9FIHNvM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7431
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir.

On Mon, Apr 19, 2021 at 20:38PM +0800, Vladimir Oltean wrote:
>
>What is a scheduled queue? When time-aware scheduling is enabled on the po=
rt, why are some queues scheduled and some not?

The felix vsc9959 device can set SCH_TRAFFIC_QUEUES field bits to define wh=
ich queue is scheduled. Only the set queues serves schedule traffic. In thi=
s driver we set all 8 queues to be scheduled in default, so all the traffic=
 are schedule queues to
schedule queue.

Thanks,
Xiaoliang Yang
