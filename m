Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD33105D9F
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 01:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfKVAW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 19:22:28 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20866 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbfKVAW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 19:22:28 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAM0ARm5024796;
        Thu, 21 Nov 2019 16:22:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=J7bvfFj7ufWCZjsPUoChvgY0dfDEYl0vY+MSXzezycQ=;
 b=TjtQBA2ia/4HidGY8xalja5uqYUcNBwWUiXbCUD0t5Oy25rmwj7vhIxScXcrW51f+UVC
 WvXTqqYqheIHuTvyntEpiySAd91ow1QTb0PjmVoha4UvH5yHZWxUncaPvpUtu6DpGSyz
 tLVfOk27E8KpmsH1JuBjkMSmTBw8XHpw5HI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wdxtm24py-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 16:22:07 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 21 Nov 2019 16:21:58 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Nov 2019 16:22:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E5SNCWYxILcg5ZWbVHzT6/+U4zISl5DBGhK+XIph+w/vUeVoDJMSyLUMwCYq3ci9AYpoOvrCmqGXWF8i7O5DPVya+TocAjF6rulyfcQnduynhjNNSvrsmNqwaMuYHrH0m7KJDFKa+Y9f+OoH3Zy/Psk8Q3+0+xa4EmisIG7vkP9T5c8fTiv14rUIO3hV8PXAPvMCyNRYk7xy7RRhxt1fXnBpg14zx6b2U9obzUV1qe/rXzb37AZerv5KMPHmS+snzmZ/6gftBgMxQ/EHGNtQTJfeXBBawcaefnBrazUqzxlzu300TSd3TuJFJOvDBd9x8p7Qv/xcVuDWBYvZRV+nRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7bvfFj7ufWCZjsPUoChvgY0dfDEYl0vY+MSXzezycQ=;
 b=TeiFrRPKoK0I625Aj/ovCAFEM9O0V0zk5MycffTXglWbCEyovLuObevBI8JS63RGheUkBzBAaTYRRuduQKZM6PQbnVNngEMpSyHI8FlT/egbTldsLSMH478igp5YBvwGfJKyrweOpnpLh9Rkc5oyiemwMyi5haI977VjBgaJSei+rHMLjhrjd5VCO0POp14179zubbAh3RgiOvH6k3N3MIovoXuHHhHgQ4GzxqAWieV3rDYmG1xIO62kwAtjNPCuykPaj+lXBZQmI0PSyqqXrIPa6Kps72NYxf5JGhyfB4xu24+8qKdw6htSuIcX0iPi/uqCqaQfC2nVn16TNjM9WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7bvfFj7ufWCZjsPUoChvgY0dfDEYl0vY+MSXzezycQ=;
 b=OtGxYLHU7Iqi2e7D4u2mMcivMXbihT54jiX9qk5d+T6gJ3W2tbvrLfP16hhes6SW7bXij6J/NRKw2TxhONaAiOSLSu5vtOIxnl+C1sCGnmIE/L7CCX776ge1bBB7rSOaWNdQREEqAW58lIzic7uKTs9wT/HU5+WCCVX0/zSH55c=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3255.namprd15.prod.outlook.com (20.179.57.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.30; Fri, 22 Nov 2019 00:22:05 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::a9f8:a9c0:854c:d680%4]) with mapi id 15.20.2474.019; Fri, 22 Nov 2019
 00:22:05 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>
CC:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 9/9] selftests/bpf: add batch ops testing to
 array bpf map
Thread-Topic: [PATCH v2 bpf-next 9/9] selftests/bpf: add batch ops testing to
 array bpf map
Thread-Index: AQHVnw/0rnKpbCfcfky9UVTXU5Cf8qeVctYAgACwXoCAADRlAA==
Date:   Fri, 22 Nov 2019 00:22:05 +0000
Message-ID: <5ff4bbe7-49ee-b6ad-cdf2-ff9ebd32fb09@fb.com>
References: <20191119193036.92831-1-brianvv@google.com>
 <20191119193036.92831-10-brianvv@google.com>
 <4688ba20-0730-7689-9332-aa0dcef5258e@fb.com>
 <CAMzD94SCUQTi=O694HN3Muh=F-NT81_C4kBnzyBu0pfoNi87DQ@mail.gmail.com>
In-Reply-To: <CAMzD94SCUQTi=O694HN3Muh=F-NT81_C4kBnzyBu0pfoNi87DQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:102:2::19) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:ffef]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 75c0cc94-6d19-4132-c110-08d76ee200dd
x-ms-traffictypediagnostic: BYAPR15MB3255:
x-microsoft-antispam-prvs: <BYAPR15MB32550CD499AC0AC9F7247BF2D3490@BYAPR15MB3255.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(366004)(39860400002)(376002)(136003)(189003)(199004)(7416002)(71190400001)(4326008)(46003)(14454004)(186003)(54906003)(86362001)(6512007)(71200400001)(2906002)(6116002)(31696002)(99286004)(25786009)(386003)(6506007)(31686004)(6246003)(53546011)(76176011)(52116002)(478600001)(102836004)(66556008)(64756008)(66476007)(66946007)(66446008)(6916009)(316002)(229853002)(14444005)(6486002)(6436002)(8676002)(305945005)(81166006)(81156014)(256004)(7736002)(5660300002)(2616005)(8936002)(11346002)(36756003)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3255;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dCXZMuvk7P5RhzEfG96i9Z8RqCpAR7QZDU1tNXmTjGWf99pZA7XBVeEqHjBVImB31Ku4Nlc21Gmcsy9GpqSfYe8mVjdYQ0Ht/CxP7BmJRP+Rr+c2J5BygRjnrfz3ZA+1HeBZAHVaVI6jFl4LXgyk1V5Vi94l/FHlCzyMm2U2uM8CemONzkMW/MsOvYvvFYR6hQ+aoc6uOEmunXgmSXQB18E8wfk1KNu28LGByrmcLGzQDz1Micl6hALMVa59eghMxLYa6NHDxj5r1V5qKc9JxBg92JPm3vyl3PJEK8dTzYwUpt3yEx5At4y0YdqnBEzW863m3dUI9VIdIx+YJrBmgkQ2ctRNSIwy2DDi9tEAcL+z5z73EQpNxGS5QUVFL3bpcSGh8fPtX91tIP6UqPZilCm0BPpMJSqZapJw0X/9N89pQCrB9iWFETldhCxGCDRY
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BA2A6CD134239A4193AB26305B1C5638@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c0cc94-6d19-4132-c110-08d76ee200dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 00:22:05.5429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wF9vbHrlQYbnQwj2C7VtYtXMAifZ4fBnrnk41+bvP32OElO5tqy0njpVenLAEtm5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3255
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-21_07:2019-11-21,2019-11-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 suspectscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=972
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911220000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDExLzIxLzE5IDE6MTQgUE0sIEJyaWFuIFZhenF1ZXogd3JvdGU6DQo+IFRoYW5rcyBm
b3IgcmV2aWV3aW5nIGl0IQ0KPiANCj4gT24gVGh1LCBOb3YgMjEsIDIwMTkgYXQgMTA6NDMgQU0g
WW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4gd3JvdGU6DQo+Pg0KPj4NCj4+DQo+PiBPbiAxMS8x
OS8xOSAxMTozMCBBTSwgQnJpYW4gVmF6cXVleiB3cm90ZToNCj4+PiBUZXN0ZWQgYnBmX21hcF9s
b29rdXBfYmF0Y2goKSBhbmQgYnBmX21hcF91cGRhdGVfYmF0Y2goKQ0KPj4+IGZ1bmN0aW9uYWxp
dHkuDQo+Pj4NCj4+PiAgICAgJCAuL3Rlc3RfbWFwcw0KPj4+ICAgICAgICAgLi4uDQo+Pj4gICAg
ICAgICAgIHRlc3RfbWFwX2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNoX2FycmF5OlBBU1MNCj4+PiAg
ICAgICAgIC4uLg0KPj4NCj4+IFRoZSB0ZXN0IGlzIGZvciBsb29rdXBfYmF0Y2goKSBhbmQgdXBk
YXRlX2JhdGNoKCkNCj4+IGFuZCB0aGUgdGVzdCBuYW1lIGFuZCBmdW5jIG5hbWUgaXMgbG9va3Vw
X2FuZF9kZWxldGVfYmF0Y2goKSwNCj4+IHByb2JhYmx5IHJlbmFtZSBpcyB0byBsb29rdXBfYW5k
X3VwZGF0ZV9iYXRjaF9hcnJheSgpPw0KPj4NCj4gWWVzLCB5b3UgYXJlIHJpZ2h0LCBJIHdpbGwg
Y2hhbmdlIHRoZSBuYW1lIGZvciBuZXh0IHZlcnNpb24uDQo+IA0KPj4gSXQgd291bGQgYmUgZ29v
ZCBpZiBnZW5lcmljIGxvb2t1cF9hbmRfZGVsZXRlX2JhdGNoKCkNCj4+IGFuZCBkZWxldGVfcGF0
Y2goKSBjYW4gYmUgdGVzdGVkIGFzIHdlbGwuDQo+PiBNYXliZSB0cmllZCB0byB1c2UgcHJvZ19h
cnJheT8NCj4gDQo+ICAgSSBkaWQgdGVzdCBnZW5lcmljX2xvb2t1cF9hbmRfZGVsZXRlX2JhdGNo
IHdpdGggaG1hcCBhbmQgaXQgd29ya2VkDQo+IGZpbmUgYmVjYXVzZSBJIGRpZG4ndCBoYXZlIGNv
bmN1cnJlbnQgZGVsZXRpb25zLg0KPiBCdXQgeWVzIEkgd2lsbCBhZGQgdGVzdHMgZm9yIGdlbmVy
aWMgZGVsZXRlIGFuZCBsb29rdXBfYW5kX2RlbGV0ZSwNCj4gbWF5YmUgZm9yIHRoZSB0cmllIG1h
cCAocHJvZ19hcnJheSBkb2Vzbid0IHN1cHBvcnQgbG9va3VwIGFuZyBoZW5jZQ0KPiBsb29rdXBf
YW5kX2RlbGV0ZSB3b24ndCBhcHBseSB0aGVyZSk/DQoNCnRyaWVfbWFwIGlzIGEgZ29vZCBjaG9p
Y2UuIEJhc2ljYWxseSBhbnkgbWFwIHdoaWNoIGNhbiBiZSB1c2VkIHRvIHRlc3QNCnRoaXMgQVBJ
Lg0K
