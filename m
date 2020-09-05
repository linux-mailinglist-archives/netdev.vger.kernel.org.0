Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3BC25E525
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 04:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgIECzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 22:55:55 -0400
Received: from mail-co1nam11on2123.outbound.protection.outlook.com ([40.107.220.123]:2817
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbgIECzw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 22:55:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wt5PHsJQTFcSsSODowQ6IwmWaSh8kwULGSkJDFbOxSIyiFE8PU4A7pOUgaJAiSeTogIBGa/KkcVj74z15Y6ZcRv9jJ/POrA3fh6SvT3v9cHIou2nIGs3l3Eo3bLmlqidHgKHTCOcaF6Z6rcstABX+yQoII41ic1FRB3lHZit+XLhp7tPip3xmTKmSFAYiH6eU4/tJiCTu+CWiCahrnvy+U2H/M/aAs6QLOXGDbMJsAVuz7WxeZkYNUGod87sfkXGzxlJGOheYxOUlA1csUFVP3vjFWm8/f/lHtVu5JnQcyu1/wzG9l3/9Ic+tB9dPmRIjsLfC9GZVDO6m0PuRpXyVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7glVAHFyQaNVHqsco2Ncan9L3S9yMz0SEOCa1l4oro=;
 b=WhCT2RDMrbQB/a7M56yeRIz6oZu+cZ2Sm3ML0/QNYXXPbFX+mkbNqDlN9d1YojJ7dckFpNMefHMmMhA/DYblBf7BCSvvhwetzGS7HIFaD/ELkxFaj8DgkonuxjXnMole1kAIwLOS+g8omCVPDu0qbxRsLwQcLnYSdjvw81JKoQwM/8c2wJtAaIHe1KL2IfRYFjhvwRPmwGItOx8SqI9vrjF8Ky+RHHmhysY7O8IGCbzenRXT1IrT5muuE4bYsB01sQPzDlqT729enuuSPKKqEnvQ8LCRrU3sGMptaxECSamRcu7wAOCd5xSTCKJ9zF5pkmtpV7UJdSTP9SbctBwmaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7glVAHFyQaNVHqsco2Ncan9L3S9yMz0SEOCa1l4oro=;
 b=Sw1q11AQ+u3joGQmsYZxz+nmz839FHdesZhpPfIHzby4defTsLwZEpZ3aPsQNdaX2o49G1Be6nd04ZIUlRGCFLDLOQGmg05yZ6ZhG+R7y6L/K4k/sAamCAuLNvuZj+3YvpUpZRVHEaADl5ddNQsJn50+rcES/sFHLTwI8AR3d1E=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MW2PR2101MB0969.namprd21.prod.outlook.com (2603:10b6:302:4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.0; Sat, 5 Sep
 2020 02:55:48 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%5]) with mapi id 15.20.3370.008; Sat, 5 Sep 2020
 02:55:48 +0000
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
Subject: RE: [RFC v2 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Thread-Topic: [RFC v2 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Thread-Index: AQHWgNViudirRNKRX0u5bfq2r+DQyalZVOwQ
Date:   Sat, 5 Sep 2020 02:55:48 +0000
Message-ID: <MW2PR2101MB10523D98F77D5A80468A07CDD72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
 <20200902030107.33380-12-boqun.feng@gmail.com>
In-Reply-To: <20200902030107.33380-12-boqun.feng@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-05T02:55:46Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ff219b7d-18cd-4f53-a460-a8dc10c8c4fa;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e065bad8-a35b-4860-192d-08d851473182
x-ms-traffictypediagnostic: MW2PR2101MB0969:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB0969B56942986A265D23CD02D72A0@MW2PR2101MB0969.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 65TusjnYgCCuL/3+tVojVIJ81Mr+twK/rJdBcvWVTE75+pd+Ty+udLttAjGM+U0b0vLe4wMnabfgNUYXKLCtx62gwwbeONOrCUep2dNvPm6Q9fscSqTDFiHgMy1gCT2tjTos3gUBihCPLz1P6BXlmXFDfjIaoE54v7wWxkOJLW6kDR/RRRNN1IaO3A71cap90fWlefQKkwdntuNBrEbn7X35NTUExJHB0B2ncb0x3rlHaxMVnM1EZHPXdqnJPqMiQQOk5qo7LdLMfgWKOTUtOzZNHQ2AlkAeqXuGfqJScFaiTo7SKiaqW6R4VZ2wWWRorqj/a+gcqb7EQ9Eh2Wq1fVVnaQxFJxSNSCIKKq+edlsTmYSVYCjJJbIY8EMrPPuD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(366004)(396003)(71200400001)(55016002)(2906002)(8676002)(66476007)(86362001)(8936002)(9686003)(4326008)(66556008)(478600001)(54906003)(66946007)(110136005)(64756008)(8990500004)(66446008)(316002)(76116006)(83380400001)(33656002)(7416002)(82960400001)(82950400001)(52536014)(6506007)(5660300002)(10290500003)(7696005)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /IyvZ4jAwdO2qjI/kHw+J6IGOucA1R1xbtMqDYP06jOvIZbMvk0zKdtcBGQs3d+w3eymUD1sVbQ4aGMJjgXVNfeCdlEODbTJhqpQPXODkJFTLej7W79O9FWYvShEPoyxNnWcULOsQSANOjbIPihvHmbl8SIJ1itIQ6YYeOwNS6VWNb7PoUztuW4BLsotXjSd9zPUC0DzjX37zXH1VVvbragfYe7laHy4CId6SP/QaPxg7CRDWsLI0EwzcXE/kn2QZTv1Qs9KdbvSMDJY4g8P/BKsxeg0n935Q2yFsW3EK9chQcuuPEJUdyRyuCqCOiGB25TLsEn1y+r9czK2phUfUbl3fawvQ/eskNDwhXJF2PxS8YpkC6eGTcYCbOa6kwkuefn07uZlGmlsyL+f8mFrishSRoGuZOH6UYSPzQ7lTvz+3OUqcH2NK7deiXjc0ZYd25S5o+Dm2C/0q5Ig/aSinEiGDdcsLIIUpUfIfEWsbEn8dA7CUo6wSoP6AxaKtjhRpVYJNfYzKnD3o9ZcW3ByxsVmhONzeP+ASq5so95gYFSDr/4oYRy2JY61+HFlKDq7j4FioqdFMHPASyhyJNhM4Dupbc/fbs45795bUrrvLaM+NxfuWQ2P5A6psrTMil6CoiQYMOj+QZctw4HfXSMk5w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e065bad8-a35b-4860-192d-08d851473182
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2020 02:55:48.7313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uibUe2sIeCNVU9ytoNYDQYpXN0sSInmeFOjA5u9dcsWmXlMTscoavvFAwhRQ/LQ3DR7EACd3iz+ci8XZsa2Wnx2BlXA+PiKb9FFGYakZTqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB0969
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Tuesday, September 1, 2020 8:=
01 PM
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
>  drivers/scsi/storvsc_drv.c | 60 ++++++++++++++++++++++++++++++++++----
>  1 file changed, 54 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 8f5f5dc863a4..3f6610717d4e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1739,23 +1739,71 @@ static int storvsc_queuecommand(struct Scsi_Host =
*host, struct
> scsi_cmnd *scmnd)
>  	payload_sz =3D sizeof(cmd_request->mpb);
>=20
>  	if (sg_count) {
> -		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
> +		unsigned int hvpg_idx =3D 0;
> +		unsigned int j =3D 0;
> +		unsigned long hvpg_offset =3D sgl->offset & ~HV_HYP_PAGE_MASK;
> +		unsigned int hvpg_count =3D HVPFN_UP(hvpg_offset + length);
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
> +		hvpg_idx =3D sgl[0].offset >> HV_HYP_PAGE_SHIFT;
>=20
>  		cur_sgl =3D sgl;
> -		for (i =3D 0; i < sg_count; i++) {
> -			payload->range.pfn_array[i] =3D
> -				page_to_pfn(sg_page((cur_sgl)));
> +		for (i =3D 0, j =3D 0; i < sg_count; i++) {
> +			/*
> +			 * "PAGE_SIZE / HV_HYP_PAGE_SIZE - hvpg_idx" is the #
> +			 * of HV_HYP_PAGEs in the current PAGE.
> +			 *
> +			 * "hvpg_count - j" is the # of unhandled HV_HYP_PAGEs.
> +			 *
> +			 * As shown in the following, the minimal of both is
> +			 * the # of HV_HYP_PAGEs, we need to handle in this
> +			 * PAGE.
> +			 *
> +			 * |------------------ PAGE ----------------------|
> +			 * |   PAGE_SIZE / HV_HYP_PAGE_SIZE in total      |
> +			 * |hvpg|hvpg| ...                 |hvpg|... |hvpg|
> +			 *           ^                     ^
> +			 *         hvpg_idx                |
> +			 *           ^                     |
> +			 *           +---(hvpg_count - j)--+
> +			 *
> +			 * or
> +			 *
> +			 * |------------------ PAGE ----------------------|
> +			 * |   PAGE_SIZE / HV_HYP_PAGE_SIZE in total      |
> +			 * |hvpg|hvpg| ...                 |hvpg|... |hvpg|
> +			 *           ^                                           ^
> +			 *         hvpg_idx                                      |
> +			 *           ^                                           |
> +			 *           +---(hvpg_count - j)------------------------+
> +			 */
> +			unsigned int nr_hvpg =3D min((unsigned int)(PAGE_SIZE / HV_HYP_PAGE_S=
IZE) - hvpg_idx,
> +						   hvpg_count - j);
> +			unsigned int k;
> +
> +			for (k =3D 0; k < nr_hvpg; k++) {
> +				payload->range.pfn_array[j] =3D
> +					page_to_hvpfn(sg_page((cur_sgl))) + hvpg_idx + k;
> +				j++;
> +			}
>  			cur_sgl =3D sg_next(cur_sgl);
> +			hvpg_idx =3D 0;
>  		}

This code works; I don't see any errors.  But I think it can be made simple=
r based
on doing two things:
1)  Rather than iterating over the sg_count, and having to calculate nr_hvp=
g on
each iteration, base the exit decision on having filled up the pfn_array[].=
  You've
already calculated the exact size of the array that is needed given the dat=
a
length, so it's easy to exit when the array is full.
2) In the inner loop, iterate from hvpg_idx to PAGE_SIZE/HV_HYP_PAGE_SIZE
rather than from 0 to a calculated value.

Also, as an optimization, pull page_to_hvpfn(sg_page((cur_sgl)) out of the
inner loop.

I think this code does it (though I haven't tested it):

                for (j =3D 0; ; sgl =3D sg_next(sgl)) {
                        unsigned int k;
                        unsigned long pfn;

                        pfn =3D page_to_hvpfn(sg_page(sgl));
                        for (k =3D hvpg_idx; k < (unsigned int)(PAGE_SIZE /=
HV_HYP_PAGE_SIZE); k++) {
                                payload->range.pfn_array[j] =3D pfn + k;
                                if (++j =3D=3D hvpg_count)
                                        goto done;
                        }
                        hvpg_idx =3D 0;
                }
done:

This approach also makes the limit of the inner loop a constant, and that
constant will be 1 when page size is 4K.  So the compiler should be able to
optimize away the loop in that case.

Michael






>  	}
>=20
> --
> 2.28.0

