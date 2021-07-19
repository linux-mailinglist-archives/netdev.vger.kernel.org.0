Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D28C3CCDDD
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 08:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbhGSG2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 02:28:44 -0400
Received: from mail-eopbgr80119.outbound.protection.outlook.com ([40.107.8.119]:14596
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233580AbhGSG2o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 02:28:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiL8X71DXzWScDBhM4cwBFIGZKwyBTcTbU3w/kErGli7/9QnTeocjxQxxNuaytgmx9F/K+TmS+e/7UCgfOq6inqwGTN9pTfXIPXz2D8iRJ0k+yJXneDNQcYdW7p6Vd83/9W3e+Sl3PPasY+FzpU4KTH6di3dv1MDZKbLwFZMEFC/nEp54o/4v1GxcjKBYz0zsdxsL2+4i8EGu7E3hhwC84kjrRtXPRDFDvnjoUy6VcTq4OMyxcm631fh0yyKH4TbVEsQeCBU+6zs8Y9V0Jv1GBAcIoAij0wl8xa4kCCj7Z2mWMDl9z5sxY/59IYmqTOdOS/fB722lDr8s234UZ3jSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dS5a4c2ZKFzE8zL4AeAbXR18mkQsM5YX1LneI7g1I6o=;
 b=mGXvcc/PjPQ0leF2WawZuz7HBVNKKMt8mTlxHHjSxKW/zg2lnjmDuEAvjqfbeMhF7slkpG+8UWHbQMvWao7nj++wxqb1yf9Y6HSuIVa2Az+2Er9Ij6yNIdaIeAcr5fnwhe+/Z+SUfyI/VsHvjOlos6lfNtM4omWVhDprCmrcqZuvv3ayLf4hmFfWd2Fbz6k7kia/9PvYZ9db+hxlUbYtPS6hfy0YPI5vwWVSNnWfRN5zEB9QL4Y4NRnQyMBerzzM0/Nil0DJB+Rz9myS7rfhoWeG3WzY3JJ9Xv0PqUeQB66x1mY6YODIws7W73r1EJQwObZ4sYme/b3woqfo5mdTgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hbkworld.com; dmarc=pass action=none header.from=hbkworld.com;
 dkim=pass header.d=hbkworld.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hbkworld.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dS5a4c2ZKFzE8zL4AeAbXR18mkQsM5YX1LneI7g1I6o=;
 b=SQ4Xdbh1307GFsebQq2MjvC8X/Wg/MkM+hIzoPKjpBBM72JKo7yi25N4yeus93gJdr5mPBxZxF2ai9BhxK35/nhywsYQyqMKHlEfPoIHjWBh1mYkERDcI/CtoqNMeEbn0jKaZOf306JoholGUM/knRLVHTOW3rW3Ir+KeHXlgjaZfeC2O2d0ueskOhHF3CrXo54fWeTe9HeydGOcp/NgoDJXCYy0OonSOsn+6onf2FAuooDx+hVTNuxEfDDbnohkTyFw/IdTlAMA/snN1+TDRoWoRjIL3QqlRhAxRJArmkAydiPNF0hew7glE6qRYBus9Z2K9xQWeqTxvvdnVPug2w==
Received: from AM0PR09MB4276.eurprd09.prod.outlook.com (2603:10a6:20b:166::10)
 by AM0PR09MB2628.eurprd09.prod.outlook.com (2603:10a6:208:d7::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Mon, 19 Jul
 2021 06:25:41 +0000
Received: from AM0PR09MB4276.eurprd09.prod.outlook.com
 ([fe80::4d88:bf9c:b655:7a92]) by AM0PR09MB4276.eurprd09.prod.outlook.com
 ([fe80::4d88:bf9c:b655:7a92%7]) with mapi id 15.20.4331.032; Mon, 19 Jul 2021
 06:25:41 +0000
From:   Ruud Bos <ruud.bos@hbkworld.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net-next 1/4] igb: move SDP config initialization to separate
 function
Thread-Topic: [PATCH net-next 1/4] igb: move SDP config initialization to
 separate function
Thread-Index: Add8ZdnZwW0JgSK1QxiyoIhbvUIypg==
Date:   Mon, 19 Jul 2021 06:25:41 +0000
Message-ID: <AM0PR09MB4276020F3D89779871559DEAF0E19@AM0PR09MB4276.eurprd09.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Enabled=true;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_SetDate=2021-07-19T06:25:40Z;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Method=Privileged;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_Name=Unrestricted;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_SiteId=6cce74a3-3975-45e0-9893-b072988b30b6;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_ActionId=78a564ba-32c2-48ba-bd85-c09c86e4c53b;
 MSIP_Label_9208be00-d674-40fd-8399-cd3587f85bc0_ContentBits=2
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=hbkworld.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a306f40d-c23c-422a-5fa1-08d94a7e082d
x-ms-traffictypediagnostic: AM0PR09MB2628:
x-microsoft-antispam-prvs: <AM0PR09MB2628BFFAF75CFDD0D81915ACF0E19@AM0PR09MB2628.eurprd09.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p0tc9mi7uzxPgA9L6gZXwR0Sm9FaoAK9A8iK4r1fHCl05YgJUt/5/M5S8yL9X5wEGTbUo19gS4zGhG/AdaD9TP8U9PhKvn8fkiy9q44x8T/ya1VakZWdCt80XbyyzpXwV/mWFXnkhOa/k+Mo5cIcpeOakwBZ5Y65S1XBy60PRuGUZNBL6G6CsMq2d5EwWBmizj9iN1Jnq2KEiZjLL1ENFeqLHir9uizW/eroEpH/4obDA69KI+Svb45naOCyr2WQLxmMW8YNQhv8nGyB6yfhIJ2lIE/3U3dC/XcA8yMf0ONwtSDDm6TQp79FbnuXm8Shr95YKBbDANPvNt6AacP3nPqAHRtWdrPi2vajHuQelBvxtIJh9JJkbK3FYg05pSanBm8FE1Bqf2VilgpfMo2e0Of6CbjkLsWDkJkHI+3iOH3ZvVjX0Noxwe37Dy/58kic78qk2E6kWnsPXU+024nh+4o0vqeBe+qaj5E2DL2sGC5t9emmOlQemm5e8yIrmR33UsI8Ofx4VR6fMuyQd/qGXbiryR5anwCccbVyU8wfucQ2CKyhWX5TZATnEiUPZ/xK5St8aRWq3nc89s5GfYf+foiRWUs0F2TyDJSrwe6snaQvR/bzqqg4flB681e9aDjzl80sgCGHqIRw0vJkI7cJQM9gNRkxBhBsVE6RXDr+Q917tiErDEtBk6J7w6j4zHIOtnKQsT9o1Qev2iQnkNIEmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR09MB4276.eurprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(26005)(55016002)(186003)(33656002)(71200400001)(86362001)(64756008)(66446008)(5660300002)(66476007)(83380400001)(15974865002)(52536014)(66556008)(8936002)(38100700002)(122000001)(66946007)(2906002)(8676002)(44832011)(6506007)(7696005)(316002)(76116006)(508600001)(6916009)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?amFEWmhCSUVvK3RJdXJVUUgrRDV2dmsvQTYzamwra0FoOFY5UEtYU2tVVk85?=
 =?utf-8?B?V1Y2cGF2dWQ5eFlaM1VNK29ubW43ZU5sZEpMeEtZcEd4bHhIRmVCNWltOVdm?=
 =?utf-8?B?d2hqRUpzS0xlWEg0YXdFVWUxcFo5bEo2aUV5d25VODhtNHRvaS9DS0M5MmE1?=
 =?utf-8?B?V2VESjZ5a0ovTUJpaDNMOEtwbmdwMHFqWkw1Tk9XL1dQVjlaS0x2R054ai9m?=
 =?utf-8?B?b0VNRmx0LzhMVVVnbzBUK2R3dTRzRlVoT3RXM2tDdWNMWjE2dzU0cExGSjN1?=
 =?utf-8?B?dVhLVHhxdUR5cGFPNnEzcTdOZkZiclhtUUNMYTR2QzU0Wm9qVlZJYlFtM1Fr?=
 =?utf-8?B?QXlFYURLY1BacmxGb0c2UFNJcnF0OE5CdnBsRk9UYk95a0dvcGZIeGtNRi9r?=
 =?utf-8?B?VlRVbjlFdVk4VTFEbUtvR2s5RVkydTVMdW1Sc1FvaGkxaHErVkt1eW9EK0NS?=
 =?utf-8?B?QmI5enBkdy9jWDRaRXRBanJJd1B2b0c3ajhQQmhIaXk4RlNkU1JOTTRCcWcw?=
 =?utf-8?B?WWFKcG9JbTl4Y05xQm01d1FvOUloQXNidHlrNk8xdVBOdEk0N3ExU2NRejdn?=
 =?utf-8?B?RStLdkJhQjRXZWtqZXBCaEw1KzB2MEtrM0hZTVUyL05mZi9Qd3FMd1U0RTN6?=
 =?utf-8?B?TkRTZk5xUU05WVpoRllaUGZSTUJweHN2VnZ3am9yRno2OFhoZVkvbkFCZlNN?=
 =?utf-8?B?aGhZNm0xc0VRc0tGdWxiZk9NckFQcDNqY3dDeHNUbnk2VGo0VUVVTDZDcGlW?=
 =?utf-8?B?U2tJbDRuU2x3TThZOENKMmlaV2U0REdXZlUyM3pYT002MkNxb1ZYK2h1RkVB?=
 =?utf-8?B?Z1ZMb0NPMzJXWFR2YXR6bEVTMFRXTnZQZTNPM2V1WU5iSGFpNGFuOTcxUVVv?=
 =?utf-8?B?R0VCQWJ3QnF4b1lnMHJXVDdrcUt3Wjg3VEdxVno1QTRmTHhyVGhSY2xqajF0?=
 =?utf-8?B?OFlSdkVuZGVkVUtUaFBtd2NuYUVSZkFCVzdqZU4zL3FhR3lDQXQ4MEJEbUVm?=
 =?utf-8?B?TGM4TEpHU2xEQXZlYkNlMThJK2lJbmpJZmZDbTFjSi83ZmZsM3RwTnp0WkhR?=
 =?utf-8?B?amJpbktIb1NFdGYrR1BENVJqall3MUZWcWtqRHozeUQ3WUtQWVhPQUo1RTZs?=
 =?utf-8?B?UWhOd3Y3akdRdjZudkdVZmtSOWZpbTIvYkJrV0JDVXhmWG1nNllKVDJPZ0pU?=
 =?utf-8?B?T0dHTURxYVFZN2FoOVpEUmxqRGVVMks5Rm9OMFhkYlUvaEJsZk1IQXdqbkFm?=
 =?utf-8?B?SUQ5YnFLY2paaDduekluTXdpazhxUzlxWTh5dTVMRlExRjdsZ1BXUDRZcTY5?=
 =?utf-8?B?RzRvODdNK0RXTU5CdngyZkswRW5UdHQ0TjEyN2JJVW9NNWs4dXFwdUJXOHlq?=
 =?utf-8?B?ZThVWk5wdmdFRmdXbUhTS0VoWjVlblR0YUdyWkJlMVhTWEgwZHZyQmxkcjZR?=
 =?utf-8?B?WW1iTGdDSm1RUU8zd2VibHdza3M1MmxINU9ZVlhhd3JjK09JUklHWXE4Y1ZV?=
 =?utf-8?B?bWYyb0VXR2JFNHpnQ2tQWGZzaUNpSTQ0YnprWUN1WUJwSFhQZGdXNDhvaUJP?=
 =?utf-8?B?MWF4TWhZakZxSVlCYWtRK0ppOEpaR0s4UkwyMjdrbkNHQ2srR0F1aE5yUFEz?=
 =?utf-8?B?M1JxSUhvSDVrSVFmYnEwMHFySldRY2swdlRmd2ZkQmtMOXFnUXR4ejBLMzcr?=
 =?utf-8?B?Q0ZnNFNoRXFtSVkyQTRXajVmRStuTTRRVDhyanNUeU9DVFhWeUxmL0Q4aEoz?=
 =?utf-8?Q?zs9VJHR5AoBITqv2go=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hbkworld.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR09MB4276.eurprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a306f40d-c23c-422a-5fa1-08d94a7e082d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2021 06:25:41.2564
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6cce74a3-3975-45e0-9893-b072988b30b6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SgoW/KgyTv0YMoOw0vo2RhMkbCnDhlfVIluiHl3C0wz12H0DhH1WfD26hB4c5FLs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR09MB2628
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWxsb3cgcmV1c2Ugb2YgU0RQIGNvbmZpZyBzdHJ1Y3QgaW5pdGlhbGl6YXRpb24gYnkgbW92aW5n
IGl0IHRvIGENCnNlcGFyYXRlIGZ1bmN0aW9uLg0KDQpTaWduZWQtb2ZmLWJ5OiBSdXVkIEJvcyA8
cnV1ZC5ib3NAaGJrd29ybGQuY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aWdiL2lnYl9wdHAuYyB8IDI3ICsrKysrKysrKysrKysrKysrLS0tLS0tLQ0KIDEgZmlsZSBjaGFu
Z2VkLCAxOSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9wdHAuYyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2lnYi9pZ2JfcHRwLmMNCmluZGV4IDAwMTFiMTVlNjc4Yy4uYzc4ZDBjMmE1MzQx
IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9wdHAuYw0K
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWdiL2lnYl9wdHAuYw0KQEAgLTY5LDYg
KzY5LDcgQEANCiAjZGVmaW5lIElHQl9OQklUU184MjU4MCAgICAgICAgICAgICAgICAgICAgICAg
IDQwDQoNCiBzdGF0aWMgdm9pZCBpZ2JfcHRwX3R4X2h3dHN0YW1wKHN0cnVjdCBpZ2JfYWRhcHRl
ciAqYWRhcHRlcik7DQorc3RhdGljIHZvaWQgaWdiX3B0cF9zZHBfaW5pdChzdHJ1Y3QgaWdiX2Fk
YXB0ZXIgKmFkYXB0ZXIpOw0KDQogLyogU1lTVElNIHJlYWQgYWNjZXNzIGZvciB0aGUgODI1NzYg
Ki8NCiBzdGF0aWMgdTY0IGlnYl9wdHBfcmVhZF84MjU3Nihjb25zdCBzdHJ1Y3QgY3ljbGVjb3Vu
dGVyICpjYykNCkBAIC0xMTkyLDcgKzExOTMsNiBAQCB2b2lkIGlnYl9wdHBfaW5pdChzdHJ1Y3Qg
aWdiX2FkYXB0ZXIgKmFkYXB0ZXIpDQogew0KICAgICAgICBzdHJ1Y3QgZTEwMDBfaHcgKmh3ID0g
JmFkYXB0ZXItPmh3Ow0KICAgICAgICBzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2ID0gYWRhcHRl
ci0+bmV0ZGV2Ow0KLSAgICAgICBpbnQgaTsNCg0KICAgICAgICBzd2l0Y2ggKGh3LT5tYWMudHlw
ZSkgew0KICAgICAgICBjYXNlIGUxMDAwXzgyNTc2Og0KQEAgLTEyMzMsMTMgKzEyMzMsNyBAQCB2
b2lkIGlnYl9wdHBfaW5pdChzdHJ1Y3QgaWdiX2FkYXB0ZXIgKmFkYXB0ZXIpDQogICAgICAgICAg
ICAgICAgYnJlYWs7DQogICAgICAgIGNhc2UgZTEwMDBfaTIxMDoNCiAgICAgICAgY2FzZSBlMTAw
MF9pMjExOg0KLSAgICAgICAgICAgICAgIGZvciAoaSA9IDA7IGkgPCBJR0JfTl9TRFA7IGkrKykg
ew0KLSAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHB0cF9waW5fZGVzYyAqcHBkID0gJmFk
YXB0ZXItPnNkcF9jb25maWdbaV07DQotDQotICAgICAgICAgICAgICAgICAgICAgICBzbnByaW50
ZihwcGQtPm5hbWUsIHNpemVvZihwcGQtPm5hbWUpLCAiU0RQJWQiLCBpKTsNCi0gICAgICAgICAg
ICAgICAgICAgICAgIHBwZC0+aW5kZXggPSBpOw0KLSAgICAgICAgICAgICAgICAgICAgICAgcHBk
LT5mdW5jID0gUFRQX1BGX05PTkU7DQotICAgICAgICAgICAgICAgfQ0KKyAgICAgICAgICAgICAg
IGlnYl9wdHBfc2RwX2luaXQoYWRhcHRlcik7DQogICAgICAgICAgICAgICAgc25wcmludGYoYWRh
cHRlci0+cHRwX2NhcHMubmFtZSwgMTYsICIlcG0iLCBuZXRkZXYtPmRldl9hZGRyKTsNCiAgICAg
ICAgICAgICAgICBhZGFwdGVyLT5wdHBfY2Fwcy5vd25lciA9IFRISVNfTU9EVUxFOw0KICAgICAg
ICAgICAgICAgIGFkYXB0ZXItPnB0cF9jYXBzLm1heF9hZGogPSA2MjQ5OTk5OTsNCkBAIC0xMjg0
LDYgKzEyNzgsMjMgQEAgdm9pZCBpZ2JfcHRwX2luaXQoc3RydWN0IGlnYl9hZGFwdGVyICphZGFw
dGVyKQ0KICAgICAgICB9DQogfQ0KDQorLyoqDQorICogaWdiX3B0cF9zZHBfaW5pdCAtIHV0aWxp
dHkgZnVuY3Rpb24gd2hpY2ggaW5pdHMgdGhlIFNEUCBjb25maWcgc3RydWN0cw0KKyAqIEBhZGFw
dGVyOiBCb2FyZCBwcml2YXRlIHN0cnVjdHVyZS4NCisgKiovDQordm9pZCBpZ2JfcHRwX3NkcF9p
bml0KHN0cnVjdCBpZ2JfYWRhcHRlciAqYWRhcHRlcikNCit7DQorICAgICAgIGludCBpOw0KKw0K
KyAgICAgICBmb3IgKGkgPSAwOyBpIDwgSUdCX05fU0RQOyBpKyspIHsNCisgICAgICAgICAgICAg
ICBzdHJ1Y3QgcHRwX3Bpbl9kZXNjICpwcGQgPSAmYWRhcHRlci0+c2RwX2NvbmZpZ1tpXTsNCisN
CisgICAgICAgICAgICAgICBzbnByaW50ZihwcGQtPm5hbWUsIHNpemVvZihwcGQtPm5hbWUpLCAi
U0RQJWQiLCBpKTsNCisgICAgICAgICAgICAgICBwcGQtPmluZGV4ID0gaTsNCisgICAgICAgICAg
ICAgICBwcGQtPmZ1bmMgPSBQVFBfUEZfTk9ORTsNCisgICAgICAgfQ0KK30NCisNCiAvKioNCiAg
KiBpZ2JfcHRwX3N1c3BlbmQgLSBEaXNhYmxlIFBUUCB3b3JrIGl0ZW1zIGFuZCBwcmVwYXJlIGZv
ciBzdXNwZW5kDQogICogQGFkYXB0ZXI6IEJvYXJkIHByaXZhdGUgc3RydWN0dXJlDQotLQ0KMi4z
MC4yDQoNCg0KVU5SRVNUUklDVEVEDQpIQksgQmVuZWx1eCBCLlYuLCBTY2h1dHdlZyAxNWEsIE5M
LTUxNDUgTlAgV2FhbHdpamssIFRoZSBOZXRoZXJsYW5kcyB3d3cuaGJrd29ybGQuY29tIFJlZ2lz
dGVyZWQgYXMgQi5WLiAoRHV0Y2ggbGltaXRlZCBsaWFiaWxpdHkgY29tcGFueSkgaW4gdGhlIER1
dGNoIGNvbW1lcmNpYWwgcmVnaXN0ZXIgMDgxODMwNzUgMDAwMCBDb21wYW55IGRvbWljaWxlZCBp
biBXYWFsd2lqayBNYW5hZ2luZyBEaXJlY3RvcnMgOiBBbGV4YW5kcmEgSGVsbGVtYW5zLCBKZW5z
IFdpZWdhbmQsIEpvcm4gQmFnaWpuIFRoZSBpbmZvcm1hdGlvbiBpbiB0aGlzIGVtYWlsIGlzIGNv
bmZpZGVudGlhbC4gSXQgaXMgaW50ZW5kZWQgc29sZWx5IGZvciB0aGUgYWRkcmVzc2VlLiBJZiB5
b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50LCBwbGVhc2UgbGV0IG1lIGtub3cgYW5k
IGRlbGV0ZSB0aGlzIGVtYWlsLg0K
