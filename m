Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A414A6B46
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 06:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbiBBFQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 00:16:16 -0500
Received: from mail-mw2nam12on2044.outbound.protection.outlook.com ([40.107.244.44]:1999
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230087AbiBBFQP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 00:16:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRDlZPzMX17FhdHx4TTETJkI8wSm7+oOds0iNCwfoce/K1DcsS1It3+6wRSFB9UoqrrUstRpcwGmjI0+ibTb7CowqHZjc56JS3o8HfRUrcJ+O8jWlTJFE+o3BH57qQknj1AoyoY4RARShdIAuucvc/wjRQ1Yu99zvAE49pTt+ojWHMDSUxg26YLWDpSWMkQMF5aQtO1KImgT6XW6w2slVEJANGptIbpV58BOKgAQN1qbH0CyQYTztQC+rLkReGxhqWzlPlNYEp1onU956Y8HW0u9fmJy6kbgOMtnaSWpqzT2BlwroqfDzq8WjYzPACEOnc7FjkBVk7SptXSqrQ6MmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2SGMKMQk3gdDHADJ4F04xb1exaOoeYWO7yrvpgzNXgQ=;
 b=Op3fLuQvj0EamJ5Ia0aCP3/gQfXf/YvWtfhh0Z6hcsrvgEUcOM+pCVzFYheaERlfu/nbkji7KcrxorBYAZH62LJmracdBgnbZtomJHzz42B4+QFMC7DpXTKsXaWKHsMmUJdMTxaF6meYDCpysqwKFoJlkVA+RsHKevnw1qyxG4RgYwwbzEpJ26we+hOd4pKgasxpiZ5u3RXdPDspmhgGZXx2HW5pE458FDZmbRTPGRiYfGW7PRcnUCq93uXkpfO2LhxJQ9zuWk4S88xTorD1DbU81Gf00Xy96+vpNfnpM3kFXkZ+ZfzvZd0fjjYNY0l80vMDWHp9Xa9Jw2e05tQJWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SGMKMQk3gdDHADJ4F04xb1exaOoeYWO7yrvpgzNXgQ=;
 b=ELPN8DLRC5YCCUmbnjB9vSchnGSKm72zaO0GJonOp/wITC7ErNhh1bgZ3Ur1bI/F59O184Y4szNv94OoXdPQ7diM5Rn+PkzQS0ddWBGPKIhuFskFpWihbNVRPFh5zq1g3x8dOaa4fegRCLsy7ARQ7cmmJK6SPr6//kxGPqXMH5m2hA4/EWlPQ8cS9HBwvmFsBvwNlW5jwhXy8g+kgt3zaSKUC5snYSEB6aq7KblP/Fa5gQRBw0MNexx2XSn5g57Z6cPkt2++XZqbq+FefaeS6BUNhy+l3Fvm0TFomQLePzPk8IuzXyAcZCmgKk4Wdev+xhlmG8Q2n4s8t3T4+JNu1w==
Received: from BYAPR12MB3557.namprd12.prod.outlook.com (2603:10b6:a03:ad::31)
 by DM5PR12MB1225.namprd12.prod.outlook.com (2603:10b6:3:7a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.21; Wed, 2 Feb
 2022 05:16:12 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB3557.namprd12.prod.outlook.com (2603:10b6:a03:ad::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Wed, 2 Feb
 2022 05:16:11 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::35a1:8b68:d0f7:7496%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 05:16:11 +0000
Date:   Tue, 1 Feb 2022 21:16:09 -0800
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Chris Snook <chris.snook@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "K . Y . Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        Shannon Nelson <snelson@pensando.io>, drivers@pensando.io,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jiri Pirko <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Rob Herring <robh@kernel.org>, l.stelmach@samsung.com,
        rafal@milecki.pl, Edwin Peer <edwin.peer@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Michael Chan <michael.chan@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Joel Stanley <joel@jms.id.au>, Slark Xiao <slark_xiao@163.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Liming Sun <limings@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>,
        Omkar Kulkarni <okulkarni@marvell.com>,
        Shai Malin <smalin@marvell.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Gary Guo <gary@garyguo.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, intel-wired-lan@lists.osuosl.org,
        linux-hyperv@vger.kernel.org, oss-drivers@corigine.com,
        linux-renesas-soc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH net-next] net: kbuild: Don't default net vendor configs
 to y
Message-ID: <20220202051609.h55eto4rdbfhw5t7@sx1>
References: <20220131095905.08722670@hermes.local>
 <CAMuHMdU17cBzivFm9q-VwF9EG5MX75Qct=is=F2h+Kc+VddZ4g@mail.gmail.com>
 <20220131183540.6ekn3z7tudy5ocdl@sx1>
 <30ed8220-e24d-4b40-c7a6-4b09c84f9a1f@gmail.com>
 <20220131121027.4fe3e8dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <7dc930c6-4ffc-0dd0-8385-d7956e7d16ff@gmail.com>
 <20220131151315.4ec5f2d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <dd1497ca-b1da-311a-e5fc-7c7265eb3ddf@gmail.com>
 <20220202044603.tuchbk72iujdyxi4@sx1>
 <20220201205818.2f28cfe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220201205818.2f28cfe5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: SJ0PR03CA0153.namprd03.prod.outlook.com
 (2603:10b6:a03:338::8) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae6708f1-2a99-4db3-77ab-08d9e60b1ff2
X-MS-TrafficTypeDiagnostic: BYAPR12MB3557:EE_|DM5PR12MB1225:EE_
X-LD-Processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr,ExtAddr
X-Microsoft-Antispam-PRVS: <BYAPR12MB35579BA69B805A8478DC6E9DB3279@BYAPR12MB3557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gYMpCK+vNxWaGMI8PYAiWkMBublaSRKnKDtq6QbZtJuFcFd8hkeVvHjZOF1HpnzqXAI2XiWFkMpeRfxIKkuTnJt4HAarr7bwb5nkvAF6d9N2HpUJyi7wuFc7102rvzLdjI/gO2K4tx6uad/sXlsa1dNxyQIQad6KZqEXOGtAaJ49UM+fb4B3SjwujqhrfJx4o9hIxTLn58fYp/qjXMb1dmOJ2gHeg7RUvayTPbYEVXNlytSU1kKRe3rNase5anorrmXWhewHaL9ZGmNrwX7ulj6JzV3eRQCoYWxzCWqDEaQY9bLacLLDgK2Cyf7mheHGbs3VL1DXQZjeDpjubg4lw8Mbm5qSOuRp+kQ8v7803FYteNU0RNdXtrSVs+F8JdQ9o27Lqqkif5RT3Tc+GtTWx8RdHp3MwjDZV2LzXZGd1HubKTc+qOkrB2vmj4RBmg/Lk/PzxGBBkOP/vR0qo5JaAH0xLzlcMVEVooNSDzMVtGlgdE0pLJrJuR3qmO11olS3r3OdtJrMqiNAUF4G1+j8IJSbFiIHsUOmbZhxrM9st4NtZZf47Y36ItCM4HI4NPeTXurbM3p3d90u3fFed7ktfUaVXcJaaSZQ2G9SsPEj1En5Jm7xtUNj6mA1nUqTMQOLYLrWpSDQXbSWTCITL+3G7Q5TmlvOQKH4qS0P0mXpmB839c06uNBuDodx9pcngC6JxBkdXeMGgiz64DRPHAC2TbrfF/a6Jd2ieVimJy3fMPI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3557.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(6506007)(9686003)(86362001)(6916009)(316002)(54906003)(6486002)(508600001)(6512007)(186003)(52116002)(1076003)(26005)(33716001)(83380400001)(5660300002)(2906002)(7406005)(66476007)(38100700002)(38350700002)(7336002)(7416002)(8936002)(7366002)(8676002)(66946007)(4326008)(66556008)(129723003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZC6mxXoWld1zacpp/iJ7ttj8VqqtozlUveJgiLhSweYZJGbesh09M33D/hTw?=
 =?us-ascii?Q?c4rCA/CfX4NJyDpQirfDaFI+MV0hH+iMMPhQCFV+TjOD7G7WFwlKOvYalQXi?=
 =?us-ascii?Q?ojLQIWUk5jaByLPGzCRP8AgyMdBXeZApN4onjtcAI1Qjaeh2naVK12TKSG7Q?=
 =?us-ascii?Q?MhDNE5EvPPmxFudDQAiBd0QuKQrCPe/wQ+E2BnB/wtKcDLOcW6CvxeIl8yEm?=
 =?us-ascii?Q?/F8VeaPlwMCZkE0gr2OD1WWbmqIDHEC9ZAze5ZQavvo6wwlYvY87pgvFP6fM?=
 =?us-ascii?Q?NjXg8azdmYVm3PHAQkbRfsvOiTx+aoyyKdYOFdPaYTDXjeLBqyUYUffXfr4x?=
 =?us-ascii?Q?XfaOafJfGqE4bs/a4+fWmFF8V8WI3TxgJn9RkTktEmMJw157Zssy1TlMf08v?=
 =?us-ascii?Q?FRggUhq7h+YHLCYHOzlkYDAxZxUgPczDPxDz3pdBkmfNRI43f+cwBK9NGaux?=
 =?us-ascii?Q?hrzXn8fw9f3SDMiXTKVs5RDql+RcJcj9piTUGqUcj5yOYDhQ/0gcFyrwgQB3?=
 =?us-ascii?Q?D2d3yzVOUiEolpA8+6pp6Eupj1jgAJ63y/Yc5D4zqi/VDvE7FPnHvncnG0uF?=
 =?us-ascii?Q?oqQiBvk/25+8oLcKIK9BiXVll7UQfAIzcWVcA/QIsfrX8SxxGdk29hDZFlhY?=
 =?us-ascii?Q?N+QZHmSBNj2qDrNx0FmLwh+wRyKoCDLvuLrMHHAKQc8djlIAhoOi6wxBEpBr?=
 =?us-ascii?Q?4afH+Yxo4GBqIfK3O3t/nZGBHk4A/iw+CnSEQlent9eFy46NM52NONfObJzh?=
 =?us-ascii?Q?CUWIhxjexGKa8pew+BzR5W+JjQLUXiV7f98EwgVYnydFFpEcao5h2wYXi5Vc?=
 =?us-ascii?Q?roqfS1gfOeJevbQok3SKzfngcxDgyJtj6St04lAK+PS4nJeug7VRgmW8WTGx?=
 =?us-ascii?Q?rQoc3FhJDhIS+n2+RqYEjNFyZbbp1Pr2eRjsmsgsilXIXuoPYyuStSkfZEJE?=
 =?us-ascii?Q?IQA+KJuNAhr4JqgHfQlgFUXH5S/jKXX+EuDI2/UNO30SI/71w0RUJAZfGqhx?=
 =?us-ascii?Q?lIKw4Aw2I2qdFu/1KXCv4yR/qOvJmWmgxtcZ7Peld/hTqnY19fSWuhTDffDd?=
 =?us-ascii?Q?060BKfYY9fxcFw80uOIAWK3fwphRt9jLZcktenXJRQ4F8R0InPEgq8aFmuou?=
 =?us-ascii?Q?dOMJwOWayBd/6QvElgMNIw+ITEe4ij+HhFsGOowoda7dfKnDvRGxfFw3gh2t?=
 =?us-ascii?Q?svxg7GcnKYIHDWkpI5VHrNogXzR9X/0eJdq6DibTIu9RYZknFLoBJWaF6Xw9?=
 =?us-ascii?Q?w74xdBatZKRaU8XVjUS56HBqe31+Dux4mHD8OXP1MhkrqG4iifDAP9fRa/Kc?=
 =?us-ascii?Q?pWB5QeeWjjyFjr7bxRw3HhkzWtT5F569L78DoWFWHr/s3OjSU1rXhp9v3uL8?=
 =?us-ascii?Q?Sjqpeshl292VIbeWk9Ga3LkKZSuqXzkuXI3uOr6sCNpyh74M7VLA57GL2+kr?=
 =?us-ascii?Q?1jHFHcFxsw27Y1P+K53tIFLCSJXoyPLdqKbuZQrT/F+Lf/fbyvixn228la0+?=
 =?us-ascii?Q?0wJ+vcixdESn+Ewew28Ll8KNL8Hm9Ktm2P5HucNdQVtLeJyovY7r7l5JC4Zp?=
 =?us-ascii?Q?lPcM/8AT0aZ171lYCCmoZwPhThmyHKCa1IVUTNU3+mOfF3HbAhlHF3rYFGcN?=
 =?us-ascii?Q?uYiqh5oOqM/Cj5bgBSfnavs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6708f1-2a99-4db3-77ab-08d9e60b1ff2
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 05:16:10.6210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6nkGj/uTUnSbDYyFHKAU8V4aExBEuQAkAhbZOkjbP1ijEPn/l6JAwTghpxGo9mG5A4fkS+ltl3M4I0IbnZHpKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1225
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01 Feb 20:58, Jakub Kicinski wrote:
>On Tue, 1 Feb 2022 20:46:03 -0800 Saeed Mahameed wrote:
>> I am getting mixed messages here, on one hand we know that this patch
>> might break some old or def configs, but on the other hand people claim
>> that they have to manually fixup their own configs every time
>> "something in configs" changes and they are fine with that.
>>
>> Obviously I belong to the 2nd camp, hence this patch..
>>
>> I can sum it up with "it's fine to controllably break *some* .configs for
>> the greater good" .. that's my .2cent.
>
>I think we agree that we don't care about oldconfigs IOW someone's
>random config.
>
>But we do care about defconfigs in the tree, if those indeed include
>ethernet drivers which would get masked out by vendor=n - they need
>fixin':
>
>$ find arch/ | grep defconfig
>arch/x86/configs/i386_defconfig
>arch/x86/configs/x86_64_defconfig
>arch/ia64/configs/generic_defconfig
>arch/ia64/configs/gensparse_defconfig
>...
>
>First one from the top:
>
>$ make O=build_tmp/ i386_defconfig
>$ $EDITOR drivers/net/ethernet/intel/Kconfig
>$ git diff
>diff --git a/drivers/net/ethernet/intel/Kconfig b/drivers/net/ethernet/intel/Kconfig
>index 3facb55b7161..b9fdf2a835b0 100644
>--- a/drivers/net/ethernet/intel/Kconfig
>+++ b/drivers/net/ethernet/intel/Kconfig
>@@ -5,7 +5,6 @@
>
> config NET_VENDOR_INTEL
>        bool "Intel devices"
>-       default y
>        help
>          If you have a network (Ethernet) card belonging to this class, say Y.
>
>$ make O=build_tmp/ i386_defconfig
>$ diff -urpb build_tmp/.config.old build_tmp/.config
>--- build_tmp/.config.old	2022-02-01 20:55:37.087373905 -0800
>+++ build_tmp/.config	2022-02-01 20:56:32.126044628 -0800
>@@ -1784,22 +1784,7 @@ CONFIG_NET_VENDOR_GOOGLE=y
> # CONFIG_GVE is not set
> CONFIG_NET_VENDOR_HUAWEI=y
> # CONFIG_HINIC is not set
>-CONFIG_NET_VENDOR_I825XX=y
>-CONFIG_NET_VENDOR_INTEL=y
>-CONFIG_E100=y
>-CONFIG_E1000=y
>-CONFIG_E1000E=y
>-CONFIG_E1000E_HWTS=y
>-# CONFIG_IGB is not set
>-# CONFIG_IGBVF is not set
>-# CONFIG_IXGB is not set
>-# CONFIG_IXGBE is not set
>-# CONFIG_IXGBEVF is not set
>-# CONFIG_I40E is not set
>-# CONFIG_I40EVF is not set
>-# CONFIG_ICE is not set
>-# CONFIG_FM10K is not set
>-# CONFIG_IGC is not set
>+# CONFIG_NET_VENDOR_INTEL is not set

We can introduce CONFIG_NET_LEGACY_VENDOR that selects all current vendors.
it will be off by default but will be added where needed in the defconfigs 

