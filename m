Return-Path: <netdev+bounces-8179-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5737E722FA8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D562281192
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A63824147;
	Mon,  5 Jun 2023 19:20:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38622DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:20:00 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC38E183
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:19:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzZIlFDCC5ELYlwZ1qeUUx5gbwUtukQFnU6jwL7cdsm/Hv722CPoOx9Cnzh6hBRz2NrOulBQ9yQs9d1hl4WjJ+X+BYDUj7y9UkopGsl4peo8M65vuokrzRC8BFLfuedhDWzwxWhk+9FZXYgAO2hgxWjsxYPvF4EEut2V4rHdpGjPU5zQduUQpY2mJhShboBv+uStTjHMy0F7E+GHRkxGidTCRyqbtHqesy4ejZ+vrUizfMSKKCtovC9d7iRvFhrVjfgs3Iodsan4oEPeGmenfu9giOJ7aupnu89Ij+e7zqWjc76EG3/cSgLmj9aELdnHZpJa72V1vTCKnr6kYWAPVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUk84BP6IxgcozyuoQ0VZjqc+sgTVc+hwPsjPhS10lM=;
 b=KR6dTPKRYSoJ6vcg37tLD6uxfJwOh4dM6//8EmJUjsWZ4u62cH7x10nuq1Z/lTPtXddQdfGpHujYp0VhLC1Lr8d8q0yKhnH0VdLHTehVRtcJqkKhy3USukw3sBdZBjI1LtcN4fz3IWcVXv35FqHeRRe2dhR9sAp8lofHD53mKUayYXMaAiTL9YiSns7WTzCFuPxUMVBk7io70JEcQfs4BYPiVyq4SytqatpN5Ve9YSEfcQ/asu3fVt8U7uBtAWSLxTa257GMMkgVLvqwGSWucQvj7xMICHyQ8bdcnEn1+H6y7jKS++0gheXBUrEP23QxVMYR0FxjdHVxg39L1kOueQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUk84BP6IxgcozyuoQ0VZjqc+sgTVc+hwPsjPhS10lM=;
 b=oWUS0ThLFb4Wu9bRmpCdVF9pyBQR0XKK4KiGvvoTkV/CvuV2YYc0QuimnyKEeCHQA8xKBF/v0TSOeYUNVjbozNuQ5sGiao9H+/2EkRWXCqBy5Jc7u3bWdTKh5Qwg50+uFLqWgSoPo3ko/gA3EYIwB4wgnKbHWXnb1FN4CWqw2gU=
Received: from DM6PR06CA0004.namprd06.prod.outlook.com (2603:10b6:5:120::17)
 by MN2PR12MB4407.namprd12.prod.outlook.com (2603:10b6:208:260::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 19:18:30 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::7c) by DM6PR06CA0004.outlook.office365.com
 (2603:10b6:5:120::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Mon, 5 Jun 2023 19:18:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.33 via Frontend Transport; Mon, 5 Jun 2023 19:18:30 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:18:25 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:18:19 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 5 Jun 2023 14:18:18 -0500
From: <edward.cree@amd.com>
To: <linux-net-drivers@amd.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <edumazet@google.com>
CC: Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
	<habetsm.xilinx@gmail.com>
Subject: [PATCH net-next 6/6] sfc: generate encap headers for TC offload
Date: Mon, 5 Jun 2023 20:17:39 +0100
Message-ID: <672e66e6a4cf0f54917eddbca7c27a6f0d2823bf.1685992503.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1685992503.git.ecree.xilinx@gmail.com>
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT047:EE_|MN2PR12MB4407:EE_
X-MS-Office365-Filtering-Correlation-Id: 341d58f9-b24d-4ad9-2d17-08db65f9a59a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	J72nSa4eJDTlgpsHYqMe8juXRjv4SoTioR3ae3wWACz8Y8IMqsHrJuoBicnfUY7PmZNsB7o6+CHYcs/0WO/cmfCRNTdDa73Df9+NeV5ffVOELo0UZ2smQ+o2bgniM+GW9+vKhFEldGSdRBn7o3f+nIjwFkaDDlCfMaBa79ld8vEWeX463QF9uOpCVCqb740wmz7r/HpH7poAQdSkeX2gfIJ5WHajQmoUsgX/QSf9SO05PUf5v4k/NBwI07/9PR4pCDqp9GFbdbrfC2JPOMaBY7Lk2qxLuO3mUeWMyeq6NgTAsyXtNJmryhaHNyahKQvabncb2rILXQpiB1rqSEwS0yUsqfmtThaCL9ACMUY8geiBSIe6TvfVeBtUtsRkg3A83L2htz+I/J1CwMjcl2jLig5waHI61aKK1DVCcNesLLoPj8ZsXB4X+MtEvUwSLsjPBxwEcEHdsVCb6Nn57ERFgD4+63iDzzenyHTIS0Lmp0GSB89cOozjQAVTlTnh9N0l3u7jAQCA3i2gzmG/QdYG+WJd2QcJRtmEbv+hRjpdwExKIDbOScu4mCBC4o0V4a3B4UqhFwent+xU5LoyhNTT+3iv4WYU6zRNnG5WRn48kldomkrPj/jssHsC5J5x4aC42jHPKJpV+E2tJ+/R4Oa/DHL7M145QVFhrrAQ6Vn0yj219BmoltWbmZw+tyEM+OW/0lAddf034HIUH9w3mj1qV0KQhXQRTP4XRU2z0h3TfA5l4Pp4twgvA0JLJPe2UfrQxkVBMT++9bp7/G/z+IO8HQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(39860400002)(346002)(451199021)(36840700001)(40470700004)(46966006)(54906003)(110136005)(40460700003)(478600001)(8936002)(8676002)(5660300002)(36756003)(2876002)(2906002)(86362001)(55446002)(82310400005)(4326008)(70206006)(70586007)(316002)(81166007)(82740400003)(40480700001)(356005)(41300700001)(83380400001)(47076005)(26005)(9686003)(186003)(336012)(426003)(36860700001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:18:30.1882
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 341d58f9-b24d-4ad9-2d17-08db65f9a59a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4407
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
index 601141190f42..9a51d91d16bd 100644
--- a/drivers/net/ethernet/sfc/tc_encap_actions.c
+++ b/drivers/net/ethernet/sfc/tc_encap_actions.c
@@ -239,12 +239,183 @@ static void efx_release_neigh(struct efx_nic *efx,
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
@@ -278,14 +449,19 @@ static void efx_tc_update_encap(struct efx_nic *efx,
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
@@ -482,7 +658,7 @@ struct efx_tc_encap_action *efx_tc_flower_create_encap_md(
 	}
 	encap->dest_mport = rc;
 	read_lock_bh(&encap->neigh->lock);
-	efx_gen_encap_header(encap);
+	efx_gen_encap_header(efx, encap);
 	read_unlock_bh(&encap->neigh->lock);
 
 	rc = efx_mae_allocate_encap_md(efx, encap);

