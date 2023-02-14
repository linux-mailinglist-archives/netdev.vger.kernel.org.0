Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6E0A6962ED
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 13:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232338AbjBNMCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 07:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232080AbjBNMCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 07:02:53 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383D7FD;
        Tue, 14 Feb 2023 04:02:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jDW0KQtb5iIbJiYk0+ubzG/V3YqYU0T20YQ8TwLF0wJNIKmwqqnTRT5gR2fI1GQJPnRSYOiYL9XnNdPC7dvOWs/vuLq4jCPvJNCj3ESAbFA0P4K8vOxAm7Ak7XTlVM+4pbjqU7Equr1ki4rPgkaDR+BEw3Y8pL3/zWD613x0Ft831HLRUFpa6uX9fOvGWYKy5uYRyPPCZJuYDdiQRgPRy3dS5lGE1Sru66y4BupzEQrZ4l/eoemhWh2T1DYAkXC16qnOgniQCOfvdzBxbyavFfTSznssF3N645wUf/RHVxmjob1B1Gcfy0v8fUpGogRLK4d1EjCDWcpQQSqyDZyDlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VOjUaq16aeIsebYJe5km13hHw0cqSw8oytAk+RiujI8=;
 b=YO19iVgCIP+FSy0cP8niTt8O+34nfS4j3IBmkgA3s1jOmnj393+EQe+jmlNSt1UNGZpjY8XwMQkjsvyNzrmypUNxASmlZUNsRtGAH+qypJTqzXsZqDtGMHn+GuFYnBVR2lwGiYWYXPyOlhJiDP7VC0EYYpPYKJ9M+Q7ZdTqmYYomdlmusCLzEZVFBIS6KI03sLq9U+7mbo4q5mQ7zS+dejTazd5EuqSX00wkXpzx8N0UzFk0p1MpTYq7RwKHHseYVGGia8dFv+B892CNjFu6dBWt9cmtuAbolEzOl1PtG3L6wHSGiAv/l3n00fFPEWiDy04HdQTi9YiwtCuIF5gpng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOjUaq16aeIsebYJe5km13hHw0cqSw8oytAk+RiujI8=;
 b=n4Jodd8Mn9uJfrrzii5H/6qfCkyyD2ylgy5ueosQJmdgfPvFED24ulcVAKNQ//iO4PbuDCBvdBSDQ/IdyrVg7WO822JL514AaomexLwnctw6slpTHsnfI3rz+LwAx2B1WKVmzRKI+UhKqjrP51TC3LcesTxCMPJN4RP+c+/QHJuoXg+TPUSX41tjaS4+HZn5kaeJlV6+JiZbMBcWU0bGlPm+wVTKYlMPSNlavEppcJWaEvhliJiFz/qZ/ImseENuEFWzRS3WYoATOT+HiictI+pgBMJ/lHbkV8n5jC1g6TW+bt9oLXeKID8kHPxX0QkJNz7YP++B5XoiQoKMSo20vw==
Received: from BN9PR03CA0861.namprd03.prod.outlook.com (2603:10b6:408:13d::26)
 by CH3PR12MB7596.namprd12.prod.outlook.com (2603:10b6:610:14b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 12:02:47 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::e1) by BN9PR03CA0861.outlook.office365.com
 (2603:10b6:408:13d::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Tue, 14 Feb 2023 12:02:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.26 via Frontend Transport; Tue, 14 Feb 2023 12:02:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 04:02:39 -0800
Received: from yaviefel (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 04:02:36 -0800
References: <20230210221243.228932-1-vladimir.oltean@nxp.com>
 <873579ddv0.fsf@nvidia.com> <20230213113907.j5t5zldlwea3mh7d@skbuf>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Kubecek <mkubecek@suse.cz>,
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
Date:   Tue, 14 Feb 2023 12:53:06 +0100
In-Reply-To: <20230213113907.j5t5zldlwea3mh7d@skbuf>
Message-ID: <87sff8bgkm.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT025:EE_|CH3PR12MB7596:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e4e206d-3c1f-4d2a-513c-08db0e836344
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MtAMdq9hZEmdcThCtMpQSLjexkN0hQF579zHIpJk7SbmJaE9wv7HojzKZMa6HO1YToJlUMf/vjkozKXxZtlL7jGC1Gs8Jh5zrklY8fPbN2Ax50Mrrc/ZrCwG3HcKOh0uzjFEH0tu5fgQ2vj5Kg5J4OugP7/+pCTzxAK60L3oHhEHnbOtTPQ6FOgpAdajjc5DAQq1GpYm9nOQYtTZY9KOpbJ66WnaznzZtYwUmXGMbTHP6py4J2YcB/oyJ+0JpGhIzRsznKMM4FiXCBRSrkuBc8Z8Ccuc6uycCs6FMWbBqsMeXoDyaneyERO6UcppfrDwaUuMsUV2yjFGnS9Rq1Kce7h5wW4TLj40V/XyYnSbIX6qCHz43HHuo7weJ7mci/3a9mlRshHi6RSdhWqBeR/zcQ3McHr9nhsmjSh5ShxhofZYgLSw5TCtVRRdepTZK1I2VvpWKaCRlpRzC3LGzgjjhGqtulm2PsdZZdlyXm0cyZZufSF3obYoH+lkZOJIGpAH/GOT57pv0HrDPpwrP/+G6qLrWbWFRnAbcNyAXIJTLpmoiEWw7TLUx6mB2aV3INM/6+lCQHlOkQGq77k0tSLBCIsEAA1qPnP3nVynkZeCFVZj8Nx7uIc0GQVhLme6pVqUePNyqgCOkRC60aB7ADZtl/V1HqAWF5koltVUnMEdU1p+BSfPxnd9u88oaq7aXlju3aWIWj/dnZxHYVfz6xM1wQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(40470700004)(36840700001)(46966006)(54906003)(5660300002)(41300700001)(8936002)(70206006)(70586007)(6916009)(316002)(4326008)(8676002)(7416002)(2906002)(478600001)(6666004)(186003)(16526019)(26005)(40460700003)(2616005)(36756003)(336012)(426003)(83380400001)(36860700001)(47076005)(40480700001)(82740400003)(7636003)(82310400005)(356005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 12:02:46.9952
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4e206d-3c1f-4d2a-513c-08db0e836344
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7596
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> Hi Petr,
>
> On Mon, Feb 13, 2023 at 11:51:37AM +0100, Petr Machata wrote:
>> Vladimir Oltean <vladimir.oltean@nxp.com> writes:
>> 
>> > +# Borrowed from mlxsw/qos_lib.sh, message adapted.
>> > +bail_on_lldpad()
>> > +{
>> > +	if systemctl is-active --quiet lldpad; then
>> > +		cat >/dev/stderr <<-EOF
>> > +		WARNING: lldpad is running
>> > +
>> > +			lldpad will likely autoconfigure the MAC Merge layer,
>> > +			while this test will configure it manually. One of them
>> > +			is arbitrarily going to overwrite the other. That will
>> > +			cause spurious failures (or, unlikely, passes) of this
>> > +			test.
>> > +		EOF
>> > +		exit 1
>> > +	fi
>> > +}
>> 
>> This would be good to have unified. Can you make the function reusable,
>> with a generic or parametrized message? I should be able to carve a bit
>> of time later to move it to lib.sh, migrate the mlxsw selftests, and
>> drop the qos_lib.sh copy.
>
> Maybe like this?

Yes, for most of them, but the issue is that...

> diff --git a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
> index c6ce0b448bf3..bf57400e14ee 100755
> --- a/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
> +++ b/tools/testing/selftests/drivers/net/mlxsw/sch_tbf_ets.sh
> @@ -2,7 +2,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
>  source qos_lib.sh
> -bail_on_lldpad
> +bail_on_lldpad "configure DCB" "configure Qdiscs"

... lib.sh isn't sourced at this point yet. `source
$lib_dir/sch_tbf_ets.sh' brings that in later in the file, so the bail
would need to be below that. But if it is, it won't run until after the
test, which is useless.

Maybe all it takes is to replace that `source qos_lib.sh' with
`NUM_NETIFS=0 source $lib_dir/lib.sh', as we do in in_ns(), but I'll
need to check.

That's why I proposed to do it myself, some of it is fiddly and having a
switch handy is going to be... um, handy.
