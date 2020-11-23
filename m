Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6DB2C1244
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 18:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387846AbgKWRno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 12:43:44 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:37664 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729740AbgKWRnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 12:43:43 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANHecTc028854;
        Mon, 23 Nov 2020 09:42:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=olHRgCON0wlPyAqv/iv/rojW1dNprj0z/2uquJy5r8U=;
 b=ZOgTr/8UJlv1HMpdpxJbtK0cDhb1LWGqKozwxhLfWDBhyCNlYDsXIy8nmNrHqnb9tQDj
 aUaDgCgn5XxNwSBu573rIkfT2IQVVY+eePjsROruFOK2kOhdNAzoNbu/Gfhlm5oAmzwH
 IgwQqN0ZfRR4rimYCkqmIyKMwRXIqU3dP0N7ItaGF4ZLg+Wo0zQb+F2BJd8pF3g4oPuJ
 0SxQ3Ju2Qm7wsZkUNT64DEojeWReQzJbijh0WOX2W3gs9qhij9jntPYgiG0LEENbFUvW
 8p302mWRgQv66cj8rTEn1uEErI2Mbxlwq1hXCrNOGu1Xv1nm67RylSBAYuni3jHAUt4T Cw== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 34y39r6bse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 09:42:50 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 09:42:48 -0800
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.57) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 09:42:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPY+EORfthD67n12LOh6FYIi6bwEZ49SG8Xznata5J+fD6vdqo1TP1tVxoD8y5h2daWT6Y8HS7IOImiEW8TCqejZzQCdMXrjxXX4tuAZyRW4vYT2oRNGaOgzrMXFKT2epzV0xvoKDJM4EZr7ElD6qZeNW3Mzk1zx3TsCDA0FiwKwhAD0DvCGJ9eVCI4K+5CkfPXubWihchOFYWwnuhZhLe1kXyzdUNj4tyMuw3Ikyjlee2s3nYmO+eOh76z2e6K2U570qHQ0UVHxPFTwuIQASYs8M7UYSIZ4842+pumGxdhhYEtjS0DG8N9zP/8X5U6DWOqK3RYmGE+9Ac1Qapk4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olHRgCON0wlPyAqv/iv/rojW1dNprj0z/2uquJy5r8U=;
 b=nu7guwKyx4wBYv5ilmVJ4mOhM/YioRJQJPLPPwxUW1MgJtXObukTczkVTub19+qW5ERrtSDiq2EqlHDcmq8BJKg1jsjk8ojL2k109JcsTxk2QpPE0mOraxMxD0D/dvVGOJDS27wVRg7OWCeMjMYxzKutY/cvysJqr1/9Snl2J5kr8WZvaZiwgvgvE1UsSSkOtLUDSjyW0HBvb8p8g4Ws0XEW1Qwp9oSWT8W74xR3jPW+uwNRj4ehaf6UEl/nD6j5dmd7RQEC/BGu8FCJ5jrYTti4ht5TDn18Hz/JNJiFlE/IzFwO8ZS1Uhye25assGeYZZXpHbyG8Op/qQz6TW3J8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olHRgCON0wlPyAqv/iv/rojW1dNprj0z/2uquJy5r8U=;
 b=a+/OSC3hM4A5BSMJgAXsifbezlw3P/N8cH1ljgY3UJe0igPgyUjb65kQwCYZqK64kBQ81xcoG5eoU35On5pP6zyaapGz71LSKCT2kkYPdJm7Tpv2vheCP6ThsGA2CenhnDiqH4K4gr0wW8covHhR8BBLK9Y5U13rGxtiZTaL+cY=
Received: from MW2PR18MB2267.namprd18.prod.outlook.com (2603:10b6:907:3::11)
 by MWHPR18MB1342.namprd18.prod.outlook.com (2603:10b6:300:ce::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Mon, 23 Nov
 2020 17:42:46 +0000
Received: from MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703]) by MW2PR18MB2267.namprd18.prod.outlook.com
 ([fe80::e17f:37fb:4eb3:c703%4]) with mapi id 15.20.3564.039; Mon, 23 Nov 2020
 17:42:46 +0000
From:   Alex Belits <abelits@marvell.com>
To:     "nitesh@redhat.com" <nitesh@redhat.com>,
        "frederic@kernel.org" <frederic@kernel.org>
CC:     Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH v5 0/9] "Task_isolation" mode
Thread-Topic: [PATCH v5 0/9] "Task_isolation" mode
Thread-Index: AQHWwcAN4HMJq5rZb0WNk0YfmsaUgQ==
Date:   Mon, 23 Nov 2020 17:42:45 +0000
Message-ID: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [173.228.7.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a9d35cc7-fd55-4984-568f-08d88fd7302f
x-ms-traffictypediagnostic: MWHPR18MB1342:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB134242BC779E6BF2FDFF5355BCFC0@MWHPR18MB1342.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MTJWklmvD0U1E9pA1Pz40pf2/hVDWZamHIgDwfCmSNlSQcL/o/DWR75lA10d+fRXnlblW27NYNS4QvKhDOD+FwWTiQo6583LN5tOnxsuQDbrnymojgAqPBtiFZGHDzmG596tOcgk8/P/RXmuZfO1ud03uJLRv+dbsXudKsuUcAfxzlQF6RgKVKc7ic32mZDa2dR+hniE0pFoT5t8HWVzFZGnhqAcNtq9a+rgNmRVntteeplMaEGkDL26HXagirxX4WbRjuoLenYlBwmWfX2ADGoTJHGqArQjSRaiGmpWxHlo6WE/VuCeaftZvhbB6K0FpMPFW3UQfz4xNVl3qOaLd8fbNIWMpRgb+Oo8lhSbFEjS+rob5Rf3tw2+epErMQzbyxNG/kqOGq4tAxdFWJq5Lw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR18MB2267.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(966005)(6506007)(478600001)(86362001)(8936002)(26005)(36756003)(186003)(2616005)(8676002)(2906002)(6512007)(7416002)(6486002)(4326008)(5660300002)(83380400001)(54906003)(71200400001)(110136005)(316002)(64756008)(66446008)(91956017)(66476007)(66556008)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Crv+cFLHay9+M3Pg68PhaqvINHX/WL83jq/72lKlVPZS4Jzl00d1yfmFRGpkRIq2hTmFwztHv3bakBJpkiad9z2+ogTnYgwExK1u86NwgoJQOcOBPP3NmmbW8Q26NkzxprFsJl2PFV1EK9MX58Df1uDGTn3KUadKlMpFlCUDcb/48gIyHMwK9iyo8ejWvA60srJuyV2d2RJHIyAcSlcxivRqlAaL/CHUMZ4PS7zPjiAIlLURGqhN/hQmO/K+jiHAD7W1j0d0z8tEz5jc26gkHIUQ84qR8J7chkNDihr9tEubyo9ajAVi9ndSNMKsCxUNNMJdOUj1BA46iN5/DRlD06ahL7K5sJAfNX6t7iC8kAgZ4ij/GxWYM4CQiTubXNA7j17rk/JwDRw7PdPHR1IImkXPwVIiUJzT1UFlk30xVrfjROncOjGv083Y109VwF5fuckRZuYYMuf+xZpUzU3vHTPSsVj0MtiSwSC5QBnBbnmvv+jWuQv/eWrEPRdhFJ+utwROzvAAAwuCbVLxpVcKYprWjvFh4AsCyY/aCdrr8KbsBM6hrmsQkj4JLKhZjzi7iBxllIUJudDyehWGmVxcp177np7dO7qOqwUM+VpaoIUJg+yMb1nV9QfZyWBiPYV8xNFLHC3kqkft96uFB7350zplTlgIH+w+DgezuTimW+VWY+EHPpDxLPeV1fOWwZXT75b7VBxfwobrOi8QHWlC7DkCumW0HS8yEQUQIYcdaYnANBJCG+oUCTU+fHyLXs4aMIgGIg8M5QEG1vr/phStcU8SKuWLSBfNpk/yM7rqzrOLMKfvfWrfj73BoWWttQWAfNadsEVeNQNq6MJBhss6L8xZ+03yGp8tLXtcmy0yufd9ob5vECtHjlRUKqJJTyv0m9AQmNvUa9baeHO2Tr3rNg==
Content-Type: text/plain; charset="utf-8"
Content-ID: <93B54AB342F93C4B9C188076FB9F6EC5@namprd18.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR18MB2267.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9d35cc7-fd55-4984-568f-08d88fd7302f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 17:42:45.8256
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XOC/wgfjt+A22H0eumiI0/kRwya1nTdK/YNklTkp7JmvnWzsjF41XzZ/2QDfDijYMmXpCxG8IgJkFfjOv6bXGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1342
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_17:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBpcyBhbiB1cGRhdGUgb2YgdGFzayBpc29sYXRpb24gd29yayB0aGF0IHdhcyBvcmlnaW5h
bGx5IGRvbmUgYnkNCkNocmlzIE1ldGNhbGYgPGNtZXRjYWxmQG1lbGxhbm94LmNvbT4gYW5kIG1h
aW50YWluZWQgYnkgaGltIHVudGlsDQpOb3ZlbWJlciAyMDE3LiBJdCBpcyBhZGFwdGVkIHRvIHRo
ZSBjdXJyZW50IGtlcm5lbCBhbmQgY2xlYW5lZCB1cCB0bw0KaW1wbGVtZW50IGl0cyBmdW5jdGlv
bmFsaXR5IGluIGEgbW9yZSBjb21wbGV0ZSBhbmQgY2xlYW5lciBtYW5uZXIuDQoNClByZXZpb3Vz
IHZlcnNpb24gaXMgYXQNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8wNGJlMDQ0YzFi
Y2Q3NmI3NDM4Yjc1NjNlZGMzNTM4MzQxN2YxMmM4LmNhbWVsQG1hcnZlbGwuY29tLw0KDQpUaGUg
bGFzdCB2ZXJzaW9uIGJ5IENocmlzIE1ldGNhbGYgKG5vdyBvYnNvbGV0ZSBidXQgbWF5IGJlIHJl
bGV2YW50DQpmb3IgY29tcGFyaXNvbiBhbmQgdW5kZXJzdGFuZGluZyB0aGUgb3JpZ2luIG9mIHRo
ZSBjaGFuZ2VzKSBpcyBhdA0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8xNTA5NzI4Njky
LTEwNDYwLTEtZ2l0LXNlbmQtZW1haWwtY21ldGNhbGZAbWVsbGFub3guY29tDQoNClN1cHBvcnRl
ZCBhcmNoaXRlY3R1cmVzDQoNClRoaXMgdmVyc2lvbiBpbmNsdWRlcyBvbmx5IGFyY2hpdGVjdHVy
ZS1pbmRlcGVuZGVudCBjb2RlIGFuZCBhcm02NA0Kc3VwcG9ydC4geDg2IGFuZCBhcm0gc3VwcG9y
dCwgYW5kIGV2ZXJ5dGhpbmcgcmVsYXRlZCB0byB2aXJ0dWFsaXphdGlvbg0Kd2lsbCBiZSByZS1h
ZGRlZCBsYXRlciB3aGVuIG5ldyBrZXJuZWwgZW50cnkvZXhpdCBpbXBsZW1lbnRhdGlvbiB3aWxs
DQpiZSBhY2NvbW1vZGF0ZWQuIFN1cHBvcnQgZm9yIG90aGVyIGFyY2hpdGVjdHVyZXMgY2FuIGJl
IGFkZGVkIGluIGENCnNvbWV3aGF0IG1vZHVsYXIgbWFubmVyLCBob3dldmVyIGl0IGhlYXZpbHkg
ZGVwZW5kcyBvbiB0aGUgZGV0YWlscyBvZg0KYSBrZXJuZWwgZW50cnkvZXhpdCBzdXBwb3J0IG9u
IGFueSBwYXJ0aWN1bGFyIGFyY2hpdGVjdHVyZS4NCkRldmVsb3BtZW50IG9mIGNvbW1vbiBlbnRy
eS9leGl0IGFuZCBjb252ZXJzaW9uIHRvIGl0IHNob3VsZCBzaW1wbGlmeQ0KdGhhdCB0YXNrLiBG
b3Igbm93LCB0aGlzIGlzIHRoZSB2ZXJzaW9uIHRoYXQgaXMgY3VycmVudGx5IGJlaW5nDQpkZXZl
bG9wZWQgb24gYXJtNjQuDQoNCk1ham9yIGNoYW5nZXMgc2luY2UgdjQNCg0KVGhlIGdvYWwgd2Fz
IHRvIG1ha2UgaXNvbGF0aW9uLWJyZWFraW5nIGRldGVjdGlvbiBhcyBnZW5lcmljIGFzDQpwb3Nz
aWJsZSwgYW5kIHJlbW92ZSBldmVyeXRoaW5nIHJlbGF0ZWQgdG8gZGV0ZXJtaW5pbmcsIF93aHlf
DQppc29sYXRpb24gd2FzIGJyb2tlbi4gT3JpZ2luYWxseSByZXBvcnRpbmcgaXNvbGF0aW9uIGJy
ZWFraW5nIHdhcyBkb25lDQp3aXRoIGEgbGFyZ2UgbnVtYmVyIG9mIG9mIGhvb2tzIGluIHNwZWNp
ZmljIGNvZGUgKGhhcmR3YXJlIGludGVycnVwdHMsDQpzeXNjYWxscywgSVBJcywgcGFnZSBmYXVs
dHMsIGV0Yy4pLCBhbmQgaXQgd2FzIG5lY2Vzc2FyeSB0byBjb3ZlciBhbGwNCnBvc3NpYmxlIHN1
Y2ggZXZlbnRzIHRvIGhhdmUgYSByZWxpYWJsZSBub3RpZmljYXRpb24gb2YgYSB0YXNrIGFib3V0
DQppdHMgaXNvbGF0aW9uIGJlaW5nIGJyb2tlbi4gVG8gYXZvaWQgc3VjaCBhIGZyYWdpbGUgbWVj
aGFuaXNtLCB0aGlzDQp2ZXJzaW9uIHJlbGllcyBvbiBtZXJlIGZhY3Qgb2Yga2VybmVsIGJlaW5n
IGVudGVyZWQgaW4gaXNvbGF0aW9uDQptb2RlLiBBcyBhIHJlc3VsdCwgcmVwb3J0aW5nIGhhcHBl
bnMgbGF0ZXIgaW4ga2VybmVsIGNvZGUsIGhvd2V2ZXIgaXQNCmNvdmVycyBldmVyeXRoaW5nLg0K
DQpUaGlzIG1lYW5zIHRoYXQgbm93IHRoZXJlIGlzIG5vIHNwZWNpZmljIHJlcG9ydGluZywgaW4g
a2VybmVsIGxvZyBvcg0KZWxzZXdoZXJlLCBhYm91dCB0aGUgcmVhc29ucyBmb3IgYnJlYWtpbmcg
aXNvbGF0aW9uLiBJbmZvcm1hdGlvbiBhYm91dA0KdGhhdCBtYXkgYmUgdmFsdWFibGUgYXQgcnVu
dGltZSwgc28gYSBzZXBhcmF0ZSBtZWNoYW5pc20gZm9yIGdlbmVyaWMNCnJlcG9ydGluZyAid2h5
IGRpZCBDUFUgZW50ZXIga2VybmVsIiAod2l0aCBpc29sYXRpb24gb3IgdW5kZXIgb3RoZXINCmNv
bmRpdGlvbnMpIG1heSBiZSBhIGdvb2QgdGhpbmcuIFRoYXQgY2FuIGJlIGRvbmUgbGF0ZXIsIGhv
d2V2ZXIgYXQNCnRoaXMgcG9pbnQgaXQncyBpbXBvcnRhbnQgdGhhdCB0YXNrIGlzb2xhdGlvbiBk
b2VzIG5vdCByZXF1aXJlIGl0LCBhbmQNCnN1Y2ggbWVjaGFuaXNtIHdpbGwgbm90IGJlIGRldmVs
b3BlZCB3aXRoIHRoZSBsaW1pdGVkIHB1cnBvc2Ugb2YNCnN1cHBvcnRpbmcgaXNvbGF0aW9uIGFs
b25lLg0KDQpHZW5lcmFsIGRlc2NyaXB0aW9uDQoNClRoaXMgaXMgdGhlIHJlc3VsdCBvZiBkZXZl
bG9wbWVudCBhbmQgbWFpbnRlbmFuY2Ugb2YgdGFzayBpc29sYXRpb24NCmZ1bmN0aW9uYWxpdHkg
dGhhdCBvcmlnaW5hbGx5IHN0YXJ0ZWQgYmFzZWQgb24gdGFzayBpc29sYXRpb24gcGF0Y2gNCnYx
NSBhbmQgd2FzIGxhdGVyIHVwZGF0ZWQgdG8gaW5jbHVkZSB2MTYuIEl0IHByb3ZpZGVkIHByZWRp
Y3RhYmxlDQplbnZpcm9ubWVudCBmb3IgdXNlcnNwYWNlIHRhc2tzIHJ1bm5pbmcgb24gYXJtNjQg
cHJvY2Vzc29ycyBhbG9uZ3NpZGUNCndpdGggZnVsbC1mZWF0dXJlZCBMaW51eCBlbnZpcm9ubWVu
dC4gSXQgaXMgaW50ZW5kZWQgdG8gcHJvdmlkZQ0KcmVsaWFibGUgaW50ZXJydXB0aW9uLWZyZWUg
ZW52aXJvbm1lbnQgZnJvbSB0aGUgcG9pbnQgd2hlbiBhIHVzZXJzcGFjZQ0KdGFzayBlbnRlcnMg
aXNvbGF0aW9uIGFuZCB1bnRpbCB0aGUgbW9tZW50IGl0IGxlYXZlcyBpc29sYXRpb24gb3INCnJl
Y2VpdmVzIGEgc2lnbmFsIGludGVudGlvbmFsbHkgc2VudCB0byBpdCwgYW5kIHdhcyBzdWNjZXNz
ZnVsbHkgdXNlZA0KZm9yIHRoaXMgcHVycG9zZS4gV2hpbGUgQ1BVIGlzb2xhdGlvbiB3aXRoIG5v
aHogcHJvdmlkZXMgYW4NCmVudmlyb25tZW50IHRoYXQgaXMgY2xvc2UgdG8gdGhpcyByZXF1aXJl
bWVudCwgdGhlIHJlbWFpbmluZyBJUElzIGFuZA0Kb3RoZXIgZGlzdHVyYmFuY2VzIGtlZXAgaXQg
ZnJvbSBiZWluZyB1c2FibGUgZm9yIHRhc2tzIHRoYXQgcmVxdWlyZQ0KY29tcGxldGUgcHJlZGlj
dGFiaWxpdHkgb2YgQ1BVIHRpbWluZy4NCg0KVGhpcyBzZXQgb2YgcGF0Y2hlcyBvbmx5IGNvdmVy
cyB0aGUgaW1wbGVtZW50YXRpb24gb2YgdGFzayBpc29sYXRpb24sDQpob3dldmVyIGFkZGl0aW9u
YWwgZnVuY3Rpb25hbGl0eSwgc3VjaCBhcyBzZWxlY3RpdmUgVExCIGZsdXNoZXMsIG1heQ0KYmUg
aW1wbGVtZW50ZWQgdG8gYXZvaWQgb3RoZXIga2luZHMgb2YgZGlzdHVyYmFuY2VzIHRoYXQgYWZm
ZWN0DQpsYXRlbmN5IGFuZCBwZXJmb3JtYW5jZSBvZiBpc29sYXRlZCB0YXNrcy4NCg0KVGhlIHVz
ZXJzcGFjZSBzdXBwb3J0IGFuZCB0ZXN0IHByb2dyYW0gaXMgbm93IGF0DQpodHRwczovL2dpdGh1
Yi5jb20vYWJlbGl0cy9saWJ0bWMgLiBJdCB3YXMgb3JpZ2luYWxseSBkZXZlbG9wZWQgZm9yDQpl
YXJsaWVyIGltcGxlbWVudGF0aW9uLCBzbyBpdCBoYXMgc29tZSBjaGVja3MgdGhhdCBtYXkgYmUg
cmVkdW5kYW50DQpub3cgYnV0IGtlcHQgZm9yIGNvbXBhdGliaWxpdHkuDQoNCk15IHRoYW5rcyB0
byBDaHJpcyBNZXRjYWxmIGZvciBkZXNpZ24gYW5kIG1haW50ZW5hbmNlIG9mIHRoZSBvcmlnaW5h
bA0KdGFzayBpc29sYXRpb24gcGF0Y2gsIEZyYW5jaXMgR2lyYWxkZWF1IDxmcmFuY2lzLmdpcmFs
ZGVhdUBnbWFpbC5jb20+DQphbmQgWXVyaSBOb3JvdiA8eW5vcm92QG1hcnZlbGwuY29tPiBmb3Ig
dmFyaW91cyBjb250cmlidXRpb25zIHRvIHRoaXMNCndvcmssIEZyZWRlcmljIFdlaXNiZWNrZXIg
PGZyZWRlcmljQGtlcm5lbC5vcmc+IGZvciBoaXMgd29yayBvbiBDUFUNCmlzb2xhdGlvbiBhbmQg
aG91c2VrZWVwaW5nIHRoYXQgbWFkZSBwb3NzaWJsZSB0byByZW1vdmUgc29tZSBsZXNzDQplbGVn
YW50IHNvbHV0aW9ucyB0aGF0IEkgaGFkIHRvIGRldmlzZSBmb3IgZWFybGllciwgPDQuMTcga2Vy
bmVscywgYW5kDQpOaXRlc2ggTmFyYXlhbiBMYWwgPG5pdGVzaEByZWRoYXQuY29tPiBmb3IgYWRh
cHRpbmcgZWFybGllciBwYXRjaGVzDQpyZWxhdGVkIHRvIGludGVycnVwdCBhbmQgd29yayBkaXN0
cmlidXRpb24gaW4gcHJlc2VuY2Ugb2YgQ1BVDQppc29sYXRpb24uDQoNCi0tIA0KQWxleA0K
