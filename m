Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BDA5B0F4B
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 23:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiIGVkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 17:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIGVkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 17:40:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9C4A0301
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 14:40:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287LJVNo017890;
        Wed, 7 Sep 2022 21:39:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=0uNxT0iSzYOEQyD6hUjnPh0hi1y3yJjlS4GDyfiF1cg=;
 b=m1W+ohDg9N9IFzQd2vJGPzoGYYfYMPtSlRp9NtiMzxIrFAdQjmXwp0rbMDeEBvmORVrz
 qeZn60/f/OcW1PikZwhuDfrFK84JbQ1Gl6a1mwqnypLK4t/0TZgjiWzSDFfdxLLZMknB
 EbTwwdo1bzsDgAXUVsDHFnG/4QMzN7SwWoWS+ljauPQyoq+5Y9e2MBHmM9jXlkRXegjo
 QUrxv1lbW8xSHq6eJ0e2N1i3Asy8qoqTaqeb38Q+sE0wQNw45lIBhIooL5WOmlqS8PPi
 EHdm51m6jnQvtqtJTPjeoHQh9vTM8wduDAIymJfnDsNyu8yUvkMO/KTMLrI14Vrvxfaf NA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbwh1j6bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 21:39:59 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 287Ik7rI021267;
        Wed, 7 Sep 2022 21:39:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwcavvww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 21:39:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfdzylOpNcotIwBKBeIjepe1nD3hm9RWuyBQ8RF9CfWn7eX11A5TAERnoI/PO0583Vsv8TRJHpwJgJcH3/8eBxvCZz1n0UZKRhrtFrxvENF+RN8IDL2sBRxU3QmvPJKNPsRgp6CeDohStrfqReYd5vPpFKDknmc10ou8lzOMDdk95klF2HUMYUxb1OPDbYgp5nWl15Al9w3iVjY40CF90QenDrkep9pju4b8xh8rGGAOS3pSut95VkpuRFLXtc0u3LnAoiJDikqqkHc5cb8tbXpyGWLRqq3+nshKrP01oH97wRf1gV8pjdEd9ljYR2kAJ6qIyDXoGYv2gavFl9rzbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0uNxT0iSzYOEQyD6hUjnPh0hi1y3yJjlS4GDyfiF1cg=;
 b=VKOFF7iw+6CNHK5dDtv9fXsQFrnKRErADE4iUujenWdlp71npjL+a07QaSCMNnW0aybfM9fXXnp1SEwmiPpXn4zXZ4He4k/pa/0GZkmWF+SKkHaO7Ehb17ncwMOgzIX0zIaiY0SJCui/oFwT1RetEh9lQSVemO1c3wAIkrGlvLTMZQoCInp5xdqiHb5wYtnKy1ELy8qFs4mhgw1uSua4LCB6jEQhuSgxyF3nvAEQIH71vvgYwHRPmnMdoMWwKwW/pK+93RSarGKr32uv1nQPZ2xjLwn0vs1omUxghIVffudhzH9ybn4SSHRXEL+JdiI9NJ/5xriznn+bN9mQQWkagQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0uNxT0iSzYOEQyD6hUjnPh0hi1y3yJjlS4GDyfiF1cg=;
 b=zFqTBrRJ/T3Nvjjh4ZxWSBUG7uTk+ieYTrkGMwvd4G7KuQ746BGfSz9mdPLk7Xv2xn/bZkX+SjD1sDSWPK8lZ0Zte4UCJkwvzu0cgzGdgmpNBNJBCuG1s32AfDEXuv4quSDGqa9ytjDdnQazOyIzfWGN82Esvvx5azxPZ+9ZVO4=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BLAPR10MB5297.namprd10.prod.outlook.com (2603:10b6:208:326::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Wed, 7 Sep
 2022 21:39:55 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 21:39:55 +0000
Message-ID: <8d80bb05-2d01-9046-6642-3f74b59cc830@oracle.com>
Date:   Wed, 7 Sep 2022 14:39:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [virtio-dev] RE: [PATCH v5 2/2] virtio-net: use mtu size as
 buffer length for big packets
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>
References: <20220907101335-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481D19E1E5DA11B2BD067CFDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907152156-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481291080EBEC54C82A5641DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907153425-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54815E541D435DDC9339CA02DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <PH0PR12MB54815E541D435DDC9339CA02DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0069.namprd11.prod.outlook.com
 (2603:10b6:a03:80::46) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69e66c9a-3f0b-440c-922f-08da91198144
X-MS-TrafficTypeDiagnostic: BLAPR10MB5297:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 131eEst44nCmB6AyYNg53c3KRw16PcBV4NuUHDmi+314ioNHnCKkLScvPOd2DZxMI2YZe3Jq76NJmQ16VmIGARcQkhD3hJ9wlPU7wXXUwdO7ZWTQGe+E5C03MVI6nNoLKaIZCS8By0hH6EXLN8oQ/R6heRXd1gSQdQQf4hOUhO6Y3X27Q58Sbm3E7/+XXjFn46jzLM8X1Rlun1yd/wxCL+RbB0Ongcg0wjy1Zr4n+rNOKTU+ttoc/QJqsRQugvfrosfX95ZHMBLY/ipMfafKhd5DYVgNQO5cxUZs1ACEeh3ZMDkFYw7wBVshG/wJ/ADQ8IoYx+CgHHXu8LTrSZOAGzoWqvgNS2U28x1arPT/GLUJltzjc4qDjF76bo0Ht6Vqcbcz1EYSyrp4vvTo1TKwwh/Ib3GJYVWZ/HgcuZ4G11dZ/uEntuzCmeYftdVfKDTTwZyjOXp7e8+Km+6T8ozvkNGtuWr7//mLp1YNonOm5aHVKrROx3+p9I/Ery0LHWAgN4XOMs6tXbA5sUAKKA4TLy42EzdNJANlKwZClXX68hYHWFhxrrW/E3nGfULmbiLVumo4Y99aICaRChEzb3YXhD4rDqH1+WAAp9o2rBPTVIjAKi+S1CwbEuB88h3FyJR9iaHMWi83W/9ysWbnntLmtQ9TD4ZSIz8qmjuHFBfKQ4HQM9sYfmjxQ86PD1+V48dgt5QMELqOo8h4Krx7aX/ZKKqj/m6AdU0y/ucs7J8iVZ+bvP/0eC5ecKrqWwH916SvTcQjoJf7N60LUhsMnhU0ei8PH9ELQ5M6w03kcEXh70Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(39860400002)(136003)(396003)(376002)(31696002)(38100700002)(316002)(110136005)(54906003)(4744005)(5660300002)(66556008)(7416002)(8936002)(66946007)(66476007)(8676002)(4326008)(2906002)(6486002)(186003)(2616005)(41300700001)(83380400001)(6666004)(478600001)(36916002)(53546011)(6506007)(26005)(31686004)(6512007)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTBQd1B2OXdjMW1PSUl3V3RqWFN6a2JJR0ZnTFl2ZVVuc2lUQWNVU0FoelUy?=
 =?utf-8?B?SlNYTHNwbm1NN3ZiQkdVTlFSdlVZVGduL241ODJSYmtRbWVMdzdWcmNic2pi?=
 =?utf-8?B?eDhqRXdBTk5Ma2NzYTFrVk5BMEdSa0JGWnFpSk5wK1JCTmFvMnN4VFFYUjUz?=
 =?utf-8?B?TjFxZ1ZFSGNibzdZUVBoaTB3blAwTytVd2lOMllLL2NWY1dnZFhJaG5oNk5L?=
 =?utf-8?B?L1NUSll5VGFEeHdNME9mMEhWU0MveEtGSVJrd0ZabjI4SVlEbHhSV1F1OStz?=
 =?utf-8?B?WFRiUDE4SFB5OGNQTSs3ejVuSnRqanRjOXFMNi9DVEExeERHZENRMnFETkRL?=
 =?utf-8?B?V2RBQnhOUFk5Y2tJRG02c0lqYXh3eDVqOCtDUU9FbmJ3a1FFQ1cxcGk2RTBr?=
 =?utf-8?B?eWR3aDc5RnpZK3k0Y3E5MTVYKyt4T0czNnM1SGlad3RIcDg5UFU0dEI5UzJx?=
 =?utf-8?B?VnpncEN3Y1JNZXh0cU5Kd2ZUamxrWEROMXViRFAvMCtPQWNodVpBOFgrV3BF?=
 =?utf-8?B?ZVRQdDA0aE8vMlV0SjRQT1gxaWRicGYzT2g0VVM0VXUzNHRINWZ0QVM2alVo?=
 =?utf-8?B?SzZ0QmtFL0JSRnRMelNEek5ZSGtpbm1wSHBqVkswaFRHNWIrV0pSdWo2WlVD?=
 =?utf-8?B?OFZnVFNpalZZYm9PYnQ5TmVtNU96TmNjM0k0d1RsaFk1d3A4cFAzQmFaeWlQ?=
 =?utf-8?B?QlI1L0JLcGM0R1RCT1pyMStkQjZ4MmwxUUhMckh0Q1hpdVJpbHRJQmp5MVF4?=
 =?utf-8?B?dytmWGpwc3V3bHNpWXNPV0FRNGI5UUxJbkt3TkhHTjhjekNESVJjalVoNlR3?=
 =?utf-8?B?ekNmSkxNS1ZQT1IyS05VTnhWSVQrays3UVo0eXpneW9mL3NxUmVnSnFQc3Bt?=
 =?utf-8?B?SWtEMzZZVG5aK1kxOXFWeUNOWEk2MXptN0tBZndHc1RFeTY1eHMyV051MnJp?=
 =?utf-8?B?NXRvdm9sTk5CbFk5dWxJMW9qTUVST3BHaUtQbG5WMkxjV1d2Mk4zNGJPb25r?=
 =?utf-8?B?WTVMOHBzVFpwMXhlODVOSnNpc0ZrWWhKM0dUVCsvaGNUN25RbEMyTFZoRDls?=
 =?utf-8?B?UWdUOWZyNTE2WTlqOVoybnZKd2ZkRXRyOFBHR2ZMOVZzd2JCNTFwZDIxdy91?=
 =?utf-8?B?WW9TZFloeWZmNndaQ1VPNlI1TzJHd00wQWVqZFdaQkx5b1Q2dFNRUjFaS29t?=
 =?utf-8?B?eGhzc3pvZFE1TXBNYTVWRlRneEt2LzgwN2NBWVNEQ2xXZmtWclFndFpLMTZB?=
 =?utf-8?B?SU1wb0dPYy9QU21LOTJVU1pMWG9DOUx3eklJSVVIaHpDd3pGN2lzYlpRUHNp?=
 =?utf-8?B?cXcvTEhoTXlpWVVLZWc1YUE0blFZVTR6akROWnpod0FLaUZHN3BONkRWazBR?=
 =?utf-8?B?NG92b2FOVlY0YUM3Q3p6MXl1TXZWUFVkOEdJUTloSDZ3S2M4YS81eWxnRUpq?=
 =?utf-8?B?SFB1aDNwbW5DSGE1WWg0SmoxcG9uUmk5NDR3aFdGNjhSM0hYbm9oZll0UEpv?=
 =?utf-8?B?MjllWjU0UnNIUTFGVnA0dWl2cG5CK3h0ZFBKYmNXc1FLVURTZVMrblZXc0cr?=
 =?utf-8?B?YWo1N2FpckR0MWZNbEpYYnBtY3hocjc3WlhPcERhbEt4dGpic0xROEhTd3dN?=
 =?utf-8?B?Ri9NSURYTXNDam1RN0szaWVCblJVMEg2NWtQNUZxUGZyelVOQmthaVRoS1g3?=
 =?utf-8?B?Uk1FUDRjdmZFUTNxZ2tvZjBSZDV0VnZHMFgvVUNXZGxIVk0yL0tkQ2h6a25N?=
 =?utf-8?B?NVZnOVg4OEtvVUxvcjh2bnNjcVZWemRPQndXeXNISWVFZ2owMDZYcEE5d3RZ?=
 =?utf-8?B?ZWxuNzY2aDljcEZLMkY5eHR4Sm1RSGZSWWVkekNtVTZRTnp1WXR2UmIrYlRh?=
 =?utf-8?B?MUpZSnIxSm1qWjF6Z25qNFMxQk9ValBhN01xYnFUVUVLUkJMMDVKMjRHSnBt?=
 =?utf-8?B?NVdISjRxaC96VmQ4akxVblIyalo4UFdlRFNVamd4NzFseHhPbXUxRFl0OHB4?=
 =?utf-8?B?SGU0eGg5em04WUhKanR0TzBhTGQrekJvTUhZY1h5SGpnU3J1SHQ3L0ZIV2x2?=
 =?utf-8?B?V2dtOUpRaUJ0NXRvSHVxNHdmS202cU1VekxTY1phU3VyZ2I2N25laXZIc0lO?=
 =?utf-8?Q?1OhBUIyRNV1Vg0cZirhsx46uI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69e66c9a-3f0b-440c-922f-08da91198144
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 21:39:55.7498
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AY2Hl5lo56r1qvgiSR/Qu1NY8iixv6ny14mBuXxsO7Cs3qonCJ/y0eKomsBM2cMvqjN+9ZZJMSICd3wvMLtL4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5297
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209070079
X-Proofpoint-GUID: uDzEn5ZcU0xvzxjGvyv_gKTQm1HyD7YX
X-Proofpoint-ORIG-GUID: uDzEn5ZcU0xvzxjGvyv_gKTQm1HyD7YX
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2022 12:51 PM, Parav Pandit wrote:
>> And I'd like commit log to include results of perf testing
>> - with indirect feature on
> Which device do you suggest using for this test?
>
You may use software vhost-net backend with and without fix to compare. 
Since this driver fix effectively lowers down the buffer size for the 
indirect=on case as well, it's a natural request to make sure no perf 
degradation is seen on devices with indirect descriptor enabled. I don't 
expect degradation though and think this patch should improve efficiency 
with less memory foot print.

Cheers,
-Siwei
