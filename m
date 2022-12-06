Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7425644D21
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiLFUOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiLFUNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:13:54 -0500
Received: from CY4PR02CU007-vft-obe.outbound.protection.outlook.com (mail-westcentralusazon11021025.outbound.protection.outlook.com [40.93.199.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55978442C8;
        Tue,  6 Dec 2022 12:13:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAEhwAwS9nBLeI8anb15dAsmHEw+o899ADg6SUB1MBN2gOerfyl1tjXVVMapv/BCk7B8CMTOkwX7TxyxHRb0r8WlMB7tCRNXqRocRwjx9TlN/jpftzSTTCREZMb4O92MH9HOxE2WQbaMaoj2Z6VctstyBokgQcao1b64tkVOPQDM+xdaeTSkvVynrTjjy4mf17mSpE/vszabNaGIM2kVIxXbemNbQx+TRkrdbaNQMjLEVhpbBSGLsCqtLcK7Slo2ex4S6emiYqTEUQ/z0uYRNRWSptK7JkvesUvntMxjLArmFGf7qvQaRZUPfxTWA/CCH7hrz2MJJtLzYyH668VQxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tFrFgAc28fUlIP4u/CxBV8TLKHWgFO4un7YC4GCn0cA=;
 b=FIRm63ArqC9dnQ2lTj1R1+rrQ0XMGS+IEkEbrIlfJJJwu9dHExZlF6IZ8FJnsFHuWo1jBgpe5VnTfMHouEkyCIdoGaSrQWKmIS8WGnzKx2hmMZYovldzRvdHOp/zkcGPQPOIjCWt0DybcshXfS8yWyhv2S5Cv4wzIqGVU/VhqNED1AvbpXuxJLBsODdoqbp7AYGRVfw9773KdQXbejHjsbQ4i/pqcI/hfwQlSo1dDtWXY6FcUnzTa+ih8pOakf//memwTVP2deIA5AbTzgdAIXP9rb/MSRBY8UsuIlOI0jpv/m/L4dDcR3/ljFAqdLvMa9x1BSyxkfeUtqruVV4v+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tFrFgAc28fUlIP4u/CxBV8TLKHWgFO4un7YC4GCn0cA=;
 b=SP67krvmHz/lhLh8fjmebshvnkQnyES5uaa/xWUjdzm4Pm20G4/h1CAYYWVOewNjjBoIR52tZCYMqI/XOEkg4HNuuVf8AnOxSL9oXBB4EmgU0MiVqpH3zvKLT1L2t+SKxi3WTY+B5o7/013q5+hKConJxDHErv89A5t02ZTVNc0=
Received: from BYAPR21MB1688.namprd21.prod.outlook.com (2603:10b6:a02:bf::26)
 by IA1PR21MB3400.namprd21.prod.outlook.com (2603:10b6:208:3e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.4; Tue, 6 Dec
 2022 20:13:10 +0000
Received: from BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd]) by BYAPR21MB1688.namprd21.prod.outlook.com
 ([fe80::1e50:78ec:6954:d6dd%5]) with mapi id 15.20.5924.004; Tue, 6 Dec 2022
 20:13:09 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
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
Subject: RE: [Patch v4 05/13] init: Call mem_encrypt_init() after Hyper-V
 hypercall init is done
Thread-Topic: [Patch v4 05/13] init: Call mem_encrypt_init() after Hyper-V
 hypercall init is done
Thread-Index: AQHZBf6sn+ZXM6Ly40q2Zb/xUXDSYq5hSGwAgAAEzKA=
Date:   Tue, 6 Dec 2022 20:13:08 +0000
Message-ID: <BYAPR21MB1688BD8EF5F5E7B572846116D71B9@BYAPR21MB1688.namprd21.prod.outlook.com>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
 <1669951831-4180-6-git-send-email-mikelley@microsoft.com>
 <51fb66d6-f2e0-f11c-68a3-525723d56dd4@linux.intel.com>
In-Reply-To: <51fb66d6-f2e0-f11c-68a3-525723d56dd4@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f609deda-5f74-40f3-b17a-941f892976c9;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-12-06T19:54:51Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR21MB1688:EE_|IA1PR21MB3400:EE_
x-ms-office365-filtering-correlation-id: 932aec9b-4915-4484-cbf3-08dad7c64b23
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DBvwILjSp/IljFzBXkeLLX66COryhZ37DrLprEXNkRkdVO3ut3RtSVv1vIkQGN8roEJAa5Fzl/CUVUS2UEnOXmUm4h0cYeCb10Bg+UNkwac5calxwKHoS4zBRaZbLhnRC+hUSag8gyG1p9czPuhOaZjS7qQ8OqSE9JhEU8qnkEnsm3rNvVptp1QZwTiVT9TNGgEKxpTDyx5bG8K7KshZb+2twysLOeGEtGKpsflhyW5X32v4Z+XZlD/4PE9SYfceWBl1j5jlYGI18AI0WsjyWjdRvCjCAmm/1rOdN5d0U96aarLki++ZbVHVvWBzkNwlG6oDB9JCU6OUf0PHnC/8/KlPhj5MPf1P/9IZ0LCarR21mmtSjUKWmu3SCOl/TeWMbHa4Cv/Khyb3qF8p+dL0Qs8HUQ/DRhEsZ2dNJDYBoFmtpFIeCd4BEqt8zWJ25H7ww0wCc05pk1gz+6vszsEoS+1jJLPdQuqiH4u2ziKsjQJeORz9znpxssz8SiIC6RmOOoO+Ll8ouPJijyzDJCyMVMC2Us9e+qAwCjqa1/GETTQIhAi+P5fOna4mEEJeQ8h5fyYG/C2yK0YkJ1LDIJmBqL2or1cxbgc107vNH2ISjysVPbynju8432MtUIVegSlAkK+YMzvxJONEu67s/tO4DauLb3w3PgtZx10qjhl2fHst9ZvCtuOOaHzq3oZScDFGjpKtdUk8f47FwbhM4npxMvFZaOYyUFbeOzB+qdu4vVp0ii9CDWSA3t1LaTfHl9m1w9nHUqpwGpV0nQli3CGOMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1688.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199015)(122000001)(83380400001)(33656002)(8676002)(82950400001)(921005)(82960400001)(7406005)(7416002)(41300700001)(5660300002)(2906002)(8936002)(38070700005)(52536014)(76116006)(8990500004)(6506007)(186003)(7696005)(64756008)(53546011)(26005)(9686003)(478600001)(110136005)(316002)(66556008)(66446008)(10290500003)(55016003)(71200400001)(86362001)(66946007)(66476007)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z25GZnEvZVpSS1NHV0FqZkliV3FVbDRoL1JjZ05kS040SFQrdlZYZDJBcUZC?=
 =?utf-8?B?azFGYy9FSGo0d0NEVVJ1RENKeDkrWnpnaVVYd05hdkYxbXlnTC9heEp6Zys0?=
 =?utf-8?B?dUVaM3FmcS90NWJyUDZKaFp5a2RrRmxRUGtqV2ZGSXFzdm9YNHFyYkZ3bzYw?=
 =?utf-8?B?Q3VlWjJmc1lmcGZiWU1jQmxwNUZMamsvQ1dpbnJJeTBzdWk2b0pYOGlJVzhN?=
 =?utf-8?B?OG9nQnZDc0JybzVsUHpydFRDeWJkLzUvUXJMS01HcDZuVlpGYU5qSTJSK3dP?=
 =?utf-8?B?UE53dnRJN0VQL1d1dDUyVkN5K2o3R1dWYW9JeE0rcGJkU0E1dUJxQ0V3dks2?=
 =?utf-8?B?OW5nWVU1ZVpWQ1ZPU1hOQjVqQkkwYVRFajRTSldiTmZWeitrUmNHcDF6MjhX?=
 =?utf-8?B?V2VVZERWYTVJaVZKZ2VEcU5zR3pMUU8wMlltSHRGZitnSGMvQXl2Z2JOOHVL?=
 =?utf-8?B?cVA3MHRHNXRkb1RoV3dPSHNSSVNrSXdaOHRnZmhIRytaaTBkVnBud05rdW1F?=
 =?utf-8?B?V3pDODVuWC81VVZmY3FoMTFUKzhGRzZQNlBLNkhOTlU0SEdZSWJvZGtTdkps?=
 =?utf-8?B?ZTRHczdTQ2ROUEJXeTZNQkxQT1IwV29VK3BnN2ZWYWh3R29yT01oNWJJMFhS?=
 =?utf-8?B?dUFnazFzU1NOUUJreXRNRjRCWmw0V0wrOUVqdmsvMjF2VGJSbU01Q2FYeCtm?=
 =?utf-8?B?NndaR0duN2l6eG1NaTJweWF4MUc5VDJiaTExaDJRYm4wSGZDWlJKWHdlMzNE?=
 =?utf-8?B?Nm5aejNTMU5ra3hTdUVDYWp0VS9OOWFPYzVibFR3N0tnZE8rM3NxbzluRDhl?=
 =?utf-8?B?UzBFV2c4YXk2M3FsMTBvMW0rbzR4dlc0Y0srTUV5cDk3eFBPclhHSjJpUk00?=
 =?utf-8?B?cFMxdWZnS2h1NWRGeXp6akpkaGNwTjZjUEc0bnFqR09EcWtoQXk2ZG9uK3Bo?=
 =?utf-8?B?QWFYU1U0OURsVHROaVZLWTVObFpYMFhIMG5KaC92UG93YXNWeWl2dmh3K2I0?=
 =?utf-8?B?dHEwV3JNZTJyMDdqcFlpUHpkZHVlclZOa0pLWXpQblBkcEdsSlQxeDNrelFq?=
 =?utf-8?B?ajk2QXJNaFpSL042RGUyMVo5aFdDa1NleUhodWV2MmtxLytiQllqL0xUbkJp?=
 =?utf-8?B?R002MTBlTGpFMmx2Vnc3WXROMU1uSjM1QnpORjNSaW5mM3JSb2U0NXRFZ0x4?=
 =?utf-8?B?N3lZVCtIeHlYZVVRNmlTajhtbjZlZWptVHpOV3J1UXBhblJpVVhxL2d1MVlB?=
 =?utf-8?B?REh0R3VYTS9XMXAxd2duYmx2U281ZFFudVdsRk9wbHZLV1haNkw2dmh6MzQv?=
 =?utf-8?B?eVRJQmt2UmVHQ2Y4aEtCQVVvWHA4Q24zcG41T21rYUs0UUI0N3JKUzlWWTdo?=
 =?utf-8?B?RWQ0czRsZ2hhQjA3bUJxZDJlcXFaVGZaU3E4aHd4bzJtdzdtcTI2MTQwL1JY?=
 =?utf-8?B?V3I5UGgxRXNaK0lpYU5ZMzNHOVE1UDRtd3Y5elBmK0Vnb3JvY1ZDQTdQdHRa?=
 =?utf-8?B?cTQ4cWVtR1BxMzN3ZlNaUWsyY2dwZUdna0NHbktLN3RmUHlsREdBU2lMN3M5?=
 =?utf-8?B?Z3g2K2VUdTcvVTVuc3NiNldyT2MwNjM4VEFnSVJiaU9uYWVGYTNMZ0RzU3I2?=
 =?utf-8?B?ckVCNGpNdzNGRzVJTnV2ckhQL3gxblFmcVFLcmRVL1ovQ3lnczU3Z0Y5ZTNH?=
 =?utf-8?B?QndiZkoxamdOdlRwQmNQMDZzNThnK0ZLQnVKMEpSRFhHaWxUTll1czA4WmxR?=
 =?utf-8?B?YnBhaUQ3SVZtVXZOaG9xNGJlQy9FZVFXMFRwMHVkRzB5TjU0NS90UWdtd2pO?=
 =?utf-8?B?bENmSnM5KzJsTFFWRllTWEhKTEpUOUxnTm5JdzFuaVN5dWYybHJVbmpmY1NS?=
 =?utf-8?B?bzdra0RlcVNhZVhQVWtZbm5UbUx4VU9sSHo5cHA3NWZVa0o3K3M0QUlpc2gy?=
 =?utf-8?B?dkpwZ3cwbUhHb29zaUN5L0ZvZnlIMXNENk9NNGlubERTNnZCaWkyMTQvMFkr?=
 =?utf-8?B?R1htcjd0aHZEZFc3anNPQkFoY1g2cUZEeUVsdUVONTNVa1NLYmhRbGEwZjlp?=
 =?utf-8?B?NDlqZWhzUkhHelhUUjJzSGNPR05RQXlSSXVLNlhMVGFvaDlFOWUzSXZ0bzBl?=
 =?utf-8?B?MDdnS2VpTHNaYmhYYWdNeUpHTVBvalFncEVSSng0bjMraktyb2kwR0RHQWtI?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1688.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932aec9b-4915-4484-cbf3-08dad7c64b23
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2022 20:13:08.9855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1zU5LaQzAbEdIEFHNuhaqmYasxEA2aeaU/DlAINp6NUhAV0jydPUPSSFIUcoDHNbCSwlppT/NBd7Svt34phQMqIrmWzPtg3EBUlkBPPhgBE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR21MB3400
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU2F0aHlhbmFyYXlhbmFuIEt1cHB1c3dhbXkgPHNhdGh5YW5hcmF5YW5hbi5rdXBwdXN3
YW15QGxpbnV4LmludGVsLmNvbT4NCj4gDQo+IA0KPiANCj4gT24gMTIvMS8yMiA3OjMwIFBNLCBN
aWNoYWVsIEtlbGxleSB3cm90ZToNCj4gPiBGdWxsIEh5cGVyLVYgaW5pdGlhbGl6YXRpb24sIGlu
Y2x1ZGluZyBzdXBwb3J0IGZvciBoeXBlcmNhbGxzLCBpcyBkb25lDQo+ID4gYXMgYW4gYXBpY19w
b3N0X2luaXQgY2FsbGJhY2sgdmlhIGxhdGVfdGltZV9pbml0KCkuICBtZW1fZW5jcnlwdF9pbml0
KCkNCj4gPiBuZWVkcyB0byBtYWtlIGh5cGVyY2FsbHMgd2hlbiBpdCBtYXJrcyBzd2lvdGxiIG1l
bW9yeSBhcyBkZWNyeXB0ZWQuDQo+ID4gQnV0IG1lbV9lbmNyeXB0X2luaXQoKSBpcyBjdXJyZW50
bHkgY2FsbGVkIGEgZmV3IGxpbmVzIGJlZm9yZQ0KPiA+IGxhdGVfdGltZV9pbml0KCksIHNvIHRo
ZSBoeXBlcmNhbGxzIGRvbid0IHdvcmsuDQo+IA0KPiBEaWQgeW91IGNvbnNpZGVyIG1vdmluZyBo
eXBlci12IGh5cGVyY2FsbCBpbml0aWFsaXphdGlvbiBiZWZvcmUNCj4gIG1lbV9lbmNyeXB0X2lu
aXQoKS4gSXMgdGhlcmUgYW55IGRlcGVuZGVuY3kgaXNzdWU/DQoNCkh5cGVyLVYgaW5pdGlhbGl6
YXRpb24gaGFzIGhpc3RvcmljYWxseSBiZWVuIGRvbmUgdXNpbmcgdGhlIGNhbGxiYWNrcw0KdGhh
dCBleGlzdCBpbiB0aGUgeDg2IGluaXRpYWxpemF0aW9uIHBhdGhzLCByYXRoZXIgdGhhbiBhZGRp
bmcgZXhwbGljaXQNCkh5cGVyLVYgaW5pdCBjYWxscy4gIEFzIG5vdGVkIGFib3ZlLCB0aGUgZnVs
bCBIeXBlci1WIGluaXQgaXMgZG9uZSBvbg0KdGhlIGFwaWNfcG9zdF9pbml0IGNhbGxiYWNrIHZp
YSBsYXRlX3RpbWVfaW5pdCgpLiAgQ29uY2VpdmFibHkgd2UgY291bGQNCmFkZCBhbiBleHBsaWNp
dCBjYWxsIHRvIGRvIHRoZSBIeXBlci1WIGluaXQsIGJ1dCBJIHRoaW5rIHRoZXJlJ3Mgc3RpbGwg
YQ0KcHJvYmxlbSBpbiBwdXR0aW5nIHRoYXQgSHlwZXItViBpbml0IHByaW9yIHRvIHRoZSBjdXJy
ZW50IGxvY2F0aW9uIG9mDQptZW1fZW5jcnlwdF9pbml0KCkuICBJJ2QgaGF2ZSB0byBnbyBjaGVj
ayB0aGUgaGlzdG9yeSwgYnV0IEkgdGhpbmsgdGhlDQpIeXBlci1WIGluaXQgbmVlZHMgdG8gaGFw
cGVuIGFmdGVyIHRoZSBBUElDIGlzIGluaXRpYWxpemVkLg0KDQpJdCBzZWVtcyBsaWtlIG1vdmlu
ZyBtZW1fZW5jcnlwdF9pbml0KCkgc2xpZ2h0bHkgbGF0ZXIgaXMgdGhlIGNsZWFuZXINCmxvbmct
dGVybSBzb2x1dGlvbi4gIEFyZSB5b3UgYXdhcmUgb2YgYSBsaWtlbHkgcHJvYmxlbSBhcmlzaW5n
IGluIHRoZQ0KZnV0dXJlIHdpdGggbW92aW5nIG1lbV9lbmNyeXB0X2luaXQoKT8NCg0KTWljaGFl
bA0KDQo+IA0KPiA+DQo+ID4gRml4IHRoaXMgYnkgbW92aW5nIG1lbV9lbmNyeXB0X2luaXQoKSBh
ZnRlciBsYXRlX3RpbWVfaW5pdCgpIGFuZA0KPiA+IHJlbGF0ZWQgY2xvY2sgaW5pdGlhbGl6YXRp
b25zLiBUaGUgaW50ZXJ2ZW5pbmcgaW5pdGlhbGl6YXRpb25zIGRvbid0DQo+ID4gZG8gYW55IEkv
TyB0aGF0IHJlcXVpcmVzIHRoZSBzd2lvdGxiLCBzbyBtb3ZpbmcgbWVtX2VuY3J5cHRfaW5pdCgp
DQo+ID4gc2xpZ2h0bHkgbGF0ZXIgaGFzIG5vIGltcGFjdC4NCj4gPg0K
