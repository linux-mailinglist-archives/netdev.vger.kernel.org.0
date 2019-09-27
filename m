Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C57C0D1E
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 23:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfI0VPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 17:15:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35580 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725789AbfI0VPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 17:15:48 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x8RLDeT6007829;
        Fri, 27 Sep 2019 14:15:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ceqPOS0TA1R8thoAAEOEdvWi7BGLAkHVcwSe3Wyx3/Q=;
 b=E58KgLAQi3h/8/RUzWVW9i7pVNeHMlUW03MApUFPMwcTVwmF9KyUlRzGBF7ZPyuAPSQA
 BN+6jB6FToicGqLcn2Cob0yBe2YSMEi/fxOW+LQF2EVbCA7VBucfkm9WqI95O58R/iw/
 R9CKTdtDSqBJpxM9IwU4zgAigguSf+rCnio= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2v9mph1uw7-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Sep 2019 14:15:30 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 27 Sep 2019 14:15:26 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 27 Sep 2019 14:15:26 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 27 Sep 2019 14:15:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtbnOY9aIwHPhY58Sz5PN71UdvSEENqsDIH884MWiXkCGlj5GM67zT9+R6SgJi48JC6vJwUMLA0PB1xWsD7LTVjd8RBPzXck6/euqFK9a11cRTGFrmCXrYMOnC9XL3+Q+GGz3D8Cu1/cTaCstz7Zq/y6sbsfVYQzy3A4uEvUB8m6WIPASBTClw0roV9Z4AwBbYtbkve7seS6T/g5njgLe4Zvozxd5SqXGAg/C4o2KzMxDO5PuW6FfrqJ4E6yQ7cqD8b81I5x0freUNLMG3KcHNMbdmbQ7RD63XxwZ5+54dKw/SjfZjB5i9IIGyc1d3KInDyfutv228ISeg1m4Wzfcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceqPOS0TA1R8thoAAEOEdvWi7BGLAkHVcwSe3Wyx3/Q=;
 b=m6bOIplSL/Q+oWDgHnP49Z2GTlH75fS2wHKIjghOf03UzpbsLUIiX89196MO8+f/TQmSKFujUFcP3ytPSH4OGPwLiLvbXL1XDGUAyrSDNzf2xXsY0pHQbXmcdxiENVxya2Lthd9rGgwRUlACAYWJ0IhtSJgKli1S+Wv6ksREMNZGDrdeNFl1duUibmM8lGDxPMx7jTee0gR9Fau/6jRMLqtwRBR+nWvLGIZLjiHFwtFr19C02AX1FAx2rT2q/hHZpnM+orsnyqDrZz0HtutgAOetUvqX4r8k3/haSzvvrhuJxQ8Z5yFNm/T3rSr97nlrAWJW38SLGRnQ4R6aQ8R39A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceqPOS0TA1R8thoAAEOEdvWi7BGLAkHVcwSe3Wyx3/Q=;
 b=QE023yxhQ4mxNveVhTE7pTOV4IeDFDP1Vp+UWEos5Tx8P6I1rNzQWxkRML3vgfhZ3RD2IDpf5H7D9vRy434MOA2wF9Hy6Lm7Mi4cVDMC6jWjOMDL/M4wTqhv8wgvjWJFaVU4lKZ7sJiHzPG7ImC57mBeOlk4lrlSC3KHJqhw9LM=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1453.namprd15.prod.outlook.com (10.173.234.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Fri, 27 Sep 2019 21:15:25 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.017; Fri, 27 Sep 2019
 21:15:24 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
CC:     Song Liu <liu.song.a23@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, "Yonghong Song" <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] tools: bpf: Use !building_out_of_srctree to determine
 srctree
Thread-Topic: [PATCH] tools: bpf: Use !building_out_of_srctree to determine
 srctree
Thread-Index: AQHVdNDXBxSGfE5tmEyE9kgIwPwciqc/3XAAgAAFZoCAACTiAA==
Date:   Fri, 27 Sep 2019 21:15:24 +0000
Message-ID: <57756C81-5B82-4E56-9CF0-5C1C4A4FBEFC@fb.com>
References: <20190927011344.4695-1-skhan@linuxfoundation.org>
 <CAPhsuW5EncjNRGjt7F_BN2bNhRkf=uXVeDe6NCbJe=K2J+hdyA@mail.gmail.com>
 <5ec40572-5df9-0e5b-5a85-eb53be48b87d@linuxfoundation.org>
In-Reply-To: <5ec40572-5df9-0e5b-5a85-eb53be48b87d@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:200::1:cdab]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 68c45fa1-16b5-4257-c9fe-08d7438fd042
x-ms-traffictypediagnostic: MWHPR15MB1453:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB14533876EBC7A220754C87C7B3810@MWHPR15MB1453.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0173C6D4D5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(51914003)(8676002)(478600001)(316002)(76116006)(64756008)(66446008)(36756003)(66556008)(66476007)(66946007)(81156014)(6246003)(14444005)(256004)(6486002)(4326008)(50226002)(76176011)(6436002)(8936002)(81166006)(6512007)(229853002)(71200400001)(86362001)(2616005)(446003)(11346002)(486006)(46003)(99286004)(71190400001)(305945005)(14454004)(6916009)(33656002)(476003)(7736002)(5660300002)(25786009)(186003)(2906002)(53546011)(102836004)(54906003)(6506007)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1453;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: heJ5Dq+R8fRhqy+zbV0eVu7LpK+eOf08edNY6+/2OotD1YQWSp6M814+a3R56V0/KJE5Xo0gPQMyDmBHDBIdcmo2wh/2MBLXcrnW9izbx5+hpbwmM7mc+lDp8xuVCufgfaWtzaBL2J4Lf7VeU2z8/FIEYmFVpA1bBR0LDoOskmTKv1XlmQzTShdhu1sFkUsjPe4NcIaTvf3zOzqDjP4FRplN2ecMcoimXx+p2TkK6D2pTXlSNH50FoGkoRQK9PNX6YNRx9E8cyZY42Q8lgF5Uv446xoRlMMNpDF1kqo0EWgr4M7BtKD0046teqJ1oEfx/vzfrjVvznHbZbgWxJ4N5ylEf/XUNDMj2qkFLBOAnAPVRjKk3DXxWtlVAnCrAIUUp0vrLXpv4dfgjS4VLR98+Y4XZSsMLtmci+WYmR1QJdY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6C6AF43DDFBD14B8925B24E4E06C797@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c45fa1-16b5-4257-c9fe-08d7438fd042
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2019 21:15:24.7497
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzT4P4ntiSByp0037Hqeyp9HcRNpcWjfzwI+C+C1Y/8lnA61cRaLkHWmozD7W+PEMOj8MaGjF0qAApqiN6hnSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1453
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-27_09:2019-09-25,2019-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 suspectscore=0 clxscore=1011 mlxlogscore=999 adultscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909270178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Sep 27, 2019, at 12:03 PM, Shuah Khan <skhan@linuxfoundation.org> wrot=
e:
>=20
> On 9/27/19 12:44 PM, Song Liu wrote:
>> On Thu, Sep 26, 2019 at 6:14 PM Shuah Khan <skhan@linuxfoundation.org> w=
rote:
>>>=20
>>> make TARGETS=3Dbpf kselftest fails with:
>>>=20
>>> Makefile:127: tools/build/Makefile.include: No such file or directory
>>>=20
>>> When the bpf tool make is invoked from tools Makefile, srctree is
>>> cleared and the current logic check for srctree equals to empty
>>> string to determine srctree location from CURDIR.
>>>=20
>>> When the build in invoked from selftests/bpf Makefile, the srctree
>>> is set to "." and the same logic used for srctree equals to empty is
>>> needed to determine srctree.
>>>=20
>>> Check building_out_of_srctree undefined as the condition for both
>>> cases to fix "make TARGETS=3Dbpf kselftest" build failure.
>>>=20
>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>> The fix looks reasonable. Thanks!
>> However, I am still seeing some failure:
>> make TARGETS=3Dbpf kselftest
>> [...]
>> test_verifier.c
>> /data/users/songliubraving/kernel/linux-git/tools/testing/selftests/bpf/=
test_stub.o
>> /data/users/songliubraving/kernel/linux-git/tools/testing/selftests/bpf/=
libbpf.a
>> -lcap -lelf -lrt -lpthread -o
>> /data/users/songliubraving/kernel/linux-git/tools/testing/selftests/bpf/=
test_verifier
>> make[3]: test_verifier.c: Command not found
>> Is this just a problem with my setup?
>=20
> You are running into the second bpf failure because of the dependency
> on the latest llvm. This is known issue with bpf test and it doesn't
> compile on 5.4 and maybe even 5.3
>=20

Thanks for the clarification.=20

Acked-by: Song Liu <songliubraving@fb.com>



