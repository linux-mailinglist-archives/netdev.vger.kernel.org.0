Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE1BA750C
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 22:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbfICUhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 16:37:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53350 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726589AbfICUhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 16:37:06 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x83KWptY001728;
        Tue, 3 Sep 2019 13:37:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LFxXicji6YwZSWsGPM2RLYemvVtGqLnSTZdPUjEpXaE=;
 b=ObAiaBjZuDafL5IFUWUpjeKzSsEveLBgRxYkzG2g0ooRbzYNnShLQd3ubqCkCycBQxBl
 8JArtgd2XTaeUSOyhghk7hRllK2X/q8NSePl05N7eZLJJXW/aLOCb2xAxNxHJ4c9x25s
 41FKde/mJ6QqgjVpIM48NlNi/ug17yEWSJs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2us5w5neqk-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 03 Sep 2019 13:37:03 -0700
Received: from ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 3 Sep 2019 13:36:52 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 3 Sep 2019 13:36:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VMtmIeo5+z/6wsrW74G2tGgMwyMcqbMBh0rRrd3LseObYIn4X5YAeryR4MJMVSWPnMycGm6BXzQRteydg8GDzjv7o8rU1J44oihWQXidv+yPCUEjdxJtnVtcM0R5XYolTCxPvzQLmLPIgZm04GlkVVCdtl/YIoevpIgR0R9iC6gpwFhk6jjt9MT3REoC9yvzM6gzWUonctdte7sE0cHuM/J/+GhNA8gBB7lkcva07sKh5UxbV4tA5m+MJfrhsB0wrQgVOCI2TZSYem0PR+4mxG5NVqYqI7bAUqTS3sYb9mMZK6nINwcRGqxI+meN8QA3wOu1qdBPzTtK+1um7Ja8+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFxXicji6YwZSWsGPM2RLYemvVtGqLnSTZdPUjEpXaE=;
 b=VXQctDSk4uXgEUKys+BQxmXJfE9pwsJdMR/1Yqt6LQPsowVifyxQM90w6El4tfoTe1Q/TRp0w021puUAuVaHSFz4ravzGKn6o8qJEGD7x8PYvKl3Y7j3B/+2gw66laGrw/AurDJPNUyQAHxwmSb1GmkqPI/x3pOV82OJ0BHZVOmVN5ESPxae5/dqKnJ0GzNinC0SwD0kRQE0xlot6bRLhFj4KPlvs4BejxQa0bwmrPVl4mSTsIrYsE+6hPAY2aP8Hfo1uzNpBq4v8VPIXy6rVM7RIQ6UAoNeKZILzL8i1de+y/xIl6CLyiMeYx7DqTKE2KaEgLDIlwbo6n/XoiRluA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LFxXicji6YwZSWsGPM2RLYemvVtGqLnSTZdPUjEpXaE=;
 b=YgJ5tVUwHcG+Pf/WxjTKWz/sGPdIXmykzofrdMjUTLaArd1ryqaIey+PzZo/rM6oXrMubdKhOhivW8XZ9zffXCe8Ii81Pvrq6Wv3nrXNm2pLhcZb8+ov2GKpV93ya7Gg4Bq1WchVW5JQgRdO3NgUL0ErDxZcJeyZB/DYqOqDT30=
Received: from BN8PR15MB3380.namprd15.prod.outlook.com (20.179.76.22) by
 BN8PR15MB2834.namprd15.prod.outlook.com (20.178.220.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Tue, 3 Sep 2019 20:36:49 +0000
Received: from BN8PR15MB3380.namprd15.prod.outlook.com
 ([fe80::ac59:4764:67d5:8f09]) by BN8PR15MB3380.namprd15.prod.outlook.com
 ([fe80::ac59:4764:67d5:8f09%7]) with mapi id 15.20.2220.022; Tue, 3 Sep 2019
 20:36:49 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Thread-Topic: [PATCH bpf-next V9 1/3] bpf: new helper to obtain namespace data
 from current task
Thread-Index: AQHVUgen0TRJjFwMbUCsjzJfHVP59ab5P2KAgACSqQCAAEGFAIAXCgt7gAADlwCACUpP8oAAHwmA
Date:   Tue, 3 Sep 2019 20:36:49 +0000
Message-ID: <45259b64-8db9-7cd8-e4f4-0b00b5370d3b@fb.com>
References: <20190813184747.12225-1-cneirabustos@gmail.com>
 <20190813184747.12225-2-cneirabustos@gmail.com>
 <13b7f81f-83b6-07c9-4864-b49749cbf7d9@fb.com>
 <20190814005604.yeqb45uv2fc3anab@dev00>
 <9a2cacad-b79f-5d39-6d62-bb48cbaaac07@fb.com>
 <CACiB22jyN9=0ATWWE+x=BoWD6u+8KO+MvBfsFQmcNfkmANb2_w@mail.gmail.com>
 <20190828203951.qo4kaloahcnvp7nw@ebpf-metal>
 <4faeb577-387a-7186-e060-f0ca76395823@fb.com>
 <20190828210333.itwtyqa5w5egnrwm@ebpf-metal>
 <20190903184502.2vpaqnoubbr7nnf6@ebpf-metal>
In-Reply-To: <20190903184502.2vpaqnoubbr7nnf6@ebpf-metal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR22CA0022.namprd22.prod.outlook.com
 (2603:10b6:300:ef::32) To BN8PR15MB3380.namprd15.prod.outlook.com
 (2603:10b6:408:a8::22)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:1b1f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ac348f7-700b-4d88-2594-08d730ae71ed
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR15MB2834;
x-ms-traffictypediagnostic: BN8PR15MB2834:
x-microsoft-antispam-prvs: <BN8PR15MB283495BACB0BE650D7104509D3B90@BN8PR15MB2834.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(376002)(39860400002)(136003)(366004)(189003)(199004)(66556008)(36756003)(71190400001)(71200400001)(14454004)(25786009)(4326008)(256004)(478600001)(66446008)(64756008)(66476007)(6246003)(66946007)(11346002)(6486002)(476003)(2616005)(86362001)(446003)(229853002)(6916009)(486006)(76176011)(8676002)(81156014)(102836004)(31696002)(81166006)(8936002)(53546011)(7736002)(386003)(6506007)(305945005)(6116002)(46003)(186003)(316002)(31686004)(5660300002)(54906003)(52116002)(1411001)(99286004)(6436002)(53936002)(6512007)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2834;H:BN8PR15MB3380.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tzujRTm2vA6Rdd9+b/gH5evlRI90z1tlryqVjMHBf+ckZzPIz0mPvHqdb50n1VspiKOyuc5komnpYSXLAlJc1AJ0/eFJYcpSqNE5TEEsTN3XHwpTzVs0p6x3zenLh486l55biWYw79Rk4rJdp0EsbkFEmyl0r0W7PZDs3Kq1Bazw08jKt1WVqtT3uYxLOnFKawwOSKGYiJrw2y5y3hQllNxCsMGeEHmvwEKp51HYDK9uc0qTtH1yNyLP5IrrNm/c29vG87o53gwHTx8nPBE/mZ0NLaP4ul9jph7ui09Y2zIxOpnrXGqDNULJHDPlPIBTR5ZJiv1IZUnPRp5qUsERGe9eho/rcUWldJXOUqPmhsQ/PECDykpABu28cKmQF6YEoJUDsjLgChE3LWRCj3/ZvgzcW84F50F5/Bak/geqTC4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <5219DFF77A6D43418DBA5715CC59E2B5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac348f7-700b-4d88-2594-08d730ae71ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 20:36:49.2602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fMuitTdNFjdGSfNI7ksfQzWfd77oEvJ2alj1hj4xdU15pMmg8VE0/MTHyI+XjHfi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2834
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-03_04:2019-09-03,2019-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 mlxlogscore=973 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909030206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMy8xOSAxMTo0NSBBTSwgQ2FybG9zIEFudG9uaW8gTmVpcmEgQnVzdG9zIHdyb3Rl
Og0KPiBIaSBZb25naG9uZywNCj4gDQo+Pj4gWWVzLCB0aGUgc2FtcGxlcy9icGYgdGVzdCBjYXNl
IGNhbiBiZSByZW1vdmVkLg0KPj4+IENvdWxkIHlvdSBjcmVhdGUgYSBzZWxmdGVzdCB3aXRoIHRy
YWNwb2ludCBuZXQvbmV0aWZfcmVjZWl2ZV9za2IsIHdoaWNoDQo+Pj4gYWxzbyB1c2VzIHRoZSBw
cm9wb3NlZCBoZWxwZXI/IG5ldC9uZXRpZl9yZWNlaXZlX3NrYiB3aWxsIGhhcHBlbiBpbg0KPj4+
IGludGVycnVwdCBjb250ZXh0IGFuZCBpdCBzaG91bGQgY2F0Y2ggdGhlIGlzc3VlIGFzIHdlbGwg
aWYNCj4+PiBmaWxlbmFtZV9sb29rdXAgc3RpbGwgZ2V0IGNhbGxlZCBpbiBpbnRlcnJ1cHQgY29u
dGV4dC4NCj4+DQo+IEZvciB0aGlzIG9uZSBzY2VuYXJpbyBJIGp1c3QgY3JlYXRlZCBhbm90aGVy
IHNlbGZ0ZXN0IHdpdGggdGhlIG9ubHkgZGlmZmVyZW5jZQ0KPiB0aGF0IHRoZSB0cmFjZXBvaW50
IGlzIC9uZXQvbmV0aWZfcmVjZWl2ZV9za2Igc28gdGhpcyBmYWlscyB3aXRoIC1FUEVSTS4NCj4g
SXMgdGhhdCBlbm91Z2g/Lg0KDQpUaGlzIHNob3VsZCBiZSBmaW5lLg0KDQo+IA0KPiBJIGhhdmUg
bWFkZSB0aGlzIGNvbW1lbnQgb24gaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oLCBtYXliZSBpcyB0
b28gdGVyc2U/DQo+IA0KPiBzdHJ1Y3QgYnBmX3BpZG5zX2luZm8gew0KPiAJX191MzIgZGV2Owkv
KiBkZXZfdCBmcm9tIC9wcm9jL3NlbGYvbnMvcGlkIGlub2RlICovDQo+IAlfX3UzMiBuc2lkOw0K
PiAJX191MzIgdGdpZDsNCj4gCV9fdTMyIHBpZDsNCj4gfTsNCg0KTGV0IHVzIGtlZXAgdGhlIGFi
b3ZlIGZvciBub3cuIEkgbWF5IGhhdmUgZnVydGhlciBjb21tZW50cyBiYXNlZCBvbg0KeW91ciB0
ZXN0IGNvZGUgd2hpY2ggdXNlcyAiZGV2Ii4NCg0KPiANCj4gSSdtIG9ubHkgbWlzc2luZyBjbGVh
cmluZyBvdXQgdGhvc2UgcXVlc3Rpb25zIHRvIGJlIHJlYWR5IHRvIHN1Ym1pdCB2MTEgb2YgdGhp
cyBwYXRjaC4NCg0KUGxlYXNlIGdvIGFoZWFkIHRvIHN1Ym1pdCB0aGUgbmV3IHZlcnNpb24uDQoN
ClRoYW5rcy4NCg==
