Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B4D3E41AE
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhHIIgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:36:07 -0400
Received: from mail-mw2nam10on2056.outbound.protection.outlook.com ([40.107.94.56]:8896
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233903AbhHIIgH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 04:36:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVopH6Mn/RkU15FSqYWskwQO7gJM43yA6t4jy3WbWlmQVKFr+CKGqxhgLBuKu7jCSuOptFs6u7jpsdbEJF3O9JxbvXBFk18EfvJl4t1yZ05ywY7McQ2af7Slf1AjlQ5DtX/MyD3/RRejTEjcbYAQvVXgpXrMnRBdYPEqTwWFGGMLvPTQF1uaYiReHhAWkSFg14ETw3A3oeYHATiEixxOZnWdKZCHW69WWUJE2u7BKSXniklXx4dFaeIc5elBpdIECqcCxCG8/ztn5Fbg0F65Mu+TWm5hzkCKrIJHuVC64xtf427BhxB9pEgjdudK8VnKcUJHRb8yHjkDtLTfUd5BNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZV0RF8HzdaSxkq4XoL1IG11OM2Q/E3t8LE+IfSWkzSM=;
 b=PaZACuizMhgrBtXdKcSfmAtrUsoQeU5yJfl56z81BDvepzmYAh55favQS/fhglE1fBkFk7jm9xjELuxNk5TTHVX7MoVW7n1+juKZqrYRjtePdaIwEcHlYu35WXaEHz2AxhNoYSTjMN7kvuAfabtxlMTgV1pzizot0SXeciXmSpd7BwqZVupi4ec6VPoLfak+kAYdjg8VUTxSogL0gk9n32iHIHQ/g+Rb8B3Np2O+IyxPrm6Tmp5QF6YWT+C7UXeBmi7CeU3MTZg4d8eprJ1e5OKdJM4AbhVdSgQXWt8WgJ3az3QZS7Jk/OI2/CTzSiBVJIzfPqxrm85DL56SHzyDCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZV0RF8HzdaSxkq4XoL1IG11OM2Q/E3t8LE+IfSWkzSM=;
 b=gNNwMFT2aDy3I2qM5mYtrZJKv7VuM3BXxp3hzBVKCIqQd8bAmO93ZtGAFgoaY/BwjQ1o7vnsk/Eq6pxbcBmiLCziqlV5/xKwgXlhvfR04ZGM0+ffivWbBeAsQCIP2b4sPnh+CzvB37ioNe4rtyB+vSEHeAzRnteMm1AmS4Jd/FPITO9eG5tqPN/Z3JxBVquGCxbVJNhJw2iNRIaYmJfOLc3Rep1iLLh72B+6lgJ+ktWlanjbhzIyneXYTyUL5WCtdDRvCV/TNHhS5KA/T1EKt0ZM2JNNrGqv4F1oGBDydvB6HEncKqOJPd9thRN03XQvnw/EDlW/3XlfdUqH28m1qQ==
Received: from DM5PR13CA0036.namprd13.prod.outlook.com (2603:10b6:3:7b::22) by
 BY5PR12MB4903.namprd12.prod.outlook.com (2603:10b6:a03:1d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 9 Aug
 2021 08:35:44 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::63) by DM5PR13CA0036.outlook.office365.com
 (2603:10b6:3:7b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.5 via Frontend
 Transport; Mon, 9 Aug 2021 08:35:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Mon, 9 Aug 2021 08:35:44 +0000
Received: from [172.27.14.178] (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 9 Aug
 2021 08:35:40 +0000
Subject: Re: [PATCH net] net: sched: act_mirred: Reset ct info when
 mirror/redirect skb
To:     Hangbin Liu <liuhangbin@gmail.com>, <netdev@vger.kernel.org>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Alaa Hleihel <ahleihel@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Aaron Conole <aconole@redhat.com>
References: <20210809070455.21051-1-liuhangbin@gmail.com>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <a25a75de-ac21-f20b-3372-9d90cb485f2f@nvidia.com>
Date:   Mon, 9 Aug 2021 11:35:38 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809070455.21051-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3136d21-441a-44ef-1ae9-08d95b10adaf
X-MS-TrafficTypeDiagnostic: BY5PR12MB4903:
X-Microsoft-Antispam-PRVS: <BY5PR12MB49037AC793DE557A1231F813B8F69@BY5PR12MB4903.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:67;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7HjAEt43iXIT4eQ/RV3oeOsHeIU6yw1uSYzNwH+tHi8f5G/bznBf3B9SunlEH1lQ3Ti+uFIxZfnxtTr5oOTmifDnzL8jaCb8gteUyIj83jIlwMok7/8AUP6Hj0VF84fJ0DAi++68b10Tf/TTSDiPD0SXVQ1mY8KjJZAwkb+UU3hlWZNaP06fYOC7e4FBsVmzoPDQk2Bvn6YCqFKry7twhB9zAUrPkHWF9E4oO05Q9BopBhoeZMxH/8Y2oKoTQmzPVLjFKhdwXm2Nh2tan9Sos6H+mjLwY5jOWkYvqtY72xHnj7IhnnzY6zYKewbKAn3gmRFKiCZYI5+LDlOv44AepXMngkLECb/howAupNQrvn3DNO7JQRFkzFAB9uvVGe3lwmW70TgdkHo8+rbsnpc3DPLmbtvWqNsgmSe/DrU3mfBk7clSs03XL2dYc/+aHtSFIJfIrwEmGYXPrEUQM6Ghq32xZlu7/ytsYd+1twN+YE4Z7t89QwdADDauHdhKO1/sMjkFXo3WDIH0NvhUz9BDUtAtDTPZr8vCOsMFLEF41d3j2WeD+4neIPJdIYsbKkzxmULF8ddVkqs/uPFYfx9+MIIM++ydgaDymQpQDzgnpn4WFhFxpfFO+31V1MahBEe7smYBGjWTT6+rtPfD2nVUGe1JQ73Mzk8BpiFI8IUxNVsjdScp7F/j59+6vyx6b95usNd4QlJDNAsqoNol8mbHxeuHwr4oDiYZ2094fZGrpOY=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(36840700001)(46966006)(47076005)(26005)(16576012)(336012)(5660300002)(316002)(110136005)(54906003)(478600001)(36906005)(31686004)(70206006)(70586007)(7416002)(82310400003)(426003)(8676002)(356005)(186003)(82740400003)(16526019)(53546011)(2906002)(8936002)(4326008)(36756003)(31696002)(7636003)(36860700001)(86362001)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 08:35:44.0074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b3136d21-441a-44ef-1ae9-08d95b10adaf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4903
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-08-09 10:04 AM, Hangbin Liu wrote:
> When mirror/redirect a skb to a different port, the ct info should be reset
> for reclassification. Or the pkts will match unexpected rules. For example,
> with following topology and commands:
> 
>      -----------
>                |
>         veth0 -+-------
>                |
>         veth1 -+-------
>                |
>     ------------
> 
>   tc qdisc add dev veth0 clsact
>   # The same with "action mirred egress mirror dev veth1" or "action mirred ingress redirect dev veth1"
>   tc filter add dev veth0 egress chain 1 protocol ip flower ct_state +trk action mirred ingress mirror dev veth1
>   tc filter add dev veth0 egress chain 0 protocol ip flower ct_state -inv action ct commit action goto chain 1
>   tc qdisc add dev veth1 clsact
>   tc filter add dev veth1 ingress chain 0 protocol ip flower ct_state +trk action drop
> 
>   ping <remove ip via veth0> &
>   tc -s filter show dev veth1 ingress
> 
> With command 'tc -s filter show', we can find the pkts were dropped on
> veth1.
> 

We can add a fixes line on the commit added ct support
Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")

> Signed-off-by: Roi Dayan <roid@nvidia.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>   net/sched/act_mirred.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
> index 7153c67f641e..2ef4cd2c848b 100644
> --- a/net/sched/act_mirred.c
> +++ b/net/sched/act_mirred.c
> @@ -273,6 +273,9 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>   			goto out;
>   	}
>   
> +	/* All mirred/redirected skbs should clear previous ct info */
> +	nf_reset_ct(skb2);
> +
>   	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
>   
>   	expects_nh = want_ingress || !m_mac_header_xmit;
> 
