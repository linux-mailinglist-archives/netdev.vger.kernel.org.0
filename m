Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F87576AF7
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 01:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbiGOX5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 19:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGOX5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 19:57:44 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB96F904EE;
        Fri, 15 Jul 2022 16:57:43 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26FKnOl3016693;
        Fri, 15 Jul 2022 16:57:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=kp7VOhgncTUyNkDSwkD5iuVR8OcFWy+icWqCIMUte78=;
 b=K91b5PYAePmrdFk3LnmxNff9K7pFboesY9dolMg7UMfgXyeBusfAeRrrxhf9CrQsOlOZ
 m7as7Bvknj8uRvzcCogmf2I+RyMcx5QR8QywxQUeanG2hmlSdeiHDLho9RVGitLSsvy0
 khW+iavr8iBIP5qPuBjlBaIi6zPcfir/kww= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hb892v1em-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Jul 2022 16:57:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LomFz/MAdTEMLZSpXGw8V1Bpd6ZP0p+pPY0KszfSz9v5LRmAbvTEhNzkYFY+qOEz6ToxQZ+OXwGAuwreywULZQkSLmm1QIs8k6NDJTQIarjJzJpQsYFT4mPls+xgEDuFdC/tpGv5bc8vRrdzgmVIC8uk1XdExlIys6L+JnYx+VeganLUwSL4o7GQrXScqVvUgYq91Otl2uDeSVUCsWV0P1mjTgfjDNSvtE9z72K36m7+/jq4rf6O1XernyfP12zpZ8nwJJMwdgzaUUWjK0HuF2dFxmpOj6k3cFw+lJ+Xa2B1VJjNOTQ1cLzC1RXy7VGbz+RvVUdaIuQop+1i/DWH8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kp7VOhgncTUyNkDSwkD5iuVR8OcFWy+icWqCIMUte78=;
 b=KYMRVDnK/1CCCKNX4UXE1EDXvNzN6peLXh9opC6l7f1/ODuZFsmpNQ6urOMnBxyjLCO5QJssKkmjwTE5b1pWpCTPjpDNRHK1ubh+s8JDc8wLK1ri8h2H/99v5m9mRXd1AtiY1xxPqQPQOKbSpYm2OtXeyqiE5vQUyVqawB2R9moxxls3G6VssJpnewLCEHpQkfNgxtyX009UY0o9CBc+nYoBQAzCJwpH9I5tTcmv7vURfR3SLGCpljdVrYaJ6M/00Vnl+8VqncVATWyhswGsfLw3UQ9nyghQ92moAXsmjDCwfZTZMO49VWKUTMLJ0QnHr1zrtYO86VuwoCpINzEUbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2693.namprd15.prod.outlook.com (2603:10b6:a03:155::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 23:57:08 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5438.017; Fri, 15 Jul 2022
 23:57:08 +0000
Message-ID: <3cbd73a4-0644-c8ee-a14a-836702b84b8b@fb.com>
Date:   Fri, 15 Jul 2022 16:56:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v6 02/23] bpf/verifier: allow kfunc to read user
 provided context
Content-Language: en-US
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-3-benjamin.tissoires@redhat.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220712145850.599666-3-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::23) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e50e846-bf98-4992-ec78-08da66bdb3a4
X-MS-TrafficTypeDiagnostic: BYAPR15MB2693:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OIN4EeBPHxiV8pTnlTTyVswUrNSX9Cu6/1VHgsTbU5s9tbBu0LGlz7rJbll4jRqmpyf5s1L6TWPqOY4jIVTkZNDG7pKbW3dkDgrgKbMR0U4gai+qsqgw8vvB2cHTJ0jwdWu+T+XWR8GyRv0JRW7eYGOWbi5TS0zE3gSHjgfyT+mARfOAvZ4mRIxzg4Ui8nFLyiBN0DjZcVeiTumt/SkIMdXPXbNSkVSU2iF/0i2UMWJOe2J3MFoZxqGmWjLQcyn3b8d3EXCAgUi8ILotSYOvyc3KoIiI6I+YnHGCVV+19xUymcKzNv49o7oZ4SYEwk5RpJWwZDxgEQdHt67gvxd/QiTIeBQYfJE8NFmqvoQQlaczNen/u+U9kpx3ZXw6gin6UIhQDrrO89cibOp3KqKIq8CVylVeEjz4yIXd5ZEEVzQI3l4lo7nAjEHokWScGkG24Ufcez5WXmoVdkV25Jpw/KrxbcnGj8UFBe4En01YS5czoX1Cz+8xWeMNcDzvPK17pG6swlqEdHCOC1TqIcl5L6WUmJC9kAxoIrdmrN7k7/FrVzdPy8Hc5wLD/fFo7anFeU/HVOTlyCEQWZHRtmdb6cGAEVMux16LNbqyRwlVqmWT+mXg+xtohnqy8Ijp9rVf0ZobospvEjBztHPa/oH5ow1LhTJF67HP8BlHwzF7BTKM796LySp0qes2F1cMZXqzQBv8QWWjfS57qBQSGE7VoqHBOjhiNoLNmhWHxPdrb3gR6WXekl09gB7+EayxWt9rSOupUCF7d8SPKyHAlessXgKBiIWH+RyVab/YuS8zTNRyd7A5zVMDDXAMiwoBG9QA8s+LlH9yFKjemVyG2u9JAZT10UVAmz0KXM7BckFGqHNUmH9fNWRZnfEw0Y/1gA53
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(2906002)(316002)(8936002)(921005)(8676002)(66946007)(7416002)(66556008)(110136005)(4326008)(4744005)(83380400001)(66476007)(36756003)(41300700001)(86362001)(186003)(31696002)(53546011)(6512007)(6666004)(6486002)(31686004)(6506007)(38100700002)(2616005)(478600001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXJkcVdHYk9VQXRHMG4zQVZCamxSZlNmQnhmcVBpTFgxVU81Z3ozaE9KNjlT?=
 =?utf-8?B?dEI4N0MwTGQxTFhwRWc0UndRVHFuODdwWTRDL1FJZFBiVTRENFN4enRQN2pw?=
 =?utf-8?B?U29OWnlGQUkwVXgvQVRkdVpHMFo1UjdlbGJTcDNGbUhseDhIT1NNNXR0YkRJ?=
 =?utf-8?B?eEpnRmkvbWhFa1haTXBzUWE0eWgwNDJtL0hpdlFyOFFKdzRtaHpqTVZ3UU1p?=
 =?utf-8?B?QlNBRnRYTERUQzUwSUI5Wmh0L2V6Ynh3MXRoSDl3RzJWZG9HbzBDUFZHRlFL?=
 =?utf-8?B?bGJzUUZzS0EzVkFrK1FWVzdTZW1qdU5KOUwrdGF3Sy9kMkVxYjZjbythd3pI?=
 =?utf-8?B?WFdRR0hNRFJGemp1Q2tOeHRIYUY4TllWb0hjRUxqVTJlbmRGUW5SUUlkT0Nl?=
 =?utf-8?B?enA1b0dESnVnUDFmckpDZ2twek5ETXhWTzFPcDRibmZKblEyRHFLVUZPTGUz?=
 =?utf-8?B?YUI3QUVxRWtxK1J0R2s3WXhUMzcxcEFSU2o0cm1ORmhncjRRQmo3NlFXM1ZJ?=
 =?utf-8?B?MkZQQXBWeDk1b0pXNWVUSC9HeEVLbXR5dUQ2RmM0bkI2QlNoV1FJL2w0Tm9u?=
 =?utf-8?B?M1FkcER0SGdzOGdJaWh6VDluMm8ybDFCeWFhVUpDeEpCL002Y0tQcEtkSG50?=
 =?utf-8?B?dW8zVmpnazNHT0NZUmxOT0d2OU9zU05idEJqUFFqWjczaXR6d0FYa3pmaXpx?=
 =?utf-8?B?aVVYNzZ4S2xHREtKUDRXeHpLRmIwNlFwUzJlUWRoTVVtNmFwN05uVVMwQnBI?=
 =?utf-8?B?bGlQSFROR25pZEtLUzZZOTJub2h3akZJRm1oMjgwblJkU3g1NW4yVFArWUdx?=
 =?utf-8?B?V0J1endCcGxTcUc2OXAxN0xCRjZTNE9zTVRncGtaRldPZFRDM1ZzcDRhclQy?=
 =?utf-8?B?V1hTY09jYXphZytPY1FTbXVmSzNEY1FpY1BpbVlsZHp6TVlnaER5enRvdnNO?=
 =?utf-8?B?UHF2V2R3QVo4OWtDbVd6WVRTY1E4ajVPWG9mTjdKTzNZL2RaZjNKSlhuSE9j?=
 =?utf-8?B?b0V5dUd4dFphZFF5YWd1UVZxQXFIc2lzdWdIUEtMYmdlNGRJOEFCaHhVWkEv?=
 =?utf-8?B?K3lQTEdJRjExWkVkZTcrNkYvTnJFYzNJVXNhdlF4THg1UnFZU2tqUGdRYXEr?=
 =?utf-8?B?WnlJV3AxaUFDbmhyT20vL0VxdWxPdWRBZFZwOXVBempIVUtRRlJJaGxUT2tT?=
 =?utf-8?B?eWc2b2d2OXMrOUR1STNjZDVYRG9FSnpzUHF6ZjFmMFhvcS9jRm9oc3dsNUFh?=
 =?utf-8?B?d1dJdlJVQmt6QmpTZGlWKzN2cEtxVlFwcFBMZVhQbE9zVHlrY1BwV2tPR3RF?=
 =?utf-8?B?V2VrNktjUTdoVlNlNkxYMkpQYVpqL09Cc09TcW9RdVlWbEhzWEdoUG02OXpx?=
 =?utf-8?B?VFpOT243VWt6d3FsSUlBcllZWVlvYTg4MDcyZllNcDVVbTVDeWhGdFp3SnlJ?=
 =?utf-8?B?cEc3d0RIN3VtcHIxSGxkNTM4SFlubXhqc1JSNEgxN2JpNzRrZ3VPNHpkek16?=
 =?utf-8?B?ODROR3R6UDZQVUgrNVE4Z2JRT3FWTklZendwR0NRcmhML1FSK2ZqMEUrWVZs?=
 =?utf-8?B?OGFLdDl5Q1lzUlYvdlk0QWoxbTRLYnQvdEhFZWVxMTdHdjJQc1g1RTFPWVFi?=
 =?utf-8?B?aHRPMjZFbW1xZ21BcVMvdnBIdzljL1Y4OEE3N1F4QVdrSDlLcnVPT2puZHZr?=
 =?utf-8?B?K0I4bitWWGtzUWF3RHFUcmQ4UjlscXp3NEJ4eW1QK2FPcTFDaThYd2lGbXZk?=
 =?utf-8?B?SktlM1I3VlE0LzBYZFRSZlFGU2FrcTAybDFnRDNzQ2lqOElJdWpsdWVzUmpB?=
 =?utf-8?B?ZWhIZ3U5azVnSnY2aEVRZENKRnZuL2RtOGg0MDlkelJ5NGd1Z1Vic0ZJTjRI?=
 =?utf-8?B?YXdMQ0VaNW9wMmlkRXF1c3VRNkxNNkJqamhQNmNaRTZTaEFLUXZjTEgxUUJR?=
 =?utf-8?B?Q2s0VE5uVGhSUGxZNTM0WHFSRldkQS9ZeUl1M000bWNma0JEQWRHMDZZdUV5?=
 =?utf-8?B?Y2pRRDZadTRRM0VkREdyK0dmNDZuQzQ0cFNzU2N2ejlEM1cwc1BrWlBzbUI2?=
 =?utf-8?B?UUxSUDN4UHBTZzRiZnZramRWL1BGZHlXS2lPekt2RWRiQUhRckEzdkc3MUpI?=
 =?utf-8?B?bUFGdWlqVDhOUjJkQ0tORkxOa1J0ajFlOW4zY2FRaWsyWFF3V2NLc0dZNE94?=
 =?utf-8?B?N3c9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e50e846-bf98-4992-ec78-08da66bdb3a4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 23:57:07.9965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sozOCLbuH+b5COYvMUKpP6Gv1Pn1IVNSu8ucu/cq1+D+jwo41FnMrpKTrIVpRuDG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2693
X-Proofpoint-ORIG-GUID: GiRilcKKzFSaOrDKdID_6VMzkXNOsCkc
X-Proofpoint-GUID: GiRilcKKzFSaOrDKdID_6VMzkXNOsCkc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-15_15,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/12/22 7:58 AM, Benjamin Tissoires wrote:
> When a kfunc was trying to access data from context in a syscall eBPF
> program, the verifier was rejecting the call.
> This is because the syscall context is not known at compile time, and
> so we need to check this when actually accessing it.
> 
> Check for the valid memory access and allow such situation to happen.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
