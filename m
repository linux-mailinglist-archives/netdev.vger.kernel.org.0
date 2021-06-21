Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071AC3AE6E5
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 12:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhFUKVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 06:21:32 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18566 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhFUKVb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 06:21:31 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LACUIp030256;
        Mon, 21 Jun 2021 03:19:14 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by mx0b-0016f401.pphosted.com with ESMTP id 39ap170jac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 03:19:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDU5YwRPOaUH0jAcmgX3oXw2dKPengwVlHetVgWLoKt+1vSlq/dqP3A280BR+igLy0xHEBTmXoDOsK4JDNjr+FDyttzJhrCOT/4qVDUzdCP4KkKAUK6AMMnIfFCpGIFEcvNQKRFxO38S1R8EUDQc88yBmjW0II5GSbzHiXTpKQJtzsWlvcdJk+Zpib+GV58otF+0xAAMkw8AqQsir1h4RufACjuFo8Lzd8iINSOu3IjFeStFhft+iJfhB1q23Ve+l0utOlP/OD+gMF7TUZj7u77AMeTv61JhMdehnW8YWEs/hGTWjxaVOEGpFiLROIwzqweaKKG5ZsmncluBBphVPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/gb/yeWajARFxqTQT7nz6TUhWVBDVLjlfGocd4p24c=;
 b=XJHeJEsZrEY60/n9d0yJ0Kkp1RCLNs/2oBHHepq8mhjaO6xicsIqCULFZab6DUbNakSWkGsa3lhmOQ91qnB82+S4ivfRcMbv3A8mki0OlEylu+ci9FxT6Thjn7iM15LDigTrX67aNWVbIbwEYG6vchuosA79KT5cnPz6O1Z1HtQVxNdAbJh8DJdupyWZTSTlym/abZGVpJGLriZ/K5nDFeftu8YVpWfLVNm0Kcr9uoXcbsP1Sqj5yZihpaFXuQMs2wDNNcuUMdJjgRsRcRPvxzGYKd9KbSRKSFjsZStmTq3kXLFNsmDEelzOfeFqEIdaTXkmgqOIScIGzj9YfUV+LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/gb/yeWajARFxqTQT7nz6TUhWVBDVLjlfGocd4p24c=;
 b=BUos6O5nqkgkipCTylqN85aIIDSIeN3wqwEqqQahE+ntaI38HHPHxDa1G+QeSMayINc/6fBhrenZayMn47/g+dkFN1+H9cdsoaybQBIFt/2pxgrzRZntkelPT6Pk/UMidWu3mOEjTSLyF/MenE+zIhbhKsAET7NeJVfAKZ+W5p8=
Received: from CO1PR18MB4666.namprd18.prod.outlook.com (2603:10b6:303:e5::24)
 by CO1PR18MB4698.namprd18.prod.outlook.com (2603:10b6:303:e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.23; Mon, 21 Jun
 2021 10:19:11 +0000
Received: from CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::681a:e55b:2953:afe5]) by CO1PR18MB4666.namprd18.prod.outlook.com
 ([fe80::681a:e55b:2953:afe5%9]) with mapi id 15.20.4242.023; Mon, 21 Jun 2021
 10:19:11 +0000
From:   Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
To:     Kees Cook <keescook@chromium.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>
Subject: Re: [EXT] Re: [net-next PATCH 1/5] octeontx2-af: cn10k: Bandwidth
 profiles config support
Thread-Topic: [EXT] Re: [net-next PATCH 1/5] octeontx2-af: cn10k: Bandwidth
 profiles config support
Thread-Index: AQHXZFwbbdZx5wbeFki/50YI88FgR6seRLwY
Date:   Mon, 21 Jun 2021 10:19:10 +0000
Message-ID: <CO1PR18MB46661477EC162BF123B79FE0A10A9@CO1PR18MB4666.namprd18.prod.outlook.com>
References: <1623756871-12524-1-git-send-email-sbhatta@marvell.com>
 <1623756871-12524-2-git-send-email-sbhatta@marvell.com>,<202106180903.E89363BB@keescook>
In-Reply-To: <202106180903.E89363BB@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: chromium.org; dkim=none (message not signed)
 header.d=none;chromium.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [124.123.169.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7acc9e19-e88c-4c5e-72c2-08d9349e0311
x-ms-traffictypediagnostic: CO1PR18MB4698:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR18MB46982D6659008351282DB25DA10A9@CO1PR18MB4698.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LpO6ky/1nIbRN1tt3P2U7g+4q8A05s2crYzPyya9Fquo6VvbeOko78AzDPybyuTBdjCn599IS8+3rEcPDsJ3dUd8AntTBwhQxz0m0cIF9RpRs8AeXoZPThhWnWvhvZhip6scB5/VsxtH7UhGKkIhIbZ1IH9XR0GfxtWLg2aQVF4xsfpkjmKlum7L1escq2FHZjk3ugOsToUC2O0ZYwz2bWN3FdIeohBbcb6B/YodQMmrrSsaf/3kRyr2iJwB/Uxl5pfbOnpKCfR15+KfY4DtT+F1ydLJHI2x/5lKGB5xzt2TOemSlHacGE1d9ex2QvP1VfcJS8PkQgVYiloGvdznG5EyJa/MkrwHO4XOCMc4kmtUsIkX0GhB0NaHh7e8tfPOFJs9P9g3U+JPFeOAyBxHFUofX/1sTIU1CK4XuozcgWr7u7mSsgQLBMWNy/mVK03jfyblgJXV/w38mfhOKdeoe8O0cqR4aDs5MFZ9WJUHlL7isQXrdDIuDdCOioDkqH2j2UPW26crsaRSk6kKsk8WVch+xV+LtIvLSN7pXEUqMekpBVzL0i5qZvO9gYqbRgftiy1Fq+s1bKOxpceFZRXdWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR18MB4666.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(376002)(396003)(346002)(66476007)(66556008)(33656002)(76116006)(66946007)(4326008)(52536014)(66446008)(54906003)(7696005)(91956017)(64756008)(2906002)(107886003)(478600001)(53546011)(316002)(86362001)(122000001)(186003)(8936002)(9686003)(5660300002)(6916009)(55016002)(38100700002)(71200400001)(6506007)(26005)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7n3Cy2WtpEJHh4W58M8p6l27cLkERebbyJBuXYERfLxPCCWvAAFXjMxozkOT?=
 =?us-ascii?Q?iZNrCnACPpaU8nK3WKoJavJsJIWHhokvhRmH3hWjYAS6mJT/2tuMiSLoKQhu?=
 =?us-ascii?Q?+qLRQDv+zX7WliyMsZm0v/wY0owyYk4PH1AW4hPoo2d/+DFYyBR1LvePv9UW?=
 =?us-ascii?Q?aj8D5riy/yTpiIGtsF/6YbVFxK+X/f3RrsRh5JyRvwUpySmg71V2SsdN2mXZ?=
 =?us-ascii?Q?YdWnJRfS9Wfv+2spjVr/yZwwd1I95+xb5W+sUVymcnzjhR/aAGI0XXfXrN7p?=
 =?us-ascii?Q?EiChurXy0nRWsnOlCTRe90L5R2k18Ql7RwmoqBgZq2+hqbF1BsUho1PchIj8?=
 =?us-ascii?Q?+bHwfQCbl47M2uQ6YHeMsvTeH12U4WFkp3D9Cus+olXDNzBZmXR/a2t2Vk/P?=
 =?us-ascii?Q?ZxBuy2KN4F2CZ8XQaMkrSKSpC7Mws7DhCAlicy7SrzXnCOBHhItJ4QfI2KNX?=
 =?us-ascii?Q?4rIMCm9ej8t9StROADfbOwmAFjuv4u4UZ7qdhYPh3mpIZCVjzfVgUDA9KzSX?=
 =?us-ascii?Q?69Va0pB6MrV1b0t64VCAHgT2JpQO2rn+pVzVTs1A3vRP2B2GzzdQay6xsVid?=
 =?us-ascii?Q?fHjskwcbVkeKnfIIbFPHAJF5JdeQDErqUqZIY/WrvZpBA5hu4J9aIHiNU/Jh?=
 =?us-ascii?Q?hos2MjWFnYMuD2Qb8HZirtFWjmJSKo3Ld1GtxDAb9tPkmJRIZ8C9yy/ShWCz?=
 =?us-ascii?Q?lyjyf9DrMMNw24KBby9FLh5vIQMjBe8KWJyltdJRZgYbvvxC66zezgi5lK42?=
 =?us-ascii?Q?0Fny5Jc+KsgSQTNVP7E27lUjFIadskIBOleFrFzAylcSsVY+NWTFOJbYb8Nd?=
 =?us-ascii?Q?uK9HjklySmT2sMYGUwZGUJ5HXMfhP5zcM07y02wYOSOWhC93wngXBlZ8LtiQ?=
 =?us-ascii?Q?v8S+9SAQtJtifYXqMkUPgkihH9SvEkJcJoKzvShJNILP/EyeKuID4cOPN0Ft?=
 =?us-ascii?Q?RfjYgbwF1USJhozGvH2D88ECXWfXyP+sbWdfxK1bT5mSyQSRLtZUtKYBKrxJ?=
 =?us-ascii?Q?JtKGrYXzwRiXqUE8fMK+p+LucDVkIsQrGiu6E2suQrlTKSrGYT76+lxtttH9?=
 =?us-ascii?Q?6szd1TzvWte1PtEpC25MQNjdHzykHI7xaxyQqM63wMtdZbVlU8dz83UVMspj?=
 =?us-ascii?Q?lW8XC+rYVM263xjIZEpxgXYXmbd9vK2LWq1vTn+IquspFjxFVTHJUa4lrKtQ?=
 =?us-ascii?Q?8sm8XpIMEQ8aQxepyWYXZWlNJM//plFs63vHvrPOvouiczPhav0M0lsxPMGZ?=
 =?us-ascii?Q?iwMyDseX8CNDzEijhhfT9Eeshd8jaei4U3uawyNIEtskviBMFUpMn9KHHiG1?=
 =?us-ascii?Q?jhY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR18MB4666.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7acc9e19-e88c-4c5e-72c2-08d9349e0311
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2021 10:19:10.9572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YeEA8fYFOAXI3uTgKBx1InSWI+ghbT+RbeJGIjc4Lrv5q+Cj/uCxRi6vYYPvDbMp01l8dHgOmmNILxhjRHIkgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4698
X-Proofpoint-GUID: n9k0sBqunWhN9ZJ_QaEviCdFswWmYkAv
X-Proofpoint-ORIG-GUID: n9k0sBqunWhN9ZJ_QaEviCdFswWmYkAv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_03:2021-06-21,2021-06-21 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kees Cook,

Thanks. I will send the fix to net.

Sundeep

________________________________________
From: Kees Cook <keescook@chromium.org>
Sent: Friday, June 18, 2021 9:37 PM
To: Subbaraya Sundeep Bhatta
Cc: netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org; Sunil Kov=
vuri Goutham; Hariprasad Kelam; Geethasowjanya Akula
Subject: [EXT] Re: [net-next PATCH 1/5] octeontx2-af: cn10k: Bandwidth prof=
iles config support

External Email

----------------------------------------------------------------------
On Tue, Jun 15, 2021 at 05:04:27PM +0530, Subbaraya Sundeep wrote:
> [...]
> @@ -885,6 +906,9 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, s=
truct nix_hw *nix_hw,
>                       else if (req->ctype =3D=3D NIX_AQ_CTYPE_MCE)
>                               memcpy(&rsp->mce, ctx,
>                                      sizeof(struct nix_rx_mce_s));
> +                     else if (req->ctype =3D=3D NIX_AQ_CTYPE_BANDPROF)
> +                             memcpy(&rsp->prof, ctx,
> +                                    sizeof(struct nix_bandprof_s));

rsp->prof is u64 not struct nix_bandprof_s, so the compiler thinks this
memcpy() is overflowing the "prof" field.

Can you please fix this up?

--
Kees Cook
