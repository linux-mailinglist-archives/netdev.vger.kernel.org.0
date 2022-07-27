Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0B675821DC
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiG0IQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 04:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiG0IQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:16:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50F0912D04
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 01:16:12 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26R7OqFY009198;
        Wed, 27 Jul 2022 08:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=00fbvGiRjb1nRpQX+P/L/r4UcnyGJMer05SRMxBA+e0=;
 b=Kr+Xw40WSCHY0D1giAsuCfhG8TIbc72A9lK8h9u6LjPC8QuA/TFWeLUOyEhu1ETIbLOO
 eX7DOTA3YRCEC8rOoP07hI92QLUAXxkmkLRWoJIJG4zk/kcrWpNVu7xpliJmY5cpwnHw
 l4/MjY6gFD3Zb+oeGJleFeGkwnJrkVEZ3dFii6Y00NIm4hwhfc5ZLTUkz50p47NUsY+M
 avcOtytar+m0iuMRtkh+BIMhnwEsxPZOeduDYCN0uqsKwBZbqjQimq3zaSesUSKpgq9E
 +l7MAm259uV6zNPFshQiSBhnkZn87aNTQ1zxmVyM2u3bx2B4qwXrb7JnTMTTNqnCLkuK Pw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9ap0dc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 08:16:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26R6RuUR006209;
        Wed, 27 Jul 2022 08:16:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hh65cmajw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jul 2022 08:16:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLcnI6y0zh+oUsqaCAd4D0zcrzzKw4+UuDKzkM/BAG8yDsJc8QaY+j5QeoVznGWRyW3N7w7YkrH9kteaymlLOUpPWRAwURPbUKCYxYurN2JLvvGGU3Bi7tdVJwwm/p25SpOgui2aEWlEs3bW0pafqf+8pL0/tGAmLNJvXig8/ZbC8THGGkIq3CewwO55Juapv26+itCubatnDmS5bzWCPUiC+smwJZiYWIbTxjdaB/pqho+4lO3MG0NZr7JIXGt0E7oKnhgfYAdhmglB2kEw9rS5cRRiZJKPUO0adv5ZG49MLLdGwReBdnQfHk+hz9Sy8J2A+pgMf3VaqCVGAnH9vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00fbvGiRjb1nRpQX+P/L/r4UcnyGJMer05SRMxBA+e0=;
 b=lpFBwfP6NKPOE0I9MPsTogtAL52BHjwE2qZ/I6U4bi2rsuVedzLvnZQ9nHuuxviEika+1sJ1eWkEIh6v0twdKK4b054hrUtJH7sbLVqt+5B4CPnMHiDab4Ku4vtNvpFyC4dSUQ9UqZIpnCOufjy//6XTenshrM5srCdmlg2mVf1TqXQeRbolbu8QpfVI/VFzygBWq/3h5UT7lF9kVA0PfLeswPQbOuiiytygENCsYYn2R6SNcQhS31UUEyCasywF08xSeu1GZTLcklPJN4aZxCDuWMiZn1pZkktygi4ZRkleVqT8p6Uv/xo6adXBwAn9uZmRTrhf6JCipKxeazQk2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=00fbvGiRjb1nRpQX+P/L/r4UcnyGJMer05SRMxBA+e0=;
 b=O0LPZ32EGqNKJ/qT+QXNCeRofeQKrqaUY+qWhbW9K+tRoR4OpHkUKUZwb2PjtWb6yHyu4Ecnvi7OtCa4T7rt1cZhVVJ+xL5whKTl5PvFrx5bvf59Hi5fbjpCfXTylPMO8aQjW6M1/Ek1I6HcVrLBO6YKHQb7yfZaqqKl2k6VeB0=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by PH0PR10MB4645.namprd10.prod.outlook.com (2603:10b6:510:31::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Wed, 27 Jul
 2022 08:16:01 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::c846:d8e4:8631:9803%4]) with mapi id 15.20.5458.025; Wed, 27 Jul 2022
 08:16:00 +0000
Message-ID: <a1bb599c-63be-a85e-5cff-6eed28abd347@oracle.com>
Date:   Wed, 27 Jul 2022 01:15:58 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e8479441-78d2-8b39-c5ad-6729b79a2f35@redhat.com>
 <PH0PR12MB54817FD9E0D8469857438F95DCBE9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1e1e5f8c-d20e-4e54-5fc0-e12a7ba818a3@intel.com>
 <PH0PR12MB5481862D47DCD61F89835B01DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <PH0PR12MB5481862D47DCD61F89835B01DC819@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0176.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::31) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bd6e6fe-452e-4ffc-8bfa-08da6fa83d9d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4645:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rnDriudiYObX/rH07WDfizTUUBzgBjlNstL5R7u1cmV55rcjpDhOZeSlSOzf+5SrkVQcDq3AHDVJkAtkWCwQ7GAmNP7tWaNaDWRjf0AuYVliN5n7Mi/Gb4ivJHSbLKmAXXk0RJx+jTWKDeIAuSydbvx1TCQGpkRwaLSSb/14Bdxhy8RrxA0PWA43GZPsvRLKcncBWf8d8cuBY6IBzKwmU5LXYJ6acFTkDvRRK1p1Xx+OrxcrIl9cPyspZdMWg+hNVbRCnQ56gdkQ17CzeKkBVBjVFsbvO0R4ltg738lxB7DD0RTXPBjqniUsNUh0gH0DNvwIK3zUsBmbTTK35AbSRls7adXPyRgJjzhtdItb1r5Ppe8EOmu3TNtWRXfn8hJZtbAKm1yD308ibhPk1JgeE2lyNlaArc/ggzUlh9xq2+QHTbf1I3a7w74EP/TJVSE1Ntk+Q5ap5BfyFSkFDy8RAbOILizQjOdX/lxVUBM7yWKua+NjLe4cNU/loD8JNOsti4t//4ZE7rNUNCe8sgogARLL0tTQEBeXV45MbEMy9y6CVlUeXdm8jyZn8A1xFwJNbocMCa6ysFX3HZuw91aCiYl9wu6YxBhV3R3rm24hVuRaBmLVkCy8cM+5SapZWUYoHhJpED8X8tNyfPQdIAjItIa/sJL/2ju3b+15w3aGI2sEWzky7HVfpMglxGVxDDQiiREwepQzjc7eGQqfaRqm0VlbVoZJ2w4O3c1YR2glio4j2U8s+ZeKacJOAkEhxEmoqunlgFgdVLhpR4tRoPwALGFP8YOvWFX7PTjDIbAmBosCzovho8gMvsyBz6tFQ0d16wKXM8MfenP91rOI/XMb6yp2oVNk+hbDvL4Oxtg3u7s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(346002)(376002)(39860400002)(136003)(2616005)(316002)(38100700002)(83380400001)(8936002)(2906002)(966005)(31686004)(36756003)(41300700001)(5660300002)(478600001)(6486002)(8676002)(53546011)(110136005)(6512007)(54906003)(26005)(86362001)(31696002)(66476007)(4326008)(66946007)(6506007)(36916002)(186003)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzNxU0kySk5iR1NwdmNQbHZzLzd3OTZieU1EdjJWL3Q1cVJPN2pWTFRNemNl?=
 =?utf-8?B?QkVVUGkyM1NJaFgwVERsWHkyM09MVW5jN3BNb2xiOHk3Zmp5OFE1VzJCSll1?=
 =?utf-8?B?akRjZ0IwVk9VSmR4bmRRa056dTJ4dGcxNkJ4eTRhNXJNWGxHS1lzQkVsR1VL?=
 =?utf-8?B?WnhPYW96eEFRNHdlejRnSitQTWR1QUtyMjZ0Y256dk5iT0JQOXVmMGVQOEZs?=
 =?utf-8?B?WXRsRWxZY24zYUJhelBUNjBjOFhablNkTUZoeERSWVZFdXNoaUlvQy9UNlNT?=
 =?utf-8?B?KzR5OEtDTkQ1MXRiUDJvYVdEKzg0SE4vdGVEd2JYNURxcHgwSWFmSFM2ZjBR?=
 =?utf-8?B?L01ZY1gvOHNUMzREMGNOcVhEb2tON3dsRHVzdnR3WVdKVnpZazZid1NEZGo3?=
 =?utf-8?B?NTJmVnhubitTeWkyeEpQKytIT1FVU0FRajJKL25kQTZhMWVjdVh3aWFxdjEz?=
 =?utf-8?B?S25ZdEtENHc3SDdKODdRKzIwc2N6VkE1T2FDVjU4YlNaVHc2bmVVYzZJVEdW?=
 =?utf-8?B?SWFyNHhXT3VVSVpybmhVVzlKcERPYWpaTmczY3BCc3ZQUkl1bkUrcGlLa29G?=
 =?utf-8?B?VTZzZHZ1bklNcWJKeWtlWVlzZHZjMzhwSVJZemduWkxOaE5kVEwxSjBVS3o4?=
 =?utf-8?B?NXFmbXJsVHVQb25sRjJVWlk1SmIxSW9pK0pCVHZ0eTdYOXk5VklHMDIwTi81?=
 =?utf-8?B?MzdUODJmOTlUcVEyMVFCZVJ2Y0FsUHV6UzJkQmlnSTFLNWxVaUxtRGVvaDd3?=
 =?utf-8?B?S2FnWW5kSkRSczU3RDVLSFhwWUlqSzV5M2lLWitkR0Nmd1JTazl3Tk9TeGRM?=
 =?utf-8?B?cU1wOThkNDdTaU5qaHlqOHF2cjZoeldtb2FlcEZJMlNTb2tQY0ZQN2J3VTZU?=
 =?utf-8?B?KzJialp4Vm1nekdYcGtKQUlWSG1aYWpQeSszVjJack83QVFZVTR0TnpXS1Fq?=
 =?utf-8?B?bVNLS3U4S1hDYlJYZkR0R0E2MnZuRHhNNHBJcFFLbXk4NFlWTTBzYXVnUlFt?=
 =?utf-8?B?VDh5WWxJVFpVaGQwQ3lOSjhHSHVRVW1hb3VFVlc3Q200SWpsSHVsc092N05n?=
 =?utf-8?B?VnZ6NSt5MzNlcExCazAybmhwYUR5dmtrbzgyWTRvYU93YlFqeGpZSndCMnlV?=
 =?utf-8?B?L3UreWxNeVpSZHYyc1g0SGNOTkZ3bkp5WlhyUEdqUk9yRkl6TFFZcHBOaUtp?=
 =?utf-8?B?V0VxS1hvU3B4R0Zrbi9Famo3aUF0eGlQeDZhQjZVc2l0RTd1cXRXU1BMUVZS?=
 =?utf-8?B?RldkZ044N3owK2xOTFNZdllGS0JQbHdiVnJ3cWdmTkFMSlJtVlpEazZaK1hW?=
 =?utf-8?B?d2lWUFhoS0tXLzZsMGVwQWtSN2did0tidERDazFzL1NHa0JJWUNrMnhLZ0VV?=
 =?utf-8?B?Mjhla2ZoSVVwRDI0OEVXYlBhWE83V2Q5SDFReGlJcGo5Q25Ld0ZTZ2IzRXZz?=
 =?utf-8?B?TEJCMFBCeDNmWklNRWpvMVpGOGxFRjJzb2wrSlZxVjl0dEEzV0Fzb2VDS1hC?=
 =?utf-8?B?MjA1dXc5M2RZYjBFNHVOWnJab1NYSFJPaWxjMk0yVCttSlNBUEJkOWM3ZUVY?=
 =?utf-8?B?RlRRalQ0MGNmR05KOXlJQWZvM2pwSm1TY3dreXUwNDF1aFc4MGZwRmFWUmVp?=
 =?utf-8?B?cHBHVnJWL1BIUW5qQ1kyQU9zN1g2SEV0UkZTR0cwSllrNmtZMW4xZVFyYXZt?=
 =?utf-8?B?SlJ4ODVseld6a3VXVlVOcWlWQU1nTmM5MldTWFp0Ny82MkNVWEM2UWZYNFRD?=
 =?utf-8?B?bmxSWlYyaHRCUTdlRVJPYnVVVVN5bXdEVDBSbGRDS2VGSDduOHkvRzJLV0JZ?=
 =?utf-8?B?M0VPTjFUMGFPT1c0bDBtd3JBUFRoUllhTGNpSmZMRTJmZlNQUEp6OGgxWGlM?=
 =?utf-8?B?SjE1SjAyN0k5b3hkT3pEdFFLdFZhREFzUmtMbG9ZZDc3b01jb25VUCt3dGpD?=
 =?utf-8?B?WTZaRjBWeEZXc3JiVGhVcW5sM1ZKbDJIQzI1NnZIR2FXR2xoTFpUa09CQ0xh?=
 =?utf-8?B?Z3F4blRiTElqWTlCdnZSOHM4T0w5eVYzT3Qxc3I1YjJNTTU1TWUzaDh2NzRj?=
 =?utf-8?B?a2E1TmZ1NXV6LytibmsrY2s2OGxGVTBoZk5QNjVtN2tMdFYvcVREbXJ6dENo?=
 =?utf-8?Q?WnOkqmnOK3fGXL3xv/UXNVob6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bd6e6fe-452e-4ffc-8bfa-08da6fa83d9d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 08:16:00.6051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RsrdqdenxujS7gAA7Xll5MPiQQN9yIySGh38DDvGKIQOenxdxPTzN9HLTULArFL+EhKn/Zf32BIaznJCjP9vnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4645
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207270032
X-Proofpoint-ORIG-GUID: L8WZqxdQp43yjU63WoXY0D8AkxWZQIzW
X-Proofpoint-GUID: L8WZqxdQp43yjU63WoXY0D8AkxWZQIzW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2022 4:56 AM, Parav Pandit via Virtualization wrote:
>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>> Sent: Tuesday, July 5, 2022 3:59 AM
>>
>>
>> On 7/4/2022 8:53 PM, Parav Pandit wrote:
>>>> From: Jason Wang <jasowang@redhat.com>
>>>> Sent: Monday, July 4, 2022 12:47 AM
>>>>
>>>>
>>>> 在 2022/7/2 06:02, Parav Pandit 写道:
>>>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>>
>>>>>> This commit adds a new vDPA netlink attribution
>>>>>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>>>> features
>>>>>> of vDPA devices through this new attr.
>>>>>>
>>>>>> Fixes: a64917bc2e9b vdpa: (Provide interface to read driver
>>>>>> feature)
>>>>> Missing the "" in the line.
>>>>> I reviewed the patches again.
>>>>>
>>>>> However, this is not the fix.
>>>>> A fix cannot add a new UAPI.
>>>>>
>>>>> Code is already considering negotiated driver features to return the
>>>>> device
>>>> config space.
>>>>> Hence it is fine.
>>>>>
>>>>> This patch intents to provide device features to user space.
>>>>> First what vdpa device are capable of, are already returned by
>>>>> features
>>>> attribute on the management device.
>>>>> This is done in commit [1].
>>>>>
>>>>> The only reason to have it is, when one management device indicates
>>>>> that
>>>> feature is supported, but device may end up not supporting this
>>>> feature if such feature is shared with other devices on same physical device.
>>>>> For example all VFs may not be symmetric after large number of them
>>>>> are
>>>> in use. In such case features bit of management device can differ
>>>> (more
>>>> features) than the vdpa device of this VF.
>>>>> Hence, showing on the device is useful.
>>>>>
>>>>> As mentioned before in V2, commit [1] has wrongly named the
>>>>> attribute to
>>>> VDPA_ATTR_DEV_SUPPORTED_FEATURES.
>>>>> It should have been,
>>>> VDPA_ATTR_DEV_MGMTDEV_SUPPORTED_FEATURES.
>>>>> Because it is in UAPI, and since we don't want to break compilation
>>>>> of iproute2, It cannot be renamed anymore.
>>>>>
>>>>> Given that, we do not want to start trend of naming device
>>>>> attributes with
>>>> additional _VDPA_ to it as done in this patch.
>>>>> Error in commit [1] was exception.
>>>>>
>>>>> Hence, please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES to return
>>>> for device features too.
>>>>
>>>>
>>>> This will probably break or confuse the existing userspace?
>>>>
>>> It shouldn't break, because its new attribute on the device.
>>> All attributes are per command, so old one will not be confused either.
>> A netlink attr should has its own and unique purpose, that's why we don't need
>> locks for the attrs, only one consumer and only one producer.
>> I am afraid re-using (for both management device and the vDPA device) the attr
>> VDPA_ATTR_DEV_SUPPORTED_FEATURES would lead to new race condition.
>> E.g., There are possibilities of querying FEATURES of a management device and
>> a vDPA device simultaneously, or can there be a syncing issue in a tick?
> Both can be queried simultaneously. Each will return their own feature bits using same attribute.
> It wont lead to the race.
Agreed. Multiple userspace callers would do recv() calls on different 
netlink sockets. Looks to me shouldn't involve any race.
>
>> IMHO, I don't see any advantages of re-using this attr.
> We don’t want to continue this mess of VDPA_DEV prefix for new attributes due to previous wrong naming.
Well, you can say it's a mess but since the attr name can be reused for 
different command,  I didn't care that much while reviewing this. 
Actually, it was initially named this way to show the device features in 
"vdpa dev config ..." output, but later on it had been moved to mgmtdev 
to show parent's capability.

-Siwei
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

