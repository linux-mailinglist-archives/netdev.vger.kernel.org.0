Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AE53A1311
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 13:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239378AbhFILoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 07:44:05 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:35041
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239416AbhFILni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 07:43:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSHLuTEPNmxZJjZIvEiaxfzpeccnZuM8k4YGfrhR26Q0708d0ENdORoFn+fOs5Wwz3Bag2rh2O+3nAvZW0rT7vEtbG14MoOkwC9l3HUa03bZrjehV/xTt8hnQKSLipr4ZG+LSePedSgK7ovi47SIRQ1+jL+CdSGOwQxK0ThyC9yMl5fbSAajNkUEGVTC2hK8RRPubNJQjpCazr2mEaBqW7z7ZRhfpJzpRDvuYFGje0POZ5G54oYbvX42hSx5E2dB2OveNnIp5Xptp+75yxkENXxUwcs960pLWHeaMjeKIybjeY5u1pJqB8JmQwoyDt++VTk4ohra2Lm8sZ0y7vV12A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fi5IsqkRAsO9ZahipVwt4r8xuabl3mAV8Ozsa1vGeE=;
 b=YDjVRnByPBRVASs9EUcZfZSWDwp9Kx988tO8NJAbK51rD8Hrg06I80CpXjk1UZfp/R6QeIU3PnZF8+ASIaQjs5cIigVgl83NDmky9iB7QTaxzXHBQpXZUVmOxkslSChVklo8SB5MlE4NhuHPftJMY90uFNIL5XUiRImqa7HpRdwQuxJRn8EcL7E2s5XTtHKQwP6vyVkKjZJTlWM35wivQHkdcn7cYORSCWVtWbQTi3Ddjfbd/c36HJob4tQoQb9HcdiNqDR1cTRAmXhXaGe6l6x6RCf/hONspiMep8Juk4seFTfjaMTB0gDPVLNua/SsmwynMWg/OqPASVE1G/buZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0fi5IsqkRAsO9ZahipVwt4r8xuabl3mAV8Ozsa1vGeE=;
 b=OyR5pISf5ihVaIZV9or5eNHvUOTDlPxcvNjQPgHG2YdwClqbCREieAy+fVy4uMdRpcEPgcOQHU/slbdOcStOUSZt182PoWk5S60SJHWYckQgtb5SGsIatI5G7Uo9mgctsGMp5QugVSLDBkQDSf7JV9XkUTjTk9fVQghgzDpwHGzgdXJ2F4IlVzITkEJUZAtkOc0Vk6/sppKpVz4tE8G9im/cfCYdNgD1tZZpavrRIhHN1EoYRTwnQAcB54wTlgUCYYuANS7t2hHXXETyEui0uaFbKZM75XeaUfGUW25qJAaKRX3VSR3YXI2/I+N69JB2NjmJ/DUc0EAD7yTBGfSd7w==
Received: from DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) by
 DM4PR12MB5197.namprd12.prod.outlook.com (2603:10b6:5:394::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.22; Wed, 9 Jun 2021 11:41:43 +0000
Received: from DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4]) by DM8PR12MB5480.namprd12.prod.outlook.com
 ([fe80::411c:4f77:c71f:35d4%7]) with mapi id 15.20.4195.030; Wed, 9 Jun 2021
 11:41:43 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Topic: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
Thread-Index: AQHXXSOKIeWKy8Tb3ES7oqXp/ULpGasLjafg
Date:   Wed, 9 Jun 2021 11:41:43 +0000
Message-ID: <DM8PR12MB548026AA440355217C7AD509DC369@DM8PR12MB5480.namprd12.prod.outlook.com>
References: <20210603111901.9888-1-parav@nvidia.com>
 <c50ebdd6-a388-4d39-4052-50b4966def2e@huawei.com>
 <PH0PR12MB548115AC5D6005781BAEC217DC399@PH0PR12MB5481.namprd12.prod.outlook.com>
 <a1b853ef-0c94-ba51-cf31-f1f194610204@huawei.com>
 <PH0PR12MB5481A9B54850A62DF80E3EC1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <338a2463-eb3a-f642-a288-9ae45f721992@huawei.com>
 <PH0PR12MB5481FB8528A90E34FA3578C1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <8c3e48ce-f5ed-d35d-4f5e-1b572f251bd1@huawei.com>
 <PH0PR12MB5481EA2EB1B78BC7DD92FD19DC379@PH0PR12MB5481.namprd12.prod.outlook.com>
 <17a59ab0-be25-3588-dd1e-9497652bfe23@huawei.com>
 <PH0PR12MB5481256C55F3498F63FE103DDC379@PH0PR12MB5481.namprd12.prod.outlook.com>
 <4e696fd6-3c7b-b48c-18da-16aa57da4d54@huawei.com>
 <DM8PR12MB5480BE54D27770DEB39EA009DC369@DM8PR12MB5480.namprd12.prod.outlook.com>
 <c30727a7-49a5-db18-ed16-e96e55ec66a3@huawei.com>
In-Reply-To: <c30727a7-49a5-db18-ed16-e96e55ec66a3@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.202.149]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fd34163-c979-4521-f864-08d92b3b8df3
x-ms-traffictypediagnostic: DM4PR12MB5197:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM4PR12MB519720648F0E1AB83B49A3C3DC369@DM4PR12MB5197.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aoOp4DNi8T0QvSpZmCMkzKfOKiqUmlgzrVoZdW3t/uprwz8FgB8VfTNXFyAQMZIeH15yg5946IONn+0RyW4mO0Cr2iwAio14J4XurD8GHjXoJMRkYDrSJL1BBrzNL/5fcqBkhxplCqS13awBkIQ4K1jcX5CbDS62d1h3pMQhb3E3lLlMdtoO2YBIug88V2Yqf5CLdjHX4932kPySmsqdEpf4y4h1tiaMKtP636RuEsQfqfFhupmOyw6qm+0x+KHVi32gKNY9PQxmt1ljy0NHKK49+Um3TkyJQ6P+hc6BVvjtaBculhoDJ/21G75tQc5uaajAL9cOIcd0Iv5lWhiLL3WSH0XVIe4R3V3cNaJipeeD58LBRGh172trX/6b1QOH82fW5/w2z8AFa9F0WtjqHRD2LXWccM7RhMA9XxpVGdi7nQEGv5HmnKKF4uDmXBD3TQWPoaSZrwn23o+QXYgVQpW8LHVafvNOtGt/6sMKrbn2g45DqeHiFXV1JfqW41Fe39obrOqQNIac1A90KmVWHvvEc9VzK+FgLdRAxccaZC9OtpWoCQr8wwHfgfgjtLTkVHTOhMxt1yTOt8k+INxc1QnDRhPFL/4oiciwwPUXsRw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5480.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(9686003)(55236004)(53546011)(7696005)(6506007)(26005)(4326008)(8936002)(55016002)(33656002)(5660300002)(316002)(76116006)(110136005)(8676002)(52536014)(478600001)(38100700002)(66476007)(122000001)(86362001)(71200400001)(186003)(64756008)(66556008)(66446008)(2906002)(54906003)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VmltZXh0eTlucnYzTCtMNG4xMUl3QWdJanVwNGdiSDdXeDMzK1V0V0l0VmNr?=
 =?utf-8?B?aUphTDlNbjNHZndNK1p2S25HWVUvU1I1NDI2M2tlYWNlc3NyWUVUZTIwSGZV?=
 =?utf-8?B?TUxQWHhCKzJmaEUzTklyUzFYSVNRWTVuTjJzUCtzdklHbS9QSkVTdUVPaUNj?=
 =?utf-8?B?SWVUcW1pYzZZaDNUQUVJdkxIdFBXQTlOK0VPYkFudW95K213Z1EwaHA3QWc0?=
 =?utf-8?B?MXRncTR6cktHdGNnbWZNeG1ZQVZPdEQwV1l4NU05MlFSemlCTnpRRGt5V2lM?=
 =?utf-8?B?Yjg0aVR3eXRhQytZWXc2MzB6ZDd1WUd3K1pqZjh0bHl6elpncnFZeEduRE5G?=
 =?utf-8?B?eWJkSisyVVVFdFZJY1FxTkdNK2kyYjBCTmNYMlI2Vzh2emlrWlJ4Q3B4OGln?=
 =?utf-8?B?MFppVnV6U25tb2RRZ3FDdnBYUXYzdngwcGhDV2loSVlycUFlYjRob2JIMjdV?=
 =?utf-8?B?a2ZsVjMvR3ZjZTBkbEdXakdMVEtZVUxWczFRRzVWWUg1SGdyMVVrc2FOMzNC?=
 =?utf-8?B?QW0xYVJsaUFGakdBN1J0Vm4yL2tRcjB5UGFlajFHSUNYYzRJYUVnVkNKb0tB?=
 =?utf-8?B?cmFPSkd4M0FxYVh3eFJUVjdsbGgzR3NIeitwVVlxV3RoQmFGYjZvQ3QwS2RP?=
 =?utf-8?B?dHFOUXlmQjE2ODExWkc0Y0V2ck8yK2Y5TkVGRTBzZk5Kc2x4SzlIOUY2M2xv?=
 =?utf-8?B?UjRrVnRBS1hCWGN0SWFON0REcUl6UW94c3lKSHJVenNNR1QyUklyL2pQNDQw?=
 =?utf-8?B?b0ZoMm1hWGVYbmJQc3E1OFZZTDdNQ2tmWjZZUGFONzZjTnREOTdaR0t4bm5F?=
 =?utf-8?B?YlYwWStqVGs2RWhwODNOOEg5OFk0NGtwNmNydnk1WUg2eDdPbEpaTUtrQW5P?=
 =?utf-8?B?a2p4WUQ2ci9SVSt1UjNSTHk3T1g4S2kyM003VktldnJrTkt6WWQwR1ZZNEdr?=
 =?utf-8?B?UExjazhpeEhITmowYkFSUzljR0VlOThWNU0xY3BISlBBYnFRTmt0cEQ2dysr?=
 =?utf-8?B?bVFsNUx4eXFSWWpzck16Vml4eDRSZHNOUUVQM0hRMG52YTJjYWpaSUxQanFm?=
 =?utf-8?B?SHZGUmdKd3hkM2grZHNRSEtmT2k0QmRHMEh6QVRSYUR3cjZPemo1VEVuQWQ1?=
 =?utf-8?B?NTlwMGZsc2F1ejBDQUd5QUVxT3lkVzlvZXk1QVhub1lhbFRJeWZpMWlLNnpS?=
 =?utf-8?B?NS9WTEQyb2djaU02czhzcHpaOVdxbUJUMFY2SjVCYzFZbzkreFFkbHVIME5D?=
 =?utf-8?B?WFQxVm1sOWIvNlR3bDMrbTJHMThCL29kRVdaM2lUeXFjak1WeVNkSy9MUnVF?=
 =?utf-8?B?a2VqM0J2WUdqU1JNblhWSXZzb3lTNTVqZEIvdzhYMEU3TDRTdjdMN2lRVHUv?=
 =?utf-8?B?S3pBcVVEWEV6R2lmWTNpQW1MUGx6cmFVdWRMb09Md1M3WmJkMVJMRi90dldQ?=
 =?utf-8?B?SXJQTWU0YXhuYmRGVitCVVlMTkxZcURKQldZdTFBZlh3d3I5WnFNRmJwS01p?=
 =?utf-8?B?SU5aUGlOUFNyQXhDMmIwc1JjcStFNGVOek5UaytHT0tGMkhrL2phSU45ZkZ3?=
 =?utf-8?B?eEFWWUFnRVFFVndVWnNURXNkVUNVNUZwWXF4Q2Y1ajlsMkJoZUVvUHJ2VlF3?=
 =?utf-8?B?eGZPbTBmUEhKOGNHOU96ZnByRTJ2RCt5UDRZVCs3UzhNYXFhWVM4UEpickpq?=
 =?utf-8?B?SjFZVnhkaWJ3MnZiU0s1MnF0TnEyRy95T0xLRktVUjlKRFAvb0xoT2NDemxE?=
 =?utf-8?Q?6ECFr24xoEmoJXF7ocDzKx8/zJl2Pka41fxwfGu?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5480.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd34163-c979-4521-f864-08d92b3b8df3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2021 11:41:43.3012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: agBUOInzdTvX2fuyG5BIViasdoD47mk2omXV+OyAoKb8/lONQqJm3HTIbfoyQavWNezVPaJhtt1MHmG7P3GbhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5197
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWXVuc2hlbmcgTGluIDxsaW55dW5zaGVuZ0BodWF3ZWkuY29tPg0KPiBTZW50
OiBXZWRuZXNkYXksIEp1bmUgOSwgMjAyMSA1OjA1IFBNDQo+IA0KPiBPbiAyMDIxLzYvOSAxNzoy
NCwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+PiBGcm9tOiBZdW5zaGVuZyBMaW4gPGxpbnl1bnNo
ZW5nQGh1YXdlaS5jb20+DQo+ID4+DQo+ID4+IEkgdGhvdWdodCB0aGUgcmVwcmVzZW50b3IgcG9y
dHMgb2YgYSBQRidlc3dpdGNoIGlzIGRlY2lkZWQgYnkgdGhlDQo+ID4+IGZ1bmN0aW9uIHVuZGVy
IGEgc3BlY2lmaWMgUEYoRm9yIGV4YW1wbGUsIHRoZSBQRiBpdHNlbGYgYW5kIHRoZSBWRiB1bmRl
cg0KPiB0aGlzIFBGKT8NCj4gPg0KPiA+IEVzd2l0Y2ggaXMgbm90IHBlciBQRiBpbiBjb250ZXh0
IG9mIHNtYXJ0bmljL211bHRpLWhvc3QuDQo+IA0KPiBTbyB0aGUgRXN3aXRjaCBtYXkgYmUgcGVy
IFBGIGluIGNvbnRleHQgb2YgKm5vbiotInNtYXJ0bmljL211bHRpLWhvc3QiLA0KPiByaWdodD8N
ClJpZ2h0Lg0KDQo+IEl0IHNlZW1zIHRoYXQgaXQgbWFrZXMgbW9yZSBzZW5zZSB0byBzZXQgdGhl
IGVzd2l0Y2ggbW9kZSBiYXNlZCBvbiBkZXZsaW5rDQo+IHBvcnQgaW5zdGFuY2UgaW5zdGVhZCBv
ZiBkZXZsaW5rIGluc3RhbmNlIGlmIGRldmxpbmsgaW5zdGFuY2UgcmVwcmVzZW50cyBhDQo+IG11
bHRpLWZ1bmN0aW9uIEFTSUM/DQpEZXZsaW5rIHBvcnRzIGFyZSB0aGUgY2hpbGRyZW4vc3ViIG9i
amVjdHMgb2YgZGV2bGluayBpbnN0YW5jZS4NCkVzd2l0Y2ggbW9kZSBpcyBwZXIgZGV2bGluayBp
bnN0YW5jZSB0aGF0IGRyaXZlcyBob3cgaXRzIHN1YiBvYmplY3RzIHRvIGJlIGhhbmRsZWQuDQpT
aG91bGRuJ3QgYmUgb3RoZXIgd2F5IGFyb3VuZC4NCg0KSWYgeW91IG1lYW4gdG8gc2F5LCB0aGF0
IGluIG11bHRpLWZ1bmN0aW9uIEFTSUMsIEFTSUMgY2FwYWJpbGl0aWVzIGRlY2lkZSB3aGljaCBk
ZXZsaW5rIGluc3RhbmNlIHRvIHN1cHBvcnQgZXN3aXRjaCAoYW5kIGhlbmNlIGl0cyBwb3J0cyks
IGl0IG1ha2Ugc2Vuc2UgdG8gbWUuDQoNCj4gDQo+ID4gUEYgX2hhc18gZXN3aXRjaCB0aGF0IGNv
bnRhaW5zIHRoZSByZXByZXNlbnRvciBwb3J0cyBmb3IgUEYsIFZGLCBTRi4NCj4gPg0KPiA+Pg0K
PiA+Pj4gRWFjaCByZXByZXNlbnRvciBwb3J0IHJlcHJlc2VudCBlaXRoZXIgUEYsIFZGIG9yIFNG
Lg0KPiA+Pj4gVGhpcyBQRiwgVkYgb3IgU0YgY2FuIGJlIG9mIGxvY2FsIGNvbnRyb2xsZXIgcmVz
aWRpbmcgb24gdGhlIGVzd2l0Y2gNCj4gPj4+IGRldmljZSBvcg0KPiA+PiBpdCBjYW4gYmUgb2Yg
YW4gZXh0ZXJuYWwgY29udHJvbGxlcihzKS4NCj4gPj4+IEhlcmUgZXh0ZXJuYWwgY29udHJvbGxl
ciA9IDEuDQo+ID4+DQo+ID4+IElmIEkgdW5kZXJzdG9vZCBhYm92ZSBjb3JyZWN0bHk6DQo+ID4+
IFRoZSBmdy9odyBkZWNpZGUgd2hpY2ggUEYgaGFzIHRoZSBlc3dpdGNoLCBhbmQgaG93IG1hbnkN
Cj4gPj4gZGV2bGluay9yZXByZXNlbnRvciBwb3J0IGRvZXMgdGhpcyBlc3dpdGNoIGhhcz8NCj4g
PiBOdW1iZXIgb2YgcG9ydHMgYXJlIGR5bmFtaWMuIFdoZW4gbmV3IFNGcy9WRnMgYXJlIGNyZWF0
ZWQsIHBvcnRzIGdldA0KPiBhZGRlZCB0byB0aGUgc3dpdGNoLg0KPiA+DQo+ID4+IFN1cHBvc2Ug
UEYwIG9mIGNvbnRyb2xsZXJfbnVtPTAgaW4gaGF2ZSB0aGUgZXN3aXRjaCwgYW5kIHRoZSBlc3dp
dGNoDQo+ID4+IG1heSBoYXMgZGV2bGluay9yZXByZXNlbnRvciBwb3J0IHJlcHJlc2VudGluZyBv
dGhlciBQRiwgbGlrZSBQRjEgaW4NCj4gPj4gY29udHJvbGxlcl9udW09MCwgYW5kIGV2ZW4gUEYw
L1BGMSBpbiBjb250cm9sbGVyX251bT0xPw0KPiA+IFllcy4gQ29ycmVjdC4NCj4gDQo+IFRoYW5r
cyBmb3IgY2xhcmlmeWluZywgSSB0aGluayBJIGNhbiBzZWUgdGhlIGJpZyBwaWN0dXJlIG5vdy4N
Cj4gDQo+ID4NCg0K
