Return-Path: <netdev+bounces-4918-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 698B870F2AD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 11:25:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FC17281257
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:25:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3B6C2F8;
	Wed, 24 May 2023 09:24:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5DEC2D9
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 09:24:24 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2116.outbound.protection.outlook.com [40.107.244.116])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F8C13E;
	Wed, 24 May 2023 02:23:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aEpH3aA/Os5MGK5qclO026O/HXFsIyAJCWeVyYsa2anftTRUGH2ZWR/iXqEWG/cn2cg05XYK4p54nwUJecpLEgDx7qxVn0nhMXSpJLRnyJ5bioPDeaHmBG2v+8SV6XsejWzFLgIEx+rUIzv/+Wc05rGA+TSfHjfnw6Kl4XFL5PzPT9l1GAHAwiR1TcCyou9MFtiXhgPBQMhKCmEf0uiSxxdkuR6XQUvjBs6/2XZLBwMsGpKRYN+/74uBOIJ+tafa1OGtv6H/IFdzSVupXbh/W5YBNKAXF40B9k2kmG8qDg2x0qRjlZ/D/p5mg3QJpnSKVqYAVnZ5Uo7hatLim0O+rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSL10cDHJ5rmEpVf59t8j+/PCydr0um2zycRstv5f/M=;
 b=Rib1ayI/N9+qoIWH3us27Rcomn2An3xj2mBPXkig7ei7cAfqWW3ymAPXLkuEb6PrN4lwiDshb4M+NISRLQsFKMLKVQyWKFpmO5Woe/1xbOGa7Ewm5Y0Ug+oaAnbowbmzVe8Bu3Exi0n9MhY2eM2TeNxbgnqRJo45jk/9catIu9+aACseQzV2wtdlXn80H+rr4IsLxKIdF/uJhrdb/ULSjd70vcwnWgCGYpMc+RxmiiCSocS0fxvY4Nnlk8Ob+Ufli8tN4ItN0PakMD5B3iq6DaWf5gg8vQnHTYk6vAloGdHubkWxeWFNk6kCLFos5MH6RTev4gmVXjNSCJ+ds1z4UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSL10cDHJ5rmEpVf59t8j+/PCydr0um2zycRstv5f/M=;
 b=NRNlphlyx7J06FuakBchOhhEpiR7x03jR7SdyZojb3Ol6XWf07NjLjGRSYd8gU+ILNvMfGmvLs35/NQOSaTobpfiyZ3uvWKbvkOwJ/y97z8GF9ai/QT3GFJ4dQuaxw7shfHq5gVIoerBlLu790YFkAn4e83yfGVa4aFWuhIK+Mg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4425.namprd13.prod.outlook.com (2603:10b6:610:6c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 09:23:46 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Wed, 24 May 2023
 09:23:46 +0000
Date: Wed, 24 May 2023 11:23:38 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	bcm-kernel-feedback-list@broadcom.com, justinpopo6@gmail.com,
	f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
	andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	richardcochran@gmail.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, conor@kernel.org,
	Florian Fainelli <florian.fainelli@broadcom.com>
Subject: Re: [PATCH net-next v4 1/6] dt-bindings: net: brcm,unimac-mdio: Add
 asp-v2.0
Message-ID: <ZG3XmqWdrSxrezlQ@corigine.com>
References: <1684878827-40672-1-git-send-email-justin.chen@broadcom.com>
 <1684878827-40672-2-git-send-email-justin.chen@broadcom.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1684878827-40672-2-git-send-email-justin.chen@broadcom.com>
X-ClientProxiedBy: AM9P193CA0008.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4425:EE_
X-MS-Office365-Filtering-Correlation-Id: ab6c6c65-43d1-4e16-6508-08db5c38933b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	y/fiC3MCfFVLMQPUO3BfLwCSWEthq4Rgybl3Xhf8fu8+yBaeFGB8Zxwdwkm/HpfdPgotwgdL1XF3DS1s1wQQVXCVxsz6foQ10eOvoMs/2Ft9lTAHrJOHvHRXmYhUWOT1xoR0wd4oZ2f8biO/PHB1yVc/QoVQlecg1jbOBQS7l8sT4/jm7UIToXjzJrBzueqp/qlYRKK0dUb1DdvSjHwedBuSC37zW10sGGqRFVO8utTKNnGcPEn9FBgS+Xrs2tjHcIEcLVkgyJqelwe+wUVeG3EURg8Ama+VLxb6N9l3Hm5gmhqxAw5DR8PMY72/g6E73Waj7RUGMWhUMCfc7WRRC1lFzVV/yXOKr57eH8N1hFJyPDdcanOFJeEerdBSYY6GIn2lKJErKk6Ukcnr/y8HYOHzSv0igIPVQYHDYtwKNgVbMLUZdDe/jL9Cawg95En4+Vn8h5+/pnI0FSi/BXCieAqZtV//kpC5qgtbR4AIsg/6qRolEv8GFF0hia8NMt9YIstnrqNJuwGKdmuDhFvR0dKmbkEFffTBpdboMXn46QzM5+SX6O9c6TuSCUSfzfNZmeNjlFbjwQMb53T1Xt0lYcNzuMt4wAIunFkNuHF5LTw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(346002)(376002)(39840400004)(451199021)(86362001)(6486002)(41300700001)(478600001)(6916009)(4326008)(66556008)(6666004)(316002)(66946007)(66476007)(5660300002)(8676002)(8936002)(4744005)(38100700002)(44832011)(7416002)(6512007)(186003)(2906002)(6506007)(2616005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l1iNDrty6nFYHBqW1qEB8iUq58zH0N4hd1KnlowWIFvhww2MSaMZy9QYL5dQ?=
 =?us-ascii?Q?GnLPxhpsJvqWIuZ5bTK/f5hgx2R7tbPOFM52kGOE1o12Hhgh5fH/9nhJojPu?=
 =?us-ascii?Q?qyfNoUMBiaWiBdkAdlc1S0cEMf48vW5b7n54AxxMO+7Lpxno51OC+MH4nPZF?=
 =?us-ascii?Q?xjVgoCo9eoixjzlTOto/0KdHP92KJKeL/ToRCWtWRdlQW8d/wSLqvVCQ8/F4?=
 =?us-ascii?Q?7c29E3TStllp/48HeVpMFzjRPtOT19n2wTQqjVIswUvOc1lRUBSvKtMJu7Th?=
 =?us-ascii?Q?LK//XHp16qMtHu/mEmcDVH891cWQd91HFhgiSIH6yYtkUb0PbaI+RU6CqlKd?=
 =?us-ascii?Q?F2g+mehAtoXWT1XK0mmAWoH1G9FhuGRgJdZCnU1ZX1xknVouQqXfG3qg+wpM?=
 =?us-ascii?Q?IKgyOfGGMUOLzoeysCN4mUOa/Ksdt7prPrNTFag94Y4byPN7i5I5lP26l8Kb?=
 =?us-ascii?Q?L4hb3McaMkSWJ6ER/A8Lz2vSKbgoRvHAbpw8MqRQ2svee7l60go7VlfNi84V?=
 =?us-ascii?Q?bJqjhTKba6Wlg9sjkMnwc4OagAj3fYzHtm7WimQ1FWu4eiIpljm6ks1Y+EYl?=
 =?us-ascii?Q?eSBpHX6GreKwAcEJxkhzoAJ6XSHeMCrhWehYli96Q508QdIE3FjHJUff5HKD?=
 =?us-ascii?Q?cA/Ckf/Z8BtTzMwrMKVk0zTXiwG9Rsu38yPoZIsnBO7eueDfY0auyuXOOx4o?=
 =?us-ascii?Q?KvyyQbfwHTcGs2sSD/7Tzbv/KKoslrUWzF66fhxxpgdD790z7xB3qCYsOqG+?=
 =?us-ascii?Q?z40TVsRJUq83DbsloOTV45sAroB0Q9opdo998OU2sWKAunWuSMw1moLiyR69?=
 =?us-ascii?Q?3TaShRP7p8JFnKO4MgF6+MSgRztmZaTGqwWm+8Tk3EOhTd4ryZr7AXUF1VwY?=
 =?us-ascii?Q?98SctYoLf+PW1DdYsx/hFIQseajmwpryQnxYUeVrqFwHbkNLJvmxRLUe3C6o?=
 =?us-ascii?Q?aERJimHYclSAfvhhMaOdi4I7Q/+2R3Cby1RcEaq3h7ke6lGAR5vPfSY+jae1?=
 =?us-ascii?Q?XvIFok84Syvj/kChGw92VSDNjj/vhh/YbItwMBX40B8kXHaNTDSVPAZ/8jQz?=
 =?us-ascii?Q?Myg24CjCQPh8OHHGATJtYQOzYLOSflFYKjBkc9Oh/0DpBhyRpsHrDO8z+dMQ?=
 =?us-ascii?Q?pAxffPofXT45xPAyG3DmTS6myEjFylPBAA6LNpWdZto9/l5un3plh2iB4d8g?=
 =?us-ascii?Q?KeUB7t2r5H3VhmgRH1loA7jqEsXjQLrZDXiYueXrudQgVrF/vmkZvk+RLvHI?=
 =?us-ascii?Q?Z4v5ieiF1mHoCkM+Zd/gw7ZLpWPBtNzRohcaT80gJn6YBtW52hqG0QEQp/p+?=
 =?us-ascii?Q?StWUBmXYGMnXcw8pYEZ7rdc/POsD0JjTBoQLLGPQgkB0q7F1fd6x7iF6I+Bp?=
 =?us-ascii?Q?LwHm/EHrTv6zPldhbNYKAiMG/0tXhTJg3Th0GaPyELqso2wO0ZuBPZxrYe6Q?=
 =?us-ascii?Q?1uTdjks9fGRh6AZ9p+R31UF+Edv7HYuHyg60ECkKL1u0dBqx4knpF69LP0V4?=
 =?us-ascii?Q?1Zi6I4Z2ejAcXSrwWsYSf4ej4rE7wWeCtwuPeUZTOA0URHlEM2vbvLOjLCYs?=
 =?us-ascii?Q?22t4PYFYX/BgTN6sIQQEiX7huARK/NdVGT/pbCWagkDeVufSpsuGVpkKayZH?=
 =?us-ascii?Q?zSEAEJCPaQ+dPy2W1ahsY+5DBofHzOLMlCIElLi1Qk9TkaJneqPZxWUu3LqT?=
 =?us-ascii?Q?xU3CYA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab6c6c65-43d1-4e16-6508-08db5c38933b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 09:23:46.2496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7raZiYVDuvJ57QO3pbffZAxnsBjeWd9snByl+a9UWIsSTiD0Oy1AiVufqcQNn7IC4SYJBsEs3B4pY6QVJHXOq7bnp+pp7/v7n1Xj3pKI+WI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4425
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 02:53:42PM -0700, Justin Chen wrote:
> The ASP 2.0 Ethernet controller uses a brcm unimac.
> 
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
> Signed-off-by: Justin Chen <justin.chen@broadcom.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>



