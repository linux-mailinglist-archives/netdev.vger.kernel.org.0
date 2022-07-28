Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C35C583942
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 09:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbiG1HJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 03:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231701AbiG1HJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 03:09:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26ACA1B4
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 00:09:33 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26S64Fmn020314;
        Thu, 28 Jul 2022 07:09:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=xR5gwm8RNMPuzwLkDQv6OnU1Xe8BcB34mQuo57yr89A=;
 b=gYkJbRfaU1gNquNzfInaRM62nN3mm2A35N4L426hXlGtpFk8XmeddCNljd+rl08qkSnw
 jJjA5F44H285+S6FnJTnyRrizufnKsCeVUPG7UBW97wQ0sBoFUcbRJ9geUlWnxwg4m6y
 ID1UuYjNW+T5nCYajAetXVjVJfcCLgp27jcT8/+D97aj45Dasi8fpBdS0z/GXin7cTCP
 cF6FfAr6O6WqnLcXQWNbwtwXN6DRCRwBLMtzHf4rQBNePUFPshvISwaI6aN/CzCd46kY
 xBioMXaxdUPBW9+hgV2N18Vu6UjTYONRBLj7uUJGcVTGIZzapVcSVcDzmLKC188JNC0q Uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9hsv4nn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 07:09:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26S6xf5x035300;
        Thu, 28 Jul 2022 07:09:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hh6358fh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 07:09:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d7YNo2RpfivHc6LcCASSlUDmnqvaJofU2AraP02BITSzBUMJyk+X86g/4DM7Q5Za1ka4v0s3sqPqf1/hi1Oz4e6kVj9wCQ/rz841PjKbWsTZ7mwUr09zo+FQWtxhe4vE8QT/I02yUtvlPNuhRoyj1Rzu1ux+yH4X3g3w01trLUmL7Pd9ftlagOx/ZNc5HkTeTpDI8NgyLzUFC1cawRdF5A6hsU9SYFt1oRsVFHuSDnXxepOjNSlbsDuJmuyQeQrMTdNdpvPG+o/fAzN5FEQDSQSMw79SrN+Ntz5OgvypWrcQokMqKcrtKTCt/EvD/acE+qkfPipCJFQYfY2bQfwUIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xR5gwm8RNMPuzwLkDQv6OnU1Xe8BcB34mQuo57yr89A=;
 b=OOYSZgrKgAoSnKr41Ml2mNN1xrmC5xWeL/5BrWRxnP9QJnJeHCcMUt8QFKaQ0JoznEHmZwfp/tFuPM/1NLMVWnMeWkDlqA7v6HeNyB1JHSDp4ZSK/e+glCA9KluuW26b3plxqxlM9YYFdbyTlTePs2GqwHanCqsPXgPozSPZQqDc0g2WaVMVEML4WM4fEFOgIWKli+fnJ3KQ7cmCSE8FgVG2BhSBU6/P9sxw0kf/xJadHWCbFiX/MijZ1mbRmzwSxDi9oOcyE577dFWN1eyNvLVpAsKpAy84OEdI88SsyPBHh0uFuNMnJK01oEL1FQ+T61RcxzyKDZGiQxKCPlAexA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xR5gwm8RNMPuzwLkDQv6OnU1Xe8BcB34mQuo57yr89A=;
 b=lo8q9nyK7bS31CKdsZ+OF3M70UtWoC3cPrEP3fi7L6L6PQ+EfC2kCEVZXVX9xlXNBJZHbSonX+/DzHWNDANWuX7uLBHJE/GDRDVHX7xCvgjUbH0lFIiooZ67flxPBvTnjzlFheYUrVWEXrcjwgDfmHBnz0xhednvVSsEhQOZSd4=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by CY4PR10MB1672.namprd10.prod.outlook.com (2603:10b6:910:9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Thu, 28 Jul
 2022 07:08:58 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803%4]) with mapi id 15.20.5458.026; Thu, 28 Jul 2022
 07:08:58 +0000
Message-ID: <f3fd203d-a3ad-4c36-ddbc-01f061f4f99e@oracle.com>
Date:   Thu, 28 Jul 2022 00:08:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
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
 <c8bd5396-84f2-e782-79d7-f493aca95781@redhat.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c8bd5396-84f2-e782-79d7-f493aca95781@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR02CA0096.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::37) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 572562c7-614f-41e4-fbc9-08da70680a51
X-MS-TrafficTypeDiagnostic: CY4PR10MB1672:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5kOoISs3s1nKd0So9fvcvK3aoeD1QhPX9XuEg727VFJOaR+XSnfJJQE/FW2cq9pkRld5THRJvzeHl0BM/xJ+ZII8YqYc9LBukzjjAPdw7CSRfnm4vkeJi6X2GkXQcdJ4Y9fu2tEwJSzZtEi2OhJKNQ404aaCCP9ELrFOhuW4cZ1J7ChYvtjXXopRm/sMBFLA8Q6tSoQ01tdTufwi+oyn8AShEubKbl7cwD+wIFybdVNXfNwZIQWUJxpGSMmXlIbisUrjNhV32VvkRR+kTOMz1zEYpOagrzqF7Q/kENwQv3eF8hH2L5QskNFtfUEyWPZmpvO5TrG8KJjjh5Q+bFgUAhRdH0fdk7TOcvBuaJ6sNs2dMQI+Oqy/gFAq8MgvDsazHlpl3qZBXN7iRXLIUDemrVMkxaW4oE6ceyilDEqi5pzXyz1riK4qe6Ph+pMVSjdmBlJgmMrdqARPkbLTIWwG4ABJsUfbpqiPyf3dIvO4DcViSc8bn5M1JKPUpcNd0UE1eiFr6Y/JyMgxBwl6uGfhkJPx1nAkDwKGnFgg+1ep9mCtcXkomRtSRNSpkQP/Q30aCWSQpQob3uwzSqFlPdsPbVq7XWZYSv3srasVHpB3PlIR5KRrEb/aYiyxR1D+xHvQdZrPit4UgrbelTE/V+IxKnC9DCghx7EQaobYpT3IWJXtOxWVXD47XZR7ZZG9N3gOpC6BZbGwnC45oelo0SuRNVEaw02is4S30SflEPLBvXGGXBEyqMEt2iT3MnYWiWMU3UXPu5l7ji5boCvj+mJ6ij9oXAZqzTzty0HXMHOSJ8+BPxexMnYuIXH1R6sQi2nT84qMlvpQMm93cNwtM6aFANb7NZGTbsKpstTD2pjeQRI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(136003)(366004)(396003)(376002)(346002)(26005)(4326008)(6666004)(8676002)(54906003)(6512007)(110136005)(966005)(53546011)(6506007)(66556008)(66476007)(66946007)(86362001)(186003)(36916002)(83380400001)(8936002)(2616005)(316002)(478600001)(41300700001)(31696002)(5660300002)(31686004)(2906002)(30864003)(38100700002)(36756003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SXRNK0RuMEpJRXJpcGpxb1BiTUpZcUlHYklUcUxyTEtvdVpPaU9XelByWWlF?=
 =?utf-8?B?TXo2RzZnbEhLUU9VNTFzNzBGbUtZMTBwc2tDVFpEVlJWd1UvQmVBL2ltcnZp?=
 =?utf-8?B?RkJSSko4WVFyMEszTXVjUEpnejF1aGdnc1Qyb1Y4aTZUelVqZ0RpZnhINGVE?=
 =?utf-8?B?S0F2QlRnUUxyVXFmbjIxengwQktWK09Fd2p2Tjd1Mm1BQ3ZTVlg3RTByampq?=
 =?utf-8?B?cjUvbURKcHJFVzdENnhrWm5UWWh4TUFTOVZsQlZvdDNDVVFFaGNQV1IreWI5?=
 =?utf-8?B?U0xlaG5pK08vWHhnTDgrR1B2VUlJOExadzlHa2VSVkw2SDgvWTFlTDZlendW?=
 =?utf-8?B?OXQ2cmpaV2s2Uzg5SzlNUjVFMmJWNDZTVUdWQndRUnJxd1d6ZkFpOUZYcDdN?=
 =?utf-8?B?YjQ4RVVsY1dNUTArVkZtOHRRVEZ5cUxzMVNFdUxna2krTHNDcXNwaDNGcm4y?=
 =?utf-8?B?QzJSUUlkcDFncnQrenROTFZYRDh3RE1BWXpLblZkUk9MeDBSTlpQZXEyOVcz?=
 =?utf-8?B?ZUMxTjFzNW1kbmk2VUErWFR1ejZ0U0g5V1BpOGVFT05EaHgvcEh3ZjNBelkr?=
 =?utf-8?B?UGZWOXRGRDA2eVVkbUtVajRoOW5RQUZYTjNWMjlWcGV6N2trblE4aGNMVVph?=
 =?utf-8?B?bkdaVERSbjdnRzVFNDBXVHlnRjhlU2hvS2ZZOU54OCswd1RZejF2QWZZYkxS?=
 =?utf-8?B?eGE2SXlhUFUzdzJFRDdCWkJHcmNxaHBpOVp4WVB5bUV2VnlTZjZZQTZYZ2Rl?=
 =?utf-8?B?cm96SzhZbXEzZmw3VUF3Z2p5OU4yNHY3ZUdFOGd1OEl6RkUyYkN2RWNGR3Uz?=
 =?utf-8?B?eTBvajhtRjdDV09DV1Q0aGNQd2tPR01xZFYrS1FZNW9jdUtKTW9oTjNNcFps?=
 =?utf-8?B?alNNQmpicTF2WnBuNWg3Rkk2S3lvaGxwUXpTdHlNbExRamxSMzQ5U3poZW15?=
 =?utf-8?B?SkplSUxzbUltUWlMekwyT2I0S0psVHlHdXF5ODFOL29QUFp2Q0ZwM1JxQ0RO?=
 =?utf-8?B?THYwZHA5bUFHcXJveWw5WXpiTWtOSzhDdFAzdE1hRUFoa1ZPNzhJVS9hd2JU?=
 =?utf-8?B?TzhnRjlWelN1aU5YbnVPRklobXd2RDJXRmtIRStnVWowc3ppN0I5QkF1U2px?=
 =?utf-8?B?TTBUc3RYS0VlWHJhZUJlL0xNZjN6OHNVRmE4K1Yya3FLcU1Na3JxR0RYZ1cy?=
 =?utf-8?B?eXpzb1FJVy9JNXg1aTljM3dUdGZjQk9WMmhSK0RFWXp6c0NHcEpvZ2V6ZGQw?=
 =?utf-8?B?ek1XZ01qWkFYN2xmbUlZR3dqby8wWlBMM0tLcnZITUFTY2VJd1VjdzlVM3Jj?=
 =?utf-8?B?QmpqK1VtR0w1WFNSOGV2UUpsT2tmejJDMklyTmkwSFlDVmtoSDg3dEhLUXRI?=
 =?utf-8?B?Z3NXNkRxRWhXMVlEd2lCL013VzBGdzFXc3BpUWcvbTZNL0lObWhGSEJybGI2?=
 =?utf-8?B?Z0NHR0hqVVpSaFdKakI2V3RzRExjMUZTbmUxMUtYNnFhVlphWG5iNVZjYnY2?=
 =?utf-8?B?eGZQVmsxckYvNTU3d2FmT05QaHBZKzVlK24vUWJtcVNWRlNsM2psQTRvMFFl?=
 =?utf-8?B?cXJGZHl4Q0xpa1lOMjFiaW5sMmRIMGZuMCtBVnBxREJUR3FpQVJEaUw3MkFx?=
 =?utf-8?B?M2FkRllxRE4wMFg2RmNIQ09GNzNLWmMvUkdkVlNodVE5R1hXdWJUYmRvQjJp?=
 =?utf-8?B?VWVadFBHUnByLzVmMzBpZmRKdHFLZEU0WllXT1RxVmV2QTdHZDRDU3JmeWFa?=
 =?utf-8?B?R1RtOGFqenhiR2pmTjFpU1FKTTZlNUo3Tkp2TjNYOG5sbHo2NkxyWXFJVUhv?=
 =?utf-8?B?ajF3NWp2cjJXUmJZcHhsQVc1S2hBZHRKRUFXcmU2aWxMc2RvZk5idkZrdWx0?=
 =?utf-8?B?T3ZPVmIrdi8rZzBBbVJvTVl1SjBEeE1rb1lnZ3ZiZk5BdncwZXNTVG1NVFBu?=
 =?utf-8?B?UExrczNyNnVkUlBiNUZjMDl2RDFmMWtwdlJLLytoRTFQTlptRWlPakx1N1F3?=
 =?utf-8?B?WCtNOEZDWWY2V3lNK3FzUDQ5WHBIMGEyTUJBb1A3VzZGRTJiSm9BcnNlU3cy?=
 =?utf-8?B?UG94bWlPNExsTXphNUU0cnV5TEtHRGEwR1RORXhwSGI4SGJ0V0I2dDJCRXFV?=
 =?utf-8?Q?kCPjyTGmVt118HeF10BxE2ilq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 572562c7-614f-41e4-fbc9-08da70680a51
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 07:08:58.0276
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: boRY15vOsNA0g23e5glPJ4D7u8Qxr0fVFZPhsv9EgBd43eH6vyF2J4nkS93uyaNtMuztdde+yPdtdChzN0KK5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1672
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_01,2022-07-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207280028
X-Proofpoint-ORIG-GUID: B5mvQxUaWQ0sk5eqFVsKGI_yQKL4hBO8
X-Proofpoint-GUID: B5mvQxUaWQ0sk5eqFVsKGI_yQKL4hBO8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/27/2022 7:06 PM, Jason Wang wrote:
>
> 在 2022/7/28 08:56, Si-Wei Liu 写道:
>>
>>
>> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>>
>>>
>>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>>> Sorry to chime in late in the game. For some reason I couldn't get 
>>>> to most emails for this discussion (I only subscribed to the 
>>>> virtualization list), while I was taking off amongst the past few 
>>>> weeks.
>>>>
>>>> It looks to me this patch is incomplete. Noted down the way in 
>>>> vdpa_dev_net_config_fill(), we have the following:
>>>>          features = vdev->config->get_driver_features(vdev);
>>>>          if (nla_put_u64_64bit(msg, 
>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>                                VDPA_ATTR_PAD))
>>>>                  return -EMSGSIZE;
>>>>
>>>> Making call to .get_driver_features() doesn't make sense when 
>>>> feature negotiation isn't complete. Neither should present 
>>>> negotiated_features to userspace before negotiation is done.
>>>>
>>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill() probably 
>>>> should not show before negotiation is done - it depends on driver 
>>>> features negotiated.
>>> I have another patch in this series introduces device_features and 
>>> will report device_features to the userspace even features 
>>> negotiation not done. Because the spec says we should allow driver 
>>> access the config space before FEATURES_OK.
>> The config space can be accessed by guest before features_ok doesn't 
>> necessarily mean the value is valid. 
>
>
> It's valid as long as the device offers the feature:
>
> "The device MUST allow reading of any device-specific configuration 
> field before FEATURES_OK is set by the driver. This includes fields 
> which are conditional on feature bits, as long as those feature bits 
> are offered by the device."
I guess this statement only conveys that the field in config space can 
be read before FEATURES_OK is set, though it does not *explicitly* 
states the validity of field.

And looking at:

"The mac address field always exists (though is only valid if 
VIRTIO_NET_F_MAC is set), and status only exists if VIRTIO_NET_F_STATUS 
is set."

It appears to me there's a border line set between "exist" and "valid". 
If I understand the spec wording correctly, a spec-conforming device 
implementation may or may not offer valid status value in the config 
space when VIRTIO_NET_F_STATUS is offered, but before the feature is 
negotiated. On the other hand, config space should contain valid mac 
address the moment VIRTIO_NET_F_MAC feature is offered, regardless being 
negotiated or not. By that, there seems to be leeway for the device 
implementation to decide when config space field may become valid, 
though for most of QEMU's software virtio devices, valid value is 
present to config space the very first moment when feature is offered.

"If the VIRTIO_NET_F_MAC feature bit is set, the configuration space mac 
entry indicates the “physical” address of the network card, otherwise 
the driver would typically generate a random local MAC address."
"If the VIRTIO_NET_F_STATUS feature bit is negotiated, the link status 
comes from the bottom bit of status. Otherwise, the driver assumes it’s 
active."

And also there are special cases where the read of specific 
configuration space field MUST be deferred to until FEATURES_OK is set:

"If the VIRTIO_BLK_F_CONFIG_WCE feature is negotiated, the cache mode 
can be read or set through the writeback field. 0 corresponds to a 
writethrough cache, 1 to a writeback cache11. The cache mode after reset 
can be either writeback or writethrough. The actual mode can be 
determined by reading writeback after feature negotiation."
"The driver MUST NOT read writeback before setting the FEATURES_OK 
device status bit."
"If VIRTIO_BLK_F_CONFIG_WCE is negotiated but VIRTIO_BLK_F_FLUSH is not, 
the device MUST initialize writeback to 0."

Since the spec doesn't explicitly mandate the validity of each config 
space field when feature of concern is offered, to be safer we'd have to 
live with odd device implementation. I know for sure QEMU software 
devices won't for 99% of these cases, but that's not what is currently 
defined in the spec.

>
>
>> You may want to double check with Michael for what he quoted earlier:
>>> Nope:
>>>
>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>
>>> ...
>>>
>>> For optional configuration space fields, the driver MUST check that 
>>> the corresponding feature is offered
>>> before accessing that part of the configuration space.
>>
>> and how many driver bugs taking wrong assumption of the validity of 
>> config space field without features_ok. I am not sure what use case 
>> you want to expose config resister values for before features_ok, if 
>> it's mostly for live migration I guess it's probably heading a wrong 
>> direction.
>
>
> I guess it's not for migration. 
Then what's the other possible use case than live migration, were to 
expose config space values? Troubleshooting config space discrepancy 
between vDPA and the emulated virtio device in userspace? Or tracking 
changes in config space across feature negotiation, but for what? It'd 
be beneficial to the interface design if the specific use case can be 
clearly described...


> For migration, a provision with the correct features/capability would 
> be sufficient.
Right, that's what I thought too. It doesn't need to expose config space 
values, simply exporting all attributes for vdpa device creation will do 
the work.

-Siwei

>
> Thanks
>
>
>>
>>
>>>>
>>>>
>>>> Last but not the least, this "vdpa dev config" command was not 
>>>> designed to display the real config space register values in the 
>>>> first place. Quoting the vdpa-dev(8) man page:
>>>>
>>>>> vdpa dev config show - Show configuration of specific device or 
>>>>> all devices.
>>>>> DEV - specifies the vdpa device to show its configuration. If this 
>>>>> argument is omitted all devices configuration is listed.
>>>> It doesn't say anything about configuration space or register 
>>>> values in config space. As long as it can convey the config 
>>>> attribute when instantiating vDPA device instance, and more 
>>>> importantly, the config can be easily imported from or exported to 
>>>> userspace tools when trying to reconstruct vdpa instance intact on 
>>>> destination host for live migration, IMHO in my personal 
>>>> interpretation it doesn't matter what the config space may present. 
>>>> It may be worth while adding a new debug command to expose the real 
>>>> register value, but that's another story.
>>> I am not sure getting your points. vDPA now reports device feature 
>>> bits(device_features) and negotiated feature bits(driver_features), 
>>> and yes, the drivers features can be a subset of the device 
>>> features; and the vDPA device features can be a subset of the 
>>> management device features.
>> What I said is after unblocking the conditional check, you'd have to 
>> handle the case for each of the vdpa attribute when feature 
>> negotiation is not yet done: basically the register values you got 
>> from config space via the vdpa_get_config_unlocked() call is not 
>> considered to be valid before features_ok (per-spec). Although in 
>> some case you may get sane value, such behavior is generally 
>> undefined. If you desire to show just the device_features alone 
>> without any config space field, which the device had advertised 
>> *before feature negotiation is complete*, that'll be fine. But looks 
>> to me this is not how patch has been implemented. Probably need some 
>> more work?
>>
>> Regards,
>> -Siwei
>>
>>>>
>>>> Having said, please consider to drop the Fixes tag, as appears to 
>>>> me you're proposing a new feature rather than fixing a real issue.
>>> it's a new feature to report the device feature bits than only 
>>> negotiated features, however this patch is a must, or it will block 
>>> the device feature bits reporting. but I agree, the fix tag is not a 
>>> must.
>>>>
>>>> Thanks,
>>>> -Siwei
>>>>
>>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>
>>>>>> Users may want to query the config space of a vDPA device, to 
>>>>>> choose a
>>>>>> appropriate one for a certain guest. This means the users need to 
>>>>>> read the
>>>>>> config space before FEATURES_OK, and the existence of config space
>>>>>> contents does not depend on FEATURES_OK.
>>>>>>
>>>>>> The spec says:
>>>>>> The device MUST allow reading of any device-specific 
>>>>>> configuration field
>>>>>> before FEATURES_OK is set by the driver. This includes fields 
>>>>>> which are
>>>>>> conditional on feature bits, as long as those feature bits are 
>>>>>> offered by the
>>>>>> device.
>>>>>>
>>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if 
>>>>>> FEATURES_OK)
>>>>> Fix is fine, but fixes tag needs correction described below.
>>>>>
>>>>> Above commit id is 13 letters should be 12.
>>>>> And
>>>>> It should be in format
>>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if 
>>>>> FEATURES_OK")
>>>>>
>>>>> Please use checkpatch.pl script before posting the patches to 
>>>>> catch these errors.
>>>>> There is a bot that looks at the fixes tag and identifies the 
>>>>> right kernel version to apply this fix.
>>>>>
>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>> ---
>>>>>>   drivers/vdpa/vdpa.c | 8 --------
>>>>>>   1 file changed, 8 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
>>>>>> struct sk_buff *msg, u32 portid,  {
>>>>>>       u32 device_id;
>>>>>>       void *hdr;
>>>>>> -    u8 status;
>>>>>>       int err;
>>>>>>
>>>>>>       down_read(&vdev->cf_lock);
>>>>>> -    status = vdev->config->get_status(vdev);
>>>>>> -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>> -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>>>>> completed");
>>>>>> -        err = -EAGAIN;
>>>>>> -        goto out;
>>>>>> -    }
>>>>>> -
>>>>>>       hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>>>>>>                 VDPA_CMD_DEV_CONFIG_GET);
>>>>>>       if (!hdr) {
>>>>>> -- 
>>>>>> 2.31.1
>>>>> _______________________________________________
>>>>> Virtualization mailing list
>>>>> Virtualization@lists.linux-foundation.org
>>>>> https://urldefense.com/v3/__https://lists.linuxfoundation.org/mailman/listinfo/virtualization__;!!ACWV5N9M2RV99hQ!Pkwym7OAjoDucUqs2fAwchxqL8-BGd6wOl-51xcgB_yCNwPJ_cs8A1y-cYmrLTB4OBNsimnZuqJPcvQIl3g$ 
>>>>
>>>>
>>>
>>
>

