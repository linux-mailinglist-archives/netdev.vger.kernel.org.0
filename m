Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE1F453B3C
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 21:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhKPUyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 15:54:32 -0500
Received: from mail-bn8nam08on2072.outbound.protection.outlook.com ([40.107.100.72]:29664
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229527AbhKPUya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 15:54:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JTxfVROHp2LnDSbVqzS2SWta81PvCbFMsaB52PPvbWzYagO7MiQ4t9sY+HT1bioM7XOOBpC/LhHAu1/gw5fB1yPD097JAK8R+UCajV4xCY00Vnyu6fBbFydVCpcKiRVPM7bdx4PAOTFgrbhp2Z64SC+rurrnAXE+50jg7KaxAw8O8di0/BXda2lfgplt3eYj5ZEA1Je1BKKbQQXaAFb6OYNmAS3+PCVLCLGk7sK0zfq+EWkKM8boTQoLiH5JcaWLtxvjQjtsWPpH7PgHUm7WQi+tbsij0m3TxhRf7bQEwwtEp+seb+necENVC6l90MUx3AvRkVfv5uiM/+MAArYZ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s9pAocGdv7uXza+vMSQrU+L5gQc7Ndf2cmxXm2U1O9E=;
 b=PR+NDglJYGwiLzRR/DWAweKe21NOuNjVEuAk+fomA34GYPC+o5XNFGyUp/H2OG5lonsiYuKRvCewth+3cFJRtIzX9QTQ3+o0HRnJQik8HGiDl9KRIUa33ixNCMnZecF9buuh/A8MoplS95W9T/VO0eOlYCDKi6evlzWjlF73/uIY5aSDxka2j+/KUMx9W1FuMQdQKidAUStNRA6MLjje7mAgBFKejDBNJV9UjszL5OkrIPQ6uNZa2ypDeXL7ovXNH9yINH3O+gMESyK6xSQS/PIiOSaEHUFjJbOaClZcw/dpqQCzEIOQpHtD5HTP+PiRTmyfIjwaaBLbn0C4fHaXDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9pAocGdv7uXza+vMSQrU+L5gQc7Ndf2cmxXm2U1O9E=;
 b=aKAeg9CADDMqwT1cvO3jH5S+gEav+teef8wU3IDaKKxZWwceepnc9tT6TpPVzQPGOPcyePtP4To8HmpEtXTlzjI33zniX9GkMFSRevRW74fVdiofFT+JRwxLls0yQ9hrgI5wpym5t2zxsXZPY55ae5ODRymopPKCfXgaYGvI3NjyhIQDKs/Iv1FHJxdFKQqVsK8Lv11HOQqkR02BfAGFQ8ZsakC0AJmzcVzvIGllx7h0NMVyIGRnDRLAy6kBHYn2XnVGJdEh4N0a1F6MkAA5Fzq5bo/gNQqBqre4dGg0VklVeRP87amHctTOElfsraAIS/Ox/Y2XoqgIASXwlXtXtw==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3206.namprd12.prod.outlook.com (2603:10b6:a03:130::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 20:51:29 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::b9dc:e444:3941:e034%7]) with mapi id 15.20.4713.019; Tue, 16 Nov 2021
 20:51:29 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>,
        Khalid Manaa <khalidm@nvidia.com>,
        "arnd@kernel.org" <arnd@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>
Subject: Re: [PATCH 2/2] mlx5: fix mlx5i_grp_sw_update_stats() stack usage
Thread-Topic: [PATCH 2/2] mlx5: fix mlx5i_grp_sw_update_stats() stack usage
Thread-Index: AQHX1JFNMjyRIHOIj02dBpFsstGsXqwGrlEA
Date:   Tue, 16 Nov 2021 20:51:29 +0000
Message-ID: <87789d9ba455d7abc7f083bcd9b10af4671bea7f.camel@nvidia.com>
References: <20211108111040.3748899-1-arnd@kernel.org>
         <20211108111040.3748899-2-arnd@kernel.org>
In-Reply-To: <20211108111040.3748899-2-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 965e647e-7749-43c2-e9e3-08d9a942dd5b
x-ms-traffictypediagnostic: BYAPR12MB3206:
x-microsoft-antispam-prvs: <BYAPR12MB32068E89758EF2D0B30DA207B3999@BYAPR12MB3206.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tT+S9w4ttmTxPnT4q8x3Uf0w6v6OCPeeDIvEi2bwLYhvFVDJRoRkMWQuDW2M27FD5H257mJ6mJFY9L8HLqVHoFWNaewvsz0Y3Kpnm/FYI3xcT4vs41XepIacNa5zciW8IWf5/KdFR3t/sGgBLKUjRfPsJdo0v9rqVcSzWvNN+yoCrg/LR65umvQxdXoGi9xU3QHClka7jS26+sEoJvZah+Lr8/V3Eu8to2EVt5c1dLL5lyBYOSGkPOi0hwvu1Ch2uGiwovEY+7Pku4bNm5YUURL5DapESzRww97CSkl7Z8mMdaeeiKouunKLfC/An0mD+1Dujite19E6Zy18pkoh87krr6jDVk0iIJvriQZaSZIIAy5ITXDosVIKyG6WONQxvLPW/F9wk9VSaSo26EnybUp+7hri8pe7HSJEACOBVrV252S6daiJyJ5xaMhTvbHkgpjU6uoFA/msedtBN4vYssKKs9uCvgL8rFy87kzokRAPB2eDo0wmJuVNohBRX05A/AGS+xCV+33qZm80GLmZDpHr2f7LxuR/CestNGprXXpRD6c3CFZ8pPqLPZdJXcouyAz/QpJJ9INkmxYFcJ/4x6kSrb7aD31VAS799NaYPDOHDnFXDcshNuFL08VPDuEO5lsDd32nJsnFAaEAOflzK7LJSsO12nm61CG1xCzyODH+KNX2Bkz3xpPyYSKW19tJ9HADPnFIrzBMDVOPBg0j8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(36756003)(26005)(4744005)(122000001)(8936002)(38100700002)(8676002)(6512007)(6486002)(186003)(508600001)(6506007)(66476007)(54906003)(66946007)(66446008)(5660300002)(4326008)(64756008)(66556008)(110136005)(38070700005)(2616005)(2906002)(71200400001)(316002)(107886003)(76116006)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S2hvdVVLdGdZRzFuTGQ3QmtvdkpodkRlcUMwR1hOamNhU0pzNkdVTW8vNGla?=
 =?utf-8?B?ZGpiME5qeEN4RzFOY1BuaWxZZWtJbHQrSmx0ajZKSnp0K3NDaGltUDRnaGtM?=
 =?utf-8?B?dUNuNnhFQzZMSngrOFk0VWs5SVdISzRDOUcvVk1nbWdvS0haMTlFa1dzRHRN?=
 =?utf-8?B?SW5FY0NWWCtsKzZQM1IvQ3lQYWQzcXBwSzY3ZmFjVk52S2RGZUpnNnVPQWVo?=
 =?utf-8?B?RGdmUjlnMW80WmUrTUlHSW15QWJ2R0VkM2dLelpVS01IOE45aTJWQ01WMTFZ?=
 =?utf-8?B?eC9kVkpTNUVlOEtuazBqeHpvQVhaZXhZdVlYTXlYUXFSdEFhcjk3Sm9Ka2x6?=
 =?utf-8?B?aWxSL3ZWT2xQeE5nMERkbkJmcnR2QWVXVUp6aC9qZ0NsZmV1YjBHd2pWUDJM?=
 =?utf-8?B?SEdEelZXeW52M1hKTVJPUmZkNkNLNXdlbUpBczJ5a1NUbkt4UmN2bVlmUlB5?=
 =?utf-8?B?MjR1ajBSc3gwYWo1akJ6TDR6MHhiRllLS1VRemFaVXRJMUlXQU5VSWNvVU41?=
 =?utf-8?B?WDFwUWtDTjMvOGZxSjJ2YUVCWnZNRVJ5VnNHRWhUenpjS21OZ2hqZSs0dXNV?=
 =?utf-8?B?Njd5b1ZRSFloaXU2d0Fyeis1dUJXVkEwZm16cFlJbDM5TEtLTTRZRUFXSnpY?=
 =?utf-8?B?VkpYeDc4djJkT1ljUTh6czY0SERUM21ZN0RMak95WGQ3d1QxeFVoNzdnT05L?=
 =?utf-8?B?OGRIZ2pRQUhTekZJZWZ4c09odW4reStUVUZOOWpBekwyRnc4L0R5eW1RTG93?=
 =?utf-8?B?WFFIcWgrOWRSWTdObmtxUTRtMURyMEhwNm5IQ0p5VmlENFRpNGczUHNkVFBB?=
 =?utf-8?B?QlF1NU5kNHFjVnBTclFybno1VW1CN0R3S1ZoaWcrbWFZak1HRzROeklHNDhI?=
 =?utf-8?B?U1c3N3gyWE1KVEVDVllKNnJwbFJ6eU90WUZLbTRIb2RMdGhiVjlPazAxeHEx?=
 =?utf-8?B?eFlGTCs4empiN2NsRVBzODk2Mjl4NGYxTUxTMUp4NElYcm9udEpwR1ZRV3Vr?=
 =?utf-8?B?ME5TVnpDL3BLaVk1OGtodHJJS3J3RTdWd0svNmZlK1VnZHRKb0Q2aW1pQ242?=
 =?utf-8?B?eHNEdktNTnduM0UrblNadW5XMk9nS3E2T2NZWTk3a2daNkYwMS9PMEVXUjhV?=
 =?utf-8?B?L0k2RUFwaEtuSGZwdUNvZ0pCM2c0S2RzSXc1cWJTOGFjaU5XNHBqOVF4ZzVC?=
 =?utf-8?B?Z3o3Ly9NdnQ0YjBabVR4ZE1iWndVUHM1WnN1UE8xOUNlWmVNUm80RmNLOTdS?=
 =?utf-8?B?OElGS0hHVDRPVXpRczg5R3hrUmxpY0NlWEtBSzEzVElSb2N5UGhDOXo0VVBV?=
 =?utf-8?B?TDFRNlFOeDVYaXpxYXM3MmdDWkw3RXpZWGViTUxrNG00ZGt6TUZCWm1kRGQz?=
 =?utf-8?B?YytTZVY3UWQzK0JqZ1VKamZhQmRBZnkrcUt5OE9aRWcrM1ZQQnIvcnkzN1Qr?=
 =?utf-8?B?YnVUa1huVG5ySWRCeThucHJkdTVQTlMrdDd3b0c4dVRiWTJxcE5zdkRKMmdJ?=
 =?utf-8?B?bjZweDFwb2g2MnIrZzB0R0R1UVFnUGVOVkc5WTF6VEVSeHpNSzZjMS9VQXR0?=
 =?utf-8?B?aVByaG5LQUI2azNVWGcxUmRKUW5OSnU0WEFRa0FFUThOY0x2WjRmV1NxVXNF?=
 =?utf-8?B?SytrMFhkUlRFSnFEMkRZMjVVWE5NaHdLYThXUWtJUDRud1h1aXE0aHo4TUMy?=
 =?utf-8?B?eC8zT0lSeG1vRFdDdlpZT3VRSUU0MzZOK25odWJsZzlhamtDb0h1dlVGSC9p?=
 =?utf-8?B?QWxuUzFQSC9GcHl5OW8yWnlQN2NVUENIY1J2MjhMUW90MU5PZHBXY2tFQ1B4?=
 =?utf-8?B?OFhkOUtjanZnZ0pzNmtZbnBmYjlEZUZ4QjcxZlM4cHJDUnhWeDZ1cDNSbmY4?=
 =?utf-8?B?Z2daT3N1T2pJSW02M0JEcHpkQkVoTzlCYXUrQVFvcXhkdmVoUW13WEprTDI2?=
 =?utf-8?B?TEJZbjBZZTlSMHZJeEVyV2o4TS9IUUFjclljYk9UREJ5WFBNT0x3ZlFWRWY0?=
 =?utf-8?B?UEtURmZLSGcvek1haEx1S3krcHFIZ1RuUHBMS0VsWXRhUDFtaGhtYUZpVDJ4?=
 =?utf-8?B?TXFiL0lWYW5MR2E3dmx0Z0REM0xwNXVNNHV0R2JJNXU5WEZFSXVLanpvcWxJ?=
 =?utf-8?B?NHNVb2xNamtQNVFWZ1o0Z21SSS9KKzRUclU2ZWNLRExvdFZmSHpZSklqcWQy?=
 =?utf-8?Q?UemVuRqYbAzyA4sLnZgIt+l3UH951TcAvEwO2VjBMdL/?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0587DD25D2B85C48A11277390A2F1294@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 965e647e-7749-43c2-e9e3-08d9a942dd5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 20:51:29.4189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4XPWR/i4LHyXrmwgOyuUqknMbpu3mMGNT6ACtZIVObolTdNHKHoiYrx4HFHMq/PgKjgUUPf+H2RsXFDRpOxHsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTExLTA4IGF0IDEyOjEwICswMTAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBGcm9tOiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiANCj4gVGhlIG1seDVlX3N3
X3N0YXRzIHN0cnVjdHVyZSBoYXMgZ3Jvd24gdG8gdGhlIHBvaW50IG9mIHRyaWdnZXJpbmcNCj4g
YSB3YXJuaW5nIHdoZW4gcHV0IG9uIHRoZSBzdGFjayBvZiBhIGZ1bmN0aW9uOg0KPiANCj4gbWx4
NS9jb3JlL2lwb2liL2lwb2liLmM6IEluIGZ1bmN0aW9uICdtbHg1aV9ncnBfc3dfdXBkYXRlX3N0
YXRzJzoNCj4gbWx4NS9jb3JlL2lwb2liL2lwb2liLmM6MTM2OjE6IGVycm9yOiB0aGUgZnJhbWUg
c2l6ZSBvZiAxMDI4IGJ5dGVzIGlzDQo+IGxhcmdlciB0aGFuIDEwMjQgYnl0ZXMgWy1XZXJyb3I9
ZnJhbWUtbGFyZ2VyLXRoYW49XQ0KPiANCj4gSW4gdGhpcyBjYXNlLCBvbmx5IGZpdmUgb2YgdGhl
IHN0cnVjdHVyZSBtZW1iZXJzIGFyZSBhY3R1YWxseSBzZXQsDQo+IHNvIGl0J3Mgc3VmZmljaWVu
dCB0byBoYXZlIHRob3NlIGFzIHNlcGFyYXRlIGxvY2FsIHZhcmlhYmxlcy4NCj4gQXMgZW5fcmVw
LmMgdXNlcyAnc3RydWN0IHJ0bmxfbGlua19zdGF0czY0JyBmb3IgdGhpcywganVzdCB1c2UNCj4g
dGhlIHNhbWUgb25lIGhlcmUgZm9yIGNvbnNpc3RlbmN5Lg0KPiANCj4gRml4ZXM6IGRlZjA5ZTdi
YmMzZCAoIm5ldC9tbHg1ZTogQWRkIEhXX0dSTyBzdGF0aXN0aWNzIikNCj4gU2lnbmVkLW9mZi1i
eTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gLS0tDQoNClRoYW5rcyBBcm5kLCBC
b3RoIHBhdGNoZXMgYXBwbGllZCB0byBuZXQtbmV4dC1tbHg1LA0KDQpTaW5jZSBJIHdpbGwgYmUg
cXVldWluZyB0aGVtIHVwIGZvciBuZXQtbmV4dCwgSSB3aWxsIGhhdmUgdG8gcmVtb3ZlIHRoZQ0K
Rml4ZXMgdGFncy4NCg0KDQo=
