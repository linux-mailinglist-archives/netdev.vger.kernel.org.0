Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 793D456BE09
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 18:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237827AbiGHQI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiGHQI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:08:27 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DDA70E40
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 09:08:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDkG20+uyptOCiuV8/ENDJjfYMcS89seDQmfYPsOP85dsax21/UbzwdIu4SL6Npg4wLrxWWvxgbc6XF5kw1VNmR5Duc6PM5slK8xJFCEVn3DGoDmhRW6cOqrKfs9MVUyw6YQXj+xWIoqTHei6DiZjtyJuD4lr9gYEr1kdaHh7epaG9kVpLdXjCqMWJaT40I1NgfXJTr+q2oJlz2rSPnA2Ab4TbgNyf/Ao2BVx6rxK9N9nxKxBGQss+S8C2/xaWQGbkz06O/2naofDc19tKFzGBq84Rg2OoOMsg4dQHo3tnPuzObl+YKNKuvWtX5smahrMRDS9dHhoffMqMrqQg7aHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w1JHOdpM2/4IGOWhjai8R3DNm6oFqzGCedVt/B0EFcg=;
 b=oGdEFFxSbUoNVH2P2OQAAI6RPiA83RmTHQI0Dw5cNWlkNM948E0hL5VF7K7lK1kzKeFyKXcOc8fXd7Z7HVS2k3TzolC+/kRN0zAUYy8zNttkYKNENLyblTK5X9CY8SzpQ3WcVR9osvmwxY8aa3MTR4rGCj0CNqKPsJRSQ3UvvJKjxuuU452jaTmtoC9CW+FUSXODSIIyqtCLizhdkU8pEllDe5BchaPdNX2/+nefsvuEOGmMQrobUgfTVrTpES/rQ5OG5HFfp717lkVbVMzz/VTM+nebC7uI5NM6uyJMOWgg10J2ZGn150RzvrRJspjDMZHL2ZJz8I6jPaNAzOXQmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w1JHOdpM2/4IGOWhjai8R3DNm6oFqzGCedVt/B0EFcg=;
 b=BEpcNmVU34yXAjvj5aIglCHHxW8L/7jnXfmyrvdkxYeae6yZ8x3LMyKxzdf1vk+DBV98Hle4fPnN/JyFJieZ6lsnhC0DkDvs7Jot37GdqECIIDAJVIwTo1Rn1244UXy4h5mtlk6G5+HgZkLQoLZBE7SsN/jVdF+2rOnSrr1i2EMFCOhdHc7m+OMsjxgAEOI3tWtSnsbQjaFFeerOMS3s0UzvwB1ohA7OCisGKSoIh1z1ur+mQrhug7/fSREKgLHDqEJzPJ4Y+pQux4lAXddnptYrAZiu0RHVJ7vhUiABrVGpUnAUm5ccZDTD5Hyy6ZLTOy+zX4dfLwpbHons8f+UYg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BN6PR12MB1284.namprd12.prod.outlook.com (2603:10b6:404:17::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.18; Fri, 8 Jul
 2022 16:08:23 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 16:08:22 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa.c
Thread-Topic: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa.c
Thread-Index: AQHYjU+QmOZttA2ivUmN8uBJ6/N6Yq1qFNVggAn3fYCAAKKm4A==
Date:   Fri, 8 Jul 2022 16:08:22 +0000
Message-ID: <PH0PR12MB54815FFBEDBFEAC0CDC378DEDC829@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-7-lingshan.zhu@intel.com>
 <PH0PR12MB5481D4D77EAC336BA68E85AADCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <dea8be07-bc25-192c-ecd7-636cbdb2a629@intel.com>
In-Reply-To: <dea8be07-bc25-192c-ecd7-636cbdb2a629@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e47d9e13-d8dc-4795-2fa8-08da60fc151e
x-ms-traffictypediagnostic: BN6PR12MB1284:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tQYTiLh4VgU65nM6A1FBaHCPRfpKVrfc7wtDBJDT72cevCi8Qe4qLcW8hi8es+TqnveBX7Baoe+QO+19qekAVL4FKNJUMf3qgDNXAevuYw7c0JeCBxoolozoLmRCu+N/1fH6CNK/7owrbDmju1o0ME+O83RPAIcgkrxzDFwHgQNUhoODUVuT+KaYIX15xcrFmdGOzpSunWKVpiF4Hhgp3ZLrmYHEYBRaOvDo/MmhguCFgDvPMbPy3qlxFSUz96JNa8gb4MVQypPW8wt23O/f3J6mTYew9dZOiy6+F6G4TCQeUy4M2MDU8eB1nxRB54KNL4TyHmPhNUwq1/58/Knfmkx3tfWFRsiqUUgXaX+cxKnzuS8JvTm8MPmLN16hUvueVRYm4gaLd9Fu+/tnjQ7DTPTmcxG3XKLeoePjoPokmFh6zwGFd0CAsfPsQWCopoyyZVyLJltkfnVNaY3zM/Oo9v0gfwYwC5bjjEbRAm7+e8pgBUsBcuE986R8R19X6V/A6FcuAyK/DPn78GZNfFX5n9i8h4QyPs5YZXcRS3heq+hzzCrWVNkhK1yWrJoklQHzDbfTIDMADyeifafZktG48+9gu0DatNRlckFZS5APY7Z09QV9/J33CBgsKfT4GC9+A45e7gkYwcs0t+Kcls4LcaoK/38aJEFJayLmuIycgkqqeP65jkxb8aTyXMguLZ0nddZcY8lcuUe91dyUSoUTExOEiaHyVlmIVMV34npVjJrIPbqVWIepiweZaz9egPaOxtdmbUOxGUMoerIooVVIeuNN95Rj4royFFOdd0Y4gPNY9O1fDihgFxnzEfci/oSu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(316002)(71200400001)(110136005)(6506007)(53546011)(186003)(7696005)(9686003)(55016003)(26005)(33656002)(54906003)(478600001)(5660300002)(122000001)(66556008)(8936002)(86362001)(38100700002)(4326008)(64756008)(41300700001)(66446008)(83380400001)(76116006)(8676002)(38070700005)(52536014)(66946007)(2906002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2NBeTFDSGJZTzhPQUpvNlRadUtodGozc2FSV0lIaERvdnkvLzNMamtGa2dF?=
 =?utf-8?B?SldXeW9JbW5SL3JRbEN0anRHeWZUTkYyb0NRRGJqWGtnT1lVcHBCbitGeG15?=
 =?utf-8?B?ZGszNkRIckF3dERNZ0FmaEVVd0V1VDV3YXNBc1YxWUttVDhhQ3pJbk9NQlhi?=
 =?utf-8?B?ODNNNWdZTG02TkdtSWNSV0lVNlNMR3VQRUliNTZIdFR0bHJxSzdsWjhOL2E5?=
 =?utf-8?B?MG01VDlCT2lUS3JsVGFoVFg0ancvaTZrb1g5TFdvRE5RNlhUYVIrWFJlY0FC?=
 =?utf-8?B?LzRWZy8zRk56bWpPdXlMTVVIdmo4ekE1REd2MmE2djZ3aTVuSGdMU3hXR0dX?=
 =?utf-8?B?ek41Yjk1aUpwZDFzUXk1WlQ0em8ycklzN2RraXNvT0xtN1dUVXZrV0VyWGQx?=
 =?utf-8?B?SXkrWERMRDkyRFR2OUtvaEtmcmhBN0N4bUhFM2xPM2JxVjNaZi9KSk1PbzVs?=
 =?utf-8?B?VVVXVi84ZWZDTFBmaFZJQ0FKeUZlbFdTa1pHZHN2WXNSem9qeUhINTV3bmtq?=
 =?utf-8?B?QjFlekpYSWxWL2JlNWJyVEZEcjlPMDBoV291UHRraGxCQmdBQkVHVkhCTWZv?=
 =?utf-8?B?bE5vUDRBb2tSbGt6RmhEczN0d01FODg3TkhEeWF6Z1J2MWhaSk5PTjFNaGxZ?=
 =?utf-8?B?R3A2TXYvZEtjRTJiamV3RDd4b21meGl4VUtTYTRCZ0tvZjhBbFhsY0VmdzFn?=
 =?utf-8?B?RXJIZkhrUFJXZDFzZnBBZ3ZFeFdPOHhuemRXUmFaUXlDNFEwTjA3cWlxY1gz?=
 =?utf-8?B?Q2FWSDlwUEJmbkNWL0Q3TzhvajZwNXY0NjRJcHNTWitwbTBiVG1XbnQ5RDFx?=
 =?utf-8?B?czRLTk40RzRydCtMbXE5N0dsUWU2U3I5YjZ0MUptRWh5TVo4TkJjbHQ4Qk9Z?=
 =?utf-8?B?T3o3U3FuLytrL3oySlBTdnJ1Zm9jOFJnUVVJYzRHbTRKWHUyMERWQTF3cGZD?=
 =?utf-8?B?ZHBuUWFiQmIybmdROXB5Zjc5cHNSc0R3TlpDMjRwckRnTVpjeHZRN0pvUTJ6?=
 =?utf-8?B?aWtOSHV4Rnk4K1BaSlhyS1FQdEp4VmJxWDh2dWZYV3gvTXhMV0pQSVp5cUFv?=
 =?utf-8?B?LzVjY0hwZWJPdkhUTkZyU0Z5NDFWcUlhL1oxcHg3ZXd1dnpNZ2k3dGYyZ21o?=
 =?utf-8?B?Y2JvUkhYZkY0OWdoTXlJaUcrRURHU01jRzMrMVUwZ3RyM1h5VzJVaXNtb3Qy?=
 =?utf-8?B?ckpmTVNnNUxqSTYwT29hZDRoTnVWbnMwOS9nTXZtbGZaOGhlVG0yNk9XQTVm?=
 =?utf-8?B?MnBwT1dFNXFXREtWdkJncVg1Mml4bnZXYmt1eGpqQklIQUZVSVZpYUhsOWdv?=
 =?utf-8?B?blk3Z3NrVXJxdHhXd2pJRG55cTZzbmNoVUVhYlpwVHdKNDVkTGVrOWZ3V0ta?=
 =?utf-8?B?Vlg1U29WOXhTUjVPbVFmVk5yMkdDUlRqWFVmSG4zREJlR2hSdllubG9LWmxE?=
 =?utf-8?B?UGkyaC9QdS9EZ0tJTGhMYlpDcnI1YzEwc0ZuWjAza1VQcHRpT3lwSUpEaVNX?=
 =?utf-8?B?elJKRkRGUG5yY21BSUFwZyt1NVFId3VoMjU3eDRDZHVoTW5SYlZpWVQ1NmJQ?=
 =?utf-8?B?UHhXZHVOZ2pJVmJPZ0JLTFpSd1loclczRmxqVHM0VEJ0OW5VWHRRMWlwSE1W?=
 =?utf-8?B?WW1iZWhhcS83QmNpYTFqTGpGaFpXajVYaEFYdFhjRTM1VkcvVkFCVndBeWor?=
 =?utf-8?B?N0lqU3c4N3YraWV3RFZoMDNYQ3h2cllpcDE4andONlpHNklXS29yT0o1d0xJ?=
 =?utf-8?B?S1E0L1YzVXBnbU54V2hCcVFEWE0wbkdVbnY4ckZTbDhJaEdVR3UwTEowNjVk?=
 =?utf-8?B?eUxLTUJ3QnhBalRxaEM0Y256UEFScjJjci8yOUJSd0dnRG40NnFITG5QMERJ?=
 =?utf-8?B?amQwQkRTdU83UXl4TzFGbU9NNFI5aVc2RFI1VkFrbno4ZkRMWW14eDZ0Z0FB?=
 =?utf-8?B?R2E0c0duWmhzNFo4UVRKR3JYYk9LYjVXNDRrOHd3RE9iTHFtcVNjS0wwOERz?=
 =?utf-8?B?UWNFS2dWSG1xbFJzdjZoeXNIdUY1TVJrVnFCanRLTHc2cnhRRGE2RHZ0amxQ?=
 =?utf-8?B?MTVQSFZoOUlNeVpOaDBibW5mTjQ3M0VGdmwyZFN6Wlk3bUhLSUhBTWtYT1Zl?=
 =?utf-8?Q?dwoU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e47d9e13-d8dc-4795-2fa8-08da60fc151e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 16:08:22.8358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2r9XY27jtm5tbUem20GlOyinL6VIyn4Nle2xJzI5JyyAyboJaQbkY9HDGVHhR4KXZt4CssTkLuRzmZRoSGp1AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1284
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFpodSwgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+IFNlbnQ6
IEZyaWRheSwgSnVseSA4LCAyMDIyIDI6MjUgQU0NCj4gDQo+IA0KPiBPbiA3LzIvMjAyMiA2OjE4
IEFNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+IEZyb206IFpodSBMaW5nc2hhbiA8bGluZ3No
YW4uemh1QGludGVsLmNvbT4NCj4gPj4gU2VudDogRnJpZGF5LCBKdWx5IDEsIDIwMjIgOToyOCBB
TQ0KPiA+Pg0KPiA+PiBUaGlzIGNvbW1pdCBmaXhlcyBzcGFycyB3YXJuaW5nczogY2FzdCB0byBy
ZXN0cmljdGVkIF9fbGUxNiBpbg0KPiA+PiBmdW5jdGlvbg0KPiA+PiB2ZHBhX2Rldl9uZXRfY29u
ZmlnX2ZpbGwoKSBhbmQNCj4gPj4gdmRwYV9maWxsX3N0YXRzX3JlYygpDQo+ID4+DQo+ID4gTWlz
c2luZyBmaXhlcyB0YWcuDQo+IEkgYW0gbm90IHN1cmUgd2hldGhlciB0aGlzIGRlc2VydmUgYSBm
aXggdGFnLCBJIHdpbGwgbG9vayBpbnRvIGl0Lg0KPiA+DQo+ID4gQnV0IEkgZmFpbCB0byB1bmRl
cnN0YW5kIHRoZSB3YXJuaW5nLg0KPiA+IGNvbmZpZy5zdGF0dXMgaXMgbGUxNiwgYW5kIEFQSSB1
c2VkIGlzIHRvIGNvbnZlcnQgbGUxNiB0byBjcHUuDQo+ID4gV2hhdCBpcyB0aGUgd2FybmluZyBh
Ym91dCwgY2FuIHlvdSBwbGVhc2UgZXhwbGFpbj8NCg0KDQpJIHNlZSBpdC4gSXRzIG5vdCBsZTE2
LCBpdHMgX192aXJ0aW8xNi4NClBsZWFzZSBhZGQgZml4ZXMgdGFnLg0KV2l0aCB0aGF0IFJldmll
d2VkLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG52aWRpYS5jb20+DQoNCj4gVGhlIHdhcm5pbmdz
IGFyZToNCj4gZHJpdmVycy92ZHBhL3ZkcGEuYzo4Mjg6MTk6IHdhcm5pbmc6IGNhc3QgdG8gcmVz
dHJpY3RlZCBfX2xlMTYNCj4gZHJpdmVycy92ZHBhL3ZkcGEuYzo4Mjg6MTk6IHdhcm5pbmc6IGNh
c3QgZnJvbSByZXN0cmljdGVkIF9fdmlydGlvMTYNCj4gPg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBa
aHUgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+ID4+IC0tLQ0KPiA+PiAgIGRy
aXZlcnMvdmRwYS92ZHBhLmMgfCA2ICsrKy0tLQ0KPiA+PiAgIDEgZmlsZSBjaGFuZ2VkLCAzIGlu
c2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3ZkcGEvdmRwYS5jIGIvZHJpdmVycy92ZHBhL3ZkcGEuYyBpbmRleA0KPiA+PiA4NDZkZDM3
ZjM1NDkuLmVkNDlmZTQ2YTc5ZSAxMDA2NDQNCj4gPj4gLS0tIGEvZHJpdmVycy92ZHBhL3ZkcGEu
Yw0KPiA+PiArKysgYi9kcml2ZXJzL3ZkcGEvdmRwYS5jDQo+ID4+IEBAIC04MjUsMTEgKzgyNSwx
MSBAQCBzdGF0aWMgaW50IHZkcGFfZGV2X25ldF9jb25maWdfZmlsbChzdHJ1Y3QNCj4gPj4gdmRw
YV9kZXZpY2UgKnZkZXYsIHN0cnVjdCBza19idWZmICptcw0KPiA+PiAgIAkJICAgIGNvbmZpZy5t
YWMpKQ0KPiA+PiAgIAkJcmV0dXJuIC1FTVNHU0laRTsNCj4gPj4NCj4gPj4gLQl2YWxfdTE2ID0g
bGUxNl90b19jcHUoY29uZmlnLnN0YXR1cyk7DQo+ID4+ICsJdmFsX3UxNiA9IF9fdmlydGlvMTZf
dG9fY3B1KHRydWUsIGNvbmZpZy5zdGF0dXMpOw0KPiA+PiAgIAlpZiAobmxhX3B1dF91MTYobXNn
LCBWRFBBX0FUVFJfREVWX05FVF9TVEFUVVMsIHZhbF91MTYpKQ0KPiA+PiAgIAkJcmV0dXJuIC1F
TVNHU0laRTsNCj4gPj4NCj4gPj4gLQl2YWxfdTE2ID0gbGUxNl90b19jcHUoY29uZmlnLm10dSk7
DQo+ID4+ICsJdmFsX3UxNiA9IF9fdmlydGlvMTZfdG9fY3B1KHRydWUsIGNvbmZpZy5tdHUpOw0K
PiA+PiAgIAlpZiAobmxhX3B1dF91MTYobXNnLCBWRFBBX0FUVFJfREVWX05FVF9DRkdfTVRVLCB2
YWxfdTE2KSkNCj4gPj4gICAJCXJldHVybiAtRU1TR1NJWkU7DQo+ID4+DQo+ID4+IEBAIC05MTEs
NyArOTExLDcgQEAgc3RhdGljIGludCB2ZHBhX2ZpbGxfc3RhdHNfcmVjKHN0cnVjdCB2ZHBhX2Rl
dmljZQ0KPiA+PiAqdmRldiwgc3RydWN0IHNrX2J1ZmYgKm1zZywNCj4gPj4gICAJfQ0KPiA+PiAg
IAl2ZHBhX2dldF9jb25maWdfdW5sb2NrZWQodmRldiwgMCwgJmNvbmZpZywgc2l6ZW9mKGNvbmZp
ZykpOw0KPiA+Pg0KPiA+PiAtCW1heF92cXAgPSBsZTE2X3RvX2NwdShjb25maWcubWF4X3ZpcnRx
dWV1ZV9wYWlycyk7DQo+ID4+ICsJbWF4X3ZxcCA9IF9fdmlydGlvMTZfdG9fY3B1KHRydWUsIGNv
bmZpZy5tYXhfdmlydHF1ZXVlX3BhaXJzKTsNCj4gPj4gICAJaWYgKG5sYV9wdXRfdTE2KG1zZywg
VkRQQV9BVFRSX0RFVl9ORVRfQ0ZHX01BWF9WUVAsDQo+ID4+IG1heF92cXApKQ0KPiA+PiAgIAkJ
cmV0dXJuIC1FTVNHU0laRTsNCj4gPj4NCj4gPj4gLS0NCj4gPj4gMi4zMS4xDQoNCg==
