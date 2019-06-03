Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90CFE32AFB
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 10:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbfFCIlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 04:41:51 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60350 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725856AbfFCIlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 04:41:51 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x538ffcu031333;
        Mon, 3 Jun 2019 01:41:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=fAN7wz+r/otU12EFJyBMj07ScX254+w4tkdhsYuo+PQ=;
 b=s9r/7R8B98UiIJ38sMUWBA70UOvccecjfI32vuBWwmcQ+aAf2Gflc+Puo1iO0buiCZ2A
 YVyB4PsPXnhGKuSh4HY6sgIboOmuVtPqmgbxYYonsXc35iMic53yqSbM28L0PeS2nkHk
 x4YUGYLIJ8yeAkH6vjxALr6JyBAz/J5+wWm3KqbpX4jbPxMQqWVH5McKiT2X2ON+CK/i
 ZNuEQhnzauVA/2rBy6yTFsF6yeEp5tIvk9/CYnOtseE7ONolQKj6GniReQ/7sPjfB11d
 Q8u+yZXp0BX5T3YrI8QnvkB/7gKfMTGBwL4QLs850gZjKfuIob2H42GMrCE0O0iLGBCO sA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2supqm00eu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 01:41:41 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 3 Jun
 2019 01:41:24 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.51) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 3 Jun 2019 01:41:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAN7wz+r/otU12EFJyBMj07ScX254+w4tkdhsYuo+PQ=;
 b=rXn4imgrl4vF25kJUsP5L8EQgVqYul9+njI2mZtDgwUTOJcYVUYinmcGL+SeRV4K8Mnj5fwPCdFlsp+zjf3Q0Y4Co/Kcz4lJYpG0Nh/Euj5zKE+7AtlczBgsAkl/GytPr5q/ankZWz4RiXf2PIW1iiEbxTBWWm55yetDgUAL+Ww=
Received: from MN2PR18MB2637.namprd18.prod.outlook.com (20.179.80.147) by
 MN2PR18MB2638.namprd18.prod.outlook.com (20.179.84.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 08:41:22 +0000
Received: from MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::3c77:9f53:7e47:7eb8]) by MN2PR18MB2637.namprd18.prod.outlook.com
 ([fe80::3c77:9f53:7e47:7eb8%7]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 08:41:22 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Dmitry Vyukov <dvyukov@google.com>
CC:     syzbot <syzbot+dc4127f950da51639216@syzkaller.appspotmail.com>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "andreyknvl@google.com" <andreyknvl@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "huxinming820@gmail.com" <huxinming820@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: RE: [EXT] INFO: trying to register non-static key in del_timer_sync
 (2)
Thread-Topic: [EXT] INFO: trying to register non-static key in del_timer_sync
 (2)
Thread-Index: AQHU8UKXrSaZj3qnvU6hFZ7GfmsosaaHYqxQgAJS84CAADevwA==
Date:   Mon, 3 Jun 2019 08:41:22 +0000
Message-ID: <MN2PR18MB26372D98386D79736A7947EEA0140@MN2PR18MB2637.namprd18.prod.outlook.com>
References: <000000000000927a7b0586561537@google.com>
 <MN2PR18MB263783F52CAD4A335FD8BB34A01A0@MN2PR18MB2637.namprd18.prod.outlook.com>
 <CACT4Y+aQzBkAq86Hx4jNFnAUzjXnq8cS2NZKfeCaFrZa__g-cg@mail.gmail.com>
In-Reply-To: <CACT4Y+aQzBkAq86Hx4jNFnAUzjXnq8cS2NZKfeCaFrZa__g-cg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [117.241.205.23]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41adeafe-04c5-4413-9ad7-08d6e7ff4196
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2638;
x-ms-traffictypediagnostic: MN2PR18MB2638:
x-microsoft-antispam-prvs: <MN2PR18MB2638BF38FE9A7BD085207B66A0140@MN2PR18MB2638.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(366004)(346002)(376002)(396003)(199004)(189003)(102836004)(33656002)(6916009)(8936002)(53936002)(74316002)(476003)(86362001)(81166006)(8676002)(81156014)(66476007)(66556008)(64756008)(66446008)(73956011)(305945005)(558084003)(76116006)(14454004)(478600001)(3846002)(66946007)(6116002)(9686003)(25786009)(7736002)(229853002)(256004)(4326008)(6506007)(11346002)(2906002)(66066001)(5660300002)(76176011)(7696005)(6246003)(7416002)(54906003)(71190400001)(446003)(71200400001)(186003)(55016002)(52536014)(486006)(316002)(26005)(6436002)(99286004)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2638;H:MN2PR18MB2637.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nVUTbY43rDr8mmqY48l1I5i3y+DKFng5be5JS3vrS9sl4MgHIAKiCx5L7kklJX3GCs97Sstb+r7btqeDja4R9QVx1c6RvymwKYy0VeTBzQJON/9F4kDAn4H/bspp7WuRcd8/9CRc4udjgrUiGxLKphsWXJ0c7B8J2Vuj2PaLT8T6/Qe/BiLN2CePrQH86+d88LzeK25o0p7WIE80dPKxBqP3U5nOOMjs1uObjAOcfDPjFNk4BqIuWZW2v8ulwmL6fI0Qddpx/Cl1u7PgSvawD5MkGA4ZFrU8XruABfPHbi03NNCDd3JMgYH+8xHtr7moj3FCy9M/Nar+NWtze4ghzNCxh9P4B7bJ6xyThc4SGUCetcW74EGJnzveQHT1lQlbrtZhc6z/NHLMUPUJv/8KFr2/IbJiAogNqpnevg1+vy0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 41adeafe-04c5-4413-9ad7-08d6e7ff4196
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 08:41:22.1080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gbhat@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2638
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_07:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRG1pdHJ5LA0KDQo+IFRoZSAiZml4ZWQiIHN0YXR1cyByZWxhdGVzIHRvIHRoZSBzaW1pbGFy
IHBhc3QgYnVnIHRoYXQgd2FzIHJlcG9ydGVkIGFuZCBmaXhlZA0KPiBtb3JlIHRoYW4gYSB5ZWFy
IGFnbzoNCk9oIE9LOyBXZSB1bmRlcnN0b29kIHRoZSBpc3N1ZSwgd29ya2luZyBvbiBhIGNoYW5n
ZSB0byBmaXggdGhpczsNCg0KVGhhbmtzLA0KR2FuYXBhdGhpDQo=
