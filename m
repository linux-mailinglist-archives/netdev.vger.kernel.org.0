Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3B76775FC
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 09:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjAWIBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 03:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbjAWIBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 03:01:01 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on2089.outbound.protection.outlook.com [40.107.12.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDD212045;
        Mon, 23 Jan 2023 00:00:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdQhD6dgQjD6saljmDr8qnrxpWDrjgbPemOufHPv5chs97xYl1ovB8FVbrOD60o8gzAIZ0ok+IU80FcoRYmrwFx0OzDDAWYLCefwthsi+zPfcA/hSw5uy1gJUWatOYRiiK6HgD4BeOZZvbnmlj0Bfcv9YjnCOm4SxM8gbH9Bi/GllcgNzD+tcgMPLwPbfx9RpkntPJvSOZk8EYdJ6sCEPyn3NGiyKDR4vR6mv1H10Ls3yEvKiyOFMpcWnTSbJVSo+fWhPMAJ0UGns2T1eIgZSUmnl6R9lSi2SfYpGlQ4bos9iEkrzFZWfqMFuPX4YhIGECxXulITJCYzauVAd6ohjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q6YePFkniL7j7C3VjyGTGsPYp/v9LFdpPOu1kRMzWKg=;
 b=NmifLICLZwpsgMP5LNhq8z4+gI1OYY6pxIBjkP7PNwvEFpX/l8waws19cSxxHDm1cKsOPyrbsfA0uDIp+jaIYQlNxtMZduz+gcYjHjdkRzdoYmec4hdROxakiZkyVE+R06m82RDB/hwaN8E88FY4MkTdeE8DRf1ZavyvprgmntZXCoszOIuVJj+PjOrf+5/woo6O5sQRtLL4fh+ECAnrPk3SqYTc4e5cVziCQ5XPKKAuaVc1eTjifJoH/HHBXx6+T7rCEKKiJvOE0Qiw9Elen8ezLYjXwPj+AvvBQi5bJXbKcBSyqyyJ+r3ayAEa7rg+IXZrNVgQ05XxduqpdZIV5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=csgroup.eu;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6YePFkniL7j7C3VjyGTGsPYp/v9LFdpPOu1kRMzWKg=;
 b=090yUPjj2irT1BuLfQfjE2eV/ljhQzVUVBx7VuXgTcMvCpfjo8t2ocMKWr0Ywbpr5M6eUsxT0jwSB9n0L0YCOZUvPZQjcNZ4SvHGilguRwIDLMqktnysfTbdEkPZTInexyQkJmgKwgemwo6E+iaX69zVfLetSoN6+18NonCafIhZct/MDxFZ644vl6qyLEUmDWmmTU6MFIT0qA3jq36gWleuljXnXox4vt7wAZZTJQJ7L5F9FUVWekaWSsYxuO4kNorFgvx0gzRylo8EBttshfzE5NttiH1/X4hzFwiAdZmHwDdh5nWU79r+H90/0jfEhsDrmIp5nu2vMgUQQ08OlQ==
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB1533.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 08:00:51 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::2cfb:d4c:1932:b097%4]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 08:00:51 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Tonghao Zhang <tong@infragraf.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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
Thread-Index: AQHZILjtdiBl24vDM0uhRRtlAlrCCa6QG7gAgAFsaoCABDtogIAMZLqAgAAhWICAAHMhgIAAGywAgACreICAAAJmAIAAV8iAgACpXYCABzlAgA==
Date:   Mon, 23 Jan 2023 08:00:51 +0000
Message-ID: <accf139f-de37-d1df-afa5-1fc426f86017@csgroup.eu>
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
 <d807b7fb-dbd2-8e4c-812c-48a1a01c190e@csgroup.eu>
 <CAADnVQKAAhbL-9qGPfRFsfw3oh6KnrEpeYLnfhrKUSzX8VmFuQ@mail.gmail.com>
In-Reply-To: <CAADnVQKAAhbL-9qGPfRFsfw3oh6KnrEpeYLnfhrKUSzX8VmFuQ@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MRZP264MB2988:EE_|PR1P264MB1533:EE_
x-ms-office365-filtering-correlation-id: 464facea-39fe-4929-3406-08dafd17f22d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MVjdJyD7Sg0UrHM/pXLpdc1a3nauF8HnpMqx/85jq88evC2KpvaZEwwyXxYTfVYgyUrlMsDNKuCHgkPLMu7JrC2okBxZfyxiboAXBdCxoTiNSRCkP3PgQcWItRtD/pgkFsiogoOlOBNJV/f/y4rHjxSRUyGTQziXS/f9aT4oCaBqbZdtTGvpJxZG3WvYJb6xF9JnF+ZYAlJOb60HiuMGQuslYdKCBpnvxWqvZFANlXP1o1lOL96c4f1A/3oJKSoUrJd2rz0HzSa0VsObMV0kpoDmhUpF9MG7/NXAX2iTaWZ4cyRu2NLzcngyRGNA9OSSp5pMeDxuNfLa1uaAIcZjD2MVygOweP0ti77yI/6mVszOMbmjM7lG0rh5xSxKBOurqaGIN6Fa0x9I582d5rMRk0ClVGDZWmi45/5t6ujbT6uLNvllEblDDI78tZrVyKW086SChETRd8Z2SJhM1B9ANXCG3P7CxEBM2yOpLXYGTLWwOuiEHel4IOgM9h/cI4EeUYPmW1nR3L0V0pciTLFqVHpMDSAEY1t+bEkjUNOCSe6iMc1G8xxSnKwj2lkUCEY2+aD67QDNgxFEvNnwqmpxaJIHo7cd0OuUDhiuS5RDy9p9bEvcbEbFzAYK02GUyEUodhMwFKsYrGmqdy6wL8ORZ2E6kIEdjB3jGkLlz0mUJa0zRDIoezF5vcLrK0FG7EAFbJyDmKI89qOU811pLO0ufKsuO8pbiBsL4vCeol8zYw1RVkoNERWO9+PixAB6uRYVesXANAAVpfzFz1dYXmYneOjrM0GQJwyYVUBBCP4cjhA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(39850400004)(376002)(346002)(451199015)(122000001)(38100700002)(36756003)(31696002)(86362001)(478600001)(38070700005)(316002)(54906003)(6486002)(64756008)(66446008)(6916009)(76116006)(66946007)(8676002)(66556008)(4326008)(66476007)(966005)(66574015)(2616005)(91956017)(31686004)(71200400001)(53546011)(2906002)(6506007)(83380400001)(6512007)(186003)(7416002)(26005)(41300700001)(5660300002)(44832011)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGNvb0gwWGZpNGRkemY1WXBnNVM1R1pFRmI3SnpNbWVFWnhNV1RZeXRUdzNk?=
 =?utf-8?B?TzZWSEZuc1ZpUC9Na3ZCMmQ3MFZrdG1SK1F4dUdpSU0xZUxNdnM1Y0l0YllS?=
 =?utf-8?B?OWE0SENtOElrU3hMRmRHeEx5allFWW5rZGtrNmpPNnpjRG15Y1hYaVdkaUxS?=
 =?utf-8?B?S1dSYSsvekQ3S01uNDE5QXRCMnYxaldjdTRUOHJQZHdPaGZ2TW9XMVplZ3VN?=
 =?utf-8?B?YXR0NDV5WDdHOFhGajc5TnJ1ZW8ySlQ0MnhNd2ZBTlBVeXN1V0ZCZlBzOU1j?=
 =?utf-8?B?NnkzWmlZYUJiY0dCUUl5Tks3d1loVXMvR0pQY1FwVXFMSTJmUUdHcGxhNVh5?=
 =?utf-8?B?V05INURXMXBWeG9UbmFuVk03bW9tUTN4Q3gvb0M0MEpXSUhhYmxXVVZKZkRp?=
 =?utf-8?B?Q0dHTmhvd3B3RmxaNVBEdG52VFp0RXBZSmlqVDVBZ041eHVFckhRbTNTVzNS?=
 =?utf-8?B?eHpBQmRUajlXMG4rZ2pFbVRZVTZ1VVpRL1NYMHhnclZlNjdYNjRudDdkVXFv?=
 =?utf-8?B?VWlGZUpWMmY5a1FndVZPcFNmZ29Iek4rSStGN25VT0VqQ3QyUE1NTHY3UXFT?=
 =?utf-8?B?YUpoRG90Vm5GckZVSHdCTmpXWG5BV2NBM2dyMlN0Q1hyVFZCSXFHUEN4dy9N?=
 =?utf-8?B?WDVtWS9ESDRvWGlYOWFXU3dJNXZJTDJmU1Y0L3VnOEk4TSszcm83SXhHVTA4?=
 =?utf-8?B?MkRqMERCQ3NUcUY5eUZkVjR6SG1NZFA0SGpubzBIQlB2blF1czlFME9YVmxn?=
 =?utf-8?B?WHl3Sm1MUkkxRUhvd1BqUWpaeGFxbDZMZjFOT0hucTZsVVVpZzRmZnByVDRj?=
 =?utf-8?B?VWZxWG1nTlBXSnhWWkwzSXlwUHFTL1ppM3BGdGJwenhOWTNzZGlyMXdSdTUr?=
 =?utf-8?B?YUVnOGVWWGVCcjI0bmp1OUhVUzFxQ054bzBoY3k2VmJjYnJ5MHZGWHpodGcr?=
 =?utf-8?B?YjdHUTZmeXR6RXdYeFhyWit5VkhMcXBKMHYrODhzaGN2NjVOWDdRYk9yVTdU?=
 =?utf-8?B?R25MUTFiUjNsanBnWHBhalNycklqWUQ3OHlnU3RaTFp3em92blE1MFplWjVU?=
 =?utf-8?B?dW85L2Npd2FBSSsxaUwxclNrTk9td0lXWHB0MDA2aG5FSnJ1SkZTS2xrQ2Fn?=
 =?utf-8?B?NDNTK1hPakdQZldFbkhxSjlYdVovQkExUGxUVnJuREpCR0gySW1GVlphRUkz?=
 =?utf-8?B?czBPdzlFY0Y4dnhvWDJxRWliR0s5eVNEc0NzRi9tVjBsM2NLM1NnOFFqQUEx?=
 =?utf-8?B?TTM4dzQ0QlF3eGtlV2d5bFlVMnBXVnBibWJDWTZVS0xOV0ZVd01JSm4xTW02?=
 =?utf-8?B?WTcyZmVyV0ZNUGtmbnI1ejYzSldXY0FKMWFJcHlrWkp3U1NMRU4yRVJzaFlR?=
 =?utf-8?B?aTJ5NERSblI0dTh2QndvUTMzQkt3VEpVa2xMdlJhRlNoNGpaWXRmSWJyT3h5?=
 =?utf-8?B?S3ZkSFFLbkhuTEhRa0xqTXlSait2dnZicUlacmNneTJYTGwxczFKNjhlc241?=
 =?utf-8?B?blAyekRvY1RNbjY1RVJ5Ulk0aWZwYmNjRlFzZGpzZXQ3eWlQWE9yNWVickVp?=
 =?utf-8?B?TWJmcnlRTWRrQlV2ZTNZc3lOQSthdU1zWE54UTZNaGVodGloWi9uWkZSTFpj?=
 =?utf-8?B?KzNrYW51SHFQK3BpVC9vSlZUR0JiTFptMjZSSHFOeUthWE5SSTNUbThDcU4z?=
 =?utf-8?B?U3BqNnBYSzhOUHFYakVCQ21laEY5UGZUYWNGSEFxRHRqWTVBSzVlRTBVeHhk?=
 =?utf-8?B?Q2RzTEZiM1dDWm4vU0NXcm14OFM0MVRhc0NMUm9wT1JDUW5MNENPN09xQnZ1?=
 =?utf-8?B?eGo1K215U0lzdU5VUUY2WUlFV1hwWlI2N1Nmek55VUhIZ0MvM1J3ZGw3T3A3?=
 =?utf-8?B?VjUrdVp0WHpPV0pTUDRpQUJ6WHJPdE5hdytwc3FYZ29tNjBwWWU0K0FmT0tF?=
 =?utf-8?B?S2RuZjNNRUhEY1BjL2ZacmJNMGRTL2FLN21yYXBKMk1aOEl6eGdyMmVzbDV1?=
 =?utf-8?B?S3ZpQ1R4cVdFbS94bVB1dFdROEdqeWFpYmtjZ0pmeU1PSDZud1hJUHdLdjVh?=
 =?utf-8?B?WGxYaWtRclJ3bmJnY0EyV3NOTGQvZGxqQWRPTjllbzFRUkRiQWswOVczeVBp?=
 =?utf-8?B?U0s3R3FLeXhQR1NxZXA5d1RoTytSaWlFb3V4UlhLRGF3REZNWDZ0aXlhNDZE?=
 =?utf-8?B?cnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C05FDF437055694092E0C37BA49A9762@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 464facea-39fe-4929-3406-08dafd17f22d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 08:00:51.5314
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HoVmkqd/OFgtMjowSP8jDQidgTYmlXpkMuK+sngByD/CeBkoJewCZ97mICnQKmK25PyJf6Wofc22lYGKkv2DKqIm2+t9vXVmJgdwY6mcy3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB1533
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCkxlIDE4LzAxLzIwMjMgw6AgMTg6NDIsIEFsZXhlaSBTdGFyb3ZvaXRvdiBhIMOpY3JpdMKg
Og0KPiBPbiBUdWUsIEphbiAxNywgMjAyMyBhdCAxMTozNiBQTSBDaHJpc3RvcGhlIExlcm95DQo+
IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+IHdyb3RlOg0KPj4NCj4+DQo+Pg0KPj4gTGUg
MTgvMDEvMjAyMyDDoCAwMzoyMSwgQWxleGVpIFN0YXJvdm9pdG92IGEgw6ljcml0IDoNCj4+PiBP
biBUdWUsIEphbiAxNywgMjAyMyBhdCA2OjEzIFBNIFRvbmdoYW8gWmhhbmcgPHRvbmdAaW5mcmFn
cmFmLm9yZz4gd3JvdGU6DQo+Pj4+DQo+Pj4+DQo+Pj4+DQo+Pj4+PiBPbiBKYW4gMTcsIDIwMjMs
IGF0IDExOjU5IFBNLCBEYW5pZWwgQm9ya21hbm4gPGRhbmllbEBpb2dlYXJib3gubmV0PiB3cm90
ZToNCj4+Pj4+DQo+Pj4+PiBPbiAxLzE3LzIzIDM6MjIgUE0sIFRvbmdoYW8gWmhhbmcgd3JvdGU6
DQo+Pj4+Pj4+IE9uIEphbiAxNywgMjAyMywgYXQgMzozMCBQTSwgQ2hyaXN0b3BoZSBMZXJveSA8
Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1PiB3cm90ZToNCj4+Pj4+Pj4NCj4+Pj4+Pj4NCj4+
Pj4+Pj4NCj4+Pj4+Pj4gTGUgMTcvMDEvMjAyMyDDoCAwNjozMCwgVG9uZ2hhbyBaaGFuZyBhIMOp
Y3JpdCA6DQo+Pj4+Pj4+Pg0KPj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBPbiBKYW4gOSwgMjAyMywgYXQg
NDoxNSBQTSwgQ2hyaXN0b3BoZSBMZXJveSA8Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1PiB3
cm90ZToNCj4+Pj4+Pj4+Pg0KPj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBMZSAwNi8w
MS8yMDIzIMOgIDE2OjM3LCBEYW5pZWwgQm9ya21hbm4gYSDDqWNyaXQgOg0KPj4+Pj4+Pj4+PiBP
biAxLzUvMjMgNjo1MyBQTSwgQ2hyaXN0b3BoZSBMZXJveSB3cm90ZToNCj4+Pj4+Pj4+Pj4+IExl
IDA1LzAxLzIwMjMgw6AgMDQ6MDYsIHRvbmdAaW5mcmFncmFmLm9yZyBhIMOpY3JpdCA6DQo+Pj4+
Pj4+Pj4+Pj4gRnJvbTogVG9uZ2hhbyBaaGFuZyA8dG9uZ0BpbmZyYWdyYWYub3JnPg0KPj4+Pj4+
Pj4+Pj4+DQo+Pj4+Pj4+Pj4+Pj4gVGhlIHg4Nl82NCBjYW4ndCBkdW1wIHRoZSB2YWxpZCBpbnNu
IGluIHRoaXMgd2F5LiBBIHRlc3QgQlBGIHByb2cNCj4+Pj4+Pj4+Pj4+PiB3aGljaCBpbmNsdWRl
IHN1YnByb2c6DQo+Pj4+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+Pj4+PiAkIGxsdm0tb2JqZHVtcCAtZCBz
dWJwcm9nLm8NCj4+Pj4+Pj4+Pj4+PiBEaXNhc3NlbWJseSBvZiBzZWN0aW9uIC50ZXh0Og0KPj4+
Pj4+Pj4+Pj4+IDAwMDAwMDAwMDAwMDAwMDAgPHN1YnByb2c+Og0KPj4+Pj4+Pj4+Pj4+ICAgICAg
ICAgICAgMDogICAgICAgMTggMDEgMDAgMDAgNzMgNzUgNjIgNzAgMDAgMDAgMDAgMDAgNzIgNmYg
NjcgMDAgcjENCj4+Pj4+Pj4+Pj4+PiA9IDI5MTE0NDU5OTAzNjUzMjM1IGxsDQo+Pj4+Pj4+Pj4+
Pj4gICAgICAgICAgICAyOiAgICAgICA3YiAxYSBmOCBmZiAwMCAwMCAwMCAwMCAqKHU2NCAqKShy
MTAgLSA4KSA9IHIxDQo+Pj4+Pj4+Pj4+Pj4gICAgICAgICAgICAzOiAgICAgICBiZiBhMSAwMCAw
MCAwMCAwMCAwMCAwMCByMSA9IHIxMA0KPj4+Pj4+Pj4+Pj4+ICAgICAgICAgICAgNDogICAgICAg
MDcgMDEgMDAgMDAgZjggZmYgZmYgZmYgcjEgKz0gLTgNCj4+Pj4+Pj4+Pj4+PiAgICAgICAgICAg
IDU6ICAgICAgIGI3IDAyIDAwIDAwIDA4IDAwIDAwIDAwIHIyID0gOA0KPj4+Pj4+Pj4+Pj4+ICAg
ICAgICAgICAgNjogICAgICAgODUgMDAgMDAgMDAgMDYgMDAgMDAgMDAgY2FsbCA2DQo+Pj4+Pj4+
Pj4+Pj4gICAgICAgICAgICA3OiAgICAgICA5NSAwMCAwMCAwMCAwMCAwMCAwMCAwMCBleGl0DQo+
Pj4+Pj4+Pj4+Pj4gRGlzYXNzZW1ibHkgb2Ygc2VjdGlvbiByYXdfdHAvc3lzX2VudGVyOg0KPj4+
Pj4+Pj4+Pj4+IDAwMDAwMDAwMDAwMDAwMDAgPGVudHJ5PjoNCj4+Pj4+Pj4+Pj4+PiAgICAgICAg
ICAgIDA6ICAgICAgIDg1IDEwIDAwIDAwIGZmIGZmIGZmIGZmIGNhbGwgLTENCj4+Pj4+Pj4+Pj4+
PiAgICAgICAgICAgIDE6ICAgICAgIGI3IDAwIDAwIDAwIDAwIDAwIDAwIDAwIHIwID0gMA0KPj4+
Pj4+Pj4+Pj4+ICAgICAgICAgICAgMjogICAgICAgOTUgMDAgMDAgMDAgMDAgMDAgMDAgMDAgZXhp
dA0KPj4+Pj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4+Pj4ga2VybmVsIHByaW50IG1lc3NhZ2U6DQo+Pj4+
Pj4+Pj4+Pj4gWyAgNTgwLjc3NTM4N10gZmxlbj04IHByb2dsZW49NTEgcGFzcz0zIGltYWdlPWZm
ZmZmZmZmYTAwMGMyMGMNCj4+Pj4+Pj4+Pj4+PiBmcm9tPWtwcm9iZS1sb2FkIHBpZD0xNjQzDQo+
Pj4+Pj4+Pj4+Pj4gWyAgNTgwLjc3NzIzNl0gSklUIGNvZGU6IDAwMDAwMDAwOiBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYyBjYw0KPj4+Pj4+Pj4+Pj4+IGNjIGNjIGNjIGNjIGNjDQo+Pj4+
Pj4+Pj4+Pj4gWyAgNTgwLjc3OTAzN10gSklUIGNvZGU6IDAwMDAwMDEwOiBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYyBjYw0KPj4+Pj4+Pj4+Pj4+IGNjIGNjIGNjIGNjIGNjDQo+Pj4+Pj4+
Pj4+Pj4gWyAgNTgwLjc4MDc2N10gSklUIGNvZGU6IDAwMDAwMDIwOiBjYyBjYyBjYyBjYyBjYyBj
YyBjYyBjYyBjYyBjYyBjYw0KPj4+Pj4+Pj4+Pj4+IGNjIGNjIGNjIGNjIGNjDQo+Pj4+Pj4+Pj4+
Pj4gWyAgNTgwLjc4MjU2OF0gSklUIGNvZGU6IDAwMDAwMDMwOiBjYyBjYyBjYw0KPj4+Pj4+Pj4+
Pj4+DQo+Pj4+Pj4+Pj4+Pj4gJCBicGZfaml0X2Rpc2FzbQ0KPj4+Pj4+Pj4+Pj4+IDUxIGJ5dGVz
IGVtaXR0ZWQgZnJvbSBKSVQgY29tcGlsZXIgKHBhc3M6MywgZmxlbjo4KQ0KPj4+Pj4+Pj4+Pj4+
IGZmZmZmZmZmYTAwMGMyMGMgKyA8eD46DQo+Pj4+Pj4+Pj4+Pj4gICAgICAgIDA6ICAgaW50Mw0K
Pj4+Pj4+Pj4+Pj4+ICAgICAgICAxOiAgIGludDMNCj4+Pj4+Pj4+Pj4+PiAgICAgICAgMjogICBp
bnQzDQo+Pj4+Pj4+Pj4+Pj4gICAgICAgIDM6ICAgaW50Mw0KPj4+Pj4+Pj4+Pj4+ICAgICAgICA0
OiAgIGludDMNCj4+Pj4+Pj4+Pj4+PiAgICAgICAgNTogICBpbnQzDQo+Pj4+Pj4+Pj4+Pj4gICAg
ICAgIC4uLg0KPj4+Pj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4+Pj4gVW50aWwgYnBmX2ppdF9iaW5hcnlf
cGFja19maW5hbGl6ZSBpcyBpbnZva2VkLCB3ZSBjb3B5IHJ3X2hlYWRlciB0bw0KPj4+Pj4+Pj4+
Pj4+IGhlYWRlcg0KPj4+Pj4+Pj4+Pj4+IGFuZCB0aGVuIGltYWdlL2luc24gaXMgdmFsaWQuIEJU
Vywgd2UgY2FuIHVzZSB0aGUgImJwZnRvb2wgcHJvZyBkdW1wIg0KPj4+Pj4+Pj4+Pj4+IEpJVGVk
IGluc3RydWN0aW9ucy4NCj4+Pj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4+PiBOQUNLLg0KPj4+Pj4+Pj4+
Pj4NCj4+Pj4+Pj4+Pj4+IEJlY2F1c2UgdGhlIGZlYXR1cmUgaXMgYnVnZ3kgb24geDg2XzY0LCB5
b3UgcmVtb3ZlIGl0IGZvciBhbGwNCj4+Pj4+Pj4+Pj4+IGFyY2hpdGVjdHVyZXMgPw0KPj4+Pj4+
Pj4+Pj4NCj4+Pj4+Pj4+Pj4+IE9uIHBvd2VycGMgYnBmX2ppdF9lbmFibGUgPT0gMiB3b3JrcyBh
bmQgaXMgdmVyeSB1c2VmdWxsLg0KPj4+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+Pj4+IExhc3QgdGltZSBJ
IHRyaWVkIHRvIHVzZSBicGZ0b29sIG9uIHBvd2VycGMvMzIgaXQgZGlkbid0IHdvcmsuIEkgZG9u
J3QNCj4+Pj4+Pj4+Pj4+IHJlbWVtYmVyIHRoZSBkZXRhaWxzLCBJIHRoaW5rIGl0IHdhcyBhbiBp
c3N1ZSB3aXRoIGVuZGlhbmVzcy4gTWF5YmUgaXQNCj4+Pj4+Pj4+Pj4+IGlzIGZpeGVkIG5vdywg
YnV0IGl0IG5lZWRzIHRvIGJlIHZlcmlmaWVkLg0KPj4+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+Pj4+IFNv
IHBsZWFzZSwgYmVmb3JlIHJlbW92aW5nIGEgd29ya2luZyBhbmQgdXNlZnVsbCBmZWF0dXJlLCBt
YWtlIHN1cmUNCj4+Pj4+Pj4+Pj4+IHRoZXJlIGlzIGFuIGFsdGVybmF0aXZlIGF2YWlsYWJsZSB0
byBpdCBmb3IgYWxsIGFyY2hpdGVjdHVyZXMgaW4gYWxsDQo+Pj4+Pj4+Pj4+PiBjb25maWd1cmF0
aW9ucy4NCj4+Pj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4+PiBBbHNvLCBJIGRvbid0IHRoaW5rIGJwZnRv
b2wgaXMgdXNhYmxlIHRvIGR1bXAga2VybmVsIEJQRiBzZWxmdGVzdHMuDQo+Pj4+Pj4+Pj4+PiBU
aGF0J3Mgdml0YWwgd2hlbiBhIHNlbGZ0ZXN0IGZhaWxzIGlmIHlvdSB3YW50IHRvIGhhdmUgYSBj
aGFuY2UgdG8NCj4+Pj4+Pj4+Pj4+IHVuZGVyc3RhbmQgd2h5IGl0IGZhaWxzLg0KPj4+Pj4+Pj4+
Pg0KPj4+Pj4+Pj4+PiBJZiB0aGlzIGlzIGFjdGl2ZWx5IHVzZWQgYnkgSklUIGRldmVsb3BlcnMg
YW5kIGNvbnNpZGVyZWQgdXNlZnVsLCBJJ2QgYmUNCj4+Pj4+Pj4+Pj4gb2sgdG8gbGVhdmUgaXQg
Zm9yIHRoZSB0aW1lIGJlaW5nLiBPdmVyYWxsIGdvYWwgaXMgdG8gcmVhY2ggZmVhdHVyZSBwYXJp
dHkNCj4+Pj4+Pj4+Pj4gYW1vbmcgKGF0IGxlYXN0IG1ham9yIGFyY2gpIEpJVHMgYW5kIG5vdCBq
dXN0IGhhdmUgbW9zdCBmdW5jdGlvbmFsaXR5IG9ubHkNCj4+Pj4+Pj4+Pj4gYXZhaWxhYmxlIG9u
IHg4Ni02NCBKSVQuIENvdWxkIHlvdSBob3dldmVyIGNoZWNrIHdoYXQgaXMgbm90IHdvcmtpbmcg
d2l0aA0KPj4+Pj4+Pj4+PiBicGZ0b29sIG9uIHBvd2VycGMvMzI/IFBlcmhhcHMgaXQncyBub3Qg
dG9vIG11Y2ggZWZmb3J0IHRvIGp1c3QgZml4IGl0LA0KPj4+Pj4+Pj4+PiBidXQgZGV0YWlscyB3
b3VsZCBiZSB1c2VmdWwgb3RoZXJ3aXNlICdpdCBkaWRuJ3Qgd29yaycgaXMgdG9vIGZ1enp5Lg0K
Pj4+Pj4+Pj4+DQo+Pj4+Pj4+Pj4gU3VyZSBJIHdpbGwgdHJ5IHRvIHRlc3QgYnBmdG9vbCBhZ2Fp
biBpbiB0aGUgY29taW5nIGRheXMuDQo+Pj4+Pj4+Pj4NCj4+Pj4+Pj4+PiBQcmV2aW91cyBkaXNj
dXNzaW9uIGFib3V0IHRoYXQgc3ViamVjdCBpcyBoZXJlOg0KPj4+Pj4+Pj4+IGh0dHBzOi8vcGF0
Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC1yaXNjdi9wYXRjaC8yMDIxMDQxNTA5MzI1
MC4zMzkxMjU3LTEtSmlhbmxpbi5MdkBhcm0uY29tLyMyNDE3Njg0Nz0NCj4+Pj4+Pj4+IEhpIENo
cmlzdG9waGUNCj4+Pj4+Pj4+IEFueSBwcm9ncmVzcz8gV2UgZGlzY3VzcyB0byBkZXByZWNhdGUg
dGhlIGJwZl9qaXRfZW5hYmxlID09IDIgaW4gMjAyMSwgYnV0IGJwZnRvb2wgY2FuIG5vdCBydW4g
b24gcG93ZXJwYy4NCj4+Pj4+Pj4+IE5vdyBjYW4gd2UgZml4IHRoaXMgaXNzdWU/DQo+Pj4+Pj4+
DQo+Pj4+Pj4+IEhpIFRvbmcsDQo+Pj4+Pj4+DQo+Pj4+Pj4+IEkgaGF2ZSBzdGFydGVkIHRvIGxv
b2sgYXQgaXQgYnV0IEkgZG9uJ3QgaGF2ZSBhbnkgZnJ1aXRmdWxsIGZlZWRiYWNrIHlldC4NCj4+
Pj4+Pj4NCj4+Pj4+Pj4gSW4gdGhlIG1lYW50aW1lLCB3ZXJlIHlvdSBhYmxlIHRvIGNvbmZpcm0g
dGhhdCBicGZ0b29sIGNhbiBhbHNvIGJlIHVzZWQNCj4+Pj4+Pj4gdG8gZHVtcCBqaXR0ZWQgdGVz
dHMgZnJvbSB0ZXN0X2JwZi5rbyBtb2R1bGUgb24geDg2XzY0ID8gSW4gdGhhdCBjYW4geW91DQo+
Pj4+Pj4+IHRlbGwgbWUgaG93IHRvIHByb2NlZWQgPw0KPj4+Pj4+IE5vdyBJIGRvIG5vdCB0ZXN0
LCBidXQgd2UgY2FuIGR1bXAgdGhlIGluc24gYWZ0ZXIgYnBmX3Byb2dfc2VsZWN0X3J1bnRpbWUg
aW4gdGVzdF9icGYua28uIGJwZl9tYXBfZ2V0X2luZm9fYnlfZmQgY2FuIGNvcHkgdGhlIGluc24g
dG8gdXNlcnNwYWNlLCBidXQgd2UgY2FuDQo+Pj4+Pj4gZHVtcCB0aGVtIGluIHRlc3RfYnBmLmtv
IGluIHRoZSBzYW1lIHdheS4NCj4+Pj4+DQo+Pj4+PiBJc3N1ZSBpcyB0aGF0IHRoZXNlIHByb2dz
IGFyZSBub3QgY29uc3VtYWJsZSBmcm9tIHVzZXJzcGFjZSAoYW5kIHRoZXJlZm9yZSBub3QgYnBm
dG9vbCkuDQo+Pj4+PiBpdCdzIGp1c3Qgc2ltcGxlIGJwZl9wcm9nX2FsbG9jICsgY29weSBvZiB0
ZXN0IGluc25zICsgYnBmX3Byb2dfc2VsZWN0X3J1bnRpbWUoKSB0byB0ZXN0DQo+Pj4+PiBKSVRz
IChzZWUgZ2VuZXJhdGVfZmlsdGVyKCkpLiBTb21lIG9mIHRoZW0gY291bGQgYmUgY29udmVydGVk
IG92ZXIgdG8gdGVzdF92ZXJpZmllciwgYnV0DQo+Pj4+PiBub3QgYWxsIG1pZ2h0IGFjdHVhbGx5
IHBhc3MgdmVyaWZpZXIsIGlpcmMuIERvbid0IHRoaW5rIGl0J3MgYSBnb29kIGlkZWEgdG8gYWxs
b3cgZXhwb3NpbmcNCj4+Pj4+IHRoZW0gdmlhIGZkIHRiaC4NCj4+Pj4gSGkNCj4+Pj4gSSBtZWFu
IHRoYXQsIGNhbiB3ZSBpbnZva2UgdGhlIGJwZl9qaXRfZHVtcCBpbiB0ZXN0X2JwZi5rbyBkaXJl
Y3RseSA/LiBicGZfcHJvZ19nZXRfaW5mb19ieV9mZCBjb3B5IHRoZSBpbnNuIHRvIHVzZXJzcGFj
ZSwgYnV0IHdlIG9ubHkgZHVtcCBpbnNuIGluIHRlc3RfYnBmLmtvDQo+Pj4+DQo+Pj4+ICAgICAg
ICAgICAgICAgICAgIGlmIChicGZfZHVtcF9yYXdfb2soZmlsZS0+Zl9jcmVkKSkgey8vIGNvZGUg
Y29waWVkIGZyb20gYnBmX3Byb2dfZ2V0X2luZm9fYnlfZmQsIG5vdCB0ZXN0ZWQNCj4+Pj4NCj4+
Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAvKiBmb3IgbXVsdGktZnVuY3Rpb24gcHJvZ3Jh
bXMsIGNvcHkgdGhlIEpJVGVkDQo+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICogaW5z
dHJ1Y3Rpb25zIGZvciBhbGwgdGhlIGZ1bmN0aW9ucw0KPj4+PiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAqLw0KPj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgIGlmIChwcm9nLT5hdXgt
PmZ1bmNfY250KSB7DQo+Pj4+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBmb3Ig
KGkgPSAwOyBpIDwgcHJvZy0+YXV4LT5mdW5jX2NudDsgaSsrKSB7DQo+Pj4+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGxlbiA9IHByb2ctPmF1eC0+ZnVuY1tpXS0+
aml0ZWRfbGVuOw0KPj4+PiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBpbWcgPSAodTggKikgcHJvZy0+YXV4LT5mdW5jW2ldLT5icGZfZnVuYzsNCj4+Pj4gICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgYnBmX2ppdF9kdW1wKDEsIGxlbiwg
MSwgaW1nKTsNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIH0NCj4+Pj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICB9IGVsc2Ugew0KPj4+PiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgYnBmX2ppdF9kdW1wKDEsIHVsZW4sIDEsIHByb2ctPmJwZl9mdW5j
KTsNCj4+Pj4gICAgICAgICAgICAgICAgICAgICAgICAgICB9DQo+Pj4+ICAgICAgICAgICAgICAg
ICAgIH0NCj4+Pg0KPj4+IExldCdzIG5vdCByZWludmVudCB0aGUgd2hlZWwuDQo+Pj4gYnBmdG9v
bCBwcm9nIGR1bXAgaml0ZWQNCj4+PiBpcyBvdXIgc3VwcG9ydGVkIGNvbW1hbmQuDQo+Pj4gcHBj
IGlzc3VlIHdpdGggYnBmdG9vbCBpcyByZWxhdGVkIHRvIGVuZGlhbm5lc3Mgb2YgZW1iZWRkZWQg
c2tlbGV0b24uDQo+Pj4gd2hpY2ggbWVhbnMgdGhhdCBub25lIG9mIHRoZSBicGZ0b29sIHByb2cg
Y29tbWFuZHMgd29yayBvbiBwcGMuDQo+Pj4gSXQncyBhIGJpZ2dlciBpc3N1ZSB0byBhZGRyZXNz
IHdpdGggY3Jvc3MgY29tcGlsYXRpb24gb2YgYnBmdG9vbC4NCj4+Pg0KPj4+IGJwZnRvb2wgc3Vw
cG9ydHMgZ251IGFuZCBsbHZtIGRpc2Fzc2VtYmxlci4gSXQgcmV0cmlldmVzIGFuZA0KPj4+IHBy
aW50cyBCVEYsIGxpbmUgaW5mbyBhbmQgc291cmNlIGNvZGUgYWxvbmcgd2l0aCBhc20uDQo+Pj4g
VGhlIHVzZXIgZXhwZXJpZW5jZSBpcyBhdCBkaWZmZXJlbnQgbGV2ZWwgY29tcGFyaW5nIHRvIGJw
Zl9qaXRfZHVtcC4NCj4+DQo+PiBIaSBBbGV4ZWksDQo+Pg0KPj4gRmFpciBlbm91Z2gsIHdlIGFy
ZSBnb2luZyB0byB0cnkgYW5kIGZpeCBicGZ0b29sLg0KPj4NCj4+IEJ1dCBmb3IgdGVzdF9icGYu
a28gbW9kdWxlLCBob3cgZG8geW91IHVzZSBicGZ0b29sIHRvIGR1bXAgdGhlIEJQRiB0ZXN0cw0K
Pj4gPyBFdmVuIG9uIHg4NiBJIGhhdmUgbm90IGJlZW4gYWJsZSB0byB1c2UgYnBmdG9vbCBmb3Ig
dGhhdCB1bnRpbCBub3cuDQo+PiBDYW4geW91IHRlbGwgbWUgaG93IHlvdSBkbyA/DQo+IA0KPiB0
ZXN0X2JwZi5rbyBpcyB1c2VmdWwgdG8gSklUIGRldmVsb3BlcnMgd2hlbiB0aGV5J3JlIHN0YXJ0
aW5nDQo+IHRvIHdvcmsgb24gaXQsIGJ1dCBpdHMgdGVzdCBjb3ZlcmFnZSBpcyBpbmFkZXF1YXRl
IGZvciByZWFsDQo+IHdvcmxkIGJwZiB1c2FnZSBjb21wYXJpbmcgdG8gc2VsZnRlc3RzL2JwZi4N
Cj4gSm9oYW4gQWxtYmxhZGggZGlkIHNvbWUgZ3JlYXQgYWRkaXRpb25zIHRvIHRlc3RfYnBmLmtv
IGJhY2sgaW4gMjAyMS4NCj4gU2luY2UgdGhlbiB0aGVyZSB3YXNuJ3QgbXVjaC4NCj4gDQo+IEhl
cmUgaXQncyBpbXBvcnRhbnQgdG8gZGlzdGluZ3Vpc2ggdGhlIHRhcmdldCB1c2VyLg0KPiBJcyBp
dCBhIGtlcm5lbCBKSVQgZGV2ZWxvcGVyIG9yIHVzZXIgc3BhY2UgYnBmIHByb2cgZGV2ZWxvcGVy
Pw0KPiBXaGVuIGl0J3MgYSBrZXJuZWwgZGV2ZWxvcGVyIHRoZXkgY2FuIGVhc2lseQ0KPiBhZGQg
cHJpbnRfaGV4X2R1bXAoKSBpbiB0aGUgcmlnaHQgcGxhY2VzLg0KPiBUaGF0J3Mgd2hhdCBJIGRp
ZCB3aGVuIEkgd2FzIGRldmVsb3BpbmcgYnBmIHRyYW1wb2xpbmUuDQo+IGJwZiBpcyBtb3JlIHRo
YW4ganVzdCBKSVQuIFRoZXJlIGFyZSB0cmFtcG9saW5lLCBrZnVuY3MsIGRpc3BhdGNoLg0KPiBU
aGUga2VybmVsIGRldnMgc2hvdWxkIG5vdCBhZGQgYSBkZWJ1ZyBjb2RlLg0KPiBMb25nIGFnbyBi
cGZfaml0X2VuYWJsZT0yIHdhcyB1c2VmdWwgdG8gdXNlciBzcGFjZSBicGYgZGV2ZWxvcGVycy4N
Cj4gVGhleSB3YW50ZWQgdG8gc2VlIGhvdyBKSVRlZCBjb2RlIGxvb2sgbGlrZSB0byBvcHRpbWl6
ZSBpdCBhbmQgd2hhdCBub3QuDQo+IE5vdyAncGVyZiByZWNvcmQnIGNhcHR1cmVzIGJwZiBhc20g
YW5kIGFubm90YXRlcyBpdCBpbiAncGVyZiByZXBvcnQnLA0KPiBzbyBwZXJmb3JtYW5jZSBhbmFs
eXNpcyBwcm9ibGVtIGlzIHNvbHZlZCB0aGF0IHdheS4NCj4gYnBmdG9vbCBwcm9nIGR1bXAgaml0
IGFkZHJlc3NlZCB0aGUgbmVlZHMgb2YgdXNlcnMgYW5kIGFkbWlucyB3aG8NCj4gd2FudCB0byB1
bmRlcnN0YW5kIHdoYXQgYnBmIHByb2dzIGFyZSBsb2FkZWQgYW5kIHdoYXQgYXJlIHRoZXkgZG9p
bmcuDQo+IEJvdGggJ2R1bXAgaml0ZWQnIGFuZCAnZHVtcCB4bGF0ZWQnIGFyZSB1c2VmdWwgZm9y
IHRoaXMgY2FzZS4NCj4gU28gYnBmX2ppdF9lbmFibGU9MiByZW1haW5lZCB1c2VmdWwgdG8ga2Vy
bmVsIGRldmVsb3BlcnMgb25seSBhbmQNCj4gaW4gdGhhdCBzZW5zZSBpdCBiZWNvbWUgYSBrZXJu
ZWwgZGVidWcgZmVhdHVyZSBmb3IgYSBuYXJyb3cgc2V0IG9mDQo+IEpJVCBkZXZlbG9wZXJzLiBP
biB4ODYgYnBmX2ppdF9kdW1wKCkgd2FzIG5lZ2xlY3RlZCBhbmQgYnJva2VuLg0KPiBJIHN1c3Bl
Y3QgdGhlIG90aGVyIGFyY2hzIHdpbGwgZm9sbG93IHRoZSBzYW1lIGZhdGUuIElmIG5vdCBhbHJl
YWR5Lg0KPiBIYXZpbmcgYSBzeXNjdGwgZm9yIGtlcm5lbCBkZXZlbG9wZXJzIGlzIG5vdCBzb21l
dGhpbmcgdGhlIGtlcm5lbA0KPiBkZXZlbG9wZXJzIHNob3VsZCBoYXZlIGFyb3VuZC4gSGVuY2Ug
dGhlIGNsZWFudXAgb2YgdGhpcyBwYXRjaC4NCg0KDQpPaywgSSB1bmRlcnN0YW5kLiBUaGVuIGl0
IG1lYW5zIHRoYXQgJyBicGZfaml0X2VuYWJsZSA9PSAyJyBjYW4gYmUgDQpyZW1vdmVkIG9uY2Ug
J2JwZnRvb2wnIHByb3Blcmx5IHdvcmtzIGZvciBkdW1waW5nIHVzZXJzcGFjZSBCUEYgcHJvZ3Mu
DQoNCkJ1dCBmb3IgdGhlIHRpbWUgYmVpbmcgaXQgZG9lc24ndCBzZWVtIHRvIHdvcmssIHNlZSBt
eSBvdGhlciBhbnN3ZXIuDQoNCkNocmlzdG9waGUNCg==
