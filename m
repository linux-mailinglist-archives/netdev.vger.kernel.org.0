Return-Path: <netdev+bounces-4652-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D390A70DAD6
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9CDE11C20CD1
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E16034A850;
	Tue, 23 May 2023 10:49:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD704A840
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:49:55 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2097.outbound.protection.outlook.com [40.107.244.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FCB01BD;
	Tue, 23 May 2023 03:49:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B09xcuN+MBHqA6ou/2B8W8Cw+PSMCvetPN3YvH8WJTorJtltsTrI8zlX7NE10t0sdORomMYSB4I+FlYISekarvc3CJUIGTkGbpGHW/HLOr/KJLwRZTjoWXV2vLL26fKVTaKbeKIPf85hGpoPQnp7wtE/sPcHUiAnnRmV4xfqgCS9Gg9L3Nk4neVfuTz7+2Q+fuhSfpJQIqaFFKNxolIdHbmVFuhpbueUbRnjTGlRzWUaiUrR5LSK5HjLIS+zDndPLWdmHcTcXyqzP1euhpy8oD0b07lWIW9DP2aamW7+Bgu7/DEprYSPYZXfhOLy5uL9tLl8vZuDB494dC/V7DxbYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNDBrUYJvy3yQ1tW2DLxa80WryJdcmMtC6W4XaSbngE=;
 b=L/Vjtk4dOEg/9aX8N22JBm0AS4cqYqgv29YTTuhxtU/vUpKwhxJMNM3tTietMhY5Y/66KlxjAMGG73Hs5HUaCuImLTq2MzhhpLpn+7s7tKo1whC00QA9gn6qTIHsicoGwO+JYj23kk6W/FXboEb1C8oRZz78mfWXB3GnttT+9O61JayZj7rbguR0wUNbO0i29B2HZINcB7mePxfxMs4S+EPJRd73/Cf05H+0QS6BwOQdQMm1oGxNNKOSOxrwclytDuKPyepNtTBtMmvWHmGNrrTMO4Ky5ggVUurUvdbnqPxksduocXJ55D8EDKTUpze6VOXNmLg0098X921qpYsRtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNDBrUYJvy3yQ1tW2DLxa80WryJdcmMtC6W4XaSbngE=;
 b=TN3ko+aF7RLNMxgxsFTt4FlK4RT/s3Uf0a8qbhOnIFvQGD5A7fb8pZ6HlE2ohIxgOgyEmCwxhdo+/lFC0KqhGEPxrTY+peDNE/+pXcJhmJImdf83+Wz514IeA4Nn667yvEsCs+rC1UUnr5TDGH58pMXYi0F/oE7QgnuzTB3yIHk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3765.namprd13.prod.outlook.com (2603:10b6:610:9c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Tue, 23 May
 2023 10:49:50 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 10:49:50 +0000
Date: Tue, 23 May 2023 12:49:43 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com, andrew@lunn.ch, corbet@lwn.net,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH net] docs: netdev: document the existence of the mail bot
Message-ID: <ZGyaR61pO5JgASN+@corigine.com>
References: <20230522230903.1853151-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522230903.1853151-1-kuba@kernel.org>
X-ClientProxiedBy: AM0PR06CA0074.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3765:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b05420f-8a49-4bd6-e6d3-08db5b7b6eae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6lLylMmXQfR48RUmp7jV6Hq5qfOApPcDJmqWZB5ErIRo4rGlnQa5dSZCczO2XnqaNEm4X8IMy9apjvFlJBcgRFgLhkqxXnkrpOoTkMXzykubIhqWsrwzdAaM5sjKalezd2Rb3t8Bi/kyXMsr70VEH9XHoajZ88x1TmGI8mgpeSu+OJa0jjLlGK3iPEwRrn/LDpQPDSmsNfP1w8aUKtwifEkDll0e+fB9a32QugDROCJXvZ+fuKKE4EJmiVGxANeoed0Tz1mDSJTET5RivVHqo7RAiRwORPDFv8ph0aDEs5EB0iRFG40fnckC+/bd1jxHtQwPgtjFmZnJKB/++2vLx6rvr8Zol7WS58HTPdf0tc2uMoHHTSHyl95KUndcyWnECE0BFxba2Cgl42T4ct9JPp7nMlBlxj60GVDGAK5qeAdsXuoHGrFHfQQmOgZtSXYbTSMlSo0fEJFtV6CcRg4wRYDO1u1YYKoiniDL0wp1vtlLIJAIoCnNbxXTfTv0mWKMTr5tO4X2+MKiFGuQJCQUpWYXg1rZ5Jz2R4CH3u4depM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(366004)(396003)(136003)(39840400004)(451199021)(38100700002)(8676002)(8936002)(5660300002)(6506007)(6512007)(186003)(4744005)(2906002)(2616005)(36756003)(83380400001)(44832011)(966005)(86362001)(316002)(6666004)(66476007)(6916009)(4326008)(66556008)(66946007)(6486002)(478600001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hkuMsAOir9q5Tj+9YVexRdEIczVqqn6Ds7A9N+jYN1bi77Y0Q71aLpk2qIOK?=
 =?us-ascii?Q?yr9xWnJE7k6rg8C3f/iZEdV5uSMOpIRAAIOJ36ts2V4b0bavPhKMQLfK/840?=
 =?us-ascii?Q?BrGrGsqNKOZTB5kjpBQ4OB7685TcERCwXHOm/vIb0bvbZ5bsCVaoX4RNRBk+?=
 =?us-ascii?Q?PjIsqrmPwOMsSa/f89G47gNb6TYdhtPNOh3pMgsbssbN+k6truFaMbhtMEcu?=
 =?us-ascii?Q?0FBpAPs6chMUPaXTz2nGrs6s1nYOqyOACCU9x5DxCCZsMBXVLbLWXH6ISFrm?=
 =?us-ascii?Q?Z1l89vQWpvnsGojmwXUjotkuiLos3lPHtdyGAhBaDmgjlYvCy07tSfqTqI/N?=
 =?us-ascii?Q?1SgFHlXpuweQwIwZZfLvzb8BJeZ5dlIlaXZB7gE7EWueBLlrdcGvaiNbSW+2?=
 =?us-ascii?Q?Z5aq2Q+5KKMWUG3u75Tw/50dSg/nr0QzATbYKqDfNubl0I7B133/4vhILN2E?=
 =?us-ascii?Q?J4ohbvubjVnoiu1EcKNjzA8al48kFzBB4uUJ3fLcCe8uouBpISLpklhlle0T?=
 =?us-ascii?Q?VnMGe+l307M4hY6ogrvgAZk3q8oX01CdIQ1L9oH52/dwQF9Qx9SSHVVGxyHD?=
 =?us-ascii?Q?Z0xs2/cOKxF8EJb0lUQzrcU+1mvwmi1xoMlF0weUThoQ5o56Ibqs0bNGbjiC?=
 =?us-ascii?Q?9vub87HzzzSaG3f8rPB8CR4BbSCcxPDwVff2W9f0tiPr7GkGEo60kqi+qN1c?=
 =?us-ascii?Q?img9duJ6wCSxfddeaJluP/IQb/rCzJLCPCsZEZvw6amlrbuWNXu/kzobS9VW?=
 =?us-ascii?Q?9BIDmF47bf1anmXDH95x3kt6y27vlVtP6m1ATX1Ke7+HUJ/sfntxkwSPk3Qo?=
 =?us-ascii?Q?OBlEhA19b23XzEqXdDnXKdDbfsTSI7r7sWvxKluMS/od12gG4XxPX6oQPS/k?=
 =?us-ascii?Q?DFTix3WWLMc3P1H0qrowh9s1wZ6ejLS/fi05rkI+asIz+TRsB2cnhZk64gRh?=
 =?us-ascii?Q?ix732DCLCYTbBxmHl+U91HILWKH8nBQTyFuwlhdqrDtbKA+UCcqDCv0VOYYH?=
 =?us-ascii?Q?fsotoQlDj+4sVdsQoQj/NhWlbBulo1SA3GJHdd9V9Xt67zrXYFUt0DYz0Ip9?=
 =?us-ascii?Q?k6EBK+I6vICjETFT0YdRRhaeG0Kk+kfMucMCZoyzqExDYkEHZ3C46FbdbsX/?=
 =?us-ascii?Q?PXtIuC0zIGGT/3Q5gDOpOV7cmQPRnWNUaE1elXMYQ8HJZ0979L/68v5vJFb8?=
 =?us-ascii?Q?0CKLyBurQjcxrHm2JZznnuBq9vHeonMoZXSw3rl8gtrcaPngxfG1qKho19xt?=
 =?us-ascii?Q?Aoj6UuhjasagaCUvJKxoR7RyYG7RyjCUVyVj+8qjAG9MboM8l6j1n9qCB5q2?=
 =?us-ascii?Q?hlzKjLqK2FBlkXoXnZBab+f3rShPungP86XudTVHVlEE4R17Dc6CQPqVy26W?=
 =?us-ascii?Q?lsxAAvlOUlAuzCnRR5LD0gqn7vUX9PSigjNGNX5NZfs7il8q9U4ZFo2pHR1K?=
 =?us-ascii?Q?Wba3RjpoV6ua9EhT+v8TNU+qCMFWjOnEo3DqyLuUCxpYy5PDTvDx/bkI+9St?=
 =?us-ascii?Q?WssZEEViNslSq+7zAHhLCF36XiHn5eRlZ65b+UxkONXQZLnd8GMEoRMfV6o4?=
 =?us-ascii?Q?B4Tw0xeyCZ1Z6755zH0J+WRQ7p8mE66eR6ZnVYwYBlNaCeTWmk+71RAlFGvG?=
 =?us-ascii?Q?PYxLoxlQrtKIW5XnSa/MAtTJPN3blv+HAF5jFM51iwH2IOcOqZ0rfmqQ7Osr?=
 =?us-ascii?Q?fll0Fw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b05420f-8a49-4bd6-e6d3-08db5b7b6eae
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 10:49:50.0632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fvJ+cjliW/iryMo62Upe2IalspMSI7nOpdyH9TVGlfYz1GW9yXfDJZSiuvFcTvlz/sSDR/UDTg/ryQ3dEDQo9qpAvEtAGUbq+iaV2+6o/s0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3765
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 04:09:03PM -0700, Jakub Kicinski wrote:
> We had a good run, but after 4 weeks of use we heard someone
> asking about pw-bot commands. Let's explain its existence
> in the docs. It's not a complete documentation but hopefully
> it's enough for the casual contributor. The project and scope
> are in flux so the details would likely become out of date,
> if we were to document more in depth.
> 
> Link: https://lore.kernel.org/all/20230522140057.GB18381@nucnuc.mle/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


