Return-Path: <netdev+bounces-7133-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5407F71A355
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:55:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABF5C2817FB
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0816C22D7B;
	Thu,  1 Jun 2023 15:55:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B34BA2F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:55:32 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2106.outbound.protection.outlook.com [40.107.92.106])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E262F12C;
	Thu,  1 Jun 2023 08:55:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ief0E8zUKF1XO+lZKZ4SAlkvxDOyCMZ1G3D1z7V79U4LoOZJfENY2dO2hcV5dgBfzPcMiBUAXMoW9GDh/R7sQP0SvHv2rHaF5JkXSy1IYyugx5RlI+LJT96xzxp6OBeQe0mHs1FB38Q8b+kGTwFDMLoBPiwSYjlQ/yRC+LMBlRFV/fjQCMz/8jIMGZPgzcRobY/qZ2HdGuGtSG1tJfhQjnnfRWeMXORNxOIJyj0qxrpT9VNvrkb5rrtD+jEZF7CH7JtdRI52CYg0BhBWFbRUAR+Ty/lf9HbucYMzjHkFdu4rrlRak9aya1NKoQ2tveQvKy2O6fhUi0BciQff9QDH+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vk4aKa3KlBSR+RPwxtSBmAST3zYhqMuIKflsSPWBoCc=;
 b=UVgP2q1BEZPPQZoTsnqYm984mVOPPbjO9Jmdxs+ZzqQ0lWkOQbQ6tMntfCUdPhbICG0BNzsQ2XzKRa2t+1U1np33NetLu/89m/f49sN+I5k383iy8SHmBdJvefNNp9YS1YYVyloXU/pLgCbsyoa/ryMR8EPg9mGWrcDrdLXdEqLEHN70Pw1MRUiTa+rEnDOK6BJzytkTu9nD3tcNbFDPFZ6f4XGGwqm+A4BG1R8SmIXr+0GVeXaq76jwNLE0zAeLaRx5434iT4ozDLIpOm8sPzta1R08qozjIxq7tLxBtakno4YsYqRNIVdlCU8syYr1VyHA6ENMWpm6w/fvGwIgHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vk4aKa3KlBSR+RPwxtSBmAST3zYhqMuIKflsSPWBoCc=;
 b=nJR88oNLT/qNfAuADKy/AOKPfRTZz9LjRkncLSUYqqq7WiIa4VpKcVTOO+CuX63LQJc7gW0/++4+Z0rH4dKwsQvB8IUfK7qu+YZC3KfTJ6H/Wq8udEkdV3eZVOrwCz1vn85Ma7YMsOAP+xPGOl0D0OUbxEI6uzO7xk8rcVySKPI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5764.namprd13.prod.outlook.com (2603:10b6:510:11b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 15:55:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 15:55:28 +0000
Date: Thu, 1 Jun 2023 17:55:21 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, bcm-kernel-feedback-list@broadcom.com,
	florian.fainelli@broadcom.com,
	Daniil Tatianin <d-tatianin@yandex-team.ru>,
	Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next] ethtool: ioctl: improve error checking for
 set_wol
Message-ID: <ZHi/aT6vxpdOryD8@corigine.com>
References: <1685566429-2869-1-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685566429-2869-1-git-send-email-justin.chen@broadcom.com>
X-ClientProxiedBy: AM0PR10CA0021.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5764:EE_
X-MS-Office365-Filtering-Correlation-Id: 153d3ecb-3d36-4cd9-7199-08db62b89ea8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	57twhxaBZShjqkeRoFzLahpHkm1tcFbBERezupvzBI+HDmhoorQcCgldZW/hCWYTt4fSn5OLQxRgkHTjyRi+uL2MFOq575Mk4T7x5EZ/K+zqLX7wiPlHq5QtuaBNbNT2W6dg5HEWapKxci6TxsBn/klJTv+3TLpwz0IgflQaQ//4Rqcqd5k10HQR3dd9jpF0hVckHQBdqrVFbFYLdSmMkxrfGShxpNH5ulXLY2S15NBZNwwoLslg/kTM0UP+17PpA2x1t6xY5iiTqMaGnqFr+55okeLrCtJqo+Q3K1+lVCqsXvQNlNmYOhZHeNUMwoEhmSOtlMqNJeRhpBVjBGfSIfjItrU9jfnlN5ivvkPxRt4NGRemVG7WIjakDfVYFswgvCo8o/t0L8lwFw1J7d5xofI5x1i8gZbrfQqbPvqE13kO5FctJ9lizpCP/USq8KOF9X06pfHKQApgaQ9z+vjVjxFZtF09RVqMBM+tAxBKyqnNnJBj5PnpLTCHhPdX6KfhRCvTpIxRWg/m3HzRzXIkmmYXAVW7ss27aDoGeqovwHf7dDSvVv3KfJgHoNQTthd4O2Hvgajp0OozgGNpm0U9mfkny6eQJdWMroyNNoDKvmk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39840400004)(366004)(346002)(376002)(451199021)(6486002)(86362001)(41300700001)(4326008)(6916009)(6666004)(316002)(66476007)(66946007)(66556008)(7416002)(36756003)(5660300002)(186003)(2906002)(44832011)(6506007)(6512007)(2616005)(26005)(83380400001)(8676002)(54906003)(8936002)(478600001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YbhbfJijaH0f8ZFxHUYVxr6dUB4/Fg4rIYFho81AFMbIrcRT2ROvv9Wen3LD?=
 =?us-ascii?Q?gnm/FqhAHRvU/NHU8NELf5aAz1DNSkG5jt6dwS4RzeEhuOPInOln/wG0LWy0?=
 =?us-ascii?Q?CL9BHEpD+tjg5k2euFbmaJFkSBjSW2tpolSKuoLSu9C24PJtrnmGEXxjnC89?=
 =?us-ascii?Q?Qi3R7uxD4Xxj4wvQRC5PhZuuQKsY1kbfuUkm6mrX297KWf0OyWzxhZwzD5WK?=
 =?us-ascii?Q?PJvpmI9gyH9CIxSaBTSlS+qRHMx929EPpAqYaanuNYcr0BvHPMtTyCYUOkQg?=
 =?us-ascii?Q?wwzBkbpaq8E29B3H+LLTubPhWgSJO8M7FNZyuA23TpgmycZHWqDbieUj7dpf?=
 =?us-ascii?Q?idnF1j0hkzEHj0sxIw60G9lHPpC98P5MtZ5xlfGqTdsHXgdYJ9xPAvxIf69v?=
 =?us-ascii?Q?d2bM0E4kKdgweWPoRQGiH5pSlvdq5eTj0PEa9D1HN26aSfshVNWKUp30z0ft?=
 =?us-ascii?Q?tpof/4CvMGqbmXtEQwv3i/dFQgGqyI342y4ZXCz2Qs6smHFc0eEQ9ox+y2ul?=
 =?us-ascii?Q?4L+9Yrggr/KpHUH6oqfaSUKfRIjdJnKv4pbPEFiSg6qQ6CgYVnmC4X+h0SF4?=
 =?us-ascii?Q?1DvkuziMrSCc8L7uPzl5lWnR+28xLFgbhNAIDQn5JKr5dRpsWW+emb2h0ex+?=
 =?us-ascii?Q?wetoMPrIvH2y4i+HzDrELitMgSSY3HbaUPT6l19cEYwyCEhD1djgEi8N6aPq?=
 =?us-ascii?Q?A/9mILqZzWo8kFFkDg51zGxHTPHv0xXutUe1t5S5QQtcZqhviJra2YB5svxZ?=
 =?us-ascii?Q?IgnMvHL9tSbzB3P3y0ilKqbYp8D8rSE/rWICRHqnpDieyEBGUB1d8Pt76aBb?=
 =?us-ascii?Q?P5+jkL+pBObqR8pv2e0gSJHmI+V/5l/oRQNMbWx61oHCtvWyOApy6kIk7FBw?=
 =?us-ascii?Q?CKB4ASPTuOkcbKooKPvNLx9KC86wcuvD7dK2TSyt7Xk3JcMCO8ulD1y95pjJ?=
 =?us-ascii?Q?WhKD481Rc6bJ62PUpSH+h+dEvLqpafc9P7bAEAnw4vQAecmv1MlHskNiwBig?=
 =?us-ascii?Q?rcJHeETYXfh4CPDSsNI8PU6kEBF8kxGO1HQ4AS9imKKvSPxFlNXCMLNbuCtE?=
 =?us-ascii?Q?r7V55IiKGHzepVg51udJbY+J5pzfg8/edJS6uL4sz4xyB95zl34blAxsmZHB?=
 =?us-ascii?Q?QkknfP+32yR/RMrU+ZsGqTqx4ScOe6upcI9/UPllup+hHZ9G6kXAlSOG5f4V?=
 =?us-ascii?Q?0veE/JM2nsCPy03YaOxRCU2ZaWxTg4IF1uRlkLvgKUtaudYXuSwm2ScSGaaN?=
 =?us-ascii?Q?/oLbGhFGDsya1eU/0G60ZhwMjC6fs+WJoeMghNLtSr5QakJhYk7D83vDGanl?=
 =?us-ascii?Q?yoKFDKkKIik4DE0VCgw13lLpSlMsbvP0TczbIcrw41rLVPYggu6dlNI+5K3t?=
 =?us-ascii?Q?gakuddQy+a0QkdJAdW5eilBdrS0GjEL/SdxYYDPN58s4QXZ96q/BkWZEqlSo?=
 =?us-ascii?Q?oPih7vCtzp/xO/HVjB5cymQX6hyLDX+1JlC5UJceHOBYzWqJU6Eh2OkerLEH?=
 =?us-ascii?Q?nwGxFGCcintyYZtCp+3rlMLVx+6gvc8Za9BRV5bK5FwJlqswRZihwRfzp17x?=
 =?us-ascii?Q?+WD1+I5QaVICPxrx6RMvsX+uF4+K8BZsju0+FTkkA0hHKxwVMz+N8XaQU/gi?=
 =?us-ascii?Q?wQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 153d3ecb-3d36-4cd9-7199-08db62b89ea8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 15:55:27.9602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w0Fy7jOkKrcZRx3InXO+YqGk0Py/czLrLNki27DCPd49Z06MU27TxkoRMZaOzD4KEZMtgvdO5ltmcneLsxUzvaqJZ76xZX7xxyhrX6j0tgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5764
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+ Daniil Tatianin <d-tatianin@yandex-team.ru>, Andrew Lunn <andrew@lunn.ch>
  as per ./scripts/get_maintainer.pl --git-min-percent 25 net/ethtool/ioctl.c

On Wed, May 31, 2023 at 01:53:49PM -0700, Justin Chen wrote:
> The netlink version of set_wol checks for not supported wolopts and avoids
> setting wol when the correct wolopt is already set. If we do the same with
> the ioctl version then we can remove these checks from the driver layer.

Hi Justin,

Are you planning follow-up patches for the driver layer?

> Signed-off-by: Justin Chen <justin.chen@broadcom.com>
> ---
>  net/ethtool/ioctl.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 6bb778e10461..80f456f83db0 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -1436,15 +1436,25 @@ static int ethtool_get_wol(struct net_device *dev, char __user *useraddr)
>  
>  static int ethtool_set_wol(struct net_device *dev, char __user *useraddr)
>  {
> -	struct ethtool_wolinfo wol;
> +	struct ethtool_wolinfo wol, cur_wol;
>  	int ret;
>  
> -	if (!dev->ethtool_ops->set_wol)
> +	if (!dev->ethtool_ops->get_wol || !dev->ethtool_ops->set_wol)
>  		return -EOPNOTSUPP;

Are there cases where (in-tree) drivers provide set_wol byt not get_wol?
If so, does this break their set_wol support?

>  
> +	memset(&cur_wol, 0, sizeof(struct ethtool_wolinfo));
> +	cur_wol.cmd = ETHTOOL_GWOL;
> +	dev->ethtool_ops->get_wol(dev, &cur_wol);
> +
>  	if (copy_from_user(&wol, useraddr, sizeof(wol)))
>  		return -EFAULT;
>  
> +	if (wol.wolopts & ~cur_wol.supported)
> +		return -EOPNOTSUPP;
> +
> +	if (wol.wolopts == cur_wol.wolopts)
> +		return 0;
> +
>  	ret = dev->ethtool_ops->set_wol(dev, &wol);
>  	if (ret)
>  		return ret;

