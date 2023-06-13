Return-Path: <netdev+bounces-10299-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA64572DA68
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32A06281030
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E473C22;
	Tue, 13 Jun 2023 07:07:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640C01844
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:07:02 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E3719A5
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:06:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLnnWW/19v+cgECiph/io5uzMw/OKYNoJ3pUM8mw3us28cBjkg+CuGZgu7gET/SSTTW2Axvu9YjCIns6vrQzISylRVwu87MIHIgDo3JB4vEjmFozFwwiT9cQI/wlwFGPF8HHI+A5MGvqZp/qDNSdsw6/6woQZTeA1kQX6mUjVh2n8tUR+mkU9+wAJRtG9yl9GCA8X1hFPXJfjmG94TTPe/LnCceqwrYznLwPF/MGDw+qi+sLPJnpS78egatc+8IxlKqguAlugCP9LvjS8WA1nRjkv29m+fW+ttZ8L4Pwd+EgWziA8mMNBB/2y4bt1aGk15YCvMFPjZmOm4pAUL5Dmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZdbIOcmkewVCI+s3d5SeBcC/tdtzhpBZRhuevqo/fg=;
 b=Yy/M7Xb91mFEz9LRzloKuObUDDLaV/nue0wFQRjMMaWQ21dl87crN0DWhV0sZDpELv/Tp/DlP4ReoQRhmizo7o3hORwO7SiuCAsEortg8X4hHzh384PiSjRovbqwxUyID/Z9y3qhr3fYefYeQn9uLRSEz5JnaaLcbvPLsXyHgoRF2/qN696guq7Tgv6RI8NizlWbBBhRiBoGjj6VNSraBIULkk7aXhqZ/W1KoiPP3wmYe+4kx3xhZmn80AKfdTIyd/6wKON++E1S3fftKXVKptnNKN/Kz2MJ3pYYl9zjtbqKvMFevRdVV+Bp5c6SfwW2rqWoqNo/88AWUW1yvo9xRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rZdbIOcmkewVCI+s3d5SeBcC/tdtzhpBZRhuevqo/fg=;
 b=dpeAsXk8mTMpaYoUZTO1cI4Hv1JxPyhbVHHK5HQHVNLCDKlqn6BMP2ZI/fExPxDWQ9vVLvqNoiR+nxY14PIIeY4NjOJbXo3Aums+e1Wcwgh3QowSgpKpBbdw5YwyfrB5cTZDSUcvUJv979ektNyIvvNYSHi0mZrtWrB8grICT+572OH1uE+BZheip/n4zlGbAy1rlgCXpcvl1UejXlEuYdn1hqm3BFUIMdYodr3kvEfJn17C2KmO6OOCJh1nTWcWCbWhZ9aN4jw5KsOgy2I0yvL4BRmTnYs4a1CaO1NnWWYmVuZFs0DArBJSVR6w6tZ/SbX6W8aN2IdwEwCcuR7kkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SA1PR12MB8697.namprd12.prod.outlook.com (2603:10b6:806:385::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Tue, 13 Jun
 2023 07:06:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::66d8:40d2:14ed:7697%5]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 07:06:46 +0000
Date: Tue, 13 Jun 2023 10:06:38 +0300
From: Ido Schimmel <idosch@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: mkubecek@suse.cz, danieller@nvidia.com, netdev@vger.kernel.org,
	linux@armlinux.org.uk, andrew@lunn.ch
Subject: Re: [PATCH ethtool-next v2 1/2] sff-8636: report LOL / LOS / Tx Fault
Message-ID: <ZIgVfgtmRSAlnA9z@shredder>
References: <20230613050507.1899596-1-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613050507.1899596-1-kuba@kernel.org>
X-ClientProxiedBy: VI1P191CA0014.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:800:1ba::14) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SA1PR12MB8697:EE_
X-MS-Office365-Filtering-Correlation-Id: ce7879d6-8848-480a-3411-08db6bdcc00b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LxxQAzELKnrBBzmTK/QoYdVfku0c0W/AtQ5pbYBozLY6y4JsJDTOoWY5En9k6l8b5MNiru6F3UC1sWKTqRge9fIRMlbUDqE/dY1Y8rioTPiGDxNuJ1Z3SGh1TPmT+eZ5RHACcqJyNRKdiAs3du/UrkdB0X1dnlnhWeotaLP53XoDXtFLbJuZN5wxxviM3ruS3y2ZQiovgwIPdAuvbsbnb4KArKCIMG4VrBUUxfR92S50Wv7Nr/uhy8m8NVIkceTNYhQ/kEQzz1imwR8aBdXSIkCUotN4gWoQS0Qaxo/UFXAu/yqOOEuhqkytM45o/npYp08NbeWb2CxVWTxSzPmRv70f46/eYTEYZm9UVmQFNl3JN7ogufP3xsmVR/B2bnU3K6zjFgb35v2OtqwPXnu0nd+VB6a+j8MV68SfJZBwDbxIA63aaNMz1eNtxW7XYHWtDIivx9QW9WYcm+Uk6x524QpStAWXISC8flu2wkVrHccQFrnJWqtDq47EtRuh2Qg9AzqhvVsYFWrLxzuU4/1VMoUbaYHyMV3T99MoUY252ghqLVUG8wLFcL0cRBXELPTs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(451199021)(66556008)(66476007)(66946007)(8936002)(8676002)(5660300002)(4326008)(6916009)(478600001)(6666004)(41300700001)(6486002)(316002)(38100700002)(186003)(9686003)(6512007)(6506007)(83380400001)(26005)(2906002)(33716001)(86362001)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5QkkFCIO6R18kZMiT76rkY9fP06IuDt04zFiWUGudUeJV37W12vPLl1txAoC?=
 =?us-ascii?Q?ST2mz5Z3Jgo7QVZ4MX6TiVoSdsZNsvF01PJZ+PUHR8PX5GmASj2gjzFgcvSI?=
 =?us-ascii?Q?lPJeV0i7LcuxoxMexv2gcvE1yV9/q2r/7ZcN0q8ZZHtsOWwYSYCylzOwuOji?=
 =?us-ascii?Q?5Uh4ssJojhanSVEHr4K5DYav+fqDIKsmvB7AvX0yt6fFXBRd42lTgbm2PWJi?=
 =?us-ascii?Q?wy0RFX0wSN5Fg6hZN6mhDyOqwsZ6bQ9rKcAH+CsBLiixWKpMk4hW0Jkz5aiv?=
 =?us-ascii?Q?CNs6vko6e/c3RKOHKp0BHSnEmOuXNmaBFhyuicNzoNGTvWP3Rgz2h4Rutyd6?=
 =?us-ascii?Q?jWjCqDod/RI+Us/bnDasjofadN0mMuPlsvPIdXfTfaMdx/339oc1T6Kf50ZW?=
 =?us-ascii?Q?OVN5pi3Yb13mPAGtDwhKAvTrOjg1kCrbwGmRdQovtgDVtFWjCllFVmh4Kmux?=
 =?us-ascii?Q?FGFGbo2fZwkI4FPgUZbG0SOdVIoxc0iZxOsq5YTDhhXuVmVd650/LZMwozwr?=
 =?us-ascii?Q?0IE7Q7f3PjNTNzpeH5t82GVNDQO181SY5Sq6f59Mv5qkanzEkh5oNrTemfjA?=
 =?us-ascii?Q?aErnFFCzzX+e0uQwCeS6dQHMLzU1rlowXokmc0jv87CeMU5ZyWqDFNNPmYdg?=
 =?us-ascii?Q?7ermt0X2NZsJUCDN6os3+jmgSx+OuBzT5/tJNXav9UeT6zWIReeJ3wEyrr8a?=
 =?us-ascii?Q?st6nvf1u96idwiN6x24ZQa9hEVPsi7KvpfQOr1LYj/cHl3jVKFu9qb86qmNQ?=
 =?us-ascii?Q?AW4V3Q07QwZj05LwHK2Z6IzJJ4gc+YnYCPQXq2tVT+kvxe0lXi2Mhx6bS1oj?=
 =?us-ascii?Q?4RkKdF6MwH9lbXoGttM+zccV0GNVRvDez+JaY3X2kdSEMncga3dzYnf7QyVn?=
 =?us-ascii?Q?ZtXLh4sSgRuKl/wjMaqtKIgh4NSq/2bQJSrANxjU4MdEza8AzA52EluOOsQ/?=
 =?us-ascii?Q?vm4pmEuFjljTbVlB42jc1uMnJcWGB3jfp5nuDmNYhFUtEL37iWfe6l5OeAgH?=
 =?us-ascii?Q?O8nn+WpNtHw5ZjmUBHnCSesixumbKGpKlKTe9QEYnu9m3+Cfiglj13iLZqvw?=
 =?us-ascii?Q?ZcD+2rDrNGVgQ2BeRMer2ao0nZXpS1EmNOPogHlb3Wu+TyttFTZBVWNLtAYI?=
 =?us-ascii?Q?zkc88xLQeTyGVehiP38EbfEBUBrgG443bW+yqjVe6/JB5RFZ1Vx//iliMkOB?=
 =?us-ascii?Q?pZVbM/Ob4WqGJ/kM6uxwnPZXCjf2Q+ChkWQcqxw4g3xHJTk6wvN3kmJNGYwP?=
 =?us-ascii?Q?my7er2Hd2UUL3jcMRm7pwQ5mAGvxTmoQXbgnRUTg5hDsal5djbK4U5SnDOXV?=
 =?us-ascii?Q?owktrAOfhOLjMWRedRn/5waBflxOAgMW91+cZXfEnJLdqnbCPNMa8LZWAQRn?=
 =?us-ascii?Q?hxJT/EXrKCUMsJ8SYoZaZ6VXBvII3UG2FeErmpxVTHffETfHMW857x5Rbo1b?=
 =?us-ascii?Q?vA3/AMQr0Y0nlaWwUTyZ8whx8KyUtV0kvwGjxOeivF3MndvwKy5ECoGG4RQ3?=
 =?us-ascii?Q?NPXCLneDmAKaSI4SuINZZW7KMNU4NVLWOAVzmOMzMO2MdWTLSmTBYQJCsEm7?=
 =?us-ascii?Q?haExSqjC70L/akSbPRuvpDXh5yJXplzB0Xq+35fk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce7879d6-8848-480a-3411-08db6bdcc00b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 07:06:46.2941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnxbXM4nBnmiFDBB6zK9FksokbhYC6fhi8gQTooOadbqmsib3xbhDVbhZseDYGiINmb0eFxxLCdtuMsYaeLiVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8697
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:05:06PM -0700, Jakub Kicinski wrote:
> Report whether Loss of Lock, of Signal and Tx Faults were detected.
> Print "None" in case no lane has the problem, and per-lane "Yes" /
> "No" if at least one of the lanes reports true.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

