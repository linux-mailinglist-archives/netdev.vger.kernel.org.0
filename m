Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73FCA4D5B8B
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 07:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239088AbiCKGWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 01:22:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233190AbiCKGWL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 01:22:11 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA5566626
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 22:21:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JItntZEJoTgJV0viHrL7vT+P4oJCScyu7iysvboqgdi+b0onR3S0UvMGtjgpICEmpJj5oFZMNnt+hOqoh1gbwHEI/naakqzhAXmGnA4k7fvdOeD4mnuMyNiTa+hAx//IO2lKJ91HTxJrhZVhE/TmFjFt+L8YLoHv/m9noNqP9/soY4439n2Gf883fj8tWDrtJrs+gEAGhp5OeAUJgDW1ZDlYGjAVdrsP+x/7NMy4Kdr6hEPZwO6EPbppaQLAvWO4gKLl1nnI8Z7IuKZiF16qm4TsLopwyxaPDW1mJ8BvFqWQxN+XncfDC1i9LXqA3k+DBZF5oAtF89EAcS0Is0ciSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PPiGCI3qNDIf+LsRjFklfHHUahAl8w1V2CSrXw/LiOE=;
 b=FZwtyI0+lOaOZLqqr89L1pYiPV3uOVC8tMxP7wNl63h8NS+NK69nCG5BZUyFYl6ZhZuEnwRJQHaC+V93+jrYg6kY7ERzLwQwANsTsy6K/cE/NhrgODBM9gSpmaS3LR7EKUTcwKPvfvWJFm3EeLGLVQkl6rihMcqOali8zvx6SMifTvR5lFNu5xOQzQwv3pf3NakGZHOCjyRn+IHT9QHx7fR+yh20T3X6tqNPHUJY9k55RnpUnaRbiQofXPv25uWsJUEK8nr8H3VT6+KGoXakfaDeS5RtnSpxSZ5hsHcbwY0JFuzx444P9t7rgWK8w4AgnQ5NmR+9QHcZa3pUQQpDpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PPiGCI3qNDIf+LsRjFklfHHUahAl8w1V2CSrXw/LiOE=;
 b=RT5pFwgTbYwNs0r0mHKZY0djAH7aNK1oZFv/YnkGPqgpqm1D+07GHFb0uz7BbiIBG0YKI1/WuBF83xwX4p1thBTA/fez39B+Pl2egWY7r/vDBF5OfelnQR2tfjqVnREu7A0usOHgWTDr80mZMt0j5E+iNQZquAaSQBG+BV6SvFsdBkeb2ReqbpvwmeWy6NTP8k1puRD0WGj8+ewJRyYOW1SwZdECgx/+6eNL6GQnL3jRa7/sF9OEzM3twDiXe/aH51K8kSeF0dUnlslJO+wttpW5uXlxlUVnUP4WJZmNymdiq9Ww52Rf0LtG0dMTCPWeZYI+93nFBaibBM+yUdbHsA==
Received: from MW4PR04CA0206.namprd04.prod.outlook.com (2603:10b6:303:86::31)
 by CH2PR12MB4069.namprd12.prod.outlook.com (2603:10b6:610:ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.16; Fri, 11 Mar
 2022 06:21:06 +0000
Received: from CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::90) by MW4PR04CA0206.outlook.office365.com
 (2603:10b6:303:86::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.24 via Frontend
 Transport; Fri, 11 Mar 2022 06:21:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT037.mail.protection.outlook.com (10.13.174.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 06:21:06 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 06:21:05 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 10 Mar
 2022 22:21:04 -0800
Date:   Fri, 11 Mar 2022 08:21:01 +0200
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        <netdev@vger.kernel.org>, <sudheer.mogilappagari@intel.com>,
        <amritha.nambiar@intel.com>, <jiri@nvidia.com>,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net-next 1/2] devlink: Allow parameter
 registration/unregistration during runtime
Message-ID: <YirqTaKPzmKLy6EB@unreal>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
 <20220310231235.2721368-2-anthony.l.nguyen@intel.com>
 <20220310203348.40663525@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220310203348.40663525@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19eda49a-e6db-4ef9-d9a9-08da03275347
X-MS-TrafficTypeDiagnostic: CH2PR12MB4069:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4069396457DF7435A818BDC0BD0C9@CH2PR12MB4069.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TC2xtjb9LzYlZgE/ea8WYhNPsnUeZsw57qcadhZ4AHmgrNwD2pmxcZa9oPohyFx2tDH6Olf2mxjEzmPdv3zKb4L5jKcrS1+kAlf2e/g+C8u5X8Hj18ofTVu9Q7EzSg65OVSJynlX4QnvvYintvDCQJLhRULKfwn8wP7Y4iWF6J1yC+PTFKPqFKh5B7oPQIVuMEd396AqyAa3A/wrtGvd4nqJP/ICGyBAso437YnkSeSU2DQ6RQhkkhh9cVVyk0MwDGqpV3K4RpTktuk5Fy6HOAoU9dQyBJlcCv0gphewDQHzRt24h7xRgfwZX4ksomFtOGO4xIWJCaP3gCSsYSDl0NkpmYmm1dbE/TuFYiT7RP77Hy2o/pOFobMO6nsgNzztfjylDIk6ILsImYNkwJAaL8R4OtvbP+kKyc30HkQBkKvrznt4MkCphDmV13SXPyeHXZoBT3RuJGzDHxJWGY4x+mrJKADdG6DBbRaOJRGJfnvROqJInGNeHmAAg7VhSG5WscDbcBm0Js57hR2ojTlgAz5Y27YDSbkJAC5dtTvm5pA2rlAFkNrNHkhmVZQgTQmb6RbFlXngLMMzukVmPNlLTnbiDQ21bE1bAu5997NuorlWXOjMfSf+O8e5RLAFt8e0y9nxHOnsL+/X0wK0ZhMmbjwlBIlTKIdA9LIsaoukv/QHncaBvByzXtiuZ3pfvDIAHbjK3r6q5cRncC+uvmOTQNdhJClafpf6CQ5HR9l7vCOhhLktfTcDY0h7pLTZeUitaxD92DBnti6Zo7LdCCgwYH+LbObxcZGxt/CaoAV8MGc=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(7916004)(40470700004)(36840700001)(46966006)(70586007)(4326008)(8676002)(83380400001)(81166007)(508600001)(86362001)(9686003)(6916009)(316002)(6666004)(356005)(82310400004)(16526019)(186003)(26005)(33716001)(426003)(336012)(36860700001)(70206006)(54906003)(2906002)(47076005)(40460700003)(8936002)(5660300002)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 06:21:06.0922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19eda49a-e6db-4ef9-d9a9-08da03275347
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4069
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 08:33:48PM -0800, Jakub Kicinski wrote:
> On Thu, 10 Mar 2022 15:12:34 -0800 Tony Nguyen wrote:
> > From: Sridhar Samudrala <sridhar.samudrala@intel.com>
> > 
> > commit 7a690ad499e7 ("devlink: Clean not-executed param notifications")
> > added ASSERTs and removed notifications when devlink parameters are
> > registered by the drivers after the associated devlink instance is
> > already registered.
> > The next patch in this series adds a feature in 'ice' driver that is
> > only enabled when ADQ queue groups are created and introduces a
> > devlink parameter to configure this feature per queue group.
> > 
> > To allow dynamic parameter registration/unregistration during runtime,
> > revert the changes added by the above commit.
> 
> I'm pretty sure what you're doing is broken. You should probably wait
> until my patches to allow explicit devlink locking are merged and build
> on top of that.

Yes, it is broken, but I don't see how your devlink locking series will
help here. IMHO, devlink_params_register() should not be dynamic [1]. 

Thanks

[1] https://lore.kernel.org/all/YirRQWT7dtTV4fwG@unreal
