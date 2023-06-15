Return-Path: <netdev+bounces-10974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9D77730E1C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 06:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC52E1C20E14
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 04:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3FE655;
	Thu, 15 Jun 2023 04:27:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D942625
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 04:27:50 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020014.outbound.protection.outlook.com [52.101.61.14])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C36F5198D;
	Wed, 14 Jun 2023 21:27:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ovo3fTBixaxTuTgs73fQvCqLr8kCeDstXY5sYh6KSbQEM+I5VCUJZj7ky/+Y6cMhgvBXP6hPOs9UFxyylADDJ/a+f2ziyqK/dXamFfWvYQ14duaLuBx8bZKvaMo7nzsW0VwYxH05Aw18c8OEv0pRm9PPftogRRjakdUykKExdFQEKvKpyjgU8YXj4IiAFIGYqh9tEci5tbkJp7upEIWUFwwtztiZeDyIDRFWEd1j32F8RO2EX6KOcb1wUCHzWNTQXoSjpQWfPP2+8aX2yKTD0ekE7oMA3xFYcPT+QeXnqR/GGLX06I6m2RFrRlAqSXgJWjPnZxCMN5S/T5QpEdLFNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=01YY/vBFjGjMwvGEHtJ87RVvi22XaEEoyqH5o61Lb0Y=;
 b=PdDW7ik/NjqWPiEDGoZiZH/x3gJgepaHeVpWs8sVW2pwUDRWPgDnL25O/8cPUAKycPxGBZWw4OrGAGOGrz+WthlomX6SKyWlJNj6Xmsz0VROY+2smyhzv+PRxhzDP9omxoKtJRdoU0OP0HMrC4P4LRQOKhsmTOOoZy+0OaqZa5FPhxG7lX/gPYyWvTWm051Ix18EaCvX9pSSpB3y9lFZ5c84Dx4U95ubibrbUXsoraem5rSrEp32rKfonMCMEuYpvgSVfgTrhg07yjqr5PsyIn5HbBksDUOLxPuUGCDOXD3IFvejvV+5KLzVsHsS1vfyJQhjhVtrcAWSrVKsEmzJBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=01YY/vBFjGjMwvGEHtJ87RVvi22XaEEoyqH5o61Lb0Y=;
 b=XhuSZe76JU/9luGMWOXj8iPYCuA8mAcmfsMXtVQO5vZC1wMYZJiaEcFO4RCrL5jhGwnjHlYst913B7StXn7tGB6Hcnhv4SnAwR7w+tfzq4iBpL9h2/gFMA6ELFYr2rjs5gcTje9rW6mV/kLZrFSvgydBq18nrGQY/r7aCz5/iw0=
Received: from SA1PR21MB1335.namprd21.prod.outlook.com (2603:10b6:806:1f2::11)
 by CH2PR21MB1510.namprd21.prod.outlook.com (2603:10b6:610:8e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.10; Thu, 15 Jun
 2023 04:27:45 +0000
Received: from SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::bb03:96fc:3397:6022]) by SA1PR21MB1335.namprd21.prod.outlook.com
 ([fe80::bb03:96fc:3397:6022%4]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 04:27:45 +0000
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
Subject: RE: [PATCH v3 2/6] PCI: hv: Fix a race condition in hv_irq_unmask()
 that can cause panic
Thread-Topic: [PATCH v3 2/6] PCI: hv: Fix a race condition in hv_irq_unmask()
 that can cause panic
Thread-Index: AQHZjvHvMuBijgFAUE2iuK+yh+6HEq+LXMWQ
Date: Thu, 15 Jun 2023 04:27:45 +0000
Message-ID:
 <SA1PR21MB1335549F59339A9848101158BF5BA@SA1PR21MB1335.namprd21.prod.outlook.com>
References: <20230420024037.5921-1-decui@microsoft.com>
 <20230420024037.5921-3-decui@microsoft.com> <ZG81WpJBBegbLSbT@lpieralisi>
In-Reply-To: <ZG81WpJBBegbLSbT@lpieralisi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=aea10944-eda4-4b97-ad94-fff1ee2a7f81;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-15T03:56:14Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR21MB1335:EE_|CH2PR21MB1510:EE_
x-ms-office365-filtering-correlation-id: 3c684c38-fd56-4318-ea95-08db6d58ddfc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 fsCAa9XuF09RB/t5bSR5HEDAsJ+jSfIV8pbW859ISj6ABOkBfJ+746G+iJe4AzPkR551F54A1MPR+ZebEPquz//ANK16uCbbVxL0JVav9OQ8jud/vyKIJrnhEIZRINpk1y9TTI0XkZzZ6bn+SnCrS18G4HaS9kvgb0uE10ivWsiyUZ/ChTxwbJWnuLheY5svRsvJ8GbT538V0LRjDqQuGShQKpSowTTr51EvA+jRxtevcTVbgq5gPC1v8B+B96+XQFJpUJmGmWrR/rYc9AQLSi0EKqAWXMq12H7H8zuoPy6l9lsjTy7h5EMB77auUEa0L1uKu6f0waidFmzXeKJG7d2t+Cv4KVXZ1JEz4Gxz/CVM0bl8I4UInjPgUppD6QXxmJamIURFiH1zq0x3Yd4zZ9xKn2xBkwaucp+03Sub343j8oyBKipvwhBHiGFIA5s0rkHH88JP+WzmN7IAb9ozQBnq/uHg6o/8xEdTK1EqFDa+dG+nVgomex/tSbBPm+zMHz5XUrlmqncs667k29N6dDalOXrCMQnIQtOAYacvdm08OKBPu7Nk9rkJKaYHFczdnsThukL6Tr/8ym91lXnpQbcQ0fKaj2OMCLycqiLNYAstI0dEZF/ZfGYRKu/7hCQptSaM8c01o0+MjHF+wEBMz5kyWWx5i1wBjNG+jFpKexE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR21MB1335.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39860400002)(376002)(346002)(451199021)(8990500004)(2906002)(86362001)(33656002)(52536014)(38070700005)(7416002)(55016003)(7696005)(83380400001)(186003)(9686003)(6506007)(5660300002)(82960400001)(71200400001)(478600001)(82950400001)(122000001)(54906003)(66946007)(66476007)(6916009)(64756008)(66446008)(76116006)(10290500003)(4326008)(316002)(38100700002)(66556008)(8676002)(41300700001)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?+Hi7sYsdZRxugsGb6H2yU5PDc9X7EPXvkpid15yjWnLDD/HwJ8mGxJXiPhLx?=
 =?us-ascii?Q?6GOeUeAAuzxSTnMKVaFB180rjzSQS2iK77dNnOG+qGfBgF/tQ2O12kH19YX6?=
 =?us-ascii?Q?0yMiAZAs0bXnLleV/ewfSBOvPO7xADy6E8Yd9wsT5ySMN13W/vSkUvnPi023?=
 =?us-ascii?Q?SQRgZfRW46VA+32iPfO+yswUchNs0wSm1FPBi58XOaWqpEJOt+zFGo15Gip1?=
 =?us-ascii?Q?PDv1dH+ZzCXzzqVwqUYxjFVnQAW3AxNDRZqPhPewa6n9jMWBzuxoQ4DCKZRD?=
 =?us-ascii?Q?m+gHMHWOrloMj+M4DfoA8rA80FqIb1sPoTGpM/0Wu0VlqGQSIivo/rkVsosW?=
 =?us-ascii?Q?yTPqEYS4x3QWtzoGtREPEEdIk/6pNf/bOzCr4njjwyHDyWI6LYkDoQWbTtdh?=
 =?us-ascii?Q?XmrJOLCyR40o2N0ihaZ54m5znnQknCwvrwZaobLRAyHepXQ2lE9BOWN4ukn5?=
 =?us-ascii?Q?P+xTLPiGXSUIHcirL4qTWVaTmudlmX1+oI/x2wMdDl0VcW+SI8eMFFBcbRgZ?=
 =?us-ascii?Q?ow1YHLUJGBWGEkLrHypglrCC3HzCHF3WD+7dvB/z4qAzAr1pviTRmiXmAO+9?=
 =?us-ascii?Q?iId/XNTOFwIkiydrZ4FbJoubSURJbVitmEp4Z3A1lMb7BPZsQN1Ata2oHeB5?=
 =?us-ascii?Q?a4JdcumwONa5DUmWjQhT6cXQfRVaOJ911o9XnAuZ5t8Q2O7BPWjqqhG2wOfY?=
 =?us-ascii?Q?h97eAEhyx/b6mX7HVR7A8C6pbATmsA1/WOotcmwk9qUk/cMFk893YuCInasz?=
 =?us-ascii?Q?6qpAzh/Gtx622VrrgKsIrTiwHm6p6FMcgsiv1r6cud1/nFrKUrm+Uy0TGIlj?=
 =?us-ascii?Q?b9aB9J6yWVYegn59AnmPmnardCFxZNe8gjgDQM83SalxXstI3Z8hXrTZhRF+?=
 =?us-ascii?Q?D+tE8hKfj+nzjgak8YbnUDiBhI+dEO1znkZEElzHPcuJXbE8c4w2ubsLn6OS?=
 =?us-ascii?Q?VfpoIDjSi55Arp5lNHWIynyv8R5jhyp9/UGY//w9315O97tlX62Ap1cZebI1?=
 =?us-ascii?Q?jI5wG5hYBNZJ6n5+ne/mD/cFX4XIsb4y5+WT4sOL3p/r4df7Jki0jagD+vrJ?=
 =?us-ascii?Q?+agIsVPlVjGjOkS1eiMS4HFqTfz1ySM3eeivcVQ8/kl7t7QvpOD1SyzOt0mK?=
 =?us-ascii?Q?swsTLoARXybLPzYMGFcMTM0CfdIayGGBi0H4k19IjHps+OlawqEccGafz3J2?=
 =?us-ascii?Q?kZrB3rJUPG9SOfVekkZdrG0wYq9roPnhBluepuFP6vo9BstzzPS00GAvupNU?=
 =?us-ascii?Q?4ZBsLZ+fYqxUFMfU+WCdQ9+xzfMxhV6+ULOQdyKmt98GYNJYaum8Bams5A63?=
 =?us-ascii?Q?8ooACjtsBdMmA0ZM9SziQdI8B6hs9y7ZjE9yTaggIlSPy6QTehHV9hFxJhHA?=
 =?us-ascii?Q?EBVhS6Mgtl1Y6BdKKnIOXLJoyRFq4lb6Cgf+j5iHA3tHxla0gl5guXjQF8Dl?=
 =?us-ascii?Q?2JIbJVi9jxGmtQcBg01RMpOw8uNpA1S25B/E3WIsnI1NaIQuF1a6dva+hREv?=
 =?us-ascii?Q?BJxxIDIn7z35wVYRVoeEQr4EQYz99+OM7u8JzJirEq6juojaWKYqukCZ2UyD?=
 =?us-ascii?Q?I2RRs0RjCWNv9GFpz2drO0vP+XHn1aXsdDMuH6FXaJhi/I/A0ERpi6S5uIFF?=
 =?us-ascii?Q?12DGr1H+EKzgx0mk+W7bJWI=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c684c38-fd56-4318-ea95-08db6d58ddfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 04:27:45.1664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eLVDdTK1gyitIS685Uh9V1/PzW8AzS/H0ieBZe528E+lQmwzumhTPA1mJPpHx1wmfAvJpz3lHFG2mtDsAgwK2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1510
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Lorenzo Pieralisi <lpieralisi@kernel.org>
> Sent: Thursday, May 25, 2023 3:16 AM
> > --- a/drivers/pci/controller/pci-hyperv.c
> > +++ b/drivers/pci/controller/pci-hyperv.c
> > @@ -643,6 +643,11 @@ static void hv_arch_irq_unmask(struct irq_data
> >  *data)
> >  	pbus =3D pdev->bus;
> >  	hbus =3D container_of(pbus->sysdata, struct hv_pcibus_device, sysdata=
);
> >  	int_desc =3D data->chip_data;
> > +	if (!int_desc) {
> > +		dev_warn(&hbus->hdev->device, "%s() can not unmask irq %u\n",
> > +			 __func__, data->irq);
> > +		return;
> > +	}
>=20
> That's a check that should be there regardless ?
Yes. Normally data->chip_data is set at the end of hv_compose_msi_msg(),
and it should not be NULL. However, in rare circumstances, we might see a
failure in hv_compose_msi_msg(), e.g. the hypervisor/host might return an
error in comp.comp_pkt.completion_status (at least this is possible in theo=
ry).

In case we see a failure in hv_compose_msi_msg(), data->chip_data stays
with its default value of NULL; because the return type of
hv_compose_msi_msg() is "void", we can not return an error to the upper
layer; later, when the upper layer calls request_irq() -> ... -> hv_irq_unm=
ask(),
hv_arch_irq_unmask() crashes because data->chip_data is NULL -- with this
check, we're able to error out gracefully, and the user can better understa=
nd
what goes wrong.

> >  	spin_lock_irqsave(&hbus->retarget_msi_interrupt_lock, flags);
> >
> > @@ -1911,12 +1916,6 @@ static void hv_compose_msi_msg(struct
> irq_data *data, struct msi_msg *msg)
> >  		hv_pci_onchannelcallback(hbus);
> >  		spin_unlock_irqrestore(&channel->sched_lock, flags);
> >
> > -		if (hpdev->state =3D=3D hv_pcichild_ejecting) {
> > -			dev_err_once(&hbus->hdev->device,
> > -				     "the device is being ejected\n");
> > -			goto enable_tasklet;
> > -		}
> > -
> >  		udelay(100);
> >  	}
>=20
> I don't understand why this code is in hv_compose_msi_msg() in the first
> place (and why only in that function ?) to me this looks like you are
> adding plasters in the code that can turn out to be problematic while
> ejecting a device, this does not seem robust at all - that's my opinion.

The code was incorrectly added by
de0aa7b2f97d ("PCI: hv: Fix 2 hang issues in hv_compose_msi_msg()")

de0aa7b2f97d says

"
2. If the host is ejecting the VF device before we reach
    hv_compose_msi_msg(), in a UP VM, we can hang in hv_compose_msi_msg()
    forever, because at this time the host doesn't respond to the
    CREATE_INTERRUPT request.
"

de0aa7b2f97d implies that the host doesn't respond to the guest's
CREATE_INTERRUPT request once the guest receives the PCI_EJECT message -- t=
his
is incorrect: after the guest receives the PCI_EJECT message, actually the =
host
still responds to the guest's request, as long as the guest sends the reque=
st within
1 minute AND the guest doesn't send a PCI_EJECTION_COMPLETE message to
the host in hv_eject_device_work(). The real issue is that currently the gu=
est
can send PCI_EJECTION_COMPLETE to the host before the guest finishes the
device-probing/removing handling -- once the guest sends PCI_EJECTION_COMPL=
ETE,
the host unassigns the PCI device from the guest and ignores any request
from the guest.

So here the check "hpdev->state =3D=3D hv_pcichild_ejecting" is incorrect. =
We
should remove the check since it can cause a panic (see the commit messsage
for the detailed explanation)

The "premature PCI_EJECTION_COMPLETE" issue is resolved by:
[PATCH v3 5/6] PCI: hv: Add a per-bus mutex state_lock

> Feel free to merge this code, I can't ACK it, sorry.
>=20
> Lorenzo
Thanks for sharing the thougths!

