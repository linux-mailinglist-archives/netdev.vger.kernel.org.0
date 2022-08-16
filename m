Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5935957E7
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiHPKSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbiHPKSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:18:03 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2043.outbound.protection.outlook.com [40.107.20.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B2B3D5A9
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:10:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLaM2hfSIkm9wcbb1lTi1B9q2vhLxQsl6lfRj+wQr7523M7CK6KdCzaoaB+1Ez88RSbF8CzzpSQbRGskcbkz1Q86ygRR3HmmI79KbC+pYwzZ++MdpB5YOZBQS5Ns1Wf7O4vkM5cndvzSruN8ZZeOCD522Jp7XYzwfzEzeAQCUyAif0niETmr4lIzTwvlkVko/e2T4TbmsHLfVkZ7b49e4TAoCdSQMXkQiAxa6RwgNAXlH3a8wMG+Arwm7arMfQlOhKppCq6dx/nZI2V1H5SOqkhD/yPXQ78txUUoztjtU7ezBq5zrSR9ppI9lBhZN6V295W6SoP+S566U8PAh68w4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xVNDR097mIVF9yY5OhVf9yPRRM6scwMTnYNbTh3bd+w=;
 b=ZxhMsBkrxwvSppnemy2Nr+PUPVagoSAAgBvpNzdsP7MCRZXh/m5ZJR96iPSgaiAkeNYOMrfDFnehdXwy8qv2nHtU8eqGJOYgLJBqXXxGNyulB/rCupoO32K7R175Fm+C+m1b6eJtY8s4KSRSEoOPMSTBZGOwzQGLJC18Kb5Qc4JVgfUJb6jf2cTGwpMueEVJtrDTn0/qfXt4QkrzymHD71je7J94uxu0LFtvxluA9913gu7EcJTiR7EINgG+BY9ESoj7RNqDRKMlHO/CTo/9oUXpShuh5211t98iVT4ahDzqkL19/GdDe7K4ca/fDiR20RPmIrddD3itJlLS9hNKmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xVNDR097mIVF9yY5OhVf9yPRRM6scwMTnYNbTh3bd+w=;
 b=XmE01e9KGwq43rwGq3NBRKZB9yVGDekSba2un7X6CT3ZsFI+vSr/+Ru9jg82hJniavSB4mENpsRfFD0GRd/Y0aGSIr5DmHj3p35aLZCYNVrBFzfJZ2MDgcYlLYyWj2Xba6Ye/AO5cKkbRKqMjbUQoj0UCeeh+GOX430hGSr98yg=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5608.eurprd04.prod.outlook.com (2603:10a6:20b:a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Tue, 16 Aug
 2022 09:10:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Tue, 16 Aug 2022
 09:10:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "marton12050@gmail.com" <marton12050@gmail.com>,
        "peti.antal99@gmail.com" <peti.antal99@gmail.com>
Subject: Re: igc: missing HW timestamps at TX
Thread-Topic: igc: missing HW timestamps at TX
Thread-Index: AQHYmepVJYOkQdQn8k+cRlOb7lKNfK2wqy+AgAANKICAAAtWgIAAqJKA
Date:   Tue, 16 Aug 2022 09:10:34 +0000
Message-ID: <20220816091033.n6zfyiastdugfvfr@skbuf>
References: <87tu7emqb9.fsf@intel.com>
 <695ec13e018d1111cf3e16a309069a72d55ea70e.camel@ericsson.com>
 <d5571f0ea205e26bced51220044781131296aaac.camel@ericsson.com>
 <87tu6i6h1k.fsf@intel.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <252755c5f3b83c86fac5cb60c70931204b0ed6df.camel@ericsson.com>
 <20220812201654.qx7e37otu32pxnbk@skbuf> <87v8qti3u2.fsf@intel.com>
 <20220815222639.346wachaaq5zjwue@skbuf> <87k079hzry.fsf@intel.com>
In-Reply-To: <87k079hzry.fsf@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd723dc0-6553-44a0-a163-08da7f672d4a
x-ms-traffictypediagnostic: AM6PR04MB5608:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yLfgMQbvleUFBezK9drUW5xaDvFOovKiHhmESKM7IyIkItsodkVGFzG5VKPb+Uiuxe2xfkZau7zrCoxbdXk//MkFID+cQnIEX7FkMTyvskfodEz0iSHiFAibdvbP0TRqsBZurf/16HmiG0Kz/N2CkwDMnBwFwIlH62lSmSURGSf1405eDhxANdJEottuUZbnD16KvYVTzsgOvGifO10YB+ozV5g0LQxhEmDyepQSrWLVtzMESa9i3cFsaN0WxihViyQYtwaO8xu1Iw6JMdPfrCaYd8DDhQUE9qEn3ok3VO1WYQLweGD0hrUJfWZbXl0lVHaiYR8COY4AzV3PxmDkqmMO4urIn57gsU44g9/ju/dII1SHbsk345g3lo7jJFxPdtn62SsWU3SXhCuTpC3PL77VCPi7yPtSJDnZrIA/4CoLR81Y2DGgYixqKS91p46/XFDjXCVLUuc7fCtM0K1cin+uYSXe8DN2xoaZk1GzMsqYNfO5AJepdiWWgnsyfsxxdHsIu49UPTS3LJnU5uJdo1LHBNufNIZd2LtIC2oSO4lwyhfCa5M7KkNbD/iPmeOiEi+z7LkXRlO8l1DkXyWQg8HrSfFxfe+XaTgLx9EymZOb0UPjQKv8mPYduySMpYHh3Tj27U07ChZUWyznrKt8VQXAJ5fktS5FiJZh7rc71uIZy5g00Ru5yX9G/U+t0+6UkUc47RTTTn329c4OiCeNMq5carz5HbSvN+5/ZiCei4zXwYs6FwFGk8TAHU9CCGAEJfk7zbWagLiU2nkM9zLpiif9vY5mifuo671bNqKvPX8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(396003)(39860400002)(136003)(376002)(366004)(6506007)(26005)(6512007)(316002)(54906003)(86362001)(478600001)(6486002)(71200400001)(6916009)(33716001)(41300700001)(186003)(122000001)(9686003)(38100700002)(38070700005)(64756008)(1076003)(83380400001)(76116006)(66556008)(66946007)(5660300002)(91956017)(44832011)(66476007)(66446008)(4326008)(8676002)(8936002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?p1BUx0FpY3q/wMxrciZX6H3fXuKZvE+KKdaaxeUJfdO0e9SCHX8MXu0m9wkR?=
 =?us-ascii?Q?l2E7hWvjhHxtiK6cgszRvFGiEa0F8eem97pcv4/MpBXdq6D0XuTSdgG1o4nT?=
 =?us-ascii?Q?BHmFT4LWNK1bxKhi37nORJbiSlybIpJR9B0qcr2mwGsjOzMnGAPflDzvTgAG?=
 =?us-ascii?Q?Aw6URZ/lLleyUcBTmKnAWwZ5pSJm1Z4wkklHRY1MtuTjM6Q1rR5X7DCL1cGb?=
 =?us-ascii?Q?RDyKDTRzIIIJfEDa/ZUjix3X1t0nXyltNu1bfK/uMgRuxixeeO4fP6Y0huU8?=
 =?us-ascii?Q?/aYaGeGfbHCv83p8JRydyopUmHyPD/INb3V03TLlrUJNnWslLZdeCtyLs8pA?=
 =?us-ascii?Q?zVo/G2RTiJOc14YsGPRdB1Jd73LfwvlVA8le0euXiAJcJ96DfGpLSzYlxvlY?=
 =?us-ascii?Q?ekoULKJanG73LrT2dD3vjsjgx1ZyyfhzM3itaRy49gr7UN8JMEfNXQzKAinY?=
 =?us-ascii?Q?2KQjMeqp7IT3afCTvWec+TXvYXaJczCUmLBoXQkCTPDYsOe9kwxAzkSPiucC?=
 =?us-ascii?Q?B21KsPPi5VfBkBGeeky2SwzPxPgUjKu2hthuE8bb0VonddkjFATG3Bf/ojWz?=
 =?us-ascii?Q?RuFM9EI8R8A2olzu2T7FfrG9bUgWEiIvkm76auNDPvwlfIHomPtM4o10TKrS?=
 =?us-ascii?Q?pqBVLL4eiMXOoWoQm41E9Gad7dQibnG2CYT1YO4GjEr3KXod/CCot/0ZK42p?=
 =?us-ascii?Q?9H5JQLoZ8JodbE6Q74erOk6jGj4dEpGwnqtKsQQwGz/w5towXLOumZn2ozvi?=
 =?us-ascii?Q?EGAEFnh2CjADd5RD6migi3bWgbfw51nAez5+jTr8X/+CDhWYfYcYWm8K68cp?=
 =?us-ascii?Q?uOZ8+QaBk9ZJ48fhdKOnweraeRRQjlMrm8oaAOwxVUEZvoXPVctsLz1LAi4T?=
 =?us-ascii?Q?onlpO/9MJJChTpR/E8cDx+wRX3+g1Qp7o+iZ8KeLaEVDGt9jk+4feWciNAio?=
 =?us-ascii?Q?yXOLW7TR/DJ1DpAsJRruRhX8XWBF4Q/sA2j3NMpdebWp52BrGf7rzNtGfDST?=
 =?us-ascii?Q?a+MLowu+P+wLVTksP2aRAAjhuK7kmoLh9ucdfaGw8q4Y7MWDrR93WvZI11m9?=
 =?us-ascii?Q?o2auJrqOE6OXYQA4R8bHGy/IM9xIhWTh9Zhls48CTuGrkZS1XrFL3/LWESlu?=
 =?us-ascii?Q?c1bxoHiOg3Voia7x3Ki+zvmM2ZW83zBAV9Ug7TLbnOVD4/Xv04sZ4XSCbx9A?=
 =?us-ascii?Q?GN0U9EEAJHuqvFHipReAfaSWeLNBqKCYZAG2al7aq6BYi4xEMUGqDImrILTu?=
 =?us-ascii?Q?lVeFirHfpsSElFpHczDzCw8KOhI9RwK/zUYzM3etpSxZNO+ZzhSoEiPuWDPN?=
 =?us-ascii?Q?aguixVgdkRc3b3JxeY8iaRh+NSdcqT4LvL1X9pDxey4hFipA9KGRe60T5H0R?=
 =?us-ascii?Q?q2ef7CZlgW7LAL5+uprWTGo09piyzXO9uCAPPny3XYIhBWt7OCzNAHWgZBHJ?=
 =?us-ascii?Q?8Edq+2yujef9/mBAVx5MtUH4OXdwXr1d8szTkIMAJPZpd4V6rxyhl48+O9QN?=
 =?us-ascii?Q?sp/K6xLwcDjYTcGsoe++QEwqDLWJjok+Grdohpa08VUGwpno7ZWASjYoEc+G?=
 =?us-ascii?Q?+Fx7hQZ6PVf0STflYy8Th+tJBjW3hiESeiD4u0eeui1gWfLRGoXZyMzpS/0i?=
 =?us-ascii?Q?EQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5732F81F2C234D4AA82899A2279B5B01@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd723dc0-6553-44a0-a163-08da7f672d4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 09:10:34.3946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WbKGYttQJG0iNCYqWyHMaFGI9OyjgNwui/SwGrGRKAUvFFu2qZYfTDu84JgiVldiut+oDlH66z/u/aflS78G0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5608
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On Mon, Aug 15, 2022 at 04:07:13PM -0700, Vinicius Costa Gomes wrote:
> The interrupt that is generated is a general/misc interrupt, we have to
> check on the interrupt cause bit that it's something TimeSync related,
> and only then, we have to check that it's indeed a TX Timestamp that is
> ready. And then, there's another register with some bits saying which
> one of the 4 registers for timestamps that is ready. There are a few
> levels of indirection, but no polling.

I used the word "poll" after being inspired by the code comments:

/**
 * igc_ptp_tx_work
 * @work: pointer to work struct
 *
 * This work function polls the TSYNCTXCTL valid bit to determine when a
 * timestamp has been taken for the current stored skb.
 */

> I think your question is more "why there's that workqueue on igc?"/"why
> don't you retrieve the TX timestamp 'inline' with the interrupt?", if I
> got that right, then, I don't have a good reason, apart from the feeling
> that reading all those (5-6?) registers may take too long for a
> interrupt handler. And it's something that's being done the same for
> most (all?) Intel drivers.

Ok, so basically it is an attempt of making the interrupt handler threaded,
which doesn't run in hardirq context?

Note that this decision makes the igc limitation of "single timestampable
skb in flight" even much worse than it needs to be, because it prolongs
the "in flight" period until the system_wq actually gets to run the work
item we create.

> I have a TODO to experiment with removing the workqueue, and retrieving
> the TX timestamp in the same context as the interrupt handler, but other
> things always come up.
>=20
>=20
> Cheers,
> --=20
> Vinicius=
