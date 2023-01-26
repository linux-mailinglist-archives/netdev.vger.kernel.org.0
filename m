Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFFA67D2D5
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbjAZRO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:14:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjAZROZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:14:25 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A10188;
        Thu, 26 Jan 2023 09:14:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3y8lPUYp9HNyeXfuRGES7AGS7MLeILWSmMoySGoTp9L/YXInXKBFzgIpYFSFHaXvWl/Y8ZDy60DvrypqTvfRVC8AvfaZ6n1i5mJRRnfIAODAvqet7UZK6adN0crbWyoz+dO6RGa9YSw38fs9pvkJyM8Vl2Hps4ANp48CEWO15JbA+Aq2WnTYAfZdDOxW5+vmPA4nzh/ONcMcZLAO+EdTnqpFRVXYxi6/HRI0xR9vgPH16PWpyS16tbbY7jbG1v3J3qkUUmU1QPh6yja9sPDUy0rHoj3qWuMiD2WyKjGED1Mbyctz+a2Rk9U9c/VE2ULYdufGFQ0co3mmO+jKGGlCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MbxFnNkFDnYVhKeQNv2k6vVRhn+PbeLDx6w031StdtM=;
 b=hPE0l1GOhdqBIB4xuGfvQI05HhFG0NOYYNGtCrQWZs6uo3QvEb7dmZQ29TMKXfzKMAMiFd2Cd+54EFN2I4OrwsVnhISRsVG+DhlQ2DByBCxMXGLMVduucOdVTR3sHkou9yr+Sv9OojtI/TXQDoSsYYwTIg8rzROWd60aqx4WqzzD+ri7ub9nrHvVZ4USa1JheMnvdWLiJGCb6Tv21tN8Nxj+woULwJyrrU2n/wcWxwTWg0KcZRX5LcdLWwlMiW3OQSZUjXPLXb+cb8al7thxCT7swV9vl6bpxaQ7xCnw74JTr6s+pE2Sx0Otr8+iaPVe3hjAkHAVBRqa8+ph8GHOMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MbxFnNkFDnYVhKeQNv2k6vVRhn+PbeLDx6w031StdtM=;
 b=Y2MqusgkjKR6kJurS+Dy7k0L3Q9DbRU4YF4i5Ctj/Tqchh/t2JzW0ejlidScLOOtD02o9D59eqWkcyI2vDusNMIo5lSnxbHnON2UIKTuMAMH48TofPnpH6cX3Y6vnP71zYr3nuFlvG1te1GZ2kc6QsZD4R6WLDpuMbL5gwSNVHLPkKtQiG+9b6vzUC8V9DiTkzxaG5irupNjDrUQheNrFawCdZqWheZk6qJz1LKhYTFlcbY1146DZVIe6eEVnzdSBNUbj7HBboed+8O4rxDEKWCWUP+CbrC9cPlRpg898qk0fhrqQ1QeODjO+BchU9gcggl9/P9786UqBPmHKtjX7w==
Received: from BL1PR13CA0200.namprd13.prod.outlook.com (2603:10b6:208:2be::25)
 by PH8PR12MB6722.namprd12.prod.outlook.com (2603:10b6:510:1cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:14:21 +0000
Received: from BL02EPF0000C402.namprd05.prod.outlook.com
 (2603:10b6:208:2be:cafe::1b) by BL1PR13CA0200.outlook.office365.com
 (2603:10b6:208:2be::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.7 via Frontend
 Transport; Thu, 26 Jan 2023 17:14:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0000C402.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.10 via Frontend Transport; Thu, 26 Jan 2023 17:14:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:13:53 -0800
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 26 Jan
 2023 09:13:50 -0800
References: <20230124140207.3975283-1-vladbu@nvidia.com>
 <20230124140207.3975283-7-vladbu@nvidia.com>
 <20230124214210.32ac7329@kernel.org>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>, <pablo@netfilter.org>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v4 6/7] net/sched: act_ct: offload UDP NEW
 connections
Date:   Thu, 26 Jan 2023 19:12:56 +0200
In-Reply-To: <20230124214210.32ac7329@kernel.org>
Message-ID: <878rhpfcc4.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0000C402:EE_|PH8PR12MB6722:EE_
X-MS-Office365-Filtering-Correlation-Id: 5317c268-8bf0-407b-fa86-08daffc0c2b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B/ZL379nCwqFRdb6IMS7BnPiW04AU2rltRU/rhAIJYgR5K9ZJ4TRdqGhuD3vGWupXFyHG+655wRCLNoxBqldbNLE/8cf1Ef9sX707zxxS2cH1h8ZvIFCh9+Lv6/wdXGDMQqb82T4/uLqrAaEIKUGCOkeN8MlAx134/+wYTm9u6aCzrj+YmOy+HVL1bWjlYb4OhTPDnZD2VAIPDofkFYpk5RDbf7EEBjjKcFrVtfEKfMmAk4ov5WbceZY4ePV0DOo+jkMWLMalye+RF5Tnnau40/Q5v57EnHPbesZVpGh5b6SFps4A694VXxJ4QS4La/DzsKQjtrFSQC2UkkhYaU457cpTlblzNq2tOFb++RifHiNIjJA7EnHVaL1fFMAc1MesVnQ9iazD3VY2WF60UrDiWSAaAzqmf843BQyFCpx9XmJzmE02bsNjbmQkO8bdZiCiprlN3zAedrJA1IJLgWK/eNSkwyhmnORU3TxHFC9xdOgt70z6lwv8COPvTMt2fUee6AJxh2g4E3zxNZT160WcaB3ft8CKLvwRI3/jpsO9sGynwxh7jBi6JnzriDLGWCfDY0+ZuBPLVHIqeLmSVcPZykkH71hsiDxWRo+XAEEnrMUKYZhx9yTKZ+NC+3toRjpXq5mj8WtXThq98jVArvKPzzlQlk8sDOWF3eAoDdmeJ9VpXRP/p0TKj1/kHlPfz+URKu+Py75ejDEe5uCHOETlA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199018)(40470700004)(36840700001)(46966006)(47076005)(54906003)(8676002)(36756003)(40460700003)(7696005)(356005)(40480700001)(86362001)(83380400001)(7636003)(36860700001)(426003)(2616005)(336012)(82310400005)(186003)(16526019)(26005)(478600001)(7416002)(5660300002)(316002)(82740400003)(70586007)(41300700001)(8936002)(6916009)(2906002)(4326008)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2023 17:14:18.9653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5317c268-8bf0-407b-fa86-08daffc0c2b0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000C402.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6722
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 24 Jan 2023 at 21:42, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 24 Jan 2023 15:02:06 +0100 Vlad Buslov wrote:
>> Modify the offload algorithm of UDP connections to the following:
>> 
>> - Offload NEW connection as unidirectional.
>> 
>> - When connection state changes to ESTABLISHED also update the hardware
>> flow. However, in order to prevent act_ct from spamming offload add wq for
>> every packet coming in reply direction in this state verify whether
>> connection has already been updated to ESTABLISHED in the drivers. If that
>> it the case, then skip flow_table and let conntrack handle such packets
>> which will also allow conntrack to potentially promote the connection to
>> ASSURED.
>> 
>> - When connection state changes to ASSURED set the flow_table flow
>> NF_FLOW_HW_BIDIRECTIONAL flag which will cause refresh mechanism to offload
>> the reply direction.
>> 
>> All other protocols have their offload algorithm preserved and are always
>> offloaded as bidirectional.
>> 
>> Note that this change tries to minimize the load on flow_table add
>> workqueue. First, it tracks the last ctinfo that was offloaded by using new
>> flow 'ext_data' field and doesn't schedule the refresh for reply direction
>> packets when the offloads have already been updated with current ctinfo.
>> Second, when 'add' task executes on workqueue it always update the offload
>> with current flow state (by checking 'bidirectional' flow flag and
>> obtaining actual ctinfo/cookie through meta action instead of caching any
>> of these from the moment of scheduling the 'add' work) preventing the need
>> from scheduling more updates if state changed concurrently while the 'add'
>> work was pending on workqueue.
>
> Clang is not happy:
>
> net/sched/act_ct.c:677:12: warning: cast to smaller integer type 'enum ip_conntrack_info' from 'typeof (_Generic((flow->ext_data), char: (char)0, unsigned char: (unsigned char)0, signed char: (signed char)0, unsigned short: (unsigned short)0, short: (short)0, unsigned int: (unsigned int)0, int: (int)0, unsigned long: (unsigned long)0, long: (long)0, unsigned long long: (unsigned long long)0, long long: (long long)0, default: (flow->ext_data)))' (aka 'void *') [-Wvoid-pointer-to-enum-cast]
>                 else if ((enum ip_conntrack_info)READ_ONCE(flow->ext_data) ==
>                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Thanks, will fix it in v5.

