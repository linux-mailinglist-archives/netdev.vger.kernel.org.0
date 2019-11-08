Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB4B7F529A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbfKHRcx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:32:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726200AbfKHRcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:32:53 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8HS9QK001685;
        Fri, 8 Nov 2019 09:32:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6ln4OWkfonLQwkCXQ0K6/qTXqb08HMf6gsVPvuM4LGo=;
 b=bfN21L3YKpOz8ptcdNMGXc1xuKx8d5OLFcctncNGAzlnZv1D3ZT310Txbcmj6sH4NSo4
 DEFapuu5r0KzOcIe1KTaOfaQeZvs2GD11YzllMYRLdQJ39J1HC7f2/LPYpQe7oLMNs+W
 ypE2m1/8DiZzIqAJqG4s0mEiCaa3EROe5Hw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5a1bs2au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 08 Nov 2019 09:32:37 -0800
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 09:32:36 -0800
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 8 Nov 2019 09:32:36 -0800
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 09:32:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OCi2r8/cgqtxpM0OwZeWm9c9Y1tpUzZhhi47V/09cx08RgGO1Q5h/xPuV7fPT/56ryE3UJFHT2fTNiPOC+5E2ZrMSrM8RdK+zJgeTvEAdkRzoDZ7TXH72FC6wwV7bpAUTM6QVHB/fk0BFwpp2+W6C/W0kE3Mg/tF9Xdy9f87/NRiT/NmIdvAG/7J65xB3HfchAxIxHEdBVEGgw3OVrUKUu2XXpxs02myYqUN6OYNWxXmzDzhDsYIdP7LZwXKEJf467GbA8e+EAnjK5V8vNlA03DxKgkuM8rUSV97S4Oe6UFtoNja43xGMv/N/pr/upFy6jKEFqZgWU1tgluYAkCGgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ln4OWkfonLQwkCXQ0K6/qTXqb08HMf6gsVPvuM4LGo=;
 b=nqFInMKxZogirMybW6Qv36vPmm5ZHAhWCaavq6enGP2qKFbhn26emQbyOrHZk52SryYGwLOjJmPSxyoCMLU8DnrUiTpvJ24yixvoX8rmYX8ZdR1PTr6FFkrxNYjlFuPBtpyzI23ZNStifOAWrEspuTwhjNxZHZA66itaNxXyx4PKBt5PGPCVSryeEZ5Xi/4mdTtdXHdkDBjHXvNS5S3iPlvZ+ydwgUwTi9JhCE1eIosiMJ8kYL4yRhTDsVsrqzXDZEm6W3FmgAuPTXUEUEYILTCH4DHCESXPqBgXnWTTaI5o4LVucNprPeD7C/2Zhgtkvf781R3+fiESp+S+dbR5Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ln4OWkfonLQwkCXQ0K6/qTXqb08HMf6gsVPvuM4LGo=;
 b=NDZfMTR++gVCNqcAx0g3ISmD5D1/LnCqtHQDA0t5RrJ0OLZdMMvD84GxdbDh+92BFqjdXgAyulOJuH1vWwvLeJWez+ZvZkCjJPsV81YWuUuGZ1nPU/7uEm5AzZVs4Jg/QC55yY3kZmdupDoklwlDZEUW3Kjk4ILD8GbF70ayhlA=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1933.namprd15.prod.outlook.com (10.174.100.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 17:32:34 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 17:32:34 +0000
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
Thread-Index: AQHVlf+bHUIhx96v2Ey15OIsHx2+aaeBh9iAgAABKwA=
Date:   Fri, 8 Nov 2019 17:32:34 +0000
Message-ID: <0E317F4C-F81F-43D2-9B8E-D8EE93C98A07@fb.com>
References: <20191108064039.2041889-1-ast@kernel.org>
 <20191108064039.2041889-15-ast@kernel.org>
 <0A1C27F0-25D9-455C-86DF-97AC19674D8D@fb.com>
In-Reply-To: <0A1C27F0-25D9-455C-86DF-97AC19674D8D@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eaa24cbf-a06b-486c-af62-08d76471a468
x-ms-traffictypediagnostic: MWHPR15MB1933:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1933D3D9B2C2CBBD3B5B183BB37B0@MWHPR15MB1933.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(396003)(136003)(376002)(366004)(189003)(199004)(71200400001)(8676002)(6486002)(50226002)(5660300002)(71190400001)(2616005)(6116002)(33656002)(8936002)(81156014)(4326008)(5024004)(256004)(476003)(486006)(14444005)(316002)(46003)(66446008)(64756008)(66556008)(81166006)(186003)(66476007)(7736002)(76116006)(99286004)(6916009)(54906003)(76176011)(14454004)(66946007)(6246003)(6512007)(305945005)(11346002)(478600001)(86362001)(229853002)(446003)(102836004)(6436002)(4744005)(25786009)(6506007)(53546011)(2906002)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1933;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: va5TPEKIXKwLoIP+OD2OaHmsAupHL88W7L2I3ydF674V3gRQy1zxI9UHwAi5f3SuVwmtR+CZVW1jrxJ9dpHJQB6RmeBcDYi7ao0th0U+C4vNEXqUEhkXFQ3ZYvMtdNKPRwWC2toxJmci+ES5+Pa5RfCQc9oR7RwEwiWY8MR/O5PUGImXLza3CIh7pu+z+f3ajVnJwNFMm7CrdWC3Sn4gjqN8Xm8dG36CyNy5unroy+PiesxiQcb/LRSR4Pg04NQjCZN/Mwp+3kQP1zmZDsg0+97SYsh3k28HHbWpcaTDGtnPtR84/TxipG23a/gE92fibJapHcHjgH5B3G+265XLydyhH7WQEJx63K2YuVsCJUN6tETSpYmolHTDApFbS2wxb2MvP/pLSu8VLBgBxKgvxYx9GjgTjBkl2J4v5QiG515ApWwOg28I7IT+81bxkEHp
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9DC002FDB4341A49B78621AC077B01E7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa24cbf-a06b-486c-af62-08d76471a468
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 17:32:34.6881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bsqNMlOCBpBrThyahNVxRXPOPrY4sOs/qh9Tqq+5yhvg1i/LuKL9k5gg+85hkxyoY9pNxsTQOABCmYre6oHuzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1933
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_06:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=508 lowpriorityscore=0 malwarescore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 8, 2019, at 9:28 AM, Song Liu <songliubraving@fb.com> wrote:
>=20
>=20
>=20
>> On Nov 7, 2019, at 10:40 PM, Alexei Starovoitov <ast@kernel.org> wrote:
>>=20
>> Make the verifier check that BTF types of function arguments match actua=
l types
>> passed into top-level BPF program and into BPF-to-BPF calls. If types ma=
tch
>> such BPF programs and sub-programs will have full support of BPF trampol=
ine. If
>> types mismatch the trampoline has to be conservative. It has to save/res=
tore
>> all 5 program arguments and assume 64-bit scalars. If FENTRY/FEXIT progr=
am is
>> attached to this program in the future such FENTRY/FEXIT program will be=
 able
>> to follow pointers only via bpf_probe_read_kernel().
>>=20
>> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
>=20
> Acked-by: Song Liu <songliubraving@fb.com>

One nit though: maybe use "reliable" instead of "unreliable"

+struct bpf_func_info_aux {
+	bool reliable;
+};
+

+	bool func_proto_reliable;

So the default value 0, is not reliable.=20

Thanks,
Song=
