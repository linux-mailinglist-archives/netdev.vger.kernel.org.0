Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A83BF528E
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfKHR2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:28:43 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:14270 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726121AbfKHR2n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:28:43 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA8HJes2007380;
        Fri, 8 Nov 2019 09:28:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yTUWAXOtmD0bn0cYiFV9MvYZSQZiC0kzLxuCaSodJ7g=;
 b=lLW7opwFm4/D4+tG1HjLyL2j1ts1rht3PQuHGqq7lgyXsiU58WVRvNbUcGP2+rxPfWN0
 rdLO2ipzQ7AP/ORQlxQIdEGpZKT65IqTjJCUjtF5zbmOUADzvofC34m6586F4Qruz8NT
 5E5BDTVlCuDG16fC0mdZqEPHhf6nEw6WBFo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w5ckcg2dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 09:28:27 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 09:28:26 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 09:28:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R1r80nA+xdmaDYxXPKxxqFaU3YOMyTCbKrEVK43W0c8o8RHr+2WvkdM7z7vOsi1cui1bFucSMLGG6FFJEuZTPRPzB2XbxHQqRCGmw7Y1uZ23hHjbDrMBxQr+eEoRTyeWBcbD+cLb48B27ABq8iFuKFbajSPffoy25CckJREPbQCYbEtpcNQ9iKD3gsX8Efi0pECXUfs7ovgMuU/+UIbw0ISZZDKtj4vPFioxPbrStAdM2ns3sSx07eIbktlAoKbjXYS9UmIN+hVnBOvOT6ah7n5j+diD/mMwDkGHVEUWjl7NdwL6d6plsFFhIJcAAcgPEXecgkTKfFqqsl4xHcCe4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTUWAXOtmD0bn0cYiFV9MvYZSQZiC0kzLxuCaSodJ7g=;
 b=PoMbWsqu3h2L+LrtYVbIkQM9Cq4eI+q3J1W6gHerTs9hzpCFqkG+8A6EkHugaR1sdfplhPBh5CPGQC7bFuh0OzKBVvDf4cJq7N11dY9wgKdChnhEyzcRCkNbPPV6obmxHLiwrIe7WI+OcBchthencPdge0Yn4iDeelMS4WlBTvzS9uG6waP6lsXc0bVswoPsI5wtXB3J7Te1WNfrmSD8W6ygUkfbPV2lcU8wkrwE1w09eDeT7qX8GXRWjdYQsb5exKAyo0OxAtWG6mUY5jQBrzM+ZPM8AsikoZzY+FW/t5T79IsYzAb1y1Q6yG/03tZbQUpyprJWmk9ZW3lTWtojSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTUWAXOtmD0bn0cYiFV9MvYZSQZiC0kzLxuCaSodJ7g=;
 b=eQbvHyJtZXT6QmsJ+sMiwnBRy1rp15JAGhNrPsqYnxEoxiho6c/H8lAvOmIGdHSMcJt7B4XDruoYhx/MibuhXxyQBujpKsY2CU1ZM3UktCufzgi+43CJjYG4ZZ94tWnxA3ANz0SjJPfYlXEKK/72BLZFM25igC9Tb7PnN6ycqUA=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1935.namprd15.prod.outlook.com (10.174.96.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Fri, 8 Nov 2019 17:28:24 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 17:28:24 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 14/18] bpf: Compare BTF types of functions
 arguments with actual types
Thread-Topic: [PATCH v3 bpf-next 14/18] bpf: Compare BTF types of functions
 arguments with actual types
Thread-Index: AQHVlf+bHUIhx96v2Ey15OIsHx2+aaeBh9iA
Date:   Fri, 8 Nov 2019 17:28:24 +0000
Message-ID: <0A1C27F0-25D9-455C-86DF-97AC19674D8D@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-15-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-15-ast@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 94bd7c61-9553-4346-ee57-08d764710f1b
x-ms-traffictypediagnostic: MWHPR15MB1935:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB19352F70305737FD67AFD332B37B0@MWHPR15MB1935.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(86362001)(54906003)(11346002)(446003)(2616005)(486006)(476003)(36756003)(76116006)(66946007)(64756008)(66556008)(66476007)(186003)(81166006)(81156014)(33656002)(14454004)(46003)(6486002)(6436002)(53546011)(66446008)(229853002)(6512007)(50226002)(6506007)(6246003)(99286004)(102836004)(8936002)(5660300002)(4744005)(4326008)(76176011)(2906002)(71190400001)(71200400001)(6116002)(256004)(14444005)(5024004)(305945005)(7736002)(6916009)(8676002)(25786009)(478600001)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1935;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PLFwnKcS5ZauObfFsv7c4HjOjsXJll25QLGHLlnxSEtNqtErb4kBUvVDPDkttmMQ2qGAb7qFQPioHI85517VJLN+hr5jcxM+zw7xiVwyg+pGzrLdKopZvIvpTbkI1L9eYDivwfUbQ29uCHj9siFhxjlm65T5NdwpSte9YuTeSNgrn/AxeNTj1YNHpHUHxnGPXglmHhPpuxQnUOKshtYzAD+02XH3LIa6ExrDE/Tj23QKUjQbcJX5C76FN9QmhPQfFGATum3HbsW4rgObqwAygQg86xUNgMnkNbedHWDk1evk7vc7Rd+is3wZ5bQwMRWliFp2shv1o8yB7HZ5jOtr0JsZYDSplOCrHtrPIGsAWFS6hGoq2OQ6vWpDx8hi5Q8EHhWO+7Hp/7H/l7uqLjC9IsJaagnol+bDmpRt2yw1dpOf9tLLxR8Fkke9OcoMyRnJ
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FECE34AF8C00284C94CD62388E1B1607@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 94bd7c61-9553-4346-ee57-08d764710f1b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 17:28:24.2226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LKU96IXCIak/SIFc0QHXvYQ6s3yCw5/O6c35GyTs6qQp8HFKlbXGNUFOpGJzfXKCtSKrKgj3YxFdpCpJceix4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1935
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_06:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=411 impostorscore=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>=20
> Make the verifier check that BTF types of function arguments match actual=
 types
> passed into top-level BPF program and into BPF-to-BPF calls. If types mat=
ch
> such BPF programs and sub-programs will have full support of BPF trampoli=
ne. If
> types mismatch the trampoline has to be conservative. It has to save/rest=
ore
> all 5 program arguments and assume 64-bit scalars. If FENTRY/FEXIT progra=
m is
> attached to this program in the future such FENTRY/FEXIT program will be =
able
> to follow pointers only via bpf_probe_read_kernel().
>=20
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Song Liu <songliubraving@fb.com>

