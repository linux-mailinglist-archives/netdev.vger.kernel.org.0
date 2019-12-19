Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D74D126E5F
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 21:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfLSUGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 15:06:41 -0500
Received: from mx0b-00273201.pphosted.com ([67.231.152.164]:24368 "EHLO
        mx0b-00273201.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726906AbfLSUGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 15:06:41 -0500
Received: from pps.filterd (m0108162.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJK6NW8006532;
        Thu, 19 Dec 2019 12:06:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=PPS1017;
 bh=2OOoPPZ3opPj95nLaLsYmfp+ijeBUkikHIAXzqVnTM8=;
 b=xgwhkwffYnLAPw9qlmGSGNd6YWIj54veeUyYQRCvJZhWxLW4WGA+N89Q7QtsZShVAnOl
 7EgoP4yF/urs7OycVtt39cOjznY41zCwIt0+8leG9kmxHkiVoa8gJul03yNdTh4sHHfR
 30dbviwqZg2VLN8Qm690LMqLoEKxFyLni58tIRN75Nf/cdHG6nnZQ7QFPh8Aw9z8rgbG
 Ux2EdfxdW0rdLkHsUho1rx88Pz6zyitura5LwXPGhPVK9d3ImU9I2y+lR8FCgPLEELsE
 Q/YT64nKohrGFZZiRWoJHauZ6hSPvqs5VZv8yH9G5OxoJdkd5jM2OqvgYf9Q9USJZP9X EQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0b-00273201.pphosted.com with ESMTP id 2x05dwh3c8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Dec 2019 12:06:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cNsqZcWxDsHYacut5OIPweDJ+CVUXJOBeVeD/8uKd1tTkPP/sD3gP/bteG3tKadnZURoVOSvwJAXJOK73voz61bz2O8XUAx+GR9buUcTf/XCslfiUWdSTNMY8iUoi/fgYgZTY4yaSiF16xG3Y/kTzOeY2BpLZnyyUDSS4N0tBPcU12LGhvQresA/5r7jApyJqC9B/vO8OiwURNbE0WW9nsMi+uP0ymx8WHtkWwiYccxwbn/1ppWDXaTX8G6FiE371b57+q6/3qsePVZWGYwOZ6dDti6qNahTEtmMJG304rQl91KBFdW//dBJGfahXYQavn1Y9RphfZXkX0rRTLqTsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OOoPPZ3opPj95nLaLsYmfp+ijeBUkikHIAXzqVnTM8=;
 b=Prm0crSXBF1Ao53d0xdSYgL1kKF/S1j7di5Liv+6sYBMk+hy0YRcQNw/TW5JiaWjUb2yeQHUb8VKom7tcI4CtWe6DBLi1yM/TRedwNI++NsHDg6rXfwPvPv6ixMPoXr9NVWiSQfWcG7xUAaO9rRIzZlUSn11tEa8R9HkbQK2z6m8t3fVdNcYWGH9fonyQMRRzuIA2muGDCw6LANFYYFrmHZrR59anhpP7bUJuUNJsMosmEMhr/tTn4DFTdg45sZEaeP9UM1NzAhjoLG+71hIlpAHQXjXHyXTucCbKac5pSM3qOY26Av3vuzJMld+S5rCVedeGN0eF8xnLb09ULOnjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OOoPPZ3opPj95nLaLsYmfp+ijeBUkikHIAXzqVnTM8=;
 b=i56bz1aYsXajXgJyLTSCi5jbVGEcdzC3jxRQCBWOuoR4JEF9n7V+oh5Dj9mqEQ8/pJyTWvZZyKRsj4iXVvxKEHM5GembgBJrE0A5GId6Rhu7t13z+K97UkIyczDV6/ncPCt7AgsU6jyj1EpYFTUFaxfB0jc6uo4WGiUOV4w6gV0=
Received: from CY4PR0501MB3827.namprd05.prod.outlook.com (52.132.99.143) by
 CY4PR0501MB3715.namprd05.prod.outlook.com (52.132.100.157) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.6; Thu, 19 Dec 2019 20:06:21 +0000
Received: from CY4PR0501MB3827.namprd05.prod.outlook.com
 ([fe80::8d77:6795:84cf:dd47]) by CY4PR0501MB3827.namprd05.prod.outlook.com
 ([fe80::8d77:6795:84cf:dd47%7]) with mapi id 15.20.2559.012; Thu, 19 Dec 2019
 20:06:21 +0000
From:   Edwin Peer <epeer@juniper.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Y Song <ys114321@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN
Thread-Topic: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN
Thread-Index: AQHVtgy6x2wMuQ42JECcwOBV53W8TKfBDSIA///4BwCAAJXcAP//j9uAgACtiID//4TxAA==
Date:   Thu, 19 Dec 2019 20:06:21 +0000
Message-ID: <9A7BE6FA-92FD-411F-BF8C-80484F1B0FBA@juniper.net>
References: <20191219013534.125342-1-epeer@juniper.net>
 <CAH3MdRUTcd7rjum12HBtrQ_nmyx0LvdOokZmA1YuhP2WtGfJqA@mail.gmail.com>
 <69266F42-6D0B-4F0B-805C-414880AC253D@juniper.net>
 <20191219154704.GC4198@linux-9.fritz.box>
 <CEA84064-FF2B-4AA7-84EE-B768D6ABC077@juniper.net>
 <20191219192645.5tbvxlhuugstokxf@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191219192645.5tbvxlhuugstokxf@ast-mbp.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Enabled=true;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Name=Juniper
 Business Use
 Only;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Enabled=true;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_ContentBits=0;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_Method=Standard;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_ActionId=dcdc48b8-d966-4fc9-9883-0000bd1c4933;MSIP_Label_9784d817-3396-4a4f-b60c-3ef6b345fe55_SetDate=2019-12-19T19:50:02Z;
x-originating-ip: [66.129.242.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 61573581-6e21-4e75-c77d-08d784beeae6
x-ms-traffictypediagnostic: CY4PR0501MB3715:
x-microsoft-antispam-prvs: <CY4PR0501MB3715EBBE07B1784407A11357B3520@CY4PR0501MB3715.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(376002)(39860400002)(346002)(199004)(189003)(6512007)(81166006)(81156014)(8676002)(6916009)(66476007)(66446008)(64756008)(66556008)(6486002)(86362001)(66946007)(76116006)(71200400001)(316002)(33656002)(91956017)(2616005)(2906002)(186003)(5660300002)(4326008)(36756003)(26005)(478600001)(8936002)(54906003)(6506007)(53546011);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR0501MB3715;H:CY4PR0501MB3827.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: juniper.net does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iP4dtOsRpEWkgRMQGOT2J1nBlsCZlIaifZZ5smMPy+v1OaxeJT+fHL2/8xWWX595WJInaL8fSCC25FQSL2DferdkgKvI0TM01ngKr3luhUAhrTwLugFA2tRYKbPT+tK3cVMYHIoL7ZhuYjJRXE/653XEO+fixfXSVfU5X32NsmDaf5ntShcWLgnx+m8CGapz4wyGwXIf959eWpU55OpF5RFvJ1GLcdCB6xtzh+M8L+YuX0KQR3dVK3hp/xTaABAnzWXrZJS4roftrnViivRwqCIp1bkkjm44aphEjCDqngOXtW4CijAsNhn2BeHKJgLnWRKtJtgXPrqhXjnFx41Sh5setqkudQAzZyFYGQpUCO1ipLOaZEB4a4xaLx1PT8GvSuuSvHARQz72tNlwDkRv2K35XCPa1IJMjTQXOYhTVMlKYD5eN08cP6Dnj3D19jn8
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <12C2DF504ADF2D40BD71437413C8DBC9@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-Network-Message-Id: 61573581-6e21-4e75-c77d-08d784beeae6
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 20:06:21.4238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /yM696A35pXHOIe7I87+DGRYtdDnGQs5d7EPOvO79BymCsrU8On2pNRSVTtKjhrU8Mp8z+gWSBw8+gXSBj4ejA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR0501MB3715
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-19_06:2019-12-17,2019-12-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 clxscore=1011
 mlxlogscore=999 adultscore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 spamscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTIvMTkvMTksIDExOjI2LCAiQWxleGVpIFN0YXJvdm9pdG92IiA8YWxleGVpLnN0YXJvdm9p
dG92QGdtYWlsLmNvbT4gd3JvdGU6DQoNCj4gT24gVGh1LCBEZWMgMTksIDIwMTkgYXQgMDU6MDU6
NDJQTSArMDAwMCwgRWR3aW4gUGVlciB3cm90ZToNCj4+IE9uIDEyLzE5LzE5LCAwNzo0NywgIkRh
bmllbCBCb3JrbWFubiIgPGRhbmllbEBpb2dlYXJib3gubmV0PiB3cm90ZToNCj4+IA0KPj4gPiAg
V2hhdCBhYm91dCBDQVBfQlBGPw0KPj4gDQo+PiBXaGF0IGlzIHRoZSBzdGF0dXMgb2YgdGhpcz8g
SXQgbWlnaHQgc29sdmUgc29tZSBvZiB0aGUgcHJvYmxlbXMsIGJ1dCBpdCBpcyBzdGlsbCBwdXRz
IHRlc3RpbmcNCj4+IEJQRiBvdXRzaWRlIHJlYWNoIG9mIG5vcm1hbCB1c2Vycy4NCj4gICAgDQo+
IHdoeT8NCj4gSSB0aGluayBDQVBfQlBGIGlzIHNvbHZpbmcgZXhhY3RseSB3aGF0IHlvdSdyZSB0
cnlpbmcgdG8gYWNoaWV2ZS4NCg0KSSdtIHRyeWluZyB0byBwcm92aWRlIGFjY2VzcyB0byBCUEYg
dGVzdGluZyBpbmZyYXN0cnVjdHVyZSBmb3IgdW5wcml2aWxlZ2VkDQp1c2VycyAoYXNzdW1pbmcg
aXQgY2FuIGJlIGRvbmUgaW4gYSBzYWZlIHdheSwgd2hpY2ggSSdtIGFzIHlldCB1bnN1cmUgb2Yp
Lg0KQ0FQX0JQRiBpcyBub3QgdGhlIHNhbWUgdGhpbmcsIGJlY2F1c2UgYXQgbGVhc3Qgc29tZSBr
aW5kIG9mIHJvb3QNCmludGVydmVudGlvbiBpcyByZXF1aXJlZCB0byBhdHRhaW4gQ0FQX0JQRiBp
biB0aGUgZmlyc3QgcGxhY2UuDQoNCj4gV2hldGhlciBicGZfY2xvbmVfcmVkaXJlY3QoKSBpcyBz
dWNoIGhlbHBlciBpcyBzdGlsbCB0YmQuIFVucHJpdiB1c2VyIGNhbiBmbG9vZCBuZXRkZXZzDQo+
IHdpdGhvdXQgYW55IGJwZi4NCiAgIA0KVHJ1ZSwgYnV0IHByZXN1bWFibHkgc3VjaCB3b3VsZCBz
dGlsbCBiZSBzdWJqZWN0IHRvIGFkbWluaXN0cmF0b3INCmNvbnRyb2xsZWQgUW9TIGFuZCBmaXJl
d2FsbCBwb2xpY3k/IEFsc28gdW5wcml2aWxlZ2VkIHVzZXJzIHByZXN1bWFibHkNCmNhbid0IGNy
ZWF0ZSBhcmJpdHJhcnkgcGFja2V0cyBjb21pbmcgZnJvbSBzcG9vZmVkIElQcyAvIE1BQ3MsIHdo
aWNoIEkNCmJlbGlldmUgcmVxdWlyZXMgQ0FQX05FVF9SQVc/DQogDQo+PiBBcmUgdGhlcmUgb3Ro
ZXIgaGVscGVycyBvZiBjb25jZXJuIHRoYXQgY29tZSBpbW1lZGlhdGVseSB0byBtaW5kPyBBIGZp
cnN0IHN0YWIgbWlnaHQNCj4+IGFkZCB0aGVzZSB0byB0aGUgbGlzdCBpbiB0aGUgdmVyaWZpZXIg
dGhhdCByZXF1aXJlIHByaXZpbGVnZS4gVGhpcyBoYXMgdGhlIGRyYXdiYWNrIHRoYXQNCj4+IHBy
b2dyYW1zIHRoYXQgYWN0dWFsbHkgbmVlZCB0aGlzIGtpbmQgb2YgZnVuY3Rpb25hbGl0eSBhcmUg
YmV5b25kIHRoZSB0ZXN0IGZyYW1ld29yay4NCj4gICAgDQo+ICAgU28gZmFyIG1ham9yaXR5IG9m
IHByb2dyYW1zIHJlcXVpcmUgcm9vdC1vbmx5IHZlcmlmaWVyIGZlYXR1cmVzLiBUaGUgcHJvZ3Jh
bXMgYXJlDQo+ICAgZ2V0dGluZyBtb3JlIGNvbXBsZXggYW5kIGJlbmVmaXQgdGhlIG1vc3QgZnJv
bSB0ZXN0aW5nLiBSZWxheGluZyB0ZXN0X3J1biBmb3IgdW5wcml2DQo+ICAgcHJvZ3MgaXMgaW1v
IHZlcnkgbmFycm93IHVzZSBjYXNlLiBJJ2QgcmF0aGVyIHVzZSBDQVBfQlBGLg0KICAgIA0KVGhl
IG1vcmUgZWxhYm9yYXRlIHByb3Bvc2FsIGNhbGxlZCBmb3IgbW9ja2luZyB0aGVzZSBhc3BlY3Rz
IGZvcg0KdGVzdGluZywgd2hpY2ggY291bGQgY29uY2VpdmFibHkgcmVzb2x2ZSB0aGlzPyBUaGF0
IHNhaWQsIEkgc2VlIGFuDQppbmNyZW1lbnRhbCBwYXRoIHRvIHRoaXMsIGFkZGluZyBzdWNoIGFz
IG5lZWRlZC4gVGhlIG5hcnJvd25lc3MNCm9mIHRoZSB1c2UgY2FzZSByZWFsbHkgZGVwZW5kcyBv
biBleGFjdGx5IHdoYXQgeW91J3JlIHRyeWluZyB0byBkby4NClNvbWV0aGluZyBpbiBYRFAsIGZv
ciBleGFtcGxlLCBoYXMgdmVyeSBsaXR0bGUga2VybmVsIGRlcGVuZGVuY2llcw0KKHBvc3NpYmx5
IG5vbmUgdGhhdCB3b3VsZCBiZSBhZmZlY3RlZCBoZXJlKSBhbmQgcmVwcmVzZW50cyBhbiBlbnRp
cmUNCmNsYXNzIG9mIHVzZSBjYXNlcyB0aGF0IGNvdWxkIGhhdmUgdW5wcml2aWxlZ2VkIHRlc3Rp
bmcgYmUgc3VwcG9ydGVkLg0KDQpSZWdhcmRzLA0KRWR3aW4gUGVlcg0KDQo=
