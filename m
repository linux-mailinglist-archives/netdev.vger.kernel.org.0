Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 039444AF72C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 17:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237365AbiBIQtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 11:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236897AbiBIQtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 11:49:21 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2137.outbound.protection.outlook.com [40.107.21.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF350C0613C9;
        Wed,  9 Feb 2022 08:49:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vh7VFDdeWJS3cytRPk8FpSOP3q1Csea7Y2Axao9pFWECDk96tHMdfbZR+VcCFcwtcr/Dwfcrjw+LcFmqjJDILJwoBmE2vGDdRSbcFVoAF8VIbAXTaSPACmwCsus+Ny7o45L6gxmKB5y8FUndoA+WI1O27W4SZZAUDgSq+leLOGfbmB4/u3ielk4xYnNe1wl90CNnwdKcKqizlX1mC1b+jrbxoQkT4bqE1mb7fXaA4rIGeTfrUrvYaL6AB40thjOQ20PmCj846zBoyp/Rtb7MorAkr+DtEEN/O9wfhI3bnzTV8uKMD4OxUYogm5/9jxxpAkzlDLyYOJou4vd0ynAy9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKwvOGGFOuW4P+2UnfAgh+z8hnbOXM/11/NYZuQbvQo=;
 b=aW3HQ0Xf8gy4U+07u3SpkkZ3DehC+gMl85jR88o7FVXHufNO8ueOGkkYrgaLVaE6rN1tEWIJ4BBbGNd2vdM3y7nppMQHUwcjFIinxeY89ysKSTPuhi358+m/uHcHssjKg3xtmUXs8JjIKURhuo5MaySnOf442pbD24NoxQ4KgiKr/vcEU97/fGSwXf3SZAgkoYTsKu2wUd6p8Hon90KD89v3KWyacJ0R9DYJdTncxja7+3UB7mrtPBhT6MHFHT8beun6+GvhUPBiDcNxfsQq03xGqXwjqP+lGleARhFEv3fflNrPysTKUyfchS1GYyP8ty5VmkxgcmtHgKAXOcnD8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKwvOGGFOuW4P+2UnfAgh+z8hnbOXM/11/NYZuQbvQo=;
 b=folUGCtPWAwfgPCrHbzwEjohUNtDvHCmwjHq9omgXeMS2dBWeP4vimo85i1xSwENdHdMHAx668H1Z5TtSdMzLMSfFEKbKXx81Z1gMlJcrpj3Q0jl0B5aY8mUwhBRYRjJP5NaB0jYhEVvwQFsBXKp22KASqVmttMhvu4VcrwZpkg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR0301MB2285.eurprd03.prod.outlook.com (2603:10a6:800:27::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Wed, 9 Feb
 2022 16:49:20 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::54e1:e5b6:d111:b8a7%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 16:49:20 +0000
From:   =?windows-1254?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Rob Herring <robh@kernel.org>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        =?windows-1254?Q?Ar=FDn=E7_=DCNAL?= <arinc.unal@arinc9.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML
 schema
Thread-Topic: [PATCH] dt-bindings: net: dsa: realtek-smi: convert to YAML
 schema
Thread-Index: AQHX+7x190ifeZKfKUO5Ng/OWHmcTQ==
Date:   Wed, 9 Feb 2022 16:49:20 +0000
Message-ID: <87zgn0gf3k.fsf@bang-olufsen.dk>
References: <20211228072645.32341-1-luizluca@gmail.com>
        <Ydx4+o5TsWZkZd45@robh.at.kernel.org>
        <CAJq09z4G40ttsTHXtOywjyusNLSjt_BQ9D78PhwSodJr=4p6OA@mail.gmail.com>
        <CAL_JsqJ4SsEzZz=JfFMDDUMXEDfybMZw4BVDcj1MoapM+8jQwg@mail.gmail.com>
In-Reply-To: <CAL_JsqJ4SsEzZz=JfFMDDUMXEDfybMZw4BVDcj1MoapM+8jQwg@mail.gmail.com>       (Rob
 Herring's message of "Wed, 9 Feb 2022 09:28:59 -0600")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c731cd6e-8b7e-4b7e-9e89-08d9ebec1e81
x-ms-traffictypediagnostic: VI1PR0301MB2285:EE_
x-microsoft-antispam-prvs: <VI1PR0301MB22859DF5ABA3F0207CB14E63832E9@VI1PR0301MB2285.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jl72+bTCpzYE6V9W3+ihXONrE2babWQx9WNDMuAIFuV6/D+BgRn55ee1RkptwvlsoATf7uorNntjJIJ3YSB3nFVqlbO/WoGX5acY6uxzZv8CIv1e9HHs/sFpbdr2DudRA7aGbNjUmHoPtwvMxk/JZCXUHH6zgLP51mgerQlpQnB8YCvmci8J9yN/qp5PFJzOctBmaSQxbDzwhAtOWFY68Vo0HOfg5wHfCUw0WD/MSr4w2AwBIfD9N9TmYS4Ywt5tmzN0Z7/vL1EleT1xDc5LgTO8gjgAOBTxL3z3s7UWjIhXuCNRyfVA2JMf25qhaP8xYUl+aX/C+3bUF5Dzh+5EwH00z6zlFX2iYt9mapPsSLFTdfYUq0zvuHFN0dCU0Wuax6Jhkq84j2m4+YXc/prMi3p1QOqHHzATA7VkOTh0edYS8XmqC9U1zRIxUe9J82xFflLORSh/KJmyQyNYJ1NacDzVxzYalvukGCcF53ljSCJ4+SCogzRDFda6d/vYHBKsVYqM7l51gUpQAs8Mw7MSM+vD9TR0Nu7V5/ajDs8kMZ8WkTXW9UGtFCeJmXE40uSfFxnNiiHlTNIMSJ4BXmBYn8yhiqZSR8/3dxV5F6L8bieIUA2wfbrWwF72I3IcORrxMm//kFgI6XyNxHz6Z5kDtb+UGvyT+wvQTn3D13y2yLIlfE+Wbh/+SrED3UQZ4gaCqNrN/Otkj24pmuraGiWDJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(8936002)(64756008)(66446008)(66946007)(6486002)(6916009)(4326008)(66556008)(76116006)(86362001)(54906003)(6506007)(91956017)(7416002)(66476007)(316002)(71200400001)(5660300002)(6512007)(508600001)(26005)(2616005)(122000001)(83380400001)(8976002)(2906002)(36756003)(38070700005)(38100700002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1254?Q?3LivN6TRY1uxIZ0GpRRac/4nFDLckHKpdbJtgOhsuV6w3BholNx73PEc?=
 =?windows-1254?Q?wF9tlWxqhU7lSa4ki7+O4gibou1BDj8+TG/ED/2eSiE37Olg1/7cLx+q?=
 =?windows-1254?Q?C+M9U8ICEz5BUGI+yYflzFCJKNIGNILoqyEHlsqOSo07FpvXoY8GQexC?=
 =?windows-1254?Q?pK5n90yKwJKpxgNH0jyqRN4VuF+WNoOKmYTgUzVp1FQqfyN0FpAvxT6t?=
 =?windows-1254?Q?nWrfsm4XQVXX8pIFyCLjxX6xj8Cc0lDhVkMz+0awdU/uWiXKV5L1inqC?=
 =?windows-1254?Q?1J6UY4TwyjYT/ZF5eWbVsPmb3AbRyeSdNDE3ynrtvotuvityiJnsirbk?=
 =?windows-1254?Q?VdhtsTl5KPkl6rTwzg3miayi7F2cj1ZlwINGY2ssLiURwsoVPzBOPtDq?=
 =?windows-1254?Q?PXRFLH8IuPLIVuQtFCMrtpkaIxlXH1CQjwgE9R3fPyS60O2TU9RJ20Wj?=
 =?windows-1254?Q?B8EwIS/Z0ZBLSeaWpaKQ5mgm4jwt/reDl+Q9X/mxHBITbkGuKCLN2N2b?=
 =?windows-1254?Q?z3ZPEI9EbHbRjXm9Bo4pUB4AJOVAdxus56PloRpDZacFiQ2A8gMIceQo?=
 =?windows-1254?Q?9jCuYh6lfhQVstr0Ndx4ZFgDytX+FcOnt8N0fCJyLe7p8OChBYkc4y1b?=
 =?windows-1254?Q?le5U+u2I4zBM5AZdRC5vfqBtLVWdwUFqNPwF4qkAyuLe+RYE3D0+8e4S?=
 =?windows-1254?Q?h20pNnsB4/maCaDzgG3yTaJ4hvASRSUxvhop5seei7ETqhI+qOg281wI?=
 =?windows-1254?Q?utTZq/TTrHcT2ZyBa7onUwu4CPSWCBV4C/+mDALgkoa7quRboTL5xdqt?=
 =?windows-1254?Q?vRn5zpp1XGcjn1ErYQ3idCY/m8B3CZHxEdGvORsunlqDDl7qzHEKcc7H?=
 =?windows-1254?Q?Hv7AHeqefPJ+Me08TN3zTDVij6c6Zu4D02m+20NdeLvy20YbWYN06e3T?=
 =?windows-1254?Q?Xk1TC9hg7iJt6n2bttoifQEVgAhhc/GkzYQNZ5sbKEfjCpnFSXqQLdoP?=
 =?windows-1254?Q?0JAbU/6HgKYiegZXtZlB26xAzC8RJMwiEQq0jVXNODzie2C9lezMAEZU?=
 =?windows-1254?Q?AYD4VvK5nlxy0ENNJx4U4UaR5/ex3xRIg/I5dAQLglyp2rLYaC/F/nfp?=
 =?windows-1254?Q?Gvgh2qfJw/9Q3pytW9h9Z23VhrJplhG3QrLaGGkfjIVtGCPaocuud1rF?=
 =?windows-1254?Q?QKHHQl9WIOSESBIffeWEFuUlqU/ZLdqPmTud9EN9JF2ubIdmaw++m4uH?=
 =?windows-1254?Q?TDs4kzo+J4Z7MGeTYNRRhoA4Z6XsTkyRhTon2UD+813Laus7xzw4Pemb?=
 =?windows-1254?Q?BLCXEHWqlcQA3i31Mh0AaUR+BDdDzUwzK5bNMwIxgN9kykDaAHqlgncw?=
 =?windows-1254?Q?hVCbuBHf/NcNl3T6hHHgY4+iaNM1QlG0UhTYf13aQfVcTwdRxH6UWiKo?=
 =?windows-1254?Q?iJwnLzlNCIARzyYoKLb366u5wRkJ2XxNZvINu7SdZ7NiRShJyO2YEfoW?=
 =?windows-1254?Q?qmkW6Qy1oAEyn+xtiYcC5M8ez/ZW0Q5cvCg+loftNHG10eRZh1Kga5Os?=
 =?windows-1254?Q?dFq9kEnE9Iir7WgJZ0bBxTGRklt8KjRTmZfpJdnS6+8b6TYAqmAqjvBD?=
 =?windows-1254?Q?ZhsB7kF3ZdUL2Gk3iSNZbay0ki2PsLMCBKg2z6LDN89oeQAfGruIituQ?=
 =?windows-1254?Q?I5Q8AYBA3cim0HGblGr8VPojqvpv9vmsZe9T4K/WyMXwn63DU8TgyDcn?=
 =?windows-1254?Q?RYHEbBBQPiaZQ5F0pNI=3D?=
Content-Type: text/plain; charset="windows-1254"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c731cd6e-8b7e-4b7e-9e89-08d9ebec1e81
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 16:49:20.5162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q6chY7rNaPG4XEiu0Zz/JMteAtzaeqgg/JL10kqsCF+C2xU8tBPBbMzyg4/m8/58aiEuZfGGCVpeOY9z8drTKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0301MB2285
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Rob Herring <robh@kernel.org> writes:

>> >
>> > > +
>> > > +      interrupts:
>> > > +        description: TODO
>> >
>> > You have to define how many interrupts and what they are.
>>
>> I didn't write the interruption code and Linus and Alvin might help here=
.
>>
>> The switch has a single interrupt pin that signals an interruption happe=
ned.
>
> Then it's 1 interrupt?

Correct. The switch has one physcical interrupt signal.

>
>> The code reads a register to multiplex to these interruptions:
>>
>> INT_TYPE_LINK_STATUS =3D 0,
>> INT_TYPE_METER_EXCEED,
>> INT_TYPE_LEARN_LIMIT,
>> INT_TYPE_LINK_SPEED,
>> INT_TYPE_CONGEST,
>> INT_TYPE_GREEN_FEATURE,
>> INT_TYPE_LOOP_DETECT,
>> INT_TYPE_8051,
>> INT_TYPE_CABLE_DIAG,
>> INT_TYPE_ACL,
>> INT_TYPE_RESERVED, /* Unused */
>> INT_TYPE_SLIENT,
>
> Unless the DT needs to route all these interrupts to multiple nodes,
> then the switch needs to be an interrupt-controller.

Yes, it is an interrupt-controller, and an interrupt-parent to the phy
nodes.

>
>>
>> And most of them, but not all, multiplex again to each port.
>
> Now I'm lost. So it's 1 per port, not 1 for the switch?

There is one physical interrupt signal for these switches. In the switch
driver IRQ handler, some registers are inspected to decide what type of
event it is. Luiz pasted the enum of possible interrupt types in his
mail above. Most of these events are ignored, or are otherwise internal
to the switch driver. But in some cases, the interrupt is actually for
one of the embedded PHYs in the switch. That's why we make the switch
an interrupt-controller.

So, in summary:

 - one interrupt for the switch
 - the switch is an interrupt-controller
 - ... and is the interrupt-parent for the phy nodes.

The rest is internal details and shouldn't matter, as far as my
understanding of device tree bindings goes. Happy to be corrected
though.

Kind regards,
Alvin=
