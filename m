Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDEC860249E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJRGlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiJRGlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:41:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5D6A6C3A
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:41:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwSuDUmuTRIDYAVQZsJnkkuamdbd3FBkEsHdXvfpGlwu5dAi3l4G8VmOlGXZJdDZlHN0vcTflX6B8gr6lZKWUD4Y1NWDmZ/j/KrnlKoaXH36WdI3iYaM/PJ5tcQijg/WfsayfRlRlAAMJYUb8b60XQOv2yweLm2WAyrQX4r/JCqXjFOC38EEWxY6D5ztbc26S/l4kBDww7nNyxYibYua9LSVIsP5pBuf8DxAg2iYxIuYJS/LHg32xOitzgE23I0PzuGSrwIjeXPrGTtgetvNbAZSKGO6v71Q+xlY++/oV+YjVm+ThQ54P9zNc7jQB+r7ykZJ2E5dwQUSioYE6G0ajg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s10p0x8l2IB9To2cQuTum0TS+L6JRi3MMfMwlGMqbSQ=;
 b=dJzaOGNv9Hn4G1absu+rR9a4bmAAsECrJ4LayrYxXL4rNjD0KhuHJ51XwXD/aei04IcOCPDz8y+R6qoeAAl7K3cXnkNEyHjlHd0TKbTvCiex1M4MtxztTlFW3bQ4KNuB4m4MWMzwvBE1bpjZSVr0gteQHRrm3AFLNFHweFjQFXG9ooYs+pB9wpN1AwiN3sH3+D0HWl6joMer7ydoTIGyb/VcVzA7VrTQP8Wg/EnijpHFWAmbaw0dtSThzS25dfpS3bmo/O0b3Ozb9eswFjfxx7uoY4UR5QN4oHspNyEe5/+4J4W7gw9gSZ6aMrrkuUwrm6JbBYtCUFxcbvrtXFYFLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s10p0x8l2IB9To2cQuTum0TS+L6JRi3MMfMwlGMqbSQ=;
 b=pob6JF4qw80DscsIeD8xb06s9wM4e3CYSYWtgR9gUbgeOyGpgVIU+96scPcoAQp1jzb0mBOlP6o1fOtMogQtlXNjRJYgYv8oulm1Uc39ZFE4jmfLct9OFlpr/rzOVRsrGrLRcrb4J7mUAJRet6X8mukx4qLHXETW6dNt4XQE5A7AGC1MWvEjMK2JBRSeePbhPbqgvEhv+dp5s6RYg+u83tMF3InAhtmuANRzSQwf4HaJdKEQIoXtLyJhctbsR687MVmKu83x8dcwyRQao17c/azbF9PjxUEVFD6ecQM2F838VXwc7brzmTi+qeGCuau4oHaC1JtI/JB1EvH8xY7P2A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH0PR12MB5385.namprd12.prod.outlook.com (2603:10b6:610:d4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 06:41:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 06:41:08 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/4] bridge: A few multicast cleanups
Date:   Tue, 18 Oct 2022 09:39:57 +0300
Message-Id: <20221018064001.518841-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0026.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::39) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH0PR12MB5385:EE_
X-MS-Office365-Filtering-Correlation-Id: d7b53f97-f139-457f-8f5c-08dab0d3bd12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 06lrDlpsylNaIW9ioUTtnYpf38e+MXZeWFOx750bNqkNmhpt/ItJKuhrH8HDk2r3gb3DFrU/7HQNrJmYdnUWojo9j3iQLt7malajxzzsrM8nbcgabyXQHBFfg8hjnerX1xqsMfkWJwmq4dXonsLojb2pzq7LQYvetXEcvY5aEfnmS2AdK1YvT9dFv7bli4Qdjm8RLsR5MQX0X4kYy9JEqZB4TFApeujH5ZOPawOT4VcNoli0QtRI9733v/v0+MP3ALtrHIVWAakwY02iSYn8qIpsvmH4Tb8CidGRv+GKLNJr7kAS/pCzKO0293butwSOJ7O8GmMyaPpRPJpTom+7bx0caSbyGiK0Fux1t0wXwpJZ50RKsS0MJWS05f/huXGi7QlUsxNEXx5hRwmO0lt2MMrIfZi6YwBFP6VlqUq2q+v39wsx4oaAmWHIw/Zj3m9FgUeuFDRN9r4Z0H92VbVZGKTmRjXDckC+Cx+Y9oyt8KTU6qHphvQLbAqRq7oc5kpbS3cBFKKAyQD2evrgGjzRFzfUonNVeiOdG5S/7edNN9OVs5gE+qeB0vvn97r7iLIZCtu3BFeLn9w8ilz9WjdUpn5CqPUTzlsCFfP6+4mIgwpUkSsdCRASfXqIg3OYiJc4nW/E9nXsMj42opqEkE8KzxAxZgOf0xZCM82EuPcTtD+YAxia8dCiDgGJaw6K+kqldMMWMPmeefGT0VALt5G+6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199015)(36756003)(86362001)(6512007)(4326008)(26005)(6506007)(8676002)(8936002)(4744005)(6666004)(5660300002)(41300700001)(66556008)(66476007)(107886003)(478600001)(6486002)(66946007)(316002)(38100700002)(1076003)(186003)(83380400001)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i02r56DpMcTU2ATmlnYCEIZRqPyW2uqjCfhRFwyI4msoL2vyQ6xjBKxBnB25?=
 =?us-ascii?Q?5p64L4obMfH0xAM9LLHu9D0V3vWiJ5wY+vjvRkLt4SpKiNKsJLn+638OPbsg?=
 =?us-ascii?Q?zOD3A8QWcGbXU4GBi5eCVaU2M1ZKaqwgrMWd699O5bKVDNMBrpJ+3J1aWh0e?=
 =?us-ascii?Q?xwtWndQZudFljmqzCKtK0R4yAk/Ouernz6rFp0Lsiqb8NwcPqKxkAwouP9J0?=
 =?us-ascii?Q?lvKb7UUxMkpgNXLblUYDAwUuZN89qE8HeSBMNPDsDTjPNN2xxBlfVDhT3wys?=
 =?us-ascii?Q?/B6uioCNwQchB04vCSYHKXHO6G37SCEX4moL3TDLGzGIvtv7otI6gIQiQCqX?=
 =?us-ascii?Q?GZE1R4k0n2h2WrUbGUHrI8Ar3jserqrIy41DuAUh4quk/N6iGYFCr0FF5e82?=
 =?us-ascii?Q?kasZj6UXT65OduSHKCWwd5lI/RHaEUKq9RgpGv4BpkzywN1ILzvdhMzN40w6?=
 =?us-ascii?Q?YpiZdi5ggMtocNaD9Ab1tlRGOypk+pRx0p9tUdU3N6bcKvK5FzW1zTbNzl2y?=
 =?us-ascii?Q?tAxy/A26fs81H/RUyXpW2PS2+ywiQBFsxRG5QrI+yj9bm1i7CzuNfEWUbfz6?=
 =?us-ascii?Q?dXiZ6h+xLG3C+0MWGBAieFVowPp2w2Ywk1ZowC8ADu1HH2p9NhuB0/HwQyP0?=
 =?us-ascii?Q?zApoem5z9F34x/y/rwQV7g9jC+bTBgVi/aEOhtB/U1W1YrE65yOmfjHLMYbJ?=
 =?us-ascii?Q?zU60UoEfOBzdZb/ycx1+RLJyAECUciUP6zgJGbO7pUtoDeznlAluOWk6ty5w?=
 =?us-ascii?Q?qzBBsZF0Ir85DVtaSz9fPfS9bWM6ui9I4w75OV6FluIUip9b5+ZEZO4V31aZ?=
 =?us-ascii?Q?xbd0uNzmYFK4bDa/qFIB+NXa9T/tGhblbBaiNmbXAy0OOLeGDXsE4Gz5PB1C?=
 =?us-ascii?Q?h2Z2K+jq6bHYq6hUaYjy6ubHAtvbZU/LL4MdaTjS1NSyGGd1OiPTNxHnyx1C?=
 =?us-ascii?Q?Le1D3CJVodt25/Z0yNhkJwC8GpoW/Pw7zZVrjxbG0n35PpcoYHExJAJL1pC8?=
 =?us-ascii?Q?sJ4O8znZVui23x95tqWfwKUo0iQ3glvQYK05I19PfPxkTDU88fuJrupTDY25?=
 =?us-ascii?Q?acqMTZxfPsBV3OBp3R0z19DouxFlDxD/zn9OT2HJ6O/zsT6v3V6ewS7SQb7J?=
 =?us-ascii?Q?9n8itfJrICXv5Xjs3lzRmp5cdcO8wRpx3KXjoKjeg677PpNma1RrrRwW4prU?=
 =?us-ascii?Q?8LGYiSYyXSdohNLBOjG1+Gb/8kUC5XCy/2DTL4jcE62wsLTaerOQyGCC0DZo?=
 =?us-ascii?Q?APCPq/UbKCQ0Vi8nCcxZk7U5iyxoM5qobaBvlUIaZwTq0pT7qDFl89UYvpn1?=
 =?us-ascii?Q?HqAX62VbILQfpq7kckrLuXh+2NHMUizoopuularOzRvbAEWKTRWmB+SwsrAO?=
 =?us-ascii?Q?Qu3sTjLOEO8TTPLQZvc25nPAOwIG2eqsbp7UKL/U+0xQOeOetbbN5+tLo44v?=
 =?us-ascii?Q?rV1QpttAzea8pJ/wPvpysB+FGxDbBDnyeXvwuNSV9regfmk5bj1r2y7Y3jmL?=
 =?us-ascii?Q?ZlERayhjkw80DynLYLD7zFdVs92ttZoVM93OGf0+y/uhNWjqclAWcvNjy9VT?=
 =?us-ascii?Q?o3Nlckndm2V6nSFOLWjQcmSi52OcryC9TgfBoA4/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b53f97-f139-457f-8f5c-08dab0d3bd12
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 06:41:08.5700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Hni0XQS3LLydc9tpKFs5sRwTry8lv5do1B4A8Igcjow7irx94l8+1Qa/9CgmcLErn6mwT2uCu9me8MiJ+oNCA==
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

Clean up a few issues spotted while working on the bridge multicast code
and running its selftests.

Ido Schimmel (4):
  selftests: bridge_vlan_mcast: Delete qdiscs during cleanup
  selftests: bridge_igmp: Remove unnecessary address deletion
  bridge: mcast: Use spin_lock() instead of spin_lock_bh()
  bridge: mcast: Simplify MDB entry creation

 net/bridge/br_mdb.c                                   | 11 +++--------
 net/bridge/br_multicast.c                             |  8 ++++----
 tools/testing/selftests/net/forwarding/bridge_igmp.sh |  3 ---
 .../selftests/net/forwarding/bridge_vlan_mcast.sh     |  3 +++
 4 files changed, 10 insertions(+), 15 deletions(-)

-- 
2.37.3

