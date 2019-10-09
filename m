Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A22D062B
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbfJIEBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:01:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3446 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725440AbfJIEBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 00:01:19 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x993xg76022410;
        Tue, 8 Oct 2019 20:59:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PujgvuEMz2YlDZzakwc0IEe3mrWqtqoPKbzWBN7PrEk=;
 b=Q7trm3+qoLNjTjotROfLX0SzpH78BgIuV4cAPjsPtQg28B8KTCg0aTUi/JfwVgak8sVn
 KkGpZBlYWXrlznXbTnQ3mdHxQ1Vpfc0zaBMLiU3sgA0e1GraAVF3Hyam7TRPa9yKkiI8
 /WaWMAC/G8DJbC6grhh+xjmLzz0lN0hZjow= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vgdb3ydn9-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Oct 2019 20:59:46 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Oct 2019 20:59:07 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 8 Oct 2019 20:59:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcpmzgwQiNMwBvu/wkxOg4X6oDdPn0lfXbrGnYkGRtm1H9u5sUnFLQv8nVEZNd0hkor0Y0pyFSy71px60LRGBPXqk+MKZESqmxnPwdkY0LczzGk4ZbI9sXB16GNZWew9nzwSRZOlND77MqZxkgMXhsnx1mlVLQK1EN01D2OxsvHJuNezLF+f1pxmbnrNryeTH6XA8pw99fhHgzoq0aabWD/b6Elj4Jyq3DNAkJqEi4xCBWOxPIwVszRYmvA1XjfrUM7Dts3keb4NfJUgsXnVK97w+dw7KXOEiJT1EPND5Jj+QMQ77vlKiGme5MHuWIiUZIDYudYaWTImznrXhx8ONQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PujgvuEMz2YlDZzakwc0IEe3mrWqtqoPKbzWBN7PrEk=;
 b=V+MIH9uyyg8sBvgYVzDIMQ43ZmR4KzneubTIf+a/XKuUq15CinZNNguMtoBbPY1QyvyxC+5qBspkYQ5/jE3WqGaNyGqBNzQZr3OhAKPYsZbIp1vu/C+EEN2/xx6FZ7D6c7+wkcViOx+VpjHEZO/88f10hQFqfbAE2NV6NA8ErGnKWm2djFY8JBZfQelViZBVxPsqqGANaAwj/yf7fEgJP+raA3THusfkmC19EpwtRKyoMJMtHu9nBGWc/soiBtxY0WHYn0D+9sYXRJSWCFIs/1iUgSNKPFXs2dKRaBlkYUGGwfqLaqaxozFtdq1x1WiEbkmyU/rC81zFNMZspiwXcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PujgvuEMz2YlDZzakwc0IEe3mrWqtqoPKbzWBN7PrEk=;
 b=jlDuhDsiFGan2rpVlyu7dIJBCQzxZrQFHKYvCeZL6slU5HEvSwUZYBT9asgkDpYI+Rpjtbg7rGieL5ZqKqKdubrt/JQfUnD+E2nI4at8DJYQwEahAEufzjXKCVA8p5H2fGWb+PExdjJj/hbP/ZjRHT+YuVQwHHAK+ndkBUzfg5A=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2392.namprd15.prod.outlook.com (52.135.198.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 03:59:06 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2327.026; Wed, 9 Oct 2019
 03:59:06 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 05/10] bpf: implement accurate raw_tp context
 access via BTF
Thread-Topic: [PATCH bpf-next 05/10] bpf: implement accurate raw_tp context
 access via BTF
Thread-Index: AQHVezo5sKYubhk6UEK1EwMR6IEna6dPYwwAgAJSRoA=
Date:   Wed, 9 Oct 2019 03:59:06 +0000
Message-ID: <8615dd2a-0ab9-9130-93db-bacefba57609@fb.com>
References: <20191005050314.1114330-1-ast@kernel.org>
 <20191005050314.1114330-6-ast@kernel.org>
 <alpine.LRH.2.20.1910071131470.12667@dhcp-10-175-191-98.vpn.oracle.com>
In-Reply-To: <alpine.LRH.2.20.1910071131470.12667@dhcp-10-175-191-98.vpn.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0044.namprd14.prod.outlook.com
 (2603:10b6:300:12b::30) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::851e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d91147b6-48e0-4df1-07ca-08d74c6d07d3
x-ms-traffictypediagnostic: BYAPR15MB2392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB2392F56A4C3AC48278B48A0BD7950@BYAPR15MB2392.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:335;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(346002)(39860400002)(136003)(189003)(199004)(229853002)(6246003)(6116002)(25786009)(86362001)(11346002)(305945005)(7736002)(46003)(446003)(36756003)(4326008)(2616005)(476003)(14454004)(486006)(64756008)(76176011)(54906003)(31686004)(81166006)(81156014)(316002)(110136005)(2906002)(71200400001)(66446008)(8676002)(99286004)(478600001)(71190400001)(66946007)(52116002)(66556008)(66476007)(6512007)(186003)(102836004)(31696002)(14444005)(256004)(6436002)(6506007)(386003)(53546011)(6486002)(5660300002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2392;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VhD14oJMyt0kqidzMt+pChWShbFNqyD5b28wwPphJrl/6yf+GhO1kP9fAddSLPRVfCOGvBT5V3ub+JUfWuHWj44XMjEmcvPQQne8FpxC3fdlVoCfojif3x60rbqN+hj8MFMR7E9HUOCokihKucBrN2V1YgkwJ9F4+FF00m9teciw6s2/Lwn0yWak+lH7kfXTpHdDf9552QVdTCFtCHYvoN6dSbsj5Z39ksEr13CJKzMJwNguNVF0QwNy/8UNtcMLn0HkhZ8NyufWw47DJPE+b3wJO5VpQJpYUoQqWcbDJ7C4LxYEeI496fzPKJQ7phsJqkZZTiL8YxrEAQm3aMiZ1OVtzvjdxwuKixaj4uqQsgoLeelI2nXRFNUd5Kto/HeG2LKXxXcTJV8q4qTeYX3OqByTFJMHSFroQ5eZn2NmJKI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E87B901D4A97EA40820849BD99C8720D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d91147b6-48e0-4df1-07ca-08d74c6d07d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 03:59:06.5329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ECihX2dH67JKk1xYnlnxO1uqy+vDWnaHcgSw5e4GXnSpo9YRzvGl01Bi3g8Si4s
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2392
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_02:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 clxscore=1011
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910090033
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvNy8xOSA5OjMyIEFNLCBBbGFuIE1hZ3VpcmUgd3JvdGU6DQo+IFRoaXMgaXMgYW4gaW5j
cmVkaWJsZSBsZWFwIGZvcndhcmQhIE9uZSBxdWVzdGlvbiBJIGhhdmUgcmVsYXRlcyB0bw0KPiBh
bm90aGVyIGFzcGVjdCBvZiBjaGVja2luZy4gQXMgd2UgbW92ZSBmcm9tIGJwZl9wcm9iZV9yZWFk
KCkgdG8gImRpcmVjdA0KPiBzdHJ1Y3QgYWNjZXNzIiwgc2hvdWxkIHdlIGhhdmUgdGhlIHZlcmlm
aWVyIGluc2lzdCBvbiB0aGUgc2FtZSBzb3J0IG9mDQo+IGNoZWNraW5nIHdlIGhhdmUgZm9yIGRp
cmVjdCBwYWNrZXQgYWNjZXNzPyBTcGVjaWZpY2FsbHkgSSdtIHRoaW5raW5nIG9mDQo+IHRoZSBj
YXNlIHdoZXJlIGEgdHlwZWQgcG9pbnRlciBhcmd1bWVudCBtaWdodCBiZSBOVUxMIGFuZCB3ZSBh
dHRlbXB0IHRvDQo+IGRlcmVmZXJlbmNlIGl0LiAgVGhpcyBtaWdodCBiZSBhcyBzaW1wbGUgYXMg
YWRkaW5nDQo+IFBUUl9UT19CVEZfSUQgdG8gdGhlIHJlZ190eXBlX21heV9iZV9udWxsKCkgY2hl
Y2s6DQo+IA0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL2JwZi92ZXJpZmllci5jIGIva2VybmVsL2Jw
Zi92ZXJpZmllci5jDQo+IGluZGV4IDA3MTdhYWMuLjY1NTliNGQgMTAwNjQ0DQo+IC0tLSBhL2tl
cm5lbC9icGYvdmVyaWZpZXIuYw0KPiArKysgYi9rZXJuZWwvYnBmL3ZlcmlmaWVyLmMNCj4gQEAg
LTM0Miw3ICszNDIsOCBAQCBzdGF0aWMgYm9vbCByZWdfdHlwZV9tYXlfYmVfbnVsbChlbnVtIGJw
Zl9yZWdfdHlwZQ0KPiB0eXBlKQ0KPiAgICAgICAgICByZXR1cm4gdHlwZSA9PSBQVFJfVE9fTUFQ
X1ZBTFVFX09SX05VTEwgfHwNCj4gICAgICAgICAgICAgICAgIHR5cGUgPT0gUFRSX1RPX1NPQ0tF
VF9PUl9OVUxMIHx8DQo+ICAgICAgICAgICAgICAgICB0eXBlID09IFBUUl9UT19TT0NLX0NPTU1P
Tl9PUl9OVUxMIHx8DQo+IC0gICAgICAgICAgICAgIHR5cGUgPT0gUFRSX1RPX1RDUF9TT0NLX09S
X05VTEw7DQo+ICsgICAgICAgICAgICAgIHR5cGUgPT0gUFRSX1RPX1RDUF9TT0NLX09SX05VTEwg
fHwNCj4gKyAgICAgICAgICAgICAgdHlwZSA9PSBQVFJfVE9fQlRGX0lEOw0KPiAgIH0NCj4gICAN
Cj4gLi4uaW4gb3JkZXIgdG8gZW5zdXJlIHdlIGRvbid0IGRlcmVmZXJlbmNlIHRoZSBwb2ludGVy
IGJlZm9yZSBjaGVja2luZyBmb3INCj4gTlVMTC4gIFBvc3NpYmx5IEknbSBtaXNzaW5nIHNvbWV0
aGluZyB0aGF0IHdpbGwgZG8gdGhhdCBOVUxMIGNoZWNraW5nDQo+IGFscmVhZHk/DQoNCndlbGws
IGl0J3Mgbm90IGFzIHNpbXBsZSBhcyBhYm92ZSA7KSBidXQgdGhlIHBvaW50IGlzIHZhbGlkLg0K
WWVzLiBJdCdzIGRlZmluaXRlbHkgcG9zc2libGUgdG8gZW5mb3JjZSBOVUxMIGNoZWNrIGZvciBl
dmVyeSBzdGVwDQpvZiBidGYgcG9pbnRlciB3YWxraW5nLg0KDQpUaGUgdGhpbmcgaXMgdGhhdCBp
biBicGYgdHJhY2luZyBhbGwgc2NyaXB0cyBhcmUgdXNpbmcgYnBmX3Byb2JlX3JlYWQNCmFuZCB3
YWxrIHRoZSBwb2ludGVycyB3aXRob3V0IGNoZWNraW5nIGVycm9yIGNvZGUuDQpJbiBtb3N0IGNh
c2VzIHRoZSBwZW9wbGUgd2hvIHdyaXRlIHRob3NlIHNjcmlwdHMga25vdyB3aGF0IHRoZXkncmUN
CndhbGtpbmcgYW5kIGtub3cgdGhhdCB0aGUgcG9pbnRlcnMgd2lsbCBiZSB2YWxpZC4NClRha2Ug
ZXhlY3Nub29wLnB5IGZyb20gYmNjL3Rvb2xzLiBJdCdzIGRvaW5nOg0KdGFzay0+cmVhbF9wYXJl
bnQtPnRnaWQ7DQpFdmVyeSBhcnJvdyBiY2MgaXMgbWFnaWNhbGx5IHJlcGxhY2luZyB3aXRoIGJw
Zl9wcm9iZV9yZWFkLg0KSSBiZWxpZXZlICdyZWFsX3BhcmVudCcgaXMgYWx3YXlzIHZhbGlkLCBz
byBhYm92ZSBzaG91bGQNCnJldHVybiBleHBlY3RlZCBkYXRhIGFsbCB0aGUgdGltZS4NCkJ1dCBl
dmVuIGlmIHRoZSBwb2ludGVyIGlzIG5vdCB2YWxpZCB0aGUgY29zdCBvZiBjaGVja2luZyBpdA0K
aW4gdGhlIHByb2dyYW0gaXMgbm90IHdvcnRoIGl0LiBBbGwgYWNjZXNzZXMgYXJlIHByb2JlX3Jl
YWQtZWQuDQpJZiB3ZSBtYWtlIHZlcmlmaWVyIGZvcmNpbmcgdXNlcnMgdG8gY2hlY2sgZXZlcnkg
cG9pbnRlciBmb3IgTlVMTA0KdGhlIGJwZiBDIGNvZGUgd2lsbCBsb29rIHZlcnkgdWdseS4NCkFu
ZCBub3Qgb25seSB1Z2x5LCBidXQgc2xvdy4gQ29kZSBzaXplIHdpbGwgaW5jcmVhc2UsIGV0Yy4N
Cg0KTG9uZyB0ZXJtIHdlJ3JlIHRoaW5raW5nIHRvIGFkZCB0cnkvY2F0Y2gtbGlrZSBidWlsdGlu
cy4NClNvIGluc3RlYWQgb2YgZG9pbmcNCiAgICAgICAgIF9fYnVpbHRpbl9wcmVzZXJ2ZV9hY2Nl
c3NfaW5kZXgoKHsNCiAgICAgICAgICAgICAgICAgZGV2ID0gc2tiLT5kZXY7DQogICAgICAgICAg
ICAgICAgIGlmaW5kZXggPSBkZXYtPmlmaW5kZXg7DQogICAgICAgICB9KSk7DQpsaWtlIHRoZSB0
ZXN0IGZyb20gcGF0Y2ggMTAgaXMgZG9pbmcuDQpXZSB3aWxsIGJlIGFibGUgdG8gd3JpdGUgQlBG
IHByb2dyYW0gbGlrZToNCiAgICAgICAgIF9fYnVpbHRpbl90cnkoKHsNCiAgICAgICAgICAgICAg
ICAgZGV2ID0gc2tiLT5kZXY7DQogICAgICAgICAgICAgICAgIGlmaW5kZXggPSBkZXYtPmlmaW5k
ZXg7DQogICAgICAgICB9KSwgKHsNCgkJLy8gaGFuZGxlIHBhZ2UgZmF1bHQNCgkJYnBmX3ByaW50
aygic2tiIGlzIE5VTEwgb3Igc2tiLT5kZXYgaXMgTlVMTCEgc3Vja3MiKTsNCgl9KSk7DQpPbiB0
aGUga2VybmVsIHNpZGUgaXQgd2lsbCBiZSBzdXBwb3J0ZWQgdGhyb3VnaCBleHRhYmxlIG1lY2hh
bmlzbS4NCk9uY2Ugd2UgcmVhbGl6ZWQgdGhhdCBDIGxhbmd1YWdlIGNhbiBiZSBpbXByb3ZlZCB3
ZSBzdGFydGVkIGRvaW5nIHNvIDopDQo=
