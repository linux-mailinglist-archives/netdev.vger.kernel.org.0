Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C70A64A6BBA
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 07:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244813AbiBBGwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 01:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244698AbiBBGwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 01:52:37 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-mr2fra01on0609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e19::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814B3C061769;
        Tue,  1 Feb 2022 22:30:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dLZiOeA/mMqTvwDgMJeH/imkriKuvsJMbWW1SDv5GHlpXS5LUSSNxUZouB9dSoZxwYQQxjmmw+6VFIQR0B2Uz3Xe5yXEhul11EJBfsSjDEv/vETF1OuwvERSuLi1AWhr0oVLx7k9k1SaGtpiZNTJD1Q3DfggLtjFbeASw9LDcGC3OMTT0u92bmsiTpS3kp0asCSFp6LB/4NGkxWgwuDkxecbLkdwkonxPvPi1rdEE53RZ5jP5a9x7CUeSJg+wFuyzqr3u5wbZkjaqwyFCNs6cSOOt6owS00G/Pmf/eAVmPZ648ra4Iprxs16w/Paw+IrG4dPaq8HqUea+/0V+0YyIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GuqiKB3JCAh1Tg2H6Y16RVpDVJVD++2MtoEOKaq0AVw=;
 b=kUtDgRpK+TumVy3qMiD2voPW3P8PvQGCkzkEO1a5XwlRdlA+veDRR4rVJWq09NlHpHFUKsN5635pUjNTp2mcWv6cFUACP16ICyZGqYbgyuLsADkhno2KCoXdbxSdDf1r1Mf0DWNdMWrLG3rttqrNYfbSv2AdG3HR1AzC3toBCSR75+nw8v9+KyMAiDLyxlisV1wVCLmIP04XsWJfQ5+Gvqpc7Oyo+efYb01yaMnOtBwuJCP1nsJo6kSWsJe4BAnhishtJt3SWdsSon+wt3r8oT3xhihGPIr9+qmawvoZiWgKP8HUrf4LPAXZUZ4dzEjxYqif48ivmaLQ/7fQo+u3iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB4384.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:143::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 06:30:14 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 06:30:14 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>,
        "l.stelmach@samsung.com" <l.stelmach@samsung.com>,
        "rafal@milecki.pl" <rafal@milecki.pl>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Liming Sun <limings@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Gary Guo <gary@garyguo.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-sunxi@lists.linux.dev" <linux-sunxi@lists.linux.dev>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "oss-drivers@corigine.com" <oss-drivers@corigine.com>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs to
 y
Thread-Topic: [PATCH net-next] net: kbuild: Don't default net vendor configs
 to y
Thread-Index: AQHYFseJAQIl+0rChkCgUTL3TOyG0Kx9aumAgAAI3QCAAAFcAIAAAWMAgAAZGICAADEOgIAAAgWAgAAB4QCAAe1wgIAAA2wAgAAE/YCAABSxgA==
Date:   Wed, 2 Feb 2022 06:30:14 +0000
Message-ID: <8566b1e3-2c99-1e63-5606-aad8525a5378@csgroup.eu>
References: <20220131095905.08722670@hermes.local>
 <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com>
 <20220131183540.6ekn3z7tudy5ocdl@sx1>
 <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
 <20220131121027.4fe3e8dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7dc930c6-4ffc-0dd0-8385-d7956e7d16ff@gmail.com>
 <20220131151315.4ec5f2d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dd1497ca-b1da-311a-e5fc-7c7265eb3ddf@gmail.com>
 <20220202044603.tuchbk72iujdyxi4@sx1>
 <20220201205818.2f28cfe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20220202051609.h55eto4rdbfhw5t7@sx1>
In-Reply-To: <20220202051609.h55eto4rdbfhw5t7@sx1>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95b95ae6-0e97-426a-982a-08d9e61578c1
x-ms-traffictypediagnostic: PR1P264MB4384:EE_
x-microsoft-antispam-prvs: <PR1P264MB4384ED1D27912A4FB9524D69ED279@PR1P264MB4384.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MYggpnDxFgIr4MzzU7lGQcQsdz6oeqbPCCTxQGIBJ0CijlWSsxl3q6k4hWE2Q5a30B1gJESi+Xx99gY6VVkwMwrPqiAGCFfWVTMjUk2Qbyjaxm7rUOHOiV2fRhd09MVAlT4LExJzrAKwJldrcsoiht3dBWEJFOHfB5WJVRedBtD4EQHRJ1FrZVpYFHQjk9OHf8ayJjjcgFcxs+e9kRXLqZZY2uNZui79c7LHDVSiRaIzoOYP/eQzUL/y4VFK5HADa46yhFQP6ceFUeKS51b4DLHknS5n4af10nmXukE8woXII4iMA0m/Wl9In3XOKindNSo3HF3DmXnKxdWEqomuWM9/T3rT2j1TcR048waw7I9PdJSktMk+XPAncuNFsNpZuHTVeNLOJ7zJL0yOUFo5SdCnj19NW5sYDOgqnM5ZEBad2nSutlBJ+IIhBvsK7sgmmizaLfSs+tcYfD4J9OqqzfWtYeGDvGBSD64T9qImIK/c5eJrp8axWfIWOBGpoeWMf43/OKuCfymSMHbocBsGxEFRYOeFebowL0xxknYClea0War2pWVu9Tnm2C9h5oNMBcj186K5awqXlN5bfWKBv/4F2Q/9YCdPS56XEdTzJKKUp00TOC5ZRJQEN0snE5FwufIYckmeTZt3XeJTdImI688Uv8IpMx0P2j49dw+4fTAum2lzz5zrW8hUN6AyNH8X/+Y15u1oqEAk0/luy2wqDMXQo0o7xJ01V/AywoKc2cxbDrsQZEziH58yP4BURhH2XuAZxLmztWjsucVM2tqJvUZKKsYwA7uHrJ0+aoEKz6o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(54906003)(110136005)(36756003)(122000001)(2906002)(66946007)(6512007)(508600001)(71200400001)(66446008)(64756008)(86362001)(38100700002)(66556008)(4326008)(8676002)(8936002)(31696002)(76116006)(91956017)(66476007)(6486002)(44832011)(316002)(5660300002)(186003)(26005)(7416002)(7366002)(7406005)(2616005)(7336002)(6506007)(38070700005)(31686004)(129723003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUpzSG5TbXliVCszK1I0R3pTK0JMa0JVdEJ3dm45MVZPdEhFY3YyWERTUmpF?=
 =?utf-8?B?cW5mSlJ1WU84Mnd4anVnODVoTWNhUHdLdDJ4czY2S1FTdit2RW1Manh0K0t6?=
 =?utf-8?B?UkJ4dVhKaUREWmtrdExNWWFzOU85VmcvNzM0U1VQeGVNUStIMTJJU2pXZTRR?=
 =?utf-8?B?VUZsRnhzazFHWnVwRWtPMmR6MVpXbTNOUzdWU2lrRnRPeEE2MXQ2UUhxMDJQ?=
 =?utf-8?B?U1A0U3ZDZWQ5Zm0vL0J0M0xWU2pKM3pkV1NjdVgyYmxwS3F4VkRyUkxROHln?=
 =?utf-8?B?RzRBc3hYR01MWmdSTlZtdXdXNUVSMGNSaHRIMTZPazhMZXNCRTZjQnlzaUFI?=
 =?utf-8?B?N1l6YnU4NUNaVjZlOW1oTmNLbEpjTWxTUnpINzcweGoxd2lqKyt1ZmlYblMz?=
 =?utf-8?B?aUpPakwxUmlzMDJKMFJDSUkrbjRDT3gzcUVRNVVqRk5FK2ZnMjVJN2FjRkd6?=
 =?utf-8?B?TUVhRWxleVpXOVRYM3lQWVMyaFZLdWtoMEIxNXp0Um5UT0ZIdFBRL0RGQjJi?=
 =?utf-8?B?cXJ0K2F3cUcvQ0M3bjFDQ1ZlSjV0dXdxdkIra0hSYWpsdUxRdXZQQjFSOHp5?=
 =?utf-8?B?eVZxbENva2g4OWJ4QVFhWGFicXczTjdBcnltZnNDT3lmQkQ5eUVjNHN6bStx?=
 =?utf-8?B?eUFQeGxpQi9nYk9ndVVXYWhmdEhML3RST3NmNUc3b1RXV3pZYS9zMm1RRTVS?=
 =?utf-8?B?d1lleVd2TlA5TWZEMndoMDNYbFNROWkrdzNSblN6YUxDa1Q3ZmJYc0VtRHF3?=
 =?utf-8?B?ZlJ6YnNaREJCYnVSUFBQQ040Q2VrWktlL2tncGpRVUhLb2hhZHpSc0VzcnRH?=
 =?utf-8?B?WFJyT1hDMHZHbGx4RWRkdTJUc2tZYzVEUXNKL012RngwWEtLT3RBV1F6ampW?=
 =?utf-8?B?MjF4Yi9OOERaMmorSit3NE1wQk83bkR5TFdlTHMzRjRwbG5iYWRPOEhiL20x?=
 =?utf-8?B?SkVFNm9pZFhCN2Z5ZlYxcFhLSjVjNTBXMFZhR2UwelIrMkJpOGlSMHhYZ3NQ?=
 =?utf-8?B?S2U3amltRVpldDUzK05pdUtRNUZwVEkwVEY0Rjd4Q0NNSmFpalNicE9QVGFV?=
 =?utf-8?B?YWdoUFBNRFp5Y2YvbWdXeU1CL0xHR3RwRG9CaFdLbkVFQjBCRW44enJ6RnIz?=
 =?utf-8?B?VW1PeEtMSWJmTUpPOEY0d09tOWhTcVU3TTJBTmhudXF0QjdRSDRLSCtXZnZX?=
 =?utf-8?B?ZjlFZWZTKzlFdmRvQmh4d3FEaHFLR1F1eGRpc1VOOGk2VVdocnpyS08yRFVi?=
 =?utf-8?B?djJrRERlTzNqL1hMMVpvTE1qa2RlODNVOCttT1IybHV3bkc5b2FWR0JsYmJZ?=
 =?utf-8?B?NXpQQWwxRkxNb2E0RHVuS2c4cUNleWtYQkNsUUpOSTB0MDNmUm9FKy90ZVQ0?=
 =?utf-8?B?WTFlWFc3UEV3M2tiUWUyYzcxMEtnTXJacUdGc1V4TE9ReTRwMzdvc1h1KzA2?=
 =?utf-8?B?VkpGNFlmaVZBYlROT0FRL3N1RGg5b1E3OFdVRURIS3RiTEw3cHdUdkJmTG9W?=
 =?utf-8?B?SzR6T3YydjdWeWtYNVFKVlJYT2M2bHl3WjUyQ0ZJbHVXSG5xWGtxKzVuK3Fn?=
 =?utf-8?B?MWZRbzBwWTdxQzd5UkF5YyttV0Ixd3pVN0E4MU04bzZ0c2lsZ2REa01aN24v?=
 =?utf-8?B?a0JsbU1KeHdaS0hCUko3VEFCQXRhc0Nyb3lZbi82bC9TS1NCQmlhZDVjNEFL?=
 =?utf-8?B?cEpTMlJXUnhFUVpQL2tCcFRBV0hIQkthMUJUMndQODRWTHBjYUYxdmo0RTRQ?=
 =?utf-8?B?UUhhSTEwSmtuNDlGUFY3S0lFNWhVaENDcEpnSmlURUVkZTA3NFBlbmZxOEh4?=
 =?utf-8?B?WHFhQ0Fsek94NlQxN1c1Qi8zcWlqNkNjamxDRVpWYTF0Z25tNXhnZjlDVGRV?=
 =?utf-8?B?c1JIMXhiem1ISEVtQy9sN3pRS3lldGpzdEh6eW12SVZxaDQxSTh1WWhNT3po?=
 =?utf-8?B?RGJoSFN5WGJNSTF6OVA3STAyUExJUlN5UmdnaXM5VVVzVDRPR1hqZmRJRmRu?=
 =?utf-8?B?T1RycWZZVVRFb25LVVVVd2wrWWZKNmE0ZGdsMC9iZVpwTHdiemxpODN6Tm5Q?=
 =?utf-8?B?THRaVDdFeVNqSjZMVlV2NGdkTW5wOXFFeUgwcUVCRmlXUXh4R2RjRG1WZi81?=
 =?utf-8?B?aVF6bXIrQll5NG5YOUhIVURsLzZpZmJRK3ZxQytlT1J0by8rZHVOMFl3VWxq?=
 =?utf-8?B?M1N2TEtHak11eGN1Mk9uRmVIaUJHc3gxeWdKWGE3WGh2em9oNzNrdHlQemFC?=
 =?utf-8?Q?IwgR+sT1xas7Mp2P8RUDszke7OBkIZt7dozrL5NRaw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C00100F51ED2448AEE5C64811BF8C58@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b95ae6-0e97-426a-982a-08d9e61578c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 06:30:14.3665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Er/7TGygwHTI9Z7mAWMsV3PLvBybHXCEWb/WxUId6c0sDBGwuHLhiUsXUfBH1k7sTs3NLGWJo+rdZgKjP1Okx/oDU7TqUOWmZ0pVMg3d0jQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB4384
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDAyLzAyLzIwMjIgw6AgMDY6MTYsIFNhZWVkIE1haGFtZWVkIGEgw6ljcml0wqA6DQo+
IE9uIDAxIEZlYiAyMDo1OCwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+PiBPbiBUdWUsIDEgRmVi
IDIwMjIgMjA6NDY6MDMgLTA4MDAgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+Pj4gSSBhbSBnZXR0
aW5nIG1peGVkIG1lc3NhZ2VzIGhlcmUsIG9uIG9uZSBoYW5kIHdlIGtub3cgdGhhdCB0aGlzIHBh
dGNoDQo+Pj4gbWlnaHQgYnJlYWsgc29tZSBvbGQgb3IgZGVmIGNvbmZpZ3MsIGJ1dCBvbiB0aGUg
b3RoZXIgaGFuZCBwZW9wbGUgY2xhaW0NCj4+PiB0aGF0IHRoZXkgaGF2ZSB0byBtYW51YWxseSBm
aXh1cCB0aGVpciBvd24gY29uZmlncyBldmVyeSB0aW1lDQo+Pj4gInNvbWV0aGluZyBpbiBjb25m
aWdzIiBjaGFuZ2VzIGFuZCB0aGV5IGFyZSBmaW5lIHdpdGggdGhhdC4NCj4+Pg0KPj4+IE9idmlv
dXNseSBJIGJlbG9uZyB0byB0aGUgMm5kIGNhbXAsIGhlbmNlIHRoaXMgcGF0Y2guLg0KPj4+DQo+
Pj4gSSBjYW4gc3VtIGl0IHVwIHdpdGggIml0J3MgZmluZSB0byBjb250cm9sbGFibHkgYnJlYWsg
KnNvbWUqIC5jb25maWdzIA0KPj4+IGZvcg0KPj4+IHRoZSBncmVhdGVyIGdvb2QiIC4uIHRoYXQn
cyBteSAuMmNlbnQuDQo+Pg0KPj4gSSB0aGluayB3ZSBhZ3JlZSB0aGF0IHdlIGRvbid0IGNhcmUg
YWJvdXQgb2xkY29uZmlncyBJT1cgc29tZW9uZSdzDQo+PiByYW5kb20gY29uZmlnLg0KPj4NCj4+
IEJ1dCB3ZSBkbyBjYXJlIGFib3V0IGRlZmNvbmZpZ3MgaW4gdGhlIHRyZWUsIGlmIHRob3NlIGlu
ZGVlZCBpbmNsdWRlDQo+PiBldGhlcm5ldCBkcml2ZXJzIHdoaWNoIHdvdWxkIGdldCBtYXNrZWQg
b3V0IGJ5IHZlbmRvcj1uIC0gdGhleSBuZWVkDQo+PiBmaXhpbic6DQo+Pg0KPj4gJCBmaW5kIGFy
Y2gvIHwgZ3JlcCBkZWZjb25maWcNCj4+IGFyY2gveDg2L2NvbmZpZ3MvaTM4Nl9kZWZjb25maWcN
Cj4+IGFyY2gveDg2L2NvbmZpZ3MveDg2XzY0X2RlZmNvbmZpZw0KPj4gYXJjaC9pYTY0L2NvbmZp
Z3MvZ2VuZXJpY19kZWZjb25maWcNCj4+IGFyY2gvaWE2NC9jb25maWdzL2dlbnNwYXJzZV9kZWZj
b25maWcNCj4+IC4uLg0KPj4NCj4+IEZpcnN0IG9uZSBmcm9tIHRoZSB0b3A6DQo+Pg0KPj4gJCBt
YWtlIE89YnVpbGRfdG1wLyBpMzg2X2RlZmNvbmZpZw0KPj4gJCAkRURJVE9SIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2ludGVsL0tjb25maWcNCj4+ICQgZ2l0IGRpZmYNCj4+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9LY29uZmlnIA0KPj4gYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9LY29uZmlnDQo+PiBpbmRleCAzZmFjYjU1YjcxNjEuLmI5ZmRmMmE4MzViMCAx
MDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL0tjb25maWcNCj4+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL0tjb25maWcNCj4+IEBAIC01LDcgKzUsNiBA
QA0KPj4NCj4+IGNvbmZpZyBORVRfVkVORE9SX0lOVEVMDQo+PiDCoMKgwqDCoMKgwqAgYm9vbCAi
SW50ZWwgZGV2aWNlcyINCj4+IC3CoMKgwqDCoMKgwqAgZGVmYXVsdCB5DQo+PiDCoMKgwqDCoMKg
wqAgaGVscA0KPj4gwqDCoMKgwqDCoMKgwqDCoCBJZiB5b3UgaGF2ZSBhIG5ldHdvcmsgKEV0aGVy
bmV0KSBjYXJkIGJlbG9uZ2luZyB0byB0aGlzIA0KPj4gY2xhc3MsIHNheSBZLg0KPj4NCj4+ICQg
bWFrZSBPPWJ1aWxkX3RtcC8gaTM4Nl9kZWZjb25maWcNCj4+ICQgZGlmZiAtdXJwYiBidWlsZF90
bXAvLmNvbmZpZy5vbGQgYnVpbGRfdG1wLy5jb25maWcNCj4+IC0tLSBidWlsZF90bXAvLmNvbmZp
Zy5vbGTCoMKgwqAgMjAyMi0wMi0wMSAyMDo1NTozNy4wODczNzM5MDUgLTA4MDANCj4+ICsrKyBi
dWlsZF90bXAvLmNvbmZpZ8KgwqDCoCAyMDIyLTAyLTAxIDIwOjU2OjMyLjEyNjA0NDYyOCAtMDgw
MA0KPj4gQEAgLTE3ODQsMjIgKzE3ODQsNyBAQCBDT05GSUdfTkVUX1ZFTkRPUl9HT09HTEU9eQ0K
Pj4gIyBDT05GSUdfR1ZFIGlzIG5vdCBzZXQNCj4+IENPTkZJR19ORVRfVkVORE9SX0hVQVdFST15
DQo+PiAjIENPTkZJR19ISU5JQyBpcyBub3Qgc2V0DQo+PiAtQ09ORklHX05FVF9WRU5ET1JfSTgy
NVhYPXkNCj4+IC1DT05GSUdfTkVUX1ZFTkRPUl9JTlRFTD15DQo+PiAtQ09ORklHX0UxMDA9eQ0K
Pj4gLUNPTkZJR19FMTAwMD15DQo+PiAtQ09ORklHX0UxMDAwRT15DQo+PiAtQ09ORklHX0UxMDAw
RV9IV1RTPXkNCj4+IC0jIENPTkZJR19JR0IgaXMgbm90IHNldA0KPj4gLSMgQ09ORklHX0lHQlZG
IGlzIG5vdCBzZXQNCj4+IC0jIENPTkZJR19JWEdCIGlzIG5vdCBzZXQNCj4+IC0jIENPTkZJR19J
WEdCRSBpcyBub3Qgc2V0DQo+PiAtIyBDT05GSUdfSVhHQkVWRiBpcyBub3Qgc2V0DQo+PiAtIyBD
T05GSUdfSTQwRSBpcyBub3Qgc2V0DQo+PiAtIyBDT05GSUdfSTQwRVZGIGlzIG5vdCBzZXQNCj4+
IC0jIENPTkZJR19JQ0UgaXMgbm90IHNldA0KPj4gLSMgQ09ORklHX0ZNMTBLIGlzIG5vdCBzZXQN
Cj4+IC0jIENPTkZJR19JR0MgaXMgbm90IHNldA0KPj4gKyMgQ09ORklHX05FVF9WRU5ET1JfSU5U
RUwgaXMgbm90IHNldA0KPiANCj4gV2UgY2FuIGludHJvZHVjZSBDT05GSUdfTkVUX0xFR0FDWV9W
RU5ET1IgdGhhdCBzZWxlY3RzIGFsbCBjdXJyZW50IHZlbmRvcnMuDQo+IGl0IHdpbGwgYmUgb2Zm
IGJ5IGRlZmF1bHQgYnV0IHdpbGwgYmUgYWRkZWQgd2hlcmUgbmVlZGVkIGluIHRoZSBkZWZjb25m
aWdzDQoNCldoeSBzdWNoIGEgaGFjayA/DQoNCkkgdGhpbmsgd2UgY2FuIGZpeCBhbGwgZGVmY29u
ZmlnIHdpdGggc29tZSBzY3JpcHRpbmcsIGFsbCB5b3UgaGF2ZSB0byBkbyANCml0IHRvIGFkZCB0
aGUgcmVsZXZhbnQgQ09ORklHX05FVF9WRU5ET1JfU09NRU9ORT15IHdoZXJldmVyIHlvdSBmaW5k
IG9uZSANCm9mIGl0cyBib2FyZHMgaW4gdGhlIGRlZmNvbmZpZy4NCg0KQ2hyaXN0b3BoZQ==
