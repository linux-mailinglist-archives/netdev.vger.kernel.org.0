Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024D5456AA0
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 08:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhKSHG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 02:06:59 -0500
Received: from mail-dm6nam12on2102.outbound.protection.outlook.com ([40.107.243.102]:35931
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230169AbhKSHG7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 02:06:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUUsQSEm8HRwudf6zn7qS8pwtO6c+FeysQNAn23ACsm525SYTdvDm6/nh08dtHrJzwCB8eKOu86YXyVbc1jvGy6vKq8PdSKvUTAusGqNK4btUf+zkX7yIgHmGB9D97TW64k9e+o/3kPhTV4xmZTnkDUODfRyVofPXek4oSdZdXxQkEDNjbMnaARXpBA/sHd15XjxPHNOsymF0TVvoHtigwPEsCvTele6bvHNvl59HZuICM297SPD4/zaRnM206dOJDtc+CXwN18kybh/6reckLOa6AQ4PoonCwuswTl+EE1dwAqyod6flUGRWvcnPn1FNA0j2fY5ES02svQdQ1NOxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EOuTTOU5tR49ep0/Fap4mMlNqpcWR41PXeqr1BPapQk=;
 b=KkiFlG6RMvTLTC0GS6uHjqIDBX2Cj0pQ4ryno82n7jv1YQfLnnvkmhJLFfEZ0cn84OU3Vl9kXjkoiutREnKQ1YlkCivY+DKFVAnKZVDpjKk5EgJBKbLe5y5hDJw1hGh50LiOyqG+Db16DDkeV8kQZSxpDvjgDOQCkSO66pXu72SgPhYspWZuy1XraPiBjLY/6kaS7sEZLf0OIuP4mZ5t/dD7IyHchmAUEVfczrsLkRn4fVrNlfwkzXzM6z3aEA9g6oPzfcHpKHrJMK31HVxa0ucn/iGCAoZCgIpR0/QwVarh+qgSjedyATS6S4feyfddQJC+Yvs0bqUtzCkkvYRPkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EOuTTOU5tR49ep0/Fap4mMlNqpcWR41PXeqr1BPapQk=;
 b=cS8cXjvUKHwU3Kwd7ZgIeBawEzEseqHW7Krm8Mp4t/g7j+6ddz4/am/Ce1HmqS7jlgG5pOKfMQ8yGT4CXWQMRJmcyTEOXweml22YbH7z4NDxy5rQEMXS62y3GkGxQhb9nzOXKSh77qU05MEl/boua15ERNIjlWeoayITzHdcpm4=
Received: from CY4PR1301MB2167.namprd13.prod.outlook.com
 (2603:10b6:910:43::20) by CY4PR13MB1302.namprd13.prod.outlook.com
 (2603:10b6:903:9f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 19 Nov
 2021 07:03:54 +0000
Received: from CY4PR1301MB2167.namprd13.prod.outlook.com
 ([fe80::293d:a4b4:da7e:9591]) by CY4PR1301MB2167.namprd13.prod.outlook.com
 ([fe80::293d:a4b4:da7e:9591%7]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 07:03:53 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers <oss-drivers@corigine.com>
Subject: RE: [PATCH v4 03/10] flow_offload: add index to flow_action_entry
 structure
Thread-Topic: [PATCH v4 03/10] flow_offload: add index to flow_action_entry
 structure
Thread-Index: AQHX3H1eQ++rcmn/P0+qkle4n9pecawKZRaAgAAHNrA=
Date:   Fri, 19 Nov 2021 07:03:53 +0000
Message-ID: <CY4PR1301MB2167088542EFA12ABACF502DE79C9@CY4PR1301MB2167.namprd13.prod.outlook.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
        <20211118130805.23897-4-simon.horman@corigine.com>
 <20211118223107.183dad75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211118223107.183dad75@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47d9226c-3179-4df1-fc2d-08d9ab2abf75
x-ms-traffictypediagnostic: CY4PR13MB1302:
x-microsoft-antispam-prvs: <CY4PR13MB13027FD82CB02B12F12E8980E79C9@CY4PR13MB1302.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UUl/Xxms17rV/yv0VVvF7RoqR9M70E35Cr+xZI7Nzo5GJtTgnjb8V/j0wNvo6VxtpvoXJIND2jOU8eMrQNQfyiQGWz5NVT3OrerBTbMhHfFfW/vCHOvCukZtLc7H7EO6onl4GT9AJxfXagjqUgyr69I5qO9EgftIocEmepOlT55YGqtA/nt8kvf/XON5HJonr+JED7kgykscrZz72D6tMQMGHKdWNZkiE3nr+8YVeJHwu70bgUs9N/4N+n2h1QKzs3xlQ+b6CPUVhygBkar1qTHsB/HU2BGjJheOdfCKVujv6dTbEl8bTy19AnDXlz1FM33c3cJF33988b8u7g8rARjnYdYEmDpOtr2JlQbBBzavac90qBbe6AT+0LqWLDgA1dhAduZ1Sq68XaePl5WsivQ30Y5ZlOywRv1mwP4xj9ngMuYrrQIeLk7x1OPd2ziVEHl80HG1qSIoBIttu0ZKdZpiFR2egiFVZh5z4CQIOGpK9Jwc6uGxB410IvhRr5wR/0wczZjKze+GJUs24elVspIH3e1UxAC4S5ZQ9fKbkDFGu2jjEaw1Oo8n/I6C4bKXDQElZ3ZN07qExppjSjQPJ9JReHJuou9zp4fZzps842JX/dfsUMjEOdqk8OxKNEmrippoq7aRpoMWLbcrQk4aiqQUmimsgXCihh1dY+DYBkVRFgtNDywfls4beCigpquuv4/MDEwVbpoks25zBmJn2WH2OP42h/T9U5urU2+Kr3pd7S+FvDdYDddJu1Y8VZsb
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1301MB2167.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(396003)(376002)(346002)(136003)(33656002)(508600001)(5660300002)(6636002)(55016002)(26005)(107886003)(6506007)(44832011)(52536014)(66446008)(7696005)(54906003)(9686003)(186003)(38100700002)(8676002)(83380400001)(38070700005)(4744005)(64756008)(86362001)(66556008)(66476007)(66946007)(71200400001)(110136005)(122000001)(316002)(8936002)(2906002)(4326008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UHhrc0lLa2h4ams4ZERucDBuWVhWanZPWFBoU0tIZGM1Uzk0a0lweFdUeisv?=
 =?utf-8?B?enZTejNpMDdiTDJ6YTFNSnpBZVNYM0tOUW02U1hKajNsRDFJenQ3ajBHV1l6?=
 =?utf-8?B?bHdYUkc5ZzBFSW5adWtteDdDWW15MXlWNG16NS90VGhiQzJjdEh0bU9SOCt3?=
 =?utf-8?B?cHJhRDNQbUdMeXN3OGdvb0VyUmhnZE9tcjhrb3F4U3FEWUw3S3N3cndFYlo2?=
 =?utf-8?B?RjM4RXZ1c3RVVDRPQk4zb2ovcFR1aWo0NEFEelBzQy9qT2xmL1p3d0F6WFNH?=
 =?utf-8?B?R09BdjVIaDl0VWEvK1pOYVkzZXgzVWlqSjhwb0V4VXUvbVk3bDZESnRKSjFh?=
 =?utf-8?B?Sncwbng4b3R1WjAzTmRaZjNpN1MxdHhONmNmSE9FNDdLM3B2bUx6TlQ5em5m?=
 =?utf-8?B?c0ViUE9lZEhMenRBU3dkQ1ZNOUhJMFJvK1V1NU9hdnJuWXFESlVOVm5zS2Vs?=
 =?utf-8?B?eXg4OHZOWHJNdmpyb1RNOGNVem1DQlllM1NoQS9YVDIzNnZCWDEvWFFRb1hJ?=
 =?utf-8?B?Wk9Ibm9LYzNvUlQ1bnYyMTZxazhvNHNGZFd3eTdRcTNWVUxXNmRnb3M0bmlI?=
 =?utf-8?B?NUZMREVRSWRGdHpkYlpTL2t0QmsxSUtsZjZhbFU1em1FR1ZEdktoWklnalI3?=
 =?utf-8?B?MEdnRkhXOTlUdnRoc2xSUHpuYkVoRG5tSTF5cFVMaGdOUnZJU0FyRm4rVkRt?=
 =?utf-8?B?dWlEbFlaRXhkeHVvcUs0cW5yQ045S1k4aGI5a2pYNkgzMi95eXIxT2VjS0p2?=
 =?utf-8?B?WTRqQU9lL2t2UnlNWE5MZ0c3cFR1OHQxeHoyV2ZKUU9OVTJ4RDVvYi90TnJ5?=
 =?utf-8?B?UFI0YjdVNWlITEJ0czh1Q243cE1GQ0c0R2FzVm1Sb2RDSXFFQnpDVlRrZDg3?=
 =?utf-8?B?OE1zczg2M0FyQ01pWnJHVmJQNlNKU1AyQ1hrQ1JmZ1J0OVFIWlcyK1ZFWk1a?=
 =?utf-8?B?MWloNjVMZUkwUWlzVFU4bExRZzJWNTRSbnEySC9jV2JvZ3lpZXdHOHpOOVdL?=
 =?utf-8?B?MkwzOURKVlV3SnduZjk5U0R1bmVLMzRLbGFYZ3VkbEtRUTBSdjFJakFwa0lD?=
 =?utf-8?B?VTdCWjhYbkZzWms3b3NwRTMvd0IwOWs1bEU0bENUU2grWHFMV205RnBWbExx?=
 =?utf-8?B?a2NEaS8rb1lGNWw0OGpucE5mTVFPT2gxNkMydWFrNzRkUW1sUCsxNzVkWXBU?=
 =?utf-8?B?ZkxHMS9RTmtPcFplMU9xcTg0UHp2NVMydFJWYXpZVTltbUxxNnpuWHpOZUhp?=
 =?utf-8?B?d2FOSWlxUlBRTTZMWjRBSWs5S3RzT0N5VU5aQUlNa3lSK1ExUkJDMlJYVFFs?=
 =?utf-8?B?NHYvZVJicGE2TDMxaGZjcDIyZWNrNmVGbVZTMGpnNHVlNjcySWNRTlhGNldl?=
 =?utf-8?B?UTVsZXZhaGt0SEFQUExkeVh0clh1MGFHcXQvcTJWaDAxNmNhdjdrUENjWVli?=
 =?utf-8?B?ckVmanA4azZCUUlqRVRybVdOMmQxQnB3OUZ0K1FmcUtRa09EeDVLYzdFQ21S?=
 =?utf-8?B?ZkNtNXpndU1QWGppY2U1NTFiemdmZXBxOElZVHdNaEUycklUOVBmWnphMSs2?=
 =?utf-8?B?QjZQR1gwdUFIOHJyck4yWERRVFEvMU5jM0wwU2tBcmx6SWJpY1dFODZLUU92?=
 =?utf-8?B?T242V1Q3SDZTTDJ1RXhINXRUb21wNnN3dk1LT0xXakppay9lay81OTR6eFZi?=
 =?utf-8?B?UVkwNkQ1a0ROcUswRDZ6dlEvaWJzTnJ2UlcvaXFpNW4ra2hJWmJ5SktNVWxl?=
 =?utf-8?B?U2pIbnB2S1dPTFdmR21Fc0FxOE5xbmNQWHdTK0QyNHAzaStTWEhQUHh0aFEy?=
 =?utf-8?B?TFZCMFZ5M0N2UDBTVFNlbVFRVU9SQkxObUtKLy9mSFRZVWlvaWRlZis4aFZw?=
 =?utf-8?B?OGlXcXRZN2JxS3FPeHNRNm41MTMzTXhZcVhlYTNBeEEreVg3dGtKMHFvN2dQ?=
 =?utf-8?B?dlRURzNSblk0YTNYZUlCblh4c0ovQ0lHSFRxOWhOemtOUWs2cTBCWjhLU2F1?=
 =?utf-8?B?NHI3cVpYM0p4N3d6V2FiYVdnYzFpSEhlV29JY0l6Nmw4S25WeFBIYjRUL2xU?=
 =?utf-8?B?Z3VEWWFqR1BucW5RanZETW1jK1hzQ2pXZEJUbjhGL01aUDlrNmREUmtRd0Yx?=
 =?utf-8?B?LzdWZ2NNc1pLeFpLaTNESitBRld6U1Q2d3hWRG0xd3FUQ09iV0R5aXQ1Y1lq?=
 =?utf-8?B?TkluUjR0U2pVTmV2M1Q3MkFTam1ib1MydzJ1Ni9CTU1RL2w4Y0RUY0htcEs2?=
 =?utf-8?B?YmFaZU9qWFNFSS9saVB6NmZPczJRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1301MB2167.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d9226c-3179-4df1-fc2d-08d9ab2abf75
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2021 07:03:53.6203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: laxCXb/CoiQKJYuvN2eNQYIivjQjezMWz/PtYcXskN7IDToDaeHOFm0X+vPMUqiiwnbqku/k6HnfqP36VpWHjMzDBWNrFM+r0NlTjygN/U4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR13MB1302
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIEpha3ViIGZvciBicmluZyB0aGlzIHRvIHVzLg0KT24gTm92ZW1iZXIgMTksIDIwMjEg
MjozMSBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+T24gVGh1LCAxOCBOb3YgMjAyMSAxNDow
Nzo1OCArMDEwMCBTaW1vbiBIb3JtYW4gd3JvdGU6DQo+PiBGcm9tOiBCYW93ZW4gWmhlbmcgPGJh
b3dlbi56aGVuZ0Bjb3JpZ2luZS5jb20+DQo+Pg0KPj4gQWRkIGluZGV4IHRvIGZsb3dfYWN0aW9u
X2VudHJ5IHN0cnVjdHVyZSBhbmQgZGVsZXRlIGluZGV4IGZyb20gcG9saWNlDQo+PiBhbmQgZ2F0
ZSBjaGlsZCBzdHJ1Y3R1cmUuDQo+Pg0KPj4gV2UgbWFrZSB0aGlzIGNoYW5nZSB0byBvZmZsb2Fk
IHRjIGFjdGlvbiBmb3IgZHJpdmVyIHRvIGlkZW50aWZ5IGEgdGMNCj4+IGFjdGlvbi4NCj4+DQo+
PiBTaWduZWQtb2ZmLWJ5OiBCYW93ZW4gWmhlbmcgPGJhb3dlbi56aGVuZ0Bjb3JpZ2luZS5jb20+
DQo+PiBTaWduZWQtb2ZmLWJ5OiBTaW1vbiBIb3JtYW4gPHNpbW9uLmhvcm1hbkBjb3JpZ2luZS5j
b20+DQo+DQo+ZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9vY2Vsb3RfZmxvd2VyLmM6MzA2OjQz
OiBlcnJvcjog4oCYY29uc3Qgc3RydWN0DQo+PGFub255bW91cz7igJkgaGFzIG5vIG1lbWJlciBu
YW1lZCDigJhpbmRleOKAmQ0KPiAgMzA2IHwgICAgICAgICAgICAgICAgICAgICAgICAgcG9sX2l4
ID0gYS0+cG9saWNlLmluZGV4ICsgb2NlbG90LT52Y2FwX3BvbC5iYXNlOw0KPiAgICAgIHwgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXg0KVGhhbmtzLCB0aGlzIG5l
dyBjaGFuZ2Ugd2FzIGRlbGl2ZXJlZCB5ZXN0ZXJkYXkgYW5kIG91ciBwYXRjaCBicm9rZSBpdC4g
IFdlIHdpbGwgbWFrZSB0aGUgY2hhbmdlIGluIHRoZSBWNSBwYXRjaGVzLiANCg==
