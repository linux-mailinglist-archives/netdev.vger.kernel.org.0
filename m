Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E6454B8C2
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344219AbiFNSiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343774AbiFNSiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:38:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361E337A25
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 11:38:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJqMgzHh2f0S9P2ombqXEmKi6A62FARIh/U1O9R350Lb8zhSgkLSd0RyeDpTA5VF76PeLSngrnlOdLwJizeEqEdwg/0tncNShCQT6IumSDjF87aEeo0y42CBWzukZmW6qfEzrdmz/NbzpupmbacNsih7kDbuOIVi0IMTqBmUhwIxBRk3ZQw44ls+eYGBQggQ7jvYQeW4Y0pFrlHrTCMJk5OJe+m4gHH15I0rx6xUUhQOgY9vc1tFX1Vm7k3wq94doLnYZ3m0Tza3ocRZJqjBe8EYzDIgrHWGiZpZFaprtTf2dZpXt5ykd80Fjve4rV0oeyEMgKnjzE8cD6ezAh2CuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fj6gQY1EfVe3G9A0UXJUYSe2gS2oonChOeLVsxp0cd4=;
 b=jXScUCQk2sw3KmzUw5YaTzgZ2po+7oKaSg5E9c/NhGncBFzFi782t8851+svvUQoeEMuY4N9f1tbSpk16IJHq1Hmo3oAdLmZZRtJa8VU1lr8H+JnvIGqVdrjOVgsRXHLAxTCsYG/3aXVXORXAC8WlPljAaFGXC6riYruA/Ln9AcfltINJLR17R5ij8AHnV+uRH6f9EvROJIlgNvfv9GsCCEK3uztf4bMTMM2bukM2X/MYV+06T0z7Q1U78xpYv5l/+Dltmiwkrgb1L9EskDzkFsZq+mkgM6bFD6icUw26eNs+SSBcQybBPp06+2PI8fWQ3Ic9iTCdyF7qvxM5slktA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fj6gQY1EfVe3G9A0UXJUYSe2gS2oonChOeLVsxp0cd4=;
 b=qeT27vwBrlEHtojiV6o1kYVRwXzOHuexAHjGqOnDOuB4aQHVRzICKrcJcQbkbOwVC+4lOjeUeIUJNKsIm5mZjHHoBjmD+MvFZjfHP+H8EMw2EXGfR3CCrKroHBsfFOiF2E7PJAhLsNBLvLMyMJo2Lw17ckY6NUwysBSArY0fjLIElUNBTMPbibUZQRLYVBLGpI9+iK7AytO6g711t59q2hsrDc31EVYi37iwpAFLcGgSEouroBoINo+e+E4DnxHKYJizHwBFuzqlVpjuoHYiwlVYuclAAeR2Tt0EdFOMcJxRCPu9FiGi2tc460nsADZI83aIMOb7FcMkgvC3PO6Bww==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MN2PR12MB2974.namprd12.prod.outlook.com (2603:10b6:208:c1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.17; Tue, 14 Jun
 2022 18:38:16 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8c53:1666:6a81:943e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8c53:1666:6a81:943e%3]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 18:38:16 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V2 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V2 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYfw/QFftqwiWMMkaiRAN4I7mCTa1NzPiQgABoqwCAAQZfMA==
Date:   Tue, 14 Jun 2022 18:38:16 +0000
Message-ID: <PH0PR12MB54816E481633EEB9C24D4D5CDCAA9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220613101652.195216-1-lingshan.zhu@intel.com>
 <20220613101652.195216-4-lingshan.zhu@intel.com>
 <PH0PR12MB548173EB919A97FF82E5E62BDCAB9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <9ed635bf-1c92-f3c6-f6c6-5715a5a5ac92@intel.com>
In-Reply-To: <9ed635bf-1c92-f3c6-f6c6-5715a5a5ac92@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c3fb4fe-bce3-4385-3fb6-08da4e350b99
x-ms-traffictypediagnostic: MN2PR12MB2974:EE_
x-microsoft-antispam-prvs: <MN2PR12MB2974AF3E2787881D5508F54CDCAA9@MN2PR12MB2974.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YHpsnI8apTYO6Q4iDTnl/xfFxNISNPvzshErujpyFQAz/vrQlD41tfhs5LxDAxlkMYwDdUXt+VtX8v4OanwfDvoOzC0I936+1ZbmDCqn97cEQJPVZhvlFt3iesQOn35XjKb0F7d4AC2xNbixW9YmIzkLYy+mboQX/h5ZV1ExiwmQmpIXCHrsMcP7Od4iCLy02X7/nWuUOglPko2qjBGmkQeC6t4HFdx9NzNT3nqlbhTtxYFAUQVMHV07lHkwoMqsYYM0Yy/v64BDdtU7hgCkfaenbHZYCvq/BK5TYkmgGSztbR9ff910VJ/A0TPCDVwTgIHIxauyC97A8NSppngscoiTOR6U61Wv1DIouuKJhpZhyY470SPfFEvJ6H56KTu5Hnza4OF6zuxpXS0fUMhM18gz/W1Yf+x0hvBl2NaN5wVNU4vkIi+G2buPiXWt/8YxdN9zMth1cvn0QAUXsFpD+LybgvjgLlAu0Db/PfH6KfT65SOj0gInatWOQM9hfldOKwC6JmvFEBC2wOm7Z/Js57vAJGka0jgVqb87ZiZAqvzxB9EpxmKU9OU50mlVwtnDL2kv7j2ZRkXbLuM4aAhg1Iiv/V5ZlKhEb9eDKBifZS/njH4PRitjDF3dWRWR4G4pQgy/mBdilI0RLqqqAcuN9UY4WKVx0SWYwTZSySjIvJ46+RN3jXGY3qHnWFJ2muv6iIZmlEXNRZvo05naIDU6PQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(508600001)(8936002)(5660300002)(316002)(52536014)(122000001)(38070700005)(54906003)(110136005)(86362001)(71200400001)(8676002)(66446008)(66476007)(4326008)(64756008)(66946007)(66556008)(76116006)(33656002)(26005)(53546011)(83380400001)(186003)(9686003)(38100700002)(2906002)(6506007)(7696005)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1NWZCtDcm92R21Rd1NWL1BzejVzVDVsSWdVcDRwNnJIcDJ3ejZsSGpiUFBV?=
 =?utf-8?B?TUxjdTBGYWRmWVdrYU1ualB4cm9MdWxEQXduWWZGS1NRamxRMFBMZlluNzhk?=
 =?utf-8?B?aFZCcWJZZVFqVWpDdFhxNDRPSTQ0WDZ0T0NkZGp1Vk1RRUg5cStURjkzTC9t?=
 =?utf-8?B?Z2YvaUJMMjhETWp3d0UxQzNXRkFiNU9razVNanNXNW50ekoyekZOTHRHTmd3?=
 =?utf-8?B?L2x3QnlXeEJwNldTMkkvY2E2OFA1d0VxMCtDVGNBYTNmdDhJd2x3UUIwbVJ3?=
 =?utf-8?B?K0VZSzNibW1nbXNEMFc5MkE5cDhjcytPNmVkOUNZajZCa0pVd1BSeHlKbEhv?=
 =?utf-8?B?aFlRZEh3QWNNbURXRzJ6VVR3WkYvV2ZIQzJRTmRDNEJUdFQ3aG9YQmxMTXkr?=
 =?utf-8?B?MmhrbnVHVUFjaVNaNG16R21nWjlYelBWLzV3RC9leWdGeXRSQnJCZEgwY0JB?=
 =?utf-8?B?TUZUY1BkYVl5eWJEUmt2Y2hycFlMKzdqL0pwVUpCSS9GREZ1V1N2YmtjQ1NP?=
 =?utf-8?B?T21RbHBHMjR5QTByOGQ4N0IvaDdTaC9GOExFczI0NFJIOEJGaEdwN2lySjFD?=
 =?utf-8?B?SDg2V3k1VEVqeU9aMnpsMWdXdGFWbUtUem1GeThHVlNkN3N1VmgzT09oM0Qy?=
 =?utf-8?B?dXNBY2xRYlRiZE1tMDVrTEI5aU04aHpUTmZ0ck1Xcko4UWZWbklLZmhrN28y?=
 =?utf-8?B?bGhqQk1zYVNTaHp0YVhtUzVPSFhZN2dKY3B6cXhLYjY5dlBKQzMxQnNHVnN6?=
 =?utf-8?B?V0dZdHUyK0x1dHRYOXB5dEdXZzM3U1p0M2hyWGQwV3hjNlFqRzVlWUtwbFlt?=
 =?utf-8?B?OHg2SG9BZFYzY2Z2a0F6TUZDT2xldVFETWpXZS92UWVOZXNtZXJqZXJHeWls?=
 =?utf-8?B?ZmdhMnpRWFNoNi9LYkFSaTFneDZvSXZCQi8zR3E0ZnUxK0Q2aWJqRnQ1MGZZ?=
 =?utf-8?B?dGMzMEVONG9mVHNndi8zWnpLSU1zemk0cWxUc2xYWmdQWklDeEQ4UjBWWVRK?=
 =?utf-8?B?VWloSzFjMzNQOHpidlZDaU5tN2JHK0N0Sm40Vm5oYVlldytEZ3JMcWUxNWJv?=
 =?utf-8?B?WDVoUUVyYTVqaHcxK2thZUNocXpSWVdTM0dWWHFORW0zT1p5Witnb2tCbklU?=
 =?utf-8?B?L05hOGJ0K3lWSVBlekFic21XekdYcGdjdWlDY0hMcU9zcU50YzNpWkNKOUFq?=
 =?utf-8?B?a1ZqMUJ0ZXpFQUZObW0xS2NOakxYb2xwTlJYRmR6OFo0RTU5blN1RWV1OEJm?=
 =?utf-8?B?b05uekVIM3lFdSsxOE1LUFZyZWJJbzFtclVpV05WaHM1bHNlOW02YjdGUSs5?=
 =?utf-8?B?OHVHMHk0UTRkSE9lOHhRTHFWSFdXb2daZVI5NnJSRTZXZDk1YmhwSTlLYXhF?=
 =?utf-8?B?bEtReTNoQXNTRlFDMXA5U29JemdGSS94THJkYVFzSVRpd1BUc3FzWU9aanJU?=
 =?utf-8?B?UVUwZldRY0dOUmdvQjlBWmF6RDFqemlhdy9WdklMOEZiZEtHbWpVZ1Jmak5n?=
 =?utf-8?B?OUlBL2FyM2xhazltV3VYU3FTSTgveGFFVmdoUUk2ZHhubjdPYm1VbUtKRXpJ?=
 =?utf-8?B?UzI5K1Z0bVhVSUVrblZ2SW0wNjBhUU9HVmhtQVQ2Q3M1ZlBOc1paTDlPZlU1?=
 =?utf-8?B?VHhQWlY4cTlEeFFpckdPVGJscE9kNEY0aGpkZllxYlFVUm1RdG4wY0dBY1d5?=
 =?utf-8?B?Z1d1bDRSNUowTjJxQk1vMyt3Y2Y1MWRCVWNpWWJ5eWN5MzNTbUg0NCt5Zkg3?=
 =?utf-8?B?K1BOUmtRK0RldHdrdHRUL0laUWNkMUwveXhTc3NEMUJjRDdjb3NCVlBDRFRD?=
 =?utf-8?B?UktRbU8xblF0d2xNR1REa08rcS9OZ2xxcTB2YkUra1NkeUd2Ym82aTZadG51?=
 =?utf-8?B?azZGYm1RQ2lSRzZPOEh4ejA4dFZuMXlOa3BITVVvelRpd1VDRHovdGFRTmI5?=
 =?utf-8?B?cjRlV2lHblA5K0tHa3dOTHJmTDdlWEdNMzFpV1VCZ0gzWkNzTjRkV3ozME85?=
 =?utf-8?B?TmtyUVpJNjI4aXJnSzBnYkhYb2k4TlZONzFENUM5NHYrZll0Yk0vMkJVVEJF?=
 =?utf-8?B?VDJZa1lidXlWSmFDTWhxdGFxZDhkZWlBeFZUSDZlTnpTd2szT0ZIYlBEalI5?=
 =?utf-8?B?eFJCcUFoU1pYV2F0bkJxdVVDM3JKK0Mxa3dOdDVyOFU3Y2xHcVZZdyt0YXZp?=
 =?utf-8?B?NHBtSzNYZmR6S25RYU5YQnBIdHM1bFpLSkNKY2hHRDdQMndoUDB1UnIvK3lQ?=
 =?utf-8?B?ejM2Q2VzcktyY0VCSzJocGxuZlNOU3VXd0RCajJONmlOWC9rY2dNZUZ6WnhO?=
 =?utf-8?Q?gG0eoaLtpGGFEMqf2G?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c3fb4fe-bce3-4385-3fb6-08da4e350b99
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2022 18:38:16.0548
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 29vclzK2rEvoet5eP+qitqNyo187/+OPavYbdv8pT1z9joqwiipI69G8XHF/TGYpYlcVW6bwaRzw9vR/9kT8ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2974
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWmh1LCBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4gU2Vu
dDogTW9uZGF5LCBKdW5lIDEzLCAyMDIyIDEwOjUzIFBNDQo+IA0KPiANCj4gT24gNi8xNC8yMDIy
IDQ6NDIgQU0sIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPg0KPiA+PiBGcm9tOiBaaHUgTGluZ3No
YW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+ID4+IFNlbnQ6IE1vbmRheSwgSnVuZSAxMywg
MjAyMiA2OjE3IEFNDQo+ID4+IGRldmljZQ0KPiA+Pg0KPiA+PiBUaGlzIGNvbW1pdCBhZGRzIGEg
bmV3IHZEUEEgbmV0bGluayBhdHRyaWJ1dGlvbg0KPiA+PiBWRFBBX0FUVFJfVkRQQV9ERVZfU1VQ
UE9SVEVEX0ZFQVRVUkVTLiBVc2Vyc3BhY2UgY2FuIHF1ZXJ5DQo+IGZlYXR1cmVzDQo+ID4+IG9m
IHZEUEEgZGV2aWNlcyB0aHJvdWdoIHRoaXMgbmV3IGF0dHIuDQo+ID4+DQo+ID4+IFNpZ25lZC1v
ZmYtYnk6IFpodSBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4gPj4gLS0tDQo+
ID4+ICAgZHJpdmVycy92ZHBhL3ZkcGEuYyAgICAgICB8IDEzICsrKysrKysrKy0tLS0NCj4gPj4g
ICBpbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oIHwgIDEgKw0KPiA+PiAgIDIgZmlsZXMgY2hhbmdl
ZCwgMTAgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gPj4NCj4gPj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvdmRwYS92ZHBhLmMgYi9kcml2ZXJzL3ZkcGEvdmRwYS5jIGluZGV4DQo+ID4+
IGViZjJmMzYzZmJlNy4uOWIwZTM5YjJmMDIyIDEwMDY0NA0KPiA+PiAtLS0gYS9kcml2ZXJzL3Zk
cGEvdmRwYS5jDQo+ID4+ICsrKyBiL2RyaXZlcnMvdmRwYS92ZHBhLmMNCj4gPj4gQEAgLTgxNSw3
ICs4MTUsNyBAQCBzdGF0aWMgaW50IHZkcGFfZGV2X25ldF9tcV9jb25maWdfZmlsbChzdHJ1Y3QN
Cj4gPj4gdmRwYV9kZXZpY2UgKnZkZXYsICBzdGF0aWMgaW50IHZkcGFfZGV2X25ldF9jb25maWdf
ZmlsbChzdHJ1Y3QNCj4gPj4gdmRwYV9kZXZpY2UgKnZkZXYsIHN0cnVjdCBza19idWZmICptc2cp
ICB7DQo+ID4+ICAgCXN0cnVjdCB2aXJ0aW9fbmV0X2NvbmZpZyBjb25maWcgPSB7fTsNCj4gPj4g
LQl1NjQgZmVhdHVyZXM7DQo+ID4+ICsJdTY0IGZlYXR1cmVzX2RldmljZSwgZmVhdHVyZXNfZHJp
dmVyOw0KPiA+PiAgIAl1MTYgdmFsX3UxNjsNCj4gPj4NCj4gPj4gICAJdmRwYV9nZXRfY29uZmln
X3VubG9ja2VkKHZkZXYsIDAsICZjb25maWcsIHNpemVvZihjb25maWcpKTsgQEAgLQ0KPiA+PiA4
MzIsMTIgKzgzMiwxNyBAQCBzdGF0aWMgaW50IHZkcGFfZGV2X25ldF9jb25maWdfZmlsbChzdHJ1
Y3QNCj4gPj4gdmRwYV9kZXZpY2UgKnZkZXYsIHN0cnVjdCBza19idWZmICptcw0KPiA+PiAgIAlp
ZiAobmxhX3B1dF91MTYobXNnLCBWRFBBX0FUVFJfREVWX05FVF9DRkdfTVRVLCB2YWxfdTE2KSkN
Cj4gPj4gICAJCXJldHVybiAtRU1TR1NJWkU7DQo+ID4+DQo+ID4+IC0JZmVhdHVyZXMgPSB2ZGV2
LT5jb25maWctPmdldF9kcml2ZXJfZmVhdHVyZXModmRldik7DQo+ID4+IC0JaWYgKG5sYV9wdXRf
dTY0XzY0Yml0KG1zZywNCj4gPj4gVkRQQV9BVFRSX0RFVl9ORUdPVElBVEVEX0ZFQVRVUkVTLCBm
ZWF0dXJlcywNCj4gPj4gKwlmZWF0dXJlc19kcml2ZXIgPSB2ZGV2LT5jb25maWctPmdldF9kcml2
ZXJfZmVhdHVyZXModmRldik7DQo+ID4+ICsJaWYgKG5sYV9wdXRfdTY0XzY0Yml0KG1zZywNCj4g
Pj4gVkRQQV9BVFRSX0RFVl9ORUdPVElBVEVEX0ZFQVRVUkVTLCBmZWF0dXJlc19kcml2ZXIsDQo+
ID4+ICsJCQkgICAgICBWRFBBX0FUVFJfUEFEKSkNCj4gPj4gKwkJcmV0dXJuIC1FTVNHU0laRTsN
Cj4gPj4gKw0KPiA+PiArCWZlYXR1cmVzX2RldmljZSA9IHZkZXYtPmNvbmZpZy0+Z2V0X2Rldmlj
ZV9mZWF0dXJlcyh2ZGV2KTsNCj4gPj4gKwlpZiAobmxhX3B1dF91NjRfNjRiaXQobXNnLA0KPiA+
PiBWRFBBX0FUVFJfVkRQQV9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTLA0KPiA+PiArZmVhdHVyZXNf
ZGV2aWNlLA0KPiA+PiAgIAkJCSAgICAgIFZEUEFfQVRUUl9QQUQpKQ0KPiA+PiAgIAkJcmV0dXJu
IC1FTVNHU0laRTsNCj4gPj4NCj4gPj4gLQlyZXR1cm4gdmRwYV9kZXZfbmV0X21xX2NvbmZpZ19m
aWxsKHZkZXYsIG1zZywgZmVhdHVyZXMsICZjb25maWcpOw0KPiA+PiArCXJldHVybiB2ZHBhX2Rl
dl9uZXRfbXFfY29uZmlnX2ZpbGwodmRldiwgbXNnLCBmZWF0dXJlc19kcml2ZXIsDQo+ID4+ICsm
Y29uZmlnKTsNCj4gPj4gICB9DQo+ID4+DQo+ID4+ICAgc3RhdGljIGludA0KPiA+PiBkaWZmIC0t
Z2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3ZkcGEuaCBiL2luY2x1ZGUvdWFwaS9saW51eC92ZHBh
LmgNCj4gPj4gaW5kZXgNCj4gPj4gMjVjNTVjYWIzZDdjLi4zOWYxYzNkN2MxMTIgMTAwNjQ0DQo+
ID4+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC92ZHBhLmgNCj4gPj4gKysrIGIvaW5jbHVkZS91
YXBpL2xpbnV4L3ZkcGEuaA0KPiA+PiBAQCAtNDcsNiArNDcsNyBAQCBlbnVtIHZkcGFfYXR0ciB7
DQo+ID4+ICAgCVZEUEFfQVRUUl9ERVZfTkVHT1RJQVRFRF9GRUFUVVJFUywJLyogdTY0ICovDQo+
ID4+ICAgCVZEUEFfQVRUUl9ERVZfTUdNVERFVl9NQVhfVlFTLAkJLyogdTMyICovDQo+ID4+ICAg
CVZEUEFfQVRUUl9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTLAkvKiB1NjQgKi8NCj4gPiBJIHNlZSBu
b3cgd2hhdCB3YXMgZG9uZSBpbmNvcnJlY3RseSB3aXRoIGNvbW1pdCBjZDI2MjlmNmRmMWNhLg0K
PiA+DQo+ID4gQWJvdmUgd2FzIGRvbmUgd2l0aCB3cm9uZyBuYW1lIHByZWZpeCB0aGF0IG1pc3Nl
ZCBNR01UREVWXy4gOigNCj4gUGxlYXNlDQo+ID4gZG9uJ3QgYWRkIFZEUEFfIHByZWZpeCBkdWUg
dG8gb25lIG1pc3Rha2UuDQo+ID4gUGxlYXNlIHJldXNlIHRoaXMgVkRQQV9BVFRSX0RFVl9TVVBQ
T1JURURfRkVBVFVSRVMgZm9yIGRldmljZQ0KPiBhdHRyaWJ1dGUgYXMgd2VsbC4NCj4gY3VycmVu
dGx5IHdlIGNhbiByZXVzZSBWRFBBX0FUVFJfREVWX1NVUFBPUlRFRF9GRUFUVVJFUyB0byByZXBv
cnQNCj4gZGV2aWNlIGZlYXR1cmVzIGZvciBzdXJlLCBob3dldmVyIHRoaXMgY291bGQgY29uZnVz
ZSB0aGUgcmVhZGVycyBzaW5jZSBldmVyeQ0KPiBhdHRyIHNob3VsZCBoYXMgaXRzIG93biB1bmlx
dWUgcHVycG9zZS4NClZEUEFfQVRUUl9ERVZfU1VQUE9SVEVEX0ZFQVRVUkVTIGlzIHN1cHBvc2Vk
IHRvIGJlIFZEUEFfQVRUUl9NR01UREVWX1NVUFBPUlRFRF9GRUFUVVJFUw0KQW5kIGRldmljZSBz
cGVjaWZpYyBmZWF0dXJlcyBpcyBzdXBwb3NlZCB0byBiZSBuYW1lZCBhcywNClZEUEFfQVRUUl9E
RVZfU1VQUE9SVEVEX0ZFQVRVUkVTLg0KDQpCdXQgaXQgd2FzIG5vdCBkb25lIHRoaXMgd2F5IGlu
IGNvbW1pdCBjZDI2MjlmNmRmMWNhLg0KVGhpcyBsZWFkcyB0byB0aGUgZmluZGluZyBnb29kIG5h
bWUgcHJvYmxlbSBub3cuDQoNCkdpdmVuIHRoYXQgdGhpcyBuZXcgYXR0cmlidXRlIGlzIGdvaW5n
IHRvIHNob3cgc2FtZSBvciBzdWJzZXQgb2YgdGhlIGZlYXR1cmVzIG9mIHRoZSBtYW5hZ2VtZW50
IGRldmljZSBzdXBwb3J0ZWQgZmVhdHVyZXMsIGl0IGlzIGZpbmUgdG8gcmV1c2Ugd2l0aCBleGNl
cHRpb24gd2l0aCBleHBsaWNpdCBjb21tZW50IGluIHRoZSBVQVBJIGhlYWRlciBmaWxlLg0K
