Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE732315BAD
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234505AbhBJAxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:53:17 -0500
Received: from mail-vi1eur05on2067.outbound.protection.outlook.com ([40.107.21.67]:15577
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234641AbhBJAuy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 19:50:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpqAS0EKjlYxZC3L8qA3QovLkZrgeBA4s1FRge0e2qY=;
 b=OWIl9Bgqpt8DA2igCSo7LUNVXXJVQm+x82+ozbaeJUxbmOCe6/l2hr+MMgRoSpc9RK3PcHdU5jlOlpUBjCUOq6a69ywk7Lt75r1ScRjhuRhf9uNqpSforfP0K3Dn7z3q7ULaWTfjrd5pU3v1zqlMtD/bUXhdKZ6TZEB5/LPqsEM=
Received: from DB9PR06CA0028.eurprd06.prod.outlook.com (2603:10a6:10:1db::33)
 by PA4PR08MB5902.eurprd08.prod.outlook.com (2603:10a6:102:e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Wed, 10 Feb
 2021 00:49:59 +0000
Received: from DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:1db:cafe::54) by DB9PR06CA0028.outlook.office365.com
 (2603:10a6:10:1db::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend
 Transport; Wed, 10 Feb 2021 00:49:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT005.mail.protection.outlook.com (10.152.20.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3846.25 via Frontend Transport; Wed, 10 Feb 2021 00:49:59 +0000
Received: ("Tessian outbound e989e14f9207:v71"); Wed, 10 Feb 2021 00:49:59 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 0373bd5633dcef3e
X-CR-MTA-TID: 64aa7808
Received: from 75efda0022cb.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3135B719-BF4D-44DF-AEC9-41532641E056.1;
        Wed, 10 Feb 2021 00:49:54 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 75efda0022cb.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 10 Feb 2021 00:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDqrjOwsc6JJ9lSm3Sj5AH+hwnq2HwXJ4eT+byq8PEQ62ULNTElcuiJg+Y6r3x4/p6OOYxmcIDkihdzWmWzqdG/dCWNUoeWghuA2GWpxDivoczKE0pjbwsC43v/yVYBdeg9vb0dxstics+vnceX0vHARIRrS9RLC6cXL8UqRiYIMitjqDXw8aQH5o6JTXa7gt+JQZPHnIkd38snkMwWjPMm647UDRtRksz5IKMKfA8ZJBBfVhLHbUZEIaNKrpsMO6jqdfeb0QtBz6pAjG8IkUs9MUgvh9MYWOFBXPBgBo16Mz3A9BQw9eWBBmK2cV8kO1h51vR60NA9FHFs35ZpVyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpqAS0EKjlYxZC3L8qA3QovLkZrgeBA4s1FRge0e2qY=;
 b=Ux04L9WKJKsd+e6e66E1GFnU31NvWVqIyqNp1Kfa6cCCnnG3/lrwY45DoDEXCCeyNX+ncuQCPazFx9FU4tBB77I4ScWFJilMsiR+cl5c0/bLx2RQ/xjJy0ic1TOhzvEGLa8wO9iY6A3U6EYOdGShH6selwEeHaRmfNtaWyK3z7YClgVbUJFlomMQazcj83YPN72krRR/9VOyemlpHnfY4LkvQss4Wju0bN1hytaF4Icf7KqCBfOzfs3ec5/mipecVRDYLQ2lb1XRYnputmbynrYPdKnlpbJUyWw1mDnF1z4K5z45ULA0rJYvhhacfrtA0h/EJSvC/U9NtTNgxdFFuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UpqAS0EKjlYxZC3L8qA3QovLkZrgeBA4s1FRge0e2qY=;
 b=OWIl9Bgqpt8DA2igCSo7LUNVXXJVQm+x82+ozbaeJUxbmOCe6/l2hr+MMgRoSpc9RK3PcHdU5jlOlpUBjCUOq6a69ywk7Lt75r1ScRjhuRhf9uNqpSforfP0K3Dn7z3q7ULaWTfjrd5pU3v1zqlMtD/bUXhdKZ6TZEB5/LPqsEM=
Received: from AM0PR08MB3026.eurprd08.prod.outlook.com (2603:10a6:208:65::21)
 by AM0PR08MB4196.eurprd08.prod.outlook.com (2603:10a6:208:129::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Wed, 10 Feb
 2021 00:49:51 +0000
Received: from AM0PR08MB3026.eurprd08.prod.outlook.com
 ([fe80::c98b:a3ef:b40e:c8ae]) by AM0PR08MB3026.eurprd08.prod.outlook.com
 ([fe80::c98b:a3ef:b40e:c8ae%5]) with mapi id 15.20.3825.030; Wed, 10 Feb 2021
 00:49:51 +0000
From:   Daniel Kiss <Daniel.Kiss@arm.com>
To:     Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Jiri Olsa <jolsa@redhat.com>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Thread-Topic: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Thread-Index: AQHW/x+srwtZ81CPcEC+4vtMWq6t8qpQge2AgAANGIA=
Date:   Wed, 10 Feb 2021 00:49:51 +0000
Message-ID: <5F054B94-6CCC-49C8-887F-D4AD73989882@arm.com>
References: <20210209052311.GA125918@ubuntu-m3-large-x86>
 <CAEf4BzZV0-zx6YKUUKmecs=icnQNXJjTokdkSAoexm36za+wdA@mail.gmail.com>
 <CAEf4BzYvri7wzRnGH_qQbavXOx5TfBA0qx4nYVnn=YNGv+vNVw@mail.gmail.com>
 <CAEf4Bzax90hn_5axpnCpW+E6gVc1mtUgCXWqmxV0tJ4Ud7bsaA@mail.gmail.com>
 <20210209074904.GA286822@ubuntu-m3-large-x86> <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava> <YCKwxNDkS9rdr43W@krava> <YCLdJPPC+6QjUsR4@krava>
 <CAKwvOdnqx5-SsicRf01yhxKOq8mAkYRd+zBScSOmEQ0XJe2mAg@mail.gmail.com>
 <20210210000257.GA1683281@ubuntu-m3-large-x86>
In-Reply-To: <20210210000257.GA1683281@ubuntu-m3-large-x86>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [2001:4c4c:1b2a:1000:9c7d:1b80:7ac6:94b6]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 90d62858-fc7d-403d-3605-08d8cd5dcb3d
x-ms-traffictypediagnostic: AM0PR08MB4196:|PA4PR08MB5902:
X-Microsoft-Antispam-PRVS: <PA4PR08MB5902857950652870061E0546EC8D9@PA4PR08MB5902.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:8882;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Kf1QcfE1XPpGkTWwtlp4+7oL16rlL4pMi2U7P/MVg0PjKY2qSfoisCPmvCXYa7wXKn1ApkCy4d4vYCEOxkqH4CxJRZgWAHgnD07gwN0GbwXzfZ5shrj9W8crV+vXSczQREcc1cKRtHwPclbNcUWoJzsYqjxx6QfQ8Tzw6DMti86rnAkKJF84u5+RpEMfaeNZwZYwC7IsUmJhMJKQa4aUS13np6QaYS5rP37r0gjCKhW/C6Pg4Yk7qWW4vtPDxq/uWl5VZ1mUNv37Hf64o6tikF4PAmBGw1rh2qRZIxH7xEgmnO4J6H96Csyamj4rtfM8/PvWeR70QkVDKDoZYufHHptxaPY9CN3q0450F2DN/EmJNkWOXjA+ftlUaiRsMQ2ZZpDtixx1kSWRqy3Bu+9FKYlBSce0NCg/nd+a+PvpAo3cPAAYSR/R/IXHRf2b+6BeeD2V97/doy5FVEDLGdYaWIWQ5DYLas7F1kPDSNF9mI2CN+76CWIvbqQW+YoEpEZ+/vucaj5wWFZ0djah+3EUKvL4miL+Q8DI2brwxPae+1MGq9mCADV1KLDSutKFiUbUD2B2qQSbKjAqGjUmVNrpyQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB3026.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(396003)(346002)(366004)(376002)(136003)(64756008)(66446008)(66556008)(71200400001)(2616005)(76116006)(6506007)(110136005)(186003)(66946007)(6486002)(54906003)(66476007)(91956017)(53546011)(33656002)(83380400001)(8676002)(5660300002)(8936002)(316002)(6512007)(2906002)(478600001)(4326008)(86362001)(36756003)(7416002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VTlyNVZ5emU1YStONUxWYWV2QUc5Rk83V2d2YkgzNm5qOWZIMG9IREZZOFdw?=
 =?utf-8?B?STEyTms3djVDcmJjM3UybERmdk9ydVNIcVF1UTFLRWxxd1VEdkZMeHRSWlVl?=
 =?utf-8?B?TzNsc3FCTEtwYjZlZml1RHlGWmZqTmhreVNWaSt0TWphREVqV0dVSjBIMFkv?=
 =?utf-8?B?cGtaUExFeFdGdWd6TUN3REZReXFiVnJwdDRqWStjN1l3VVEzaDNxOUJNVEtJ?=
 =?utf-8?B?Y3ltbEpUbXgxRlIxcm42UjQwQlhUWmxzSytTWkowbFhMNzVqVXc1WXUyQmt1?=
 =?utf-8?B?Mzh0RTdwMEo3MVZNREQ2U2xBQlhoa1JkeFpUdUlWQ1FRdGdhdU93bDVHWW1o?=
 =?utf-8?B?TEpyMU1TTWhvQWJhNXJ5eGJXT1RUWXRUUjdhWWpsbEZVR3lXZ3dpMXlxL2JY?=
 =?utf-8?B?YkZrNUNBdStSM01Jdnk3aTFKNDk3ZHNuamtEYnh4MHRZSGlyTGNiREd6WTcy?=
 =?utf-8?B?c1REZXhhYTZQdU1PV1VrTmFPR0pnNHYzS2FCb0VoYzJjU0hXcDVHNEpEZEtF?=
 =?utf-8?B?T2tTTGFneklEaVZYL0NYS3JyN2JPSXNjNzg3bVRRN3plWHkxQXVOYmJHcjcy?=
 =?utf-8?B?SXlVb0tmTGpmMXY1cC9qM01JR3hJOGVVa3dMQXBLTnE5eGY2Nk1hWGRoUjQ1?=
 =?utf-8?B?OTJhcFgxNjR0aUFBUHM4SUpBQUxSZnpFZzRuMzBaRXJmdWs5L3p5N3JobDND?=
 =?utf-8?B?Vm1wd0JrZE9qakdPc1M4clNqb2FNcitybHFWUVlpc0pGdUQ1UWZ4UGdmaHhq?=
 =?utf-8?B?ZjYzTG1xQ1VMVzVKVllvbGxFdFV2ekI0V3l4amJzUytyUmtwREJJRXZrRHdV?=
 =?utf-8?B?VnlUQU5PRHJaN3NWamEyYnYxOEZvc1hCYjFRY1djRVI2N2hwckljMldZZ1kv?=
 =?utf-8?B?RVFoeHdpeXUvSksxZTVVRmVOTWRsL2psMFBhVElWWUVXZHlDdWlKVHZFdjE4?=
 =?utf-8?B?eGRsS0V3ZExjUkpURFh2eVJRb2JxbzZDOXFla3JIZUlCL0VBS1dNc2JNSEpF?=
 =?utf-8?B?MUptUWhKTzdnWGZ4VGIvQmlCdXdaNXhBQkxvNVk5d0tnMXpmSjB2dmNiUXpW?=
 =?utf-8?B?dGpJbW8zbi9zQkFJV2hUQkdYREZvL081NVFVSytSUTcxbkJHaEFpU3BEb1pQ?=
 =?utf-8?B?L25KVWxFQ0c0QnVGLyt4Y05DWnEwVUM4VS8yUU82Y2h5bS9IaU9JeWc1MXdm?=
 =?utf-8?B?b0ltQUNtTExHWlAwZGgxdGJRRHlUcEQ0SUlUcHBDOGlRVExCWEhMcEtZYmI0?=
 =?utf-8?B?L1p2U1BXdmhYUnpMNktVZ2pzQWV0YTB4dWw4MXduSmQxYnd1S1ROaXA1a01V?=
 =?utf-8?B?eE9MZVd1K3d1bDZoK0IyQ0ZwNXcxV0pCcGVrU2owczJQT1NxbFBaU2VXOUhw?=
 =?utf-8?B?LzNQdDJjZ0pmZUwxQW42SkhPMTB6akp4WFkxZytjTCtaR0VMSFpUSlVZUTVB?=
 =?utf-8?B?TGhRRHVpaVlYSFM5akE0KzdmVzc1ekVtYjVDR2JJWHkyYmpGRWxnbU9vMHRT?=
 =?utf-8?B?YkR1YXlyTXVMM2FOT2w5ZGlrZ3M2NEVsNUh1VjZSM3pUWUJxVDMyTmo3RFND?=
 =?utf-8?B?MjgxSVdnYUVJc0FSa2g2Mkx6VlhzMjlpMnpxaE96T1RBWisvY1hXNW1pZVI0?=
 =?utf-8?B?a3kxNWNyVDFDWkk2UmFUanZGZFNYWjF4WXFCZm1qQUhqeG5rS3Iyc0ZrMjBW?=
 =?utf-8?B?VFNtWmZrTzA5aU9jbitsVnV1TmtiVktGbkNZYXF2NDlneFpkUU53OXkyd1Jw?=
 =?utf-8?B?cEl2Y01mQTBJL1lmbHVNbis1Y2pITXZmL1RKdzdob04yNU9wTFpmVjBtVEJB?=
 =?utf-8?B?YzNFTG4xZFc5Q0NFd3FEU2dDaU9PM1p1WWF2NmtldSs5dWlaWXMxdDBpMDBo?=
 =?utf-8?B?VTNYRmNrZ2hhWTNNUk4wSUI4eDBtWWZJVHhSWWE4N0ZlUWc9PQ==?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <929DE5CD643C4C46BAB890495FCDD5B8@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4196
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: f5780b7e-610a-4c07-0c4c-08d8cd5dc62a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QNKwyadI3HM1W32OSt+Ju/QfEb3fYLqQET1hKD/sVnCB3ENL22A2719gc2rg7th4uNwXnrlA11sHO4P2KJu39XrNF/SCZBHjc6cakddrId0WIzjVvHyKCl+4iGMv//0Bw4Y+qma/YYzasEiE3GEHCR0buNu33zq4rPw4juVYqMd9jmRhYEOSyBGh6qeGUZUYtq4+Uj0KIBdcWUeyey0tM+jKZWy9UvSkYNoW3QN5WrxrWf8iT76rQkEXrk7bjtFtBybsh9lMUAZ2qSkdd7HifL+5m0Rj57kbxLrqNdnbsCT/IAdgQLatWbUeQLpc2qJEmG4yoBEVfoah9N8Z6I/euohHH7Y6tm4eB2SssVcVA0F3SWXA2XwTwzAvG0xxGcWzQOdmsEN0VvfEaC3tlDe9TdiTtkO9GyuneOP6g5y774UsGGdVxufLMpllEe35ZZSMmnzNBav6ovuSGG5k/jIa6Qvazz6OExGzYoF3pKrDA06pzo2OwIED5ECWdmhjYE/uvcUIEMoV/MmXH1Q6C5MAOjFLKKbed4q3nFfzgpT/QyPoeZOssihyzKyxGXcb72XbA/ofBHrCkrnMmzR7Ef1q1Vvu7oTLaau6CeFDMB5+DNKmCcIspyviwKFiXMJDj9x+XRg24xGc4973KrPyDMgo2o8mM82nlvAGQ+cWb7iHlFk=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39840400004)(136003)(396003)(36840700001)(46966006)(336012)(4326008)(33656002)(26005)(8936002)(86362001)(6486002)(5660300002)(81166007)(186003)(70586007)(6506007)(83380400001)(316002)(2616005)(36756003)(2906002)(107886003)(110136005)(6512007)(356005)(54906003)(53546011)(8676002)(478600001)(36860700001)(450100002)(82310400003)(47076005)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2021 00:49:59.8264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d62858-fc7d-403d-3605-08d8cd5dcb3d
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT005.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR08MB5902
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMTAgRmViIDIwMjEsIGF0IDAxOjAyLCBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0aGFu
QGtlcm5lbC5vcmc+IHdyb3RlOg0KPg0KPiBPbiBUdWUsIEZlYiAwOSwgMjAyMSBhdCAxMjowOToz
MVBNIC0wODAwLCBOaWNrIERlc2F1bG5pZXJzIHdyb3RlOg0KPj4gT24gVHVlLCBGZWIgOSwgMjAy
MSBhdCAxMTowNiBBTSBKaXJpIE9sc2EgPGpvbHNhQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+DQo+
Pj4gT24gVHVlLCBGZWIgMDksIDIwMjEgYXQgMDU6MTM6NDJQTSArMDEwMCwgSmlyaSBPbHNhIHdy
b3RlOg0KPj4+PiBPbiBUdWUsIEZlYiAwOSwgMjAyMSBhdCAwNDowOTozNlBNICswMTAwLCBKaXJp
IE9sc2Egd3JvdGU6DQo+Pj4+DQo+Pj4+IFNOSVANCj4+Pj4NCj4+Pj4+Pj4+PiAgICAgICAgICAg
ICAgICBEV19BVF9wcm90b3R5cGVkICAgICAgICAodHJ1ZSkNCj4+Pj4+Pj4+PiAgICAgICAgICAg
ICAgICBEV19BVF90eXBlICAgICAgKDB4MDFjZmRmZTQgImxvbmcgaW50IikNCj4+Pj4+Pj4+PiAg
ICAgICAgICAgICAgICBEV19BVF9leHRlcm5hbCAgKHRydWUpDQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+
DQo+Pj4+Pj4+PiBPaywgdGhlIHByb2JsZW0gYXBwZWFycyB0byBiZSBub3QgaW4gRFdBUkYsIGJ1
dCBpbiBtY291bnRfbG9jIGRhdGEuDQo+Pj4+Pj4+PiB2ZnNfdHJ1bmNhdGUncyBhZGRyZXNzIGlz
IG5vdCByZWNvcmRlZCBhcyBmdHJhY2UtYXR0YWNoYWJsZSwgYW5kIHRodXMNCj4+Pj4+Pj4+IHBh
aG9sZSBpZ25vcmVzIGl0LiBJIGRvbid0IGtub3cgd2h5IHRoaXMgaGFwcGVucyBhbmQgaXQncyBx
dWl0ZQ0KPj4+Pj4+Pj4gc3RyYW5nZSwgZ2l2ZW4gdmZzX3RydW5jYXRlIGlzIGp1c3QgYSBub3Jt
YWwgZ2xvYmFsIGZ1bmN0aW9uLg0KPj4+Pj4+DQo+Pj4+Pj4gcmlnaHQsIEkgY2FuJ3Qgc2VlIGl0
IGluIG1jb3VudCBhZHJlc3Nlcy4uIGJ1dCBpdCBiZWdpbnMgd2l0aCBpbnN0cnVjdGlvbnMNCj4+
Pj4+PiB0aGF0IGFwcGVhcnMgdG8gYmUgbm9wcywgd2hpY2ggd291bGQgc3VnZ2VzdCBpdCdzIHRy
YWNlYWJsZQ0KPj4+Pj4+DQo+Pj4+Pj4gIGZmZmY4MDAwMTAzMWY0MzAgPHZmc190cnVuY2F0ZT46
DQo+Pj4+Pj4gIGZmZmY4MDAwMTAzMWY0MzA6IDVmIDI0IDAzIGQ1ICAgaGludCAgICAjMzQNCj4+
Pj4+PiAgZmZmZjgwMDAxMDMxZjQzNDogMWYgMjAgMDMgZDUgICBub3ANCj4+Pj4+PiAgZmZmZjgw
MDAxMDMxZjQzODogMWYgMjAgMDMgZDUgICBub3ANCj4+Pj4+PiAgZmZmZjgwMDAxMDMxZjQzYzog
M2YgMjMgMDMgZDUgICBoaW50ICAgICMyNQ0KPj4+Pj4+DQo+Pj4+Pj4+Pg0KPj4+Pj4+Pj4gSSdk
IGxpa2UgdG8gdW5kZXJzdGFuZCB0aGlzIGlzc3VlIGJlZm9yZSB3ZSB0cnkgdG8gZml4IGl0LCBi
dXQgdGhlcmUNCj4+Pj4+Pj4+IGlzIGF0IGxlYXN0IG9uZSBpbXByb3ZlbWVudCB3ZSBjYW4gbWFr
ZTogcGFob2xlIHNob3VsZCBjaGVjayBmdHJhY2UNCj4+Pj4+Pj4+IGFkZHJlc3NlcyBvbmx5IGZv
ciBzdGF0aWMgZnVuY3Rpb25zLCBub3QgdGhlIGdsb2JhbCBvbmVzIChnbG9iYWwgb25lcw0KPj4+
Pj4+Pj4gc2hvdWxkIGJlIGFsd2F5cyBhdHRhY2hhYmxlLCB1bmxlc3MgdGhleSBhcmUgc3BlY2lh
bCwgZS5nLiwgbm90cmFjZQ0KPj4+Pj4+Pj4gYW5kIHN0dWZmKS4gV2UgY2FuIGVhc2lseSBjaGVj
ayB0aGF0IGJ5IGxvb2tpbmcgYXQgdGhlIGNvcnJlc3BvbmRpbmcNCj4+Pj4+Pj4+IHN5bWJvbC4g
QnV0IEknZCBsaWtlIHRvIHZlcmlmeSB0aGF0IHZmc190cnVuY2F0ZSBpcyBmdHJhY2UtYXR0YWNo
YWJsZQ0KPj4+Pj4NCj4+Pj4+IEknbSBzdGlsbCB0cnlpbmcgdG8gYnVpbGQgdGhlIGtlcm5lbC4u
IGhvd2V2ZXIgOy0pDQo+Pj4+DQo+Pj4+IEkgZmluYWxseSByZXByb2R1Y2VkLi4gaG93ZXZlciBh
cm0ncyBub3QgdXNpbmcgbWNvdW50X2xvYw0KPj4+PiBidXQgc29tZSBvdGhlciBzcGVjaWFsIHNl
Y3Rpb24uLiBzbyBpdCdzIG5ldyBtZXNzIGZvciBtZQ0KPj4+DQo+Pj4gc28gZnRyYWNlIGRhdGEg
YWN0dWFseSBoYXMgdmZzX3RydW5jYXRlIGFkZHJlc3MgYnV0IHdpdGggZXh0cmEgNCBieXRlczoN
Cj4+Pg0KPj4+ICAgICAgICBmZmZmODAwMDEwMzFmNDM0DQo+Pj4NCj4+PiByZWFsIHZmc190cnVu
Y2F0ZSBhZGRyZXNzOg0KPj4+DQo+Pj4gICAgICAgIGZmZmY4MDAwMTAzMWY0MzAgZyAgICAgRiAu
dGV4dCAgMDAwMDAwMDAwMDAwMDE2OCB2ZnNfdHJ1bmNhdGUNCj4+Pg0KPj4+IHZmc190cnVuY2F0
ZSBkaXNhc206DQo+Pj4NCj4+PiAgICAgICAgZmZmZjgwMDAxMDMxZjQzMCA8dmZzX3RydW5jYXRl
PjoNCj4+PiAgICAgICAgZmZmZjgwMDAxMDMxZjQzMDogNWYgMjQgMDMgZDUgICBoaW50ICAgICMz
NA0KPj4+ICAgICAgICBmZmZmODAwMDEwMzFmNDM0OiAxZiAyMCAwMyBkNSAgIG5vcA0KPj4+ICAg
ICAgICBmZmZmODAwMDEwMzFmNDM4OiAxZiAyMCAwMyBkNSAgIG5vcA0KPj4+ICAgICAgICBmZmZm
ODAwMDEwMzFmNDNjOiAzZiAyMyAwMyBkNSAgIGhpbnQgICAgIzI1DQo+Pj4NCj4+PiB0aGF0cyB3
aHkgd2UgZG9uJ3QgbWF0Y2ggaXQgaW4gcGFob2xlLi4gSSBjaGVja2VkIGZldyBvdGhlciBmdW5j
dGlvbnMNCj4+PiBhbmQgc29tZSBoYXZlIHRoZSBzYW1lIHByb2JsZW0gYW5kIHNvbWUgbWF0Y2gg
dGhlIGZ1bmN0aW9uIGJvdW5kYXJ5DQo+Pj4NCj4+PiB0aG9zZSB0aGF0IG1hdGNoIGRvbid0IGhh
dmUgdGhhdCBmaXJzdCBoaW50IGluc3RydWNpb24sIGxpa2U6DQo+Pj4NCj4+PiAgICAgICAgZmZm
ZjgwMDAxMDMyMWU0MCA8ZG9fZmFjY2Vzc2F0PjoNCj4+PiAgICAgICAgZmZmZjgwMDAxMDMyMWU0
MDogMWYgMjAgMDMgZDUgICBub3ANCj4+PiAgICAgICAgZmZmZjgwMDAxMDMyMWU0NDogMWYgMjAg
MDMgZDUgICBub3ANCj4+PiAgICAgICAgZmZmZjgwMDAxMDMyMWU0ODogM2YgMjMgMDMgZDUgICBo
aW50ICAgICMyNQ0KPj4+DQo+Pj4gYW55IGhpbnRzIGFib3V0IGhpbnQgaW5zdHJ1Y3Rpb25zPyA7
LSkNCj4+DQo+PiBhYXJjaDY0IG1ha2VzICpzb21lKiBuZXdlciBpbnN0cnVjdGlvbnMgcmV1c2Ug
dGhlICJoaW50IiBpZSAibm9wIg0KPj4gZW5jb2Rpbmcgc3BhY2UgdG8gbWFrZSBzb2Z0d2FyZSBi
YWNrd2FyZHMgY29tcGF0aWJsZSBvbiBvbGRlciBoYXJkd2FyZQ0KPj4gdGhhdCBkb2Vzbid0IHN1
cHBvcnQgc3VjaCBpbnN0cnVjdGlvbnMuICBJcyB0aGlzIEJUSSwgcGVyaGFwcz8gKFRoZQ0KPj4g
ZnVuY3Rpb24gaXMgcGVyaGFwcyB0aGUgZGVzdGluYXRpb24gb2YgYW4gaW5kaXJlY3QgY2FsbD8p
DQo+DQo+IEl0IHNlZW1zIGxpa2UgaXQuIFRoZSBpc3N1ZSBpcyBub3QgcmVwcm9kdWNpYmxlIHdo
ZW4NCj4gQ09ORklHX0FSTTY0X0JUSV9LRVJORUwgaXMgbm90IHNldC4NCj4NCmxsdm0tb2JqZHVt
cCAtLW1hdHRyPXBhIOKAlG1hdHRyPWJ0aSAtZCDigKYgd2lsbCBwcmludCBuZXcgbW5lbW9uaWMg
Zm9yIHRoZSBoaW50IHNwYWNlIGluc3RydWN0aW9ucy4NCg0KSXQgaXMgaW50ZW50aW9uYWwgdG8g
cHV0IGEgbGFuZGluZyBwYWQgKEJUSSkgYXQgdGhlIHZlcnkgYmVnaW5uaW5nIGZvciB0aGUgcGF0
Y2hhYmxlIGZ1bmN0aW9ucy4NCiAgICAgICBmZmZmODAwMDEwMzFmNDMwIDx2ZnNfdHJ1bmNhdGU+
Og0KICAgICAgIGZmZmY4MDAwMTAzMWY0MzA6IDVmIDI0IDAzIGQ1ICAgaGludCAgICAjMzQgLy8g
QlRJIEMgPOKAlCBsYW5kaW5nIHBhZCBmb3IgaW5kaXJlY3QgY2FsbHMuDQogICAgICAgZmZmZjgw
MDAxMDMxZjQzNDogMWYgMjAgMDMgZDUgICBub3AgICAvLyA84oCUIHRoZSB0byBiZSBwYXRjaGVk
IGFyZWEuDQogICAgICAgZmZmZjgwMDAxMDMxZjQzODogMWYgMjAgMDMgZDUgICBub3ANCiAgICAg
ICBmZmZmODAwMDEwMzFmNDNjOiAzZiAyMyAwMyBkNSAgIGhpbnQgICAgIzI1IC8vIHBhY2lhc3Ag
POKAlCBwcm90ZWN0aW5nIHRoZSBsaW5rIHJlZ2lzdGVyLi4NClRoZSBmdHJhY2UgZGF0YShmZmZm
ODAwMDEwMzFmNDM0KSBzZWVtcyBjb3JyZWN0IGJlY2F1c2UgaXQgc2hvdWxkIHBvaW50IHRvIHRo
ZSDigJxub3BzIi4NCg0KSFRIDQoNCkNoZWVycywNCkRhbmllbA0KDQpJTVBPUlRBTlQgTk9USUNF
OiBUaGUgY29udGVudHMgb2YgdGhpcyBlbWFpbCBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSBjb25m
aWRlbnRpYWwgYW5kIG1heSBhbHNvIGJlIHByaXZpbGVnZWQuIElmIHlvdSBhcmUgbm90IHRoZSBp
bnRlbmRlZCByZWNpcGllbnQsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBpbW1lZGlhdGVseSBh
bmQgZG8gbm90IGRpc2Nsb3NlIHRoZSBjb250ZW50cyB0byBhbnkgb3RoZXIgcGVyc29uLCB1c2Ug
aXQgZm9yIGFueSBwdXJwb3NlLCBvciBzdG9yZSBvciBjb3B5IHRoZSBpbmZvcm1hdGlvbiBpbiBh
bnkgbWVkaXVtLiBUaGFuayB5b3UuDQo=
