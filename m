Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11D968AB85
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjBDRMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjBDRMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:12:33 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A1532E49
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:12:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjaLuS8gwvJf3wHTOv02uHyl5eLB03lRLQ5YMQPjrU+SmoZwOfJhbkfJbf+v/pRpDcDhUD1Kwothojc4+SPPm51CqDtRteiNqzOcLPGZcZOGYQfdyHRXMP60BR58sisL4smbEEZZLnPwpJDjWzfNuVD4hOfkYf9l8NguUKlO6wFdooLYf2Ja7UoF8cNa4NG9lWkq6f02XXGmcwXC9nFjqZ9kWooT8wMP4iYtmIM5U6wLcPWxo3rh2W1MPx2jZe1BmdxRtSvqVPhv59HRfKjaQL07hIUH//e5xwAIl46bYj5jkoye3NIgZtgozM2rh7/LFbgmBf4qRw0xAwTP6HBkNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W4PXtYbUKyUivLLP3rUrPplalXXEIhuL6DL8cRncPe8=;
 b=VVb1bBZrlwlM4arhjhR9KRHy8cbijxMoU5aHwGqyhVkOUBDtJQDWrdhiEYCPxzBatviL5K6q3AdanwMVpnGxSmUHiPmAvZ5TDyLW7PGiN2DRn2jJQNG2bNwYqAkVA16Fh6uE1pkCHw96Lxm4XilT8RUS/AKVbUpNGkMU0POtHhzFcgpEH/6DAexG/Z2TiYBuTWDC7h3PiBosmMu3nasmlLuoAk++5hArN7Z7Kw/7DZ/JPNWoT7xuZt8l3FKrC303C+DpMxf05A+G5uQ7R21npGAgGVnIuMjXoWKL+NM3fgCu3+rSYLjNoZkc5fcKTOFXzQ+X/FVL0si+mKH8Vb4LQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W4PXtYbUKyUivLLP3rUrPplalXXEIhuL6DL8cRncPe8=;
 b=dQQsmV0FTx1fcBwZAvgp4P+sw6DUYWcSRS5fmFUvt7GuAtykJvqtm6rtOISPffs0VUArJ/wJdPOAwEhnwdaRXnGV6GXwtbgfgCKIA8GK1BPSFqlfl3Faf2Y55vtSa3ZVO2lHa1/fOoS7inEGsB9nuvqJwrZuFgzXeKGKOQgcBiJjOuWjw5HYzCllkdhMXdKw6TYmNuEfleJTHvxPzZebK65yic5T/0QaT+KSDet3PqEmYMGssAtL7vDUUApqAtwZeGtqnluhJGIooI1tbLv4SVNbuUlYrkVuI14fvMKOt2AM8c1TvIImt+rKu5nw56B1XdijK7wesJ6th77LO4wOKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB6816.namprd12.prod.outlook.com (2603:10b6:806:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:12:28 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:12:28 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 07/13] rtnetlink: bridge: mcast: Relax group address validation in common code
Date:   Sat,  4 Feb 2023 19:07:55 +0200
Message-Id: <20230204170801.3897900-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230204170801.3897900-1-idosch@nvidia.com>
References: <20230204170801.3897900-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c68914f-3c51-4284-f46f-08db06d2fdf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xy+iFUaMS2OO5x5nm38ggpFAZeK4y/f5FwaZjnuM2xiL0u6v9epzeQDmqczHTNyd/0k6zzz8yWCOtBx4VV4TIu1iEQQNUChLYtUucrSxK6eT76tjm9B/KWWH8Al105k+3u0gNqgKrPHDD9q8WLMkuU74yDB298pMCKqqFzzmLpiPxIIZ0Q3J5rWhKGuxmigNvSDB1XZHPatWq5jMWgm+AoL0gfP1LCgi/lDIBkwqAY2SGz9zuHaIJpTlCdKwRzYF5spdEoDA+jKlCqz82WS0w/YmX1nt2NuNhAuvHhLN7SjWHf8hkP3mluUP491H2DxnQtsWrQPF0BocizHaG4IiifCzTVbdQb/3xEQvRXV7ucX3jkbSt80dT3WUFkN7jRq1fgR+4tr86GVO6DakFIPbPfbiOuzi7X3nfOai5dixkoDffTaylBXqaLKwRlUzSO5+JkT/x2GVm69AjWM0JPM9nepM/TLt6x10sdDiT7gY+tQzXqChlzJ63Xixbw/76IFAoTxbgqiOYS3nSpmELUORHxNdaixxo0vHRvfLmRrWB+cGs8UKXqRP2ojmXs6c12YImnPJvTga6rd8kJahtDNqJ/cjC41z9JToyJ27Jq0pQBLkxPvOHTBSi9rubhqXCDr9sL5P2WyOBsGr0xjsnV1cL+HjGs6eSMYh+XmKLgAv21FYPG59SKzP0MoD5WNAjlB6D77lHXjKvwJDgvuDAZav1kk8Hjvg+7A4kIAPxyukYmA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8936002)(36756003)(5660300002)(107886003)(1076003)(6666004)(316002)(6506007)(478600001)(38100700002)(966005)(6486002)(66476007)(4326008)(8676002)(66946007)(2616005)(83380400001)(66556008)(41300700001)(86362001)(186003)(2906002)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5tBATLKlqwck8aBIMiH6kG8/ELH/OQTihgMCm/ckmmdmVF052mAo8fjpJWVE?=
 =?us-ascii?Q?1tqcK3kdLUmQIYyH84V3MY17K7fa2aAnAUJ9KAVurQbu7eRw3k8nOIyFBfpu?=
 =?us-ascii?Q?+/mNQ4wn7lGRKWM10nLl948/WvHVW9TMZSzt4iL7rvUQb8q2UHqI/OaM1R5J?=
 =?us-ascii?Q?qJSp7oZJjibOZA9PC1+prLaBXdMfc52zSm0hc6zCi1WKsS/zimhSfOuvOW3J?=
 =?us-ascii?Q?xqU/atCC4bZiVablqQTnCkTJX9CRKCR0BGSbAb6+KoKNmg38bhyWKJhO/ocK?=
 =?us-ascii?Q?5O5axEFxmb+U1zhM/+cGv6bSYZyV+vSBR/RouKEWj2jCWg46Fk1fW/nzPI29?=
 =?us-ascii?Q?jt8QNVqzCefXdfnvWzNi5sL5/xstloUJThyFoF5RJOVUtAWjLNDOM0V/svZr?=
 =?us-ascii?Q?IGFXPCQBPgDrarkQJKHINedhUybrQz5TlL4AmFtRi9kviaOAZSM+RXauw4Zn?=
 =?us-ascii?Q?kX/0KHlXclBmJWTNOVldLL0Vx8sAYMg2LwhZy4Gwr5Zy6koxRKRsRQ+ZICba?=
 =?us-ascii?Q?9s/5OpieKdV8FCvWvztGTWL5Cg/oWxWzRpLZngcgdSvk12tjtjnffDigGHQc?=
 =?us-ascii?Q?6rGLm8NyoWLDfqTzOnMdGcRlCFsdetH00u8UYCsSN0R8vi22vYeiwKycJwSm?=
 =?us-ascii?Q?16GwfzKkY+VJWzxJCHLIFleWnbWoPxEYqLSFP7eqc9pX8q3CIVHkU4Zuq+cs?=
 =?us-ascii?Q?KTlzARCvJeCxRNoXXmy2jKMkGRBbTfASLdFR1BHaJ3kihbcDp2EsTOlrLwX+?=
 =?us-ascii?Q?efS2ZL/3KP6PWevFYTkoQDogU+ljKG7IYhu59YQXxMgQmXobfAKjN1yJUfDp?=
 =?us-ascii?Q?kh/rPY5vshI6XkmTgMfzwMSwkrWT3RhrcFubmrnc7fnDDkggOfgnHZIPXO8z?=
 =?us-ascii?Q?QWo6PE+RBkWBG6jDKRXPph3w8hcz0CIcZYvLhfZMKEf5joH8C+QM4lAjfCaE?=
 =?us-ascii?Q?q1Ba0vVPGKSX4TpmUiq9FrJujROwx8IWEV2nlY5oOKL8EB7kOufor+MEZ5at?=
 =?us-ascii?Q?YLwJPuMSpGDIBsNcneQsNWcZ6iX3kCUa5Z/uRTtzS+JonUJetRjuFG1o/jGl?=
 =?us-ascii?Q?8Bn744+DQwwg3Wlp5Ie3v9XNoMXLuJeXXtCTRylscFuHk7RCW97Vfigm2DVn?=
 =?us-ascii?Q?v+5BYV6LHg/EbtjGOr5w1OU9AdlH3sypsTE/wS2tgHFZ70f3rsiDPrE+EAqh?=
 =?us-ascii?Q?P2Gecf7yXVFIV49XfK08Vym9RuYb1PevBvRJPssJ2O6yt6b6fua0votcxf/e?=
 =?us-ascii?Q?kHd6rG+nuzqw2o2xuhFUymfDvmSMWZnwXiEJ6yfKhE0R6iIHys3f9TBORqS0?=
 =?us-ascii?Q?+Sp9qm22vlJAgcJl/kz55F9WLYYJcG5D42tgFNeaHKpjlbRQ/l6/esUCMEHZ?=
 =?us-ascii?Q?SAGMPOSf+w3Xm+gL26OW4gk+7rGe1uwhdjRXPfEHIxIUhUj2sUsFCtUEmwAV?=
 =?us-ascii?Q?sVih96ggqyAQMDQ3bEberr2FIa1TBTBXK/QezyMf0pEtx/xBZ1STIstDE1VD?=
 =?us-ascii?Q?CNUikK5hb7PxWIA79KrQ3IuGoIfRQPAJeMOj3ZTlFC1nPE3vFbXJAFikKmFw?=
 =?us-ascii?Q?waVWYpGv9r+jR0pnphMo3QD6L1qBH5c6uJwKYJfR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c68914f-3c51-4284-f46f-08db06d2fdf3
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:12:28.0328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wfrBH7qfDlkIWJRQXrv6UJdfTvjxbDRCz2TRYcj/Qr/2UG1YBdRnpEr0LLtAmBfS+LQz8NCBvSFuREXzeHHjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6816
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the upcoming VXLAN MDB implementation, the 0.0.0.0 and :: MDB entries
will act as catchall entries for unregistered IP multicast traffic in a
similar fashion to the 00:00:00:00:00:00 VXLAN FDB entry that is used to
transmit BUM traffic.

In deployments where inter-subnet multicast forwarding is used, not all
the VTEPs in a tenant domain are members in all the broadcast domains.
It is therefore advantageous to transmit BULL (broadcast, unknown
unicast and link-local multicast) and unregistered IP multicast traffic
on different tunnels. If the same tunnel was used, a VTEP only
interested in IP multicast traffic would also pull all the BULL traffic
and drop it as it is not a member in the originating broadcast domain
[1].

Prepare for this change by allowing the 0.0.0.0 group address in the
common rtnetlink MDB code and forbid it in the bridge driver. A similar
change is not needed for IPv6 because the common code only validates
that the group address is not the all-nodes address.

[1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-2.6

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c  | 6 ++++++
 net/core/rtnetlink.c | 5 +++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index f970980e6183..88f0519520d2 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1249,6 +1249,12 @@ static int br_mdb_config_init(struct br_mdb_config *cfg, struct net_device *dev,
 		}
 	}
 
+	if (cfg->entry->addr.proto == htons(ETH_P_IP) &&
+	    ipv4_is_zeronet(cfg->entry->addr.u.ip4)) {
+		NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address 0.0.0.0 is not allowed");
+		return -EINVAL;
+	}
+
 	if (tb[MDBA_SET_ENTRY_ATTRS])
 		return br_mdb_config_attrs_init(tb[MDBA_SET_ENTRY_ATTRS], cfg,
 						extack);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 892d4e8fd394..1c7a8cbc4ce1 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -6149,8 +6149,9 @@ static int rtnl_validate_mdb_entry(const struct nlattr *attr,
 	}
 
 	if (entry->addr.proto == htons(ETH_P_IP)) {
-		if (!ipv4_is_multicast(entry->addr.u.ip4)) {
-			NL_SET_ERR_MSG(extack, "IPv4 entry group address is not multicast");
+		if (!ipv4_is_multicast(entry->addr.u.ip4) &&
+		    !ipv4_is_zeronet(entry->addr.u.ip4)) {
+			NL_SET_ERR_MSG(extack, "IPv4 entry group address is not multicast or 0.0.0.0");
 			return -EINVAL;
 		}
 		if (ipv4_is_local_multicast(entry->addr.u.ip4)) {
-- 
2.37.3

