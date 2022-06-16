Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0EE454DF62
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 12:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376536AbiFPKo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 06:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376612AbiFPKog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 06:44:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0985E142
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 03:44:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JWkhUCGzHAnmgi5lmk76s5wawwkvMaeKfO3ARzt2a8X12xAgILNZrufKNfq3oAAefo5Ry2vhQE4YIjRmjKjyUmhWFh5/pqeZNCIBk+HBCCirzcz5BHCHKoTHTMCti/JESHhe1bg5GSK8xZEbrdrIvDraMX51gp1W2JA4bHSXVJr7JDccWBz7yrVRkxCYuQYF7NNjqrtTATQu/I1ZOhdHB11HBza2wTGXJhE5Gl2Aoawuy1TT91nSaRc1uykcwGuVbXS2gwN0HooeX7TaWxY2uSwV9C1UaU0/gL/0H7GudZOZ67f5TI0I7TcFQrdHAWl/M3NzcAo+/nObM2a8PsuUig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zy7EhjVpdScPtZOacq/VmM6eGy+IrFcK8sDjAFlN6BU=;
 b=LIaJTbO1qoC0ZxjLYGcp1/Bd3mFhibkXrK/GAhqznQbsKrbegA6RGBgWZLu7hatXME2/Z14JFcYvNE87OBX+sOPfwDjU7UzkkBlzDXAcOpFt5DL4RmBNFEJhJBNbOVPapzPqbCLjvakTCra3sy6tnQGc5A7S0F8rZH0vHD4dtn+qeqpjPsEngoOutWFepC/gzxCq4WJe1POAp5SKgOt0Qi9Xa5E/fLmoV9MRlPu2eiLg6ctYbHPWDRVwdwXQUBknPmMIXT6JeptFcH14mOhxmaq1w2KrS5LGxvWwERPj23Xh0RounYY8bKuQJ90UMVC3q4NBSLOmqCU4ZeHLvTQ/CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zy7EhjVpdScPtZOacq/VmM6eGy+IrFcK8sDjAFlN6BU=;
 b=n5VgCxa/tMXmFGI0+e4IiMJhFbPdgZqLABta8ZXzAzyk24qzdXT/mOn0VbgkO6GbULopzvhTgIURjbHUEBirfJLgPxH4DpvQ5fAkBtyiBoY3lQP29NIqHfuHL/s8AwEyI6cBzYvy8qjIhP9d/aq5lwOI5IX9t9S1ROD3lWdyLVBm+VzW9TpkQVucIpO/COKVrhQ72prHuCMcAfpTPPweet9CxSACN41gJSHQ+VFam0fgzGIk2VCotXX/EOSRlSj4+iNy3vFkcbkFXV7AwFHdeNmF6R9Z2mSJvS2m6uYL43z1MJWVjY3FBci4mEUnvNaeTAjTAFyuvCDTj8BnRvwSqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM5PR1201MB2504.namprd12.prod.outlook.com (2603:10b6:3:e3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.16; Thu, 16 Jun
 2022 10:44:22 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Thu, 16 Jun 2022
 10:44:22 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/11] selftests: mlxsw: tc_flower_scale: Add a traffic test
Date:   Thu, 16 Jun 2022 13:42:43 +0300
Message-Id: <20220616104245.2254936-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220616104245.2254936-1-idosch@nvidia.com>
References: <20220616104245.2254936-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR08CA0029.eurprd08.prod.outlook.com
 (2603:10a6:803:104::42) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1506788c-e1b9-402e-565d-08da4f852cad
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2504:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB250432F9A03A8D407D39A7B1B2AC9@DM5PR1201MB2504.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o7HWHgEb3KKxMSfIaLY/dbWuVmDkIT2adEQ14HN9J0Q7E5BtdP4RJXuMkuo9PPh+k3VVovmxCjBpY4Jnyua6DmEUccWno7wEQ45X7qUa2Tty6nPBSrtA0+rWTGpWwgMY9Gz+ecM5gaWVxx/c4/nXZzwYC+MnQNWjQvHZH+cehJNc2K0Yxfyty5KkJIp4tlvza/JdeobhtG94fRt0OZ6ToowuqXCWd9baDtXr5FPAxKtxu4mieI8FJZhpce+4TCyFkZ/U3+s6rbc31u5h/luvu5+ETrGOJjo36Vwc3/MfInvsgs6nTuTJZxXXrndm6hEkXBigZvvGypHP26OY8a/XlTcBOcLCqVYpju9aFuIyLmGLHhQL1539f7HRjt/938MVz+cGP1ptqGlKoUv8r9nh6El4u1bc0OmoJZ+uV7S6BiqtIq0WsWFH76LuLon1aRgWj1AWiSKvZ0nv9LMltVCPn46/G0USRjkka34wKcBy5Wi53rBt7iTvtTk8sWSkepiveQEYoqDAkZxr5zQXaOu4D8JsZZ0+P9e9wroZBo1+ELjKsGgkq35zrMhAnUu0fYCSNrdBHhdBDjX51/Xx4Q2v9eaF6c3aBJwz9xBDsXluchTMzB3MLeQtuXnJ97zD7CTaWl3zMcSp40ssUJj81BXd+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(107886003)(66476007)(6666004)(1076003)(6506007)(66946007)(6512007)(2906002)(186003)(36756003)(8936002)(5660300002)(86362001)(66556008)(8676002)(26005)(6916009)(4326008)(6486002)(508600001)(38100700002)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Q3XuXCw3jTlzUDXBsHOss9mD76wJIbA6Ls2HiWyIUSzez7EFuPE7Q/n0B7n?=
 =?us-ascii?Q?cnAihUWgor3gY8Eub8C43eyAanwY2T4h69u18JymxEbYz7GnUUKbI8drUbD2?=
 =?us-ascii?Q?KjIC+7fXlkNhMwHi1lWDaa1J6ys0vuomE27EWPEkBWz3E/s3xwkih5I+iGR5?=
 =?us-ascii?Q?fb1ZYJdF7PYWj5YRAGkweICVRIrmZoqRbeBOx3eD9Wlcgy7H3BjU7B/FeXYq?=
 =?us-ascii?Q?rOvnGvA44fOHAGZPv9Pm6wpHfraZ3Ff0/mLptR0Q5/i4pR2RT5r4I0n/EQ/l?=
 =?us-ascii?Q?VkY6jh2bxHw5DaSy+WSO6MyyxdeDHTY+WkpGNpUmvZEgsaSwM3kDE7wEGq8Q?=
 =?us-ascii?Q?Mr4OuTgZSn+jJQtBrfalIir45GXXUDZxDlaNpOKa9HfBPEeprVt2OmyeUfyP?=
 =?us-ascii?Q?GeVn/kr6ijQMXfuUvvZHFgMe69UN+qqx1hB5dF7bn+8uTAfHCfqxb5PybMoK?=
 =?us-ascii?Q?Uu0WJAGyw7tC+muLVceEWlMaoXX/sU4nJGhURr9+WK+LSZoPZNUcAz0msWlU?=
 =?us-ascii?Q?FuuXv7WhS5UM1z5y9vzEo7CHFZwyDHPcxc7+aEgPsahapKM/S/Zy75aOsUeN?=
 =?us-ascii?Q?5mD6cOw6+SiSDxdZbe2VKRbDLZ7MYjlL21PuzSSx5UrmLDhGh8XJvFKnpVIX?=
 =?us-ascii?Q?/SRTXQEC/c+drwkyAwIUCTfpknJpLyVRivUAXXqcFQs+6d92IeTnO6Dcehrt?=
 =?us-ascii?Q?OWgQyeoKOT/Zn+WL0jRimbnlIcDQ9wYOu/uW9CJa9NymKWKAWQdFFz0Ivwo9?=
 =?us-ascii?Q?1dLR08CK6fPyVLX3AwYhwjzCoa2/OIl+hUZtzMaa1Z5NusBvk2jDW8izeSjm?=
 =?us-ascii?Q?BdSf5p5REyRxD2AZZPYU09an5129Gqly1aK9F7UsgVt9aD6FAEiIqKNXS5nu?=
 =?us-ascii?Q?s0ds+E5/B69806krRt9TkoggXXL6gyh/lVS2UAn92stCFrlEvea7fzjYy5cT?=
 =?us-ascii?Q?iAA77TM5JVoxp7O2C/o5ZO1oARmetOCMyvr31L3/rcKadLsWlFchZLufrDfN?=
 =?us-ascii?Q?tpSNd/m5bPL76R3W7XH8rWzcAfR2Toz5smZLtnsz66qRoIm6xj749rSS3k7y?=
 =?us-ascii?Q?TQudrEaRRc12sUmn6nl+CBSXsd3qv1zN8X/ZgY8VzrqLl9LK/PJTgncuDb5Z?=
 =?us-ascii?Q?d0YXmKAz8QzB+DwgAdL/7TuCwAAlJ4uLGoYX/mBVgvZn51JlCMu46+ign3d3?=
 =?us-ascii?Q?o5LkUgn2R5YUVNoCVkiqkz4ViQEjd+POlJwqBJZfu6lmXyNfP2FPmuB74c66?=
 =?us-ascii?Q?26I/372VBijtac9C72b2ZRnzIGHprxOFA4rkOrQvq0LmD6uTi18ijpp+fvZg?=
 =?us-ascii?Q?/2S+tIy784z49Ij3vTyH4aXA175YlWp4QTE0Y+snO3NJ04mbS2poTBj4vkb7?=
 =?us-ascii?Q?Q56W+5GErUQhhnaxupMSsVSN0IsGH58UoamutoRWEsRpE/w1gEdktnIydfSq?=
 =?us-ascii?Q?f13BMEjOyiLHfv0wXrwRCrZzDIIrahRrSb+d1tPw+xw9AeiGh8qMvh2Ce/IF?=
 =?us-ascii?Q?qNEMA4LQiiuIBzs3h9jfO62/tysefI8y4Ks4rb1zPnIPXiW3ZFxBEAcAgpMw?=
 =?us-ascii?Q?w2QQCXhFHEL7mc7u1YbO6X25rkJlF3gv5r+ajSK01MbV7EQG/O6/FGtYMxVs?=
 =?us-ascii?Q?73Dcpj5aHhaX52ftF5kAtalYVysh+H0uDJuKhe1ktHojUJD5Vzt3mTdFZwjv?=
 =?us-ascii?Q?JaDBb/EbXX4KdFkQQK2hx49njP6ljkZHsDhn+zRmGLpyrN/p8k1Y2wCM1cUC?=
 =?us-ascii?Q?pUVsoufjFQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1506788c-e1b9-402e-565d-08da4f852cad
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2022 10:44:22.6085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYv5BUIM+QbPfCIJ6GTAT5Tqcrpmd8KTQtgRXapr6zv+FXEETu1u8YMXZHcEVWGSijlo2r1k9ldwaF0hSYEOmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2504
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Add a test that checks that the created filters do actually trigger on
matching traffic.

Exercising all the rules would be a very lengthy process. Instead, take a
log2 subset of rules. The logic behind picking log2 rules is that then
every bit of the instantiated item's number is exercised. This should catch
issues whether they happen at the high end, low end, or somewhere in
between.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../drivers/net/mlxsw/tc_flower_scale.sh        | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
index aa74be9f47c8..d3d9e60d6ddf 100644
--- a/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/tc_flower_scale.sh
@@ -77,6 +77,7 @@ tc_flower_rules_create()
 			filter add dev $h2 ingress \
 				prot ipv6 \
 				pref 1000 \
+				handle 42$i \
 				flower $tcflags dst_ip $(tc_flower_addr $i) \
 				action drop
 		EOF
@@ -121,3 +122,19 @@ tc_flower_test()
 	tcflags="skip_sw"
 	__tc_flower_test $count $should_fail
 }
+
+tc_flower_traffic_test()
+{
+	local count=$1; shift
+	local i;
+
+	for ((i = count - 1; i > 0; i /= 2)); do
+		$MZ -6 $h1 -c 1 -d 20msec -p 100 -a own -b $(mac_get $h2) \
+		    -A $(tc_flower_addr 0) -B $(tc_flower_addr $i) \
+		    -q -t udp sp=54321,dp=12345
+	done
+	for ((i = count - 1; i > 0; i /= 2)); do
+		tc_check_packets "dev $h2 ingress" 42$i 1
+		check_err $? "Traffic not seen at rule #$i"
+	done
+}
-- 
2.36.1

