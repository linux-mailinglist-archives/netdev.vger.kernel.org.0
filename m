Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD9D4F8FC8
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 09:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiDHHuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 03:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiDHHuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 03:50:04 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90045.outbound.protection.outlook.com [40.107.9.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D88481DE6D8;
        Fri,  8 Apr 2022 00:48:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVbA25tbjNnZeLyMrMaaoL9QH1qZQeW+NDkELLkNjuz/udKB7OWX/IM7kVcozIvc7ikFoJaMfWCYxjrLMCU3/MpSquZRRlIHJoPhhmUhIcTNlpWDKpyIP3Sxcnn/9OCiy3kM88oxkaJmp5SlG3hdFxqF/e+BApQZyp4/p5ddxOitEKIjhOTM4T/sH7Xw2BBwxJxEXMiHpaxIqmFpuNkOoV89pOjt+xBfqsWom7NMh9j0HnL1tR9DMnIKqQUFgvdy9RP8pzdqw7kU1uCxKzM1CF3o5mysjNvRTNpVs/ea+QXY2yFRAhcQKfifY1HEbRlcuqJl6xJ4owADjvLZeHbYLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yQU2psO4RWKA5APhrnQQQPFalS7lqysAuSI6sLq1iEo=;
 b=epz8nxaPavz0Swj9pCDpzdzkfcKUIWf1Jjr9sLcqEdxOzoVyIkVGmSOrUNsVvPlnXhYQ7VSdkzdNZEefLE6w9B/jdDzkrwT8VpZ9HL589KOK8vQ0Iup8oJf6vKNgcD06PwWVvUCRBqyJZa2fV7mXbcogentZaSTB11+xTSPn1gCfMtvGyJifv8pmUqSYy44wfMUNw2A4x4erU4YaXjL4MyXxdnPVf0cRsdfut11D+Px5P8zda3tANmGknuPKMz/+iOfcraVPo+vCt7QaZWhDYw5QUJrmyKXQrEFKB0+MxpVpUPa9pEuRLpfRQ9DsrEHe6R4C9vgRjyzSXDXStKCwlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB4023.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:252::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.23; Fri, 8 Apr
 2022 07:47:59 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::59c:ae33:63c1:cb1c%9]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 07:47:59 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Jakob Koschel <jakobkoschel@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        Eric Dumazet <edumazet@google.com>,
        Paul Mackerras <paulus@samba.org>,
        Ariel Elior <aelior@marvell.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        "Bos, H.J." <h.j.bos@vu.nl>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Jiri Pirko <jiri@resnulli.us>, Arnd Bergmann <arnd@arndb.de>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jakub Kicinski <kuba@kernel.org>, Di Zhu <zhudi21@huawei.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Michael Walle <michael@walle.cc>, Xu Wang <vulab@iscas.ac.cn>,
        Vladimir Oltean <olteanv@gmail.com>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
Thread-Topic: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
Thread-Index: AQHYSmqrhOU+WNoBAEqSPOAnf3fWTqzlpReA
Date:   Fri, 8 Apr 2022 07:47:59 +0000
Message-ID: <cd02715e-890d-bf67-697a-8f9b06160536@csgroup.eu>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
In-Reply-To: <20220407102900.3086255-3-jakobkoschel@gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5603a068-e0fc-42ce-0682-08da19341a14
x-ms-traffictypediagnostic: PR1P264MB4023:EE_
x-microsoft-antispam-prvs: <PR1P264MB4023DFA7B0DAEE8A59CFBED6EDE99@PR1P264MB4023.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CKQ0onlVt0bVxPkNF/AbUzPX6x+ZQ54lKEk2/sNgCGGayWpU6KkJNN9Irz5dgQu9w31NZCxo8yK97wITnZXT2Y4bBOsr+JklwKAqyIXyvKgHp5zoGuQS4ci5+xv1ZVckvV0qPDhNKvkikNovdWb5fG3Vvs8PBkBHHjvdNepkdA2XkkIBS447bh5JbbcqrF9mqGrSVEAG70lIGH4r9gpVZlcBZeRmc+B24wtxAuAjR992ihYHZtjFbITii8yhhPT9JBX62MdX+AiUdynQ8iIy7FSsn6Qw09Uosnc/P+rbiOFCs82O4HxSDPRv0dMGUSHI5X5aI1/oKCu1VR647WraAUagXwgQCX8qkdkvPDtP3UaoYQmslSiNXbe5f4p+xZYGPaNp+FXrr0a+Yg9F6I2ONV2feXWyFyDsC6WsRkkvHPufqNEh1XuNjhuFwbuCBusbEKN07sosQliL1N8vDNg7RS7g2uuZlTCRabvIXVsFGdTzNMmVzFZ9uYvI1vjeRHq1k51oA/hHIdv49/0yFwF98kokOk1t/Fc5kth9iDMIAp3tg+vrbeWvxS+kvLfQ/TAPcZ5JVah+0l2u8BO4a0QgQSO/B4zhPyuPO4Z2SS8gQwJSuPody+yr/DEtlNhfn9rUG8BAV68SQHKaic6M3YQT2X/tOtGy3pmjO0SwEQpPJUOaoHUdez7S6htqsxcks9fwwq4k2qiXf1/wVEvifOcq3vdCMVxtVY6343Qs0P+zEJIqypiQRuZV7KajztsNL3gr321tW1GWaERVKaK+5LpjfM+LAhlttbMPEG8G1nNN7MnxyffflhIHkZM7k9kG7kWF7quKyX1K5BPb380L0PWmNmDY4tSF6brmFwcpbViMSto=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(5660300002)(2906002)(966005)(31686004)(4326008)(36756003)(6506007)(8676002)(186003)(64756008)(26005)(71200400001)(66574015)(66946007)(66446008)(66556008)(66476007)(6512007)(7406005)(76116006)(7416002)(44832011)(8936002)(91956017)(122000001)(38070700005)(83380400001)(86362001)(31696002)(2616005)(316002)(38100700002)(6486002)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aTZ4dGNiZ2t5OWllUllBSjEwakRWUldxdXhjTG1QRXcydUFoVll5REJZSlRr?=
 =?utf-8?B?WlZkNVNVbkpFSi9kZ0xOVk50WnQyRjE2UnovLzlGV3pCUFdoUHE3a2ZBMUhi?=
 =?utf-8?B?RTVzR3gzams1dnN3eitORUhMOHdMdFNzV3NaRnhjOHk5L0l1RjBmNFVlMVk1?=
 =?utf-8?B?UkxheWU1cUoydml1Mk14djNPdUlCeXlvVDBTS2ZpYkZrKzZaQjJoL0xyV0hj?=
 =?utf-8?B?Ny9jbUpKN2Q4WlJZMlV0MzRPcGNzY2ZGQ3pkUTQ5MUdWdy82ak5zcXF1QlNv?=
 =?utf-8?B?bzNSQTF1L2toQkV6Ykl1VnVycnZRNCtSTEU1SFhmc0dtK0xxNG9nOFJ2dlhr?=
 =?utf-8?B?dDhyYjRhQmgvcWNsNWdZeWhrVGFiLzVtd21QQTZsMXI3RURCZkVUMEplTDhI?=
 =?utf-8?B?NTNvdy8xbjRyUFJoNDFxdGg5a1AyTVJEdnpyUDFVN2ZTcFdOeWZ1a1ptVGpp?=
 =?utf-8?B?NXlDUi9kbGpucmRzTytHbHJHYk1TTUJTRnp3Yk5BZTNzQkJRS2NuVExOUWhG?=
 =?utf-8?B?d2ZRcElDZkVxL09qbmZmU0gwRHZORXZDb1k1RStQd21RL3czVk8rcXFrYjY4?=
 =?utf-8?B?eVFZd2dSaFI2bnhkRXI1TG9HWHhhYUtTZEsxMXFJZ2o3QlVlRUpXa0t0VHRH?=
 =?utf-8?B?dGhxbEhqWUtUekl4UU1uN3h4d3Bpa1E1Y0VHdkhlaGtjcnU2ejJ3UVJvdjZG?=
 =?utf-8?B?MWpGR3RrYzRDenJ3b29rM1BXVzRLbGlVL1czMGdDeWcxbWJyVWdFM1V4eG44?=
 =?utf-8?B?N3FPTFZsZGRTM3ZJT0JodSt0T2lVNjN2THdsZ3doOTVBeGUxb0Y2Q1puWkJ0?=
 =?utf-8?B?UmJIRHFpckhjUHVHbkxNbk1MOVFlRm0vT29tMTFGWVYvK2oyTHFGZDlXR2p3?=
 =?utf-8?B?S1ZNTXA3TWJHS1FNNU4vSmVjcUpxNTVQTjNRVXBaQitHOXNXY0ZkVEhFZks5?=
 =?utf-8?B?akRESmhiZlQ2enVSNzR5VnJjYUpEQUQ5OVBKN0FVU3lycjRKK01WWGdIMW9q?=
 =?utf-8?B?cjdvL2IzRlppZFc4R2FMdGRpNVZ3SjY1Nkdacm1LOWpKSmtsdWdnbERabW1p?=
 =?utf-8?B?NUpQcTk1VStFTURpWVJ4YVZNaTA1cDlwT1FRUEFUUWtYbDNiMVZ2UnBiY0tN?=
 =?utf-8?B?b1J0RnpINTJ0OXUzUUVYa3BVa09uTDd1ZFJpbU9WcTE0ZVNzbURsekRSMTc3?=
 =?utf-8?B?Y21aRUFRQWRNU2xjVVpNamQ4bnQvKzFzTkJ1eERyWHpVTzMxcG93N2hMa1NW?=
 =?utf-8?B?Ukl4dEUzRUVrSHUrT3BDeEFUbjQrWWc5YSs0N0U5VVU0VDFVbWNwOUpvZ0tT?=
 =?utf-8?B?ZmdUdUNvRnp0RUN5Q3ovQlBxQlpKakFPL3RSb0tJVllwdk82T0dnazJOQkhy?=
 =?utf-8?B?VVdTZGwxL2VhaUZwNkErSkhLVnhMdldraGdYVEVnYTYrZjNOMXRBWHVXK2hj?=
 =?utf-8?B?L2JhdlNRUGlkT1hqZmJJRW5UVTJ0OE0rTVpldG5BTmhLYWR6WW8xUDZ6OWJn?=
 =?utf-8?B?bWZXbGF4aGY0U2ZZSGpkRDVwOCt6bmFBQ2ZSZGRDQWNacUlKU1hxSzVPOW4v?=
 =?utf-8?B?R1Z0QW1aR0EvVDFJOGdEem9CUmhEbkhFZi8vMnM5eEVzMlhTM0xydHhEbWdp?=
 =?utf-8?B?aXdvYmgvcVRrOEN2YUF3aTgwKzZkcDZXTzNsdE9nK0tqR2VHUklMSUFpSjlJ?=
 =?utf-8?B?SG1EUGxlemNQQVc1OWFkZ2svU2x6V0dsTXh5aGJ5RDB4NUZ2OE9tMzRlZ0Rz?=
 =?utf-8?B?TjRQajMyQUxOMUxtM1VZY1hyN202ejhta0o5aExtd1UzbWN3ZlpMdjZITUFG?=
 =?utf-8?B?eTlPMDNNSGhlMERSdnNlakVVTVJFTytSK3hhVzRheUVHZGRSSDVnUys4ZEto?=
 =?utf-8?B?aVc0WlI2cGpnQ0VwVUJjL1BzKzFGU2dGaGpiS3dTOFhTb1BRak10KzhoSkVV?=
 =?utf-8?B?N1hyZGhpTSswZERJOXpRNzN3OVNveXVXT2NiUDJUMUtiVFpwQllESTd5WVZM?=
 =?utf-8?B?Q2pqK3RKWll1cktqZTBwUzJhc2RyY3JGMEpkYTVZWTBhNlhZcVlsTFFJNUlt?=
 =?utf-8?B?SjJOeTZ2UVJUREZ3UE9GWURZZ3ZWcFFhMkR6YWhTaWN6SmcvMDhOY3ozaGpJ?=
 =?utf-8?B?dGRhNnJlTWZVdm9PZWcwSnR1WUJITDJ4M09TS1ZOZjh2RThzeW5WcGpVb29Z?=
 =?utf-8?B?N3laVFlYUkRzdllvRGZQeXFIMy81TnZVOVRNTFkwV2xTbFhJYWM4QVE4WDJa?=
 =?utf-8?B?WWlrR0RsWmh0aHVaWFZLWUtxOXV3MzRLNXJOUkoxY3d6NVM3dTlGOXY4REI3?=
 =?utf-8?B?dHJxb1NtclpJL1JjUE8rZVg2dnNRckpJaHpyUVUvOUJUajgwQ0lIRm5zeExE?=
 =?utf-8?Q?cFpBJErr+YEWW4UlRx31CkbTqggBLtLcxKQxT?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <587DBB0F99805B439C0BE5F5ED864EB7@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5603a068-e0fc-42ce-0682-08da19341a14
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 07:47:59.1610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eEebz8Si5V4l8HxDLrvjF45IuWhrGEnZwTCQVvMjDdwUYXjR9826Dqk2yTWcFd84dxj4U1sDVuZmqVBezbQP7RYVo6ocbM/ZcEBMU26KMCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB4023
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDA3LzA0LzIwMjIgw6AgMTI6MjgsIEpha29iIEtvc2NoZWwgYSDDqWNyaXTCoDoNCj4g
SW4gcHJlcGFyYXRpb24gdG8gbGltaXQgdGhlIHNjb3BlIG9mIGEgbGlzdCBpdGVyYXRvciB0byB0
aGUgbGlzdA0KPiB0cmF2ZXJzYWwgbG9vcCwgdXNlIGEgZGVkaWNhdGVkIHBvaW50ZXIgdG8gcG9p
bnQgdG8gdGhlIGZvdW5kIGVsZW1lbnQgWzFdLg0KPiANCj4gQmVmb3JlLCB0aGUgY29kZSBpbXBs
aWNpdGx5IHVzZWQgdGhlIGhlYWQgd2hlbiBubyBlbGVtZW50IHdhcyBmb3VuZA0KPiB3aGVuIHVz
aW5nICZwb3MtPmxpc3QuIFNpbmNlIHRoZSBuZXcgdmFyaWFibGUgaXMgb25seSBzZXQgaWYgYW4N
Cj4gZWxlbWVudCB3YXMgZm91bmQsIHRoZSBsaXN0X2FkZCgpIGlzIHBlcmZvcm1lZCB3aXRoaW4g
dGhlIGxvb3ANCj4gYW5kIG9ubHkgZG9uZSBhZnRlciB0aGUgbG9vcCBpZiBpdCBpcyBkb25lIG9u
IHRoZSBsaXN0IGhlYWQgZGlyZWN0bHkuDQo+IA0KPiBMaW5rOiBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9hbGwvQ0FIay09d2dScl9EOENCLUQ5S2ctYz1FSHJlQXNrNVNxWFB3cjlZN2s5c0E2Y1dY
SjZ3QG1haWwuZ21haWwuY29tLyBbMV0NCj4gU2lnbmVkLW9mZi1ieTogSmFrb2IgS29zY2hlbCA8
amFrb2Jrb3NjaGVsQGdtYWlsLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZHNhL3NqYTEx
MDUvc2phMTEwNV92bC5jIHwgMTQgKysrKysrKysrLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwg
OSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2RzYS9zamExMTA1L3NqYTExMDVfdmwuYyBiL2RyaXZlcnMvbmV0L2RzYS9zamExMTA1
L3NqYTExMDVfdmwuYw0KPiBpbmRleCBiN2U5NWQ2MGE2ZTQuLmNmY2FlNGQxOWVlZiAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL3NqYTExMDUvc2phMTEwNV92bC5jDQo+ICsrKyBiL2Ry
aXZlcnMvbmV0L2RzYS9zamExMTA1L3NqYTExMDVfdmwuYw0KPiBAQCAtMjcsMjAgKzI3LDI0IEBA
IHN0YXRpYyBpbnQgc2phMTEwNV9pbnNlcnRfZ2F0ZV9lbnRyeShzdHJ1Y3Qgc2phMTEwNV9nYXRp
bmdfY29uZmlnICpnYXRpbmdfY2ZnLA0KPiAgIAlpZiAobGlzdF9lbXB0eSgmZ2F0aW5nX2NmZy0+
ZW50cmllcykpIHsNCj4gICAJCWxpc3RfYWRkKCZlLT5saXN0LCAmZ2F0aW5nX2NmZy0+ZW50cmll
cyk7DQo+ICAgCX0gZWxzZSB7DQo+IC0JCXN0cnVjdCBzamExMTA1X2dhdGVfZW50cnkgKnA7DQo+
ICsJCXN0cnVjdCBzamExMTA1X2dhdGVfZW50cnkgKnAgPSBOVUxMLCAqaXRlcjsNCj4gICANCj4g
LQkJbGlzdF9mb3JfZWFjaF9lbnRyeShwLCAmZ2F0aW5nX2NmZy0+ZW50cmllcywgbGlzdCkgew0K
PiAtCQkJaWYgKHAtPmludGVydmFsID09IGUtPmludGVydmFsKSB7DQo+ICsJCWxpc3RfZm9yX2Vh
Y2hfZW50cnkoaXRlciwgJmdhdGluZ19jZmctPmVudHJpZXMsIGxpc3QpIHsNCj4gKwkJCWlmIChp
dGVyLT5pbnRlcnZhbCA9PSBlLT5pbnRlcnZhbCkgew0KPiAgIAkJCQlOTF9TRVRfRVJSX01TR19N
T0QoZXh0YWNrLA0KPiAgIAkJCQkJCSAgICJHYXRlIGNvbmZsaWN0Iik7DQo+ICAgCQkJCXJjID0g
LUVCVVNZOw0KPiAgIAkJCQlnb3RvIGVycjsNCj4gICAJCQl9DQo+ICAgDQo+IC0JCQlpZiAoZS0+
aW50ZXJ2YWwgPCBwLT5pbnRlcnZhbCkNCj4gKwkJCWlmIChlLT5pbnRlcnZhbCA8IGl0ZXItPmlu
dGVydmFsKSB7DQo+ICsJCQkJcCA9IGl0ZXI7DQo+ICsJCQkJbGlzdF9hZGQoJmUtPmxpc3QsIGl0
ZXItPmxpc3QucHJldik7DQo+ICAgCQkJCWJyZWFrOw0KPiArCQkJfQ0KPiAgIAkJfQ0KPiAtCQls
aXN0X2FkZCgmZS0+bGlzdCwgcC0+bGlzdC5wcmV2KTsNCj4gKwkJaWYgKCFwKQ0KPiArCQkJbGlz
dF9hZGQoJmUtPmxpc3QsIGdhdGluZ19jZmctPmVudHJpZXMucHJldik7DQo+ICAgCX0NCj4gICAN
Cj4gICAJZ2F0aW5nX2NmZy0+bnVtX2VudHJpZXMrKzsNCg0KVGhpcyBjaGFuZ2UgbG9va3MgdWds
eSwgd2h5IGR1cGxpY2F0aW5nIHRoZSBsaXN0X2FkZCgpIHRvIGRvIHRoZSBzYW1lID8gDQpBdCB0
aGUgZW5kIG9mIHRoZSBsb29wIHRoZSBwb2ludGVyIGNvbnRhaW5zIGdhdGluZ19jZmctPmVudHJp
ZXMsIHNvIGl0IA0Kd2FzIGNsZWFuZXIgYmVmb3JlLg0KDQpJZiB5b3UgZG9uJ3Qgd2FudCB0byB1
c2UgdGhlIGxvb3AgaW5kZXggb3V0c2lkZSB0aGUgbG9vcCwgZmFpciBlbm91Z2gsIA0KYWxsIHlv
dSBoYXZlIHRvIGRvIGlzOg0KDQoJCXN0cnVjdCBzamExMTA1X2dhdGVfZW50cnkgKnAsICppdGVy
Ow0KDQoJCWxpc3RfZm9yX2VhY2hfZW50cnkoaXRlciwgJmdhdGluZ19jZmctPmVudHJpZXMsIGxp
c3QpIHsNCgkJCWlmIChpdGVyLT5pbnRlcnZhbCA9PSBlLT5pbnRlcnZhbCkgew0KCQkJCU5MX1NF
VF9FUlJfTVNHX01PRChleHRhY2ssDQoJCQkJCQkgICAiR2F0ZSBjb25mbGljdCIpOw0KCQkJCXJj
ID0gLUVCVVNZOw0KCQkJCWdvdG8gZXJyOw0KCQkJfQ0KCQkJcCA9IGl0ZXI7DQoNCgkJCWlmIChl
LT5pbnRlcnZhbCA8IGl0ZXItPmludGVydmFsKQ0KCQkJCWJyZWFrOw0KCQl9DQoJCWxpc3RfYWRk
KCZlLT5saXN0LCBwLT5saXN0LnByZXYpOw0KDQoNCg0KQ2hyaXN0b3BoZQ==
