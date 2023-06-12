Return-Path: <netdev+bounces-10080-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16C9572BFDE
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:47:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7978F28104B
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2CC1106;
	Mon, 12 Jun 2023 10:47:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD4A11C88
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:47:30 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on20621.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::621])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE273448D;
	Mon, 12 Jun 2023 03:47:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bbZZ9VJPg0NLpcAYgsXosB84/+JZRTYSH3YYs6q4CVWK2lEyaFWulzkgWjOS6CclCheByNBtt+WA5ng9P5jLmuS3UdHyh/cWveKAKAPIMyEc1DSF5EsAAhQzGCuiPNW3O7RN+GsDgWjJRlkDbuz492bo5SDBqsTdYE1blcL/6HqcfAjBR9UP4NpePj//e0ngLj2UPOyeUh+i2OPJ9hcR5YoFRb2SwbgLlvpBPdEieA3wLOZDZgO/ewMIsVDMr+mnMvlYj5HEKuCbHX78AIZHaERTMUzQImhQYYz6qRE/y/fHnssJguvPY1gos/tU7xnI+6R4A7krdrVaZAe6Z4qjCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fAyo59XacG6wKEvQSEDoc8MaHxBbUhtYK49ZemaUVIo=;
 b=Zb1YKA/TdtIkW+gCvI52eb6/he4EfOr6plSAGeNB/OBmu/asiUVkfi9YZEgdeJ9ZUxiQYRUfCnYnWtKyRSMFgpMERbkNFwQc1tSVI9/ws2CfO/dH24dqM992j7OSLr+kzL1fy/OVUj75aqQhCAOHtdCkTqgNJPPZAmaB8IdUytdOPSEavY2SVLfbWIrtzepqeECTjOrN6RXw9ICXXqckfV1ZR3xnp8+E3ZxeMjrKRHWlVxXe/VmbrkwdVQv+Lu9iXq0MeudrtxkvaAi2P20YpqQP51LAGLGzqDOnWnKA7GXyMkz8/Uwd6EB0+JMsbolKCIIeZTavNG5icDlpxJzaNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fAyo59XacG6wKEvQSEDoc8MaHxBbUhtYK49ZemaUVIo=;
 b=tI8ifWJMSSQZMM38HoouvuoX/myz2bvt53UPAsmNyFSd8ouHP05N/+Ide4E/yIZbf4HxHjK++biUwiYhSMAihwunhaV+Ixl/MkYENMO1tOUGGtaaisu9MIkiQr9g4tSvsA2Af1cUQFVN2exAioGPt7XnOE8HabfxrKBkdYb9qVoSkVJsajwJNrdL2lxdEgqetVCzMrq9FNqDNeLWZ++am6IUnWODh9cJOERUL4pPUxMvZI5tKOxQRafmmyFODjNPYylfRVORfc7YSkTgq21XWnwrwQm9nJSUfBOf/hl2l4OVOmNIu9J2t9flYiCCNeRyll58L5pL3foVedoW1tWbCA==
Received: from BN9PR03CA0038.namprd03.prod.outlook.com (2603:10b6:408:fb::13)
 by IA1PR12MB7757.namprd12.prod.outlook.com (2603:10b6:208:422::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 12 Jun
 2023 10:47:24 +0000
Received: from BN8NAM11FT113.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::78) by BN9PR03CA0038.outlook.office365.com
 (2603:10b6:408:fb::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.34 via Frontend
 Transport; Mon, 12 Jun 2023 10:47:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT113.mail.protection.outlook.com (10.13.176.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.22 via Frontend Transport; Mon, 12 Jun 2023 10:47:24 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 12 Jun 2023
 03:47:13 -0700
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 12 Jun
 2023 03:47:10 -0700
References: <20230612075712.2861848-1-vladbu@nvidia.com>
 <20230612075712.2861848-2-vladbu@nvidia.com>
 <6bcd42ad-4818-dff1-96a7-36b117610e85@huawei.com>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: shaozhengchao <shaozhengchao@huawei.com>
CC: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<shuah@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>, <netdev@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <marcelo.leitner@gmail.com>,
	<victor@mojatatu.com>
Subject: Re: [PATCH net 1/4] selftests/tc-testing: Fix Error: Specified
 qdisc kind is unknown.
Date: Mon, 12 Jun 2023 13:37:59 +0300
In-Reply-To: <6bcd42ad-4818-dff1-96a7-36b117610e85@huawei.com>
Message-ID: <87h6rdvtxw.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT113:EE_|IA1PR12MB7757:EE_
X-MS-Office365-Filtering-Correlation-Id: c84b2b7b-4f72-4881-fd86-08db6b32684f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+lMzv3VTKKyDpCIpNV0MzZl4i1seKBTkXITzzcN1gzWUuoB/ppQe1TuYck6qXx1mY0YOqLJIfjIPkIYkql/pKX76rduVePAbzzCokyxmAxP0dun0dPZkAUi7tivu2JGQ1OGm20wmf5kMaJu+N6YInh02Kj4M8sAbfrNu0SFV83EY/MMEbHt2Xfg0IZQQjCVgXLJfhVqKpmVtUOOg23UtQ7AwC3NFofge5Klmjtm4TQB7Uaq4ecDKxAGGVQUysZkNqHqphmOc97DR+/xSb6myij9/uUxQEJvzC+L59o3DkPmGwq+X9R/bVxGBrm0UxHj1TmwI+31C4rfmzuQRbk1e//y0KpkSxDkxZV8sJwYSHRMn2cXordEmpzRpP81JERDJKTqIXSQKBA42RkDUR4WsrZ0cQ26bAVVKrDBCx+XNpvn276jEKYjKEthKe+dxNmmQN98MDGkPHsNIdiqclEJkfwjjd0ieMuuKyjbrsOI26KilAZDRlszU4yhfzRSUx7BlwSiabGdU/XsL8jPabhI2okqSwER01Q/HCdour2jCyHyWQtQYFG6EIx5uSpxzSlmzqFcUyNiUCHPL6ypqo2QY9Rs2u4ivC+pOuUPPMkJtvfnvDaMjH9t8Xc37OCBkihTV2C2G1IDQ/OSZZm3LLZxcNoCNKNrvnF+aJiVuJbnhot3MEOZ9v9HtVdnQsNmI0ufmuIah94AJ/emYlgL2IMdpKlyW5F7zVqH4+2D7Hv93FICsgAzGn6oI+b9Zc73zggii
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199021)(40470700004)(36840700001)(46966006)(83380400001)(40460700003)(336012)(426003)(47076005)(2906002)(2616005)(40480700001)(36860700001)(36756003)(86362001)(82310400005)(82740400003)(7636003)(356005)(316002)(41300700001)(5660300002)(6666004)(8936002)(186003)(8676002)(7696005)(478600001)(54906003)(6916009)(70206006)(4326008)(70586007)(53546011)(26005)(16526019)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 10:47:24.3635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c84b2b7b-4f72-4881-fd86-08db6b32684f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT113.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7757
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon 12 Jun 2023 at 18:35, shaozhengchao <shaozhengchao@huawei.com> wrote:
> On 2023/6/12 15:57, Vlad Buslov wrote:
>> All TEQL tests assume that sch_teql module is loaded. Load module in tdc.sh
>> before running qdisc tests.
>> Fixes following example error when running tests via tdc.sh for all TEQL
>> tests:
>>   # $ sudo ./tdc.py -d eth2 -e 84a0
>>   #  -- ns/SubPlugin.__init__
>>   # Test 84a0: Create TEQL with default setting
>>   # exit: 2
>>   # exit: 0
>>   # Error: Specified qdisc kind is unknown.
>>   #
>>   # -----> teardown stage *** Could not execute: "$TC qdisc del dev $DUMMY handle 1: root"
>>   #
>>   # -----> teardown stage *** Error message: "Error: Invalid handle.
>>   # "
>>   # returncode 2; expected [0]
>>   #
>>   # -----> teardown stage *** Aborting test run.
>>   #
>>   # <_io.BufferedReader name=3> *** stdout ***
>>   #
>>   # <_io.BufferedReader name=5> *** stderr ***
>>   # "-----> teardown stage" did not complete successfully
>>   # Exception <class '__main__.PluginMgrTestFail'> ('teardown', 'Error: Specified qdisc kind is unknown.\n', '"-----> teardown stage" did not complete successfully') (caught in test_runner, running test 2 84a0 Create TEQL with default setting stage teardown)
>>   # ---------------
>>   # traceback
>>   #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 495, in test_runner
>>   #     res = run_one_test(pm, args, index, tidx)
>>   #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 434, in run_one_test
>>   #     prepare_env(args, pm, 'teardown', '-----> teardown stage', tidx['teardown'], procout)
>>   #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 245, in prepare_env
>>   #     raise PluginMgrTestFail(
>>   # ---------------
>>   # accumulated output for this test:
>>   # Error: Specified qdisc kind is unknown.
>>   #
>>   # ---------------
>>   #
>>   # All test results:
>>   #
>>   # 1..1
>>   # ok 1 84a0 - Create TEQL with default setting # skipped - "-----> teardown stage" did not complete successfully
>> Fixes: cc62fbe114c9 ("selftests/tc-testing: add selftests for teql qdisc")
>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>> ---
>>   tools/testing/selftests/tc-testing/tdc.sh | 1 +
>>   1 file changed, 1 insertion(+)
>> diff --git a/tools/testing/selftests/tc-testing/tdc.sh
>> b/tools/testing/selftests/tc-testing/tdc.sh
>> index afb0cd86fa3d..eb357bd7923c 100755
>> --- a/tools/testing/selftests/tc-testing/tdc.sh
>> +++ b/tools/testing/selftests/tc-testing/tdc.sh
>> @@ -2,5 +2,6 @@
>>   # SPDX-License-Identifier: GPL-2.0
>>     modprobe netdevsim
>> +modprobe sch_teql
> I think not only the sch_teql module needs to be imported, but all test
> modules need to be imported before testing. Modifying the config file
> looks more appropriate.

All other modules are automatically loaded when first
qdisc/action/classifier is instantiated via their respective APIs. The
problem with two modules that are manually inserted here is that
netdevsim-related tests expect /sys/bus/netdevsim/new_device to exist
(which only exists if netdevsim module has been manually loaded) and
specific command format "$TC qdisc add dev $DUMMY handle 1: root teql0"
failing since 'telq0', again, only exists when sch_telq is loaded.

Overall, I added modprobe here not for theoretical correctness sake but
because running tdc.sh on cold system causes error included in the
commit message for me. I don't get any other errors related to necessary
kernel modules not being loaded for any other kinds of tc tests.

>>   ./tdc.py -c actions --nobuildebpf
>>   ./tdc.py -c qdisc


