Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BD566D6F8
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 08:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbjAQHbH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 02:31:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235918AbjAQHau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 02:30:50 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-mr2fra01on2074.outbound.protection.outlook.com [40.107.9.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5E3298E5;
        Mon, 16 Jan 2023 23:30:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEnIxU4q/WPK4eVn6tqKCunK2ZUl+L9yx7L8bLrxLENruMiamQsutXemhBX+hPEpsq6pMtjwQa2meim4jyjDLotZ65AiPMYLr7Ks+UVyIcc1f6DzFsAbam4VN8BRbaEKxKXCRa3oHZpF3QM+uBOD6WFly5m92FIo7x6KhqjBHWYV/X6vdzTA/kndvRJp8H4AydWoSA4DdzniAuK0sGXgoSyU2fm0En9dpHmreUItWRTuxj8KqVD/zmHffvxFDM4Oe+MkHOhNKpwJuBTR0Jdg9xA9THxNdWcRR0KVcX2bidy4HmKCbxduPmpRZMpN/UebqeKctXs4yq6RX4FP7IrkEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H+zXVMt6KlN+j/szC2YuRQrWMZ0rcDtHqqu4IN5hGlM=;
 b=eiytWjMiKTXu5mA5Tqk7Em6LX2lfwkYiLKiw+n0MD7p7Tuasoo4iXvbM3P5iiPw/rcA2RN0D2Y1AS9AXXMdmZMk6MGVryN1eqboIGXuhDxmI3ULvic1ofvwIG2U683NKOINKofKzBaYg99RKndRzg6NFgAMpS9j52GiuLFuzgyeNdSpeRusk4VB2ABWUOxDE8aKW+4DA+lArhRdK0NIGIrQsfPDuYVkfLyucEgQbzzJa2tVt5I6Lac0Bfz139sxqIut34FQIvWiaQLGs7DN2sMl1Bf19sgnC2Q8Jt7LVd0b/suA01az2GtA4r1zDil8je+cC2nXm12OCIx1DR5Lm2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+zXVMt6KlN+j/szC2YuRQrWMZ0rcDtHqqu4IN5hGlM=;
 b=amuB9DTh4+ZC5cSZ58AQT3+uFrog7SP3rm2ZMqFpFLEtdQGPyd7JM2f8+h0Aq5BwG8XYSM8UFvTCNhe0aUolpNYw1vrBkoNqGuid/loujYkF7icehvY8Vg4kgj07nSzJlT6SiMv+2R+flbweuxCnA/WY4AF7s8q8xsIpCkywYSrnDRrkBaue0beS8dhHFn+WBzJ6r+0QnqvyxFZf2wGYpYIRMBV1YfBVEddpVT3Vi5Bc6jKav135dV8ZgAKoTl77R0wv8gODIGqtZAr/4eEGIbg6OUVZB+8N5jJ8p3Fi/vfR8X69+McK+Z9PWRs5D5jE3E6Bk0TyYLqMOaPVmjMIJA==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB2033.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Tue, 17 Jan
 2023 07:30:10 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097%9]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 07:30:10 +0000
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
Thread-Index: AQHZILjtdiBl24vDM0uhRRtlAlrCCa6QG7gAgAFsaoCABDtogIAMZLqAgAAhWIA=
Date:   Tue, 17 Jan 2023 07:30:10 +0000
Message-ID: <0b46b813-05f2-5083-9f2e-82d72970dae2@csgroup.eu>
References: <20230105030614.26842-1-tong@infragraf.org>
 <ea7673e1-40ec-18be-af89-5f4fd0f71742@csgroup.eu>
 <71c83f39-f85f-d990-95b7-ab6068839e6c@iogearbox.net>
 <5836b464-290e-203f-00f2-fc6632c9f570@csgroup.eu>
 <147A796D-12C0-482F-B48A-16E67120622B@infragraf.org>
In-Reply-To: <147A796D-12C0-482F-B48A-16E67120622B@infragraf.org>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|MR1P264MB2033:EE_
x-ms-office365-filtering-correlation-id: b6a8cb2e-e95d-487b-a595-08daf85caa21
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BWLkjmFXeX3U2J7B3rF3hVDpGDZD9Y/huzxdWy3t53Bw4qfIM3jmqM38pyjdgb8stn76dxkiTUb6+5kzhNfEKL+vS32HFBlpvoM5En3PqbHAvPiJH4VxNPj1UrfcumDWgU73Q66W9LTwmJbEhOhDIRCV4Tz2KHeNIYgeNhH0EeXxzCTucYbaC+kVRvGV3Tw8X673uvY6PZfj19RVkKtFh6tVphuTIEYnMvgnnZ1rhGZy1maUDoT+Q34VrO1o2Mx1yKE/rZUEWPvuQjc8QGagSA2gez0BOPFF7jZETP6yadSz6CRETuuvIkQFSBSKwW1p7JFhSeYT0YTCMp7Ujp5Lw4XtId5AGAVFPdRdhyrlVg+/3MXqa6ZBNvvuT94eyIvaG26BBhBMIweNfBt1J7J4h6vDmSsYuYVab3C5uXuzr2DUv6hJAPopafyHiB0fnqFpxGd5CfWgin1D83RQ1IlVosY5ahaem7maYOCn9RxpgejpAHxR9xxeKQoqZXwokend9kAfuv0weB5JeOeGQPNx1nPcbOHSSXX8f9Jy2M8Ct65YLm24Izolvjj/rMIpsXqcgJDdIWEYjmajOg9Ln4l+iEugQRmXFeZ/UYKR8Qie6QKE65Bnf4rJFmbLv1ne2/5tVxUOUV+CcKMNzr+EANkckR4NmGllcfYpXt5tnTBgqys/+X+lXHeCwwnkKwdYSXpyrBZvRHNg549Vjx8Vz272c7vrRTSkbrsFyF43LpANiU8+WyptofwniyfOnbXIaBLtzmIQxZ7Beu/BopTTRlF2wKAj751EnVXrr1JgaDtOmCk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39850400004)(136003)(396003)(376002)(366004)(451199015)(91956017)(41300700001)(66556008)(31686004)(186003)(5660300002)(64756008)(66476007)(7416002)(4326008)(76116006)(66946007)(66446008)(44832011)(54906003)(38070700005)(8676002)(122000001)(110136005)(8936002)(316002)(2906002)(86362001)(38100700002)(966005)(71200400001)(6486002)(478600001)(36756003)(31696002)(53546011)(26005)(6506007)(66574015)(2616005)(6512007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rk01SmE5TjVKUjNncmhLa1o5eStoY1JESnhqTjFpd0t2T2pGYkNmazZXeFla?=
 =?utf-8?B?WnlZdnVlOHVoRHA0bXErYllsbVZIaVdNWjBHeXRNbzl0K2JRM01DckxnNFlw?=
 =?utf-8?B?eDRaSUY1eS80TG1QbDBkQWxQeHFjT1NGclpSMTY4M3ZOMUkwV0t0azRobDcz?=
 =?utf-8?B?Zk5mUmsxc3lmajM2K1pqZ3VJdXRteDJUdHpkRHFsc1ovR0QwSjRsTVpwZnBo?=
 =?utf-8?B?MTRhSmFiRzA0LzdNMUQ4SVI3WUR1YktUTUpha2o1aWlGSExtbTFHdHJnMHZy?=
 =?utf-8?B?M1U1UCtET1NUUlFKMXF6QmZGNDV0WTVJcFE1ampmMDZOK0pXTVdmYjF6bEt0?=
 =?utf-8?B?ZU9ONXJIcTE2NkhzTmw5ekQyTzhYNEJ2aytYWklyU2lXaXpLWWpUR01XcW82?=
 =?utf-8?B?RTBITWsxQ3VhcDFTMER1MWVvMmNtUjJIT0RHbTNJK3gvK28yTldNd1I1aStv?=
 =?utf-8?B?VmFhRVBOZUF5STB6TnQ4Q1Z6MVFTQ3hxL255SEw5VW9sY0M3UFZuTVhyK3Z2?=
 =?utf-8?B?NC8yVjd6SkFZbWhGSXRqZlhzenRZblM5VmIxSWZ1UnhVZXJGNlVMd0VHa0N4?=
 =?utf-8?B?cy9MR2U4NnFzZU5CTmxuaVhuN25yU1NnOWQvMmcwWSs5dHZneStsNlpqVjNi?=
 =?utf-8?B?WjVORndRMzNvQ01OTlhEMisxU3hBendkQ2RkMkdYU0VOWUdiUGh4ZndEalpO?=
 =?utf-8?B?dXVTSS9ZcG1ncUE5V1VodFFMSTNlZmlKN1dUWTZRL1Fhc3NFMXVrNlQvc2Y2?=
 =?utf-8?B?eUUrR0lsK0swVlpDSzFWNm10MnJNaHpOa0tWUE1mSmZjVUhuQnlKRVQrcU5m?=
 =?utf-8?B?R0twOEVxK1BCUXJZQnUwcFZrNUJzZDZ4RnQ0K1VscGJ6eGcvWCtjMFZSazlD?=
 =?utf-8?B?Zkg5alJLaUFMM2M2Nm80a1MrWUtoemFEa21rbVpQVjNEc3Z1YTh6aUxQdzRp?=
 =?utf-8?B?R3gyRkkwd3A2Tk9IdWZybnI4QmRscCt1RVZoTEh6dEVYb0dUZzdlaTN5VnQy?=
 =?utf-8?B?bzlGOVF2MDdrL1JXNWYyTTdWVjE2ZGFvSUswTXdtbGlTNHQ2ckhXbkZaV01F?=
 =?utf-8?B?ODR0Q3ZiZHJlaGdta2NaVURMb1ZORVErZlhGcHAzN2xDU3gwUmEzMW9aTXRR?=
 =?utf-8?B?WXBpSnp6Lzhpa0JXS0hwbDh2RVFqNVV1VjBhWXVZUk1wL3JyNjU3RnY4OUFl?=
 =?utf-8?B?em1xSWFPQURBMDlreGZNeUI5RnNzZEM4MmNpcXJjcEZJc3lOSG5LcXF4cEls?=
 =?utf-8?B?cDFQejdhaVFWQmlDTEU2enE0b296WEpYaTB3VmxWaWpMemdLdUJoc01VaEtY?=
 =?utf-8?B?OFlXTFpHQ3J1WnJ2RDFvQjNBYTAwbVF1Uk4xSVlJTjZrZHN2VUM5RHhhRU16?=
 =?utf-8?B?dEdoSDZ3eDFROStZUW1mb0U1QW9icm1yUkFaMEpiYXlSK0w5enE4alNoWExj?=
 =?utf-8?B?aWl3ZlZhNzlsbkx1TG9SQTNxQ0RRbmsrL2ZhK3VMeVpNa2F6cVB0SkxLd3hW?=
 =?utf-8?B?MUxJR0ZacDluZ3RXanhVWC9DS1A4SHlYSXJHeUVqbHRWa09TU3c3NWxTbk9P?=
 =?utf-8?B?VzlMdVlsRnNKVzhNZVFFeTlWZ08zNkQ1czViSE9WY1pqS3BXR2wyZ0RlL2sw?=
 =?utf-8?B?OGhFejV0bWw2VVN0RktmdEJkcGlMMm5KT3dyeCswUnlnaE1Oc2svQ2tXVmZT?=
 =?utf-8?B?cGtGZlZvY21SNkxvSlpHTk1xbC9sN1BJb2Vtbmw5WjJLMHhub3pqMmZuNWI2?=
 =?utf-8?B?WEpWTDl6djFtckh4dnhGeExmRXdudTNRM0lYak95TzkzWHdhaGV1a3NyVkl5?=
 =?utf-8?B?N2J1ZFlRVkgwN0NDUThSeitUSFhQVWxKdVplQjhMTk5MVDYzWGU5d0h1UmFo?=
 =?utf-8?B?cFVOWEVTYUJZdDBaU2pKZGVKUE1HY3RSZXNLTFlONGNYeUhuSGswTlBoYjlp?=
 =?utf-8?B?QjUyU2lVSHRuOCtzUE9FeTZOaDkzcGprK3ZaSGRsQXBaWVNacWdDb1lWTGJS?=
 =?utf-8?B?LzJjekJYR2FlWjB5bk9ldzNyUUNJYmZCTUcvTTJhSWEyV3hyRTQ3ZDQ0aG9W?=
 =?utf-8?B?L3VYOWhYR2dMS3Q5c2E4QXVUVitLSkRxSk9WekNTamlENi9MbTZuejNnVDdy?=
 =?utf-8?B?OWZWdXhYMUVwa2FabERSa3lFWDdIY29qZ3lyN0ZDME9oekdPRml6RVNDN0hD?=
 =?utf-8?B?R1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC78B1B8BFF13846BFD4618C43F5E0D6@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b6a8cb2e-e95d-487b-a595-08daf85caa21
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2023 07:30:10.1046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yeW8mL1sjRboug0cMdF/Vx6jKjhrU/7p9r1Cvl+/xsnHDj7jXKK4Y9cxuU2LymCV9bHwuHRLpn8OdaxIrhLCp/6WmOGXfk/Z4NskaI9XTFQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB2033
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDE3LzAxLzIwMjMgw6AgMDY6MzAsIFRvbmdoYW8gWmhhbmcgYSDDqWNyaXTCoDoNCj4g
DQo+IA0KPj4gT24gSmFuIDksIDIwMjMsIGF0IDQ6MTUgUE0sIENocmlzdG9waGUgTGVyb3kgPGNo
cmlzdG9waGUubGVyb3lAY3Nncm91cC5ldT4gd3JvdGU6DQo+Pg0KPj4NCj4+DQo+PiBMZSAwNi8w
MS8yMDIzIMOgIDE2OjM3LCBEYW5pZWwgQm9ya21hbm4gYSDDqWNyaXQgOg0KPj4+IE9uIDEvNS8y
MyA2OjUzIFBNLCBDaHJpc3RvcGhlIExlcm95IHdyb3RlOg0KPj4+PiBMZSAwNS8wMS8yMDIzIMOg
IDA0OjA2LCB0b25nQGluZnJhZ3JhZi5vcmcgYSDDqWNyaXQgOg0KPj4+Pj4gRnJvbTogVG9uZ2hh
byBaaGFuZyA8dG9uZ0BpbmZyYWdyYWYub3JnPg0KPj4+Pj4NCj4+Pj4+IFRoZSB4ODZfNjQgY2Fu
J3QgZHVtcCB0aGUgdmFsaWQgaW5zbiBpbiB0aGlzIHdheS4gQSB0ZXN0IEJQRiBwcm9nDQo+Pj4+
PiB3aGljaCBpbmNsdWRlIHN1YnByb2c6DQo+Pj4+Pg0KPj4+Pj4gJCBsbHZtLW9iamR1bXAgLWQg
c3VicHJvZy5vDQo+Pj4+PiBEaXNhc3NlbWJseSBvZiBzZWN0aW9uIC50ZXh0Og0KPj4+Pj4gMDAw
MDAwMDAwMDAwMDAwMCA8c3VicHJvZz46DQo+Pj4+PiAgICAgICAgICAgMDogICAgICAgMTggMDEg
MDAgMDAgNzMgNzUgNjIgNzAgMDAgMDAgMDAgMDAgNzIgNmYgNjcgMDAgcjENCj4+Pj4+ID0gMjkx
MTQ0NTk5MDM2NTMyMzUgbGwNCj4+Pj4+ICAgICAgICAgICAyOiAgICAgICA3YiAxYSBmOCBmZiAw
MCAwMCAwMCAwMCAqKHU2NCAqKShyMTAgLSA4KSA9IHIxDQo+Pj4+PiAgICAgICAgICAgMzogICAg
ICAgYmYgYTEgMDAgMDAgMDAgMDAgMDAgMDAgcjEgPSByMTANCj4+Pj4+ICAgICAgICAgICA0OiAg
ICAgICAwNyAwMSAwMCAwMCBmOCBmZiBmZiBmZiByMSArPSAtOA0KPj4+Pj4gICAgICAgICAgIDU6
ICAgICAgIGI3IDAyIDAwIDAwIDA4IDAwIDAwIDAwIHIyID0gOA0KPj4+Pj4gICAgICAgICAgIDY6
ICAgICAgIDg1IDAwIDAwIDAwIDA2IDAwIDAwIDAwIGNhbGwgNg0KPj4+Pj4gICAgICAgICAgIDc6
ICAgICAgIDk1IDAwIDAwIDAwIDAwIDAwIDAwIDAwIGV4aXQNCj4+Pj4+IERpc2Fzc2VtYmx5IG9m
IHNlY3Rpb24gcmF3X3RwL3N5c19lbnRlcjoNCj4+Pj4+IDAwMDAwMDAwMDAwMDAwMDAgPGVudHJ5
PjoNCj4+Pj4+ICAgICAgICAgICAwOiAgICAgICA4NSAxMCAwMCAwMCBmZiBmZiBmZiBmZiBjYWxs
IC0xDQo+Pj4+PiAgICAgICAgICAgMTogICAgICAgYjcgMDAgMDAgMDAgMDAgMDAgMDAgMDAgcjAg
PSAwDQo+Pj4+PiAgICAgICAgICAgMjogICAgICAgOTUgMDAgMDAgMDAgMDAgMDAgMDAgMDAgZXhp
dA0KPj4+Pj4NCj4+Pj4+IGtlcm5lbCBwcmludCBtZXNzYWdlOg0KPj4+Pj4gWyAgNTgwLjc3NTM4
N10gZmxlbj04IHByb2dsZW49NTEgcGFzcz0zIGltYWdlPWZmZmZmZmZmYTAwMGMyMGMNCj4+Pj4+
IGZyb209a3Byb2JlLWxvYWQgcGlkPTE2NDMNCj4+Pj4+IFsgIDU4MC43NzcyMzZdIEpJVCBjb2Rl
OiAwMDAwMDAwMDogY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MgY2MNCj4+Pj4+IGNjIGNj
IGNjIGNjIGNjDQo+Pj4+PiBbICA1ODAuNzc5MDM3XSBKSVQgY29kZTogMDAwMDAwMTA6IGNjIGNj
IGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjIGNjDQo+Pj4+PiBjYyBjYyBjYyBjYyBjYw0KPj4+Pj4g
WyAgNTgwLjc4MDc2N10gSklUIGNvZGU6IDAwMDAwMDIwOiBjYyBjYyBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYw0KPj4+Pj4gY2MgY2MgY2MgY2MgY2MNCj4+Pj4+IFsgIDU4MC43ODI1NjhdIEpJ
VCBjb2RlOiAwMDAwMDAzMDogY2MgY2MgY2MNCj4+Pj4+DQo+Pj4+PiAkIGJwZl9qaXRfZGlzYXNt
DQo+Pj4+PiA1MSBieXRlcyBlbWl0dGVkIGZyb20gSklUIGNvbXBpbGVyIChwYXNzOjMsIGZsZW46
OCkNCj4+Pj4+IGZmZmZmZmZmYTAwMGMyMGMgKyA8eD46DQo+Pj4+PiAgICAgICAwOiAgIGludDMN
Cj4+Pj4+ICAgICAgIDE6ICAgaW50Mw0KPj4+Pj4gICAgICAgMjogICBpbnQzDQo+Pj4+PiAgICAg
ICAzOiAgIGludDMNCj4+Pj4+ICAgICAgIDQ6ICAgaW50Mw0KPj4+Pj4gICAgICAgNTogICBpbnQz
DQo+Pj4+PiAgICAgICAuLi4NCj4+Pj4+DQo+Pj4+PiBVbnRpbCBicGZfaml0X2JpbmFyeV9wYWNr
X2ZpbmFsaXplIGlzIGludm9rZWQsIHdlIGNvcHkgcndfaGVhZGVyIHRvDQo+Pj4+PiBoZWFkZXIN
Cj4+Pj4+IGFuZCB0aGVuIGltYWdlL2luc24gaXMgdmFsaWQuIEJUVywgd2UgY2FuIHVzZSB0aGUg
ImJwZnRvb2wgcHJvZyBkdW1wIg0KPj4+Pj4gSklUZWQgaW5zdHJ1Y3Rpb25zLg0KPj4+Pg0KPj4+
PiBOQUNLLg0KPj4+Pg0KPj4+PiBCZWNhdXNlIHRoZSBmZWF0dXJlIGlzIGJ1Z2d5IG9uIHg4Nl82
NCwgeW91IHJlbW92ZSBpdCBmb3IgYWxsDQo+Pj4+IGFyY2hpdGVjdHVyZXMgPw0KPj4+Pg0KPj4+
PiBPbiBwb3dlcnBjIGJwZl9qaXRfZW5hYmxlID09IDIgd29ya3MgYW5kIGlzIHZlcnkgdXNlZnVs
bC4NCj4+Pj4NCj4+Pj4gTGFzdCB0aW1lIEkgdHJpZWQgdG8gdXNlIGJwZnRvb2wgb24gcG93ZXJw
Yy8zMiBpdCBkaWRuJ3Qgd29yay4gSSBkb24ndA0KPj4+PiByZW1lbWJlciB0aGUgZGV0YWlscywg
SSB0aGluayBpdCB3YXMgYW4gaXNzdWUgd2l0aCBlbmRpYW5lc3MuIE1heWJlIGl0DQo+Pj4+IGlz
IGZpeGVkIG5vdywgYnV0IGl0IG5lZWRzIHRvIGJlIHZlcmlmaWVkLg0KPj4+Pg0KPj4+PiBTbyBw
bGVhc2UsIGJlZm9yZSByZW1vdmluZyBhIHdvcmtpbmcgYW5kIHVzZWZ1bGwgZmVhdHVyZSwgbWFr
ZSBzdXJlDQo+Pj4+IHRoZXJlIGlzIGFuIGFsdGVybmF0aXZlIGF2YWlsYWJsZSB0byBpdCBmb3Ig
YWxsIGFyY2hpdGVjdHVyZXMgaW4gYWxsDQo+Pj4+IGNvbmZpZ3VyYXRpb25zLg0KPj4+Pg0KPj4+
PiBBbHNvLCBJIGRvbid0IHRoaW5rIGJwZnRvb2wgaXMgdXNhYmxlIHRvIGR1bXAga2VybmVsIEJQ
RiBzZWxmdGVzdHMuDQo+Pj4+IFRoYXQncyB2aXRhbCB3aGVuIGEgc2VsZnRlc3QgZmFpbHMgaWYg
eW91IHdhbnQgdG8gaGF2ZSBhIGNoYW5jZSB0bw0KPj4+PiB1bmRlcnN0YW5kIHdoeSBpdCBmYWls
cy4NCj4+Pg0KPj4+IElmIHRoaXMgaXMgYWN0aXZlbHkgdXNlZCBieSBKSVQgZGV2ZWxvcGVycyBh
bmQgY29uc2lkZXJlZCB1c2VmdWwsIEknZCBiZQ0KPj4+IG9rIHRvIGxlYXZlIGl0IGZvciB0aGUg
dGltZSBiZWluZy4gT3ZlcmFsbCBnb2FsIGlzIHRvIHJlYWNoIGZlYXR1cmUgcGFyaXR5DQo+Pj4g
YW1vbmcgKGF0IGxlYXN0IG1ham9yIGFyY2gpIEpJVHMgYW5kIG5vdCBqdXN0IGhhdmUgbW9zdCBm
dW5jdGlvbmFsaXR5IG9ubHkNCj4+PiBhdmFpbGFibGUgb24geDg2LTY0IEpJVC4gQ291bGQgeW91
IGhvd2V2ZXIgY2hlY2sgd2hhdCBpcyBub3Qgd29ya2luZyB3aXRoDQo+Pj4gYnBmdG9vbCBvbiBw
b3dlcnBjLzMyPyBQZXJoYXBzIGl0J3Mgbm90IHRvbyBtdWNoIGVmZm9ydCB0byBqdXN0IGZpeCBp
dCwNCj4+PiBidXQgZGV0YWlscyB3b3VsZCBiZSB1c2VmdWwgb3RoZXJ3aXNlICdpdCBkaWRuJ3Qg
d29yaycgaXMgdG9vIGZ1enp5Lg0KPj4NCj4+IFN1cmUgSSB3aWxsIHRyeSB0byB0ZXN0IGJwZnRv
b2wgYWdhaW4gaW4gdGhlIGNvbWluZyBkYXlzLg0KPj4NCj4+IFByZXZpb3VzIGRpc2N1c3Npb24g
YWJvdXQgdGhhdCBzdWJqZWN0IGlzIGhlcmU6DQo+PiBodHRwczovL3BhdGNod29yay5rZXJuZWwu
b3JnL3Byb2plY3QvbGludXgtcmlzY3YvcGF0Y2gvMjAyMTA0MTUwOTMyNTAuMzM5MTI1Ny0xLUpp
YW5saW4uTHZAYXJtLmNvbS8jMjQxNzY4NDc9DQo+IEhpIENocmlzdG9waGUNCj4gQW55IHByb2dy
ZXNzPyBXZSBkaXNjdXNzIHRvIGRlcHJlY2F0ZSB0aGUgYnBmX2ppdF9lbmFibGUgPT0gMiBpbiAy
MDIxLCBidXQgYnBmdG9vbCBjYW4gbm90IHJ1biBvbiBwb3dlcnBjLg0KPiBOb3cgY2FuIHdlIGZp
eCB0aGlzIGlzc3VlPw0KDQpIaSBUb25nLA0KDQpJIGhhdmUgc3RhcnRlZCB0byBsb29rIGF0IGl0
IGJ1dCBJIGRvbid0IGhhdmUgYW55IGZydWl0ZnVsbCBmZWVkYmFjayB5ZXQuDQoNCkluIHRoZSBt
ZWFudGltZSwgd2VyZSB5b3UgYWJsZSB0byBjb25maXJtIHRoYXQgYnBmdG9vbCBjYW4gYWxzbyBi
ZSB1c2VkIA0KdG8gZHVtcCBqaXR0ZWQgdGVzdHMgZnJvbSB0ZXN0X2JwZi5rbyBtb2R1bGUgb24g
eDg2XzY0ID8gSW4gdGhhdCBjYW4geW91IA0KdGVsbCBtZSBob3cgdG8gcHJvY2VlZCA/DQoNClRo
YW5rcw0KQ2hyaXN0b3BoZQ0KDQo+Pg0KPj4+DQo+Pj4gQWxzbywgd2l0aCByZWdhcmRzIHRvIHRo
ZSBsYXN0IHN0YXRlbWVudCB0aGF0IGJwZnRvb2wgaXMgbm90IHVzYWJsZSB0bw0KPj4+IGR1bXAg
a2VybmVsIEJQRiBzZWxmdGVzdHMuIENvdWxkIHlvdSBlbGFib3JhdGUgc29tZSBtb3JlPyBJIGhh
dmVuJ3QgdXNlZA0KPj4+IGJwZl9qaXRfZW5hYmxlID09IDIgaW4gYSBsb25nIHRpbWUgYW5kIGZv
ciBkZWJ1Z2dpbmcgYWx3YXlzIHJlbGllZCBvbg0KPj4+IGJwZnRvb2wgdG8gZHVtcCB4bGF0ZWQg
aW5zbnMgb3IgSklULiBPciBkbyB5b3UgbWVhbiBieSBCUEYgc2VsZnRlc3RzDQo+Pj4gdGhlIHRl
c3RfYnBmLmtvIG1vZHVsZT8gR2l2ZW4gaXQgaGFzIGEgYmlnIGJhdGNoIHdpdGgga2VybmVsLW9u
bHkgdGVzdHMsDQo+Pj4gdGhlcmUgSSBjYW4gc2VlIGl0J3MgcHJvYmFibHkgc3RpbGwgdXNlZnVs
Lg0KPj4NCj4+IFllcyBJIG1lYW4gdGVzdF9icGYua28NCj4+DQo+PiBJIHVzZWQgaXQgYXMgdGhl
IHRlc3QgYmFzaXMgd2hlbiBJIGltcGxlbWVudGVkIGVCUEYgZm9yIHBvd2VycGMvMzIuIEFuZA0K
Pj4gbm90IHNvIGxvbmcgYWdvIGl0IGhlbHBlZCBkZWNvdmVyIGFuZCBmaXggYSBidWcsIHNlZQ0K
Pj4gaHR0cHM6Ly9naXRodWIuY29tL3RvcnZhbGRzL2xpbnV4L2NvbW1pdC84OWQyMWUyNTlhOTRm
N2Q1NTgyZWM2NzVhYTQ0NWY1YTc5ZjM0N2U0DQo+Pg0KPj4+DQo+Pj4gQ2hlZXJzLA0KPj4+IERh
bmllbA0KPiANCg==
