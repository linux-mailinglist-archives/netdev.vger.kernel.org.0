Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FFF4D4EF3
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiCJQ0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239589AbiCJQ0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:26:01 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652E71EEEA;
        Thu, 10 Mar 2022 08:25:00 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 22AFguH4028439;
        Thu, 10 Mar 2022 08:24:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=UKgZjKuZVNOLU9QBdrkRIneNA3S0t2UU1n3xTMYjems=;
 b=MF8KFUIDFeV4gAGdSC1D2VwmwYDVyl0K64EXty9xb+3T5PqA3gqVLhUpS6hA6VExgj7y
 /bhMxor2Q4FCqUbBWvr5xMyjhnuv3ijE/mZRMsTeW4KsR24d9IIi/+TUfXd33iF0ztne
 7/qarEc7WTTyW+lZzBFKRtjU8jCEOegTka8= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by m0089730.ppops.net (PPS) with ESMTPS id 3eprkfjf7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 08:24:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vg3sP8CNVWy+315lTEN/YsgaOtwonF5XdgTESPsQSKRR6gIKKzZ4G+CeiXyIJDFrOqq0uykTqiBsmpplgX5pMx55228Dr15i0XlZDK4Ix9twPq5yGC/Rbh6MldgYil8cz66f67OzFC77Itr0g6TljA78uLBWv+bxViSa3WJ3KNWHagfrwg+OXvov9dpKYbgvjxlSKF9EEqksFD09P2WuRUQRH97MH12+pQFXmzSpRrw1qHzO9mS09TjahIlgnl+Jdl5FSwFer2GbXgdqdMbSJpU9ekmV0yr3KK38nP2BvY7ajMWTE39nWdoSjIOHjD3Ok0qTkUfn3ewXCs1Ez1kBBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UKgZjKuZVNOLU9QBdrkRIneNA3S0t2UU1n3xTMYjems=;
 b=KoAVQkQ2X3SWIYIm1+koBpJ1X2/4jiOqiEEm+rIX9ZD3FIxM8oz7DPaoNZZDcvrfSrZ2ZWMdzidTqoQkPcrjeNhy24OHv0MOGLkdAuZ9jCNFfrEmhsuGCU3WVUlTPy50CGu5BtmYvxZbTEqZaCOJGTTBKCCkqvTrvg30iukBnzCN78SGTvhTPXlrFLnHE/oVeJ9AEnJBxLg33ibsI47NHEb44Ht1WyR8s9OcBzkcmk5vQJ4frI6qzkJhbLegQjz4k+ST4ieULMG8MTodu8m909sFmzrs+nsIucbj2s5cIHtzf3OXJZtUpLw6eNw7nQ6sF1QkonBEJxcL2XSK+bWlbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB3286.namprd15.prod.outlook.com (2603:10b6:a03:110::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Thu, 10 Mar
 2022 16:24:42 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c5c7:1f39:edaf:9d48]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c5c7:1f39:edaf:9d48%4]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 16:24:42 +0000
Message-ID: <a7025518-3119-14f7-f761-b6b21cc8c324@fb.com>
Date:   Thu, 10 Mar 2022 08:24:37 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH bpf-next] bpf: Use offsetofend() to simplify macro
 definition
Content-Language: en-US
To:     Yuntao Wang <ytcoode@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220310161518.534544-1-ytcoode@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220310161518.534544-1-ytcoode@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0040.namprd14.prod.outlook.com
 (2603:10b6:300:12b::26) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5ac5eb2-fdaa-48a0-b3b6-08da02b27b3d
X-MS-TrafficTypeDiagnostic: BYAPR15MB3286:EE_
X-Microsoft-Antispam-PRVS: <BYAPR15MB328626F6B611960914061660D30B9@BYAPR15MB3286.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JBnfz9wXcbfy9s77Hxywmdl+xlx3SnpevGABZMJt5sZB+bQtx6Q3AERfTWbUfwNF2q3aaxdP2tnfkbm/omXV37J/9s9ljsaPu9ChcHN6NaImzk0SFMv/xtFJF4mikount6JybNQeVkz51D2vwUmrOhKxZMh5ArIbGQoghdWoZ611xHaCnW38YVLB2cHBT6yqGb8Z/WvdgdodCvSlE4v/EdrrzuLmny4fao+wjZTbakuXeUrh3NEXHfwOiHihWSQXK5rFytsTvvJUHuIxx+mVNs/eOmaqCGg9UCDyZGotIo/OkoBWUqL3GSe3cK+yimudD1urkiyqvDpoxShIoYMiOGdx+JWVVlzwvHq8xF1WxdL2YQYbCkSsFiyUmVsU+lxbNytLYIu8+CDMGcMFjXBlxaXuGCXzWi6y7h8RKsg4rnqV9D974vzEgNvmuAxuYhQy+JibmA+2CVWJWI6nTPPC062ftityNXgPY7+N0cMIeqFiVzE8H+x1P2tV8b9IXgQ95koUBb8dnRKwxZESG6pUTd8Q08bRiMU/rCpsI4zagZ+LS3i/XvRDx5q5z8bxV5scOKtktRAv9RYoUOvCKToizNZ57nt4ZWS2HQvLc1zdA9yJ0jroK5s5vSgjeK0TGjRik/djhBfEBz8W7ZaP+WI42L2BQOzDUtNzBJOkeT9ojtB/iHrj4xaB3O57Y7ES8JfzXTceW0uVQzE21NYok7Vo1tramByIsXUbszbxX3o6neQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66476007)(6506007)(8676002)(4326008)(52116002)(53546011)(5660300002)(6486002)(66556008)(110136005)(38100700002)(508600001)(558084003)(6666004)(2906002)(36756003)(8936002)(31686004)(54906003)(2616005)(6512007)(186003)(86362001)(316002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTZ0c3g2aUpXcEFPUit6MUNFTWY2YU43ZzQzQ2Y1aXhnUFp3RGs4NVJXbXdK?=
 =?utf-8?B?WkMzSTdXMWRSR3Ezbi95NmJjeXV5VWhyMGZUQ3pBeFgrZ1Zjczlab1Z2MXc3?=
 =?utf-8?B?c3BCY3FtUFc1ZmtXTUVlRmFINUs3bElnakMvSnM2OXVkRHZWLy9lbERWbUdT?=
 =?utf-8?B?d0E3VkpxRGFxSHd0aHZ0SElZTktNd1BncTdkWU14NlFOc0VNS2JuYTBMWGxs?=
 =?utf-8?B?ZGZZMVVPVHZoNnFDcDN5Wk1GcDFmNzhRbHFSUG5KL3cxZ2IxZ0FWeitUOUFi?=
 =?utf-8?B?TDNjaVlVcHFRL0xsTENCNmNoNHlHRklDakpEMVR2bjY3TkdpajJoZzBkZmxx?=
 =?utf-8?B?bTBsQ2IrSG1MckpGTXZDMExYVFMrR1h0U2d5dWxKSWhIRlhSK3MraThNVy9V?=
 =?utf-8?B?QVMyeFNQcGpTWWk5TnVsOFlNN0pTWW1OQWx6encwOHhBOGxwN3NhcEFWRVY5?=
 =?utf-8?B?VlVxUlhGS2gzdG1oVWFxaThaZmRMbzlmWTM2OExEbE50S3BrZGF6bzhGWEdX?=
 =?utf-8?B?cEI4VXB4NUczN2VKSktSWEJhYVJKK3BxMHFjMVpYMDdKTjJkNHozZHJCSkFv?=
 =?utf-8?B?cmQ2Mnk3WGc4R3JaZksvUjcxcFZsUndkZW1hdGNERVE2a2NrU0ZRY2JZOFd5?=
 =?utf-8?B?RklUWWpNWEoyYzJBcHoxRjdxdUk5Wis2amFReXR0Y05YeTdsM2NtWU1GY0hK?=
 =?utf-8?B?YjEyQ0xzejhlNlNnNllyeWdPK2I0NjMrWWxEdjdrRy9zMUFRYnVNU1Mxbnha?=
 =?utf-8?B?c0F5OWlkY0FNRG14WGtDclNEZFhVQk9telhvak5kK3I2OFhab2xWMHNwMDRO?=
 =?utf-8?B?UDhEcmdOMTFuNGJJTU5IVjJyRFltYXdKV0pnTURLV0YvUG1Ha1JyNUFYL05H?=
 =?utf-8?B?WEtMdWNYa1FsSkJ2QmZ3Uk9Kc081UVBSM0RISkE0VlpZMFEzZ0JJTWpyQW4w?=
 =?utf-8?B?d3IxSTY4eWJNU1BvWDE4ZHk0WWYxWU5lVmVodVVmaG5HUW04bDhLTnp0RVd0?=
 =?utf-8?B?Q0lLR3g0ZFU2K2YxRHZaZjdhcTZQMGpGd3U4K1Q2QWxieWwzbGxHaUh2cUtw?=
 =?utf-8?B?TmJZNFBzRWU5bVd6dVhpZks2cDd4WG4yNmpXRENrTFFVejdRRzR2ZFpBa0lM?=
 =?utf-8?B?ZzdHcFBJQ3JWaHQzc2s3QjVPUmRHY1p2eVZDV0hKQXNIR2VLbHZSaFZRZGdE?=
 =?utf-8?B?Tk03MHYzUmROT0twTGV2VnR6UFB1cXQySHp2d25tTnI0OHJHOWtmUjVsUTBq?=
 =?utf-8?B?QW1sK01wRlhZai9tOG02WUNOSzNEakFHdWQ5NTEvRy9VMTlJWUJOeDVSZG12?=
 =?utf-8?B?cWl5Skk0Q0hiVkMzRGJpSGs0RmxlL2hTdzNHbmFjM0wzMnpPOWdGZkFNeHVn?=
 =?utf-8?B?MWRWU2ZXSDJ1M2NhSU94OXlDbVhYdGhxQzJaeFM0ZWt6K1NnK3d5cDV0Ly9K?=
 =?utf-8?B?bFNUQVR1MXV0cTRRcmt3RG5sZytDcTJsbk9CZnJ6MW1KNHJ5dnUveHJVZE9T?=
 =?utf-8?B?c0pUWno4ZHZpUXNQVG5YdVl3dVFETHlOMlVsZFpwTXkwSGExWHJTL3BzWEs4?=
 =?utf-8?B?anBaZW9NL0p2cW9RMU41Q1RjVXhxUm5LNVVNSnc0REtTN0NYWWg2elJhUmRT?=
 =?utf-8?B?L0tkTEV5M0Y3MkkxSkRtQU1KaUtaNTFoMWFwNHIzMjUyWHNSRmdSSm53b1dZ?=
 =?utf-8?B?cGRqbTJUcGhZOHNlTFdEYk5iaHlxSm9VeWR1OGFoVG5HSHhTYVhWNHM0RUR5?=
 =?utf-8?B?YWk2UzUvRlNUc0hVd0g2ZUFoaU5kY3VxbHU5T0JrcEpIVzRwVG0zdmNsSVlH?=
 =?utf-8?B?VXF4VFg3VVNDL0llcFQ0aS9NeU1kMWtucWduc0xEUDdFNlRTNU1QTnpmL3pE?=
 =?utf-8?B?WHhIYlVJaHFKRzlrQ1RSN3B6YU45bUlFeEdNeHhCUm1XaHFDRDMybm5YZjla?=
 =?utf-8?B?OEZwRkVGNlB4L2wvNm13amkwVEdVenBKbUtQY1VjNUJLQkpUUXVELy9FaGVU?=
 =?utf-8?B?aG5xWVBleUpieGRKekphbTJKcEpjNjZzU1RhQUkvWlVQamNsbHRHZkdSSGpB?=
 =?utf-8?B?R1hmL0FRWVF1TXVQNTRWSUtyR0srWTZGL0VTRkJoaCtrb2Z4RmRHWEhTUGJk?=
 =?utf-8?Q?t7ILwaEWB/+Rp0UjXz4bfhxcr?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ac5eb2-fdaa-48a0-b3b6-08da02b27b3d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 16:24:42.3140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iwy9LbBkRa82t+Cd1b0YirejbG1htJPLL20m7tLeOWUR2JqFAZQ2L6gYtZK4I4Nn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3286
X-Proofpoint-GUID: 4jf4Ijb8Xbzp8uxeTriAstKjO7MIQSLx
X-Proofpoint-ORIG-GUID: 4jf4Ijb8Xbzp8uxeTriAstKjO7MIQSLx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_06,2022-03-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/22 8:15 AM, Yuntao Wang wrote:
> Use offsetofend() instead of offsetof() + sizeof() to simplify
> MIN_BPF_LINEINFO_SIZE macro definition.
> 
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
