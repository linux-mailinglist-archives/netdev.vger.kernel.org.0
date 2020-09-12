Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E18D267C2A
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 21:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgILTzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 15:55:32 -0400
Received: from mail-eopbgr750091.outbound.protection.outlook.com ([40.107.75.91]:52226
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725875AbgILTzW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Sep 2020 15:55:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vp02GnHaaGwqdcabqm16DMlKYgEvYPS5mkMvQNvg/sdo8d71tko/L1Fub2sVa1yf++n+w8hiZ5QwxLdNm/06cuh1i+iNHSzxaVl76ZexJwXEOQB58PyXy0XhEkX5+VE0KqPzzCiHI80jBmNCtZpmrEmli2h3/WQPUjlezv3jynIW9GJ75dedmD0rbZq+l58Dwbdx9QhegkCyCxPoMy0hjLlHq30bl3Ix6bDBIgDyUjK8A3CfZ8nxvgwMO8YnqWFTOsGP2CCv6BJLEygRFbxK4tf7coUYWInJo/tditasaZpwxHpc1dQW4P+Yvz17u12ra87VLFP2TcGIGy/auPAM+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kl2mgj60w3tfXcsrxHmB3e0zcz0ySXd/yD8wLARyqu0=;
 b=D9vuBUqSrAG9h+HYdE1rqaUnSxpxqghIsS5Qj2j2Djww6XPSX7RTK4bEU+KQXNksWyREpKqGpkNPXWj6As6S7Ghn/7EQY//MB/QGXCoRx4t2X5g+ltKyfLTNAzfOiePAV2qOzPnjdMqyU+lIQVAdcDwVNLPCN28+G029TwhXdcYhozG8V5N6pDf4Gz4YBW87havCmUN4bvFKBI5wdEgSv3cpGjdh2QyurvdMWxz+J7bfA+r+zTXhAViyg59CyJ9Hx2XvzUP7joG6IAWQNZGT+wGqw9JZBrJAn4INFR5Xw79rtAZ7BK66Gxvb4pSiDkKjoF5MMudBagRVVVuG1yf0hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kl2mgj60w3tfXcsrxHmB3e0zcz0ySXd/yD8wLARyqu0=;
 b=hzujsktExSqBkX9NFtx6UTkI2UjIMvpsmdHaS6BWZOPqFs3PlLUG4RGXsjmYMTFBHRNJ6aeVYyJMcpuqNqustSmuzn6G93WhjvfSedaLxF0vjGGMKN8YG/2sTj0lYAMPoF9OCh7AUY0BKiWVEwAsSdJEEplDDCUN02cgMwhcca4=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0890.namprd21.prod.outlook.com (2603:10b6:302:10::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.1; Sat, 12 Sep
 2020 19:55:16 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%4]) with mapi id 15.20.3412.001; Sat, 12 Sep 2020
 19:55:16 +0000
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
        "maz@kernel.org" <maz@kernel.org>
Subject: RE: [PATCH v3 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Thread-Topic: [PATCH v3 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Thread-Index: AQHWh3+iswt/mGTL+kaAcnr9o93++KllahIg
Date:   Sat, 12 Sep 2020 19:55:15 +0000
Message-ID: <MW2PR2101MB1052215E0AC097F7BE439794D7250@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-12-boqun.feng@gmail.com>
In-Reply-To: <20200910143455.109293-12-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-12T19:55:13Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9a42f931-5453-42d0-9ab7-8f50495a4f65;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f815a372-58f5-4953-904e-08d85755c4ec
x-ms-traffictypediagnostic: MW2PR2101MB0890:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <MW2PR2101MB089074A10F2FE1B13FC67A91D7250@MW2PR2101MB0890.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sdrGySaSX0ouEpwRHxhqSMnWcHIyYyhKHOSeUws4UWzZ1qHnD0SKd2F9Uz2ocEoSRJ7bXEP54HCaFS8jkECgQbCbT73GNgLekhqKlu1ubh1KN4uq6kZqKxbGPQ2eGPT8e2qCRNFuPSRxnjIvjN7WVPGp+RE+p17oLA27NxiBDycOaYsL7vQJ3jdidpsxIwmJnO7naAAkwg3zgVjY6/VlVuGV3hV5fh+lr7KTm4AiN3/qGFbSPRpIoz/QmGODgZ0l+yw04iILQ4kW1tjFct54h6Lc3yMa5NJLV79UqtogG83wXQ74h2td21hCyYODhgGYoQ9q3FL0paU9XDhrNeJ+4UkKJw4roDzHJYbjqLsZ9eyhZmjHRIkXNuRshDWt306X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(366004)(39860400002)(136003)(186003)(33656002)(66946007)(86362001)(7696005)(66446008)(26005)(76116006)(66556008)(71200400001)(52536014)(8990500004)(54906003)(110136005)(64756008)(5660300002)(8936002)(66476007)(8676002)(83380400001)(478600001)(4326008)(7416002)(82960400001)(316002)(55016002)(6506007)(2906002)(9686003)(82950400001)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: fW9JCkmv9fZiFVccyZ4UXMTujLXmXQkabV3q0eBEAwgTh/hNaabKGZF1sDlGzewQ+VXQ1NvhfxeAoqK3ikXFCHrBQjk07N0OdtXMT3vYIcrzJDIK/WeBlpr110HY06Tk0Vm8C3Djz79wVGG4qw/CCW1dqOHelsrTJuPYpVtHLcka2pkhFTHxs9b8hqnDD04e3AfXONLlC34hzFd6sOSOATVkEzhxNwYuGqVA9mq/cIpbJGVSRw8Izhp0+834itnfLtViNdXl02wc4tVZFGNidt7ax+W7wtQkYyKeKe2YuV8ihql8KR9rSEgshs4enXxruQtM/FXWRuFqgAT/5EHQLkPBjupsYjPO5815bagNHnTE5X+R3pPAotSoALVeO7Rd5ihCkY8qLdVEdcEILmLz0UVmbWh6CaFJlSKuvnuDkVOv+UNxGDzcjRSqXwFYDm6ex2vWxjNAkI1mvkq9PT1c01BYs76PKPqhqlHM9meSsOoWW+1gcc7StDQwcbcnZjr9GolpEVW/81fRBkafFQctybfRM54AysPJ9QEz6DY1RvHQWqC3avYzDvCcqUiy8ziXYbqMF0YxdnEhqXXtOJ8epBPx562IU5ZX5Xkqr5sffD4ej7xcU/zRC9g/n08rW+7WHSy6UE0fCDUAJPt1Ng5gkw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f815a372-58f5-4953-904e-08d85755c4ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2020 19:55:15.8320
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5zCMGEusvV9SqngEM7K5iehf3CIw7u5dOFwbuGe+1b73KpxJyFxWQTgr6SV1peDj99OnoX71pQMKUbMe7x3SselmdS1ahvQHjdi0Qpa56fw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0890
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Thursday, September 10, 2020 =
7:35 AM
>=20
> Hyper-V always use 4k page size (HV_HYP_PAGE_SIZE), so when
> communicating with Hyper-V, a guest should always use HV_HYP_PAGE_SIZE
> as the unit for page related data. For storvsc, the data is
> vmbus_packet_mpb_array. And since in scsi_cmnd, sglist of pages (in unit
> of PAGE_SIZE) is used, we need convert pages in the sglist of scsi_cmnd
> into Hyper-V pages in vmbus_packet_mpb_array.
>=20
> This patch does the conversion by dividing pages in sglist into Hyper-V
> pages, offset and indexes in vmbus_packet_mpb_array are recalculated
> accordingly.
>=20
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/scsi/storvsc_drv.c | 54 +++++++++++++++++++++++++++++++++-----
>  1 file changed, 47 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8f5f5dc863a4..119b76ca24a1 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1739,23 +1739,63 @@ static int storvsc_queuecommand(struct Scsi_Host =
*host, struct
> scsi_cmnd *scmnd)
>  	payload_sz =3D sizeof(cmd_request->mpb);
>=20
>  	if (sg_count) {
> -		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
> +		unsigned int hvpgoff =3D 0;
> +		unsigned long hvpg_offset =3D sgl->offset & ~HV_HYP_PAGE_MASK;

This is a minor nit.  The above expression uses sgl->offset.  Code below us=
es
sgl[0].offset.  They're the same but the inconsistency sticks out a bit.

> +		unsigned int hvpg_count =3D HVPFN_UP(hvpg_offset + length);
> +		u64 hvpfn;
>=20
> -			payload_sz =3D (sg_count * sizeof(u64) +
> +		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
> +
> +			payload_sz =3D (hvpg_count * sizeof(u64) +
>  				      sizeof(struct vmbus_packet_mpb_array));
>  			payload =3D kzalloc(payload_sz, GFP_ATOMIC);
>  			if (!payload)
>  				return SCSI_MLQUEUE_DEVICE_BUSY;
>  		}
>=20
> +		/*
> +		 * sgl is a list of PAGEs, and payload->range.pfn_array
> +		 * expects the page number in the unit of HV_HYP_PAGE_SIZE (the
> +		 * page size that Hyper-V uses, so here we need to divide PAGEs
> +		 * into HV_HYP_PAGE in case that PAGE_SIZE > HV_HYP_PAGE_SIZE.
> +		 */
>  		payload->range.len =3D length;
> -		payload->range.offset =3D sgl[0].offset;
> +		payload->range.offset =3D sgl[0].offset & ~HV_HYP_PAGE_MASK;

Another nit.  The right hand side of the above assignment is already calcul=
ated as
hvpg_offset.

Nits aside,

Reviewed-by: Michael Kelley <mikelley@microsoft.com>

> +		hvpgoff =3D sgl[0].offset >> HV_HYP_PAGE_SHIFT;
>=20
>  		cur_sgl =3D sgl;
> -		for (i =3D 0; i < sg_count; i++) {
> -			payload->range.pfn_array[i] =3D
> -				page_to_pfn(sg_page((cur_sgl)));
> -			cur_sgl =3D sg_next(cur_sgl);
> +		for (i =3D 0; i < hvpg_count; i++) {
> +			/*
> +			 * 'i' is the index of hv pages in the payload and
> +			 * 'hvpgoff' is the offset (in hv pages) of the first
> +			 * hv page in the the first page. The relationship
> +			 * between the sum of 'i' and 'hvpgoff' and the offset
> +			 * (in hv pages) in a payload page ('hvpgoff_in_page')
> +			 * is as follow:
> +			 *
> +			 * |------------------ PAGE -------------------|
> +			 * |   NR_HV_HYP_PAGES_IN_PAGE hvpgs in total  |
> +			 * |hvpg|hvpg| ...              |hvpg|... |hvpg|
> +			 * ^         ^                                 ^                 ^
> +			 * +-hvpgoff-+                                 +-hvpgoff_in_page-+
> +			 *           ^                                                   |
> +			 *           +--------------------- i ---------------------------+
> +			 */
> +			unsigned int hvpgoff_in_page =3D
> +				(i + hvpgoff) % NR_HV_HYP_PAGES_IN_PAGE;
> +
> +			/*
> +			 * Two cases that we need to fetch a page:
> +			 * 1) i =3D=3D 0, the first step or
> +			 * 2) hvpgoff_in_page =3D=3D 0, when we reach the boundary
> +			 *    of a page.
> +			 */
> +			if (hvpgoff_in_page =3D=3D 0 || i =3D=3D 0) {
> +				hvpfn =3D page_to_hvpfn(sg_page(cur_sgl));
> +				cur_sgl =3D sg_next(cur_sgl);
> +			}
> +
> +			payload->range.pfn_array[i] =3D hvpfn + hvpgoff_in_page;
>  		}
>  	}
>=20
> --
> 2.28.0

