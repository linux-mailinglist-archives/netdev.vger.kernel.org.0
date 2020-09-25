Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE2D278CEF
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgIYPiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:38:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65454 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728527AbgIYPiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:38:11 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08PFbCZC030181;
        Fri, 25 Sep 2020 08:37:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=fVqCnkIwhJeguD+33eBFNZjlKaMxVdfuYmByIjo4+r0=;
 b=QVhultQgyvPisMrMitWp+G8YynHRFv4qdZHAdUsoEv0/AF+BcSLIZRYGyPpHp93tHKmE
 eAwyAFnor5PlHGd4bnD6v1MCgfjXAZLsbLNY06FXdP8RX2MCfzU8RwSuqYbJc/LyJts1
 SsK99lpK2AO1Z9xgduySpZLGsNDxVZ7v/ek= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp705r3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 25 Sep 2020 08:37:55 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 25 Sep 2020 08:37:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceQWXo7pyX0XcVz0VnEbOy7RgSQ2CXkjVdj+2lxtatVW38niNTrWr1EIhrZTjBLYls151tA9aoSYMCppn17Sn8xWRLTHSeDA1wy+XQqnGirHefU3//prijl8YaS4C9vQ6SlSNFioEHJzjsFZ/CpZGS8rUi6q2y40H5LWVHD2BMU9tTvbXkuSlLdltoI4/Ou4yQAx3ZXtXEIZujF4DM9Q8APCa0Kq4vOvn3gCrQMcD8NOHxsexZ8ixUW1Mw540z77PrI5owCl4ZJ/z4gjmp52svIjFduLrhhz/al9QSIjJeNFg3oUCZFX57CkfNbx/M/pT07Tmgxg8h2S2d1h362q5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVqCnkIwhJeguD+33eBFNZjlKaMxVdfuYmByIjo4+r0=;
 b=IXtAK1TJ8vZ9AVgKyOYgXVh1CRRtqQ4tZbA9lAiyAUfq0FAI8jNCDeJvouy5im/H9ptep/7GKQ042qlrmw8BDGFWR5mj3RdL60/mcYionPQ+5XSiJm+xZHMiFELnfQa+KtRSNEY5nTGZ6i4jlIJ53Dz1Gg/3N/NfRvZX+0TYEpOIKGoT/9NV/aEmaAyD+q1EU79MKtvYzoYSqOsP5PLiza6kJeRYrP4jyLDjspVFMqZqyMJ7qsA30r67XSwz6GgHvqCsoO0qX6CpTgrIh88a9KotD//D8VYTdnh/72+w+ZnUeBAph29gqMpnGShZGIZ53AWz3nGytN5EjMjCom5JVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVqCnkIwhJeguD+33eBFNZjlKaMxVdfuYmByIjo4+r0=;
 b=N7X+F7xL0dztUymy3vphIySN2HrOKgcyiSwfoKsHAXggIaPPGyoUJsQBCoL9BEXddZo+/9O15CrOtQUhDT+yIRRcoFjnijqsiX2S/ocNm74wrbUglV56jJUi8GP7JMmR69JCYY6T9I5qEbY1+1FLoroP3zqsJ/D7MZeGsDMtGPY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from MW3PR15MB3772.namprd15.prod.outlook.com (2603:10b6:303:4c::14)
 by MW3PR15MB3834.namprd15.prod.outlook.com (2603:10b6:303:4e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13; Fri, 25 Sep
 2020 15:37:50 +0000
Received: from MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::fc81:4df1:ba69:a0dd]) by MW3PR15MB3772.namprd15.prod.outlook.com
 ([fe80::fc81:4df1:ba69:a0dd%9]) with mapi id 15.20.3412.025; Fri, 25 Sep 2020
 15:37:50 +0000
Subject: Re: [PATCH bpf-next 7/9] libbpf: add BTF writing APIs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20200923155436.2117661-1-andriin@fb.com>
 <20200923155436.2117661-8-andriin@fb.com>
 <20200925035541.2hjmie5po4lypbgk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYFswwhJOq4bSDZU5-bqUo+LwwUQ_NRH_zkBgGcBVYOjw@mail.gmail.com>
From:   Alexei Starovoitov <ast@fb.com>
Message-ID: <731e94e1-b246-4838-9611-66d91d7d2518@fb.com>
Date:   Fri, 25 Sep 2020 08:37:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
In-Reply-To: <CAEf4BzYFswwhJOq4bSDZU5-bqUo+LwwUQ_NRH_zkBgGcBVYOjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:2128]
X-ClientProxiedBy: MWHPR1401CA0024.namprd14.prod.outlook.com
 (2603:10b6:301:4b::34) To MW3PR15MB3772.namprd15.prod.outlook.com
 (2603:10b6:303:4c::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:2103:c99:e09d:8a8f:94f0] (2620:10d:c090:400::5:2128) by MWHPR1401CA0024.namprd14.prod.outlook.com (2603:10b6:301:4b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.13 via Frontend Transport; Fri, 25 Sep 2020 15:37:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b59d844-de97-4dc1-8e24-08d86168f59d
X-MS-TrafficTypeDiagnostic: MW3PR15MB3834:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR15MB38345B8BB18F4ACC75D69A4CD7360@MW3PR15MB3834.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8cAiXps44gtcgKxzkGjm5q+KMUok8q8jmX/q4p4X/c/eaRooD3cjxkkD+V3A+jv2CGC9tI7byUDnrRG6C+bU+gwdcwJg5iCaE5kcgVP2PUUoP5SNpFDkXtx6IFDVKbBJY2JjOqfKIyknds7Xs8PFZfNAPhdJ+UZnfU2dxwvDgcTOahDbSiwmtkCtgdbRzET85ojwIzut39VFggOjIbhUFs3WeyIM2MtrY8zPO48qayYN8WhgKaDDbnOBzMpuDbQwMm50pgYkO2AwneZP3l7CE3RDYYbLCn2z/rRmWDIhq46yRw2khhFwLiSl5m3xyggu8oPrKD3CsApCOesg5/DOwvC3vrtf9ShuN2uF1r98pkzx4AqrXuzW7/7Mxn5KpSdhHcjc7LCPq5eNJjtlwwb2ealtxlT1SwWVfyELrf6kBT7vHb9/DIiIvggoxKZWxrBw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR15MB3772.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(396003)(346002)(53546011)(186003)(86362001)(31696002)(4326008)(316002)(36756003)(110136005)(2616005)(31686004)(66556008)(8676002)(8936002)(54906003)(16526019)(66476007)(6486002)(52116002)(83380400001)(2906002)(478600001)(5660300002)(66946007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9QsxoifH5WSB0Dm1aKslNdRC7hwE1XuYpgB9z44C77XYKD0Gkl3cdJPUBzWm6o6446yQgXzAcHJG/kuLmCrRJX9ggaE28V5DwYA1Jk7dNuNXLnbdvnkxbYw646NAc65EgHUQmNG77e16WteaghnHcsyaO58N2UpKd4H1/04/vmqTDkvjvV7u5R+0QcWLVIa9eaLunqi9aonAat6wCqruIWRm12o/fG6bIsuVw7oNwFfhr4GVF9F4m5Ep0U2IfxxlLje9u+0utxs6IiOCsu1wbDfBVZ99zLjHp0xoM0ZyLnlNlKCOjGkHwJbi/ImlZtx1oSSASlSzdSg8oYG7wyCoY/RXxgNibZRTB649tSFvHsW7ZRTA2pMQxuWr9Fw3GfeC7GCfEy8zRSAg4IjMFY729yfQ9/RP2aeqWJ2LTarpDc8wxjpz1KpPB/corW0op2DCwNcQkhBAF5dEb+YCQw1i+5NVlNDVskRZXUOLjiuFwoFtCYhiedDBrlDdsbcQi3iHDGwIrfIISRYWS1D0Ggkc3KkirqlJGkbWs+feMsspHnojkxVpQ38lEZ6KWIEhwVngpQceT3GzB89ViHJIqxnLZvxkr1VCaHup69ISD3rOOo32ei0sVze0VOADmi4hFoHmmjP6D1543JRI9ip9vbd+cQbwYveowhrGso1fS90GbejDQBNumXh+jxqzv4Nduwxt
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b59d844-de97-4dc1-8e24-08d86168f59d
X-MS-Exchange-CrossTenant-AuthSource: MW3PR15MB3772.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 15:37:50.2691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rjHvvTuXUUK9NOd7faVO76aLbTx9blH4061G/lMVI70WA7P6rDYXKlQjTjRyZqZq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3834
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-25_14:2020-09-24,2020-09-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 priorityscore=1501 clxscore=1011 impostorscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250110
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/20 11:21 PM, Andrii Nakryiko wrote:
> On Thu, Sep 24, 2020 at 8:55 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Wed, Sep 23, 2020 at 08:54:34AM -0700, Andrii Nakryiko wrote:
>>> Add APIs for appending new BTF types at the end of BTF object.
>>>
>>> Each BTF kind has either one API of the form btf__append_<kind>(). For types
>>> that have variable amount of additional items (struct/union, enum, func_proto,
>>> datasec), additional API is provided to emit each such item. E.g., for
>>> emitting a struct, one would use the following sequence of API calls:
>>>
>>> btf__append_struct(...);
>>> btf__append_field(...);
>>> ...
>>> btf__append_field(...);
>>
>> I've just started looking through the diffs. The first thing that struck me
>> is the name :) Why 'append' instead of 'add' ? The latter is shorter.
> 
> Append is very precise about those types being added at the end. Add
> is more ambiguous in that sense and doesn't imply any specific order.
> E.g., for btf__add_str() that's suitable, because the order in which
> strings are inserted might be different (e.g., if the string is
> duplicated). But it's not an "insert" either, so I'm fine with
> renaming to "add", if you prefer it.

The reason I prefer shorter is to be able to write:
btf__add_var(btf, "my_var", global,
              btf__add_const(btf,
              btf__add_volatile(btf,
              btf__add_ptr(btf,
              btf__add_int(btf, "int", 4, signed))));

In other words the shorter the type the more suitable the api
will be for manual construction of types.
Looks like the api already checks for invalid type_id,
so no need to check validity at every build stage.
Hence it's nice to combine multiple btf__add_*() into single line.

I think C language isn't great for 'constructor' style api.
May be on top of the above api we can add c++-like api?
For example we can define
struct btf_builder {
    struct btf_builder * (*_volatile) (void);
    struct btf_builder * (*_const) (void);
    struct btf_builder * (*_int) (char *name, int sz, int encoding);
    struct btf_builder * (_ptr) (void);
};

and the use it as:
     struct btf_builder *b = btf__create_global_builer(...);

     b->_int("int", 4, singed)
      ->_const()
      ->_volatile()
      ->_ptr()
      ->_var("my_var", global);

Every method will be return its own object (only one such object)
while the actual building will be happening in some 'invisible',
global, and mutex protected place.

>>
>> Also how would you add anon struct that is within another struct ?
>> The anon one would have to be added first and then added as a field?
>> Feels a bit odd that struct/union building doesn't have 'finish' method,
>> but I guess it can work.
> 
> That embedded anon struct will be a separate type, then the field
> (anonymous or not, that's orthogonal to anonymity of a struct (!))
> will refer to that anon struct type by its ID. Anon struct can be
> added right before, right after, or in between completely unrelated
> types, it doesn't matter to BTF itself as long as all the type IDs
> match in the end.
> 
> As for the finish method... There wasn't a need so far to have it, as
> BTF constantly maintains correct vlen for the "current"
> struct/union/func_proto/datasec/enum (anything with extra members).
> I've been writing a few more tests than what I posted here (they will
> come in the second wave of patches) and converted pahole to this new
> API completely. And it does feel pretty nice and natural so far. In
> the future we might add something like that, I suppose, that would
> allow to do some more validations at the end. But that would be a
> non-breaking extension, so I don't want to do it right now.

sure. that's fine.
Also I suspect sooner or later would be good to do at least partial
dedup of types while they're being built.
Instead of passing exact btf_id of 'int' everywhere it would be
human friendlier to say:
   b->_int("int", 4, singed)->_var("my_var")
instead of having extra variable that holds btf_id of 'int' and
use as it:
   u32 btf_id_of_int; /* that is used everywhere where 'int' field of 
var needs to be added */
   b->__var("my_var", btf_id_of_int);

I mean since types are being built the real dedup cannot happen,
but dedup of simple types can happen on the fly.
That will justify 'add' vs 'append' as well.
Just a thought.

