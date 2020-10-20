Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A54E293993
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 13:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393457AbgJTLFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 07:05:04 -0400
Received: from mail-eopbgr20085.outbound.protection.outlook.com ([40.107.2.85]:45376
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393451AbgJTLFD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 07:05:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uls7ejvfpuF1h+j3W5ONhOOupeMgNWjCcAlth9HENR+zsytoozEY/5ZxgTeOXSEGwoz7EBzZG1sGgeLaWO/wmuhGmKjw3DOSqxj4n+LuYg30I2IqchpjlNoEzZFIJ/2WngWbQ1GGE9dsMWDDzpSl6bHKXbrarr3vqtwqXfxwkbdtff/QiJP9lH/o3YgKfxPyfRYyCxK1N1zDkjCHHcDqUML8RcVSgoHI98U3qYoWfTRY4osRzDkPFWGXB0D5LWNN/ToCqW/ypcXHLA3lovMs4/8RpA12pgPaZmchTbaIhJuCpggsIM8JLsNbcoJZT4er3oik6yx0PkpsL1Wt8hQEyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/kMscUN3iDMhUrL7m9irSlcCplgOLNPEXw2cbtRH68=;
 b=RZQQXxCj93YMQ262Spf/FiVil4HGuKOwNIPdZa0KAzH455AxzdE9Kyxw5yz0+HnBZRfMp9HmKZSP6Y9Tp6uopYh3Zrj4EGd/mbM/E8PuVmDIrUNadE4NwgJQ/wdvtFhwavE22ftohzdw3euVYy6RIXz7SyiOvHmaMtthtFpy6eJl2rcr0TXdPIo8Uj33SKq6VmaDoApCoUliBxv8vv1h0JetW//A251UbVloC12Z5mNzVwdXZjV+S9Res8shhYlfKc/tc9JEyUodpqIomtbp3+ONiWXz3Lmm/fRbkHbseyod8TGyFlZYhp5w49JUXB6TUjX8G8XjMI6Zsxnx78XygQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/kMscUN3iDMhUrL7m9irSlcCplgOLNPEXw2cbtRH68=;
 b=CvJ65RljeOr/pNf+nFA+svSRVXBmRMByBU/xbFJdmg3k8UPMXR0NxiB3n2BGjhFNVnLqMMa3H/rPlWb8RjqIx8SpewjLjoWj0wo34xMWZvcht7rz0K2NkWAcAkKbRsb4pnVyzne/vDwXbXA20Fh/ncKtURy06nXaC8wRUBZ68wE=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.27; Tue, 20 Oct
 2020 11:04:57 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 11:04:57 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Jose.Abreu@synopsys.com" <Jose.Abreu@synopsys.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        "joergen.andreasen@microchip.com" <joergen.andreasen@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>
Subject: Re: [RFC, net-next 0/3] net: dsa: felix: frame preemption support
Thread-Topic: [RFC, net-next 0/3] net: dsa: felix: frame preemption support
Thread-Index: AQHWppd2E6QkNMwHMkSueCeuktWEw6mgVIAA
Date:   Tue, 20 Oct 2020 11:04:57 +0000
Message-ID: <20201020110456.x4pyivcbz6lqr6zs@skbuf>
References: <20201020040458.39794-1-xiaoliang.yang_1@nxp.com>
In-Reply-To: <20201020040458.39794-1-xiaoliang.yang_1@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d5683d7f-82ba-4b76-312a-08d874e7fb6b
x-ms-traffictypediagnostic: VI1PR0402MB3839:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB38395D4CFB26589442AEE7F6E01F0@VI1PR0402MB3839.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CALtmO0GTacd2XEhmtpGLL6n9fGZ2CaneGHXM2JJRmBLcMYQB04rl290pwMyc3ZnTgGbkiHgIL5yn+bubfeU/6bLPO293ztVJ5EJ5zmhRYvVY58jkv1g3/jWrCjiY/A2N8ChQIPC8NAhB3pNksjlOg6xVmq8IpanBQIYTT4M/Wm2ItIl9SDVYOX1AFClOxVvWXyO8Y9hLDbtYqoDaWKaSc6QpGBEQ09pezVas3KAVuRAu8W/x+FV73JWL1dUYb97uhuPDVfVj/v1bDmVf7jIS09HW0wlYTj0HC/n1xBpNJw9Q8vPJOTwcujneX+AbsSfQc7WQ+QiV5n/0UQguQh44T3qmgWxeMohfH1+2FuXKAVGzEFKPq1bC7EwWTI5j/y2cMMoE+zj8VSIlMJ13Eersg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(136003)(396003)(346002)(376002)(966005)(86362001)(44832011)(6512007)(9686003)(71200400001)(6506007)(316002)(26005)(54906003)(7416002)(186003)(6636002)(66946007)(8936002)(1076003)(5660300002)(66556008)(6486002)(33716001)(4326008)(4744005)(6862004)(8676002)(76116006)(91956017)(478600001)(2906002)(66476007)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: QeV4u1hLq/plerQQlSHKuqwq1sRhufCrAYJ0HIR8l94B/ap6PXbmXuDRVffvJ331YQ6tgnJmFIdoCd/C4gvygJkni6rxKeKuOjGruGzZ7tqZv16pyarncO1x8mPxk4/f3nm5b151M7lUwFEDjCSfMXmfGuWcliwenKgoUs2B51vOyro8B0mFKCpQlOCmOKlWqlsaLEVzpTVui807v1862mCJ/PcRhjZcwz+rD6J8VVcs2Xa9jbVJqqmAtU68/F9uJsTxAGh9rfAR7Bfb16pGuOBUKWZ/n6Wqk52DnCb++gZjOKV35FCiORF63hm/1rpteZVNtfKloMLcnE39cdZwSQkEo2zcUbm/FRQKb0G78gUtmCKN7sokXdd6OwjoJsUi4YXiYczADsk3/VC2Ha5s5MbQt1Fz6nKV7hXHTz+QKgeZ0RlClTVGQWphe/D64vWeLTOdIHUIXECPpUcDq213T3Of2s/2HJ3GEDXYLW5zIfDGmPJHxMk5BAv8QYs/o+YdQNekkCCRv9ivplCEfImerR5bUARueDN1+lZcFQmhRXe/2V2zSQpfwpzjqWIwFR8HWe/zbFqXDZlQhUYVuicaYCwvA0Zj45njkjaoCu2xKwbwGl/qoOlVVQsK97cV2KDCAkIkE67ij5UR/har+OkUfQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F0F20FDAC434D94F8A29C23C868AF679@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5683d7f-82ba-4b76-312a-08d874e7fb6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 11:04:57.5319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PkCgukRmHpkzp2/d9XioBNjpRdJ8I/KeddHIQVYQ2RyI4kKaXtuMTddD6CJ54Vuq04kU8T/b6BcZd1zADP2Xtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

On Tue, Oct 20, 2020 at 12:04:55PM +0800, Xiaoliang Yang wrote:
> VSC9959 supports frame preemption according to 802.1qbu and 802.3br.
> This patch series use ethtool to enable and configure frame preemption,
> then use tc-taprio preempt set to mark the preempt queues and express
> queueus.
>=20
> This series depends on series: "ethtool: Add support for frame preemption=
"
> link: http://patchwork.ozlabs.org/project/netdev/patch/20201012235642.138=
4318-2-vinicius.gomes@intel.com/
>=20

Would you be so kind to also provide some feedback to Vinicius on that
series? It's important that we fully agree on the configuration/status
interface first, and that it is acceptable by everybody and gets merged.=
