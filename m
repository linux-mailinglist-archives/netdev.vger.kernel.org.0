Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74C52EC72D
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 01:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbhAGAAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 19:00:42 -0500
Received: from mail-dm6nam12on2107.outbound.protection.outlook.com ([40.107.243.107]:12405
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727288AbhAGAAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 19:00:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZb2H1mxFWc5ZGHetNpGaaxTKYXldhBwdyfGXjvWlhe5bnINCzr90D3MpFEZ9LWq50CyMFqktnPVGi9FulzCWzs6pYZ4+1Gg7PKqlMVsBJK+Y1ZQkhDRl+gKNtyCl458aj6Mb1Y/OScrXC81k9btUcdsD1gnOSg2Ny10tVZSnMdIJSbr/da8Amth1La5scm97Lfl68VnFGk/InGrsKlDW6S5t8reVg7ux4plmRsOenQT/B3//6ag/ZrkpP9m/91H7/dYi99xvPiReVZ5Z+cOu4snSELXmmncRqtLZeuiD1jTJc4rxuED9QbdHhMnY9KUaWNLZozWUIHffzXLMBqEWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqV8ymXU2hU8Zf3SIjYDF9jJSzIyvuhghz/tHeLtgmk=;
 b=lrGV/3KxRi0WzEGW9DK+5CSSGhimu9umdzgnpTnxAk/9fCuvl0o3CbbHtZ4JSI5OrRS9SWGGxSZaAsV5NydLBx26vHIx1OeqBl6/TM3UwCF5bXEWIlMU8o+kNZcxrrhrUgHEjjvap+ZINN5whZGvWufSTHTHrKZ+QHX8mDmN/3wv0oJXYj37j5shaMULGlmma2Yd+VPGFUm3wFyDuqku7iu78V1ujJcdIIA87VMc1kRNljNV5sHtwqE/L9fqP32PBlFd4KePSTxSvZZ3/sb5rup1uTPEir/vGMSlYchtyAsx4fHFYue9AxEW1S/xiGX+AsRr4U37XK8pbOX7tPjdBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jqV8ymXU2hU8Zf3SIjYDF9jJSzIyvuhghz/tHeLtgmk=;
 b=WeDO6dBDMoGSrUDfhrTtClJ2km+DDaAuOz+5ewCK1ie4MrtP/gNpQoqEQ3TguzxaC1A36g+ryYu7XPWb7cc71hjrFTrDoYTOqDur9QCezVASQfUyvoDpAJZ24bRnG3IwxraUYTOaAqQBN5wExz8Nt2e9fBR0xU8s+5tgr1AhIb4=
Received: from (2603:10b6:408:73::10) by
 BN6PR21MB0753.namprd21.prod.outlook.com (2603:10b6:404:9c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.2; Wed, 6 Jan 2021 23:59:52 +0000
Received: from BN8PR21MB1155.namprd21.prod.outlook.com
 ([fe80::e535:7045:e1e2:5e23]) by BN8PR21MB1155.namprd21.prod.outlook.com
 ([fe80::e535:7045:e1e2:5e23%8]) with mapi id 15.20.3763.002; Wed, 6 Jan 2021
 23:59:52 +0000
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
Thread-Index: AQHW48mSn3A3+34fsUybSMcLXFW+XaoaAHAAgAFGYHA=
Date:   Wed, 6 Jan 2021 23:59:52 +0000
Message-ID: <BN8PR21MB11558420E44B211793B308F9CED09@BN8PR21MB1155.namprd21.prod.outlook.com>
References: <1609895753-30445-2-git-send-email-longli@linuxonhyperv.com>
 <202101061221.LKsEcWmp-lkp@intel.com>
In-Reply-To: <202101061221.LKsEcWmp-lkp@intel.com>
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
x-ms-office365-filtering-correlation-id: cb81330f-6df2-42cd-6f16-08d8b29f28c0
x-ms-traffictypediagnostic: BN6PR21MB0753:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR21MB0753D2532FDE4ED70A248F59CED09@BN6PR21MB0753.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:800;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OAs1+n9rYpG5Uv/bXq1b6P5jGJYamYygab9pICBRq9xAR78ZBDUxPDtMfFlqubRj2kskl4EX8qxpUTGCxzgzP8KmVlJRkbhGsUZciyTfRrn+NBHXklSi81RSyHfdoGQSiKxT/VllxRJ+Pn4XQHtrMfyR6nS14Fqrm2cP2be+30hLAWGujMwd38iJnz1ZH+8HvVy7d2f/wu6tWHJVHhQkYSohc0/0NtMgOcvz7P7F5aLcnt+LHb9CS+7yi9KoV4EL7pupglU8ZZcFDgfOj8wj3tVnHxYQ+NbadWIekivrnJDr6dMPZeROsv0Jasn0rJbh/h3KaPP+gIoIGbhxrWxIVVmRlMdU0XPSSWmYyLQ3fBzspAfupmYPtGhH1ciba4hHbuGRJyxz+Dm573LlUXNkOeV918oYfVh50qXVbJ3ijuO47LUQuVcog4324VK653rD+rgmYH/wExfMiQq8yZsT9JExWSOyuIAbLIESjilycg7bxZzL9arbrtPUKmQ8wivi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR21MB1155.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(64756008)(316002)(110136005)(26005)(2906002)(10290500003)(54906003)(8990500004)(8676002)(66946007)(86362001)(82950400001)(478600001)(966005)(76116006)(66446008)(33656002)(52536014)(66476007)(186003)(66556008)(7696005)(6506007)(82960400001)(8936002)(5660300002)(83380400001)(4326008)(9686003)(921005)(71200400001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Lrl8ctSZwNDCFufpO92H0R0wBfGpeUiPdxDjQVVbNuzDBvPGKRQAlwu9nwdJ?=
 =?us-ascii?Q?e8i4tXK8g+25C5a8er+L1EycE6NVN+xl/TLMGJ862c9d2kd9tb9hI3shl0Ni?=
 =?us-ascii?Q?1xMyJON5NGHX5yyoD5NwAqeuVeYMQwt6k5kkG011S4VnZ/XFKKloP2h96r9i?=
 =?us-ascii?Q?T8wz2q7JqXiIDGXG4nHj5rGjhFpi4t1LjHjOI+c4HPDvn3+4VGpD/jXlfwPi?=
 =?us-ascii?Q?D1DtIHHHV0EKEC7rWlQbURLtyJLWAcU3zpyw1jZuP3L9rz845e0shIDObQ09?=
 =?us-ascii?Q?L6phaYYEg0xcSZxUl+HlVAcFwtNu6++A8gfHpG3xS2xoWKtw62n02U8PreSM?=
 =?us-ascii?Q?HGeVFJQeyI2XhzIkrhCtZz/OvXbt7y4Z/D2WMR4GL7s7BA84RKsoFYFvCrBL?=
 =?us-ascii?Q?REiDCyHFm+Qps+UgKt6ILq1xCtw6VMqtGvAcxeNZb+SVIH2RNVm5df+C5yCK?=
 =?us-ascii?Q?s1u2DWy8wjReBQwrtkroUAhbwO01/JbNUj1VYbu4av7yX9pxlpy3MrKLE7yB?=
 =?us-ascii?Q?yPUGWzcWtzciGPOOww2xiQ+UgOU2gL3JcgYFymiIx5kO5oSGY5R9gFXGIXBj?=
 =?us-ascii?Q?zRuCBiYjF2rfs3HP0VwBHQCDcA5r689FZgiZXeeqEXnvjZTtQiS200P5lITR?=
 =?us-ascii?Q?b5CHyIDcJL2UftDDr3JmhfbjNYI4P7jU92sIENOes96mmxbWdDAMGZ6LqLFS?=
 =?us-ascii?Q?5Ls9A7UdkvekeOqKf3Ad9sN3Oje7nlVKYt2rumkYmSAq/BGaZDg5VS49GeyP?=
 =?us-ascii?Q?zZHhKOmp7AOxiJNQn/2Z75PjjaMJNom40RBcVA9Jfkyt5iij7UCJjtqod7nf?=
 =?us-ascii?Q?LeoiLBSTBXTJR/DkhcuX2wxr8V0cMSJI0ivKhlxd2ImVQ1tOvd3hEXTwp/VH?=
 =?us-ascii?Q?yLrvFBeE2dvXegDplHXvSWX/QDZhXsB6Q6qNdzero/FAgPv7H0YQLTfJpcQD?=
 =?us-ascii?Q?hYd+qmyoW8yfHD/KmAQwD/T637kgGugL+6LwvVA1qRM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR21MB1155.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb81330f-6df2-42cd-6f16-08d8b29f28c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2021 23:59:52.5119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: emIlabv8A1qFOewdYJhvsWSKcWmu2npZaOkvUb6cOCJeNEcAy//+YZ5WZJkf2gMoaGOKsMKRfxPavIrTOfcIWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR21MB0753
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH 2/3] hv_netvsc: Wait for completion on request
> NVSP_MSG4_TYPE_SWITCH_DATA_PATH
>=20
> Hi Long,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
> [auto build test WARNING on linus/master] [also build test WARNING on
> v5.11-rc2 next-20210104] [If your patch is applied to the wrong git tree,=
 kindly
> drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit-
> scm.com%2Fdocs%2Fgit-format-
> patch&amp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3d454eb468
> b85fb08d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C6
> 37455042608743102%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMD
> AiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3D
> 90AgH9HlZumRZ4UNC4uD2WIRpZ6ZEnvIdOKOfzYcXpI%3D&amp;reserved=3D0]
>=20
> url:
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgith
> ub.com%2F0day-ci%2Flinux%2Fcommits%2FLong-Li%2Fhv_netvsc-Check-VF-
> datapath-when-sending-traffic-to-VF%2F20210106-
> 092237&amp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3d454eb46
> 8b85fb08d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C
> 637455042608753098%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwM
> DAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata
> =3DvtVJ8pXIOxIYeKdaqT9pD1%2BEuOM3wz4yqsHh8uWsGP4%3D&amp;reserv
> ed=3D0
> base:
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit.k
> ernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git&
> amp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3d454eb468b85fb0
> 8d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C6374550
> 42608753098%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQ
> IjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DFXMG
> CFODFoq3KLklxr17iVHiq%2FWmJ3c0fM7vIZRfNmc%3D&amp;reserved=3D0
> e71ba9452f0b5b2e8dc8aa5445198cd9214a6a62
> config: i386-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
> reproduce (this is a W=3D1 build):
>         #
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgith
> ub.com%2F0day-
> ci%2Flinux%2Fcommit%2F8c92b5574da1b0c2aee3eab7da2c4dad8d92572c&a
> mp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3d454eb468b85fb08
> d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63745504
> 2608753098%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIj
> oiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=3DMMXkQ
> KENGpyfW0NJs2khBSKTuBExFSZaWHgWyyIj6UU%3D&amp;reserved=3D0
>         git remote add linux-review
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgith
> ub.com%2F0day-
> ci%2Flinux&amp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3d454e
> b468b85fb08d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0
> %7C637455042608753098%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjA
> wMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;s
> data=3Duge6PX2NyAe%2BjRtvgOhR5xzN2ltBctZXeZwn0hoYco0%3D&amp;reser
> ved=3D0
>         git fetch --no-tags linux-review Long-Li/hv_netvsc-Check-VF-datap=
ath-
> when-sending-traffic-to-VF/20210106-092237
>         git checkout 8c92b5574da1b0c2aee3eab7da2c4dad8d92572c
>         # save the attached .config to linux build tree
>         make W=3D1 ARCH=3Di386
>=20
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>=20
> All warnings (new ones prefixed by >>):
>=20
>    drivers/net/hyperv/netvsc.c: In function 'netvsc_send_completion':
> >> drivers/net/hyperv/netvsc.c:778:14: warning: cast to pointer from
> >> integer of different size [-Wint-to-pointer-cast]
>      778 |   pkt_rqst =3D (struct nvsp_message *)cmd_rqst;
>          |              ^

I think this warning can be safely ignored.

When sending packets over vmbus, the address is passed as u64 and stored in=
ternally as u64 in vmbus_next_request_id(). Passing a 32 bit address will n=
ot lose any data. Later the address is retrieved from vmbus_request_addr() =
as a u64. Again, it will not lose data when casting to a 32 bit address.

This method of storing and retrieving addresses are used throughout other h=
yper-v drivers. If we want to not to trigger this warning, I suggest making=
 a patch to convert all those usages in all hyper-v drivers.

Thanks,
Long

>=20
>=20
> vim +778 drivers/net/hyperv/netvsc.c
>=20
>    757
>    758	static void netvsc_send_completion(struct net_device *ndev,
>    759					   struct netvsc_device *net_device,
>    760					   struct vmbus_channel
> *incoming_channel,
>    761					   const struct vmpacket_descriptor
> *desc,
>    762					   int budget)
>    763	{
>    764		const struct nvsp_message *nvsp_packet =3D
> hv_pkt_data(desc);
>    765		u32 msglen =3D hv_pkt_datalen(desc);
>    766		struct nvsp_message *pkt_rqst;
>    767		u64 cmd_rqst;
>    768
>    769		/* First check if this is a VMBUS completion without data
> payload */
>    770		if (!msglen) {
>    771			cmd_rqst =3D
> vmbus_request_addr(&incoming_channel->requestor,
>    772						      (u64)desc->trans_id);
>    773			if (cmd_rqst =3D=3D VMBUS_RQST_ERROR) {
>    774				netdev_err(ndev, "Invalid transaction id\n");
>    775				return;
>    776			}
>    777
>  > 778			pkt_rqst =3D (struct nvsp_message *)cmd_rqst;
>    779			switch (pkt_rqst->hdr.msg_type) {
>    780			case NVSP_MSG4_TYPE_SWITCH_DATA_PATH:
>    781				complete(&net_device->channel_init_wait);
>    782				break;
>    783
>    784			default:
>    785				netdev_err(ndev, "Unexpected VMBUS
> completion!!\n");
>    786			}
>    787			return;
>    788		}
>    789
>    790		/* Ensure packet is big enough to read header fields */
>    791		if (msglen < sizeof(struct nvsp_message_header)) {
>    792			netdev_err(ndev, "nvsp_message length too
> small: %u\n", msglen);
>    793			return;
>    794		}
>    795
>    796		switch (nvsp_packet->hdr.msg_type) {
>    797		case NVSP_MSG_TYPE_INIT_COMPLETE:
>    798			if (msglen < sizeof(struct nvsp_message_header) +
>    799					sizeof(struct
> nvsp_message_init_complete)) {
>    800				netdev_err(ndev, "nvsp_msg length too
> small: %u\n",
>    801					   msglen);
>    802				return;
>    803			}
>    804			fallthrough;
>    805
>    806		case NVSP_MSG1_TYPE_SEND_RECV_BUF_COMPLETE:
>    807			if (msglen < sizeof(struct nvsp_message_header) +
>    808					sizeof(struct
> nvsp_1_message_send_receive_buffer_complete)) {
>    809				netdev_err(ndev, "nvsp_msg1 length too
> small: %u\n",
>    810					   msglen);
>    811				return;
>    812			}
>    813			fallthrough;
>    814
>    815		case NVSP_MSG1_TYPE_SEND_SEND_BUF_COMPLETE:
>    816			if (msglen < sizeof(struct nvsp_message_header) +
>    817					sizeof(struct
> nvsp_1_message_send_send_buffer_complete)) {
>    818				netdev_err(ndev, "nvsp_msg1 length too
> small: %u\n",
>    819					   msglen);
>    820				return;
>    821			}
>    822			fallthrough;
>    823
>    824		case NVSP_MSG5_TYPE_SUBCHANNEL:
>    825			if (msglen < sizeof(struct nvsp_message_header) +
>    826					sizeof(struct
> nvsp_5_subchannel_complete)) {
>    827				netdev_err(ndev, "nvsp_msg5 length too
> small: %u\n",
>    828					   msglen);
>    829				return;
>    830			}
>    831			/* Copy the response back */
>    832			memcpy(&net_device->channel_init_pkt,
> nvsp_packet,
>    833			       sizeof(struct nvsp_message));
>    834			complete(&net_device->channel_init_wait);
>    835			break;
>    836
>    837		case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
>    838			netvsc_send_tx_complete(ndev, net_device,
> incoming_channel,
>    839						desc, budget);
>    840			break;
>    841
>    842		default:
>    843			netdev_err(ndev,
>    844				   "Unknown send completion type %d
> received!!\n",
>    845				   nvsp_packet->hdr.msg_type);
>    846		}
>    847	}
>    848
>=20
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flists=
.
> 01.org%2Fhyperkitty%2Flist%2Fkbuild-
> all%40lists.01.org&amp;data=3D04%7C01%7Clongli%40microsoft.com%7C695cf3
> d454eb468b85fb08d8b1fb3ddd%7C72f988bf86f141af91ab2d7cd011db47%7C1
> %7C0%7C637455042608753098%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC
> 4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&
> amp;sdata=3DAKWfmJrn1C%2BwaqX6wlu95HcPys9K0ju%2FlC%2Bu3O20jAg%3
> D&amp;reserved=3D0
