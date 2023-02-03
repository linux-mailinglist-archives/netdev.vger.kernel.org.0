Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB4C68A283
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 20:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbjBCTHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 14:07:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjBCTHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 14:07:43 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2108.outbound.protection.outlook.com [40.107.220.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B23C1F5F9;
        Fri,  3 Feb 2023 11:07:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkIx242L9OdX1wxhY6N6rnmc/58wNFZDSKYuh77ye6pGkErLeGOtpGeJwAEOridtF5LgzR0wf7lGVTIISqYADbJ9RGo5+OH0CpnYqtC+exDsXZCUEMkp2osE1RW03n6WPanCAB6ZKPzfkxiMxvmBtMGt/xf4/pFK97Sgrux9k94ckQM2lzvju4KFZExvsku99uCxRIZF+WpJO5FxOWjVoHXVSDc9jEum5m5sLRNKw2bG5WreubfPFQIpISZK3XM78SO8aCVSdIBvD16pQAoHzb0hpwVOiOOdnx4/F04Aan/83M8WFaWiOG8uYNjiePJ8RpYu2Yd84yvtF9/1cT4gSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQPQML3rjOdRjU1J5yhjlZ3SNJ3uC7ARgK57jLLKmTI=;
 b=Jb1HGQOm4qz+sNBnrtzDzvjaEw4nszVJked5qeoGOAbR0Qgpin8zG2NRV9xlQMSbszbl3i+Rpw4lSP0Nr2FvTAiIx6IgS320i7IRtc2gWh1NLQriZfYm0TFOTdox/eixz+f1Ut4BCjxkIwiR9ldPBNGXPE8oH8bA/4vjvIz3eZsIg9pDaZDGqPupyrsDAaxuIQlsGZ72pv8NiEy5ZiLLj7YRHmnN5QT0K4lxMYUzVoMiwKdSo7VTMMBUnnYBk6JCBBiXYyoV9Czf7KSzugJQnA3urMUl1rKwUq6jndKyREyhaYx3WqCvB7jY/yo3AUNuI/bYr5ZQ1HLb6pk6otgL3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zQPQML3rjOdRjU1J5yhjlZ3SNJ3uC7ARgK57jLLKmTI=;
 b=QwrnMW2kmp6fdcUZJFeswLVUxV6EnuEaxigRe6qYvIrCh2lLXPuiGH6NF8le+D+4ktHg0XEy1P8g8g94kccEE3ZcPnfEfXunW8Gf1MXxZIU2F9624kPZsdDjPR1N5p0kjDyIhIjriP0b7a5zSjIjDFkHiWws2K+joAupomS7gGU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY5PR13MB4406.namprd13.prod.outlook.com (2603:10b6:a03:1c5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 19:07:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%5]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 19:07:37 +0000
Date:   Fri, 3 Feb 2023 20:07:31 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Bo Liu <liubo03@inspur.com>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rfkill: Use sysfs_emit() to instead of sprintf()
Message-ID: <Y91bc2LWMl+DsjcW@corigine.com>
References: <20230201081718.3289-1-liubo03@inspur.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201081718.3289-1-liubo03@inspur.com>
X-ClientProxiedBy: AS4P192CA0013.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY5PR13MB4406:EE_
X-MS-Office365-Filtering-Correlation-Id: 09dd6931-5c70-4d81-d83f-08db0619e9a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jR/516GibR2b6DYe5h6lHtNRvoTkUbw4xWQRC5Srba/drYmZXhFwtORlDYJCkdhwbaILBaKaQEz7mc1Lym3cAuYk5hVdVZil8wbFxV2emDfXhHE8/BIFWB82ebTd+Pa3MHgP8aIs+ZD6mb5MRL1wnsRLTgUGU1FNkbj3bSBYZ+RmiLOYL0J3ocdfJY6cf4O+b+NzVevbBHtWbzbDf0QCB5FFi5UI6ZT6Z6vgb0JPjLW6wIQ+KeMjM021u9umUiOHxPJbAO0YOxYo3I4AozrUYF6+gJUpZJ8Wh1L9H2yQEoNZQ00g9yJhAsPTqLfvlXDKN2M2ZWshCRUtJmu4hMx9cYqjpAr5uz5RhIIUnuvOHCOglqZJePeXg94eZL8IymuzUEbGSqEZcm7seHLMawY4Cus1UY3ImgT0Aga0vOJzxvHpdmhRER0z4xH0VlT6qAa3VXvpdmhKdNWT+1ldr8J/13YpG8Ra+2ZLiJg1ds3/EEWtdoV0IPiO4Ui4iF+R7XnCUCp67JEIbg1oKUfZ41yDshZ9AzhEp66I4qwy2UWJNLrVUDFuoBg90C4O+DB9U3MgigujrN5vJp62D70AwuOSsdTEIEbHq6nWcXV9qvyBI6GCJeKSGGsGE5QusSWDNJsPrvjxysISAvs+zZK5fxJffTYM57hyijRkmLKUzhhWG1a9ErlffnoS+rIbomJGtmbw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39830400003)(136003)(376002)(396003)(451199018)(2906002)(478600001)(36756003)(44832011)(5660300002)(2616005)(6666004)(6512007)(186003)(6506007)(86362001)(6486002)(8936002)(66946007)(41300700001)(8676002)(6916009)(83380400001)(4326008)(38100700002)(66556008)(66476007)(316002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Rz8Fot9OrKyQ2khX5CYbOpjxoxVrlmdRWB+Ckepnp+lZUeqZqxv2hxQdtZGo?=
 =?us-ascii?Q?p8ccRAUOCyC/4HoMNHRY48+MI2iOOrSXj5j5uyakeg6216YFUf13EIPm/Er7?=
 =?us-ascii?Q?BzCA3+9Q4bo3HtngN01LuTYQDA6kSBsktGehrI9uFzo5FmGEK0vXHiGtoxzG?=
 =?us-ascii?Q?vrz7P3FY7bia2/fC5nq4KpuEVhb8nm+VCLwf0t4OVcWA6M9bt0dccvKeqyzO?=
 =?us-ascii?Q?24afsFEUK7bJ8Ro4QTk+udLjltuzuQKmLgqdVwdNH51QGxi5n5Ns+lSSKGfX?=
 =?us-ascii?Q?xmAx83K0XzG+5M/yyln0hk1N3JUnnDE6aaAFWmBt7GypwwHcIj7L0fWRij9V?=
 =?us-ascii?Q?cNivhWlrN1P+bTg7cuUYXMp8XydkKg3y1uJqmNBEueGsOzLvsiz7LFkeR/3f?=
 =?us-ascii?Q?/7DwrwOjnjbuVSr8E2qWkrAFFuvg8BP1Gh+WdqI9g0IzzFQmH92u94v+IdS9?=
 =?us-ascii?Q?rx05oYyQtuCLaX+uz9b7A+2RV+PSs5dQB+tYuwme+nOpfY0oYzUv9woN/wAh?=
 =?us-ascii?Q?szhvju7EcZlF0NfidTvHzWed7SiRY44JGMuGQBelxc2s+aCXnwRqvjTl+MPD?=
 =?us-ascii?Q?LALST3d5drAvJK5MU5ZBD15xsl2/RAjlnePni5oLQC/JS6cMEnqCaNChX6xX?=
 =?us-ascii?Q?0Vb5xkUlhT2h5apQpisoUYxoWpEOrXS3NU/C/ZCxF7HkN8l9XPoy80cNdiZ3?=
 =?us-ascii?Q?v1KYD9bPfnz8Ztc1jbN0MIi9vxunzqNr1MfO6TJBt4oatmYVstxjHjskoaNL?=
 =?us-ascii?Q?i25ynifwUDL8qjaA30ZhxWtI1mh82BHp2ehD50AkMkxa7bsp0cWc3l3SMTgJ?=
 =?us-ascii?Q?xMJ/L7LFI3+A9ovWjUzpntsRACyPmgXrJty1qBG0FiNLb2vg7PoY0JKEpDxK?=
 =?us-ascii?Q?YubdQ+t/mPad1r2MFWLJlt3zu+7b6iKa+decZd4PMa8j9GXd1x4XO4594+mf?=
 =?us-ascii?Q?BREBQo+KiYPPuX14ETiil+691/4ywQe285C7rb9jdIp0xF/dlYmzgJap73Lc?=
 =?us-ascii?Q?Cv++EWW4X0yViih+Elrt2BCwhI4ifDGKCvQbC9YeLUy9qsSJF7isCHQulERA?=
 =?us-ascii?Q?ijtKwtdiJ+/rjkJUzXDBMJ4T1qRyIrWsz8GZB///gt8rS8eRSyL/eFGGUXcX?=
 =?us-ascii?Q?x77qyhjv1eAi7QwLi6SZGc0PxvWAre5IOfJHWPytr+oLVcLbdJO77YLfNjjv?=
 =?us-ascii?Q?jJhLpQOCbYS/0B4LIYgu1/vp9TfDwmfD+8BbLEfnS/wOtcVH/1tTQy9r7Inp?=
 =?us-ascii?Q?N3j4jLvnm5NA8gkZARaIXWRXOMCNTNloaCWelWgeq6tD5IBE5839J2SiobXZ?=
 =?us-ascii?Q?65S9gU4cwFB+oHPy/h0xqqyQdgclF6rISmIq4LxAhCrBHv1nMmN5CU5tx941?=
 =?us-ascii?Q?ZO2mfm9v9tud0LGrAY/4souajwJ2hSNIbWxdKVdKyU+TxmeT2D8lELzloEc5?=
 =?us-ascii?Q?jg7Ptoc6Uf8d3yhjjYn1yo9CjhKxEDnjlIJwi16ekxplrzm/djAAAaceQPD2?=
 =?us-ascii?Q?n5mCiDMoxXMK0m/q2EhgPkP9uNf7ZnM4VLjYt04jmJho9+eTb3v99JmxsT86?=
 =?us-ascii?Q?wXgMRlWh5fFkZoaoD1mEn3PjyXKdB/AvJ8iM1DzPK7JtFf6Xp7013wppkU96?=
 =?us-ascii?Q?we3aCw8+Af8iRfppo7H2kMzkOuKHPZCpD9ReGSsCZKyVQFLHAYtvsgwdrGeB?=
 =?us-ascii?Q?yJkwxA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09dd6931-5c70-4d81-d83f-08db0619e9a3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 19:07:37.1223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBb+oZ2cAbs4gFHNaGLWLklyBzUVpjcsPM5Bj87DCkb8PiC0GOhKQ/RnwBOdHjSPHydHj9dDbPG90nj4HhYymTWV1obVU7zmU8bSaipeC+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR13MB4406
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bo Liu,

On Wed, Feb 01, 2023 at 03:17:18AM -0500, Bo Liu wrote:
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the
> value to be returned to user space.

Thanks for your patch. As it is not a bug fix it should be targeted at
'net-next' (as opposed to 'net'). This should be specified in the patch
subject something like this:

[PATCH net-next v2] rfkill: Use sysfs_emit() to instead of sprintf()

> Signed-off-by: Bo Liu <liubo03@inspur.com>
> ---
>  net/rfkill/core.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/net/rfkill/core.c b/net/rfkill/core.c
> index b390ff245d5e..a103b2da4ed2 100644
> --- a/net/rfkill/core.c
> +++ b/net/rfkill/core.c

...

> @@ -721,7 +721,7 @@ static ssize_t hard_show(struct device *dev, struct device_attribute *attr,
>  {
>  	struct rfkill *rfkill = to_rfkill(dev);
>  
> -	return sprintf(buf, "%d\n", (rfkill->state & RFKILL_BLOCK_HW) ? 1 : 0 );
> +	return sysfs_emit(buf, "%d\n", (rfkill->state & RFKILL_BLOCK_HW) ? 1 : 0 );
	return sysfs_emit(buf, "%d\n", (rfkill->state & RFKILL_BLOCK_HW) ? 1 : 0);

./scripts/checkpatch.pl complains that there should not be a space before
the last ')'.
