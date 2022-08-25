Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986255A1C46
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244410AbiHYWZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 18:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244504AbiHYWZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 18:25:10 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CCA356D3;
        Thu, 25 Aug 2022 15:25:07 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27PLJnAO025354;
        Thu, 25 Aug 2022 22:24:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CrSvDfKLsnhvFBEdR3ccK9AsYyGgaIEWeMVOhIyWQxA=;
 b=F0SLtV4QWrUvtZ50QL90StoLVn0zC1LvycnGujrEKvS3r2XAhmpzBi9+4YBdDhq9PdgZ
 wpripwKl1/Kg0mMZIcqX/1M/YG/mFgrPeFjSIohCbgGldkPe6fgwM4kYpceoHTLw7O4T
 gFDGUaqurGUiOSfHH/536sZlE6h3mNT7mSD2Tp+CF4QdZPg16CDSCiTY/x/7a1+J+AGN
 HYRf7bwMTq6JZH1W3B+Xp3QCTX/NeTl9ljGipjsVEB63PTdOHnHhmP3sZ9p72tW9lrqB
 hImSU01vQgxD1imHqQAhF0l6o3r6utXIRFUi+nj+KtC2tnytX/OqAM7ocJ6hVkB0aeGe kw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4w24038x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 22:24:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27PK0S4K039640;
        Thu, 25 Aug 2022 22:24:58 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n4n23f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Aug 2022 22:24:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lIzB0OUkbYfUmYB6aMQzfCjsJlK+gHZYxFOj4S0sTqyF5HMb1U3wuYCdt0FeaWZnQmEaTqLZUCL+ZoaEGcR/YjxY4bm3rQJ6oOroodcvtFrlWcmZD5OF2O5Vxce2Q7nuQdYM6riGQHBtuAMLPA75UdHSVwCPWCFmMW5p/QuvYQUrJ+8bvl3DFQbY8VMV2bVceXfAFE2zgnlFhN5kJL5IS3XGEEZFuXCWS/C5MIY/nNiRJxGOibPV+R3fdO1iPMJB+C72PEkkIPbqVac6Vmy7MSqK63vM37epVovssy94XBDCa8L65eSOTDq4M/UrXkZQX3z1NMjCKnaUBDqwiaPCjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrSvDfKLsnhvFBEdR3ccK9AsYyGgaIEWeMVOhIyWQxA=;
 b=goyyZYRj0qc0NuCYC5pzAfofrz8A8Qo+BSs+EkshnwutprdpUKFdkXIiQjTM6v5KE7HlzKWqgkjfuvMNsrR4rTBOG6u8csoR6WYg5zZ1wtB4JC4L0QZahE+yEJ3/8kq21X91omBlJkbz09CIOfFGavXuWZgC8knIi1auQa/35xZCEIZ2btyVPbB+WKJqZNYkR4LqF3nwfy3W4HPuhOdIFEcwMCUotS8CTwIochxDcQUbDMCqNWmkmrPmN4sq/SJhFJPtpMCPcoEu3J9YLa3zVvaZKYQ9hWmDWFXD+U0xfc2sDyzr05DtFYAjDBd0Rbj5KacHJxStclSc4GIm3QJeCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrSvDfKLsnhvFBEdR3ccK9AsYyGgaIEWeMVOhIyWQxA=;
 b=ymzOyjRFFtN0qVJLd7qsdaTY/LEkOqRJIVLPOhb6Yw44OrWkmwXXobWhwn1BpU37DqZiw7P74xqOKdB0e6kxf2Mjw8EXk92TJZgL2FE9oxbcwQlAiwR/9FA1D20Ad9RlIN8xRKTp/7JZ9jhXesHYakX6pXkoi+CowNTY1T+cMPg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN7PR10MB2516.namprd10.prod.outlook.com (2603:10b6:406:c1::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Thu, 25 Aug
 2022 22:24:51 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::2077:5586:566a:3189%4]) with mapi id 15.20.5546.021; Thu, 25 Aug 2022
 22:24:51 +0000
Message-ID: <b230f8e1-1519-3164-fe0e-abf1aa55e5d4@oracle.com>
Date:   Thu, 25 Aug 2022 23:24:39 +0100
Subject: Re: [PATCH V4 vfio 04/10] vfio: Add an IOVA bitmap support
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>
Cc:     jgg@nvidia.com, saeedm@nvidia.com, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, kevin.tian@intel.com,
        leonro@nvidia.com, maorg@nvidia.com, cohuck@redhat.com
References: <20220815151109.180403-1-yishaih@nvidia.com>
 <20220815151109.180403-5-yishaih@nvidia.com>
 <20220825132701.07f9a1c3.alex.williamson@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20220825132701.07f9a1c3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P251CA0026.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:b5::30) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d7e90ff-bb07-4b55-115e-08da86e89d50
X-MS-TrafficTypeDiagnostic: BN7PR10MB2516:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LsSP4clGJ5eAbbX+dp7hwfsk0VAf1kYHs6pJuOxcrAuvYvHrOT6VeL25hep3nO0Hkk7jGzYVt8uJ3+rcZ62j3L26djCZoqReFo5mFjSa0PGK28yOrRsKhJSQ6oydLVzo/I8kCgYBvi1uy1+VPavh4Iie9C1NskjmLaIboX/hPSrIFABbpBnsrBlNwGt8ojNUyoUUzUDpc84r8+TyGpdgCgB5mA9thcduKSlFhBpQ2i0d7znmPUB83YbvTSp19E28NwFkArVpwQTqCpXbSP1NVu9ybLx0vFmxhCHofSTtujTa03f5aZoyOLQ/V8243AMr/ChHKLU8nQtCdDWth9jQG/WS1sjwy+Z+kW1sbYY+sn3gOPjWzTbDNHcl4pByxqccDXjpQrV2p4+e55VyZs4yXBfI01PB49phvPEgmw6DQ0Dpba1wbkP+lBHVRDJ40DPHqN6GAkMCrxZM2fTANdSjVilcvDKxZWCWEqBiFhnPFeUUcK7IjEJcJO98pV29i2kFjnTs5Io1lfKHYDysy7t5HIRQu4t0AT5C1H/xp6L1ELduJ98FUPXYVP8OllxfqdBFkN9H0EvCC4wZiRAuOJHQNsGHflAmDMB6rNM0pJ9QcwjeWuMZykeXjQRZzi60tYar4JokPMD1pZb8+xSeWSA+eLJM9PBamhWNoBeRHdnrzPLnwU0l3sZ9ewzg006iHvH5VFW0MOCaz2qao4VWA40dDz1gFG6M5HBr1snBYndZqKdYaAiZYq7xk6E7apuqTvkQtCqJ4+BOJu03xR3psTgRxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(376002)(346002)(366004)(136003)(6506007)(6512007)(5660300002)(6666004)(26005)(53546011)(31696002)(86362001)(478600001)(2906002)(6486002)(41300700001)(7416002)(8936002)(30864003)(186003)(38100700002)(83380400001)(2616005)(4326008)(110136005)(316002)(8676002)(36756003)(66556008)(66476007)(31686004)(66946007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVY5ZmhINjJXRDJ2cjZLamdsUjhScTJYVDdHREEvUGZGOElIMm04MUpjbVJX?=
 =?utf-8?B?UmYwN0Z5MElJUWFENVgxVlVmeG9kZC9taGE5R2hHR3RjRndmVy94NVRLQXhV?=
 =?utf-8?B?d2ZYdm5LSUFpOFhrdHpMSGZyT2Nkb2V5Q2toMjg3bnhwWngyby9RT21PZmdz?=
 =?utf-8?B?VEg1Z0Q4dFAvZnh2MnpFb1ZYciswV0NIZGJXZFFKaWR4bmpjNFlweWtKQ0NL?=
 =?utf-8?B?ZmJRSGZ4bUFmRmtFaVNJZVdrR1Q5RldNNEhxYWxtK2ppeWVoNmZFN0FkeDFB?=
 =?utf-8?B?NGVVZ3lPMXJIK0hJdmpoYllkb0xUUUd3RzU0QUFhcmpsTUw0Q08wZ1EvTThE?=
 =?utf-8?B?M2xoMWdJK2NENE5DajcySUxrUmFldDFlOHQ5c1hMUUp5K1NiNXdLWUlHZUJL?=
 =?utf-8?B?VVVrT1FrYWJGeEZ6TGtoeEo0OWdSQTc1MHFvMFZmVkFTKzUyNTkrL1FQVmxT?=
 =?utf-8?B?b0liNmw4bDVTcFFMTWlWUEZjZXhWVWozUDdHMWd1RTF4ak4xRjIyVzJIRE9O?=
 =?utf-8?B?RUY4Y1ZhM3pEZ3BwMjlJRmVYTnpIQ3BYU3g1ZUVYbDdodkNHM1B3Z3RoYXJs?=
 =?utf-8?B?eTkyTW5saStreERPYWNGdHpzUUI2U2FMYU9PQlljMWNnMW1RNUlqa29sdnht?=
 =?utf-8?B?a3h6UTdtejRQeFV5cWcwcUFMTGd5cXBSQmp2ZWJVaUZkUC9ZRDQ1b3NDbGh3?=
 =?utf-8?B?TTVYVUZSYU5pVFd5c01lUVNjelRoVjh1RmNpWHZudG9OK1BwVmNKMmRGTU9K?=
 =?utf-8?B?RllicWdtdGp3cEVoYUtjaWlRZ2MvbjJKVkNTRjV1S2trZE5KSjhOaTdBSEVp?=
 =?utf-8?B?YjUwZWlpMHZGWTdDV2Vka1pWNlh3WkdiSzgzRWlVRzFlVFdQTHY1NzhGWlY2?=
 =?utf-8?B?MTBuVmJlMm1FL3o0eVZ6RWdNdmZ4SkJGd1F1eHI1MkFiSTY0R2NYcitnb1dz?=
 =?utf-8?B?RjJ1UTBqZVErVmFJUWFKR3U1VXdsMzRDVE5JcmlUTVBSRjNZako3SWZ4Z0ZL?=
 =?utf-8?B?dmZ0aSthbllGcHQwNDJRQzl6QkJGZHZHbU83b1p1eEZCTm1xTTNYZ0hYbjNn?=
 =?utf-8?B?OTd5VkFENUp1a0IvS2J6RE5kOXZ0QXdDT1NEZFA5VlFOdXRaYXQyVlRyNDZS?=
 =?utf-8?B?YXQySlE3TGNWSFFMQ0dmbDhramJmOFBwWGpKYkMyT3NvZkdYNTdpMGczNlBW?=
 =?utf-8?B?SnVFN1c2NndyYWkrRzIzWTNGVHJnSk42YmZwSVpmMmNnRU1kRVB6YXlpUm5D?=
 =?utf-8?B?eVo5TWM2M1VGWkhPNk1RU0xTOFpid3p3eVBvWEs0VHhvOWJIcG50R0tNcTg2?=
 =?utf-8?B?VWxJbDFyWTFYQkkwNTdVQXc3aFdraW9ENXA0ZVFvSzBhWVJ2MllQNS8rTlk5?=
 =?utf-8?B?eE5KUEhMUlZtYWd6WFhwK01JTUUrWHMxSmNBbmdYWG92TEphZ2V0Y1V2V1ls?=
 =?utf-8?B?RXFnSmdFODJtTkRrWEpFK3NZSmhYbEE5SmRrWWxrV2xBazNKUWdmOG9BalQ3?=
 =?utf-8?B?ZkhjeWloNFpvNVBuZE1uSkdmQkFlWEYzYWRNcTdYT0FLT3l0V3hHVW4rMjlq?=
 =?utf-8?B?dXJkZ0ZHZHErbk5EeXF0SXdpOFg1Y2dZbHFLWS9tc0F4T0hFRjR4M1Ztc1Jn?=
 =?utf-8?B?bldaWDlYTDdJTk1Xb0oyU1BhbVlMYWdqZmV0SFhCY0dsTSs0UFFiUWNjVGhE?=
 =?utf-8?B?dFFkaVVZdnRKZk8vLzFncVFxZlFDamFDdXhoN0hJK0RpU2VXdEgzcktCaGJw?=
 =?utf-8?B?UFF3dDhkOGszM0JYRWcyQ3FNZ2ZVOS9seXppTjM4QSt6c2JhRjg0NVdRVThz?=
 =?utf-8?B?aHFOemdWZHlzaFV2V05xZWxua2UvdlNvSDV6eEhQOXREaGc1cnBYa1NTby9F?=
 =?utf-8?B?QjBIZ29OR3o1N3dMQ2k4SWhtellTV3VjS1BZczRhZE5Sb3l4NGF1NTVybndV?=
 =?utf-8?B?SHRFd04vdW5WRE1obTNKakx2eXR4VEROVHRKNTM4d3AxcnJwNTVZb1FHMWN5?=
 =?utf-8?B?RWhDL2F2bWxITEdtQlg1ZVd3OG0yMmVlWWpQempkR1VVN0JweU1kU2xWRW5I?=
 =?utf-8?B?aGV6Rk9ubFNIU2JxMCtWekpCaW1kd0FqdEZLRVg2cldrS2c0VWR2V05vaHk4?=
 =?utf-8?B?QVpHOFhEWi9oTHRJU2hnb2I0N2xqVUhOS0NVUEJCOG9NVm1HUHlxU2g5Z1hT?=
 =?utf-8?B?Tnc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7e90ff-bb07-4b55-115e-08da86e89d50
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 22:24:51.8215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTISY6jJ7wN/AgOSp5ljnYxmQIqBEl6RETgVzm5u0s/0L+Q2FtnpvzUfr5Xt84AZefwEI63RE27PjyT0pjuLms/mDL5D9F39/snH9gnMgxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2516
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-25_10,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208250086
X-Proofpoint-ORIG-GUID: aqEY_FlsSUHKDlhMo8pjZjnjcYT1-qGh
X-Proofpoint-GUID: aqEY_FlsSUHKDlhMo8pjZjnjcYT1-qGh
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/22 20:27, Alex Williamson wrote:
> On Mon, 15 Aug 2022 18:11:03 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> From: Joao Martins <joao.m.martins@oracle.com>
>>
>> The new facility adds a bunch of wrappers that abstract how an IOVA
>> range is represented in a bitmap that is granulated by a given
>> page_size. So it translates all the lifting of dealing with user
>> pointers into its corresponding kernel addresses backing said user
>> memory into doing finally the (non-atomic) bitmap ops to change
>> various bits.
>>
>> The formula for the bitmap is:
>>
>>    data[(iova / page_size) / 64] & (1ULL << (iova % 64))
>>
>> Where 64 is the number of bits in a unsigned long (depending on arch)
>>
>> It introduces an IOVA iterator that uses a windowing scheme to minimize
>> the pinning overhead, as opposed to be pinning it on demand 4K at a
> 
> s/ be / /
> 
Will fix.

>> time. So on a 512G and with base page size it would iterate in ranges of
>> 64G at a time, while pinning 512 pages at a time leading to fewer
> 
> "on a 512G" what?  The overall size of the IOVA range is somewhat
> irrelevant here and it's unclear where 64G comes from without reading
> deeper into the series.  Maybe this should be something like:
> 
> "Assuming a 4K kernel page and 4K requested page size, we can use a
> single kernel page to hold 512 page pointers, mapping 2M of bitmap,
> representing 64G of IOVA space."
> 
Much more readable indeed. Will use that.

>> atomics (specially if the underlying user memory are hugepages).
>>
>> An example usage of these helpers for a given @base_iova, @page_size, @length
> 
> Several long lines here that could be wrapped.
> 
It's already wrapped (by my editor) and also at 75 columns. I can do a
bit shorter if that's hurting readability.

>> and __user @data:
>>
>> 	ret = iova_bitmap_iter_init(&iter, base_iova, page_size, length, data);
>> 	if (ret)
>> 		return -ENOMEM;
>>
>> 	for (; !iova_bitmap_iter_done(&iter) && !ret;
>> 	     ret = iova_bitmap_iter_advance(&iter)) {
>> 		dirty_reporter_ops(&iter.dirty, iova_bitmap_iova(&iter),
>> 				   iova_bitmap_length(&iter));
>> 	}
>>
>> 	iova_bitmap_iter_free(&iter);
>>
>> An implementation of the lower end -- referred to above as dirty_reporter_ops
>> to exemplify -- that is tracking dirty bits would mark an IOVA as dirty
>> as following:
>>
>> 	iova_bitmap_set(&iter.dirty, iova, page_size);
>>
>> or a contiguous range (example two pages):
>>
>> 	iova_bitmap_set(&iter.dirty, iova, 2 * page_size);
>>
>> The facility is intended to be used for user bitmaps representing
>> dirtied IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>  drivers/vfio/Makefile       |   6 +-
>>  drivers/vfio/iova_bitmap.c  | 224 ++++++++++++++++++++++++++++++++++++
>>  include/linux/iova_bitmap.h | 189 ++++++++++++++++++++++++++++++
>>  3 files changed, 417 insertions(+), 2 deletions(-)
>>  create mode 100644 drivers/vfio/iova_bitmap.c
>>  create mode 100644 include/linux/iova_bitmap.h
>>
>> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>> index 1a32357592e3..1d6cad32d366 100644
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
>> +vfio-y := vfio_main.o \
>> +          iova_bitmap.o \
>> +
>>  obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
>> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
>> new file mode 100644
>> index 000000000000..6b6008ef146c
>> --- /dev/null
>> +++ b/drivers/vfio/iova_bitmap.c
>> @@ -0,0 +1,224 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (c) 2022, Oracle and/or its affiliates.
>> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>> + */
>> +#include <linux/iova_bitmap.h>
>> +#include <linux/highmem.h>
>> +
>> +#define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)
>> +
>> +static void iova_bitmap_iter_put(struct iova_bitmap_iter *iter);
>> +
>> +/*
>> + * Converts a relative IOVA to a bitmap index.
>> + * The bitmap is viewed an array of u64, and each u64 represents
> 
> "The bitmap is viewed as an u64 array and each u64 represents"
> 
Will use that.

>> + * a range of IOVA, and the whole pinned pages to the range window.
> 
> I think this phrase after the comma is trying to say something about the
> windowed mapping, but I don't know what.
> 
Yes. doesn't add much in the context of the function.

> This function provides the index into that u64 array for a given IOVA
> offset.
> 
I'll use this instead.

>> + * Relative IOVA means relative to the iter::dirty base IOVA (stored
>> + * in dirty::iova). All computations in this file are done using
>> + * relative IOVAs and thus avoid an extra subtraction against
>> + * dirty::iova. The user API iova_bitmap_set() always uses a regular
>> + * absolute IOVAs.
> 
> So why don't we use variables that make it clear when an IOVA is an
> IOVA and when it's an offset?
> 
I was just sticking the name @offset to how we iterate towards the u64s
to avoid confusion. Should I switch to offset here I should probably change
@offset of the struct into something else. But I see you suggested something
like that too further below.

>> + */
>> +static unsigned long iova_bitmap_iova_to_index(struct iova_bitmap_iter *iter,
>> +					       unsigned long iova)
> 
> iova_bitmap_offset_to_index(... unsigned long offset)?
> 
>> +{OK.

>> +	unsigned long pgsize = 1 << iter->dirty.pgshift;
>> +
>> +	return iova / (BITS_PER_TYPE(*iter->data) * pgsize);
> 
> Why do we name the bitmap "data" rather than "bitmap"?
> 
I was avoid overusing the word bitmap given structure is already called @bitmap.
At the end of the day it's a user data pointer. But I can call it @bitmap.

> Why do we call the mapped section "dirty" rather than "mapped"?  It's
> not necessarily dirty, it's just the window that's current mapped.
> 
Good point. Dirty is just what we tracked, but the structure ::dirty is closer
to representing what's actually mapped yes. I'll switch to mapped.

>> +}
>> +
>> +/*
>> + * Converts a bitmap index to a *relative* IOVA.
>> + */
>> +static unsigned long iova_bitmap_index_to_iova(struct iova_bitmap_iter *iter,
>> +					       unsigned long index)
> 
> iova_bitmap_index_to_offset()?
> 
ack

>> +{
>> +	unsigned long pgshift = iter->dirty.pgshift;
>> +
>> +	return (index * BITS_PER_TYPE(*iter->data)) << pgshift;
>> +}
>> +
>> +/*
>> + * Pins the bitmap user pages for the current range window.
>> + * This is internal to IOVA bitmap and called when advancing the
>> + * iterator.
>> + */
>> +static int iova_bitmap_iter_get(struct iova_bitmap_iter *iter)
>> +{
>> +	struct iova_bitmap *dirty = &iter->dirty;
>> +	unsigned long npages;
>> +	u64 __user *addr;
>> +	long ret;
>> +
>> +	/*
>> +	 * @offset is the cursor of the currently mapped u64 words
> 
> So it's an index?  I don't know what a cursor is.  

In my "english" 'cursor' as a synonym for index yes.

> If we start using
> "offset" to describe a relative iova, maybe this becomes something more
> descriptive, mapped_base_index?
> 
I am not very fond of long names, @mapped_index maybe hmm

>> +	 * that we have access. And it indexes u64 bitmap word that is
>> +	 * mapped. Anything before @offset is not mapped. The range
>> +	 * @offset .. @count is mapped but capped at a maximum number
>> +	 * of pages.
> 
> @total_indexes rather than @count maybe?
> 
It's still a count of indexes, I thought @count was explicit already without
being too wordy. I can suffix with indexes if going with mapped_index. Or maybe
@mapped_count maybe

>> +	 */
>> +	npages = DIV_ROUND_UP((iter->count - iter->offset) *
>> +			      sizeof(*iter->data), PAGE_SIZE);
>> +
>> +	/*
>> +	 * We always cap at max number of 'struct page' a base page can fit.
>> +	 * This is, for example, on x86 means 2M of bitmap data max.
>> +	 */
>> +	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
>> +	addr = iter->data + iter->offset;
> 
> Subtle pointer arithmetic.
> 
>> +	ret = pin_user_pages_fast((unsigned long)addr, npages,
>> +				  FOLL_WRITE, dirty->pages);
>> +	if (ret <= 0)
>> +		return -EFAULT;
>> +
>> +	dirty->npages = (unsigned long)ret;
>> +	/* Base IOVA where @pages point to i.e. bit 0 of the first page */
>> +	dirty->iova = iova_bitmap_iova(iter);
> 
> If we're operating on an iterator, wouldn't convention suggest this is
> an iova_bitmap_itr_FOO function?  mapped_iova perhaps.
> 

Yes.

Given your earlier comment, mapped iova is a bit more obvious.

>> +
>> +	/*
>> +	 * offset of the page where pinned pages bit 0 is located.
>> +	 * This handles the case where the bitmap is not PAGE_SIZE
>> +	 * aligned.
>> +	 */
>> +	dirty->start_offset = offset_in_page(addr);
> 
> Maybe pgoff to avoid confusion with relative iova offsets.
> 
Will fix. And it's also convention in mm code, so I should stick with that.

> It seems suspect that the length calculations don't take this into
> account.
> 
The iova/length/indexes functions only work over bit/iova "quantity" and indexing of it
without needing to know where the first bit of the mapped range starts. So the pgoff
is only important when we actually set bits on the bitmap i.e. iova_bitmap_set().

>> +	return 0;
>> +}
>> +
>> +/*
>> + * Unpins the bitmap user pages and clears @npages
>> + * (un)pinning is abstracted from API user and it's done
>> + * when advancing or freeing the iterator.
>> + */
>> +static void iova_bitmap_iter_put(struct iova_bitmap_iter *iter)
>> +{
>> +	struct iova_bitmap *dirty = &iter->dirty;
>> +
>> +	if (dirty->npages) {
>> +		unpin_user_pages(dirty->pages, dirty->npages);
>> +		dirty->npages = 0;
>> +	}
>> +}
>> +
>> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter,
>> +			  unsigned long iova, unsigned long length,
>> +			  unsigned long page_size, u64 __user *data)
>> +{
>> +	struct iova_bitmap *dirty = &iter->dirty;
>> +
>> +	memset(iter, 0, sizeof(*iter));
>> +	dirty->pgshift = __ffs(page_size);
>> +	iter->data = data;
>> +	iter->count = iova_bitmap_iova_to_index(iter, length - 1) + 1;
>> +	iter->iova = iova;
>> +	iter->length = length;
>> +
>> +	dirty->iova = iova;
>> +	dirty->pages = (struct page **)__get_free_page(GFP_KERNEL);
>> +	if (!dirty->pages)
>> +		return -ENOMEM;
>> +
>> +	return iova_bitmap_iter_get(iter);
>> +}
>> +
>> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter)
>> +{
>> +	struct iova_bitmap *dirty = &iter->dirty;
>> +
>> +	iova_bitmap_iter_put(iter);
>> +
>> +	if (dirty->pages) {
>> +		free_page((unsigned long)dirty->pages);
>> +		dirty->pages = NULL;
>> +	}
>> +
>> +	memset(iter, 0, sizeof(*iter));
>> +}
>> +
>> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter)
>> +{
>> +	unsigned long skip = iter->offset;
>> +
>> +	return iter->iova + iova_bitmap_index_to_iova(iter, skip);
>> +}
>> +
>> +/*
>> + * Returns the remaining bitmap indexes count to process for the currently pinned
>> + * bitmap pages.
>> + */
>> +static unsigned long iova_bitmap_iter_remaining(struct iova_bitmap_iter *iter)
> 
> iova_bitmap_iter_mapped_remaining()?
> 
Yes.

>> +{
>> +	unsigned long remaining = iter->count - iter->offset;
>> +
>> +	remaining = min_t(unsigned long, remaining,
>> +		     (iter->dirty.npages << PAGE_SHIFT) / sizeof(*iter->data));
>> +
>> +	return remaining;
>> +}
>> +
>> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter)
> 
> iova_bitmap_iter_mapped_length()?
> 
Yes.

I don't particularly like long names, but doesn't seem to have better alternatives.

Part of the reason the names look 'shortened' was because the object we pass
is already an iterator, so it's implicit that we only fetch the under-iteration/mapped
iova. Or that was at least the intention.

> Maybe it doesn't really make sense to differentiate the iterator from
> the bitmap in the API.  In fact, couldn't we reduce the API to simply:
> 
> int iova_bitmap_init(struct iova_bitmap *bitmap, dma_addr_t iova,
> 		     size_t length, size_t page_size, u64 __user *data);
> 
> int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *data,
> 			 int (*fn)(void *data, dma_addr_t iova,
> 			 	   size_t length,
> 				   struct iova_bitmap *bitmap));
> 
> void iova_bitmap_free(struct iova_bitmap *bitmap);
> 
> unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
> 			      dma_addr_t iova, size_t length);
> 
> Removes the need for the API to have done, advance, iova, and length
> functions.
> 
True, it would be simpler.

Could also allow us to hide the iterator details enterily and switch to
container_of() from iova_bitmap pointer. Though, from caller, it would be
weird to do:

struct iova_bitmap_iter iter;

iova_bitmap_init(&iter.dirty, ....);

Hmm, maybe not that strange.

Unless you are trying to suggest to merge both struct iova_bitmap and
iova_bitmap_iter together? I was trying to keep them separate more for
the dirty tracker (IOMMUFD/VFIO, to just be limited to iova_bitmap_set()
with the generic infra being the one managing that iterator state in a
separate structure.

>> +{
>> +	unsigned long max_iova = iter->iova + iter->length - 1;
>> +	unsigned long iova = iova_bitmap_iova(iter);
>> +	unsigned long remaining;
>> +
>> +	/*
>> +	 * iova_bitmap_iter_remaining() returns a number of indexes which
>> +	 * when converted to IOVA gives us a max length that the bitmap
>> +	 * pinned data can cover. Afterwards, that is capped to
>> +	 * only cover the IOVA range in @iter::iova .. iter::length.
>> +	 */
>> +	remaining = iova_bitmap_index_to_iova(iter,
>> +			iova_bitmap_iter_remaining(iter));
>> +
>> +	if (iova + remaining - 1 > max_iova)
>> +		remaining -= ((iova + remaining - 1) - max_iova);
>> +
>> +	return remaining;
>> +}
>> +
>> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter)
>> +{
>> +	return iter->offset >= iter->count;
>> +}
>> +
>> +int iova_bitmap_iter_advance(struct iova_bitmap_iter *iter)
>> +{
>> +	unsigned long iova = iova_bitmap_length(iter) - 1;
>> +	unsigned long count = iova_bitmap_iova_to_index(iter, iova) + 1;
>> +
>> +	iter->offset += count;
>> +
>> +	iova_bitmap_iter_put(iter);
>> +	if (iova_bitmap_iter_done(iter))
>> +		return 0;
>> +
>> +	/* When we advance the iterator we pin the next set of bitmap pages */
>> +	return iova_bitmap_iter_get(iter);
>> +}
>> +
>> +unsigned long iova_bitmap_set(struct iova_bitmap *dirty,
>> +			      unsigned long iova, unsigned long length)
>> +{
>> +	unsigned long nbits = max(1UL, length >> dirty->pgshift), set = nbits;
>> +	unsigned long offset = (iova - dirty->iova) >> dirty->pgshift;
>> +	unsigned long page_idx = offset / BITS_PER_PAGE;
>> +	unsigned long page_offset = dirty->start_offset;
>> +	void *kaddr;
>> +
>> +	offset = offset % BITS_PER_PAGE;
>> +
>> +	do {
>> +		unsigned long size = min(BITS_PER_PAGE - offset, nbits);
>> +
>> +		kaddr = kmap_local_page(dirty->pages[page_idx]);
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
>> index 000000000000..e258d03386d3
>> --- /dev/null
>> +++ b/include/linux/iova_bitmap.h
>> @@ -0,0 +1,189 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (c) 2022, Oracle and/or its affiliates.
>> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
>> + */
>> +#ifndef _IOVA_BITMAP_H_
>> +#define _IOVA_BITMAP_H_
>> +
>> +#include <linux/mm.h>
>> +
>> +/**
>> + * struct iova_bitmap - A bitmap representing a portion IOVA space
>> + *
>> + * Main data structure for tracking dirty IOVAs.
>> + *
>> + * For example something recording dirty IOVAs, will be provided of a
>> + * struct iova_bitmap structure. This structure only represents a
>> + * subset of the total IOVA space pinned by its parent counterpart
>> + * iterator object.
>> + *
>> + * The user does not need to exact location of the bits in the bitmap.
>> + * From user perspective the bitmap the only API available to the dirty
>> + * tracker is iova_bitmap_set() which records the dirty IOVA *range*
>> + * in the bitmap data.
>> + *
>> + * The bitmap is an array of u64 whereas each bit represents an IOVA
>> + * of range of (1 << pgshift). Thus formula for the bitmap data to be
>> + * set is:
>> + *
>> + *   data[(iova / page_size) / 64] & (1ULL << (iova % 64))
>> + */
>> +struct iova_bitmap {
>> +	/* base IOVA representing bit 0 of the first page */
>> +	unsigned long iova;
>> +
>> +	/* page size order that each bit granules to */
>> +	unsigned long pgshift;
>> +
>> +	/* offset of the first user page pinned */
>> +	unsigned long start_offset;
>> +
>> +	/* number of pages pinned */
>> +	unsigned long npages;
>> +
>> +	/* pinned pages representing the bitmap data */
>> +	struct page **pages;
>> +};
>> +
>> +/**
>> + * struct iova_bitmap_iter - Iterator object of the IOVA bitmap
>> + *
>> + * Main data structure for walking the bitmap data.
>> + *
>> + * Abstracts the pinning work to iterate an IOVA ranges.
>> + * It uses a windowing scheme and pins the bitmap in relatively
>> + * big ranges e.g.
>> + *
>> + * The iterator uses one base page to store all the pinned pages
>> + * pointers related to the bitmap. For sizeof(struct page) == 64 it
>> + * stores 512 struct pages which, if base page size is 4096 it means 2M
>> + * of bitmap data is pinned at a time. If the iova_bitmap page size is
>> + * also base page size then the range window to iterate is 64G.
>> + *
>> + * For example iterating on a total IOVA range of 4G..128G, it will
>> + * walk through this set of ranges:
>> + *
>> + *  - 4G  -  68G-1 (64G)
>> + *  - 68G - 128G-1 (64G)
>> + *
>> + * An example of the APIs on how to iterate the IOVA bitmap:
>> + *
>> + *   ret = iova_bitmap_iter_init(&iter, iova, PAGE_SIZE, length, data);
>> + *   if (ret)
>> + *       return -ENOMEM;
>> + *
>> + *   for (; !iova_bitmap_iter_done(&iter) && !ret;
>> + *        ret = iova_bitmap_iter_advance(&iter)) {
>> + *
>> + *        dirty_reporter_ops(&iter.dirty, iova_bitmap_iova(&iter),
>> + *                           iova_bitmap_length(&iter));
>> + *   }
>> + *
>> + * An implementation of the lower end (referred to above as
>> + * dirty_reporter_ops) that is tracking dirty bits would:
>> + *
>> + *        if (iova_dirty)
>> + *            iova_bitmap_set(&iter.dirty, iova, PAGE_SIZE);
>> + *
>> + * The internals of the object use a cursor @offset that indexes
>> + * which part u64 word of the bitmap is mapped, up to @count.
>> + * Those keep being incremented until @count reaches while mapping
>> + * up to PAGE_SIZE / sizeof(struct page*) maximum of pages.
>> + *
>> + * The iterator is usually located on what tracks DMA mapped ranges
>> + * or some form of IOVA range tracking that co-relates to the user
>> + * passed bitmap.
>> + */
>> +struct iova_bitmap_iter {
>> +	/* IOVA range representing the currently pinned bitmap data */
>> +	struct iova_bitmap dirty;
>> +
>> +	/* userspace address of the bitmap */
>> +	u64 __user *data;
>> +
>> +	/* u64 index that @dirty points to */
>> +	size_t offset;
>> +
>> +	/* how many u64 can we walk in total */
>> +	size_t count;
> 
> size_t?  These are both indexes afaict.
> 
Yes these are both indexes, I'll move away from size_t in these two.

>> +
>> +	/* base IOVA of the whole bitmap */
>> +	unsigned long iova;
>> +
>> +	/* length of the IOVA range for the whole bitmap */
>> +	unsigned long length;
> 
> OTOH this could arguably be size_t and iova dma_addr_t.  Thanks,
> 
OK.

Thanks a lot for the review and suggestions!

> Alex
> 
>> +};
>> +
>> +/**
>> + * iova_bitmap_iter_init() - Initializes an IOVA bitmap iterator object.
>> + * @iter: IOVA bitmap iterator to initialize
>> + * @iova: Start address of the IOVA range
>> + * @length: Length of the IOVA range
>> + * @page_size: Page size of the IOVA bitmap. It defines what each bit
>> + *             granularity represents
>> + * @data: Userspace address of the bitmap
>> + *
>> + * Initializes all the fields in the IOVA iterator including the first
>> + * user pages of @data. Returns 0 on success or otherwise errno on error.
>> + */
>> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter, unsigned long iova,
>> +			  unsigned long length, unsigned long page_size,
>> +			  u64 __user *data);
>> +
>> +/**
>> + * iova_bitmap_iter_free() - Frees an IOVA bitmap iterator object
>> + * @iter: IOVA bitmap iterator to free
>> + *
>> + * It unpins and releases pages array memory and clears any leftover
>> + * state.
>> + */
>> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter);
>> +
>> +/**
>> + * iova_bitmap_iter_done: Checks if the IOVA bitmap has data to iterate
>> + * @iter: IOVA bitmap iterator to free
>> + *
>> + * Returns true if there's more data to iterate.
>> + */
>> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter);
>> +
>> +/**
>> + * iova_bitmap_iter_advance: Advances the IOVA bitmap iterator
>> + * @iter: IOVA bitmap iterator to advance
>> + *
>> + * Advances to the next range, releases the current pinned
>> + * pages and pins the next set of bitmap pages.
>> + * Returns 0 on success or otherwise errno.
>> + */
>> +int iova_bitmap_iter_advance(struct iova_bitmap_iter *iter);
>> +
>> +/**
>> + * iova_bitmap_iova: Base IOVA of the current range
>> + * @iter: IOVA bitmap iterator
>> + *
>> + * Returns the base IOVA of the current range.
>> + */
>> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter);
>> +
>> +/**
>> + * iova_bitmap_length: IOVA length of the current range
>> + * @iter: IOVA bitmap iterator
>> + *
>> + * Returns the length of the current IOVA range.
>> + */
>> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter);
>> +
>> +/**
>> + * iova_bitmap_set: Marks an IOVA range as dirty
>> + * @dirty: IOVA bitmap
>> + * @iova: IOVA to mark as dirty
>> + * @length: IOVA range length
>> + *
>> + * Marks the range [iova .. iova+length-1] as dirty in the bitmap.
>> + * Returns the number of bits set.
>> + */
>> +unsigned long iova_bitmap_set(struct iova_bitmap *dirty,
>> +			      unsigned long iova, unsigned long length);
>> +
>> +#endif
> 
