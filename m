Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4C95B5E4E
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 18:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiILQeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 12:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiILQeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 12:34:13 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2062.outbound.protection.outlook.com [40.107.101.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C9C1D0C6
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 09:34:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XJmTlH01MPg85bXcpfJSQ4kZgTs7TzJKYq/x34UxDT6ytZuxGJIdBRiYAOPhPnTMsoMuno58cDP8Cdx6UGxptkKzYaytegxoHAMpijjz/9Rq1JoXmAev4litBSGfmdfH6y+yxREHIKazswbf1dwsrxKjXpTyOKjw2E5huIskioHA05PNUFBthxT8vwOPPgKIyX+9DToXpCEUGSWiGtcYLXGwxv0Va2VdFBnrQj4frqMGpZ6xMXg4OxckwZ/oU7VEpF91Wpj2WXI+LOZGsQSl1QCCZg+ikM3JNXvbux2tuH+WvoTJ3XY6xu7E77ofHtdio26I+y5lKqfd3qletWYZJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wev1CdTRdkrHnC4DvC2RFF240CwUv4Mv6j736UkfxcQ=;
 b=YrABK5CxbFZvCb0KPYBIQzvrmMXaHSc+fuAXMRS3ZZ1y+iFBTCZUnL8KeAiXEnpSWdkPaPB6p2y/Fy5Rqm8frcjp99DZalOaNY/ExxS78+SeufeDnjLz78LK4Ir2lNYz1IApG/onZCpnPoptBltgVF66yap5zSp36aeVbaTLtpwvy8kxM4POtMJcsWXbjQBFUw39LRRn76c+Kuifpgj4GrSMqNkLlnKyCXiX1/eD3f1NFPv6JkpnTrGbtbu61ASXK4oIj/rFM4AhBi07f+oIjeIGHAN9JtK6WL9GIKe9DCEjrQ/+azjWU6oRWrr4NBBPBFfhCrESjBjD/aEaXHl/qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wev1CdTRdkrHnC4DvC2RFF240CwUv4Mv6j736UkfxcQ=;
 b=ebMXK+6x7DiGhLeWWwDitL78q7+2gaDnxtiKK4Bk4pHYNRuVcRKX3zQmYXWUfZvyFhFSpK3hFOB7fzEF36fqyOpFp4ybunwcar6Mno5yc92x/QoVlb9otMggnkz2Z3xx6Qzdu5c3z3/EeamMFdDkeljWjQ0mzDzhjvkBsp9BzyQTXrnDVp3R9FO296Y358rsQtynJ0Vplwdk/wbUiq17TXo4LQWlofqsAzp6A2tk8jguvLxcie0ZphipHpnl1gQU7H8sOz/RL3w6KPt4y5pxSJa9ZwOVABxrxug/uwtuLUe/USfBOfI5a3dH8x9LzEoWCUlT0cL9up61iMyUwrqAmA==
Received: from MW4P220CA0028.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::33)
 by BY5PR12MB5512.namprd12.prod.outlook.com (2603:10b6:a03:1df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 16:34:10 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::bc) by MW4P220CA0028.outlook.office365.com
 (2603:10b6:303:115::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19 via Frontend
 Transport; Mon, 12 Sep 2022 16:34:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Mon, 12 Sep 2022 16:34:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Mon, 12 Sep
 2022 16:34:09 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Mon, 12 Sep
 2022 09:34:06 -0700
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
 <20220908120442.3069771-3-daniel.machon@microchip.com>
 <20220909122950.vbratqfgefm2qlhz@skbuf> <Yx7b5Jg051jFhLea@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>,
        <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <petrm@nvidia.com>,
        <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Date:   Mon, 12 Sep 2022 18:30:08 +0200
In-Reply-To: <Yx7b5Jg051jFhLea@DEN-LT-70577>
Message-ID: <874jxceemc.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT055:EE_|BY5PR12MB5512:EE_
X-MS-Office365-Filtering-Correlation-Id: 5064e0ca-27b7-496a-1ed5-08da94dc9ecb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qU0rlAqCPRX65poh7PtuBJPr57wthW+mOT5tqzxWC/z98aEPLcFpXL+nnaEUwIfGYGGPhX4r8I3AkJQw5TbAuakgiRGh/zLOeyzTU7S1e7AW27lvyIXqA+IK8ZcNppXoIpZycvulFypjFt+XPGroeOzOE6gS8pVTYAurCY4fRxzpoDf5NWW5QiPGsfgj8VIH2MlLWJE+cfHzIWvvl0fXFtIxef1B8NPzVfvTvIbwHWwybgST+ebikdEgBloQ0QVp5BrOqbtiV5ln/sutPoxfYOVtXHTQm3wGDy30LUBya2ekkne7bRsLa+gH+cCI6P4XCTlYPU3VTEBlUvdF79P3lKjE5YtJeAMozNBipp0VPu5Hn3EwSiOJFN7DxOFlrwh/yY3CGcRYK+t8DsOh1F8GqG7J1iFzBlqKGbYzbEYzXrXH/xTAfkUtr4JOUmC5b3EwhsF+dFS7PQSTA4QlWUJCe/shuil7RJ5j0DrIXo2Bo0tGMI/OcsO1Q55ezKLK0d8gfeIVmWh25t8wihHBtxEs7exJhdntEpssM2oOOgsWiIIvt/aI7MzAvfLbY8liCc9YIxDZADfzqsVjPf6qmJe539wWQ8RyMcWFdNaJcbtBPqno1GbZKBQIqxaT1l24DOT3TDFwX0rBbgSNr8Rdo5ERe0ZKFbgRsnNp+GqcCyx8/6PplGHH6be0AL3kfcuAsjotv9KtXgGfBPHR6YztDbS0jjaPCFkFFZq4GdBkk5ayCLARV1WyAYO15Gc9QNoFpLYUjyZ2HgWkhigEf1jjku/4Y8ns381CJ6aeVN9Ls/w2sZY=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230017)(4636009)(376002)(136003)(396003)(39860400002)(346002)(36840700001)(46966006)(40470700004)(70206006)(70586007)(82740400003)(54906003)(81166007)(356005)(40460700003)(336012)(2616005)(186003)(36860700001)(86362001)(5660300002)(8676002)(2906002)(426003)(26005)(36756003)(40480700001)(16526019)(47076005)(83380400001)(41300700001)(8936002)(82310400005)(6916009)(316002)(478600001)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 16:34:10.3080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5064e0ca-27b7-496a-1ed5-08da94dc9ecb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5512
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

> Den Fri, Sep 09, 2022 at 12:29:50PM +0000 skrev Vladimir Oltean:
>
>> Let's say I have a switch which only looks at VLAN PCP/DEI if the bridge
>> vlan_filtering setting is enabled (otherwise, the switch is completely
>> VLAN unaware, including for QoS purposes).
>> 
>> Would it be ok to report through ieee_getapptrust() that the PCP
>> selector is trusted when under a vlan_filtering bridge, not trusted when
>> not under a vlan_filtering bridge, and deny changes to ieee_setapptrust()
>> for the PCP selector? I see the return value is not cached anywhere
>> within the kernel, just passed to the user.
>
> Therefore, in your particular case, with the vlan_filtering on/off,
> yes that would be OK IMO. Any concerns?

Yeah, it would make sense to me. With the 802.1q bridge, the reported
trust level would be [PCP], with 802.1d it would be [].

As a service to the user, I would accept set requests that just reassert
the only valid configuration, but otherwise it sounds OK to me.
