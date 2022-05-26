Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02AF55351F4
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 18:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241712AbiEZQX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 12:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiEZQX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 12:23:56 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D956D3B4;
        Thu, 26 May 2022 09:23:55 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24QDTTLm028658;
        Thu, 26 May 2022 09:23:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=SqeBFqievm4LUB3A2G5izAA9pPWP7l3jkVZbpKH1EL8=;
 b=QI/bcpVCf4XPHrzvoGrgHLfFR7I3l/6LFWergGlf6SZ4k5hTKGQiJd/yFGk6BDG4y3Sq
 DABlgWIYO36w2hcYfEGl5yZsPK836ICx9DZ+WMBWgYRDVYGG6LZooGlO/3bDlrDbcdYj
 4xkmI8URLmQOIVOuFnF/aMizaN8cM/FqDJs= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gaafu1834-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 May 2022 09:23:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGSyAb80Sg5cLTq0nDMNVdla48gRAeqZ1prOLEBsNVG691zwSBb99sNbLhWVZDnI+0eJnrs4EL/INi6iSil5OOJ5MPvUNJf4pPe2ERiv4JY5Qct27LPc7vTWjszYVK0awXqb4RarNyXxq/+xHRsUzkS9eG3gvCMSpKgjkQ1ROqje6g+PGniRKRXOBfSc4x1AKfPJmuukdrqFanHv4LpKcrEax8eg2QKlgKsm2hYCjXkTADFYrDou8d9ypX8nNN8jSvxjqpeGvjLg7Q7jXc5h3lFOciDm94zshwTJBTAp6rxtFCMgb4X4PjDOLCoueQLpyygBxanhM2iCMikyaECFXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SqeBFqievm4LUB3A2G5izAA9pPWP7l3jkVZbpKH1EL8=;
 b=Q/Cna+72yB/3nVmPdGB3PFZI8ZpQXMR2fUXqArZcr1xzJDu1xDdJ587PUO3v2TRLk0LryLmbnChmghZAm6Y6Zn8cHAeBx/0aD4Z0wlHTBsDaxRlpHVV5dNBcOCQtwz9GXbA7SMb7IJNy2XnS6UzUIWSHPnPg2+ayOcthxx7W62rTuzvVxMxotsZGOC3DLsx8MCMQtAreYIxsVnUzyGMPFVmebDHYYrUg1S1rNACTh7R5dH/d8Tu5+FCceDOOwjYk8QPkdq/OC79QeHEjH740P0LCIWcdKlBcCzTuJuzrsphKI4YlWhq3NmJbaxL9Y0/6dmywn6lerlW6W2DnLMRcng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN6PR15MB1699.namprd15.prod.outlook.com (2603:10b6:405:5a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Thu, 26 May
 2022 16:23:37 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::fde9:4:70a9:48c2]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::fde9:4:70a9:48c2%7]) with mapi id 15.20.5293.013; Thu, 26 May 2022
 16:23:37 +0000
Message-ID: <8d1f2a05-368e-9f50-8e6f-a8a717517766@fb.com>
Date:   Thu, 26 May 2022 09:23:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [RFC bpf-next] bpf: Use prog->active instead of bpf_prog_active
 for kprobe_multi
Content-Language: en-US
To:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
References: <20220525114003.61890-1-jolsa@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220525114003.61890-1-jolsa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR08CA0004.namprd08.prod.outlook.com
 (2603:10b6:a03:100::17) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6441a658-3fa3-479e-0d41-08da3f34166b
X-MS-TrafficTypeDiagnostic: BN6PR15MB1699:EE_
X-Microsoft-Antispam-PRVS: <BN6PR15MB1699C1911546E3E0D0B9E86ED3D99@BN6PR15MB1699.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: geL86N0F2daVsR655RSiQbmHNlr/+3ol2PSYi4uo0gr4SkH3aCC0qq9wogBXZAN3+uI32SYgMPAYItHrp9KYHB6NtwgRCgvy3xX5ecSQ+5XCt3EMjhTBwQAW9CHhbprztkA19c80ofdhVb0+OzNMHTI0Kh6LHOe29ZY9C7EuotdJxVo91aGf5YNUsWR4TKP7K7sL2O8BSfFttPl5hPTJkmxBZTkT8pod6S19pjy/8RgLwEwNAsGe9EJ6yp8HCAuuuQMsgVS0d7uwjgDbq0QspE4kZTqBmFJYodCVO87WCtKUgFRowd0kpSGlE+6x1NGCUUd6Lz2AMZXX17C8ejbQYd3e7Iu8c2ZOETbx57EzAKullXbWcX9SPYV9jggHpD292RzYD/x5jKFqpTlLvvB8byyNYBFpyak4cgb5NbfpXfcSgiXY75T03Rs9VgzrwdOgOpnNUUkHil3hSBAlLGDnIhQbxS45UYhGBOcozwJBuNLjbrTixmP0/tFyjpioebYebwhBIeiA3jQzddoYrotsI9DX3xtJvszC6JmNHWS5mNKDS+VCVD3AJl8fCI2oNOHCniMYWYwtVk7c3jJsEtsrJPxOM0sM0rgz9DlcLd4VjzZohfWo832gNQNRBw6eeGJSVVb1wGfZuafBK5NT/o13hsQJsmksyZXMME4NUjEMagKMZBdoqNEDQONSkVy2m9PRDnwRC1XLFlFC46KibXC8bAUinmc2gDGyZllhz+6e69TW5PjKE5DtWNNVGBKri9D1a96Dd26X6szUepqp6yj4OGVFepTJ8uhpFKFTK+04C1g88APCqDkcgvlVHhFVZfYIhw2VjqKZxiPa8ZQmMHbM0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(52116002)(316002)(54906003)(6506007)(966005)(6512007)(2616005)(86362001)(38100700002)(31696002)(110136005)(66476007)(66556008)(8676002)(4326008)(66946007)(6486002)(8936002)(508600001)(5660300002)(31686004)(83380400001)(186003)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHpkN3czcHJwdzJCbUJ4L2tNYmd5RTEzeUlMWWNDTFI2cDBwVmtyWWVKK2dB?=
 =?utf-8?B?SmtPQlg4bDhUZ0xZT3lXaTNkYVB6TVN4Ym11UmJwZXJLdlZYRjA2MjJuWkNM?=
 =?utf-8?B?bTRMRzlWUXdvc1NPM0hON05ocHcvaVZIczNNU3Nhc3JLd0J6ZmQ5Z0NuT0FR?=
 =?utf-8?B?L1Rhd3VBZXVNV0lEbXBXdzZLMC9wQWVWcDhBVkNYL1kxa01FQ1RYR0lnalF4?=
 =?utf-8?B?c3VWa0xlUXlTc0VVL2tMS0N6MnQxQ3Fna2t5dTM3Sm11bk9yTjloTVViSUhM?=
 =?utf-8?B?Yjk3M0ovRDFNWU5nU3FjdGlJdmFDelYxd1dIYVd6MWtaU0JaODNFQVBNSGxG?=
 =?utf-8?B?ekx6RGd2OStPSnk1ODRrbm1Ya0xVMU03RU16OG9KYUtFSWZsWC8wQXltUkdo?=
 =?utf-8?B?OHU0cjVFdE5HMit5RjBoVGdoNEkvMDRQckhKRWZiTEthRUt6VW81QXR4U01C?=
 =?utf-8?B?VllPY1FOVHpYMEdTVUtFQUVyYkEwdTRDbTdoMkJmcDEzTGlJOEp3ZURqMzBq?=
 =?utf-8?B?SGoraVpjYy9xa2JJYXB2OUNuS0xzcjRkL3BWcHZEeGxYdUpUYldGdzdrSWxr?=
 =?utf-8?B?c0lsTHVaQk8vVGNha0hKOHRmQ1JwN3lvSG1TekY0ckZ2c21uSGtwQVlPak9V?=
 =?utf-8?B?MHFGVVV1bHgzaXNvWVJ3QmprVXlsb2x4b2h4bllWbDNjRHpseUt4RHNDY2sz?=
 =?utf-8?B?WE8xRUhxZHJDRkxXaDErRVhCZnpjVTh2S2pzT2hHRUJMeDNBY3hGVUJEeSto?=
 =?utf-8?B?eUNpQ2xnSEdReVRlWXg1NEdDZWI3ZUYyOXVKVXY4MFl2VFIyRUwwcWUzVWFR?=
 =?utf-8?B?ak52b3RTUE51dW0vVndEUmlTTkZoMldKNk8wdnNmalZJdVEzUHVUQVpTSkhC?=
 =?utf-8?B?bWpZOUh0cTAyYUExRVRtVTk2VGFKZXVXcFhWM3IrZVZVQkZoSnNuOU1uL1U4?=
 =?utf-8?B?SDIrZDY0cEUrZEF0OGVBSnJIc1lOaE9xeERqeFhTY3hPWHlCbFFybHhKelZ4?=
 =?utf-8?B?ZXJuUHZndldjRHY4U3ZoMEhITkFSaDhxSi9ZOG9TdjRKV1Y4b09sT1hBYW11?=
 =?utf-8?B?R2ptU2w4SFFnTVg5RThDSElHMFVZNUQ1L0Irb1pQamRJVHY3dk42a1lPL3pm?=
 =?utf-8?B?U1NySGJta0RlWXd6Q1NpVUJ6TzI0KzdMVTU0cXZWK1VVR2ZPaFRTdGMrbjlL?=
 =?utf-8?B?dkF3eTlzZmxuc2Fxa1EyOTZvLzg2aVZaZTlxekpIQ2U1MmFSajcrSUpTOUxQ?=
 =?utf-8?B?V2RPOEtrRXEvRW92TzBvOTZHMkJHd1BZRmE1dzJyMS9NSzA0cFI5aFRzWEYw?=
 =?utf-8?B?WFZ6dVliOEVZQUY1Q3VMZXdQNStsVU9iL3NYSEx2ZjNYTGEzS0pGRTRXNloz?=
 =?utf-8?B?WGZrQUF6d2FaUndhTGRJaXhwRTk2WWY2VmhpaE95dDhiK2lhSTRxNTVUa01v?=
 =?utf-8?B?VC9iSCtSRG43YzdaMHh0ZlUyeUZYbjlYR2FKb3dPeHZXdjQxenNFMElWcDdJ?=
 =?utf-8?B?cDN0bE9xQ1RsNExWZWhqclo4eGxtbDA3aG1XbDB6NldGcVFqM0gyTUdKV1pC?=
 =?utf-8?B?eUJ4OXR1ZUpNV1hlcWpnaWF3bjJ1TGdKM3l2cmJGSzdIMFN6eENmaWk2Sm0w?=
 =?utf-8?B?RjhwcnROYTA0MUZOdDQxU1pBNWljNHR4ZGRUZ2VkUTRQd1E3NC9JTnY1cnBn?=
 =?utf-8?B?eTZxeVQ1TDJtZHFOTjFDL0w0NWFUT1NmamVIZnVaejkxc0NjVlRtbEFNQ1By?=
 =?utf-8?B?bjZ5RmxsWEgrZ3BhZTVkbVB3MFJWYXRrcWRzdGptRmJKd0RzdnpRYXozWm54?=
 =?utf-8?B?UkJNTWxRdENpbkYwMjlNd3dvdlRKSE5QcC85eG1EaEdlVUJnb0RERk5xdHla?=
 =?utf-8?B?RGk1LzRpK3kzdGZkRHl1MVlqMlQxeVU1d012TG84SDBnQUNoRHZjenc5N3p4?=
 =?utf-8?B?NFpYbThjM0R1enkzcUFoUlJZQmhGUy9wOEQ2Ymg4N0NvM2NCcnJVYytsRHVP?=
 =?utf-8?B?enpIYzBBZzBOU21nb1o2RnB3S2lEUThJa0NOc2FrZUVuQkNHOUo3L3ZFYW9G?=
 =?utf-8?B?OHNJRThpSDduaFZISWdxQVpuaW0wZU45OUxhNEtHdVVxYnhNT0FXYThndkdY?=
 =?utf-8?B?N08zdTFHN1hEazliYmNnOHVjRTZTeS9jdWkybnI5MXFjUUJObW01OEN4TU9s?=
 =?utf-8?B?TmxKcExYcGdMeDVPUVZFTlJ5QlNlUHRMNXlFeFErM3duZ1N2ekhTVFJNaDNl?=
 =?utf-8?B?REVsaGxrL0pxSlVyb2pEL1BIL3gyVDBEeThwVTdCbkJiWk5ZTms5K2dORHBR?=
 =?utf-8?B?YXBiWmwxUm80UW1GZjRES3lXZmZtYWhJWjJlZmpIZmNtbzB5aWk4TXpmZlRU?=
 =?utf-8?Q?ew2YmavbKXupZOcg=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6441a658-3fa3-479e-0d41-08da3f34166b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 16:23:37.5028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BUDjSZ1ljrrk7Xv3xoYUH6lb+IkOsRwhi1WgTfG6GIS+NPM7wOr8/7AzdW3HJ47D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1699
X-Proofpoint-GUID: bo2tjIfDTQmTTeVI8fjUPRzpwjVJXICO
X-Proofpoint-ORIG-GUID: bo2tjIfDTQmTTeVI8fjUPRzpwjVJXICO
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_08,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/25/22 4:40 AM, Jiri Olsa wrote:
> hi,
> Alexei suggested to use prog->active instead global bpf_prog_active
> for programs attached with kprobe multi [1].

prog->active and bpf_prog_active tries to prevent program
recursion and bpf_prog_active provides stronger protection
as it prevent different programs from recursion while prog->active
presents only for the same program.

Currently trampoline based programs use prog->active mechanism
and kprobe, tracepoint and perf.

> 
> AFAICS this will bypass bpf_disable_instrumentation, which seems to be
> ok for some places like hash map update, but I'm not sure about other
> places, hence this is RFC post.
> 
> I'm not sure how are kprobes different to trampolines in this regard,
> because trampolines use prog->active and it's not a problem.

The following is just my understanding.
In most cases, prog->active should be okay. The only tricky
case might be due to shared maps such that one prog did update/delete
map element and inside the lock in update/delete another
trampoline program is triggered and trying to update/delete the same
map (bucket). But this is a known issue and not a unique issue for
kprobe_multi.

> 
> thoughts?
> 
> thanks,
> jirka
> 
> 
> [1] https://lore.kernel.org/bpf/20220316185333.ytyh5irdftjcklk6@ast-mbp.dhcp.thefacebook.com/
> ---
>   kernel/trace/bpf_trace.c | 31 +++++++++++++++++++------------
>   1 file changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 10b157a6d73e..7aec39ae0a1c 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -2385,8 +2385,8 @@ static u64 bpf_kprobe_multi_entry_ip(struct bpf_run_ctx *ctx)
>   }
>   
>   static int
> -kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
> -			   unsigned long entry_ip, struct pt_regs *regs)
> +__kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
> +			     unsigned long entry_ip, struct pt_regs *regs)
>   {
>   	struct bpf_kprobe_multi_run_ctx run_ctx = {
>   		.link = link,
> @@ -2395,21 +2395,28 @@ kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
>   	struct bpf_run_ctx *old_run_ctx;
>   	int err;
>   
> -	if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
> -		err = 0;
> -		goto out;
> -	}
> -
> -	migrate_disable();
> -	rcu_read_lock();
>   	old_run_ctx = bpf_set_run_ctx(&run_ctx.run_ctx);
>   	err = bpf_prog_run(link->link.prog, regs);
>   	bpf_reset_run_ctx(old_run_ctx);
> +	return err;
> +}
> +
> +static int
> +kprobe_multi_link_prog_run(struct bpf_kprobe_multi_link *link,
> +			   unsigned long entry_ip, struct pt_regs *regs)
> +{
> +	struct bpf_prog *prog = link->link.prog;
> +	int err = 0;
> +
> +	migrate_disable();
> +	rcu_read_lock();
> +
> +	if (likely(__this_cpu_inc_return(*(prog->active)) == 1))
> +		err = __kprobe_multi_link_prog_run(link, entry_ip, regs);
> +
> +	__this_cpu_dec(*(prog->active));
>   	rcu_read_unlock();
>   	migrate_enable();
> -
> - out:
> -	__this_cpu_dec(bpf_prog_active);
>   	return err;
>   }
>   
