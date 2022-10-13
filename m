Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 037D95FD1CC
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 02:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbiJMAtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 20:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbiJMAt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 20:49:29 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19F3106907;
        Wed, 12 Oct 2022 17:44:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hkaKljuxu5Co1+fTqrpAwsB395pfQbGIl59EuVRQS6UiCKwFHR5+RwklA0NbV5dPWurNNw301hIOEKr0sWa0ZVCd3R1/NCF1uWhxCgNgMPFrgWtoQDgKC259p2YDALTebGmVQuZrgbg++1VZxldKCFqJgOAUIgkNBdX36NV4yMtVK/sTH12rw/EMG6AHieW4vxWMRzYGkPgrStYATKAEoNVTntEJmDGSXnccNH3AK2SZrBxozau/uLmwRm8OvsqiEA3uEF1p9gCek4NNMMzRKdhb8p3HY2cuY8hpp1/eyHSl+mJmBh58Hz42W6Tr6g+ecK4T4oFKUI+vMGB1omdzUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ptqEj/nnM67xSZIG94Q+I3AU7yUqD3y/arhx4PkEpHc=;
 b=ND0Kd2y8LkwfcJ2xv8mN8hTuNnLs0hd5hYGOdZStpuK3JwlmkTsZMZwkHSNmqT45EUZxU343ARCgdZnSQXH3aEBfo1vz/5mrV3vkgOYsEFL95Jsv+GNvM6aFqFslmayu1YbuSSDN2k9746Oe/mzY3vYot2OvwJ9XaL/7hjXGN2sxOsVfaveVyH5azoBmWMki8udUe8ezjiSYhs1dKkHHypdqHZieStQFdheLMfrFA8WdtkyAqe51N8R9gQctaLNGOjcSdEuhBtZpe+Jh6Vw3OdC2gkCEw2RSOtnsD+I1FdYhg6jhYiZZrvuqAmis3g6J3HM4F9JL/wLeC2NU7R9Biw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ptqEj/nnM67xSZIG94Q+I3AU7yUqD3y/arhx4PkEpHc=;
 b=djLVvz5HBcVq4G/Vfj7G7akrGtwB45EYyo3CKO1IcpFPTRG/3UV0phzfmxk8X1t8ZYeor4Sxl6J4sp5St8GKZU0QDoEl0W0Ltjf1bFG79Rlou+Z9M+FebdCRCXVVSTcig5DaR/ga42JQU3hgozlRRd9A6wqF9M2T7JcX7osu00n1VibiWKO/yxeuCp38zxoeQQumz5wimN7Jw7zYmWcH8gyOpPJ46ucp0jXYKxxnnI6XscWMLBveOQ8m93byw30vnkAnn1Yk7AFtA3rlWtEaxCt56zplc0vIqb2jf0JCENN8C3u2FPy7G3m9YKphoHMHGkHLlCRF5cpLpCYTmFZK4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by IA1PR12MB7589.namprd12.prod.outlook.com (2603:10b6:208:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.20; Thu, 13 Oct
 2022 00:40:52 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::6c65:8f78:f54e:3c93%3]) with mapi id 15.20.5709.015; Thu, 13 Oct 2022
 00:40:51 +0000
Date:   Thu, 13 Oct 2022 09:40:46 +0900
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: kselftest: bonding: dev_addr_lists.sh doesn't run due to lack of
 dependencies
Message-ID: <Y0dejgSk60iZaJ/4@d3>
References: <40f04ded-0c86-8669-24b1-9a313ca21076@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40f04ded-0c86-8669-24b1-9a313ca21076@redhat.com>
X-ClientProxiedBy: TYWPR01CA0001.jpnprd01.prod.outlook.com
 (2603:1096:400:a9::6) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|IA1PR12MB7589:EE_
X-MS-Office365-Filtering-Correlation-Id: b00fdad1-bbb7-458c-2e3c-08daacb39469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IY+ucpVMIae93zxx+2Y9v92JVthevydB5XhF04IJfPB52TWtJkH2K2h+mEX9VjYq8NjLxPfXxuLzHvHbsi2/NnCHQ9+gR5P8DSRQWtykGPzRY406CinRkMeeTLkQdb+vdFooW32bEdFRSCUb0HLpjDOsNn+TzkQekmxbEjdeFQMFi61+4Kkt+xb+yy/bEUCDMqOFXFAhdfImTpMhOTQ4Ddg3OE1AoJRKIwLZUypOvAnVpyU0szrkrRWas3Iv4pzjtmXxevdaD61H2LhWqwmvwiCZ18uC2U3ePHCKy671xrnXbhj44TOAkYSbIxWTs9dJMFYzPacsLKN3IOZvuosD90FRcbg/X0HM6P96x37GfOHJHPyr6Jt5dFEaWA2gF+BsTMt3SSjojGhlEyCbskpvAx42QcOSur0oNUuJtMyWlIOL/Z9vSxqxwF22Ib0fVauGO6g6xMm+Nmc94wyqzEa81wMEvbasf4oXOZYzhIDZt44h2q/043ET3tdKgvgnAaO+2/rpzTKRtGhWz9fT3pfVze8dTpvFR6e5B61Xba/Te3AqJNsse+nqdMe7/3hWhWKXMcV0MT+wHg9cpAFLXqTZ7KISEd1Lllq0FcgeEbREDBFdV0GW6LM64f4w/32//j6Cp2jKMm5iEPWTB6GJ0FFZ/DfP8zBb2Or5hgA5nBFwtaJZAhA/ClwH8/b2GB/euX9yZ5l7/2/m27jozfhsPKajqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199015)(4326008)(186003)(66946007)(66556008)(66476007)(8676002)(38100700002)(316002)(6486002)(26005)(478600001)(53546011)(6506007)(6666004)(6512007)(9686003)(6916009)(54906003)(86362001)(33716001)(8936002)(4001150100001)(5660300002)(41300700001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8a7KWXVodd1t6BZ4rasujX7qiXzM86LFidRQ/EyTX1lSMSwf0TiNeMmrZmRh?=
 =?us-ascii?Q?EQZS0DVh7nTvQNzNrkHlJHivFVGarPCBVlGF+Am2YXIIulWiya521TVjmagH?=
 =?us-ascii?Q?1+Y0MRkY9ft684cKqojrpIKyzeLWNpJeI+zYqWvVEwpplSxp76R25VW9sE7a?=
 =?us-ascii?Q?vJiT8R1RcDO/cx3HwVBpfQ0TkM+0asVvi5luUAUYh/mb6H5XxUvWEpay/r9s?=
 =?us-ascii?Q?5C0MEXj+pxcqJLL2/OjFPtDyrfjEWRuuVU8g82rOOOKK1L5Bv1AnIHcM8+S5?=
 =?us-ascii?Q?VwKFxrCCtJLPeU/SYnMWRJvRZuR4uDJxm0MGw3KaEs+OiMTb0rwBUYdA4qH1?=
 =?us-ascii?Q?1WCBKgxBWussI+XZRueZqj03qW/9B7KMsCreXrSg0Hx6+Q+I8nTPXse2e/mf?=
 =?us-ascii?Q?B96dOxxUw6rOct6epxYuaR3Y/DAlqV2q4snADDete8Uk+EIPFX6V7JVCKyjF?=
 =?us-ascii?Q?9agVv+7CJb5ZgZYTu966UbjiHG41I3ocp7dMUobrcyntxkvncP5+r3XfDenS?=
 =?us-ascii?Q?E1/QDsg8uKkmKi+U1LEY+p/8TwP5VleWMaXCoj24qI9BtfcfAhJVdL7A3wpP?=
 =?us-ascii?Q?oeEwBQWIhAI9Ltz85JjuelV3XJxnkMHv+Gdk2g411gyE/TJZ388L/hmy7elo?=
 =?us-ascii?Q?v7pbionkiU/U24w0SQG1oedOlctmHC5T2kpO3tVjTx3OiCwKwZa0wt7MyGug?=
 =?us-ascii?Q?D1YmBmVl2aj3o8HcHIIfvlx7pZKAuuU5yvSD+8o2E9YPGQY9Mfg2eCeMdTdB?=
 =?us-ascii?Q?VcM8QQnpSlNsPEd2nRW+o1YatB/YytMPl2USxo4NIavtgdk1JTM0vLvWNEa3?=
 =?us-ascii?Q?BI1vsHWqRx3bPr6+K/wlCBbc1UD4D6APCICnxsfT47R9/iWBuqVqlQgVSYOB?=
 =?us-ascii?Q?JlUo37XAxZ7UEw6KvHnQnxrnUwUq6qqK+ggM8tL7g3OwqH1WOdEIGc5AtpJx?=
 =?us-ascii?Q?Cb1uacebziStPaCo8la/cMPd1B8UG7OknuUwv2AN/xNKagucwiwUIaZN8q14?=
 =?us-ascii?Q?txO6d0rLUFZOihfjYz7kXyBqF5frvTKKcaT+lDcF1BVo+69GI91v3n99X71o?=
 =?us-ascii?Q?sgSpLsLA6stCuW7o4eTaGgmn1lhtPfXtT+r39Nj6OaHjx+kgupn2jrbvTrT0?=
 =?us-ascii?Q?X58r0e3tatnwyzYeSa/piF4YUw+S43z78aA3TIX4rruNgsE65Ii5/mqJOdlm?=
 =?us-ascii?Q?cUsPRzqJ2IFaaCmAhYLbHaYpEd5DnMoi0eh4qVdwysggAowV53nnOUT3OXRm?=
 =?us-ascii?Q?KeX0WTcB1hilbdRz919kmJOYOvBGItONfLEdrJAvX+fX1O1lkCqXJfvNtxE/?=
 =?us-ascii?Q?2vc0zuNQCS4ERGKI3Mfkh6ujPutu1c//6ktXiy7aZ26zjzRrifomG8N/Elud?=
 =?us-ascii?Q?e6qETSAChdXj8M26iTQHoVof0dljo2u+u6f51OR8lP/tC3cS4/GX/uES5W35?=
 =?us-ascii?Q?rPwX8L3ks9/9VNP+DOVHCr43kKJ8f2mJ/Y3CGb3yCvdnwQ9z4A67YixlNyPb?=
 =?us-ascii?Q?hmoMQKPT/21umKQsbMd3fShtOsnA26mEWafu79PhYb+5qEs3pAiZJ6ZyWdCl?=
 =?us-ascii?Q?xqi/359SCXclVMg+YG0y/FIQHXo8fNBk4+Sv7yKJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b00fdad1-bbb7-458c-2e3c-08daacb39469
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 00:40:51.8840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4B03K2bETQpYXzQ9psWyk0DntGrMBrJjsEMht0r9eObxc9/PsOK/zWQbE1YF0DxABTI9nnvs90LWoao31PKgKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7589
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-10-12 10:17 -0400, Jonathan Toppins wrote:
> When kselftest for bonding is built like:
> $ make TARGETS="drivers/net/bonding" -j8 -C tools/testing/selftests gen_tar
> 
> and then run on the target:
> $ ./run_kselftest.sh
> [...]
> # selftests: drivers/net/bonding: dev_addr_lists.sh
> # ./dev_addr_lists.sh: line 17: ./../../../net/forwarding/lib.sh: No such
> file or directory
> # ./dev_addr_lists.sh: line 107: tests_run: command not found
> # ./dev_addr_lists.sh: line 109: exit: : numeric argument required
> # ./dev_addr_lists.sh: line 34: pre_cleanup: command not found
> not ok 4 selftests: drivers/net/bonding: dev_addr_lists.sh # exit=2
> [...]
> 
> I am still new to kselftests is this expected or is there some way in the
> make machinery to force packaging of net as well?
> 

Arg, I didn't know that you could export just a part of the selftest
tree. Thanks for the report.

I'm traveling for a few days. I'll look into how to fix the inclusion
problem when I get back on October 19th.

In the meantime, if you just want to run the bonding tests you can do:

(in tree)
make -C tools/testing/selftests run_tests TARGETS="drivers/net/bonding"

or

(exported)
make -C tools/testing/selftests gen_tar
[... extract archive ...]
./run_kselftest.sh -c drivers/net/bonding


It seems like a plausible fix might be to use symlinks, what do you
think?

diff --git a/tools/testing/selftests/drivers/net/bonding/Makefile b/tools/testing/selftests/drivers/net/bonding/Makefile
index e9dab5f9d773..7c50bfc24d32 100644
--- a/tools/testing/selftests/drivers/net/bonding/Makefile
+++ b/tools/testing/selftests/drivers/net/bonding/Makefile
@@ -7,6 +7,8 @@ TEST_PROGS := \
 	bond-lladdr-target.sh \
 	dev_addr_lists.sh
 
-TEST_FILES := lag_lib.sh
+TEST_FILES := \
+	lag_lib.sh \
+	lib.sh
 
 include ../../../lib.mk
diff --git a/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
index e6fa24eded5b..7b79f090ddaa 100755
--- a/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
+++ b/tools/testing/selftests/drivers/net/bonding/dev_addr_lists.sh
@@ -14,7 +14,7 @@ ALL_TESTS="
 REQUIRE_MZ=no
 NUM_NETIFS=0
 lib_dir=$(dirname "$0")
-source "$lib_dir"/../../../net/forwarding/lib.sh
+source "$lib_dir"/lib.sh
 
 source "$lib_dir"/lag_lib.sh
 
diff --git a/tools/testing/selftests/drivers/net/bonding/lib.sh b/tools/testing/selftests/drivers/net/bonding/lib.sh
new file mode 120000
index 000000000000..39c96828c5ef
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/bonding/lib.sh
@@ -0,0 +1 @@
+../../../net/forwarding/lib.sh
\ No newline at end of file
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 9d4cb94cf437..6203d3993554 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -84,7 +84,7 @@ endif
 
 define INSTALL_SINGLE_RULE
 	$(if $(INSTALL_LIST),@mkdir -p $(INSTALL_PATH))
-	$(if $(INSTALL_LIST),rsync -a $(INSTALL_LIST) $(INSTALL_PATH)/)
+	$(if $(INSTALL_LIST),rsync -aL $(INSTALL_LIST) $(INSTALL_PATH)/)
 endef
 
 define INSTALL_RULE
