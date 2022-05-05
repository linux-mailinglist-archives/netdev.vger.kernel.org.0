Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060DA51BFA6
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377616AbiEEMoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377961AbiEEMoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:44:18 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2052.outbound.protection.outlook.com [40.107.20.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA782193FB;
        Thu,  5 May 2022 05:40:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJlwXWWN/rRJrF+/pghfMHs6WahJmXZb1Th+EDxIoYGD8r5QOpHmZDbcD2CWQjscv8O5Lk/YN1OMN5andsphA2P7+C8w7fr+mG2aKGfMHhGdYrL/MuLaPjDPvu6VeQJCCSCqAup9AzMw06lEDNWaJqBaPvyy30V/yy3PrXRPmx+3bPuyp14kk1WdhQ4CKauobvDMuOF0Lc5u0jMjmFVx78TPbPxIYBVG5Usa8rJ6tTc5ZVLwY5CUbqAzWdSEX3uyYsALFzBQt3voNcFm0y+nifHJ7XC/OAAdLZNC8tnDVIlw1MM21p+7zfEpJPAlEQ7GplXwy+seh8b7zhW0vJUcpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngw3NGbNeU2YhVFdm0+FyBd1E57Iw6AHC4JOBszABKE=;
 b=hv8PtPVwPQaPWV61AedhOZBcsEvtI5wa4q3s0BQ93ST6dGk44/SdKdVyjs987xNvXzrKAcMGFYzsQo7hKwHXC3eJVPthpivY3qAWugVH4ib3RmOYCUorgAd4ZIgPe5LuCpdl0Vc6YrDGVGB+iKr35Lw92VN/4/Ket8T8LMGEnnq5mzO7ABMleDpoGQ39JO5hbwB6IesEHvNTRV7XI81fpu2Q6hpSq+ywYG26XXaOcJi4g/Wsq+UiAlR/P7CmkQ0mavKBr8iWOsUCSGnj9ikFqEH/W1BGWHDf3ixpzjQC14drobn8vEUAj7u08PnPZyx1rV15X1zixY/QjcfD+HtnQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=variscite.com; dmarc=pass action=none
 header.from=variscite.com; dkim=pass header.d=variscite.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=variscite.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngw3NGbNeU2YhVFdm0+FyBd1E57Iw6AHC4JOBszABKE=;
 b=td3HNakzGp5MUaPAQ/lFb9qWYjSVEuyB7Q8msmwZCYy7U527UnRfmJ4J/PN5D1rwpS+Ctwv4hjyVIKt81XqnI2dKV07JBCjELxKOXfNMyqOZcoIyMq6y9AAy1HqIfEzo21HLgU03kcOJ/5ifT2rehTh4e+5t/BGobY4USTU9+MJeD/q0K/MD/V+kNk98UF204kYEn9FKsgLUajxtWOpUKMTvveECS53Gds7/nuElWHk+x1XauyXKmUuNSNp6XdGBPKS1lzreBGYooFPERpWBucW/83MYINKzDYjZuB1fN0tV0IqD9VBse5xqo/lLQO1bGWu/Ig3ih1tnA4GJVaPlTg==
Received: from AM8PR08MB5746.eurprd08.prod.outlook.com (2603:10a6:20b:1d8::20)
 by DB7PR08MB3820.eurprd08.prod.outlook.com (2603:10a6:10:7f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Thu, 5 May
 2022 12:40:31 +0000
Received: from AM8PR08MB5746.eurprd08.prod.outlook.com
 ([fe80::9dfd:cf1c:a154:9a09]) by AM8PR08MB5746.eurprd08.prod.outlook.com
 ([fe80::9dfd:cf1c:a154:9a09%9]) with mapi id 15.20.5206.013; Thu, 5 May 2022
 12:40:31 +0000
From:   Nate Drude <Nate.D@variscite.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "josua@solid-run.com" <josua@solid-run.com>,
        Eran Matityahu <eran.m@variscite.com>,
        "michael.hennerich@analog.com" <michael.hennerich@analog.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH 1/2] dt-bindings: net: adin: document adi,clk_rcvr_125_en
 property
Thread-Topic: [PATCH 1/2] dt-bindings: net: adin: document adi,clk_rcvr_125_en
 property
Thread-Index: AQHYW/lBEC5y4bS5mEezwW7NaJBvmK0LTw+AgAHBDQCAAzKNAA==
Date:   Thu, 5 May 2022 12:40:31 +0000
Message-ID: <88b343998e6cabeef71fee272cf3f8029a59d5f3.camel@variscite.com>
References: <20220429184432.962738-1-nate.d@variscite.com>
         <a11501d365b3ee401116e0f77c16f6c2f63ef69b.camel@redhat.com>
         <5d3bccb5-2b0e-9054-3302-d6962da0fee4@linaro.org>
In-Reply-To: <5d3bccb5-2b0e-9054-3302-d6962da0fee4@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=variscite.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98e6e7fb-3c57-4b20-15be-08da2e947163
x-ms-traffictypediagnostic: DB7PR08MB3820:EE_
x-microsoft-antispam-prvs: <DB7PR08MB382037E12292408B4C0C147F85C29@DB7PR08MB3820.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XcIN686fV5vbkNl9CyGxafMS/JuejR1a2db6O2KhFJbew3y3vefT9sJOXCoIWgdHJuE7YrCztre9KODY02JqMvkr5IGISFwxyc5YdhEbjrgEOboQAlZd5XKSVyDPlD6J5y1Bo5l/LPzChrcGEwqp8OMPPU2Agk5hRTGTQxN/P3HNp06z6REinBQ30u+Ol3uweM2uzJyl+Dui6WPRYvB1HHeaG5rV4tHP1Bd/AoRAF9fMlw+GzUeg1UJOdH5QjQjARcb1a05IWDNwqkjbJ0n08LWF+j0YoH6DiaRtLpgoSZTu0voGYB4riCv64YWbdMIVfusIA175g3E2vk0x46NkdZ223sjQD0u1JuamC/t343fDad2dpOO7lYYYJukzRkV+FKEcbVvqVZp0k7bOWBUw2Xq5YfW01S1/SpLlgfDuK001vOssKrj0U0xUR/ji0iLa65gQXIlRerq6Lmp4ecwhTHvDDwU9an0bFskAAe23C+qa4C7WvGyd0eccqMpa7OvGk4pZxSJ8Hj7QEMdCthg43JDt+IQZGSztGSp3nge0D+4ZzF4eCUKIdivtyUO58Zs+Daj3ZreKYdKNRoZhHm57yYpFrIQk1iyhXow1ulk3fPpU00xGRJV/owarae/mR/T8i+aptU+wzajwsBEUXE2Llg64H606d3VY4hNq9V3OlHXSh6inoAqmnFVQq6+I+m0VoSVuF6CHEDnrLoNsjmQYP9gCotFd/8k5x/RTZRWaMBHwFr+AAX/bKBuRcJKh6ZZFV1aaPAYzfyXdGhqz9/WAnSYGspbSHB3bVCQQQ4q+S7s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5746.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(396003)(376002)(39830400003)(366004)(136003)(346002)(54906003)(86362001)(6512007)(110136005)(26005)(122000001)(76116006)(91956017)(66946007)(66446008)(64756008)(66476007)(66556008)(316002)(36756003)(2616005)(4326008)(966005)(186003)(6486002)(83380400001)(71200400001)(6506007)(8676002)(2906002)(5660300002)(7416002)(38070700005)(38100700002)(508600001)(8936002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MU5MemMrRGFtQS9UWGlvL3FsbG1PV0hZMjJRYVBmNng3azhxUE1xd1FGZk5C?=
 =?utf-8?B?QmRWbjVabXI4WnBQaUFnTkYzbys0SWNMbnkzSEhnbVZobGcvaGJyOGZjTjRa?=
 =?utf-8?B?b0gvd2hNbit1WXBTRVhuVG9XZWhSOVJCbHd6aDJjOElhNThnRDlwVjhuczJJ?=
 =?utf-8?B?QlFqY2IwQzRUMkpRbm5HaTAyT2p4VE1wYnhmcGRaNTltY2RCS3h1U21oZ1RW?=
 =?utf-8?B?Unk4UEtIT1FYL1VkaDgvQThIY3QyQ0VMeFNsQWt0aUJBWm1mVTJUSUJUWVNt?=
 =?utf-8?B?cU5QU3hBbjl6YWI5NGFubEp1MDAxVlhmN2V0UmZRb0RYWXVRSktOdUdRZkl0?=
 =?utf-8?B?bENSV1BLeEowd0NhNHdBSXNsQjBNeng4d2J3bGx5V2NUR1QvZVFaM2E1V2c3?=
 =?utf-8?B?QXVMYXF5aWdYZjBUd09SQ1NxSGVmaVM0UmhTZjZwZmV5K1BWYVpnaGl4dTRG?=
 =?utf-8?B?bTFOamhWT0wzNG5weENXTzl4V3N4MjhUTFN0Rmh1d1BpYy85OGROUlF2YmFL?=
 =?utf-8?B?WUdDai9ZdVJqeGxkemVjNkpXSUZKbm5qaURHK2V3VVFKNWt2ellZQTRDcWdu?=
 =?utf-8?B?bkZBeVg3RktEV1JNVG9qUGg3WjBUbGp6YWYzWFI1d3YvU2FvWlRSOEN5ZW43?=
 =?utf-8?B?T0FOMk5KSDJRZHF6Wmp5S09lZGQxZVZGT3FOT0VldkUwYzczeVIrS3ZaeWNK?=
 =?utf-8?B?clVjd0JrTi9QM0xGdGlaWGJ6TlZtODdPSE1SSEozSmRhYVM1UTJBZllvUGFL?=
 =?utf-8?B?V3p2WFJjNGQxRjU2RmhLZlpLR3Ryd3lSRHlpMWU4QzdLQm9hVTZFNUJUNGYx?=
 =?utf-8?B?b3ZjODNmU094cEY3OVlMb1BYTHJjZGc4N1lrYno1cUVIcTdiT3pueWNjN0RO?=
 =?utf-8?B?YXZSZDNNU2pmakFEK3R3WDJTT0RrNkFuTDRNazdoQzdlMlNPTGx5SzYrSi9F?=
 =?utf-8?B?OHhBbllUZGxoMWFmNVNSSzNSUmRJMDg5cDRuZTlaS1Njd0tsT0FJdjlsVWdZ?=
 =?utf-8?B?K1BIMmV2NHlRVU13dXdkZkt6U09kUVA0U3UvRFMvKzNFNXdxWUptUnB3K2gx?=
 =?utf-8?B?eHpSQjBZMWFkSlJYcmxHdDZ6bUFUMnRaVk1BOWxuaVVCR29CWkgxN0h3WkZQ?=
 =?utf-8?B?d1dCOU5mOThqYXRUakFwYzl3OWlhRXpDSGYrcmx0aG1rdU1vSkRNRGxoZndY?=
 =?utf-8?B?Nk1CaVNrbmFTUjBrSHlkVVA0YWp1eUlsN0s1d1hzNE1PM0VoUWxkSVhWSGZi?=
 =?utf-8?B?TG9BZGVhTmhLVFdGbmRiYTM0UlpVeVlNU1RhdkpUQU1uV3VpWnhGdlZjRkhr?=
 =?utf-8?B?REk2a0ZFU2lBYWlTeU1kdHFrdzU5Z1hoZVZzUTNVaDMzQlRaSHI2eitsMlR3?=
 =?utf-8?B?SGF1K2dON2JYdXdxYnZuakFMNTZSS2hPUVJNU3RFcEF1cW1uWTVVUFUrSXQ4?=
 =?utf-8?B?TkxpcmZCRktrbXZpaUp6MFpjSXRYQnE1VWpKNGlhM0REdTMyUzZMdzhPOGda?=
 =?utf-8?B?TG1RbFFVMU1BeG43MUt5ZnNmMHhzYWovTlBaYWNOUFJqMUFPTngrMDJGV3hI?=
 =?utf-8?B?Sll0a1NJR0E4TDlpNEJDWHJGVjNmd0pXQ2tpSndoMnJZUkZWekMrTU9HK3cy?=
 =?utf-8?B?RVBSMGFSTWtRcG1vZG95L3l4cmtrTzU0elhleldmYVhpZEtuMyt2eU13dk8x?=
 =?utf-8?B?WjhHQmFJdnhvUE9kNjdXbTRHY3h6ZXMvckZ5OHhzMFA1N29lV1dkbENzNmxN?=
 =?utf-8?B?WVlLVEZWVktpZkI0cG9nVHZrNnRVUGE0MkJMSVJ4MG9WTTZWTjBIQlJudlRX?=
 =?utf-8?B?aytUTUd0a0JFeVhVT2x5SzhuektjeGF0ZXovYmkwUW5xZHlsU2NtT3M3Z3Jp?=
 =?utf-8?B?K2lqMy9uNnlMdGNzUFN4Z0JhTWFiS3Ewd3BsaE9Ka05GdWQyVUk3WmJ0aWd2?=
 =?utf-8?B?N2J1WTU5WWtqU045SXNwYStMVDJaaXhydlJrWmJ6eVRmTXNzL0RERXFWUk5W?=
 =?utf-8?B?ZGorZm1hODJNeHRPQndnVGMwUlVzNkNHZzVHa2hHQnNRaS9mTG5ibjN3RDk2?=
 =?utf-8?B?RFdic1Q1cHp4UjBhT3pJRlVMMnRxbGV0dXhSYkNpL29HdXRzTy9FYmZXUE1I?=
 =?utf-8?B?UE9XRkdPcTIyMFJlZi9IbElwK1ZvUEdYYWFvakdYZUZ0S0s1NUU2enZOQUxH?=
 =?utf-8?B?TGQwTnRsWUE3WkFzb2YxVkRyZWk2UW96a1NKeUNCY1FGQUM3M250bFJmUnEy?=
 =?utf-8?B?SGpqR3RQZXpPL25zeFR1T1BKZ1ZEd00xZnZXYXZ3UmhrY3FuWktaRFlYdjY2?=
 =?utf-8?B?am1qa1RwYTJKd1NQRWV6VmhEUWV1K3RRcGxxK3cxU0tRTjFwU2U0bTlIMkN5?=
 =?utf-8?Q?BWYIeG5SzqQEulEs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E606B52A758D314A8A90A9B14EA6F191@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: variscite.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5746.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98e6e7fb-3c57-4b20-15be-08da2e947163
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 12:40:31.8234
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 399ae6ac-38f4-4ef0-94a8-440b0ad581de
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yIS/3B9z1YZdktJ7wqSYlJ1cVG95xHhSwjxgikI0eTXMdgYoKrlSr3fbskh41D0byBZ399k8BOHOJncrUp5zvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3820
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA1LTAzIGF0IDEzOjUwICswMjAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiBPbiAwMi8wNS8yMDIyIDExOjAzLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4gPiBIZWxs
bywNCj4gPiANCj4gPiBPbiBGcmksIDIwMjItMDQtMjkgYXQgMTM6NDQgLTA1MDAsIE5hdGUgRHJ1
ZGUgd3JvdGU6DQo+ID4gPiBEb2N1bWVudCBkZXZpY2UgdHJlZSBwcm9wZXJ0eSB0byBzZXQgR0Vf
Q0xLX1JDVlJfMTI1X0VOIChiaXQgNSBvZg0KPiA+ID4gR0VfQ0xLX0NGRyksDQo+ID4gPiBjYXVz
aW5nIHRoZSAxMjUgTUh6IFBIWSByZWNvdmVyZWQgY2xvY2sgKG9yIFBMTCBjbG9jaykgdG8gYmUN
Cj4gPiA+IGRyaXZlbiBhdA0KPiA+ID4gdGhlIEdQX0NMSyBwaW4uDQo+ID4gPiANCj4gPiA+IFNp
Z25lZC1vZmYtYnk6IE5hdGUgRHJ1ZGUgPG5hdGUuZEB2YXJpc2NpdGUuY29tPg0KPiA+ID4gLS0t
DQo+ID4gPiDCoERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvYWRpLGFkaW4u
eWFtbCB8IDUgKysrKysNCj4gPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKQ0K
PiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRp
bmdzL25ldC9hZGksYWRpbi55YW1sDQo+ID4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQvYWRpLGFkaW4ueWFtbA0KPiA+ID4gaW5kZXggMTEyOWYyYjU4ZTk4Li41ZmRi
YmQ1YWZmODIgMTAwNjQ0DQo+ID4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmlu
ZGluZ3MvbmV0L2FkaSxhZGluLnlhbWwNCj4gPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvYWRpLGFkaW4ueWFtbA0KPiA+ID4gQEAgLTM2LDYgKzM2LDExIEBA
IHByb3BlcnRpZXM6DQo+ID4gPiDCoMKgwqDCoCBlbnVtOiBbIDQsIDgsIDEyLCAxNiwgMjAsIDI0
IF0NCj4gPiA+IMKgwqDCoMKgIGRlZmF1bHQ6IDgNCj4gPiA+IMKgDQo+ID4gPiArwqAgYWRpLGNs
a19yY3ZyXzEyNV9lbjoNCj4gDQo+IE5vIHVuZGVyc2NvcmVzIGluIG5vZGUgbmFtZXMNCj4gDQo+
ID4gPiArwqDCoMKgIGRlc2NyaXB0aW9uOiB8DQo+ID4gPiArwqDCoMKgwqDCoCBTZXQgR0VfQ0xL
X1JDVlJfMTI1X0VOIChiaXQgNSBvZiBHRV9DTEtfQ0ZHKSwgY2F1c2luZyB0aGUNCj4gPiA+IDEy
NSBNSHoNCj4gPiA+ICvCoMKgwqDCoMKgIFBIWSByZWNvdmVyZWQgY2xvY2sgKG9yIFBMTCBjbG9j
aykgdG8gYmUgZHJpdmVuIGF0IHRoZQ0KPiA+ID4gR1BfQ0xLIHBpbi4NCj4gDQo+IFlvdSBhcmUg
ZGVzY3JpYmluZyBwcm9ncmFtbWluZyBtb2RlbCBidXQgeW91IHNob3VsZCBkZXNjcmliZSByYXRo
ZXINCj4gaGFyZHdhcmUgZmVhdHVyZSBpbnN0ZWFkLiBUaGlzIHNob3VsZCBiZSByZWZsZWN0ZWQg
aW4gcHJvcGVydHkgbmFtZQ0KPiBhbmQNCj4gZGVzY3JpcHRpb24uIEZvY3VzIG9uIGhhcmR3YXJl
IGFuZCBkZXNjcmliZSBpdC4NCj4gDQo+ID4gPiArDQo+ID4gPiDCoHVuZXZhbHVhdGVkUHJvcGVy
dGllczogZmFsc2UNCj4gPiA+IMKgDQo+ID4gPiDCoGV4YW1wbGVzOg0KPiA+IA0KPiA+IFRoZSBy
ZWNpcGllbnRzIGxpc3QgZG9lcyBub3QgY29udGFpbiBhIGZldyByZXF1aXJlZCBvbmVzLCBhZGRp
bmcNCj4gPiBmb3INCj4gPiBhd2FyZW5lc3MgUm9iLCBLcnp5c3p0b2YgYW5kIHRoZSBkZXZpY2V0
cmVlIE1MLiBJZiBhIG5ldyB2ZXJzaW9uDQo+ID4gc2hvdWxkDQo+ID4gYmUgcmVxdWlyZWQsIHBs
ZWFzZSBpbmNsdWRlIHRoZW0uDQo+IA0KPiBUaGFua3MhDQo+IA0KPiBOYXRlLA0KPiBKdXN0IHBs
ZWFzZSB1c2Ugc2NyaXB0cy9nZXRfbWFpbnRhaW5lcnMucGwgYW5kIGFsbCBwcm9ibGVtcyB3aXRo
DQo+IGFkZHJlc3NpbmcgYXJlIGdvbmUuLi4NCj4gDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IEty
enlzenRvZg0KDQpIaSBBbGwsDQoNClRoYW5rcyBmb3IgeW91ciBmZWVkYmFjayBvbiB0aGUgcGF0
Y2ggYW5kIHByb3BlciBhZGRyZXNzaW5nLg0KDQpUaGlzIHBhdGNoIGlzIG5vdyBkdXBsaWNhdGVk
IGJ5IHYzIG9mIEpvc3VhJ3MgcGF0Y2gsIHdoaWNoIGFwcGVhcnMgbW9yZQ0KY29tcHJlaGVuc2l2
ZToNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIyMDQyODA4Mjg0OC4xMjE5MS0z
LWpvc3VhQHNvbGlkLXJ1bi5jb20vDQoNClJlZ2FyZHMsDQpOYXRlDQo=
