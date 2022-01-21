Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8597B496557
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 19:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiAUS4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 13:56:45 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22422 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229453AbiAUS4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 13:56:43 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 20LFtDrJ005971;
        Fri, 21 Jan 2022 10:56:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=b+7euje8ULiVl8STSV3Kq+UghuVegja/xePtS0HJlxY=;
 b=E86DZRcEEnvM8QDnfF2Hjhj8ft7Z+i/suyXh4mOsmUvbmQyF25S9lg9mbAIXVN3wTCXk
 Atrljbqb2SK/R+ekftnkuL1Kz0HkG6I9M2vW1QvLNG2HtJBFzaxu2rU5FXLY+2e6n8hQ
 DGFACluigHrj/94A1BWCpy5IWaNT9NpI8UI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3dqhy4n771-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 21 Jan 2022 10:56:42 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 10:56:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeFmRE4K6Q+pRkI2/27cuq2eImZ7NW5UHmNuvR4EKhy1dl+Vyn3hHWlqXf1U1rYUEWmAUFrxipMxILxRXKOWv6hDUuPPozve1PkB4jOX7p970k32Z4M+jQyK+qb3kVE1SZWPidHLY/e6sbh7pV+MaG9rSVofHy+kfhWNfx06F2nP6o3NVP6T+YqwJqQ10Hhl/xlnQdbnt/u5w46JqOAcOejn8c+htVdAAqoRokjFXqT4B18j2ro8U9ay+XTyWu7OMBBAkxYBC8hw0KC6oFfl03Vg17ZMEStEyQJHt1KmjYV51LrK7gVHXadTkJiYhLImXnxAwcpXSjjJts/ZonHVfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b+7euje8ULiVl8STSV3Kq+UghuVegja/xePtS0HJlxY=;
 b=PicxMXGg0txFJYc5a6oD5TOOlcW5W62z0vsXCuCLmypBcg8w6Nyx7OrRjs1yugqKK0OV5H/2QXv3mYg5OpOVrWhyMiqP2IQhTGzy2NkK2KXbyj5Uf6lVy3qfC72pmrk/6CRLiM0fO0jF1nf5d8L1S+pQeUGwGdGS/osXLYlr06Mb7CaSFY1Z+qtymWdfR2Fb4eOTFineBTxMgYMht2vPYrFh0mRIDLP7Wr+KB3WvXL1oSF8dLRayQHaj6yQk5iiYEO7puhDW6znjvWK5p5CgT2xRA1SAVgWs67kH12eGR4LYS2t60MoFP3mmMliAzpyZxE9hcloppQVBnf/oNZkj3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN8PR15MB3329.namprd15.prod.outlook.com (2603:10b6:408:a5::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Fri, 21 Jan
 2022 18:56:39 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::1d7e:c02b:ebe1:bf5e%7]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 18:56:39 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Song Liu <song@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "Peter Zijlstra" <peterz@infradead.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v5 bpf-next 7/7] bpf, x86_64: use bpf_prog_pack allocator
Thread-Topic: [PATCH v5 bpf-next 7/7] bpf, x86_64: use bpf_prog_pack allocator
Thread-Index: AQHYDjH7IlFLQbwkPUWXKcNPE2HSyKxs6t2AgADYTACAAAo4gIAAB3cA
Date:   Fri, 21 Jan 2022 18:56:39 +0000
Message-ID: <ACCB0C73-9968-4DB8-9B8D-97560B32D8DD@fb.com>
References: <20220120191306.1801459-1-song@kernel.org>
 <20220120191306.1801459-8-song@kernel.org>
 <CAADnVQL-TAZD6BbN-sXDpAs0OHFWGg3e=RafBQ10=ExXESNQgg@mail.gmail.com>
 <F72EEF0D-4F61-4AE1-B2A1-D16A5DBCCC37@fb.com>
 <CAADnVQLWj6cVE=OEqNfSBcAzFJDHPF8sPfqGfaCknV+Q=1HOmQ@mail.gmail.com>
In-Reply-To: <CAADnVQLWj6cVE=OEqNfSBcAzFJDHPF8sPfqGfaCknV+Q=1HOmQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ed65530-8ee7-46cb-a0af-08d9dd0fc1b3
x-ms-traffictypediagnostic: BN8PR15MB3329:EE_
x-microsoft-antispam-prvs: <BN8PR15MB3329BDBE5ECD706BA8576614B35B9@BN8PR15MB3329.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dMG6rc6fE0lcKVTmj2DJs9Yl3RozemyRiG3jsl3lrWbgE2YljvXIEGG+HnLuFd2jf2FFrIBBAv7AiYPke31TEFcK9v9zQphzdF4GDYmVb7S6CcMzRU2xdd4nUXrXjcWt8oAWTZEHVvfbExFcVzi2FP7m9u3M34p0nh6PKO2deOm3FShBcqNfCRCjH1RykLOMfhhPyXJDVoSMf9MBz0384EEZ/B7qemkkWhceTyBQk/LtOsZXEyNj2EBjCI6sUKIOjEOtTvzeenuL5B9WdcMoCFI/vjfIlvpvh4rA7lQaP3tD3F2FUXWP6IvQ+OPYd56j/YqnATDqM6Su0G4GtLIT3vX+nOZ5yDFX4n5nipQ19qDiYjR19Tt440pCklKyJ3R8ZD1zT+GjgvrnZOr7mc92KN9i0DuPXdnToP9YJkJ7OIfX87S3cxJxi2SVw98ZgyqwH4xCFeeRpLaaUIH/mYZugXFdVdEqr/93tjgfMkhTgSCXf5UAUQYSN/u7qKd2euXOGwHanwtLf3F3fgi0g6n5geoZ29wXeWdnKn+aJIsIsrqcpiIZpcl2YDQOVQ+cz4P2tCl2avVwzxfr0fu8UC2Xa42IociVRSLak2VLLSbJ151bT7a/TK90Po5BE5/QUu2neH9QB1vsfpFNrgKE91bhiuw+VksgY/ZPU2SRMODENsIPef5uAMKO1Wir768XG39tSImjhNg5M+4x4bJDSN2ilB3Ry9ldQxgtMrAu9prM/UuyHErCP6KheSCUrI85Om8P
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(33656002)(122000001)(76116006)(38100700002)(6512007)(186003)(7416002)(36756003)(71200400001)(86362001)(54906003)(53546011)(83380400001)(4326008)(5660300002)(38070700005)(2616005)(8936002)(66946007)(64756008)(8676002)(66446008)(66556008)(66476007)(2906002)(6506007)(508600001)(6486002)(6916009)(91956017)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Tmtd5pRAXuqe38YzRzHa4Uv44MeH858ZMl0NfxutxiUIKOlASTBLmj+shXkS?=
 =?us-ascii?Q?lwe/P+vUNu6O/5CnbIKY5ASLGrTmYc77jVKox5pk75ehlvKQHBm46mcIsQfU?=
 =?us-ascii?Q?Gw8844gHCyYOwUVHlPVapRlavo3zcB0iFZZsKGX+rJsHMYI7wVEi/denQ84y?=
 =?us-ascii?Q?ujkcs0vuhlE7dzNxpurUHuU88frNlqZa/bNiPtxvbjcfjTiaiBpQgferxtUY?=
 =?us-ascii?Q?M4mI2SP5rV/+AfWvNQoqQeTaPuWaBEPhqrN/9QYwtbbg6wJz5+FVatxqjw5L?=
 =?us-ascii?Q?7iYlqLygak3tSFtre15yHvqmJVjPwQY67IKgkZWp4TUWI+eZqLoSVxmxsxjc?=
 =?us-ascii?Q?rxAbjhyHQjgw/2GkH3Yg6tgCzDwVtVlBt5P/HGbE5M2T/pw+7Ul89dyxzqDT?=
 =?us-ascii?Q?E4f2sxUV5W/5YDQErGXC24GU03ArIgnkkdRWgdLCmgUVZQ8ncKBDdQ0BqFfe?=
 =?us-ascii?Q?Prma4qDm9qYR8kYESWO9CWQhHgACbZZQVWXBusJ0sTh531xnHlGnzOJJELII?=
 =?us-ascii?Q?k6hibo7xlg2pEjkIdE8lpxsp46pU/pRY1YwlfUNhJMPvqQGLPEBaKcWdOup4?=
 =?us-ascii?Q?MEI7VSd0lVa3sucRpovGoBOCDFxyPDaPxRzLR3nmqqKUsUwuVsr2zVI7fkQ5?=
 =?us-ascii?Q?3D5LmCGYh/3DCZI6wIb8uk88TPZ37FIKUVn6GPlgYkCj5bTgc6G85JXyxaN8?=
 =?us-ascii?Q?l1r5EjCqPfElFf2g91FoUv/+pdcnoIRF8jZYm9xWmADUaUyxw70JLQymaOdR?=
 =?us-ascii?Q?AH6rgBrmQrRH9GYBFOiv09+pBcRqG70hieFdEs9M5RZWOSKsxQxwKkUfhwc8?=
 =?us-ascii?Q?bIcoHqDog2PLks5coL1CE6kKIq1/sqlxZEuylisAj+SGT9TGPPh8j4o0IS6Y?=
 =?us-ascii?Q?oO4B+Vehis24Dt7jjttQrAho6yIoA2iUMSLYYVUZzPIl6xJYvGkCXfg+tLdG?=
 =?us-ascii?Q?5bVL8IBYk6RxFzVxuufyYXRhZgtNOAkwjRJs9pfnroh7FyJ4CPkPxEZKWZ0M?=
 =?us-ascii?Q?Nu7gqKSCvEkqpZQg0RcHWBqRXC3z9lKWKSyDDQPd2ibs1E1dg21GEBSN8GVl?=
 =?us-ascii?Q?pArDFia9Jg6ZtbmdTR9KVFducDjtEikTF0ffw2TSOXjESpLcnixe3R+wqNZx?=
 =?us-ascii?Q?AWkNrznjnKDqZJ/Xtx6SfRHDmh6IjPlP5tIFfpJ2arEg0uR86eJqrjiQeRsN?=
 =?us-ascii?Q?+akpiqb5mdjRpFPZF5NKz1/5uGSXvuz7J4BI+oOPJRAx48ghdtQcRBP8MTDp?=
 =?us-ascii?Q?TlAx8gFVSIrictCjs6CEojbIrS+NmefTHdvJDAqfUOl3bjCTDE+LzMbb1atC?=
 =?us-ascii?Q?Wmxy+Y9Jdk/XBlD86tDhCvoL/PPyf8r8c8He11M9VRtI3PsMbA4uUaKSvlId?=
 =?us-ascii?Q?0znwHbCHWJ4CmsG30dwf7i6ll65ubCP8IWufrWQxBNzNq4KfHNtyKSaQYNfw?=
 =?us-ascii?Q?H5wwWV58mbKb654fn9sYjXz1/1ZogPKmvssRMrjKDJYKMLjWapyWS10P9O31?=
 =?us-ascii?Q?ogWTC+fRWzf04t/hsBN2uRMs7TtTTa39mzWuqD+XYpaVAk6LcxrCNiDT6Zf2?=
 =?us-ascii?Q?mqI++pJxEY0NHBOAJJnFVun/bqgAof0byVvHPF1oMiTmflwIiX/OcPS7J/NN?=
 =?us-ascii?Q?Qu7+dcmwL9xHoCdUqQA14KVF/Em/7YZm/qe0YgF6HGA2LffhNRXe4blI17Bz?=
 =?us-ascii?Q?OAU7aw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F994C7ED32154B4799DAEC7B26F15B7F@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed65530-8ee7-46cb-a0af-08d9dd0fc1b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2022 18:56:39.2408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6pxyMJuCnwvGqU1aA9Vzwfr8g699fDFv9yNomczWKpfsjj9iey6qdis4tC2ks8wKtwoyhuRGUPnLQ3k04FS91Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3329
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 2Zmm6rUg6QsdE6NDjrZ5Ys-77BZm3ugT
X-Proofpoint-GUID: 2Zmm6rUg6QsdE6NDjrZ5Ys-77BZm3ugT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_09,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 impostorscore=0
 spamscore=0 malwarescore=0 adultscore=0 clxscore=1015 mlxlogscore=751
 bulkscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210123
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 21, 2022, at 10:29 AM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> On Fri, Jan 21, 2022 at 9:53 AM Song Liu <songliubraving@fb.com> wrote:
>>> 
>>> the header->size could be just below 2MB.
>>> I don't think kzalloc() can handle that.
>> 
>> Technically, kzalloc can handle 2MB allocation via:
>>  kzalloc() => kmalloc() => kmalloc_large() => kmalloc_order()
>> 
>> But this would fail when the memory is fragmented. I guess we should use
>> kvmalloc() instead?
> 
> Contiguous 2MB allocation?

Yeah, I tried that both kzalloc() and kvmalloc() could get 2MB memory.
I think kzalloc will fail when the memory is fragmented, but I haven't 
confirmed it yet.

> 
>>> 
>>>> +                               if (!tmp_header) {
>>>> +                                       bpf_jit_binary_free_pack(header);
>>>> +                                       header = NULL;
>>>> +                                       prog = orig_prog;
>>>> +                                       goto out_addrs;
>>>> +                               }
>>>> +                               tmp_header->size = header->size;
>>>> +                               tmp_image = (void *)tmp_header + ((void *)image - (void *)header);
>>> 
>>> Why is 'tmp_image' needed at all?
>>> The above math can be done where necessary.
>> 
>> We pass both image and tmp_image to do_jit(), as it needs both of them.
>> I think maintaining a tmp_image variable makes the logic cleaner. We can
>> remove it from x64_jit_data, I guess.
> 
> I'd remove from x64_jit_data. The recompute is cheap.

Will do. 

> 
> Speaking of tmp_header name... would be great to come up
> with something more descriptive.
> Here both tmp_header/tmp_image and header/image are used at the same time.
> My initial confusion with the patch was due to the name 'tmp'.
> The "tmp" prefix implies that the tmp_image will be used first
> and then it will become an image.
> But it's not the case.
> Maybe call it 'rw_header' and add a comment that 'header/image'
> are not writeable directly ?
> Or call it 'poke_header' ?
> Other ideas?

I think rw_header/rw_image is good. poke_header is confusing, as we will
text_poke "header". 

Thanks,
Song

