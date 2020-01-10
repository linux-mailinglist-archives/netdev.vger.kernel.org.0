Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E24F137588
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728765AbgAJRz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:55:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22794 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728616AbgAJRz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 12:55:57 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00AHqVmD021583;
        Fri, 10 Jan 2020 09:55:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vf2ZGddOq2mWOez5j3NmAhttRNAAlLkbvn+ZhfWe0o8=;
 b=Xr9YNrla4uc9waqkzvGd2U5URrK/Tm6ti6JRNtmVsNwXefP9Lv7vEKsRpDnRk0ePJM4v
 WFbz2jqWrQh2256C96oFbq4Z8ng9f3Uoh2++KIihEHT/Dv5S+WF3cLVSnRdHpt3bzw5x
 Kmpsa+En2m94vbTTkrwFJG3GoIZMBqhc23w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xev8f8r6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Jan 2020 09:55:45 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.230) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 10 Jan 2020 09:55:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PeI/q6k5NkoeRzE0rFjjmFFGi5DsI7xHLKRFMfToUGList0DdAobvyv5uUdTCIP/A59WcA93ht+tIpmwKRCMdATdLJ6rXhxDnl1XDmjvNNHoc511wOG3xWNjyxGf4hTRbuwSqde7yfjdK6nM41xUw1LKx9GVnaZGjzVPI2LOp6WlJVIbxScFE++XayFV0QbcqCaqClplrKjY12mAfL6w2z43NUgGKEAR2eumH82AvtVp329XMc560ka+dp8u64/OjA6NCfNDu0ifS8AZapGZM+2z36XplMFHHODYfBNeHvwzlhM4l9xapumWKz+qyVLgTb1n/swUCO1fZx0NgZmClw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vf2ZGddOq2mWOez5j3NmAhttRNAAlLkbvn+ZhfWe0o8=;
 b=aVcsk7NVP87V/R+xPeLDMh+Izo1CctlZNTK81fJmSw5PRnoOR8ayEI4YHZyVbqeJWWuzboAcBUx78ywZm9sooyxnbDkVmnwLmUs2I2RFinKbRM0F010Xx6bSr+xPi9ZKAI7IBRXwVGFyR8hbdUz3rteILLURBFYF5xnNG6SSa+PmMH15GjtyObYpE5bVkgcnCd6CJ21eLm4/E3J/+KlKKdbrctaGMWqxY7HmOD3dsp36LKXZviRx2bmvOmHPFV/ZKLqXQnrEZC5Qnlf1vPnGNRkQjr1XfwL0rF/KbDTJ+1GpcSVire/1sPFKF0hECpVqG9qjJYyJaOJrNg8A1zI8xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vf2ZGddOq2mWOez5j3NmAhttRNAAlLkbvn+ZhfWe0o8=;
 b=kJIFpBF+O2mOjZ/hP2SZWTrWwD+fqtqEAvknRSEMCScTaDfL+apN73vDLAm8+s3dgOKT3qbOlH6LldWQaaz+6AARrIjhtEvGXp1Xj0knXMU2FY8qaBg/Tbc+rJ81V9YKSrd4MFhxiS2Kw0IyOx7ckA2F6ONxiSqbc6TzT1SU8GY=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3583.namprd15.prod.outlook.com (52.132.173.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 17:55:43 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2623.011; Fri, 10 Jan 2020
 17:55:43 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:200::3:1c91) by MWHPR11CA0039.namprd11.prod.outlook.com (2603:10b6:300:115::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.10 via Frontend Transport; Fri, 10 Jan 2020 17:55:42 +0000
From:   Martin Lau <kafai@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [Potential Spoof] [PATCH v3 bpf-next] selftests/bpf: add
 BPF_HANDLER, BPF_KPROBE, and BPF_KRETPROBE macros
Thread-Topic: [Potential Spoof] [PATCH v3 bpf-next] selftests/bpf: add
 BPF_HANDLER, BPF_KPROBE, and BPF_KRETPROBE macros
Thread-Index: AQHVx92OlyP5WyGy/UGdk3xN4u2gDKfkLpqA
Date:   Fri, 10 Jan 2020 17:55:43 +0000
Message-ID: <20200110175539.7gqu3itjb5cs6kvg@kafai-mbp.dhcp.thefacebook.com>
References: <20200110174350.101403-1-andriin@fb.com>
In-Reply-To: <20200110174350.101403-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0039.namprd11.prod.outlook.com
 (2603:10b6:300:115::25) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:1c91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7065aa7-499e-4555-f2fa-08d795f64ffc
x-ms-traffictypediagnostic: MN2PR15MB3583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB3583AD0FB346E5643C97156FD5380@MN2PR15MB3583.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(376002)(346002)(366004)(136003)(189003)(199004)(55016002)(6862004)(4326008)(9686003)(6636002)(2906002)(81156014)(5660300002)(54906003)(1076003)(316002)(7696005)(8676002)(86362001)(52116002)(6506007)(8936002)(66556008)(66446008)(66946007)(66476007)(64756008)(186003)(16526019)(478600001)(71200400001)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3583;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cv7DGO7NRiBD9gs4nZQATG3SR3DP7k5wBHlnbiEUWcVmpxoimhoR99mCuOtrH7KP1tb5fdD9/Dko7Ftf7DySqtGKpxMT84OBc9JXhsIyNo1KNEbi1lXcZ+1iOnnts5inps+O0VphtD/dfYQW8A624XR1UDzXJlWw1SD0IMDKmmtUXPkwwmGxqDbG+Nr/w0DbkvyxafFNpocoKVglCN8MOCmxfr6jB7k1D+BGrPvByBKUW68b0t/YwhKYIkXqjlXbtixQjq0U2M37Im5lzYuqx/J4zwRUIHQjfAS2n8pqebDiPY9vAosDhskSO2peIcpFW0aEwn9Lh93yXpDFqsQnuZdy07OcIcyLbDjTUUCiDjXk2T/zH2LSBtYrvqLjFPMCaq77t8McogUabN1pv3d0TQUSgKd8RwUda4o6YGUnhfBEL0i8L5sGsjKumC4ibJa5
Content-Type: text/plain; charset="us-ascii"
Content-ID: <89A4B3A9B886884A97056C801367556C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e7065aa7-499e-4555-f2fa-08d795f64ffc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 17:55:43.4394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ULfY4hnVpvMdyp8Mag04DErSlqsNQL9O9hXpG/JhY09e4oEYx3V8P2lPUCPoAc5h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=871
 spamscore=0 impostorscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0
 mlxscore=0 adultscore=0 clxscore=1015 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100144
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 10, 2020 at 09:43:50AM -0800, Andrii Nakryiko wrote:
> Streamline BPF_TRACE_x macro by moving out return type and section attrib=
ute
> definition out of macro itself. That makes those function look in source =
code
> similar to other BPF programs. Additionally, simplify its usage by determ=
ining
> number of arguments automatically (so just single BPF_TRACE vs a family o=
f
> BPF_TRACE_1, BPF_TRACE_2, etc). Also, allow more natural function argumen=
t
> syntax without commas inbetween argument type and name.
>=20
> Given this helper is useful not only for tracing tp_btf/fenty/fexit progr=
ams,
> but could be used for LSM programs and others following the same pattern,
> rename BPF_TRACE macro into more generic BPF_HANDLER. Existing BPF_TRACE_=
x
> usages in selftests are converted to new BPF_HANDLER macro.
>=20
> Following the same pattern, define BPF_KPROBE and BPF_KRETPROBE macros fo=
r
> nicer usage of kprobe/kretprobe arguments, respectively. BPF_KRETPROBE, a=
dopts
> same convention used by fexit programs, that last defined argument is pro=
bed
> function's return result.
Acked-by: Martin KaFai Lau <kafai@fb.com>
