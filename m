Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7305F4B9124
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbiBPT1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:27:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiBPT1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:27:03 -0500
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20136.outbound.protection.outlook.com [40.107.2.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465581A341E;
        Wed, 16 Feb 2022 11:26:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6L1qSIttIZ3pa0sewtVtB8cjNe5EIUUOfQGdsOWFcLN3TifncY8BSXmsSg8I32jWig3jxc7TeOFTWTP5Z+gV3RvEmOZXBMNjUoMjpqQUZEi9QRO6xTah4oDcNctwjqA9pUeOx10qMBWKvVQRJpMkVPkvk9oJ1Ngh3er7chW0RCUlGnv02FkjRgRUzbHsLceGlFIhSB0zhU4jZbkiLgIl/xeZbbGWfpJE/nG/C3F2c7gr1PUBjdhu4hXnavENFQ0p2a/gyynBrNHi3RSQP7x7t4Rqr5m2xmfyESkt+zp+2UBDqmgsfwL+LyPu/nUNle8KCGMJcn8lAjyS29PrQiT2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AxV7QKwN3cgCGshvNwKoI61VfitQvSXvIkd1SrnkCd8=;
 b=FvDsDXxsKyn5LNsQE5CGxOa5YoNwm3pZvoI443dHA+vilWkVOXhHeDiqgj9QOVXg55pfHPuoFuaOHep/8aoyt/RVGStwdlvcjOT7W0FZ0EmLzqm9nJABlGXNCJJtGkTTnpQgxXRhmxv/Sb9QnM0sTUYyB8uivRYJ/nIDzRyGDrpEpn3a5qEKagQrW9SDnsWkfL3j+Qp9XWhhLXQsxFqRwcwMbr2zIZxeK1nQy09Lau87rJv1YQMqeR1HvrQCiTXmth0gfpDvrO1QN/wkvAkIxEsEb6WGTtdVn5bYNlqQaocI7A1hPjfO5zkxm3bLi1KJlgXv0mz3VjAOgvxXkGg6ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AxV7QKwN3cgCGshvNwKoI61VfitQvSXvIkd1SrnkCd8=;
 b=CsJiBV6XMsbE2ak0JFpvhtBcRRl7d3hikQbZeD3cpXvk85+BCmQY8mxEtP0AIO9PvE8aftBdJSzNt9+4ECPe6oZx8rdDq8YrikVcxV2RhQumljQSWKeqAe18A9P8Hk/fx1SQBq6TxDRwD0cOBse08ENjEZxNdMcUBvEs1//1VFU=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM0PR0302MB3379.eurprd03.prod.outlook.com (2603:10a6:208:5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Wed, 16 Feb
 2022 19:26:43 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 19:26:43 +0000
From:   =?windows-1254?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?windows-1254?Q?Alvin_=8Aipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        =?windows-1254?Q?Ar=FDn=E7_=DCNAL?= <arinc.unal@arinc9.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read
 corruption
Thread-Topic: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read
 corruption
Thread-Index: AQHYI06+Oi3bmZ4n+EmyFAzgV7y6pg==
Date:   Wed, 16 Feb 2022 19:26:43 +0000
Message-ID: <878ruasjd8.fsf@bang-olufsen.dk>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
        <CAJq09z6Mr7QFSyqWuM1jjm9Dis4Pa2A4yi=NJv1w4FM0WoyqtA@mail.gmail.com>
        <87k0dusmar.fsf@bang-olufsen.dk> <Yg1MfpK5PwiAbGfU@lunn.ch>
In-Reply-To: <Yg1MfpK5PwiAbGfU@lunn.ch> (Andrew Lunn's message of "Wed, 16 Feb
        2022 20:11:58 +0100")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33bb0bb9-6e2c-4322-b808-08d9f18243fa
x-ms-traffictypediagnostic: AM0PR0302MB3379:EE_
x-microsoft-antispam-prvs: <AM0PR0302MB3379913DF64F3A80AAD92C4F83359@AM0PR0302MB3379.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wet6Md9UsXrsghVjGiZMclsRDEyxJ5/Hgnqz33VgohF7oN8uljezGeaVswG6UPTiSdbIozaRiE9xQQponHjeP/Sf5xkMycgvuXemKZ7zAbcVcjp0BQ1hVrRRVCL+xCWNV6G+94TlJUWXnYpLg1KMSBtQpZLAvC3maiAH/S8804QWLslbgmFRdAkn2ziLXeqanylRPo3ZxihakoglN0tccwAVh1mypXQWk+Pa5RuL7u8GOwgLO1jWxGKUvf1bEu7AJG6mY6xIq+ysia2+juDLcEZvESdn9jYBcpIKbjhX1sXwjfWyW9xJMTBF9Z1ofpqGcLlyYMBwqkhpmRMyiFyICNtbrX+8QOijIuOK+Hxb8qiB3L6swzvi+OcFcLFzlL0F80Hq+TofPEor5//SBIWmH3T7uZKxj6ZqT/wMBngCJVxpEPFjGJP5x6I2JrRQSMPz5xGnzlsmPVoHeJWp+YjZfZ5k16nhnH8NtKSepGg81bs096vRCkjac+Y8il/nynF1zIvHdDFHe8IsM8XIeU162JLT9Hwl/HEEyb8MTO4CK5Vb2uljlsptcnwD/OSWHySOp0WRmqkwmYatNiWV/zs8CERb930Q21mInLzDol4HWn0aHU2quaThcbBEcjMkjm8lKS4wNe/+TRdiVh00/ZUXb9/xMMsSbiys9xcMs5fFOMCA8HAF5E2Vb3RlL4xrtkcAJusYEcITexi3pHNtJAmccg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(8936002)(5660300002)(8976002)(186003)(83380400001)(6506007)(6916009)(66556008)(54906003)(6512007)(508600001)(6486002)(71200400001)(316002)(8676002)(4326008)(66476007)(66446008)(76116006)(2906002)(26005)(2616005)(91956017)(66946007)(38100700002)(86362001)(38070700005)(122000001)(36756003)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1254?Q?s+SzKHBl9BnzIAmYT10e9tRshW46AV31KgYSeWrM20XrFwB9P8zvg/cP?=
 =?windows-1254?Q?ck279UEHI9/zzDx2Oag04iPsr9MdS/vmZfpWhkEfuN6Cfqk3H6NbbeEF?=
 =?windows-1254?Q?frJ1id/xmLhfaL6LSwSnmIIqqS/LUwosTwezbtEZCsGw0Kx/zhwk+MzD?=
 =?windows-1254?Q?+x+qAvvCNY1RSi3M9LkMLkrJVKlW4eydJxl5PSYe2X4FV8rLsI7DxdTs?=
 =?windows-1254?Q?p1NZjJxNeg5rrIg1XhkCJtWaAD6wBRo4UV6wBsEt+ABm2P/xog+88Kyz?=
 =?windows-1254?Q?UKqRuQ3bI7bM5Rk6bkN1qYeV6w5rCF4UzGRKenmPVTnU45yUKUJW/kQw?=
 =?windows-1254?Q?aoolUUKrfNLkP9X9UHTGwyBZ59hXgo1MXnK1PcyoLIbXQMcMagx5+k7Q?=
 =?windows-1254?Q?SLzWWEk78IwxoEGGxBhfwaQhwSgI6aZGKsMi6MKVIW5BxmGdO7Aetaq1?=
 =?windows-1254?Q?smtRpdb/lcJTHMBYLHgFdXtYlH01dBYoosahNWIZyP+SIUzcXKZTWTLV?=
 =?windows-1254?Q?0wnpkqPU1OXnL8NclhZ3uoOlwV603OtIaFrgI03CHi7Bh2hzxDjgjqYn?=
 =?windows-1254?Q?BciaT166OHxzl0sc4TgZizJYcC0uW0R3o80qnRRQLtclZSSca0geNkNg?=
 =?windows-1254?Q?iz4nZeYbPvlevaaCZenwCwa1P04HdL6+EgdYCuWF4RmythxtptZScMXu?=
 =?windows-1254?Q?jZ90v023be+u+1eFO/ZnS4+MxP8o3c/2/gg1j0v6an3l6xq4Z4Er6bND?=
 =?windows-1254?Q?nXUvG18vh8ZwSl3KibiLmDfX1KrgCh59eax1q8uTTFb1G+0gGltFdSUh?=
 =?windows-1254?Q?CBavn1RQLS6hQLK9sXg2K2lRTIO5N89QXAb/FBiR//4eqrxx94JGYmzx?=
 =?windows-1254?Q?TF2e5WHC1VtvDDN9Ct3nSN27PK0ngxOjuxSEPkE2CO2epuMQghdSUO72?=
 =?windows-1254?Q?kvO2H+YIP90KPq8bzJrrSmIWop5k1/8s9TZECqURIv7ied7G9eA/72zE?=
 =?windows-1254?Q?TeVvAzmzNc2ietxBrZ3N6uiqEfgQfPTpnZC+P4EQJXzOpEB8FlChutIl?=
 =?windows-1254?Q?3FcBnJoIYJGuWIitBfqpImToVGgej06VxDeA17cFm2FgWpG8uQaCGdGC?=
 =?windows-1254?Q?2q49a0fd7ksmmEtDqcqau95XcKHLBui12yZY69JBcMLiGp/+6GMtZ7ku?=
 =?windows-1254?Q?EDWZZ0RdbX1C737Q4zztjjx7fwocbXi2XDKf+B81KMaBGMWHYvF0lL4z?=
 =?windows-1254?Q?7MzVxTTHuEK2E9YXpwy3b+oDFW2EbcnAYcCOwxlAFuO46IRZvlBed09x?=
 =?windows-1254?Q?hkWOnuU1skEKVHYZHIwJETcOrRKZscUiLWL+jS3w+PLgfmcJujVhpNHz?=
 =?windows-1254?Q?1MNOZcbrgVMBZWfsroDFUkvjcZiF6vIAcGmlmGxDgq69UrAyY0NSKGMp?=
 =?windows-1254?Q?I85pZ5N/AZYkFdYifrWUf7fcwbO6VQn17XOa4xMRPeUOIMKTUiEO2LGD?=
 =?windows-1254?Q?55ygtzXyZDuREPPCLvvRP9d+V7sBLNfxAE9AxoHQa77T3t+Oi22cTsY/?=
 =?windows-1254?Q?zMVWQLa9rqMY2UoAwaQWAzH2L4GVELhkXybVvYtdf1qALpeXMyjuvISU?=
 =?windows-1254?Q?XhBvpTu/rhGPeDZ9nfHIzCIai/TbTKo+8B1Hf3Vu+ZhIDNWei95kVxLZ?=
 =?windows-1254?Q?iSYOOI4x+bFqsiWLysMSDN4Az6UpZXy9J+pB6HFOT+tRGzWlREDp9bta?=
 =?windows-1254?Q?ZceoKt3byXbSe4NfAu4=3D?=
Content-Type: text/plain; charset="windows-1254"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33bb0bb9-6e2c-4322-b808-08d9f18243fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 19:26:43.7089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4SYskooHvHLaavVzEhPPNiEt3KaMhUaipgG2viWzOOU4aijSK8YREFnuDrbCFk86RLjEYU08dBe1uJNCtsvagw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0302MB3379
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:
>> Hmm OK. Actually I'm a bit confused about the mdio_lock: can you explain
>> what it's guarding against, for someone unfamiliar with MDIO?
>
> The more normal use case for MDIO is for PHYs, not switches. There can
> be multiple PHYs on one MDIO bus. And these PHYs each have there own
> state machine in phylib. At any point in time, that state machine can
> request the driver to do something, like poll the PHY status, does it
> have link? To prevent two PHY drivers trying to use the MDIO bus at
> the same time, there is an MDIO lock. At the beginning of an MDIO
> transaction, the lock is taken. And the end of the transaction,
> reading or writing one register of a device on the bus, the lock is
> released.
>
> So the MDIO lock simply ensures there is only one user of the MDIO bus
> at one time, for a single read or write.
>
> For PHYs this is sufficient. For switches, sometimes you need
> additional protection. The granularity of an access might not be a
> single register read or a write. It could be you need to read or write
> a few registers in an atomic way. If that is the case, you need a lock
> at a higher level.

Thank you Andrew for the clear explanation.

Somewhat unrelated to this series, but are you able to explain to me the
difference between:

	mutex_lock(&bus->mdio_lock);
and
	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);

While looking at other driver examples I noticed the latter form quite a
few times too.

Kind regards,
Alvin=
