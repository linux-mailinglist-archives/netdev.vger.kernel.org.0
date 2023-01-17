Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3242866DCA3
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236718AbjAQLh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbjAQLgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:36:45 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-mr2fra01on2084.outbound.protection.outlook.com [40.107.9.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98AB2F784;
        Tue, 17 Jan 2023 03:36:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IpMZ5ipvGjFqTgDvPQAmzJn9eYAAd3ZCmHeYjbgpdOvSAGbSwwvaqxnyef+1617kIuuCCso0Svp7onHBirpPKqvH2wTlQ5q3cnr7aD76UokXxheGYfP41O9D6A0K39wWHAJMf58NCrEsBiQkizQ0656GYqS9/0qluDl5/n1fQ22jPXTMQZopY38ITLEvVM7qbSC94xP9wqQi4e6tqjHJPY0DsKPhLgVU581aQgE9LdLn3M0rZKtSp31ddjp1NZ+MwbwTBMsQs0DFKr10CZRMHN+C8gISYoMoHBpL8B5Lup+3quD+uk/bLpfw+xc/6t2Lchzbyq3TZqMjDGoO0l58Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/JpQbaD10uOBuEt6h8sdCLZVpzuenfNBPbHMN0y1fA=;
 b=kkZZmSZu8mk5qiigeNlWAJWrWjGL+2gvp6Cas6m7OoSa3sUJH2Ci846tvrDWZITFXWRZgoaiut2GujOfbGFsECA/X01FThL2UEZGeADb/4vU/ABsQHlEcw+bHIKyY3LlWoGQuvq9clL0bxPeGWrFJ1bPtsayK1Gweu7k/Z71rWILNkBvVHpQ82vIBk05RG5Dwy+df+83kDTOXA+C36KV9JLn6ZW6yeQj1oPDFca45drQIvjzTqi9M5TK+FO+HWRNGZAYncyzP4PxO/nS84DRTKSKawBhek/5hno1uaK0AhT1420o6kF8rlXGjUfQb4vP5KjfD0SxnAbN354IjZWo9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/JpQbaD10uOBuEt6h8sdCLZVpzuenfNBPbHMN0y1fA=;
 b=fG1GtVtXQmzD+b5l88l5vEHpyh/DdC8NOGuzobwUnHziCqa1aAXV7+zL3QYhAqGrs/zQpwtOFFP05JgbtK/jfOFNSpuzXh/N2+6AzdZYVVEm5zg1Ay+y8QjBIipK8TOY6HWM6mRt3tigcs2VcmYSht7Mi49zxAq40mfOFIu5PMOxdFnof6C6ZfFinX9VMmduG8jo3sTGb5L9sk0O4UTW8CAs3yTHjtsPB8DhrvW8h7FeoZCT6BywT1nUXzgLitZZ/1OjpnH2gIECHxq0LDB6nqZsLqpv7V/wwkV/w5UfpC3jwv7xynvTZCfmu3TqYZ3LQ13LxUOjjB4nSHiNq2gb6Q==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB2341.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1e0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Tue, 17 Jan
 2023 11:36:10 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097%9]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 11:36:10 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Tonghao Zhang <tong@infragraf.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.or" 
        <linux-arm-kernel@lists.infradead.or>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>,
        Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Jiri Olsa <jolsa@kernel.org>, Hou Tao <houtao1@huawei.com>,
        KP Singh <kpsingh@kernel.org>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        "naveen.n.rao@linux.ibm.com" <naveen.n.rao@linux.ibm.com>,
        "mpe@ellerman.id.au" <mpe@ellerman.id.au>
Subject: Re: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
Thread-Topic: [bpf-next v2] bpf: drop deprecated bpf_jit_enable == 2
Thread-Index: AQHZILjtdiBl24vDM0uhRRtlAlrCCa6QG7gAgAFsaoCABDtogIAMZLqAgAAhWICAAES8AA==
Date:   Tue, 17 Jan 2023 11:36:10 +0000
Message-ID: <0792068b-9aff-d658-5c7d-086e6d394c6c@csgroup.eu>
References: <20230105030614.26842-1-tong@infragraf.org>
 <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
 <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net>
 <5836b464-290e-203f-00f2-fc6632c9f570@csgroup.eu>
 <147A796D-12C0-482F-B48A-16E67120622B@infragraf.org>
 <0b46b813-05f2-5083-9f2e-82d72970dae2@csgroup.eu>
In-Reply-To: <0b46b813-05f2-5083-9f2e-82d72970dae2@csgroup.eu>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR0P264MB2341:EE_
x-ms-office365-filtering-correlation-id: f917256a-df55-47d3-8d6d-08daf87f0812
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XFWK3NAyOHUkNMRy9fSh8FTwgx6elytrKbOsVQvbg+gkj+5bzUE4OnVavscr31L7saJC7mxX++Q9n736f6ZxsEDlJ8NtPM/bVZWOj79HMlv+4Fk2wUCHmxJO5Bcy7uNIRIA4XSsRSYa7Yv96+c7RKAixx6ytVq4+WtdnuO8zXs+P4lAhMOQ8nVpphZhXovaeqFWpqKk5FyZWHXtKk9x/S0kPmSSyludEKiM0HpElqrTkFR8qhIGwmaPoXKgEHZZBOqvUsMKqnFKx/G7KvR93HBNLfmqDEB4n9UQMECUNavwhPpE9bCtRnOSs+tN0GVaeaLzNPgW5PjMGFDWA/q5NiVvSP4v6xfWl2UR5FKBVDeBnvnimI7mBx6wVF/zA8WVdJYjnfsXpD40D/3E22qLxj38UwtDrOTD6B8cR45N3YP6r00VscigNbZoS+WkmDz/MJ0PW9uFvVgVfX4ZE4uykmWkwM2qQ4zTuVPPBgc5GuQmwaNZLXMfHYFkrNHuIRMfdBetKJY71Nooo7uo+DqKVH0lz/XiVwo+EQEnGDYZBk4nouZpDEBUp76cdtX8paUHFEXyiFXC8+sISjLJPISsocJg/Kk1r4o9zrNAvhPd4QZeaSZ2IiY+6niFAVMB3YfDPh+oeCjh8wK4ySbycjqzwIRn0XY98d6aO9bUQFfa/XAEb2zlxwGNixOepPpvEq8HJcUSrYH1RQ0hAXO+P5KRoi/Gp9U5zGPyAgqo/+Jg0V9cYEdUSQnEBMB14GKZcq1PTd2hmP92dSilEwCYxbgsuLZzuvGyeJXacmSKyFQkWjF4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(39850400004)(366004)(346002)(451199015)(38100700002)(31696002)(5660300002)(86362001)(36756003)(38070700005)(122000001)(91956017)(53546011)(71200400001)(2616005)(6512007)(110136005)(6486002)(31686004)(966005)(26005)(478600001)(76116006)(316002)(2906002)(7416002)(83380400001)(54906003)(186003)(66946007)(6506007)(8936002)(44832011)(4326008)(66574015)(66476007)(66556008)(41300700001)(8676002)(64756008)(66446008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QThwNHBYMlNzZlRpN0hGTSt3Vk41cVZLUzkzQ0ZTdURKcG9OaE1lR01JeFF1?=
 =?utf-8?B?MDhFVDFVb1ZRU0JpSHpNTWs5WUJiQlNjTkdKNURJVWlxbWo1RUFtZHZaYytx?=
 =?utf-8?B?NytHOVFjVXZ1aDJWajJmUis5ZW85aXRMMERIZUsrMmpJZXpVOHBQOUxkMmJB?=
 =?utf-8?B?YUFnbW9BU0RYZWlGWnNZc3VBcUVKcndtbXllZHlmZHc2akFBemV4RUhUQmsv?=
 =?utf-8?B?bVFpcVgzZ0FGV0NRODgxZWYzWkVYT0JPZjgvaElHeUFuYzNva1Uyc1h6TW1Z?=
 =?utf-8?B?Vmp2eDkvemNKeTkwamtORmJaQVM1ODFKbXdBdS9TRVBtTEpMOTJ0djkwdUxE?=
 =?utf-8?B?VTdJQXNzSmg3N2hHd2VBby9GcmNCU2JQTm5GbDVacWt6Tnl4UE1NOWVHREsv?=
 =?utf-8?B?Y0JSUTZEWU5ERDkwRVUvNUIyTmZxMDV2Z3p5Y2JValMyM01PVGxRajdaZ2hk?=
 =?utf-8?B?eTkrWlBmSEtIM2tENHVJV2luR3JhQ2tsUXJpbmxWaGo0eEo3WkxiYjdwV0My?=
 =?utf-8?B?V0tHdU15MXVIRVMrQjlVaXRsVG1ZdWd0cUMzYzdFZC9veU1DODBSZWNvaTFM?=
 =?utf-8?B?MWw4Wm5mczc4UlBvejNjSkxqTkdnajYxMmd0TlJSK2ZSa1liTUlNVGVYY0ZU?=
 =?utf-8?B?ZEh0S1FHWnJWcXRlMFJ1dUlrWEtIeXZOQWhaV3RZZVdUZ21VVWdFU0FkVkhT?=
 =?utf-8?B?Y0g4Y0o2Z1EwVlV4Qmx4N3NIS0tYNEY0eXJEaXI4aGxlT0wzSWhhRm5SNWtz?=
 =?utf-8?B?R1RPUzVqZ0RnNVJoYlI1Vy8zYm5zSjUrYnVKNDFORWdIN1JPdlNhN0ZZWmVu?=
 =?utf-8?B?TnhteEtFZ2twRW9mdkRmYVBXQWtWTHZZbWN3N2FVS29tRDVQU3FaOWRSYjQ5?=
 =?utf-8?B?Tmc2UUlJaU12MUE1SHlDSU00dG5TUkpzLzhqR0w0TjY0ZEhqTXU1aHdxckhv?=
 =?utf-8?B?V244NEJiU3ZuSlcvbks5MXlDcS94TUxsWWN2RHZlSWlaTXJGRWpYRUVFTERC?=
 =?utf-8?B?c3Uzd09jU2hzOWV4dmZKUTY0ZzJDQ3BTbmEzdjNDRW5kT0F4ams0OXlobGIv?=
 =?utf-8?B?cUVueWpMMTEzNTFrZUEwVWc3dUc1UisrQVUvNzJJdEtmbU5CTGpjcmV0djk0?=
 =?utf-8?B?WG5vRGg0bVF1U2I5bS9UK2xRNms0SFJKUkRBUCtzRDRuWlJHLzh4YVRwQUpx?=
 =?utf-8?B?N3JXa1o2bHRYZGU4NmUyK2xkK3FHWFJzem5tVVVZNWh2MmhqZkJwQkcxSWJU?=
 =?utf-8?B?eXhSMzIxeFE3enBqd3BmWDhLMkNRM0pmNlBkNkFuUmVyYVErQVQvVGZzRTU0?=
 =?utf-8?B?YXNXRGtPeGgxRkpoMGJxZ0M3Y2ZKMFNuQlIza2VZQ3JzVmlNZXYvc3ZlMFVo?=
 =?utf-8?B?NXhrMUF5RE5SU0l0WEhQUk5rSFhvTlFudXE3NDg0d2RrMEJSTFgwOG5WaGZL?=
 =?utf-8?B?YnB4WmlqdSt5V29EMEtIc09XM2daR1NXNy8rWW9xVXNQN2JBeXNhOHU1T3JD?=
 =?utf-8?B?S0xyM1hjTUJyYXhueGFFSlRVamxZSGNtdXNQOWFWczQ2OUpnUTZoWFl0c1Bv?=
 =?utf-8?B?QzFXWmtNUzZaNytpSzZoWXdGMFkzTWNKWUZMOGt2RjR5eWpsVmFBcE55K3pJ?=
 =?utf-8?B?czVVbFJHWklFYUJHaFFiM2tYWW0vMjBrWFNkelpzclVyVVlZdWtpczFrWGkz?=
 =?utf-8?B?TExuNGxFNjhOZHNsb09sVkJqcmlGMG41VyswVTFhQThpOWVuZ3pPa1hNTnpR?=
 =?utf-8?B?eS9NQnR3YllwdWI0TWw2SlhSb2Nvd3pibENlbVNxMjlYbGJLaGwwT3I4RHMw?=
 =?utf-8?B?SVlVNWU1MGZ3TlRNNmFqMnlmV2YwcFlWN1Z0ZmFRUG42OTNPdGQvRGNMZ1pF?=
 =?utf-8?B?bjZ0NDdhYjRyZjhwMW1yeUNDV2lMM0VkTktYRTFwbmwzY3g5U1dYK2FOMDZD?=
 =?utf-8?B?aFA0ZXQwdG5UNzQxZXUrd3BlKzc1a2JwTjI1OGpodmFzSy9pVUF5aHNGM003?=
 =?utf-8?B?cGRicEhhcGpoZzNFS3pLUnk2ZG5jeEJjVXNMWDMycENzYytBNG5Ea3dsS0pX?=
 =?utf-8?B?aXRzL1JCNUZqVWZHQURZL0FLbDFSMlBZdEJpU292WmEyRk5FMytub1VyOERP?=
 =?utf-8?B?ZFRGNzBkMXhpZ2xRalFrZ3daZEJKVjYvRGZ5Kzl1L3FVZmJPYXVkVDVMN014?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE1F30BF1F878F4CA61B2BA4DF82EE53@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f917256a-df55-47d3-8d6d-08daf87f0812
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 11:36:10.5689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KT/zffu89pLugbdeXERPdcK4R1Zqw123bkU2GcJ76YbMQDQXrOtAQYP/CaQ2+g6WKxb3sWg/I2gjYUFALlD3BFh2EzT+uFDS5nzYutjr+R0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB2341
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDE3LzAxLzIwMjMgw6AgMDg6MzAsIENocmlzdG9waGUgTGVyb3kgYSDDqWNyaXTCoDoN
Cj4gDQo+IA0KPiBMZSAxNy8wMS8yMDIzIMOgIDA2OjMwLCBUb25naGFvIFpoYW5nIGEgw6ljcml0
wqA6DQo+Pg0KPj4NCj4+PiBPbiBKYW4gOSwgMjAyMywgYXQgNDoxNSBQTSwgQ2hyaXN0b3BoZSBM
ZXJveSANCj4+PiA8Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1PiB3cm90ZToNCj4+Pg0KPj4+
DQo+Pj4NCj4+PiBMZSAwNi8wMS8yMDIzIMOgIDE2OjM3LCBEYW5pZWwgQm9ya21hbm4gYSDDqWNy
aXQgOg0KPj4+PiBPbiAxLzUvMjMgNjo1MyBQTSwgQ2hyaXN0b3BoZSBMZXJveSB3cm90ZToNCj4+
Pj4+IExlIDA1LzAxLzIwMjMgw6AgMDQ6MDYsIHRvbmdAaW5mcmFncmFmLm9yZyBhIMOpY3JpdCA6
DQo+Pj4+Pj4gRnJvbTogVG9uZ2hhbyBaaGFuZyA8dG9uZ0BpbmZyYWdyYWYub3JnPg0KPj4+Pj4+
DQo+Pj4+Pj4gVGhlIHg4Nl82NCBjYW4ndCBkdW1wIHRoZSB2YWxpZCBpbnNuIGluIHRoaXMgd2F5
LiBBIHRlc3QgQlBGIHByb2cNCj4+Pj4+PiB3aGljaCBpbmNsdWRlIHN1YnByb2c6DQo+Pj4+Pj4N
Cj4+Pj4+PiAkIGxsdm0tb2JqZHVtcCAtZCBzdWJwcm9nLm8NCj4+Pj4+PiBEaXNhc3NlbWJseSBv
ZiBzZWN0aW9uIC50ZXh0Og0KPj4+Pj4+IDAwMDAwMDAwMDAwMDAwMDAgPHN1YnByb2c+Og0KPj4+
Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCAwOsKgwqDCoMKgwqDCoCAxOCAwMSAwMCAwMCA3MyA3NSA2
MiA3MCAwMCAwMCAwMCAwMCA3MiA2ZiA2NyAwMCByMQ0KPj4+Pj4+ID0gMjkxMTQ0NTk5MDM2NTMy
MzUgbGwNCj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKgwqAgMjrCoMKgwqDCoMKgwqAgN2IgMWEgZjgg
ZmYgMDAgMDAgMDAgMDAgKih1NjQgKikocjEwIC0gOCkgPSByMQ0KPj4+Pj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCAzOsKgwqDCoMKgwqDCoCBiZiBhMSAwMCAwMCAwMCAwMCAwMCAwMCByMSA9IHIxMA0K
Pj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCA0OsKgwqDCoMKgwqDCoCAwNyAwMSAwMCAwMCBmOCBm
ZiBmZiBmZiByMSArPSAtOA0KPj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCA1OsKgwqDCoMKgwqDC
oCBiNyAwMiAwMCAwMCAwOCAwMCAwMCAwMCByMiA9IDgNCj4+Pj4+PiDCoMKgwqDCoMKgwqDCoMKg
wqAgNjrCoMKgwqDCoMKgwqAgODUgMDAgMDAgMDAgMDYgMDAgMDAgMDAgY2FsbCA2DQo+Pj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgIDc6wqDCoMKgwqDCoMKgIDk1IDAwIDAwIDAwIDAwIDAwIDAwIDAw
IGV4aXQNCj4+Pj4+PiBEaXNhc3NlbWJseSBvZiBzZWN0aW9uIHJhd190cC9zeXNfZW50ZXI6DQo+
Pj4+Pj4gMDAwMDAwMDAwMDAwMDAwMCA8ZW50cnk+Og0KPj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCAwOsKgwqDCoMKgwqDCoCA4NSAxMCAwMCAwMCBmZiBmZiBmZiBmZiBjYWxsIC0xDQo+Pj4+Pj4g
wqDCoMKgwqDCoMKgwqDCoMKgIDE6wqDCoMKgwqDCoMKgIGI3IDAwIDAwIDAwIDAwIDAwIDAwIDAw
IHIwID0gMA0KPj4+Pj4+IMKgwqDCoMKgwqDCoMKgwqDCoCAyOsKgwqDCoMKgwqDCoCA5NSAwMCAw
MCAwMCAwMCAwMCAwMCAwMCBleGl0DQo+Pj4+Pj4NCj4+Pj4+PiBrZXJuZWwgcHJpbnQgbWVzc2Fn
ZToNCj4+Pj4+PiBbwqAgNTgwLjc3NTM4N10gZmxlbj04IHByb2dsZW49NTEgcGFzcz0zIGltYWdl
PWZmZmZmZmZmYTAwMGMyMGMNCj4+Pj4+PiBmcm9tPWtwcm9iZS1sb2FkIHBpZD0xNjQzDQo+Pj4+
Pj4gW8KgIDU4MC43NzcyMzZdIEpJVCBjb2RlOiAwMDAwMDAwMDogY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MNCj4+Pj4+PiBjYyBjYyBjYyBjYyBjYw0KPj4+Pj4+IFvCoCA1ODAuNzc5
MDM3XSBKSVQgY29kZTogMDAwMDAwMTA6IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNj
DQo+Pj4+Pj4gY2MgY2MgY2MgY2MgY2MNCj4+Pj4+PiBbwqAgNTgwLjc4MDc2N10gSklUIGNvZGU6
IDAwMDAwMDIwOiBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYw0KPj4+Pj4+IGNjIGNj
IGNjIGNjIGNjDQo+Pj4+Pj4gW8KgIDU4MC43ODI1NjhdIEpJVCBjb2RlOiAwMDAwMDAzMDogY2Mg
Y2MgY2MNCj4+Pj4+Pg0KPj4+Pj4+ICQgYnBmX2ppdF9kaXNhc20NCj4+Pj4+PiA1MSBieXRlcyBl
bWl0dGVkIGZyb20gSklUIGNvbXBpbGVyIChwYXNzOjMsIGZsZW46OCkNCj4+Pj4+PiBmZmZmZmZm
ZmEwMDBjMjBjICsgPHg+Og0KPj4+Pj4+IMKgwqDCoMKgwqAgMDrCoMKgIGludDMNCj4+Pj4+PiDC
oMKgwqDCoMKgIDE6wqDCoCBpbnQzDQo+Pj4+Pj4gwqDCoMKgwqDCoCAyOsKgwqAgaW50Mw0KPj4+
Pj4+IMKgwqDCoMKgwqAgMzrCoMKgIGludDMNCj4+Pj4+PiDCoMKgwqDCoMKgIDQ6wqDCoCBpbnQz
DQo+Pj4+Pj4gwqDCoMKgwqDCoCA1OsKgwqAgaW50Mw0KPj4+Pj4+IMKgwqDCoMKgwqAgLi4uDQo+
Pj4+Pj4NCj4+Pj4+PiBVbnRpbCBicGZfaml0X2JpbmFyeV9wYWNrX2ZpbmFsaXplIGlzIGludm9r
ZWQsIHdlIGNvcHkgcndfaGVhZGVyIHRvDQo+Pj4+Pj4gaGVhZGVyDQo+Pj4+Pj4gYW5kIHRoZW4g
aW1hZ2UvaW5zbiBpcyB2YWxpZC4gQlRXLCB3ZSBjYW4gdXNlIHRoZSAiYnBmdG9vbCBwcm9nIGR1
bXAiDQo+Pj4+Pj4gSklUZWQgaW5zdHJ1Y3Rpb25zLg0KPj4+Pj4NCj4+Pj4+IE5BQ0suDQo+Pj4+
Pg0KPj4+Pj4gQmVjYXVzZSB0aGUgZmVhdHVyZSBpcyBidWdneSBvbiB4ODZfNjQsIHlvdSByZW1v
dmUgaXQgZm9yIGFsbA0KPj4+Pj4gYXJjaGl0ZWN0dXJlcyA/DQo+Pj4+Pg0KPj4+Pj4gT24gcG93
ZXJwYyBicGZfaml0X2VuYWJsZSA9PSAyIHdvcmtzIGFuZCBpcyB2ZXJ5IHVzZWZ1bGwuDQo+Pj4+
Pg0KPj4+Pj4gTGFzdCB0aW1lIEkgdHJpZWQgdG8gdXNlIGJwZnRvb2wgb24gcG93ZXJwYy8zMiBp
dCBkaWRuJ3Qgd29yay4gSSBkb24ndA0KPj4+Pj4gcmVtZW1iZXIgdGhlIGRldGFpbHMsIEkgdGhp
bmsgaXQgd2FzIGFuIGlzc3VlIHdpdGggZW5kaWFuZXNzLiBNYXliZSBpdA0KPj4+Pj4gaXMgZml4
ZWQgbm93LCBidXQgaXQgbmVlZHMgdG8gYmUgdmVyaWZpZWQuDQo+Pj4+Pg0KPj4+Pj4gU28gcGxl
YXNlLCBiZWZvcmUgcmVtb3ZpbmcgYSB3b3JraW5nIGFuZCB1c2VmdWxsIGZlYXR1cmUsIG1ha2Ug
c3VyZQ0KPj4+Pj4gdGhlcmUgaXMgYW4gYWx0ZXJuYXRpdmUgYXZhaWxhYmxlIHRvIGl0IGZvciBh
bGwgYXJjaGl0ZWN0dXJlcyBpbiBhbGwNCj4+Pj4+IGNvbmZpZ3VyYXRpb25zLg0KPj4+Pj4NCj4+
Pj4+IEFsc28sIEkgZG9uJ3QgdGhpbmsgYnBmdG9vbCBpcyB1c2FibGUgdG8gZHVtcCBrZXJuZWwg
QlBGIHNlbGZ0ZXN0cy4NCj4+Pj4+IFRoYXQncyB2aXRhbCB3aGVuIGEgc2VsZnRlc3QgZmFpbHMg
aWYgeW91IHdhbnQgdG8gaGF2ZSBhIGNoYW5jZSB0bw0KPj4+Pj4gdW5kZXJzdGFuZCB3aHkgaXQg
ZmFpbHMuDQo+Pj4+DQo+Pj4+IElmIHRoaXMgaXMgYWN0aXZlbHkgdXNlZCBieSBKSVQgZGV2ZWxv
cGVycyBhbmQgY29uc2lkZXJlZCB1c2VmdWwsIA0KPj4+PiBJJ2QgYmUNCj4+Pj4gb2sgdG8gbGVh
dmUgaXQgZm9yIHRoZSB0aW1lIGJlaW5nLiBPdmVyYWxsIGdvYWwgaXMgdG8gcmVhY2ggZmVhdHVy
ZSANCj4+Pj4gcGFyaXR5DQo+Pj4+IGFtb25nIChhdCBsZWFzdCBtYWpvciBhcmNoKSBKSVRzIGFu
ZCBub3QganVzdCBoYXZlIG1vc3QgDQo+Pj4+IGZ1bmN0aW9uYWxpdHkgb25seQ0KPj4+PiBhdmFp
bGFibGUgb24geDg2LTY0IEpJVC4gQ291bGQgeW91IGhvd2V2ZXIgY2hlY2sgd2hhdCBpcyBub3Qg
d29ya2luZyANCj4+Pj4gd2l0aA0KPj4+PiBicGZ0b29sIG9uIHBvd2VycGMvMzI/IFBlcmhhcHMg
aXQncyBub3QgdG9vIG11Y2ggZWZmb3J0IHRvIGp1c3QgZml4IGl0LA0KPj4+PiBidXQgZGV0YWls
cyB3b3VsZCBiZSB1c2VmdWwgb3RoZXJ3aXNlICdpdCBkaWRuJ3Qgd29yaycgaXMgdG9vIGZ1enp5
Lg0KPj4+DQo+Pj4gU3VyZSBJIHdpbGwgdHJ5IHRvIHRlc3QgYnBmdG9vbCBhZ2FpbiBpbiB0aGUg
Y29taW5nIGRheXMuDQo+Pj4NCj4+PiBQcmV2aW91cyBkaXNjdXNzaW9uIGFib3V0IHRoYXQgc3Vi
amVjdCBpcyBoZXJlOg0KPj4+IGh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9s
aW51eC1yaXNjdi9wYXRjaC8yMDIxMDQxNTA5MzI1MC4zMzkxMjU3LTEtSmlhbmxpbi5MdkBhcm0u
Y29tLyMyNDE3Njg0Nz0NCj4+IEhpIENocmlzdG9waGUNCj4+IEFueSBwcm9ncmVzcz8gV2UgZGlz
Y3VzcyB0byBkZXByZWNhdGUgdGhlIGJwZl9qaXRfZW5hYmxlID09IDIgaW4gMjAyMSwgDQo+PiBi
dXQgYnBmdG9vbCBjYW4gbm90IHJ1biBvbiBwb3dlcnBjLg0KPj4gTm93IGNhbiB3ZSBmaXggdGhp
cyBpc3N1ZT8NCj4gDQo+IEhpIFRvbmcsDQo+IA0KPiBJIGhhdmUgc3RhcnRlZCB0byBsb29rIGF0
IGl0IGJ1dCBJIGRvbid0IGhhdmUgYW55IGZydWl0ZnVsbCBmZWVkYmFjayB5ZXQuDQoNCkhpIEFn
YWluLA0KDQpJIHRlc3RlZCBhZ2FpbiwgdGhlIHByb2JsZW0gaXMgc3RpbGwgdGhlIHNhbWUgYXMg
b25lIHllYXIgYWdvOg0KDQpyb290QHZnb2lwOn4jIC4vYnBmdG9vbCBwcm9nDQpsaWJicGY6IGVs
ZjogZW5kaWFubmVzcyBtaXNtYXRjaCBpbiBwaWRfaXRlcl9icGYuDQpsaWJicGY6IGZhaWxlZCB0
byBpbml0aWFsaXplIHNrZWxldG9uIEJQRiBvYmplY3QgJ3BpZF9pdGVyX2JwZic6IC00MDAzDQpF
cnJvcjogZmFpbGVkIHRvIG9wZW4gUElEIGl0ZXJhdG9yIHNrZWxldG9uDQoNCnJvb3RAdmdvaXA6
fiMgdW5hbWUgLWENCkxpbnV4IHZnb2lwIDYuMi4wLXJjMy0wMjU5Ni1nMWMyYzljMTNlMjU2ICMy
NDIgUFJFRU1QVCBUdWUgSmFuIDE3IA0KMDk6MzY6MDggQ0VUIDIwMjMgcHBjIEdOVS9MaW51eA0K
DQoNCj4gDQo+IEluIHRoZSBtZWFudGltZSwgd2VyZSB5b3UgYWJsZSB0byBjb25maXJtIHRoYXQg
YnBmdG9vbCBjYW4gYWxzbyBiZSB1c2VkIA0KPiB0byBkdW1wIGppdHRlZCB0ZXN0cyBmcm9tIHRl
c3RfYnBmLmtvIG1vZHVsZSBvbiB4ODZfNjQgPyBJbiB0aGF0IGNhbiB5b3UgDQo+IHRlbGwgbWUg
aG93IHRvIHByb2NlZWQgPw0KPiANCj4gVGhhbmtzDQo+IENocmlzdG9waGUNCj4gDQoNCg0KQ2hy
aXN0b3BoZQ0K
