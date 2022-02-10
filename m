Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36804B1378
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244576AbiBJQvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:51:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244375AbiBJQvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:51:17 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB28CEE;
        Thu, 10 Feb 2022 08:51:18 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21AGU9GP028414;
        Thu, 10 Feb 2022 08:51:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=zm4nQanzWW40/tL++7jZ/qrx65KA2GStYn/rhGUpoM4=;
 b=Yeenj7k8GhHnll9uS93sevULn+QeX6Pn5brM8LbbqiXVkS35P2XZwtUuL/8gkrUL0XI5
 8Z5iTQ1DKursyf+3Q8G/+ssRSSBzL+Lea6jFucHKdy8muX05rqkqMceT1B86tvB8cJ4q
 F2KqgE5C+XYU/5iAy0yBKLIKh0IhkIeDL5g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3e4sd2medh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 10 Feb 2022 08:51:17 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Feb 2022 08:51:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEPg7xzBhI2ZNb3noaS/mL59OiXUk5uAEWmAmcpC9ZiTvo2/IWmoPr3TXhaxg1O959BfIiv0hjwFFqVPGpiYfQnTgKaXwO2mi7Ulx7YnaRLot7vZkrHNN7LKxGksGqTEoScJH0PkiJxzGemaS1B8+GfySSQL61QTA9IAxuziDdyQvEm8QxJn9a4Xi4tZPr+FMeQd6L8U71DYrqOJeoBEzKg3TTWs/uLo8d9J08sUGH/IRNTgWrtTVx/enAJ34ECwYZCIL6FUuPKuCoS5+xVCk6DNcLf4vTZGI9la3Lw+9qZDEDlqYgign5k/E74v799rWEfMrRyrEIry04kA1TlDNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zm4nQanzWW40/tL++7jZ/qrx65KA2GStYn/rhGUpoM4=;
 b=jmwR4iRKe+N/M5pzwUZQrOAT428CoauIfSCsYb5jdhas4gllrzp9pU8LU3vA6KuIi7+3Bpz1m2ZCbZ4tni20drzyJ328mqgY+qTBtMF1tZKnKQ+O+hxd1WOmcPPidqlXLmWYQpxVXRwEWMFvunI5LxxeczSe1fT1xtRXT2UWZSIm3yJcWwPetRa0bbEia2Dl2Vwk7hcCvyCnmn9jzHfWBdzSoQhcL7q1boOk6wKpEZZxkuDunbw6eVmkynTuSYkRF2aOS1PY4tUnSr83O6gQLgO2ligngLh/36bH+fBADCo3fBoj9FjF0aJ0rE6O6Lf+B+8ZfJuzJxjQg/g3w1p4zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BYAPR15MB4135.namprd15.prod.outlook.com (2603:10b6:a03:a0::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 16:51:15 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e%5]) with mapi id 15.20.4951.018; Thu, 10 Feb 2022
 16:51:15 +0000
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
Thread-Index: AQHYHklKCIaff07zEkyT+B5ekpbKEqyMcwwAgACNNQA=
Date:   Thu, 10 Feb 2022 16:51:14 +0000
Message-ID: <A3FB68F3-34DC-4598-8C6B-145421DCE73E@fb.com>
References: <20220210064108.1095847-1-song@kernel.org>
 <20220210064108.1095847-3-song@kernel.org>
 <34d0ed40-30cf-a1a2-f4eb-fa3d0a55bce8@iogearbox.net>
In-Reply-To: <34d0ed40-30cf-a1a2-f4eb-fa3d0a55bce8@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b270785-7dfe-4e90-8a88-08d9ecb58d17
x-ms-traffictypediagnostic: BYAPR15MB4135:EE_
x-microsoft-antispam-prvs: <BYAPR15MB41359BB760A5F747F2E94D2EB32F9@BYAPR15MB4135.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EueHGdeKe2322BTeMeASZwjE7QcLcmK2CskAjFnZGEnrG+eu7GOpconJZarxyLnBHD2y6Ac4VR+KtZu2KX6fYtmGj4uEMGR8wacp1doa0hvKmqcq0O82nIRmWcWVMP4f6YVabUefzitKoZFYygCYKaKbX0zwao60RnD8Sm3wSUJvZ1oUiOs37LqxmzpmqRbkbQg2Ur3xsI8Obgr7Bq7BTllno/ukA4C3X4lo8/n0fsgoWgA2c3VgQdqdZf9wDMvJC7MRJUfpKmtlN3TXE7gkioDsKWQMnegA1l2UPruiyLvdpbXYQEIFa3j9WIFMa081D0YwOv5Q6N49PnQNH0hUBqNZCTNJ1S4HxBH+AApqsAXAyLDGqAEVhYfnPNSgRVtqzhg8q6t/MiJGPvDlUw5VucJdcpGoGfGTRFIzbODO1YOhS2B25SiRRhRmpL8cGyZ6MYwgi9ey05CXug1V56zsbXYpFvecbb3qcE/m1Q3/TDvsUiP9LMPt3InuZPIYOSPpDb/lqHiVcQN3vtAFDw66Jl9WgDmPkhdBoCfknZ5d8iLLNdw5fojhTDBpyw/0OYJTC0z90IuN0GAJ/CsdC1m06ab2fnr/AzaTC4BqE//2f+lemVem6TDuKTZeDlXq0LBBMA5a4ve+4wmB2XJZir8PtQLm0GWyaCLVr9LbSYRHpM48+BY9LKUwAZzj4aizkalLARw+adC1t/sMBzUlG6bN5iY+NtGHi0ZWTbJfiu+HEeM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(2906002)(6512007)(54906003)(316002)(36756003)(6916009)(86362001)(83380400001)(71200400001)(66556008)(66446008)(91956017)(33656002)(6506007)(64756008)(8676002)(4326008)(53546011)(8936002)(6486002)(122000001)(66476007)(66946007)(76116006)(186003)(508600001)(7416002)(2616005)(5660300002)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RZcMdpLNuDl6o4OjkjXvI9wFFlVaNjLBfz6poVB3k0OV4umTQjWHcYZ17OcW?=
 =?us-ascii?Q?BpRZF7Lg3Vrhf64h6/326HkPko34ZIzbuM/ne5OOFIs+7LJZ1IEUcVK9OHqa?=
 =?us-ascii?Q?rVj6dtACurRPSSkrvPq9XAOC4gaDVPesirst7qt1ihMeSU4+57Y1Itk3xohi?=
 =?us-ascii?Q?sEbSFte4QfjYt5rGfnwYsQQ2xeW78iMdZPOEIiM8109NLreC6vaKhiEBlHNq?=
 =?us-ascii?Q?LKnrALVRdRfRU/XpkdzAeSXYtKmrP3rxickEj6VDPlQXaqcMWABR1zRQsd5k?=
 =?us-ascii?Q?O/8GnT3HoDRylqOtVSFVUA3sF0gVACNp5VLdNlQbPagvQy5Tvj+OLO48/Qd5?=
 =?us-ascii?Q?yZvrTvt1Mf9a0Xjt/VixcOhBfOdArJVa+WJsIiJ7yo3iO0C/ELbYegd/XKw4?=
 =?us-ascii?Q?fCwcJAsKlE7kY7a7/p+DR01FZVDR7QFh5SkNOIzxY1Qd2u/D20/wjvTm8ae7?=
 =?us-ascii?Q?styiCnTgtqOqp6o6tpd8h3B4EZjdmJ88MJ9plSjkYHFLMP96Z+RJhoXOZmkA?=
 =?us-ascii?Q?MiJsD/IIbruPnl+/niuk64PlNu/++Y9SGubBoljaSeQNTbSh+J8M63WATIq1?=
 =?us-ascii?Q?0iuIbU10GN8hnQ3l+YowC+H4kvZQCpRBFFMZHa9m2KTSu66VVD3bHLLZXLY8?=
 =?us-ascii?Q?+Ac5cQkFwnX9xj7G0hFVcVpZf9+nJRIb2rk/VBEnrevRH/8Pd3k59lQEUV7P?=
 =?us-ascii?Q?rOTxK/pxwWrYWnKbwEqmFe1aktpsiEXsKW7AXcJ2hk8FlvXoqmGW6tMmnoe4?=
 =?us-ascii?Q?6nqj/N0EToMYyjNU7uq9Ho1JBEMFLm7Sf7+dfRc55U2uYIcbtr3QpzXZMWcJ?=
 =?us-ascii?Q?qhtTe+WE2b4wHw6eqfJCw3Q4Se3/mjZtERSwJx8NzC1xAM32gaGpfmNIF4qG?=
 =?us-ascii?Q?45/ubTWKfEBvnrKuZJkjZyaEEagBCo4ibwqkN6/czhNeHGQ0+XWuxfXVzhdp?=
 =?us-ascii?Q?z0Apnv0AJqD700xhu4ctwpwGyPysIhWb1k3eAzsFLXndNR+Eo5hYInvknHj0?=
 =?us-ascii?Q?BT5JGvB8gpSiNfhKd+MAI0gWuNX31dNI5WzDhgx6Pai7hslajPjswhSdEImh?=
 =?us-ascii?Q?LBxua5L9/P197dqIPFIZ55dRDj7WIUVFRsNykNmpXL3wHa42x4xJuqs2teW2?=
 =?us-ascii?Q?YDi5FrCiM4YH+qvL2S6e/aZeV5cn3aH1l/WdaG7qSo1qpQmb++jTNMZhL9Q5?=
 =?us-ascii?Q?V+3cwXdLgLNIb2EN+F50pVWiwmF2/kprA88mIOZsWz4HoBR1pn51Ei8G7WaS?=
 =?us-ascii?Q?Liq9XAgiGQ/mQ42A6BVC2F3UK7rcC3zWLPunX/ydhVzFpLbXCjqZ+By4YHVI?=
 =?us-ascii?Q?omMWMui/6vLfHt3BRe3/CblzMN9ylwintslk1pnA2T8X6kANVt5lmAH8Eakz?=
 =?us-ascii?Q?STPcEWWlVa7sU0bXSEiRGjxNSvGeLUtbtuzvXc/AiQEHewI/lzYjqEJJqQcW?=
 =?us-ascii?Q?ba9AijI5IJJ4NE1jtkw5y+358iZQDf2ZvEE0InnBfhtIYjTBa5BH8o/9tZim?=
 =?us-ascii?Q?eJXCaA8awfeMiYcqrpSfSaESgI61mkaPfb8WY4ZXAshKHIvyxfQrR9d9Ykvu?=
 =?us-ascii?Q?Uo/VAmkNqmuolm2Uvv3UbjFXgxRx4Nzfz8fjgkMqzqIxCXTG/JcGtVjPHaHP?=
 =?us-ascii?Q?3zUb/hfUrQJGJoZiIJzOMzjUPP2asm4g4FnRtEcVXoobLNE3XAItFaI0GmfN?=
 =?us-ascii?Q?dTmfBQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CFB87DB8BFD9AA46AF5438216E5A08A5@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b270785-7dfe-4e90-8a88-08d9ecb58d17
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 16:51:14.8752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NwhBugq61T0Qwr7tGXpXoJXy/tqu0nEavi6K2MPdtPIIB610eq0ceT1qjKE6f+LfkWtnAGJfwUQ5SwU4v2gWFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4135
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: i1gg_sRmGSN4XXhREJobWjJTBlEBnhDV
X-Proofpoint-ORIG-GUID: i1gg_sRmGSN4XXhREJobWjJTBlEBnhDV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-10_07,2022-02-09_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 phishscore=0 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202100088
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



> On Feb 10, 2022, at 12:25 AM, Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
> On 2/10/22 7:41 AM, Song Liu wrote:
>> bpf_prog_pack uses huge pages to reduce pressue on instruction TLB.
>> To guarantee allocating huge pages for bpf_prog_pack, it is necessary to
>> allocate memory of size PMD_SIZE * num_online_nodes().
>> On the other hand, if the system doesn't support huge pages, it is more
>> efficient to allocate PAGE_SIZE bpf_prog_pack.
>> Address different scenarios with more flexible bpf_prog_pack_size().
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>>  kernel/bpf/core.c | 47 +++++++++++++++++++++++++++--------------------
>>  1 file changed, 27 insertions(+), 20 deletions(-)
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 42d96549a804..d961a1f07a13 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -814,46 +814,53 @@ int bpf_jit_add_poke_descriptor(struct bpf_prog *prog,
>>   * allocator. The prog_pack allocator uses HPAGE_PMD_SIZE page (2MB on x86)
>>   * to host BPF programs.
>>   */
>> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -#define BPF_PROG_PACK_SIZE	HPAGE_PMD_SIZE
>> -#else
>> -#define BPF_PROG_PACK_SIZE	PAGE_SIZE
>> -#endif
>>  #define BPF_PROG_CHUNK_SHIFT	6
>>  #define BPF_PROG_CHUNK_SIZE	(1 << BPF_PROG_CHUNK_SHIFT)
>>  #define BPF_PROG_CHUNK_MASK	(~(BPF_PROG_CHUNK_SIZE - 1))
>> -#define BPF_PROG_CHUNK_COUNT	(BPF_PROG_PACK_SIZE / BPF_PROG_CHUNK_SIZE)
>>    struct bpf_prog_pack {
>>  	struct list_head list;
>>  	void *ptr;
>> -	unsigned long bitmap[BITS_TO_LONGS(BPF_PROG_CHUNK_COUNT)];
>> +	unsigned long bitmap[];
>>  };
>>  -#define BPF_PROG_MAX_PACK_PROG_SIZE	BPF_PROG_PACK_SIZE
>>  #define BPF_PROG_SIZE_TO_NBITS(size)	(round_up(size, BPF_PROG_CHUNK_SIZE) / BPF_PROG_CHUNK_SIZE)
>>    static DEFINE_MUTEX(pack_mutex);
>>  static LIST_HEAD(pack_list);
>>  +static inline int bpf_prog_pack_size(void)
>> +{
>> +	/* If vmap_allow_huge == true, use pack size of the smallest
>> +	 * possible vmalloc huge page: PMD_SIZE * num_online_nodes().
>> +	 * Otherwise, use pack size of PAGE_SIZE.
>> +	 */
>> +	return get_vmap_allow_huge() ? PMD_SIZE * num_online_nodes() : PAGE_SIZE;
>> +}
> 
> Imho, this is making too many assumptions about implementation details. Can't we
> just add a new module_alloc*() API instead which internally guarantees allocating
> huge pages when enabled/supported (e.g. with a __weak function as fallback)?

I agree that this is making too many assumptions. But a new module_alloc_huge() 
may not work, because we need the caller to know the proper size to ask for. 
(Or maybe I misunderstood your suggestion?)

How about we introduce something like 

    /* minimal size to get huge pages from vmalloc. If not possible, 
     * return 0 (or -1?)
     */
    int vmalloc_hpage_min_size(void)
    {
        return vmap_allow_huge ? PMD_SIZE * num_online_nodes() : 0;
    } 

    /* minimal size to get huge pages from module_alloc */
    int module_alloc_hpage_min_size(void)
    {
        return vmalloc_hpage_min_size();
    }

    static inline int bpf_prog_pack_size(void)
    {
        return module_alloc_hpage_min_size() ? : PAGE_SIZE;
    }

Thanks,
Song
