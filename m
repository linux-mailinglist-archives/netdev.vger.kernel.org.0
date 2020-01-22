Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F040145EF5
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 00:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgAVXJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 18:09:09 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11460 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725884AbgAVXJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 18:09:08 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MMq4U7022469;
        Wed, 22 Jan 2020 15:08:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=fgjQerNf3TIOCOU0Ra+DB+R3kNGZDhpEOJXRpZd7Tkw=;
 b=L0x2kRc51AnfD7awE1T9NR2IXwQvHSoAIgSiRYWV25swBnIUk/4BbLEosPnIWTqRlpey
 dvZp8tA2TshgCjCc97DsLLaY56EPazlY3W7l5DPN1zcRAomlMexDvKkMcK45dK4Ew1wC
 SCwTsYN3hP7Jnz1QY4ABdWAfCKml8IWQ5uc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpyher2jd-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 22 Jan 2020 15:08:55 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 15:08:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUDfRcSNR5CNo8ZP9brqf1uVukZW2wb6h6OaKmFo6wLD1MpTdEyc/2btIT5jX0YGRHc0gKERL8shC092Q5dZZmzgjGvoE+uI43nW/lECULylxuo9MZfgibBle1MTU1vW+FDoDnZs3zDpe98U+WICTHuThfgvmaH98Rus3TOPD1QOqULtgoCFynLmKhfFervvO05b/ZYZDEYDwA9K9wdHzXdN3V+cbnph5IX4ILouB737Md/S5ju3AZPM8Tf0R9cdUNByB2c/FmMtfok7pzK+tntzfkW5tF+hDle8kSEX0OrHeGxpflO/wIxPQOuguSl1AFpwf5zLgDqo2bAAeQ6Dwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgjQerNf3TIOCOU0Ra+DB+R3kNGZDhpEOJXRpZd7Tkw=;
 b=WLTl9S+UWERBvtq9A+I99DWCB7zzzvDG0JCj+NEpLvRVUs54UeZDj5FXALZ7ryKLGuSI5Qz4kF6cmUZgdcFh6zcgUBob8xzmyl0CmkXdkfvhmAWigcvt2rTS0nfr4sBsbamPYshttzhdoktuD2MPADtyiWdHr96xIik3FIZM/KvGq0srVoFxyy9NxWqXIS2I/imu/5UekY2zmjj2lOKCaPkAD6HEHFMAXukSK8YhqLwfN/DS0JpiB1vlSytN3pomfNDDxH8dGfGtMsw7GNjBfGz4U/Xi2HbcjkaG6qXadJUK/b4gbGpeqZlBoLgrvB1qyEPSNS7b36okobqmD8IQgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgjQerNf3TIOCOU0Ra+DB+R3kNGZDhpEOJXRpZd7Tkw=;
 b=JsxE8PouGYhIf2XMq4frh8/7Zzx2TBXBtHdMLhARUXOp8wJ2BF/42iSYMW7ds3yeDYcr2wTwpMIu8/ujTAVxrfeK7ab89ZXgbou7+sINWEzjKOk6p1BMVggI+1ImTa31VjJ2roE+0W2MEQ9peUDnb80g4D4JnD/Uk2y6MoaN/40=
Received: from MN2PR15MB3213.namprd15.prod.outlook.com (20.179.21.76) by
 MN2PR15MB3519.namprd15.prod.outlook.com (20.179.21.81) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 22 Jan 2020 23:08:49 +0000
Received: from MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f]) by MN2PR15MB3213.namprd15.prod.outlook.com
 ([fe80::6d1e:f2f7:d36:a42f%4]) with mapi id 15.20.2644.027; Wed, 22 Jan 2020
 23:08:49 +0000
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:180::ccdf) by MWHPR04CA0051.namprd04.prod.outlook.com (2603:10b6:300:6c::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.20 via Frontend Transport; Wed, 22 Jan 2020 23:08:47 +0000
From:   Martin Lau <kafai@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "John Fastabend" <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 09/12] bpf: Allow selecting reuseport socket
 from a SOCKMAP
Thread-Topic: [PATCH bpf-next v3 09/12] bpf: Allow selecting reuseport socket
 from a SOCKMAP
Thread-Index: AQHV0SS5qCMuoeFlqkeyqm80aQ3P0Kf3T0YA
Date:   Wed, 22 Jan 2020 23:08:49 +0000
Message-ID: <20200122230756.qgrv4riuxrb2drh3@kafai-mbp.dhcp.thefacebook.com>
References: <20200122130549.832236-1-jakub@cloudflare.com>
 <20200122130549.832236-10-jakub@cloudflare.com>
In-Reply-To: <20200122130549.832236-10-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:300:6c::13) To MN2PR15MB3213.namprd15.prod.outlook.com
 (2603:10b6:208:3d::12)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ccdf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff26418b-20f3-436f-09d2-08d79f900a0a
x-ms-traffictypediagnostic: MN2PR15MB3519:
x-microsoft-antispam-prvs: <MN2PR15MB3519FC08C623537FCC6EA137D50C0@MN2PR15MB3519.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 029097202E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(346002)(39860400002)(136003)(396003)(199004)(189003)(478600001)(6916009)(316002)(9686003)(4326008)(66446008)(66476007)(64756008)(54906003)(86362001)(7696005)(52116002)(55016002)(4744005)(66556008)(81156014)(81166006)(8676002)(71200400001)(1076003)(8936002)(2906002)(6506007)(5660300002)(186003)(16526019)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3519;H:MN2PR15MB3213.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tdvw3dQm+be5N5t5qgWxcKQLKr8ldSimKUMBTypymXS5RGqaZj2fWOylUVRH3UeomMWSlv4WaMKgOg9az0uH67yldZgGsct9QYLZEUTxDjR7U/UXCWCmC9mtlsvmEmQ5l+OenN2UKsjmdOb7YJYY1UaVyzF0W0qhwbRhk3P51pnjjG62TVxK77beEZLteSVoX4ALtUgpiZwBXZhnsMvVjhOKi1/0fo4PkV5apvpQCa5EKWoctZtzhuWRIdDc8/raSZ7MP9VDKYZ8ul5yBI2yj5EFFs24xB9qBg98mWt51OM1qq3kAnQd9AbrT6nB0I1NidcgFHWr7fm6Q7KNiFM3rNI66VvJXlh6FFG+fCjxTvMTLYwnMNYBdgcQ/j/5VuJrbvas8P1V/8kTtZ+fcjlVgqvd7E/c0HAtVzb0kNS0nQkENmMw7ptJdF4TSH80fRNt
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <026149D3F60B7244BA719FFD236082A1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ff26418b-20f3-436f-09d2-08d79f900a0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2020 23:08:49.1110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EFrNqMi++TCRPXl+c0Y2TK/lpWCT6SiY+/PwSt3FM/vNGd6itWrxQDxEFKFi1wUM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3519
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 mlxscore=0
 impostorscore=0 adultscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 spamscore=0 mlxlogscore=531 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-2001220192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 22, 2020 at 02:05:46PM +0100, Jakub Sitnicki wrote:
> SOCKMAP now supports storing references to listening sockets. Nothing kee=
ps
> us from using it as an array of sockets to select from in BPF reuseport
> programs. Whitelist the map type with the bpf_sk_select_reuseport helper.
>=20
> The restriction that the socket has to be a member of a reuseport group
> still applies. Socket from a SOCKMAP that does not have sk_reuseport_cb s=
et
> is not a valid target and we signal it with -EINVAL.
Acked-by: Martin KaFai Lau <kafai@fb.com>
