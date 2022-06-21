Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5F12553240
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 14:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349319AbiFUMja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 08:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350475AbiFUMj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 08:39:27 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC2B24F17
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 05:39:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koux2p9Yd228k3WXXXt2Twxqi8g3uO7JEPzhF0cnoHgtpa3aQZhp/zX2R4mpcn9p6vwVMHjlNvaPEVuISI5gbnxnUr+0iXrUtSZlrtXtOgAcXC7hxlcghhl/fdg2WfsktdEbLHgiHMZOXMoy7pN8h5SZkdtYvWrZ1/i3rmgCzOp+NpdmtLiRp26DfoxnP5DlV3LNFX+dBo5HzRD8QQcRmqRk4FWeQs285M86YGXq7IeEdyDzKNnleB5MH6fX3ZfKdWovD6/JOlxrH9foWL2lqHbu+5e76/sNrcLTr0ubNAKQ5EJ5BzfIK3Oa1yOpbXFJTaHW7AIED8ro/Vsk6hOXXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o5r5P5K4e5CK+2KfFqqtLi35y2xGNiuXlAbAxgzX4y8=;
 b=XrZynKn2kfaonOlOppuDfJgNl/RNzDrOsJSfZsEjW9E4/Ysq0A0dFvOL/LM91PljvZhJPJktqU0CLbWULNgqRG0CillHcNNANmB0JM8HmJ6VvTyZqbnIWNkxATGi/UVDWRHQMJ5xKn91heOrqRg6OUPQroDheKroEDQL2jwH38iGIbtVqgJtAl9SgGZedWnExPhnjx47NMfKZ9Yu0dW5wN//CSHPcGrlNoAVhHxkjX/gjOYsodJTIIwkCEXeUmi6AL3aKx63GyE65mTF+uCxXoWCdtWJij38vz6f/Iccq7HFcJQlxlDfxTuCugXa0s3BUNt+b+wa+MJfxG7aAgv8zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5r5P5K4e5CK+2KfFqqtLi35y2xGNiuXlAbAxgzX4y8=;
 b=de6ps9rdsA+08h0KPcIunQMtA4PHHzYk+9d9WlSsrAU2XrkNDZgN7Z0F6GqEwGC3G6apQ78G1OHy9uT3QExYzfmPl78so874DOUm/CgaX8NpcGZTDBpUWZsmakMp2/wYfBSGguVeh0EOAwsMUcakAbWyAeWw4+hT+NEyxgxanKFSEdRTCi9oH6oXeqeIust2nfcRX7LbJjyApTALBjS+q4mEFQ576TKxeOdlaRsdboftQj9123qRPLFSWB8WgT6oHJsMcWcU0LbBjaAXx4Ak/euwp/KabLLIFLT1GxBbzPaAR96Ag41CVDPF1wzaDy1RUtmal2oi6IlmPa3vTKfuyQ==
Received: from PH0PR12MB5449.namprd12.prod.outlook.com (2603:10b6:510:e7::24)
 by MW3PR12MB4475.namprd12.prod.outlook.com (2603:10b6:303:55::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Tue, 21 Jun
 2022 12:39:23 +0000
Received: from PH0PR12MB5449.namprd12.prod.outlook.com
 ([fe80::f15d:45d1:4f02:5b52]) by PH0PR12MB5449.namprd12.prod.outlook.com
 ([fe80::f15d:45d1:4f02:5b52%8]) with mapi id 15.20.5353.022; Tue, 21 Jun 2022
 12:39:23 +0000
From:   Lior Nahmanson <liorna@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben Ishay <benishay@nvidia.com>
Subject: RE: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Thread-Topic: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
Thread-Index: AQHYfxeLrA1D4yQ9x0eLs4ha9L+iN61O7o2AgAAm9ACACrctoA==
Date:   Tue, 21 Jun 2022 12:39:23 +0000
Message-ID: <PH0PR12MB5449F670E890436B0C454D2ABFB39@PH0PR12MB5449.namprd12.prod.outlook.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
        <20220613111942.12726-3-liorna@nvidia.com>
        <e95ebed542745609619701b21220647668c89081.camel@redhat.com>
 <20220614091438.3d0665d9@kernel.org>
In-Reply-To: <20220614091438.3d0665d9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f02ede68-db79-490e-3a74-08da5383121c
x-ms-traffictypediagnostic: MW3PR12MB4475:EE_
x-microsoft-antispam-prvs: <MW3PR12MB44750EFF8B20F48374AF354BBFB39@MW3PR12MB4475.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rEWSLUIVOQVTrhvNm0GhZrnwkRX/Y+7EBgmwPZwGfpyFIhwD8C5bQWi2xkilI56KCPLlCnWT4Eoju21JRKVdwR2Oeq7x1NtdkTkhayNcoUHhk1po+i0KpqzKfwiIfBGCOu/xdCWiunZDpPO8iJ5Wn8Ow52O9ShGL7glLQ6bjOQ4oYV1zgkvyT1454iF6XQ9Vhk5tC6DIraqqvydhv/9T2AREvWEtsbvz3TGj1NGiVepOnAxhIERH1KGvhbQG2U0WEhfDXxEyacSejnHSH089u5pU8405Ar7NmX47a0vgJKiblltexU08VzaKGiPUQlHmMO4NuPzg9EoFtJ9g2qd+NopKDf9bhuM2sXxFoR/Nw4V0E+0QepEl3Slkw0JJGp+ih3xUXdHAS/oP7z7HPBU5EbH0nEAn1SwNRFQ0/9L7EQXg88t7RhJKtEuUEZyTeJ8/artnEQNmgUysfFcoAv2eS0Tq4TuitCkQZp47lCNgegMXJjkx5smhDWg9nDIbDFh9wGgJMqUkXB4FOt361SxPWdQmzoUdI5f63pi6uH9N3HTiZOflj7KaCWyWL+/OB7y7JQIqXqkCoLg5imwNgc7DpIMqLVuxGTdMdAkTOZD4TWDc2Ur7ZQ1H+T8GRzmVAA8NOqfnzpaA04GtCMR8uxmeNxhPXVpkxc3QAWP39ddWuG1DXwnjuZxy3ai+9gb7aQIKabWlrnwrez6iTAfcEXBFQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5449.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(4326008)(66556008)(66476007)(66446008)(64756008)(66946007)(41300700001)(107886003)(8936002)(8676002)(76116006)(52536014)(2906002)(478600001)(186003)(33656002)(9686003)(5660300002)(6506007)(26005)(7696005)(86362001)(53546011)(71200400001)(122000001)(110136005)(54906003)(55016003)(316002)(83380400001)(38070700005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ILTj1SVZc7SoS9hqTF1JDYlrZ+Fmp23+UF5571HH0g9Dn2h2KvcTCltVoBq7?=
 =?us-ascii?Q?AI253kv7J+F/mcIc7Sf7ltdrnB0LHMdhBxgZBXR+VdM7D2cs+9RzWPSuqOoI?=
 =?us-ascii?Q?1Fqu4KXsemCFy5UuFLXcjkogYeRNx+Tg2JGa6DMULPKdNqUEwXF9enhOJInJ?=
 =?us-ascii?Q?6CwzaJhtUwW7pPgehfptzuRuhbKou8aYO7FjAW5++JE8V4LeTGHzhNwTKdnq?=
 =?us-ascii?Q?lVP9oeOn5zMuaFbsvCxDb6DczZDoFdJrECfrQsTevcNYsPW6cBSwrpjiSiw+?=
 =?us-ascii?Q?TWNo049oXmzk20vRbe4QNV/kpuFrARA0kVj2dBatfgcYUg1KgyA/rGdRZxU7?=
 =?us-ascii?Q?Nus4HZngoa3b1+kN0xLXIHtl8o+cWXoa+YUXKTGR1PIg3qQVgcWpAJpjoyKU?=
 =?us-ascii?Q?TdZFCDjW5dVl9RGYbPR8V7HGhPrEtj76VNv6ltoJ8wmw8MrJFMeLT2CODIFw?=
 =?us-ascii?Q?Yqyb8koBk9j2bHyadRJ76fSb2V+JNu5xiF+rooUacnSg4ZSh64lUWPQxtyx/?=
 =?us-ascii?Q?M0lZgYugDzXBgKla6BA0IcsXludU7vr8Y0ETUjKTNyheiAUPyo9MR2G74VDw?=
 =?us-ascii?Q?rnOuKu2q65k8hJe5pbspXiLBO/e2g7V+FloYG5m5Ux5etzxNZIxHj+9QAOvs?=
 =?us-ascii?Q?g2CKHIf+015TCd0D4PH5r4812rKQRD+sHF4R+oqAdkRrOMY6Of+wGdBPXyL9?=
 =?us-ascii?Q?tYfOdpHzFzafoOFIGy1VG1OP253nADbbsoG1947GEj52hXOHwdtNiTwUaSDb?=
 =?us-ascii?Q?E9+x6T05mo/UF6CKQrN50j0q2hUPORu577it0Wuu1EU/Wwi/sVPK/SDpPnvH?=
 =?us-ascii?Q?Aadf2yO8HzH+8VFadVeOc92FPN6o+uh1E5rfNtipYU2NMU9gcVaOdxq3n+xM?=
 =?us-ascii?Q?SfSPHFAWd+q5kCzYi0O4aI+0uB1evfrmcHqh6XK2UlTfj1uvGDpq0PmrUgQ4?=
 =?us-ascii?Q?JgkX9gyq/2JexowIpLionmS5ravAEvHKTm5V96LFjjtLzl9KsUR9inKLZ5Xs?=
 =?us-ascii?Q?5nhMBXO2V3LdkVXWT9Uytq+kJO6A2LM9dSqKKTGFkKYGdHEsqnnKNnfI8uW9?=
 =?us-ascii?Q?MiZCxjpmGxfoooCtY5sVsGs0pHyinOg6DsBvrxarvAowsfc9BQemracW43o3?=
 =?us-ascii?Q?csTeyLILQCzTe24ilH9vP7y2uUTAXVthZHrBPNz3dohauYQ+Sz2R1EsoaayD?=
 =?us-ascii?Q?NOhc/DLhzB5yTRHwaGpTamWsw6lNayRdgvLxESFHwaHpIcS81PVPlUKUjzth?=
 =?us-ascii?Q?ZFQYOgYc3kYChDle+lIYkmA3FqEpxKRZW5+ejKnypT1yOKsx3E5LThua3n53?=
 =?us-ascii?Q?5Csx7tm/vNqabXRKQ2jWW73q9nL8WlPwHbe8G811UaQMRS+1OaTHbzEFunpE?=
 =?us-ascii?Q?qN+OIV+B1TxuYUsR6cgVUzoInmDnTmJ2JvJ9FGYxHd8+4xtkn5CmuB2GBDqj?=
 =?us-ascii?Q?mbxHSTZSVUIenyzpDMJtIIUg4LcrSB6HFTeUqZK4M6fUostC476J1j7uYLBD?=
 =?us-ascii?Q?HhZ5+9jiocQbS/aq/DmK4ojrjSD/MIRcZuEe/C0gDMsPPGA1StG98hriNpUW?=
 =?us-ascii?Q?3wDrJ223r9STyIY0XweWmVsP3VY8+wW2vhaGmE1DW5KG+g4GoBJM8Sybn2xi?=
 =?us-ascii?Q?Ls0/2gKHWIOOtjhcUX+bFOZVu+RkcDgrWbxFnpcU1WshL4AYS6+qSndbvf2B?=
 =?us-ascii?Q?18yVL13du0W+m02ZYL/Di0VEd3No8J6L7+BDo4gEVGPAzlsf?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5449.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f02ede68-db79-490e-3a74-08da5383121c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2022 12:39:23.5851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Agsft34llzKlDKWsQs50FvBJF+A+AyCyTU4dYaZTnLnhPnt2hpvgOMm5LbSCywHtUIO0TVioxk8n0qngx9Dz1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4475
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, June 14, 2022 7:15 PM
> To: Paolo Abeni <pabeni@redhat.com>
> Cc: Lior Nahmanson <liorna@nvidia.com>; edumazet@google.com;
> davem@davemloft.net; netdev@vger.kernel.org; Raed Salem
> <raeds@nvidia.com>; Jiri Pirko <jiri@nvidia.com>; Ben Ben Ishay
> <benishay@nvidia.com>
> Subject: Re: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb
> extension Rx Data path support
>=20
> External email: Use caution opening links or attachments
>=20
>=20
> On Tue, 14 Jun 2022 15:55:13 +0200 Paolo Abeni wrote:
> > The main reason I suggested to look for the a possible alternative to
> > the skb extension is that the GRO stage is becoming bigger (and
> > slower) with any of such addition.
> >
> > The 'slow_gro' protects the common use-case from any additional
> > conditionals and intructions, I still have some concerns due to the
> > increased code size.
> >
> > This is not a reject, I'm mostly looking for a 2nd opinion.
>=20
> Shooting from the hip a little bit, but macsec being a tightly bound L2 u=
pper
> maybe metadata dst is a workable solution for carrying the sci and offloa=
d
> status between upper and lower? The range of values should be well known
> and limited.

Under the assumption that by skb_metadata you meant metadata_dst,
I think there are few reasons why i think is better to use skb extensions:

1. Unlike skb extension, the metadata_dst deallaction is handled directly b=
y the allocator.
Since the sci and offloaded fields are shared between the MACsec driver and=
 the offload driver
(in our case mlx5 driver), for Rx, the metadata_dst allocation is done in t=
he mlx5 driver,
while the dealloction should be done in the MACsec driver.
This is undesired behavior.

2. medadata_dst is attached to the skb using skb_dst_set(), which set the s=
low_gro bit.
So there is no gain regarding slow_gro flow.

3. metadata_dst allocation require much more memory than needed for MACsec =
use case
(mainly because struct dst_entry which seems redundant for this case).

