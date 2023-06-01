Return-Path: <netdev+bounces-7116-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA5D71A2E5
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:44:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A82BA2811F1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA4022D57;
	Thu,  1 Jun 2023 15:44:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC8123400
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:44:31 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2138.outbound.protection.outlook.com [40.107.243.138])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49BDA134
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:44:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awO4meJYHkaBFlG2xHNlRuA5oGH8/7CSWMSDIiRetvQ77kQxx0217WSiuJ+p+HpwTU3zNwfTIuvZm/2bFsqlVVw1mjtxZ6cQ9PSVxyFjzybcgYNQkjQDBuUVbJTYNlZa9xezTcmy+IZyQcevm1oCkG4VvLTMoaYXQuw7lMtHdvQQSo6cf+/ei6iA2Ou3ybjBBm+g/W4lL+TlorwazSKnKK5qxXkHF5yXOYQKRkxM0eL9fEg3ZW3sgg1lcLAePbxVermD78VrLogngnd4AYT+70CXW9sbyjFbrlboEKdAVMQMtVouSbwHFhErSn7jpfqDjo51Qs1Wbkf9R6g53a394w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NpGbCFgrh+N6zqTsRzWXw1rNs5yhW5ZP1wnKOu8Gaak=;
 b=Stp+FgdHjIBMICa26XmFVBMyW79Js2ZbycV7Mwx2zvIUXzh/KLq/3uXbmRWku4ySEgsTXaNFQu8Yi8jjVEDv8CCgISDocrIYGSstq3rf7oWjQmTyQkBJjgN3K2LHdzQrqxm1YzabDrbZ6++mb5CBMSONBYBMQhJAeCFrhoxpH/2LaB36D54rTqOjcdl17orENBeGaz75sfgU3TepClB0uDggehOp2rIpxTXTc0r+M+s877bXmbMJNVSBv54NhgABcadhbeRREU0yKo8BWDooe5WM7AkYr3tVpsiuqNa9zC3Z2bIDwHLhrdODYLZ4UG1fdmCwrstAWJqwJ3qsl0ieXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NpGbCFgrh+N6zqTsRzWXw1rNs5yhW5ZP1wnKOu8Gaak=;
 b=wGHlkyQ4rp+oEp6x1ryVbJSFyX9eas41CrcdEwGRmi17TgkDPw3D9wWCfQ5zTy9/Y814Cfi03oTiXb4WFeyu00km83bV1bz4e0h8uKrqdHgdN59UUevaO92+Nfi1JBtmcKPKz6JFX8VeHQD1obRbc5yDbPJru5nbpzdv+YCd4XA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB4490.namprd13.prod.outlook.com (2603:10b6:610:6a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 15:43:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 15:43:07 +0000
Date: Thu, 1 Jun 2023 17:42:51 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Xu Liang <lxu@maxlinear.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, netdev@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
	hmehrtens@maxlinear.com, tmohren@maxlinear.com,
	rtanwar@maxlinear.com, mohammad.athari.ismail@intel.com,
	edumazet@google.com, michael@walle.cc, pabeni@redhat.com
Subject: Re: [PATCH net] net: phy: mxl-gpy: extend interrupt fix to all
 impacted variants
Message-ID: <ZHi8e4tM9MiB1oH4@corigine.com>
References: <20230531074822.39136-1-lxu@maxlinear.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531074822.39136-1-lxu@maxlinear.com>
X-ClientProxiedBy: AS4PR09CA0011.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::13) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB4490:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d401220-00ab-4c9d-8dd0-08db62b6e4f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	xgHmDy8DnUC3qgDpC/5gHsbJCAeQ8ypDyX3+IbANGAU3IveAlDvyiJBPG4RlUoljc9fOXXPtccioRKjClOB1V21hz1WGqCQ8gREa5OxKhT9wjvJvCWAMcGvCDRn0arJulM7mDPEWBL2e5F7r9SAiIwDGhmmuaR4xqnqhNT6pFu5COeZKNn8Wt98pjVb+PaY6mWEfry8LLqCtggtIsUa9psmwvndcQm9XlzZALfv1y4GcMcory6rtSgHt22LN8Ka0AWULqB7i41/SPcs0BGERF9CGLkGOqjls+CH33SZ642FfFgqHQW21BOMR0St2R+V72NYDSMkxSlGKVyJ9a1UOVpYUbi52XoHKUpjstsN3L55j8uImUugnKArlVdhBYch6BfTFrvwYspDmuqUVAEpsoir0lV1l0s0ttFGq4O0CYwwS4XRLsD6vbeJj0BpPfjccBMFFI8VX0k514o+T08EljLwwjOmrcZEuuiB63RubaG0I8/x2VCc+nuizY2vPizSF2SpqH0S9thN2kgcKhZpVyGr+dORct86PHTIfQdDcnOG0RT5ffNfXFHRQ8IyO4xAMn9sxjTklNXLDkPJ4Yt9MI4Exji+lKBGLGPR+I4IyWxE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(39830400003)(136003)(396003)(376002)(451199021)(36756003)(38100700002)(86362001)(8676002)(8936002)(41300700001)(7416002)(6512007)(5660300002)(26005)(44832011)(6506007)(4744005)(2906002)(186003)(2616005)(6666004)(316002)(66556008)(66946007)(66476007)(6486002)(478600001)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZYmmkndnCy/F5VIKNhtNjiiu5V3hzFht/B2iCHXEbXggAaRDFNlMRiLuK7nz?=
 =?us-ascii?Q?RyuhoUDx+i980Q/K4Z3o2hamhIB0kn1cV7CQR5juj8XK7jQpwlo5VVlTv89L?=
 =?us-ascii?Q?QO/5KMmETR8svOccLE1Bi3eH5C0t9nGm+5Hyc4qYV+mNUp2wtvYO4KIe5XJ9?=
 =?us-ascii?Q?qCfXbcSFWweeWdoEcGh4t61wIRO4+m8E9AGG0DS3HOMkrBmA02MS17jK0s+v?=
 =?us-ascii?Q?1X4wWVWUfIP3Y/puqq1hVNeH64uPLRASCRAeOwv6BprqpcBNvaFRxEEGvL3m?=
 =?us-ascii?Q?RxpVv+2V0FLZhzsOwhJcp+aTreBW4JfyEMb7AmTUX3/obBanTFGjpKa8ehlB?=
 =?us-ascii?Q?9BAzcvRXC4ZzxE8PmLLDlHO6A6hliBTjKi0E/Bit1T3eL8k2OVMcvU2LNvsR?=
 =?us-ascii?Q?QHp4FHgZdhZmsGR55OaWntWwfYxQVnx6gTK77V4l9MhdJPKpGQvica4GeA7L?=
 =?us-ascii?Q?YW0t2tEsEfA6qFMS4j8MbkVa03F1BlD7rRAqmm1pklWf88A8uRNbVV+3FDys?=
 =?us-ascii?Q?lsWfxUHMC2GYOooiaICHthXs16+dXLjCnfbyDTHYAGINMzt0bA/MoPyFAQJh?=
 =?us-ascii?Q?R2oIMweIimr9XOlLAuo0Sbi2wEttBvprRVCGvJauy9USo98UC7GVTrWLJg2s?=
 =?us-ascii?Q?TDnbPjfW+tn3h4gzndl0GEL5k7AEccmTIMX1zkjIn1GZKe8WFSN5+3Nbox4s?=
 =?us-ascii?Q?ZVWWi5vLFX0DO+DtErfcCmx9VUAk30mt6zHlP3rMofn6tIg0GVM+4jL97uUW?=
 =?us-ascii?Q?gi1wokt1y/QhodcUfSi/npT+PF315NX8uhFFCtpbv19HQVeye5JoTc1ADMOu?=
 =?us-ascii?Q?CqPBErnZSk4UyRusg3rFBVu7bPZUuMsQLdixhE1ehIbpRt4x4No7ncHZEcIA?=
 =?us-ascii?Q?2b5GSCQb4KQXXJ2pVlx8Jk6sihZ8D2zzl0+T/Ci9ezJFJcZxwWR0BA8DTB1b?=
 =?us-ascii?Q?b7mbkFxQOn4KSjdRPJEafBCeTeXKiYQe6zngiFxP0AxPXSs+K5NNl2f7LVTJ?=
 =?us-ascii?Q?2MyAOpHh21RHFKw3th2y0De3F0dTIwKYzoaHGKPpyMhluZFQZSGLESBOTzC4?=
 =?us-ascii?Q?yzArdw6lDyLvuLqWHWX1YkKw4AJLyR7PlVEqlJcdm7qa7S0WnozVRTQ++Jk7?=
 =?us-ascii?Q?CyxgNPD5WZZ+W+Qv4BQnnFS9xxrlnw+VoyfZ+Vb0z7dHcYwM1PJigss/+DlB?=
 =?us-ascii?Q?145JqS9TjWjiVKKu9IYJ7FNDqMtfLcqkbv9bCLmP1Z/wvGgqd5u/4HEys2KN?=
 =?us-ascii?Q?birxXq7Z/jUBwRG4OAf5EyON7NBx/tbLTZ6WoLw2+VI/FHtM11Ss6mpbEOfs?=
 =?us-ascii?Q?TeOlMWHg24mfSldVR0/I/0A6INzdAsADf01zqKRCtGcJG/RolBL7mRMahgNs?=
 =?us-ascii?Q?G/6p2WFkFf7t8rRlEibRQ9mgqrG9HUtdmVdFUyexp9GoT5Z5upBMaKINqxsy?=
 =?us-ascii?Q?f40iXueR4drphnlIRssR0esl1Gmhq5Kmog8XOLg1Ges1Q3Kxw2pvHjPjZ152?=
 =?us-ascii?Q?qzsvguZKpsiYbpX1tHX8ABC83ZDT8LToLP2cTQfyfkDixA6hweo/4y69jep5?=
 =?us-ascii?Q?a1GD3xi0++DEhWDqCeT/lmXjpGpHWekfJTJCEyCMFnV5n3SZ/QM7UTDwOxIp?=
 =?us-ascii?Q?xg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d401220-00ab-4c9d-8dd0-08db62b6e4f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 15:43:07.0843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qRg5DolLA4aYjQb4ztsbBhJacD3lCa5TYB6Kv1iW4FnXWJjLpGYphCU50d4TQrB84kprfxFW0V7TQJZXMS/kSb3JwvnMw3eLPTrLWWLoceY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB4490
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 03:48:22PM +0800, Xu Liang wrote:
> The interrupt fix in commit 97a89ed101bb should be applied on all variants
> of GPY2xx PHY and GPY115C.
> 
> Fixes: 97a89ed101bb ("net: phy: mxl-gpy: disable interrupts on GPY215 by default")
> Signed-off-by: Xu Liang <lxu@maxlinear.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


