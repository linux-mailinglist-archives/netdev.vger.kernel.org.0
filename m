Return-Path: <netdev+bounces-7147-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 953AB71EE8C
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 293CF1C20E93
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:18:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B9C4079C;
	Thu,  1 Jun 2023 16:18:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31D922D77
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:18:05 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2138.outbound.protection.outlook.com [40.107.92.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10FF133;
	Thu,  1 Jun 2023 09:18:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShB59jXHu8wFcUWgxE3eRIcPylw7R7ko2/2V3NGsRjRK1hdlwahXQTsfgiqODiqAJdQRBmwNq5pAAEpy6O1L5RvsdElOD/JcRuype/z49FHXU87Fu5t+fp6p56vc/BbuH6xA5DnWW4f5o0Ydhw7dVWth626dGOEQZqAZN99SUQXwZn5zQlxmtXmM/lNR2nW6/fu370Hr/H00KfmQ4zJ28vr1FguhTK7PtgVZk85xs0eUcwnNuXV9NVWXMSVNF+SS6oPzeasasOGozEAfpAhgkiIkFoIlK4VEXfi4yL+bnMcb9Ba0m9GrsF/JRbimFyXRm/MzSReNWujH/qw0lbSioA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X62EkVyOpQEqviz81dkN1ZqYgkuyrY/oeqiKAPfQR1c=;
 b=NVq6PJX82/ic1dr3mmT0sND0XbtF7xTDF0TYEWYqKmFGzZLsngEAzjn4ecsyriWt/MlTzEnB1vblOdBR+6AgrnG5Ezo4HnyE9FwHbiW7aQGXHinFA+XcUYrDPMv5bRnedXNngWfWBHIgmPAZwSqYML9dRHNyCEyAquAKZ3WPoJ5s+w7dGKBZsA9iubKFArWVxn0udYOGyvapm9XX3lCVkG+yMC4FHnTMtLtn6fDiBtqyeVVsdf5T7+2FkaIz27dhCtQdsI9P0R+NT2kNC5UiSAwCoYgiTlMRoH9F8MTpHfh88KiIVQKdQdh9V0/0kBnIF5mC+LFrazdyql5Qrc70uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X62EkVyOpQEqviz81dkN1ZqYgkuyrY/oeqiKAPfQR1c=;
 b=wGh2m4ffLXDzWghaKbpHSoM5Y+U5d+gQb6+TATe4EZSovJpFiG6wKb2p3sKqkIECm6iYXFguDL/oKr4vmrUnlJjmqjumd+X0rv2IYOZ7Pnq48PJDuJekZLRPIIvJWXqW53dguE9u5g1Adem7l3gJiEBqn25j2WQsfTpuEGm1lm0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO3PR13MB5783.namprd13.prod.outlook.com (2603:10b6:303:166::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 16:18:01 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 16:18:01 +0000
Date: Thu, 1 Jun 2023 18:17:54 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Kalle Valo <kvalo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next 4/4] atk10k: Don't opencode ath10k_pci_priv() in
 ath10k_ahb_priv()
Message-ID: <ZHjEsj7Pajx52iRZ@corigine.com>
References: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de>
 <20230601082556.2738446-5-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230601082556.2738446-5-u.kleine-koenig@pengutronix.de>
X-ClientProxiedBy: AM3PR05CA0085.eurprd05.prod.outlook.com
 (2603:10a6:207:1::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO3PR13MB5783:EE_
X-MS-Office365-Filtering-Correlation-Id: e28b28a5-cb44-4a4c-03d8-08db62bbc51d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hVhBIp/O2D7DdttAAS1LZMbfXDUizIVpTvWZLflnp34js2ffwiZEeBpdlZ66m+O+HXNOnb5rfkSw0fxKA6Yw8awjstqViV92s8rLKJVIyeeGOCJsgAdu594STxofW6Z10he5WYe90C37shA4tzPEFZdNnnqF5iPmq2paYRYPDxMI/KCXlhm63h+0bAmZd1ArZE/ERaFb6ONMsBZp+aEIvOZJ2gdi7OqTPpc6Deoqa/YMjqc/dMySwebXgLgpBa1mYf17iYlYdP1f+NfEPlHFCqEJTtbe7qVqtq+etWCQ+W3czIEV2zBu0brXJsq+lh4MNKWAAlHWH5JfLjLEdqpWO2LMmHIYXIBxquGvo32Gyr5OoYak67aoNeXIV3Wyf+z1XUU1areLHX0O++/eRFNZdvlw5ABk/hoD+810uLm2j6YW5jTp7/QwzObzo8fsUsgemZ9/Hjn8OfwkaO1EUl1SydrZUvY5ucdhSIGxs4kcz4iX/3jJIrgXIEbFcu5toDwhUHHVDLNP0f5gvrXNt051YJplOo0ZIKnUCAsJePtPTBjpqbBmH5MYqvUNSbozKGpl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(396003)(136003)(39840400004)(451199021)(7416002)(44832011)(186003)(2906002)(2616005)(6512007)(6506007)(5660300002)(478600001)(54906003)(8936002)(8676002)(26005)(38100700002)(4326008)(86362001)(41300700001)(6486002)(316002)(558084003)(66556008)(6666004)(36756003)(66946007)(66476007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Uk4xa1lTdlJ3T2l5MjF0eHQ0b1lWaWMvQWxMbjRraFliRXh2T0dJajZOYm9M?=
 =?utf-8?B?QUtuMi83N2dHU2IrbFVndmd3c2R6c2JLdlJ5ZmVFK29KTlNTbkg3ajdUdURJ?=
 =?utf-8?B?VktzMkkxbllGLzIvbUtVbEFuUkF6L2pNenA1R1VudTNVTWVvQU9yQzdFNHZW?=
 =?utf-8?B?N0k4L29QYXlOaUkzYitiVy9PcFRaUDFsMDZTSHNQWDM1dXFNcVBpTEE0TU5k?=
 =?utf-8?B?OTY4bDJXaVhlSC9KN2FYV0NPc3BGd1dUSitaZG5CeHZFVmxxMnpuOFUzVFVZ?=
 =?utf-8?B?WTFudmFMaGxYbGlrWThzTlpTSGVmVFNEem0wdTJiZERoditIN1lUK05tM2V1?=
 =?utf-8?B?S0ZybUpPWjBjRm9SYU55aFA1cm5aN3ZyTC9kTFRiUEwvSXZqaXhhUGF6c0xu?=
 =?utf-8?B?TTJqb2JHT2NkSTE4dFJoTkdtblB6bk1RQThuWStZY1cxRUlCMnpoV0VwM1J4?=
 =?utf-8?B?NWx3d0llZWJCVjdWdCtnYjBRZ2kwM0hMbXFnNDFaQmRLUXRybDRTdkxrbGpZ?=
 =?utf-8?B?SDFzd2hjdldoMmk3UWYxeU1aTTdJQXR4eGVvaXc2VjFJWW45VmphbHczUXR1?=
 =?utf-8?B?dmR0eEhYcTdzSEhoREYyQ1paMUJrS0gzNFVYbnNzWmFHRVJsU1lXYWRLa2FS?=
 =?utf-8?B?aHdmbTNVdXBHdHFvYlYvbGhadjNoejJVQjJTRnVzell5c1dxUkpVN3hYeWNI?=
 =?utf-8?B?amNHbWsyWFUrbXdMMmQ4N3o4N2NiTFREMlJrd0kyWE4wZGwwWURsU2dZRmRU?=
 =?utf-8?B?UmgwWFN6WXFWSGhHQUlVaVZCbGtRbnhxQ0hMTGhrYnNnd01jbElHYjI1dmFy?=
 =?utf-8?B?by9xY0RWQ1dRNGhteW4zSk1NZEh6Rm5EblY1RTRkOXYxM1Bvc25oQmw3bUFm?=
 =?utf-8?B?Y3UxUDJ5N0NLTVBSU3ZkZnVnMlJzbm12U2FDQzl4STBOT05LeWQ2RWlWWEZW?=
 =?utf-8?B?VHJ6NEcxRStVekFFaXJ1MnlUU3JTYlROWmh6eGJKMFlWYlFvdk5TNFVLaENn?=
 =?utf-8?B?RHN6WDdDckR0ZmVLZTBja3lpRlNpanFmYnp3TTZoQm1SUjVoSENXckZHWG1m?=
 =?utf-8?B?ZlFFcnJkcTJrV0dCTmFObFd4Y3U0VWFGNU96QjVJMDNrNkV5bEx3QUZraW1n?=
 =?utf-8?B?cEJuanF4VVR3aU02UmZ0QlZsZEx6NEhpQVZEZzBUSUIvaTQxSUdnOUd2Wnpv?=
 =?utf-8?B?Nk1mSWdYOG5tV0FHZGZNYmY4YmpVbmY1SThsLzBkdFU5ZmpMMERVV3R3N0Ja?=
 =?utf-8?B?Y1pTNTRhZm5jQUI3Ym9vRkF3ZnFqRWJIUlBDbGYzTXlXWUJ4b0Q0ZWJNVnZU?=
 =?utf-8?B?MURiMXEvNFVESThyU29RSVdUTm5JMERoYi9tSVZkSlluNHE4UTdoZGUyQ2RF?=
 =?utf-8?B?TlhQdXpCdEdFLzlpd0doWnBvSDlSM2xlb2EzM2hteDcwbndBMFV5NWQzZkJa?=
 =?utf-8?B?WnAwaitjRzFVL0RjNkdlbFE2Mm00dmRWUkNlMjJyN1k5dHY2T2JRazNSN3Ey?=
 =?utf-8?B?R0VrTGVkY1VlTGdqRzNEcE1WOUswUndUVTBLTUFnd1BSNHVPb0QvUWRxOUZu?=
 =?utf-8?B?MlE3WHFGaEErdnJHc1Jaek02emR5MXpqZ0RvOFJpQ1lUdTVVMkVrZHZJaUxN?=
 =?utf-8?B?aWN1OWRRdkg3NVZ1OCs0NkJhNUh3UjVaYTgvd082THRoSzFsc1Rlc1FVLzdF?=
 =?utf-8?B?b21iVnA3amFPVXQvQlQxZ0ZwWkZNVnRvKzNpVjNvaUo3Wlladm90WHorRTlq?=
 =?utf-8?B?NGR1TU92eWoxR3JBSjFlL21mRFVxVEVQRkV1OFUvNWM3NDJuR0ViSW5XSk9S?=
 =?utf-8?B?d0sxNk5JeDFUUjl6OVE4T3A4ZkF3WDQ5V01ZcUxpZnMzeE1VZ1pDQ2FFZWFr?=
 =?utf-8?B?QWpCN1VQZEEvZ3BVS00zbUxpUTczdVhKQXhOTTdhT2NVbnBwSlhjbEhpK05h?=
 =?utf-8?B?ekRINndJWlV0b3V1ZUhjN0tISmhLdTVzM0RwV0JTNitxTDBpa1lKTTltblRq?=
 =?utf-8?B?WVlRaDQ1enRrUlhjMkY2Y2M3amR6QUJ3dlNqRmV0dkxnU3JINEErcjhld0pN?=
 =?utf-8?B?N3RkRXNHVmtzaUY1T044cDU3TmluRC9oUkdjM2dqT0o4ejVHZDJta2daUU15?=
 =?utf-8?B?OTBBNjZDM0xqbDNvaWU0a0tGdHpIQkVHbWF3VkFGSTA0VFFjS3lVTXdoUlBv?=
 =?utf-8?B?Q2c9PQ==?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e28b28a5-cb44-4a4c-03d8-08db62bbc51d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 16:18:00.9596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QwCNOvTuWzB45eb+gRbHZuVlB8xjhzg+fxs9lWChBi/Mx7Uu80ALDnLu8vqjHqw/lpH3wGQCddjFrttBTCtIgkiR4JDat7jQxPK1clNrigs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO3PR13MB5783
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 10:25:56AM +0200, Uwe Kleine-König wrote:
> This introduces no changes in the compiled result (tested for an
> ARCH=arm allmodconfig build).
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


