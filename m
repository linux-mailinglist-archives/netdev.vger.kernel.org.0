Return-Path: <netdev+bounces-7779-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DCC1721789
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 16:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 063861C209D5
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 14:00:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC04C2F4;
	Sun,  4 Jun 2023 14:00:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B1223C6
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 14:00:04 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2139.outbound.protection.outlook.com [40.107.102.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F366490
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 07:00:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=knCh/14U9lRwoApcCZ/Z6GS6bcXnmOfA+CdS/DzkygMT+Hk1KZl2r2KGuPbA4Chc1dq6yZIEusINpZVTQ7xbxQdot1qAmPrzWPcCuz7KHLE30KY8+ktejItWiQOUn5XlokSjcsp1AohBw1sIWXQUReQ3nTBPkFwfiftProDwh6Bb08UYm7leNCyj0PTkYmuEnituP0Fll9H/4D6dJ6i7EsNUn8ellnkZhg7/rk4aGMKSFgudN1DaeZpnFWPbkMYt/BndQtCjKuFjUMD2JK+ypBEg5nwXbybEj1K3mKikB3UuQkNQh0YIBWDeSIkyJN9ZI8cu+jZEcx4DdAxnii/oHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0E3QGJSRRzaBY9wSNqD4+MVZUQUwO9cPMthvagT8dE=;
 b=QF7GPY/o2253V8EvZmxyI66CZ2Fb7uFx0ZPfG0F7Wc6GfSRDYXb0yF0YfJDvh1H8Axm8pqv8DLKFZKYgNa6nNgBXJLPVm8nNiDKVoZWv1baUaImDO0ODke/BMIc7TBVsfeUhSeH/jgxoUEW1IdJ9ORFrb+ek8igBcr9+Tclo7oPuqMCGiR3ZFAGt1NEwMzUHRqkmvdhQwhdFihRhUVSPs6zmoR85jC4Rc/fLQiwLPF3jmGtrFh5HIvd+RjZL5umQH9PGLHlvxHGADS0ExCamC6IQVxd5CsyR5iZw7ck2ilob+nXAopBrhZ+PQEpTCAWefs3gdzLFiBo61ELkMJo3/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0E3QGJSRRzaBY9wSNqD4+MVZUQUwO9cPMthvagT8dE=;
 b=PPlC6f2WtLlTsjF/Q0IqMT6zCVJzHjiBt1UKr7NJx3REhgg66ZfAuP2OTr+Xuu61a6b4mDB23lmq7q1cTplx3SSLcP319iCJZLXBtQK+INF80IdAlqFK+CCtlVPOTXMrMj5Cuh2YSJcdWRaU2DMaPieVMmyTMzcjg0Pp+Zs0sT0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO1PR13MB4887.namprd13.prod.outlook.com (2603:10b6:303:f6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sun, 4 Jun
 2023 13:59:59 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 13:59:59 +0000
Date: Sun, 4 Jun 2023 15:59:53 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wojciech Drewek <wojciech.drewek@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	alexandr.lobakin@intel.com, david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com, sridhar.samudrala@intel.com,
	pmenzel@molgen.mpg.de, dan.carpenter@linaro.org
Subject: Re: [PATCH iwl-next v4 02/13] ice: Prohibit rx mode change in
 switchdev mode
Message-ID: <ZHyY2TjJkFT46HZm@corigine.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-3-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524122121.15012-3-wojciech.drewek@intel.com>
X-ClientProxiedBy: AS4P251CA0021.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO1PR13MB4887:EE_
X-MS-Office365-Filtering-Correlation-Id: fe32136d-7195-4301-1f1e-08db6503fc2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LGK3ysUnQQTSWsY3A7rkOaMxOsI+nZR/icDz3HGHM7EaETuvi9jFJNlAM1p1IusjcfsevAMZr8b050UCdI2mUCbVYYe0oVB1TAv8JIaOr7MMNmEvkBDjGJMqB34IV0LwZ31ctqaDD9Ei8jCeCzN+LkoMxQr3dRcchkzDppqtuodgExx44Rr7UJpnhXUYw8j8IF3iLmt18cCeCdzDWqoLkx/UfnQc20UH/9eXISyxUqQFXIKyZayh22R6D/h45ahpo3RwBoVaCPMsTTI5oVET8wrO4rU7fqgwb1ZqFIEBs27Pe+2BRcPwKFeu3M5rk5fM54/E7QEBBUxTVlFuIQir+B4yp0RgVXq6uX+Y00pbY7skFfyGi84z2lL0mVC0p1ZafpCBH5pFpTywGzazt9Q8I0CL6eowD0OJ0Hox4uNpoVNzMQ+OojAxPZgvYh9EQPXmOT/yo9SdmpH4xpcilGwjUJ1Seo6ISCndDUsaWV/R5PTB4xpGzTCiln6HRTp6JNg/frkaQllDWd3ihmL/ASckVR+/ol8sY8dxFzXT4A05Tqo6KHUOnwCgoh+p82SOtGhjXKCEy6PFh1qxbhDeHB8FtGIo6xC7W9XgNLubJIK9kgs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(39830400003)(376002)(346002)(136003)(451199021)(7416002)(44832011)(478600001)(8676002)(8936002)(41300700001)(316002)(66946007)(66476007)(66556008)(5660300002)(38100700002)(6916009)(4326008)(86362001)(6486002)(36756003)(6666004)(2906002)(4744005)(186003)(6506007)(6512007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T4KgDJpKH7MI8QBJDPGirncGS3F2aTW+DmBe5iqX9rJbqb2nIB9lgry+QUEf?=
 =?us-ascii?Q?6IOLE30EbJPEuAYxptaHAmDVc1Uy7kWhJAZDhdvBCIH8J9oYbfbWKVyM7MSf?=
 =?us-ascii?Q?Ih8x3WAJYtcVHNl5Sos8m9hMzJm4xmq1VrNb0CG9E7TphhFMnRV9h1SqEtSH?=
 =?us-ascii?Q?5Ac5z5LDuHVCRkMYtw71FsQImiTNYvzc+BHCAoRZfaITKYeCpWsbyXd7l5CZ?=
 =?us-ascii?Q?2QLDK2hdM88BCMY3FmPyxlOcb8B30ooEcn0WnLOy56s+xsVs9vQV9q6rTzfA?=
 =?us-ascii?Q?GHuYSWzq1KpGckpWqWY6a1rDZhHQcxI0YzbgOZdpfpKWMefCDkDe5ZEUasSe?=
 =?us-ascii?Q?OxxIG0wkXeB97niYKExvbbDT0yEyV/bjJ88p80rjPKyrWviq910Y6SUcYPfp?=
 =?us-ascii?Q?/hkDfcGZQWZ2iabaMJnuMr4Xx7awt0EcvvxwJ0cW28C4nnhR1B8L6W7VEGwF?=
 =?us-ascii?Q?D8caKZvrUgSkImJS6YqiFUxuTpohgejravj8yHd+K6/KQs0wZaqrpXDh85j3?=
 =?us-ascii?Q?C2ejWojNvkzgRedEV8bFTkTT1TV6rC1qIl7r1XfHeHkcfV/YNmfk0C60iik3?=
 =?us-ascii?Q?59hpVC2ifn3vcwmU2zbaYWObIE/zEaKIoGhfv/xgY49g72RKBivDwUunQ6Fm?=
 =?us-ascii?Q?hcUHbkwe0zwmdUN5/x9PzudGU4p51Hcd1zXwELAz1/TlaqE2BnnwEMFBQAuv?=
 =?us-ascii?Q?1MskGVtJZETHckemWRRfUM1Ha1joasOWXzrK3AEJI+eUfeZKln4arph7nLsC?=
 =?us-ascii?Q?mSJxjXdirArgmXUcy7of3KYnm67IGs6hXB+N4IBzY6yWPKZdw761pdWya4E7?=
 =?us-ascii?Q?YMIymSgm64AL333KhhrNYGsLxSmnazrad/UyV4IFI9NN0HxBJELCqKMGDosP?=
 =?us-ascii?Q?dYFSR4i/pBOARVwPT/Dezf8h1B3X9q/6DjQX2fyzAR/3cUXFusBUmLwcII2l?=
 =?us-ascii?Q?ILro0kYvz409SWng05oIPXllsvmyjioKp185TPDmOtUYyugwbwbLk8zRe9AW?=
 =?us-ascii?Q?Js0dAqCXKVi+sOTCyyZL8tOTwz/sIHXNmLcYWSrqcPPfbsr8nQlDqdzCNHQE?=
 =?us-ascii?Q?gKNVb4iy4ELiavfJrQlaMmzUinHaGgplOTfMirtF7SMvjWEIdZj2pnTjnPUB?=
 =?us-ascii?Q?BIiBLjR5KrUzqJtzPFfM++rTUu3dMags588x9AjlWikfzFjN7IgNHo3nc6vi?=
 =?us-ascii?Q?cYk7JRXXVvUAzqH1Dgk7lVY4VTxg8m6aA4sSu3xk1Q7V1iusx51qDEr+cBXK?=
 =?us-ascii?Q?3PQWOSAhtdtpcTrdEOqd5rOKI9v0dqt1y5ww7rNp0eNHqnqNnaikSwSoYuME?=
 =?us-ascii?Q?B1GfEGqIEBOC7Hxi59FBtle+S22QELAdUf7V7ckWTF851GWt8WgsoTdfLpuk?=
 =?us-ascii?Q?HICSPbqIMGaSU3yBg7vJltWcMHM8QUXweNxdmFuMRA8kMYKgit6B29rNhleb?=
 =?us-ascii?Q?Up9P5srnVFsIW3wIrDuijSKsIUn/AbCTzUebt7o9bjj04idokuSAInlq4INk?=
 =?us-ascii?Q?yCZjxBs++oF4vSpTk0HeLqp1Iilh7XNFXRYh9iq0WFrZ/NryE4uLhtL8XSzr?=
 =?us-ascii?Q?3Hi6WCGUuq+NpRrOc1B9c4xM2CwRzlpW3UhLZRJ3+qSQ0Hqq+3JeF0rJ8NJd?=
 =?us-ascii?Q?BflITBgWDcFgdx0j+bffoYwR22SOKG6oE6rL86i38hLpDywr4NWJpRPnovBH?=
 =?us-ascii?Q?NRTR7w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe32136d-7195-4301-1f1e-08db6503fc2c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 13:59:59.4342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BY0ojSavVWQb6s7AIQccmFdOmWa+HUBpryoWXJTlHxsotua9Fbo1cxw+fztSXUiF97Yf3xwNQ5gtOBLjQ0owRA3zmwuZCAN7bydI6KWgsa4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR13MB4887
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:21:10PM +0200, Wojciech Drewek wrote:
> Don't allow to change promisc mode in switchdev mode.
> When switchdev is configured, PF netdev is set to be a
> default VSI. This is needed for the slow-path to work correctly.
> All the unmatched packets will be directed to PF netdev.
> 
> It is possible that this setting might be overwritten by
> ndo_set_rx_mode. Prevent this by checking if switchdev is
> enabled in ice_set_rx_mode.
> 
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


