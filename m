Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEA622CC1FB
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389088AbgLBQSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:18:49 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:55448 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728614AbgLBQSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:18:48 -0500
Received: from pps.filterd (m0170393.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2G2og1020112;
        Wed, 2 Dec 2020 11:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=smtpout1;
 bh=R9gWkkqT52ksh/nQaF9y9YOeO2DMvI4ZuetQduJ8x64=;
 b=ASewIRX1z+V2fTjs2x0QRXMOPnF2x57dVVkcmuaJKrzc/uxqqzdhuWFYsjjbb5u2hLuE
 TuO/Tp6GBcO/bWoZUPgyS2iPxjmm2+EKBSodhtGqgFMfVJAUtEUXiIZv5mGldpOuzKPn
 5QgCGIMCGFCqRweoQ1UnorC9EeeE9gsE7yEmdI3C3C/4RYo0GiIcSm43IzCQaLNSSCAG
 Qgi/dMv9dGvDxq5CZJzxXXDjin6rd7S6yNHJvy1E/3eZOTE5+4m1ffrU0/Nget0eKJF0
 eDs/PmG9iYHqfNFgOH3Gssx4mBn0e4LOSMpCXFn8mRzGqTbs3p3H78y4oPBQMuIe2ZlF 0w== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 353jrq0n58-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Dec 2020 11:18:07 -0500
Received: from pps.filterd (m0134746.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B2GEsXF044458;
        Wed, 2 Dec 2020 11:18:06 -0500
Received: from ausxippc110.us.dell.com (AUSXIPPC110.us.dell.com [143.166.85.200])
        by mx0a-00154901.pphosted.com with ESMTP id 3569ejnfje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 11:18:06 -0500
X-LoopCount0: from 10.173.37.130
X-PREM-Routing: D-Outbound
X-IronPort-AV: E=Sophos;i="5.78,387,1599541200"; 
   d="scan'208";a="1013735384"
From:   Mario Limonciello <mario.limonciello@dell.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Cc:     linux-kernel@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        Mario Limonciello <mario.limonciello@dell.com>,
        Yijun Shen <yijun.shen@dell.com>
Subject: [PATCH v2 5/5] e1000e: Export s0ix flags to ethtool
Date:   Wed,  2 Dec 2020 10:17:48 -0600
Message-Id: <20201202161748.128938-6-mario.limonciello@dell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201202161748.128938-1-mario.limonciello@dell.com>
References: <20201202161748.128938-1-mario.limonciello@dell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_08:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 bulkscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020096
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012020096
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This flag can be used for debugging and development purposes
including determining if s0ix flows work properly for a system
not currently recognized by heuristics.

Tested-by: Yijun Shen <yijun.shen@dell.com>
Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c | 40 +++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 03215b0aee4b..eb683949ebfe 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -23,6 +23,13 @@ struct e1000_stats {
 	int stat_offset;
 };
 
+static const char e1000e_priv_flags_strings[][ETH_GSTRING_LEN] = {
+#define E1000E_PRIV_FLAGS_S0IX_ENABLED	BIT(0)
+	"s0ix-enabled",
+};
+
+#define E1000E_PRIV_FLAGS_STR_LEN ARRAY_SIZE(e1000e_priv_flags_strings)
+
 #define E1000_STAT(str, m) { \
 		.stat_string = str, \
 		.type = E1000_STATS, \
@@ -1776,6 +1783,8 @@ static int e1000e_get_sset_count(struct net_device __always_unused *netdev,
 		return E1000_TEST_LEN;
 	case ETH_SS_STATS:
 		return E1000_STATS_LEN;
+	case ETH_SS_PRIV_FLAGS:
+		return E1000E_PRIV_FLAGS_STR_LEN;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -2097,6 +2106,10 @@ static void e1000_get_strings(struct net_device __always_unused *netdev,
 			p += ETH_GSTRING_LEN;
 		}
 		break;
+	case ETH_SS_PRIV_FLAGS:
+		memcpy(data, e1000e_priv_flags_strings,
+		       E1000E_PRIV_FLAGS_STR_LEN * ETH_GSTRING_LEN);
+		break;
 	}
 }
 
@@ -2305,6 +2318,31 @@ static int e1000e_get_ts_info(struct net_device *netdev,
 	return 0;
 }
 
+static u32 e1000e_get_priv_flags(struct net_device *netdev)
+{
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	u32 priv_flags = 0;
+
+	if (adapter->flags2 & FLAG2_ENABLE_S0IX_FLOWS)
+		priv_flags |= E1000E_PRIV_FLAGS_S0IX_ENABLED;
+
+	return priv_flags;
+}
+
+static int e1000e_set_priv_flags(struct net_device *netdev, u32 priv_flags)
+{
+	struct e1000_adapter *adapter = netdev_priv(netdev);
+	unsigned int flags2 = adapter->flags2;
+
+	flags2 &= ~FLAG2_ENABLE_S0IX_FLOWS;
+	if (priv_flags & E1000E_PRIV_FLAGS_S0IX_ENABLED)
+		flags2 |= FLAG2_ENABLE_S0IX_FLOWS;
+	if (flags2 != adapter->flags2)
+		adapter->flags2 = flags2;
+
+	return 0;
+}
+
 static const struct ethtool_ops e1000_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_RX_USECS,
 	.get_drvinfo		= e1000_get_drvinfo,
@@ -2336,6 +2374,8 @@ static const struct ethtool_ops e1000_ethtool_ops = {
 	.set_eee		= e1000e_set_eee,
 	.get_link_ksettings	= e1000_get_link_ksettings,
 	.set_link_ksettings	= e1000_set_link_ksettings,
+	.get_priv_flags		= e1000e_get_priv_flags,
+	.set_priv_flags		= e1000e_set_priv_flags,
 };
 
 void e1000e_set_ethtool_ops(struct net_device *netdev)
-- 
2.25.1

