Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C82B45BAEB2
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 15:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbiIPN6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 09:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231461AbiIPN57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 09:57:59 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70071.outbound.protection.outlook.com [40.107.7.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B081A61D1;
        Fri, 16 Sep 2022 06:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWPo1AGnZzLGW1QYUD041M7+7bbFCj3x9qadwTeJYclvJ3T8EHNLXi28Yr3XX2GKxox+iKhrASCkE+rYbJNTyB7dZOMW38CbkF6fHD2NIZXZRtJtSpK1hZY+IG8Ft2QtnfahyrxISM2odg8oJJR5cdJ8py6Zrp+QQwt14jbBKXlLqBBMu+WkRFAwZUJeZmqbzRu7M8UaV5T18mAf3Cmg4IXl073Kt1IZzXU7XFjG1S9Nsb6k4eiuHvbf1qWTfLn4jDoh63Ro3Ib7RGDhuRA0uF2+ppb1uk41bZO+g4AGjCFxZ3BwfDB2NB62YNCC7DvCx5L2xxnhVBhbNlyMN0UfYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rykyvqF97/AxahbHLyenzrfRxQjWGPy81HRLEdCrN9U=;
 b=EcUeshgVfo3D/VOsCzDc5oeYvJWlye8itqRevU5J+trDGYjU7CrT9NbHP4zxg3XBvMtk1DSf+9NZJPkaZdHxVe0AM7gVgMlau6mAbQFAWIVf//qIRhkW3NejH/6Ln0DNU2m11IpD+8puJT2JOBTnoCFpvZlXu+gO76jQp4Kn1ZqZqxxtQmWSSdbP2oNKiQ/Fe2ksKPNHJd94l8DJk/w9HbUgWesdyQcw5d+PPc89h+Ue9DdDbX9t57nitkzrJd7SPZOVfS3rsK9/KnPh3sW8U0lbHcIh3wcJqt84WyZw8qsLWDvyoUHOIKEKzV9ZKCq0413uXO4RFcxeTPNj2CoKzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rykyvqF97/AxahbHLyenzrfRxQjWGPy81HRLEdCrN9U=;
 b=sVjC41ixNuBN5yrncGUhSD+im1wDHK2+scTDixRVsnQ4rIMR6mvVrTfEcVanDaPMKsWIcgOi+VkBFsGfdqCptm9wWZred/OXgMnwY25qbzs947KkMmfY2yzFKhor4HPHGpKJqfZBSfq5PSf6daDG83A6uB7Ao/aGWvUwfe3vKD0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PR3PR04MB7449.eurprd04.prod.outlook.com (2603:10a6:102:86::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Fri, 16 Sep
 2022 13:57:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5632.016; Fri, 16 Sep 2022
 13:57:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Rui Sousa <rui.sousa@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 10/13] tsnep: deny tc-taprio changes to per-tc
 max SDU
Thread-Topic: [PATCH net-next 10/13] tsnep: deny tc-taprio changes to per-tc
 max SDU
Thread-Index: AQHYyE9kpcxLYCJ3dk68mHHPDBjrxq3g2nSAgAE9jQA=
Date:   Fri, 16 Sep 2022 13:57:53 +0000
Message-ID: <20220916135752.abmpagmyjt4gnolk@skbuf>
References: <20220914153303.1792444-1-vladimir.oltean@nxp.com>
 <20220914153303.1792444-11-vladimir.oltean@nxp.com>
 <ecf497e3-8934-1046-818e-4ee5dc5889eb@engleder-embedded.com>
In-Reply-To: <ecf497e3-8934-1046-818e-4ee5dc5889eb@engleder-embedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PR3PR04MB7449:EE_
x-ms-office365-filtering-correlation-id: 182933e4-55ec-4916-0676-08da97eb7381
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VhXjGnTK6fJx9Utk4/ArMMARfQR2oKuRLzJSB2QG+GpMaMr0AgS1TBeWbVxI5zu/ceGcBX2CYZsrOvhIOzHHIyhRy5MtUllMJbRO7WdDxlttU/3EgU1jniAvJq8mpmabD2JDtX3MzH/uF8h+r2oKQIRM6FsAAnhISNJbFjH7BO4Em5pPdIyXA/maiDyVajqX4y8jLUTN6Aeu04BhZp1rA3vj802PQwRbwe89vMWjTS0SKNWzsc8Ab7fkS1ua5DbBq64IBv/qRVfNr/ABV0p75sDqOzb7WG+C0Btk+iyeAEp7Z9kYZmELcyoel3A+Y+rTs2v4X7HBFlFtKdeYTmQIgFfogcoHiIl9QUbgaOrzxeLmurWVCSRbXaqDUYH/0TOtauc/X3lrY8AnwCTqCZVjTLXATACF8KLeEPkC3obMEexW3xttyVa7A+OCn5llmtO98hnK9ORxCenWgmXcWKGf2KCFIppoFSy2tKhDkhXaBlNaMehvjT/ZeVji+1VqI1pPiC4hhmrRui02i+X49qgbGb2FZVVq7lFsq4biBs18tBxZvcQzi0ZkDlA/HRURLXEui8WggXsfViQYnHHNy1xAYq9OMTOKVWgArVdIt4bS8S9B7MP/WA1BfT9XYqqcFp5JRdFy2qmJgC35RKP4PLavbhTWQ3BEypvD8ryw86T4vxMe459mBZitKE1O45Y3wO6TNI6ByQszRLkrYqYOsr0GFVShHZ1dd8bBWD63m6Qt3W1cEPU+pWgPuYY3QQ+kH/anq+ZOsjKM75zK0ovIoz/0qQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199015)(478600001)(66476007)(6486002)(64756008)(71200400001)(66946007)(91956017)(76116006)(66556008)(41300700001)(4326008)(6916009)(6506007)(86362001)(8676002)(38070700005)(8936002)(26005)(122000001)(6512007)(7416002)(66446008)(33716001)(38100700002)(54906003)(9686003)(186003)(1076003)(5660300002)(316002)(44832011)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WNyZ292iFjO5imWRqrC2dUY+C005ZzXbZw5nb1Ib81BMSZX0N1VWxXNvLpHv?=
 =?us-ascii?Q?JedMW4D+5dcrDxxW4SI/jEL9QOFe8XPMriJFLX1tkHfvuCkMXxfC+BABQYKL?=
 =?us-ascii?Q?g/PV+EelBQp3fXanQGoIe2WNY2CTSsItJmOAX/M1ZbRPM78yiZ9Jy+Y5zd+Q?=
 =?us-ascii?Q?/ViqfJlv4+OBSMcR+YpFdNPxmXZnGV3HpZu/wMtJR+7PrK13b/h+ftthwNZ+?=
 =?us-ascii?Q?2oS/910452MsL0nEXgTqqLFZr0WYGhdN9ENzQbvSJV+ZwrzTmPk21fCpTidU?=
 =?us-ascii?Q?94+V0nF+o0ZATQxIneVdgjHNXhnC13wyv2hN9y81OmrcV6QJlGkLZDAnco4h?=
 =?us-ascii?Q?1eRNiaX0XeEWBMqjMt+sDiZQoH0upGttpRl+rFIM+i+Lrdx9OWppiqDrcfMy?=
 =?us-ascii?Q?Yf9fCilJIYRQUwZ+fG8CikDI2qIeD/3+QSQhrg0f0Exsc1FhkMK3HSAeSNFn?=
 =?us-ascii?Q?x3MY+JPwMTfIOeHndkyNiWu3N709ybttrsKJKflUW05xWiISypGMzJSKPieD?=
 =?us-ascii?Q?eaXWMyNnWmQDFOhKZ4FDHEKcQmf09o0b2krQDOkwnPy2D509KPMG+aX9jCrZ?=
 =?us-ascii?Q?zMaelk+rokJMonDyT7sTB4eaksEvr/cYSnTnlG47IC4OCViK+W2V9TiEPUK5?=
 =?us-ascii?Q?lzf/+3FWF98Cb/JX9uO29WJUCB3HYWLQ0mihQ0ugDCT3cX9EILYJdxYxnnCM?=
 =?us-ascii?Q?tSh/UghBWtLeiMz90jv6ZZnCBLEAYwMK+4+itrxkCMrhN4Jukz/kF2/RSmAO?=
 =?us-ascii?Q?YFWdsR2HEqwl2deMlot6xMqHCvPG87WAiO8FwEvNgE8Dk9PvUdeotA1ytNIN?=
 =?us-ascii?Q?hYJhWlo4ZTBddeNMXG/120X6WXs0RjY5fhnruBZCBGPI3nH7dZtOcYRI5+Yb?=
 =?us-ascii?Q?dU0JSEvqqUggWB0kAWSI+49oFvN6QfL4bnEBsEEeZs8Spq7ZGDeSPg83qA7k?=
 =?us-ascii?Q?QZD+uWF8UiW80LD757QBXHGrlPGzZHg7pLY0aNiF2Q6dB4P9tFnYioFTCfVb?=
 =?us-ascii?Q?JaMvpp09bt+bkKUyS2td9wBoJNZnblbnOaf9OSQ2KjsPoda+dduPDqguH+WO?=
 =?us-ascii?Q?WdWenpWMBwRfQlUJrqvcyrh0BokBur+cxg7Wmd1P/eqD1N7/GuiXnhxWUW91?=
 =?us-ascii?Q?ZsFeoY6MiqEVP09IQHZ0HEXHQ5kPzVZz1oz/VXQd2fRfpw8JvoN68Jh2/0og?=
 =?us-ascii?Q?3keF5FdxMKLCUnjDu0+4ll6Xi+anQIWSVmG0zDZqKT9YVYZ68mrCcU5SAgqz?=
 =?us-ascii?Q?AN2Ie/CfJMtvamd+ZfFrrw7ekg/VsI7SoseciO/AVMFTiaWLIwhFLD9+6xrg?=
 =?us-ascii?Q?xWay7HZ7jZYHZ9xR49VF0Jqjx+UJwA8u/jXmeTMLNa6lXFThLOchkrIvTy5P?=
 =?us-ascii?Q?45Pe4O/DpPdTc5hZkDOkzkBLcDDSyFeCDPPYid6NXUwwWyFet7bmPjroHNt+?=
 =?us-ascii?Q?EDle8pxlNswdJlORrKOrCByfO3EGUbZ+vHVQ3U+46fZajtsDLEFkLQfO9y7p?=
 =?us-ascii?Q?5NiPubWHt4fOKGgipQIFTZ4FJS3A1M412dm9SCMPO11j+szKxpC4WH5NWU1P?=
 =?us-ascii?Q?6g7ZyCxi7faTyRIoOQehGGpk+pCNrUBSvsg/QuBDErATN+U+OeM5kpumgvm6?=
 =?us-ascii?Q?TQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <886C1A575B7E6E4284D9BE0EFB332782@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 182933e4-55ec-4916-0676-08da97eb7381
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2022 13:57:53.6822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ipQUN9kslDLLEDU72/UUUlaffXVt9kNcDd3w9t9dO+NP0t5Mevt5Lm+FKf+8X5XIuTWoc/s0FTCg2KiCHTDn1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR04MB7449
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 15, 2022 at 09:01:19PM +0200, Gerhard Engleder wrote:
> Does it make any difference if the MAC already guarantees that too
> long frames, which would violate the next taprio interval, will not
> be transmitted?

This is not, in essence, about gate overruns, but about transmitting
packets larger than X bytes for a traffic class. It also becomes about
overruns and guard bands to avoid them, only in relation to certain
hardware implementations.

But it could also be useful for reducing latency in a given time slot
with mixed traffic classes where you don't have frame preemption.

> MACs are able to do that, switches not.

Switches could in principle be able to do that too, but just in store
and forward mode (not cut-through).

> The user could be informed, that the MAC is considering the length of the
> frames by accepting any max_sdu value lower than the MTU of the netdev.

By accepting any max_sdu lower than the MTU of the netdev, I would
expect that the observable behavior is that the netdev will not send any
frame for this traffic class that is larger than max_sdu. But if you
accept the config as valid and not act on it, this will not be enforced
by anyone. This is because of the way in which the taprio qdisc works in
full offload mode.=
