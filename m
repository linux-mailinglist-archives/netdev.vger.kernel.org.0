Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26929A408A
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbfH3WY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:24:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51196 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728164AbfH3WY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 18:24:58 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7UMK3vp020137;
        Fri, 30 Aug 2019 15:24:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=FNK2GCKbxGFceQZI01mUV1z6fRqq8ww6onOwU798tWo=;
 b=b0xYeNqH8cQJTCRIgNkVnDS7epuIDjws+ZL0et7ZzXccf4IXjek3Z6kmQr0ps00wEWSi
 5i35VZ5EgA1MLdr4cnz3RbuPIp7fmceLZvVGXCUiIgYCo7lZGzBr1NI6tKzt5u7YA3C1
 hwYba0IlBSz/H4H2DRkYFh649xjDofpNJZ8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ups2kn5xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 30 Aug 2019 15:24:33 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 30 Aug 2019 15:24:32 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 30 Aug 2019 15:24:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M71aDfS+d94XrtkK7mH+OBus4ceJT7va6DALolO7BaL7V0lG5Lx8rR2SYSRbSfQ0443fxr8r+IA0ZMLhJAoNI1J1xtcvDH+GTSl0eiOq+J+MpU86ZPM09C5dj5T1bjWD5B6RTTPRUBIqwE78Fqf3zIa/IJuJ2ZHgTcVBj+z9RZNU3pYxcmEAKxh1z6tLHDah+OEVvsa65DhdFY7mL4rorn8GYbJhDiNH1oWilMbOksCSi8X7EaYnrLgxYKsLf0xAOjeCeiCy7nEQcpcabpDdltl8goaW07nbbhNsWrZJ/Zh0P1Lg7QmZxeHcg/fWNA3I0S6QX/FSQUGeAjNsmXBfrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNK2GCKbxGFceQZI01mUV1z6fRqq8ww6onOwU798tWo=;
 b=erYke8jCBOiIrR/GhdgqpZ0ZcrqvAAiSgW58VLoMFo6Sa0NQbE232ysz6wcEPY6U0vv0ihTLgJZlV3QqGwihCeXZyJY9RTECXkWqvvKG2bDx60Bc2y+FQZbSyFJ2GrO6FwreYVSAbTviQPKM9N9VWYhRQe2P9cZg7/CJ9cKJ2L1LsSf06qSNyfKX4c5Ajrqe6spup2Xm+LmRnOB49i4McNyeSpREGngu2Iiray7Y4Y2hlG/KfXYwCcOPMHdr9gzSS8dtbuQb825WDPJ73f3KkWKeVCc5wwfXrI8Qije0KfdKIXZk4COeyjO/kE/hSyyGCPwTA4GcLwLfoyLjxAACBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNK2GCKbxGFceQZI01mUV1z6fRqq8ww6onOwU798tWo=;
 b=Q4IRLlnQlVnWwOwsq/+4hBgyvmh6LZiC7IZOKeS2M8hZsGUMzTViDX4gQPc2TR8WMsz1H7o4NUpi4fRlfnCDzSgNM+7kIvJg9KvnHBQcLQlGliuY6U/smIRzwmyAmu0Jst1/NxYdxby4916KaiWMwjjIpw2q5D9Jb07gqqYbBX8=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3399.namprd15.prod.outlook.com (20.179.59.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.19; Fri, 30 Aug 2019 22:24:31 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::d95b:271:fa7e:e978%5]) with mapi id 15.20.2220.013; Fri, 30 Aug 2019
 22:24:31 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Stanislav Fomichev <sdf@fomichev.me>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Thread-Topic: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Thread-Index: AQHVXjVV7RBe3Y+1zUuAbrXegepHf6cSdccAgABMroCAABEcgIABT0aAgAALQgCAAAQqAIAAFK6A
Date:   Fri, 30 Aug 2019 22:24:30 +0000
Message-ID: <6e230a98-34b1-80aa-799b-f0831baa3741@fb.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829113932.5c058194@cakuba.netronome.com>
 <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
 <20190829171513.7699dbf3@cakuba.netronome.com>
 <20190830201513.GA2101@mini-arch>
 <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com>
 <20190830141024.743c8d02@cakuba.netronome.com>
In-Reply-To: <20190830141024.743c8d02@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2001CA0005.namprd20.prod.outlook.com
 (2603:10b6:301:15::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:dd98]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54b8e0ef-16f7-4b7c-9148-08d72d98d3c8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3399;
x-ms-traffictypediagnostic: BYAPR15MB3399:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33994141AC897FF5B550B9FCD3BD0@BYAPR15MB3399.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0145758B1D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(39860400002)(346002)(376002)(189003)(199004)(46003)(31686004)(76176011)(6116002)(52116002)(446003)(53936002)(6512007)(7736002)(8936002)(8676002)(305945005)(2906002)(14454004)(86362001)(478600001)(6436002)(31696002)(36756003)(71200400001)(476003)(256004)(53546011)(229853002)(486006)(386003)(11346002)(102836004)(6506007)(4326008)(2616005)(25786009)(4744005)(81156014)(5660300002)(6916009)(54906003)(81166006)(99286004)(66446008)(6486002)(186003)(64756008)(66476007)(66556008)(316002)(6246003)(71190400001)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3399;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IKScyTMxSeixK73LYudoSiiCcce3VXHAoCxTIx5kSil53sPt/8sz+rhlmPGmM9cjiPmwWMiqkOvdC/ODPuISYu3uCde0zktWzsxe9oW4vwTNYZu8/TMCoEKh04aOZmIY3La4dqARO4R/HJfvGCbxksYnUjilelqmhetUBqN6+0yUUv6+WIYfZd1FAPUpOZrMv7oMMiY6Q3Bv8hmhQGM01teUKmICELzz4gcet0tCpw4TW0HtukQgDpKifjumyeWmB1GG0xdphxJyAAIH978X18pfMjTQj6ien6JqFWrBUsUDtHLSBHMt96lFAlscQ9Of7bKljatSofghjIUT5FfrGw0tJ3xYP/1kT3PkgOPnVL7O9IaZ/L5FXfwI8c9uSDnItCNl99NK2FdNYLcMI6UQQU1ATKeYv1P/r21BCYwFYr0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D6269FFC2AD66646A1B91A6DF148093F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 54b8e0ef-16f7-4b7c-9148-08d72d98d3c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2019 22:24:31.0308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EwRuzsC2hzR7VKBh8SDFBg0856h5qOb+QG3immi1LJ7exphCEycPBS202UmN6WtS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3399
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-08-30_09:2019-08-29,2019-08-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 clxscore=1015 mlxlogscore=907
 priorityscore=1501 adultscore=0 spamscore=0 malwarescore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1908300216
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDgvMzAvMTkgMjoxMCBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIEZyaSwg
MzAgQXVnIDIwMTkgMjA6NTU6MzMgKzAwMDAsIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+Pj4gSSBn
dWVzcyB5b3UgY2FuIGhvbGQgb2ZmIHRoaXMgc2VyaWVzIGEgYml0IGFuZCBkaXNjdXNzIGl0IGF0
IExQQywNCj4+PiB5b3UgaGF2ZSBhIHRhbGsgZGVkaWNhdGVkIHRvIHRoYXQgOi0pIChhbmQgYWZh
aXUsIHlvdSBhcmUgYWxsIGdvaW5nKQ0KPj4NCj4+IEFic29sdXRlbHkuIFdlIHdpbGwgaGF2ZSBh
IGRpc2N1c3Npb24gb24gbWFwIGJhdGNoaW5nIGFuZCBJIHNpZ25lZA0KPj4gb24gd2l0aCB0aGF0
IDotKQ0KPiANCj4gRldJVyB1bmZvcnR1bmF0ZWx5IG5laXRoZXIgUXVlbnRpbiBub3IgSSB3aWxs
IGJlIGFibGUgdG8gbWFrZSB0aGUgTFBDDQo+IHRoaXMgeWVhciA6KCBCdXQgdGhlIGlkZWEgaGFk
IGJlZW4gZmxvYXRlZCBhIGZldyB0aW1lcyAoSSdkIGNlcnRhaW5seQ0KPiBub3QgY2xhaW0gbW9y
ZSBhdXRob3JzaGlwIGhlcmUgdGhhbiBFZCBvciBBbGV4ZWkpLCBhbmQgaXMgc2ltcGxlIGVub3Vn
aA0KPiB0byBtb3ZlIGZvcndhcmQgb3ZlciBlbWFpbCAoSSBob3BlKS4NCg0KWWVzLCBsZXQgdXMg
Y29udGludWUgdG8gZGlzY3VzcyBvdmVyIGVtYWlscy4gOi0pDQo=
