Return-Path: <netdev+bounces-3260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D096E706426
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C893B1C20DE2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 09:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 223F011CAF;
	Wed, 17 May 2023 09:29:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8685249
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 09:29:27 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2126.outbound.protection.outlook.com [40.107.94.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EABE255A9;
	Wed, 17 May 2023 02:29:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTVEj83yGaxxZoqAOsSkuH5nmayZjBnEQHUZ8LhM3IJhKDP2uTblPcpcu25mjXAgAKXfvyTHTM7jgta0lnZKJk3jSfIVh5x9u952qKK9ywtmxpYTDrgbfS9qr87gnJrQyrlChbOyesn4ynvUiHhWBMEx1IBZ6f+5RYL7r1s85h2A+bYDAuUsuDeMBwjS1K0ieWov60WIjjSDH4Fk3m78ULHjw114Q2xpEl98bpDb0M6u4lDNiIC4y5gNH8A8XGTA1VmLM3GMp1uF5X1PspSlcNl2jCTYoH1dkq3d4QHHbABMdH6mZqhqXkwQi1M4dBDs3Oyu/DzO2zgV/xTo+3Ud+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pNwUFcnYRt7e6W2yAeCzksT/E92MClYfgw9om7Vu7Ew=;
 b=SlwvasPPVCKcOA3xB2FE8e4fa1ehiZAVZJdPBEltjJxQpQGq2j9mShm4EQKRMR4gwORRXrZlzAKTlhzNO8aPae/+wQ/nPkwLUueoCgo6Pbcl9X+4QpHSfYsIClVorXGNkeVCWk0vf/4So+AAxUSwuV+oNpHjuZMFvuExoWTuBkLd/AIS8MHQs+zkci0G7ZvCBMShr4WuY2XjD7atsfLK+rfS6sa9xCjmVtHCraiI35q18t8Hq/ETVH4EmDBa7IkO7z043+HZwNBoL29kQBlEiX2RzJcJvg82JoBiQvTPMp3I8+YZUgww+sIkotWkwqerJiSckf5bS7loE+SonDCREg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pNwUFcnYRt7e6W2yAeCzksT/E92MClYfgw9om7Vu7Ew=;
 b=ToMOonDpASFRsGlBMKbVk+UJGKO5WhqeJ0NAMxUFqOs8b9SaMabq5Y33b7j0Wj4NH+YAAY++mGw75powBA/DZW5IkJbvc3mbaZ02PO8icb7LfW09H0yN9UeUwKFImdYM7lUcoSJbZEtTecfDQEXa0QuS2gB7S1Z3uQ6ZcTwHcZs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV3PR13MB6359.namprd13.prod.outlook.com (2603:10b6:408:19e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Wed, 17 May
 2023 09:29:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.033; Wed, 17 May 2023
 09:29:19 +0000
Date: Wed, 17 May 2023 11:29:12 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, marcel@holtmann.org, johan.hedberg@gmail.com,
	luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH net] MAINTAINERS: skip CCing netdev for Bluetooth patches
Message-ID: <ZGSeaLMRsi8abq+B@corigine.com>
References: <20230517014253.1233333-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517014253.1233333-1-kuba@kernel.org>
X-ClientProxiedBy: AM4P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV3PR13MB6359:EE_
X-MS-Office365-Filtering-Correlation-Id: dff9425c-bd4b-4109-2611-08db56b930a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	d8K2G4x8Te+mGSfOy7GUMQYvJKTdhdd5VPSsP18BsL6SHnZa27OHAQfux8gT7nkGZrXiCYhIZVzRfyiug38ypffP9/aWkHgwVxNuL4HvjbyMLhV7UxUesvgooWIN/erq9QAeEXmx1VL/ESWT8ZxTxoa8SafD/CznepNtI4TGRhTP9IW26ScnT2nMQWnaZi7mKzSgKLuGPoj90DvXkHn1+3BZ0gvX8ysagBCMxpW6S8EPyTnllrxCKMwCAkbKhhpQGsz0dteIrphpbJGZI6dp0nyAcpVhaEDb8b+KM11GP8IlWrKJNGfkRjG11CtFYmKhafpCIbHK+ay+jYKKJPTvzKcu0GbNoRRJAIMYdDko5TGWnEUA9nmxIDXuKrcs8lvGBppL0dPZ5nhEjWvyDGnsKDi7yFTdS35vEvrqKL+N6fnZLKcGPAUFP1Dru/vu9UbPzH0wZp3GRVmetrQ3w9TVp6rgyeGOQxCUKgfgDrc8RGgjQtkEEdrvR0q+p1BwBKq0Sms1JUMVeeNcTvAoXTYWD8G9MLCt6dRe3pyG0ct3vCVFDvNkPzPK8FlwdqPcEZVLBtKsJp1kg2j8XprAHmMCRajnnwtNnTTdZBS6AwdAGQ8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(366004)(39840400004)(376002)(346002)(451199021)(86362001)(36756003)(66946007)(66556008)(66476007)(6916009)(4326008)(316002)(966005)(478600001)(6486002)(6666004)(8936002)(8676002)(5660300002)(41300700001)(4744005)(2906002)(44832011)(38100700002)(2616005)(6506007)(6512007)(186003)(83380400001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TiYWTMlLP4SAqZtUP4F/5UL70Oh9iyTA9f8HKJNTeaf4br5/nj4X60utaJsQ?=
 =?us-ascii?Q?2rzi2pcl1y2gZRgEEQ6mqPvEku2fJSzjjzgReGnwwXoyjfsWBCfDal0ZOGfd?=
 =?us-ascii?Q?v1pXU0D+XQNnxNqRRTSlNP1xDde8FV59TjM+Gj8C4VRaoMK6LJ8MepT3k829?=
 =?us-ascii?Q?qarhGJStwRPSMYbTugSrnFc4DNjp7t9PAXxkuaHx6YbehDxkmlh9jdBOeJJF?=
 =?us-ascii?Q?w0MDzuZPsEwEyQDKKRHejNGG/yh3cB7Rse9TfuVMM6LnIGlzLskZBLi30hTN?=
 =?us-ascii?Q?Cfio2xGdv0EXNRjAic/r2xKgNHd8N4S6U0J6vnm071ksPxKhFtfTg1UJxApG?=
 =?us-ascii?Q?KmE88pHHPCYXcUW1NBNmalXAzNwAZfk2hZlYJFTW2KJKCHnIpWLN40FnimF1?=
 =?us-ascii?Q?dL7tH7xaCXziD2b6tF3Hr/OknFyM+Q1vaJ2VqcIYCF6n9IjTmbk79iTSV7Dp?=
 =?us-ascii?Q?aAbtX77QKnmKOzebl+DG7lFzXUNM2wlju9MRw339k0md8Yxcd8O3QBZc1xCW?=
 =?us-ascii?Q?YpFheOdsXnRTMHDydCvfuIFXZshDAe8Y8RzUKeUtW0bNJ2YDevyxS3HLmzKx?=
 =?us-ascii?Q?pAETxIrA+R9R7i6PoSDKIzJNsM7lVgiSJ2bmbzgVa01avo3ciz4ocbJo+oE1?=
 =?us-ascii?Q?d70aTG0OYfBYcd8y79Bz2Xg6CiuHmaJamhvbVFqAPVpbRNDVRyDYF665Da5p?=
 =?us-ascii?Q?W9sA8bp4Mo0GuwX+oAYCCu7aE9juOYnV0C1WqazpS4h0QR2CFYJB5gICQ5pg?=
 =?us-ascii?Q?jGBbcQoI7O7QE+V9JuG6PkpCX6POTKmOZilHPftyVmsaBGFOXtfnjo+iPKL9?=
 =?us-ascii?Q?FpyCzU9T6RCYrTESFPkYQVV/+F0IjJHj2vMI13zhbqI1brQqDLYAHhNYRnwj?=
 =?us-ascii?Q?W39PDUmJnlMY6/CQ1sLZNW/l/gIVHKhZRg80mUiHvtZGRgrS8SZexHEKORQK?=
 =?us-ascii?Q?3xXhJqvDy9bInA1PziYSqYJHIqgNf2IC8R3NbjfJYdPxBeSva6rmYrIUSEIS?=
 =?us-ascii?Q?tdD98/gbCiPFdGXnI5oXHHzIgDTisOiXzNg/UCPMg850kJh26E/5sM2juu6u?=
 =?us-ascii?Q?bH31AkiidbbTqwireM6SyvD5RYdTbHRpVlnhEnpFD4pkMq1/e0grcu8VFIiU?=
 =?us-ascii?Q?ydY3/34u7rtCFCVYetM0IbtamPKdAwP4RzSF13oNKjD4Lfh0SyR931R05vks?=
 =?us-ascii?Q?MD1mJMnFS9BjyHdrDwEzIQfKaJcjWMMM1z3oiBmuoNi22aYs70lfEVnZM6f6?=
 =?us-ascii?Q?V4PhdqnxFzYrAQDtwu8nVAdrGrcHJzW7obnL9P14hoTEd9c+QkQEEi3E85dF?=
 =?us-ascii?Q?YgtmEoNR7dC4K54bZgyLLKiPVz2AqqlVN9UOJm6mL3fG6AnHdLCS/Kq+/pn4?=
 =?us-ascii?Q?GpRKImSOUt6X3mNI8o4Uc34eNYt86YkPSSNLXaTCUHWmyYKHVy6LFdhurMhW?=
 =?us-ascii?Q?ZUBhFA4dywmKDeBKmUCng9lja1kmfvmCpWgMi4rBGIU83BmsXLkDGSTppomZ?=
 =?us-ascii?Q?e7twbrbPugX50q6g5+BkEWcDPLRJYbRjQcPg3x4tJkWGVMBY1I033OxpZJKY?=
 =?us-ascii?Q?kDgB3ewXVwdvFDoSVI7FV+4xyNPl3AY0Znh0ZLaTEJfc6RDlQkZkDbvKQqYx?=
 =?us-ascii?Q?r4wR6+4IYrbFQjxHX48DRIrpHL062YW/67Spp2CeHMnmDI3ugE+ZtLhw2MBO?=
 =?us-ascii?Q?PuaQ1g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dff9425c-bd4b-4109-2611-08db56b930a6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2023 09:29:18.9839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: prE0HDxkep51DhhQT00f2mHPV9lfaHmEXrQ2LAAhtW7oiAS4HzyQ3Qg/G3vSd2eFI2N+08Kp0rLUApFSm5FVJP8U6hqsHYn06dB2bb+JDLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR13MB6359
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 06:42:53PM -0700, Jakub Kicinski wrote:
> As requested by Marcel skip netdev for Bluetooth patches.
> Bluetooth has its own mailing list and overloading netdev
> leads to fewer people reading it.
> 
> Link: https://lore.kernel.org/netdev/639C8EA4-1F6E-42BE-8F04-E4A753A6EFFC@holtmann.org/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


