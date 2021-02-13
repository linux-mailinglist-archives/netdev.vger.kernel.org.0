Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14B731A929
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhBMA6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:58:47 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:61434 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232486AbhBMA5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 19:57:14 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11D0RrRo014057;
        Fri, 12 Feb 2021 19:28:51 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2052.outbound.protection.outlook.com [104.47.61.52])
        by mx0c-0054df01.pphosted.com with ESMTP id 36hrw92s7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 19:28:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hl299JaJ4Wwq+neV1aMAJCsJMrqWa69tJWWBit4T8NNNpPaGfVu+VngNLq8ME8tbfXu7Od8qLYdI6eko88Gvr29NzCpWBbriJOn/aDA8oMBtbb0rmuVM1KJZWIm5NEDIsY4+K9IY0Oiz1nnAKBxSBIAXkGg6Rxf8C+rai33WdO2J1khq24ZyFxWv45gbh2E1OdUmiDzlhkz8IJMgvCHvaiRLJzErRAmlq4/63mmg8n6NBIwyTvZMn61woHh38yhLMNqybgk73rho2QJRRRVO3Zu0R7KGMxGqBcieP7dja9JJ8d95kJKmA1uc9wVU3Jtle8p1Mie+AUIBtYQTNjp+2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTwXFyEGjt6RVFJQWD7KH82azsq8YGkmYhZJRSXzCYU=;
 b=TMpL3lWSmqfK7HWUDHVCDfrz+9fK/Y6FJ6nSYHsgUlRdB6N8+nRKxS676lhwixgNo/T3eepyufQaoe8noeBloRfAEcHVKBwHWK05wNMenZ0dPxj2DWlG3NMZ1Ny8fyDTefqrNEF6n9Tkkr8Gb4S04N1tXFYMEabCXyNcQOjlfrgNQkJCjZ5BnkecLq297ay2/H+EBg2AtsHIfImwz75H3XUmHqPKarkEqDWxnS842NyTqkTzg04V/RGIGYN2jyEA7PW58mgQVapIHOopYpa7eojQUxXsj8AeUPSwkoFJmUQPLClHLubJ1ybsnouCX0JHTibo9G/WkB/gU8MAmOBPYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTwXFyEGjt6RVFJQWD7KH82azsq8YGkmYhZJRSXzCYU=;
 b=rcKnSIyEGY53DuEs8QRHAslS0uKG/fB5GiHEASoXECAoK5dKapjeNg8nP4+3vMbUG9ni+rIPqEEiSHf0iwFOF0p0OBdRITmY9n8VXcFkdUwsXAVBdPZm1kpan2I6729CZdVLCeZO3+5+uTHI+2buq3NGz2TwvgeX1cdSSYPbBXk=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:1d::17)
 by YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Sat, 13 Feb
 2021 00:28:50 +0000
Received: from YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128]) by YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3451:fadd:bf82:128%6]) with mapi id 15.20.3825.034; Sat, 13 Feb 2021
 00:28:50 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 0/2] Broadcom PHY driver updates
Date:   Fri, 12 Feb 2021 18:28:23 -0600
Message-Id: <20210213002825.2557444-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR11CA0010.namprd11.prod.outlook.com
 (2603:10b6:3:115::20) To YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:1d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR11CA0010.namprd11.prod.outlook.com (2603:10b6:3:115::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Sat, 13 Feb 2021 00:28:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3050054e-72fa-4bd8-f828-08d8cfb655ce
X-MS-TrafficTypeDiagnostic: YT1PR01MB3564:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB3564E7B594C26562E5AF25D4EC8A9@YT1PR01MB3564.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LpehQHUpU0pdfyBKiwdQu06wsDxrFkXF7BlL9kfHHAfeuxDVqI2jYoj8ezuUCQubZrB/Nf9BCSh+r8GbITehs6GsgTnx46wBtBFDXg/qjqYCL3HEiIHZIrO2rs3IhF7LgwyNdNExvvO2n0EwU34jmJxXzeAG5PYoJj5WdeZfSmoaF9pVrxVXFDZyKu6FzzS5z0Gj9jxdfFGEnlV2RFOVzWCAQOFOaKGC4bBdzti+SSa/80or1sgrXgdNiGOW4zjSXHG2VjekKbggheR2938ORf5wUq0ds45+oRluH8G42z1p0xZOVWTgOCIFy5CdC+BIOEzwa0ZPMMMe6RNpgz6rOOl7geZnKZvL6K0sLnVABPzHwb9EqVRDpsWEXmptT217keJ3lZkvitVKoXm0cZPjJeMP5/azl1WXMhmBigMeDY4PIGfswaf3gLkz2ClDtNuFbZX5RvpCk6t6jw/alR7AGHL96v0XVuuLP1xjQI1K9eO3RHoeYVrzgL/3pdjke3neCgsZLMa778v2HFZ1jikoZGvitV4a9E0uH9bVqQJyifBb6VTbb7jMjd//el0779iweF8e617j+jbowAZaSPIkOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(366004)(346002)(376002)(4744005)(1076003)(6512007)(52116002)(4326008)(478600001)(66556008)(66476007)(66946007)(2906002)(8676002)(44832011)(2616005)(107886003)(6486002)(5660300002)(69590400012)(316002)(956004)(15650500001)(83380400001)(16526019)(8936002)(6666004)(6506007)(26005)(36756003)(86362001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?CGryoYIZshe0tzQBOCakqJH27U0MuNADHEgTpSblx/84Jg7ahuxTr+bEGi/L?=
 =?us-ascii?Q?PzSR4unLHgwtrLCUcjkjrlzPYItrpSMFr2F11zHJ9Gi4Y/1mPFHUewX82+xy?=
 =?us-ascii?Q?OL/avmzkuoa7o3HyfgRQtR2JbBpcfHoMHB0FZT8mV7Ob3kJZ4XH1q50o9+gP?=
 =?us-ascii?Q?5dgfW61dE8b3mOIJgHk8TBF4RR8/Vr34XAG8PGmn1U88zq9UMpPxKJowQz5/?=
 =?us-ascii?Q?ZgsjkT6tT2kUzGn44mchVAFmSZOnU/r0rdpO5+fgpSNF4MMnSWWTRgI3b/8x?=
 =?us-ascii?Q?jQMHnvcdwBWGZolcNxCdhlQo+7LH2y+dyoGAf9HNULbHjoFJ5XcCNl7BYOJJ?=
 =?us-ascii?Q?DedFoedaehXe7dLpfBB0WJPDChr5Aka1PM4eK2Z1CrK9J99fWBJWIqmVT/kp?=
 =?us-ascii?Q?WQfegGm0FaqlwfC+0A8kybA9VYs+d3hFSI7iETxoazc21XC5FJ5Htpi7iliO?=
 =?us-ascii?Q?8bzS+7VqqahIk0yLi7KrXtegjuzNzioZxSQFK2oQ7JeL4/nCLierpV0G6k5O?=
 =?us-ascii?Q?tJi2uqkrL3TLpcIotLLNQ7WH+dja7/Zx7bir/5HgEXqQeUWOu7n7ncqAqyUx?=
 =?us-ascii?Q?HaEDZPk1fP3XhfKngKLu4VhPUXJPC0XmF9KsD/KfQCu5iX5KsAiHpbVSiu0U?=
 =?us-ascii?Q?FuN9lEAcwYgGeL+HXBXUKPeFmVsUQO/RHtYnGCKLqL45DNDufMDB7IjteMUO?=
 =?us-ascii?Q?qa4KPvYtUyUjUP5n3X+2XSO6/S4Wto7HTf9vf27jMM8Rhf/OiOU9h1vLAyuJ?=
 =?us-ascii?Q?pv8FGQJCYNgrs8ZtQe6YtAfdTYSCTcJsG7ZckU8JlQzEShzbnwYsWIWSq0zx?=
 =?us-ascii?Q?z6UGIysANOiylkbqoJxC4W2cMyeHw0zaEOOiv+POmr+ocZI0dQfh7v3/i3Hj?=
 =?us-ascii?Q?9t4CIElkleVeKVgWvuZQGSzZf4RoXw/1Dmhh5YIngv7lx58GpdVmF6l7VHnH?=
 =?us-ascii?Q?4W1b+r71hFElBsQZcnpeqQJPd0vqfaNc/IsKYNkCeEc9CBszbRmVyU7QbqCQ?=
 =?us-ascii?Q?GyJiTgzUVvKXQdZ6/Ul6mqlarSvvD7O5dpeJXUUvTnqJ/OV3csM4+fkOI5cN?=
 =?us-ascii?Q?/A7J5WseVYrWN3DAiVSV568hpCyl/Inn15Npv9pPTK0UyLYFJv1Hf/DkUlX7?=
 =?us-ascii?Q?6Wn8HFOGyzA4koK+eRyB9nP+0NtX+O/HPTp+aOjqFW7yAzblKsXXLW8/jRUD?=
 =?us-ascii?Q?nsAnm5wqFLrrnpCukAcS8Ohnp7fqMaSkhELkkhlLHkpkUFgNjOPN6r0ZLYYV?=
 =?us-ascii?Q?WdIP3r9H4Cga9yfl9HOf6EYIibqgoqmTE21a4R2C7NWWIHbko04TvxDd717U?=
 =?us-ascii?Q?ovyCptrHcLZP9jqYiixB1oCE?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3050054e-72fa-4bd8-f828-08d8cfb655ce
X-MS-Exchange-CrossTenant-AuthSource: YTBPR01MB3551.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 00:28:50.5139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRJvMojJvnDnoypFN+9ixGOK6OF3OztdOE59nZsIvkQlhfrJrapuIQRLPgZEPAfUTDOOyHfqg7wCEV6tkwQznwY0Gl6DW8ZziOER1tNl/aU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB3564
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_10:2021-02-12,2021-02-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 clxscore=1011
 priorityscore=1501 impostorscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=721 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102130002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updates to the Broadcom PHY driver related to use with copper SFP modules.

Robert Hancock (2):
  net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for
    BCM54616S
  net: phy: broadcom: Do not modify LED configuration for SFP module
    PHYs

 drivers/net/phy/broadcom.c | 109 ++++++++++++++++++++++++++++++-------
 include/linux/brcmphy.h    |   4 ++
 2 files changed, 92 insertions(+), 21 deletions(-)

-- 
2.27.0

