Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1472643C214
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 07:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239323AbhJ0FUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 01:20:20 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:12160 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238090AbhJ0FUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 01:20:20 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19QMO3KR012599;
        Tue, 26 Oct 2021 22:17:47 -0700
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bx4dx6eau-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 22:17:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cpb6j0e7+Lit5fyOHDkWF9DzLHPN6WFsGA6FTjnk3Frq5I3sGpMiUzMLtUizmJP/tD76etVDW223jXDVv90gTstUxL90PS3Wa2Tpk0+kU9gtGn01mGyv5D2Q1RlTzbS7UgCh+vZ4xoNgw5F6ERafgV0lkMUmhNX00d3fse+vgZHJT7vtk6W8ocCwC/LgjzxLoafyW1RNhfmbgK7fuWTs1W0EZ3OXF1nD7Q/uYCQjDujICzlUsdPd3DDAG1ZBeLcVlVT8dxGokA4Hm5PHtfuKg1hSaNm2RRMtoq4nVyJZkd0WQ5e7go9M79BNEgQp+BqU10zQ27th1XUL1IDRNZ42nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gapa5X+c6rST52cX6B8LwOpAV/zKqyTRKP+mVm91Ue0=;
 b=eO85KHjRy5jDxCppYvhi1K309s6LzqiipByv9lNy28OH+MICs2zC3tBQiSVEQ/I0Sr3Qut0Ly4776Wwie2VvWsU+HCn4+rf3PTLkh9fpTzta2ig+wj0FN915+w4IR+Mp4ZP64UJ0ZiiQ6BOSpZAXXFYbYTklybKI0994cbuPJ77Bw7mVkIznaAV8jP8uoQFxMB0J5cRB0IBrvRu68m0P0drsytJBMDp7l25vrKASamrrw/iWJ/ukg8ygEhrvENk8FcEzKUsm55HpDAEd+9ixhZH6VyUO1vUNwZfC/1rLQJzMJBlkpoaEv4EREmP7/VTA7Eh4qPA+xQnp6SvQynGDcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gapa5X+c6rST52cX6B8LwOpAV/zKqyTRKP+mVm91Ue0=;
 b=ekvJNBT4JP7+Cngx3l9lHxnTJUny1Wt1faIcVqC1F9GK6CnEZGSaDN2y840sp63c9heIw5/ju/eFvAAR7Sl/Z1wpcaPEoGz1NUroDywc1zsMXT9mVALF309k94xReQQ88A4ahN0mjGoRFQ6CwjgMY1LJc8oUy6tubKP1KQJRK1Q=
Received: from PH0PR18MB4655.namprd18.prod.outlook.com (2603:10b6:510:c6::17)
 by PH0PR18MB4718.namprd18.prod.outlook.com (2603:10b6:510:cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 05:17:44 +0000
Received: from PH0PR18MB4655.namprd18.prod.outlook.com
 ([fe80::18a1:f96:a309:3bfb]) by PH0PR18MB4655.namprd18.prod.outlook.com
 ([fe80::18a1:f96:a309:3bfb%5]) with mapi id 15.20.4628.023; Wed, 27 Oct 2021
 05:17:44 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Manish Chopra <manishc@marvell.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Thread-Topic: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
Thread-Index: AQHXyqEA7jl+kkKwVE2k6p2laLQP2KvlxdmAgACEIOA=
Date:   Wed, 27 Oct 2021 05:17:43 +0000
Message-ID: <PH0PR18MB465598CDD29377C300C3184CC4859@PH0PR18MB4655.namprd18.prod.outlook.com>
References: <20211026193717.2657-1-manishc@marvell.com>
 <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211026140759.77dd8818@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 575fd966-66f0-4bb8-b5b8-08d999091b37
x-ms-traffictypediagnostic: PH0PR18MB4718:
x-microsoft-antispam-prvs: <PH0PR18MB471846FF79FA3422ABDEBD93C4859@PH0PR18MB4718.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eGUDr8ZwdxqNTez7NoDGJIAduAFyJhhkwZKzZ+qS9Lcw1zEKaBJp25qlIQ8laKQhIE19mQ1m0MygccrkzjoByIWzoqE02/WYmgA4FaETNWjBVfTDyGGiu3ORAjkCHWpvC0S30fFiSzkEIZDu/38fqgiuWCWnrl7amIvAjmVT8sXm+cmVug+sOo7IoCuD/rAOS3CQ0HpJZbEMmHmQ8oznK7kerT9RYg12XzNoFKzAW0IBvXg49A6zU5f4L1mkDZajWF43JT5bjmeMc9zaJZ+ROtc4Tj5MoCgGYjYA9avSyBbqswR0ceR10BYPfDlZ4U5zEldWv1ToJ/q1NZ1LZvtFbBKbCw+D92L3tdBbw81xLjyMSO0jDbWHNYOMZQ/cker0ZlBLsyC0/Z1DIr8jqXnom4BrhZAbV1MjYclTWO62NbefGrFGc9Y4NyDehktLLE4ibvsAtJnahPhJPjFKs3ou5Jm+IEcXzOXTiTjvnH4euFQRzTb0jKb0l+OuNZAZfWDrs2M3KjSAJMrBJ2uu0T53qnmF/YcVqrysm15srTR0DnC/zZ7ti/5AZDdz/RQ2ij5AYEUvV1qhwy4qExIemhgWAX8/esF3NQM9pSFEdt7YZ3iJa/ZDGDBmTWrcHcV2uWqa4KAO7sB4F+ZQKuJ0UW4r9el59me+FOZpBWIUSeu1Kja9cNlQQiphnyPRO9AVC/8TK7rGY8Yiyfd3zpUCpa0ROA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4655.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(110136005)(8676002)(54906003)(7696005)(86362001)(64756008)(66446008)(83380400001)(66946007)(508600001)(53546011)(6506007)(71200400001)(26005)(186003)(52536014)(33656002)(66556008)(66476007)(4326008)(5660300002)(38070700005)(122000001)(38100700002)(316002)(8936002)(9686003)(76116006)(55016002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5zlcF4++Wd1SdfS4r1S3/TaEr66XJItPzWvEftVsu95Wqq+hS+OYDrE+2mp/?=
 =?us-ascii?Q?4+uIe3V0nmLUqyLOsiEr3dgYlIDnqmmErUMQ+wRn/SH/vmwMjoiv06GsjVvX?=
 =?us-ascii?Q?okMJmYinE7LnvggRmNK+gzPlvOAkAwKThumMrC0v58B15rvSCNieJBCMIF0G?=
 =?us-ascii?Q?sjcu6RC88RJ5K4hza7d0Vgu9m9IV9KJklboYXaYOZnDbUuceRlImvuvwdgBm?=
 =?us-ascii?Q?7B3iIN+q9biM9dG5TBc6+HoWZVrYP/Ct6U6ySZHwJ2dTQgdRPkwVXb0VNzS7?=
 =?us-ascii?Q?XCFVvrPnjhlF2MOdnBLPBYvY9MjJwm4fk75hpVg1979pMfmXM/mhLnyO78nH?=
 =?us-ascii?Q?RjjlqSky9wW759oTKwRMYAwQHffkBCW+ZOtsoN2/E4gsA4KxTEtMuvJ2itb9?=
 =?us-ascii?Q?pGB+nIMrRlIXTOWwVpXFQAOCmU0W67UqIbRIaXHaUQTJI7dQTtIYQf6zvTsO?=
 =?us-ascii?Q?18rDDK2jnpyiNKw72fHkiZls805n/mPsQHbj9ucw11PFNNZ1UmlmPcyAdVn4?=
 =?us-ascii?Q?3OqGBiIHZZoPuG1asetQqaepkOGRWLhGYJzsGF1PimdkDcln674F7xahYoSq?=
 =?us-ascii?Q?Od6kMFckVIYqWtKKvfXNWwC6vICToia2bwqBFsvY8bcd6GFpiEZ0Ay/Kk/zL?=
 =?us-ascii?Q?Tmqzx/Sb99k/EjrvHmLJRHYjlsEkQGH8RO/oJ1fSnmmxX7iZn6UJVpzZGSch?=
 =?us-ascii?Q?5ouSFn/m1RDe88UxMcmagQusinxnQiG/EcUo55kJaK41AWQYVG/ei57IR6ET?=
 =?us-ascii?Q?97u+4KWjqicoTZLg1mrnkluy/685x/8rHUGKSDlprvT+XrMdZS7wIO9vFn1w?=
 =?us-ascii?Q?6F3bKnGhwN9faz6SYkwhu7PJnYqgyx5yilompa/+ozyswVtiryOphWtWhyyD?=
 =?us-ascii?Q?9yqApPjmMaqs3KOwQPYJjo5VXslMlqguWwLDpw9uGWGkVmLjmNfVExcvw2x6?=
 =?us-ascii?Q?59ekk5lQe4TLnmKYU5IJxJX5/CLU+OKs0PnlUHY7i/s7a19AHEkCc9+5S1fh?=
 =?us-ascii?Q?2y/OL1xqO828PLMzpCxAL1RYE0M1UQQSgjvIPrGn3/RT58vCCBuEKaMg1W8u?=
 =?us-ascii?Q?Hfv/bZPx6w64p97cOlMziYsHyAbPfn6e/G89Na/FTwMP6hkGwEVBBDGjWlUG?=
 =?us-ascii?Q?QQp2v7yoQ9i+/GuGUEksPio2cshWV/W/ovuAMA8DcAnH0X+DPWA/NOMYm/Pj?=
 =?us-ascii?Q?T3gijfDS3XZORn7DBdy/ihy5idRj2j0yShLa5Xwuavn67oegpjFzqMb0IWCB?=
 =?us-ascii?Q?U2HZdpCF12eOIPuBkr0F2HTe9HVmb1huGKJIzorQSb7SXdVQUSvvseV+Co0v?=
 =?us-ascii?Q?+kTTuyHhc8F/3FTvFC3Ph64a8jMcCfxSwJy8VhbgEq7oxcjsYcuUV+gP5KET?=
 =?us-ascii?Q?3ocR+ux8B+zlSR4d/kmODKXOcxQF6w0meVc31a2zX1Od5DA6jJiccSxQcqGl?=
 =?us-ascii?Q?jqAgx5VH3RDdTrRUJS4DhJNhyr5u3RVf5t7+3c17OX4lFfUQh6khCfdV3GOk?=
 =?us-ascii?Q?fCJqIA9njH5Uh0rD0oz1Mt8XoMoiTSaxX72QaiM2Au7LnTsDoMWQAU4p2Oco?=
 =?us-ascii?Q?9APqMv0SlQSA8TE1/x/TBNcvfkESh41Mto8eyfUoqmeTlk6zjS5isxtqXQIQ?=
 =?us-ascii?Q?d3zSi4hbvKgoisDrhEGX278=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4655.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 575fd966-66f0-4bb8-b5b8-08d999091b37
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 05:17:43.7956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YFhP0GjCiEYYv+Q7dqSwgKp3xOTAwfjkG1rooJsseH3bhRTqv110ZIpVAb5ubF1dY5rzmAZQYHUPJ4jaZ+38Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4718
X-Proofpoint-GUID: -twyq-HZowifKyHwarw3hcAV2Bq9r_KQ
X-Proofpoint-ORIG-GUID: -twyq-HZowifKyHwarw3hcAV2Bq9r_KQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_01,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, October 27, 2021 12:08 AM
> To: Manish Chopra <manishc@marvell.com>; Greg KH
> <gregkh@linuxfoundation.org>
> Cc: netdev@vger.kernel.org; stable@vger.kernel.org; Ariel Elior
> <aelior@marvell.com>; Sudarsana Reddy Kalluru <skalluru@marvell.com>;
> malin1024@gmail.com; Shai Malin <smalin@marvell.com>; Omkar Kulkarni
> <okulkarni@marvell.com>; Nilesh Javali <njavali@marvell.com>; GR-everest-
> linux-l2@marvell.com; Andrew Lunn <andrew@lunn.ch>
> Subject: [EXT] Re: [PATCH net-next 1/2] bnx2x: Utilize firmware 7.13.20.0
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, 26 Oct 2021 12:37:16 -0700 Manish Chopra wrote:
> > Commit 0050dcf3e848 ("bnx2x: Add FW 7.13.20.0") added a new .bin
> > firmware file to linux-firmware.git tree. This new firmware addresses
> > few important issues and enhancements as mentioned below -
> >
> > - Support direct invalidation of FP HSI Ver per function ID, required f=
or
> >   invalidating FP HSI Ver prior to each VF start, as there is no VF
> > start
> > - BRB hardware block parity error detection support for the driver
> > - Fix the FCOE underrun flow
> > - Fix PSOD during FCoE BFS over the NIC ports after preboot driver
> >
> > This patch incorporates this new firmware 7.13.20.0 in bnx2x driver.
>=20
> How is this expected to work? Your drivers seems to select a very specifi=
c FW
> version:
>=20
> 	/* Check FW version */
> 	offset =3D be32_to_cpu(fw_hdr->fw_version.offset);
> 	fw_ver =3D firmware->data + offset;
> 	if ((fw_ver[0] !=3D BCM_5710_FW_MAJOR_VERSION) ||
> 	    (fw_ver[1] !=3D BCM_5710_FW_MINOR_VERSION) ||
> 	    (fw_ver[2] !=3D BCM_5710_FW_REVISION_VERSION) ||
> 	    (fw_ver[3] !=3D BCM_5710_FW_ENGINEERING_VERSION)) {
> 		BNX2X_ERR("Bad FW version:%d.%d.%d.%d. Should be
> %d.%d.%d.%d\n",
> 		       fw_ver[0], fw_ver[1], fw_ver[2], fw_ver[3],
> 		       BCM_5710_FW_MAJOR_VERSION,
> 		       BCM_5710_FW_MINOR_VERSION,
> 		       BCM_5710_FW_REVISION_VERSION,
> 		       BCM_5710_FW_ENGINEERING_VERSION);
> 		return -EINVAL;
> 	}
>=20
> so this change has a dependency on user updating their /lib/firmware.
>=20
> Is it really okay to break the systems for people who do not have that FW
> version with a stable backport?
>=20
> Greg, do you have general guidance for this or is it subsystem by subsyst=
em?
Hi Jacub,
You may recall we had a discussion on this during our last FW upgrade too.
Please note this is not FW which resides in flash, which may or may not be
updated during the life cycle of a specific board deployment, but rather an
initialization sequence recipe which happens to contain FW content (as well=
 as
many other register and memory initializations) which is activated when dri=
ver
loads. We do have Flash based FW as well, with which we are fully backwards=
 and
forwards compatible. There is no method to build the init sequence in a
backwards compatible mode for these devices - it would basically mean
duplicating most of the device interaction logic (control plane and data pl=
ane).
To support these products we need to be able to update this from time to ti=
me.
Please note these devices are EOLing, and therefore this may well be the la=
st
update to this FW. The only theoretical way we can think of getting around =
this
if we had to is adding the entire thing as a huge header file and have the
driver compile with it. This would detach the dependency on the FW file bei=
ng
present on disk, but has big disadvantages of making the compiled driver hu=
ge,
and bloating the kernel with redundant headers filled with what is essentia=
lly a
binary blob. We do make sure to add the FW files to the FW sub tree in adva=
nce
of modifying the drivers to use them.
