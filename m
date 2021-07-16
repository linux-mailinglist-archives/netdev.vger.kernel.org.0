Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9A53CBF78
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 00:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238143AbhGPWvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 18:51:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:11790 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232532AbhGPWuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 18:50:40 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16GMgMDH018473;
        Fri, 16 Jul 2021 22:47:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=OPGYRZbLbvgxjBvp1yPnTyrAZTPmMfZi+IkyAmqF8v4=;
 b=Vrlck8ghH8AP1YL5fy/lWOXQpdF7cGD5btOBwni4eP3gsa+r0EbOn3Madklv+2MH8H9m
 o26k85qBO5IRdi1zIemqJWcjr9U5nd4UKbUWPlj7MO6fM6+9RtB6l5Egb2ytuee3KMaH
 8VtiBcGoWCtuPQVXff9NVsNnM0iTUT5Y7kt1Cj0pLksjS5ekC6hWWkucX2FM2xtCoEGN
 10VwBAi1QbpIrsMRNkmDoZTIWqCzKXsA/r9E/jpkSXOYNFo60z+Z3sZ26PJuZb/K6Hsl
 kfsIWL2q+ZF2ItOnVrE8ihjy/hncEMCN7UIkn5MOv/PaUts9EpLX0BTGvfu+lsnA/Hha Vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=OPGYRZbLbvgxjBvp1yPnTyrAZTPmMfZi+IkyAmqF8v4=;
 b=kA0JM9RPwPdxX+VUGEE2osx3BJ40N4Gh6adB5hffLOgn4JJYud7wzfZB1Td8U8HhwBLO
 j+EMd38UCUq/+6VLdBiZv4M6yDUngEMlQcFkPs4g70hwcxSlXQxG7w+qul7o3Y8iBxoB
 E/bFg7mCk2TVVnBE62QXqh5KGo75iuzbfrdpzhlx+vu8jG2oVy1PSBrpn4SaxNaQmdkz
 a4CWl16iVUlw5JQu+1EgAeflQvKohQMHohaJLX1UL7icZKmTj1Seaz2RM+jWB+j/d1lP
 01xKYIF5NiD8GSuRItiBoo0jYSj5HWBJDp7/86d9rZsnWVFS2DXaxlC2vmueUQbOD+tB tw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39tw31aa8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jul 2021 22:47:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16GMdvoW186463;
        Fri, 16 Jul 2021 22:47:16 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3020.oracle.com with ESMTP id 39twqrx9ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Jul 2021 22:47:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fvym68ZXhPdKtKKBLd5iCX8bLswpkzKAa6tublu+rJ/4/bzgVfakng1/OjCPjmY177H/ZTPyyWlDVwWJ9KiatsRuhkwKoQfH4hVgZnKqdnsIef1JxKBWFtLKyfioU3OruOrVmf4sXwma7qzreAVcJtOfQ4/8c7yh+PRjsLlrYENhTujl6hmIK/gPqGi7T6ndVpZHEpuRel5y/ifBdWNtIJV3dgdu7muOJ7xFEkUTUyGBmC96NIyqb+QYqO588p0YL2J94158XwTKowhRCIaJ0tNw+b5/QY67Lt1XN3WO0Lujo354Lgp43XvL8VS+mDIYEYmgXO6QS4VA014YxVEi9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPGYRZbLbvgxjBvp1yPnTyrAZTPmMfZi+IkyAmqF8v4=;
 b=J0DoUmv46jRrJkKf9P14bA/8tUll3ZrHnb2BDx3lYlVXvWG2YZpZxeSk7MZdvlrzNOlTjnO+cvI8Ejx22FR7oqvW4+POfwW9hzF+5yGXRPJLbFPErSQEpkUlATipbrNzyLUPEUHJucHqgoflUCMFODY73XaZ95AQDmb9WLLcABgQHPOIqxLGdmtkt7ElgrnZkVa9ULtB5wIZdr/ya/vBGDW2t1N3KGOx009+9uCips0jUfAgaDn5+/1YkowDazCY4pVqs3KTMfx+49bLadWqcWIUT0klG/iQbsa083Ewijvsss+5Tk1zdoLA2CXKVQYVAn18qrQFnzFBSL3Xwo8hPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OPGYRZbLbvgxjBvp1yPnTyrAZTPmMfZi+IkyAmqF8v4=;
 b=X++7TM8kw1YbPmzMYNyyXYnA7I/HJkwrT1Xa/0oHDClHVjIIJId3yI/61ya60d1YSseIgKGp5ZT+yHytjbdmzn5C18/lO4GHCZiWmqhaZVlTeNk6Iih8PrJV2bmveLfvxKGAAnA8I4cvKoKC83VSOizZWR9m+gF4VxzOIADgWmQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by BLAPR10MB5378.namprd10.prod.outlook.com (2603:10b6:208:328::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Fri, 16 Jul
 2021 22:47:14 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::39e8:94ec:fc2d:5a56%9]) with mapi id 15.20.4331.026; Fri, 16 Jul 2021
 22:47:14 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 2/3] libbpf: fix compilation errors on ppc64le for btf dump typed data
Date:   Fri, 16 Jul 2021 23:46:56 +0100
Message-Id: <1626475617-25984-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com>
References: <1626475617-25984-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0058.eurprd05.prod.outlook.com
 (2603:10a6:200:68::26) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.uk.oracle.com (95.45.14.174) by AM4PR0501CA0058.eurprd05.prod.outlook.com (2603:10a6:200:68::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Fri, 16 Jul 2021 22:47:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae4df6ce-cbbb-4075-3703-08d948aba7d2
X-MS-TrafficTypeDiagnostic: BLAPR10MB5378:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BLAPR10MB5378B60C740DB42988D57B38EF119@BLAPR10MB5378.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iwql+Gl/ASsR8kiHFoblWzXrsUG29jGBFHhec7IC7CyfomjIzJSjijUhLQS+dBZZoIaTcwIjG38s6QiD8qw2MY5X1nkL3GxiqVr/01vx7xpUh23VbGI8fqKxSZttH3LJX0os681xCLNZPMfDuGXAqVaapJ1rwQ9/WRdimdd/c1eMTyRg+xgB6PQf4TP9mSXE/5dB4ScsN0D1C7HLIrgf753o+Qo89dYOJCw6BgEYDGhy3nNKDCKmydMQJ7WmhHGDTiQa3CNRIKeZvQDi/BcM4P+ljT2EHWakpSMKTIZy7Ujj678Kx5C5+LNyFUdo+hvL1lF+o6ZAS4YzfmiotVS3ErSw1MziKSZ6xVj/B/4s3qAcL0i8HiBsjIpcB6tYbkqHFY/gETaRYqaD1N7oaMqHcvEYQuxjglo9RKYenRtIpmdvmEOQxqcB8t+ycFS50Vlyg8HShQNVbxBbC39Svb5vre9T4Zi5VjFcWPTYz865MRV4jUNGW/qA3guShAGoIyMdX1UrSSt18Bv8TibRKrIGvIbMYZOxKdirtPYOX1MKJZX7LLsoACzBQWC5eF1KlSK6YhVBj3aWWjz0hn3QDZkjg0WkXmzSVxDbeSGy3IV1vpMRfIHvjPf0Vm3gjWkX51E9RVJWwrtWP0Pxy1C9+yPbFGf0s33EPFsPRh3n81EfPArCpCWqaepgFj9nZmy5QR8mbd7U58nvRsYYtJbIWUCezw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(396003)(136003)(39860400002)(83380400001)(2906002)(6486002)(8936002)(36756003)(107886003)(6666004)(4326008)(5660300002)(316002)(44832011)(86362001)(38100700002)(478600001)(38350700002)(2616005)(7696005)(956004)(52116002)(8676002)(186003)(26005)(7416002)(66946007)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MNsc2FaWMtt1nCU+Zg7C3zNcx735NL0H/SA7qOJLgxCkb+99kxP3XgRZ/qkV?=
 =?us-ascii?Q?20u8xJmr7iQxqyUKbZAmVyfs5ZSUM1ywtAmay1y/awRPA2sEcabbdT5406fk?=
 =?us-ascii?Q?G37/uL2SUeAGKLFJbNt2vvCrBsIcVQ7rQ5NUuHUkH7hTUdhLtLzwtlwTb9kL?=
 =?us-ascii?Q?T5VhXnH8uThY/igmLdh13iA9qdM5RrbVsQV+cEse+w5W0RXcxC1EHZNwjrg6?=
 =?us-ascii?Q?tJtJMf+/zEzoEFIT2F99PqKdJZ2EL+aENeqDmsrTCUOqF227F42UWVqkiyDz?=
 =?us-ascii?Q?sntRw0cHA3sT1YCOoHexyLPM8wEzcKZLFOGiHzhHsvpLZZdrr7RFegR1mcGS?=
 =?us-ascii?Q?V2VPgdcQ8IptdHPVBbzaFuU3nSlrbkXVUWDQT7iYjKVjwYjDeBbQClbXQ2Uq?=
 =?us-ascii?Q?Wqj2ZpYYXZvUdYcOg19JqTyLcdHK4Gs/hJXfoTbVm+KGEmYxOs/QXLQoMEqB?=
 =?us-ascii?Q?4g7DuA8NafnTiFZd6Kt0fhoQrf2ifcA1zOPlNvKC3+JzqQaPbPTlHIjgiGoW?=
 =?us-ascii?Q?VWypUBX/EHVGzmwQ+avR45wrTvdGrAXq0dZVOj6Wk8gIIcyHhuq3ZzUQPXOx?=
 =?us-ascii?Q?r/AzpORPY7RL64miShTchN7UwoI1qjjsHmihKfk/28Um/+i0emIKidz+hZ7Z?=
 =?us-ascii?Q?VNQj8e+FVbm3aJCovJ7L2Q2PgVOJpUPnHSN6pQ4MWbCt5HDYx5bElErk3DNq?=
 =?us-ascii?Q?IPeRaxtV/Bl5P3THjH6/bYKUvkNIIAQD0NjC4wBHJFRc69SB4y9Mh7JGTfWn?=
 =?us-ascii?Q?z6If2ZoWirG2wT8V7icoY5KrEiCRc4GC36fPHlVPqKS154yaI8wgwDD+jAn2?=
 =?us-ascii?Q?3kAjNoUyMVPKzQPfLprYPG6WUMGfwXqXhYv+IuI5XI+DiiLonFP2ceVynLv6?=
 =?us-ascii?Q?S14JUMzUW2Y05qL4RsNaPVo4mG2XFVMvAwBo+txqrC+xjpW0+pik3yr/GCi9?=
 =?us-ascii?Q?fwBOnjqVuZPnEX9lROCVRU9LjODPEifNIBG9Hk+2HnU6eVAsLtQEgtGJ4RKO?=
 =?us-ascii?Q?OyW/owL6FBQvEy/Q9jxIumuZF1+948nPO5G3Iwy7U47XpMi8Ggwi+dgf5Dpl?=
 =?us-ascii?Q?1xlVfndOrA+fQ21jLzl/eCu6FdeMXMraiCJXasEJFIES4pVbUaYI9qnLN5BD?=
 =?us-ascii?Q?DcgAc4CbQngzOlm8NufPUfO4T1dA28vXHzrTHgy8NeHJ91OJGvWg/LG69odL?=
 =?us-ascii?Q?ndvG/U/GohwPWeSJuPU/70ICsjmSUr9QAgDva7Ultnqv728djlHoZGeruG23?=
 =?us-ascii?Q?RzE4dfqzfiCkHm7N6l5JPcYQd8ejx9ET5uZKCusGgQ8t03552DXmkdwQ07LQ?=
 =?us-ascii?Q?i5B2dyqjTe1VDKGswYUZ0xlq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4df6ce-cbbb-4075-3703-08d948aba7d2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 22:47:14.3806
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYN76g9iq+qHligNcBGRg8EuGd5QL7oOTyfbzjrasQz2rfG+G6zrLVwhUJSXHE9q4nztAeELUQ4m0bpReUXD8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5378
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10047 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107160145
X-Proofpoint-GUID: sMz9LGtBvGNgX9sPzKeXxc5SELJyURGE
X-Proofpoint-ORIG-GUID: sMz9LGtBvGNgX9sPzKeXxc5SELJyURGE
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii reports:

"ppc64le arch doesn't like the %lld:

 In file included from btf_dump.c:22:
btf_dump.c: In function 'btf_dump_type_data_check_overflow':
libbpf_internal.h:111:22: error: format '%lld' expects argument of
type 'long long int', but argument 3 has type '__s64' {aka 'long int'}
[-Werror=format=]
  111 |  libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
      |                      ^~~~~~~~~~
libbpf_internal.h:114:27: note: in expansion of macro '__pr'
  114 | #define pr_warn(fmt, ...) __pr(LIBBPF_WARN, fmt, ##__VA_ARGS__)
      |                           ^~~~
btf_dump.c:1992:3: note: in expansion of macro 'pr_warn'
 1992 |   pr_warn("unexpected size [%lld] for id [%u]\n",
      |   ^~~~~~~
btf_dump.c:1992:32: note: format string is defined here
 1992 |   pr_warn("unexpected size [%lld] for id [%u]\n",
      |                             ~~~^
      |                                |
      |                                long long int
      |                             %ld

Cast to size_t and use %zu."

Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/btf_dump.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 814a538..e5fbfb8 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -2011,8 +2011,8 @@ static int btf_dump_type_data_check_overflow(struct btf_dump *d,
 	__s64 size = btf__resolve_size(d->btf, id);
 
 	if (size < 0 || size >= INT_MAX) {
-		pr_warn("unexpected size [%lld] for id [%u]\n",
-			size, id);
+		pr_warn("unexpected size [%zu] for id [%u]\n",
+			(size_t)size, id);
 		return -EINVAL;
 	}
 
-- 
1.8.3.1

