Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAD9559ECC
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 18:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbiFXQp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 12:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiFXQpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 12:45:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420814DF67;
        Fri, 24 Jun 2022 09:45:55 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25OFYhvE011642;
        Fri, 24 Jun 2022 16:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=z2TwZvR0aUTw7nV6fEAAj+/7ndfdSL6V1ERImvzzG7k=;
 b=dwaiykwP5sDfWQ7RBfHwsTWcB8cqYK6X9uVtLTpPslVs15RMhJiwGvHdr9rDw+Z/Id/5
 bhp2rkXfuLBDa7PQ7fyeE0HL7Ao+3enTm9DJZ6UdIp4VH/sW+cni8D1oWZGSxqFD9mGc
 C2F/eAu5RzaPZ1/4mLbv34pAy1PoQiNy0gCWUJX4VkfSfP2exNkxufh6J3pzCQMtjqkT
 jLW9/yeog1kgutz0N6Y4mu86uDmt0ClxEQAlbbuPWEVTcOxm2OgHN4kn5GVtcKyvXWOF
 7Iaz02v1FjGhGGdiKrfVCO4qzzAFLtqGM9/JsBRLcnzLyEHYlgb1wzw3smhDMpDi7pnu Iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6kfe0bm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 16:45:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25OGUejV033875;
        Fri, 24 Jun 2022 16:45:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtd9xc0sb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jun 2022 16:45:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hsw2qt26AhXZXHqqIjUikUbuU0ZYmEIFyHCHc9C3Rcwgjsx2NOTTmqSDc3WFGRR7RZf+slE6gq4ykuV3+ZXHqCKTTXC/wKxiPlu5DzflbLfWhW5IwoxsXOXh2snv3o/jf6lO5zvJzj+aoL+xWTCRqw/ebYcMxA1CG6d0ozYWY+DjbgYapP9BF80cM3m6BX2Sev6ZfiTDyELJAdQeWDX1jbXsKwSzxvvoN0JXVRnlL4jdMANCTPwI5r43GxzvfQl26yIswFGrIFA0Cr7u/Q3X+ogwlKBzIltU83IiB2jhoPwxjzF7pvj4tImt1of+IFrJ9ANpTaFNB3uy1NAwDGg7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2TwZvR0aUTw7nV6fEAAj+/7ndfdSL6V1ERImvzzG7k=;
 b=myAk97uN+mYvuQCPqD57718Sf1+udqDsLrjkH3/Rfrlkk6Z63MDcfVW4r06Tq00SSRmYncWuJZTMJ8hE0gQNLPBM8ZlqTSlQVZ5aj/fCtY8UmxzPLOBE9RVIl3eNnJOlCIg5EYV0BqEL6xU+aFb150dZ2JlB/QGIKePenQqT+mupoiXeWEWiUghcbuGFnfYCRvGR/BYnDS5BXgkUa3uUrrEf30IHqAnatVc3yLh9aYA1F3cD99K3VeTBNLgu2N3ctGzI5MmQeGopEtArBP+OlcGpA/OMbmR5/M2a+0BO1aicDu5DO9iXQhdm9q+UIkLvGIee3+hm6IIYlEgm0V3Y8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2TwZvR0aUTw7nV6fEAAj+/7ndfdSL6V1ERImvzzG7k=;
 b=NiGCLrBlY4GTTMBoU7NJIaz5uoLhpl/6L4Nw/sHl7exZ00J7sk9Q/q+vrdvnM6fFc0RrVblcZwvXXrFzgSPxQYA1ZsKLn01S3Hi5AGvZYy5/r4LHHprQTOXg0+Ie0EdPOPkR7WNmqOP6iZQ8NT4vcgMJAV+ZsidJCu4Jh0YqlUE=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by CH0PR10MB5115.namprd10.prod.outlook.com (2603:10b6:610:c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Fri, 24 Jun
 2022 16:45:24 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::a080:c357:962c:eb5]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::a080:c357:962c:eb5%5]) with mapi id 15.20.5373.017; Fri, 24 Jun 2022
 16:45:24 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jolsa@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, mhiramat@kernel.org,
        akpm@linux-foundation.org, void@manifault.com, swboyd@chromium.org,
        ndesaulniers@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [RFC bpf-next 0/2] bpf: add a kallsyms BPF iterator
Date:   Fri, 24 Jun 2022 17:45:16 +0100
Message-Id: <1656089118-577-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0396.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18f::23) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b2f97eaa-a533-4e2c-3cbf-08da5600ef87
X-MS-TrafficTypeDiagnostic: CH0PR10MB5115:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R10Pi1SHR3CGAkUhE75bcWf3uIaGBboP0l/PEThOZPEj7baCh5xe52zr/zqt0EXSSNWfqfj+4+uw6efAtg8IQeFUudkHLIB3CKUDOqMRZ79Oy8stVVEjUYOXr94a2k6FKxJbykQCOakPcxhkXDu4SWfxA2exUv+4TZxudruSPPuCUmkTwE6l1ObtnihFh/zlkyvfavftp+s/0UGGnTjoXjO/9Ij2O3vWhwIHySU6yPR78fS2CUQhRLljkr25XvpLctLlJpCIRSzSk8nT5jzorhgOOgOTGx5QpHh6w0w5arr1W66kqI2bJzXWWwLrdO2qfYFv1Xr/WmXrO+heMUWHx3OLY3YpnCUANxExQBS7/fNM+Cvp9RqFN9h+dmuBs62v7Z+OmPNsoSUqS2dm9vWn+5MUyFfn6pW5goZdobxGhtakoZX1vAbQzqG5SuyQT261ShlYiqTZFZ9s8q7cMqqx5TJLGgIg6b1Cl5aAEjpI70VtJbb9HUNiTaI7rB+uqxsqiRcatz2qNMSB+gzLVuf8NNaBCIykttaWexTehPNmH3I7ViUe1Dgj0BVKW5inlCX6fqe+uRnHdZXHgEynwKXaGiDYXM38J2MYek2G2EDqF7NbZfpf2hfsc/Ey8Ooc8Ycw9YCwMBiHyNZPSKnn5OCWAk0jkbtltq64M6jOJnVD2M6K6ronaiJOx/BxGHLBEU1NWJZckMp1G3Gw0DhzhAXv+iEh6A7ccNUfmE7pdtoWm9+z6tB1riQ4A8opeQKoPHwO4aDuGjeIJ5+1Yt4VPGyhjHf2UomyWSiVpWTEN8wCQplG8vF0AUujcl1842SytIGm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(376002)(346002)(136003)(4326008)(8676002)(186003)(44832011)(478600001)(66476007)(4744005)(5660300002)(2906002)(66556008)(38100700002)(7416002)(66946007)(8936002)(6506007)(107886003)(52116002)(2616005)(41300700001)(6512007)(26005)(6666004)(966005)(316002)(36756003)(38350700002)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lCH997V1ZkQB9KXQKpI/chw/oIqnQCLnLKsFc7e/9rwObAVvwT9XjsXCNKPx?=
 =?us-ascii?Q?Ip8FgJnVTs4AubolOe277N1bh6GGiIKLEoeSCycD0dmZuzto5SksPDbB2/c0?=
 =?us-ascii?Q?v6XlijOArP7yh8JPiW60B9K1UG0AlFIgAd4U1CDSn3Q6a3Hxr1Jh3L+CDi0b?=
 =?us-ascii?Q?lrmNIq1tgv1KgQmMDWmZ3hMtkMKpG4CBRlZt1nmogxuP3IDGnSCSgdraxjc+?=
 =?us-ascii?Q?XngCg69r/GmoVBOXOHOsA/AEux/gYH69lJY7vgjhE8rZrVX6bQaBBsc6N3Iw?=
 =?us-ascii?Q?fb5oE++hiXaiMu3jJjS5d1DX4tIO5SEdAyyp0uJK4ltM7IjYBhX3UGD/KEEd?=
 =?us-ascii?Q?amBBxYKBzoSGJwlYZbCGxrroypuTmeJ2h8wAx8TyNhFKXJoGp4e3bG7hlqqZ?=
 =?us-ascii?Q?mg83g6EZtJGmCJYjyElcIoqt969jG9aZEc0Nu+HdaLaeuElDwdVE7mo+Iq2G?=
 =?us-ascii?Q?+luZrGjXUrDHJXbwF8w6viVceyVWtOu7lB+Y6cTeVOKOQjPePlSG6NOmsuzv?=
 =?us-ascii?Q?/Ngy3kHhpEesDz0Igobs57nHTx5mWZ3RALrh3oJqafnWPx8wlkBJevNtpc7g?=
 =?us-ascii?Q?3q6jrgNGiJQyK3tc8SyTEuMnuw6Pm9yXwVYk0sjPKRzAnaK8d7slAm8WyIzn?=
 =?us-ascii?Q?0x36yfnngS/qRr4INoqhy6HJchBVwDDrivl1GC1i9uKP5E5rPkYOWh01YKx/?=
 =?us-ascii?Q?axFQH7ua1rhqya5tO9SudVE2hj0AfmhnL0i9wTXaIyJpm9RYbqwcnxqANz6E?=
 =?us-ascii?Q?DB4gxopl8NCy9dByhq8XZpnvDuNKzGnZa80I3DJA5Sw669bUCA1VCHBe+SDA?=
 =?us-ascii?Q?0B1bXVOha+FjPZi6Sn+q4Y5TmzqMo18fOVU8ZXX+SNn/YUzixjsmbLeKl5Rq?=
 =?us-ascii?Q?yMQ1CpSkSBexDddeMe8WzTJM+VCvgraDEmM/67Pu79Zcaydb3pEnVhdHzW2u?=
 =?us-ascii?Q?CFxIjNdWb6IUx/p/dJZ4+0lIiixLJZ9tb4nUuvo+7DUk8yKIhu0ZndHJW6ch?=
 =?us-ascii?Q?hSLy5U5YzeFZrF0II5G2RJFfjlMsGqBwT9vOKscBTQsoTdRK0AwKfO0pN2bT?=
 =?us-ascii?Q?NAtwgghCAGnpQKLl58ayqEXxNpQmB6jpo7WpZjCsyk3lzBPV1Zn1Bx6YwUeU?=
 =?us-ascii?Q?sOsFkQVgJAntO9/ohp84ZUJuM0WntloOlPXp8Tso40OCu6rj3q9H4aIz/7+S?=
 =?us-ascii?Q?lbt9ZSM63PEe18TxQA0sARttji/mdTlPyFAeWensZgv4CvMRDlSXLGO5MCaT?=
 =?us-ascii?Q?hgAjUfpwJshNQkGphzhVGk3HF608BiBBrd6o8Hft6T9+b0jC1C8RG6ts57kh?=
 =?us-ascii?Q?6CGJcPpVxaAzJplZYr7emZ0PDpUQWhs1dgeeNUY7Bfs3IxODYGN74rBNUIWo?=
 =?us-ascii?Q?0ldRE+8WWs9XZERU8f3xXbesXAYBFuw/JmjE+QxLTmxw+5upDbuFWKfWXIhH?=
 =?us-ascii?Q?ijT5snkEY5tDbqY8LsUCIZ34GxYJ8iroggzqAnewM8nlyt4RxipOBGfJTQP6?=
 =?us-ascii?Q?KDwTTiQYCjo2S+3AswZP6GAcxmqe4+0P6I/vlTXjBhnmI6C6jv4Z2FAllVUB?=
 =?us-ascii?Q?JhBAJqvHP/IXitjER/JpAik94rRL1ZRFEhFnf+8H?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f97eaa-a533-4e2c-3cbf-08da5600ef87
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 16:45:24.6984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50okBtxuhLHpR4W3K3CdZ2APm8VTpa+2VWuaoxu66r/1pl8rLWaYvgHDLA/Uxz6DkWNqCz6KRHnAEcYdBUrWbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5115
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-24_08:2022-06-23,2022-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=538 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206240064
X-Proofpoint-ORIG-GUID: 3RoiHOkFWF2MG3A0L8bd34KsKtM_3M0H
X-Proofpoint-GUID: 3RoiHOkFWF2MG3A0L8bd34KsKtM_3M0H
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

a kallsyms BPF iterator would be useful as it would allow more flexible
iteractions with kernel symbols than are currently supported; it could
for example create more efficient map representations for lookup,
speed up symbol resolution etc.

The idea was initially discussed here [1].

[1] https://lore.kernel.org/all/YjRPZj6Z8vuLeEZo@krava/

Alan Maguire (2):
  bpf: add a kallsyms BPF iterator
  selftests/bpf: add a kallsyms iter subtest

 kernel/kallsyms.c                                  | 93 ++++++++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c  | 16 ++++
 .../selftests/bpf/progs/bpf_iter_kallsyms.c        | 71 +++++++++++++++++
 3 files changed, 180 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_kallsyms.c

-- 
1.8.3.1

