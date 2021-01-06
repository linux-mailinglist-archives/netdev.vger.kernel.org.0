Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2985A2EC5D6
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726711AbhAFVlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:41:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48262 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726225AbhAFVlE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 16:41:04 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 106LMJAh027294;
        Wed, 6 Jan 2021 13:39:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=N5/IGZH1DuiwviUa62guIiX/6K5eA1KdxHBXzodBugw=;
 b=nt+Qb+YoWtkIAY6ZwPwIhRjj6IowQQxrQbU68JSJ8rSoKpawsC6Hofgaqymqua/86+AH
 RKm0Mka1C8TaI6rcqvi6xl45W0/yEHLJ+xc/fvLoadRwimUU3z4ACChk/xx6tKe7YxuE
 SiQg/z8saIa6k4tqPvH2PN4A54diDCorZWM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 35wjnj0x2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 06 Jan 2021 13:39:56 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 6 Jan 2021 13:39:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Twoh656uCJ00XbpWzg6Su0ETJ0MyMYDN8ClwjEGEUnKmWilvnYWTHjs8h89cCzm9aMUR0qmz1rACrl22Ruy71zATKsdXqdpUlEV4qfJ2SqJzUIwnkER47l0RggRBupu6fp0cnF+eDsPAChRTOri6AZ1+SXSEvRTZ900zXvk18BrLRNQuJKNdqQr/2f35rj0cokn3LjLpnZL4WifwpEZp8w476oUUAPlPBshcdXxXF5Q7YHp8JeIGZpbDh5HeiiXL/pQBJXyqXCFc8cIEwwk6LXhCaLSBxNN+NQKlmubG0lovpgBnKr96kRtvVPGXkfwi9YXKVAK4z4DH+hUKbcBr0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5/IGZH1DuiwviUa62guIiX/6K5eA1KdxHBXzodBugw=;
 b=J98KZs70h2dVaReJjuXJSF3YX/1Jlz7/qBo/qa0b0qC+1R1OrqguVG1rY7ismJ/j82GuKZ17fRODNBDfyW7yDwtpao/9C7Pa0WcXz3c/WfUqcrSXSA+ltcNmheem79h83kixdkmg/wHdDap22p1T8ShXTlU32pTVwDf6wIgSPpxkbtxY3dfYwnxN+GpPxVj6eLcMRhy3zDxf99ch6h3IziwH5s3PtCU/o9Kuyw5whFih0EHx3LGyjIoYe3wMf1Rljqhavf/YAmyC7bCgZKNgWbtEOCC0hGAbIvhMzKqWmqZn5bstwQzatykzPhObXBhDaB5IanGoqAGhKfnS+5dxwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5/IGZH1DuiwviUa62guIiX/6K5eA1KdxHBXzodBugw=;
 b=feLOERPaQMtQi28/OCEVQFxc4FSXvJvxH4ILGSYk/MsTzwCXIzdRPiuoi6noVF8UTutXx2gnaK/wYeZTEgQLkdiE3J29ImJRtD7fSS34UWnwx3UpagZ4QKdFHnUCL5ZXfbGRiu++oph1YAJtxSjnrethc+vfcxqZ7G03Nc6U4CE=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=fb.com;
Received: from BY5PR15MB3571.namprd15.prod.outlook.com (2603:10b6:a03:1f6::32)
 by BYAPR15MB2582.namprd15.prod.outlook.com (2603:10b6:a03:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Wed, 6 Jan
 2021 21:39:53 +0000
Received: from BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7]) by BY5PR15MB3571.namprd15.prod.outlook.com
 ([fe80::217e:885b:1cef:e1f7%7]) with mapi id 15.20.3721.024; Wed, 6 Jan 2021
 21:39:53 +0000
Date:   Wed, 6 Jan 2021 13:39:46 -0800
From:   Martin KaFai Lau <kafai@fb.com>
To:     Alan Maguire <alan.maguire@oracle.com>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <toke@redhat.com>, <wanghai38@huawei.com>,
        <quentin@isovalent.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf] bpftool: fix compilation failure for net.o with
 older glibc
Message-ID: <20210106213946.sfnjfiycieo3f3em@kafai-mbp.dhcp.thefacebook.com>
References: <1609948746-15369-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1609948746-15369-1-git-send-email-alan.maguire@oracle.com>
X-Originating-IP: [2620:10d:c090:400::5:5a1c]
X-ClientProxiedBy: CO1PR15CA0077.namprd15.prod.outlook.com
 (2603:10b6:101:20::21) To BY5PR15MB3571.namprd15.prod.outlook.com
 (2603:10b6:a03:1f6::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kafai-mbp.dhcp.thefacebook.com (2620:10d:c090:400::5:5a1c) by CO1PR15CA0077.namprd15.prod.outlook.com (2603:10b6:101:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 21:39:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b725db9f-ddd1-4d54-5f47-08d8b28b9a62
X-MS-TrafficTypeDiagnostic: BYAPR15MB2582:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB25827F65FD46FD3993B28016D5D00@BYAPR15MB2582.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uVFIJ1tfhIYXnmWEBO7LUNzbInmfxHuwMwITI3Wc/leZuzTdGuGHmbIHlhHCYiw/UwNwktRiKsUIJWUZUJWLe2A59wj+n7A2jrV9VKhtZPdZk5zcW6aXEY0m0+ML6ZMEFVzMXoFJGPTxzHjjKUXY/aJwnxcbRaIBuM1WuF2akDgsN67GdmRe9isHsL6EsJCr/BIW72B0P2mW211Jo3t15bUc4cFgljHIY7YRHimFHb2SOmeYRKvOPmzZSBMmRAOhx960c9oc3lpo1fGfXU3z14vFilH8C+3vllpb/sQTTaEM83iDmNlRC3nrQWmM/xKMW04wd5Ff0Et1LoCcFCSm3lQDpDhSCxDmT/hTgDbo/jL79xSIHLTXlSq3YkweHlCxsX3YFlrUfrWVIEad4DaBew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR15MB3571.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(396003)(136003)(376002)(4744005)(86362001)(9686003)(186003)(7696005)(1076003)(52116002)(6506007)(5660300002)(16526019)(8936002)(478600001)(6916009)(55016002)(4326008)(6666004)(66946007)(7416002)(66476007)(2906002)(8676002)(316002)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RFh3dTRuYVNLTVI1Q1I1ZmlxL3MwSXBPR2ljNGpvaGtvTUIzQVNKaU8vSHdX?=
 =?utf-8?B?MEtLd0lMajVqcVJ1YUtvRzQyQ3FyMzN4d2szM1VqQlArWlk2R0s0UEIyUkF6?=
 =?utf-8?B?cE9qUkVEbzRoVUpGdDVHcnFvdzFSR2RTZDVwczB1T1BOK25kSDZHOUxQbjg2?=
 =?utf-8?B?eXMxU0tTc01BT2tsRitVK1hVRnN0ZkZ4dGsza1psTVBuZERWZjlzejhQTWx1?=
 =?utf-8?B?cXl0RnVMaU53Y2E3aGZER0dxOWR5bWtXNW55MHJnNTdBWTBIS3pWczUxL0Zu?=
 =?utf-8?B?OW5iWWMzZVBBQUVOQlB2QWxxTzNQWTQwWkRqMisxWTRVMW1MNDlWRUhxMzBI?=
 =?utf-8?B?UHhHTFg5R3U0eW0xdzFndjMvRjVwaTNyYmJSekovTFMzTWlWM0cyaitnbEhR?=
 =?utf-8?B?cnVLOFVIOGhUYjNjSlB2N3h6VUtZUHU5eEdBN2RSSTROckFtdG5GRDQ4RGZt?=
 =?utf-8?B?WjBtOUpGcHhzd0ZvYTI1YmNZQ2l6NmVINXExdW5PQXpBSGVaRVNxemp0bmVT?=
 =?utf-8?B?SGV1bTM1RFhoYzJueVkzZ0lFOEZHVlhXTTNCL0ZIYnpIQkV4RUFTWHlLVFRC?=
 =?utf-8?B?RGMzeFdienh0aGlzVG0rVGFPUFZzUXkvd09ZMDFDKysxYlU2aktocmlFaFMw?=
 =?utf-8?B?RS9UZmpJdERuODkxZDR2UWhXWC9nKzMyTGN2bWFYdXNSVDFJejVUeDhCT1ZV?=
 =?utf-8?B?WVQ2bUVvNVArTjQ1QmNMMk1uSzdtcWw3SlRVZnV2WXJySmlRQklHd1EvWHdM?=
 =?utf-8?B?dEFxK3QzSTdyeVFHM1pmWG1Ma0JhYUlCTUhUT1k1ZU9aNlFBZDhMcEJnTGVU?=
 =?utf-8?B?aGxhWEZjVVZ6WHYxQ1ZwUUVlcm5DR0tKNkRnSm9ya0E0d0dNL0N6WG1GWW5O?=
 =?utf-8?B?R2RrNG81MGwwbld4MXBiUC82RFhwNjgwWlpaRjJDN1Nuc0RCM1J5emJCdEY5?=
 =?utf-8?B?VXMxRU5wTW8zZk9rak5PejlLS1RZOGhtbm9GNnZKSTVJNlVmNmhmdnhMRnFp?=
 =?utf-8?B?dXZnQnRoUEhDVUIrcDYwdnBBd09wb3k1bUpEYVQ1VXp5UWtKWG5jM3JZdE0v?=
 =?utf-8?B?NWRBMXY1YlRIdmg5NkNONGxaV2xFbnVua294ZFR1djcrY3E4dE1KWlpJQkww?=
 =?utf-8?B?VjlxeDFEL0hxUUFmeHk1UzlyRWtiZXZRUWxpUG5HTEZ3QUloL043R2J4SlJH?=
 =?utf-8?B?bTlhWW9xbHVuUEQxYjhqWGZZSWZ2M2dqeWg4SHhJemlEakNWM1VrQW5nWnNK?=
 =?utf-8?B?dnp0VjRtcFkxY1FWa0xibUhoN1JFOTEzWjJPaERkVXhwTnNIRmUyTk9RVzl4?=
 =?utf-8?B?SFhVdHROVHp3aXB3WEk2Sy9SS2dXNExhUTJib0xqSHBXV3RScHFrUnFCMSty?=
 =?utf-8?B?M0NwMmk1dnJWckE9PQ==?=
X-MS-Exchange-CrossTenant-AuthSource: BY5PR15MB3571.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 21:39:53.2342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: b725db9f-ddd1-4d54-5f47-08d8b28b9a62
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H+6gO7hNjX0OsyF5Z+7inc7pqA6Z50ZcPJY1Lz7EPU7ycY48xv4jU5tC2YzhF4xV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2582
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-06_12:2021-01-06,2021-01-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=665 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101060122
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 03:59:06PM +0000, Alan Maguire wrote:
> For older glibc ~2.17, #include'ing both linux/if.h and net/if.h
> fails due to complaints about redefinition of interface flags:
> 
>   CC       net.o
> In file included from net.c:13:0:
> /usr/include/linux/if.h:71:2: error: redeclaration of enumerator ‘IFF_UP’
>   IFF_UP    = 1<<0,  /* sysfs */
>   ^
> /usr/include/net/if.h:44:5: note: previous definition of ‘IFF_UP’ was here
>      IFF_UP = 0x1,  /* Interface is up.  */
> 
> The issue was fixed in kernel headers in [1], but since compilation
> of net.c picks up system headers the problem can recur.
> 
> Dropping #include <linux/if.h> resolves the issue and it is
> not needed for compilation anyhow.
Acked-by: Martin KaFai Lau <kafai@fb.com>
