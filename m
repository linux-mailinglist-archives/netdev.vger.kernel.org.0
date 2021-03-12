Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7559233954B
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:44:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhCLRo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:44:26 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:26322 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231597AbhCLRnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 12:43:52 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12CHag2q017839;
        Fri, 12 Mar 2021 12:43:49 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2053.outbound.protection.outlook.com [104.47.60.53])
        by mx0c-0054df01.pphosted.com with ESMTP id 375yymhjj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Mar 2021 12:43:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WPl/579lTGd9EmeA/VULCjGXNQIO0mfiXPsTQzBBa5RSoMoVrjJHCTK1nf/sQoL0dgx896SjMK5Mktl91Z1C4GSM5WUa7djmqIhnTal9wEVWQdIeMPR6Ji128SQH+x6vsmPyzDsfYN9jTh+SixEUkhKmVmYGIAzF3fMPnz0ApIdxd5aNGwt+cJMIDtynXOkkdUTzt6dFfHezAU6ni1g7H3wgXck2XUEgwlemG90buLiGrbQv8xlT6Kujc1OWQeRzOM/u7qTh3jNRsMPnntjpAfH+k95ezMORPiBB90nuUU43B/Ys6a009MmA2zUQ8PCRCsewGJE4INQaFP+V7FaHNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcQDzOcFnR1IZ9SI4lAbS/Azh2nsNpzVM2xy5h/T870=;
 b=HmdUUOuJ0K21K3qRjBg8yailn8muaMArcs+uwZRJrqngGeizcLTVt7gHVK4nUu29y3WATYnxp2hp9QnOIsknmfOghz/SaOhdFGyxLiWysM7JbTTElQB4e6k3LahNpnLviV7GlN8uVyIowjwY3Ibh6cKWOvyzY/V85efrY8isAt/carzDI/7lwjTudUDBH4xWLr1/5yJ2Uh4QOcgkSpNVDpdxuggBLcS3p+c63nCFQ4Y2ZH1PT4zSXph3QQTZPhma219ome3EOYm6jkKK44Y2JbADfO1FZWbJmBQW7rFTAnQIIZt61qulRZ185ygQYzIsv90snk3NlCtO1ikF8eawfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qcQDzOcFnR1IZ9SI4lAbS/Azh2nsNpzVM2xy5h/T870=;
 b=O9IwBJpoaWVEmalOn07GlPy7+FtCX6v9wZc+qcNJq1rpT0FdtUBGH1jDgUo1DXFb+a7b3vbyOcDvjapnzVU7j0TfIa31/kRnr4lz+JmrSHkbRZFYAOnHzlFndqlLm/nnnMLg0xN2d8ow/ekFtMjbS/R7kxdj0984IpNGrID+wCM=
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;xilinx.com; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YT1PR01MB4440.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:43::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.2; Fri, 12 Mar
 2021 17:43:48 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::90d4:4d5b:b4c2:fdeb%7]) with mapi id 15.20.3912.031; Fri, 12 Mar 2021
 17:43:48 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 0/2] axienet clock additions
Date:   Fri, 12 Mar 2021 11:43:24 -0600
Message-Id: <20210312174326.3885532-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM5PR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:3:ac::13) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM5PR21CA0003.namprd21.prod.outlook.com (2603:10b6:3:ac::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.3 via Frontend Transport; Fri, 12 Mar 2021 17:43:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d152e503-1b59-4273-6439-08d8e57e6445
X-MS-TrafficTypeDiagnostic: YT1PR01MB4440:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YT1PR01MB444038AE6FE3AFF10A979A48EC6F9@YT1PR01MB4440.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: loVv+7F+y6mOueupkd9XuCYmQ7iuNCLs4aKFfBudQT71eOHW0US//CmShkqa8GjTafAOd8rNAzIY5dL9eqdMkHje5ycBa0AaePTIIAfg0j+liv2WvA8TcphbJvdE0hhhhjTtKQO4GDk3MRd/gGcYHpgzpX4oL+mV1Xu9bzvcgcjzEBlSED6Y6G+i75/lPZxrxfy5QHAY6gq+O9HFKST5e4E8ylVl3PBcKcD9udaGYuokXT2UUgbAxbcEpnwz7acwEgNdWUNbeiO68+u5KXROqbkf9rpsDxpPnlRVtIQ9oinJ3+8WvYKkn5+lkeuEKYHDYyP2wHcjkLlEi4ceJ9hy6pzIYCp6OPg78WifkQO6jKaWjSD+Pyzhkvh/ir7yoXRJDfhJy965+9hcXcdDpeWFfC5/Yk/GW29ETK6d+wvS8kmm2fCMBO4g1dvGCHjMYSpimIkXp/xSPww/hpVeASumedv3fS88C3CBtpN42yRnMsEq1ePviV6V2mMTXzxyStUTtJ0eJoNOEaZXu3uhnSRzXhj8NgwXOEk5I1tizG92Tbx66GcQK5uerCCL3xf+DSQK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(376002)(366004)(396003)(8936002)(26005)(2616005)(8676002)(16526019)(107886003)(44832011)(4326008)(4744005)(36756003)(956004)(186003)(83380400001)(2906002)(6486002)(69590400012)(5660300002)(6666004)(316002)(478600001)(6512007)(66946007)(86362001)(66476007)(66556008)(52116002)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3ZqOhwnXfEVwV16XYih5Fdn4kpN4NjgX4viLJrbhraAy3YtLhCWAD3d+8edc?=
 =?us-ascii?Q?Zv+SZ+EHg+vWS2GCdfAda0Y51L5QlGJvdeovzV7w0tpumKXItZxrc4ofh3t9?=
 =?us-ascii?Q?Lhpnl9wxcUgJ/KsiE5YQG8+71ssX0aScteM1z9vAFHauzlSoCjvxcQDTx/qj?=
 =?us-ascii?Q?KoZMmTXrgMazWdqTDtDPczYVHiZEVy2bJD/lN1mgE/k79NCvEITF6vg8TpZH?=
 =?us-ascii?Q?HDQOz3do/Z0OtsjpX8ls2PolKDEcrwSsoByfC63MEafhnZtjDqIBjEyTHe7T?=
 =?us-ascii?Q?flXiBRugMCcm3qzJMR9qOBKgE0X/+fo2L0HgB7TfTslNz0vIwSDwekYf41YP?=
 =?us-ascii?Q?LoYsf52f8Dpn9LxP98gNVF39IF/8CJhHRbblnngOZ97PPxjbV9ujQaZxO1rk?=
 =?us-ascii?Q?EMGuxdavWL1b+5boRiMyC+FbplAuJtE7SuQVeiBjhqGsDedfL4XLCL5hJoSQ?=
 =?us-ascii?Q?rmmKnM8d2LVVOubgIWwSCHec5Qw4hDVy9N4qo/ytWluls4/eyOzXJu8XjLhp?=
 =?us-ascii?Q?1lNTwfF7kspE3jk/o4uG9FBjWGolW/eQ/wLwhXW1UFNHfMy2vGmDC7iROhkv?=
 =?us-ascii?Q?xZ9ar6NKQkbVwxdRHgGgsIjdxSrUf7obj9L8Nrg3bSyhgrnrsWJY1do/fbQ9?=
 =?us-ascii?Q?Sq1otQX6pHAT13/BEAFGoJZ9tJNDZKe7Rlvz2JLr7o8OYw7Dzsgmrb4kyNhA?=
 =?us-ascii?Q?BmyBlcLsgrZ/6OagOQ9A4ovgQpphUOstHDvlS3aZoc+kf7D8APLpTFE0uSC/?=
 =?us-ascii?Q?CLH+7raJiVKI3LCkt4NcKlVP68tbbEDOR4Hpu7ROCxUnkbPUqWgTLGnzPSSf?=
 =?us-ascii?Q?yjm+SfxrkXPVjxEbCDEsci9lF0caD+hbRhcHlf674J37vOSWjLGIhUv7vNn8?=
 =?us-ascii?Q?IYyfGkegkgJSZIoefOSGgn1EbqMLsAso/+rNh85cz53YgyVb9oxFS1DYfCj2?=
 =?us-ascii?Q?3tpAmmHSjcaGnJ12gnzn2BExRRklh8qr9kcp1VccbkB7QEbPnE6XaAjqanif?=
 =?us-ascii?Q?Be1SABbwXuu4djFLS7JrznxKf4rGgsCsMtZGtPzTlmQW+hdKOJblinTFa9xI?=
 =?us-ascii?Q?3MEK9FKdEoaUtMajHUtuTCuDjXPj63cRyai/Ps00DuNtb5RSWgM2gm7cxylZ?=
 =?us-ascii?Q?1K8hCn+/Gn7jlAw43VTANyJ6nj3Go9wRZoCFEhh+lSWmKrkWGTP6GcRw4zCU?=
 =?us-ascii?Q?eq+I/OjwSN3oz+o9N6pEssR5YDmzy4ZOYpwSNQi8YLQiu1ZerEkbGcQLbNIb?=
 =?us-ascii?Q?2UDJlmfUhOG1YQbx/IWIr56r19EMoeNr+mtepAfqDgICu7sl2EgiUYVhNXyi?=
 =?us-ascii?Q?wp+UnZTMJg+k4jUQ7ER1HEmO?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d152e503-1b59-4273-6439-08d8e57e6445
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 17:43:48.5943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BAgmYUrdGRfNuY8ipOubHzAvn7TGecSTaw3EJApqyzEtXsj4RRyzD4hKAgkfzBrvw6Q47bY56DSbigplT9mX3v/7cuL6SUMIrN0lNeFQbV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB4440
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-12_06:2021-03-12,2021-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 suspectscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 mlxlogscore=920 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103120129
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to the axienet driver for controlling all of the clocks that
the logic core may utilize.

Note this patch set is dependent on "net: axienet: Fix probe error cleanup"
which has been submitted for the net tree.

Changed since v1:
-Clarified clock usages in documentation and code comments

Robert Hancock (2):
  dt-bindings: net: xilinx_axienet: Document additional clocks
  net: axienet: Enable more clocks

 .../bindings/net/xilinx_axienet.txt           | 25 ++++++++++----
 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  8 +++--
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 34 +++++++++++++++----
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c |  4 +--
 4 files changed, 54 insertions(+), 17 deletions(-)

-- 
2.27.0

