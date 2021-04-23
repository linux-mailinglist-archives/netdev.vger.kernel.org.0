Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627EC369CF4
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbhDWXAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 19:00:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59484 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhDWXAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:00:38 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NMeqHi006858;
        Fri, 23 Apr 2021 15:59:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Uzz1RE2aohYcI/zEh7ZZecDqYAbW93cuMOQjGR4rh2I=;
 b=PkEn58SoIMHHL/1EDGgSDV5BhFDzCTJ4XLwSSf4oc4JpzmmZGb56uh2NRnmGrCTiEshM
 9Nfs0/F1pD+2ljRE3yqXnZvR0gPC7tpFZMsR1BuPLqOOFqPVRXjHFdEWUhtzTBsPWJ4S
 +4HJimCDRbCFZvjTe4ut+Gg88GVzJPfeBwg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383b4q9jam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 15:59:48 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 15:59:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tk++oTzw7uOotyCuDrViWJdchCSs3bEl9MkzlCFvfet8nq/rxGnz8zLvVNjgPwaNzCOduQNvQzcq9rIKH7boSLia2x75M2hNMDAzza38KT0a3g7VLXyY7OaVAO6nuRdtseUO4/nRC2I98xun+y244joubGlvhGkjKLMQaUMmatGQigJFUzrMEt45IfVOTkKTfZkLdic1d97X2Fb+GFa2nn35TuSQ7wI8g+uBsKEZJbI3yfVNsxi/7l7NBnxlHLuG8SAlJvS2ypi4XESTGvSg+ACQW1WIthnpAc8LwQobVw8ASBTdgl9tOZooQ7BoU/MVkOWrksCXpRh3gZuXOvUoYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uzz1RE2aohYcI/zEh7ZZecDqYAbW93cuMOQjGR4rh2I=;
 b=Q5Tr9jKLEgX8lN1xVAGk4D1vjAP5aAa1P+sOLyZo+W3M9tUBx+LRasv8PhSYW4QxjK3DNXoynbMOL9oDGBtM4hwgGG3n0fnI3xUMmtcmITGrLOeJd2yexeKnIRVddvIFmsa/3a18lIozHqzjbv7KQpPehlM3Rz52clfRnESKeArwdffVdHMzTRgY9siqPaGYcEUp/U2Ok/OJj8n56vJebslBQSqEUD/46IQQNHaD21KomjLul272zefBhQKN5EiNX6WlJkd965B4ufanwVYb5PqcqXMOWuSgU/p7R0cd/QQrb21l87GIJCnazvyMZvDC2ztSKTm2zoR3Yn6NFV3B5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4919.namprd15.prod.outlook.com (2603:10b6:806:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 23 Apr
 2021 22:59:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::f433:fd99:f905:8912%3]) with mapi id 15.20.4065.025; Fri, 23 Apr 2021
 22:59:42 +0000
Subject: Re: [PATCH v2 bpf-next 4/6] bpftool: handle transformed static map
 names in BPF skeleton
To:     Andrii Nakryiko <andrii@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>
CC:     <kernel-team@fb.com>
References: <20210423185357.1992756-1-andrii@kernel.org>
 <20210423185357.1992756-5-andrii@kernel.org>
From:   Yonghong Song <yhs@fb.com>
Message-ID: <af65a52b-7a64-74bf-8330-2f4f93547c82@fb.com>
Date:   Fri, 23 Apr 2021 15:59:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
In-Reply-To: <20210423185357.1992756-5-andrii@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2620:10d:c090:400::5:a7ce]
X-ClientProxiedBy: CO2PR04CA0082.namprd04.prod.outlook.com
 (2603:10b6:102:1::50) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2620:10d:c085:21c1::134e] (2620:10d:c090:400::5:a7ce) by CO2PR04CA0082.namprd04.prod.outlook.com (2603:10b6:102:1::50) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Fri, 23 Apr 2021 22:59:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a5a762b-6935-49e1-0e19-08d906ab7abf
X-MS-TrafficTypeDiagnostic: SA1PR15MB4919:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA1PR15MB491940C62C6D0868417025F8D3459@SA1PR15MB4919.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6YR/35jNYGv4t+1vXTPCMtsi8t7Xlhl/O9681lj5QfURAfWjnKiymxVGDSP7neLGomilBrbWcMG3Oza3dV4FFwnRgeWY7OR9OgLxFTnE7CuhszAychivBRHFn5n8+gOWCgx0asqb7Ed+6+GqVhubtkVWXdGadkbxaWlfg5x2AP6FrX4mBBTF9Mufxx2d+rp/H59QNiTFtOpQMWpc+fj8/IlOuUvqbJcRylV4A44dv5NSx8li8H14Dq9gEYo3fV5gygfSrt/Stuv+zlW30d/ygDTgdJEtVma/HX0S4uHZubf+u/3efA2qLwDPzqephjxeW3G2qkHt+6a+mbF5i0Lp0N1v2qteMP3pcus8IIiMUGTypmS17tL7i0Pp6CYT6e+93/9mfqQcAI/HuFYNPwLclHAUwjg77BKs4DyMGMAfn456NIWCo+KMHln+DgIIpoC0KEDy43C+Z3yqQyp141krIUe2e9FPTyb6x6e2Gh2fmNs80swZF2SaG3lvpf8GoqwxUb/1aBCLODVjRmR3hwaK6zq9L15Dz0roCFEAc6oFfW5ose4F8atPL9RHZPTqbWaZVbNW3MCjZHBWqhE9p9xZ5sddqAsteUE6qzqKILzSp+VezjzHNtY5KeyTR/RYpMyTCqQ7xHhvytld/jMfvD+Kv8k6V+0y1zxCJpguaya0DDAQVd9es3paCsBgolpkMy7t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(31686004)(4744005)(66476007)(31696002)(5660300002)(316002)(86362001)(6486002)(2906002)(2616005)(6666004)(36756003)(4326008)(66946007)(52116002)(8936002)(478600001)(53546011)(8676002)(38100700002)(16526019)(186003)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eGR2MjdJZG0vSlAzenUxSGN1a0crN0E4TTltV2lYM0ltUkYrVlFrQWY1bkI0?=
 =?utf-8?B?eXFHN2x4cVVHRXN6bWs0bnkrZWUvL0ZrS3VFYUdIS24zcFpocmNpQThDZXFx?=
 =?utf-8?B?aTc5RXJ6bjQ5c3BHV2dHcGRpRkVUajVDWHVPMmUwbjBqb3NGbHZsTUQzVFd6?=
 =?utf-8?B?NkxVTnZST01oaXNzZnJBbWQ5d2dEY2drQW44Z095VlJ1NHR5MVJOOVAvMVpH?=
 =?utf-8?B?aHNIOWJWQmF4RU9OeFVJejBvNkFJQ3BYdm91OTlMSDU4WHpEQ1FSNXk3WUFM?=
 =?utf-8?B?RHE0WEd0cUZuYVgvMk94SkJ6cHptT1BQMitlc1lBK0ZGWHhVdEh5NGRES0l0?=
 =?utf-8?B?elFEeWxFM2dzUC84RkRZYkJWbVdsZlVJRC9KWStQUTRYQ1VVaVovMldxWG5T?=
 =?utf-8?B?cDVFcTAreVg5T2hicm00V1VGSXpaU1ptOUUyUEhaUTJlSkEvRkZWc2thNGEy?=
 =?utf-8?B?b0RvekFNNGNoQ2lBenNxK0xOdjc3cEMzRmJOb3FkMU81WVExZDNUT2JNN2RM?=
 =?utf-8?B?bjZxemVnN2NaZEM5V1JadUduaVRUOHdkbm53akF6TmN4aStEdklTdTFyYkNt?=
 =?utf-8?B?em5MY29yeUxGTGRneGxndWs1d1RsMEZUTTNhNVRWZFVEMXNMbUR6S29raVZD?=
 =?utf-8?B?dU5IN2FmNXoyQmx3eVBrcnlaOHBxMk9ZWVhiTEtodHZza2poSGgyRGVWZURw?=
 =?utf-8?B?Rk9nRDNXSUVXUmU2UzVjaDFRYWVIaUNYWGY5YU1KaXFBS2RrUEJROGczOXBX?=
 =?utf-8?B?SklidkorSmUwRVRUQU0vWTRTdlZwcGdGdE9vR2haNXgrUWhOSEw5WS9NTENV?=
 =?utf-8?B?UW5VaklRZEJLMEdycEVYTDVPVTdRRXhBZkVEREFVTnF4MnM0c09HVHJHSVUz?=
 =?utf-8?B?dlNiWUdHTVZpQTlYSksxTjhraklIdzBsSitVOTZMdVc3WTY5S3FqZ3hUMkQ2?=
 =?utf-8?B?SFQ1aWY0NjBnVWdERGUvaU92MEZiZ2xtYjRkWVZ6bGZ3eStuUTd3UjMvWFNY?=
 =?utf-8?B?dkd5TVlaTVRqcFY0dEltSG1yU1N2dFZZekJtWUVkT3J1TlBBblBlaVplUUox?=
 =?utf-8?B?dW1MaGhDbS9ZL1RBZ1NlRVd6UTZUbjNNSE8zeFhmdmFBTDk1cE96VTF1QS9j?=
 =?utf-8?B?Q2taRGora0dXZkpFRXMxQ0twaW0xTnlubmtCRUY3Yk5BSnZkbm90dHZtalNV?=
 =?utf-8?B?Q3BSN2lYSnY3ZDhlS1UwUldWQzdOSjJuTVFpMWh1eURVQ01rZkRWc0FDYjQx?=
 =?utf-8?B?dUFrdWVXazhoUXRzTWJsSkovREk3NEdEbytqaitLOW4wSkFxWkdyRXhSV2Mv?=
 =?utf-8?B?RER1dWlOTE1kRExPOW85VHdhZ1pOVzJXK0Zwc3hlLzF5WEtneXdLSmRlNzFV?=
 =?utf-8?B?TWtiZU40YTdFN0d4WG40MlZxS2Mxam4rc2g1dU1aWkU4anNwaCsxMUY3UVZE?=
 =?utf-8?B?ci80SFZ0MVhCdkJuWEZ6YXMwQ3JFelVnSmY0ckVFd3V1Vm1xQ3JmN2c5RDFi?=
 =?utf-8?B?L3dDMGpUR1NvbkVkQnkvaFF0RUUxZmZlU0tQeDNXK29zbk4xYllVYjY4bHRB?=
 =?utf-8?B?Q3BMY2x2MGdpRTZDVnR6S2d2RTU5NUhSWDRodmtHT2xhSkdxam54K21CYk4r?=
 =?utf-8?B?R1RDeFB0RHZILzFpOEVVbFBnZlU2bmlBdU5YaEJPOHJ6UmRzQllYekV6MDlq?=
 =?utf-8?B?dzUwTEpHSVFuV3NQRFlQTlJya0xRL2VyOUdkdzV2ZCtlNURmb0lGMnhsMGNC?=
 =?utf-8?B?bWFzZjh0OG9hdGpCK2xIbnBXVCtDVnYxemZ2MEc2aXJiOHM5aDEwQXpZMGFQ?=
 =?utf-8?Q?wUeDphcE9DrpVUfwZovmgzgYaiWg4ukXvtNN0=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5a762b-6935-49e1-0e19-08d906ab7abf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2021 22:59:42.2109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YveX9cFNehq7zmtaUdA4s5wWA5J46bHomhJRgZfUWiOY7sDGMgRlcW2kAfKnhBuv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4919
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: _6t60766-cCrWsvzny942RxBbqjXRX2t
X-Proofpoint-ORIG-GUID: _6t60766-cCrWsvzny942RxBbqjXRX2t
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=999 phishscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230153
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/21 11:53 AM, Andrii Nakryiko wrote:
> Static maps will be renamed according to the same rules as global variables
   global => static
> (<obj_name>..<map_name>) during static linking. This breaks current BPF
> skeleton logic that uses normal non-internal maps' names as is. Instead, do
> the same map identifier sanitization as is done for global variables, turning
   global => static
> static maps into <obj_name>__<map_name> fields in BPF skeleton. Their original
> names with '..' separator are preserved by libbpf and submitted as is into the
> kernel. As well as they can be looked up using their unsanitized name with
> using bpf_object__find_map_by_name() API.
> 
> There are no breaking changes concerns, similarly to static variable renames,
> because this renaming happens only during static linking. Plus static maps
> never really worked and thus were never used in practice.
> 
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>

Acked-by: Yonghong Song <yhs@fb.com>
