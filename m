Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8AA1258C1
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfLSAmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:42:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48088 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726559AbfLSAmQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:42:16 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBJ0fkNI007716;
        Wed, 18 Dec 2019 16:42:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rwkiZ4X4v6+r5af1WV7klUAIvWUjQTFduYq6ul+j+Lw=;
 b=HrBgBEUOrwIvmp4jGa+4GI9HFmoCi2cq9Ekf6aLTo1UbieLe/p6afObuZLufxNcfITVz
 ZtzlU4Wq0bw2t8hhQJZZ3cRDLl6qrcPwfpE4iQnSnalnmJWvWw7CDtkYFGR832KMBChS
 Z/S+SLhIwqdZUX0VdcVv4aeOsBVFQ/wpTBw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wy61t6t7a-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 18 Dec 2019 16:42:03 -0800
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 18 Dec 2019 16:41:59 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 18 Dec 2019 16:41:59 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 18 Dec 2019 16:41:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YIJcjvLuEdmgo7uDvvP/Lij8SGwvQOfOm0xkTJTsp8wMeWycqartgPFLfN7/AD1X5/J+UifVqu75ycW/6M4+uCFwYXQroXZPE/snnEquG29w4RMTIhf5auu4p4rFeB8TYeyQoL8nRDTonozI69A3PlOa60KeSrJnIv+vZ+W75ms4NOU7uDIgDvGi7BislA15McbFwYaQrBebu6ert0DLEzW0jrzRyVSOS02ItW+DjmIaDAWHRLFfxlPlrepZF12XixJDF1BQRcO+QTE1PCaZ13sMraJF9dijSZkGD7tLjdsKRFXnohVvp3+jZj3y/mN4C37qXevHA3714SfLl/7z1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwkiZ4X4v6+r5af1WV7klUAIvWUjQTFduYq6ul+j+Lw=;
 b=UFa8fFmHVT4hxtfwRSnTa5WDTVkOkpOOv96i57r7zQ6Q1PzOFATkOMRhsfgm9g998J16HhIgrGlz1GETM6h9/GkgyfnGb0s5uSqwH6GGCbDNp0Y44/TCOJmP6i07Cdah7twGcPo8dbMa7orsd7ORwY7ajz3RUuuAVKKA4YMBDzzvwjsfC/usl98kV14xumzFCah5rA6KZ+Ps7sY0G6VRoV7aCe4FrH2xKejaaOzw66JMk6EuyQ7dd1o/3Ji9SmUugExGABn8Tvzo9qzmMmEw0ORXd/wafhDOyAgqbEM9iHCTXcuMe0Bh4z2qYQ/FEfb9PNjxvpUx6b5G8+i8tD+pPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwkiZ4X4v6+r5af1WV7klUAIvWUjQTFduYq6ul+j+Lw=;
 b=FMyqVgoDbkNrfgo3An90BF3eSk6pT0rTeqqd6QQHxvS63K797cy4G4fzPZpVBpJSpykV1gm2mEnue9rG2jQ+0eXy/yba13k2aQSVBQBa0Wapb45vGMH4s9W4pNTHSk/klh7vxHCui3HFNqmRuv9KcNBSiWnGQzjMLjnkoccFZkc=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1706.namprd15.prod.outlook.com (10.174.108.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.14; Thu, 19 Dec 2019 00:41:58 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 00:41:57 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpftool: work-around rst2man conversion bug
Thread-Topic: [PATCH bpf-next] bpftool: work-around rst2man conversion bug
Thread-Index: AQHVtfvFdG9maJpGtUqoLFWYlcsFrafAnkAA
Date:   Thu, 19 Dec 2019 00:41:57 +0000
Message-ID: <1689268b-3f09-0a8a-b1dc-8c739901d92f@fb.com>
References: <20191218221707.2552199-1-andriin@fb.com>
 <bc49104a-01a7-8731-e811-53a6c9861a48@fb.com>
In-Reply-To: <bc49104a-01a7-8731-e811-53a6c9861a48@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR21CA0047.namprd21.prod.outlook.com
 (2603:10b6:300:129::33) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:31e6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b93411c-7f82-4f23-aeb4-08d7841c4099
x-ms-traffictypediagnostic: DM5PR15MB1706:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1706DC9C76EC215C864200D6D3520@DM5PR15MB1706.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0256C18696
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(136003)(396003)(39860400002)(189003)(199004)(2616005)(110136005)(52116002)(4326008)(81156014)(81166006)(54906003)(2906002)(71200400001)(53546011)(8936002)(86362001)(6486002)(8676002)(6512007)(31696002)(186003)(6506007)(66946007)(66446008)(66476007)(64756008)(66556008)(316002)(5660300002)(31686004)(478600001)(36756003)(21314003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1706;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0fX8vTdn3X03LsXTPG3Uv7pebBW9O+qMctk47YqVaiIY5P8EBzHBA14qHF0PPzcgKMDNRabkFLbiYYfc8TRcPymJIIfTn8o4pfK5MhTqH1oDgf61qUxnZsjOPTwbhwf1gkNrdLwXN0u5tLdhkqqiHE4sLboFUrj4TwfD0WYqXD2jkrO0Yu3sfEKVduk64shwBa8TYjOWWWrkSvJ/iaO9XwIVrUFZPAokaVM3iCVIvKn4sQVxw5pIs8C+cvJdM9R2FKmir+Caqr+FphrkJdV67UrWPgKmp69E55TpLlVBVFKZHBn51c+KlguJtUXzTKNUBGANKI0tf0PHNCZXW8OotLmeL60FCeDO9RBYDYLPqM3bSHvr6OvGswnidFLyZy5yRL12D24hY6cnh6vt/MhF0COi4nV6qvLcAkMmvjWndkrP0s2ZJkJPIubDprLf++Gr0MeY0pxWt/3Bwth/wqeO7679E/zQJwcsp36NTTpPK1y6vhmWFbgJvcDykLv6vkUr
Content-Type: text/plain; charset="utf-8"
Content-ID: <F5D85845128FDE4BBF2E8C8147466C0F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b93411c-7f82-4f23-aeb4-08d7841c4099
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2019 00:41:57.7487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Po3EkqTpATe8tH21CZKMdN1sWd9tZfcrZaREadQc4rrd3N4w8WcU3PkzW6YUWTRL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1706
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_08:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 mlxlogscore=881 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912190004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE4LzE5IDM6MzUgUE0sIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+IA0KPiANCj4g
T24gMTIvMTgvMTkgMjoxNyBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPj4gV29yay1hcm91
bmQgd2hhdCBhcHBlYXJzIHRvIGJlIGEgYnVnIGluIHJzdDJtYW4gY29udmVydGlvbiB0b29sLCB1
c2VkIHRvDQo+PiBjcmVhdGUgbWFuIHBhZ2VzIG91dCBvZiByZVN0cnVjdHVyZVRleHQtZm9ybWF0
dGVkIGRvY3VtZW50cy4gSWYgdGV4dCBsaW5lDQo+PiBzdGFydHMgd2l0aCBkb3QsIHJzdDJtYW4g
d2lsbCBwdXQgaXQgaW4gcmVzdWx0aW5nIG1hbiBmaWxlIHZlcmJhdGltLiBUaGlzDQo+PiBzZWVt
cyB0byBjYXVzZSBtYW4gdG9vbCB0byBpbnRlcnByZXQgaXQgYXMgYSBkaXJlY3RpdmUvY29tbWFu
ZCAoZS5nLiwgYC5ic2ApLCBhbmQNCj4+IHN1YnNlcXVlbnRseSBub3QgcmVuZGVyIGVudGlyZSBs
aW5lIGJlY2F1c2UgaXQncyB1bnJlY29nbml6ZWQgb25lLg0KPj4NCj4+IEVuY2xvc2UgJy54eHgn
IHdvcmRzIGluIGV4dHJhIGZvcm1hdHRpbmcgdG8gd29yayBhcm91bmQuDQo+Pg0KPj4gRml4ZXM6
IGNiMjFhYzU4ODU0NiAoImJwZnRvb2w6IEFkZCBnZW4gc3ViY29tbWFuZCBtYW5wYWdlIikNCj4+
IFJlcG9ydGVkLWJ5OiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFzdEBrZXJuZWwub3JnPg0KPj4gU2ln
bmVkLW9mZi1ieTogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCg0KQWNrZWQtYnk6
IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20NCg0KWy4uLl0NCj4+ICsJCSAgKi5ic3MqLCAqLnJv
ZGF0YSosIGFuZCAqLmtjb25maWcqIHN0cnVjdHMvZGF0YSBzZWN0aW9ucy4NCj4+ICsJCSAgVGhl
c2UgZGF0YSBzZWN0aW9ucy9zdHJ1Y3RzIGNhbiBiZSB1c2VkIHRvIHNldCB1cCBpbml0aWFsDQo+
PiArCQkgIHZhbHVlcyBvZiB2YXJpYWJsZXMsIGlmIHNldCBiZWZvcmUgKipleGFtcGxlX19sb2Fk
KiouDQo+PiArCQkgIEFmdGVyd2FyZHMsIGlmIHRhcmdldCBrZXJuZWwgc3VwcG9ydHMgbWVtb3J5
LW1hcHBlZCBCUEYNCj4+ICsJCSAgYXJyYXlzLCBzYW1lIHN0cnVjdHMgY2FuIGJlIHVzZWQgdG8g
ZmV0Y2ggYW5kIHVwZGF0ZQ0KPj4gKwkJICAobm9uLXJlYWQtb25seSkgZGF0YSBmcm9tIHVzZXJz
cGFjZSwgd2l0aCBzYW1lIHNpbXBsaWNpdHkNCj4+ICsJCSAgYXMgZm9yIEJQRiBzaWRlLg0KPiAN
Cj4gU3RpbGwgZG9lcyBub3QgbG9vayByaWdodC4NCj4gDQo+IEFmdGVyIGJ1aWxkLCBJIGRpZCBg
bWFuIC4vYnBmdG9vbC1nZW4uOGAsIGFuZCBJIGdvdCB0aGUgZm9sbG93aW5nLA0KPiANCj4gICAg
ICAgICAgICAgICAgICAgIHNwb25kaW5nIHRvIGdsb2JhbCBkYXRhIGRhdGEgc2VjdGlvbiBsYXlv
dXQgd2lsbCBiZQ0KPiBjcmVhdGVkLiBDdXJyZW50bHkgc3VwcG9ydGVkIG9uZXMNCj4gICAgICAg
ICAgICAgICAgICAgIGFyZTogLmRhdGEsIGRhdGEgc2VjdGlvbnMvc3RydWN0cyBjYW4gYmUgdXNl
ZCB0byBzZXQNCj4gdXAgaW5pdGlhbCB2YWx1ZXMgb2YgIHZhcmlhYmxlcywNCj4gDQo+IC5ic3Ms
IC5yb2RhdGEgLmtjb25maWcgZXRjLiBhcmUgbWlzc2luZy4gSSBhbSB1c2luZzoNCj4gDQo+IC1i
YXNoLTQuNCQgbWFuIC0tdmVyc2lvbg0KPiBtYW4gMi42LjMNCg0KU29ycnkuIEFjdHVhbGx5IHRo
aXMgcGF0Y2ggd29ya3MuIEkgYXBwbGllZCB0aGUgcHJldmlvdXMgcGF0Y2gNCiJicGZ0b29sOiBz
aW1wbGlmeSBmb3JtYXQgc3RyaW5nIHRvIG5vdCB1c2UgcG9zaXRpb25hbCBhcmdzIiBhbmQgZ290
DQp0aGUgYWJvdmUgcmVzdWx0Lg0K
