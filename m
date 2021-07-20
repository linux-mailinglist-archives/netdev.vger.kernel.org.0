Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1DD23CF661
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhGTINM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 04:13:12 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53978 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234739AbhGTIKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 04:10:10 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16K8fXX3003351;
        Tue, 20 Jul 2021 08:50:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=/bbvl6C83jt6PVA3ecG+2EQauIq2vecYUPhIOg9NKrM=;
 b=XqQxGF71sOWH66npGlt5jgzdLtm4AEcoBqsfJiJn+Hnl8VZpTx1TwkdK9IsYsqkC0sv7
 EnFdB7fDkkMkbd5D/B3r36/JnfkHHcp+htLZ2fSaAiqQxlqlZrU5zaLV39uDN7cEu0ix
 fOoCbJ/pu7rVzPKHEbazYTIZVC80m3YTxUsU5o0LuiBK8NKtRZLnK31sug1H3VnL/V9D
 xVpsZpnZGDm2vNYx2gWhCRYgf3rhT9nxmRtdf8hWOdRI4EN0DcOjZ5JKLiJnVSA04nPN
 ZOq8uYDeeR47vfTEcxWLkwe+j0RMwOt2pQM1LLtre1jHXaC/vYxM9zmzA3fiBl+o1wCw rQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=/bbvl6C83jt6PVA3ecG+2EQauIq2vecYUPhIOg9NKrM=;
 b=yvGpp0surqwtyxibhQMkgzS7dddGGWHxSUS9hU5JljxlWTvRXeld2/PmgeRKf+8jTwi0
 sz9S2ur42ujFE3D2Aatm0GV9dzjU1SqBXU3Ec6U8jOjCCyQKOsyxWLNq8lOsOEUUUQQW
 3Bzs0G+ouuOuSb0FXqHpZ7gb2c/M8MQklI4dBh5kh2PpbMl0YTKSneJM98p6NyNmyiVF
 Fz6b6M8fyZQ67d1IzgOYCO8FT5m7iT9wW7AkTjdR+AXMj8vm0im5yYlF+BFG5NdzYEly
 nSyGtgS4U22mmYvJwNTjqlc1JOrwdQ58Y4MpyU7guNqL9hgOFDJ3Z19fX///l6NC1frz 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39w83ct7aa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 08:50:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16K8oJW8063036;
        Tue, 20 Jul 2021 08:50:26 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by userp3020.oracle.com with ESMTP id 39v8yuhnq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Jul 2021 08:50:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbfdKt5kxjHqgIByYYGDpjQZBBoDRYltBKyWWAECrAQg/iECNcHnICCkR8zoyX+lqgQTOrHCLLP5S7uN7tjp+Uy3R+5fee1OOJCTtJy1l59EYZtjqRjdHcntzug5nfYdYn+YBsAn1OB/4pudYmz+F3rWBioy4Rxh4J7w1a8c30FQnMeqZMj21W9NBvP8r7qwkLID0V7DDMlYuT7mmjkyGj1WZLKP2lwlaryAPLWmEdoB9W1K9LXxeJbomH0ZCQOAQ+xtkTyla3x5+dOrqXCjeH07pAyZVfyIPUF4NDqozZR/V5a9uYlOzImAhoZpcs0egHXIMcdnVBGG9YsA4L319w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bbvl6C83jt6PVA3ecG+2EQauIq2vecYUPhIOg9NKrM=;
 b=Qy3cchYcnLtJjH4kGaGQzSv7XVFLtw2zzoxRZbIqgTtEzGmlWMihBJPGZ35FNwl2S4ZBeGznHx49MgYaRSmXgBJAvQadB9T1PNDdrg1MTILfZSvd6AdUa7YW9cVK3326QhdoutVlrZyoR3iHMDbvWStGfc0QsqGYq5yLRyTMqYF4kh/CHlXFw6p9OESIO6nmTSoYQ8aqZnMu92x+EChU+/UjKtJ0nvjMMUKKcE0elNddWzjm/ywUBZkd5XX6MZf0NbaJDkeViQzmOb1Rk2ZcK5MHwc/BD5EmHRhDDdnG1e5wPJbFR8Oew4rDyfzRbywlWm3f3GJ2znprvwUDUno26A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/bbvl6C83jt6PVA3ecG+2EQauIq2vecYUPhIOg9NKrM=;
 b=GJSGk46Tp4zy/xn25GWolNXBiXtFzZ+v26yVMPLW0ldPl1Dgsd4jiGjlDpx2Ac81WJd93pWAT/J29d4ML/f7sRd2fp9HSbTqUr+5C9GUbew9S+ZZIwh4aYxkYuZYhUoBdpfZM4zGDCxwhSBgto9sssl7k/ObKWH37Xv6L0HxmcY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by MN2PR10MB3470.namprd10.prod.outlook.com (2603:10b6:208:10d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Tue, 20 Jul
 2021 08:50:11 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 08:50:11 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 3/3] libbpf: propagate errors when retrieving enum value for typed data display
Date:   Tue, 20 Jul 2021 09:49:53 +0100
Message-Id: <1626770993-11073-4-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626770993-11073-1-git-send-email-alan.maguire@oracle.com>
References: <1626770993-11073-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: DB6PR07CA0158.eurprd07.prod.outlook.com
 (2603:10a6:6:43::12) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (95.45.14.174) by DB6PR07CA0158.eurprd07.prod.outlook.com (2603:10a6:6:43::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.9 via Frontend Transport; Tue, 20 Jul 2021 08:50:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1910e4a6-da92-4068-868a-08d94b5b61f4
X-MS-TrafficTypeDiagnostic: MN2PR10MB3470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB34703F378066E7375DEC333DEFE29@MN2PR10MB3470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9rbPnFXgPbHz7AClJkADpTAjvAZHKj6Tkj15WSfay1VWEe6jBALWs3FT3iaYsFUbq0A0cUNkXQ/q6NQ2S14dRjSTCqkMRvxTP+qh6ndJW+v4vZ1x+GIg/rre2ipsz3vQNCLZ0yfYHLYpx4NyqIvr/OzRldUSz89S89RZVagEEDm80neXJ2Ew+dha5jslGIPIT7evwWhShqpa7qqVS1OrAtpS8KPGvV1kZ4SpWmNLlYl9fID7vshmnyMprXBscD5Wr9sovPwAKxT/RwRF3PH14zBYLAz8XUh+O3LGiFZlSd+83BeMRhAtk/38X5pebFfs73lV9XllSulDmTXIPRtipk9zwr0EpEczJY66ckHrci+KOKzTaOv5VOJt6JdD87oxU1UC3DHCmWq6EaYQFfPxYmKAbmEwJ+3liPQk3cRUjV+I4aV2RfaHgOsORt8vs2IF4i0Cd7l3UKeQfNGxSQDc0Bnvsry16kZkS+hG/G7lhq7lH17F6StgXhxu3khib/LBX5AvBXaeZx/zB63618jTi6mIzTxjO+e8nIwn4Q9ZiJd5VNln/gGtwxag/sj8gH2F03gLOyhSq8zZ5a3VDddyAlqydW8ACJpfZfxSGDJdmEavMWNerVXRf6v69lvtrnxBWl7q6i2F/asgL9rwqIxAc81Si7iEk441J45AJYjDjmyvkOYnefGHtSI0DrKK/Y2MXvsMI2zzeMkj5CSon6LZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(346002)(396003)(366004)(6506007)(6512007)(8936002)(2616005)(107886003)(26005)(66946007)(66476007)(956004)(6666004)(83380400001)(2906002)(4326008)(66556008)(86362001)(5660300002)(36756003)(52116002)(4744005)(38100700002)(38350700002)(8676002)(6486002)(44832011)(186003)(316002)(7416002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cRlYF+zscKRrVaauAPQBEsq6bhmXrbetedmasNy7+PhY8GrnWtsaT1fxY7NA?=
 =?us-ascii?Q?SJ3TXDG9UxGLUI3eG3dtRxGR28fFUYd5xtodmWxGFYwgjUkKh5p7QwsgL2lt?=
 =?us-ascii?Q?WwZm5TuBHo9w5+Zlj5Slyl6byWw3J9zjoH2yYDdeaJK5pRTyNcIjOSEyQ53U?=
 =?us-ascii?Q?Feg/o8wFaU991/M0Hldlvrch8M/xS6yL2sEG8hkpi4BCYFf7coHqj6FbESZK?=
 =?us-ascii?Q?UmpUxUuh6lrVmK8cM8Kr7UlZA5XrFtOGzB47/zv9/CCWm0VffjuPTPeeqPlp?=
 =?us-ascii?Q?AsO1RrS1DPOHIIEP6y7AF/D852VE5nT/Z0TKrpAYbNTaAXtPHCgXbjzxrowc?=
 =?us-ascii?Q?lIJOUyet8yhM8AivpVuK60saw9AGGqxpHnJKkhnRbQlspjWPv4gKF4mZmT5p?=
 =?us-ascii?Q?11LfC3U7FIZTFRyPX8n0smOWpvN0ypthot6eVb1qxLV7nVImO1Dcn5BKwlXJ?=
 =?us-ascii?Q?Yvmb9DasziIe93lFjJL3KFs+SA82kXfE2nBSOirSOsEAhnJo+npNVtBkagPi?=
 =?us-ascii?Q?o29SLWQ6R/y3ac9xO9xWNTXkA5hPpo7Qn8CjFEiprtLNdrePfU+lBLtMm6NS?=
 =?us-ascii?Q?9Oneez64Z0eGqcnZXWKt6kwYMdaz1DQ3rxJkg2cULoOxbS99Sa91q76ut2G+?=
 =?us-ascii?Q?92F9FJ9tClEjR5wNzUv3A37eZl+QcviXsyGqKYda21eLS+LbJ76AQTwnm0Ae?=
 =?us-ascii?Q?E61gd9nfWR5q6JMdmyn1s84BK+jIhnwxczfv6JAV9kSHeAM501VEtdRw7si7?=
 =?us-ascii?Q?+QfvwZ48kOs5d4P9v6CVVlyoXLINcXMajdj/mHq1DLN+J6pAXMfYBjxUxeP6?=
 =?us-ascii?Q?uszP2Czdxdudnm7ZX4bdi8JNvG2iTeUcbrHJrgn23U2vQj4JOpeILzFSDKd5?=
 =?us-ascii?Q?7eiCjoGgzpCwFJeyoFhUOn4jrYcqZjUpLP3NISuN96sXEFG3hlHDMBjuPauo?=
 =?us-ascii?Q?gfB0LEVhFLxdmbl6EDIcZqSYcm6eVyWaDSTl+qNLr0a8i2XgeXxPXMJrhsHo?=
 =?us-ascii?Q?ChTxNTlanaRFHAsNWbvV2hRJoTySitD0Rijx7vtJC+GwxZQhIx6lMcGGX4Rg?=
 =?us-ascii?Q?tA9VpMvnAETuCvsKwIlPUvebzXf7HXId2yvDcV/GdcugnfGKoin9AZg3tfid?=
 =?us-ascii?Q?nHSOvcv02pgmMMywpnPEqy1cJTcdW8mIqp3I8lP6Dlv/aAKH/HyPmRcgxlZo?=
 =?us-ascii?Q?sbj6+rZQoQLi9UeDo/8ymQh+iRipgXrSm/wHhAIDzgUWf+I3NEyqnl+JC8BS?=
 =?us-ascii?Q?MIaVA0ooxuT3fi/wcj7N4VukO06YdZqieMbDQKFoYN6s7BPNEeRoT2yXhNQU?=
 =?us-ascii?Q?No2CDpSgldSiEqBqP681kDNl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1910e4a6-da92-4068-868a-08d94b5b61f4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 08:50:10.9049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R3/WzqM8bNoA3OYCG070lvMdrR7TqVcuYCbRezURMtbmkaSOvuQPdawL3763qI2G9bnQpq8kyiYBUsBroTnqiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10050 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107200053
X-Proofpoint-GUID: Ak6o9GTNDD6Yj27hPcmKkoEnvokfG8ha
X-Proofpoint-ORIG-GUID: Ak6o9GTNDD6Yj27hPcmKkoEnvokfG8ha
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When retrieving the enum value associated with typed data during
"is data zero?" checking in btf_dump_type_data_check_zero(), the
return value of btf_dump_get_enum_value() is not passed to the caller
if the function returns a non-zero (error) value.  Currently, 0
is returned if the function returns an error.  We should instead
propagate the error to the caller.

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf_dump.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index d52e546..e4b483f 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -2166,8 +2166,9 @@ static int btf_dump_type_data_check_zero(struct btf_dump *d,
 		return -ENODATA;
 	}
 	case BTF_KIND_ENUM:
-		if (btf_dump_get_enum_value(d, t, data, id, &value))
-			return 0;
+		err = btf_dump_get_enum_value(d, t, data, id, &value);
+		if (err)
+			return err;
 		if (value == 0)
 			return -ENODATA;
 		return 0;
-- 
1.8.3.1

