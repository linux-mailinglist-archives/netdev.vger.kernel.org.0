Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027425A791A
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 10:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiHaId1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 04:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiHaIdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 04:33:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21BEC12F9
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 01:33:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27V4uAOE018723;
        Wed, 31 Aug 2022 08:33:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=YGN84qk7+jDaHKSyFAB6/AWdeBCqWCW5qQK8uHhUAAI=;
 b=O4OkIAesBKto4n6R6jHBBcuLUM/uxyNI/y01jBhOl9VMZxLmLXv1pN31oyW3aOH04xv6
 7cq/t0FtPZmzBE/Y5LV9hUnPTiiKXUY7sBduBJuunkFiQ/4S3n4fU7o87Do3HWQxYhxR
 AR8HzyCVe6YtxVkN6IbfBShpat1k4aCwxra4O1axMZ4zArvg5y5j7x6NlBuSn6R5wWbc
 BLbC7kTgqesymf7Zq0vAsUGabsWA0ymrgX+R8JqrwqCciaAbvsk/BvsGGd89dejXDkaW
 6hK7vq7uvgZ5nz3DG9WRJQ6dDrL9o5ZAUclKWyqH01NmL83o1vhp0MbrzDpgX7Fkp/f3 nw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j7b5a0f6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Aug 2022 08:33:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27V69ak9038156;
        Wed, 31 Aug 2022 08:33:11 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j79q4uqmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 31 Aug 2022 08:33:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LBOOt7+ghKaLCsjhW5EPOu5qSifyslDp0KQa9L2KkeQBH2n1uiEOR9ymyCdErIZ2/k8dqw1a8OCOxZ5pLJMUq6IBm/WcippFV+4YISPs4t9EF84U9X/nJn+laR6PwxU3QYzdJo+jGelUqctrCPkFzGLw0KHkgpySl7LAe5gHrPlsTfQUxURrOiJSATXWUHaWbIZJ7TTbwczig2IS7PypTO35Un+nPEIXr9+8J7sW8HPzszV01zNfEqtENt+MSQ78HuuxgtVfZShngmNCjgjQ5mQdtr9GNpfUb4wV/xRTiGKICvvclEeipSasHSZ8PJRl29TO048QXH7hfRPPZJ8dVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YGN84qk7+jDaHKSyFAB6/AWdeBCqWCW5qQK8uHhUAAI=;
 b=ZdBsvCw2NdQCf8YX56DahI85hlw0U/4ERPXP6HhJhqutGwdcLw4f4B8+ufA6HJyhkpOGc9Z1eujo6LcXraKul1TD+i4Wp+O2OPYovpCGcjs6KRNTyOipkPyjjnrBqRmIm5c2ThDsSJHObr8v6jJSX2OtsIEM6nEZjaVczDVBNtdv1bBYNVl3GxTbGdgwvlyFitKGpCJM61KAGKuyQ7CugJCYuMc1iPnDNOq5j7buYVmW5pfWtkrqr/xedZJUlgmUcJJWNDXUw1jQGwJ47BFBHTwifqva/MKM0sLe4937X9p558JBIOvFTclmnyTR3BBXoXp85MMGDSBNHnxQwL0CiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGN84qk7+jDaHKSyFAB6/AWdeBCqWCW5qQK8uHhUAAI=;
 b=HVpPewFu+WGonsaQnzD4cX4EFrjRfis3qxAjkkQuEKqvmltLPviErNp29QOwyHStVL8glry3tVG/X8zppSN2SY9UVr1m2uhwgJgt3qPXWd3RNm7XqVl+4NytZCBTZd3WbLRU15BBb7BfVbPXeevA+lafxNdxcize86UQEcAaIlI=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by CO6PR10MB5571.namprd10.prod.outlook.com (2603:10b6:303:146::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 08:33:09 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 08:33:09 +0000
Message-ID: <ed397c98-316c-4785-0d16-81605246c2cb@oracle.com>
Date:   Wed, 31 Aug 2022 01:33:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [virtio-dev] [PATCH v3 2/2] virtio-net: use mtu size as buffer
 length for big packets
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>, stephen@networkplumber.org,
        davem@davemloft.net, jesse.brandeburg@intel.com,
        alexander.h.duyck@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org, mst@redhat.com
Cc:     gavi@nvidia.com, parav@nvidia.com
References: <20220830022634.69686-1-gavinl@nvidia.com>
 <20220830022634.69686-3-gavinl@nvidia.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220830022634.69686-3-gavinl@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0097.namprd13.prod.outlook.com
 (2603:10b6:806:24::12) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2f4493f-4aec-4a64-2e3c-08da8b2b6f1e
X-MS-TrafficTypeDiagnostic: CO6PR10MB5571:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IIntTkl+Gp6HzrMVdb7DPtHE9sQ1TzEbqvAogAxDpLSQEAoEgi6G/CXoXW+awEWCa3f4ZGvBAEoCphtOB9AgIBULsoOdSQ1yVthJVPw4sP3Q8UnPspdMIcp4biPOIsThLxWJSk6ZKSn0nrquN/HyFGrAVw/YIbBFes/kBW6EOMJ7G+rwD1iEb3NcqisRL6zr+elVEFvwht48vJmpg1PfVO2nGv5j81MWSg23XB4G0d9Yin5TfTh1sN43dPDug5Isg1p9stIlrcew10Vms9qBJn7UTVCovH/oftyY2oZzg8YGpacRM4cf89D1Gd8b3GjcUFLmemOU9pKFKoNeI1i9REgFhUH+dgshWojjbKSTIT+mBNLO7IQgwxjEQc6g0Vd8f9D6vQnbBwngo4mfAHWEiFfxjMujYyjI7XFcGs28/N1rlQot7uygxzU6RTca+oPk6LymN3Kg4TE8zzkTzcdyQqtl2eibtYmMw3ba9rduvBhnFT4vDu+bIM7bYktDoYVkqetuJv+9S0WyvraKIQpcr5jacMxb3UPYKuGwx0pYs5RCaGZb6vLTGTPnlnLrESKA14KJu0JqfLdRoDIZDFawTLWACdcs1xOzO8w8ZeZsF5mLF8KBApg4ygOWiWImIrlZxISPetWRtTfaaBeXRc0/HQeIp78iCV7JQpz9v43W0b85hUmcJujtzpXu+xF8xHXVuhHftMRkDw+nH6PUuXo02Xql1JKKnvrTvMv5ivYE5KxKpmg3LpD3Qa1G74QFXmbKTqvH37Dk7XpABcN5UWjDwedXJAJ7Zid7wvQzxwTljFDJyMTSMUwsGL+LMnGqa3B5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(366004)(396003)(39860400002)(136003)(8676002)(66476007)(66556008)(4326008)(66946007)(316002)(36756003)(2906002)(31696002)(6486002)(5660300002)(86362001)(7416002)(8936002)(38100700002)(31686004)(921005)(186003)(2616005)(41300700001)(478600001)(26005)(6506007)(6512007)(6666004)(36916002)(53546011)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXRkbXE4aXByZkUyV3ZYZGExNVNZbXVYZ2QvN3FyU1Q1OGxmV0RBS2t6bnBP?=
 =?utf-8?B?K2czTkRhK0R1RWlUMm5QUkhKNHlHT0hFQTRDTHErQ2hlVllRWGg1dXhYZXY3?=
 =?utf-8?B?MlkyMFNZQ2RjeDBrcFd0MGVTbW5PWXJKcU4rUS9tMmg4MXNjYjdKUjBwSFl1?=
 =?utf-8?B?aXJKamcrL3laRGpJZklrVFpacE9oczdWUEFNNmNCK0JJc1JSbTJkNjNrMkFp?=
 =?utf-8?B?TUZsMCs1UmpFYXNNdlRRVU5ud1pJQTVUNVBUcmJ0OVRiVzBkQ0luR2Q5SExk?=
 =?utf-8?B?eWh4ckhTQjFCOFhyVXczZE9kWE5rd2tURzJiYmp3ZHhDNkFLaWpGUkxRbGd0?=
 =?utf-8?B?amtzd3VCanhEUzVBbjkwaDQ4NUZ5VkFSdXpWK2huSDlybVZ0WWkxVWRqdE5X?=
 =?utf-8?B?VzFDZzc0YTFCbHIxQmovekVkdWVNK3VBR281a0VXK2RIU3pNVkFoRHZSS25P?=
 =?utf-8?B?T0d6cVdtVDhzdHZMNkg4UkNTSGR5TUUwU2RMd2RxQTBxcnVWbGRQTG5UWjly?=
 =?utf-8?B?VXorYm5NUExlNjZRdGlmNjl5UnFxMFNtbUFLN2ppSTRabUE2SW1iSHVFS0dO?=
 =?utf-8?B?aHFRV1VRaXZXeUFGM1k0M2VnUUdUdFZNaE5vaTdWakZHZ3FydE9HWW5QMVlW?=
 =?utf-8?B?SEM4d2VJc0pJV0FuSGJkZ1NNekRBYWFYbGhneFB6dVBIcmNXMXcrMzYvLy9h?=
 =?utf-8?B?L3VMS1RyOVRTK2szTEV6QmFGYm1FdkNRTHVVN0NvQWNvODl2OG83NUVVUEVM?=
 =?utf-8?B?Q25pMEF2QXZlMS9ydWorY1EzcU92czVOM0M0SHNWYTZscHB6TVhiSTZSTmFG?=
 =?utf-8?B?QjZ3eHdwWUF5dm9nN0srRmtuRGtkQmFyOVpQZ1hNdjFGVmVrL1QwWGNKU25R?=
 =?utf-8?B?TnNGY1Npc0JDZk1iMFhzOXRkcTlGR0RWNWN5OHFpWCt5RTVkSXpTU2xJRFlr?=
 =?utf-8?B?Mmd3R2Z6a0JyQlJnMXFJcnZnY3RNK0R5TVVvL2tQTnUzTmF3OGZCOFNGUkpW?=
 =?utf-8?B?N09IMXlYMThzYWovdmxYTVlTYzJrR0RBVnBnUE9ycFBnVjJITUh4bXNzNHhW?=
 =?utf-8?B?STRyOFlrcnIvbDJ4WVRlcHVlcEd3dVVyM3NJWmt5TGFQc1dSRzd2S05VZitj?=
 =?utf-8?B?K1RrZWpMWE16bk5yRjVESXU3bVFOZDBrVDBXd1k3TkM3bHpnbXFJNkIvdkEw?=
 =?utf-8?B?TThTZitjWDdOQ1NvR002WSsxeU1leUgwcFZnSkkwdDd1ejIvYmRKTlg5Q2ox?=
 =?utf-8?B?M3pacXJTcW9wQlRGQXQ1OVhFczRmdWRDVUVlUXAvRVVwd1dKejk4Skx1dXRj?=
 =?utf-8?B?RUNhcjIrS3VhYVlyT0l0a3B6RUV5V045VENjYThXTEdVeUV5QldOMUVmYUFU?=
 =?utf-8?B?Z2o0V3BzMk9FZ2NHTCtNdVYvS245QW9LdjJ0VDdXT3FGR0dvL1J6MDJtbDNn?=
 =?utf-8?B?UDlDWFNXcGdtTUNkTlRjTlh6alp0TlJxQTc0WlBvU2lmNWU3R2NuUGNJbDln?=
 =?utf-8?B?QVg4QXBSRnVkYTRPdXMrYWZYSFJXdDF4c0liUGtxTmk1eUo0dUlZNmgzK1F2?=
 =?utf-8?B?eURxWFdkVk45QW9mWHVUL3pUUXFhdHdESFVtaElKLzgvZ2dyUzQrck01ZFQv?=
 =?utf-8?B?azd2WXVNVktHNjZEQkhLYTdXaWlQN3h2anBtVHg1Ym8xTXJ2OVQ4K3Zuc0Nm?=
 =?utf-8?B?N09TUllLNVhDdkQvNVN3ZUk5SkdRb09JOTRqV3grMDNvYkUrOThqTkJ5N1V0?=
 =?utf-8?B?TnYwTC82d3pZQXpUYWZIVWJIeXhRWGxoazVlcmF5cXNUbUsxQ1NZeWVzVTlt?=
 =?utf-8?B?VTVMOVJhYUVOby9TaUcrQUxqNGhJd3Q0b2c0TWVUYnh6YUpndmNjMVoxOU5z?=
 =?utf-8?B?YVdNaDhsWmNjQUdOSi9Tb2ZtQVJKUUxHeHo4UWQ1RDlYQWwzQkZtNEFBeHda?=
 =?utf-8?B?RXhmZjlDZXdHeTJialpYU250MGVLVisvekRqNFNpNTh1c1AyQU1BZC9YV1pI?=
 =?utf-8?B?V0d6Z2tYbko1U0hNVFEwZjF5dXFyWi9DRkxnZ3pLK09hMGpFdjBJdlJYK2pD?=
 =?utf-8?B?ZjFubFRNWFZCYXZvYUpWM09lSDFMZXl5UkF2MEVLbmJuYUk3d3VPV1Q1MURR?=
 =?utf-8?Q?3oyCF7IaZ2+Swp66/xODKvNZ1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2f4493f-4aec-4a64-2e3c-08da8b2b6f1e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 08:33:09.2012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sZM8JyuD/BFZmZeCDooDaWZNU55LBSr4yyI5mYCtDbGl+OfsPiu9o6OxmWWdXeLKtxW/5t0PnofLGVe19O3SkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5571
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-31_05,2022-08-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208310042
X-Proofpoint-ORIG-GUID: Y11YWtrTwLY5m3rgjcJoBJCzQBBzhXAM
X-Proofpoint-GUID: Y11YWtrTwLY5m3rgjcJoBJCzQBBzhXAM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/29/2022 7:26 PM, Gavin Li wrote:
> Currently add_recvbuf_big() allocates MAX_SKB_FRAGS segments for big
> packets even when GUEST_* offloads are not present on the device.
> However, if guest GSO is not supported, it would be sufficient to
> allocate segments to cover just up the MTU size and no further.
> Allocating the maximum amount of segments results in a large waste of
> buffer space in the queue, which limits the number of packets that can
> be buffered and can result in reduced performance.
>
> Therefore, if guest GSO is not supported, use the MTU to calculate the
> optimal amount of segments required.
>
> When guest offload is enabled at runtime, RQ already has packets of bytes
> less than 64K. So when packet of 64KB arrives, all the packets of such
> size will be dropped. and RQ is now not usable.
>
> So this means that during set_guest_offloads() phase, RQs have to be
> destroyed and recreated, which requires almost driver reload.
>
> If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS has been negotiated, then it should
> always treat them as GSO enabled.
>
> Below is the iperf TCP test results over a Mellanox NIC, using vDPA for
> 1 VQ, queue size 1024, before and after the change, with the iperf
> server running over the virtio-net interface.
>
> MTU(Bytes)/Bandwidth (Gbit/s)
>               Before   After
>    1500        22.5     22.4
>    9000        12.8     25.9
>
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> ---
> changelog:
> v2->v3
> - Addressed comments from Si-Wei
> - Simplify the condition check to enable the optimization
> v1->v2
> - Addressed comments from Jason, Michael, Si-Wei.
> - Remove the flag of guest GSO support, set sg_num for big packets and
>    use it directly
> - Recalculate sg_num for big packets in virtnet_set_guest_offloads
> - Replace the round up algorithm with DIV_ROUND_UP
> ---
>   drivers/net/virtio_net.c | 37 ++++++++++++++++++++++++-------------
>   1 file changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index e1904877d461..d2721e71af18 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -225,6 +225,9 @@ struct virtnet_info {
>   	/* I like... big packets and I cannot lie! */
>   	bool big_packets;
>   
> +	/* number of sg entries allocated for big packets */
> +	unsigned int big_packets_sg_num;
Sorry for nit picking, but in my opinion big_packets_num_skbfrags might 
be a better name than big_packets_sg_num, where the comment could be 
written as "number of skb fragments for big packets" rather than "number 
of sg entries allocated for big packets".

Reviewed-by: Si-Wei Liu <si-wei.liu@oracle.com>

> +
>   	/* Host will merge rx buffers for big packets (shake it! shake it!) */
>   	bool mergeable_rx_bufs;
>   
> @@ -1331,10 +1334,10 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
>   	char *p;
>   	int i, err, offset;
>   
> -	sg_init_table(rq->sg, MAX_SKB_FRAGS + 2);
> +	sg_init_table(rq->sg, vi->big_packets_sg_num + 2);
>   
> -	/* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
> -	for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
> +	/* page in rq->sg[vi->big_packets_sg_num + 1] is list tail */
> +	for (i = vi->big_packets_sg_num + 1; i > 1; --i) {
>   		first = get_a_page(rq, gfp);
>   		if (!first) {
>   			if (list)
> @@ -1365,7 +1368,7 @@ static int add_recvbuf_big(struct virtnet_info *vi, struct receive_queue *rq,
>   
>   	/* chain first in list head */
>   	first->private = (unsigned long)list;
> -	err = virtqueue_add_inbuf(rq->vq, rq->sg, MAX_SKB_FRAGS + 2,
> +	err = virtqueue_add_inbuf(rq->vq, rq->sg, vi->big_packets_sg_num + 2,
>   				  first, gfp);
>   	if (err < 0)
>   		give_pages(rq, first);
> @@ -3690,13 +3693,27 @@ static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
>   		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO));
>   }
>   
> +static void virtnet_set_big_packets_fields(struct virtnet_info *vi, const int mtu)
> +{
> +	bool guest_gso = virtnet_check_guest_gso(vi);
> +
> +	/* If device can receive ANY guest GSO packets, regardless of mtu,
> +	 * allocate packets of maximum size, otherwise limit it to only
> +	 * mtu size worth only.
> +	 */
> +	if (mtu > ETH_DATA_LEN || guest_gso) {
> +		vi->big_packets = true;
> +		vi->big_packets_sg_num = guest_gso ? MAX_SKB_FRAGS : DIV_ROUND_UP(mtu, PAGE_SIZE);
> +	}
> +}
> +
>   static int virtnet_probe(struct virtio_device *vdev)
>   {
>   	int i, err = -ENOMEM;
>   	struct net_device *dev;
>   	struct virtnet_info *vi;
>   	u16 max_queue_pairs;
> -	int mtu;
> +	int mtu = 0;
>   
>   	/* Find if host supports multiqueue/rss virtio_net device */
>   	max_queue_pairs = 1;
> @@ -3784,10 +3801,6 @@ static int virtnet_probe(struct virtio_device *vdev)
>   	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
>   	spin_lock_init(&vi->refill_lock);
>   
> -	/* If we can receive ANY GSO packets, we must allocate large ones. */
> -	if (virtnet_check_guest_gso(vi))
> -		vi->big_packets = true;
> -
>   	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
>   		vi->mergeable_rx_bufs = true;
>   
> @@ -3853,12 +3866,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>   
>   		dev->mtu = mtu;
>   		dev->max_mtu = mtu;
> -
> -		/* TODO: size buffers correctly in this case. */
> -		if (dev->mtu > ETH_DATA_LEN)
> -			vi->big_packets = true;
>   	}
>   
> +	virtnet_set_big_packets_fields(vi, mtu);
> +
>   	if (vi->any_header_sg)
>   		dev->needed_headroom = vi->hdr_len;
>   

