Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D1058480B
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 00:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbiG1WMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 18:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiG1WMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 18:12:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC532E9E6
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 15:12:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SKIxUV009598;
        Thu, 28 Jul 2022 22:12:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=a0XWmn+c7INafZGtHv80lNY/Smc/DDMauasaH9K+O9A=;
 b=NZJo6HDBqQLjnwWTt6FtRA2UBWk+9Lg74NdODPlBDw1ODzPAHoRDX9bQvcWLujBh1ARP
 B/RYinzllnJqEUlH7y4HfxWydtU0vkzPj9moBZFF7q7OY5tZgxuy27mHxEwxA8dVu3Gr
 WzRw8k3ZR6F44zkFswhZxAnCq+O2yXxsmfe0YgAiHSCNyXGKBKfVF3drDSqD7eOhsayP
 A88lmDMltVlVsiyX7gju/RTbWb6BQdeQbjoGren5Uxa7P14THTMpIDesj/Bf1UG4XcTB
 Rhn5E6j79CqzNtjOcTPCzAtOUQFtBiDE2Vh7+Kcf+PzkK/J1x6+c8i3huMpai52bpAIz eA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg940wgpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 22:12:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26SLuwui023012;
        Thu, 28 Jul 2022 22:12:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hh5yy08b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 22:12:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XUPzrfFdaJ/RnX+Xt9Plo2ptqgmoejvFV4n8K6Z3dI2xc2dkZUCDR04tPgyxu9puvnMbWfuyD40nQLvQoMGigzM5AtvToVxIDPkYnpq3+K32VV3X8u02tFIoXKB0Xpy6jMbGrgcYr9dYw9odBgNC5I52zD0TsNLUKYga/RWlRl+gsNgWEQ24W5m/zAXBqIgMXPooczLZ9U4tQi3K5ygWP1IwwjjGRYcRRhWjIJMl392oxZ/7KPEuLyA9leVXkdpsqBsiqtPfolkCv7ufUiOiwF1JN2orsxf6162DXmsHTnSkt17IM1/amASR0YlJ0mRzRucXAsIA3XHtNQxGU49n9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0XWmn+c7INafZGtHv80lNY/Smc/DDMauasaH9K+O9A=;
 b=QfDFvi10fx0o33ThA3seq3lTRAdqRaVr+tLmycujbEl43n96dEeDrBn5iMEN+mbfZnNisYdVpWLBVV+jCGpgTbcUAOe5DbmpJ5XjopQTy9sk4JoQLe7Oq0lwQTBT1ZIRoCgQfTA7/UQMgvB6kzxXQaCnL38iJzg2Ib3VYyRoWsge3iR6fUc5EGYi74Fxb4Zb22rYCTUJPbm2HFpaP8kga1rcR7ii0dH0iGHwMGQmegxVmGm9g+vrGb36ImrPvECeIvRCsIgukSX+xY/HRotiLH5BZ2LzhJN5DzEcNGPHQJ3bapW3VBH30G7CU1cy0mU0O9qK48Awof5GXpTVaCreQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0XWmn+c7INafZGtHv80lNY/Smc/DDMauasaH9K+O9A=;
 b=aQSb0nNXxI5029WLhhRAQwBcIlCylsMY8yWP2zNPBsLQw+Beqq4ZrZPYddUvLge2t/oBdeYly8C/3RJAtGbWR5T74+xtT1S3fZwrEm03oJf6hy5zf26egkWfzKJXi5mqECy2pOx1IcZK77Lpa/IKQBRSxJwWxkXLi0tPfb015zk=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by DM5PR1001MB2347.namprd10.prod.outlook.com (2603:10b6:4:2e::38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 22:12:10 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803%4]) with mapi id 15.20.5458.026; Thu, 28 Jul 2022
 22:12:10 +0000
Message-ID: <65f1ae9b-9bc7-8ddc-337c-0ca5fa328131@oracle.com>
Date:   Thu, 28 Jul 2022 15:12:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
 <f3fd203d-a3ad-4c36-ddbc-01f061f4f99e@oracle.com>
 <20220728070409-mutt-send-email-mst@kernel.org>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20220728070409-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::30) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b9478e3c-d054-48b4-d3e5-08da70e63786
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2347:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHuDABUoKXkLR5l095E0KbwXeyDeqqaIZCwwkY7zcoqM6WTGGeYmiTT03GDhrXQXUVn6FCKtk2g0q51upNPuJn7tW5Qzrk7vKTbkj5KJ1aEqQNaHiBQ1L+FeLEmVGtUVzJJ6Mtfh4ujRFd7+i7nSo2WvE7yBRUjmXdzlI3Z/g3JWAFZ80j5o58mljrcMhGXWATv9ZIDjuQTuv6f1r9IjUk8N1cP9RwtWNnLQOsvQN7c8+EmGIPocRqGYowkmdGAFkCCOatZ1Of7ea1n6dIR2Q6Ld2U2+MroSWmz5TC0pgnLA3rYtsuXCYNH0NIYoGTGS2c7KSSuztJW25RqGiXXhceBvAimwwRTjTLRMx1wObQCWgL5mzrIvtwjNpbAB8FDDoGw8fKz5Lq4NgGT/6ggHYhbW23rgfn4msAGqR6bK5CsF/0xyYj1Bee6DQztCdThGvF7JW244Qp7HxAF8t435cFX4VXQDYS2L5kYO2pTso1KLb83VRV3CK4eFh3vtCUi991huRdOuEdowbO+ylZRFnyMXvm/SNuFPHPbbnsAXpjJzMXSuiQns5q3mrj8oSzhWQCUk3xuM8EthaBuJZvn7Sc6Orv0/s/b4jjvIl15TEdWBQnFdPxa9OyyT7Gz1mNcdJ34B4autl4M5jWheZfn/X7ll4jg20Lcu4Zx2+Emie3blQXdfK94JKs14fwlEy9N8D9+ixdvgcfmOsa92bwyV9E5RK9gmlG71FiG2Zat/BUi2sx9YQhA+Ng+kZqrkzSlSKmDKvyeabPof1ehpeWjYzxWdJwayTInh2Ajy/D9rOx/YXrn/KF30am1BzyF/VxyoUUsjM40M5VF4GIdibMRcvz7WWnQjkfJF3H8LgQ693Gs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(39860400002)(136003)(366004)(396003)(186003)(53546011)(2616005)(36916002)(26005)(6512007)(30864003)(6506007)(38100700002)(5660300002)(2906002)(8936002)(966005)(4326008)(66476007)(54906003)(6666004)(83380400001)(8676002)(41300700001)(36756003)(6486002)(478600001)(6916009)(66946007)(66556008)(31696002)(316002)(31686004)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHFpK2xjS2ZjamtQdFBFRzZ0VlJZYkt0dWxjTlhWek40VldEZWJ2Zkk4YkJP?=
 =?utf-8?B?SEJXSnNObk9ZVUQ5WUdMNXJxY0Ntd1FqYThJblo1cUZqZ0JiM2QwaEF1U0RM?=
 =?utf-8?B?NktPbmM5UUxTbHNraGNLenc5UUhIdVdoOXNucFBINXk3azVQZzVkWnpGRXVM?=
 =?utf-8?B?dzVtdGdMWDRWVTR5OXAxVmIzNGF2ekpnbXNDa0kzWmVWM2NRNEhWbGdzQzZX?=
 =?utf-8?B?eUdNVlNUYlRYSzNsZ2IxdHRBdlYyWHpLNHYyUVE1Y1ZaWFJZUG5YSmF5Q2N6?=
 =?utf-8?B?b2JGSFNJajhXYXREU2x2WVpyY1pQN3lyRnkzZWVmcnhjd2psKzZWeUgxSml1?=
 =?utf-8?B?VlBmTHV1Q3Zjb3VFaXd1OWlCYy91MnYvSHYyY1J3SjJUbEgxZ0grelE4b0do?=
 =?utf-8?B?ZHBHZUNpcGV1VXV0dWtJcU5RcEt1ZitoWk5SMjdJRkIxN2F1Y0JERGpjbi9Z?=
 =?utf-8?B?VHZhMUZOU05RSTBBR0p1b2JDMUdrQVZ3Z1dsNWU1RjhIaklKMTRxb1paUlNw?=
 =?utf-8?B?UUR3cFJyK0NRdFdhaVdRa3dPbW5JdmxkRk9IdjJFb1FWSVdwamJKOUxjN3Vx?=
 =?utf-8?B?czdPK3Y0WjJ3Y2k0SGw3K085Qm9iaUUzS2NvZjRiRzA0RzczY0NVR0pBem1G?=
 =?utf-8?B?WEZZSGxJQnhGNmxBOVA3bDNOSXhUbGhZeTQ0MVlFaFB5c1gvVHlhQlVmMlpW?=
 =?utf-8?B?bzNJdTBlbFNPL2phZ29QYjFSQmRtT2Z4aW9FOUIvcUpPSGRUVmxDSDNCUzZu?=
 =?utf-8?B?dWF5VlhVdk1wU1Q0TWFJc1MxVmVncDhhd0N4TjF5VVczRFpSbHArOEF0b3lz?=
 =?utf-8?B?YnNtZytuc3hOUXIwTUVLMUQwaWdGZ1lCelRWSzhJRHlzQzdreFN0aWNRbFQ4?=
 =?utf-8?B?S29tVUxRRmdYWVo2eW4rNjlVVndsT0FWbUg1eHdMbUZ5VXBxTkc4VzVKYU00?=
 =?utf-8?B?OE42TlVQK1ozaW5LRU5LSGRCZ2pYUXUvT3lYbnhHY2s1NHJ5cTVnRTBwYjlB?=
 =?utf-8?B?cFZvSUtWNWhTRXBHVTA0dC9zWHNRaEVXQmpSYjFnSFNTT2RxTkJMWjNMNDFE?=
 =?utf-8?B?Ny90Z2RhTk92RHNkUGFaRzBMeFBOditoNnRBNjBMYUJybXZvTUg2UW9ZTGdY?=
 =?utf-8?B?NmRpUUJnRHNXWGxMRHdSWC9nZURVeXBSRE1oWk5qSitaVEhOTXlUeTk3ejlY?=
 =?utf-8?B?VnVxZzVTcm9WYm55cFBQSWkyVGR0WU01NmNVODZ2cjBzb1QxUDNEcWhCbFIv?=
 =?utf-8?B?aHB4TUpqeWJsT25adi9FWUxkcEJxUjZJcDRLclU0YmYzMWMzenJvci8vNkZH?=
 =?utf-8?B?bmdyZDgvN05vdE0zNXBaWGFmbUhOWEVxRWo2WTJPMmx2QUJ0RDVwRzAzZkZy?=
 =?utf-8?B?N2FBOTZaWHdYN0RQR3FtWnU0WC9KajRvZHhzY014MUJNTjYwYkdQck5kWnAz?=
 =?utf-8?B?TnY2SnphSnZKYjdWdlo5ZktqREhoaXBVbUJKNHhFTmd2V096UVJzMkNUUDQ2?=
 =?utf-8?B?dWpER3JXWGI4dnMzTXJzd2sycGxDdUhEellSbVEyQkNwTzFDYjEraGUxOWtw?=
 =?utf-8?B?cnVJa0JPbTNKL3RmK01QN01FRUoyelE4UVF2N1lQZGh6eTJqVG5SYXgreTRn?=
 =?utf-8?B?TnBVcm5NU1R2cDJHTWNGOTJGd2hOQXdiRlZ5d2Y3OHBmMnRiejQzdEt6NWds?=
 =?utf-8?B?dWsyZUxVTFJLYklZM3RaNXc5Tm00OFA5c2NFZmpzUERoSm4zaEI2dk5pNHpr?=
 =?utf-8?B?ZXJwemFXdXEyZWdVajNTMjB4VVJIQ3E5eTJqRnNmWnRuZ2pOekJGYXNzYmEv?=
 =?utf-8?B?c3VvVXlmS3RuZVJhMmZnY21KbkZHWnVNUWUxSFo5V1BkcitsbEh4OU50N2I5?=
 =?utf-8?B?OG0yZEdaeXRERFEzTzg3V2ZSSCtObDJTS2JTa0lEaGtsaVhDWTN1cHBxckNk?=
 =?utf-8?B?NE9vbjc3NFlTNmxFOE1WbXUzMlZ5YWJqN3dJUS9OT3V4dDM2QklxQ3VqaFBa?=
 =?utf-8?B?OW9JNUppMzF1Tm13ZGlIaVEvYlR6VUQvckRpY2NLa2pVUHNBajNkUjgvNnBC?=
 =?utf-8?B?RXF1YXdqc0VQRFg4Z01zRVhSdWp5eDNJenpOYVVnQzJ6OXBENk9rcWNMdTlu?=
 =?utf-8?Q?PGqrXzUkPjzt7xr8QR6QqUSsM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9478e3c-d054-48b4-d3e5-08da70e63786
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 22:12:10.4593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aaTeSbKQGfTuPWysO3LYXQgNp7xLvEyQ1ADQxWqwet3ZESX3a+8fouIbs6TOFjLW3U137EBy5sa9WLiQheD4kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207280099
X-Proofpoint-GUID: LGopwkBm7DTc0kNXxBdsGXRSAzGieteL
X-Proofpoint-ORIG-GUID: LGopwkBm7DTc0kNXxBdsGXRSAzGieteL
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2022 4:35 AM, Michael S. Tsirkin wrote:
> On Thu, Jul 28, 2022 at 12:08:53AM -0700, Si-Wei Liu wrote:
>>
>> On 7/27/2022 7:06 PM, Jason Wang wrote:
>>> 在 2022/7/28 08:56, Si-Wei Liu 写道:
>>>>
>>>> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>>>>
>>>>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>>>>> Sorry to chime in late in the game. For some reason I
>>>>>> couldn't get to most emails for this discussion (I only
>>>>>> subscribed to the virtualization list), while I was taking
>>>>>> off amongst the past few weeks.
>>>>>>
>>>>>> It looks to me this patch is incomplete. Noted down the way
>>>>>> in vdpa_dev_net_config_fill(), we have the following:
>>>>>>           features = vdev->config->get_driver_features(vdev);
>>>>>>           if (nla_put_u64_64bit(msg,
>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>>>>                                 VDPA_ATTR_PAD))
>>>>>>                   return -EMSGSIZE;
>>>>>>
>>>>>> Making call to .get_driver_features() doesn't make sense
>>>>>> when feature negotiation isn't complete. Neither should
>>>>>> present negotiated_features to userspace before negotiation
>>>>>> is done.
>>>>>>
>>>>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill()
>>>>>> probably should not show before negotiation is done - it
>>>>>> depends on driver features negotiated.
>>>>> I have another patch in this series introduces device_features
>>>>> and will report device_features to the userspace even features
>>>>> negotiation not done. Because the spec says we should allow
>>>>> driver access the config space before FEATURES_OK.
>>>> The config space can be accessed by guest before features_ok doesn't
>>>> necessarily mean the value is valid.
>>>
>>> It's valid as long as the device offers the feature:
>>>
>>> "The device MUST allow reading of any device-specific configuration
>>> field before FEATURES_OK is set by the driver. This includes fields
>>> which are conditional on feature bits, as long as those feature bits are
>>> offered by the device."
>> I guess this statement only conveys that the field in config space can be
>> read before FEATURES_OK is set, though it does not *explicitly* states the
>> validity of field.
>>
>> And looking at:
>>
>> "The mac address field always exists (though is only valid if
>> VIRTIO_NET_F_MAC is set), and status only exists if VIRTIO_NET_F_STATUS is
>> set."
>>
>> It appears to me there's a border line set between "exist" and "valid". If I
>> understand the spec wording correctly, a spec-conforming device
>> implementation may or may not offer valid status value in the config space
>> when VIRTIO_NET_F_STATUS is offered, but before the feature is negotiated.
>> On the other hand, config space should contain valid mac address the moment
>> VIRTIO_NET_F_MAC feature is offered, regardless being negotiated or not. By
>> that, there seems to be leeway for the device implementation to decide when
>> config space field may become valid, though for most of QEMU's software
>> virtio devices, valid value is present to config space the very first moment
>> when feature is offered.
>>
>> "If the VIRTIO_NET_F_MAC feature bit is set, the configuration space mac
>> entry indicates the “physical” address of the network card, otherwise the
>> driver would typically generate a random local MAC address."
>> "If the VIRTIO_NET_F_STATUS feature bit is negotiated, the link status comes
>> from the bottom bit of status. Otherwise, the driver assumes it’s active."
>>
>> And also there are special cases where the read of specific configuration
>> space field MUST be deferred to until FEATURES_OK is set:
>>
>> "If the VIRTIO_BLK_F_CONFIG_WCE feature is negotiated, the cache mode can be
>> read or set through the writeback field. 0 corresponds to a writethrough
>> cache, 1 to a writeback cache11. The cache mode after reset can be either
>> writeback or writethrough. The actual mode can be determined by reading
>> writeback after feature negotiation."
>> "The driver MUST NOT read writeback before setting the FEATURES_OK device
>> status bit."
>> "If VIRTIO_BLK_F_CONFIG_WCE is negotiated but VIRTIO_BLK_F_FLUSH is not, the
>> device MUST initialize writeback to 0."
>>
>> Since the spec doesn't explicitly mandate the validity of each config space
>> field when feature of concern is offered, to be safer we'd have to live with
>> odd device implementation. I know for sure QEMU software devices won't for
>> 99% of these cases, but that's not what is currently defined in the spec.
>
> Thanks for raising this subject. I started working on this in April:
>
> https://urldefense.com/v3/__https://lists.oasis-open.org/archives/virtio-comment/202201/msg00068.html__;!!ACWV5N9M2RV99hQ!Os6QE_RJokx7Us9y7-5-ByVVLuy3oLuPodAdZWxwJw_aNkJY0o0H7691FI9aYSTRLVieASUD_eOu$
>
> working now to address the comments.
Great, thank you very much!

Is there a link to the latest draft that reflects the change uptodate? 
The one above with iterative feature negotiation seemed getting some 
resistance because of backward incompatibility with older spec? Please 
copy me in the loop when you have the draft ready. I am not in the 
virtio-comment list.

Thanks,
-Siwei
>
>
>>>
>>>> You may want to double check with Michael for what he quoted earlier:
>>>>> Nope:
>>>>>
>>>>> 2.5.1  Driver Requirements: Device Configuration Space
>>>>>
>>>>> ...
>>>>>
>>>>> For optional configuration space fields, the driver MUST check
>>>>> that the corresponding feature is offered
>>>>> before accessing that part of the configuration space.
>>>> and how many driver bugs taking wrong assumption of the validity of
>>>> config space field without features_ok. I am not sure what use case
>>>> you want to expose config resister values for before features_ok, if
>>>> it's mostly for live migration I guess it's probably heading a wrong
>>>> direction.
>>>
>>> I guess it's not for migration.
>> Then what's the other possible use case than live migration, were to expose
>> config space values? Troubleshooting config space discrepancy between vDPA
>> and the emulated virtio device in userspace? Or tracking changes in config
>> space across feature negotiation, but for what? It'd be beneficial to the
>> interface design if the specific use case can be clearly described...
>>
>>
>>> For migration, a provision with the correct features/capability would be
>>> sufficient.
>> Right, that's what I thought too. It doesn't need to expose config space
>> values, simply exporting all attributes for vdpa device creation will do the
>> work.
>>
>> -Siwei
>>
>>> Thanks
>>>
>>>
>>>>
>>>>>>
>>>>>> Last but not the least, this "vdpa dev config" command was
>>>>>> not designed to display the real config space register
>>>>>> values in the first place. Quoting the vdpa-dev(8) man page:
>>>>>>
>>>>>>> vdpa dev config show - Show configuration of specific
>>>>>>> device or all devices.
>>>>>>> DEV - specifies the vdpa device to show its
>>>>>>> configuration. If this argument is omitted all devices
>>>>>>> configuration is listed.
>>>>>> It doesn't say anything about configuration space or
>>>>>> register values in config space. As long as it can convey
>>>>>> the config attribute when instantiating vDPA device
>>>>>> instance, and more importantly, the config can be easily
>>>>>> imported from or exported to userspace tools when trying to
>>>>>> reconstruct vdpa instance intact on destination host for
>>>>>> live migration, IMHO in my personal interpretation it
>>>>>> doesn't matter what the config space may present. It may be
>>>>>> worth while adding a new debug command to expose the real
>>>>>> register value, but that's another story.
>>>>> I am not sure getting your points. vDPA now reports device
>>>>> feature bits(device_features) and negotiated feature
>>>>> bits(driver_features), and yes, the drivers features can be a
>>>>> subset of the device features; and the vDPA device features can
>>>>> be a subset of the management device features.
>>>> What I said is after unblocking the conditional check, you'd have to
>>>> handle the case for each of the vdpa attribute when feature
>>>> negotiation is not yet done: basically the register values you got
>>>> from config space via the vdpa_get_config_unlocked() call is not
>>>> considered to be valid before features_ok (per-spec). Although in
>>>> some case you may get sane value, such behavior is generally
>>>> undefined. If you desire to show just the device_features alone
>>>> without any config space field, which the device had advertised
>>>> *before feature negotiation is complete*, that'll be fine. But looks
>>>> to me this is not how patch has been implemented. Probably need some
>>>> more work?
>>>>
>>>> Regards,
>>>> -Siwei
>>>>
>>>>>> Having said, please consider to drop the Fixes tag, as
>>>>>> appears to me you're proposing a new feature rather than
>>>>>> fixing a real issue.
>>>>> it's a new feature to report the device feature bits than only
>>>>> negotiated features, however this patch is a must, or it will
>>>>> block the device feature bits reporting. but I agree, the fix
>>>>> tag is not a must.
>>>>>> Thanks,
>>>>>> -Siwei
>>>>>>
>>>>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>>>
>>>>>>>> Users may want to query the config space of a vDPA
>>>>>>>> device, to choose a
>>>>>>>> appropriate one for a certain guest. This means the
>>>>>>>> users need to read the
>>>>>>>> config space before FEATURES_OK, and the existence of config space
>>>>>>>> contents does not depend on FEATURES_OK.
>>>>>>>>
>>>>>>>> The spec says:
>>>>>>>> The device MUST allow reading of any device-specific
>>>>>>>> configuration field
>>>>>>>> before FEATURES_OK is set by the driver. This
>>>>>>>> includes fields which are
>>>>>>>> conditional on feature bits, as long as those
>>>>>>>> feature bits are offered by the
>>>>>>>> device.
>>>>>>>>
>>>>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device
>>>>>>>> configuration only if FEATURES_OK)
>>>>>>> Fix is fine, but fixes tag needs correction described below.
>>>>>>>
>>>>>>> Above commit id is 13 letters should be 12.
>>>>>>> And
>>>>>>> It should be in format
>>>>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration
>>>>>>> only if FEATURES_OK")
>>>>>>>
>>>>>>> Please use checkpatch.pl script before posting the
>>>>>>> patches to catch these errors.
>>>>>>> There is a bot that looks at the fixes tag and
>>>>>>> identifies the right kernel version to apply this fix.
>>>>>>>
>>>>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>>>>> ---
>>>>>>>>    drivers/vdpa/vdpa.c | 8 --------
>>>>>>>>    1 file changed, 8 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
>>>>>>>> struct sk_buff *msg, u32 portid,  {
>>>>>>>>        u32 device_id;
>>>>>>>>        void *hdr;
>>>>>>>> -    u8 status;
>>>>>>>>        int err;
>>>>>>>>
>>>>>>>>        down_read(&vdev->cf_lock);
>>>>>>>> -    status = vdev->config->get_status(vdev);
>>>>>>>> -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>>>> -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>>>>>>> completed");
>>>>>>>> -        err = -EAGAIN;
>>>>>>>> -        goto out;
>>>>>>>> -    }
>>>>>>>> -
>>>>>>>>        hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>>>>>>>>                  VDPA_CMD_DEV_CONFIG_GET);
>>>>>>>>        if (!hdr) {
>>>>>>>> -- 
>>>>>>>> 2.31.1
>>>>>>> _______________________________________________
>>>>>>> Virtualization mailing list
>>>>>>> Virtualization@lists.linux-foundation.org
>>>>>>> https://urldefense.com/v3/__https://lists.linuxfoundation.org/mailman/listinfo/virtualization__;!!ACWV5N9M2RV99hQ!Pkwym7OAjoDucUqs2fAwchxqL8-BGd6wOl-51xcgB_yCNwPJ_cs8A1y-cYmrLTB4OBNsimnZuqJPcvQIl3g$
>>>>>>

