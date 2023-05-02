Return-Path: <netdev+bounces-5-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF276F4ABF
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 22:01:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90CD51C2098D
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6949944B;
	Tue,  2 May 2023 20:01:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E008F6E
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 20:01:48 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2099.outbound.protection.outlook.com [40.107.243.99])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01F7211F
	for <netdev@vger.kernel.org>; Tue,  2 May 2023 13:01:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpEZEsxCxPeirLal5BzhiHJkQQE2HXmQ4DHoS2q4r1wgQsVIHsjSgj/f4lWNr6Zv/iaNTmTMeDPxcxrDpVmjpQdTlhwGIfykaJAvEkQsiNg9BuRdEN0qNlgrRKrt8rwyXKB2zFJg6MS83SzOArO9OxYykiPe/N3nyABGTVN0LqBc3+2U1FNSTj/zGug9bZO2G4suuj7yL7Vvtrx86SFL2cDINw/snnf8zVoS+xpka9oZlzc6FlB3i3599FPRfo7AOWYApkuldtoppZuvLFka9AUcZ6wfva1MtidLWFym9vTtSSSNzpPXrZ9Cdk2dHED9XtC1OsdIwhw3+WDmbXletA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=80Yx5DB3MB+oAdgh48oSErj34fefaPL9fSoG/G/YAis=;
 b=marJH/oXrRyv8CWMluXXuW27bxunYM48lGPk2VEEFJKSiGB0lyZtP+gQTP01jZBFt84z26uGY6fxUqMqfp8Wr6BzT+BDN3iyuFH4qWzvCHeWA6VbxlaIoKLcrZqEZzigImOowewKWKE4iCJCtnZ+Rz5r4gVuKFn0h20TkcN7LIPmoOcxMXmXfodl0PscxbcQEMlHckLb79RAzVOYYmUK/QCHjAsQ1XM/DnRaV73EmBCFpHIo+t9jJctV7jvhGmdX3v+YJM4IV0YbqJHwxXITPbJ7PW0qdEbX0xpJ0oYMYuhuYAblW8hhay46o2CdUe2ZGjLP7EjLCrFv9mLPmk7GWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=80Yx5DB3MB+oAdgh48oSErj34fefaPL9fSoG/G/YAis=;
 b=dg8R+SaNcj62E095AatjEDI6Vu51dVi2UsTaCPtrHzmjVDpKNUSFh63etEYoEp4xJvsIfxGWD98+dnljqScMZWLtgNFD5EWV33lyw7nWSIWtQYonPhFJ+dVlZx4l1gvnBEfb7YaRXpj+KggSCN//0w1GAG/MSeBAzNCLtjQ8Wuc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5414.namprd13.prod.outlook.com (2603:10b6:303:195::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Tue, 2 May
 2023 20:01:32 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 20:01:32 +0000
Date: Tue, 2 May 2023 22:01:26 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shannon Nelson <shannon.nelson@amd.com>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
	drivers@pensando.io
Subject: Re: [PATCH net] ionic: remove noise from ethtool rxnfc error msg
Message-ID: <ZFFsFsNg/H+859hM@corigine.com>
References: <20230502184740.22722-1-shannon.nelson@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502184740.22722-1-shannon.nelson@amd.com>
X-ClientProxiedBy: AS4P195CA0003.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e2::9) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5414:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f592a54-c753-47d6-823b-08db4b480650
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	quH2hsuxBEYAmyTDEfV1IfuJUzq6Nj/khq+NGycVUFylzp0864Atx+dzx+0AYnaEhsSKIdc7bVbBxvKlhDmnxWuwrUjrJzzH0dnMHWpnEGaPiL+qUGV6Jo2ACn0e8hE0vE9O+I4GSMe4WlnEi06Uql3bXoBcyVPyiSheD79cCAgERb3oSAHvnUUd0X84eF+vmAyB+80wWVvZHcV8CcRuESZbFzT0MpEoar8xmEQab8pX+CvW8iqPDUfY29++BiXH5+NOmG4UGiGVnUNgw+TYPyA5CA9dtNGUdUWev+S5DNbPSFMFc9IRVoX3hvaiAeEHVMF73WheewbnFddVPr/nQ1P5VvNUJxWdD2hV5h29zppEier4FxgPEF/+Lce7+vVIwGvpcNjMakRnNUES4JITk14wwTTWNgfZrTWurT4HW3eO2q+whLO2wzjEIanvXVrFY+PIava5REaIaVzeWPNFl0jhdOR26sFh+t/4KhWsQF69errpsJtvfosRwEvwzLwdWjclTltkja8Kfxq/klRV6m2Fepbf9XCLNE7lDo5NnMnW0boeRX8go2FQ5N7l4OQM
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(136003)(376002)(39840400004)(451199021)(478600001)(36756003)(316002)(5660300002)(38100700002)(2906002)(4744005)(8936002)(8676002)(86362001)(66556008)(66476007)(4326008)(66946007)(6916009)(44832011)(41300700001)(83380400001)(6506007)(186003)(6512007)(6486002)(2616005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hfdinHtCdO/YIgXs0S2iiXcg4pvyf6hFyGfH4HGZgZe+fymYWijESKPnq/n0?=
 =?us-ascii?Q?36Jf0QU/exilsj53e/eJ60k1DYjOYIQrgMnqlLt8lSPnShpowFSYWnyYkHOx?=
 =?us-ascii?Q?Jgbs+EzeV+P8plkfaNXgiV2p1rBB2A4PP3EfDx9zp2IhzMmFm57+Ooo/JegI?=
 =?us-ascii?Q?Eyk2n0WgiiwhIlEEcb5Ax2Bm8gwLMNNKHnfjI5wNRWfRmUUxAy7lPCba3JQM?=
 =?us-ascii?Q?U/Y5batli4ZcIXsQ4wSX2rfkqCJx8KoEsu8hOTGgCT1Elb8QhRQ+b9w1zaaP?=
 =?us-ascii?Q?nUwobVtAQ5R74qrGfIkBwfOaXK1snScIYI7AyBk3sbR80mz60U5es/2heU4n?=
 =?us-ascii?Q?sb7RMWIMuXaKL8NLdt/Ykrh0WBIIiByaliapqilQWmcKwMMnQUF/KIxwuXGw?=
 =?us-ascii?Q?tqOfl6zTGKH+NS+XlhhOyg3vH6TEbk2oHOropnGdxIlEqJVM29eKFh3rhZQV?=
 =?us-ascii?Q?QrRLpuZN2+RCSFzdy6XymO8iy3gC2zPzw+wlnr2aU+CbWlrXpjArpqYm4Kir?=
 =?us-ascii?Q?r7Bo04uvLA9k2LVWa2Q0R84IZSuOZX0i6Wr950Wa2BHTMscbsq9zzJ9oS2UY?=
 =?us-ascii?Q?9BNC5qR7KV+DCC0h9BjZWOqaeWxAhrsY9BPXN1e3nrdda6r5zTqc/RvmSui3?=
 =?us-ascii?Q?j6aptWM0m6KfZb0TcyeB+CgCwnq41LexqG2WSMAEJ1XzuIeWLYouqc1+CIE5?=
 =?us-ascii?Q?UWBXPV0BCWDAb4q2g1+5nbEZirL1gLwKb5Foh4PJX9QerMus9w0nIzy9kHqO?=
 =?us-ascii?Q?5msZsLxyg7dg8h7CaBd7Bt4QsbRnseozfiBeEimSkfukeBOJW6cZ6nyVoH/E?=
 =?us-ascii?Q?I4ZDQLCCMghc1Vgss2fXEJbJEHUZSdyQm7V82Sbu1V05mmaIZR6i6w+aGtUm?=
 =?us-ascii?Q?Qz6ne/Tn3uEUT2K+Pi9sHhSHlUBGmaL6+wlXbkzdO0XQWNjXF72OGI0FtlfU?=
 =?us-ascii?Q?6/AcSbRjXxUpGXDyCsLgmmXkRb4DM2bzT4OJkKlY4Fue1Ej7rIsqzGt5zoml?=
 =?us-ascii?Q?ZqENMArCuzl8zKzaoq1AjrC4aMDLv8HaMuc75zsPYj2XyNwjRSbWfHkBCyvN?=
 =?us-ascii?Q?mGI2oPxTcCP3JconvTzswvD7yCvAFje32LgCeC7fPTjRhkz32DHb1Lw6hCor?=
 =?us-ascii?Q?jUFdQGeeGNEdM2f/YkQUoHnMwkAEKDLaH3x8egibjvjSRDl4pdUSPM9FFdwV?=
 =?us-ascii?Q?WyAhuBYzDsAZTIbZHsz43HihxhiIg4P1y0A1daXB+T2Lj1iRsQMgo61elIT2?=
 =?us-ascii?Q?rKKNMbpn53R1fjyt3T9IlFNu0068GQsKDI1B9G7Y7XWULOimr10Kc4qfCO8h?=
 =?us-ascii?Q?MFTtns9WKoDubMTLlCm1a7KL7E2meUeXWmWxAEkguZ6TiIW0sJbInJWF7JQQ?=
 =?us-ascii?Q?sEfF9w/iCxWpc7hFAdVP26Nz10+H2TQoqqOz5PUeHKevXFTlL6qCxY2OKzLn?=
 =?us-ascii?Q?DbYeiUJV2E6ms1NNGsE6f2ZvJ7Br/yCBplYb0lfk1K4DqghEuzpHj15QeF6d?=
 =?us-ascii?Q?TXoLm1JRad77TPsh8y9cCNRg899dvR8ozZmwl7SPjM37ZZRwv8pMsnYHq3v2?=
 =?us-ascii?Q?p9UHXq9NgbyRcDv5cxsgwmvLAdGJTW43Th4nfN6UNOiJ1kLIRXK8dWkpOeml?=
 =?us-ascii?Q?0mObSVJSJHeSJoi/P72qOXIsPqm/VzH/L3WqHRoYCJVKr6LnUmD9ivKsMBv1?=
 =?us-ascii?Q?X48BqA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f592a54-c753-47d6-823b-08db4b480650
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 20:01:32.4709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5Vy6lQs8cXZLTX0suZuqzeIMbPuZMGa06vXfArSrjj4YF+WnTYN+pCXArY51eb597bdY32K87w7ltHnnd+B6DVVdjptrgpRtIolfcZnk3s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5414
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 11:47:40AM -0700, Shannon Nelson wrote:
> It seems that ethtool is calling into .get_rxnfc more often with
> ETHTOOL_GRXCLSRLCNT which ionic doesn't know about.  We don't
> need to log a message about it, just return not supported.
> 
> Fixes: aa3198819bea6 ("ionic: Add RSS support")
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

