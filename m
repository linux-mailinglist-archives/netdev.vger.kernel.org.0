Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8725847DF
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 23:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiG1VyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 17:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiG1VyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 17:54:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A3CD74CF6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 14:54:16 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SKJ3u1011130;
        Thu, 28 Jul 2022 21:54:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VSBymVTOCk1ck3sKx8nWRMvV+S4tDc9wTmyO5E6BdVM=;
 b=dF25E73wm4CkITkO5T2N566l5JfqHa4sNZNTnuvbhzrbPWt+rPy32lZXgdF5Izuwq03H
 hrW0glfWCjrqsJbwBEI13tCDtuXpJralb9XFe3QthMVLSb69dtENkFk6CEGgwMDoxonb
 xh8sjDb2sD/qXF+Md+FpkfjDhzeoZ7agYK5g6nTZAQPy4+mR4KyFhtelTZgQX7X7fHwu
 6KnxFZLtd1YSNjSqHOSPtf3Q17YDNDSBnT9gP6K8aWwm7kB7RB0WM5N31JjkcPCPgRcR
 kky1tq0LjIhhbyPuxto1CGcHexEi5Z+zHev7YIYm0ge4z05pcTX6mELUO1W+8dAFsVEF mg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9ap5b6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 21:54:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26SKUt2d006173;
        Thu, 28 Jul 2022 21:54:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hh65eq8k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 21:54:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxS6gZPh7GxHo3nlnruaxmd9xW8eTN1pYkTjF5clHGgmnm0V9T1MCrIVgKAVDoV3swzCK1d5a4dQH/UIHX+SYrb7VgkHcwx+KRK9MmuzV3EN45rmR/C84L8aE+8Wr2SmamJKC/HGq0REQLiIPwqYatfr+cbfhiG4ZuicO7n0Yn5lRGSFQvDQUCFHMDLjLW3ADDbMPs8pYuCR1OiGfS6fMpI+37M1oJdEqXHpdaLcy3vk7k2rCo7l2/d+r5v01wJtuXnxrQ5FdeqyxPIA2dhFu5Mui7qUEicwa1RV4dsHw8QgSuWNxKhVXUbgdJJTxK1p3q9yZWW3IjhLwDJ1O6Dy8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VSBymVTOCk1ck3sKx8nWRMvV+S4tDc9wTmyO5E6BdVM=;
 b=E2I1m1Yo70w8yeT5S9qyueMfafhVylUGvtCFAs+ojFe/YlCmDYWOUBX3LRJeZwLc0y1nVxPhqvQ3kxpoXkvRKimTUl+yDk8zS3+ViqJqhcAtMw5AMCgqqMzJS5YEUOpkp9Zhgh+qpus44wPrnhOpY8UCu0bYQZnmq/TxDjyKfMzuft2geHR5sb57PVyrFvl5vm5CDhO4jm1wJlPF2wqPgh3Rx3Gw/etQhgTOdoJB5yBzV5MUqntOajzPlQtI5RnAsR3WXgOeDh9z2gbgsHFsYcwQ3sDyTKwqlYWQfo5VgZfcBynIpcERp+cZLIdUBxvd85m5cuAXnc7JmOfK0JLw9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VSBymVTOCk1ck3sKx8nWRMvV+S4tDc9wTmyO5E6BdVM=;
 b=RJ1jQWONK2nAt6ncSDDoLNVpulQhN5bBRiA2w+nhL+FuAgnTJPoscfMLv9sydFaWc2LuVgc/0O/+bUQcuixYvf3Z44XNQ5LwbCD9VW7TMXhNr+5cpM8yhqaW4j5wVNhu1qyXX/pxazYUqIgsguRJFdlmu46F1zsOaynBR4EdDDw=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by DM5PR10MB1644.namprd10.prod.outlook.com (2603:10b6:4:f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.19; Thu, 28 Jul 2022 21:54:07 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803%4]) with mapi id 15.20.5458.026; Thu, 28 Jul 2022
 21:54:07 +0000
Message-ID: <41ae3d6a-664a-0264-0c60-a6743c233f19@oracle.com>
Date:   Thu, 28 Jul 2022 14:54:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Content-Language: en-US
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com>
 <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com>
 <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com>
 <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com>
 <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org>
 <66291287-fcb3-be8d-2c1b-dd44533ed8b3@oracle.com>
 <20220727050102-mutt-send-email-mst@kernel.org>
 <6d5b03ee-5362-8534-5881-a34c9ea626f0@oracle.com>
 <939bc589-b3ad-d317-8b1d-6da58e4670c0@intel.com>
 <e546e6c0-37bd-ee3e-76e5-def63a33f432@oracle.com>
 <685241b9-3487-489c-2784-2a2209f660ad@intel.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <685241b9-3487-489c-2784-2a2209f660ad@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::21) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1b0a735-86ea-45e4-409a-08da70e3b1f7
X-MS-TrafficTypeDiagnostic: DM5PR10MB1644:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bch4R9ey7YrE1EMeImJ0jR0YMVNasi1as8pOKMP00E8YE6kO6+qsiPrEKEtWCetC0f+vWgUBa7Cj/+ugA8+5BjL81aYCgo6RcEfYlLZN2aBc7Rm1uXRGM7zyqtC66PImI6OKZqclbzQzmhIdieU8f3zVJw3Y0yJLCP0BIZnX2mYBXB4yF2h2y8fMta+Uk8cV4WFUPeYvHe07UWlawx9+aly2+Bexx+/2Krx0IG0/Ni2RJJEyWqCMhphtHzEtpI+nIdt6Cs8JKB9cEuyOFYmdIRWKuDl/u9whMDbtU7YHKwwM+LFsFB8a09vcDKmZkOa4E3w6ryeJSGJ7hriF4k9ifCZF/Hl5CwrjdpVscOUCyodwiPpVjD0Z7V5EoJQbu9JHWslzPYYmCfgyCuXy4W789YHoHqwwSNvXG728vZZWnDL+aWLtQeI7rYw4xHh5l+4MmHhx+Xb48jgesSXMcYBJiHU0DqAlzVq9iF2OKpec76EYUUlJSlYbaMDqaaZcVZxT8p/y3vQGMzUrEaAoOeeuVAX3qUlI+UlSIguHxQpB5+dknRFkUzcA6sMBe1pQz7yqDgEWpl/57sTsgiy8Zw1FKYUY5RJJhWVQIDMKM2eztxetUwNby/U5dp86FNWDDpIsnxa3FOyFKzlxz+s9LRRtd81kpiIsCpwHGzsBqvfiw8oFsMkwXpgiKYAuDWykIN5Xpyydh60f6R86BzqLkREFD8sDgfyzdtJ9e+dx6zrTIrQQ4/fltiZDZ9foTnBk5NA8FBOjgDaGCWhOLObf7RH9A5YmJ3YsnXMlXRGf4NKoR1l76+BdKMP9lQwLLPtRa9EoxiMM3YpafwY/PITh7jFE3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(136003)(346002)(376002)(39860400002)(6486002)(36916002)(26005)(53546011)(8936002)(6512007)(66946007)(66476007)(6666004)(38100700002)(4326008)(316002)(8676002)(2906002)(5660300002)(186003)(6506007)(478600001)(41300700001)(66556008)(31696002)(86362001)(36756003)(54906003)(83380400001)(110136005)(31686004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THk4NHo0S2xobkJ1Q3M2ZnVicjFFb2ZrelZBdlFkNDRLcjFOQU9ycGxhQjBJ?=
 =?utf-8?B?M2xheVVyZkdkWVUrd1ZydjRmcCtJaDRlbGNralU0V3JvS3dPT2hwSnVhOHAz?=
 =?utf-8?B?cVRoQi9UMHJ6dGw3djJIcTYwS3ZHRCsxSElHMnNxRm4wNzkyQlBRUnpWcEF6?=
 =?utf-8?B?VWdjVWhsekVXc1lHV0VBZDZrdWsxazRpZzdQbFVwRFJhL2hvZ0lsTEpzYTdX?=
 =?utf-8?B?UmRqTDI4M3RTS3VWaC9SWUxSUzJRcm1zTDBXMzFDcnVXSkRZOWxKYjJpOTZQ?=
 =?utf-8?B?cHFBRThqNW9xMzlZVzV2ZE82Q2J3QXRxQ0EyejlSSTJPK05UVVNKakJTbkpU?=
 =?utf-8?B?bDk3OTJXanVPZUpJK0dyaGFzcTRQMU8wcmNaYzFqTDBzSzgraDdmNFgrTEZV?=
 =?utf-8?B?QXpFRSthTStqK2VXaFdpSnU3VlRMSis2MDc5d0FGY0ZlTkYzYndYbU40a0xM?=
 =?utf-8?B?N0toRWhEZnVtREtYeVkyWEc5VGRVY0tGMng1Y05kbkFMTmczV2k0SWtWUlNh?=
 =?utf-8?B?SmdVYlFJd3EwclZFYkM4dlJ6SnBEVVV5aG5sTFBsTEZpRjlXTUh2ajE5MnlN?=
 =?utf-8?B?OGZ0aGZVb3ZCOUxIVmN3Zld4UEJld0RsMDkvdlRiQkFxWWZlZkJVTUt6bFpx?=
 =?utf-8?B?RjdQWVR0TVVwMUNySWJidmZRSzJwZDIvN29sQ0t6MUhhcU91WWxBUnEybnl3?=
 =?utf-8?B?UTh6YWQ0bTZkUGJxTkhFbFhld0VYbkovUVVWeVhVZnpkeUZqVmdNbWR3ekNu?=
 =?utf-8?B?NU9jaDhtRGNZZ3AzeTBIK1FZSFlOL2U5K1dBUzRNcGxxUzBpNXhBWEVRRUVO?=
 =?utf-8?B?R2ZXdVJERThtTURIN1M3VmJvNG5QaDlibXhMYjlKS29iOGpzdUFuRkpnMDl0?=
 =?utf-8?B?MHlYRGtXYlovOXhpZkxpTTF4NlBMNWNUZzB3NFlVQjFabjE4cG5PRDhlYTNB?=
 =?utf-8?B?Q3NXV1J5NlFWbVRBeHpTbi9rSDZHZ3pXanhzNitnUzRBc3FtZTVyQk9TK3l5?=
 =?utf-8?B?WVU3bGFUMExoSHZKR3ByL3k2dUcwK3J0T1VmODNDTDU5eWgyM2ZzRnVTeEhF?=
 =?utf-8?B?amNVNFJ0SVgvODBMbUxOUkx5d0gvSGRWdGdlZkE0OEpNa3ZKeC9LYmZvSGsy?=
 =?utf-8?B?MVIxSFB0b2FPaDFtalFWbFloejBPdXphcDVEMVh3L2szNnROSHVSK0FMWlls?=
 =?utf-8?B?T3FXUFNYaTU5bFpWajlmZTZZazFMbjhPU3IwSTJGZStnWGlneiszam53Y3pD?=
 =?utf-8?B?N2pOSDVyV2ZjMHlDdmU1bTZTc29pVkhrMU1MQVlJV1RJQVJHSnM0L25tY3NQ?=
 =?utf-8?B?Z0ZQRTh1aDJwVi9oUkUvZHl2bkxHd1JKbTB3ZU0rTCs2YU90RTJacXNtVEdQ?=
 =?utf-8?B?UGZTRnFwNEdIdlVmVTFWbzJsTFlFZ1FQdzI5MlpROTdGL2RKNDFLSTBaYmFj?=
 =?utf-8?B?RmYzYUgyZEMrU2p2cmRkS0pkRytjZFV2NlliVGgrd2I2NzUrNWU5SWFSaG9X?=
 =?utf-8?B?cVlhUkhENEJlMG9NcVhUNWhweUdOS0pUMEJPTEphWjYxN3BwMmhLRGFLclJI?=
 =?utf-8?B?cTZxc1cxdmdBbnVQUndEWTczdWRrU0RwT016a3laamV2MkZvVGUzWlZ6N0Mx?=
 =?utf-8?B?VlBzV2pRU21uZXhzT212STBuZGx2TnUwTk94OTgrT2kzMzNvUWpqaFp5Mjd2?=
 =?utf-8?B?cG5Fa2VERDVVVDdWeTFVcTZzd2diMi9PbUNQaWRzZnZZekJ4Ty9oMHZQRlFu?=
 =?utf-8?B?NER0dS8rYXFNWkFkMU1YYjVhazZFZ2w0V3JTcFRQWTlKVWFPazRGOCtId3JH?=
 =?utf-8?B?VHNsUCtCdWpybDBEUFNMRm03T1MrSlpiSnAvdGVBMFpDVWhaMk4xaFBiWktD?=
 =?utf-8?B?eHNIRlErRVA5eWZzSUVBQnNLQ01vSU9Ra1BJcDlqSFJOYVcveTVVb0lZTWJC?=
 =?utf-8?B?bnUzd3lUWG9maStxU3FHK3lDMnJtVTY0VWt4MHVlbFJnYk8zOFAydGZ3bWpE?=
 =?utf-8?B?QUJ2VU5uMkxWRk53NCtjTUlzU05KUmdGeXp4eU00cDN2OFhsSzJnNVVPbWQv?=
 =?utf-8?B?ZDlEb1FtTVc4eC9YajZ0UkZTdmlxYU1jbmFseFZidFRzbGVJb3I5V3o0UzRs?=
 =?utf-8?Q?ERjr4Pf2RtzoGfEiCydW/yYtl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1b0a735-86ea-45e4-409a-08da70e3b1f7
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 21:54:07.3723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j08XrWWVzMMxaHW/f/XTYgPTFFkEi0pDWaGXBvnLhZBQgvUVgtaIPs6rh4CzV1J5SzUNvbnBFrYbGgJB3CWgKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1644
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207280098
X-Proofpoint-ORIG-GUID: LW1pPoiSL5nfYPDUQNjFzzftyYp1jVrq
X-Proofpoint-GUID: LW1pPoiSL5nfYPDUQNjFzzftyYp1jVrq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2022 7:44 PM, Zhu, Lingshan wrote:
>
>
> On 7/28/2022 9:41 AM, Si-Wei Liu wrote:
>>
>>
>> On 7/27/2022 4:54 AM, Zhu, Lingshan wrote:
>>>
>>>
>>> On 7/27/2022 6:09 PM, Si-Wei Liu wrote:
>>>>
>>>>
>>>> On 7/27/2022 2:01 AM, Michael S. Tsirkin wrote:
>>>>> On Wed, Jul 27, 2022 at 12:50:33AM -0700, Si-Wei Liu wrote:
>>>>>>
>>>>>> On 7/26/2022 11:01 PM, Michael S. Tsirkin wrote:
>>>>>>> On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>>> Sent: Tuesday, July 26, 2022 10:53 PM
>>>>>>>>>
>>>>>>>>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
>>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>>>>> Sent: Tuesday, July 26, 2022 10:15 PM
>>>>>>>>>>>
>>>>>>>>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
>>>>>>>>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>>>>>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
>>>>>>>>>>>>>> When the user space which invokes netlink commands, 
>>>>>>>>>>>>>> detects that
>>>>>>>>>>> _MQ
>>>>>>>>>>>>> is not supported, hence it takes max_queue_pair = 1 by 
>>>>>>>>>>>>> itself.
>>>>>>>>>>>>> I think the kernel module have all necessary information 
>>>>>>>>>>>>> and it is
>>>>>>>>>>>>> the only one which have precise information of a device, 
>>>>>>>>>>>>> so it
>>>>>>>>>>>>> should answer precisely than let the user space guess. The 
>>>>>>>>>>>>> kernel
>>>>>>>>>>>>> module should be reliable than stay silent, leave the 
>>>>>>>>>>>>> question to
>>>>>>>>>>>>> the user space
>>>>>>>>>>> tool.
>>>>>>>>>>>> Kernel is reliable. It doesn’t expose a config space field 
>>>>>>>>>>>> if the
>>>>>>>>>>>> field doesn’t
>>>>>>>>>>> exist regardless of field should have default or no default.
>>>>>>>>>>> so when you know it is one queue pair, you should answer 
>>>>>>>>>>> one, not try
>>>>>>>>>>> to guess.
>>>>>>>>>>>> User space should not guess either. User space gets to see 
>>>>>>>>>>>> if _MQ
>>>>>>>>>>> present/not present. If _MQ present than get reliable data 
>>>>>>>>>>> from kernel.
>>>>>>>>>>>> If _MQ not present, it means this device has one VQ pair.
>>>>>>>>>>> it is still a guess, right? And all user space tools 
>>>>>>>>>>> implemented this
>>>>>>>>>>> feature need to guess
>>>>>>>>>> No. it is not a guess.
>>>>>>>>>> It is explicitly checking the _MQ feature and deriving the 
>>>>>>>>>> value.
>>>>>>>>>> The code you proposed will be present in the user space.
>>>>>>>>>> It will be uniform for _MQ and 10 other features that are 
>>>>>>>>>> present now and
>>>>>>>>> in the future.
>>>>>>>>> MQ and other features like RSS are different. If there is no 
>>>>>>>>> _RSS_XX, there
>>>>>>>>> are no attributes like max_rss_key_size, and there is not a 
>>>>>>>>> default value.
>>>>>>>>> But for MQ, we know it has to be 1 wihtout _MQ.
>>>>>>>> "we" = user space.
>>>>>>>> To keep the consistency among all the config space fields.
>>>>>>> Actually I looked and the code some more and I'm puzzled:
>>>>>>>
>>>>>>>
>>>>>>>     struct virtio_net_config config = {};
>>>>>>>     u64 features;
>>>>>>>     u16 val_u16;
>>>>>>>
>>>>>>>     vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>>>>>
>>>>>>>     if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, 
>>>>>>> sizeof(config.mac),
>>>>>>>             config.mac))
>>>>>>>         return -EMSGSIZE;
>>>>>>>
>>>>>>>
>>>>>>> Mac returned even without VIRTIO_NET_F_MAC
>>>>>>>
>>>>>>>
>>>>>>>     val_u16 = le16_to_cpu(config.status);
>>>>>>>     if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>>>>>>         return -EMSGSIZE;
>>>>>>>
>>>>>>>
>>>>>>> status returned even without VIRTIO_NET_F_STATUS
>>>>>>>
>>>>>>>     val_u16 = le16_to_cpu(config.mtu);
>>>>>>>     if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>>>>         return -EMSGSIZE;
>>>>>>>
>>>>>>>
>>>>>>> MTU returned even without VIRTIO_NET_F_MTU
>>>>>>>
>>>>>>>
>>>>>>> What's going on here?
>>>>>>>
>>>>>>>
>>>>>> I guess this is spec thing (historical debt), I vaguely recall 
>>>>>> these fields
>>>>>> are always present in config space regardless the existence of 
>>>>>> corresponding
>>>>>> feature bit.
>>>>>>
>>>>>> -Siwei
>>>>> Nope:
>>>>>
>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>
>>>>> ...
>>>>>
>>>>> For optional configuration space fields, the driver MUST check 
>>>>> that the corresponding feature is offered
>>>>> before accessing that part of the configuration space.
>>>> Well, this is driver side of requirement. As this interface is for 
>>>> host admin tool to query or configure vdpa device, we don't have to 
>>>> wait until feature negotiation is done on guest driver to extract 
>>>> vdpa attributes/parameters, say if we want to replicate another 
>>>> vdpa device with the same config on migration destination. I think 
>>>> what may need to be fix is to move off from using 
>>>> .vdpa_get_config_unlocked() which depends on feature negotiation. 
>>>> And/or expose config space register values through another set of 
>>>> attributes.
>>> Yes, we don't have to wait for FEATURES_OK. In another patch in this 
>>> series, I have added a new netlink attr to report the device 
>>> features, and removed the blocker. So the LM orchestration SW can 
>>> query the device features of the devices at the destination cluster, 
>>> and pick a proper one, even mask out some features to meet the LM 
>>> requirements.
>> For that end, you'd need to move off from using 
>> vdpa_get_config_unlocked() which depends on feature negotiation. 
>> Since this would slightly change the original semantics of each field 
>> that "vdpa dev config" shows, it probably need another netlink 
>> command and new uAPI.
> why not show both device_features and driver_features in "vdpa dev 
> config show"?
>
As I requested in the other email, I'd like to see the proposed 'vdpa 
dev config ...' example output for various phases in feature 
negotiation, and the specific use case (motivation) for this proposed 
output. I am having difficulty to match what you want to do with the 
patch posted.

-Siwei

>>
>> -Siwei
>>
>>
>>>
>>> Thanks,
>>> Zhu Lingshan
>>>> -Siwei
>>>>
>>>>
>>>>
>>>>
>>>
>>
>

