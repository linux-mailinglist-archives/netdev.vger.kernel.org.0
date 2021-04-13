Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00CAB35E4F1
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 19:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347159AbhDMRXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 13:23:38 -0400
Received: from mx07-001d1705.pphosted.com ([185.132.183.11]:53516 "EHLO
        mx07-001d1705.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230267AbhDMRXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 13:23:36 -0400
Received: from pps.filterd (m0209324.ppops.net [127.0.0.1])
        by mx08-001d1705.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DHMW9M011194;
        Tue, 13 Apr 2021 17:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sony.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=S1;
 bh=sUu08j+t4kd1TOUqs2L5xLy9+PJUHu9XdXZw718jRWw=;
 b=CKjS7UFGS3SvyoTHHzSBXg6iAZ6IryhbQda5Xoc7b3gSOsA4KhqXuPp9Mi/DKXAvlyBt
 nFk4Ld31KDPrVPEEyw4YQMecfEke7kiOISn5WJ6h5Wo8cqqjZxIWl8vjXUv5p3kf5k+E
 I3lV6WHetYr+1tjc+5NUQrfCBJHowhwCKIsW4EfrVdEmHYKxKjJJsOHyrsSdLPNtGzIK
 gVtIq2I3LprXqju0ARmuaV8x4j6X0TyVjjg8uUqlQfaBrLt8a26knMirf/p2KP+Xa4Gt
 CJkq4P+99fUKUBrtHjEXxdKmreVt2/mRNm8T+gstHo/Cj3le8B7SFnSNeomOyS2G21T4 Ag== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx08-001d1705.pphosted.com with ESMTP id 37u166j7eg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 17:22:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dn4GUtsvEQDAaYBFMZ+LqdX6FS6spEWuzEpUcGUxyKTJB+/mlVkXlUEEm5ZC+cgKmq8sFnmN5cmxm3c0V+yWGUKVM2r+c7uJQiK2Lzape1ztSD6yLxU4OwMlcvnd7CpkOwsjkG6pLkr22fDSN0Uvl0dgD8gbogaLFRHwNIAwkc7qxYtZqvyp4ZoD4iReN50oBpFHd/dr7ZDpYwfibb9Wn0XC+tpQ63weeOxht8lesRZe/TxnBrkJkvSv/gsRYH/lz4RZbfp50oPfbe6FGtcNsnmdjf2Q5MjotF5Tph7Pr8iMiUGE1oEer5KFkRDPiNhNXafWJQPSixd8YL/Rgat6Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUu08j+t4kd1TOUqs2L5xLy9+PJUHu9XdXZw718jRWw=;
 b=FI3VESGJxgZnGDdHMDP8iIuxVyQO9YnRvhjuiU6mZm7xRnMvlgE4UIK/Dur88sR44wSOjm3T8uOGL556gL+yd857jcx6Llt7wbHPstoCqAGrtswQUOw4pDGSbBYOrusqT7+4HaZA/HWKXWwrYcvbvj1PPF63b6OtrUCl0QT8jmYEDezES1y/JxYBZ1ncaMFIEXNjnID4CM4k3zIzUwzRQxmooAcTCswaArt35px7rCVzQiQHwKU4L+T8gNDNgnBJ6Uhu1SNgKyGOf1DgUm6ZeaaCiCy7cEUsNOh031I+fcwxa0YtruKR/ewZ3fmb9Glf6b/LGOKtV4VmuJD6AidklQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sony.com; dmarc=pass action=none header.from=sony.com;
 dkim=pass header.d=sony.com; arc=none
Received: from BN7PR13MB2499.namprd13.prod.outlook.com (2603:10b6:406:ac::18)
 by BN6PR13MB1700.namprd13.prod.outlook.com (2603:10b6:404:14d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.6; Tue, 13 Apr
 2021 17:22:27 +0000
Received: from BN7PR13MB2499.namprd13.prod.outlook.com
 ([fe80::24ab:22c1:7c5f:2ca6]) by BN7PR13MB2499.namprd13.prod.outlook.com
 ([fe80::24ab:22c1:7c5f:2ca6%7]) with mapi id 15.20.3999.016; Tue, 13 Apr 2021
 17:22:27 +0000
From:   <Tim.Bird@sony.com>
To:     <alexei.starovoitov@gmail.com>
CC:     <yang.lee@linux.alibaba.com>, <shuah@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] selftests/bpf: use !E instead of comparing with NULL
Thread-Topic: [PATCH] selftests/bpf: use !E instead of comparing with NULL
Thread-Index: AQHXMErV8JcfI63Nok6Yi06yGd1P+6qyj46AgAAONpCAAAGCAIAAAGSggAADW4CAAACiYIAAB8mAgAAFicA=
Date:   Tue, 13 Apr 2021 17:22:27 +0000
Message-ID: <BN7PR13MB2499241F9FE8E1E07AB762BBFD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
References: <1618307549-78149-1-git-send-email-yang.lee@linux.alibaba.com>
 <CAADnVQJmsipci_ou6OOFGC6O9z935jFw4+pe7YQvvh2=eCoarQ@mail.gmail.com>
 <BN7PR13MB24996213858443821CA7E400FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
 <CAADnVQJJ03L5H11P0NYNC9kYy=YkQdWrbpytB2Jps8AuxgamFA@mail.gmail.com>
 <BN7PR13MB2499152182E86AD94A3B0E22FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
 <CAADnVQKjVDLBCLMzXoAQhJ5a+rZ1EKqc3dyYqpeG9M2KzGREMA@mail.gmail.com>
 <BN7PR13MB2499EF2A7B6F043FE4E62D51FD4F9@BN7PR13MB2499.namprd13.prod.outlook.com>
 <CAADnVQJ1+EmGD3CAc4N8Jq7ACYZvbzkxZrhz8hVf4dJHGamoXw@mail.gmail.com>
In-Reply-To: <CAADnVQJ1+EmGD3CAc4N8Jq7ACYZvbzkxZrhz8hVf4dJHGamoXw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=sony.com;
x-originating-ip: [136.175.96.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 500ab9ae-b2cd-4a49-0a7c-08d8fea0b616
x-ms-traffictypediagnostic: BN6PR13MB1700:
x-microsoft-antispam-prvs: <BN6PR13MB1700D83314BCAC971679FCFBFD4F9@BN6PR13MB1700.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XuIQo/hKc0SYJm1YtenkqjXlCMMv3LMFtvNvI28Ka1jhr9uMtXU7qO2vqb3tc/z9knIGg9VhOro+DbppA6P/2IMCxk45AFQsYze4nESY3SmDPJmkMDEvs1om96kw/EcJWxrHeIabpoX4hrvY8qyyO2/A7xeHktek0i5SrzT2TCnoKjSSEYKqPOx8mTfXlNti0QtayUHdWsqZirvLBV8S0Z1SANCmMKv6G0cXiJHJJi2asGogSb5CP9xSP9FMUcAnkWOJjbpw/k69ZVRwRGSa0cBLlz2Ct2fMib4uSwUru7Jq4CxFnzhF/U72VL64B6n1qPftq1yVIRS1zXwU27kf3hRh0ZosDvEdNw1bljAtY4CX2eTWgckzJ0nfG8x4dv44q41bfq4Ji4TGWGYcWPJ1wwmVxcyz5oEC3wd7bnnYA6cF2xVk6LiHWb0akd7ToW0odzRSyg+M73H+iJy+8a3hflDDPfVtjAiECHc+DyOqOwc4XurS5F6i8oLhf9+6nTiDxa7r2Iqxh3UCLgH81eoAy2BBar2eWRb+hjiQu4yaz9+OB/jxnHY/fyp6qZ7kBUU/qFYsAAZD+2lEgOpegX3rD09SeIpaqCJ+JdSK+aN02bM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR13MB2499.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(83380400001)(186003)(26005)(38100700002)(122000001)(2906002)(8936002)(9686003)(33656002)(55016002)(8676002)(66476007)(4326008)(52536014)(6506007)(53546011)(7696005)(86362001)(5660300002)(478600001)(54906003)(6916009)(71200400001)(316002)(64756008)(66556008)(7416002)(66946007)(66446008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WHgxR1FKcnBsWXJHYW5PSHdUT2dTUHpPbmpsc0xFdWlQNjExN0tYWm5JSFdJ?=
 =?utf-8?B?NTBBbGJnWVViV3VLUjVwbE56bjJieGwwelp6cHM2cjRzNkNSekN4NW9TVVIx?=
 =?utf-8?B?ZTgzY2RENTJJRXh6WnlnNVIvK1BabTFETXFUMXE3NUh5SUJibWF2UFJ4SjA5?=
 =?utf-8?B?ZVh3bmhKQ1FBV2lBQndEYit4VVJvOEV4dnpvbUhhVHdZVmhZK2NGdU5YQWFj?=
 =?utf-8?B?cVljMjJuMGNRSXlYbGx1MzNRSTZ5amt6UGdwaTkyVFRxdDRveWxIRzZMYWg0?=
 =?utf-8?B?N1dtT3BOVlp5clB0Qy9aaXk0SzU0RS9DL2hrbVp5ZTVHSDU4NHh4Z1R2WmFP?=
 =?utf-8?B?ZW44bEtZekIzMmNMUUU1WEsrV1JnTjJ4VDFDSmZNMmdDb2t6TWw3ejBOMDFH?=
 =?utf-8?B?UFBpdC9uRUR0Z1dZUEY1dUJIemJQZm1ka3NYcWRSUFJjWVpKRCtpdDBaRlda?=
 =?utf-8?B?T2ZpdDNONmhmZ1lRaHphQi9DUWZUK3FBUCtyRjFoTFlhazJrNXdEOWg0c245?=
 =?utf-8?B?THNpUGloeEx6ODk4SmI4RnZDWlVRWjlpODlnRTZBbC8zMDNZR2dUYmFEc0xM?=
 =?utf-8?B?SEhzek9TeHp5cFhPMEZkSWlRaWlWWWZHNElJZDBPWk1vSlpWMWM4elNGdG5Y?=
 =?utf-8?B?N01TVFNmbXJaNG5sZ0IySTFhdWhYOEF2RjZHWHhkTkFDeGp2RUs5UGJiK3FF?=
 =?utf-8?B?Wi9XYURiOUJRT01QK1VjT21CZm1iL0tiNDdITGk2YlZKQUQ5bXpBRW1xUWdM?=
 =?utf-8?B?dWF2VFp2Z2RDWEVWQmFDK2tQckg3UENIeHJYbWFWZTh1T2F1MU1Wb2txcVhW?=
 =?utf-8?B?UG5zUDFkQjk5cENFOG9oNGdFeWVyTFdZV0VZTHl2NmlMdlJhK2VpczNwWk1s?=
 =?utf-8?B?VzF0dFk4clptTDgrN3FIb1BoM1ExeS9BRTlzK3dkelhyQi9vU1JBbjdvZ3E3?=
 =?utf-8?B?OTliTVdUMk1nWU1KSlo3dlliczIrSmExeThNNTU4bHVza2xWRHVPZHFuc3d0?=
 =?utf-8?B?RkdwTzhXazZra09hb2FsUlF1K3dKTDdiT2ZxSWMyL1ZzbDdIOUNjV2FsWjBn?=
 =?utf-8?B?dXNGeGZMNDg2S05rQmQ4b0ZEaEFiSVlLZkE2enVtSkJ3TDdOVWM3dWV4aUhU?=
 =?utf-8?B?V0kvV1B3TFpNSVhsK3dRbnJzTUdKNnFJelA3WUVuK0ZTMlFmZ0ZFNjNWT0ZD?=
 =?utf-8?B?QXBMZEhGOVIxTEYxVTlDRWxyUE41TkYyMTBwZCtBU2kvT1lHbFFxM0VsQWx2?=
 =?utf-8?B?OGhmU0hZZTdPUy8vQWxWbUtVVWFvVTE1bGtwRkxkNUFZdHFuQVc5ZUcyOXNo?=
 =?utf-8?B?Z3lHTi96ZTJUNncxaFpYRFBIbU1yaE5OVnlGWDl2NGh3RjdaMjMyU0x0UVFG?=
 =?utf-8?B?U0ZrUFZWUDRLZVFndTdHSnVUOWhmaytWajZhU05INTZQQTFYelJHdFRsSGtp?=
 =?utf-8?B?dUVyYU9La2JUWk1NTXRoUTM2N3dEUnYrUHpvUWI1YkIxdFhGcEYwN2hxK2Rz?=
 =?utf-8?B?MHFDWGlrckxhU0JaaUZ0dEdIemE2elllTVoxRmdPb1NXRi9CeDY4THFlYWh3?=
 =?utf-8?B?cFVmK2hYbVB0a0FDbHZ0RUdsUk5Bd0dYWnAvV2xxblNKVTk1emllOWRLYVd3?=
 =?utf-8?B?bmxwQ29PT1RRSUFOOWpMSXNJWVI2K29VNDNIWFdGYVhHN2R2MkRjOFdQbFBV?=
 =?utf-8?B?UjNYam1jMXpobnExWkRrWFJZOFY5NHNVMXU1dERlQjFYWmV2WU1rLzBwR2sz?=
 =?utf-8?Q?qOH/uyfpZdtfmqX7R7Zlht73kQA2489gEqdvLvR?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR13MB2499.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 500ab9ae-b2cd-4a49-0a7c-08d8fea0b616
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 17:22:27.4896
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QBcxz5uClJmXYpe3FBLjcLvfDPbb6oL/CQDX3JAnFSZgdRkqN0Ko8krgvpk+heKAYvmW6cBtVPzViaYwhGrMHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB1700
X-Proofpoint-ORIG-GUID: 8eA3fTwS0iLTVi_UYENPtmBLiuEFFe4k
X-Proofpoint-GUID: 8eA3fTwS0iLTVi_UYENPtmBLiuEFFe4k
X-Sony-Outbound-GUID: 8eA3fTwS0iLTVi_UYENPtmBLiuEFFe4k
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_12:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 clxscore=1015 spamscore=0 malwarescore=0
 mlxscore=0 priorityscore=1501 impostorscore=0 phishscore=0 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130118
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3Yg
PGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+DQo+IA0KPiBPbiBUdWUsIEFwciAxMywgMjAy
MSBhdCA5OjMyIEFNIDxUaW0uQmlyZEBzb255LmNvbT4gd3JvdGU6DQo+ID4NCj4gPiA+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFs
ZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+DQo+ID4gPg0KPiA+ID4gT24gVHVlLCBBcHIgMTMs
IDIwMjEgYXQgOToxOSBBTSA8VGltLkJpcmRAc29ueS5jb20+IHdyb3RlOg0KPiA+ID4gPg0KPiA+
ID4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiA+ID4gRnJvbTogQWxleGVp
IFN0YXJvdm9pdG92IDxhbGV4ZWkuc3Rhcm92b2l0b3ZAZ21haWwuY29tPg0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gT24gVHVlLCBBcHIgMTMsIDIwMjEgYXQgOToxMCBBTSA8VGltLkJpcmRAc29ueS5j
b20+IHdyb3RlOg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPg0KPiA+ID4g
PiA+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gPiA+ID4gPiBGcm9tOiBB
bGV4ZWkgU3Rhcm92b2l0b3YgPGFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb20+DQo+ID4gPiA+
ID4gPiA+DQo+ID4gPiA+ID4gPiA+IE9uIFR1ZSwgQXByIDEzLCAyMDIxIGF0IDI6NTIgQU0gWWFu
ZyBMaSA8eWFuZy5sZWVAbGludXguYWxpYmFiYS5jb20+IHdyb3RlOg0KPiA+ID4gPiA+ID4gPiA+
DQo+ID4gPiA+ID4gPiA+ID4gRml4IHRoZSBmb2xsb3dpbmcgY29jY2ljaGVjayB3YXJuaW5nczoN
Cj4gPiA+ID4gPiA+ID4gPiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9m
aWxlci5pbmMuaDoxODk6Ny0xMTogV0FSTklORw0KPiA+ID4gPiA+ID4gPiA+IGNvbXBhcmluZyBw
b2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUNCj4gPiA+ID4gPiA+ID4gPiAuL3Rvb2xzL3Rlc3Rpbmcv
c2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMuaDozNjE6Ny0xMTogV0FSTklORw0KPiA+
ID4gPiA+ID4gPiA+IGNvbXBhcmluZyBwb2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUNCj4gPiA+ID4g
PiA+ID4gPiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMu
aDozODY6MTQtMTg6IFdBUk5JTkcNCj4gPiA+ID4gPiA+ID4gPiBjb21wYXJpbmcgcG9pbnRlciB0
byAwLCBzdWdnZXN0ICFFDQo+ID4gPiA+ID4gPiA+ID4gLi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9icGYvcHJvZ3MvcHJvZmlsZXIuaW5jLmg6NDAyOjE0LTE4OiBXQVJOSU5HDQo+ID4gPiA+ID4g
PiA+ID4gY29tcGFyaW5nIHBvaW50ZXIgdG8gMCwgc3VnZ2VzdCAhRQ0KPiA+ID4gPiA+ID4gPiA+
IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Byb2ZpbGVyLmluYy5oOjQzMzo3
LTExOiBXQVJOSU5HDQo+ID4gPiA+ID4gPiA+ID4gY29tcGFyaW5nIHBvaW50ZXIgdG8gMCwgc3Vn
Z2VzdCAhRQ0KPiA+ID4gPiA+ID4gPiA+IC4vdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3By
b2dzL3Byb2ZpbGVyLmluYy5oOjUzNDoxNC0xODogV0FSTklORw0KPiA+ID4gPiA+ID4gPiA+IGNv
bXBhcmluZyBwb2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUNCj4gPiA+ID4gPiA+ID4gPiAuL3Rvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMuaDo2MjU6Ny0xMTogV0FS
TklORw0KPiA+ID4gPiA+ID4gPiA+IGNvbXBhcmluZyBwb2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUN
Cj4gPiA+ID4gPiA+ID4gPiAuL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9m
aWxlci5pbmMuaDo3Njc6Ny0xMTogV0FSTklORw0KPiA+ID4gPiA+ID4gPiA+IGNvbXBhcmluZyBw
b2ludGVyIHRvIDAsIHN1Z2dlc3QgIUUNCj4gPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiA+
IFJlcG9ydGVkLWJ5OiBBYmFjaSBSb2JvdCA8YWJhY2lAbGludXguYWxpYmFiYS5jb20+DQo+ID4g
PiA+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogWWFuZyBMaSA8eWFuZy5sZWVAbGludXguYWxpYmFi
YS5jb20+DQo+ID4gPiA+ID4gPiA+ID4gLS0tDQo+ID4gPiA+ID4gPiA+ID4gIHRvb2xzL3Rlc3Rp
bmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMuaCB8IDIyICsrKysrKysrKysrLS0t
LS0tLS0tLS0NCj4gPiA+ID4gPiA+ID4gPiAgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMo
KyksIDExIGRlbGV0aW9ucygtKQ0KPiA+ID4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiA+ID4gZGlm
ZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMu
aCBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMuaA0KPiA+
ID4gPiA+ID4gPiA+IGluZGV4IDQ4OTZmZGY4Li5hMzMwNjZjIDEwMDY0NA0KPiA+ID4gPiA+ID4g
PiA+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9ncy9wcm9maWxlci5pbmMu
aA0KPiA+ID4gPiA+ID4gPiA+ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi9wcm9n
cy9wcm9maWxlci5pbmMuaA0KPiA+ID4gPiA+ID4gPiA+IEBAIC0xODksNyArMTg5LDcgQEAgc3Rh
dGljIElOTElORSB2b2lkIHBvcHVsYXRlX2FuY2VzdG9ycyhzdHJ1Y3QgdGFza19zdHJ1Y3QqIHRh
c2ssDQo+ID4gPiA+ID4gPiA+ID4gICNlbmRpZg0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICAgZm9y
IChudW1fYW5jZXN0b3JzID0gMDsgbnVtX2FuY2VzdG9ycyA8IE1BWF9BTkNFU1RPUlM7IG51bV9h
bmNlc3RvcnMrKykgew0KPiA+ID4gPiA+ID4gPiA+ICAgICAgICAgICAgICAgICBwYXJlbnQgPSBC
UEZfQ09SRV9SRUFEKHBhcmVudCwgcmVhbF9wYXJlbnQpOw0KPiA+ID4gPiA+ID4gPiA+IC0gICAg
ICAgICAgICAgICBpZiAocGFyZW50ID09IE5VTEwpDQo+ID4gPiA+ID4gPiA+ID4gKyAgICAgICAg
ICAgICAgIGlmICghcGFyZW50KQ0KPiA+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiBTb3JyeSwg
YnV0IEknZCBsaWtlIHRoZSBwcm9ncyB0byBzdGF5IGFzIGNsb3NlIGFzIHBvc3NpYmxlIHRvIHRo
ZSB3YXkNCj4gPiA+ID4gPiA+ID4gdGhleSB3ZXJlIHdyaXR0ZW4uDQo+ID4gPiA+ID4gPiBXaHk/
DQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gPiBUaGV5IG1pZ2h0IG5vdCBhZGhlcmUgdG8ga2Vy
bmVsIGNvZGluZyBzdHlsZSBpbiBzb21lIGNhc2VzLg0KPiA+ID4gPiA+ID4gPiBUaGUgY29kZSBj
b3VsZCBiZSBncm9zc2x5IGluZWZmaWNpZW50IGFuZCBldmVuIGJ1Z2d5Lg0KPiA+ID4gPiA+ID4g
VGhlcmUgd291bGQgaGF2ZSB0byBiZSBhIHJlYWxseSBnb29kIHJlYXNvbiB0byBhY2NlcHQNCj4g
PiA+ID4gPiA+IGdyb3NzbHkgaW5lZmZpY2llbnQgYW5kIGV2ZW4gYnVnZ3kgY29kZSBpbnRvIHRo
ZSBrZXJuZWwuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gQ2FuIHlvdSBwbGVhc2UgZXhwbGFp
biB3aGF0IHRoYXQgcmVhc29uIGlzPw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gSXQncyBub3QgdGhl
IGtlcm5lbC4gSXQncyBhIHRlc3Qgb2YgYnBmIHByb2dyYW0uDQo+ID4gPiA+IFRoYXQgZG9lc24n
dCBhbnN3ZXIgdGhlIHF1ZXN0aW9uIG9mIHdoeSB5b3UgZG9uJ3Qgd2FudCBhbnkgY2hhbmdlcy4N
Cj4gPiA+ID4NCj4gPiA+ID4gV2h5IHdvdWxkIHdlIG5vdCB1c2Uga2VybmVsIGNvZGluZyBzdHls
ZSBndWlkZWxpbmVzIGFuZCBxdWFsaXR5IHRocmVzaG9sZHMgZm9yDQo+ID4gPiA+IHRlc3Rpbmcg
Y29kZT8gIFRoaXMgKmlzKiBnb2luZyBpbnRvIHRoZSBrZXJuZWwgc291cmNlIHRyZWUsIHdoZXJl
IGl0IHdpbGwgYmUNCj4gPiA+ID4gbWFpbnRhaW5lZCBhbmQgdXNlZCBieSBvdGhlciBkZXZlbG9w
ZXJzLg0KPiA+ID4NCj4gPiA+IGJlY2F1c2UgdGhlIHdheSB0aGUgQyBjb2RlIGlzIHdyaXR0ZW4g
bWFrZXMgbGx2bSBnZW5lcmF0ZSBhIHBhcnRpY3VsYXINCj4gPiA+IGNvZGUgcGF0dGVybiB0aGF0
IG1heSBub3QgYmUgc2VlbiBvdGhlcndpc2UuDQo+ID4gPiBMaWtlIHJlbW92aW5nICdpZicgYmVj
YXVzZSBpdCdzIHVzZWxlc3MgdG8gaHVtYW5zLCBidXQgbm90IHRvIHRoZSBjb21waWxlcg0KPiA+
ID4gd2lsbCBjaGFuZ2UgZ2VuZXJhdGVkIGNvZGUgd2hpY2ggbWF5IG9yIG1heSBub3QgdHJpZ2dl
ciB0aGUgYmVoYXZpb3INCj4gPiA+IHRoZSBwcm9nIGludGVuZHMgdG8gY292ZXIuDQo+ID4gPiBJ
biBwYXJ0aWN1bGFyIHRoaXMgcHJvZmlsZXIuaW5jLmggdGVzdCBpcyBjb21waWxlZCB0aHJlZSBk
aWZmZXJlbnQgd2F5cyB0bw0KPiA+ID4gbWF4aW1pemUgY29kZSBnZW5lcmF0aW9uIGRpZmZlcmVu
Y2VzLg0KPiA+ID4gSXQgbWF5IG5vdCBiZSBjaGVja2luZyBlcnJvciBwYXRocyBpbiBzb21lIGNh
c2VzIHdoaWNoIGNhbiBiZSBjb25zaWRlcmVkDQo+ID4gPiBhIGJ1ZywgYnV0IHRoYXQncyB0aGUg
aW50ZW5kZWQgYmVoYXZpb3Igb2YgdGhlIEMgY29kZSBhcyBpdCB3YXMgd3JpdHRlbi4NCj4gPiA+
IFNvIGl0IGhhcyBub3RoaW5nIHRvIGRvIHdpdGggInF1YWxpdHkgb2Yga2VybmVsIGNvZGUiLg0K
PiA+ID4gYW5kIGl0IHNob3VsZCBub3QgYmUgdXNlZCBieSBkZXZlbG9wZXJzLiBJdCdzIG5laXRo
ZXIgc2FtcGxlIG5vciBleGFtcGxlLg0KPiA+DQo+ID4gT2sgLSBpbiB0aGlzIGNhc2UgaXQgbG9v
a3MgbGlrZSBhIHByb2dyYW0sIGJ1dCBpdCBpcyBlc3NlbnRpYWxseSB0ZXN0IGRhdGEgKGZvciB0
ZXN0aW5nDQo+ID4gdGhlIGNvbXBpbGVyKS4gIFRoYW5rcyBmb3IgdGhlIGV4cGxhbmF0aW9uLg0K
PiANCj4geWVzLiBUaGF0J3MgYSBnb29kIHdheSBvZiBzYXlpbmcgaXQuDQo+IE9mIGNvdXJzZSBu
b3QgYWxsIHRlc3RzIGFyZSBsaWtlIHRoaXMuDQo+IE1ham9yaXR5IG9mIGJwZiBwcm9ncyBpbiBz
ZWxmdGVzdHMvYnBmL3Byb2dzLyBhcmUgY2FyZWZ1bGx5IHdyaXR0ZW4sDQo+IHNob3J0IGFuZCBk
ZXNpZ25lZA0KPiBhcyBhIHVuaXQgdGVzdC4gV2hpbGUgZmV3IGFyZSAidGVzdCBkYXRhIiBmb3Ig
bGx2bS4NCg0KVGhhbmtzLiAgSXQgbWlnaHQgYmUgdXNlZnVsIHRvIHB1dCBhIGNvbW1lbnQgbmVh
ciB0aGUgY29kZSwNCnRvIGV4cGxhaW4gdGhlIG5hdHVyZSBvZiB0aGUgY29kZSBhbmQgbGV0IHBl
b3BsZSBrbm93IHRvIGF2b2lkDQoiZml4aW5nIiBpdC4NCiAtLSBUaW0NCg0K
