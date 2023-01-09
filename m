Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBCB661FC9
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236336AbjAIIPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:15:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbjAIIPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:15:16 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2041.outbound.protection.outlook.com [40.107.12.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F18AF21B1;
        Mon,  9 Jan 2023 00:15:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlXglv71n04BE38et6C+RBXnG5ddCd8J558FvBkK2zgjbCnlPtoiKFZ57ECAjx6WwOdo6YCn6IQ5I7l6pEV2lEnahWx64wKD7xcG4qy1717vf+RRdnVEg4p25FrzWCpJSipaFhiO1Pjfuplny8tq/TikCJi4sOkM3oV8kNjWTqpVsTLZ0WKOsDjdsmlZyDkORd/rDO5FEHLLTnYyaLHm9jeppuF7o+1wDpB8Qx3VJ95Ti/yjCP0oGD0K8QbxWCtIpQ2pqt4LSWfIXoYtVbJK8DyLgvvskMQ3jSidgR2S5mCfYAUpRx2y7JMgCAWdkhyibB3dsdJa4WwRewdFTIGAFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hx0FHV3k/7NL+AZRamp5FxA9YTcTDbwPT4gTSHJWP3M=;
 b=mVxa14WBEIKVP2rI5SavFS5sH82h7MkkxDyMIdTS2s5LKf3eO4+GZzRQuuBqz+eEoD3R3B1CR88RRLKNf6Ess8GV+kGauUMRZmUr4x6aTQVYdaRs7jYC60VzxGCBETW8r2axBe0xk4Gi6ptiAhzyrtUcixwM+rNATvzI9Bv9Au5pQIHmWwh0XnCTIrDaRHDhv1utZgTCOHrmqzrmqqbpMrOIlHB0an559Dje2OXTnc2cKif09giEk4ogJz5HigO5SKWorG/LsTrE1/kRmVOFB2AGlA16lq3B3vwnJ82jJR9310PZ1uz4P9WFUdLxvfXx0gF/5XHcTUA5UU6PRq2ztQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hx0FHV3k/7NL+AZRamp5FxA9YTcTDbwPT4gTSHJWP3M=;
 b=LTHFGhQ2QZFrkRm03gr1OF3kTUQ/HPb6vESV3JsuqZkZkMb64a4VhAOEESfJA7+v76AerH13J3ySgMLvS+acIqiLICJnNuioCclj+YwcQoRs/AwmY0AUs0t173GvdW6R2a3+l7VtQctZCFsJwpttDGX3Bt7QksU9JYqBPbDxmsOtoswGIhUOOWZNbtk7XxSiJP7K/syv+lweMN73s89IFM4+lyZ2MzQ7+e5AlSPmsitKn1DYF7SjOGfMzLenyUlnablYYddtPQ2Xniq1A91ugXFiC4QVWVztU2HK7+uiF5ZVl0y9aSJi0xVdJHhy4pQ8nCN6UNMwe8X8xnUqhuZBvw==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB2011.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:168::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 08:15:12 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097%7]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 08:15:12 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "tong@infragraf.org" <tong@infragraf.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.or" 
        <linux-arm-kernel@lists.infradead.or>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>
CC:     Hao Luo <haoluo@google.com>,
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
Thread-Index: AQHZILjtdiBl24vDM0uhRRtlAlrCCa6QG7gAgAFsaoCABDtogA==
Date:   Mon, 9 Jan 2023 08:15:12 +0000
Message-ID: <5836b464-290e-203f-00f2-fc6632c9f570@csgroup.eu>
References: <20230105030614.26842-1-tong@infragraf.org>
 <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
 <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net>
In-Reply-To: <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR0P264MB2011:EE_
x-ms-office365-filtering-correlation-id: 165fcc8c-4bc6-4951-f904-08daf219a14c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oBu1gBw/sTnmVI8W846EXzPrCilfmXE4aZ94DtN4KBS4BkzgFGtvM52bpdIXVwM7JO9uvwKVdf2mNO4Y0ryRtaJ69L1aibQ/2vMwsjRPaV7PoUzKwGbeMvjh7dw0MzMixFFgY+3RiQWE3BCPn8+dcwvi5Ai1oIqupvsebfMW+YH9WoWAUXd3WZmkQ4NxY8zyo1zqMj5JYHisV6UOKu7UbRQ9l1NOjdTH1g/Ha+1PapB3XE3ZGYEBqGpPaul+P5vQhqC0U04qrESKLqiOvsHDtqg0aiAkcnxfyJdxck16J70WMwHtgLZVcdgat9u54mLeAA0PnqIWcu+sX7KodlnZCM2jcDGemcTcL83UvjiezF1rgkwwdA2Xog9gFRYuIi0FE+OtlBGCCzVy4Xoz8Dfv/QEeMbba6+1EUANsKFb+cAkeDMBsQZP0nImqe4rZ3DkBEhL+QQxvFc1zf+V0uWmdgixZ2LyjPjLU0biW3ElnL/jdjk+QCoPVSLAY7XvJBmDqzKKNx7vmiLhMrq7P5WQXgiGmR4b0dz7IwLAKrrafR/Dzs16dN9w/r+r58AZsINIRzBjucSdLygj7H18GHMHIKLJ35TYws15r+CXwpUa8pQSc69Aj2fps/STK7iW1SutRkwEbAA+h1WLJZrJFY5hE9qcPXvGHSG55+Ol5K6jvnOPrrFV8Xox6kBGpyIjNwPzj+3RuzroUV91hsMm5qrokVtCwqR+7v0bFRn9BA1cHJqL0N4qKVb8eyH39RNPpboMgRCJ38MjcrymEZQAmdTTefRC371Q5hYTR3TryYgx+D9pjuDUMhiAJpqLc17zYTlia
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(346002)(39850400004)(451199015)(8676002)(316002)(5660300002)(7416002)(71200400001)(26005)(44832011)(6512007)(966005)(6486002)(478600001)(186003)(2616005)(66574015)(41300700001)(31696002)(66446008)(110136005)(91956017)(54906003)(4326008)(66946007)(64756008)(66476007)(76116006)(66556008)(8936002)(83380400001)(38070700005)(86362001)(36756003)(53546011)(31686004)(6506007)(122000001)(38100700002)(921005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk1NNitkcjIzQU9FWG12ZldOR2lOckhnREsrWkl0elp4QlczQ1hVNjNCdXQ0?=
 =?utf-8?B?b1l1dzR4UkJhNHRhWk0xQ2RqNXpvdExleVRMa2RpWXZTcWN4MnRVbE9nQ3hM?=
 =?utf-8?B?eXpRTEhTRm45WlBRZUY3dHpFZW4yUEo1cXhWTVE2andJQlhqL0JwN2lYNXV4?=
 =?utf-8?B?Uk12Mk1Fa2NGUm1YcXh5VU9CblN0VUVlQmRlT3ZTMEhmL0NIT0NBWmdjTFFo?=
 =?utf-8?B?c01nYVVubVk4YlVzWFZuVXE5emlzeGRKbTNVWGVKa054QzhEekY3SU1YcTA2?=
 =?utf-8?B?T28wNnVkVFEwYjhHZU9GdjkxYWVPMzBhb21TOEtEREtCdmlsWVlldlFUS1Za?=
 =?utf-8?B?VnFYRExQZEJMNmlKZE9BN2thSXd1UnN5cGZFTHhDNTNxd3l2dDN5TlhYb0do?=
 =?utf-8?B?dHR4aGZBY1hMU3BFRXI5VHFRMVhCTkcrUzVRaXR5dWtxMy9HRUNGMTd3ZFZi?=
 =?utf-8?B?VHVhY09WTWU1SGFBNDVNZk5CZVg2em1IekV1Vk5CTlVLUWVqN3drcVB6N0N3?=
 =?utf-8?B?cTZEWG02dU56L2dGZXRLMjV6M2ZTWFBHdXlFTGZVUjJsNHRqa0tZck9lc3JC?=
 =?utf-8?B?YUlvUDhBd2JqQ0hKTThDRVBYb0MwU2c5a1FJTXpYUSttbXMvd2dBd0xuZTgr?=
 =?utf-8?B?UEhNOXFKRkFvZzRiM1AxVTZzTVJkVkVIK2d3blJ5N0RySWlWR3lJRUxEL3BS?=
 =?utf-8?B?bkVLZ3NMNDNEeHROVzNaRnd0cjhYTVNOaWd0OC9YdFZsNE9OOG5rQytXWitk?=
 =?utf-8?B?UUFWK2lDZHAxMnJFb3h3cWxWL2sxak82UjVMbmhLWHVCNzFhR1VsZTJPR2d1?=
 =?utf-8?B?c3RxMEZrY2dVdENMRnp1QzN6bFJFY21NUkdyV1Z3M04xTEF5WHRnSUJ1c25k?=
 =?utf-8?B?Z2ZVOENNSlBvTDJLSUVnM2Z6ZkFESzdJTUcxNmdEa0RPYUcreEw4L2lYSFdF?=
 =?utf-8?B?M29QM1RBcjJRZ2s1RXdIcXFyQkh4cXJGVEhrd1NaZDhxNlRoc2FEMzc3T2lI?=
 =?utf-8?B?NzBWb01hM1RXN2dZM0RwNVdRWFBydmpibVFzRU9IOUdSL0ZucUVGMTM4blZX?=
 =?utf-8?B?ZG1lbUxnM1o2QnJzNzVnZmNkQmlHZ1dnbm1PeVlFbTFQWXRuWkVGdGwxZ1RJ?=
 =?utf-8?B?ZjZBUEhqbk80b2VMREsxTTVqN2hibzVCcU9tWERuMHdMeG9vLzdobnZPS0Ju?=
 =?utf-8?B?c0lLS1g3Nm1YeEROWFRyQnUvV1hxY3RNSGswZThHMlF6WURkR2JicUJwbldK?=
 =?utf-8?B?UWJiMVV6MUMwWCtXeDZWd1VXd1pYcWZQRENtRFhYbGo1SmN1ZFMvd0Q5Qita?=
 =?utf-8?B?MGtMd0NJMDh0a09PdTZlbDliSkdoVjJxdURrOFh0aDdsSVF1dks1QVozdUFK?=
 =?utf-8?B?NnQrS21SZnBHck1SWmtiYmdJc1VSYWFzTlNVM2NMVTgvanV2dFkzbnJ3Sk1q?=
 =?utf-8?B?ejJFczVJUWg2UTlXMkFqUzI5Ym82cjFFc1FCS1BFVkl5eEltWDVrK0JFNWhY?=
 =?utf-8?B?T3QrbGdnbWlYek1yREhOTTd6VjBQcmF6UjJsbFBiandHTVNaTmtDQ2VTNXVr?=
 =?utf-8?B?NVBWUVk3ejdCa1B6emRVTmRIbytjdnNrODRpZW1JZ2dOMHI5aXpyNjc5REZi?=
 =?utf-8?B?ci9oeGlSUW9sNHBDK1JmNDJsUlFQMTZlM09BUkdhQXVtakxnOXJ5eVFmcmFN?=
 =?utf-8?B?WXd5ejl2ZUoyWVd6WnpxVm1sK2JjMXI3bkpoejJGd2F1aWRsdXBJZ1F2R2tE?=
 =?utf-8?B?ZFhQL1lkbWVJWDR0cmxrSmtNT1htWHdpdjh4d2F0SjNlWTk0QXZjQzh0VjMy?=
 =?utf-8?B?OWk0ZTBZRTBJc05RRnlhMlZ3Q1MzNWZNSUZXZnFXVkltWlpXdWk3eEhWTHBm?=
 =?utf-8?B?VllHQkdJZm1ZejIvOHFCYk9pRkhDVHJMVmxHL0wxcFVXc0FhMm9kcEVRSktJ?=
 =?utf-8?B?enR1ZlJjZUcvSWx0bU9kMDEvYytOdDBLaDI3Z2lNZFZVNWVMUzB1OGRqZTNU?=
 =?utf-8?B?WGpmc1hkQ0wvNVkrME9xTHU4Q0Q2ZWlJOW9wVFRvT0doTmRuVzVUWHNDRXVT?=
 =?utf-8?B?bDAwM2pkMWpsYlBQN21CdFlvcEhYdFZ4YkZYVHo1R3VTN2NuTkErWldMTXBo?=
 =?utf-8?B?UC9pYnVabFYyVmJHcjFvZEgxTlVnMlZTZUxwMzdZZ2s5TjZ1OTNBRE1YSzlC?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35373EDDA1640D4DAC2A155620971E1A@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 165fcc8c-4bc6-4951-f904-08daf219a14c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 08:15:12.0314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eunRnCU5XUpcBmvefzYzji2drRRc8lZg0aap0h9/SKF1cNORvWnYRUOFXGFf4tw2nKKzsv2r50daj6Nu8yHS66UDCm5M6GixgXYuvuK7wCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB2011
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDA2LzAxLzIwMjMgw6AgMTY6MzcsIERhbmllbCBCb3JrbWFubiBhIMOpY3JpdMKgOg0K
PiBPbiAxLzUvMjMgNjo1MyBQTSwgQ2hyaXN0b3BoZSBMZXJveSB3cm90ZToNCj4+IExlIDA1LzAx
LzIwMjMgw6AgMDQ6MDYsIHRvbmdAaW5mcmFncmFmLm9yZyBhIMOpY3JpdMKgOg0KPj4+IEZyb206
IFRvbmdoYW8gWmhhbmcgPHRvbmdAaW5mcmFncmFmLm9yZz4NCj4+Pg0KPj4+IFRoZSB4ODZfNjQg
Y2FuJ3QgZHVtcCB0aGUgdmFsaWQgaW5zbiBpbiB0aGlzIHdheS4gQSB0ZXN0IEJQRiBwcm9nDQo+
Pj4gd2hpY2ggaW5jbHVkZSBzdWJwcm9nOg0KPj4+DQo+Pj4gJCBsbHZtLW9iamR1bXAgLWQgc3Vi
cHJvZy5vDQo+Pj4gRGlzYXNzZW1ibHkgb2Ygc2VjdGlvbiAudGV4dDoNCj4+PiAwMDAwMDAwMDAw
MDAwMDAwIDxzdWJwcm9nPjoNCj4+PiDCoMKgwqDCoMKgwqDCoMKgIDA6wqDCoMKgwqDCoMKgIDE4
IDAxIDAwIDAwIDczIDc1IDYyIDcwIDAwIDAwIDAwIDAwIDcyIDZmIDY3IDAwIHIxIA0KPj4+ID0g
MjkxMTQ0NTk5MDM2NTMyMzUgbGwNCj4+PiDCoMKgwqDCoMKgwqDCoMKgIDI6wqDCoMKgwqDCoMKg
IDdiIDFhIGY4IGZmIDAwIDAwIDAwIDAwICoodTY0ICopKHIxMCAtIDgpID0gcjENCj4+PiDCoMKg
wqDCoMKgwqDCoMKgIDM6wqDCoMKgwqDCoMKgIGJmIGExIDAwIDAwIDAwIDAwIDAwIDAwIHIxID0g
cjEwDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoCA0OsKgwqDCoMKgwqDCoCAwNyAwMSAwMCAwMCBmOCBm
ZiBmZiBmZiByMSArPSAtOA0KPj4+IMKgwqDCoMKgwqDCoMKgwqAgNTrCoMKgwqDCoMKgwqAgYjcg
MDIgMDAgMDAgMDggMDAgMDAgMDAgcjIgPSA4DQo+Pj4gwqDCoMKgwqDCoMKgwqDCoCA2OsKgwqDC
oMKgwqDCoCA4NSAwMCAwMCAwMCAwNiAwMCAwMCAwMCBjYWxsIDYNCj4+PiDCoMKgwqDCoMKgwqDC
oMKgIDc6wqDCoMKgwqDCoMKgIDk1IDAwIDAwIDAwIDAwIDAwIDAwIDAwIGV4aXQNCj4+PiBEaXNh
c3NlbWJseSBvZiBzZWN0aW9uIHJhd190cC9zeXNfZW50ZXI6DQo+Pj4gMDAwMDAwMDAwMDAwMDAw
MCA8ZW50cnk+Og0KPj4+IMKgwqDCoMKgwqDCoMKgwqAgMDrCoMKgwqDCoMKgwqAgODUgMTAgMDAg
MDAgZmYgZmYgZmYgZmYgY2FsbCAtMQ0KPj4+IMKgwqDCoMKgwqDCoMKgwqAgMTrCoMKgwqDCoMKg
wqAgYjcgMDAgMDAgMDAgMDAgMDAgMDAgMDAgcjAgPSAwDQo+Pj4gwqDCoMKgwqDCoMKgwqDCoCAy
OsKgwqDCoMKgwqDCoCA5NSAwMCAwMCAwMCAwMCAwMCAwMCAwMCBleGl0DQo+Pj4NCj4+PiBrZXJu
ZWwgcHJpbnQgbWVzc2FnZToNCj4+PiBbwqAgNTgwLjc3NTM4N10gZmxlbj04IHByb2dsZW49NTEg
cGFzcz0zIGltYWdlPWZmZmZmZmZmYTAwMGMyMGMgDQo+Pj4gZnJvbT1rcHJvYmUtbG9hZCBwaWQ9
MTY0Mw0KPj4+IFvCoCA1ODAuNzc3MjM2XSBKSVQgY29kZTogMDAwMDAwMDA6IGNjIGNjIGNjIGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIA0KPj4+IGNjIGNjIGNjIGNjIGNjDQo+Pj4gW8KgIDU4MC43
NzkwMzddIEpJVCBjb2RlOiAwMDAwMDAxMDogY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2Mg
Y2MgDQo+Pj4gY2MgY2MgY2MgY2MgY2MNCj4+PiBbwqAgNTgwLjc4MDc2N10gSklUIGNvZGU6IDAw
MDAwMDIwOiBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyBjYyANCj4+PiBjYyBjYyBjYyBj
YyBjYw0KPj4+IFvCoCA1ODAuNzgyNTY4XSBKSVQgY29kZTogMDAwMDAwMzA6IGNjIGNjIGNjDQo+
Pj4NCj4+PiAkIGJwZl9qaXRfZGlzYXNtDQo+Pj4gNTEgYnl0ZXMgZW1pdHRlZCBmcm9tIEpJVCBj
b21waWxlciAocGFzczozLCBmbGVuOjgpDQo+Pj4gZmZmZmZmZmZhMDAwYzIwYyArIDx4PjoNCj4+
PiDCoMKgwqDCoCAwOsKgwqAgaW50Mw0KPj4+IMKgwqDCoMKgIDE6wqDCoCBpbnQzDQo+Pj4gwqDC
oMKgwqAgMjrCoMKgIGludDMNCj4+PiDCoMKgwqDCoCAzOsKgwqAgaW50Mw0KPj4+IMKgwqDCoMKg
IDQ6wqDCoCBpbnQzDQo+Pj4gwqDCoMKgwqAgNTrCoMKgIGludDMNCj4+PiDCoMKgwqDCoCAuLi4N
Cj4+Pg0KPj4+IFVudGlsIGJwZl9qaXRfYmluYXJ5X3BhY2tfZmluYWxpemUgaXMgaW52b2tlZCwg
d2UgY29weSByd19oZWFkZXIgdG8gDQo+Pj4gaGVhZGVyDQo+Pj4gYW5kIHRoZW4gaW1hZ2UvaW5z
biBpcyB2YWxpZC4gQlRXLCB3ZSBjYW4gdXNlIHRoZSAiYnBmdG9vbCBwcm9nIGR1bXAiIA0KPj4+
IEpJVGVkIGluc3RydWN0aW9ucy4NCj4+DQo+PiBOQUNLLg0KPj4NCj4+IEJlY2F1c2UgdGhlIGZl
YXR1cmUgaXMgYnVnZ3kgb24geDg2XzY0LCB5b3UgcmVtb3ZlIGl0IGZvciBhbGwNCj4+IGFyY2hp
dGVjdHVyZXMgPw0KPj4NCj4+IE9uIHBvd2VycGMgYnBmX2ppdF9lbmFibGUgPT0gMiB3b3JrcyBh
bmQgaXMgdmVyeSB1c2VmdWxsLg0KPj4NCj4+IExhc3QgdGltZSBJIHRyaWVkIHRvIHVzZSBicGZ0
b29sIG9uIHBvd2VycGMvMzIgaXQgZGlkbid0IHdvcmsuIEkgZG9uJ3QNCj4+IHJlbWVtYmVyIHRo
ZSBkZXRhaWxzLCBJIHRoaW5rIGl0IHdhcyBhbiBpc3N1ZSB3aXRoIGVuZGlhbmVzcy4gTWF5YmUg
aXQNCj4+IGlzIGZpeGVkIG5vdywgYnV0IGl0IG5lZWRzIHRvIGJlIHZlcmlmaWVkLg0KPj4NCj4+
IFNvIHBsZWFzZSwgYmVmb3JlIHJlbW92aW5nIGEgd29ya2luZyBhbmQgdXNlZnVsbCBmZWF0dXJl
LCBtYWtlIHN1cmUNCj4+IHRoZXJlIGlzIGFuIGFsdGVybmF0aXZlIGF2YWlsYWJsZSB0byBpdCBm
b3IgYWxsIGFyY2hpdGVjdHVyZXMgaW4gYWxsDQo+PiBjb25maWd1cmF0aW9ucy4NCj4+DQo+PiBB
bHNvLCBJIGRvbid0IHRoaW5rIGJwZnRvb2wgaXMgdXNhYmxlIHRvIGR1bXAga2VybmVsIEJQRiBz
ZWxmdGVzdHMuDQo+PiBUaGF0J3Mgdml0YWwgd2hlbiBhIHNlbGZ0ZXN0IGZhaWxzIGlmIHlvdSB3
YW50IHRvIGhhdmUgYSBjaGFuY2UgdG8NCj4+IHVuZGVyc3RhbmQgd2h5IGl0IGZhaWxzLg0KPiAN
Cj4gSWYgdGhpcyBpcyBhY3RpdmVseSB1c2VkIGJ5IEpJVCBkZXZlbG9wZXJzIGFuZCBjb25zaWRl
cmVkIHVzZWZ1bCwgSSdkIGJlDQo+IG9rIHRvIGxlYXZlIGl0IGZvciB0aGUgdGltZSBiZWluZy4g
T3ZlcmFsbCBnb2FsIGlzIHRvIHJlYWNoIGZlYXR1cmUgcGFyaXR5DQo+IGFtb25nIChhdCBsZWFz
dCBtYWpvciBhcmNoKSBKSVRzIGFuZCBub3QganVzdCBoYXZlIG1vc3QgZnVuY3Rpb25hbGl0eSBv
bmx5DQo+IGF2YWlsYWJsZSBvbiB4ODYtNjQgSklULiBDb3VsZCB5b3UgaG93ZXZlciBjaGVjayB3
aGF0IGlzIG5vdCB3b3JraW5nIHdpdGgNCj4gYnBmdG9vbCBvbiBwb3dlcnBjLzMyPyBQZXJoYXBz
IGl0J3Mgbm90IHRvbyBtdWNoIGVmZm9ydCB0byBqdXN0IGZpeCBpdCwNCj4gYnV0IGRldGFpbHMg
d291bGQgYmUgdXNlZnVsIG90aGVyd2lzZSAnaXQgZGlkbid0IHdvcmsnIGlzIHRvbyBmdXp6eS4N
Cg0KU3VyZSBJIHdpbGwgdHJ5IHRvIHRlc3QgYnBmdG9vbCBhZ2FpbiBpbiB0aGUgY29taW5nIGRh
eXMuDQoNClByZXZpb3VzIGRpc2N1c3Npb24gYWJvdXQgdGhhdCBzdWJqZWN0IGlzIGhlcmU6IA0K
aHR0cHM6Ly9wYXRjaHdvcmsua2VybmVsLm9yZy9wcm9qZWN0L2xpbnV4LXJpc2N2L3BhdGNoLzIw
MjEwNDE1MDkzMjUwLjMzOTEyNTctMS1KaWFubGluLkx2QGFybS5jb20vIzI0MTc2ODQ3DQoNCg0K
PiANCj4gQWxzbywgd2l0aCByZWdhcmRzIHRvIHRoZSBsYXN0IHN0YXRlbWVudCB0aGF0IGJwZnRv
b2wgaXMgbm90IHVzYWJsZSB0bw0KPiBkdW1wIGtlcm5lbCBCUEYgc2VsZnRlc3RzLiBDb3VsZCB5
b3UgZWxhYm9yYXRlIHNvbWUgbW9yZT8gSSBoYXZlbid0IHVzZWQNCj4gYnBmX2ppdF9lbmFibGUg
PT0gMiBpbiBhIGxvbmcgdGltZSBhbmQgZm9yIGRlYnVnZ2luZyBhbHdheXMgcmVsaWVkIG9uDQo+
IGJwZnRvb2wgdG8gZHVtcCB4bGF0ZWQgaW5zbnMgb3IgSklULiBPciBkbyB5b3UgbWVhbiBieSBC
UEYgc2VsZnRlc3RzDQo+IHRoZSB0ZXN0X2JwZi5rbyBtb2R1bGU/IEdpdmVuIGl0IGhhcyBhIGJp
ZyBiYXRjaCB3aXRoIGtlcm5lbC1vbmx5IHRlc3RzLA0KPiB0aGVyZSBJIGNhbiBzZWUgaXQncyBw
cm9iYWJseSBzdGlsbCB1c2VmdWwuDQoNClllcyBJIG1lYW4gdGVzdF9icGYua28NCg0KSSB1c2Vk
IGl0IGFzIHRoZSB0ZXN0IGJhc2lzIHdoZW4gSSBpbXBsZW1lbnRlZCBlQlBGIGZvciBwb3dlcnBj
LzMyLiBBbmQgDQpub3Qgc28gbG9uZyBhZ28gaXQgaGVscGVkIGRlY292ZXIgYW5kIGZpeCBhIGJ1
Zywgc2VlIA0KaHR0cHM6Ly9naXRodWIuY29tL3RvcnZhbGRzL2xpbnV4L2NvbW1pdC84OWQyMWUy
NTlhOTRmN2Q1NTgyZWM2NzVhYTQ0NWY1YTc5ZjM0N2U0DQoNCj4gDQo+IENoZWVycywNCj4gRGFu
aWVsDQo=
