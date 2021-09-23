Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF0D41612B
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 16:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241720AbhIWOjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 10:39:45 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52974 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241637AbhIWOjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 10:39:44 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18NDsgU5017225;
        Thu, 23 Sep 2021 14:38:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=hcNY69KejcMcT6psbbH8W/1dCokj0JJCaRY0GLlNGz8=;
 b=rJbI6fslFWYi9F/Z9VubCFP/2ye6eflNsnXhskmWCEnIuUhEFJR5UqtNFzJ+hhZJI7gV
 H14jkNWzPIbw23wibtIPp2xgGaQuilsLqgv7WoolzARW7FQFAU65A6bR9MMZ88FA6jJ4
 e9PLx6QMt+IHXr9+Pax3wuLAhFQyprskix2RBRpH2QPXDTAiZVmGlzmTyrkwi7enCYHP
 5YdwXiBl2N0fRL2Q/M2AIpAJzOMdXm+b9lxkXV0NrN83AlcnRH/6I3g518nyCpSuicQs
 o+IWY4+qOhmDxqIMo1ZV/Lnz6GgtVbckWoqxLIraGO/qUUvO6htxjBiSSV4BbuC4JSGU 7w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b8n2v2muj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 14:38:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18NEU6c1013616;
        Thu, 23 Sep 2021 14:37:48 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by userp3020.oracle.com with ESMTP id 3b7q5xx42y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 14:37:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bwg1/vejx+HqJ4Bi9VzLt06ph8DTqwm8Zl/A+LWcjCV5x3rCHqUgeFweSAfLdI8SYnccCriq3/TCLAqK3FfChvaB/eg9IWlKvtRorZUM8b5DBYyLWUzZjy/gpFOC4uuviB1JkItUbBrqxwvXoMnLt20g9WsQZV6KVzA94TbfZ7ysAk2CW+D5RpV52yJwsVPh60G4SCkfl0cfIwHPD0IODuyhjNO/8TyEBhsH4Qssl3gSATH22KUDvqALh5zS4kctUpikjRYGGh5GMyCcNBd8YeMqZKo08sG3dKIdArw6Vs/DlGTh5WmIXWQaGt1BqfXTafZFvcLflpxGN6dnMxUwAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hcNY69KejcMcT6psbbH8W/1dCokj0JJCaRY0GLlNGz8=;
 b=D/OoOjy0Dl3d3vpP+fn2jUse4T7b8bgJ6c4UXjt/Q5dKL6ar0LshJN+51bVVj1/sKdn8VpR3h4Xd8qOriNEETPHY+BPvmIAu7U69G4rqmda0BT+b3FD9yc+P7EKsKx+BGKGUn/hrjukNFiRXOYQl7mqcT9EuKCfHZ2mhGTAlVZoLZ8xGyuRv9UJd6nBiHbrbpdSpV6at4Vwoe6Ps5xAeLSLkUGYiC5hRqqDLCtFUWCntD/dPe6ckfBgY9ZGMduX3/XXZm8NM/HlOwKXOyYN4fpYsbDLZuSF0PSzdhszwnEEid+9Sjsk1UDYB/gUSTQU60j9tIBi1fK/s9yODGKrWIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcNY69KejcMcT6psbbH8W/1dCokj0JJCaRY0GLlNGz8=;
 b=uGZI/YyZ7gpGvq1JgAwZBy2RoThJatqg0t0O9zq1oLy3H/yUJRB7CdruHy2mN788yiPZxnu9ch+6rRg29CDJTu0aeVQEwnNW3c1MQjncVkvSNvTy6wgVVB8rY7x+EdMo86YC8tnfnDG94QFc08WTeDbT7ofSQPgbpupuNqdcHVA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2208.namprd10.prod.outlook.com
 (2603:10b6:301:2c::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Thu, 23 Sep
 2021 14:37:46 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.015; Thu, 23 Sep 2021
 14:37:46 +0000
Date:   Thu, 23 Sep 2021 17:37:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     syzbot <syzbot+263a248eec3e875baa7b@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] WARNING in mptcp_sendmsg_frag
Message-ID: <20210923143728.GD2083@kadam>
References: <00000000000015991c05cc43a736@google.com>
 <7de92627f85522bf5640defe16eee6c8825f5c55.camel@redhat.com>
 <20210923141942.GD2048@kadam>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923141942.GD2048@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0045.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::33)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (62.8.83.99) by JNXP275CA0045.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:18::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Thu, 23 Sep 2021 14:37:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c81792d6-24c0-4588-ecd0-08d97e9fb574
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2208:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB22082F82ECC3CD0BE47E262C8EA39@MWHPR1001MB2208.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lFDMwOEffjO5Tjd7DlLHoe3HjrgD/Tt1BPF5MWAIYAy6orXSAA0fsSXe+SY3NQD4PhY4DSmZflpaXfP06L2/DXQV7ilDfgw1j32EDnnjz6QDHVCmgDkB9O5WJyMRPHsaX9R5sTBrmxsNKe/G26p4qiyAAa3DsUzoGkQBiYl1cZ4G2eSExrKyXU+z3pNH/uQXtQFI9NS53Xcq3E8Q/E+J1iKQXH8atJUpFpml/sS0fwlbIE9P/ctQqolKTtMbLAn0gPrBbbscKfvQ4BOd/oEOepo/ZxFqIKPStP717jJSwOSjg3zQfeRf5hIAxr3abJ+WqBTbYeR2C9DPMAiXjtbffu6HvgIcE+ezD60ixPDe7u0E+ScV4z3Xe11Do8otZMQq7ATdXKIHuyt8eHvssrwR0yCRMoVCIjAXfTAygmHILZk9tMONRvyCJVyh7/JJDXG3zuAmE1seL+YAwFKFgJqHxnr7PxP5f7YkKD36rdIm0x474huFmo7uYLDmlhXuukZIKjXqfok8iVkHOHyyrShLhAtwSkSE7S1jmcGayipPEXAez5hL7L+f1V5U2vGa/qTUGxxYnqUbb+akO5hNQ4/7mI9f4MKxUwS2moOnKvotNbtgU0hhj1uGsoaIIAYn2VUu0tPH6HO2u0FIlC8lqgUHMslqpFuj1tBMXwtyIfpRgvo+wfL4VDB+jhhaE7+j5R0GUEULv9s2hYRuKcfh1jiSuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(83380400001)(6496006)(55016002)(86362001)(1076003)(9576002)(9686003)(6916009)(956004)(5660300002)(8936002)(66946007)(38100700002)(33656002)(66476007)(6666004)(186003)(4326008)(44832011)(508600001)(316002)(66556008)(33716001)(8676002)(7416002)(2906002)(38350700002)(4744005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zgwqXFSitB4z61V7mQU73EUplaCAGe4HJLEStLTdYbnLxxv54JHDiyQeuGFc?=
 =?us-ascii?Q?R8qJCbyuGv1fy950bkisPmK5YZqYrSDiSbayTq8WuOu1CHBARzWzwFPXOYQX?=
 =?us-ascii?Q?sY0avXWe3WDf3JazvNti09m6SezedoK/u2nJdhaKs3qJ41pejl9YLWFh5v0N?=
 =?us-ascii?Q?JZkEM7oMPhQuEN2tMtYUAHkja6lLC4tq9d6Vtu6HjxMzcteWOvs5ls0XFoTb?=
 =?us-ascii?Q?ptYgoqQ8WvGFdFTufYSxpJmi1Es9wh2GoRDhwqlW+rTciabuwWJoVXDMfUbq?=
 =?us-ascii?Q?wM8R+9MvEYqKhOxiDhBFB38pBAVquWZ3+eHnVi9aQK7CWsw+G83OrhF3w88B?=
 =?us-ascii?Q?G5dapqmXfZOJLiuUOp532WzCWqAKdROQJ2RJZ6OKc+8Xi+TBLsgeF1P31Zjv?=
 =?us-ascii?Q?uiS+JtG7NKnyV0xqQ+cuRL9ep1dSgEP52gvLgGsNtCS5TdrFqY1AL3s046QG?=
 =?us-ascii?Q?qBz6juq5Kuv9zpniHYuBwSLb4uSOe6IVMKFKjjqkURTxxOKTlIBr/qi9Mi3/?=
 =?us-ascii?Q?cKOni6nD7bLZ791Ks9PZFGFvQIZsmkOShqllJfEQCsB6sqN7IoQ7PpMv3Zsh?=
 =?us-ascii?Q?CVmt3yNV2w8rN0nZLSJjoU2vJwnpsAgj4rfJuOIaDmTCdR1AfzGR8w8AOSa8?=
 =?us-ascii?Q?5Dx8XBMMGc77oDdLU5TXkciYhcYTZf7FePheAIrFtuedAWjYrp/bR9t13oVi?=
 =?us-ascii?Q?JpHj6vSTB47K8oUcf9CUvBfoWCrrWu06hzuCbt3rksLBAFa4ws48Y17R5lEn?=
 =?us-ascii?Q?xUTKb40ZHeaF1eFqA9cLQEMA7yKL6QkwObeDOzLqEQb+1UmJPZaCJd/uP52M?=
 =?us-ascii?Q?yLsmwNiQ8WtA90LOp426viOqkpP7ZJjmmHyKmT3lsnCc9Igz1vvr+6waZaK9?=
 =?us-ascii?Q?GHgRAptY5ylyuas2+C1RCDl8Kk170m9eNy6M8tpruxdsuDawSC2S/tbrVfhQ?=
 =?us-ascii?Q?9yOAB4ljmJbh6mHFbDoC/X+3Qvhw6FaHficT6pvmhBUcW0XUJmoNkL0rVYYg?=
 =?us-ascii?Q?JlnqXiP5q8xxVZNCswaicfBOVAdvVuQaw+er9tz9n4hK2Jre2wnVEOCs1ksw?=
 =?us-ascii?Q?yDAS3GsH2mS7OfOpbxdVUj0GaHDM4YWXVegZJKslPe4lXprjuj7Sdt8rLMeV?=
 =?us-ascii?Q?qepzR65MRk0cJteIEsIlcqIacrpvOkO4tBPKxGXpP0tHhTFX+4nKs+qhf6xT?=
 =?us-ascii?Q?N3b8KzMWQ2VGxOIyM5m+Df1XNyt34+Q0ob1eeYADILRMFNrLNyqgEvOYsBXs?=
 =?us-ascii?Q?O9EN+gUi0u8G9Zton9z+sqjTFGXlRtOQeW6FDjK3rIa50QbAuWMKSXTuvIYL?=
 =?us-ascii?Q?ZVWf99FoNMSzkXzyACnXhGyo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c81792d6-24c0-4588-ecd0-08d97e9fb574
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2021 14:37:46.0353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6e+UTHr93XXPIinEvkakJYvsSNfmH5JSIK2MFKQUvLpsWkgGGB3W3AVwifoewT3Y7uetqpUUreWvtzO0dsOHKrbaR+1GGEK/YKZQ6veUZY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2208
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10115 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109200000
 definitions=main-2109230091
X-Proofpoint-GUID: VJCu1dsLHIUTJlWKBeZoEaL8_iWuaEqe
X-Proofpoint-ORIG-GUID: VJCu1dsLHIUTJlWKBeZoEaL8_iWuaEqe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 05:19:42PM +0300, Dan Carpenter wrote:
> On Wed, Sep 22, 2021 at 12:32:56PM +0200, Paolo Abeni wrote:
> > 
> > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > 
> > The debug code helped a bit. It looks like we have singed/unsigned
> > comparisons issue
> 
> There should be a static checker warning for these.  I have created one
> in response to your email.  It turns out there are a couple other
> instances of this bug in the same file.
> 
> net/mptcp/protocol.c:479 mptcp_subflow_could_cleanup() warn: unsigned subtraction: '(null)' use '!='

I should have checked my output a bit more carefully.  I don't want this
one to generate a warning.

> net/mptcp/protocol.c:909 mptcp_frag_can_collapse_to() warn: unsigned subtraction: 'pfrag->size - pfrag->offset' use '!='

Likely "pfrag->offset" can't be larger than "pfrag->size".  Smatch has
some code to try track this information but it's not clever enough.

regards,
dan carpenter

