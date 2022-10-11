Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C20645FB8EB
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 19:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbiJKRFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 13:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiJKRFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 13:05:23 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6892222BD;
        Tue, 11 Oct 2022 10:05:20 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29BGffg0026229;
        Tue, 11 Oct 2022 10:05:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=kBum9N8dMEfY62EOz2kyIR478XYDmfyZYIDiZVZEJsA=;
 b=Pyhw8D6Aa8jJtcJmDGZEfrAbBcsMLLtEe3Xgt1tZKgRnXZeOBRRQXERoszW0H1v9FyCI
 9kWaY8+cnpJILu7wDWaZ55wagxZpmK6Ewi8rvPXD1xsDHhjPtfBWADP+4LrwRmtQe3MB
 a+yNCWGkXybRMCoyo+MF5O7DCmWRKIPRjqlQFoc016pxDWjg6YwaiJQTAZdb8Ecp6Wku
 t4WeCEMD+oT+My03cD+8radWb2eBqfEANxIUAisrC33WCdB++qNduGCQ5I2Iwt75wKEW
 R5mZ5yFNELF0WSMJd9Dp8l/5v2ozFOYUb/3+pxXa3+O0cqrKlKbbhVKK+S+N2IF9XJbH yg== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3k4q14hu1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Oct 2022 10:05:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJO1OMsd+1hFaA3DbJ08i9Prp59dvqzzrKnqr6rjHpGipWFbwCpVYSDTWoB+0Brb9LdOoUXuACiwngAEjcN5c1v5GzdUymMn1g2ZU9hoOHtWXfkSqeamMEBxYtzWuPPto9QYQ2gEZTRp8dChxDwZ/qEZqPfZZPiFDv5wkMpc/iN8N2BSq/hN9aUhQHC7vXfJT7VmUH7NnTnwLzTsJ0zfmfh7rlcLNBYr49oGsj6yUznfjzigCeISxSFQ/P1ZN1/W0HodYmynBktYoHyx7zQELeEjSKaq4dyLSt4msyf2957UdZxAmRc9T8MP7IX9iE0jVeNvXP8E9GWHBqNhnohaaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kBum9N8dMEfY62EOz2kyIR478XYDmfyZYIDiZVZEJsA=;
 b=LjHclZUu/zuvAsV6OrvatuXD+t9rQuQaccQnTwQlrOPfdPw8ZtzfWKnXgXiUi04iQBPmQUCG/kGfmHH4uXwIqg4hWFi1SaqZEm1XUxvv73A6wwXHAx6Vt6duztmdA6RFthf1DqV97T9WW9nto1sJSwobHuxDFUgETcU+xsu8oNqZPXWkXUxU0k+twkZa1Tm54xjFkDyMkKJQmTRVQMc3IfnZEyf1aQJ2rg3fFZ7GkA+QwQQIUdwP2cV1yWZ69qWg33xhx54Y5jTdW0EE0SKmiMcRZ1QTf+NqGCmNZRGj6t21j2x1UmM/4Mir0TgUjNhADgbtZAKOVzS5lKW2LdNHhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from DM6PR15MB4039.namprd15.prod.outlook.com (2603:10b6:5:2b2::20)
 by SA0PR15MB4063.namprd15.prod.outlook.com (2603:10b6:806:86::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Tue, 11 Oct
 2022 17:05:07 +0000
Received: from DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::192a:3127:20ff:4d71]) by DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::192a:3127:20ff:4d71%8]) with mapi id 15.20.5676.040; Tue, 11 Oct 2022
 17:05:07 +0000
Message-ID: <e6dea7cb-ba5b-df4a-eae7-0d3e026baf33@meta.com>
Date:   Tue, 11 Oct 2022 13:05:04 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [RFC Patch v6 1/5] bpf: Introduce rbtree map
Content-Language: en-US
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     yangpeihao@sjtu.edu.cn, toke@redhat.com, jhs@mojatatu.com,
        jiri@resnulli.us, bpf@vger.kernel.org, sdf@google.com,
        Cong Wang <cong.wang@bytedance.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
References: <20221005171709.150520-1-xiyou.wangcong@gmail.com>
 <20221005171709.150520-2-xiyou.wangcong@gmail.com>
From:   Dave Marchevsky <davemarchevsky@meta.com>
In-Reply-To: <20221005171709.150520-2-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-ClientProxiedBy: BL1PR13CA0274.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::9) To DM6PR15MB4039.namprd15.prod.outlook.com
 (2603:10b6:5:2b2::20)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR15MB4039:EE_|SA0PR15MB4063:EE_
X-MS-Office365-Filtering-Correlation-Id: c5204b70-6239-4b6b-d204-08daabaabf54
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kBJQPU2kUiTMlsQl6SQU/VeXccxsCYSZ+XlH2hae1Q7lOn9EDBck66DH9NITDZWiivDNTPQ00qKB08BARohB7h8fr8ygDZxd55dGsJfYZYK6L2Wi68t+urBijTUNVZdcpeSI1gwfqvYT8mHRnXzaD/trJkOnDETsIQlbZQbcJ984Mr6pu2l9NO3CLjPs0Z1FIVR2avqEF6p5T1EJkSb3NG69tVak8ShXR5V4fX+BhZureEtoDHbFK2Sa56UtiL6Nwab6slbWRpzZxITKOs6gTJvrFljPy1ZBiqoG8dFkZxrtZC9tQwDv0B5S0yiEKxK/smChv9+Fhezec6FK1HIuy9FfuIrSU2+XmsqjFWMVOc72wynUUHgudeWNnEgD5IEf1vQw3pnj6ek9W9gyEKFH7qa8RnG19WZBxkGOvdPo8d9T/uFYss3em32kbK09teGOtPVss4ATZuyE87SZQf2rK5Wgv+Bpux85+itSSJd4VKOgGCSEAMC68hqdZmajCzrQk/pkwGTAFUW8xlIMs0NDHVAoNmUA1XGCGIasFfj4kskBHkq13MFgPaH4+vpcbumL0mVADhMrRC7aGtlOOOOy6xwk1TfB73S/7WeRUo9RUMKfGbDGS/TH3YR6ceBzAW/+qaxUAkFgZj37C2hqaIwDqzZ9HEUP3uU2f1/peVXqSgj7LXXn+HtiizST1faYXVcbr3Czw37FgiDBSwzGCm57oTvrHLDmHbHAxr+eNTJD5kSPHAwo+K0/WoloqoEyo58UED9ALFy0/kq80cc58VHkIjrkFPF/ar29Ig16GlW3fzXlYabxZCjeW6+qmyQ50Zb476O4WCatUS0Ru48ZCucswA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4039.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(451199015)(6666004)(6506007)(186003)(2616005)(2906002)(53546011)(83380400001)(86362001)(6512007)(31696002)(316002)(478600001)(54906003)(966005)(6486002)(38100700002)(30864003)(7416002)(8936002)(5660300002)(66946007)(66556008)(66476007)(41300700001)(8676002)(4326008)(84970400001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c09jN1VvU1RyT1E0Z21lSk8xN1oyaVFDbk5sQkVqSllQdmZiMmlJS2JXN3J4?=
 =?utf-8?B?eS81a3E4OTFRZWx1T1NPb2w3L3hKeVFUMHZLMjZPU0VRdk52b2ROWWRjOUJG?=
 =?utf-8?B?cEtENnAxQmo4ZmkyL3lIbzc4UTVKclM3dkpsYllOMWFuY21lSGlxR09LbWtZ?=
 =?utf-8?B?UmlPaWM3S2xvK0IwV1NXRzJ6dlhISGVqQXdTMTlSYlFwRlJoenk2ZHVlWlRl?=
 =?utf-8?B?dGVqTG1peC93Mm1aMXNqYlJoMXZ3SmJWaXRBK01ZdUlEU0FucFVvTWE1SWts?=
 =?utf-8?B?K3lmNUpWdGVlWk1vbHVZZlJ2U2xycTcxdVZBODNnY3F5OXRjQlpXYnZDd0dD?=
 =?utf-8?B?d21vaWsyWlFmcWt6RS9Ba1o5TVRmZHhYS1hCeW5pT251S3ljZmZEU2tzd0d1?=
 =?utf-8?B?a3dkOFpGbzBCYmhDWVBzTjdaSXNTR3NKZlpiTks3dWZmK3JxVUg0V2Nxa2lv?=
 =?utf-8?B?NTU2ejg0c2k3Q1drR0FUZjZCVFBmQzNPN1FJTmVMUmk4YmZhMkdQNjk2YURx?=
 =?utf-8?B?VC9lQzQrTGZXbTJDSjNYVlRrMW1EZVpid1piLzNiai91cmlxZnU4WldUaDBC?=
 =?utf-8?B?YVM0ZEprODZubVRjcWhhY1I1aUtnM0NrK0VlR1haU1VERlh2bVNhN3hkaisx?=
 =?utf-8?B?ZGtWbCtHKy9NdU5CT3N2SEYvRCtBV3U3QmdzYkZaR0RVTW9QZVJYc0Q1cFMx?=
 =?utf-8?B?TVgvTmt1c2p1bDk4aUlzalQwR0VtZjFiVFRERG9GTjIvc1hpdXFqVDcwTThp?=
 =?utf-8?B?RjEyZ1NFRThhL2E2alhoT1VEenZqL1pVYXM5S2VCZk93TXM3bEp2OEJFbHB0?=
 =?utf-8?B?YUlUSkhhUlNUbjhLT1F6WGk4RG9RQkZucU1GMW95QmNOa1BmRjZMd1VYVzhE?=
 =?utf-8?B?bmtYSkJLU29SckpYZmpReFNtK1FGZFkzNnVmS1F0RVNWQ2dxbmk2ejBkbTli?=
 =?utf-8?B?ODNldTlIWWJkRmdnUnJpVFVqc3lPMWxlMFhBeGhDV2N6WVdpYmMvWFVtK0Z0?=
 =?utf-8?B?R1B4L3dkMG5wcFZENmQ0WjVvdWRXeGlMQWJzajhRV2twalovRUVqRTJSS3h0?=
 =?utf-8?B?R1p3bXFYMk9rdzN2OVYwQ3Z5U2h5Vm8vYUxpcjRlVE5GUFY2SlAwT3duZXNO?=
 =?utf-8?B?b0ZEQVcrT2VWWTlUMWxQdzF2VDFaOS96aU5KRzZpQytVZ2UrR01JdXo3UUVh?=
 =?utf-8?B?RTlaMWw2bVRGSmE2a201V1V5Z1U5U3gwUXU1N2l5M0ZkT2F0ZFRrcEdZSFdp?=
 =?utf-8?B?OVBVVFBXNVEvbDJNNlc2Q0Y2eUZhdVBXUC9FUktEMks2OXpJdjBGcytadENw?=
 =?utf-8?B?M2NHb0Z4eWpPZDNqZk9GZGxnenVhTXVPaE5lMjFpS0pPVGZpVW96WURTdjJG?=
 =?utf-8?B?K0VoQzlQRWVNVmQ4V2VuM2J1Z01nMjZwMmJRRmgxdUpYeXFXOUR0a3FpMW1j?=
 =?utf-8?B?c3haZ3Y4S2d3bExFRm9PMzM1ZFhrcjJOYmhOMzdRVjVuRmpPTmZOT3pOKzRG?=
 =?utf-8?B?ZXlQdG5mSkpZcytZME9PVHBBdEQrY3A3Ym9IaEhqMEpxbHZLS01Ed01MYmJH?=
 =?utf-8?B?R2cyNkJMVHVjRXIxeDA1UXVYMDM1R0k5eUMrM3FCNks4OUFPNVhOR2VaMkFX?=
 =?utf-8?B?ZFUzaXpsTUVNZVF1UmdqVHJtNElCRkhsUFVoaGFKMjJxdWd0d0dvTjk3ckFa?=
 =?utf-8?B?ZFZ3RlJPVlFEVUpQYTI4QVZIeHVFb3FtOTZncGwxMlRoeGRGZlhBZU5XbXh3?=
 =?utf-8?B?K2E0MVlsckwrZmNCNkpjU3pHSEdidytrcGNBdGtJcFdhWGNDWlhXSHF1WXht?=
 =?utf-8?B?ZUkxdCt0ZFNrSGtGWW1DZXBWL1JXRElDbG1YTjBNLzFsa0RmcDN2U2pEMVdp?=
 =?utf-8?B?Q2hTMjNXWGdSeWlrNlJ6SVptcHJ0b1dpdm9jMi84YzB1WkRuYi95RnhQTVNB?=
 =?utf-8?B?b1dqcmFsTWZHdW9hZmYwaUpCVXBhblhHTmcveDNRQnlaUmR3LzlJaWlqMGlt?=
 =?utf-8?B?c0Z5QW02b2NKK1RPUlF0OUZkRjkrdm9IbVl4Z0ZpRUNtWU16eVhmMVI3d3V0?=
 =?utf-8?B?eDlGVDJSVnVrWlArc3FFOXVUKzBabnczNUo2OFk1d2R6VXV5Y1FJRGpuTlpu?=
 =?utf-8?B?d3dSdGFhQVhtWGJqRCs3dzE5SVpFMmFIeSs0SDZSUVFUZ0NXNVRnM1ZBS1hL?=
 =?utf-8?Q?XSjL3dcN1N4TuFOciiFMV0M=3D?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5204b70-6239-4b6b-d204-08daabaabf54
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4039.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2022 17:05:07.0393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h8wIKYeEaw6tibQhlNN+UcZkyxDMMFTXSNpU8tB3Van2VieXt3uKXomX6feU9hjczhHE/iSzZovtpxWvYS+MLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB4063
X-Proofpoint-GUID: ITN3ei_3itBxN2WGwP3vFZ5j4Cgj3U2-
X-Proofpoint-ORIG-GUID: ITN3ei_3itBxN2WGwP3vFZ5j4Cgj3U2-
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-11_08,2022-10-11_02,2022-06-22_01
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

On 10/5/22 1:17 PM, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Insert:
> bpf_map_update(&map, &key, &val, flag);
> 
> Delete a specific key-val pair:
> bpf_map_delete_elem(&map, &key);
> 
> Pop the minimum one:
> bpf_map_pop(&map, &val);
> 
> Lookup:
> val = bpf_map_lookup_elem(&map, &key);
> 
> Iterator:
> bpf_for_each_map_elem(&map, callback, key, val);
> 
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/bpf_types.h |   1 +
>  include/uapi/linux/bpf.h  |   1 +
>  kernel/bpf/Makefile       |   2 +-
>  kernel/bpf/rbtree.c       | 445 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 448 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/rbtree.c
> 

I've also been working on a rbtree wrapper [0], with the goal of supporting
scheduler-like usecases as you mentioned in your cover letter. This morphed into
a larger discussion around "next-generation BPF datastructures" with Kumar,
Alexei, and others. Many of the points we reached consensus on are relevant to
the rbtree patches in this series, I'll try to link context where appropriate.

For next-gen BPF datastructures, we'd like to move away from exposing them as
BPF_MAPs with standard bpf helpers to access / manipulate. Instead, they should
be exposed as kptrs and manipulated by unstable kfuncs. kptr representing the
datastructure can live inside map_value of existing BPF_MAP - e.g. inside
ARRAY map_value as a global value. This means that next-gen datastructures can
be added - and their API changed post-addition - without UAPI changes. For
rbtree this is particularly desired as a few other folks also want a BPF rbtree
and we'd like to make sure as many usecases as possible are supported.
Discussion around this started in initial rbtree RFC [1] (specifically patch 5's
thread) and Alexei mentioned it during his LPC 2022 talk (slides [2] video [3],
slides 22-end are particularly relevant).

This next-gen style also allows us to move locks and locking behavior out of
helpers and into the BPF program itself, with verifier checking that correct
lock is held when the datastructure is manipulated. This discussion started
in [1] and continued in Kumar's [4] and my [0], both of which implement such
behavior. David Vernet's LWN article [5] touches on this in "Plans for the
future" section as well.

Kumar's recently-submitted evolution of [4], [6], implements the above as
well as other groundwork necessary for next-gen datastructures and a next-gen
linked list implementation. I've been modifying my rbtree implementation to
meet next-gen datastructure expectations - specifically kptr and kfunc, as it's
still using BPF_MAP/helpers like this series - and should be able to submit it
soon.

I'd like to make sure my impl works for you as well, so there are some questions
about approach below. I didn't focus too much on coding details as requested
in cover letter.

  [0]: lore.kernel.org/bpf/20220830172759.4069786-1-davemarchevsky@fb.com
  [1]: lore.kernel.org/bpf/20220722183438.3319790-1-davemarchevsky@fb.com
  [2]: lpc.events/event/16/contributions/1346/attachments/1021/1966/bpf_LPC_2022.pdf
  [3]: https://www.youtube.com/watch?v=andvNRUAAs0&t=91s
  [4]: lore.kernel.org/bpf/20220904204145.3089-1-memxor@gmail.com
  [5]: lwn.net/Articles/909095/
  [6]: lore.kernel.org/bpf/20221011012240.3149-1-memxor@gmail.com

> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index 2c6a4f2562a7..c53ba6de1613 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -127,6 +127,7 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
>  BPF_MAP_TYPE(BPF_MAP_TYPE_RINGBUF, ringbuf_map_ops)
>  BPF_MAP_TYPE(BPF_MAP_TYPE_BLOOM_FILTER, bloom_filter_map_ops)
>  BPF_MAP_TYPE(BPF_MAP_TYPE_USER_RINGBUF, user_ringbuf_map_ops)
> +BPF_MAP_TYPE(BPF_MAP_TYPE_RBTREE, rbtree_map_ops)
>  
>  BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
>  BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 51b9aa640ad2..9492cd3af701 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -935,6 +935,7 @@ enum bpf_map_type {
>  	BPF_MAP_TYPE_TASK_STORAGE,
>  	BPF_MAP_TYPE_BLOOM_FILTER,
>  	BPF_MAP_TYPE_USER_RINGBUF,
> +	BPF_MAP_TYPE_RBTREE,
>  };
>  
>  /* Note that tracing related programs such as
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 341c94f208f4..e60249258c74 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -7,7 +7,7 @@ endif
>  CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
>  
>  obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o prog_iter.o link_iter.o
> -obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o
> +obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o bloom_filter.o rbtree.o
>  obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
>  obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
>  obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
> diff --git a/kernel/bpf/rbtree.c b/kernel/bpf/rbtree.c
> new file mode 100644
> index 000000000000..f1a9b1c40b8b
> --- /dev/null
> +++ b/kernel/bpf/rbtree.c
> @@ -0,0 +1,445 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * rbtree.c: eBPF rbtree map
> + *
> + * Copyright (C) 2022, ByteDance, Cong Wang <cong.wang@bytedance.com>
> + */
> +#include <linux/bpf.h>
> +#include <linux/slab.h>
> +#include <linux/capability.h>
> +#include <linux/rbtree.h>
> +#include <linux/btf_ids.h>
> +#include <linux/bpf_mem_alloc.h>
> +#include <linux/math.h>
> +#include <linux/seq_file.h>
> +
> +#define RBTREE_CREATE_FLAG_MASK \
> +	(BPF_F_NUMA_NODE | BPF_F_ACCESS_MASK)
> +
> +/* each rbtree element is struct rbtree_elem + key + value */
> +struct rbtree_elem {
> +	struct rb_node rbnode;
> +	char key[] __aligned(8);

My impl takes a different approach to key, instead allowing user to do

  struct node_data {
	  struct rb_node node;
	  __u32 key;
	  __u32 val;
  };

in their BPF program similarly to normal kernel style. This has the downside
of requiring custom comparator callbacks for any operation requiring traversal,
which prevents common lookup/update/delete helpers from being used. But next-gen
kptr / kfunc datastructure style won't use common helpers anyways. Will
something like this work for your usecase?

> +};
> +
> +struct rbtree_map {
> +	struct bpf_map map;
> +	struct bpf_mem_alloc ma;
> +	raw_spinlock_t lock;
> +	struct rb_root root;

In my RFCv1, Alexei suggested having the underlying rb_root be the "_cached"
version as it's likely that _cached behavior will be better for most usecases
by default. Do you need the raw rb_root?


> +	atomic_t nr_entries;

Is nr_entries used anywhere? I could only find incr/decr in this series.

> +};
> +
> +#define rb_to_elem(rb) rb_entry_safe(rb, struct rbtree_elem, rbnode)
> +#define elem_rb_first(root) rb_to_elem(rb_first(root))
> +#define elem_rb_last(root)  rb_to_elem(rb_last(root))
> +#define elem_rb_next(e)   rb_to_elem(rb_next(&(e)->rbnode))
> +#define rbtree_walk_safe(e, tmp, root)					\
> +		for (e = elem_rb_first(root);				\
> +		     tmp = e ? elem_rb_next(e) : NULL, (e != NULL);	\
> +		     e = tmp)
> +
> +static struct rbtree_map *rbtree_map(struct bpf_map *map)
> +{
> +	return container_of(map, struct rbtree_map, map);
> +}
> +
> +/* Called from syscall */
> +static int rbtree_map_alloc_check(union bpf_attr *attr)
> +{
> +	if (!bpf_capable())
> +		return -EPERM;
> +
> +	/* check sanity of attributes */
> +	if (attr->max_entries == 0 ||
> +	    attr->map_flags & ~RBTREE_CREATE_FLAG_MASK ||
> +	    !bpf_map_flags_access_ok(attr->map_flags))
> +		return -EINVAL;
> +
> +	if (attr->value_size > KMALLOC_MAX_SIZE)
> +		/* if value_size is bigger, the user space won't be able to
> +		 * access the elements.
> +		 */
> +		return -E2BIG;
> +
> +	return 0;
> +}
> +
> +static struct bpf_map *rbtree_map_alloc(union bpf_attr *attr)
> +{
> +	int numa_node = bpf_map_attr_numa_node(attr);
> +	struct rbtree_map *rb;
> +	u32 elem_size;
> +	int err;
> +
> +	rb = bpf_map_area_alloc(sizeof(*rb), numa_node);
> +	if (!rb)
> +		return ERR_PTR(-ENOMEM);
> +
> +	memset(rb, 0, sizeof(*rb));
> +	bpf_map_init_from_attr(&rb->map, attr);
> +	raw_spin_lock_init(&rb->lock);
> +	rb->root = RB_ROOT;
> +	atomic_set(&rb->nr_entries, 0);
> +
> +	elem_size = sizeof(struct rbtree_elem) +
> +			  round_up(rb->map.key_size, 8);
> +	elem_size += round_up(rb->map.value_size, 8);

Will your usecase's rbtree values always have the same size?

> +	err = bpf_mem_alloc_init(&rb->ma, elem_size, false);

Although my most recently-sent rbtree patchset doesn't use the allocator Alexei
added, next version will.

> +	if (err) {
> +		bpf_map_area_free(rb);
> +		return ERR_PTR(err);
> +	}
> +	return &rb->map;
> +}
> +
> +static void check_and_free_fields(struct rbtree_map *rb,
> +				  struct rbtree_elem *elem)
> +{
> +	void *map_value = elem->key + round_up(rb->map.key_size, 8);
> +
> +	if (map_value_has_kptrs(&rb->map))
> +		bpf_map_free_kptrs(&rb->map, map_value);
> +}
> +
> +static void rbtree_map_purge(struct bpf_map *map)
> +{
> +	struct rbtree_map *rb = rbtree_map(map);
> +	struct rbtree_elem *e, *tmp;
> +
> +	rbtree_walk_safe(e, tmp, &rb->root) {
> +		rb_erase(&e->rbnode, &rb->root);
> +		check_and_free_fields(rb, e);
> +		bpf_mem_cache_free(&rb->ma, e);
> +	}
> +}
> +
> +/* Called when map->refcnt goes to zero, either from workqueue or from syscall */
> +static void rbtree_map_free(struct bpf_map *map)
> +{
> +	struct rbtree_map *rb = rbtree_map(map);
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&rb->lock, flags);
> +	rbtree_map_purge(map);
> +	raw_spin_unlock_irqrestore(&rb->lock, flags);
> +	bpf_mem_alloc_destroy(&rb->ma);
> +	bpf_map_area_free(rb);
> +}
> +
> +static struct rbtree_elem *bpf_rbtree_find(struct rb_root *root, void *key, int size)
> +{
> +	struct rb_node **p = &root->rb_node;
> +	struct rb_node *parent = NULL;
> +	struct rbtree_elem *e;
> +
> +	while (*p) {
> +		int ret;
> +
> +		parent = *p;
> +		e = rb_to_elem(parent);
> +		ret = memcmp(key, e->key, size);
> +		if (ret < 0)
> +			p = &parent->rb_left;
> +		else if (ret > 0)
> +			p = &parent->rb_right;
> +		else
> +			return e;
> +	}
> +	return NULL;
> +}
> +
> +/* Called from eBPF program or syscall */
> +static void *rbtree_map_lookup_elem(struct bpf_map *map, void *key)
> +{
> +	struct rbtree_map *rb = rbtree_map(map);
> +	struct rbtree_elem *e;
> +
> +	e = bpf_rbtree_find(&rb->root, key, rb->map.key_size);
> +	if (!e)
> +		return NULL;
> +	return e->key + round_up(rb->map.key_size, 8);
> +}
> +
> +static int check_flags(struct rbtree_elem *old, u64 map_flags)
> +{
> +	if (old && (map_flags & ~BPF_F_LOCK) == BPF_NOEXIST)
> +		/* elem already exists */
> +		return -EEXIST;
> +
> +	if (!old && (map_flags & ~BPF_F_LOCK) == BPF_EXIST)
> +		/* elem doesn't exist, cannot update it */
> +		return -ENOENT;
> +
> +	return 0;
> +}
> +
> +static void rbtree_map_insert(struct rbtree_map *rb, struct rbtree_elem *e)
> +{
> +	struct rb_root *root = &rb->root;
> +	struct rb_node **p = &root->rb_node;
> +	struct rb_node *parent = NULL;
> +	struct rbtree_elem *e1;
> +
> +	while (*p) {
> +		parent = *p;
> +		e1 = rb_to_elem(parent);
> +		if (memcmp(e->key, e1->key, rb->map.key_size) < 0)
> +			p = &parent->rb_left;
> +		else
> +			p = &parent->rb_right;
> +	}
> +	rb_link_node(&e->rbnode, parent, p);
> +	rb_insert_color(&e->rbnode, root);
> +}
> +
> +/* Called from syscall or from eBPF program */
> +static int rbtree_map_update_elem(struct bpf_map *map, void *key, void *value,
> +			       u64 map_flags)
> +{
> +	struct rbtree_map *rb = rbtree_map(map);
> +	void *val = rbtree_map_lookup_elem(map, key);
> +	int ret;
> +
> +	ret = check_flags(val, map_flags);
> +	if (ret)
> +		return ret;
> +
> +	if (!val) {
> +		struct rbtree_elem *e_new;
> +		unsigned long flags;
> +
> +		e_new = bpf_mem_cache_alloc(&rb->ma);
> +		if (!e_new)
> +			return -ENOMEM;
> +		val = e_new->key + round_up(rb->map.key_size, 8);
> +		check_and_init_map_value(&rb->map, val);
> +		memcpy(e_new->key, key, rb->map.key_size);
> +		raw_spin_lock_irqsave(&rb->lock, flags);
> +		rbtree_map_insert(rb, e_new);
> +		raw_spin_unlock_irqrestore(&rb->lock, flags);
> +		atomic_inc(&rb->nr_entries);
> +	}
> +
> +	if (map_flags & BPF_F_LOCK)
> +		copy_map_value_locked(map, val, value, false);
> +	else
> +		copy_map_value(map, val, value);
> +	return 0;
> +}
> +
> +/* Called from syscall or from eBPF program */
> +static int rbtree_map_delete_elem(struct bpf_map *map, void *key)
> +{
> +	struct rbtree_map *rb = rbtree_map(map);
> +	struct rbtree_elem *e;
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&rb->lock, flags);
> +	e = bpf_rbtree_find(&rb->root, key, rb->map.key_size);
> +	if (!e) {
> +		raw_spin_unlock_irqrestore(&rb->lock, flags);
> +		return -ENOENT;
> +	}
> +	rb_erase(&e->rbnode, &rb->root);
> +	raw_spin_unlock_irqrestore(&rb->lock, flags);
> +	check_and_free_fields(rb, e);
> +	bpf_mem_cache_free(&rb->ma, e);
> +	atomic_dec(&rb->nr_entries);
> +	return 0;
> +}
> +
> +/* Called from syscall or from eBPF program */
> +static int rbtree_map_pop_elem(struct bpf_map *map, void *value)
> +{
> +	struct rbtree_map *rb = rbtree_map(map);
> +	struct rbtree_elem *e = elem_rb_first(&rb->root);
> +	unsigned long flags;
> +	void *val;
> +
> +	if (!e)
> +		return -ENOENT;
> +	raw_spin_lock_irqsave(&rb->lock, flags);
> +	rb_erase(&e->rbnode, &rb->root);
> +	raw_spin_unlock_irqrestore(&rb->lock, flags);
> +	val = e->key + round_up(rb->map.key_size, 8);
> +	copy_map_value(map, value, val);
> +	check_and_free_fields(rb, e);
> +	bpf_mem_cache_free(&rb->ma, e);
> +	atomic_dec(&rb->nr_entries);
> +	return 0;
> +}
> +
> +/* Called from syscall */
> +static int rbtree_map_get_next_key(struct bpf_map *map, void *key, void *next_key)
> +{
> +	struct rbtree_map *rb = rbtree_map(map);
> +	struct rbtree_elem *e;
> +
> +	if (!key) {
> +		e = elem_rb_first(&rb->root);
> +		if (!e)
> +			return -ENOENT;
> +		goto found;
> +	}
> +	e = bpf_rbtree_find(&rb->root, key, rb->map.key_size);
> +	if (!e)
> +		return -ENOENT;
> +	e = elem_rb_next(e);
> +	if (!e)
> +		return 0;
> +found:
> +	memcpy(next_key, e->key, map->key_size);
> +	return 0;
> +}
> +
> +static int bpf_for_each_rbtree_map(struct bpf_map *map,
> +				   bpf_callback_t callback_fn,
> +				   void *callback_ctx, u64 flags)
> +{
> +	struct rbtree_map *rb = rbtree_map(map);
> +	struct rbtree_elem *e, *tmp;
> +	void *key, *value;
> +	u32 num_elems = 0;
> +	u64 ret = 0;
> +
> +	if (flags != 0)
> +		return -EINVAL;
> +
> +	rbtree_walk_safe(e, tmp, &rb->root) {
> +		num_elems++;
> +		key = e->key;
> +		value = key + round_up(rb->map.key_size, 8);
> +		ret = callback_fn((u64)(long)map, (u64)(long)key, (u64)(long)value,
> +				  (u64)(long)callback_ctx, 0);
> +		/* return value: 0 - continue, 1 - stop and return */
> +		if (ret)
> +			break;
> +	}
> +
> +	return num_elems;
> +}
> +
> +struct rbtree_map_seq_info {
> +	struct bpf_map *map;
> +	struct rbtree_map *rb;
> +};
> +
> +static void *rbtree_map_seq_find_next(struct rbtree_map_seq_info *info,
> +				      struct rbtree_elem *prev_elem)
> +{
> +	const struct rbtree_map *rb = info->rb;
> +	struct rbtree_elem *elem;
> +
> +	/* try to find next elem in the same bucket */
> +	if (prev_elem) {
> +		elem = elem_rb_next(prev_elem);
> +		if (elem)
> +			return elem;
> +		return NULL;
> +	}
> +
> +	return elem_rb_first(&rb->root);
> +}
> +
> +static void *rbtree_map_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct rbtree_map_seq_info *info = seq->private;
> +
> +	if (*pos == 0)
> +		++*pos;
> +
> +	/* pairs with rbtree_map_seq_stop */
> +	rcu_read_lock();
> +	return rbtree_map_seq_find_next(info, NULL);
> +}
> +
> +static void *rbtree_map_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct rbtree_map_seq_info *info = seq->private;
> +
> +	++*pos;
> +	return rbtree_map_seq_find_next(info, v);
> +}
> +
> +static int rbtree_map_seq_show(struct seq_file *seq, void *v)
> +{
> +	struct rbtree_map_seq_info *info = seq->private;
> +	struct bpf_iter__bpf_map_elem ctx = {};
> +	struct rbtree_elem *elem = v;
> +	struct bpf_iter_meta meta;
> +	struct bpf_prog *prog;
> +
> +	meta.seq = seq;
> +	prog = bpf_iter_get_info(&meta, !elem);
> +	if (!prog)
> +		return 0;
> +
> +	ctx.meta = &meta;
> +	ctx.map = info->map;
> +	if (elem) {
> +		ctx.key = elem->key;
> +		ctx.value = elem->key + round_up(info->map->key_size, 8);
> +	}
> +
> +	return bpf_iter_run_prog(prog, &ctx);
> +}
> +
> +static void rbtree_map_seq_stop(struct seq_file *seq, void *v)
> +{
> +	if (!v)
> +		(void)rbtree_map_seq_show(seq, NULL);
> +
> +	/* pairs with rbtree_map_seq_start */
> +	rcu_read_unlock();
> +}
> +
> +static const struct seq_operations rbtree_map_seq_ops = {
> +	.start	= rbtree_map_seq_start,
> +	.next	= rbtree_map_seq_next,
> +	.stop	= rbtree_map_seq_stop,
> +	.show	= rbtree_map_seq_show,
> +};
> +
> +static int rbtree_map_init_seq_private(void *priv_data,
> +				       struct bpf_iter_aux_info *aux)
> +{
> +	struct rbtree_map_seq_info *info = priv_data;
> +
> +	bpf_map_inc_with_uref(aux->map);
> +	info->map = aux->map;
> +	info->rb = rbtree_map(info->map);
> +	return 0;
> +}
> +
> +static void rbtree_map_fini_seq_private(void *priv_data)
> +{
> +	struct rbtree_map_seq_info *info = priv_data;
> +
> +	bpf_map_put_with_uref(info->map);
> +}
> +
> +static const struct bpf_iter_seq_info rbtree_map_iter_seq_info = {
> +	.seq_ops		= &rbtree_map_seq_ops,
> +	.init_seq_private	= rbtree_map_init_seq_private,
> +	.fini_seq_private	= rbtree_map_fini_seq_private,
> +	.seq_priv_size		= sizeof(struct rbtree_map_seq_info),
> +};
> +
> +BTF_ID_LIST_SINGLE(rbtree_map_btf_ids, struct, rbtree_map)
> +const struct bpf_map_ops rbtree_map_ops = {
> +	.map_meta_equal = bpf_map_meta_equal,
> +	.map_alloc_check = rbtree_map_alloc_check,
> +	.map_alloc = rbtree_map_alloc,
> +	.map_free = rbtree_map_free,
> +	.map_lookup_elem = rbtree_map_lookup_elem,
> +	.map_update_elem = rbtree_map_update_elem,
> +	.map_delete_elem = rbtree_map_delete_elem,
> +	.map_pop_elem = rbtree_map_pop_elem,
> +	.map_get_next_key = rbtree_map_get_next_key,
> +	.map_set_for_each_callback_args = map_set_for_each_callback_args,
> +	.map_for_each_callback = bpf_for_each_rbtree_map,
> +	.map_btf_id = &rbtree_map_btf_ids[0],
> +	.iter_seq_info = &rbtree_map_iter_seq_info,
> +};
> +
