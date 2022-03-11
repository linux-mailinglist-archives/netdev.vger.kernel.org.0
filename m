Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530A94D6149
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344400AbiCKMMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347050AbiCKMMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:12:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38F5141FE5;
        Fri, 11 Mar 2022 04:11:33 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BBZcrE004098;
        Fri, 11 Mar 2022 12:11:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=5jF2kYrj8DqV5W8M0raDLkw8hX7kFHu9OdM920FxLC8=;
 b=C/FSc0CT5gCJfxQXtLDjMq31T6ieyux0qEcgrz3+H7l3Jhb17PzxN1qmAN2KtRUNNTYT
 J7P2UFdNMMXaa4fkNSaIKZR8NecMp5W/phjmYv89Gy2Pnp/fhD9eSZlNz35dfAk9BElQ
 TQMXdsy1adzsItO02NDNiuV6/0oXFeuXD/h6w8oQL7Jkus9s1nVVwGSRBixOjMkaTAnE
 o7SHAC5+6QE4nihCu/zU4Mqhhi7Ms1xGT6gVNPh2vgnaC/7VDG5VQ1tB8AcBtpBE8qLs
 wrrmla07o+YfOETYlCjGOdykbFxU91ah9Lt/Y3CzgUX6zRxclZHAIA1c0iJFryl0RX4D hQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0du8w9h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22BC1obs034517;
        Fri, 11 Mar 2022 12:11:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by aserp3030.oracle.com with ESMTP id 3ekwwe2s0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 12:11:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CG+LeG2GAKPFH9rJKj0iP93/kUXqzjRcV3WWmUirKRAZpNB4tvQLgDwSTSCz4fCFgVMokQ9T9ZsHPC2iX/JpN25OOdXTOgEqyOOqRkpt9eC4rsjcEyrzF8RjfPkHc17hkg/y+53NvKyaNPpeRuLuZt6dzgaIqXckWhUbEwJu3bOH983tGdBHxZQ3TG0mkVwcN5t0whdEmB5IH55j93L1/zcUf3V2a3b52jQyLqMCx5fPBq3hiANns1Y7Guys6jHILjUijdcP+OylxLZf0dlv/uDLqpq1d1gqvQo2280q29pg/X9mnpyzjax01W5HJXl3ymZPhL/NZDC1XVLCih6moQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jF2kYrj8DqV5W8M0raDLkw8hX7kFHu9OdM920FxLC8=;
 b=nvzztSMizKCsBkkein7Gy0Cx3aipLXdf2F/rOcNjqXBqq3yrdUWqPkTTvLNB8J79eyq6g9sOmMD+Uze//8Xa37yOrzEG33LzCNoX7o0F7CzqbnDNil4AJY5ajV1TKnfu4Qdi+dn2aVg9p7SCj92yuth7TDywAlHLy48bNkAFljdcntpWJE1xdv137KvfpnhUM+52o6l5XuUDVQ34EH3LKKCVys4TOBDCfqAV9M4SKvOZMx5pKaKnHrBiWmfNumysKNYwYud5j0OTNN6McJUk4EOkQR4Q+8p6zWPRDv4eFRZnCkDIEoDCl/J2IhXwVkVrdoup+kH576kk6RY1J32jOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jF2kYrj8DqV5W8M0raDLkw8hX7kFHu9OdM920FxLC8=;
 b=d0ztgn3TKWkEJnjUZzN5+k++jf+/IN0+SzPMgdr2rFNcoB7n+Jnd+TJeltf0dD+7NXYoZU56bhg8mwCJX9XSDg1CsIQQI6hLpBaploWKjFuZHs051pvV4sdLKJ7oO37zoPwX3joZNXY/+sKqqoM1sHOwMQSl9kk2DglhpS6ipeY=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 12:11:08 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::517b:68:908d:b931%3]) with mapi id 15.20.5061.024; Fri, 11 Mar 2022
 12:11:07 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        sunyucong@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v4 bpf-next 2/5] libbpf: support function name-based attach uprobes
Date:   Fri, 11 Mar 2022 12:10:55 +0000
Message-Id: <1647000658-16149-3-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0335.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18c::16) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78e706df-09c0-4aaf-3c51-08da03583921
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4784:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB478401674BB324039619B9FFEF0C9@SJ0PR10MB4784.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eshRCV3l1+YVnh0n64/GSwnGazUDI4Xf0E6AHPo8/1FRp6+NtCtD5vLWBRGenC4+wH8vA6rJoh3vu2PUfMYLB++3vfxlHJXq0XaTfXv98ILfAzJufrV1ybvxfRnVr1oAJUNeD7HQ5x/XdcPX3KWSg+dfq2c3dSU6KN4KvUqjM7Yi4FEpq/jai4jfZn77RUJZhF5qbtgJtFC3bf3CmrlJ6BDZSZ6EzUc+nywWJdNDsctyoMqnXgJMQZ3s5IW0LYbjo3NrUfksbCtKOvtsmL6Z1MBF2TEhf/h/R72pgQDpgFHZ5+pEHxrMUPc0OeW/xadcrlKTzSK8faVnixw+zx+o0TVr18PDFFauc7IKwX46XiZ6FPukzwXzHACDBdfMQqk44v1z6iC91SY4kQuSmaP0UVp2WEqwxRiwFXkggRsv2N4BMLT61bE4RE+aZFAoLLpqXu8urAE4RMHgKGAte21tBGML+hZ06XFp5i/mifq/VhB1YLrFXQ06v9pySqh2i8G7Cue4xGf4lBKLuk6bQLgbfoNH7n7ib+NoGJOPOoK7eYB2MoF9cGmpdbvBVZugyZeAcg8Nkl215Lptelhch1upi+bi7tJSYvfRxu4oFJI03iunztZkCBBmwOlSX5Ye4bON04iRLtpn5RurF0zCFCE1gm4dC+Zc2ZyVl6oC1azEoQoKv1GA6uovKabOE+YXSNfq04LowBQNWmzICBI5IMCqo6AhYCsM0nLTSSI83fsk6OHLqvRAJmSxcYAaQYH19NMfpoC2VAk9YXlg+WogHcSJjH1sZnPC4S+yf3J0dCY78VY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38350700002)(2616005)(66946007)(36756003)(7416002)(966005)(83380400001)(316002)(38100700002)(30864003)(6666004)(86362001)(508600001)(5660300002)(44832011)(6506007)(8936002)(52116002)(26005)(6512007)(186003)(2906002)(107886003)(66476007)(8676002)(4326008)(6486002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SGa/ad40t4IYk3OpfIhHP7D5xP62RuZsQ7m8dh5s1J6b92qsurNGmeDBSRDj?=
 =?us-ascii?Q?MUwlLsDuyDYGReEnKLL8u5y0vA0ja0dY+twD65lEjSIhJXAYSzylPl39Jo4e?=
 =?us-ascii?Q?2pLx6cpg92JZHQc3gkF/C7+p0a2dmpu5f70kJqNM5pPpTYNwWHrOcm2A0n8R?=
 =?us-ascii?Q?l7bcn/9t0jBvgzFnya6kkpD7Wr22zY5h0i73tF75E7h7nfM5F5ggeIT2lLaT?=
 =?us-ascii?Q?/7V/4B7JIY/MlGJZcwB3H1oAWAEAlsKrqo08Fthrhx+ThQg7OXAD6vzeohL7?=
 =?us-ascii?Q?953wsbSHBMk9rK64nHYi4f0P5aeT+OH+vwx0u7hgcI84upd0Th6OReAEyY/7?=
 =?us-ascii?Q?53V7dvrLMqsRk9jhyzhY8FlWZdCfcoakZQwC32IeiV+Xj2Oe9yw2iT86vL+y?=
 =?us-ascii?Q?2JR0UinQtTmedzJaYoiwbxrNPlcU9Jm5vqJGikKy95OpRUU9fFl5XWGgLV7f?=
 =?us-ascii?Q?I07nc3nLdPM8z/U91F2ohI0/dn56P2v3ZNPxcJiJwwUdNM9+LXiWluTa6w4J?=
 =?us-ascii?Q?FU5S3Xv/ibEQtch5CPEFz/QTZ7HfC38hkhXIbYtPLZbiWuBSHOub5m36vgjI?=
 =?us-ascii?Q?8RASmmEvpZPLN9/1CtLep3cTQWT3biJ+OY9GRD9gHjxhnYYQ/EoDOt3nxGEd?=
 =?us-ascii?Q?rwXuxXHBosMa0eisi8JccjgSDIyJeZDPNSkLUSS/1Wwwa946neBLaRp9G4ju?=
 =?us-ascii?Q?jgU4XHTs7F0RwrJsZEYNw53JJ5tCGcvHIEl0ViHRT8a7ElGTPRs+dJp89mew?=
 =?us-ascii?Q?aZsw1ykiK4mHbByCrVauh07WngMDXh4oCkVmttONy37+ermc2nP0DysgUajC?=
 =?us-ascii?Q?ZJxl6LiWNLWzrvyS2NfsrlzRc6a+9/VXwpF/jwx9/yqQDGvFUsfJB8xgQ25C?=
 =?us-ascii?Q?p9NflTorR2LPh8Uf84k4j05HqNhSlHb7vKFynh9aEEo87vyVNV/H+Gkxuo9Q?=
 =?us-ascii?Q?1nJlE/N8rJGczR3tmjwy5dIp5d/W4iUFsPTs9TKf//wj2RPt3akdBWbxfx4Z?=
 =?us-ascii?Q?XnA6FRgAWOWcNCbD88ygRLgM7w4kray8/yI8jWIXLBF2P4OSAH/ZW0I+EYPQ?=
 =?us-ascii?Q?Qqd1TgaVERLpjpGRy1/oTFyllCc199Uy7HCET/zQo3s4Frsxiec69o8kkuOh?=
 =?us-ascii?Q?oXczWNUiZjHS1OL0S+QFFAXSVK14U1o67y7+I1ymTmkw4XFAKvkYiueHBR+E?=
 =?us-ascii?Q?lJ8hhjMBslmByRe6AhAT7VRv9X6t/OWWICjyN8Yk7+NhjXOKl7BHzoNq8q9w?=
 =?us-ascii?Q?XsmMVMoRFOTpGe5OCJKnEQP2nE5Qo8yyDn0guctDKKmWs72/g4Hm1w6MhZyp?=
 =?us-ascii?Q?pIXW2oQJaErit6hCNDhF1gyNH0mcp/JAkOasI8Y+msUTKKSbE0yfTpCj8jUY?=
 =?us-ascii?Q?5F64mvuqLMbFUTvfGB3dcfF9CFgDj+HSskak87REl7uFsTz6nr4Vb5Nc4V/i?=
 =?us-ascii?Q?GgaI54n0WiXWr+WHCKhmhhdE/kqJ5wEXlNTX3jqteh+Ug+z6/tznR95ogCAa?=
 =?us-ascii?Q?OtoWUushx0aLsBHo7+oT/M7da0+1Ge+BnfCiwXf6YoyvenecZGw8c7LLQfK9?=
 =?us-ascii?Q?yUouDgC29pNdAZUJKiFGzqrXXsR631L4epQ+ePnNTskL1fZzqIiq2PjKuw0w?=
 =?us-ascii?Q?ddRf2Yz8cd3Y4D2R1+GjzmM=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e706df-09c0-4aaf-3c51-08da03583921
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:11:07.8705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pMTrC8t0K17wNk04HnLYSYi787CLdbSO6bI2dIv04zMXGwj4FpOk8f6jAYv6YtdAP7DDJDUBx5Gw9xtxbQyKmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10282 signatures=692556
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110059
X-Proofpoint-ORIG-GUID: b0pYeu4J0mzmNYf-uCuYXBFPPtstNWre
X-Proofpoint-GUID: b0pYeu4J0mzmNYf-uCuYXBFPPtstNWre
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

kprobe attach is name-based, using lookups of kallsyms to translate
a function name to an address.  Currently uprobe attach is done
via an offset value as described in [1].  Extend uprobe opts
for attach to include a function name which can then be converted
into a uprobe-friendly offset.  The calcualation is done in
several steps:

1. First, determine the symbol address using libelf; this gives us
   the offset as reported by objdump
2. If the function is a shared library function - and the binary
   provided is a shared library - no further work is required;
   the address found is the required address
3. If the function is a shared library function in a program
   (as opposed to a shared library), the Procedure Linking Table
   (PLT) table address is found (it is indexed via the dynamic
   symbol table index).  This allows us to instrument a call
   to a shared library function locally in the calling binary,
   reducing overhead versus having a breakpoint in global lib.
4. Finally, if the function is local, subtract the base address
   associated with the object, retrieved from ELF program headers.

The resultant value is then added to the func_offset value passed
in to specify the uprobe attach address.  So specifying a func_offset
of 0 along with a function name "printf" will attach to printf entry.

The modes of operation supported are then

1. to attach to a local function in a binary; function "foo1" in
   "/usr/bin/foo"
2. to attach to a shared library function in a binary;
   function "malloc" in "/usr/bin/foo"
3. to attach to a shared library function in a shared library -
   function "malloc" in libc.

[1] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html

Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/lib/bpf/libbpf.c | 310 +++++++++++++++++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h |  10 +-
 2 files changed, 319 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b577577..2b50b01 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -10320,6 +10320,302 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
 	return pfd;
 }
 
+/* uprobes deal in relative offsets; subtract the base address associated with
+ * the mapped binary.  See Documentation/trace/uprobetracer.rst for more
+ * details.
+ */
+static long elf_find_relative_offset(Elf *elf, long addr)
+{
+	size_t n;
+	int i;
+
+	if (elf_getphdrnum(elf, &n)) {
+		pr_warn("elf: failed to find program headers: %s\n",
+			elf_errmsg(-1));
+		return -ENOENT;
+	}
+
+	for (i = 0; i < n; i++) {
+		int seg_start, seg_end, seg_offset;
+		GElf_Phdr phdr;
+
+		if (!gelf_getphdr(elf, i, &phdr)) {
+			pr_warn("elf: failed to get program header %d: %s\n",
+				i, elf_errmsg(-1));
+			return -ENOENT;
+		}
+		if (phdr.p_type != PT_LOAD || !(phdr.p_flags & PF_X))
+			continue;
+
+		seg_start = phdr.p_vaddr;
+		seg_end = seg_start + phdr.p_memsz;
+		seg_offset = phdr.p_offset;
+		if (addr >= seg_start && addr < seg_end)
+			return addr - seg_start + seg_offset;
+	}
+	pr_warn("elf: failed to find prog header containing 0x%lx\n", addr);
+	return -ENOENT;
+}
+
+/* Return next ELF section of sh_type after scn, or first of that type
+ * if scn is NULL, and if name is non-NULL, both name and type must match.
+ */
+static Elf_Scn *elf_find_next_scn_by_type_name(Elf *elf, int sh_type, const char *name,
+					       Elf_Scn *scn)
+{
+	size_t shstrndx;
+
+	if (name && elf_getshdrstrndx(elf, &shstrndx)) {
+		pr_debug("elf: failed to get section names section index: %s\n",
+			 elf_errmsg(-1));
+		return NULL;
+	}
+
+	while ((scn = elf_nextscn(elf, scn)) != NULL) {
+		const char *sname;
+		GElf_Shdr sh;
+
+		if (!gelf_getshdr(scn, &sh))
+			continue;
+		if (sh.sh_type != sh_type)
+			continue;
+
+		if (!name)
+			return scn;
+
+		sname = elf_strptr(elf, shstrndx, sh.sh_name);
+		if (sname && strcmp(sname, name) == 0)
+			return scn;
+	}
+	return NULL;
+}
+
+/* For Position-Independent Code-based libraries, a table of trampolines (Procedure Linking Table)
+ * is used to support resolution of symbol names at linking time.  The goal here is to find the
+ * offset associated with the jump to the actual library function, since consumers of the
+ * library function within the binary will jump to the plt table entry (malloc@plt) first.
+ * If we can instrument that .plt entry locally in the specific binary (rather than instrumenting
+ * glibc say), overheads are greatly reduced.
+ *
+ * However, we need to find the index into the .plt table.  There are two parts to this.
+ *
+ * First, we have to find the index that the .plt entry (malloc@plt) lives at.  To do that,
+ * we use the .rela.plt table, which consists of entries in the same order as the .plt,
+ * but crucially each entry contains the symbol index from the symbol table.  This allows
+ * us to match the index of the .plt entry to the desired library function.
+ *
+ * Second, we need to find the address associated with that indexed .plt entry.
+ * The .plt section provides section information about the overall section size and the
+ * size of each .plt entry.  However prior to the entries themselves, there is code
+ * that carries out the dynamic linking, and this code may not be the same size as the
+ * .plt entry size (it happens to be on x86_64, but not on aarch64).  So we have to
+ * determine that initial code size so we can index into the .plt entries that follow it.
+ * To do this, we simply subtract the .plt table size (nr_plt_entries * entry_size)
+ * from the overall section size, and then use that offset as the base into the array
+ * of .plt entries.
+ */
+static ssize_t elf_find_plt_offset(Elf *elf, size_t sym_idx)
+{
+	long plt_entry_sz, plt_sz, plt_base;
+	Elf_Scn *rela_plt_scn, *plt_scn;
+	size_t plt_idx, nr_plt_entries;
+	Elf_Data *rela_data;
+	GElf_Shdr sh;
+
+	/* First get .plt index and table size via .rela.plt */
+	rela_plt_scn = elf_find_next_scn_by_type_name(elf, SHT_RELA, ".rela.plt", NULL);
+	if (!rela_plt_scn) {
+		pr_debug("elf: failed to find .rela.plt section\n");
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+	if (!gelf_getshdr(rela_plt_scn, &sh)) {
+		pr_debug("elf: failed to get shdr for .rela.plt section\n");
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+	rela_data = elf_getdata(rela_plt_scn, 0);
+	if (!rela_data) {
+		pr_debug("elf: failed to get data for .rela.plt section\n");
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+	nr_plt_entries = sh.sh_size / sh.sh_entsize;
+	for (plt_idx = 0; plt_idx < nr_plt_entries; plt_idx++) {
+		GElf_Rela rela;
+
+		if (!gelf_getrela(rela_data, plt_idx, &rela))
+			continue;
+		if (GELF_R_SYM(rela.r_info) == sym_idx)
+			break;
+	}
+	if (plt_idx == nr_plt_entries) {
+		pr_debug("elf: could not find sym index %ld in .rela.plt section\n",
+			 sym_idx);
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+
+	/* Now determine base of .plt table and calculate where entry for function is */
+	plt_scn = elf_find_next_scn_by_type_name(elf, SHT_PROGBITS, ".plt", NULL);
+	if (!plt_scn || !gelf_getshdr(plt_scn, &sh)) {
+		pr_debug("elf: failed to find .plt section\n");
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+	plt_base = sh.sh_addr;
+	plt_entry_sz = sh.sh_entsize;
+	plt_sz = sh.sh_size;
+	if (nr_plt_entries * plt_entry_sz >= plt_sz) {
+		pr_debug("elf: failed to calculate base .plt entry size with %ld plt entries\n",
+			 nr_plt_entries);
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+	plt_base += plt_sz - (nr_plt_entries * plt_entry_sz);
+
+	return plt_base + (plt_idx * plt_entry_sz);
+}
+
+/* Find offset of function name in object specified by path.  "name" matches
+ * symbol name or name@@LIB for library functions.
+ */
+static long elf_find_func_offset(const char *binary_path, const char *name)
+{
+	int fd, i, sh_types[2] = { SHT_DYNSYM, SHT_SYMTAB };
+	bool is_shared_lib, is_name_qualified;
+	size_t name_len, sym_idx = 0;
+	char errmsg[STRERR_BUFSIZE];
+	long ret = -ENOENT;
+	GElf_Ehdr ehdr;
+	Elf *elf;
+
+	fd = open(binary_path, O_RDONLY | O_CLOEXEC);
+	if (fd < 0) {
+		ret = -errno;
+		pr_warn("failed to open %s: %s\n", binary_path,
+			libbpf_strerror_r(ret, errmsg, sizeof(errmsg)));
+		return ret;
+	}
+	elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
+	if (!elf) {
+		pr_warn("elf: could not read elf from %s: %s\n", binary_path, elf_errmsg(-1));
+		close(fd);
+		return -LIBBPF_ERRNO__FORMAT;
+	}
+	if (!gelf_getehdr(elf, &ehdr)) {
+		pr_warn("elf: failed to get ehdr from %s: %s\n", binary_path, elf_errmsg(-1));
+		ret = -LIBBPF_ERRNO__FORMAT;
+		goto out;
+	}
+	/* for shared lib case, we do not need to calculate relative offset */
+	is_shared_lib = ehdr.e_type == ET_DYN;
+
+	name_len = strlen(name);
+	/* Does name specify "@@LIB"? */
+	is_name_qualified = strstr(name, "@@") != NULL;
+
+	/* Search SHT_DYNSYM, SHT_SYMTAB for symbol.  This search order is used because if
+	 * the symbol is found in SHY_DYNSYM, the index in that table tells us which index
+	 * to use in the Procedure Linking Table to instrument calls to the shared library
+	 * function, but locally in the binary rather than in the shared library itself.
+	 * If a binary is stripped, it may also only have SHT_DYNSYM, and a fully-statically
+	 * linked binary may not have SHT_DYMSYM, so absence of a section should not be
+	 * reported as a warning/error.
+	 */
+	for (i = 0; i < ARRAY_SIZE(sh_types); i++) {
+		size_t nr_syms, strtabidx, idx;
+		Elf_Data *symbols = NULL;
+		Elf_Scn *scn = NULL;
+		int last_bind = -1;
+		const char *sname;
+		GElf_Shdr sh;
+
+		scn = elf_find_next_scn_by_type_name(elf, sh_types[i], NULL, NULL);
+		if (!scn) {
+			pr_debug("elf: failed to find symbol table ELF sections in '%s'\n",
+				 binary_path);
+			continue;
+		}
+		if (!gelf_getshdr(scn, &sh))
+			continue;
+		strtabidx = sh.sh_link;
+		symbols = elf_getdata(scn, 0);
+		if (!symbols) {
+			pr_warn("elf: failed to get symbols for symtab section in '%s': %s\n",
+				binary_path, elf_errmsg(-1));
+			ret = -LIBBPF_ERRNO__FORMAT;
+			goto out;
+		}
+		nr_syms = symbols->d_size / sh.sh_entsize;
+
+		for (idx = 0; idx < nr_syms; idx++) {
+			int curr_bind;
+			GElf_Sym sym;
+
+			if (!gelf_getsym(symbols, idx, &sym))
+				continue;
+
+			if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
+				continue;
+
+			sname = elf_strptr(elf, strtabidx, sym.st_name);
+			if (!sname)
+				continue;
+
+			curr_bind = GELF_ST_BIND(sym.st_info);
+
+			/* User can specify func, func@@LIB or func@@LIB_VERSION. */
+			if (strncmp(sname, name, name_len) != 0)
+				continue;
+			/* ...but we don't want a search for "foo" to match 'foo2" also, so any
+			 * additional characters in sname should be of the form "@@LIB".
+			 */
+			if (!is_name_qualified && strlen(sname) > name_len &&
+			    sname[name_len] != '@')
+				continue;
+
+			if (ret >= 0) {
+				/* handle multiple matches */
+				if (last_bind != STB_WEAK && curr_bind != STB_WEAK) {
+					/* Only accept one non-weak bind. */
+					pr_warn("elf: ambiguous match for '%s': %s\n",
+						sname, name);
+					ret = -LIBBPF_ERRNO__FORMAT;
+					goto out;
+				} else if (curr_bind == STB_WEAK) {
+					/* already have a non-weak bind, and
+					 * this is a weak bind, so ignore.
+					 */
+					continue;
+				}
+			}
+			ret = sym.st_value;
+			last_bind = curr_bind;
+			sym_idx = idx;
+		}
+		/* The index of the entry in SHT_DYNSYM helps find .plt entry */
+		if (ret == 0 && sh_types[i] == SHT_DYNSYM)
+			ret = elf_find_plt_offset(elf, sym_idx);
+		/* For binaries that are not shared libraries, we need relative offset */
+		if (ret > 0 && !is_shared_lib)
+			ret = elf_find_relative_offset(elf, ret);
+		if (ret > 0)
+			break;
+	}
+
+	if (ret > 0) {
+		pr_debug("elf: symbol address match for '%s': 0x%lx\n", name, ret);
+	} else {
+		if (ret == 0) {
+			pr_warn("elf: '%s' is 0 in symtab for '%s': %s\n", name, binary_path,
+				is_shared_lib ? "should not be 0 in a shared library" :
+						"try using shared library path instead");
+			ret = -ENOENT;
+		} else {
+			pr_warn("elf: failed to find symbol '%s' in '%s'\n", name, binary_path);
+		}
+	}
+out:
+	elf_end(elf);
+	close(fd);
+	return ret;
+}
+
 /* Get full path to program/shared library. */
 static int resolve_full_path(const char *file, char *result, size_t result_sz)
 {
@@ -10371,6 +10667,7 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
 	size_t ref_ctr_off;
 	int pfd, err;
 	bool retprobe, legacy;
+	const char *func_name;
 
 	if (!OPTS_VALID(opts, bpf_uprobe_opts))
 		return libbpf_err_ptr(-EINVAL);
@@ -10387,6 +10684,19 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
 		}
 		binary_path = full_binary_path;
 	}
+	func_name = OPTS_GET(opts, func_name, NULL);
+	if (func_name) {
+		long sym_off;
+
+		if (!binary_path) {
+			pr_warn("name-based attach requires binary_path\n");
+			return libbpf_err_ptr(-EINVAL);
+		}
+		sym_off = elf_find_func_offset(binary_path, func_name);
+		if (sym_off < 0)
+			return libbpf_err_ptr(sym_off);
+		func_offset += (size_t)sym_off;
+	}
 
 	legacy = determine_uprobe_perf_type() < 0;
 	if (!legacy) {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c1b0c2e..85c93e2 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -436,9 +436,17 @@ struct bpf_uprobe_opts {
 	__u64 bpf_cookie;
 	/* uprobe is return probe, invoked at function return time */
 	bool retprobe;
+	/* name of function name or function@@LIBRARY.  Partial matches
+	 * work for library functions, such as printf, printf@@GLIBC.
+	 * To specify function entry, func_offset argument should be 0 and
+	 * func_name should specify function to trace.  To trace an offset
+	 * within the function, specify func_name and use func_offset
+	 * argument to specify argument _within_ the function.
+	 */
+	const char *func_name;
 	size_t :0;
 };
-#define bpf_uprobe_opts__last_field retprobe
+#define bpf_uprobe_opts__last_field func_name
 
 /**
  * @brief **bpf_program__attach_uprobe()** attaches a BPF program
-- 
1.8.3.1

