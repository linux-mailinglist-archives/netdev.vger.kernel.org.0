Return-Path: <netdev+bounces-8915-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18ED6726460
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7696C1C20DC3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5107E33C81;
	Wed,  7 Jun 2023 15:25:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC581ACB5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 15:25:22 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2099.outbound.protection.outlook.com [40.107.237.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B7F1FF3;
	Wed,  7 Jun 2023 08:25:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeTe5/6DQueW912Nr+ArufUlxGN+k7OfkkfXqRKitN1Tgvcum753tYJe4VRqvKjfxYyPRZPK+PqUVxtsMcDBuPJtyge4KVJ1P8nrY7mvGQrA3Ll1MslqHGXCAehLLn0C+68ascHT/UljJOk0m2LM483GXHvZjKPlPROKuvlYb1kooEemwkOfYCxoQBv0bD8tl3rXNQR51Y6pwen/urtl3ACeEdMC9ZxTE8hRYdsij1B3ThxpAlT29TQcE4yn1Y+lKksKoWu0qs9LPTKOq+4X0y3g9mCea7fxDzTk/7EViuUY1h6Fd+5F0RGJY3G9QRXP90MhLw9eIBwAU9+GjwIniw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aU2AwhRfP0ThvkP35v9KbDA7NQFQXNMW+M71mbEk968=;
 b=iXv9zuICMv8ApMiBGiH0CswCLnztBNcegmDN9kTgkPO0n/bKRRmdXoPXN6olAyydlv8juqiqL/4Vy+I627WHY6gPKHmhgRYKMQgOVXDbPWb1S6CZEsEv8scdYKjE/pnTj9iv9ip91OJI29J3ocVz5Bf0wt/we2zVrrCZV2c6qv5xeajdg0b8rs7FAlj97zE2qqFoaTfG+Cy0u/+Nqd6JIa7xdF0osRtTCyf8EHZZc09yE649s56VS3/AsvhE9vl4rZ1/DFyUUwAAsE2WqywKHg9ve/i/cHB6jgIXORQPoaBS3msYD8IiybuKy2hL1EXnm8FwGgYmxovXGxeO9LMwqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aU2AwhRfP0ThvkP35v9KbDA7NQFQXNMW+M71mbEk968=;
 b=kuhWriNK5Il54Yy9MWZtIUi0wDTdaXape/oABBaHqcPmBCEQhuifUfUSJzOzu+kOQwAPXTn4Un9j5qzCJ4rQ3Qn3iLU93V+wk+v8FxugyrqK57gzaXk/LXc8lGUwD5zCoAIpzWVv7HoUtMef2mEQCntpC9LJtn0w6TFdnmNv9uE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by SN4PR13MB5263.namprd13.prod.outlook.com (2603:10b6:806:1ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 15:24:04 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::9e79:5a11:b59:4e2e%7]) with mapi id 15.20.6455.037; Wed, 7 Jun 2023
 15:24:04 +0000
Date: Wed, 7 Jun 2023 17:23:57 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc: s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, maciej.fijalkowski@intel.com,
	netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] net: renesas: rswitch: Use hardware
 pause features
Message-ID: <ZIChDe2LHcP1Ux+O@corigine.com>
References: <20230607015641.1724057-1-yoshihiro.shimoda.uh@renesas.com>
 <20230607015641.1724057-3-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607015641.1724057-3-yoshihiro.shimoda.uh@renesas.com>
X-ClientProxiedBy: AS4P190CA0058.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::7) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY3PR13MB4834:EE_|SN4PR13MB5263:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ebec746-4113-4eaf-a748-08db676b3a6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vCIdceMhAUocVVTvERR27JBA032d36KT4RTGqxMnJrhSgpXPYr3hpubPuZ/nt8KwBv5OIqMhRwdXuAW3IGSGFtuk1k/SmPGWNENEzIv3R8koyhBPhcg0PRhZVAs3SQBcxtXyp7bJ8r8X2cK3jac0EzZ2NZpikbqlFARw5KDJ8+zf0InWwx9u0bbgF4M9BTb9lPh175EFBmJdVXCtiMwgFMtJ4YbSliaECjQut4W3tZyWkCIdOzgSXo1Cy1Xrsc2BaB/m7guFpPwsyFEpJMvIQRzRhpqAGKM/J1Vxe08wPzWm0JKg8NkI3M8Ce6loNS3i7cBXj6OsLtnwicH/MuBSYejWwfZ/ENWPas3c8XZQWrA9seSMSSejWEf8Trb1LUkv/uItgLG3k9/ff33KQ+Yt6s8Vxq3dukoWWyDYRDk+DWhC+v8lmldjg/zJ4pWpAA0IP/tyYQyHfDNbZ2hW4yoms8niJgCyyvPfsSjCHfr1ZkW8n9dVfbL/vLDtYcRqTKhCqknHmcDWM3NH80sveZ1+6GlHvdR0uScwFukSjUDEw6XnDp5STZp/Tl/63J8aMwVbmVAenrhin3gp/o8NDPXvGjb8Oi02zXCEZ6ocSWEOerhnSrW25DXc9XUl270AsbFhsJ8SdOSzWzcnfmMLNE5Sujzz0nMSGHWYROiD9ftQCVYL3vDeEh3DXGPRXVXIvbCl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(396003)(376002)(39830400003)(136003)(451199021)(66946007)(36756003)(8676002)(8936002)(5660300002)(66556008)(66476007)(4326008)(6666004)(6916009)(478600001)(316002)(41300700001)(6486002)(38100700002)(44832011)(6506007)(186003)(6512007)(83380400001)(2616005)(86362001)(2906002)(4744005)(76704002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D39ua5xbhRj+yNOaURtUDmYv0liT2/1VFOidzaSXBVdq7FBbkmrRJ0haMFDT?=
 =?us-ascii?Q?meygK/k2I0e49bhRn1kL8Omvq/cCaI6Jz6LkiNdXSVGcDqAxOP8BfSxD4/rX?=
 =?us-ascii?Q?90RMFc+a8E89oWTuOxby2kpxBbm3S5dWTQG7PQPy3GLAd8dU8Ptp37WvxThc?=
 =?us-ascii?Q?YzewVGR6hBs9PoVbeaJv4RtUy2gth7IRViYcAxlqr1tn5tYnOWizI+PWlROo?=
 =?us-ascii?Q?JEXhQU81CubKnRxSY5pbFmYHhZUQYy5uXzIAuWWwAd0YabLmlClUey/3fBIb?=
 =?us-ascii?Q?LA7kssxdW/9BbziJHMFuyi7BnMuy55vKcLDKPKvEnJTD52Ch6E4GIIhtifm/?=
 =?us-ascii?Q?PYBvCXRD1C9i0tE9KLPdxeF81cbxkRZh7vrR5TSG0D2VCrpMjWenideokLZR?=
 =?us-ascii?Q?tvy3r0cL7MjGyfjZzOXa6kKdNNLLeaGCQrtS7qBHCyOHIiOXkZPlnD5tGhv8?=
 =?us-ascii?Q?lAL9f1s8UoBBC9+ewk+oB54igjCn1gj9PODQblITWEoT36hGroKLvVgy2hPk?=
 =?us-ascii?Q?hZI8JKqmvg2aIeV1+Gwtlk9jJjaB0hFKVXi9WKchmLPgdOZJQJNI3gt8KFJQ?=
 =?us-ascii?Q?Ol73LoB2PDK66sMfljWgwQzXTXRaIt/A5L9Xkv+Dqz34kof6zbt/wLtnp/af?=
 =?us-ascii?Q?vdk5D0TyGnZmlEqUsDivMsKDB1jZ/xuXY+bh+HvKMWSUwLHux0of3eR+g/fP?=
 =?us-ascii?Q?cy+dkvYvvwmbK3FWOa5fHglbNaiT+GJ69gSxrSulseky0QxdWsGNRBOkKaSm?=
 =?us-ascii?Q?2RTfNqNHSSv8C0Lf/fZXjjG8vzKr/OG1vGXdXWx7dZzAgOjYomo+C0/oTiCJ?=
 =?us-ascii?Q?aOUC3iH7nmp6ZHcQQud0rbYt4iLAIhQwx1gT+umBoFi5y5vL3WtC+NJNZYCW?=
 =?us-ascii?Q?WdoWa3SU1oio4clT7QVGz8Mr/NZ8eALwE9WPuOdRz71Ty18Uu+su90V8DHOO?=
 =?us-ascii?Q?lANeRLCtZJhTZWgcPjLuTc3bJzWDzsp80AWzr5eUGaTyXgQ5M6PZZD7KBkjT?=
 =?us-ascii?Q?qsNnna92S0UXi3AHdDC2bsNpRwKzl9cSQ25scuSJdzintYfn1WM8zfEBlyuK?=
 =?us-ascii?Q?uP3p2dqA2c3ymQ0///l9mApmGM/vC7Byq4quc238wFT8d/gKjrY9QzSLyqtX?=
 =?us-ascii?Q?8XHqXadAwpdg4oFWhijLxgvAEA99EMZHYeSK/jKmrzsjHOu/Pe2ek8Fum+a7?=
 =?us-ascii?Q?hvlojtEEtnjlPyCSxeBcoNCgNy7WbuKd0CjWeyT4dG5GXg+3kBBPtqiJDS7W?=
 =?us-ascii?Q?VOPTi9OILxb7Oc2Da4Uj9Z5KAmWvsmHOGsE9lQoL0fxBr7ow1lB+l1DCmMSP?=
 =?us-ascii?Q?nbaRDwsHBHT3OFGx2bZotgi7nT8a+eNAIuwJwVUDruBLqRZtjncYh2FfGc9H?=
 =?us-ascii?Q?Hde+fvjnSknBus5Q89xiZ2rhF3QgSoZNYUL1rDTGtMIfPXBd6Tt+qtRHA7oH?=
 =?us-ascii?Q?48NPaFOWJRQckTiDHx1E757TEuc4xQm8PfOkh4HLwPmfG3EYBfKxlqRXqgx6?=
 =?us-ascii?Q?KIqwPDwQAJSNOb/rcPI2X5nPg6casVNF6rC/1RGPS0RScYN0U7OtaDaqEFlF?=
 =?us-ascii?Q?PrrKrPkNyqvo6/WBTQG4FUu7DQcCNoleHvjIWWzLrFkZVLU0q2wAImvSIrT8?=
 =?us-ascii?Q?Y5rMVPaSe4NFfthSiIslkY+GIi4pcFzE9JVIY/dJLlxgJnDXaNQzVxzz4S2f?=
 =?us-ascii?Q?W6n2ag=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ebec746-4113-4eaf-a748-08db676b3a6d
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 15:24:04.4562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FNICskJVepkomVWpoFroyzXAnmwj4Bbww6NWpyUjOWSOaIck5odSUmDcmeiJW9WJWtTxtNfhs/qiZX/B6JLuQWqiM5byQvLIF2hc41ln6L4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR13MB5263
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 10:56:41AM +0900, Yoshihiro Shimoda wrote:
> Since this driver used the "global rate limiter" feature of GWCA,
> the TX perfromance of each port was reduced when multiple ports

Hi Shimoda-san,

a very minor nit, in case you have to do a v4 for some other reason:

        perfromance -> performance

> transmitted frames simultaneously. To improve perfromance, remove

Here too.

> the use of the "global rate limiter" feature and use "hardware pause"
> features of the following:
>  - "per priority pause" of GWCA
>  - "global pause" of COMA
> 
> Note that these features are not related to the ethernet PAUSE frame.
> 
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

...

