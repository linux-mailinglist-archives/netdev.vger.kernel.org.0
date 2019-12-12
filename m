Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6359D11D61B
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730536AbfLLSoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:44:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730096AbfLLSog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:44:36 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCIhapk000820;
        Thu, 12 Dec 2019 10:44:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=9TDAXXRHLL2RAc3cVksIbGsKKDkm+K4A7fJkryGjEb0=;
 b=gBAZinubiTisw5MZPxVhkNwW7fc8wrdzD2vX6hSGoptq711M6XGoHkYJ02AevaSXiLlM
 xLZgkSEiTj8BcvK45LbyXhiXVj9EozS/D1SxnWISHxpuiq8c0GGkUefIAG7Ipk5fbhYm
 PThh/GV36qHO2gNkBB3TDeJOTp2edc9+s1M= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu404e1sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 12 Dec 2019 10:44:19 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 12 Dec 2019 10:44:18 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 12 Dec 2019 10:44:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SeLrgHTAzDHzoSgXfU/L7t0UJUma9hjktvWkWZrSt6lh2m41q1Ht/h+0wEM8FAIUefGU0ND7CJ5Nizq6SbRv50MDsjRPszRzyEh4kjV6+Z+7C0Uc495/nwpvUPcfZtzdUu0lzIM7fwcq6ROngvbd1Afpd1P2tZErsHYlamve+B6rvfr8VbEU6uEpdP8cRaB0kJmrGyziCuUwonYcdrWUKJzb5PhmaNX8jW/XgBh0kppl6Toq2ZwCD9L7D/N6+fES2PGHiN6npFPU9k0KIYdOKllIwUHrrbUu7ojXboS4SxwYDBd98WcfEi8KLOeO/d01JiofYwyD4MtUh7y8TXZMvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TDAXXRHLL2RAc3cVksIbGsKKDkm+K4A7fJkryGjEb0=;
 b=UybrvzRrh4c1UYR9/l6Vcp6i9C3KMb13Gr0HJbfzAxJOZN6KJ+xg+4X2Rf8PhVuFlIg6EQtkquXTFL2ppELBiW4l8NtZGFqN6U8ZYSpfstxJslPh5V4E6uiWHxGcEWi5w3Bc3hm0CrVIMdbCcrS7aAAdkivM9gzF+79ujIw7U2qZnouQy4O9unDjObITSZpRvWIPRMuX06qSnmoxoduMOw7zQ3frHaEa0hQAmkOZz2azHZU/D912oZRGrxpBMuW+gTMzBoe7exqHMJTo45R9Ux2UDllbxHtjNbWU72aNlsK8gq9iO9/c7rnSm9nfz8qgUaffur4+i8Jm2Kwy6D14ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9TDAXXRHLL2RAc3cVksIbGsKKDkm+K4A7fJkryGjEb0=;
 b=MkoHJrn1LL7mLnR8XsDrF0yI5gNRL3B3FmkYmLXhaqN/cg0aRXoFqqpDpjLDVhc/s+1e+n0rEXXxRSMUko1BGzpLOcKH7Ng+pSamPGb2KpJt0bOcvvC8N0NKyOuh/5UCyIcelsqvSeVQCrw6HtiRS64JaYIdy95of/tyKfQMqPU=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB2799.namprd15.prod.outlook.com (20.179.147.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Thu, 12 Dec 2019 18:44:17 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2538.017; Thu, 12 Dec 2019
 18:44:17 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@google.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: expose __sk_buff wire_len/gso_segs to
 BPF_PROG_TEST_RUN
Thread-Topic: [PATCH bpf-next 1/2] bpf: expose __sk_buff wire_len/gso_segs to
 BPF_PROG_TEST_RUN
Thread-Index: AQHVsEwLUWZjNmqSZkyw83eJXXpaH6e217OA
Date:   Thu, 12 Dec 2019 18:44:17 +0000
Message-ID: <20191212184413.uedxe65rbcls5jde@kafai-mbp>
References: <20191211175349.245622-1-sdf@google.com>
In-Reply-To: <20191211175349.245622-1-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR20CA0029.namprd20.prod.outlook.com
 (2603:10b6:300:ed::15) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::97ef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d5f00eb4-ae36-4dac-509c-08d77f334ac2
x-ms-traffictypediagnostic: MN2PR15MB2799:
x-microsoft-antispam-prvs: <MN2PR15MB279964644F2F339414F17BDAD5550@MN2PR15MB2799.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0249EFCB0B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39860400002)(346002)(396003)(136003)(366004)(376002)(199004)(189003)(4326008)(1076003)(558084003)(478600001)(52116002)(6506007)(6512007)(9686003)(66946007)(71200400001)(66476007)(33716001)(6916009)(86362001)(81166006)(81156014)(5660300002)(316002)(54906003)(8936002)(6486002)(2906002)(66556008)(64756008)(66446008)(186003)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB2799;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kLB6PCBeiAKcaPF/UczUkNEnKprpo49IEsdLi1ykN9P7/Pz+xTZGArPyCD4nD/v0M7KAYAYruCTXSsTr/U5f3Kq+lXRGEl9lI6pugCVl3Exf+a3Gx+cC3/CRKtT4XH0DhYg16Tz5u6ysR+2kWZl3/fiycMDkZU/TH3rsA37pGVXP8Al7tUOB/FEPNVbF5Ui6RF/MgFzTYQU+0W56+u3VKnLBfHWHgNJeXSVbvMgNlYyMKeIe2iGUlJTBtRpjyA7rXYaknFUF82N9nIST4sEYtGbVeyhRDHuoUyj9ZEkxneU1oUALZcN/EOSZUO+b5vml0cb5bKtJzmOsZ9zRL0GcBdWbdfL4ybIBIrPBSAp5TYGzTwvO7E6o3zDV0CYM5SFNqhu9AGDEh0RjyIJK90+9ntlDskJMT5hA/NyfPudkBzOwi1tGACzWxnEVqlUH4IWH
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F96C3809598BC49A271052C70F0CFB9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f00eb4-ae36-4dac-509c-08d77f334ac2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2019 18:44:17.2961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 296r8kSx+9CVuJsa767E0qtZJXZUUYCP6W96sJyHaKF9azI6U8Qf1cOAuT8/fU4u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2799
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_06:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0 mlxscore=0
 phishscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 clxscore=1011 spamscore=0
 mlxlogscore=697 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912120143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 09:53:48AM -0800, Stanislav Fomichev wrote:
> wire_len should not be less than real len and is capped by GSO_MAX_SIZE.
> gso_segs is capped by GSO_MAX_SEGS.
Acked-by: Martin KaFai Lau <kafai@fb.com>
