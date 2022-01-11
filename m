Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70A1348B2B7
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:58:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242136AbiAKQ6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:58:00 -0500
Received: from mail-mw2nam10on2062.outbound.protection.outlook.com ([40.107.94.62]:32746
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242269AbiAKQ54 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 11:57:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDN172CUlL+cRiAzD45OXKfDO3D8bgCzTH51Jlo6XX9F+R57NvyQIfAWXYGbOVzZ5dtmi86KmOsJwTyEeJNdNGGlnlduAChahY0ZuA3xu9ZXJFBZlyn2coBLo1a1vsYtizJcKkCBsQw7NUOeHlyn/xhlZd6FxlDcJJS7h+DnAylrIYx6npn/tM/AsfsXGlntVnV7MJ17h2nxwBPA7gOijhnMw8Pvq4xqzfSQSLcTMIi2j2jlZKBccR7sv5VKgJ71s0UafoSc6IbHamWsGHuPn10LqngmhwJEdD0HP7e9dd4PHSjkAyTnL7tDmcB+7YBoy9qmEOe5joDvRrSZwY4eoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dygTfNPXU8tp/Ycp2tZRN+f9DUfqapuuI7hFgVYbnrw=;
 b=L0T0chO46ep2TLKS8PI649kqeF2KMBbjDKgyfHpkk0hxNgfdVrhwF8gMp0r9fFNsM5dIc0tbJLUQrDP/vAYm5nabBIwsKPE9d8ujPwQWcf9A+81NtIt3GW32NaTPUTwP91K6VH9sET4hO5VDP0fU4nJmA6+r/J4B17GOdtn7jLKh+PHFE80W/vrurH+WV8T53Jzx0R13kbztg2RGPOkwIdOnUyfXnfxQpPlf0MOau9kQ2WZps+mpHT+kzgj5t3amf+eMiAv4/K9xN46P0TsIpgigJWU764JwqY7PEgTk0FPrdTP7+FEoZ+xjpzZbY1OvtUUzIJmddqIB0LgaudbNLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dygTfNPXU8tp/Ycp2tZRN+f9DUfqapuuI7hFgVYbnrw=;
 b=QtrBxrV/XZIUSeRKabf2z5jBLvPiVYfqYR/Hyy1hudwPaK1OksMhdwKy8/22N+33Nu9/97cPbaV0TFUnHGCQy8LGuJICe7ve5qmD562DEtFfj7MTHIIGGL1YDBS1+xHwyTmfjt+HOLbSeUD1XST9JfQM4AOe31sa3SVfWD3/gKfJUl7ZKlkPJDG2YUzN0lQeXhpAke7AocHtxqohwO8VvV7QAnn8UFgJKwlSecfy3kZquixQSNqLGwusLtB9FihgDg5zWaDVmvh4dSdkeLo2+ctTMTT2rAmdDkvy+r4acTweX5p4XmEfmaMK/2dORaSss+DblKvp15yaRII4QG9HeA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5500.namprd12.prod.outlook.com (2603:10b6:510:ef::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 16:57:54 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5%3]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 16:57:54 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUA==
Date:   Tue, 11 Jan 2022 16:57:54 +0000
Message-ID: <PH0PR12MB54817CE7826A6E924AE50B9BDC519@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
        <20211122144307.218021-2-sunrani@nvidia.com>
        <20211122172257.1227ce08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB25744BA7C347FC4C6F371CE4D4679@SN1PR12MB2574.namprd12.prod.outlook.com>
        <20211130191235.0af15022@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <5c4b51aecd1c5100bffdfab03bc76ef380c9799d.camel@nvidia.com>
        <20211202093110.2a3e69e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d0df87e28497a697cae6cd6f03c00d42bc24d764.camel@nvidia.com>
        <20211215112204.4ec7cf1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <1da3385c7115c57fabd5c932033e893e5efc7e79.camel@nvidia.com>
        <20211215150430.2dd8cd15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SN1PR12MB2574E418C1C6E1A2C0096964D4779@SN1PR12MB2574.namprd12.prod.outlook.com>
 <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211216082818.1fb2dff4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d20b45c-f73f-49bb-f9a5-08d9d52382b2
x-ms-traffictypediagnostic: PH0PR12MB5500:EE_
x-microsoft-antispam-prvs: <PH0PR12MB550031FC82332D0CFFCF93FEDC519@PH0PR12MB5500.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Id9yzGcDd3N2x0RurR2sPtWVbHjt69YZD6LM37Eocr9K7uOlOGVeV6LqY/ZaN+t/UB4qOkPnugr8xOw8lRzGpOD25eHKOsDEtLDka11yoC2GlDHCoo8Ws85cjLAfOg5NnjKHVdI71ULeBsc9RqwvO4KZO8BV0CTypCOiprC2nVyJ9MTmpzttKfTYMS+qyqmFF+uZnyzLuteim6b2/K44Fw4iimy79b51BJxUMqnKTw8ws+SVj7cIXef+seBpRyctwxk9QI84/UafXakohltre3CdtvbYe/CAZl/hrxeqRIxm+u8M52LRVPjdtDAdkwFln9yJ2j7FEm+jAL6PxQGPDq23um0xQypABJ8ga96AgHMvN9iM4iAY2OsEsnYxx1Y7nIeD/RN8RxAfKj+TkA+JyGyoQ7YCXVvKpbQoFJ9t56+ce1p2gAiz/NwkfBzPIqJT7TVK84u7dpUwxy/dfBE/qzNi6NM2IehGRR518CDRJi+wXAGthVFfIJNyyn3GQ1B6tqtbA6l+gMKdiqNhDFLUpTFq7YAeJV+5ou1rV1Nur1uVro+7/34HinZ7ttHo/TKzC42iTlf886rVKxto3AQ4S532TFZ2sM94Z9ilVjqv1qUCSJkmF8lhtFn8Gt6lqnLz5qJiKTX6rVbWhEOh7zGgmi2ZAI0oUKHnMfe0UgG8vZTuRPvwy6mIG9Xg9jBpyM5YLfhecMPgFszXgVJpsRBxQw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(66946007)(110136005)(6636002)(2906002)(38100700002)(66556008)(52536014)(71200400001)(26005)(316002)(76116006)(122000001)(38070700005)(66476007)(7696005)(66446008)(4326008)(64756008)(186003)(54906003)(5660300002)(107886003)(86362001)(33656002)(55016003)(9686003)(8936002)(508600001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7GM05q1dil3+93G6iHNO/vloQgtsUpAlUlo+HOXrxFTIphC3wQmdh7Gkg0Mg?=
 =?us-ascii?Q?6Iessh/36LplH3WJtCatK9/furBOk3d3ygMJ4MIaFJqsiYfuw2fBAXnweEq4?=
 =?us-ascii?Q?xtRk3ys4EXMmf9hnLTZkaEYD29UzN9w89o9FvI+ZXupEcT01FrRgFx7HlVj9?=
 =?us-ascii?Q?TpwXsgGs3bi/GbI2GlVXxfF7am0p/05xHqecIgYV354oyceNqb23ZMmqDvhp?=
 =?us-ascii?Q?xDoRB/JYEP+GNSlrBlenTkMczYO4lgRDx8EvQuNGnfgogdmZjikalzQR6oJI?=
 =?us-ascii?Q?pJUyU3mJQXbn7C4x5lGDglPut7ihWQdFvJhKQ5q/Oh59RsNn+TQK3gRn9V1C?=
 =?us-ascii?Q?zzn3Rno3gVj9ItbDfZC7Ee5PwfXX/aU9N2zEbPEVQAfC0nwborN7oeC50zTu?=
 =?us-ascii?Q?HVeergr8eLFrCiVul9fwQI7UVlvV66oz0nqgbkDtHy+32TxkvabVmjpiMAYv?=
 =?us-ascii?Q?D2OZMWtxKRtXLwAWYFJOslH7Ub+PZmU3DAhNZ4Xbk2VadrzOU3YR9uAcwx4E?=
 =?us-ascii?Q?VHJ4S/NftVFbha+DK6siGxkhq8RmzO9GY2JWKHWlbZr/cO1xV6aR45b6KrpB?=
 =?us-ascii?Q?N0ILcBAZDiMtGxbmuKt5s7DZjQZ9t9aGEPwfx72JHbvrfB0E1K3ftD6c39B3?=
 =?us-ascii?Q?3DpCM3iL43G+2WA/TJLQJc2CPynHXjqQgG6sjj9UTo5P/eryaEZlSlQhmEtR?=
 =?us-ascii?Q?HMKFu2RYly7mdcOB4eFF3NyHYDHwrwYdeNghcTS4qBj3ZHTWAys2E28ObPBu?=
 =?us-ascii?Q?HQgfOTzu71FJGkfIuLDIyUr8d3oIhkqEbAcn7bNcf0ABCBs+0hmiH0gjWSxq?=
 =?us-ascii?Q?ZV/V659YkMt3vZPIRFpslWB0JR4lHIgJgdc5mG71HNgR1PO8wnmNc0XbR49N?=
 =?us-ascii?Q?L+vpavWLn+Otf6/ceKXv1hd2kIVP2Wr2HMbNXS6qZ3Lwx7USw1xVi9/Shsjw?=
 =?us-ascii?Q?HLDiyUF4Z7QQZmKBnauxR+pVmzMidWycy6EyPkOKL+raDWUyJMk5NxnhmlX6?=
 =?us-ascii?Q?EngksGwk1M0hXcKf1qbwSQw/BsH+Uklro+za8P9M4iVzdI1nvibsdDd8YN/X?=
 =?us-ascii?Q?9mfYOFRPS/sA8bKPaJeUECHE7S/aSHCDjRlRlzdU8MM9pNNYjVxV48r/dKz/?=
 =?us-ascii?Q?eXZbReyhwsPtVwGNMPzxxiSFPJcyCt45Cwwe6By33XqvN5qjKZiWtVERHixA?=
 =?us-ascii?Q?+a7eY2iWhdoDkkjyGJhnuI8o3oCwBUk/N4WZX2w2WOftsCTxAJBWMiX9/Ft0?=
 =?us-ascii?Q?Cbs5psYiV75chWe5Okas1GzJh8cIxCsTV67w5Y4lkjqFLBjUYX/zGkRgRanG?=
 =?us-ascii?Q?2oBsGjYKm5hRHWSXbuf3uWhKJJ0XPLvKR4R431eEE1c+PcCPPds6KcJWBJfb?=
 =?us-ascii?Q?w3xqOc5sQo/+GyL7w5lLblWgNeCM91+CPbWSdxTfgJbqC2cjqqnXLayzePJL?=
 =?us-ascii?Q?MHF63wjsdeqo8VNu92JB+xTcmms8wuz4T8Hi3plx8NpDn2ez49E2cz/kx3j8?=
 =?us-ascii?Q?Gk03/PjJDTqoLIo/Ia0Cos+uc5H2NvnfOtZmn07tzb3i5ldJJ4jWU/j3L4Ye?=
 =?us-ascii?Q?e1SvxdryM0kbrsSv7C1KsTMhCl/FXUPPqZvn14o0muKm7g0iTN/nGYkOEAQC?=
 =?us-ascii?Q?jDaOtqU+qO8m9qJK2deYLm0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d20b45c-f73f-49bb-f9a5-08d9d52382b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 16:57:54.2017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SZRsad6Vs07UVcG7tFTJcaMxSc6JTu5xNFhDd24iNML4h1ewGNj0RSiHpR7MoyzZLOgXDoKODdN3lqG3ljPLgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5500
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, December 16, 2021 9:58 PM
>=20
> On Thu, 16 Dec 2021 16:17:29 +0000 Sunil Sudhakar Rani wrote:
> > > On Wed, 15 Dec 2021 22:15:10 +0000 Saeed Mahameed wrote:
> > > > We will have a parameter per feature we want to enable/disable
> > > > instead of a global "trust" knob.
> > >
> > > So you're just asking me if I'm okay with devlink params regardless
> > > if I'm okay with what they control? Not really, I prefer an API as cr=
eated by
> this patches.
> >
> > What shortcomings do you see in the finer granular approach we want to
> > go to enable/disable On a per feature basis instead of global knob?
>=20
> I was replying to Saeed so I assumed some context which you probably lack=
.
> Granular approach is indeed better, what I was referring to when I said "=
prefer
> an API as created by this patch" was having an dedicated devlink op, inst=
ead of
> the use of devlink params.
This discussed got paused in yet another year-end holidays. :)
Resuming now and refreshing everyone's cache.

We need to set/clear the capabilities of the function before deploying such=
 function.
As you suggested we discussed the granular approach and at present we have =
following features to on/off.

Generic features:
1. ipsec offload
2. ptp device

Device specific:
1. sw steering
2. physical port counters query

It was implicit that a driver API callback addition for both types of featu=
res is not good.
Devlink port function params enables to achieve both generic and device spe=
cific features.
Shall we proceed with port function params? What do you think?
