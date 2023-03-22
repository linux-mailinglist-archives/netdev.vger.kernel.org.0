Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D559B6C5A9D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 00:39:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjCVXj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 19:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjCVXjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 19:39:04 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2054.outbound.protection.outlook.com [40.107.7.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2629923A64;
        Wed, 22 Mar 2023 16:38:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVUZ80RHNRpxhiB2aqDQG6XCZcpsBlLSzf+ShsCFC8PlT+AaVkgmINu51fWVlELUbSAV+4F2cvrm72IQXg13zstmu2XDD/zxwfGilC0NA80bA2tGJvMOWNLaf6yqLkAz3ETDnhQ+CsR6VU3TfIZqDlcLIAGKazVU3O/1d5qzrvl935qCTguxRQZvE7nUMhlkvPMiWtKECr+rFx0g3zOp4R/NvDlrA7LxRKih+5vI2jH4gf5dV3DwKHxpJzAvnajRIzgSKGZexd30LWtjAE5XLZhESGBq7zS258jk5eNHuPX0wMWNbfFwRh2x+Gg8DOkD2yq7uGNRtMDWsngbg7o9Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HudGl9FX9tARMb9pAAmbiXqgdru7VPq6sg9TMbQYgBo=;
 b=gHCE8Z+OoPj5r6Ht1cmqYrfGMQ9mSshiInHA+fmmjPVHsCepkKMp9a4KpGjxO1aAT4xi1/0p3kKXmR6WAkQhBqwNOVYPaKgxh9CvA41YedHymK/Gj4gb+izzQX/Bux4H49DWr32O5zap9sMotde2NHdDxIGk40gxZC0twGq6ujLGGzgm3Dxdqp9lIKjRnCOJVEG165sXvbiJDz0GKaSfpM7tpglJiSTem2YGR8tndHZUPgwTRxwf2WKUoF2INkVF+PpP6B+NkR34iprktDVi4KjphOL0T2Q3X/1jW83J1JHUEuy7tKpDU04BMHuDwjTxEr4TkYM/hKUwRwTb+s1j5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HudGl9FX9tARMb9pAAmbiXqgdru7VPq6sg9TMbQYgBo=;
 b=V5IJ6vHOEb2lvK0vFbUSAHCyMK6za8fL8CZdXrz3sOSCj5OVms73Wd/ltQDy64MGwFMmnZrDriFzjho0dmrokqc9qCvtT1uWkevzBdozE/ooPvvf4hHb5jSbLTl0hkHKKkDox/rof5hdzhEuo6Oyux5QTNTV0oo+GYuEv66ngmo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VE1PR04MB7263.eurprd04.prod.outlook.com (2603:10a6:800:1af::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 23:38:43 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.038; Wed, 22 Mar 2023
 23:38:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 9/9] net: dsa: tag_ocelot: call only the relevant portion of __skb_vlan_pop() on TX
Date:   Thu, 23 Mar 2023 01:38:23 +0200
Message-Id: <20230322233823.1806736-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
References: <20230322233823.1806736-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0081.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::8) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VE1PR04MB7263:EE_
X-MS-Office365-Filtering-Correlation-Id: 93359f0a-1440-4168-7e02-08db2b2e925b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: axsM63xrVpc3CtreONQTgT3IuvUJIKkZauFSsdhtF7OPYqEuYn5AP6yqZSll0NyyzRuyIiFSdQ1USaNlThVRfoZdw1rGY2lYyuzf65lzX4a8dDPyZXE2d4tf7glSxeNlDG636aJzakoW0SKj3gfJPEdkXXQAKjsn7dDbPfBjbaq3INvPvYiAS+pz5vKonegclnXgd9Nxo7AG9vZTtxPmNZ2hSGrmK845K4KwNJCbIgOA7Dpf4zkFDoIa+CY3AUoDr3XgMvRVC39iF99UC/lLCbfdPsISxCn5pwDuzT5mes49GX1QQgiamRZT5mjIXs1OKKAKwZMZ99RV25o1tF54BCXmZFsWLF7uEH51VhTQF7ynOXC25Pu4rMk5SRef7j7/oGR3OkYz7feUR6qSAaH9rtzEGMCbBc8ovA0n8AcmPTaqpAwrJ89tZQWCDHqbuZ0ccABpMLJLlsDG1wuHShAqdkWd/vg3YZ9o5gHqT0ARQhaAjEXUg2oWGVmloWNEzi8oX5UDhZ7lmCuio/SrNUHPG0c3sdgOV0CZiUaLLAYnLKcRrR7LbB0CBz+fr81ud4ZsjHonRyjk9SJuOdbCqrfxzwHkDY/7T86WuIS7Shc0rLTdCp/vyxlaYh38xcX5d/HWpXfc1hKwM/Btpr9Qb6NJCILW0tPm5eh8XxJqLZ9k/wEcrZ/0QcM2HEVwkQA+NX69tasqgMjYWBNvmZV3N0hnBInDVcj+g0R+Fvudw4ys1O3q4sw9bdeeIw1kKQ/z0dsW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(451199018)(54906003)(66556008)(6486002)(6916009)(316002)(66476007)(8676002)(66946007)(478600001)(6666004)(4326008)(52116002)(41300700001)(6506007)(1076003)(6512007)(26005)(8936002)(186003)(44832011)(5660300002)(2906002)(2616005)(36756003)(83380400001)(38100700002)(38350700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yHjdqqvnOSJEGfYZFqjvXLhatIp3mXKZ+atuA2znVI4J7Y5Qj093LdSndx0T?=
 =?us-ascii?Q?EOg/WMpKsmK3fPKl/D9l0C5TchT9GIVQnropZeFgzhVYjYaHx8m8224w3pgX?=
 =?us-ascii?Q?q1GdmHoPXi9LDlsBUiM33K2DRO+xMqrQt/L1a1MhOYLd70vWza22rvSfwZru?=
 =?us-ascii?Q?mx5t/cPJxwhzc2Nemx2QLNqVoVWC72VA3kx0jOaGZwDP0ANtpB9tEmUzHDUO?=
 =?us-ascii?Q?qFK/CdF4PoSOMGnk7WkvMtUf3uy+ByMrE/KVfhjEqisplUrojp+FkL1YNlBc?=
 =?us-ascii?Q?K7FZZqk066o3CcyT+cW6TvoQs5/nfd4l4GYcWMGfForGOuddiqXzFrlhAttw?=
 =?us-ascii?Q?V9d2Z1jwpWuORsHm6vg/v7ZErBOhjo/zbS8DYdH/OQiYUY1ruS8VkH3bUx/E?=
 =?us-ascii?Q?XXLEPXIco/ercT1LJr9PyhkRdi8/7VzVtXZu2DoCM2Prq/xjicI/hBZ6Y+ka?=
 =?us-ascii?Q?StOrRamFhzx7hg4sNXakOicWzuxHxQFuYDkX3kr2Ww9+BilPcSVmeH2yJvIo?=
 =?us-ascii?Q?pEIn9byZOo6hTw1dq61rFnxP/rE1CnxAHzYVKNFJpoIk0NAhZflcYkqIybgS?=
 =?us-ascii?Q?5ZrixJGbsAbFqUWb8nhUQhQ5zeFMRtsIsS/b4GTgvQcsdnfITXRDH2At+pKn?=
 =?us-ascii?Q?Ku5wSl3irHdJRH4GQ9ivS+uFiKntIt7FQq6pQYIFt+/fbK+OyXNusKxAXevt?=
 =?us-ascii?Q?T6hQ5fcWr0NzL5lqoY3/7I4+YktadgfAGPqFU58oaK2n6YLNLd25Zfh9blYi?=
 =?us-ascii?Q?/B85E+U6hkSkBMAQWE9rUasruGihCDEaEmXbKBoU3p9CwOI9hIMUqHFYbZv7?=
 =?us-ascii?Q?CUzE2dNJ/lK6YLMynOWL8PFDvrGjjZDCi98hSbGfNhboUiyRNdhiZUnwzLO4?=
 =?us-ascii?Q?p2PxuBIceHwkfK3HUzaaWYMT/X9nZBOTCRtdtJ4QTXC965pCNT1TRkakpb+C?=
 =?us-ascii?Q?ipfBYbX7wsoe+QlovElMvrmyINkfr6xv24XVAMSfaGUnIUocTqsW/oAo5sVB?=
 =?us-ascii?Q?F6YlN0XAtm3KJgzyqL3dtor/fBueKmoyhxCPP08QC4ZkVh1+F4GUE+txkVzM?=
 =?us-ascii?Q?EK2Cu4sEky/WjithORQREorC+tce32zxDkSHJbBWXsMky9GQfGDG/4eEFxz8?=
 =?us-ascii?Q?g0UvVaC7C/UOCbYaNp5VowecrWwxdTHxBLwJA64R4ZYG/YeTg7JwkRTBb2XW?=
 =?us-ascii?Q?ouwxuhwYaFM0SvGtYcAfgtciGzNUQ+q8IMsDQ7k01D5aTsBqz5A4VZJ9cxvc?=
 =?us-ascii?Q?HLpiWGwSRRmG+KJmnEryxWFBTaoH7Leuz/5JtGzQCbO60SmGPiwKAxeJ4vXr?=
 =?us-ascii?Q?U8FyJmWIcwJpijHtgoH/PDUyqtN2pB86A36gGHw8SthLznhfXXiVaCv5yR3n?=
 =?us-ascii?Q?eV0ghwgeuVbWq2NmP6pF2pb9P6QzcXqMzbwG6rVD5x06g6FnicVpBKviAgEa?=
 =?us-ascii?Q?Cx1e/oG6Wr0ShtUuO/NPH1Mh/W/cwZH0HqY/+NaoKsAGcVgV6hRwmsAyh+94?=
 =?us-ascii?Q?snfEqHQlbCB67cq/o4kTraROrziEUnxDmOh+Pxtn3u1mEnBXJdc2y3qAm0GV?=
 =?us-ascii?Q?FeItoCSoEj/8nO7d9RAe9gFeD8LjdvfSInPAnpl1Rk3CnN8w82obwQxdxrtX?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93359f0a-1440-4168-7e02-08db2b2e925b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 23:38:42.8422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHQIuyifdcoH37q7VAjVRXjvUvDJjlwd2s61rr0KktXgJnvNihH1SJZVCoPeEoqqbOPqoE5k9mzGVCai/LRDDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7263
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ocelot_xmit_get_vlan_info() calls __skb_vlan_pop() as the most
appropriate helper I could find which strips away a VLAN header.
That's all I need it to do, but __skb_vlan_pop() has more logic, which
will become incompatible with the future revert of commit 6d1ccff62780
("net: reset mac header in dev_start_xmit()").

Namely, it performs a sanity check on skb_mac_header(), which will stop
being set after the above revert, so it will return an error instead of
removing the VLAN tag.

ocelot_xmit_get_vlan_info() gets called in 2 circumstances:

(1) the port is under a VLAN-aware bridge and the bridge sends
    VLAN-tagged packets

(2) the port is under a VLAN-aware bridge and somebody else (an 8021q
    upper) sends VLAN-tagged packets (using a VID that isn't in the
    bridge vlan tables)

In case (1), there is actually no bug to defend against, because
br_dev_xmit() calls skb_reset_mac_header() and things continue to work.

However, in case (2), illustrated using the commands below, it can be
seen that our intervention is needed, since __skb_vlan_pop() complains:

$ ip link add br0 type bridge vlan_filtering 1 && ip link set br0 up
$ ip link set $eth master br0 && ip link set $eth up
$ ip link add link $eth name $eth.100 type vlan id 100 && ip link set $eth.100 up
$ ip addr add 192.168.100.1/24 dev $eth.100
$ # needed to work around an apparent DSA RX filtering bug
$ ip link set $eth promisc on

I could fend off the checks in __skb_vlan_pop() with some
skb_mac_header_was_set() calls, but seeing how few callers of
__skb_vlan_pop() there are from TX paths, that seems rather
unproductive.

As an alternative solution, extract the bare minimum logic to strip a
VLAN header, and move it to a new helper named vlan_remove_tag(), close
to the definition of vlan_insert_tag(). Document it appropriately and
make ocelot_xmit_get_vlan_info() call this smaller helper instead.

Seeing that it doesn't appear illegal to test skb->protocol in the TX
path, I guess it would be a good for vlan_remove_tag() to also absorb
the vlan_set_encap_proto() function call.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_vlan.h | 20 ++++++++++++++++++++
 net/core/skbuff.c       |  8 +-------
 net/dsa/tag_ocelot.c    |  2 +-
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 3698f2b391cd..4d54814143a8 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -685,6 +685,26 @@ static inline void vlan_set_encap_proto(struct sk_buff *skb,
 		skb->protocol = htons(ETH_P_802_2);
 }
 
+/**
+ * vlan_remove_tag - remove outer VLAN tag from payload
+ * @skb: skbuff to remove tag from
+ *
+ * Expects the skb to contain a VLAN tag in the payload, and to have skb->data
+ * pointing at the mac header.
+ *
+ * Returns a new pointer to skb->data, or NULL on failure to pull.
+ */
+static inline void *vlan_remove_tag(struct sk_buff *skb, u16 *vlan_tci)
+{
+	struct vlan_hdr *vhdr = (struct vlan_hdr *)(skb->data + ETH_HLEN);
+
+	*vlan_tci = ntohs(vhdr->h_vlan_TCI);
+
+	memmove(skb->data + VLAN_HLEN, skb->data, 2 * ETH_ALEN);
+	vlan_set_encap_proto(skb, vhdr);
+	return __skb_pull(skb, VLAN_HLEN);
+}
+
 /**
  * skb_vlan_tagged - check if skb is vlan tagged.
  * @skb: skbuff to query
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 050a875d09c5..0a7c058d4849 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5939,7 +5939,6 @@ EXPORT_SYMBOL(skb_ensure_writable);
  */
 int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci)
 {
-	struct vlan_hdr *vhdr;
 	int offset = skb->data - skb_mac_header(skb);
 	int err;
 
@@ -5955,13 +5954,8 @@ int __skb_vlan_pop(struct sk_buff *skb, u16 *vlan_tci)
 
 	skb_postpull_rcsum(skb, skb->data + (2 * ETH_ALEN), VLAN_HLEN);
 
-	vhdr = (struct vlan_hdr *)(skb->data + ETH_HLEN);
-	*vlan_tci = ntohs(vhdr->h_vlan_TCI);
-
-	memmove(skb->data + VLAN_HLEN, skb->data, 2 * ETH_ALEN);
-	__skb_pull(skb, VLAN_HLEN);
+	vlan_remove_tag(skb, vlan_tci);
 
-	vlan_set_encap_proto(skb, vhdr);
 	skb->mac_header += VLAN_HLEN;
 
 	if (skb_network_offset(skb) < ETH_HLEN)
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 73ee09de1a3a..20bf7074d5a6 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -30,7 +30,7 @@ static void ocelot_xmit_get_vlan_info(struct sk_buff *skb, struct dsa_port *dp,
 	br_vlan_get_proto(br, &proto);
 
 	if (ntohs(hdr->h_vlan_proto) == proto) {
-		__skb_vlan_pop(skb, &tci);
+		vlan_remove_tag(skb, &tci);
 		*vlan_tci = tci;
 	} else {
 		rcu_read_lock();
-- 
2.34.1

