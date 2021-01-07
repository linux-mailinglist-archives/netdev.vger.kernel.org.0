Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1D262ED6C7
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 19:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbhAGSh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 13:37:26 -0500
Received: from mail-mw2nam10on2135.outbound.protection.outlook.com ([40.107.94.135]:60832
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726064AbhAGShZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 13:37:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qky0VuzRdjDge1TBgBq1g5/vPn1hcbgTVCC3Q8CYoMyPqUvC+EJYu4lo6CgwpaBAnb+U4UOEVWKx8LL0ZkWn1L7num9T/UpaEYIFLab6S2GkAjo2jWuOhNl/qHQcggyCAUsbyyywfbeuLu+z4jYCI9LXQVqk7ai6ysdvS48FhCQijgOzsFzG2Ke+Wzx51J/F+xoVsGJE8y1NdArW6dOrE4mjoPp5avDsSMfg/FKA5oX2j/G+5+G3sog8ONkZY4TQcf9rMRRKMDHQYzCynUKJ6BepuG78M9lQ00wiQuroFaIfhl9bfuITUu5qdVBq4SU34piC1BlJFDEzqD61WpFdUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQcmf2etB90l7tAF9UpDoVERXCRqm1WHuXzct35MxWw=;
 b=gebshhnmn2QP1772v/An5U4Dmzzgy2c9bgoLGn0PUdVtaNe/QfDY2lX7aAO3Lu1L49KQoc4nQT8F7Q8bzImXONGig3i0sNZbwVDUqwLdyrfS/5zTRnXfFGAvKs/l5BltbYptWttWqipBtKBxbiW8qcbCt4dgRfIGhrrMQeKggnEt1llThOCYhRO+Krg6KAaGF08jPXPrI0smdG12oXs67X8a+aroDZ57fxCTABAATC6aZKUPvQCqivy9BxkJLPdG4gTu0nSYm9L1QGGySZ3uh2o2hzhHc0FDGLO+dwh+7gNMwTWPOnB4ijZCQpeRg44emrAOnz5hrKbgAW5tgSTu4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQcmf2etB90l7tAF9UpDoVERXCRqm1WHuXzct35MxWw=;
 b=hcTh1QNIWE3+6vBHHed4TJhFCR91ZSM6+s1/Eoc4ykBoMuFViwrDTzfUNbhrN53kFGY4EpEI94GDxmjdiPgBOQPkMtQ4QK8VBZoShQ91fRcjlUSHrtpHMGa1Y2Io8xaYuKy4IW9GlPjmWpdtGZ1gzF+9uLnm8sLzl2GVxg+0g2c=
Received: from (2603:10b6:408:73::10) by
 BN6PR21MB0772.namprd21.prod.outlook.com (2603:10b6:404:9e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.2; Thu, 7 Jan 2021 18:36:37 +0000
Received: from BN8PR21MB1155.namprd21.prod.outlook.com
 ([fe80::e535:7045:e1e2:5e23]) by BN8PR21MB1155.namprd21.prod.outlook.com
 ([fe80::e535:7045:e1e2:5e23%8]) with mapi id 15.20.3763.004; Thu, 7 Jan 2021
 18:36:37 +0000
From:   Long Li <longli@microsoft.com>
To:     kernel test robot <lkp@intel.com>,
        Long Li <longli@linuxonhyperv.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 2/3] hv_netvsc: Wait for completion on request
 NVSP_MSG4_TYPE_SWITCH_DATA_PATH
Thread-Topic: [PATCH 2/3] hv_netvsc: Wait for completion on request
 NVSP_MSG4_TYPE_SWITCH_DATA_PATH
Thread-Index: AQHW48mSn3A3+34fsUybSMcLXFW+XaoaAHAAgAFGYHCAATmEYA==
Date:   Thu, 7 Jan 2021 18:36:37 +0000
Message-ID: <BN8PR21MB11553F84E846C4B5EFC72C14CEAF9@BN8PR21MB1155.namprd21.prod.outlook.com>
References: <1609895753-30445-2-git-send-email-longli@linuxonhyperv.com>
 <202101061221.LKsEcWmp-lkp@intel.com>
 <BN8PR21MB11558420E44B211793B308F9CED09@BN8PR21MB1155.namprd21.prod.outlook.com>
In-Reply-To: <BN8PR21MB11558420E44B211793B308F9CED09@BN8PR21MB1155.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b54563ee-dea4-4a98-9576-fbf00dc118a4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-01-06T23:53:55Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [67.168.111.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8c183569-9474-4127-b1cc-08d8b33b2a9f
x-ms-traffictypediagnostic: BN6PR21MB0772:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR21MB07726AF070A1AE183B2A20ADCEAF9@BN6PR21MB0772.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:800;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QvpyFWin094USl5yxPP5hHSg6ua84kYSsQdIsUcI6Yhq0RoAJSnym0GomMVKsUjRFR/EdlEE8/+yFG3Blh+l6QprRIyUCm4aqmVo7rwEsKLxxGhW1MiCRjdZQ5BC28Vj1ORZO1zJj0Wa7FFlc5/lbASGDkJvRrAYN3S0bzlF/WsCISFZwJ47FQ7vAOXAwYUV5Lh0HEJ/+gsLJV6O9b3vl3401fI/XnbeqgLTRPlw/+83YLw62oi7j/8+tg8jcWpfud3/zjxSSOgDICrsp//RkOqTpcTWbGr/nGVIlMvyfZENzLPhgNV/iU2whm4bwV/Y0GSFU4OPgFCjzmDv3awCnwuWz/fU074R+8Pr/kQkAA8fPh/5SQUI2hqFw5tSYnbIxxZOzDjiSB4qSq4nJlzf2zgh7ntqClhvdSxl8jewFBvvyrDbaRMmc/Ai+mZGfaXrLDJvIVh8rnKkW9RP/5VR13Squ9qfe9AT8XRQmOpPTdMHz2OcHairCcVz5pZMS0hcC1uuRykH8NcZ1/v5hIsovg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1155.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(66446008)(186003)(26005)(966005)(76116006)(6506007)(66556008)(478600001)(8990500004)(9686003)(8936002)(4326008)(5660300002)(64756008)(316002)(83380400001)(71200400001)(66476007)(55016002)(86362001)(33656002)(8676002)(921005)(110136005)(10290500003)(66946007)(2906002)(82960400001)(82950400001)(52536014)(54906003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?8Jx6ph4iF6Vzy7RgbSvqig4ksX3IvE0xAlSAQ+6SyYTyJpOqjJeVKfm1VHp5?=
 =?us-ascii?Q?DJ3ClgJbCZExJW65mNBp795Ux0o4fpx13gCraE25Y8jESbDIa0QSsggdjIaq?=
 =?us-ascii?Q?UwqSGxlb+ZANe/zTpMaifZjmt+6xdOSFkf0ikxCWMpJw6K8g4Mcv4p0M5iCW?=
 =?us-ascii?Q?kJZ32iQyTGc5lIPAAPHLTY+YpD9MIHOoMzFX+cLgJu1DRg2pxSbwtqGdGqyM?=
 =?us-ascii?Q?5Bt2jN5wkcikQ/lqpb5+M1kBHpR2fKFJzEcPwP7J+MlmfQyMGg9Lh2xssCjz?=
 =?us-ascii?Q?k/ryjoHAti3hPpP2aK73UrGFYw+XYHoGDgBf+GHwdVZD0BbLUvkDDIRw5Vcp?=
 =?us-ascii?Q?Jll1UWg2vIYbQZmPIrDWWA2v+T8JDlkdHDqkoGlOYyInbqrqUxUIHfeSOfu2?=
 =?us-ascii?Q?DBUmXYfawRNO+tp3ZqNb+mPKcFvUQSjvgG1/aYwlhwBP7xeRuLNXf8+bJ5z2?=
 =?us-ascii?Q?scIveQBCX7nKnOkDCqWvJszhOaLB2l4aECSo2oe3BQNNN1QlUebm3Ns9Q9DD?=
 =?us-ascii?Q?XqI9Ro0rxEQ7CdN+xwH2BNF6OyBSYpHyhyThQ0X6tRN3IfZmfDZdP+L4t8W/?=
 =?us-ascii?Q?+AlFuJA84n0YIUZZnAf1u0+KGWZxbEBnwBA4TJudcteVOyGWpe4P37mmgEFr?=
 =?us-ascii?Q?bGb84Nxvavh7Hy5gHlR4SEEhqUczhJ9Oevcdp2GdOrXAryvdTJ9BsXK4VJ1Z?=
 =?us-ascii?Q?9gAiccsY3FNsZreQK63y5ndXLxUXjJvhA6yseLx3BHTJjhylMO+bSiSiS0WL?=
 =?us-ascii?Q?RB85DwJkuNI84WnCMUBHOsz3eJKJOr/Gm60DcHhDXCMhOyq4AJV4OMvCajSY?=
 =?us-ascii?Q?ERV9QbzNmbS1Iy+V7BApcRsv0JnxJh051D7LFcaYCgNx+bTDi/OH7MJsv08T?=
 =?us-ascii?Q?OlCtQ7kil4awjJ0U6T07n8Qw5tRUO3u9/tWqn2GVzmrLlL1UYeTPUi8WEpky?=
 =?us-ascii?Q?a3j03A74deOscAnBezp+Y3AiVIWV3p7fGle0gwpTaMQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1155.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c183569-9474-4127-b1cc-08d8b33b2a9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2021 18:36:37.1017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uKRG9MkpxMT2bKobpJ+aUd1AmkNoKL/XVNennSYznlad+ZWgz8dhBdX4Hzm6iGfG9MCJ9xtitAdchqp4SCBYGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0772
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: RE: [PATCH 2/3] hv_netvsc: Wait for completion on request
> NVSP_MSG4_TYPE_SWITCH_DATA_PATH
>=20
> > Subject: Re: [PATCH 2/3] hv_netvsc: Wait for completion on request
> > NVSP_MSG4_TYPE_SWITCH_DATA_PATH
> >
> > Hi Long,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on linus/master] [also build test WARNING on
> > v5.11-rc2 next-20210104] [If your patch is applied to the wrong git
> > tree, kindly drop us a note.
> > And when submitting patch, we suggest to use '--base' as documented in
> >
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit-
> > scm.com%2Fdocs%2Fgit-format-
> >
> patch&amp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3d454eb468
> >
> b85fb08d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C6
> >
> 37455042608743102%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMD
> >
> AiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3D
> >
> 90AgH9HlZumRZ4UNC4uD2WIRpZ6ZEnvIdOKOfzYcXpI%3D&amp;reserved=3D0]
> >
> > url:
> >
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgith
> > ub.com%2F0day-ci%2Flinux%2Fcommits%2FLong-Li%2Fhv_netvsc-Check-
> VF-
> > datapath-when-sending-traffic-to-VF%2F20210106-
> >
> 092237&amp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3d454eb46
> >
> 8b85fb08d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C
> >
> 637455042608753098%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwM
> >
> DAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata
> >
> =3DvtVJ8pXIOxIYeKdaqT9pD1%2BEuOM3wz4yqsHh8uWsGP4%3D&amp;reserv
> > ed=3D0
> > base:
> > https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit=
.
> > k
> ernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git&
> >
> amp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3d454eb468b85fb0
> >
> 8d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C6374550
> >
> 42608753098%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQ
> >
> IjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DFXMG
> > CFODFoq3KLklxr17iVHiq%2FWmJ3c0fM7vIZRfNmc%3D&amp;reserved=3D0
> > e71ba9452f0b5b2e8dc8aa5445198cd9214a6a62
> > config: i386-allyesconfig (attached as .config)
> > compiler: gcc-9 (Debian 9.3.0-15) 9.3.0 reproduce (this is a W=3D1
> > build):
> >         #
> >
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgith
> > ub.com%2F0day-
> >
> ci%2Flinux%2Fcommit%2F8c92b5574da1b0c2aee3eab7da2c4dad8d92572c&a
> >
> mp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3d454eb468b85fb08
> >
> d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63745504
> >
> 2608753098%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIj
> >
> oiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DMMXkQ
> > KENGpyfW0NJs2khBSKTuBExFSZaWHgWyyIj6UU%3D&amp;reserved=3D0
> >         git remote add linux-review
> >
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgith
> > ub.com%2F0day-
> >
> ci%2Flinux&amp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3d454e
> >
> b468b85fb08d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0
> > %7C637455042608753098%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wL
> jA
> >
> wMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;s
> >
> data=3Duge6PX2NyAe%2BjRtvgOhR5xzN2ltBctZXeZwn0hoYco0%3D&amp;reser
> > ved=3D0
> >         git fetch --no-tags linux-review
> > Long-Li/hv_netvsc-Check-VF-datapath-
> > when-sending-traffic-to-VF/20210106-092237
> >         git checkout 8c92b5574da1b0c2aee3eab7da2c4dad8d92572c
> >         # save the attached .config to linux build tree
> >         make W=3D1 ARCH=3Di386
> >
> > If you fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot <lkp@intel.com>
> >
> > All warnings (new ones prefixed by >>):
> >
> >    drivers/net/hyperv/netvsc.c: In function 'netvsc_send_completion':
> > >> drivers/net/hyperv/netvsc.c:778:14: warning: cast to pointer from
> > >> integer of different size [-Wint-to-pointer-cast]
> >      778 |   pkt_rqst =3D (struct nvsp_message *)cmd_rqst;
> >          |              ^
>=20
> I think this warning can be safely ignored.
>=20
> When sending packets over vmbus, the address is passed as u64 and stored
> internally as u64 in vmbus_next_request_id(). Passing a 32 bit address wi=
ll
> not lose any data. Later the address is retrieved from vmbus_request_addr=
()
> as a u64. Again, it will not lose data when casting to a 32 bit address.
>=20
> This method of storing and retrieving addresses are used throughout other
> hyper-v drivers. If we want to not to trigger this warning, I suggest mak=
ing a
> patch to convert all those usages in all hyper-v drivers.
>=20
> Thanks,
> Long

Please discard this patch. I'm sending v2 to fix the warnings.

>=20
> >
> >
> > vim +778 drivers/net/hyperv/netvsc.c
> >
> >    757
> >    758	static void netvsc_send_completion(struct net_device *ndev,
> >    759					   struct netvsc_device *net_device,
> >    760					   struct vmbus_channel
> > *incoming_channel,
> >    761					   const struct vmpacket_descriptor
> > *desc,
> >    762					   int budget)
> >    763	{
> >    764		const struct nvsp_message *nvsp_packet =3D
> > hv_pkt_data(desc);
> >    765		u32 msglen =3D hv_pkt_datalen(desc);
> >    766		struct nvsp_message *pkt_rqst;
> >    767		u64 cmd_rqst;
> >    768
> >    769		/* First check if this is a VMBUS completion without data
> > payload */
> >    770		if (!msglen) {
> >    771			cmd_rqst =3D
> > vmbus_request_addr(&incoming_channel->requestor,
> >    772						      (u64)desc->trans_id);
> >    773			if (cmd_rqst =3D=3D VMBUS_RQST_ERROR) {
> >    774				netdev_err(ndev, "Invalid transaction id\n");
> >    775				return;
> >    776			}
> >    777
> >  > 778			pkt_rqst =3D (struct nvsp_message *)cmd_rqst;
> >    779			switch (pkt_rqst->hdr.msg_type) {
> >    780			case NVSP_MSG4_TYPE_SWITCH_DATA_PATH:
> >    781				complete(&net_device->channel_init_wait);
> >    782				break;
> >    783
> >    784			default:
> >    785				netdev_err(ndev, "Unexpected VMBUS
> > completion!!\n");
> >    786			}
> >    787			return;
> >    788		}
> >    789
> >    790		/* Ensure packet is big enough to read header fields */
> >    791		if (msglen < sizeof(struct nvsp_message_header)) {
> >    792			netdev_err(ndev, "nvsp_message length too
> > small: %u\n", msglen);
> >    793			return;
> >    794		}
> >    795
> >    796		switch (nvsp_packet->hdr.msg_type) {
> >    797		case NVSP_MSG_TYPE_INIT_COMPLETE:
> >    798			if (msglen < sizeof(struct nvsp_message_header) +
> >    799					sizeof(struct
> > nvsp_message_init_complete)) {
> >    800				netdev_err(ndev, "nvsp_msg length too
> > small: %u\n",
> >    801					   msglen);
> >    802				return;
> >    803			}
> >    804			fallthrough;
> >    805
> >    806		case NVSP_MSG1_TYPE_SEND_RECV_BUF_COMPLETE:
> >    807			if (msglen < sizeof(struct nvsp_message_header) +
> >    808					sizeof(struct
> > nvsp_1_message_send_receive_buffer_complete)) {
> >    809				netdev_err(ndev, "nvsp_msg1 length too
> > small: %u\n",
> >    810					   msglen);
> >    811				return;
> >    812			}
> >    813			fallthrough;
> >    814
> >    815		case NVSP_MSG1_TYPE_SEND_SEND_BUF_COMPLETE:
> >    816			if (msglen < sizeof(struct nvsp_message_header) +
> >    817					sizeof(struct
> > nvsp_1_message_send_send_buffer_complete)) {
> >    818				netdev_err(ndev, "nvsp_msg1 length too
> > small: %u\n",
> >    819					   msglen);
> >    820				return;
> >    821			}
> >    822			fallthrough;
> >    823
> >    824		case NVSP_MSG5_TYPE_SUBCHANNEL:
> >    825			if (msglen < sizeof(struct nvsp_message_header) +
> >    826					sizeof(struct
> > nvsp_5_subchannel_complete)) {
> >    827				netdev_err(ndev, "nvsp_msg5 length too
> > small: %u\n",
> >    828					   msglen);
> >    829				return;
> >    830			}
> >    831			/* Copy the response back */
> >    832			memcpy(&net_device->channel_init_pkt,
> > nvsp_packet,
> >    833			       sizeof(struct nvsp_message));
> >    834			complete(&net_device->channel_init_wait);
> >    835			break;
> >    836
> >    837		case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
> >    838			netvsc_send_tx_complete(ndev, net_device,
> > incoming_channel,
> >    839						desc, budget);
> >    840			break;
> >    841
> >    842		default:
> >    843			netdev_err(ndev,
> >    844				   "Unknown send completion type %d
> > received!!\n",
> >    845				   nvsp_packet->hdr.msg_type);
> >    846		}
> >    847	}
> >    848
> >
> > ---
> > 0-DAY CI Kernel Test Service, Intel Corporation
> >
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flists=
.
> > 01.org%2Fhyperkitty%2Flist%2Fkbuild-
> >
> all%40lists.01.org&amp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3
> >
> d454eb468b85fb08d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1
> > %7C0%7C637455042608753098%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiM
> C
> >
> 4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&
> >
> amp;sdata=3DAKWfmJrn1C%2BwaqX6wlu95HcPys9K0ju%2FlC%2Bu3O20jAg%3
> > D&amp;reserved=3D0
