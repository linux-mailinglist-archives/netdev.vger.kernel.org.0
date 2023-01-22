Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A4B677371
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 00:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjAVXaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 18:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbjAVXaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 18:30:17 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B0BDBC5
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 15:30:16 -0800 (PST)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30MGjHMB022405;
        Sun, 22 Jan 2023 15:30:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=ph9k+EimdFbYWX2y2YkP7s8+2NdRB6lCiS4eOWbwFmE=;
 b=Z/4EunoZeri2UETRlsOOcL4DCdaZY+KAhUIqQamujC3uXjoA9K5oXEuapvxYE/DkNtNe
 j4Gxuzf9B+Jf9K9SVbdfTPv85LwPfy/fevh4wknWR2ZrW9hQvGaosfItbNNlzyBkAmm3
 FpEPh1cQxWxqPV1ajyDd8iA1mklIY+sZ8CxWYWp2usN8oXsBi8rrSfHTGa4ohsoa3B7i
 2BEyGmD12MlI0wgeKutWR/aPlIxM9uyDT2Bs7eoTxTEzNP9LxDxHREI32Rk+F8puGjvB
 jfdSr5GdkOVY+g42Hzgf0p3XBhLKwnEuyrirNbQYnIwEQr36skBUEB2YEAycA0jakPt8 QQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n8emu4ec8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 22 Jan 2023 15:30:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdQfdalE6d7aHlmYMaUBv7Krczg9oSRQekx9OH1o2PzPRHyXcK04EdKDCOqmsDD3dPGnQqWuJdQiJ6iEw7n/jh/gHrDJrGYFlUC535Y6gsDF2jVYi4gBjy63Jr5M4E4s0HlSo8/VbPGq1cH2AU2IXcTh9hmZp1skD5XasM0cOkUBRkzr5N73QdWSOg7tKrf0GttvwhPIPpVQx07aZWIxSHsXwpW9R4FG4gQhU8sEWBsaTCEQWQ4IO0Ble09AQf5aUK6nUyRj8vgk1MZ/hNAfAO34MlzWho5ayn5mZzEncVtsb22puzKsEIVVsKmHl0qRjZgyj+yv/H8p2qDeaxD1rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ph9k+EimdFbYWX2y2YkP7s8+2NdRB6lCiS4eOWbwFmE=;
 b=HRJZAyN6scxHQ5hHU8KiyzSS4bLY+W917knUc8xKYiTiHpo2SH5MNlOB1J5XosXzXsitaNuuNtx1McUqXYautIek2MUVuEhH2mzI860BLa02j6lZN3Qip+LRATdiE5Wgmvnti2NNBdqfb4hhnzlS6/PMRK1MhMHKcYIZbCJRWDR1mUTrqCu6MhiWnX2n2Iz6Aw4QoSSypJnZQLdM7zlsjpupsW3yfOYYEloLNNIXcEqqxL8mnAoaoWlXU6J/CsDObA6p3OP9QUDhfiD9/xDJuAAmbHOXw3qCRoiBvaOIMFDa551gFFHXtbNM2IU3Jeq1owmlzTLkLvv/3TRN/ncllg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW4PR15MB4665.namprd15.prod.outlook.com (2603:10b6:303:10a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.31; Sun, 22 Jan
 2023 23:29:58 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a595:5e4d:d501:dc18]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::a595:5e4d:d501:dc18%4]) with mapi id 15.20.6002.033; Sun, 22 Jan 2023
 23:29:58 +0000
Message-ID: <a55558fe-0e43-422e-bd2c-9a434ce1b1e2@meta.com>
Date:   Sun, 22 Jan 2023 15:29:56 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: Clang-14.0.6 compiled kernel/linux-5.4/samples/bpf/ failed to
 load on x86-64 target
Content-Language: en-US
To:     nelakurthi koteswararao <koteswararao18@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org
References: <CAGJbQde7RGRzMheyCbUfmPSMWkeuxBDJpFGhj1K+AT-mi8kYPg@mail.gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <CAGJbQde7RGRzMheyCbUfmPSMWkeuxBDJpFGhj1K+AT-mi8kYPg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0179.namprd05.prod.outlook.com
 (2603:10b6:a03:339::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|MW4PR15MB4665:EE_
X-MS-Office365-Filtering-Correlation-Id: b7fd2031-29ff-4417-eb8d-08dafcd09393
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qDG+ZNRBe22aTFajHvNsC++xx8Z6/JhjuH6vKIgzahKkO5jNqlE6Cpg/crDvM1yzp6gavRcpfDwK6A0fWvgmMIEC3Gb4mPKGk9s7G/rC6S2WHA4Mp/A4qVqco+Ag3G37ycM5cDN2mlh5CBskwnDEUI/CtucwWc0gtRNjcNfrZRmbxKkl50QeBoH6PGNj1V+ij3FYNZSKC3fwwM1F3ab2gJ5l5bpYWiAymzt+3Z/XDEG5wJP8nyhbOk7FL60TcA/S4AqIFkIFQDoFjFj0AgnTJOQU+nle6SDZuoA/J9cc2rQh+zwxOzSs7NMCVYGrlUJgYF1mxm9S4jpkmFpBxkRyHOOCVGqmk80iIHA+JS30TpD7CQbqx8t/kmiR4nAT8G6HUB+hyRjkmoCudO9UC3+smV0dM7pHgYWx05EoDQrQyDBfVlWvFyYbtYsTRm6mctY7Uyy24Z6v+vfaDUfvqyS+rFIJ8AHFFqJnFoFckbW3pD7d6Ek1Y1nz+Lf7iPj9A+8KZXqWNIG1fzHHjMNH4jQ+LIVZ/FOFn9RxTHK5jilXIh43glEEmDSnWtX7noSlOoTfiy8NNj2wMekFkRQXbDnSLsnc49XaYgNZhA07mit5ku9WTcoM5PnV74HjldBPbB4LM1lzZxBonbOG+vyupWgmE5gKMnWRXNAJfOBbRfONPo1OlPYglboMoO4E7fxFTQ1PGvlt9Xr161qhmAkaZl7oOjvbJLtrgxtlE4xOH+p9+BM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(346002)(376002)(39850400004)(451199015)(31686004)(36756003)(86362001)(8676002)(66946007)(66556008)(66476007)(2906002)(5660300002)(31696002)(8936002)(38100700002)(478600001)(110136005)(316002)(6486002)(41300700001)(186003)(6512007)(6506007)(83380400001)(53546011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0RqaGEwR0k3SDdXaE15TjlYUCtaWU40R0FJbm9Pa3RhcDBqamhKNit6eXZI?=
 =?utf-8?B?UE5LOXdRRzBORW5iZFQ4ZjZYU3podVZJTDc2QllVMm42eEpUMWxtbWxsVnBu?=
 =?utf-8?B?WVpGMDI4MWhhNlpSNmVCMTFGcHZsYTF2VzFTOUtsMDVNY05YL2dIb0dScUJT?=
 =?utf-8?B?ZnhzMVUrQk0wTitDNGhieFlTemZaVXNOSWk5QitBTitONGM3bElWTkZ1M1FX?=
 =?utf-8?B?NDFkdHVqYmNZZFFPT1RBWHdlcWVwQmQrdGxCT2xNQkZJN3ZHY0tITmkxb21j?=
 =?utf-8?B?bXNNUjcxeHVMUlkzOVN5MXo3OEttV0pxd2R5Tll2UUlPVHh4VG0xSnBGMngx?=
 =?utf-8?B?dXlKR1E4VitsaHZsMkMvVDhRSzlidnprUzdGeEJHMjFXL1V1YUltbEYvNTMw?=
 =?utf-8?B?akRCS2lKYVZVMGdoWnEzSGcya1lFbXpZd0tLc0h0VzRiR1U2blJ0VjUyemVJ?=
 =?utf-8?B?SjJyVWJoUmF0Y2o3dGZUemZNR1IwSXI3MEw1UW9HUmNUemM1bnMzeWMya3Fl?=
 =?utf-8?B?a1g3a3hGRjA5RVdHVFg0aHRyVmxUZXZOSEdUdEg4emFmV0pnYklIS3VIY25U?=
 =?utf-8?B?blBtQ3pMZGNVWDJnRDU0aE5ES3VXSVNqb2dJTEtJcytVakJKY0NIQXVSR0xi?=
 =?utf-8?B?V2xGdXlDdjhvRlJjcGRRQTh1WnFQdW1mUk91L09NeWJlclVoUk1GT1hmTm1S?=
 =?utf-8?B?Nk9aK1hpOCtNelVTSHdQbjlFcllGdEpXN245dVlkdmRHZExhWmx4WkJvejUw?=
 =?utf-8?B?MjliQ05uRTYvK09CU0gzZ0YwcnMvM2F3UGc4NkhUaHV3a2NweVNnNTJsN2dn?=
 =?utf-8?B?UEozZWtxS0cxbm9tN3JTQWNpbm5zakZ1TDdpZ21nME4vTTFhY0preFpOb0tt?=
 =?utf-8?B?M1psVUxjM2JOWFJaY0V3T2daVWxQaTQwTytWOVc1ZmtDYmVQdXlNbjl0VUtL?=
 =?utf-8?B?MjdnYm5mZ3kwYzZKdFRCdlNFVlhFMGkzczRQVElYb0Vib2loYjAzTVp0K1BL?=
 =?utf-8?B?NTNra2ZhQW8zZnVoQ0U2YW1FYWlBRmFUKzliS2ZkVVZjKytudy9wNFdObkM1?=
 =?utf-8?B?OHIzdit1alJKZ09RVUUya1JkYlVQdnhtUmFRQXZZUmNEMVQ2UXZiNjYvejJ4?=
 =?utf-8?B?aTkwVW9xTitIMThQOFBmaGRVVWVla0hqYlBuNWU2UFN3UStpRVFyanJPUlZw?=
 =?utf-8?B?ZDNOWnZtbnh6Rkw4a3I5bzZrWm0zcldPWXpjSGZPbWFUQU8xNnI1OU40eVR1?=
 =?utf-8?B?MDZYVzNxMGFXZWNoVGNvRFZYbXhmc2ErWmovZGtaVHMvVTE2cDhYTDQ0QVZU?=
 =?utf-8?B?Qll1cFJSejl4RlQ1eEUrTWVRV09wc3lQTnY4WTNCSWsxTjlUQTQvUmY2YVZN?=
 =?utf-8?B?Z2xjRUZINE1NY0t0eE8waFk2Y25qOXZJTUIrMHpLb2lmWUJzQ2RBSDF3Zms3?=
 =?utf-8?B?Mzhwc0ltaWI4d2hadjhjZW9VNE9nd3RoaE0ycUhmSHhlUk1sYVF6VUNOWUd2?=
 =?utf-8?B?ZXpwbWhFcHVMQzh6emdCcys2cjRzMlFrVGR5VDAyTkpiakNrRWxuZGJ4dlI0?=
 =?utf-8?B?NGE2b1h6WkYzTklCKzZ1YjRMREE0cHYxdXdwSmpIN2lzbWFRV2J6QXdUcUlN?=
 =?utf-8?B?bnlkejM2QzJLc0xIeFgrc0R3TXRCemRoejJjNjhQTFpCVkpXS1VxOHRlQ1BZ?=
 =?utf-8?B?cjNHWVBsSU5xVEdUYVI2alRUY1BPKzFqeG12Wi9VRHFMLzNuaWhjNkZNU2oy?=
 =?utf-8?B?dlhLZ1EvUm1SYUVuaHhmZGdSdHYwekN6cUs2cFBDOW15aWRQT21QN3dqaUtu?=
 =?utf-8?B?NmtMWGxZZzVrbXpsMXpDYkkxMTFPbVNUNVEzM291YlU5ejRabTdzNE9MOWdt?=
 =?utf-8?B?U2RRcWpVc1kzaHdDUWtlUWVCRU4raGVKYzQzeC93UEpvNU9wR1lieTMvOG1r?=
 =?utf-8?B?d2hOcXc4ZFd2bmphVzNndUZucmdScG5VdWxtMWhNWjJJRUFFN1MxckNYNGNY?=
 =?utf-8?B?YXI1WkJSaHQzVGFOWDBhNGFWNDRNcjBhejd3Uk1mODVXazZUbFNKS1ZIL3NR?=
 =?utf-8?B?aDJuOU9iU25SVVptbkJZUUt3Y2Eybkg4bS9Na0wyYm9vRVN4V2w3NDJjbGNL?=
 =?utf-8?B?YzVUWlZXOHJUNkZZSytzeHE2d3RhTXluOGNBS2luZFQ3MkZ3cEptQkVXd1lh?=
 =?utf-8?B?RFE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7fd2031-29ff-4417-eb8d-08dafcd09393
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 23:29:58.7875
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TWCbLQ2FQzNem3B0+DSJ0d6LtxsL6tj6AmRiOYeQYPD3d0l9zQVzxEPDLetWBFKg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4665
X-Proofpoint-ORIG-GUID: d05rfo8LjjvDtdQubezJtxzBsva87ngS
X-Proofpoint-GUID: d05rfo8LjjvDtdQubezJtxzBsva87ngS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-22_18,2023-01-20_01,2022-06-22_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/23 10:10 AM, nelakurthi koteswararao wrote:
> Dear LLVM BPF contributors
> 
> I compiled samples/bpf/ programs for target 'bpf' using clang-14.0.6 
> version compiler present in linux-5.4.202/samples/bpf directory but when 
> i try to load the sample programs like (sock_ex1) on target x86-64, they 
> are straightway failing to load in to the kernel.
> {{
> /var/log/gui_upload# ./sockex2
> libbpf: Error loading BTF: Invalid argument(22)
> libbpf: magic: 0xeb9f
> version: 1
> flags: 0x0
> hdr_len: 24
> type_off: 0
> type_len: 1000
> str_off: 1000
> str_len: 2290
> btf_total_size: 3314
> [1] PTR (anon) type_id=3
> [2] INT int size=4 bits_offset=0 nr_bits=32 encoding=SIGNED
> [3] ARRAY (anon) type_id=2 index_type_id=4 nr_elems=1
> [4] INT __ARRAY_SIZE_TYPE__ size=4 bits_offset=0 nr_bits=32 encoding=(none)
> [5] PTR (anon) type_id=6
> [6] TYPEDEF __be32 type_id=7
> [7] TYPEDEF __u32 type_id=8
> [8] INT unsigned int size=4 bits_offset=0 nr_bits=32 encoding=(none)
> [9] PTR (anon) type_id=10
> [10] STRUCT pair size=16 vlen=2
>          packets type_id=11 bits_offset=0
>          bytes type_id=11 bits_offset=64
> [11] INT long size=8 bits_offset=0 nr_bits=64 encoding=SIGNED
> [12] PTR (anon) type_id=13
> [13] ARRAY (anon) type_id=2 index_type_id=4 nr_elems=1024
> [14] STRUCT (anon) size=32 vlen=4
>          type type_id=1 bits_offset=0
>          key type_id=5 bits_offset=64
>          value type_id=9 bits_offset=128
>          max_entries type_id=12 bits_offset=192
> [15] VAR hash_map type_id=14 linkage=1
> [16] PTR (anon) type_id=17
> [17] STRUCT __sk_buff size=176 vlen=31
>          len type_id=7 bits_offset=0
>          pkt_type type_id=7 bits_offset=32
>          mark type_id=7 bits_offset=64
>          queue_mapping type_id=7 bits_offset=96
>          protocol type_id=7 bits_offset=128
>          vlan_present type_id=7 bits_offset=160
>          vlan_tci type_id=7 bits_offset=192
>          vlan_proto type_id=7 bits_offset=224
>          priority type_id=7 bits_offset=256
>          ingress_ifindex type_id=7 bits_offset=288
>          ifindex type_id=7 bits_offset=320
>          tc_index type_id=7 bits_offset=352
>          cb type_id=18 bits_offset=384
>          hash type_id=7 bits_offset=544
>          tc_classid type_id=7 bits_offset=576
>          data type_id=7 bits_offset=608
>          data_end type_id=7 bits_offset=640
>          napi_id type_id=7 bits_offset=672
>          family type_id=7 bits_offset=704
>          remote_ip4 type_id=7 bits_offset=736
>          local_ip4 type_id=7 bits_offset=768
>          remote_ip6 type_id=19 bits_offset=800
>          local_ip6 type_id=19 bits_offset=928
>          remote_port type_id=7 bits_offset=1056
>          local_port type_id=7 bits_offset=1088
>          data_meta type_id=7 bits_offset=1120
>          (anon) type_id=20 bits_offset=1152
>          tstamp type_id=22 bits_offset=1216
>          wire_len type_id=7 bits_offset=1280
>          gso_segs type_id=7 bits_offset=1312
>          (anon) type_id=24 bits_offset=1344
> [18] ARRAY (anon) type_id=7 index_type_id=4 nr_elems=5
> [19] ARRAY (anon) type_id=7 index_type_id=4 nr_elems=4
> [20] UNION (anon) size=8 vlen=1
>          flow_keys type_id=21 bits_offset=0
> [21] PTR (anon) type_id=33
> [22] TYPEDEF __u64 type_id=23
> [23] INT unsigned long long size=8 bits_offset=0 nr_bits=64 encoding=(none)
> [24] UNION (anon) size=8 vlen=1
>          sk type_id=25 bits_offset=0
> [25] PTR (anon) type_id=34
> [26] FU
> 
> NC_PROTO (anon) return=2 args=(16 skb)
> [27] FUNC bpf_prog2 type_id=26 vlen != 0
> 
> libbpf: Error loading .BTF into kernel: -22.
> }}
> .BTF information is generated during compile time but loading to the 
> kernel is failing.
> Is it due to clang-14.0.6 compatibility with libbpf version present in 
> 5.4.202 kernel is leading to this issue?

You need to have a later version of libbpf. libbpf will probe kernel
and do proper sanitation if the kernel does not support above [27] encoding.

> Request to please provide input if possible
> 
> Regards
> Koti
