Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2B35F43F8
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 15:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiJDNLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 09:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiJDNLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 09:11:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837082A947;
        Tue,  4 Oct 2022 06:11:38 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 294B22Eg029891;
        Tue, 4 Oct 2022 13:10:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=faKg5jyFvoc7ulz5/2ZXMK3jXwlOwm42o93ZEoNGJww=;
 b=qlI3tW5g1Avb8ShARlDbwC8fw2T45VxQaz4CRmcrDYgLBkWszx2LeVdFSnjyqttx29DI
 JkTaaTsswugPiE0lBs3P9AF+AmSGy6HmGrun5egIGFFlCgAIEIEvc06PmyMI/wViAG6D
 liBvk7frV/PGc4UOWR8HWkSNO3C+QVa3xfFYIII1D3uY6fKER6SAl04N3eCc6U2qtQYj
 TynbbCxkf6jQQVuEs9I3bvu6x6KglmbIKcvfJlPJyeKLlZBzu4Tt7TkNDArySBtwEZdo
 p3e+Xkis1Aajq1n6mIH6noi5hKhJJne9a/wpaWSwxUHXKP69nwx/bEANQhcg+RhzGNMg Zw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2pc3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 13:10:58 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 294BJVdT020017;
        Tue, 4 Oct 2022 13:10:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc0afb16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Oct 2022 13:10:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hun2CHqWZjzrQJyGZA6t6ncDot4/x+eWAHQqBgf61PFrjcrGmENy3lb/m+H7HvITRdZAUc0AW4kgUbTdJfQSMFKgVrB6DA8XT9ee8l5mC+6rl4UYx6qmy8eniGJdG8S1CxzGFWlbVWIbU7LXkUbD5stBTQM9zUyoHbx2LpzlcyN9VLY97ve6zvPrRi95wGPC3NCF87OP1vIcUaf0bjcoxK+izu4EXTSf1HveJ1bOrR6Pi7P1HLKkuhERTu9ebJNXyEJ158OleuvR3ErFOTAzjGAbXNoi+A7PD+Kt6uOWDcN1nIHZFZxIMTH/i4/J1Hx72h8Veorhrcf1gYL4RnbBng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faKg5jyFvoc7ulz5/2ZXMK3jXwlOwm42o93ZEoNGJww=;
 b=MfLBeh2Cs6uvPb9HBzkuWmkzMBJpqgg5OcVBw+YdmqJRvTj5g+fDtYDIMytXueqARahygma6YZkBqpH/iktFjj0/j3AqXYcazDT3vFyk85z2/IRikEziGh+qS1gG6rAYFJzQCoKLXlaJIaw6dIm1+q5lCnmXUpHoY3C0ppxEAOGNvlgBtU4ba7bEBsgUj8Ru0yDWbpzZSoeSBDFJjI+vz7FS516UaX6QIBp6jyRmDBRN5A6u84O1/r3tmXAXgXkUnHKLM4dI3dcFGIoDY6gcO96AnwTlMq2W7MgGHACkzIVl9hR8+w9w5DDH3nhcz3pXevnFguhIN0Ub6JAcD3V4Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=faKg5jyFvoc7ulz5/2ZXMK3jXwlOwm42o93ZEoNGJww=;
 b=lpDfIQEiBEmK93nqPzI2g4Lx/MAQ/4plqDwwU4nOOe/RoN8lvhrYUUriwqhWs1C5neQW1L+soZgotlApw2UPwkVpLTroIe+JNnMpAKTba6dW33U2Jr2CLBs03ShQdX+PCx4y7hDU+iKkEk2zGq69PMpevsRRnOizKePS+gP1lM4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by DM6PR10MB4123.namprd10.prod.outlook.com
 (2603:10b6:5:210::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Tue, 4 Oct
 2022 13:10:55 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::1b8e:540e:10f0:9aec%4]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 13:10:55 +0000
Date:   Tue, 4 Oct 2022 16:10:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     v9fs-developer@lists.sourceforge.net, linux_oss@crudebyte.com,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Dominique Martinet <asmadeus@codewreck.org>,
        syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, ericvh@gmail.com,
        kuba@kernel.org, lucho@ionkov.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "9p: p9_client_create: use p9_client_destroy
 on failure"
Message-ID: <Yzww1LRLIE+It6J8@kadam>
References: <cover.1664442592.git.leonro@nvidia.com>
 <024537aa138893c838d9cacc2e24f311c1e83d25.1664442592.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <024537aa138893c838d9cacc2e24f311c1e83d25.1664442592.git.leonro@nvidia.com>
X-ClientProxiedBy: MR1P264CA0016.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::21) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2365:EE_|DM6PR10MB4123:EE_
X-MS-Office365-Filtering-Correlation-Id: 86650115-2223-412f-4159-08daa609dccf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pJx1wjtav+W4Ic9KSgRCELm6biZCDYW/KcnwVidRI/CO5OMiraJxIQRvPSNa+3CiUFCE3PAT2odaLwqtxbRO/kHgYEAxl8Dzb1FnZbjRkBX28IUNt9Nw+AU/e27DcIWQfUuvI/RlKeE14n5mzpEJaYH9OZsD8jIXq9FB3qMmSHEkYxDsWJJik7ilg8PV7qu0uT26t30WbdVOVsCxLLUKUPHErQP85ImvOtYesyCYRb+amSu7FhDduTbxtrdb46FGYvcAMKpSyxPXWFO+23EVYLA5mBRBtL22eLZkD6mzt9lJmX91i0UMLFQI6etfP9phxsUJkbVdzo2F4huPfJlimiFD3SnklNqIqzm0QRq/THVZ4CrBjRbkcXUMbFK4HtFeArs1yFZtPanhJ/VaE9VFsdmQhKnHcb9sm5hwCTMok+R9qfK1pjsTy+0MG/qF8kImslFwIp1X66UBQoV0waCYSkTFxdOOY0bUPhvA5SnRRoqEsPGC+gGFYJ7wU81R3omsOsLcv88Q12do5K6Xnjy2CHxu8nxp2NuHoIL5ZChAzZ6mcG2noH2MX6wcqEW6ICp1jVrwfCJS0M1Xl7MaTgpTb9imx4YAn1swtYMnbkw9RSjGCobnMXixIy9zIS+vpaHBjisasOG69QolLrCEClnUkxAW6wEsc4ZRkgE5F7fs69Kq5CY7dNcFHkrlgNeUlawsmaUKIou8GzPUrisIoFKEjUUkLh/zrNK+7NMNTATLwNj9DsgeHLDoGr1PXJPjp7RM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199015)(6512007)(9686003)(38100700002)(6666004)(33716001)(66946007)(66556008)(66476007)(8676002)(4326008)(6506007)(26005)(86362001)(478600001)(83380400001)(6486002)(6916009)(186003)(316002)(8936002)(7416002)(4744005)(5660300002)(44832011)(2906002)(41300700001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hC6/PhX+ni0OI4i7EKV0hRd0+kTzqWNKgyTY86sIQzRjSzLkiDxpo6iJ5NmZ?=
 =?us-ascii?Q?HhC8DpppJYjunBD0iu5NWAWSFqjxlToNAziO6yO+mBikhf0DPuFB+1Fd76IN?=
 =?us-ascii?Q?I656uhtsMtn566LvV8mtQPTGyS8Gyf3zhtYQx+a+3YhegB/vvBBXAMjAkCwE?=
 =?us-ascii?Q?N4TacPvly1/1b9+OqDF84lXafMoCQygjqHNrJTLYCIZcaSIOra9QLzCdhKxN?=
 =?us-ascii?Q?SL3scpcroeF1afSvVBOabVznfdXviDAKa8Y+Q1tZeuY4PDra68TXE1Dezd6F?=
 =?us-ascii?Q?8pnEL5dP8LFYR1Bngp7fZAGPpcZ41cZNTbdwCO/lgb4kM18sZsEg9lbr4vdM?=
 =?us-ascii?Q?Fh6qWnX3BS5ttjDGB4vniZeNH9hPDbg5uk6Da9b0VnhJp9OQtr07vbkPnXix?=
 =?us-ascii?Q?Q5jXuHahnWoMdJqw7VVW+Z1V8RzI6JHpixWxrZdFeP9TnY/Gt21C8iEQLBu5?=
 =?us-ascii?Q?GGjVVCKUgE3EO/NB/6Yj8/B3j0ZPJgTJnhQ6MPotwJb1HwdYLs7SRUyvRcbd?=
 =?us-ascii?Q?moWHQbBpLw6p8bcXvox5Amfo7k4H4+R3AsT9P68MrJMhwpwyqtEZWK3ZfQDw?=
 =?us-ascii?Q?SlNqpxkvO3ppN9mFSGI4yAVz3E/Je/xkv6OWjPkkIHAeFCiK02XMeA+ZU9P7?=
 =?us-ascii?Q?pr/fS7syO98mPlSXPiXlnYbvWOJOHHsdxdCOY/ltz6O9T5KlWfEUgF5JLmVo?=
 =?us-ascii?Q?Ohl1t4cHKdJmrTQt1XnHr3DSO2H2QfHofF6JZjvblFkXIXPhIJf8xrX7XgKY?=
 =?us-ascii?Q?NuI97PKNrvM1hQ7t+kBoViLnqsZMSXUaqn5G2z7uxATQB/fSrF9pd857Zq28?=
 =?us-ascii?Q?ggsxfVBnceo6qJ2zz+IJ7aHvgZvald9Xlp4NYCjQA6Vmd6QO7v5dDWB+2GQc?=
 =?us-ascii?Q?we6a35oJS8bJHzoW34OuK+8/KRFN4LoVfdohdHKaRmH92AXeQAWv3AELMewg?=
 =?us-ascii?Q?GPC4ONU6OhM1baX910wvhgfGqNdsJhfQxg7AMS90GIalRmMnv/IZmI31Waz+?=
 =?us-ascii?Q?OuAAh3xFywtSxqcrZTK8KK4wvLHQyQV1tazC2u5FnCqASGFcZGt7OfGE5v/X?=
 =?us-ascii?Q?1F0xios/tUkQRAWVI73CnnjYxyhJMl9glIVIRPYoILUWNvW3aQf/1CTh2UGk?=
 =?us-ascii?Q?MRqkZFWQmBM3eKKqFljr4xhgEOaT4yIAuqVUHLdK7bK5n/TJ6dlim70LIQuZ?=
 =?us-ascii?Q?vGeAsLTDR5WZm0u+kJ5Xuvwuu3B5PYUSp2RSxb+rNuNTFgNVcpRX81AvRDqD?=
 =?us-ascii?Q?0gokF0uCfSBFASFB1JQijpZxeB/lU01pPVCHFDjF6nZkBsyzfgzsBCpE5B4M?=
 =?us-ascii?Q?a20SkVcAsI+GIAN8baPj2nqREiO9Io9t6Bx/Vl1eo0Fa36RyOYYGWrIChqsb?=
 =?us-ascii?Q?ajev1TDVIqoTiaQGU3jazXi0DyTv11K1ZWRVjEh+/LBdT3rS7BbcY3fJnsLB?=
 =?us-ascii?Q?IpOMzMgV2RObjhtPoZDdv6vG3ZGEhJRzcp6GXZBy8+yEVqdAzV2sZj9SclOH?=
 =?us-ascii?Q?MJyOkGt6dKh4SA53ZS9NWT3YXQrcrwtvXvrgIvvONpZEi9RTFjp4evRXNZub?=
 =?us-ascii?Q?k9358uKzKffFpTxq/t5xkx1Yww5p/TaOPaqggUXuKbikHBSSYsS57K8cV8QH?=
 =?us-ascii?Q?Ew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86650115-2223-412f-4159-08daa609dccf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 13:10:55.7079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SxQ5na+wOQuJRvt3DTR0guvlwCnUSXtS8viovRr0w8dkpe8vFW62vRMJnyZ+ZA6b+j24YEaVrtCaqHw/xIxzJmr7lhyAT/uQpvPPUWc9UY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4123
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_05,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=724 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210040086
X-Proofpoint-GUID: WBQX3YDIpEM-s3vfadxag6LTpXf-mOqx
X-Proofpoint-ORIG-GUID: WBQX3YDIpEM-s3vfadxag6LTpXf-mOqx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 12:37:55PM +0300, Leon Romanovsky wrote:
> Rely on proper unwind order.
> 
> This reverts commit 3ff51294a05529d0baf6d4b2517e561d12efb9f9.
> 
> Reported-by: syzbot+67d13108d855f451cafc@syzkaller.appspotmail.com
> Signed-off-by: Leon Romanovsky <leon@kernel.org>

The commit message doesn't really say what the problem is to the user.
Is this just to make the next patch easier?

regards,
dan carpenter


