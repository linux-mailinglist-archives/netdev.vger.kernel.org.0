Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E52622A386
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbgGWANN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:13:13 -0400
Received: from mail-mw2nam12on2100.outbound.protection.outlook.com ([40.107.244.100]:20064
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726685AbgGWANM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 20:13:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNHPx27MIfZVzXQfFOiHAOgYUCoEbJZlXdmsDACB20NDWsMg26Mf7SlMESk6uDSfBD+ck06CgUHpEiBcI9BVh2VODetsW7PYT2a5Guq2qfFi2AAU3M5GVt06iN3M7Yz/PgONzhwTIQQf7fXX2N+Kh4htR6Y7vsDSSVvBKYSBQSp4NB/SAZgXtzof6vYpyvviCusxz3DzR2R01FGwoNL6nc8iet2eTAILA/G77qKh5Z2bt4m7rH8U/q0mMlTd0HrzDWLMCP/BxwDQ+LmENWPjA4auMP/8j8MRluB1wYbg9e3TAd0xYLTyeKdZGJ3uPj1rNdZmjhuZjKeT3ZwIfTpfSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iv3tKUqwj4GLIXmVeBnGAvz2Fmn2APkR64SPF5jisFc=;
 b=LUWg56C9sPU40o5C7lAfWgicCGfw4yI7bJxEMOlxbVwnOkHoe1EwiD9rF9lh1h5XSUCVaRrCaKEUL/uVgGwQ0wagUl2JwpKrxeYdnA6qDKxKBgj5NCSMXui5Vs6hSZAEyU4eaFDypf4OIEcsZVhqF/Bq/GJJv9GwU91rYrJwOZHkpqKgXvKuqNFSFdyh56wVGceOyUgRwqM0eNTfXJT2oR/wBxbT4bL0xl3QeCXmN1EVSBZ9hOZm4wwAbOdqufFfbE0KjIQZGz2y74g2k4oOZ7cICf7quvphOVcraiT5THwrVyezYFv8n5sYu35n7TyACQ4caC+sZGzPLBnpZbxfsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iv3tKUqwj4GLIXmVeBnGAvz2Fmn2APkR64SPF5jisFc=;
 b=Tep0Pikp2TBS0SRQ2ngaUCQtWc3ASsGBdyyLCTR594hvv6C3wJe8czTOGKs5goIbYYK2Y8t1bvYDWVBx7TFOoiPw3mXQtC9+WR80pXQul2d0zeThNHdJKgnx25PFMw69wQ8VdAQl24RmalC5oWxPxPaUsPTk2vA0LHarmqAeKwM=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0144.namprd21.prod.outlook.com (2603:10b6:300:78::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.3; Thu, 23 Jul
 2020 00:13:08 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%8]) with mapi id 15.20.3239.005; Thu, 23 Jul 2020
 00:13:08 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RE: [RFC 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Thread-Topic: [RFC 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Thread-Index: AQHWXwAq7r8b2cLtUkWcYsdrWYe9TqkUScaQ
Date:   Thu, 23 Jul 2020 00:13:07 +0000
Message-ID: <MW2PR2101MB1052B072CA85F82B74BE799FD7760@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-12-boqun.feng@gmail.com>
In-Reply-To: <20200721014135.84140-12-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-23T00:13:06Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=cd5985dc-6ae2-493a-90fc-2e545e75dce5;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f15381b8-9d91-4e16-cc99-08d82e9d2df3
x-ms-traffictypediagnostic: MWHPR21MB0144:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB014435BAA10D956D3A0232EAD7760@MWHPR21MB0144.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qDosYAIDvIpFkkmaUu+s5uzPmup+hE9kR/hKhYkdSTk4Q3BoB76Xy8oNSNMlCGg36mQAymkPN7W5dzmUvDQCTzh5Aqn93Ia0LLuHRSuPludJro5FVde89dqLZglmPwaFLdKeeyafFDElL9+RIXf4Z+DEjyK55BrMA6pVTW5mgAjqhXevYSpFcZx4TF7eHyEirnC/Zu/3xUA+ogcvg/H7mA0uH9dxkS+6jvl4vNaB723+VAM9O01wXXl2I2ruI4YbjH45CJCxX8Dwyu4JN8PuCiehPy2K+WlVhL5DoqTQr4fhjwbBrXUPcrpp268ta5m8yV61Y3I7jNban5Ac98kBrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(8990500004)(55016002)(82960400001)(9686003)(26005)(71200400001)(186003)(76116006)(2906002)(10290500003)(52536014)(66946007)(5660300002)(64756008)(66556008)(8676002)(478600001)(83380400001)(6506007)(82950400001)(316002)(7416002)(66476007)(54906003)(33656002)(7696005)(110136005)(86362001)(8936002)(66446008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Gr80VwBHXYtPfvpuyxL7FldsBTn1UfxpbSQqjnAed0XPW4C2PUcYk9W+g8kZ6pmDTM6GakwqSes0yTqySqd0jMTwE4+v5pgqUGey9xnQxaHe11NxymLZE1OPHu1aU8k/+SSAFV8uUoKaczxiWE39GpjwlNjxcFjfWXTKVyaT2IFlYQttS0E2VcFS+G0u74LHKOrWdMinGa48D9GJ66fK7BZgZWe2lvdZYviD7g/6p2hWT6g7Ro23GdjbP1ZLtWzmwnddA5oJXDI84hS/f9DeSJnN4+YO6ZXEpfXf+Iwpzllm01IUWxN14ieuSchak0UKl3zSg3Ep/Pwe+Lr1+jsBU1May18ztIY+7X5swSl7eQ76betvDRhCDB2T42H4f5Uzmgwysl+S4Qd9mYXcRbIZNnCNPTYEVJZ0UsNfSKnnx4kJMJkzoK6UOl+d7Yy5o4BhlBTO38o6oejruiah4R7A9FC+zVZDt3Ckjyv/5PHDF87wZp2E1788iyC9QsDX5UKHmzi/esmy5TXY1xAzQWjvAhQVqC90xBAJEitgckHH9CwZeoMoWGjYxR8DK2hLhBjmvBQUE5kDMrXLZkeE+FUALoso16KbtLVt4/BU/WVC4BBCWmN1+tpBg10R4c//cC648M1nzBFsoWeD3aJ0HAj2Qg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f15381b8-9d91-4e16-cc99-08d82e9d2df3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 00:13:08.7591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C6SuX0Hdah0XAfX9BhdPlWMDbIRkIDA46jtmFNJiHSPYwp0heFK9XRPKrvdBOpy3gBGEXopvsbWdPR0RA5bY0i+PKBC90ETgEPa2dceAYhc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Monday, July 20, 2020 6:42 PM
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
>  drivers/scsi/storvsc_drv.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index fb41636519ee..c54d25f279bc 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1561,7 +1561,7 @@ static int storvsc_queuecommand(struct Scsi_Host *h=
ost, struct
> scsi_cmnd *scmnd)
>  	struct hv_host_device *host_dev =3D shost_priv(host);
>  	struct hv_device *dev =3D host_dev->dev;
>  	struct storvsc_cmd_request *cmd_request =3D scsi_cmd_priv(scmnd);
> -	int i;
> +	int i, j, k;
>  	struct scatterlist *sgl;
>  	unsigned int sg_count =3D 0;
>  	struct vmscsi_request *vm_srb;
> @@ -1569,6 +1569,8 @@ static int storvsc_queuecommand(struct Scsi_Host *h=
ost, struct
> scsi_cmnd *scmnd)
>  	struct vmbus_packet_mpb_array  *payload;
>  	u32 payload_sz;
>  	u32 length;
> +	int subpage_idx =3D 0;
> +	unsigned int hvpg_count =3D 0;
>=20
>  	if (vmstor_proto_version <=3D VMSTOR_PROTO_VERSION_WIN8) {
>  		/*
> @@ -1643,23 +1645,36 @@ static int storvsc_queuecommand(struct Scsi_Host =
*host, struct
> scsi_cmnd *scmnd)
>  	payload_sz =3D sizeof(cmd_request->mpb);
>=20
>  	if (sg_count) {
> -		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
> +		hvpg_count =3D sg_count * (PAGE_SIZE / HV_HYP_PAGE_SIZE);

The above calculation doesn't take into account the offset in the
first sglist or the overall length of the transfer, so the value of hvpg_co=
unt
could be quite a bit bigger than it needs to be.  For example, with a 64K
page size and an 8 Kbyte transfer size that starts at offset 60K in the
first page, hvpg_count will be 32 when it really only needs to be 2.

The nested loops below that populate the pfn_array take the=20
offset into account when starting, so that's good.  But it will potentially
leave allocated entries unused.  Furthermore, the nested loops could
terminate early when enough Hyper-V size pages are mapped to PFNs
based on the length of the transfer, even if all of the last guest size
page has not been mapped to PFNs.  Like the offset at the beginning of
first guest size page in the sglist, there's potentially an unused portion
at the end of the last guest size page in the sglist.

> +		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
>=20
> -			payload_sz =3D (sg_count * sizeof(u64) +
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
> +		subpage_idx =3D sgl[0].offset >> HV_HYP_PAGE_SHIFT;
>=20
>  		cur_sgl =3D sgl;
> +		k =3D 0;
>  		for (i =3D 0; i < sg_count; i++) {
> -			payload->range.pfn_array[i] =3D
> -				page_to_pfn(sg_page((cur_sgl)));
> +			for (j =3D subpage_idx; j < (PAGE_SIZE / HV_HYP_PAGE_SIZE); j++) {

In the case where PAGE_SIZE =3D=3D HV_HYP_PAGE_SIZE, would it help the comp=
iler
eliminate the loop if local variable j is declared as unsigned?  In that ca=
se the test in the
for statement will always be false.

> +				payload->range.pfn_array[k] =3D
> +					page_to_hvpfn(sg_page((cur_sgl))) + j;
> +				k++;
> +			}
>  			cur_sgl =3D sg_next(cur_sgl);
> +			subpage_idx =3D 0;
>  		}
>  	}
>=20
> --
> 2.27.0

