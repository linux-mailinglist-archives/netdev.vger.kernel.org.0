Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206EC3699D2
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243573AbhDWShI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 14:37:08 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2362 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229549AbhDWShG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:37:06 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13NIPe9U025210;
        Fri, 23 Apr 2021 11:36:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=ZPBfUjRE0B+fCJdEhNh/TrynWHzx41QV61iNasviTTM=;
 b=g8uN/rXnufN6/YHYVlqjqVMZAPQ7iD/jaLBNP6SQWGtL67JwvjOpNr0Iv9ux+u/cHHXE
 HgogoR3EkHyge/k4O9nFynbeEuue+IWVj9yCIoAFpVsui9ZszTInYUjhnagKcOdQxTZN
 K3ie/iTJj0saQyOixKQBtFbt7o49s6jXhLU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 383h1unq32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 11:36:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:36:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CZWSBestcyVMzKDnBV8+Ttwx/ltQ7I8nzsFDPqpfV3/Wdvo4fkAYOcbk3ZfoELuzUjHxrCoxxB1qSZdrBtZYhq7mmQd87jtvo67p6cdC9wMgJXRTXlk+iODuntqIRKe6GwXXf8xKbDCJvtCHKus0G0qNKZdVfol+Dov2UBmTGcXUksY+yHiUruAouc4s1yAJhBzoEOOE5eTmZC34LIDgr0tfsfrZIUswHZ0HrctroNYFNn3H390XLi3pK0cRD2RuGl+nofT96eysCYxfzXk0Gox30i0LTwC4XG1YnUw0narohq0BVQbccvMPnMTFSEbubt6ZYwnnU7QYBF/HpO0Qhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPBfUjRE0B+fCJdEhNh/TrynWHzx41QV61iNasviTTM=;
 b=NWP2ZTmqjW265GVgtq30sWPDhOUVz6wTW9y2vHyfI/trIoWOE0scX+P/5zw5EaGINFx6F8mqkFKVOVQuvKO7uuScyu21+dlCrtculZXL14Prgfr6vVJ4W14qNb3itZ5cLU20DSVkW5njEvcTfHjsJ8vY4h5UwyClv+ozlUSQTEMQp+oEJlu92vu2mbqkNGVYA/vLGfyGPr84tbaFfKvjq2tVUR28Ey4E9/63++Ws1LdBIaajIi/lq1yDrTKWg0et9+vpJQ53Dy+fsnuk/GYGkIruq2+qpYfSks2+K8lksaduzTJLGU4gmmTVDBLvvG9hp5rKzBzD2wM1r5Y7Sj/6Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4386.namprd15.prod.outlook.com (2603:10b6:806:191::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Fri, 23 Apr
 2021 18:36:14 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 18:36:14 +0000
Subject: Re: [PATCH v3 bpf-next 06/18] libbpf: refactor BTF map definition
 parsing
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423181348.1801389-1-andrii@kernel.org>
 <20210423181348.1801389-7-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <fd61eabd-4205-f173-b67d-c1bb267ee770@fb.com>
Date:   Fri, 23 Apr 2021 11:36:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423181348.1801389-7-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:bc07]
X-ClientProxiedBy: MW4PR03CA0125.namprd03.prod.outlook.com
 (2603:10b6:303:8c::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21e8::17f2] (2620:10d:c090:400::5:bc07) by MW4PR03CA0125.namprd03.prod.outlook.com (2603:10b6:303:8c::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Fri, 23 Apr 2021 18:36:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88830c6e-7f1c-4ea7-7e5a-08d90686acba
X-MS-TrafficTypeDiagnostic: SA1PR15MB4386:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB43861A1D61B47B900894A49AD3459@SA1PR15MB4386.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wck+KiPjBUR29//ehldcH8CbsAiTdGVDHrotm+1Vv2TEvWtO5qWdTCLxVs3OrvlVdgjQAzT6tqySay9WrIhahExX61PtZsE3MVwRAAGIazRB7+4DN87cULTKu0q0YmFD+ISZUYHfavhY3zO9w+iYdQQHQrfyRb+ZGY8A4/DgAYnmNmvDvnHTn5VERU3LHA4m3zNWeJuoyQ7PZFhMhn2T1fSg6B3x5IJrHpA0Bq0wE9kmSawGnyG8HMnPyT/7lgia5tErCgfhsjDG5tna/4jBUE3BPx8Fwl4wCGRMnGkdORHFbJBhazgfKaaRZRcMotZcvLhumbMoEU+hEnXP/iica+emfPrMZJniD7FM2Uzh3EjExSvdp4ag8yFtvRUDi2IdW/Afft8WCz1gYQuZjraowXmg+EHtH+J6/wrLBtukhVlzvk4aBx1QzP8DEMxYv76hgCgCV/OPcqjjGLM2Qjfb7zhiLK0JISejXu2cKcxjNt1THF7F2DWSmLC8TsrjiwJ6+ul3Q47UsQyiXfdYbzZaoFWghll8MEC83mkzodJOBkm2+EtUAVRSxSWZxUmAjv8p9jQ+WNijvLkjlXhcD6yaKTrVmGOY0NB9BjVw78P3VcaAWsa/RiiXA5YPDsFNKdiZ7ZAILyzlxwKvF8BO5EYo9BKZTm7nmqmXRZwbNJewXuxeuaYYMn28rrxqxAVM5HOT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(396003)(366004)(39860400002)(478600001)(316002)(31686004)(53546011)(2616005)(8676002)(6486002)(66476007)(38100700002)(4744005)(66556008)(66946007)(52116002)(4326008)(8936002)(36756003)(16526019)(86362001)(2906002)(5660300002)(31696002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NVhjN2NhaytGd0p3Mkx5eGhYaDRpU0todWh0M0o0eVBXMDVMUVErQmlHQXNV?=
 =?utf-8?B?UjRRdTFMa0pOU1hxVzdINDlxNEZIVWpFSzMrS0QwTS9VdFpBVmVEakJOTFZj?=
 =?utf-8?B?enpFdTZzV3hPdTF5ZzJmOXFBOXlRTGxuN3lSVzdUZnlBcXdZSC9teWcxak12?=
 =?utf-8?B?c0oxUm01THJ3WDhDaU51cFRtUXJqdnJXZzViMkxmUFVMMXoxNHJzck9GNjJv?=
 =?utf-8?B?aTdpQzJnaGVqM3Q3eXduVFhwU3lIOTNhZjhIQmdPVWQ3eWpnVzFSQ1VnSkRG?=
 =?utf-8?B?T2xyUVZONTNhMjlBK2VTTmh4NHlpcEw0QUEwOEV0YkdSWTBGTU1XanN2Vzg0?=
 =?utf-8?B?c1RHMW94V2wveXllN0l0enpqam5ybEhoTys1VmE1V0hHeXM5MVVZOG8zK25F?=
 =?utf-8?B?VE5nZTcrK2N3ZDEwR3A2bkgrOU55OFAvaXNDUHc3MjVIMTJvNlF1cHMwVHNj?=
 =?utf-8?B?elZSc25yQlVxUjJ2U0Q1ZG91NjlGQUM4RE1yVlh3UHNkV2V0a0pJTzY4QUZh?=
 =?utf-8?B?dUpVNTJVWmRXQjlOcGFBTVg4c3JzbVBMM0V1Rm01UFF4OWNVTFhNakZ3cnEz?=
 =?utf-8?B?R3hjWmw4Q21INXA4NXZLNVdybkFOblYrSmt6TEZZSnZuazFGMitLZW9jUGFr?=
 =?utf-8?B?ZDhoMVVyb1IvQWVHZ3h0Q1dNQk1TOVZvaDhXTVBMU1EvS2hrNnllbVIxSFZr?=
 =?utf-8?B?Zkg3b2MvOHc0WndUemJGYk4vQUdpeDRzZGRuTnR3dDBGc3V0Rm5NU2cxS1Mz?=
 =?utf-8?B?TW43aVJKandTLy94TXFnc2dyQWVNM3N5VUVkKy9MZDViUjZlZXFzL3J5alh5?=
 =?utf-8?B?djNSYWdLeFMrRGRIQXc1SHhxY29FbUpIeGt4U3F3NXA1cjRVZWh4cGYxaWdY?=
 =?utf-8?B?SVoycWErbFZyeEgvdVhUM3VZcjdJVmJyYUxESGkvTGNRQ0J2SFd5UEM3TDZS?=
 =?utf-8?B?UTJORWtOK1RweTBydVNKRjB4ekxZQnd2dStueFN0Y2JaUnVtOCt1R0FUaStn?=
 =?utf-8?B?RGtjU1VWOW5FTTBhNlpTcENyZEIycjNVYWMvSUtQUTlHSVZHVlpyZm9mNUU3?=
 =?utf-8?B?N2x2aVBZY3U5czIxY2hQWWlkMWtablhobnRMZjFtMkFyd3gwM1R6Qms5d2Vu?=
 =?utf-8?B?blJsajNUaW1JUTh6UlFML0RFUXlEU1hZODQ3UzRyWjZrWnMrdmFQd1h1YUxH?=
 =?utf-8?B?cmwzV2ROcmhJeVRvOGlZaitWTVg0eHdhZFNrRkp6ME45UFZ0bTBhVm5XRVNB?=
 =?utf-8?B?cDY0elQxRGpIQmlvVC81RWNGMG9HMHBuUW5mZ3R4VUFsR1p1MDNQaGFJRG0r?=
 =?utf-8?B?NHJVbE5ZRDZGU1lFaXY1T2ZqUHRXRXVUNVhhMk5BQ3NXR29obkpzNm9FWDU5?=
 =?utf-8?B?Nm5mRjFVTjhFbFVyaDI4ZlhacnZrM3FoQ2hDZy8vOWxiK25IdWJSckZqNWxD?=
 =?utf-8?B?R1M5djkzQVJxN1ZXWHhzcnVrWHdJL3RWSkRNalo0OTAvVjg0dzdHaW1zU1k1?=
 =?utf-8?B?T2tsRDViQU1TSDA3bUsxcUJIRHprbmp0YWRRL01yeVZPOHl4NWFEcExZdDVm?=
 =?utf-8?B?UGswRHNYM0ZDaHk1WmttdUovUmdzZ0UxOHBMbVhsdzBCTTAxTzRDL1J2S0gx?=
 =?utf-8?B?WmZ3Znl6Ry9SWmJjS0tmaXJ4K2RZYm9tM0pRck5xZm5SMWZ5NHlYeG81aDM2?=
 =?utf-8?B?bzJ2SFZYVVhKQnNhbVJwdG9EZ1RnY2hzV3NvYlNES0V6NmFhN1BBRzdqcEpv?=
 =?utf-8?B?bUhvYWVvZlNKZ3NoZjdwU2ZkcUh2SjNvYU1aazRpQllEVTRFakFxajdPWXh4?=
 =?utf-8?Q?oUP2cv4NKQxku8W+p+vZm+CzZpDMj4I4R0Nl4=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 88830c6e-7f1c-4ea7-7e5a-08d90686acba
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 18:36:14.3802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GOeO+dekKFleXwonXKu2Z85oeC1tCcxx64R62qLtyzHU65dNwU2v4fbICEA+2aC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4386
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: YQbzPINGfwGpdtiHKzl1h_LcGXGuSli9
X-Proofpoint-ORIG-GUID: YQbzPINGfwGpdtiHKzl1h_LcGXGuSli9
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230121
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:13 AM, Andrii Nakryiko wrote:
> Refactor BTF-defined maps parsing logic to allow it to be nicely reused by BPF
> static linker. Further, at least for BPF static linker, it's important to know
> which attributes of a BPF map were defined explicitly, so provide a bit set
> for each known portion of BTF map definition. This allows BPF static linker to
> do a simple check when dealing with extern map declarations.
> 
> The same capabilities allow to distinguish attributes explicitly set to zero
> (e.g., __uint(max_entries, 0)) vs the case of not specifying it at all (no
> max_entries attribute at all). Libbpf is currently not utilizing that, but it
> could be useful for backwards compatibility reasons later.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
