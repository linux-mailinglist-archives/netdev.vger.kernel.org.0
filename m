Return-Path: <netdev+bounces-9554-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 28980729C04
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:52:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D751D281925
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 13:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04A2E1774B;
	Fri,  9 Jun 2023 13:52:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC61B747F
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:52:41 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2114.outbound.protection.outlook.com [40.107.93.114])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9023A84
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 06:52:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BENEVtDzKYtbMce0I2dYTY8WVszv9tcovoCmbPkHZpd/1CT581k/BnEPFap5Oz7qRAxLZfVNPl6ShTjgaZFxAWcXzth0+fQ9JSbSjaAim046IKDqBQvdkty2YC3PbzQ4pF0aiaQIELX7ROb1eMSPZhcqhHfkSAadl8utDVuB4GqsOyB37xYemdgPLt5YFetHV8h4aBC5euhO7SntrMZSjDBrholtkzoakGwt41aiZyN1E+HoJmWuqBxEifB42904T4lRfxAP3B5GtO9n5+rQanRW1pkEWSWe+bynYtryeZNwjonLg8pHfpS7YtzbZPR8xwW52sxcxt1gLs+jqSIibw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=va7puN03NP5Z+aIkG46xNlMisglbbVC6uOx4hbKAn+c=;
 b=ArWYv6AlpyAkhWqUgbdkmdmgB1VYY3vIqhrjCHtWhFuP8E47/ZRsk+Af0XKuFn29xGtQ6t1g7S0JtL9/GRp6oG3i+fiJzIMFEqI9s1K+dI8KS3YYaW/O/S91jEKrjN+oUUoQazJ/YTBggAp09rRLusJzPBAqEZgLppQXELkNZJuDwgpBXQBwpWMbMXrFMwqB30BzWlnhR2hkJWReOaAOo8XJtJVx7QyABK8A79J9vm9vJEvFyZt/W4yRKjWl47wk87NYohVoGVa+z/Bg7C/dLTRlHjQAw0QEH/C9gLlRu5MctokH3IJCfTPq+IkdD0tR+Zi70BHzP3EWga9RMb26xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=va7puN03NP5Z+aIkG46xNlMisglbbVC6uOx4hbKAn+c=;
 b=oTg6QhNhugv0SfkbAKxpVv2v7nA8BbflPIFSNP3Z2WL/fhZuqRI3cQzJkhafT3yN2ZidSiHD0p1b/a6q7THO+g+ej78UUq8HPUqsAGcDBsOzl0isolA9cQBvHHD7g9tnxgG2gjCMLhTzJ3KYygX0b98cRCj6eiit5j6W7N66Cbs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3724.namprd13.prod.outlook.com (2603:10b6:5:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Fri, 9 Jun
 2023 13:52:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 13:52:28 +0000
Date: Fri, 9 Jun 2023 15:52:20 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Marcin Wojtas <mw@semihalf.com>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH RFC net-next 1/4] net: add helpers for EEE configuration
Message-ID: <ZIMulJhSQWc7SFEv@corigine.com>
References: <ZILsqV0gkSMMdinU@shell.armlinux.org.uk>
 <E1q7Y9M-00DI8a-CV@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q7Y9M-00DI8a-CV@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AM4PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:205:1::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3724:EE_
X-MS-Office365-Filtering-Correlation-Id: 39a7614b-c329-4cc7-5ed5-08db68f0c358
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YdLsu/DEDUEITmoDGxyVoQFyR4TFSltegII8KU3DV/YY2MPBsOBPJ35W168yjTxYG5qWKzSA+aIwJ59i7aLFC5FuBpwEOvmqWiVD7pxbLbjLO9leA5TCi2HMOn39ugxOJJHWm9DegpkEhosjYRA2VF1qtXQFzrKvgzLM0eqIg7ppDzxRUN212PI1ozfSbLkq60Ten+BVg18RmATzWpVL9SGe1tLRRS9CzKSRMl/9cVhF5x2AiLCPRkdHBmQE+XmGJ6BQk/Q1lxqXXsQFDPPqxIb2t2+M4h8Aejh/rS2ak/RFnqiYiB1+jWZlVPjeR76x1sOLcFbjl6GHtOiiNSoTMxg95xLSGrdriUHgLy6UgyePn6jTa/q8jIlfBA4ucWW/InnCuh838J98DVAEagFaE9ccbGorY2k0HcPrOQIvMqFqXsXxNbbV2EqWnQXhpdvxEMjQN9XsJS1PL/DX0hW/UtK6cGc0SODHPJ60DzS/Xw9+5Fmm2067zfVuOBB3jIUdRhJE8rGQxt5aTjanr0QiB+sJeLeLDpW8GIFdZejXDTWxCjSw8LExkZGWp1x84OMO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(396003)(366004)(39840400004)(376002)(451199021)(54906003)(36756003)(2906002)(86362001)(478600001)(44832011)(7416002)(5660300002)(8676002)(8936002)(66946007)(66556008)(4326008)(66476007)(38100700002)(41300700001)(316002)(6512007)(6506007)(2616005)(186003)(6666004)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TeOwSGPTZWNxEhDbF7oNBtiTsoWpFhHrgKFWt3Bhw0Efl9wkbAv7uLTcr+eh?=
 =?us-ascii?Q?NjGDUf74Kt3t5Tz8pnVXj5Qo5xsuImk3cXXYuiEFS9ratfqr+CjqqAFqFxev?=
 =?us-ascii?Q?UJQLHEY2ez5pyD43/XaixpYtkZMirj1d72E4BZWNOnogRcRO+teZo1Iu5Htu?=
 =?us-ascii?Q?OizkAGwxRF7VF5YlDnT+Q/j+9ZZhDYNvTWDqRJyH63NePtjd8pKXCFMZ9AAo?=
 =?us-ascii?Q?O72gt3Yi38MPXhjiCx7ZHztMzCVLZUigIIjWLmBFs+7yPhr9AZspkxQpLKLM?=
 =?us-ascii?Q?iYLMCoN6nOwem7F07oUbQzpnt7310kfgC6W3lah7zxXo9oWK3tI6KUFwtHUx?=
 =?us-ascii?Q?u6DieCGjVqcEm7ZCqBJUSH+Oep/ogGanGcazQpNDFOWsgePn/V3s7jnKFuVJ?=
 =?us-ascii?Q?xaHIhy+zFbf5ykYhfcUNRZ2LjnCVoL4A+9yLwoGniqfYcpbKyOMglS/HnJOs?=
 =?us-ascii?Q?o5Qns4K91s4dIsGDVBP0uPzJaO1TBKKShtcnpVu4h7AymQaBlvM010KsW0I6?=
 =?us-ascii?Q?GHl0yGmE0dQ6Nyoq7i94UtifZt5vcFWoKnoNcMFmXGXFhy9PFxtqaXDAs8vM?=
 =?us-ascii?Q?PCgSE1uKRK+/hcYJUPOKJ2SidsvEgX/+NFJi8J7t93jQ76Ya1ZvWB0xaT9II?=
 =?us-ascii?Q?7ss6+YNWzMi1zOJEjsHHbJj33lqymfljY4WeAkdtpVXBp4dSyIZzTanvHUT1?=
 =?us-ascii?Q?MdzY+rKxy72HIRu47KkPN5XKT4GgCu3QyXZwt8hHMJigiWxWrw5r4qj18evG?=
 =?us-ascii?Q?sX8TKBod9naH3jqWOowMDghFtdJKpIBE9aX8Uy5mrPwGCdWkEjgt6P1TmIHP?=
 =?us-ascii?Q?IX0/0uguFikFlwE4Pqi/9cldJTsaZiMIRiAP3Fw81lSzPhh5yYDJxPZpxcwU?=
 =?us-ascii?Q?Ct7+OXn4ZIJRoklTRsvr/LQjN0IIuY/KPUu71aixkN84i9R9GJZxMg6x1S8a?=
 =?us-ascii?Q?xBzXe4Amy1ltI7E4P1/gSjD4PYkEC+udTRqIySwq07VkN5wUkCoXP90Iowqi?=
 =?us-ascii?Q?UR2z6hvRXctHIDsZ4ihUpNaodm91gfVnUrMbxbHE3+6XQOTA047imOUJvyb5?=
 =?us-ascii?Q?tzI14+cHSWGOwfT8LbmRRmGm3lTiulqaBqJZluq50mPvq+MtoZ3QdfsIikoD?=
 =?us-ascii?Q?NKyBhO6ZLyMYnuQ2M765700P+oU+1ugdRPzKodo3q9Ww/Rsd/XbDHaZFQgF4?=
 =?us-ascii?Q?B53tciqUK7cuhJw0jE+Y5vXXZ8N1lkKjOLc0zhA8jC6SzeCIOBYJKzdLS7jH?=
 =?us-ascii?Q?P08G3hH32CncdUgcnWL6bVaC8T4JPS7oRlHuFVWwRQC/usetYIQmsiJbVBfN?=
 =?us-ascii?Q?Htuj65TERBmVP5hpnAlwT5ZzmRTOKxglCRVQedXdL8jZUbbpij9F15E6DRww?=
 =?us-ascii?Q?8+hQcxTSFZZxxnNxmn5sVGjxFdh58wUc21L78ZibtuTgpVuXtsfRLrXgRoW8?=
 =?us-ascii?Q?FKM8T/blKrU1CUFo5qAuea+R3aylv00r4TJNtlpftZAyRSIQTkhPlXJklzsE?=
 =?us-ascii?Q?9dBjoDG3Q6OClnwvwsrA0suEq3jzNc8Ljaxg72GXi93nU+7hOszS5EMUR5NG?=
 =?us-ascii?Q?pNdBWhVRB4GwgMxutHkHSJULn2Kw+Xpmlo1/P6Rt75lJNi4UGGYAPuzk9Poq?=
 =?us-ascii?Q?ddettp1iTzzZ7ZZHa/lNZgAWnzCBfHoRmWlLaYAXSOUmxmgnLRHfiIk4qqO1?=
 =?us-ascii?Q?WtgnWw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a7614b-c329-4cc7-5ed5-08db68f0c358
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 13:52:28.4508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/7DE0ZP3nvZoebZdmr57e3FoKtKfAPjkoHxzGhZ7WI/8buRRT6MZsNXX9IVFrK142pmWpzLY0mtx7rj05WUaa8xVUGzN1yCOnVYTdBEWPc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3724
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 09, 2023 at 10:11:16AM +0100, Russell King (Oracle) wrote:
> Add helpers that phylib and phylink can use to manage EEE configuration
> and determine whether the MAC should be permitted to use LPI based on
> that configuration.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  include/net/eee.h | 38 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 include/net/eee.h
> 
> diff --git a/include/net/eee.h b/include/net/eee.h
> new file mode 100644
> index 000000000000..d353b79ae79f
> --- /dev/null
> +++ b/include/net/eee.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +#ifndef _EEE_H
> +#define _EEE_H
> +
> +#include <linux/types.h>
> +
> +struct eee_config {
> +	u32 tx_lpi_timer;
> +	bool tx_lpi_enabled;
> +	bool eee_enabled;
> +};
> +
> +static inline bool eeecfg_mac_can_tx_lpi(const struct eee_config *eeecfg)
> +{
> +	/* eee_enabled is the master on/off */
> +	if (!eeecfg->eee_enabled || !eeecfg->tx_lpi_enabled)
> +		return false;
> +
> +	return true;
> +}
> +
> +static inline void eeecfg_to_eee(const struct eee_config *eeecfg,
> +			  struct ethtool_eee *eee)

Hi Russell,

a minor nit from my side: the indentation of the line above is a bit off.

> +{
> +	eee->tx_lpi_timer = eeecfg->tx_lpi_timer;
> +	eee->tx_lpi_enabled = eeecfg->tx_lpi_enabled;
> +	eee->eee_enabled = eeecfg->eee_enabled;
> +}
> +
> +static inline void eee_to_eeecfg(const struct ethtool_eee *eee,
> +				 struct eee_config *eeecfg)
> +{
> +	eeecfg->tx_lpi_timer = eee->tx_lpi_timer;
> +	eeecfg->tx_lpi_enabled = eee->tx_lpi_enabled;
> +	eeecfg->eee_enabled = eee->eee_enabled;
> +}
> +
> +#endif
> -- 
> 2.30.2
> 
> 

