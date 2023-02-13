Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9FB694DE2
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjBMRZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBMRZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:25:28 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2074.outbound.protection.outlook.com [40.107.104.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E4618B27;
        Mon, 13 Feb 2023 09:25:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvIq7HHQ0lK4JXY3SlxI9107uXllZPlltpfHk54+vwUEaxPHFm/9RQb1mJGit+qeAuItpi2OGiwjTfSLc69/NTp3fY9R69YWxyB7jHPGHWJpq2QhB/RrMnhZgNj5yHjCHjuLFPBPU6zCU66zO8LdUcv1mXr5hbHPPlOEC7UH9Jdyl0fHdr5LmaUT+83ZXxfgPEe37zHJiqIvDxRwipdeL9e3mDBKlOW9lYWsMvshxB0eP8+j8ztLtzGGI8MsfxbkkKsnWFTyj06d5sPvFe6bIxPnMS4zGX+co8o5eyKx4+V0LWkF/E05l7s9jOWbJyL7msevdgBPYNRXv+lrrV2osA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBiijs7yijnleThJd8ciENc03ftD3axm6U31W0ZyrvE=;
 b=hTtL985I3M91GnJrcRnN9DohPf56X1rbqe7tuDfl5auvwB52ahQL2d8Wi499Jm9WfTUu6CftVwv5o4KEw/wfQVrhpCzKwXprNUf51t/mdN5lN2+3gq2MsdAQD9t+3UgL905I1vadgH107Mm1ZIvOWXe3cu4rOr//4IyNkYeQkElzstEunRF176/R/j3QIvOwG7zlIxL7iXzxRIXGL7wt+jqNB/hXqlBLSYHoOibIR4QyG0z9BXcS0yWPHLnEAAUwtMaogvTMDRBPCLtU+BPiQnq/cbcewjiIwawn+l/fmAmAWZAqIS0uUjJcS54chgr2PsagC2XPQ3Sr+SpDbCo4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBiijs7yijnleThJd8ciENc03ftD3axm6U31W0ZyrvE=;
 b=SciX99dMpfmCcJSD3tds1clKNWnqx2ghmRxlMBg6XdGwgS/zS8nHOot2Q76nKv+DOiTuaCRzPL6+c16W46UKxMwfKvWZWKRzAmmmHAwWyp2fLYlHjQlq5AlDxlV50Eg/kutGh5fYgQ9u6MxvGreBXmLLW7NXp4PGtl+jChEdtNs=
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by AS8PR04MB8979.eurprd04.prod.outlook.com (2603:10a6:20b:42e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 17:25:25 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 17:25:25 +0000
From:   Neeraj sanjay kale <neeraj.sanjaykale@nxp.com>
To:     =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "marcel@holtmann.org" <marcel@holtmann.org>,
        "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>,
        "luiz.dentz@gmail.com" <luiz.dentz@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        Amitkumar Karwar <amitkumar.karwar@nxp.com>,
        Rohit Fule <rohit.fule@nxp.com>,
        Sherry Sun <sherry.sun@nxp.com>
Subject: Re: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Topic: [PATCH v1 3/3] Bluetooth: NXP: Add protocol support for NXP
 Bluetooth chipsets
Thread-Index: AQHZP9Ao+9vvplHGd0y6tYpARA8Wnw==
Date:   Mon, 13 Feb 2023 17:25:24 +0000
Message-ID: <AM9PR04MB8603C653BE4266E3343B1F12E7DD9@AM9PR04MB8603.eurprd04.prod.outlook.com>
References: <20230124174714.2775680-1-neeraj.sanjaykale@nxp.com>
 <20230124174714.2775680-4-neeraj.sanjaykale@nxp.com>
 <bd10dd58-35ff-e0e2-5ac4-97df1f6a30a8@linux.intel.com>
 <AM9PR04MB8603E350AC2E06CB788909C0E7DD9@AM9PR04MB8603.eurprd04.prod.outlook.com>
 <ad1fc5d4-6d44-4982-71f9-6721aa8914d2@linux.intel.com>
In-Reply-To: <ad1fc5d4-6d44-4982-71f9-6721aa8914d2@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8603:EE_|AS8PR04MB8979:EE_
x-ms-office365-filtering-correlation-id: d777a111-dd8b-4ea0-14f1-08db0de74b00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1Bu8roYT1iYSjFATlP/YyJsV5cP5ugOZexpsV0EwVtnc3lQNl+A8iQd/KWakkJMzRBk7NmhIAq71Z4R+Qr9xdnoturQTcz9sIurkVM1a1iyrowv4aFmIamTrnhfwaQVYZEsvZSluPKDjrmmRPl7M6gPhPZSXcRMUgrXKH8Wz3a5E57U+4qL5j+jZWPe7iYvzFJYrpZV9SCIdcV75K1C1JCtZMZeup7yxrBzXSZaMlcn8JymyGMgrbQVm6yNxz1XTNbytzNhJ4Q7tLU/VNySNI2kHFTnPFcaQ0MHtXXtXFvg/sNMd0D3ebG2pWWve55oxjU4L+J6SAuTN2zpHYlsuIEFnzNzQ/5VHCuNLsjDKpidm5h/G0KL2079Hhi0PUBbzHG1kwtg0S2NRJrG2wtcvMgUEsI1+sHUtnxO4b+VCe6UDbjNt65ZtVOfoK5a1CbHR7OojujRgJoduY9TEG+YIqGAwV9JrnnO874xzCeijktOpxklgQ8MX7kOO66Ydz9Kljroxq2yIBAADhj1f4P56p4zobTw9vs/+jXYHeMCxHK3Z7qa/WJ2G8A6hjjiCJIJPPx28Emiok780WZqdpBQ5kHZtdfCsYzfcmw95jh/2XMrQ6SHOk2GhQzqSlPgpfvgirJ7Ej9zMDWneugZIP0nsAH1dQlRf13k7uaa2F7eOSWxVEWD6BC1r++Q8UFqBmUkOeYn5cPMPt3YZ0V4R9tzCOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(451199018)(4326008)(41300700001)(6916009)(33656002)(83380400001)(122000001)(86362001)(38070700005)(55016003)(38100700002)(54906003)(316002)(8676002)(66446008)(71200400001)(7696005)(66556008)(66476007)(64756008)(186003)(76116006)(55236004)(66946007)(6506007)(478600001)(26005)(9686003)(2906002)(52536014)(7416002)(4744005)(5660300002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?rtZYQy/p/GYIbH9vpPqHYh9av63qKIWX6Iq4UnxndaHBpM1d9Nw7CapvLt?=
 =?iso-8859-1?Q?bK9dVQOzvs0FxzwXj1gd3kkxzlhtaMwlcvN2CbgiOrVX1Ske5Pw/sJab1h?=
 =?iso-8859-1?Q?Eme9KS+yBPGm+588e5Fc4jMXI1218gengVNeFnSrw090uRRW0rHolrMBiw?=
 =?iso-8859-1?Q?g39/Ulranpuq32X/0GYQTkrng13RB0VpEnCF/0fd4V34jetLwYpm+Kzr8i?=
 =?iso-8859-1?Q?UUkbBR8otG6mgfOXFBFS3kXcgE5PobiLdyR0nAWSQQt0QHmeRj5RFdrmwN?=
 =?iso-8859-1?Q?GYcnn84/JVAP8JGSXYBYH8StfnuvvelbpuBQtrnygcnToGP8/RGaFih9i1?=
 =?iso-8859-1?Q?cDa0wISFho9aZx04AhLTZ3j2c92bndvlZ0IcAQwQqrqPNuUBb7DCMQqfHg?=
 =?iso-8859-1?Q?zhEvv2gql3LYEeneA+rDu4JnZUNERs3qOeb0dXXkC0fpV7SK8DM4+50w/2?=
 =?iso-8859-1?Q?QkwI7FwO9PpTmju/1aDrzTGBb4Yo8pEivKEH2uoSMsRlgNVD4fWWk7R7t4?=
 =?iso-8859-1?Q?Lwen/WQ1u7h3/eoK4aLHCpxyNAnyjk7stHg5wVzgyVWZ2sc2sWa8/xXMHg?=
 =?iso-8859-1?Q?pyfZGArfueSu6uamS516MnrYT22ut3TY4jP1sAgPSPovzSfbUIImGYQGY6?=
 =?iso-8859-1?Q?yPWRxX6bUWcwW8AdhrG7RV547GMbRdt7aOGJ+7dO8Ox184MA2eIVEMUJUs?=
 =?iso-8859-1?Q?2y3rrz4kXHoFSTmU5iJWV0X772UXIio8uL35REaKSzrIfBP8gcWno/h5So?=
 =?iso-8859-1?Q?JvodWt9lql3BXWvj49s++NupbqpiGi/6lcz1EfBHUDaCC+ke81WgfDvfNO?=
 =?iso-8859-1?Q?VddXLYwucOdyhfNLIDMBx5Mj3Xl/G0BiUL5FEPT74Iht8eqnyk9ao2Kknt?=
 =?iso-8859-1?Q?ZuBYyPD6a5v9+O+ZUncX2Yk/RYak1E8NINT/3SKjHFax8TwEZGOGcRBqJY?=
 =?iso-8859-1?Q?Wc8KOHyqQL5eCuvz5eI2yWSttOHapE/A+NpsFLtmnMUYdUmLgVm1dkxKT+?=
 =?iso-8859-1?Q?4zsF6V9GwMlAvR1RWCO3Jjcpbt1nMVAI8j7h75wDze9slfPiVcAtSZQ5Ab?=
 =?iso-8859-1?Q?RwwCen56XX7vVsWx/CJneX7zQlGElmSWZpFYaG2Q6TLEfbc5zHLTgrlRLu?=
 =?iso-8859-1?Q?oA60JJ7TzUKFmlFpC+QMI3XEf+5zijgCW0tZqUo2OuIJIBGo1TOigNnWKR?=
 =?iso-8859-1?Q?+s4986gzK0bePgm5D39/C5ymfuYConuAmluzjJQKp1JzVTbp8aOrDUrcGu?=
 =?iso-8859-1?Q?NXcKPrrRknwxtt/wb4EOliFH2eq0VNStP61GIbh8JMlFPmb+6x5SYleGH/?=
 =?iso-8859-1?Q?jzOT03kTMR01SG3A8AiQ76JjEGxUF8X4Fl4VB2Le7bMJABq6co+NjW4Ii7?=
 =?iso-8859-1?Q?6t1I8bB8PCG5Bk4dGrxEEHSt1p4oxPyFReEaYlg9D5UcsLrlpAAqNlEQtD?=
 =?iso-8859-1?Q?WEwZgpPFNCDEQ1asaAjodHfd+WpLuXfrlKtHgOCLmOoqSEhxV9hucuPVu5?=
 =?iso-8859-1?Q?j1WOiUoAsn5S+NwQibqD5QmjyHzZ8og125Bcf0DGOe6YJIh5xQiSt/DBPC?=
 =?iso-8859-1?Q?ouqjTEGKLARjWOEYJSzYHJwttpBL6LOkkWoBrw8jOxqnv3cfAFc/Ik7FR2?=
 =?iso-8859-1?Q?0qtqzcRgBkxgcutXdLhDbc7JwpvvhrxCovgsHbtUw2KWHReQarsNq+IQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d777a111-dd8b-4ea0-14f1-08db0de74b00
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 17:25:24.9647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aFpag/kcSjtdAPBE9kcxB/8X3IWnNxidgqyAKJvt6m8gkO032x5MfIYX5epW1AH3sIg3Em5L4I/j7iwrLaOYg+YvQhTPd+4cVm+Jb4t6cSo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8979
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Hi Ilpo,
> >
> > Thank you for your review comments and sorry for the delay in replying =
to
> some of your queries.
>=20
> I made some additional comments against v2 and I meant those ones were
> not addressed, the ones I made for v1 you've addressed I think.
>=20
> --
>  i.
>=20
Hi Ilpo,

I checked with my colleagues Amitkumar and Rohit (in CC) and we can't seem =
to find your comments on V2 patch in our inbox.
It might have probably been blocked by firewall or due to some other issue =
we have not received it.

Maybe you could please re-send that email and I can quickly take a look at =
it and resolve them.

Thanks,
Neeraj
