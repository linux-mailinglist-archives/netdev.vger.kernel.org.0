Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661F383CA5
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 23:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfHFVnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 17:43:14 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26536 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727039AbfHFVnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 17:43:13 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x76Ldfbh021862;
        Tue, 6 Aug 2019 14:43:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=vdiyCNhlkR5KdnYJvaUIP85TLkF1/tsoQXzcG5Tct0o=;
 b=NoahQLgAOGrRkN/uXzVtK1CYOoX6rizXZJPJ5soO6Hu1n7p6Fucr0y6tdKDL/KX4AojG
 i/KRmhRUH81LXVEyYSd2vtZxi/2Wp6tpvjKnughYKS1rjeId4YIUxqhtxMpEwiv3gKA5
 KFui/obly+QmcyCu6DB4FCdx0WAl+vR3I1w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u7g3g8d9a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 06 Aug 2019 14:42:59 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 6 Aug 2019 14:42:32 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 6 Aug 2019 14:42:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eur2y8kCqYNsYS1qlF2D7X3Oaytn6Q+0x2n5Qfr71fDEClqia0pnY+Dzd2CWf90OWQAlPdk45fnSF9Z48dy0qGujo/ZRvUQ38cuzG1dSIdivLgGEgEPLiUJVE0LUycvcpuMZwpGpKlEiKMkw5+PuJjRoRLqGzPep2RWT1Jp0kA9wIq4c/dBeFeJm/X5FdE9oJpNOc4YLnuwmPSlh8v1qkR5DDQKTToqhwGCQyRI9yweHPazbPoxVxFfXGHXyS+aJR1C3wjfHlDeSIfF5n2BikoFexYT04E8tgKQzI9NV0BtD+XQxG/60JsqQ6pk/AvEsl6lTyOlvyy+kc/A1jb7EMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdiyCNhlkR5KdnYJvaUIP85TLkF1/tsoQXzcG5Tct0o=;
 b=lGoSxwJRr1QcMGTUaA+9tD/wjT0I+wbGkUIjy7MZ0CQF2g+EuvjkOFRk/wl/qscT+deKGm49W6MnSZwFrtG08/NkRX/YxwJym+cNJckG28PH14tjUSX8SmXEbc9QX1q8HDsIxyQxH2M6w3wlbFsMlJnfrYR+rTfWWlu/lbr3S1b/LwuHhHeFjv0o4AxtzZxN9RPj2eQDLXyRh5R8YXeiLNwA6EDwZw5/ic9NqZUfJ/utMYLvBJxXZFWVA+jJKY+TPB+AKsIkKVc6kgz1IdrkkuShY5s6ki4wztaWiRM8QqciOotoxVSD4vZQ/2vio/5ZH4eYSDm2jl0MoaL2FENN5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdiyCNhlkR5KdnYJvaUIP85TLkF1/tsoQXzcG5Tct0o=;
 b=FJgwHDLZ/gvxSckVND0K0UfdcxD7CHCHWMSWp9caMFsuWksOGtKgXzhUT/OQnOrj+Ot+W2I9PtS4HBlnBrQ+jOcsda8uq3EQCcsQTPJIAp7YTccJYe4GSgBMsmQ3FGcisZRV+8BJ5j8SuyiwFNNVNArZFln9jOKEu72gtyNYHZo=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1629.namprd15.prod.outlook.com (10.175.141.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.13; Tue, 6 Aug 2019 21:42:31 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.011; Tue, 6 Aug 2019
 21:42:31 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v4 2/2] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Topic: [PATCH net-next v4 2/2] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Index: AQHVTJuYHTgXpcglwkmoKo5MNz+oeabupnmA
Date:   Tue, 6 Aug 2019 21:42:31 +0000
Message-ID: <fe0d39ea-91f3-0cac-f13b-3d46ea1748a3@fb.com>
References: <20190806210931.3723590-1-taoren@fb.com>
In-Reply-To: <20190806210931.3723590-1-taoren@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR0201CA0107.namprd02.prod.outlook.com
 (2603:10b6:301:75::48) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::cfa4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abbffab3-efa3-4025-31d1-08d71ab6fc25
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1629;
x-ms-traffictypediagnostic: MWHPR15MB1629:
x-microsoft-antispam-prvs: <MWHPR15MB16296DECF5CE7553E3E0F3C2B2D50@MWHPR15MB1629.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(396003)(346002)(376002)(39860400002)(136003)(366004)(199004)(189003)(6486002)(102836004)(2616005)(25786009)(305945005)(31696002)(7736002)(229853002)(86362001)(2501003)(476003)(446003)(8936002)(6246003)(65826007)(8676002)(81156014)(2906002)(46003)(256004)(6512007)(186003)(68736007)(478600001)(14454004)(81166006)(53936002)(11346002)(66446008)(52116002)(64126003)(99286004)(31686004)(58126008)(110136005)(6116002)(76176011)(36756003)(65956001)(65806001)(5660300002)(316002)(486006)(53546011)(7416002)(71190400001)(6436002)(2201001)(71200400001)(66476007)(386003)(6506007)(64756008)(66556008)(66946007)(921003)(1121003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1629;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HQZMyfnu8UPXQnH7/U0CzsH7+arEkDPX5gb8zPcxRVVnVKBvYOVDeRfkIlOrkAGnWFgygcfr6YUwJyjHGTn5xmkIQ8B0iGh5DyOkV50GY26XQZ7/ukCWXNWOlekcGSO1/pPXrV3O+FCw/TAWH5/+PYgVlErYV2UDmLkpPFRDMEypcayYar+SkuQdjya+8oMzUjQPhe84+w3DXI9OIH6HANkduvZV7Z7SVhDzo1cH/jkCMrJVyTkDO2v3LR/oWG25rwUK1M/3Sx1bE8qkN9OOnK5FVQf0syIuGrBEYX0C+x5w4VjUItxDSBMSH5VgyiOTJhK/+P99ymaxH/pcZco5ekGdOaI5IvCOk05PFfO7cHW29va+h1jN0CQtWs0m6LM+rfyMmaP6lmMQQxpvh6r1xhq/Iz6mH7BUsG7dyRqqUII=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EA8150608DD5942A0B0DDFC6F84A627@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: abbffab3-efa3-4025-31d1-08d71ab6fc25
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 21:42:31.5119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5QCivJhdyxGetujlqsWv3hDk1qsu5njflGVeNKM4hCpVDg9rb/T1BiQbFsLHvN27
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1629
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-06_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=898 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908060185
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3IC8gSGVpbmVyIC8gVmxhZGltaXIsDQoNCk9uIDgvNi8xOSAyOjA5IFBNLCBUYW8g
UmVuIHdyb3RlOg0KPiBUaGUgQkNNNTQ2MTZTIFBIWSBjYW5ub3Qgd29yayBwcm9wZXJseSBpbiBS
R01JSS0+MTAwMEJhc2UtS1ggbW9kZSAoZm9yDQo+IGV4YW1wbGUsIG9uIEZhY2Vib29rIENNTSBC
TUMgcGxhdGZvcm0pLCBtYWlubHkgYmVjYXVzZSBnZW5waHkgZnVuY3Rpb25zDQo+IGFyZSBkZXNp
Z25lZCBmb3IgY29wcGVyIGxpbmtzLCBhbmQgMTAwMEJhc2UtWCAoY2xhdXNlIDM3KSBhdXRvIG5l
Z290aWF0aW9uDQo+IG5lZWRzIHRvIGJlIGhhbmRsZWQgZGlmZmVyZW50bHkuDQo+IA0KPiBUaGlz
IHBhdGNoIGVuYWJsZXMgMTAwMEJhc2UtWCBzdXBwb3J0IGZvciBCQ001NDYxNlMgYnkgY3VzdG9t
aXppbmcgMw0KPiBkcml2ZXIgY2FsbGJhY2tzOg0KPiANCj4gICAtIHByb2JlOiBwcm9iZSBjYWxs
YmFjayBkZXRlY3RzIFBIWSdzIG9wZXJhdGlvbiBtb2RlIGJhc2VkIG9uDQo+ICAgICBJTlRFUkZf
U0VMWzE6MF0gcGlucyBhbmQgMTAwMFgvMTAwRlggc2VsZWN0aW9uIGJpdCBpbiBTZXJERVMgMTAw
LUZYDQo+ICAgICBDb250cm9sIHJlZ2lzdGVyLg0KPiANCj4gICAtIGNvbmZpZ19hbmVnOiBiY201
NDYxNnNfY29uZmlnX2FuZWdfMTAwMGJ4IGZ1bmN0aW9uIGlzIGFkZGVkIGZvciBhdXRvDQo+ICAg
ICBuZWdvdGlhdGlvbiBpbiAxMDAwQmFzZS1YIG1vZGUuDQo+IA0KPiAgIC0gcmVhZF9zdGF0dXM6
IEJDTTU0NjE2UyBhbmQgQkNNNTQ4MiBQSFkgc2hhcmUgdGhlIHNhbWUgcmVhZF9zdGF0dXMNCj4g
ICAgIGNhbGxiYWNrIHdoaWNoIG1hbnVhbGx5IHNldCBsaW5rIHNwZWVkIGFuZCBkdXBsZXggbW9k
ZSBpbiAxMDAwQmFzZS1YDQo+ICAgICBtb2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogVGFvIFJl
biA8dGFvcmVuQGZiLmNvbT4NCg0KSSBjdXN0b21pemVkIGNvbmZpZ19hbmVnIGZ1bmN0aW9uIGZv
ciBCQ001NDYxNlMgMTAwMEJhc2UtWCBtb2RlIGFuZCBsaW5rLWRvd24gaXNzdWUgaXMgYWxzbyBm
aXhlZDogdGhlIHBhdGNoIGlzIHRlc3RlZCBvbiBGYWNlYm9vayBDTU0gYW5kIE1pbmlwYWNrIEJN
QyBhbmQgZXZlcnl0aGluZyBsb29rcyBub3JtYWwuIFBsZWFzZSBraW5kbHkgcmV2aWV3IHdoZW4g
eW91IGhhdmUgYmFuZHdpZHRoIGFuZCBsZXQgbWUga25vdyBpZiB5b3UgaGF2ZSBmdXJ0aGVyIHN1
Z2dlc3Rpb25zLg0KDQpCVFcsIEkgd291bGQgYmUgaGFwcHkgdG8gaGVscCBpZiB3ZSBkZWNpZGUg
dG8gYWRkIGEgc2V0IG9mIGdlbnBoeSBmdW5jdGlvbnMgZm9yIGNsYXVzZSAzNywgYWx0aG91Z2gg
dGhhdCBtYXkgbWVhbiBJIG5lZWQgbW9yZSBoZWxwL2d1aWRhbmNlIGZyb20geW91IDotKQ0KDQoN
CkNoZWVycywNCg0KVGFvDQo=
