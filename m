Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29D664A89A3
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:14:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbiBCROs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:14:48 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:6730 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352593AbiBCROp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:14:45 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213H5Scq012182;
        Thu, 3 Feb 2022 17:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=sYRSApGCeocH1y/kOKYU8MRcPNLAYqzO/pUpPpzk+uo=;
 b=hO+7tnNZCrcth2KHsTvj7R67aa40IYXyE4buGu5seykZ9/n2YSNTJzgQkpHc+Ck2MrQ0
 0mX9GZ06HDch7rnfDC/TxRlblaBfCZEsSDz8Zvy4vfF0CPWCrOPyYwW07exH65Nu4wyt
 HVi/savceMKRLphWPX9Wcbc4YPXymp5lykt7jsGEshbEFFvhJ3Yy9dy0ynVrc6E93iQP
 YBIO+pcwEeKD19G5O0h3PEYC28hcN0MsgASm6BK0twiiaGy1OR130+zPQ8aMkrDP7gBg
 Jc5T5frq1z8ToYP9PRvOzOxW6oAt03ewpmeN3WWHUjm5xoYhWyQxZKJbXOyP27+UCP4w GA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e0hfw8bge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 17:14:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 213H5HqY171975;
        Thu, 3 Feb 2022 17:14:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 3dvwdas6jd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Feb 2022 17:14:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLvF+ABCj1N2gpmrBGVWajU7ZpkQdrUseYk/T+v7/UYKNIYlrZze+MfBl/4pGTafUQdSLH5OZAqOQpYFbMfF29219RxrNj7aMD6CqUYvnIaIX5ACbW4xjdLDSGpXXealZmDGzxy7qjAwMUMTneOZTvGi9yalTqRPN+p8s1NWkxcpzX8l3knsrFSe2g9O1l9SHKn4Th24GlGaQGkkT64TVWrTAUeS5GOmiQ76cqxqE9EOloCosmXQJ3qaOoXkbP0c5tFYdojChNnm/DQth1CHJmE+RSsLe0J5W9QDwYwEhYTkbvwz72t9YMQABO0hqSAnFQi4B0QPwSM0HBtNO8UcFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYRSApGCeocH1y/kOKYU8MRcPNLAYqzO/pUpPpzk+uo=;
 b=iq2XNf35CO1rF+w6s4fNpytdrYQAmSrOqo1Ak4mu9EG8h85rAhyYbIyuRV/8y7T2rncVhyzhCIQg+j1kyMaNpZeX4jzdjYVhKSdh7XgbowyQv26F9paYoqIZGc6HEfFT9GQcMrOCof5oZJgVNN+KvCDcu70cDxOFmClyJxilR2bvktrix3PBFy8yC+HJK30v0NnF09N/t5PC7MhvHIyt0RxcvLgloGXg7oTgf7CmTaVV7Q3JvZUDCbc52KykEnFarOt+m6fMin6d7OdGTSlDpjrsgNaen12ceto9l/VDH1JAqaFTuDRqFFZCreobeIBozIshPu/G3RepjKiQPnOBGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYRSApGCeocH1y/kOKYU8MRcPNLAYqzO/pUpPpzk+uo=;
 b=IeajfuG5ATQJil4+0axinTynTJh4zvHpbAU3xTKip3deGGdv2jFmce3E9wCNVKQO9Y+5VwUY4aw5ho7kVt4OG6KczpP6LMBGSbsJ2BaoGtv+XbWZVBXssLcscKcu6/chDv12fIwe0XCsazExGiY/5U1XfqIGeDzDx2cBFoNr0PY=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 17:14:37 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::e5a5:8f49:7ec4:b7b8%5]) with mapi id 15.20.4930.021; Thu, 3 Feb 2022
 17:14:37 +0000
Date:   Thu, 3 Feb 2022 20:14:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, thomas@osteried.de, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ax25: fix reference count leaks of ax25_dev
Message-ID: <20220203171411.GH1978@kadam>
References: <20220203150811.42256-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220203150811.42256-1-duoming@zju.edu.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0043.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:2::31)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02a9bbf7-671c-42d0-2152-08d9e738a820
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4752A8C4EFA3873A8CEA5ADE8E289@SJ0PR10MB4752.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:913;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDvSJwiBnUm2Qd7WPlxdOM1kpGBrNoPfEXZHegRAZ9+YWB91KCoa0w0pVslCe4mgzeffG+04Jd45vwcWK3fcdOfdG2rqHpqrzriD56uAkIn1eUyNNvi3vM/bMQiSCNbIWNTCiiUo4esWr18tnoTDXK0nqVyf1sDYvVKcFJS5Hj+51lVoSU3Emij/m8PsyjarwRDYw4Iqj9depuXok62Wwk0EzBMCS98ZvkQXiCx4QhSKD3fIx93klHrGKg802FIzxDweHDRh1B6v67ffzKFkGTh32AkCV3srFUhB2kHfz5Q4WKGqwthE/IQ1EzM4kc5uH22NfIPym3KzEp15lW98JrwUhI6kspEobCkqQTr7IiJU+N4IzP9IFyXQnUPbRn3/zxxtngrKiKutMsrqrRWiR2DH16JJ+OWz1jWq5rjARK7cYe5IAO5aRyHSj1USHxyrrL43DIAUxHACvL9WGS+xO5rZqFFFw/yO79cZAKBk6Dilj2TBRtgfHNm3YjqpbBFt1jrd0FrdisgAeIHMNL2vZ1x6eA45zDC/gT4AoF6Smrd/JN+HpRHc17/JsU7ercmxJlM96Ud3Vhy4bZqDVQ85pW/1tTCh1MoZJo1pQ6Usnl9DNH3FP3BiNhTP3kFmMUhJ/2SVGOcws+ste8dVkqIZ5Eg1STJxUEEfwwm9lx3gN9t6IhuTPb1DFTJoGvP1Zwd6m+gf4yMyDy78MU3V/oTIJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(8676002)(8936002)(6506007)(44832011)(6916009)(4326008)(6666004)(52116002)(2906002)(66556008)(1076003)(26005)(66476007)(508600001)(66946007)(6486002)(186003)(38100700002)(5660300002)(38350700002)(316002)(86362001)(33656002)(33716001)(9686003)(6512007)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hxoIV6FPMU8CNybP1OlQKmGexJM6rJiTTvOqWI4DaOkg/Vi0JnJ+zX3VeoEx?=
 =?us-ascii?Q?aHYpCNmf0mqpANG4Q5O7WrNpEx4NSO4O529I4tZC500fClZpdGsKi0GMlpSh?=
 =?us-ascii?Q?u4nLgGS6bbqRWNWGXrk3gZAKhIkoHG4J+7gEqVUuu+e7Mxd+/ce7FycJhFHG?=
 =?us-ascii?Q?KSnETPi1/EtvC7n5uq01zKsWzNOUEWpzQ0t633C6RrVpU56rpOMMGfjdXESW?=
 =?us-ascii?Q?+8vD9fn2MUB3+YgAgS1mFGO+dNXcSgwocI9Nf4wQKGEuO4gxII7RhfNJDbDo?=
 =?us-ascii?Q?pZJHk3vwG843XcMJ39RZS/06RPG/kt0qVgLgn1Hj6CdWvXLVK5EpV65meIww?=
 =?us-ascii?Q?wlAq2ALqgmYs+ezbi9OrwGrLZ3W/+xsGCvXfizA9c7phO9du3D3lapgsE7n+?=
 =?us-ascii?Q?b2IOFkTyce6oi1F7KUeqn1lLXsc1PGBn+2BFW3bGSOxmaN26Rc7GzLYA2RnD?=
 =?us-ascii?Q?ETJlwZb311XPkRj+E5SHSHe9RFxQ01VVSTUxaUwjcV5fi4TwRMMMaFrnMDIi?=
 =?us-ascii?Q?6nt7Y6dFuHeN6DD4wYIOY7qABMHcCYiN0s1/WDKKFNAycgteY+YpdMMxuQhO?=
 =?us-ascii?Q?vZJeF/MCjSCMzQ0eUF65oyZ+zAjF6rc/HDvHrWX+8j4iWgvS0kPFaiYVEffz?=
 =?us-ascii?Q?63fI4eB/QOqGVYiBSbNhlIvcLgoWTIq2OB6iphsoAaJhhG8lYpwZXWiOw903?=
 =?us-ascii?Q?gOz0MGg2S88Yu8sckeITGwvf8XIuc/tsqwP019yHXSDcqJBW+zJVmMdS2ZX9?=
 =?us-ascii?Q?VzBrtgPJ6vZskap/IHNa3We4Bg6nrdsItuxdYG+/HjlazZkVSqPUEF/j72A5?=
 =?us-ascii?Q?nCMkYjyZqwKOzmWhBtbfnCJAleAkpHKjhohbEdTJjYsLPqZsIcopyGaNGt/5?=
 =?us-ascii?Q?ObUHuN7USVeEHJm3IHyhdK5rdJS9iTLT3eM6NIvAX3nhvTgaOokBTV//AULd?=
 =?us-ascii?Q?jaFOOz3xl2isYluyANAnq7DbRZkPOXk5U0FjI+Kw3BRNZn0DMNxHOKojm3nR?=
 =?us-ascii?Q?CXX51l13BSXID4YYnlnkBrek2cEfVKOz30mmmZdxass2MOiOPBF4wH8G+rIn?=
 =?us-ascii?Q?XjmtMB9oKjhmB3rc+378f20n2WajRc3NNJOOemqRWw1op4JqQIqFdIiY2ZhG?=
 =?us-ascii?Q?Xbj0JGui9stcmlONDDd4HDjG+5u7JKRWgr2mFwzJK01VTBtfIMbbzz1UTdku?=
 =?us-ascii?Q?8SX7cDVUwsVMA+H29O6kqDYZeP6OFf23XGzKBPRRtcQNvPX2P8PO78tDBGvu?=
 =?us-ascii?Q?lT9rT+NVbj8eAVpZA6nge9fhGcQo5jHF/Qujd7yRnRzd66opl2H5E7ZMAarp?=
 =?us-ascii?Q?/3atTnS+wXmsQ6dLVwWX7VJGZKZh4ljsxIp1aYQm9PYmhERZurcXrtchILob?=
 =?us-ascii?Q?gVi7VUAJhOavGEriyGirxR7y95XsBkP10CQaA2A4UxfWG3exR4hF/G9mT/6x?=
 =?us-ascii?Q?tnACa+Z+Z/Dt3kTbTDumPvgKnXFlg+GOB/6503aiaMZcqnQApfLIqO7GsSKq?=
 =?us-ascii?Q?/hBXiFEr2FivjlLAYSAu47sxLFmZVB0kUA7mN/+sZrh1WmniAfhb+fDItxu8?=
 =?us-ascii?Q?x6P8vvgiTBC5x9y//j1ByeAgWHa2txQ2fRKElq96cCBt/z3xMHWqvQGoCAWg?=
 =?us-ascii?Q?0K8t42K7bT254S/iOdkvYusXcbKllzVIxCsU2YJILRpwuVccmk5/fTPxq9bS?=
 =?us-ascii?Q?0AQKbA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a9bbf7-671c-42d0-2152-08d9e738a820
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 17:14:37.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: imYulv3Al7LJ4/by4zEYcsqY2T9D4lLZWOE2HKcHfFrsNorKnecpIWT+NLnS7TjVH7z7DDo+AkQUseJ4IiXzDUHHfl75Naai5n6CsF2/oqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4752
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10247 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=908 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030104
X-Proofpoint-ORIG-GUID: doIuhv_fgoamiO0OBZ3sz-p1_gaO4cYM
X-Proofpoint-GUID: doIuhv_fgoamiO0OBZ3sz-p1_gaO4cYM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 11:08:11PM +0800, Duoming Zhou wrote:
> The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev
> to avoid UAF bugs") introduces refcount into ax25_dev, but there
> are reference leak paths in ax25_ctl_ioctl(), ax25_fwd_ioctl(),
> ax25_rt_add(), ax25_rt_del() and ax25_rt_opt().
> 
> This patch uses ax25_dev_put() and adjusts the position of
> ax25_addr_ax25dev() to fix reference cout leaks of ax25_dev.
> 
> Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---

Much better, thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

