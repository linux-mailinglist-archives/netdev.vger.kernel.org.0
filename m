Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C513835DD88
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 13:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345302AbhDMLOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 07:14:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60612 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242875AbhDMLOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 07:14:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DBAvN5090947;
        Tue, 13 Apr 2021 11:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=7lQxKLFA2mqWGDETkp4lhHsgGkk9c1rz4PrdahKBAz8=;
 b=a4IRJnyTcsEO0aXVrHyNdJf/c3c2nW0uxy+o9s14bvicVe7B0rRBEsD63bQRUI0jLNQF
 Buj4xBv6RAyAqmrwiSQ9qUvlIP0sU60+IQTZQMewf6l5NIv6RLpG7sZV92s1xyc+qITz
 gunafC9R/tMrc3I7Qc5xEY0faWROcJm8GmJ8X5BL8GqmXDQQFMCFhGlEQ+JbxQXDERjs
 buQJKImbbQNgGZvzZfCusjmAxT3Bd2xtH1l5s0D3a7etnae+HD/bpEDcMA6H6NlImtca
 NrQY91pShZG128fVjU8rY/UHQ0n7dQ/Pk4g1xz/zl5t4YLQrrgs5eow9lvEX6P2oGxNM zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hbet95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 11:13:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DBBSZM103209;
        Tue, 13 Apr 2021 11:13:41 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2051.outbound.protection.outlook.com [104.47.45.51])
        by userp3020.oracle.com with ESMTP id 37unss7ncu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 11:13:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6u00iR48i2eAv1/wpjeJLk4FBfjUOWEkU0u6zBB36+ujdGbwFePOOBOQAtEDsAbZkSJLsdIOkLe83m/DiS2wKaBYP2KePjO4VSbBLj95VbpiA4wi+TiMUrVQ5nixEeQjqayY9EDvoqa79xybxz4yszy5Q5juLtTEquAqWwED4cPBu76sr1CA+QLkwwPc5VrF7CKQqJ/s1R+ubwHcpspAYIARXxdUBtkaTEpXTEijdCoiYmU6+ZQTQy0UGBZapB4bVNONCblDa9Cb+h9PYsYrmK5Vav4GXu0NCnl1PRHsKzcaRB6TjW2L1fHBXDRgTZ3+Xy9xGRg6bWyhLva7W82Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lQxKLFA2mqWGDETkp4lhHsgGkk9c1rz4PrdahKBAz8=;
 b=KAeJAnS7QMu59s8s7ho/eIr+MIgfX5KbhjZyj5VnZD7ZU4b5JtZ0nZ0xe8oeFFO5ibT6u9RN11SLyInPcOLA+qNZl1WoJ6MIc/hiNl/P77HKDeLeW0xCmgC03WdO6NUUNUOinSG5vjz8fsWPg6rg0RQJ+QcKNMJgPDAzihQTcEzUk4j19nOz7ZCRdrek7EW3eEdzCQweWXUBGucoCYlWqiX61Y0+TqHgrXUX91jUYN7hv46Tm38vzRtvdbVk3ZLGL+oKUd+ZM93xBjP9M3be0l5FRstRnIjoVtiuvZrYK4K4zfwZmSc6Wbl6tDt48lH0sawxoMmdvcIGv2l8JdT45A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7lQxKLFA2mqWGDETkp4lhHsgGkk9c1rz4PrdahKBAz8=;
 b=HdVZLoOQnlBeSGMW3E6eGi9Ss0/bp9CmnTPquW/LkVHHHLOODYHkVUQLAsXKaHFaV69kxeT1XXiwh766EZSG2L8PVFe4RD4/XXCYWALDu4N1IkLSyNep55VjfTyuV4bn3aqu787SG2GIGTPa2kcm/epjihTG47Yk+c+QCH8dToM=
Received: from CY4PR10MB1989.namprd10.prod.outlook.com (2603:10b6:903:11a::12)
 by CY4PR10MB1302.namprd10.prod.outlook.com (2603:10b6:903:27::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 11:13:38 +0000
Received: from CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5]) by CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5%11]) with mapi id 15.20.4020.022; Tue, 13 Apr
 2021 11:13:38 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Linux-Net <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Thread-Topic: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Thread-Index: AQHXJl3kxGIldyYid0mmsgwi6FkGPKqxkg6AgAB9+4CAAE9UgA==
Date:   Tue, 13 Apr 2021 11:13:38 +0000
Message-ID: <F450613D-9A52-4D21-A2D5-E27FA4EBDBBE@oracle.com>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
 <20210412225847.GA1189461@nvidia.com> <YHU6VXP6kZABXIYA@unreal>
In-Reply-To: <YHU6VXP6kZABXIYA@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [51.175.204.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83aecd22-8c4e-4c44-0c72-08d8fe6d301b
x-ms-traffictypediagnostic: CY4PR10MB1302:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB1302F160A1674BA2AF3345F4FD4F9@CY4PR10MB1302.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cFT+DGIFniZUFUAMCPta90Dgc0Yw4teOmEkeVDfsYC8lhObSlRsrFzwbWNnzEfBiL9aojCwxsEY/rV47ciRNp8J+ekbG3q7YBV1OBBo0ONbZUWFfdayhOXswdn8q/JNwiixRRKYzesd+DpJlWBCQ45LYVvcoNPUODX5Ez1AT6unFqSo8Z8xi8Msa27/TUc3psH/0ZZ9q6RaQn+PSTaQs6cxiT02f8/KhDkDDmsUi4xghDbonPq/ZvkaYGyAli+Xn64hQIXBeFl7xP3/iTmTWmh4Ym785Qnr1YP5P1El7nCUaJqWS1weBLMY2YQ0BJr1xNXwGmuvb+ABdDsj9h9gWA9uUdcO8bP+AB7nF/tTZ8SRV1+jHasB5qm9SeHIfUsRUtldH7eY7axbkg/aqu9/4PDf6fQNqRhuXfDOjOMA+9kVbPedqZcKjcrONdBRbqVww66iEaZu1YErEQmWjk7kGI6ggFFbZ26tdPn8oBT71UPYvslJ9p77yo1XUxOyQ9mAdN9NuG3sct8Dr8y9AiuEG2hbTnkf4XExDeAjbMVNK/VfdFgBGJ0Ent1s4sfsHWkpUtZ/bFYGrrv4ZcJNOuGrVjCvHwooZBAGTZRdS7do/TvIZuV1spQ3YkSgxL/JH+n4MXKPBvJTzEpABFZpGE8e97iHGspi67efV4ETGuMUrX18=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1989.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(346002)(39860400002)(136003)(54906003)(33656002)(5660300002)(478600001)(44832011)(36756003)(26005)(6486002)(6506007)(66946007)(66446008)(4326008)(66556008)(71200400001)(66476007)(53546011)(6916009)(2906002)(4744005)(186003)(6512007)(38100700002)(8676002)(91956017)(76116006)(8936002)(64756008)(316002)(2616005)(86362001)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RE8vNzJNcUZlaGdWRjNNRWs3RFIwSTJVR3I1WHhYUjVSL2FJODlobENPYkVS?=
 =?utf-8?B?Q0c1ZXF3bHRSV0k0Z0VRSFV3VWdzdlFmLzcrdjRNejZEb2dqejNlTlIwMXk5?=
 =?utf-8?B?SENKYlh3TWRwNGRUSU5MVU5BSjRxWW1yT1A4MCtneGZjLytIWmQ4TnE4S2tq?=
 =?utf-8?B?WDBYZnA1NTl4QTEzYUlkYkpqamc5SzYweUd2eExUeGZ6eDdTSHBWT2xPLy8z?=
 =?utf-8?B?cXBWaStkU29LekFpeUlHYnpsTzRxays2RC8zVDdFZGFiSVdYNzdXQVYycnJB?=
 =?utf-8?B?MXpEOS9SMFpPNlFJMWxEZWw3WkRkNE9uZXhOeTczTmsrZ2NVRWMvVDRYMWpU?=
 =?utf-8?B?aFBYNW5heFRsZGs5SW53WVVpNnYxQnZ3M0pEVHpRTnhRSDIxTVJHYVFOK0NK?=
 =?utf-8?B?cXZPMWFYdy84WVpxeWdJNjc5WDVyNmQyUTg0VDJqYmhrVEU1OTB5WWdLS1N3?=
 =?utf-8?B?RDNjOVVUOWpWb3FTL3dwVVRmY1dLbG52S1pvUlZzdkdoWmIvZ1dDYnlOSjN1?=
 =?utf-8?B?TnpXUWtnKzJ6bVo3THJrbGZhekp2SDhhR3YrS3BsUGIrbFpsb0dKQXQrelly?=
 =?utf-8?B?bEE3c2g0UzFMZkRWK0ptTko3Tlg5elhJLzhZaVRTa3Y4MjJZMVJUaS9TOERa?=
 =?utf-8?B?c0g2NE1QeklnV1NLUDBQVXIzZVZVRFU4NndJTHplVkFNQ253eXJ6NGVzOFNQ?=
 =?utf-8?B?YVQzbndCdE5HSGNYUDV5bXY5Y211VTNkM1FMWWF3c3RWelVQNFpZRm1qK1hu?=
 =?utf-8?B?MlpSWGI0WHBHdHQ0akVlWkhDSFRQb1F3M0srZDhaRmhoNllwYW5yUi9JSDRD?=
 =?utf-8?B?UTcwVHcyQWZKMlVYcFFlRjJTaHA0UENVV2JjdUZ4b1Z0WUxZVlNFREJsL2JR?=
 =?utf-8?B?ejdmcWpBSmRScXF1NnZBQjExMXppK0c3Z1V4ZUcrSUhyRDV5RDBwOWRmanNj?=
 =?utf-8?B?VkRtUGwxb2QzMVIzc3dFZGptK1JYeDhjZ29JVXZIU2tGYlFNT3QxUHRPeUlM?=
 =?utf-8?B?UUo3R0pacVg0a3BkN3Arc2hHb1NubkpqV2x3dlhOYWFBRHJCMzMzc0xLUUNZ?=
 =?utf-8?B?WEZGc3pHOUN1cjhzS000SUd6amJOaEo2RVFmcEN1RWxwZWNaRm5RQUR6ZDdz?=
 =?utf-8?B?Qkx1VmRmVHYrMFJ6L0t3Z09CTEdtaHd2Y29Vcm1ta0trM214dHovUzBETzR4?=
 =?utf-8?B?ODdSa2p4QmpibjViSmlUeUYrZG1QR1VSMmRQWEx0ZWh5cGFxK0pZcWZaMWEv?=
 =?utf-8?B?WURpbEdxQVNFelZLOWxMWjhiNXp6TmpsUmRka3djenh5ZU1FRXJrY1JjKzd2?=
 =?utf-8?B?czQ3aFFsWEg3TjRJOHNyUUhQRHBJdzFGVHliTEtYdTJ5dmdPYTZXbHZmeWtQ?=
 =?utf-8?B?d29yaEduc2dXc21INVp3Sk1ZVFUxcnNPRXo5Z1JaTzZWUVJPYzdMTEkwSnhN?=
 =?utf-8?B?bHJMWGI1bFg1REdvYncvQWJmMjFHcFp4RFYydldmQytETGhYbUovQm8yZitn?=
 =?utf-8?B?d1JZUDR6c282QjZnaXJTYlUrMFZXUGFoNm9FZnd5Vm1qQ3poV0VsRE5YRGJw?=
 =?utf-8?B?aXhHUWNKaEFPL3lPTmdWVVJlSzJiQk41ZHVRQjJlUGNtaWZyYVI2MEJHZDRT?=
 =?utf-8?B?MmJmT1FGOExZWVhBY2ptUlpBV1FJNzltbVcrejNoblFpcVF1ZVhaSVNSL0RE?=
 =?utf-8?B?U0dnMkRDRHpRRVZLRXA2T2ZscVR6OHhUYVRXelExWjhKK3lVbitraWlFWlo5?=
 =?utf-8?B?OTIvdkEyUklOT2UvbHcyMnkvZVJJakQyS01XSDBzdWZJcnhzaURldXd3bVl2?=
 =?utf-8?B?TWxPRXdjZ3M1RGJNRFU0UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61A2D464B3D1074F93182A577519673F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1989.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83aecd22-8c4e-4c44-0c72-08d8fe6d301b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 11:13:38.3905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tYYOPDZAvpG6L9YM3FXA5Kzwm2pl5HByTkj0EE17juAFFw02mZokVk4kZ7n/thE2rTVHscL8yhXwPtFv4FGaWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1302
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130078
X-Proofpoint-GUID: XN6FC6VAhnvUkkK4s2UrnBpFdb5ZFe4l
X-Proofpoint-ORIG-GUID: XN6FC6VAhnvUkkK4s2UrnBpFdb5ZFe4l
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130078
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gMTMgQXByIDIwMjEsIGF0IDA4OjI5LCBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2Vy
bmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIEFwciAxMiwgMjAyMSBhdCAwNzo1ODo0N1BN
IC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6DQo+PiBPbiBXZWQsIE1hciAzMSwgMjAyMSBh
dCAwODo0MzoxMlBNICswMjAwLCBIw6Vrb24gQnVnZ2Ugd3JvdGU6DQo+Pj4gaWJfbW9kaWZ5X3Fw
KCkgaXMgYW4gZXhwZW5zaXZlIG9wZXJhdGlvbiBvbiBzb21lIEhDQXMgcnVubmluZw0KPj4+IHZp
cnR1YWxpemVkLiBUaGlzIHNlcmllcyByZW1vdmVzIHR3byBpYl9tb2RpZnlfcXAoKSBjYWxscyBm
cm9tIFJEUy4NCj4+PiANCj4+PiBJIGFtIHNlbmRpbmcgdGhpcyBhcyBhIHYzLCBldmVuIHRob3Vn
aCBpdCBpcyB0aGUgZmlyc3Qgc2VudCB0bw0KPj4+IG5ldC4gVGhpcyBiZWNhdXNlIHRoZSBJQiBD
b3JlIGNvbW1pdCBoYXMgcmVhY2ggdjMuDQo+Pj4gDQo+Pj4gSMOla29uIEJ1Z2dlICgyKToNCj4+
PiAgSUIvY21hOiBJbnRyb2R1Y2UgcmRtYV9zZXRfbWluX3Jucl90aW1lcigpDQo+Pj4gIHJkczog
aWI6IFJlbW92ZSB0d28gaWJfbW9kaWZ5X3FwKCkgY2FsbHMNCj4+IA0KPj4gQXBwbGllZCB0byBy
ZG1hIGZvci1uZXh0LCB0aGFua3MNCj4gDQo+IEphc29uLA0KPiANCj4gSXQgc2hvdWxkIGJlIA0K
PiArCVdBUk5fT04oaWQtPnFwX3R5cGUgIT0gSUJfUVBUX1JDICYmIGlkLT5xcF90eXBlICE9IElC
X1FQVF9YUkNfVEdUKTsNCg0KV2l0aCBubyByZXR1cm4geW91IHdpbGwgYXJtIHRoZSBzZXR0aW5n
IG9mIHRoZSB0aW1lciBhbmQgc3Vic2VxdWVudGx5IGdldCBhbiBlcnJvciBmcm9tIHRoZSBtb2Rp
ZnlfcXAgbGF0ZXIuDQoNCg0KSMOla29uDQoNCj4gDQo+IGFuZCBub3QNCj4gKwlpZiAoV0FSTl9P
TihpZC0+cXBfdHlwZSAhPSBJQl9RUFRfUkMgJiYgaWQtPnFwX3R5cGUgIT0gSUJfUVBUX1hSQ19U
R1QpKQ0KPiArCQlyZXR1cm4gLUVJTlZBTDsNCj4gDQo+IFRoYW5rcw0KPiANCj4+IA0KPj4gSmFz
b24NCg0K
