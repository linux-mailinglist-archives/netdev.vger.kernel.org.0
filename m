Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 634C75AA044
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 21:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234530AbiIATkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 15:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234695AbiIATkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 15:40:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2650D6C;
        Thu,  1 Sep 2022 12:40:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 281HJJXl009010;
        Thu, 1 Sep 2022 19:39:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=v578PBKL3sG4BdKJMKGszd2mmctMtYXjcWde4cfLbt0=;
 b=MDOpJH0B7EwfCeBM8G1ncOrsXg5EPI4HcmWbODSY+M5An66LG2RKpNupM2ymjWHW/yA+
 9FIdM2fyYB4Pgt9pMJvYDXZggc3DTSqpwvczPTasqsEQZ/TzTzTlAh53EGkiOIi2C0IJ
 Nxl2LTek2of/gkBLNhz1X5L7pEOpOX8mdQxLk2L0jpIT4hO9jTBfckiWsz/facPffgnC
 pvn4jSchGdz2wM6ePPt0bWPlEhV3WAYVdeauyhYkCtt63y+BDssBnmg4clGjx2ZaUzJd
 D104ZbK1PJVLayx8hVjSxjyGLnkJ9XesvyExHL6B8Mcme3edRlWf2wlEmBEavt0lPdtB kg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7a22dc1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 19:39:49 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 281HtVcR002102;
        Thu, 1 Sep 2022 19:39:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jarqk5sns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Sep 2022 19:39:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4ejcNs+efqKX02/kNcIKspIJRaNxQYvmmmOuisR3CDzXCFs5ZoVxjcR16L3hiS/5TlQHGROu5yRf6dfpdWnSH0I67qhqMpTl8H53pWdu7TSbQJCwwftrDJ/0lzT9j78xkRqDk8lyeYS9rViq+bFxFievtnoPd5HaMJ3kdI74wbBMc3t0lda/VX+BXX4yX5q79EvDo9VkzxrZ52aj1xrW3vLZM6AIIXDXdwxgY25vzcxSNh1bBHDAoZF8GnLE1p6iGhyyugmQfjFSSvdAOzdmBu+1mQcJnampPZyavwpwWBdkMZJw6v16OMO8AG0kBbvJcvg5qXqaCrHpS7LMHMhSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v578PBKL3sG4BdKJMKGszd2mmctMtYXjcWde4cfLbt0=;
 b=MXFY4cgxUkjet2kaQc8zUn3p8NeupVMQIUWMIEnMECn/vShmcZO9LvfOBiXIIq2NvVmX/zSIFwvKllMevrv6gTloXJdjBj8AXrTBx7pV0aTCCvb680WesjXpfHvPg5tPTmyURWfQimG8Fl3Vo4cq2nKGwQdEoJSIYX5uml2zn+XOAT+H9tPthDtYwasoq9/imHoOjoiJW+5Nv44SAMbW+RjTLwjKIYwATST3V86zkM/ITe0hN1Z0DzT/qVQV8XSAv3jDntDDXu5157M0tXlJcAyIgMuF/REqrr4ZKYSn+Sw5BQyHLFIqNxvywUx6xPpZ7hKqhPmfcMqm/tGReTfIDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v578PBKL3sG4BdKJMKGszd2mmctMtYXjcWde4cfLbt0=;
 b=AH6CHYsITOlibofslwSen1eYeClyPEkkhtnv9nTPzB3d3Yi1njb2fH4Z6aJTC54mE9ta3k2M9lXS+GgegzmVvmoAGJjmXSQwVEDjwTPb7SvTcNYqlPY2Q/GY6OAm2gpD/z80HpMPyc2D8nL9J4KYE4udjHZUtrtveiMijeQ9Suc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH8PR10MB6669.namprd10.prod.outlook.com (2603:10b6:510:221::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 19:39:46 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189%6]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 19:39:46 +0000
Message-ID: <b3916258-bd64-5cc8-7cbe-f7338a96bf58@oracle.com>
Date:   Thu, 1 Sep 2022 20:39:40 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.1
Subject: Re: [PATCH V5 vfio 04/10] vfio: Add an IOVA bitmap support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     jgg@nvidia.com, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com
References: <20220901093853.60194-1-yishaih@nvidia.com>
 <20220901093853.60194-5-yishaih@nvidia.com>
 <20220901124742.35648bd5.alex.williamson@redhat.com>
From:   joao.m.martins@oracle.com
In-Reply-To: <20220901124742.35648bd5.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0019.eurprd04.prod.outlook.com
 (2603:10a6:208:122::32) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b1883c6b-f869-40bf-6ce6-08da8c51b9d3
X-MS-TrafficTypeDiagnostic: PH8PR10MB6669:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oS0qg1+YuJTv2pbvxA0e/BEj2qr6YGduvLa6Z33KAHOmeYgwT/sZVWLoRgzqP1WZwObp0eZWjoO3sgBoZNaXn1JBk14mZ9H4pI+Lfds9p2kubqDOZ+dIPU7CMON4O66dhRk0mpw/aNkAXb1V8HjYbkvlVQZevd6wMkTVWwT5PWa7KOoBgM95mXLbB1IkVVn5lDPpbWGfZewacc8UMpC+dbHuUt7Y09TK6D0L6lRT5mr62dTZF5b7pSYkx4Obh5vFYWOcYZXGG9xX87N/rZSb4DOgrlwTpqEwCv2bVwyOD0i1l8bxX6bPxGZBbKkTFe8XL3Xp3AAeCef3dKQ3ovaEmFLx4xcQRs4IGOKCmrZz98nc+sWfOATILpe5N9Goer/fn5VmxI6el8xyFOfxa73aBQokPdalh5vxgLcnlF37eZT+/4K4Rxw5xT1nJiJs+H3oUMNJi/ZMozLblmQ678XTncNJtNtDdjjfCv8lcZTTGSKpUi7SSdY19Xl2AUW2TIuf4eFcPmp6c8EZnX2sm239ejLOwiS5+l7NUAJ5edmNvfvEA5CXhPQYjs7hTVjXx1/uw6AzDnwG7cZH9IAKXzXhTPWB7Ph7yQCrTh7vhMQgGFZ1uW9eFk93GhWc1fJ2taa9EolSE+DrjXfbnfKNrQw8PzZqoVv0lXRXK67L3pMg/a7tegHGxS8SGp9t+hqlIKAMvb+avvAnXriRxI/1OI57XhPswwPCbu3PRO4+JgHq8yZcPLjL/BEwBVV/xo+QD1AvtNY5dfxJsGM7mzf5IFtaGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(346002)(396003)(366004)(136003)(66946007)(6506007)(66476007)(6666004)(53546011)(4326008)(8676002)(66556008)(9686003)(8936002)(316002)(6512007)(26005)(478600001)(6486002)(86362001)(110136005)(38100700002)(31696002)(41300700001)(7416002)(2616005)(186003)(2906002)(36756003)(83380400001)(30864003)(31686004)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OGFRWW16MWg3ek1pcm5CemFkZUZjQnBieWIxMVczWjJ1d1BLVW5zTEI1YmQr?=
 =?utf-8?B?YUZVQ3lPc2l0N0Z3Mjg2anluQVdhWHhmRjJBbXcyZ3hXNE9hQWpPTXIxOG9G?=
 =?utf-8?B?RmVacGhsNmgwZlpuRnh5akkybjhraFM1WFVPWithWlFCRHJJYWhUbFlRWkZx?=
 =?utf-8?B?bFozZnhFcFVtc3o0c2I3Tk1jWEplN1VSZlJQWSt4WDNYV3dDd3BDYTF3UUZx?=
 =?utf-8?B?OUdyZUZ5T014UGQ0MHR3T1pBZ09XMzRKQlFPb2cwb1NBWXI1RVJ6cTZrbmdQ?=
 =?utf-8?B?WEFKZnlCTnU4eXAwNW9tLzhjbmFsNms3MWx1dmVNV21LRDZEdmFkTzdIYjVR?=
 =?utf-8?B?NTlkVVpXa1hDZFQ0SkpiS2lDYkRtZzR4UzVnT1ora25PZ1hPT3NqYlpNQ2gz?=
 =?utf-8?B?aTJhMUh3anJYOXlKRlRKd3hKQkhjYkhGUWg3b1U5WW1BYjMvZzNsSXlVWkpD?=
 =?utf-8?B?alFYK1dHQzhKZUtidFhSRTZiWVFUT3d4NTM5RmRHaDdPZFdmZm9QcmJjc0dm?=
 =?utf-8?B?Mk1WdGNPNDNrb1gwR0tOWENmdG4yZjlSRCtuczVqN21IY3h3dHRwU05TYWs3?=
 =?utf-8?B?bkJoaVJlTG9USm0wdVRIVXlNRkNBbklqd25KakVRdHF1blRsMGpPMmJwRUxQ?=
 =?utf-8?B?a0kyMHpsamtHVnZhdFo5QlFsM0x4YTYvWS9zUjAyM3RsMWdCZmQ2VDRiazQ3?=
 =?utf-8?B?ZmFLK0dNaW5vQWFRWHRZWC9zcmNzSmtvazJyZUtTNmtqTitEZThPWllsS1pI?=
 =?utf-8?B?Q2txUDVpMWNWZEd0L3NyMTJHWVRublBMcDU0ZmpheW56cXJKemlWQnVZWnhk?=
 =?utf-8?B?d0UzWWpqTlJuQTAyWVp5MEtFMEc1cjVDRHZoU2VhWVRsVzRjYmFheS83Nkp3?=
 =?utf-8?B?YmNRMjVBTjBiNmd2QkFxbEJ1MVNIMzQ0c011OHlFZWFZY1UxUjdSNHY4d24x?=
 =?utf-8?B?T3RkaS9SakNWeGdIb3VaRWdOQk52Vk5nK3QwNWlUYTRQZThUa3Bkb3QwVGpn?=
 =?utf-8?B?eWFuWVlSWDVQVG1YVDJPL0JBSm1GdG1ISlZ2QkJuTVZXOUNYZWh3WE1CbTV0?=
 =?utf-8?B?N3R6U2czWmcwZ3lqK1RteU1hRXVwVDNiWHVmQWJOY3cyYUM4eVBLNk16YWJD?=
 =?utf-8?B?OS9mSHhhcGpsL2ROdFR4aUI5TDAxVWQvS0Rvb3d3bVRsME9pc2pVUTVoOEln?=
 =?utf-8?B?NE1JRm14MUdoMTlkWHFnUWp4dzc3S0J0WXFNL3V2Sk1Pc0FBdG1SdVdwRzRx?=
 =?utf-8?B?M1BkYkZhbWJNTlAyLzV6TEwxZGVlMnRQT3VzaGJrUHpxdjladVlPa2RpSS96?=
 =?utf-8?B?cDJCNnZVVmVDaHZHcTJCYWdIQTkxN294K1pSS2t2VklETS83ZElQNVMxd01y?=
 =?utf-8?B?Nk5NWTB0ZE9ITEloQm5WakJlSENzN21lZk1NWEtpVzE1MVdoME85ZVM4ZTFP?=
 =?utf-8?B?OWswMnBYL3pORm1VYXg2TkRLaGdPdUlIeG9wSVhHSktuWk5JTi9Nd00ySG9o?=
 =?utf-8?B?SzB2bmpQZ2dDMERFZUhvZzJEdHcvdVdZWUtvQTA3aE5zODBEaTB4SlVJQU4v?=
 =?utf-8?B?a3hBcXF3SHl3YkNma2YxSGZBZVRrb21SMjEvbFhvQkR2UW5sWWdYVDM5ZE5J?=
 =?utf-8?B?UUVhR0diVWNnSHllOFQzNU8ySUNwWVV4bkMvMDB1K1cxRFo5by8yRUNyYXZ3?=
 =?utf-8?B?MkwzZ3ZzVlhybW5heW8vYzJtTCtWaDh0anA5OHpIRVhhZ29FbEg4ay9hQlJw?=
 =?utf-8?B?QXpJeHR2MmNRQ0tTcVFBSVJMMmhWR1lCZUd5WWJ6UlBCQm9kRUVQVWJKMWFu?=
 =?utf-8?B?M3BzNHpJdkNhcHQ0WU54dm5HS2tZQ25IYk1yNFd3WWx6dWRIa0U3cFNsQVcx?=
 =?utf-8?B?MU8raHQrV0RpNlo2NTVHZ0gyeXZ2NVovdWczOFl3elQxMWlkc29HQVphNHh3?=
 =?utf-8?B?VllmM0FaYTJkaWV5SCtoNmROOGllTUM5SUIvWDRFczRQM0V6ZUo1ZmFOOEtF?=
 =?utf-8?B?Vkdjb2FkS1VaejVqZGRTeHhsQXpZSHFib3pvTVRRalE4b1hvQ0g0RlM0eUhE?=
 =?utf-8?B?N2k1KzZxdGgwdTlleXErSURoUkRocUdBcnhqa01haGJXSVJZNUI0L25mbkI2?=
 =?utf-8?B?bHU3VkFuY0F4ZU1sdXFjdGRMRUhtMFIxT2hCcHdIb3lUWk04cm54V3dIbUpJ?=
 =?utf-8?B?elE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1883c6b-f869-40bf-6ce6-08da8c51b9d3
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 19:39:46.6570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +m/x7wtMuoQJqaKC2N6wkkhzzpnxBa1Ei0AWIwc7V79cXUAYQBr0kODVa1qKVID8gJLgAjAp7GmzvhzJEJmbag3POjsAvOeWc4JSZpUnv8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-01_12,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209010085
X-Proofpoint-GUID: PFZi8lG0SuX3tDswxsh42l60Pb_v_arG
X-Proofpoint-ORIG-GUID: PFZi8lG0SuX3tDswxsh42l60Pb_v_arG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/09/2022 19:47, Alex Williamson wrote:
> On Thu, 1 Sep 2022 12:38:47 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> From: Joao Martins <joao.m.martins@oracle.com>
>>
>> The new facility adds a bunch of wrappers that abstract how an IOVA range
>> is represented in a bitmap that is granulated by a given page_size. So it
>> translates all the lifting of dealing with user pointers into its
>> corresponding kernel addresses backing said user memory into doing finally
>> the (non-atomic) bitmap ops to change various bits.
>>
>> The formula for the bitmap is:
>>
>>    data[(iova / page_size) / 64] & (1ULL << (iova % 64))
>>
>> Where 64 is the number of bits in a unsigned long (depending on arch)
>>
>> It introduces an IOVA iterator that uses a windowing scheme to minimize the
>> pinning overhead, as opposed to pinning it on demand 4K at a time. Assuming
>> a 4K kernel page and 4K requested page size, we can use a single kernel
>> page to hold 512 page pointers, mapping 2M of bitmap, representing 64G of
>> IOVA space.
>>
>> An example usage of these helpers for a given @base_iova, @page_size,
>> @length and __user @data:
>>
>>    bitmap = iova_bitmap_alloc(base_iova, page_size, length, data);
>>    if (IS_ERR(bitmap))
>>        return -ENOMEM;
>>
>>    ret = iova_bitmap_for_each(bitmap, arg, dirty_reporter_fn);
>>
>>    iova_bitmap_free(bitmap);
>>
>> An implementation of the lower end -- referred to above as
>> dirty_reporter_fn to exemplify -- that is tracking dirty bits would mark
>> an IOVA as dirty as following:
>>
>> 	iova_bitmap_set(bitmap, iova, page_size);
>>
>> Or a contiguous range (example two pages):
>>
>> 	iova_bitmap_set(bitmap, iova, 2 * page_size);
>>
>> The facility is intended to be used for user bitmaps representing dirtied
>> IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>  drivers/vfio/Makefile       |   6 +-
>>  drivers/vfio/iova_bitmap.c  | 426 ++++++++++++++++++++++++++++++++++++
>>  include/linux/iova_bitmap.h |  24 ++
>>  3 files changed, 454 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/vfio/iova_bitmap.c
>>  create mode 100644 include/linux/iova_bitmap.h
>>
>> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>> index 1a32357592e3..d67c604d0407 100644
>> --- a/drivers/vfio/Makefile
>> +++ b/drivers/vfio/Makefile
>> @@ -1,9 +1,11 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  vfio_virqfd-y := virqfd.o
>>  
>> -vfio-y += vfio_main.o
>> -
>>  obj-$(CONFIG_VFIO) += vfio.o
>> +
>> +vfio-y += vfio_main.o \
>> +	  iova_bitmap.o \
>> +
>>  obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
>> new file mode 100644
>> index 000000000000..4211a16eb542
>> --- /dev/null
>> +++ b/drivers/vfio/iova_bitmap.c
>> @@ -0,0 +1,426 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (c) 2022, Oracle and/or its affiliates.
>> + * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>> + */
>> +#include <linux/iova_bitmap.h>
>> +#include <linux/mm.h>
>> +#include <linux/highmem.h>
>> +
>> +#define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)
>> +
>> +/*
>> + * struct iova_bitmap_map - A bitmap representing an IOVA range
>> + *
>> + * Main data structure for tracking mapped user pages of bitmap data.
>> + *
>> + * For example, for something recording dirty IOVAs, it will be provided a
>> + * struct iova_bitmap structure, as a general structure for iterating the
>> + * total IOVA range. The struct iova_bitmap_map, though, represents the
>> + * subset of said IOVA space that is pinned by its parent structure (struct
>> + * iova_bitmap).
>> + *
>> + * The user does not need to exact location of the bits in the bitmap.
>> + * From user perspective the only API available is iova_bitmap_set() which
>> + * records the IOVA *range* in the bitmap by setting the corresponding
>> + * bits.
>> + *
>> + * The bitmap is an array of u64 whereas each bit represents an IOVA of
>> + * range of (1 << pgshift). Thus formula for the bitmap data to be set is:
>> + *
>> + *   data[(iova / page_size) / 64] & (1ULL << (iova % 64))
>> + */
>> +struct iova_bitmap_map {
>> +	/* base IOVA representing bit 0 of the first page */
>> +	unsigned long iova;
>> +
>> +	/* page size order that each bit granules to */
>> +	unsigned long pgshift;
>> +
>> +	/* page offset of the first user page pinned */
>> +	unsigned long pgoff;
>> +
>> +	/* number of pages pinned */
>> +	unsigned long npages;
>> +
>> +	/* pinned pages representing the bitmap data */
>> +	struct page **pages;
>> +};
>> +
>> +/*
>> + * struct iova_bitmap - The IOVA bitmap object
>> + *
>> + * Main data structure for iterating over the bitmap data.
>> + *
>> + * Abstracts the pinning work and iterates in IOVA ranges.
>> + * It uses a windowing scheme and pins the bitmap in relatively
>> + * big ranges e.g.
>> + *
>> + * The bitmap object uses one base page to store all the pinned pages
>> + * pointers related to the bitmap. For sizeof(struct page) == 64 it stores
> 
> sizeof(struct page*) == 8?
> 
yeah, we talk about pointers the actual struct page doesn't matter. I'll change that.
 
>> + * 512 struct pages which, if the base page size is 4K, it means 2M of bitmap
> 
> s/struct pages/struct page pointers/
> 
/me nods

>> + * data is pinned at a time. If the iova_bitmap page size is also 4K
>> + * then the range window to iterate is 64G.
>> + *
>> + * For example iterating on a total IOVA range of 4G..128G, it will walk
>> + * through this set of ranges:
>> + *
>> + *    4G  -  68G-1 (64G)
>> + *    68G - 128G-1 (64G)
>> + *
>> + * An example of the APIs on how to use/iterate over the IOVA bitmap:
>> + *
>> + *   bitmap = iova_bitmap_alloc(iova, length, page_size, data);
>> + *   if (IS_ERR(bitmap))
>> + *       return PTR_ERR(bitmap);
>> + *
>> + *   ret = iova_bitmap_for_each(bitmap, arg, dirty_reporter_fn);
>> + *
>> + *   iova_bitmap_free(bitmap);
>> + *
>> + * An implementation of the lower end (referred to above as
>> + * dirty_reporter_fn to exemplify), that is tracking dirty bits would mark
>> + * an IOVA as dirty as following:
>> + *     iova_bitmap_set(bitmap, iova, page_size);
>> + * Or a contiguous range (example two pages):
>> + *     iova_bitmap_set(bitmap, iova, 2 * page_size);
> 
> This seems like it implies a stronger correlation to the
> iova_bitmap_alloc() page_size than actually exists.  The implementation
> of the dirty_reporter_fn() may not know the reporting page_size.  The
> value here is just a size_t and iova_bitmap handles the rest, right?
> 
Correct. 

The intent was to show an example of what the different usage have
an effect in the end bitmap data (1 page and then 2 pages). An alternative
would be:

	An implementation of the lower end (referred to above as
	dirty_reporter_fn to exemplify), that is tracking dirty bits would mark
	an IOVA range spanning @iova_length as dirty, using the configured
	@page_size:

  	  iova_bitmap_set(bitmap, iova, iova_length)

But with a different length variable (i.e. iova_length) to avoid being confused with
the length in iova_bitmap_alloc right before this paragraph. But the example in the
patch looks a bit more clear on the outcomes to me personally.

>> + *
>> + * The internals of the object uses an index @mapped_base_index that indexes
>> + * which u64 word of the bitmap is mapped, up to @mapped_total_index.
>> + * Those keep being incremented until @mapped_total_index reaches while
> 
> s/reaches/is reached/
> 
/me nods

>> + * mapping up to PAGE_SIZE / sizeof(struct page*) maximum of pages.
>> + *
>> + * The IOVA bitmap is usually located on what tracks DMA mapped ranges or
>> + * some form of IOVA range tracking that co-relates to the user passed
>> + * bitmap.
>> + */
>> +struct iova_bitmap {
>> +	/* IOVA range representing the currently mapped bitmap data */
>> +	struct iova_bitmap_map mapped;
>> +
>> +	/* userspace address of the bitmap */
>> +	u64 __user *bitmap;
>> +
>> +	/* u64 index that @mapped points to */
>> +	unsigned long mapped_base_index;
>> +
>> +	/* how many u64 can we walk in total */
>> +	unsigned long mapped_total_index;
>> +
>> +	/* base IOVA of the whole bitmap */
>> +	unsigned long iova;
>> +
>> +	/* length of the IOVA range for the whole bitmap */
>> +	size_t length;
>> +};
>> +
>> +/*
>> + * Converts a relative IOVA to a bitmap index.
>> + * This function provides the index into the u64 array (bitmap::bitmap)
>> + * for a given IOVA offset.
>> + * Relative IOVA means relative to the bitmap::mapped base IOVA
>> + * (stored in mapped::iova). All computations in this file are done using
>> + * relative IOVAs and thus avoid an extra subtraction against mapped::iova.
>> + * The user API iova_bitmap_set() always uses a regular absolute IOVAs.
>> + */
>> +static unsigned long iova_bitmap_offset_to_index(struct iova_bitmap *bitmap,
>> +						 unsigned long iova)
>> +{
>> +	unsigned long pgsize = 1 << bitmap->mapped.pgshift;
>> +
>> +	return iova / (BITS_PER_TYPE(*bitmap->bitmap) * pgsize);
>> +}
>> +
>> +/*
>> + * Converts a bitmap index to a *relative* IOVA.
>> + */
>> +static unsigned long iova_bitmap_index_to_offset(struct iova_bitmap *bitmap,
>> +						 unsigned long index)
>> +{
>> +	unsigned long pgshift = bitmap->mapped.pgshift;
>> +
>> +	return (index * BITS_PER_TYPE(*bitmap->bitmap)) << pgshift;
>> +}
>> +
>> +/*
>> + * Returns the base IOVA of the mapped range.
>> + */
>> +static unsigned long iova_bitmap_mapped_iova(struct iova_bitmap *bitmap)
>> +{
>> +	unsigned long skip = bitmap->mapped_base_index;
>> +
>> +	return bitmap->iova + iova_bitmap_index_to_offset(bitmap, skip);
>> +}
>> +
>> +/*
>> + * Pins the bitmap user pages for the current range window.
>> + * This is internal to IOVA bitmap and called when advancing the
>> + * index (@mapped_base_index) or allocating the bitmap.
>> + */
>> +static int iova_bitmap_get(struct iova_bitmap *bitmap)
>> +{
>> +	struct iova_bitmap_map *mapped = &bitmap->mapped;
>> +	unsigned long npages;
>> +	u64 __user *addr;
>> +	long ret;
>> +
>> +	/*
>> +	 * @mapped_base_index is the index of the currently mapped u64 words
>> +	 * that we have access. Anything before @mapped_base_index is not
>> +	 * mapped. The range @mapped_base_index .. @mapped_total_index-1 is
>> +	 * mapped but capped at a maximum number of pages.
>> +	 */
>> +	npages = DIV_ROUND_UP((bitmap->mapped_total_index -
>> +			       bitmap->mapped_base_index) *
>> +			       sizeof(*bitmap->bitmap), PAGE_SIZE);
>> +
>> +	/*
>> +	 * We always cap at max number of 'struct page' a base page can fit.
>> +	 * This is, for example, on x86 means 2M of bitmap data max.
>> +	 */
>> +	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
>> +
>> +	/*
>> +	 * Bitmap address to be pinned is calculated via pointer arithmetic
>> +	 * with bitmap u64 word index.
>> +	 */
>> +	addr = bitmap->bitmap + bitmap->mapped_base_index;
>> +
>> +	ret = pin_user_pages_fast((unsigned long)addr, npages,
>> +				  FOLL_WRITE, mapped->pages);
>> +	if (ret <= 0)
>> +		return -EFAULT;
>> +
>> +	mapped->npages = (unsigned long)ret;
>> +	/* Base IOVA where @pages point to i.e. bit 0 of the first page */
>> +	mapped->iova = iova_bitmap_mapped_iova(bitmap);
>> +
>> +	/*
>> +	 * offset of the page where pinned pages bit 0 is located.
>> +	 * This handles the case where the bitmap is not PAGE_SIZE
>> +	 * aligned.
>> +	 */
>> +	mapped->pgoff = offset_in_page(addr);
>> +	return 0;
>> +}
>> +
>> +/*
>> + * Unpins the bitmap user pages and clears @npages
>> + * (un)pinning is abstracted from API user and it's done when advancing
>> + * the index or freeing the bitmap.
>> + */
>> +static void iova_bitmap_put(struct iova_bitmap *bitmap)
>> +{
>> +	struct iova_bitmap_map *mapped = &bitmap->mapped;
>> +
>> +	if (mapped->npages) {
>> +		unpin_user_pages(mapped->pages, mapped->npages);
>> +		mapped->npages = 0;
>> +	}
>> +}
>> +
>> +/**
>> + * iova_bitmap_alloc() - Allocates an IOVA bitmap object
>> + * @iova: Start address of the IOVA range
>> + * @length: Length of the IOVA range
>> + * @page_size: Page size of the IOVA bitmap. It defines what each bit
>> + *             granularity represents
>> + * @data: Userspace address of the bitmap
>> + *
>> + * Allocates an IOVA object and initializes all its fields including the
>> + * first user pages of @data.
>> + *
>> + * Return: A pointer to a newly allocated struct iova_bitmap
>> + * or ERR_PTR() on error.
>> + */
>> +struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
>> +				      unsigned long page_size, u64 __user *data)
>> +{
>> +	struct iova_bitmap_map *mapped;
>> +	struct iova_bitmap *bitmap;
>> +	int rc;
>> +
>> +	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
>> +	if (!bitmap)
>> +		return ERR_PTR(-ENOMEM);
>> +
>> +	mapped = &bitmap->mapped;
>> +	mapped->pgshift = __ffs(page_size);
>> +	bitmap->bitmap = data;
>> +	bitmap->mapped_total_index =
>> +		iova_bitmap_offset_to_index(bitmap, length - 1) + 1;
>> +	bitmap->iova = iova;
>> +	bitmap->length = length;
>> +	mapped->iova = iova;
>> +	mapped->pages = (struct page **)__get_free_page(GFP_KERNEL);
>> +	if (!mapped->pages) {
>> +		rc = -ENOMEM;
>> +		goto err;
>> +	}
>> +
>> +	rc = iova_bitmap_get(bitmap);
>> +	if (rc)
>> +		goto err;
>> +	return bitmap;
>> +
>> +err:
>> +	iova_bitmap_free(bitmap);
>> +	return ERR_PTR(rc);
>> +}
>> +
>> +/**
>> + * iova_bitmap_free() - Frees an IOVA bitmap object
>> + * @bitmap: IOVA bitmap to free
>> + *
>> + * It unpins and releases pages array memory and clears any leftover
>> + * state.
>> + */
>> +void iova_bitmap_free(struct iova_bitmap *bitmap)
>> +{
>> +	struct iova_bitmap_map *mapped = &bitmap->mapped;
>> +
>> +	iova_bitmap_put(bitmap);
>> +
>> +	if (mapped->pages) {
>> +		free_page((unsigned long)mapped->pages);
>> +		mapped->pages = NULL;
>> +	}
>> +
>> +	kfree(bitmap);
>> +}
>> +
>> +/*
>> + * Returns the remaining bitmap indexes from mapped_total_index to process for
>> + * the currently pinned bitmap pages.
>> + */
>> +static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
>> +{
>> +	unsigned long remaining;
>> +
>> +	remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
>> +	remaining = min_t(unsigned long, remaining,
>> +	      (bitmap->mapped.npages << PAGE_SHIFT) / sizeof(*bitmap->bitmap));
>> +
>> +	return remaining;
>> +}
>> +
>> +/*
>> + * Returns the length of the mapped IOVA range.
>> + */
>> +static unsigned long iova_bitmap_mapped_length(struct iova_bitmap *bitmap)
>> +{
>> +	unsigned long max_iova = bitmap->iova + bitmap->length - 1;
>> +	unsigned long iova = iova_bitmap_mapped_iova(bitmap);
>> +	unsigned long remaining;
>> +
>> +	/*
>> +	 * iova_bitmap_mapped_remaining() returns a number of indexes which
>> +	 * when converted to IOVA gives us a max length that the bitmap
>> +	 * pinned data can cover. Afterwards, that is capped to
>> +	 * only cover the IOVA range in @bitmap::iova .. @bitmap::length.
>> +	 */
>> +	remaining = iova_bitmap_index_to_offset(bitmap,
>> +			iova_bitmap_mapped_remaining(bitmap));
>> +
>> +	if (iova + remaining - 1 > max_iova)
>> +		remaining -= ((iova + remaining - 1) - max_iova);
>> +
>> +	return remaining;
>> +}
>> +
>> +/*
>> + * Returns true if there's not more data to iterate.
>> + */
>> +static bool iova_bitmap_done(struct iova_bitmap *bitmap)
>> +{
>> +	return bitmap->mapped_base_index >= bitmap->mapped_total_index;
>> +}
>> +
>> +/*
>> + * Advances to the next range, releases the current pinned
>> + * pages and pins the next set of bitmap pages.
>> + * Returns 0 on success or otherwise errno.
>> + */
>> +static int iova_bitmap_advance(struct iova_bitmap *bitmap)
>> +{
>> +	unsigned long iova = iova_bitmap_mapped_length(bitmap) - 1;
>> +	unsigned long count = iova_bitmap_offset_to_index(bitmap, iova) + 1;
>> +
>> +	bitmap->mapped_base_index += count;
>> +
>> +	iova_bitmap_put(bitmap);
>> +	if (iova_bitmap_done(bitmap))
>> +		return 0;
>> +
>> +	/* When advancing the index we pin the next set of bitmap pages */
>> +	return iova_bitmap_get(bitmap);
>> +}
>> +
>> +/**
>> + * iova_bitmap_for_each() - Iterates over the bitmap
>> + * @bitmap: IOVA bitmap to iterate
>> + * @opaque: Additional argument to pass to the callback
>> + * @fn: Function that gets called for each IOVA range
>> + *
>> + * Helper function to iterate over bitmap data representing a portion of IOVA
>> + * space. It hides the complexity of iterating bitmaps and translating the
>> + * mapped bitmap user pages into IOVA ranges to process.
>> + *
>> + * Return: 0 on success, and an error on failure either upon
>> + * iteration or when the callback returns an error.
>> + */
>> +int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
>> +			 int (*fn)(struct iova_bitmap *bitmap,
>> +				   unsigned long iova, size_t length,
>> +				   void *opaque))
> 
> It might make sense to typedef an iova_bitmap_fn_t in the header to use
> here.
>
OK, will do. I wasn't sure which style was preferred so went with simplest on
first take.
 
>> +{
>> +	int ret = 0;
>> +
>> +	for (; !iova_bitmap_done(bitmap) && !ret;
>> +	     ret = iova_bitmap_advance(bitmap)) {
>> +		ret = fn(bitmap, iova_bitmap_mapped_iova(bitmap),
>> +			 iova_bitmap_mapped_length(bitmap), opaque);
>> +		if (ret)
>> +			break;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +/**
>> + * iova_bitmap_set() - Records an IOVA range in bitmap
>> + * @bitmap: IOVA bitmap
>> + * @iova: IOVA to start
>> + * @length: IOVA range length
>> + *
>> + * Set the bits corresponding to the range [iova .. iova+length-1] in
>> + * the user bitmap.
>> + *
>> + * Return: The number of bits set.
> 
> Is this relevant to the caller?
> 
The thinking that number of bits was a way for caller to validate that
'some bits' was set, i.e. sort of error return value. But none of the callers
use it today, it's true. Suppose I should remove it, following bitmap_set()
returning void too.

>> + */
>> +unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
>> +			      unsigned long iova, size_t length)
>> +{
>> +	struct iova_bitmap_map *mapped = &bitmap->mapped;
>> +	unsigned long nbits = max(1UL, length >> mapped->pgshift), set = nbits;
>> +	unsigned long offset = (iova - mapped->iova) >> mapped->pgshift;
> 
> There's no sanity testing here that the caller provided an iova within
> the mapped ranged.  Thanks,
> 

Much of the bitmap helpers don't check that the offset is within the range
of the passed ulong array. So I followed the same thinking and the
caller is /provided/ with the range that the IOVA bitmap covers. The intention
was minimizing the number of operations given that this function sits on the
hot path. I can add this extra check.

> Alex
> 
>> +	unsigned long page_idx = offset / BITS_PER_PAGE;
>> +	unsigned long page_offset = mapped->pgoff;
>> +	void *kaddr;
>> +
>> +	offset = offset % BITS_PER_PAGE;
>> +
>> +	do {
>> +		unsigned long size = min(BITS_PER_PAGE - offset, nbits);
>> +
>> +		kaddr = kmap_local_page(mapped->pages[page_idx]);
>> +		bitmap_set(kaddr + page_offset, offset, size);
>> +		kunmap_local(kaddr);
>> +		page_offset = offset = 0;
>> +		nbits -= size;
>> +		page_idx++;
>> +	} while (nbits > 0);
>> +
>> +	return set;
>> +}
>> +EXPORT_SYMBOL_GPL(iova_bitmap_set);
>> diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
>> new file mode 100644
>> index 000000000000..ab3b4fa6ac48
>> --- /dev/null
>> +++ b/include/linux/iova_bitmap.h
>> @@ -0,0 +1,24 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2022, Oracle and/or its affiliates.
>> + * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>> + */
>> +#ifndef _IOVA_BITMAP_H_
>> +#define _IOVA_BITMAP_H_
>> +
>> +#include <linux/types.h>
>> +
>> +struct iova_bitmap;
>> +
>> +struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
>> +				      unsigned long page_size,
>> +				      u64 __user *data);
>> +void iova_bitmap_free(struct iova_bitmap *bitmap);
>> +int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
>> +			 int (*fn)(struct iova_bitmap *bitmap,
>> +				   unsigned long iova, size_t length,
>> +				   void *opaque));
>> +unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
>> +			      unsigned long iova, size_t length);
>> +
>> +#endif
> 
