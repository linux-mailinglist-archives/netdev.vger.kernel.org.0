Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71A1471A1E
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 13:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230441AbhLLMmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 07:42:09 -0500
Received: from mail-dm3nam07on2073.outbound.protection.outlook.com ([40.107.95.73]:62440
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229839AbhLLMmI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 07:42:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZI22hcOwp3rS0NYpxtLJInT+G4glth9hWewgtD6hZQvby+dhIaUSx2dsk12UUYGu4IPigvbaq4vBwz9LJOtvDII800vVZX7hlxgUAzwRdE/3tR+TjueVGQnWRxdaJnZqTUZrvYd1dTRdvPaeBPRYA/gMroCgqkPA9IGT9DGodBqzpW1k2owgKxMFUrjBykD0AiwQClFmdT4xaPJuRMoHeCAN1TTwT1p8Yrsmzq7f8XtvesT/imvw5hZajJBmST/1Tr9s/Y6whu0kjWIwQgSFp0wL7G9QMbqkqD3hPo8cnluzasA5lodC7jL1co+Gyu4rdbwhysB30VKWLxLlOiOGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOyWrjQXfsVeZnhsnXsXv5JnLY2cg/xEct9ki0kU+nE=;
 b=JXjeAgJ/cs0K1B0t0ZS1C1GdvL9uQyt0fU8ELWGNBJnQjqQ8N3UN3M4nI3sTH+cQ87cFQcLg+QuyB1dyIs8JWKud4+qSx+SwtVqmJZ0Y2otY5PlumYtyHkEkw5/4mE/6YyWjyngHL5d+wWsnENCXngLmJT+G8M+iTF4qr8pCgbo9jm6P1axTQ8qeLjR05bNtVdJxnXXbwxYRmXAjBDCOI+STh49X76N8TDYq31Lg8Cy3pqS/2qbLd7p3un4xqowB/v+3p9PsR5FIB5WdNQHzkZWe4Ws/eq3V1gy0kAez/Wr1k0W7xMcyxXm4vUUIXXBCaORWMWnUEJE9lommohyU9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.12) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOyWrjQXfsVeZnhsnXsXv5JnLY2cg/xEct9ki0kU+nE=;
 b=nAMIyyE92+SCV1yzo0dKoop3xCRitucPxanRAcsWUcOEHE+w6XMxpy4/h8pvN608xuaM48Lhl7VMPGipuqdT10iM+LHsmJ1j4j1F60aG8v3SowjXchjjBzh5Hwjn3ygCfwOwqix5B/JEfH8ExvR89qtA0w2FRyW1f9hvEvgNfYRRYqLBob/aykOsGi+oAI+Jrd0P+2fGoOC1adfNrRu7R9E+Amy/YerKjHlUhSiIkXeB9etDf7CDZGfMnLcS0upNaxV0BJgNnj6RZzz+akcI3BdW4NT/z00+p03v0YUDHtmmB4pV8MAVtHpwUu4Ur3MkjZBYwvzeWzRMObp3jcWdNw==
Received: from DM5PR06CA0096.namprd06.prod.outlook.com (2603:10b6:3:4::34) by
 DM5PR1201MB0169.namprd12.prod.outlook.com (2603:10b6:4:55::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.16; Sun, 12 Dec 2021 12:42:07 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:4:cafe::3d) by DM5PR06CA0096.outlook.office365.com
 (2603:10b6:3:4::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Sun, 12 Dec 2021 12:42:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.12)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.12 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.12; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.12) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4778.13 via Frontend Transport; Sun, 12 Dec 2021 12:42:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 12 Dec
 2021 12:42:01 +0000
Received: from [172.27.12.251] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Sun, 12 Dec 2021
 04:41:56 -0800
Message-ID: <6e56aa1e-25a2-9bb7-aee3-6a2954216b73@nvidia.com>
Date:   Sun, 12 Dec 2021 14:41:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH v6 net-next 04/12] flow_offload: return EOPNOTSUPP for the
 unsupported mpls action type
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>, <netdev@vger.kernel.org>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        <oss-drivers@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <20211209092806.12336-5-simon.horman@corigine.com>
From:   Roi Dayan <roid@nvidia.com>
In-Reply-To: <20211209092806.12336-5-simon.horman@corigine.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 262c1a4b-5d81-472b-a5bb-08d9bd6ccec8
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0169:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB01696A63BFBA40547E8F26A4B8739@DM5PR1201MB0169.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:400;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: efd1UzxYs1rS14NA61z7GJ1YRPn3Mt2Z+FGFrggSKpxWsvpaKSlnahmbPZWeBOYvhf3E4FctS0Xv1yfMU9FuL5ShBTAJvsjT6vJ2Ed473/Hhyjr9cw+Bus5khVdw7iBh7M6hTK9Fg9WkEIq+UGZslnG1rJu+W/VHqVzS6hZ9d2zipafEaEg4qsiGfRfTEiU67b3U3o4/3a/z1yTyBq4ww+yA5E4Pvdh76x3mQ4kKqjdgoMdmwxxxF46HgwhowGRX4RgF2N9RyvMBUm2vlJ/H+mwUodXMREHEnj5sCz/DqlV16x4o+k9a0sZxXxV2xj8EL4rGUAIskFO6IsWKz7lI4XAfpCQUI1Kp7B28bpWM2sQccQA+zSAxXTuRLVNW20ZjrRfAQkWZzGcKTlhOAPV5dQLniEcghZgzAqwRx9zStQG02RjNmK+hJIoVYwpfOVFi94ljQKLO4p6qPezZaMg/SS3cotsi9U39I4mlaPQL7ySBoNW4S7GcjgCgwXsNSRuslf2+TpT9etmqDlRZFx1TBZtI/2HsMpoOuBihpitDIVRl4vRm6oLMr9QjTVt0pGem14TyucEqdVxgA1RmEaBfaVwoCCrDfSimjihDDbDPNxz3+BkPj4UKodmtEdzYy+cRrH2w9A4LZVXZZ1Q8tj2Ug7Z849tHkKnYbNG4dtCP5z84RWYJXBgLilnBZANcbnrLER//prNYtkDZ4TE0Iv/RpY1om/hJLhwrDRO5PnMRA/Tynm6hCI/eKQGEuvKy1rLnXGcinU2jufg3Et8KHSCkOZK8MRW+Z/JtAba3yrx2xD9K9ewpnaMC2PZ4wn1kL/Pc9KF1DYdGXf0A/JJYDx0GAw==
X-Forefront-Antispam-Report: CIP:203.18.50.12;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(83380400001)(16576012)(316002)(7636003)(86362001)(36860700001)(336012)(5660300002)(40460700001)(2616005)(34020700004)(8676002)(54906003)(110136005)(2906002)(508600001)(36756003)(4326008)(356005)(8936002)(82310400004)(47076005)(6666004)(426003)(53546011)(16526019)(70206006)(186003)(26005)(31686004)(70586007)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2021 12:42:06.8478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 262c1a4b-5d81-472b-a5bb-08d9bd6ccec8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.12];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0169
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-12-09 11:27 AM, Simon Horman wrote:
> From: Baowen Zheng <baowen.zheng@corigine.com>
> 
> We need to return EOPNOTSUPP for the unsupported mpls action type when
> setup the flow action.
> 
> In the original implement, we will return 0 for the unsupported mpls
> action type, actually we do not setup it and the following actions
> to the flow action entry.
> 
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>   net/sched/cls_api.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index d9d6ff0bf361..7a680cae0bae 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3687,6 +3687,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>   				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
>   				break;
>   			default:
> +				err = -EOPNOTSUPP;
>   				goto err_out_locked;
>   			}
>   		} else if (is_tcf_skbedit_ptype(act)) {

should we have this commit in net branch with a fixes line
so it will be taken also to stable kernels?

6749d5901698 net: sched: include mpls actions in hardware intermediate 
representation

