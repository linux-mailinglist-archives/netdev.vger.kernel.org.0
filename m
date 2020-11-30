Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5BB2C9184
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388731AbgK3Wue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:50:34 -0500
Received: from mx0b-00154904.pphosted.com ([148.163.137.20]:45572 "EHLO
        mx0b-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387853AbgK3Wue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 17:50:34 -0500
Received: from pps.filterd (m0170396.ppops.net [127.0.0.1])
        by mx0b-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMcHhV004314;
        Mon, 30 Nov 2020 17:49:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=A9GOHddH/fHambY9vBgtDvi9QEydr1qsDtB1r/fZygo=;
 b=D3MUbG6ZaOoKCKdZERjM9FUsXMID12pFgrlw46RhzJSwkpexpaHBunJPmtxJcoO83eAq
 4zJUmMBRFl8frNQBQVpbi+shMoACC7Vo/zOOZ2djgYLrLT18DN6GUbuiTIJGvbBD0FuG
 /KBNZ8hGOVXZDarH452y8+bAgxRU4sXaQ5eTyEFadrbok1lQeOKZz4MdBz2mM7oP5meR
 8FfbBe9Talp1q4I2u3QeWia2uto+Gd9sFRZFga8ldSckiDN9yxZLoKG/biF/DTEHSnfi
 2E75PJztew887Qalqfc9XFg7IkGYujXUAyADDjrInPyfK6wjs1mmvh/tQlOelOJ+XFZu hQ== 
Received: from mx0b-00154901.pphosted.com (mx0b-00154901.pphosted.com [67.231.157.37])
        by mx0b-00154904.pphosted.com with ESMTP id 354fjsw78q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 30 Nov 2020 17:49:42 -0500
Received: from pps.filterd (m0134318.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AUMi3ui095884;
        Mon, 30 Nov 2020 17:49:42 -0500
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2057.outbound.protection.outlook.com [104.47.36.57])
        by mx0a-00154901.pphosted.com with ESMTP id 3559sqg2fw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 17:49:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d+E7Gqf183/CInCXLi8Gi6m10exBjSRqe2hS/s2m4DVsi6PLEqDvYv+1fvFMhJr9LRxMFRys/9tsTwo/oSYEpbLBNosibibdVNyY5M5EbijYw7VWLzwziM5/+tNH8GvPJl9pATRprKgJIctuHluG5jguZQTg32cE0tQ8LZ58nK83p0QtJ3jNzxLVWy256jiPT5zZcq2/wUBxRt7pV3A3XxCNv9BWxgLwKSMPwEy18qbakC9Kjp3tvIZYf40Q1XWsyomFwD99i7WMOom/62drn6Gcv1m8cd6KDns27QPImVByDikBysEDRB6ilbnd6HAqRUfmuj6cycqrFbQQ5CynKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9GOHddH/fHambY9vBgtDvi9QEydr1qsDtB1r/fZygo=;
 b=UkbH/4EJyi9Ak+852wwfG8slHmzuQA09uSg6CyCAeWCg0RpqFQUJqv3tYvUkRZAenHfDbDgZHtqAiEZ2Pe07Dx4grsNxaiSn0997luOaAPUqfdyAAhv40M97MuGUf0TuYuKAvT/fvZ2PDYfLgjg0Ff0+CMOok8G1rBbNNDgue7+FFj9lJljdqZ9mRtN1N9Lsg+16Si9izFORBJAnw3SMQqkcnX8WFmJmy5bHr+Z34Yj92fI+6DkPE1wRpL1qvv5HiXAqLI22cp6WLhA3SHz9sst5ytCEpjM3/Q06AXkGKpAutYGE/7qlaAsVNanjb6h4c5p1VQHf/FdTR6euefKFNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A9GOHddH/fHambY9vBgtDvi9QEydr1qsDtB1r/fZygo=;
 b=QwslU88X7paPX9VQviBscVDu2Pzrm4R5o4yfOvodYc26L/zPTGn/9p5sjRJ9oq2ngI+WXSWCS5CHYiUqoTeFk0tDQuPx2QzQL0gbfU2RJiWTn3Id05IqDSc6Xn3V7Rhw65L0tPpVOcT6+EceQkmMuYh0kZnKiVkSZT8lepWDlNU=
Received: from DM6PR19MB2636.namprd19.prod.outlook.com (2603:10b6:5:15f::15)
 by DS7PR19MB4502.namprd19.prod.outlook.com (2603:10b6:5:2c0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Mon, 30 Nov
 2020 22:49:39 +0000
Received: from DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914]) by DM6PR19MB2636.namprd19.prod.outlook.com
 ([fe80::8a8:3eb2:917f:3914%7]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 22:49:39 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@dell.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Stefan Assmann <sassmann@redhat.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        "Shen, Yijun" <Yijun.Shen@dell.com>
Subject: RE: [net-next 2/4] e1000e: Add Dell's Comet Lake systems into s0ix
 heuristics
Thread-Topic: [net-next 2/4] e1000e: Add Dell's Comet Lake systems into s0ix
 heuristics
Thread-Index: AQHWx2BpEVIIDeleQEmslZxM02DwbKnhQjqAgAABWjA=
Date:   Mon, 30 Nov 2020 22:49:39 +0000
Message-ID: <DM6PR19MB263658FAEFC9076787EA4EDEFAF50@DM6PR19MB2636.namprd19.prod.outlook.com>
References: <20201130212907.320677-1-anthony.l.nguyen@intel.com>
 <20201130212907.320677-3-anthony.l.nguyen@intel.com>
 <CAKgT0UfvF5yzpck5V-2QM_7RjFV_UKGEGmgM=xg9L5t5CG5PgQ@mail.gmail.com>
In-Reply-To: <CAKgT0UfvF5yzpck5V-2QM_7RjFV_UKGEGmgM=xg9L5t5CG5PgQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Extended_MSFT_Method=Manual;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_ActionId=20905644-0763-4bdc-b24e-f30aa29258cf;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Name=External Public;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SetDate=2020-11-30T22:49:35.5820833Z;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Owner=Mario_Limonciello@Dell.com;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_SiteId=945c199a-83a2-4e80-9f8c-5a91be5752dd;
 MSIP_Label_17cb76b2-10b8-4fe1-93d4-2202842406cd_Enabled=True
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [76.251.167.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96f1f80c-ac7d-40ae-7d44-08d89582383d
x-ms-traffictypediagnostic: DS7PR19MB4502:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DS7PR19MB4502635196FDF1836367DF0EFAF50@DS7PR19MB4502.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zm4vUxYt5ABJMQr/UP/CKH9pIpl16whsp4n5mmm4zkfPsO8ytVzPJTAmAqHnHIXVHKdK8cvi+B+cr7QgG2GpFXxQ5OxjZjjOlVBZzpmjPdap80gX+dFIFCpsvvcQF8/YgmEtvKDzEBY7XxFJE9oWEQjiMVRkPysvVJxFjEw4QNIwu2odcHR+bh6YU27U+UeWBd3N3sZ6MMlTjaUJXHBfjB4w1vlF67vFPtegnmIAUQFDRjDaCI6zfi13FTyRZMGfEnpEmFRWx0wUBeplMXfdcbeT6rmJ4cb5svFyT6FW34EetFB0XWeC+w9Y5Y8UEdHTPl8ib9ROIQJZWyZBpltpiwNZOqcVjeOvTHja0q8sWfqJXe9j1tAwjYeOmKSk3n0T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR19MB2636.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(39860400002)(366004)(4326008)(55016002)(6506007)(66446008)(64756008)(110136005)(71200400001)(66556008)(66476007)(316002)(786003)(9686003)(54906003)(83380400001)(26005)(66946007)(107886003)(76116006)(2906002)(53546011)(86362001)(52536014)(7696005)(478600001)(8676002)(8936002)(5660300002)(33656002)(186003)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eFBHejdTVERDWE9uRDZ2Q2dYVDROSW5kOWoySVVMbGh6U2Znd05UOXVwTjhB?=
 =?utf-8?B?VTFsRUFqTEtYaUlxYkJsYjBidkYyMEo1M01YYnM0cXNpMFZLdTRHMnVmZEhJ?=
 =?utf-8?B?ckVhakhuSVpORUE4dlBNUlpLNWZyVHc0UFlIUnVhUXZnSHZET0xYdEM5dUUr?=
 =?utf-8?B?Uyt6YmxsZjYwT1g0dU5mR25MMkU3VzlxbDdIMEJIUDBjZ3lWZUF2RlMyQkpS?=
 =?utf-8?B?aitxRTd4WGF0Zm4yL28vUkczbWVrd3F5RUNMazlLYVhGVEZUZHR4cGFtd3Ra?=
 =?utf-8?B?VUVuWEgwTXBtSzVBZFluRjUra2xoWTZqdUdaWDE0Z3N6UExmdnF0MEc4cm1Y?=
 =?utf-8?B?aDA2UUlXUkZPTE5FNllzS2FUYUp2dkJCQU5HOWtPMTdrL2Z1c1Rybm9jUGdX?=
 =?utf-8?B?TnIyeU5mc25xVVNZVVdtS1pha2pEZDNyWElXQmFZVUJGUmVXa3Ftcm9iOUx5?=
 =?utf-8?B?OWlYQURKU01sdnZYT1lIODdLVUdjeUJDOWZyNXNZM2ZET3hvNThaZ3I2UUtK?=
 =?utf-8?B?TlgrMGppQis2RGlHWmp0NU1lUG9walIrdFY2cnVGNnFkZnByTXozRmRqT2Iy?=
 =?utf-8?B?UUM1VDQ1TVp1MGRBUjBKamw0UkZySmhkYnJZcGptNU9na29FTkxsMWF0VEhH?=
 =?utf-8?B?MDBsUXYrK2R1MG1lT2FMQ2ZvMk1kNzJoN2N4a01tdG5YY1NGQnVXdFU0TDJ0?=
 =?utf-8?B?QVlIZXBlemJSZTdteDV4YXJMdWEwUkhGV1FlUlcrWVhBeGJ1b2VzeFJvU2d1?=
 =?utf-8?B?OXp2K1FBajMyZng5RHJ2MlY3SmxRUzUwd2ZBVWNjSnQ2cEh0REl0ZEpzMFVW?=
 =?utf-8?B?ZVhkNzhnVWxNbVlndm5RT2FDM1dmS3Y0a2Rua0d6TTkyeXk3L01jbFFPMVJ6?=
 =?utf-8?B?Ui9RcWZJSStPVnhFdThQb29Hejh1T2xDU0s1OS9wbUxTenVuYzRScXJwVFVt?=
 =?utf-8?B?c0RIbUhWN25malJCMHdzenNnYU53VElqTm12UFVhTmR6QXFabDJCSG5aSDFy?=
 =?utf-8?B?eW9QWFpIcnMzNEc4bCtndmNWUlNlN2hpVFZxLzAxaHRlb050MGhBdTJDYUkw?=
 =?utf-8?B?eWJyUlVXM25weHcxZmVqcUFLRVlPZzJkUHEyempxMkFqSm9tNGREMmQ1Q3U1?=
 =?utf-8?B?U2ZuZ0ZQQzJsdVBDRU9SazArTzlHdklwUU56WG1xeE5Nc2hTNm1xMk9UWjJx?=
 =?utf-8?B?RDYxdURRTGdXTGwrWnlkRGRqY1UxNDJIRE5rbVdtbWlMVFF2a3I0bmlYdld0?=
 =?utf-8?B?ektTOC9Zb1JYYlF6MEZEYm5EckwrMjM0dTNXNDQxeDFIQmdBOFBzWC9uRU1C?=
 =?utf-8?Q?c3aznid3EueyM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR19MB2636.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96f1f80c-ac7d-40ae-7d44-08d89582383d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 22:49:39.3117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xv4CAQscR8WC533ZCLDKx6pvb5rzNUeheHiBvAxSnETsc+pDCSPZWJPk6eyhLTYGXnx/BwjbIm+eQBgAmdVUcU1gI0cb9YE1h+ThfOp/JwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR19MB4502
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 adultscore=0 suspectscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300141
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300141
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBNb24sIE5vdiAzMCwgMjAyMCBhdCAxOjMyIFBNIFRvbnkgTmd1eWVuIDxhbnRob255Lmwu
bmd1eWVuQGludGVsLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBNYXJpbyBMaW1vbmNp
ZWxsbyA8bWFyaW8ubGltb25jaWVsbG9AZGVsbC5jb20+DQo+ID4NCj4gPiBEZWxsJ3MgQ29tZXQg
TGFrZSBMYXRpdHVkZSBhbmQgUHJlY2lzaW9uIHN5c3RlbXMgY29udGFpbmluZyBpMjE5TE0gYXJl
DQo+ID4gcHJvcGVybHkgY29uZmlndXJlZCBhbmQgc2hvdWxkIHVzZSB0aGUgczBpeCBmbG93cy4N
Cj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IE1hcmlvIExpbW9uY2llbGxvIDxtYXJpby5saW1vbmNp
ZWxsb0BkZWxsLmNvbT4NCj4gPiBUZXN0ZWQtYnk6IFlpanVuIFNoZW4gPFlpanVuLnNoZW5AZGVs
bC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogVG9ueSBOZ3V5ZW4gPGFudGhvbnkubC5uZ3V5ZW5A
aW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9LY29u
ZmlnICAgICAgICB8ICAxICsNCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBl
L3BhcmFtLmMgfCA4MCArKysrKysrKysrKysrKysrKysrKysrLQ0KPiA+ICAyIGZpbGVzIGNoYW5n
ZWQsIDgwIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9LY29uZmlnDQo+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvS2NvbmZpZw0KPiA+IGluZGV4IDVhYTg2MzE4ZWQzZS4uMjgwYWY0N2Q3NGQy
IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL0tjb25maWcNCj4g
PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9LY29uZmlnDQo+ID4gQEAgLTU4LDYg
KzU4LDcgQEAgY29uZmlnIEUxMDAwDQo+ID4gIGNvbmZpZyBFMTAwMEUNCj4gPiAgICAgICAgIHRy
aXN0YXRlICJJbnRlbChSKSBQUk8vMTAwMCBQQ0ktRXhwcmVzcyBHaWdhYml0IEV0aGVybmV0IHN1
cHBvcnQiDQo+ID4gICAgICAgICBkZXBlbmRzIG9uIFBDSSAmJiAoIVNQQVJDMzIgfHwgQlJPS0VO
KQ0KPiA+ICsgICAgICAgZGVwZW5kcyBvbiBETUkNCj4gPiAgICAgICAgIHNlbGVjdCBDUkMzMg0K
PiA+ICAgICAgICAgaW1wbHkgUFRQXzE1ODhfQ0xPQ0sNCj4gPiAgICAgICAgIGhlbHANCj4gDQo+
IElzIERNSSB0aGUgb25seSB3YXkgd2UgY2FuIGlkZW50aWZ5IHN5c3RlbXMgdGhhdCB3YW50IHRv
IGVuYWJsZSBTMGl4DQo+IHN0YXRlcz8gSSdtIGp1c3Qgd29uZGVyaW5nIGlmIHdlIGNvdWxkIGlk
ZW50aWZ5IHRoZXNlIHBhcnRzIHVzaW5nIGEgNA0KPiB0dXBsZSBkZXZpY2UgSUQgb3IgaWYgdGhl
IERNSSBJRCBpcyB0aGUgb25seSB3YXkgd2UgY2FuIGRvIHRoaXM/DQoNCkknbGwgaGF2ZSB0byBj
aGVjayBpZiB0aGUgUENJIHN1c2JzeXN0ZW0gdmVuZG9yIElEIGlzIHNldCBvbiB0aGlzIGRldmlj
ZS4NClRoYXQncyB0aGUgb25seSBvdGhlciB0aGluZyB0aGF0IGNvbWVzIHRvIG1pbmQgZm9yIG1l
Lg0KDQo+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAw
MGUvcGFyYW0uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2UxMDAwZS9wYXJhbS5j
DQo+ID4gaW5kZXggNTYzMTZiNzk3NTIxLi5kMDVmNTUyMDE1NDEgMTAwNjQ0DQo+ID4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL3BhcmFtLmMNCj4gPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvcGFyYW0uYw0KPiA+IEBAIC0xLDYgKzEsNyBA
QA0KPiA+ICAvLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMA0KPiA+ICAvKiBDb3B5
cmlnaHQoYykgMTk5OSAtIDIwMTggSW50ZWwgQ29ycG9yYXRpb24uICovDQo+ID4NCj4gPiArI2lu
Y2x1ZGUgPGxpbnV4L2RtaS5oPg0KPiA+ICAjaW5jbHVkZSA8bGludXgvbmV0ZGV2aWNlLmg+DQo+
ID4gICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3BjaS5o
Pg0KPiA+IEBAIC0yMDEsNiArMjAyLDgwIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZTEwMDBlX21l
X3N1cHBvcnRlZCBtZV9zdXBwb3J0ZWRbXQ0KPiA9IHsNCj4gPiAgICAgICAgIHswfQ0KPiA+ICB9
Ow0KPiA+DQo+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCBzMGl4X3N1cHBv
cnRlZF9zeXN0ZW1zW10gPSB7DQo+ID4gKyAgICAgICB7DQo+ID4gKyAgICAgICAgICAgICAgIC8q
IERlbGwgTGF0aXR1ZGUgNTMxMCAqLw0KPiA+ICsgICAgICAgICAgICAgICAubWF0Y2hlcyA9IHsN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgICBETUlfTUFUQ0goRE1JX1NZU19WRU5ET1IsICJE
ZWxsIEluYy4iKSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBETUlfTUFUQ0goRE1JX1BS
T0RVQ1RfU0tVLCAiMDk5RiIpLA0KPiA+ICsgICAgICAgICAgICAgICB9LA0KPiA+ICsgICAgICAg
fSwNCj4gPiArICAgICAgIHsNCj4gPiArICAgICAgICAgICAgICAgLyogRGVsbCBMYXRpdHVkZSA1
NDEwICovDQo+ID4gKyAgICAgICAgICAgICAgIC5tYXRjaGVzID0gew0KPiA+ICsgICAgICAgICAg
ICAgICAgICAgICAgIERNSV9NQVRDSChETUlfU1lTX1ZFTkRPUiwgIkRlbGwgSW5jLiIpLA0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgIERNSV9NQVRDSChETUlfUFJPRFVDVF9TS1UsICIwOUEw
IiksDQo+ID4gKyAgICAgICAgICAgICAgIH0sDQo+ID4gKyAgICAgICB9LA0KPiA+ICsgICAgICAg
ew0KPiA+ICsgICAgICAgICAgICAgICAvKiBEZWxsIExhdGl0dWRlIDU0MTAgKi8NCj4gPiArICAg
ICAgICAgICAgICAgLm1hdGNoZXMgPSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgRE1J
X01BVENIKERNSV9TWVNfVkVORE9SLCAiRGVsbCBJbmMuIiksDQo+ID4gKyAgICAgICAgICAgICAg
ICAgICAgICAgRE1JX01BVENIKERNSV9QUk9EVUNUX1NLVSwgIjA5QzkiKSwNCj4gPiArICAgICAg
ICAgICAgICAgfSwNCj4gPiArICAgICAgIH0sDQo+ID4gKyAgICAgICB7DQo+ID4gKyAgICAgICAg
ICAgICAgIC8qIERlbGwgTGF0aXR1ZGUgNTUxMCAqLw0KPiA+ICsgICAgICAgICAgICAgICAubWF0
Y2hlcyA9IHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBETUlfTUFUQ0goRE1JX1NZU19W
RU5ET1IsICJEZWxsIEluYy4iKSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBETUlfTUFU
Q0goRE1JX1BST0RVQ1RfU0tVLCAiMDlBMSIpLA0KPiA+ICsgICAgICAgICAgICAgICB9LA0KPiA+
ICsgICAgICAgfSwNCj4gPiArICAgICAgIHsNCj4gPiArICAgICAgICAgICAgICAgLyogRGVsbCBQ
cmVjaXNpb24gMzU1MCAqLw0KPiA+ICsgICAgICAgICAgICAgICAubWF0Y2hlcyA9IHsNCj4gPiAr
ICAgICAgICAgICAgICAgICAgICAgICBETUlfTUFUQ0goRE1JX1NZU19WRU5ET1IsICJEZWxsIElu
Yy4iKSwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBETUlfTUFUQ0goRE1JX1BST0RVQ1Rf
U0tVLCAiMDlBMiIpLA0KPiA+ICsgICAgICAgICAgICAgICB9LA0KPiA+ICsgICAgICAgfSwNCj4g
PiArICAgICAgIHsNCj4gPiArICAgICAgICAgICAgICAgLyogRGVsbCBMYXRpdHVkZSA1NDExICov
DQo+ID4gKyAgICAgICAgICAgICAgIC5tYXRjaGVzID0gew0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgIERNSV9NQVRDSChETUlfU1lTX1ZFTkRPUiwgIkRlbGwgSW5jLiIpLA0KPiA+ICsgICAg
ICAgICAgICAgICAgICAgICAgIERNSV9NQVRDSChETUlfUFJPRFVDVF9TS1UsICIwOUMwIiksDQo+
ID4gKyAgICAgICAgICAgICAgIH0sDQo+ID4gKyAgICAgICB9LA0KPiA+ICsgICAgICAgew0KPiA+
ICsgICAgICAgICAgICAgICAvKiBEZWxsIExhdGl0dWRlIDU1MTEgKi8NCj4gPiArICAgICAgICAg
ICAgICAgLm1hdGNoZXMgPSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgRE1JX01BVENI
KERNSV9TWVNfVkVORE9SLCAiRGVsbCBJbmMuIiksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgRE1JX01BVENIKERNSV9QUk9EVUNUX1NLVSwgIjA5QzEiKSwNCj4gPiArICAgICAgICAgICAg
ICAgfSwNCj4gPiArICAgICAgIH0sDQo+ID4gKyAgICAgICB7DQo+ID4gKyAgICAgICAgICAgICAg
IC8qIERlbGwgUHJlY2lzaW9uIDM1NTEgKi8NCj4gPiArICAgICAgICAgICAgICAgLm1hdGNoZXMg
PSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgRE1JX01BVENIKERNSV9TWVNfVkVORE9S
LCAiRGVsbCBJbmMuIiksDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgRE1JX01BVENIKERN
SV9QUk9EVUNUX1NLVSwgIjA5QzIiKSwNCj4gPiArICAgICAgICAgICAgICAgfSwNCj4gPiArICAg
ICAgIH0sDQo+ID4gKyAgICAgICB7DQo+ID4gKyAgICAgICAgICAgICAgIC8qIERlbGwgUHJlY2lz
aW9uIDc1NTAgKi8NCj4gPiArICAgICAgICAgICAgICAgLm1hdGNoZXMgPSB7DQo+ID4gKyAgICAg
ICAgICAgICAgICAgICAgICAgRE1JX01BVENIKERNSV9TWVNfVkVORE9SLCAiRGVsbCBJbmMuIiks
DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgRE1JX01BVENIKERNSV9QUk9EVUNUX1NLVSwg
IjA5QzMiKSwNCj4gPiArICAgICAgICAgICAgICAgfSwNCj4gPiArICAgICAgIH0sDQo+ID4gKyAg
ICAgICB7DQo+ID4gKyAgICAgICAgICAgICAgIC8qIERlbGwgUHJlY2lzaW9uIDc3NTAgKi8NCj4g
PiArICAgICAgICAgICAgICAgLm1hdGNoZXMgPSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAg
ICAgRE1JX01BVENIKERNSV9TWVNfVkVORE9SLCAiRGVsbCBJbmMuIiksDQo+ID4gKyAgICAgICAg
ICAgICAgICAgICAgICAgRE1JX01BVENIKERNSV9QUk9EVUNUX1NLVSwgIjA5QzQiKSwNCj4gPiAr
ICAgICAgICAgICAgICAgfSwNCj4gPiArICAgICAgIH0sDQo+ID4gKyAgICAgICB7IH0NCj4gPiAr
fTsNCj4gPiArDQo+IA0KPiBTbyB3aGljaCAicHJvZHVjdCIgYXJlIHdlIHZlcmlmeWluZyBoZXJl
PyBBcmUgdGhlc2UgU0tVIHZhbHVlcyBmb3IgdGhlDQo+IHBsYXRmb3JtIG9yIGZvciB0aGUgTklD
PyBKdXN0IHdvbmRlcmluZyBpZiB0aGlzIGlzIHNvbWV0aGluZyB3ZSBjb3VsZA0KPiByZXRyaWV2
ZSB2aWEgUENJIGFzIEkgbWVudGlvbmVkIG9yIGlmIHRoaXMgaXMgc29tZXRoaW5nIHRoYXQgY2Fu
IG9ubHkNCj4gYmUgcmV0cmlldmVkIHZpYSBETUkuDQoNClRoZXNlIGFyZSBmb3IgdGhlIHBsYXRm
b3JtLiAgVGhlIHBsYXRmb3JtIG5lZWRzIHRvIGJlIHByb3Blcmx5IGNvbmZpZ3VyZWQNCmZvciBk
b2luZyBzMGl4IGZsb3dzLg0KDQo+IA0KPiA+ICBzdGF0aWMgYm9vbCBlMTAwMGVfY2hlY2tfbWUo
dTE2IGRldmljZV9pZCkNCj4gPiAgew0KPiA+ICAgICAgICAgc3RydWN0IGUxMDAwZV9tZV9zdXBw
b3J0ZWQgKmlkOw0KPiA+IEBAIC01OTksOCArNjc0LDExIEBAIHZvaWQgZTEwMDBlX2NoZWNrX29w
dGlvbnMoc3RydWN0IGUxMDAwX2FkYXB0ZXINCj4gKmFkYXB0ZXIpDQo+ID4gICAgICAgICAgICAg
ICAgIH0NCj4gPg0KPiA+ICAgICAgICAgICAgICAgICBpZiAoZW5hYmxlZCA9PSBTMElYX0hFVVJJ
U1RJQ1MpIHsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAvKiBjaGVjayBmb3IgYWxsb3ds
aXN0IG9mIHN5c3RlbXMgKi8NCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBpZiAoZG1pX2No
ZWNrX3N5c3RlbShzMGl4X3N1cHBvcnRlZF9zeXN0ZW1zKSkNCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGVuYWJsZWQgPSBTMElYX0ZPUkNFX09OOw0KPiA+ICAgICAgICAgICAg
ICAgICAgICAgICAgIC8qIGRlZmF1bHQgdG8gb2ZmIGZvciBNRSBjb25maWd1cmF0aW9ucyAqLw0K
PiA+IC0gICAgICAgICAgICAgICAgICAgICAgIGlmIChlMTAwMGVfY2hlY2tfbWUoaHctPmFkYXB0
ZXItPnBkZXYtPmRldmljZSkpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZWxzZSBpZiAo
ZTEwMDBlX2NoZWNrX21lKGh3LT5hZGFwdGVyLT5wZGV2LT5kZXZpY2UpKQ0KPiA+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgZW5hYmxlZCA9IFMwSVhfRk9SQ0VfT0ZGOw0KPiA+ICAg
ICAgICAgICAgICAgICB9DQo+ID4NCj4gDQo+IElzIHRoZXJlIHJlYWxseSBhIG5lZWQgdG8gc2V0
IGl0IHRvIFNPSVhfRk9SQ0VfT04gd2hlbiB0aGUgaWYNCj4gc3RhdGVtZW50IGJlbG93IHRoaXMg
c2VjdGlvbiB3aWxsIGVzc2VudGlhbGx5IHRyZWF0IGl0IGFzIHRob3VnaCBpdCBpcw0KPiBzZXQg
dGhhdCB3YXkgYW55d2F5PyBTZWVtcyBsaWtlIHdlIG9ubHkgcmVhbGx5IG5lZWQgdG8ganVzdCBk
byBhDQo+ICghZG1pX2NoZWNrX3N5c3RlbSgpICYmIGUxMDAwZV9jaGVja19tZSgpKSBpbiB0aGUg
Y29kZSBibG9jayB0aGF0IGlzDQo+IHNldHRpbmcgU09JWF9GT1JDRV9PRkYgcmF0aGVyIHRoYW4g
Ym90aGVyaW5nIHRvIGV2ZW4gc2V0IGVuYWJsZWQgdG8NCj4gU09JWF9GT1JDRV9PTi4NCg0KWWVz
IHRoZXJlIGFyZSBwb3NzaWJsZSBsb2dpYyBvcHRpbWl6YXRpb25zLCBidXQgSSB3YW50ZWQgdG8g
bWFrZSBpdCB2ZXJ5DQpleHBsaWNpdCB3aGF0IHdhcyBoYXBwZW5pbmcgc28gdGhhdCB3aGVuIG5l
dyBoZXVyaXN0aWNzIGdldCBhZGRlZCBsYXRlciBpdA0KbWFrZXMgc2Vuc2UuDQoNCg==
