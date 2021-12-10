Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72237470A8D
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343667AbhLJTmo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:42:44 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:26882 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343663AbhLJTmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:42:40 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAJD7o3017991;
        Fri, 10 Dec 2021 11:38:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=k9QG0qiD3tleD+mXRxE7F/fZL8UIpMt6hy0UpBwjXdc=;
 b=qI73HxfCbWGQAi+SXkr9ImIL0lgvKaqvlFkxBEzygHkJvUfh6vtFgFCAhqiUIvWUUmY4
 1M6ssXF7nGRJDufzPzdhGLgzrF45Qyo8UYhlButnzxuQ7Muok8qX+v03kaLU3E7fW+c4
 GFUm32hZxs96MDRgK716Df79OWoZR/NK0sY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3cvcus8860-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 10 Dec 2021 11:38:49 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 11:38:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QR0kw0VhlkQXWlvXGYQaGiGe0S2N7t0kyhTgsaxBnR8fNYcadKm3Tb7M7NsO9ta7xD6OUz0wPJx3EMmFbXPx3zc78p9yn1htMUlBPNV5DLy33gJ+dptw/HS5Ar78CGslhqamdcL9eSpQ91+BBEHMtqARZ3mYNNbVE56xiBBeP6PRqByVjMf9VVTxQmxWgmxlZFs5NkmA8ZyydFsdS4HZJs/tCzLBDVpOMKep+SwqH8mbUdeir6bc2Ih0WbhV3KmOGdnGqVUfvQeLch2x1oifBoQEa4giMHkiMKhbPQ0DclYbeaBeH/EnQJVKSR+HNHObPItdBvS4DDgyBPBzNHMCMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k9QG0qiD3tleD+mXRxE7F/fZL8UIpMt6hy0UpBwjXdc=;
 b=ZGm4BE9O0xx8b7XnQREthL5vI1tFBPO5VMJ7HtLf1sPnzrKnQrBZXmCs4CV2RubGSCyng31oFnhTLyt2u21qEBy+8Q1aoxlbM+V43s+3qKZNhz0BDyJDb/5V47XCGpFi+N7e+YukoMWccXPgWlwxk3G6GtLIDy53oPxMu0nzGcrhnxusFl81ZFhIivGkWerV2nlG85EQSdp723tWselOWqJ0PLHuCFcsjCVmAYoxIGfnQt3mkKLj5Sfa7dvoWWq9w1yCGcQU5GDnuYqnPn/x7pcz7kTPRY+JMluLvVlF0CzXWJw2gaXZLAJs8YGJx5RvomQSgdYU5+e1xOTrWtzGPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4465.namprd15.prod.outlook.com (2603:10b6:806:194::23)
 by SA1PR15MB4611.namprd15.prod.outlook.com (2603:10b6:806:19e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Fri, 10 Dec
 2021 19:38:47 +0000
Received: from SA1PR15MB4465.namprd15.prod.outlook.com
 ([fe80::853:8eb0:5412:13b]) by SA1PR15MB4465.namprd15.prod.outlook.com
 ([fe80::853:8eb0:5412:13b%9]) with mapi id 15.20.4778.014; Fri, 10 Dec 2021
 19:38:47 +0000
Message-ID: <8f5bb6e3-0ab4-c4a9-56a2-affe61223021@fb.com>
Date:   Fri, 10 Dec 2021 11:38:43 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH net-next] net: Enable neighbor sysctls that is save for
 userns root
Content-Language: en-US
To:     <cgel.zte@gmail.com>, <davem@davemloft.net>
CC:     <kuba@kernel.org>, <ebiederm@xmission.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, xu xin <xu.xin16@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20211208085844.405570-1-xu.xin16@zte.com.cn>
From:   Joanne Koong <joannekoong@fb.com>
In-Reply-To: <20211208085844.405570-1-xu.xin16@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0338.namprd04.prod.outlook.com
 (2603:10b6:303:8a::13) To SA1PR15MB4465.namprd15.prod.outlook.com
 (2603:10b6:806:194::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1cd2ca2-b273-473d-7592-08d9bc14aede
X-MS-TrafficTypeDiagnostic: SA1PR15MB4611:EE_
X-Microsoft-Antispam-PRVS: <SA1PR15MB4611DDE5CE4F0A1191196039D2719@SA1PR15MB4611.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vmRNBygif8GOOpExbXgURWQs/MP5wylAjeQvPy9dl7DpOew3/FlIGf2w0QXkPg7bIFCzpRVlYcL7VBqzFj286BVleFkLquLCl+tC8oxjPMZ4Nq0HPzadUBf1Nwsw2HP9eW5zzVtyJkdWaqsUQ/+CC+AHsR2/OcUR4M2Cm5wpc7M4PbNGfzqkehqeB+bwzRWEhc9QONKyHfqGuFrMTc67Ml/bucA5Nd5+qdBZB0qCBPWw5YoT+Oq+yvHRtfaUbUmLZL7k71ZwOKVf7tp128NuzcEDyQ0MujGzNVz9KWR5YxESLXyeS5chv3OYtlOTnHniVH/YupWhIrlx0CuHG6+S0OWNbqlGpqkTaGyYHeCnYUfH3TGPLrTK+O10R0W0GnlBJxCJDaOf99MW4XKikuoa2DtgE+kbJGKxoUqDw5UfSpu2Fgb1zngRy3aziL+SPX0J7ZupyRFltwALWjm5/+yjiqw6I6y4XO90gIgYnMC+4Tc95/tJtimw6O+LuEa/pXVw/0HBxKlSyjxEvIIuAmWB4nkHfxgEMhdQyRG3D7l/gVao4esMbgdQrkaEB99T50qOEmDq+ulf5z7nhx/DKCEtQk7/m9KB2ZIPhwhdUYAtLFcvsvbcAnYgUsXUVtl5r1CcOaCGVRoUqHfq14ZM/z3NBDgxnuDVIhRFLrVPS+1s8YfowgGr3hCuxz3y/eebdB1+7cfEtorMCq9pCx3MkOUwgGlqD1daPo0iKwOUtnAYogg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4465.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(186003)(66476007)(38100700002)(54906003)(66556008)(2906002)(6486002)(316002)(6512007)(31696002)(6506007)(53546011)(31686004)(2616005)(8676002)(508600001)(4326008)(86362001)(8936002)(83380400001)(36756003)(5660300002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODhZUE1CQWoyTzFQdnE5dzd4MDlUS3ZXeXpMZ1lTMXQrdFVOTXpjY0VEMVUy?=
 =?utf-8?B?VlNDY0tjL3VES00rdWJqZFQ3RjlJdmNidlkxOW5iaHpzQnhSekhOTVgvbm4r?=
 =?utf-8?B?R1BGYm9KOTBZdi9tZkh5R1hacEZTc0swcVBiWDhrZ1RmejB1cVhWaFFTOWtF?=
 =?utf-8?B?WHRIb1VXSzJyOGZjNUlNbnAwN3Y5UThGQlovTEZmMnFXbldOeUhTMy82QVF2?=
 =?utf-8?B?YmNSNkhyQ2JMbUNrblJkOGdPc0lTYmFEdXppcXdHeEFUMjBtQ1gvbzAzeFFa?=
 =?utf-8?B?aEZ3blNoS2xiVzcwUUE1Q1I3a2h5bXFNWmxhLzljb2NYd1MrNXhsSi90UGNq?=
 =?utf-8?B?b2ZRMUxmZS81S21iSm15c1F6ZTE1TTVHdVo0MDZpSFM0cXRSQStyZEppb3hh?=
 =?utf-8?B?cWxYYzh5VjVaVkpXajNBaTA3UmwvLzVUT2dSdWlDT2hpOWJ1SjgwMmxDcG9T?=
 =?utf-8?B?aUE0QXV5aWVqa1d3b1pINlJoN3M1OEV2RGJIRGljQkFrUVFuRGcwQmRUTmJx?=
 =?utf-8?B?UlRab3FmTERlQ285OHAvMWo0VGZGckwwQncvc3o4NG56Q1Q0UFRNSkd2d0p1?=
 =?utf-8?B?cG5leExkYWFqVzdCZDlyQmpKcU5yNXo2L09heVR1YkdTYk8yRHU3T2FybTZN?=
 =?utf-8?B?RHlYMkR6UGszYzFsZzk4VG9kRFREaDlmajVibHFaSTgwSC9ZYktjbFArajlL?=
 =?utf-8?B?OTBHcXVSNHJhckhrdkVjNEtOVXRodEJmM291U29IU2RDMEZVS2pCbVo2eWpF?=
 =?utf-8?B?Tnp6T1llZ2JFWnZMOU9oYzhQU0pMd2VIdEJmRWF0Q2VhWFpOeXFpSHV3YWRO?=
 =?utf-8?B?K3YvMWFCUllWSzV2MDlzQ1U5dDg4YjhwV1pVWjZncmxWZnFLdE9ud09Oci82?=
 =?utf-8?B?Qm9SdEJFcnVmenJUdkZkcGI0YzRLNVZ0ZnZHandtWDh4VEloaThKbUh1TXc1?=
 =?utf-8?B?YzIxSHlJL2E1a28vTm5ITzhQZXZoQm9GZzlReU8wR1d4UFUwMzQxQURjMUsr?=
 =?utf-8?B?MXpGalBkSksxNVdTejRXTU0zOU1ia0JBVGFFM2d2V0liRDZDeVlxbjlhUXR4?=
 =?utf-8?B?MHNsZkpnUFNBZlhtTkNHZDlPU3JHYzF6Q0wxaUFhSW41OXl4S3NXZzk0U0FK?=
 =?utf-8?B?bitybE9VT0E0Ti9CY2ZNUG8wSlJFQm80eVdnUXdOcHJKcU9BeGFNdVNzRHc4?=
 =?utf-8?B?Tlk0UHlobHlHdGY2RHd6QVJzbFFvNTBNeGRzT3RBbk5NL3l3VlFXYjNnM1kw?=
 =?utf-8?B?UEJPR1VTNU1VOG10R1dueTNDTXJPZXBueGtrcCthcDBlQTA0bVIyZ3hEQXdx?=
 =?utf-8?B?QnNrbmNZQThkUDJ2bXgva0xKYnZyelBrK3kxbnUxRXlCQjY3NDc5bGpRbEky?=
 =?utf-8?B?TUEwb21wVE5xZXQ1UjNxZHZNeUxDZTBCM0JOMWFiREhqZEhodVFieHUwTEhk?=
 =?utf-8?B?aDcxSUUwU3lUbC9sbnZUR1JTTS9wK3VIdDRVQmc3dUFjbWlaSFJmTVRNaVVv?=
 =?utf-8?B?L205clQrK3V1SjF5aVZXa05BNmZlVzFWRmRFYnlVSm9VVk95VVYya2FyNnZJ?=
 =?utf-8?B?ZHRBay9FcTVHSWpTZGt4RU5iMXdXVjMrTXovbE81VnZJa3pScUtEdEVHcDdI?=
 =?utf-8?B?Z2ViZEpFSWV4a2pwdG5LZ3F0dFJ3aTYyRnFCNjQ5cDRTQldBZ2FyM1dxY3lN?=
 =?utf-8?B?UnZ5SDN2NWxWVFhxTlNJSW11dUIrNDNyTGNHTWhXa3lyZUY1MGV5ZzNVK1JO?=
 =?utf-8?B?c3YxSHJGN0N3RE5MbHFUSHNaWVdvWVh6a2pLakNBYXBhOHQrN1ZoS0s2RkJj?=
 =?utf-8?B?QnE2c0ptSTNxTERtcUxIOERRK1F1Z1UxdldOL1Bmdy8zYXJoV1VFMjM5R2o4?=
 =?utf-8?B?SGlqWHJIZzNZd1hQUDJpZEszSWVQa09BU3RGNmZ5MW51TWpIeFp5MEdoTmoz?=
 =?utf-8?B?b0kyQjliMjViNkNQZ2YyVVN4WHhlMVlIZE1EckVwTmRmRmRVWmNiOUZ6Rk9T?=
 =?utf-8?B?U2krb0FyVStHV1pudWR2aTJLQXdUYk1CNEpCS3RTMzR5aEI2SG9NM2xiMExq?=
 =?utf-8?B?R1h6TWtBbjM1ckNsU1pKNWQyeGlXbFNuN1B1Tk5FZjQwcytiQlJDWkk4UXJi?=
 =?utf-8?B?U3NldGJPWmR1TGtNODlhVmdkWERzc1JaNjVHbkVucjVESld3MmpFbit2QlI3?=
 =?utf-8?Q?um+9+pvPX7Qq/VLiufQGQzy7L1Oc8Qjxm8SbANZ9OjE2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1cd2ca2-b273-473d-7592-08d9bc14aede
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4465.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 19:38:47.0958
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2r7jwM2W5mDHKhkRcnuo8FnndjmLvMCa8mMx6hBQEblo7nHAcg/sCxix6/jYRd2v5GYQ+ayYEUI4B1VNVsj2cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4611
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: OCLmTz_EQ3OVL9Zc3aVwnhs26rbmc42Q
X-Proofpoint-ORIG-GUID: OCLmTz_EQ3OVL9Zc3aVwnhs26rbmc42Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_07,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 adultscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100107
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 12:58 AM, cgel.zte@gmail.com wrote:

> From: xu xin <xu.xin16@zte.com.cn>
>
> Inside netns owned by non-init userns, sysctls about ARP/neighbor is
> currently not visible and configurable.
>
> For the attributes these sysctls correspond to, any modifications make
> effects on the performance of networking(ARP, especilly) only in the
> scope of netns, which does not affect other netns.
>
> Actually, some tools via netlink can modify these attribute. iproute2 is
> an example. see as follows:
>
> $ unshare -ur -n
> $ cat /proc/sys/net/ipv4/neigh/lo/retrans_time
> cat: can't open '/proc/sys/net/ipv4/neigh/lo/retrans_time': No such file
> or directory
> $ ip ntable show dev lo
> inet arp_cache
>      dev lo
>      refcnt 1 reachable 19494 base_reachable 30000 retrans 1000
>      gc_stale 60000 delay_probe 5000 queue 101
>      app_probes 0 ucast_probes 3 mcast_probes 3
>      anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 1000
>
> inet6 ndisc_cache
>      dev lo
>      refcnt 1 reachable 42394 base_reachable 30000 retrans 1000
>      gc_stale 60000 delay_probe 5000 queue 101
>      app_probes 0 ucast_probes 3 mcast_probes 3
>      anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 0
> $ ip ntable change name arp_cache dev <if> retrans 2000
> inet arp_cache
>      dev lo
>      refcnt 1 reachable 22917 base_reachable 30000 retrans 2000
>      gc_stale 60000 delay_probe 5000 queue 101
>      app_probes 0 ucast_probes 3 mcast_probes 3
>      anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 1000
>
> inet6 ndisc_cache
>      dev lo
>      refcnt 1 reachable 35524 base_reachable 30000 retrans 1000
>      gc_stale 60000 delay_probe 5000 queue 101
>      app_probes 0 ucast_probes 3 mcast_probes 3
>      anycast_delay 1000 proxy_delay 800 proxy_queue 64 locktime 0
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
This LGTM. The neighbour sysctls are registered to the net namespace
associated with the neigh_parms. Any changes made to a net namespace
will be locally scoped to that net namespace (changes won't affect any other
net namespace).

There is also no possibility of a non-privileged user namespace messing 
up the
net namespace sysctls it shares with its parent user namespace. When a 
new user
namespace is created without unsharing the network namespace (eg calling
clone()  with CLONE_NEWUSER), the new user namespace shares its
parent's network namespace. Write access is protected by the mode set
in the sysctl ctl_table (and enforced by procfs). Here in the case of 
the neighbour
sysctls, 0644 is set for every sysctl; only the user owner has write access.


Acked-by: Joanne Koong <joannekoong@fb.com>
>   net/core/neighbour.c | 4 ----
>   1 file changed, 4 deletions(-)
>
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 0cdd4d9ad942..44d90cc341ea 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -3771,10 +3771,6 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
>   			neigh_proc_base_reachable_time;
>   	}
>   
> -	/* Don't export sysctls to unprivileged users */
> -	if (neigh_parms_net(p)->user_ns != &init_user_ns)
> -		t->neigh_vars[0].procname = NULL;
> -
>   	switch (neigh_parms_family(p)) {
>   	case AF_INET:
>   	      p_name = "ipv4";
