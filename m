Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBD057F5B1
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 17:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbiGXPVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 11:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiGXPVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 11:21:36 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2073.outbound.protection.outlook.com [40.107.102.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A18E11C05
        for <netdev@vger.kernel.org>; Sun, 24 Jul 2022 08:21:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8wJaeUcronGlJAuWZ2Pvy0Hbu7xd60cWnx8cYp1bBFGilhnw2guMGOSAzs3FQ5BjwIyzziNsGpLI3sWgtEiSQbSorU+ypnZSa6GddC4ukVTsRtwkpnIDwzKgmUFS55QIOaNtdATQPIF6htrIG9dPviqB5twK04tR7sAaSQHdJ4uNJ7tgEPnqcjKcMrdazkp45UyxBwWcbMXsLICAapdfzOYXeKKdpPtCaKobfK2G2zlT6lDYpsenGw0RSj0UxTpJvqtbFYUN8O6A1KfWlhjoSWGYmD2xv19BNcEbR79LTJB2LBDAfL1OkHTWTH6xixas+PIQ9O3h311YrCmZMaBmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7uTgfQiTBuCu4zbOWms2i94DCu6g5IlaoP30tgoPuw=;
 b=bdG+7QgXuYg5p5AouVGPpUOTmLz8int6N+EpYiblrLLnOUnk21EvI35k0arn9v3miaOWoTYAn/PRjFqaNXYKOXKhOLZ+AdzuJcb1uriznh3Zv7Q/TlzbWqogtgg8eerA6GzbPAfck/30455oOh7lbf16XOquRUbvZrBmzvC6gHCauXqOPpEF1L4j1J7pJdyyfd7V4lV3Qsh3s+4AEwuGPENB0G4ZEA1qPkMvyJImrnfhBNyWiu94Rpl2FBqKRUhv0eLPrnYavuiXNxaInfaHqUgELxdo+qJKXq1whbVJBbBvUX0zb1UBBu9m8GNRA3PkEKQLarZA5slE5FFFPatHqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7uTgfQiTBuCu4zbOWms2i94DCu6g5IlaoP30tgoPuw=;
 b=kLaurm5BwwDROjhQt/MtVgKKBLMdwyvjFBgtso/4u3YrktYJ+d7kXVBddNVTGl+272ImeUOBCVkTFfjVGKmmJIshYxgRD0rxV5RDJzrbjVgLiflRueOOTO4VS5BieYemL0bDww+j5Xw4dqMOdT3gUKHkpdhy3H3MYrFgSxptf+bh3cwClvjPFV+/KE8Q+kRpai9kwrPnWrAaJpFimOkICBNXHzLjYr+/yTQ7TTUJ6aOow9BuPpS1HYa+7hbDY3DG5XUzYCQay5dD10YsoCo8LsWssem7mrP4VfCU44m04Yi5Z3Q6wB6ZDdEwJwJfASOCtDzIov/9oA/2SYzeJxS6tw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BY5PR12MB4804.namprd12.prod.outlook.com (2603:10b6:a03:1b6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Sun, 24 Jul
 2022 15:21:32 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::544b:6e21:453e:d3d6%9]) with mapi id 15.20.5458.023; Sun, 24 Jul 2022
 15:21:32 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Topic: [PATCH V4 3/6] vDPA: allow userspace to query features of a vDPA
 device
Thread-Index: AQHYncLBTkGC7Q3QJk+hIdvX3SqZ2q2KXRuQgAF0rYCAAdS1UA==
Date:   Sun, 24 Jul 2022 15:21:32 +0000
Message-ID: <PH0PR12MB5481D9BBC9C249840E4CDF7EDC929@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-4-lingshan.zhu@intel.com>
 <PH0PR12MB548193156AFCA04F58B01A3CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
 <6dc2229c-f2f3-017f-16fa-4611e53c774e@intel.com>
In-Reply-To: <6dc2229c-f2f3-017f-16fa-4611e53c774e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6bf8bf8-0fc8-4ea5-9ddf-08da6d8830a7
x-ms-traffictypediagnostic: BY5PR12MB4804:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 42OqS3H0/lkvDNIULOChVweH1a8s1zI+j0xMonBXmhYUeIseyn1J4k9jJwXHo+i80yMWFuGRoKQ3vjNQdjxyV5amlL0u9buWlnD6+sAOTEQs+MnJweCjN6HdICDz0+5bexPLwFq2NHQleF+J3qYU7OSeUGpswVbY4XiqWZ9tim7wWUEzLa1nW97RlSayRPJvMKyYCXaIu5DjeUmm+0sZOFG4dvpdV7XA3wtPzSjgW0WyqPQLi47uC2FZDcD7PRnXku9jOnUmyGGG2WpD4wCI7cIJO1mTBmzNnLR9yKT2hHQgqwSWFnM4F2bLMRA1xroCA+Jq0BQMceV3zU+XF94UJb+ibTjhqehB2OUdwFPigaJbiEBPQxV3hqfbiuvmomn2vxckTRcz/gHDAsDzJW9eVdskY1pAkez+KLv9HzHJD+J5fnp/03TEfQxuCc5NBY4t8z19QUdEfXZt+tHmUFmDJ2aw8Hms5bhbSFMSAOwY2GnbBfZ3ZIcraI7sc9gz0Mo0GMXiRuM3qAoPBAD4g0pawfRfzoYlnaka8D2RQWodR1siIdKZQztabBy3uicMGw5Sj+ZPBzLuiEYCjyweqW+yJy/Gq1ERApe/Y7I3uIEnNOvKUNqA27mXwwgBouXXAg55ph/xbMGutiRp+fn8i2E0pogCawmczumWhDz/fbhu2oP2t69eFKGjwYDBw0qV2fTrx6yI7iHYrY11lOYmCaBITPBjiLzml03XdYL/WwJxbzo3bFAGaluBlymgdPPgHMfQE6nOVwZ7lJliH1uAKCxDRdTPitHb8gGxDki7zYn5EeH1ybeNShotLOClNQC/nXDi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(38070700005)(86362001)(33656002)(52536014)(122000001)(26005)(6506007)(186003)(53546011)(83380400001)(9686003)(38100700002)(7696005)(41300700001)(71200400001)(110136005)(54906003)(478600001)(316002)(4326008)(66946007)(8936002)(66446008)(64756008)(66476007)(8676002)(76116006)(55016003)(2906002)(66556008)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFV6R3YxMTczdXd6dFkwMXRQUkNOS3g2NE9rRy9nczE3Nk1tZkhENzQySHcx?=
 =?utf-8?B?Mys4amZKZFU0UmQ3azFva3pVTWMwNytIK21jaFAvVUNIbWFnTjV2RU1CQ3d6?=
 =?utf-8?B?ajRyUERkWVhIRXR6amFmcDc0UzV6MGlaakRKTlg2LzF0dkxNaGZZY3pjc3RC?=
 =?utf-8?B?YktBUnZNVndLaUpYdk9pNWlpNDhpUjVMam9QOXBNMnoycTdZVlE1T0JTdzQx?=
 =?utf-8?B?WWI0RVcvY3YvcWpKVy9GaE1WRXFjVXhBbVl4Qmc3NloydU5GWFY5dEZENEF2?=
 =?utf-8?B?VFp5THA1V280TWlFUFlkVnQwOUVYTjVoMThzMlg5bXE1ZXBYNndJcUhTV1Ra?=
 =?utf-8?B?dWtKRWNlVjVjRFFLNHFucFlycVE5U1V1dHJ6eGxUcEgyQVMvcUliWnJwbGFk?=
 =?utf-8?B?TUZQREZQemZMaVNhUER5WFo1T2lrREZ6cWc3MVRaUFNnSmRqdHlSZSsrRG4w?=
 =?utf-8?B?b1RPVDZJVmFkZTJrbHdGTUZKYmJ4a1FXcklMSDNPSXh6bGdmY1NkTFpZaUhH?=
 =?utf-8?B?YUtXR1ExWW5GR0hxMmVZNDNvQ1laeW5rWDlvUUJTdjZ5NmlKRWo0ZllEbURE?=
 =?utf-8?B?MTVFcTRMd0lEcStJQzA0VkdGbmNUSkpZRFdPREp4bkpsZERqUytDcVF5aFJY?=
 =?utf-8?B?UXByaU84aEtwSjJWWXBPUVVvNG5SUy9hVjdlT0srWE1FSEMva21xWDlFMktx?=
 =?utf-8?B?M2dHNHgzOUxlNUNxOGdaSWg0ZTBYTVJUUlpTQWlWdjlSdmI1SHJqMzBFcDdI?=
 =?utf-8?B?NmxPZHA2TUZJaldPZU1GdTFlalk3WG1RTXBHTGp5ampzSHRjMkJOd1BPcFN1?=
 =?utf-8?B?S0haUFBjNk1xN2dwOGRRNUt1SDFWN25hUzB0RGpJd2FOTXBVdHdpbXFYUFA5?=
 =?utf-8?B?bkJOZjg4RzZWNUVVZjFtQXBoTTdQOGFyMk1vNVBvMzl4OWsreVJCSFRmWUlX?=
 =?utf-8?B?RTN1VHlxMStNeGw0LzJxRld5Wk5FelI1cE5FWmlvQjdxcnV0VUllV1BpNmd1?=
 =?utf-8?B?ZzVQeGpackRWV0tNdHM2NVNxOTFwZ2lKalBxN1lZWDk0bGJTWEd0RW1WRDdv?=
 =?utf-8?B?VGEwOXlSd0t3STBvd1FPOEJMaDdiN3VnSkhCL25ZS2kwbnIwVEdtcDg5Y0hj?=
 =?utf-8?B?em9tUGNzUW5UTnpYSnVadWZMSHZIWE1VR0FDem41c1dXR0ZsbzZtczYzN2xO?=
 =?utf-8?B?Z3RuL0JNNmNXQVYwUGtyOGdwa2o4a0R1S24wcmhGbGxaN0Y5aFNYeHpwcnFy?=
 =?utf-8?B?VVU5dWlLRXpOVjBjYjZza1lxdkprSXovMnp2VklTenRDSzNVM2ZGaVRUbmxj?=
 =?utf-8?B?SWd3SHNOU2p3a0dPTno2ZTgySzV6Wnlad3h3UVVLamgrbHg5M2NvbkttdTNq?=
 =?utf-8?B?eU0xYzN6TVkyMEphQ3RZd2crWEk3bjhZUUJmaEpRRDFjYXlib28vRUVOUkNC?=
 =?utf-8?B?RlI4ZjRkb2o5QzI5UFRVNWpmOFhJQmZZbjdROUgvV3ZWTDR3RENZTm9OS1lq?=
 =?utf-8?B?bFJ0Z1JXUW1pYzZuOFJmdTg5NnpSTE42cHJ0Y2lpOEtEbHRJOTdZQkE0RUFX?=
 =?utf-8?B?UENac2lVVlErR011VnU1RkRHMGNwd3BtUGd2TzlVaXQ1QnlqaVZia0ZmOXZp?=
 =?utf-8?B?NEFVMGNKcnhyeHlCemFpRTlQNzFBL1oyem1LTkdCS3BSeUdGSlpHRndlbWJl?=
 =?utf-8?B?RUxEK05VeVdKUWkxU0JSWVh4QkxseXdWMFhWZnpyQ3BoaWR3L3FtazQvQTM0?=
 =?utf-8?B?QW1EQkp2NGs2NTdObEtoNytyYXNhdHFLRTFFQ2NiaEdQeTFRQWwxZ3huaFVh?=
 =?utf-8?B?SWdaemtDWFg0bnQwV1VRcTRzVmtaOGR4Qk04OG1EYkRqWXpkWHBKUkVicTlC?=
 =?utf-8?B?MXpKOFlQdHZjeFFlWnVOQVl0Nm91Skc1WklpRDVGZk5xcDlJVjRjL0o0ZXlN?=
 =?utf-8?B?cGk4Si9oWjltTC8vOEZkZm1lM2c4ckovV1hYSThXcFpCREtjRDBtOWtXM2ty?=
 =?utf-8?B?ajRtQlkwOWxUV2JkSU03WmgrWG9wRDg2d25QbUtDZktla0J2YzdqUndPRTgx?=
 =?utf-8?B?aiszaVFhRmdUUld6OHRnZ2hHZ0tPdGE4ZXNMYXJSR3FVUTZVbGMyWG55R0lk?=
 =?utf-8?Q?6rtw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6bf8bf8-0fc8-4ea5-9ddf-08da6d8830a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2022 15:21:32.5305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WpnVyEzOWaqec8EeSJhwku1Y8qmU0OzO0gRsZr1M0sHUcblEkheiFO7P5wXXJkL3xjXPcoCpP6cu1JJeTuDkHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4804
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogWmh1LCBMaW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4gU2Vu
dDogU2F0dXJkYXksIEp1bHkgMjMsIDIwMjIgNzoyNCBBTQ0KPiANCj4gDQo+IE9uIDcvMjIvMjAy
MiA5OjEyIFBNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4+IEZyb206IFpodSBMaW5nc2hhbiA8
bGluZ3NoYW4uemh1QGludGVsLmNvbT4NCj4gPj4gU2VudDogRnJpZGF5LCBKdWx5IDIyLCAyMDIy
IDc6NTMgQU0NCj4gPj4NCj4gPj4gVGhpcyBjb21taXQgYWRkcyBhIG5ldyB2RFBBIG5ldGxpbmsg
YXR0cmlidXRpb24NCj4gPj4gVkRQQV9BVFRSX1ZEUEFfREVWX1NVUFBPUlRFRF9GRUFUVVJFUy4g
VXNlcnNwYWNlIGNhbiBxdWVyeQ0KPiBmZWF0dXJlcw0KPiA+PiBvZiB2RFBBIGRldmljZXMgdGhy
b3VnaCB0aGlzIG5ldyBhdHRyLg0KPiA+Pg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBaaHUgTGluZ3No
YW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+ID4+IC0tLQ0KPiA+PiAgIGRyaXZlcnMvdmRw
YS92ZHBhLmMgICAgICAgfCAxMyArKysrKysrKystLS0tDQo+ID4+ICAgaW5jbHVkZS91YXBpL2xp
bnV4L3ZkcGEuaCB8ICAxICsNCj4gPj4gICAyIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMo
KyksIDQgZGVsZXRpb25zKC0pDQo+ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZkcGEv
dmRwYS5jIGIvZHJpdmVycy92ZHBhL3ZkcGEuYyBpbmRleA0KPiA+PiBlYmYyZjM2M2ZiZTcuLjli
MGUzOWIyZjAyMiAxMDA2NDQNCj4gPj4gLS0tIGEvZHJpdmVycy92ZHBhL3ZkcGEuYw0KPiA+PiAr
KysgYi9kcml2ZXJzL3ZkcGEvdmRwYS5jDQo+ID4+IEBAIC04MTUsNyArODE1LDcgQEAgc3RhdGlj
IGludCB2ZHBhX2Rldl9uZXRfbXFfY29uZmlnX2ZpbGwoc3RydWN0DQo+ID4+IHZkcGFfZGV2aWNl
ICp2ZGV2LCAgc3RhdGljIGludCB2ZHBhX2Rldl9uZXRfY29uZmlnX2ZpbGwoc3RydWN0DQo+ID4+
IHZkcGFfZGV2aWNlICp2ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqbXNnKSAgew0KPiA+PiAgIAlzdHJ1
Y3QgdmlydGlvX25ldF9jb25maWcgY29uZmlnID0ge307DQo+ID4+IC0JdTY0IGZlYXR1cmVzOw0K
PiA+PiArCXU2NCBmZWF0dXJlc19kZXZpY2UsIGZlYXR1cmVzX2RyaXZlcjsNCj4gPj4gICAJdTE2
IHZhbF91MTY7DQo+ID4+DQo+ID4+ICAgCXZkcGFfZ2V0X2NvbmZpZ191bmxvY2tlZCh2ZGV2LCAw
LCAmY29uZmlnLCBzaXplb2YoY29uZmlnKSk7IEBAIC0NCj4gPj4gODMyLDEyICs4MzIsMTcgQEAg
c3RhdGljIGludCB2ZHBhX2Rldl9uZXRfY29uZmlnX2ZpbGwoc3RydWN0DQo+ID4+IHZkcGFfZGV2
aWNlICp2ZGV2LCBzdHJ1Y3Qgc2tfYnVmZiAqbXMNCj4gPj4gICAJaWYgKG5sYV9wdXRfdTE2KG1z
ZywgVkRQQV9BVFRSX0RFVl9ORVRfQ0ZHX01UVSwgdmFsX3UxNikpDQo+ID4+ICAgCQlyZXR1cm4g
LUVNU0dTSVpFOw0KPiA+Pg0KPiA+PiAtCWZlYXR1cmVzID0gdmRldi0+Y29uZmlnLT5nZXRfZHJp
dmVyX2ZlYXR1cmVzKHZkZXYpOw0KPiA+PiAtCWlmIChubGFfcHV0X3U2NF82NGJpdChtc2csDQo+
ID4+IFZEUEFfQVRUUl9ERVZfTkVHT1RJQVRFRF9GRUFUVVJFUywgZmVhdHVyZXMsDQo+ID4+ICsJ
ZmVhdHVyZXNfZHJpdmVyID0gdmRldi0+Y29uZmlnLT5nZXRfZHJpdmVyX2ZlYXR1cmVzKHZkZXYp
Ow0KPiA+PiArCWlmIChubGFfcHV0X3U2NF82NGJpdChtc2csDQo+ID4+IFZEUEFfQVRUUl9ERVZf
TkVHT1RJQVRFRF9GRUFUVVJFUywgZmVhdHVyZXNfZHJpdmVyLA0KPiA+PiArCQkJICAgICAgVkRQ
QV9BVFRSX1BBRCkpDQo+ID4+ICsJCXJldHVybiAtRU1TR1NJWkU7DQo+ID4+ICsNCj4gPj4gKwlm
ZWF0dXJlc19kZXZpY2UgPSB2ZGV2LT5jb25maWctPmdldF9kZXZpY2VfZmVhdHVyZXModmRldik7
DQo+ID4+ICsJaWYgKG5sYV9wdXRfdTY0XzY0Yml0KG1zZywNCj4gPj4gVkRQQV9BVFRSX1ZEUEFf
REVWX1NVUFBPUlRFRF9GRUFUVVJFUywNCj4gPj4gK2ZlYXR1cmVzX2RldmljZSwNCj4gPj4gICAJ
CQkgICAgICBWRFBBX0FUVFJfUEFEKSkNCj4gPj4gICAJCXJldHVybiAtRU1TR1NJWkU7DQo+ID4+
DQo+ID4+IC0JcmV0dXJuIHZkcGFfZGV2X25ldF9tcV9jb25maWdfZmlsbCh2ZGV2LCBtc2csIGZl
YXR1cmVzLCAmY29uZmlnKTsNCj4gPj4gKwlyZXR1cm4gdmRwYV9kZXZfbmV0X21xX2NvbmZpZ19m
aWxsKHZkZXYsIG1zZywgZmVhdHVyZXNfZHJpdmVyLA0KPiA+PiArJmNvbmZpZyk7DQo+ID4+ICAg
fQ0KPiA+Pg0KPiA+PiAgIHN0YXRpYyBpbnQNCj4gPj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFw
aS9saW51eC92ZHBhLmggYi9pbmNsdWRlL3VhcGkvbGludXgvdmRwYS5oDQo+ID4+IGluZGV4DQo+
ID4+IDI1YzU1Y2FiM2Q3Yy4uMzlmMWMzZDdjMTEyIDEwMDY0NA0KPiA+PiAtLS0gYS9pbmNsdWRl
L3VhcGkvbGludXgvdmRwYS5oDQo+ID4+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC92ZHBhLmgN
Cj4gPj4gQEAgLTQ3LDYgKzQ3LDcgQEAgZW51bSB2ZHBhX2F0dHIgew0KPiA+PiAgIAlWRFBBX0FU
VFJfREVWX05FR09USUFURURfRkVBVFVSRVMsCS8qIHU2NCAqLw0KPiA+PiAgIAlWRFBBX0FUVFJf
REVWX01HTVRERVZfTUFYX1ZRUywJCS8qIHUzMiAqLw0KPiA+PiAgIAlWRFBBX0FUVFJfREVWX1NV
UFBPUlRFRF9GRUFUVVJFUywJLyogdTY0ICovDQo+ID4+ICsJVkRQQV9BVFRSX1ZEUEFfREVWX1NV
UFBPUlRFRF9GRUFUVVJFUywJLyogdTY0ICovDQo+ID4+DQo+ID4gSSBoYXZlIGFuc3dlcmVkIGlu
IHByZXZpb3VzIGVtYWlscy4NCj4gPiBJIGRpc2FncmVlIHdpdGggdGhlIGNoYW5nZS4NCj4gPiBQ
bGVhc2UgcmV1c2UgVkRQQV9BVFRSX0RFVl9TVVBQT1JURURfRkVBVFVSRVMuDQo+IEkgYmVsaWV2
ZSB3ZSBoYXZlIGFscmVhZHkgZGlzY3Vzc2VkIHRoaXMgYmVmb3JlIGluIHRoZSBWMyB0aHJlYWQu
DQo+IEkgaGF2ZSB0b2xkIHlvdSB0aGF0IHJldXNpbmcgdGhpcyBhdHRyIHdpbGwgbGVhZCB0byBh
IG5ldyByYWNlIGNvbmRpdGlvbi4NCj4NClJldHVybmluZyBhdHRyaWJ1dGUgY2Fubm90IGxlYWQg
dG8gYW55IHJhY2UgY29uZGl0aW9uLg0KDQogDQo+IFBsZWFzIHJlZmVyIHRvIHRoZSBwcmV2aW91
cyB0aHJlYWQsIGFuZCB5b3UgZGlkIG5vdCBhbnN3ZXIgbXkgcXVlc3Rpb25zIGluDQo+IHRoYXQg
dGhyZWFkLg0KPiANCj4gVGhhbmtzLA0KPiBaaHUgTGluZ3NoYW4NCj4gPg0KPiA+IE1TVCwNCj4g
PiBJIG5hY2sgdGhpcyBwYXRjaC4NCj4gPiBBcyBtZW50aW9uZWQgaW4gdGhlIHByZXZpb3VzIHZl
cnNpb25zLCBhbHNvIGl0IGlzIG1pc3NpbmcgdGhlIGV4YW1wbGUNCj4gb3V0cHV0IGluIHRoZSBj
b21taXQgbG9nLg0KPiA+IFBsZWFzZSBpbmNsdWRlIGV4YW1wbGUgb3V0cHV0Lg0KPiA+DQo+ID4+
ICAgCVZEUEFfQVRUUl9ERVZfUVVFVUVfSU5ERVgsICAgICAgICAgICAgICAvKiB1MzIgKi8NCj4g
Pj4gICAJVkRQQV9BVFRSX0RFVl9WRU5ET1JfQVRUUl9OQU1FLAkJLyogc3RyaW5nICovDQo+ID4+
IC0tDQo+ID4+IDIuMzEuMQ0KDQo=
