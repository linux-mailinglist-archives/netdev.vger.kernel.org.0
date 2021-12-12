Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28604471955
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 09:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhLLIwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 03:52:44 -0500
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com ([104.47.66.44]:14939
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229593AbhLLIwn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 03:52:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuDdMq0QBb5VPFm5q/lwWzEmOiTbX4o9dmTXxcxkCgFFbLCjte67EdLTEm40q8/VLKXIcL8h1OVeh0MGKzGf4VhVBKsS2buw8yUw3Zl+wHRI7plIgSc74heN/zJlK6Ek34OzAbbL5T9a1K443xlC7B6qjukJzBVvLuxYNticsaKf9ZUMFgOzEx0aggwsFQ+qcQU+FZ97JwnaflNYcHkWV4QTWyxiWdcsMoThYDcN6etoYavehmXvFq8pbg1dxuHbvsRolnBMUujUcuJClQ4aCeZbhK0ZWx1MVxXVCaQobaNGu85oXQQzsldk98tw5N+AxtrxnI5B9RHxwl/DaTPdeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATKU0Usss4+CmLVr1Hkgym0+kJiBuNdmh5xk8wUncps=;
 b=Ot2fQNXHQcuCmxCw0n+HAJlKOxQUQ4ig5kvfRoNWJVtE5J+X5Q3smNoxJC8esS0IfUuuzW1LcL6vP498UdMr3T03yvQ0gHlOVYqKYwijLeh1z/fcSmLo4dgTGwk4WlzTtJg1FyDjyF5pRcekqz03my59LPUCBDV4ZeIA1YWw0fHoi9Qfodhe+Dz+LSmZoUhGFwebT1pyzFilmf67W3Wrvkd7b2cAvsC+SV50BdkFBYOMYXSLDX8B1TNrwvJcduwG1dIk0PWaQwIKEddkLd3Kum97eeHJbEWpuCeTpDUSw1ohUhku7DpvrmvbOg70vYCcGYUjD74Fn7B7sq0kAky3bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ATKU0Usss4+CmLVr1Hkgym0+kJiBuNdmh5xk8wUncps=;
 b=AipKs9yd+/aICICKeFdq2Aa5EVuIyIm9+8Zhnbrkw9xyayzwKWMQFRZ3XowxKGuVevahTT6UU8OHx9TCc4tbJXvIMfuSi6WOm0gu18JZQLx5OioBEXokSeYGTrhVGKEJxcIHABQ3wn4QYrA5zJNccy8RBinRLzaw0KTU+/K/eLk=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM6PR13MB2489.namprd13.prod.outlook.com (2603:10b6:5:ca::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.9; Sun, 12 Dec
 2021 08:52:41 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::44c:707:8db:4e15%4]) with mapi id 15.20.4801.010; Sun, 12 Dec 2021
 08:52:41 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v6 net-next 05/12] flow_offload: add ops to tc_action_ops
 for flow action setup
Thread-Topic: [PATCH v6 net-next 05/12] flow_offload: add ops to tc_action_ops
 for flow action setup
Thread-Index: AQHX7N8mrQe/FeBE5kWZNDjascCX46wtsYcAgADehvA=
Date:   Sun, 12 Dec 2021 08:52:41 +0000
Message-ID: <DM5PR1301MB21726925A9CD8A7CE5847B72E7739@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-6-simon.horman@corigine.com>
 <44f072d1-331e-a09d-eaba-420f07e89ce3@mojatatu.com>
In-Reply-To: <44f072d1-331e-a09d-eaba-420f07e89ce3@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eacef86a-cd0e-4e13-9a7e-08d9bd4cc198
x-ms-traffictypediagnostic: DM6PR13MB2489:EE_
x-microsoft-antispam-prvs: <DM6PR13MB24897AA27F9C7CB30A64176EE7739@DM6PR13MB2489.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t8/7FShCsCBSd1/kwOf7zqBu1NZ4xrfIgZRHKg/qc0q1N6qojYX/x37kA702cLnH3M9La1tosUCfLbj1JDU+w0KXFMdy2gMVCc3RVAZaBCRsdqE6+4Cjeo9pLZtBX5xP1pSj9yq9zhLiAiCySm4qfOBheA6+Vr+fKojNKuhPhea0Sc57Gqu2WZ/Pj1YWdYFq63Ek4J8z/rJGGJd7tQGgmecqnx8VhQwnH+0sWhzDaoz0EMnlK0xAE5tkxr3s/9FEnbys0+GiYgpOCreQ3fFnpdd/ONP//8a+pC8Y7jLdeDZokkTio8FpvHr1y4JtHWlKM/DDgka/od6ouoYdqY/8YoKh13bYIA2lmgwhpd266QkzRAPPP8rX5moDCCeZ03s/djFeykmTrHxY1ABz+zY1bzoAGbq9OyUbNNIp6HluPoxrY3t6C5YVinW2KGw8Xzg4CvqEVJGd2p9axF2IbhYrB+QkmbGHcYJKseRjxl/N4Xi+sraazX7ppajVOfyM4X06MpjGifQUoy3SsSMRdTTkNJB76Tue4RKTk1ku61ciSkbi+pi38ojR+XEnjEgAAcpc7owHfGmuHRkeIw0oD451vU6hqNkbRihDfVjUtNipgc5jN1UaoNeyLyfnxHDOMR0p0eDFCdGLzooIzSYOI5YUnjWgwevZvcqxHubrSFi7vcNzgKa8bIpJuymJ+lhptbISz1DBEg0EZ3Lf7iDi7w1W5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(366004)(136003)(396003)(39830400003)(376002)(110136005)(44832011)(5660300002)(33656002)(52536014)(38070700005)(86362001)(71200400001)(8676002)(66476007)(2906002)(66446008)(64756008)(316002)(4326008)(66556008)(54906003)(55016003)(122000001)(8936002)(9686003)(76116006)(107886003)(26005)(6506007)(7696005)(38100700002)(186003)(508600001)(66946007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTN0RWV2Q1ByRTU5ak95NUtVWndHNE9Oc05rbG54MXBDMVMyM3N1YXRab2lF?=
 =?utf-8?B?NlV0Zlcwci9JSms1QUlPVEpHaWlOOCs1SWN5NU0vQWpadUp6eEJSeUI2d05L?=
 =?utf-8?B?THVQOFRucWJDdmRiQVIzcXhEK3BGUW9WN092WnVHT2NyU1llaEI4cmVmMDdl?=
 =?utf-8?B?d21OVm9wdUU5VHI2N3FsRFNvak9BSjRrY2doNVhLZFZaV0Rmbjg3dGsvdWJk?=
 =?utf-8?B?QmdKRUxQdkVldm1YUWh6dlVXS0E2bU9GVTAyVm44TWlaRXEwaS9BZlB3aUZE?=
 =?utf-8?B?TlpqNFBPZFk4MHZoUjRKdVp1cXR0Nmphd0FTSVk2aENBVHd1eU5WVjhDTTd3?=
 =?utf-8?B?QVdUNTVlMWVXc1ByZkx6U010SVRaeGFkOXF6Rmlmbm1pUFZ2ckhrcFRVb2xa?=
 =?utf-8?B?NHY0d2ZvelpqNVR5WTlnc3FxYUpKQVRtd2RSb21qUTlvWjcxeVFpR2ZuNW9U?=
 =?utf-8?B?U0tmWlU2OWtSd283WnZRbUtuam5hTGM5VnJpai94YkZoSlBoRURwSy9ISFdR?=
 =?utf-8?B?SVppaCtJTFBKSFJSR2ZnNTdWWTZHeFowbG9jeks5L0l5dGg4USszZC9EL2Ni?=
 =?utf-8?B?a0ZJY0ZDUlErS3JIZEpKbG1mMW1ldjczbk4zc3FaRk9TUlBRaThqY2NNakJw?=
 =?utf-8?B?WlUrMmpBcmw5RkkwTXBQVDFmbkJodEtKWTlBVWJ6Q1NzYVJkUzZXL0dWWUFR?=
 =?utf-8?B?d281ejR1dVJYOFo0NWtsNStTRjBDaDU1YWpGOXVMeTAySEwwM0haV055YUly?=
 =?utf-8?B?ak40S1Y2KzlBV3d6bTl0MXprTTN2SlBOWW9rWU9WVEl3cDBjVFdsWFE0KzlX?=
 =?utf-8?B?Z1oreXpYTlFHMUFSNDV0RGk0QTNIdk9tallKUklqWHNXRkg1WlJYZkc1cGJk?=
 =?utf-8?B?RUJaa2htMmdQdEMveGZjcG0xSmNCQ2xOVEtKL1VaTkx3RUF6dGFmeGk5cXRh?=
 =?utf-8?B?RU5FTEtPbzQrMHVRcktoUjBZdjB6S0gyUEsyQ0RWVHhnZjBWdi9QaEgvSnEr?=
 =?utf-8?B?Nld3MmRjazlncjhlZ1Y3SFkvQThzNEV5V0YyLzdIdGRNU29CK29NREY0a0JJ?=
 =?utf-8?B?RlZDa0pWMlg5M1VTV3lFTjJZNnFzS2oxZ1Z4T2RNRlpsQjNJQW1OVnoxczlH?=
 =?utf-8?B?cWpUbWdpVlUvdFlreUJPaENzREhIa3U2SWxPclFtY2Y4UW5xdFJacmdwSUFT?=
 =?utf-8?B?aUxsKzA5ZHFtYk5uY3Q3d3ZxNk1YYXVwQ1JJYmY2OWY3cktxbzA4RzM4N2J1?=
 =?utf-8?B?azZvZ01nZUVJM1NnTEZGNlorMEJLa3c4cnhCZmJpZFJDTWc1S2RXM1VGclRN?=
 =?utf-8?B?c0lBWitXRS9uMHZIS3dCTEc2SE95RmRpSHVmMlVLWkJQbzJad1dqYUEvRGx1?=
 =?utf-8?B?VU1uMnR2ZUhuSldIK2taT3FHNWNvYWZFTG9MWFZqN0RxTkJTUXVYcXhNdk1K?=
 =?utf-8?B?TjZZVTRpNnpCQTBScGhSTEF5WHJGMFM1aDRxUkNvZWROcGo4UWZ1UGlmcEV2?=
 =?utf-8?B?MnhnWDVoQmNrdzJ1YnpJSmE5aUx5K0czbUdlb1FpU1B0VjAwVXR6emlmTWNq?=
 =?utf-8?B?Q1JSakZZMmFqUEprMyt4OVBhd1oxb1VTcUxIWXdqQTk0aTA3dERXeWdzNnV0?=
 =?utf-8?B?aFNQYmFsbUFDRWc2QUV0enRQMWN0V1Jza3AzcG9XNHZlQjd5bkNISFBKQUFj?=
 =?utf-8?B?SDdjTTJiaC81clJDdDRVSDdEWUdhVTNOUlJlaUY4anFrSnlwWXhTVVJtcy9C?=
 =?utf-8?B?N2t3Rm41c3BqYUFxMzNibGpCUmRFOE01QzNXVEhFeFpQbVhpODRDNC85N2tM?=
 =?utf-8?B?cTREMk03ODdKaElMRVF5NU5KVzl5dGd4dEswS3JhWHU0Q3hwT3N1VWU2d1E3?=
 =?utf-8?B?MjZlQW81UjN2QWcxQmhtb1BlMWVobWlRTEx6L1dmS0pkREwxMWEycmUybjBt?=
 =?utf-8?B?YnNRUzZ2ZExUOHFGKy9ZbnhuekRHUW9kYUh4RFdjckptY0ZwVUNoT3ZyTWc0?=
 =?utf-8?B?STdPcG9tQk5UNm9RR1hvaWFjTjM0N1RoWSsyUXZsTmVVb3d5T1BrdzkrS2cr?=
 =?utf-8?B?SmJSWFJPalBmeFRJVGtLazhZR3Y1ZmpWRHNOZXBjbDN3QlZvNVZKU1RkMm45?=
 =?utf-8?B?ekpBS2x3UEFiYmowcmtVTGNIUm13SG5hZzFpUmp1TDRqK1JEQ2dGYXBqWStk?=
 =?utf-8?B?bEtiNDRmQnNaVi9OWlN5TVNpWjNxaGdOUkxSa1NpbmVES1hHUk5DQkRLVXJD?=
 =?utf-8?B?WSs2TnU3Sm43SzdqalBjUitvMzVBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eacef86a-cd0e-4e13-9a7e-08d9bd4cc198
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2021 08:52:41.1924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fc3PwGYapHgte6oD6SNlF+CW4xLFp3Oo8btQ/QzvooICpHZxGXoEq5nvyiIZmBZDl4bZPDhwuvrRRsbLGExrapT9vu0G+isan1edIDGzm4s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2489
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRGVjZW1iZXIgMTIsIDIwMjEgMzozMSBBTSwgSmFtYWwgSGFkaSBTYWxpbSB3cm90ZToNCj5P
biAyMDIxLTEyLTA5IDA0OjI3LCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+PiBGcm9tOiBCYW93ZW4g
WmhlbmcgPGJhb3dlbi56aGVuZ0Bjb3JpZ2luZS5jb20+DQo+Pg0KPj4gQWRkIGEgbmV3IG9wcyB0
byB0Y19hY3Rpb25fb3BzIGZvciBmbG93IGFjdGlvbiBzZXR1cC4NCj4+DQo+PiBSZWZhY3RvciBm
dW5jdGlvbiB0Y19zZXR1cF9mbG93X2FjdGlvbiB0byB1c2UgdGhpcyBuZXcgb3BzLg0KPj4NCj4+
IFdlIG1ha2UgdGhpcyBjaGFuZ2UgdG8gZmFjaWxpdGF0ZSB0byBhZGQgc3RhbmRhbG9uZSBhY3Rp
b24gbW9kdWxlLg0KPj4NCj4+IFdlIHdpbGwgYWxzbyB1c2UgdGhpcyBvcHMgdG8gb2ZmbG9hZCBh
Y3Rpb24gaW5kZXBlbmRlbnQgb2YgZmlsdGVyIGluDQo+PiBmb2xsb3dpbmcgcGF0Y2guDQo+DQo+
DQo+UGxlYXNlIG5hbWUgdGhlc2UgZnVuY3Rpb25zIHdpdGggIm9mZmxvYWQiIGluc3RlYWQgb2Yg
ImZsb3ciLg0KPkl0IGltcHJvdmVzIHJlYWRhYmlsaXR5IGJlY2F1c2UgdGhvc2UgZnVuY3Rpb25z
IGV4aXN0IGZvciB0aGUgcHVycG9zZSBvZg0KPm9mZmxvYWQuDQo+U28gaSB3b3VsZCBzYXk6DQo+
cy9YWF9zZXR1cF9mbG93X2FjdGlvbi9YWF9zZXR1cF9vZmZsb2FkX2FjdGlvbi9nDQo+aS5lDQo+
Zmxvd19hY3Rfc2V0dXAgYmVjb21lcyBvZmZsb2FkX2FjdF9zZXR1cCBhbmQgdGhpbmdzIGxpa2UN
Cj50Y2ZfZ2F0ZV9mbG93X2FjdF9zZXR1cCBiZWNvbWUgdGNmX2dhdGVfb2ZmbG9hZF9hY3Rfc2V0
dXANCj4NCj5BZ2FpbiBmcm9tIGEgbmFtaW5nIGNvbnZlbnRpb24gdGhhdCB0Y19zZXR1cF9mbG93
X2FjdGlvbiBzaG91bGQgYmUNCj50Y19zZXR1cF9vZmZsb2FkX2FjdCgpIHJlYWxseS4uDQo+TWF5
YmUgYW4gYWRkaXRpb25hbCBwYXRjaCBmb3IgdGhhdD8NCj4NClRoYW5rcyBmb3IgYnJpbmcgdGhp
cyB0byB1cy4gV2Ugd2lsbCBtYWtlIHRoZSBjaGFuZ2UgdG8gcmVuYW1lIHRoZSBmdW5jdGlvbiB3
ZSB1c2VkLiANCk1heWJlIGFkZCBhIHNpbmdsZSBwYXRjaCB0byByZW5hbWUgdGhlIG9yaWdpbmFs
IGZ1bmN0aW9uIG9mIHRjX3NldHVwX29mZmxvYWRfYWN0KCkuIA0KVGhhbmtzDQo+PFJhbnQ+DQo+
UmVhbGx5IC0gdGhpcyB3aG9sZSBuYW1pbmcgb2YgdGhpbmdzIGluIGZsb3dfb2ZmbG9hZC57Yyxo
fSBpcyB2ZXJ5IG1pc2xlYWRpbmcNCj5hbmQgc2ltcGxpc3RpYy4gSSBrbm93IGl0IGlzIG5vdCB5
b3VyIGRvaW5nLg0KPlRoZSB0ZXJtIGZsb3cgaXMgdmVyeSBtdWNoIHJlbGF0ZWQgdG8gZXhhY3Qg
bWF0Y2hlcy4gQSBiZXR0ZXIgbmFtZSB3b3VsZA0KPmhhdmUgYmVlbiAibWF0Y2giICh0aGVuIHlv
dSBkb250IGNhcmUgaWYgaXQgaXMgZXhhY3QsIHByZWZpeCwgcmFuZ2UsIHRlcm5hcnksDQo+ZXRj
KS4gTm90ZToNCj5JbiB0aGlzIGNhc2UgeW91IGNhbiBvZmZsb2FkIGFjdGlvbnMgaW5kZXBlbmRl
bnQgb2YgbWF0Y2hlcyBzbyBhIGJpbmRpbmcgdG8gYQ0KPm1hdGNoIG1heSBub3QgZXZlbiBleGlz
dC4NCj4NCj5jaGVlcnMsDQo+amFtYWwNCg==
