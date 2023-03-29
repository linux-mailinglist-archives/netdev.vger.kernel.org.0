Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875046CD833
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 13:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjC2LIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 07:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjC2LIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 07:08:53 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2070.outbound.protection.outlook.com [40.107.212.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655211716
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 04:08:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLDrwX16yHigW1NA5zuJJwpQZ31gsE3HtvmgycLfNySxsFSlFZS8ZRRN/yWu+2QDsP+zga93bj52S8R8qK5KUyE0a9/CG0W4dV+fubAKw00QH11r4xQobhtUd8Q5Uj1CK4Mx3T6MQfPdDz5wVYEbQpKOk63ApxpbacO7Hy5cq6x5QI0OQZwIFWy3ymCH8ZyfZfvAj1qAVF08A/mBo1yo8863xJvrrirTBwi1ygFnFHm1VkUtvNbkPiYN+z0+9GMuDKGGX8OTYz4c8GgWmM8jsqmTPCtdqAMA0f7+7ftutA5zBcn8dJ7R5N45G4r2WWLF1S0Uks8bVJSXpPucJnQjdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ic1pcQ2GPCMR7i6vRwX65L2lakuZG3pGnFazwLh92fA=;
 b=IFDUEuNEuzA4HEOBe8C1IRgUlF1pKw+DRelBEz05p5SoVkpt+F8c3sHF1NiEtCIK1O7D70ix9pSVjmpcCLJyLnrMQtAt70EKTEGBoZ+ZQ+yleVeJzXGCGd1YFckue5f1vpUuLMPQcZAHqQ/0ny27tWe5ZU0JUD/F0yFt+wI1Vv8/wEKJUHAHZepAYGE66O9x7lYFQQt2W1R4G5nN0OaP4ZAjqHTLr2Vy+OBX3rXqaL0t8BMao5oYOFimQycZL1J12OApX6x9n4FRxRidkCFNMKEcdXL0D7EGiokJ+0TsoWs9KT2iNqLg6Jgj4bFl/sf7weIsZev/ajgB4mIsC9niqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ic1pcQ2GPCMR7i6vRwX65L2lakuZG3pGnFazwLh92fA=;
 b=ZY1AbSXTklAaRS0Lihmt8gyx4o2nDreOjzimFwe+yiGPMVdNB4YgI/11BrvmzSC+9A8dmyFvQUTt3MfnHmIz4+nuLI95Wo0JIJ1m5vumegdvK/Ar9vz+EhtaGba/lSrSgbgzOsG2Ppnr9PxL3VryZU1p8dn8Srg0lTZpxp6wNKHOxAhi5Sc8uUdaxuDp79bHKzMJ7cPu6eP7tCbrVFkeK/RcoejQ1Gfge3l0/VDj+nYuRihRdKYhkwGjqsqdSTchE8wExfH6LGMrVNcyjnj2YFi6IegIyXfYgXW7W6uZM9ec08G79Rr5VMcr3QWcv/N5SMi3uvv2qnZ1VrdsEQR3tQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DS0PR12MB8197.namprd12.prod.outlook.com (2603:10b6:8:f1::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Wed, 29 Mar
 2023 11:08:50 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::adb:45dc:7c9a:dff5%5]) with mapi id 15.20.6178.041; Wed, 29 Mar 2023
 11:08:50 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 1/4] vlan: Add MACsec offload operations for VLAN
 interface
Thread-Topic: [PATCH net-next 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Thread-Index: AQHZX7RxM01RMOfCPEGm1w69wBk9+a8O1yKAgADrC2CAAQtnAIAAz0RA
Date:   Wed, 29 Mar 2023 11:08:50 +0000
Message-ID: <IA1PR12MB63531B4078AE8BB723CCECCBAB899@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230326072636.3507-1-ehakim@nvidia.com>
        <20230326072636.3507-2-ehakim@nvidia.com>
        <20230327094335.07f462f9@kernel.org>
        <IA1PR12MB6353B5E1BC80B60993267190AB889@IA1PR12MB6353.namprd12.prod.outlook.com>
 <20230328154154.14bbee54@kernel.org>
In-Reply-To: <20230328154154.14bbee54@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DS0PR12MB8197:EE_
x-ms-office365-filtering-correlation-id: 90769b65-5df5-4aa1-6802-08db3045f9c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eQjRHuEBpMyDmG77aYLqzOyqMsyHBePOM0mYf2Yx4lhs+fCIjkodmVFgcIT7HOs0buXSCxt1BzaJxvj31PCfIJv5eJNDX7BB23SVSYM17Ny9gp+pM86Y5IXoXDGVFuMSKH+xrouBjF5JpoBAulRN/VY2Z7+aIiMlUa/N5lStOqDYitUnynP6vj/jnWPO1bJxDtbWqdVsMqGMCmx7MbmY+r89k7tj+PfvpjxRJ9Tp8s6kprAcSweG2Vcu40bnOcrMUp4vwVGRvXbsixKoYbWd8OVWoNuE6B3WQIxzPdizYoaxAJnC6FzpijRS+Lhf3y8HUA03z/Eb37lOKW4BNnIz2mx+PoykMEugHFPhv8XZk3SW0fNjeJ3UCUFvTjAgyGS3/mPReS1GETFXJMmwoAj9AGZ32CvdH5+QQ9mxxs3jBKZgKhgqjGfeDHOzY3GGZoHeAGLKktPNTxgOe9FNCrtnR4jycSi/5VVGpeS9MJY8ERvvF3nO2Q/2Z+OwD2MA9Hv2xPTijN6drZQ87ZW0VjI+7AA20P/WFKSU3YRaQtUQsYhlTpxanETIiRN3SQumO/i6OTg6k0Dq1oydioY80z+IQ+TkoHr6qkSytkmq9g6J1S67pFxVGW4vWgQbpu+cTzmo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(451199021)(86362001)(38070700005)(122000001)(5660300002)(186003)(53546011)(83380400001)(33656002)(9686003)(26005)(6506007)(52536014)(8936002)(41300700001)(55016003)(71200400001)(76116006)(4326008)(7696005)(6916009)(8676002)(66556008)(2906002)(38100700002)(316002)(54906003)(66946007)(66476007)(66446008)(64756008)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXM2UVU0V3JCbXlyTDZoZ2tRNFR0QXRPK1JrVVowTms5a2RpUTQ4YmpSVFZ1?=
 =?utf-8?B?REZMWUtzMkFDdDQ5S1R5Y0d6Z3pzVGNjcVNHWEZjcWtnSHFxTEoxN21nanlH?=
 =?utf-8?B?RXFmbk9tTWJuS1FoaTJJbTVySERHanQ2T0NZY21rWE1UeXQ1SmoxUkdaSXVv?=
 =?utf-8?B?RmZ4QnY4aHB1cmkwMFBuTkVtMGxiRklPbG41eFJkM01ZbFdFdUl1M1dUbThH?=
 =?utf-8?B?TFNhWlZjQ0w0QXkrK0J3M1V2OGtOMlh6RnVGTWJaZWg2eVFvd2tPYk42Q0cz?=
 =?utf-8?B?ZmgzUE51RWtTMWdBejEwdEYvVFY4MVBkT09Rd0JRRDBic2REaURiYUlSSU43?=
 =?utf-8?B?Ri9Yd1paZ0s3aDdpMVRXckpXQ1FUcHBFbldqRE5ZV3JKcWZFRUJjOE9CaGpt?=
 =?utf-8?B?QTNlQUxBRkdUNzYzMzNxY0c0b0ZTZ3laY3pyck9UWjhJMHpZTXZBVUIxMURz?=
 =?utf-8?B?bUpQTzRSSy9hY3FEcXBERUFIQzQxM1ZETmVQWTZIemhxdG9sU3k0alAwMjBh?=
 =?utf-8?B?OHVnQkFjMlAydmlJM2xaT1p5TFp5NGw4czc5Wml2d05KeTA0VWswdGZOMnVs?=
 =?utf-8?B?V21ya1FHV0M0dzc1WWdCZmZ5KzVPUnNBdGtjWVhnZ0NUWTJHSmFDMjJPbDJO?=
 =?utf-8?B?RW9oQVRYOGluQk5XOVIvSDdlOFE4VkpvRThSN0oyNkIrTXZvS3hUK1dIMTZB?=
 =?utf-8?B?TDZ4eHVJejV4TERMUkJLYWx2RmRNcWR5TWZrMVl0dnlzOHBQM2FWb0xQR1NP?=
 =?utf-8?B?dU54Vy9BVkx3aU5ta1I3TFQ1alMxYkFoWTNFR3NiVVB3dnBqM2txU3g0ay80?=
 =?utf-8?B?SmdNVUJnSFY4VFFQMy94TUI5a0VYb2hOYmNZTmIra0tFUUFhbStJSGJsb1dY?=
 =?utf-8?B?ZjhHU1YwYWdEV0xheWFuMGIvVjB6RGh2VVJNT21RcDFJUVp5SWFFVFN2NnJY?=
 =?utf-8?B?d0ZYV0dwNER0dWlBK2cwWnZkZXAwOTNmMmNKcGo2dnlyV0lmTHZVNGxaR3Br?=
 =?utf-8?B?Vkk1aUVucE53Ni8yanp4OUhUbEcrZGczcExKaVZoa1FsbmVwOWdZekl2QWtp?=
 =?utf-8?B?Wnh1ei9LSTlFQjk2SmFUVklTQUloamJtMm00b21mMjU5QldsMStlRE1Ncy96?=
 =?utf-8?B?VTdwZHdLQmMwd2hkOEE1YTZWcG1VL1VYZXJKOTFBQ1I4RGpycDVLRnMrN21x?=
 =?utf-8?B?bzlTNlQ2Q2JWR0VTaHNtQXYwVHNwSEp1VzlmVnZWbnNXaDZXZVJMYXRFMEMz?=
 =?utf-8?B?MXFFN2pHU3ZDbEk3b0lZYzkxL2R1cGpFa1dJcVByYlNzUG1QNndYYmY5d3dH?=
 =?utf-8?B?Vm4wNUM1TGtKMExqdnE5TVFqb2lQbmRCKzJhbXFNS3ZaZ1pHaXVod25GYzZY?=
 =?utf-8?B?ZkN5UU8rS2djMGhPT0dOM2t3emNEZFVQTiszcVBlY1g0VHdUNkpVTG1vUlpZ?=
 =?utf-8?B?ZkY1VmRadE9XV2tpcFRldHpRdnA4S2R3NkxKSGlRKzJQa01EMHkzY1h2aHl5?=
 =?utf-8?B?R0tqVld5TVJOVUkveG93b2Q4UVpMb3pTSmttUDYrZUVTT0dFSFkwQjN6SDdY?=
 =?utf-8?B?SUlTN3M1eGhqNEdMeFhiM0F1TDhBNit2bXY5NEhuSnIwcFo4bVlXNGxRdHA2?=
 =?utf-8?B?aERGMm5QMGJIZlpMdjhCY0JtV1pjTlJuT1dBQys2ZHhBdXZ1RkVzdUJvblVw?=
 =?utf-8?B?VlFERVVDR3ppcUNGSGJMZ29WMi93bWh5S3JCZC9zS1YvVEdJTm5vcStnd3J4?=
 =?utf-8?B?VFZmdDArcEVCeVpldG1KcDhJRWtPQlFyUDFBb1Jrc2twM0dhZ20xdGkrWGxE?=
 =?utf-8?B?VEhhM29FMlpZdGVOYUI5cy91SGIrSEJjZDRZdjU2WVc3ZnVwSEJUWldJODYv?=
 =?utf-8?B?VnNWVkNXaUhSMHNaNXJSZXdud3hqQTVVVitjWXRyNWxnV0NaM21ybkFESXlN?=
 =?utf-8?B?TlBzdk9FMSt2dVhPUkdNVWxxZE1pTUtOVkxjZjRVUEc0ejArTXFKR2N0d0dS?=
 =?utf-8?B?bzR5YXFXSEFMQVFMN0NJUkFrRkZVZnJmaUlDN0VoUFpxOGZNUGN2K0ppRUk4?=
 =?utf-8?B?VFVHWjVPOVMyV0YydUNlazhpMUk5RnMwRlRqT095SEY3dXk3bHE0cTR3ZktX?=
 =?utf-8?Q?W5dQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90769b65-5df5-4aa1-6802-08db3045f9c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 11:08:50.3666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GYyZ/cQDhxI+jVZyk4BiK3NBhx2CtqAgUNlrStAN2Gf1yu+nQi/IbDogKmhUXvqBfVMBFoHxObYz9N9nYmT/fA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8197
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCAyOSBNYXJjaCAyMDIzIDE6NDIN
Cj4gVG86IEVtZWVsIEhha2ltIDxlaGFraW1AbnZpZGlhLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVt
bG9mdC5uZXQ7IHBhYmVuaUByZWRoYXQuY29tOyBlZHVtYXpldEBnb29nbGUuY29tOw0KPiBzZEBx
dWVhc3lzbmFpbC5uZXQ7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQ
QVRDSCBuZXQtbmV4dCAxLzRdIHZsYW46IEFkZCBNQUNzZWMgb2ZmbG9hZCBvcGVyYXRpb25zIGZv
ciBWTEFODQo+IGludGVyZmFjZQ0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9w
ZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiBPbiBUdWUsIDI4IE1hciAyMDIz
IDA2OjU0OjExICswMDAwIEVtZWVsIEhha2ltIHdyb3RlOg0KPiA+ID4gPiArICAgICBpZiAocmVh
bF9kZXYtPmZlYXR1cmVzICYgTkVUSUZfRl9IV19NQUNTRUMpDQo+ID4gPiA+ICsgICAgICAgICAg
ICAgZmVhdHVyZXMgfD0gTkVUSUZfRl9IV19NQUNTRUM7DQo+ID4gPiA+ICsNCj4gPiA+ID4gICAg
ICAgcmV0dXJuIGZlYXR1cmVzOw0KPiA+ID4gPiAgfQ0KPiA+ID4NCj4gPiA+IFNob3VsZG4ndCB2
bGFuX2ZlYXR1cmVzIGJlIGNvbnN1bHRlZCBzb21laG93Pw0KPiA+DQo+ID4gSSBkaWQgY29uc2lk
ZXIgaW5jbHVkaW5nIHRoZSB2bGFuX2ZlYXR1cmVzLCBidXQgYWZ0ZXIgY2FyZWZ1bA0KPiA+IGNv
bnNpZGVyYXRpb24sIEkgY291bGRuJ3Qgc2VlIGhvdyB0aGV5IHdlcmUgcmVsZXZhbnQgdG8gdGhl
IHRhc2sgYXQNCj4gPiBoYW5kLg0KPiANCj4gRGVjb2RlIHRoaXMgZm9yIG1lIHBsZWFzZToNCj4g
IC0gd2hhdCB3YXMgeW91IGNhcmVmdWwgY29uc2lkZXJhdGlvbg0KPiAgLSB3aGF0IGRvIHlvdSB0
aGluayB0aGUgdGFzayBhdCBoYW5kIGlzOyBhbmQNCj4gIC0gd2hhdCBhcmUgdmxhbl9mZWF0dXJl
cyBzdXBwb3NlZCB0byBtZWFuPw0KDQpJIG1pc3VuZGVyc3Rvb2QgeW91ciBwcmV2aW91cyBjb21t
ZW50Lg0KSSB0b29rIGl0IGludGVybmFsbHkgd2l0aCBMZW9uIFJvbWFub3Zza3kgYW5kIGhhbmRs
ZWQgaXQsDQpJIHdpbGwgc2VuZCBhIHYyLg0KVGhhbmtzIGZvciB5b3VyIGNvbW1lbnQuDQo=
