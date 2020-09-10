Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE34D265235
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgIJVKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 17:10:52 -0400
Received: from mail-eopbgr700113.outbound.protection.outlook.com ([40.107.70.113]:34657
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727122AbgIJVKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 17:10:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mM/Aj8Utb0xlzApAR15JceC3BiRpmJKIEW+0loSqCVhCtOFnbw4CUxl6PYTua+TsNN1HpcEmytisrqIUUX4Yxgo03mhhIWhxppk/X1GBwYvIgQ2SPXSIBYOtkZP6xD2mUChNHF+lP/NQSkvEAWfNIa/Od/5+3RMiVaUBlbMXU5YNtzNqPWiE3tucYcDueS2CIeuq3nuEMuI8QqGkZkv+6rEx74TIc2XTVTvhA7zMu9JyZ/bpN/vPKXgrdXu6oy/szMzypEbD9d0a1SiLTMOK8I9Nt8MpNyNh+bgMcFNjCmwObRGbZTSDbY2p4+S1wzHlBL9Tp4/aE8EIkO76VjQy+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCGjL3fKXdW7gGWwfTc732rzvBw5Z8D52EdstYJBykM=;
 b=edzqDp4YbojYXXt5oZYc6KCu60Y/r0yBNbM+0afQP5KiAsTmtv5PfSbDmxw/ZPH4Id3K75PL5gcEpbsNI8+q5O2q173H0X9k1ksScUs6UcLCxw178JfgW+/6zKhRcSDeaj2Yq1Xw+qo5umvE8zemqr4dNa8qGetfl63pDBFrGKjeejyAenrD1znJkWAmN3Lk+qzmHuH9n0OyPbceafm4WWjb45VtlgfyT4UMYWKieGCB2aE6UcUz8UAhG32kZ307VknKRPna6D/sduUT8A/tRzfYgpVDHF2N1iq/Bq3qcWE8bp194vTiU1Pu2GRn160KESrNbPV/1yezT4MAJ2Z8hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCGjL3fKXdW7gGWwfTc732rzvBw5Z8D52EdstYJBykM=;
 b=clnfXBZq9VBCUQhTm0/m/HVTSQSZzfRUmfusxPl3Pj0RCr8IOCwZRrORCD1kR3rcxlOOxpPAQQMU8hqWGj/yhj4P6DFy17pFJiWSl3hhFlWwl8xT9+eGa2/2f2/zfezs39c781TwD0HbRoS05b57mlKFE6Sbjuqo1vvlJrlz33k=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB0963.namprd21.prod.outlook.com
 (2603:10b6:207:30::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.6; Thu, 10 Sep
 2020 21:10:11 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::21e4:e6b6:10c:e66f]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::70b5:f505:ae8b:c773%10]) with mapi id 15.20.3391.005; Thu, 10 Sep
 2020 21:10:11 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Andres Beltran <lkmlabelt@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Juan Vazquez <juvazq@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2] hv_netvsc: Add validation for untrusted Hyper-V values
Thread-Topic: [PATCH v2] hv_netvsc: Add validation for untrusted Hyper-V
 values
Thread-Index: AQHWh3CiaBH0lchHw06AORvXwhPeSaliXZ+Q
Date:   Thu, 10 Sep 2020 21:10:11 +0000
Message-ID: <BL0PR2101MB0930659825AD89FF5A8DC2C4CA270@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20200910124748.19217-1-parri.andrea@gmail.com>
In-Reply-To: <20200910124748.19217-1-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d007ab8c-0d09-44a0-a78d-0a90f0f8d24e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-10T21:06:29Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 66123bc8-db4c-485c-7e9b-08d855cde789
x-ms-traffictypediagnostic: BL0PR2101MB0963:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB0963C61A42B6A556C0FC8718CA270@BL0PR2101MB0963.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v+9Hx+eMpjlHJ3KsUNamU8v/WkRzF6wcQYsICwqrcNaX5fONAD4PXVng9HNrqkBk0+Xj4Eh2O0DUbDLNtehtcEQ8Duv0K/iWKJHJqgsU3Hjlb7b82I9ztWAFzq0777Ox+dZ/snQBVGrufZboCDJx+psbDqWYRhlvF9L6i6q2kHyekqmuYNxKeOR2Suaee4QzBd629VrVlmkgREpp/pwWs/XrsI5RGv79rcNKZz8Mu/RIhVslodR753wf7JVrjj927XEuQwkbutVrWygKGkhir2axXY+Z5FghZJH5//Qq5QLg6jMc3Iq9MYb9lplmaIU+YGRKdZOLtNpCFMOHjX823Je3DZfwCAg2ORWOY6At3uw+ByKPhMYt5bgAUE4eYVIG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(26005)(55016002)(110136005)(52536014)(66476007)(71200400001)(76116006)(54906003)(66556008)(66946007)(316002)(10290500003)(83380400001)(64756008)(478600001)(5660300002)(8936002)(86362001)(66446008)(4326008)(2906002)(82960400001)(7696005)(33656002)(82950400001)(8990500004)(6506007)(186003)(53546011)(8676002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uV7Hp/XFSqtODaWGsNBqnqfCrx4ol04xoSDpeOnugWeahmqpTLP84pCufdlqlCL5s/KE53GiuOpwI0vpDtLBTt2ZM3sjawu2X7Buw8tfXFJstHSH4eYzl2F0IBha8DIR3mIeKlkkl5XNHR5eEPy5rDNrQHehCOn5XEQm8XWAE3QPh4UlVl8FmruggmRXnYdRV0fVgniJgpbB25Rn2YtkVVpLMKWXPpzeEmvaVL8VBSxjFMuPKxNWLPP+9DMLucguE2xtzayXEDTfFPD460ENzQK7Z2i7aclodRTiYmQ6vdmCuLDjut/3reT0PvJvKVsGprgdO0dHPXiPoiuLAbUog8o6+81tsfFh2ThkkcD+U27Dwob7sLnDQcrZFQ+FR9X/Q6IoEK3qtPZKiZkoTKH4hDpEQaS/xaFnTPjz438EVEvwXtK+s4etKlRkf+ZZJVDEvhTcnxZryaEktsOMUr3oRyZg6PXMwj2+GmIgFIHjjfsDt40MDvUZ1m61sem61Pz073IhG3h4lbD658f4rtI5U6Nm312OjCf8jU8xz1YzDgFDvvuJyPsk7RTFucwHq8toD1JqaDjge1RzaE1WR582qzRCT1tpcPWjIeGejnfy9MuY3cTY5PG4rznuXcsQwxj9JTI2Ii9/rWHGccEW/ge+YQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66123bc8-db4c-485c-7e9b-08d855cde789
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2020 21:10:11.2720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /WW651SUB33t1XZXozJqxyWlWKjPi4n8coTChCKpalJPxgSPn9eqCbcgrh4a5+FaBu4vJ0ZLS5kvxvLD1ae4Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB0963
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Sent: Thursday, September 10, 2020 8:48 AM
> To: linux-kernel@vger.kernel.org
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; linux-
> hyperv@vger.kernel.org; Andres Beltran <lkmlabelt@gmail.com>; Michael
> Kelley <mikelley@microsoft.com>; Saruhan Karademir
> <skarade@microsoft.com>; Juan Vazquez <juvazq@microsoft.com>; Andrea
> Parri <parri.andrea@gmail.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; netdev@vger.kernel.org
> Subject: [PATCH v2] hv_netvsc: Add validation for untrusted Hyper-V value=
s
>=20
> From: Andres Beltran <lkmlabelt@gmail.com>
>=20
> For additional robustness in the face of Hyper-V errors or malicious
> behavior, validate all values that originate from packets that Hyper-V
> has sent to the guest in the host-to-guest ring buffer. Ensure that
> invalid values cannot cause indexing off the end of an array, or
> subvert an existing validation via integer overflow. Ensure that
> outgoing packets do not have any leftover guest memory that has not
> been zeroed out.
>=20
> Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
> Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
> Changes in v2:
>   - Replace size check on struct nvsp_message with sub-checks (Haiyang)
>=20
>  drivers/net/hyperv/hyperv_net.h   |   4 +
>  drivers/net/hyperv/netvsc.c       | 120 ++++++++++++++++++++++++++----
>  drivers/net/hyperv/netvsc_drv.c   |   7 ++
>  drivers/net/hyperv/rndis_filter.c |  73 ++++++++++++++++--
>  4 files changed, 184 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/net/hyperv/hyperv_net.h
> b/drivers/net/hyperv/hyperv_net.h
> index 4d2b2d48ff2a1..da78bd0fb2aa2 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -860,6 +860,10 @@ static inline u32 netvsc_rqstor_size(unsigned long
> ringbytes)
>  	       ringbytes / NETVSC_MIN_IN_MSG_SIZE;
>  }
>=20
> +#define NETVSC_XFER_HEADER_SIZE(rng_cnt) \
> +		(offsetof(struct vmtransfer_page_packet_header, ranges) +
> \
> +		(rng_cnt) * sizeof(struct vmtransfer_page_range))
> +
>  struct multi_send_data {
>  	struct sk_buff *skb; /* skb containing the pkt */
>  	struct hv_netvsc_packet *pkt; /* netvsc pkt pending */
> diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> index 03e93e3ddbad8..90b7a39c2dc78 100644
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
> @@ -388,6 +388,15 @@ static int netvsc_init_buf(struct hv_device *device,
>  	net_device->recv_section_size =3D resp->sections[0].sub_alloc_size;
>  	net_device->recv_section_cnt =3D resp->sections[0].num_sub_allocs;
>=20
> +	/* Ensure buffer will not overflow */
> +	if (net_device->recv_section_size < NETVSC_MTU_MIN ||
> (u64)net_device->recv_section_size *
> +	    (u64)net_device->recv_section_cnt > (u64)buf_size) {
> +		netdev_err(ndev, "invalid recv_section_size %u\n",
> +			   net_device->recv_section_size);
> +		ret =3D -EINVAL;
> +		goto cleanup;
> +	}
> +
>  	/* Setup receive completion ring.
>  	 * Add 1 to the recv_section_cnt because at least one entry in a
>  	 * ring buffer has to be empty.
> @@ -460,6 +469,12 @@ static int netvsc_init_buf(struct hv_device *device,
>  	/* Parse the response */
>  	net_device->send_section_size =3D init_packet->msg.
>=20
> 	v1_msg.send_send_buf_complete.section_size;
> +	if (net_device->send_section_size < NETVSC_MTU_MIN) {
> +		netdev_err(ndev, "invalid send_section_size %u\n",
> +			   net_device->send_section_size);
> +		ret =3D -EINVAL;
> +		goto cleanup;
> +	}
>=20
>  	/* Section count is simply the size divided by the section size. */
>  	net_device->send_section_cnt =3D buf_size / net_device-
> >send_section_size;
> @@ -740,12 +755,45 @@ static void netvsc_send_completion(struct
> net_device *ndev,
>  				   int budget)
>  {
>  	const struct nvsp_message *nvsp_packet =3D hv_pkt_data(desc);
> +	u32 msglen =3D hv_pkt_datalen(desc);
> +
> +	/* Ensure packet is big enough to read header fields */
> +	if (msglen < sizeof(struct nvsp_message_header)) {
> +		netdev_err(ndev, "nvsp_message length too small: %u\n",
> msglen);
> +		return;
> +	}
>=20
>  	switch (nvsp_packet->hdr.msg_type) {
>  	case NVSP_MSG_TYPE_INIT_COMPLETE:
> +		if (msglen < sizeof(struct nvsp_message_init_complete)) {

This and other similar places should include header size:
		if (msglen < sizeof(struct nvsp_message_header) + sizeof(struct nvsp_mess=
age_init_complete)) {

Thanks,
- Haiyang
