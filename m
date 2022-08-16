Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 098A0596417
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237228AbiHPVCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233785AbiHPVCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:02:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2069.outbound.protection.outlook.com [40.107.92.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8F97538C;
        Tue, 16 Aug 2022 14:02:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQJAEMUaUcR6OzRpNJCBQ/wTshYUhHJrB8Pnc6zf3POZMdTH9pAk16rIOyt3Ej5n2McdDbY/gKkaaH+nnsCtFXuAu6Iz0A9bmFh5Glxl1S+x6Bl+eaTwmDoJZ8bgSaVuoPk7eVA7A9lnUEnxHReIG5GRp13QoonqU0xOyCDgIBUCfbvQ4oARz5qqvY/sL4G/R08omKM03G9vjuYJUK5hmZkIGmjeuDbVNbeDD3/iGnQukNh3P4C1ZGMc8x2ifhuS7jd2SsFrjDKkCVEUVVItOgKGAyzu6S3tZAYM3thvy0lvQODnCeDt+rtg+P1CuBGvd7EvPX2FGX/A+URuNXkGzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xLx6TZQAe+s3FAf4LLCCcHMP64Mp9EuL+L1m2tX9kF0=;
 b=lCQhe7IBZ+h4fSCXdpPX3yB8eSpzrWpiYnQHh8j+Dg3mEViTWLZnyJ+I+sbL95oPgrwU+XMfdmDUyxHFnAwP7V3QnMAAsqEtvwOE0XV/2lzJ0aLXjte0SLLsMmj67Oqo6aZNCcuqdv1vJO/C1gENY6yhtINGtUAP6UgP4YTT3+uVG/zsURvk3FlHB7i2fv5dXgsD4BvcGGtmvthSqP3Vpd0epCjP2bLYQpbjnMFANOce4gZKC5zJY2zELUri41pc2TnpfRBJ6Eh6AiMYh74dFwZEZycUIo/ABV4iNEM+TcLXHCasUMN8BcjckN+g3vXaWUWrhwe8maXeBDZC91RgUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLx6TZQAe+s3FAf4LLCCcHMP64Mp9EuL+L1m2tX9kF0=;
 b=uUIK/UwtWYI4UtLa4Oq8l3z9U1L5SBi/o4PZX/xknI74uqqBrhQdgmJ6n718MhnmBGkBjqXKvFi5AEdkLL80QA3npRnuU+KlapoK4bgtvWqf0rY30D1F+ObEqGhY6a4CIWmqaqwm1YFNKM/fuQbdf2iSeW673Rpkss2FAK/XtFfS1a6s1p6PqX/n54Q6wdWuTRYZBijxhpp3i9SSmZyppiA0NQvyNwWFvhnL8TEzY1wHLF3vTcmLAE/bJ/lMaWaO0MHW34w+DJIQs0Dw7BzH+2RP6zThkohYaCN771rv3fceoDuF/TAinxhS89R4ES6vaEj0TDjMlmJH+XtGiav7Wg==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CY4PR12MB1846.namprd12.prod.outlook.com (2603:10b6:903:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Tue, 16 Aug
 2022 21:02:17 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e%6]) with mapi id 15.20.5504.028; Tue, 16 Aug 2022
 21:02:17 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: RE: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Thread-Topic: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Thread-Index: AQHYsIpJtq9YpvWt2kmNOt5VAnquUK2wzXWggAAf+YCAARYlwA==
Date:   Tue, 16 Aug 2022 21:02:17 +0000
Message-ID: <PH0PR12MB5481EBA9E08963DEF0743063DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <PH0PR12MB54815EF8C19F70072169FA56DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <4184a943-f1c0-a57b-6411-bdd21e0bc710@intel.com>
In-Reply-To: <4184a943-f1c0-a57b-6411-bdd21e0bc710@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1978bd28-765a-4e26-85bc-08da7fca9a34
x-ms-traffictypediagnostic: CY4PR12MB1846:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GEqLEhcGUMEmWAsbdG6gaCJu14bIMYvd2YBVmO4T/blVecJIJvqxDXYUBTv69ONGlSdRS3AwBiARZGMqU+LcrcYZ1hcrI9k3En7CQiLREpcj+D4MrljZRicZX19n53MYFZineyfV0VPmx7GE3cVnsomcRDiQko4VeFrnGuGTr9is7MGA8acXW5L8FPeBnE2bKCknYLrHo1ccguC5VTflZOXc8q1VS9BF4NidXFG3hxSj2uly9PCesDXgAZaHVKsbVbXtyoSCRse1YcpxbieQfcwv3BjTwEYTWHN/8yM9NMRPgDDPJCU0xZy4xhj8V24CTawIP/tBu3+8NxPoi0ezslR4fbL7f3sisK9tYjNDnTtC2h75xe1+0QhAxTM6zbSkS3CGU+10CVLDuD+Poy+2i9y5YaBCF0J1TnS4i5BguRQoUYL3V71jwZVIgNQVoii3m0BU5eABJREnuGRdoBTRdq12X/aJo+z6z0p17lJTlRFQKaYHrbo9/DdBttw0cwf4pkZr2+1lKOZZ1b79X0nOkl8TSs1+Tl9PY5XWswXjC7nBLugKHiofCf87EOMJHd+QRquYjXlVklp+yb7BcT8iEcmgAtgBjdFmKw0Ey7JChaZsyrG2r+eqNcrvJWpGxHyrgLy3rzf5KJtIm6WONELvr+FlvTWSnMGg9a/w0a1mATscbX26g1PHIwqMD9xzf2+uA7h1gKokC9RFtjpe4zdg666Qhd9i684mq6VMPVlGkeFDPs+veFWwDCot54uSnFu5bNXsyeevv3YaoOW0u1U5EFwHL2KRwc/M9OWeBSePIP0NgIWRdcinxUCtbAHzrAswEWQxyGGnKHWf87NEpmGmOW0z/rW2oxbv3j1cIOij3KRRch0YBlrq7UnS1rvsT3VQ3WqLuOSNv8UodtaYzBnb9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(55016003)(52536014)(2906002)(5660300002)(38070700005)(86362001)(122000001)(38100700002)(16799955002)(478600001)(6506007)(71200400001)(26005)(7696005)(53546011)(9686003)(41300700001)(33656002)(66476007)(64756008)(186003)(66946007)(66556008)(66446008)(8676002)(966005)(83380400001)(76116006)(8936002)(4326008)(110136005)(54906003)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzBhNm03Qlc2S0xSMFlXcTBaR1hEOVZERE42d2lhWEtpUDBPVUQzMUZNZkJV?=
 =?utf-8?B?YVVzVGpaKzR4V1hNVTFCVG56RXBKanNVQ3k1aU9NYTF1ZXZnQWR5WDNuYUhw?=
 =?utf-8?B?QlVxcUZuZGRFdGpzK25tcksyblpoRnhUdUkzdENQcXliMm82STY5YzJCZ3B6?=
 =?utf-8?B?MS8vSmhyN1Jud2NlS2w2WDVjaW9rMmlLVDhzVFJBL1Vnc3ZyVS90cGVKQU5w?=
 =?utf-8?B?N0N4Rjc2UmF5TmtCQlByeU4zWkFnSWxlMzlzMnp2NXhOaUdYaEJnK3NKWU9X?=
 =?utf-8?B?aDFyQmlJcDMrZlkrOXBWQUg1UEdtNTRTL1c3cHhFQWRCcXJIcUFmYStDZHBH?=
 =?utf-8?B?Y1J6UldkZmV3U3FxRS84VTRkMjF5bit4UmxVSC9JSlJWeUtlYlE0ZHVxMGtC?=
 =?utf-8?B?cGpxMUlqcjRSbnlKUkt2NkFnQk1Qb3BYZXRsSjByc0JMc0wrMDJUa3pnQi9l?=
 =?utf-8?B?bFhkZnFGb0Zic0pDeGR1OUFwOU55TVkyMS9aSjlKQU9nc3JKQUZPZ1VNQUt2?=
 =?utf-8?B?dk9Md0Vpb0I4OVhuWTNvUktPakVpSnJJVUdMNnEzV3pSaVg4R1V1QUEzUity?=
 =?utf-8?B?a2lnSnlzVHo5ZjlTZmRaaDJvdmtwWVlMd0tIb1lSbXh0MS9MUHpaUDVtMlZn?=
 =?utf-8?B?bzR3YnIvdHVoSVFycFhidytZN3NnMXczY3EwajBHRDNkOFcrNFNPbGxuekhi?=
 =?utf-8?B?RlRDTFVHcks0dStsVmI2ZHJRQ3hqQktxeTU1OTNUM0tTdFpUTjBKWit0Rk5W?=
 =?utf-8?B?S2VQUC84MVJlVEJtRWovdkIwUmk5aWF1cXh1bzlFL0lheERzMGdVMTcrcEhT?=
 =?utf-8?B?cERFUjNRVW9mQ1RyNG85aEZ1WEVrS2ZrdENIcG1WZHljSXA1Rkg4N0NIYk5J?=
 =?utf-8?B?L09sWmNTRHBxMTBLelgrcm1TNEJuTTFycFhNTEJCUGF0S1hDbTBWWVFuYzdh?=
 =?utf-8?B?aVZlY0dIeFc1aFdsbTdIMXpDUEJzdzJQSmNZR2dKejBBa3RTVkRyRER4aTNJ?=
 =?utf-8?B?NitMTGEyL21salJXdVpYNncrL2d0NGRlUU5GZUZkOEI1UDJLV2FJY05CTFVJ?=
 =?utf-8?B?WEhubHpPRGh5eFZudVVNTXh2MVE0Yk9UV28xSXh0S3ZKcitKd2FLWWh5eFd3?=
 =?utf-8?B?N0d5MFNSWFppdDU0NS9FbVN4NHBsTlhHcXRuRURjeG9WMDQ0ZnlnUmJQWHhW?=
 =?utf-8?B?aU4vZDgyaGhhdFNsVmg4YURUT2s2L2RLSWFxUU45UDAzY2ZUdFpLR3FLM2lV?=
 =?utf-8?B?b3BzZThyOFFYRFVucDZqSXZ3OE83bml0aXl4VkdpTWNxZGxMQXB3Q2I0eWlF?=
 =?utf-8?B?dUQrQzJVQmliWUdPeEgza3BIRzkxVjdxN0ZuY0F4dm5QSERnUEwxRU8wNUNT?=
 =?utf-8?B?TzREalc5RnhLOEpaSmFwdk9hWU9rUEFTdWpjdXF1eWUrUVU1dkxKRHlBZDBy?=
 =?utf-8?B?TFVVYURtek8wM0FjZGswQ3ZnR3FsRUVuenZWTVlFZTBWVzJaUEhjMFQ5ZEZV?=
 =?utf-8?B?N1V0QW45QWUrVFI2d254dkpER2ZlWEIvV3VDSVhsVlQxQ0R2VUFTREdwd3VU?=
 =?utf-8?B?a1RkOXV3MG1ucjE5SHZzbmFlRHgxR05lV3pJSFhVQ2NVeGhNNmNlRXU0U09B?=
 =?utf-8?B?N21tTzRJc0lOWXJvUCtqOUlhZk1MM0M3eWl2SG16NnJvN0Y5NWo5Z2R0SGFS?=
 =?utf-8?B?TWw1akVaa01wRDJQcmxPemRVbDZabUJFazhhY1ljQUFxOUVhZU0yYStPR1ZD?=
 =?utf-8?B?UUtNTXU5UGNBaFM0eSsrM284ZUsyNnJ0dWJGc1BZVTA0VFNGMFVDUElHcHdt?=
 =?utf-8?B?RWZKSGZNUUw0L08zTHZ1ckZIbWlBWU5rTkJ1dTdpT2ZvUXk0ckwxNkxCRlU4?=
 =?utf-8?B?Zk5NUGFTU2pTNWR1QnNMSmp1c1ZhWmxPamZ6TXhQTFdBRVF0REplMXU1RnhT?=
 =?utf-8?B?akpIRDRGeGZhRHpoSHJ1Y283alFjY1ZXY29Wd2NZQVB4OERpVzgzVjkxZEp6?=
 =?utf-8?B?aW9oWTJVM2kyYjRrVVBFZWVuNzN6T3RqTnJnQ3IzOGMyZXpvSy92amZoMlEz?=
 =?utf-8?B?cXcxeWJDaTFFOHo5VzV0M3c4TUhRTHNMYXBVcGsrUUNlc1d4bUVWM1hRZEM0?=
 =?utf-8?Q?VEQ0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1978bd28-765a-4e26-85bc-08da7fca9a34
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2022 21:02:17.2976
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3bKLf7rsj1De7BvNYmeK8Up3hSO7V8ad6nq/jzXo9LGYdSXl8GRBDWJv/Q4JDgYOqm8iqHujKJ3TsnmGhIEI7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1846
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IFpodSwgTGluZ3NoYW4gPGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIEF1Z3VzdCAxNiwgMjAyMiAxMjoxOSBBTQ0KPiANCj4gDQo+IE9uIDgvMTYvMjAy
MiAxMDozMiBBTSwgUGFyYXYgUGFuZGl0IHdyb3RlOg0KPiA+PiBGcm9tOiBaaHUgTGluZ3NoYW4g
PGxpbmdzaGFuLnpodUBpbnRlbC5jb20+DQo+ID4+IFNlbnQ6IE1vbmRheSwgQXVndXN0IDE1LCAy
MDIyIDU6MjcgQU0NCj4gPj4NCj4gPj4gU29tZSBmaWVsZHMgb2YgdmlydGlvLW5ldCBkZXZpY2Ug
Y29uZmlnIHNwYWNlIGFyZSBjb25kaXRpb25hbCBvbiB0aGUNCj4gPj4gZmVhdHVyZSBiaXRzLCB0
aGUgc3BlYyBzYXlzOg0KPiA+Pg0KPiA+PiAiVGhlIG1hYyBhZGRyZXNzIGZpZWxkIGFsd2F5cyBl
eGlzdHMNCj4gPj4gKHRob3VnaCBpcyBvbmx5IHZhbGlkIGlmIFZJUlRJT19ORVRfRl9NQUMgaXMg
c2V0KSINCj4gPj4NCj4gPj4gIm1heF92aXJ0cXVldWVfcGFpcnMgb25seSBleGlzdHMgaWYgVklS
VElPX05FVF9GX01RIG9yDQo+ID4+IFZJUlRJT19ORVRfRl9SU1MgaXMgc2V0Ig0KPiA+Pg0KPiA+
PiAibXR1IG9ubHkgZXhpc3RzIGlmIFZJUlRJT19ORVRfRl9NVFUgaXMgc2V0Ig0KPiA+Pg0KPiA+
PiBzbyB3ZSBzaG91bGQgcmVhZCBNVFUsIE1BQyBhbmQgTVEgaW4gdGhlIGRldmljZSBjb25maWcg
c3BhY2Ugb25seQ0KPiA+PiB3aGVuIHRoZXNlIGZlYXR1cmUgYml0cyBhcmUgb2ZmZXJlZC4NCj4g
PiBZZXMuDQo+ID4NCj4gPj4gRm9yIE1RLCBpZiBib3RoIFZJUlRJT19ORVRfRl9NUSBhbmQgVklS
VElPX05FVF9GX1JTUyBhcmUgbm90IHNldCwNCj4gdGhlDQo+ID4+IHZpcnRpbyBkZXZpY2Ugc2hv
dWxkIGhhdmUgb25lIHF1ZXVlIHBhaXIgYXMgZGVmYXVsdCB2YWx1ZSwgc28gd2hlbg0KPiA+PiB1
c2Vyc3BhY2UgcXVlcnlpbmcgcXVldWUgcGFpciBudW1iZXJzLCBpdCBzaG91bGQgcmV0dXJuIG1x
PTEgdGhhbiB6ZXJvLg0KPiA+IE5vLg0KPiA+IE5vIG5lZWQgdG8gdHJlYXQgbWFjIGFuZCBtYXhf
cXBzIGRpZmZlcmVudGx5Lg0KPiA+IEl0IGlzIG1lYW5pbmdsZXNzIHRvIGRpZmZlcmVudGlhdGUg
d2hlbiBmaWVsZCBleGlzdC9ub3QtZXhpc3RzIHZzIHZhbHVlDQo+IHZhbGlkL25vdCB2YWxpZC4N
Cj4gYXMgd2UgZGlzY3Vzc2VkIGJlZm9yZSwgTVEgaGFzIGEgZGVmYXVsdCB2YWx1ZSAxLCB0byBi
ZSBhIGZ1bmN0aW9uYWwgdmlydGlvLQ0KPiBuZXQgZGV2aWNlLCB3aGlsZSBNQUMgaGFzIG5vIGRl
ZmF1bHQgdmFsdWUsIGlmIG5vIFZJUlRJT19ORVRfRl9NQUMgc2V0LA0KPiB0aGUgZHJpdmVyIHNo
b3VsZCBnZW5lcmF0ZSBhIHJhbmRvbSBNQUMuDQo+ID4NCj4gPj4gRm9yIE1UVSwgaWYgVklSVElP
X05FVF9GX01UVSBpcyBub3Qgc2V0LCB3ZSBzaG91bGQgbm90IHJlYWQgTVRVIGZyb20NCj4gPj4g
dGhlIGRldmljZSBjb25maWcgc2FwY2UuDQo+ID4+IFJGQzg5NCA8QSBTdGFuZGFyZCBmb3IgdGhl
IFRyYW5zbWlzc2lvbiBvZiBJUCBEYXRhZ3JhbXMgb3ZlciBFdGhlcm5ldA0KPiA+PiBOZXR3b3Jr
cz4gc2F5czoiVGhlIG1pbmltdW0gbGVuZ3RoIG9mIHRoZSBkYXRhIGZpZWxkIG9mIGEgcGFja2V0
IHNlbnQNCj4gPj4gTmV0d29ya3M+IG92ZXINCj4gPj4gYW4gRXRoZXJuZXQgaXMgMTUwMCBvY3Rl
dHMsIHRodXMgdGhlIG1heGltdW0gbGVuZ3RoIG9mIGFuIElQIGRhdGFncmFtDQo+ID4+IHNlbnQg
b3ZlciBhbiBFdGhlcm5ldCBpcyAxNTAwIG9jdGV0cy4gIEltcGxlbWVudGF0aW9ucyBhcmUgZW5j
b3VyYWdlZA0KPiA+PiB0byBzdXBwb3J0IGZ1bGwtbGVuZ3RoIHBhY2tldHMiDQo+ID4gVGhpcyBs
aW5lIGluIHRoZSBSRkMgODk0IG9mIDE5ODQgaXMgd3JvbmcuDQo+ID4gRXJyYXRhIGFscmVhZHkg
ZXhpc3RzIGZvciBpdCBhdCBbMV0uDQo+ID4NCj4gPiBbMV0gaHR0cHM6Ly93d3cucmZjLWVkaXRv
ci5vcmcvZXJyYXRhX3NlYXJjaC5waHA/cmZjPTg5NCZyZWNfc3RhdHVzPTANCj4gT0ssIHNvIEkg
dGhpbmsgd2Ugc2hvdWxkIHJldHVybiBub3RoaW5nIGlmIF9GX01UVSBub3Qgc2V0LCBsaWtlIGhh
bmRsaW5nIHRoZQ0KPiBNQUMNCj4gPg0KPiA+PiB2aXJ0aW8gc3BlYyBzYXlzOiJUaGUgdmlydGlv
IG5ldHdvcmsgZGV2aWNlIGlzIGEgdmlydHVhbCBldGhlcm5ldA0KPiA+PiBjYXJkIiwgc28gdGhl
IGRlZmF1bHQgTVRVIHZhbHVlIHNob3VsZCBiZSAxNTAwIGZvciB2aXJ0aW8tbmV0Lg0KPiA+Pg0K
PiA+IFByYWN0aWNhbGx5IEkgaGF2ZSBzZWVuIDE1MDAgYW5kIGhpZ2hlIG10dS4NCj4gPiBBbmQg
dGhpcyBkZXJpdmF0aW9uIGlzIG5vdCBnb29kIG9mIHdoYXQgc2hvdWxkIGJlIHRoZSBkZWZhdWx0
IG10dSBhcyBhYm92ZQ0KPiBlcnJhdGEgZXhpc3RzLg0KPiA+DQo+ID4gQW5kIEkgc2VlIHRoZSBj
b2RlIGJlbG93IHdoeSB5b3UgbmVlZCB0byB3b3JrIHNvIGhhcmQgdG8gZGVmaW5lIGEgZGVmYXVs
dA0KPiB2YWx1ZSBzbyB0aGF0IF9NUSBhbmQgX01UVSBjYW4gcmVwb3J0IGRlZmF1bHQgdmFsdWVz
Lg0KPiA+DQo+ID4gVGhlcmUgaXMgcmVhbGx5IG5vIG5lZWQgZm9yIHRoaXMgY29tcGxleGl0eSBh
bmQgc3VjaCBhIGxvbmcgY29tbWl0DQo+IG1lc3NhZ2UuDQo+ID4NCj4gPiBDYW4gd2UgcGxlYXNl
IGV4cG9zZSBmZWF0dXJlIGJpdHMgYXMtaXMgYW5kIHJlcG9ydCBjb25maWcgc3BhY2UgZmllbGQg
d2hpY2gNCj4gYXJlIHZhbGlkPw0KPiA+DQo+ID4gVXNlciBzcGFjZSB3aWxsIGJlIHF1ZXJ5aW5n
IGJvdGguDQo+IEkgdGhpbmsgTUFDIGFuZCBNVFUgZG9uJ3QgaGF2ZSBkZWZhdWx0IHZhbHVlcywg
c28gcmV0dXJuIG5vdGhpbmcgaWYgdGhlDQo+IGZlYXR1cmUgYml0cyBub3Qgc2V0LCANCg0KPiBm
b3IgTVEsIGl0IGlzIHN0aWxsIG1heF92cV9wYXJpcyA9PSAxIGJ5IGRlZmF1bHQuDQoNCkkgaGF2
ZSBzdHJlc3NlZCBlbm91Z2ggdG8gaGlnaGxpZ2h0IHRoZSBmYWN0IHRoYXQgd2UgZG9u4oCZdCB3
YW50IHRvIHN0YXJ0IGRpZ2dpbmcgZGVmYXVsdC9ubyBkZWZhdWx0LCB2YWxpZC9uby12YWxpZCBw
YXJ0IG9mIHRoZSBzcGVjLg0KSSBwcmVmZXIga2VybmVsIHRvIHJlcG9ydGluZyBmaWVsZHMgdGhh
dCBfZXhpc3RzXyBpbiB0aGUgY29uZmlnIHNwYWNlIGFuZCBhcmUgdmFsaWQuDQpJIHdpbGwgbGV0
IE1TVCB0byBoYW5kbGUgdGhlIG1haW50ZW5hbmNlIG5pZ2h0bWFyZSB0aGF0IHRoaXMga2luZCBv
ZiBwYXRjaCBicmluZ3MgaW4gd2l0aG91dCBhbnkgdmlzaWJsZSBnYWluIHRvIHVzZXIgc3BhY2Uv
b3JjaGVzdHJhdGlvbiBhcHBzLg0KDQpBIGxvZ2ljIHRoYXQgY2FuIGJlIGVhc2lseSBidWlsZCBp
biB1c2VyIHNwYWNlLCBzaG91bGQgYmUgd3JpdHRlbiBpbiB1c2VyIHNwYWNlLg0KSSBjb25jbHVk
ZSBteSB0aG91Z2h0cyBoZXJlIGZvciB0aGlzIGRpc2N1c3Npb24uDQoNCkkgd2lsbCBsZXQgTVNU
IHRvIGRlY2lkZSBob3cgaGUgcHJlZmVycyB0byBwcm9jZWVkLg0KDQo+DQo+ID4+ICsJaWYgKChm
ZWF0dXJlcyAmIEJJVF9VTEwoVklSVElPX05FVF9GX01UVSkpID09IDApDQo+ID4+ICsJCXZhbF91
MTYgPSAxNTAwOw0KPiA+PiArCWVsc2UNCj4gPj4gKwkJdmFsX3UxNiA9IF9fdmlydGlvMTZfdG9f
Y3B1KHRydWUsIGNvbmZpZy0+bXR1KTsNCj4gPj4gKw0KPiA+IE5lZWQgdG8gd29yayBoYXJkIHRv
IGZpbmQgZGVmYXVsdCB2YWx1ZXMgYW5kIHRoYXQgdG9vIHR1cm5lZCBvdXQgaGFkDQo+IGVycmF0
YS4NCj4gPiBUaGVyZSBhcmUgbW9yZSBmaWVsZHMgdGhhdCBkb2VzbuKAmXQgaGF2ZSBkZWZhdWx0
IHZhbHVlcy4NCj4gPg0KPiA+IFRoZXJlIGlzIG5vIHBvaW50IGluIGtlcm5lbCBkb2luZyB0aGlz
IGd1ZXNzIHdvcmssIHRoYXQgdXNlciBzcGFjZSBjYW4gZmlndXJlDQo+IG91dCBvZiB3aGF0IGlz
IHZhbGlkL2ludmFsaWQuDQo+IEl0J3Mgbm90IGd1ZXN0IHdvcmssIHdoZW4gZ3Vlc3QgZmluZHMg
bm8gZmVhdHVyZSBiaXRzIHNldCwgaXQgY2FuIGRlY2lkZSB3aGF0DQo+IHRvIGRvLiANCg0KQWJv
dmUgY29kZSBvZiBkb2luZyAxNTAwIHdhcyBwcm9iYWJseSBhbiBob25lc3QgYXR0ZW1wdCB0byBm
aW5kIGEgbGVnaXRpbWF0ZSBkZWZhdWx0IHZhbHVlLCBhbmQgd2Ugc2F3IHRoYXQgaXQgZG9lc27i
gJl0IHdvcmsuDQpUaGlzIGlzIHNlY29uZCBleGFtcGxlIGFmdGVyIF9NUSB0aGF0IHdlIGJvdGgg
YWdyZWUgc2hvdWxkIG5vdCByZXR1cm4gZGVmYXVsdC4NCg0KQW5kIHRoZXJlIGFyZSBtb3JlIGZp
ZWxkcyBjb21pbmcgaW4gdGhpcyBhcmVhLg0KSGVuY2UsIEkgcHJlZmVyIHRvIG5vdCBhdm9pZCBy
ZXR1cm5pbmcgc3VjaCBkZWZhdWx0cyBmb3IgTUFDLCBNVFUsIE1RIGFuZCByZXN0IGFsbCBmaWVs
ZHMgd2hpY2ggZG9lc27igJl0IF9leGlzdHNfLg0KDQpJIHdpbGwgbGV0IE1TVCB0byBkZWNpZGUg
aG93IGhlIHByZWZlcnMgdG8gcHJvY2VlZCBmb3IgZXZlcnkgZmllbGQgdG8gY29tZSBuZXh0Lg0K
VGhhbmtzLg0KDQo=
