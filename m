Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89C45A767F
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiHaGXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiHaGXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:23:30 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB65BD130
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:23:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YCVbT/LGK1Cfr7VRQ7z8ogj5N7t3bIlpWGAJvUwq9ziWJCG23bFjlMeM8ZL7oQnXhze/q0eSguO+GIOGNUQZIkHWFseYEtvENSBKO1Rnk3GnrXO+MnRjSyRBp8/mSuI4LSJS41Hldg3twK3lgfWeOtio/Kk9VuHMZXVrDKAnw9oPtIrP9Y1aFL4pDNEXZbG8I88zcy8kvazyjPmBF0+UD/4cO1zTFZrC+uvvQL4QsQDsrp6fCl1Mu40OlCM9sRN3zKROVMChgxL+MAl/e4eLqoPuBqTRi+kabqW1MX7o5DyUXfUyhxbGer6Fw0/OGuft8d0uVdycz4V+h9S5zzWMWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H5IgbxYFHPfIZ4C9uMI4Ym6eCGnbbTrp+iqEvXUiN1I=;
 b=HRhstcigBNvI+l3aJG1D410Hr6BY22xo8Dnc4CIUBrLUtkkeQMlB1TbBBzckCstPFRoWKZ/I3S+JBiJf5+oKDKxY2GIwC8RdIYSaeXF5CVBjA4lPZG30WjnUeohy5MJQguY6XwVXR4uHp2YhjWGLhsjHOUG6vqa7OX1ylsjWSOtf7bBgdOk6Yj4tAPgyl8mdSReVblparysN0Zp9QyO4etozy/BIQ2jeG8AbzxT9Numg6aDIneBQPtW6j3n3EeJY9JWYIYTy4LH1S3BcZEL7wE2s8KuLRCXKXY5/CB2wFUyoGDC6ONAeYl7oIuFREG3ulKiLx+HYhbzvSDwrJToslw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H5IgbxYFHPfIZ4C9uMI4Ym6eCGnbbTrp+iqEvXUiN1I=;
 b=LiknwHXJkO7f/URlURAL4FonRjRSJoF+9AVWdrPrXQjfCE5KtEQWik3U6yRuMmjOc4yWZVDlyl2lWCdFFzsmOKGa2I452G4C4JAC+N1DXHd3VSTHhvWexoBwmkxkzM24pZCkygpGLsrcBUkOi9wpc53I4IBsO4Uw6j7rCfEBkAZKpT35WAfr/jHDy3TDqh7mF8015fh8tHjch0WowSLzTmmVnviNkJbxxEKEJyYIH4ogWNkjY7jVpAXkMoPWgFZg3bTVwC+GaoRmEx2WI3TA+x90BiWk3E7toYsIeVcfw4Gc3ZYyTf/stSFp5XPbjbinyK3IOtjvc2okiuR3nojvHA==
Received: from DM6PR06CA0063.namprd06.prod.outlook.com (2603:10b6:5:54::40) by
 MN2PR12MB4287.namprd12.prod.outlook.com (2603:10b6:208:1dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 06:23:27 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::c0) by DM6PR06CA0063.outlook.office365.com
 (2603:10b6:5:54::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10 via Frontend
 Transport; Wed, 31 Aug 2022 06:23:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Wed, 31 Aug 2022 06:23:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Wed, 31 Aug
 2022 06:23:25 +0000
Received: from localhost (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 30 Aug
 2022 23:23:24 -0700
Date:   Wed, 31 Aug 2022 09:23:21 +0300
From:   Leon Romanovsky <leonro@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Message-ID: <Yw7+Wc1+l4l31BzB@unreal>
References: <20220830101237.22782-1-gal@nvidia.com>
 <20220830231330.1c618258@kernel.org>
 <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 026f9415-164a-46a9-123f-08da8b19507f
X-MS-TrafficTypeDiagnostic: MN2PR12MB4287:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XRcINQGXWX6hbhhH1l2nj4ClvIfJWscm4pE3t50H/Eg43U0jx6GFx7IIPF8pMge8Gzdr++tt050P5jvj/EN/f529eiZ531ywmYL5xZ4QRTRIAQ9SyIXhvvOkNZJHOYB6CqYewKssWvGHHb1NFfi05p3+01YyVwpk8jcNMErXQT78FrwvSRtharpsAWZesjBOsQR1GSvdpNrYZNeUXQ7T9+Il3GGMCsf08GLbV7KLH0D6z8PKF70AWrAEIpOG+avr95NjLEl1zz/dh0QS8W2ez51MB56Bgdq32cFfxya0xlB9IYefdBrPycyBYeuokj0r6KaLcr9VQEEjRejceA0G9oEUFqm0JuK1hMEaGHtAG2gahdbtWoREpMW+7YJo5+/XPpoYNyOKgZhcNAjNJPPYVFem/cv5OaeL5i7RyhEZxuZueERL2WbHON+aoc8nwLJZFDaOS4HU20hcCfSqJnFZt0tj8iTm5t7V1tJHNgo1/G/mOsB7enRRUiCXnSOaMYuNIpiWIoyV4qcXJvRSWGyg7aXuAM/o4YlV4zsvsP1qj1vOm+zT9KaKNt7PIQbeMbrr8ONyl1IR4N5msXT52X5v8ZMltbodJxF+4SBzswxNKPbyR4cy6VZe7jTnhbppnNOGooB6PUJCP8Cvrr/vss71f+PCkF34Ysb6Vdo8t2hdOuE1tzuMp6zetqC16ueAopLvNOEr+Z5cLh9G+OMbn7Z9H/+q4DRSvn+VPY0rJgEMJx2foJtbRlMT3sOkAlTM7TRzBGKWvx+O+goxtOPEjsPzybZtABore01HKt0spgKdR7w=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(376002)(136003)(396003)(39860400002)(36840700001)(46966006)(40470700004)(83380400001)(9686003)(26005)(47076005)(186003)(16526019)(426003)(336012)(40460700003)(82740400003)(81166007)(36860700001)(356005)(40480700001)(33716001)(86362001)(82310400005)(70206006)(70586007)(4326008)(8676002)(478600001)(6666004)(6862004)(8936002)(5660300002)(41300700001)(6636002)(54906003)(2906002)(316002)(53546011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 06:23:26.6044
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 026f9415-164a-46a9-123f-08da8b19507f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4287
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 09:20:39AM +0300, Gal Pressman wrote:
> On 31/08/2022 09:13, Jakub Kicinski wrote:
> > On Tue, 30 Aug 2022 13:12:37 +0300 Gal Pressman wrote:
> >> When CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled,
> >> NL802154_CMD_DEL_SEC_LEVEL is undefined and results in a compilation
> >> error:
> >> net/ieee802154/nl802154.c:2503:19: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
> >>  2503 |  .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
> >>       |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~
> >>       |                   NL802154_CMD_SET_CCA_ED_LEVEL
> >>
> >> Use __NL802154_CMD_AFTER_LAST instead of
> >> 'NL802154_CMD_DEL_SEC_LEVEL + 1' to indicate the last command.
> >>
> >> Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> >> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> >> Signed-off-by: Gal Pressman <gal@nvidia.com>
> >> ---
> >>  net/ieee802154/nl802154.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
> >> index 38c4f3cb010e..dbfd24c70bd0 100644
> >> --- a/net/ieee802154/nl802154.c
> >> +++ b/net/ieee802154/nl802154.c
> >> @@ -2500,7 +2500,7 @@ static struct genl_family nl802154_fam __ro_after_init = {
> >>  	.module = THIS_MODULE,
> >>  	.ops = nl802154_ops,
> >>  	.n_ops = ARRAY_SIZE(nl802154_ops),
> >> -	.resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
> >> +	.resv_start_op = __NL802154_CMD_AFTER_LAST,
> >>  	.mcgrps = nl802154_mcgrps,
> >>  	.n_mcgrps = ARRAY_SIZE(nl802154_mcgrps),
> >>  };
> > Thanks for the fix! I think we should switch to 
> > NL802154_CMD_SET_WPAN_PHY_NETNS + 1, tho.
> >
> > The point is to set the value to the cmd number after _currently_ 
> > last defined command. The meta-value like LAST will move next time
> > someone adds a command, meaning the validation for new commands will
> > never actually come.
> 
> I see, missed that part.
> 
> So, shouldn't it be:
> #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
>         .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
> #else
>         .resv_start_op = NL802154_CMD_SET_WPAN_PHY_NETNS + 1,
> #endif

+1, I wanted to propose the same snippet.

Thanks

> 
> ?
