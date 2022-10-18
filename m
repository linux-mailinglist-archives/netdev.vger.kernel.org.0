Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2446024A8
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJRGlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJRGll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:41:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2081.outbound.protection.outlook.com [40.107.94.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035E1A87A2
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:41:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCYX7npWohNkSemw3XA2KDyNvkXt7p5cksEp0G5kptGaMLAzGwudkt/Kq26joli1jQfV4WEK2bCbElQOdcQ0e5HeOcEoPQI+4Rwl1dxKaeq6eC8/LZCaNmrmv22Rcp49eRWKIyJGX8GovG4lgB5SafpSxY43swjH58k3olfLHRpSqGSoT7gsB0xKVmkYkubpmA81Mw2Tn71lXbgtg0ku+MRukigu4pP1gHTALCpEEsVjr1n85WfG9WWP5olyhS7LOfE9Z1AK4v/Qs9xwJpcoTxOq68jqAdy/Om5pA3VkpLyuXgQfDP/fQi8GplxgBd1as0T5ADQjrdTrAVTEb7bagA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fc+o0DhHymNEO83gPG4UU9+8CmTDns9+6MM1r1bR4vw=;
 b=FpLVVwcMp582hTSJxJgfqmtjmHPUzbuLKCr59Qg9dnqkYcV+C2bAJnRupmAG71X4lDnQjnPdksIVidol1oFLACXFF6S56HdhVYn0GrQNN9E5zsxRxhjyZGZRjMwesB8xIDSAn3CQ7sJdUTFapNx2KrtYJncwnmGmgCVSQ4JKLBJ2qKb61S0+AME00nvs6HDcz5ZpBKhqO2HjllnAkl5Cwm3UrOLQJp7usJC50t6LOBtFXBgg/x6mf7QqIYuBxXbQieWk+fXeINq4696T0VVmu4rHSysjPCD1g+Het3mzAbbTWwfpKFESPvNZdhmtO+1dKdqEkx5V0GGPMOUQ0d8Xrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fc+o0DhHymNEO83gPG4UU9+8CmTDns9+6MM1r1bR4vw=;
 b=A0qNdgpv1ukflSkpLbrMDRWb3UfGtr2cW7i00MGghxkPUxG9b4X2eV05DJkjk/GgHK3Irx32xw79TIFhurMLexksQ5qTXNzwXRGg9e+Yp6mf5IzzxoS5yMfwZjUT8poy1QaefKJlqUv65AS7xrBOIa1P7snGFX0KRV0gmHErifKgG56uMUWIlVxnpywUSbECRX8kzyCOxZV5KNoZA0eo+8dpOGxEZgxEwzYuv50XS0kd41EEbAi3cRPTJr1eCv6z6IEKmp9ZNnXQL3FfAXKsEfFWa9CZtb3DM0gStTTdaFLEH3nDknwCYD9A9t/TJ47zd0cfL46Xss008Axs3IBGsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB5385.namprd12.prod.outlook.com (2603:10b6:610:d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 06:41:39 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 06:41:39 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/4] bridge: mcast: Simplify MDB entry creation
Date:   Tue, 18 Oct 2022 09:40:01 +0300
Message-Id: <20221018064001.518841-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018064001.518841-1-idosch@nvidia.com>
References: <20221018064001.518841-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0601CA0022.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH0PR12MB5385:EE_
X-MS-Office365-Filtering-Correlation-Id: 59dedc98-9fc9-4960-6586-08dab0d3cfcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6G9w+fWDr77gzDYojUrbN/Se/waQtigY88nNvrvYfihF2sEIJZNnM4Yp2hJD+v9oj5O+vOn6HXSVTQ+BHVRlwVohYMPXM++3+dEXmVlMwEm7f6fXf2bgIA0p5NFQhxMUMMvnbhseb1e3q1wbTYY6UUyKs+QmSdDTq9oeH8piIZiZM3lHTLIcUrD1u5VzUj+fdJ45ZvvUtTFhoR7ghM/VH9dyYUBIAr+BmSCzJMsuJN9CivLPeid63hrSLC/7AtB8gojLpxdQerG/1dXyhVyd0gEY/oW6wJs94COWV2x4bQftnbep7m12pochLfoysthehjSbxYakKs7iOSbzEJbcCSkumDs94iVxNlaQ+xV40w19AeU0rIhLfkz/IgK3nylMrfWt2SCwEGwKXlNKifGieXZzc2ZApPDUqlTsEWT2GavB4TpuFNDe7+7wndTFZTnLU9JsOygBZIatg9VC42nZXbUVyyhTvsW23zTxk0FU91ILqjZ3Tv7M/olf2fbxa1GiJflutk5MqT18VShQMAGbnyrbr/rDqtypwDMTHv3yt3p2cSZY7xr/642ogQcyVRjepefVcn1tNZqFizII4Heq+IIhO6CJv6w4Ezjkb9di8MgmGDdj1xhcYxzX07Aka7FmCTUgUYsigUVIRCQeXK/4BzmcAu750cvifT4SJ3aS6HSpfxezUwce42uSsIkMKrqBpGo7IM0WaM6soFXZunruGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199015)(36756003)(86362001)(6512007)(4326008)(26005)(6506007)(8676002)(8936002)(6666004)(5660300002)(41300700001)(66556008)(66476007)(107886003)(478600001)(6486002)(66946007)(316002)(38100700002)(1076003)(186003)(83380400001)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GhHIQMAGprNxl3S4NLa1R1QVTVF0nDAbYcQvFxOjoDHF9pZzYMdFUZSxR3zj?=
 =?us-ascii?Q?GiQem4ZcnBIUcyFLRZBUT1na3hg8r7axYcT8I4Wk5oqfzNJr6TeOGWkiQbQ7?=
 =?us-ascii?Q?HDgs4wbxA6omEFw212V/7gOsHTRcaOV3/6PK0pMiE2wx2aZT41iWaQKrYsqX?=
 =?us-ascii?Q?zq5jD8Kpl7+v7/5Y34y5+eNCMX+ZrBj1ddPTeZag+tM+OYRXJLnB8MJWdpsm?=
 =?us-ascii?Q?Yi2LEqdTaeM2BCNPbzV7eUI8LU+oWWIYoNm9Kxh+/Jry1r5ms28M8/F02NDA?=
 =?us-ascii?Q?T4anofR5kTFeOJx4MiGGXaF1mKtTuKWGGvqiy1KrQFqyBG3uo3r3uRf4ApyI?=
 =?us-ascii?Q?/0+wHdJhHZeMxlxf/iKPVKhQbRgyM2mytEosRIaoHCKGyNo0cTh88BE6BKeE?=
 =?us-ascii?Q?wmUOqzyC0z+M6NNDXFnah4AFL+JPIN7U0fbV75oN/+X/NaKChwkH2oTbXOuH?=
 =?us-ascii?Q?rqcy07maBhoD9NUcc38Zft/WiSZvYPzzHJH9VVyDKl7gKgZsC0bD/OzYMnah?=
 =?us-ascii?Q?JlKdYnEi+6AB/jujD4qQaaCvC/L1szfjWQe06RJiyCPZdOVTboM5pRS7DwYi?=
 =?us-ascii?Q?y81+RP9kKaBFqEaE37ds/1yLemTlMFOKTaEdBA1QHj7RCImnUkX75CGLGcv5?=
 =?us-ascii?Q?8kLVAclP9D7/wQWRLl6Jb2Ll5mHyO0y/Y6wH273Qv3JLem05CH5Uq0pk3BbD?=
 =?us-ascii?Q?QKgRgsXSYpXd36eFYWUBTQ4JASOZM0BfatY4VWzsSXNVrrtu20CYGWFS3rxI?=
 =?us-ascii?Q?yIczrzlqX9zZPCLqoe5hhhY7jUES+eAdCQ7pWd9gG6v82xG6905NY9DiI11U?=
 =?us-ascii?Q?7w+B6H2dnz0IxGVBVXrFWKVbhhQF/TZtsFcN4X/BNAyNf8MblvtKOQ2NhrGY?=
 =?us-ascii?Q?Ka4DU8sdlOUqbQVnxFjdmUIRCCZW+29VFGuvh4R384mV6LY8Tf4HRS/J6e+p?=
 =?us-ascii?Q?yF1xPQ3/vQo0hrd2NPrpwnYQ0Dtm4nXYa5e92Wp2/yszdqAxw0x4GwRVRuX3?=
 =?us-ascii?Q?FVB+8QIep6237rzALI+W66UGhKkXfA8qD7Wx/uzNa58L2ioKbrjcq80ixlva?=
 =?us-ascii?Q?yZscvatk0AG7i/r6k59g2uQL6mIkZlgzyKN9HtSTwi/RYshHFhmhZ6cBFxU2?=
 =?us-ascii?Q?KRBgJkvPLj5YFRsFVgyRBacezoUrLgP3XA9bPSkB/DeGDqxAkemVyl8SKfUQ?=
 =?us-ascii?Q?t8PPKiQCjWkfRKtLC3kIScCBDAZEO64vkVbBxf9d8VuKgyMbgF+0AVW2UeVR?=
 =?us-ascii?Q?qrmT6I/nClWOfDROmzDS8/KIRh5bOEkFKh8z0dzu/iPyVUMoqlQj6N9LFAGO?=
 =?us-ascii?Q?hJsm11+SPzt5ErG6YsOLPO95TF0ueeFxyU2/oIBRSBeYGaWQRb3YHMT/Jl7n?=
 =?us-ascii?Q?DPSRUfYuLyxuSVmdJGSfQnxFXjwkXGT7sMShr1afxPCFc232PZpFLUFYz2FU?=
 =?us-ascii?Q?FTs8yBxwLkhquducIFYVTsxHK/WjNCJ18+L8n3oS0jfL7YJBxmgJBCTToges?=
 =?us-ascii?Q?E5IowKTgfUwaqufQisD+k2glpqzMHvto7XKIsmmYVYaX9Dszdk6db26pfKqq?=
 =?us-ascii?Q?7L/BPeHAvrsKYZwPi3wwvkD7g1cNGp/e7WhXsS0o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59dedc98-9fc9-4960-6586-08dab0d3cfcc
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 06:41:39.8149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4mZIZKrzAtOobxzsT5m9j3vrhQ6Ldd+fSEWbyKWjYZWxPzxw6KYHvc8A1cCtKiHWpoHRL2DtaVdfhAr0dXOh1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5385
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before creating a new MDB entry, br_multicast_new_group() will call
br_mdb_ip_get() to see if one exists and return it if so.

Therefore, simply call br_multicast_new_group() and omit the call to
br_mdb_ip_get().

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 589ff497d50c..321be94c445a 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -866,7 +866,6 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	unsigned long now = jiffies;
 	unsigned char flags = 0;
 	u8 filter_mode;
-	int err;
 
 	__mdb_entry_to_br_ip(entry, &group, mdb_attrs);
 
@@ -892,13 +891,9 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 		return -EINVAL;
 	}
 
-	mp = br_mdb_ip_get(br, &group);
-	if (!mp) {
-		mp = br_multicast_new_group(br, &group);
-		err = PTR_ERR_OR_ZERO(mp);
-		if (err)
-			return err;
-	}
+	mp = br_multicast_new_group(br, &group);
+	if (IS_ERR(mp))
+		return PTR_ERR(mp);
 
 	/* host join */
 	if (!port) {
-- 
2.37.3

