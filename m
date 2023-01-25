Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E929E67B504
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 15:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235741AbjAYOoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 09:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbjAYOoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 09:44:00 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3907A474FD
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:43:24 -0800 (PST)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 30PDxOIb008043
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:42:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=tLmG8jbrFrY74GHuQpiJb2FbeHPedyJho+0FnLRH92Q=;
 b=OsY7IOf0i6vdiN6DtriBj1TFGmyl91pKgHrZkX5559WXRMzmJTMVgmFdn+MBlhif2xEs
 M/j4evK9yKAfwFEz5+U+wPa+oFYLdwTGwhviDUaAaDvZqTFTg4D7X3USjSZoCZr8UFIB
 72MVzlG2dMDZU3uJXoOFD2+700oEr/hPdhX+Jt1AYyZjH5Fne6VsHaN/483vKEuPCRaY
 8oq6vKOqcQaWUqjLIyLgEhgk5g8mVlTtLKxHTJ5FsfoE+Cv8N1qaKkjx9pfpbvWsCGBF
 m63NQLALRzjxQgwnNtyH4SF6Zh0TrAz49L4Y+iYPGUHlEAVRquPkLMeSnqll/vzo42of fQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by m0001303.ppops.net (PPS) with ESMTPS id 3nagrwygax-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 06:42:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7jIlHKVk6E70UqShNWyWqwzuRamVmZmCp1r5GLzoBGW9ZA2Jkj+g8yXjsLDeuHtrzuT/oBk43QdW6PJdPs0qPLFb9YzG1orkBEItejkNsxUu4KwESqJrlHLy1DPEJfyArXgWw3JGSdEZ/LjTQ59JT3IcEGDvHAyliuD3gvt8ew+6wGwmImRuM/2N5GU6MjPi7u5+Sy4YbgbE5pbkiFl/m6/Xf3RKuLfBXChSXg1hUpQoj6k5BEfPcf1/fIXDjP91fCLd0pflngcNF7hC+IwR5urA0L04yi2XfZYNwHzHQDIweeMdfkTOB0wA5bwLx7h9nu07eIOjoDLqoGysmKVkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLmG8jbrFrY74GHuQpiJb2FbeHPedyJho+0FnLRH92Q=;
 b=DiTFPWB0lsh9aMcTChDQxg9WSPhMm6EljVdCw/3xAc5eeh4HSsjor3r3wdw0zflZZ7dUs08ehlNBPiMBvnQPA4VMNmzXVyJgW7PZZ51Zh05mUuymcEVJ5MOtCmrAQSMD8KIJmGgBRyg8jdnALqbYUigpvHzykSMYYEId9fIBGuRm13ojt/1oLu6C8dawpi2xS17aQRO0StsogZZ8tq8dwbKqtWlHW+GvKl2zqFbKPN1ISp/f+mN+XP1BLOlLX99qWfMnK5sAWj+AFI2UZ3DqPWRvJFvrFyVdgVLDIWTJjUc7xfoty0bnc2lFWcP9FPJUkk7hrEHgw/2H6PzM7DQujQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from BLAPR15MB3874.namprd15.prod.outlook.com (2603:10b6:208:272::10)
 by DM4PR15MB6226.namprd15.prod.outlook.com (2603:10b6:8:18b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21; Wed, 25 Jan
 2023 14:42:08 +0000
Received: from BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7]) by BLAPR15MB3874.namprd15.prod.outlook.com
 ([fe80::8f58:63ac:99f9:45d7%4]) with mapi id 15.20.6043.021; Wed, 25 Jan 2023
 14:42:08 +0000
From:   Vadim Fedorenko <vadfed@meta.com>
To:     Gal Pressman <gal@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Thread-Topic: [PATCH net 1/2] mlx5: fix possible ptp queue fifo overflow
Thread-Index: AQHZLnza/MOTtBC6Vkmawt4udI7hba6sQiIAgAFkLQCAAZMcgA==
Date:   Wed, 25 Jan 2023 14:42:08 +0000
Message-ID: <45d08ca1-e156-c482-777d-df2bc48dffed@meta.com>
References: <20230122161602.1958577-1-vadfed@meta.com>
 <20230122161602.1958577-2-vadfed@meta.com>
 <c73fe66a-2d9a-d675-79bc-09d7f63caa53@meta.com>
 <46b57864-5a1a-7707-442c-b53e14d3a6b8@nvidia.com>
In-Reply-To: <46b57864-5a1a-7707-442c-b53e14d3a6b8@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BLAPR15MB3874:EE_|DM4PR15MB6226:EE_
x-ms-office365-filtering-correlation-id: 7af977d9-b865-4592-c553-08dafee255e7
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P/2DfSw8KxmU0m3G6z9Gsrqp4IjAKis5JxeYh6Ffh3oLbHSEaMAXfCHlHkj945ya8hpFlGjlQ0EW7JKNue2dnzSEBNCeK2TJpcYDZJtHAP66zR416cYRmybgxOUsaVEThC650e8tOcFA2pVY/2yTsFH03za9bvKcH12ViBi2Yu4uT5f7ZaUkNskfIDOvHOcw+or87BmdlCHAKH+vMenAqrJ+/4Aaa5Pxa9YTGLilUFF1YP8nAQxIXSxyJT8+Y5ZuWaIzIQT4GnqCA2GllO4PvQUNtU6DXhJwjw2NEs9Z8HvacSe6Y2L5q714CoveCByTGs0OYoizoY84gAchJ9roeCqBRyrC/Bu1EshXG28ufLc1SqwoiLwc74j6zWQ5+mxKkFHAJ8wJoajxrnRRb8ddaROqesQSlzinHv2ncA0b0xA5WTi0z1jKAvHC0fpkUrB2AYErDTyNKlpXw84kQjiK9LjmDZWIW/CuXZbuBDXSPF/ZqFBDeAB/jr31euc3lTB4pQqbdxLYiQHoEs3x+XMgq5BeKHjuHTvdzJbSTQ396wsBBHdYzUXHXfSR3zW0TAWLoYk6cwLMhWIJR5BQNE1uYoki2K6IhVeT2i/4a8GnTXv8j4zXhsOyh5R+3CLOqkhsY4yQZX2VWCtuIR7APrM0p5kxXYTvt89vlCQ5S/t49E0fDHtH6hgHhn8vToZAUSCz1s1BbzquznaisTWVBjvL84mCwAWz2xJdQV2cIWeCIO8tusExLA/5FyIfwIA4e/weL2Uvr1H7unGbQ1AAZMVaJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR15MB3874.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(451199018)(5660300002)(66446008)(64756008)(186003)(316002)(2906002)(6916009)(66946007)(76116006)(4326008)(66476007)(91956017)(66556008)(8936002)(8676002)(31686004)(41300700001)(71200400001)(83380400001)(6486002)(478600001)(966005)(53546011)(6506007)(6512007)(2616005)(38100700002)(122000001)(54906003)(36756003)(38070700005)(31696002)(86362001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dWRLYXUvbjZUd2tWT2p2US9FRkFjNjkrcFJJRVdYNlV0cWtUSWc0N29tMkNI?=
 =?utf-8?B?VEVDTFFTWmVNUThHb3Jxd0F6ZTJYMm9tazBmNjhPdjJnbkx3OTlYL0JKUVow?=
 =?utf-8?B?OEZqKzlxemtpc3ZBRmdyTTR1SFZuQnRIQ0d6ajJWTmp2VHA0RVlvdzlCSG1E?=
 =?utf-8?B?dDQzUis0WWc5cFNlNDIyVGdJTmg2dVFlQUgrdlk3MjdlY0RPWGFUb1JRMmY2?=
 =?utf-8?B?aFFidHZ6RTc3N2VYbjVjc29UVEE3ZXNSN2lWcDNHSVFKemJDK2pUWjd0OEI3?=
 =?utf-8?B?VHdDR2ZHclJGZGFIb0RGWFprQzlLTU1KSUFhWmJqQWtPdEVMa1Y1TWlwVkoz?=
 =?utf-8?B?Qm9SR3dZY1V5NDFxRnlySmUxVWlHWHBwMUtoeE91MVI4TmhvUmE3TmxIWmly?=
 =?utf-8?B?VUg0T3Yyc2RzSTNlbWljUFhXZEo1bHFNODc1THE2WG5tQ3BNN0lLd3Yra0ZS?=
 =?utf-8?B?NnkzeGZqU2JEQkN1YmY2dEt1cS94UXR1aC9kNmY4UGJSa3VEOWJFL2NnVnFz?=
 =?utf-8?B?K1NzN2F4QnNsRFJCa0xIb0xmQ0orOVB3cFdWSUwraVVYU05ORkNGWk15b051?=
 =?utf-8?B?ZkphNG9YNFV1T3NocGY3dE5WVS9GeW5ORnRnSzlPQ3NmOUtNVVdXTWpSeDBz?=
 =?utf-8?B?UWIrYy94eHpORVFkY1VXdFR5WWRhcVVxcVJXanhKaGYrTHlhZmJvalkyb3px?=
 =?utf-8?B?YmpNSDdrVzRGTGlkaWZrQmtvVDNSRzVsNXN5OElQb1hxVXBjZDJzTEN6Nmpl?=
 =?utf-8?B?QW53WEV0NWxiNXlnMTVXbmtndkdxKzFNa0RkbnFHVzU2S2EvbllsOVBvZHV4?=
 =?utf-8?B?ZERkc1BjZ1dhZnpQb1E4ZnNQdW5rZkVxbHo4NjVsamNKUFpiRUM1bkp3YS9p?=
 =?utf-8?B?Nm5sVHJ3SEY1WHNLNU1hZGk4VWV0aWNBY2RyY2p0cmNWMXlTSmFmWWo5clFM?=
 =?utf-8?B?amNZVlpOM3doQVRrNkxNLzZEaHRLV2tpVXVJcHNxOEZXbUN0VDloc1lCQ0RL?=
 =?utf-8?B?MVNvck9sYzhnWUFqWVQwclplclBGbTNhMjVrZTNHaTFYaDNiSXg4TjhBb2o1?=
 =?utf-8?B?enFRUFFCSlpCNnFHUk5ZYzlzbEg2cmdJM3ZQUWtIWWdFT29oeWh1THA2TFpw?=
 =?utf-8?B?aUM4ZFJXRG4wUy9Nd3VvRWdSNFM2NEJQSmxhSWlaemgwTGQ3cVZ1dWd2QVRC?=
 =?utf-8?B?Tk94S2VRMGVTRjZCWEwxaG1yaTVQbUJjdk9od2VsVnZ5UmxpVlk5WGZtVFpl?=
 =?utf-8?B?QUI0V1F6TkpCUnNZWTFDdXlkUXZ1VExIQmtzbXBIblFhZHNLaURrWTBTeEJL?=
 =?utf-8?B?UUxjZGhER0lMK1pNdG9IcTlkTmRSQUFEREs2RmR2akpVSlh0TVlxb2JnZVEy?=
 =?utf-8?B?cExiVGhuUldYTFFQakxRT0hHcHhBTStsazRkSmt0WUFuT0t5Q2dOVXR6OWdY?=
 =?utf-8?B?ZmF6V253NGw0aUFaNEZzaWhGL2QrbWpoV3VNaU11QTdMajJ1VStiSy94UERP?=
 =?utf-8?B?V2VSUWZObTYrdWQrOFVWdklhbE9KbDRycDJMelY0ZmhsMldHcVFMQjdYOUxD?=
 =?utf-8?B?dHllcTJZQXNWSjdhZnZhaDhTTjNRK29jZGJkYXRHZG93MCs1OE90WmdLdzFU?=
 =?utf-8?B?Z1BjQ3JCL284Z3M4U0hXeDlPMGhnTmk5NVdVRk42T256dXNJdzVwUHM5VWhr?=
 =?utf-8?B?YUlJNWpIaTJubVVyd1U1dVMvRkdsb3MydytHY0xNRVEwcWV4VXFzZ1RYcno3?=
 =?utf-8?B?TE1heUNpc09iS1N1MTVDSnlWSFhIVXY0bEU0anN2UjVMKzNueHY0b2JzbFJD?=
 =?utf-8?B?VHFJekM4RDRjMVFvUFRndk9hVWQwQklHWER1TzJ5WktCN0FodlA5WDcycFVS?=
 =?utf-8?B?aTBQcDd0cVhyQTdNNHNtVHpqbEEzQTZoeU5lS2VkT05MTDNsdUNGeGVzVGVu?=
 =?utf-8?B?Q1VoZWM5am9OSmdtcXc4eC85Z0dkVUh5N1hKSHNYR1gwd2ZOZ2ZKdzNzdmRG?=
 =?utf-8?B?NnlCZCtnUUVZZnpHMEJpWnlvU0o2YWdwaGYvU01sQ3RITTZaM2lrdFIrN3Vo?=
 =?utf-8?B?OGgxc0R4dEdpcDVRUmgveU96akZWZ01kNEJmZHhVamh6UTgwdnpLN3UyZWRp?=
 =?utf-8?B?c1MwVFFGN2RMREtpd3pHcGxkQjBoQnhRV3M4WDZubTk5TWtCREJkM2RZVjk2?=
 =?utf-8?B?OUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FFEDA5A18AF9541871D8A20F4DFD0B6@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BLAPR15MB3874.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af977d9-b865-4592-c553-08dafee255e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 14:42:08.3350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JWgIBZfY3IZgrK3p7C4ona3fckxsxXAF76Lkwfp5439d4m9a4wWrpi5Q7X0563J9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB6226
X-Proofpoint-ORIG-GUID: f8THqmm-T-R-sVCr0u_z_or6uOJVj3ub
X-Proofpoint-GUID: f8THqmm-T-R-sVCr0u_z_or6uOJVj3ub
Content-Transfer-Encoding: base64
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_08,2023-01-25_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQvMDEvMjAyMyAxNDozOSwgR2FsIFByZXNzbWFuIHdyb3RlOg0KPiBPbiAyMy8wMS8yMDIz
IDE5OjI0LCBWYWRpbSBGZWRvcmVua28gd3JvdGU6DQo+PiAgID4gSGkgVmFkaW0sDQo+PiAgID4N
Cj4+DQo+PiAgID4+ICsJCXB0cHNxLT5jcV9zdGF0cy0+b29vX2NxZSsrOw0KPj4gICA+PiArCQly
ZXR1cm4gZmFsc2U7DQo+PiAgID4+ICsJfQ0KPj4gICA+DQo+PiAgID5JIGhvbmVzdGx5IGRvbid0
IHVuZGVyc3RhbmQgaG93IHRoaXMgY291bGQgaGFwcGVuLCBjYW4geW91IHBsZWFzZQ0KPj4gICA+
cHJvdmlkZSBtb3JlIGluZm9ybWF0aW9uIGFib3V0IHlvdXIgaXNzdWU/IERpZCB5b3UgYWN0dWFs
bHkgd2l0bmVzcyBvb28NCj4+ICAgPmNvbXBsZXRpb25zIG9yIGlzIGl0IGEgdGhlb3JldGljYWwg
aXNzdWU/DQo+PiAgID5XZSBrbm93IHB0cCBDUUVzIGNhbiBiZSBkcm9wcGVkIGluIHNvbWUgcmFy
ZSBjYXNlcyAodGhhdCdzIHRoZSByZWFzb24gd2UNCj4+ICAgPmltcGxlbWVudGVkIHRoaXMgcmVz
eW5jIGZsb3cpLCBidXQgY29tcGxldGlvbnMgc2hvdWxkIGFsd2F5cyBhcnJpdmUNCj4+ICAgPmlu
LW9yZGVyLg0KPj4NCj4+IEkgd2FzIGFsc28gc3VycHJpc2VkIHRvIHNlZSBPT08gY29tcGxldGlv
bnMgYnV0IGl0J3MgdGhlIHJlYWxpdHkuIFdpdGggYQ0KPj4gbGl0dGxlIGJpdCBvZiBkZWJ1ZyBJ
IGZvdW5kIHRoaXMgaXNzdWU6DQo+IA0KPiBXaGVyZSBhcmUgdGhlc2UgcHJpbnRzIGFkZGVkPyBJ
IGFzc3VtZSBpbnNpZGUgdGhlICdpZg0KPiAobWx4NWVfcHRwX3RzX2NxZV9kcm9wKCkpJyBzdGF0
ZW1lbnQ/DQo+IA0KPj4NCj4+IFs2NTU3OC4yMzE3MTBdIEZJRk8gZHJvcCBmb3VuZCwgc2tiX2Nj
ID0gMTQxLCBza2JfaWQgPSAxNDANCj4gDQo+IElzIHRoaXMgdGhlIGZpcnN0IGRyb3A/IEluIG9y
ZGVyIGZvciBza2JfY2MgdG8gcmVhY2ggMTQxIGl0IG1lYW5zIGl0IGhhcw0KPiBhbHJlYWR5IHNl
ZW4gc2tiX2lkIDE0MCAoYW5kIGNvbnN1bWVkIGl0KS4gQnV0IGhlcmUgd2Ugc2VlIHNrYl9pZCAx
NDANCj4gYWdhaW4/IElzIGl0IGEgZHVwbGljYXRlIGNvbXBsZXRpb24/IE9yIGlzIGl0IGEgZnVs
bCB3cmFwYXJvdW5kPw0KPiBJJ20gbm93IHJlYWxpc2luZyB0aGF0IHRoZSBuYW1pbmcgb2YgdGhl
IHZhcmlhYmxlcyBpcyB2ZXJ5IGNvbmZ1c2luZywNCj4gc2tiX2NjIGlzbid0IHJlYWxseSB0aGUg
Y29uc3VtZXIgY291bnRlciwgaXQgaXMgdGhlIGNvc3VtZXIgaW5kZXgNCj4gKG1hc2tlZCB2YWx1
ZSkuDQo+IA0KPj4gWzY1NTc4LjI5MzM1OF0gRklGTyBkcm9wIGZvdW5kLCBza2JfY2MgPSAxNDEs
IHNrYl9pZCA9IDE0Mw0KPiANCj4gSG93IGNvbWUgd2Ugc2VlIHRoZSBzYW1lIHNrYl9jYyB0d2lj
ZT8gV2hlbiBhIGRyb3AgaXMgZm91bmQgd2UgaW5jcmVtZW50IGl0Lg0KPiANCj4+IFs2NTU3OC4z
MDEyNDBdIEZJRk8gZHJvcCBmb3VuZCwgc2tiX2NjID0gMTQ1LCBza2JfaWQgPSAxNDINCj4+IFs2
NTU3OC4zNjUyNzddIEZJRk8gZHJvcCBmb3VuZCwgc2tiX2NjID0gMTczLCBza2JfaWQgPSAxNDEN
Cj4+IFs2NTU3OC40MjY2ODFdIEZJRk8gZHJvcCBmb3VuZCwgc2tiX2NjID0gMTczLCBza2JfaWQg
PSAxNDUNCj4+IFs2NTU3OC40ODgwODldIEZJRk8gZHJvcCBmb3VuZCwgc2tiX2NjID0gMTczLCBz
a2JfaWQgPSAxNDYNCj4+IFs2NTU3OC41NDk0ODldIEZJRk8gZHJvcCBmb3VuZCwgc2tiX2NjID0g
MTczLCBza2JfaWQgPSAxNDcNCj4+IFs2NTU3OC42MTA4OTddIEZJRk8gZHJvcCBmb3VuZCwgc2ti
X2NjID0gMTczLCBza2JfaWQgPSAxNDgNCj4+IFs2NTU3OC42NzIzMDFdIEZJRk8gZHJvcCBmb3Vu
ZCwgc2tiX2NjID0gMTczLCBza2JfaWQgPSAxNDkNCj4gDQo+IENvbmZ1c2luZyA6UywgZGlkIHlv
dSBtYW5hZ2UgdG8gbWFrZSBzZW5zZSBvdXQgb2YgdGhlc2UgcHJpbnRzPyBXZSBuZWVkDQo+IHBy
aW50cyB3aGVuICFkcm9wcGVkIGFzIHdlbGwsIG90aGVyd2lzZSBpdCdzIGltcG9zc2libGUgdG8g
dGVsbCB3aGVuIGENCj4gd3JhcGFyb3VuZCBvY2N1cnJlZC4NCj4gDQo+IEFueXdheSwgSSdkIGxp
a2UgdG8gem9vbSBvdXQgZm9yIGEgc2Vjb25kLCB0aGUgd2hvbGUgZmlmbyB3YXMgZGVzaWduZWQN
Cj4gdW5kZXIgdGhlIGFzc3VtcHRpb24gdGhhdCBjb21wbGV0aW9ucyBhcmUgaW4tb3JkZXIgKHRo
aXMgaXMgYSBndWFyYW50ZWUNCj4gZm9yIGFsbCBTUXMsIG5vdCBqdXN0IHB0cCBvbmVzISksIHRo
aXMgZml4IHNlZW1zIG1vcmUgb2YgYSBiYW5kYWdlIHRoYXQNCj4gcG90ZW50aWFsbHkgaGlkZXMg
YSBtb3JlIHNldmVyZSBpc3N1ZS4NCj4gDQo+Pg0KPj4gSXQgcmVhbGx5IHNob3dzIHRoYXQgQ1FF
IGFyZSBjb21pbmcgT09PIHNvbWV0aW1lcy4NCj4gDQo+IENhbiB3ZSByZXByb2R1Y2UgaXQgc29t
ZWhvdz8NCj4gQ2FuIHlvdSBwbGVhc2UgdHJ5IHRvIHVwZGF0ZSB5b3VyIGZpcm13YXJlIHZlcnNp
b24/IEknbSBxdWl0ZSBjb25maWRlbnQNCj4gdGhhdCB0aGlzIGlzc3VlIGlzIGZpeGVkIGFscmVh
ZHkuDQo+IA0KSSBhZGRlZCBzb21lIGRlYnVnIHByaW50cyBvbiB0b3Agb2YgdGhlIHBhdGNoZXMg
dG8gc2hvdyBza2JfY2MgYW5kIA0Kc2tiX2lkIGZvciBldmVyeSBwYWNrZXQgdGhhdCBpcyBmb3Vu
ZCBieSBtbHg1ZV9wdHBfdHNfY3FlX2Ryb3AoKSBhbmQgMTAgDQpwYWNrZXRzIGFmdGVyLiBUaGUg
b3V0cHV0IGlzIGluIGh0dHBzOi8vZHBhc3RlLm9yZy9yTXliQS9yYXcNCg0KSXQgY2xlYXJseSBz
aG93cyB0aGF0IHNvbWUgcmVvcmRlcmluZyBpcyBoYXBwZW5pbmcgaW4gQ1FFLg0KSSdtIG9wZW4g
dG8gYWRkIG1vcmUgZGVidWcgaW5mbyBpZiB5b3UgbmVlZCBpdC4NCg==
