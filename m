Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7266715CA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjARIDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjARIBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:01:16 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-mr2fra01on2044.outbound.protection.outlook.com [40.107.9.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734AA5D90F;
        Tue, 17 Jan 2023 23:36:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbqRLcQBx5Kft9WR0EcpVFS2WT5O0PWKT5gnOiYJeG0C58OsaMrvsMwXJAKo3nNUsrkVH2tmAadIe8jDGMgww0rfYsg55SAwDRq1efNORWo493xU/a0z1M0k4sTiGOf3RyF6qBu/eA1SdUEKnThKgw91xmRcyL9ET1zojlE7XuRUb3Nc3SghJ1Z8vfp3KDUMbwztqritYrTnLSPTQnue+p8PJifvT0BQhC4XbFcHUzaxa7uZlVKh3Q9YVz9VxHthZbv1wBsK3cqPenTprAJ0R1001xt+4xBwKlOpWYa+IwoWfs/Gd1IEb7/H0oCb1PWEenlrXTCBZk5sEFPYI/Ct6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7RLqYLYpu8XmJjVR4x85rAS3xBdQydgx6qQopFeb1U=;
 b=oE2NG0diqpddFy0aeROuQ9MMMw9TALL+UNj2xrt6l+HFiXTFA9LlcPPvdr+DJp/wTa4EuMjx+hOveANyrnTIgxpqV/M1Xsp/q98rgDq4OzkUq6FR4PiduNEHhecexL3pC96bu3GitOVfMbNKoP2gi3V+VCk5HGgs83LU0FHp6J2g04jeGATprrZmnYUtz+f9E846AGbUjJvKAFILlf0+IAWszckcfRZQKvV2cjEmWzUtdGpslCnFcs2xMn+UCdQdU4WXeZScOuEv+RlQERR+EaA4XtrnqokONVDlCQTwgNE/8XtbNSPTnq3BdAD1JWUJ00S/n7UNK48DFZxGpiNntA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7RLqYLYpu8XmJjVR4x85rAS3xBdQydgx6qQopFeb1U=;
 b=t2f/5fQwRZ6dGsAc6srMjWXi8lt0oEIQOjsUZjNIlPuBcfXEJWr+CL8ds+bAEUgeh+zQnexM36RJI7jO+LstaL9XScHuoDSJfv7l4+eecRP8L3WsKvG+f95tbAcYxGYqdmrgzLBhxmVsteHSDwH16ryMkZnuO5yycd5Do9iXl2Ev46gcjZ0YwPTrtOo0h3h/Kq8oKze1LiZVQYxY37PeFd8d3hI37DvknozplXUTxy7wOQAST7PtwQIRA/Ki+Oq2bt13vCl1gSDRcIiPkUf4f8JxXIJNE4YQuyCuirx9p57h0VVGgA4PbvJz7tYgcTPq9sOOihBD/uxLuJLIRbxryA==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB2108.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:168::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 18 Jan
 2023 07:35:57 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097%9]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 07:35:57 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Tonghao Zhang <tong@infragraf.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
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
Thread-Index: AQHZILjtdiBl24vDM0uhRRtlAlrCCa6QG7gAgAFsaoCABDtogIAMZLqAgAAhWICAAHMhgIAAGywAgACreICAAAJmAIAAV8iA
Date:   Wed, 18 Jan 2023 07:35:57 +0000
Message-ID: <d807b7fb-dbd2-8e4c-812c-48a1a01c190e@csgroup.eu>
References: <20230105030614.26842-1-tong@infragraf.org>
 <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
 <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net>
 <5836b464-290e-203f-00f2-fc6632c9f570@csgroup.eu>
 <147A796D-12C0-482F-B48A-16E67120622B@infragraf.org>
 <0b46b813-05f2-5083-9f2e-82d72970dae2@csgroup.eu>
 <4380D454-3ED0-43F4-9A79-102BB0E3577A@infragraf.org>
 <d91bbb9e-484b-d43d-e62d-0474ff21cf91@iogearbox.net>
 <7159E8F8-AE66-4563-8A29-D10D66EFAF3D@infragraf.org>
 <CAADnVQLf_UhRP76i9+OaLGrmuoM942QebMXT3OA3mgrP_UV0KA@mail.gmail.com>
In-Reply-To: <CAADnVQLf_UhRP76i9+OaLGrmuoM942QebMXT3OA3mgrP_UV0KA@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR0P264MB2108:EE_
x-ms-office365-filtering-correlation-id: 99c1c3f4-57bf-4140-7839-08daf926a3b4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a08frPSbV3M5oK1duUikx4fD8/sHCBrjprVxxt7kf8yavzW9uLr3e5NrvruZFHlpbe1LaVlA6T49rsFGW81bGqDEy0ri/g28pvB8VZtiH3puAm9H9Q9PQPdOnpf5STF/7P5LgUP/CIdVx3H8p7VxNDTL4h7Vd13FxzGya9nHzYQCyzhPDDbTlMIw9e5Y/icfgPyYq6OIETCzZ9hIE0kPZUI1aCgxYwCNjw5TLINdiBL5KluW4Q2Yh0LXCKmnJ1nGCOCNR3Fr/0383VZhifiAQj9kG0IDqmJ3Zk+SOLKkONjSuvzN83bq31qMO77Jg/ooB2l2p9mkgEC6kJsykONfzXma8UUmo8iPb2+gErJWH/79h9KANKPNRsnolN2l8YSOcwOQg1dddaLlGeUYnMvi6a4SRjjBoAzPPzCMOslSf6PUW3zjmG+Lhh8iCAuDVa5j05oKPg/fPPp/Wd59w3dSzVGysPZW5MUHo3RPpfSs9ZXq7TSsXx8txLBnfBtS3qP/s9CTdXSxdcBPnUtML4wrb5mCUlYkT0jMGHURYbCGkKA9HsXeWLMoo36doqexZOozogipZW3aL5T8NHGx2ebkvjvKGRSOryemfLxs5tVHr1GWi3tDdmduuKR3CBNWitUT0WcKeNxu+mPTJS5fwjkSXpnjMCD5QAxON51PD6oXnoFkDSJ1F+wzE21zHLJ5XlFcmGjzhxm43vV1ElrzbTyNrsEHjGHzGoB332XinFMKWUwSQRB2o6ErdOiI967JPZ/oMFAlWZtYSaHYV8cPfx2AnR8P7egAeVB0IE5vZThOUJM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(136003)(396003)(39850400004)(346002)(451199015)(26005)(478600001)(66574015)(6486002)(966005)(38070700005)(41300700001)(66446008)(6512007)(38100700002)(66556008)(71200400001)(186003)(31696002)(316002)(110136005)(54906003)(2616005)(86362001)(66946007)(66476007)(76116006)(53546011)(4326008)(5660300002)(36756003)(7416002)(6506007)(2906002)(31686004)(83380400001)(44832011)(91956017)(64756008)(8936002)(8676002)(122000001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aktPLzJ4V0pVWVplVzhXQXUwSVBkUzZmZmJqTzZBTEtldzhUcTNjYlVKRzB2?=
 =?utf-8?B?QnJpMDVzWDl3eXR6Mm00OFlvYy9nWjUwK1RMbzRNeDAyeGhKTUM4bnZUZjBn?=
 =?utf-8?B?bEh3ek9CdTk1UFVzMm9zSGF5Q28xdHR0bmo1KzF5dU5Yd0RFcVYvSjlYK3g0?=
 =?utf-8?B?Uk0wVEJJSEpXam53M0hlRUxIY0h3RVR5eE9vUUxyVGhrVHZRWmFmTStyRzhG?=
 =?utf-8?B?QTVSMk12Mk9PdDhXbWhVTEp1MER4bWVUdzgrbTk4TkQ3bVRaY3ZvZXR2cVUy?=
 =?utf-8?B?OCtGUVBPMmFHZk43TkUzUFU3cmdMNEZoV3pzano5bVE1dWFCVHlscmdVL3Z6?=
 =?utf-8?B?MkpCVm56VnpTaVYzTDI0c3lQTXlJa0FJQzBuUW9MQVBRWjhJUHN6MERydUdy?=
 =?utf-8?B?RFNzUHBNMEV2VXdsOW9TcUNqWXpPL29RMnA2bUFFazExZUM3T3ltMzVtdjlN?=
 =?utf-8?B?ZUhDbjVwM0dSVlJQWW9BMDBvMXpKQTlocU1VMjk5Tk1jaW9hckNjcmNOazdZ?=
 =?utf-8?B?WGp6QS9sRGdwdzYzd3RIT2l1WHpOejVubmVsZDNrejJaNm44YjdFRkFMcXVY?=
 =?utf-8?B?YmhXSEF2NkFzL2pxUTN5d0d6dktlTFAycEk0K20rZTIzeW1lQS9ValBjMlhO?=
 =?utf-8?B?RU5HUzZTOGlOcUVtSjB5Y2dvNFZUN0lsWlJuSXRpYUxONmh4WWxFUkZGc1Zu?=
 =?utf-8?B?RzhOL2pNa0V1a0I0Uml0RjFHRFR4dEs1eHIyUHdzVlBtWTF1UlhmSXlkZU9B?=
 =?utf-8?B?aDNMRmdOTkU4SEppMzdWLzhQUWdzZGovMHVPWHQ1cFZkSzlXUmphOElmNEpt?=
 =?utf-8?B?R3JkYlRvN1RoMzFFamp2UXhMVElUYTlnYXVKbHdzUUMvc21kb1loSmEzMVFJ?=
 =?utf-8?B?UWdlRTM4S3VkdHZUSHllaUVoQ00xdFlKbkJjVndKampaVUZZLys3dGdxOWtG?=
 =?utf-8?B?TVFBd2tsSGxLZFE3M05LV2FsWjhaMVRVS0w4cXgwajBxUFEra1F4OWwrSkd0?=
 =?utf-8?B?Ky92ZlppQ29IQ3hnZGVnTFpOZjRZRnQ4bnpyVGNpNW9kbHNMRkZTM0lRU0p2?=
 =?utf-8?B?VzVYcG5sWnBBS3h1N3hvU1lBSDRwMW5Wd3FMSTZwVVRPNHZKaGJrK091QVB2?=
 =?utf-8?B?VzNpOGhtR0xpaGVzUkVFQ3dWZUJXNUxGNVFRQzFjbzlLcVRuamk3OWNwcEV0?=
 =?utf-8?B?NVplN3FLeUhLbnp0Q0Z5Y0pxVE9wZEFQQTdBOVhTUkVpeXdJSmRmVWh4WDlV?=
 =?utf-8?B?OXlTMVVyL2VxZnI4MDZFWlFpbzdLalZGNzhZNGdGRUZpZ1dTY2RmTkVJSFlO?=
 =?utf-8?B?dHZ5bGpvL05DdUwrMkgwU2Jmdm1QK2JyTy9zYnBIc0pwVllXRlVRRDJOQWZr?=
 =?utf-8?B?Zm96cUdEZkZGTWZ5UEt3ODhQTTRKVm11eWdaYXNyUFBLM1VyUHhvMEMvVzE1?=
 =?utf-8?B?U2QxNGhvNDNZekZnSjhvSUlCeldCZkphdVpXdHBlZEFBNzBRc0R6cEJ4VURE?=
 =?utf-8?B?cnRaa051ais0dG5yV0NrTDhDbnhvT0tEa3dEKy94L3hvOGJ4RXBBRWtTWTM4?=
 =?utf-8?B?dytXVWRJV2ZqaFV5QzRmT1JGV2V4bGNNR0o5enczbFpCL3B1bmxKUVFucDhn?=
 =?utf-8?B?NXdwWmlCdlF5ZmhOMjd3ME0rSkZBMzBqOUhUYUxDYld6N3RUUXFRODVhdVN5?=
 =?utf-8?B?Y0lNT0RGNzg4T0JWaVVjdkFNUGxNdnRQQmMzTnM5aGZyWXV1NGhxd0RNZmpY?=
 =?utf-8?B?TncwcmVZeSs5VnZXcjBmODRDQ2ZpVW9YWmtFNEtISnZzWXRGU2FVMSt5ZnFN?=
 =?utf-8?B?aUl4SnVuOVoxZHBELzRrMzF1MG9NZVBZSEZtNk1lbkJLU2pqNEQ2emI2NFR6?=
 =?utf-8?B?YXV4NS9QRDFIZ01wenZXUVkwaGxuUDZiK0p1QXZZRm9Od0FnSDNvbEVaeWJj?=
 =?utf-8?B?dFVYNDJXaHNmWm56QzQ5QUIrMjV6UVRnR0tQOWtUU3JBOWRPeDY5TjNKRUFE?=
 =?utf-8?B?U3h6MFFoVlFwbVVvMWNMWDBhKzNQRmlpZjNHMC9mUHVwYU8wTWpoU2ZSS09Y?=
 =?utf-8?B?MVVDcDZ0bytDaTN5KzhTa2FIRWd3aGROUFVhd0w0L3RJaVVCZUJqM3hLbVVw?=
 =?utf-8?B?Si9IeFRyRkZJbXRwTUNnY0M2bFdnVmhvN215L25zUURHaWl2S3JYRys3Y3ox?=
 =?utf-8?B?K1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <921C112B685AEC46A55B4A678D083401@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c1c3f4-57bf-4140-7839-08daf926a3b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 07:35:57.6777
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yetKOV825Ybl742VS0JOtqid9S5XA9TmmzFYDTtDrmJQHNP6mmUsPYNi/uN6DAnRDg0RqpfgRuwJMAjTBGFrkpKhGfrHy32T2T18Gzu4e1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB2108
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDE4LzAxLzIwMjMgw6AgMDM6MjEsIEFsZXhlaSBTdGFyb3ZvaXRvdiBhIMOpY3JpdMKg
Og0KPiBPbiBUdWUsIEphbiAxNywgMjAyMyBhdCA2OjEzIFBNIFRvbmdoYW8gWmhhbmcgPHRvbmdA
aW5mcmFncmFmLm9yZz4gd3JvdGU6DQo+Pg0KPj4NCj4+DQo+Pj4gT24gSmFuIDE3LCAyMDIzLCBh
dCAxMTo1OSBQTSwgRGFuaWVsIEJvcmttYW5uIDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4gd3JvdGU6
DQo+Pj4NCj4+PiBPbiAxLzE3LzIzIDM6MjIgUE0sIFRvbmdoYW8gWmhhbmcgd3JvdGU6DQo+Pj4+
PiBPbiBKYW4gMTcsIDIwMjMsIGF0IDM6MzAgUE0sIENocmlzdG9waGUgTGVyb3kgPGNocmlzdG9w
aGUubGVyb3lAY3Nncm91cC5ldT4gd3JvdGU6DQo+Pj4+Pg0KPj4+Pj4NCj4+Pj4+DQo+Pj4+PiBM
ZSAxNy8wMS8yMDIzIMOgIDA2OjMwLCBUb25naGFvIFpoYW5nIGEgw6ljcml0IDoNCj4+Pj4+Pg0K
Pj4+Pj4+DQo+Pj4+Pj4+IE9uIEphbiA5LCAyMDIzLCBhdCA0OjE1IFBNLCBDaHJpc3RvcGhlIExl
cm95IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+IHdyb3RlOg0KPj4+Pj4+Pg0KPj4+Pj4+
Pg0KPj4+Pj4+Pg0KPj4+Pj4+PiBMZSAwNi8wMS8yMDIzIMOgIDE2OjM3LCBEYW5pZWwgQm9ya21h
bm4gYSDDqWNyaXQgOg0KPj4+Pj4+Pj4gT24gMS81LzIzIDY6NTMgUE0sIENocmlzdG9waGUgTGVy
b3kgd3JvdGU6DQo+Pj4+Pj4+Pj4gTGUgMDUvMDEvMjAyMyDDoCAwNDowNiwgdG9uZ0BpbmZyYWdy
YWYub3JnIGEgw6ljcml0IDoNCj4+Pj4+Pj4+Pj4gRnJvbTogVG9uZ2hhbyBaaGFuZyA8dG9uZ0Bp
bmZyYWdyYWYub3JnPg0KPj4+Pj4+Pj4+Pg0KPj4+Pj4+Pj4+PiBUaGUgeDg2XzY0IGNhbid0IGR1
bXAgdGhlIHZhbGlkIGluc24gaW4gdGhpcyB3YXkuIEEgdGVzdCBCUEYgcHJvZw0KPj4+Pj4+Pj4+
PiB3aGljaCBpbmNsdWRlIHN1YnByb2c6DQo+Pj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4+ICQgbGx2bS1v
YmpkdW1wIC1kIHN1YnByb2cubw0KPj4+Pj4+Pj4+PiBEaXNhc3NlbWJseSBvZiBzZWN0aW9uIC50
ZXh0Og0KPj4+Pj4+Pj4+PiAwMDAwMDAwMDAwMDAwMDAwIDxzdWJwcm9nPjoNCj4+Pj4+Pj4+Pj4g
ICAgICAgICAgIDA6ICAgICAgIDE4IDAxIDAwIDAwIDczIDc1IDYyIDcwIDAwIDAwIDAwIDAwIDcy
IDZmIDY3IDAwIHIxDQo+Pj4+Pj4+Pj4+ID0gMjkxMTQ0NTk5MDM2NTMyMzUgbGwNCj4+Pj4+Pj4+
Pj4gICAgICAgICAgIDI6ICAgICAgIDdiIDFhIGY4IGZmIDAwIDAwIDAwIDAwICoodTY0ICopKHIx
MCAtIDgpID0gcjENCj4+Pj4+Pj4+Pj4gICAgICAgICAgIDM6ICAgICAgIGJmIGExIDAwIDAwIDAw
IDAwIDAwIDAwIHIxID0gcjEwDQo+Pj4+Pj4+Pj4+ICAgICAgICAgICA0OiAgICAgICAwNyAwMSAw
MCAwMCBmOCBmZiBmZiBmZiByMSArPSAtOA0KPj4+Pj4+Pj4+PiAgICAgICAgICAgNTogICAgICAg
YjcgMDIgMDAgMDAgMDggMDAgMDAgMDAgcjIgPSA4DQo+Pj4+Pj4+Pj4+ICAgICAgICAgICA2OiAg
ICAgICA4NSAwMCAwMCAwMCAwNiAwMCAwMCAwMCBjYWxsIDYNCj4+Pj4+Pj4+Pj4gICAgICAgICAg
IDc6ICAgICAgIDk1IDAwIDAwIDAwIDAwIDAwIDAwIDAwIGV4aXQNCj4+Pj4+Pj4+Pj4gRGlzYXNz
ZW1ibHkgb2Ygc2VjdGlvbiByYXdfdHAvc3lzX2VudGVyOg0KPj4+Pj4+Pj4+PiAwMDAwMDAwMDAw
MDAwMDAwIDxlbnRyeT46DQo+Pj4+Pj4+Pj4+ICAgICAgICAgICAwOiAgICAgICA4NSAxMCAwMCAw
MCBmZiBmZiBmZiBmZiBjYWxsIC0xDQo+Pj4+Pj4+Pj4+ICAgICAgICAgICAxOiAgICAgICBiNyAw
MCAwMCAwMCAwMCAwMCAwMCAwMCByMCA9IDANCj4+Pj4+Pj4+Pj4gICAgICAgICAgIDI6ICAgICAg
IDk1IDAwIDAwIDAwIDAwIDAwIDAwIDAwIGV4aXQNCj4+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+Pj4ga2Vy
bmVsIHByaW50IG1lc3NhZ2U6DQo+Pj4+Pj4+Pj4+IFsgIDU4MC43NzUzODddIGZsZW49OCBwcm9n
bGVuPTUxIHBhc3M9MyBpbWFnZT1mZmZmZmZmZmEwMDBjMjBjDQo+Pj4+Pj4+Pj4+IGZyb209a3By
b2JlLWxvYWQgcGlkPTE2NDMNCj4+Pj4+Pj4+Pj4gWyAgNTgwLjc3NzIzNl0gSklUIGNvZGU6IDAw
MDAwMDAwOiBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYw0KPj4+Pj4+Pj4+PiBjYyBj
YyBjYyBjYyBjYw0KPj4+Pj4+Pj4+PiBbICA1ODAuNzc5MDM3XSBKSVQgY29kZTogMDAwMDAwMTA6
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjDQo+Pj4+Pj4+Pj4+IGNjIGNjIGNjIGNj
IGNjDQo+Pj4+Pj4+Pj4+IFsgIDU4MC43ODA3NjddIEpJVCBjb2RlOiAwMDAwMDAyMDogY2MgY2Mg
Y2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MNCj4+Pj4+Pj4+Pj4gY2MgY2MgY2MgY2MgY2MNCj4+
Pj4+Pj4+Pj4gWyAgNTgwLjc4MjU2OF0gSklUIGNvZGU6IDAwMDAwMDMwOiBjYyBjYyBjYw0KPj4+
Pj4+Pj4+Pg0KPj4+Pj4+Pj4+PiAkIGJwZl9qaXRfZGlzYXNtDQo+Pj4+Pj4+Pj4+IDUxIGJ5dGVz
IGVtaXR0ZWQgZnJvbSBKSVQgY29tcGlsZXIgKHBhc3M6MywgZmxlbjo4KQ0KPj4+Pj4+Pj4+PiBm
ZmZmZmZmZmEwMDBjMjBjICsgPHg+Og0KPj4+Pj4+Pj4+PiAgICAgICAwOiAgIGludDMNCj4+Pj4+
Pj4+Pj4gICAgICAgMTogICBpbnQzDQo+Pj4+Pj4+Pj4+ICAgICAgIDI6ICAgaW50Mw0KPj4+Pj4+
Pj4+PiAgICAgICAzOiAgIGludDMNCj4+Pj4+Pj4+Pj4gICAgICAgNDogICBpbnQzDQo+Pj4+Pj4+
Pj4+ICAgICAgIDU6ICAgaW50Mw0KPj4+Pj4+Pj4+PiAgICAgICAuLi4NCj4+Pj4+Pj4+Pj4NCj4+
Pj4+Pj4+Pj4gVW50aWwgYnBmX2ppdF9iaW5hcnlfcGFja19maW5hbGl6ZSBpcyBpbnZva2VkLCB3
ZSBjb3B5IHJ3X2hlYWRlciB0bw0KPj4+Pj4+Pj4+PiBoZWFkZXINCj4+Pj4+Pj4+Pj4gYW5kIHRo
ZW4gaW1hZ2UvaW5zbiBpcyB2YWxpZC4gQlRXLCB3ZSBjYW4gdXNlIHRoZSAiYnBmdG9vbCBwcm9n
IGR1bXAiDQo+Pj4+Pj4+Pj4+IEpJVGVkIGluc3RydWN0aW9ucy4NCj4+Pj4+Pj4+Pg0KPj4+Pj4+
Pj4+IE5BQ0suDQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBCZWNhdXNlIHRoZSBmZWF0dXJlIGlzIGJ1
Z2d5IG9uIHg4Nl82NCwgeW91IHJlbW92ZSBpdCBmb3IgYWxsDQo+Pj4+Pj4+Pj4gYXJjaGl0ZWN0
dXJlcyA/DQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBPbiBwb3dlcnBjIGJwZl9qaXRfZW5hYmxlID09
IDIgd29ya3MgYW5kIGlzIHZlcnkgdXNlZnVsbC4NCj4+Pj4+Pj4+Pg0KPj4+Pj4+Pj4+IExhc3Qg
dGltZSBJIHRyaWVkIHRvIHVzZSBicGZ0b29sIG9uIHBvd2VycGMvMzIgaXQgZGlkbid0IHdvcmsu
IEkgZG9uJ3QNCj4+Pj4+Pj4+PiByZW1lbWJlciB0aGUgZGV0YWlscywgSSB0aGluayBpdCB3YXMg
YW4gaXNzdWUgd2l0aCBlbmRpYW5lc3MuIE1heWJlIGl0DQo+Pj4+Pj4+Pj4gaXMgZml4ZWQgbm93
LCBidXQgaXQgbmVlZHMgdG8gYmUgdmVyaWZpZWQuDQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBTbyBw
bGVhc2UsIGJlZm9yZSByZW1vdmluZyBhIHdvcmtpbmcgYW5kIHVzZWZ1bGwgZmVhdHVyZSwgbWFr
ZSBzdXJlDQo+Pj4+Pj4+Pj4gdGhlcmUgaXMgYW4gYWx0ZXJuYXRpdmUgYXZhaWxhYmxlIHRvIGl0
IGZvciBhbGwgYXJjaGl0ZWN0dXJlcyBpbiBhbGwNCj4+Pj4+Pj4+PiBjb25maWd1cmF0aW9ucy4N
Cj4+Pj4+Pj4+Pg0KPj4+Pj4+Pj4+IEFsc28sIEkgZG9uJ3QgdGhpbmsgYnBmdG9vbCBpcyB1c2Fi
bGUgdG8gZHVtcCBrZXJuZWwgQlBGIHNlbGZ0ZXN0cy4NCj4+Pj4+Pj4+PiBUaGF0J3Mgdml0YWwg
d2hlbiBhIHNlbGZ0ZXN0IGZhaWxzIGlmIHlvdSB3YW50IHRvIGhhdmUgYSBjaGFuY2UgdG8NCj4+
Pj4+Pj4+PiB1bmRlcnN0YW5kIHdoeSBpdCBmYWlscy4NCj4+Pj4+Pj4+DQo+Pj4+Pj4+PiBJZiB0
aGlzIGlzIGFjdGl2ZWx5IHVzZWQgYnkgSklUIGRldmVsb3BlcnMgYW5kIGNvbnNpZGVyZWQgdXNl
ZnVsLCBJJ2QgYmUNCj4+Pj4+Pj4+IG9rIHRvIGxlYXZlIGl0IGZvciB0aGUgdGltZSBiZWluZy4g
T3ZlcmFsbCBnb2FsIGlzIHRvIHJlYWNoIGZlYXR1cmUgcGFyaXR5DQo+Pj4+Pj4+PiBhbW9uZyAo
YXQgbGVhc3QgbWFqb3IgYXJjaCkgSklUcyBhbmQgbm90IGp1c3QgaGF2ZSBtb3N0IGZ1bmN0aW9u
YWxpdHkgb25seQ0KPj4+Pj4+Pj4gYXZhaWxhYmxlIG9uIHg4Ni02NCBKSVQuIENvdWxkIHlvdSBo
b3dldmVyIGNoZWNrIHdoYXQgaXMgbm90IHdvcmtpbmcgd2l0aA0KPj4+Pj4+Pj4gYnBmdG9vbCBv
biBwb3dlcnBjLzMyPyBQZXJoYXBzIGl0J3Mgbm90IHRvbyBtdWNoIGVmZm9ydCB0byBqdXN0IGZp
eCBpdCwNCj4+Pj4+Pj4+IGJ1dCBkZXRhaWxzIHdvdWxkIGJlIHVzZWZ1bCBvdGhlcndpc2UgJ2l0
IGRpZG4ndCB3b3JrJyBpcyB0b28gZnV6enkuDQo+Pj4+Pj4+DQo+Pj4+Pj4+IFN1cmUgSSB3aWxs
IHRyeSB0byB0ZXN0IGJwZnRvb2wgYWdhaW4gaW4gdGhlIGNvbWluZyBkYXlzLg0KPj4+Pj4+Pg0K
Pj4+Pj4+PiBQcmV2aW91cyBkaXNjdXNzaW9uIGFib3V0IHRoYXQgc3ViamVjdCBpcyBoZXJlOg0K
Pj4+Pj4+PiBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGludXgtcmlzY3Yv
cGF0Y2gvMjAyMTA0MTUwOTMyNTAuMzM5MTI1Ny0xLUppYW5saW4uTHZAYXJtLmNvbS8jMjQxNzY4
NDc9DQo+Pj4+Pj4gSGkgQ2hyaXN0b3BoZQ0KPj4+Pj4+IEFueSBwcm9ncmVzcz8gV2UgZGlzY3Vz
cyB0byBkZXByZWNhdGUgdGhlIGJwZl9qaXRfZW5hYmxlID09IDIgaW4gMjAyMSwgYnV0IGJwZnRv
b2wgY2FuIG5vdCBydW4gb24gcG93ZXJwYy4NCj4+Pj4+PiBOb3cgY2FuIHdlIGZpeCB0aGlzIGlz
c3VlPw0KPj4+Pj4NCj4+Pj4+IEhpIFRvbmcsDQo+Pj4+Pg0KPj4+Pj4gSSBoYXZlIHN0YXJ0ZWQg
dG8gbG9vayBhdCBpdCBidXQgSSBkb24ndCBoYXZlIGFueSBmcnVpdGZ1bGwgZmVlZGJhY2sgeWV0
Lg0KPj4+Pj4NCj4+Pj4+IEluIHRoZSBtZWFudGltZSwgd2VyZSB5b3UgYWJsZSB0byBjb25maXJt
IHRoYXQgYnBmdG9vbCBjYW4gYWxzbyBiZSB1c2VkDQo+Pj4+PiB0byBkdW1wIGppdHRlZCB0ZXN0
cyBmcm9tIHRlc3RfYnBmLmtvIG1vZHVsZSBvbiB4ODZfNjQgPyBJbiB0aGF0IGNhbiB5b3UNCj4+
Pj4+IHRlbGwgbWUgaG93IHRvIHByb2NlZWQgPw0KPj4+PiBOb3cgSSBkbyBub3QgdGVzdCwgYnV0
IHdlIGNhbiBkdW1wIHRoZSBpbnNuIGFmdGVyIGJwZl9wcm9nX3NlbGVjdF9ydW50aW1lIGluIHRl
c3RfYnBmLmtvLiBicGZfbWFwX2dldF9pbmZvX2J5X2ZkIGNhbiBjb3B5IHRoZSBpbnNuIHRvIHVz
ZXJzcGFjZSwgYnV0IHdlIGNhbg0KPj4+PiBkdW1wIHRoZW0gaW4gdGVzdF9icGYua28gaW4gdGhl
IHNhbWUgd2F5Lg0KPj4+DQo+Pj4gSXNzdWUgaXMgdGhhdCB0aGVzZSBwcm9ncyBhcmUgbm90IGNv
bnN1bWFibGUgZnJvbSB1c2Vyc3BhY2UgKGFuZCB0aGVyZWZvcmUgbm90IGJwZnRvb2wpLg0KPj4+
IGl0J3MganVzdCBzaW1wbGUgYnBmX3Byb2dfYWxsb2MgKyBjb3B5IG9mIHRlc3QgaW5zbnMgKyBi
cGZfcHJvZ19zZWxlY3RfcnVudGltZSgpIHRvIHRlc3QNCj4+PiBKSVRzIChzZWUgZ2VuZXJhdGVf
ZmlsdGVyKCkpLiBTb21lIG9mIHRoZW0gY291bGQgYmUgY29udmVydGVkIG92ZXIgdG8gdGVzdF92
ZXJpZmllciwgYnV0DQo+Pj4gbm90IGFsbCBtaWdodCBhY3R1YWxseSBwYXNzIHZlcmlmaWVyLCBp
aXJjLiBEb24ndCB0aGluayBpdCdzIGEgZ29vZCBpZGVhIHRvIGFsbG93IGV4cG9zaW5nDQo+Pj4g
dGhlbSB2aWEgZmQgdGJoLg0KPj4gSGkNCj4+IEkgbWVhbiB0aGF0LCBjYW4gd2UgaW52b2tlIHRo
ZSBicGZfaml0X2R1bXAgaW4gdGVzdF9icGYua28gZGlyZWN0bHkgPy4gYnBmX3Byb2dfZ2V0X2lu
Zm9fYnlfZmQgY29weSB0aGUgaW5zbiB0byB1c2Vyc3BhY2UsIGJ1dCB3ZSBvbmx5IGR1bXAgaW5z
biBpbiB0ZXN0X2JwZi5rbw0KPj4NCj4+ICAgICAgICAgICAgICAgICAgaWYgKGJwZl9kdW1wX3Jh
d19vayhmaWxlLT5mX2NyZWQpKSB7Ly8gY29kZSBjb3BpZWQgZnJvbSBicGZfcHJvZ19nZXRfaW5m
b19ieV9mZCwgbm90IHRlc3RlZA0KPj4NCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAvKiBm
b3IgbXVsdGktZnVuY3Rpb24gcHJvZ3JhbXMsIGNvcHkgdGhlIEpJVGVkDQo+PiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICogaW5zdHJ1Y3Rpb25zIGZvciBhbGwgdGhlIGZ1bmN0aW9ucw0KPj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAqLw0KPj4gICAgICAgICAgICAgICAgICAgICAgICAg
IGlmIChwcm9nLT5hdXgtPmZ1bmNfY250KSB7DQo+PiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBmb3IgKGkgPSAwOyBpIDwgcHJvZy0+YXV4LT5mdW5jX2NudDsgaSsrKSB7DQo+PiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxlbiA9IHByb2ctPmF1eC0+
ZnVuY1tpXS0+aml0ZWRfbGVuOw0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBpbWcgPSAodTggKikgcHJvZy0+YXV4LT5mdW5jW2ldLT5icGZfZnVuYzsNCj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnBmX2ppdF9kdW1wKDEsIGxl
biwgMSwgaW1nKTsNCj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0NCj4+ICAg
ICAgICAgICAgICAgICAgICAgICAgICB9IGVsc2Ugew0KPj4gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgYnBmX2ppdF9kdW1wKDEsIHVsZW4sIDEsIHByb2ctPmJwZl9mdW5jKTsNCj4+
ICAgICAgICAgICAgICAgICAgICAgICAgICB9DQo+PiAgICAgICAgICAgICAgICAgIH0NCj4gDQo+
IExldCdzIG5vdCByZWludmVudCB0aGUgd2hlZWwuDQo+IGJwZnRvb2wgcHJvZyBkdW1wIGppdGVk
DQo+IGlzIG91ciBzdXBwb3J0ZWQgY29tbWFuZC4NCj4gcHBjIGlzc3VlIHdpdGggYnBmdG9vbCBp
cyByZWxhdGVkIHRvIGVuZGlhbm5lc3Mgb2YgZW1iZWRkZWQgc2tlbGV0b24uDQo+IHdoaWNoIG1l
YW5zIHRoYXQgbm9uZSBvZiB0aGUgYnBmdG9vbCBwcm9nIGNvbW1hbmRzIHdvcmsgb24gcHBjLg0K
PiBJdCdzIGEgYmlnZ2VyIGlzc3VlIHRvIGFkZHJlc3Mgd2l0aCBjcm9zcyBjb21waWxhdGlvbiBv
ZiBicGZ0b29sLg0KPiANCj4gYnBmdG9vbCBzdXBwb3J0cyBnbnUgYW5kIGxsdm0gZGlzYXNzZW1i
bGVyLiBJdCByZXRyaWV2ZXMgYW5kDQo+IHByaW50cyBCVEYsIGxpbmUgaW5mbyBhbmQgc291cmNl
IGNvZGUgYWxvbmcgd2l0aCBhc20uDQo+IFRoZSB1c2VyIGV4cGVyaWVuY2UgaXMgYXQgZGlmZmVy
ZW50IGxldmVsIGNvbXBhcmluZyB0byBicGZfaml0X2R1bXAuDQoNCkhpIEFsZXhlaSwNCg0KRmFp
ciBlbm91Z2gsIHdlIGFyZSBnb2luZyB0byB0cnkgYW5kIGZpeCBicGZ0b29sLg0KDQpCdXQgZm9y
IHRlc3RfYnBmLmtvIG1vZHVsZSwgaG93IGRvIHlvdSB1c2UgYnBmdG9vbCB0byBkdW1wIHRoZSBC
UEYgdGVzdHMgDQo/IEV2ZW4gb24geDg2IEkgaGF2ZSBub3QgYmVlbiBhYmxlIHRvIHVzZSBicGZ0
b29sIGZvciB0aGF0IHVudGlsIG5vdy4gDQpDYW4geW91IHRlbGwgbWUgaG93IHlvdSBkbyA/DQoN
ClRoYW5rcw0KQ2hyaXN0b3BoZQ0K
