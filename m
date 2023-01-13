Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA56669E64
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjAMQml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:42:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbjAMQmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:42:17 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8A4639B;
        Fri, 13 Jan 2023 08:40:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmTmVJO4X32f9y7JqfYGS4rNXV+kNXvr+YUTYVb6UIIEieLuJJszWzUtwVkG2ftXmVXxYCuwJwTI0NxGtVHsdcZtlfon5Ymax4oj8IlNun1bk+qym4W/b8Nekthygtv7z+gE2vGtEFi/0RZUi6vM/jOK/eGooDTbxlPGF7+tV2lK8VfQZRAg4h99R3JQwklXf5mwvsoE9lXP4ficUAjZcJFaGwqhVRhqPoUyJraFJwy9Qm1kaKzpa734xGfW+1SPinRdpETJ1RemqpFBce8pPVG1hxNDPhKQsjx852vENns9hGH5r28WssXDwXwSxcf0y8CibiXAtKC379IH0BOSsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yNFI1ODvT1qxWxuUYeT6CbLyos3m+5BrA5L0BY6iWEc=;
 b=HOEkUpctNyNckRLZTFXkF9DvdKAdMXzTC4hN5xo9JPkYU1uCGKQpX//iY6C2Vt4XpjWgfhXcLvbuqBljnKjkekoNsa6zldYwgaup7Lke8r2yaPJgXd1pkCblXFzzqjmJ1zKfr+gHP/LVuQ9DZ2U+rq/tbCXGqs+Ahu2QnQqbGhwmXWPJaxhCkYto5eZMInoEo+BB9I2bsmn8QJRQlDuln1xr6l1PQ24L8R4kmJ8J/jzwEdzVXWx0C5ndf0qfy+G8q+vAmvjxSswcZVUxS0BjXGvjHt7LbXcg5qVJmVsAjP1H1TMnPjZyirFQEpYLg56nVBpIH+kXv7EzRZLA1zs35w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yNFI1ODvT1qxWxuUYeT6CbLyos3m+5BrA5L0BY6iWEc=;
 b=g889N5AYG/onY1r49SbbU9cDImXgFl8sqlKP0/MBTg3nN/sisooAXWM40sIQvDMhUmh3y+WCX9Q3wib2eYBLG9bRh17SGThkIsOwxIXsdtsKuETYNcZMxNQtNeOchrbNhRLpV6dNoF4x8xBBPXbc35RzVYVBz61+VjA1bGLkfHghitIFS2w0DR5KRz3u7gx5lE0tUx15GzS/qFn04cVl5kUsSiqx8EfIPR1jPmmUVJlmsB/jzUl015MJ18d+GlLA+ddqxuVbMAxmRsm5G3of4LL1fdjQeO79ogGsqseQf9zpZ7FxDMVtZ7SzKzGjj2VUSVAWhgQ8Qio8D1+GzBnuHA==
Received: from DS7PR03CA0106.namprd03.prod.outlook.com (2603:10b6:5:3b7::21)
 by DM6PR12MB5023.namprd12.prod.outlook.com (2603:10b6:5:1b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 16:40:42 +0000
Received: from DS1PEPF0000B077.namprd05.prod.outlook.com
 (2603:10b6:5:3b7:cafe::59) by DS7PR03CA0106.outlook.office365.com
 (2603:10b6:5:3b7::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.16 via Frontend
 Transport; Fri, 13 Jan 2023 16:40:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000B077.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.11 via Frontend Transport; Fri, 13 Jan 2023 16:40:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:40:35 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 08:40:31 -0800
References: <20230112201554.752144-1-daniel.machon@microchip.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Daniel Machon <daniel.machon@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <petrm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/6] Introduce new DCB rewrite table
Date:   Fri, 13 Jan 2023 17:11:50 +0100
In-Reply-To: <20230112201554.752144-1-daniel.machon@microchip.com>
Message-ID: <87wn5qxu9u.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B077:EE_|DM6PR12MB5023:EE_
X-MS-Office365-Filtering-Correlation-Id: fdbe7ac6-0666-4e11-d518-08daf584e90b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J2tlInTGlRBpGOIrFGVCpo0vw5kJGa9e529yEljVKNl7q/r7chHfvUm/Mtler9EersQWIgmE3yovBQcOKE+RVHxqSEFles4j2koqrFVxyS+rec3lrp2B8HFeRRe7BTeJEPUP7LkxGbQ0oXVZgalBvDr/Sdjg3J3bJHQCL937zNXpM4c3/Yb/AQ1fgdnuiQBbIanmtP4iEzA6t2egNiJovcy/geaBAd9+iQrBwfFdr2f2X60IB5h9t0ESvLBVWRd4RRBhh49l9PfvMibAPTmRA1FNDgfmwqVeXCGA1ZOjHI7IgbWJ6ha+y6eAq9wfMxKw7OVg06oGq0MlIUZhYYmztpEgsb3C76ukZEMfFvOdp1rZsqvotj4KWNNqyIkZbhnspd8TJNhYFv0j8NKHh4wOwZz9g/mHEBp2fGBuddl+PCGg/+ZwAl/DJNHFhmU82EeNw/e8w+lE0/VUecH5fN7NKBgfodPhz6PEZu5y539pZm68ljf5ty9NBm8JOI+bfwfwqJloy4MWu27uKTWGJYFUiRmjdnq1iUr3/5L0i5Oo+TZOyccTLt7uS0fEjb+5bTNBaP7j039mLEAbxRn+3wIxDKBSJnxcvsEIjOQsS6THgeqDDiKslu8HrMiijUlp4eSCGsq9JqxeI4/N6iJklX8gGNUNaunmzsc4UvUWbGWfIXR7rW9OiGcyPgLrPtwSym4HPyzWj53bDiaAdT4s8MakyQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(70586007)(36756003)(2906002)(7416002)(82310400005)(7636003)(5660300002)(8936002)(356005)(41300700001)(47076005)(83380400001)(426003)(36860700001)(82740400003)(66899015)(54906003)(86362001)(70206006)(6666004)(8676002)(2616005)(40460700003)(186003)(316002)(40480700001)(478600001)(26005)(4326008)(6916009)(16526019)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 16:40:41.9139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fdbe7ac6-0666-4e11-d518-08daf584e90b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B077.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5023
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Daniel Machon <daniel.machon@microchip.com> writes:

> There is currently no support for per-port egress mapping of priority to PCP and
> priority to DSCP. Some support for expressing egress mapping of PCP is supported
> through ip link, with the 'egress-qos-map', however this command only maps
> priority to PCP, and for vlan interfaces only. DCB APP already has support for
> per-port ingress mapping of PCP/DEI, DSCP and a bunch of other stuff. So why not
> take advantage of this fact, and add a new table that does the reverse.
>
> This patch series introduces the new DCB rewrite table. Whereas the DCB
> APP table deals with ingress mapping of PID (protocol identifier) to priority,
> the rewrite table deals with egress mapping of priority to PID.
>
> It is indeed possible to integrate rewrite in the existing APP table, by
> introducing new dedicated rewrite selectors, and altering existing functions
> to treat rewrite entries specially. However, I feel like this is not a good
> solution, and will pollute the APP namespace. APP is well-defined in IEEE, and
> some userspace relies of advertised entries - for this fact, separating APP and
> rewrite into to completely separate objects, seems to me the best solution.
>
> The new table shares much functionality with the APP table, and as such, much
> existing code is reused, or slightly modified, to work for both.
>
> ================================================================================
> DCB rewrite table in a nutshell
> ================================================================================
> The table is implemented as a simple linked list, and uses the same lock as the
> APP table. New functions for getting, setting and deleting entries have been
> added, and these are exported, so they can be used by the stack or drivers.
> Additionnaly, new dcbnl_setrewr and dcnl_delrewr hooks has been added, to
> support hardware offload of the entries.

Looks good to me overall.

I just want to add that to configure rewrite, mlxsw currently reverses
the APP prioritization table. That's not ideal, and is lossy as
well--certain configurations simply can't be expressed however you set
up in-driver heuristics. The proposed interfaces would make
configuration of the rewrite functionality very straightforward.
