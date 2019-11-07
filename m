Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81482F368F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 19:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfKGSEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 13:04:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40158 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbfKGSEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 13:04:44 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7HxZHO000815;
        Thu, 7 Nov 2019 10:04:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=1dxZyu4+Z3ZEcI6T5jlvYT89LuvcxqG9F+ehjd9RvjM=;
 b=MqpX3/8G1d8pIok7cjkjKVrYyBRrYUabScuyfTDkIB00adPHDOvuGR/6+xGU5ydPBLDt
 8aUxi1gEpcq+YDL7q7bS+uS2t3CZ0+rLlGvPPghBW3wabL9XLuqTD6QC5pZujgIUTODC
 NNJTkHXCaqWJk8AxMT6EuActN0dMoeDrncc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41w6xjuq-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 10:04:28 -0800
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 10:04:26 -0800
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 7 Nov 2019 10:04:26 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 10:04:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COa621/kcLL/fKqeY86Rn9JCjP//vNWx8+Z6Xcp3njfnb0Nk20CoYQWfURvjw8zbEZRduPeeIJiisD/qokndBKvy5HsfIZuQEm0zg5IBH0OkTuJWXSp32ahNOMzvukTwV20ojPTXOowHJDm7b1RNPtlvem1skRA40K9d007rR1C3iI+tro2ieCNkSPsIwhU6ioNV24Kx8igyMaZmDG39ITydMIgrjBljZdU5Cx4SzSulQht8yHGhRlkyYi21uDTyjTDXrJ2fOLU7hbm/FrN06cWQCwm6InYj35Y//crNLinTcLqzhqk6gJ/p1Ca7j18vY8DVaJKGGywvZnHn6aEufQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dxZyu4+Z3ZEcI6T5jlvYT89LuvcxqG9F+ehjd9RvjM=;
 b=hkoDsVRzrw/RVUjSCGqc33V4oIsI87S+WG7HYTec2QENqMWxMekK5T4E/xmaY3GiQNRjQZPnXKX2eJ4ou0bM88ToPGXGsL8DPLQM/hDp1LuIjkPLZrlgHColRqHg9I++2B9g8DGpOUQsGE6DqKyIZ219d/PnllGSkawigC7bXKcyn6oRYDHznVCmL0j/fG/uHw+kILJ69a4ci0+Gdw+jj9k7R9h6Gjyx8ZXo0yx+Y2Oj4l1lBrV14oN4BCg5Y7uYuNfV88zEa7jMb4Bwyg9gaxN4F/xy32cPaJmIQs0Z0z5rMmJcqGmAEXatF7Mx+XFistcKq39C4UTusKuanka/Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1dxZyu4+Z3ZEcI6T5jlvYT89LuvcxqG9F+ehjd9RvjM=;
 b=eJh0w9ZYlx9c3kuHnAyYA8SF2aZu6VF8rKM2pHJwTln41xXC8b72fzjCdgMe7E0u5F9j4CKooET818RUSFV7Q8xplyJMgMI8YlQHyRZy3rMMkUoqviEkkiVk6BcGQDMFobAhuaKfhkl0AneW6neF0Kj0AJtyUJLCF/oidk5iqzg=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1695.namprd15.prod.outlook.com (10.175.142.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Thu, 7 Nov 2019 18:04:25 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 18:04:24 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <ast@fb.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 02/17] bpf: Add bpf_arch_text_poke() helper
Thread-Topic: [PATCH v2 bpf-next 02/17] bpf: Add bpf_arch_text_poke() helper
Thread-Index: AQHVlS7DiyLTZMsKz0OSS+G7WREPWKd/9O2AgAAIcICAAAEcgIAAArwA
Date:   Thu, 7 Nov 2019 18:04:24 +0000
Message-ID: <0C445C0F-20A0-48E5-A5A6-03A3F4073160@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-3-ast@kernel.org>
 <EE50EB7D-8FB0-4D37-A3F1-3439981A6141@fb.com>
 <CAADnVQJsnVmTNxj1QbEbHCsvyvL348R08cZ6ChZK8EGnpc2BfQ@mail.gmail.com>
 <71d8650d-10a3-af18-dd3d-3e8d63d48bbd@fb.com>
In-Reply-To: <71d8650d-10a3-af18-dd3d-3e8d63d48bbd@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::1:11cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0aac60f2-d3c5-4520-bc7c-08d763acec84
x-ms-traffictypediagnostic: MWHPR15MB1695:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB16955C950A0558DC8530452CB3780@MWHPR15MB1695.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:185;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(346002)(376002)(396003)(366004)(199004)(189003)(316002)(6116002)(6862004)(8936002)(229853002)(33656002)(4744005)(86362001)(2906002)(6512007)(53546011)(486006)(476003)(46003)(71190400001)(71200400001)(50226002)(36756003)(76176011)(6486002)(6506007)(186003)(66476007)(66946007)(5660300002)(305945005)(54906003)(14454004)(7736002)(4326008)(64756008)(76116006)(66556008)(478600001)(37006003)(81156014)(81166006)(66446008)(25786009)(102836004)(8676002)(11346002)(6436002)(6246003)(2616005)(256004)(446003)(99286004)(6636002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1695;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: swnK7/zv0yEcqkZJ6pYQRyPwF2BcrdE75RXAGWlsJfIEBl9l9qAPziP8jNjblhCSjVOAUoNsHYBZB4A17cVcsfiin8PEoAa2vQWhzYmzT+lvzhkj/ECPc48Y5CCDEXIzJWpj2HoEJwV3XpqWXP5sNK583eRpxSaVfXyqrYau4bqqH60l1kXqkhAtdHJ6S/VxUvz/j+hfQ+rk4RSZOIy3EqQpFPyTiExtuA7NJbKUP5YDKSxWyI0UcrndPUISVbi/Uxne06M0kejfUxKBUky80663XDup/7ipBg/a1dLppnqU9+Gl5WirzSKIL4P+FOyIcDVkWxU+sjyyJ5ExF/Cpx83iCo38/wIWaNy0/dtoagF/ThY4E8EyRawtQW5IxkLJ2NqM/5zkPvNBjqgFvGpa6pupbq1+xD6swbGR3923Ikk4ynOwve5tziG/MB0PoIWk
Content-Type: text/plain; charset="us-ascii"
Content-ID: <71231B59EF978E45885100A71CA2F90C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aac60f2-d3c5-4520-bc7c-08d763acec84
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 18:04:24.8611
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o//oQm1fDp6C8+oqXMXhN8AOaUpu55TrSXSzwCLF0t4fgrMjH5D0tdvFrlztQ3pnIp3bUNq6vCXNAWYfDQ2ppQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1695
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 phishscore=0 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 adultscore=0 priorityscore=1501 suspectscore=0 spamscore=0 mlxlogscore=872
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 7, 2019, at 9:54 AM, Alexei Starovoitov <ast@fb.com> wrote:
>=20
> On 11/7/19 9:50 AM, Alexei Starovoitov wrote:
>> On Thu, Nov 7, 2019 at 9:20 AM Song Liu <songliubraving@fb.com> wrote:
>>>=20
>>>=20
>>=20
>> ohh. yes. of course. I had it fixed.
>> NOP_ATOMIC5 above is incorrect as well. I had it fixed too.
>> Looks like I've lost another squash commit last night.
>> Sorry about that.
>=20
> Argh. Now I see what happened.
> I squashed it into patch 3 instead of patch 2. sorry.

Found them in 03/17. Keep reading... :)

Song
