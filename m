Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C41A6B06AF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 13:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjCHMNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 07:13:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjCHMNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 07:13:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F248F574E5;
        Wed,  8 Mar 2023 04:13:13 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3288Dxxp010479;
        Wed, 8 Mar 2023 12:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=oPu+RFmPtIIQN+1TPuIEnqPrL7KpckKRLgK7ibTs1js=;
 b=eVBQoVrPy0S6cj1fcLgqKx0QgiOfxnyNb1PhF/NwUNamcWV5J8gFMz3GEsIGub9SQSL9
 r+ey+7VgQCOthXYx5901YkGLCklXK+P8M1jfXvqRsnvQZgy0uJO5+kJdaszLGpU8NX4j
 F6ocmoq5m3NBybNmb1ItQqytktF/KPdEemYQkQ7aVZgpZDH9l0Q/Ve0HfLGc7F7lIOYf
 0s+h0c0d5dvqFb+W75PlbmhdxrFwh1I7BnYUG7UfzcVZAzM9i8u5m0iRGOFR4cNnSI84
 Vr21Q8TDXnCLvS5blKn03y7/YwZ3z4IsOtTR3rcly9ra6M8C39qfA+bLzHgp2MHcSt0W Gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415j00bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 12:12:52 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328BOegP007317;
        Wed, 8 Mar 2023 12:12:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4fmrt9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 12:12:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XVg6VPDjaDWvqoWbMnwFg6sPaIKZmE04WJpDDQDYc3R158doyYuLvEKQ+tE4+Md2jPdvZKWOnHXsVWxEVnXroyGRYzGnn2vsVRIVX2Esx/3QeMd35Dt2lce2UYouK1z1Dka9neVBBBuwzZLkUVyQySa85N5GtLQ52EuSN8WVjB9BT7KZni+NJ6sXUmT6iPLJ376EI4W8HrTxFiWSEEsVYbAyQzAFP0Kxk1SLU+fnnJahypyDU7bd0WQ16RJrIqn59q6PMfpz8OT3WFLQQUuzbR/YF8ilXapabpPS54cguDbdq8ucN5m3+JLKUBLfRGYAcmiUPO5Q3ziPc6dxWs2NAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPu+RFmPtIIQN+1TPuIEnqPrL7KpckKRLgK7ibTs1js=;
 b=NM2EPx99LQF8YDG2Ac4w2605q2f6mwWoxzrIV61awt7ktctGUquWUuBnJeJaRWsH1zqDLxTD4O1YZEcEg/UOzI/3LbViqLwI0j80tIXWjcoceQGR5Np1yJ8aYIueNF/BBtHTYh+03KZX9GCx8XdbYsj++4auW57NvRLhv0hcHQZvev/Mz/oADQu5Q+kGX1doYiFtay5Lm2fPXL67puzV4WZbs4Htyl4OFw802l4a5iiHV0NNUk4U3eq8TYsWrO6EpgBHKJ1gFx/Oi+WE9sMkvYfQYObgZOl2G4aZzgiYpTJvoqRwel0NnN/Tcpq7+FtvamMCvZdSrLSrSX8N9Pmp3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPu+RFmPtIIQN+1TPuIEnqPrL7KpckKRLgK7ibTs1js=;
 b=xKgG7ZkDiMJSp572SYyaif2EAjTRrBkUEgXWyJUgScOaFAU0vdGuw2twOy+whvySF2xOTiJTY0t9DFMSf3VaO4928Cb/fzjHOfKHLW1mMgkHloBq8RABPUoHbrFvEiAOYUF/0F7tdOR+WgtvC7aTNRv8EUGFrBuq9v0hnVX8PoQ=
Received: from DS0PR10MB6798.namprd10.prod.outlook.com (2603:10b6:8:13c::20)
 by DS0PR10MB6823.namprd10.prod.outlook.com (2603:10b6:8:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 12:12:49 +0000
Received: from DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d0f7:e4fd:bd4:b760]) by DS0PR10MB6798.namprd10.prod.outlook.com
 ([fe80::d0f7:e4fd:bd4:b760%4]) with mapi id 15.20.6156.027; Wed, 8 Mar 2023
 12:12:49 +0000
From:   Nick Alcock <nick.alcock@oracle.com>
To:     netdev@vger.kernel.org
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hitomi Hasegawa <hasegawa-hitomi@fujitsu.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] mctp: remove MODULE_LICENSE in non-modules
Date:   Wed,  8 Mar 2023 12:12:30 +0000
Message-Id: <20230308121230.5354-2-nick.alcock@oracle.com>
X-Mailer: git-send-email 2.39.1.268.g9de2f9a303
In-Reply-To: <20230308121230.5354-1-nick.alcock@oracle.com>
References: <20230308121230.5354-1-nick.alcock@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0105.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::20) To DS0PR10MB6798.namprd10.prod.outlook.com
 (2603:10b6:8:13c::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB6798:EE_|DS0PR10MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 7c0e38be-9324-433a-1354-08db1fce6f80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PIampdTuHu9RHc5LtFZPRcZD2ci6GkiQEWD6PNp1Wn6YjAuHu20JrjDk8ZI39oIm/zTdsw1PSw7F+j8onLOxQOy63t0Pb3ttkAW5ZbnfwZ6NPOVhPACdRLXSHsAOOyc8S6hsqPVdsZpFb0a7tOJG3zZST5PfCl1cdyOS3ehKAsFpPew+wW0ygmh3JRKorNmuzIqXqpKjfi56Xb06oHJgQSuWixvMVPFywwlJC/iOJ1eYsKGTrVmnOxes1yWqjkyVDOetyfDv5xwPFoOl5V1/eHIhViPuUpO1N2gGwSnjR12Cdb2Oh+ekL8SWxrp+nK3R7ZwwSQ3edxVKjtirH4oOCq56ISYdc3CScIXmCM1feP6KoYuVlpANFQqlfb8N7f4PNry30aXoO8wp8+Ro9Fkm8Q6tg4e0717eQiF4O0pTZ7KmuspM6MxVHry4LN8egRYDEBUBHOoSduUO4q8AQFQz29TZrawExXptuqtuDYVYdgtdWypGDSVk55EmeIi1PZ6PL+E8upA6Y85wyPT2vMvtuRL8SuEXrlZqxXCSuhD5c/ZU+QE9baKglAgO9tVO1/YVSTdqf5+vo6DV63CLI4vPKNeBWujg9T/RelHcDsAaHs3JsseoxdH9HJs7QgyKGMKo9YplbIK/5ohlzA7Oy2pgFw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB6798.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(136003)(376002)(451199018)(6506007)(1076003)(6512007)(6486002)(36756003)(6666004)(86362001)(83380400001)(38100700002)(186003)(2616005)(41300700001)(66946007)(2906002)(66556008)(4326008)(6916009)(8676002)(66476007)(44832011)(8936002)(7416002)(5660300002)(316002)(54906003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M+GmPwcASBPvp06gQHtBUAWITj0cW9uIpAE1aJQ2U+K9Xz/geaQN2BDjWcEv?=
 =?us-ascii?Q?x/KskVV8EiW1ipNyBcW7/IOTBCFXwffNmBAaGQyDSfd67nBMLgNGnBINjCfV?=
 =?us-ascii?Q?j84bjvK9u+Edb7AnwUP/JCERKmw7SSkpRMgwQcpB57NA2u4gANiR0AdPpS8o?=
 =?us-ascii?Q?GSE9mNEU23dWdiohX0fI3t3UjsZWr5qJlqpzogKGGh3byOwHbxa1e0RHr5p4?=
 =?us-ascii?Q?Q0/jHq0VdzUJPL4fvijQqF+tzdEvBm9IckBQGPwvrPNRHJQ3+ABHY3eHO9WZ?=
 =?us-ascii?Q?jFH6GjURmqHDWbYI2jmQVzDTTnWp5mubg6Vegc8UAfq9wKsMlNY84xlStMEo?=
 =?us-ascii?Q?fnDHR59mBtCERKqJGlV+GrJBryqhTOxMQVEXxA4oY4NvEKYphWDbXzeWIea4?=
 =?us-ascii?Q?fYCUHlsh4h3WlWCBNbx0Iy9kfKqh9c9OhS4dvEQQf4gVrlW16APiPlSkQQwp?=
 =?us-ascii?Q?zHieD51RU0+f0B9QfWQ2icI0waKaVYYUqc04tPCU9//i+GlhIdGyBLaneg9h?=
 =?us-ascii?Q?jEQJCbUjWchFo8l2QhBu3GW9kxr9iGR2tRZunashMPQe6kY6kzmo7XIKorq8?=
 =?us-ascii?Q?4Oc516Z9J8Y+sxXNsLZSGLLp4FwwGuq7wGI9RKPXDNESi0q/TX2E9zY32thw?=
 =?us-ascii?Q?QmsRxpxQJojMnO0G2hjVSWSQE4tgH1kYlP+lcCGAO4DNUuGLMEl43QqpA25c?=
 =?us-ascii?Q?BCB9xBZLph88/iUX1BsomlDzRjCioqR1Vrh8Njn52dQsGD1x2v5lov0x/yPP?=
 =?us-ascii?Q?dypdgJDqU7jCjxPVlwb24chancoNJh/F4MzM95zUZuHruuHdNiW9vIy3t8CE?=
 =?us-ascii?Q?0qUm5u9/p2qOWqxL69qyluIB+fIQb6h+BHrIwvdZrdZRhluYQsMcwEiUZiOO?=
 =?us-ascii?Q?IzluCklxUEaZ4SwXKR9aA4E5yzaH6G5MttSp62LMGFawjimuF6eW76VE0M+T?=
 =?us-ascii?Q?3NZnv23sBszDo1s0U5xQeMUOliCX4n97ccvxqxanTc1jvnwmk3rBOI0582AV?=
 =?us-ascii?Q?Z78gsFx7tVHk2W1IfkV4O1vletfOYGiMpAnsqjzlU0oYSlxhLWmscDD23ipB?=
 =?us-ascii?Q?M2/CUQTBbg/BGQfrLop4hZC5wNG23g0/qvrRR9NTvMi+IdV6X63f0dD/NWES?=
 =?us-ascii?Q?UYIVCOwzKzRN1yMZfWLZiAUhw62p1A55DP0kIarfJ0bJr4TVARi8iYKUSfIF?=
 =?us-ascii?Q?GLwEbna/adKcJNfF1IkqEOAAOg4+a+IG3RyRdIxEMYZ4GHwAf374awZF55KV?=
 =?us-ascii?Q?Z2VXIqf512/S/MyVOOOA8e7+9vgH5hCmtoJkSmcTq1VOcqkdG6IJIRYHwXAX?=
 =?us-ascii?Q?ETwEdLJQpo0bkt6Mpfoe40SNvfm+Pui3idNIlwxRCN8cONq1cwZjOOLFQ+VC?=
 =?us-ascii?Q?e0QNes7YJDPGysTgjEtYGJEvftKhOcm/unhO7K7qJWOQHPEpoibCRME6dQrw?=
 =?us-ascii?Q?4S6ZpzTVCl4d/PJXYgg4H7rtzj9bxKkAfNEn+wiVS3+7GJg23EDzy4PQxTK6?=
 =?us-ascii?Q?VgsjzeIvD5eA2VHzdyslLdp5jaPI5ruRvXM+fTQrnxortHZZQzUoHn41ksfU?=
 =?us-ascii?Q?sXNVuccuZpcziIu9gEAKd5mYJfUcQmX1JguGWPgLmNeVjhzcFRppVmaz2UOo?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?qnUBT8JrAbty4QMUGtSyJ9VRycijy4HdqsHjQfhkjnrOlK5ED1AUvhaKxZuy?=
 =?us-ascii?Q?K0amf2a7X5PA51keMUnE18Ul6trauvZcly9YwQm7xwCkMRp5vcP2/zKsWoQ2?=
 =?us-ascii?Q?R42AUcWZ1FgakbXvrKB05qhzt3c4YmvtNtT8RW2Vbc1UaUIcc5T7y//acmX/?=
 =?us-ascii?Q?m1USkM6/BaBXGJU0RoTN/QQA9xh6co2nf/rp7/3xMKzMrqt3Few/uMCQ8b9X?=
 =?us-ascii?Q?ckWnV4fSn+huPKc13KAch8c7qX1NPMZV1qMeevOkcDsIgY/oDG/T0RT1aw79?=
 =?us-ascii?Q?yviIh89WadjXvxSSXBahUaFun30IDt2CXHJ30zhlpx1qQr831CDR2VEssZU/?=
 =?us-ascii?Q?Hkyl4GgEzcVwCby2vST6iOF78EzWlT7hTRNqPXYxIs6Wg9JHKWrHlk6349Rv?=
 =?us-ascii?Q?FSMrWYKKqjBWT/F/DbOOCAceTEIT68MgBwSzLjkxX8kXo2nYBUlFY+z2GoDL?=
 =?us-ascii?Q?sat70JMbmNEwnNDGD3iyXiDuX4SilTom4izl1UIPkf0FWxY7fFT828OXdkR3?=
 =?us-ascii?Q?kVRmQbpuY83HZekbIYj7XTNHJ0GuZhQFhzSSNYzzjUnnEP/sNAwp+eRIavPu?=
 =?us-ascii?Q?rzOZ8yQt/J8KSshgm08pdjMPqmfAHdJE1QTdx/w3zk/xnlAp7nhYd2atNN5i?=
 =?us-ascii?Q?nv4PsH+1ClwsLu28jUuAHoH7UybYe/P6NVvGlPg+aH1C7/XEsjsrmxhW5zNB?=
 =?us-ascii?Q?vzdEBgOw31++Crp7zkQEWIugRq9anY4NApADLnxeNXUS0ArmAC8EUWNRq+LR?=
 =?us-ascii?Q?c15m8hqR2KrRuXeMG++/Dx6WqJ4D2TGExZnVdowOEacZu+jZQfqLX8RtqdXG?=
 =?us-ascii?Q?I8kIq+lcmHs1g7B1bEHKtwCqtlU8KvUJyEmN5IZGaMv41Iba00foKJLElg+q?=
 =?us-ascii?Q?fRZRb8JBRluR3J5uM5bDBGDYfCztqwEA59P4H6jNQLOQFXTV2ZOaPGWuRMHG?=
 =?us-ascii?Q?BfIxfB2Kd5kyfJIy1q8zGM4lY6pblIqseUcpMaShg6U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c0e38be-9324-433a-1354-08db1fce6f80
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB6798.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 12:12:49.8383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MuqZ495Lg5DMrbymPwz8zumPZoOcfRaoTvzUqYgGWXmTpMyCleAMlLvnv5iMWbYWw4XnOZCHY82D1h6O7Cc27Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_07,2023-03-08_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080106
X-Proofpoint-GUID: Lclc1x_vxVyScTF-agJBoXgsGKjeJRTc
X-Proofpoint-ORIG-GUID: Lclc1x_vxVyScTF-agJBoXgsGKjeJRTc
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

(Reposted to netdev as requested.)

diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 3150f3f0c8725..bb4bd0b6a4f79 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -704,7 +704,6 @@ subsys_initcall(mctp_init);
 module_exit(mctp_exit);
 
 MODULE_DESCRIPTION("MCTP core");
-MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Jeremy Kerr <jk@codeconstruct.com.au>");
 
 MODULE_ALIAS_NETPROTO(PF_MCTP);
-- 
2.39.1.268.g9de2f9a303

