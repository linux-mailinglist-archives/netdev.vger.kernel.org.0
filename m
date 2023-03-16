Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3C2D6BCDA1
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 12:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbjCPLKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 07:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjCPLKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 07:10:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DB6B5B5A;
        Thu, 16 Mar 2023 04:10:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbm50yMbAk1b6IsIuhT4SX8RfdzVACBkgj8pCtzxpIqSC6b86JwuMJoyGEij+SU3bcBM+VY6vqHBbFrJESRC1VXi5AVcoqu0ARW1TTLwcp5aEkovMEv7RnB2Sk2gIv0fmy0hx6d5t8dbPHKQ9yv5bmQ1LwD0g83I5Pz3bYfsyJTgXZ3UeKm3tJCRwSOfvVrerTLkxBR0DXxR8nid4T+yPyQZJ93fqukeAiYV4Yw1DjCLGDcYVxoaUWGSviHLKiZ5mwaqof4dhv8bwxixAsHeRDcsbxBMedU6GYjrNLHgJHfMHqzL174NyfYkqLaL+lvMFcH3c8gi+g30Mu76nf7R4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4DA2Jjf8jgaKEuNylS5mgtUE2Lt/x2oF4XQcXPfqHl4=;
 b=kNKfHrL2fU9nfSWmrYsjXUQl5oX/LSURX+MTcNAQIU/rTEm/2rsRgaZWFHu3gf+T3I/1fiw1jAN4se7T18zdanf2cuSXwvSl81IMo/rKg3Pmn9tQ1hkEZkjnMGy37Fapm0s3F8HqaL/zA/XRJYeK04tuyjHLmPl7FrDjKY02niWYvqmSKve8MKDCV34TQ0D354386zMzvU35WGmCJn7g2V9PiQ+1ujh4IThLpMT+N2CKWPfN+xGvFQlcPjHmuDT0KePZXGxTGF0itAFtGXf+nyoGfgThWpeUoiIBQvENpRT6L1brNEVjcbAyHHZt7ZE+jTspin1Q4PxE4hRLA/64iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4DA2Jjf8jgaKEuNylS5mgtUE2Lt/x2oF4XQcXPfqHl4=;
 b=IUIyp4pLE9LhBLvIpzkTkjmgQP9r2YYG1HhduGDZxHFeg9rTbPfJyp/PfgBubykNMicOu84hgupyvNAAIRRJyHwynoqCKvDVRmjK7UiyqqgKuj9FXlKFpe8f2Id5DlX24WnUwuJSryfCICnUI5WO7NRo1fnoeIBDbrYbb/ihAlF1JRcDppU/MdIbcaE3OymqRizzUbgsSwO1XR/8RNPdH3sclcJ7f8kUU1/mkityrH1HmyWyOkBBh6o8S/45FDLYh6n/5jk7DkRd2qmQNhRcKJi4yx+/OVpn4uGUmeVR1DjTSAojRfSJAT25Mb+bQccULHsI6gR+4dFkJnJjOzSybw==
Received: from MW4PR04CA0111.namprd04.prod.outlook.com (2603:10b6:303:83::26)
 by DS0PR12MB7557.namprd12.prod.outlook.com (2603:10b6:8:133::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Thu, 16 Mar
 2023 11:10:48 +0000
Received: from CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::2c) by MW4PR04CA0111.outlook.office365.com
 (2603:10b6:303:83::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31 via Frontend
 Transport; Thu, 16 Mar 2023 11:10:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT056.mail.protection.outlook.com (10.13.175.107) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6199.18 via Frontend Transport; Thu, 16 Mar 2023 11:10:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 16 Mar 2023
 04:10:38 -0700
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 16 Mar
 2023 04:10:34 -0700
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
 <873579ddv0.fsf@nvidia.com> <20230213113907.j5t5zldlwea3mh7d@skbuf>
 <87sff8bgkm.fsf@nvidia.com>
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
Date:   Thu, 16 Mar 2023 12:10:12 +0100
In-Reply-To: <87sff8bgkm.fsf@nvidia.com>
Message-ID: <87y1nxq7dk.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT056:EE_|DS0PR12MB7557:EE_
X-MS-Office365-Filtering-Correlation-Id: 0311fd5a-1390-4547-38c7-08db260f18c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8yxPBXAN6Q+pxzPWbGCSu1S46jvzfcmHIBP18yP9XOPEf96d4lF3POCi3H1S7J73clCMUT33idXEbWxpuJ/dmO+/INFtRJgO/y9ob+/ox6lBbpywx3EAdvaGgQOiPahwipHquRAsTgpFP9hLYuHzwFEN76rTl0SOB3Z9AoELtFzNSjeSLibl+W3pXK3CGmT8UUoKA2kJfiGxShxOn0pltVgPADenvoS7HbOQuiFLpopZyydNBZtXcTUdo4ghVX73XxATF5yi6PXV6PG6JOyQvMnAiTWJX9JfDulHYN5qXgUuGOZ4kMuxluLn/2ny3JZQP7c6pXgomzfMHHGhqPA/l8MGktEDNwOYKPRmW4EuKE31M/yk+Lhm6wlK+Cwhf4EknrSqszDqueVEkSW8MJ1C9uLpnnVjUHXVx6zQws/tw6Z33i8E2baKE+RC1CpFyZzjyKdpSLEcjya+FSY1pHsxLVadBSqmIyH+4v0X0mk2MycECT0Orc0qyzxbGeHsShISsYqbHfyYJY/+VvwfRzrMAUJGpfZJHHHEAgvvxrbSqJ/sFgF+BWwQxMroIoSueqO4sU5WFTRnKo0bDafTHM/6FpK0HFlD5Nhizo2t8l+ZRzSevm7oVV3MVVySdc2y0ZgOGu1+30TEBsCR0wN7dIooIOvumgoPiM08iUtHGK943BOKxPWxE7VwekfYaGRuBVMU4yIYmuyglmMy9G+P9TNOR0R/zJAwB6bfGn1hzMrsUXRFwuwb/LM3cmdMB4xisfbA
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(136003)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(356005)(86362001)(36860700001)(36756003)(7636003)(2906002)(82740400003)(6862004)(41300700001)(7416002)(8936002)(6200100001)(5660300002)(82310400005)(4326008)(26005)(40480700001)(40460700003)(426003)(336012)(83380400001)(16526019)(186003)(54906003)(47076005)(37006003)(2616005)(316002)(70206006)(8676002)(478600001)(70586007)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 11:10:48.4128
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0311fd5a-1390-4547-38c7-08db260f18c6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7557
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

> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
>
>> Hi Petr,
>>
>> On Mon, Feb 13, 2023 at 11:51:37AM +0100, Petr Machata wrote:
>>> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
>>> 
>>> > +# Borrowed from mlxsw/qos_lib.sh, message adapted.
>>> > +bail_on_lldpad()
>>> > +{
>>> > +	if systemctl is-active --quiet lldpad; then
>>> > +		cat >/dev/stderr <<-EOF
>>> > +		WARNING: lldpad is running
>>> > +
>>> > +			lldpad will likely autoconfigure the MAC Merge layer,
>>> > +			while this test will configure it manually. One of them
>>> > +			is arbitrarily going to overwrite the other. That will
>>> > +			cause spurious failures (or, unlikely, passes) of this
>>> > +			test.
>>> > +		EOF
>>> > +		exit 1
>>> > +	fi
>>> > +}
>>> 
>>> This would be good to have unified. Can you make the function reusable,
>>> with a generic or parametrized message? I should be able to carve a bit
>>> of time later to move it to lib.sh, migrate the mlxsw selftests, and
>>> drop the qos_lib.sh copy.
>>
>> Maybe like this?
>
> Yes, for most of them, but the issue is that...
>
>> diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>> index c6ce0b448bf3..bf57400e14ee 100755
>> --- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>> +++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
>> @@ -2,7 +2,7 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  
>>  source qos_lib.sh
>> -bail_on_lldpad
>> +bail_on_lldpad "configure DCB" "configure Qdiscs"
>
> ... lib.sh isn't sourced at this point yet. `source
> $lib_dir/sch_tbf_ets.sh' brings that in later in the file, so the bail
> would need to be below that. But if it is, it won't run until after the
> test, which is useless.
>
> Maybe all it takes is to replace that `source qos_lib.sh' with
> `NUM_NETIFS=0 source $lib_dir/lib.sh', as we do in in_ns(), but I'll
> need to check.
>
> That's why I proposed to do it myself, some of it is fiddly and having a
> switch handy is going to be... um, handy.

Sorry, this completely slipped my ming. I'm looking into it.
