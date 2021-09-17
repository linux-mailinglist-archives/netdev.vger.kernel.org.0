Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C84540EEB4
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 03:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242174AbhIQBZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 21:25:59 -0400
Received: from mail-dm6nam12on2123.outbound.protection.outlook.com ([40.107.243.123]:17761
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232222AbhIQBZ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 21:25:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lj3igesvG087rVoCbXnTe4Dj7GG/x37RxGQceB4p1mK330Oca/9vR5YFFbMmE8JRHGbDifoQqKsFn/6YZLGOF3VPwF/XOwjsPyc/FjfNN84C6I0fZCx0Vp2i7uCOUNjHuvjyXHDl4D8NpoY1bCZspXycWdr3Vva6uSrYPq1t5+wkIqQS5qRAEYtzDBzurKCLicN0gF9gl8IBuznqVDZT7HL1yc+IiYmQlgRY9wi6z/7FZMrsorfLo7yQsqLnIZHSAYS/utDagbcA4EaVdIBEgp49SUrGHjo0zF24VHlwHy6guNdUlcvHFv+3SxoaEsVXaeV1G+ELoFf1PtZ4OO/ZiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=pAylwhCLKQE6upkxOpTeuKjfnz6hUJrgci6PxFcqocw=;
 b=UjJKi7xGpFpys011twiMmTtsGEpwAIpXUz3NCB1O6XBZhip1Dd8Xma+WWQhLTKkVlFXDb0c6Oz/rdKXLz3KiFknghdfRFl0Xa/zrJS+WCFuwSBjCTrgBW+A6I0gxH7SHsa+runLUJmwaZEypOnSRSuIVkrLPBXD2pJR+Og9bORo9iobF8tTumS4jEkJ6cpHfwKbn6WAk89moomwAWvLooCxoOSgVnkfYQLWEqKXVsmckdPF3aLYsLtf6zyfRFT5RmdrPx2AofUY5+LIRoA1LPwufAc0+p5h1kisEb4/a+Xs073GPV9ERrb3NYK+IHZMby6kgVpvsC8tPamNRDPA53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pAylwhCLKQE6upkxOpTeuKjfnz6hUJrgci6PxFcqocw=;
 b=W7h/YV50uxsGofv+orzM49GnAYW3677PeqbCUrvR5A0Knrq479Rzg4qC8gLCtjJ7TXrJ3B9b7Yxm3L1Tkqa0oFeQiQ0z/p5fl9NIC0nuYbx8T6jrh43Tibeb6nn3I3mNIXwCI0xxkuKYWZrlvBV1TRMGnAJC9HnUs6eMiHy45tk=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4516.namprd10.prod.outlook.com
 (2603:10b6:303:6e::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 01:24:34 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::bc3f:264a:a18d:cf93%7]) with mapi id 15.20.4523.017; Fri, 17 Sep 2021
 01:24:34 +0000
Date:   Thu, 16 Sep 2021 18:24:29 -0700
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 net] net: mscc: ocelot: remove buggy and useless write
 to ANA_PFC_PFC_CFG
Message-ID: <20210917012429.GA647191@euler>
References: <20210916010938.517698-1-colin.foster@in-advantage.com>
 <20210916114917.aielkefz5gg7flto@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916114917.aielkefz5gg7flto@skbuf>
X-ClientProxiedBy: MWHPR17CA0087.namprd17.prod.outlook.com
 (2603:10b6:300:c2::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from euler (67.185.175.147) by MWHPR17CA0087.namprd17.prod.outlook.com (2603:10b6:300:c2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Fri, 17 Sep 2021 01:24:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e439240-34a7-43df-53b6-08d97979e7e2
X-MS-TrafficTypeDiagnostic: CO1PR10MB4516:
X-Microsoft-Antispam-PRVS: <CO1PR10MB45160B52456C771CD034F5EEA4DD9@CO1PR10MB4516.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uPgfvPxJTrt0tAtsc20uIRV1XOYS5t12udwX/g1nBUwIQdd1GIFTV1IQH46lNaywruwxNeR3vn0W/pGwIM7mb+qyV1/5Vwfs1EEVQNM6dFX7yT+ycY1l9FMIECZxfEepz3Bt9MY8tTE2thn/q+EqVu+nNL1LfDpdZ1ll9S9OEOHy2Hnz3Ny0L69xFdG7KPPJdGx1YHDokkSHViUeJa6iidr0HOUpLDEGuE3cTGPdrPaMWmudIEyOaGJ9K2f/DTr3asugQGujHTCERc+f3kL3y9JAqMTHsyRZJYJH0MOh5Al1otGLt7SbN+mzloiGbSGxRPgBxQDSZBKPTciXQYjcUtAdc9RqfiGbmm5C2nB1uAUU7f7zQtguxDp6w4epbbMluUeDUXFMvsxkV42JKrMSZUArtH1cNB9H0XWZo6ZI70dwbTnMVnvHuHh+zDtWkyw4neTJ3q00IVGt6Ak4XydEAuzsgfW0xGAVDjFVH0FLy8EodHbPbpVE0YU/0YaSVqgnZDTTB/5/Mdae9XoOC7014TDXqX8cSPgqN2Sm7DEfLV5c9zUGncp1kcv7KDfyNKZpVENigWE/csBOu+j78o5Sqsb8xlH3wUfYVDAzuEAOrUO6YhRnC6ECA79w1iuDfRQarR+8iWp4oZsbofdvUXXPfo+31IHLdMrHIIW3j5b7I1k1x0u/QNwmvPj1CwqAoB0oVryM/5yZHCVNUUzbLhBQ17ISodS77viRj7ZA52nhwUnKfsZDJwabghsCFleE5CpSCS9S4bFmQIFKbmTTZModBsqmoP/7AN8BBIOpPulNgEw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(39830400003)(346002)(136003)(55016002)(52116002)(9686003)(9576002)(44832011)(33656002)(6666004)(6496006)(66946007)(478600001)(1076003)(66476007)(66556008)(86362001)(966005)(33716001)(6916009)(4326008)(38350700002)(186003)(5660300002)(26005)(38100700002)(956004)(83380400001)(2906002)(316002)(8676002)(54906003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nvUJELUpz/0WeWpPRBlCKi1DEeomUzz12yTzs9yn35yZGwAgx7z0RDO3bY4L?=
 =?us-ascii?Q?FiQDyNbDgttaKpQWDPxEIlBw+0Pi+wsFBJ2vmg7YJ1Y6XDy0QXm9Dktk8Q3K?=
 =?us-ascii?Q?tSfTXCYfJqvfuswLHftnJPFnPiaG4v+/N8mZd4GIfLKY9R6PAKFn7l6tMH7a?=
 =?us-ascii?Q?DYU70QvQ6XdhGJD20wk125KU5Qe0bPOGJpjQp5gJQXWkMB0dy2F7R67FaclS?=
 =?us-ascii?Q?fMbGUcytmFFJy6UJ3vcf+3sVCPjLH/9MgOTw/7VCDdJzuXFw0iZUZ6WySBDt?=
 =?us-ascii?Q?xUouVbEMckoSZEPp/zu2gMhCMLMvmedIN+qNZ23t2WmP/iSsOgk6Ga7TqDVo?=
 =?us-ascii?Q?cGhX9cSa/4nnNKV3EoVm3aDJZFAGy1hlCjuba4+LOfrSP/rpwG+9KlZvPmsL?=
 =?us-ascii?Q?8ywxYNKQX+Ir9+IXEFyA15no86srCy4HahXwOTbzhx64qs0Q22+RH+OtVzk5?=
 =?us-ascii?Q?Ygg0EhFIaF8iQtVE9XSXepl55aWzpRkHb36e3rrCozl0fydvzzgZxIwbOi1P?=
 =?us-ascii?Q?5IOMu9NbbQi4zlvKLw5rWiNbdv+XNaNklbyk4OupG3+galOBQwy/qGljyu0N?=
 =?us-ascii?Q?U9g1EHVu9FYCB7sM7WPRqeeAKuhO90+bZdRlkJLEPIWXkQFBbMDnw2z/T8CY?=
 =?us-ascii?Q?itQ/i2ipS4c99Che7VMCSljS/D3dzpT1UEppFHe7GaLDbOgKymPQIaTG1cHX?=
 =?us-ascii?Q?aQV7WQAH4wwioR/uQ75yPTR63c6PTe0IiICUQCHjkpZWbDrBdx+ailCD0nMw?=
 =?us-ascii?Q?pzxwLIfqVhIpXNaP97GPXe9jsKRw8D+Fec24ESEiKJCiju4AlCVExVS3TrTg?=
 =?us-ascii?Q?OTcDslSJdExSYh4cH5+WG03WIGxOlj8722R2xUYYB/gA7gylUMfaOP5OIVuL?=
 =?us-ascii?Q?whKnsAi2DvLyi+DSL0YQePczC5M8WQoeBOwlx/Xp74eUyYOQoJpukfuL1YX+?=
 =?us-ascii?Q?1jKsf5317v6UbVTqwqb+4vdnZ4Wn/eJtjGORkmBrh4Ite+8xektS1iPxWnrH?=
 =?us-ascii?Q?CECpSsm1iTXLSHH6Fa26RwnATlQeUL/BDjc+Lu0GleEr5gSwT0CF7l1Z6RsN?=
 =?us-ascii?Q?JthJL0MnaSqw9udlj/12QoYvEcJPZPAismErIdZnScvEw+Ns//iKIAJ74W83?=
 =?us-ascii?Q?RbhvEi1EeQ/LPogvJ9KZ4HeC0Sqwpr822X5c8FRlXhkJZziFT64h1R9OkJIj?=
 =?us-ascii?Q?opuUkKHzUk6hrImHL4bheAL3tu1vzGWuYTovPJceaOpqixt7d4g36zExHAn4?=
 =?us-ascii?Q?AG5gdyLgTcQmaCdIJ7gjhRNzq8ucO5cUP/vyRWv2aRn0E/wBNVuWNyQzjThT?=
 =?us-ascii?Q?wURGMRP24iRrtl9WtQoCI5ek?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e439240-34a7-43df-53b6-08d97979e7e2
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2021 01:24:33.9827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +Mjh/J8YEbxsYpOobLIgbC7CcuiMc+kwRVaKYIR3DXImmy0BiUCnQBh8jqu5ZUqs3imSf/T2T2rw/coMxKWdinRq9blZ7hpRqPuORy8gOI4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4516
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 11:49:18AM +0000, Vladimir Oltean wrote:
> This will conflict with the other patch.... why didn't you send both as
> part of a series? By not doing that, you are telling patchwork to
> build-test them in parallel, which of course does not work:
> https://patchwork.kernel.org/project/netdevbpf/patch/20210916012341.518512-1-colin.foster@in-advantage.com/
> 
> Also, why didn't you bump the version counter of the patch, and we're
> still at v1 despite the earlier attempt?

I wasn't sure if changing the names of the patch and the intent is what 
would constitute a new "patch series" so then restart the counter for 
the counters or not. I had figured "two new patches, two new counters"
which I understand now was incorrect.

In this particular case, should I have stuck with my first submission
title:
[PATCH v2 net] bug fix when writing MAC speed
and submitted the two patches? 

I assume it would only cause headaches if I incremented the counter and
changed the name to something like
[PATCH v2 net] remove unnecessary register writes
or something simliar? Although your example below suggests I should
maybe submit the next set as
[PATCH v3 net] ocelot phylink fixes

> 
> git format-patch -2 --cover-letter --subject-prefix="PATCH v3 net" -o /opt/patches/linux/ocelot-phylink-fixes/v3/
> ./scripts/get_maintainer.pl /opt/patches/linux/ocelot-phylink-fixes/v3/*.patch
> ./scripts/checkpatch.pl --strict /opt/patches/linux/ocelot-phylink-fixes/v3/*.patch
> # Go through patches, write change log compared to v2 using vimdiff, meld, git range-diff, whatever
> # Write cover letter summarizing what changes and why. If fixing bugs explain the impact.
> git send-email \
> 	--to='netdev@vger.kernel.org' \
> 	--to='linux-kernel@vger.kernel.org' \
> 	--cc='Vladimir Oltean <vladimir.oltean@nxp.com>' \
> 	--cc='Claudiu Manoil <claudiu.manoil@nxp.com>' \
> 	--cc='Alexandre Belloni <alexandre.belloni@bootlin.com>' \
> 	--cc='UNGLinuxDriver@microchip.com' \
> 	--cc='"David S. Miller" <davem@davemloft.net>' \
> 	--cc='Jakub Kicinski <kuba@kernel.org>' \
> 	/opt/patches/linux/ocelot-phylink-fixes/v3/*.patch

I've been using --to-cmd and --cc-cmd with get_maintainer.pl. If this is
ill-advised, I'll stop. I noticed it seemed to determine the list on a
per-patch-file basis instead of generating one single list.

> 
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Please keep this tag but resend a new version. You can download the patch with the review tags automatically using:
> git b4 20210916010938.517698-1-colin.foster@in-advantage.com
> git b4 20210916012341.518512-1-colin.foster@in-advantage.com
> 
> where "git b4" is an alias configured like this in ~/.gitconfig:
> 
> [b4]
> 	midmask = https://lore.kernel.org/r/%s
> [alias]
> 	b4 = "!f() { b4 am -t -o - $@ | git am -3; }; f"

Thank you for all this. I understand you have better things to do than
to hold my hand through this process, so I greatly appreciate your help.
