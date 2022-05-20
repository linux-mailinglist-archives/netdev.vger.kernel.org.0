Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DDF52E155
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343972AbiETApw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiETApu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:45:50 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85519A469;
        Thu, 19 May 2022 17:45:47 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24K047wP029843;
        Thu, 19 May 2022 17:45:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=JlQFZtX6bFdREwR1lHwlCnRclL4+9oDaQ7WyRr6g7jQ=;
 b=LZT8RFOUkkfQboLMhvrbMUl/KGSdR7z+8XKe+Wwh6rQlryix4UL5uuDCgL/lpaZtIjNL
 grdTugZlUrHK5Gr7+r8Ap3eHrq7FkqT74A2ejYN7nqJ8nS3aRMecqvvEe0ayKsF1xw9w
 yJSt7LXkRTctWi2FD0R6IKLiVVSeSE3TpAQ= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3g604bg5bg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 17:45:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtvpbInoIz0lpRqMp3sNmxa5sQizEAUQPyTh+Y9ApjtYToiYsYoZP7aKSdOaAaYgdf0Ow9Az90IXla3+wlyZqhr87ytlhXXFJh/rtwOCLMrUbqSR+t3nwPmczoDs8DkMT6wRfl/I2TIe2psiuz8Gzzrfcur0FGBBbAVAWAREFVaMglc4ryLM/6UMptyWwzcQYz1wlEjZHEXhUhsG3sInPJY2fF5fLX4HSUnH95Q6aFVxtVb2hnwELG/Uv4ue+VWe6d0k5hm2+IhBzSBGuAYaZz/UXxbeLuLWeC4YSHW5Ovfv4F5RwQKueH58sVFIG1XKdRzydhV3PPdBEaEZBZ8Jhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JlQFZtX6bFdREwR1lHwlCnRclL4+9oDaQ7WyRr6g7jQ=;
 b=T9u74CzyE7ODRfyCWcOvtE6jQG41KNQXw8Ka6kyAiLWzT7Lj3H2NJBjUMMJyV/e4T9apt8/fevN4ABVFNZSnGHbqAWjMcKyHIbRZXQrIwlT6xDAzUrHHxGf7jviHwjrvhMrY/49qe9sHJXixXpmg3NgjBALyvQlp8MsetAAyg5wfkhz8R3Nq6tyZea7yTZ47xfKww3w8hOZvqYbcIYF/JaOKNyp2MHVWBgJMwEdHlWDDksuTz3LnhclvknR73QrWidIGmX6NO6D8Ol6lmQe7k47M64tl5E+uCiT0JU7gpIbMFkp0l2eBNsmM7GaJ7NIwzrdMWP7RVHB/cYvLoD92DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by IA1PR15MB5467.namprd15.prod.outlook.com (2603:10b6:208:3a9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 00:45:31 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::5811:4996:bbfd:3c53%7]) with mapi id 15.20.5273.015; Fri, 20 May 2022
 00:45:31 +0000
Message-ID: <787b0ed8-00f7-3a94-85a8-0cc301b11470@fb.com>
Date:   Thu, 19 May 2022 17:45:28 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v7 01/11] bpf: add bpf_func_t and trampoline
 helpers
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
References: <20220518225531.558008-1-sdf@google.com>
 <20220518225531.558008-2-sdf@google.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220518225531.558008-2-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44d908f7-49fb-4610-ac60-08da39fa0a93
X-MS-TrafficTypeDiagnostic: IA1PR15MB5467:EE_
X-Microsoft-Antispam-PRVS: <IA1PR15MB54677AF5EF605D67FB7B7336D3D39@IA1PR15MB5467.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: INvYMstpp7WsAWwariwZ0xHbnIvAXSAZtNpLfliUdz9hu75EznpXq67FoHsiH8wzVpaHu7pe6zFq2OtLZZXZsDH1ajRnqalBL5z9thGyPFE6v9BIyZv77Ah5gmkG3v4eWujm8y/KlpjUg/MRWBQ+X0RwJejZDE6E39s2zkZ6gNgIbFKI16/wDjJvPobby7k3L17DCNzL/CIHL4pUVlKbSJ+3FRIg9OUHiGDQ93G+HbYLyM/9kMMgcQgMseGiHKBDIWl5KmlUWDu2eceZqma66yjY/C8KhYhStSU0zzjNxtR2+5WRqdJijlaX0FyCbZLQDfcbzImusHrrB/XK2mscEPPjTECDvkN/8bS7qhZscqIdnH9A8hDKE4p5NVHd9pkROK2i0rj46VT/CnPFgGfdMJfXF+V40QsN+ow4iloCrw2+nrW5tU505E+X67k7XuHFE/opgZQPz0unPCi0b/5rm9e+v+IXahG6zdmx44LlecPCnxqnkb+Mp19oNNE6EADAAm5p43o+3K/hP6Ns/nVKE81bj8CJbBcKiZHYNZXzPl4f6SBFr3Wj6U1h7JSTVOHh1wHGy4qaNjec/QLYUuBSubmNUT6ZOtZeRfuXHppf0ZOjR98tRVrXBmPj3QufNCVlaOuOdGON4xvDRYUyeeVutD917YSDy7tnt+L5ySHnNmRr15wSlWGNT4f8gsgmQgZ7FH8z6MgSyjQlWzz9toBjrePyw5/Ozq4VkLLK4vNFYEk7falQMruTEXWbDtXHsSWC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(31696002)(316002)(2616005)(186003)(6512007)(6486002)(508600001)(86362001)(83380400001)(6666004)(52116002)(66946007)(6506007)(66556008)(31686004)(2906002)(38100700002)(4326008)(5660300002)(8676002)(66476007)(8936002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U2YrZlpvSXlPaHlNMUpYV2tCYW9GQlJDN0NnK0xxWmhxL3dJdFcwVWJqSnhj?=
 =?utf-8?B?S21lbDdjNEllREtqcHRCYURTNWJ4bUF6bzZGbzFjZ1Njd2huekliRlNFT0Zu?=
 =?utf-8?B?U3p1eGlKSjFNTVBlNVRqUDcyL0ZmWlhrdGFCaUxyZEs4Qmd4UmNpMmE5aUk0?=
 =?utf-8?B?V3NaQU81QU9SRjNmVzkyWkZpaElIME9yMXM0TlRnUkxpOEdUVFdoWEZNZkJ1?=
 =?utf-8?B?ZlhjdlJwUEFDd0I4T0E1TkRyaU5MQkV1LzZGNHVXcGhMZEZZMXU2YThWRHZv?=
 =?utf-8?B?QkFtZ051bC8yRUg1Ui9GcUZ1dXFMc2VpdWhGL2txM085Smh1VWFEdzhsWEND?=
 =?utf-8?B?eEZNTkNrMy80UnhvVUlXK2VJamdNQUN3clFLQUJoNGJ1Ni9MbUE3N3NiNmR3?=
 =?utf-8?B?L2JpREllYVB1ZURqQ01rbCtaTUlYWDZiYUUwaHFlRzhDcjlvTjFVbmFobXdi?=
 =?utf-8?B?V3RpN1ZVWUlQTUV5K2NoL0dtb0hIQ3JZTTRsdW9JaGRPdXdRTnl0dGhRcWJv?=
 =?utf-8?B?eXVkZG1EVS9EV2V0U2JNTTZ3aWZLR0ZRK0lWcjVBeXhGNVhvNk5pQnJmT3Ew?=
 =?utf-8?B?NXZFV01qajFkek93TDcrUUd1TUowb3RlcDhrM0hiYS9rS2p5WnlLRWhMamtT?=
 =?utf-8?B?T0w3N2ExRlF3NW83ZEpxMGNmY2daWEplV0NYZWNVS2tmSFpCZEgrb1pSRk9r?=
 =?utf-8?B?VG5aenhEQUVrSTRjNDF1QlAvUDJwMnhsc2dxNEdaSWZwalNhRVdmeDJuVmZK?=
 =?utf-8?B?K3gzQ3ZUNUJ2RjFadnRhUzdGemExYVY2QXdLZUttOHFvVHFpMnN1VkFDaUdW?=
 =?utf-8?B?eFIzUWpGa3pFN2o5R3V1emJYQnEybkZBQWl1Uk0vNkg1U01pMENuQzUvd2lQ?=
 =?utf-8?B?RjFsMGlUeXZBWG96UkFSeFdiN3owU0FzVWdHbkh4cGJCY0JaWWQ4ejY3NVVt?=
 =?utf-8?B?aDFKdG84RmNxcHVETzBxL0VEaGtCWXJrZXRMVnM2SEdjRzVsOEhtVVorZTJw?=
 =?utf-8?B?S0N3d0Z0OXU0QmVyamorVkh3b0Y5THFlQzNYRnJBek1nSUdhbFdENWNwbHlv?=
 =?utf-8?B?UkdOQUpsVXNiRFdySTU0WEIwQVFhSDcrbWtpWDdWSjVpQkg5SWE1cmlEUk80?=
 =?utf-8?B?bzlhRUE4aXBpOTRmT0hxVS9ZSGg3YXFpb0V4QlJRcDhWdmp5QVJuUThwc1dt?=
 =?utf-8?B?VWZQUEZwV2RTaWp4bEdDQ1kyYVpkNXhxSUVIMmx0eDNUVW9YMzQrNWFtWTZu?=
 =?utf-8?B?bE00NDAxYU9yMGpaTHVTaFlXVnlqMThDL01iU1ZiL2VVenkzVVYxZXVwckJN?=
 =?utf-8?B?bzRvVWlkbzdyVERHb1M0Sk1jSWR0MTVzbk5kNkRZdlFnalA3eXJUeC81UnJ6?=
 =?utf-8?B?endIWjltT0tjTTJSVkUybUtXbUQzMTJIazlQMm1zbjU2TmtUYlJoTW9MSVhi?=
 =?utf-8?B?OFB3bHVDRFhtZkhhWFJON3RuRzRlMVR1U2did2NKeVhsemlEQXZqQnZSaVBD?=
 =?utf-8?B?Mm8waHFHZGg4bmtQNmV0b2RmOEE0QTFyWkxENFp2OGtUNzF5VU9vL3hvMGlL?=
 =?utf-8?B?OWxZN0lNZklyd0J4WXF0R2g0QXhIcjQ3NjhSaG9ncnYwYW90dDFDK25TbHpP?=
 =?utf-8?B?bXFlMm52aHZuNWg2Vy9QbUNkdzFnUmppcEVYczlyM1VsOFFpaFNyM0ZlTW0z?=
 =?utf-8?B?bkt4VElQSVdyZFFFR1hmRSt6bUJESUFWZWIxTVhlaVBKdlY5NWEyY2FxTHVa?=
 =?utf-8?B?QjlJQ2Y0bFNTZlgyVFJWZVNNUzRrMjcwT3o1RWhXWjZQczlLL3RXMCtZRlJk?=
 =?utf-8?B?VTB4VU9UemxiL3VBa015LzF0Tis2eHgxZ3NpeU40WXFZYm1HUXM4ellxVy9O?=
 =?utf-8?B?ZXdoK2ovdmFEVnBERlpJOVdIS2JQZGowWVhpb0lUdWo5akRzTDlEK09IUkFt?=
 =?utf-8?B?OGdyU1NNZjl6blRvdWJBbGV3N2dneUtTMERlSW9SbnVJM1Rsc0EwTmptOExG?=
 =?utf-8?B?ZVZQNHFmaEV6MzdBSFpSVVlEdnRJakxLZTlkZW9rVnRreDhkYUo0YXV5OGhW?=
 =?utf-8?B?R285R3NETmhLcmxBQ1BoU2NybDNwTThMTHk2N2NQWXZMaDlOTzV1ZFlLZEIx?=
 =?utf-8?B?V3FEUTlVbUh5SGtPYXlvb0FTUU83SEMwdFA5MDRBS3BVendkV25sVm5JK0JZ?=
 =?utf-8?B?N2tUM0RWdEp5d0hLVjJjNDBOc0xlb3V2ZmR0ZUZQOVMvM3JqeGJDREU1YzRt?=
 =?utf-8?B?dGp2RHQ3ZmIxK1NTODZKYUl0dzFJVkdnNTljS3g3Y1VNendFelFWOU5LT01X?=
 =?utf-8?B?aFkwVkZISG9VTzFZd3d5VVQ5VHdrVTNReE1Zc2UzMVd3c1h0b29PcUZSL1la?=
 =?utf-8?Q?C3Y6aap1pqxgjKX4=3D?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d908f7-49fb-4610-ac60-08da39fa0a93
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 00:45:31.1059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gmpa1r3ensRaSZDG4KpBqbpPo4zydg4/CGigiIl9TQuXJslxmCPN/rs92WnMtPH4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR15MB5467
X-Proofpoint-ORIG-GUID: 6RBlw0oZEaaJrvNZ-baNVdzCH5etKItz
X-Proofpoint-GUID: 6RBlw0oZEaaJrvNZ-baNVdzCH5etKItz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_06,2022-05-19_03,2022-02-23_01
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/18/22 3:55 PM, Stanislav Fomichev wrote:
> I'll be adding lsm cgroup specific helpers that grab
> trampoline mutex.
> 
> No functional changes.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   include/linux/bpf.h     | 11 ++++----
>   kernel/bpf/trampoline.c | 62 ++++++++++++++++++++++-------------------
>   2 files changed, 38 insertions(+), 35 deletions(-)
> 
[...]
> +
> +int bpf_trampoline_link_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
> +{
> +	int err;
> +
> +	mutex_lock(&tr->mutex);
> +	err = __bpf_trampoline_link_prog(link, tr);
>   	mutex_unlock(&tr->mutex);
>   	return err;
>   }
>   
>   /* bpf_trampoline_unlink_prog() should never fail. */

The comment here can be removed.

> -int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
> +static int __bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
>   {
>   	enum bpf_tramp_prog_type kind;
>   	int err;
>   
>   	kind = bpf_attach_type_to_tramp(link->link.prog);
> -	mutex_lock(&tr->mutex);
>   	if (kind == BPF_TRAMP_REPLACE) {
>   		WARN_ON_ONCE(!tr->extension_prog);
>   		err = bpf_arch_text_poke(tr->func.addr, BPF_MOD_JUMP,
>   					 tr->extension_prog->bpf_func, NULL);
>   		tr->extension_prog = NULL;
> -		goto out;
> +		return err;
>   	}
>   	hlist_del_init(&link->tramp_hlist);
>   	tr->progs_cnt[kind]--;
> -	err = bpf_trampoline_update(tr);
> -out:
> +	return bpf_trampoline_update(tr);
> +}
> +
> +/* bpf_trampoline_unlink_prog() should never fail. */
> +int bpf_trampoline_unlink_prog(struct bpf_tramp_link *link, struct bpf_trampoline *tr)
> +{
> +	int err;
> +
> +	mutex_lock(&tr->mutex);
> +	err = __bpf_trampoline_unlink_prog(link, tr);
>   	mutex_unlock(&tr->mutex);
>   	return err;
>   }
