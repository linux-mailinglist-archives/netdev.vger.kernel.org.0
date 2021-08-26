Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43E2C3F86F1
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 14:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242394AbhHZMGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 08:06:13 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20732 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234332AbhHZMGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 08:06:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17QC3Rv1017035;
        Thu, 26 Aug 2021 05:05:21 -0700
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by mx0a-0016f401.pphosted.com with ESMTP id 3apamh009d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Aug 2021 05:05:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZM0LH/0SstOy0YqiERtUX6VVzYrqg+v8CsJfS/De3/d+HkWD5oo9h2+zz3K0kud5LyU4L+6jx0bPrUp9t6eXK9yWEBy1aZqZLZVNc2Xw/a34ZKfWKmn6NMyTT6JkmxJrObxSym8DfBEbNxXeiKaCMoAzAz4XTMbE43+Pt+SF3L7Eueuj7VmvfSLtOUUUgjKATCpcj0jbKKBMAy4XL/bd3/n5U4ovAsT+WyXdBHaS+rw1UFHXY93uzduBGQCyVfKEMisgOo5gE0gjvNbQUTwmCd8bocxUZ1GkK6lu+k1ifKwo4toBXEOuS83sQJRkuNDnlTgfBvHFcycI5LoNClT3vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wL1gUE4ePGFbOJnPr8aiO63eq3hA0pgt+jsfl9sUoo=;
 b=BJcorg88J8XzKqcv2JZY3jnRgnVAidMlqtXewFk5M3aS0C2GMSf7xTUI1PNUIXYpglmNd75bjrUFSdyrc3omS7N7Hkfb89/lmj3LP8LJKA9SJc5qSqZTgPYzFWPRgNL/WXwzCQ6L7+nVzDE3ydJhkMXOmES9+fT6oqN6FeeTT9ygXegqlhaCjUZIjQAzpgUmNHpuA1EG2l/Dk2ljIgfvi0tm3f2mBdDuzjZrDD9ffqb7ecfiu5MnSrceayCl4TVox9guBvn/7mnWD+nGDmNMBr8OiFhKbIDS8DomRoaZKIDLII4V4sRtJj75o/NUgUQ/xdfTn/NVV/GqNz+EQCFOUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3wL1gUE4ePGFbOJnPr8aiO63eq3hA0pgt+jsfl9sUoo=;
 b=OEV8NBxRe1FGzzB5o6hNofhqs5Uk9gNftGM4rghB91hf13zSzNiK0ieMD2+QM/mL/0Fr+VuMhtpE8DOqsWKIwGKOWbwmLanY+ZCRI+0gSQDGuXBxwkqjV4CBF1dkwg003kzrc58Po5JmUVR3U/7VIM56T7Z+NF5u/ItQKE3MEWY=
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com (2603:10b6:a03:2c8::13)
 by BYAPR18MB2647.namprd18.prod.outlook.com (2603:10b6:a03:136::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Thu, 26 Aug
 2021 12:05:19 +0000
Received: from SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::80cb:c908:f6d2:6184]) by SJ0PR18MB3882.namprd18.prod.outlook.com
 ([fe80::80cb:c908:f6d2:6184%4]) with mapi id 15.20.4436.024; Thu, 26 Aug 2021
 12:05:18 +0000
From:   Shai Malin <smalin@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>
Subject: Re: [PATCH] qed: Enable RDMA relaxed ordering
Thread-Topic: [PATCH] qed: Enable RDMA relaxed ordering
Thread-Index: AdeaWH1cMB3HroUCSDyaRk8TiVc9wA==
Date:   Thu, 26 Aug 2021 12:05:18 +0000
Message-ID: <SJ0PR18MB3882237C8D74EB4A93A711DFCCC79@SJ0PR18MB3882.namprd18.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 668189b4-6d50-45e1-0775-08d96889c5c6
x-ms-traffictypediagnostic: BYAPR18MB2647:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2647CC657AED0D61B8736529CCC79@BYAPR18MB2647.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U3dzFna5AbN5kcBXL5IpyntbosdhmYFUph4OACA9i4IuE+KBS/Nrn890CLERDvjqvnVEuWdOjc2VuBOMsQRfmSMKdm3POEtfzPok1TRA8KXQkpExnZUwX68CRw2DLEepVp3aAIwRkCXSGBQpkV/dR+RGsgqxa5GVfc/t+PkQubt4Il3/W+6dnxCW+3GXmLSKLjIcZq0W/tWwfWw6m2VrGeRGQnirOsDxfs6wj7ny4hMDLUcw+RUH4BocCPk/nxge48xr95eWUKsztvLNRTPvE6z8eolc+uBBRYilwqHxuliKmyN+LXTABMfJDiMdwP+QbFVVbPy+4D8ibME4HIDbnsQH79xOtGHK6sMwrtpB6c6BxuBgSh4PuSzLFWn6Z4d+Y3wT3SDQ7QnBxpwcN88UnMs6dIsxV4dIlK3ZFy2YOeCfY9nscL7Z1dfc5pWTpErvTTQ05CUFGw87KoBUoe9HaCKr2Z6Rwa9qPOxgUpdVv44G+LxavQBtmrYbA9Fj6oA18IRdaGc83/SwgBGbDit+fYzDR5tPjxNKWXiGHK6mklEossejMRLvC7sZA6U6XptpBjKlMkTFmGQt1pm5qVQckRlch4+UlFw2DrUMjebf42REuR33tglYhMbFQQg1BO8E1JK7Lg52DynLPEW6YjHUWlp7I9RhiH5i7sJy6+7vnWKLyY31UpznqSjLKOwmwyPus14CrY9ZvDJ+6IFURX638A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB3882.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(186003)(54906003)(5660300002)(6506007)(2906002)(316002)(110136005)(52536014)(122000001)(4326008)(33656002)(38100700002)(478600001)(38070700005)(64756008)(55016002)(7696005)(76116006)(66946007)(86362001)(8936002)(83380400001)(9686003)(66476007)(8676002)(66556008)(66446008)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qCOlWYzJIzjSQc5o7cSQdzPo5EqdcmdJqodLJZHoS96b7PePIK/9Uv33iDTm?=
 =?us-ascii?Q?bxoVhQt1EMs3ewgyygHFp4BxeaFlKlzSaFHbqhrGI8hkHjxoq7YFlDdFog5x?=
 =?us-ascii?Q?y6iHNFYN2oQvy1kafq3qrboFFW1eLhT17s5MXoguBBbxgdrLQgaDLuueTTV1?=
 =?us-ascii?Q?I1Oy4BL0jpCu5EN/spUacqLrq1tvzhqGrslZQvpUjy1MxibIeP0GaSQtSo+7?=
 =?us-ascii?Q?vKzIFbLd5v+trjgJ3uPRLF3rPDGOI9sC7PbfWdYQPPoDHGH6uyO67qK83jeP?=
 =?us-ascii?Q?WGtGMiex27KsWlVCTNTaZefkc9ZSTUpHOfhnHsmM0e4TpmLRKcGKRBpHaN8Q?=
 =?us-ascii?Q?ZpAWY+Z31YhOsOiVqXQsr3nuYIpQ9KNy9IjdINXJrBA7rd5QATlArfgUCQdc?=
 =?us-ascii?Q?TmeIVEDGBH060WLKbOZg3LuqSkv+E7lsSULGsMWPZHaK6Y4j1ZQEjRHjRoRS?=
 =?us-ascii?Q?5PjqH/POdnQEH4Gkt4MOd6ahY7SRj/DsKXKe2+1VN/ZGlMDLHihFGllXOCIi?=
 =?us-ascii?Q?FvyhidqJjysoNZs7B3eaNLMpVDaQMbR9g587cZngMJN4maXL3R/Q/kuRN47m?=
 =?us-ascii?Q?2JrN6gdV8eqtnCoEpEvxXS3dLyl58TPA+xyEd2Mug8DYvTdB/s14eNNc+VYz?=
 =?us-ascii?Q?2OkCeXfB5UVPvmVOZOCYXPr0PmOmtbQ7+3weA7QnslIH1WTGA9hHumbYlDw2?=
 =?us-ascii?Q?+QqMKUM0czZvaqa3trI27clav4h1PplVYNcHVSn5MqQimPPZ5ZqiyWLkmF3O?=
 =?us-ascii?Q?aGxhzFlmRsIR04jY9vwblq9I5uOGLYM+ZUvD36mk/7dEmRq9ApP74VnTIoOx?=
 =?us-ascii?Q?qV0/LwyXXRxMTQQjwsXjyg/jpjeasmZOGPcHDvYBtHiaBZgmCC2sXsmY+W1f?=
 =?us-ascii?Q?4Q9QhEVhOUBCr5CuHznvgfKLONSZKEw4lhXxO8LNFFpQDBGqe3q3cLbu4l8F?=
 =?us-ascii?Q?Lv89sPdrBhxkt1ebkc42QEXzkrNSBWV6v3NeOokYT7B1i/2GXe7SqzPSJsoU?=
 =?us-ascii?Q?ZJkveq2Qkg46Cd3mDMHmFvbwYfORjBoNywWSOFRRi3YrDtVTmFSr+b3mq3A/?=
 =?us-ascii?Q?ILdsKUXXkMN/WGDBcvuE3HMV3ldlIxr4Lm44XbiN+d4qKkNc8Yp/71nPct04?=
 =?us-ascii?Q?P5D6sYlb6IsebiBoffWnwbnSc8wOf0o1JNW8x7mIrivCXs30YcDUzs9pCW+Q?=
 =?us-ascii?Q?f885v4qT46O6IwcDwloTZU9s+5ToTpHVu9wreXXTMDgYf5Y1VBJD9ee13qvO?=
 =?us-ascii?Q?Ob6QZJjRmmGvFycFZXkUOlCtVpHysEaODG8ckbkP58Yv0oW7tlJryHYiiE4B?=
 =?us-ascii?Q?4G1LpN9f/yCPIDt+oXaMyP5iG8hTkXFp1dvWix9Y44ESPcVwIOYZ3bQm9EHh?=
 =?us-ascii?Q?pFM2LDo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB3882.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 668189b4-6d50-45e1-0775-08d96889c5c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2021 12:05:18.5094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: neGR4LqngI9YlLJeKfF3v/exvz+Jfuuor9RNK2Mooyzb306ZHfQa8tap8D/x7tBMq3Sir//zpxSU1mLbfpTurA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2647
X-Proofpoint-GUID: h5edAyq27vxDkvqugRayLQNcxf_as5Q8
X-Proofpoint-ORIG-GUID: h5edAyq27vxDkvqugRayLQNcxf_as5Q8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-26_03,2021-08-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 02:52:21PM +0300, Leon Romanovsky wrote:
> +RDMA
>=20
> Jakub, David
>=20
> Can we please ask that everything directly or indirectly related to RDMA
> will be sent to linux-rdma@ too?

In addition to all that was discussed regarding qed_rdma.c=20
and qed_rdma_ops - certainly, everything directly or indirectly=20
related to RDMA will be sent to linux-rdma.

>=20
> On Sun, Aug 22, 2021 at 09:54:48PM +0300, Shai Malin wrote:
> > Enable the RoCE and iWARP FW relaxed ordering.
> >
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > Signed-off-by: Shai Malin <smalin@marvell.com>
> > ---
> >  drivers/net/ethernet/qlogic/qed/qed_rdma.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > index 4f4b79250a2b..496092655f26 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_rdma.c
> > @@ -643,6 +643,8 @@ static int qed_rdma_start_fw(struct qed_hwfn
> *p_hwfn,
> >  				    cnq_id);
> >  	}
> >
> > +	p_params_header->relaxed_ordering =3D 1;
>=20
> Maybe it is only description that needs to be updated, but I would
> expect to see call to pcie_relaxed_ordering_enabled() before setting
> relaxed_ordering to always true.

This change will only allow the FW to support relaxed ordering but it=20
will be enabled only if the device/root-complex/server supports=20
relaxed ordering.
The pcie_relaxed_ordering_enabled() is not needed in this case.

>=20
> If we are talking about RDMA, the IB_ACCESS_RELAXED_ORDERING flag should
> be taken into account too.

Thanks!=20
We will need to add both FW and driver support to enable it.

>=20
> Thanks
>=20
> > +
> >  	return qed_spq_post(p_hwfn, p_ent, NULL);
> >  }
> >
> > --
> > 2.22.0
> >
