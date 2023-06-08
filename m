Return-Path: <netdev+bounces-9289-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 896077285AF
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2BE11C20A5D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F0D17FF9;
	Thu,  8 Jun 2023 16:45:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E0C19912
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:45:09 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C1E2727
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:44:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjZL7hqjN2jntzsY4hR82GFzP9pi1w+IiUVQIcH4FBhOduXwVpJ6KgSr1qpDSXnHTnfKPl44VIQno49mw06xaBxvsMJl/MJvyJQTGVqeGtSLSZ5oa4Fj8DSFqboeTkhyyaV162rc2kde/Nmdw0LOsy5rHBdY5DE2DnjBpPhaS0Ib5H61apV6KnmlHRG4MM0oxINcytJ4du0g7+E3TyWeTKwrMhDL4HhdlN2JHpW6S/uADXlLg6YtBT55C31JFOx7e1N10jW3ZcDqke/wVZawG8t4Ecq7K794GYOGYWbaF+ywZWa7wapKT6yUz3oFVeQo9698njA6/Rfqfmdd+VosHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joHt6LdT0/ppib6AGYQDS8YEhIGZNMIspOYbng3xGi4=;
 b=g1n+o/210rNvv9t9srTtHzKvCcrlaM4rHz6PgZGLVkJb4ayIXo13GbMzEVh4zUGzP8BMTlwF54GFikFBrmThB4pN4dcwZgLe+dgxDQUJPuAzT6wdAXGTNAbYCZXjDBxlYPqv5wKaY4XX2csCttzlk2vBhjzyKtEc1hjMpS3TBVvfbP4hE+SjGQ9/u38CjrYYGNJchmW/MDfQzvASnweH5Kmyh6UREoGWOee8TE4VmprzE1+oIoMg/PXYMoulVB7jzup7kZfH1OjxGroztuLkhPycwZd8zPSFAYzIcpULeeoAfZ0mCt+faZRWxuxHOESUnkx99XKHjfdqKN1ZCBWVOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joHt6LdT0/ppib6AGYQDS8YEhIGZNMIspOYbng3xGi4=;
 b=miVy7Ubhx62826U/zEblzC6rc3F7L1b/LF3rUFzAngxTs5hThpAUZhve6R909JnXPghNlg1en28oeqIZwW8zFmD+dasyiAd1SO7j93BmqskYiJ7OeJl5zBCMeZe2i+6Z/imqCYmLK9yU+/pu2c7cm/t0ULCcxxO56pbVz5YYhJ0=
Received: from BN9PR03CA0400.namprd03.prod.outlook.com (2603:10b6:408:111::15)
 by DM4PR12MB8452.namprd12.prod.outlook.com (2603:10b6:8:184::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 16:44:20 +0000
Received: from BN8NAM11FT097.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::50) by BN9PR03CA0400.outlook.office365.com
 (2603:10b6:408:111::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.26 via Frontend
 Transport; Thu, 8 Jun 2023 16:44:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT097.mail.protection.outlook.com (10.13.176.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6477.26 via Frontend Transport; Thu, 8 Jun 2023 16:44:20 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 8 Jun
 2023 11:44:19 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Thu, 8 Jun 2023 11:44:18 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH v2 net-next 6/6] sfc: generate encap headers for TC offload
Date: Thu, 8 Jun 2023 17:42:35 +0100
Message-ID: <ac117b151d7a47b6083b166c75cb261369dd26e4.1686240142.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1686240142.git.ecree.xilinx@gmail.com>
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT097:EE_|DM4PR12MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: 75b824a3-fda1-481e-8cd3-08db683f9b63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MHdSvyhdjzLkvTRgb+NU1yXFWChbA1os54FAijhrGcylntnPrfd8PCCKB0rn6bldXMloTGB5ka+izNXuL3973DclTmmyDoEoNPOjaaPphmhbo6KI7abPoAhXBSUB84da5DRVidjQu5GfNbv3PPRGuVpbzP6Jixx/KBcIdLHgnPf9vfM17el6MkH+rbGvHUeJlufgQ5CSRdFylceBVkd65qeOy0vLB8GBB9H97aP8iXScTbwYMJ4o2FNzRVYIgZW/0UFMZcd8D2A3aIBcUV2aniskt30CSBdcnknbYKsHNMFOB9Z1INod8ceNXSo6JvG/0Nv7hWboRMhXM1qcH27Vb43fu8eij2/ZC8O+L3DhTBXLZneTHHqbHAQ5YJb//mgWEPhF32kqA1Fbv6YxQxpQL8bsvuHTSIdekgbOklM40Ky9Zr512dAaiTYxZeHczIcImkBAfL5/WiJ+jCL6XZBy8sYHOOsUKWoy6Ii3yD4FImiIWBDaIfJL28+1Zun28Kd66nlVDEgtuVGfAqvY0NMoNNbK5y2fFS4xKligGb+pn5OUdlSX98YI72fqOjIi0JI3FO/yMtoJpdz7Z0738GOxt4mkGFEfxSUaFk2Dcn9XhimtmTVv1vqOmZ39dmZHJKVidRTf5THemTTg+rqPJM1VwXuxsP3nBGO+zGHgKFTblHHkgSHU9UHVeat6Rq8duE1RhnG/OIkoAYRG1MU7eiyNqoPXfcrjQNcRnWV1bKzCXH/ZNF6oKkDr6bAZjJYUuoMV6e7BzGwn/QsYc3kLMvYThg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(376002)(396003)(451199021)(36840700001)(46966006)(40470700004)(9686003)(186003)(26005)(426003)(336012)(83380400001)(86362001)(47076005)(6666004)(36756003)(82310400005)(36860700001)(2876002)(2906002)(40460700003)(8676002)(8936002)(478600001)(40480700001)(82740400003)(316002)(110136005)(55446002)(41300700001)(5660300002)(70206006)(4326008)(356005)(81166007)(54906003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 16:44:20.1809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 75b824a3-fda1-481e-8cd3-08db683f9b63
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN8NAM11FT097.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8452
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Edward Cree <ecree.xilinx@gmail.com>

Support constructing VxLAN and GENEVE headers, on either IPv4 or IPv6,
 using the neighbouring information obtained in encap->neigh to
 populate the Ethernet header.
Note that the ef100 hardware does not insert UDP checksums when
 performing encap, so for IPv6 the remote endpoint will need to be
 configured with udp6zerocsumrx or equivalent.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/tc_encap_actions.c | 194 +++++++++++++++++++-
 1 file changed, 185 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/sfc/tc_encap_actions.c b/drivers/net/ethernet/sfc/tc_encap_actions.c
index c1bd7d468343..aac259528e73 100644
--- a/drivers/net/ethernet/sfc/tc_encap_actions.c
+++ b/drivers/net/ethernet/sfc/tc_encap_actions.c
@@ -243,12 +243,183 @@ static void efx_release_neigh(struct efx_nic *efx,
 	efx_free_neigh(neigh);
 }
 
-static void efx_gen_encap_header(struct efx_tc_encap_action *encap)
+static void efx_gen_tun_header_eth(struct efx_tc_encap_action *encap, u16 proto)
 {
-	/* stub for now */
-	encap->n_valid = false;
-	memset(encap->encap_hdr, 0, sizeof(encap->encap_hdr));
-	encap->encap_hdr_len = ETH_HLEN;
+	struct efx_neigh_binder *neigh = encap->neigh;
+	struct ethhdr *eth;
+
+	encap->encap_hdr_len = sizeof(*eth);
+	eth = (struct ethhdr *)encap->encap_hdr;
+
+	if (encap->neigh->n_valid)
+		ether_addr_copy(eth->h_dest, neigh->ha);
+	else
+		eth_zero_addr(eth->h_dest);
+	ether_addr_copy(eth->h_source, neigh->egdev->dev_addr);
+	eth->h_proto = htons(proto);
+}
+
+static void efx_gen_tun_header_ipv4(struct efx_tc_encap_action *encap, u8 ipproto, u8 len)
+{
+	struct efx_neigh_binder *neigh = encap->neigh;
+	struct ip_tunnel_key *key = &encap->key;
+	struct iphdr *ip;
+
+	ip = (struct iphdr *)(encap->encap_hdr + encap->encap_hdr_len);
+	encap->encap_hdr_len += sizeof(*ip);
+
+	ip->daddr = key->u.ipv4.dst;
+	ip->saddr = key->u.ipv4.src;
+	ip->ttl = neigh->ttl;
+	ip->protocol = ipproto;
+	ip->version = 0x4;
+	ip->ihl = 0x5;
+	ip->tot_len = cpu_to_be16(ip->ihl * 4 + len);
+	ip_send_check(ip);
+}
+
+#ifdef CONFIG_IPV6
+static void efx_gen_tun_header_ipv6(struct efx_tc_encap_action *encap, u8 ipproto, u8 len)
+{
+	struct efx_neigh_binder *neigh = encap->neigh;
+	struct ip_tunnel_key *key = &encap->key;
+	struct ipv6hdr *ip;
+
+	ip = (struct ipv6hdr *)(encap->encap_hdr + encap->encap_hdr_len);
+	encap->encap_hdr_len += sizeof(*ip);
+
+	ip6_flow_hdr(ip, key->tos, key->label);
+	ip->daddr = key->u.ipv6.dst;
+	ip->saddr = key->u.ipv6.src;
+	ip->hop_limit = neigh->ttl;
+	ip->nexthdr = ipproto;
+	ip->version = 0x6;
+	ip->payload_len = cpu_to_be16(len);
+}
+#endif
+
+static void efx_gen_tun_header_udp(struct efx_tc_encap_action *encap, u8 len)
+{
+	struct ip_tunnel_key *key = &encap->key;
+	struct udphdr *udp;
+
+	udp = (struct udphdr *)(encap->encap_hdr + encap->encap_hdr_len);
+	encap->encap_hdr_len += sizeof(*udp);
+
+	udp->dest = key->tp_dst;
+	udp->len = cpu_to_be16(sizeof(*udp) + len);
+}
+
+static void efx_gen_tun_header_vxlan(struct efx_tc_encap_action *encap)
+{
+	struct ip_tunnel_key *key = &encap->key;
+	struct vxlanhdr *vxlan;
+
+	vxlan = (struct vxlanhdr *)(encap->encap_hdr + encap->encap_hdr_len);
+	encap->encap_hdr_len += sizeof(*vxlan);
+
+	vxlan->vx_flags = VXLAN_HF_VNI;
+	vxlan->vx_vni = vxlan_vni_field(tunnel_id_to_key32(key->tun_id));
+}
+
+static void efx_gen_tun_header_geneve(struct efx_tc_encap_action *encap)
+{
+	struct ip_tunnel_key *key = &encap->key;
+	struct genevehdr *geneve;
+	u32 vni;
+
+	geneve = (struct genevehdr *)(encap->encap_hdr + encap->encap_hdr_len);
+	encap->encap_hdr_len += sizeof(*geneve);
+
+	geneve->proto_type = htons(ETH_P_TEB);
+	/* convert tun_id to host-endian so we can use host arithmetic to
+	 * extract individual bytes.
+	 */
+	vni = ntohl(tunnel_id_to_key32(key->tun_id));
+	geneve->vni[0] = vni >> 16;
+	geneve->vni[1] = vni >> 8;
+	geneve->vni[2] = vni;
+}
+
+#define vxlan_header_l4_len	(sizeof(struct udphdr) + sizeof(struct vxlanhdr))
+#define vxlan4_header_len	(sizeof(struct ethhdr) + sizeof(struct iphdr) + vxlan_header_l4_len)
+static void efx_gen_vxlan_header_ipv4(struct efx_tc_encap_action *encap)
+{
+	BUILD_BUG_ON(sizeof(encap->encap_hdr) < vxlan4_header_len);
+	efx_gen_tun_header_eth(encap, ETH_P_IP);
+	efx_gen_tun_header_ipv4(encap, IPPROTO_UDP, vxlan_header_l4_len);
+	efx_gen_tun_header_udp(encap, sizeof(struct vxlanhdr));
+	efx_gen_tun_header_vxlan(encap);
+}
+
+#define geneve_header_l4_len	(sizeof(struct udphdr) + sizeof(struct genevehdr))
+#define geneve4_header_len	(sizeof(struct ethhdr) + sizeof(struct iphdr) + geneve_header_l4_len)
+static void efx_gen_geneve_header_ipv4(struct efx_tc_encap_action *encap)
+{
+	BUILD_BUG_ON(sizeof(encap->encap_hdr) < geneve4_header_len);
+	efx_gen_tun_header_eth(encap, ETH_P_IP);
+	efx_gen_tun_header_ipv4(encap, IPPROTO_UDP, geneve_header_l4_len);
+	efx_gen_tun_header_udp(encap, sizeof(struct genevehdr));
+	efx_gen_tun_header_geneve(encap);
+}
+
+#ifdef CONFIG_IPV6
+#define vxlan6_header_len	(sizeof(struct ethhdr) + sizeof(struct ipv6hdr) + vxlan_header_l4_len)
+static void efx_gen_vxlan_header_ipv6(struct efx_tc_encap_action *encap)
+{
+	BUILD_BUG_ON(sizeof(encap->encap_hdr) < vxlan6_header_len);
+	efx_gen_tun_header_eth(encap, ETH_P_IPV6);
+	efx_gen_tun_header_ipv6(encap, IPPROTO_UDP, vxlan_header_l4_len);
+	efx_gen_tun_header_udp(encap, sizeof(struct vxlanhdr));
+	efx_gen_tun_header_vxlan(encap);
+}
+
+#define geneve6_header_len	(sizeof(struct ethhdr) + sizeof(struct ipv6hdr) + geneve_header_l4_len)
+static void efx_gen_geneve_header_ipv6(struct efx_tc_encap_action *encap)
+{
+	BUILD_BUG_ON(sizeof(encap->encap_hdr) < geneve6_header_len);
+	efx_gen_tun_header_eth(encap, ETH_P_IPV6);
+	efx_gen_tun_header_ipv6(encap, IPPROTO_UDP, geneve_header_l4_len);
+	efx_gen_tun_header_udp(encap, sizeof(struct genevehdr));
+	efx_gen_tun_header_geneve(encap);
+}
+#endif
+
+static void efx_gen_encap_header(struct efx_nic *efx,
+				 struct efx_tc_encap_action *encap)
+{
+	encap->n_valid = encap->neigh->n_valid;
+
+	/* GCC stupidly thinks that only values explicitly listed in the enum
+	 * definition can _possibly_ be sensible case values, so without this
+	 * cast it complains about the IPv6 versions.
+	 */
+	switch ((int)encap->type) {
+	case EFX_ENCAP_TYPE_VXLAN:
+		efx_gen_vxlan_header_ipv4(encap);
+		break;
+	case EFX_ENCAP_TYPE_GENEVE:
+		efx_gen_geneve_header_ipv4(encap);
+		break;
+#ifdef CONFIG_IPV6
+	case EFX_ENCAP_TYPE_VXLAN | EFX_ENCAP_FLAG_IPV6:
+		efx_gen_vxlan_header_ipv6(encap);
+		break;
+	case EFX_ENCAP_TYPE_GENEVE | EFX_ENCAP_FLAG_IPV6:
+		efx_gen_geneve_header_ipv6(encap);
+		break;
+#endif
+	default:
+		/* unhandled encap type, can't happen */
+		if (net_ratelimit())
+			netif_err(efx, drv, efx->net_dev,
+				  "Bogus encap type %d, can't generate\n",
+				  encap->type);
+
+		/* Use fallback action. */
+		encap->n_valid = false;
+		break;
+	}
 }
 
 static void efx_tc_update_encap(struct efx_nic *efx,
@@ -282,14 +453,19 @@ static void efx_tc_update_encap(struct efx_nic *efx,
 		}
 	}
 
+	/* Make sure we don't leak arbitrary bytes on the wire;
+	 * set an all-0s ethernet header.  A successful call to
+	 * efx_gen_encap_header() will overwrite this.
+	 */
+	memset(encap->encap_hdr, 0, sizeof(encap->encap_hdr));
+	encap->encap_hdr_len = ETH_HLEN;
+
 	if (encap->neigh) {
 		read_lock_bh(&encap->neigh->lock);
-		efx_gen_encap_header(encap);
+		efx_gen_encap_header(efx, encap);
 		read_unlock_bh(&encap->neigh->lock);
 	} else {
 		encap->n_valid = false;
-		memset(encap->encap_hdr, 0, sizeof(encap->encap_hdr));
-		encap->encap_hdr_len = ETH_HLEN;
 	}
 
 	rc = efx_mae_update_encap_md(efx, encap);
@@ -486,7 +662,7 @@ struct efx_tc_encap_action *efx_tc_flower_create_encap_md(
 	}
 	encap->dest_mport = rc;
 	read_lock_bh(&encap->neigh->lock);
-	efx_gen_encap_header(encap);
+	efx_gen_encap_header(efx, encap);
 	read_unlock_bh(&encap->neigh->lock);
 
 	rc = efx_mae_allocate_encap_md(efx, encap);

