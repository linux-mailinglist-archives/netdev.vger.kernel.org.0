Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B7A5A2DF5
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 20:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239224AbiHZSGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 14:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiHZSF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 14:05:58 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 562F14BD13
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 11:05:55 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27QHi9sh017711;
        Fri, 26 Aug 2022 18:05:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=2UUqyUigeee2KBeL/X63KbVIl/bLPNL8w4SLWes7g8g=;
 b=rPlH6hJWsFZlyUMlgbCfFPo6mUQ8I1+1iLOlyoNA3Mxe0YvZWJ5seEFUPuXH2TEmojCR
 ZzDiEOn1k3CeVBK5d9bviq8hJXH8nBpH5+fm3kLPBw/0aFYhCnUmgsKZAzbsCY6OrP66
 /qnRn7BXrGSxt6ipX0hI3E7U+P3v/jqBAaJ5GCgZ0mdBkxK3lCNa8SH85glTT83pQ0b7
 K1Ae1hvSB8KElQAyP+Om0QVqm28FgK00afuECUdESrEhUZnWKj1z1mgum19oVmP1WYrE
 Q1zKJwx4KOoiGdZoTJLCKhWdLDaIRoJl6mJqEd+dXljrE9XOC1YEYHLx7H3+zwURtDFy 0A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j5aww7qt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 18:05:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27QGiX38036192;
        Fri, 26 Aug 2022 18:05:14 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j5n6ppngt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Aug 2022 18:05:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kZqv0TgI9VtzJlhj6TTQ5q/Q/px53Yh+gQl4ywu1VJNN0dyLnKKkqaHjJmBn5COTgpNrpRBsu8nQcDtMNk8GgV1Ey8b4LalVYeNntT6J+cFGrlwSZGfOMIZ348HRGkZYtTbESy39vNtgJqW1efuvU54EIflpqyw3Z7TMsjcITytyUJ08SEVWfuGP4X1+TbayOK0s7Esi6V1q5KTVe2ahEi0XHVMixLEsOGQHA+45TTGIcShaom4ducko8jXo1yCtSy764igh6syKA+HZw3TyX2uxVulIYHaBu7I4yAFBdgl0GqBdJ5hgzFsDGh91xX1RBeKfYYjjijRpCTe2biNQCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2UUqyUigeee2KBeL/X63KbVIl/bLPNL8w4SLWes7g8g=;
 b=k/nZjYFMbO58gBfdtAL6yJrX/hTl9y7vAXanyHzEAr81MR09DF/Wg97d7FJyVgxyyNK85CVagCj/MqCHtK0R0Al69+1j+VHQZdtv8X4NnCTl3Qr3nrnSQJZqNfAo6sXT8o3v1SSsQa0ffpg9em/HaB4fNYx1sLQ33jQeypItvLrQMvmpC/7C4tZZ6LS5niMFsv1JjqymDJbDKntdFcNW8H6qzjvl3j6s96jj7Ra1+604NXoyzChPINjltu+OI9LZ8o4BVe1VwOLHM7d2J7uTrVeUAo11my25TeVJ+R9i+szYii6RZWd/JYA56WoG+wUC417bT8iEy6zqeSLPWLeKXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2UUqyUigeee2KBeL/X63KbVIl/bLPNL8w4SLWes7g8g=;
 b=duJdP3CFxRplzk/SV2tFgJbCLcEpK2PUqeKuHk8ls3EO4Y3SLI3Dk4FFAdniAW1tLjRiKvPqAgKD0kLBiEBZidnxnpFes8U4SY8J1982D4BqXegRbMt84vEFvhj61tyhXjTGnV7zDMh47Pr7obCiWZ8picUXq+c57acLnQOi6ss=
Received: from BYAPR10MB3287.namprd10.prod.outlook.com (2603:10b6:a03:15c::11)
 by MWHPR10MB1503.namprd10.prod.outlook.com (2603:10b6:300:22::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Fri, 26 Aug
 2022 18:05:11 +0000
Received: from BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649]) by BYAPR10MB3287.namprd10.prod.outlook.com
 ([fe80::dcf7:95c3:9991:e649%7]) with mapi id 15.20.5566.015; Fri, 26 Aug 2022
 18:05:11 +0000
Message-ID: <784140bb-53d1-e00b-f79a-7b95b0c1052f@oracle.com>
Date:   Fri, 26 Aug 2022 11:05:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [virtio-dev] [PATCH RESEND v2 2/2] virtio-net: use mtu size as
 buffer length for big packets
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>, Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     Gavi Teitz <gavi@nvidia.com>
References: <20220825123840.20239-1-gavinl@nvidia.com>
 <20220825123840.20239-3-gavinl@nvidia.com>
 <27204c1c-1767-c968-0481-c052370875d8@oracle.com>
 <PH0PR12MB5481BB5F85A7115A07FBC315DC759@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Si-Wei Liu <si-wei.liu@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <PH0PR12MB5481BB5F85A7115A07FBC315DC759@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0052.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::29) To BYAPR10MB3287.namprd10.prod.outlook.com
 (2603:10b6:a03:15c::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34206391-ed85-4cd2-5722-08da878d84e5
X-MS-TrafficTypeDiagnostic: MWHPR10MB1503:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: apgsFH+V1Ypx5G0qtxmY7M3brgJDxqQzvenelmFGc+EyOsXNkE6/8j9jIyjq2OkO1e7BmxAStqKRQ+hqCKy1RD/ICQeKfY/L7uUE6Y9fU6RdQBpveLCi1SXsA60e6Bc+JmeO7Sh0R4aRmrEKXmf/s4vbyTrKMOJDrnKrP3eDH+BRcDHdcFOvTj7QhEmHbbWlg/Z3oqR9bCFhGMztOYuVJXVidS71q6HtifJmo2iwTtQfmaOqpitrL8xIWo7IYZmDSU7r9djspQogk1hgJmwbgvZeQZOnL47A6KLV/N/8GsFE+G6llSgR817muQ/apsAxNz3kYtYNpMm/9Pu4jh/XjWOgbpy3E+G1tpVVYOX0VFZp38V1rM2Ctk08xKkahSKf+T2wdYmPJo8nzQkuYv7pwDltHm+kjsrDs2iVKprhW+DId6Rh7b0paqe99IQDTC+d5w59PLBf3w/72LD2dWoFLdssfZxEsMJQHy+R/9mPrYkAZjKX5Ds6cuIJyvQQr79S3Cza6Yvex5aygkZHFs9SW91jhrCSJmExK7EqxzCWmmAne/ENKes/dKr4zAxqmEa8iDtkw2jpQVz28SV/6Siu+4ZSS68GersdPtBJZePohe7JcVuX6I6qTjs9e0hxrttWBjwJ5t85iK1Jj5j8oX+wbcOozbZxeYCX66tn4pJp4faTC2//lTQcLLE18iEy3O0lTpttQQUJRPjFO9VHPnsy5YSkb5SCQilMgVbIoiczdGUHZAuqpn8UZWy+feQqIExAse7PAvdZ9QdnOAAtfPyfMUYmf2tas1h8uGgS1d3WIzJLl9ovsOwxOiN/zLeyOWOY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3287.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(136003)(366004)(396003)(39860400002)(66476007)(83380400001)(38100700002)(316002)(8676002)(66556008)(110136005)(5660300002)(8936002)(4326008)(2906002)(66946007)(7416002)(6506007)(53546011)(86362001)(36756003)(41300700001)(6512007)(26005)(36916002)(921005)(31696002)(478600001)(6486002)(31686004)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0NiMGZMUVlqUkxTZFJhbHA2WGtqVE1BSXpuY0ZjOW9iTE0rdWErbHNFd1B0?=
 =?utf-8?B?WGF1WmZIbzMvMktUL0lvc2pGREVZT0U5R0poWGxqNXFDRmE5UkZBbVZDRUhR?=
 =?utf-8?B?RmZ5c1lTS29ZYzBnMFdRdFJHQU4xNS9MenJ2dHo4eG50dVN3eTNBV3hoT1l2?=
 =?utf-8?B?OVJ0MS9jdlM0ZUk5ZUJTTmdLUTEyYkh2YVcrVTl4SUQyd2NSbHZiUlZEaWpn?=
 =?utf-8?B?elUvOS9pMEdVZHJCTWowSmR2TExqZExtSy9kLytRNDNkRzFCSEFnU0ZRUEZH?=
 =?utf-8?B?cVNiZTVRWUxWOGR2Yk1xbFgzdmt1SXNvcXIvK2lON0NTd3Z1bThVdjRXN2F2?=
 =?utf-8?B?anlLaDBLdHFQYzNlWUI2aHcvc3phVFgwSzhNN1FrVnlDeXpNbzVDaHpTL2RX?=
 =?utf-8?B?amt0VCtuV0dtRGFZTVhpTExGdlFNcHg2Sk82RVNXNURnUHBPd0NnS2pZUC8w?=
 =?utf-8?B?TDFNLzRmUU9uOGFPMEVPQnRLMTBaV21kUDhIMmdOOUlMK2NyVGNLcXFVQzRC?=
 =?utf-8?B?MzQvNGgxdGdZUWQ4TEVpNU1YTTczaThROGZ3OExJNGVveXdEdTlNN0hSOUto?=
 =?utf-8?B?NzdlQWlMNmwxdjE0ZDh0Rk1kbndqUFV5czIzdm85MjBXdThjbG04V1Y4RGdD?=
 =?utf-8?B?RUNaUW9ETTh2d211cGY2SXkwZmJqdjVtdzFubVBKSjcvNWhjTURtY3ppaHdH?=
 =?utf-8?B?dnhSMzk1VjBPSmE3WGU1QzhhWnNVNXlxYm42RE5nUDl1bElOM1BGK1ZKOHVm?=
 =?utf-8?B?ZERMRGMzdm8rWUx2U3M3cDIzODRZR0dTR0poYXhZM0Ewb2JRRW8xeWZCVVBs?=
 =?utf-8?B?UEpkU0lyOHJVdC9TZEVxeExiZ0dhaFh0TlFrZk8zU0hIQllYT2VHS2RNaDE1?=
 =?utf-8?B?N280QzhERzNaSHBGYlpXZGFHYUZETnJ1VGQ4WjgrWVplT0pqdnlsN1IycHF3?=
 =?utf-8?B?Z0VDOC96VHBtb1JTQ1RWY3ZwQ1dTYjZSTmFGVWZRcy9WOEgrdXYvMStaYlVo?=
 =?utf-8?B?di92dTVrejIydi9WME4wbzgrc05RU3oxd2pxSGszMEoybWxXZ1pucERNeDBr?=
 =?utf-8?B?RnpCekp0MmFIYjFXKzd6UmZmZnFSRVdqKzl5ZGFGbVl6QUpvM0MvY3NUMjdu?=
 =?utf-8?B?NFhaSDhzcFoybGFKZlFZNEJBelZNNEVEOFBrR1R5amVvcm92bFdlMGlMeUF6?=
 =?utf-8?B?OHVuM1BPOHpJNVRwUDVha3NuTjcwMm5KRzlNZDRFTmMwbHlQMkEvS3phZmNZ?=
 =?utf-8?B?QW9nSVZmTGZUVGNoaGlsa3diVkJTRm1TUjl4bmxQd1pwVmM4VDRHMjJsT3FD?=
 =?utf-8?B?TjUxWnh0WlVkck1ycDhxQUpoalB0cHhpSFRMZHk3RFo2bUlZUCt2blhDc3Bo?=
 =?utf-8?B?dXpmZzgwbC9ENlFuNWc2YllZVW92cXBOQlF0OFF5NVkwWGZBb01OUDBQZ2tL?=
 =?utf-8?B?Y1B5YUszSXhsa0FvYS9kcXUyMWhzVjdUQ0FUUW9qay95R0N2VG0zeW1EejM2?=
 =?utf-8?B?Y29IQ2xUUWpHUVFOS3M3OUZ0a2dFaEljSUdib3ZXSU1UU1YwcUhZSlFmSTZT?=
 =?utf-8?B?ZS92V3YwQytsbGV1L0d2QVNtN3FITzVlNzJKU0dCeEs3WStCbmVyeUFNcVhx?=
 =?utf-8?B?UEVLWCtPUzRYSm02QktDYmJrb1hWWUxzZFRJR25PUVNkSmUrM3Q3ejJ1T1hw?=
 =?utf-8?B?dnV4M0lXQlRNTmpLVnJqME1Ndk1ESnFQREJmcHNOeXYyWDY2TVkwRmV5bGhw?=
 =?utf-8?B?TXIyYXg5OW9kbjZseTdzSVVodENQaHloNFJFZmlzdEUyT2g3QzZlTTExenFn?=
 =?utf-8?B?dkYvdVpIREJJU1hGUWlONHJ5WGtWTXNJQUZxS21TTlF5K3BMTHl3Nnk5eWVI?=
 =?utf-8?B?WEgrRVNXMElNT0ZkYXR0dmM4clRLd0JSS295RmlCVFhXNmZoWDBhaFF6YkdD?=
 =?utf-8?B?QUd5aytPVGE4M0RteUhCUnVzakNDdy9vdjltWEkxcUlmdW9EUG40cFExWlpi?=
 =?utf-8?B?YXRqWVNiS3BVVVhUWjE2RnpBSnFXcW5hQjJqa1RkVmtsR3d4ZU5FdVNEUlVR?=
 =?utf-8?B?M0labkFjTTJnb3lSdFF3RUcrYWNSR3M4S21HR0xzR2ZNZHVzRlhmcXhNcm1Y?=
 =?utf-8?Q?19jxgOGiPw0DWwfh0h3vSHedp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34206391-ed85-4cd2-5722-08da878d84e5
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3287.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 18:05:11.7201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9VOiBQ9KUNXe2wnuW0Rl3R5E9lFKg4JZG4jIxTHHGY9gXL3TGfbenClBlK0F4nVLEpPT3CxTMlPCALAf1d1evQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1503
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-26_10,2022-08-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208260072
X-Proofpoint-GUID: gp1UP8ZxRtOOx5dP4BQtZfowJmPBcQbk
X-Proofpoint-ORIG-GUID: gp1UP8ZxRtOOx5dP4BQtZfowJmPBcQbk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/26/2022 9:41 AM, Parav Pandit wrote:
> 	
> 
> From: Si-Wei Liu <si-wei.liu@oracle.com>
> Sent: Friday, August 26, 2022 4:52 AM
> 
>> Sorry for the delay. Didn't notice as this thread was not addressed to my work email. Please copy to my work email if it needs my immediate attention.
> 
> Can you please setup your mail client to post plain text mail as required by mailing list.
> Conversation without it is close to impossible to track.

Fixed.

> +	/* If we can receive ANY GSO packets, we must allocate large ones. */
> +	if (mtu > ETH_DATA_LEN || guest_gso) {
> +		vi->big_packets = true;
> +		/* if the guest offload is offered by the device, user can modify
> +		 * offload capability. In such posted buffers may short fall of size.
> +		 * Hence allocate for max size.
> +		 */
> +		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
> +			vi->big_packets_sg_num = MAX_SKB_FRAGS;
>> MAX_SKB_FRAGS is needed when any of the guest_gso capability is offered. This is per spec regardless if VIRTIO_NET_F_CTRL_GUEST_OFFLOADS is negotiated or not. Quoting spec:
> 
> 
>> If VIRTIO_NET_F_MRG_RXBUF is not negotiated:
>> If VIRTIO_NET_F_GUEST_TSO4, VIRTIO_NET_F_GUEST_TSO6 or VIRTIO_NET_F_GUEST_UFO are negotiated, the driver SHOULD populate the receive queue(s) with buffers of at least 65562 bytes.
> 
> Spec recommendation is good here, but Linux driver knows that such offload settings cannot change if the above feature is not offered.
> So I think we should add the comment and reference to the code to have this optimization.

I don't get what you mean by optimization here. Say if 
VIRTIO_NET_F_GUEST_TSO4 is negotiated while 
VIRTIO_NET_F_CTRL_GUEST_OFFLOADS is not offered, why you consider it an 
optimization to post only MTU sized (with roundup to page) buffers? 
Wouldn't it be an issue if the device is passing up aggregated GSO 
packets of up to 64KB? Noted, GUEST_GSO is implied on when the 
corresponding feature bit is negotiated, regardless the presence of 
VIRTIO_NET_F_CTRL_GUEST_OFFLOADS bit.

-Siwei
