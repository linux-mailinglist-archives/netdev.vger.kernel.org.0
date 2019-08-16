Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60D468FA86
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 07:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfHPF4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 01:56:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11914 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726166AbfHPF4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 01:56:49 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7G5runs027062;
        Thu, 15 Aug 2019 22:56:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=kWal1GjVCRKuz0W/IfWFyGfTVFqKaHX5Clzafw2II6g=;
 b=FmBhI/+8yft8pQxvzxjWORcGx4pj9M1Ym9DS0v6VZxNH5kTibxLqHvjJkAWfkOcHMd6A
 hPhR2smkZSK4qtBgav8B920TGOW51NYuZzkow00vT49lcfiU4yRcVBQlmETb+N9R9LhU
 JnbJItCcSxPHMG5XhT9CHAkDOB9fXcuQeI8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2udnkp869k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 15 Aug 2019 22:56:23 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 15 Aug 2019 22:56:22 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 15 Aug 2019 22:56:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyisf+Wah8ENtZqlmWhd6i4Elbi4JFuNr7CgZio+UoWaknARfdr76yXu59BlUo7g554a/91pfg4HnwUVl6e3+HqaMd8NdXyvHFCdOzHMvU2w5FNl5VrPMFPWWWnFrD/9yu3zL0uy7da0JWCfEaeGTRoasWD7uDWjfDJOXIrjLBtib7Q+dkpJS7GBHI/feUQ5o9UFVw1y2F6DLoEb0Bvq43P6MSkTOImQEhOaHJnUi7p2x3tT1lHGz6xNSiCcMpcRSFQ+FaPOHwzlUqZfcwUFWalmKsW+HtewsiDUJJLYJuYtbfzOGiv6ClYtIBkmO7gFoREJNN2Vhiob7ExQutHVcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWal1GjVCRKuz0W/IfWFyGfTVFqKaHX5Clzafw2II6g=;
 b=gVzYPgCLFbtm937cd/Uif1qIdfe6sKB/uY3g7l+rDsdQkKtD/rpo/1sUZYfoKX10v/+HMlLDxE3WLDE36yVz19t5Q+ANR70qyxWyNM6VQ533JX0Fhr4quEeR0Dn4JhKrKV7vNbjg/BETo8M5ODrauUp7h+4C+Q8GfFs0nR6xy+VcXfPBl9cdnIvzEO2epTeLt3OBzHPSleKY5vV7uxOUd0kh98G8hjGDq2tJyk7Otp1eeuMeEe4TzyaJMh/ZprcC61JlTD0bio2SPSr039JVSfRzFdwnApgDyWoQV25ibTdSNho5pqmAFXePvKRbw2YCdDv6+Kxh+9QyeY7wRwBmUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kWal1GjVCRKuz0W/IfWFyGfTVFqKaHX5Clzafw2II6g=;
 b=hO0lrql+o3ZYroYy56jGPDqJZhHWn4x6iHNkAJ3XIIxnDcMCTl8YPMaISyDKSA60RM+pBPt5090J2lKXTtqzGnXDvWZnlC12lKA5DNFz9aqiqmZbJmL5O7+OfCb9JmP/oU4ojWIDm7fAOLclw4A6YGMmR24bGZgxkoE+x9l0J8I=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1279.namprd15.prod.outlook.com (10.175.4.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Fri, 16 Aug 2019 05:56:20 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::45ee:bc50:acfa:60a5%3]) with mapi id 15.20.2178.016; Fri, 16 Aug 2019
 05:56:20 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Andy Lutomirski <luto@amacapital.net>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Thread-Topic: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via
 /dev/bpf
Thread-Index: AQHVLSW5611trSWWQEuGSg4xXBva46awKSYAgAFFJoCAAehSgIACJsgAgAEbzICAARNPgIAANGYAgB9j6wCAATKggIAAgfQAgAAt2QCAAFEqAIAFfSwAgAPZeACAAQAYAIAAxVOAgAC4LoCAAl7hgIAEHsgAgAAfGQCAAF7NAIAAHpUAgACj0gCAACEJAIAAIrKAgAA/JgCAAdj4gIAKg7WAgAL/24CAAEL5gIAAEyuAgABUMgA=
Date:   Fri, 16 Aug 2019 05:56:20 +0000
Message-ID: <4F52274A-CD70-4261-A255-2C4A7E818141@fb.com>
References: <CALCETrUjh6DdgW1qSuSRd1_=0F9CqB8+sNj__e_6AHEvh_BaxQ@mail.gmail.com>
 <CALCETrWtE2U4EvZVYeq8pSmQjBzF2PHH+KxYW8FSeF+W=1FYjw@mail.gmail.com>
 <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXX-Jeb4wiQuL6FUai4wNMmMiUxuLLh_Lb9mT7h=0GgAw@mail.gmail.com>
 <20190805192122.laxcaz75k4vxdspn@ast-mbp>
 <CALCETrVtPs8gY-H4gmzSqPboid3CB++n50SvYd6RU9YVde_-Ow@mail.gmail.com>
 <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp> <201908151203.FE87970@keescook>
 <20190815234622.t65oxm5mtfzy6fhg@ast-mbp.dhcp.thefacebook.com>
 <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net>
In-Reply-To: <B0364660-AD6A-4E5C-B04F-3B6DA78B4BBE@amacapital.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::4a64]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00e30123-bd54-4240-80e2-08d7220e7675
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1279;
x-ms-traffictypediagnostic: MWHPR15MB1279:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB12799154B4790D09D869E9D4B3AF0@MWHPR15MB1279.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0131D22242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(136003)(39860400002)(346002)(396003)(189003)(199004)(6486002)(81166006)(6512007)(81156014)(66476007)(14444005)(256004)(6436002)(66946007)(8936002)(36756003)(50226002)(66446008)(66556008)(64756008)(8676002)(14454004)(446003)(11346002)(2616005)(476003)(46003)(99286004)(316002)(54906003)(71190400001)(486006)(76176011)(71200400001)(561944003)(186003)(102836004)(33656002)(53546011)(6506007)(478600001)(7416002)(5660300002)(2906002)(25786009)(305945005)(7736002)(6116002)(57306001)(4326008)(53936002)(229853002)(6246003)(76116006)(86362001)(66574012)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1279;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nNXX4fRfPzM4WNmd2ig3kuqijS3gF65gL0PsBZyKMJfwkiXyygwagczS/nfy2AVmG7FIFHJs3lT29uAr5TKXQpXC7cC03RvExgTeg0Kkx3PugUwdXZoqDjbQQKyIPoif9eQJqelbxgdnN4clk3eEY8weqFFmF7XiphGiA7057AQltQuBDxi9iUMfWCl5Y4s4CeI3gLhqPFW2GhqX8QHCh5gFMR6SRsWlvuxjY3YmtSFK+KdtEo1cOR8qd7nFJwAlf+IFjES78NAk/hlpS0MnIv+0XzQhZZDoRnrl7U/JxGhG87DnmvjYtIgJAJuhZOpi+wfa2RMDS8V5WeYVC2S/q988Rk9Ynmcp6BErtIHJrKVlje1uKstp6VCypDrRC7g05DVbgUvyOpUvBedBhx6cYmBLpVvn/wS5csQO38yCJ9Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5CAAA3EA589AD74FAB87425A3C3BEBA7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e30123-bd54-4240-80e2-08d7220e7675
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2019 05:56:20.6304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P48GhUIR5YUJGdDULSiH2VWyYv5mIET8vQgkZxHItbhur16OQfaso42FZLaBHCcdmXDGgHYyinwgKbqGe9uadQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1279
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-16_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908160064
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gQXVnIDE1LCAyMDE5LCBhdCA1OjU0IFBNLCBBbmR5IEx1dG9taXJza2kgPGx1dG9A
YW1hY2FwaXRhbC5uZXQ+IHdyb3RlOg0KPiANCj4gDQo+IA0KPj4gT24gQXVnIDE1LCAyMDE5LCBh
dCA0OjQ2IFBNLCBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5j
b20+IHdyb3RlOg0KPiANCj4gDQo+Pj4gDQo+Pj4gSSdtIG5vdCBzdXJlIHdoeSB5b3UgZHJhdyB0
aGUgbGluZSBmb3IgVk1zIC0tIHRoZXkncmUganVzdCBhcyBidWdneQ0KPj4+IGFzIGFueXRoaW5n
IGVsc2UuIFJlZ2FyZGxlc3MsIEkgcmVqZWN0IHRoaXMgbGluZSBvZiB0aGlua2luZzogeWVzLA0K
Pj4+IGFsbCBzb2Z0d2FyZSBpcyBidWdneSwgYnV0IHRoYXQgaXNuJ3QgYSByZWFzb24gdG8gZ2l2
ZSB1cC4NCj4+IA0KPj4gaG1tLiBhcmUgeW91IHNheWluZyB5b3Ugd2FudCBrZXJuZWwgY29tbXVu
aXR5IHRvIHdvcmsgdG93YXJkcw0KPj4gbWFraW5nIGNvbnRhaW5lcnMgKG5hbWVzcGFjZXMpIGJl
aW5nIGFibGUgdG8gcnVuIGFyYml0cmFyeSBjb2RlDQo+PiBkb3dubG9hZGVkIGZyb20gdGhlIGlu
dGVybmV0Pw0KPiANCj4gWWVzLg0KPiANCj4gQXMgYW4gZXhhbXBsZSwgU2FuZHN0b3JtIHVzZXMg
YSBjb21iaW5hdGlvbiBvZiBuYW1lc3BhY2VzICh1c2VyLCBuZXR3b3JrLCBtb3VudCwgaXBjKSBh
bmQgYSBtb2RlcmF0ZWx5IHBlcm1pc3NpdmUgc2VjY29tcCBwb2xpY3kgdG8gcnVuIGFyYml0cmFy
eSBjb2RlLiBOb3QganVzdCBsaXR0bGUgc25pcHBldHMsIGVpdGhlciDigJQgbm9kZS5qcywgTW9u
Z28sIE15U1FMLCBNZXRlb3IsIGFuZCBvdGhlciBmYWlybHkgaGVhdnl3ZWlnaHQgc3RhY2tzIGNh
biBhbGwgcnVuIHVuZGVyIFNhbmRzdG9ybSwgd2l0aCB0aGUgd2hvbGUgc3RhY2sgKGRhdGFiYXNl
IGVuZ2luZSBiaW5hcmllcywgZXRjKSBzdXBwbGllZCBieSBlbnRpcmVseSB1bnRydXN0ZWQgY3Vz
dG9tZXJzLiAgRHVyaW5nIHRoZSB0aW1lIFNhbmRzdG9ybSB3YXMgdW5kZXIgYWN0aXZlIGRldmVs
b3BtZW50LCBJIGNhbiByZWNhbGwgKm9uZSogYnVnIHRoYXQgd291bGQgaGF2ZSBhbGxvd2VkIGEg
c2FuZGJveCBlc2NhcGUuIFRoYXTigJlzIGEgcHJldHR5IGdvb2QgdHJhY2sgcmVjb3JkLiAgKEFs
c28sIE1lbHRkb3duIGFuZCBTcGVjdHJlLCBzaWdoLikNCj4gDQo+IFRvIGJlIGNsZWFyLCBTYW5k
c3Rvcm0gZGlkIG5vdCBhbGxvdyBjcmVhdGlvbiBvZiBhIHVzZXJucyBieSB0aGUgdW50cnVzdGVk
IGNvZGUsIGFuZCBTYW5kc3Rvcm0gd291bGQgaGF2ZSBoZWF2aWx5IHJlc3RyaWN0ZWQgYnBmKCks
IGJ1dCB0aGF0IHNob3VsZCBvbmx5IGJlIG5lY2Vzc2FyeSBiZWNhdXNlIG9mIHRoZSBwb3NzaWJp
bGl0eSBvZiBrZXJuZWwgYnVncywgbm90IGJlY2F1c2Ugb2YgdGhlIG92ZXJhbGwgZGVzaWduLg0K
PiANCj4gQWxleGVpLCBJ4oCZbSB0cnlpbmcgdG8gZW5jb3VyYWdlIHlvdSB0byBhaW0gZm9yIHNv
bWV0aGluZyBldmVuIGJldHRlciB0aGFuIHlvdSBoYXZlIG5vdy4gUmlnaHQgbm93LCBpZiB5b3Ug
Z3JhbnQgYSB1c2VyIHZhcmlvdXMgdmVyeSBzdHJvbmcgY2FwYWJpbGl0aWVzLCB0aGF0IHVzZXLi
gJlzIHN5c3RlbWQgY2FuIHVzZSBicGYgbmV0d29yayBmaWx0ZXJzLiAgWW91ciBwcm9wb3NhbCB3
b3VsZCBhbGxvdyB0aGlzIHdpdGggYSBkaWZmZXJlbnQsIGJ1dCBzdGlsbCB2ZXJ5IHN0cm9uZywg
c2V0IG9mIGNhcGFiaWxpdGllcy4gVGhlcmXigJlzIG5vdGhpbmcgd3Jvbmcgd2l0aCB0aGlzIHBl
ciBzZSwgYnV0IEkgdGhpbmsgeW91IGNhbiBhaW0gbXVjaCBoaWdoZXI6DQo+IA0KPiBDQVBfTkVU
X0FETUlOIGFuZCB5b3VyIENBUF9CUEYgYm90aCBlZmZlY3RpdmVseSBhbGxvdyB0aGUgaG9sZGVy
IHRvIHRha2Ugb3ZlciB0aGUgc3lzdGVtLCAqYnkgZGVzaWduKi4gIEnigJltIHN1Z2dlc3Rpbmcg
dGhhdCB5b3UgZW5nYWdlIHRoZSBzZWN1cml0eSBjb21tdW5pdHkgKEtlZXMsIG15c2VsZiwgQWxl
a3NhLCBKYW5uLCBTZXJnZSwgQ2hyaXN0aWFuLCBldGMpIHRvIGFpbSBmb3Igc29tZXRoaW5nIGJl
dHRlcjogbWFrZSBpdCBzbyB0aGF0IGEgbm9ybWFsIExpbnV4IGRpc3RybyB3b3VsZCBiZSB3aWxs
aW5nIHRvIHJlbGF4IGl0cyBzZXR0aW5ncyBlbm91Z2ggc28gdGhhdCBub3JtYWwgdXNlcnMgY2Fu
IHVzZSBicGYgZmlsdGVyaW5nIGluIHRoZSBzeXN0ZW1kIHVuaXRzIGFuZCBtYXliZSBldmVudHVh
bGx5IHVzZSBldmVuIG1vcmUgYnBmKCkgY2FwYWJpbGl0aWVzLiBBbmQgbGV04oCZcyBtYWtlIGlz
IHRvIHRoYXQgbWFpbnN0cmVhbSBjb250YWluZXIgbWFuYWdlcnMgKHRoYXQgdXNlIHVzZXJucyEp
IHdpbGwgYmUgd2lsbGluZyAoYXMgYW4gb3B0aW9uKSB0byBkZWxlZ2F0ZSBicGYoKSB0byB0aGVp
ciBjb250YWluZXJzLiBXZeKAmXJlIGhhcHB5IHRvIGhlbHAgZGVzaWduLCByZXZpZXcsIGFuZCBl
dmVuIHdyaXRlIGNvZGUsIGJ1dCB3ZSBuZWVkIHlvdSB0byBiZSB3aWxsaW5nIHRvIHdvcmsgd2l0
aCB1cyB0byBtYWtlIGEgZGVzaWduIHRoYXQgc2VlbXMgbGlrZSBpdCB3aWxsIHdvcmsgYW5kIHRo
ZW4gdG8gd2FpdCBsb25nIGVub3VnaCB0byBtZXJnZSBpdCBmb3IgdXMgdG8gdGhpbmsgYWJvdXQg
aXQsIHRyeSB0byBwb2tlIGhvbGVzIGluIGl0LCBhbmQgY29udmluY2Ugb3Vyc2VsdmVzIGFuZCBl
YWNoIG90aGVyIHRoYXQgaXQgaGFzIGEgZ29vZCBjaGFuY2Ugb2YgYmVpbmcgc291bmQuDQo+IA0K
PiBPYnZpb3VzbHkgdGhlcmUgd2lsbCBiZSBtYW55IGNhc2VzIHdoZXJlIGFuIHVucHJpdmlsZWdl
ZCBwcm9ncmFtIHNob3VsZCAqbm90KiBiZSBhYmxlIHRvIHVzZSBicGYoKSBJUCBmaWx0ZXJpbmcs
IGJ1dCBsZXTigJlzIG1ha2UgaXQgc28gdGhhdCBlbmFibGluZyB0aGVzZSBhZHZhbmNlZCBmZWF0
dXJlcyBkb2VzIG5vdCBhdXRvbWF0aWNhbGx5IGdpdmUgYXdheSB0aGUga2V5cyB0byB0aGUga2lu
Z2RvbS4NCj4gDQo+IChTYW5kc3Rvcm0gc3RpbGwgZXhpc3RzIGJ1dCBpcyBubyBsb25nZXIgYXMg
YWN0aXZlbHkgZGV2ZWxvcGVkLCBzYWRseS4pDQoNCkkgYW0gdHJ5aW5nIHRvIHVuZGVyc3RhbmQg
ZGlmZmVyZW50IHBlcnNwZWN0aXZlcyBoZXJlLiANCg0KRGlzY2xhaW1lcjogQWxleGVpIGFuZCBJ
IGJvdGggd29yayBmb3IgRmFjZWJvb2suIEJ1dCBoZSBtYXkgZGlzYWdyZWUgDQp3aXRoIGV2ZXJ5
dGhpbmcgSSBhbSBhYm91dCB0byBzYXkgYmVsb3csIGJlY2F1c2Ugd2UgaGF2ZW4ndCBzeW5jJ2Vk
IA0KYWJvdXQgdGhpcyBmb3IgYSB3aGlsZS4gOikNCg0KSSB0aGluayB0aGVyZSBhcmUgdHdvIHR5
cGVzIG9mIHVzZSBjYXNlcyBoZXJlOiANCg0KICAgIDEuIENBUF9CUEZfQURNSU46IG9uZSBiaWcg
a2V5IHRvIGFsbCBzeXNfYnBmKCkuIA0KICAgIDIuIENBUF9CUEY6IHN1YnNldCBvZiBzeXNfYnBm
KCkgdGhhdCBpcyBzYWZlIGZvciBjb250YWluZXJzLg0KDQpJSVVDLCBjdXJyZW50bHksIENBUF9C
UEZfQURNSU4gaXMgKGFsbW9zdCkgc2FtZSBhcyBDQVBfU1lTX0FETUlOLiANCkFuZCB0aGVyZSBh
cmVuJ3QgbWFueSByZWFsIHdvcmxkIHVzZSBjYXNlcyBmb3IgQ0FQX0JQRi4gDQoNClRoZSAvZGV2
L2JwZiBwYXRjaCB0cmllcyB0byBzZXBhcmF0ZSBDQVBfQlBGX0FETUlOIGZyb20gQ0FQX1NZU19B
RE1JTi4NCk9uIHRoZSBvdGhlciBoYW5kLCBBbmR5IHdvdWxkIGxpa2UgdG8gaW50cm9kdWNlIENB
UF9CUEYgYW5kIGJ1aWxkDQphbWF6aW5nIHVzZSBjYXNlcyBhcm91bmQgaXQgKGNoaWNrZW4tZWdn
IHByb2JsZW0pLiANCg0KRGlkIEkgbWlzdW5kZXJzdGFuZCBhbnl0aGluZz8NCg0KSWYgbm90LCBJ
IHRoaW5rIHRoZXNlIHR3byB1c2UgY2FzZXMgZG8gbm90IHJlYWxseSBjb25mbGljdCB3aXRoIGVh
Y2gNCm90aGVyLCBhbmQgd2UgcHJvYmFibHkgbmVlZCBib3RoIG9mIHRoZW0uIFRoZW4sIHRoZSBu
ZXh0IHF1ZXN0aW9uIGlzIA0KZG8gd2UgcmVhbGx5IG5lZWQgYm90aC9laXRoZXIgb2YgdGhlbS4g
TWF5YmUgaGF2aW5nIHR3byBzZXBhcmF0ZSANCmRpc2N1c3Npb25zIHdvdWxkIG1ha2UgaXQgZWFz
aWVyPw0KDQoNClRoZSBmb2xsb3dpbmcgYXJlIHNvbWUgcXVlc3Rpb25zIEkgYW0gdHJ5aW5nIHRv
IHVuZGVyc3RhbmQgZm9yIA0KdGhlIHR3byBjYXNlcy4gDQoNCkZvciBDQVBfQlBGX0FETUlOIChv
ciAvZGV2L2JwZik6DQpDYW4gd2UganVzdCB1c2UgQ0FQX05FVF9BRE1JTj8gSXQgaXMgc2FmZXIg
dGhhbiBDQVBfU1lTX0FETUlOLCBhbmQNCnJldXNlIGV4aXN0aW5nIENBUF8gc2hvdWxkIGJlIGVh
c2llciB0aGFuIGludHJvZHVjaW5nIGEgbmV3IG9uZT8gDQoNCkZvciBDQVBfQlBGOiANCkRvIHdl
IHJlYWxseSBuZWVkIGl0IGZvciB0aGUgY29udGFpbmVycz8gSXMgaXQgcG9zc2libGUgdG8gaW1w
bGVtZW50IA0KYWxsIGNvbnRhaW5lciB1c2UgY2FzZXMgd2l0aCBTVUlEPyBBdCB0aGlzIG1vbWVu
dCwgSSB0aGluayBTVUlEIGlzIA0KdGhlIHJpZ2h0IHdheSB0byBnbyBmb3IgdGhpcyB1c2UgY2Fz
ZSwgYmVjYXVzZSB0aGlzIGlzIGxpa2VseSB0byANCnN0YXJ0IHdpdGggYSBzbWFsbCBzZXQgb2Yg
ZnVuY3Rpb25hbGl0aWVzLiBXZSBjYW4gaW50cm9kdWNlIENBUF9CUEYNCndoZW4gdGhlIGNvbnRh
aW5lciB1c2UgY2FzZSBpcyB0b28gY29tcGxpY2F0ZWQgZm9yIFNVSUQuIA0KDQoNCkkgaG9wZSBz
b21lIG9mIHRoZXNlIHF1ZXN0aW9ucy90aG91Z2h0cyB3b3VsZCBtYWtlIHNvbWUgc2Vuc2U/DQoN
ClRoYW5rcywNClNvbmc=
