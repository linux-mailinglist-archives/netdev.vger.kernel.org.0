Return-Path: <netdev+bounces-7213-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 028A371F157
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:05:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7BECE1C210C9
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEE5148238;
	Thu,  1 Jun 2023 18:05:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7A64701B
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 18:05:40 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1781A1;
	Thu,  1 Jun 2023 11:05:21 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E4SJU028591;
	Thu, 1 Jun 2023 18:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=+VGVJIKb4yGy/KiAi81FFbe6tEAHT+4wYlU3QGTMmOE=;
 b=OHhKTruXx9iSqPXG7ohDeMzZj0Kbpf8QGYCIUmT6pM+Aa7EpZxiAHbAA5vLXGc2rDHH0
 WBhVKQHnp6/h7UU8zHGjOoxlKxZ9WsV9A12cRQTHWWVclW8FN+fPc07ef+6t9nviLlTz
 xN+4Qchw2o8NbQRGE+xerDlvcozBVBpIiRAXJ1NjVrICaGCnh0Lcvc1Km3xzySsxUpDk
 8oTTMV94vciTPHY7uOm2CiRxk5nsavWafbyn0kuS9dcn7J9u3X51US9t23wqbpO0KUbs
 8xQOqWdHsKzCFS1a30YSIKNRvVW9YT3UXDRv60TF4pm4v6Q4/FvyxBC039iGfU6QWddk Vg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhjkseqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 18:04:51 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351HUhVW003686;
	Thu, 1 Jun 2023 18:04:50 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4yf6emt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 18:04:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMQYrrlKGyv/0NQKrE0aHbMW71MDKXxcchY+E8vycSkjWqUgZ7NwCT5KYQWUbdPxiOymYQiro5d6OSRZDQlHD7dCpFmXJtJr3LlBNjWy4gaQ3nzrhMj61XOEPtSX75GiWU4yrCb6G0rLo9IHwGgA8llQ4uukqLzpi4r+XoRKioUdZUA3du3ZGzk+Zadv1S2O5Gmsw/zfxdK51PPOyibW8K8r3J1mHwmbEMpUTnVPUJ+HibzW0Nty4GhCaiTYU5oShC+Vh/z8iLC1fdGDIK12vRj8mETnT5gsXP6UniLMtui8C/fGGRzv0pCzocQ1U+rocZe3PhZHvW9K0VbOtJJQXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VGVJIKb4yGy/KiAi81FFbe6tEAHT+4wYlU3QGTMmOE=;
 b=izXZzr++65bn1iO8MPy5Yuxf4DYJkd5oiCY1lxymyb5suMNvr4mF5leTeZJ2VOwq7Nk/ivgUNZwqfI9B8vOmxSdn6Z/dDZm8H4tgPeAjoG/+yvDE4Z1ky/dMhTGbo74S0S0k3iIDXCq75nY6KfwlPOA5bssChje2qUYDgGnEO13ry1JSycc1Ez0PJGWLOLvDIt5fYvV+hMRdDIqWPTXpEUFsGd4ecgYApeIckiUgmbWqFNJ1owbrBe3GhDR00McfV7KkhDuJBKwuQeX639yD16C8aKvZBL0R7JLnwRUI+VGgyQf3/yNquoDUVBIxT3HCVwvpNqYjhbnpy4pMUFWiCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VGVJIKb4yGy/KiAi81FFbe6tEAHT+4wYlU3QGTMmOE=;
 b=E0jxPxodFzPevPtNYEkC/WBC3x1HtssjCGVyXhpgQR9mk6H9pLMXTw9K6P2LMywEEOewAffRbkAySZjJ2QN7IFzcctZnkB3Kstb3H87ajXVR0/B/k3r1iBtl3t2VY2TY5UOh8Ica3Vow86kDQZg16/lxbuI11fKL/GXfPvRo8GI=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by IA1PR10MB6685.namprd10.prod.outlook.com (2603:10b6:208:41b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 18:04:47 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::998f:d221:5fb6:c67d]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::998f:d221:5fb6:c67d%7]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 18:04:47 +0000
Date: Thu, 1 Jun 2023 14:04:43 -0400
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc: davem@davemloft.net, david@fries.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, zbr@ioremap.net, brauner@kernel.org,
        johannes@sipsolutions.net, ecree.xilinx@gmail.com, leon@kernel.org,
        keescook@chromium.org, socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v5 3/6] connector/cn_proc: Add filtering to fix some bugs
Message-ID: <20230601180443.pzmziatbb5ua66qt@revolver>
References: <20230420202709.3207243-1-anjali.k.kulkarni@oracle.com>
 <20230420202709.3207243-4-anjali.k.kulkarni@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230420202709.3207243-4-anjali.k.kulkarni@oracle.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT3PR01CA0139.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::31) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|IA1PR10MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e0c2370-4f81-4471-6df2-08db62caaf62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	6Z5/HXM11/GfHj1zOeNk/pmnj1fRiEsmvPKuuNqLfwIdOnUaTPxp6PBSrtHFQfQl3/SassByPOhzD5kUTm7wNo3PpGHUS4yUcf7n6gBdR7SaH3zYfGaNIlaK/Jsg378/3iNKN4xnk7+EQUDhj6B/BUsya5Ka5X39V/n9F2REACb4L2qHaI0IGxCgQB+o477hZd1rlJy6XACOyZbAYFelSwyr6J41cgdmK2z4Et/dw76BY1wE7/Ag3kOYJIcBqETMbyyW80R+TAi/opiEyX8n0f0M+hMXMy9snvq2HqWI5z1sck2o9ThMqejqp+xBSgW7Fn7/Vh8pqVEe2EhIbnPk89ddC76hTfQnw3oUzLuiiLdMe7dFygjJwAB3clC8Y2jrUi5NM3mDMdGzmCI4un9ABUTW9K2WYJGakfQQOvABOX8rbmIOiNf4T6VTtwutn/WaPM9HCNhhz76Yin9kgF1ZxdsNIEjNn5qdvntTGOfiUZYYVKVIu4e8OKDE4t+Nx6l4unFyyJ5rWzNWGyFoaYgJWcyiMQ8zLRhOXW5NZUNvTG6xHieaR6Nx9xckcuwY0eTK
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199021)(83380400001)(86362001)(66556008)(66946007)(66476007)(6666004)(6636002)(7416002)(5660300002)(316002)(4326008)(8676002)(33716001)(6862004)(38100700002)(8936002)(6486002)(41300700001)(6512007)(6506007)(9686003)(2906002)(186003)(478600001)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?UIJ8QFu8y7sPsEcYMVtV8pDu/HutGInEo7jp0Gkfbh9b1KnRmysjl5gmr9Qd?=
 =?us-ascii?Q?Bvcb4A5u/yZXf768CtOxRAde8joSswU5aYVe19V81p3NmH4CLmlPjxJ/LXS5?=
 =?us-ascii?Q?kBXkLlgGJcurPeFOf6pJRnhZy3Mk3Tzdu+EgJO/H+RHTJQyQYtAb1ko9QsCM?=
 =?us-ascii?Q?eAai86+vAQyjMQym4sTxkxy6kvgpCaul0xjuKWRxcR+LcsJvebUtjQXciUIL?=
 =?us-ascii?Q?kUlHQAPfU6m1m+tbUO77ztdPpJNRPciX5ukWxK+e8EnAIx9MpmRblckPEF01?=
 =?us-ascii?Q?j0BPHLB/7tGTddqcbAlfoFfoDc2kukTefDkD2lk+dF/0n94g1Ou8KzslCkpi?=
 =?us-ascii?Q?waK8A9+7KDrnLXdDCxRKogFa0N/qfZGDVXWZsyHzWgy1m0/M0l2vxLzcNrl5?=
 =?us-ascii?Q?mOZRnnomJfZSdKAQ/rEfKMeUKOQMAOb45MQLPxPMmjZ6g8IWRY+iwxwplKw9?=
 =?us-ascii?Q?1j2ySpIzAeiArZWMbyX8m3XTY+WRzHChI4mahMRkuEfaGcV394NdeKjmYQe1?=
 =?us-ascii?Q?LtdLq4JZFRCImNy3iIx0cuLBYJqiY1x244UIXYXtEfUKEKK8a11wkM4pD3lh?=
 =?us-ascii?Q?vdD0N4bOD+uJz0c9/h9srSNUNNedctIZu0Okvo7OD8ycLz5V7Fl9EnJzmnke?=
 =?us-ascii?Q?/F/xuyRfSaIv51GxXrB1pO4rJ6FbixdiiE+200+4dPWkOtp7v4TAeSmUMX2d?=
 =?us-ascii?Q?nqoVBNwOsq+RW4sEd/RgsUlK5RycMStkAV3exZFYeirXQYHMKz9fZS7wbkuY?=
 =?us-ascii?Q?zGW2IvnXVMFya56/QJznUyEIGPnOvQM+JlVXYCQdUqgQgU/rm2ynX2yZNmc4?=
 =?us-ascii?Q?A2PjOmTxAdgWlu5USUIDuIl2MtW4Ieel15lhx3I67AVV+l6L2YIL+ACT4j+C?=
 =?us-ascii?Q?8mGGSblOBbvrF8JXqj27U4EYHsPMZBLVofB1wpRqFjJjCV5FDGfws3lmmkVD?=
 =?us-ascii?Q?Vd+OOPqVqN/at72JcNE2fpTlfQxWaJm3LQFAXpLJqTXp7bHsw9yBNgetQ/Px?=
 =?us-ascii?Q?oa/Cqoo3F/C/+rXLYj0iaEwGfalnBAf7Q5hRCzpogFcIauPV/smyHEw6dAfk?=
 =?us-ascii?Q?2mGoFEjgYhIvXMwG+iYb+z+DRLpcobZJU6vHeIvH//gmBAPIlDStTcCqs3dW?=
 =?us-ascii?Q?UPiGBzW2VEqWTHmkDxOMVfPrwp0H/CtCmMnxnYRePRS0fCWNUzmrIgYbRA9V?=
 =?us-ascii?Q?wP5y3iuuP8JZ5ktaWiQ2NjAXtoO1cGPt3G86wbbYIZx3iqAqxfneUw0Yl+Af?=
 =?us-ascii?Q?DTVfVwnMh+gEPLgppk/EFY/LmFjpjn9NyTsS7YtWt88ZnBABY8MsW3bmj6ke?=
 =?us-ascii?Q?fl07xdVq/a8Yvq/F4lRLBxrBtgtSb7qydl8UHItEUpZ7HmX2MZanb3aA7v1S?=
 =?us-ascii?Q?QSck6nbzAhh4s8TXscIXSvGYm61pVaRd7KQcgYQEmfCebyhFuWxZAyI7lE0g?=
 =?us-ascii?Q?vgP9mdQDcHkqCG7a4RZNqo+3GQWEvlCJJvXtbbDamLVaEGvlyjRfsY2Vunww?=
 =?us-ascii?Q?ff8IIBj3HJw6wFHVfpodjZ03VPY0HtWZ1CcElWP6474BQ5d9JrSaxLxVu+bq?=
 =?us-ascii?Q?8uR2ZnOvFKydw+dFCSUp+dGI7r/8jmnET8SLSEdvq4GjeeAuaTHOYIENg9IG?=
 =?us-ascii?Q?YQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?Nb/yY2a8+Abv37mXwNWa1nVlmFRieXuYOhvtDhWZ3CbIFGOsAWnjSCFQAKHq?=
 =?us-ascii?Q?3Eq/3EC5VqnTgX7JmCkvLp962FbzrYYyl/W8vwJk3pJWwODwDoeUSm2UEopZ?=
 =?us-ascii?Q?ysk+parqJjqy93RZEz05CQVygkWqojsJiq4U+Kwo0fzaay95xQcJ1X+KMFtC?=
 =?us-ascii?Q?//ZZYNMcDW6BxMz7i3lJpvs/iVkKNBQrXW07CXXKLMSzmD6dO921Z8wsFP68?=
 =?us-ascii?Q?oNf2dED8twUWGdKsucjmbFpuKbAcUbUeGIuOP0YwlemNYy+podgRt0RwSzdl?=
 =?us-ascii?Q?pjVxrwJdCQA9H2bROpYM32fWI5jCUPdmDLLwJjh7CYZ+N18qJdNPlUQ9+Iqy?=
 =?us-ascii?Q?WlpTI9wdzFmOYIrOvvKGWcjM6TlOFfjnpbEcGakCRMOz3p9WqUbbFuGBuNf2?=
 =?us-ascii?Q?ToXh25HXf5vz3DckLB88qgxHx3yRMw8bZ3YhI0asGwxEm9nnd4KOgqyAyDc8?=
 =?us-ascii?Q?H2x4JFqG7bfHf5h39Odq3jfJ5F2iHqemuBBD9WUb6WhbXb91fPPBJsKdYJsO?=
 =?us-ascii?Q?jGF7PH9BzD6dpnBnoRzZXCD4DXSZHbh5he7BcA9gKvKR8GsYvZR1r0gXVIjQ?=
 =?us-ascii?Q?uNeRZ8tpGsZ37SsAEo32v+6eSXOCv1FlOq8zhGJfFJZdr2c4sIoijio161IQ?=
 =?us-ascii?Q?XRyn6jD8Nu+nexIhy7dQD/3DVyS4o+qqcD/fv1L9dhcoUPr6lLlP0/F+akC6?=
 =?us-ascii?Q?qJInH64lF5Jqx90SDtY02/1RDygeT4A/qAt6mAIxgZckp6zkD1zB4nJ1E9bB?=
 =?us-ascii?Q?IOcVREx5T3YLpM6M9QQwxJ9TDdG90yIxtGlLj40x9SvHbalZjgUjJz4vTu8r?=
 =?us-ascii?Q?Ldr5J2qnCoWe7QtN5R119Y2Gvxkj6m0jsKA4BopucyXnqnZiHxacHwQaJ4QE?=
 =?us-ascii?Q?LrdvOGE175C/NV1+y+tLKCU8qhF/VnrUr+0/z/Of6LoOEtFV/3T1IkcJd4nt?=
 =?us-ascii?Q?db/tsfAmTqkCORLEocOZm2eqQBdpIP0xMIeqwSdsiwFuzxfLBiNaf4J9uXGn?=
 =?us-ascii?Q?XEeZddohxoEpeOQ7HA6MGkBPVrnEvX+1Th6uOdX/CyBgSZuno8RRpS/Gyh7E?=
 =?us-ascii?Q?oc+9tPmqXj93wbHzHgP/zr+1S5Jeb7MVuCgLCZ0Qf8fDyEkuMpI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e0c2370-4f81-4471-6df2-08db62caaf62
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 18:04:47.0739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hjtD1OMKqHxyrgKCjerF1xmU1Z564MLWR9PRh4aCue4oRYEYeaP643mBQw9/LxlUQVOs505AtnN/BwK+8Rk5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6685
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010156
X-Proofpoint-ORIG-GUID: C1M70I2R0W49u89jS6mBvMcHP0V6RLvF
X-Proofpoint-GUID: C1M70I2R0W49u89jS6mBvMcHP0V6RLvF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

* Anjali Kulkarni <anjali.k.kulkarni@oracle.com> [691231 23:00]:
> The current proc connector code has the foll. bugs - if there are more
> than one listeners for the proc connector messages, and one of them
> deregisters for listening using PROC_CN_MCAST_IGNORE, they will still get
> all proc connector messages, as long as there is another listener.
> 
> Another issue is if one client calls PROC_CN_MCAST_LISTEN, and another one
> calls PROC_CN_MCAST_IGNORE, then both will end up not getting any messages.
> 
> This patch adds filtering and drops packet if client has sent
> PROC_CN_MCAST_IGNORE. This data is stored in the client socket's
> sk_user_data. In addition, we only increment or decrement
> proc_event_num_listeners once per client. This fixes the above issues.
> 
> cn_release is the release function added for NETLINK_CONNECTOR. It uses
> the newly added netlink_release function added to netlink_sock. It will
> free sk_user_data.
> 
> Signed-off-by: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  drivers/connector/cn_proc.c   | 53 ++++++++++++++++++++++++++++-------
>  drivers/connector/connector.c | 21 +++++++++++---
>  drivers/w1/w1_netlink.c       |  6 ++--
>  include/linux/connector.h     |  8 +++++-
>  include/uapi/linux/cn_proc.h  | 43 ++++++++++++++++------------
>  5 files changed, 96 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> index ccac1c453080..84f38d2bd4b9 100644
> --- a/drivers/connector/cn_proc.c
> +++ b/drivers/connector/cn_proc.c
> @@ -48,6 +48,21 @@ static DEFINE_PER_CPU(struct local_event, local_event) = {
>  	.lock = INIT_LOCAL_LOCK(lock),
>  };
>  
> +static int cn_filter(struct sock *dsk, struct sk_buff *skb, void *data)
> +{
> +	enum proc_cn_mcast_op mc_op;
> +
> +	if (!dsk)
> +		return 0;
> +
> +	mc_op = ((struct proc_input *)(dsk->sk_user_data))->mcast_op;
> +
> +	if (mc_op == PROC_CN_MCAST_IGNORE)
> +		return 1;
> +
> +	return 0;
> +}
> +
>  static inline void send_msg(struct cn_msg *msg)
>  {
>  	local_lock(&local_event.lock);
> @@ -61,7 +76,8 @@ static inline void send_msg(struct cn_msg *msg)
>  	 *
>  	 * If cn_netlink_send() fails, the data is not sent.
>  	 */
> -	cn_netlink_send(msg, 0, CN_IDX_PROC, GFP_NOWAIT);
> +	cn_netlink_send_mult(msg, msg->len, 0, CN_IDX_PROC, GFP_NOWAIT,
> +			     cn_filter, NULL);
>  
>  	local_unlock(&local_event.lock);
>  }
> @@ -346,11 +362,9 @@ static void cn_proc_ack(int err, int rcvd_seq, int rcvd_ack)
>  static void cn_proc_mcast_ctl(struct cn_msg *msg,
>  			      struct netlink_skb_parms *nsp)
>  {
> -	enum proc_cn_mcast_op *mc_op = NULL;
> -	int err = 0;
> -
> -	if (msg->len != sizeof(*mc_op))
> -		return;
> +	enum proc_cn_mcast_op mc_op = 0, prev_mc_op = 0;
> +	int err = 0, initial = 0;
> +	struct sock *sk = NULL;
>  
>  	/* 
>  	 * Events are reported with respect to the initial pid
> @@ -367,13 +381,32 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
>  		goto out;
>  	}
>  
> -	mc_op = (enum proc_cn_mcast_op *)msg->data;
> -	switch (*mc_op) {
> +	if (msg->len == sizeof(mc_op))
> +		mc_op = *((enum proc_cn_mcast_op *)msg->data);
> +	else
> +		return;
> +
> +	if (nsp->sk) {
> +		sk = nsp->sk;
> +		if (sk->sk_user_data == NULL) {
> +			sk->sk_user_data = kzalloc(sizeof(struct proc_input),
> +						   GFP_KERNEL);
> +			initial = 1;
> +		} else {
> +			prev_mc_op =
> +			((struct proc_input *)(sk->sk_user_data))->mcast_op;
> +		}
> +		((struct proc_input *)(sk->sk_user_data))->mcast_op = mc_op;
> +	}
> +
> +	switch (mc_op) {
>  	case PROC_CN_MCAST_LISTEN:
> -		atomic_inc(&proc_event_num_listeners);
> +		if (initial || (prev_mc_op != PROC_CN_MCAST_LISTEN))
> +			atomic_inc(&proc_event_num_listeners);
>  		break;
>  	case PROC_CN_MCAST_IGNORE:
> -		atomic_dec(&proc_event_num_listeners);
> +		if (!initial && (prev_mc_op != PROC_CN_MCAST_IGNORE))
> +			atomic_dec(&proc_event_num_listeners);
>  		break;
>  	default:
>  		err = EINVAL;
> diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
> index 48ec7ce6ecac..d1179df2b0ba 100644
> --- a/drivers/connector/connector.c
> +++ b/drivers/connector/connector.c
> @@ -59,7 +59,9 @@ static int cn_already_initialized;
>   * both, or if both are zero then the group is looked up and sent there.
>   */
>  int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 __group,
> -	gfp_t gfp_mask)
> +	gfp_t gfp_mask,
> +	int (*filter)(struct sock *dsk, struct sk_buff *skb, void *data),
> +	void *filter_data)
>  {
>  	struct cn_callback_entry *__cbq;
>  	unsigned int size;
> @@ -110,8 +112,9 @@ int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 __group,
>  	NETLINK_CB(skb).dst_group = group;
>  
>  	if (group)
> -		return netlink_broadcast(dev->nls, skb, portid, group,
> -					 gfp_mask);
> +		return netlink_broadcast_filtered(dev->nls, skb, portid, group,
> +						  gfp_mask, filter,
> +						  (void *)filter_data);
>  	return netlink_unicast(dev->nls, skb, portid,
>  			!gfpflags_allow_blocking(gfp_mask));
>  }
> @@ -121,7 +124,8 @@ EXPORT_SYMBOL_GPL(cn_netlink_send_mult);
>  int cn_netlink_send(struct cn_msg *msg, u32 portid, u32 __group,
>  	gfp_t gfp_mask)
>  {
> -	return cn_netlink_send_mult(msg, msg->len, portid, __group, gfp_mask);
> +	return cn_netlink_send_mult(msg, msg->len, portid, __group, gfp_mask,
> +				    NULL, NULL);
>  }
>  EXPORT_SYMBOL_GPL(cn_netlink_send);
>  
> @@ -162,6 +166,14 @@ static int cn_call_callback(struct sk_buff *skb)
>  	return err;
>  }
>  
> +static void cn_release(struct sock *sk, unsigned long *groups)
> +{
> +	if (groups && test_bit(CN_IDX_PROC - 1, groups)) {
> +		kfree(sk->sk_user_data);
> +		sk->sk_user_data = NULL;
> +	}
> +}
> +
>  /*
>   * Main netlink receiving function.
>   *
> @@ -249,6 +261,7 @@ static int cn_init(void)
>  	struct netlink_kernel_cfg cfg = {
>  		.groups	= CN_NETLINK_USERS + 0xf,
>  		.input	= cn_rx_skb,
> +		.release = cn_release,
>  	};
>  
>  	dev->nls = netlink_kernel_create(&init_net, NETLINK_CONNECTOR, &cfg);
> diff --git a/drivers/w1/w1_netlink.c b/drivers/w1/w1_netlink.c
> index db110cc442b1..691978cddab7 100644
> --- a/drivers/w1/w1_netlink.c
> +++ b/drivers/w1/w1_netlink.c
> @@ -65,7 +65,8 @@ static void w1_unref_block(struct w1_cb_block *block)
>  		u16 len = w1_reply_len(block);
>  		if (len) {
>  			cn_netlink_send_mult(block->first_cn, len,
> -				block->portid, 0, GFP_KERNEL);
> +					     block->portid, 0,
> +					     GFP_KERNEL, NULL, NULL);
>  		}
>  		kfree(block);
>  	}
> @@ -83,7 +84,8 @@ static void w1_reply_make_space(struct w1_cb_block *block, u16 space)
>  {
>  	u16 len = w1_reply_len(block);
>  	if (len + space >= block->maxlen) {
> -		cn_netlink_send_mult(block->first_cn, len, block->portid, 0, GFP_KERNEL);
> +		cn_netlink_send_mult(block->first_cn, len, block->portid,
> +				     0, GFP_KERNEL, NULL, NULL);
>  		block->first_cn->len = 0;
>  		block->cn = NULL;
>  		block->msg = NULL;
> diff --git a/include/linux/connector.h b/include/linux/connector.h
> index 487350bb19c3..cec2d99ae902 100644
> --- a/include/linux/connector.h
> +++ b/include/linux/connector.h
> @@ -90,13 +90,19 @@ void cn_del_callback(const struct cb_id *id);
>   *		If @group is not zero, then message will be delivered
>   *		to the specified group.
>   * @gfp_mask:	GFP mask.
> + * @filter:     Filter function to be used at netlink layer.
> + * @filter_data:Filter data to be supplied to the filter function
>   *
>   * It can be safely called from softirq context, but may silently
>   * fail under strong memory pressure.
>   *
>   * If there are no listeners for given group %-ESRCH can be returned.
>   */
> -int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid, u32 group, gfp_t gfp_mask);
> +int cn_netlink_send_mult(struct cn_msg *msg, u16 len, u32 portid,
> +			 u32 group, gfp_t gfp_mask,
> +			 int (*filter)(struct sock *dsk, struct sk_buff *skb,
> +				       void *data),
> +			 void *filter_data);
>  
>  /**
>   * cn_netlink_send - Sends message to the specified groups.
> diff --git a/include/uapi/linux/cn_proc.h b/include/uapi/linux/cn_proc.h
> index db210625cee8..6a06fb424313 100644
> --- a/include/uapi/linux/cn_proc.h
> +++ b/include/uapi/linux/cn_proc.h
> @@ -30,6 +30,30 @@ enum proc_cn_mcast_op {
>  	PROC_CN_MCAST_IGNORE = 2
>  };
>  
> +enum proc_cn_event {
> +	/* Use successive bits so the enums can be used to record
> +	 * sets of events as well
> +	 */
> +	PROC_EVENT_NONE = 0x00000000,
> +	PROC_EVENT_FORK = 0x00000001,
> +	PROC_EVENT_EXEC = 0x00000002,
> +	PROC_EVENT_UID  = 0x00000004,
> +	PROC_EVENT_GID  = 0x00000040,
> +	PROC_EVENT_SID  = 0x00000080,
> +	PROC_EVENT_PTRACE = 0x00000100,
> +	PROC_EVENT_COMM = 0x00000200,
> +	/* "next" should be 0x00000400 */
> +	/* "last" is the last process event: exit,
> +	 * while "next to last" is coredumping event
> +	 */
> +	PROC_EVENT_COREDUMP = 0x40000000,
> +	PROC_EVENT_EXIT = 0x80000000
> +};
> +
> +struct proc_input {
> +	enum proc_cn_mcast_op mcast_op;
> +};
> +
>  /*
>   * From the user's point of view, the process
>   * ID is the thread group ID and thread ID is the internal
> @@ -44,24 +68,7 @@ enum proc_cn_mcast_op {
>   */
>  
>  struct proc_event {
> -	enum what {
> -		/* Use successive bits so the enums can be used to record
> -		 * sets of events as well
> -		 */
> -		PROC_EVENT_NONE = 0x00000000,
> -		PROC_EVENT_FORK = 0x00000001,
> -		PROC_EVENT_EXEC = 0x00000002,
> -		PROC_EVENT_UID  = 0x00000004,
> -		PROC_EVENT_GID  = 0x00000040,
> -		PROC_EVENT_SID  = 0x00000080,
> -		PROC_EVENT_PTRACE = 0x00000100,
> -		PROC_EVENT_COMM = 0x00000200,
> -		/* "next" should be 0x00000400 */
> -		/* "last" is the last process event: exit,
> -		 * while "next to last" is coredumping event */
> -		PROC_EVENT_COREDUMP = 0x40000000,
> -		PROC_EVENT_EXIT = 0x80000000
> -	} what;
> +	enum proc_cn_event what;
>  	__u32 cpu;
>  	__u64 __attribute__((aligned(8))) timestamp_ns;
>  		/* Number of nano seconds since system boot */
> -- 
> 2.40.0
> 

