Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86334577951
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 03:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiGRBkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 21:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiGRBkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 21:40:17 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2138.outbound.protection.outlook.com [40.107.92.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEAAEE00
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 18:40:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8hSjgDt8Jg3nRzg/HdYSRRT/WOMFO6crpxqbVB7PXCHcHCf3AkYyMiib57T6YLefwVOgUhnJGEaUCfPA/0pxWB2wd4iffLTP3fmjKIilfEBlg4v5U7t9rOqX3KhK6eP4kuMahaJqHmy6IvIk/b8ZAW5bTPJ0s3LWdkVFG/bVd3ExJak1iRCoo2CG/q/XU3uXXzE8dEfmnsplXnCMWMfUXPdY2RcJPlo5oPgZ8Wls7BUaD+iMqdAHQ/BFC0hcRrKBJFMMaFU1SoMKE18aGPNhjeJ9Ya6WhhZc8kUg4TZ01i1s+sNX5E0vIUSnEd8wxXobaVR+bjDVaKGKemadyY4Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y0R5IO7ExormQTjfKs23Tn1742Ak4/JaV89JEHZkXYM=;
 b=M38okJQArF2J48aQb9QdDygzyGC1aA7Y1r5iYqupFI69Q33wx2fNOmdGhdWir59alS7g0H+qBHBmLWqCfcowlI75/W6CENIpTeExYg8tew1XgrmodMeBfXvNlYwHNZaPOu4RFX6OghkYRwxymMhMd8q3HxG8kZnFkt4dBcTwRJgOQtKn5lTgg9Wi/X/aIS9AupnBNYUeWU4UWByIzqJR3nCWxnZEiYdn16iHciu3N0T7toTQgoiniCEJ2ulsUeB6aCCPrwDfxk0kZoTPS609km7cERAqeWeATU07+kgH2WQAF88VkkfxBK4b38MnpdmIFIXisx1KYYbspckegNfZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0R5IO7ExormQTjfKs23Tn1742Ak4/JaV89JEHZkXYM=;
 b=q7SvGWwKP1EHKuOJYXRKmJ810+6Vuq6BxHwMDKrEL3utEFo8ubx7d2ZUtI4kd4Hd6PrSf52c/gWyS4L+TkphGFKRGRvbySSxGt6CjE1PnjsG2VOhLu8G6ciDO4u9/xtpS+PPXSWxaj+qD3gHIWnFbop/NfZN9H/LL5EyOHNyaE0=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by BY5PR13MB3270.namprd13.prod.outlook.com (2603:10b6:a03:189::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.15; Mon, 18 Jul
 2022 01:40:14 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::3069:6dd2:38fe:8d5a]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::3069:6dd2:38fe:8d5a%7]) with mapi id 15.20.5417.013; Mon, 18 Jul 2022
 01:40:13 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Oz Shlomo <ozsh@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Simon Horman <simon.horman@corigine.com>,
        Roi Dayan <roid@nvidia.com>
Subject: RE: [PATCH net] net/sched: cls_api: Fix flow action initialization
Thread-Topic: [PATCH net] net/sched: cls_api: Fix flow action initialization
Thread-Index: AQHYmbc9rrQNroyesEyXZ6wTDwhxF62DWJUg
Date:   Mon, 18 Jul 2022 01:40:13 +0000
Message-ID: <DM5PR1301MB2172BA76D9BAEADF9A40D11CE78C9@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <20220717082532.25802-1-ozsh@nvidia.com>
In-Reply-To: <20220717082532.25802-1-ozsh@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3c4473b-fae3-45c1-b5b2-08da685e75c3
x-ms-traffictypediagnostic: BY5PR13MB3270:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hKv+CIBcUWO2FBRiQBtMDB6n4/w+DZPVgogeRXSyQgeDXJLIliUr5sqYf1rube2lxPWhagdCFxF23+R7eN/IAjLXXW8LyG5vRdh5bGc+wycs+eNwSP24r7EScPjFl18TT62IESbWn2TsOrfDSHgWwM34xmKI3Po9YhsMT6cCFpJHnqxL4R+Xc+YUokZE8BtDTCOlLYBScPlJkRIKtVKaAS1T0ldzX5F8BcmmyUiOSu9jzIeSqMr04LU+dd2Zocw4JNnwZtinzNIlb4cP1ojA2f06LxZjdNfSyrJVEaI+0VsQUKT4L/KQKqDf2/UAX7us72TqBg1X8H9ABmHHxZCyMCLF2P+4ui5tSOr+JDjhPUVHyaF3mKf3nXhjfoM676E7INkOXFDeufpyOFFwR/wk1/xIquZLcLk75NCdFuCJCnz8xV3UhjdmRjmcYwbtkYjgHlaTfFf9MJHJJL2HSptoKYNiOeA4Ki0msXU6l9nN2f65wMBYc3JqkI5wKPpDJ1V5sjkZjk2ZhdTusJw+VFgSAEJms3qYDc/6GmK5YiSy7PVOLlQx+OqFjy0vg4SdqMsc3bDu3tDUeKDuU+/TuD1L4vKsQDhA0aNEzkYXwAGXS/pwos54EqFauM63SlG2dEXaYAkTVPoBldYRNMG0okz5vFMzttSDlUwrX4e6anu8lYKRhmJIYavWzXS7e4kO3tGQ9x8c9Or6SP4Ntr/u9jYi49UlfohgGoDhEQosI1TEgN1G/kQFwlt4Jo4zNpbSqdVK8h0gPvYbLby24oGS9TWjv64mdjVQ5ZDBURL/O6QhwTRI8ATZjZB06f2Z73YK/6cZ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39830400003)(346002)(136003)(396003)(366004)(316002)(38100700002)(52536014)(8936002)(86362001)(5660300002)(44832011)(55016003)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(38070700005)(7696005)(6506007)(83380400001)(53546011)(41300700001)(186003)(9686003)(26005)(110136005)(54906003)(122000001)(478600001)(71200400001)(33656002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHdjK0xheFU4N2JOTU10Tmx4Um94dCtyY0Jld2x4R2tjR3RhY2VGcUVwQmcv?=
 =?utf-8?B?a1RXSWphanM5cEkvT1l3Qmt3c2ZVUUdTZG51enQ1Q1RJRU4zS2RTTFlZdmEw?=
 =?utf-8?B?eFoxdS9RamN5Q0lYZDJUVk5EKy9XdG85VlZyRGhxYm1LTERObTlYTmZLdFhG?=
 =?utf-8?B?RVdUdU5IeUhrZlMweXA1dzA5YVdxdEt1TFVVcjZnTDl6QUpsRkk2ZVN4azlo?=
 =?utf-8?B?d0grczRXR01MOUFRR1JYNmVwT3BKaDVDMGxtYjQyb3ZwckVwZlp4UFV4cmJI?=
 =?utf-8?B?S2ZmdUVuTFB4cmFmZmhDRnN0Wi9mTXhlOXdnVFRzTlc5TGFIdHNsRUV0TmNO?=
 =?utf-8?B?aTZkSU02RCsvdEFSb3NWU0hST09UZ0VQaFVxVnhlL29KQ2xBMjBBRitBRXVj?=
 =?utf-8?B?MzM0bmlGRUE2a0MxMlVncHBYcHlZVTBTSzRiUlU4UzF0ZWJLcEg3TXJyVjE5?=
 =?utf-8?B?TjE5VmY3WTExQ21IUHhRQUlCelk5UE41SWY0OFRFK2FXcUpXWkNNTEZ5eU5n?=
 =?utf-8?B?NUpBUllMVzZNRk1jRkczM3ZEZXZlQXMyUUo5NDE2cmUrMHMybFcvdzhNNlI0?=
 =?utf-8?B?eS9GV2NxUCtvOUlhdXBYR3d1eXd3blNmenNoak0yYzJlaXcwc2xaeHRFVVRs?=
 =?utf-8?B?YTN5K1V5YkZqYytHMU0vRks0QXlhaGdjTll1S0ptNGNFbHN2QURscFZPOS9L?=
 =?utf-8?B?Rko4OE5pZVMxUG9pUjc5Nnl1eXRqQ1hSSGd4LzN5ZWRCMVQwWVVnNTg4bHNH?=
 =?utf-8?B?a2p4YUZMTHZKQUxETUdNRXVSem5vUXlVb29IWG1ZVng4YzZvL05FUlRTWVdx?=
 =?utf-8?B?Wkp2Y2VkVWRGSURZNHB2VkJlZUsrTkhPTDhrZVhiL3Y5N0FJRkFBK1pNZkYr?=
 =?utf-8?B?OWpxVHhET0x3dkNHQW1xNi9nWFNvd1ZzTFlGelF5RWg2MTFvU2t5UHpVWGV6?=
 =?utf-8?B?cXRudE5xZUlYMjVHSnlQNUU2cmlwZ2NWM1N0YmE1emRpTTBDUURnbi9FNUNF?=
 =?utf-8?B?QWRwdG94aFZqR2JkSjgrR0htL1hpMG5DWm1Xb2F1cFFTY29zSmFuL1RKdEVx?=
 =?utf-8?B?Vi9xblFTYWxGQ3pDK2NvWU15VE9uayt3dE1qcW5tY3VEWU1CQTFJa00wQTNt?=
 =?utf-8?B?L2FHVFArTTJWbzZaN05tZGpDWUIxWmZNR1F4YkFCeFN3RTlJaVVpZ2poOEF0?=
 =?utf-8?B?Rk1GVFJ4OG9TS2ZyOHpncmlrSlY5WmJqYXdXN3FQSmVDL1dROE9CNGx1Ujh6?=
 =?utf-8?B?SElrbEN4TWFVc2VDM3FpejhZeGVQcDJhZjJqcXMvL1BXMlpualRqNVpDYTBY?=
 =?utf-8?B?aXJuNUFoUVRsbVA3c3QwM1R0a29CMDB6RGpaSW9PWnJ1MzZ4RXVYUnhreEpF?=
 =?utf-8?B?NHZkUlFlQTBGTUc4ZjBSam9Za1dYczRlVDlCRjRKS0xoUUlWUVpEaXlqd05o?=
 =?utf-8?B?Unc2Vk9jclFUT3JWcEI3aDFkckVBK0IwZGhPV3lPdXpBU1RLQkRwWEh6a1lU?=
 =?utf-8?B?OVpENUtsekhBZ1Jrc0V0WmNaVlFUNCtLNjFncVZjbzFyYmVTNEJhYzgvQnI3?=
 =?utf-8?B?aElMZC9CVm1MeEd4MUhlYmlPelI5WUpueENxNTR2V0lFMktERXZRTnFjQnl3?=
 =?utf-8?B?dWtFcnpSdUJkN2RMaktPcW81OWxHcm5VVEl3cWlYVEZLK3huVExySXpycnVZ?=
 =?utf-8?B?SzFHOTVHTlcxQ1Uxci94S3B4Z3Z6S05Ub1NiSWhVMjk5eVlFNEczeks0QzI0?=
 =?utf-8?B?YWFITm45ZGFnMVBmRmI1Um5nTFVCMnFDWUJiclNUMkNSQlMvOXQrWHRlekJl?=
 =?utf-8?B?VGRaN0VyUDNiOWM1T1FmUlg5RkxUcVlrZGF0TGZydXQ1aExXUFVWdVJVaVl6?=
 =?utf-8?B?dmYxb2RwMGdwTEQwbnB2Uk4xdmRYUTFDVXBtVkMzTjR1MTIvTHhybXJvQ3J2?=
 =?utf-8?B?OEYzdXFvOXJjNHVmdXlISytBY3NXcWRWQ3hxQXZzRzB0cEdmRi9raXlQQnFn?=
 =?utf-8?B?dEIveFdkM3ZiSUc0K1ZTNVp0WUtKVkVPUDQwL1FVNlI0YXdHS0tWamRxUno5?=
 =?utf-8?B?L2k0L0pBK2ZxZTdNQS9jQVo3S0dkYmYwakkrZ1VnejJmVDdkbGFYbVA5MG12?=
 =?utf-8?Q?3JkYIEJ3/QyOp5IOgkBq+Qs41?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c4473b-fae3-45c1-b5b2-08da685e75c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2022 01:40:13.7852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kuN4KQdwarFRgz0vyrZ8GfknGJ3R62GuCQq4eb4XuAtoQXbWsPLjm2yPNz6Zsv6jJ7mDjERpepGJKs0PMOhfJZeXu5f1PMLdHJkt9392qtM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB3270
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuZGF5LCBKdWx5IDE3LCAyMDIyIDQ6MjYgUE0sIE96IFNobG9tbyB3cm90ZToNCj5TdWJq
ZWN0OiBbUEFUQ0ggbmV0XSBuZXQvc2NoZWQ6IGNsc19hcGk6IEZpeCBmbG93IGFjdGlvbiBpbml0
aWFsaXphdGlvbg0KPg0KPlRoZSBjaXRlZCBjb21taXQgcmVmYWN0b3JlZCB0aGUgZmxvdyBhY3Rp
b24gaW5pdGlhbGl6YXRpb24gc2VxdWVuY2UgdG8gdXNlIGFuDQo+aW50ZXJmYWNlIG1ldGhvZCB3
aGVuIHRyYW5zbGF0aW5nIHRjIGFjdGlvbiBpbnN0YW5jZXMgdG8gZmxvdyBvZmZsb2FkIG9iamVj
dHMuDQo+VGhlIHJlZmFjdG9yZWQgdmVyc2lvbiBza2lwcyB0aGUgaW5pdGlhbGl6YXRpb24gb2Yg
dGhlIGdlbmVyaWMgZmxvdyBhY3Rpb24NCj5hdHRyaWJ1dGVzIGZvciB0YyBhY3Rpb25zLCBzdWNo
IGFzIHBlZGl0LCB0aGF0IGFsbG9jYXRlIG1vcmUgdGhhbiBvbmUgb2ZmbG9hZA0KPmVudHJ5LiBU
aGlzIGNhbiBjYXVzZSBwb3RlbnRpYWwgaXNzdWVzIGZvciBkcml2ZXJzIG1hcHBpbmcgZmxvdyBh
Y3Rpb24gaWRzLg0KPg0KPlBvcHVsYXRlIHRoZSBnZW5lcmljIGZsb3cgYWN0aW9uIGZpZWxkcyBm
b3IgYWxsIHRoZSBmbG93IGFjdGlvbiBlbnRyaWVzLg0KPg0KPkZpeGVzOiBjNTRlMWQ5MjBmMDQg
KCJmbG93X29mZmxvYWQ6IGFkZCBvcHMgdG8gdGNfYWN0aW9uX29wcyBmb3IgZmxvdyBhY3Rpb24N
Cj5zZXR1cCIpDQo+U2lnbmVkLW9mZi1ieTogT3ogU2hsb21vIDxvenNoQG52aWRpYS5jb20+DQo+
UmV2aWV3ZWQtYnk6IFJvaSBEYXlhbiA8cm9pZEBudmlkaWEuY29tPg0KPi0tLQ0KPiBuZXQvc2No
ZWQvY2xzX2FwaS5jIHwgMTcgKysrKysrKysrKysrKy0tLS0NCj4gMSBmaWxlIGNoYW5nZWQsIDEz
IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pDQo+DQo+ZGlmZiAtLWdpdCBhL25ldC9zY2hl
ZC9jbHNfYXBpLmMgYi9uZXQvc2NoZWQvY2xzX2FwaS5jIGluZGV4DQo+OWJiNGQzZGNjOTk0Li5k
MDdjMDQwOTY1NjAgMTAwNjQ0DQo+LS0tIGEvbmV0L3NjaGVkL2Nsc19hcGkuYw0KPisrKyBiL25l
dC9zY2hlZC9jbHNfYXBpLmMNCj5AQCAtMzUzMyw3ICszNTMzLDcgQEAgaW50IHRjX3NldHVwX2Fj
dGlvbihzdHJ1Y3QgZmxvd19hY3Rpb24gKmZsb3dfYWN0aW9uLA0KPiAJCSAgICBzdHJ1Y3QgdGNf
YWN0aW9uICphY3Rpb25zW10sDQo+IAkJICAgIHN0cnVjdCBuZXRsaW5rX2V4dF9hY2sgKmV4dGFj
aykNCj4gew0KPi0JaW50IGksIGosIGluZGV4LCBlcnIgPSAwOw0KPisJaW50IGksIGosIGssIGlu
ZGV4LCBlcnIgPSAwOw0KPiAJc3RydWN0IHRjX2FjdGlvbiAqYWN0Ow0KPg0KPiAJQlVJTERfQlVH
X09OKFRDQV9BQ1RfSFdfU1RBVFNfQU5ZICE9DQo+RkxPV19BQ1RJT05fSFdfU1RBVFNfQU5ZKTsg
QEAgLTM1NTcsMTAgKzM1NTcsMTkgQEAgaW50DQo+dGNfc2V0dXBfYWN0aW9uKHN0cnVjdCBmbG93
X2FjdGlvbiAqZmxvd19hY3Rpb24sDQo+IAkJZW50cnktPmh3X2luZGV4ID0gYWN0LT50Y2ZhX2lu
ZGV4Ow0KPiAJCWluZGV4ID0gMDsNCj4gCQllcnIgPSB0Y19zZXR1cF9vZmZsb2FkX2FjdChhY3Qs
IGVudHJ5LCAmaW5kZXgsIGV4dGFjayk7DQo+LQkJaWYgKCFlcnIpDQo+LQkJCWogKz0gaW5kZXg7
DQo+LQkJZWxzZQ0KPisJCWlmIChlcnIpDQo+IAkJCWdvdG8gZXJyX291dF9sb2NrZWQ7DQo+Kw0K
PisJCS8qIGluaXRpYWxpemUgdGhlIGdlbmVyaWMgcGFyYW1ldGVycyBmb3IgYWN0aW9ucyB0aGF0
DQo+KwkJICogYWxsb2NhdGUgbW9yZSB0aGFuIG9uZSBvZmZsb2FkIGVudHJ5IHBlciB0YyBhY3Rp
b24NCj4rCQkgKi8NCj4rCQlmb3IgKGsgPSAxOyBrIDwgaW5kZXggOyBrKyspIHsNCj4rCQkJZW50
cnlba10uaHdfc3RhdHMgPSB0Y19hY3RfaHdfc3RhdHMoYWN0LT5od19zdGF0cyk7DQo+KwkJCWVu
dHJ5W2tdLmh3X2luZGV4ID0gYWN0LT50Y2ZhX2luZGV4Ow0KVGhhbmtzIE96IGZvciBicmluZ2lu
ZyB0aGlzIGNoYW5nZSB0byB1cywgSSB0aGluayBpdCBtYWtlcyBzZW5zZSBmb3IgdXMgd2hlbiB0
aGUgcGVkaXQgYWN0aW9uIGlzIG9mZmxvYWRlZCBhcyBhIHNpbmdsZSBhY3Rpb24uIA0KSnVzdCBh
IHRpbnkgYWR2aWNlIGZvciB5b3VyIHJlZmVyZW5jZSwgbWF5YmUgd2UgY2FuIHN0YXJ0IGFzc2ln
bm1lbnQgZnJvbSBrID0gMCBhbmQgZGVsZXRlIHRoZSBmaXJzdCBlbnRyeSBhc3NpZ25tZW50IGFi
b3ZlLCB0aGVuIHdlIHdpbGwgcHV0IGFsbCB0aGUgZ2VuZXJhbCBhc3NpZ25tZW50IGluIHRoaXMg
bG9vcCwgaXQgd2lsbCBiZSBtb3JlIGNsZWFuLCBXRFlUPw0KPisJCX0NCj4rDQo+KwkJaiArPSBp
bmRleDsNCj4rDQo+IAkJc3Bpbl91bmxvY2tfYmgoJmFjdC0+dGNmYV9sb2NrKTsNCj4gCX0NCj4N
Cj4tLQ0KPjEuOC4zLjENCg0K
