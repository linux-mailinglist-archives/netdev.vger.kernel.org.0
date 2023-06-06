Return-Path: <netdev+bounces-8647-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 781247250A4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:17:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 02A7128103C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09B434D62;
	Tue,  6 Jun 2023 23:17:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBA27E4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:17:35 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851C71BFE;
	Tue,  6 Jun 2023 16:17:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Swp6OUAZNUr5aaw5z7G0TA+3tX0qWJ6kVb9GxKO5RcseVnw6vLOqhOKBckcnYlnPjHtO/UWoUdZNkAYMpPy6u3XqTBznuS1f9Efr4guN6FcIwxJT7OyxPOx2z9EBZDaRxF9VvTJIHBBxF9aZaGskmtk2UkXVNyIEn5DIbhemll/TjyqHAHVDCPmHNgy3EoSQgvD6iEtYRmTDAEH79D2pMD2Ps45h9mWt75ENXTmXGw75wqHV24frPJVMRKdDGMaOrWMJagPmVoez3dDQw6YqPHS+UqVgsMpkgowkDM75iMIODhp7RdXN5hW/k9YCix5cl4SkI69VenErF6m6SLzuUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kaYo/Y1IZ6KVYaHLbIDJUf9dCS6MmBNYkxZV5rHUDeE=;
 b=bYZ7Mc4qHuINVb5TEW0qK4pc2uhylCG3gRv7oS+o0owf+0UYczE4yokCltge86SwILHvX3W8ARjNgm+7BvdrCr5BblDlGvoXIO/mP7boE8myAOYHT0WNrseB0M7gxKTzZbxuQ3/GjpDRTOxrXE/sGe8+w5l3mAFyb7H3faMTlMGmKUjve/kJe6o7KAJ/rbeOKBLb8oJ+UEi2joAk0qNkIS3RvSViCm+OQWmH4mlpM6WB3jtSLdcyZYTM5+lXTK0cHBsTzbe3x8JyhmDIH0nBDdUhivU1xNe/adlid7/Ul/78Cgb6VgM2/RH4XPfTgmUbyzx9kqpornPniQf5adEqTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaYo/Y1IZ6KVYaHLbIDJUf9dCS6MmBNYkxZV5rHUDeE=;
 b=B/QYkHfviADCv0rNBxT6//UZGzDeWndkeTGVHl8hef3uybcsewQpkNW9+ZPzDiBk8pt2eyUb6RihD2dPRUL6gfGDF6zHXEDbrTzdXS3coigkbfh4MZuORFARtsE1eXCwuWCc9TJkFOojNyVcXxU3kU1Nl0Su0x4vMNFev9F0AFK9OnOQswQjWLFn+uL+EzTnX/GQwz+nBW/ODVyDGAjdoa+d/ItS81Jw2TZRWUleGXlowd1ndsA5qmirAdqotBt2+3glgHqRsoSO3bDLnAKb3WhI7ozxpv6ozr83es+eXGrn9om6CQgPMY5wGlTLj2T8NhsgQwZl6Stw7jukebSKbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by IA0PR12MB7555.namprd12.prod.outlook.com (2603:10b6:208:43d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 23:17:29 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::a03a:9b2b:92f2:ff69]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::a03a:9b2b:92f2:ff69%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 23:17:29 +0000
Date: Tue, 6 Jun 2023 20:17:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Chuck Lever <cel@kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>,
	Bernard Metzler <BMT@zurich.ibm.com>, Tom Talpey <tom@talpey.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Message-ID: <ZH++hitKpvcFC/hQ@nvidia.com>
References: <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
 <ZH9VXSUeOHFnvalg@nvidia.com>
 <325C9DBC-5474-427C-9431-19A59D64F28D@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <325C9DBC-5474-427C-9431-19A59D64F28D@oracle.com>
X-ClientProxiedBy: BYAPR06CA0067.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::44) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|IA0PR12MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: a12c43a9-cbf8-4385-19fb-08db66e432b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AAMQQVMkvvD1MeEiWFGUh5PpKbx2gfm+rHz65+4QdASOw2Kj+i7/cPDu6j1xCvtXpyEjl0o38UEsVNUEbLjxTA5xdfTaFyoE8kjX3ezOHraQN/nvxoqxxf7AfUhMDRJ/La6gjQRcW7CMCDbqFgMlnF5QeLB1nb6iTY0mp1bZk0lMi8X80YtCi64WdWd1nJFGPyMi4+nKOjnPHnpgZ3okHXviUuCNHg5lmlnfnmjINEgP2xd0mgK+znDQKhfML8Pp2NY5zyQICxIOn525kZDS6l+pxYN02oiDI45cO8kwv5iusaxXT2f5+GIWTAwdQIErtoshFB2pqrtDIt8pTzJiJux+bliaYdbG2qV3ql/qVAMKnhecdlRt0OfKuVsrsFSVlDxb54P+6LG7IhQ3O/XI9tp5HpRomAvHW73DScYtrWOYPjRGbiAcm48zZxoGRbruFKqwrNFK3JLcKjVoRXn3VBjJhPymjLtOEuuyAyNuNtBskBZChgs3KbqOM2jUqCQ2H/3VUWsAafO4MclM6HWSREhTYIzV1t8b0sbFs0dqOpGRoemzgDxFuJ9AILlRGErc
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199021)(41300700001)(316002)(54906003)(5660300002)(2906002)(66476007)(66946007)(4326008)(6916009)(66556008)(8936002)(8676002)(478600001)(6666004)(6486002)(86362001)(36756003)(186003)(2616005)(38100700002)(26005)(53546011)(6512007)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GlCoJV09weffdZmmAgK1GUAYLSAAgpvdtunq+WJyZCHeYBLlGoeiuxogqU+G?=
 =?us-ascii?Q?77L0UQ2CaDsx/ep/WmmEjNTItYvL724+Bu+YFEBf+HCZsFKxqVp1VDumZNXM?=
 =?us-ascii?Q?s6kec9RjSeWRpCRz6h86SDjUWg8w3LL1UIQPqL1/nT5MyFYky8uLhc6OU0KA?=
 =?us-ascii?Q?1OY1HDpR82Ba39M2K3Vpx37vt9wobQLhQ1WYiSeh0N79SF7HqeicC/PjtYiS?=
 =?us-ascii?Q?5HEjICzQNRslW9wGSoKr3FsINt+SVH2B1alKxr6aUNQhRGs9h5wmS02bOM9i?=
 =?us-ascii?Q?vSKo0Dg1yBQL9890kPGywbUzohKVE8cNuWQs/KslpN0Mws6O7WbAyGPMj/Ai?=
 =?us-ascii?Q?WTmkV5iBFKvDvj/PxizPtTW7gbjjouq+tqdXgCYdkHhqBtyjr/yLjSF85fB+?=
 =?us-ascii?Q?XAU2RDM9Jam5oWJm7x2UDYZNnNhTCwIl9Qu0OX6qTJwpiQWiKMEqfBRhMIjc?=
 =?us-ascii?Q?AIfkow2EuOXFRwL6CxnVoz9tc7PPT7GGqzotgnp1VFJoWANaygBF97b7lH/0?=
 =?us-ascii?Q?yVmYktq0a2778Z3k6qwA6l6U+nOJhfP3kFC3vlpIFykgfFI7Eq/e8Kz30MJA?=
 =?us-ascii?Q?86MpB1hSi8MW+/KQudHlm4522o/klgkaX5doiNW6CEL7PgUDWSlBJd2lo2gb?=
 =?us-ascii?Q?iKVmilm4evLpG5zBjuFrnNA2S1iwGL0NR/gMVypTtVS/L0s+KrlZDbdPeZrr?=
 =?us-ascii?Q?GFikE5ghLVWQKadzYxXvvj6oIuqYRitfDqG5VkyPebRfF7SPdLY0/Xf26sFw?=
 =?us-ascii?Q?AmuHVhlkFAfAjf8X+tc1fmHWI4DzfbpL1zKmq/eeFK5/6G/Fdo+xSBZtbiUV?=
 =?us-ascii?Q?MuHp2RG/d29yJ5bHWDWaYGMfKqTU4evUOdEdY+5V+K4XZH5TmBnI39OIbywn?=
 =?us-ascii?Q?8czWse11E2pPvnBRggNFEb7k3HXHmc4k9R6n6Lenoe660DuGGoX1oWRBDxQk?=
 =?us-ascii?Q?KM1x5dsAHQogOdtQT+nLw8Q7MzgjUZpZeU2ZwYjy3yBI3gtB1sH1lCzZwGLr?=
 =?us-ascii?Q?ZWPFMQgwRx7+KPH8D9Gysliwxwm8Kula1KWfN2jI7HvLLpnddH1QxHsPDGSX?=
 =?us-ascii?Q?LJ939Myiy+sDwFw3SOZ0NbqWYJ6niyqHkNYGGulVc5VHi2xjfejsu92elkA8?=
 =?us-ascii?Q?wolMkM38kpQ3E2LYXwFVAzeVAXW/X/ANaRkmr7b1dvE0COCctTGeNuLRBnD/?=
 =?us-ascii?Q?rEwae1CjvhwtTl3VeTCbkGjUyAtAResBh7m7632bHm6b3FiXXvXwJEOIU2yx?=
 =?us-ascii?Q?4QMUPrYAJZ0PEB7+jfGO5qw94Y+o61swvdQOU56rHW1QDksoYjCg0QYiS66m?=
 =?us-ascii?Q?0Wp3yA5OYXg19iPjaxsWmryZVNbgHCfB3UeRvFxgwxQDshlciwYgwV+j/PoA?=
 =?us-ascii?Q?mSNbcly+b2521LcRdYr8BCtxGYpHKWVpuhq6deZfLnsZRJYB+B7Xl5sMtlfv?=
 =?us-ascii?Q?e6nkDocGTfMCNmxA13PGAVfdv+A2B/EokAl/2OKq2LmF7Pg48pdxw/VD/GAx?=
 =?us-ascii?Q?biXL+0q0d0uGsYWBObxsc6KBBauXUCJ2HgE0SmkSUtx08GQgCUrf+2Pvzu1i?=
 =?us-ascii?Q?C25+n3HSZt45CmqRmXmRnyrT5ZY+Rw4SSYscdkSM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a12c43a9-cbf8-4385-19fb-08db66e432b5
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 23:17:29.5218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CHdqX9hAXYLBEOoUfBnOfua4ROnoxYjBpSkn3p8T3GYrgmusJP8RS6+AC8Y9DJwR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7555
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 08:15:36PM +0000, Chuck Lever III wrote:
> 
> 
> > On Jun 6, 2023, at 11:48 AM, Jason Gunthorpe <jgg@nvidia.com> wrote:
> > 
> > On Fri, Jun 02, 2023 at 03:24:30PM -0400, Chuck Lever wrote:
> >> From: Chuck Lever <chuck.lever@oracle.com>
> >> 
> >> We would like to enable the use of siw on top of a VPN that is
> >> constructed and managed via a tun device. That hasn't worked up
> >> until now because ARPHRD_NONE devices (such as tun devices) have
> >> no GID for the RDMA/core to look up.
> >> 
> >> But it turns out that the egress device has already been picked for
> >> us. addr_handler() just has to do the right thing with it.
> >> 
> >> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> >> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> >> ---
> >> drivers/infiniband/core/cma.c |    4 ++++
> >> 1 file changed, 4 insertions(+)
> >> 
> >> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
> >> index 56e568fcd32b..3351dc5afa17 100644
> >> --- a/drivers/infiniband/core/cma.c
> >> +++ b/drivers/infiniband/core/cma.c
> >> @@ -704,11 +704,15 @@ cma_validate_port(struct ib_device *device, u32 port,
> >> ndev = dev_get_by_index(dev_addr->net, bound_if_index);
> >> if (!ndev)
> >> return ERR_PTR(-ENODEV);
> >> + } else if (dev_type == ARPHRD_NONE) {
> >> + sgid_attr = rdma_get_gid_attr(device, port, 0);
> > 
> > It seems believable, should it be locked to iwarp devices?
> > 
> > More broadly, should iwarp devices just always do this and skip all
> > the rest of it?
> > 
> > I think it also has to check that the returned netdev in the sgid_attr
> > matches the egress netdev selected?
> 
> Both @ndev and sgid_attr.ndev are NULL here. 

The nedev to check is the dev_addr->bound_dev_if, that represents the netdev

It is some iwarp mistake that the sgid attr's don't have proper
netdevs, that is newer than iwarp so it never got updated.

So, maybe it is too hard to fix for this, and maybe we can just assume
it all has to be right

Jason

