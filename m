Return-Path: <netdev+bounces-9178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13295727C5D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 22FC21C20FAE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:09:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2591CBA39;
	Thu,  8 Jun 2023 10:09:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19644A93C
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:09:53 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2093.outbound.protection.outlook.com [40.107.220.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C191FE6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:09:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzSWongRQHiXsqOj66uU43m5czdSrOsqUZ/UlYbinOEpsGqL2Eq8R5XoaAd1ZNFA8W3cnc6YIIeLOZR+4bLDWqN0m4REE272+QSDgWQMzwokfYdhvLJFjLcUGmArq2g9pTU+ve72hRzaSraEOFIjqmtit8fgbopE5UluOvIHQ6GX8EIucBuP5d7fcYysdZk3TdqXkH0cAgpqBgS3s7VyVcUuborJFLrv47ba3DPLC7uYbd4/cBZg3L3fFPC/3sSEazWQru+VqWzuoUontk1j5bMwH4Y28lGr7ue4chQZC4VYNB9dJD72jTH6fv/GtQm4/8oIqYfiVIvnyztM5/p9nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoKx1cdWTF8P2C93ti7RspQgt6DGpK7b5yZxJoWUPdk=;
 b=Te69n9AUAfpFs4SkkagkLSMqchLBiP5K0MEp/jPsSQsLwy/lD3eBvEw2WzkH7D7Tz+iHFkek1HHjexBHFjVKVaO5DfOPYPZ/D3WANi72Pgs87Om6c25zVKgRAzJHU6Oz3aN9dzsmzbyVV6mENd79ZSbtXXdosbFV58aBfe6RT6gYOspexAxAGqpDG4i131EQOHZ0OOw+keoQ98ygDXhQ/fgDXn3ofxsyghXpoWEtQNeAh7rlbNEvp4aC4h25yIrx3R9E3R4SMKztMBL4tYr/Wl5kWGRPv+N5/6dosBLKJX2x2W4uf+mETwoi0med6oIWsjzRChlsPFLfbdRMiSJy0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoKx1cdWTF8P2C93ti7RspQgt6DGpK7b5yZxJoWUPdk=;
 b=Hni0neVJ//L3yHtuwUpQVg1AjlgaymUYf2VEqRPRhII5FEW2BHlhikDB+sl+Z5y4YIqKnxe2xWfREsw+mbh2u1+pAXpnHIRaRhA+WGHsTjtlcRjMeVcWS6vr25FTc0Hmx008aZe+Xy9W/TeyjUifpsDW+p3NXWk397F1n+EBeXQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB4152.namprd13.prod.outlook.com (2603:10b6:208:26c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.37; Thu, 8 Jun
 2023 10:09:47 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 10:09:47 +0000
Date: Thu, 8 Jun 2023 12:09:41 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Petr Machata <petrm@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
	Vladimir Nikishkin <vladimir@nikishkin.pw>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next] mlxsw: spectrum_nve_vxlan: Fix unsupported flag
 regression
Message-ID: <ZIGo5ahrbZjLQbpJ@corigine.com>
References: <5533e63643bf719bbe286fef60f749c9cad35005.1686139716.git.petrm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5533e63643bf719bbe286fef60f749c9cad35005.1686139716.git.petrm@nvidia.com>
X-ClientProxiedBy: AM8P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::17) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB4152:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a343065-e7e7-4ba2-fce9-08db68087d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6xHeP+fs5q1ToOSO8JM/OC455hkzBUiujPlvKB40ZISuHX0/+LGVitz5RuBu4pcKqE0VNnp/3bCPDfuM8P9KLUojUxZgbEzeSZqch8vNhpGjejs3S5fRCnqsYohHr3bzv+vhVwo1MYSg52DPU9D/D95K43q3lQg4916dehteu9bOETpZC9xpWc+ULGezuMKXOjXWyruZJ5JX7Y1uDWIq13lhJmFbiODCGYtQofzUH2jpOiMTtzbMivN4ti1h7hUtbHg4bQSQX7UF8r4lmuwgvPK3j2MYfllCfI5wuhDbcbKl7ZyFWIo7Jx6xfaNqwt7pRuonHdiaOkLxOs/lZnCGLvYhPx17mmpj+Qll9Nxtoxu1celgvwPrERPz/VCIQ2A7gry1dgovH7//gDgRjanI3jxyrlpDnKM9Wgw1V9BrMnQeZYK5NOzQfOfTPdVvbA3JVGO26W12yzRJnxxftvFoslRwwi9Gqc/B7prk7pVsGlr1DwRDES1liT5kpusHtu94qJo5YGt33RhcYmPyzEFwnUkGkxvxaciwiCL5oc71+PjfeHLjRfXcvfax7pX6wJtQ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(39840400004)(136003)(376002)(451199021)(6512007)(186003)(6506007)(41300700001)(5660300002)(36756003)(44832011)(4326008)(66476007)(66556008)(6666004)(66946007)(8676002)(8936002)(83380400001)(2616005)(478600001)(54906003)(2906002)(86362001)(4744005)(6916009)(6486002)(316002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1g+iL3zmjAUUfgWXlP7uVf/8LWv6ZxOHj15pC7zIDSE97bPxj7ojIe5GBC4i?=
 =?us-ascii?Q?KwR5W9WlkxnPiuq6uOdnTrAQBUSy4ZYSdg1FJfay7N31CizHWkRG6fscE3Dp?=
 =?us-ascii?Q?CwvYpD2MFFJtcPPS4XokLtb5giLIaHIDmkyBB3346WmVn9MrjoxuWE3Oy5zU?=
 =?us-ascii?Q?TDDH9WCWcVbnC+nCn+5iYdUkF4D8wakjvGUjf3Fd3l+095ndZZ2AxB0dFN3/?=
 =?us-ascii?Q?0H06Yh18bnquyKaGml4NjKvJ55M/iF0HGR5FFkhNMGBdTTV8hGzsBS5yfwFK?=
 =?us-ascii?Q?RykLJg2pIgegHZU0Fm66TPegFeDmoJA1ma6R8b5RrPxRbgaFqW1Lac7dMrsp?=
 =?us-ascii?Q?iOhdM/WFbtG2Pzu81Daad8VY6OqX4B2MmEFshCx31i9kp+eTwduxnmIfKhWy?=
 =?us-ascii?Q?59D07HK7Uxo0K32OL/ewPmOIKMP35CU96KQIb4FPgtm7oNBCNl4e9qfjXuwl?=
 =?us-ascii?Q?4tvzjTAMShqCqO7ltWt05+RbdxYyu3YJhmg9qKfw/cV9G1TfTfVXuFlarXac?=
 =?us-ascii?Q?Hf6jlmdqcW6cTtDL7Hpe+EuHzh7TtxhNWfi63ydoT9NEtsYtMj+uFyDhh7yS?=
 =?us-ascii?Q?5jyweE9eSIF3XK42H2oOsdXTgGb9q+0DjrlQhdPn4n3NCvRPb5Kqj9T9S55i?=
 =?us-ascii?Q?H0i2jDoPmaLY/48GVlMR+Yo0M5IgokKksqRd38zY0qEaiW4vFGh4MwX+zSph?=
 =?us-ascii?Q?Gv0nmEHQ/7YY0/TGKWKFKZdoyO7zkeDi6WYo+agqHWz0RJMtBD+ztKz0j3wQ?=
 =?us-ascii?Q?C1lxywsLqaX4ibXeMIHGQERifzlYVXBRCvyE2Ev5RaUSJcU4fE3FP4pQzmMB?=
 =?us-ascii?Q?qSH8OqEEmo8xK1A4npAh5iir42MhRQVnCjPotPnV62Y3xiPuRTZonsd64Ql3?=
 =?us-ascii?Q?JaZzpbz2JwoG79lgwzVJwYdJydPHx54YwzuIPkCewfqcnGtmKR6H8wbKVxlK?=
 =?us-ascii?Q?IEK5N3HimdrlgOZWklCUIn6DA3VbbsL6cZtqzgyWXXicmTgrvCVcXyWBwh5d?=
 =?us-ascii?Q?8o75mt/qytA1qd0zOCKAxVavxhhls8+4PIgPOzf5Ua5tU+dYI+CZ5ujdygoL?=
 =?us-ascii?Q?zlop1GEGR9kEUHV+zgi4ief7lEXZZaEYz9L/SsnGWK2I2BWcOf/tnfite3Qk?=
 =?us-ascii?Q?ATPiyjK0F5cjYDauanCStI1RKurHPnP8PVhw3M+6uFRAzaDABm/NfV6ZJWlZ?=
 =?us-ascii?Q?ba8hVV5LQdUpk2Hksoyf+6A2xF/VbFYF4b2HpPQAnQ5/9fxzCNfOJJOciKGu?=
 =?us-ascii?Q?OeEoU5i3j9BozO8j3sNXoo6eBk06fyf7gNhHvs/Qywp86+S4X2hkfSYBaIls?=
 =?us-ascii?Q?hLgiYhFRdDCaeS7IpzDTgeOuVIR08aAEl7bn0I2+DxANYiGrkdXxOGOHQTNP?=
 =?us-ascii?Q?Mbsorf7H0LRTSs1uZuRTlaRMl2pVn7wxyWV80sH4Fh9WWjFEiBf/ptw7Emls?=
 =?us-ascii?Q?rniFFT1DNitHu36yXAmieuWskvBs+8abxpUyHxNpeM/mk6Ijk2wxfZpcFrF5?=
 =?us-ascii?Q?OaUpS/y7k+3KjybEmcyOaf5UNmH3RaI5F4oMCwJ5NfbWG1HFqrTOxb0uCjvi?=
 =?us-ascii?Q?W/5EFBOK1xU6S+K3xOJZneayOJ2/lfG5Z5KaxciutNFTQ+rzyNQcJI1stKIQ?=
 =?us-ascii?Q?vXTrzWQUFcr3N4htyns6d6Sdh4mqiujVa6Mme9ArGlLaIpRuRynNn3wmFWd0?=
 =?us-ascii?Q?Qsk3/Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a343065-e7e7-4ba2-fce9-08db68087d12
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 10:09:47.1544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1PkBcaKgSZMLSWe2ceDVH9koizoeSDiY/TEB+2c04dVbWBAYGOUg/+OKtvEcPlSUNZgdBXzulONp7bdVN5thAhc7UYjT3maneWwznGIYw/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB4152
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 02:19:26PM +0200, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The recently added 'VXLAN_F_LOCALBYPASS' flag is set by default on VXLAN
> devices and denotes a behavior that is irrelevant for the hardware data
> path. Add it to the lists of IPv4 and IPv6 supported flags to avoid
> rejecting offload of VXLAN devices which have this flag set.
> 
> Fixes: 69474a8a5837 ("net: vxlan: Add nolocalbypass option to vxlan.")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


