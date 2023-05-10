Return-Path: <netdev+bounces-1457-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C44A6FDD07
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 13:42:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B33DA1C2097F
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:42:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D813F9F6;
	Wed, 10 May 2023 11:42:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A05B8C1C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:42:36 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2132.outbound.protection.outlook.com [40.107.244.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEF12716
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 04:42:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz7od98aG6+iYnnptE0kDzhnB/QvghEg3SiiJGPDS08nZ9N8aTSF219bv5wysCUjbhN6yqyZKAzsXMa5Sck9aU8RHADhWAGGsfg9K1pgkufNyiIUoCR7jUZkx9nA1OSvKs/3zzzL8FKMpBeJIoJwREjMQ17NEzP5ACY52OMqDyY7YS2C6ukWxaEHLd5269DvyCIwvmuD5pOZ7Sd4OXzPRHS65RQu7tjflq3KKgqKn9Qa9TANvN+/wHMoblba7ufzfvdAKmCIZKqSvnJXTAMsgiqPsh6UcFuKP+0zrZFzxm6LbEHkhh1GGi/u3Wu3nDnUsKfJ2ZdtS5isFDNjJ6n19A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JQgoyQRkIroa4Iog8v4GP/n7iC0IPHUqQxJeMu2XbUA=;
 b=Fjheu7iHa5Rz1eOmYbIQNFMVMrUcuCCQRHvETo9d/ADSkYGHnEIkSjADKctFJUwj+HjZLoOU6uCz7AEe1kZUrcYMv+TmZOIg3XBGS/0/6haa0zwNha8K58Ps3y4uTubFbbabYpcuVhCz3b1JqXz641I1blldyfVs27L6Ke5Aq6reFvPNZgCqtH4TEcD+6Gq45XgdxQQhri59q1vG9BjmnIaTtc22a8vm3YeBcIhy3vxlDSzQGtSyf9/hr3ZCNdqvcsBomQGSxZHHVcYtyrnn3cy8LFurz6XYkH/Lv/RKAWLJKpRk1kWW+IanHHmcg5nTOFu2w8YK7QxV0CtYgWmiVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JQgoyQRkIroa4Iog8v4GP/n7iC0IPHUqQxJeMu2XbUA=;
 b=CGstN66kwhWaUXyb15RsLO830J9UUHzBGjS1O4o+k8sVopN5hC5tvIsinIfMfSUTOIwVAKFR7R+92LzMOzlCujRoiI7OvuMH0N66qMa+ApAZmCnCGLR4NYgRN99KNjXJnXUlKqnRbU1ie+ryfLbswdvjA7MwEcyiUjXrnLeFPP4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3790.namprd13.prod.outlook.com (2603:10b6:208:1f1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Wed, 10 May
 2023 11:42:25 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 11:42:25 +0000
Date: Wed, 10 May 2023 13:42:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phylink: constify fwnode arguments
Message-ID: <ZFuDGiRuLMX4R8jj@corigine.com>
References: <E1pwhbd-001XUm-Km@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pwhbd-001XUm-Km@rmk-PC.armlinux.org.uk>
X-ClientProxiedBy: AS4P189CA0011.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d7::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3790:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d508b01-d2da-432b-e5be-08db514b9ff7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	x0psuj1gTJcGrqk6q72uO0VPF1/P62YNpxYrrZf0QIW6k73MH7ZY8+cyTbpgINmKyDvEGRCPR8iZw8CCDzLgKJ7PhU0FAtEMBlAZvNHtXXZqKlwdAPuR81dVCIqVf+teM6MGEFxIJ9HaZEfyVhcSj1Jqo707C9wPreGAnVcyeEC07298xwKsXTBYWIZQYNxmjBtKsylRd6GcdY/MozGJzcyLXfX4A6gLwNKFHw97nQVwDw73dS0PNFlSYHLMhbpkC0WFZ/UKhIOkTUMlOx/wcNGgQ29nhgfk8T5kBKzGQ2r/c39YS5s0yuSTFffqU4Tjz28BDg8FVs/JPiq6katfWZqSYTl0oAgrzVpxBqtdcFRJrS99G/ZSnDPrd/M9+wUXPiwYcPxo7ouD1ZD5XYD1EWRu6vmvTYrz9n54TEKUrd3COv+IO6Y833FMroW/q4Ct7yTMn0cyYtx5M8ZO/WARkd8TP8z1EZjPf8ZTbddvWWK7rouHrqSK/uirbXcb3iCkfeQwy2btzsLkUBQ2BfUgbOYH1Of/LD9eI3FuifJSJV5Hp+nl3Y/TnS3UWJDmml4JieTCAuvW7/QkxZNalCwUTRM/PdkkM0eIA/vTJwlZuls=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(366004)(39840400004)(346002)(451199021)(5660300002)(8936002)(44832011)(41300700001)(86362001)(66476007)(66946007)(66556008)(316002)(2906002)(4326008)(4744005)(8676002)(54906003)(478600001)(38100700002)(6486002)(6666004)(2616005)(6512007)(186003)(6506007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aEt/PeZsiWIkSA7hFUONa84sMMZmyCXsSoUd9S+IH8KfGEnX+Fu0VAfl5klN?=
 =?us-ascii?Q?P9XFTtPKpPYwBn03GfFBKRGIdd+H92rFJXVndlBy2OMcHjNXs1ReotlJoPNp?=
 =?us-ascii?Q?PkBWSWqsw1BnTsNwW++kgL35vfby4OMsGP9SmYM88bmrAyDpGaqQbu8/QP2i?=
 =?us-ascii?Q?4xK5TK9WpzyFCzbLK5MRKo1UPl6OBTPdRPXIT3ZXc37f7Ya3QseWogo+uwso?=
 =?us-ascii?Q?I+0d9lIsMxmFXwjjJk1o1bgl/zjCG8SaAaEvaqLJ4cYYWgzPLyGrnT3zVHI0?=
 =?us-ascii?Q?CszzWWmY0KmEVSQKfdFbHB6ioMr2RuKTACkgFqJIXLUHwmgtJgpaQ6CXUS6R?=
 =?us-ascii?Q?G0K7H3YmAdgoD+KwEor/Z+sr3yVaKhDL1cBzxAcHtzliMF4eF4HPCBTFf1uG?=
 =?us-ascii?Q?YOQV1rT7lm8CTk1+P3MP/47QBfzGLJcXMrdNdY4iI3vbcnxJCROz8DAkS1T/?=
 =?us-ascii?Q?r1CSP/wTMnDVks8hwIhraaVedC6dFnbdeOD1VqeVcRvu9IO/eiI8Uh7J8q4P?=
 =?us-ascii?Q?vukQDElMxJ3BPNtJH53Lqgk/aizXVWrbl7Jh/Q3qIjOFo1s2FjnZLQp6Rz/v?=
 =?us-ascii?Q?nJtdDdmKl5tY8WY9bLtzL6JImBZfsdHQj5o/2eEw4RZJ2o1Ns+jaZvO9Luxm?=
 =?us-ascii?Q?iUbPRuDUA94CTZvp5fAil1rz4nSt99WDvc9dkRljK9DrmfKtTizc5mbQoGiM?=
 =?us-ascii?Q?MjBT0aF3xsQJdQzhYpEAm1ejYCl9U7UmuZScm62jGr4YaN39ufKnjfC5e7F6?=
 =?us-ascii?Q?B24joMPFNE13hlDBk2ce3mOHmeVBzy7Xf6rZGVIAYuDuEdVmMFCzcrFaq5SC?=
 =?us-ascii?Q?ZIdNagrVDLHhu07cOA04ep2IVS+JyCZTx3dNx/FXMR098MbRJywBsZJYWqxc?=
 =?us-ascii?Q?yf1a7RDskFHCrEmqQ9k8q57TKpot1NtsaZEeHXKCuVw8YoCDmgqKopoPYfq6?=
 =?us-ascii?Q?LXINssBfn/aMh47i3em7PYktCLVfth6I4dEtkewzMrDlzoaJmR3oTDbFn+zg?=
 =?us-ascii?Q?YGLXlIn+TJGLrTYi6x5spACH4UgLrZytmMRmePQtDLTOdwHH/rpgeqKFRhUJ?=
 =?us-ascii?Q?5lC5kCvue0dL9YgnCpLhMSr1qsaTPjsjcPovDqorzjBo30G65MLgvtD3wd70?=
 =?us-ascii?Q?Ve5sg0n2VAyPw5VZ2ohjR0SXS7ReDhE4ImLTiM5W1Nr7KTfu4lTw5FVc3xBr?=
 =?us-ascii?Q?dM19k4AqT84eU63KRaHx+0DVwzCM1oUC+uFSAa6GhoU5XnWq141RKcyeXPMf?=
 =?us-ascii?Q?TitNwnq2DwkfzQpxwM1Ii8gjO69802/W7FU206WhVz7v/dM35fquLcO0+XJP?=
 =?us-ascii?Q?oNcOWlEeM/SfpmUb0vUp8KGugyLtTdDvYF8SDs+KRp1VLQnzGk2CQUiJB4km?=
 =?us-ascii?Q?I5nmSAy3Eaz/PiXwWMBB+0VarD8MdjqN/QXBrsSuLrDKPsRusxjPm4kx3p5W?=
 =?us-ascii?Q?PLov32PDG1t8gKatYM1RsI5B6WAPRJ47CwZq5qOecgb/+h2Hf92ZYMpSfVom?=
 =?us-ascii?Q?BcoOI4959Sv3bIjh3GFcXtl5lNR7HSiOhjoG3Mypn0qbemWwQFs52R9JKtJW?=
 =?us-ascii?Q?JbGj14kbflV5pAK51PjEWYsnOhx3L5fvLIgERtO5iCSGF/Q+4oJmX/tbQNIR?=
 =?us-ascii?Q?+HxYjHfHDV+IPsIZJs5YkW4bXSS1LqJUPTanp29G5lC9E+E9pI12Jnq4VLA6?=
 =?us-ascii?Q?n+jWQA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d508b01-d2da-432b-e5be-08db514b9ff7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 11:42:25.4002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iQIiP9hUNw8LHRQTeirlRoCYqV7+BsFb8k+Fnal7KrxyGpNnhsSuzAXD47ieGhRrgfALGxEM2FiL32TuzrjtSIvBF8iZfZdObvPa8px5gV4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3790
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 12:03:37PM +0100, Russell King (Oracle) wrote:
> Both phylink_create() and phylink_fwnode_phy_connect() do not modify
> the fwnode argument that they are passed, so lets constify these.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


