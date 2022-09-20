Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C07B5BD8DB
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 02:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiITAmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 20:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiITAm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 20:42:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A7752819;
        Mon, 19 Sep 2022 17:42:21 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 28JMsstE012842;
        Mon, 19 Sep 2022 17:42:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=olRSHUSkMARB2EPJ60joK5kVkw59ec6sGOdNuYJo2Eg=;
 b=mMCbJsmAADY/oKPml1ENwtKmgxPFUTFKp9GQwVRJMyVmytMIgOQC8grG5nB+RPf/H7Jt
 tP1WZvrw+yIiBL85rlhP/IgJe9+Px2+6xrzbLu5c3q4rHUP9MJ2olBnWasyeG19zMmf2
 +Gpo+PSSB2+h0R3eRYclHSv/5FNLK+lGbJQ= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by m0089730.ppops.net (PPS) with ESMTPS id 3jpm35esph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Sep 2022 17:42:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i76Sbwe/0fYhnA6LAwk/MT2BmLZUPrhniL63p0kzWV0iq0UIB2kOrrf+g7Lq+H2EmKxAGfNicMYU2ENJlNIYDDNRwZdWZ6Y7vLlmsCBSegFIQUlFMEy39UeSCdiWRYnTBkZUv4W1/e6tZseOprc56UR9PaitsYh3Jcka/85ywnukYBalEtF3tY/gE3k8YhRfloLCeRfYwXHDz8MvhNvIYJttae+6BMvBHf5rAmD45ptCFerRxpqWWGjqzXcAYQM/69OKc4jyzbA+wbPBp47vJSknquvJv0r1P23fvqrAndsAAQMloX9mCfukk2zDTpJA4R0V3E+IL4n85wXRu2W/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olRSHUSkMARB2EPJ60joK5kVkw59ec6sGOdNuYJo2Eg=;
 b=BiD5HKM/R5w52v1sbhjPbWDCrde/DKZ5tP4UGsunen/iCdVTatIbXykBrtsNvA0oW6uAe+NCD5bEb7CAUWsmwtGRb6Y7H5o30EghaC72+v64VmaM4PFIzX05OQ7Z7dlzEdXXy9RXqJRodY4LFJ2j21fZM1x19eQ+S5qjkXGE2pHGhvAbMagwh6D5oGeQKWjdkvEuZ7MD65diF7PLSNfn8JklvEtAZHu0ICTFta81R23w3jRveZPwjlpPPpo8dWxc+5bQPqZUT2UDF8rmqH5xc8qIqs+79mMdlSCr27qiRpy3cnf+swhWJ/zBKrWvgn6IOutMweOPUBIfotYf6YLxzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN6PR15MB1108.namprd15.prod.outlook.com (2603:10b6:404:eb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.21; Tue, 20 Sep
 2022 00:42:16 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::cdbe:b85f:3620:2dff]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::cdbe:b85f:3620:2dff%4]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 00:42:16 +0000
Message-ID: <1f965bad-1116-371c-87e1-1250fd8c9603@fb.com>
Date:   Mon, 19 Sep 2022 17:42:12 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH] headers: Remove some left-over license text
Content-Language: en-US
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <2a15aba72497e78ff08c8b8a8bfe3cf5a3e6ee18.1662897019.git.christophe.jaillet@wanadoo.fr>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <2a15aba72497e78ff08c8b8a8bfe3cf5a3e6ee18.1662897019.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0036.namprd16.prod.outlook.com
 (2603:10b6:208:134::49) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BN6PR15MB1108:EE_
X-MS-Office365-Filtering-Correlation-Id: fc821f2a-b07c-458f-e8a6-08da9aa0f761
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mk0SUY0NBGCrPi0Y7yaks2NBWfvokXWsqoB0KqWux2zYwJGZudXl8BwpcTtZVrQn2tlbdHXD8RoxHl4rfHBuxrNgqslXCmXPH5NiEgtRE7Aj6a/JagrBCKxwZxWeoutv1nW5EgcD1T9jVg7Fyb1DbdeTx6SWefyLfNg8Jy63s34j807lwG2JeLi69KuDd7BCFREfWaFv0ZxFVn17PqxFvhCfqGfbYbK9uJLh+oS543GcyAiXA5XgpAmT9qGrgnDHhT5pV16Y3eMMqQC1NWcpN/q2da/XDnU4GSKd09QLsbnEqaon/8Z4Uk5F7xlSNoSXDpxVlSc4WPG8oxZtXWarTZA97BvUO29fMqo6IkBL2g6qzJ23bJLdlP3X8eTnK2/5n7iLWMX2lEUzE90hbjA6zYjY1uh06qlfT31mlyUwjsY7feHNSNTgz9+KWBFJjheUR0Ak4joVHUQb/NpM2kMPpPYWwlFJlKa7XAVYJGSYtD3fpoRL3eCy5Qak2j+Ri9U0Sqjy77mF906ycrpI5TVcyKjcF+Jx7AMqgcfKxQvC/IKa0IX7R5KKwUQbiDfVZPGGx5iEij9wu6/c2v+79HC/lhqSKsBS3wIEZ+Js/rZRhWluYxu4EhuyjhFacULyUrH8yp4eyi/FC7LlohENq8Mgw/jc+TGWbsgzXoaPguyXy64oYcpqjuJUp/jlUJ621g2IzoVbXbzLqOQJtMCcXBzXscVYs3CM2YpJLC5h8btuJBd7VACqxjc9L+A07h9muMAB8XSY8QrxeZV5jVH79vm4Fe393aDTK0+Ucq3aS1jLG7wvAAW1TkEBXQLqCRL0iDNW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(39860400002)(136003)(396003)(451199015)(31686004)(186003)(83380400001)(2616005)(2906002)(38100700002)(6486002)(316002)(31696002)(4326008)(110136005)(86362001)(6506007)(8936002)(53546011)(478600001)(6666004)(41300700001)(36756003)(6512007)(66556008)(66476007)(66946007)(8676002)(5660300002)(2004002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTBTRW5YUy9zYmsxSDJtUEtTaEhFZ0JWVDhuMzlBeHVlOHhJWlluRkhHM0o0?=
 =?utf-8?B?ZmVZeG84Y29jWGJndllPS2JJVXVoRUE0TnlQMGFCY1lNcWdjYXl4UkcxZlJU?=
 =?utf-8?B?dU9EbkFMYjFxdUcydm1UdTd3UE9rdXJiRDJNOXJ5ZnR0RDdaT2hSMXoyeUZM?=
 =?utf-8?B?VmdvbHNtejNUWlIydzF6SXJuL0JuZ0VYeVBWbFlYSkdrUU1tUEUrOXVQVHQ3?=
 =?utf-8?B?MitRRnIvUUdmVVZ4YzlHYkhVakFGdjRFbmlSZzNQTS9QcUhtak9ibVp3MHRy?=
 =?utf-8?B?WFdpaEZ6UXF4RDcrcVdhclArZVhEbHcxbHVWNE9keXdzcnI2czBKdnJZamNY?=
 =?utf-8?B?QWJDbnRRM21EN3lXOTIrL2M0M0FnU3V6djU0bWFJNDhPNU5NTUFSVGxZNUF2?=
 =?utf-8?B?K0o3b3BhZXBHZ2N5T1loOVZ1Yk8vUjE0WjVnWEk4ZmQ5U1k1cHM3Z0pUTzJ3?=
 =?utf-8?B?MTY0c3NvVWpiMEhFbUhlOU9GeXVSbStkNyt5MHVSV1NiaVJ4clhjUTZIdzVo?=
 =?utf-8?B?aG1wWFpUQkdPWFRVRzI0U2h2T2h0Tjk4U3lpSDZ4WjFrbTRJNkI1eTlvNnNi?=
 =?utf-8?B?Y2VMT2dhUlZVOXBRUzNtQUtrMVEydnpueHl4MkhSN2RvUmdZbytUK1hvY1M1?=
 =?utf-8?B?dnBhMWNwVTJTUUFkbThzYzIzWk4zZGdZY2tXVHY3T2tyalNEZ1FlZTI5aWsx?=
 =?utf-8?B?QktBcjNBK1NkQW10Vk9QQmFLbms0OWdnL0FTR0E1ZHY4Z3JlbjZhVDJ3dHhG?=
 =?utf-8?B?Qk8wMkRpZVRYNWQyVHd0MlYxbmhTeWJlOUVIbEU5cThsTlhPbHhlTGlYaGlu?=
 =?utf-8?B?cE1Pa3FTa1gwcG1jak12cDFDc3VCWk9pWWIwY3Fnd2l0U0dZUS9FaThKd05i?=
 =?utf-8?B?MmlndWlzN0VoTFBRYnVFK2pvTXJEV3dDUFdaV0lwSXdhVVFWaW5VdXpBem1q?=
 =?utf-8?B?NU40U0hpUXBBMjB2KzY4MG1HeWN0bFNjbzdTVHI5WWFLc1BOUTREV3Z2dkFQ?=
 =?utf-8?B?TVEyWnNTYlpZTm5RYTFWcU9Jdk1LdjB5eHpaRU10a1VsRWdxeCtmczhMN1Bp?=
 =?utf-8?B?Q3dqdUpJWEdRWWV5NkdjalBoQ3hPelpqeTRDak9kMUlQYk4zUzBHQXdtRzJv?=
 =?utf-8?B?SjJheGlCcHJMRkU1UU92SUFqZUNHMml1RDM0NmN4QTJwYWtTNjJLUDVBQklY?=
 =?utf-8?B?VlRPQjdhM1JmdWJIbVlRVDM5ZkxwUWR2SUdIVlpWZWM0SDBteEZoY2FBN09I?=
 =?utf-8?B?OW04UFEzUXp2UGxUVGpFZmphNzdmN0t5UHZ0bko5R0dUMXcrU2dCbGl6czFl?=
 =?utf-8?B?Zlk1QVBrRThyYUdEamkzN3FUdnVpejVJc0t1Tis0bzZxWFg0Y2FYVkthWjlr?=
 =?utf-8?B?czZPeEVOaXcwMnV4bWRvcEQ1akZHZGVGQVVwQjAzcFpTSlBqaktDcjM2YTdQ?=
 =?utf-8?B?UEFoTEJFSjZKTXJPdERSTTNaRHZzZkVqY0MxYzZnclhuc2sxRDY5OUFlZER0?=
 =?utf-8?B?VzRjQzZiVjEwWGdIQk93YWNTLzhZc01aYlk0d1ZlRktzRnRMdHNWSFdWUnFy?=
 =?utf-8?B?alEwaDVKQnNabjAxMFpJd3FUMGNFdTh3Z2R6aEE1dndzYzNQRFZNLzlBeTR2?=
 =?utf-8?B?MytvZ1phZU1GNXcvV1phU1BSQzBjZVN0dU1SRExLL0VwcUhrZmtZMUJobVdj?=
 =?utf-8?B?dVhaalQrL0F4WlMvcUhFY0gxSjE4S2lRUUI5cTh5MVVGWi9LbFRqdnNDOFhs?=
 =?utf-8?B?S2RZZjlmUlRWNDJGUFBCUEFGem9xTk9ybTFBK2V3dnRSK2RrNkd3Mmw0dndQ?=
 =?utf-8?B?YzRsZ3BETXgzcnlLcDBra0xFWGhsQWZVN0U3YnFWK1RPcVdEdjQvbVVuSkJN?=
 =?utf-8?B?T1FuL1ZZVjRnbTVwazgrcU9McVI5VVZkcDhrM3pTUHlhdzFIUW51dyswaEtE?=
 =?utf-8?B?dzdEN2xjYWtCaGtXMWgyempMOHQvb1o5bWlMcFNEbVFEYVR1QmFqYm53aks4?=
 =?utf-8?B?cUlqTmpMVHQzTHRLSlgwN0Z6MlB0WUlRZ3U4Yk9VRjJvQkY2R25DSWRGS2dh?=
 =?utf-8?B?blhyNzI0K2lva0tHdmFicDgvUXRZQlB1UXl3WFJoditLN2ZOY3FWb2NWbldY?=
 =?utf-8?Q?5lMw0i818Yb3ddUr9v/dX0jvP?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc821f2a-b07c-458f-e8a6-08da9aa0f761
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 00:42:16.3742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lQlOun5tnYoTFEES55bLMyC4Y7RnHLZdYScyFUwXm9OI+zN+fCj/0BMrgqnfnnSc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1108
X-Proofpoint-ORIG-GUID: Viv5pNCuOpklzXcArMDkSIwvhIYU798g
X-Proofpoint-GUID: Viv5pNCuOpklzXcArMDkSIwvhIYU798g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-19_05,2022-09-16_01,2022-06-22_01
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/11/22 4:50 AM, Christophe JAILLET wrote:
> Remove some left-over from commit e2be04c7f995 ("License cleanup: add SPDX
> license identifier to uapi header files with a license")
> 
> When the SPDX-License-Identifier tag has been added, the corresponding
> license text has not been removed.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   include/uapi/linux/tc_act/tc_bpf.h        |  5 -----
>   include/uapi/linux/tc_act/tc_skbedit.h    | 13 -------------
>   include/uapi/linux/tc_act/tc_skbmod.h     |  7 +------
>   include/uapi/linux/tc_act/tc_tunnel_key.h |  5 -----
>   include/uapi/linux/tc_act/tc_vlan.h       |  5 -----
>   5 files changed, 1 insertion(+), 34 deletions(-)
> 
> diff --git a/include/uapi/linux/tc_act/tc_bpf.h b/include/uapi/linux/tc_act/tc_bpf.h
> index 653c4f94f76e..fe6c8f8f3e8c 100644
> --- a/include/uapi/linux/tc_act/tc_bpf.h
> +++ b/include/uapi/linux/tc_act/tc_bpf.h
> @@ -1,11 +1,6 @@
>   /* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
>   /*
>    * Copyright (c) 2015 Jiri Pirko <jiri@resnulli.us>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>    */
>   
>   #ifndef __LINUX_TC_BPF_H

Could you also update tools/include/uapi/linux/tc_act/tc_bpf.h?

> diff --git a/include/uapi/linux/tc_act/tc_skbedit.h b/include/uapi/linux/tc_act/tc_skbedit.h
> index 6cb6101208d0..64032513cc4c 100644
> --- a/include/uapi/linux/tc_act/tc_skbedit.h
> +++ b/include/uapi/linux/tc_act/tc_skbedit.h
> @@ -2,19 +2,6 @@
>   /*
>    * Copyright (c) 2008, Intel Corporation.
>    *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms and conditions of the GNU General Public License,
> - * version 2, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License along with
> - * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
> - * Place - Suite 330, Boston, MA 02111-1307 USA.
> - *
>    * Author: Alexander Duyck <alexander.h.duyck@intel.com>
>    */
>   
[...]
