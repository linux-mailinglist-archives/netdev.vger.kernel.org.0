Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD0835388F
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 17:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhDDPEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 11:04:43 -0400
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:11137
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229788AbhDDPEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 11:04:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOQn+lOJc412+fqzsxhgqB8mWKMXyIvCSJyPJ0DnNFWr21GcgyQVLLzC5XOwiAifmLKl15/Z7EDXNUz72aMNiXy2IDfE7zdxiSUIa7pP9+AsMIIBEi/dABwoUxkSybIF+jBMEva/XM2BA7AvXh7c7PDqAAIX8WwDmpmuHqIh2oUVEjTToMEatyeVW2CMKE6hLjmvszcHfnpj0oOmAHD6X/G+FkRBferZV6OOoH1TgF83B9/mfwaRwa5sun4Ikw4Jm+ZU6LcodTWBcPzqgPKlCL1ENH+rGkWfF9CZ72f5JeFJQHFtdos9865PAfOaaMQjcY/p23fXK4x5mnqZva3b5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmJPfYZZeeUHJLFkRfij0B+LVJyvCV2nnWWnz4j5hUA=;
 b=CgGeRa8YeSIWwQb2z2I1atGE/mipS9x/AKMNeXgV7mfSkA47QE/XTzuhiMOf3BMFcC0XzwSr6J3AkEjeV9xFeV3oxHggRv+CDQ+4wLGt6OWDmpydCkuP3Dc2/OOL7jTzY7MXOnofpkZASyhGUg1OoDRZYypBXLSJyFvD1ofPQkT6U5viSkHT17+LT9yby5elxADwFruxLFrPfA+KGGa3BiY63xFK/nW4B/lMNCszckaLp32F7ceNjJIXSWM8oxbBs584C2SWoO+G8Imoq9YS2+GpmjIQLL5/U3M5r9XaQUmS07gumS8mMoS53W/HEhQE7tC7I7WfW0i46JLdvGwNNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmJPfYZZeeUHJLFkRfij0B+LVJyvCV2nnWWnz4j5hUA=;
 b=I7wVXQzF0sq0+ltfm5E8S9yuFI6ZKcxyheRw2KYkvuiMUrx8VNAo82nU1UHcJiX+K6EKhlsxmIip8SDRwLKwEnDfSo2JxaGRvmitsASb8YZAkyAeCtsQmgeeAsjpNr2H4mTwTfDk93tKDgSFwuzRFWzrwNARDQ68SQS6xc5FhuyEiQRv0NqkMlifHARGxptFbXUrKL0ioXlIPi8XNzoaK/h0c4t/oawbIU/t4Jct9h2AO5Q3MRKEp56Xmq7F/kCUWkdEhLcAs3Mkc+nJ0gVHQBp4MrwLRrmkSOxcKUrH6+JrICe/DTE/RoqLI/gpggpWtoHkMOuPXg/0C5chzL2mmQ==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM5PR1201MB0123.namprd12.prod.outlook.com (2603:10b6:4:50::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Sun, 4 Apr
 2021 15:04:35 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::8423:fe54:e2ea:7775]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::8423:fe54:e2ea:7775%8]) with mapi id 15.20.3999.032; Sun, 4 Apr 2021
 15:04:35 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "acardace@redhat.com" <acardace@redhat.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        mlxsw <mlxsw@nvidia.com>
Subject: RE: [PATCH net v2 1/2] ethtool: Add link_mode parameter capability
 bit to ethtool_ops
Thread-Topic: [PATCH net v2 1/2] ethtool: Add link_mode parameter capability
 bit to ethtool_ops
Thread-Index: AQHXKSqiy1NCZxxuWEyWWVUMq+pPVqqkaG2AgAAFdAA=
Date:   Sun, 4 Apr 2021 15:04:35 +0000
Message-ID: <DM6PR12MB45163C0617DC03F24E6CCEA0D8789@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210404081433.1260889-1-danieller@nvidia.com>
 <20210404081433.1260889-2-danieller@nvidia.com> <YGnKs/k0ed0NwTwe@lunn.ch>
In-Reply-To: <YGnKs/k0ed0NwTwe@lunn.ch>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a56960a-e46b-43e4-0328-08d8f77af5eb
x-ms-traffictypediagnostic: DM5PR1201MB0123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB0123243ECA9CECAB31540314D8789@DM5PR1201MB0123.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Va4Ei+aZ7i7s7MhqB8zxHKytvudiVS5RXSaa8lJm0Cx9xFdtsKFzsKb4xPhY6iDWGlwBPvUfZQF3TcJ++IjLlJX0tvRR0YwuOOhVKCT3VsPHyhTx+7CEi+8dxP5qQDBBxX+B1PS4i2aRBoLdVIXOigzPbhf+ncdf1i9VlzUkJKRIKD27vqVypEb7kIeREyNpwjg/eoeXTGNDmBcfghAIMYpIPI8ZsUZ5aYv8c1iQrOCsF1Zgc4kvH45jdGaM+3lR4vwhIAhdCzmujT5vk69Fo7jdCjPXMC/fccar5Y4W2IBY/OjgIv9Cm0k2Oxta7XymMsLfO/Bnl7bf0NGZmJvaL/OH12H6tdiCVCuQ20261KcPZI6qwH9bHobDFgmjrXvrLwtvkW2l5l4JySYPv1gI1aWKRed3zdHXu7JkBbq4SYlMR3+3+k3EvBAMCzOVzo7qbjzCrs5kaHqbOfPlacSVX+mEXQID33Guka/KfVdR8v9fDY/VHJ5y2pALTPkOOrs83HqWsXKLFIQ6RAF8vi/+7Qmxyz0OGJShjjYqGQAfL4FoghRx6/hVfPczFtHVbdy1x+IEU3hWhG5isadicCgm2+/JU+ytFfIolsPz11ClW7oanDXsH0ufFFvAh/Pd1wvzWVSPEBHs//JVzmjKl64bSerwWlR40fqNFdNPwphYPi4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(8676002)(5660300002)(26005)(38100700001)(316002)(478600001)(2906002)(9686003)(107886003)(8936002)(71200400001)(52536014)(6506007)(186003)(53546011)(83380400001)(6916009)(4326008)(66556008)(66476007)(76116006)(66946007)(33656002)(7416002)(64756008)(66446008)(7696005)(54906003)(86362001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?gqcR5Z1yJKuxPhyusX+fJiH8cL5TlTxinQBjW+ElrNO7Cy+Or3w7AXcme2l9?=
 =?us-ascii?Q?7ye6/2NSzMWW2oEioTdHPbKc6S/NwXFP3kt5nNr2Xk+O9H41BulVtzdXocfW?=
 =?us-ascii?Q?o4CwcZ5JPaG531PTuZpnhJ1Tm1yUpNBsPs54PgWkhRHoQBI4858d8FhSAl76?=
 =?us-ascii?Q?BR34uPZZ3dDFsWS6jPRrsrpvt8raroZJ1jBqRYqWxwv665FAtBIH9wtO3lDf?=
 =?us-ascii?Q?O4Qzk2E0cHPKm2ZlQ2Iz2MHlnZV+TQDwPf1lCqEnnUEFwK96JvH8XNsdFQ1L?=
 =?us-ascii?Q?2omD+RaOCHfabnlhcAor/U2fZ/6BKbLkOeEypCknIY3HUVUK6m65w5OxRVKx?=
 =?us-ascii?Q?YlToV8ErCNgDT0uaJwnkynAYnGmQeTev0UA8vcbQwRa45VLfHCE3bN7k0TQC?=
 =?us-ascii?Q?/BdkKU4c+SBdJAwFX5d7IBfYDlE6vuI07GOp4jzmn+BAUCGo6nQx23q+nwfN?=
 =?us-ascii?Q?zzFuVSitaJdsi37iNqkR2OcxixEVz3ZRIl7BdFUM7hlmYqcyxHXSz7JjJ3JN?=
 =?us-ascii?Q?Z5dJNhmz9aYAaYbZXw2R4P7cek7v8Inj6I9LVPaNhTKbQjTl5Jtx7JNDj5Tm?=
 =?us-ascii?Q?CKKw7q/w2tY+ipBqE4hLsxJVwKP9UZKmaIGvJ8YtmtGPLccOeC6cuMRHk6pm?=
 =?us-ascii?Q?21Zs32k32ZLSnuQlywLxzXc87XmiuV7OaDwq42Tur35F7QR5w/IcFVi3NT9y?=
 =?us-ascii?Q?yojuoLeOlP5lBA8lWBVyv8TP7WHwRZvXuqlREUPoszwcLBA7bQSaaq3zIVqA?=
 =?us-ascii?Q?L6q44qUsJeCMdK8h6dzXZ+oGM+63ubtr4oTDjNUDUilBy5FwBgZPltWElA6b?=
 =?us-ascii?Q?I3LCJkE28fqmAdAm4MACxLVj4PmL9pad44eHbjx6u2DGsi3FGXynqMOJvbeG?=
 =?us-ascii?Q?AxIVOyyP8ugJTrswXB2RNi08Gda/8NaA2aIf4Bz0o1W9vnHjIaFUwKZGVbqE?=
 =?us-ascii?Q?ycqYK2S32z9S+Pe6fF6hiWfBB6hh1feB7um8VV7ZGYqgLMsphG2n5dhCesD5?=
 =?us-ascii?Q?Z7kZXpblSRESdYRvcA2siQ+FyjTjzMzgKBzxIWV7aOYYq46MxcYf4hd9S3o/?=
 =?us-ascii?Q?FFETYWMNZwEuDb9jpq47m+iaWrrK6d9GsB1mfoO/YHse3O1FYL9JSfP1MRjW?=
 =?us-ascii?Q?MrZXb+npwhbV0jwxETqgVoSOioxcqu6HgGKVESDqfBCRG4WiSJ+EsxwPDXFf?=
 =?us-ascii?Q?B8HksmCDoH550WdO9Ms3C8W1edseZoPNmZgK18RzsZZhtl7zczk8B5A3CGPU?=
 =?us-ascii?Q?hrkhYaNn0CXJMSP5N9SfXmykPoPGR64VwGtuQipw8YeBJKf3momcDZ7lqjFI?=
 =?us-ascii?Q?mMuOMcb4+MXEdmCHszUW5aI0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a56960a-e46b-43e4-0328-08d8f77af5eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2021 15:04:35.6118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TT3xaefBDEFCFVG381A4GAKx9czaevXrcWGg+qg4jpS8mMJyis0ok2uY2FMWeSjJvqw7nrjFR92/knXf6Y0nyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Sunday, April 4, 2021 5:18 PM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; eric.du=
mazet@gmail.com; mkubecek@suse.cz;
> f.fainelli@gmail.com; acardace@redhat.com; irusskikh@marvell.com; gustavo=
@embeddedor.com; magnus.karlsson@intel.com;
> ecree@solarflare.com; Ido Schimmel <idosch@nvidia.com>; Jiri Pirko <jiri@=
nvidia.com>; mlxsw <mlxsw@nvidia.com>
> Subject: Re: [PATCH net v2 1/2] ethtool: Add link_mode parameter capabili=
ty bit to ethtool_ops
>=20
> On Sun, Apr 04, 2021 at 11:14:32AM +0300, Danielle Ratson wrote:
> > Some drivers clear the 'ethtool_link_ksettings' struct in their
> > get_link_ksettings() callback, before populating it with actual values.
> > Such drivers will set the new 'link_mode' field to zero, resulting in
> > user space receiving wrong link mode information given that zero is a
> > valid value for the field.
>=20
> That sounds like the bug, that 0 means something, not that the structure =
is zeroed. It is good practice to zero structures about to be
> returned to user space otherwise you could leak stack information etc.
>=20
> Do we still have time to fix the KAPI, so zero means unset? Where in the =
workflow is the patch adding this feature? Is it in a released
> kernel? or -rc kernel?

First, it is not the API structure that is passed to user space. Please pay=
 attention that the link_mode field is added to "ethtool_link_ksettings" an=
d not "ethtool_link_settings", which is the API.
So I am not sure what leak could happen in that situation, could you explai=
n?

Second, the link_mode indices are uAPI, so 0 is not forbidden.

>=20
> > Fix this by introducing a new capability bit
> > ('cap_link_mode_supported') to ethtool_ops, which indicates whether the=
 driver supports 'link_mode'
> > parameter or not. Set it to true in mlxsw which is currently the only
> > driver supporting 'link_mode'.
> >
> > Another problem is that some drivers (notably tun) can report random
> > values in the 'link_mode' field. This can result in a general
> > protection fault when the field is used as an index to the
> > 'link_mode_params' array [1].
> >
> > This happens because such drivers implement their set_link_ksettings()
> > callback by simply overwriting their private copy of
> > 'ethtool_link_ksettings' struct with the one they get from the stack,
> > which is not always properly initialized.
> >
> > Fix this by making sure that the implied parameters will be derived
> > from the 'link_mode' parameter only when the 'cap_link_mode_supported' =
is set.
>=20
> So you left in place the kernel memory leak to user space? Or is there an=
 additional patch to fix tun as well?
>=20
>    Andrew

Again, not sure what is the memory leak you are talking about.=20
This patch solves the protection fault in tun driver, by the fact that now =
we are paying attention to the link_mode value only if the driver confirmed=
 it supports the link_mode and set it properly.
