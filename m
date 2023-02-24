Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833AE6A1E2D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 16:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjBXPLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 10:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBXPLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 10:11:08 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3E54DE3E;
        Fri, 24 Feb 2023 07:10:30 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OEn2pl003369;
        Fri, 24 Feb 2023 15:09:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=pESwYL4yE8NIIdgiAfvzSmpCiCo0iXNFKa67SEfmtPY=;
 b=Ver1JuWN7r0oWjX1jMKwUxP9zD5niaanm7cnBUkuohsoemdqb0p64139LUceRSqiiEMe
 0kUJTcRleaurUWVMX2jMwhHR0gEtASarYCbhEg5BAIloKu1oSH9fe3INFQZLw5aLjd1G
 ynyFtwmTge+m3PUZcT/hlAdUkpAOpgg4Y7PE2JgQDZYjT25iY225wQdXL4BnnOWFFguS
 qDlclyb3ABKD3D6L3dBBOev2aKwOSozOX3sHHx+t1R63fORFUjXBFebcIifWhZcDx6bv
 AQOUhYi4PkpoNZn03vnXDfaLMN2MmqSMyI+fNw20o8Tu2wlJaPwEj+cfp5HN6/+Kl+56 /w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntnf3nbbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 15:09:26 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31ODKojb031919;
        Fri, 24 Feb 2023 15:09:26 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn49qng5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 15:09:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jixLMynWj6j5ln7RZaaQM5tbtKKLTGRyNLhUnCbwWnhySuY7GnIdKtezwnuCLDq1MSzy/5fsuENxCrBp+83SKt1vBtffCxIpB7qxYSrpjTd50ehoRnnaQ90XBVwRMOMEWnZnHjyIz4hz2XytdVS7QSToo54iePV+KQQhIVoX5hSWndmxX+glyxsNNPaLI2MCY0welQ6wM+AAT/5FWWup1cYxq0fy/niLJTcJz77V9L110v/AzUgZgY4JIrINk9Oj/c6exIJIRZAaD+pfsr/UzqcvdyQ4RDI4NJ/KWOcq1YUF4JA3utLVUvIz1sgmnYVvMCDgAHmxG2neMJijx7O34Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pESwYL4yE8NIIdgiAfvzSmpCiCo0iXNFKa67SEfmtPY=;
 b=dInYhWzSFJwestAAqi+kmK1Ulez98HVGdCD2hFKYyyONL7QFZSVqawQ4q7qGI6Aauc0cU6rhiN2yvExHxhFo70KmUyw1yfxDRKo6wTfFNj5zxxqhnDDzyn7/+MmOKKdGpFXsbIjQY9943q7FXTYgCFdGw5IyKPO9Dq9Dlqgy/m37V6xx7uPQny2+hi2Q+ZHVe469sqavbAXXZi9RZ8BijTLBhPMzpK3//I9Y0/ssNUevt/2eeEsZaqhDKKT5WTtBsiu7soS4s2TOQqJzI87Bo9qJJ6Fuvxl+iRIH8iH9vtcEhBN8sPzBaGPD20u80OM/bywvYeed6lUAU7kWRu6zqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pESwYL4yE8NIIdgiAfvzSmpCiCo0iXNFKa67SEfmtPY=;
 b=poWXmqzinBC7KM5/hWr8lmVI6aKEc6QGm3O/aIF+twwrEdjLZtxfiJMCQ18zCSKUgwrtH8+qi2kAtU8adObAe+QslYjF67/EU117+jGLIzLNgCDFQ9etNpZCbWZMSv5KhDri8uThBNILBg0rYI+hn+fCCRyyZ8MBvoYK5Vb6bWY=
Received: from DS0PR10MB6798.namprd10.prod.outlook.com (2603:10b6:8:13c::20)
 by BN0PR10MB5303.namprd10.prod.outlook.com (2603:10b6:408:125::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.11; Fri, 24 Feb
 2023 15:09:24 +0000
Received: from DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d0f7:e4fd:bd4:b760]) by DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d0f7:e4fd:bd4:b760%3]) with mapi id 15.20.6134.019; Fri, 24 Feb 2023
 15:09:24 +0000
From:   Nick Alcock <nick.alcock@oracle.com>
To:     mcgrof@kernel.org
Cc:     linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH 13/27] mctp: remove MODULE_LICENSE in non-modules
Date:   Fri, 24 Feb 2023 15:07:57 +0000
Message-Id: <20230224150811.80316-14-nick.alcock@oracle.com>
X-Mailer: git-send-email 2.39.1.268.g9de2f9a303
In-Reply-To: <20230224150811.80316-1-nick.alcock@oracle.com>
References: <20230224150811.80316-1-nick.alcock@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0583.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::13) To DS0PR10MB6798.namprd10.prod.outlook.com
 (2603:10b6:8:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB6798:EE_|BN0PR10MB5303:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c446e79-1bfc-4835-1056-08db16791d46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LtkNPwwZHVjDxXGo5DTP2no/eE0se4LvbwqaXF3VG51BLdNwUy9tMBaRfAEt/uNbmjicfgkvtwQz6aW8LFT++knft/9G4lDbssHMgVLsO7r2HeCmCsYM0CsdSmyO9QoHmLmCIFqt4D8jSuhqiYv1J46sVWytrIVEEy/e95wGvrkByk2ew+Xqd2+Zn+GTydPL/JNgQYLv2XfBvyHOKVz2qtCus8yuHLnpGue4XNX255ZOG/KcZMMceeI/ejQ13flSFhUtgEdM+g9KGHwkiKO72xPO9xyBmetiHp+V5jRgGx/L5bVbENJErZ9oTldQgS4MKfaowwzTi+/u9ZzNVN1f6A/UrI7D1Vv/4CmT8q7MOfOUm/17bqOalO/bIDqQnCNV3CxHmHg5FEHSMshD4TpIOSNUxuBV6yzjWGLVJJ+LLQQO9YXsZ8dQizyayB/OWWmCYht8rDQOMOxwk75rveGmSsll745n+TcHjdbL0RaB0EoWnKLy3f3zIVGl/P5gjNaXqftsWU2oM2YoDMv4HN7AmK/huINTN1YOBLg8LlDKL9PJ/SheGpsfiAl1Fl2JdfslkKRJePiDaNUyGLGDXGkgmezDdTW5vuJfU7Kc8vsVkYpqNjJUoBBj6jiakwQX3tVRkBPmNPC1nTvhyEnjsp4yAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB6798.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(136003)(376002)(366004)(39860400002)(346002)(451199018)(36756003)(6506007)(83380400001)(2616005)(1076003)(6512007)(6666004)(186003)(8936002)(7416002)(41300700001)(6916009)(4326008)(44832011)(8676002)(5660300002)(2906002)(6486002)(478600001)(66946007)(66556008)(66476007)(54906003)(316002)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S/8VxAJ8+zT/TrIZxDst4fz5oxJgWzTOYZMguIEMJaJldEAfPtLJNAEpc8Bc?=
 =?us-ascii?Q?Pl2gz6jWh8j9IRaeJNNI65Y8zJ7Q1hFc4GLrIvBZykTnD4pIEs7GljWuXzl8?=
 =?us-ascii?Q?K/Zs7np3qIxkLaokXVVa73aQjbYnA/16njz3xt0Ii7705f8K0VCCOQyyyEks?=
 =?us-ascii?Q?Z+HRGVMejIk0xzqc74B7n+jJHkvVXjanw3qdwZ7bzqQcv6T4lovJsSvTqoK9?=
 =?us-ascii?Q?XsTpy1Kc2/tFtZ6W3QG+oFwbb78TZjBfYw3eL9p0LJ+/h8SOnqXYlk8Gf3m0?=
 =?us-ascii?Q?Fw/52aJBaXPbQhbehSBfgtEEYy7f9QfRrWzVboFaDw38fqMzLC6+pW9w6nu9?=
 =?us-ascii?Q?2ZOnRq40cZtYFarWbErbcdOu1w5tJpOoUpCqDzcZn3C7aoPATuSTEETCfRiR?=
 =?us-ascii?Q?omD21XtM6cI91zqD+zMwg3cAib7vnrW+/GsjMw7NKz34RzdhZcSsax9ptGKZ?=
 =?us-ascii?Q?NEpLSjrVzODvpkrzhGJx+1H4DWCcXl81UPG77hJM6apsLdsLugae8ZD6gTBX?=
 =?us-ascii?Q?l7zNGnbolRcnKMWyUy26IHYhx3krGzkkiZeuMIrv3nCvOYHB2XvwNu54XSts?=
 =?us-ascii?Q?ATOO9ijfaDr0QY45Ggvo6CTFrdD8ixEIlUBq1/K9z17IcWMNKtKK960CkPIy?=
 =?us-ascii?Q?MtSguPR6f9iGVWjX3G6wSWsPj8OFjS76+CWSGhLLApZXwXb1q1Fxn3ykx6jQ?=
 =?us-ascii?Q?T+Hmt1oAkfTZon3n2XhjE4HMjRWgR5cigq+6ONP3w2xKmYsIFsCPnHKBSvuj?=
 =?us-ascii?Q?TAUApvIsV3Hu31tEldyXU8hzXExRFrm+C9TbrKuudPTjzOFVxRbVMCdIhdS2?=
 =?us-ascii?Q?6io4MARzlfFWiRFi3hh9fjuJ0t7sB/uisrhLxjQcs1jAND36U1vGB6GAwdOK?=
 =?us-ascii?Q?/i+p0hX8u9ewlA+SYk1/TA38ilqVauTdTWjuD4wfYxZeTSTowpcALU0jA0m6?=
 =?us-ascii?Q?p74Se/+GmCJk9dyqrwWgxS1toDuk5pjHdyeMK9wU0/k++Q1n0rPhYNx5I0wU?=
 =?us-ascii?Q?KBtcCigdyXDTsrnoEw1ND8Oe3BJEPDkXiJgA/uJWAD9MOH1nzDg0VY+yNivN?=
 =?us-ascii?Q?1fW8IeaV5PBxS/1d+F/MaKy0rkYfqn603lik5lOHjj7Njr5FMQB7xKnOyxwj?=
 =?us-ascii?Q?jHkGj6m0Jyrr7332cCaNKuZn16ujdYdBZxCC62vvmV3c9EWbaBNvACJFhQS7?=
 =?us-ascii?Q?KmecZaY9TN+Z0IYEolCrzKOLpgXLtNwAJcjftnqAdZlQqkzSMGX0A/ZbFQhb?=
 =?us-ascii?Q?R14wrWq6Hs6E6LV9pkEQ1PUm/bEsJUwgRzquQauJMsJCRosKq6yWX0ky0oie?=
 =?us-ascii?Q?VKLCCkxhmfIFJcBZ7JhLnY21jZczvu2XNxvynSKMjJzCWPSJ5ia1HE1E9oLY?=
 =?us-ascii?Q?sWnyWaMO8zI9b6pL6yat/MCB6KaMgGoZ86drLVEe2qrcpOLWBbBLmf+nLHnl?=
 =?us-ascii?Q?K4EsdnetLYiYBQhjbitRCWtA4Z+/ns6BjEO1cHRjDfjKzFwngBSQelBVL6kB?=
 =?us-ascii?Q?J9ARbUqPIrF0C5pXhfhNzbPaFzbXBzaSOAGr1HkS5DFOAfgk5iL1EOCiBg66?=
 =?us-ascii?Q?wuLN+Fw1JOrAMUYmllnW77/AnThB20nx+Xg0X6ZwER1lcKeKT4h+IiX3Nifv?=
 =?us-ascii?Q?QDDu3TDPkeb1ql+yuS62D54=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?y0mj2/plll/LHP7DHiYuH4ISR4geV6hAr8Ht5019EAthILDkYb0o89TYpyDj?=
 =?us-ascii?Q?dgBn49lxBaHQ3cmw1qEwPHzBbEEBaAvefQGLFWYSjYjrqwwCcqA9ZcwEmyXH?=
 =?us-ascii?Q?LQ1NSkvjd01Ofh2IRc4HUh/kn6f9z9gvd1unursYmC6Zw9IQJmnB5m0qB733?=
 =?us-ascii?Q?4DCDPcZen3tZ5qPJ6VCWoXFcbcMRmWekZ3FrFV7RfI1uEmJ5spQDHn4K5WHt?=
 =?us-ascii?Q?RiFibKcuVRM/XG1iHgv2uMEa6RLX33hg8fvo13TM0SLMHtUhSdJcAoqM0zOP?=
 =?us-ascii?Q?3QMbIbKMLIunyD60xHjlTmfuemUz1cziEIgP4t0OV0j597/icCiSqPOWmYEG?=
 =?us-ascii?Q?h8hPBgHEYuIePwQTNiGONd3BQ1qsAONunS4c1IBeseh0lrjniQW0OoOw2C7g?=
 =?us-ascii?Q?9cTmdcVsPWbWVNsB0lgI011w+61vEqyyz91+3BNMGSEImu0adyEM0bZxWQNu?=
 =?us-ascii?Q?qEO7tbFxkS1wrCahR9UPfQ9nr/UH8pLj36uYW4DI/jFK4hfZCO5g3jiZ9KnT?=
 =?us-ascii?Q?kmkK59FcvJOhcENC4a1S+UQroxDD+SaaSfO8I5FzhNlUecjzlZHhcGXDsB1Q?=
 =?us-ascii?Q?vSydklBn3V+z/jOoGFjJ8xuZ5uOzhmqTr9KOwXR50m4fg1QMIwYM8xURa5vj?=
 =?us-ascii?Q?WNiprv1+vMsIkvR2Z177E0VkT5uB6cJ1cyH+nt4oYakDc2WJyJavIlKfAgWP?=
 =?us-ascii?Q?DIgFSUV0sziWaiq4ZOIczrALCxYk4QKEeuCUy0Kdq+nXq78rkHKbL6kj2T9r?=
 =?us-ascii?Q?CH68yMqurRn6k15lgPTIHNPLgh0u5iB7xcW9xr0t3vbQbJ2ZxuG2Nyd+joq5?=
 =?us-ascii?Q?KJeKUeG+JCK7T3IdyJMa0W3GBf6QmGw7FUTjl5nO+lRevSpYNbv/orfgdfJV?=
 =?us-ascii?Q?05H06pbC/TfN6dp78sL4YyXszeBSr11C/3x9cWUWCVfEgr7InG8UFT6bvmfm?=
 =?us-ascii?Q?tVJgaKc6FkuaVHyLrlD+GNXfaT/JMs/ky3dUQ1Kjf1k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c446e79-1bfc-4835-1056-08db16791d46
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB6798.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 15:09:24.1979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9fpzmbE3VVS1EOi1kpR2Fio0GiLUixImbgZO5esCUM4pTQL0Y3dnbxMQ1Cl1lQLVPmiS4TWNN/VSiZqn7GsBKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5303
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_10,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302240118
X-Proofpoint-GUID: 63iDsnb3qGvS-E25vveWIk2xeWFKuP7V
X-Proofpoint-ORIG-GUID: 63iDsnb3qGvS-E25vveWIk2xeWFKuP7V
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 8b41fc4454e ("kbuild: create modules.builtin without
Makefile.modbuiltin or tristate.conf"), MODULE_LICENSE declarations
are used to identify modules. As a consequence, uses of the macro
in non-modules will cause modprobe to misidentify their containing
object file as a module when it is not (false positives), and modprobe
might succeed rather than failing with a suitable error message.

So remove it in the files in this commit, none of which can be built as
modules.

Signed-off-by: Nick Alcock <nick.alcock@oracle.com>
Suggested-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-modules@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>
Cc: Jeremy Kerr <jk@codeconstruct.com.au>
Cc: Matt Johnston <matt@codeconstruct.com.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
---
 net/mctp/af_mctp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index fc9e728b6333..2e763c398e92 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -694,7 +694,6 @@ subsys_initcall(mctp_init);
 module_exit(mctp_exit);
 
 MODULE_DESCRIPTION("MCTP core");
-MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Jeremy Kerr <jk@codeconstruct.com.au>");
 
 MODULE_ALIAS_NETPROTO(PF_MCTP);
-- 
2.39.1.268.g9de2f9a303

