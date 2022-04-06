Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73F8D4F62C0
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbiDFPU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbiDFPUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:20:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B630564C189;
        Wed,  6 Apr 2022 05:20:02 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2369nGrX000758;
        Wed, 6 Apr 2022 11:44:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=oqp/rS4IHmgqeRkUDMyUEtKlIVxo3cx+mDHiIQ/O9ZA=;
 b=Su0vLzMd75AkUXzkfXtY76QpsYWAaG3xfi4sVsh9EyDVCrAFKyp7tJKNs6AU5VAQI2PI
 2oG2KwslWXwZ6BpqCqXJi+QwZgNlBc21zzge1t3Y4FwZIK3J8qYLl2x0jpQHRL8OyR7k
 mTQ0/4Mj1yKXqNtmOlnNetc07kAl3VYvffK91EVQSD97D2xPaEjMbyGwKTCRyevjpSHV
 uK1z+LWOu4zAZEncjRd2AksRADq08onXjmrAxHYQopnSqQzHHbokx87+YG8h6zaNkc36
 X/kFVBreYOSDO3BNP7RxelKWC69TSAX6qZ17HN3Eh+TfJigisiuUHqoSQohlw06U1Hi4 3g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3srky3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 11:43:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 236BeWGj040819;
        Wed, 6 Apr 2022 11:43:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3f9802mrf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Apr 2022 11:43:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FY9Pf9dGLJts7MceWzQMdGgkccGj962UTzbDO3bRuDknLF7rQTCxcW7PwQ57k7Oj4MVO2Id6ITfoiC0bRRX5IXZS1y4cmoX+g+1zUVBOI7OS996G0l6jEFwi5ryo+CFJE2PLcPeL7+F43THrvFJihEngFH1WuqmHntFZMU6KwVHSnZyU0xDomZxtjQVXyFUAlIhdFG7pnxzSyxQ2+RJ35c22zwEi9EeMzL99OZnvgKQlMDj0b/GdaPkCYtxOHCJN2+pO1UEsbhQZ2DBxArKAge7itxqAg/Xi1ccyjDeDeWpEekGb5lXdWCtaqxFeHiuS5DbWkDLsByQbSPqAldet4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oqp/rS4IHmgqeRkUDMyUEtKlIVxo3cx+mDHiIQ/O9ZA=;
 b=eHfvRGWiF4z3N+I/XLBzhewPTUssFk4+PKS+7aEHAwod1oeaHWUy+phDbaOXCXHtsIcT6hWzKWo6MsYAnleNbIcPxGeDSpGxlQWu2xPXxMz9NdxeoAta5PTt6Af3S0XyDeKoJ8nGb7sF8nHZvRQpvYO6rnTqSM8o2zxfFcNIR/VupApIvo4TDaWH/LvcYeBACwaF116G0JdyQsswhmkaIwl/+ZoQXTH4rX84A1w5xgL7L7KQORketX3fkooS4BiUUWN/Yi1R4g29tqM9VEacI6jlta2D5dCjw1fngAQDyZRwRgjrXEOgTMdKbTuwUrolAdtsqqIInMSm70WEgtBKdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oqp/rS4IHmgqeRkUDMyUEtKlIVxo3cx+mDHiIQ/O9ZA=;
 b=hKLiUcjo2+OqI7KkUDxlO+6ZXqeM/mJhGWSfGp6HLCZHKwR4nXtKOkKjkTkRull0FtyKmpJhE8OF8827Il3/SetfSgM2yLMsCeuSrhkioCOzm65fZnUkIPkPEw8M9ldsi4AWu4m57EkMqpfCkKCI56kLKrDlVxSGz4QHwYp+yzU=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM5PR1001MB2409.namprd10.prod.outlook.com (2603:10b6:4:33::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 11:43:57 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%3]) with mapi id 15.20.5144.019; Wed, 6 Apr 2022
 11:43:57 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 0/3] libbpf: uprobe name-based attach followups
Date:   Wed,  6 Apr 2022 12:43:48 +0100
Message-Id: <1649245431-29956-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0073.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::14) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 969aa0e2-8d52-4e81-752f-08da17c2bbb5
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2409:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB24097E25135E924ADF8764E0EFE79@DM5PR1001MB2409.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRCarQ8Mp5O63s7zej/OHB3esxVOuWlesBIaXOSuW+zWUwwYdH0zLoeSC3UYT1loq7yMVznXDwwHHBRCs0TRz0y3w2oTEyBqTLbGemtl1FlAeob8YsutpX5gf6mbLwTZHbQ77/gHAa8lzGT6TcRoScubf8BwYMwHj3MNilRqO0MgiqcdLQ/3LSCmAo9mbqObWuceK7xCMhYIHRyeQcmHB21G3PnOPDEs2lcaOjYjEzV4Jskt9lPqJLUXPmMiG7HtoBWstvKUadCi91geWNrfmcjRqH0i4/weQf/yL6BSTBJXd6x/Ow9mqLPSN54tOwATTk2dmwGYZMeWpK3zPLaZnlSUmp21E92f/XZvxGC43WvBQb6wYbBEGjHuNwDH3h14WL+Pk+/EuRHbhELcBpSyIlbdQicjeGTP7uCiQfo3JLHF0i8t0OLwZTj3pGqy1qIKi8gRHDSiqwgzSUm61D+a5p7z6Mf7Bl+PPG+cF1eaHHiaH9xNvTnS6f4PnYrfVc5CvSLszaZgHmLR75iTrfl3tCl2dSbhMlJVKQT8W3RRkquIz9H0iw6Yz6WBHMI6nJjNZw8G/qs5A5Xdpjb+BoD3KKDo5NjL8qQgGsYAhNe2UE5O/lb1v+1LzoIEJF/1tkJFxiPMJmQJ8KeFFbwQ3yE+2ORELS5yElHuYLKqa9mg3Eo9iUiXbIvqKKwJgvFPIhFNJoNCRU/PPpMnqQIqvNWD+c1RqUGRe/SgdilAwBcdrmR0x98o3ksrCOSrt3aafQZAsUHb5Zye5bULHwBCwuxdayIH6n5KlBDHFOIVFD4gIUw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38350700002)(86362001)(8676002)(4326008)(66476007)(66556008)(316002)(2906002)(66946007)(186003)(5660300002)(8936002)(7416002)(44832011)(2616005)(107886003)(26005)(83380400001)(508600001)(6486002)(966005)(6666004)(6506007)(6512007)(52116002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Stg+1/09SyPEm8XT4mrV9nlZSjDWeXNJA+Zo1yrJ5ICe5ywYtVyPY9u/XAdN?=
 =?us-ascii?Q?yNB/6ma+iDHZrOpRdUbVFo8FLK8iUqXs8rvBip6DWJOK9tIqWeDkFuRruv0E?=
 =?us-ascii?Q?VxxckcuNtTaYoZgYJXeHiEGZWIFZXNeo4LLyL2soHLozhr6b2WbSZUvQ0SJQ?=
 =?us-ascii?Q?p2xYiiLR2XBtAgNp4T0gNQZaWRKSlYlvuVzoVsq64HWXRprBW7IWV5Nu8P+E?=
 =?us-ascii?Q?c/4Xm8Zwh7Beh113kOweAgtVIYNpMu3NP2rccUd4G8rFAOSFkhZtPCM2vypG?=
 =?us-ascii?Q?JG9WIO7CEJ2rib0wDcZiprJqL2bQkFqCwTr1wLuDqOHFpyT9+XGpupuaN23G?=
 =?us-ascii?Q?4jc+djNwYXh8EWpQQ2GmM9+8iuWiarK6PS2IZWoC1pncQhiXQEs6R82Bdby1?=
 =?us-ascii?Q?U0l3aU/Oay33bHq+CteUdpimfv9pRfX9qRKbBfbemq7PPZXaDFxr/kb0c3f0?=
 =?us-ascii?Q?MJObX3P6ILLVZs/Bp6LK3FXFQNpnYc0P3sM+xNNgFCQiFelUyx5UGuBVnMEt?=
 =?us-ascii?Q?FyoU2mBEAiZNMR49hmBtR2Ky5hXGFHPXjBdpvE3N8wbLFXowAerGipyvODwX?=
 =?us-ascii?Q?EQoVj0h8Q/2kxniFqyeX2EfbV9RXUEvY2Z8nVbVIYbgO4PTOa61LhNQf22BK?=
 =?us-ascii?Q?7B6ZS7a349u4wHFRtKAo/2HjvHKjhfsmSviO+AOohK0s3108Ugx6qXUHjI3o?=
 =?us-ascii?Q?2bWrvgGQXsQ0BKgnBO1AE2y1hWJ65b6Oj1wqmUcPs8Cb0gJ2dJlGkdWE5Yts?=
 =?us-ascii?Q?rgSghfTkf/Kzoy/VNsQeDM1QFHZidaAhcAFT4FfIPJ4Dlfa8naX81z8WIGsU?=
 =?us-ascii?Q?j/HW6KVryK/FCN61Oz0deeS+oUUZntkvGvHf2PtJrqv/i4d0hPVh94VI+P0C?=
 =?us-ascii?Q?jvFmQrEO2YTcOd8OLa2pPrAa2MIScFgVova0zRA1cjubQ2zfYvMOb6zwrmp9?=
 =?us-ascii?Q?57pErY1piKfW546sZm/QUmIebD9/lvBTxjDPbQbc1AszFXXNtF9kzZdzvwdW?=
 =?us-ascii?Q?zyxffG2zbShPWHqbVzyW7XY5qrRVU7vN5VVz+y2ugPjd3UpsFHcTtlggtmRD?=
 =?us-ascii?Q?J7qZ2fXSxH3r1FrmOOV7YpASsvBx9sUjO5bCTDyrO0gniJrGq075idUK99ku?=
 =?us-ascii?Q?gNxCmoeNXZpjlJCQD7ggN6EaCSrdOb/8g7TmYw9h5ZBGHyxG9Szr7SDgINfF?=
 =?us-ascii?Q?oUCzjNq0RuNAZMN5RNFCjZIRjkCRy8ZaU5BtWD0H8E2zrFS8V0mY6ecTar1f?=
 =?us-ascii?Q?BkRJRSuAG9iokisnX1Tktdf4BwtKVyWWVVdyWUWWSv+4/vMoxY3ZM7J5HflE?=
 =?us-ascii?Q?uIxh9toD4DYAjpeqOGqe1CVy1CjNYMG7BCazQm7eD74YllWGOsfQZ7W5kJlO?=
 =?us-ascii?Q?6O9T8cgFV325vzjouyZ9TXvl/lXnZWYgYeowMAXun0UKGWCjMVsEhcDqt3id?=
 =?us-ascii?Q?11As5QbH3v91NZ4Y6MQBxDlz/uBQyCbm+zhIHr7sKBkM9PYRuJSNGg9YuC+I?=
 =?us-ascii?Q?U5dej9rQM3Pru8xr7GdPfZ09zUD4DkC5aXO4KAbyTJgJytvMUnUWlkcWiAYm?=
 =?us-ascii?Q?5SQYch5CE/tSMDsQelIoAzwUmKLEVSlo38jsQq3HUZC5hkJTS9NeIdwR43MT?=
 =?us-ascii?Q?bgUIkyN3hJWjmVLuhcxdnmkFlh+qzcRKfT6ksqZgNvhpIlyPOOBaLRBgQpya?=
 =?us-ascii?Q?TuYe5U7j65dNmbgtjgsumiyIF+mjU9M7u2noEN/pxcmr34SAd0LWAwGfs6t+?=
 =?us-ascii?Q?Cg4KrezHv4DVjQb3Rg2gYwV8WgSu9LU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 969aa0e2-8d52-4e81-752f-08da17c2bbb5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 11:43:56.8859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agRKulJ1gt0MAf7wYLmK9JCGKgwRfzAY+/iZSSl42AkhRTKLdW5z6Iso1DpFWo0oexP67HD3IdlEOzbZihl2Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2409
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.850
 definitions=2022-04-06_04:2022-04-06,2022-04-06 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 spamscore=0 mlxlogscore=734 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204060054
X-Proofpoint-ORIG-GUID: VbYoHWsmfANONsItYRxX-Rxw3cUMXvvw
X-Proofpoint-GUID: VbYoHWsmfANONsItYRxX-Rxw3cUMXvvw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow-up series to [1] to address some suggestions from Andrii to
improve parsing and make it more robust (patches 1, 2) and to improve
validation of u[ret]probe firing by validating expected argument
and return values (patch 3).

[1] https://lore.kernel.org/bpf/164903521182.13106.12656654142629368774.git-patchwork-notify@kernel.org/

Changes since v1:
- split library name, auto-attach parsing into separate patches (Andrii, patches 1, 2)
- made str_has_sfx() static inline, avoided repeated strlen()s by storing lengths,
  used strlen() instead of strnlen() (Andrii, patch 1)
- fixed sscanf() arg to use %li, switched logging to use "prog '%s'" format,
  used direct strcmp() on probe_type instead of prefix check (Andrii, patch 2)
- switched auto-attach tests to log parameter/return values to be checked by
  user-space side of tests. Needed to add pid filtering to avoid capturing
  stray malloc()s (Andrii, patch 3) 

Alan Maguire (3):
  libbpf: improve library identification for uprobe binary path
    resolution
  libbpf: improve string parsing for uprobe auto-attach
  selftests/bpf: uprobe tests should verify param/return values

 tools/lib/bpf/libbpf.c                             | 85 +++++++++-------------
 tools/lib/bpf/libbpf_internal.h                    | 11 +++
 .../selftests/bpf/prog_tests/uprobe_autoattach.c   | 25 +++++--
 .../selftests/bpf/progs/test_uprobe_autoattach.c   | 43 ++++++++---
 4 files changed, 96 insertions(+), 68 deletions(-)

-- 
1.8.3.1

