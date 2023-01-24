Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64FE67919F
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 08:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbjAXHKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 02:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232535AbjAXHKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 02:10:44 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2080.outbound.protection.outlook.com [40.107.92.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BBD222C5;
        Mon, 23 Jan 2023 23:10:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRQPZHUjekDOJesZ7rZrqds5PSiNs9HlxPR6K/I2ML11xg/WypkrGlAoozyTEpCsvGmAZPo2mYK8rfCEo3fczTyEsekxxxvsfr72rlFyjNz7g0UAidjwR5PUAqOjugICTqPX+l3KHWPOd4NCqyIxR3g3hJxfWHtQnEdgLFiSHgzCWY5tFDzE+Fv1XehP4bU3/jMJloJ5GQd+dwyTJNwK46MNXvdDkg1emPBux0Y8z/o3rzphAQ7/NGzh2eh2fii2880It63DkElBvHO7XnE/GHDIp93RR8POW+DPwukkWVnxIMH9KICBwY0oUPLrf8g6eTZ4URex9OEuLn0PTSbSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9nE9z4OLS322x1JpPdE/OP/r5XVmuao7EVuf1oFduc=;
 b=C86iSbCHsyimVZB76GYEgeUE+slxtD8zXF/570TKAs7tug9rn0O8reyiNne3LXP1dXCCUkClQW6jl3u5d4gkNuvXBQNbEQons5kXBC5iWGzZbZXJzQ8wlbXS9qpIfbmm86+Edu9cns0s89ejC6IowLzvs04MlP/p3aZTpWBDLTSoXo1MO7RcBtd3p6mDUP2S5PLzDDF0aJGrcg0BI5WY/kbP55so0bSJbRB52dtn8dSeTX2avlYdJjMsBPTWgBVGQE4r4Md8x0LTkerIUTF+CaKvjwqQWLK/Rdb2SLNDPgiLIgjpGLC5FFYf9UW7Ww3yZCJLNIJ4NzBbbfSXXpEYcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9nE9z4OLS322x1JpPdE/OP/r5XVmuao7EVuf1oFduc=;
 b=cJpLTei0ekmawJA4xBvIhx3iu0XlBU6ZPlyKwJ+ATc+CdgdsBolp50rBcby1TznlChjMFtZYEL5iT2jGT+ijlZQQAy7s+p+tdAtIRyK6pDDOaF6HvO7Bekik/QYJVtWy4DxLpIptCv6TA0YnZmB8atUHCIwdNMn8waVOMspRB8YM0OApEF+9sUkd+vjgD1N2bcg8k4kc4F7gETxMcZXkKLR5B3FWuzDyOr9kFBxFS4pxYhty+ugZQ4xnd+xrnffTh+v5tPINq0t47FVi0bB64pS0GJQdNS8J7PAv9Vh+tGfKD8U2UV103BmDpqY9tOkSQAV7SMmQ+JxCPEgLM07Ghg==
Received: from DS7PR03CA0022.namprd03.prod.outlook.com (2603:10b6:5:3b8::27)
 by CY8PR12MB7537.namprd12.prod.outlook.com (2603:10b6:930:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 07:10:40 +0000
Received: from DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::63) by DS7PR03CA0022.outlook.office365.com
 (2603:10b6:5:3b8::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 07:10:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT104.mail.protection.outlook.com (10.13.173.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Tue, 24 Jan 2023 07:10:40 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 23 Jan
 2023 23:10:20 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 23 Jan
 2023 23:10:16 -0800
References: <20230119195104.3371966-1-vladbu@nvidia.com>
 <20230119195104.3371966-3-vladbu@nvidia.com> <Y8qBx6gOJJH2Y7FE@salvia>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 2/7] netfilter: flowtable: fixup UDP timeout
 depending on ct state
Date:   Tue, 24 Jan 2023 09:08:34 +0200
In-Reply-To: <Y8qBx6gOJJH2Y7FE@salvia>
Message-ID: <87wn5ccsrt.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT104:EE_|CY8PR12MB7537:EE_
X-MS-Office365-Filtering-Correlation-Id: a5325b14-0603-48d7-8d1c-08dafdda19ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nX9PNnBIEUhKj1Jx4+SmBl3IhtYvjVaQC+ssAL8m1Hycc+08lUxhWR+IIUiMavze4CsaUccxoOx/h88IKNnOzjtgLQHoUbKtBcBll4zv3fTuEnbwjuPPWwtyuKX1BWayhMLOfi8+E4V/9+kwEikX5wrFusy8JwMHXcKg5D8UlVy4hA3DDyW6Hw16ohTRecTD10h3OCkI4r19I3QzYtNmDK23RAtoFsJvaQpdN/VUPBz13No0jtk6x6sZ5ti3SRLKe7iVNZ+9JnXLKZFV172Bt6fcmuy9xzHpUwcBpxQc2E1lzoevz/PR96RAxcdETHnvSw9S/QA+Mih6Bo7kXqfXeGIz5nbV9tIOLcPol1QwkcG6qQvC5vA/dFLkb3B2jiLLy98lH7fn1GtDZ4mk91KdiIHGGF05dLktDnRUJrhhEsnkbyU2GXl/Uf9asYlJxz7mn+mZBx3gixIGr1iiDNg0Tun4hmrvL5+OQoSuyC/Ry3lIPr5DYTOJvFX+0LzUfBE95ZvTKKdS+yU7Ns9xGjAhFZ7WOtfC3y+85o5Y5w5Dtg1Q3GkvGm+k0d7zjpF3m4HcAcebzrRTFgShpn1WhBGZDKYh3MN17wZa0llWKo2BWJpqM2t1P8a4u8BsyEUsKISK/wz/g9WDNufrKfRFnB8ijVh1PZs1CT5WrYRcjTAzi2miSE4wJz0ydwiU4dcRUC6y1Rw4riEu0aoauYYpRsnaDw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(40470700004)(46966006)(36840700001)(83380400001)(36860700001)(82740400003)(7416002)(41300700001)(86362001)(356005)(7636003)(82310400005)(2906002)(5660300002)(8936002)(4326008)(40460700003)(16526019)(40480700001)(8676002)(26005)(6916009)(186003)(316002)(6666004)(47076005)(336012)(426003)(70586007)(70206006)(54906003)(2616005)(478600001)(7696005)(36756003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 07:10:40.0442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5325b14-0603-48d7-8d1c-08dafdda19ad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7537
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri 20 Jan 2023 at 12:57, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jan 19, 2023 at 08:50:59PM +0100, Vlad Buslov wrote:
>> Currently flow_offload_fixup_ct() function assumes that only replied UDP
>> connections can be offloaded and hardcodes UDP_CT_REPLIED timeout value. To
>> enable UDP NEW connection offload in following patches extract the actual
>> connections state from ct->status and set the timeout according to it.
>> 
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> ---
>>  net/netfilter/nf_flow_table_core.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>> 
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index 81c26a96c30b..04bd0ed4d2ae 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -193,8 +193,11 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
>>  		timeout -= tn->offload_timeout;
>>  	} else if (l4num == IPPROTO_UDP) {
>>  		struct nf_udp_net *tn = nf_udp_pernet(net);
>> +		enum udp_conntrack state =
>> +			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
>> +			UDP_CT_REPLIED : UDP_CT_UNREPLIED;
>>  
>> -		timeout = tn->timeouts[UDP_CT_REPLIED];
>> +		timeout = tn->timeouts[state];
>>  		timeout -= tn->offload_timeout;
>
> For netfilter's flowtable (not talking about act_ct), this is a
> "problem" because the flowtable path update with ct->status flags.
> In other words, for netfilter's flowtable UDP_CT_UNREPLIED timeout
> will be always used for UDP traffic if it is offloaded and no traffic
> from the classic path was seen.

Hmm, I didn't consider that netfilter might not update the status. Will
try to decouple the teardown timeout calculation and allow flow_table
users to specify their own.

>
> If packets go via hardware offload, the host does not see packets in
> the reply direction (unless hardware counters are used to set on
> IPS_SEEN_REPLY_BIT?).
>
> Then, there is also IPS_ASSURED: Netfilter's flowtable assumes that
> TCP flows are only offloaded to hardware if IPS_ASSURED.

