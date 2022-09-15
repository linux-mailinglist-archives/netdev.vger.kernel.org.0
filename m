Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA875B9446
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiIOG1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIOG1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:27:15 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120089.outbound.protection.outlook.com [40.107.12.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72ECA7963A;
        Wed, 14 Sep 2022 23:27:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIUjJ9Wmw5O94VfcFgtd9IflwYwdzH9qpr8F8H/uGzyf52rirvT/zjmNuBb/ZbIL0VPZnnvwzkU48Dqo6+OspOLcmhy+CAMbrMSwfV7n4jkDDtnAYhy8oARa6OPEMoWPgS7AL16iUditTn/fxeeCffH1iF5N6ydrmAODioh43BV49matue8KArGXe98u4Ys5gMCIXjUvtZEvaLrTTCF0PJHQyJRdvyZWzF6cb5BRiXJQn7KhCWMoqZapoMJ8vZms6SxlODTV2itHB5rP8IqvhSou0W3DXs3lONXTMrArquqTY7m4jPnfv85eApuLOvGP+ecAWfG+oB589e5/qEvqQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgSNFQg8SNFp/zDmDYYoBaLqPEsmgADgIQIyWZJhN8w=;
 b=joyjKT8xZaQn9WWgeXoclOvkS5WFHrNNxW69Z1oLkC2VM/N3ufYH59VIGmKQPugDR8ON6zPgcMHlgFTliel/0+g0if/O9/ahS5MniT9xpe9O2xBmBtf6LpCt8JpTGw4StE/d2aSh4pMLkjAvgEFUNoP5HZIigheK88ooUuLf7mOOZe6Owo9NsClIdNA8UXa1+89jD/37urSwUUGLEOYOtWh5VFPX4x1HFgZnNLXznLqaBl5Fsw/P1hgPP3Ez8VFHkFqApHcnw/q+j8wKOW7WukJ++xSMlgutUYW2arLxwJo/c6zHqr1vzBn0rY8WHOXA2Lw9gvQRLE1NeXO2PbKOWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NgSNFQg8SNFp/zDmDYYoBaLqPEsmgADgIQIyWZJhN8w=;
 b=2YXlxwzKVya4c5Sbiy1xAjIP/bH6JpUF9T+ikNY5vlYP6XHe8tYME+9aYxmrNDgtHraj91LXgVkpN/wuYzy+VrEQmYTrmC2TwR5rh3Zdlj57VcQ5YSJgdzase6mdd+OGvp58RqajdC4jjuGSXMwGXi3DCooT7GqPDp6CQnuHymSSRc6ajs5tA0yoouv+qpwJ88qBOBDIV8K2nPD8D6TUAj7iGilfHg3UL4cGbJPsa2+WVPoHknnnc1gU5aG3l0xq4+fijaFYZ/QbZBm/E+9PuRwPshAUwJDp5V61y0nEWa7Xn+bNn5n/3VatH5l2xNXPWU92Pau5C26vRAMcvGkhPQ==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB3361.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:29::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14; Thu, 15 Sep
 2022 06:27:10 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::382a:ed3b:83d6:e5d8]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::382a:ed3b:83d6:e5d8%5]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 06:27:10 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>,
        "pantelis.antoniou@gmail.com" <pantelis.antoniou@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "zhengbin13@huawei.com" <zhengbin13@huawei.com>
Subject: Re: [PATCH -next] net: fs_enet: Fix wrong check in do_pd_setup
Thread-Topic: [PATCH -next] net: fs_enet: Fix wrong check in do_pd_setup
Thread-Index: AQHYw4r4qqdHxG/o+Ear5m3EDbffkK3gEUgA
Date:   Thu, 15 Sep 2022 06:27:10 +0000
Message-ID: <c84e673c-3542-c5e5-3779-17312779871d@csgroup.eu>
References: <20220908135513.53449-1-zhengyongjun3@huawei.com>
In-Reply-To: <20220908135513.53449-1-zhengyongjun3@huawei.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|MR1P264MB3361:EE_
x-ms-office365-filtering-correlation-id: 03e23f28-dfac-4874-66f1-08da96e35247
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +nT2Z7+l5+hKFfg4LvmxlAogQNNYfz5wcugne8is7j9Is6HZZQvLMa7zfjFEDvdwwpWrWpxnVf7tQzZllbMQYedt84+h6r8kiglEDdlzBFugrrbLTZ7LyUfBzLswTfGvPI5c6LO/VigHkUDtm/nYtAgJUalsJ8whdVFibzlJUUWoAe7/wDvbvvalCpiNtT70vP6VD3y7+K7YskcScZgWwvsc01ckugJ8GKPbRG6rYokMLG3xsPZ4z3t9dBr2IBzFqTONyA8AAIIfK+p4cm6T1dsRLG6k00tTeEhaqjkiFMCqF0plazBK/yeIqltLFjwSJvOngL1McYjFsnXjGL6AIu+xQSoLDvXhPUlwy4LW1f1dfrsb8XmNF9W+7d/Of5ekLPfPMfFEBy811TyU59A9AJvkU0CFUZLw2ka0G/eXQhIc3IhPoCKIh+Vn75wYkXU5VfUBMiq/KE1WgDHtrTmL0r2jTZG/Gp4DraJiUohl6zIX+Ho+4WffPgh21kA2VsSBpX4QkSuc451m72FkxWVGQqSGvgvnacZjRjW1bTRGIZRgGaHA2AA42o13KbmLZQaENsQ11rfifGirJE45pxHP/+z1E1ZASPmyygMbd17cxgqxr+TYT1lpHlrJ15RVCf74uhm2LW/6e1blfZIHny9WemNoTbdpjFXPHlKvbuvffTmDEqwqWQrZjudk271c9YK/H/mgYhK0AZ9hUjTlTntx+ljxb+yw0oh5aiU0Re6XErtY7yZBJln3rKbvbvCIuyw+lpMeGHXUqARUOnEZwfEQiEzDxobKG+KmxqU6/esQCi81eDrCnUoCVkaiA8s1QzbuIyvcAXLm4YWlJTwbxo2vvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(136003)(366004)(39860400002)(451199015)(31686004)(7416002)(8676002)(4326008)(76116006)(66556008)(91956017)(66446008)(66476007)(66946007)(64756008)(6506007)(122000001)(110136005)(71200400001)(2616005)(8936002)(2906002)(5660300002)(186003)(36756003)(66574015)(83380400001)(44832011)(6512007)(38100700002)(6486002)(41300700001)(38070700005)(966005)(26005)(478600001)(316002)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUZWekRYZG5hSklYSnJlWHl3eHpkaEZkcFpqS3YyR1BsN2RJekk5ckNPdUp2?=
 =?utf-8?B?Z2thaGJ2OXVKemNXTkhiemdocnQ5ZDU5YW5DY05iR3JmWEY1aDJHRVk1OHBQ?=
 =?utf-8?B?NlQ4eUw1NnlFTmMrNmpGaEdhMDVtTXhzS1hELzFNeCtXbXRyZW5xWlVHamdu?=
 =?utf-8?B?ZkVFU2d2S29jUGFDSHJHcjZTblUwUHdETDdXWU43dDFkc3hDb2loaWp6aklj?=
 =?utf-8?B?L21NUmwyaWhSQzFYTzVWakNtc2FrOGZRRGlwR0RDNXowOFFNQ1N2WG5yaTRG?=
 =?utf-8?B?dUpza2RoV1JXRHlSWlV1b3hpYWVDdTlTYk9oWE5GUzRsSmFSMTBOUERjVXV2?=
 =?utf-8?B?czZlMXRLeFJ0KzU0cDJjUElvSTRsMm03OXVsemY0RHJFVmkzSm8rUWdKdk8r?=
 =?utf-8?B?aEM2WE9MSGdrT2hXaDBCdGFDNEdwT3hWdUxXZ3IvRTRiWkJUQUV0MnF5YnR5?=
 =?utf-8?B?Y2lWYXFjSERaTU1mUitaNFFsZXRaU1hOdjBOU0lKTW9aN1lyMjI4MUQycDRE?=
 =?utf-8?B?a0JpTzRxZmQxSk1naEVyb3dibTJHcSt5WVpIRGRsTmU2dExOOXI4QVd2SmRH?=
 =?utf-8?B?UkEwcG1VZ20zR0xWZDNGOEdTQSt3RzBMRGRHSkNrWldxaEF1VnRqNGpLakN2?=
 =?utf-8?B?aWRvQkh2TTJ1cEFnUWVmSkdtZXp1dXdHK0I1K2ZjN0hXejJsS2svODREV1cw?=
 =?utf-8?B?NitLSnArQ004TWFvb0pMNXBveTA5cVJjTGtBSlRNdit0QjhWQjA1c1JraGNm?=
 =?utf-8?B?cXRGTEZmUzRRMFlzNVFHNmxBKzBMT2NBOXA5bVAyVUNEVUJxaXBiK2RmdjlD?=
 =?utf-8?B?NGx6K1kweFcwNFJBMms5bTRuN01IandWOE9wZEg5RjJjaVpwU3lxc3FwWXRC?=
 =?utf-8?B?RDhhdnIvcDJ1UXpzbGFNaDNGNnpRcGQrUlIxY20xNngrQ3FzYTFWMllmaUx6?=
 =?utf-8?B?OWZKZGc1MWhjZmQ5Zm5LL2Z5eVMyZzcwVGxGK3Y5SHRSM1ZUMFo4dlEzc3oz?=
 =?utf-8?B?SjV6UGV2VE9RTlU5M1RlcStwamJkaFFJTU96RGF0cXE1bTl6a0FDSHJuMVRW?=
 =?utf-8?B?WkRKZGFwdTdrSEZmQnhQMm9zTitrN3ArUTkvQms0VXZEQ1U4cUxEN1MvREtB?=
 =?utf-8?B?a0FoU3ZzcnFxY1N4T1Q0UzNJZHdERGI0cklmblk0SVZkb3FrQ3RMYjRRaTJE?=
 =?utf-8?B?SUJUTi9yUis5LzArYjBGejhZeEJBam5lVXZMdjEzL0MvamFEK3A4RTFQWFRQ?=
 =?utf-8?B?KzJFMXNLb2p3UUlnSjRRcEw5TlRRdHhjYnBYNDBMSXo3aTBwM09vb2ozY0RQ?=
 =?utf-8?B?MTRQUTN4UG9NT1hlc1Q1dVRQbDlyVUFBSUpLbFFHUDdTdmxwK3BVeWdYTG1B?=
 =?utf-8?B?RUtMQkdaRldHZEdXbk9OR1pVUjdyRTNpNFNTUHFydjJIeGkyYnZ2QytJdjMr?=
 =?utf-8?B?K1BDTFZ5aW9vQTJ1NmszUU91cHRhYkJDNlF0bHp4RGg0cmZodHQwZ1VXR0NH?=
 =?utf-8?B?NWRjMEo3ZWZ6eUplQ3pxUkdlOHpUUGxRUGw5bHJ3NEJCR2Y1cDc4TVg0S09C?=
 =?utf-8?B?ZFB0d01QLzhHODk4bUxZUGs0WlZpaWYrUlQxSHJvTFEzQUk0RlE2cWVJOXdi?=
 =?utf-8?B?UndCdm1aL2hUeWhib28zOUFhaXhDVnQvMmFlZzd3Q0prT3E3N0YwMyttV0c3?=
 =?utf-8?B?aUlaVE9YTk8xSEp6K0Q1dmtLV20vVlltd2hNSUtKV2U4UEVQSEhha1JpQ1ZI?=
 =?utf-8?B?WHdmRy8xUVF0ekl0V3FGZGNrMzIrQzB6R2tOUmVRM0pGazM1ODN2RUJ2MG93?=
 =?utf-8?B?ZUU0SVpiRVVPa3lxOTV4d2lQd1JWQjNjV0Vtd2dEVmJFaXZneUU4cjJEWXIr?=
 =?utf-8?B?dWJGVURUMjhNWERBMHlCd0ZodlhkbTF1ajZTME90TXpmQ0xuRTVXa3VYYkVa?=
 =?utf-8?B?Z0U2L24yNkdJbDRLVnFNeHdkVmlJRytObk5BZG45dEtOSG82YksrMThnU3Rj?=
 =?utf-8?B?VFJmajB6VXNveXMySjlWc20zTzlZTHpjcnE1RzM5QWVMZHBZTTJ4MkdOMGJh?=
 =?utf-8?B?NnA0NldrNzJkNjJ5dTBwWXdNOFFCVDdsY2h5VVVCeWwzSTl6MngwdllqTUhK?=
 =?utf-8?B?emxtYlN4RXd6eTBiUWNxaHpjdnpQMFVZUTVGekRkREFIRXlyNkZXcmhldCtI?=
 =?utf-8?Q?V8oZdDl11yqErfsURRuWc8w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3BA7D6109DC9B44B0CB57CE544C451E@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e23f28-dfac-4874-66f1-08da96e35247
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 06:27:10.8031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDZEODEhoN5WXFHG4YYv5W+LSblP9KdqcMFebru7qvIDz1NARLiwZOrWQBDW0gscjCJ64sNVrKNohI27aBA1mfaVlk7GdH4HppzBwUBbOpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB3361
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDA4LzA5LzIwMjIgw6AgMTU6NTUsIFpoZW5nIFlvbmdqdW4gYSDDqWNyaXTCoDoNCj4g
W1ZvdXMgbmUgcmVjZXZleiBwYXMgc291dmVudCBkZSBjb3VycmllcnMgZGUgemhlbmd5b25nanVu
M0BodWF3ZWkuY29tLiBEw6ljb3V2cmV6IHBvdXJxdW9pIGNlY2kgZXN0IGltcG9ydGFudCDDoCBo
dHRwczovL2FrYS5tcy9MZWFybkFib3V0U2VuZGVySWRlbnRpZmljYXRpb24gXQ0KPiANCj4gU2hv
dWxkIGNoZWNrIG9mX2lvbWFwIHJldHVybiB2YWx1ZSAnZmVwLT5mZWMuZmVjcCcgaW5zdGVhZCBv
ZiAnZmVwLT5mY2MuZmNjcCcNCj4gDQo+IEZpeGVzOiA5NzZkZTZhOGMzMDQgKCJmc19lbmV0OiBC
ZSBhbiBvZl9wbGF0Zm9ybSBkZXZpY2Ugd2hlbiBDT05GSUdfUFBDX0NQTV9ORVdfQklORElORyBp
cyBzZXQuIikNCj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0Bo
dWF3ZWkuY29tPg0KDQpSZXZpZXdlZC1ieTogQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5s
ZXJveUBjc2dyb3VwLmV1Pg0KDQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9mc19lbmV0L21hYy1mZWMuYyB8IDIgKy0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZnNfZW5ldC9tYWMtZmVjLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9mcmVlc2NhbGUvZnNfZW5ldC9tYWMtZmVjLmMNCj4gaW5kZXggOTlmZTJjMjEwZDBmLi42MWY0
YjZlNTBkMjkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9m
c19lbmV0L21hYy1mZWMuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUv
ZnNfZW5ldC9tYWMtZmVjLmMNCj4gQEAgLTk4LDcgKzk4LDcgQEAgc3RhdGljIGludCBkb19wZF9z
ZXR1cChzdHJ1Y3QgZnNfZW5ldF9wcml2YXRlICpmZXApDQo+ICAgICAgICAgICAgICAgICAgcmV0
dXJuIC1FSU5WQUw7DQo+IA0KPiAgICAgICAgICBmZXAtPmZlYy5mZWNwID0gb2ZfaW9tYXAob2Zk
ZXYtPmRldi5vZl9ub2RlLCAwKTsNCj4gLSAgICAgICBpZiAoIWZlcC0+ZmNjLmZjY3ApDQo+ICsg
ICAgICAgaWYgKCFmZXAtPmZlYy5mZWNwKQ0KPiAgICAgICAgICAgICAgICAgIHJldHVybiAtRUlO
VkFMOw0KPiANCj4gICAgICAgICAgcmV0dXJuIDA7DQo+IC0tDQo+IDIuMTcuMQ0KPiA=
