Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A295ADCCDF
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 19:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505460AbfJRRdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 13:33:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728833AbfJRRdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 13:33:31 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9IHXDkp013651;
        Fri, 18 Oct 2019 10:33:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NYGR2MVRl+D+NOGJ4FB+FySYIO7yrO7/EVoC/jMz3PE=;
 b=ooJgfTP1uUUNVoZZOWAFEJiytr93EwKLtbyiju4Q/F6PrYqfZ9WsZ6zwLHS2CfdCCtAO
 1kHK+OHGWG7/1zxYUIFKnzjQFgf6168v/mLlizGK/tKV+TvhEsj67RVtL4fGdwZBWSVe
 v+n5TQZLa+YXexLmXHfQLMZJT8EHsqPX7MY= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vprq9eay1-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 10:33:27 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 18 Oct 2019 10:33:16 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 18 Oct 2019 10:33:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UH+BFTauEjELU6iPGY0bIFj8Ml6rvidvIr/Dwezahxm3vK6TEMqMOKpo3NqBK1uIZvTodAL3/R+5fshrGTkVcvQ7i0SGKCJXqKRkQPLZ/sZF5aoV2IQbv9FAY7xnUcysWwse6g57p3zRy+NRfzxrwk5GV1otPMGk0/ppul7MIvFOL7Tq2xdCYWr64pszw6b4HM7kWAUhK/GBqDPZt/2VBUgaVxPRtRl411ZM43egwKtUPDwwfvGW1AOJ8MmkzR+wJ8HvXJnCIjckXLThc4HSYfGdmQkJRRWjMDRjwRBGHR8yG7TUEU1tiqVldl6t7Uw1uaTXKXPTzrdbLC23Ynt2mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYGR2MVRl+D+NOGJ4FB+FySYIO7yrO7/EVoC/jMz3PE=;
 b=UD5LwQSVKUkysa6MeolUpzqCQzmyB2bO6q8QMBqJZzt5BzJt1927wemB1AUdEMUM3HtEoWywr3aKdGYk3/kyB7oPdU5EQkrb8D2rVxXQovE/3zJavGW+muC2/y5+x5i5atsFVFvii/S2I8hHh2ZApShjosRCnU1u9hiBfVOgCsFguV5L7Ij4YUO14Jz/7SkRoXsHj1hs/UjEIFkE1ODmCdnuXSEtwcRy37svEyiTMWLq1BrhRYoBXJX90JLg/6AgNuulVlwMpPSOujWw0X3YY/LVltqF1vckvIuiIikC8nXHa86+5/hh7e6E/nP8zr2KyTosjR1UB6JUMG/AxkCCMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYGR2MVRl+D+NOGJ4FB+FySYIO7yrO7/EVoC/jMz3PE=;
 b=JMor8xwqMe294+6e7MbLlOKU2fJyg8hGwFBsYM21r8bYxNvIJw0K8dxl3HrvH80wz2UYgEGFJV5+35tnKKSFH5QlDvKh+7SMt24j4iZ+ixswjR3u2BXwMOlLMl3XPkalxgucu+wEv/xZvdtyJqysDkVX62toAOseuY1PaIIarLw=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3208.namprd15.prod.outlook.com (20.179.58.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Fri, 18 Oct 2019 17:33:15 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 17:33:15 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Carlos Neira <cneirabustos@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v14 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
Thread-Topic: [PATCH v14 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
Thread-Index: AQHVhdofiAeX9gztpESdd7q/+xbkwQ==
Date:   Fri, 18 Oct 2019 17:33:15 +0000
Message-ID: <d88ce3ca-d235-cd9c-c1a9-c2d01a01541d@fb.com>
References: <20191017150032.14359-1-cneirabustos@gmail.com>
 <20191017150032.14359-5-cneirabustos@gmail.com>
In-Reply-To: <20191017150032.14359-5-cneirabustos@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR10CA0064.namprd10.prod.outlook.com
 (2603:10b6:300:2c::26) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:3455]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f0496707-3b1a-4946-905c-08d753f141c1
x-ms-traffictypediagnostic: BYAPR15MB3208:
x-microsoft-antispam-prvs: <BYAPR15MB3208CF05172B74BBEB2DA10ED36C0@BYAPR15MB3208.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:551;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(136003)(376002)(39860400002)(189003)(199004)(102836004)(53546011)(8936002)(31696002)(486006)(6486002)(186003)(6512007)(8676002)(76176011)(52116002)(81156014)(81166006)(46003)(99286004)(86362001)(229853002)(6246003)(4326008)(2501003)(478600001)(386003)(6436002)(36756003)(6506007)(110136005)(305945005)(14454004)(31686004)(25786009)(7736002)(316002)(5660300002)(446003)(476003)(66946007)(2906002)(66446008)(256004)(11346002)(66476007)(14444005)(5024004)(54906003)(64756008)(66556008)(6116002)(2616005)(71190400001)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3208;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZaTtKfUqUbmB983oTtxFKWuLNRM0gGox93Fi84qqTKs3YgWpMKObPo0cKPB0EE4K45FeWPKxORzTGAr8jzGEKFIbFBSdDnwxSkYjQ8+EEfbztyvE5FaSiOVxu33OFHHP/U1dMDd5pmyl1dpoqa9Qq+QqCidBKv3ky9eGoLtyc2dRnjx8WU89Wx2wZfH4LNniimG+Al6LDf5gt4JmwFQfdZLtnj3zP/L9wkNqnSCs/xRfsE+IdwKw+pP4TBGTmAruy6Gl/z7JWGBoNlnagzT0eXn83Pjm/sjHP4DWkm/Tb7W67Vf9uOtzqpCg9NLsZWbWoAYTJtCXiC29LwMS0YU4hMXDJx0b/5DRxqbGVLRHipuvE7PM1kHeq/myFH8z/NbtCpfEgbZiAbLqCf3BfM0kVRzC6Y3MSS85XO/+VmY2kNY=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <6C4507A6DAB9984EBF699F49A327F24A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f0496707-3b1a-4946-905c-08d753f141c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 17:33:15.3651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4B7Dwk3+U3P0MxaobjEtC4tNltfxVvCqIrqA88d7+urVAHJVCvO3GchVGUNj39U5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3208
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 impostorscore=0 clxscore=1015 suspectscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910180159
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzE3LzE5IDg6MDAgQU0sIENhcmxvcyBOZWlyYSB3cm90ZToNCj4gU2VsZiB0ZXN0
cyBhZGRlZCBmb3IgbmV3IGhlbHBlcg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2FybG9zIE5laXJh
IDxjbmVpcmFidXN0b3NAZ21haWwuY29tPg0KPiAtLS0NCj4gICAuLi4vYnBmL3Byb2dfdGVzdHMv
Z2V0X25zX2N1cnJlbnRfcGlkX3RnaWQuYyAgfCA5NiArKysrKysrKysrKysrKysrKysrDQo+ICAg
Li4uL2JwZi9wcm9ncy9nZXRfbnNfY3VycmVudF9waWRfdGdpZF9rZXJuLmMgIHwgNTMgKysrKysr
KysrKw0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTQ5IGluc2VydGlvbnMoKykNCj4gICBjcmVhdGUg
bW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvZ2V0X25z
X2N1cnJlbnRfcGlkX3RnaWQuYw0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9icGYvcHJvZ3MvZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWRfa2Vybi5jDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dfdGVzdHMvZ2V0
X25zX2N1cnJlbnRfcGlkX3RnaWQuYyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
X3Rlc3RzL2dldF9uc19jdXJyZW50X3BpZF90Z2lkLmMNCj4gbmV3IGZpbGUgbW9kZSAxMDA2NDQN
Cj4gaW5kZXggMDAwMDAwMDAwMDAwLi40OGQ5Nzg1Zjg5ZDANCj4gLS0tIC9kZXYvbnVsbA0KPiAr
KysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvcHJvZ190ZXN0cy9nZXRfbnNfY3VycmVu
dF9waWRfdGdpZC5jDQo+IEBAIC0wLDAgKzEsOTYgQEANCj4gKy8vIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiBHUEwtMi4wDQo+ICsvKiBDb3B5cmlnaHQgKGMpIDIwMTkgQ2FybG9zIE5laXJhIGNu
ZWlyYWJ1c3Rvc0BnbWFpbC5jb20gKi8NCj4gKyNpbmNsdWRlIDx0ZXN0X3Byb2dzLmg+DQo+ICsj
aW5jbHVkZSA8c3lzL3N0YXQuaD4NCj4gKyNpbmNsdWRlIDxzeXMvdHlwZXMuaD4NCj4gKyNpbmNs
dWRlIDxzeXMvc3RhdC5oPg0KPiArI2luY2x1ZGUgPHVuaXN0ZC5oPg0KPiArI2luY2x1ZGUgPHN5
cy9zeXNjYWxsLmg+DQo+ICsNCj4gK3N0cnVjdCBic3Mgew0KPiArCV9fdTY0IGRldjsNCj4gKwlf
X3U2NCBpbm87DQo+ICsJX191NjQgcGlkdGdpZDsNCk1heWJlIHBpZF90Z2lkPw0KDQo+ICsJX191
NjQgdXNlcnBpZHRnaWQ7DQoNCk1heWJlIHVzZXJfcGlkX3RnaWQ/DQoNCj4gK30gZGF0YTsNCj4g
Kw0KPiArdm9pZCB0ZXN0X2dldF9uc19jdXJyZW50X3BpZF90Z2lkKHZvaWQpDQo+ICt7DQo+ICsJ
Y29uc3QgY2hhciAqcHJvYmVfbmFtZSA9ICJyYXdfdHJhY2Vwb2ludC9zeXNfZW50ZXIiOw0KPiAr
CWNvbnN0IGNoYXIgKmZpbGUgPSAiZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWRfa2Vybi5vIjsNCj4g
KwlzdHJ1Y3QgYnBmX29iamVjdF9sb2FkX2F0dHIgbG9hZF9hdHRyID0ge307DQo+ICsJc3RydWN0
IGJwZl9saW5rICpsaW5rID0gTlVMTDsNCj4gKwlzdHJ1Y3QgYnBmX3Byb2dyYW0gKnByb2c7DQo+
ICsJc3RydWN0IGJwZl9tYXAgKmJzc19tYXA7DQo+ICsJc3RydWN0IGJwZl9vYmplY3QgKm9iajsN
Cj4gKwlpbnQgZXJyLCBkdXJhdGlvbiA9IDA7DQo+ICsJY29uc3QgX191MzIga2V5ID0gMDsNCj4g
KwlzdHJ1Y3Qgc3RhdCBzdDsNCj4gKwlfX3U2NCBpZDsNCj4gKw0KPiArCW9iaiA9IGJwZl9vYmpl
Y3RfX29wZW4oZmlsZSk7DQo+ICsJaWYgKENIRUNLKElTX0VSUl9PUl9OVUxMKG9iaiksICJvYmpf
b3BlbiIsDQo+ICsJCSAgImZhaWxlZCB0byBvcGVuICclcyc6ICVsZFxuIiwNCj4gKwkJICBmaWxl
LCBQVFJfRVJSKG9iaikpKQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsNCj4gKwlwcm9nID0gYnBm
X29iamVjdF9fZmluZF9wcm9ncmFtX2J5X3RpdGxlKG9iaiwgcHJvYmVfbmFtZSk7DQo+ICsJaWYg
KENIRUNLKCFwcm9nLCAiZmluZF9wcm9iZSIsDQo+ICsJCSAgInByb2cgJyVzJyBub3QgZm91bmRc
biIsIHByb2JlX25hbWUpKQ0KPiArCQlnb3RvIGNsZWFudXA7DQo+ICsNCj4gKwlicGZfcHJvZ3Jh
bV9fc2V0X3R5cGUocHJvZywgQlBGX1BST0dfVFlQRV9SQVdfVFJBQ0VQT0lOVCk7DQoNCkRvIHdl
IG5lZWQgdGhpcz8gSSB0aG91Z2h0IGxpYmJwZiBzaG91bGQgYXV0b21hdGljYWxseQ0KaW5mZXIg
cHJvZ3JhbSB0eXBlIGZyb20gc2VjdGlvbiBuYW1lPw0KDQo+ICsNCj4gKwlsb2FkX2F0dHIub2Jq
ID0gb2JqOw0KPiArCWxvYWRfYXR0ci5sb2dfbGV2ZWwgPSAwOw0KPiArCWxvYWRfYXR0ci50YXJn
ZXRfYnRmX3BhdGggPSBOVUxMOw0KPiArCWVyciA9IGJwZl9vYmplY3RfX2xvYWRfeGF0dHIoJmxv
YWRfYXR0cik7DQo+ICsJaWYgKENIRUNLKGVyciwgIm9ial9sb2FkIiwNCj4gKwkJICAiZmFpbGVk
IHRvIGxvYWQgcHJvZyAnJXMnOiAlZFxuIiwNCj4gKwkJICBwcm9iZV9uYW1lLCBlcnIpKQ0KPiAr
CQlnb3RvIGNsZWFudXA7DQoNCllvdXIgbG9hZF9hdHRyIG9ubHkgaGFzICdvYmonLCB5b3UgY291
bGQgdXNlIGJwZl9vYmplY3RfX2xvYWQNCmZvciBzaW1wbGljaXR5Lg0KDQo+ICsNCj4gKwlsaW5r
ID0gYnBmX3Byb2dyYW1fX2F0dGFjaF9yYXdfdHJhY2Vwb2ludChwcm9nLCAic3lzX2VudGVyIik7
DQo+ICsJaWYgKENIRUNLKElTX0VSUihsaW5rKSwgImF0dGFjaF9yYXdfdHAiLCAiZXJyICVsZFxu
IiwNCj4gKwkJICBQVFJfRVJSKGxpbmspKSkNCj4gKwkJZ290byBjbGVhbnVwOw0KPiArDQo+ICsJ
YnNzX21hcCA9IGJwZl9vYmplY3RfX2ZpbmRfbWFwX2J5X25hbWUob2JqLCAibnNfZGF0YV9tYXAi
KTsNCj4gKwlpZiAoQ0hFQ0soIWJzc19tYXAsICJmaW5kX2Jzc19tYXAiLCAiZmFpbGVkXG4iKSkN
Cj4gKwkJZ290byBjbGVhbnVwOw0KPiArDQo+ICsJbWVtc2V0KCZkYXRhLCAwLCBzaXplb2YoZGF0
YSkpOw0KPiArCXBpZF90IHRpZCA9IHN5c2NhbGwoU1lTX2dldHRpZCk7DQo+ICsJcGlkX3QgcGlk
ID0gZ2V0cGlkKCk7DQo+ICsNCj4gKwlpZCA9IChfX3U2NCkgdGlkIDw8IDMyIHwgcGlkOw0KPiAr
CWRhdGEudXNlcnBpZHRnaWQgPSBpZDsNCj4gKw0KPiArCWlmIChDSEVDSyhzdGF0KCIvcHJvYy9z
ZWxmL25zL3BpZCIsICZzdCksICJzdGF0IiwiZmFpbGVkXG4iKSkNCj4gKwkJZ290byBjbGVhbnVw
Ow0KPiArDQo+ICsJZGF0YS5kZXYgPSBzdC5zdF9kZXY7DQo+ICsJZGF0YS5pbm8gPSBzdC5zdF9p
bm87DQo+ICsNCj4gKwllcnIgPSBicGZfbWFwX3VwZGF0ZV9lbGVtKGJwZl9tYXBfX2ZkKGJzc19t
YXApLCAma2V5LCAmZGF0YSwgMCk7DQo+ICsJaWYgKENIRUNLKGVyciwgInNldHRpbmdfYnNzIiwg
ImZhaWxlZCB0byBzZXQgYnNzIGRhdGE6ICVkXG4iLCBlcnIpKQ0KPiArCQlnb3RvIGNsZWFudXA7
DQoNClR5cGljYWxseSwgd2Ugd291bGQgbGlrZSB0byBkbyBtYXBfdXBkYXRlX2VsZW0gZmlyc3Qg
YW5kIHRoZW4NCmRvIGF0dGFjaF9yYXdfdHJhY2Vwb2ludC4gVGhpcyB3aWxsIGVuc3VyZSB1cGRh
dGVkIGVsZW0gaXMgc2Vlbg0KZXZlbiBmb3IgdGhlIGZpcnN0IGludm9jYXRpb24gb2YgdGhlIHBy
b2dyYW0uDQoNCkluIHlvdXIgY2FzZSwgc2luY2UgeW91IGlnbm9yZSBhbGwgdW5tYXRjaGVkIHZl
cnNpb24sIHNvDQpJIHdvbid0IGluc2lzdCBpZiB0aGVyZSBpcyBubyByZXZpc2lvbiBuZWVkZWQu
DQoNClNpbmNlIHlvdSBuZWVkIHJlc3BpbiBhbnkgd2F5LCBJIHN1Z2dlc3QgdG8gc3dpdGNoIHRo
ZQ0Kb3JkZXIgYmV0d2VlbiBicGZfbWFwX3VwZGF0ZV9lbGVtIGFuZCBhdHRhY2hfcmF3X3RyYWNl
cG9pbnQsIHdoaWNoIGlzIGEgDQpnb29kIHByYWN0aWNlIGFueSB3YXkuDQoNCj4gKw0KPiArCS8q
IHRyaWdnZXIgc29tZSBzeXNjYWxscyAqLw0KPiArCXVzbGVlcCgxKTsNCj4gKw0KPiArCWVyciA9
IGJwZl9tYXBfbG9va3VwX2VsZW0oYnBmX21hcF9fZmQoYnNzX21hcCksICZrZXksICZkYXRhKTsN
Cj4gKwlpZiAoQ0hFQ0soZXJyLCAic2V0X2JzcyIsICJmYWlsZWQgdG8gZ2V0IGJzcyBkYXRhOiAl
ZFxuIiwgZXJyKSkNCj4gKwkJZ290byBjbGVhbnVwOw0KPiArDQo+ICsJaWYgKENIRUNLKGlkICE9
IGRhdGEucGlkdGdpZCwgIkNvbXBhcmUgdXNlciBwaWQvdGdpZCB2cy4gYnBmIHBpZC90Z2lkIiwN
Cj4gKwkJICAiVXNlciBwaWQvdGdpZCAlbGx1IEVCUEYgcGlkL3RnaWQgJWxsdVxuIiwgaWQsIGRh
dGEucGlkdGdpZCkpDQo+ICsJCWdvdG8gY2xlYW51cDsNCj4gK2NsZWFudXA6DQo+ICsNCj4gKwlp
ZiAoIUlTX0VSUl9PUl9OVUxMKGxpbmspKSB7DQo+ICsJCWJwZl9saW5rX19kZXN0cm95KGxpbmsp
Ow0KPiArCQlsaW5rID0gTlVMTDsNCj4gKwl9DQo+ICsJYnBmX29iamVjdF9fY2xvc2Uob2JqKTsN
Cj4gK30NCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9n
ZXRfbnNfY3VycmVudF9waWRfdGdpZF9rZXJuLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9i
cGYvcHJvZ3MvZ2V0X25zX2N1cnJlbnRfcGlkX3RnaWRfa2Vybi5jDQo+IG5ldyBmaWxlIG1vZGUg
MTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMC4uMWZkODQ3YjYzMTA1DQo+IC0tLSAvZGV2L251
bGwNCj4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL2dldF9uc19jdXJy
ZW50X3BpZF90Z2lkX2tlcm4uYw0KPiBAQCAtMCwwICsxLDUzIEBADQo+ICsvLyBTUERYLUxpY2Vu
c2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiArLyogQ29weXJpZ2h0IChjKSAyMDE5IENhcmxvcyBO
ZWlyYSBjbmVpcmFidXN0b3NAZ21haWwuY29tICovDQo+ICsNCj4gKyNpbmNsdWRlIDxsaW51eC9i
cGYuaD4NCj4gKyNpbmNsdWRlIDxzdGRpbnQuaD4NCj4gKyNpbmNsdWRlICJicGZfaGVscGVycy5o
Ig0KPiArI2luY2x1ZGUgImJwZl9jb3JlX3JlYWQuaCINCg0KWW91IGRvIG5vdCBuZWVkICJicGZf
Y29yZV9yZWFkLmgiIGhlcmUuDQoNCj4gKw0KPiArc3RydWN0IHJlcyB7DQo+ICsJX191NjQgZGV2
Ow0KPiArCV9fdTY0IGlubzsNCj4gKwlfX3U2NCBwaWR0Z2lkOw0KPiArCV9fdTY0IHVzZXJwaWR0
Z2lkOw0KPiArfTsNCj4gKw0KPiArc3RydWN0IHsNCj4gKwlfX3VpbnQodHlwZSwgQlBGX01BUF9U
WVBFX0FSUkFZKTsNCj4gKwlfX3VpbnQobWF4X2VudHJpZXMsIDEpOw0KPiArCV9fdHlwZShrZXks
IF9fdTMyKTsNCj4gKwlfX3R5cGUodmFsdWUsIHN0cnVjdCByZXMpOw0KPiArfSBuc19kYXRhX21h
cCBTRUMoIi5tYXBzIik7DQoNCkluIHlvdSBjb2RlLCB5b3UgdXNlIG5zX2RhdGFfbWFwIHdoaWNo
IGhhcyBtYXhfZW50cmllcyA9IDEuDQpJbiB0aGlzIGNhc2UsIHN0YXRpYyB2b2xhdGlsZSB2YXJp
YWJsZSBjYW4gYmUgdXNlZCB0bw0Kc2ltcGxpZnkgdGhlIGJwZiBwcm9ncmFtLiBZb3UgaGF2ZQ0K
J3N0YXRpYyBzdHJ1Y3QgcmVzIGRhdGEnIHdoaWNoIHdpbGwgdHVybiBpbnRvIGEgbWFwDQphcyB3
ZWxsLiBTbyBub3cgeW91IGhhdmUgdHdvIG1hcHMgdG8gaG9sZCB0aGUgbnNkYXRhLg0KSSBzdWdn
ZXN0IHRvIHJlbW92ZSB0aGUgYWJvdmUgbnNfZGF0YV9tYXAuDQoNCllvdSBjYW4gdGFrZSBhIGxv
b2sgYXQgdGhlIGJlbG93IGNvbW1pdCBmb3IgYW4gZXhhbXBsZToNCg0KY29tbWl0IDY2NmIyYzEw
ZWU5ZDUxZjE0ZDA0YzQxNmExNGIxY2I2ZmQwODQ2ZTQNCkF1dGhvcjogQW5kcmlpIE5ha3J5aWtv
IDxhbmRyaWluQGZiLmNvbT4NCkRhdGU6ICAgV2VkIE9jdCA5IDEzOjE0OjU4IDIwMTkgLTA3MDAN
Cg0KICAgICBzZWxmdGVzdHMvYnBmOiBBZGQgcmVhZC1vbmx5IG1hcCB2YWx1ZXMgcHJvcGFnYXRp
b24gdGVzdHMNCg0KICAgICBBZGQgdGVzdHMgY2hlY2tpbmcgdGhhdCB2ZXJpZmllciBkb2VzIHBy
b3BlciBjb25zdGFudCBwcm9wYWdhdGlvbiBmb3INCiAgICAgcmVhZC1vbmx5IG1hcHMuIElmIGNv
bnN0YW50IHByb3BhZ2F0aW9uIGRpZG4ndCB3b3JrLCBza2lwcF9sb29wIGFuZA0KICAgICBwYXJ0
X2xvb3AgQlBGIHByb2dyYW1zIHdvdWxkIGJlIHJlamVjdGVkIGR1ZSB0byBCUEYgdmVyaWZpZXIg
b3RoZXJ3aXNlDQogICAgIG5vdCBiZWluZyBhYmxlIHRvIHByb3ZlIHRoZXkgZXZlciBjb21wbGV0
ZS4gV2l0aCBjb25zdGFudCBwcm9wYWdhdGlvbiwNCiAgICAgdGhvdWdoLCB0aGV5IGFyZSBzdWNj
ZXNmdWxseSB2YWxpZGF0ZWQgYXMgcHJvcGVybHkgdGVybWluYXRpbmcgbG9vcHMuDQoNCj4gKw0K
PiArc3RhdGljIHN0cnVjdCByZXMgZGF0YTsNCj4gKw0KPiArU0VDKCJyYXdfdHJhY2Vwb2ludC9z
eXNfZW50ZXIiKQ0KPiAraW50IHRyYWNlKHZvaWQgKmN0eCkNCj4gK3sNCj4gKwlfX3U2NCAgbnNw
aWR0Z2lkLCBleHBlY3RlZF9waWQ7DQo+ICsJc3RydWN0IGJwZl9waWRuc19pbmZvIG5zZGF0YTsN
Cj4gKwljb25zdCBfX3UzMiBrZXkgPSAwOw0KDQpZb3UgY2FuIHJlbW92ZSAiY29uc3QiIGhlcmUs
IG5vdCB2ZXJ5IHVzZWZ1bC4NCg0KPiArCXN0cnVjdCByZXMgKnByZXM7DQo+ICsNCj4gKwlwcmVz
ID0gYnBmX21hcF9sb29rdXBfZWxlbSgmbnNfZGF0YV9tYXAsICZrZXkpOw0KPiArCWlmICghcHJl
cykNCj4gKwkJcmV0dXJuIDA7DQo+ICsNCj4gKwlpZiAoYnBmX2dldF9uc19jdXJyZW50X3BpZF90
Z2lkKHByZXMtPmRldiwgcHJlcy0+aW5vLCAmbnNkYXRhLA0KPiArCQkgICBzaXplb2Yoc3RydWN0
IGJwZl9waWRuc19pbmZvKSkpDQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJbnNwaWR0Z2lkID0g
KF9fdTY0KW5zZGF0YS50Z2lkIDw8IDMyIHwgbnNkYXRhLnBpZDsNCj4gKwlleHBlY3RlZF9waWQg
PSBwcmVzLT51c2VycGlkdGdpZDsNCj4gKw0KPiArCWlmIChleHBlY3RlZF9waWQgIT0gbnNwaWR0
Z2lkKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiArCWRhdGEucGlkdGdpZCA9IG5zcGlkdGdpZDsN
Cj4gKwlicGZfbWFwX3VwZGF0ZV9lbGVtKCZuc19kYXRhX21hcCwgJmtleSwgJmRhdGEsIDApOw0K
PiArDQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gK2NoYXIgX2xpY2Vuc2VbXSBTRUMoImxp
Y2Vuc2UiKSA9ICJHUEwiOw0KPiANCg==
