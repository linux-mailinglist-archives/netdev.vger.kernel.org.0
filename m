Return-Path: <netdev+bounces-278-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 999696F6B1C
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 14:23:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3908280D05
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 12:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40812FC10;
	Thu,  4 May 2023 12:23:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D635FBF3
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 12:23:24 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8891F5FFF;
	Thu,  4 May 2023 05:23:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1374J21mPbNjA29/d3CSzTye/LojxouVALIc6OejJZxPujjdnpngYL+FfsD5ikXrBgY4WV+nEPLr+jaxjxdncV2GEpob95zpOh/4Ot2X9Y3V3Ch4f8ekldfVVakc6YiIVxiYOqd+w/gWTfGhFt5772g7iTvdPYVkm076j+9pbwJ+FpmQY8/8l+npi9JR+X330ZNlsHyl0ltRFhpcsqcCneKjb3teQAZ1m9xqM19H6rZ7ari5m94yuiccwcl33NdeZn1Fc4mwDDIC/JxXAeQvAWddaAWlmdgzuBCY5BmtiZ7DO9fnEUV0EBk2mleth+QL3Q0ygk7vzMF0gSX53ZPgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJNtSYSQwvU3ZQfWsmt7ngegvYtfWD+rjVkQWZXafD4=;
 b=ZAbbVITIxyKSXtvXhrheIElHEvt8VFkZVA2OoytczVYAOYmrByCkJkFR4L8wF0jliWE/0mlKTF/wBOeifR5yHiMk9a+Nh9bOOTazPw5h08Ra/dDyq4R1q1iQL4l6LzbqZXvW4XzG/PeO9Gnqe/3ddFfbgoHMp5H1ojo8UkBJw2Ep2qTYeaDT6aoozwPse24hCVdeCj04Mg5v6Q5wQAUEsb0nHPGGBV/FyOWbwdIK6LsWlICHBLQYFnp/oZWBVjE2X7qBFaN6zaWeZxdMaVVwgn90yf/SnwM/iOQNhFx/BGd+bDL7FTgjiNhyoDc2GA6lS+2Y1jL4LLG5HLi4SNsjGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJNtSYSQwvU3ZQfWsmt7ngegvYtfWD+rjVkQWZXafD4=;
 b=JVGlZFMbPFHC190MFQl0yH/a9wDQbmi0h/r/G1p31wpWu5Sq8Rho80dYXJ6sqLb8J3+G1RoFjmVRhzCJEK63u9LVeDBW/e1QxBL72K8ngoJqqsxZp8cF6ZH5B/PSkzNMzxMT8WZkQgtfEa0diwhiiJ5dB9OyMcr4qlBV3G8nucKIwZMwcLMtwfFmJGUhv0y+QVcKejRbJKYv+8sb8WtBp4x8mwek9qPhbIJ2JyFuhsdwhfC896y7Ji2d7brH++8JO11u8e2ceH0DGxW1KInqUznEN5Q2O4QLpaQ5YmO8YiAXR0oqa2f9qM3pQTwk6JUc8dNe2FAPMrqt560jycCDYA==
Received: from MW4PR04CA0380.namprd04.prod.outlook.com (2603:10b6:303:81::25)
 by SJ0PR12MB6760.namprd12.prod.outlook.com (2603:10b6:a03:44c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 12:23:19 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::19) by MW4PR04CA0380.outlook.office365.com
 (2603:10b6:303:81::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 12:23:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.26 via Frontend Transport; Thu, 4 May 2023 12:23:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 4 May 2023
 05:23:07 -0700
Received: from localhost (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 4 May 2023
 05:23:06 -0700
Date: Thu, 4 May 2023 15:23:03 +0300
From: Leon Romanovsky <leonro@nvidia.com>
To: Kamal Heib <kheib@redhat.com>
CC: Stephen Hemminger <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-next v2] rdma: Report device protocol
Message-ID: <20230504122303.GZ525452@unreal>
References: <20230504120918.98777-1-kheib@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230504120918.98777-1-kheib@redhat.com>
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT030:EE_|SJ0PR12MB6760:EE_
X-MS-Office365-Filtering-Correlation-Id: df1f9dfb-039f-4d7c-ed12-08db4c9a5823
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C+runmBNxSFjNApXfycV3yy45JVddMmNuzKYTR7WNekP/GDzmF8ENnv5BeTo/bNnnjxTdFzvlNUySxUyolYslkFbe0AUI8vrOE8a3YJdnzdQkOWR99CSrWmUBbzeStmgn7RjI001fXOKkUaifLAk8p482zl2vRxw925Cxz29SENKM7llgF5U9t9SL9C48GHIh+nIlmcUt7WL4yHuUVNIXaZI1SpdT6hG+Ryxvjh6p6IhBVVtnPfNlzj+85sZW8G3Fjfz5EG0wY4gY/P7PJBSSvszqYokvtjV70Z/itEsd0oLVS6Vi5/FgRMMDgpkZJFIiELyMjTPrbxxzNFnrg7hSGesoO8RivXcwJphqFNrxy9grTm6QCRYfs+oH9ULnKscUISo2HCtoVHNFBdqLhrPdUvAMLWAkFxXSs1WzFM+T7a6zC0X0izxnBqYo04W7fKEKFUPNjoFvDBk//s5OXQCKshK0SczIwz04pl4ho2AQ/DJ+ttlsXvg8xEqAGkeAJtdiTAm+1nnDQa4S1o9KfxGT2MecsxNx8hsmljRQLRlbz+8BCsdggnqHm3Vo5T31zsrFU8luflScBOMKzSHRAw2srLE0Djt6CVIWrMH4CRNTG4UDa+JvSmSVUxt2/k/xdHkaj+Oh7ljezBWZFDlfZ9ag2sPcFVVCsXPnh/+Qkqu36kegbjHtbf+JPDa7hmxbaFBQvQoUqqp0VgjiW/eQFgc+g==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(7916004)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199021)(46966006)(40470700004)(36840700001)(36860700001)(47076005)(54906003)(6666004)(478600001)(16526019)(9686003)(186003)(33716001)(26005)(1076003)(426003)(4744005)(2906002)(4326008)(41300700001)(70586007)(70206006)(82310400005)(6916009)(356005)(7636003)(5660300002)(86362001)(8676002)(40480700001)(8936002)(316002)(33656002)(40460700003)(82740400003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 12:23:18.9075
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df1f9dfb-039f-4d7c-ed12-08db4c9a5823
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6760
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 08:09:18AM -0400, Kamal Heib wrote:
> Add support for reporting the device protocol.
> 
> 11: mlx5_0: node_type ca protocol roce fw 12.28.2006
>     node_guid 248a:0703:004b:f094 sys_image_guid 248a:0703:004b:f094
> 12: mlx5_1: node_type ca protocol ib fw 12.28.2006
>     node_guid 248a:0703:0049:d4f0 sys_image_guid 248a:0703:0049:d4f0
> 13: mlx5_2: node_type ca protocol ib fw 12.28.2006
>     node_guid 248a:0703:0049:d4f1 sys_image_guid 248a:0703:0049:d4f0
> 19: siw0: node_type rnic protocol iw node_guid 0200:00ff:fe00:0000
>     sys_image_guid 0200:00ff:fe00:0000
> 
> Signed-off-by: Kamal Heib <kheib@redhat.com>
> ---
> v2: Use protocol instead of proto.
> ---
>  rdma/dev.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>

