Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBA02AB49F
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 11:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403812AbfIFJJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 05:09:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15858 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2403767AbfIFJJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 05:09:41 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x869999b003151;
        Fri, 6 Sep 2019 02:09:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=iQ0yPSwuN5mrShejf6iwU8O41/Ju2uu71H/havnfRyQ=;
 b=Ocz3yJ0FUJT7UebareBm/YXTYP++HyY8U5uydJCm2IdjVnb7qexpPgS2vLz7MT3UhliM
 cDjwz8pEiJmuUbQjKYfPFPCWzm1STQZhy21WefxpjlVrzePDk4AR2YDcV/twLbYm6eKD
 Yu7dkEbhe1KiPhSuYuZF9ZMFatReX3GtQzM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2uu6wu349x-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 06 Sep 2019 02:09:20 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 6 Sep 2019 02:09:19 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 6 Sep 2019 02:09:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3wpZLpcfUwHRaqIqZLr/n2VuO1qh6Dn366HToxFJrc+pu42djhs3NNDQbH6csq4fbjRaWd3vKoS5AdztbNbIBrPTPO9DxTorhgcpVYQUhk9uYIc0/CbS/rbiUMfO4q3l1CWYjhLt2DiomL8jGZ7zL2vTKkVpH3OmgRbFa+/H0oQDCBLeIpK4HzY/604oz+L/GnWgeFVIYWD+mUUkredMKfIYvaIWzh+fnPexgZjUnSMXaZDzvDeBdm3Awacx/xiwYoYoazdZgLk8mQ7ehze+iCEELQXCMVfOgscOJytJPMhcChWI7h2VmhBeQFK9UbpCj9T0AiyUK6eJycOPyUlZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQ0yPSwuN5mrShejf6iwU8O41/Ju2uu71H/havnfRyQ=;
 b=bETrwXeIGCVcDUlfYH5o5DzGwpWgegNnXkk3jcCVTpY2tNZ61N5GsBBZWwRiBvuYXXRfDB3rbvWkiLMVPO4S3Low2qyrftDsD0abiYK7aRP8aqUsycAIAQarKqWV6XQhUjt5tNr1/1CqNATD53siAnbniMVuOHkK78rhguiH/483xg1tz+pyf4AIo3QLK3YMUceHljfI/LuFcYa038w9uMKkToH7gYEyZRcHL5dJ4P/9KXRfcWi5go9fbNnfwchD0wJywkQy/vYeGSmfGYZqPvgj2WHCCwLYqJeXe5DO+t6gRmLQWH0x+4cdNOzrsCLQUJjf122+ZRu9Z5G8zCsYdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iQ0yPSwuN5mrShejf6iwU8O41/Ju2uu71H/havnfRyQ=;
 b=e25YWhIX8RNlkfX8fc6jSXNafVaT7UbYxaJsWAjLpwH+ip2vXS19zrMH7bICz1EzXdEssblOW+5TYd/oF/ZuiSMmHF5x60Ls+Y6YffX5WG6L3wRh/DBnJ9NrUttW8r7nM3rx1qDRtdKyAQf7Loz9XBga0Zt5sOiNHDT1iEvHYQo=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1943.namprd15.prod.outlook.com (10.172.180.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Fri, 6 Sep 2019 09:09:18 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::c0da:c2ae:493b:11f2]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::c0da:c2ae:493b:11f2%11]) with mapi id 15.20.2241.014; Fri, 6 Sep 2019
 09:09:18 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH 0/7] libbpf: Fix cast away const qualifiers in btf.h
Thread-Topic: [PATCH 0/7] libbpf: Fix cast away const qualifiers in btf.h
Thread-Index: AQHVZIUqWrWnz2G+aU2yiETb8ajbCaceXHGA
Date:   Fri, 6 Sep 2019 09:09:17 +0000
Message-ID: <62e760de-e746-c512-350a-c2188a2bb3ed@fb.com>
References: <20190906073144.31068-1-jolsa@kernel.org>
In-Reply-To: <20190906073144.31068-1-jolsa@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0393.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::21) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c092:180::1:5dd3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb38e336-624c-41de-4b91-08d732a9e563
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR15MB1943;
x-ms-traffictypediagnostic: CY4PR15MB1943:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB1943E5F181EA7ED634BC6F66C6BA0@CY4PR15MB1943.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0152EBA40F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39860400002)(396003)(376002)(346002)(199004)(189003)(65956001)(65806001)(6436002)(4326008)(66946007)(6116002)(66476007)(52116002)(25786009)(64756008)(66446008)(66556008)(7736002)(71200400001)(76176011)(71190400001)(305945005)(53936002)(36756003)(8676002)(54906003)(8936002)(6246003)(2906002)(81156014)(81166006)(186003)(110136005)(31686004)(476003)(46003)(102836004)(256004)(486006)(14454004)(53546011)(99286004)(2616005)(14444005)(229853002)(6506007)(478600001)(6512007)(386003)(11346002)(5660300002)(316002)(446003)(6486002)(86362001)(31696002)(58126008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1943;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KljxklS6RDEHkNsQP7BlMafOaS7ZE+knFGIW/cfMZHrpWpU4LNeY8P5gpCA6gPGpPxzHoFbNxdl9ILZqb4++OpdyEZsfoszLn5+QbgmuWuOpdpdQTFea/SL6Ru70xnKHjMZyN8iYFZx0Z677NBvJAeKmw0VKKfRP/4VeJhhrKmhMjC7FFoKMUY3GQOYJeWvzOwMssVPmZjFgUzj4ew0LfZKNOPRwXsBRdRlrJTGrTu/g+TSw23WfcrnjR2x2tso+lkLvOnqEXx9zGxr7mlln8hELCIz5pnNe1XSkSJHMgqSmCjKIbYvZm1YuzhuFVi6S3eEViE7bHsnpV69EaWs9V4deKhrQAqHWfM4HqCabT7zQZwfunLq2IVb7FxwgCEzsTe4cOENtOrji3y0Bj0/LybseCTw8a56sYuXdXRKLO9s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3599222EAD792F4E94DCAE3F44F9B09B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fb38e336-624c-41de-4b91-08d732a9e563
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2019 09:09:17.7825
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oODhJkskAd2BGOakrwcBgOGX22ouV3NLNcaj12cm0Pt4JgBRMv49keQTCWdWbO3z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1943
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-06_04:2019-09-04,2019-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 impostorscore=0
 adultscore=0 spamscore=0 mlxlogscore=963 clxscore=1011 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909060097
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS82LzE5IDg6MzEgQU0sIEppcmkgT2xzYSB3cm90ZToNCj4gaGksDQo+IHdoZW4gaW5jbHVk
aW5nIGJ0Zi5oIGluIGJwZnRyYWNlLCBJJ20gZ2V0dGluZyAtV2Nhc3QtcXVhbCB3YXJuaW5ncyBs
aWtlOg0KPiANCj4gICAgYnBmL2J0Zi5oOiBJbiBmdW5jdGlvbiDigJhidGZfdmFyX3NlY2luZm8q
IGJ0Zl92YXJfc2VjaW5mb3MoY29uc3QgYnRmX3R5cGUqKeKAmToNCj4gICAgYnBmL2J0Zi5oOjMw
Mjo0MTogd2FybmluZzogY2FzdCBmcm9tIHR5cGUg4oCYY29uc3QgYnRmX3R5cGUq4oCZIHRvIHR5
cGUNCj4gICAg4oCYYnRmX3Zhcl9zZWNpbmZvKuKAmSBjYXN0cyBhd2F5IHF1YWxpZmllcnMgWy1X
Y2FzdC1xdWFsXQ0KPiAgICAgIDMwMiB8ICByZXR1cm4gKHN0cnVjdCBidGZfdmFyX3NlY2luZm8g
KikodCArIDEpOw0KPiAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBeDQo+IA0KPiBJIGNoYW5nZWQgdGhlIGJ0Zi5oIGhlYWRlciB0byBjb21wbHkgd2l0
aCAtV2Nhc3QtcXVhbCBjaGVja3MNCj4gYW5kIHVzZWQgY29uc3QgY2FzdCBhd2F5IGNhc3Rpbmcg
aW4gbGliYnBmIG9iamVjdHMsIHdoZXJlIGl0J3MNCg0KSGV5IEppcmksDQoNCldlIG1hZGUgYWxs
IHRob3NlIGhlbHBlciBmdW5jcyByZXR1cm4gbm9uLWNvbnN0IHN0cnVjdHMgaW50ZW50aW9uYWxs
eSB0byANCmltcHJvdmUgdGhlaXIgdXNhYmlsaXR5IGFuZCBhdm9pZCBhbGwgdGhvc2UgY2FzdHMg
dGhhdCB5b3UgYWRkZWQgYmFjay4NCg0KQWxzbywgdGhvc2UgaGVscGVycyBhcmUgbm93IHBhcnQg
b2YgcHVibGljIEFQSSwgc28gd2UgY2FuJ3QganVzdCBjaGFuZ2UgDQp0aGVtIHRvIGNvbnN0LCBh
cyBpdCBjYW4gYnJlYWsgZXhpc3RpbmcgdXNlcnMgZWFzaWx5Lg0KDQpJZiB0aGVyZSBpcyBhIG5l
ZWQgdG8gcnVuIHdpdGggLVdjYXN0LXF1YWwsIHdlIHNob3VsZCBwcm9iYWJseSBkaXNhYmxlIA0K
dGhvc2UgY2hlY2tzIHdoZXJlIGFwcHJvcHJpYXRlIGluIGxpYmJwZiBjb2RlLg0KDQpTbyB0aGlz
IHdpbGwgYmUgYSBOQUNLIGZyb20gbWUsIHNvcnJ5Lg0KDQo+IGFsbCByZWxhdGVkIHRvIGRlZHVw
bGljYXRpb24gY29kZSwgc28gSSBiZWxpZXZlIGxvb3NpbmcgY29uc3QNCj4gaXMgZmluZSB0aGVy
ZS4NCj4gDQo+IHRoYW5rcywNCj4gamlya2ENCj4gDQo+IA0KPiAtLS0NCj4gSmlyaSBPbHNhICg3
KToNCj4gICAgICAgIGxpYmJwZjogVXNlIGNvbnN0IGNhc3QgZm9yIGJ0Zl9pbnRfKiBmdW5jdGlv
bnMNCj4gICAgICAgIGxpYmJwZjogUmV0dXJuIGNvbnN0IGJ0Zl9hcnJheSBmcm9tIGJ0Zl9hcnJh
eSBpbmxpbmUgZnVuY3Rpb24NCj4gICAgICAgIGxpYmJwZjogUmV0dXJuIGNvbnN0IGJ0Zl9lbnVt
IGZyb20gYnRmX2VudW0gaW5saW5lIGZ1bmN0aW9uDQo+ICAgICAgICBsaWJicGY6IFJldHVybiBj
b25zdCBidGZfbWVtYmVyIGZyb20gYnRmX21lbWJlcnMgaW5saW5lIGZ1bmN0aW9uDQo+ICAgICAg
ICBsaWJicGY6IFJldHVybiBjb25zdCBidGZfcGFyYW0gZnJvbSBidGZfcGFyYW1zIGlubGluZSBm
dW5jdGlvbg0KPiAgICAgICAgbGliYnBmOiBSZXR1cm4gY29uc3QgYnRmX3ZhciBmcm9tIGJ0Zl92
YXIgaW5saW5lIGZ1bmN0aW9uDQo+ICAgICAgICBsaWJicGY6IFJldHVybiBjb25zdCBzdHJ1Y3Qg
YnRmX3Zhcl9zZWNpbmZvIGZyb20gYnRmX3Zhcl9zZWNpbmZvcyBpbmxpbmUgZnVuY3Rpb24NCj4g
DQo+ICAgdG9vbHMvbGliL2JwZi9idGYuYyAgICB8IDIxICsrKysrKysrKysrLS0tLS0tLS0tLQ0K
PiAgIHRvb2xzL2xpYi9icGYvYnRmLmggICAgfCAzMCArKysrKysrKysrKysrKystLS0tLS0tLS0t
LS0tLS0NCj4gICB0b29scy9saWIvYnBmL2xpYmJwZi5jIHwgIDIgKy0NCj4gICAzIGZpbGVzIGNo
YW5nZWQsIDI3IGluc2VydGlvbnMoKyksIDI2IGRlbGV0aW9ucygtKQ0KPiANCg0K
