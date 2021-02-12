Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6124531A421
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhBLSBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:01:36 -0500
Received: from mail-co1nam11on2056.outbound.protection.outlook.com ([40.107.220.56]:30048
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229451AbhBLSBe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:01:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P90rzTx4O5GWEsTeFuLx80tTtyCK7DTEW+Dx186z3RXiSMTRyUz08WJmNMZgPE3WKdRdPh9YR/oBDgblRSZNlGw+AJJcg545Bqdycgvj7AhD6gI1pF+EmcNUHzEYA8LHOlaGbRktpGetr3iJOHZckVZk7kmf+4nyBRyBIby0vzQehu1+VhSQ3C6VyFaJAdaFEUi2Dr+zJSAdijFUQuJjRJLwbQ1Le4tuRSs7svk7CN2gCoMbUq5hzxAbTE7h7LAgNTpyIc/g+qgczGLIJBXuJfsshwvkosQ7VSGAiaB+P/2nEoFZ0Gz9K2YZdkfzUQh9737vEPEzArSZ4lJzBHsFpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdy6B7CuZbaSu3q3G1P+hlGrk6YegH1hqJlRuIWRoRw=;
 b=gpOBWfYcD0O4tY0/pBwNmKgQVgaoXVrf0zFvW4ojJbW4W68LYB3tz8eNJqD6/CsoRZkOTcohHS0c/GQGlcw79f99TK9D3b82+MM6GxC9gWtAo6F1YJlc/CTS9voKOOHs9jDn7PxC4ynLDPMGOaCqAkTz5qu1w7VVg083765O/TnOwW2W1dqfbkyHgcfJEtbLEhF8+HSzgah7X14U+rX2cQT3z1+Lti230bxyS9qeu9FuqWHKPIbFRKQ6fliddGQhXR7AqAmVEJ9YNwxQ/05xWZi61D8AYIpYpQqmKfkG0lCWx/WgUY4A5kl+dEXRsg6ftU04/IQLk6tQ6S1Xmq+6OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kdy6B7CuZbaSu3q3G1P+hlGrk6YegH1hqJlRuIWRoRw=;
 b=GBUsrQj4aw6kEnV4Tfm4jsJLj8y9u8U99TxNDYANWZ/XT9P0RrOHPofgxhDzK8HhCCvLQw/YQPtS4Xa00WaRZfLXCiF9Xs9FJv72etlJj7qsWVPzIoH+M0bur97b3gOwHNJ045U/I8kRP6+Aqh4se4wHoX4/QKw10VuOX37Tat0=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2495.namprd12.prod.outlook.com (2603:10b6:802:32::17)
 by SN1PR12MB2399.namprd12.prod.outlook.com (2603:10b6:802:2b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.29; Fri, 12 Feb
 2021 18:00:42 +0000
Received: from SN1PR12MB2495.namprd12.prod.outlook.com
 ([fe80::319c:4e6a:99f1:e451]) by SN1PR12MB2495.namprd12.prod.outlook.com
 ([fe80::319c:4e6a:99f1:e451%3]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 18:00:42 +0000
From:   Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Sudheesh.Mavila@amd.com,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Subject: [PATCH 0/4] Bug fixes to amd-xgbe driver
Date:   Fri, 12 Feb 2021 23:30:06 +0530
Message-Id: <20210212180010.221129-1-Shyam-sundar.S-k@amd.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.156.251]
X-ClientProxiedBy: MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::31) To SN1PR12MB2495.namprd12.prod.outlook.com
 (2603:10b6:802:32::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from jatayu.amd.com (165.204.156.251) by MAXPR01CA0089.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 18:00:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f0beb131-4559-4318-fd3c-08d8cf801d16
X-MS-TrafficTypeDiagnostic: SN1PR12MB2399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23991AC2546486E3B8D87F189A8B9@SN1PR12MB2399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zN2837pq/vWlXobLlEnQFE3LvQbxgu+Wb59EenRC+nO9ehGIt1fMsQ7IEedAjX9CFyab6h84HWr4nwbComPgire5aR8BXZyw6vrnE7VlbrHwa1/+PwHk/ObL5jSO4htvsN4u46Qw/M2loDtQQhWz9vZ54L6Uz9Ipcit8sHMRXPYAAO7HSiGy8CwyUe1g2XFRlUogpauXuYlEe/M4RwZavjfkqyWWCeU1Uqb4c8ZmlJFpDVZ/dvQs322DmMngUjzZgx4dgpDqkf+qsxDRBv0uJir0YDmm/jlQ8F/9+s2YD8HN8mJ+JoEZjMEFnKoNeUxPenoxyNVWcb3jp1GxkxXKK3rDIMEmrY4ZNOJ6XhqWqfqoBxzDJ1JPMjFC/WsW02xD4V88LlmfcX6XL4xK3dblU92qcjbMCpEgiF4Xbg+25iC35JbSYQBMqD2zNBzbQMcwOXRrYEdhkaoGsQSjS+1oGSX+mLZZy41wxtW6JCXgoMTOoMRE7TZ4ZIZFyOqsT2uondMAxAgksBw6DyVCiWJj6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2495.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(66476007)(66556008)(66946007)(956004)(2906002)(6486002)(36756003)(52116002)(4326008)(2616005)(4744005)(186003)(316002)(16526019)(110136005)(6666004)(26005)(86362001)(83380400001)(7696005)(5660300002)(1076003)(8936002)(8676002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dV/ja2ug1LzvxywP8sbfm+Y16VeACmZjY/TkPdfREVFqtA9LVhcQiMKvHsJp?=
 =?us-ascii?Q?fwpQIBBsUUgWlL15fQHGXaUQP1DkAUuM62zPdmZIUwqJN0qNfnI/Jm5Q3PAg?=
 =?us-ascii?Q?JjfWo2Fnq/hb/iqrWlzddlgKx0uO2d9by1N0cZzN2npV9fnP17Sx4+ikuuPI?=
 =?us-ascii?Q?AaNQuWWTvrjT++Q8ePu/4xBtF//7fu1VTH75PCUGPRL2mMDoeYwZskkJSjzM?=
 =?us-ascii?Q?12z7u4OLXBWzc6sx0KnkZbmn6ron8HQ3qsYPR7jummUhw1WaUcGona66xSar?=
 =?us-ascii?Q?18PWRnfe2Aw3bzFJP5S35Sj8KtZaozX53cDqZKVPct5l0jXH9QYShPwhSIeZ?=
 =?us-ascii?Q?vlhUkueanPFC7MzwS0yS89xEJSLNvB+zKL1EyIdPoUcS7hmdPOEJWfYCtHgX?=
 =?us-ascii?Q?VhavSrtLrXKoc63xdyL7LNWA/85antCGLpYxJ5LJVnjBSvBTLZd5/sX+9H0i?=
 =?us-ascii?Q?oF/aoP7msm+oEa6UR0kkC5Ysa0SWT66wbVJ8GtNE2RSxA4K8+BQXmZYtXWGt?=
 =?us-ascii?Q?99EUQyPAo06jQMrMvVcYT8VAuXikxe1uDKsH64UC9QeVZTFVVtt8X2qo2Lr1?=
 =?us-ascii?Q?DS7X6JKhcU36CcEpsqmwpJl9wihXNaRpcqk/2tuGYhlGmNnddmNN/b+IXomd?=
 =?us-ascii?Q?cPptaqPEiZrO1PpzhWwOPjpk1X6ncmlME4BCgNicNvsln/H9ezsDlbVprPJA?=
 =?us-ascii?Q?sH/VEvzYCPyUhll1oKDsrjarpDRAS01jEB/vNF67+glviXrje51eNkS4LZko?=
 =?us-ascii?Q?IbFR8I5qVar587m/cd5rpqm4oP07UtWcUSRMRFGwkKSpffTEaPTMXqMIN3s2?=
 =?us-ascii?Q?YZgPdoEx5gp6kkaGj28YaXuL104sGzWBrivKLTXA/Ij4c66rPrjy5inwEdYy?=
 =?us-ascii?Q?1N4EgLZO1d8BeTIsUS6HQ0PnZndu2VCeYrXlqRhaA7ofTiZe1f3xbdXSxU+3?=
 =?us-ascii?Q?hUGbo4czxLkIw63swNRfytVV2meC14Cj3rH7Pj7vjsOzhJiHRr8mEfFaIlHd?=
 =?us-ascii?Q?o7Evs/Xf8pyZJWJWfdaWFnPVCB7h0sv5zfNFEtanhp7S8UMbghzE1I+j+9H1?=
 =?us-ascii?Q?EzTRjVahaIhhlWrbum6ueXUAlRUEzku3j3Z/yHk/FZBAHubKq1GDkDZY6bre?=
 =?us-ascii?Q?gOaVNcDQCGEtPDJvaCdiIJdMXRk2h4xSb5+VjBDxFSkkMYRgCF37pe5ueiGE?=
 =?us-ascii?Q?PSajGP1nipD4tuOyuPnV9UvOtpAs4jALd6hmQhuKltvc7JnnMqv8+C5SXaT2?=
 =?us-ascii?Q?P0MtS40N68JLlT4bw5C7fb9gaEUVVMMuYfUHhBkGbW91fd/0yl5kCTG/O4H6?=
 =?us-ascii?Q?CsyTruVSQNez1Q7HpEd8McJPS9mr2okJSu55zh3xxIDU/Q=3D=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0beb131-4559-4318-fd3c-08d8cf801d16
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2495.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 18:00:42.7772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3V95arjWd8UUPniqZRgpXj7cwbrGqBDl9imaNLQRaiq1c7IMuTup5PyJQevtn7srr64ErLsdo4Q2I/KVUp1GNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

General fixes on amd-xgbe driver are addressed in this series, mostly
on the mailbox communication failures and improving the link stability
of the amd-xgbe device.

Shyam Sundar S K (4):
  amd-xgbe: Reset the PHY rx data path when mailbox command timeout
  amd-xgbe: Fix NETDEV WATCHDOG transmit queue timeout warning
  amd-xgbe: Reset link when the link never comes back
  amd-xgbe: Fix network fluctuations when using 1G BELFUSE SFP

 drivers/net/ethernet/amd/xgbe/xgbe-common.h | 13 +++++++
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c    |  1 +
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c   |  3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 39 ++++++++++++++++++++-
 4 files changed, 53 insertions(+), 3 deletions(-)

-- 
2.25.1

