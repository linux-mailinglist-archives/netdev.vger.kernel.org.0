Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5924B6D3900
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 18:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbjDBQle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 12:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjDBQld (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 12:41:33 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2094.outbound.protection.outlook.com [40.107.101.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC55CDF0
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 09:41:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoG+rbEz+V/+vPMaP+UDY4EalIAE1iR4YxnHUA7DFf6qjLvNrHArW5dFFKxuzB3apS0vmU9a15M4i+dlusf9j1BJcFev4Cs88uM1MvIfILjxH12Ic1XxeaApFAYCPrSJNaOYUyepHC3dSny5IbcKx3RFlch5V86kLYpT61KhnJTEma38iBc6VNLz0aps/aMw9dVjwvUuIgXU/d4oeIQWSuW9mUsDxQ7aI+OEoNd3KJA8IeINftE28+TRM37+eIdnnbNUxHFmsRku4iFzY432qlv2aejkw3O0+mt33hLz/51QoeXmK/D4UbLEn3rfKRFp2fyFidyJZAnpnpzQQmX1iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tq1Fg3BvWLJw/8/RQuCWp0YkgVZP7Mqi5qBZFTTftoc=;
 b=JWo+4DugS8jHEkQ90CSyfQp3bWYP4TsCMCgC4WNSSsD+jzhgXZBNx6mSWmb5dwXqQ9/HTEoprpg9ZXY8uf15m++dwVmGisPAOyHSGZqBFm28wZ887DKy+vxrPi1OWJD2vt4HYWokJ+W1qhBrwoQVK5bhd4HFDqOY3VsC4qlZAVA0YwUFobbTyWvusnvq2T9mqYqfOpLMLHLZcNCJBzxVGlFbZUmSNTFU1OrFOmV9Ex32odY8Nzk01vSTqnCUOaAXlIVSRj4Dk2w+PlKMhVAWmO3wBFzIXBkPnshgN3Ay2/FRzFiWp1d7HNcnAahlXClgTIESM8nP9N6MBZSo/bHkJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tq1Fg3BvWLJw/8/RQuCWp0YkgVZP7Mqi5qBZFTTftoc=;
 b=RJUoRH4oX4INavv3mX/ifeieV1LX8xCeKWweNW3GMXkGvbU/5nWuI6gcFbJaMPLPCeKAGRjhAPRaOhIcVRAoImMOu2Ucuw4K8xXrsxvZwD+sg49C0Wmc3swMBsnXCfsV5gpxogDtDxtwLXVWua8Tb0bvfQaIZqHvmWyi8oblRb4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4160.namprd13.prod.outlook.com (2603:10b6:806:93::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.30; Sun, 2 Apr
 2023 16:41:30 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.030; Sun, 2 Apr 2023
 16:41:29 +0000
Date:   Sun, 2 Apr 2023 18:41:24 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Healy <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 2/7] net: phy: smsc: add helper
 smsc_phy_config_edpd
Message-ID: <ZCmwNH68+xguWQ8v@corigine.com>
References: <d0e999eb-d148-a5c1-df03-9b4522b9f2fd@gmail.com>
 <27ad971b-929e-d292-a16e-c0c3371ca17b@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27ad971b-929e-d292-a16e-c0c3371ca17b@gmail.com>
X-ClientProxiedBy: AM0PR02CA0130.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::27) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4160:EE_
X-MS-Office365-Filtering-Correlation-Id: ad1379bf-f716-4acf-01f8-08db33991c15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YQuEwffFyPW+4HaJ0MUgHKO538QSmLfticZXa+GRHinx8NzLqsNpsAl0ChMVhGphma0DU3jzT2WGy1ZU9RP2eBh/ty2vs2K+jnO3og4DIYCP7T+v1E1MLk46NJ4ahcoApLzaQPXIG+O1LJN7zK4vAzFjp2lCWUxa0uhTnavgUkRL+6Pxz4uOxuvQHgxcBGqgAb+hFYjYrboaPwSxdPO7sF9qyQrDS0riECmA8EFGBrz6hD+5Oy/WjMsSlVPvcFIksQyJj0TfzlA0YUYHmY6qt1esIr9DdIJaaYB9AXW9imJfbIye0pADzSaepS2G4Kvfnsfob6pwcvHatQyDfnx4+5TMk6IfatzN1a8rCzNJSzMqtN3rGqND7vSGZuOVzkV05XlFG1WWR4MgTbuHvILQPzNedFNQ5LwKhIf7IkS0mqDDRwLVJbuOnUWuOoN3Fwvmn/W6NGJUGz7hdPwsh5ZXH4GHVXJSpjLHE5D+O65MjlZ2KJUZMhqrw5ShFL77i9w8p9acvOZkxk6WTUeYX4hu60EN5vey95fCbCo4FtGJvCFEF21B14Cj5rx2a2Lk15IWjemaOnuPBeR8jslWhbDFgKTbQnyQwCqyDia/zMw7S/gjp1jKeApAEizRHS8fXkTDLHRi/qxYuWrBUaWCQf2UGrV5z/1wEDJYrr7Y5IeKBlk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(346002)(396003)(376002)(39830400003)(451199021)(4326008)(6916009)(8676002)(66556008)(66476007)(66946007)(478600001)(316002)(54906003)(8936002)(4744005)(44832011)(5660300002)(41300700001)(38100700002)(186003)(2616005)(6486002)(6666004)(6512007)(6506007)(86362001)(36756003)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cnCr+zMKdH5jkzpwQ0VTQNL9szTTUgfG/sLki1jBjCxK1gt7jcSLWxZsb1ip?=
 =?us-ascii?Q?xougf1i1XHLwbPP9p7hObqSFjbBOXtIRWOUufPMpuM72yfkEBJyLQYsGAE/L?=
 =?us-ascii?Q?wHiPlQkL4LLgi8mJk3vObfrAFcLNBrlP9TuuEeb530Q7tgh+nqWDtfyoJ//c?=
 =?us-ascii?Q?/d1hofsyLYWAc+O+Y7p7P+VWsmBcJ4cabABpQMHuA283B0pUmlTDr2tiTEr/?=
 =?us-ascii?Q?iDFZpNISLdJ5b7yLOUsSRPWsfyb2UvpWNR7jrrUIEiSunGxBiWFOKBhjgUiY?=
 =?us-ascii?Q?4ymFAiB9DRq/4l7/eo/ku0FHMgHaWSTzZ/QnEWeb0dTCrPZoYc+dGSyS2GjY?=
 =?us-ascii?Q?L1TeWRm2uirb5BZ8eeo874CE3KpCNfxhHGBNyoU3zs/P+noARjoiDFNXpws9?=
 =?us-ascii?Q?VFfQCWKPtmQzC7g9nYla4i4qKTQRBFNz2nu3EB+GmSyZYdCJWF4fnEDB0BIL?=
 =?us-ascii?Q?C5E7CKYBJhjqYv7yteOrP02wf4V3Ws5HfGDMFc4fs2KmYorVKLCSOhKOsmr7?=
 =?us-ascii?Q?qaXbtlgs2+KmDQOiwfrtYQqFHJ7Z0ysdE2KKnMu0U6YRxOBGvMsDW6WPP+aq?=
 =?us-ascii?Q?W8gbWMmMTf7n3AGBZqrSNF0vNiQSsKL5GyekOFZ36sEQzbZsi/kX8lQvZv2n?=
 =?us-ascii?Q?vyJKYhS8+g/VNIAxAKOo2OLY9bI/iIfaRJ2ew83JaCz5G9U479PbuXThUQW3?=
 =?us-ascii?Q?MWg8n4wBDkqbBUMsuiMpvU5hicDktMwzP0eXYoj4dRiRCSammVKsJ254szAZ?=
 =?us-ascii?Q?aWoL1ey0WOnE/9ZZSiEd/znXV/Nz5xmXIGx0y8o8TKGoIGWylVfeqvlmc246?=
 =?us-ascii?Q?KJ8ZsaR3jyqwiXoma3cAiSmXcCtJhDfX1P9pNKW/aCiSNVFIC6s/kUUMPmhP?=
 =?us-ascii?Q?dVvhEebOUlpDoaWaTkNbwVTBt1eMvYl0a+nRF2dcV8qs3W9k/oBUPjRIeTXU?=
 =?us-ascii?Q?M5DxCwOcA+fl7VLWMBEx+lJjuzrOSaCNVL0yV8VBZAL/icaw+UH5oOxHMpl0?=
 =?us-ascii?Q?xtk+shVcoVqcRP6ffGvDzbGSQanlkOlKe98T7jkAE2Z189g1z9fBQez/LvVD?=
 =?us-ascii?Q?tgVdhIjBDYoFExio8045Jszb3Vkq5fwzmqouFVmm7NaMYlg3m2O8DQDsANub?=
 =?us-ascii?Q?Cg0mi+ti5wHzNeLkcv1xAcPN3oV37uBVwEbGghLMiEHS4FcL2npFdwlbM+K5?=
 =?us-ascii?Q?thftFteSe/QWe0YzwRWwQpnKgH0HvgdTB4ZTiomfVTMNal4kFYsRt2fWZH/3?=
 =?us-ascii?Q?DBqzf+yi9OFYeSPu9Ix8ZBUd27/ERiRUJr7GaZe5SYnAwDD4FYrDbRNd1eJ5?=
 =?us-ascii?Q?0RQ2/pNQunxOP+bpusVQKk9Rh+5uuqB4K8INPah8gXjuPHCmifCYYDRbSxAp?=
 =?us-ascii?Q?xrLAiKKrBDLlOC/Rb+PpToLFiSmyW0HVVnH+ejY0k4MaYlSGfTNFzJeozRB1?=
 =?us-ascii?Q?s8r9fD427vxZtGZoms5JtuhUb2IyM0okhjILfixgvf0GZrAKMt8k5BLfpTKe?=
 =?us-ascii?Q?2D4eacqO4GOV+IDk7aDOD4zQHB/g2QFBj+K82F3fXuYVDKElYNXGoVcbZXMM?=
 =?us-ascii?Q?n/nsjzTsCGXpBRIyIIJxZLBXKSycgGjrv7QuqcUbYm6jF7J/hmAFi/o4iFwl?=
 =?us-ascii?Q?1afZz6diKKlBZUMS3peIhuq5jGEeo/Bw18RIYEC/Iu9UoK1YMnYwqV3UxWbc?=
 =?us-ascii?Q?nG3fSw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1379bf-f716-4acf-01f8-08db33991c15
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2023 16:41:29.8802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l0sav2yYONNW/qWeZYFTThm0IVVDCOCYqjS+PzqwkqbmuAZRHEprQ9SVJB9o+InVx6gzkePGNU1Y4gcXF+9G2sjInmuMczHe5muaV7KuDXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4160
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 02, 2023 at 05:12:20PM +0200, Heiner Kallweit wrote:
> Add helper smsc_phy_config_edpd() and explicitly clear bit
> MII_LAN83C185_EDPWRDOWN is edpd_enable isn't set.
> Boot loader may have left whatever value.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

