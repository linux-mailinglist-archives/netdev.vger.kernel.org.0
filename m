Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF34539760F
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 17:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhFAPI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 11:08:56 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:21692 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233924AbhFAPIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 11:08:55 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151EwxeW005456;
        Tue, 1 Jun 2021 15:06:51 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 38wm1ur4wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 01 Jun 2021 15:06:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PE5INtmJ9RbAQxns4WQjTWM86dosqPRCRSEgfwHGRoPv9DRAUEEjCOYC4oI01Y8G4zzyQAOCDtrG2GREueHC7ELECF9qK5tJ1gh9sV05DzG5nZI604XJtEfWbXd4YzfYNMkWLyw2xIXbe6qg7NuvY3ih3F6bgPxzHhdBtP3SLr9ygTfgG/xZ3drSlTc6j+wiUWmkeug3HVV7VdoUb3y3kn/gA7ijbCqhGQLtIsRWlq8gmos7/drcjnfX4xtDg8Udi+NoUur/I26QxOCe5+QBgFJgBzQAUb9HLMb1KsaESEcPfulf7o1IKOiJL2k2JXxSSY6YRbLXz7/3/t+zawMEbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6tutHu1KIhe/RxjbyrQmF+ieKWyEBarwHzNEdbkzgw=;
 b=enYt80l/QfNdukZoFPfuElIlP4/SyxhbtYmVYibL+ZLiWwgkyZSGy3pX3trGwh8bmsraemsvY3x+obOgPDVGI45YnvYRG3r9MHXPuQsh5BqNiBYtoXP3xa0Fap/ywBzz2zlVtt6BmtBxFMydVKPCB0VqY752Jl77jRMkIqmjzE/ZB++2Dbgzp9v3EQFG6TmZx2I9q/qRIp+bGd7S7JxyJwjNylqt1hR+fFhftGYpz6gXeXxuWk4MvUAMd9sUVociQwkPfQ2dRqpkzXiBM6cTek6bvTy9J7AVRgvE/NxAkc2fgGRLnh3wgVjYOY9Vi2XUA6C33DSa3HL83CSSFBTbMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6tutHu1KIhe/RxjbyrQmF+ieKWyEBarwHzNEdbkzgw=;
 b=NwGXXjehv/fX/8jNI1qSNGnvbiQg96UeOI6W8u57VBOGpMyxdFbQQXAfQmre3VWOx/elT9j/iSUV4Ws9fVFV11lJQdkEJZTvB+S/2RpfFOt6oY/axt6W+NM5sQq92p+2kwN1tqh16cIYnvRxW1CWtHMazbW6aMXX3xRgnpfNiiw=
Authentication-Results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none
 header.from=windriver.com;
Received: from BY5PR11MB4241.namprd11.prod.outlook.com (2603:10b6:a03:1ca::13)
 by BYAPR11MB3223.namprd11.prod.outlook.com (2603:10b6:a03:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Tue, 1 Jun
 2021 15:06:44 +0000
Received: from BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c]) by BY5PR11MB4241.namprd11.prod.outlook.com
 ([fe80::34b3:17c2:b1ad:286c%5]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 15:06:44 +0000
From:   Yanfei Xu <yanfei.xu@windriver.com>
To:     daniel@iogearbox.net, ast@kernel.org, zlim.lnx@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] bpf: avoid unnecessary IPI in bpf_flush_icache
Date:   Tue,  1 Jun 2021 23:06:25 +0800
Message-Id: <20210601150625.37419-2-yanfei.xu@windriver.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210601150625.37419-1-yanfei.xu@windriver.com>
References: <20210601150625.37419-1-yanfei.xu@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [60.247.85.82]
X-ClientProxiedBy: HK2PR02CA0199.apcprd02.prod.outlook.com
 (2603:1096:201:20::11) To BY5PR11MB4241.namprd11.prod.outlook.com
 (2603:10b6:a03:1ca::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pek-lpggp1.wrs.com (60.247.85.82) by HK2PR02CA0199.apcprd02.prod.outlook.com (2603:1096:201:20::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Tue, 1 Jun 2021 15:06:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41de9d90-25f4-4c76-230a-08d9250ede3a
X-MS-TrafficTypeDiagnostic: BYAPR11MB3223:
X-Microsoft-Antispam-PRVS: <BYAPR11MB322391E997C6F2F73DCBFB3BE43E9@BYAPR11MB3223.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ijsKhq16wVfpgZa4ihh4T/26pHJ7opOILW05IvXa+uX9+waZR0Db7gekGejHoGPWVIaPeCZ4yDeTa/BdDhfN3S6bT4AaNGcBE/DQ6PNwtaOGIugU28Aa7Wxm7XBFtM1JFjygfzqlD678kjJQ+3nbj86dkBEhq1m4yo1dOghQV2uZ3QCVIcj1kgYHG+wuF5Nz02cFwhRRlgFuNAS5wbIku724mbzYrqUHWiJbL6Z+i5P8blywETcsG/fc28IG5TMEgiOUJ4DXLOuP3iQ7ZRjMw/5SRpmxUQZhC7qGFEUBuT+UUUb6ezNA5ZzUAFTTlxK6cDny6yZyqsg0nO3OwInV+ESF+qx4B2Wxn+xphHL5QzOXIiz0EUBl09VhVHa8NfOyOz2zoSqax+G4wJCmy8Gb0XacVIsNkVG3xgSeWw+Miphvt3Uu0xVKbHtGsnUB8FFn8grOCebjFvCdMbpt10hfypjS/JOXxUqyS5qUAkLrW34nRZDUx0uVXnXsV7fJq5418jI+La4QunRtOKA7ir+EMlAc+idOXsqeJJtG7fEmgHjKhkML7Uim3o9XM5iY7aPdRhlFVPpp2zduO2r+PN0CpMiCPBtkdUsddOXXhLxybzdg3tIEBlnFQYpDIQkTR2oXB1y8p6Oyybbhe9vNBDLmzi8NOluoo2F6baGhl+kvDEk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4241.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(86362001)(44832011)(5660300002)(66556008)(2616005)(498600001)(83380400001)(6486002)(2906002)(36756003)(1076003)(16526019)(7416002)(4326008)(52116002)(26005)(6666004)(8676002)(66476007)(66946007)(38100700002)(8936002)(38350700002)(4744005)(186003)(6512007)(921005)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ktd/mDkyVn1RUQSR0VwWgkHGl84T9xbjGaFeyWRuMMkji4BNsHkcsUWZb0rv?=
 =?us-ascii?Q?TR+KUQ95xbiQCN4o6GipweX1O2DLjNQszjzOAyumhSuLPgicJgWRfQe8bMK+?=
 =?us-ascii?Q?a8Qhh3Cy19Rb8SDfqChw+N+RmpYzo77yzogHVHSiWepMbkVR1QeeAwpXa5+m?=
 =?us-ascii?Q?C58sXSTmhbJ1b98fPhU4ag4iuwOJwEzPwYxKSlKMiM8CK/zNU6bHkdeK1/uq?=
 =?us-ascii?Q?CjnyGNH7HncUr6WeziPAnt0X6yUofFtYIqekhj6dxTA4L9YhQ5wE70V4OEQc?=
 =?us-ascii?Q?eTfgS3hELQ9pNH1I9v3PtK7PMhsPwGjp9DdtHec2XPp7zbHHFnkH2CMbX03F?=
 =?us-ascii?Q?oTRpScCaK99aTfW37HOLlRtccmE09llXalgKmUui26Xpi29T7vAEcf4lEmGP?=
 =?us-ascii?Q?t+pgckpOC0yqr/ouGFbno33IrQk7VKeDwcu2IdQB5G0h4bc0eVIUUSuHW74j?=
 =?us-ascii?Q?8xsDQ/j2qxdc2EfXeu9NNcjpYPNISCGv301KWLDC/SHgLwZ2rxkSerLlx0Cj?=
 =?us-ascii?Q?/fP1oDTXknTz0GnhteaH+MqxWdl9WZ//VLIt9I1vEIldEJnlbeiL9BwCHv8G?=
 =?us-ascii?Q?rR3X6bUzNAyi3UMPX0kK7eRJ6y7n468jCZbynw1AqHPcyf8jexnXCYQpLgd3?=
 =?us-ascii?Q?SAvj/qF8CaPMVC5EU4ZS/P+4yyqZ9bFGoBZ0rhb1PXQXuD65FaPPL650oqTq?=
 =?us-ascii?Q?21ETRvLy6rplLXsdC1AYqKQZr2NISoxa0v2sAM3zJObidGEClN60eRubxxLn?=
 =?us-ascii?Q?CmGE8gPzvbhxw/buSdZWVjEix2hz98J67JcXP7KMRXQLZgjPOj6tNFbm9FjK?=
 =?us-ascii?Q?PK0dwuVVfAr3Ad+iqdF+buy1DjE9NMDo/p2JnVrrwgLUQ2cyzvgOeVGGUzw8?=
 =?us-ascii?Q?Rm+nHkyesDNFMjwGh30RjUSlBo/vEvFmkp/eZlnwr3lMEfZVPWVjV5t8/NJV?=
 =?us-ascii?Q?NmAyInrvi4LpW214mXYyb2mTLnUr91SfFOATw27IWMKb/EHSV9+Q7n4x/qvU?=
 =?us-ascii?Q?AVanmU2bkk13xKwSQthK+syGHwtCG3AOtbC+fNHz6sqkx8J6DBaUj2s5AWZ1?=
 =?us-ascii?Q?crO79zom+XoPZipEn8zTTv+qc1sIeN1uGk0tHX8j6LD2u4xZQvMqC3K14QVD?=
 =?us-ascii?Q?iGuvJEB5i0vUzdCWxeOQ+lRTHNlTV5VvkLSL2brQDPq9HQWggnGEolbBYp9O?=
 =?us-ascii?Q?2xnILF25F1YYiO+kpWfEwpY/57ulLswdD07vPXmmkfV1xGYX8XT6DMjMPO9n?=
 =?us-ascii?Q?sxUqAM8Coy1M5x5HLZ4B495fJS5ne208k52E29Oa/vIpEHTf4faw5TIZ6gZD?=
 =?us-ascii?Q?X7lG0JktYq+fYhafYolI15Uw?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41de9d90-25f4-4c76-230a-08d9250ede3a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4241.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 15:06:44.0985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6lV8h0hgM77YAh7jnTAtMzvCQ++juqv4VC5seq4e4oaJSmUb8ZjZU7wDoA4bKXa971Uq5RR+CW6M/mMVlwnH0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3223
X-Proofpoint-ORIG-GUID: KvOHrvp-QcMoEVrpJ5bTLjtPLb_1GwVC
X-Proofpoint-GUID: KvOHrvp-QcMoEVrpJ5bTLjtPLb_1GwVC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-01_07:2021-06-01,2021-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0
 mlxscore=0 mlxlogscore=906 suspectscore=0 priorityscore=1501 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106010102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's no need to trigger IPI for keeping pipeline fresh in bpf case.

Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
---
 arch/arm64/net/bpf_jit_comp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index f7b194878a99..5311f8be4ba4 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -974,7 +974,7 @@ static int validate_code(struct jit_ctx *ctx)
 
 static inline void bpf_flush_icache(void *start, void *end)
 {
-	flush_icache_range((unsigned long)start, (unsigned long)end);
+	__flush_icache_range((unsigned long)start, (unsigned long)end);
 }
 
 struct arm64_jit_data {
-- 
2.27.0

