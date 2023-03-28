Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C11D06CC248
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbjC1Olp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbjC1Olo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:41:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2113.outbound.protection.outlook.com [40.107.220.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8DAC1FD0;
        Tue, 28 Mar 2023 07:41:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5MUAzls+liGDWcPD8NR1ckUerRAan2eftZ8rp6KLI9gQcm2QRQ8IDWdAPMOtmbzRpoQuuex7QSV2vaZ6WzvMl085uO9LnqaU8y3xbD2l/vDqJyK/H1lA5uCvYt1L9jAmy2QFHvTqlVG/9fFCdr+reBapQmf/t75mh9lKFcheYXBaLWh0HxPzmmKKW5ElqZAiT9AHkrrODY9QU1bgVQgt6gxluACKGo2ZZr0k4sfOD9+6ddLmmCgunICkWaa9hOOj53Qd3kwUN2n9VkUKUpfNCDQVhm6giqOckfL/WhzmXhYYi2ZJWSH0hg9p306zDA2ENaTmD09s6vOYST/QUcYkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MW/UnzKEb+cPT4n+TIDCjoMo0xXy5HMF27WPHLubjR8=;
 b=njlyMcmjzuudGnAcx9lRz3aMnceSa3MFhFEBDadFvuclhUYeXbQ86uhyAAT80AirEltpP1DXVJuOkxEQlg4dfVTYRLexcNCE/ZHbcsFiqYAXtQ1tAR+DaqJYTM1wl2DqqfUivgAunIfXwYv6mpiVgJO8MqUaSO/c+W7m7jjYe7gcInzgSNzrdfIWY/ltAUZ+9b0YB4mi9JnUINFTbMk2MWtbbwNZ96KkfgSzoT+f5IZCfjJQ9sg+rDTSWH9NObrcVmF8uRpQkpik4W4d1sHn5LM8AVJfzi/4bfoD5UgO6iHFjmbVJe6yKOTWK9GPIXNlhRGe1cXWoY1KM9Om0otTCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MW/UnzKEb+cPT4n+TIDCjoMo0xXy5HMF27WPHLubjR8=;
 b=r30YBqNYkbWKLyKI4bhufUU5adqpZttHPSXB8swBb5+JqscHY4oJ7KR8+RHHuLBLKhp/D+WvuzkqY9WCVdt4iCNArMXLWNXvIhFQRzVFGFUB4jBJxoJlKwDX7QmHehKR6OHxa1s9Z8EvzOXSn/KdfDHD0s/uCBYzHFkdZidZXP8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4914.namprd13.prod.outlook.com (2603:10b6:a03:361::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 14:41:39 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%4]) with mapi id 15.20.6222.028; Tue, 28 Mar 2023
 14:41:39 +0000
Date:   Tue, 28 Mar 2023 16:41:29 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, andrew@lunn.ch,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, naveenm@marvel.com,
        edumazet@google.com, pabeni@redhat.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, maxtram95@gmail.com
Subject: Re: [net-next Patch v5 5/6] octeontx2-pf: Add support for HTB offload
Message-ID: <ZCL8mXFZxpTj1Duz@corigine.com>
References: <20230326181245.29149-1-hkelam@marvell.com>
 <20230326181245.29149-6-hkelam@marvell.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230326181245.29149-6-hkelam@marvell.com>
X-ClientProxiedBy: AM0PR03CA0036.eurprd03.prod.outlook.com
 (2603:10a6:208:14::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4914:EE_
X-MS-Office365-Filtering-Correlation-Id: 30f07cad-3583-4b8d-65fc-08db2f9a89ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vwNKTM6K8fSpqdfgbykvhVlpWS4Zp0BJgbFM7QK6gX5N5PZkdSfKvfbSCyPjh45uowijM1TkVfmOQP2HDjArWmGJJQvlw1OS60lK+GmbCNEpXX/Rr7kTyMAXdZSk7Jpl13xSweW7Ky/syof/uaPXnADtK5MZXcM2ji8750tW/e8rO8VCdgCYkjLvtuY98z6ZM3DR/2Vnuqdb/k2AkKxAHu8Cxz3T20nbguK8DCimnKkmkuDCgkXiywuVgg3ihw2MoNs1kbOOQsgakQyGWqacxGTvLSaGkGGYwcKYpEts7n/i9dGW9Ft+zUVlzqMqCVEToNeTUmyiPU5ik+ylHfm2R/fY9Np5AR/w4dFhDNU10MnqNGZpPTVglYCprXkBDoMy4W7zUzd+XwNweIAGjYpfa0EusHTAK9YlIut//pGg4/WbIqxegKC/u+UXzM9HoQoQ4MViTM4RFI0zkxLZ4MxHWo3L6VNbD7A1bl2UGFjTy52nD8Q6CyJEakS/TiA1gBrAntQbYBGYXXeNpYX9wcM7QditiKJf1vVqNyB1S7RwVY6eRYIEhU0TJDqbwSDS3j26
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(396003)(346002)(39840400004)(451199021)(316002)(66556008)(66476007)(6916009)(4326008)(8676002)(41300700001)(186003)(66946007)(2616005)(6506007)(6512007)(478600001)(6666004)(5660300002)(83380400001)(8936002)(44832011)(2906002)(7416002)(6486002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?58UAZRx6Ev2inNFrFzO8udEaMrUMcT0tO/xSoowyum7DRMOo+ClIbGKzDGVX?=
 =?us-ascii?Q?b00GnwF5hnHVpKg1qUzzgnGFnOzrSS2khpTodjbqagzYFWiuYXIfgKzsZQPy?=
 =?us-ascii?Q?G5YhghV7b4N9Cuu7lDzjB9mBXASk+qOyhR5gHClm+1M1k8Ows45LKF8ot4Sn?=
 =?us-ascii?Q?ogh1aMBdGlW6/6pf+Fse6PJ5+d0QNSIs1nCpgoqhzJgKa98sbyycwBHM8CrX?=
 =?us-ascii?Q?lj8+u4Sww92rXQqy0bcKzmW4CmIQCKCwnZep/IRzmm8w1DBEGOYFud0WQuEP?=
 =?us-ascii?Q?DDDLbzUn2rRFPIWDlz1jQMf8Mk07at/6xXDQ7H6RkhTR1fyfGCPAi7krXCxg?=
 =?us-ascii?Q?qKuexRODWMCd/5xggKzOq6i3z4SKbW03M41+bS6ITfrwPg/rNeBrgjD8ESVY?=
 =?us-ascii?Q?sjQ2kkCtp0O/lHKK8LWu5bEBDsyxSuARaJX8K9JePjwxydIfraM0VWyYd/6d?=
 =?us-ascii?Q?fZS6T3C93yV9HrEk3detkGXf0r5HU4OqaNa7B7J2Q+kMR0uYohbSXdg7qWpk?=
 =?us-ascii?Q?IO2p0nAKXtDwz9t4j67lF4CPDZT8Q9I0D+72v7HcqInjA2P3rTDw30lLniWK?=
 =?us-ascii?Q?k+9Ff3GZpztJzMw0ZW3cg/A96EahnRRDnpxFsUOk4Gp7UnVc6TQ9VdVTHB1G?=
 =?us-ascii?Q?/ZQFKOG++mLbLnDuTIZHUWWsWGHKd2thyWQVBGsSxn15Www/Y7fCCHyCzBey?=
 =?us-ascii?Q?/5kHIoteTFS2fyYNZiltiNHeJVyeFKXjLYRwzDTJQ7A6q+QJuBLLWVVqfQBa?=
 =?us-ascii?Q?H4wPdc3Z7r7JIFX5ww7sj1KhbUICkrtmntFBMrzVqE+Ly0fcxikftqi5IK+n?=
 =?us-ascii?Q?ieleneMU92JFfWPCfIElwD9ueiK8GMKX9xw85LAbOsgjqPUufif8IrMax5ZN?=
 =?us-ascii?Q?O7sP/BKgAcjc1xBrC9H4c9aUgXrC79/mln7CNYajZsvV9PG1qIem/pLuEMs7?=
 =?us-ascii?Q?4+Avt9OqRnE0CUBlat5Q8oq7i5sTyH6PlKlL8Gp2Q6fOzpynXddr1CLznmVf?=
 =?us-ascii?Q?vod7CfjyDOizJRVBI++TDvKvd/9eWc4zF4mXQecRSrjGTR+E7hMornHmU3TB?=
 =?us-ascii?Q?0Tju3qoy/nY9zXlilH+WhEHmIh8XrVQK468ed4NeJ/vvcT+7WeWMDxT6MngY?=
 =?us-ascii?Q?oa6TLv3NLFfuV3Xgh/D1y8w6X50dBfZBoUsjCC2f6RGPudOvWc5n826fdf79?=
 =?us-ascii?Q?kuLCp8IWGUkQGO/XFcWWmHJm6lROpDrkx8jEQBc78902PxCSKjWr4Ew49Smc?=
 =?us-ascii?Q?JgvebdWNOdW28RyznYR2D9gwSco5SatzbI52DQNDoHlyAGtCcJCInHLrDn9e?=
 =?us-ascii?Q?rXuwfMI7nNt03gwGun5zsJHmlxwOtoejO2gA6hRlHUxdFUp9Ii9ZaWwc4zY1?=
 =?us-ascii?Q?E0SHmfcqB0Y3iiaflusM+ulrPsAN4O7UzR0fLZDKQXua9I/FgBe6lx/FO4PZ?=
 =?us-ascii?Q?Jwz8mBYYAzsx9VXHV8hqx1r0nIWw8Gud7951b7BvJMvR9NKRLRW5y0cOIfFD?=
 =?us-ascii?Q?iQJjrQo3Ah5Z96RAHiJHf7uO4HJxUXzY7fK5g9BpDX4kAhkU9RkZpxw5YlyD?=
 =?us-ascii?Q?NcX4p8ldCVDRxh91bgQdKpPagGCaTZ1Nyns4I3fEiVm21PCFd75bveP2+lkF?=
 =?us-ascii?Q?+CoztfoQ0t9ooSObI7a4PEhO14BZSu1BLPWsnrLpq03/s8sMIhPxXVG3DnBk?=
 =?us-ascii?Q?oeBWqA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30f07cad-3583-4b8d-65fc-08db2f9a89ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 14:41:39.0512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: loIcKKrhTQimaCQ7h/E1wLFjAnoSSnZb7PyygbQAIlhaYD31nrhXkLWy5s/7F0jUH9YjuvgHNrxLS235ObAmYzV43SUIO118o1fm5jjdGZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4914
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 26, 2023 at 11:42:44PM +0530, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> 
> This patch registers callbacks to support HTB offload.
> 
> Below are features supported,
> 
> - supports traffic shaping on the given class by honoring rate and ceil
> configuration.
> 
> - supports traffic scheduling,  which prioritizes different types of
> traffic based on strict priority values.
> 
> - supports the creation of leaf to inner classes such that parent node
> rate limits apply to all child nodes.
> 
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
>  .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
>  .../marvell/octeontx2/nic/otx2_common.c       |   35 +-
>  .../marvell/octeontx2/nic/otx2_common.h       |    8 +-
>  .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
>  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   56 +-
>  .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
>  .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
>  .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1460 +++++++++++++++++
>  .../net/ethernet/marvell/octeontx2/nic/qos.h  |   58 +-
>  .../ethernet/marvell/octeontx2/nic/qos_sq.c   |   20 +-
>  11 files changed, 1657 insertions(+), 35 deletions(-)

nit: this is a rather long patch.

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c

...

> @@ -159,7 +165,7 @@ static void otx2_get_qset_stats(struct otx2_nic *pfvf,
>  				[otx2_queue_stats[stat].index];
>  	}
>  
> -	for (qidx = 0; qidx < pfvf->hw.tx_queues; qidx++) {
> +	for (qidx = 0; qidx <  otx2_get_total_tx_queues(pfvf); qidx++) {

nit: extra whitespace after '<'

>  		if (!otx2_update_sq_stats(pfvf, qidx)) {
>  			for (stat = 0; stat < otx2_n_queue_stats; stat++)
>  				*((*data)++) = 0;

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c

...

> +static int otx2_qos_update_tx_netdev_queues(struct otx2_nic *pfvf)
> +{
> +	int tx_queues, qos_txqs, err;
> +	struct otx2_hw *hw = &pfvf->hw;

nit: reverse xmas tree - longest line to shortest -
     for local variable declarations.

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h

...

> +struct otx2_qos_node {
> +	struct list_head list; /* list managment */

nit: s/managment/management/

> +	struct list_head child_list;
> +	struct list_head child_schq_list;
> +	struct hlist_node hlist;
> +	DECLARE_BITMAP(prio_bmap, OTX2_QOS_MAX_PRIO + 1);
> +	struct otx2_qos_node *parent;	/* parent qos node */
> +	u64 rate; /* htb params */
> +	u64 ceil;
> +	u32 classid;
> +	u32 prio;
> +	u16 schq; /* hw txschq */
> +	u16 qid;
> +	u16 prio_anchor;
> +	u8 level;
> +};
> +
>  
>  #endif

...
