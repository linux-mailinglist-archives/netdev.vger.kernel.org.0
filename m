Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FE4587427
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 00:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiHAW6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 18:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiHAW6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 18:58:33 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0DA2A421
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 15:58:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 271MEYiE028814;
        Mon, 1 Aug 2022 22:58:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=jSPhfCb0Oo0n4x7SdqObcERl+zwiTznF2KAzqKgvF3Q=;
 b=o5dHpbGjToy8ZlIGhYcjrsAlKOTh6ljNNAYHGFFAKEJ4tViOkZ+g5b0frhh+BjAn/ulD
 807ATFvNlv6CINiCGOpcQVquAODtIftFC+dwgSjzuS/ILxzwnFSj4LwLNC6tWwjOMS0G
 cWBFNIlvNjg8bWjZMSAM95apLb4apvbfsy6CVgSr8Hf71wYj253yE4TVBcPV24ffxD03
 lF4bg5/k+5etwPvaXVehGNFKSx4NjS+dfaRc6OahJg/rMia0OvpO66mFi6X/mOnp3sv8
 fn9Ps5Fn2ccNvGrGPy4qsszXAJv+POyS7J039M9H98nAvGDAYEPxHQgF1B4R7hA6bokp Zg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu80w6a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 22:58:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 271JqOWK010847;
        Mon, 1 Aug 2022 22:58:25 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu31q1qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Aug 2022 22:58:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hi9OlOZmtXyKiiX96IQmQZelM4NQx8jxZOoW1deGd4vscTx+qf78b45JMxxYV6KQ/pdz3ajN82CuewSyCj/b4zWUH3SXkVrywBn7f19THwIUeaJ5EM51Y59SjfsMZDFhb3vCd7qo8GAVXvwIg0+P0pEFr0I8qZZNgPrCasz6a1Oj3srFbb7Wq6SVwOXKKy0ZfM4pHFUvKbLOjOTmN6sNercskBXtmgNcpQJfXyNC6EvLLBwGzxpESZ4Y0mCV/a9DVbIndI5iQJzMNgIrp/wzhv4+o6tZtSuXZzgRla4UoiHhavenHh96YsA+t6X30j0L33oRXnpg5turopQufwWo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jSPhfCb0Oo0n4x7SdqObcERl+zwiTznF2KAzqKgvF3Q=;
 b=IS18Ssyjwqn96r/GiFgff7eo2ycn+Az1795PggRHHMjPd/jgN7Z0L+24Ykk8GqQ64uuUoW3qpCbbFG9wQSz/awlCKycA7Yz2c9kj6bADlHKbv0lDvHat1n6i9j0Oz+ll5YDeg+DsHS1NwDYGKfcDL2OIYw9DCpOMu1kx2y8oQ6+Pfxpn25YKFr7sXW3wB8o2KkgUKJOhHCNSGcE8o52eitPqTlVgCtQ/7X1xGoU6TAgx0+0E8GnHNnZ79HhCk4c5nV3OC0NxExyAV/VZJ0VIKbf+o98qdGChGUTGjN27L3FporlWVaCXje4B5CRuPuWJpZ0DI3kxtPeqFTEWIfZ59w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jSPhfCb0Oo0n4x7SdqObcERl+zwiTznF2KAzqKgvF3Q=;
 b=DvkUCxWPGEJAy4P1DvetYC1mcwfnPGYvtNxLqnrIMb8uVsGn0ANsTLbv2gHvI/IHkC9nrwe//RrxTI8BHVgO9DKL7xmUbqCsOgcASMheSOIa4cvolmVSnEd2ho6e04ns6V/1SBhgXYm3cFVQO8JeOTIxdEv4PkDWzqlsjuynP/M=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by SN6PR10MB2654.namprd10.prod.outlook.com (2603:10b6:805:40::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Mon, 1 Aug
 2022 22:58:22 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 22:58:22 +0000
Message-ID: <c77aa133-54ad-1578-aae3-031432cc9b36@oracle.com>
Date:   Mon, 1 Aug 2022 15:58:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
From:   Si-Wei Liu <si-wei.liu@oracle.com>
To:     Jason Wang <jasowang@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-5-lingshan.zhu@intel.com>
 <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00889067-50ac-d2cd-675f-748f171e5c83@oracle.com>
 <63242254-ba84-6810-dad8-34f900b97f2f@intel.com>
 <8002554a-a77c-7b25-8f99-8d68248a741d@oracle.com>
 <00e2e07e-1a2e-7af8-a060-cc9034e0d33f@intel.com>
 <b58dba25-3258-d600-ea06-879094639852@oracle.com>
 <c143e2da-208e-b046-9b8f-1780f75ed3e6@intel.com>
 <454bdf1b-daa1-aa67-2b8c-bc15351c1851@oracle.com>
 <f1c56fd6-7fa1-c2b8-83f4-4f0d68de86f4@redhat.com>
 <ec302cd4-3791-d648-aa00-28b1e97d75e7@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <ec302cd4-3791-d648-aa00-28b1e97d75e7@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0230.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::25) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7a30fb0-dd53-4084-b3cb-08da74115579
X-MS-TrafficTypeDiagnostic: SN6PR10MB2654:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KkrXB16PzHzJCFXL51YQ/4Av9SPdTvgNNwH6P3PO/M/0jLHL8Zx//K8rf9/eNs1keEJuPWfL4Y8NqkQaVla6eF37WppRwwZLyjPzSdlDcBF5Z2bycrAb4Wyp2Ik4bgw3pbPq9mqEexg2g7oywVZ7WEvgbKizrdEL7eMpdkfOyi7i32DUvgBpDQd2/EHg4MMbTuzsh+Ucc19LXTathgy1zbV55thnERN4/sYbQ1Db3Uzg6Is6hf74nWg+VaSDjVWVL67OCh2zR3EAYrLeuxCHKwLQRQnvlLy1BTy3l8mO1EURbXmQ1t2xjZ68vVQTt+SEASXspXCjQ8FtlAEeIrqgd6hZMaHkbnhyFeFF6rtydz7OpR3fqXbgZB57whDGuOy1nkivYeWVdujQYhPilV5XSmfPGFWF086mjxMOT3sR9mJiKwMa9Ls9Dc/+6QT+L5qGrYYGyuYQKslCK/7c0TMNsOwLHJh1mSTFcDTVQuFveceNKdOnMFLFdLI3GrBMCA9ppDcb7odLLSL4xNXMlw2ORyITvQLGE5ASVhwuRKLqQxpW09DA92FMdVHSEZu8+mRaJC3tatn/sodFoQVHyvKSuGPMi8cKxIb6WmV7TEAIUkaYkRgsW/2oYL3+yhl76syQCjJ03k9l8yhPE2QuiJlIiZBc0mqm6jrS9uTw6yP0Qh7kXtMjk9iNh6w3NqOq64VPl/pEBrwQe18PWbtO4RC8lSPpbM1JVXJneW5svfa17gTCz5FVYBPFwkzAJYVXWUYpOxdNBKFDU5yGMd3HYbMGIOMcN21U+qhmwzm+5TKSZKvjVWklKTZ/wpC6Z9lHtd8QhbZKCKyNIrv6MptdQ5quknlTtBJriXO7KiQ/SyeHuwk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(366004)(346002)(376002)(39860400002)(53546011)(6506007)(36916002)(31696002)(86362001)(6512007)(2616005)(26005)(5660300002)(478600001)(966005)(6486002)(2906002)(8936002)(30864003)(41300700001)(4326008)(186003)(38100700002)(83380400001)(36756003)(54906003)(110136005)(66556008)(8676002)(66946007)(316002)(31686004)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3ptTUVyLzU2RDF5dWlOK1JReVNCWUswN0IvdlN3cnRobVVFcXJrdXozQ0U3?=
 =?utf-8?B?RFZzQnV6RGdMQlRFeE1TZkRuRG5nRlBsR3pzWDlZck9zWmlUSDlCYXBEdTFr?=
 =?utf-8?B?eVVVREl3NTZBdTdLTVgzZWhxWUFKL0liWG9PdjFCelNpOGNuZEdNajZkRFVq?=
 =?utf-8?B?K0l0emVzZWEwdFljZmtRTXlRbVZxVWdsbHRWa0J1aFFpcGdjV1dXczBmM1Ew?=
 =?utf-8?B?ZUd0dFRQd1g2S3dFQlFjT0Y0bUM2NUhCWUZ0S2Q2NEJ3OGhuVEcyeEZ2SzEr?=
 =?utf-8?B?NTNOUnJ3d3p4ZXJGeGs2T2p0QVgxOEsxQkxreUNGUTVsdndqb0I0aUw5dXFt?=
 =?utf-8?B?dTVqM2hGZzdWUXpiQXE1UEloeDJwQmpWWjNLd2x5RUZRcW80RFN2S3V6Y2U3?=
 =?utf-8?B?ZzM5R3h5U05wTjN4dDBCb0lHUDl0TDNVcHRJeWxSTXZBQ2JKRXdYbzd4MXpN?=
 =?utf-8?B?d0h2N3ZCakFOajBETEloY3RpaWlabkY1eDIzcFlVRGtMWGR2VDMyTFF3Z0tX?=
 =?utf-8?B?ZjZ0dkRsbVRtZzJJSGU0d3dBQnZFWHNzMjBIY083N0c2Ym03Q3JMK08weUdJ?=
 =?utf-8?B?NEU3OThWa1hoaExQMzQ0NTExZ1IvemxVNktoZld2OGJLeE5jSzlkNGd4YWI2?=
 =?utf-8?B?dmxpMHZrcGF4YVRLMDEvRDYwTWJLUzNxMmpqYWJXcjdSZzVjT01TRnVKeVdI?=
 =?utf-8?B?Q2JhZ0FlTjUzTDIzalRuYmVWMEdhbzBUdDFZN1RSV0pGaFd6MyswcHgxZGlI?=
 =?utf-8?B?SlhRelJmTzZjREdvR2EvUGlyS0luVytGVGl3T2ZnWDZ2bkJLOWVjMCtBZGZF?=
 =?utf-8?B?OU5tZUN5VnkvTWFaY3FGS0dFam9Tck9nL2NtVUlpNzQ4Vlc4cmtsVkY1MEo5?=
 =?utf-8?B?YmlkWVVFeTVSN1VKR3p0aGJjYkJBL1cwMXh6VTlSN3JJbndBRWxLak0xVmlz?=
 =?utf-8?B?a2NZeG5JMVdqYmtqVFlXcXFzQnd6T2hXRDkzNng2VzdBeVBTRVZjeWxhaXdr?=
 =?utf-8?B?M1NmMlJ3eE5yUFJJZjBRQUxMQXFEVlpwOERsazNqRVhTMU1DVG82bmFRKzZ2?=
 =?utf-8?B?eXk3RU01U0ZPVnZLY0c2Ri96QkR6KzM1TnhjM3JnSE5hZEJXYWpTVkdXbHFK?=
 =?utf-8?B?SDhmRHk1aDRsVFY1VGQ2K0o0NlQ0cnkxa2tqSUttaWJvMlNNUjJNZ1NFUUxy?=
 =?utf-8?B?djdXWjdlWmV5UHY0Z3FoVlFWTkhDMThaVVpRM3k5VTVCU2I4RzhpMDBtUjk0?=
 =?utf-8?B?M3gvR1hXT09DaFRwUVpkQkhnTytkVFRWK1htdkFYQVZsUG1pV2JNMVdlWW01?=
 =?utf-8?B?UUxHTzd5RnQwaTM5NDdFRXNNS3BtR1VTSEl4OHVDY2k1c3VTandqSjR3eWx5?=
 =?utf-8?B?OTZKNnkvR3hrV3JLSmsrK1ArMUdJUmE4MldacU5aWmVFQWx4ZmRLZlI0TzFP?=
 =?utf-8?B?SFNwWGljYjNCY2srbUpwNVVXMFNua3BzUWE2MW5kK0FvZTRsVzJhdGhOQ0RQ?=
 =?utf-8?B?MU5CTXQvQmxrS2lkM2RwSW9hdzBUT2FvSmZGemxLdVhSektyVTdXUWk4V251?=
 =?utf-8?B?Mlg2bTVWemdBWWVQL3J4cmowZnBvSkhqdFdKQXZMQWZ3OUxWRGZoanFRdWd6?=
 =?utf-8?B?R2NTS3FwZ24wdGVCc3FyM1hMekplbnlRVkhSUzhqOGViWEk1MFc2dFNsVnFI?=
 =?utf-8?B?NDNQTEJuLy9WYVEwQzd2dnZlNW5WajZEYjVnRkNEanpYSnU5TUZnWUNjRkFv?=
 =?utf-8?B?V3IvZDF1N3QzWGxGTkRlWHdOYUJ4akVMSERTOC9EanI0bHNBQVBHL0sxM1U4?=
 =?utf-8?B?WE5LSC9CaXk3NlVpZ05JanRvRnlPS1c5eEhOVEczb0svQmpkVzhDOTVFcVFU?=
 =?utf-8?B?T2VwODVTZlg0bkkxMnQvOWx4MmtwMU0vc2dlSDlybkdzYUxUZFk0bXJERUc0?=
 =?utf-8?B?SE5EQm5RZVBKUWFEU2llcXo5bjhCVU10K3IyRWhJampVT3l2TnZDcEpGVk82?=
 =?utf-8?B?QnNiVnBnSEdoTWYvNnA2dWFHeEVVQ0xaeW1IY2Q2bW96K0I4eFJkUjNtSUJZ?=
 =?utf-8?B?bWtheERmOWdsRjNIUW9WUkdCMkx5NGtNNTZNRlBrTVY1YUlubmNTVlNmZTNY?=
 =?utf-8?Q?+yBuRzwo6bv35hAytYUFJro1V?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a30fb0-dd53-4084-b3cb-08da74115579
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2022 22:58:22.4745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ewWIQyKqpJHnCMDD7Q40a7ZJkFKx/HCAGxyyY5SDuJvarBw8RNDTfPn2iQMwYBeM4tD4KjuNqGzTE3kAxeyI3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2654
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_11,2022-08-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208010116
X-Proofpoint-ORIG-GUID: OKej-driv1ur_uLZidaURjTmu2qKta9h
X-Proofpoint-GUID: OKej-driv1ur_uLZidaURjTmu2qKta9h
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/2022 3:53 PM, Si-Wei Liu wrote:
>
>
> On 7/31/2022 9:44 PM, Jason Wang wrote:
>>
>> 在 2022/7/30 04:55, Si-Wei Liu 写道:
>>>
>>>
>>> On 7/28/2022 7:04 PM, Zhu, Lingshan wrote:
>>>>
>>>>
>>>> On 7/29/2022 5:48 AM, Si-Wei Liu wrote:
>>>>>
>>>>>
>>>>> On 7/27/2022 7:43 PM, Zhu, Lingshan wrote:
>>>>>>
>>>>>>
>>>>>> On 7/28/2022 8:56 AM, Si-Wei Liu wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>>>>>>>> Sorry to chime in late in the game. For some reason I couldn't 
>>>>>>>>> get to most emails for this discussion (I only subscribed to 
>>>>>>>>> the virtualization list), while I was taking off amongst the 
>>>>>>>>> past few weeks.
>>>>>>>>>
>>>>>>>>> It looks to me this patch is incomplete. Noted down the way in 
>>>>>>>>> vdpa_dev_net_config_fill(), we have the following:
>>>>>>>>>          features = vdev->config->get_driver_features(vdev);
>>>>>>>>>          if (nla_put_u64_64bit(msg, 
>>>>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>>>>>>                                VDPA_ATTR_PAD))
>>>>>>>>>                  return -EMSGSIZE;
>>>>>>>>>
>>>>>>>>> Making call to .get_driver_features() doesn't make sense when 
>>>>>>>>> feature negotiation isn't complete. Neither should present 
>>>>>>>>> negotiated_features to userspace before negotiation is done.
>>>>>>>>>
>>>>>>>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill() 
>>>>>>>>> probably should not show before negotiation is done - it 
>>>>>>>>> depends on driver features negotiated.
>>>>>>>> I have another patch in this series introduces device_features 
>>>>>>>> and will report device_features to the userspace even features 
>>>>>>>> negotiation not done. Because the spec says we should allow 
>>>>>>>> driver access the config space before FEATURES_OK.
>>>>>>> The config space can be accessed by guest before features_ok 
>>>>>>> doesn't necessarily mean the value is valid. You may want to 
>>>>>>> double check with Michael for what he quoted earlier:
>>>>>> that's why I proposed to fix these issues, e.g., if no _F_MAC, 
>>>>>> vDPA kernel should not return a mac to the userspace, there is 
>>>>>> not a default value for mac.
>>>>> Then please show us the code, as I can only comment based on your 
>>>>> latest (v4) patch and it was not there.. To be honest, I don't 
>>>>> understand the motivation and the use cases you have, is it for 
>>>>> debugging/monitoring or there's really a use case for live 
>>>>> migration? For the former, you can do a direct dump on all config 
>>>>> space fields regardless of endianess and feature negotiation 
>>>>> without having to worry about validity (meaningful to present to 
>>>>> admin user). To me these are conflict asks that is impossible to 
>>>>> mix in exact one command.
>>>> This bug just has been revealed two days, and you will see the 
>>>> patch soon.
>>>>
>>>> There are something to clarify:
>>>> 1) we need to read the device features, or how can you pick a 
>>>> proper LM destination
>>
>>
>> So it's probably not very efficient to use this, the manager layer 
>> should have the knowledge about the compatibility before doing 
>> migration other than try-and-fail.
>>
>> And it's the task of the management to gather the nodes whose devices 
>> could be live migrated to each other as something like "cluster" 
>> which we've already used in the case of cpuflags.
>>
>> 1) during node bootstrap, the capability of each node and devices was 
>> reported to management layer
>> 2) management layer decide the cluster and make sure the migration 
>> can only done among the nodes insides the cluster
>> 3) before migration, the vDPA needs to be provisioned on the destination
>>
>>
>>>> 2) vdpa dev config show can show both device features and driver 
>>>> features, there just need a patch for iproute2
>>>> 3) To process information like MQ, we don't just dump the config 
>>>> space, MST has explained before
>>> So, it's for live migration... Then why not export those config 
>>> parameters specified for vdpa creation (as well as device feature 
>>> bits) to the output of "vdpa dev show" command? That's where device 
>>> side config lives and is static across vdpa's life cycle. "vdpa dev 
>>> config show" is mostly for dynamic driver side config, and the 
>>> validity is subject to feature negotiation. I suppose this should 
>>> suit your need of LM, e.g.
>>
>>
>> I think so.
>>
>>
>>>
>>> $ vdpa dev add name vdpa1 mgmtdev pci/0000:41:04.2 max_vqp 7 mtu 2000
>>> $ vdpa dev show vdpa1
>>> vdpa1: type network mgmtdev pci/0000:41:04.2 vendor_id 5555 max_vqs 
>>> 15 max_vq_size 256
>>>   max_vqp 7 mtu 2000
>>>   dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS 
>>> CTRL_VQ MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED
>>
>>
>> Note that the mgmt should know this destination have those 
>> capability/features before the provisioning.
> Yes, mgmt software should have to check the above from source.

On destination mgmt software can run below to check vdpa mgmtdev's 
capability/features:

$ vdpa mgmtdev show pci/0000:41:04.3
pci/0000:41:04.3:
   supported_classes net
   max_supported_vqs 257
   dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ 
MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED
>
>>
>>
>>>
>>> For it to work, you'd want to pass "struct vdpa_dev_set_config" to 
>>> _vdpa_register_device() during registration, and get it saved there 
>>> in "struct vdpa_device". Then in vdpa_dev_fill() show each field 
>>> conditionally subject to "struct vdpa_dev_set_config.mask".
>>>
>>> Thanks,
>>> -Siwei
>>
>>
>> Thanks
>>
>>
>>>>
>>>> Thanks
>>>> Zhu Lingshan
>>>>>
>>>>>>>> Nope:
>>>>>>>>
>>>>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>>>>
>>>>>>>> ...
>>>>>>>>
>>>>>>>> For optional configuration space fields, the driver MUST check 
>>>>>>>> that the corresponding feature is offered
>>>>>>>> before accessing that part of the configuration space.
>>>>>>>
>>>>>>> and how many driver bugs taking wrong assumption of the validity 
>>>>>>> of config space field without features_ok. I am not sure what 
>>>>>>> use case you want to expose config resister values for before 
>>>>>>> features_ok, if it's mostly for live migration I guess it's 
>>>>>>> probably heading a wrong direction.
>>>>>>>
>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> Last but not the least, this "vdpa dev config" command was not 
>>>>>>>>> designed to display the real config space register values in 
>>>>>>>>> the first place. Quoting the vdpa-dev(8) man page:
>>>>>>>>>
>>>>>>>>>> vdpa dev config show - Show configuration of specific device 
>>>>>>>>>> or all devices.
>>>>>>>>>> DEV - specifies the vdpa device to show its configuration. If 
>>>>>>>>>> this argument is omitted all devices configuration is listed.
>>>>>>>>> It doesn't say anything about configuration space or register 
>>>>>>>>> values in config space. As long as it can convey the config 
>>>>>>>>> attribute when instantiating vDPA device instance, and more 
>>>>>>>>> importantly, the config can be easily imported from or 
>>>>>>>>> exported to userspace tools when trying to reconstruct vdpa 
>>>>>>>>> instance intact on destination host for live migration, IMHO 
>>>>>>>>> in my personal interpretation it doesn't matter what the 
>>>>>>>>> config space may present. It may be worth while adding a new 
>>>>>>>>> debug command to expose the real register value, but that's 
>>>>>>>>> another story.
>>>>>>>> I am not sure getting your points. vDPA now reports device 
>>>>>>>> feature bits(device_features) and negotiated feature 
>>>>>>>> bits(driver_features), and yes, the drivers features can be a 
>>>>>>>> subset of the device features; and the vDPA device features can 
>>>>>>>> be a subset of the management device features.
>>>>>>> What I said is after unblocking the conditional check, you'd 
>>>>>>> have to handle the case for each of the vdpa attribute when 
>>>>>>> feature negotiation is not yet done: basically the register 
>>>>>>> values you got from config space via the 
>>>>>>> vdpa_get_config_unlocked() call is not considered to be valid 
>>>>>>> before features_ok (per-spec). Although in some case you may get 
>>>>>>> sane value, such behavior is generally undefined. If you desire 
>>>>>>> to show just the device_features alone without any config space 
>>>>>>> field, which the device had advertised *before feature 
>>>>>>> negotiation is complete*, that'll be fine. But looks to me this 
>>>>>>> is not how patch has been implemented. Probably need some more 
>>>>>>> work?
>>>>>> They are driver_features(negotiated) and the 
>>>>>> device_features(which comes with the device), and the config 
>>>>>> space fields that depend on them. In this series, we report both 
>>>>>> to the userspace.
>>>>> I fail to understand what you want to present from your 
>>>>> description. May be worth showing some example outputs that at 
>>>>> least include the following cases: 1) when device offers features 
>>>>> but not yet acknowledge by guest 2) when guest acknowledged 
>>>>> features and device is yet to accept 3) after guest feature 
>>>>> negotiation is completed (agreed upon between guest and device).
>>>> Only two feature sets: 1) what the device has. (2) what is negotiated
>>>>>
>>>>> Thanks,
>>>>> -Siwei
>>>>>>>
>>>>>>> Regards,
>>>>>>> -Siwei
>>>>>>>
>>>>>>>>>
>>>>>>>>> Having said, please consider to drop the Fixes tag, as appears 
>>>>>>>>> to me you're proposing a new feature rather than fixing a real 
>>>>>>>>> issue.
>>>>>>>> it's a new feature to report the device feature bits than only 
>>>>>>>> negotiated features, however this patch is a must, or it will 
>>>>>>>> block the device feature bits reporting. but I agree, the fix 
>>>>>>>> tag is not a must.
>>>>>>>>>
>>>>>>>>> Thanks,
>>>>>>>>> -Siwei
>>>>>>>>>
>>>>>>>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>>>>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>>>>>>
>>>>>>>>>>> Users may want to query the config space of a vDPA device, 
>>>>>>>>>>> to choose a
>>>>>>>>>>> appropriate one for a certain guest. This means the users 
>>>>>>>>>>> need to read the
>>>>>>>>>>> config space before FEATURES_OK, and the existence of config 
>>>>>>>>>>> space
>>>>>>>>>>> contents does not depend on FEATURES_OK.
>>>>>>>>>>>
>>>>>>>>>>> The spec says:
>>>>>>>>>>> The device MUST allow reading of any device-specific 
>>>>>>>>>>> configuration field
>>>>>>>>>>> before FEATURES_OK is set by the driver. This includes 
>>>>>>>>>>> fields which are
>>>>>>>>>>> conditional on feature bits, as long as those feature bits 
>>>>>>>>>>> are offered by the
>>>>>>>>>>> device.
>>>>>>>>>>>
>>>>>>>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only 
>>>>>>>>>>> if FEATURES_OK)
>>>>>>>>>> Fix is fine, but fixes tag needs correction described below.
>>>>>>>>>>
>>>>>>>>>> Above commit id is 13 letters should be 12.
>>>>>>>>>> And
>>>>>>>>>> It should be in format
>>>>>>>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if 
>>>>>>>>>> FEATURES_OK")
>>>>>>>>>>
>>>>>>>>>> Please use checkpatch.pl script before posting the patches to 
>>>>>>>>>> catch these errors.
>>>>>>>>>> There is a bot that looks at the fixes tag and identifies the 
>>>>>>>>>> right kernel version to apply this fix.
>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>>>>> ---
>>>>>>>>>>>   drivers/vdpa/vdpa.c | 8 --------
>>>>>>>>>>>   1 file changed, 8 deletions(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>>>>>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>>>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>>>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device 
>>>>>>>>>>> *vdev,
>>>>>>>>>>> struct sk_buff *msg, u32 portid,  {
>>>>>>>>>>>       u32 device_id;
>>>>>>>>>>>       void *hdr;
>>>>>>>>>>> -    u8 status;
>>>>>>>>>>>       int err;
>>>>>>>>>>>
>>>>>>>>>>>       down_read(&vdev->cf_lock);
>>>>>>>>>>> -    status = vdev->config->get_status(vdev);
>>>>>>>>>>> -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>>>>>>> -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>>>>>>>>>> completed");
>>>>>>>>>>> -        err = -EAGAIN;
>>>>>>>>>>> -        goto out;
>>>>>>>>>>> -    }
>>>>>>>>>>> -
>>>>>>>>>>>       hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, 
>>>>>>>>>>> flags,
>>>>>>>>>>>                 VDPA_CMD_DEV_CONFIG_GET);
>>>>>>>>>>>       if (!hdr) {
>>>>>>>>>>> -- 
>>>>>>>>>>> 2.31.1
>>>>>>>>>> _______________________________________________
>>>>>>>>>> Virtualization mailing list
>>>>>>>>>> Virtualization@lists.linux-foundation.org
>>>>>>>>>> https://urldefense.com/v3/__https://lists.linuxfoundation.org/mailman/listinfo/virtualization__;!!ACWV5N9M2RV99hQ!NzOv5Ew_Z2CP-zHyD7RsUoStLZ54KpB21QyuZ8L63YVPLEGDEwvcOSDlIGxQPHY-DMkOa9sKKZdBSaNknMU$ 
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
>

