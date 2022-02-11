Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00DA4B2DE8
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 20:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352950AbiBKTml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 14:42:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236180AbiBKTmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 14:42:40 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830C7CF2;
        Fri, 11 Feb 2022 11:42:38 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21BEk4GB003731;
        Fri, 11 Feb 2022 11:42:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=ArWIh5RLkppQPydPQtkbAlX6Xmxip0nouVnHNvWG5ts=;
 b=P5NgH5hTwSQn5KruLJrUwE7CAzPHQiVVkfYWfG73kqFUhjkPw8cL01wVxINoQ44zedmc
 wKUJY3bXkIFWyRSD6eEZ2QgveQ0tX/tHwbKoYGyzmQrpDEOlxfVPCQw9+No28tIzPyhx
 zWxvMN3CwIhqqdtCZ5oTmh12N5hFBtP+qL8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e5sug22pc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 11 Feb 2022 11:42:37 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 11:42:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZT10y8etz9eNDuXqOGTRabWoaFYPShZG8lTzX6TAMYf8z6Wb46sw/yyFIXb5r5G91K9ydPv4zxGmVWOeKISPVerniofQJeNFA5D1ED7Dk7oHxDmAYIpmLpyQm84DIxbTRUVmmyqPVy6JiC8XSIOjTCeKjrAlt9Wb9x+JCbGDJa3oApImw25LPsnYI/rh8zo4I6cvL+xU/urQxz9yEdy2nhq1L7YFPm8RojqiEndE3iOfu8neIH0T7h4JQvfBcCk58rX1uheOShMi1q1zIGRQcafRjsGHDc8z1WydhyAPabv6Xv58yijbG28Y6Oqt7F18Flj/PdYorvIMO2JBx+badw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ArWIh5RLkppQPydPQtkbAlX6Xmxip0nouVnHNvWG5ts=;
 b=fBGxqULpruYXOtTbGUbTPoUxRxCaDAvTCI3jwQnoSYpPCp/UwocMye54Mu0yKFk+yn98iywKK5kWfEvsOYRDzz/NENcXtagYFHULZtDWeStPzfoJP6DudpZhktF7by/CnpLQ/eX6DM5LcZqniR/xjm4Qwjho/cFLdxxAXmUy26W7PgM6wU3Fneycrz599qjw9TEOQvcov8HZkIyV78BQVCJqZM7hEwtPe+YGjHmEsy/gjW50YOsq+Nb+xOSqwK0TQg9kL3iq74mZP30LuUZdunpKz1YcfKHCmrmoKtofceClnsrtHoqwYnnEDIwi7HSX3HvTwXDsiXSS7sG5sTTOSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB2732.namprd15.prod.outlook.com (2603:10b6:5:1ab::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 19:42:34 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e%5]) with mapi id 15.20.4951.018; Fri, 11 Feb 2022
 19:42:34 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
CC:     Song Liu <song@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Michal Hocko" <mhocko@suse.com>
Subject: Re: [PATCH bpf-next 2/2] bpf: flexible size for bpf_prog_pack
Thread-Topic: [PATCH bpf-next 2/2] bpf: flexible size for bpf_prog_pack
Thread-Index: AQHYHklKCIaff07zEkyT+B5ekpbKEqyMcwwAgACNNQCAAWxqgIAAVccA
Date:   Fri, 11 Feb 2022 19:42:33 +0000
Message-ID: <14B98886-D56E-4FE5-89F6-3A41D35B7105@fb.com>
References: <20220210064108.1095847-1-song@kernel.org>
 <20220210064108.1095847-3-song@kernel.org>
 <34d0ed40-30cf-a1a2-f4eb-fa3d0a55bce8@iogearbox.net>
 <A3FB68F3-34DC-4598-8C6B-145421DCE73E@fb.com>
 <dd6dee71-94d7-5393-8fe6-c667938ebfac@iogearbox.net>
In-Reply-To: <dd6dee71-94d7-5393-8fe6-c667938ebfac@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 670676af-2c7a-40d3-9a34-08d9ed96a649
x-ms-traffictypediagnostic: DM6PR15MB2732:EE_
x-microsoft-antispam-prvs: <DM6PR15MB2732C4D6289B525E1A609FD3B3309@DM6PR15MB2732.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fW/q+la8kW/f6Hh8Jpe6U551nm/rHQ82XjsH5HL5KTFITniXWjp4Y28gXra19F8DvYx6KjW79ySq08pJkGaNPX/3eP31s9t8f8ccDkwkjCsLAjkyX7OsaPUL1C1imopDT5IB9DHggsnMDB4O3Aj46tGO2o41QOpQo9e/y0CsGIFjp4mtgL4U50ePz0n7Czl7EYJIMetaMEMPARYKzxlj2nImL2CepTHAnsX+/QjUolsM/NbgF6HeNPmgyqrZ5g6jYLGnqmimxysfT9vXlPt+MMnrEq7Lpdk1U6V4tU1Dq/r1pznXDDHaAw7MMymthzitSTpSiXVXX+wDEuKoAxgcN6I++hWCLgsapfoA3A8slYU73Qg/GdD+S4+2DSrVQKlMo4wcWv3Hm3GZYm7VwrpR3UILHhR/Rn6omeQwZQEwnxk852LYJpp3YwnR+lNU6YV2DT6u2+u+kN2NMBK+aT0/d/gWCUJrrYpRcGjnn7JGPpQY7ym3JAPhAsceBu7A/fSgVwQnEuUZbztXQ7+OSG5pdTXcnXTQ6fGo7V3g9tAMhlBxtppRnAuWogQJ7IeGhbYX0OpGew3lHyRWcxVWUdsOjgkDlMWjIe+D8jnIxmpMCVhAIrQn/6aeVjdNT+VYiQ9TR2D5F7qmhgKReYHwLnJ1kKgIuoCF4QzXBgfRMAa4zxjky3qaoB0g9CSKTsN08sGyuvx9tRdbYLBeXvXapkg27aBl2xD+gzTydg2LcQ0lcpRjU8ZHLpj4tUj1Rpa1loAu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6916009)(316002)(186003)(5660300002)(508600001)(38070700005)(2906002)(54906003)(122000001)(2616005)(38100700002)(7416002)(6506007)(86362001)(8936002)(6486002)(66446008)(76116006)(8676002)(64756008)(91956017)(53546011)(66946007)(33656002)(71200400001)(6512007)(83380400001)(66556008)(66476007)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5lrBbgZ44Tl+SG5zYpuPd1HQTGhcfKXPb0eDuZzNW2paUxD4g/qkS5bhExII?=
 =?us-ascii?Q?Vk5ezXTMiZWlO8C0lW1uefdViNzGsp5vVd7FejJ6bVWZ40JUtBaK6/Vamt4w?=
 =?us-ascii?Q?E1vLdPvSXiCloxmSV/cXB/VtgMZff/mFsQ2zjaNtopwgHbMK/gmSS1xbUeEG?=
 =?us-ascii?Q?Lmw/UaGMJI+dKdJrz5FDsYpREDhQwJTdgmsfhBfnOlnImV2hYgmO6XyiCgVQ?=
 =?us-ascii?Q?KGg8o63+a8sTC2ozCENgNITVzry+WYXMERPbBOQ2qi3AWZD/czyAZWtUIUaK?=
 =?us-ascii?Q?blviapuHDKnHO5RtnHlwhsyZ8SMEvQKM8SC8kvymnVe/LFQUxdAxXourM2kK?=
 =?us-ascii?Q?zTrJWBl8fQ2wReu/hdEcYfLg4cIEjENscjbZdv5/CyY2sZRPkU4WieJr/B6F?=
 =?us-ascii?Q?KP8V6Y1NbGqLj0YC6HmusuSiRSaqUw3bvT6um4iwMeqQkcrYAHhK6/m88qy4?=
 =?us-ascii?Q?0Mnhr1x+EpKUchp/JQWPjbO+1NNEBo8toRzFu+nhs44ZgnxKV9LRCk+YnsOx?=
 =?us-ascii?Q?5voWn2mGsalWv52Ltw+2Qzlh2t6yMn2UdIqqaAbSZ0EaGzZSuUpm36PFCd8F?=
 =?us-ascii?Q?PSTTtxvzdtfZfeJPn5zx9tgZY9dsIy26jtWHp8FJVyWEHRF/mXC0WvngJMs4?=
 =?us-ascii?Q?OW2IEY0uDJ8JQVJ0Ot5N+56I5L4e/JjHjJXWhzIxQ3QLGSryVaaj4bm6K/cj?=
 =?us-ascii?Q?+dPKLD/nH/j3KSo7E51Q2jBA2IfiOrmZ0XRSR006CI/QXjRorwOb+lIFzHpo?=
 =?us-ascii?Q?OjxOL7epS2AIjNSTG4PGGo8ZCFUC9PbkZirlZhTDs6KIQu4rZnHx1X1N2WpN?=
 =?us-ascii?Q?5XYh1evh1/vKYUA1yAahMFSeNjs3LOMlbM2Sf94rNC0tC4DZxtb/mKrug8HD?=
 =?us-ascii?Q?7Ua9e3joy1UHj5d+VBiiYlJVKt2OViG3UwpaXqEAhv5lB1hG1H/X+KPSZCZb?=
 =?us-ascii?Q?xNpYNQeKMI2/aYezysh1ysTfWligYD6xTFMf8yXD784OroIOScSNx9P/Ec52?=
 =?us-ascii?Q?s0FguNx2eeTr38h9z9pznSrc/CCjVzxiYVRhV/K36c0GZvvhsd4PK43HusEs?=
 =?us-ascii?Q?W0MC8qQ07bIfxfjHUNyu1gQCT40OPXwP9nkexuf34bbG4U11O4+daDMW+MQ2?=
 =?us-ascii?Q?xdmW9e1zfxPgMqPpr7micRHNYRbGruQ+KDJ1MVqIUIsYFlgAV13SeSOtmRhL?=
 =?us-ascii?Q?GS0R5iI/iTsBXsoY0C6xpNobRq3R0E49sEb5aLsXgqN5ysU7LNpfQf+0XVsw?=
 =?us-ascii?Q?tBOXwI6Rl9AUAb0VExdcfvFZJbNKZP+lwzjVmt+LcUy9jV3dtCDBSQ96qkIr?=
 =?us-ascii?Q?jqdJkRk+rhY+E7rIcGGEQQcMgR1n5VnBY+5tGppfejMGsrYZc06uVQbhtSKl?=
 =?us-ascii?Q?JKFvgFTp+WKRjnRbAsGOZuvA+isCNL3f/jVpm7NmQK1nfSSLHbFsMkD7qwGO?=
 =?us-ascii?Q?Xlijww7gR95pzDX4IUkyBVn5DsfHNAxIhjwT+KcDKbf5z2/lQktw79kp30A3?=
 =?us-ascii?Q?aJCKQucKeyuZ4XV/ZEZd08lGWPsE9OSEVnvuXdAuYJXWkSAxpH+JNlU8xdwg?=
 =?us-ascii?Q?vQB/deMO4p9bL480FXqG+rQUVTeNYyhdc5mQo6kjmEG1Qa2KNvMacQrnhIXr?=
 =?us-ascii?Q?37jGvlkl66EmBmygf+bAC6qVy+RSgixd4b5PtFQ6km4Ey65DcDjWAq+uiVZg?=
 =?us-ascii?Q?P0Hcgw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <47B3BA2A3AD9A34698909A821DC9B1BF@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 670676af-2c7a-40d3-9a34-08d9ed96a649
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 19:42:33.9560
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BdYYWgv0MZd5bQbETipy+Tclw/GPSdImkzJSNv0dnsLZzyOPkJmfoYoFXuH3sHqHi2HL+oRx1n6pcDAUJDX+vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2732
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 3hcpz9wnW_NpKxEHIUUCgAUW3VYbLDdp
X-Proofpoint-GUID: 3hcpz9wnW_NpKxEHIUUCgAUW3VYbLDdp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-11_05,2022-02-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 clxscore=1011 adultscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2202110104
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



> On Feb 11, 2022, at 6:35 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
> On 2/10/22 5:51 PM, Song Liu wrote:
>>> On Feb 10, 2022, at 12:25 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
>>> On 2/10/22 7:41 AM, Song Liu wrote:
>>>> bpf_prog_pack uses huge pages to reduce pressue on instruction TLB.
>>>> To guarantee allocating huge pages for bpf_prog_pack, it is necessary to
>>>> allocate memory of size PMD_SIZE * num_online_nodes().
>>>> On the other hand, if the system doesn't support huge pages, it is more
>>>> efficient to allocate PAGE_SIZE bpf_prog_pack.
>>>> Address different scenarios with more flexible bpf_prog_pack_size().
>>>> Signed-off-by: Song Liu <song@kernel.org>
>>>> ---
>>>>  kernel/bpf/core.c | 47 +++++++++++++++++++++++++++--------------------
>>>>  1 file changed, 27 insertions(+), 20 deletions(-)
>>>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>>>> index 42d96549a804..d961a1f07a13 100644
>>>> --- a/kernel/bpf/core.c
>>>> +++ b/kernel/bpf/core.c
>>>> @@ -814,46 +814,53 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>>>>   * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
>>>>   * to host BPF programs.
>>>>   */
>>>> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>> -#define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
>>>> -#else
>>>> -#define BPF_PROG_PACK_SIZE	PAGE_SIZE
>>>> -#endif
>>>>  #define BPF_PROG_CHUNK_SHIFT	6
>>>>  #define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
>>>>  #define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))
>>>> -#define BPF_PROG_CHUNK_COUNT	(BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE)
>>>>    struct bpf_prog_pack {
>>>>  	struct list_head list;
>>>>  	void *ptr;
>>>> -	unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
>>>> +	unsigned long bitmap[];
>>>>  };
>>>>  -#define BPF_PROG_MAX_PACK_PROG_SIZE	BPF_PROG_PACK_SIZE
>>>>  #define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
>>>>    static DEFINE_MUTEX(pack_mutex);
>>>>  static LIST_HEAD(pack_list);
>>>>  +static inline int bpf_prog_pack_size(void)
>>>> +{
>>>> +	/* If vmap_allow_huge == true, use pack size of the smallest
>>>> +	 * possible vmalloc huge page: PMD_SIZE * num_online_nodes().
>>>> +	 * Otherwise, use pack size of PAGE_SIZE.
>>>> +	 */
>>>> +	return get_vmap_allow_huge() ? PMD_SIZE * num_online_nodes() : PAGE_SIZE;
>>>> +}
>>> 
>>> Imho, this is making too many assumptions about implementation details. Can't we
>>> just add a new module_alloc*() API instead which internally guarantees allocating
>>> huge pages when enabled/supported (e.g. with a __weak function as fallback)?
>> I agree that this is making too many assumptions. But a new module_alloc_huge()
>> may not work, because we need the caller to know the proper size to ask for.
>> (Or maybe I misunderstood your suggestion?)
>> How about we introduce something like
>>     /* minimal size to get huge pages from vmalloc. If not possible,
>>      * return 0 (or -1?)
>>      */
>>     int vmalloc_hpage_min_size(void)
>>     {
>>         return vmap_allow_huge ? PMD_SIZE * num_online_nodes() : 0;
>>     }
> 
> And that would live inside mm/vmalloc.c and is exported to users ...

Yeah, this will go to vmalloc.c.

> 
>>     /* minimal size to get huge pages from module_alloc */
>>     int module_alloc_hpage_min_size(void)
>>     {
>>         return vmalloc_hpage_min_size();
>>     }
> 
> ... and this one as wrapper in module alloc infra with __weak attr?

And this goes to some module.c file(s). I am not quite sure whether we
need __weak attr or not. 

> 
>>     static inline int bpf_prog_pack_size(void)
>>     {
>>         return module_alloc_hpage_min_size() ? : PAGE_SIZE;
>>     }
> 
> Could probably work. It's not nice, but at least in the corresponding places so it's
> not exposed / hard coded inside bpf and assuming implementation details which could
> potentially break later on.

I don't really like it either. 

Another way to do this is to test the required size for bpf_prog_pack 
in BPF code, something like the following. The pro of this version is 
that we don't need changes in vmalloc and module code. 

Thanks,
Song



diff --git i/kernel/bpf/core.c w/kernel/bpf/core.c
index 44623c9b5bb1..3cfd0f0c93d2 100644
--- i/kernel/bpf/core.c
+++ w/kernel/bpf/core.c
@@ -814,15 +814,9 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
  * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
  * to host BPF programs.
  */
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#define BPF_PROG_PACK_SIZE     HPAGE_PMD_SIZE
-#else
-#define BPF_PROG_PACK_SIZE     PAGE_SIZE
-#endif
 #define BPF_PROG_CHUNK_SHIFT   6
 #define BPF_PROG_CHUNK_SIZE    (1 << BPF_PROG_CHUNK_SHIFT)
 #define BPF_PROG_CHUNK_MASK    (~(BPF_PROG_CHUNK_SIZE - 1))
-#define BPF_PROG_CHUNK_COUNT   (BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE)

 struct bpf_prog_pack {
        struct list_head list;
@@ -830,30 +824,56 @@ struct bpf_prog_pack {
        unsigned long bitmap[];
 };

-#define BPF_PROG_MAX_PACK_PROG_SIZE    BPF_PROG_PACK_SIZE
 #define BPF_PROG_SIZE_TO_NBITS(size)   (round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)

+static int bpf_prog_pack_size = -1;
+
+static inline int bpf_prog_chunk_count(void)
+{
+       WARN_ON_ONCE(bpf_prog_pack_size == -1);
+       return bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE;
+}
+
 static DEFINE_MUTEX(pack_mutex);
 static LIST_HEAD(pack_list);

 static struct bpf_prog_pack *alloc_new_pack(void)
 {
        struct bpf_prog_pack *pack;
+       void *ptr;
+       int size;

-       pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(BPF_PROG_CHUNK_COUNT), GFP_KERNEL);
-       if (!pack)
+       /* Test whether we can get huge pages. If not just use PAGE_SIZE
+        * packs.
+        */
+       if (bpf_prog_pack_size == -1) {
+               size = PMD_SIZE * num_online_nodes();
+               ptr = module_alloc(size);
+               if (is_vm_area_hugepages(ptr)) {
+                       bpf_prog_pack_size = size;
+                       goto got_ptr;
+               } else {
+                       bpf_prog_pack_size = PAGE_SIZE;
+                       vfree(ptr);
+               }
+       }
+
+       ptr = module_alloc(bpf_prog_pack_size);
+       if (!ptr)
                return NULL;
-       pack->ptr = module_alloc(BPF_PROG_PACK_SIZE);
-       if (!pack->ptr) {
-               kfree(pack);
+got_ptr:
+       pack = kzalloc(sizeof(*pack) + BITS_TO_BYTES(bpf_prog_chunk_count()), GFP_KERNEL);
+       if (!pack) {
+               vfree(ptr);
                return NULL;
        }
-       bitmap_zero(pack->bitmap, BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE);
+       pack->ptr = ptr;
+       bitmap_zero(pack->bitmap, bpf_prog_pack_size / BPF_PROG_CHUNK_SIZE);
        list_add_tail(&pack->list, &pack_list);

        set_vm_flush_reset_perms(pack->ptr);
-       set_memory_ro((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
-       set_memory_x((unsigned long)pack->ptr, BPF_PROG_PACK_SIZE / PAGE_SIZE);
+       set_memory_ro((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
+       set_memory_x((unsigned long)pack->ptr, bpf_prog_pack_size / PAGE_SIZE);
        return pack;
 }

@@ -864,7 +884,7 @@ static void *bpf_prog_pack_alloc(u32 size)
        unsigned long pos;
        void *ptr = NULL;

-       if (size > BPF_PROG_MAX_PACK_PROG_SIZE) {
+       if (size > bpf_prog_pack_size) {
                size = round_up(size, PAGE_SIZE);
                ptr = module_alloc(size);
                if (ptr) {
@@ -876,9 +896,9 @@ static void *bpf_prog_pack_alloc(u32 size)
        }
        mutex_lock(&pack_mutex);
        list_for_each_entry(pack, &pack_list, list) {
-               pos = bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
+               pos = bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
                                                 nbits, 0);
-               if (pos < BPF_PROG_CHUNK_COUNT)
+               if (pos < bpf_prog_chunk_count())
                        goto found_free_area;
        }

@@ -904,12 +924,12 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
        unsigned long pos;
        void *pack_ptr;

-       if (hdr->size > BPF_PROG_MAX_PACK_PROG_SIZE) {
+       if (hdr->size > bpf_prog_pack_size) {
                module_memfree(hdr);
                return;
        }

-       pack_ptr = (void *)((unsigned long)hdr & ~(BPF_PROG_PACK_SIZE - 1));
+       pack_ptr = (void *)((unsigned long)hdr & ~(bpf_prog_pack_size - 1));
        mutex_lock(&pack_mutex);

        list_for_each_entry(tmp, &pack_list, list) {
@@ -926,8 +946,8 @@ static void bpf_prog_pack_free(struct bpf_binary_header *hdr)
        pos = ((unsigned long)hdr - (unsigned long)pack_ptr) >> BPF_PROG_CHUNK_SHIFT;

        bitmap_clear(pack->bitmap, pos, nbits);
-       if (bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
-                                      BPF_PROG_CHUNK_COUNT, 0) == 0) {
+       if (bitmap_find_next_zero_area(pack->bitmap, bpf_prog_chunk_count(), 0,
+                                      bpf_prog_chunk_count(), 0) == 0) {
                list_del(&pack->list);
                module_memfree(pack->ptr);
                kfree(pack);


