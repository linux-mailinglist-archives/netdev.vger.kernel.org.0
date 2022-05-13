Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F4A525C92
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 09:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377897AbiEMHuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 03:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377891AbiEMHuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 03:50:05 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90073.outbound.protection.outlook.com [40.107.9.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4FA13C4D6;
        Fri, 13 May 2022 00:50:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYN6+3ZlFZpm1WE8BFlPJIaviEI7kpVlgdqQtfBHFZ6yUjwZmCu6k4nADhZWrxZuUuQFEU5dMokExfMsJMsLAfTBNPYWvo34dUHytfI8f628mIZ69NaYO1F9YjhgkoAPamqD1DFJpRAa4VQHNUAW5hLj1Wt18eXUSUVd+eCQPwizBNkP7yNRfjM7T+CcjFxkGBp8ze+kOxT050C3NPsslat5UUZz9YQc8PZr+lIXv8q4yNC64SpDrDeFmcOtGpoTyGrOLrFq2wx7vPgpQDSLcLinZjSjpyOzm2RTlvXaMTbi89kjVsfmlYcO/9o0xbmp37g2QBfS1tYSTpwNvHJQtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XQo8fAgwrnHsHkpMXBaXL6Ng8iYev3/4tJxYzHxDHAA=;
 b=lxrmuDydv7ptvqrcglPrF1j8415dJfQ60jT9mW0wuOOLpWcRcyl2WDwig86pLUDbyy6WKFhPB4N4Em2xCjmW/12bENPki8cXVxnKhmaLVsluXtiRrTxoDHbnw9tUMCeXaJfhhq5nzD/JVEz+bDjVBX+jbsmVyeO6SlalRQMCyatNv8XjNu8Hq4W+cbcH/DslZ+4wgretXE5ivlgfncZmJslEbKvjrlPaV5sBdMk/v2TiYjTtL3lHOPuP8Aji3gE2eBQgTu8eupPBeRUXvnGnzTMAmEfZMMJ1XT0cTF5cf6engLOdCoIcjiZEV80YmWd9yGUDr6gjB8TnMhLNh+YGbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB1904.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:193::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 13 May
 2022 07:50:01 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d%6]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 07:50:01 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Hari Bathini <hbathini@linux.ibm.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
CC:     Michael Ellerman <mpe@ellerman.id.au>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jordan Niethe <jniethe5@gmail.com>
Subject: Re: [PATCH 5/5] bpf ppc32: Add instructions for atomic_[cmp]xchg
Thread-Topic: [PATCH 5/5] bpf ppc32: Add instructions for atomic_[cmp]xchg
Thread-Index: AQHYZdRx9aF2Tal9R0y7FgKMrFNStq0ccG2A
Date:   Fri, 13 May 2022 07:50:01 +0000
Message-ID: <025e9a60-46d9-bc3d-224e-1d92bc05f857@csgroup.eu>
References: <20220512074546.231616-1-hbathini@linux.ibm.com>
 <20220512074546.231616-6-hbathini@linux.ibm.com>
In-Reply-To: <20220512074546.231616-6-hbathini@linux.ibm.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88197431-e37c-45c8-03ca-08da34b52f45
x-ms-traffictypediagnostic: PR1P264MB1904:EE_
x-microsoft-antispam-prvs: <PR1P264MB190402568783980E879A8C12EDCA9@PR1P264MB1904.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oSvaZ+0sO081iTF9ClQCCe+W+/4IdCl6GAA845NDRbfm4MSG4DJ6ngPyxAR3Odb9yUGYNaPCZnRVGntE+jNu17ESFxa5e6jJowxy4mY0bvQVRDY1Z8DJXPTiIPZWtxCAUIdWxCstmfMfRn8IoSguFDS+03LrzeeMO6dl7GOY0w+EHTKytSbQHxGJreqlhhEPwYFBQdhXo7E7nXGTxjQ/o8ayycfwkOfw64JTj7O3GoOt4IDiBhg9tvAAMOcRtXWkd+pSupmoqzjgab0qMvIbFr512ngI/UEkiDwt56FbfCi0nfHKOJ9h85bLLkz6T1WtvluZ1ZUmej5HPNkkVIkGdEcwnkjXZsxugSyBzRjVaz05QoTcnqC3wJEFDjxVcRVpJQbsbzLXP84Lke3JhulnmyAAWu5W2kRyLtKHdkm31RDg1FIVYS3xJCuE04oZL/KVTZ9oWpjqz+s2COyGwOtwnaQBd5ryd5YJKo9LCFGEzMV9qUM+824pyRIhHehKfmEthHA9TiKK3fODPOhIVkD26tMZ1g8aHg9vz0jr69cNYfTkn6mJgEzoot6CCSGRxz8lsv4BWDbWt4eFqegIozxy+WrPuYqO0C4vQ6nq8V5Lvu/MIbBceYu4CW4RcsGxlC3J98ZBtYkkClvL9pfM8IEV+wEMN8OAtoAaer2bEK2/LwfyPBXlCdThDl0PayBUGYSlsnv2ubIt0qeK/tpkc4uIrkNYHbwKkO4wxKbOzbnXS8+71UlgEabwYdZDkQ/WnAt8EU2uP5t2uRHN0hRSmv7qiQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(76116006)(64756008)(66446008)(66476007)(66556008)(8676002)(31696002)(4326008)(91956017)(86362001)(54906003)(110136005)(122000001)(316002)(38100700002)(38070700005)(6512007)(26005)(6506007)(186003)(71200400001)(2616005)(83380400001)(508600001)(6486002)(2906002)(5660300002)(7416002)(44832011)(8936002)(36756003)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjRheWxvSkNrWHQ1MDBCSTBieTFyaUlUaURJaTdWOUltRzR0TTRiM0JueFdu?=
 =?utf-8?B?TE1qTmpiZ3NwMzlEdHNQUkZ0UUt3L3JxTTd4d2pPWXlDS0ZVT2J2QjVVbDll?=
 =?utf-8?B?ZGcvVWVmekVjaitlK2R3Zjl5dEh0SjhIeHhielM4MUdEZVpFeFF1L3RqNHZp?=
 =?utf-8?B?SVhwUlNnclBmVjlwT0NRNjNnQXZUaUJvN3JhYUVHSXBLL09malNZVVlQNmJw?=
 =?utf-8?B?Umd6OVBBTGZYNDdKNkRoSWY1M3ZqRE4xVE5mcktubDQrZ0w0N2N3ZVlYY1Zi?=
 =?utf-8?B?aVRzcURHM3JkaE0zWVpoN25LNldvMmpDWkNNdTJTeEFTYjVMa0dDam5MTCtQ?=
 =?utf-8?B?dzc1VEV6bUNYUCtJUHVKQ3lBZHRHcXgvais0YXBDL002ZFZJdk5CWjVERUpL?=
 =?utf-8?B?Vm0xTU9qTGtrSmFpNlViRG1OSnBGZm84aTlUeGJHS29lNWsvUWpPek1lVlA2?=
 =?utf-8?B?M0tHWlo0MHNDN05EaHYxVEwzaHV0VjRZcUVMSXAyN21IMHZTMGtUTnl5MmJx?=
 =?utf-8?B?bVV0RjRVTEdCM0RsZFlxaGlDNWVPOFp5OE1XdkJWcWo3MFNmOXJ5UnJXdkZ1?=
 =?utf-8?B?d3l1cnRqREFVN3U0TTZabHQ5TksvQXg1VWYrS1gxOVdyT0FkWHFnLzJEUUNR?=
 =?utf-8?B?djZQU0ZVZWo0YitYK2RBbmdDa1FJaXFwaGF3aEVjODZkdGw3aTdEUlJEeXlp?=
 =?utf-8?B?Y1BzMjRpYXZuOHVYSFBpVjFUV3pTVGdoS2hETHVWVUY5elR3K3YyZXJqTi9U?=
 =?utf-8?B?R0llRUxGZGJzQmJZTEVzbkU3UWZJb3NpWTdlckFWRy9yOG5PZ080VTBVYitT?=
 =?utf-8?B?WXhveTVMa3RBUlNDSTNDbEIzQnZFNlhDL3JyZEM4WXlIay9ZS3c2SUJWdFB4?=
 =?utf-8?B?U1hkbzdmUUpEcDRjYWRMZ0xYUS9ZMkF2bHRhcEZUUjd0TFNJczdWc25UcTMy?=
 =?utf-8?B?cndTRDNDbUY1dHc4RXMrMTcvczdDK1JrRExTWkduZk1Sb0hCZytuOFd5ZkFI?=
 =?utf-8?B?NERaQWw2Y0tiMlhlYWNObmRSb1I0dkpaQTFwVFQ4TU9Da3p2OUczTTk2VCsz?=
 =?utf-8?B?Sk1mZUJxcUd4am1aeWlUMEZZR2ZvQzR2MnE3R2owSm8xbHhYUGEyUFdWMGtI?=
 =?utf-8?B?Vjl4QnU5eFhmWENzaGNQNm9pUE9hQnNhQklCazk4Ukx2Y3RpTHJQRHpTOXRK?=
 =?utf-8?B?OFR5clFmazdJV1RKQk9CemhzRlhwYi9zZitycWlhMmE1SUVGYjhOb2xxM1FM?=
 =?utf-8?B?b0NVMHlOOFdrNGFaeW11RWM2Q1NlU0JzQ055Z0ZpYlNSdWkvSGRlWUo3WTNo?=
 =?utf-8?B?QnNrMWJ1dTdiVUw1QTdSaVF1Nm1UMG83ZW1VTkQ1NEUxRGJxS3ZlajFNNS9x?=
 =?utf-8?B?bmx5cGxFaC9hMmU2dU5tNlJiU0tUelhTZTB6N3JZaTNMVkRnZXNSSmtqYnFu?=
 =?utf-8?B?ZkVZOXprcHRia2FFUXRsODY5b3JKOCswWjBMWXcrRkNPUTJxWUpSQ1QzTHF2?=
 =?utf-8?B?M0VoQ1dsNlNCSWxwWmN0S3ZDQlNmdFV5QzhPL0VvWDM1cVlPcVAyQng4Nzlu?=
 =?utf-8?B?YmdOT3pWdWEvZUVwbE9URDVNdDBuSTVzOVlOUGVlWWdNdjJWVWxaOTVDNjVP?=
 =?utf-8?B?Y0dybzRESC9UR2J4S0pseXEvcEpQQkNHZkVhN1c2RkpzbEZkVHlCWHR2OEJS?=
 =?utf-8?B?TUIySnRrN1pCTTBtQ0QyOERuYm16d1Zxam05aXBlaXlEczQwUkQxb3Bhd1FP?=
 =?utf-8?B?QjVBZlkxRVZhaFNxZG1YZy9xRld2TllTa2VqWG0zZFBUYnB5UG5KWm96SC8v?=
 =?utf-8?B?Rmoyd0d4dWcyeUhCNHZvUDVMMzlLWXZWUzIzTHdkcmtRWW9nTEd0OGQzcG0v?=
 =?utf-8?B?VG9aREpnVTIxRDRrOGc3M3FSaFRid3g5TkhpQVo0Wkw2R2Z1VmtXb041R2hJ?=
 =?utf-8?B?RDBZRkRIQzVxYWsvQWNVQk1WRmlvdm9zMzhzd3p2T3AxZ1p6NUIyNEtlUmtp?=
 =?utf-8?B?QUk5THNWZ256aWlwZEN2VURUQWMwUy9pd1llUVQrc2lsVXlVUGxQYVdnVE9H?=
 =?utf-8?B?c2xTb21BTGhXd21IT3pXMmhmOFE0bk1ubXRva1hlbGZRODhxMk1tTVVpMzUr?=
 =?utf-8?B?a3pXOXE5Y3VMRnlmTDVLWWdHd0lyODFRUGdFeUFmZWFnS2Vqdkx0d2h0aEVJ?=
 =?utf-8?B?T0lVUkttNDVVZmJ0Ky8raXVITTZpV0N2aUd6OXA0cENBNXp0bm05Si9aRGVx?=
 =?utf-8?B?MTB5WVprcVFQdVd4Y1R3Y2J4R2NIVkdmKzhwUkExRWY4MlE2R3JOekJabldV?=
 =?utf-8?B?alZUVnQ2WWhDcHNuQ040cDIzZFNJRUdUelBhZFlldnNIUmhUdXRrTzlRUzdi?=
 =?utf-8?Q?bMYXQowW40h+eAiqjC/KIN8i17VlgdmTYQ+29?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <679746C24E293145934AEB137DCB228E@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 88197431-e37c-45c8-03ca-08da34b52f45
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 07:50:01.1717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0Y/2nVxcMtyx8hUMkaGHWiUgXLa+0jWej/wVz7PyVkZocWPt9IlKLbm4DuRB2cxj3cmAMkM6Zj3/BrZvhcYeZAgeXr83Ugj5MlE1joYP2JY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB1904
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDEyLzA1LzIwMjIgw6AgMDk6NDUsIEhhcmkgQmF0aGluaSBhIMOpY3JpdMKgOg0KPiBU
aGlzIGFkZHMgdHdvIGF0b21pYyBvcGNvZGVzIEJQRl9YQ0hHIGFuZCBCUEZfQ01QWENIRyBvbiBw
cGMzMiwgYm90aA0KPiBvZiB3aGljaCBpbmNsdWRlIHRoZSBCUEZfRkVUQ0ggZmxhZy4gIFRoZSBr
ZXJuZWwncyBhdG9taWNfY21weGNoZw0KPiBvcGVyYXRpb24gZnVuZGFtZW50YWxseSBoYXMgMyBv
cGVyYW5kcywgYnV0IHdlIG9ubHkgaGF2ZSB0d28gcmVnaXN0ZXINCj4gZmllbGRzLiBUaGVyZWZv
cmUgdGhlIG9wZXJhbmQgd2UgY29tcGFyZSBhZ2FpbnN0ICh0aGUga2VybmVsJ3MgQVBJDQo+IGNh
bGxzIGl0ICdvbGQnKSBpcyBoYXJkLWNvZGVkIHRvIGJlIEJQRl9SRUdfUjAuIEFsc28sIGtlcm5l
bCdzDQo+IGF0b21pY19jbXB4Y2hnIHJldHVybnMgdGhlIHByZXZpb3VzIHZhbHVlIGF0IGRzdF9y
ZWcgKyBvZmYuIEpJVCB0aGUNCj4gc2FtZSBmb3IgQlBGIHRvbyB3aXRoIHJldHVybiB2YWx1ZSBw
dXQgaW4gQlBGX1JFR18wLg0KPiANCj4gICAgQlBGX1JFR19SMCA9IGF0b21pY19jbXB4Y2hnKGRz
dF9yZWcgKyBvZmYsIEJQRl9SRUdfUjAsIHNyY19yZWcpOw0KDQoNCkFoLCBub3cgd2UgbWl4IHRo
ZSB4Y2hnJ3Mgd2l0aCB0aGUgYml0d2lzZSBvcGVyYXRpb25zLiBPayBJIHVuZGVyc3RhbmQgDQpi
ZXR0ZXIgdGhhdCBnb3RvIGF0b21pY19vcHMgaW4gdGhlIHByZXZpb3VzIHBhdGNoIHRoZW4uIEJ1
dCBpdCBub3cgDQpiZWNvbWVzIHVuZWFzeSB0byByZWFkIGFuZCBmb2xsb3cuDQoNCkkgdGhpbmsg
aXQgd291bGQgYmUgY2xlYW5lciB0byBzZXBhcmF0ZSBjb21wbGV0ZWx5IHRoZSBiaXR3aXNlIA0K
b3BlcmF0aW9ucyBhbmQgdGhpcywgZXZlbiBpZiBpdCBkdXBsaWNhdGVzIGhhbGYgYSBkb3plbiBv
ZiBsaW5lcy4NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGFyaSBCYXRoaW5pIDxoYmF0aGluaUBs
aW51eC5pYm0uY29tPg0KPiAtLS0NCj4gICBhcmNoL3Bvd2VycGMvbmV0L2JwZl9qaXRfY29tcDMy
LmMgfCAxNyArKysrKysrKysrKysrKysrKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxNyBpbnNlcnRp
b25zKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0X2NvbXAz
Mi5jIGIvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0X2NvbXAzMi5jDQo+IGluZGV4IDU2MDRhZTFi
NjBhYi4uNDY5MGZkNmU5ZTUyIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3Bvd2VycGMvbmV0L2JwZl9q
aXRfY29tcDMyLmMNCj4gKysrIGIvYXJjaC9wb3dlcnBjL25ldC9icGZfaml0X2NvbXAzMi5jDQo+
IEBAIC04MjksNiArODI5LDIzIEBAIGludCBicGZfaml0X2J1aWxkX2JvZHkoc3RydWN0IGJwZl9w
cm9nICpmcCwgdTMyICppbWFnZSwgc3RydWN0IGNvZGVnZW5fY29udGV4dCAqDQo+ICAgCQkJCS8q
IHdlJ3JlIGRvbmUgaWYgdGhpcyBzdWNjZWVkZWQgKi8NCj4gICAJCQkJUFBDX0JDQ19TSE9SVChD
T05EX05FLCB0bXBfaWR4KTsNCj4gICAJCQkJYnJlYWs7DQo+ICsJCQljYXNlIEJQRl9DTVBYQ0hH
Og0KPiArCQkJCS8qIENvbXBhcmUgd2l0aCBvbGQgdmFsdWUgaW4gQlBGX1JFR18wICovDQo+ICsJ
CQkJRU1JVChQUENfUkFXX0NNUFcoYnBmX3RvX3BwYyhCUEZfUkVHXzApLCBfUjApKTsNCj4gKwkJ
CQkvKiBEb24ndCBzZXQgaWYgZGlmZmVyZW50IGZyb20gb2xkIHZhbHVlICovDQo+ICsJCQkJUFBD
X0JDQ19TSE9SVChDT05EX05FLCAoY3R4LT5pZHggKyAzKSAqIDQpOw0KPiArCQkJCWZhbGx0aHJv
dWdoOw0KPiArCQkJY2FzZSBCUEZfWENIRzoNCj4gKwkJCQkvKiBzdG9yZSBuZXcgdmFsdWUgKi8N
Cj4gKwkJCQlFTUlUKFBQQ19SQVdfU1RXQ1goc3JjX3JlZywgdG1wX3JlZywgZHN0X3JlZykpOw0K
PiArCQkJCVBQQ19CQ0NfU0hPUlQoQ09ORF9ORSwgdG1wX2lkeCk7DQo+ICsJCQkJLyoNCj4gKwkJ
CQkgKiBSZXR1cm4gb2xkIHZhbHVlIGluIHNyY19yZWcgZm9yIEJQRl9YQ0hHICYNCj4gKwkJCQkg
KiBCUEZfUkVHXzAgZm9yIEJQRl9DTVBYQ0hHLg0KPiArCQkJCSAqLw0KPiArCQkJCUVNSVQoUFBD
X1JBV19NUihpbW0gPT0gQlBGX1hDSEcgPyBzcmNfcmVnIDogYnBmX3RvX3BwYyhCUEZfUkVHXzAp
LA0KPiArCQkJCQkJX1IwKSk7DQoNCklmIHRoZSBsaW5lIHNwcmVhZHMgaW50byB0d28gbGluZXMs
IGNvbXBhY3QgZm9ybSBpcyBwcm9iYWJseSBub3Qgd29ydGggDQppdC4gV291bGQgYmUgbW9yZSBy
ZWFkYWJsZSBhcw0KDQoJaWYgKGltbSA9PSBCUEZfWENIRykNCgkJRU1JVF9QUENfUkFXX01SKHNy
Y19yZWcsIF9SMCkpOw0KCWVsc2UNCgkJRU1JVF9QUENfUkFXX01SKHNyY19yZWcsIGJwZl90b19w
cGMoQlBGX1JFR18wKSkpOw0KDQoNCkF0IHRoZSBlbmQsIGl0J3MgcHJvYmFibHkgZXZlbiBtb3Jl
IHJlYWRhYmxlIGlmIHlvdSBzZXBhcmF0ZSBib3RoIGNhc2VzIA0KY29tcGxldGVseToNCg0KCWNh
c2UgQlBGX0NNUFhDSEc6DQoJCS8qIENvbXBhcmUgd2l0aCBvbGQgdmFsdWUgaW4gQlBGX1JFR18w
ICovDQoJCUVNSVQoUFBDX1JBV19DTVBXKGJwZl90b19wcGMoQlBGX1JFR18wKSwgX1IwKSk7DQoJ
CS8qIERvbid0IHNldCBpZiBkaWZmZXJlbnQgZnJvbSBvbGQgdmFsdWUgKi8NCgkJUFBDX0JDQ19T
SE9SVChDT05EX05FLCAoY3R4LT5pZHggKyAzKSAqIDQpOw0KCQkvKiBzdG9yZSBuZXcgdmFsdWUg
Ki8NCgkJRU1JVChQUENfUkFXX1NUV0NYKHNyY19yZWcsIHRtcF9yZWcsIGRzdF9yZWcpKTsNCgkJ
UFBDX0JDQ19TSE9SVChDT05EX05FLCB0bXBfaWR4KTsNCgkJLyogUmV0dXJuIG9sZCB2YWx1ZSBp
biBCUEZfUkVHXzAgKi8NCgkJRU1JVF9QUENfUkFXX01SKHNyY19yZWcsIGJwZl90b19wcGMoQlBG
X1JFR18wKSkpOw0KCQlicmVhazsNCgljYXNlIEJQRl9YQ0hHOg0KCQkvKiBzdG9yZSBuZXcgdmFs
dWUgKi8NCgkJRU1JVChQUENfUkFXX1NUV0NYKHNyY19yZWcsIHRtcF9yZWcsIGRzdF9yZWcpKTsN
CgkJUFBDX0JDQ19TSE9SVChDT05EX05FLCB0bXBfaWR4KTsNCgkJLyogUmV0dXJuIG9sZCB2YWx1
ZSBpbiBzcmNfcmVnICovDQoJCUVNSVRfUFBDX1JBV19NUihzcmNfcmVnLCBfUjApKTsNCgkJYnJl
YWs7DQoNCg0KPiArCQkJCWJyZWFrOw0KPiAgIAkJCWRlZmF1bHQ6DQo+ICAgCQkJCXByX2Vycl9y
YXRlbGltaXRlZCgiZUJQRiBmaWx0ZXIgYXRvbWljIG9wIGNvZGUgJTAyeCAoQCVkKSB1bnN1cHBv
cnRlZFxuIiwNCj4gICAJCQkJCQkgICBjb2RlLCBpKTs=
