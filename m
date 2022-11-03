Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49DE8617EFD
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:12:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiKCOMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbiKCOMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:12:33 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-centralusazon11023027.outbound.protection.outlook.com [52.101.64.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4BFFAFE;
        Thu,  3 Nov 2022 07:12:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OAGz8G5zRfd/b1p/+xrU2HSUVq7G37yk3iyywVoSWUe6gjPcikvfdQZUCGI7ecXwRNG37R+8tQuiPlS1N0iAaSSQKnfUMCokr6KFmYKK9IPIpJeJSlZCBKIdGvQrYW4yz2Zzio/Oh7PSCAhQ3jcAt0xULFFmwaa2YAfXDp17e+UUhcGJagciKavSbil34VC630BT4hdzwQKLv1OQ5Fp0SLORRO9w7t6NpjMa8jPrqOZ0JBLn4szweKfkEBVc4JWF966VEmqJS4/nsA/Np67jcQ+dHGB8bD/GnZ5Hk815h8S4xtT60hXYQhSdqwN2J6tKKbS7DgcghPCdroGjCPSSDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JqbOyUvOUrBABtbEBJcPiMfonq99p5c3r3YcqYZ3yCU=;
 b=Mfc7hCUVFpNa9c2Z7puxHHsXTD5p3DybO8+OMpBEnJY2IjdTmC0hOw2A4PnwNsCA5mO4sEguwBsFyMqSECHxiFE7SY2Orf10cyOABv0EILfxCzfZEXWbjQgg8uF0yoo3k6MGgg/V4j2w18fbdEP8f3VchHYpwZP8qdTnX5yDt53qOj3SKQ4l0sNc3+ze2/c/gD4rW+xFoZ5o6WXAqDrLcOXT7/j9DUojPSdQp3592U41sXc5FBkuVv+bbwG6yNbVQdVjtSkFgRE8jl2bjWCmq0WXXdJZttdXA7hAiFJunA+ROd5dKhHQUC4Tr3XJlgMGRU6it9n3l4H2ev+nOlwyjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JqbOyUvOUrBABtbEBJcPiMfonq99p5c3r3YcqYZ3yCU=;
 b=TguBQDVzIXCiOWO8F4gE83ohazs8kp5ZQ1OANlgZ9fWqgZOTWHMmrmHGG9FS6h8LCtnFCA4AxejWpbQoJGdediR9H1Y7KCQkDvThHt8YKw7FYon3HUDIt0w8QoALTj0x2NSq/OLwWWScy6kLzEqPQjDMdcu6lwBA/rBzVeJjkdo=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by PH0PR21MB1911.namprd21.prod.outlook.com (2603:10b6:510:1f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.5; Thu, 3 Nov
 2022 14:12:23 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::f565:80ed:8070:474b]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::f565:80ed:8070:474b%8]) with mapi id 15.20.5813.008; Thu, 3 Nov 2022
 14:12:22 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Tianyu Lan <ltykernel@gmail.com>, "hpa@zytor.com" <hpa@zytor.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "lpieralisi@kernel.org" <lpieralisi@kernel.org>,
        "robh@kernel.org" <robh@kernel.org>, "kw@linux.com" <kw@linux.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "isaku.yamahata@intel.com" <isaku.yamahata@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "jane.chu@oracle.com" <jane.chu@oracle.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: RE: [PATCH 05/12] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Topic: [PATCH 05/12] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
Thread-Index: AQHY5K2TMxpWCFa020OvkDhl8nmDWa4tT/OAgAABxDA=
Date:   Thu, 3 Nov 2022 14:12:22 +0000
Message-ID: <BYAPR21MB168867D803CE3A463553BA88D7389@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
 <1666288635-72591-6-git-send-email-mikelley@microsoft.com>
 <1eedc23a-8b50-bd90-d398-cff3f22af01e@gmail.com>
In-Reply-To: <1eedc23a-8b50-bd90-d398-cff3f22af01e@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=256ca772-778b-4866-ad1c-0aa5a60e2523;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-11-03T14:06:57Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|PH0PR21MB1911:EE_
x-ms-office365-filtering-correlation-id: 4ad671fa-cce3-4fd8-cf86-08dabda56d54
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4XGhQyb8PQdWFDvOJbU7QcITDFdqhvuYIjy09O/bKBQTdYENC3St57IH9XSnJjOCpkq0i9dB1Qn5Z2wPl9jFcekIjWlZQokVuDJHyCjUR3pdIM/21MfSAAowb87GD8sV6ei7nOkVzbsiBBS6gX1172Dov+uSvrBG0nJUEfidqYF9VteGQuuaLHK+22DVkECWkb5rBh3HZpFfuDAAynkriRRZJhRe9HoNqJvqvpZjkhoIMjGnl1y95K4TEmmTjZ6J1rgR7sbqa0BigrjLxqX0px5kgFFtqzxV5Ruhimo4aUoXCQJwcdKnZCpsvnA6qVdbAlMcgaBtqL6nkxvZcR2RhCIOIu5Z0qsdz/zYSsLP7E8gS38sgymC9+iFy/rT7Iog72r2MMSmngpJoLu7sYYlSj17nS5mXrMALOgj9peR8BJcEeuGbQiscVk5SXYjlm4Gy4cF7M0AoCSNnt8fyhBqc51CMMn5Pc+s8X/mZYJguA0/Zo8dgt8Yxpp57TXipLwp0E1eeivVRSjXViosCJm0dexkgc2TeyCZyq9K6aGv4b9xFkAzgvdZl0Vl0WYIyzi4+Gex7Ef/10OOHSFZGLoefSvwmwr9qf02E9Or+Pp2JAyF81RMbCfyrht1EtRjNH1X+pEuzsY5rgOaFXyglAxrSbPBX20jv+CFQO/7Dk5iFz4EIEeRugcAI/70ELSWrMv/1xcK9xlDlTluHD/IsXSxe1VG0qO3rsom+ELLfOVZ4TfwVY6L3sgiKqsJYILSRRG6ILhBcMDu1YaoY9ZfNjeTkBL2KtSaXi9+3/znv3oYNnO8an3yknn1fdb41tZJglczY9xzuziT/q700JUDjHQIjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(376002)(346002)(396003)(39860400002)(451199015)(2906002)(122000001)(8990500004)(66556008)(316002)(64756008)(76116006)(66476007)(66946007)(26005)(8676002)(66446008)(6506007)(9686003)(86362001)(41300700001)(110136005)(8936002)(33656002)(5660300002)(7696005)(4744005)(38070700005)(52536014)(7416002)(7406005)(921005)(82960400001)(38100700002)(478600001)(83380400001)(53546011)(55016003)(71200400001)(82950400001)(10290500003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VU5tMTdvcHc2eWRadEF2R1JyQ3J3UFZyWjNFcEVCRjZobXNOY2dHVjN2anU3?=
 =?utf-8?B?YVY1TmNIcTVRM1pZZVpzWTA0VmxURTgyQlFyOFhCMzlPZEdQWDJtQ1lRT2tI?=
 =?utf-8?B?b3Ard0xTRjBBWUJoTnFIZWt4S3d2c3dzR2RnQWlkR0tZQVU2cjhkdEpwRzBa?=
 =?utf-8?B?Tk16dWNjOGl4TGc1YWJJZkZTRSsvSzdMZDBvRlU4d0ZrUE5OMEszYU9qcldI?=
 =?utf-8?B?N1VSREpwUi8wZWZRTzVNbENaMU50RW9hcW9VMkZnRkVITGtQK3k1REt5c1pZ?=
 =?utf-8?B?eVJQa211enVzQjFHYXplcktMYWJuSHpaR3cvQjJYV0JQVXVzc1hXbGUxdzJP?=
 =?utf-8?B?MFFIYk9wcTdrQ0htNmRIcUlyaDNQb294d1cvQVVRbDE3SHNUVS9tNWFpa0hF?=
 =?utf-8?B?UjdZNTc2MitlUWxiOXZTQU0yeUVsQ081WEdMY1BzUHZnSVZzb0ZFMk9PM203?=
 =?utf-8?B?OXlOZ0d2blhNRHA4Wi9RbmRGci8yam5jNVZXTWxPdU8rV05na0xkYStISExM?=
 =?utf-8?B?VGgxdGw3dzg3ZWtmQjRwLysxTjdXTG5GTDNOVEF1MmZjd2VER2tFaGxRQmxs?=
 =?utf-8?B?eXU5REcvVmdYcXI5eXFmUTYvbXFSRVdtckZ5cnpXVnpkT0xqemhtaGtFdUFF?=
 =?utf-8?B?WnZZTVdMY2taaXVYR2xhNWNQQXg4bTVHQ2YxQTRuRnMwYXhPVXEyQ3pIMlFl?=
 =?utf-8?B?UUhKK3EydjFCWWt5dGR5c29qejJVU3hqSkhKWmlCZUlVb0d5L2ZpQmw5aEtM?=
 =?utf-8?B?MjFrbS95UXE2cnZzN1hQSWtvVFdjWC9oUHpTRmN2dEVZdnJ2Yk9Ra28vQWQx?=
 =?utf-8?B?bmM2eThQWU5SMm9EeHF2MmlXa3lHOTJtYWZONEh2Z0JScmtZNnpHNWNHTDhO?=
 =?utf-8?B?UEc3R2Uza0dRTWtLSDRHRlBCUDlJNWpNd1VLVkVQU1JZTHpBSGVOcUw3NEZw?=
 =?utf-8?B?MUVGT1JqbWk2Nko3dW5pV0pRMkZKbVo0aVZRSkpvYU1OalRNUU9TeDJZNXVL?=
 =?utf-8?B?ZTBIakVvTUUyeXcxRFdNaW5yOERwaDNXZzVUc1RwRlNkQ0I0QWFQYUVEL0ox?=
 =?utf-8?B?RUtINGsxS25OWU5PUUt0Yi90LytzRUk3S08wS3Y3Z21JVXJOaDRucllMR0Jw?=
 =?utf-8?B?WnE2LzJ3eDVtMDM5dExOcVI5dWtsclUrclllcS94S2Q4dlVJK09MTlNNamNa?=
 =?utf-8?B?am9HaDhER3F1TEE5U0pmUTM1RzJPbTdHczlJek52RHRiMEFrMTd2N21keTZJ?=
 =?utf-8?B?QTdkdTltSURXVThRRndlV0xrdVFvN0U4dXJzME9ZWDExRjUwMjlnQjRtKytN?=
 =?utf-8?B?VGpwaTZDQ1M2NFdNenUrQlNzampadytiNStYR01zZ01ORnIzSVZ6ZFIyZ1d3?=
 =?utf-8?B?Z3ZiWDFxQklpVUNkQ3ExdEU3THUvbW5ncnJBM3NjUVhZb2NxR1dEVHR2Qkpv?=
 =?utf-8?B?NUh6NWpqenBiSnc1WFlwVEw1MWl2QWhVVW5OaExxQmNqMGw1K3JzMS9DZk0z?=
 =?utf-8?B?dUJTblowS3FvblR4VlZVSzk4MjAyb04waTVON0tQaFBJMFk3TnBVbmZta2Q4?=
 =?utf-8?B?Z0svS1JUT1cyakNocmU2dlF3T1Y3WHhTYllvMTAzQjRpOGl2TlpjM3FsbTUv?=
 =?utf-8?B?R2JaTkZ1UWhiVGNlQ2g3ak5ER2Y0S282TTJ5azRmd0xRcXI1My85VGk1UjYw?=
 =?utf-8?B?M3YyWnNLTVlOZytOY0lHckdTSzlVVUViZXJhZjYzdm04eUw3T2VUYU1yU2hm?=
 =?utf-8?B?UHhKWVJaUXM5MmFEeHZxeDNQZUQweUFmRTd3VVZLY2toZFRGaU43MEpIcU14?=
 =?utf-8?B?bFlOZGJzS3Y4aXA5L2piVS9oY3ppMndkWVR6djRwSWJFb3VzUXdYdERlZEp4?=
 =?utf-8?B?RzFab0tyN1NpbDVjSXZUUHhRMUtDekhxM1FxL0RRYzFjU0FseDhnZHNmTVJ4?=
 =?utf-8?B?MUt1STJacVBkQkxGMy9EWUZEek5WemJYSDI1dzVLdXJOQ3NQcWdUb0VCZXpO?=
 =?utf-8?B?bDUwTnAyRWJwaXZVMUNLWWNSWXhzeFU1ZmZhRlViUm9kdkZFMHVuSHkwbmxS?=
 =?utf-8?B?Q1pqZnlEdUJjbDJ5QzE4TFdRdEViWm1vZFRGSkZtR3JBZUtjb2xHN3FzSkYy?=
 =?utf-8?B?UTlEMnY1WmFiTkZNR1k2MHo2aDdhZzh3V2ZtM0JubXpORUxJWkw2SWo0dkNr?=
 =?utf-8?B?c1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ad671fa-cce3-4fd8-cf86-08dabda56d54
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 14:12:22.7562
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: My7FdD78saKg52BG04aUThJABjxOM7M2KUjbwm4z7A4UHuvJXAleY2nSErBqJNN/nnFRdYQBXfzjoOvetoCZdtuVLDIx2Cwri56NOmm722A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR21MB1911
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGlhbnl1IExhbiA8bHR5a2VybmVsQGdtYWlsLmNvbT4gU2VudDogVGh1cnNkYXksIE5v
dmVtYmVyIDMsIDIwMjIgNzowMSBBTQ0KPiANCj4gT24gMTAvMjEvMjAyMiAxOjU3IEFNLCBNaWNo
YWVsIEtlbGxleSB3cm90ZToNCj4gPiArDQo+ID4gK3ZvaWQgX19pbml0IGh2X3Z0b21faW5pdCh2
b2lkKQ0KPiA+ICt7DQo+ID4gKwljY19zZXRfdmVuZG9yKENDX1ZFTkRPUl9IWVBFUlYpOw0KPiA+
ICsJY2Nfc2V0X21hc2sobXNfaHlwZXJ2LnNoYXJlZF9ncGFfYm91bmRhcnkpOw0KPiA+ICsJcGh5
c2ljYWxfbWFzayAmPSBtc19oeXBlcnYuc2hhcmVkX2dwYV9ib3VuZGFyeSAtIDE7DQo+IA0KPiAN
Cj4gaHZfdnRvbV9pbml0KCkgYWxzbyB3b3JrcyBmb3IgVkJTIGNhc2UuIFZCUyBkb2Vzbid0IGhh
dmUgdlRPTSBzdXBwb3J0DQo+IGFuZCBzbyBzaGFyZWRfZ3BhX2JvdW5kYXJ5IHNob3VsZCBub3Qg
YmUgYXBwbGllZCBmb3IgVkJTLiBIZXJlIHNlZW1zIHRvDQo+IGFzc3VtZSBtc19oeXBlcnYuc2hh
cmVkX2dwYV9ib3VuZGFyeSB0byAwIGZvciBWQlMsIHJpZ2h0Pw0KDQpZZXMsIHRoYXQgaXMgY29y
cmVjdC4gIEluIGZhY3QsIHlvdSdsbCBub3RpY2UgdGhhdCB0aGlzIHBhdGNoIHNsaWdodGx5IGNo
YW5nZXMNCnRoZSBjb2RlIGluIG1zX2h5cGVydl9pbml0X3BsYXRmb3JtKCkgc28gdGhhdCBzaGFy
ZWRfZ3BhX2JvdW5kYXJ5IGlzDQpzZXQgb25seSB3aGVuIGl0IGlzIGtub3duIHRvIGJlIHZhbGlk
OyBvdGhlcndpc2UgaXQgaXMgbGVmdCBhcyB6ZXJvLiAgVGhpcw0KY2hhbmdlIGlzIHNwZWNpZmlj
YWxseSBzbyB0aGF0IHNoYXJlZF9ncGFfYm91bmRhcnkgaXMgemVybyBmb3IgdGhlIFZCUw0KY2Fz
ZS4NCg0KTWljaGFlbA0K
