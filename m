Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF75A58564D
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 22:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbiG2U4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 16:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiG2U4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 16:56:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2BE743DA
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 13:56:02 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26TKEYsl031936;
        Fri, 29 Jul 2022 20:55:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=5ilPBWmnQP77Cf16m4cEekpwTJL7AajdC5e3o78KHok=;
 b=y82TDaHCinw4AgLyOB6rM900qeBiLq7dTZJu+lpZQ1FwwQbVECel1zV/3o4ZsySemvZa
 /ZXd80SbGllq3ktMebiuYQXpkHN9T2FFsPWkL9+diKbq3WAcZoaJTerK2PaRRuQL3Fjs
 1RCSsPA8dgMsMhQzCFRVqK87egj9ocx4zL9F5UV1WU1CN00S66Yc5XB/e3qFEdrjbZbh
 NnS1CgjB7BeyQWpxfrZY94/ELgr8maYJ7QKmn+jZh6Dl46dPkYa4YT1gY39jJSnYWuv0
 2jBYEYw1O/KluutMi7hKYehLTx9R5hSItGi42vTpHIKYAZrLxNBLV6wMMS/vozMiq5lY Ew== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9ap7qgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 20:55:47 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26TK4nfZ029777;
        Fri, 29 Jul 2022 20:55:45 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hkt7d6gxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jul 2022 20:55:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nn6ldDlblmai8t20gD9yPwXu59azE6bHKeThZ/V5LsXESgDaR2mZDZyTarks3LoUz7icyt/BelXcOps4mwL2usshUoyoYLqB2bsIFDAhhTnsjGuayhd7BA7+D5yxgcsH/2jQ6FHJTT9D44shJO1DDiETZKz6WRiq+V948pe09ICUvyj6dejthsVZ54WQucYPsbTfO0DwgKYKr36NLZoV1tPeCrK8tcKhjfsBwRHxvEd5BsHwbJ/FL0L6KAtOvZrNQ2fLAXDwvLCGjr3eZPs5GZQzygNHSt47if5AL6T+nhcADHX5o2BzO4V87AqpoL9M/FfWNLRA0wInYq2RExqYQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ilPBWmnQP77Cf16m4cEekpwTJL7AajdC5e3o78KHok=;
 b=beww+Ubx1wT8Z9WTXOfd63qUvOfSmzwvlStG2N0I18QF7l6tIJAk2LrJWcgoLTx2RPhQbSaJ5WCSPiNFLSbkJ/KvqQeucKNbPNGCIImJ6NfkgCO5zPOW6w48VUYFypYYs5yJyY6otiZEV/0yNChXO2Ri7lsyheH+sDc/U/WUZWZulJZGE0ihLZQhgJCr1K4pyHDuYjdhmSWYbDNY/qppB5rwp4odMFHsNbJbk5sMd1nhL0M023hvGHTWdLuaQ2WRqCxr3aLPRMW1H9rRbDQnPylp1nTpXP6ZARoeB9VZcHJNAlQbv/wPF/hEd3+eAGeZ7yUnJWwiyaMIx8SMPxmmcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ilPBWmnQP77Cf16m4cEekpwTJL7AajdC5e3o78KHok=;
 b=PLi6MLCE2AekazycmIa0KHLDgXFAT2fh0gDQnmplvJVrW5uLup9Fkl7V6Zpb6FLcbSIMlT1E0AmmZhF1V2/NWuLHUqjf2DdT4/4Rpf+eml/OoRXO8ydkNV4SD14RebGdso9lg2T/exz3EKi34rNk3HA46Aq5kbgz+0P4zmGNjWg=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by BLAPR10MB5124.namprd10.prod.outlook.com (2603:10b6:208:325::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Fri, 29 Jul
 2022 20:55:41 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5482.012; Fri, 29 Jul 2022
 20:55:41 +0000
Message-ID: <454bdf1b-daa1-aa67-2b8c-bc15351c1851@oracle.com>
Date:   Fri, 29 Jul 2022 13:55:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
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
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <c143e2da-208e-b046-9b8f-1780f75ed3e6@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0048.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::23) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e58a94c-444b-4037-73aa-08da71a4b2a9
X-MS-TrafficTypeDiagnostic: BLAPR10MB5124:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fIPrp/m/mZjLWnFPa7BWDg/aC1P8o+Gtjf5korQVrhvhRbGsPGe4GAApo0UA+oG+B3MlHMmzR0QpfiemkhlK3TPu23CMqtNrxnI6s/K1Sz17bYnHh3PAmobelah67BAQLxYZ+bYuuNzsSfl+Ku2dAnBUf42vxhi4HZUNr1YupzW3mYHrw8x7CreqIQGBPAC8E7D4tuCRwlWHRe69xzWvXEj323F6lXj4TqdqGGqYJccUjjUBGITCysCaj+bClqVnLOX8P4Ox93QOCkR9fCdXm5Tn25RP+5lIqHaboIqKW9nbobuZhK6p37IisTcQcsJTHbdxuZvn75ONi+TSXJHwIAAnK6LS3RO4mB0FBtdmcGA2anH2QBvE6KuthYD7tYQoiUcv3sieJnrjs6jZaAdaMCkDB35fiiZV+xPu7sw22wDZ+4UmrTFODyaDBY4ktIE+bjvll5oGZED+WwI2dER1hxbWXQj8kKvLi9/IjgMunl04RGInZF5BKEDQuyb/w49MnLaialcb2ZTUq7sfMeynE1LmXLN66zODS5k3wGjB8oo5h4Jhv9gHNO4AKN4BgFy9BbHHKCVoN/vQyWEeqWqtexjkq6562sovsWY9HS+H2lPaXzjolME4GCPHzifTRPC6x9s9TblgHxt2A94Ds8MGF6akb6zOOveeR27j2rCMYm/7Yyc5xDMWcRSlig5F9HUt/ixKQSJAW/Apk53S8x57H5niL9HQJKCuns0E3FNE9fjWx+HZFkxKsNvhe1REmhvbe5YoTgDniL0xaL/HpOezYq+hHzKW6+hlc8RDg8zyhDoG6XM52yvmiHUFyMo7SQZ0owLDzTBsz1/M/x+vPqQ7E41tyGs1XAcj4xGjZmKvCgw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(346002)(136003)(39860400002)(396003)(31696002)(36916002)(2616005)(30864003)(2906002)(6506007)(26005)(6512007)(53546011)(6666004)(186003)(31686004)(41300700001)(8676002)(66556008)(5660300002)(66946007)(66476007)(38100700002)(83380400001)(86362001)(36756003)(966005)(8936002)(4326008)(6486002)(54906003)(478600001)(110136005)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWsxRUNxcHJnblN4TGxJY0tDanVTdXZReEhXZ1VvRWxmUmNkVHVSWHFrSDFJ?=
 =?utf-8?B?MW9yRDZURjBENUZPOHR6RHhReCtPMDNPMGlaU1daM3daRmtoK1VjNGdscVJa?=
 =?utf-8?B?cHdTd1BFTjdmcGpscE44QWpPS0s0bGs4WWgwa1N2TFFHVkZneFRWc0JFQTZJ?=
 =?utf-8?B?ME5UbHg2WmRheWdicS96S0ZNUVpidExDM013b0JZRFJPblNZZVp5dFhUNU1Q?=
 =?utf-8?B?WGFqbDVtZVVZNllGSEFRZ0hmWG0rRnUyNmZZWUZZK0cwaTJwenhTREFSbnZh?=
 =?utf-8?B?ZEcxNG0vdllPQ0tKS1pCWE5ZQ2pOV0tQQURtdjZMWktlaVJ2cTMycDEwbkha?=
 =?utf-8?B?TGM1ZFYrT0ZZVnpXV3V3SCtzbXJMRjhLeGdzMENIMTB0YitxcUNnZDJMTzVl?=
 =?utf-8?B?TDVlSHhDb01wSkJ5TU5oZzM4TDBSY2NDd2NzcWo1Qmxhenc3VkhSdFgrTmJB?=
 =?utf-8?B?SzNiU2w2T2xROUpYQWtPNTlNQUlpYnRnanBTY3JOVEIwNFdOZDJDTThwbDkx?=
 =?utf-8?B?cHJVU0FtbHBWUjh6RExXbjJNeGpiRUVmQlp3VEVIdHRYVXlzNmlJSFBGNnVB?=
 =?utf-8?B?SCtvd3k4ZWozZ2ZUczRyb0F0eUNFYlQvVlQ2cGxiazVTRmtNL3VlVTVzdEhk?=
 =?utf-8?B?MkhuZTNBbm9GSGRPSUJORE1SVmFya3MrRzd6VjhWRFdUbmZRanROSVNlQlVO?=
 =?utf-8?B?T2tQUWZRVFpXSXpucVJ1eGRIVEVZK00vZkd0Z1pqWVo5UHVZYVFBUUR2TTla?=
 =?utf-8?B?UStwWk9reUtkMlFJVDJrVTdmWnkyY2Y1RWp1dU5VZ1cxbnhicDFtclBDcDJU?=
 =?utf-8?B?R25IOFQ0RzlzbXJINTZKdnZmcnQyNkJlczkydXVOemlpY1NBejh5UVNyK29M?=
 =?utf-8?B?QzNlQ1QzWFJTckpUbTc2d3NielBGYjdQUVhxWTQ1VkQvb0svSWhSTVdqMXFQ?=
 =?utf-8?B?YWFOVXhjdE8yNUtXQjJsN3Y4RHp1bUZPZXdFdmR5aU9UbG5aUHVBNkVJdUdj?=
 =?utf-8?B?YlNGY3pTR21XY0VHL3pwODkzSVloaURZRDJBTU5SN3BSc3lwdmRROGlpZVZ0?=
 =?utf-8?B?ZUp4QXpsMnIyb0d1aVhiM1BPQlFGNGdkRHluTzJybDhQdEhzUCtUbUp4TnI4?=
 =?utf-8?B?Q0pPYmprSk82RWpLN01PK0FmcUFYMjh1bVBCTjFlWWIwRjNUMDNIeWJ4Q2FB?=
 =?utf-8?B?YVlpRnZ3S1cxVEQ1WWRGU094Y3FOWFBlbjZ2K0tqZkFGSG9Cb2J4SC9SZVlQ?=
 =?utf-8?B?QlJmdW92MzZGdDlLcDdBY3ZHZ1N1SEpTT1JVVG5LcThzU3BHQk81S3I3S3hn?=
 =?utf-8?B?QnpUS3MrOVFwZElqUTVGdWpRZzlsYjAvWlRqRDFicGNSSldVN2V3aHpweUND?=
 =?utf-8?B?TUlTRGxqZndEWVNjUDJPRGFibDNra05LSEMzcFBXRGVuOGR6QUNKOVZyb3o1?=
 =?utf-8?B?dmZNWEY0dkZMQ1FhamQ5WENYZ0JNSWRSRHRMVG80YzNmRHR4T0g3YmNvYjMz?=
 =?utf-8?B?N252WGpRSmx0YVZVSjRMSENCUGtqRVoyZkRFc2wxeHR4S1kwckt5L1FzQmEw?=
 =?utf-8?B?MWgyOUlGYy9sb0syTmppb0Z2TWw2Z0RhMjlpNmJTRmJCMCtPMjY2eC9PaTN6?=
 =?utf-8?B?SWs1ZDhLdWdqWjhwdzBzSjRET1BYRUxoUWJYcmhqTWJWNHI0N2FzYzFlUjFN?=
 =?utf-8?B?S2MzZGpRb3RRb2pRaUg5dEc4V2g4NGU4bG9zdFJQbUduc0pTSjZOZjRuTUhP?=
 =?utf-8?B?TEJSRFF1VjI0cnZtYkV2MldCUUhlMTBsc0lOcmkxbkdVOWlFaVF4YUNZanNq?=
 =?utf-8?B?RDQ4Z0lKZ1VPQ3cwbFVSeFFHdU9xZkZjS0J2SitNWEZ1Z3RyZFdhakdwRXY0?=
 =?utf-8?B?NjFLRTZ0UDk5cjliOFZDeFFjaGlQb2NMUFoxbW13TEFwUzBmYnJWWnRzUjd6?=
 =?utf-8?B?Z0NmT2ExcHJMZ0FKa2RtOENNcGFOWEliSFYxT0pvL2hPWTFFRXcxSHB6Zzhh?=
 =?utf-8?B?amkxMXFYeW1vR004d1daS2xzejRod1RmZFl1bk5xVEdZek1lZWhMSkpvRVVt?=
 =?utf-8?B?NElJaG5yZkFvb1d0aWxPd0pLM0VjQXZBSXc5N1Q2Ky8ybS8yVGNobEdaZFp2?=
 =?utf-8?Q?GvihbIEBJpAPiQwLzTXHM0WbN?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e58a94c-444b-4037-73aa-08da71a4b2a9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2022 20:55:41.3465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: epi0CajTVg+7CSdEpawDAKfMF4yBr1Q/chIvm7QIKWuob1QHjWcZJxGvB5WXxPvq00mXNvG/tG+iP0Cd7bX8xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_19,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 spamscore=0 adultscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207290086
X-Proofpoint-ORIG-GUID: F16wQUXNeP87bxeIkv9zeyYNPC21uCQh
X-Proofpoint-GUID: F16wQUXNeP87bxeIkv9zeyYNPC21uCQh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2022 7:04 PM, Zhu, Lingshan wrote:
>
>
> On 7/29/2022 5:48 AM, Si-Wei Liu wrote:
>>
>>
>> On 7/27/2022 7:43 PM, Zhu, Lingshan wrote:
>>>
>>>
>>> On 7/28/2022 8:56 AM, Si-Wei Liu wrote:
>>>>
>>>>
>>>> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>>>>
>>>>>
>>>>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>>>>> Sorry to chime in late in the game. For some reason I couldn't 
>>>>>> get to most emails for this discussion (I only subscribed to the 
>>>>>> virtualization list), while I was taking off amongst the past few 
>>>>>> weeks.
>>>>>>
>>>>>> It looks to me this patch is incomplete. Noted down the way in 
>>>>>> vdpa_dev_net_config_fill(), we have the following:
>>>>>>          features = vdev->config->get_driver_features(vdev);
>>>>>>          if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>>>                                VDPA_ATTR_PAD))
>>>>>>                  return -EMSGSIZE;
>>>>>>
>>>>>> Making call to .get_driver_features() doesn't make sense when 
>>>>>> feature negotiation isn't complete. Neither should present 
>>>>>> negotiated_features to userspace before negotiation is done.
>>>>>>
>>>>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill() probably 
>>>>>> should not show before negotiation is done - it depends on driver 
>>>>>> features negotiated.
>>>>> I have another patch in this series introduces device_features and 
>>>>> will report device_features to the userspace even features 
>>>>> negotiation not done. Because the spec says we should allow driver 
>>>>> access the config space before FEATURES_OK.
>>>> The config space can be accessed by guest before features_ok 
>>>> doesn't necessarily mean the value is valid. You may want to double 
>>>> check with Michael for what he quoted earlier:
>>> that's why I proposed to fix these issues, e.g., if no _F_MAC, vDPA 
>>> kernel should not return a mac to the userspace, there is not a 
>>> default value for mac.
>> Then please show us the code, as I can only comment based on your 
>> latest (v4) patch and it was not there.. To be honest, I don't 
>> understand the motivation and the use cases you have, is it for 
>> debugging/monitoring or there's really a use case for live migration? 
>> For the former, you can do a direct dump on all config space fields 
>> regardless of endianess and feature negotiation without having to 
>> worry about validity (meaningful to present to admin user). To me 
>> these are conflict asks that is impossible to mix in exact one command.
> This bug just has been revealed two days, and you will see the patch soon.
>
> There are something to clarify:
> 1) we need to read the device features, or how can you pick a proper 
> LM destination
> 2) vdpa dev config show can show both device features and driver 
> features, there just need a patch for iproute2
> 3) To process information like MQ, we don't just dump the config 
> space, MST has explained before
So, it's for live migration... Then why not export those config 
parameters specified for vdpa creation (as well as device feature bits) 
to the output of "vdpa dev show" command? That's where device side 
config lives and is static across vdpa's life cycle. "vdpa dev config 
show" is mostly for dynamic driver side config, and the validity is 
subject to feature negotiation. I suppose this should suit your need of 
LM, e.g.

$ vdpa dev add name vdpa1 mgmtdev pci/0000:41:04.2 max_vqp 7 mtu 2000
$ vdpa dev show vdpa1
vdpa1: type network mgmtdev pci/0000:41:04.2 vendor_id 5555 max_vqs 15 
max_vq_size 256
   max_vqp 7 mtu 2000
   dev_features CSUM GUEST_CSUM MTU HOST_TSO4 HOST_TSO6 STATUS CTRL_VQ 
MQ CTRL_MAC_ADDR VERSION_1 RING_PACKED

For it to work, you'd want to pass "struct vdpa_dev_set_config" to 
_vdpa_register_device() during registration, and get it saved there in 
"struct vdpa_device". Then in vdpa_dev_fill() show each field 
conditionally subject to "struct vdpa_dev_set_config.mask".

Thanks,
-Siwei
>
> Thanks
> Zhu Lingshan
>>
>>>>> Nope:
>>>>>
>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>
>>>>> ...
>>>>>
>>>>> For optional configuration space fields, the driver MUST check that the corresponding feature is offered
>>>>> before accessing that part of the configuration space.
>>>>
>>>> and how many driver bugs taking wrong assumption of the validity of 
>>>> config space field without features_ok. I am not sure what use case 
>>>> you want to expose config resister values for before features_ok, 
>>>> if it's mostly for live migration I guess it's probably heading a 
>>>> wrong direction.
>>>>
>>>>
>>>>>>
>>>>>>
>>>>>> Last but not the least, this "vdpa dev config" command was not 
>>>>>> designed to display the real config space register values in the 
>>>>>> first place. Quoting the vdpa-dev(8) man page:
>>>>>>
>>>>>>> vdpa dev config show - Show configuration of specific device or 
>>>>>>> all devices.
>>>>>>> DEV - specifies the vdpa device to show its configuration. If 
>>>>>>> this argument is omitted all devices configuration is listed.
>>>>>> It doesn't say anything about configuration space or register 
>>>>>> values in config space. As long as it can convey the config 
>>>>>> attribute when instantiating vDPA device instance, and more 
>>>>>> importantly, the config can be easily imported from or exported 
>>>>>> to userspace tools when trying to reconstruct vdpa instance 
>>>>>> intact on destination host for live migration, IMHO in my 
>>>>>> personal interpretation it doesn't matter what the config space 
>>>>>> may present. It may be worth while adding a new debug command to 
>>>>>> expose the real register value, but that's another story.
>>>>> I am not sure getting your points. vDPA now reports device feature 
>>>>> bits(device_features) and negotiated feature 
>>>>> bits(driver_features), and yes, the drivers features can be a 
>>>>> subset of the device features; and the vDPA device features can be 
>>>>> a subset of the management device features.
>>>> What I said is after unblocking the conditional check, you'd have 
>>>> to handle the case for each of the vdpa attribute when feature 
>>>> negotiation is not yet done: basically the register values you got 
>>>> from config space via the vdpa_get_config_unlocked() call is not 
>>>> considered to be valid before features_ok (per-spec). Although in 
>>>> some case you may get sane value, such behavior is generally 
>>>> undefined. If you desire to show just the device_features alone 
>>>> without any config space field, which the device had advertised 
>>>> *before feature negotiation is complete*, that'll be fine. But 
>>>> looks to me this is not how patch has been implemented. Probably 
>>>> need some more work?
>>> They are driver_features(negotiated) and the device_features(which 
>>> comes with the device), and the config space fields that depend on 
>>> them. In this series, we report both to the userspace.
>> I fail to understand what you want to present from your description. 
>> May be worth showing some example outputs that at least include the 
>> following cases: 1) when device offers features but not yet 
>> acknowledge by guest 2) when guest acknowledged features and device 
>> is yet to accept 3) after guest feature negotiation is completed 
>> (agreed upon between guest and device).
> Only two feature sets: 1) what the device has. (2) what is negotiated
>>
>> Thanks,
>> -Siwei
>>>>
>>>> Regards,
>>>> -Siwei
>>>>
>>>>>>
>>>>>> Having said, please consider to drop the Fixes tag, as appears to 
>>>>>> me you're proposing a new feature rather than fixing a real issue.
>>>>> it's a new feature to report the device feature bits than only 
>>>>> negotiated features, however this patch is a must, or it will 
>>>>> block the device feature bits reporting. but I agree, the fix tag 
>>>>> is not a must.
>>>>>>
>>>>>> Thanks,
>>>>>> -Siwei
>>>>>>
>>>>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>>>
>>>>>>>> Users may want to query the config space of a vDPA device, to choose a
>>>>>>>> appropriate one for a certain guest. This means the users need to read the
>>>>>>>> config space before FEATURES_OK, and the existence of config space
>>>>>>>> contents does not depend on FEATURES_OK.
>>>>>>>>
>>>>>>>> The spec says:
>>>>>>>> The device MUST allow reading of any device-specific configuration field
>>>>>>>> before FEATURES_OK is set by the driver. This includes fields which are
>>>>>>>> conditional on feature bits, as long as those feature bits are offered by the
>>>>>>>> device.
>>>>>>>>
>>>>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if FEATURES_OK)
>>>>>>> Fix is fine, but fixes tag needs correction described below.
>>>>>>>
>>>>>>> Above commit id is 13 letters should be 12.
>>>>>>> And
>>>>>>> It should be in format
>>>>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if FEATURES_OK")
>>>>>>>
>>>>>>> Please use checkpatch.pl script before posting the patches to catch these errors.
>>>>>>> There is a bot that looks at the fixes tag and identifies the right kernel version to apply this fix.
>>>>>>>
>>>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>> ---
>>>>>>>>   drivers/vdpa/vdpa.c | 8 --------
>>>>>>>>   1 file changed, 8 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
>>>>>>>> struct sk_buff *msg, u32 portid,  {
>>>>>>>>   	u32 device_id;
>>>>>>>>   	void *hdr;
>>>>>>>> -	u8 status;
>>>>>>>>   	int err;
>>>>>>>>
>>>>>>>>   	down_read(&vdev->cf_lock);
>>>>>>>> -	status = vdev->config->get_status(vdev);
>>>>>>>> -	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>>>> -		NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>>>>>>> completed");
>>>>>>>> -		err = -EAGAIN;
>>>>>>>> -		goto out;
>>>>>>>> -	}
>>>>>>>> -
>>>>>>>>   	hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>>>>>>>>   			  VDPA_CMD_DEV_CONFIG_GET);
>>>>>>>>   	if (!hdr) {
>>>>>>>> --
>>>>>>>> 2.31.1
>>>>>>> _______________________________________________
>>>>>>> Virtualization mailing list
>>>>>>> Virtualization@lists.linux-foundation.org
>>>>>>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>>>>>>
>>>>>
>>>>
>>>
>>
>

