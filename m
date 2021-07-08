Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE9D3BF589
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 08:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbhGHG1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 02:27:04 -0400
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:7232
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230412AbhGHG1E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 02:27:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fhiEmxcP/sSS9vZbtaBPe75NJ9kLxJXWFvMuw5Qg4HBhMZePATL/KJ9lj4GBXxRXrT2mNRDoILglLtsZUELViOYBQVBDjVBly2SG4+Eqm6w5QmKVYl0wteOwTVUcCgm5CK6oKRQw7sj+ItPeDjq42H2+RLSZg87KDvw/7UBmk4im7Nvdfo5keOLQR/BrruzX69DPf+hrK38cdWTP64B7ls3WHkQWjoMAtFuO1PC0cno/EZ1fClPbbquwcjyFJH46Nfey39kqOiBm9fJCkiS0mrjRTHXihZCkI5VALWeFkf/Kxwt6PluN1d0cVl/crEvRsZJSwRrtxy4jefLaUOFzuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqspdSVmn0abjI0dXeKzFMzguhfRaaVQ/DCivfUDlZ8=;
 b=OaTgXsLjtnErlq8PbAdBdy/KzsYe0EvHBNYWlzaFj2M/MF7/nYh7uWcazwHkCf5JWL6zyJueARWtGA/RL/UzRvX5EbjmrO/N0OtFdNx9KgPagxJgtewtObmZQ1k6L8W2HW3HoO1bZbr6D8ieYfwaUeLMf4dFbU95Aox6Asox0Uyg1OIQD4k1FPfloSLOM4/CnG6KhAftjs/94b7FE2ZJlYg2XhaDTpwmdH5uln7s608En5X7gwvv8YuadXyhs0xVtdKhMPQgqxnCqw0obkiD7N5XLeids3pfUGFaKPE7fuEIRYh8TW5bdhg4Ufbpn8RP9DgnprJpZ2xp5vFgqZTyyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SqspdSVmn0abjI0dXeKzFMzguhfRaaVQ/DCivfUDlZ8=;
 b=PwwSFh8WQ7Ov4QI0vNDJnlw8oCLZyKpbHDbn6MaUx6TwFUmU3RaxeVQMmdHaubzV/VKH0AVnp4IBnedxBTMaH8oVYOm2sNdrDNx3j4pjnM6p6oj9d233sku4IO90pNkKUmUnY4aP6TW0fa2j2yQV0kNrFLmpF/s6MGhIaW3QwQOi3SEm+xQVD7qBT3bdaaMoTOarRz74ZAWmZZDhbi5loK6BcGaJ+woKQeeRVJk5+KOWcsWCYZgfbGxXpDrRld708iTySkOtZ8EO9QAatyMTiaml2O7OFKS62thP4Regfx9hmAeoQh8Va5yU1URMO6/h0DAttVgzMNTQN1HPxfbUvw==
Received: from BN9PR03CA0674.namprd03.prod.outlook.com (2603:10b6:408:10e::19)
 by BN9PR12MB5339.namprd12.prod.outlook.com (2603:10b6:408:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Thu, 8 Jul
 2021 06:24:21 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10e:cafe::17) by BN9PR03CA0674.outlook.office365.com
 (2603:10b6:408:10e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend
 Transport; Thu, 8 Jul 2021 06:24:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 06:24:21 +0000
Received: from [172.27.1.80] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Jul
 2021 06:24:17 +0000
Subject: Re: [PATCH net] skbuff: Fix build with SKB extensions disabled
To:     Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
CC:     Paul Blakey <paulb@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        mika penttila <mika.penttila@nextfour.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20210708041051.17851-1-f.fainelli@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <d2bcf9fc-1068-a02c-2ef9-f015468283b2@nvidia.com>
Date:   Thu, 8 Jul 2021 09:24:15 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210708041051.17851-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 722d77da-3c07-49af-ca7b-08d941d905f3
X-MS-TrafficTypeDiagnostic: BN9PR12MB5339:
X-Microsoft-Antispam-PRVS: <BN9PR12MB53392ECD14A2B68BC8803C27B8199@BN9PR12MB5339.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Cm44p6wEerjdYu0HF1sg9XIVYg2blLDZw+75CQeGW2FlTFiUYJ6BBqoUvi+Oo3PUyeTnZwBZIdeioVCgE2yYYzwgwLB1ug/Fv6gihL2WYInmiHjq47u3CFYFR5g8chzYyXNSwo7yyd3J6wFZ5vBeKAMv40DVAv22pohfWhzeJ86QkuU1+EdhVhENu3gRRRg1YCB7t2jZUaNV2jhB3PsNGePb0H7BzgdEb6O3QLldiywxpSl9sIIYSxJqOOVVMkdoF1j/eypRuF1Bxshrqad2sbNFa9e6SBxYKNn4DYUq4RiKAVJgWtQLFB2sqOuXbGY51exE/c7Hh6tRcET8FqrJXDSw5nM7OU5mC0Ueqz2rBum2BXuFrMz5UwdGC3YkUSd8bGn138QSucCOx166Uqy/lkPls/cpUDWrR2vXz8OjiinElt7yotymd5yaxji/hpn0rWC0YNeG72R5hOBI96bJ75K63+2aOV4bHm3iqgzocPoLccxWA5UcjkoubzQd2sS/cke9MGECijExX3qk21DB2SfDFkuFj9QhUe/j8k/NBnZj7sjEktgslZMZD8aL6TtYEN2UdBTWa7N1/doDlDZJYcyetMpxugCRZTdaWneEpDjT1dOGVkrJgUENt97mk6jVCIyzxSZdvfNEZPiqUEFZeuTgEG06ydRgEFe27iXxxjFkY1nOLmnVmaHOCjPJ38j25LGiKjx1ofVmjn/xGTyFCrUjMeGJfgvvAAklBCTeV8=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(346002)(136003)(46966006)(36840700001)(5660300002)(86362001)(36860700001)(31696002)(336012)(36756003)(107886003)(47076005)(186003)(82310400003)(16526019)(83380400001)(4326008)(478600001)(2616005)(82740400003)(26005)(8676002)(316002)(356005)(8936002)(70206006)(426003)(54906003)(2906002)(110136005)(7636003)(53546011)(31686004)(36906005)(70586007)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 06:24:21.1528
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 722d77da-3c07-49af-ca7b-08d941d905f3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5339
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-07-08 7:10 AM, Florian Fainelli wrote:
> We will fail to build with CONFIG_SKB_EXTENSIONS disabled after
> 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used
> skbs") since there is an unconditionally use of skb_ext_find() without
> an appropriate stub. Simply build the code conditionally and properly
> guard against both COFNIG_SKB_EXTENSIONS as well as
> CONFIG_NET_TC_SKB_EXT being disabled.
> 
> Fixes: Fixes: 8550ff8d8c75 ("skbuff: Release nfct refcount on napi stolen or re-used skbs")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   net/core/dev.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 177a5aec0b6b..03c95a0867bb 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6010,7 +6010,7 @@ static void gro_list_prepare(const struct list_head *head,
>   				       maclen);
>   
>   		diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
> -
> +#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
>   		if (!diffs) {
>   			struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
>   			struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
> @@ -6019,6 +6019,7 @@ static void gro_list_prepare(const struct list_head *head,
>   			if (!diffs && unlikely(skb_ext))
>   				diffs |= p_ext->chain ^ skb_ext->chain;
>   		}
> +#endif
>   
>   		NAPI_GRO_CB(p)->same_flow = !diffs;
>   	}
> 

thanks. sorry for missing this.
tested compilation before and after the patch with combination
of the mentioned options to be sure.

Reviewed-by: Roi Dayan <roid@nvidia.com>
