Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA0655DEF4
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbiF0Tkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:40:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbiF0Tkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:40:35 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1562815A27;
        Mon, 27 Jun 2022 12:40:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lz3zQV9TPcMXfDmpjQ9Pu0E+upYtc347huEzj6j+Y/KxhxUaT0TqLAcmE6XOkZOsgpk/uNknr2BrmEhOcijc5YMIwWqxnSTFDmjnOHTjGnWCo3dapAp0ZDRHfcqC+NbZZPxQaLuNy8eGwt4Xp7QPZBcqbcUFg+K0SDc5uWcfagBP2vW3tQNsW8adTPqfGm2CKfgx/mTktVzjJPbNeAkOLUNoCcJfE14CiLcJxUe3vTJ2qqtsHHbsohv4qhkdCdLKL2z6iRisOwTexrpVEN3d9ixnyy9lxCjeoG05nc+zEMkDDpkgYlJpbLOU1NyJao1PeJfmGwOkz9dtOnrx3X64Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jQ0NdlynsJ/Q02qrRa0Yf30IESLNZcAJIQj7uUlJmas=;
 b=eoDwMNIQtQP1gk2Fl9Z2GVbraBILZVObGb6ob8b++EkmUJgFoT8+Y3g2Ii1f85BafQ6/jnjfOUNxRAdhOElDR76ZtkZNUHNFJKEW4LL3JKsZOrfDJVIxFshyQQfwvizkh7MWIwAINGDsHe5T0SiyPN8LnlUXjiPaNXDXUeAqmBEcoZs1QWca2LZso+NjzLFAVes8cb8Z3qqYxEwpUEbgispaLEdIuNsAWq17kNkxxEfPIfeYmWaDGqAwAMCQ/+TpcSQm3jqSm6jRid04XSwVnygXZTRYtTljtlLxmd/amDTL+lawZjaOfJBJYqSI8Y8EtAtAuC2yiLLEqH6wuzxpZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQ0NdlynsJ/Q02qrRa0Yf30IESLNZcAJIQj7uUlJmas=;
 b=i7m1WORlB9YOAxIxQAu4BsCeeoEf8EFA9JWaJEN0p5he6B1c/eTRCUFJ/Bjc3uh/72YN67E8V7pgpYp4leT+DVcFYacZFaSMZlQtGwwppuuwLGfGulQHYvNmaifPVZCbkGrJs1ILHaml70zAlBkBfGsW3VtDn2qx7Hkm9PJMo6M=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB6PR0401MB2535.eurprd04.prod.outlook.com (2603:10a6:4:34::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Mon, 27 Jun
 2022 19:40:31 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::94fe:9cbe:247b:47ea%7]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 19:40:31 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 4/4] net: dsa: felix: drop oversized frames with
 tc-taprio instead of hanging the port
Thread-Topic: [PATCH net-next 4/4] net: dsa: felix: drop oversized frames with
 tc-taprio instead of hanging the port
Thread-Index: AQHYiVUMDrzfbWhGTUGNTUf+r0GzEa1jmdQAgAAPBgA=
Date:   Mon, 27 Jun 2022 19:40:31 +0000
Message-ID: <20220627194030.uyaygut2n2sjywni@skbuf>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
 <20220626120505.2369600-5-vladimir.oltean@nxp.com>
 <20220627114644.6c2c163b@kernel.org>
In-Reply-To: <20220627114644.6c2c163b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6160460-c5f9-44f3-7c29-08da5874e541
x-ms-traffictypediagnostic: DB6PR0401MB2535:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j5iAjpB2/ML+3PQO4a+WfgRU1+FgXDhsBVrhQ3Nbqr6JTnlY+AGeEebUtpFxeX5rmcF/RrC1p8m9hkz9fUFgpjsl9Sfk+n6MqiI99+DAY71ewkfeXhVlGtkIQkYsNY1ovb1L3d3I2jB0M3hz7n+a9jmy1vJqTD9eW7gfjp54xBPalpFGtl4x//+dDwq0Vr0r76m7lzX+FA+6VH8Usgs/bWcQhIg0xrOyxIPea1QTqhAy9tgTnmtFdo7Ljirv9dBnZeIkOSUdgZpxYkIfNUz2LQOShg31kEx0tGRx0WhAP1Bx0PbjEERQ/JVvckxb8ui9or5CmN0R1Amb/5+Z8ct8ZpHb4A8EAObpdoN+eFiJhLNhfpK0gVKLwD+6phb20CxXxfiJO/ZQFD3vbUxBe5dt/52VdIDaYx7+KjKYthW3bQ0A3pKZllUBOESErWytt7TAIwg2Z9veRWfBJzb++Znv/g3EpUpg3ih3rTyF2jIVMp7WtynLsgo2hOTvd6BJaUn38cT6Yho3xKYCY/1mNZ4ivMar1ZUCWixPMv0RO0naHFH4d2JB+v9EBceXd+NC0oiFjcfQXbI/WXLKWpsavlLkqEuwLxdknQj9j8GKiE0JxAdlsQ7fNlB3pTz7FpFUXWlgDsPrGn8OejSdR0IsN3hspZzGVWwfN1Y7RCxUnWF3J80tAEllwBfG/gwB69rBpLbSaDuXPV3NkYEEiA6qHz2eEU4x5hUy/BClcAR/xADxd5Tx6e4+ECPK+3YQJto65qUCwuATmtZLWpd5tkZen/EWOJtquO/OihIDlWS/CVzFCoA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38070700005)(26005)(122000001)(91956017)(71200400001)(7416002)(6916009)(54906003)(5660300002)(41300700001)(76116006)(9686003)(64756008)(66446008)(2906002)(6512007)(44832011)(6506007)(478600001)(1076003)(8936002)(86362001)(83380400001)(38100700002)(186003)(33716001)(66556008)(8676002)(4326008)(66946007)(316002)(6486002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9RiEqZlP20Xf6j9gr23ZWe4MlmylLLQ+J/tyCRwKUKKlS+Z0MveRMwekfiSv?=
 =?us-ascii?Q?sV+1MbK3GmpTrJKkEDl72qQT08SlDeBinNSNJzmcy1xc1YbSpuhMqn00KH2B?=
 =?us-ascii?Q?XKZKDOzmM4S5+S/rwyaV88kQvaDTP4BgxlBB1geytrMs7j+8S/i9Rmp7z0xP?=
 =?us-ascii?Q?ijn1+z/VW5JICTvsB/jMLBHujJ65Vq6zxheu9Y4dNi/QYy7L3XuStWCtH0z5?=
 =?us-ascii?Q?ifaSB4d+rKdvd+eIrGKBlp34nqBfOWMF/fDRNDP5vWEd/dRELB8WnZ/WHIWB?=
 =?us-ascii?Q?DRA+lEGaOPyew4C+EmC0VBq6cpr+vk011IaxIQkL6QKufoC4XvvzyK8kKHT1?=
 =?us-ascii?Q?mK/34WT6QT0/EDKvWg5iaxOMRHoIjefQBWWlVfB9UcjMinFrgI6rpq6kxaFL?=
 =?us-ascii?Q?VBG1eJTWhNe28V5bomE1bYJ7ttz1/u2VumEZFgYZR8JRBO+KAHdDZspUjIZm?=
 =?us-ascii?Q?iL31N22kWJYcXh+3RZg0yiD+3iXPpQ04Aw3igkuppRqym1iKlUY7gWQU6rp9?=
 =?us-ascii?Q?CPtm8YpJf/3wDu79sv3hkmRo4Hkkeb6sgKDJ8+siebo1AlJP6sTEMGZABT28?=
 =?us-ascii?Q?05uM+Mlf4HoabpPhfmMYBuIkbnHCIUJYuC6q2eHKcCMF7P+rZbS1wqMO+hhr?=
 =?us-ascii?Q?5pXVD2M/ntmSE90AeXooen2b8kgy1OAuK1t5TJISAms00SCeTQf20mAXiuBK?=
 =?us-ascii?Q?XRk4KlEYD/4YWwPEY+6gPXM85IOYVNDaW7Mo7YRr2LM1vYMaNFljD3NS15ey?=
 =?us-ascii?Q?RUENHca3KiQ1LiSyDe1d5DURoqOQfL8VQ7lNQ26dSO1DoJq2ne6fcRzTxNmy?=
 =?us-ascii?Q?N9t/GWcfRaGGQ+Fpgo7FVuMd7g9tiffUojOMWWN3/crKItAT7s4Nbi1T5Bth?=
 =?us-ascii?Q?t7CEfcB3i1Do+/hAakBNPeYgcWGhe1V6vLQcnZ8Jxdgihh2DiKkmGjD8EBXi?=
 =?us-ascii?Q?+ZaZbgZipfmqIKWCfHyfaHqJOqrS6I9JlzpwLcqwdyF34Yg+VsKg5AYix+Uz?=
 =?us-ascii?Q?YLSpLxXy4h4+nHosCVkZfkMILGEJaGUG96hxIR3SzET6FZu7+OOUdp0vtg3r?=
 =?us-ascii?Q?aUHBei7L8/H5/Tpqtd474+uVO3tQyvanQP2t8nKh4prJsNhUOyJKKVEL37IR?=
 =?us-ascii?Q?GRNEJPMFfihQCyvyuvqXiIt4+Hw3ic+MJqcjX82HrxGbU4f8mGPBKnmnY2Yu?=
 =?us-ascii?Q?iCglzZ+lPZOfg+9wYxP45jQnJXHwB40fI/sKilB6scmxRfeNckVk0Mi7Bzfz?=
 =?us-ascii?Q?mjEgVVZLTHBoNKQyVIU3iTahvEUSuVnQNPzAb7eZP0hWVdKpHG0Gf/gUOpTC?=
 =?us-ascii?Q?phrk5ciSL2hOHn7zC3fWpElq5g+j0USg0c1CL0I3Jil1GAC47XdGmZBQPM/a?=
 =?us-ascii?Q?BNCswGJ6nBsCpEs333ZI5XngAr+T67tta/RfeR1NzG8nk03R6yKpmlEffyTu?=
 =?us-ascii?Q?tZbkA2IoXO2R2VAWuJ4OcUY28EaaCv826H0Y3suVsbWGU/ImcYuxhY4DJ7tm?=
 =?us-ascii?Q?lDwTtFfPD75xF5bGYrLPR0ymO7d7aboHpDim9jjdr/sl0VtVMC41ENeADcd2?=
 =?us-ascii?Q?jio5CCNtGkLj0rQXnlc73UCdQN/fZSm+lt23Cx9oOte4kEdn2gOvflJcsiAp?=
 =?us-ascii?Q?/g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <432ADA23FDC5A3459DFB82BA0F2C6E23@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6160460-c5f9-44f3-7c29-08da5874e541
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2022 19:40:31.1602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MKKrMihKlyqInvmhquSYVWj3ihwI6NhClqwTrf8gJQSH+ddJJpzEOSt9RHxszEMp3ydLOdPNPQ2hlJbZ2MISFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2535
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 11:46:44AM -0700, Jakub Kicinski wrote:
> On Sun, 26 Jun 2022 15:05:05 +0300 Vladimir Oltean wrote:
> > When a frame is dropped due to a queue system oversize condition, the
> > counter that increments is the generic "drop_tail" in ethtool -S, even
> > if this isn't a tail drop as the rest (i.e. the controlling watermarks
> > don't count these frames, as can be seen in "devlink sb occupancy show
> > pci/0000:00:00.5 sb 0"). So the hardware counter is unspecific
> > regarding the drop reason.
>=20
> I had mixed feelings about the stats, as I usually do, but I don't
> recall if I sent that email. Are you at least counting the drop_tail
> into one of the standard tx error / drop stats so admins will notice?

Sorry for being unclear, fact is, I had even forgot this small detail
between testing and writing the commit message...

The switch, being a switch, will not 'drop' the packet per se, it will
still try to forward it towards the ports it can. It will only drop it
and record it as such if it couldn't forward it towards any port (i.e.
if we're in a 2-port bridge and there isn't any learned FDB entry, it
will still flood it towards the CPU).
Because of that, the "drop_tail" counter is incremented on the _ingress_
port. Good luck counting that into a tx_errors counter :)=
