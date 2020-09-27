Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA499279D15
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 02:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbgI0ALp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 20:11:45 -0400
Received: from mail-eopbgr750129.outbound.protection.outlook.com ([40.107.75.129]:22179
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbgI0ALp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 20:11:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoI+KYNTfEVde+Si/t6SfpiGgThyc0pIMQZjLUhUTMrB416Da3enwAx5Ot6qTikZ7KWhf/G5jA35Z26dZc8SgGTZItKC7M340ZmYtRJrA9ulnCVTkk8IBXG4+fm1ulAkU43ZmwZv6W8VtU26gRcGaoUG4Qp9gXkUekaFJagSpFmwoN7C78WcCdCsIwAUB5SA6sxyywl2sfBuL2FclxvcUyXSyFKkNbSAF+hqu5vq43LUWFLELEZyM3i8tv+BSsn0x0kEe6HMowLdCGCMZdRXeQpSHyQgSm6SAE8M0ZoXAA/M8mGO8dbUIWWIsWCFJmZLb1A1oJdVVnFKc3ns+E0JhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iz+DhjcQzB7+BuAIvMc+YqOnBWjU/+FS1aTZ+jsC1uk=;
 b=HIstcnTbQEm+Ap6SyNmS0Xx/LZ4Qgco0ibNHP4o49K8M323eitaG2oeAzwUknSpCJJVYI0q0ZCbGcBlvt3hnCOLcPPkESh+e22kIZ72RhrajflGIKWmd42S6fUNJ1b4sHH73SxxMtJj6BYP0kXnvEtAMTX1U3mntjXF2UVoAeFUzu60mLGhUL0U4HDq+GEtLbM1WVCHZpnfRm71rgK2ukTWmGr/Gb2eE41CUsELI2PLYFAU/Dv5M8btbjqVD3EZAsFHYGGSCursUaC+z0EnV2fURBi+fPKOoY6huowBDR3fNp7WEpGHtFwUta24XqUkQxTNQ6RIpkz46eMV8OEnKUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iz+DhjcQzB7+BuAIvMc+YqOnBWjU/+FS1aTZ+jsC1uk=;
 b=HM2SHl8u1ikjYM8zBiQGyHwcpr/3R++rF8+9reUIKGioueEoiNizpZPKaUAeemlvHx6Hr/nblnhrXz7IDmT5fbOddckkf5DY6+3Dsanr1izd+GyMYt/yGbUIfaEm5WKkWC8w+x1fYSV9Va6u9tIsjv8eiRnI62p7yzhNKvmbh/c=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0892.namprd21.prod.outlook.com (2603:10b6:302:10::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.7; Sun, 27 Sep
 2020 00:11:40 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.028; Sun, 27 Sep 2020
 00:11:40 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "will@kernel.org" <will@kernel.org>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Mark.Rutland@arm.com" <Mark.Rutland@arm.com>,
        "maz@kernel.org" <maz@kernel.org>, Jiri Kosina <jkosina@suse.cz>
Subject: RE: [PATCH v4 09/11] HID: hyperv: Use VMBUS_RING_SIZE() for
 ringbuffer sizes
Thread-Topic: [PATCH v4 09/11] HID: hyperv: Use VMBUS_RING_SIZE() for
 ringbuffer sizes
Thread-Index: AQHWi9xgnCO/KUGnGUuiAQJ8m8OOY6l7rZYQ
Date:   Sun, 27 Sep 2020 00:11:40 +0000
Message-ID: <MW2PR2101MB10522AE6C10071E709655BFFD7340@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200916034817.30282-1-boqun.feng@gmail.com>
 <20200916034817.30282-10-boqun.feng@gmail.com>
In-Reply-To: <20200916034817.30282-10-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-27T00:11:38Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cc66c1e9-281d-4e17-86bf-1aaa276dfafa;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8ead55c5-86dc-42e4-23f5-08d86279e894
x-ms-traffictypediagnostic: MW2PR2101MB0892:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB089296E227945866DE754667D7340@MW2PR2101MB0892.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kUNcTHxKJeypfE1lGz0r6he0ivacPn851bwfoyiP+mcfrnLuDHhLJwQtVr1ZCYecIhEqYkZwCqVnB0YEpO+p805enx7YlwzPcTJDFkyp786AvPUs4cUNqLumdfNWmYcBE2q7gqy6+VO2Ob+wnynXPDhhqCZrjawEKeulxZrVkeF3DXZBo6VeLKlw/CVSNQxRk2/sEoVvbKbmhJF8QfkE9/YMvkL3rmgwdB6QT8FWmHQkAn+jTn5oX9s079dovyVkoO3GnUahn07s9n2jzCma+buVVUeFm/PBGaihdVFXQQksKPJtJDgrC0tPtkTtHokMF/AFuWfEf1qe0lyhcID+x4GDRuDq3GIogtRA4BKx2InBhTlvbAK+ixcrvJrXOYjTj4LuQAX9ZA8djKlO4sLZsQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(5660300002)(316002)(4326008)(66446008)(52536014)(86362001)(64756008)(83080400001)(66476007)(66946007)(71200400001)(76116006)(82960400001)(83380400001)(66556008)(33656002)(966005)(8676002)(54906003)(82950400001)(186003)(7416002)(110136005)(7696005)(6506007)(8936002)(478600001)(26005)(10290500003)(2906002)(55016002)(9686003)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: aP5AhIwB1hWAqMIc0j13Z8Pci1FpWmJ1TjGeXKnfO/CvDhbML/xP+WdokK2h1IGCTRAAOaCh6lqQtRw6lb2dqaYuGQvUnLFzmBU8tj974s46Z1/RhaPH6Iscl14hRhTvtKQlkzvFtzRTCfO69YFZwX8osDtaCY/dwW9sNLb3+qTdNlOWc3ig9kNXk0V9ampeSf/7kOsj98gMbHiP6IcSioKnN/v/MaDC1xNcvUxEOkbYAvZ1S1JrlNMuUFkOTYdua282zdo3jU7y9QyOSPzhH5TZf4Wa76q/SpNfxIXUNcikfFoveAsnITc7fMXolkHXuKF+KG0vSETOsmoBqaKWT6C+q7pee0iMC5ub5jUnj95qtclTRzGIWxdpCtO78s83VGkyrknat0/p8uJy6sEYJE4F0C8EWCBJ0tXxhXetHRqCb1zclEqbbXdXYqSkGGgBVQs1WxWksQYc1TkINEHqVq7pIH8gv4pIeNKnnft44Szbb+g76Pxu1OeQXefUdyiSKeC8H4pDgVCd8kTncQrFphAu0CRBpXQN7eCzmBlrjqGq6633F3zBN6Eh5ToeEOCjbMk32gEifaHgVVUlIEetKdP9tONlPcEACjFsnwjM1FtdaAMTI6/zlPZoKUbhgBSWIWpBtrvS0XfjLvSiDty2Fg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ead55c5-86dc-42e4-23f5-08d86279e894
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2020 00:11:40.4763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RPnjPzAF9NLTK4yjxKOeIM7eSeL72upbzznKrxC4diVh5FGEVmFAwE0TTZMXYrMJ4uNdIQOCkZ63eZHJ0fISbeaKjJ/FL5NwHXv3EVC0Otw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0892
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Tuesday, September 15, 2020 8=
:48 PM
>=20
> For a Hyper-V vmbus, the size of the ringbuffer has two requirements:
>=20
> 1)	it has to take one PAGE_SIZE for the header
>=20
> 2)	it has to be PAGE_SIZE aligned so that double-mapping can work
>=20
> VMBUS_RING_SIZE() could calculate a correct ringbuffer size which
> fulfills both requirements, therefore use it to make sure vmbus work
> when PAGE_SIZE !=3D HV_HYP_PAGE_SIZE (4K).
>=20
> Note that since the argument for VMBUS_RING_SIZE() is the size of
> payload (data part), so it will be minus 4k (the size of header when
> PAGE_SIZE =3D 4k) than the original value to keep the ringbuffer total
> size unchanged when PAGE_SIZE =3D 4k.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: Michael Kelley <mikelley@microsoft.com>
> ---
> Michael and Jiri,
>=20
> I change the code because of a problem I found:
>=20
> 	https://lore.kernel.org/lkml/20200914084600.GA45838@debian-boqun.qqnc3lr=
jykvubdpftowmye0fmh.lx.internal.cloudapp.net/
>=20
> , so I drop your Reviewed-by or Acked-by tag. If the update version
> looks good to you, may I add your tag again? Thanks in advance, and
> apologies for the inconvenience.
>=20
> Regards,
> Boqun
>=20
>  drivers/hid/hid-hyperv.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
> index 0b6ee1dee625..978ee2aab2d4 100644
> --- a/drivers/hid/hid-hyperv.c
> +++ b/drivers/hid/hid-hyperv.c
> @@ -104,8 +104,8 @@ struct synthhid_input_report {
>=20
>  #pragma pack(pop)
>=20
> -#define INPUTVSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
> -#define INPUTVSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
> +#define INPUTVSC_SEND_RING_BUFFER_SIZE	VMBUS_RING_SIZE(36 * 1024)
> +#define INPUTVSC_RECV_RING_BUFFER_SIZE	VMBUS_RING_SIZE(36 * 1024)
>=20
>=20
>  enum pipe_prot_msg_type {
> --
> 2.28.0

Reviewed-by:  Michael Kelley <mikelley@microsoft.com>

