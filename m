Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312A3458828
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 03:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhKVCzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 21:55:37 -0500
Received: from mail-mw2nam08on2054.outbound.protection.outlook.com ([40.107.101.54]:6656
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230434AbhKVCzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Nov 2021 21:55:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HCZG/M1SxZv0ctmmoCZqFxbMiwycpG2g4xZ/rotbbgvYJGF6zVVWoRTnmgJ6G9tmtZSy1dFkjYRQ86nwnGutmk5xvlNHnCgtva5VFo2s1egXRgSPRc8FLObXZM11nrXAOWu3a9pPTfpAZf+cvd8LLkDaHm703X2TO7tLq26uw3DEsaKOfdo27VdP+ZwTT4D4TiqRn4VmVjM6H1eIIZ08Ak6bjirsdtns/0pNsIpSLHQhnEw7hA6MZbz07X9TFjrcQ97rTgbLIagLKcbia3aZsyeYOjKLKUvQf20RgzaHgD3QTChpRYPH++uR70oo31wdqaKIK0lUTpceqay1nRhKwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCcWtzfnPWWQwm6XL/ux/F6pU/25jFji7xRI4092YK8=;
 b=SPnYzL4Gv8wykZs2YGCggNmYNNUYdWmvG9KEEaUBynb+vVIo4luh56kWfTarsNCOAryOAKAxCfeUY1/0qqU2Y8mk4C4emBmrAxJVSR8xjKVlIub9x0iekIKurjTw8POaPTPDcO0urH3JV4xW/UAKd2Jq7O/IXw/ovcsckiwLjSa+VFL92oDE9d6EEdlRS5yQ5Gyh1nxUvbTBd748jKvAE72pPhCpRkv7U8E4Bbjsp6v1He5OhBxpPZk9IXL3LoBLyfnpwHHskgpwBcaMLzKffIxlsAj9r1iOblsLrV3+goD7JihzKIs9J/ro767m8DgJbgMV3utmCYHjW5r/85AJSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCcWtzfnPWWQwm6XL/ux/F6pU/25jFji7xRI4092YK8=;
 b=udcQILF+ydOneHTwpsbDMGFk6iWuHn7fqJ9pYdrIcCzP2djqvOi6Dec1Ahs8m2D4hNuLAEMuoRk6WuE0IW7BpSikbZlCAXzbEC7uhzHtNUq7gjk7Vjxp3DVwGM7ZZvjGVSczwSX2jwTUvwqs2tLKeB69r37+dbcM8WC/jz5rDtAQAmHdagnbrwyQrRfr88+FjIpdC6uYor2b7utcgrY++pnCuWjVo64PzgUgWTFSzk+ArALooyoAXGP7L3fIwG2l0yLcMA3aWSRekuQafl7qAASxfSSFwssgvnpjuGzAUW44JDEfYuCLf7/nYA+7DF2P38eBoSB0JzL2Ii1xBVLWow==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5498.namprd12.prod.outlook.com (2603:10b6:510:d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Mon, 22 Nov
 2021 02:52:30 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::5515:f45e:56f5:b35a%3]) with mapi id 15.20.4713.022; Mon, 22 Nov 2021
 02:52:30 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "patchwork-bot+netdevbpf@kernel.org" 
        <patchwork-bot+netdevbpf@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH iproute2] vdpa: align uapi headers
Thread-Topic: [PATCH iproute2] vdpa: align uapi headers
Thread-Index: AQHX3KYeo+q44itHa0+iVFz0BpQheKwJlb0AgAVIghA=
Date:   Mon, 22 Nov 2021 02:52:29 +0000
Message-ID: <PH0PR12MB54816468137C264E45CCE9C6DC9F9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20211118180000.30627-1-stephen@networkplumber.org>
 <163725900883.587.15945763914190641822.git-patchwork-notify@kernel.org>
In-Reply-To: <163725900883.587.15945763914190641822.git-patchwork-notify@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df174229-0505-4318-876d-08d9ad63200c
x-ms-traffictypediagnostic: PH0PR12MB5498:
x-microsoft-antispam-prvs: <PH0PR12MB5498BFE354E264351DAD7159DC9F9@PH0PR12MB5498.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:163;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ACyDFzeHve9orm80OBLVzdEYE32Aoa4ycGHVGisZp00GyUe9Tdgl47vmfTvX4icrU4ElYdYsVc7tis4BOFjbT3QZ0DpVLGVBe+mS27s1+XCqzwyUBvkE0Aek6FDETdoJLw3drZWcBu8qiroULT4f+GQJmfrYdFwGtKDQuSuFmtJwTsUAd3fQZRBWTvv1FL3iVzGllhmP/0D1tqSKbXAo/uEdK88Zboa06lKYiToHyZx+fUv/v6TQka4TL9gJxiG8k/99rD5abuZyPrs6k2vc906sUjRbxBPMtlh2i+b45Oy7yHZHsV05bVo5tOOx4AQNh82K7vc2yR4NO+tRUitM2S8sNaVzIb8NB+/k7THNm3Uh3syCLFhxCHz2X91WG3vxMf43VrEvFl9Wr0diEWP6LEVhSuDgTIw9o9j0rmza5pUH8J9MBzp9aCjzAfZFIySRgdRk0XvKvAkHscD9eowkNyQE3TIdLKqpE48bqr50Lou/fIUpdEHejDrsFmFv2DarbfEfkpp1JpiVUn65T8y9PMGEQ9MvlOPaEi8hmJpbS+cxMCaxjZFiEgxFW1zhtEhVNuAnbPIzo0MBVcblPRp2bdp8kx7x9OI8k9ReNXlCdK96NBkFuIbvNjkLBr8aGismyvt6dw/dqKOlBxOrQ3uwgvEm7SbKDvfArQszcg9Tm+HEDkvxDG/IjOONmi1xFk3hnYpk8isoYlBeyZhYVvwfYs0WcUHF4lOTKsXSnDtv6L1wGW0ApVEr/xaTKRjSu5gpZwNO9SiohYGxF4PL3X/VPFl4IQ315Qx7Li1O//NMFM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(33656002)(966005)(110136005)(8676002)(316002)(38070700005)(52536014)(9686003)(508600001)(55016002)(66946007)(5660300002)(66476007)(71200400001)(83380400001)(7696005)(6506007)(4326008)(122000001)(66556008)(2906002)(26005)(186003)(4744005)(86362001)(8936002)(64756008)(55236004)(38100700002)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3FhYlVTcnByVlZISm1YbHE4V2FDWlE0QU5VWUtaV2libjh4dUxYNUhrcnZ3?=
 =?utf-8?B?OE1zZDFOK3lWTlRkMVBqL2g5alhWS05iTzhuazJtMkh3T0F0T1ZtSGVzTE1p?=
 =?utf-8?B?dzhiOE4zWWo3N2FnVnM1aXYycGZucmFZaFdRK3ZPRWZoSFlXSXZKYjMvcjJR?=
 =?utf-8?B?VElNbHFmbHBuc3ZLRzB6NEo4dzIzWnk3MnAzaWtqc2x0L0RwL0VIdTRWeVU1?=
 =?utf-8?B?a1pXaUFJRlRHTEJOZTdyUGM4UGh4bmdRRnZoMXdsTmJEZHByN2VOaStLZHhl?=
 =?utf-8?B?L0hVK1BoVXNTM2lDTjdGY3laR0tBcitHamFkVy96SmxIamVkcXFVTi81UEdN?=
 =?utf-8?B?dG94aUZnRTAzM0VPWjVMUnRDNWNMN1d6eEFZSkdWcDRKbHpFOWpnUGl2Zk1Q?=
 =?utf-8?B?b2tTK0x2ZUl3TzRFdkpYeGIveGszSG5QU0xjR3F2QXA1OEgxdzB1TVhxUVZQ?=
 =?utf-8?B?dlhjSjNSb3NJUEV2WnJYNkQwN29LQW9CZ0M1VXhveFNRa09wbXNPYUJsNkVa?=
 =?utf-8?B?RGpRN3lsZ3FiNW5mVkdWNGlCTEZqcjA3c2N0dnlIampndThwUmQvcUdHeVBQ?=
 =?utf-8?B?VWdVTUtLR3JURVNPVkswcm1ubGVjMUNjOVhqSXhFa0hrMTM2eTRFZXZpbERp?=
 =?utf-8?B?ZktkV2cvTGs2MGN4NHFNRDhKdmZCVFZqeERuTDRFWE52N2xLaENkM2NCOVNV?=
 =?utf-8?B?YzJzUFN4TWY1K0MxUzR2Q1dOOW5OWkh4RTVYNmJwcThOWUtrdG83cldtTjU4?=
 =?utf-8?B?dHJwaGMvTnVGZ3lkeGhrQ3FQNlNsWUtvNVFTOVMwNEZCMGtFb1VsQmFXbk1C?=
 =?utf-8?B?SnpQa0RPMjdTQzVpdDRvN2Q1dVhXT0NRSDBscjJnQ1FrQkNTUC85YW52cHQz?=
 =?utf-8?B?WmhkMGpFeWRJdHZCek1YdTFjRndBNE45SGYwNyt4cW9SWWJPckxIYmxxZkNk?=
 =?utf-8?B?RjJaV1RoZEp6YytKNHBVeXBzSSszVXpBU2lsS3VxeVR3SUZsd2w0em5PYjRD?=
 =?utf-8?B?UjVtSVRHYkZ5ZGpDNUIrejFnTmtDMmo3bWszRDJaMG5tSzc4enRNL0xvK05k?=
 =?utf-8?B?UnJ0a3BkMDhCOFpsMVZOUmp6WHFlRzJhcmRHc2hjU2VZdjFhcEkyL1poZVV4?=
 =?utf-8?B?dmJXWkRwb2pxbjB5VTM5cmZvVVU4RUZ4bHNsN2FnR3lHY3o1Y285SnRxRDZO?=
 =?utf-8?B?VGs5djNxdlNwV3V5cHN6MjV1S1RXOGJodG04bENJS3pxc01CeUNBSHFuY1gz?=
 =?utf-8?B?QnNZREdBdUF1OUx6NW5RTnRoVllpR1BFblFXZ1F1NXU4eVJaOU5mMUpjY3RT?=
 =?utf-8?B?MGZOMTI0ZVVmRmFDV2ZzZHVzemh2eHZkMjZqVVVncy9KVDFQcEIxZ0hqdTNn?=
 =?utf-8?B?a1plNy9zMElLUnhpVGJUUnI3K2htdE9PSlI4TmRwR2RubFNwWGxJWUJUTGNY?=
 =?utf-8?B?YTlVSGhMKytpb0lZN2c1UmhhNTZBVGhRV3dWV1JMeUdaTmdVZWdXZ3pSUGNj?=
 =?utf-8?B?UnVVUXRMMlZtbm51UDQ4c2pWS2F2UG4xcHZqRUlZRzA4SGZOU29IM1JWQlNN?=
 =?utf-8?B?RDd0Z0J1VzRMOUdVNFEwTVBPWkpPNk4xRWliTkNtMjdvbFJXcEkyRHYwekY2?=
 =?utf-8?B?T1VuSVZxeUtsMUZrcTRxQWM4T0FFeXd0S0V5aFkrYkc4TTdyZVN1WWZBaE55?=
 =?utf-8?B?TlF3NFNIaGFIYWlKbHl5VDBTcWtPejJMbUVUUFpqMlV6SHRORGR0djdwVTNo?=
 =?utf-8?B?R2NldW1UTm11UnRGaFRqOUxMTkE4WlFJSXFwL3B6Rkl2ZWErME9XREpPV0wz?=
 =?utf-8?B?N2lZRGN3YlgrREhoWmFxM1dXd1ZnK0E2ME9wcUIrOFM0VHJsSk53VWFza2ov?=
 =?utf-8?B?cVFVMUhZb244VzZ1enl0UUNxQWFISnR5RzE5NXlhNlVNaTE5bndSekYrOWlS?=
 =?utf-8?B?THpFRXExTTUxNDBuT01Dd0tPZlltU2R1UGNtWWFLUDNCL2Y5ekxVRDc0R3pW?=
 =?utf-8?B?UVFHSmdBejEwcm5aUlMvZWxYUHBPcFFualE4aHh1RVZrK1dWMWpTTjNxUEJp?=
 =?utf-8?B?dHYydjVmcmM1RWl5dnpKblhLcUZtSUkwVkg5eUhUQ1liek1hcEtvWU0yRzJX?=
 =?utf-8?B?Mm9iZ3RUMk5ZNFA3aDFId21RZnZSUk9qY0F2MDJNRngxNk1tSGhxcHJ2cHhy?=
 =?utf-8?Q?iF7A0+mJakhNRKVSQ57qX6I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df174229-0505-4318-876d-08d9ad63200c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2021 02:52:29.9192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2M382c76i7QroKE2atSgE0g+i72K8iYu4nY3SDCQIYU+8xa/3+GBUDD3RK9PYyMXAnFJznUV0k7ixCVtsP0vjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5498
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogcGF0Y2h3b3JrLWJvdCtuZXRkZXZicGZAa2VybmVsLm9yZyA8cGF0Y2h3b3Jr
LQ0KPiBib3QrbmV0ZGV2YnBmQGtlcm5lbC5vcmc+DQo+IA0KPiBIZWxsbzoNCj4gDQo+IFRoaXMg
cGF0Y2ggd2FzIGFwcGxpZWQgdG8gaXByb3V0ZTIvaXByb3V0ZTIuZ2l0IChtYWluKSBieSBTdGVw
aGVuIEhlbW1pbmdlcg0KPiA8c3RlcGhlbkBuZXR3b3JrcGx1bWJlci5vcmc+Og0KPiANCj4gT24g
VGh1LCAxOCBOb3YgMjAyMSAxMDowMDowMCAtMDgwMCB5b3Ugd3JvdGU6DQo+ID4gVXBkYXRlIHZk
cGEgaGVhZGVycyBiYXNlZCBvbiA1LjE2LjAtcmMxIGFuZCByZW1vdmUgcmVkdW5kYW50IGNvcHku
DQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTdGVwaGVuIEhlbW1pbmdlciA8c3RlcGhlbkBuZXR3
b3JrcGx1bWJlci5vcmc+DQo+ID4gLS0tDQo+ID4gIGluY2x1ZGUvdWFwaS9saW51eC92ZHBhLmgg
ICAgICAgICAgICB8IDQ3IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCg0KVGhpcyB3aWxs
IGNvbmZsaWN0IHdpdGggY29tbWl0IFsxXSBpbiBpcHJvdXRlMi1uZXh0IGJyYW5jaC4NClsxXSBo
dHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbmV0d29yay9pcHJvdXRlMi9pcHJvdXRlMi1u
ZXh0LmdpdC9jb21taXQvP2g9bWFzdGVyJmlkPWEyMTQ1OGZjMzUzMzYxMDhhY2Q0Yjc1YjRkOGUx
ZWY3ZjdlN2Q5YTENCg==
