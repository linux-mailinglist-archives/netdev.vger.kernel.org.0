Return-Path: <netdev+bounces-8389-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB90723DE9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02846281604
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08127294EE;
	Tue,  6 Jun 2023 09:40:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA990125AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:40:28 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77A3E4F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:40:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZpK45fek0q/JDEDbaIguBwgkqknVhnXvL37mEcuHeCmL1fI/HfPW1ADOSVN0fslYxg6b/EwbrjHs/XSDY6+kvqbRLZKAwD48iE73W08M22f467QvgJBOZ3+b9TE8W5XG/Bo6jKQiRnES1C5+RT9+Wj6P2XWWNmMxKsroU7EzKaPisBK5RKW+m3WqMft3zdAsSffrMjzh5jdBQeVsRZMtTYkymQQP5dhfIUsl0nK0tN8nZHxP+DVsHvOBCAW1k4KnDI7h86+0HvCOpEJh8MEAe70/RQIAFYK0uHHD9kO5QE38R56WHyvGAwL/b6ua0cDFFuUhzAMtwQ1OL4vmQA0B0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCChaser9ivpkj0U7VRgFErs3uu4NRFnkhZUQ7OJl/M=;
 b=WCUOvHUzAWn14mUDStiuJma/Aro6gjm6xhZChwapHl0OQuYQ4c0DuT0nb4QSPnRZ4OVcLVMYE1zCVtWnpKjh4L5wR7JJ3l4Vvi/rm3hmZzN8f4fw8czqqj6Z4sYbE8RYzxpKnCHhZ3ur59oSJhNsnXgUJPJCS258Gvm5tbK6RrZROYIphZ7q8j3ByMY3fhr8Wh3TjluZx8mJphkxiXQHOAtuFRvSDvumSMtFzHMaJmJYVMJOnkUbRIHhxLQVGcqH041tBM9llTcUJ3Zgt+VoMcGGq8Oy2/IzbzM/c4NbyMyRXkto4X4IGnwD1Sxt9YMNY0ovLILSJ0uGhDbOSJVfRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCChaser9ivpkj0U7VRgFErs3uu4NRFnkhZUQ7OJl/M=;
 b=wY0ipyFvLKQi/nwGAsB5fNFlkzMj/+I3jtks2+XVv15m9sSAcDAyPFmddkxLnMhLNW6qGGvcUfPvp4Felh10x9D9XqaYjv0ViaXevyEasoaintelI4sr7y6IOwjxKOLGfAke8VSBPRhSlrdj7jgXWHP2mzFyq38GGDdtMvr70eE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5363.namprd13.prod.outlook.com (2603:10b6:510:fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 09:40:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:40:23 +0000
Date: Tue, 6 Jun 2023 11:40:17 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH v2 net 2/2] rfs: annotate lockless accesses to RFS sock
 flow table
Message-ID: <ZH7/AYVDuK630MvO@corigine.com>
References: <20230606074115.3789733-1-edumazet@google.com>
 <20230606074115.3789733-3-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606074115.3789733-3-edumazet@google.com>
X-ClientProxiedBy: AS4P191CA0014.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5363:EE_
X-MS-Office365-Filtering-Correlation-Id: 83c19cbc-4b0e-409a-7fc2-08db66720d0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zChtA8Rwm4VZw0rkXf/Mu7j+DsoMhK5IjRjx7RsbiSClHUywcMY22HpFDk/HO7hk3TaW2/SQ+OibDoOVKlSoRiWP/iLuonBojhxXrvGK9gBcsq/9TBzMzpj9a4c16pVHIzPd9K8CFlOl1mGx25wUuO8smpnyFN6ZnEzMRWpIv3eGeY5yBTA9pBro5fin2QKNS54gqEZgWlzOzau0eviIcJZxPZYDnsMg654kvdicHwo0jgn9zOyxLB39r+DwnNHBJfd4DEkAPK8b9oYD+hQQDQZSGiOT4God/cKJ+G47eo2AjpnB/qtiZnR4QdqC1FhN9no6yts6OsMx9bximFMNOuwm89ENw3zVlTiK8JBELkfnirxCABGiIcraQMTjtiuMW2h7jCvlmuL8J/ZVONFhB57Z6GWK9TT1nK04S0WpAwslUSR3dswVXDZngG9T7bHOVnOsQ7L5UMgPRkFPmFLrbpEKp9i+Ndi427BdUrqbQybGwMYusyUk2MamoiUjlxgu8baKLYFBmZiiHu5XgCAjsARPEtc/y+rIyrgvmGw2kYecp6Uf93fMw3i2yaLbT4qm4DqiM5N2/W3qQ75qhMRT+BQVmHXomMEJxtxPmMvHRyU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(376002)(366004)(136003)(396003)(451199021)(6512007)(6506007)(38100700002)(2616005)(41300700001)(6486002)(6666004)(186003)(83380400001)(478600001)(54906003)(66946007)(6916009)(66476007)(66556008)(8936002)(316002)(4326008)(8676002)(5660300002)(44832011)(2906002)(86362001)(4744005)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F7LrpY21RBRNExcMFGfj4AoqkTE7Dhi4jfQxkNae2jaoKq+OEGOvy3TXD9a/?=
 =?us-ascii?Q?ASHR8uamBYxSyPqk8fVkW3FIFNrB3rl4dBh2jsFEr1iyZZXR8fCa2gcDL9+W?=
 =?us-ascii?Q?oW6hEyQFSLMh/tsFMDHzJPZ+qsDe9DkfqkQgjhCsHGbNpnL+cQxsOGcvnlfS?=
 =?us-ascii?Q?Fx8Qz9Evfb+rvnVwEkAeP0PaIFAnFxz1dN2EKbX45agQEoL+PK9UTclQPBxv?=
 =?us-ascii?Q?PJrcWGufYJX4IKyUu/hZzdxlf7eTSZ/p6f3tsoPgUkirD9Ptj4wilG5+blIZ?=
 =?us-ascii?Q?ivbhssBcdxg64hBvE7lOpcN90Vcke3aIzq/pqkSKTQhtfcq4+BRyRAYsTNTs?=
 =?us-ascii?Q?JOh3wMWmhR/Et65M2CmC1iMxbIa14Uw0Y7stBnlB/g2SToh0OkeaEguHypqB?=
 =?us-ascii?Q?MUh8sglXjmjOEvNscXWXcqsNLKuVa+Encyuy5+ASBr59Rxopj0iuMxGSYcJQ?=
 =?us-ascii?Q?5VP2jTpnPBYhZi1tv1upD+pqIPunBUDDQ8ZHWUmThFjaOhxR8AU4K1gweOPp?=
 =?us-ascii?Q?zexsUDGrZSOQMnqZP/XKyytQ3pjlkbV/ZMSqy1udzbdlSu7XkW7EOv4uKGoV?=
 =?us-ascii?Q?WzPLfx8M5KlTw9K3tUyl4zkVzmulzYNlmvLdlMLG2VG5ISgIqj+I5zbU0Xd9?=
 =?us-ascii?Q?zEQpEKbYPARZYbf/x6iv5bqd3EIdNQc4NI0/TtPPd6pa33MaFEk4S3Cf3Puw?=
 =?us-ascii?Q?/GDEBgmXOFA33ooHEpszjuouqJrSiLvEzON/ktdSxBLSmyznSZkQm48gVtwy?=
 =?us-ascii?Q?nV5KD1oCwDcZDi/iMEpS73aO6/JeTyVnsKlAwL/Zu0bvUuOV25ewsQlfpLMO?=
 =?us-ascii?Q?M9XK7WY8jbhdQBrG6FoK/aUuXobNBIxBJZUwmABE5kvksHyM+nBV+LZXdZGl?=
 =?us-ascii?Q?DeRpISxPP1XXKPUFbPCyOoegfcmpJLLDv/aMAPiSfqRgsUuXZS5kSxtAxR96?=
 =?us-ascii?Q?DuzqjdG5gUF7KYaPb0BORlxwXZYvi9zxaUYrK4RQqJDDcq9JnoDIf7pRlNPX?=
 =?us-ascii?Q?dJxoOQDVCulnvjw5mpKGKK0vHryfxNRRmuujjvlhj4CfhE7UcpJ1ZgPIknZC?=
 =?us-ascii?Q?LhR8xtcGSLX4QLlMT39Ti+BYGXILBumHHlyy+pAFwlHizV+Y1QPCI1cx9EhH?=
 =?us-ascii?Q?D6HiIFQis/huu4ZpnF3ChBTayjbhSvy2XZwXYtQzuoaIAdqDlUPDFeu4hv+Q?=
 =?us-ascii?Q?Ctsf7SXvF4oQhwI+UcDTvjoXquK8N0kH56KiRvEFRFHTFArMxkk1SZsNmlxi?=
 =?us-ascii?Q?WxMOxlvC4rRHghfGw0G19hcnuzm1ah42QmErlbEh81XQRCwfj8QM1ik3sDHv?=
 =?us-ascii?Q?fI0sHtjqeuF25pIYDoCI8jvfh+4fU/TvZvGoArBs9lOMzVFahNi2CQDVf8z5?=
 =?us-ascii?Q?M0I8yf7g8UqtyQuYBrWnm8jPpxN0WspkkNxsvfvvGucGdn+YcVmwYau63Ipa?=
 =?us-ascii?Q?pAbCTOxnZEYi2YdORT30LAuBCstAcB6Wb2NPmdHXlHmaQRVR2FJU+2AeIhpz?=
 =?us-ascii?Q?tRD0580ZQDOxID8ZmENUFcBr1AGkhp2cWLD0VPDqGjaNA2r87/ODvg+G4t1O?=
 =?us-ascii?Q?Oa2hSa5gZAXWd8Lj1Lt/4NDBjSdWF6JInyuHRhnkH+74JbxFL/gKd7RRNzgi?=
 =?us-ascii?Q?nsXFkP2TQy1zJ9HtWmJ98ZVCHenmEfwpHX2UgC9I3AT/uMwQcCyzlzrT1mwt?=
 =?us-ascii?Q?Kic5Eg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83c19cbc-4b0e-409a-7fc2-08db66720d0b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:40:23.5064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TNeptWPIjMi0mEnjrOCh6VdJAw/NiHYj4RIHhxjWvUz9FGKwcEZduG+UP2HBvQdXEyKcYM1DZclO5UoTfkrJvw7ObMWtGswJnV1YcbgmsM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5363
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 07:41:15AM +0000, Eric Dumazet wrote:
> Add READ_ONCE()/WRITE_ONCE() on accesses to the sock flow table.
> 
> This also prevents a (smart ?) compiler to remove the condition in:
> 
> if (table->ents[index] != newval)
>         table->ents[index] = newval;
> 
> We need the condition to avoid dirtying a shared cache line.
> 
> Fixes: fec5e652e58f ("rfs: Receive Flow Steering")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


