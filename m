Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E5C52C1C9
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 20:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241257AbiERR6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 13:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241220AbiERR6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 13:58:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE038BD17;
        Wed, 18 May 2022 10:58:48 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24IHDXRx029324;
        Wed, 18 May 2022 10:58:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=/wSB25d9dHEtozBUp8QSWnjdbqTThwDKbN+gOktSgYc=;
 b=UIZd9yQyiWeTknL7c9WUBUs3de1L0EJyCDdC+O0AbR/q8oKeqKaSweWOEZOkCeLZR+Mk
 UDhn1ING1D/OxS14DpBcvVZTWUjfiyEzNNqr5c4WHAMLq19LLBHWAzhk2cSMFLCEomAR
 Q8jnW6nf01REPkyYdCXnrEnCg1hpbaafwOY= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g4ey1gv7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 10:58:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XHU/Efo+Ad7gxK12IdzILTlb1evVoubD9UcwoRolk+c1Ghf4V0zDmEJ+Opy+DMpwowbJkxIoYSFzJ5BLmkWXtFF/0PIjqx/GlZ2cQv4FUCTF0rklxphBxtS0KWojY0uQJ7SqVWgEoxdEkI67NSaT+Ws2Sn6TV796rNkDGl79IWU4jUro4ffUSeyo6mFRiUVbQoWnfX4Lp/NuX9ssdB0USY4wEbQqLGrP9VwAat+fLW/G99pYZlmyVpyqSXePwEDlBx+mPPBji/KDaAtgiN2334gXOCxnPPeHI8DdFdEnn2Bbn8ji5incPsB5me0vGPHPucUuwy3M6pI4j3QwmBQ9uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/wSB25d9dHEtozBUp8QSWnjdbqTThwDKbN+gOktSgYc=;
 b=CsLjhPdkdpfPLgyfEDxGUR5o0SF8vFVqI1bkLGfb5XK5DpnE6iQLSO5iHx7wyyHDnfCr1usJjGjZlu8paPJyZ3GG8tuMKHfhPUfD4Z5tI64iNqMwxVwSCV7u1fHRhjygdq25jrPIVhm2kpIbS+v4vppMy2epWvPWXqFi8FKkeTWPkQsUOqHFmxqn6uwuO3DNXFIauY3bVSws/KnqesnRE0tWpp5/XzOYZFAw593J7QYYDAL38DTC80GUFlMhv8Hof6e7p5wUfWvHGsUhGEfNPLpV+7r/Q6BTIS47r2O5hW5dxPll3hRdUdzpFd8gF74ZLD/hcqZUu4KDzuz08w1CMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BL0PR1501MB4129.namprd15.prod.outlook.com (2603:10b6:208:37::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Wed, 18 May
 2022 17:58:15 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Wed, 18 May 2022
 17:58:15 +0000
Message-ID: <8912c7c2-9396-f7d8-74e2-a2560fbaad56@fb.com>
Date:   Wed, 18 May 2022 10:58:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH v3 bpf-next 1/5] bpf: Add support for forcing kfunc args
 to be referenced
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com
References: <cover.1652870182.git.lorenzo@kernel.org>
 <7addba8ead6d590c9182020c03c7696ba5512036.1652870182.git.lorenzo@kernel.org>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <7addba8ead6d590c9182020c03c7696ba5512036.1652870182.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0027.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::37) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5c0f552c-b534-41b2-0d05-08da38f7fb9b
X-MS-TrafficTypeDiagnostic: BL0PR1501MB4129:EE_
X-Microsoft-Antispam-PRVS: <BL0PR1501MB4129C1A857883532CFE298EBD3D19@BL0PR1501MB4129.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s4r0ns7BTjgAfePV4ePtn1W0b620bxMeDqhZUXFZItLMrhvD9BO7zPmJdCG7G3DRFPNMzrmyi2QMuh0Y6lrKbgOaLGAZm8OlguWCBpsjmhqpyNQ48Bl66oDh7TRrcwq502uYTEKbLgVsMOEdkW6fEC1A2oiwPv5ewgEFbjjgNosx76vSykAItf8Mpx6c+bD6Fkc7s8TAfe/8CAgizsxiCY4SFXymc4DzaaED0UoxwKke8slpQtWWKTpM6uHcDMkk+oSF4FgNQKsc7Ll/4nlFLqE5z+MAPWa+gjgbNOgpd+qS/14j22u4nE2+BJtcGL4WhdNqArCpzOTGxvoAA4GbGo5WNJgGWl4AYhWySw5OPFvZN1vkYhbhq63ICwjqi+rvIEZN1/hWjGbiZh+XR29APnudzumXids36UY1AEN2x2v4EB2oE9vT2DPqUc4zqVgHNMsQZ65krGQcXW6S528V/vsxPdWqOU13/k2612Ip0J50dr8rlfcArsyfqGP2/4ItNRRVWp6Ka8P/UyzdpnjZD11/EMgUwjhZjFqvRexC+ULO4IIBdqxoqLrubrCcNsYvIO12qjdko621OoTjd5fLpYzjDWCRLRMoY/FtuULP0MgCnoHNdcpIMUW0KsgNeiClILJTw6/sBQ43nKpq7Ce80ctYtLGi9mDmzgG6jjeLJRHJvdiewm4Zd7RsLDltU4qguPc6/og0UNfiIJvJynfHFaSN25CuHNSImrOZo2lfb68=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(7416002)(6506007)(31696002)(86362001)(66556008)(66946007)(316002)(66476007)(31686004)(6666004)(186003)(6486002)(508600001)(2616005)(36756003)(8936002)(52116002)(2906002)(83380400001)(8676002)(4326008)(53546011)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tm5rVmZSdTlZK1ZSNHBuVGpxejBSR1ZPK1NiTC9BYVJqRlVCOEJCV1RYRHN1?=
 =?utf-8?B?ajcyNllEekE4eUtNSERpbnFIR25WMnk2M05PN1BxSFZBSjE4RTl6clFLRENq?=
 =?utf-8?B?cFB1TVNFUzVrMWc1ejV6TjlOSWx6NUUyQ0JpcnlsS3VDL0Q0Q2pseG43Q3dZ?=
 =?utf-8?B?VnA0amh6Zm4rQ0M1andVd3BFNmV1ZzU5SUJ4Lzl3TmplTVYrenU4WkQ3eWZy?=
 =?utf-8?B?N0pqZmpGOFBUREZsZ2U2WUxnTGFPMCt3V2pRdXlrS3N6Nzg5MzRmdVhGRmZi?=
 =?utf-8?B?OGZhNlRmM1htWUZTVkRsWG5aa0JpbTVtUi9tQjVBNjZ2Q29DOFkzYWsvTEkw?=
 =?utf-8?B?QlFMSmMwL3hnNk1FS2NOL1ZrbVVESmY0bi9aM0xTYUNvRHhJb0FNd3F5RkFG?=
 =?utf-8?B?bUJQM2FUZG5DKy9OTTZhSytSRWZENVJHdVpza0dWQURROStFaUYxZEJTcVdI?=
 =?utf-8?B?NmRGNVdhT0Z4eERiUmpscXNVKzg3ODFtR1hJKzhrL1YyUWpQRVh5Q0FDTnNC?=
 =?utf-8?B?S2QzMWpvSG5oaWNOVVo3L3dERFJiRDZid2k5SWRPOExkRjQ2ZzNsekpibWZv?=
 =?utf-8?B?UWtxeVZ0V0t6V0hKSHJkUi8rMU1IQU50V0c1VEpIOXR6Yy9RWjFaSzl0cWZ2?=
 =?utf-8?B?S3ArUHkwSUh1QmVEbzRxNExITnl5S2cyL1NMR3MzdnVDVDRPRkMwWXJZc0ZO?=
 =?utf-8?B?cVYvUXpYYVNxMmpRYXphblFkcURwL2ZKc1lZdElJeFpoSnhibjNVaCtsWWFZ?=
 =?utf-8?B?aHZ1QmI1RnBKM25YNXRBV01RUjFISmVDcWpMelFhTDhTYVpZbVAvWURnbFVV?=
 =?utf-8?B?c1lvZXV6NnAxSjNrM2h4THpaVFpnMnVxaisrdCs0TG9QbG4xY001cTBDN1pD?=
 =?utf-8?B?VnpKSFcra0V4WStjVVE2YzVZZEpURjdsVFRQNHk3T3ZoS3JQZWtLQlpEYVNh?=
 =?utf-8?B?V1VvZHJ1SDJGOEh1Y1RCazYzUFJrWFJRMkU4UVVMWFcyOTJGTjloTzlnVFJh?=
 =?utf-8?B?enN0T1JjY2F0TnFYT0l4bldsUEVvc0RGbjI1N3lXMHhKZEdvSkw1RTNLZHNh?=
 =?utf-8?B?TzlIZFM0Ykx4UTFYT1JvM2ZPaTRBakpiSUYxbmRFVWtZWGphNzdZMjh4dE92?=
 =?utf-8?B?cDQyTlVEK0lTS3h5OW43bkFaN2wzdTBCV1lZOGgvNGhJZGlycHR3cHlzNmo2?=
 =?utf-8?B?VDJLbCt4NHNPQTQ1MGU2VzFIdlp5Z2lrbGZXY0hxNXpnUlJraTlVUTZCTDVF?=
 =?utf-8?B?eWlMUWhteG5nYUZZQXNxU1VocW4rL0djUFA4SklFNk1POFBLUlJLMFlkejA4?=
 =?utf-8?B?VWRHK0psbEd6WGJYOEpHK1Bqd1hETTlSMUVCaWZRcW0rTzNTaG0wNmhpcnhP?=
 =?utf-8?B?ckZubXNqY2wvMDhRSUx3OG0zOEF4V0d1dURCU29UYVZqRmNqTjVxY2VYajdT?=
 =?utf-8?B?cTlESjg4cklpeGVsT2Zad1F1Y1RBQnVVYVU1T3RML3pQMkZuaDlHRy8rYnF6?=
 =?utf-8?B?dDNGWEFPRG5ZV0xVbUVVblZCdVoxL0lPSlpZbmhuMVpiMC91SzF0WHBHVi8r?=
 =?utf-8?B?MWsyOUhldy9mcDUzanA4VC9wQ2RWc0JVRXdjT1pYWmZONEtGYVBBNU5QUzM4?=
 =?utf-8?B?MVNGc0ZuNnhhTC9LVFJtemdvQmd6YWxjZXhjUk5wRXdlQWJEbnNmeUV6VGVR?=
 =?utf-8?B?cW9SRXFrMVQ2M0ZuT25UU2Yxc0J4dk8rcUx5SWUxN2R1S2g3WmpnUlZjZU1K?=
 =?utf-8?B?bHBoa0VTUGR5T3VqK09YQjM3czNyd05QQ1JaTGw4TG1QRU9lcUZGQUI5ZmpF?=
 =?utf-8?B?Ym51UVBLTmZIRnI4NHNmei9YNS9ITjJoU0hRWkhHZjcvemFZYlN1MVl1Unp3?=
 =?utf-8?B?ZVZkb1pzcmpKdDAvSit0RXMwQURTdkNxSW5IdXZ5WEdXQmR3SXpGVnZtZ3gw?=
 =?utf-8?B?UEltOVYyQlZxWE5FZnhwcW82SnNjK2RZWWhwUFBRcldrNTEvcTVrOEc4b1Zp?=
 =?utf-8?B?L0YwdmhlTS9JU2hOaXlqMzMrUUE0bzVleklxMVVqSXAzMTVDUXJMVjkwM2RU?=
 =?utf-8?B?S2dKeW9vWlY4UmF4YW9HNnlmQmNvSkdiUEV3aFovTjZqWUphanlzUkhFaTBM?=
 =?utf-8?B?eDYyTjF3OWVVVk5oZUR0Z2ZjSWlEOS9OQzJuL1h5MU9wSGdLbWVBSnVRQ2Nt?=
 =?utf-8?B?U3hYZmQ5azRGMUphdnFTeUpuNUExVEU5RHFKS2ExZVVxN0Rjc3lqbXhVOFFy?=
 =?utf-8?B?UXo0b1lWQU9kdyt4VTkzWWtvdFNyc2MycmJqZVY0dnlBNnAzOWRjUk94RjN4?=
 =?utf-8?B?UEh0RkZVMDJqdGVkMGhycUtYc05leVNkMEZTY3NMdWM5TmJ6ckRiWGltcCt3?=
 =?utf-8?Q?CTME5tCdH4i7OAig=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c0f552c-b534-41b2-0d05-08da38f7fb9b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 17:58:15.6760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bynGqy7dar8r+FiKuH/2SrOYREWLWszucaktH6ARY6eWFvZI82gQmPh0eBVnOsoG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB4129
X-Proofpoint-ORIG-GUID: DHY4a2IqY1brAShOkqfZhpaUOuBEiwYT
X-Proofpoint-GUID: DHY4a2IqY1brAShOkqfZhpaUOuBEiwYT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-18_06,2022-05-17_02,2022-02-23_01
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/22 3:43 AM, Lorenzo Bianconi wrote:
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> 
> Similar to how we detect mem, size pairs in kfunc, teach verifier to
> treat __ref suffix on argument name to imply that it must be a
> referenced pointer when passed to kfunc. This is required to ensure that
> kfunc that operate on some object only work on acquired pointers and not
> normal PTR_TO_BTF_ID with same type which can be obtained by pointer
> walking. Release functions need not specify such suffix on release
> arguments as they are already expected to receive one referenced
> argument.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   kernel/bpf/btf.c   | 40 ++++++++++++++++++++++++++++++----------
>   net/bpf/test_run.c |  5 +++++
>   2 files changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 2f0b0440131c..83a354732d96 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6021,18 +6021,13 @@ static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
>   	return true;
>   }
>   
> -static bool is_kfunc_arg_mem_size(const struct btf *btf,
> -				  const struct btf_param *arg,
> -				  const struct bpf_reg_state *reg)
> +static bool btf_param_match_suffix(const struct btf *btf,
> +				   const struct btf_param *arg,
> +				   const char *suffix)
>   {
> -	int len, sfx_len = sizeof("__sz") - 1;
> -	const struct btf_type *t;
> +	int len, sfx_len = strlen(suffix);
>   	const char *param_name;
>   
> -	t = btf_type_skip_modifiers(btf, arg->type, NULL);
> -	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
> -		return false;
> -
>   	/* In the future, this can be ported to use BTF tagging */
>   	param_name = btf_name_by_offset(btf, arg->name_off);
>   	if (str_is_empty(param_name))
> @@ -6041,12 +6036,31 @@ static bool is_kfunc_arg_mem_size(const struct btf *btf,
>   	if (len < sfx_len)
>   		return false;
>   	param_name += len - sfx_len;
> -	if (strncmp(param_name, "__sz", sfx_len))
> +	if (strncmp(param_name, suffix, sfx_len))
>   		return false;
>   
>   	return true;
>   }
>   
> +static bool is_kfunc_arg_ref(const struct btf *btf,
> +			     const struct btf_param *arg)
> +{
> +	return btf_param_match_suffix(btf, arg, "__ref");

Do we also need to do btf_type_skip_modifiers and to ensure
the type after skipping modifiers are a pointer type?
The current implementation should work for
bpf_kfunc_call_test_ref(), but with additional checking
we may avoid some accidental mistakes.

> +}
> +
> +static bool is_kfunc_arg_mem_size(const struct btf *btf,
> +				  const struct btf_param *arg,
> +				  const struct bpf_reg_state *reg)
> +{
> +	const struct btf_type *t;
> +
> +	t = btf_type_skip_modifiers(btf, arg->type, NULL);
> +	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
> +		return false;
> +
> +	return btf_param_match_suffix(btf, arg, "__sz");
> +}
> +
>   static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>   				    const struct btf *btf, u32 func_id,
>   				    struct bpf_reg_state *regs,
> @@ -6115,6 +6129,12 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env,
>   			return -EINVAL;
>   		}
>   
> +		/* Check if argument must be a referenced pointer */
> +		if (is_kfunc && is_kfunc_arg_ref(btf, args + i) && !reg->ref_obj_id) {
> +			bpf_log(log, "R%d must be referenced\n", regno);
> +			return -EINVAL;
> +		}
> +
>   		ref_t = btf_type_skip_modifiers(btf, t->type, &ref_id);
>   		ref_tname = btf_name_by_offset(btf, ref_t->name_off);
>   
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index 4d08cca771c7..adbc7dd18511 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -690,6 +690,10 @@ noinline void bpf_kfunc_call_test_mem_len_fail2(u64 *mem, int len)
>   {
>   }
>   
> +noinline void bpf_kfunc_call_test_ref(struct prog_test_ref_kfunc *p__ref)
> +{
> +}
> +
>   __diag_pop();
>   
[...]
