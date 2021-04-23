Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78380369B44
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 22:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243889AbhDWU1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 16:27:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:28762 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232636AbhDWU1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 16:27:01 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NKQ6U2005030;
        Fri, 23 Apr 2021 13:26:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=TQF71pPZ1qdiXKVqQ+wy/I6rm95m5cF3SJ5Dq7iCDq0=;
 b=gMiOmOtDo69sWJgxx9nGhl8JuHWXuPGNc4zhPPgjuG33xxLC3Cl74y96KWxkVan1g7YN
 OLwlOLSKYz0sdcmBBKTUYN92/XKtW1/JoeA5GwVRVkonQGY8zlSsPkkjYXCuBDfRlVrT
 /Semh7v+UmIXcVb0YJ1YrLA+PYlSzhQasLI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383an28un0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 13:26:06 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 13:26:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UM8rEIageWSoXnuG1Nm5wNekt+W/TnHD5R98Rq11XcTszVYSe0KHS86j4QZS0Vu0jGWaUQKgCJbij+jwHCPV63nHDSFg8v0buTZ2MX7otb0EysxQrd8MNkrveANlKm3HGDM89LpGf7h8+qqtHGibxbDq0vmPpz4k4Gw1dOdxlSCPZG1lBqVxJG5Aqaz9nGio85E+L/opa0TnPMtFaJHTF0iLXiwRsOAD00rfhfv9WCptjTwhmii3PW4zSLsYHy9xYkGsWYw5xg+E1XtOF2o5WKfqEQm0RsBzc1U7S9eCmmYnQkvvgw7syV/gJvK7hNcNxjUL9//6oVrsvnxM9HI2ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQF71pPZ1qdiXKVqQ+wy/I6rm95m5cF3SJ5Dq7iCDq0=;
 b=S5Pr3UCdzR2x3uj0fxVvGTISf09RPk2TLku5At7xwAQz3I7xn4fwOqXoqGb5VmPgJI+IcJfPo2d6UwvAW/dv1VlAavu8O03hQhZ5IEGIyuSf4h56wJxVOPN62vCghHMtSxD2dz84kIxPZ6A/kFx80WVS/j74ji/+Tf+K/ykW7xge1j+td7JWS6WQBZyZ9rmI2X242JAuA9YOrbhZCKDeaCBydNoPE1h8DSiHzbqW0TvWGC3P5BP1FTqu1MAVL96Ke7cWbmJ3w8j7QtLWXR+nNKCr2uCX6ncr88QTYgXSmw7volyF3Tqfc4MQ6Erjo+zvsjpKcp0ppBFat02ByYh+hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA0PR15MB3822.namprd15.prod.outlook.com (2603:10b6:806:83::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 20:26:01 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 20:26:01 +0000
Subject: Re: [PATCH v2 bpf-next 3/6] libbpf: support static map definitions
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423185357.1992756-1-andrii@kernel.org>
 <20210423185357.1992756-4-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <44fb75eb-27f8-f47c-e5c8-bf2f710913e0@fb.com>
Date:   Fri, 23 Apr 2021 13:25:58 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423185357.1992756-4-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MW2PR16CA0072.namprd16.prod.outlook.com
 (2603:10b6:907:1::49) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MW2PR16CA0072.namprd16.prod.outlook.com (2603:10b6:907:1::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Fri, 23 Apr 2021 20:26:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 866a4d41-4cf3-4646-ea12-08d9069602c9
X-MS-TrafficTypeDiagnostic: SA0PR15MB3822:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB382294D71F60E2E32266FB06D3459@SA0PR15MB3822.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:302;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rmdxY5xQjPOoEocVDHMQjtCHYW8/yykxo3MiKUqQ4lCfq6YpNbzvoImACAmVNDIR2ydrF8bbiNATxqFHqTZjyx5H38JdS9xmYk6tOM96+BAYbtid9jNAb7ZPoK6GHI9gvbGsfnLhJv+MjNvmi7VCyvqiQ3rYm1j6UlBZ1Q7VzNhJ1Y6v+5GiNi2EHXDsOEQ9/PAP5u4RxxZHpwBCSgmmhJAV8hTSSbafrXNf+bit5Lq+8lpXNhnlaRA1E9x2LnMMrr/RKYibj0Dja0VQ+y5zysPHlXgQiIvZ3GFk1mPTTGbeMecyvNEmhhNqqggnyZNtccWVTTqeMxy2zueZO3nNdK/Ww8Q4Mxt50b3OTyz/mviio5kFHIZ+jFvfnpilyAUu+lq3xMJ/MYnIB8eod5bpYHXwl0sj1AWtH8XRGCUSBWWJT2g/VxvihEDxzC/PA0TuLi9BNcGe02C6KmBB97ELdAGslcSbCdLo+asAzeHFaHEOUtaEeUdxBnkn+swqMkyag8+k9iX09YVpfA6zvNMAsBzWIN5nNdxp6sOAEWuLnpMWP4RTvN0wH5YyFqA93N9WLWExeF16iunNjXX92EgBFCMSKBZlIXRJSeGpDrvWlpuDItFKE3Ecl3tk5CDsEgDb69v/gI2jaAYxdmZRnFg3662uP2+fB/ULO9aToYjlYtEa1bsdhUGFoYF/hY8bWB18
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(8676002)(8936002)(2616005)(53546011)(66476007)(5660300002)(478600001)(66946007)(52116002)(6486002)(66556008)(36756003)(4744005)(86362001)(31696002)(316002)(186003)(16526019)(4326008)(38100700002)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RkdkNGkzYjJGbW53d3VVS1hXVTdOM3piY0VhbDE1c3hxMk5iNlVKMEUrcDcr?=
 =?utf-8?B?a0tJZlRoVVpPQlorcllHMVF4TmwrdzVSZUpjb3ZsUVJ0ODNrSVZmNEQvR2N1?=
 =?utf-8?B?ajVCaitWamthK0Q2R3dhQ0hSemFYVGpiWmk2VE1IeHgxYTdrWS9xeEVsMm5k?=
 =?utf-8?B?TlRDZ3F5TkJzNmRiMVFnR2E2NHoxSUhDNU1HdXNFdng0WXNwRG9uK0dPOTZi?=
 =?utf-8?B?TUpWZnFMYzdMamFQSG1iVGN0eTZYaE1yUEYrd2xrRWd2d0pvbGdsbWtuaGpZ?=
 =?utf-8?B?Nk9lVDRIRzArSS8rM2FHdUh2RjhKdzhCeU14bGphb2xydzY3dENybXNra1l6?=
 =?utf-8?B?YzE1NkFRY1VwUHltWVRxTGtIbENML0kycWVGOHdpTncwWDRDZzRyQUlBQldS?=
 =?utf-8?B?UkFvYXRDZWdKUTNVRlh4N0daZ3hOa3pucnpRTjRxMlZUWVhEVnA1QmdZS0RI?=
 =?utf-8?B?SkpKYnNFVGY2K3AyMkVHUzh4OU1obmdVbmZYRnRFSlc0UkFZbWUyYW83dkt6?=
 =?utf-8?B?SVNhcmp1QXd3Qm1kb2dDZXRaRjdLN2ZtZmE4b2xhSHVacW1TR0VBTXNNK2R3?=
 =?utf-8?B?dUxBbEdhWkFkN0trSnpub3Nhcjdvd3U2L1F2RlM1NjgzQkF2Q09SeTNyME1w?=
 =?utf-8?B?M2Y1MmhnOVJ2N2NEZmt1UEpEUkUxOWhYQ05kUlBtNVJXczlQVlhmYjdaY3dG?=
 =?utf-8?B?dGZGQXJKVFVZdnNFSG5uWW4wZkV5ZVZVazF3YlF2QnhlZm4yZ3ZvdHVxMEhW?=
 =?utf-8?B?OGI0RHMveFlKWGFWMC9hL202ZE5lMUk4RkJwVlpIUkxwN0FKMVRQbjRXRUdj?=
 =?utf-8?B?M3FiRURyVFFQWTZtTHNhR1ExU3dDVEowSlA3d1R2Vlhoam1ZYWN6UWpuWTA1?=
 =?utf-8?B?K0RPSXB1cHpRamU3VnZ6MEJKcEVOa1IyVkxvMnFRN1BySUpUb2FFS0ZCMmMx?=
 =?utf-8?B?WTQyUGhlRUpLY2IwNHFOUVpRKytsTHJpaXBOTjFsV1dsL2FrU3RjVnJMTGgx?=
 =?utf-8?B?RWJpYUVrSTRGN2hOQzdiYmtKK1AyNFZJUGs2QnkzM3I1TmthdDJ3b3lka0Nx?=
 =?utf-8?B?QlNXQWNiZWdveW9SNzlOSFlEVHNFTFJnWm1SOGx4bnBiZmExNzNqZGR2Sng0?=
 =?utf-8?B?d2RJN1h1cG9pY3RvdmhOcnJIanNPUXpod3dMbllTcDZiUlUyQU1ETmRxVW94?=
 =?utf-8?B?MXY0c0NMSXFVaFFzRDVPT2xHc1BNelhTdDZma2E0V2RVdFlkUzNMSjFBR3Vp?=
 =?utf-8?B?cjk3YmxKYTl4bVZGN2NISm1jc2FFdS95VFpjTXhqU1NpNWFWY3JPM2s3dmJF?=
 =?utf-8?B?c0NPYjErUjdtUGkxOCtIRVNJNkNLcGlZdDVuSlBObTNnaGZjSUpMZlE3OXhX?=
 =?utf-8?B?V0hhaFJRc0NXRkkwZGRqT1EzMEg2QlYvRDkxYTBQWnRnSkZmdy83c0JkY2lQ?=
 =?utf-8?B?U2pUSzcvejdnRmRXY0NoNnpCZXdpRDBwQXplQmJmNXhoWGJXRE96Sk42VzJw?=
 =?utf-8?B?SXliRmlsZjI3VUtmeUxBMzBMUW40UjFhT0h0RUg3U1dyYkpVQkRJenZNbWVr?=
 =?utf-8?B?K0pUb2xheis3eEROeHN4TVFEYnlaV3ZFVXY0VjgrZHJDVDI3YkxJZndLNWNp?=
 =?utf-8?B?ZGlHOTg4TlZENkR2b3A1YVplUHVqc0hnUW1hbUFqdjREd0pBU0QyMkdHS2Rw?=
 =?utf-8?B?RkZJMzFqK1pYKzZvcVVJZ2FtVmJJNVAvdDc1bkJ6aFhrS3RrR0dnMm1QTnJK?=
 =?utf-8?B?M1BmV1Z0YW03cTNCV3QvSFBVdUdvMnE1bGZuTVJYNEhId2xjWlAvb3ZXaW4x?=
 =?utf-8?Q?FKsp5oAgZz1sTz+aXdIF9cva3oscZmbVuhBPM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 866a4d41-4cf3-4646-ea12-08d9069602c9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 20:26:01.2103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6YCWh07EcftV+OGbICMycCMdZ9zmwNnUPS8spabiTxH8kX49RIUILDR6VhzcjBzW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3822
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 2AcLKPodth11XA2iWva5H_bxEJONtiEa
X-Proofpoint-GUID: 2AcLKPodth11XA2iWva5H_bxEJONtiEa
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_10:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230136
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:53 AM, Andrii Nakryiko wrote:
> Change libbpf relocation logic to support references to static map
> definitions. This allows to use static maps and, combined with static linking,
> hide internal maps from other files, just like static variables. User-space
> will still be able to look up and modify static maps.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
