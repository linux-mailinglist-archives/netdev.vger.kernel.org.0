Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947A8425E58
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbhJGU7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:59:47 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:21886 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232229AbhJGU7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:59:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 197Ktnhb011503;
        Thu, 7 Oct 2021 13:57:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=xC5+UGF4hpPZLZ6CmLwFWMrS4/128UUwoLQDZY56pIg=;
 b=THD9n3xkPd2XLccBC5qXWtHU3whOCM6yql/PkbKgFnSvznBsp+ZrkXIw6QiEDLj4bdTt
 2TuV/a9oUd2EdFksqHiByoU9/cFB+XwTd8fO60pa8P/T3uTaW6xIsmNHuvc2eM38LyPu
 718+A54R0y4epocWW6gfJJUNDNO9Ys24qQI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bj8c2r098-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Oct 2021 13:57:38 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 7 Oct 2021 13:57:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B72iVH8Z31loeaaSLMyei38e9lBAjx/y4A+nfBbHqwWGkh0/i4Fh/Cd0clXMVoZRoVkGby8tHG2akZZMCcSniXxd+b7jlyBY/67OChPOv5MWxNjz0hNiB9Z41cNGRIA63tnBq2uY5XHugSFXrsI6Yo8UTCPtjVmb1o58g1ULZ5TgL0ZQqwpFFWSuDzqZggxWj9Zvebs/5DMvILC9cnMKpW3djeiwDx3OEJje44jMxXTwpt9xQZ8IVPqc3rCF8jID7+/H72MXen+LpFWofsbnK7BigIhy6JlgwvvvN2gE21O4FTh6ksOTb2CGkENRwJxoU5tacnwHVwcUMxdgYuoPCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xC5+UGF4hpPZLZ6CmLwFWMrS4/128UUwoLQDZY56pIg=;
 b=hRaUzbYk31A+RA1lbFh/s/rgTpp6uIq8iQ8Tjt90+dm/ZC1N3PxBjoOEfGYCqUBRo2ea1DMS8yKmnlfr9+MqG8NDBw6J0QMR1sRikZw+/cR6vtT5lWBbFpdUAvzz+ORNWhH2K3xlVuOpQbSs1+/4LfHvh6gtEX/Iq6afXpxN+r63ZlSxtsXo0la2um0iT/a4a1bHw8eYBczjX194E6SqydEOGdgTOnVQnlwkxNVDtU8A4prmJlytX9LS2YbyzWw/nFMD+tom5C8eccN2Jj6TrlRN+LZ4qqn4D8Iov6IJNJ88o2xpHvlGkeCN0U0O47pmWFY4Ep2YemWbrra0IfTGUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=fb.com;
Received: from SA1PR15MB4465.namprd15.prod.outlook.com (2603:10b6:806:194::23)
 by SA0PR15MB3885.namprd15.prod.outlook.com (2603:10b6:806:89::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Thu, 7 Oct
 2021 20:57:36 +0000
Received: from SA1PR15MB4465.namprd15.prod.outlook.com
 ([fe80::85c6:f939:61cf:a55c]) by SA1PR15MB4465.namprd15.prod.outlook.com
 ([fe80::85c6:f939:61cf:a55c%9]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 20:57:36 +0000
Message-ID: <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
Date:   Thu, 7 Oct 2021 13:57:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.1.2
Subject: Re: [PATCH bpf-next v2 0/3] Add XDP support for bpf_load_hdr_opt
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        <bpf@vger.kernel.org>
CC:     <kafai@fb.com>, <netdev@vger.kernel.org>, <Kernel-team@fb.com>
References: <20211006230543.3928580-1-joannekoong@fb.com>
 <87h7dsnbh5.fsf@toke.dk>
From:   Joanne Koong <joannekoong@fb.com>
In-Reply-To: <87h7dsnbh5.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To SA1PR15MB4465.namprd15.prod.outlook.com
 (2603:10b6:806:194::23)
Received: from [IPV6:2620:10d:c085:21cf::15eb] (2620:10d:c090:400::5:5b25) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend Transport; Thu, 7 Oct 2021 20:57:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f6193d3-7c4e-403f-e0b4-08d989d5173d
X-MS-TrafficTypeDiagnostic: SA0PR15MB3885:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR15MB38850CA959914F27435EAACED2B19@SA0PR15MB3885.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q56s0qNQUmrMPEfWWfWJYYdkEdFxYo0ox7zXd283nHVe9VcThL5u1jFlnYARh9igmdARarIy8uDqN35d4LaFXBpLWpwX89E7Jwq7R9+bYPgIM0RpmN/INUUw82+1sCco2CsHeA33NZDX1EzlR93HMYzX6ZqBHEm+vQW8CBG7AmxjuJfAZ47ukexElGHHcH1orV8QMsGDFJ5a4jv2LQ1ctCpB3vcLDvBZCCf2hgUKk3vfq5iIyatmEDIh6sYAzrs/77iLmf+xRo4k4Uib6pQ/zubvbLBSp+pJ772ZgDLfRhp1OiA/WXxfzoN1hA2e+S3hk4OdmTh9h2XEhHknzk4xd/KE0FocSl8aD2AUDXIPR5hD/LTUf2HaZed29CmSRdYsswNAOoT9JUW6rniaFNt4U9QV2Dz23ELhFN6+Dn0/IDKAyc0/nWOUFewuVk3jPGGLvBzz9R/ekKOBKzjn4AM6ka4ib14ZNz7/AxzbVCvu2ZQwgD++VpN0iMb0QIVCYTH/USOsz3B6azKsBCcbbRkcGtnBD5Fo40ScUlUfENf3TL0exr3xA+If1xX9E4lOSnQPeHLQIXcAhngIV/5VmGhqAFPT0PrDyPYVd/iGO4AYzDIUiuiuRPHcPCL0apVg750Fq7X70bN1exgCWddO3t+9sD44+dUJ5PFgCxuVSPb52Yyj5DbW6FgKciSZjI4BhQlGxmqpU00QIbpIVPjiwfSVEk8pazpgK5TWkBR1e6LsPiCZytfyap2tVApv/5nNHvk9iA3meDn0f0wsCaaKXnT/qw7S8FbWejUFrdiDpfMgfsvENXeXGb3MQ+297CN3q238rUuHXf3DMPfhJw0QxnBS8opCVUOVyB4LMU21yP7FblA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4465.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66574015)(316002)(36756003)(31696002)(2906002)(66476007)(66556008)(86362001)(186003)(966005)(53546011)(83380400001)(508600001)(66946007)(31686004)(8936002)(4326008)(8676002)(2616005)(5660300002)(38100700002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0FNeVpLWkl0eW1hQlY2bkx2YmszQ2lFREV4WklUUFBxOFArK1dYNm5VMzBo?=
 =?utf-8?B?akRBWkNwT2VXNkVDeW5zNUZrSXVSUTFFQ1duUVVyNEZFT1BTck9xSG44K3Zq?=
 =?utf-8?B?SHdwWTM1M0hrUlhJejJkUmZLRFUyTlJISktZVFRKOFN6QlJtSjNpcm5TZmFx?=
 =?utf-8?B?SlJTMFhtT2NnUHAxbSs5by8vS054QmNzbTFkN1dsdGp3ZVR6ZDRiYUJVMCtm?=
 =?utf-8?B?TW5DWEc0K0JsbkJTQ0hlOEk5ODViNm9scWYyMEVFRHhYeEY0dXNuMWgrWjU2?=
 =?utf-8?B?RElFdmFpMGtaVXBjL09rNTdwQTNGeFQ1V0s0YWpJVnBHTGN0RzNmcmpkcWdI?=
 =?utf-8?B?L3k3ZTdYUVd5REVnMU15OWhlaTdNV3dWU2NvdDRWUDJDeVN6VUVkUTlPQkFW?=
 =?utf-8?B?VVp2cGFlY01GMThEZlY4RXpYMTRMSEJBcDJMZGJDMEc1a0hrc29QbVlPV2VZ?=
 =?utf-8?B?N3RoVnZGSUJXTDlvdzFONkNQcGl0a3BYdzM1aXdEYTNyeHNoQm5CMnd6aXJK?=
 =?utf-8?B?OWE5cG5VL2Q2bFRzWFRSWmQ0YzJQSFNJemR0RXIyak52NmRpWERyU3FKQ2Va?=
 =?utf-8?B?VnU4KytqckZTWmt1R1lFOUs1WTQweVVVMkhrcVU4MlNYU2dHVWFDMXBCMDFI?=
 =?utf-8?B?cTZtU0phZ0Z6UnVXZTVVWmJaWkhDa3REY3Y4ZFV3UXNvaWRuYXBEQ2YzajdL?=
 =?utf-8?B?eHcvWFFodHF4UDVUUTkwWWFWRFJ3aDAzVGpQSDdLNGh4dzEzL3I3Yk5MWks5?=
 =?utf-8?B?dkY4Z2c4VjJHMnV1eUxncUlMRGxQeU5pd2ZYaGlZYTE1dTVUbG1PbjBQZnMr?=
 =?utf-8?B?dHdjaTVRTFlKS24vdjNDNmRoclJ5emJOekVuZUI1NjcvTk1QT2c1OHVRd2gw?=
 =?utf-8?B?UU9jbVE0M01KYVRBWU8rbnV0cFdLSklEczFqNW80NWllbU5TTFJyazU5d01Z?=
 =?utf-8?B?Z0lSUTh5VVNrN0dkMldKTDBkeDcrYll6L1RYUUppcFVBSGJPaWhwR0pFdGIw?=
 =?utf-8?B?VlM3bTZQZEJwdk9MRThMd2RkNy9QaWlhcEh5TjZFeVJLR2xvL1ZaOHhxM3ZR?=
 =?utf-8?B?SFhRdnkxdk5QWTlDNHc0N3c2SlErZXQ1Mm9scTBiek1uWkx2WTlBclhoQmdw?=
 =?utf-8?B?NFJJamRxTk9SVVZuVzc0R1hHZmhNSWM3TWtGLzZTWmlzSmljUlRDT0dhUFJ5?=
 =?utf-8?B?NWdjRDRKdktkZFNQOVR5a1Vtb2RwRGtONTJYaCtpRzN2blorTlVtNTlDaWRr?=
 =?utf-8?B?Y3F5TWZiSjk5R3ZRYUxvMVBYU1hWcGdvRjJLQk1IZ1BPdnQ2dUx5cWpDZThn?=
 =?utf-8?B?b0FqSzhzOHBPODVYOExBQ1VSY0ZWbWdsdGJJUGJDVFlRczJNTWwxZjVNUjVZ?=
 =?utf-8?B?RVl1Q0pxNmNROGtrTnNvQUp5bkFwcG9HWEJ3TEJvS0g4OUU4blRnZHk0NVVr?=
 =?utf-8?B?L00zd1JBcDd6amk5WDJKMEZaUVordCtteXgrN0ZzakNkRXRXN1djM0dkZmtE?=
 =?utf-8?B?Uys1eVJpci90anhpZW5seFhNL3U5SHkvYjZnOEVCU09jSjZYYnU3dnRlT0dS?=
 =?utf-8?B?TnNwUkVvODV2UXMrcXhPZVorQmhsWTBEcVhzeCtVdHl3ZUlkVVlZeFh3NWZS?=
 =?utf-8?B?SnhUaytJM3pEMmQ1eFg1aDZwZjJLaS9aaVN6WTlwdTZSWlhEblZCNTZJRjhZ?=
 =?utf-8?B?dlF3MDRqeWNOMUpmaUZpY1RxZ2gzYjR2d1dJUnZDYmVubEh3SmhtckluZlA5?=
 =?utf-8?B?QlJFa05oeGFoUnJRZXJuYk4rYWczUHZGK0JPV1BkMWZLRVE0RTFmMU9XUXlK?=
 =?utf-8?B?enhOa05GL3ZhRkplQTN4QT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f6193d3-7c4e-403f-e0b4-08d989d5173d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4465.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 20:57:36.2557
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qgwfl70zTw/AD4ndlyNVOFZZ4vTMzXXHAKkbp0XsWJa3tGjHjcW7jQZJHiKYB0YjCdrHJz5JhIFDBz8tF5cYKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3885
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: SZU2jcm8_tSgDzIg2uh0lUiyKOnn6Hb7
X-Proofpoint-GUID: SZU2jcm8_tSgDzIg2uh0lUiyKOnn6Hb7
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-07_04,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 bulkscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501
 phishscore=0 mlxscore=0 impostorscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2109230001 definitions=main-2110070133
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 7:41 AM, Toke Høiland-Jørgensen wrote:

> Joanne Koong <joannekoong@fb.com> writes:
>
>> Currently, bpf_sockops programs have been using bpf_load_hdr_opt() to
>> parse the tcp header option. It will be useful to allow other bpf prog
>> types to have a similar way of handling tcp hdr options.
>>
>> This series adds XDP support for bpf_load_hdr_opt(). At a high level,
>> these patches are:
> Why is this needed? Why not just parse the header directly in XDP?
Parsing a variable number of TCP options is challenging for the verifier.
Some programs are using #pragma unroll as a temporary workaround
(https://github.com/xdp-project/bpf-examples/blob/master/pping/pping_kern.c#L95)
I believe Christian Deacon also recently posted about this on the xdp 
mailing list
with a link to his bpf fail logs in 
https://github.com/gamemann/XDP-TCP-Header-Options
which showcases some of the difficulties involved

> Seems
> a bit arbitrary to add a helper for this particular type of packet
> payload parsing to this particular program type. I.e., what about other
> headers (IP options?)?
The current use case needs so far have been for parsing tcp headers, but
in the future, when there are needs for parsing other types, they
can be supported as well through bpf_load_hdr_opt.

> Are we going to have a whole bunch of
> special-purpose parsing helpers to pick out protocol data from packets?

I think bpf_load_hdr_opt is generic enough to support parsing
any kind of protocol data (as specified through flags) in the packets
> Also, why only enable this for XDP (and not, say the TC hook as well)?
The plan is to also support this in tc as well (this will be in a separate
patchset)
> -Toke
>
