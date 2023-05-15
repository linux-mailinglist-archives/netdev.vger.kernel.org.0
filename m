Return-Path: <netdev+bounces-2654-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9B4702DBA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38244280DB1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:12:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6729779D4;
	Mon, 15 May 2023 13:11:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F30C8F9
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:11:39 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2135.outbound.protection.outlook.com [40.107.223.135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96863596
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:11:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VK7ZT8E1eNfY91rDTJPPJoNP04RMFKgmOVijRSLSA4xF0XAF1jcsfaoBkRaG3onEWcku2AWCPMwYlFVIAfEh1+UvMYGsCi3nOsAFsWa1ODrannLLmPkKNd9qKvvtdqyvxgmOMDaWDOxtESIK9iaF47kAtay4DZ3RPNFVLSjsWPmFaGw/IV6o7VAxLjaIBab93oEGmywKXUgcVCoajyffo7uETNC/YtUB2vMppYlSD8byVxcZ5VGWoBe5hXP/n5NTuyMJvugw3gjmBAQwQrmPoiK5MkwvD09lPsAlyQjfhGUZCjkaeuwTsmMEIuZl0RSsWgzqCASLt0Tp4iN0XskuYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iitst0xdXUCfT6wMTFiPDq4OLQjJlFw715+zqObO6fY=;
 b=SQPSMbQOb8K25Snahk/97x9ZBkSBQ9dsEAlDAGl43peDTTI+WAiIoZemzuwFm7aklzzA5K5zUYbsM52MQ6xkEnofTI7xyl58eEwyG5nNZy9/FCGdDDDlul1aDPMm3DHsu0ALBbqqdhRmhMX11uCRo5PAc885b7RChfpscC39O+dF49pgEzlAHkPwzIhAztIYHNyTEVX26qsp7Qi07eSjywMRQGz1emvSXAHw23vAJ4b53OgbVlrd/F23BXoXhDzKPfvvxlFQFwEMWI+/XYojJwW9/xjPjau14Io/mLrak/A+MB27sn1kfEfuHdsalv0uvHIWxHL/52PYdWB96SYoFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iitst0xdXUCfT6wMTFiPDq4OLQjJlFw715+zqObO6fY=;
 b=JDBW+xYS45t0W8L9Cjd1u6XdbtYAtrdX7l2aBYmd333U2BQU5xYJgVz+mV56CrBO1LsQ+WXO3U/a/QRVKexiMkYPism5udHw3q+hDn4mXP5++vojzrHHyUVwN85HjTMBmLYakDDZ6AhuC9OuHQyg2hFlRmAyJtyeOS+JubZ+XeQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5528.namprd13.prod.outlook.com (2603:10b6:510:131::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 13:11:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 13:11:15 +0000
Date: Mon, 15 May 2023 15:11:08 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, jiri@resnulli.us, j.vosburgh@gmail.com,
	andy@greyhouse.net, netdev@vger.kernel.org, jarod@redhat.com,
	wangyufen@huawei.com,
	syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
Subject: Re: [PATCH net] net: fix stack overflow when LRO is disabled for
 virtual interfaces
Message-ID: <ZGIvbCJqAgVMIJ57@corigine.com>
References: <20230515053740.3065735-1-ap420073@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515053740.3065735-1-ap420073@gmail.com>
X-ClientProxiedBy: AM4P190CA0019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB5528:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cf136b8-680c-481f-208f-08db5545dcff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TlUbwW3flD+gxrCsh0oORto3gCXoI6uPT4tSBQARWGa2txecUOzPpnONzXUKH/ULazDsjeBuq8KZK7QVcyTf08urBSUVunBnp/RFVSmu4wfABw3GoiNBEvFhDkUsRnvHq2Y3a2mMG83GabyF4YifQu2q6k5wtWWdBl6hVbM64K/y84IQyuyUl259Epv5v+vzw70D46loH4VYT6s+/SFZtOhdNO8uXXlwA0TJcvnhPFXMnI9u1Z4ijBofcPeYVrGC3TJqqq00tteArLqP34xU9JTF2ymO5s9VZtC5jbHG51ZngNkmK/n6K2yqMa/Uuh7Sn8k5wsKMXg6Lf9d5B1xpkbMvBqBNgy1g2JWH1yRyi2i2Ckea1Dj9eripsnbYfxxPENcfil8loZ19E+CMFlieFwTCvisVGGGH1XE7/VxAEcY+XhpzQS1P7IYevT+Rx068mx+b+c10bB2Czf87LxKo2Ydb5pgXAk0/yH98fT/hXhZwiIHGA8DZwuO+/C5uIgW+VU2jaikcv7QI5IyCOCBtq+5py3D9uyDACBnR/VL3b+6m040GBNWu0XzgYfGcZELia+TeogFk2bjWrPlIhXDQQZSVEqnXxxKRISMX3jkX0rM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(366004)(39840400004)(136003)(451199021)(86362001)(478600001)(36756003)(186003)(6512007)(6486002)(6506007)(6666004)(316002)(38100700002)(41300700001)(66556008)(66476007)(66946007)(6916009)(4326008)(7416002)(5660300002)(8936002)(83380400001)(2906002)(8676002)(44832011)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W2sRiJvOcsxUrpvoB7euRnqMHNIxNCgq5qh57ryb4Ve+L0kpzAmnzObVo/Ag?=
 =?us-ascii?Q?GmILJO7bxNGj8hW+XoMNJ5oLuKa7/pfQL6TS1RvYrEiQK+QRX7tPc7e2d4RW?=
 =?us-ascii?Q?8k+Tn5KLIADAO/r/Aj1WCJX0Oo4D6p1g/eL/4G2hMMNdNzjZfkHdmwdayPv7?=
 =?us-ascii?Q?bbI4PpqgFiO+I7XSbLQ8k7/a2wFD1lNHvx1qqZcH3D8LH3YRWmJ3micENpjU?=
 =?us-ascii?Q?+kq3jYK23is6a4+/b0oOJrgWZ5ezKsAbrFTzatUOY9sXxylPm30a5mWOnexa?=
 =?us-ascii?Q?a2Qhi46+MrZsouYuGSuHrMIJHd+HWiIu0VnFR6hMW2bU8Osf2xexIIAte4ov?=
 =?us-ascii?Q?Lb2E1O350ao3C7MfyvzgTGp8QlYVBiwamYx7/aSxmyhyxlo3RpmbbfDN8h/b?=
 =?us-ascii?Q?78Gee3z6z8nDLlFn9cXNJAXSiCNGJgtGMO4tLzDIq66cQfeBrplTirnO62B9?=
 =?us-ascii?Q?xYjpR38oS2SSlZkSXpUhiVkhoHBG9ZwjHbXska0Y1S8Ak1KO/pe7ONGMXGld?=
 =?us-ascii?Q?8WSfLCzRHFq+8bUU97tAU2AUjVNaePXRUQt9sz3XDs0Fz/QtQ6CX4+K9EUoc?=
 =?us-ascii?Q?6NXCUfWwobHWf4q0nfgraxq/1oU933JURqo92ejeh1ld1QoX5+2jDf6cb/lB?=
 =?us-ascii?Q?8MLHWJbCjR8kZ53IokRQjBJPM5g1sC1Vu51JJ1Cdc7Sz/IQrvYivjUNX1Uwt?=
 =?us-ascii?Q?Tix15zZRIBs2fyrpb+mSGQ6H4YqYiicH5kYOzL53FAP0cFG/Rtxmvix+lut9?=
 =?us-ascii?Q?s2G2jYrvj38ng22WcWIjiuVp2ogf4lYGqe/oyrBmIfHR+KkQuOhYV1AMAaeB?=
 =?us-ascii?Q?k/DDqfaZO2SrGgBJtP4dkEcBVtnseBoKrlaCex9gcBgiheoHIugFj6nVZTfz?=
 =?us-ascii?Q?euSiAC4QyjOMbaneJjjK1uncDKba6mGTMsuv+r9Ep8YBcCNQwTw5OxPlBhyo?=
 =?us-ascii?Q?YG8TUhgaHKypgatBVLmZd6fmzhLwo/Fikc/3xPMVHxLOmTPJeNJKzh5Qay55?=
 =?us-ascii?Q?QPW5IksGv2sbSAClTl1mQmIs9FwXVS3+uRThDNIL+9zySb5E9x5crdNUm3ym?=
 =?us-ascii?Q?GIdm+ByZiS8GtW0hY0TEgGAfWqrvNFNGb0FXjX+ChadmxGeddC7k/tKNX2Ta?=
 =?us-ascii?Q?8q7+NQWr2QesYbS+YzqP3N1mK7pFKlYeLBt0G9qQgGjPGSxz20afiAswSG1S?=
 =?us-ascii?Q?TYHFXbuCI0FPBE5vkjxn6DVTWi07eIFbFgSqd72GMHI7m+k/6z13smF0FyQR?=
 =?us-ascii?Q?4QkiB65R8GjRq8laDl5lrqoDguZZ9nk5h/Y1V1cdkJG6GKrr6EmF7Vd6TEP9?=
 =?us-ascii?Q?LZMBst3ABQoSP2HBSYrwFkczcdfu4smYY4q8ROWV14HmNdF1sZCrgaRDixlx?=
 =?us-ascii?Q?U+ps4G7C9mQCJ3W1+LTJM/6VyAl/XVJr+Ykq88WZuG4NfE0rCvvzBe+YYcRe?=
 =?us-ascii?Q?Ks8OPzTilqFkK79IMcI6QzyJSpN7UtFgfIeb9iZMsli+sFm2A0lybLctiP2s?=
 =?us-ascii?Q?Oo7jT7ovx4vTWQhS7bSTv5CCk1DJDwym5Jvv4kqO5c0kcvklOdf1Pod0Y3hG?=
 =?us-ascii?Q?XcWw+eHbqZBnPhNV6kdvPwQnEHK18zZjxGiXoXJrCrowHSenzEeisT3m+UKk?=
 =?us-ascii?Q?YFshVqIv+ENx/kT6so90D0Qhd8Vy06iPSp/tOACsQYzXNwEdVvlOt4Ii8kMN?=
 =?us-ascii?Q?xgu7VA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cf136b8-680c-481f-208f-08db5545dcff
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 13:11:15.3733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQSMHKHdadvTUWePjuXkSk+rttuOz0FA0ynuAMqlJiPEf3G/KJmKGzt/+jMFDKPHCqdqf//mhy6tYEARs7t58zZd2hnskVzSUPl1XInnCL8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5528
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 05:37:40AM +0000, Taehee Yoo wrote:
> When the virtual interface's feature is updated, it synchronizes the
> updated feature for its own lower interface.
> This propagation logic should be worked as the iteration, not recursively.
> But it works recursively due to the netdev notification unexpectedly.
> This problem occurs when it disables LRO only for the team and bonding
> interface type.
> 
>        team0
>          |
>   +------+------+-----+-----+
>   |      |      |     |     |
> team1  team2  team3  ...  team200
> 
> If team0's LRO feature is updated, it generates the NETDEV_FEAT_CHANGE
> event to its own lower interfaces(team1 ~ team200).
> It is worked by netdev_sync_lower_features().
> So, the NETDEV_FEAT_CHANGE notification logic of each lower interface
> work iteratively.
> But generated NETDEV_FEAT_CHANGE event is also sent to the upper
> interface too.
> upper interface(team0) generates the NETDEV_FEAT_CHANGE event for its own
> lower interfaces again.
> lower and upper interfaces receive this event and generate this
> event again and again.
> So, the stack overflow occurs.
> 
> But it is not the infinite loop issue.
> Because the netdev_sync_lower_features() updates features before
> generating the NETDEV_FEAT_CHANGE event.
> Already synchronized lower interfaces skip notification logic.
> So, it is just the problem that iteration logic is changed to the
> recursive unexpectedly due to the notification mechanism.
> 
> Reproducer:
> 
> ip link add team0 type team
> ethtool -K team0 lro on
> for i in {1..200}
> do
>         ip link add team$i master team0 type team
>         ethtool -K team$i lro on
> done
> 
> ethtool -K team0 lro off
> 
> In order to fix it, the priv_notifier_ctx net_device member is introduced.
> This variable can be used by each interface in its own way in the
> notification context. The bonding and team interface is going to use it
> to avoid duplicated NETDEV_FEAT_CHANGE event handling.
> 
> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
> Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

...

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 08fbd4622ccf..ebd49a54f0d5 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -2393,6 +2393,7 @@ struct net_device {
>  	unsigned		threaded:1;
>  
>  	struct list_head	net_notifier_list;
> +	u32			priv_notifier_ctx;

Hi Taehee,

Please add this new field to the kdoc for struct net_device.

>  
>  #if IS_ENABLED(CONFIG_MACSEC)
>  	/* MACsec management functions */

...

---
pw-bot: cr

