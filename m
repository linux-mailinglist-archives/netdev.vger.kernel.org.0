Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D43D686D34
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 00:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404775AbfHHW1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 18:27:00 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732708AbfHHW07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 18:26:59 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x78MN1qM011635;
        Thu, 8 Aug 2019 15:26:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=na5DQSykmYjV2XFT/RRnI0NDwRI3L21oaeLfEFeTnhA=;
 b=OHXGGJIHs8su8bLnD7ejfbOJaEiVvY1HtRJ2e96kt6yvQf6td/4rXAjpMEjDXKI/JX+R
 nrdH2PuoVpysNsOWDgncXaJ9WxCO6bxFzCabVqg9/X/jCj96Mf94dHbRSTJ1+LE+Odbx
 /FQ5o7PoNvxHSAIBTsc2NteSgt8kKjYhnKk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2u8p4b1j6f-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 08 Aug 2019 15:26:41 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 8 Aug 2019 15:26:39 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Aug 2019 15:26:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlxypHuE6eYPyi9cvjTjtWtlXfZ95GUDT3VHOsUkjFI5wsJ+s3Dlrn5AQ7pEbQz0npExbwzeD91Dfe5D1yxrjFR3wIGAzPMQB3mDEzJxTYWqWL4DKbv2UyWf+tIoePEjC1jbtfc9kPZ6xC6xF17+8SE9pPG++A7H6JqNk2yCTaOwrpWuaux+AI3gbxzhEejFKmWmZ4JhC+ZmtKf9VGWiwbJPdVejW9AHVxfoPS8afSCad2eDDIvgIncxp1sUvQLZFNgyl4uvpxJ4bSc+edum/vZIAv/OpzQaguLyvQiAr1R8hlfGBRRK5LX5MWlercJPSkUzUQCBW1Yb5RgOCRsiAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=na5DQSykmYjV2XFT/RRnI0NDwRI3L21oaeLfEFeTnhA=;
 b=VqLs9lUA2xSziQfTYyfRp7bvoOjEqG9AtjUjVbWBtLJItlp2E8Zj9eGx9cW00UuZ6TlhbynAHG0DabhgZOh/la7niY1utUnTkZ+kaDmYfPmaWM7LfBMV8h27Ju7WduSiJ1ZOzQEibKBOf9qxsBMRjSoRF99NIUh51vRvPRtNoZsjce4phyJRGUco9WJMEpt9p+Iw7yajspaLJcwnquqPnUZe8Udn0er7BRncR2xsJ7AovQNGL0Oo5ksuHzJChzGICS1S4eI48bQim4y1ZSWpeNw54uF17Z+Ct16OdEJUBnrdGALNz8i6CMQe3Y+imBMPC0cq9wFfXdWxLEO4orqAdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=na5DQSykmYjV2XFT/RRnI0NDwRI3L21oaeLfEFeTnhA=;
 b=g6/3rx6J9RBJrdP7IVVKGNAw2JY43mabcDcSpRFtjHdK8MBSDKemRlH+0rT3nQdQxhsvtufcQF4CwmAqTI+1JGA3SRVDxw3Y7HM+uuH+MusbY15YQf2nxW8kBnN4ko7Wa567IFpcQiJWBcQcIj+DUWOXZb9WpKO2vuu2SlFCeIk=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1230.namprd15.prod.outlook.com (10.175.2.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 8 Aug 2019 22:26:24 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 22:26:24 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        William Kennington <wak@google.com>
Subject: Re: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Topic: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Index: AQHVTLYXvEPb5D4KhEGV/bPPR833MKbwAYEAgAAEloCAADQnAIABB7CA///nDgCAAJqugIAAE4WA
Date:   Thu, 8 Aug 2019 22:26:24 +0000
Message-ID: <ac22bbe0-36ca-b4b9-7ea7-7b1741c2070d@fb.com>
References: <20190807002118.164360-1-taoren@fb.com>
 <20190807112518.644a21a2@cakuba.netronome.com>
 <20190807184143.GE26047@lunn.ch>
 <806a76a8-229a-7f24-33c7-2cf2094f3436@fb.com>
 <20190808133209.GB32706@lunn.ch>
 <77762b10-b8e7-b8a4-3fc0-e901707a1d54@fb.com>
 <20190808211629.GQ27917@lunn.ch>
In-Reply-To: <20190808211629.GQ27917@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0035.namprd21.prod.outlook.com
 (2603:10b6:300:129::21) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::5aeb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57c6d56d-6822-486c-6636-08d71c4f724c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1230;
x-ms-traffictypediagnostic: MWHPR15MB1230:
x-microsoft-antispam-prvs: <MWHPR15MB123039EF5ED717F4B581DA11B2D70@MWHPR15MB1230.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(346002)(39860400002)(136003)(199004)(189003)(446003)(486006)(58126008)(2616005)(4326008)(11346002)(476003)(64126003)(53936002)(52116002)(54906003)(65956001)(316002)(6246003)(229853002)(186003)(6436002)(81166006)(2906002)(305945005)(65806001)(8676002)(14454004)(81156014)(6512007)(65826007)(53546011)(6506007)(386003)(102836004)(31696002)(5660300002)(66946007)(99286004)(25786009)(76176011)(71200400001)(31686004)(66446008)(66476007)(66556008)(64756008)(6916009)(36756003)(14444005)(8936002)(46003)(86362001)(256004)(6486002)(7736002)(6116002)(478600001)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1230;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QCfRTuZBhjRolOdS0Nmjq17iC24aSAUbayAedlVoPGYzXnGybE+ccfCjL4/mQ2TBLuCtnBJ7xFMV9A2une1bMMdc2RCDqRcCoB+io/Lb+ynpREnaxRW750VMphkUMJ1Kd/z7VorZJ04ADfjRNhK6YhiRn990K3almpFozZ7yw2Iwo2/S0gJnp3KI9CQBI27Dl681Z/NLHJSuNsuenErcWvDym5Oe9YwKDKOUBXOWTGcKgZRMWyiN8sR3u2v9nHxcMcr1+ckICPBA5PJyFtVLyzho4cueHqKpPoYdtnm5d5dLkNpE3BGZ+4tvi/W100rOr/h9e47pyVzZvn/tOoBzUhIRBFzR7c1P0x/rN8FhHlx71Lb+P8ENQU65cFaY1UeZGzcogfdl7cb9LXYTs5e2AoKPOr/k/bQJsvAdAjJnmf8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <DEE09A85E7BF5F40848D5F79138D64FA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 57c6d56d-6822-486c-6636-08d71c4f724c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 22:26:24.4387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OsMDLvQYB5vQesnOHfdA34M779+nJathXiqLlVb+sNPi+VOM5ZBLC5twbIdT5RKl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1230
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080198
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC84LzE5IDI6MTYgUE0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBPbiBUaHUsIEF1ZyAwOCwg
MjAxOSBhdCAwNzowMjo1NFBNICswMDAwLCBUYW8gUmVuIHdyb3RlOg0KPj4gSGkgQW5kcmV3LA0K
Pj4NCj4+IE9uIDgvOC8xOSA2OjMyIEFNLCBBbmRyZXcgTHVubiB3cm90ZToNCj4+Pj4gTGV0IG1l
IHByZXBhcmUgcGF0Y2ggdjIgdXNpbmcgZGV2aWNlIHRyZWUuIEknbSBub3Qgc3VyZSBpZiBzdGFu
ZGFyZA0KPj4+PiAibWFjLWFkZHJlc3MiIGZpdHMgdGhpcyBzaXR1YXRpb24gYmVjYXVzZSBhbGwg
d2UgbmVlZCBpcyBhbiBvZmZzZXQNCj4+Pj4gKGludGVnZXIpIGFuZCBCTUMgTUFDIGlzIGNhbGN1
bGF0ZWQgYnkgYWRkaW5nIHRoZSBvZmZzZXQgdG8gTklDJ3MNCj4+Pj4gTUFDIGFkZHJlc3MuIEFu
eXdheXMsIGxldCBtZSB3b3JrIG91dCB2MiBwYXRjaCB3ZSBjYW4gZGlzY3VzcyBtb3JlDQo+Pj4+
IHRoZW4uDQo+Pj4NCj4+PiBIaSBUYW8NCj4+Pg0KPj4+IEkgZG9uJ3Qga25vdyBCTUMgdGVybWlu
b2xvZ3kuIEJ5IE5JQ3MgTUFDIGFkZHJlc3MsIHlvdSBhcmUgcmVmZXJyaW5nDQo+Pj4gdG8gdGhl
IGhvc3RzIE1BQyBhZGRyZXNzPyBUaGUgTUFDIGFkZHJlc3MgdGhlIGJpZyBDUFUgaXMgdXNpbmcg
Zm9yIGl0cw0KPj4+IGludGVyZmFjZT8gIFdoZXJlIGRvZXMgdGhpcyBOSUMgZ2V0IGl0cyBNQUMg
YWRkcmVzcyBmcm9tPyBJZiB0aGUgQk1Dcw0KPj4+IGJvb3Rsb2FkZXIgaGFzIGFjY2VzcyB0byBp
dCwgaXQgY2FuIHNldCB0aGUgbWFjLWFkZHJlc3MgcHJvcGVydHkgaW4NCj4+PiB0aGUgZGV2aWNl
IHRyZWUuDQo+Pg0KPj4gU29ycnkgZm9yIHRoZSBjb25mdXNpb24gYW5kIGxldCBtZSBjbGFyaWZ5
IG1vcmU6DQo+Pg0KPiANCj4+IFRoZSBOSUMgaGVyZSByZWZlcnMgdG8gdGhlIE5ldHdvcmsgY29u
dHJvbGxlciB3aGljaCBwcm92aWRlIG5ldHdvcmsNCj4+IGNvbm5lY3Rpdml0eSBmb3IgYm90aCBC
TUMgKHZpYSBOQy1TSSkgYW5kIEhvc3QgKGZvciBleGFtcGxlLCB2aWENCj4+IFBDSWUpLg0KPj4N
Cj4gDQo+PiBPbiBGYWNlYm9vayBZYW1wIEJNQywgQk1DIHNlbmRzIE5DU0lfT0VNX0dFVF9NQUMg
Y29tbWFuZCAoYXMgYW4NCj4+IGV0aGVybmV0IHBhY2tldCkgdG8gdGhlIE5ldHdvcmsgQ29udHJv
bGxlciB3aGlsZSBicmluZ2luZyB1cCBldGgwLA0KPj4gYW5kIHRoZSAoQnJvYWRjb20pIE5ldHdv
cmsgQ29udHJvbGxlciByZXBsaWVzIHdpdGggdGhlIEJhc2UgTUFDDQo+PiBBZGRyZXNzIHJlc2Vy
dmVkIGZvciB0aGUgcGxhdGZvcm0uIEFzIGZvciBZYW1wLCBCYXNlLU1BQyBhbmQNCj4+IEJhc2Ut
TUFDKzEgYXJlIHVzZWQgYnkgSG9zdCAoYmlnIENQVSkgYW5kIEJhc2UtTUFDKzIgYXJlIGFzc2ln
bmVkIHRvDQo+PiBCTUMuIEluIG15IG9waW5pb24sIEJhc2UgTUFDIGFuZCBNQUMgYWRkcmVzcyBh
c3NpZ25tZW50cyBhcmUNCj4+IGNvbnRyb2xsZWQgYnkgTmV0d29yayBDb250cm9sbGVyLCB3aGlj
aCBpcyB0cmFuc3BhcmVudCB0byBib3RoIEJNQw0KPj4gYW5kIEhvc3QuDQo+IA0KPiBIaSBUYW8N
Cj4gDQo+IEkndmUgbm90IGRvbmUgYW55IHdvcmsgaW4gdGhlIEJNQyBmaWVsZCwgc28gdGhhbmtz
IGZvciBleHBsYWluaW5nDQo+IHRoaXMuDQo+IA0KPiBJbiBhIHR5cGljYWwgZW1iZWRkZWQgc3lz
dGVtLCBlYWNoIG5ldHdvcmsgaW50ZXJmYWNlIGlzIGFzc2lnbmVkIGEgTUFDDQo+IGFkZHJlc3Mg
YnkgdGhlIHZlbmRvci4gQnV0IGhlcmUsIHRoaW5ncyBhcmUgZGlmZmVyZW50LiBUaGUgQk1DIFNv
Qw0KPiBuZXR3b3JrIGludGVyZmFjZSBoYXMgbm90IGJlZW4gYXNzaWduZWQgYSBNQUMgYWRkcmVz
cywgaXQgbmVlZHMgdG8gYXNrDQo+IHRoZSBuZXR3b3JrIGNvbnRyb2xsZXIgZm9yIGl0cyBNQUMg
YWRkcmVzcywgYW5kIHRoZW4gZG8gc29tZSBtYWdpY2FsDQo+IHRyYW5zZm9ybWF0aW9uIG9uIHRo
ZSBhbnN3ZXIgdG8gZGVyaXZlIGEgTUFDIGFkZHJlc3MgZm9yDQo+IGl0c2VsZi4gQ29ycmVjdD8N
Cg0KWWVzLiBJdCdzIGNvcnJlY3QuDQoNCj4gSXQgc2VlbXMgbGlrZSBhIGJldHRlciBkZXNpZ24g
d291bGQgb2YgYmVlbiwgdGhlIEJNQyBzZW5kcyBhDQo+IE5DU0lfT0VNX0dFVF9CTUNfTUFDIGFu
ZCB0aGUgYW5zd2VyIGl0IGdldHMgYmFjayBpcyB0aGUgTUFDIGFkZHJlc3MNCj4gdGhlIEJNQyBz
aG91bGQgdXNlLiBObyBtYWdpYyBpbnZvbHZlZC4gQnV0IGkgZ3Vlc3MgaXQgaXMgdG9vIGxhdGUg
dG8NCj4gZG8gdGhhdCBub3cuDQoNClNvbWUgTkNTSSBOZXR3b3JrIENvbnRyb2xsZXJzIHN1cHBv
cnQgc3VjaCBPRU0gY29tbWFuZCAoR2V0IFByb3Zpc2lvbmVkIEJNQyBNQUMgQWRkcmVzcyksIGJ1
dCB1bmZvcnR1bmF0ZWx5IGl0J3Mgbm90IHN1cHBvcnRlZCBvbiBZYW1wLg0KDQo+PiBJJ20gbm90
IHN1cmUgaWYgSSB1bmRlcnN0YW5kIHlvdXIgc3VnZ2VzdGlvbiBjb3JyZWN0bHk6IGRvIHlvdSBt
ZWFuDQo+PiB3ZSBzaG91bGQgbW92ZSB0aGUgbG9naWMgKEdFVF9NQUMgZnJvbSBOZXR3b3JrIENv
bnRyb2xsZXIsIGFkZGluZw0KPj4gb2Zmc2V0IGFuZCBjb25maWd1cmluZyBCTUMgTUFDKSBmcm9t
IGtlcm5lbCB0byBib290IGxvYWRlcj8NCj4gDQo+IEluIGdlbmVyYWwsIHRoZSBrZXJuZWwgaXMg
Z2VuZXJpYy4gSXQgcHJvYmFibHkgYm9vdHMgb24gYW55IEFSTSBzeXN0ZW0NCj4gd2hpY2ggaXMg
aGFzIHRoZSBuZWVkZWQgbW9kdWxlcyBmb3IuIFRoZSBib290bG9hZGVyIGlzIG9mdGVuIG11Y2gg
bW9yZQ0KPiBzcGVjaWZpYy4gSXQgbWlnaHQgbm90IGJlIGZ1bGx5IHBsYXRmb3JtIHNwZWNpZmlj
LCBidXQgaXQgd2lsbCBiZSBhdA0KPiBsZWFzdCBzcGVjaWZpYyB0byB0aGUgZ2VuZXJhbCBmYW1p
bHkgb2YgQk1DIFNvQ3MuIElmIHlvdSBjb25zaWRlciB0aGUNCj4gY29tYmluYXRpb24gb2YgdGhl
IEJNQyBib290bG9hZGVyIGFuZCB0aGUgZGV2aWNlIHRyZWUgYmxvYiwgeW91IGhhdmUNCj4gc29t
ZXRoaW5nIHNwZWNpZmljIHRvIHRoZSBwbGF0Zm9ybS4gVGhpcyBtYWdpY2FsIHRyYW5zZm9ybWF0
aW9uIG9mDQo+IGFkZGluZyAyIHNlZW1zIHRvIGJlIHZlcnkgcGxhdGZvcm0gc3BlY2lmaWMuIFNv
IGhhdmluZyB0aGlzIG1hZ2ljIGluDQo+IHRoZSBib290bG9hZGVyK0RUIHNlZW1zIGxpa2UgdGhl
IGJlc3QgcGxhY2UgdG8gcHV0IGl0Lg0KDQpJIHVuZGVyc3RhbmQgeW91ciBjb25jZXJuIG5vdy4g
VGhhbmsgeW91IGZvciB0aGUgZXhwbGFuYXRpb24uDQoNCj4gSG93ZXZlciwgaG93IHlvdSBwYXNz
IHRoZSByZXN1bHRpbmcgTUFDIGFkZHJlc3MgdG8gdGhlIGtlcm5lbCBzaG91bGQNCj4gYmUgYXMg
Z2VuZXJpYyBhcyBwb3NzaWJsZS4gVGhlIERUICJtYWMtYWRkcmVzcyIgcHJvcGVydHkgaXMgdmVy
eQ0KPiBnZW5lcmljLCBtYW55IE1BQyBkcml2ZXJzIHVuZGVyc3RhbmQgaXQuIFVzaW5nIGl0IGFs
c28gYWxsb3dzIGZvcg0KPiB2ZW5kb3JzIHdoaWNoIGFjdHVhbGx5IGFzc2lnbiBhIE1BQyBhZGRy
ZXNzIHRvIHRoZSBCTUMgdG8gcGFzcyBpdCB0bw0KPiB0aGUgQk1DLCBhdm9pZGluZyBhbGwgdGhp
cyBOQ1NJX09FTV9HRVRfTUFDIGhhbmRzaGFrZS4gSGF2aW5nIGFuIEFQSQ0KPiB3aGljaCBqdXN0
IHBhc3NpbmcgJzInIGlzIG5vdCBnZW5lcmljIGF0IGFsbC4NCg0KQWZ0ZXIgZ2l2aW5nIGl0IG1v
cmUgdGhvdWdodCwgSSdtIHRoaW5raW5nIGFib3V0IGFkZGluZyBuY3NpIGR0IG5vZGUgd2l0aCBm
b2xsb3dpbmcgc3RydWN0dXJlIChtYWMvbmNzaSBzaW1pbGFyIHRvIG1hYy9tZGlvL3BoeSk6DQoN
CiZtYWMwIHsNCiAgICAvKiBNQUMgcHJvcGVydGllcy4uLiAqLw0KDQogICAgdXNlLW5jc2k7DQog
ICAgbmNzaSB7DQogICAgICAgIC8qIG5jc2kgbGV2ZWwgcHJvcGVydGllcyBpZiBhbnkgKi8NCg0K
ICAgICAgICBwYWNrYWdlQDAgew0KICAgICAgICAgICAgLyogcGFja2FnZSBsZXZlbCBwcm9wZXJ0
aWVzIGlmIGFueSAqLw0KDQogICAgICAgICAgICBjaGFubmVsQDAgew0KICAgICAgICAgICAgICAg
IC8qIGNoYW5uZWwgbGV2ZWwgcHJvcGVydGllcyBpZiBhbnkgKi8NCg0KICAgICAgICAgICAgICAg
IGJtYy1tYWMtb2Zmc2V0ID0gPDI+Ow0KICAgICAgICAgICAgfTsNCg0KICAgICAgICAgICAgY2hh
bm5lbEAxIHsNCiAgICAgICAgICAgICAgICAvKiBjaGFubmVsICMxIHByb3BlcnRpZXMgKi8NCiAg
ICAgICAgICAgIH07DQogICAgICAgIH07DQoNCiAgICAgICAgLyogcGFja2FnZSAjMSBwcm9wZXJ0
aWVzIHN0YXJ0IGhlcmUuLiAqLw0KICAgIH07DQp9Ow0KDQpUaGUgcmVhc29ucyBiZWhpbmQgdGhp
cyBhcmU6DQoNCjEpIG1hYyBkcml2ZXIgZG9lc24ndCBuZWVkIHRvIHBhcnNlICJtYWMtb2Zmc2V0
IiBzdHVmZjogdGhlc2UgbmNzaS1uZXR3b3JrLWNvbnRyb2xsZXIgc3BlY2lmaWMgc2V0dGluZ3Mg
c2hvdWxkIGJlIHBhcnNlZCBpbiBuY3NpIHN0YWNrLg0KDQoyKSBnZXRfYm1jX21hY19hZGRyZXNz
IGNvbW1hbmQgaXMgYSBjaGFubmVsIHNwZWNpZmljIGNvbW1hbmQsIGFuZCB0ZWNobmljYWxseSBw
ZW9wbGUgY2FuIGNvbmZpZ3VyZSBkaWZmZXJlbnQgb2Zmc2V0L2Zvcm11bGEgZm9yIGRpZmZlcmVu
dCBjaGFubmVscy4NCg0KQW55IGNvbmNlcm5zIG9yIHN1Z2dlc3Rpb25zPw0KDQoNClRoYW5rcywN
Cg0KVGFvDQo=
