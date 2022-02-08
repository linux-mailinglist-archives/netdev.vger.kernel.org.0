Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4E84ADFB3
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352705AbiBHReP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239079AbiBHReO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:34:14 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BA7C061576;
        Tue,  8 Feb 2022 09:34:14 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 218E725U013569;
        Tue, 8 Feb 2022 09:34:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=Xx0SvAyUI45+O3O0WGz+M9tuj0ewRf30xWNiU7xwKdc=;
 b=oGYQVd0K0ChfL4e2HDeL09f3HkVtVVK7km/fvquxxIVHvO/fc8j+X1hK6fgGKapZ2/4J
 4BBuWKDBEYjz+ctIpIyexoXutqH8vK5+uUZS3Toff+kWQX3BOLjjIzQ3kKilcrixYr/c
 8WramlCT+pHAr417zb56ThefJkzphbO08xc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e3puw2rvw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 08 Feb 2022 09:34:14 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Feb 2022 09:34:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAUqR/o3VCmhkyZ2fq6hoyq+TlJlcnnyEd5g1x5pCf+mwqZiinC7ZmBqz6IdqBt4DLsgISOmxrbbX9XkxFA0zkxoz9PmJatz9aM2d8bRNRAiqFtQS6bzG/c5v1yIz1MMEYxYbJU1Lvq8xww8m1KPBOU7wowzeqK++53GKFVT6d5MQ+k470d2kRp2WhFDTYlZq5wLG7m7WlERiYccdY9onDttAkwadNWo4K/wU+y+wLsH7EwBj0/cpruP0F5MZ0XKYlgbQT3ARCCTLcb5VJaa2RZU2c8Drzft2qNGNsaRur8lbt/7gZf+upLJC12YJ485ypwnHEuI/y8OfMaag3QMaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xx0SvAyUI45+O3O0WGz+M9tuj0ewRf30xWNiU7xwKdc=;
 b=m/vcQ68odtC/ub6UK9TJ1VNvmyJaj6A5VrVCW5V6kiz+5JLL3u6hxdK1JeANrYsPPw6TsIs9gjW5MyK0A72No4GToOX+PbZWDzLMl37I5bSjsZVXLMUXec7ftrkPUAAl5D8G1+uQPj0FDfHVDSRISD9DFxMkVYZVVplofSnGeqxi11TGllMoPGCZIj//0UDYkyvZ+VxoEVJl/f8tut6flPTmdLfQX5cX3Kd7qR+/bZAsgDgALBrUx1/zMDdbpVjzPusLRQrY9yZo2M53C14jKUUUi3v2JyrBnKD1vtr/JM444+psIYhYnBmruwvnBElzhRvRNZT5eoNnYXy9JfM25w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BYAPR15MB3061.namprd15.prod.outlook.com (2603:10b6:a03:b2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19; Tue, 8 Feb
 2022 17:34:10 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e%5]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 17:34:10 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Kernel Team" <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf, x86_64: fail gracefully on
 bpf_jit_binary_pack_finalize failures
Thread-Topic: [PATCH bpf-next] bpf, x86_64: fail gracefully on
 bpf_jit_binary_pack_finalize failures
Thread-Index: AQHYHLTdg+/UCfRi/kO9FfmtvMwTk6yJ6RsAgAABo4A=
Date:   Tue, 8 Feb 2022 17:34:10 +0000
Message-ID: <A5912F45-61A9-4D58-9787-C63CFBBD8DD7@fb.com>
References: <20220208062533.3802081-1-song@kernel.org>
 <CAADnVQLpksvkKaJh1SAT0t2mjAb-1jUsTGp+EjhycsWfEThj1g@mail.gmail.com>
In-Reply-To: <CAADnVQLpksvkKaJh1SAT0t2mjAb-1jUsTGp+EjhycsWfEThj1g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44c6ec75-77ba-43a4-c53d-08d9eb2937a4
x-ms-traffictypediagnostic: BYAPR15MB3061:EE_
x-microsoft-antispam-prvs: <BYAPR15MB3061185AA0D387D6E1FFE7C1B32D9@BYAPR15MB3061.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 59Y52lBlQ8dRUtbiV0GT3y9JVr/b1YLRHNjGnpIX5snuff8Zkeh1DQ50TiLZqWXAYPVI2SLcy/PlHgEuWcTBmyPspUTujP4vNTRcQIVhtZOrNN0A1uedFlA+z2WtgATVDfAiF+N5aq8kew8CfCpaEihyDgxB7GFbn7f+JvfSi2JJAh3XEKonG0UEfFHvsWvg1ctgs0WPzzY/391sUN4uSIqpS/0oxTRRYZXQLSrUMK3sE2WpSo2hp3p7oct2GyDBAz4gAvLdVwibLTPD8JNMBkut+e9JfVlkKDVg5oStrkgg3L7rQyfq0agd7W98w4Q9uZg1OGeVpK7ASo7N1/YvBtwE1QySH+W79R9jAgmEy16HXoa0eUufY5jgbuPm0nqpaO02Tg6HvX/wzNHCnkaA3ayjHJthABpavSAi9UgRebxU45BTeC4aT/l4Rm1j60GgHMTbhLPedZ1futBZwjbiepCBOm3weMl5/Xj5Izx+RpGoNtx9tEPPlj/YZQ7YcKZXfFaoLk3tADQ2/htDsHj7n3AmhV6r1DswKQGhoLXe5FfWeApDrbmLLOa6V/QIPEjBgGzPyY+cs9JfbgVIM9RL+7Y/56dcEcdLXhdVIVI2M8t876rI1Ku+P8m+aB2aquL71aV7F2UA3FEyVUjW1IBedMo6KcFs8V8WLM46QRvG6hJAuA5Jy2AZxYvfeCq9pa/CduSEXjXqtOKzVZCJev5VoFYjISY9FjHnJpIffeW1qbuvz4HL2rWdJrbkZsYKngd/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(2906002)(36756003)(4744005)(186003)(122000001)(38100700002)(2616005)(38070700005)(33656002)(54906003)(53546011)(6506007)(86362001)(8676002)(8936002)(64756008)(66446008)(66556008)(66946007)(6486002)(71200400001)(91956017)(4326008)(76116006)(508600001)(6916009)(6512007)(316002)(5660300002)(66476007)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jNxG2g37Yc42j7WKTqPaQWxfnSEDg8LwaU2wt5VLDVqntAS/Y5KphkWLtpHr?=
 =?us-ascii?Q?QiuErbobMFzhym2MS8o/fuK2Zs+Zglsm2paw9MLLN3e++F76a8Hc7J2l0byE?=
 =?us-ascii?Q?Q5bJjZW0KCVCVzCpr3mme5Slh7elj588ksZxf2dISRJbEGwmq3Zf0ySb4zsp?=
 =?us-ascii?Q?Qeco4DJOooN/ZAT4RuI21vy3Krp0Wg1t571s6rNKnigMcnfAF56YVoMvcYad?=
 =?us-ascii?Q?suJ3wH/6EXCqVUsNQS1Ror78al/nRAgkHS//fHmkSYIOSJsyIG6vfdRtfJlj?=
 =?us-ascii?Q?YR4f4OVJLoKO38T0rKdQeCiJXa5bvP16AOsrjndIOPMWiBsvAVq799zAV2VQ?=
 =?us-ascii?Q?XxMdRfdwhpa1xhMtwfeDisNXoAYJfaJZJqbRXNIV9hOsBzVlPOcACzuhDdpa?=
 =?us-ascii?Q?WqvylkLz08Tx4JGkBwYluauaUu+WXyrUWn7KqNSA0ye6TLsHWZE8qHaaJfzf?=
 =?us-ascii?Q?zJBqFy7g+/KIDHuoAlOXTzZKnUF/GgZXWGtiRzL7NkSbRAkujdpM8SQDOeGW?=
 =?us-ascii?Q?zAhEMrVqiLM70TVhPcDby1lcbdNukyH/DUF3+2FRV00I94e3dBkvPDoRajbk?=
 =?us-ascii?Q?4Pge2K+PmxHVnYn7X8PTq2JrSikh/ScMwgAT6APvKUSkUMvSqJv2+J7JmZXr?=
 =?us-ascii?Q?0xsVPwxqULxyCxeUZI+UJXK5Hvz0fpUXJBQSIYUl3j31CTJdTRTN3hz0tvYm?=
 =?us-ascii?Q?bQkASj/WDtcxn+qWok5cMRqeFUdZOKIIt+zaW9JKTuy+jK1/CLz8/i6s6JTJ?=
 =?us-ascii?Q?G3Aoc7MEPAeYNZqK5EBLJVjQbwMzuaovrCtZYCLu0HD6AuSL41eCUfss45fM?=
 =?us-ascii?Q?HGn4tnEwaQWHcZOvSNlWKeOy8hojdK3FtAaG5yhfkXeVo9a3GHR0Z+GpxstU?=
 =?us-ascii?Q?cz0xXbIUOF2TedB8iRJZlcT+Fm9jYF/PEGwKx48ytPtoNGSn28RzVwXFEYZK?=
 =?us-ascii?Q?VbauZJr8fB2usuW5Fjhyr2z1yRY7B5tWETl0QJuK/GwM/k1dniLYWYRHVTOS?=
 =?us-ascii?Q?ec43gJa+F3CZ/fDUrg/DJV2KBvGN3rdRRag0q7m7SmWBLRJpBZrsp2h82iMY?=
 =?us-ascii?Q?WIeBUQYpzq5MIHUk2E13BAKZJUhdaccTMXOFbCzaZK0+SAJk0G63xYO+PAuG?=
 =?us-ascii?Q?bjWH4tFZjK7MoIQZyRPayPfbfIOXg5YV2Hv1GPM6qMumBggkuqyPAE+Krzii?=
 =?us-ascii?Q?uLMN6UQ5BNE8AlpKgobtEoh6QK6aiDm6Fj/YWvHemXPZLJlI3S0d5tYOh0WX?=
 =?us-ascii?Q?YFebWD54V7wdTrQnlH3lN2x5BvxYGrkTOtpacg84rGOjXhMi+dMM2/LBuoHy?=
 =?us-ascii?Q?7bYbB3wXjSiwkO5Ova417AiTqkroc0lqrxEO2jQ9eA4QsEDVLGcbjb/B3req?=
 =?us-ascii?Q?e2FBAZ/iYejPzY9M0d3jyznNHVkKWa2Usf206E52P7ChCyIt78hm79cSWK1z?=
 =?us-ascii?Q?fKfdc7JgzqUxIASi5a926R+aBWz/WbQK8Anl4xFlmABunEvsoWEJ+X7MmoR1?=
 =?us-ascii?Q?1u2mJ1DoyHKs06ajHY84l6cLWhM5oLsw08Kj3ReOTbvByCxb1DWyvf79b4Ta?=
 =?us-ascii?Q?isj7lr6kYGCQXp7Fgmq1ZFPlHikm8lXXSficb3XVU3Ib7aXdk36foitOonJ0?=
 =?us-ascii?Q?EtqdXRGf9B+PegI26f75c7nBrml9+PEHKYUQgHH3rVc326od0PV87j+HV/4d?=
 =?us-ascii?Q?0aVQHw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <49E3FABA64E67D4586FC8A7E1F65A6D6@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c6ec75-77ba-43a4-c53d-08d9eb2937a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 17:34:10.8274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G3qoY1o4rJlkQfL0dG1mx8h+aN5MWj/7oHPrcYIlJEtgAKrEv/5yn7GJ2bIe5wZu0NgKN6tjKwPw+cCfLDrNng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3061
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: ER0Q9IhLVuGJqUTgkdFwqTApKF1Cmsos
X-Proofpoint-ORIG-GUID: ER0Q9IhLVuGJqUTgkdFwqTApKF1Cmsos
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_06,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 malwarescore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080105
X-FB-Internal: deliver
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 8, 2022, at 9:28 AM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Mon, Feb 7, 2022 at 10:26 PM Song Liu <song@kernel.org> wrote:
>> 
>> Instead of BUG_ON(), fail gracefully and return orig_prog.
>> 
>> Fixes: 1022a5498f6f ("bpf, x86_64: Use bpf_jit_binary_pack_alloc")
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>> arch/x86/net/bpf_jit_comp.c | 6 +++++-
>> 1 file changed, 5 insertions(+), 1 deletion(-)
>> 
>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>> index 643f38b91e30..08e8fd8f954a 100644
>> --- a/arch/x86/net/bpf_jit_comp.c
>> +++ b/arch/x86/net/bpf_jit_comp.c
>> @@ -2380,7 +2380,11 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
>>                         *
>>                         * Both cases are serious bugs that we should not continue.
> 
> I tweaked that comment a bit, since it's no longer accurate and
> pushed to bpf-next.
> Thanks!

Thanks for the fix! I had that in mind initially, but forgot about it
when I got to the keyboard. 

Song

