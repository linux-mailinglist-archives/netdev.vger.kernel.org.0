Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE02356BA59
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 15:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237721AbiGHNKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 09:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiGHNKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 09:10:42 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E766626136
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 06:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H52+3wfae3D7lIKkcpbVksbKwiwBixcdJetl/O+aINVs9KIWWalTTZub+kw3yKetu/7KLZFsFETMPTsnaoNpkm5y7/61OzI9Pye8FtBykneZgwfFG1fNhVrgSf+7x6BTQIp/wuVgeVRm4JwhkWnTzwqtBWR2PXS1XZi3X/pw+Iv78plu65W7ba5tlmr0H2el8M1HeSwi9ISuWxCQgM7ngjZO9yTRLrI/pkg51Zt1NEiyb740nAPLqsNmxnyDPYg4lCiIz8pSbt9R078ZI8wDshrACvJt7LYW7NaEXTISg3pWHl4fvvv4aXiPi8FcZI9UZXDUtBALJnp1IIKQmGk+gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ew+4zNdBFD8ChJpa+xhhFWAE43Lt3TgvtTU+4y2P5AM=;
 b=Wou1tpH/0AifdF5G7hysy16fxGyFM8S0xyqviNt3RmvixJOEiVwJvuz6FV9mh+FxZLfliHisslklivqSNlRTbIdYMDor+Z3w6Q//nbyoNYmlDbMCxMZvhXUzFyifAjjyEMNM21jtD5IHi0KR+k/6KWTTf54I4HKCOva006o6YbY7fmufK34uvvbKuY1FLjxewl+Zf4Kf/l07VSmPHbWeuSOFtgB3zEtHvaMqWRaHNj7D7IodC6Hp6G2fNdkTauUb5eHiR47td2xgCDXzg3YESfbPywRh07ZVIK8EwId22yP937m/MI1CwNTpysfFcmcWmy60hhLEIYXHHjRswvzCBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ew+4zNdBFD8ChJpa+xhhFWAE43Lt3TgvtTU+4y2P5AM=;
 b=CGxGBg4afX2N0Vpi139px9cL5+DayKJZiFsOgS9BTZz3QyUk3sE0SUU+vNN2xe20FBQcHFegp8q40slOki0ZRG1BLnVkOhqW2pxx6urvo/oZoqaVkRzlQgjn3iPLOmA12/pNwVxid5wlHORWUvhkwy7JGrAEa6JukEKw+Ffe5WAJTzvywNT4G0yWJqJSM6gQYesPqLCEk/CqGuaPLKEqS9jlnXtuLMH5s+2lKzE2mi3vDe8JlaK7xkPkSMQUEudq9cJQxSg3z4m2rXZ/b3KoU02uSPGMdH/Zuyt8SqYxJdsPVei19GXnEpSCMs26jf2rfvNhppqMt/zZRRlR5QaVOA==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN8PR12MB3202.namprd12.prod.outlook.com (2603:10b6:408:9c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Fri, 8 Jul
 2022 13:10:38 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548%7]) with mapi id 15.20.5417.016; Fri, 8 Jul 2022
 13:10:38 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "ttoukan.linux@gmail.com" <ttoukan.linux@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 11/15] net/tls: Multi-threaded calls to TX tls_dev_del
Thread-Topic: [net-next 11/15] net/tls: Multi-threaded calls to TX tls_dev_del
Thread-Index: AQHYkY+OH6POFNkN9EKvbaYPUEpzGa1yMeiAgAFI1gCAACJXAIAA2ASA
Date:   Fri, 8 Jul 2022 13:10:38 +0000
Message-ID: <6a19625bed077cb063aef035ec846e2f6c0d7464.camel@nvidia.com>
References: <20220706232421.41269-1-saeed@kernel.org>
         <20220706232421.41269-12-saeed@kernel.org>
         <20220706193735.49d5f081@kernel.org>
         <953f4a8c-1b17-cf22-9cbf-151ba4d39656@gmail.com>
         <20220707171726.5759eb5c@kernel.org>
In-Reply-To: <20220707171726.5759eb5c@kernel.org>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32c28b2e-6a6f-49a2-6606-08da60e34097
x-ms-traffictypediagnostic: BN8PR12MB3202:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6NbsG3oav46vqPY3r6borMqe4oUcdlLgzPdyPmLyxEguBuJlo1XptRZBbgZbTLpjXr5WN/PVu/xumC5pnwQdUpwDpetM+FRjVF5mn9C11Yw5YW2/gOocJsiw6yvP94iK8nJv55f0VGTPI/BvwFh1XUr665C/RufSL2OwQJpEnSwBAjyVL1F0rirK/EWuNORNoHBTsDj/CCYXboPbqnDwa6hh/DiW112Wdj9H3ObmXu+XDuwYQfC+7S8+1R0sgjC7iiZi7ySApvn5b3K0AaLDxWJENVMqZx+mfdoSuC6WEn5OcRq+Jz2Mbr2k154g5dXQC3O768/zizT/vqPMItFGbb1eL/pItlDbix4KfjESgUL50gzd49vb6zRzZQbBnX3xbtKi4SLUllZmbslaym8VwSQ7CIT57Q6xpWbuCOGCaPVqnRwgvtmGGCnwPqQktuA9kwtzx9ioV7rmRHQM28e+3pEAICV42EF0XX8J33ic1xJxLPykty4NPgbG1xTyL3Dkcx5tYVpNThh0GXQd+CsX26Qxzk8W672uggjaTsx02EA0euY2LSf+ZBGYQ3xfKOFF5+C2OZ1OP4K+syDBDDhzpP9L7jywf0MkDH2gery5dDT2P2hlE3aeaJ9JJhdOOsfKvtePmaVOAXF/EWIFRRKT2OOPirnvC3uSFQ5LrQmXDJfLjcZR4WnT1+k2612M7dEPOF+IKNrEn7OG/f4b5Uc/Q8NlpELoKR2Knr3ZHm+DAdMFgGLDx7pLj1ZkyMJJ8aqCJ/dgyvUO5WhqOgz3SpvJFOwNSY0XDV7Rxs3pY77noEd/j25S7+fQMCk17uHUWxGX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(39860400002)(396003)(136003)(376002)(41300700001)(6506007)(86362001)(186003)(36756003)(83380400001)(4744005)(66446008)(6512007)(2616005)(6486002)(8936002)(8676002)(110136005)(316002)(5660300002)(54906003)(76116006)(4326008)(66946007)(122000001)(66556008)(478600001)(66476007)(38070700005)(38100700002)(2906002)(91956017)(64756008)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFFTUU5OU2hpWnBuaW9teWNkQnFIRDVvQ3FuMVdIZ3JpdXJEZ3FlNzA4ZnE1?=
 =?utf-8?B?RUUvY1UxWUFxdGNHYkxWT2tsUnV1enA4RVFQdTVQRkFpUTVGeUM3WEorclRZ?=
 =?utf-8?B?OEtyZ1FaVHBsOFBTUXlKZ2xYdkpPcFlSWlh0RS81WUJKTGR1L28rQytuYzR5?=
 =?utf-8?B?ZUVxRDZta21aMU8zYkVLY2JkYUF2Z0twTTBodHZXYjlscTREcFJXWkVjZDBo?=
 =?utf-8?B?TEtCeVJNRlVoU0VnZWM0S3psZExudnNyWjc0RkpZVlhiazM3R3VWa0xlc0RW?=
 =?utf-8?B?TGJWL1Y3NWEyMzZzQVZsT1RKMHRNaFkyV1FieXl6RGdCNVJnRzkzdGZud0ww?=
 =?utf-8?B?dWE5RlZMRjhOb2NrRStzNEJ6TGhuRDVudTkyMFZCVWNRSUEwdFZUSGh0dWxl?=
 =?utf-8?B?Qzd3bUdTSHQ0bDRSdmhHWkNMMWl5blIvLzJ1aERlLzRLYmZUNXdXRkR6YlY2?=
 =?utf-8?B?b3MxeGdlcXlPWS8vcVlCRlAxTzRKZ2diRTNESGdyTXR6TkJwSVBtOFVGaE14?=
 =?utf-8?B?RVlLVW9yd0ZqRW9NNlhGZGNwZWlsb05zenhpWUxFTVRFTERtZk52cmI5YURa?=
 =?utf-8?B?c1BJTXFxbFYwTXFEQXB2NmJ1b2NCbDNieWZjQXkxcGhveFNlaXFHbU0yWVAz?=
 =?utf-8?B?OGsxYWRUT0c4NVQxcWhtcDljSldsQXB4SmR1M20xN1V4MTVjbWlrMzlaUTZY?=
 =?utf-8?B?Q0pBWTlzVXA0SmhuaHkwQXNSd0lCQUdDYUYrUlcrNldSeHdQSVk5RW9IZmx2?=
 =?utf-8?B?VzF5MDFhUWVEV0VNbkJ2ekE0b3ViVk5LaU16a0ZvYSs4eXdOT1pyWE9zS3o2?=
 =?utf-8?B?Rk5rUHRMTklrcmxrbmljNlk2U2dKRGFYamJVTlh6c3B6WDZnQ2JoMU40aHpK?=
 =?utf-8?B?TVcvTCtQdXE5QVVhcGgyenJuLzdENHRJV1M2bExTWEUzM0s3eGRUVkovM2Ra?=
 =?utf-8?B?UlRHOXI0OG94cU1YaktGSHFOMnJaMGo4NXpRWXMrMkRCYitCTmEyOVB6ODRL?=
 =?utf-8?B?VTk3SWgyVElUNjVVWXRjOUgxd3Q5RTFveStFSmVSUjVXbjhOaHcxdEU1Skdu?=
 =?utf-8?B?eHMrVmF6R0Q3VVYrNmlJQUJ6Y1dTekVUZklQK0VHSVdUdXorY2VGQWl3S3hw?=
 =?utf-8?B?QXpqbFlCc2RVdEhDVCtWTkhyQlo2a3owTEZPSGpnVFpKVFhvNHNXcVg4a250?=
 =?utf-8?B?RnN5SXhiZlZmaHJJYUw0Y3IvSnM2dnQ1Q1hmaWFhZzJ4RmNSWGxDaXRxNmVY?=
 =?utf-8?B?RHdjbnNoeEh0Tnp3NW1VWUVZclVXWUQ5UCtjd01GNFlLZ0pteEFlR1RjN1R1?=
 =?utf-8?B?K2x4M1BtZExyS3Z5cTRuSjBhbmthSFdtMjdEYkJWb1VKa1IzZEsyRG5UNnpz?=
 =?utf-8?B?dlUycG1FUjRnV09CekhpUDYrR3N4OTZKeTYxbEY4SU9OblpCME5xbWRob1pE?=
 =?utf-8?B?c2xFaGFIekxISEkxZThTUjd5SFJ1bFdFZ2puNCtwSldWYUdKQjAyWFplcnBv?=
 =?utf-8?B?eVRiVVczNjc0aTJZY1hIckY0aXFFK0FLNS9RbzJnQ2Z5SDhsYTVZU1RVWW80?=
 =?utf-8?B?T0NuQjhHdDltMUJ5MFBwc3EwMFFXckZVVEJvZi9jVS9QTzBOU0txYXAwd3kz?=
 =?utf-8?B?R3pHVDFTYUo2RHB6TEVidStYMmMyODV5ZENCUFhPQVp3dFNrUnRxeDZzME9G?=
 =?utf-8?B?RzBiRXdkenk5QmJkaUphZGtqUHpvVFBzUjNLcVFDZ0NjMzR2TDA5aFVmZHdt?=
 =?utf-8?B?YjVpRStscjVFZk1kSDBSV2pDaEkxTE80a2tZVU1jMzZWcUJseUorTWh2R2Yv?=
 =?utf-8?B?d2ZydTBsOHdLeXF3TFQ4QnBDanN6Qm4wYlRGYm9vOWptSTlFWGN3TWhja0w5?=
 =?utf-8?B?ZWlFSGpzMCtKV2dnZFFCUVJHTXZOZC9lS1pUUnUxTjNZUDZQcEkzcHhTYTNV?=
 =?utf-8?B?QllVUEZXWXJXQWU5UmNCM3h6UVZ4YjhjUCtjTmVvN0NSNC9XWXp5Zk5sTTUy?=
 =?utf-8?B?MjFaZHhIUEI0Zkp6M21hWTZEOTE1T0k5UHFaWURoZXg0K2dnRjN2R1lZMXAy?=
 =?utf-8?B?N2pDakFzR2M2MXd1RWVUcTAyaGdYLzVVODFwSmJ4eFRSOWNOSE0xSUZBNjNP?=
 =?utf-8?B?Y1BYUlpYcUNvVHJtN0EzWjBjOHBOK0NGRDl4ZUFaMDM3WFRFU25NUmhicXFu?=
 =?utf-8?B?ai91OHlpUU9wN0oyQ1hpMXplNFVBR2xhNGdCME8zN0o3anJDcEl6cElqOWhH?=
 =?utf-8?B?a3ltdlNFMFJsaGZ5NjFnR1RhQTBRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7CA355DFACD1F04687CC3759131BC99C@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c28b2e-6a6f-49a2-6606-08da60e34097
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2022 13:10:38.3228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1bo/QcQ7aq4/gIqdbMf7/CamgenC14V5Dwyqy6eewuFawRX9KCGSaTbASrNm5aKc1282omQgd2KP6W3Dhq4Zug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3202
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA3LTA3IGF0IDE3OjE3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCA4IEp1bCAyMDIyIDAxOjE0OjMyICswMzAwIFRhcmlxIFRvdWthbiB3cm90ZToN
Cj4gPiA+IFdoeSBkb24ndCB3ZSBuZWVkIHRoZSBmbHVzaCBhbnkgbW9yZT8gVGhlIG1vZHVsZSBy
ZWZlcmVuY2UgaXMgZ29uZSBhcw0KPiA+ID4gc29vbiBhcyBkZXN0cnVjdG9yIHJ1bnMgKGkuZS4g
b24gVUxQIGNsZWFudXApLCB0aGUgd29yayBjYW4gc3RpbGwgYmUNCj4gPiA+IHBlbmRpbmcsIG5v
PyAgDQoNCklzIHRoaXMgYW4gaXNzdWU/IFRoZSB3b3JrIGRvZXNuJ3Qgc2VlbSB0byBhY2Nlc3Mg
YW55IG1vZHVsZS1sZXZlbA0Kb2JqZWN0cyBsaWtlIHRsc19kZXZpY2VfZ2NfbGlzdCBhbnltb3Jl
LiBEaWQgSSBtaXNzIGFueXRoaW5nPw0KDQo+ID4gDQo+ID4gU28gdGhpcyBnYXJiYWdlIGNvbGxl
Y3RvciB3b3JrIGRvZXMgbm90IGV4aXN0IGFueW1vcmUuIFJlcGxhY2VkIGJ5IA0KPiA+IHBlci1j
b250ZXh0IHdvcmtzLCB3aXRoIG5vIGFjY2Vzc2liaWxpdHkgdG8gdGhlbSBmcm9tIHRoaXMgZnVu
Y3Rpb24uDQo+ID4gSXQgc2VlbXMgdGhhdCB3ZSBuZWVkIHRvIGd1YXJhbnRlZSBjb21wbGV0aW9u
IG9mIHRoZXNlIHdvcmtzLiBNYXliZSBieSANCj4gPiBxdWV1aW5nIHRoZW0gdG8gYSBuZXcgZGVk
aWNhdGVkIHF1ZXVlLCBmbHVzaGluZyBpdCBoZXJlLg0KPiANCj4gWXVwLCBTRy4NCg0K
