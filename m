Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07010302722
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 16:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbhAYPpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 10:45:18 -0500
Received: from mail-eopbgr80122.outbound.protection.outlook.com ([40.107.8.122]:60774
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730279AbhAYPox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 10:44:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLL6bRuQkEV7E0quflL1YLTMwpwffgpUED3197AQ0cCX0tmeEEhtj0wlw1KEfjeETsNP8r+L3VDKxOS9izEFwDMGcqYQgPgTjwH+Qk7vPwbrLstZNbhuoc2MdNua9cKRF3t6w4xvPdldUV8+39jWu+m3ivrM8rlzpQNuu2Hkfhyt8UmSFgLJ8lIUWu9Wzz/9c1BnN11FlLpmt7gIgzoFh0bS3QSKPtp8Ma+B4kGZaq7unkgjqK+y9ZBO4MmbVHjcIdNyuXIxQbeFp8Tbns5ygjxQbJP7xvCY9BbGJUvZA8y1BbhlGDOLV+icEY+hXI9/cgXlGz/IbWYdj3xD6l+NAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNGycpj62OACl8F9sWq8uhkww4+tO3uqdZKPbGwiLUI=;
 b=Udk8ESkr9Vqo7WRTu2h/iuoLwUzsL6QJI64jGvXT/ZmpfB2NBpMV9ai3fTvn7fIrRXae1BSjnB4/bjLq4n+UNzCuI000PT495slqvMcWCfX71ZgYJ6n5knX+H97b3TqfxBEnigNZlv2wnAk5aRrimS+00IL5lit5rqYyuUy39IEL2VPL7PZVyHGtl5a9RY1TuQwNUR720Xt/hu7Ou/db+O/VzmVIQ1IOAlH66PXbKWLp+px92vI4Wp03nDoWuxppnIY8SgQpZpvqaOZMBE3GiaEGlu3Jv0znb8AIpRIXzUlbKAdUXfKrK8VNvC/wwP/pGTQMOvaNngQZcgrqV5HW+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNGycpj62OACl8F9sWq8uhkww4+tO3uqdZKPbGwiLUI=;
 b=gKA0F3jsFPXFA2cMTj1Id5LaPNeLl41akCUpnOWjOG5B8HKLVmTHuQKtPocI9reGbHO/AsO5KhDNVwuTDSeLcQQwMbCt6k4zOcBORnHug5UZTmp7onIl3lXd0mxLj80w/6Kk1m1Ot4nU/1Av3/R2l6Qa8h1p69R7arTuT2zefDY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3331.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:18b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Mon, 25 Jan
 2021 15:04:57 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3784.017; Mon, 25 Jan 2021
 15:04:57 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net-next v2 0/2] net: dsa: mv88e6xxx: remove some 6250-specific methods
Date:   Mon, 25 Jan 2021 16:04:47 +0100
Message-Id: <20210125150449.115032-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR1001CA0048.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::25) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM5PR1001CA0048.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Mon, 25 Jan 2021 15:04:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de493cab-89a3-4f2a-59ba-08d8c14293b8
X-MS-TrafficTypeDiagnostic: AM0PR10MB3331:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3331FEA97480EAAD47AB16E693BD0@AM0PR10MB3331.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pxQecCKJOJ3hGx83PBpf6ruAU3QYkUZuwdPoc6SUUHKkiixh7mg8yBaPfPzMguOYL9XXlM0Sn29oyeHOLMs+gEwM6DtM4T0UjB17n91UBqEIL0CvS25BcdqmNK3zwBw9bKLV8Cycwo5ShUft5WTE2bj9o+fnJeo7hVy8vv5AP+13ocZTqjIcvsEe+Z+J+tTIugi6KXpRMfxBBTsTZvasAdMJ4u7eY2qf62aRHrWa52MMSwhMCRCRZc4cZIulcBOpeZqBq4xsGd++YUnJUGtPtarhwvsUZL/ec6THhanpaGmoIGEoAvgkRgFFW9ijbRQC7bnxXlf4hftvssrfGBIk3FDLhdS7skHL0qLngRErlQccs90kNDmPHUU1sXECnzeHFc1R4DEBIDdQ7MzL5GcgRvXF9HXAsiXQ49QVOfoLqiQcaaq/LTaGIqYdBRekO6osrRV5PHM/yGf2i1hWkXbZuVcCKu4bg7jTkf3Ao6rXKDm4GH+HyzHCo/uSEEFtfkOxQri4azgy2hzckOMnV6+xsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(39850400004)(136003)(396003)(376002)(52116002)(83380400001)(4326008)(8676002)(6486002)(66476007)(5660300002)(66556008)(107886003)(66946007)(36756003)(54906003)(44832011)(6512007)(8976002)(16526019)(316002)(8936002)(478600001)(186003)(26005)(2906002)(6916009)(6666004)(1076003)(2616005)(86362001)(956004)(6506007)(4744005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bgruWD5+V1qU6iCEB0lk0rMT0W0ccJrYCTn2T3SXQnBeoYxYy4+THvLVblM5?=
 =?us-ascii?Q?Kx6DEJor9G6GrqDFLyEQYyOVMujvGR+ghWQs7SYTOihlbElIF6vqWVAv1dsX?=
 =?us-ascii?Q?2nrFj+WdSAP6ghcesFRPJttPgLvt9eOgwZI68ZDs6NlNfLvW2YJM8URBepaY?=
 =?us-ascii?Q?g7uUFBx2ucH3RIGylpA3KuIyZuqsITDpE1yarEUjtz1n1VD6epKuxxBnO2cK?=
 =?us-ascii?Q?FmMoVWOabZROLkerRJrKmBugbYQPvZtWqJ/4vehDUYdACo+f0e5l04vkJXNj?=
 =?us-ascii?Q?dw7T8BIvupi6c+4swOpbTx90QAw4FwZVnUOkY3QWqtRH8rJnKYwD5vbol9hn?=
 =?us-ascii?Q?fOHC7X5cMXW9CplDdZ1NDl6uiO+jNAqIQmbr0Ry0qnvH2pVpDXwW2/w4rYwv?=
 =?us-ascii?Q?8tb7yglz6MEL7AbRkxGn5A5oSVch9PgO/RRaJ1Qe8iCc7GCjtipfQwuc5qQl?=
 =?us-ascii?Q?srHIj7f0lUZiOVBukmhLbiUu/LXGf4h+XfuomyZ1ba215s6eMxptDVgIyE/3?=
 =?us-ascii?Q?VMp0E4Uf+MagU5jfqegVWifM1lFesqWEZUNY3OxDHGG+/kU/omgjGYEdXBHt?=
 =?us-ascii?Q?fY3L2IGNJ1Cuo+07okkTcp4t6WbdeSq6RRZ88C7QnCk3h1Uw3uVKRHuTW2CJ?=
 =?us-ascii?Q?que0b3Pk41uGNjI+Y+d7J6SOrRx1+xmhDXjhZ2R1JdA5CA0bDkTB/07cCE3M?=
 =?us-ascii?Q?WMYD59Oax05EoSEjO8fim9YY2bEQXwQ1OtRtoXIlo5ASTycJC3mbmvGkU28a?=
 =?us-ascii?Q?Cn6Lnc1+HrEl81SXa5ayXmCpAlhkIzp0f4rG0vbDisfi8P9hHEhQycUVUY9e?=
 =?us-ascii?Q?N3r1hY9PgKImjW1wK8tg1djU5BgZ8cjSkg+EOBUIwRp8ooK/t/7JViSP62F2?=
 =?us-ascii?Q?2AwkE1V6/K7aZgPE0ZuwRjYFjPfOep4iR5DE884lOPiyTyix66SZ95qbIJ7t?=
 =?us-ascii?Q?xE17vCCgLqxt02rKyQ5obvys1SF5YXVgbNWTxs8RV/if2eWihDWjbdQSbXdp?=
 =?us-ascii?Q?htB4?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: de493cab-89a3-4f2a-59ba-08d8c14293b8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2021 15:04:57.3573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gcEfwrUgY4rd+F+K9i0a21/5WTUF6YSO8E75NhU4xCCfB27BoF+Y8qYp8qJyiC6yvhKcuYUkerFQWmioUdMyD0a1OtWlyE14gm+CT5qKFqw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3331
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2:

- resend now that the bug-fix patch (87fe04367d84, "net: dsa:
  mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext") is in
  net and also merged to net-next.

- include various tags in patch 1.

- add second similar patch for loadpurge.

Rasmus Villemoes (2):
  net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_getnext() for the 6250
  net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_loadpurge() for the 6250

 drivers/net/dsa/mv88e6xxx/chip.c        |  4 +-
 drivers/net/dsa/mv88e6xxx/global1.h     |  4 --
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 69 +++----------------------
 3 files changed, 8 insertions(+), 69 deletions(-)

-- 
2.23.0

