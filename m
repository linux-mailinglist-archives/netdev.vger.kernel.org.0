Return-Path: <netdev+bounces-5591-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB3A571233C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:18:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 984DB1C20FFD
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:18:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA04510952;
	Fri, 26 May 2023 09:18:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A530F5255
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:18:42 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2103.outbound.protection.outlook.com [40.107.96.103])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5981A4
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:18:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoNDQOqby82tkil59ztpD+53WKQ6fdals/pzEN7xI+ws6XGkllI5q3lL+0UZSdCFyoFaqj3MZQbjXLT0Iw8nYbsr9rX13TA3RrUfOTUb+XXEU+ZRBMRPJRPgDqNrAtc8SixoH4NO+zR8B8wC+cKPqhLa40Lk6bOKkuXj++KT09D7UglKAKn99l0AA4mK9zF9TMGPiegAZJk6Ok3dkggBh/vPCA0C/nQMPqHn//nz5VHIjDaC1mGIXwBM7bK0ExM9By14wlRE4JSGyZu+dF30meKtxW8CVCBtG8uN1PfQ8uy9DKEqlRcWK/uyAoslhMc8qHppoEExtbNTQEbntHYbPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYmVtXPR9jfw7ODfPxDW/9u/ksW/Gwb+VzYNiuhKU88=;
 b=XgBMsX6LuPk9PeUWw65HX1RuTGGP1fgIuueHEEY9QzRLo0Q7H79NZS2Ylz0bj+iXcT2OMcnrRp++7eCW3mJPg6cnfOfkCJ0mPd6c/R2J19flgsS9zPKvKeglJuG5rByTEEEEQznfAiIqCDup+NvPESU3TFrvKXzgOVFrVogKTIDrl/a0yFS7yBdV2FALqRB1wkMqMY7HlRuOkOScLys41Mc5f584sCp/TzKO8kv+K2vwhX+HchqBPX6wvNU4B0ccwV7JYC/Fv8AREeALWYyQnViZttYSxjj6V+ek6Hhspl+E0at+apdan4Cuxfi3LFFZ1OhqAjFnWWHkwnOqduzh8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYmVtXPR9jfw7ODfPxDW/9u/ksW/Gwb+VzYNiuhKU88=;
 b=YaoSqTjVzQHebg/nWnBTNBP/ZfnBbuweVUCIxniVgrnk3evZqfZdGNUgV8RKnC9gfIxupbraVsXD/fXx4l/fo5UtzflmZKedIaE63pPkzT7Xz4AwNFwwLrCZZuQD/KZPwOU0bz2MqoS/e0N5i692TabK8vIVFi2VFJSpKaUh5Jg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4768.namprd13.prod.outlook.com (2603:10b6:5:3a6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Fri, 26 May
 2023 09:18:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 09:18:36 +0000
Date: Fri, 26 May 2023 11:18:29 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: dsa: add support for mac_prepare() and
 mac_finish() calls
Message-ID: <ZHB5ZZoSEnNv4G4E@corigine.com>
References: <ZG86ocZm4YmsWIJN@shell.armlinux.org.uk>
 <E1q28Mm-007tpp-UF@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1q28Mm-007tpp-UF@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AS4P191CA0050.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4768:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e99a42f-908b-417e-2735-08db5dca2f7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UiZO4Cz7QKbaYS2zdyVYKlGub7Poi8RcOPhLqJR36vAKOu+2SXbMU2H4oZ9uvRCJ4ijhUZ50KQYwDWP7PnAJA+qFd2KCg9pjTepOPep+bDm8eoO7WdMNMDz7FO/frAWD0tpz91eAiCuBgpxWOwxM9EFzfLrOU1TOMe8Ap0+1ags0wFB74xifgxpZ+EJYao7Ne68Wb3uqOzn3wAetliKwyho4ptghiDyrq5RxCQSS/0qG/nb4CNUWlshU2YkAixbSCWE5bz50bON1B34zVstyqQ4eW74ytPEV2IHvmDRiRWFnJ81fnH5Exg80/Jzr0fYLG9ig2rhyHlIx9KxWUdoQwNzD5kSESOTUZgReUZGKTkfpgSxfkX5oSAH5UHaiGYSWLdYkpwbBG3vBUib2HZcXrp+jaQbehvzS0UXC4KlLwj2GCmVkQzxKdN0J/hi3DnVeFJJFO2Birvjq4WqlHX6tgMah82OMMFuBaD/xxmDMlgnk/UDCzOYBEcNatBJQD8MNQI2gqQ4O2xt3/dSKjx8ta7fLxqrfuoo0tcLdYajfstTH6piw7WNrzHauuq0Un6Pc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39840400004)(366004)(136003)(346002)(376002)(451199021)(6666004)(478600001)(6486002)(2616005)(86362001)(186003)(38100700002)(6506007)(6512007)(36756003)(41300700001)(316002)(2906002)(5660300002)(7416002)(4744005)(44832011)(8676002)(8936002)(54906003)(66946007)(66476007)(66556008)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5hdXdz1V6XofpJjr/EYwrBDwP8b3qlMNaFY41u6efGNo4G72mD7TtcDcyAfb?=
 =?us-ascii?Q?KYp3WO/P3iQL3aAlIBCwzi0dhu3x1KysifpQdZss5L+3Gq8gNmIPIwDLHcBM?=
 =?us-ascii?Q?5ygaQERJDChJxhX70QnWY71bh6hEFUV9cjdVEQ6KB9UfurzY+5VGrqw6i79n?=
 =?us-ascii?Q?fzZbpDMovp2ilp9U1Nl+yq2SjKlw09BasssT3KMiQfLp1yRFla+3XkIn+Zw2?=
 =?us-ascii?Q?7x3jEYtEf297IWIIPLTh4Y6dp+hyQOsOTIpi1T/3D0CXIcJZl+VRQfB0W2mF?=
 =?us-ascii?Q?fbs1/sXjMrytmr5TqBsDEb9lFUmrUFEwkJlNiXsbtaiQ8WpWAcFR5+lxjoTn?=
 =?us-ascii?Q?v2yebPsBlqEpQZ4s9I2Y0C7FtwYPI27tIZ/vMdqWB2nlvPWVzIVEEnfGLFDb?=
 =?us-ascii?Q?ICcB9kuLLMp3zCv5p4Mfmlx0cGps0/LLOwFon0xbrk/owUkigb/i9YH0htu7?=
 =?us-ascii?Q?JJyixj8zePzg+7H7GHs92pG62G7CogtWR0FWcnXJSRwFvmkREESPifbA14ym?=
 =?us-ascii?Q?W6yDHnyAUpStFWcoQhlRaSTXf6Tg4nvMfIXy9q6HBqIyatYGjdbBBVaUObkk?=
 =?us-ascii?Q?Nb/PZENnwyBgXi6YSulQyXWeTAlaZsrb3hlPKaa5+TVy9dcbLCU8QN0pEFa4?=
 =?us-ascii?Q?Ys9vTAOCYpx49XFxb21vgV6roRx81FWMsl0e+1IG3DVq84y9WqfHeEYUc5iz?=
 =?us-ascii?Q?xlVxDOcrPTcmeWQ5wtHmWoENfnyEqOniPcbjhHj4R9c5F5t7EOXzGvFDdAaW?=
 =?us-ascii?Q?43Bc3vo7dAMj9O8JgdxpO8sAOtsL55Zdne693iIfuIiamFKxJaEHj1qEP3JB?=
 =?us-ascii?Q?suJZWbkZ70m4r4SDhFeVKYM3WSn8a301goL4tXOmexZC+8gK6nXPKFTX2wB0?=
 =?us-ascii?Q?HyHKtE6koroVezS2tzu2Nr/lU8+u0rIajRjk+4KsY1FKLlx+ZD22ktPRi3yB?=
 =?us-ascii?Q?AR/6KXgypsIwlbLftgUa/qiXKJv7ENQ7+zCSrb4FNkoRrytOWeCiRS3OSKu8?=
 =?us-ascii?Q?/n7tC09eXxtz/ayLlEtSNmzi4MEnrBTYulPbkDdUk8Oo3QuaPI1hF9v3x301?=
 =?us-ascii?Q?RrhHeOgOaHIIUOjunFp5wN8ZA5m/oTIBEkT1mTpJdk30ph44PUap31IwrU7/?=
 =?us-ascii?Q?QRQN1aPuNGN7Zb9e/EM65ZMY5rsBIqQNA3n/v6pwXnxPagpTeXeuWpKIYUZJ?=
 =?us-ascii?Q?GgsK1g3ffBqwv+ZYIyqNGIW0YUBKTzLX197E5mP0HFSUrjQ2FgDQ7f2IdTuc?=
 =?us-ascii?Q?CluxmXuw1UKsGKsqrK4iMW+AVLrk5HcmlJMcjuN5qiYYsbmG6bDvyP5deODi?=
 =?us-ascii?Q?fzZ1Y+2uX4Eod3VrTn27yunHY2FiDTgJ+kB0zGJ06PXBYeXe5V8A1vWnUVdH?=
 =?us-ascii?Q?YS3CeB31qpNPFNWmzV3X+gxFuy9DO0oDG8yZuMzWkuVp8cc38y5nY4hbTKGs?=
 =?us-ascii?Q?4SiwSZCl/lPe3AHswY2KxgECZpvvIGLUjzg0B9FLEwgTk10Y5fMkb+Q3CGQR?=
 =?us-ascii?Q?HmCc9AYDPbhR5n9rTa8HcUonsXD9+oIatvua2wNngjVLiEWIK1cUp1niZPiR?=
 =?us-ascii?Q?H1l8gTSc7Quw3MOucRWuVjswkf5/It/LJgoRlGUnb2E9xhTQ4VJffpFJOsLu?=
 =?us-ascii?Q?qMWM+d1SzFxNnbKalfdpXput12dl/tLY3DjapI7w4qLURt0E5r0lfbu0G2ey?=
 =?us-ascii?Q?rjRXPw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e99a42f-908b-417e-2735-08db5dca2f7f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 09:18:36.6147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUi3BFbipok5VnOHSt6wQ0vuwUro7/LY6lEhasN1hyQvHznEZ9xUlyXynEvotV0bDcNmPm545/1IHhQOESzQKjMpx50iAVq+GuOVh2Y4cgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4768
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 11:38:44AM +0100, Russell King (Oracle) wrote:
> Add DSA support for the phylink mac_prepare() and mac_finish() calls.
> These were introduced as part of the PCS support to allow MACs to
> perform preparatory steps prior to configuration, and finalisation
> steps after the MAC and PCS has been configured.
> 
> Introducing phylink_pcs support to the mv88e6xxx DSA driver needs some
> code moved out of its mac_config() stage into the mac_prepare() and
> mac_finish() stages, and this commit facilitates such code in DSA
> drivers.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


