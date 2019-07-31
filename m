Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5427B7F0
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 04:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbfGaCJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 22:09:25 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16558 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726559AbfGaCJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 22:09:25 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6V24tHh018583;
        Tue, 30 Jul 2019 19:09:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=48Sij+EDPUlaCGfNFgO0o+f8i+joYTgGNfOi7Y8l8ks=;
 b=TrXc0nzzWtEyMlzdX2SBVHAYid5EemhQG3X8xKP0iIQ1ACgtRgFVt1MeDiUbr6aSckCk
 zgYjKheURVF/ahl12PlgPn+OZMSKzZiE65V3NFSfNP6hNp+Yii4ZnpfZPFyDvwwVXTVe
 ZyK8M3wp+HLx1WfK4lOGe7cHFxIFd/ebpfA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2uxa18e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 30 Jul 2019 19:09:11 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 19:09:10 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 30 Jul 2019 19:09:10 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 19:09:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WEDX+eYoMIoYKt9ZOFPTNZMhE4dmwZTe26rQo/N3x/KC9C/vq4nvWGoHOlCWHT/8F/bqq18ubdy8W3886vEOSbOI66Oqi5H9wcBsa4DA71Z9ry0DaoaduRO6m92QL+eVrOfTyxL9GxXwhoxiu8vxwruv5wXCEdJBUc94ySu8Fp8xf7Jj+4LJRIhI1VbSQt9bDnIJGyuUHfC3//zSSSf8jKmj7ru7wCpzc4BIgXjAmCBT/CFcA6YmEVQRy+VVUMmcEQiQElYggS72t+HxDZTHFLvSiFVVXRIjdp3D6T2j8hdGrIJLlKQfcrr/XMIT8FfyGtcmPfkQ2f6k2fg3CmB44w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48Sij+EDPUlaCGfNFgO0o+f8i+joYTgGNfOi7Y8l8ks=;
 b=myq4zI+IwQKTyaDuo/2x0rmidkFc8X1BfWP8mo1a57Ctc7A+JoUIAmKTrxAqe5ZC/T/AToDVTrynjfDpg28XEQG6eaUOuvBsYT5py/WJtd7oKyeQ7RVMwe0cDJbdWtBaJPwSXacrhduveHyupPFKrmdh2ApcP+ur2+J2f7xzNp53bgvZrH7BT6D6uf3WEEesp9N2FhR60r+egXmLjVaN36XxD+A+le7S8L5PuSP/CnAP55OcAqG38/uivlb84vvkibBs18LhzEg+65yksGhToraNVQ9BsFqGJiGIwkrbQbM0hNLJ4N6vdIMb+Bl7zexNSh5X386M79W8kL2bPnHDoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48Sij+EDPUlaCGfNFgO0o+f8i+joYTgGNfOi7Y8l8ks=;
 b=gtZZfLb+IFEt/8xQQLOipIJ+JEysA4CgcdnE1eZvmBdUTDnpB5iqH2UwNDp+HurSpOZYBriaMsebTwd16GGEes3bgT0GP/Qf/+cVLfEu/oDfGhAEC8gfyKacgsPWt6EZ200Gr21mj54H628Zx/b5xm6URWoXfEBFgwslLMsc4mM=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1215.namprd15.prod.outlook.com (10.175.3.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 02:09:09 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Wed, 31 Jul 2019
 02:09:09 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Topic: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Index: AQHVRm4oHxOo2s4k1kyYCsigpkISsabiYHeAgAA34ACAAFoWAIAA4hcAgAAfZwCAAAkVAA==
Date:   Wed, 31 Jul 2019 02:09:08 +0000
Message-ID: <885e48dd-df5b-7f08-ef58-557fc2347fa6@fb.com>
References: <20190730002549.86824-1-taoren@fb.com>
 <CA+h21hq1+E6-ScFx425hXwTPTZHTVZbBuAm7RROFZTBOFvD8vQ@mail.gmail.com>
 <3987251b-9679-dfbe-6e15-f991c2893bac@fb.com>
 <CA+h21ho1KOGS3WsNBHzfHkpSyE4k5HTE1tV9wUtnkZhjUZGeUw@mail.gmail.com>
 <e8f85ef3-1216-8efb-a54d-84426234fe82@fb.com>
 <20190731013636.GC25700@lunn.ch>
In-Reply-To: <20190731013636.GC25700@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR06CA0024.namprd06.prod.outlook.com
 (2603:10b6:301:39::37) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:463a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3514b1f-b1e9-4fbe-41a5-08d7155c1269
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1215;
x-ms-traffictypediagnostic: MWHPR15MB1215:
x-microsoft-antispam-prvs: <MWHPR15MB1215D91E3546DECD2468EE7FB2DF0@MWHPR15MB1215.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(366004)(136003)(39860400002)(199004)(189003)(2616005)(476003)(102836004)(305945005)(6916009)(4326008)(65826007)(86362001)(486006)(66446008)(66476007)(8936002)(446003)(11346002)(4744005)(64756008)(256004)(5660300002)(81156014)(6246003)(25786009)(31696002)(19627235002)(8676002)(71200400001)(71190400001)(229853002)(68736007)(46003)(81166006)(7416002)(7736002)(66946007)(31686004)(6506007)(2906002)(478600001)(316002)(58126008)(14444005)(186003)(76176011)(6436002)(64126003)(66556008)(386003)(52116002)(14454004)(6486002)(99286004)(36756003)(53936002)(65956001)(53546011)(65806001)(6512007)(6116002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1215;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: VZuG+Zp52to3Ki2uYInShHaTnZ0+R8UBl7fC4si73uaPJntwZySWngGM3XoCamEke8BgNULHh+ExoEFiDka8HBXihOgSP1et+0SIZik94CiqQz1NqI/wggIuo22/fODvvDy833WgYPBMUwanQNnWKuq9A7Fb64rjq6/WvBBSenqN1P5EkqTFIqOkcXSPTVA8WJ/GQpZCpuGeFkbqGB4JafKpNDgbhcglhjSHsYCy1WdMqtej/bozEXYknq0BkE//jAtt7U7HG63HCbdwvsEZSo+XElfpay885kkLGr8gRQSTZMYQyhRCyQkzbr7VZ1yq8d2VWCoeqgZgKLrOprFcC9beo3LMxnvf4r3ldXoX9/2Y4NPh2ZR/OKoLm5nUwKPOw67p/KFlxqRDhUrwWF80RhWlQKkDjUEQIRQTIAG+YDc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5370EF05E3E55D4EA56F5E2331CBA4C2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a3514b1f-b1e9-4fbe-41a5-08d7155c1269
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 02:09:08.9719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1215
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-31_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=984 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907310019
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8zMC8xOSA2OjM2IFBNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+IFRoZSBJTlRGX1NFTCBw
aW5zIHJlcG9ydCBjb3JyZWN0IG1vZGUgKFJHTUlJLUZpYmVyKSBvbiBteSBtYWNoaW5lLA0KPj4g
YnV0IHRoZXJlIGFyZSAyICJzdWItbW9kZXMiICgxMDAwQmFzZS1YIGFuZCAxMDBCYXNlLUZYKSBh
bmQgSQ0KPj4gY291bGRuJ3QgZmluZCBhIHByb3Blci9zYWZlIHdheSB0byBhdXRvLWRldGVjdCB3
aGljaCAic3ViLW1vZGUiIGlzDQo+PiBhY3RpdmUuIFRoZSBkYXRhc2hlZXQganVzdCBkZXNjcmli
ZXMgaW5zdHJ1Y3Rpb25zIHRvIGVuYWJsZSBhDQo+PiBzcGVjaWZpYyBtb2RlLCBidXQgaXQgZG9l
c24ndCBzYXkgMTAwMEJhc2UtWC8xMDBCYXNlLUZYIG1vZGUgd2lsbCBiZQ0KPj4gYXV0by1zZWxl
Y3RlZC4gQW5kIHRoYXQncyB3aHkgSSBjYW1lIHVwIHdpdGggdGhlIHBhdGNoIHRvIHNwZWNpZnkN
Cj4+IDEwMDBCYXNlLVggbW9kZS4NCj4gDQo+IEZpYnJlIGRvZXMgbm90IHBlcmZvcm0gYW55IHNv
cnQgb2YgYXV0by1uZWdvdGlhdGlvbi4gSSBhc3N1bWUgeW91IGhhdmUNCj4gYW4gU0ZQIGNvbm5l
Y3RlZD8gV2hlbiB1c2luZyBQSFlMSU5LLCB0aGUgc2ZwIGRyaXZlciB3aWxsIGdldCB0aGUNCj4g
c3VwcG9ydGVkIGJhdWQgcmF0ZSBmcm9tIFNGUCBFRVBST00gdG8gZGV0ZXJtaW5lIHdoYXQgc3Bl
ZWQgY291bGQgYmUNCj4gdXNlZC4gSG93ZXZlciwgdGhlcmUgaXMgY3VycmVudGx5IG5vIG1haW5s
aW5lIHN1cHBvcnQgZm9yIGhhdmluZyBhDQo+IGNoYWluIE1BQy1QSFktU0ZQLiBGb3IgdGhhdCB5
b3UgbmVlZCBSdXNzZWxscyBvdXQgb2YgdHJlZSBwYXRjaGVzLg0KDQpIaSBBbmRyZXcsDQoNClRo
ZSBCQ001NDYxNlMgUEhZIG9uIG15IG1hY2hpbmUgaXMgY29ubmVjdGVkIHRvIGEgQkNNNTM5NiBz
d2l0Y2ggY2hpcCBvdmVyIGJhY2twbGFuZSAoMTAwMEJhc2UtS1gpLg0KDQoNClRoYW5rcywNCg0K
VGFvDQo=
