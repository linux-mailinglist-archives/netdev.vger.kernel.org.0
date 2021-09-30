Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4784541DD1B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 17:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245187AbhI3PR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 11:17:27 -0400
Received: from mail-bn8nam12on2106.outbound.protection.outlook.com ([40.107.237.106]:27488
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239388AbhI3PRZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 11:17:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7N1hFa7fpL5xsIVSKsD7pDXJ1OljD9eoQNA7H+OOA55tDL3Fm52KZQMJHXa6WjtPOi2D2+xb+OpSCUIo+l9B6IRJMMuAOB7ua17Cqj3EWbI1rB5K8iY/ML4bhN5WtCrbV6HX7biFyAUTf5hQA9ga1f/im3XqbFNv+1v3CGAZoXswhCv85tWpi/xSQDjzx+PmJXqgdSCDgfugmt3vHUgEtcQnj0uLa/D3wLj69odDa4QdZs7/0k9W4AA90Yg3X73aILCW711CEbkNOjR0GhtXdE9Q/0jwPGn9RyEAe04eOt0O6UQclYmO8oRRhSVL0D7xDx5Ti6K1RuB53wzwHnYPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yWuzZH1vwn+VShjSl76pg94/mnanWpBoulQ/nkDFDlU=;
 b=d6p7UGHLWYlDJ0KgIufRg0JE0bKpTEUJNBbGw8et1gEcRNc/TbywpmdGaxZQx0M43IqksKKI04TUm6eVZyuocR0C6rVpafpM6tXr2PWJzILZgxBP3SShnhtXHBbfIZonN6t1pG7X8YffSSlmMAvLQPduB/8CTsjV5x3UYR2fGnbKI7Y/wS3t0zb8N6BuUGPqW3NEzMC1YQJOOUxb+/v56uPK65KhX8578g1FwkjOb5WrIkX+afWi9IrHH4t9pefyk3ECDtPhlKpKmisA2sacJdpo77CaCJvGLtqnRvDCWCxxTRuTmhlc86NksU2wCX2MIBdXA3j0JO6Ko+8Ky4l6gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWuzZH1vwn+VShjSl76pg94/mnanWpBoulQ/nkDFDlU=;
 b=LV9o1sZdWnat/E4JZbyeQmCCpJoadLYez06d/NUDl9NlJAUzr54S3n6ZS8a4YP591feIvgo8IYWrT2MkA8jrOmEbKYWpIeldMQeJkehWdxUvQjOiZgadswfIDVNm6OHz50wHZxQASM5gHoMG86T3LNRSbI3rkRVQQqCy5uk0fCA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4431.namprd13.prod.outlook.com (2603:10b6:5:1bb::21)
 by DM5PR13MB1450.namprd13.prod.outlook.com (2603:10b6:3:123::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.10; Thu, 30 Sep
 2021 15:15:39 +0000
Received: from DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::b40c:9bd9:dfcd:7ff0]) by DM6PR13MB4431.namprd13.prod.outlook.com
 ([fe80::b40c:9bd9:dfcd:7ff0%5]) with mapi id 15.20.4587.008; Thu, 30 Sep 2021
 15:15:39 +0000
Date:   Thu, 30 Sep 2021 17:15:28 +0200
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yu Xiao <yu.xiao@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net] nfp: bpf: Add an MTU check before offloading BPF
Message-ID: <YVXUkPIWkOFMUDDu@bismarck.dyn.berto.se>
References: <20210929152421.5232-1-simon.horman@corigine.com>
 <20210929114748.545f7328@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YVXNype34MW7Swu3@bismarck.dyn.berto.se>
 <20210930075959.587f9905@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210930075959.587f9905@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-ClientProxiedBy: AS9PR06CA0249.eurprd06.prod.outlook.com
 (2603:10a6:20b:45f::22) To DM6PR13MB4431.namprd13.prod.outlook.com
 (2603:10b6:5:1bb::21)
MIME-Version: 1.0
Received: from bismarck.dyn.berto.se (84.172.88.146) by AS9PR06CA0249.eurprd06.prod.outlook.com (2603:10a6:20b:45f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Thu, 30 Sep 2021 15:15:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36fea254-c24a-4cc7-a224-08d98425296c
X-MS-TrafficTypeDiagnostic: DM5PR13MB1450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR13MB1450F49EAE173135616802B2E7AA9@DM5PR13MB1450.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YM6qqZABUoLbiYGUCUFPHRsRfwBksdhRCpZUidRgpA3OK2CCLyTqfLlYPtzt4UdYBRTdPiyWRR4p/9AzNS9ovMBQfBo7MP285ZOBOCMysfu9Yt44kjpm+KyY6GD7p+xXnKd+Z/C9xhxTj8wM5EX7ltflAsOz892/jHZh9vw4b4gfRGyOsaFhdI/Q0KbCf79yqwXL8KEynODWnGL2gt3Ooz/fI/fhH5HADhSVCrJ0bMmehWG5VjLA/KlT+5EiQG8vY5UfQllwnUjkYGGsHA8bnuTJaQbDbCCGwcniNXOlIC9xKZENxkbZiCc/On+XoGyXu7UTJlkaz3wG/8ti571sJckClukIhutfnk9mkLL3883XgDtm36k4sCx34W8+Z4M8xIHXvmmbvq0Q17uAeu/R75DPbw8g9jrM4FIq2Cga++ZRorHfekmPhCFAuiv2NQN+T5aCuCEB0C/aIs06APB8SgEPzRvJCgUdX2yRzaTiIjhFyJ4Yf28KerRIU0mOWGibw1F0gJrEQe0tlbujoasEDRiEz3KnlNjE86QGicy5ENBeQor+PTyo55TocE4mUEmJ0AdBfS4ixRb5eKYWyQC+ZmkKdGfB15tMeD6RIDS7C86DAOUfnn2uf4l5s71FkBv6VCrLlmuftCOMh+7PnzxwNGyObKnxh6faZVMgPWjqfV6IHSMzHykhZLdwMepsQ7GNeu1QKUcF74SkytJxan513Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4431.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(39830400003)(366004)(396003)(107886003)(9686003)(956004)(55016002)(83380400001)(66574015)(186003)(66946007)(66476007)(66556008)(5660300002)(6666004)(26005)(86362001)(8676002)(6916009)(7696005)(52116002)(8936002)(508600001)(4326008)(38350700002)(38100700002)(2906002)(53546011)(316002)(54906003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?q6Ep9jJXduHnm4aWdeyFkll2MWx7N8gY0zUgNs3Mkv1l2cqaukBwrbcgSD?=
 =?iso-8859-1?Q?ILTBpaQk7q9KjJm1TP/IlhEw50oTMMY5A4estjExKqYs+xx5YtnbWve0Vy?=
 =?iso-8859-1?Q?i6D13Ewj2ELptNqy83HugcHio9LcPyvgSG/c3SYFtxvIzOItIRi1S+tfpW?=
 =?iso-8859-1?Q?0msz0k/h6cvB8yns5OY4F9jpsK/9mOymNPFCTAmwQXthfBbwEg6wGvokhU?=
 =?iso-8859-1?Q?md0wMIFvsXoCTrMaQ7VoB0XPrV4ykvX7OP+7RkwEnavHb0VAiXUbMrSmYe?=
 =?iso-8859-1?Q?fXpq8yknmbXHAYISmFt1FAONfnzvkXS4B26ffLLlRV6gk0Hf+2PXbBQGC5?=
 =?iso-8859-1?Q?KH5AJ63skd4Bpbi86U5xGFe8W3EBWPsqagDkQsWlHEevYqVTEXKx0jvqK3?=
 =?iso-8859-1?Q?jws7H0ONplSV/OcwF1DM2EvnUrqFWIKWQuiERaPFlvS+/zbvW996jHSpWo?=
 =?iso-8859-1?Q?9GnoyowQYSkkrSd6NSnHd1QIHdGC7lFXmg/O86EGtnxYwwFCWV5LBT688/?=
 =?iso-8859-1?Q?y1359FV8PziRhd2qrARaatRGSBkpJw3VCC+jnTTQKVE7FgujHP083HOKrH?=
 =?iso-8859-1?Q?Is+GdFnlP/mqIKpebTCJztlfQ5HFvqXlHhmNrFDfv7bR48KfeO7IjV9w0p?=
 =?iso-8859-1?Q?urMH+AB6cYO4NOljwNGTwQEidDTOmk+doPZjXY5nF43Ht1xomQViMhrAK7?=
 =?iso-8859-1?Q?EJ1tY8aOUGF5aeJMhgG8uRTXNXAyCDDbBsgP8UxJd/cdru+CEAhorU7yzK?=
 =?iso-8859-1?Q?1l0RsqDhoo3V06+tMnxt81kY9OgMLqe/vLADEFgM+ezDVU+ADJ35/pzPuV?=
 =?iso-8859-1?Q?wqf6xbk26/0dO2Y0llI3dkgUIFrau5lTRaRPvxvpLM7WLiUTediYwjGbpM?=
 =?iso-8859-1?Q?s8HXP7bRW+HhKjqR3wmg6z+6wBZp6sf8qjx+VK1/mgD2GgvVAsFouGxiNl?=
 =?iso-8859-1?Q?hSyTTM/cb8K0OOixMKT9YSzX8p1gzzzMOIG0RWWnkNDsA23aKboGQubYgv?=
 =?iso-8859-1?Q?CUr3gq7uUTY1+6SJnA51j6CBXtvGtHuIxPoMnH2SWWpRaCFyx4UxZRvWoa?=
 =?iso-8859-1?Q?A1gJ35jig7JnQtAbfAhTm3QC3BkiCpUmqckdxWoJjT4Z6dVXE5aUtbbGbj?=
 =?iso-8859-1?Q?jsEV/nVwqnxlSdJmmlcZSeiyPDfNBYy2JbXWOONmIV+90rcudJX8sz/F7g?=
 =?iso-8859-1?Q?ZwbbmP2ol6MBj6s+hErlsVUhLGDV+chLPZHCT6JvVLNzzV2rjsXB2g00MI?=
 =?iso-8859-1?Q?fLLENFOlbd+vszoeatRbq6jEi+kAAcajZfGvUHrVIdRJICvkxeP9SBaU4Q?=
 =?iso-8859-1?Q?soYdxmItp9gZbadS8B+bLfVEGEK1UB8JulnjNX8ZxbeUTsYH9ZW1v3fhoL?=
 =?iso-8859-1?Q?w6L7iF7YMR?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36fea254-c24a-4cc7-a224-08d98425296c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4431.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 15:15:39.4541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z3mG/pxM/LJc1saTlc0VreUSo+g5p/BpfKz5OU9BroLx6mPHO8BcS8pBmkKB0zxzsyurwLyDpSGFRCD0whJYfPCaTn6u7hndIbqRrHBI5e0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1450
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-09-30 07:59:59 -0700, Jakub Kicinski wrote:
> On Thu, 30 Sep 2021 16:46:34 +0200 Niklas Söderlund wrote:
> > When the MTU is changed after the program is offloaded the check in 
> > nfp_bpf_check_mtu() is consulted and as it checks the MTU differently 
> > and fails the change. Maybe we should align this the other way around 
> > and update the check in nfp_bpf_check_mtu() to match the one in 
> > nfp_net_bpf_load()?
> 
> That sounds reasonable. Although I don't remember how reliable the
> max_pkt_offset logic is in practice (whether it's actually capable 
> of finding the max offset for realistic programs or it's mostly going
> to be set to MAX).
> 
> > On a side note the check in nfp_net_bpf_load() allows for BPF programs 
> > to be offloaded that do access data beyond the CMT size limit provided 
> > the MTU is set below the CMT threshold value.
> 
> Right, because of variable length offsets verifier will not be able to
> estimate max_pkt_offset.

Thanks, this made the design click for me.

> 
> > There should be no real harm in this as the verifier forces bounds
> > check so with a MTU small enough it should never happen. But maybe we
> > should add a check for this too to prevent such a program to be
> > loaded in the first place.

-- 
Regards,
Niklas Söderlund
