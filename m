Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212D6611E4B
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 01:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJ1XtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 19:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiJ1XtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 19:49:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FC62475CC;
        Fri, 28 Oct 2022 16:49:13 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29SKxQb1013284;
        Fri, 28 Oct 2022 23:49:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HjPZClMx7jBAgDUH+P5hHJfiVVVJrR33Nk5G5p1Y0Nk=;
 b=bPmzTklyGAofZAuIPjmUrOpk1wrFkL3xxMwOtr4H7QVat1ftReiektKP0atNTHMwu38U
 +HDosZrpEOz9GuB32ZnVlIwXBHVrDODWw/rPch9P8EEUmjGguDNW2QFv86GAbxF2gQDh
 JP47ak/wc6XCZ0WjJ5Ns50YBA7W1lnPkMohh6grCU8iPkhqKIL0wILo900h+S8k0jboW
 +u12awqrLykn2UYcMLOA/E7ALuoPXV3tTbd3pZgR68RVO2n2sIv75tKWrCJ7kq3glwpS
 d17MLfuTmZs0PYKN+ifhtBZFLF2tSePUWRDxMBrj9JdYPOSiLcV5ShrpIA6Jm18J+cmY Jw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgmsd8h7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 23:49:01 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29SNVa80011614;
        Fri, 28 Oct 2022 23:49:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagsjgms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Oct 2022 23:49:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3GP4n45sfBbXQZHuTZMLcIT2YSvx8Y8GBf7o0Quyx/DhltOG4EkECrj3zoJijERbLL/l5mxjOVQZabM20fZyTBbjNlmzGwl8DhHYg88Dyr1WHoZbAAGTVajBnV2dy4lxqtJJtmEQ2fAvjuaAxkfAdHIbixtPpmBuRnwvpsWor70rY1uRq5suC6tgZrj5dD+mPeYC5txnR06Ln/rMQ24Tad4oYNRhRq5MME7JvBcGqs0Vuo6c/AK2PIX5wjqz3I69PNEsn37raGlwwGvosqlZHq5ESsgM99807/imhhz1cJgRNE+cQc512aYRfETVQ8fLMzvyyLSo63oguvgNOF7Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HjPZClMx7jBAgDUH+P5hHJfiVVVJrR33Nk5G5p1Y0Nk=;
 b=HzKNFlsMixB0Xw2cwd7UG99Q0dXTqEwDKE18+ipOhsqZnkJU05budlDAhj5H3QoPPd2deWyivzkggVr06of4EkOHXqD/ogmC+uSgbUMCW5bqONVPZtnByMWgGYzoDrQyOMOet3mu/1Qq+/M7VEaylwSJZfsAa7F+bSDWKXYCLKXyvDAgcVfYF2UcToUiGFaQLC02HCwl4JTavWapbs/5zkqhu88tiICB4rs++88dPtFdm5i9iBHOxoU/fP5BvKOfuw8E78p624m5buLV0opw6kKVwDF/1sH7Ivl3BjnpQQIga4jM5emuII0JbUnfhMqjpNjE7sNvZqqj/17tMJf/rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HjPZClMx7jBAgDUH+P5hHJfiVVVJrR33Nk5G5p1Y0Nk=;
 b=BIOF96NW8vhhXnwDJ2u8a+L1zv+vJwIb0NvSuIjD6IXWRQTW2CY0t4ndFykYN9eMZ2YhRSNH+MKQYe5Ay1FrXxrfLuYTocVCfyE3r/b+FrHOqE8SoT/OLrigFGBXd9okawcmy3uVPb7XGhTysg5TyE2BZuV+MMFwSiVojVEgqFA=
Received: from BYAPR10MB2997.namprd10.prod.outlook.com (2603:10b6:a03:90::16)
 by MN0PR10MB6005.namprd10.prod.outlook.com (2603:10b6:208:3cb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Fri, 28 Oct
 2022 23:48:58 +0000
Received: from BYAPR10MB2997.namprd10.prod.outlook.com
 ([fe80::fee8:36cd:5e78:f1a1]) by BYAPR10MB2997.namprd10.prod.outlook.com
 ([fe80::fee8:36cd:5e78:f1a1%4]) with mapi id 15.20.5746.028; Fri, 28 Oct 2022
 23:48:58 +0000
Message-ID: <fdb9f874-1998-5270-4360-61c74c34294d@oracle.com>
Date:   Fri, 28 Oct 2022 16:48:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.1
Subject: Re: [External] : Re: [PATCH 1/1] IB/mlx5: Add a signature check to
 received EQEs and CQEs
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>
Cc:     jgg@ziepe.ca, saeedm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, manjunath.b.patil@oracle.com,
        rama.nichanamatlu@oracle.com,
        Michael Guralnik <michaelgur@nvidia.com>
References: <20221005174521.63619-1-rohit.sajan.kumar@oracle.com>
 <Y0UYml07lb1I38MQ@unreal> <5bab650a-3c0b-cfd2-d6a7-2e39c8474514@oracle.com>
 <Y1p4OEIWNObQCDoG@unreal>
From:   Rohit Nair <rohit.sajan.kumar@oracle.com>
In-Reply-To: <Y1p4OEIWNObQCDoG@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:806:130::10) To BYAPR10MB2997.namprd10.prod.outlook.com
 (2603:10b6:a03:90::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2997:EE_|MN0PR10MB6005:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d9125a7-a8d2-4cf7-dea5-08dab93efb51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fc03xPKZOCS78BZHCmzHAQgv9uK09rqqTDYgUfeHPJGrrCcc9ptOJPULPNPf5W2dZOOyYwVJ3jQhmmkZcRuX1zI+Zqu94x63XhEzKCvKb++rGu2SYcNsSan5mmjYKGm2tZ9Llq/Y7kRKssJFsYq0pDcem8jOAbxeZBdANpfmZcwLm5T+RUHWiAoAF5YfeVYQK46AobEfoHO19RaUJDghOLDo020QxqdleTAPwDXt9rUMS7WPvxWyxk5jsUM4Uv6Dx+Ug78BnqL8oZSxKXrGEMvcTo83etkvTDqDmyBALmRrzVyAjSJMgqkyPexl4tcddE4ciSuaGFqnt0+qUH0cOZlXjpoC9Lasm5BKxNbHkryyDdABTYr2lgeXOzlN5XxyC17SDkxHVODdTpU89W5Jwh6Y34DK/+1iiyofVtAWd6b6BCZykgdOiT5cffjEdfSq2RkNXiEu8zUnmhZyAdSvjT5nSsY6Qlp3/OZ+kzqnfwN/+dbpwh9ppPQHZYOgz0jFIDP04l+EyUuHGbmKlJ8FQbjk9dbEui1C34vpf+idfIWRuVGLd1Mq7rz/eMDEWaVS/g5ezjddkj0hclHRsQZhKHgLI6x6eAF+1cJpXttH/VAdD2ifRz9ZAsMgN9PhbxkdkFjOXwX3BBWTA19WGfGx7IBcEyBCh3c+s0JBKXoS8wVw4f+3nP0X7/1JqVRgs8hlQxCHjt1rQo3XQJu/e/GB0GKjLDIkiVvum9tPvQcDLwJ8D652r0UroMWOQYnThnHv1bnYSmAI1trYDxATNN2/+aft7xZ8JSrrMYSF0BI0n/s0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2997.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199015)(83380400001)(86362001)(38100700002)(7416002)(2906002)(5660300002)(31696002)(8676002)(66556008)(66946007)(66476007)(4326008)(41300700001)(6506007)(6916009)(8936002)(6666004)(2616005)(186003)(6512007)(26005)(316002)(53546011)(6486002)(478600001)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFdBNDViME1rVklDeUU4UkZiTFVxKytPcGxnR3V1VSswVEV3MTh4dlBNUFdt?=
 =?utf-8?B?TC8yME9DZUJwTG9rdm9abVViZXdqaGt1OWp6YnJra05Na2xqVGQ5UE1nVjR5?=
 =?utf-8?B?MGEyUUYxbmhvc25xS3RIY0ZqdE5BMWNIWkpPM2c2b3FVM0tYUmM3YldveDRQ?=
 =?utf-8?B?NlFYcU1yT3lZeXg5Snl4bHRzREEzWk5uRmFyMDkyQXd1Q3hycXJXM0toa2pq?=
 =?utf-8?B?UnRWa0NudDVoWjZnWER2am96Z2MzemRIWWl5bnQ2alBNVFRUVHFFQ0RSRzhh?=
 =?utf-8?B?My9GNGJvZU5PRUUreTlNOUtWM2lnajJKWHVmZFJaV09LYUFiUm5NRWJKbXVO?=
 =?utf-8?B?U0NLb0J5azQ0NlVWMm5hV1cvMGRaZnVaY1pwMlVxZGEvQytNdDdTb2ZFQkk2?=
 =?utf-8?B?c3cvYk9rMEVPWHdOSDlJNVVJcjF3UGMvWm11ZC9SdjV6RVdBeFphNFpBeWxO?=
 =?utf-8?B?M0c1ejdHa29qZTdSbHRnaG9KcHFJTWNXa3VOZUdoWThLYVFUTjNzdTRTSUJ1?=
 =?utf-8?B?NnEycWtwMTBtRUVzbU5pV0l1Y3d3RkU1aWZ4c3c4Q0h0cTFCZVY5Q0xvNDFw?=
 =?utf-8?B?SFNPeEZFdDdVbWhZM3BJWjVraENFazdZRS9ZeXdSWi9zRERqYUR5YnEzaEtX?=
 =?utf-8?B?RWo3S0RjUnZ0N3dZZDUyYmRJUlliSks0MFBnTlY0dERZd25zcmlENk9wT2d6?=
 =?utf-8?B?OVpDdDB2TmR0WlVvQ3Z3TEU5YWpFNEw4K3AzTnd2UGxlVnFId01Gb1pSQTRW?=
 =?utf-8?B?L2l2dzBFNWRWMk1uZ3VTRzJFc2RlMEtlelRISmt5aE5Pa3ZPSkk0all0MzBX?=
 =?utf-8?B?WVBxMmU4NUpIbUZmOFE3UGF1U1ZGdjIyYm9zc215VlpaQlZFV3JXem9YaUJa?=
 =?utf-8?B?TzFIOXkwSkNsM1NNeHpFQm9GbnJCbzNBYkdncTFweXhnaDF1dDNMNkpPa3pm?=
 =?utf-8?B?d3dIV2xyUEFKYjE2Z3BGRjg3Qk1GUmNIdExSVXA5T0ovSVRHdFk0NDJYVHVj?=
 =?utf-8?B?THdwRG5IZko3QTNNQllJdzJOM1plYzJvM2xqdTIxN1MzUWJtM1ZwdE9hZVRn?=
 =?utf-8?B?bWc3dllYcWhBWlIxRks4REFJOFM4TW9mL2tNVzlGa2dZNDBtanc3M0xEOE5F?=
 =?utf-8?B?RUZabjFubC9WZDhidTJkY3lScndBVmtxT3ArL0dsVStKMGJOMnZaWnJRMTli?=
 =?utf-8?B?aHFLemZjQ2VVQjJLZWM5NmMvcTZhT2taZlY0M1pLeU5GME5jWDdkQ0tsdzcx?=
 =?utf-8?B?TVpEV20yOGErZkFwQnZBOUtmYUE1SUVkN2NOZGMybHpCZ1dhd2MzQ2E2S2Z0?=
 =?utf-8?B?OWJsZFBIZkw2dEtIc1NLazNheTVsbDg2Y2JvKzhCOE9iK2syWWF2a1U3ZGFj?=
 =?utf-8?B?R2M5UzZ1ZUdDOHYzLzZ4SlU0SlFIV1dVQXg3R2JYV3pKU3p1a0lWa003YnFh?=
 =?utf-8?B?VFM2bUpHQUxNL2pMUHVCZzdCTi8rTTFYdTFUcmRockpXRTBoQmg3bUJhUU5k?=
 =?utf-8?B?WmlKMkxjVFhBZERXbWdSeWRxcHVUNTgwQWkzNTNWcTA2Z01OeVB4TTNqa1Zj?=
 =?utf-8?B?a204Wmx6TzJZNG1PVGlhU25hNmZ0bXNSckt4aFBKaVptZXVOOVZKMEMzRmJh?=
 =?utf-8?B?TmN6Ynk4YTBMWkpyQ0czbndVUjFLYmdGZ1I1U3EyZjFhcVF2VFlrSDQ4SzMv?=
 =?utf-8?B?U1I5NXFhLzZxRExCUVdFWEVodU5sclg0RU9kZkxYWXNkaVlRUWpscmo5dm5B?=
 =?utf-8?B?TWkyRlY2Z1BFdUVrc21DQ0g3Qm9vNm5KY295dkVlOWtNUlJ1RHZDU1FFaEhn?=
 =?utf-8?B?QXpuM2VQN2Y3NkdDcmhkZTFBWU43VkFHZ0J1MUd5Wk9FQ2p6Q01scFpDeXdq?=
 =?utf-8?B?TEx1Y2ozNElPN3NRcDIzNTNLZDJjV0RkMHlkczhxTStqM1FqMlFhdjZSS1lx?=
 =?utf-8?B?a2FPZ3FKTzRSUXFwSytCdGowN3M5Z1Axa0VkZ3NhQmpmMGlFUHg3VGZ2K1lT?=
 =?utf-8?B?cHpFVXlZM0tMTnZEUVZ1eTlnVnBCemx3czFxSnpRbG9oNlQxZU5wSjcrYnQ3?=
 =?utf-8?B?N2NDclhKUks3TVgxV1FhRVJBWXB3ODN4SnJaZW93S2ZEcHNkbjhTZGhvdTkz?=
 =?utf-8?B?R1dEUXQwdnVzSm1pUmxtVFNudHlnV29HdjhHem0yNWNEeWE0b3Z3OE5TSmhs?=
 =?utf-8?B?UVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d9125a7-a8d2-4cf7-dea5-08dab93efb51
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2997.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 23:48:58.3778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dP4hCRuoCDNz5srFgIG/BCYcQ/Xo25tb1Ds1fzC+q0Ep/wp/t/keCH1XsqdnUYGqPRTYns1p2fWSk/0p531PR7X7fuvlxCBD/KuMo1TdRl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB6005
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-28_10,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210280151
X-Proofpoint-ORIG-GUID: 951TXaJLK3S7BqZhfMDVdQMbtTUUEHLa
X-Proofpoint-GUID: 951TXaJLK3S7BqZhfMDVdQMbtTUUEHLa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/22 5:23 AM, Leon Romanovsky wrote:
> On Tue, Oct 25, 2022 at 10:44:12AM -0700, Rohit Nair wrote:
>> Hey Leon,
>>
>> Please find my replies to your comments here below:
> 
> <...>
> 
>>>
>>>> This patch does not introduce any significant performance degradations
>>>> and has been tested using qperf.
>>> What does it mean? You made changes in kernel verbs flow, they are not
>>> executed through qperf.
>> We also conducted several extensive performance tests using our test-suite
>> which utilizes rds-stress and also saw no significant performance
>> degrdations in those results.
> 
> What does it mean "also"? Your change is applicable ONLY for kernel path.
> 
> Anyway, I'm not keen adding rare debug code to performance critical path.
> 
> Thanks

rds-stress exercises the codepath we are modifying here. rds-stress 
didn't show much of performance degrade when we ran internally. We also 
requested our DB team for performance regression testing and this change 
passed their test suite. This motivated us to submit this to upstream.

If there is any other test that is better suited for this change, I am 
willing to test it. Please let me know if you have something in mind. We 
can revisit this patch after such a test may be.

I agree that, this was a rare debug scenario, but it took lot more than 
needed to narrow down[engaged vendor on live sessions]. We are adding 
this in the hope to finding the cause at the earliest or at least point 
us which direction to look at. We also requested the vendor[mlx] to 
include some diagnostics[HW counter], which can help us narrow it faster 
next time. This is our attempt to add kernel side of diagnostics.

Feel free to share your suggestions

Thanks

