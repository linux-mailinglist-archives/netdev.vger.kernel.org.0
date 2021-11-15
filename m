Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BF845047F
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 13:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhKOMjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 07:39:05 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25142 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231391AbhKOMjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 07:39:01 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AFBmFkY000684;
        Mon, 15 Nov 2021 12:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=Rfy7/PoE01BBgCAK3Z9KK5eQGQYEaFHqiVsEnkn6FAg=;
 b=hZLYCI6VPjVLsIBTKclsSbry4RhJzisSWeXrtLQ5W2XNAxmXFRQBTwz7bfniH3FsFGXZ
 9CoqU7d0CE5mQO/4MddkSDzZT+58YQdVwYV7/02naB9inY6edQBjJePVubEnlLD/xqpJ
 XPB19MblGFJS4AgKnv7cHo0LvuAB0GNzvFMGBjVzj4/ay3XsXfh8grKpveyE0uAXFZLw
 p9n+YdPVLH6I0akfSYzHMcSweZUpTWFUS3dxTvJnQZrgaPDDEA0/qfe+zrxaH9arKHfu
 sXgXqkLsmKGNhvOQoCFIID0p/yh6hPZy7OC93TO70eWQP0j3kxPunIq413rdISoQDduv qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cbhmnhwvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 12:36:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AFCGAkY155132;
        Mon, 15 Nov 2021 12:35:59 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by userp3030.oracle.com with ESMTP id 3ca2fufn0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Nov 2021 12:35:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y58jU9qHfgnpeff2IE6xDUSO0sHCZhxBWyqeYKHUuL23JHRljUEyoZVYkcUtEHPFxBcO6XcblsyDMK6cjGMqUICBuTAZ0CMP6E/h+ky6b5UsUyjIiJtD2X15a6SBezZKrgeorYqpcWWItGO2X+9aeq0papgpZE12lZUGMTgv0VMQrZtqwh2UxZNuuyTyRhKYv8TlcXRJM3t/UyY1gJf4bozMz1qowcPr40bwetWZ1JW1bwZ7OOWHzhJg/HztC7DuvmJDxb1hpnwdAVS/9d1PJ2kLU/h5Mh8vY+RoUrRG+u77NtqtmwFxnRugfbzOMnnMQTprejDBkmo17wBKThd91w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rfy7/PoE01BBgCAK3Z9KK5eQGQYEaFHqiVsEnkn6FAg=;
 b=E2gKL4QE0412Qci40/P8P7FzNPQNaa2fSKs7FpsYAFi2Md3jkpOyCEPk+5bciyQLAtnyO8bKUgunXIFfSiAhoAmQ6FTdWj5MO70hBewdfOJDelfNfaoga4E2ezBWg4sk030lYtgln3zYOg/g9zmcCvzyDW2T0e13q/MZH/RZPqVokyqWun2EFz7fSQ1iIHLDPDwUkEb1UBXBB66wMCwloRYJ7WDNMy4XS/eNVAEc/hN23eq1Onx4yIy/X/+KWftbEB+okiK5qbIVhGL5OpByXGzZQa0Zvl5djZwVK2vXiQgV+AjjhmdP7IwSbK90VE+Qde9zKlYVP8RZjMaE/S8ApQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rfy7/PoE01BBgCAK3Z9KK5eQGQYEaFHqiVsEnkn6FAg=;
 b=FUTAdXKarJAqvuY6W3UDy3KF/DlB173kWrPFecseIjxdglYYVe+AZrAhCtO1dtKahLCsNBUJ46aqeeph8gci9IJwRlPdEqFTnM7mGlV3g0+yzwPMFNdKlHhMYePc7MiWGJWkyflqO3vwy4xemXPF+esd1Sr8pyMj0wX0EX+v7Kk=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MW5PR10MB5714.namprd10.prod.outlook.com
 (2603:10b6:303:19b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.15; Mon, 15 Nov
 2021 12:35:57 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4690.016; Mon, 15 Nov 2021
 12:35:57 +0000
Date:   Mon, 15 Nov 2021 15:35:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: bridge: Slightly optimize 'find_portno()'
Message-ID: <20211115123534.GD26989@kadam>
References: <00c39d09c8df7ad0673bf2043f6566d6ef08b789.1636916479.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c39d09c8df7ad0673bf2043f6566d6ef08b789.1636916479.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0019.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::31)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kadam (102.222.70.114) by JN2P275CA0019.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 12:35:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d102a9b5-46f4-4f96-dfc2-08d9a83478c2
X-MS-TrafficTypeDiagnostic: MW5PR10MB5714:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW5PR10MB5714ACCB7E78DF5B13C118118E989@MW5PR10MB5714.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K3AhFIbkcvECwUeT9D06qbzyYqpvZqOALIFdZkrYsGyQW3sI4KNnBpS/5B0zbdVKj/YTRQRskYAU5/zf8ziuvOYNOFPknyz5hvl3lFKcm18GAWRMYVNx2GutC1L9tyoMN6D8+kHQ9zMTBN/emR+2mp7fHmF4phXmTUoIK+eX88jcoJKxZ/1d8/cnE9vKfPWCgrU//4u9POYlE1sccqnMQHIaUmjtz6c8pfJR52byafrsvy3U3Oy/5mtM+0PiRqD0hVkdFL6plfwRrr+sPr2U8RLROgAw77/0+19WwsfAJJ9TJv0Pc2aUlYlx7lI9rbqInRSWuB4+pJd/fwfPXfkae1GzFUgBZGPPZ8BtUnmnwBLKXvvz+rQmfDpqs4yJourhOjZ8/ZUYJWc3ZNC1RaxwiOq15FT3sTDUaaM0cPqwUmASv5otD96yzSFUv73jbp/1iWxX4aDXLoKYVK/3KDsVQY0XL6IBm4NLv5VkYLobDALy5og1kJM4dTffb8qe6cjZ+H8UY0tUXyuCgx6M/xtIwRGWFPKErRqRrueeQS9N90kLQ5QhrsBLjoZMFgHoxOFE140EDlSvrfrBFZSENeh2MSypWmRVyTWroHhh/3JJwwdUmdcvjkV8wi8u4ZiAZBTPOOFyqSSoTYCkdH8ebzmEuavWQWAk4wDylnZAPqJ+wtG6CuzrSiXFuZb7IE9Q9RzUJEYKMjj9ENytBNkNpO1Guw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(2906002)(6496006)(4326008)(33716001)(38100700002)(508600001)(38350700002)(186003)(4744005)(6916009)(86362001)(26005)(9576002)(9686003)(52116002)(5660300002)(55016002)(8676002)(44832011)(316002)(66556008)(66476007)(1076003)(33656002)(6666004)(8936002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7NNX1S3jcP7e614OkalcUZ75H1/F4QKtXPLYiv7zvtP96vSeIwC892rFwcB7?=
 =?us-ascii?Q?8KXmM4YZFFqQw2hTnPJqHEQAX4A1J3SG8qcjh8RwnJk8bODdb9Gr0AbXh8tR?=
 =?us-ascii?Q?yTO4qWgxtnerVpwUk5Hwqlh39tRqHk/lkrjYUYCntfpI9Jgvkh/DY1578jcv?=
 =?us-ascii?Q?ky2W9UngrFKGOKVwJIbQ75tTYp+BqOfc1C8hJJt5sx+5OtIANYz+RGnZMvjv?=
 =?us-ascii?Q?T1uAK+pR/4k1Jo/FY2JmKE7kSpFzEje4wwvOf7WKaccUEqnQImZWFtCWe4FC?=
 =?us-ascii?Q?uYu0OM5/BhhNhbpxyIC+Witg3vIRCyFLn3rogZ+LtqFDUXaKT1NuzKaARBtd?=
 =?us-ascii?Q?lLnhDGB7Qu4qhtg2Q7MPOiSRSSlWOlem2VLAZhbgxfLuls7gOAy6o2Pf7HoG?=
 =?us-ascii?Q?ySmf20TV3VFnup/dH/ZBeoPnSwtKUt3gD0zA/EphNcBOQpETUxw/fCxhLD/7?=
 =?us-ascii?Q?IbVm6g1vi/DhP+Lhh0jq8p3k1FD4rAQ9J5zK5uh9Pm8dbYhL1hgcbhwLUTt9?=
 =?us-ascii?Q?M4tI3Ac07AIxTUUL5IY+acZBGpNKO7pozVnhdZ6XiNz26mDvp7sL8bM/UimJ?=
 =?us-ascii?Q?Ez+EqTKXQnh5mwiG7po7JmQiW7vKX92F20s2vb69mv8Sri4xOT6D9Mnlnsx8?=
 =?us-ascii?Q?e4Em+4d7OUhyKU2eI0pzO3bzirn9ORn/bdaptBo7SgSJ5vE2Kbd3vSloUcRr?=
 =?us-ascii?Q?UwjFpQEEeao9Kptgz8RC2mOZa78Dt+vw2Iy/bA4eWIwD9K2QdXwzdKpMLAFA?=
 =?us-ascii?Q?NE/rvyIKVqwVNQrVp4p/Oz/xtcBv10QtpcY2T2+Z/HSsO7eTIAKBEDIgA8wH?=
 =?us-ascii?Q?qIMKeb2MdliORfDKAKDtYr+S+GIlz/lfhZ5Ubti+bR9AYISC/f9LyyjkuUK3?=
 =?us-ascii?Q?L6rJa/vF86Iur3j3HjMBQTF/0bINs4jFCj3qmZL8SW0ReqmP8s7RNF5KoqkF?=
 =?us-ascii?Q?mM2FgKPi268synjnM9+AItCsP0CCoNJzw0e4fFScTz+dy+B+ZkHcF+90lEEA?=
 =?us-ascii?Q?2NICY6y8PB3oTk0D9K3k3enwxww35HYf7vMwUtcdTAVq3zVHcOxgp9ythiGE?=
 =?us-ascii?Q?kI0KqT1vvIGbIc4RnL7S2R4QbPF60jWggchgEoUl2Z2HhdzjNgPVof8DlApp?=
 =?us-ascii?Q?gNKy362+VCYM9GtHmVWEYbIpKS8zWNnRfh7bTyoh6tCrkq+NekLRRFu7vbVc?=
 =?us-ascii?Q?OKqfuS/dViuZj5UbgyO4/QtKjGwVW4pOMx54elSUwTcgb6W5iUdUVkKCy/Cm?=
 =?us-ascii?Q?+W5C+9NI0WxG1zm0JQ/wT+0XNFwl7utc8etjuhy0J0Qkzv/HCm9Bd4zsiQXf?=
 =?us-ascii?Q?9ro4QYO0Pwm8cpS4+k05/Kv9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d102a9b5-46f4-4f96-dfc2-08d9a83478c2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 12:35:56.9217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7dQdkHaYpXHesvvCeIE+CGZSMYqMa4Xx9ybd8JGNbKTn3PwkRKdA4UzLLbiOSieApWQeva8yZ6t0GNrLCg94JsyN0+k5wQXryrQQyNaHOc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5714
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10168 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=632 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111150069
X-Proofpoint-ORIG-GUID: VTO7nmzC3Y2nw9AL3JYn00HqFiGniStS
X-Proofpoint-GUID: VTO7nmzC3Y2nw9AL3JYn00HqFiGniStS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 14, 2021 at 08:02:35PM +0100, Christophe JAILLET wrote:
> The 'inuse' bitmap is local to this function. So we can use the
> non-atomic '__set_bit()' to save a few cycles.
> 
> While at it, also remove some useless {}.

I like the {} and tend to add it in new code.  There isn't a rule about
this one way or the other.

regards,
dan carpenter


