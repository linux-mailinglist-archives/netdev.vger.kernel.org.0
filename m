Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F265C56535E
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 13:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbiGDL0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 07:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbiGDL0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 07:26:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130F1101F8;
        Mon,  4 Jul 2022 04:26:50 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2648f0sr019021;
        Mon, 4 Jul 2022 11:26:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=0SAL6VoIKIVOUWFKeBli/m6i5HIi8oiNg1C4Yq+sf4E=;
 b=nPxxEtf38j4ldUts3EDTvQjYU8wbCVYOJZ+vCbDjfE/N+3HccwxHf3ZPHCg5vGQ/FxIo
 hH5ZbhsSylWQVzideQXeW1fZ+hA/ws2coFDk3D5ZYVJMRglFrZ8+rMN7tzBM8oQQQ+IV
 0sYw1V0iFRqaU+/H8HkA0WMPn27yRQoG91tR8CLBd7mLsqrA2Z87MkII0VkoTawhrDPy
 ccgg/lJr7FaAEVV5L7jfH+Nkz4cw/nY1ygcTqVX0KkV1Zq/hgKuDD8+mRC+7VfkAxkdf
 fdvKuCesQASUWMAPx4GeOUBt9Fr+lCdME/5VBDT2kKU8rTlU3S4lS1G6EHDjG5IMis/Q Wg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h2dmsu7jy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jul 2022 11:26:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 264BFA1L023948;
        Mon, 4 Jul 2022 11:26:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h2cf7mv1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 Jul 2022 11:26:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxThdfNqGrFUXyBYfTqFdujnbGtDrbi936zcwKmYxbbT+XjaEFy7aqj6rYsjWaddHTlQw89J/yXMNC1yvuc5X2RHEHQl5sS0g79KwgFJsGNA7XeDFJvgJ2XJcSJnUCWoPC1WDzAK0JkYzIFkjXIvgBNrB2Uveiyq+lfWwg7a+Pd8i5v9cVhG7V57thqXOUHEJMzzw7VTk4bXTLNx8M39Wp/kOA8zfbMhWbpAXVPq7vtu3iqWKBkaJ1qD4xtm17V+/F0Etl7Aqo/Jireqlcx5oH4Jke3v1KNsg8BvtemwYe4Q3SbMFAASL5bwhEMbQgVkDYSRbzBx14WDrVTsoHWtKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SAL6VoIKIVOUWFKeBli/m6i5HIi8oiNg1C4Yq+sf4E=;
 b=Fwu+WuJXcU+zM9JQlni03UkM3SK2m2Gmbf57JLwhT/CSV2UCaecdozB02xUylLYVDHlqhgWDFoLTtum/oKYCClX0PuEhPoBR9imxtKNRsFhV0Vcs3FSNeH8bLC2GnIqlnfnNg+ksFGzXmlyj2708RqSwqJ7ZM/l4gVQayvZCR3r8IdJIzwgYp4Zy55tFJwvz0cfDZaVblIRXt0lw+PAeWsPrCCESwoRQGZHetF8W6x4syZ/y+HXj37TPVL/wnT15p8VwcFrtpuzERPnZAI1J9zSVa7V4HibPNY5hSOo+EVI4b7GEWJf4AI2CPKYe6/zRJ7tMhGZ1rF5Ys7TJIBLnSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SAL6VoIKIVOUWFKeBli/m6i5HIi8oiNg1C4Yq+sf4E=;
 b=lFAlyrfCIe54ka04jn2JZaYf8wV1P/NmBXAlhSsZ09VneO/V3ZLZLAOqGOV8oaMuPQK6GqGVbDrqc4Be7QSjWDMR6pF6eyr2qkpoAxtD3Ej+GRXwhT/8j5OmWN9Hozj3q3B+5onXE39qMWHUjy49Pn+XOYw5AEW9m41ao7UMI+k=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB3862.namprd10.prod.outlook.com
 (2603:10b6:610:8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 11:26:45 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5395.021; Mon, 4 Jul 2022
 11:26:45 +0000
Date:   Mon, 4 Jul 2022 14:26:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Soumya Negi <soumya.negi97@gmail.com>
Cc:     syzbot+9d567e08d3970bfd8271@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com,
        Xiaolong Huang <butterflyhuangxx@gmail.com>,
        stable@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Test patch for KASAN: global-out-of-bounds Read in
 detach_capi_ctr
Message-ID: <20220704112619.GZ16517@kadam>
References: <CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0059.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4f::12)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8d664e5-4218-4eba-e3d2-08da5db01354
X-MS-TrafficTypeDiagnostic: CH2PR10MB3862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OlcHYoq1BPOebNfuTiWQMYkSAewIF+jTJSgeLnH+tzbmE8rXH54t1zk/MTG2+n2la5tKv3oT78tZwK/JdHnL39aoBFVhq2IVipx883AxPiUv5htp1WclRx2gDI//ZXBksTK5g9Dy8FRDmKjalTwAJgjiXPeZBm/n6X68f1J1HnWj0+EhKdGeMpFfcIYI341TdNq7Duh7osimwL4/PT9KcFZhUmXJTapwHWmhyclecBQJm/KI+ShtTu5uKQLftDzafEJUGos2+Y7QDmWFUFOzUbd7rEFzwLBiZrf1geUS9RpZen3axkjvSY0dbB2QG1EBS3cO0iXT6SOrWRt6qJ0pZUc3P5pi7+7Yy5eXtywvPcisYstQsJjD1uLqI8FQl++OA/3WsuoyIpn+oumQWy0kf7dUSh9PFjwKpkPxeF0pbnAX+vTEpyWtbzXiEtOVXiDlJtQDZotr7ODHA4+yEpAHMxixQ62P0Qy61ioluTfrpmpifHqKKmwffYy0FIkh8qY87prS6eK3E06DOpglvuG1jgkA/MI7PvXJwYreqWBAf5sSuQAfK1lMTrrpIeA0x9pWqv/zbobD6QmUkni1gsMYKtz8JsV5cKFyLQg5mpQG0Yb9GFsHueAVdEUjxc2DC3R8zoWgPMnijc19QwWP+h9SUzzN5czcFbYhQ1lpAniD6VH3JMl4TNzoL7XBiDexwQKIb+wIkMZoJgTzbeU7WDs/rM3HnVxAbU9smOCKnwiq8FkgQCZ9l2Gth1OtEA3lQ6drJ3jHJOJneZJrMCfgEAY8hfw/ZEr80lRJxPdYOCRaahTDVYuw2aPDmaem9jO+am+PjIQMcDDRuh83QJBAm2WwM5bBFY4vqryGdgf/76UFdaTm3cBbqPLtcqr0NdzCiM1FJaoXc/lqiIM6IywPGJ5kcEPKBPtRJoStfEzt9fZqM/k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(39860400002)(396003)(366004)(136003)(346002)(5660300002)(66946007)(44832011)(66476007)(66556008)(8936002)(2906002)(33716001)(86362001)(33656002)(478600001)(38100700002)(38350700002)(8676002)(1076003)(6486002)(6666004)(26005)(41300700001)(966005)(316002)(6916009)(83380400001)(186003)(4326008)(53546011)(52116002)(6512007)(9686003)(6506007)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1r1+MQkmmtsN45jc9uImZZFNhxuR1fittxUP681VRMAiguEea/xsuVTp2d57?=
 =?us-ascii?Q?g5/Ug6mHg+wsF0BlbRmLyGabC1FtMVviPv9n/zuZR2a6nhbXfmftbIoOnTgT?=
 =?us-ascii?Q?KAvUPfVTE4timP3BbWmuv94uvravXh1OYpSWDsfIbG+1NYshq+4PLie+d3bB?=
 =?us-ascii?Q?peijXBFUQlivp9942gEZjynzDBw5r0YzxF+S2DXZCd8DDQYE8fLRVV+aRpPd?=
 =?us-ascii?Q?H9rLGPr3Jx25nioP9fTKGm0ocU5YdHDsL+lFsb6PFqQACuhypA6DNvE1h38I?=
 =?us-ascii?Q?uOhA7nwIXqgd/jObxcvwKtD//klT/D/DOb5Tia6yAnBC7cSi6OTLvOQE1OSa?=
 =?us-ascii?Q?rp0DgWA8dMli0B5dvg5rt+u3QG7iG/q4R1XN9TAS/yCwYL73rwmYhqQ52Pue?=
 =?us-ascii?Q?rQBvsKH3RNxgnzOUEUw2GBvIOw3K82CbNK/vZRZ+w17WKur6cV+e5nGWouPo?=
 =?us-ascii?Q?9lm6qNcGi9Xx3kbo374mBia/1+c5HeiKblsQVzLXRrKHHqcdlq5SLGEWtB9z?=
 =?us-ascii?Q?/mnx5qRQ45W5i7JmCubDjEW9JLQkxCLafRKp7xjC/uGYsXQqe/BckWl7GLQE?=
 =?us-ascii?Q?YPKypeDY/zkxgsU0gId/vTIDBiBngHbuWQQOSfKHOfsbisF39qqV07fUyl1j?=
 =?us-ascii?Q?dQpHmNigFlK5ZF3ep3kvM0Opgng/fMG1CdiI5iJ2bTrhFnez3BZqgmosx/ma?=
 =?us-ascii?Q?h4CgVyeCaJnG9rLNpU/9fQH1eE9HLC3zk83wmnru1u+aq1Fuv6h93Y6mkmgs?=
 =?us-ascii?Q?QAi1lzDnnESdeArS71vi5niMI6I8AqEGk4WRnH84xnzPzSC/QYREC0GXtXer?=
 =?us-ascii?Q?7l5G3Ilj1Y/TXt0riBTz04tbhmij/DwzA7vssnFJJHjCyiQ0dr00eHm0eyhx?=
 =?us-ascii?Q?xk0uLImkHgyq8G1dhkiTWa3xOUzZIeAHZup7mULqnG9MCIHaVq19abH/DTzO?=
 =?us-ascii?Q?2yMN8s/0JVIoK3aBZpeLcNH9Z5QH/dWsVFuW55EIRLkbaN9vWEfXTdU+PCXu?=
 =?us-ascii?Q?O1d0FYIh/8F32WhTiCjFciuQPEWMOidvLL7nCX8h+JujeIOddoeKjTtl2DRd?=
 =?us-ascii?Q?Eqr3q96P+upIXLQLv/x5JYDuLP+xsrvHtem2mzvM0W4RtE2lI3wEBVIBTU2Q?=
 =?us-ascii?Q?E8NjetosbdkliSXRg1sFBhcm3GsrTbfTTuG2FcueKEdl0fv7SxwYyYO1Mbqi?=
 =?us-ascii?Q?Ag5m3RHfPlxlyBXhi1Zl/Pz8DTBKVWNXKjrpLWdpUjdpwb+CYCPUhD9XtauP?=
 =?us-ascii?Q?9HwvOXvbDFUr0B1Q9n5AjTxdRyMBVkJa6Etmg3jgVxr4F8skj44DR0AryjSl?=
 =?us-ascii?Q?SfYa8b3jWYNWie72z7ubj2awVug+Y4lzrYBBszKIHKggObM4Vlzxyactt3d1?=
 =?us-ascii?Q?ACzEg8uAjKaUG5cwoibC0YVFvbRpPToEPAwDd4ZABWA4sbtq4CdbBfP/8qqC?=
 =?us-ascii?Q?pBS0n0pQ1TOkYe6oZodiUHqGaKWss3nH0qCpRZl1yVvd+kHRMGRgQ4w+Kku9?=
 =?us-ascii?Q?f+u9PSvdTyU17PdnzmdLzuh/7Gh6Kj9SDBFITn/UGplOpFpdJITd+AYT+t4p?=
 =?us-ascii?Q?pXKHSVRaWbWSByyJH3hiuDWw0rjaz7LgaP3yrpViRtSPS/AKdAfhHp57ssY4?=
 =?us-ascii?Q?5w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8d664e5-4218-4eba-e3d2-08da5db01354
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 11:26:45.1303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IRDnxSeI1DnctW8Gb9KDKzzIF3qYeW5qclRhvvVHdiCLVkMIMocnVhO5l2vART38U4Q55E7dhaLe2PISAWfYpCZSTCAB3aeNf3a76l0pIRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3862
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-04_10:2022-06-28,2022-07-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207040049
X-Proofpoint-GUID: 9yhbYSHllYZNphrHtsHUxIfCdbdhZxWR
X-Proofpoint-ORIG-GUID: 9yhbYSHllYZNphrHtsHUxIfCdbdhZxWR
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, Jul 01, 2022 at 06:08:29AM -0700, Soumya Negi wrote:
> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> 3f8a27f9e27bd78604c0709224cec0ec85a8b106
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ%40mail.gmail.com.

> From 3aa5aaffef64a5574cbdb3f5c985bc25b612140c Mon Sep 17 00:00:00 2001
> From: Soumya Negi <soumya.negi97@gmail.com>
> Date: Fri, 1 Jul 2022 04:52:17 -0700
> Subject: [PATCH] isdn: capi: Add check for controller count in
>  detach_capi_ctr()
> 
> Fixes Syzbot bug:
> https://syzkaller.appspot.com/bug?id=14f4820fbd379105a71fdee357b0759b90587a4e
> 
> This patch checks whether any ISDN devices are registered before unregistering
> a CAPI controller(device). Without the check, the controller struct capi_str
> results in out-of-bounds access bugs to other CAPI data strucures in
> detach_capri_ctr() as seen in the bug report.
> 

This bug was already fixed by commit 1f3e2e97c003 ("isdn: cpai: check
ctr->cnr to avoid array index out of bound").

It just needs to be backported.  Unfortunately there was no Fixes tag so
it wasn't picked up.  Also I'm not sure how backports work in netdev.

regards,
dan carpenter

