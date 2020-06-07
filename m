Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF441F0C48
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 17:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgFGPBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 11:01:07 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:5605
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726528AbgFGPAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 11:00:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VW+gF4qpspOL91s/VY+mnF+hzP2WCkoPv/b8KyEFcJeU9RoT4dACi+FrtjEw7VvvrEX/fRofD4FqFqJM3QpZsTGe9zJKpHkn+ibePWc5OyHX1i5v38CM1MLTBflx6KGMEW4JUBNGYL7J0YkgUyn6G444C/QikuNr8rTyZDHRmk1PVUd9uljNIrd1PdJFRN3z11I4ailviUT6F3mjTPkFBcfDVVKjAGpgwDt3DhOjdzmcLEL9TUQiTo89ajvwcKSgEeAZN2KWSLWKFGT0+LyEw6fBkUl0n57HwlSVN2h92uU3NE+USNXIsBFRNuSZdcNykye8E3XkdmK8U+eVaOsKGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMkknZVuB+OLWasoPjJKxn7XvU/mbTnf217drmrHIBw=;
 b=Bq2IHlqW5UcKRLf21FN6WIHfyY2wI0rvqcmpttOl3gIYMJA8Ml86LY9VO2d3fmwStTNS8TojbtLuehEPq6ThMsPJzqpCygn+MIkgEp/Jnh5vYCLipgQhnrK5sJjUcpiKiKgxQ+Wuqk2zWQkurHgHnZkMvjZ11Mx6ZBx+fvaPnYU/0FhDbqPWQzZAHpKc49R4wo8Ifp6gYrqI45isPxlQePe8WctgD8nD22SaWty+keiEc8Se7DAsI9YyRsaONEren3yYjE5bXItl8ewr+i5vXRz1BJquxdlJJgbAGrp+lHx0L6bh2Oaeb3hOMqE68o84aMnSi8ylOw1clMkXT1luWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AMkknZVuB+OLWasoPjJKxn7XvU/mbTnf217drmrHIBw=;
 b=Pig01QM2IIP2D9rBKFsosr40awNiGeEU3dsQ2ZRfIBVroqi7iXHjdIlM8nkCDpQvzIESeDpEUMyAsAYrzUDhBMLrHc9risZ/B2W+qn6frugPGwJMy3iHEp+2ZCuve1Gtm6234/DutmjLaqopd9XxL6hozdrMzv0KgLJmIFloCdg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4003.eurprd05.prod.outlook.com
 (2603:10a6:208:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23; Sun, 7 Jun
 2020 15:00:25 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Sun, 7 Jun 2020
 15:00:25 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com, amitc@mellanox.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net-next 08/10] selftests: forwarding: ethtool: Move different_speeds_get() to ethtool_lib
Date:   Sun,  7 Jun 2020 17:59:43 +0300
Message-Id: <20200607145945.30559-9-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200607145945.30559-1-amitc@mellanox.com>
References: <20200607145945.30559-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sun, 7 Jun 2020 15:00:22 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 571f42b5-f637-46f0-7ebd-08d80af381ee
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4003:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB4003AEC8BC9C63B2BBAA42FFD7840@AM0PR0502MB4003.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:217;
X-Forefront-PRVS: 04270EF89C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KrBJLHWMUbDNUb6PIs4rvlhoDc75rfVv0cUNZtJSkynwZ8LALOI075dbFv4B/WqhUDPGRB1Dvk0j7JdQReGtHI9PTQZnfMhQTcsWqM/BgCLSMTWtrLYPgv+8iFUPu2gjLN/mVt5MDUPvFJlj9Q2F2v5i5aHogASA7hICIA1lNiokeJ2l/42NafHyHlRgqirtDoRmw9MsEWCKQ2yIY29yavCatZw6mPwQCjc+nKMskoAPxxvWWp1iYZUdmc/sLZ0nYYoPqco4OnNRG6HWGH3+MBE1YZAbp7n91SQ9aPd83uqRA4vgmRJ1XfvE0VZaz1eX3K17Y05BttDd7P2kZ3NGgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66476007)(66946007)(66556008)(1076003)(186003)(8936002)(16526019)(26005)(52116002)(478600001)(6506007)(36756003)(2906002)(6666004)(7416002)(5660300002)(8676002)(4326008)(83380400001)(6486002)(316002)(86362001)(6916009)(2616005)(956004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HWw0iusJK412sJb3Fu2sduf8qJLvrjHO1nsAkXiielX4l6uPmeoyFh8n9MA0O3sY5txFOt08myrb108crfnTzW8wzQgviACNiy2zJF9riZDRzluBrShWLhjyrF2j/BQdnAhnmVchz6n9VlEl8h7YMJCJ8FWffvb5QjhgpaNf8wRBIu3Z8e9lVbpPwjoNwZgUYijnaLJstldkdoXVAlDgexBN+zEzk/zdOeZ8KO2tmwegeT9aEX7ycgtpdoiM4SWSsEH+XaWOk7JAOtOL/BLI7F36AVOhHGkPHR95D9kQv0XFiUNxHuBv4+m59M3aLzQGfSQdA9J2sF2GuRhloPBsD5ZamATL63ruRDRotEg4/tB7l7AVGK0q+nUfZ44ggctl/hZvhz7iSal1Af8FYYymXF5EuSzGWAxA5GVjY4rRu6T9nXR0+eHD9iLv9fttpdi3C9Sq179ocXdJMN/M2Gzf//KTnYNONB9Rhg3Ge0pxHeI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 571f42b5-f637-46f0-7ebd-08d80af381ee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2020 15:00:24.9075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hl3F7CNOJ4jflwgWuw3JZTm5/KcapHlWJiAROPMjGN0yB+Cve/i9UTY/zq6Pf8cPTtVqs3KX7zjgkN0nC7DMGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently different_speeds_get() is used only by ethtool.sh tests.
The function can be useful for another tests that check ethtool
configurations.

Move the function to ethtool_lib in order to allow other tests to use
it.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
---
 .../testing/selftests/net/forwarding/ethtool.sh | 17 -----------------
 .../selftests/net/forwarding/ethtool_lib.sh     | 17 +++++++++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/ethtool.sh b/tools/testing/selftests/net/forwarding/ethtool.sh
index eb8e2a23bbb4..ea7a11a9f788 100755
--- a/tools/testing/selftests/net/forwarding/ethtool.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool.sh
@@ -50,23 +50,6 @@ cleanup()
 	h1_destroy
 }
 
-different_speeds_get()
-{
-	local dev1=$1; shift
-	local dev2=$1; shift
-	local with_mode=$1; shift
-	local adver=$1; shift
-
-	local -a speeds_arr
-
-	speeds_arr=($(common_speeds_get $dev1 $dev2 $with_mode $adver))
-	if [[ ${#speeds_arr[@]} < 2 ]]; then
-		check_err 1 "cannot check different speeds. There are not enough speeds"
-	fi
-
-	echo ${speeds_arr[0]} ${speeds_arr[1]}
-}
-
 same_speeds_autoneg_off()
 {
 	# Check that when each of the reported speeds is forced, the links come
diff --git a/tools/testing/selftests/net/forwarding/ethtool_lib.sh b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
index 925d229a59d8..9188e624dec0 100644
--- a/tools/testing/selftests/net/forwarding/ethtool_lib.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
@@ -67,3 +67,20 @@ common_speeds_get()
 		<(printf '%s\n' "${dev1_speeds[@]}" | sort -u) \
 		<(printf '%s\n' "${dev2_speeds[@]}" | sort -u)
 }
+
+different_speeds_get()
+{
+	local dev1=$1; shift
+	local dev2=$1; shift
+	local with_mode=$1; shift
+	local adver=$1; shift
+
+	local -a speeds_arr
+
+	speeds_arr=($(common_speeds_get $dev1 $dev2 $with_mode $adver))
+	if [[ ${#speeds_arr[@]} < 2 ]]; then
+		check_err 1 "cannot check different speeds. There are not enough speeds"
+	fi
+
+	echo ${speeds_arr[0]} ${speeds_arr[1]}
+}
-- 
2.20.1

