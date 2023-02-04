Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F58468AB84
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 18:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbjBDRMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 12:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjBDRMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 12:12:30 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDAC31E15
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 09:12:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNO2PyhJaDP3BPf230uLCFO/du1d8TZI8knANGTCRp9fBIi1jeoXNr3c5M52O7haDY0NTRA03Jx2hPc4Fn9ajrvBNK2ivcxDmrCAok2w7y5PsCu3TgnsgE+l+XGz0sFY5IFLTi5+oImDzmBYzyLRiUXSnu3GpEWc158AV0isDwqvPjcAzLUAPn1/PPOf+VL+HjCG7SLbRfIoi7q41ITcxAoZeiL87m+x2Gt8sg47YqFWdcum1ohWJ2e27FruVyJ8b6jrY/2I+hwh43ztijT/rXp+U2y3/J00LFt3eNrjQ7RKN7+4znjYUTOLAwtByZgsyZ5W+PEhQbSSr9gqgcefdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H118GTbbUjYBbWxrSZ76Di052XILnkk7sJAbW42lFL4=;
 b=k4zBEz9DnKb/hqqDbLtSS4CTsGFxvEo+cyhU3weUJMf2XSGJjpu1W8SvXsipfw6sOyflXx5I2vjQN8IGnA9qhKN02dLcX6X/O4Dl/mJ+9YVtP8R2QBiXFpJbR5K0kUhGIUxc0k+fw/LsiP6Mn5SxYj/nLcY3P9+kQzPMmhMcVLAqxCgTvi9O0hRxKtm1BOKCHyopjC/edKYO2ISaYrCn9r5iDuBU2QLqc1s+jhYNcWkkYNuzo6cUI2fWZ1NS0JTgNLZpv4PddegSSNLETYijljOXYdrz64/+2fmNtaeqgLZMuguF/R5ByIGW0UF8/emPPDeMK7Ke8GUeRjY5K/pJiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H118GTbbUjYBbWxrSZ76Di052XILnkk7sJAbW42lFL4=;
 b=t54L0bLKiktrj5Ii4wA+JgM8DH9764xhXdRQFyV3TDkQ9whtxAWwOuQb9kwwyC7WogZU8//GBAaPGKdFYWqFwVPjgE2pFl40U8zDuS+5vsRX/W5n3g790uD9u8kYK6h7FK2TF4Mx5L/PiziEgFR8dkvM7zYvczXXM2miPc8fOZ3GiaKGvxvWpxjtCTTtn6QTJfCXqKI/Bm+uoykum5yU/zBWaFvYN5JUqNgYBTlxWeb3FiajnaOwPLn/KpTAJQ+nrmO8LPaBLGTku8CYBz2SFX5m3p83m6LzQdMJJCIdnC2jqwfditZC6suj1MQbv28B1vOCVwmw9OPYTEOFfH/Mww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SN7PR12MB6816.namprd12.prod.outlook.com (2603:10b6:806:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Sat, 4 Feb
 2023 17:12:20 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::7d2c:828f:5cae:7eab%9]) with mapi id 15.20.6064.025; Sat, 4 Feb 2023
 17:12:20 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 06/13] rtnetlink: bridge: mcast: Move MDB handlers out of bridge driver
Date:   Sat,  4 Feb 2023 19:07:54 +0200
Message-Id: <20230204170801.3897900-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230204170801.3897900-1-idosch@nvidia.com>
References: <20230204170801.3897900-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P191CA0003.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::7) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SN7PR12MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: a98ac8a9-ceb6-4a1b-0f59-08db06d2f949
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sO0DhxVauMJwcAzUvB6Cvg9Ou8szbk5Q85V+t3nvFKxVW9+ESEpFzf0xfelLSmOn0yrl/fqZCoXDnB5hRWvYohaJZpbmTneBQtqmzqXKNjZIDdWZ89WjTK41uHddeCes/4U1p89567JXcy/ni5S1KMFqAeaDXRYQ9R4R7s9CQfxf719nFLVvcwFpvTirtfwW1UUjAlghZEGtjpADtNmVUuIzFqDyxRzXB1ghqBJBhvo1hPebZeU/Mcvliz2MjC4IHgNPIW90TZGknF0CjpLZRTcfrtKnsRE04FdodRUZakKBdEt5kviRkExb6YNAIk4z9ckVpD2BFEgZ0gmHOgAZ566+cwnFdyjq1Sv4zv+m7HUY2ETFvVSLtooVKUzcBE0/GO0sh5vQKr2ieMg8uMXHs0vq71MWSg847c2VaZt/23hhwAgxSZ3mtgUjRxn69/IHvNN+jOreAmtLAGnog6JqDI7ANyqNTXuuVfO0nvtHwxSi1+Ba/vXSzEz3ISCTsKhDPjrlTwwxaoZVjNo8XzXlDFnqiWRZeMu21lUI45MmARYq55c5/4opYxrB7LTsYaXSHi7dnzHYL+QaXgZ/pkpI9F3RJulfc1ydT+TXbvlLDGhSDcJ972Nn0Tlcvc27mHBpqMwVBg1+oSU4NvC8wnVbIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39860400002)(136003)(376002)(396003)(451199018)(8936002)(36756003)(5660300002)(30864003)(107886003)(1076003)(6666004)(316002)(6506007)(478600001)(38100700002)(6486002)(66476007)(4326008)(8676002)(66946007)(2616005)(83380400001)(66556008)(41300700001)(86362001)(186003)(2906002)(6512007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sh2oJnR8sH6PCIF8bktyHoT0ISxWCRHSN1DFvfuOvo/bSMFBjiKTnr+KBUDv?=
 =?us-ascii?Q?u++oHaGAJOUkk4N32iYDOmrjrLd5XFJbaw/AujOXzb7zuvZOuyC9K5670Yt7?=
 =?us-ascii?Q?mtPt9h2FWApsatR2cZWfMgnLA3HCsRiTFu9zG6RJvCvEmYIDc0Ljm1s9R4FG?=
 =?us-ascii?Q?AAHT4ChAMVecVU0eAmRxhFNmYoCT7pEtXIvmqJxitylFg66Qc2M+lS9PuiE5?=
 =?us-ascii?Q?tsOEPdys3KE4LnDG7jWxLCo3uQ+2PD/2YXlbHpdnPthreie4dMSd1jov7RSy?=
 =?us-ascii?Q?64DjN7uj5qnP68YesVOyXPAD9zromt6pYTEPVB9ZaGzcI4YWSTTpE58RDKm0?=
 =?us-ascii?Q?Nrgj0Ky9v+TKna+sx6yyBZjzzHobo9YCBTi6zg8EX2mS85LrGtdudBiJi1RD?=
 =?us-ascii?Q?jWAClM7UWC7woKXsffAaSudXQiY+4Twe1IuJJb5wRCJkP+aVxgx/uo1kzeOY?=
 =?us-ascii?Q?roHEVLAGAjgOEzQSezaZOMeM3aQgvhB4Js4zBji4VxVwUoVvQUMLtynJ01Ni?=
 =?us-ascii?Q?oCU+v1CRw1JoM/BUmyMqB/2QSy3/wDpU69HcRH0WaYjRCAQ5fNaM1G3Y0lUp?=
 =?us-ascii?Q?kwFG7QHB5PO6sPkES8r7RbKm9aUOE9smUoevHLWkXf6HzvuCiASRAFQCBNl3?=
 =?us-ascii?Q?20lspMmHdPSgjbWhEDd8Lf62xQXScYz2yJYvseOG/YbS5vv6gCYdG+L1eIGg?=
 =?us-ascii?Q?YJobHJV4AM7VXSCnFnRLwRujBK1MyA1NDf8lpYaFn3ezMdCJm3FkPn6yMV39?=
 =?us-ascii?Q?kiiMsEpCNQ57VUqH7RuHTwNNnk2mwoGYfEYn9qcvL/VxFMY5j8iv4G9m0CJo?=
 =?us-ascii?Q?sZ7Zka5sApBIlsYsNrpRXVIYLp/VpBlIXXZ++IMBXL+tEZGfHiPol6WbpSap?=
 =?us-ascii?Q?uDjSuxjICnlO6K9p1DaVYQWWeQ2SB4Nn9o7bJyRfjPocWEs/91iTkM8WsblC?=
 =?us-ascii?Q?1NF+RL6yAyeTEebHl0Y1NiBRqMYo6kdLT9gT70uy+OYUPnM61kel4aqjbrI9?=
 =?us-ascii?Q?Gb3PgW1zbmiCRHMqQPPqqJYUAkJHpTuvxE1rcVuA5/suG7t7p1xeR8PEKU5K?=
 =?us-ascii?Q?5u3FBYPszTgMcu9WBYYDAHGO4GlxUhOs+S0ri1ZxPHvd23KGvm9gzkTKBzsm?=
 =?us-ascii?Q?TYL7Y6KiXggUdgO8CspjGLxMXSygcg1uVbIXmgvToH2pt8/y3GBDVswyF8mb?=
 =?us-ascii?Q?is9oMaifNUkSU7FO+f5dK96h/Pz3wme1ZmnvNISoJxs07bDycU5iURoLVgiL?=
 =?us-ascii?Q?EmYVFOTrLih1gwGWEK6A6ak1VSRfrkrQyVh51XHkcijadphvJ579WMC/1h4A?=
 =?us-ascii?Q?egGsr6eDa3kGk6SArXwMSI/KPlZm+KwjAtJpAg0nqatMi8UOhKhUESIOuxe1?=
 =?us-ascii?Q?1IOg6r4qBjiJ54iZYz+Uo1dswjyPIDZ+ThTmQ2dU1mSOBX8mA/uQDMRKqdEe?=
 =?us-ascii?Q?MVUOCXldIWiz2r3I6COM8C4mNxTVaf7J7oBqYNkGXdU6KTmixU2ecuLLOPb3?=
 =?us-ascii?Q?TLJKIubYDS/thb7+OAqwgWwy7xTn6yoRn/FYkpky2NBBlo8TAb+CnJo4Ph6O?=
 =?us-ascii?Q?QD6U7yPeCxvFQ7jlZsciySHi++v/TjEO22sxSLKN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a98ac8a9-ceb6-4a1b-0f59-08db06d2f949
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 17:12:20.0770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IrTIwX5UHGGj/WWHo5gdauPMOD7aqwFxKE4RYrZiqfbWJELalb0X+sS6WqxBl6lTJcx0KkozD+lE5h36QS8YbQ==
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

Currently, the bridge driver registers handlers for MDB netlink
messages, making it impossible for other drivers to implement MDB
support.

As a preparation for VXLAN MDB support, move the MDB handlers out of the
bridge driver to the core rtnetlink code. The rtnetlink code will call
into individual drivers by invoking their previously added MDB net
device operations.

Note that while the diffstat is large, the change is mechanical. It
moves code out of the bridge driver to rtnetlink code. Also note that a
similar change was made in 2012 with commit 77162022ab26 ("net: add
generic PF_BRIDGE:RTM_ FDB hooks") that moved FDB handlers out of the
bridge driver to the core rtnetlink code.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_device.c  |   6 +-
 net/bridge/br_mdb.c     | 301 ++--------------------------------------
 net/bridge/br_netlink.c |   3 -
 net/bridge/br_private.h |  35 ++---
 net/core/rtnetlink.c    | 214 ++++++++++++++++++++++++++++
 5 files changed, 241 insertions(+), 318 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 85fa4d73bb53..df47c876230e 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -468,9 +468,9 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_fdb_del_bulk	 = br_fdb_delete_bulk,
 	.ndo_fdb_dump		 = br_fdb_dump,
 	.ndo_fdb_get		 = br_fdb_get,
-	.ndo_mdb_add		 = br_mdb_add_new,
-	.ndo_mdb_del		 = br_mdb_del_new,
-	.ndo_mdb_dump		 = br_mdb_dump_new,
+	.ndo_mdb_add		 = br_mdb_add,
+	.ndo_mdb_del		 = br_mdb_del,
+	.ndo_mdb_dump		 = br_mdb_dump,
 	.ndo_bridge_getlink	 = br_getlink,
 	.ndo_bridge_setlink	 = br_setlink,
 	.ndo_bridge_dellink	 = br_dellink,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 3359ac63c739..f970980e6183 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -380,86 +380,8 @@ static int br_mdb_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 	return err;
 }
 
-static int br_mdb_valid_dump_req(const struct nlmsghdr *nlh,
-				 struct netlink_ext_ack *extack)
-{
-	struct br_port_msg *bpm;
-
-	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*bpm))) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid header for mdb dump request");
-		return -EINVAL;
-	}
-
-	bpm = nlmsg_data(nlh);
-	if (bpm->ifindex) {
-		NL_SET_ERR_MSG_MOD(extack, "Filtering by device index is not supported for mdb dump request");
-		return -EINVAL;
-	}
-	if (nlmsg_attrlen(nlh, sizeof(*bpm))) {
-		NL_SET_ERR_MSG(extack, "Invalid data after header in mdb dump request");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int br_mdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
-{
-	struct net_device *dev;
-	struct net *net = sock_net(skb->sk);
-	struct nlmsghdr *nlh = NULL;
-	int idx = 0, s_idx;
-
-	if (cb->strict_check) {
-		int err = br_mdb_valid_dump_req(cb->nlh, cb->extack);
-
-		if (err < 0)
-			return err;
-	}
-
-	s_idx = cb->args[0];
-
-	rcu_read_lock();
-
-	for_each_netdev_rcu(net, dev) {
-		if (netif_is_bridge_master(dev)) {
-			struct net_bridge *br = netdev_priv(dev);
-			struct br_port_msg *bpm;
-
-			if (idx < s_idx)
-				goto skip;
-
-			nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid,
-					cb->nlh->nlmsg_seq, RTM_GETMDB,
-					sizeof(*bpm), NLM_F_MULTI);
-			if (nlh == NULL)
-				break;
-
-			bpm = nlmsg_data(nlh);
-			memset(bpm, 0, sizeof(*bpm));
-			bpm->ifindex = dev->ifindex;
-			if (br_mdb_fill_info(skb, cb, dev) < 0)
-				goto out;
-			if (br_rports_fill_info(skb, &br->multicast_ctx) < 0)
-				goto out;
-
-			cb->args[1] = 0;
-			nlmsg_end(skb, nlh);
-		skip:
-			idx++;
-		}
-	}
-
-out:
-	if (nlh)
-		nlmsg_end(skb, nlh);
-	rcu_read_unlock();
-	cb->args[0] = idx;
-	return skb->len;
-}
-
-int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
-		    struct netlink_callback *cb)
+int br_mdb_dump(struct net_device *dev, struct sk_buff *skb,
+		struct netlink_callback *cb)
 {
 	struct net_bridge *br = netdev_priv(dev);
 	struct br_port_msg *bpm;
@@ -716,60 +638,6 @@ static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
 	[MDBE_ATTR_RTPROT] = NLA_POLICY_MIN(NLA_U8, RTPROT_STATIC),
 };
 
-static int validate_mdb_entry(const struct nlattr *attr,
-			      struct netlink_ext_ack *extack)
-{
-	struct br_mdb_entry *entry = nla_data(attr);
-
-	if (nla_len(attr) != sizeof(struct br_mdb_entry)) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid MDBA_SET_ENTRY attribute length");
-		return -EINVAL;
-	}
-
-	if (entry->ifindex == 0) {
-		NL_SET_ERR_MSG_MOD(extack, "Zero entry ifindex is not allowed");
-		return -EINVAL;
-	}
-
-	if (entry->addr.proto == htons(ETH_P_IP)) {
-		if (!ipv4_is_multicast(entry->addr.u.ip4)) {
-			NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address is not multicast");
-			return -EINVAL;
-		}
-		if (ipv4_is_local_multicast(entry->addr.u.ip4)) {
-			NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address is local multicast");
-			return -EINVAL;
-		}
-#if IS_ENABLED(CONFIG_IPV6)
-	} else if (entry->addr.proto == htons(ETH_P_IPV6)) {
-		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6)) {
-			NL_SET_ERR_MSG_MOD(extack, "IPv6 entry group address is link-local all nodes");
-			return -EINVAL;
-		}
-#endif
-	} else if (entry->addr.proto == 0) {
-		/* L2 mdb */
-		if (!is_multicast_ether_addr(entry->addr.u.mac_addr)) {
-			NL_SET_ERR_MSG_MOD(extack, "L2 entry group is not multicast");
-			return -EINVAL;
-		}
-	} else {
-		NL_SET_ERR_MSG_MOD(extack, "Unknown entry protocol");
-		return -EINVAL;
-	}
-
-	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY) {
-		NL_SET_ERR_MSG_MOD(extack, "Unknown entry state");
-		return -EINVAL;
-	}
-	if (entry->vid >= VLAN_VID_MASK) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid entry VLAN id");
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static bool is_valid_mdb_source(struct nlattr *attr, __be16 proto,
 				struct netlink_ext_ack *extack)
 {
@@ -1335,49 +1203,16 @@ static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 	return 0;
 }
 
-static const struct nla_policy mdba_policy[MDBA_SET_ENTRY_MAX + 1] = {
-	[MDBA_SET_ENTRY_UNSPEC] = { .strict_start_type = MDBA_SET_ENTRY_ATTRS + 1 },
-	[MDBA_SET_ENTRY] = NLA_POLICY_VALIDATE_FN(NLA_BINARY,
-						  validate_mdb_entry,
-						  sizeof(struct br_mdb_entry)),
-	[MDBA_SET_ENTRY_ATTRS] = { .type = NLA_NESTED },
-};
-
-static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
-			      struct br_mdb_config *cfg,
+static int br_mdb_config_init(struct br_mdb_config *cfg, struct net_device *dev,
+			      struct nlattr *tb[], u16 nlmsg_flags,
 			      struct netlink_ext_ack *extack)
 {
-	struct nlattr *tb[MDBA_SET_ENTRY_MAX + 1];
-	struct br_port_msg *bpm;
-	struct net_device *dev;
-	int err;
-
-	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
-				     MDBA_SET_ENTRY_MAX, mdba_policy, extack);
-	if (err)
-		return err;
+	struct net *net = dev_net(dev);
 
 	memset(cfg, 0, sizeof(*cfg));
 	cfg->filter_mode = MCAST_EXCLUDE;
 	cfg->rt_protocol = RTPROT_STATIC;
-	cfg->nlflags = nlh->nlmsg_flags;
-
-	bpm = nlmsg_data(nlh);
-	if (!bpm->ifindex) {
-		NL_SET_ERR_MSG_MOD(extack, "Invalid bridge ifindex");
-		return -EINVAL;
-	}
-
-	dev = __dev_get_by_index(net, bpm->ifindex);
-	if (!dev) {
-		NL_SET_ERR_MSG_MOD(extack, "Bridge device doesn't exist");
-		return -ENODEV;
-	}
-
-	if (!netif_is_bridge_master(dev)) {
-		NL_SET_ERR_MSG_MOD(extack, "Device is not a bridge");
-		return -EOPNOTSUPP;
-	}
+	cfg->nlflags = nlmsg_flags;
 
 	cfg->br = netdev_priv(dev);
 
@@ -1391,11 +1226,6 @@ static int br_mdb_config_init(struct net *net, const struct nlmsghdr *nlh,
 		return -EINVAL;
 	}
 
-	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, MDBA_SET_ENTRY)) {
-		NL_SET_ERR_MSG_MOD(extack, "Missing MDBA_SET_ENTRY attribute");
-		return -EINVAL;
-	}
-
 	cfg->entry = nla_data(tb[MDBA_SET_ENTRY]);
 
 	if (cfg->entry->ifindex != cfg->br->dev->ifindex) {
@@ -1433,16 +1263,15 @@ static void br_mdb_config_fini(struct br_mdb_config *cfg)
 	br_mdb_config_src_list_fini(cfg);
 }
 
-static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
-		      struct netlink_ext_ack *extack)
+int br_mdb_add(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+	       struct netlink_ext_ack *extack)
 {
-	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
 	int err;
 
-	err = br_mdb_config_init(net, nlh, &cfg, extack);
+	err = br_mdb_config_init(&cfg, dev, tb, nlmsg_flags, extack);
 	if (err)
 		return err;
 
@@ -1495,65 +1324,6 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
-int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
-		   struct netlink_ext_ack *extack)
-{
-	struct net_bridge_vlan_group *vg;
-	struct br_mdb_config cfg = {};
-	struct net_bridge_vlan *v;
-	int err;
-
-	/* Configuration structure will be initialized here. */
-
-	err = -EINVAL;
-	/* host join errors which can happen before creating the group */
-	if (!cfg.p && !br_group_is_l2(&cfg.group)) {
-		/* don't allow any flags for host-joined IP groups */
-		if (cfg.entry->state) {
-			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
-			goto out;
-		}
-		if (!br_multicast_is_star_g(&cfg.group)) {
-			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
-			goto out;
-		}
-	}
-
-	if (br_group_is_l2(&cfg.group) && cfg.entry->state != MDB_PERMANENT) {
-		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
-		goto out;
-	}
-
-	if (cfg.p) {
-		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
-			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
-			goto out;
-		}
-		vg = nbp_vlan_group(cfg.p);
-	} else {
-		vg = br_vlan_group(cfg.br);
-	}
-
-	/* If vlan filtering is enabled and VLAN is not specified
-	 * install mdb entry on all vlans configured on the port.
-	 */
-	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
-		list_for_each_entry(v, &vg->vlan_list, vlist) {
-			cfg.entry->vid = v->vid;
-			cfg.group.vid = v->vid;
-			err = __br_mdb_add(&cfg, extack);
-			if (err)
-				break;
-		}
-	} else {
-		err = __br_mdb_add(&cfg, extack);
-	}
-
-out:
-	br_mdb_config_fini(&cfg);
-	return err;
-}
-
 static int __br_mdb_del(const struct br_mdb_config *cfg)
 {
 	struct br_mdb_entry *entry = cfg->entry;
@@ -1595,16 +1365,15 @@ static int __br_mdb_del(const struct br_mdb_config *cfg)
 	return err;
 }
 
-static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
-		      struct netlink_ext_ack *extack)
+int br_mdb_del(struct net_device *dev, struct nlattr *tb[],
+	       struct netlink_ext_ack *extack)
 {
-	struct net *net = sock_net(skb->sk);
 	struct net_bridge_vlan_group *vg;
 	struct net_bridge_vlan *v;
 	struct br_mdb_config cfg;
 	int err;
 
-	err = br_mdb_config_init(net, nlh, &cfg, extack);
+	err = br_mdb_config_init(&cfg, dev, tb, 0, extack);
 	if (err)
 		return err;
 
@@ -1629,49 +1398,3 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	br_mdb_config_fini(&cfg);
 	return err;
 }
-
-int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
-		   struct netlink_ext_ack *extack)
-{
-	struct net_bridge_vlan_group *vg;
-	struct br_mdb_config cfg = {};
-	struct net_bridge_vlan *v;
-	int err = 0;
-
-	/* Configuration structure will be initialized here. */
-
-	if (cfg.p)
-		vg = nbp_vlan_group(cfg.p);
-	else
-		vg = br_vlan_group(cfg.br);
-
-	/* If vlan filtering is enabled and VLAN is not specified
-	 * delete mdb entry on all vlans configured on the port.
-	 */
-	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
-		list_for_each_entry(v, &vg->vlan_list, vlist) {
-			cfg.entry->vid = v->vid;
-			cfg.group.vid = v->vid;
-			err = __br_mdb_del(&cfg);
-		}
-	} else {
-		err = __br_mdb_del(&cfg);
-	}
-
-	br_mdb_config_fini(&cfg);
-	return err;
-}
-
-void br_mdb_init(void)
-{
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_GETMDB, NULL, br_mdb_dump, 0);
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_NEWMDB, br_mdb_add, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_DELMDB, br_mdb_del, NULL, 0);
-}
-
-void br_mdb_uninit(void)
-{
-	rtnl_unregister(PF_BRIDGE, RTM_GETMDB);
-	rtnl_unregister(PF_BRIDGE, RTM_NEWMDB);
-	rtnl_unregister(PF_BRIDGE, RTM_DELMDB);
-}
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 4316cc82ae17..aef0b9a3ac74 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -1869,7 +1869,6 @@ int __init br_netlink_init(void)
 {
 	int err;
 
-	br_mdb_init();
 	br_vlan_rtnl_init();
 	rtnl_af_register(&br_af_ops);
 
@@ -1881,13 +1880,11 @@ int __init br_netlink_init(void)
 
 out_af:
 	rtnl_af_unregister(&br_af_ops);
-	br_mdb_uninit();
 	return err;
 }
 
 void br_netlink_fini(void)
 {
-	br_mdb_uninit();
 	br_vlan_rtnl_uninit();
 	rtnl_af_unregister(&br_af_ops);
 	rtnl_link_unregister(&br_link_ops);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 91dba4792469..75aff9bbf17e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -974,14 +974,12 @@ void br_multicast_uninit_stats(struct net_bridge *br);
 void br_multicast_get_stats(const struct net_bridge *br,
 			    const struct net_bridge_port *p,
 			    struct br_mcast_stats *dest);
-int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
-		   struct netlink_ext_ack *extack);
-int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
-		   struct netlink_ext_ack *extack);
-int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
-		    struct netlink_callback *cb);
-void br_mdb_init(void);
-void br_mdb_uninit(void);
+int br_mdb_add(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+	       struct netlink_ext_ack *extack);
+int br_mdb_del(struct net_device *dev, struct nlattr *tb[],
+	       struct netlink_ext_ack *extack);
+int br_mdb_dump(struct net_device *dev, struct sk_buff *skb,
+		struct netlink_callback *cb);
 void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
 			    struct net_bridge_mdb_entry *mp, bool notify);
 void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify);
@@ -1373,33 +1371,24 @@ static inline bool br_multicast_querier_exists(struct net_bridge_mcast *brmctx,
 	return false;
 }
 
-static inline int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[],
-				 u16 nlmsg_flags,
-				 struct netlink_ext_ack *extack)
+static inline int br_mdb_add(struct net_device *dev, struct nlattr *tb[],
+			     u16 nlmsg_flags, struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
-				 struct netlink_ext_ack *extack)
+static inline int br_mdb_del(struct net_device *dev, struct nlattr *tb[],
+			     struct netlink_ext_ack *extack)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
-				  struct netlink_callback *cb)
+static inline int br_mdb_dump(struct net_device *dev, struct sk_buff *skb,
+			      struct netlink_callback *cb)
 {
 	return 0;
 }
 
-static inline void br_mdb_init(void)
-{
-}
-
-static inline void br_mdb_uninit(void)
-{
-}
-
 static inline int br_mdb_hash_init(struct net_bridge *br)
 {
 	return 0;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index b9f584955b77..892d4e8fd394 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -54,6 +54,9 @@
 #include <net/rtnetlink.h>
 #include <net/net_namespace.h>
 #include <net/devlink.h>
+#if IS_ENABLED(CONFIG_IPV6)
+#include <net/addrconf.h>
+#endif
 
 #include "dev.h"
 
@@ -6063,6 +6066,213 @@ static int rtnl_stats_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return 0;
 }
 
+static int rtnl_mdb_valid_dump_req(const struct nlmsghdr *nlh,
+				   struct netlink_ext_ack *extack)
+{
+	struct br_port_msg *bpm;
+
+	if (nlh->nlmsg_len < nlmsg_msg_size(sizeof(*bpm))) {
+		NL_SET_ERR_MSG(extack, "Invalid header for mdb dump request");
+		return -EINVAL;
+	}
+
+	bpm = nlmsg_data(nlh);
+	if (bpm->ifindex) {
+		NL_SET_ERR_MSG(extack, "Filtering by device index is not supported for mdb dump request");
+		return -EINVAL;
+	}
+	if (nlmsg_attrlen(nlh, sizeof(*bpm))) {
+		NL_SET_ERR_MSG(extack, "Invalid data after header in mdb dump request");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+struct rtnl_mdb_dump_ctx {
+	long idx;
+	long dev_markers[5];
+};
+
+static int rtnl_mdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct rtnl_mdb_dump_ctx *ctx = (void *)cb->ctx;
+	struct net *net = sock_net(skb->sk);
+	struct net_device *dev;
+	int idx, s_idx;
+	int err;
+
+	BUILD_BUG_ON(sizeof(*ctx) != sizeof(cb->ctx));
+
+	if (cb->strict_check) {
+		err = rtnl_mdb_valid_dump_req(cb->nlh, cb->extack);
+		if (err)
+			return err;
+	}
+
+	s_idx = ctx->idx;
+	idx = 0;
+
+	for_each_netdev(net, dev) {
+		if (idx < s_idx)
+			goto skip;
+		if (!dev->netdev_ops->ndo_mdb_dump)
+			goto skip;
+
+		err = dev->netdev_ops->ndo_mdb_dump(dev, skb, cb);
+		if (err == -EMSGSIZE)
+			goto out;
+		/* Moving on to next device, reset device's markers. */
+		memset(ctx->dev_markers, 0, sizeof(ctx->dev_markers));
+skip:
+		idx++;
+	}
+
+out:
+	ctx->idx = idx;
+	return skb->len;
+}
+
+static int rtnl_validate_mdb_entry(const struct nlattr *attr,
+				   struct netlink_ext_ack *extack)
+{
+	struct br_mdb_entry *entry = nla_data(attr);
+
+	if (nla_len(attr) != sizeof(struct br_mdb_entry)) {
+		NL_SET_ERR_MSG(extack, "Invalid MDBA_SET_ENTRY attribute length");
+		return -EINVAL;
+	}
+
+	if (entry->ifindex == 0) {
+		NL_SET_ERR_MSG(extack, "Zero entry ifindex is not allowed");
+		return -EINVAL;
+	}
+
+	if (entry->addr.proto == htons(ETH_P_IP)) {
+		if (!ipv4_is_multicast(entry->addr.u.ip4)) {
+			NL_SET_ERR_MSG(extack, "IPv4 entry group address is not multicast");
+			return -EINVAL;
+		}
+		if (ipv4_is_local_multicast(entry->addr.u.ip4)) {
+			NL_SET_ERR_MSG(extack, "IPv4 entry group address is local multicast");
+			return -EINVAL;
+		}
+#if IS_ENABLED(CONFIG_IPV6)
+	} else if (entry->addr.proto == htons(ETH_P_IPV6)) {
+		if (ipv6_addr_is_ll_all_nodes(&entry->addr.u.ip6)) {
+			NL_SET_ERR_MSG(extack, "IPv6 entry group address is link-local all nodes");
+			return -EINVAL;
+		}
+#endif
+	} else if (entry->addr.proto == 0) {
+		/* L2 mdb */
+		if (!is_multicast_ether_addr(entry->addr.u.mac_addr)) {
+			NL_SET_ERR_MSG(extack, "L2 entry group is not multicast");
+			return -EINVAL;
+		}
+	} else {
+		NL_SET_ERR_MSG(extack, "Unknown entry protocol");
+		return -EINVAL;
+	}
+
+	if (entry->state != MDB_PERMANENT && entry->state != MDB_TEMPORARY) {
+		NL_SET_ERR_MSG(extack, "Unknown entry state");
+		return -EINVAL;
+	}
+	if (entry->vid >= VLAN_VID_MASK) {
+		NL_SET_ERR_MSG(extack, "Invalid entry VLAN id");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct nla_policy mdba_policy[MDBA_SET_ENTRY_MAX + 1] = {
+	[MDBA_SET_ENTRY_UNSPEC] = { .strict_start_type = MDBA_SET_ENTRY_ATTRS + 1 },
+	[MDBA_SET_ENTRY] = NLA_POLICY_VALIDATE_FN(NLA_BINARY,
+						  rtnl_validate_mdb_entry,
+						  sizeof(struct br_mdb_entry)),
+	[MDBA_SET_ENTRY_ATTRS] = { .type = NLA_NESTED },
+};
+
+static int rtnl_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
+			struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[MDBA_SET_ENTRY_MAX + 1];
+	struct net *net = sock_net(skb->sk);
+	struct br_port_msg *bpm;
+	struct net_device *dev;
+	int err;
+
+	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
+				     MDBA_SET_ENTRY_MAX, mdba_policy, extack);
+	if (err)
+		return err;
+
+	bpm = nlmsg_data(nlh);
+	if (!bpm->ifindex) {
+		NL_SET_ERR_MSG(extack, "Invalid ifindex");
+		return -EINVAL;
+	}
+
+	dev = __dev_get_by_index(net, bpm->ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG(extack, "Device doesn't exist");
+		return -ENODEV;
+	}
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, MDBA_SET_ENTRY)) {
+		NL_SET_ERR_MSG(extack, "Missing MDBA_SET_ENTRY attribute");
+		return -EINVAL;
+	}
+
+	if (!dev->netdev_ops->ndo_mdb_add) {
+		NL_SET_ERR_MSG(extack, "Device does not support MDB operations");
+		return -EOPNOTSUPP;
+	}
+
+	return dev->netdev_ops->ndo_mdb_add(dev, tb, nlh->nlmsg_flags, extack);
+}
+
+static int rtnl_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
+			struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[MDBA_SET_ENTRY_MAX + 1];
+	struct net *net = sock_net(skb->sk);
+	struct br_port_msg *bpm;
+	struct net_device *dev;
+	int err;
+
+	err = nlmsg_parse_deprecated(nlh, sizeof(*bpm), tb,
+				     MDBA_SET_ENTRY_MAX, mdba_policy, extack);
+	if (err)
+		return err;
+
+	bpm = nlmsg_data(nlh);
+	if (!bpm->ifindex) {
+		NL_SET_ERR_MSG(extack, "Invalid ifindex");
+		return -EINVAL;
+	}
+
+	dev = __dev_get_by_index(net, bpm->ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG(extack, "Device doesn't exist");
+		return -ENODEV;
+	}
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, MDBA_SET_ENTRY)) {
+		NL_SET_ERR_MSG(extack, "Missing MDBA_SET_ENTRY attribute");
+		return -EINVAL;
+	}
+
+	if (!dev->netdev_ops->ndo_mdb_del) {
+		NL_SET_ERR_MSG(extack, "Device does not support MDB operations");
+		return -EOPNOTSUPP;
+	}
+
+	return dev->netdev_ops->ndo_mdb_del(dev, tb, extack);
+}
+
 /* Process one rtnetlink message. */
 
 static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -6297,4 +6507,8 @@ void __init rtnetlink_init(void)
 	rtnl_register(PF_UNSPEC, RTM_GETSTATS, rtnl_stats_get, rtnl_stats_dump,
 		      0);
 	rtnl_register(PF_UNSPEC, RTM_SETSTATS, rtnl_stats_set, NULL, 0);
+
+	rtnl_register(PF_BRIDGE, RTM_GETMDB, NULL, rtnl_mdb_dump, 0);
+	rtnl_register(PF_BRIDGE, RTM_NEWMDB, rtnl_mdb_add, NULL, 0);
+	rtnl_register(PF_BRIDGE, RTM_DELMDB, rtnl_mdb_del, NULL, 0);
 }
-- 
2.37.3

