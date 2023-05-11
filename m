Return-Path: <netdev+bounces-1832-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D7D6FF3EE
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B4901C20F52
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:22:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C67111B909;
	Thu, 11 May 2023 14:22:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C2B1B8FA
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:22:08 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70652106C5
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:21:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcP6jEBye3yLomO1Wo3O6nlRUrfMstZ3SPiKYOIzL3xdwY2bXokGJ40+fI1yO5LtJzHekjqt826676qZWN3RIKna1PPQzPfE/Szxn+gvu8zUKtAIRsL9q4gbs44tVyramVnYdAii2xa4UTXiQU0MC4j5o0piE7JtrFnBBb2I3kTwm3B6vzPWHxB0jFLmFV6XXRLJ90C4x9XeS5CQaLsH4iWYYPV0AMCkNfMP2DS/NDubBytlQp1j7WW7bVI7eTWt351IAweE8HtubjXY8DKkyj6sdYDiC/E4jojVDq1I5HXI/x4KF2v2z0+v9mozCMLBUhY+S95p2IrRLRy6mey2Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AacgAD3cnC9n3YCM8Zc/KRlb96BSiSC4fLuWgE+WQ1U=;
 b=e/fbHbtHdoJEvPe/qKgPIeQamHcyd7MaPnhvVL8RASDJBqqi2/qoO4EQl/EeKDxrtvEDBpwpkD6Y3c214xgOfguijaJyBGskIOMlEnup3CJrRzhqPIv0VM9Tx4AIw5TUFEdjw7/EIbbGeYe2u2ijK3djY7KsV/XgfbuUxQwZE1u/kj4l40wZUEB8J9Je9XPKvTDJsIaoxDcsI6Ieg/U5ilH/Rxb+dulCJjwYwiOqq/OZj2dFvp2lTXVMBScdwZuOxQgYb3hiKB4jTwoZwr4V3DG2YxTLoqPcp7vcNdKnFuEUmoBdbyD7HUOBGnxLbWHnJzosQc8YV/dCXz5xvV4emA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AacgAD3cnC9n3YCM8Zc/KRlb96BSiSC4fLuWgE+WQ1U=;
 b=bH8tO3YgbDzTNQ2XhJYxl1sZrHsD+YAeop7YtTLQzhQz88BuQ4ifNlfdcM9WXwTQlWDeUZu8RAGZGLELe/umTdvtO3nvC3jX8xna+bJ18IauakpIpOUQ920XOSh/LANMrQQsfIT8xoKYEJ6Ih/7+xtYIL/o7NRuZaDTzt17uDvAyyGStNjt1/bNcTpb70Tt5ZJhEedcUPcyMxOuaXjxTuHvHyzDrf5STR16X7BdHYhxsKHDVUg/qf1Q6EVJzO0CjxPfPIst7QuJPHdRLH6FJzzeV83jzFSI+vuhGrMisNcv6D0TIgYcXON1htIbg3B/4NNvMpl6smEYLO/4XLHCzDQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM4PR12MB5165.namprd12.prod.outlook.com (2603:10b6:5:394::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.20; Thu, 11 May
 2023 14:21:51 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1c51:21c0:c13c:3ed3]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1c51:21c0:c13c:3ed3%2]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 14:21:51 +0000
From: Parav Pandit <parav@nvidia.com>
To: Stephen Hemminger <stephen@networkplumber.org>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
CC: "me@pmachata.org" <me@pmachata.org>, "jiri@resnulli.us"
	<jiri@resnulli.us>, "jmaloy@redhat.com" <jmaloy@redhat.com>, Eli Cohen
	<elic@nvidia.com>, Nikolay Aleksandrov <razor@blackwall.org>
Subject: RE: [PATCH iproute2] Add MAINTAINERS file
Thread-Topic: [PATCH iproute2] Add MAINTAINERS file
Thread-Index: AQHZg4J/tQjz3BTMaE6DQxV9LG8vH69VID6g
Date: Thu, 11 May 2023 14:21:51 +0000
Message-ID:
 <PH0PR12MB5481305018624969AFC554D2DC749@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230510210040.42325-1-stephen@networkplumber.org>
In-Reply-To: <20230510210040.42325-1-stephen@networkplumber.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|DM4PR12MB5165:EE_
x-ms-office365-filtering-correlation-id: 2ba836bc-e5e3-46bf-fbe6-08db522b102e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 11IOby4z/KQL5YiUPuVzjTx9CDXC+pe7WdQmYcn9NV4/oqLRQYu9XcNSk+96m8puA8Llu4XOszOTkHL6/hdr/K7ZLZjWostYIDoxLAGlkIbop9BbtWkbolQ+L4u8lZmNeqTmCEGaClhd7YmlSwtFIaUDuVuPUEVVIUWp9A6L/9O5PE99i1s1NbidrC9OGTW6b/XeIdDY93UJZWyWt9Fcn1X86eN4BfXK2nt0E+9G+BaJDH+e2D2n35HLGxH2odLVQ4qwdxzjM2jPaVQp+Pp47a6sUwaFUxLdCVVpku+RcB2kZeFL4FHo8eSujkEA62g0ikVbSbrlx2t5G6Ep0edQzvLA1iWhftWBt8yrg/D5hDWCNM+YYcCNdndcZ1FeHv3boJ7aLIaqR9KhcIpYSdAPgU/di72lNITt+cjD/8gJWGCfAbqbYpoydBgNXj7ldt2+bVU7554ZjiWGh29+2/n5Y2VdCcIyZSmd++tFL61Tt7fGEI1PLG3jzm6GrDncAA5zNqIPXuiXWNroASXV7exLPY5kfKliTAv+5s63EsRTpUraznnxUluKVoTo7GZFWk863IqP5YLqUJ1BDouf3Bphm67eHsJcujrjP4AlETT6DOGMVM3ma3TukR5ooy3EXmBF
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199021)(122000001)(41300700001)(316002)(38070700005)(38100700002)(33656002)(8936002)(8676002)(478600001)(52536014)(66946007)(7696005)(66446008)(26005)(66476007)(76116006)(64756008)(9686003)(66556008)(2906002)(86362001)(5660300002)(6506007)(54906003)(71200400001)(110136005)(186003)(55016003)(4326008)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?xvywlPQBfgM56PdGjh7HRbEMSlXg2jqxXlxzTWTQAmHaqZLiRaQWEFLd0g+v?=
 =?us-ascii?Q?XaqHHPJQwmN3h/gEX8Z0Qf11I0pCPTEml268xrD9XiOVkbF92dhOHoEdeVpS?=
 =?us-ascii?Q?mJ0Kcsey6hbeYo2jzsnLKDWYyCFj3Xt9V4f0omC7MKi0vjqaxDhq+P+/5g4I?=
 =?us-ascii?Q?3ft8pO8c3Rum5HQqOSJS7auFBO8EWIElkPJrY1q18xryznSX7D00RIYghSgq?=
 =?us-ascii?Q?ki4kBLm7fQkA2b7CxsFoDv0sMdc/9UDy3v3bFlpLjI0qR20Je48MGarN9RUW?=
 =?us-ascii?Q?FCfFB7ShA9un1pjKRU9H0yDrxCHPOeOWE3ygMTg1IRUFQ0+0/7K20rltx+53?=
 =?us-ascii?Q?IzBLEW5vPgHq6EMdKMcDH7yWYnwtElWVBLuPcJnDie78bCS8USWyFyhJrCPY?=
 =?us-ascii?Q?7NWlfOMPdo6TwJ9061tyZTTOHN5eQE/jxb7IGFln29hNWCmjas3ETY8hH75B?=
 =?us-ascii?Q?/yE/X2TXKbXPakyYu3SUYquwI+FtAyzI+EguDAnbgBxDjry9U4iLsNB5eaJi?=
 =?us-ascii?Q?6GundljElKzWD5Ac23QbXZ+iTmUeDjqtqTGHJe8YWMF6srk+lClmdSM433bx?=
 =?us-ascii?Q?pDysoLpgq7wPeBWKzwwKVf+4+YzYJWutTTIjm9g6SErSITY4Tc1AuLosl/f5?=
 =?us-ascii?Q?2zdb5z+/YkwVKWgXV+w+Ux3ri0dUXlOe//RvXpRR2i9Um+3S9076WYdtJ70A?=
 =?us-ascii?Q?iXiMpF6tRoekcHuaEpcmAfLmnyjKBea4+btah81L4g1jQrwlDzk2TIoshUeF?=
 =?us-ascii?Q?eomcdHzt7J8/IPTEqOeb2GqFXjD/kXnACVATBZdVWdI9/ncJRKMddpPnBzNq?=
 =?us-ascii?Q?dJjJjrHQu9vT9q53S8YTZs6V+7Ev/CKN6pZY+6PI0R6b08Ugw0WWsq30siIO?=
 =?us-ascii?Q?c+peSdczJ3Trae+IaG254BX17SR8PQvPftEDYkKK1CB7ZhEgyQ8s9v8lyTyO?=
 =?us-ascii?Q?Ho4sAJn00jTY1rDi4OmNWQ7ImBMn3bgsM76O52aQ9HGb90JDwA5AOIT5s8d/?=
 =?us-ascii?Q?EExONQY1/l/NaMqHydBMW7tPkpScuG+IzQmXhsL+gJjnv6jM2bUkmr+aNr0X?=
 =?us-ascii?Q?IyJYvYPbhXjJfNN6VPxEabyAKUhgXpGWo+XoNwzC5glpaN/E4UDAO1XaUSFJ?=
 =?us-ascii?Q?V9UUXcrAebJoSELhQgCYy0EVqjVmsUF6LChMEksEzvmWHIjliT/uxwfG4K7P?=
 =?us-ascii?Q?wm27SG24j/1DwRgkd/UsH4+VivxQQc0TFyD0NMb4Z7nWMy6DYVAnfp0CO7Pq?=
 =?us-ascii?Q?oGbpS25wbjCGBFT3WgV2iadyqr8w5dTT3TEfLG7t0bm50OGqY1HVAcfkvEYk?=
 =?us-ascii?Q?/wpRJS6LVMm0vSqc4aG62NQLEgh/LyP18ES9BE0m3ZatJ7PpJSVM1lI6B0BX?=
 =?us-ascii?Q?AtVdf+2frFoXddtUJIndVkX/5CceFgnF6XZnzLQyUbsESO3Njf2C7c9+o1BN?=
 =?us-ascii?Q?R3grH8pEfL/A34P3a8Hwl33YjWIl7MjrX0rdzmsmER7DUcZbH5U2AnOU//2D?=
 =?us-ascii?Q?3viZ3GKglIfnqx4Qz09+3lYA7IVy+Yi03owG7bPEekIbtyAwbysKwa5zKi8+?=
 =?us-ascii?Q?jWT5wFWTZfhZjsIxTGo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba836bc-e5e3-46bf-fbe6-08db522b102e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 14:21:51.1083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TKe3PvVDABROC3AEvKdSAbZK7DR9rOXe1gGCcTl8k6ABKlf0Hl2E2rgKwRmp6gik545KNjGAJF0k/QqD5Pccqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5165
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Stephen,

> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Wednesday, May 10, 2023 5:01 PM

> +Virtual Datapath Accelration - Vdpa

s/Virtual/virtual/
> +M: Parav Pandit <parav@nvidia.com>

Acked-by: Parav Pandit <parav@nvidia.com>

> +M: Eli Cohen <elic@nvidia.com>

Eli is moving out of the vdpa project, so please drop his email line.
I will try to fill his gap.

> +F: vdpa/*

