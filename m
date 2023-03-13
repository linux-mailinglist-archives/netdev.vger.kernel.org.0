Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E08CC6B7B3D
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjCMO4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbjCMOz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:55:56 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247DA73AE5
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 07:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KB/qUO6sXRttCWDqt0F3bBwSORj70euw/E/tpLsQfSm8C5Am4XW5oBAfr2mphGdgfWf6JTQxLu0TMdQn7+PltDGARjZqAtI9c7+zbgTTpe8U6XupuWfDJODRmPrGrLkoQ5VX2LLcnmQHv/nB4MWKNEKMtyRF+M79fguL9zGMf33V7P2ps5ykB4lnOzQQGU+q0afzQQP1/wJbEdk1VwusmG8g14ziaLddqMMhvhIRIlID28iED9mU1XNXQa1sSgLp33dSY6No4ngVtI2rJrZ+gCxsC+gsXFg3aWMASXyBMMWrtoueGTC7ENH2bjRiyKtIQTGO5AZW20m76IPmr/YvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WihzsYigDcpMtb1CKap6aes47WV5s9a9F2Qas9EGhXA=;
 b=Ipsih37sK8mLRYI8ZQJdJhuvTyGpvbYfSW+BHoKu2v8FzWya4ZVivJrAaPu06FB3O0QMSEoqpJM/KnySSVnxVFd6pV0L1uRLsLvcZfQ7dqhc2STw85oH6w23PfyK9MOjlMzt3solJFqTAOdX3Pvnw1Hs4TI+nJg+TYuW5Izu+Nrj7WF+gM473MeP9VKWrES6rFlsRHXnIe293lHqpZwLzRcGRNI8OvjZu9s0fFUUUjImA15zVFvvP2eBPUPZ2rdBbdgxU8h7HBI8o1V+lQAphEJryaMuVOg7LJ+lwfQpkoj385a2BdjuclarCeAP+OvPybvC0CJx/PjjbGF9FdB5rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WihzsYigDcpMtb1CKap6aes47WV5s9a9F2Qas9EGhXA=;
 b=NRP9t1O+ukhU/+sMNCTFHk2/4yiFoWY+XWKWZa7PMBXaTwzSegZKxZawD1OIdA9sjKLTienn72ApABbZKLTfbWCJz+Z+7BH5/KR8eYcSxyZZ+du4Xplz0V+p7ffkDFXdX07ut6Qr0TCXqRWv5FMOzQiILyNV2x29QN0wdkBjkJ8yCMmBQ8mE1fNffDT+VWeT+0aX5KjBiZxh8TiI1nPD00BYncjF65+bkMBEgij72zlO6cueYfB7JlMf1f8WfXAnquxltz92UNbukPhTMd1eekd2xtJHIHRkg4S4+7d7dUdhjX75iSlDTSe1yJ9ZAcJDyhZqvWA3QQoKllDposXQyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB7493.namprd12.prod.outlook.com (2603:10b6:208:41b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:55:19 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%6]) with mapi id 15.20.6178.022; Mon, 13 Mar 2023
 14:55:19 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/11] bridge: mcast: Implement MDB net device operations
Date:   Mon, 13 Mar 2023 16:53:40 +0200
Message-Id: <20230313145349.3557231-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230313145349.3557231-1-idosch@nvidia.com>
References: <20230313145349.3557231-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0129.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::27) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB7493:EE_
X-MS-Office365-Filtering-Correlation-Id: 31e83b6f-2daa-42e0-b4c2-08db23d2f6cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IdHUIY13b24Yn1V765KQt4EGVg/v8nNDbIs7m3w/gZCjS3QDANxsWjhd9XRl2RbqThoBybLNM0Q2AnkI8//8uVEQxDi0QaivwIlcHenJEBMAZi/4p8Pj6oCQSSkP1GpdhqOxgtbz1RZKv137q09Ac8D6B7GYQJyCsk67WOcyFKGSV0GbmLYhJevY4s8uFz5/cwAjQcEHSAEgHIVQ/5Upb7snBwChUYM6M1KKXHjzZUiIliQ7f0UxRkfoPVOV8vWMR9x0zAKrDQGJFm3c6lV502rfHtnHE+lT5nCfWYGM8bGZ/kT1+n40t1Ako3Z7zDDPDQ3An4Yhk9kxUL9B9O8Rm0GzOJQkZnjB4H9BBBDhx6zjgjiSIWGwOpmWoG11WHRIixVdzsKvJOGWWo9akzxgno5baVBCcfTfw7x6mWZEFqMevPAu0J8wD9ktsoNPL6fPe9bGnljE506S9+SLb6yQxKMGIgJaWcEYE7YR7L6OxpkTrlf22wsMklhoGRmEft/l50M11CuJmQe7e5ceFzDejqH1ayUhlfzbzG4nHOiCLMgpi2Bhaq2gHLaL3heo+GP4V1fqWB1UD4qCIvX1A2hPaBXBo1mZ83o7pkYy61psDW1wTBuRAhjhlCVH+C1Pgk3mfwVSoni/Jowad22qU/nmOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199018)(2906002)(41300700001)(83380400001)(36756003)(5660300002)(66946007)(8676002)(8936002)(66556008)(4326008)(66476007)(38100700002)(316002)(86362001)(478600001)(186003)(2616005)(26005)(6506007)(6666004)(107886003)(6512007)(1076003)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zesY7xtG4AftE3Rj6lx2s9wCxc7wpqOPh0lPNnprug1MWJx6IO7np2Xaod4P?=
 =?us-ascii?Q?AfN9Hswq5LNoVF/+dSZPmtl+YuMrJVBJ8v9I2xXKCS978hhY0nCtRMu5f8Xq?=
 =?us-ascii?Q?1NSdH2Lju+B7fI8oAMSF3uD354BNriBAW5NbXGkhAiZ+NB2R7i/8CRgAvPl4?=
 =?us-ascii?Q?TnFGo5uoCU/ejLVVo+AUaBewm2JrUTnxk/rx+eW6VUcXKbcKY2Me3IuP5f6k?=
 =?us-ascii?Q?J2RfwdNaBMsl++oElSR5/hRWzvh3y7qJo1A5xP6jQfOzS2jcHyxsJma9meIn?=
 =?us-ascii?Q?cRCyemMmyey0Pgxy03rX2OnlMqybaPsZx/IQFTCX8r0r5DndOo1HG9W6O8Pw?=
 =?us-ascii?Q?1wgxJ2ZOX0QfmBQHHhKzCblJZ6CD+2mVtCZQaq0DZue6X1fRyzcOixn4cHui?=
 =?us-ascii?Q?shw5Pu9QhAOwT5Opz9i/BgqnHfMhF+D+wIrRereS1c2jS9e8NuigXdAzPe2u?=
 =?us-ascii?Q?XMFBga29CFl1gP+cbDgUBypIB4nVRYtfBZXTalv+HYYMEvN0F1sgY+3asw/r?=
 =?us-ascii?Q?vY2p4VnK0xBXjy6MY+x2kaee7vFvTX2t+oLRPoY3LIXFHZifIgWKgw3PsaPp?=
 =?us-ascii?Q?36OqWWP4moD+yzKBv2LdRhWjyGmbt9Jo+bkReJbisPX9t5n9pGbWt2shtw42?=
 =?us-ascii?Q?q6mqctGBmkIxS/c//VPPnPEaFqnX3ZTRyIrlCe0gqekctZQv+NQdRVQmpSIH?=
 =?us-ascii?Q?hmQAzgLf3PpPrQkoONv3JSlDXRllqtpHgywIRMIZGs+3NgpbpFKhWDt/3Q/P?=
 =?us-ascii?Q?z2/baat5QWaCip44rMcZghKdNL7gywk9n1cz3OpUgs1vBx4QZCVu0ZsRz9yR?=
 =?us-ascii?Q?6LUEG1D5pmJQ2fpDEYGN6nKNsSSVeTcXA8s5YpY5XXWBRiUttAwDIZYVe0BR?=
 =?us-ascii?Q?Pw9BjEuJ8lm+LltBpkbq2kma1/SOLOPVRzqHtq0IZB04SZldbPKwzaZ51xx7?=
 =?us-ascii?Q?4rynmD3qOqjAr8CkMolzffyrX6fY51HGpVvXO64WUYRbuuFTnINU7f/s+RsI?=
 =?us-ascii?Q?+ceEBnuuvWGE0UpkEN+mTIriheY+8qu2da6RIPptxuycktyl66Z9OiReTSvP?=
 =?us-ascii?Q?Nod2hJSaZ99CYYPFjBuOKAPpOiSpCPb4LiVbsaM+cv83f8sDW5b+py054QU8?=
 =?us-ascii?Q?OSjahulfr22tmn23+sDOU1HnzztIT/0YurB9CVGe3qHmVIcyUfI+HLG9wb5w?=
 =?us-ascii?Q?hyEO4DCN6a1JpSxn6L72xZyx7weXBxGyzm9mK3A7QTjD3/7Pg1khfTyq54vT?=
 =?us-ascii?Q?Eum2Tdz/VMFBmjMEsh1NxEbvBkVvp789EsINXRqy+mBuh6tv0QF0NkE1GtRh?=
 =?us-ascii?Q?RDBe+XZVrRPe4gZFl2+Et0u6zyCfYvsLaj0SyGuyVkZSrfQau8lxUZL3T2Li?=
 =?us-ascii?Q?ixMvF/yLLrRSAYVFqATHxso2JHsTAa6BFdZTrn2/r9yEm9G8IVvvi/tyRYmt?=
 =?us-ascii?Q?MjO+l+GlZxN0A4kzRvDApNKX7Cu0DfT3/jC8TF33hIj4IhWbhu3XBzd+E1LD?=
 =?us-ascii?Q?HXNBN8UmOVpToufOCatTWS5o2G9cbnl4njOLd9cZvr4NfBkJ5jg9gx7ats1D?=
 =?us-ascii?Q?lSYO/XTsuv7nIQR/SCgHOAHeAHDYQLOKk1AS6z8k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e83b6f-2daa-42e0-b4c2-08db23d2f6cb
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:55:19.6842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: StVme/1crN9eMp/c31xBOq1wmVEmY7ZpXNPrQnOyBx0j/TN8jxuTMJRm9gCK5gRzv2sFdLyjZrXELUOxmzM7kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7493
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the previously added MDB net device operations in the bridge
driver so that they could be invoked by core rtnetlink code in the next
patch.

The operations are identical to the existing br_mdb_{dump,add,del}
functions. The '_new' suffix will be removed in the next patch. The
functions are re-implemented in this patch to make the conversion in the
next patch easier to review.

Add dummy implementations when 'CONFIG_BRIDGE_IGMP_SNOOPING' is
disabled, so that an error will be returned to user space when it is
trying to add or delete an MDB entry. This is consistent with existing
behavior where the bridge driver does not even register rtnetlink
handlers for RTM_{NEW,DEL,GET}MDB messages when this Kconfig option is
disabled.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_device.c  |   3 +
 net/bridge/br_mdb.c     | 124 ++++++++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h |  25 ++++++++
 3 files changed, 152 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index b82906fc999a..85fa4d73bb53 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -468,6 +468,9 @@ static const struct net_device_ops br_netdev_ops = {
 	.ndo_fdb_del_bulk	 = br_fdb_delete_bulk,
 	.ndo_fdb_dump		 = br_fdb_dump,
 	.ndo_fdb_get		 = br_fdb_get,
+	.ndo_mdb_add		 = br_mdb_add_new,
+	.ndo_mdb_del		 = br_mdb_del_new,
+	.ndo_mdb_dump		 = br_mdb_dump_new,
 	.ndo_bridge_getlink	 = br_getlink,
 	.ndo_bridge_setlink	 = br_setlink,
 	.ndo_bridge_dellink	 = br_dellink,
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 25c48d81a597..cb8270a5480b 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -458,6 +458,39 @@ static int br_mdb_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
+		    struct netlink_callback *cb)
+{
+	struct net_bridge *br = netdev_priv(dev);
+	struct br_port_msg *bpm;
+	struct nlmsghdr *nlh;
+	int err;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid,
+			cb->nlh->nlmsg_seq, RTM_GETMDB, sizeof(*bpm),
+			NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	bpm = nlmsg_data(nlh);
+	memset(bpm, 0, sizeof(*bpm));
+	bpm->ifindex = dev->ifindex;
+
+	rcu_read_lock();
+
+	err = br_mdb_fill_info(skb, cb, dev);
+	if (err)
+		goto out;
+	err = br_rports_fill_info(skb, &br->multicast_ctx);
+	if (err)
+		goto out;
+
+out:
+	rcu_read_unlock();
+	nlmsg_end(skb, nlh);
+	return err;
+}
+
 static int nlmsg_populate_mdb_fill(struct sk_buff *skb,
 				   struct net_device *dev,
 				   struct net_bridge_mdb_entry *mp,
@@ -1459,6 +1492,65 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+		   struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan_group *vg;
+	struct br_mdb_config cfg = {};
+	struct net_bridge_vlan *v;
+	int err;
+
+	/* Configuration structure will be initialized here. */
+
+	err = -EINVAL;
+	/* host join errors which can happen before creating the group */
+	if (!cfg.p && !br_group_is_l2(&cfg.group)) {
+		/* don't allow any flags for host-joined IP groups */
+		if (cfg.entry->state) {
+			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
+			goto out;
+		}
+		if (!br_multicast_is_star_g(&cfg.group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
+			goto out;
+		}
+	}
+
+	if (br_group_is_l2(&cfg.group) && cfg.entry->state != MDB_PERMANENT) {
+		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
+		goto out;
+	}
+
+	if (cfg.p) {
+		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
+			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
+			goto out;
+		}
+		vg = nbp_vlan_group(cfg.p);
+	} else {
+		vg = br_vlan_group(cfg.br);
+	}
+
+	/* If vlan filtering is enabled and VLAN is not specified
+	 * install mdb entry on all vlans configured on the port.
+	 */
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
+		list_for_each_entry(v, &vg->vlan_list, vlist) {
+			cfg.entry->vid = v->vid;
+			cfg.group.vid = v->vid;
+			err = __br_mdb_add(&cfg, extack);
+			if (err)
+				break;
+		}
+	} else {
+		err = __br_mdb_add(&cfg, extack);
+	}
+
+out:
+	br_mdb_config_fini(&cfg);
+	return err;
+}
+
 static int __br_mdb_del(const struct br_mdb_config *cfg)
 {
 	struct br_mdb_entry *entry = cfg->entry;
@@ -1535,6 +1627,38 @@ static int br_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
+		   struct netlink_ext_ack *extack)
+{
+	struct net_bridge_vlan_group *vg;
+	struct br_mdb_config cfg = {};
+	struct net_bridge_vlan *v;
+	int err = 0;
+
+	/* Configuration structure will be initialized here. */
+
+	if (cfg.p)
+		vg = nbp_vlan_group(cfg.p);
+	else
+		vg = br_vlan_group(cfg.br);
+
+	/* If vlan filtering is enabled and VLAN is not specified
+	 * delete mdb entry on all vlans configured on the port.
+	 */
+	if (br_vlan_enabled(cfg.br->dev) && vg && cfg.entry->vid == 0) {
+		list_for_each_entry(v, &vg->vlan_list, vlist) {
+			cfg.entry->vid = v->vid;
+			cfg.group.vid = v->vid;
+			err = __br_mdb_del(&cfg);
+		}
+	} else {
+		err = __br_mdb_del(&cfg);
+	}
+
+	br_mdb_config_fini(&cfg);
+	return err;
+}
+
 void br_mdb_init(void)
 {
 	rtnl_register_module(THIS_MODULE, PF_BRIDGE, RTM_GETMDB, NULL, br_mdb_dump, 0);
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index cef5f6ea850c..a72847c1dc9f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -981,6 +981,12 @@ void br_multicast_get_stats(const struct net_bridge *br,
 u32 br_multicast_ngroups_get(const struct net_bridge_mcast_port *pmctx);
 void br_multicast_ngroups_set_max(struct net_bridge_mcast_port *pmctx, u32 max);
 u32 br_multicast_ngroups_get_max(const struct net_bridge_mcast_port *pmctx);
+int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[], u16 nlmsg_flags,
+		   struct netlink_ext_ack *extack);
+int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
+		   struct netlink_ext_ack *extack);
+int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
+		    struct netlink_callback *cb);
 void br_mdb_init(void);
 void br_mdb_uninit(void);
 void br_multicast_host_join(const struct net_bridge_mcast *brmctx,
@@ -1374,6 +1380,25 @@ static inline bool br_multicast_querier_exists(struct net_bridge_mcast *brmctx,
 	return false;
 }
 
+static inline int br_mdb_add_new(struct net_device *dev, struct nlattr *tb[],
+				 u16 nlmsg_flags,
+				 struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_mdb_del_new(struct net_device *dev, struct nlattr *tb[],
+				 struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_mdb_dump_new(struct net_device *dev, struct sk_buff *skb,
+				  struct netlink_callback *cb)
+{
+	return 0;
+}
+
 static inline void br_mdb_init(void)
 {
 }
-- 
2.37.3

