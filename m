Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ECD33F1489
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbhHSHv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:51:29 -0400
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:57441
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235102AbhHSHv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 03:51:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WQx9qd8SfK/tROIp5RKHLsOWmpeCiQYOz9Fh/o/Ei0UNe6urjD/kbkCIA9oRNukCuW9UiBcnzm/26EtHJ+lq7v3fF9ar5SWvVxTzPMA+oMgAyKIDKQl+FWP7oEYeGiaJjTUimqfPeJTntzBbPml+Q3gXRZBaFUSwg/BaC2CeGCwqsZMMZxktSrG/ZfdFFLKK1pLqy18/TvYwgpLuNNHRyyp9aOtKHj83UO7o0abi8O7WtSnimO9qavvOpd4jHqxoHS/uz2o21Y9k+ffULt8ShtciXh+qg9EBedqrpqYW2G0IPUNjs68IOqfxQZImkDVCdd1GrXAUNqB9iAV0a12ZRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ErwqSMe4rJcugaPShLbLw8ACCRtV1YT6cefcuGLfNg=;
 b=Irk6xhWOSTbkH7iJ2Fr4Ok4khwg+LHMZ4MJmqY4gjtNUqcfNHAV6ss6TSrjwQnWPuWXcyKxXIJ4IGJdVeT2Z/cEHl8IH0Lm3RTfqUSgYXktnjqMcsTwdOqKTYRdcMtHzXjAMlPosn/PvasCqpFOoCXarrRKBUOQ1QHIvYX+XK1iVT7Hxz0kEWqeer9kE0iRf/q42Ok65kDmY+nXleDx+LUqOvUOET39h67zk1tC+X6/Vm3ztnH6QrAArKgnoXbpbmfEUT+2WWEVYl+P2f5W846vOIwxo2P9sroYYPsloKtDhqrBTgLk2p4rc0yDzpvklsyN4P2BebUZcrqGrh5MDjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ErwqSMe4rJcugaPShLbLw8ACCRtV1YT6cefcuGLfNg=;
 b=gSUMuQGlq2965l0KmmvutLWsOEx0Ij22h1Z5JAExJtJahOeyh8BUY7astmJUW/P7fHczU73TbfMLPCjwbivSLPATPKL7yvI/FBgeMSZ5M+sSsRr2Y2qmnjHHDNp+g41bxl3UewqAYI2u3NGy39ZYcV7QKgxuhDOqUuGZAbM1G6mqCGsDqQlvKDTqaYRlL4CaLFq2imALSqZbtQbZ0GWjWAsIrXvBj98/8lV4qY9/cthYdgCf/lZ2hzK/hFBabXUImLnGxy5f+Bw8Gmmv+K8NKW+dky9WFY7vQfy7ZzzqrddWf51JJ+Q/AFnByVGVPIyBob1yiVLbL50DhBfrmzHeKg==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3637.namprd12.prod.outlook.com (2603:10b6:a03:da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Thu, 19 Aug
 2021 07:50:51 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::e000:8099:a5da:d74%5]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 07:50:51 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "tim.gardner@canonical.com" <tim.gardner@canonical.com>,
        Vlad Buslov <vladbu@nvidia.com>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Roi Dayan <roid@nvidia.com>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>,
        Mark Bloch <mbloch@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Jianbo Liu <jianbol@nvidia.com>
Subject: Re: [PATCH][linux-next] net/mlx5: Bridge, fix uninitialized variable
 in mlx5_esw_bridge_port_changeupper()
Thread-Topic: [PATCH][linux-next] net/mlx5: Bridge, fix uninitialized variable
 in mlx5_esw_bridge_port_changeupper()
Thread-Index: AQHXlEkLsgnnT4Q3m0+5x5/L0iS5QKt5eQOAgAD8RQA=
Date:   Thu, 19 Aug 2021 07:50:51 +0000
Message-ID: <f42ff8df9d10b6e171e3ca45247a3df9b9fba71c.camel@nvidia.com>
References: <20210818155210.14522-1-tim.gardner@canonical.com>
         <ygnh8s0ypumc.fsf@nvidia.com>
In-Reply-To: <ygnh8s0ypumc.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3b960698-78a4-4031-47ab-08d962e610e7
x-ms-traffictypediagnostic: BYAPR12MB3637:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB36374914D0D1E9054EC67173B3C09@BYAPR12MB3637.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nOrlvtx6ZxOD8kc2qsfxVDiGLzvBA+QgS4V8a1fjhSxhpQdDQbq6Q0LgTAtNmcdvm3H82SGx7/abj1dpzCFa0rS5V8pW/Tkhet5XxYlCcWTjouhshGX9BOs4uVilGjcbWOzwxL/njfUi2disY7R7j5L7s0ofYPoWP5RGuv5KhMdc0Afc4JXyFviUcgfREI8ZxPIOI4CXNmEMqTn25FHFRr2ZUQ8osMowhA+w139Rfyo2ANVe1aS4uztZxgYB2Vfq70mNQrq1BvG1/mCN7mzaTzoZ701oSOvqWmJ9JJ68BiI2S8SIFj8PrL2hP8G7VvNSvAS3whHRXcR+EXl1CsaKyDIR0FtTpHU6tARZpIz4uKOXY8UOAQyD5bDP0YR+jjlm/Az73q2awk949gf1lNibV4WzJ2kNlEFgQLAZhOnr4gxtik+bA9D+72hm/M4BEY/RhNaCn1fvCiv+qVBLem0mYQtwhQG7FL0/bIi5Y5Oced6/Rtvxlt9KiERRFwVl7k/lYXBlywqwhG+909QdnG2NvvkJHBIVdZhP/l1rMKkhLQ2Dm/6pNUAflVZP1aQ+z3eUvKEnJ6Iv+0EwIWwECSecEQKEqsMwM2k+BGQvzfH4SaCwhFJrf+nICkrvMcCJ/VObmeOTu9sFGLhIixz8IRArE1Xe6TaOx2WhvDOZB9dfRxFtZdAkc8k32rKN/JN5rc7lBkF0VnqYsDUrLlPQ9wQtcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(8936002)(38100700002)(64756008)(122000001)(316002)(38070700005)(2906002)(6512007)(6486002)(66446008)(6506007)(76116006)(54906003)(26005)(66946007)(66556008)(36756003)(186003)(110136005)(66476007)(4326008)(5660300002)(6636002)(86362001)(107886003)(8676002)(478600001)(71200400001)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UWdCQ04zTjAwWFpGT1RvVDM1ZWJLTzh4WGhHZVArVTNMSjVUTUxMVVFEZnQz?=
 =?utf-8?B?WjVRaUR3enNXS21MN2hSU0xJYk5FbExwdVV2ekVuSE5sc25FWXlzbUdacks2?=
 =?utf-8?B?c2hHeXhIdnMvYXRSVlJKYWdXVnpsNHRGYXZVb2lEd29qZjQ4ZU9iTDBIVGl5?=
 =?utf-8?B?andzRi9LeHBTR2NzMGRBejZrT3M5UnFYVkpnbjVsVFpZY2kvMzVTaS8vcGd1?=
 =?utf-8?B?NFZRd0hXd0hwcDB5dnh5eVZ1UDdDV3I0Ny94Q1YwbEQ2STIrRElMVmVnZ3Qw?=
 =?utf-8?B?cVc3Ni9Ob2p3YytIVHN3eWZFWkl5U0JKWmZzWFFJTXpxUllMUmIwYlhLcmp0?=
 =?utf-8?B?YUpoL3EvTWhQc1k2LzR4YmhWRlEwd2gzbzlOQjBMTWIxOHFNSlZqZ3QrOUg4?=
 =?utf-8?B?UENQcDQ3VmtVSnl0aElkak1PS0VmdTZBZVJPUTZsODA0MS81STlZWWViU0JR?=
 =?utf-8?B?MFNNNk1CNGQ0ZzNJaTNkc2k0RzB0cTNNem41S08wKzJVL2FLRVJMQlI2MFNN?=
 =?utf-8?B?bmdTQSt4YzM3WnZvS0Q3K21NVk9BeVZWYTlFa1ROckx3OGFYcUdoUnM4eGF2?=
 =?utf-8?B?QjBOMk4yM0RDZGVFQkM0cys3Sys2YUh1U3RFN05ENUV1TURFQVIyTDFxaGoy?=
 =?utf-8?B?QnI2aHJ6OVpRRCtrNTlvMWc3RGZITDBvRmtrOXRhbFhGckJJSEw3b3hORjRC?=
 =?utf-8?B?dzM5Q3lDb0VmSFA0aG42S1diTlFSenlUaTR2b25WT3paWGZsUk4zU2lNT3RZ?=
 =?utf-8?B?MnVpUUdWemltMkJMSGQ3aVpGSTZjT1IvRlByVGVrTXNpbXplR2EvS0w1THFp?=
 =?utf-8?B?eXFXdEhzUEdYTytBT24rQ2QzNW9qMnA1bjRTQldMUVQ1WHdJSG1VWGRRb2Fq?=
 =?utf-8?B?UE03SGRMNGtXSFhZQXhqWXBjRFFoeW15R3Rvb3NRQWpiV3U3OGEwbTBPZ1BI?=
 =?utf-8?B?Vm5DOGI4MFFhNnp0RGdtbE90dmNnbXZXSFFZYjgxQmtoQktUd2luTHZrT3Vz?=
 =?utf-8?B?d0RtWnR0eWdjY0hJVVdmZXZLdi9ZUTBQeitRV2dUM2JEeUhsRkFiNHFXeEdH?=
 =?utf-8?B?bDFXK1lBZDlTVktPWHBadnZFRjYrVFl5NnV4c2dvdktibVdpYlg4T0xKRE5B?=
 =?utf-8?B?WGViV2g2a2h5aFRFZldUNExKeEkwdWpkM1AxbCs3SVVISXBvSk1Zcy90aVlK?=
 =?utf-8?B?UU1HWnRCYjNVZW0zS0MxYWRKVnZNanFHanlISEtjL2w0ZFhtY0N0dytpa1Ns?=
 =?utf-8?B?cEo3RGRnblkxeVRKNjJhS214R2ltZDN2blRkNm1rUnRCS2ZLQis0SnYvWHYw?=
 =?utf-8?B?dE11R0RYWklMbHpyRDB4cVF2b3NuSzVza1AyRmxTRzFPRGRyYS9YNCs2VEN5?=
 =?utf-8?B?SDR2VlZMbWNXQVZhczRHdXNUaFlacFNlaHd4OHI4NnNnMlY2V3dONlk4RlNR?=
 =?utf-8?B?NmhyWEYwYmFtYmc1eHdkU0NJNkl5b21oeUt3MVRGUzhIUU50NDl4UENNdjQx?=
 =?utf-8?B?dnZKRlR2bUMrdEs0Q041Z08xQW54dHZmQVE4eGhqSGZQK2gvUXdUbXF5RUx2?=
 =?utf-8?B?TFF2N1Z0RDZPSy9mdW41TDF0MWdpZEhSRm9lLzI4ZEpUUXZqemhieFZtMEdQ?=
 =?utf-8?B?UUhWa3d5a3J0QlQ4NVJpeTU2KzEyUzlrdTRrd3VuQlRHd0w1aUJJcUhSL2h0?=
 =?utf-8?B?djJJUnBOTVRObmZYQW4wZ2JoVFZCenY2WG5kSE5sbGFUbmJxY3BxaGVUbHM2?=
 =?utf-8?B?Wjk4QkpsNjlkU2U0WFlKVHRnRjBZOFpKRVAyY0x0QmlPN0YxZm52NExFWkRE?=
 =?utf-8?B?K3Buc3NIZktWTEtBTGV1QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F2283876EC812428C2EF345F87DD945@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b960698-78a4-4031-47ab-08d962e610e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 07:50:51.4725
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6+6f5kknpiU/xGBk50fqm7LRBh/nJUF26UHGKjOPiV7XxhcSJX/kd2srZO4oAhenz5M65CnHf0JLUGhqi9pW+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTA4LTE4IGF0IDE5OjQ3ICswMzAwLCBWbGFkIEJ1c2xvdiB3cm90ZToNCj4g
T24gV2VkIDE4IEF1ZyAyMDIxIGF0IDE4OjUyLCBUaW0gR2FyZG5lciA8dGltLmdhcmRuZXJAY2Fu
b25pY2FsLmNvbT4NCj4gd3JvdGU6DQo+ID4gQSByZWNlbnQgY2hhbmdlIHJlbW92ZWQgY29kZSB0
aGF0IGluaXRpYWxpemVkIHRoZSByZXR1cm4gY29kZQ0KPiA+IHZhcmlhYmxlICdlcnInLiBJdA0K
PiA+IGlzIG5vdyBwb3NzaWJsZSBmb3IgbWx4NV9lc3dfYnJpZGdlX3BvcnRfY2hhbmdldXBwZXIo
KSB0byByZXR1cm4gYW4NCj4gPiBlcnJvciBjb2RlDQo+ID4gdXNpbmcgdGhpcyB1bmluaXRpYWxp
emVkIHZhcmlhYmxlLiBGaXggaXQgYnkgaW5pdGlhbGl6aW5nIHRvIDAuDQo+ID4gDQo+ID4gQWRk
cmVzc2VzLUNvdmVyaXR5OiAoIlVuaW5pdGlhbGl6ZWQgc2NhbGFyIHZhcmlhYmxlIChVTklOSVQp
IikNCj4gPiANCj4gPiBDYzogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBudmlkaWEuY29tPg0KPiA+
IENjOiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4NCj4gPiBDYzogIkRhdmlkIFMu
IE1pbGxlciIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+ID4gQ2M6IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+ID4gQ2M6IFZsYWQgQnVzbG92IDx2bGFkYnVAbnZpZGlhLmNvbT4N
Cj4gPiBDYzogSmlhbmJvIExpdSA8amlhbmJvbEBudmlkaWEuY29tPg0KPiA+IENjOiBNYXJrIEJs
b2NoIDxtYmxvY2hAbnZpZGlhLmNvbT4NCj4gPiBDYzogUm9pIERheWFuIDxyb2lkQG52aWRpYS5j
b20+DQo+ID4gQ2M6IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQo+
ID4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gPiBDYzogbGludXgtcmRtYUB2Z2VyLmtl
cm5lbC5vcmcNCj4gPiBDYzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KDQpKdXN0IHdv
bmRlcmluZywgZG8gd2UgcmVhbGx5IG5lZWQgMTIgaW5saW5lIENDcyBmb3IgZml4aW5nIGEgcG9v
cg0KY292ZXJpdHk/DQoNCj4gPiBTaWduZWQtb2ZmLWJ5OiBUaW0gR2FyZG5lciA8dGltLmdhcmRu
ZXJAY2Fub25pY2FsLmNvbT4NCj4gPiAtLS0NCj4gDQo+IFRpbSwgdGhhbmtzIGZvciBmaXhpbmcg
dGhpcyENCj4gDQo+IFNhZWVkLCB0aGlzIGlzIHRoZSBzZWNvbmQgc2ltaWxhciBpc3N1ZSB0aGF0
IEkgbWVudGlvbmVkIGluIG15IHJlcGx5DQo+IHRvDQo+IENvbGluLiBBZ2FpbiwgSSd2ZSBhbHJl
YWR5IHN1Ym1pdHRlZCBzYW1lIHBhdGNoIGludGVybmFsbHkgYW5kIHRoaXMNCj4gb25lDQo+IGlz
IGFzIGdvb2QgYXMgbWluZS4NCg0KSSBkb24ndCBtaW5kIGJvdGggcGF0Y2hlcyBhcmUgcGVyZmVj
dC4NCg0KPiANCj4gUmV2aWV3ZWQtYnk6IFZsYWQgQnVzbG92IDx2bGFkYnVAbnZpZGlhLmNvbT4N
Cj4gDQo+IFsuLi5dDQo+IA0KPiANCg0K
