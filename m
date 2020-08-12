Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD555242C2A
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 17:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgHLP1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 11:27:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22222 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726447AbgHLP1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 11:27:01 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07CF8m0k007303;
        Wed, 12 Aug 2020 08:26:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tm+YTYskuQ3T1i1lAtGDOheN11XFy63adnTchDAPogU=;
 b=ROvkc+x3UFClJkNNU2krns4YbQCt+GFNsmW9Mk0IZhD/U7jQUvha6/t3KBPWsSG+Q6HU
 PrTZAmVC16UQFRu39IISuQSCjImvkwFbhYLRiirf5YmQEysFtGm0r3gD1EmF9ruhgKgd
 9nOSDi6uaqK+mIotjwpCptk0ik67hq/9ZqI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kfcs4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 12 Aug 2020 08:26:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 12 Aug 2020 08:26:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nhdx3oiIiypgIL9xeVfIwDfwfXuwAZJlpHWIWvtzJAvBLkoQ7ZT0oSpkKU3OQI4Mib2GKcP4VdjI7umS9Ja4DqT/D0jY882OAVYmZLX1vXen02lWCCpcNgaXQqDH2+dCFFRuLQWXhjxYQv08LOu+t39oak+Q2kU1ijXyn1Qn4Q0mnLr6LUxM8PKgFA+6+pEC7sMz/FMsfevctLfB8ioltD22bqBoOQf0GuBPt80hcABKcSQu1M1UKw4jm6cjL6cSrSJlTHw2M3uADVuxdNAZAnUBBZ2N2ywuX3vAgOXpfROZcepsI1CgwDQ/26BAy52oDOt/r26WN96Bxn9hekL1Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tm+YTYskuQ3T1i1lAtGDOheN11XFy63adnTchDAPogU=;
 b=LzbH+L640iDLDMKdgZFFFbrXLQenhVBePMrN0tMjkmZ9s/5SKwTfjBhnQ4qE5iImMYaKeDYLJ1x5p6/uDKOkei7oH0Di0gaA7Z8UFO4gyDO0oTIQyOAbOj6CHuvTcGQwxcpnSismZEGCRxZvINE8S4a8bYw3JJR3VL5lYZ85J12BHqjgF9xay1q2pBOGAhduYWlXTH629jrEZ/7wJPuzcTN7SA4uii4cuxs357YQ1v63L1wv1Zg6Es2zcbEur374809PEe07NjRctYvc0Sa0tmOsyZDRoxUMujawfnkARHtN0F3gAIfZTQmMhgX+vu6KSVGinLc8nXaaA9CPZF5MUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tm+YTYskuQ3T1i1lAtGDOheN11XFy63adnTchDAPogU=;
 b=VPsqcFo3FSLrZaIAOMynOz1TxQzqgx9OSCLGeFcXw3jIfPcNoi+o3OpHKS2BNzO14MX8IMnW0gCjDw7k9zldPOWCS9Va6YoZSDbh5hRm82BSwF8Jpe21bhDke0X8Xj2jI1vO17p3EgZVrhOIXUawxTmzmFlSqT921bQX/uubRtM=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2646.namprd15.prod.outlook.com (2603:10b6:a03:155::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.22; Wed, 12 Aug
 2020 15:26:43 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::119c:968d:fb22:66e]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::119c:968d:fb22:66e%4]) with mapi id 15.20.3261.026; Wed, 12 Aug 2020
 15:26:43 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC PATCH bpf-next] bpf: Iterate through all PT_NOTE sections
 when looking for build id
Thread-Topic: [RFC PATCH bpf-next] bpf: Iterate through all PT_NOTE sections
 when looking for build id
Thread-Index: AQHWcKR6wbf6sGirtEeRTemTlUmcHak0mKwA
Date:   Wed, 12 Aug 2020 15:26:43 +0000
Message-ID: <5238E896-6A88-4857-B8D4-3C2E8C4E9F2C@fb.com>
References: <20200812123102.20032-1-jolsa@kernel.org>
In-Reply-To: <20200812123102.20032-1-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.80.23.2.2)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:8f7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99835a5f-aca8-48b2-a8c7-08d83ed41e46
x-ms-traffictypediagnostic: BYAPR15MB2646:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB264668A97637C1E0777FFCBAB3420@BYAPR15MB2646.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TWG78fhM7QG8lN3Wp1h5h83eygcK0tPlzwEa/1FFKDxrqZsTOpE9X1SQ/X/k/UWb5eIvqUmWfRN6JcC+tHhY7sy5pCdJBS6JaBGJbfWfzQxi/S6QNRR881wCyN0rdAANKJhrNcjcXdR9n506RCWJJvlnG/OnuPI6do8hrMqANT1aBjQxWAh2YAp5Wc+AwknGX75740Gp4Vu3CSOy1E3ckKiK+QRhx0plA0O7BwT1IW5S1QAX1v5ljHB6ABpxGTNk3amdu3bHvtYeWcW4OiB48OQIvWGi21q/K53vjiXRDiXaffZlh13gYwjdFIxearC53ffnbpUiDSR/dbv7j5UkVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(366004)(396003)(376002)(39860400002)(186003)(66946007)(66446008)(64756008)(66476007)(6486002)(76116006)(71200400001)(6512007)(4326008)(66556008)(6916009)(2906002)(36756003)(53546011)(8676002)(5660300002)(316002)(33656002)(6506007)(2616005)(8936002)(86362001)(478600001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xL0mMDGCBYyE/wrznuVUWRYY4MVF93izamp3xf3uxNW/EctgUo8Y1NjY/QFSEgrIimyN63jgObOrKkXGAQcciJaNGLGyd+UKvAvF90ap77LM6Gnz/ERJzI6ymv0lPjWOP1bbKT8/MwuEr8n0falpdEX6Y8uZuPSpc2KgFgffmICRqQfObj1UwcSUBS2fYFAV9JPiryXrsvf6ys1AmBK6yxva3OwaHXZIQVwxczuT45k1cUvEsZMWy96W49pyeSey7mKbb1/oFVLVrEjPA8lAeH0SxCy+ce8WhEI2U8OWha/Sv/1fH9x85261SaMWdJEqvuO9+5O5v4tSScBoAz449aD88gSZW7hjTce/GhSMIJhDJa8J0m2hjoCA+wPZEod4mHM2lLC+P+zD+V0aZ9p1aJcSRoXhIcpFcrpDmj6rDD3PBb79daF3pQKm3fC9lu80WxTTLSX3mZenkVNFuGn2HYvr+l+usYV2s9Ckjk9cQvxtjudJxjkGDB6v7dP+Mtag9dYqIXL2n+R29gF3xtV5QvZOxHwtTRawvhMhz6Mnl/zP4JdTq8ZrDGa/7ICZ1cAhHbFYyqP2MFqArgN3RnJ5g6N4LOr/9yr9SrLn5+EEsYZCWxeT70LXMXbpoj1ZnE0qxvcA/PvD63QOreQYJpF6WK9BSU4bz1NIlGoFX9Gwb8Y=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9B764552574D7344BE012B98C9CCD7B6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99835a5f-aca8-48b2-a8c7-08d83ed41e46
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2020 15:26:43.3512
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t8xHvQoJK2QeI5p47ASwgIE5Gbc7MPfYsAAwhqrW2kqtRnIpTedzkxGLCPw4hnAlqcnRORfVj3428pacR87S5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2646
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-12_09:2020-08-11,2020-08-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2008120107
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 12, 2020, at 5:31 AM, Jiri Olsa <jolsa@kernel.org> wrote:
>=20
> Currently when we look for build id within bpf_get_stackid helper
> call, we check the first NOTE section and we fail if build id is
> not there.
>=20
> However on some system (Fedora) there can be multiple NOTE sections
> in binaries and build id data is not always the first one, like:
>=20
>  $ readelf -a /usr/bin/ls
>  ...
>  [ 2] .note.gnu.propert NOTE             0000000000000338  00000338
>       0000000000000020  0000000000000000   A       0     0     8358
>  [ 3] .note.gnu.build-i NOTE             0000000000000358  00000358
>       0000000000000024  0000000000000000   A       0     0     437c
>  [ 4] .note.ABI-tag     NOTE             000000000000037c  0000037c
>  ...
>=20
> So the stack_map_get_build_id function will fail on build id retrieval
> and fallback to BPF_STACK_BUILD_ID_IP.
>=20
> This patch is changing the stack_map_get_build_id code to iterate
> through all the NOTE sections and try to get build id data from
> each of them.
>=20
> When tracing on sched_switch tracepoint that does bpf_get_stackid
> helper call kernel build, I can see about 60% increase of successful
> build id retrieval. The rest seems fails on -EFAULT.
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

LGTM. Thanks for the fix!

Acked-by: Song Liu <songliubraving@fb.com>


