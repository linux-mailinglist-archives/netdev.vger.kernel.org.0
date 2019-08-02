Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D48080183
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 22:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406912AbfHBUAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 16:00:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55618 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406906AbfHBUAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 16:00:52 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x72JuhWD026049;
        Fri, 2 Aug 2019 13:00:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ZYqvXFmSvT7fqdc8TT0/r8LU0LoJHAQ474KLzncWBKY=;
 b=q/b07CmricWO3tzE/plO8K5kmJfVUkPjBUzNXrRVTcGePodJMzaUdgtEpUermST+ALkm
 3C5E1aocO5GjY8hx/YWlbaMRSrbTjve1PAKYALOlI5C6KxlyzZCVWIacAI1nskPtkap5
 S/kLa9pvMLidKyclyjDJjn8OVOGE4NFaNdY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2u4s4q0kxy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 02 Aug 2019 13:00:29 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 2 Aug 2019 13:00:27 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 2 Aug 2019 13:00:25 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 2 Aug 2019 13:00:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnWG2hF3ePAa0OHXtLhSvwv9U9METRwFuwjnU0bccBi++k9ZxrDoX2bU/opU9F18j7aQlBOliZf7EHbe2K4Z2mkUCF8JLKxXD0nsVykk9ZaS6yEl7YD++GZEJFJ1wBH7GIz9dsmmD7cgWOHo52SOiwl0blKqVdBURKncO3TEv49QosgDYImQYjAZUTwrpp234Oy/V94gcgyGHYgYA8meLBb2d07nmnq4yGnTDss/DOcAHESFg8BvwOv4JyTUrwqRj1S/I7QfSFNSDQ8l0wSXqKeT7wP1nIrAWeLwB4SnX6cRT3r5oGkcEBdfd76u9wuIvOoCe7OEC6SwYil967yZew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYqvXFmSvT7fqdc8TT0/r8LU0LoJHAQ474KLzncWBKY=;
 b=cP7MUZ2athQcYa64c/X9KT+E75legA/kl+4npN1NfWRS4s3e1tubxj+eSXMhgMX59Ln0LOv3zfAzV7ghNBN0qNM5U2DsrTWwajlSeiM0zG/oSu9YgTMQ6Nw02j7dT5IzerCtIgwx49RllzwowftVOGxkRn03N5Yu+07RJamgaAEbKwhoVJB31OkKwisnVJyqBR70LEvArCQ1ixO5sAvrUA0AQpp401bvHK7bWzOLB165jr/GLJUNV7rbVeUsOl/vAnPnAsYSQy+9D+93sOClFLm+sgbTjicOrrQx7LaaMxsLzrfSS5NJYBau1JLuPwON+4pK6sEpylnnVpsT1uvtgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZYqvXFmSvT7fqdc8TT0/r8LU0LoJHAQ474KLzncWBKY=;
 b=QaQ6LaXmXdCCQnnTY0zNETOgyGR6cYZkGwAGSNsC6oREV2VBdzaWKO+KO9NjiubRzb3vpnxwWW+Fzo4p55IHlzQEPCLbGNxPvEkRxiMaDSKovlph9Zj7AiSod99J6MbitbSLGNFr3mRrZE/gSIz9MVGaS5Zjw/Uv1bBzgFNFoxY=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1864.namprd15.prod.outlook.com (10.174.52.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.14; Fri, 2 Aug 2019 20:00:24 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::79a3:6a7a:1014:a5e4]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::79a3:6a7a:1014:a5e4%8]) with mapi id 15.20.2115.005; Fri, 2 Aug 2019
 20:00:24 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next 0/3] selftests/bpf: switch test_progs back to
 stdio
Thread-Topic: [PATCH bpf-next 0/3] selftests/bpf: switch test_progs back to
 stdio
Thread-Index: AQHVSVYqECHuQeWTKE66u6+ERAQl4KboRyeA
Date:   Fri, 2 Aug 2019 20:00:24 +0000
Message-ID: <c79d3a8c-4986-a321-7b68-5273be7c2be7@fb.com>
References: <20190802171710.11456-1-sdf@google.com>
In-Reply-To: <20190802171710.11456-1-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:300:c0::21) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::e445]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0550fac3-379d-4e5d-2a4a-08d717840e7f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1864;
x-ms-traffictypediagnostic: CY4PR15MB1864:
x-microsoft-antispam-prvs: <CY4PR15MB186424DAC59317EADF678C3EC6D90@CY4PR15MB1864.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(366004)(396003)(346002)(39860400002)(189003)(199004)(54094003)(65956001)(6486002)(64126003)(64756008)(6246003)(65806001)(46003)(229853002)(110136005)(58126008)(6436002)(54906003)(316002)(8676002)(71190400001)(71200400001)(186003)(31686004)(81156014)(8936002)(53936002)(486006)(81166006)(7736002)(305945005)(99286004)(256004)(102836004)(5660300002)(86362001)(4326008)(476003)(2616005)(14444005)(6116002)(11346002)(6512007)(52116002)(446003)(14454004)(2906002)(76176011)(2501003)(478600001)(53546011)(36756003)(386003)(6506007)(25786009)(2201001)(66476007)(31696002)(66946007)(68736007)(65826007)(66446008)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1864;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MCgqgYQDACOgzMI713nuDS7RDrschgCBIQF/QWUo75GUJ8JK25TCOi2pTQIBKB3ZGfWqxBELedYItmb5lPvHLQF+SudmG2g5l3j8tbgZrok0vt1K4SZY13yYAFmCWvNZPKbY5UdbZr9f06lWXAYfeTBXq/IMw5gyf0772P3J8ZDAb/U6rqHDrJoV+jGIuMypDTs4VRRlJ28ZZI7x+sBMyp0UTWuvoCFmGzhzwXIldvOsVWi7+iCw3IUaHmcZw/INLGMVKftAsdxyqyvnMqQjVsO2gi4Hqkeq2dqcycRioN9R/5ZKrFF3p7YbVxETHETQi18x5th0boxd/bdXIiVGMF7O+g023BJL7wWzaUi1Fk0alurDPYLRawJQeatiJZQ4G/2u0Su+gLwSya02GcEQCjJsh2ZHJ5xovOzhz4jz2ZQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <15F333B81E5FFA4F806EA6F59D0596BB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 0550fac3-379d-4e5d-2a4a-08d717840e7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 20:00:24.3870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: andriin@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1864
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908020211
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA4LzIvMTkgMTA6MTcgQU0sIFN0YW5pc2xhdiBGb21pY2hldiB3cm90ZToNCj4gSSB3YXMg
bG9va2luZyBpbnRvIGNvbnZlcnRpbmcgdGVzdF9zb2Nrb3BzKiB0byB0ZXN0X3Byb2dzIGZyYW1l
d29yaw0KPiBhbmQgdGhhdCByZXF1aXJlcyB1c2luZyBjZ3JvdXBfaGVscGVycy5jIHdoaWNoIHJl
bHkgb24gc3RkaW8vc3RkZXJyLg0KPiBMZXQncyB1c2Ugb3Blbl9tZW1zdHJlYW0gdG8gb3ZlcnJp
ZGUgc3Rkb3V0IGludG8gYnVmZmVyIGR1cmluZw0KPiBzdWJ0ZXN0cyBpbnN0ZWFkIG9mIGN1c3Rv
bSB0ZXN0X3t2LH1wcmludGYgd3JhcHBlcnMuIFRoYXQgbGV0cw0KPiB1cyBjb250aW51ZSB0byB1
c2Ugc3RkaW8gaW4gdGhlIHN1YnRlc3RzIGFuZCBkdW1wIGl0IG9uIGZhaWx1cmUNCj4gaWYgcmVx
dWlyZWQuDQo+DQo+IFRoYXQgd291bGQgYWxzbyBmaXggYnBmX2ZpbmRfbWFwIHdoaWNoIGN1cnJl
bnRseSB1c2VzIHByaW50ZiB0bw0KPiBzaWduYWwgZmFpbHVyZSAobWlzc2VkIGR1cmluZyB0ZXN0
X3ByaW50ZiBjb252ZXJzaW9uKS4NCkkgd29uZGVyIGlmIHdlIHNob3VsZCBoaWphY2sgc3RkZXJy
IGFzIHdlbGw/DQo+DQo+IENjOiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIuY29tPg0KPg0K
PiBTdGFuaXNsYXYgRm9taWNoZXYgKDMpOg0KPiAgIHNlbGZ0ZXN0cy9icGY6IHRlc3RfcHJvZ3M6
IHN3aXRjaCB0byBvcGVuX21lbXN0cmVhbQ0KPiAgIHNlbGZ0ZXN0cy9icGY6IHRlc3RfcHJvZ3M6
IHRlc3RfX3ByaW50ZiAtPiBwcmludGYNCj4gICBzZWxmdGVzdHMvYnBmOiB0ZXN0X3Byb2dzOiBk
cm9wIGV4dHJhIHRyYWlsaW5nIHRhYg0KPg0KPiAgLi4uL2JwZi9wcm9nX3Rlc3RzL2JwZl92ZXJp
Zl9zY2FsZS5jICAgICAgICAgIHwgICA0ICstDQo+ICAuLi4vc2VsZnRlc3RzL2JwZi9wcm9nX3Rl
c3RzL2w0bGJfYWxsLmMgICAgICAgfCAgIDIgKy0NCj4gIC4uLi9zZWxmdGVzdHMvYnBmL3Byb2df
dGVzdHMvbWFwX2xvY2suYyAgICAgICB8ICAxMCArLQ0KPiAgLi4uL3NlbGZ0ZXN0cy9icGYvcHJv
Z190ZXN0cy9zZW5kX3NpZ25hbC5jICAgIHwgICA0ICstDQo+ICAuLi4vc2VsZnRlc3RzL2JwZi9w
cm9nX3Rlc3RzL3NwaW5sb2NrLmMgICAgICAgfCAgIDIgKy0NCj4gIC4uLi9icGYvcHJvZ190ZXN0
cy9zdGFja3RyYWNlX2J1aWxkX2lkLmMgICAgICB8ICAgNCArLQ0KPiAgLi4uL2JwZi9wcm9nX3Rl
c3RzL3N0YWNrdHJhY2VfYnVpbGRfaWRfbm1pLmMgIHwgICA0ICstDQo+ICAuLi4vc2VsZnRlc3Rz
L2JwZi9wcm9nX3Rlc3RzL3hkcF9ub2lubGluZS5jICAgfCAgIDQgKy0NCj4gIHRvb2xzL3Rlc3Rp
bmcvc2VsZnRlc3RzL2JwZi90ZXN0X3Byb2dzLmMgICAgICB8IDExNiArKysrKysrLS0tLS0tLS0t
LS0NCj4gIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3Byb2dzLmggICAgICB8ICAx
MiArLQ0KPiAgMTAgZmlsZXMgY2hhbmdlZCwgNjggaW5zZXJ0aW9ucygrKSwgOTQgZGVsZXRpb25z
KC0pDQo+DQo=
