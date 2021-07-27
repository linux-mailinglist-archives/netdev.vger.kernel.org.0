Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD513D789E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbhG0Oi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:38:59 -0400
Received: from mail-mw2nam08on2072.outbound.protection.outlook.com ([40.107.101.72]:40512
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231466AbhG0Oi6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 10:38:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mPCje3uMymVgKyi4qhGmb1FQtXj+sQiZpizlrn2DAqZmPQgWmOkDOZWxOrErAoN7lsnC0pF+hcsZWkE/jq7PM1PIoDxrFrdkd/Y561ir4vCYi3vTv06Co2V9wMgLRNR5LXd2Q9G/gO+upP3i8jd5ypYjJfH6IPhOw/VQQyKthSiP7ijbCmZ2O9bJTbgDyeMaMG1ZBFlFfg/9pIniYyiPBpjfMRZMnB/YwznN6+duz5F4+b5uxCVz+v91zrI6bvPSHFmtTFbfiJ/Bk21x1h+Lx35MDmo6YDSnMmJ2CWF37JmKXs96JxihkLO04GhKzKEJZJ1x/TB1uTUE4vJdCMrIBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqdZMziuBgSDFEl+5aqyFRtrYP/PXmmETRgrRerMrGQ=;
 b=V/R4/a6tEtP16Cof9epWGsbeF8zjey+1BWTbMR0liUXVbz5glbFmbrB7Jv34ddpEuggrRFrlhxudZvnf9jFXZ5DjQpJaXJawCTsG0/BtpW6BSeYcIc7NkDYa4aSK6I83txvYufRMjM3RIHoUOS5fOdbum9UnygFYm/daGXmY13XjRYgqUmcK0tulqyifU6AXI9KAQOi8cItSzNgI1M5dE3z7wQMd5yjYe7CT9D/oq3hXS1P3ON8xnHwqHNrQpaFrq9eS0KsQQQwktoKVljIEFxOLvoGhKP+GYLdc0qWKSzlLFAJC7ip6DO2eJH9lPrpd8oeeRSeNK+LHF//ld0eZgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZqdZMziuBgSDFEl+5aqyFRtrYP/PXmmETRgrRerMrGQ=;
 b=XolPJy2UDCyzpRzzetlbSbht6HpCt54P446HwxKHNESfwsfR60wzj1r6Wxn6562ft+VT1nJq8tuoQPuQyjPuaygCdy5HMzhzGJ5M2IWcJR8j2GjFLa60ATm8gpdCQg07F2N2i2trQazPCaXWGPqkCDDjylpNUj2wefEJJGMiQlSR1oIJ6pYCxZJR/n2H7/x4wTGLxyKNKbbNa0LpVZVEcWCDiW0R+39cqagEVsxWLWBsL2gKb3tuIbJpEhlmiOdMXinDLw/Cx4rDI+n9EI1Kw9OHN3zsqcGx8Z0UCRV6QO/S1gbdD6Fi5DRtmLrSsu24r4fVDSVNWSiUb8uJCZd/oA==
Received: from BN8PR04CA0064.namprd04.prod.outlook.com (2603:10b6:408:d4::38)
 by DM4PR12MB5391.namprd12.prod.outlook.com (2603:10b6:5:39a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 14:38:57 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::c2) by BN8PR04CA0064.outlook.office365.com
 (2603:10b6:408:d4::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Tue, 27 Jul 2021 14:38:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 14:38:56 +0000
Received: from reg-r-vrt-018-180.nvidia.com (172.20.187.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 27 Jul 2021 14:38:53 +0000
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
 <ygnhim12qxxy.fsf@nvidia.com>
 <13f494c9-e7f0-2fbb-89f9-b1500432a2f6@mojatatu.com>
 <20210727130419.GA6665@corigine.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Jiri Pirko" <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Louis Peens" <louis.peens@corigine.com>
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
In-Reply-To: <20210727130419.GA6665@corigine.com>
Date:   Tue, 27 Jul 2021 17:38:51 +0300
Message-ID: <ygnh7dhbrfd0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c1f43b3-91da-48d8-2b91-08d9510c43d3
X-MS-TrafficTypeDiagnostic: DM4PR12MB5391:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5391DE44D62E7F4B3DAD101FA0E99@DM4PR12MB5391.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0wZ2qtgalUfD0UK9BmidspQkiZX8Qkkbgs9rXFSehN6Bn4idQHg6Tqi4srgkxuTH/1jaGbPKAU11uIUwTdvb+mkyGQh9eLZ1RSZP17M9HxMmTNLMuwQX+RdST2CoxhcXXo8KuuB8BO0bAE3TP03S5zoOLNLTlPNYGyOt6uKCL5JKGD1sLbY12vDc3hhFCjjWChnP1/hyZ6h+fF+nFRqHmd/3wSgBzGmKSEEPIzvi83klDJMkOwBRNKNK2NUt/o+2KzCbFDtltaxAVILG5M1XWW+EnqM/h3vbiCAO7rUrsGvBMseUvxTmK57RYHqKZalhttMk5lQ3ouGkmg6MMMbqMbsi6SlEdqIK9p2l4NZ4SS/t0xu+VhQQIqgKKUp3so1bXuV65ZymUx1mfP2HIJIeAwaWMHGQSOaG9OS2/baCXcMwkYwvmQ+VY7v88b6fpvIQaYPmD4VPwIHY/X8mfKtRWVy8UupPr1Ww9EeJEZ3816NQc/oonQDq65kwLTguHNxV9A/6EFPeC2CSv86G5o3BP+WYhT4ez9V9G7V4EPLGYBAz6EhQPem4KwQaKxsL0Pg1o7LHWla6qT6MXDbiiHr8x2smGNRonwzTmwQAyQN3rOhkilsnUG0dSrosOGugJj5TSiBTuv0CTia+chDHCD5xFmbYTa3Tw1gHQ/O5dQQcf9nza6CcVtROm6PK7aMyWvPvxovSlt7t8eSkRKN+WaoVzg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(46966006)(36840700001)(47076005)(316002)(83380400001)(336012)(86362001)(6916009)(70206006)(70586007)(54906003)(16526019)(7636003)(8676002)(26005)(4326008)(36756003)(478600001)(5660300002)(426003)(8936002)(2616005)(53546011)(36906005)(2906002)(356005)(82740400003)(36860700001)(186003)(7696005)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 14:38:56.7446
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c1f43b3-91da-48d8-2b91-08d9510c43d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5391
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 27 Jul 2021 at 16:04, Simon Horman <simon.horman@corigine.com> wrote:
> On Thu, Jul 22, 2021 at 09:33:09AM -0400, Jamal Hadi Salim wrote:
>> On 2021-07-22 9:29 a.m., Vlad Buslov wrote:
>> > On Thu 22 Jul 2021 at 12:19, Simon Horman <simon.horman@corigine.com> wrote:
>> > > From: Baowen Zheng <baowen.zheng@corigine.com>
>> > > 
>> > > Use flow_indr_dev_register/flow_indr_dev_setup_offload to
>> > > offload tc action.
>> > > 
>> > > We offload the tc action mainly for ovs meter configuration.
>> > > Make some basic changes for different vendors to return EOPNOTSUPP.
>> > > 
>> > > We need to call tc_cleanup_flow_action to clean up tc action entry since
>> > > in tc_setup_action, some actions may hold dev refcnt, especially the mirror
>> > > action.
>> > > 
>> > > As per review from the RFC, the kernel test robot will fail to run, so
>> > > we add CONFIG_NET_CLS_ACT control for the action offload.
>> > > 
>> > > Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
>> > > Signed-off-by: Louis Peens <louis.peens@corigine.com>
>> > > Signed-off-by: Simon Horman <simon.horman@corigine.com>
>> > > ---
>> > >   drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  2 +-
>> > >   .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |  3 ++
>> 
>> > >   			    void *data,
>> > >   			    void (*cleanup)(struct flow_block_cb *block_cb))
>> > >   {
>> > > +	if (!netdev)
>> > > +		return -EOPNOTSUPP;
>> > > +
>> > >   	switch (type) {
>> > >   	case TC_SETUP_BLOCK:
>> > >   		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
>> > > diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
>> 
>> [..]
>> 
>> > > +	/* offload actions to hardware if possible */
>> > > +	tcf_action_offload_cmd(actions, extack);
>> > > +
>> > 
>> > I think this has already been suggested for RFC, but some sort of
>> > visibility for offload status of action would be extremely welcome.
>> > Perhaps "IN_HW" flag and counter, similar to what we have for offloaded
>> > filters.
>> > 
>> 
>> Also showing a tc command line in the cover letter on how one would
>> ask for a specific action to be offloaded.
>
> In practice actions are offloaded when a flow using them is offloaded.
> So I think we need to consider what the meaning of IN_HW is.
>
> Is it that:
>
> * The driver (and potentially hardware, though not in our current
>   implementation) has accepted the action for offload;
> * That a classifier that uses the action has bee offloaded;
> * Or something else?

I think we have the same issue with filters - they might not be in
hardware after driver callback returned "success" (due to neigh state
being invalid for tunnel_key encap, for example).

>
> With regards to a counter, I'm not quite sure what this would be:
>
> * The number of devices where the action has been offloaded (which ties
>   into the question of what we mean by IN_HW)
> * The number of offloaded classifier instances using the action
> * Something else

I would prefer to have semantics similar to filters:

1. Count number of driver callbacks that returned "success".

2. If count > 0, then set in_hw flag.

3. Set in_hw_count to success count.

This would allow user to immediately determine whether action passed
driver validation.

>
> Regarding a flag to control offload:
>
> * For classifiers (at least the flower classifier) there is the skip_sw and
>   skip_hw flags, which allow control of placement of a classifier in SW and
>   HW.
> * We could add similar flags for actions, which at least in my
>   world view would have the net-effect of controlling which classifiers can
>   be added to sw and hw - f.e. a classifier that uses an action marked
>   skip_hw could not be added to HW.
> * Doing so would add some extra complexity and its not immediately apparent
>   to me what the use-case would be given that there are already flags for
>   classifiers.

Yeah, adding such flag for action offload seems to complicate things.
Also, "skip_sw" flag doesn't even make much sense for actions. I thought
that "skip_hw" flag would be nice to have for users that would like to
avoid "spamming" their NIC drivers (potentially causing higher latency
and resource consumption) for filters/actions they have no intention to
offload to hardware, but I'm not sure how useful is that option really
is.
