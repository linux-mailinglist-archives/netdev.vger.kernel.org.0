Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BDD43CB39
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242307AbhJ0N5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:57:16 -0400
Received: from mail-mw2nam10on2080.outbound.protection.outlook.com ([40.107.94.80]:23553
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242303AbhJ0N5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:57:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ux1wlic/3R8p4r5f1cbVSnJOtRWTJPlHDzUcdYc+qp+EAH9GBMslcNKmP29u+oa9nFXidZIOITQEAtOxIikF1uVIFzRgvF1qOOW3OgWMsAZjwuM6H1ekb0sPGX/UqohcxNNOSfdQnXBJWeMF9JiWlcVoeTj9P50qsV8iqbFjnjRRr2yh675CmZzg2J85twR6SAKnSyC64BAZaBIa46+KU9DzGMpWct6X74D51VpZHf7Xip3ZSWu6q5IiUykA3a1U1szRe9zoibpoM0o0gVin9U1h0qe2yfUaIplBPTOr5uAERV3ZMaIUvKNkiN5PnvhZwFn6FDr9GiEB7gcTlx4C4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTiCBd+t8EqWqIv8l2waGzoG4baGX3YkWVnxOmoGZcA=;
 b=Fd46lW72qs/bUcsYGQzRYfiQecCBaStUgb07gdnU1gqL83jqLH5uD4J/XgoiuB7nraPBMywyzC0bKB7TrUP21bPhkEOZUcUJ1EswxVT8EY3IleKTGmmw69ryVOjF0CGwFr9aMxK82wj9mQklwTQ9Gnh84s5lpXaED+hsWxiqzTEba7LWPPsx1kcQAOgWDQv7Dqv7Gc8TOw++1cZv+CJiY+JxaMxTlaGwz80wVEcsEHCJxmRRFaESPOlNKUP7ReJlBsJgdeZ3PbCJon/MEb7/NmdSFE4kSeOT3ETFZkMxSiNLIMFh0EFo8oZZJKxtRn/cN6JgQyQRnJfpdio/MyXZog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTiCBd+t8EqWqIv8l2waGzoG4baGX3YkWVnxOmoGZcA=;
 b=knUtXr6C17kyEMKfzcrboga0WmRPMZxZQGdPu4L3lcVHEVx7qmP49dDvdLRmVGCrLoS0QXkKM7yB9FcQuB35nicqrI21L8CP495W7KBXDGvWgNxnp8XPaZrCy5d4UiY04s/N2o6BFWT+4TNOJgid6CtzAdNLQz83pzKYbT1Qp/aCrxe++8R+gPOOsTURjZpd7rPYw3jOISt6cS3+jRFFMEQ4qaxV1ZHoArNiNUFofU7U89DVP+h6yXqiO4FDzUOBOr/IsW5hV9s2L0k/K+QNA7i+sxNbnwRxreAgyOfG8ee3javi6O20nlret59ZC1e900PpWubEmxy201L5JqwREQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5133.namprd12.prod.outlook.com (2603:10b6:5:390::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 13:54:47 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::513c:d3d8:9c43:2cea%8]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 13:54:47 +0000
Message-ID: <a9b7d8d2-da03-42f0-bd16-3446cdcaecc8@nvidia.com>
Date:   Wed, 27 Oct 2021 16:54:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net] net: bridge: fix uninitialized variables when
 BRIDGE_CFM is disabled
Content-Language: en-US
To:     Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20211027134926.1412459-1-ivecera@redhat.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211027134926.1412459-1-ivecera@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P189CA0010.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:31f::9) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
Received: from [10.21.241.50] (213.179.129.39) by AS8P189CA0010.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:31f::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Wed, 27 Oct 2021 13:54:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bbd3070-1f92-4999-eced-08d9995156bc
X-MS-TrafficTypeDiagnostic: DM4PR12MB5133:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5133CA2BB31824332B404F72DF859@DM4PR12MB5133.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WyLUZBDyFw6QGODGx0tDxeCdOmvi+j47ftHKQiBGLfammd+qW6ftSQOG9AiiSiWdqBGdLvgnOS/6qJ4RUhDUP41G7Ho4+vqvGd58iTOqRAn9tW5So+yV5ptnSad3ghPnsFbKdXcZh38+JI5k41aj6fLnuokjCP/Mzpw5sV/5kFByQ+naj4HnwONKefHH9M3gijK8oXHWgzkDAhsEvKZM5sthtvqQ4pbRjtYC0fsVQpupn0j5YxKwfA10tqifKQdFJfsawgtC44QCHNzYBvQIaSEuSdG08FGkXI+dXyJzCPuZYcLuD1CFVQjm4D0//w2Bq8TrQE22aesY5gi+rwZhLL0OBkRH6Eq7sSgqswZM0G7qVFEtIvjxirL6mslYNbY5aHjpXmHc3vacQKysKePMreRbFzL2fVgtwcWYZbipWY5k7n2iva85UlYvyQKjUj9x55oWvyVyb8S33HU1QonjP8x6WDZTAo69z3mZoaBFJG/vvMycVz+68cGS+99EvZlHkUHHfheceF/lTtUg9MkK5wY1Yenlsf8ZF5wjxKAk9IcrCpPGB8ZKgBrxwWxqf75r1T30XWjyc07QEGgdktgr2+0lwNiVxPVi1a7h66vJls94WGVJ//MFy8LtQz4iApt8PYUWazc0sLaHJrgyY0pF1pIZEpnvUTEamz3MunCqzjp8Y209riczemMjH/xTnfE+KcPAibW7sPDUH44CKeVeKhGfMDByskDoubRDEI7olYahrCikRrEoE7KNqhQU3YWd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(2616005)(316002)(8676002)(956004)(66556008)(8936002)(53546011)(66946007)(86362001)(16576012)(83380400001)(54906003)(6486002)(26005)(5660300002)(66476007)(508600001)(4326008)(31686004)(36756003)(186003)(6666004)(2906002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnFGT2xuUEVHSGZSTkYvcWo5c1FFMTR4QVBtdHVKQUZCYlJZRzV2TUJ6WEI5?=
 =?utf-8?B?T2NZcnE2M3JFTXdqc0lqREZnMWphQkY4ZUlFb1cvNDFRWUFHU3FvcjJPK01C?=
 =?utf-8?B?STBXalpBdlZUeFQ5c20vR0x5b25jS0w2QlhSRFN2b3NwYmZld2RUci9ZbzRM?=
 =?utf-8?B?bjZ1ZUNuV2tQaURaSVhZOUdwR2JNMWN1Mit4WW5KVGtsMnVOYXhFenNCRlk5?=
 =?utf-8?B?QWViTEU4MWVtTGpuR1l3OVo4elVoNDY1blFBL0NRNGpwVEJBNklRNTVHTHox?=
 =?utf-8?B?T2luMWxqcy9WdlRJNWtOa1hOU09VRFRvMmZCUE05MlNWRWsvTjBjbWpUKzhC?=
 =?utf-8?B?T3dnNEwyWnlpVFcrdVNuWTY4aWRiV3g3UG5oQkhka1dCQWVBYmJYZ3pwMk4v?=
 =?utf-8?B?MWdUSCt3YWNyQnp2R0N4dkkyRjMzODFTdjdkTEF3Skkxb2p3bGZLTDBYZmVP?=
 =?utf-8?B?cEJMdmE3dEtCQmlWUVJRdzI4OThveXR5bzdZZVVDS0FlZXBsbDRMTVFoRjdY?=
 =?utf-8?B?TDg2cUxhSjFFa3ZabEpDR3lwOWwraFlyTWh2OGFqOVNuSHRFcU43d3I3YVlx?=
 =?utf-8?B?OS9BcmlUSWQ4NTFiRmkxNDZET1dyd3hWdlY5QkFtc3pTMXY4VExZUUdVcUY0?=
 =?utf-8?B?NXRXekRqRngxYzZEVFVvR1k2czRIREk5Q0o4bFUzTTJmc1pueElsVmFLNHEx?=
 =?utf-8?B?WjVob0dYUlFoWk5GSm1Jdm1Ibk9CUnJPUmdwZnpSNWRkSDcxZTlmeklpd1JF?=
 =?utf-8?B?cnFWbDJKVWtMOTV2UFRoSVlNS0hnLzdmemFIRzRSVHNlMmw2QjZzdk1OY09n?=
 =?utf-8?B?M25HaHpqRDJnaDJhTTBzb0lwYTJaclByTzh0T3pvOCt5TnBZbDRWRE1Qdndo?=
 =?utf-8?B?TlBXdDlQQmZvdGozTmtXWEdRd0cwYld4ckNDdGk4a1N3M09pcmk2b0hCT1dn?=
 =?utf-8?B?aE5VRGpMazBYRWpBUVMvZytsUUhKVWZNcGFlVVhHek02VWkvTGEzZlNPWUtV?=
 =?utf-8?B?bmgrMW52UUJnV2pKMjYrSDNiOWt3ZnhUdjBoQUhaQWNFczNqTklsVzJtUlYy?=
 =?utf-8?B?RGxQN3U0NWUxVEdkRXI3bHBkQUNQMDZZNUtQZ1hxeERtMGZTd21jU0JPcTZK?=
 =?utf-8?B?V3lhL3hMQ2JYRVZxdkFuT3JjTkdnQ0twbzJaNFpIUUpZc0NrUVdyNlkvZXE1?=
 =?utf-8?B?eUxzYXNLNTRibUxkZnFIT0ZiNG9FeXRSbW5vRmgrR0xPWTBOUmZ1Y25mMHJU?=
 =?utf-8?B?OFpmcmpNMENrOHJ0UGptZDV6Ykp1c2JaSGdueUw5TjNhaWV2R1Y3SzV6ZnRu?=
 =?utf-8?B?NTZPQ1dxRVI3dVV2RXk3ZU1tM0tiMGdtZEltdmRiKzNVWk9XTk9DaDBxMkpk?=
 =?utf-8?B?czdXTGVXV3RKNGd1R1BhejFnZnBkcEJaWUpzQVVUV3MvQXFhYWFQUDJjRzJa?=
 =?utf-8?B?TVEzMzJ5WWZDc2Q4NmdHTVQvV1ZlQnpycW9Hd2V2SkFHL0V6UzNYeExFT2Nq?=
 =?utf-8?B?TnROWEd1dlhzcUUybUZObENtNWQ0MFN6RmpNWVpQUjdhSXVwcDNUNmxOL245?=
 =?utf-8?B?ZS94dC9KNmNsYmhuTnV6SzJ4dSt2aWhwMVVzbzlHZWN1UGRybWQ5aGlpeXRS?=
 =?utf-8?B?R3dFSk5GS05TQllmUFF3U3RTSWJza2VnZ2ZmdWtFSC9Ed0JGOHdaMm5GbWtM?=
 =?utf-8?B?b3huaEF6Mk1HNUN0NGdPaWtiS0dIUkNuNHgzamRBTEpkSjNqK3BuNGZuMFQ0?=
 =?utf-8?B?MlJQaVhQalF3NFFKcGhQQUpMdEJSTzM1bm9odllUNm9SRHI2ajBURHJqVkJW?=
 =?utf-8?B?Z0NtUThZWVF1REZEbHk2VHQwRTVEbFk2MG96eEU4aXg5ZXIzTHIxSDg3aXlu?=
 =?utf-8?B?WGRPYXFlSURuejJJMkJhdk53VGFnY0RUVEt1TDliQUR6OFN1RG9LS0paeHBi?=
 =?utf-8?B?TFR0aUNKS3BIai9seituOE1qemQwblo5VXBaSGxDcStQN0xROEhnWVV3QUV1?=
 =?utf-8?B?STBYTmpqblRuZVozb0xiTU13Y0UwTkR2ZXBYdm5mR3JTTC9IdmZ2SDJyRkhL?=
 =?utf-8?B?NFY1SlpSRGNBTXhxeGJHMW0zL2FoY09rUGJZQXhzMlVYWXZhQWRQOGQxbHdl?=
 =?utf-8?B?R0pFSXdIdlEzZnhldTV5THMrMXZCaGxHNlE4VUg5ZzVNaUh2UE43U0hQVVND?=
 =?utf-8?Q?JPKsQ4In15lCsZW1FkbZCzQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bbd3070-1f92-4999-eced-08d9995156bc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 13:54:47.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s1Cg356P2GYdClUxJFWyVESJpnIQgSGNwsLzVsB5QgxW7auJHAJ/nZtUlHiuuc/UDa1PM28PUoxlMblVIfdUCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2021 16:49, Ivan Vecera wrote:
> Function br_get_link_af_size_filtered() calls br_cfm_{,peer}_mep_count()
> but does not check their return value. When BRIDGE_CFM is not enabled
> these functions return -EOPNOTSUPP but do not modify count parameter.
> Calling function then works with uninitialized variables.
> 
> Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  net/bridge/br_netlink.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 5c6c4305ed23..12d602495ea0 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -126,8 +126,10 @@ static size_t br_get_link_af_size_filtered(const struct net_device *dev,
>  		return vinfo_sz;
>  
>  	/* CFM status info must be added */
> -	br_cfm_mep_count(br, &num_cfm_mep_infos);
> -	br_cfm_peer_mep_count(br, &num_cfm_peer_mep_infos);
> +	if (br_cfm_mep_count(br, &num_cfm_mep_infos) < 0)
> +		num_cfm_mep_infos = 0;
> +	if (br_cfm_peer_mep_count(br, &num_cfm_peer_mep_infos) < 0)
> +		num_cfm_peer_mep_infos = 0;
>  
>  	vinfo_sz += nla_total_size(0);	/* IFLA_BRIDGE_CFM */
>  	/* For each status struct the MEP instance (u32) is added */
> 

Hi,
Could you please rather update the EOPNOTSUPP helpers to set these infos to 0 before
returning? Someone else might decide to use them and hit the same bug.

E.g.
static inline int br_cfm_mep_count(struct net_bridge *br, u32 *count)
{
	*count = 0;
        return -EOPNOTSUPP;
}

We already do the same for br_allowed_ingress, nbp_vlan_add() etc.

Thanks,
 Nik

