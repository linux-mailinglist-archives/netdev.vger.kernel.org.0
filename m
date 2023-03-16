Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611396BD152
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbjCPNtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjCPNtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:49:53 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043514EE4;
        Thu, 16 Mar 2023 06:49:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=koNUZXxT8ehdq15NLKAIgqK0YPTxzwBs6iYPRyjaGABUu+GgClNUMMU113KFLL6rZIRCU5ddZhd8R0JAm3mWQs6CrHSiP+BC/avkqmDJYOKY8BjkPGVgJCooEJBxFBLj/OhY0sU/IeZ+ydIUROA+i1fZKld8ktafO++Lng16+0ra/vwtnSDaK5DQsuDM8OXHtRBul0pOFR6Mpo+wkvV3yt7L6+jbDWT4nDggKtqNbUtIaKxTDQpztUxG1LOEpE+17fC3c0P9hMCBK1qCjxkKCiXsoXvtkln3A/oLlFKQHr1tmiiqPwhXLO3oKPNzB1Sq8oqivTxq6BY3QaJDp3+QbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vphis5bi2r8pZINdzGZ3zDJdj5BMtBCTwC4FkVFtDKE=;
 b=KSef4EdvIXTVnR3bard8s2ycWXpcS4UBxXl6wweE8oI61Gj3fcFlktdiVrr59QvntZjqdRfk6yjgYfOKGUmsVKXEgz2CUUFveYaI73lP4or2xs5JQfaRZqD+br+2/Jc9MvfvUp9YZGOcLXv0oq7r8yYBLQuMCzgLfe2B1bY3OsZXc8nEvBWogsbaR2fQge5I78oMAHVrnGWyuQvuhOYNsG5Y6eyt+hi7rIaigFVfij0ehVppmPzEjL3dtQc3Lu7VdQdfMv7TMpXZl96VPWHZmYkTCPeZgVhTh0UgoTYTziGPLFdt7cepOCY7wp6KEgrdyQTmGLdfybHh7AZHfPRsUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vphis5bi2r8pZINdzGZ3zDJdj5BMtBCTwC4FkVFtDKE=;
 b=jI5iT5b8cL4gYgk8+z/AJ6oFUsL8gPriz/r5fCctzKNa3KYogDWvkkgmlW9CyjbZKo2llfPrgyMerUQ1Xoc2BMji88X9vp6fb+JG37Ima9nZafq6vET24J7CBtHHWk9274zxNLVfzHWd6wF5vgBo75NRaSHOd5fmI9PiHV3KlOqS4/GwvSIHX1gQZ1TjzcpyXtQErro/KjFNbGiV/rbjd9HzmnPr+X9W+iCZxPB42UFZX/7it9WGiO2c/DmyZGkms3HhJWEVLnKB/T7DqA5n45RaeIsWGZIn+NMLf+tbsTN7a+frgZpiNoJT5TPGuatSV9dnZLLk+JgwPmWsNZiuYw==
Received: from DM6PR02CA0076.namprd02.prod.outlook.com (2603:10b6:5:1f4::17)
 by BL0PR12MB4946.namprd12.prod.outlook.com (2603:10b6:208:1c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 13:49:46 +0000
Received: from DS1PEPF0000E653.namprd02.prod.outlook.com
 (2603:10b6:5:1f4:cafe::10) by DM6PR02CA0076.outlook.office365.com
 (2603:10b6:5:1f4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.33 via Frontend
 Transport; Thu, 16 Mar 2023 13:49:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E653.mail.protection.outlook.com (10.167.18.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 16 Mar 2023 13:49:45 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 16 Mar 2023
 06:49:40 -0700
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 16 Mar
 2023 06:49:36 -0700
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
 <873579ddv0.fsf@nvidia.com> <20230213113907.j5t5zldlwea3mh7d@skbuf>
 <87sff8bgkm.fsf@nvidia.com> <87y1nxq7dk.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        "Vinicius Costa Gomes" <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        "Pranavi Somisetty" <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        <UNGLinuxDriver@microchip.com>, Ido Schimmel <idosch@nvidia.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [RFC PATCH net-next] selftests: forwarding: add a test for MAC
 Merge layer
Date:   Thu, 16 Mar 2023 14:43:25 +0100
In-Reply-To: <87y1nxq7dk.fsf@nvidia.com>
Message-ID: <87ttykreky.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E653:EE_|BL0PR12MB4946:EE_
X-MS-Office365-Filtering-Correlation-Id: 017c6b17-e1d2-4cb1-0466-08db26254d8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJtXB9Lt5/9vHtew/+gIJsuHdyYA1FEJ7/+bfMrJHmwaEkeE11ZAzu0Za+bJH2nb7W+YgEEqsp8tBhp8t03CM6Rcl27E5nfJVrVPZHLI6Db1YF1NdGn34XAmpViPJzfiG+dlu5zRuIeZmj3VcIC/uqrD2e0hhGA/N4OFIMZNycMR9/LLfpWSBYZvvudXhEg4gyNVkt9UgtOB3m15DBzBvQpraw8ebL9XbvmoMP3Pj4Pl6VG1yTqW8bfjIlRCfgwKq8YYJmXIjdxOyXhsHjVI4lMZ0tK6pg15GFH77ZSUbOAJDkbPIfhhQv6KuDpI4NiiNi4urjuIB+sxLGFfHwjF5ZLQlfpuqbIKfhh7Ii+vhKgAOhwc4Wr3KLJQ2qDLn1li7HrsOQv608Ed3XFXbcL8WadoDCNpfuwouKriU4vErnpyaUEZVRHVJC72vBusIur+2qguvKvAQLug6xFkTw+zExWjKZkJT2zP9mJXsqXzQD0irxao9s/X/73YXcKmiyRxPNj4x+x3piV+69a6BNDiPMiwXJp6X25euAaMzrbF1gvEHTuhgBbDpwVyEWNs07B+4A1ab7QG19qu9loPvHkFvX04FqpgujAPVgzaCE0Vkm6bG8uUZ2RdM8rWAreP5O/+a/utQqIu1vKKgHBLPqf9dbuwit6fGlXvJaQ0iVHhgalesU2ptmtllY+3VXp05NdXs9HxzqDvyaIp2IPHzWh7KOt2NlFCO+4tGE9569LyQeE=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199018)(46966006)(36840700001)(36756003)(36860700001)(82740400003)(7636003)(7416002)(2906002)(6200100001)(8936002)(41300700001)(6862004)(86362001)(5660300002)(82310400005)(4326008)(40480700001)(2616005)(47076005)(336012)(83380400001)(356005)(26005)(426003)(54906003)(316002)(16526019)(186003)(37006003)(6666004)(70206006)(478600001)(70586007)(8676002)(66899018);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 13:49:45.8161
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 017c6b17-e1d2-4cb1-0466-08db26254d8c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E653.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4946
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> Petr Machata <petrm@nvidia.com> writes:
>
>> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
>>
>>> diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>>> index c6ce0b448bf3..bf57400e14ee 100755
>>> --- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>>> +++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>>> @@ -2,7 +2,7 @@
>>>  # SPDX-License-Identifier: GPL-2.0
>>>  
>>>  source qos_lib.sh
>>> -bail_on_lldpad
>>> +bail_on_lldpad "configure DCB" "configure Qdiscs"
>>
>> ... lib.sh isn't sourced at this point yet. `source
>> $lib_dir/sch_tbf_ets.sh' brings that in later in the file, so the bail
>> would need to be below that. But if it is, it won't run until after the
>> test, which is useless.

I added a shim as shown below. Comments welcome. Your patch then needs a
bit of adaptation, plus I've dropped all the now-useless imports of
qos_lib.sh. I'll pass this through our regression, and if nothing
explodes, I'll point you at a branch tomorrow, and you can make the two
patches a part of your larger patchset?

Subject: [PATCH net-next mlxsw] selftests: forwarding: sch_tbs_*: Add a
 pre-run hook

The driver-specific wrappers of these selftests invoke bail_on_lldpad to
make sure that LLDPAD doesn't trample the configuration. The function
bail_on_lldpad is going to move to lib.sh in the next patch. With that, it
won't be visible for the wrappers before sourcing the framework script. And
after sourcing it, it is too late: the selftest will have run by then.

One option might be to source NUM_NETIFS=0 lib.sh from the wrapper, but
even if that worked (it might, it might not), that seems cumbersome. lib.sh
is doing fair amount of stuff, and even if it works today, it does not look
particularly solid as a solution.

Instead, introduce a hook, sch_tbf_pre_hook(), that when available, gets
invoked. Move the bail to the hook.

Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh  | 6 +++++-
 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh | 6 +++++-
 tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh | 6 +++++-
 tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh | 4 ++++
 tools/testing/selftests/net/forwarding/sch_tbf_root.sh    | 4 ++++
 5 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
index c6ce0b448bf3..b9b4cdf14ceb 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
@@ -2,7 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 
 source qos_lib.sh
-bail_on_lldpad
+
+sch_tbf_pre_hook()
+{
+	bail_on_lldpad
+}
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 TCFLAGS=skip_sw
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
index 8d245f331619..dff9810ee04f 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_prio.sh
@@ -2,7 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 
 source qos_lib.sh
-bail_on_lldpad
+
+sch_tbf_pre_hook()
+{
+	bail_on_lldpad
+}
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 TCFLAGS=skip_sw
diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
index 013886061f15..75406bd7036e 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_root.sh
@@ -2,7 +2,11 @@
 # SPDX-License-Identifier: GPL-2.0
 
 source qos_lib.sh
-bail_on_lldpad
+
+sch_tbf_pre_hook()
+{
+	bail_on_lldpad
+}
 
 lib_dir=$(dirname $0)/../../../net/forwarding
 TCFLAGS=skip_sw
diff --git a/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh b/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
index 75a37c189ef3..df9bcd6a811a 100644
--- a/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
+++ b/tools/testing/selftests/net/forwarding/sch_tbf_etsprio.sh
@@ -57,6 +57,10 @@ tbf_root_test()
 	tc qdisc del dev $swp2 root
 }
 
+if type -t sch_tbf_pre_hook >/dev/null; then
+	sch_tbf_pre_hook
+fi
+
 trap cleanup EXIT
 
 setup_prepare
diff --git a/tools/testing/selftests/net/forwarding/sch_tbf_root.sh b/tools/testing/selftests/net/forwarding/sch_tbf_root.sh
index 72aa21ba88c7..96c997be0d03 100755
--- a/tools/testing/selftests/net/forwarding/sch_tbf_root.sh
+++ b/tools/testing/selftests/net/forwarding/sch_tbf_root.sh
@@ -23,6 +23,10 @@ tbf_test()
 	tc qdisc del dev $swp2 root
 }
 
+if type -t sch_tbf_pre_hook >/dev/null; then
+	sch_tbf_pre_hook
+fi
+
 trap cleanup EXIT
 
 setup_prepare
-- 
2.39.0
