Return-Path: <netdev+bounces-9311-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 000D972868B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:45:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5485D28166D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 951071DCCA;
	Thu,  8 Jun 2023 17:45:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820EF10973
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:45:32 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2095.outbound.protection.outlook.com [40.107.243.95])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8F82D42;
	Thu,  8 Jun 2023 10:45:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm20NTzM7KvA9rDnBof17wbDLKc2BEQ7uFD0IAIKb3KMzmx4wIogaVkmQrCpHR6PvrLsFu1xgMOrZbPjZW/FwyUEo8pc9k7EOLJ8fVVk7W+ay3TwQT60/fzuY1GFKJlhWEe2Q4AmmsVY0s7hZUdaJxEh40yR8dIEQTonikQg4G17YSPqqr12W9vTvqCFYJC6vFuHyGIRCQ3oQYBrZscvb0nzdqIh8IufyTKGtdDAZd5V82rVFwGHrwnAZmtQijThTeJDlq2+fldWSIoUnA5Igv9SQ4Pjuzpaz09MKomc7NuxYU6sv0OtwdvSxm7G17X7EHK+jF/fHCN2v6jU4piM+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YlCQ8aRKcjWKW5BdLJSLMCKDAIDBzq0DD6M/twJ1ay4=;
 b=n4TAjfsqIFTpXkFqPA/v4POXmOPdP+z691pGFOIVj/Zp/K6oSozYS7/tcmZlj44remVYH5vxb9WTaAVVTd+zzDbRzn0IWz20emZIZ7NXQNRnjQJQOlBdJWkw1+yvIIZmuV+YeyeOBac0loq739Vyd+R+YmJ18fF6LHFRYIRxDTiu7aQKPLZZGD2+gyGnUFL/B6bZcwHK8YuIIi+jM3gVfET7NyDIMvh90FXEzYtztWksspGhALUzMubQFswx2Xz9jF9QqpTddilF2hMGSR7JD9B2brkYudqC9ucO9w7qzcfC9a5BI2kqa35Tkv8sWXJctSfnSAMLufl5E1tFBWgryA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YlCQ8aRKcjWKW5BdLJSLMCKDAIDBzq0DD6M/twJ1ay4=;
 b=vfGNv0pHDERZwj+jx9880DmhVM5B12ErT3UTIk3xZJWA7xI1rQfYbgju/trcschD1naqmjGcONWGAMyKQwZBN2XwcTtYkIKhEq7LA6JT5uf+nHLOrEUTZIWiWYvPWLvycfFKofUHPtxizMqqmwOCDzIobWuyqZFn89VvOKdNO8A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6365.namprd13.prod.outlook.com (2603:10b6:510:2f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Thu, 8 Jun
 2023 17:45:24 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 17:45:24 +0000
Date: Thu, 8 Jun 2023 19:45:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org, Horatiu.Vultur@microchip.com,
	Allan.Nielsen@microchip.com, UNGLinuxDriver@microchip.com,
	Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net 2/2] net: phylink: use USXGMII control-word format to
 parse Q-USGMII word
Message-ID: <ZIITrPpnQB2rQNUr@corigine.com>
References: <20230608163415.511762-1-maxime.chevallier@bootlin.com>
 <20230608163415.511762-4-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608163415.511762-4-maxime.chevallier@bootlin.com>
X-ClientProxiedBy: AM9P193CA0018.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6365:EE_
X-MS-Office365-Filtering-Correlation-Id: b98410ae-c19b-4039-04a4-08db684822dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nGPAox+yaHOBTAGo0Q4Qvjhz3Yjyr4ZhrfOE7mJEg+WHdhT2HUGxeOz560LhXYV1iJWE+T/Xmx4xZCxpgOxakESGPXe90BltcTEESVaXEuzckwT8wpNjwR77W54/KAj61rwfNFKqnM55DhjH0Y7mhqA8+JnQ4EHFk0xEg31c/WBrHNaFiPdcmWfThNgydDl3AAnBM6C5NWzUa0A0gcNr4w80w7UEew1V8B14XWCkrnZqPHvjurrulyf7GX6Aacbnb2WVBnuLOcbQFTDCbBQKdSC42ca/1uCtYlyAMRy+p/KExz+2xuW2eD4IVGIt+9BqSxqZ4a0fJ540Q+t8jE2xlrVezImMk7T4cxxqCO729YajcOKowX3+v8aclgGaWFfw2qjcIF6cLAMu2KzV1FD7aNTuivBXWiu2ojzYT6RDTIpTAYTvZXidEvE/D/4zaSkgAEvGBZvLs78FpiJnGpHNAtARyToN7le+mhVYV1KLJ8bfMlxCkTjEWEWpl5OoFUn/HFOprwXaiGsRpuF4Ig7BxUgGI7jek/FD38IlKd/rkV+ZwyMGRk8Flzn8gdyf/uBM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39840400004)(136003)(396003)(366004)(376002)(451199021)(5660300002)(44832011)(7416002)(316002)(4326008)(6916009)(66946007)(66476007)(66556008)(8936002)(8676002)(38100700002)(41300700001)(86362001)(36756003)(2906002)(2616005)(6512007)(6506007)(6666004)(6486002)(186003)(83380400001)(54906003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ijE7iVRZs4HHcyhJ4sPR8wcXDQtiY04gID9bPgVWyqCrxIly/HFA+TKOltSB?=
 =?us-ascii?Q?5vExkdf9ilnhv/uOeASTXghq3qnabeAlGgT7UinrVntiwd1+U0bUWwczZ9OK?=
 =?us-ascii?Q?YPJiaBKRTW2vTqo5ifUxb10Z78sDVHh1mHDA9Uee3rSoUUB47nvdkIbgWauY?=
 =?us-ascii?Q?aIMvrvfLIhn3gFGE94bcUNx6jd4WnL9oVwythV6fX/wyhTlZ0yQ3YbIKtmH9?=
 =?us-ascii?Q?KOIZ/OEobbIV4tVqqGkieWDAKkpVR7XsFUBiaSG/8TiFVLybiWAtpfGWwqD1?=
 =?us-ascii?Q?tpMcRi/XfOrYabftlrC8GLwiAg62GZHMCCGRstZMnNP8Uh+RESJBVl64mecX?=
 =?us-ascii?Q?JX3hm4GhwvKHQlfAnpF13L1frBtqslpp8aWLqzNDm/9m/iTIE5sZxZoyhU3Q?=
 =?us-ascii?Q?OAWTmDn50nhBXo4ytHADX5pUBNGPIp8bw+jneWPPBde/2LDhkuPyaEGdYKoW?=
 =?us-ascii?Q?WOY6G3IV1dyqgKwQztUmoQN1ERsVeLDQlLc50R8HY7Udo1MOd6EFLVwPPpAp?=
 =?us-ascii?Q?riITX2+wn1EPLSzXOSP6X1QXEjEbyrT+H8LQqkNs9XPu7if9mCLGcPzS1PFr?=
 =?us-ascii?Q?/gmZYY/S+wawQWyBHNaKrYEsOIH/Eiv0GQE5cepwXRtCsZsBHenwsFXyqFvh?=
 =?us-ascii?Q?3Dx0UvTHtRdUTqLgHeaEUST9GyzwPFp8xYbVD+6NvWnsfMJAL641L0700M7I?=
 =?us-ascii?Q?ibNAd6oWfpct3B897DSiIh7HFWyoRj0/QgygMzHgJGLzrRQa5OWntsIpM7IW?=
 =?us-ascii?Q?SmooiORz2XnXpciYP2xzeWL7PE2ALh2tPdoXEWzpnYuFiLUFhq65p+OWTjVo?=
 =?us-ascii?Q?flEX+ezy2Ln6rp0/VcMKJ5n/KV+7/koN1p2/6KpsUokvxgqoWINkAEeQ4qnE?=
 =?us-ascii?Q?niKUTQtWdoyseapNKTINJ8XwNnh+jF0BKMMnznupuUVhaBNZT55iYS3ij41x?=
 =?us-ascii?Q?A/FBADFlaZainYKX7C6hTdURufvq6OHb76uFmxXuubc50hQV/Ek12aYVYw5o?=
 =?us-ascii?Q?SV5aVJk61kc4Nt5hmOsMdvhi8n594FPMm4+MLBorupgQZMXDcsqfweaPDtXn?=
 =?us-ascii?Q?zeqmLTjBdFvmm33u7mMCxz1madu92FkGQaxhpDonxgjWTS3VxbD5Qv3gY8P3?=
 =?us-ascii?Q?ndcnXbKk5Om3p40zkIJCY0CABoXPgVlVyLgO7c9bJdefm9lF3VZ4fu4teUQu?=
 =?us-ascii?Q?IeriNOQOnzgH1knvY4VvT+Xa9UJXPjErrAklwJ3nLSGaXEdlB5+M0mkf0/5M?=
 =?us-ascii?Q?VyWs0K4NZlPF79Y8+64M+QuK6uZnyroB93cG5/QaR3HVGII4CPRpARodsSGA?=
 =?us-ascii?Q?1PsHXzXjpQkqb6EHXUHnoVVGEK6gNp69WTP5lBt3CJlx35l8ZrD/D6GrnvMX?=
 =?us-ascii?Q?FrsYDG2QbOCnE6nz5Tpdhs3d2dHWBSYmacvYeix+7IR8zolpd1Fwp86GEcBX?=
 =?us-ascii?Q?CLClm5nCRWxVpThWBfREZ+sP2FQse4CfRIm9SgpCOBSYohtq6OBuEp7vslbL?=
 =?us-ascii?Q?RyOP3JbytJdpEc+c4nOx9a/X3VfmblnrY7Q6USoNEd83SSvNtX1LZvp/sZ/2?=
 =?us-ascii?Q?LnTJaDtlTjF8azrooWt+sVD4ygHzHrTYxhN+5tF2jHFpIC0bgJdIH7EAY6X+?=
 =?us-ascii?Q?vQo0CWW59alV7Lz2uH0vbZHGWfpgJbhk7p7babdexbOdQFwWDmVU0y8YDu6I?=
 =?us-ascii?Q?bJz03A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b98410ae-c19b-4039-04a4-08db684822dc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 17:45:24.2271
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osaehbduf2yXjwhy9GP6vQrcFtjQr7ww6w5BIfcvqulN0NrwsWE7bH9HfYdHk4T9yOQZgCBz/Hj7ZKUbuqrzdIB+AD4bllGIY5mkZtXA76Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6365
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 06:34:15PM +0200, Maxime Chevallier wrote:

...

> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 809e6d5216dc..730f8860d2a6 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -3298,6 +3298,41 @@ void phylink_decode_usxgmii_word(struct phylink_link_state *state,
>  }
>  EXPORT_SYMBOL_GPL(phylink_decode_usxgmii_word);
>  
> +/**
> + * phylink_decode_usgmii_word() - decode the USGMII word from a MAC PCS
> + * @state: a pointer to a struct phylink_link_state.
> + * @lpa: a 16 bit value which stores the USGMII auto-negotiation word
> + *
> + * Helper for MAC PCS supporting the USGMII protocol and the auto-negotiation
> + * code word.  Decode the USGMII code word and populate the corresponding fields
> + * (speed, duplex) into the phylink_link_state structure. The structure for this
> + * word is the same as the USXGMII word, expect it only supports speeds up to
> + * 1Gbps.
> + */
> +static void phylink_decode_usgmii_word(struct phylink_link_state *state,
> +				 uint16_t lpa)

Hi Maxime,

a minor nit from my side: the indentation of the line above should line up
with the inside of the opening parentheses on the previous line.

static void phylink_decode_usgmii_word(struct phylink_link_state *state,
				       uint16_t lpa)

...

As I see there is feedback from Russell, of a more substantial nature,
and it looks will be a v2, I'll mark this as changes requested in patchwork.

pw-bot: cr

