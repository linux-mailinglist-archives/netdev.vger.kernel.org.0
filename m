Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B2A47593C
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 14:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhLONBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 08:01:40 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:41877 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhLONBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 08:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639573299; x=1671109299;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6nvDZYSc6Ce1Dme/0Hd0WZcW9tNTEoP4VYJrPQ6kvVE=;
  b=ijFRDuYOs7HmOHJyVIRy3crp5rVFBADIcjRNparQpWeYK+6lz5vq9Y1f
   u/UY2Y/Ahthwl+oCyQzbLLLwdOMA52nV1cnLva0nXjITPx7TWK2ry894+
   3BkxWISOdozxLI6CSv/+poBv7yUPFRuPBh22NE7xh4BQ8nnY/3FjXRuL/
   m6cCH8yotFkLCsGiefOTqwjcLFsrNFT4vlO0JfJ/hKJMp1D3KtmUedFxI
   beTB8yPTNFwWHLlzsCc3phxpqG+BFRpLkn5Dxw+8xfLJT6fHx0TGjhqz6
   Pzk+/awrUKK9RtIbvRF2oFQQPMdprmLYqsp3cd/umMPxzDnnUeN1lP7hl
   g==;
IronPort-SDR: RLVSPrEPWax0PTUPWPxk2HAsLqpEF4v72cV5fvKAqeHpcggYVpbNHlW/xkn52StNP6NRJfF3Xy
 sIv3uTXnM2al4nHpROVS5VVMSbvrcjAm8W0QNflgfMk3vuvd1qG6s/lWx1d87s8u3+/QAsWPRT
 PgA8/3IFX0RLtjOYoPJGpkIm/d9v+fV9+dCBcfpspJq4tx+o69dECE/Jg1Q6WcG/e6twgOU+3t
 Td2ImrWpGfSjdw158TFZ/JH/DawUcZBF8IrxqNEzapknhjPZh51qu3KdUv5jf/xqsTb+wo8boY
 2igdCaa478U59wb395cLBB1y
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="155569903"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Dec 2021 06:01:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Dec 2021 06:01:38 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 15 Dec 2021 06:01:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJlqr8jiNjLpuotU+Jqt8phG5uNnia4koiEFKeYYG2U+h6AEmitY4IIHEO1qzoHbj150E6833GMdJNugCVoRT1xTiQqnytlkMC5L+jozJcowA5yAvRuGT9RtE7+2jq/2Vq4AAUks+v9AB6QQzJ968uqs/0uB2dy0D4tYe0pMUVL0DdoE8BqJaAg5LXhDGb9NgxFiYyShEKMdnJSzlatC8YEgxNAeOJjRfM2wicpAig5q8Phn8XIc63IMtLUFUtu4RfmH7fGserTCGzkW00X5CMNVd5K+oOvZqfXaZLPrBhG4uB23NizghRxSTLK4WIkadWTkSkHf78MBnYV98eBH3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6nvDZYSc6Ce1Dme/0Hd0WZcW9tNTEoP4VYJrPQ6kvVE=;
 b=LGeMF0Z8DayhCcem1PLhjhfpbO/askSkK9z0+ezOjm4GStD8VKdHhV28IXozMMxjERPRzyvSbvQ49q+qEP1rQB5D1BcwxfaucNzrNvPQ5jHBsDDlMylSdkrN10f/JGx9hVIYJ1HZJyQ9yhsTmNFOyM1ft+1FzGv+L1fFjZ5gNSaHA8JsPxUBM7t6/J3VPLj3JfvYg55Srd9cnBzkkZzswBuTWqpVyaC+uqOlSsEK0yOE9LQmEysA6dM6KXF3oz8Ku+MKf8rV72izO5JUD97tQnwAW/j8fY8JX5/s/n9xmowiGXsE1x/l2p9BVmrYwV26MB2wwhpPOEbqYxGndh34Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nvDZYSc6Ce1Dme/0Hd0WZcW9tNTEoP4VYJrPQ6kvVE=;
 b=tGC8wGuEFJleQug3qWQdYU5mL4451cbvG/CxH8jLJYCb/l3fyomVfNdv1cE0tf8ty/j0yZOrmuWxfTPdjMQGwNqKlvI/W2DTCsfLfP9DBoqvwhsWOC0vmLHIS3cl0LvJG82ZHSbwaRweprV7Ul1//LgO7wjng7gFtODANkU4D/o=
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com (2603:10b6:a03:2ad::17)
 by BY5PR11MB3943.namprd11.prod.outlook.com (2603:10b6:a03:185::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Wed, 15 Dec
 2021 13:01:28 +0000
Received: from SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0]) by SJ0PR11MB4943.namprd11.prod.outlook.com
 ([fe80::b481:2fde:536c:20a0%7]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 13:01:28 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <davidm@egauge.net>
CC:     <Claudiu.Beznea@microchip.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
Thread-Topic: [PATCH] wilc1000: Allow setting power_save before driver is
 initialized
Thread-Index: AQHX7vY41SO9kv5AqUyGJ0KZeSsN26wvXkCAgAQrkYA=
Date:   Wed, 15 Dec 2021 13:01:28 +0000
Message-ID: <5378e756-8173-4c63-1f0d-e5836b235a48@microchip.com>
References: <20211212011835.3719001-1-davidm@egauge.net>
 <6fc9f00aa0b0867029fb6406a55c1e72d4c13af6.camel@egauge.net>
In-Reply-To: <6fc9f00aa0b0867029fb6406a55c1e72d4c13af6.camel@egauge.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e6173a2-13d0-45f5-eb03-08d9bfcb01fd
x-ms-traffictypediagnostic: BY5PR11MB3943:EE_
x-microsoft-antispam-prvs: <BY5PR11MB39430502EC324E4DAD050482E3769@BY5PR11MB3943.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3e12hYZkONwsWC5AxQAyzVTthA2V8zYW5+gZSsJ74nJPlL7Mmr6Vus2AwdmcYTdcGVOYd9vBW84c+9bNVbuQ2qbuvoFPGaU/Ik5zlVsUhbq1/MBXYDkI1RaLitbo01DHiH/hCHeGJc83ppE68i7dRJB/zJjwhgPa3p5C0MwQ2k6t6llQ08GStlRe+YWZkdGrnmSSQusQ7BgBJL8BK65mcYg4p1Lh/m3xyr0dDYn28hNPLwmRaw2cV6BUjWNs5+wqCDKoHF61LcmGt2GDpZ3U9vGxaxx2ugNGtCdu+WuINQ9ihOkPsYVHB3+pNYvB4RDzqyAik/DAfDjtrD2B3v0UxmJoRRd7L+V+F+gy5cNPciXAmvDss5dCHRfZXtI84NQ/kCYzIVq+p+FmEm+kmQ1HfbTgVFeqIsXukPhdDLNklW/X1WjoiPpcQsgbcJrCCGUc0k+X+h5eUQBzklGNCF+fmadxBDiMtRC+g0AMhZt8oTxWGg6YNHGMQ2W+IaiHd6/hcSRCCJqnbBqTZ8GY32zcnZI6dDQOfbP4K3BEs4kZAJo5/AfWia1qT4fn8iHQl2bmMlOliuOcw0rgyUhj4SSchZjHVDfUfU84nFqs4Sw6h+/Q9Xf9Z9KLMI5bWn4GuInitFaNbUTkczay31l7FpgDbFkxwRNvuqAlOFxL/lvlpM11LjTDdw9kGo1cHNWz5rIwheFF36jaOrbC6vW35zaXTXz0bnUFu8lpdj7LgJ8ZBBF6xUSp827R1O+m27q27BWu8XhDIAem91ERJt7Kj3XdaQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4943.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(54906003)(122000001)(71200400001)(316002)(91956017)(66446008)(6506007)(64756008)(2906002)(8936002)(66476007)(26005)(8676002)(66946007)(186003)(66556008)(38070700005)(6486002)(53546011)(55236004)(31696002)(6916009)(36756003)(86362001)(31686004)(83380400001)(5660300002)(508600001)(76116006)(6512007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHVUNnJrcURHNThmSnpoaEd2N25VYjE0NC9PSWFRM1Z4US81ZXFzYmx6ZldM?=
 =?utf-8?B?Z1dCVGRCNlllSFRibk1xZnM3bTJlQk51Ymd3V1M0dlo3Mi8zNFFlVkdObXJh?=
 =?utf-8?B?akNmWGI3TkIrRC9KOU55ZEFRaC8rMFk5NWZTUHpWa29ETEFOeHduWUhKa2tm?=
 =?utf-8?B?WmZFTUJ6bWRPUTB6TnFkcDczazFUSXNOdWlweFRyODJuRk9Qd1MvdFVBV2F5?=
 =?utf-8?B?YnRGSC9aQm1UOU9yU0Y3VW9XQzVMRFA2NzAwTGZpQURSM0xVV1dVeGVnOW5E?=
 =?utf-8?B?OEtDOUR3T2U2LzZkN29IOStLRC96RW93Qlo3RXM0OXVJVEpGSnBjMnZvRkZv?=
 =?utf-8?B?OHpSWU9HMlE2QWVsbUdCSC82VVJ4N3NnRVlLbzNRS2pTT1dVVUw1Z2cxeHgx?=
 =?utf-8?B?YkZDNWpSRkV4eS83NHUwWXU1TXc5WjVZS25tMmdSRmhuWU9qN0xhTnovbSti?=
 =?utf-8?B?aEpGNGdpdmNSMUpoK3k4eEx6aDNXS1pheDJseEdmNkttL3dXN3BvOG1ndFRs?=
 =?utf-8?B?NFQvMjhqTUwwMmduUGQ1SkVQeFhYZVZuUUNFL08zZTZ2aFZ2REw3ZUJaWFk0?=
 =?utf-8?B?ZXUwQk5VNE9WWmM2TE5kVzN5QXMzTHdmb0d4SWtXK1RjQTRGSHREUGI1emZz?=
 =?utf-8?B?MjZBZkZIMDREK0tXdjFBdXRlUktzekY2K2RwcWdHaUNQOWQ4dGtTR1NndnZr?=
 =?utf-8?B?blc1cjJWeDVMdW5wUzBkdnhCUkM5SkhkZ2hnUTlvQlg4NzA5SWdVNVQwNGJO?=
 =?utf-8?B?dktKZ0o0eENiVkJzcVhkbGxnMVgrMHp6eFczQm8zTkMveVdqbkRqeWhObXFx?=
 =?utf-8?B?emQ1MmZsM0NaZnhSaTFWM0c3UjhkdEZ2cStQUVVzQ3VSeTFGQ3plMzNYZ0k2?=
 =?utf-8?B?eE9rcGVGWTBCRVRBNWo0ZTZKWVZtMkNwV212dFBOMGQ1TTRzYk1mb204S1RO?=
 =?utf-8?B?UFhDZWJhRVcrR2xoTUlkbFlOL1liNXptZVMrdkpPSUlMZVFDUmZYQUYvK3RJ?=
 =?utf-8?B?cS8xY1FUc2hLR3ZqL1p6eWNBMmhPSUlrZTRTWmxNZVRCREd0MXZUa3pHMGlQ?=
 =?utf-8?B?RVJDcmxHWnpSUlB3VTJTRTd6NjBIdjdqV09BZ21nUkVnOFlNNWVhT3ZWUE9S?=
 =?utf-8?B?VHhwQ2JaNUNDRThJS28zdTVpTjlSRmhwZW5oSkZkWnVSR3RIemZXSkdZT1Rh?=
 =?utf-8?B?ZzdtMU85dkpGM0RvdU9reHR0T3hwbS82U2hkRFVBbXZ6RVQ0UWRyUDBLQ0J5?=
 =?utf-8?B?TVpTRTBNVDZkbkJVd1E3L2Z1YzkyaE9JSmhPUTNmVXpxUjBwNXdTMldoTUk3?=
 =?utf-8?B?VjFLUm5WVVJTRFhCaUZraDZwd3dFK0pzVWJjMGt3YlAyWTVwdmFydnhudDIz?=
 =?utf-8?B?cG5PZW5pSnBnOGd5Qk9DSWV3MHBBOU56akcxRFMxVVFzR2t0ZFZpbUV1dmY0?=
 =?utf-8?B?UkJMdlQyeVBMUnMzaSt1VTUzM1JhV2FEYmZraFZYMzBZZjczbm9ZUnVNajIx?=
 =?utf-8?B?YkNnZFpPSURKYkkzQVV4TlBwcmEzeG4yZWtzeWFSNWQwTENUejVKUmVsSmZy?=
 =?utf-8?B?WTBMRTV3MGd5ck9PLyswMUtlSWdVOSs0by9uVnllaFlJL3B4NEF3anFrUmk2?=
 =?utf-8?B?Q1pmV2U2MFJubFF1SWlMUDVFb1Zsc2VwM253eWR6SnAvVUJaeTRWVzRFalNM?=
 =?utf-8?B?N0J4eGgwMUp4V2JrUU1FMXdnMGdkRDZKaDh0R0Y0bzRYOVlxTk1jZlRJK3M3?=
 =?utf-8?B?UkkydmJ3TFpzSWhmUEk0bWtoVWJjczJxU0lvd0RaVlkrU3dKcisvRnJscFJp?=
 =?utf-8?B?TDZ5dWozdGVmQTBtR21KcnU0cDJ4TDZHWXJPMEJlUiswcW5nOUxLbHdoTFYr?=
 =?utf-8?B?bVovL0ZpVWp4QS8xUm8ydk01RzdKcUNpaUxFbG83QlZ0OEUwVFZCYldFbkVG?=
 =?utf-8?B?S0ZVNUM0TzRFcEswakp6MTlnbUtBNW1PdVNvRk5na0RvNlFtYy9NN0ZTUENI?=
 =?utf-8?B?b3NNOExwZ3ZmZEx0OUY0QklyQWRNTmZZK0poanlxZ21uWFdyWTN4U25md2t4?=
 =?utf-8?B?Mkc1cVhZTFFvNE5vd3VCRGRCdU5FZk4zbU43L0VHeWhZaXlKdWtiRzBNMjcx?=
 =?utf-8?B?VkpQZkdJUnV3UExSNGFHYUtQd2ttWURrNHBNQVYzRmRma1BzRzl3UVloVEh1?=
 =?utf-8?B?SW1tYXkrbTVUSS9aTWFWbmZXYUdzVytpaVlnTHFBbEpNMUhhcmszdGZsTnRm?=
 =?utf-8?B?d1pHU1VrZTczQ1REOGsvNjAxWUVBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E25F448B28B66E469C8E189191FBF5E5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4943.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e6173a2-13d0-45f5-eb03-08d9bfcb01fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 13:01:28.1882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MKOKqDLRDtkA6oAZA0QY4hETr6V6dxLwGRzIZRreMnsAbQivxCuAwL54SOD8XAdyhPE63pO4Tx8R+otIJnN+2MfeDarJlGEgYTXVGuU2yPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB3943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTMvMTIvMjEgMDI6NTAsIERhdmlkIE1vc2Jlcmdlci1UYW5nIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4NCj4gVW5mb3J0dW5hdGVseSwgdGhpcyBwYXRj
aCBkb2Vzbid0IHNlZW0gdG8gYmUgc3VmZmljaWVudC4gIEZyb20gd2hhdCBJDQo+IGNhbiB0ZWxs
LCBpZiBwb3dlci1zYXZlIG1vZGUgaXMgdHVybmVkIG9uIGJlZm9yZSBhIHN0YXRpb24gaXMNCj4g
YXNzb2NpYXRlZCB3aXRoIGFuIGFjY2Vzcy1wb2ludCwgdGhlcmUgaXMgbm8gYWN0dWFsIHBvd2Vy
IHNhdmluZ3MuICBJZg0KPiBJIGlzc3VlIHRoZSBjb21tYW5kIGFmdGVyIHRoZSBzdGF0aW9uIGlz
IGFzc29jaWF0ZWQsIGl0IHdvcmtzIHBlcmZlY3RseQ0KPiBmaW5lLg0KPg0KPiBBamF5LCBkb2Vz
IHRoaXMgbWFrZSBzZW5zZSB0byB5b3U/DQoNCg0KSSB0aGluayB0aGUgcGF0Y2ggaGFzIG5vIGVm
ZmVjdCBiZWNhdXNlIHdpbGNfaW5pdF9md19jb25maWcoKSBnZXRzIA0KY2FsbGVkIGJlZm9yZSB3
aWxjX3NldF9wb3dlcl9tZ210KCkuDQoNCkFsc28sIHlvdSBoYWQgbWVudGlvbmVkIHRoYXQgdG8g
ZW5hYmxlIHRoZSBQU00ocG93ZXItc2F2ZSBtb2RlKSwgdGhlIA0KdG9nZ2xpbmcgb2YgUFMgbW9k
ZSBpcyByZXF1aXJlZCB0aGF0IG1lYW5zIHRoZSBwcmV2aW91cyBzZXRfcG93ZXJfbWdtdCgpIA0K
d2FzIHN1Y2Nlc3NmdWwuIEkgYmVsaWV2ZSAiLnNldF9wb3dlcl9tZ210IiBjZmc4MDIxMV9vcHMg
ZG9lc24ndCBnZXQgDQpjYWxsZWQgd2hlbiB0aGVyZSBpcyBubyBjaGFuZ2UgZnJvbSB0aGUgcHJl
dmlvdXMgc3RhdGUuDQoNClBvd2VyLXNhdmUgbW9kZSBpcyBhbGxvd2VkIHRvIGJlIGVuYWJsZWQg
aXJyZXNwZWN0aXZlIG9mIHN0YXRpb24gDQphc3NvY2lhdGlvbiBzdGF0ZS4gQmVmb3JlIGFzc29j
aWF0aW9uLCB0aGUgcG93ZXIgY29uc3VtcHRpb24gc2hvdWxkIGJlIA0KbGVzcyB3aXRoIFBTTSBl
bmFibGVkIGNvbXBhcmVkIHRvIFBTTSBkaXNhYmxlZC4gVGhlIFdMQU4gYXV0b21hdGljIHBvd2Vy
IA0Kc2F2ZSBkZWxpdmVyeSBnZXRzIGVuYWJsZWQgYWZ0ZXIgdGhlIGFzc29jaWF0aW9uIHdpdGgg
QVAuDQoNClRvIGNoZWNrIHRoZSBwb3dlciBtZWFzdXJlbWVudCBiZWZvcmUgYXNzb2NpYXRpb24s
wqAgdGVzdCB3aXRob3V0IA0Kd3BhX3N1cHBsaWNhbnQuDQoNCg0KU3RlcHM6DQotIGxvYWQgdGhl
IG1vZHVsZQ0KLSBpZmNvbmZpZyB3bGFuMCB1cA0KLSBpdyBkZXYgd2xhbjAgc2V0IHBvd2VyX3Nh
dmUgb2ZmIChjaGVjayB0aGUgcHdyIG1lYXN1cmVtZW50IGFmdGVyIFBTIA0KbW9kZSBkaXNhYmxl
ZCkNCi0gaXcgZGV2IHdsYW4wIHNldCBwb3dlcl9zYXZlIG9uIChjaGVjayB0aGUgcHdyIG1lYXN1
cmVtZW50IGFmdGVyIFBTIA0KbW9kZSBlbmFibGUpDQoNCg0KUmVnYXJkcywNCkFqYXkNCg0K
