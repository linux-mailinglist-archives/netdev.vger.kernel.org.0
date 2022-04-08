Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B354F9FC7
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 00:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbiDHWzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 18:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbiDHWzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 18:55:21 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440305F41;
        Fri,  8 Apr 2022 15:53:16 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 238Ltbt1000752;
        Fri, 8 Apr 2022 22:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=gBAWB4wUiod0BSrcGE71qsn0gGS8kcnyfiKXw7Wa/Ss=;
 b=RUULYW4UNpHMcFLtkAh2KG0vtsSUTtU70h9+m0NDJQRsydSw2MtL6ga37ZnkDpu7/MJL
 d7m7Jy78BVloMGVSbmQviNRMIoIGeA+CDFeQ4+Jcr189VZHttTHHhkT203X656l3Wa9Z
 shREo8YND2v7vQckiM5GlYYOzDZRsn/aae1uHbhLz+hxAxh0cgryZDgNnvSfR/OaI9I6
 GvgLdgkcN0bas6qhjY9QEpeT0kWD+eDuzl5ySxF9ubth2YEX9YxBYqDXmsJRKfIwfhH1
 9dN/it1vVKkG8UEngnN/i2drDnOvbtIkijEfC8tsBOMjYXneMbO/HRhwYS4ywKuovRta Dg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3f6e3t0adm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 22:52:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 238MjYK5001071;
        Fri, 8 Apr 2022 22:52:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3f97uynks4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Apr 2022 22:52:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZtCFH5iZ3t5jQLOgu1GZocqbl7aCoq0GzH1U/pAc51TllwO11VtX9Xdu92WffSxH+gyhMVHSZ1dgnbDJm4g59idHnw0oQECffv4W+Sn3+HJvisfGXxJwCzXxT8zrDINDaJ0h4ijwDSWAS9OivlhKyhVU/oUiSYp04K0IaRjnqMesC+wO9mzWbgNbPW54oPKH9Ayo7Jm81yF03hfnpXjL5dfP/cri0suWMJ9KRiQYjppxJu8R9pWqbLoy0w51CEz0Drb1rN5dTYuR8WfDdlM0Ee7P1/1b9MFtP8is1gDnj+cTAHW4bIlN8wQIshnGWni+eFZjFPXAfZ3V0BfNAlK/wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBAWB4wUiod0BSrcGE71qsn0gGS8kcnyfiKXw7Wa/Ss=;
 b=ifOEyQMg0z0B1c8v1wU+uLrwdJweKDM9YGSuHixKl2eEoRB9flVV8lI1dAkifeGl+Yk3W4Cyww/d/1If2Xh7zXFNfRGGIQtZP8FWAtTQhwP8l2P2JyvZ8hRGSGVBxBLDadpsAOo0MpcsTLc20wlquRyq9TlB7DGOY7nNNYPlx0dp6x2a3/+KPZGkn/O8fOWnXNPfQj8IYI16ghdQZnF//zaiqQ+5KTY4AznobVjCL6+2Fnkx1+xBEaYPlVrGlCw1/I+pDlCLxev669VV0bAYfA1aNKU3LtcAlAeo+PrK7Xu9PkMthOZMsk+8r1JIiMZebpvtGdK9P77CahlATjoznA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBAWB4wUiod0BSrcGE71qsn0gGS8kcnyfiKXw7Wa/Ss=;
 b=ZHrPgQ41WM5gja+bLLx9IAplV0SQy+TBQx5GvDHSY4yC7gBXUHSNwNKTryiZVTL/eh7/EHRqjLLx4WzjHHkNIKbUIQnE7csOT4sQdBF50EcM37p8RoMzEXjB69EbWbhofzMw1awoZqlXnPgLOtTlS4MAEowV45TbZt1npo9iOd4=
Received: from BLAPR10MB5267.namprd10.prod.outlook.com (2603:10b6:208:30e::22)
 by DM6PR10MB3705.namprd10.prod.outlook.com (2603:10b6:5:155::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Fri, 8 Apr
 2022 22:52:54 +0000
Received: from BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52]) by BLAPR10MB5267.namprd10.prod.outlook.com
 ([fe80::bc05:7970:d543:fd52%4]) with mapi id 15.20.5144.027; Fri, 8 Apr 2022
 22:52:54 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     andrii@kernel.org, iii@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf-next 0/2] libbpf: usdt aarch64 support
Date:   Fri,  8 Apr 2022 23:52:44 +0100
Message-Id: <1649458366-25288-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0047.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::16) To BLAPR10MB5267.namprd10.prod.outlook.com
 (2603:10b6:208:30e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61a441d0-ffd7-4079-f12a-08da19b28400
X-MS-TrafficTypeDiagnostic: DM6PR10MB3705:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB37054C87E6AE1707909BCF8FEFE99@DM6PR10MB3705.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HCk19OmpXS1FbaIYyYJ39IjInojpjHc7oSKtf4Wcf2FqSBpWXCMYQ0GSAKA6i8u+45QSYF/wo6W6wRBjSeTGnYSkR/uk7oQcOmW7LioYTgG2ZNk7Kyvxi7Cdl419YUEiU6Yhhu4D7d5BwEDRGbCD/h8xJUUdvYzZ0MjAZcwXC3Fc7Z6XhF3jFBDpGj+4B4fE/ZJG25JArPotyq08EoIXLopOtZs+ose2xxkjVIjBVOM2CHv6m3DCvgnAVOevKfGpTR4Kj3qwT+7tUFIVaaovot8fBeSpoXG4ty501NYIFBPZWZl/oaPfd9GMtUCAVwxkiPxolvUuiZw3XpZlS9BCY5DpmfG+2y6Nyp/RaUJQhw2OT1YoDh/DESUWBFvUeDq4/lOXNMsJAjdTX0CdNEjkbEEjjLtJ7rLkGaB2YZ2ya+fh9htuuEz4EgyE1DLHNmPFQFu4i3n9Qu6KlMD2lLy0Hwv2Y4CAj2WbS0nE/Ret5wGnC6soqUOraz/wM2q6NHTEafXOZonDoo5rv/b+15/7E2bJJPX39yXAvyiKEGMqpA/afd4d94f+ydW7nHKGDU1E1TpapnYpbKOHlQ+V6CLWJKt17j6qaziZ8mCf86/bCXGYQjAwLiOOP6tm64LacZadUbNk2z4uWlaTTp5IjIi4Z8/Z/3WlF0tRXu1PGou2cdgiCnmgX7eA4XumrWyy/P+QGWjfLAwgHrzoeBrLS18eTmQtDpRgGzJ46LhK4aYWl3Acqc/dwzKrmy1xH1MsI0gg0P5mMRpYSii8niNURS0O+DVRg70yvA+N3bx/hAH4z2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5267.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(86362001)(966005)(6512007)(36756003)(4326008)(186003)(66476007)(66556008)(83380400001)(5660300002)(7416002)(44832011)(6666004)(52116002)(6506007)(6486002)(8676002)(66946007)(8936002)(26005)(2906002)(107886003)(2616005)(38100700002)(38350700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hMtpPD5jg803vqKpUg3gT5harh7DcWi5rUol2FUIrIP4QKW2HoLc3t/kTcmh?=
 =?us-ascii?Q?Qx/QzCa5ihvs+0AW3bAb4QNmjuHxE1U8ZyvjvD+zNXO7l4xGGfBYub/Z6SHF?=
 =?us-ascii?Q?2ouWgP6C0aYGtgKNyzUCNvNgR1I36FLaSGv75EbZso1BwDBDNZyC/iJnm/wx?=
 =?us-ascii?Q?ycv3GLtgK66Xwi0TGTiIdFcQnWRs8VTQXrobRAfKJvA6voVjOhjIJAw9EYmt?=
 =?us-ascii?Q?I1fjbiQG37o9/5G/UtjV53JTVjsc9u5fELMUTwMGDoxrIGX6LuSEZKou+zJP?=
 =?us-ascii?Q?wif9+6H0AFRrzA019ywEzhVg8mUo2sWUxMrXUkd/l9EGnkpN2lORawGQD8Y9?=
 =?us-ascii?Q?msWUdnQmyim3VkmjZ62TLBaV11L6+a+dRU+0ezp4MJxqoIaXZo4Zalvt32Ny?=
 =?us-ascii?Q?YnDxLoOO+LpI5VnXFTYKF/o+k+s9IKPcDG8upQyF8SRbu0X5Bh5VcBz2zBow?=
 =?us-ascii?Q?6NOYkF7ooI8X2e/gJ8l3J4V3aU/nqcYGkFcEJz24K41NWn8JLYSJfepGZt8B?=
 =?us-ascii?Q?cNhsZ7NU6bdpUtGBI2C3faFwFCfJgDM1QabTuB3a2HE8ldHDoLdlUmmnBgJx?=
 =?us-ascii?Q?EM2/tMbpopxQZ/bvQb25kqfSY2MSAp76tg6lIm9/1Qur+4+HfJQLWGI0gXrA?=
 =?us-ascii?Q?GFS97UOBMbrHpRuvbKGw6BxOsF/rhJob8la5VcLAEeRtOKmKXiM8a6pwyMGe?=
 =?us-ascii?Q?EjFwtWwyldBn3+twzSxmWCf93YaTIuAhYUSWA7I0W10epq+jKQJ4jWZ2/6E3?=
 =?us-ascii?Q?1sdN/mW7bTSByTwF4pW1FpHAenZsRdSnr6JWp+0jUzsmDuyIPusbnQxPm6zJ?=
 =?us-ascii?Q?iuIBcs+iIyd9Ic+rrYywxYwwSyU/pCbuFMb9+pRt1OpPJl59rVHujd5EaQkc?=
 =?us-ascii?Q?d2pUAMUG2crJawCRIZywE4M6FaoKr3c4FUROkVPJ7Vl6BgQ5B9J4j/k3kgPs?=
 =?us-ascii?Q?QPrLVvKFSfu/2qYNdwJQC+WIg/HFlTml802wRT0rdjoyim/JAXqqONSQpdk9?=
 =?us-ascii?Q?9dxvLt1YvipCRFcDQFqOeeApPlbzlK9/jlv9CU6eNXnhjIcETqPzU9bhAPY2?=
 =?us-ascii?Q?j8wXEqLuU1xUSRXpb+2Z7pcJCAbppdF6Ub5LmL9GCX4PGERkGEwt33japCH+?=
 =?us-ascii?Q?K4Lv+OPybkGvNuYgvfkb9sagqACWaNsgxUSf1/D7eZ1AsajhbsKyG+Gj2T4a?=
 =?us-ascii?Q?diyKUQ6QEc/vPdXRSM4f9kNSNacMOf8F1kT9Tr5Zy+lXHK6D3zwejK4UOBw2?=
 =?us-ascii?Q?eWYI70lHoWobBVTdJ/RFMYM9210xM3cGHpe725Qg/7fGEjnwB7QKk6uzt39y?=
 =?us-ascii?Q?wBMF/6GqBJVA9deMap9sbwX0IBqV2QizALQcCZt0CxjBFwexvCZrRcXZOvHJ?=
 =?us-ascii?Q?Gsj7o8wFlT0mFIaJ9AgX69TpVq/tHtUIBcHd/5Qg488M8qcN+91+ounrQjF4?=
 =?us-ascii?Q?pkuNMIPvwomeSdQF4vmlWif2k1atCnYd1UdMsGotQAnavHctz3s0itgLl5jC?=
 =?us-ascii?Q?G3dlOYTbDEJU19z0D9BV1fiNewOVpvbq5ZfXjaV9pjIhxSV1HqoOKh41mwtA?=
 =?us-ascii?Q?2vV/vj0ao1UdYxnvWcvKiErvcrUtRchLaXD1nM12AEwbXBRse9oml/yak4zL?=
 =?us-ascii?Q?LTqcI2SufVzgScilfc0grnpFfh9zeVY1nZLS30dqux4PYJascfvdpGpg8m1N?=
 =?us-ascii?Q?MsDFF+5EN92cTsZ0zQHwckXHwvgxViz24OfCiSX1unB507n2CrXU6HfLNwzQ?=
 =?us-ascii?Q?sV+Q9SQFvwWcoNekoDvmCBqxo7d3tTo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a441d0-ffd7-4079-f12a-08da19b28400
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5267.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 22:52:54.0100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Co5hH57h9GyZSyKuCL37OfJWEYPhuCC2D4XxM7HueWPhY8AxlZoyO5vRV9MHZqIu54abIRbzwHVi+G1A3kjqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3705
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.425,18.0.858
 definitions=2022-04-08_08:2022-04-08,2022-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=827 malwarescore=0
 bulkscore=0 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204080117
X-Proofpoint-ORIG-GUID: ZmheccpCME33_oPRnAxfAjrQlQa6matq
X-Proofpoint-GUID: ZmheccpCME33_oPRnAxfAjrQlQa6matq
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USDT support [1] requires architecture-specific handling for translating
from argument strings describing each probe argument to appropriate values
that can be made available to the BPF program.  Determining value size,
whether it refers to a dereference (and if there is an offset from the
register value), a register value or a constant all has to be parsed
slightly differently for different architectures.

However a common representation is created for use within BPF programs
(via usdt.bpf.h), and patch 1 abstracts out the initialization of
struct usdt_arg_spec associated with the argument, rather than repeating
those steps for each architecture.

Patch 2 then adds aarch64-specific argument parsing.

[1] https://lore.kernel.org/bpf/20220404234202.331384-1-andrii@kernel.org/

Alan Maguire (2):
  libbpf: usdt: factor out common USDT arg handling
  libbpf: usdt aarch64 arg parsing support

 tools/lib/bpf/usdt.c | 134 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 87 insertions(+), 47 deletions(-)

-- 
1.8.3.1

