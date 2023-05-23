Return-Path: <netdev+bounces-4524-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFF070D2D5
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 06:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CA342811CF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 04:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF2D64C85;
	Tue, 23 May 2023 04:39:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945804C60;
	Tue, 23 May 2023 04:39:14 +0000 (UTC)
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9E0FA;
	Mon, 22 May 2023 21:39:13 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N27hPV001585;
	Mon, 22 May 2023 21:38:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=iorXIOr6cB3XBKAzzdPYS8VbsIkupCxf/7Fd1DpsBbY=;
 b=FWSc544I+druROwWrwolErMRcysDH2etEBOMd7PE4EGQoyQHFKPS6+jgqnLotcOwYzR1
 4OD7ENgOUmj1WIPF31wAHrgG7UhFVACDPq7hytQm4V2dlC4L9zzpKT0i2YwYixIr5/wQ
 JBXIBzNRISuIMNR3l1DxYelu6A4eRKlSFwRaJ67vsWTWtgrpeGKcb3pgVyCePkN9AUK+
 XpS8CCIfRP5NiZxPMSJ+Uu1eh+KRTKZPvyUemGFEAs69YheZy+5704lDhBRba/0lTqbZ
 33iJna/V81WLCD3CkWAvDUwomKzuHHhGsqj72NLG2u+4K5nGsh8R2nl7ztxE34vwjDXY Eg== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qrme50qm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 May 2023 21:38:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUZ6mkiPQv3bhYv2pfPvvX4IC8FjQBQ9Kr5GNNltdYFBwqW2tzLhaqZyp1kkMDgbT67PJGAa2LfJRaZqsHAFvxPztDLTVGuPGqjOgQQkgiDBJ899IRwA5SoUEaJFWJXc92He3GIP3/V1gRRp/2+cw+9YQPxgG4KF5Xe7NgXFHOzgtaZ7+LJWcxnYcAqahk9kMUIViiFqFn1O2oaebdk+v3Y0by+2soVzW/XUOaOrVDFAyX/gns/YaDt1yf05baUdrETwR/bUSUpzLDINBqX2aSR82A2iVINIQTY/ZFUttwyWfbFIkvd7oucq0AusPmBeW0vAgVnwgRRZy3vlm2iYCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iorXIOr6cB3XBKAzzdPYS8VbsIkupCxf/7Fd1DpsBbY=;
 b=Mc2/yedYJCzIJckL/Qif8FT9uitHgihazi3boaUihhiVu+pHF+qlPJ0GZP1c0uTRnm7jDm7tjptkymhRRXF6n3DDrhL2Sm4CTUe0QilNpeNbMCvoDD70pj8UYlYkhGUNn9B8vPPz/GKYwXVv8yOXBsFf/Y38Z49glkXlcTkvSt+wf38EUX5KNl3ApZYSECs1tJWZ/TWIPKu2U9rsC2g4jv32s07tZ1SyZ+pxoCvU3PdKq106sFWDv57/9s9TBWFFIfswLKMpGkmZgfcqs6NSc+X7cjqO1YTC9pc/GJzb+vppmLRQDGjJd/df9YyLfkSV3T8vSmn1Dlgwu5aQfSZTbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB4231.namprd15.prod.outlook.com (2603:10b6:510:23::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 04:38:22 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::589f:9230:518:7f53%7]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 04:38:22 +0000
Message-ID: <a5a9fb0e-d80d-d81c-b8c8-6ac9fcdb271b@meta.com>
Date: Mon, 22 May 2023 21:38:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Subject: Re:
Content-Language: en-US
To: Ze Gao <zegao2021@gmail.com>, Jiri Olsa <olsajiri@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, Hao Luo <haoluo@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>,
        Masami Hiramatsu <mhiramat@kernel.org>, Song Liu <song@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, kafai@fb.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, paulmck@kernel.org, songliubraving@fb.com,
        Ze Gao <zegao@tencent.com>
References: <20220515203653.4039075-1-jolsa@kernel.org>
 <20230520094722.5393-1-zegao@tencent.com>
 <b4f66729-90ab-080a-51ec-bf435ad6199d@meta.com>
 <CAD8CoPAXse1GKAb15O5tZJwBqMt1N_btH+qRe7c_a-ryUMjx7A@mail.gmail.com>
 <ZGp+fW855gmWuh9W@krava>
 <CAD8CoPDASe7hpkFbK+UzJats7j4sbgsCh_P4zaQYVuKD7jWu2w@mail.gmail.com>
From: Yonghong Song <yhs@meta.com>
In-Reply-To: <CAD8CoPDASe7hpkFbK+UzJats7j4sbgsCh_P4zaQYVuKD7jWu2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0269.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|PH0PR15MB4231:EE_
X-MS-Office365-Filtering-Correlation-Id: 09f43b18-1970-411c-f023-08db5b478a21
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xkOR5G134QVYgZRMEhexHUSHXLk35aUgBf7BRlDHHxZAJGyVi26AIzBFw6+zG1fLJqNY4xj4a3kbWyDOlyR4a6HaPp2MYJIxWGRCXdd9p986QQVjAC6SmlfQm0LlEAfmMtUXPhYhd4fpTFprNZh3mkDjEFZse3EvKOiTBB/BBuMRUwPbVyigX++sAUFsvrOQ1tedl0H7DecMkua0EW+WauL6Ffki21j5y9njRmyaI2wT0D6td/MpsJP15LpReHgpXhU5gIj9ZcNV0QV6SHf/QYU5HMj9w6yUJyXZtX0u2sot0FQTu7QhIsd+UpOuTcjl1R2ctFzO37nT/s371N1BAS7S8ZPivQFbUsTmtfiymJKFDce459EqbmwUOTOa1TTriO+kt+ayaw1XkkYIAbpfmGCOOq1qr0fsNQK8VF4Jeavx34JqdiSBSasngC0M21nzoQEynfc2kUuTMDn8nYjwC+FTI8rN8jF9h8crEWyIWfUYn7OloTFKiYkxDMMf773n/K9wGxC3Ud+grLc1GkSHzEfmywxbecNpi7Km4dlfK5NDqeFQzNKBf2J8aW8KQ4RIyBHqYcL7N5+A1+lp9GBQZH1oiFfQfH2ATIQIeHqmrBjYJ6AIN9obeDUZA+gKqEjvYw3GGZHVIYtQkmoQhDquiw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199021)(54906003)(110136005)(31686004)(7116003)(2906002)(4744005)(7416002)(5660300002)(36756003)(8676002)(3480700007)(8936002)(41300700001)(4326008)(66946007)(66556008)(66476007)(478600001)(316002)(6486002)(6666004)(6506007)(31696002)(86362001)(53546011)(186003)(38100700002)(6512007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cW5vZ2dBWk5heVFQZkE5MlRwb0h0SnJ1ckRyZUlFS3pHekdHOWFDc2dZK1pq?=
 =?utf-8?B?KzFQN2ZXeGs5QmxGdnZ2cWI1SGJ4ZEIwRjY3Y0tMQW8yTFJuMi9yTUpkZnFG?=
 =?utf-8?B?RVVyL0N4Rlo1V0RTUm1yNkowa1Vlbng5NFliUlJHSE5kbnZybU5ZOFdqVEIy?=
 =?utf-8?B?RnVHSnZOMGhZVzU5anlBQW1TVlgrQThlQUVIaEIvKzlUcDV5SUJ1S1VuSDN2?=
 =?utf-8?B?bldMaDRkTmxhVWtIYjFid1NsdkFIRGN3VHd2OVNiVzNGYkhMQ3JiQ2dBVW1I?=
 =?utf-8?B?bUVONklDY21wQlcrczVXeHErUlFNd3lLTkc0TURoQ0c5bitPTjZYMlJhZnRE?=
 =?utf-8?B?UzF1YU9KdVBxamowOC9NYUNEaU5QS2c5MjllMHJEZTh4bE8rZndHemkvYzFJ?=
 =?utf-8?B?YmFYbUhJQjFtak9UWmZzdnFtdm1IK2JuZXc0Q1dMQlorTGpXQkNwcFZxc0Fy?=
 =?utf-8?B?b3lweDU0OWhiQ3o5Ris2T3l0U01pcDB6OHJkbTYwT1JORFQvYi82S0tlQjlW?=
 =?utf-8?B?Wm5kYWozZEZ2QWlYQW9ZakUxRnJiQkNyc0dxT0JucmpBUk9EK3BWcmNkMmNJ?=
 =?utf-8?B?UDZLSzVHR2dyU0RRS2g4RndzaTNpdFZFYXJadVNaWndXVGxZa0ZKSVVGbEJZ?=
 =?utf-8?B?NkFuUm9VVm1HSHVoT2tFODZJYytEcTNXa2xra042d2xGQjBkMkRpemlRVU9u?=
 =?utf-8?B?czc4UDdsN1NhTWJSOGRhTkZZK1I3eHptWVMyS3FMSFFQSmt1UnNSWDY3NFRj?=
 =?utf-8?B?c0tPc1FXYytmejNTUHhTcUlScEJnZEFyclB6dGNnOW1CZFFjQ1dTdG5kbFZB?=
 =?utf-8?B?WG5vS3RuUFFiTjc5SWpEWW9mTUo5dDg3ZzVZR0loWG9yRFRhanF1OHoyZDhC?=
 =?utf-8?B?VU9EOFNGaUFaODlYVDhmNWd3SXFIdUtpcWdVaU5vY3VmRU1STzNOR0dmL2p5?=
 =?utf-8?B?R0Ftc0hDaWFUL2NFMDQ1MGtReGFwaWx0eWljR3ErL1pheGpHY1I2cGpmWE84?=
 =?utf-8?B?R3pTZ2d6Z3JJZWp4NXF5akN1bVYxL2RXdVdEQllBL3cxdDY5YjhNaUoveVJa?=
 =?utf-8?B?eE8xdHBLbHBsS2JlYmZGNjdyL3p0T0JuazFiQnpsKzc4NlRsMWJXVE1CNjYr?=
 =?utf-8?B?TWk1T0FlL2NZaFNIWlRZc0RrWUJ4SHltNlhlMTBac3VPa2xrbGtIOUh2QW41?=
 =?utf-8?B?SlJiVnB6VG9jOGxkK2szWEMzYTk4bUYzWWlpQWtMRlJWa0JySWNNT1Y2T0sw?=
 =?utf-8?B?Z2FmZmdvSXI4cXJqL0lybnMxQ1RTcnQ0bjJpdzBranNEUmV3TkFZUzZjN3Zp?=
 =?utf-8?B?ZlRWWVJ4L0htcklzN1czVE9xZ3V4SHI0LzRRZm5sQTQzbTdKTWdRRWh3eHBX?=
 =?utf-8?B?eTg4SlpWYnlMMXBXUWdIZFZVZUQvRFF6TG1VR1lOTzF0Zmg2SEIwdVBEMlZF?=
 =?utf-8?B?Qm42b3MvWGRFZi9WVnZ0cFBqKy9ZQnJjZmhJZkV4Y3NyMGU4eENqMjlVNVEv?=
 =?utf-8?B?b0hwOWdWdlRpRDg1dndDZWd2dFhlbmE2OUlFcXlOQy9zS0pWS2d0bFo5bU1U?=
 =?utf-8?B?TllYSjBZZkFOWkxyS3R5VUhSMlZaOVFTOTJ2aFY3MVIvanB4UHZnRnVEUGlC?=
 =?utf-8?B?d3pqMHVtZVRFVkdKSGlkc1dZWERvT0VTMVdqbnpKMUpUdWNhSnZPdzdka3By?=
 =?utf-8?B?ODRrN2t1czI4K0FEcURRNGcrQmd3N2lCWGUvUy91UU5MTFpzYVZQSUhyQVBm?=
 =?utf-8?B?TnBYL21XYmowc1Zzd0tkLy9CUVo2Mm00ZzFtbmVCSndVM3pNNFU5ejhZT1ll?=
 =?utf-8?B?QTRvRjJsTktwVXJ6YlVnK09HRmFvVkpxZkhET1BrcVg4Wi9XR05yVGUxSXo3?=
 =?utf-8?B?UXdTRTl4OXhqckl5VkdINUN4Zko2TFd6RzNYZGFQbmJMMWVqSDNXU01SQmE0?=
 =?utf-8?B?ZVJuV0NTVy9yUWNvTHpDeVplUHBLYk1lNVNNSHRNa1d6ajhsM093UE9QRU5S?=
 =?utf-8?B?NWRpYlRsSmgrcHhYbEFOQ3pqVXYwVEkrRS9UMEpra2NSUmRVY0doYXdJZWxS?=
 =?utf-8?B?MmYrS3JScHFCL1k5cXRUdksyZ1VqS2ZCV1p2eUQvK0hGUngwUEh4UWg0NWJC?=
 =?utf-8?B?eXFKcFhJVWlrVU00c0xOUG5hejFNczEzNFA2alF5T0VyMFhBdW5iVkhBZlFi?=
 =?utf-8?B?L0E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f43b18-1970-411c-f023-08db5b478a21
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 04:38:22.3319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kv1es+faad4hCxWZGV+a/FFx0VwivRVZslOVLEVCD9zjW5EK19bHZ9SM8su420rE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4231
X-Proofpoint-GUID: fFS0TaRGyTON7-l_Lo3O2BfMkVB9-i8i
X-Proofpoint-ORIG-GUID: fFS0TaRGyTON7-l_Lo3O2BfMkVB9-i8i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_02,2023-05-22_03,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/21/23 7:07 PM, Ze Gao wrote:
> Oops, I missed that. Thanks for pointing that out, which I thought is
> conditional use of rcu_is_watching before.
> 
> One last point, I think we should double check on this
>       "fentry does not filter with !rcu_is_watching"
> as quoted from Yonghong and argue whether it needs
> the same check for fentry as well.

I would suggest that we address rcu_is_watching issue for fentry
only if we do have a reproducible case to show something goes wrong...

> 
> Regards,
> Ze

