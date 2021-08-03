Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFD03DF6D6
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 23:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhHCVYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 17:24:03 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:44958 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232158AbhHCVX7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 17:23:59 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 173LHUhJ000814;
        Tue, 3 Aug 2021 21:23:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Z/FgygWZITQEXyvo7FfRVnO7q1z68eJWhF5pf474kLk=;
 b=qKAOm0dimtdL9C2tpz+XAqZsBmpZBEgwJ94dbFnrZTG7TdJJTw3bsWDycskWJ+l8q7/Y
 grm4GMtNrjpu3ItxSmPWj5sRbEu/ujlrvVyUWgnkldDijUtTjXJeQjKgBXZq3tY0LSpV
 2Bq76mlgpyens5ooWBaoM1TJ5C7kGfMoluCAnvb6c8YPdciPO0Hp5+KfA5D+lq5XOYKa
 tahK8Ha62IT+A5RK4ntY/BAn3Bva8YPJ1l/LrOh6+vbs9uj9ThECtxchUkMnMY7RmvNJ
 DS/Et1mLhLGGvQQF/0FleBhga3XwKqy7GLOhYS0jAEASHNjfndyxfkGJZpbJKMqfRujO 8A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=Z/FgygWZITQEXyvo7FfRVnO7q1z68eJWhF5pf474kLk=;
 b=y/BsgcH4rXRRdJnxoTbetHv3w3LIrbEPC9AWeEIAButMBOVucnelgTJ4j7SoG/sYgKNm
 xc2kO/d20UgV6ciPrVaPvyi2EI+O6iEXlrNt3QcJCflFHELqQCGiJN4iZpDBYTB63dV4
 Y7snuxkDcnAkBQ749vhvUeZfQABZ+pdcfnxiu+efD8EpS9jm/ssH4czWwIyy8hgLAYnA
 L3gBPvd3a277eR4PE/ZX1FQ3RAMEOaLAcNe02jxVI7dvUhGP0hbQ6aT0peX4WCLvF5m8
 SQhBgPuhqbURKmRSaUR+LkPxIL3m26mBKPSKf8PRckaS4/j53dg+CK2Mos/7U548ew/L Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq08cwf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 21:23:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 173LFR17171388;
        Tue, 3 Aug 2021 21:23:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3030.oracle.com with ESMTP id 3a4un0d1ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Aug 2021 21:23:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaJnybmzi7eIJFbkfqsNFPCX5QtPnxs3odgm9Eh8U1bnDNg50jEpA8IDQ3I1a4ski+f3jPxa6IiOZJmQe1r98XoAqqL6qzB71OXXeA3k5tmLBgSnkLRgkWpKLgprWo17Sttm/CIjGKmnNRAULsunZhdw/gsfWVRQpIjaNFMMOos3VovXyTZTuV8j+cO9J2yOauHPBxDqw+kT0Sp/WHf27GZqzhAUlrAPghtGm9IJ2Cttbp24ADnIS56fQ6e1BN2wwxKD4F/tdYak8N0CF3NLqB1TyMDHGbvHcGzJqmFw5alJfrFmaBc6z2mpsY7gb3W4UCoh368VYqtgTXdGmt2goA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/FgygWZITQEXyvo7FfRVnO7q1z68eJWhF5pf474kLk=;
 b=AYXioRUz7SSU2fbWSd50Y0wUPDLWoC3rTOJOX4f8wDJrsH9OBrZtEgBhvJOa0anmeq4Ymgp2/VHsri6L8eHsqkPhDjxlBTm4BtkFF5cRzf6Tdsfg88Knohio5bLsHHY5jTphkacxYCugY49kmpav2/TOZVFnLoq3X5BssA94sT3GJLE2eISCDJ4rs9RzYaIjATsfb3p83jfyMaODGKxnKZFWlIybnpnhNzPrmz7jjSlPOhUWhQ75iJ+4Uy5wIC1Mv4XExIXlWIaIK6SKAwjl/LnhFV9T4t3CAvgsVzXPmizgk5jJwtZ2ya2zNwwrH/4ggnbjffCp0L28Tb+J5uTlWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z/FgygWZITQEXyvo7FfRVnO7q1z68eJWhF5pf474kLk=;
 b=uSDJp7xlCHZd0Qpd0rUo6OB3zazfPmyOMST638FZxuUDBEqWGdMUcrYA9h8DfXPzqn3Pfgpv55aXNCjVkQLbMtZeR0shH6lAffluo61zV5GeBdBwpzO1zoPj7awscpkf528fIPNNw+kVyfUkKElN3xfyCtC8gv4TY3xtc1Ci7dc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB4948.namprd10.prod.outlook.com (2603:10b6:208:307::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 3 Aug
 2021 21:23:28 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%8]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 21:23:28 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        quentin@isovalent.com, toke@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 3/3] tools: ksnoop: add .gitignore
Date:   Tue,  3 Aug 2021 22:23:16 +0100
Message-Id: <1628025796-29533-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com>
References: <1628025796-29533-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0024.eurprd05.prod.outlook.com (2603:10a6:205::37)
 To BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by AM4PR05CA0024.eurprd05.prod.outlook.com (2603:10a6:205::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 3 Aug 2021 21:23:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39568926-3c98-4a51-c3c9-08d956c4ef4a
X-MS-TrafficTypeDiagnostic: BLAPR10MB4948:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB4948487ABB79D750C7803103EFF09@BLAPR10MB4948.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x7e3JYb8+sc6haocJCOxSCdjZG8rJEhBds7B6k/orNGhRbjTz9d0AK2CdJCs9MFcka4zBuQ0kYwcBiPpHQKNUbd/73l5Ph9vA7PTXntMkXhoPEOnRS5cyF95jlXLppi6G7NY2OqkMDlu0IvwRfPj6ubw2pgdcEB7moBWijKfaSw5hzzdiFPHTrtMYmqsdWZzA5iEJbPuXeX6xD5waLHR9/Wr2VcOw5L6tC0CAeUUUcxjDK4EFcHvYtUB98sxfGZ5OHiYeeY5brKB7GqVIU+AMiPP1GGTNTCrETJQoZaGls9JnfDsPwOf8ntRSk67/zVIrrgORr5suOlUhcfWQIG2a3r579n3Ytqw18OrsCyCcPwHExYonNOPDIP6PrYdEphYr82SxjU3DXLY5r8vF++WD/zKTbN68U5jugLWaFdsl+hC1oYzN19kNUwt7kuOZ1vTBQwb+xuL+uwXKKuqOkJ15oXoxx8Ou5N7L0Yhl/4wB5V3bpaX27BoKW6RWkYLLym7l+PRtGfveDibVh3+p+dbCOsT2hI+EcSLkPRPoFFx+S+TmsKv3KE66joJUo+rxld14uOdKgr+E8+RcXt9Qft4nQnNS9MC4cBM7E0YDpjiPsEieSY4yE6ZuONjtkHavLPLe7dKAbubPEKPrglMzPoKK1sVlRhmZt8r/1EhXT5c2hak7RGGCjYoJj+GJPBI1QMOaw5zWhTtOOVsKWRWeu3SQrRdJl47L7NEMKM/o1mQe+8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(86362001)(6486002)(8676002)(4326008)(8936002)(36756003)(6666004)(478600001)(956004)(5660300002)(44832011)(2616005)(7416002)(38350700002)(38100700002)(4744005)(107886003)(316002)(2906002)(26005)(7696005)(52116002)(66476007)(66556008)(66946007)(186003)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Oc9BGTQmteBjUnTSgkwjkdSdUFXd6wAAiJ5DcnNUrtgULlI426KfvqAVHIwE?=
 =?us-ascii?Q?MUyuqlUvm8r96292uts+Cl1Wl1ud08Azf5yEd1GrXNU/qX//Sw71qUe6hBVS?=
 =?us-ascii?Q?l3zOYfG+5gAU63hS1tMmR848SE7Lzm0+Ov17jsu0gEmynCrtl1ci8LYatvft?=
 =?us-ascii?Q?5108cuP6JMQcHcndsKv88vuEY3pa68WRl8zjkD08MbJQ9oXLZlHAB+DnYbwF?=
 =?us-ascii?Q?bTbYwkcTkWKmYz8fttUZ3XaKC2eyGDw0SvkL8ZwJo72ASa4imopKiV8yC2kU?=
 =?us-ascii?Q?n57WR7r87Rp9noeG8AwVXL/wTjqoGGCgYyizuJ4d30tGEbc/9GawcjTXkw96?=
 =?us-ascii?Q?0483nWeYZ3UKNV5cwoaYz4ADmtWgVJToHJlKCpv1v1ZAJEl+2YYSpGzcUusu?=
 =?us-ascii?Q?+NMdVENXB8VbMUUA9BjOcX7B+nsqegsSVhgOpHos/wPXcCxj4+jvz2Wvh21R?=
 =?us-ascii?Q?NVqloSK1TPVpcSCcU5F3Let5ukf/wY6N+oCeQbCjJe1FTxMlZRqXFrbqyZSS?=
 =?us-ascii?Q?VmGmgy7EQPffiCgYK3AsTt7LtXqVNOg91Y9x2B2OTdeTJjBfKljdp9BKa8Q/?=
 =?us-ascii?Q?YO6zqRJeTaSj2bwA2hmorPj5aGjMcW2CIdSrq1d1wdeKMsYr94u+loQH2gLE?=
 =?us-ascii?Q?Fe0ncgItzyH8kHjkAq/my6yPJ4KjnJnFoyBssL7UtBZ2snYH+CPzoyBboeCa?=
 =?us-ascii?Q?VD1CnoX5WAJ0xAs9Nj1CzRKctxmKN3NQHVhOmoe2//Rd05ktNOVxvmKu+D2s?=
 =?us-ascii?Q?QGfOP4FdHNpbWUc64yUeSYv6YCE1rRd0I2Npi2m1tLCnXxgasEK2S1EWmJxw?=
 =?us-ascii?Q?Rks/X0THBSurWd91RKXa2OugG2S203QRDI5fQnbIJhNAvxGQbNzQVx7WY14z?=
 =?us-ascii?Q?PElOeakO1oi9gXfRQsk/5wlNcNO44It7IQLETX4lOBtYIwCldq/qxGOaLb29?=
 =?us-ascii?Q?ZZl6GJKOlHhG6Lv3XE9D+2LuE9O5qZ0v7UagOPP8ZsR24zOiTKwXp8Xtqn2B?=
 =?us-ascii?Q?uJILjI5ECKnY5sNfgcmwlGz3HgZ2OYeQDXRtHMPQR+G14ypu2Wh6+Un75X8A?=
 =?us-ascii?Q?Cz/Lf9tklJ+Z0nlDZeY7FaVt0T5wjoXwseFzgUBN6hJ97OtG8KI+PyEAE6Mu?=
 =?us-ascii?Q?AjA9DM2Q9HCbvljmRBTybMLQNoMYspaQwQrl2vRo1NuGRy9xAKfwD8AhQH11?=
 =?us-ascii?Q?C2yRL8VJDaSoysRpnRUmmu19Nx1ASHnChUUwEw7JY0zee/ppF4iVPkhYZf3A?=
 =?us-ascii?Q?jT4F0peGZHciRaELrM7r8IprWqKxRjSRhrJ36P9J4Gxksq6CjEs4tgJUe9b5?=
 =?us-ascii?Q?8PRQ+0vf5I7j4El7qU4K95h3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39568926-3c98-4a51-c3c9-08d956c4ef4a
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 21:23:28.0139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: emHvqM2x7RSZx7qcrP5J8Jfzs7S4lDqHJKBO+6LWvnaKM12B2qvnwGxnpr64aLzYI7vaBtCl8hvmURvm1RRmFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4948
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10065 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108030134
X-Proofpoint-ORIG-GUID: mUMOL6joB2quhARI3fn2_S7DHyPYa1lE
X-Proofpoint-GUID: mUMOL6joB2quhARI3fn2_S7DHyPYa1lE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

.gitignore needed for ksnoop.8 manual page generation.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/bpf/ksnoop/.gitignore | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/bpf/ksnoop/.gitignore

diff --git a/tools/bpf/ksnoop/.gitignore b/tools/bpf/ksnoop/.gitignore
new file mode 100644
index 0000000..8b8f877
--- /dev/null
+++ b/tools/bpf/ksnoop/.gitignore
@@ -0,0 +1 @@
+ksnoop.8
-- 
1.8.3.1

