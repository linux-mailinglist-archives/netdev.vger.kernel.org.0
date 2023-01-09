Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 022A6662A84
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 16:50:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjAIPuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 10:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbjAIPtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 10:49:40 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2054.outbound.protection.outlook.com [40.107.12.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 070AC3C73F;
        Mon,  9 Jan 2023 07:49:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2I7LwQ57BOWmpuGkZJ1sRG2jEJHBfURLEqeWsvGSFh9HNPM0rFWpWiZ7ltuOlAgSDDRohp7Cpi61D1sLK6mO9QdNmyVVmjpR8P4QLZnFznxjlQi3kDyoAIZ1aFcSvjUkhTirKJyCncHcgfsMePny7FmmcCereCAX1cxNxeJGgHQfqJy9u5bAlo9Dupqb3d6N31mkDexIuiWBK/SlfHE1QGgDgsilZr0lSMZf4nNk3U3xgGntWWNRE1oPVwJrmfd0xyy2qNqGF/d5iUs6R2SjJRvZzd3i9tMbklJhAZ48IkDZPHSz80/pPdwj8SBxUTwKiarKEU/Gc32BQBU+RlT0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TcIdgyCVGyuEMH5mxFSql0BScVCBXlqDgTgy31NC0UI=;
 b=WVLfvwb9qmnU8uNubFghgXKBzbY8vHyCKqe4gppig0YoUJATHbUPcbh5Y83ND0v1Hduli3AgvkLA+qhMCI6V83/9bm8WBcRfL2t9f4wT85Qw2zseyJZhcOQ1LN2RSsJdUkQWd/lo797Mtjz5jZmf/4Ll83eik+U4luWiEo6XH1P2VJJlv0D+11q3REpOOlSxg2OyNNZmMbxCbV4haEYiN6AChr7rsobRhqpsgyWHW5vvCTOysK3XJ2IcnOg7Jo34hZUAfGJmsFE1c3JMQWwTFUrLQcLNGB6ErvPvSggxlxg/8r3q8OOtca5uTqYgwmPX7MLUkYqH0KpCvcfCzkMAwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TcIdgyCVGyuEMH5mxFSql0BScVCBXlqDgTgy31NC0UI=;
 b=tKfl456YGosASW32ZESe2BuZ1UvQmVJ70C357zcFynnFtH6NHRNm989UP5ozkj5jLt5QnPrCB3Ang1/x0icS3PVVgJgi0c5kURtFdbIJcGhBwAKLTVWHo/ikdffqbpO5doX9VkHmCmslDxhLCm8wOAc5btuXjkT0poa1D4b1PwJJIgricRsJODq1tixoTbibaz7/AubT1GjbRJf0QHh2vJf8C5ReCYX3w90zAbLFX0N8kO7VwtNSIkkHuHlkzrifmsMgFk5iKMbChBFh3QVJ+zd3KPhn8yxzTfziI74eVJtJJerjQqpEgD2403cdM4ITYhDn+TwS8QdNbrk/uLvuBQ==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB3013.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 15:49:23 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 15:49:23 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Ekaterina Esina <eesina@astralinux.ru>,
        Zhao Qiang <qiang.zhao@nxp.com>
CC:     "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net-wan: Add check for NULL for utdm in ucc_hdlc_probe
Thread-Topic: [PATCH] net-wan: Add check for NULL for utdm in ucc_hdlc_probe
Thread-Index: AQHZFxzZzxDc+uM14kSkvyuO7aEPOq6WVamA
Date:   Mon, 9 Jan 2023 15:49:23 +0000
Message-ID: <1b6326fa-69b3-0ef0-2927-60f6fbd6ce28@csgroup.eu>
References: <20221223143225.23153-1-eesina@astralinux.ru>
In-Reply-To: <20221223143225.23153-1-eesina@astralinux.ru>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR0P264MB3013:EE_
x-ms-office365-filtering-correlation-id: f85d1291-cf91-43b5-777f-08daf2591494
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 43OZsiBl8tHTUHM1CdtZsjnGcLlOYJ3PJzhjnrerdBGokFzw7HCAi60PYvyhNdwOQgwZ7a96/n4gXt+Wp10XPo7kOl9v6Nm3pESlFzVTdQD7jPOjv3hwOkOsiyTV/P0jv/GIxVLZ517Y/12vyysnAUqNXLCXiu2pqEEZEqhCZ6UJAbFusOf+Zua1GiEy7FeJ2sOkBzti58RYsouLqAGfy/btgF4VGiJ4SSeK4b1N+WPEQlgJt7JbdnVXs0BbjuksXkrYlSy7/AZl5Nn9cOPrxcZzAw6ytAntXzmiWWtu8HzB7/BY7C5L6oCdUxUVF1co24c/Il7TKGXjruHgTvIIUq2h1vKWmiNudduOaNsvjFSVimsmL5BWXjHTvXzmItje7VgypG2B4zWNs+rAfrwdpRt4UvRbT+Oja+BenJAA953ciCYAIa6uo5qrVg1mhMWbhvX+ojxcIT8okP62KNJ5ps+bpaYYoBYqh+PC2+JSUPIZOe8WvuxnX2ZQQeIHs6+r1A7+VXfTCrKUz0j48HgpwxVHBwEOw04dL596kWbAxX0s9O4Xs93fDnOW6q5JgOZyz+I8fHcazQ7R16xfUojEDMEuTXR3D4sB3wYISfvkhJoHwXSqdvy0NIPrtX7bOfPrjqzW5p72UlKm/xFrzx1aIixntsvftdxslEA4JIiBYpXqZo+NItWxxFN2z6wM4JTltJxN3iqzqc94DfVdK5ZtN3lV+QE0v72jqCHl8ywKum0FqfYAhKVE15uMNDuXN8a2nXSV4nXPx/BxAxn4NxGspw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(366004)(39850400004)(376002)(451199015)(6506007)(38100700002)(122000001)(31686004)(2906002)(186003)(478600001)(966005)(6486002)(2616005)(8676002)(44832011)(26005)(6512007)(5660300002)(316002)(71200400001)(7416002)(8936002)(83380400001)(36756003)(38070700005)(86362001)(66574015)(31696002)(41300700001)(66446008)(110136005)(66946007)(66556008)(76116006)(91956017)(66476007)(54906003)(4326008)(64756008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnYyZDVHaWlVa0ErSjA5OGM0bDR2OUtIVnA3QkVzVHZSaFM2ZzQzZjBHYjZ5?=
 =?utf-8?B?cm9tdXo5V0dkSVlyc0JXVHovWkdNQTZSYXdvZG12ZEZuV2lJYjNIVkc3RzJy?=
 =?utf-8?B?OWlzbW5JSlNwTGZZMlpoamdHNnFMcE1xdTY0OVFHT25mNHVwOUxyaG1qczJN?=
 =?utf-8?B?RHVIalNaemRvaTJiOFdtMzVHYSt5VFFsZGpLMC9vc0tUMFYreFd1VExwdFhv?=
 =?utf-8?B?elZqRFl6TFRSdXN1eW92VXpTSGRHQXZzbGVEL2QxRXhrSXF1NXdxS01wK1Ns?=
 =?utf-8?B?dGFlWG53T1hlbWttZXU1UG53RDc0N2JVNk9ReW41bDhPQlE3NWtXeUtyTGFT?=
 =?utf-8?B?YUdsSCtqYkM0a1RmbVl6RVpqNmwzZEQrVkcveWJXUEhiMnBhOTlSbmlxOXQz?=
 =?utf-8?B?S1NocFhiSTNQRjFwQkNpY044WFVvUm5RMndzYllKRVp1QmZRMFRVSlo3MkhJ?=
 =?utf-8?B?L3JseUJCVWhpaGxtMU81bFI5Z3E0VEFQWVczaXJkVmVJQ3U3VXFhdktuSVpm?=
 =?utf-8?B?c1l1c1hiSkh4MlNVNXRjWktmb1VuR3IwLzBoYktaNlB5dnRXWUkrRTV2Qy9H?=
 =?utf-8?B?UmNUSkNLN0JqTmlUVWx0Y0Frb2NWbkNiQ3BBZ2w5c2gyU0Y3U09QNFluUE51?=
 =?utf-8?B?YTJtVFkvdGRGOEtoRThkVkRHenhyNGJCcDJ4NlN6eko0M0VFVWdWVitXeVpE?=
 =?utf-8?B?NVd0MUF0Zm13cDVmaHhITUQ5WDVpNVBodXZlSmJINUNUY3dieHFzeklGYVVD?=
 =?utf-8?B?aEdVYk9xNUwzTnUxSUtoVWg3VFNaOGY1NzFWUUpnQmlaaUUrelBiZjQwVzc2?=
 =?utf-8?B?bndJOVpNR0tZMzIvV1prQjZRRWJPUFVhK0lQdVgvWHl3VTVyRzdxNnR1dzBm?=
 =?utf-8?B?SnpHUFFPUXgwcTZjV2ZUTmlIb0hweDgrUVdYRjZWWG9veW45MlNyV1o3a0My?=
 =?utf-8?B?REhCYlBPK25aRlVsMXBhZGxKSDg4TXJOMmI2QXVUbWRIbGZQclVndFFFcjlX?=
 =?utf-8?B?L3c2NWw5UVpOWGVwM1hiMHFZdjdTa3Ezenh5dktweXloa3IwbnZMQThpWDB1?=
 =?utf-8?B?bkdoaFdxZ0JaU1puMlpVbVlWMDByYWxuQktBSlJ6ZTdwckF1aXAvSmllREFl?=
 =?utf-8?B?UWl1d21kYlNTZDRndjJFRzNCTzNEVWwzbEJVQWVGUzI1NVJtN0NLOWNvbC9p?=
 =?utf-8?B?azJkOHNWWTNkMjJ4TVpiQ3FQWDdob0g1bExXUjR3bmVjWE80YUdzMGhDUzNy?=
 =?utf-8?B?YzVjTG9QUWlYYW5kK1pjRkwxSUMrZmxFT01PRmFQYXdBeENOK2xJNVVtUGZm?=
 =?utf-8?B?Y1NTMWJsMUNlRmJvWGk0N01ONDBiaDd3aHMxSEJaTUkxRE5yUlNxUXlzK1JR?=
 =?utf-8?B?NGZVN0FtblUzVWZWOG5CZ2xPTnVJVjU1cGcrb0IrMWkxUVhadnczRzhtTnN6?=
 =?utf-8?B?bE5icnA4OUFpWWluSHMxaGNma05WQVRKWXNRWnI2Y0tWVTNEaXFYQ2JsSktL?=
 =?utf-8?B?cldVUGZVYkV2dTQzRFZPeWZWaEJmU3ZnbE9tWHNzcU5Pd1JVSkpNNmk5WE5W?=
 =?utf-8?B?ci82T1RDcWxpZTVBZE0xUWV5QysyQTlpMHUyVGhQOWpNVGJFeU1EVURmYXZz?=
 =?utf-8?B?SmtWVUJic1JuZjFCV2Ewb2NMckQ4dlBFU1RXV1lHVW5IVmJqaXBPYTNRa0xP?=
 =?utf-8?B?Q3Q4dHBCVGlMSExWUzIyTFZsc2hDM1cxcDQ0SFI2NTRrRndtY3BRNlJtUmlp?=
 =?utf-8?B?MVBvbUdtZFFYdmUvcnRQUk9JQmR1N3JwbTFIa2VQL21Wc3hFeGhMbXhKc1FB?=
 =?utf-8?B?SWtTUU10d2pJSTh4WXovcWt4SlZYNTIrbkgzMHA4a3ZLdVJNWW1XaW1CRk82?=
 =?utf-8?B?WFNMU2UwVUx4ZVRWRDZ4dUVtaVozZnI5djQ3M3I1ZVVTT0svVUs1S2labkg4?=
 =?utf-8?B?Vkg0TzdNcFVBRTVnMWxSdEtpSW1vMTBrOTRWNHRZTFBkRE1jNFFWenR0WHRa?=
 =?utf-8?B?czhRMzNEQWlPM1lxS0QxODBudEY2cDlpMGc3bjc3eE10RzNWV1F3emgrWVdH?=
 =?utf-8?B?akRKK2FvTzQzODRlV3ljSnVmT3FPUUJLUHNpNkVYWHRzUGlUc1YwMlBFeVdv?=
 =?utf-8?B?SnlsSEoxMWN2U2hrNXQzRVIvV3pZT3Vid1BRNjlJWnNjeWFqeVNMR09WbTlJ?=
 =?utf-8?B?Mmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E066305B47B05F49B5D4097FABC51653@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f85d1291-cf91-43b5-777f-08daf2591494
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 15:49:23.7319
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 54meIQDm/NbEgmpV9Dzz1TcyxI9qKsl67pj3zCMJmXT7q2AOrJXw+zcoZHENDs4MfaHBfq9U9Kb1aPSuffodd87wmpj86jbcyJ4oNLY7B/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3013
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDIzLzEyLzIwMjIgw6AgMTU6MzIsIEVrYXRlcmluYSBFc2luYSBhIMOpY3JpdMKgOg0K
PiBbVm91cyBuZSByZWNldmV6IHBhcyBzb3V2ZW50IGRlIGNvdXJyaWVycyBkZSBlZXNpbmFAYXN0
cmFsaW51eC5ydS4gRMOpY291dnJleiBwb3VycXVvaSBjZWNpIGVzdCBpbXBvcnRhbnQgw6AgaHR0
cHM6Ly9ha2EubXMvTGVhcm5BYm91dFNlbmRlcklkZW50aWZpY2F0aW9uIF0NCj4gDQo+IElmIHVo
ZGxjX3ByaXZfdHNhICE9IDEgdGhlbiB1dGRtIGlzIG5vdCBpbml0aWFsaXplZC4NCj4gQW5kIGlm
IHJldCAhPSBOVUxMIHRoZW4gZ290byB1bmRvX3VoZGxjX2luaXQsIHdoZXJlIHV0ZG0gaXMgZGVy
ZWZlcmVuY2VkLg0KPiBTYW1lIGlmIGRldiA9PSBOVUxMLg0KPiANCj4gRm91bmQgYnkgTGludXgg
VmVyaWZpY2F0aW9uIENlbnRlciAobGludXh0ZXN0aW5nLm9yZykgd2l0aCBTVkFDRS4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEVrYXRlcmluYSBFc2luYSA8ZWVzaW5hQGFzdHJhbGludXgucnU+DQo+
IC0tLQ0KPiAgIGRyaXZlcnMvbmV0L3dhbi9mc2xfdWNjX2hkbGMuYyB8IDQgKysrLQ0KPiAgIDEg
ZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC93YW4vZnNsX3VjY19oZGxjLmMgYi9kcml2ZXJzL25ldC93YW4v
ZnNsX3VjY19oZGxjLmMNCj4gaW5kZXggMjJlZGVhNmNhNGI4Li4yZGRiMGY3MWU2NDggMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvbmV0L3dhbi9mc2xfdWNjX2hkbGMuYw0KPiArKysgYi9kcml2ZXJz
L25ldC93YW4vZnNsX3VjY19oZGxjLmMNCj4gQEAgLTEyNDMsNyArMTI0Myw5IEBAIHN0YXRpYyBp
bnQgdWNjX2hkbGNfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gICBmcmVl
X2RldjoNCj4gICAgICAgICAgZnJlZV9uZXRkZXYoZGV2KTsNCj4gICB1bmRvX3VoZGxjX2luaXQ6
DQo+IC0gICAgICAgaW91bm1hcCh1dGRtLT5zaXJhbSk7DQo+ICsgICAgICAgaWYgKHV0ZG0gIT0g
TlVMTCkgew0KPiArICAgICAgICAgICAgICAgaW91bm1hcCh1dGRtLT5zaXJhbSk7DQo+ICsgICAg
ICAgfQ0KDQpJZiB1dGRtIGJlaW5nIE5VTEwgaXMgYSBwcm9ibGVtIGhlcmUsIGlzbid0IGl0IGFs
c28gYSBwcm9ibGVtIGluIHRoZSANCmlvdW5tYXAgYmVsb3cgPw0KDQoNCj4gICB1bm1hcF9zaV9y
ZWdzOg0KPiAgICAgICAgICBpb3VubWFwKHV0ZG0tPnNpX3JlZ3MpOw0KPiAgIGZyZWVfdXRkbToN
Cj4gLS0NCj4gMi4zMC4yDQo+IA0K
