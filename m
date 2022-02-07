Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F344AB6C7
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 09:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243791AbiBGIbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 03:31:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240388AbiBGIZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 03:25:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09368C043185;
        Mon,  7 Feb 2022 00:25:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2178EwQH011697;
        Mon, 7 Feb 2022 08:24:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=TgGJxtlyVN9YZ2AXuaeLhgvrEFZT3k4314+VywTXaOw=;
 b=wAz2GFUDouvggKCMyVXaAkjHExetFjhjAsK9bK6CV7tm0D0gwpLQmJ4EhMWamKkUKqPB
 qMgrKFcOS08MPe+nLqzk0LEodZ7oJiPyAMIi+N+tSQM49bpk9r1T0wjq4Zgftk9JtHGc
 RSV7SY+nVjwqCxNKRsYrgrYyOFlXB9zXP6harLGFQvCUESKGe/hj4jRgbo/3inS/kOFX
 3OkHxZdmv9QfP+O0BbS/rtAJKd2fQ1Z2t89CAp5lSP32vR4Xeoq69hRUq3Y2fp2de603
 0Q3KbsHq1crrVJrwHLjQyPHVlPC4n5IuYjcTICbBRdNnR4YOekkORQ8ZkyhorMgChPWS 2Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e1hsu5c6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 08:24:55 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2178FTsi066813;
        Mon, 7 Feb 2022 08:24:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by aserp3020.oracle.com with ESMTP id 3e1h23yhw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Feb 2022 08:24:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=alCSF7sy14XYO6leNWJQWzJTlzxKZPbHJfgxqCL5fzz6kVM/WeJujS0wlnHxnXZUKcYeMmXNPbpLnhJqXiVYfFZ11zBzmYJzlEnYdSjJXnIuA6ixSt1sMz91V8e/p++FHC/Y6IfM1H+SEM59CLJ9aP31YerLFlTp2x9w0jQd2towxcLKxWOA634ZXshqEyv0z5RrbeJyTCWh1e/P7yMLIJst7UB8DFt4Q78Szf2ztm20O1Csg8eqUMIBMo+hiPIdL6pBrUYMeF648hfTEgEMdoKuKLwGbaebITd5y5pkcJx+MQ8VS/75Xcb70NJSYURfc3RNO7utkTTlULwnAA0fMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TgGJxtlyVN9YZ2AXuaeLhgvrEFZT3k4314+VywTXaOw=;
 b=YvaKjmtjUrpTGt1a/CKVSuHbGALsHsjsxW2kvTGxj4lzsG6hBldzoJz9umujOAKMqAoz6dT+5UE8Qvur0WE2PYAV4x+pPzZceM9fyKDsCW9gGweNW544LSrRDYRZCQBffMeuvlfLHKwppWJFap875BI8rrgxpoI44/u9jMVnX6dFuXDYOoWp4nucaI8dncpMC5mD4CkHLrDUCNyuSa3GCK9QtNzkPvMZZRY9AOTfqt50dtCZlbwLGig840d1v0mAy53X0AgODUuxTlCbV7aI/NT1MLwZA/x3JjcDasY26fTKx5L+je72Ei1H7wg0eU5uSalJLIU1ktDiQ2n/M71Q0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgGJxtlyVN9YZ2AXuaeLhgvrEFZT3k4314+VywTXaOw=;
 b=vxH2xjCvByYCb/+eMvoMMbwzMqA0Z6fXF4qKMOJ5ZRPy6+G7CNzsQGvttQDkJ1AECMQW6+W5GAq5sQcWITTP/n88163jMwblvkQ57GbWyD9Bh7mi4EulYF+0cpCmRxW2DS6tGhudOWWyHCRceUeEyyY1E8idSEX41Q4gzsbAfJc=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH0PR10MB4986.namprd10.prod.outlook.com
 (2603:10b6:610:c7::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Mon, 7 Feb
 2022 08:24:52 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 08:24:52 +0000
Date:   Mon, 7 Feb 2022 11:24:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 2/2 net-next] net: dsa: mv88e6xxx: Unlock on error in
 mv88e6xxx_port_bridge_join()
Message-ID: <20220207082439.GB28514@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207082253.GA28514@kili>
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0056.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::7) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52cf6b9f-feb8-441d-ea34-08d9ea135064
X-MS-TrafficTypeDiagnostic: CH0PR10MB4986:EE_
X-Microsoft-Antispam-PRVS: <CH0PR10MB4986ED6C1D6C1B7287A221F28E2C9@CH0PR10MB4986.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:88;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hbtww/kbBd9Fqk54zTipdPH2Xl3YPnZvODgkkxNerAz14+5MQlcB+OEFcroTYw74jLQlk198w4qsumQkKdOuFmf3m0v+PiKavmxkXOc1Os8k2QYU6l4DOjiKtp4SrJMDWOLuQ5A1kHzl1Vky2N469EGZfAWpgrzFLldGCBRFnTsTw6Za8XcjmLYzAVJic4JKU5e7sP4jJX85dhUeqXBhENnP4mpANv4StHhosm+DEWX7HyJcySpZmnZ4A5ioQVLU3UxepP9HqROGQEsN/8sutFY6sbdWINT9NbedAW8Q9qty/r9c1YXeW6ZCk2vKstqlKTISc/37kZi0gv4CzqImaJDaao1uTLXoTDi3J/UDrqMBKfoG/sr9+nK6QvVzbcRRbi68JqWdBS8uV9hhojo8SbY2zFsAwGtWsOqLDHVqpZJTYEm667K9nS1sSsRVh/2e8P51SEfiI8nKLsVmjby5jJDb8F9nPHToJs/uYAUOES5VgDkb7vxfjFKDYV3H2z5adA00g6oXwccqaBL+tginfRxyrSsD3k/KuBrnPtoo8e8rhkCn5GZT8EIdfVtx1Mrd+rHUMhCy+Auh+wsb1n5VmRAw67Kexbd6QsXpLIiTtgCN/U8P/iFDxNK8qQkNiLFyHpDmYTu6IDnj+Z9fkFGpziN3LFijt+V9gytlivprxkTGdblbguvNkZyW0HzDOMTz94BXfMb7OvZ5+kQfjJa3xQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(33716001)(8936002)(4744005)(4326008)(33656002)(66946007)(66476007)(8676002)(66556008)(110136005)(54906003)(316002)(508600001)(6512007)(9686003)(7416002)(44832011)(5660300002)(52116002)(6506007)(6486002)(6666004)(2906002)(1076003)(186003)(26005)(38350700002)(38100700002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u6lgiin1F2gIBDJbQ7V/zKReyrvPWtDgpTYdoB8vXO9R9djidAJZdjxDJilN?=
 =?us-ascii?Q?yqGrE6lQn6JuFIp1v7oYKfl/JxDPaN9xOLfxLCesXdhX2V8VqDK0cOydZvMh?=
 =?us-ascii?Q?/aPmo4YQvnkMwdt+whRVPBKV5pVF1T+43fXn+VlYNOHJkG58AMsUnYlJ4NNO?=
 =?us-ascii?Q?SyHaWpUBMHmJ8XEpbWMUsxYKSx7dt7fJhryOh/fGyuAavqZY1kEvqabJu8ht?=
 =?us-ascii?Q?B58NXDjfpeRN9AA6ZA6OlcNS5znoPNRDPbDObH24gtf3bmrfyGaQJEldtCAO?=
 =?us-ascii?Q?OoFzFaYFGL8X8Js/h9MRYj3SlgOBlfJz7GqvS9E/N34X6XY9Qzvr+Ci7x+mp?=
 =?us-ascii?Q?TJz6Is2/YYfJE+o8Cj9DPKntbu9gm31YPfGuflYRQARs8JmRRFkicf//uV6V?=
 =?us-ascii?Q?HylEEwVEloTz07MS1+PnYGWtwqx5CNQDg+9jn8O3+8exmE5YkPJ8VHvAk8iu?=
 =?us-ascii?Q?h5PEhA1YCeillvyZ/tIB/B1EG6LBm2uYHy+ra4R32ZlweREja4ICZFY+5K7y?=
 =?us-ascii?Q?uiZifVHyUBWjTc4lAhcmySTPO47a/cSTeY0hYFESX/8cuPiysahgmCx3nSwf?=
 =?us-ascii?Q?mhK1dbzZ1fyAkUgsWGVTrcxbw/VvIbXzO5+bkztWQgXwU57reyyL9eV+dqE6?=
 =?us-ascii?Q?wcWa9YIyCeR5RkE393M7NU0cBCpFPB0iYwZJcWFxpPAMjaQTjPMXCABNPAXy?=
 =?us-ascii?Q?K7hzLUcbqE3Y7EIKwpBP2zHNxwIK7P4J4q5TTYHEQ2Syz41HyYzOWJ04an/T?=
 =?us-ascii?Q?NaVV3f7JZmne670eFPQ8P8XSeTpGUWI8uWgR3144fyILlgP3EPPwldc0EjTH?=
 =?us-ascii?Q?vlzyvsVODWa/XFgtJM0zjdCCEVFWYrADmHKeMl+c8HqR4yp+HY+nD3D+5I6a?=
 =?us-ascii?Q?9/7guQkPBiF47vdbSw0C0k1CjpPhq3FUwXq8F2a3KBlx15YwD4A9eq5qsto3?=
 =?us-ascii?Q?OPDI2LYspMPmPDzy66y9gZHR1XGUDHZQIzkGVr0fZL6lhHtjVNXvfPCC4SeE?=
 =?us-ascii?Q?g3+oSnGTx4viv6epL8TdW6TVsn9RCrkeDeiTpJ7TzrbpFpWcXsAYerjV7aYo?=
 =?us-ascii?Q?/KTili8AVocu54e/cFJKEkpF/VQ+Mp/m3ZGOcWh9s01JOfan+HC08OW98DZA?=
 =?us-ascii?Q?vAVj2XlJQUJq/dAlbO2Z0l5Y51UZYOAzD/L0qq0qJKxRGYxuviXyQJ2ZYTQk?=
 =?us-ascii?Q?kOHLX//CuA+bHrSiA0UJHt1//1FOHio82VF9KUI+4EQaKRyLznMh0Fp8W1Np?=
 =?us-ascii?Q?Zy9A0BuwPdApYX2StXUJ0I6q3wI9fX2+xFcpDicDGgpTLtIfNPgNVPFIRb/D?=
 =?us-ascii?Q?80Q6rhMqr7HC1enaS1n3SrtT37caLo7FDfTnpcKn9l2VXtVtdEc+YWhtQyUu?=
 =?us-ascii?Q?9uCpW0ig3kvDDKHZ9AzUDsFxNyKzD90Yt8OGbpzt9fL/SyW7J/pYz0iHYg+R?=
 =?us-ascii?Q?YgKwoZXwkdqs8tzT/kEZ5Ckyokqnaay0dN2oQBEs9h8yo7C09rJErafZcPs/?=
 =?us-ascii?Q?CxPMbiPvEs7WLrVZjUCfryEvitWNWpEE9YiRn5lw0Cv8Pcb/htAoeBHlQ6kB?=
 =?us-ascii?Q?mDWiRATKQx/IipxanhFvOrROW/b+CzRR2KQWPql+n+eEymWnzVm471IlPMuA?=
 =?us-ascii?Q?msRZl7m+lj1RcpzVN9qHwssGo9KbahdulK48K4MO6kT4gjCFrqpkmF/UDnrb?=
 =?us-ascii?Q?ys3dMw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52cf6b9f-feb8-441d-ea34-08d9ea135064
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 08:24:52.5111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i6s2jv3ZZ3zOzbfePjwCvG+ENXsoW6lpIG2Z+8fEOJP7tz6OQAS51sqtTCfoTQ3kDx67zORCuUAK9p/C+tyEemPRjFI+Fk2rRY2HswTJVh8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4986
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10250 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202070054
X-Proofpoint-ORIG-GUID: aKysWuD0-aEcaXluSOsn-_AcZUSJkZAk
X-Proofpoint-GUID: aKysWuD0-aEcaXluSOsn-_AcZUSJkZAk
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call mv88e6xxx_reg_unlock(chip) before returning on this error path.

Fixes: 7af4a361a62f ("net: dsa: mv88e6xxx: Improve isolation of standalone ports")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 192a7688b4df..c54649c4c3a0 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2602,7 +2602,7 @@ static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 
 	err = mv88e6xxx_port_set_map_da(chip, port, true);
 	if (err)
-		return err;
+		goto unlock;
 
 	err = mv88e6xxx_port_commit_pvid(chip, port);
 	if (err)
-- 
2.20.1

