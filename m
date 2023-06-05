Return-Path: <netdev+bounces-8037-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 786CB722837
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:08:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29FBD281218
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:08:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154EB1DDC6;
	Mon,  5 Jun 2023 14:08:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C501C777;
	Mon,  5 Jun 2023 14:08:14 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021024.outbound.protection.outlook.com [52.101.57.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7132E41;
	Mon,  5 Jun 2023 07:08:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJI0BUW6vXxXxonYFw2nkZO2oPbXIUtaSmv91TSuujfhOjBiLsmT7nNUPlYH1TAL19LaAjMmwC9hIxBDXtTzKHooWk3N5SgSOLmxNyH+edr8D6hLZlEyeMNWtIg8WJe6UV40thXsxxKVYRrszPkPvqXciAlkP1b1na/OaSCgU1m8yuQcYicdqBc7jofl/wEug7LMfWOLmJVXUFi1gPjzkVRPim2k57Au6BV7BhsM9+MCdsA96GoctQQB4KGU/P7cZiy7Ne9UFJLfz6iqF8y+A6COWvxMWT4juRKuQH9oYtfX4B0ViWbDzs9SNR0S6NZsHsf4tINqb0knsFSrMPRjKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FUQWGSonvXODnAHx7KGUSRRFmL1aNGXFGJDU4Gm9k88=;
 b=bTBYogXQiRxygmjqbLO04dho5RGDXyptqrqbvbqTXdGwfjpW4SF0E1IklxCEF6crtn7GSKXPny+eWgWc92L/MDC8jUMojcxNEx8VXM1JZAssW0Ib7Iqj9ZQ1mgI4eaIFvpSP1RwBfpoMBPhRQv3ihoTIeSbw7cd1gOm3pcTKoQuWmiElv5wYkTvs6sVXy+DoWwyazcHGemQR1+y7s8/SKxG5p0r1qCaM9T9iJNuEbBiO27+JeZ4TN9Y0EOMezUx/MB3Gkva+4EEgvyaxjD2RlmpOQbc18s4M4d0f4Nv4OENf/IxsGiPWuGQTsZHSKW2QMnwMT+jEAvP8LHVI2OnJpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUQWGSonvXODnAHx7KGUSRRFmL1aNGXFGJDU4Gm9k88=;
 b=VdnHfoTYfyEWpOGHOAaJGwyLw1WcoYI0YAk7obxT9jXLPNA8pC0Qu39oqtVkQW5/dr/QOJRUcUJ0ukj3Y8lMm+Tzbnr3j4gFxXOqg5XfdMqLROWoHWKp0VmQZWDYfkEQjDsT+bouJtr768SmkwG1j5g0DXh2BJrZ5Ui6QgXC6Js=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by DM4PR21MB3659.namprd21.prod.outlook.com (2603:10b6:8:ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.6; Mon, 5 Jun
 2023 14:08:06 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::7d5d:3139:cf68:64b]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::7d5d:3139:cf68:64b%3]) with mapi id 15.20.6500.004; Mon, 5 Jun 2023
 14:08:06 +0000
From: "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To: Linux regressions mailing list <regressions@lists.linux.dev>
CC: Haiyang Zhang <haiyangz@microsoft.com>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux BPF
	<bpf@vger.kernel.org>, Linux on Hyper-V <linux-hyperv@vger.kernel.org>, Linux
 Kernel Network Developers <netdev@vger.kernel.org>, Bagas Sanjaya
	<bagasdotme@gmail.com>
Subject: RE: Fwd: nvsp_rndis_pkt_complete error status and net_ratelimit:
 callbacks suppressed messages on 6.4.0rc4
Thread-Topic: Fwd: nvsp_rndis_pkt_complete error status and net_ratelimit:
 callbacks suppressed messages on 6.4.0rc4
Thread-Index: AQHZkvHeNWWbfmtPQ0KY8Y8df7j5gK98CvoAgAA9AMA=
Date: Mon, 5 Jun 2023 14:08:06 +0000
Message-ID:
 <BYAPR21MB16887C59D2B2C3ADDB61874BD74DA@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <15dd93af-fcd5-5b9a-a6ba-9781768dbae7@gmail.com>
 <ebdd877d-f143-487c-04cd-606996eb6176@leemhuis.info>
In-Reply-To: <ebdd877d-f143-487c-04cd-606996eb6176@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6bed9edf-c80b-44c8-b440-fbba4b01d160;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-05T14:06:33Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|DM4PR21MB3659:EE_
x-ms-office365-filtering-correlation-id: 8be8b2eb-9ba3-4fa7-8a4c-08db65ce48c4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 C8DFimjaosCje++kC/gpav/hT+h5w5J8t7ssiU5puv0xdOhEXsFHCQU+9myiGpRCtTlzumccmM82sCwKjgxncQ7/gel7+EtxR+yC5AK0HVWNsIoInalqidGjonLa5yEeV//X6KFWZsONcyypQHa4FyL/L7CqRO9vWmbvgfdRkxAOZ4V9eyr5LdgWBb5Rv1UaxWjx3viR+GnYErzv8i/GMWyTkz6CliXS3E8brtdU91kxeTC0qfFvy+iq8Pwjn3x7fyhbFRsvtOiQNh6Se4wX16C4XRRpjmodPxCrP3+FrDtR2RLTNG1lssV81N+ayjwvcOuUHIo3NnxB5aeRywBpF0v0HFEYUINbaGKmAQEXeT5kf9GIeVMVZHN/xPQGVzTxyL2SM78d6ASm/0urMDhK0/TrxlhmVSBWQJreUw0taCGKh9yexd+e+BJOoGOfH8ist2JISz4SsK7gFTSa/0X+Xl8xEP2b12QnX9n++i0I/yV8ebAV/uZglQNQy0MaDUAH/hViBXKdBdKt4Tj48zJ7DXotymhbJvBbkAV6AL8jmzYS05Wtc6MT/LFUptlKU06y2KwZ8SIHH6akBPJ570HkLL39A8lcCsp492aHGM/KtNkxjBBhMKjosrgFyGAEqSsBYHcBAIpYGrRZ8johd5rhXdBFjcW/L4OOZc4BS3YU02w=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(451199021)(52536014)(8676002)(8936002)(5660300002)(4744005)(2906002)(316002)(66446008)(76116006)(66476007)(66556008)(64756008)(66946007)(6916009)(4326008)(41300700001)(8990500004)(10290500003)(15650500001)(54906003)(7696005)(71200400001)(53546011)(6506007)(9686003)(26005)(186003)(83380400001)(122000001)(478600001)(82950400001)(82960400001)(38100700002)(55016003)(33656002)(38070700005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?yS5UVX9Y56qACGAav8GYny0kiftZbklgXnzW46m28Hx4SFz9G050Ea6dr3zx?=
 =?us-ascii?Q?7fOZqpOSjP47HyKTu+SheU2gK3aUjX4/JduNvAXFTYmQJRQommU/SksC1GHg?=
 =?us-ascii?Q?YXc4XP3FuK0y0qBzHQcsiBmTkXOBKwgx47U2taJ6yRhsDrM6iq/AhGYDthJ2?=
 =?us-ascii?Q?VEZuETLdJ2g10yx52jZkY0SDwv0KDgtvLbZkOHrGnN+HIvhmpZgF4f2Dk656?=
 =?us-ascii?Q?yqm01bwRY6WT+XMyOAKY1mbCN+gcHccbqRLce3d6rXZF+kQCj48YQyzBuwda?=
 =?us-ascii?Q?toXn3DiOx6pr16vypOT3O8bWHn3zxNAPc43nrt2WiCce9JP85sQg/AKHTLCO?=
 =?us-ascii?Q?CSdPuWaIcmAf6aa5kMGyfYD+m4sU9bEMH7wQFJ7BXNAxt3nnEinVzffbckfS?=
 =?us-ascii?Q?vu39awiJ8J96N7xC4AayJc5xhzHW88DhG9MxrAw3qK9Vb1k7kdH9wcniDiFz?=
 =?us-ascii?Q?5MnIqOhMG9LURind5uXYdCWnCgU8K953ldqFvFYcm1vzY6OIAvg18RdxL4sz?=
 =?us-ascii?Q?ZYQKEEXaI+B5D9LpanNUhOJngEmqb5cICMs+KKIjbmE4hIq8xUkZ8s+ZeaGJ?=
 =?us-ascii?Q?mxrkxkPMwmb41hiGZ2QfRf7RC6IxqyzX+gUqMpn5miLCcGNZq2xQnQZEJHmM?=
 =?us-ascii?Q?qKeBNel6YHvS9KIuDO4nExiVw3jvKktANBedDlGuDw3PpCujGDqJxlJEyxJu?=
 =?us-ascii?Q?7M4HRa7XTsKQKSc/+PjTMZjcq3jrhy9WiDLZVppvyeF5VFTLSBXpGopPAfzp?=
 =?us-ascii?Q?TfM/ubcsb2urbPdAZQQ2FWI1zL9IFRvzdGcg5ZoQaHZ0tFq1xpshT51uQtU/?=
 =?us-ascii?Q?wcAXxGmTDFoeR2gZmDnhV6iyE+dkpIma90i5Q/WMNZDfh9Xf78ZXe6aPSlEQ?=
 =?us-ascii?Q?MsRuGKkEmuszNVhihAN+MgOejKFOwH3RI1gOwwO79Tq9o2gx4XnRM/QfTDFb?=
 =?us-ascii?Q?F16s8qLaGOwVUClA/k3uXXaLyWmsQp9aUTWnwnZrsdb3g52SaXjaNQ8FxRTe?=
 =?us-ascii?Q?mfVCiiFgowo5N0uSwfmUUgA0cUxhax1LN6wd/fF8QHs2uU0tuLgIlOITujPH?=
 =?us-ascii?Q?P+mGCyufW1CdRnr+wtPoV/saCBji3saLpLdnYpiBP24NiNBrPYBJOGI+BOCr?=
 =?us-ascii?Q?Kt/XbdQwf35HL6pti2X5DIe79AbSpRjDg55A7ijblUXERLpPk5u86utwSiHp?=
 =?us-ascii?Q?B+AlGa1YenNAzKKldyDvnxbtCrasfwkwq5L5yl9mk5u2mX9RJLWvGgAdA89f?=
 =?us-ascii?Q?nHvkz/3lXCgeKydWhXjxmAdT+BSgvgRLR1R4YjuIx8a3Bpz3XWMarjb2r/FY?=
 =?us-ascii?Q?xKBu+RE5gbzWZmHwB5MEkhgZtUDMp8nmP0oFXt/rkDi85rvSq6pX7DoOjyby?=
 =?us-ascii?Q?qNnWwns+PI5dPUoSZx4OsULza0sU/71hgIKIX6qAsCMfIfZgbNV33Xlkz87N?=
 =?us-ascii?Q?VJYbRDiIQ/m33UckqWm8o871VEbnPS9BGMu3KZGv44fwM6WDPj/XIVH9GYao?=
 =?us-ascii?Q?kBMTezYF1lVQChSu6zEvCCMHB2SgBabwD7bXGcdS0edJOFejtCXgxt0U+Eyf?=
 =?us-ascii?Q?svpz6hhZhdQPfLoeczaPowjJ0qk/Hmvg6pB5wq/vaIsf2rqxgmBirPPRoWM4?=
 =?us-ascii?Q?Eg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be8b2eb-9ba3-4fa7-8a4c-08db65ce48c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 14:08:06.1446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZxXKK4EQ65wC0gSpI5lkQG0u/MQBUQ7HdS+M3LQMxkQy08polvnaH4ZcKtc7YDny2WLDBiIPgoxv2zf8l6Sq3of7oaqV38RL1JZl+io1/oo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3659
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Linux regression tracking (Thorsten Leemhuis) <regressions@leemhuis.i=
nfo> Sent: Monday, June 5, 2023 3:28 AM
>=20
> Hi, Thorsten here, the Linux kernel's regression tracker.
>=20
> On 30.05.23 14:25, Bagas Sanjaya wrote:
> >
> > I notice a regression report on Bugzilla [1]. Quoting from it:
>=20
> Hmmm, nobody replied to this yet (or am I missing something?). Doesn't
> seems like it's something urgent, but nevertheless:
>=20
> Michael, Bagas didn't make it obvious at all, hence please allow me to
> ask: did you notice that this is a regression that is apparently caused
> by a commit of yours?
>=20

Thanks for flagging this directly to me.  I'll check on it.

Michael

