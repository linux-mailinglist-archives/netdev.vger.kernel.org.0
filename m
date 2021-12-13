Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5522847383F
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 00:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237816AbhLMXGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 18:06:32 -0500
Received: from mail-co1nam11on2051.outbound.protection.outlook.com ([40.107.220.51]:9601
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234834AbhLMXGb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 18:06:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pgct3aovuRtI6Asf1im3W+ptIjEnY5/lb7G2+S+zcq0xg1F1KQr3pasRLtjQt6gIjwzGBDVNyzxIcNNv7s18dudHPCqLnYNiuX9DzhIrIxnOOWm8SXy3RAmrr6oZcdSS1KfsfCIYMa6l+Zua1JEA4FoIC9L8q98gGHOJLdPaePsoP1pRqZBa3vUP5IJKB8fD2aEqL//dYVzcWtfy5VT/brTx+3pz01d1FjuTrgl/XWjUV08b3L/POOLe9O+H2enoUVRWIP7ff2qquMn2gxGLmzLl9atINfb0dycWy6lV/Obd85ERwPJFIc3mcSRzO0O9Qh1Zb3EOUsYWCgcj89Ejzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Vo+ttj3pTUf33Xqjlx3UGFIwc4867IwXTDCQ68B2wI=;
 b=Bc9sVx8M9i+JcX0cyinULX6m5OdZEL6Qr51FaB7fwf1mUOHb3eN9UOMWjdqMHW3NsVOBn5oDyEMUxAyQpEZ4xLJ8TLCb+d7CAuWswrpJtM4CKPSTAelyhhBhQt9MRdP6ETw7UyIL/cGftLa9yZVpIb5dGPhPuLGj3pCKyD1uVIOn9ji7L0+KdbSHpdWUyg0hZXygHvxKBSGzxm1FLKDuZHiLPfERG6jpkMefBiawhLvTUsP5Nc/G3/kpIYgx/LoMl+3fxhLJn2qyrnm2gO80Cy1/3iDC3jN/Fz9OoXSkF/Qr/hUsYG7WQcEMT+uJf+3npuC7oTwpmcaNqFGYOVpbvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Vo+ttj3pTUf33Xqjlx3UGFIwc4867IwXTDCQ68B2wI=;
 b=KrKudTymIrMeUSPCXOLpmxnKraGgWANPFCzZ6Qg2eMmoTjFd3t+xTG0YlbPLjWzfajgaAGmRi17L9iaVOnEHKpopTjZSNJt+tkllYyqO9Q2Dvj1u6JmvHvJUuif/ePMG9/HDJgQwuJa/Ixq4slaRiQS1QMdQm23zXMv56efilCc3auHihhLWcujCEJMnHCLXWCp2T74zX89sJthhp8wetzh24lukDQBjdTmJ2pFWt+LwA2MFgXu8Ym/2NCRyvZTE53JlTBnfEEmqn8gHeqAh3Z7P+vIwbswRmdcVqEc7imHrjSyyJ72+0GTI9ZQEFZP3pk8+FXGrqGRQSACGmezsQw==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3302.namprd12.prod.outlook.com (2603:10b6:a03:12f::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Mon, 13 Dec
 2021 23:06:26 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%7]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 23:06:26 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Shay Drory <shayd@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 0/7] net/mlx5: Memory optimizations
Thread-Topic: [PATCH net-next v3 0/7] net/mlx5: Memory optimizations
Thread-Index: AQHX7D5dD+adttVerk2gBbMZG9h/QKwxE52A
Date:   Mon, 13 Dec 2021 23:06:26 +0000
Message-ID: <160c22e7ee745e44b4f37d53003205d8f63b8016.camel@nvidia.com>
References: <20211208141722.13646-1-shayd@nvidia.com>
In-Reply-To: <20211208141722.13646-1-shayd@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b6e0a44-0b7b-46ac-3123-08d9be8d307d
x-ms-traffictypediagnostic: BYAPR12MB3302:EE_
x-microsoft-antispam-prvs: <BYAPR12MB33027AF097D5EC79735328DFB3749@BYAPR12MB3302.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bjjBLpEt81fFdn72/WwZhyZWh1FJjmCmYz9J+ef0oBSBS9jEKujN5yEhVZLAZrgBduCvLIEDa14nOCtLOIfIehp8Y47O6RFMPvbOmOtvGSN8z+aWuH0Bj+rQXRayN55wpHovTENVd2TxTlhFp5f7rcKv3e09RbwpVjDA5TR8w7Y8pxTTIU2juG2ijDatoOSfDGioshzBogoHtJYKE+WBGjkjRCNF7uc3oke+TRiq/K3B8G+u0Rg5fYRmXp6IxveCSMykK54w3PPtX5/v4du7UUxPa90+IHOdBwgwYzVnS9VFL9X2XGksxA1cHtAhyvgzsd4WbD/zdiV+3rRZZ0lEyxpdiZVDyDszXcne0+qJdnYsKCi9qmfeAy5nowFpjvLQ6T1VJ97aM9285gf/lKduWtfquF0+77A8zX/eFO8zVThPljTPKifHxtHL4e/+DHWqsSchcFpgnoTaLD3KsX8SYXsz/GmUCb0vfuCyMRIe4vad/dMNAO8exEmeBa28HzdqdyYyI0iC0d0r+DyPKzEQZ50Da5nKrKB/v7FC8xupP67+Fw0aUDiCS+YKnMQ3Am6Aoal2Bn5DG5VPac+3IsTlX4R/uctg5UVFDb3wjbqfzzl0aNnD05cZj14tlaeXgGgiZqHNH2IgCO1OzLdseh8FKaIS2k5FSkailbjWm91YcX3eGON8TtRuTVpa2Ex31UK2bZaIG0wvIgY7pc5QH7VUrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(5660300002)(38070700005)(8676002)(4326008)(316002)(38100700002)(4744005)(2616005)(122000001)(36756003)(54906003)(6512007)(186003)(110136005)(26005)(66556008)(64756008)(66446008)(66476007)(2906002)(6486002)(8936002)(66946007)(71200400001)(86362001)(6506007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXYwRmhRYkpyRXNYMTI0L09yNDNNZHRXZ0VJTEpJM0FsSENjVnBUR2h3NE92?=
 =?utf-8?B?WWs0MnFtamU4bHdaajdNVWI5NFVCeFRtY1FYRGJCdGtmYmd0dFBXNDdyUnhL?=
 =?utf-8?B?Sy9tK09LNS9UdjB2dXl4cjBYaUJRYnN0MitLWEF1M0xqbGtHd1M1Y1FIdkVH?=
 =?utf-8?B?dG13K2dqMGpXeEd3NEFEam1mUDBZdWpET1hBZGx2aXh6dC9GNG9jaUdpemxj?=
 =?utf-8?B?MWNWWWtNZEFNNWd0cktnVVJObEtkUjNIc2NObXVUbGc5dGZoMjB0VjZQcGE0?=
 =?utf-8?B?VzdQQUp3SUhjUW1DQzRxRU5WdzNlWkpTc2YwZjJHQkRUdFQ5Wm5NbFRUMVNC?=
 =?utf-8?B?MlV1aVA2TVZ5djRRcGVsdzI0enhqQ3luVjFDaklrdXJKVmhQR2FaVFZJUWdL?=
 =?utf-8?B?WXN2ZXAvbVg1b1FvS05IbWVxZVVZN0kwOUl5NHZuM1paTVJCNEtvUFJJOSto?=
 =?utf-8?B?ZDNsRE54bkM5K04zS1lLbnpNakVYQTh4Z1dqdFhyN0JmVEFERjUvUVFHclRV?=
 =?utf-8?B?Mmh2R01EeDFUbURSTVRHZ0k4V3pPc3l1aUxqL2xKRVlob1pwUGdwYzZzYlBh?=
 =?utf-8?B?bWxKTXovc2Y3WE13K2VkaTlwVld4ajI1bGd6M0UyWUc2QXM1R2dkYmQzaTdm?=
 =?utf-8?B?NmNkSHhZRVZuTWt4M2RXQ3BaMDZUazFLSWwyaWFIMCtoU2pwUElZQ2lEUlBa?=
 =?utf-8?B?VTMvbWRHS1hhRVVibHNWZGhEejdPMkpBT2MvdEVLbDRwTHdvOWdmSnp1cnBH?=
 =?utf-8?B?SjZDZm1UZ20rTlAzRCtIbS9oYjl1b3VOOWlaODgvb0JaNUx0R29kNU5vckUx?=
 =?utf-8?B?RVB3QXB3c28zOXFXR3V6ZEhoZk9qY0k2cHZiS1NOeXJ2b1RBNXJDRk40QUp3?=
 =?utf-8?B?eWJ4bmpQdkIyUE9NaXZvNndNUTh4KzhSK29aODFlNGJCUWZxU29TNnNaNkFZ?=
 =?utf-8?B?RGdCODNwN08vczdoSmlBTmV1SWV5cDVnaUJSeU5KcU1XRXZZaE10OTlUZW9z?=
 =?utf-8?B?cFFXU1hCaGlWUGVRcXZUYXFzaXhzZnQ4WXRZSmNuUnN1VVlqNThJVlJnNVE2?=
 =?utf-8?B?U04vN3Z1OThPTW9ZUGkrZzJmdXMyM0lkR2swaWNxQzNpS1loa0RUKzhUTDlx?=
 =?utf-8?B?eDZpbDN1UnJzMmRLdy9tckw4NkszQkVpdzV1KzVEYUkrQkpoUVlFc0xicXM1?=
 =?utf-8?B?NjE3RWlnZC8vYnJ2WjJJbWVhTXBPamNFemxpSC83TWdiUC83NEN2UXh1Q3cr?=
 =?utf-8?B?N2FlaDg0UkpzT1I5dkpRT25pVlJ1Qm15ZHRjaW9JQWdpcDBKREQ3U2tiVlhw?=
 =?utf-8?B?NXBBMGg5TDgvRUNETnlDRG5zRkdOMVpmZSt0dEkyajFTYXVqaVZxc3BMQzlB?=
 =?utf-8?B?OXFGVUsvQmIyaDh6Mi9HTFVwME1ScGxSUTRUMzh6RHFpRGs4Zm9DQW1POFFl?=
 =?utf-8?B?N0JmTmhHM1dlQzNxYzh0TlhFWlFDNGdHY3UrUHkrNlhVcFE1b3Nib0dZeE9V?=
 =?utf-8?B?UEZSS2hoVU9XZmpHWG9OUTlsTEJNODRSWHVHVEN3QkRycDNwVTdOdThVbHVz?=
 =?utf-8?B?NjRNOEpmZjMveXROY2llcDBJTFJ6azltc29DNmtjWjJQaE9xeWRVRlJpZ3hE?=
 =?utf-8?B?cDgvb2VBNmN4aUovc0xGa1NPWEZKRG5Fd2VNZklNN2hVUzNISXdGSnAzRlBB?=
 =?utf-8?B?bkhsODJWaGhoVXQ5RURVc29yTmJMVzAxNStCUjRyWHFpMlJPbDg1UEtaNk5D?=
 =?utf-8?B?WEQ5YzFJYm4wcHl5aHFvNzFyb2NjV0RrMHlKTEtwTk5CdGRXYTMyeUl4UHM1?=
 =?utf-8?B?TlU5K2QvWXgybWp1UWYxakpORCtON1NkYldVNDJrRlVIVW45TnhmRGcxVFla?=
 =?utf-8?B?MitJYVdhQmNJUzFIanhpL3BwVFBSbitBcGUwRzFsaCtWaDRrZzNCdjJRU0xh?=
 =?utf-8?B?VUpoYWM1dWdLSGx6ZTNhQUlZSENxQ3Y1WXlhL0wvLzR2bCtvUnVIcFZnejU0?=
 =?utf-8?B?eVdodEdCSTNIMkwyYlZCdloxSHBpRy9qSHdpd2JjMnBKelFpTEtEMTlMcmZn?=
 =?utf-8?B?Tlo1SXVCanNKd0luZ01taHgzcjVxSDhvV0V4Y1ExSFYzaTNNejZleG9YSllT?=
 =?utf-8?B?UVhmZFR4QXc0dmpCaU83MDRCYThzTis3RUdiTDNHUmt2aUV6V0lYNGxDZXc4?=
 =?utf-8?Q?Vi59m8jb4WjLeX81wcBW+eE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F1D84EC114A59E4C8C983024C5D6959F@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b6e0a44-0b7b-46ac-3123-08d9be8d307d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 23:06:26.1090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jun1+3/zE2X9LOxhNFnW6S2dM14gY7wqH6zFsfYg9f0N5xPX0YqANiw83UycxEVnMIbSZWqdOeiRHciPtYFWPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3302
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEyLTA4IGF0IDE2OjE3ICswMjAwLCBTaGF5IERyb3J5IHdyb3RlOg0KPiBU
aGlzIHNlcmllcyBwcm92aWRlcyBrbm9icyB3aGljaCB3aWxsIGVuYWJsZSB1c2VycyB0bw0KPiBt
aW5pbWl6ZSBtZW1vcnkgY29uc3VtcHRpb24gb2YgbWx4NSBGdW5jdGlvbnMgKFBGL1ZGL1NGKS4N
Cj4gbWx4NSBleHBvc2VzIHR3byBuZXcgZ2VuZXJpYyBkZXZsaW5rIHBhcmFtcyBmb3IgRVEgc2l6
ZQ0KPiBjb25maWd1cmF0aW9uIGFuZCB1c2VzIGRldmxpbmsgZ2VuZXJpYyBwYXJhbSBtYXhfbWFj
cy4NCj4gDQo+IFBhdGNoZXMgc3VtbWFyeToNCj4gwqAtIFBhdGNoLTEgSW50cm9kdWNlIGxvZ19t
YXhfY3VycmVudF91Y19saXN0X3dyX3N1cHBvcnRlZCBiaXQgDQo+IMKgLSBQYXRjaGVzLTItMyBQ
cm92aWRlcyBJL08gRVEgc2l6ZSBwYXJhbSB3aGljaCBlbmFibGVzIHRvIHNhdmUNCj4gwqDCoCB1
cCB0byAxMjhLQi4NCj4gwqAtIFBhdGNoZXMtNC01IFByb3ZpZGVzIGV2ZW50IEVRIHNpemUgcGFy
YW0gd2hpY2ggZW5hYmxlcyB0byBzYXZlDQo+IMKgwqAgdXAgdG8gNTEyS0IuDQo+IMKgLSBQYXRj
aC02IENsYXJpZnkgbWF4X21hY3MgcGFyYW0uDQo+IMKgLSBQYXRjaC03IFByb3ZpZGVzIG1heF9t
YWNzIHBhcmFtIHdoaWNoIGVuYWJsZXMgdG8gc2F2ZSB1cCB0byA3MEtCDQo+IA0KPiBJbiB0b3Rh
bCwgdGhpcyBzZXJpZXMgY2FuIHNhdmUgdXAgdG8gNzAwS0IgcGVyIEZ1bmN0aW9uLg0KPiANCj4g
LS0tDQo+IGNoYW5nZWxvZzoNCj4gdjItPnYzOg0KPiAtIGNoYW5nZSB0eXBlIG9mIEVRIHNpemUg
cGFyYW0gdG8gdTMyIHBlciBKaXJpIHN1Z2dlc3Rpb24uDQo+IC0gc2VwYXJhdGUgaWZjIGNoYW5n
ZXMgdG8gbmV3IHBhdGNoDQo+IHYxLT52MjoNCj4gLSBjb252ZXJ0IGlvX2VxX3NpemUgYW5kIGV2
ZW50X2VxX3NpemUgZnJvbSBkZXZsaW5rX3Jlc291cmNlcyB0bw0KPiDCoCBnZW5lcmljIGRldmxp
bmtfcGFyYW1zDQoNCkpha3ViIGFyZSBvayB3aXRoIHRoaXMgdmVyc2lvbiA/DQpJIHdvdWxkIGxp
a2UgdG8gdGFrZSBpdCB0byBteSB0cmVlcy4NCg0KDQo=
