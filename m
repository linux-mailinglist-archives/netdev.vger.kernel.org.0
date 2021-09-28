Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A765C41AB46
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 10:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239772AbhI1I6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 04:58:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:21878 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238887AbhI1I6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 04:58:08 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S8J4He011470;
        Tue, 28 Sep 2021 08:56:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=0IDsP8dCL0yScuVVPBpsP+ykhR64fVmwdYdJN3BhmVI=;
 b=jtAHQcXx43KAKeio9XgHwHulH6rVhgoxFvnGoAuw2HBtxIZwHbU36yWMmzPrwxBYFnbf
 j+XJXeCf941rbREjsQPlk00u84XDrjqpGv+3r5Dyv7zb/+QKuVn6w/Gg85g7+6kr/r1F
 oc0dZTqvZm6gXumduwPwTS9bzz2brUiJLFVUhrwL70dgmfoSmsa4dFxwvf58qVe1lSyv
 Kf93xsKTw6AqI1cV5BPT6xHvkEvuJj6viZzZ6ZkfK2m6SeOTUzaxlLCp2Ujq+MrXUcqJ
 ciPHcOVu2Ec128rAs2FKn4BzMPiPONs193gdhiMDr3xM08eQcZNz4yIOutrYSy/Gx7Pr kQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbh6nnh2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 08:56:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18S8p9Dc054105;
        Tue, 28 Sep 2021 08:56:07 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3020.oracle.com with ESMTP id 3b9x51s8h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 08:56:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIyu5+c3hi98aZ5PWhT2ezBQyFW+80pDtJLMnKe0gPqsazzCXLxd6VWl3ADTklFjqUsuWY+HGUvvnHV1xVo4fsap7Xong1GcgjT8c0IONwUpPzTdhDYlzFED7yUQ0xh8SC5I++r5m8tzVpfQjFC8kbr2DNARN8XGIFN7vwL9ERLt7IQnOh+dSVa4mB3AJKwnlED6eMEq5+OxewUuwWATIZbV3BiYkn3Wl3haL6fyeXtt8wOoqz0KGWe2YwSvupd+X8TEgg0YOk2wpNrhUkF2QuWRVFLBb/eyadPP2dJHn6lhgbo1fh4wzFWvCT3LC6LqhihUfTbOFz+KICzlxxGSHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0IDsP8dCL0yScuVVPBpsP+ykhR64fVmwdYdJN3BhmVI=;
 b=F2EEmWmUYLwCqJFXTaulF/927LV2SIHZbhPSs1lLgvjm2RruudUaBZAmqWVG+9yVTLKLA/VzhIz89OefHBoGtGeNBjB2Uvb1xOdxA5b3mt9Kn6KGX5G17GYpfNymsL4gsJZx/JtYwYEZx6tVHc1IAVvAcBzTy9CIF8q9yDR1+4zMWIqJNEHENcS05a12LgT8fqhfHYWXIiKJRp3EIcVCNk1mFsoNd4E9jAtrkz1wLgh0Kh3OMzz3tHw7uKf6j7TLcPF7yc0Mbo4wYmDxrm5beTuAGnSbIP39tO1Io1Jy54zD2tMfUmVnpn2bT97gMAY23T9gAaYmvdb4tDGx58V/mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0IDsP8dCL0yScuVVPBpsP+ykhR64fVmwdYdJN3BhmVI=;
 b=imhySo5ESbp4V+MSPkHtRODuyWQxoBNLSL4q7DXsYTGyQI84Ts6JvWV3Rs3hTJhIqEVKw2l2aM1QJhejmKeAyYPMqgy7QqN3e8YA+OpRR2jAdn7AvPr5T0FkLEFiTFRbSbFCQzpvirG5Unb3uUJ72rIkZ1de9NuXG4mpLWu0dNk=
Authentication-Results: windriver.com; dkim=none (message not signed)
 header.d=none;windriver.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1421.namprd10.prod.outlook.com
 (2603:10b6:300:24::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 08:56:05 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::d409:11b5:5eb2:6be9%5]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 08:56:04 +0000
Date:   Tue, 28 Sep 2021 11:55:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Yanfei Xu <yanfei.xu@windriver.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, p.zabel@pengutronix.de,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: mdiobus: Fix memory leak in __mdiobus_register
Message-ID: <20210928085549.GA6559@kili>
References: <20210926045313.2267655-1-yanfei.xu@windriver.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210926045313.2267655-1-yanfei.xu@windriver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: PR3P250CA0020.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:102:57::25) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
Received: from kili (62.8.83.99) by PR3P250CA0020.EURP250.PROD.OUTLOOK.COM (2603:10a6:102:57::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Tue, 28 Sep 2021 08:56:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 71a1e9c4-d75a-4477-b169-08d9825dcdb6
X-MS-TrafficTypeDiagnostic: MWHPR10MB1421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB14215CB6014FA671C5FCFFB28EA89@MWHPR10MB1421.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xs5jMH3rxB6kfI67pV8cGrSzx+MECLOImw+i7qEk7J5Ct62RfQpa5RWXB5JEkNhrCQT4PlMQYWhNVGo15qd32on1T+YDxcWwWNh2GW34PAzFhETU9RBdJGOEjrscEx6XVysXhJ9WnF/r/98JwKXJ7ZPCdGtxMASBFHU8alPO7JnPPya57UuVm1xZz0g3Pcd/WJyD6Btfur+s+faC4wSduz1XMPPZAG4j+Qqq1e6tK/Wl3FBWssIQKGlHFqfWwU5lQOH1C5HxE3mFpWnvuxatOL72VzjHZH8Uje0EXFUF9bFnR6oY12OpK/3ZV8alh5z9zbMzrCH36YcEy0gdwNFzACKQduLFaA6QCh0d9qUm2eYSMZLcddbBk2nVh2n7ptHqN2/JBSqzRuZ9rzQ3X1kpesWfvHh5vJSsE5v3MNj7oXvIhpIj2w7DxWh+CaSK9n5mVxYH/AWPIzqA8m0e9sUpR2/S3BPL64LM71BNbbEifPiFWw73Yf7iHBBJcdRd0Cv+xEQA2gvNLSlUDJMWQpOfWudWnFFpbgUUf6Tts7pIv56cBvdz8ZBkbQMfr2cjvHWrGevnk5DSS0AP1hnORLqKRQ/4kByO25NNGWgIsIvUtBZM3L7GkuOzSpLkabenBGrBT9QDTY4I38noIonBFGoziNAeomsAkFGPzBdHHjf5rcywz8yg5fpoToLbnft+avwIAALeWJg+C1xwPShpi/SyLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(44832011)(33716001)(956004)(6916009)(66476007)(508600001)(1076003)(38100700002)(38350700002)(6666004)(52116002)(66556008)(2906002)(8676002)(86362001)(8936002)(55016002)(4326008)(33656002)(7416002)(9576002)(316002)(9686003)(5660300002)(186003)(6496006)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DpytCGE7ubc7d6OVzyVQgs3qvqcjFYWpySxqzEDc8FK1n2NntRdciuD6IaJt?=
 =?us-ascii?Q?7aJks3DA3fNAEtjSnkV39kSgBejmuMOqft6e38vp4/dixK0MJRLz7ozwEcXi?=
 =?us-ascii?Q?4jn0xJnj+Z5UVcrp47Y3x4aSJU7Xxifht5KSOC4XfRYkFGzKbE2yd+eJ010I?=
 =?us-ascii?Q?hRqFGIFbKV9F+ipj38D7PfarteaAV1EKP9p1xFiPLzn/k6fr4PbXsZ1vVdQB?=
 =?us-ascii?Q?5lUaK624J7InSmqqbYZQ6eV0INh2DmHhI6sQ1lIY2pvZk14WE6Wv/pQQ+fUs?=
 =?us-ascii?Q?N/TEoBLaJtPNPxhhj/BmC7N9bmC6NykTppPxIazzuC2lfu3WQDgp71IUVLYb?=
 =?us-ascii?Q?/DESbAHVbrfMg7y66I2+xCQgzYv/Qbmu4O8c0x3lH93FqIotzC10gXNvyAl9?=
 =?us-ascii?Q?/xtbGhG7TtEiubRTzugO/L5kyaosOB9W7+h6chHlojU6sPNrbtxZ9nE9gBfO?=
 =?us-ascii?Q?Y0ftJh52kko0Z+zqneEXMEov9RENSh9fpTe9kjn0l5fpH1fakgukd46f+jMi?=
 =?us-ascii?Q?4l/VXo+ul+fzfU43/veS4cHscq7iEQ6ZSU+UYFzLR0XTRxbgfU6qQwc/YkF4?=
 =?us-ascii?Q?XtNzDIw585J5chnAUySd19WEwuI5nwBsgpI3hYhVTQ7127z9A257+nvvQVQc?=
 =?us-ascii?Q?X1/DrWPXyewy59Xz+gOb+JS1adnXFIpyUOp4FJf9dv2XdsrNFw0/bCaRjY98?=
 =?us-ascii?Q?RgCxe/ECwastLQ1EP4fLzjzTvGTkPApQqDmlrXWJgcZbMpTmSAgu+bEm1Ida?=
 =?us-ascii?Q?NYCQ3Ro42r7rQ8YSS3ovAsxkMVCkHt17PAa1rjr2HUWe4047+Vs9RBpAHIp1?=
 =?us-ascii?Q?5et56mViGUM8X3kVajrgUoxV+p5m/jY/LthfDqqY4l3kxWe5yWl7EsmKJ1gz?=
 =?us-ascii?Q?/Ks0caIqu67vNlnl1bpQzc5VCjw0sneILcc9qvx4W4iAWemTDxguAX5Dyk0F?=
 =?us-ascii?Q?Ce9c0TY8CAecBSIkhc6x28uHf2EIaEatfCd+dP1zzmG1q7zfAMTO2WAYWcED?=
 =?us-ascii?Q?hnH1rnBSUn2DUlZcnXZM0fB88idZeqhF0eK7uF9PTIMEeLGpfo2b41tsjmFG?=
 =?us-ascii?Q?vWYH+EUo3XVppaZCi06xa+jv4HLAUUw/vyUj/e7Qnkxqb5/oI84COeAAoqUN?=
 =?us-ascii?Q?5Ho6l39bgCevKutm22IXCeb5JQ8YO38o5mC7a6SbpOOK1T3gWuILuZAHbNjm?=
 =?us-ascii?Q?2PYEp1AsqE2e/YCQyfS5oaUHEahn1yeTfboCksKaGq+4yRY4ZieQ20wu/mGX?=
 =?us-ascii?Q?DdgUco2dH6SyTqHyy4TQwjz9aVMs9+1hpaRuWuXL8ap0pekJ3RcPaKoWN8mR?=
 =?us-ascii?Q?Lg2oxqZjp46/8X1C9QoU0Gff?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a1e9c4-d75a-4477-b169-08d9825dcdb6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2021 08:56:04.8755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZkQsDZtMNYYHVDIVhYth59kr2TM+XR1GTNQVpKZC7DbMN6bb8RQZlL1aPcRXv7qINWzfAZ50TufvL6GjtfAEGFFlN79fGWlZrtQHqq85RW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1421
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=775
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280052
X-Proofpoint-ORIG-GUID: wCiU8NugDGwYB_S-kEMp05EBV4sV6kiS
X-Proofpoint-GUID: wCiU8NugDGwYB_S-kEMp05EBV4sV6kiS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 26, 2021 at 12:53:13PM +0800, Yanfei Xu wrote:
> Once device_register() failed, we should call put_device() to
> decrement reference count for cleanup. Or it will cause memory
> leak.
> 

[ snipped stack trace ]

> 
> Reported-by: syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
> Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
> ---
>  drivers/net/phy/mdio_bus.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 53f034fc2ef7..6f4b4e5df639 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -537,6 +537,7 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	err = device_register(&bus->dev);
>  	if (err) {
>  		pr_err("mii_bus %s failed to register\n", bus->id);
> +		put_device(&bus->dev);

No this isn't right.  The dev.class is &mdio_bus_class.  It's set a few
lines earlier.

	bus->dev.class = &mdio_bus_class;

The release function is mdiobus_release().  It will free bus and lead to
use after frees in the callers.  Look at greth_mdio_init().  There are
a lot of callers which will crash now.

This patch was a clear layering violation.  If you didn't allocate "bus"
then you should not free it.  Keeping that rule in mind can help prevent
future bugs.  Also he other error handling paths are careful not to call
put_device() so why would this one be special?  It should have stood out
that this one error path is the only place that doesn't use a goto to
clean up.

I don't have a solution.  I have commented before that I hate kobjects
for this reason because they lead to unfixable memory leaks during
probe.  But this leak will only happen with fault injection and so it
doesn't affect real life.  And even if it did, a leak it preferable to a
crash.

Unfortunately, this patch has already been applied so please can you
send a patch to revert it?

regards,
dan carpenter

