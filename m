Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A41E4FAEF
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 11:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbfFWJYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 05:24:43 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:14266 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726050AbfFWJYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 05:24:43 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5N9M7or007367;
        Sun, 23 Jun 2019 02:24:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=proofpoint;
 bh=bTZct3WyNTs8t7ljibZ5PG06Ui+Yj9uekmABLoOpIrI=;
 b=nndYEEkfAJrNUT/AWQJJdY9cSH1V7d2AhZKda9mr35Lbu6AwCCVKP484djAcy+bHCs0+
 y7t/Vfq0FAtWH0eqoxy6PAduc1313tfMIol6EV6HH5QdqpE20TrInOcGHNdVamQyEJVA
 djx20U6UAJeQ3sEuoAvyQlIpT6wWquQCNXpunz1On6gv9/1vVuGvYIn7FmT48BNbITtD
 1Jfs7eSPel3v4Qp0Ll0O6EB9m1jbwxUBzsZPaYYR4Nn2e4zPfj5t1bSsxMew909e1LMQ
 AxUEflRKUJX/Tgqk08mAOK5mXAKPIgAxNf8l7SsLuRatb5+xmgOBYA25BAmc+PKGxEFt OQ== 
Authentication-Results: cadence.com;
        spf=pass smtp.mailfrom=pthombar@cadence.com
Received: from nam01-by2-obe.outbound.protection.outlook.com (mail-by2nam01lp2054.outbound.protection.outlook.com [104.47.34.54])
        by mx0a-0014ca01.pphosted.com with ESMTP id 2t9gvs2nqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 23 Jun 2019 02:24:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTZct3WyNTs8t7ljibZ5PG06Ui+Yj9uekmABLoOpIrI=;
 b=VCAlD9GjnVjTuAN+WhW9Nk8NO3FfXQ9+p+bzwLHwX9zs7SmnJzB7LJz2kWlMcwQrRY1A8occrABkO/0CTUFxDq7FohDCMzVmMAoztR52L6uwqCGK2w6SNGqhNQvpZqKWHhcz8RthI+4Vl4OsHjD8PinTOsFbNyZOOyTPVledLFU=
Received: from DM5PR07CA0089.namprd07.prod.outlook.com (2603:10b6:4:ae::18) by
 DM6PR07MB6827.namprd07.prod.outlook.com (2603:10b6:5:159::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Sun, 23 Jun 2019 09:24:32 +0000
Received: from BY2NAM05FT055.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e52::208) by DM5PR07CA0089.outlook.office365.com
 (2603:10b6:4:ae::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2008.16 via Frontend
 Transport; Sun, 23 Jun 2019 09:24:32 +0000
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 cadence.com discourages use of 199.43.4.28 as permitted sender)
Received: from rmmaillnx1.cadence.com (199.43.4.28) by
 BY2NAM05FT055.mail.protection.outlook.com (10.152.100.192) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2032.6 via Frontend Transport; Sun, 23 Jun 2019 09:24:32 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id x5N9OTjd026804
        (version=TLSv1/SSLv3 cipher=AES256-SHA bits=256 verify=OK);
        Sun, 23 Jun 2019 05:24:30 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3; Sun, 23 Jun 2019 11:24:28 +0200
Received: from lvlogina.cadence.com (10.165.176.102) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Sun, 23 Jun 2019 11:24:28 +0200
Received: from lvlogina.cadence.com (localhost.localdomain [127.0.0.1])
        by lvlogina.cadence.com (8.14.4/8.14.4) with ESMTP id x5N9OSIZ015394;
        Sun, 23 Jun 2019 10:24:28 +0100
From:   Parshuram Thombare <pthombar@cadence.com>
To:     <andrew@lunn.ch>, <nicolas.ferre@microchip.com>,
        <davem@davemloft.net>, <f.fainelli@gmail.com>
CC:     <linux@armlinux.org.uk>, <netdev@vger.kernel.org>,
        <hkallweit1@gmail.com>, <linux-kernel@vger.kernel.org>,
        <rafalc@cadence.com>, <aniljoy@cadence.com>, <piotrs@cadence.com>,
        <pthombar@cadence.com>
Subject: [PATCH v4 5/5] net: macb: parameter added to cadence ethernet controller DT binding
Date:   Sun, 23 Jun 2019 10:24:25 +0100
Message-ID: <1561281865-15328-1-git-send-email-pthombar@cadence.com>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
References: <1561281419-6030-1-git-send-email-pthombar@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:199.43.4.28;IPV:CAL;SCL:-1;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(39860400002)(396003)(346002)(376002)(136003)(2980300002)(199004)(189003)(36092001)(16586007)(7696005)(356004)(6666004)(76176011)(4744005)(5660300002)(8936002)(4326008)(50226002)(51416003)(69596002)(336012)(486006)(7126003)(70206006)(11346002)(76130400001)(81166006)(107886003)(126002)(81156014)(26826003)(54906003)(53936002)(446003)(476003)(426003)(70586007)(2616005)(316002)(53416004)(68736007)(110136005)(478600001)(77096007)(48376002)(2906002)(86362001)(8676002)(2201001)(47776003)(50466002)(305945005)(186003)(36756003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR07MB6827;H:rmmaillnx1.cadence.com;FPR:;SPF:SoftFail;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70954ab7-e528-4c23-4d2c-08d6f7bc99ad
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:DM6PR07MB6827;
X-MS-TrafficTypeDiagnostic: DM6PR07MB6827:
X-Microsoft-Antispam-PRVS: <DM6PR07MB6827FF94D1EA233EC22119A9C1E10@DM6PR07MB6827.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 00770C4423
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: zWYZ9SrpO+zApTYHSbQHUbmGkNwXBD/QTuEritfHsMM2bybP7bg4Iu9bp3jYfA0ZSq/Zn5kAhGaGgzZarHakGc0WwET2P9zBEEefCgbf6wjxnMAh3jz5noNuN+W4GoC5sSxq5b1iBcAZK9TCkeaKNfTd9/wZ/GCcTMHXU+rHLvXR566mrGctEm0d05nNFaAS9DU0ZN0Eg3rUwqzJu3iyqfW7Pqw859HgogN61ygAtag4AkXONkIF07kYiNTsILW7cqpLCQv10mEtv472esNNpV/TuKFWS2EFIFw7Z4HbfCW1F/sjlQur87TilI7nHm+/OolZpTXRfyoWG0ie+LMtI8TzF0Fwf8PmT8FOkIpAKWbIdkno7JXWYgOJwbl2M9iXjfZs3MT1YS9RsUu0hUkfoV0cH0cX9gk9+YnHZMjLMPs=
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2019 09:24:32.1175
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70954ab7-e528-4c23-4d2c-08d6f7bc99ad
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.28];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB6827
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:spf.smktg.jp include:_spf.salesforce.com
 include:mktomail.com include:spf-0014ca01.pphosted.com
 include:spf.protection.outlook.com include:auth.msgapp.com
 include:spf.mandrillapp.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-23_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906230083
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New parameters added to Cadence ethernet controller DT binding
for USXGMII interface.

Signed-off-by: Parshuram Thombare <pthombar@cadence.com>
---
 Documentation/devicetree/bindings/net/macb.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 63c73fafe26d..dabdf9d3b574 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -28,6 +28,9 @@ Required properties:
 	Optional elements: 'rx_clk' applies to cdns,zynqmp-gem
 	Optional elements: 'tsu_clk'
 - clocks: Phandles to input clocks.
+- serdes-rate-gbps External serdes rate.Mandatory for USXGMII mode.
+	5 - 5G
+	10 - 10G
 
 The MAC address will be determined using the optional properties
 defined in ethernet.txt.
-- 
2.17.1

