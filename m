Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58D8559EC6
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiFXQqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiFXQp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:45:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4138B50032;
        Fri, 24 Jun 2022 09:45:58 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OFYD4L023009;
        Fri, 24 Jun 2022 16:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0H2EswXejg6sqJQb4PJ8L6Nk0KnaVB7h/56TX6J++lU=;
 b=VdjyxT5kqifUhaS8MEQIZ3ejZxOSnKhja353oCwqF2yEnV8k52MvF80AA30Dj22DfFnP
 s3kY8SDZwnUQJ33ChY6Div4GGDn7O1LWSfbp6PLnV6XHO/mTsi4AF3fVeNyiT9JZd/w8
 wTZLEDsHqjWyFH74NxpQMSp1NbMqA8/GFCpRwahRHaDcxxEShlkDV1JuYop7zyJoJ09n
 wTPANmDEfvJeB6hqXE+2Z3+AFjWi3GWGSbl8Pn9ngyoCAE6lfCohMndqI7jdQMJgERIl
 cjK7z/PGsdQR+wjClupldNySB8Xre/w9GuYL34SwUdFRgOb0lDKM+Ygp3RW+mlyRMfbe nQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs5a0pbx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 16:45:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25OGUf5V034023;
        Fri, 24 Jun 2022 16:45:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9xc0t1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 16:45:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuciVzvmypkKQwqjyV2cuiQMPHtuCjNKcO6mR85gObpnc0k8T+8Di3UqO5hlBvU4dyLBkjmSxSIKRm+ay2FvQMYad3WYPAFrUkc4AIIvc9eNX6Gg3yLIyVyQIMzoqiqwl45aTVQLpwlMjTDG7+mtIPauZW0Ob2zuLAlpQJFK+6pLWNALkW0FA2OxVyl0ooQaYEL6//pnEtdC7OXdalHckzRq6DZEkVIF6nBcG4nUVNrzQeC7Apy69+GZcOoAlypia5GN7jJuqGgADhMlkwiZVhMmupjL8IOQn95khUGyciqKoKiOTX4VqUI9tdkFAE6NMuo8go29/nJ6SOF3JNt94A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0H2EswXejg6sqJQb4PJ8L6Nk0KnaVB7h/56TX6J++lU=;
 b=LrX422UTCjYOhGu7Iu17TiU42TUMk1X0j+mqudtbuyaMb4WVtZ/fPAhjH1fFt6QgiuwjiX55bf4it+fo75oha4RimhGjjMq3RC1mVycQdQShrEgADrxeKTTlB2+yfmiQTdFcpr/tFTbquOouBcxbYLSQGAquMvLMbvkVgsQeYuydHZ6KLEgogmh0BHT30obOXrf19GcwiLFbh1XpjvbOX+u5OhgmlvRwCJg0g2MIXhQCGSBVbCmlw3JOk8PVJXi+lq3mwq+ojlfV0sKwYXMCXUzucSTqhhUVcybFo39e1F41o+G1e/C1usVqxLRuHZuaDcCdAJA7VUZYgeaYHWGB8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0H2EswXejg6sqJQb4PJ8L6Nk0KnaVB7h/56TX6J++lU=;
 b=JKIdxdIzZEugHuiYKMx3rlTYajq5GhedNhLZrOKPjsvX7h4tpoKvFIdOlo59l4ntbwGI8Bpq74HX+24+sTHulMFMFOQLRxLk4NFhk+PCAvdG06qqse00NXwgpaV3rilxdKfr9Kq3rOWeen5JwmXPMX2ZYO/vNatCh5bjOdROGJk=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 24 Jun
 2022 16:45:27 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::a080:c357:962c:eb5]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::a080:c357:962c:eb5%5]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 16:45:27 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jolsa@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mhiramat@kernel.org,
        akpm@linux-foundation.org, void@manifault.com, swboyd@chromium.org,
        ndesaulniers@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 1/2] bpf: add a kallsyms BPF iterator
Date:   Fri, 24 Jun 2022 17:45:17 +0100
Message-Id: <1656089118-577-2-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1656089118-577-1-git-send-email-alan.maguire@oracle.com>
References: <1656089118-577-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0396.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::23) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8680f5c7-5ef9-413a-cb96-08da5600f10b
X-MS-TrafficTypeDiagnostic: CH0PR10MB5115:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zLLDK1MD/7MzieVo7mkJizNZ0LZNxYTpe4O0kjnXd3gVCK6cv2o9zAW6tleXGuIhVRiZh9vdRhKBlHVeTSLA2MfOCOl/xDB4JisoeHFO2UEE1ajslmPcYRZtuu2H54MtyQNnDqbXHX5KrkoFH1n2H8PhPFfqsRApGsxXF9xfDCmBPPYNmG9dl/H6NUWtPrhd6uJVqC31b3tHZZtNPxgQSjfjqWDdu0ccCunA8oibT1B4mN+/FyIONPQgbB9lkekRasa72DhvOCwjNZ9bJKdMz+rFF7K8w7R+4Z+x9rvClauVms4oqw7pjrlFud7949iF7Z0qoObsuUvrFhAELEpdxB715fFLQMP9pbnwqjmqr8b50qsrjGng++2UDOgpM/HK9VDexthQn+nj0NNO+fKhgfIGHuV3uSZ9QcV6QEjbyQNKM41Mx42hU5tBtF4XnChO1PROgBKWO/wszlKUzNZgAC8o16Rk9tDl/wnuhxU91Tm4ux01l6WiV0AfqjZ4Qw7qKnLh3BCr50WnROCAEzLLex1niudkE6Ph0rOg6XGS5Zg8yJYVckJXiTePg6o4Q38vtT5ohUhFbxSk12uv+B1idCk9RDl6XcCvEK7eQj1pTI9CtKxi0FxiIwOgA6j0BDLfbiesj1w7eBfmdFlrSv7kEAw3AatELSXuhPsMriW+WUX+JKegPFL9cNawT6aoZrq19LjQNqbFWwbu/NatLyECaSSnnl75Guz3XXH8sHZVkLzDl27V/hG7R8dd7VEJUPyifxNVqXVe33xmP1Wfxnmh7C7UvA2h+BYYy9E7JFqd5Z3koMD4XAFSTmTmMGuCdLq+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(376002)(346002)(136003)(4326008)(8676002)(186003)(83380400001)(44832011)(478600001)(66476007)(5660300002)(2906002)(66556008)(38100700002)(7416002)(66946007)(8936002)(6506007)(107886003)(52116002)(2616005)(41300700001)(6512007)(26005)(6666004)(966005)(316002)(36756003)(38350700002)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?27kQTbdONJA7tALuCVPckhYOlMF8S0UTjX9u3+qQ1OU9ppmUxhcOJyAETuAG?=
 =?us-ascii?Q?a7bJDipPJdA4e8QMyE4dUpyW7oqKC+W1nilpGuA0sYUQCsPtbpz0GsGSwNvd?=
 =?us-ascii?Q?GW95ERUi7j9y0jgqyzLoIdltBFMhef4q0P2stkQgy4lVECmyj/PnrGOZti8x?=
 =?us-ascii?Q?Mye5g0xWDbl0G63/SBk9xTV95ATPh6nyKdK1F6BqDwHZ/82IpivDeXsm91Eg?=
 =?us-ascii?Q?pAsEHkOvo5lFT+GAIhJcgdVKYyIJjiHjPxDB583shD+lddFywe5KeFMho1yh?=
 =?us-ascii?Q?ItBurCSocgtw5m4449tH79lnmFM/DhTPUaxSyrkIMhN7yczT16V+TnMpsdgq?=
 =?us-ascii?Q?bbS8yOMqhfblULis4p2lUdIPUb0uNjR7RhUxTBEZdN0kcy/KCsOJfIoJ/7L0?=
 =?us-ascii?Q?mdZagrxi2bJ9cFyEUEr9g8Td3WQuN9qRF/R2BE7LopbgrJtLRIoAeia7Pc+Y?=
 =?us-ascii?Q?P0Li5W1/PkMRYw6iHt8QOFZm7XOg2ZLSYc3a8WWCZy3gU+yY0qShBlkSbqsC?=
 =?us-ascii?Q?tvdv9bVMTIsH797iCh7qidFqLHLklEI0oe1DOhKwBd0gXFqCgA93YkJAFR3M?=
 =?us-ascii?Q?P3b4ohPRa08tq4R+wmgX/VS6k+tktNbwXqrq8ZDhwSW5O2XeVlsfNkyG2WtY?=
 =?us-ascii?Q?c+An/0ZzymqNwHvwknB+ee80KBY8MbKz9o4sIQox92pgeDWgGzrmGRsjBTIK?=
 =?us-ascii?Q?wC25WPhGfPd7P3WeMovX7A8Ht9mMOuYDMg41QIG8u6/V/50raBllYCk1gpJV?=
 =?us-ascii?Q?lE51c1UkH30iyRhJ/GeFa8fpAptunPhbrMxTaNZ9B978DEkl2ZNBwngqisLR?=
 =?us-ascii?Q?UHmXEzFHykyIADWsq+Dbb65S2YisERDKtihOijP54s7s12720fMJ7eYYSNBp?=
 =?us-ascii?Q?g6wQyF+W0xw+qZI3aw32rV+x14FutRDJx2lzseJI74qXx1fKb4GZXu//qIeI?=
 =?us-ascii?Q?kXfbVtcI6+oS258U3uDON58k24vHkrmY1+GCWSevp6FYAB/mtEk6fLIPaCG8?=
 =?us-ascii?Q?TtiSLS4Ds7Mv+ZKtTNX9k761l9MWohNw/Ajs0AEmLMmI7ilzLw4jcWusruy6?=
 =?us-ascii?Q?NzK4qza/RgtmLuVPlzbiNOZdz4FL0wEw1nZ0yLsFZiBLF+nrvZK6jG4F2rgM?=
 =?us-ascii?Q?noMKhZWL5TcMNdDGzNgfOV/UWnBENduQ0hkDmLMoYNheOBEMlxtSNmC/hh+p?=
 =?us-ascii?Q?Nk60CKsSYp/JlUAoa7mmtnwdQ0BK+xLCpRIuqq7hOcN23OH4pOGxBcxjoYxX?=
 =?us-ascii?Q?mKjsihM+5/YaACTm/nBdwyCdgZxbXzSXjduREA5WNeAEsz6KFzqguUbmr43K?=
 =?us-ascii?Q?JFPPpRnqqpapJjp+ASh6n/w+69Aql8GA3Tp6P+mTBELquS7ODPZQc+cbdOwZ?=
 =?us-ascii?Q?2qeCM2vbxkDvrR0WhUUJEtbRIE4zLG/WrTG0TtC0Y99eo86pJPSG9BTsLjEh?=
 =?us-ascii?Q?Fgh6H4W3b3+hWLGkxgWWbCPcpstg3A9k3iRZB+Hx5ImBF0ajJfKQCzNxr458?=
 =?us-ascii?Q?KUJ88kni+0ncSEEl/5CGn4NZUJeyD3dfRJq6rDBbVR/EurIh7DCudO1II8/S?=
 =?us-ascii?Q?g45ZL9owI+tO1GmxVUiKhYdDFmLANuCsEIv5NL7T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8680f5c7-5ef9-413a-cb96-08da5600f10b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 16:45:27.2448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cA9HxmkkKdU/ddLXvL4T5ef4gMTzRKz6PACK9yqw/xAeE2eh3KaHNCJyUhsqO3tfKriRiPdkMg8x1K1SWnbVsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-24_08:2022-06-23,2022-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206240064
X-Proofpoint-ORIG-GUID: bRfEBvaPNkMv5tAnxtyNGs2tLHOf5Ivw
X-Proofpoint-GUID: bRfEBvaPNkMv5tAnxtyNGs2tLHOf5Ivw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

add a "kallsyms" iterator which provides access to a "struct kallsym_iter"
for each symbol.  Intent is to support more flexible symbol parsing
as discussed in [1].

[1] https://lore.kernel.org/all/YjRPZj6Z8vuLeEZo@krava/

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 kernel/kallsyms.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index fbdf8d3..ffaf464 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/bsearch.h>
+#include <linux/btf_ids.h>
 
 /*
  * These will be re-linked against their real values
@@ -799,6 +800,95 @@ static int s_show(struct seq_file *m, void *p)
 	.show = s_show
 };
 
+#ifdef CONFIG_BPF_SYSCALL
+
+struct bpf_iter__kallsyms {
+	__bpf_md_ptr(struct bpf_iter_meta *, meta);
+	__bpf_md_ptr(struct kallsym_iter *, kallsym_iter);
+};
+
+static int s_prog_seq_show(struct seq_file *m, bool in_stop)
+{
+	struct bpf_iter__kallsyms ctx;
+	struct bpf_iter_meta meta;
+	struct bpf_prog *prog;
+
+	meta.seq = m;
+	prog = bpf_iter_get_info(&meta, in_stop);
+	if (!prog)
+		return 0;
+
+	ctx.meta = &meta;
+	ctx.kallsym_iter = m ? m->private : NULL;
+	return bpf_iter_run_prog(prog, &ctx);
+}
+
+static int bpf_iter_s_seq_show(struct seq_file *m, void *p)
+{
+	return s_prog_seq_show(m, false);
+}
+
+static void bpf_iter_s_seq_stop(struct seq_file *m, void *p)
+{
+	if (!p)
+		(void) s_prog_seq_show(m, true);
+	else
+		s_stop(m, p);
+}
+
+static const struct seq_operations bpf_iter_kallsyms_ops = {
+	.start = s_start,
+	.next = s_next,
+	.stop = bpf_iter_s_seq_stop,
+	.show = bpf_iter_s_seq_show,
+};
+
+#if defined(CONFIG_PROC_FS)
+
+static int bpf_iter_s_init(void *priv_data, struct bpf_iter_aux_info *aux)
+{
+	struct kallsym_iter *iter = priv_data;
+
+	reset_iter(iter, 0);
+
+	iter->show_value = true;
+
+	return 0;
+}
+
+DEFINE_BPF_ITER_FUNC(kallsyms, struct bpf_iter_meta *meta, struct kallsym_iter *kallsym_iter)
+
+static const struct bpf_iter_seq_info kallsyms_iter_seq_info = {
+	.seq_ops		= &bpf_iter_kallsyms_ops,
+	.init_seq_private	= bpf_iter_s_init,
+	.fini_seq_private	= NULL,
+	.seq_priv_size		= sizeof(struct kallsym_iter),
+};
+
+static struct bpf_iter_reg kallsyms_iter_reg_info = {
+	.target                 = "kallsyms",
+	.ctx_arg_info_size	= 1,
+	.ctx_arg_info		= {
+		{ offsetof(struct bpf_iter__kallsyms, kallsym_iter),
+		  PTR_TO_BTF_ID_OR_NULL },
+	},
+	.seq_info		= &kallsyms_iter_seq_info,
+};
+
+BTF_ID_LIST(btf_kallsym_iter_id)
+BTF_ID(struct, kallsym_iter)
+
+static void __init bpf_kallsyms_iter_register(void)
+{
+	kallsyms_iter_reg_info.ctx_arg_info[0].btf_id = *btf_kallsym_iter_id;
+	if (bpf_iter_reg_target(&kallsyms_iter_reg_info))
+		pr_warn("Warning: could not register bpf kallsyms iterator\n");
+}
+
+#endif /* CONFIG_PROC_FS */
+
+#endif /* CONFIG_BPF_SYSCALL */
+
 static inline int kallsyms_for_perf(void)
 {
 #ifdef CONFIG_PERF_EVENTS
@@ -885,6 +975,9 @@ const char *kdb_walk_kallsyms(loff_t *pos)
 static int __init kallsyms_init(void)
 {
 	proc_create("kallsyms", 0444, NULL, &kallsyms_proc_ops);
+#if defined(CONFIG_BPF_SYSCALL) && defined(CONFIG_PROC_FS)
+	bpf_kallsyms_iter_register();
+#endif
 	return 0;
 }
 device_initcall(kallsyms_init);
-- 
1.8.3.1

