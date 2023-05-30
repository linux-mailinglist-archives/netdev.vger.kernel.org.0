Return-Path: <netdev+bounces-6376-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AA53716069
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:48:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C5F61C208FD
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9201919915;
	Tue, 30 May 2023 12:48:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F30217745
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:48:33 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34181123;
	Tue, 30 May 2023 05:47:59 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34U7tbH2023706;
	Tue, 30 May 2023 12:47:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=7jbA3HsUuLrBRFjF7xfDRoGhOH8VBKQqEJYeB9Y76P4=;
 b=QXGhYFkZqjrb6OIgt49H0jiD6NKA9IB4Yl7ZMTT2kiJtJ6jDKIyFj1Z4uz71ZmysCmRd
 utnrnrgXwr/lCVvEYy9++iKlA7k+eooAGJV8hFVMuC+9r2jpULXRunPI/YbmrBdij+Dc
 XnFb0KHQ/OcnxvaZJQxror79dQrQUOCycQnCqNQbTxcQwrd1n2l348YdR24Q4qYjRNY+
 a0dEZD+MsZab++1F4d7JKG4C6ifQJpOiZvwjoyMm4jdENrDlaZqKt/DvsTME0gQ6DWfG
 z1BOrVCxJsuk75JAtpsV+3H3fofraZMB05wGgtt9aKZAYOlzVvhJgRC97J5V6iZzzHOY IQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qu730tm41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 12:47:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqguRR8wlrNGW4tbsdfcgUhxZAOZ2/KFEThvw9C8D8khw47UVJLS8F6YlOO8IjDSBQZ1mNfeTD+9t5Xoy005LN1ynzrOHWYfARZYUg5IDBOZ9K0gnUBj4na3AKDh3mf1AlyReszFW49gpvQpqw/dvnzxlnZrZEp7V+WFL1ZONJzJjUf3AsV/4zMDdxdE/LdMZe+ia+JB55PoB1TmA4a8E7Mh32YWlqMfKKZqOHnsI+A1KxmRtj78h7sCJ2TcRZ+hbM1ofeyrM1gb5FZwVFMiwhVOX/ZYFdmgJOxfmz+xHbN5ANQSAaICveQwosp7NBdETduOIa3I4wgU+97RlW02TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7jbA3HsUuLrBRFjF7xfDRoGhOH8VBKQqEJYeB9Y76P4=;
 b=C9KADfZcLOW5a0B+PnkHsJkekyQs8+PnFsg4ZDMNwkJ1HN8+y2i6tHfd7FhJ80MkEVkJLXOVZCJZKFLox7daYxTjVukSQW6O//zPSOmFDYO0OcymCUqX95JlXWVjekL/qjdwcDBMD9nOcCZtH0pX1Y1gU32y63Z5nZkyOwMeT75b23Mpi35/TNd54nPS/cJltZL4CVI/ABwa8KeNQ4ljLYZ3xXqBzotV77Ij9jGuUYg+9oTLW/vqZQJU6wkjSNjiB9bsvs1TzhJZArXon8CsYgFEXByb9wUai4snKDqkSBrCY9ikkQ7qxqgv9itMKnxhAUknvwYVggNslOrFYPKl6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by DS7PR11MB7835.namprd11.prod.outlook.com (2603:10b6:8:db::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 12:47:28 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:47:28 +0000
From: Dragos-Marian Panait <dragos.panait@windriver.com>
To: stable@vger.kernel.org
Cc: Ruihan Li <lrh2000@pku.edu.cn>, Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5.4 0/1] Hardening against CVE-2023-2002
Date: Tue, 30 May 2023 15:47:14 +0300
Message-Id: <20230530124715.248505-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0036.eurprd03.prod.outlook.com
 (2603:10a6:803:118::25) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|DS7PR11MB7835:EE_
X-MS-Office365-Filtering-Correlation-Id: 2607c4df-4108-4602-6fb3-08db610c0673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qTrUfNiLzTu9P00qNOp9BJLxR1m2TKbSVR9OgO5tOfpFyPbUIpuWxr7uTxYOc/S74FaX3z7WSNCW5R4pbDO2oEod5ybD1kGPBZ7Ksuj1NogArzdkmvPTpcE2L2RmmbxguqygildQGihe9MR/jXYqJ6XV+N36m+7Aj5ElQQ1fH165NB8vjjndZ8fZzxnYuq3mDkDP1tmb+Lwq6c3kARwwuiztFjUpE8u+AgjWHeOcs2qxfDBOTVzEeSgRo/XcOdzGGHQMpnXG2DK2sERAQmZX3iCgH+WawBSQCnCwJsXoEOcamo4bgWf4qUtCRmRt1fJ5nlGqy+YQNZUn6aJZeh8SqfgNqD6to5snXqYWPjLBpAfCPae++L6sRIahXmYMYCqdF3GQ8FxsGnuDmE+Q9V+dtBJR1+0RvawlGZH9Uw+QmA6RLmw29MSSf8HSSg8JQm27qwJxeKQ2rAoK78GmfRyHghxuGnMjThXN2xK9XvFAO2/lBr92owHw2DyKZTNC69V9TZ7X5tRVldyrYE1r5nFXOmKTkPj41cp2zDqCso0tBqm6z5oyv94sLuyzuzAW8a/JOe7adcLxISyDVktLyig/nz8VMJHp3rYfdMuVL8BrbdM=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(136003)(396003)(39850400004)(451199021)(41300700001)(6486002)(52116002)(5660300002)(186003)(6666004)(8936002)(8676002)(36756003)(38100700002)(6506007)(6512007)(1076003)(966005)(26005)(38350700002)(4326008)(6916009)(66476007)(66556008)(316002)(66946007)(2906002)(4744005)(54906003)(478600001)(7416002)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?S2vPxWgBbtSBqzYTRP4PXq72EtqJ31lgyFtfRr6bsnnOC85VAQJTyqJmxnUj?=
 =?us-ascii?Q?mv6Mbwjt/WpZZXf5btSVoie1wUX08+JonHmIGFphxwuCEffyy63WdjF1ihZ3?=
 =?us-ascii?Q?5VaeOdCtzX9wPWkptGCOZahrhC980kjSY27uXgdX3ksx3af7tHDK9BvIJ/+r?=
 =?us-ascii?Q?otIZ1qJ1789O8X/O0GcrhLGFN7nZp+2AjaKn1WP3hybu5P9mxO/W1nSir129?=
 =?us-ascii?Q?XSfG7v2MRuQ8JWhsWYAEPE95xuce6tst1j2utKSAi0dHcmXIKO1uVjAwZhxc?=
 =?us-ascii?Q?WoyJ7ovZQKwQjbtXxWfvwt1Msl+HtAUo0S3dDDJgf0snXyOq0vZ1gmJRU9Ik?=
 =?us-ascii?Q?Dperm07/KDakOkWNGHhBkoi1eHacjQ835W6dC37wuyGNiQVSxcmCvgcSAhHi?=
 =?us-ascii?Q?HNrh2qS76uO4za3dS7F9jaF0cRgqZJP3OiCr+JUUYthJZB8LjmLDsL86v3R3?=
 =?us-ascii?Q?PHX0KIvM3ALaFwBNaQjQZSkBHmygMnFS4sTyVFobUHd24uPGock130NLlwbx?=
 =?us-ascii?Q?eUl2i+xlFF/CUf0dfSQ/AfEXNhIFWnr4BqRbrOYloRRACq5RrIWOVxWZsYze?=
 =?us-ascii?Q?x7xX4FKXXQwNAbNmdTt9UCr3ZI+jVB5H9omNlxPUboWC830bMt16+f5qF2X5?=
 =?us-ascii?Q?PESkvk4eZSfUSi7rgW0z7bWA2NKlMGBFYi3c/M5tTPGEZQ7yiCMltH1soa3b?=
 =?us-ascii?Q?0DMLs1n0MN5BS7sGlW4ii6BiYz8FMf6B8JGL7BBxooVosNcMn2uAEFNUj7qg?=
 =?us-ascii?Q?7nk0C/ocmCY2ZEDab7T8wraPqJxFMtFJJZ7vefroRfL/IGlcd5vVSJO4P+pU?=
 =?us-ascii?Q?rD6Z/HLUhAtxNzsfG4DS2rpR3BSCNyUX8R6oTwXjkN6rxFUgVHzT69H+lwQn?=
 =?us-ascii?Q?eJi6pOqL8LP51BbX/5/GGWBPTwMGDI8cFERt8YBzP3BUVhr4njJPOh7Rvi/T?=
 =?us-ascii?Q?ZJCQUir1rUPMUOibkNWgjwenScA/vcq1xA+EolpiOE3Cv7tFwuhNVNAVsoNc?=
 =?us-ascii?Q?1LBk9rA8SA5lzfVWlZxeeWdeuAVNE19i8KibUY6aWXtkbAYjq+G9IfwdYhcQ?=
 =?us-ascii?Q?gzsuF0ihxv7pbLzL2aNZHAwPhwXduqr8zH6LJV1AjeEVdOyY4dNjXTdjxDNC?=
 =?us-ascii?Q?jVEVfQ7ABawsHQ0f12PVZfh9r4MuqoJNRABmk81VmRDKki4c6eSsqrPFQ/hM?=
 =?us-ascii?Q?dRTC9nIRhecRGBxQcQMxHpY64b6QvbQCuUkioysIAy3vkE8FS/5UfbgQZ60L?=
 =?us-ascii?Q?PFapiOXDg78jGS4Xc8DH3dSSBC/eTxni6J7/ypYqC2zPy/+4qqyXXRJTRhr+?=
 =?us-ascii?Q?0QNkMnwp4mHmxF9rqbjkPyvH8OxXy91mDZ4RujVNy0CjN3P+yVf3G4EqdlyH?=
 =?us-ascii?Q?agzeUyHZAkuB+G466tAnZJsO/oFLjsvPSYv05/bR2W+AExdftXTf7DepNSd7?=
 =?us-ascii?Q?tUfLDx/1Fii5ljdWqCQvIBnDj30FoImyadqukZ5gPgPA6TbEUXcO9SIKkTBO?=
 =?us-ascii?Q?8w9b1uqSmRjSXFlIb7BFPvwZBF5PXf52Vlm5yYWk6n1007ek2rSWFlezbqo/?=
 =?us-ascii?Q?b8cS4rbmVWLNCswRW8kVwSg19QU2MXsCPAyAcV22/zxVv5D6ykKlFamvGzAJ?=
 =?us-ascii?Q?7g=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2607c4df-4108-4602-6fb3-08db610c0673
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:47:28.2004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yoUcukSFTB3iv899739ok++jqzZxCV+mIRxf7aZfS44knjctY5ehZn/l/lShcYdVjEVIPWEkYLcsgx7E7X2gxdQgbEE4cLnPk4YWAvJJ39Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7835
X-Proofpoint-GUID: YyPafowxtXHPuE_O5HHBMmGwWapCW-bn
X-Proofpoint-ORIG-GUID: YyPafowxtXHPuE_O5HHBMmGwWapCW-bn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_09,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 mlxlogscore=602 clxscore=1015 priorityscore=1501 spamscore=0
 lowpriorityscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300104
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The following commit is needed to harden against CVE-2023-2002:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=000c2fa2c144c499c881a101819cf1936a1f7cf2

Ruihan Li (1):
  bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()

 net/bluetooth/hci_sock.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)


base-commit: f53660ec669f60c772fdf7d75d1c24d288547cee
-- 
2.40.1


