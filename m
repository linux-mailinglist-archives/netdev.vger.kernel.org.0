Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8773FA6CE
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 18:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbhH1Qlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 12:41:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229726AbhH1Qla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 12:41:30 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17SGVWPY031707;
        Sat, 28 Aug 2021 09:40:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=1HhEGJYOS2Vzm2LjTk49+eQsHrwVthfKtI3DvNgNRVg=;
 b=qgJab3BReleL9cKthdb9MpJhzz0/V18eZH84Y+FHrYnuxhgxIR+vVEcWtzEXBS5kjSK/
 zmt32cMNTuvdaF0WIG31LHK+xlZEZAF0D4XPPynw56M3QkkkC2japD1XqouPR0fnqlWR
 tpH9CmkhgJTqlKEjzZaEjKDEetL+asC2Fo0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3aqmt2gy1j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 28 Aug 2021 09:40:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 09:40:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNJGRYimUtSwXiA22TgLXYchdT12ck4wF9Vo2+Ir3n5n2BtwsY3mmseeibYD0UxSXdeDtOBP37vobOzSWI1yb6A8C2Lhbd0JeG0EwYkrUb8gXhc3SfKY+WDtb3MXYsJ0cK0S/puwOSnaTdsLex9Mn3ItNgOhTarnxsMKLDoF3TSISxV+HZ7Hr1N+v0B+ClYsekuv2KLGOhdWol+4RWQeH1PAIxz/fkqFGSUSTG+NPYMZWgIJvwOf5KfdO2glvXg0SQjCleN01agq8icBRZsSDgKSKjlpcm0YDwDGaqm4Rpv1oQTveTRD47xBMjyVwLNTDwLgt9kon1nTf5PgvyR03A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1HhEGJYOS2Vzm2LjTk49+eQsHrwVthfKtI3DvNgNRVg=;
 b=IkZaJanvA9N2wR9nX1tU0Yndz2uT9/4kvGANIk7dZ8G14DljZuwsDtTTejD+3w39rQ+1L+1VLJeIDFTiAqR2QRZB9KMwwFD0bpQUMwtUf8v5oq0cke/KIJyavcLKQP36HP/5eBrQh7MdimR6yMcbkoPaV5ylnjFWf8es69jzUh4HwHEiCvCgr2tdaZolcAZ3dgUMjwQThykCKP0jj/m2L8j8RbDZNgf8+G7DfG+KeBEuHfOO5NMEmjHMabXA/YBIK8jaT64UJOcuN+TDI2SeFFpmoMQuwuPnXLmoa8HWhdlm7BWkokiuv3YllEDHrAZv++rpPHy96WnMSrQrIuF1GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from DM6PR15MB4039.namprd15.prod.outlook.com (2603:10b6:5:2b2::20)
 by DM6PR15MB2764.namprd15.prod.outlook.com (2603:10b6:5:1ae::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20; Sat, 28 Aug
 2021 16:40:21 +0000
Received: from DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6]) by DM6PR15MB4039.namprd15.prod.outlook.com
 ([fe80::94f2:70b2:4b15:cbd6%7]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 16:40:21 +0000
Message-ID: <3da3377c-7f79-9e07-7deb-4fca6abae8fd@fb.com>
Date:   Sat, 28 Aug 2021 12:40:17 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.0.3
Subject: Re: [PATCH v3 bpf-next 4/7] libbpf: use static const fmt string in
 __bpf_printk
Content-Language: en-US
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>
References: <20210828052006.1313788-1-davemarchevsky@fb.com>
 <20210828052006.1313788-5-davemarchevsky@fb.com>
From:   Dave Marchevsky <davemarchevsky@fb.com>
In-Reply-To: <20210828052006.1313788-5-davemarchevsky@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:208:236::9) To DM6PR15MB4039.namprd15.prod.outlook.com
 (2603:10b6:5:2b2::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPV6:2620:10d:c0a8:11e8::1060] (2620:10d:c091:480::1:1853) by MN2PR05CA0040.namprd05.prod.outlook.com (2603:10b6:208:236::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.10 via Frontend Transport; Sat, 28 Aug 2021 16:40:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36e55c30-2311-41d0-0ac6-08d96a4286b7
X-MS-TrafficTypeDiagnostic: DM6PR15MB2764:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR15MB2764726BA3D8C618A3BE5709A0C99@DM6PR15MB2764.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ijQtqTZDOkiAG4sfAqY5QMx8WGfZ0iAwht+9yAxZgSMCxozp+igMNX9rmwVFrjY8ckokDPCN9A9WtDotRdnJc68PA44/cUhE37d/5i37CEvi5EK4J0YC5owQRLYv2LsYFwJN+VsrDe9rHZOJ9fnzgiF2rTeaOZXFLgX6ZRfp86rIfkPpb5IbCVtKDwrX64tLUlQCQEUbYfrMpDqRsv5u8T8jH2VjCqEk35dqTTpQcRlMNvksihviIHQkaV0JgqGHAWayD246cjBkrYlhQB1WzpFAGbeEp40kyGHBdenyWGbQ4p3pvh2+z3d5akpE7quc40dIvFu6jJhG2OZpiHFhTIDvn6jjHKsw1J6YJB9sbg8ELIFE+PQiMQkrHsCepsUe5hSfeG31sgnqjQkQcTj0b4O0CoWEkyIpl8fuSYpKoYhPx50sj3kN0zupHwnioKhsPhMNvA143sXaKuJBo6XIbIFXA1F2a7uyBbuAKcVrWd6msO9GgXbZj2dt6F0/zfHEXgrvmsQFUnzrTBXVibRxFdTj8qtal8lxyJVCzjVZtD0YUNbmDH8JKoTTG07VzPSZkUeAcX2eKjfTj5sFxtRbIL0dOydmqWQtKHgi6KhXYejQPxJ/LQn5xE+o9ck5By8W+TggbwUYma+ujRDWVJXI2yKomJDw1UsRERwvGn3W+fs/E/jV++1mJuQnICU698p2bC9DmHPYqRUVR/PLJCssbwCN83kXAaLUobV33GFWckQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR15MB4039.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(66946007)(5660300002)(4326008)(2906002)(53546011)(66476007)(66556008)(186003)(52116002)(316002)(6486002)(54906003)(478600001)(6916009)(8936002)(8676002)(2616005)(36756003)(31686004)(86362001)(38100700002)(31696002)(6666004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzMraWtmcEVWWjBJbjBRbVlrRm9Ta3BEY0FGcngzUHdnVGY0Z1Z0eEIwT0dF?=
 =?utf-8?B?Q0JRWmNNSXpwbjArVDFRREw1aTRzazRGeFFzTnM4SllDb2dmNm1wN3N3aTBx?=
 =?utf-8?B?YkM0SEdCd2FmcHVYdVFrb0lZZjhPVDdLU2pxUTFZaHJtTkRQTnl0NG5JbHd1?=
 =?utf-8?B?YW9mcFlQOXhHVFp4NlhXbVEweEQ0Ym1oRVlCb29CSHNFbWlqVFRIalhxc0Zy?=
 =?utf-8?B?N0RTU3puMkxWckdiNUNwKzBCR1RNUHN2ZGlSWEJHVUc0QmJ1RjdWbUpjNyt1?=
 =?utf-8?B?djIrQlRrdjBrRElxMUJyZFV6MXYrTmk5MFF1aFI0Vjl6TUVUaUNJdWhodFNN?=
 =?utf-8?B?QmMzc2hDRjFrTHpnZXo1VDZpVmUxQStGdzRmVi9QWjB6WG9Ec2hUTzZtMEZJ?=
 =?utf-8?B?bThVSjRTM0pQQmVjdWFRK3JYb2dlSEM3THVrcXJtQTNRRWZteGo1dm9NV1JV?=
 =?utf-8?B?VEE3MlFydkVwMDNkbDFBdjlDTzFUOVYyMVc3NUR0V3M0cE5EQmlCbThPSW5U?=
 =?utf-8?B?YVFVeVc1cVFQYWZKM3BzTTd6WnZaaFZuRjJvWmZBckZHSTZaQ1Y0cmNTNy9p?=
 =?utf-8?B?VmVRU0s3b2lVVE1aaTgxRk1DNTVFRXBNRGtUY21uL1Z3bFhkUUFPaCtMa2Na?=
 =?utf-8?B?QmE1by9PS1pCa3FZcnIrblFOWUVmSUxubkZkMVhJTjhMamZSelJOTjVkNHlo?=
 =?utf-8?B?SHJnMlNJWkZ2RHZuS050M09uN1RydlBIdlFvQ0Z3Tkl0QUZUT3R5VTNVUDFL?=
 =?utf-8?B?VVVzTTFWK1orNEJYeHBZbmdhZHZ6eGRibDRTRjlzM3pDNTNTZ2I0TUhkbGh3?=
 =?utf-8?B?dEtzY2s4SitUWVNXYzgzVnYwdWhHdVhFeU5iU0FCU3ZtVGcxVXBiR0l0TUMx?=
 =?utf-8?B?cWh2eXlPSFZaSWtkMmJOczFPNGhNZUQydFZPdDY1Z3NYam4vUk9kQms3b09N?=
 =?utf-8?B?MFZQaUlQb0tSZE9DWmcveno0VnVNeXIxclo5NWJ2blJSQmhLNXpCclVrWm9N?=
 =?utf-8?B?MGxsOGdOWCtWaFI5S3Rvd0RFYW1qTnE5S3RiU2IzdXUrOHcycXNER1lUejd4?=
 =?utf-8?B?RzdncDZGOTZNd00wNko0L2orVndiU0tRZlBEOHZ4TFRnVU1JcitnOVdlNFpX?=
 =?utf-8?B?cUpsU0NaWkdEN1o0bDRjYUU0UzhlTkNnUHd0OHgrQytKZ2FKSU81bnR6Ylo1?=
 =?utf-8?B?cVRHSlBoTHZsMHBVaGppdGNjWHhQb1NqL1VBV0xvNjd1K1plZWZPb0RMR3Fu?=
 =?utf-8?B?NDVZZm9tYW1DUzY4eVV2M2U1VzZaN2lUT0VCVVBYVFIvaXlhM1VzaTl0Z093?=
 =?utf-8?B?TTRaQkJHVEViZ2NsZUlNQklHQlk0UEJzNkJ5eFEwcEJBT3Vnd1psVytObWV4?=
 =?utf-8?B?UEs5Ky9LUnJ1WXpRZ2xRd0gzc2cyQmZHdlBqS3N4Y3VNSk1HbjRzR3UwN2Qw?=
 =?utf-8?B?M2dudUYzenpqVjYzU0xqeEw4Ti9NMHN5U25HM3Z1Si8rZVQ2Skw3L0xuRnR3?=
 =?utf-8?B?SFkraXY0Y2ZVM3QzV2xzeHZwZjh2cktRQ3ZuYjUvMWRSUlkvZUYwenlOckcr?=
 =?utf-8?B?ODNYVmU5T0VwVVdzUGxISkVaSkVvTGFTaUs4R3g3eitjallZNWh2b01BTjJk?=
 =?utf-8?B?YXF2MTlnSnpBR3g5bHF2WUFpaTR4OXY2Qk51ZXdkMC9HTXRBRkthaGRtbVg3?=
 =?utf-8?B?aFYzYjJZdUZjb25GSUtaeTVockNiRXhXalV0OWpZblMrb0RIVGdZMDhZUUxR?=
 =?utf-8?B?NjBCRWV6NVR0bUVVdExtRGY5TWQ1eVdOUWRVc01hQ0hZMTk1ek8rQ1NiZU1a?=
 =?utf-8?Q?L0QjTLLnytbwIkGXFcNoeMBLZr638bLKmHsRM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 36e55c30-2311-41d0-0ac6-08d96a4286b7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR15MB4039.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 16:40:21.1896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/QQfZuXa+d3Rfjmkh5EOH4klK8HrlDTKFD/4MlA5rKV5wEZZWbmwI0ho8fFTmIkqTIfcoubQNXjrRIBYrAfKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2764
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 0TjGZ2Y8KSy6qMdLpFE1wTMeJKC5v-Fk
X-Proofpoint-GUID: 0TjGZ2Y8KSy6qMdLpFE1wTMeJKC5v-Fk
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-28_05:2021-08-27,2021-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 mlxscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108280108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/28/21 1:20 AM, Dave Marchevsky wrote:   
> The __bpf_printk convenience macro was using a 'char' fmt string holder
> as it predates support for globals in libbpf. Move to more efficient
> 'static const char', but provide a fallback to the old way via
> BPF_NO_GLOBAL_DATA so users on old kernels can still use the macro.
> 
> Signed-off-by: Dave Marchevsky <davemarchevsky@fb.com>
> ---
>  tools/lib/bpf/bpf_helpers.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 5f087306cdfe..a1d5ec6f285c 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -216,10 +216,16 @@ enum libbpf_tristate {
>  		     ___param, sizeof(___param));		\
>  })
>  
> +#ifdef BPF_NO_GLOBAL_DATA
> +#define BPF_PRINTK_FMT_TYPE char
> +#else
> +#define BPF_PRINTK_FMT_TYPE static const char

The reference_tracking prog test is failing as a result of this.
Specifically, it fails to load bpf_sk_lookup_test0 prog, which 
has a bpf_printk:

  47: (b4) w3 = 0
  48: (18) r1 = 0x0
  50: (b4) w2 = 7
  51: (85) call bpf_trace_printk#6
  R1 type=inv expected=fp, pkt, pkt_meta, map_key, map_value, mem, rdonly_buf, rdwr_buf

Setting BPF_NO_GLOBAL_DATA in the test results in a pass

> +#endif
> +
>  /* Helper macro to print out debug messages */
>  #define __bpf_printk(fmt, ...)				\
>  ({							\
> -	char ____fmt[] = fmt;				\
> +	BPF_PRINTK_FMT_TYPE ____fmt[] = fmt;		\
>  	bpf_trace_printk(____fmt, sizeof(____fmt),	\
>  			 ##__VA_ARGS__);		\
>  })
> 

