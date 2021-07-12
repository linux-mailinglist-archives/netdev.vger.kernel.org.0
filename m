Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5A513C5C26
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 14:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbhGLMaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 08:30:02 -0400
Received: from mail-dm6nam10on2041.outbound.protection.outlook.com ([40.107.93.41]:16067
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230210AbhGLMaB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 08:30:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LusUqCZWuRRumUGtOTNusodMQbKe1Y1YXcn2xhiAPOtBnLwYRuDaJwQLidSQ/HBfIWnP5NBHfG6cCaTekJW9xqdZA2eVhMbUwVPfUCnc8h3NnooQVR9uQDZds8JdVKi0x3Hqj8O+PiHlweUgKIILNle2Q2t75zzLsadS0/fIHryyvHLqchOHFCrkVduhbg9KlGl0f8CbmvQDunaoaXAs0ugCQBjKEAlrOMkYZvQWio5pEI9Mjw8gXWbMlIDpbaFzfrFuUsaWMAxw6xAY6pOhYingnNoMbLkl/rRmMyc2HHzTteQBMh72ZPWLhMzh3+TxfkjewRIwBN2lrLX85rKuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5N4JUejIw0XxvpMVZQ+G3PCyzzxM76s3vl0UiGPhdgk=;
 b=mfbKM3xwAEW398X2v15IqaKYOss94zuvdhv7nBINfarV2RgtvvsQ9Gpsn5ZQtffndUViMCt04psT7szXbo/5QzJWUmgk/9vo+iJ2OolIhmmtTcVSZtgB3ks6o2m+vJoGFcBiP8HbCGHM8dNPBiflsJQd3j2S8Rb0jHqi1x9fnjGvkJQcGxEElC210HxwsNxiQ0ZnujjepWGgVsSsxD2ggw5mDvekJhgy80HG579m9v6QWTYQMG8VF6WKZR1q+e3126alGDkDWIQGOqIz2xXmHd8wFa94xFajHbTlZBh8BL18jiltCABZv20/CJYFpn2K7wXfcgtqwjg/mhyYi4mdvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5N4JUejIw0XxvpMVZQ+G3PCyzzxM76s3vl0UiGPhdgk=;
 b=GMdhhv0RIzs6UgntZd0kwta8oLV0TGjmRqVIdfy3VGMYZTxIS2TZtg9/JdbhBvlBnMP0mDsij6N9wb53T1rN5h/oXFfpQwUKGbi7dh5n4hWlx7BZnfCt991Wx6ON5ShYbXd7dxGferX+fxj50MWyP5RwO5dPCnWXH9XMsEZ8z2dvlRvQz4AqGgs+3YNUNUWuC5aE+eyZIRoLuWUdBHV37dGTD2I2Bn398wJEqmhRP+fHE1nAw7odZNwl8gcfXA6R1lOiblpPa/cLUljKkPNYwFnr/WW4yX2CVsS+1HRZTUg9Z/31Q7Tf5aglwh81HFu9BMhsldw7oVKnkqzZ8Nk0zQ==
Received: from DM6PR07CA0082.namprd07.prod.outlook.com (2603:10b6:5:337::15)
 by DM6PR12MB4372.namprd12.prod.outlook.com (2603:10b6:5:2af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Mon, 12 Jul
 2021 12:27:12 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:337:cafe::c7) by DM6PR07CA0082.outlook.office365.com
 (2603:10b6:5:337::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend
 Transport; Mon, 12 Jul 2021 12:27:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 12:27:12 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 12 Jul
 2021 05:27:11 -0700
Received: from dev-r-vrt-138.mtr.labs.mlnx (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 12 Jul 2021 12:27:09 +0000
From:   Roi Dayan <roid@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Roi Dayan <roid@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        "Stephen Hemminger" <stephen@networkplumber.org>
Subject: [PATCH iproute2 1/1] police: Fix normal output back to what it was
Date:   Mon, 12 Jul 2021 15:26:53 +0300
Message-ID: <20210712122653.100652-1-roid@nvidia.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a699fbb7-b4f4-41ce-a125-08d94530603a
X-MS-TrafficTypeDiagnostic: DM6PR12MB4372:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4372C98F98C6B91472C5A672B8159@DM6PR12MB4372.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:291;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 47Z4+OkG/CRp5Ddvj8XMN3fqyBMloxgDohTpMlEjNQ8wy8DgoFXFeNx3tdpmC5Rlyk+Ikd263J/FdqhmAsdsFKlDHiDqiM5/6zbpQQXmE5o2V3y10guzv5oADqNvFqWLB92lAO/EnnzqHFZwo+BwIrI+14seJQ0EApVcJYtTd+cy1+sUss9i2Qw60wlA1Tq0qSPedWtkBYxT9i9ZtZ40zKYsttLHgywjuNO0MvmBC/L8Y8JHjSwSKiEicpRE9gk/SfGL2AuwWZGRiNcTZFOADnyvzB88ejhAq5Kol4rHwm+r007lltGrljvRysuGL6GvV4eF3IsmifBLWGqJlH1lyqX+3yR8W2jBdZQO+37pDNK+FV67GUkzA/dG9Gi2YkQj6JkESV3eqyjLpYPvEuyns3rei75f0qUYo5ECBcLYa6H2JFJd2XU9tFmLVrmfJu2sFaBvkSFLO0BXntWf4sZ5pGVeQykvbgMnUdnHIpXNC2+QmYOH6SzbPaCUSWuXdBFolXnrqA0wQX0bFC2KOG1t8a1CqG6hbYMGIqPazONSokBiKkqdxVwv20EYTbX+QCUOA7XzI1hLqcN4dcquU+gleW3ZrHe9YTI0idWnvRd8URv8qM3I9oFOsxVFLtCiYEY3WHxZuuJ9IBjpphGe6jYZ5PtjvQet6SQxdLMHlO8gjgOJAvJ2Y4+HPcEVbA5M5G4onqm+c6REseKzekWYV0vhnEZH37ReZkecQbom1bbhHm8=
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(36840700001)(46966006)(336012)(1076003)(426003)(6666004)(2906002)(34020700004)(82310400003)(36860700001)(82740400003)(186003)(6916009)(70206006)(47076005)(316002)(70586007)(26005)(478600001)(54906003)(36756003)(83380400001)(86362001)(7636003)(2616005)(356005)(5660300002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 12:27:12.3728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a699fbb7-b4f4-41ce-a125-08d94530603a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4372
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the json support fix the normal output was
changed. set it back to what it was.
Print overhead with print_size().
Print newline before ref.

Fixes: 0d5cf51e0d6c ("police: Add support for json output")
Signed-off-by: Roi Dayan <roid@nvidia.com>
---
 tc/m_police.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tc/m_police.c b/tc/m_police.c
index 2594c08979e0..f38ab90a3039 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -278,7 +278,7 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	__u64 rate64, prate64;
 	__u64 pps64, ppsburst64;
 
-	print_string(PRINT_ANY, "kind", "%s", "police");
+	print_string(PRINT_JSON, "kind", "%s", "police");
 	if (arg == NULL)
 		return 0;
 
@@ -301,7 +301,8 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
 		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
 
-	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
+	print_hex(PRINT_FP, NULL, " police 0x%x ", p->index);
+	print_uint(PRINT_JSON, "index", NULL, p->index);
 	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
 	buffer = tc_calc_xmitsize(rate64, p->burst);
 	print_size(PRINT_FP, NULL, "burst %s ", buffer);
@@ -342,12 +343,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
 		print_string(PRINT_FP, NULL, " ", NULL);
 	}
 
-	print_uint(PRINT_ANY, "overhead", "overhead %u ", p->rate.overhead);
+	print_size(PRINT_ANY, "overhead", "overhead %s ", p->rate.overhead);
 	linklayer = (p->rate.linklayer & TC_LINKLAYER_MASK);
 	if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
 		print_string(PRINT_ANY, "linklayer", "linklayer %s ",
 			     sprint_linklayer(linklayer, b2));
-	print_int(PRINT_ANY, "ref", "ref %d ", p->refcnt);
+	print_nl();
+	print_int(PRINT_ANY, "ref", "\tref %d ", p->refcnt);
 	print_int(PRINT_ANY, "bind", "bind %d ", p->bindcnt);
 	if (show_stats) {
 		if (tb[TCA_POLICE_TM]) {
-- 
2.26.2

