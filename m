Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79FFA88448
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHIUzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 16:55:08 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16746 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbfHIUzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:55:07 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79Kqg0A027057;
        Fri, 9 Aug 2019 13:54:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ybYPEFTEM8IShgYzDxXuhI/YTtJF2wIlopsZannVqjY=;
 b=YaNIX5nbiCHB762jkmJFoFobGkWUhuRBhmB1no7RDgnREOxGUP5jdmB8ZV2uhl0+mGEg
 PFZJxGkwgizWEQDmRoTBmPVFa+0L2Kb8N9T/l7KzpnXZXVJc6Ls74DkL4uYWs0UG2OB+
 v3h6jfPIQNSbyJDtTU0Bykirs3sJpHkyrIg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u96uyanqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 09 Aug 2019 13:54:52 -0700
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 9 Aug 2019 13:54:51 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 9 Aug 2019 13:54:51 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 9 Aug 2019 13:54:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ok61kOlkeRRGeHtv/0rocIqWI8132FjBbAt7WQFL57jt92lKR3dwab1yH95nHOuk/KOh8hEGRbsfemLND6j4c9zm6F1a1JflwJgIZ2A+7aUDtvABIgm4Ui7nUfbdxkKiuhKIm4DDMH5LKrIghF9Zy20qRFaT3lNA2Tu13zfhI8NhIF13RgOsCV6xeU2hHLMorJxyFWxlqbXsHxYDp2sEePwik4zRdqgvwnwFm6vO8q1XoOWZW21alaxDAct0stfBXA2EFjBpPcHoBQ0AIJhtKH8A3eYQ46/J4OrZzZ9pRwUa2WOyG88GSfe7aVhVf4KW/Z3Yy3FuywAXYLpOjqT3yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybYPEFTEM8IShgYzDxXuhI/YTtJF2wIlopsZannVqjY=;
 b=kGeEZ5dGREE42oarD12iXfAhanwzsrB8EEI3eACIoLOJKsl0O3I5wHh9Ktr3arUFtFYNddkTSbtTI8Rhm1L9rr0mXEhQBSOmwPwjcMnng+JqNa7/QXweerQxKkUdFpsykp0pzmbbZEtHaoqHCutgw3CLHnF0tLYj5WU7LhdoPfwR9E2nwgBgBefWd0aoslicBGLUKOvF+jurJD9m9koYfXdfUCCEnGNJHXPh8vVwaULf7AcbmskeeLryvQZ03wRWQOg77vokE55QRniPBzWis5JewBuK9SpIhxobq+N93j6XawyRIFLBIJgGYG/ZPVdKGqzbU0wQP4ZUvziWandPSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ybYPEFTEM8IShgYzDxXuhI/YTtJF2wIlopsZannVqjY=;
 b=BVkvrWwRxjAADv6/VzdmaCc2PvWFckP6NlIx+hxUVaoYwUtxRl9ADSrY7meJB9HNVqkMda1x4q9bUMw31YwMIjU1BmZL3LNxo/Y8RNkMLvJFpneCSw3QP+UgNN9IGC9NDb7RoopiXVHfPkvYaxrzixz29W0rDDYV7/V4Anj4SPs=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1680.namprd15.prod.outlook.com (10.175.141.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Fri, 9 Aug 2019 20:54:50 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 20:54:50 +0000
From:   Tao Ren <taoren@fb.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v6 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Topic: [PATCH net-next v6 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Index: AQHVTnXbR0omRCjy/0G0ZEtUvAlu56bzQySAgAAJTAA=
Date:   Fri, 9 Aug 2019 20:54:50 +0000
Message-ID: <e556dd17-ef85-3c61-bc08-17db02d9a5dc@fb.com>
References: <20190809054411.1015962-1-taoren@fb.com>
 <97cd059c-d98e-1392-c814-f3bd628e6366@gmail.com>
In-Reply-To: <97cd059c-d98e-1392-c814-f3bd628e6366@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1401CA0005.namprd14.prod.outlook.com
 (2603:10b6:301:4b::15) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:f2f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ce8f4be-81a4-46b8-8794-08d71d0bd1f2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1680;
x-ms-traffictypediagnostic: MWHPR15MB1680:
x-microsoft-antispam-prvs: <MWHPR15MB1680EF0A7A9A0A521486D3BCB2D60@MWHPR15MB1680.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(396003)(136003)(366004)(376002)(346002)(199004)(189003)(46003)(66476007)(186003)(229853002)(11346002)(14454004)(7416002)(99286004)(478600001)(52116002)(58126008)(86362001)(2201001)(36756003)(110136005)(2616005)(316002)(7736002)(8936002)(305945005)(31686004)(14444005)(25786009)(6116002)(386003)(6506007)(486006)(6512007)(256004)(102836004)(6246003)(476003)(64126003)(66446008)(2501003)(65956001)(71190400001)(66556008)(81166006)(5660300002)(446003)(81156014)(31696002)(64756008)(8676002)(53936002)(65806001)(6436002)(76176011)(66946007)(2906002)(6486002)(65826007)(71200400001)(53546011)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1680;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UZn1lF1VfdZOEnE5ymUmzviRrvnr1G9acPY3oa4FyNtgNtzfn9HWVjflXcgOhVUefzKhAc1zzAJbmeHntrwJi+GZMi26QchMWNhShyfNgc0ARJXsRz/yTSZrM8YTxr+o3BaHfAVBRZM/ekUk+2fv5sOhPnRMn5C6EmAoH136QYjPEM6mcu/YFA0DpTZ0tcdBMJ/j090lYRaDCN/U75X73JsbEQCmaVWLpeHMwXXj5tpJOKmHRUPU/soqKu1+pk6Ya3fhS6QzaCtickvzt6bZA9qzGMuNRiX0RTEO4JKU/TFfqkeWpdhzH/uuQIufH6v06aECxuHop2T5PNoWNZwpowvAKl1gI9RCYv/lAan4zvvjL9T1a+FeXwz3dLBWtzlzLU1teirBf9WiFO/aj+vpU8zCS4NNJ61mTK7bpmPUSq8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <59590F6C7C2CA74B916189BD6FCB461F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce8f4be-81a4-46b8-8794-08d71d0bd1f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 20:54:50.2571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fSwUqInl+5V8Ro604C7Mtj6/nOsWziwc3RGhInu13ZyisY9g8ycZGF/1kWp8G6Ck
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1680
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090204
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSGVpbmVyLA0KDQpPbiA4LzkvMTkgMToyMSBQTSwgSGVpbmVyIEthbGx3ZWl0IHdyb3RlOg0K
PiBPbiAwOS4wOC4yMDE5IDA3OjQ0LCBUYW8gUmVuIHdyb3RlOg0KPj4gVGhlIEJDTTU0NjE2UyBQ
SFkgY2Fubm90IHdvcmsgcHJvcGVybHkgaW4gUkdNSUktPjEwMDBCYXNlLUtYIG1vZGUgKGZvcg0K
Pj4gZXhhbXBsZSwgb24gRmFjZWJvb2sgQ01NIEJNQyBwbGF0Zm9ybSksIG1haW5seSBiZWNhdXNl
IGdlbnBoeSBmdW5jdGlvbnMNCj4+IGFyZSBkZXNpZ25lZCBmb3IgY29wcGVyIGxpbmtzLCBhbmQg
MTAwMEJhc2UtWCAoY2xhdXNlIDM3KSBhdXRvIG5lZ290aWF0aW9uDQo+PiBuZWVkcyB0byBiZSBo
YW5kbGVkIGRpZmZlcmVudGx5Lg0KPj4NCj4+IFRoaXMgcGF0Y2ggZW5hYmxlcyAxMDAwQmFzZS1Y
IHN1cHBvcnQgZm9yIEJDTTU0NjE2UyBieSBjdXN0b21pemluZyAzDQo+PiBkcml2ZXIgY2FsbGJh
Y2tzOg0KPj4NCj4+ICAgLSBwcm9iZTogcHJvYmUgY2FsbGJhY2sgZGV0ZWN0cyBQSFkncyBvcGVy
YXRpb24gbW9kZSBiYXNlZCBvbg0KPj4gICAgIElOVEVSRl9TRUxbMTowXSBwaW5zIGFuZCAxMDAw
WC8xMDBGWCBzZWxlY3Rpb24gYml0IGluIFNlckRFUyAxMDAtRlgNCj4+ICAgICBDb250cm9sIHJl
Z2lzdGVyLg0KPj4NCj4+ICAgLSBjb25maWdfYW5lZzogY2FsbHMgZ2VucGh5X2MzN19jb25maWdf
YW5lZyB3aGVuIHRoZSBQSFkgaXMgcnVubmluZyBpbg0KPj4gICAgIDEwMDBCYXNlLVggbW9kZTsg
b3RoZXJ3aXNlLCBnZW5waHlfY29uZmlnX2FuZWcgd2lsbCBiZSBjYWxsZWQuDQo+Pg0KPj4gICAt
IHJlYWRfc3RhdHVzOiBjYWxscyBnZW5waHlfYzM3X3JlYWRfc3RhdHVzIHdoZW4gdGhlIFBIWSBp
cyBydW5uaW5nIGluDQo+PiAgICAgMTAwMEJhc2UtWCBtb2RlOyBvdGhlcndpc2UsIGdlbnBoeV9y
ZWFkX3N0YXR1cyB3aWxsIGJlIGNhbGxlZC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBUYW8gUmVu
IDx0YW9yZW5AZmIuY29tPg0KPj4gLS0tDQo+PiAgQ2hhbmdlcyBpbiB2NjoNCj4+ICAgLSBub3Ro
aW5nIGNoYW5nZWQuDQo+PiAgQ2hhbmdlcyBpbiB2NToNCj4+ICAgLSBpbmNsdWRlIEhlaW5lcidz
IHBhdGNoICJuZXQ6IHBoeTogYWRkIHN1cHBvcnQgZm9yIGNsYXVzZSAzNw0KPj4gICAgIGF1dG8t
bmVnb3RpYXRpb24iIGludG8gdGhlIHNlcmllcy4NCj4+ICAgLSB1c2UgZ2VucGh5X2MzN19jb25m
aWdfYW5lZyBhbmQgZ2VucGh5X2MzN19yZWFkX3N0YXR1cyBpbiBCQ001NDYxNlMNCj4+ICAgICBQ
SFkgZHJpdmVyJ3MgY2FsbGJhY2sgd2hlbiB0aGUgUEhZIGlzIHJ1bm5pbmcgaW4gMTAwMEJhc2Ut
WCBtb2RlLg0KPj4gIENoYW5nZXMgaW4gdjQ6DQo+PiAgIC0gYWRkIGJjbTU0NjE2c19jb25maWdf
YW5lZ18xMDAwYngoKSB0byBkZWFsIHdpdGggYXV0byBuZWdvdGlhdGlvbiBpbg0KPj4gICAgIDEw
MDBCYXNlLVggbW9kZS4NCj4+ICBDaGFuZ2VzIGluIHYzOg0KPj4gICAtIHJlbmFtZSBiY201NDgy
X3JlYWRfc3RhdHVzIHRvIGJjbTU0eHhfcmVhZF9zdGF0dXMgc28gdGhlIGNhbGxiYWNrIGNhbg0K
Pj4gICAgIGJlIHNoYXJlZCBieSBCQ001NDgyIGFuZCBCQ001NDYxNlMuDQo+PiAgQ2hhbmdlcyBp
biB2MjoNCj4+ICAgLSBBdXRvLWRldGVjdCBQSFkgb3BlcmF0aW9uIG1vZGUgaW5zdGVhZCBvZiBw
YXNzaW5nIERUIG5vZGUuDQo+PiAgIC0gbW92ZSBQSFkgbW9kZSBhdXRvLWRldGVjdCBsb2dpYyBm
cm9tIGNvbmZpZ19pbml0IHRvIHByb2JlIGNhbGxiYWNrLg0KPj4gICAtIG9ubHkgc2V0IHNwZWVk
IChub3QgaW5jbHVkaW5nIGR1cGxleCkgaW4gcmVhZF9zdGF0dXMgY2FsbGJhY2suDQo+PiAgIC0g
dXBkYXRlIHBhdGNoIGRlc2NyaXB0aW9uIHdpdGggbW9yZSBiYWNrZ3JvdW5kIHRvIGF2b2lkIGNv
bmZ1c2lvbi4NCj4+ICAgLSBwYXRjaCAjMSBpbiB0aGUgc2VyaWVzICgibmV0OiBwaHk6IGJyb2Fk
Y29tOiBzZXQgZmVhdHVyZXMgZXhwbGljaXRseQ0KPj4gICAgIGZvciBCQ001NDYxNiIpIGlzIGRy
b3BwZWQ6IHRoZSBmaXggc2hvdWxkIGdvIHRvIGdldF9mZWF0dXJlcyBjYWxsYmFjaw0KPj4gICAg
IHdoaWNoIG1heSBwb3RlbnRpYWxseSBkZXBlbmQgb24gdGhpcyBwYXRjaC4NCj4+DQo+PiAgZHJp
dmVycy9uZXQvcGh5L2Jyb2FkY29tLmMgfCA1NCArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKy0tLQ0KPj4gIGluY2x1ZGUvbGludXgvYnJjbXBoeS5oICAgIHwgMTAgKysrKystLQ0K
Pj4gIDIgZmlsZXMgY2hhbmdlZCwgNTggaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4+
DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L2Jyb2FkY29tLmMgYi9kcml2ZXJzL25l
dC9waHkvYnJvYWRjb20uYw0KPj4gaW5kZXggOTM3ZDAwNTllOGFjLi5mYmQ3NmEzMWMxNDIgMTAw
NjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9waHkvYnJvYWRjb20uYw0KPj4gKysrIGIvZHJpdmVy
cy9uZXQvcGh5L2Jyb2FkY29tLmMNCj4+IEBAIC0zODMsOSArMzgzLDkgQEAgc3RhdGljIGludCBi
Y201NDgyX2NvbmZpZ19pbml0KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+PiAgCQkvKg0K
Pj4gIAkJICogU2VsZWN0IDEwMDBCQVNFLVggcmVnaXN0ZXIgc2V0IChwcmltYXJ5IFNlckRlcykN
Cj4+ICAJCSAqLw0KPj4gLQkJcmVnID0gYmNtX3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0
ODJfU0hEX01PREUpOw0KPj4gLQkJYmNtX3BoeV93cml0ZV9zaGFkb3cocGh5ZGV2LCBCQ001NDgy
X1NIRF9NT0RFLA0KPj4gLQkJCQkgICAgIHJlZyB8IEJDTTU0ODJfU0hEX01PREVfMTAwMEJYKTsN
Cj4+ICsJCXJlZyA9IGJjbV9waHlfcmVhZF9zaGFkb3cocGh5ZGV2LCBCQ001NFhYX1NIRF9NT0RF
KTsNCj4+ICsJCWJjbV9waHlfd3JpdGVfc2hhZG93KHBoeWRldiwgQkNNNTRYWF9TSERfTU9ERSwN
Cj4+ICsJCQkJICAgICByZWcgfCBCQ001NFhYX1NIRF9NT0RFXzEwMDBCWCk7DQo+PiAgDQo+PiAg
CQkvKg0KPj4gIAkJICogTEVEMT1BQ1RJVklUWUxFRCwgTEVEMz1MSU5LU1BEWzJdDQo+PiBAQCAt
NDUxLDEyICs0NTEsNDQgQEAgc3RhdGljIGludCBiY201NDgxX2NvbmZpZ19hbmVnKHN0cnVjdCBw
aHlfZGV2aWNlICpwaHlkZXYpDQo+PiAgCXJldHVybiByZXQ7DQo+PiAgfQ0KPj4gIA0KPj4gK3N0
YXRpYyBpbnQgYmNtNTQ2MTZzX3Byb2JlKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+PiAr
ew0KPj4gKwlpbnQgdmFsLCBpbnRmX3NlbDsNCj4+ICsNCj4+ICsJdmFsID0gYmNtX3BoeV9yZWFk
X3NoYWRvdyhwaHlkZXYsIEJDTTU0WFhfU0hEX01PREUpOw0KPj4gKwlpZiAodmFsIDwgMCkNCj4+
ICsJCXJldHVybiB2YWw7DQo+PiArDQo+PiArCS8qIFRoZSBQSFkgaXMgc3RyYXBwZWQgaW4gUkdN
SUkgdG8gZmliZXIgbW9kZSB3aGVuIElOVEVSRl9TRUxbMTowXQ0KPj4gKwkgKiBpcyAwMWIuDQo+
PiArCSAqLw0KPj4gKwlpbnRmX3NlbCA9ICh2YWwgJiBCQ001NFhYX1NIRF9JTlRGX1NFTF9NQVNL
KSA+PiAxOw0KPj4gKwlpZiAoaW50Zl9zZWwgPT0gMSkgew0KPj4gKwkJdmFsID0gYmNtX3BoeV9y
ZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0NjE2U19TSERfMTAwRlhfQ1RSTCk7DQo+PiArCQlpZiAo
dmFsIDwgMCkNCj4+ICsJCQlyZXR1cm4gdmFsOw0KPj4gKw0KPj4gKwkJLyogQml0IDAgb2YgdGhl
IFNlckRlcyAxMDAtRlggQ29udHJvbCByZWdpc3Rlciwgd2hlbiBzZXQNCj4+ICsJCSAqIHRvIDEs
IHNldHMgdGhlIE1JSS9SR01JSSAtPiAxMDBCQVNFLUZYIGNvbmZpZ3VyYXRpb24uDQo+PiArCQkg
KiBXaGVuIHRoaXMgYml0IGlzIHNldCB0byAwLCBpdCBzZXRzIHRoZSBHTUlJL1JHTUlJIC0+DQo+
PiArCQkgKiAxMDAwQkFTRS1YIGNvbmZpZ3VyYXRpb24uDQo+PiArCQkgKi8NCj4+ICsJCWlmICgh
KHZhbCAmIEJDTTU0NjE2U18xMDBGWF9NT0RFKSkNCj4+ICsJCQlwaHlkZXYtPmRldl9mbGFncyB8
PSBQSFlfQkNNX0ZMQUdTX01PREVfMTAwMEJYOw0KPj4gKwl9DQo+PiArDQo+PiArCXJldHVybiAw
Ow0KPj4gK30NCj4+ICsNCj4+ICBzdGF0aWMgaW50IGJjbTU0NjE2c19jb25maWdfYW5lZyhzdHJ1
Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPj4gIHsNCj4+ICAJaW50IHJldDsNCj4+ICANCj4+ICAJ
LyogQW5lZyBmaXJzbHkuICovDQo+PiAtCXJldCA9IGdlbnBoeV9jb25maWdfYW5lZyhwaHlkZXYp
Ow0KPj4gKwlpZiAocGh5ZGV2LT5kZXZfZmxhZ3MgJiBQSFlfQkNNX0ZMQUdTX01PREVfMTAwMEJY
KQ0KPj4gKwkJcmV0ID0gZ2VucGh5X2MzN19jb25maWdfYW5lZyhwaHlkZXYpOw0KPj4gKwllbHNl
DQo+PiArCQlyZXQgPSBnZW5waHlfY29uZmlnX2FuZWcocGh5ZGV2KTsNCj4+ICANCj4gDQo+IEkn
bSBqdXN0IHdvbmRlcmluZyB3aGV0aGVyIGl0IG5lZWRzIHRvIGJlIGNvbnNpZGVyZWQgdGhhdCAx
MDBiYXNlLUZYDQo+IGRvZXNuJ3Qgc3VwcG9ydCBhdXRvLW5lZ290aWF0aW9uLiBJIHN1cHBvc2Ug
Qk1TUiByZXBvcnRzIGFuZWcgYXMNCj4gc3VwcG9ydGVkLCB0aGVyZWZvcmUgcGh5bGliIHdpbGwg
dXNlIGFuZWcgcGVyIGRlZmF1bHQuDQo+IE5vdCBzdXJlIHdobyBjb3VsZCBzZXQgMTAwQmFzZS1G
WCBtb2RlIHdoZW4sIGJ1dCBtYXliZSBhdCB0aGF0IHBsYWNlDQo+IGFsc28gcGh5ZGV2LT5hdXRv
bmVnIG5lZWRzIHRvIGJlIGNsZWFyZWQuIERpZCB5b3UgdGVzdCAxMDBCYXNlLUZYIG1vZGU/DQoN
CkknbSBkb3VidGluZyBpZiAxMDBCYXNlLUZYIHdvcmtzLiBCZXNpZGVzIGF1dG8tbmVnb3RpYXRp
b24sIDEwMEJhc2UtRlggQ29udHJvbC9TdGF0dXMgcmVnaXN0ZXJzIGFyZSBkZWZpbmVkIGluIHNo
YWRvdyByZWdpc3RlciBpbnN0ZWFkIG9mIE1JSV9CTUNSIGFuZCBNSUlfQk1TUi4NCg0KVW5mb3J0
dW5hdGVseSBJIGRvbid0IGhhdmUgZW52aXJvbm1lbnQgdG8gdGVzdCAxMDBCYXNlLUZYIGFuZCB0
aGF0J3Mgd2h5IEkgb25seSBtYWtlIGNoYW5nZXMgd2hlbiB0aGUgUEhZIGlzIHdvcmtpbmcgaW4g
MTAwMFggbW9kZS4NCg0KDQpUaGFua3MsDQoNClRhbw0K
