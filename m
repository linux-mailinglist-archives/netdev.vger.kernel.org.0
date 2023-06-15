Return-Path: <netdev+bounces-10976-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26831730E3A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5905E1C20E30
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE49386;
	Thu, 15 Jun 2023 04:42:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DD0385
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:42:03 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020025.outbound.protection.outlook.com [52.101.61.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A162103;
	Wed, 14 Jun 2023 21:42:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T89w5SVx2BV8H19rfEqa6ldrh52c9he5omNYm9Zr5XhdxGZG59Y2Yd93TvxWOviolaZxWUGanD2sbbj8WKHNtMBnAk9j1FXlyW/UDwJgV8+rsviKhSqomNycYM40WAYYetW35HpPgra4BWbHM/v7WsVN/VsNvrtLKEfx+KVNrcSdoqdk7KEBAEwWr0Df9SOLFvrTK+t0XViupMFjwzw8i2kYuS94j+7nD86Y6mJYz2vGv78acrnS8ktCs7hpbVOtMBRJs5SENLdbfQ0EtTFGI8+gyv5Kz6ONe3h8adJ6nKPVcU62V+9TMCzKVZ6VNi+ch4k3Wd2j80ar8ugIHAwZ7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pi72W9jtVlQAq/pXqRM0p4yNbG+Y3IH1K1gkzbYenI=;
 b=aodt/pTLX/YzZP0cvcZqKAVTTbQaTBaaz3VNVknTRyc7BIgV20ZExBSS02hHTug6YO5Ry/Ts/RW5RchiCK52YU2jy30HyuXfw0/agMCWi7Jo8FzCAj6p420kNGclL1Fjjr4V82n6+j6ZapiGc09AAgOXdIbqSPTWplYdS7mZdRZo0IrFvbYekKFRz6PksHlZDlqvvgLhaSLRlcqmclWYbnFIq7DSaENNEFyZ9SZr49/zkcP/SwgLlwtGThgr7hMz/sFdb5YGjm08B47Wsd/k42PXHrVdT5uSQ8vzXeStypPSg+zryYicrmqI32164/oHlQsYgd22dwMhpbHu6hVnxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pi72W9jtVlQAq/pXqRM0p4yNbG+Y3IH1K1gkzbYenI=;
 b=CUz5zbPSGDreINXV2gCBWjDvgC51j+R7fIBHpq/KfE5CnVBucVEEjlHPeP4CNDEDg4GjW2ebdaWGFVKKLQ3DdNdtiiXpFvXrHqxyWHHxgnzBvLFTUlKXaC0xe58sqCnyYCniCh/qSk9sOEL1CvLDAw+zCdHN6ozHTEqT19BzGvI=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by PH0PR21MB1878.namprd21.prod.outlook.com (2603:10b6:510:15::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.10; Thu, 15 Jun
 2023 04:41:59 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::bb03:96fc:3397:6022]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::bb03:96fc:3397:6022%4]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 04:41:59 +0000
From: Dexuan Cui <decui@microsoft.com>
To: Lorenzo Pieralisi <lpieralisi@kernel.org>
CC: "bhelgaas@google.com" <bhelgaas@google.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>, Haiyang
 Zhang <haiyangz@microsoft.com>, Jake Oshins <jakeo@microsoft.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "kw@linux.com" <kw@linux.com>, KY
 Srinivasan <kys@microsoft.com>, "leon@kernel.org" <leon@kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Michael Kelley
 (LINUX)" <mikelley@microsoft.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"robh@kernel.org" <robh@kernel.org>, "saeedm@nvidia.com" <saeedm@nvidia.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Long Li <longli@microsoft.com>,
	"boqun.feng@gmail.com" <boqun.feng@gmail.com>, Saurabh Singh Sengar
	<ssengar@microsoft.com>, "helgaas@kernel.org" <helgaas@kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Jose Teuttli Carranco
	<josete@microsoft.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v3 4/6] Revert "PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally"
Thread-Topic: [PATCH v3 4/6] Revert "PCI: hv: Fix a timing issue which causes
 kdump to fail occasionally"
Thread-Index: AQHZjuIaSxYewRNVfE276+Ax1Cr956+LaDLQ
Date: Thu, 15 Jun 2023 04:41:58 +0000
Message-ID:
 <SA1PR21MB13359A78EF24E0848BE58266BF5BA@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-5-decui@microsoft.com> <ZG8axpfFQArZ0Hj/@lpieralisi>
In-Reply-To: <ZG8axpfFQArZ0Hj/@lpieralisi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=67a9d983-e1fc-457a-9631-d4ce33fd5bb8;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-15T04:36:42Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|PH0PR21MB1878:EE_
x-ms-office365-filtering-correlation-id: 9c46bc8c-01ba-4235-a622-08db6d5adade
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 LgmSg0JdxEAn49Bo7mnra6tLn8ZBZ1xzpC0CqS6TjaSHgC2K90Qg+5b3/wiW+kDMsUigccD/blLk8+ZQTZqHAwiyEdFuGVYVhL8XI4GcAa8T5uEkgEKPpDuZySQ4WWNRIKnElGj8kMja7L3Ej5diUYrzM2zlTHq5lE95GlHoGhrTClqfr4AebSAcsAsc3MC1KU3FGkWMgW4kDD1Kfd2fRM7xDKEFkan6joAmgljCK6W5AuITb2CyeCRYs1nyKibF8qPSDKh0I4BbcSS5B70RGTYbPZuzl9N4i8qtAsBOuaUwzOLA+9rCOJ0zL28Hfb8DGVqc7XbRhFGZN87SYMY6aSHekqGIETtng9vElQbjYUjUXbMn1u8l8Z73ZMNWy5WQp/hJuUSaS7nQoYk4LoUZm0n1Ere38nvCkaIuCnR4cShGUKSZ9CONAWdX5MPZ8t82Iv0D1mXC2WUca1ngZXMva1TFdOe9cvqgnClvKcr3hwxPnwPqDSplhzbd20Qy3ZttB1NV1QEJ2GYrRr8x4s0uypTHgDlHbpzm+9XOg87Ye9AD5wHnVq/vidACS6WBJkTy9sUaU46Y4RqxctC09Tn4SqDsAvxQ7E1NyscQ0lrT9aFR3no9IpefBuXgu/FToVpVI1KHK1naFXnVpiP8H1EYw/s/LK0rxKkjn4Qx59Ir8z0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199021)(9686003)(6506007)(478600001)(10290500003)(186003)(55016003)(71200400001)(7696005)(2906002)(8936002)(316002)(33656002)(41300700001)(8676002)(38070700005)(86362001)(122000001)(52536014)(82950400001)(5660300002)(82960400001)(7416002)(38100700002)(54906003)(83380400001)(6916009)(4326008)(64756008)(66946007)(66446008)(66476007)(66556008)(76116006)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?girHYy5rVldE+sUXJGgC0nzOp6BllKBNCqia21+Z1O955Zz/tKu4Bu90xwtK?=
 =?us-ascii?Q?5EOCieVg98GakPbY2Gsx8zDhQ/k0V29ukKLB85OrJBLDbanvkyy3PZeQeAUE?=
 =?us-ascii?Q?q20r9bcBInJWR8mMtQ45k3REC3U1QFO6eN4XLpfx/4J6wrb7RhCcc0Hbr8od?=
 =?us-ascii?Q?Y6nU4C+s1FMlQFAO/ekS4Qj2nERB7UxLmSOcOueE7Mpl1uLwcjQhuCFhzFCD?=
 =?us-ascii?Q?qPXzvUY4vBdV+9lQGSBccSYiLyPuA8MEDX6ENmNLz1W8//sk1fbqHPO4ue7B?=
 =?us-ascii?Q?VDzE5OtwBBzG428Ggj6unyiwdR2G3+EJxW+DinhT72Xsp2y/CjqBYAudoaUv?=
 =?us-ascii?Q?U7++6hFrLTDSEvg6mAsMPzdBZ0BGWZNGHGHZIdMzISXUCtbZDP2LzlTZln5t?=
 =?us-ascii?Q?bsUPdTXmOo6KqzB4qWmC+KfeXjF1Zc9JUmUpoUpNdtaaFLboZ2eSHwC1hRRd?=
 =?us-ascii?Q?ahpEay4whJFijABzWDwny1f+kIwR7C8DIo8b9582ZamOLZLxgWOGHMl+Ad1+?=
 =?us-ascii?Q?zvLBuqVHoNY8JRWdWqJdKZV1ufsXPnpQiqG7G/9ttazChz5+ZrmyWaQjIfNk?=
 =?us-ascii?Q?wLzg/LM4Bq0obj9sXbuaHz6O91Gft/Nlpm9zzgX8/Aaaaljnegi1cAm2AANK?=
 =?us-ascii?Q?VWelYTLov0/6ELxnLTR2Q7rXgvUx3YARqG48olIJkgttryGrPohWcsHFdtzl?=
 =?us-ascii?Q?eGqS+IMPOKBVGiHSJteN1UOKCa9pC5E+fsqelWM+i4KeneNcPaqiTfvlHUz6?=
 =?us-ascii?Q?FZ/iiiCRE+jFJ0n51j89vSZeyKIg743Mqg4N9RW180IM0N5WuKYtswBVVIFw?=
 =?us-ascii?Q?DcVFMIUWH7mvx5QkeFFolj7ZbhZz6uxjMfQzfejMzsdlWLMkPfg2L06eQS7a?=
 =?us-ascii?Q?Hrmt++cPqyvWI36zIZZylV6wbv298cP/VzqcA8T6C/zfJpBY/uTu2bvU2u63?=
 =?us-ascii?Q?eYMn+pFhMQY5JY1E29l1ATVlrKfYFOU6j34Wdis2AN+HyPckmWBjmRk/1UBS?=
 =?us-ascii?Q?scQt+UlxigLNbPZrF4v37GJch2Y+SxrAg4RGNOWGHS1kpkPjjrbrTacFL+Fk?=
 =?us-ascii?Q?KGvVe/8xwpoRekdmLYa3xPdWO1tPm36QcDp30DBY8TiHmUQKxRkkOsOeTBBK?=
 =?us-ascii?Q?xmAvNsguz4MOI7CR29cnBR5dLP07uCaZr0St5Mq/bm7vHqbtLvBbx0xq/1be?=
 =?us-ascii?Q?ej1Yx+1sditDMu4U3kC1Xfpt4KQ/0pPq/ryp5AiqHQajdrUKFekf4j0MpWyo?=
 =?us-ascii?Q?od9SaUy2tyOv51BrqwIsLrM9xKbJSCuwrjzQItWf2XFtmWvTJdLCl2wuYxwa?=
 =?us-ascii?Q?yYxKYvwWhViT1hkeA+Fata3IUrScMiyI1WPyb/Yu2Q/ZRP9wFJmBhN+hkJfG?=
 =?us-ascii?Q?AR9hfqS7wiw/cTF3XRMqFuBI/0P1JAhvwFYGFFRMnur7alLJyhG7LwISJgm3?=
 =?us-ascii?Q?MrCKHZIWPYqv3lx+4fWBfRwWPkAyrBswaG9XKLf5h4NFzlDzK2WUXfnfP5Ob?=
 =?us-ascii?Q?IqIixgKpt3rX+91TPDBHIgjqhuUeqH5xNBQZXZPakC7ABMr2vUt8RMUccusc?=
 =?us-ascii?Q?3QQss2RttnGrt2KGEcZSl082rtWPdiFOP73F2CC8Wk13vojgCddAxe8KAmwX?=
 =?us-ascii?Q?R/SKzSydLWLNePMUJb7uP00=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SA1PR21MB1335.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c46bc8c-01ba-4235-a622-08db6d5adade
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 04:41:58.9438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gjK2/ZfK4sySZef7ZYhwsFfmrYVmPgtIkSGsYrL3LAwt1ZEmwi3GBNIiULWk0j8Ck3H9MFzcI1rX4ng02+1Plg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1878
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Lorenzo Pieralisi <lpieralisi@kernel.org>
> Sent: Thursday, May 25, 2023 1:23 AM
> ...
> On Wed, Apr 19, 2023 at 07:40:35PM -0700, Dexuan Cui wrote:
> > This reverts commit d6af2ed29c7c1c311b96dac989dcb991e90ee195.
> >
> > The statement "the hv_pci_bus_exit() call releases structures of all it=
s
> > child devices" in commit d6af2ed29c7c is not true: in the path
> > hv_pci_probe() -> hv_pci_enter_d0() -> hv_pci_bus_exit(hdev, true): the
> > parameter "keep_devs" is true, so hv_pci_bus_exit() does *not* release =
the
> > child "struct hv_pci_dev *hpdev" that is created earlier in
> > pci_devices_present_work() -> new_pcichild_device().
> >
> > The commit d6af2ed29c7c was originally made in July 2020 for RHEL 7.7,
> > where the old version of hv_pci_bus_exit() was used; when the commit
> > was
> > rebased and merged into the upstream, people didn't notice that it's
> > not really necessary. The commit itself doesn't cause any issue, but it
> > makes hv_pci_probe() more complicated. Revert it to facilitate some
> > upcoming changes to hv_pci_probe().
>=20
> If d6af2ed29c7c does not cause any issue this is not a fix and should be
> merged only with subsequent changes.

d6af2ed29c7c does not cause any functional issue, but it makes the code
less readable, and so I'd like to not merge this patch with patch 5 -- this=
 way
people can easily know what the real change is in patch 5.

