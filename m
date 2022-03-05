Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2034CE23A
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 03:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbiCEC0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 21:26:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiCEC0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 21:26:06 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83DA22B959
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 18:25:16 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22524FEi004428;
        Fri, 4 Mar 2022 21:24:57 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8qgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 21:24:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or8iKaxTh880tipjEOqKOq/r/pteniZTdMYBvNc2d65gOAwyhNtnDxIuv1DHGle3Yw8XlI6ryMHGJXzusjBvJ5x/9/j0acMVBXBQBMlLo+Rf0Zxo50KFmVD74msE6CjuVJhMwarrL5UUGghw+zxbJlWL6vkE+VTUedAf+3giO2aJVSpsxe+SKmaSwHrdzRR/5tieg4VRHo2u/KzED1LtZxwA10M3mJJ7G1jQTqBgJx5lN8YdcCF/LiJTAvp+xYPw3Y8/YcIqiB+i80r1MVtxqxI0mVZOoVnxobFY4Dv6Q5xm/gThQUnsXWlz5yVp2tUlt9F5dQMTVYd4735Me8NVkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c2vUB5oGrTbxXTYEnA724ecAYb7WcwoB7YOZ/ekHZZI=;
 b=PHg5/j4lmrnJhrcCwr09gcRudbrxCGykJrxFEGmEIjQxSQiBr6rHTKJcBprHZ4srn1k1XD2+bucjwWg61B+bOoSKJUnE5p3ejwfG8INpC4t06GDFpEljHjVaEpInIpwRF1jEmobcwCebHc5NoFgtSUtI6ZG2yyqgKlaumriRvWvN4R8JnA0jChGNW9cNppgx3YUeg7Zz75KWJFruDz4vcCTZyIvH8vevBUcy/sr76NxQVkKuoqKduC7ZJVkfZUQGhkJ7fMuR8fd7RjiVg1MeOMFXCLj6FeK0ic2fnQ2J/anRMVZrkDLe0Ef6cMPto1Kg2SnH9Muv/4F+bMLdi3Ij+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c2vUB5oGrTbxXTYEnA724ecAYb7WcwoB7YOZ/ekHZZI=;
 b=2Goc2ieFJswuEtaAiYSVcoE7XNDmZtBuizk+4d3xMP7HAZ5eYW7EYl7eMgM5cNDN5nN7ExvvUkoIQH0BpfAVuNgBYXsamq1Xuz/NOBXy6QYksVhmGSwCwnFHbVv37pSCCZznOSntE21MZ8tsyTWgqblZb1Wkh+w8h4pRwXrrgj8=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (10.167.1.243) by
 YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM (10.255.47.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Sat, 5 Mar 2022 02:24:55 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Sat, 5 Mar 2022
 02:24:55 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        daniel@iogearbox.net, linux-arm-kernel@lists.infradead.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 0/7] NAPI/GRO support for axienet driver
Date:   Fri,  4 Mar 2022 20:24:36 -0600
Message-Id: <20220305022443.2708763-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75cc9e1b-56fe-432e-4f8a-08d9fe4f55f8
X-MS-TrafficTypeDiagnostic: YTBPR01MB3184:EE_
X-Microsoft-Antispam-PRVS: <YTBPR01MB3184F5D19F63A3E742C6E578EC069@YTBPR01MB3184.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qMNJzKbY5n8NfLKg8Mh+n7h2u0Qfd22Bgfz5h/E+IgPbCu9lqgaElyHcQgeVd/g93XBD21gumwFT+V7SlM8gqfUi7orpjW/X8xuL6svkoVXXmE9HXfHT7joXwfqD1O+ic0tPjPa23o05YaB3bKEhkJTZSkwWGVYmmYoaDV/7L40zwjv+LK8hYeQNISr7DDmJAhx4/iNJSBo9happDKEbH0wy+/PVHycMi7UqHOeC4SdWjc/grmwm6g55KnPgqBhG99eEgOWmJQEiwx74WTvWXr/Fl4ZoF5Z17Z0fP/exke6V+cJsjcvPGKRtsTbPvS3yp9cx7tPiAKkSxjDkC+GsqYzYzFOZujopN6udfNGQsgGfjGPK7RX/IJGCBbWF/nSz5noV6Fr8ElCfywSMUzFh1FJ62L3zttvZsTF1o0h2HEsXbuaQi0ke5xnifturSSaAPojYADQtI3AYML7FIMIp1bXLQW4lN0LB93EsRCKhHA3S5K5hKhNvp/9HSb08GUnAglJhvPacOg73pTWVTRvjvDxQPGc05C38b68LNhNQe0jENYbAGrnwvLfzAYTd5LiHR732cvw1OaBJCML/zTjoYvj27GxJEH61OVYn8gwUNiYwoT41cMJQ5zHI6ipkTeYvd1bjRHJ0XZa8gJ7Gg1tYca5y8+ELrOw+Axrb6RZwwJpLyEGKjyvLfc/LwzfjKugK7rMKsIRN/CJZke+9hScKvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(2906002)(107886003)(5660300002)(26005)(186003)(83380400001)(6916009)(4326008)(2616005)(1076003)(8936002)(44832011)(4744005)(6486002)(38350700002)(38100700002)(508600001)(86362001)(316002)(6666004)(52116002)(8676002)(66556008)(66476007)(66946007)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yieK3KigbNP/V1L5y4WB2fI9IdhWsTXGixqykg1ulDzDUhjGDIaPWStxc7vE?=
 =?us-ascii?Q?jlIL0MX0Qnx6z6V2GrHOGX9g6MTjey/2r28DmSKJKNAFycl9xccR/7DNvv8P?=
 =?us-ascii?Q?t+hGdHxdSvOzy8v0bu+QQ0OA2AorqQIPv/vAfBXhdgRp5a4Rv+sNMSK6rS15?=
 =?us-ascii?Q?YodCvJ212OxfzmPfc7JZ/OwthK2iqSfLPTf50j81h7ul1G1/s2jEbPLWjYrt?=
 =?us-ascii?Q?b1dGBGdV76tIL0dJ1QPrfXSUdMqG5TrU17K7CZPjnMCSMNsIBZJrc82PLSZ8?=
 =?us-ascii?Q?6sXTqvFfQ8MnrGW/F9aMXpg4cAGjjVI/N5dfw391L9LB3iVK4QQ8elxVCfP7?=
 =?us-ascii?Q?iQRZ8a2Flv0W/VnXvHCe3yD39QkwjTZPs0583qwxH4mR1YvX6yhWtikvZHm+?=
 =?us-ascii?Q?q3sXWvrwQ5LiF8EqmIaHgHoMkjOV9VY1ZoPMkGTdKG2KayFfZClyofMtXpxa?=
 =?us-ascii?Q?G7JdW554CytE+xQcmpBi7i86GQAQjQUP+6CQC9mkmQpqKpxjyXbvBl1TPQ1R?=
 =?us-ascii?Q?yW2FM/Xmw7q2pvZSIQyDbaW4m697glcVOmWRBI4UjXRoMpXYEygIumZ0WrBR?=
 =?us-ascii?Q?c3zaIXf+ltPsPTK3I8F6agZsjUo14o7T9WcZNTNv3aMSuWFZn4Xu4EPFptHU?=
 =?us-ascii?Q?GLoLwAlzYQIENijhjhn+xeM/kgFO53RiMm57dYOqevSX30Gd7Sr3INxgl/6o?=
 =?us-ascii?Q?lsPDmZTIuttV8oSkwPNxnPmIh3RMqw10eCmGNiVXIHcEG5s/j2haMvVG8Taq?=
 =?us-ascii?Q?zMhHxh8MfGssfi4Vu3eRXkmVbbBDg6/WHZWrBGir3P4I1fTUTDe7IhEjqYWr?=
 =?us-ascii?Q?vD9TlM+MDe90qMzKYIGdkJJduliEKsK07chMxbYWQG1fhk+/6jJRCtdM7F26?=
 =?us-ascii?Q?0XadySobnSIRJIkrPVrLM6NLu8QYDdqjdLHEehb/sa4Ia9jynKyiUxwGgcyu?=
 =?us-ascii?Q?p0pn71daNY1HqC6V1u2mb+ddjufQhBCEuhBBMqDkArwmo4Wv7CQJGZjGMbOc?=
 =?us-ascii?Q?cQ8aGrWWKaX3LLGby1gB8uE6u+IlWKO+f8T5/o7IVyetOeahZD9nDGQQfOTg?=
 =?us-ascii?Q?Jlv+R9z1XX2ovcxEqrILJuYPBQBaW+wxlOJj0GtGrBEROuqf7VKcgrCKDb/n?=
 =?us-ascii?Q?Ud0brkGKUU/pZ2dYV4g9ZfZjSRefLXrG38fPZ9n/7gplGE+d/XnIG3nCLkkg?=
 =?us-ascii?Q?mMsEGSU0iE3oaTBTh7bcDU1airyf9cv7jtqt14mfggATdUyjLqxE4pf1t8Y3?=
 =?us-ascii?Q?YLQypZ+rP9oUHSpNqfLjkXLVPBAENAS7Q4WaLwmRWv3xLXxL1ie8m2IIrG6n?=
 =?us-ascii?Q?zhZK3oXa2OfGUKr54ZfNWJVIweiiTmgg3STaYq6C48LTBFc4ycLcenEiPDXN?=
 =?us-ascii?Q?BtIUOBAFstofi3mQ6jWiXDjS5iz4XNbgWnwHNfDB2vzn1OelTjCv2fJYsyuC?=
 =?us-ascii?Q?35+a5HhC/tfYk1D9wpPPJ+vY4ZlFTMRoFFEB0Z0BSN5NAEVnV45ZLe6VHO7Q?=
 =?us-ascii?Q?wyCsOsUNpMl5lNRxfYgMmjTIZty9l89PQoxTSGDrgIqRvLjXn36asE6YdWC/?=
 =?us-ascii?Q?KKqdNmkvYQAGjykrT/6+g4WrrTdKUSk6HMSO+K70nSL7zAe82d/eP8derPyJ?=
 =?us-ascii?Q?/COXWAZyYfGDlkFr4GQLCNM8rOt6Kb5Fz8cvTuApsUTSKZ5zBxMzgfoGxiE0?=
 =?us-ascii?Q?emZau/3fVc4c9WqKTLHqAl2ncJ8=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75cc9e1b-56fe-432e-4f8a-08d9fe4f55f8
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2022 02:24:54.9732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /nncPvDjJCOe0q5ECNuc5NSsNxi6x63owisqwkwdTZB55NEHXFlxfVDggiwh4b+UDVa2CCLpHnGzq92S6l7/IxC7E8dV1HxsFPBSxQmx5f8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTBPR01MB3184
X-Proofpoint-ORIG-GUID: xRjpaFfOt7-m1K_gN_XnMncuR3fo3hMB
X-Proofpoint-GUID: xRjpaFfOt7-m1K_gN_XnMncuR3fo3hMB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 mlxlogscore=711 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203050007
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for NAPI and GRO receive in the Xilinx AXI Ethernet driver,
and some other related cleanups.

Changes since v2:
-fix undocumented members in axienet_local struct

Changes since v1:
-fix 32-bit ARM compile error
-fix undocumented function parameter

Robert Hancock (7):
  net: axienet: fix RX ring refill allocation failure handling
  net: axienet: Clean up device used for DMA calls
  net: axienet: Clean up DMA start/stop and error handling
  net: axienet: don't set IRQ timer when IRQ delay not used
  net: axienet: implement NAPI and GRO receive
  net: axienet: reduce default RX interrupt threshold to 1
  net: axienet: add coalesce timer ethtool configuration

 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  18 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 498 +++++++++---------
 2 files changed, 266 insertions(+), 250 deletions(-)

-- 
2.31.1

