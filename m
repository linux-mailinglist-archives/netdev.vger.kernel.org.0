Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7592179AC0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 22:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388360AbgCDVQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 16:16:52 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:11666 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387762AbgCDVQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 16:16:52 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 024LGAgx017226;
        Wed, 4 Mar 2020 13:16:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=wyJePQd1a38tfBYIXZBUFl2J8ZivrZ6unXFzsaQb4ek=;
 b=YM2dTBRCQbc5g7HkZAPAFxd58pel+2U2Jdf0RxAr+bzRduvS8tnZIVAAhqB7GiGiuzN8
 L+hwTAyogF0xjIS+xY0FfjmFq+IyfCnr4X/L4A36VY20xVVPaDTxZmZdux3nUJCReboh
 6yIE1Ue6DiuJEFermRFBtjfRvL9O/pwxktw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yjggj17ny-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 04 Mar 2020 13:16:35 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 13:16:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz8+faN9RQWkBPHAyRGOMK3NFZ1074+QNT8Z6gvcyREJLFzMaGzCzvl3sI79B4WODghoERtkKTVDg42oq0sdXZYCyWeGlSve+uIaIEp1kAHyi8LbKGFLIKm4JpPnEdveZi5keQE5auCp9TLrxuevz5VCyO1ueh3XL3j/bijyoXHzLgbv8Xk1V/zeRXvRwsD8LulZjSo38UXviHPRLhnKw/IT1JguQemcHCuISY5xmIFpFRvagkZ7riRO1ka53TVmfdD/5BzaRlvtdRMgyTwINH1SydxmlAPy4WYUq8+K3/IqsiSOUC0ODfhKhlD0V7XjfpjX2KRyuLRiBwPNw+58pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyJePQd1a38tfBYIXZBUFl2J8ZivrZ6unXFzsaQb4ek=;
 b=FEqYVfItdjwoIbfml4yODbUg/7xSX4ESEDg9E5OGPvVIqlmfhjZn+VJqq6glBrHqj21fGo7MdALPlm+Xp/ilucysH87hSoYflR3HQzCqJNzVSqs6TWPJaF/jelQMfcb3sxh3ZyWc7GNHi5SQCxHrcctSVfEEtca6Zs83lgZuAxOWKPDq8fHjirc9spwI7ulcjou6R1D9YqKzGa4sCjWD98nlxjLMlup6Tn5ElUTfO68yRK/OibNU9a7cg8sUBbeOTEsQ2cMfzQUW0Rt3sDKh54XHPpXnEeWHPnG/iPlSSGeGBgV1VOLu+AOQ8KGXwLScNNtcpTuBEyxhTGt91R2WCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wyJePQd1a38tfBYIXZBUFl2J8ZivrZ6unXFzsaQb4ek=;
 b=VwTz/MefHUD2RCrW3aczHENNFvUzZvgoPtxY3B8mn7TDAHPRB/CKaSt3HBTCzAp1CmwsaXxi369woPi4dtG/s00lt0BQb6ExDD9fOlDS+ck3nl+bEmbXXPQpj14WqKaoOqICLrQm0ym0oJjTu5MsNXFHmFIJEwAo/ZJRRRQGjYU=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3913.namprd15.prod.outlook.com (2603:10b6:303:42::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14; Wed, 4 Mar
 2020 21:16:29 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2772.019; Wed, 4 Mar 2020
 21:16:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "quentin@isovalent.com" <quentin@isovalent.com>,
        Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Thread-Topic: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Thread-Index: AQHV8k/ID7Brhxz/CkyCD9Xa6Igk7Kg4y9qAgAAaOACAAAmkAA==
Date:   Wed, 4 Mar 2020 21:16:29 +0000
Message-ID: <C7C4E8E1-9176-48DC-8089-D4AEDE86E720@fb.com>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304190807.GA168640@krava> <20200304204158.GD168640@krava>
In-Reply-To: <20200304204158.GD168640@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:4f8d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8780b42a-7fa8-4ac7-6885-08d7c0814e91
x-ms-traffictypediagnostic: MW3PR15MB3913:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB391331421A5D8804329DA4B4B3E50@MW3PR15MB3913.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 0332AACBC3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(346002)(39860400002)(366004)(376002)(199004)(189003)(66556008)(66476007)(66446008)(64756008)(6512007)(6486002)(478600001)(66946007)(2906002)(76116006)(81166006)(86362001)(4326008)(8676002)(186003)(81156014)(8936002)(53546011)(6506007)(54906003)(6916009)(36756003)(2616005)(33656002)(71200400001)(966005)(316002)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3913;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j2P00e+RyChf+UAAFPrFkoenIFh1dIbcMqI/CrMmHj3gRdSp6x/l458SBeFfUWFNhqDBalK9zeclNcDntILRjzfIbNQ/cbOH/1y7oceaLrqngtJtyopxCVtmUfHxnmr3QE2EprtrpT9A3G+JWvaaZO/iGtauLk9rTO0DfATUraOTvFVc4IP0JU+pXw4y4TUTOjyNdvEb0rFLoe49IvSDhUvEjLcO6ij6bl3rSUXyx7F+I335YPvz9E3ZPfU9BvUXw++kqHkXCHmSpQ+vKndvHcvsEp31KZ5+R120SlwzAx2JYW8l32JpHNI+lGIdTpdJtAld33a4OSptr91Z8MJ6awb0fG+MJ5fwjgm0Y65wbnDEOVRrzj5vhAqCqPD0l/bzSpof7cy4bqgdV2bKotRjzNQ+1ehEdP8sUTBkBhcejJqGoDlH4xT+uwCtyKD2nosJMan+iYESCwG6Orbuqb6CQfcUbrYtmOemkPZ32aSrRptyqbiQglPJ2EET3+A2Pf8oz6E5MSZsmgqQS2n4LfamGg==
x-ms-exchange-antispam-messagedata: qpWcJlubwluPFELpiMG1XGDRr4VYq//Dte8Kpix7xdH30ni10KHM0UZGUL8FdwN8bXldtxlM14fIYDXL5VGTPX1p9JTJGB2sr0Wtq2/Lwb4L7vHUcQ+GP2A9ZrZXgGSxIbZcRUdplPUPdo3iixvZtfyTVQxseoRgUdlXzebL8SNajb8mOiZQqhnURt4eMe+V
Content-Type: text/plain; charset="utf-8"
Content-ID: <058663A5107C874494CF6147D98907FF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8780b42a-7fa8-4ac7-6885-08d7c0814e91
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2020 21:16:29.6257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9jA5Pjdf2qs2cbNo4eSNTpWPWnDB4ynFzpTycQo5hifb2ZKFivBA43FRZXUrpng2O5VLznbyb0psc3xdhvGjEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3913
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_08:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 impostorscore=0 adultscore=0 spamscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 malwarescore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDQsIDIwMjAsIGF0IDEyOjQxIFBNLCBKaXJpIE9sc2EgPGpvbHNhQHJlZGhh
dC5jb20+IHdyb3RlOg0KPiANCj4gT24gV2VkLCBNYXIgMDQsIDIwMjAgYXQgMDg6MDg6MDdQTSAr
MDEwMCwgSmlyaSBPbHNhIHdyb3RlOg0KPj4gT24gV2VkLCBNYXIgMDQsIDIwMjAgYXQgMTA6MDc6
MDZBTSAtMDgwMCwgU29uZyBMaXUgd3JvdGU6DQo+Pj4gVGhpcyBzZXQgaW50cm9kdWNlcyBicGZ0
b29sIHByb2cgcHJvZmlsZSBjb21tYW5kLCB3aGljaCB1c2VzIGhhcmR3YXJlDQo+Pj4gY291bnRl
cnMgdG8gcHJvZmlsZSBCUEYgcHJvZ3JhbXMuDQo+Pj4gDQo+Pj4gVGhpcyBjb21tYW5kIGF0dGFj
aGVzIGZlbnRyeS9mZXhpdCBwcm9ncmFtcyB0byBhIHRhcmdldCBwcm9ncmFtLiBUaGVzZSB0d28N
Cj4+PiBwcm9ncmFtcyByZWFkIGhhcmR3YXJlIGNvdW50ZXJzIGJlZm9yZSBhbmQgYWZ0ZXIgdGhl
IHRhcmdldCBwcm9ncmFtIGFuZA0KPj4+IGNhbGN1bGF0ZSB0aGUgZGlmZmVyZW5jZS4NCj4+PiAN
Cj4+PiBDaGFuZ2VzIHYzID0+IHY0Og0KPj4+IDEuIFNpbXBsaWZ5IGVyciBoYW5kbGluZyBpbiBw
cm9maWxlX29wZW5fcGVyZl9ldmVudHMoKSAoUXVlbnRpbik7DQo+Pj4gMi4gUmVtb3ZlIHJlZHVu
ZGFudCBwX2VycigpIChRdWVudGluKTsNCj4+PiAzLiBSZXBsYWNlIHRhYiB3aXRoIHNwYWNlIGlu
IGJhc2gtY29tcGxldGlvbjsgKFF1ZW50aW4pOw0KPj4+IDQuIEZpeCB0eXBvIF9icGZ0b29sX2dl
dF9tYXBfbmFtZXMgPT4gX2JwZnRvb2xfZ2V0X3Byb2dfbmFtZXMgKFF1ZW50aW4pLg0KPj4gDQo+
PiBodW0sIEknbSBnZXR0aW5nOg0KPj4gDQo+PiAJW2pvbHNhQGRlbGwtcjQ0MC0wMSBicGZ0b29s
XSQgcHdkDQo+PiAJL2hvbWUvam9sc2EvbGludXgtcGVyZi90b29scy9icGYvYnBmdG9vbA0KPj4g
CVtqb2xzYUBkZWxsLXI0NDAtMDEgYnBmdG9vbF0kIG1ha2UNCj4+IAkuLi4NCj4+IAltYWtlWzFd
OiBMZWF2aW5nIGRpcmVjdG9yeSAnL2hvbWUvam9sc2EvbGludXgtcGVyZi90b29scy9saWIvYnBm
Jw0KPj4gCSAgTElOSyAgICAgX2JwZnRvb2wNCj4+IAltYWtlOiAqKiogTm8gcnVsZSB0byBtYWtl
IHRhcmdldCAnc2tlbGV0b24vcHJvZmlsZXIuYnBmLmMnLCBuZWVkZWQgYnkgJ3NrZWxldG9uL3By
b2ZpbGVyLmJwZi5vJy4gIFN0b3AuDQo+IA0KPiBvaywgSSBoYWQgdG8gYXBwbHkgeW91ciBwYXRj
aGVzIGJ5IGhhbmQsIGJlY2F1c2UgJ2dpdCBhbScgcmVmdXNlZCB0bw0KPiBkdWUgdG8gZnV6ei4u
IHNvIHNvbWUgb2YgeW91IG5ldyBmaWxlcyBkaWQgbm90IG1ha2UgaXQgdG8gbXkgdHJlZSA7LSkN
Cj4gDQo+IGFueXdheSBJIGhpdCBhbm90aGVyIGVycm9yIG5vdzoNCj4gDQo+IAkgIENDICAgICAg
IHByb2cubw0KPiAJSW4gZmlsZSBpbmNsdWRlZCBmcm9tIHByb2cuYzoxNTUzOg0KPiAJcHJvZmls
ZXIuc2tlbC5oOiBJbiBmdW5jdGlvbiDigJhwcm9maWxlcl9icGZfX2NyZWF0ZV9za2VsZXRvbuKA
mToNCj4gCXByb2ZpbGVyLnNrZWwuaDoxMzY6MzU6IGVycm9yOiDigJhzdHJ1Y3QgcHJvZmlsZXJf
YnBm4oCZIGhhcyBubyBtZW1iZXIgbmFtZWQg4oCYcm9kYXRh4oCZDQo+IAkgIDEzNiB8ICBzLT5t
YXBzWzRdLm1tYXBlZCA9ICh2b2lkICoqKSZvYmotPnJvZGF0YTsNCj4gCSAgICAgIHwgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF5+DQo+IAlwcm9nLmM6IEluIGZ1bmN0aW9uIOKA
mHByb2ZpbGVfcmVhZF92YWx1ZXPigJk6DQo+IAlwcm9nLmM6MTY1MDoyOTogZXJyb3I6IOKAmHN0
cnVjdCBwcm9maWxlcl9icGbigJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhyb2RhdGHigJkNCj4g
CSAxNjUwIHwgIF9fdTMyIG0sIGNwdSwgbnVtX2NwdSA9IG9iai0+cm9kYXRhLT5udW1fY3B1Ow0K
PiANCj4gSSdsbCB0cnkgdG8gZmlndXJlIGl0IG91dC4uIG1pZ2h0IGJlIGVycm9yIG9uIG15IGVu
ZA0KPiANCj4gZG8geW91IGhhdmUgZ2l0IHJlcG8gd2l0aCB0aGVzZSBjaGFuZ2VzPw0KDQpJIHB1
c2hlZCBpdCB0byANCg0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvc29uZy9saW51eC5naXQvdHJlZS8/aD1icGYtcGVyLXByb2ctc3RhdHMNCg0KVGhhbmtz
LA0KU29uZw0KDQo=
