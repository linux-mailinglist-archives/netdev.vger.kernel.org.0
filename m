Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924A64442FD
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbhKCOFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:05:55 -0400
Received: from mail-bn7nam10on2104.outbound.protection.outlook.com ([40.107.92.104]:11201
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230527AbhKCOFw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:05:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vc24UVoDXoz9cibJ4vH7fubiHKjDw6jiBqWSx/i2/fh+0oYnjB0EmVVJO7NdbeOGLfQNar0GeDuNveONZRGx0RHsiP4r9zkp8aZPQ+D2Ti78VgOwbbmi/VYR+/r8hFRs84ziNTW7nO0ZGBE04KXdpGoRXHMXw1oX304WEYBhqGQWEmsBrsG786W1rP9aQHCMlTV7jqaFMfQuP45mu3BGY2wXXtN5AcKTW/zHUqz4gcu2wflAxzQc9WYOcYxNClEqL3peG6w22dTy5Yon8oc61DljYK9fErNlNyEjMXWcvTXn9NYVWuA5i+sI5IIyS6FCEoMwC3p1DKprVnsfi28pdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LUpl4TwNbBVlWGPteymGiVrHOeviE9KX60GeMBgWnqQ=;
 b=Ic/TajMftdA1U8sMV/iaD6PxSbMicCwiM+V57/wJ9MbdeLku/b9TLsCiEOlymskvOBbsNRZe2lCY65JuxiGGiAV34UxY5i4Qel8yHzCLi5I5HSseU9qcckL8lMyzLXfPtT059GUzNfZuV+0+EJ9Ax4e7s9P1kTeQNQpcIrvH4L60+QqityGheTvwGJBKTN/Q36N3fGxDvsin3zI0jgO6Il4QINH7/h8kgSvwlx5ZxioaJvKylgsIumcJyCroDfCS2TWGGejbyji4y666LDuBIM+XKTURoe7lOQ1ErNIn95EFxvbmvz6pwPi67g+67XeiqR5DT0qn6agr+9L8ZGXK2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LUpl4TwNbBVlWGPteymGiVrHOeviE9KX60GeMBgWnqQ=;
 b=BddjCQa2H1P5+bzWbpyomSoD/S5tH0ko8FdsNxId8zxM8f6v0IoUV4V1oRr3J87qKuhbJ3dai2gyWF96bqlBko36TdoTDq7E42ciZnb01QuPQbeb4YnMhcwWK3WueWgAPlNk8rRv3w6LoBMMg9TShP0i3bBzfTJu1DmUGaKo7Qo=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB4464.namprd13.prod.outlook.com (2603:10b6:5:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.4; Wed, 3 Nov
 2021 14:03:13 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::54dd:e9ff:2a5b:35e%5]) with mapi id 15.20.4669.010; Wed, 3 Nov 2021
 14:03:13 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: RE: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Topic: [RFC/PATCH net-next v3 8/8] flow_offload: validate flags of
 filter and actions
Thread-Index: AQHXy+v7vBQ2XbePHEaO7o5JqSPS/avqRgqAgAEbH4CAAECyAIAAv3npgAC92QCAAOYhwIAAScwAgAHmiwCAAUGbwIAAJ94AgAASrMCAABR9gIAAEMIAgAAE2XA=
Date:   Wed, 3 Nov 2021 14:03:13 +0000
Message-ID: <DM5PR1301MB2172BFF79D57D28F34DC6A0AE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211028110646.13791-1-simon.horman@corigine.com>
 <20211028110646.13791-9-simon.horman@corigine.com>
 <ygnhilxfaexq.fsf@nvidia.com>
 <7147daf1-2546-a6b5-a1ba-78dfb4af408a@mojatatu.com>
 <ygnhfssia7vd.fsf@nvidia.com>
 <DM5PR1301MB21722A85B19EE97EFE27A5BBE7899@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <d16042e3-bc1e-0a2b-043d-bbb62b1e68d7@mojatatu.com>
 <DM5PR1301MB21728931E03CFE4FA45C5DD3E78A9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <ygnhcznk9vgl.fsf@nvidia.com> <20211102123957.GA7266@corigine.com>
 <DM5PR1301MB2172F4949E810BDE380AF800E78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <428057ce-ccbc-3878-71aa-d5926f11248c@mojatatu.com>
 <DM5PR1301MB2172AD191B6A370C39641E3FE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <66f350c5-1fd7-6132-3791-390454c97256@mojatatu.com>
 <10dae364-b649-92f8-11b0-f3628a6f550a@mojatatu.com>
In-Reply-To: <10dae364-b649-92f8-11b0-f3628a6f550a@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c38e9c0d-6811-4dc0-60a5-08d99ed2ad6c
x-ms-traffictypediagnostic: DM6PR13MB4464:
x-microsoft-antispam-prvs: <DM6PR13MB4464BED92A3AA2F0A2C7BF8CE78C9@DM6PR13MB4464.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:341;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ztj0YDflsb9eBNXWDrbxvaxJSp1Va97GJ8j7vCX1LoKqXT6rhfXRfOGKqZQczsON9g1OAUakbsWxbDOOvLkTmp79XeP+FObp10QKwx/ipLP+mmtQCWaP6/mZhdPPy/CPDLB9jAQZUBxYVujBCciyr+P1WBcwsIYwql+gOvB3emiX+nyvuJnGHRcoxGqhJMdBk44YW6+0VQO/C/jwhBjP10qNs3u3tH7lc8RAZHNgfl14FLBKNyeBWJcEB6TD+HVmnX4dgyJ/KE8BeoMqrbczbvFE/gtGAeo95lrti205x2wfj0C0uQ2osqJNTr3IpXs+j6dEBLE9zSZdXu/J8Qt1+WKojGnS/8sNN4Gky/3KvqgpRYCDCKPJX46s4OfMMYNTLG7h29ehS5EY/PGetvy4DJ/P++V6PgKiGemkzffgSRH8TKfAupFHO+oM66xhjwXl0pJC+X7nxMMLcLPWSRTcxrBQIwfkNBIuGEDCGa2X58zEvcvHjK/kDQqORZQZcdSx90LZHqsr9ELqFEA0rcE1SxoY/HUCGgnCr76z/sUX1E/0hhOYZeG8oKUXw7U6XA4aIoXpiDNugDSYG7bAwtWVCQ/IS+a3oJ1kSGuhO+JQdZJo45Ihi5CPi6zbiPIHxVx0+EJyjbOkTpd2eijPYgV8dePZj4cVVxIy5i19NEnhrICoYnx2jctCK6W/nYql7B7zjzjy4iZDC//clSHDcpmANw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39830400003)(376002)(346002)(366004)(396003)(316002)(54906003)(8936002)(76116006)(508600001)(33656002)(122000001)(71200400001)(66476007)(110136005)(66446008)(64756008)(38100700002)(66556008)(55016002)(44832011)(66946007)(186003)(8676002)(26005)(4326008)(9686003)(52536014)(2906002)(6506007)(53546011)(86362001)(38070700005)(7696005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnFGd0lhUXh6elBpNXlVSTdDN21SMjAxbnlDVzBzeU5DWjlNN0pONUJqY1FS?=
 =?utf-8?B?bHFocTJFekRuWXlaQnVHMDl4M2tKQ041cXM1TGFHNXZ6U0NoSmJEcmdPZ1NT?=
 =?utf-8?B?VkQxalFBbG1kbnV0Tnh1N3FYdnd6Y1ZtN1B0QmhmMFlVVnFkeDZGSEY3OHI4?=
 =?utf-8?B?WDVKdWZjdTF4eWl5U1NnQkpCMmdlakNTNXYxcC9WdnM0eU9qTHA4VmlqUk1Q?=
 =?utf-8?B?NlRhTG40YzY1aFBtTjFjeVVYN3FBaU41dUpOeEJ1RGcrVlIxMWJwYWZsbzFq?=
 =?utf-8?B?aklUL05xeWZGT01Nbmp0NDJSdEora24yNjVtcFYrTnpMVklJNmIwdUdqQjlm?=
 =?utf-8?B?VUNIeXhXbWJqeHE5ZE9rSnNGRkkycUhCaUdTcEh2c3Y0STJla2FUTDVWRVph?=
 =?utf-8?B?bytrc0hlRTNSRitUT2hEa2krS0M3RDMwUHQ1MjQ0Y0FIbUZEQ1pOQThZTGpS?=
 =?utf-8?B?UzhJR21rSERSbmxyWHR0TVh4b0E1K2VpcE5sTnVGb3V2dEFBWVpXVmZNVFdL?=
 =?utf-8?B?cGhHR0pEd2dUdHFROGhpRVFMWG9sT3hxS2g2Z2ZCUlJ4UnVWNGNzMDRLTG4z?=
 =?utf-8?B?YlJ3Q2xRQ2RvU3NtQkFTcUJrc00yZDZ1anYwdHl1eFR6V3dRTm5hRTh1c3dR?=
 =?utf-8?B?S3dVc1EwcEF4OUN3d2tZWmxDUThXell5eHU5WXdGUi9JVEdlN0N3SnJDd2xK?=
 =?utf-8?B?bmd3NDAwTzlocHYwN1oxQndGMEdpeTc1SS90dHMzMUxhSmp1VmpEbFRSbk5H?=
 =?utf-8?B?Y0ZvT0hnN2M5YTRUYkNIRXF6bStkS1RnTEc5U3dXVXNjSFNxWEJxVVBFOXBW?=
 =?utf-8?B?YWMrMkRYOWcxQUtUdklQWk02M2l4V01zMkJsM0Z0UWxadm0rNHF6QWw4UFNs?=
 =?utf-8?B?MzFHRzBKbkxMVnF4eWVabjBRa3Nmcll6bHVmUzVtOGJhM2ZxQmxmaGR1R0s5?=
 =?utf-8?B?cUx4SVBMYU5vZnI5b0JVTjIxVlcyME56NXlHMi9vSy9SdTJZdXpZOTE5R3pL?=
 =?utf-8?B?WC9GN3c1aDdIRW5FOFpka0dZRWJEWU45NHZ5UUtvaWx6djNRc2dLeStJYUNn?=
 =?utf-8?B?bmVTdkNWVHI1QlBJMllMM2ZDMExrZTZHM3RPM0VEZ2N5N2FlU2NFeER4Qy9H?=
 =?utf-8?B?QS9hWVJjbEp0SWRhN1lZOUcvaWtxM1Y3bHQrbWh2WWRobWFVUlVMR2tJK0Vi?=
 =?utf-8?B?dFFFV3VpUDc1dGw1RWZwaDJDUElxVGc0RGVSYkxEUm5Sb1NidEI5ZGV2Y0V2?=
 =?utf-8?B?LzBMdzVlUTNDNUdkMy9MQ1RNWTJrY1VOT1pwaUI4T0JrU1VBcWdQNEFRYlNr?=
 =?utf-8?B?T2s2RjRaSnhVWW1OWHYyeHF3MkhpNVJNcjRCQ25FOHJocnZmeDdiMGFFb043?=
 =?utf-8?B?RkVuZHo2aXV5MXRTaEhKSFBVeTFXNE1aN2pOWjBhRk9CcHZDcWJrcEpwNm1W?=
 =?utf-8?B?VzNKc3RMTHpQbUlQc1IvSmVPOW1OOG05TnVWcFFoVTl3OUs0Qk82Qk9HY3pV?=
 =?utf-8?B?b3UrVjJKYzVORTZSM1F0a2tLYS9rSWtBVVVBYkZmNXJkdUxsaEtJZ0QwWC9H?=
 =?utf-8?B?Z29majB1M2l3aURHazY0WDdLVEVWdGhCUGp4dzE1V2JtZzdlSG9mVEFva1lt?=
 =?utf-8?B?b3hBWjBPaDhnUFpjRGExOVRHMUhuR0RSMW1hMTR6bWhvR1QxOG9hbVJUVlgw?=
 =?utf-8?B?a3puSTZ0bE5uVTZTMUptUkRFNkRsbllNQm1VT0lQOHVQbjF6T3RIcmhBaXdS?=
 =?utf-8?B?NVJIREhudmZ3K2hxb0RQcjA0OWw4cGpBbXFjdVFBR3FmOVBTQk15dDJreTZO?=
 =?utf-8?B?VEozdjRqMFJ1YlVnVjl5OENtbVJFM2FrMmFwb3dQLzZ0Mi9GNXYvblZEWGNn?=
 =?utf-8?B?aEdrY01tLzNldnhTdE9TaTlmVjlDWXVhYTVLcG05S2VlNGo4ZmJtb3R3L2pj?=
 =?utf-8?B?OVUwOGVzV0txdUtqZU42b1FDSHcyd2V5MHdmUVZIbEpFSkpQNFcraXQ3blFN?=
 =?utf-8?B?ZjhrS3dtSDdPOCt1T25ZaTM1ZWNKYUx0QTNwbDFxbzdFQzdsMWtrVlYrcE5s?=
 =?utf-8?B?b0hEZStUWnRaUUlSSjBuaGhMQU00czFLRnNwVGw0TmhSTWdncWhBSkhheXlG?=
 =?utf-8?B?MGhWZkJJOG5FZXNnZ3FUU3ZubUJMbUtuRVJMWVdlaTZLaFFXQVcyMmVaVEJO?=
 =?utf-8?B?ek8zTE9uejJ5VlpkNE54Ny91MGVtcFV4UitEU0FRcVR1UVZBRGFnNXk1KzlH?=
 =?utf-8?B?NTNOK1hIVjZFQmJ4THhQZ0o4Q1VnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c38e9c0d-6811-4dc0-60a5-08d99ed2ad6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 14:03:13.8798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Eeus1+rii29QIKf4fkyGmNuLVhWxJ+BHm8HWZofslonI9gIAh6CVtlCfKRx91VlGjQ9X9RcR8qcxbKrHJMwmTK4qPQZ6wbxy9M7qEW7hOYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4464
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHJlcGx5Lg0KT24gTm92ZW1iZXIgMywgMjAyMSA5OjM0IFBNLCBKYW1h
bCBIYWRpIFNhbGltIHdyb3RlOg0KPk9uIDIwMjEtMTEtMDMgMDg6MzMsIEphbWFsIEhhZGkgU2Fs
aW0gd3JvdGU6DQo+PiBPbiAyMDIxLTExLTAzIDA3OjMwLCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+
Pj4gT24gTm92ZW1iZXIgMywgMjAyMSA2OjE0IFBNLCBKYW1hbCBIYWRpIFNhbGltIHdyb3RlOg0K
Pj4+PiBPbiAyMDIxLTExLTAzIDAzOjU3LCBCYW93ZW4gWmhlbmcgd3JvdGU6DQo+Pj4+PiBPbiBO
b3ZlbWJlciAyLCAyMDIxIDg6NDAgUE0sIFNpbW9uIEhvcm1hbiB3cm90ZToNCj4+Pj4+PiBPbiBN
b24sIE5vdiAwMSwgMjAyMSBhdCAwOTozODozNEFNICswMjAwLCBWbGFkIEJ1c2xvdiB3cm90ZToN
Cj4+Pj4+Pj4gT24gTW9uIDAxIE5vdiAyMDIxIGF0IDA1OjI5LCBCYW93ZW4gWmhlbmcNCj4+Pj4N
Cj4+Pj4gWy4uXQ0KPj4+Pj4+Pg0KPj4+Pj4+PiBNeSBzdWdnZXN0aW9uIHdhcyB0byBmb3JnbyB0
aGUgc2tpcF9zdyBmbGFnIGZvciBzaGFyZWQgYWN0aW9uDQo+Pj4+Pj4+IG9mZmxvYWQgYW5kLCBj
b25zZWN1dGl2ZWx5LCByZW1vdmUgdGhlIHZhbGlkYXRpb24gY29kZSwgbm90IHRvDQo+Pj4+Pj4+
IGFkZCBldmVuIG1vcmUgY2hlY2tzLiBJIHN0aWxsIGRvbid0IHNlZSBhIHByYWN0aWNhbCBjYXNl
IHdoZXJlDQo+Pj4+Pj4+IHNraXBfc3cgc2hhcmVkIGFjdGlvbiBpcyB1c2VmdWwuIEJ1dCBJIGRv
bid0IGhhdmUgYW55IHN0cm9uZw0KPj4+Pj4+PiBmZWVsaW5ncyBhYm91dCB0aGlzIGZsYWcsIHNv
IGlmIEphbWFsIHRoaW5rcyBpdCBpcyBuZWNlc3NhcnksIHRoZW4gZmluZSBieQ0KPm1lLg0KPj4+
Pj4+DQo+Pj4+Pj4gRldJSVcsIG15IGZlZWxpbmdzIGFyZSB0aGUgc2FtZSBhcyBWbGFkJ3MuDQo+
Pj4+Pj4NCj4+Pj4+PiBJIHRoaW5rIHRoZXNlIGZsYWdzIGFkZCBjb21wbGV4aXR5IHRoYXQgd291
bGQgYmUgbmljZSB0byBhdm9pZC4NCj4+Pj4+PiBCdXQgaWYgSmFtYWwgdGhpbmtzIGl0cyBuZWNl
c3NhcnksIHRoZW4gaW5jbHVkaW5nIHRoZSBmbGFncw0KPj4+Pj4+IGltcGxlbWVudGF0aW9uIGlz
IGZpbmUgYnkgbWUuDQo+Pj4+PiBUaGFua3MgU2ltb24uIEphbWFsLCBkbyB5b3UgdGhpbmsgaXQg
aXMgbmVjZXNzYXJ5IHRvIGtlZXAgdGhlDQo+Pj4+PiBza2lwX3N3IGZsYWcgZm9yIHVzZXIgdG8g
c3BlY2lmeSB0aGUgYWN0aW9uIHNob3VsZCBub3QgcnVuIGluIHNvZnR3YXJlPw0KPj4+Pj4NCj4+
Pj4NCj4+Pj4gSnVzdCBjYXRjaGluZyB1cCB3aXRoIGRpc2N1c3Npb24uLi4NCj4+Pj4gSU1PLCB3
ZSBuZWVkIHRoZSBmbGFnLiBPeiBpbmRpY2F0ZWQgd2l0aCByZXF1aXJlbWVudCB0byBiZSBhYmxl
IHRvDQo+Pj4+IGlkZW50aWZ5IHRoZSBhY3Rpb24gd2l0aCBhbiBpbmRleC4gU28gaWYgYSBzcGVj
aWZpYyBhY3Rpb24gaXMgYWRkZWQNCj4+Pj4gZm9yIHNraXBfc3cgKGFzIHN0YW5kYWxvbmUgb3Ig
YWxvbmdzaWRlIGEgZmlsdGVyKSB0aGVuIGl0IGNhbnQgYmUNCj4+Pj4gdXNlZCBmb3Igc2tpcF9o
dy4NCj4+Pj4gVG8gaWxsdXN0cmF0ZQ0KPj4+PiB1c2luZyBleHRlbmRlZCBleGFtcGxlOg0KPj4+
Pg0KPj4+PiAjZmlsdGVyIDEsIHNraXBfc3cNCj4+Pj4gdGMgZmlsdGVyIGFkZCBkZXYgJERFVjEg
cHJvdG8gaXAgcGFyZW50IGZmZmY6IGZsb3dlciBcDQo+Pj4+IMKgwqDCoMKgIHNraXBfc3cgaXBf
cHJvdG8gdGNwIGFjdGlvbiBwb2xpY2UgYmxhaCBpbmRleCAxMA0KPj4+Pg0KPj4+PiAjZmlsdGVy
IDIsIHNraXBfaHcNCj4+Pj4gdGMgZmlsdGVyIGFkZCBkZXYgJERFVjEgcHJvdG8gaXAgcGFyZW50
IGZmZmY6IGZsb3dlciBcDQo+Pj4+IMKgwqDCoMKgIHNraXBfaHcgaXBfcHJvdG8gdWRwIGFjdGlv
biBwb2xpY2UgaW5kZXggMTANCj4+Pj4NCj4+Pj4gRmlsdGVyMiBzaG91bGQgYmUgaWxsZWdhbC4N
Cj4+Pj4gQW5kIHdoZW4gaSBkdW1wIHRoZSBhY3Rpb25zIGFzIHNvOg0KPj4+PiB0YyBhY3Rpb25z
IGxzIGFjdGlvbiBwb2xpY2UNCj4+Pj4NCj4+Pj4gRm9yIGRlYnVnYWJpbGl0eSwgSSBzaG91bGQg
c2VlIGluZGV4IDEwIGNsZWFybHkgbWFya2VkIHdpdGggdGhlIGZsYWcNCj4+Pj4gYXMgc2tpcF9z
dw0KPj4+Pg0KPj4+PiBUaGUgb3RoZXIgZXhhbXBsZSBpIGdhdmUgZWFybGllciB3aGljaCBzaG93
ZWQgdGhlIHNoYXJpbmcgb2YgYWN0aW9uczoNCj4+Pj4NCj4+Pj4gI2FkZCBhIHBvbGljZXIgYWN0
aW9uIGFuZCBvZmZsb2FkIGl0IHRjIGFjdGlvbnMgYWRkIGFjdGlvbiBwb2xpY2UNCj4+Pj4gc2tp
cF9zdyByYXRlIC4uLiBpbmRleCAyMCAjbm93IGFkZA0KPj4+PiBmaWx0ZXIxIHdoaWNoIGlzDQo+
Pj4+IG9mZmxvYWRlZCB1c2luZyBvZmZsb2FkZWQgcG9saWNlciB0YyBmaWx0ZXIgYWRkIGRldiAk
REVWMSBwcm90byBpcA0KPj4+PiBwYXJlbnQgZmZmZjoNCj4+Pj4gZmxvd2VyIFwNCj4+Pj4gwqDC
oMKgwqAgc2tpcF9zdyBpcF9wcm90byB0Y3AgYWN0aW9uIHBvbGljZSBpbmRleCAyMCAjYWRkIGZp
bHRlcjINCj4+Pj4gbGlrZXdpc2Ugb2ZmbG9hZGVkIHRjIGZpbHRlciBhZGQgZGV2ICRERVYxIHBy
b3RvIGlwIHBhcmVudCBmZmZmOg0KPj4+PiBmbG93ZXIgXA0KPj4+PiDCoMKgwqDCoCBza2lwX3N3
IGlwX3Byb3RvIHVkcCBhY3Rpb24gcG9saWNlIGluZGV4IDIwDQo+Pj4+DQo+Pj4+IEFsbCBnb29k
IGFuZCBmaWx0ZXIgMSBhbmQgMiBhcmUgc2hhcmluZyBwb2xpY2VyIGluc3RhbmNlIHdpdGggaW5k
ZXggMjAuDQo+Pj4+DQo+Pj4+ICNOb3cgYWRkIGEgZmlsdGVyMyB3aGljaCBpcyBzL3cgb25seSB0
YyBmaWx0ZXIgYWRkIGRldiAkREVWMSBwcm90bw0KPj4+PiBpcCBwYXJlbnQgZmZmZjogZmxvd2Vy
IFwNCj4+Pj4gwqDCoMKgwqAgc2tpcF9odyBpcF9wcm90byBpY21wIGFjdGlvbiBwb2xpY2UgaW5k
ZXggMjANCj4+Pj4NCj4+Pj4gZmlsdGVyMyBzaG91bGQgbm90IGJlIGFsbG93ZWQuDQo+Pj4gSSB0
aGluayB0aGUgdXNlIGNhc2VzIHlvdSBtZW50aW9uZWQgYWJvdmUgYXJlIGNsZWFyIGZvciB1cy4g
Rm9yIHRoZSBjYXNlOg0KPj4+DQo+Pj4gI2FkZCBhIHBvbGljZXIgYWN0aW9uIGFuZCBvZmZsb2Fk
IGl0DQo+Pj4gdGMgYWN0aW9ucyBhZGQgYWN0aW9uIHBvbGljZSBza2lwX3N3IHJhdGUgLi4uIGlu
ZGV4IDIwICNOb3cgYWRkIGENCj4+PiBmaWx0ZXI0IHdoaWNoIGhhcyBubyBmbGFnIHRjIGZpbHRl
ciBhZGQgZGV2ICRERVYxIHByb3RvIGlwIHBhcmVudA0KPj4+IGZmZmY6IGZsb3dlciBcDQo+Pj4g
wqDCoMKgwqDCoCBpcF9wcm90byBpY21wIGFjdGlvbiBwb2xpY2UgaW5kZXggMjANCj4+Pg0KPj4+
IElzIGZpbHRlcjQgbGVnYWw/DQo+Pg0KPj4gWWVzIGl0IGlzIF9iYXNlZCBvbiBjdXJyZW50IHNl
bWFudGljc18uDQo+PiBUaGUgcmVhc29uIGlzIHdoZW4gYWRkaW5nIGEgZmlsdGVyIGFuZCBzcGVj
aWZ5aW5nIG5laXRoZXIgc2tpcF9zdyBub3INCj4+IHNraXBfaHcgaXQgZGVmYXVsdHMgdG8gYWxs
b3dpbmcgYm90aC4NCj4+IGkuZSBpcyB0aGUgc2FtZSBhcyBza2lwX3N3fHNraXBfaHcuIFlvdSB3
aWxsIG5lZWQgdG8gaGF2ZSBjb3VudGVycyBmb3INCj4+IGJvdGggcy93IGFuZCBoL3cgKHdoaWNo
IGkgdGhpbmsgaXMgdGFrZW4gY2FyZSBvZiB0b2RheSkuDQo+Pg0KPj4NCj4NCj5BcG9sb2dpZXMs
IGkgd2lsbCBsaWtlIHRvIHRha2UgdGhpcyBvbmUgYmFjay4gQ291bGRudCBzdG9wIHRoaW5raW5n
IGFib3V0IGl0IHdoaWxlDQo+c2lwcGluZyBjb2ZmZWU7LT4gVG8gYmUgc2FmZSB0aGF0IHNob3Vs
ZCBiZSBpbGxlZ2FsLiBUaGUgZmxhZ3MgaGF2ZSB0byBtYXRjaA0KPl9leGFjdGx5XyBmb3IgYm90
aCAgYWN0aW9uIGFuZCBmaWx0ZXIgdG8gbWFrZSBhbnkgc2Vuc2UuIGkuZSBpbiB0aGUgYWJvdmUg
Y2FzZQ0KPnRoZXkgYXJlIG5vdC4NClRoYW5rcy4gSSB0aGluayB3ZSBoYXZlIGdldCBhZ3JlZW1l
bnQgdGhhdCBmaWx0ZXI0IGlzIGlsbGVnYWwuIA0KU29ycnkgZm9yIG1vcmUgY2xhcmlmaWNhdGlv
biBhYm91dCBhbm90aGVyIGNhc2UgdGhhdCBWbGFkIG1lbnRpb25lZDogDQojYWRkIGEgcG9saWNl
ciBhY3Rpb24gd2l0aCBza2lwX2h3DQp0YyBhY3Rpb25zIGFkZCBhY3Rpb24gcG9saWNlIHNraXBf
aHcgcmF0ZSAuLi4gaW5kZXggMjANCiNOb3cgYWRkIGEgIGZpbHRlcjUgd2hpY2ggaGFzIG5vIGZs
YWcNCnRjIGZpbHRlciBhZGQgZGV2ICRERVYxIHByb3RvIGlwIHBhcmVudCBmZmZmOiBmbG93ZXIg
XA0KICAgICAgIGlwX3Byb3RvIGljbXAgYWN0aW9uIHBvbGljZSBpbmRleCAyMA0KSSB0aGluayB0
aGUgZmlsdGVyNSBjb3VsZCBiZSBsZWdhbCwgc2luY2UgaXQgd2lsbCBub3QgcnVuIGluIGhhcmR3
YXJlLiANCkRyaXZlciB3aWxsIGNoZWNrIGZhaWxlZCB3aGVuIHRyeSB0byBvZmZsb2FkIHRoaXMg
ZmlsdGVyLiBTbyB0aGUgZmlsdGVyNSB3aWxsIG9ubHkgcnVuIGluIHNvZnR3YXJlLg0KV0RZVD8N
Cg==
