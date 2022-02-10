Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345414B19CA
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 00:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345880AbiBJXtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 18:49:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345879AbiBJXtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 18:49:02 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60134.outbound.protection.outlook.com [40.107.6.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1152675
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 15:49:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kqHHnBZMzVK6DuhjHEAb6es/qp62Wqvd3m7lbDOPJZBMK2cFHsEpTWjXypB3cgTGLLW4XRfrD9McN1YNuxH2aVFTK4ZC+D1y5/ZqV/dSw1uqnFizzGiUk3v6RwXCv4htfwE1ZF7SiX8GLE4Af3iAQg4z8wiK7Fk2mAz6xn3iq94dPSKFFnXXEwRN5Q5M6/DciRgqFp4eQAAdlnd+3z07YX4Ag5CU9KQEOySD1tKJA6Cu1qOZYNr1/2f8Mlyfhb4cFn7ZQG9oq28T29MEOZFEMTktLZBHm6lOszHy9OwgnngbbFfEtxGaKpW3sIU4lYrjXzSMdFh6BcHdSqUdd3mBaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ObqIBvLNuQ5OFRMWVvh2VbV0QkdcMFvChPoQzv5c63Q=;
 b=guIAVFycdvWWt53GMk2pxoJTuN3oFdkU8aszopORwNlxT6kFtHfA+PdiHfnQAU9+9Nq7YO1wXqUo5VBZTchSIgVhlJ+5zYiHhcXjrFAGb9YEniOhqWBfqZ8G5oXuh4FcoZZvKYVc6mSMHPln0r7udaz0x1ZrxkvKM5Ta+3mfcI61EdxhXxTDy6ylO5hkiyKuG97nZtJOocdn7mErO2z1iOK9KEMNJ90pJ+CjqDw2usmhkKw4oXANHey9zQ6/GDyY9smQ3GCTNfXteR0/smHD85YBRpvM34UNaAgAaOaKZcZJbqAnphQueJFAL9JeJXVagFfMI2IaqqnHJPuYgtG1qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ObqIBvLNuQ5OFRMWVvh2VbV0QkdcMFvChPoQzv5c63Q=;
 b=lyPy632MP4y3crWFscJce66fMu7OoYPUaoi68o3IFyFzuqNdk4RnMx92RutpbxLAMBrsT41QPjD6qxVuApNT3tT6lWXw7+o/JL/LV9HkeUDVPNuRklF3NktcMQCxaKoBKsiLepkMP0XOXS+c2fN3maB7QUvVSJSQkZHmySg1BSA=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by VI1PR0302MB2800.eurprd03.prod.outlook.com (2603:10a6:800:e1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 23:48:59 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::9c8d:fd94:8af8:ff]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::9c8d:fd94:8af8:ff%7]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 23:48:59 +0000
From:   =?windows-1254?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?windows-1254?Q?Ar=FDn=E7_=DCNAL?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8365mb: irq with
 realtek-mdio
Thread-Topic: [PATCH net-next] net: dsa: realtek: rtl8365mb: irq with
 realtek-mdio
Thread-Index: AQHYHgbWVDJfLkKf9Uu9wAYrnUi8JQ==
Date:   Thu, 10 Feb 2022 23:48:59 +0000
Message-ID: <878ruil1ud.fsf@bang-olufsen.dk>
References: <20220209224538.9028-1-luizluca@gmail.com>
        <4b53b688-3769-c378-ec35-3286b3229303@gmail.com>
        <CAJq09z7QJ9qXteGMFCjYOVanu7iAP6aNO3=5a8cjYMAe+7TQfQ@mail.gmail.com>
In-Reply-To: <CAJq09z7QJ9qXteGMFCjYOVanu7iAP6aNO3=5a8cjYMAe+7TQfQ@mail.gmail.com>       (Luiz
 Angelo Daros de Luca's message of "Thu, 10 Feb 2022 19:15:58   -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dda3533e-6b80-4ffc-2c09-08d9ecefe89f
x-ms-traffictypediagnostic: VI1PR0302MB2800:EE_
x-microsoft-antispam-prvs: <VI1PR0302MB2800E17660E2CCE74DBE578E832F9@VI1PR0302MB2800.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fl8GroqlIhB/6RHZP82zksBZ2V0V6wuaEcv4qHNPgyOs/dWSI0Yv5zp0mHg4e+VuA1NdwcqN2GioVH1BUOb4QfUVPRt3UiLnG6EeBAVL9Eh5lnJCM4+zksYnQZMHzYZ16Cmkt/W1szzeYWwIluO9h+3J1hKsL68SRsc8lupNGUxq4GPYCyq1nO/srPRJjVydbE6+EKLydOs1Zooq3FiBJVJSe6Bx5ya3LaKWn4rijWyZdGcrX/gMRLXE6jDvDD5yUAoBI9MgzEd3H2PCM+XCXdVpWpMKADIhrl5JODVb6jB0JdIAumbiF/F2TwCnN2OdE4QAAvXhnSO02oUwEACBr8niX+kK9qWiHQzAWg5zHnNTvwHxdWqEGp0tFtDk47ojXZyJcYjQtqvrEUAROkJSYi45FQS7D03oiw967+WEbH8mGcoL6t07LURcw6GODczm7dfEvtex6iEUr/5xSsYU5L1VOvtI+oosL0OwmisSa9hsS7cquXnzHVj2wfG9lwosUJJgjD499xmNSs74GuxVEiq74bw7IqmJiUkEeDudPmLzyAvFe0tkGM64MOSZWMTHYt36ZOjEggHIIUdsCpt6CUf3VDLUJBGNpOL9hP9P07qsuksDlAd35Ajsdj73FIGuFTT5X4ZGRuJdgkk5ElfgjWUzrYeo16hIkwan5trNnWLZN1rTXfXf9iKu0OlNPWynibKNcvGhzgjv0iL4Io4ogA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(122000001)(36756003)(316002)(2906002)(6512007)(76116006)(8976002)(8936002)(71200400001)(91956017)(54906003)(66446008)(38100700002)(7416002)(5660300002)(66556008)(86362001)(66946007)(6506007)(64756008)(66476007)(8676002)(508600001)(6486002)(26005)(186003)(4326008)(6916009)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?windows-1254?Q?XYWNAdfu9J6XIgpUq7Q7lGlCshWlBMFyJ6yIP6Nb6tIRD27nWiBtvurC?=
 =?windows-1254?Q?Qs/KcOnFTPbPG4TBaJJoDaeEjAWDKCF9rcZZ/XUGrDiTYucgwLZ7Sy73?=
 =?windows-1254?Q?v3rvDTkDqzK+hvnU2hb0acC1y6/2upiyaAgiUxWn7Gue0vr86mUd8NHh?=
 =?windows-1254?Q?to1h3ZlGgH9TrMlmhylaBFv8yce8DWlgHPecEERCvmbS2Kky1eO5CCdC?=
 =?windows-1254?Q?63bNPBisHgGrUnw4bdXCsaBS0Dx4o4qTao9HeZ8PjTw7lLTj4GrGjRod?=
 =?windows-1254?Q?sfVawX+WDBurU4s64T4DqQ3b2ZRx5doE6NUmXcntrls1q7phDH+RoQKl?=
 =?windows-1254?Q?E1hIfpx1dqS/2YvSeTT4ffBasq4VP45lJBs6VAGBWAr+S3rGx7ZF5pAG?=
 =?windows-1254?Q?+bqbmRui51SP83MDlmYPEwPq2ulb6j/IuxSbcrhIRBP/Mk6VwFJPJt8n?=
 =?windows-1254?Q?R8AIvaqIlcHLq655Kxxeo7+LVz+KX+xuWOFgIw3rg5bfcA3GM9JXIkIY?=
 =?windows-1254?Q?9QQuhdMN6sA6WfEGqCpZVa7jdl0WohJUZDscF9YlsnuLllYSdPdTDps7?=
 =?windows-1254?Q?30sEPJZSIkY09OmXEJrhCyvyhyy9JJr2+DlQKzS3yEtzdE7+Gmw8A6Pl?=
 =?windows-1254?Q?GaRvflXxBvahwMgTLotCUczcV/+b1e1DFu8p5OblxoJuuIa6xFOc2JZk?=
 =?windows-1254?Q?pa4CHJHMZh1nbE9TS44Cw1KqzRHkrhdrRbLVXYO0D6Zm9isK1hMJ3dPG?=
 =?windows-1254?Q?1zlL7/QEf7kxGHv7DBz3hK2trdUiGzWLMnhV/dqX6l29VQOohiZHtl3M?=
 =?windows-1254?Q?kNnvyBsrmdwFWe9jgRYhQSmWMVdgRSqeRMnsnNdBH/4tuRXJUfZ2iQ6n?=
 =?windows-1254?Q?8LoJO7ktQmCTOLTvk2P7naKwTzOxiXZsjlb9t/bIJ32yi3+ypZDGHe/Y?=
 =?windows-1254?Q?J3yDmmnre1ZX4dI7lbBaqZlotA02PgKXMSJcSD75VIO3AOcLHrCTTO/R?=
 =?windows-1254?Q?/r8QoCQsTw6o+E1wRyngZ9c/be5NUuWCdLanGC1YXPKOmawczIYtD28i?=
 =?windows-1254?Q?ymWl5C28XWqHoBNs28yb4Gq/8SyXzy0S9BXQYMWLZp9/1UAp8fHQrBPZ?=
 =?windows-1254?Q?/Wm6LXd8wjSFOQqT+ZkRqPipAcPK9cOsgOL331b5O/HHwfpchCsvxGk/?=
 =?windows-1254?Q?VwzSl6qRSQUpnAdgf7QD5zh+eUH7CoRNbfEDFCaQ4pqYNBULRcI1KOiV?=
 =?windows-1254?Q?nOCu3Mkm+mQS9n9+AHES7gwydlTTYrN8hGbwpARSHIF+coLCISVWD6LL?=
 =?windows-1254?Q?gxiaQKn1dygqTnTWcgVjfvuKs/y0O6rgCPGlsQ60+w/cFzWhsswzBgJ9?=
 =?windows-1254?Q?NMrcEJXAvLBBxuXwoSGLso9/Jr51/nsK+E8XZK6idkFEsh+t9iHLyshV?=
 =?windows-1254?Q?TU0Bkn31ACqzQHbks4I5xMWejcRuXyij52aFMZH3mb4rqF/7hrN0AqCA?=
 =?windows-1254?Q?NSyaC4MzZPoul4yuSQnD/r1PDNt32jwx31QiO50I6OdYTJI9323aCviq?=
 =?windows-1254?Q?yD81ihhCb9+dB2XEf5Y6otN4Kx3+yeSN2DsLm+55vTWUMloSbokn7grd?=
 =?windows-1254?Q?XqtzkAtxY+hJ+T1THDoKcsdlqxbCYSdvQL2CkusUTtNckI5Q0TRbnuTh?=
 =?windows-1254?Q?DMyiFB2ERRJiNTaJuWaxde1PUbpeOEvuepToYaL1fdiM5k9woec5fm05?=
 =?windows-1254?Q?RDqm71YpOQIZR4a95R4=3D?=
Content-Type: text/plain; charset="windows-1254"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dda3533e-6b80-4ffc-2c09-08d9ecefe89f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 23:48:59.3095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0EUJZ/qbY52kDb9byrvJ5KswezysnFEqnXtbu0qRbfDnFNhn9dWAI/CdjM0n+pPejUkeGGiXiYy00yBQ1wMEzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2800
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Luiz Angelo Daros de Luca <luizluca@gmail.com> writes:

>> This assumes a 1:1 mapping between the port number and its PHY address
>> on the internal MDIO bus, is that always true?
>
> Thanks Florian,
>
> As far as I know, for supported models, yes. I'm not sure about models
> rtl8363nb and rtl8364nb because they have only 2 user ports at 1 and
> 3.
> Anyway, they are not supported yet.

I think the port number as defined in the device tree is always going to
be the same as its PHY address on the internal bus. I had a look at the
Realtek code and this seems to be the assumption there too.

>
>> It seems to me like we are resisting as much as possible the creating of
>> the MDIO bus using of_mdiobus_register() and that seems to be forcing
>> you to jump through hoops to get your per-port PHY interrupts mapped.
>>
>> Maybe this needs to be re-considered and you should just create that
>> internal MDIO bus without the help of the DSA framework and reap the
>> benefits? We could also change the DSA framework's way of creating the
>> MDIO bus so as to be OF-aware.
>
> That looks like a nice idea.
>
> I do not have any problem duplicating the mdio setup from realtek-smi
> into realtek-mdio.
> However, it is just 3 copies of the same code (and I believe there are
> a couple more of them):
>
> 1) dsa_switch_setup()+dsa_slave_mii_bus_init()
> 2) realtek_smi_setup_mdio()
> 3) realtek_mdio_setup_mdio() (NEW)
>
> And realtek_smi_setup_mdio only exists as a way to reference the
> OF-node. And OF-node is only needed because it needs to associate the
> interrupt-parent and interrupts with each phy.
> I think the best solution would be a way that the
> dsa_slave_mii_bus_init could look for a specific subnode. Something
> like:
>
> dsa_slave_mii_bus_init(struct dsa_switch *ds)
> {
>         struct device_node *dn;
> ...
>         dn =3D of_get_child_by_name(ds->dn, "slave_mii_bus");
>         if (dn) {
>                 ds->slave_mii_bus->dev.of_node =3D dn;
>         }
> ...
> }
>
> It would remove the realtek_smi_setup_mdio().

We are not the only ones doing this. mv88e6xxx is another example. So
Florian's suggestion seems like a good one, but we should be careful to
maintain compatibility with older device trees. In some cases it is
based on child node name (e.g. "mdio"), in others it is based on the
child node compatible string (e.g. "realtek,smi-mdio",
"marvell,mv88e6xxx-mdio-external").=20

>
> If possible, I would like to define safe default values (like assuming
> 1:1 mapping between the port number and its PHY address) for this
> driver when interrupt-controller is present but
> slave_mii_bus node is missing.

You could just require the phy nodes to be described in the device
tree. Then you don't need this extra port_setup code. Seems better IMO,
or am I missing something?

Kind regards,
Alvin

>
> Does it sound ok?
>
> --
> Luiz=
