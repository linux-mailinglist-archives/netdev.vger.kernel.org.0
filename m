Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB894E4F53
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 10:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241829AbiCWJ1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 05:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242642AbiCWJ13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 05:27:29 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2099.outbound.protection.outlook.com [40.107.93.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA1753E26
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 02:25:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFdjzoUwUhE5Fk/LNBiNulS6SAp8c0vlWbs87p7Ra6i1fOUnqFEfe6+Lsjs7BCoLXgqyL7MAcjSmrqSVRjCwWHuUYeJGcuC7gfD5BFpjhx+ES7+r3peehVqicMPFgW3H1Ch1oyfdiWxdlENE/5IMGmo1z/6qpzs2yzNOrTQIFJuuh274jYHXfJqQxVTdyNj54Gq8EnknHQ0Sy2hY4rmLqGDg0kUFwQNu8XsHTuYdRt2TLxM4g4/ginXn3A88xtrgz10YTWMBjbc8hj+boxBbLbU+irBLD8s87wWg4G9oSKlqCi1f4hbYv17mjozZEvA9oS9r4amN8kNAF28ueBuYxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=siTY176O7bB1NWpOmpRTr9Ci2FES6/w7GqHhtSiMgEQ=;
 b=kbYEnQ8eCMesyriQx/br6kT4SEe/HqO3kPvGqqpVU+Yvx4zrPoWqNw1mf0hx/KpEWCvU29m5720QTjwJ7lQdIOySxr7MO9hc+oW986de8HNEk4ih1yg92OyJkiJoIpJPiGH6xZdKmrLe2tCcFfqt0ep8VOu+ihS+GHU8FemZxnXgisYa9jguX5NoTxO+Iud586+dYP3TAV/2cN+pJ0sRdoE9lBdD/aK0Z8Uyn3hxCp+fElJSfkPGnE/Mw50VcLTTliO1AQeSIyQ0vLQk2V7lgWVksAv/OEwR1a1mZi9Vp/qdOLADo4ij6b+wD2Wuf4r+vAf734nguHBegE16EyfA8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=siTY176O7bB1NWpOmpRTr9Ci2FES6/w7GqHhtSiMgEQ=;
 b=lKYLV9ngSMVr3Klp7KypArSeN2iEX+/kU31u/LcnkGo8wuwXGM6jl4FUeT0MgJzkGAy7I8nRthpsn/heiq/ZFO9HK2l57qKn/HvTAZDSd6cAaQFVartMZL7UROXZRZDiaP/X9B8QmJsjaiwQQH1rB31XS08Kx0WxS6U/Ff+cNM8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 MWHPR1301MB2079.namprd13.prod.outlook.com (2603:10b6:301:35::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Wed, 23 Mar
 2022 09:25:58 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::ac34:cea7:1509:b711]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::ac34:cea7:1509:b711%6]) with mapi id 15.20.5102.017; Wed, 23 Mar 2022
 09:25:57 +0000
From:   louis.peens@corigine.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     maord@nvidia.com, roid@nvidia.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Louis Peens <louis.peens@corigine.com>
Subject: [net] net/sched: fix incorrect vlan_push_eth dest field
Date:   Wed, 23 Mar 2022 11:25:06 +0200
Message-Id: <20220323092506.21639-1-louis.peens@corigine.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0055.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::6) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1b859e3-fc85-4c38-bc36-08da0caf232a
X-MS-TrafficTypeDiagnostic: MWHPR1301MB2079:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1301MB2079AD47C4DE140F10744EFE88189@MWHPR1301MB2079.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2i1RkFZp9d+0jqjHMZdOEyYZzxZh93Yee/lQYrBh98w0BIxBtOgZHuIhv6xc33V7W5yNo8NpBiuN02r6khc7+slTDL7FMAmTZ6Vpsft5W0GdSCp7oVqCxmMBzImC5K6yPnKHL6Tl6F7qiYEEf5m3iS8+EhWMS5WiRLou9W4yaJitiahLUxiys6EwEdcMr+CdrWYdThgG/qA8JlResS5xspBwP409df5Qx0iYjedRjmaFW/F3hzPlAzdc5ezBYKFPd82RJQnn3A+zYr4URDgAuDzvk8Yidsn3u/GsPd53AiIV2RIeyALbCX5yBiKyVdMbkkDEHN7yPj8WV9yYoIGURSFaNSAUJ78FgGlnyJ8DE/y/ndR+tWhhaSMuMzjX0C1No+aXfVR/SPIYIFIdN/iTamY6STuk4gwFMXq8LkUWJ7DJhvudyzXs2hrC+BXbLhVe4Ak/n/ESeIr7VOnsbsmTOYHTBbc5CJUKQiuCkwEuLq7S50uBFR59yQOV6kXO/lb8VLjAyNA0y8Lin51gTF1e/58bZfZYumqA4VWSeAo68N7MPgk3a7XTLBvZyOer0wL2Q3nCmqty+hBTWDzDOBURhnHMdU14IZVf21EDfthFZm5ZLEV6lJkOlxMt/1TQCzna3pL4Cb/uh4FzqRpJD05TuOzJYrWx8fcTQoDarVTff1KFmmK/ucqspiT5wGG477Xnl5zN3QUxmQ864sg0iubo8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(396003)(136003)(39830400003)(366004)(376002)(83380400001)(5660300002)(6506007)(508600001)(66476007)(6486002)(316002)(66556008)(9686003)(8676002)(66946007)(4326008)(6512007)(86362001)(8936002)(36756003)(2906002)(38350700002)(38100700002)(4744005)(26005)(1076003)(107886003)(6666004)(52116002)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ns1ctOQFFQ2obpAd0zjUir+k7KOQ+FxkxuSoSSVXLYZCTeDx7hynLLDPFceH?=
 =?us-ascii?Q?uSvCgRKzqqOFrw1rOOQtdApv4juImP4D0R5CfY2QJ8t5UroTgsWUpIU+q63E?=
 =?us-ascii?Q?YFlXTF2WSQZtwVatN0B1jcesN6rAxVOPwvNgKj7Q68sOIBW6JcU2kl/1hkoh?=
 =?us-ascii?Q?+5YP+3g4d4KV4rMrY6JwjaA/nGHnaQE5a2zOT/2LGGbHdZy6IbjZcvwVdk6K?=
 =?us-ascii?Q?Fb87ED68fB0BM3mQFbfEcocg8cMruNQpS9qCFuSolNlb/OVWI6f+ChGao3sQ?=
 =?us-ascii?Q?SqNXfI/NUZgeAyaa46dUvKgdNu1BZcYcfonpmIsKIyCmxWY85AiUL4D4PTxf?=
 =?us-ascii?Q?LTxRmTPQRKbk3xecXYbaNkzhIvBWlKW2SZ8XunH6Bg685S2ctIDpUFG8eOKg?=
 =?us-ascii?Q?z71cgwPi8scxU3TjO53uYprFjYvYAqWqrtZa8xb5mIPsoJgI3naGWp7+vMzs?=
 =?us-ascii?Q?nD+JtYAbkykyQlHaVsFuB46oBoHT9xvX2SXMuCORAIcfTtSv/zULIC8b8aka?=
 =?us-ascii?Q?sH+FYTRFQsK/6TElHvkTsPfbl4Sj6Wfu4cWKmOpzO2RhsZvwRR1mu/Yz+tIS?=
 =?us-ascii?Q?brW9K+9Pf8WFSyl86z6DYakJRz7R8oF6LELxPForXcq7QhzxnTzrD+/gklpk?=
 =?us-ascii?Q?FmWVw3gK6PIRfW1+Nw++qMtksyTAEkbtqmqwM+JzZnfxSyF6W9S+9zLYI2Gt?=
 =?us-ascii?Q?n5GgUYX0bV0tqrHQ+oSc1y5jzw/zx1JD9ddhhZ9oDoiyg6VEGsXmRpVsO6Ql?=
 =?us-ascii?Q?alTU/K7RVXu0vrfAglcEztRSkPEKHinGT+Y/XDJOsJZ23ONeFd7/r4CGDAXT?=
 =?us-ascii?Q?sbb4ClEsEYRbb/N6RtAVZlBsLIm1bRU/XcBmhOuQ5p49qGfXsScxamE45koR?=
 =?us-ascii?Q?YKP2iSecsVggAigV619rMdYQC9SPW+X/dXNmROz+d7UJwVWMVfP9k1ZkXYQy?=
 =?us-ascii?Q?uR+w6N2p0+cdw7Y4iWC/ISSoSa/cJjSab5BFqXkCFj0ixHI7JqynTvmDJ4GU?=
 =?us-ascii?Q?yUJJ2cxOEqRr/QPeVG5szgtLTnwzUPNu5UBzuwh7c/VRJWc9HeBjqqEpFVdV?=
 =?us-ascii?Q?lN9o6T8sv8CLD7jdJWUjDzDGjN5yfZabaA0YZf2lWukeiUbD1RANF4d4JeVm?=
 =?us-ascii?Q?H4/lTXDsvh0oSgqSbX/X/iamW6SRBEGfbQ6N2RnfwM7XuiYeV+pfovr5BbFp?=
 =?us-ascii?Q?kftrLFx0v1Wc5t4zHVoPcg45Z6S2yFIdK6dc/Znbd9+AyFyqVh94JgW1VaXY?=
 =?us-ascii?Q?7Cf21pu7tT2SruyxK4uiUDRKDbGGElxqh5IW+bJKJ+Z03tcoeUaJBIlimdjL?=
 =?us-ascii?Q?PSIu4QiX14A/GdkEaaLIhUXmSSJgKCQuMmUYfED7xpFFrewQdZLClyNz0owf?=
 =?us-ascii?Q?UhPFNAfHx3zl8BeguwxPdj6BXxV1sXj3XrIddSRKCWLtML3bLok7warRDK8F?=
 =?us-ascii?Q?vQRd8UnuqqLMGmv84DFayRm3xMR34iTys5Rp+0dk6WlTAkq94SNHFQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b859e3-fc85-4c38-bc36-08da0caf232a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 09:25:57.7815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mYgFqUD5jvOIHpySCOUraHJkgphvWKdft32sTyZBTeKxRZQjIdVoRCnxZpAAhR5AePHq4YHfL6fI1fEtXgXHEZRH0PTbAMKQCL8yf7W/OCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1301MB2079
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Seems like a potential copy-paste bug slipped in here,
the second memcpy should of course be populating src
and not dest.

Fixes: ab95465cde23 ("net/sched: add vlan push_eth and pop_eth action to the hardware IR")
Signed-off-by: Louis Peens <louis.peens@corigine.com>
---
 include/net/tc_act/tc_vlan.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/tc_act/tc_vlan.h b/include/net/tc_act/tc_vlan.h
index a97600f742de..904eddfc1826 100644
--- a/include/net/tc_act/tc_vlan.h
+++ b/include/net/tc_act/tc_vlan.h
@@ -84,7 +84,7 @@ static inline void tcf_vlan_push_eth(unsigned char *src, unsigned char *dest,
 {
 	rcu_read_lock();
 	memcpy(dest, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_dst, ETH_ALEN);
-	memcpy(dest, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_src, ETH_ALEN);
+	memcpy(src, rcu_dereference(to_vlan(a)->vlan_p)->tcfv_push_src, ETH_ALEN);
 	rcu_read_unlock();
 }
 
-- 
2.25.1

