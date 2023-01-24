Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C2067A424
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 21:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbjAXUot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 15:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbjAXUol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 15:44:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A0A422F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 12:44:39 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OGNxLC007260;
        Tue, 24 Jan 2023 20:44:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=4gX8ngZckimhU1g8sI9qUmmqM1j0qmewGZpYiA8DKE8=;
 b=uQHX8frl+L1Tpa6jhKPFm9dsPhuQpLRMQw9PYK9GfYOF9cPDzIrC+drC6m5qFiIr7aNO
 1Vknt+4fYujtGp+lmjBaHnWxmjS2+OWCc4R5TSHdEBvuSwpD2EHFesKy3xgldjE9xRJr
 nf5UlbQyISZWP07gF2dCRErE0k0/ukGNUG3/87M7ZfYLPNLKnXppBwLdRm3LvxAnbDGm
 bqG3RoY7fC/PR81qESrWJQ/s1cyGPMyzrV8gExNPCFWVzm76Jq6HmtSv85LVFQyyTEWX
 UbT0hQ8m/48q+gInA5An1zsL0L25Qt3k2QWj2olZIeL+vTL4mVhogitwmRbNYwCKyg30 ww== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n0xfhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 20:44:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OKaoqd021316;
        Tue, 24 Jan 2023 20:44:26 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g5g74x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 20:44:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DiqwYbD4Ep+eWDTK+8gxBHaCOecS06G0FGYYVUkB90Qtn5mgmCz5DcFaz4v+Sj4R7kU4sQvqAOiDtHneGUtPOH71hCMxJDCkLBycyqfGKAPq3wIduKG758WL3cXGdQXnvCk2ipJdZlt1hMq6zE/TGtk4PcGpFIPNN1dDoUv5pjmq2u5I4GK9rgcnQu2NYUcE9uUdIIa4rAd9mneNJC5K6VfHmup7fKi0nr4PhxHslN1mA9oUY2NnR0VHjnpKjTQVQHznakw/6L9IblOZm+e7wSrFEFAMtgJk4F59QTRyDQwmoQfD0Obgh4kmLtGRsITlIwfzYYqrG42IaiT/1amKbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gX8ngZckimhU1g8sI9qUmmqM1j0qmewGZpYiA8DKE8=;
 b=Wzr+h4oMGaHG+Fvy0Ef22IqFZn6t8BcImO5Kq/Myb7izox1EQ29BdGmg8wbImV68dD/7ZlgXYYORDAnrpl/hudKIadfqXOobbGzS6SGZ6tKxEHX3FhSrtZxYt0rg5UfmZZg7MQdjtIgiz19dYHbFtyhL45ExkFlFifcWZzIQccMwjgxrx5NThf0fSag1VIlb/2AssQYZVZta5JBFdvwIOXj0IWk/MqbeGSd1Q99CgjRQe3AU7drfyHxHyJW6gKx3ZgTyJu3eN6cDHpHGEXrxd2pFTSMr1M6xpNMYnBw7YpzwvtKHP3nWJGsJ216YkRc0+TXpCIGT8heAwdjhRLcPWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gX8ngZckimhU1g8sI9qUmmqM1j0qmewGZpYiA8DKE8=;
 b=tvbjHZhakpMyKgWCMeZVVpRsWe0VlU2Wvk8akSVLMuioJMAHnvk/oyIrdJe8aOGHZ/99OLFjvvmcCCW3WciUj+3//At2V65kppFUQJujKb1tDldtK1RyzBPbO6fEuFsPc48tQQ/hgF5YKdVi/SPPW/6AyVLrfYVGlBEfEwwtHA8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB5786.namprd10.prod.outlook.com (2603:10b6:a03:3d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 20:44:21 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%8]) with mapi id 15.20.6043.017; Tue, 24 Jan 2023
 20:44:21 +0000
Date:   Tue, 24 Jan 2023 12:44:19 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        kernel test robot <lkp@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        amd-gfx@lists.freedesktop.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 a54df7622717a40ddec95fd98086aff8ba7839a6
Message-ID: <Y9BDIzZY73KjFe3X@monkey>
References: <63d00931.j+gAM+ywiXvJX7wP%lkp@intel.com>
 <20230124122800.a8c3affd99d6d916a10a1479@linux-foundation.org>
 <54b10139-6652-6a4b-a143-0df9bcbd2910@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54b10139-6652-6a4b-a143-0df9bcbd2910@oracle.com>
X-ClientProxiedBy: MW4PR03CA0033.namprd03.prod.outlook.com
 (2603:10b6:303:8e::8) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SJ0PR10MB5786:EE_
X-MS-Office365-Filtering-Correlation-Id: 89723321-40fc-4e11-1b34-08dafe4bc552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xl/Y1HEVT45YR93/oVxH+mQUoaSFU1NallGRzZmAHY+TijsPcJrEvfgXqrRG6FghOT8TTngtl/GJTfSSxDUC3zFpmXzmCNylkPQHbWR9FRrdUfw2bwKA3AMuu+/54YbGhCxBlwAGQPfV4E4EAmeYdufGESzNEyuWu9qczaXcc7pAfs6YcwRW7ICunAjKd5yRgPbA4NYLJ+WfKru5c+BI0tJ0YegcPKf3KPHKoQ31l6y5PPRkbXnd4YsyKCYGZE87VBwcuKdamvKYedZV4l3+ilYtztnjlVTp9UdnpvRkAE5NdIZeJII4giKK31mvjSJ9EddBLdw4X8O4ldJ0B1VLLLnANOCy4RxILWPszZ11/CCFg+5EvQTzYxS0AcL/I9c13uO9e9WSGmEuq2KWvpD6WyUcQAvxrQIxIlh0mDj3sKLMr5nkxkJQiI+DC881mdGjrop+KA4JHwhXplzzrFlPLlfvdPs81wHtXYpm3qRKSIZiNhgS9cqdzZMSZCG9m9e7aydgPfDRLCJUnpcVMmR15Ky8Y6L2T4BgY3ERgpV2O1dllMw89ckNXMTXQKT331ebOQganEGeMIux9J6E7l8+xhcqK3rnCj+n2Nd3taVdUkDgSOsDcWlf3PIihVbuUEQ+X0NTdd442pHEsPJguZ3RmB6RqcYSX96aoBa22EjdoMk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(346002)(39860400002)(376002)(136003)(396003)(451199018)(86362001)(316002)(6862004)(6636002)(33716001)(966005)(6486002)(83380400001)(38100700002)(44832011)(8936002)(66946007)(4326008)(2906002)(66556008)(8676002)(5660300002)(66476007)(54906003)(41300700001)(6506007)(26005)(53546011)(478600001)(6512007)(9686003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3omLknYHDkMTUkWpESbRNOmq57D4BD9sU19M/zsYHZhS88dZ5yDYu8z7sj3o?=
 =?us-ascii?Q?3SYloddswIuyQ7UAy6lesXSYjbmynAVJjLGOcv/MuNfPCI/Yu9NqiFwZ5jf9?=
 =?us-ascii?Q?wGSHQtSRwbOm38hHtigjB+PD4Rm39Cq4GGZspyy+Sx/uCSqvoBizhg1yrXnh?=
 =?us-ascii?Q?kmVJIS86tKLrfkbLf3UOVCr3UFa+P1ehj1U+KK7dAwS+fcK9N/rQ1V5UldSd?=
 =?us-ascii?Q?SfrVO5l9omw0AN95OZPcljTcwZQ7PxXmdb1To4gSGQB2FOE2kA2brszci+xj?=
 =?us-ascii?Q?S0IV0iWpxuVD91eaDb4zjISu+yl+K0dOqjlrOIlOQZsEwq4ij8VDEnFa2qF1?=
 =?us-ascii?Q?qYZyYPXbrsaIPs/fOpJk3xbv6ey7eImGNl+it0X6zL9GQ5b4dOs2l6EdL1BZ?=
 =?us-ascii?Q?ETcX3q8UsqU/OENJq0/qFjyKRPXj22HyW6lhD2ThHar3agvihveHtFQCM0M8?=
 =?us-ascii?Q?DEIYeMOGMTFG9di2eCKogYzQc76Ws7siCyKDUJwd+2J1CbEmOhMfjLj3wQ8p?=
 =?us-ascii?Q?ZeUUaRdAcb8DFQFVKd4frElkVTbRa9Bi5oASBKTQMYdNYvdqj3zetIOoqiiR?=
 =?us-ascii?Q?KjSBZBeEdM+wUHEGsqblhYpcjMsAlN9DUcvXRn/RewmdFF/9EC1/a5idLoDC?=
 =?us-ascii?Q?eA/YZccEkV3MuqQ2DckfaIvw+stVm6tT65E6PTZmqZqJ5RudTwaFWJQaTrbC?=
 =?us-ascii?Q?SbOOXgTY+smGHRXvfvfgWGOySzox4pnJwX11PRthGEWjNX2yQ1Z+X8KGG/Me?=
 =?us-ascii?Q?F8P6OtbI+SeCOnAIusBhVoHa89Z9IYGDZqZmq8OOXDDXqGZMzxwgUmGSMGiw?=
 =?us-ascii?Q?DAzwN1Slt6bRejyq6nOnheQYxWThiU6E6sVlw8n8q7IPII6xYEQE7UIeLPye?=
 =?us-ascii?Q?QNkrZwIyN3YjVxjpMOTEV7WMTb2lfxcgjELxqPtlwAZoKUyE6aRZqmRlnpgE?=
 =?us-ascii?Q?7ZJZdq+DBq4+TklA7wZb1BSsl/YrCJCIndQE5M0qxlVhzfztn519eQaINZAg?=
 =?us-ascii?Q?yNB2gp0pDHrdWUuFhi0SKdTxrpY0lErrVFwkKeHhQdFU6sEwVavDkeiVzxqW?=
 =?us-ascii?Q?Nrtcufxa2WLpcZcvjXO2ybLzgTDt8+FTkuH57INwOKptQzxLr1cL1jWYVt1Y?=
 =?us-ascii?Q?8G4sZ9d/XS2MqtK9cNgQFVFU99lfpa+HZF1E2/kyFxusgq6p8zqVq9+jgnjL?=
 =?us-ascii?Q?Oadi7ui80q11Tqkl+//LtTwAHNvZ9y9RhwQJ10yohZEE0no99zetUPXZnlnr?=
 =?us-ascii?Q?GCDB8dV5qpdp6tF7F4z4t8UI66Lmh9vPR1R0xydClIxzcWFbYAEDFX9F3S/n?=
 =?us-ascii?Q?E67p9pal/ztQLLY1+5D4DwxgUoYfHri1dU382CvP6gHSocZkzTKJJTjiWI7r?=
 =?us-ascii?Q?hsKWw7YvwSkf5RYFdB87u/1UiaZR4/NCZJQgwSRieP64V4hhA7yRFu/yRAOl?=
 =?us-ascii?Q?IK8fvJbMP+i2j/6wtL9rm7n00UBcVoE5VfD1cCeUaGyu9M3ln5vI0lI8On2R?=
 =?us-ascii?Q?tyaNlGsvInnyOclVLkFKwsyUGVaOcI7Sr9r962/Pm/hpbMuBgy3uiVpNC3Qg?=
 =?us-ascii?Q?7QUCjDvKyS2s9R2HefZuXS7BPQ+WzcG0sPTGJv7+Wgr4X+JANCqg26H6WknC?=
 =?us-ascii?Q?6g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?GL6qjP+NQHhXK4v6GnCaOWtgMaH/gUkhtTd8+dcZ6sBu9aE+KyoYEcp+pYOU?=
 =?us-ascii?Q?2AgwnDtX14k3lh1LOBH1wJGzoREMsmbA/Lbz33nwDRKOTRbmKPoK7SpCBKuZ?=
 =?us-ascii?Q?I1SsxD5jawJFP5PsoNfQDLp9rqxGZ0Ur4s+hzmftGwKmbr6DW3NTn4q3vcSI?=
 =?us-ascii?Q?JW4tFIkD7KOfyFRVW2MT2xdnxFT+EvLY7IOaWuUI2QyUpx++w9/TRGL4BSsf?=
 =?us-ascii?Q?Mrf8lbDH9fDArtKsTIO11w5STj7A67WJ3kaOVEJ3bkc0NUf69h0DvBFPQNMf?=
 =?us-ascii?Q?4hrwTTgq47vSxKGjZ8xtUqFyS+1+xz9ro6Z+sTFfrvdGnsbTc8QSAbTNQjyS?=
 =?us-ascii?Q?F3A5Ax7dnP+JsR7duC/WoTKp78h0z6CCHxr22LNMHaQcJ2CUnUTp8Egf7XTZ?=
 =?us-ascii?Q?VPP2o7WU9/NIOJboHRV2YO+WdC1mbmGcBPmsUiLOMPYuTjNSr6CRl2SGscDq?=
 =?us-ascii?Q?jvZzV0K7b2ycwTk/SODg5sQDlSfu78f+HeJd2c3RHzV6JA2mKUYUacLtsTmf?=
 =?us-ascii?Q?idJD/DmOHfuzUnLqwLOVmGJFbZhDekRWbJB8FErlj8eFjCvm4fBHFqDDJKm+?=
 =?us-ascii?Q?YjjW4bMo/DtcGEvZP8KMq97jXRyQxJKHF5cv7VzdGPvyJ2TJwvo3DJQtNJOK?=
 =?us-ascii?Q?s9yNbN+MnCvE10ut9KMIjkBxKRZjqipTGdMaU0VobN5FPdPoNuEiX63NixM0?=
 =?us-ascii?Q?szIT11OGAJntlRdflqzHHpKYGQjZ0obIdTdFjv8dOnyGZqqRjnSwotarXEN1?=
 =?us-ascii?Q?bD4T8Vi9G7MPGyQ6ixfy8itvbT90p4mm4+RhBC5amq7cAES3iMGLIK8Uj0AO?=
 =?us-ascii?Q?Xp6Om63nQ3uaNbycqUgbG7jCU0x5DIQOAYCbi8vUxPYzi4ShiRFPy+U0AnU0?=
 =?us-ascii?Q?eDDXHZzgjngFBLjtLc3OlRGu9xq/6EV2t6k6C5eGD4ZztwCT+43IQ9z16qsq?=
 =?us-ascii?Q?wmrHjnp4FZoJr+pyHHX6ZoOcHIVCpi7TMDZn/bOV5v9PZcbASCK0s9cXWaKI?=
 =?us-ascii?Q?NPTBsbhxV+En7e5IYmwNUTSf2m6u3ysrSwZv+60CXSf4ZwSBra/XGdPHLLn9?=
 =?us-ascii?Q?rkT0fcro05fZUflmSoNNRPzWzkwEBw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89723321-40fc-4e11-1b34-08dafe4bc552
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 20:44:21.4091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XLpLcC7UvzCLu8LfcHZPme7bWiDCNChfn1HfZ4KiDZfxy2RNZjNgo67VVJ1FBz+BcaxlVTPUArMOq0NTKuhM6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_15,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240191
X-Proofpoint-GUID: 1gw5F1b9L-O6zsoLDIuya5SgYrOdoUtW
X-Proofpoint-ORIG-GUID: 1gw5F1b9L-O6zsoLDIuya5SgYrOdoUtW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/24/23 12:42, Sidhartha Kumar wrote:
> On 1/24/23 12:28 PM, Andrew Morton wrote:
> > On Wed, 25 Jan 2023 00:37:05 +0800 kernel test robot <lkp@intel.com> wrote:
> > 
> > > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> > > branch HEAD: a54df7622717a40ddec95fd98086aff8ba7839a6  Add linux-next specific files for 20230124
> > > 
> > > Error/Warning: (recently discovered and may have been fixed)
> > > 
> > > ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/fsl-edma.ko] undefined!
> > > ERROR: modpost: "devm_platform_ioremap_resource" [drivers/dma/idma64.ko] undefined!
> > > drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_dp_training.c:1585:38: warning: variable 'result' set but not used [-Wunused-but-set-variable]
> > > 
> > > Unverified Error/Warning (likely false positive, please contact us if interested):
> > > 
> > > ...
> > > 
> > > mm/hugetlb.c:3100 alloc_hugetlb_folio() error: uninitialized symbol 'h_cg'.
> > 
> > 	hugetlb_cgroup_commit_charge(idx, pages_per_huge_page(h), h_cg, folio);
> > 
> > The warning looks to be bogus.  I guess we could put a "= NULL" in
> > there to keep the compiler quiet?
> > 
> This could be because if CONFIG_CGROUP_HUGETLB is not set, the function in
> alloc_hugetlb_folio() which initializes h_cg just returns 0
> 
> static inline int hugetlb_cgroup_charge_cgroup_rsvd(int idx,
> 				unsigned long nr_pages,
> 				struct hugetlb_cgroup **ptr)
> {
> 	return 0;
> }

Yes!

> 
> where ptr is h_cg. I can add a "= NULL" in the v2 of my hugetlb page fault
> conversion series.

Thanks
-- 
Mike Kravetz
