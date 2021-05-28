Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68877394326
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 15:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235301AbhE1NDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 09:03:51 -0400
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:18304
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234853AbhE1NDu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 09:03:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AgVHDKG1ErDt4rFjtOpYKxlTg0p1kE8Umi9sfWEDQCVJounDH/gOWzl2dBCMdujEJsiSkqYeG5j+5xHgkiZVHzUyVTGGiSTCyoB4LLoWNHmvTmGFhqsKpuxPxLdUl1II682dsqA8xU0/fSH3Fg9GIYmS87UNRFPnGp3YissmjL4cBNjN8LhygFGUXqGOfRuGU5ODiCMdmVRAYobXTv8Ct9tZzcz9jal1z5EkYYNmGpwuOxOXQ05hyq3DWtzuK7hy0G5BEsV4G1abbKUMvIGLPdxCPNn22TXEn/l9d9oj5JyMch2baD1NpkmxfJAopRmH/NCrId44i/ImBDkqiSjt6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzB3jQRRkoEVhoWlXiRyMTJGVdF2RyypfwWFei4DlSk=;
 b=WQGVW0v572lB0Q++Br+eXfRuLEN7uwgF7joS7rQUkdgeLgSfyUQx+lPPHyiLLwCX8oePrVAX73Lz2M7SzYCLykBNJ3DZ1f0DO/p9R/OaQvHlvoT31Q5UrBS6RwtIA3Q3Z6QeHGGHVCRROXxkVxv2CJYP48PZydx85c3T6FkOeTFdA0DXTCb9mLfOqMD13LuSAnc7HPbXfCFCuFrCIpvZtZeCrz2ebkLmhOSYjj2gqjtM86E0Cj7FMpsSF+GoJSP/S/3NkzMRWNTPgLsxHBMN1GVUh3y0VzIN2r+8J8xxeBIeUAmyD5Ca9Maa/277Cn4cItZQSR4wf41E6mXI1X6UAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzB3jQRRkoEVhoWlXiRyMTJGVdF2RyypfwWFei4DlSk=;
 b=fJJRROhdXVyfpu0xMNW3wDrkIpUPv8VYuZ2fmraS/raMSSjaQHIkyLNWeN0mkStc1R+W6qBriLSAoWr2KYFrukbZfjL07sI7tVmRE1XRRJsAoZ8Qw4EdIYIoaIDgV7nFS6BhHRnADrSRlA2XvM9OaB9jyzGMQWL1zRdMW8+Vnb4p9wk0dxBlSrjU8LQSaxyjV6c1E8Ke41VF9RVg6qn7Cm/EekotJG7lJnxgxzYXUUUZ8jU6dy2Mu72WUGc6eFUHT7UF48mdB7FrGz78l1rt/zzQ5Qpvry4qUarvSFwQ/NP4dfXuVF+zTEP5awRH1pzJQo4nNuGyUjyhQXnW5+mP7w==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 13:02:14 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4173.023; Fri, 28 May 2021
 13:02:14 +0000
Date:   Fri, 28 May 2021 10:02:12 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, dledford@redhat.com,
        linux-rdma@vger.kernel.org, leonro@nvidia.com, davem@davemloft.net,
        Dave Ertman <david.m.ertman@intel.com>, netdev@vger.kernel.org,
        shiraz.saleem@intel.com
Subject: Re: [PATCH net-next v2 4/7] ice: Implement iidc operations
Message-ID: <20210528130212.GL1002214@nvidia.com>
References: <20210527173014.362216-1-anthony.l.nguyen@intel.com>
 <20210527173014.362216-5-anthony.l.nguyen@intel.com>
 <20210527171241.3b886692@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527171241.3b886692@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0245.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::10) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0245.namprd13.prod.outlook.com (2603:10b6:208:2ba::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.10 via Frontend Transport; Fri, 28 May 2021 13:02:13 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lmc7w-00FwoE-Ss; Fri, 28 May 2021 10:02:12 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55b9d26a-3d18-4a44-c0d2-08d921d8d032
X-MS-TrafficTypeDiagnostic: BL1PR12MB5304:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5304D656AEEE85E3C5209098C2229@BL1PR12MB5304.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+kn+gRxRiJalqr/zB5XYe9M85QqQmCFfdBt1HSUh2CE7lXrnhcjgYNNEiqELbuDrhWnferB5JX695nnUbCiuPoYVuCm5AyEpIM04TzKnBH51pHlVc7ehViUCe8TQie+JtQz+zJnL3LxAMG1+MRCDt0wYByaxBD4moHifzqSVDngiSqsr59xme3JhP54Lh0WVRX/3CGM52P/CahKzoI6yKwC6TproUjR8DZyWjtz5tQOaG57y3J4akSItm7r4j+PRJwIgs+4U28tyEtGXFbD8lIV5eGuELx5FhYjz90lS8xbY6Ce1WCAxZzsdreMHJeD4OQGVu/1n/YkY7fR+g3D+U4yl7AKWUFc2bflZh31fvS9GC4qiZhj6QvNxqOepe6yAjxMNsm8DQgghn9pdMqbdptXPgpMpBFdAybjLGoVKCJK5qR+MwUup0WUAPkZl7n4mOl5Hf9oEyUncPKHoN6rYh9wCeV/kSNGcFVYcKxY+Nm4Spv+0ax6knafN4MC6VXmqKe94w+WV9jQGyyMCL+2c0LYKIxtf4CkbCPxBXpaX9PIttlAragi2LDkWi194gqZ225NOWlwLUZNx2QjNAtJQkzlxZIVYAXmF3lbg695kEk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(2906002)(9786002)(9746002)(66556008)(6916009)(26005)(86362001)(2616005)(54906003)(66946007)(36756003)(4326008)(66476007)(5660300002)(8676002)(478600001)(8936002)(1076003)(38100700002)(426003)(186003)(316002)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uwJhKU8cvg65+DD8Nm2ymFET34Nn7dcXzDcQ/aJpFWmww9GzVjjJpcqr+iIz?=
 =?us-ascii?Q?5Ke8Kn0yGL+tPCvUwMwihvINal/DAhLqh55zCr3uEQbP0Hy2WHdadM/nn53A?=
 =?us-ascii?Q?YDTfxCrMX30tqW+0t2RNCApRFJJ4VHGLwjHjn5sGXWMEZBADEKZ08LTcKoYr?=
 =?us-ascii?Q?lr8c1UzvEpwP5vmR6RiZdNWP4rxyx8foPudyCgL0uX/yKQJ7XkJ4Ul+AnY9n?=
 =?us-ascii?Q?XVTR6N7xrJRqPj+p/TFbYNsCBRX402Wa6+RWNuN0tljFSM6OcVeunmGTBpzL?=
 =?us-ascii?Q?Vw8F/blZiOkZ8d7RtHELSqlUPU0IG3hriBCmmTQYCflcCILw9IxfSSDHxSzB?=
 =?us-ascii?Q?3jc61pUDQPTCG+rJiLEKUrpYe/ExasAkZXlRiP6LkoVJDb76NqPTY+WIMYgq?=
 =?us-ascii?Q?djEvVRfOy1G2uKcsOGJCpudNe9US27gfl7q/lP27zSbIHVKsH1DvwfsB0IFl?=
 =?us-ascii?Q?e8adHC9VqgMxEQr+J+uImDbBiZ6IumIOIxs1MRr7+MPIrDAB1ya3spxma9mx?=
 =?us-ascii?Q?zGFK5iH47XqXXtNPEJm72godoM1Vru0v927A57UJP+bz7iVTCHHQ1N0Za/vB?=
 =?us-ascii?Q?rfdr7t4rbC1uePqXcTU01yzcbShuHj79jbXBeMj6hDw30F7lgkOMRi1Q675i?=
 =?us-ascii?Q?zj6m7S+wPRpDvqlmt0NqASxwe6ABwXEYRrnyDCxm09T2aiSy5JbX9ink4YYe?=
 =?us-ascii?Q?zOIoO7X5TUIWk5X/8WM/0lEEJddQFDz8qOnIQ12sRa4m8uQuqYH3jiC+IeWB?=
 =?us-ascii?Q?xOK4toicVaJlyYzVKc0s9KMgmnL5XOWv/OsVICjnfM23z/3+xPhjf8xW0C0t?=
 =?us-ascii?Q?0KiTkuL2B9Ed0vQH/6W911+uyr0hHf+Kh483J4Tv6/m1OmS/9lwaUDi+JQGl?=
 =?us-ascii?Q?HS06M4mxc6x1zdRpQXjQ/8J14oTxh2B7rvE0lknSAKSlKtvb/64nnyPdQGIK?=
 =?us-ascii?Q?ochapdiNwp0Ehodm4NUqZow/9GGNt7Y5S1FQ2miLZFHIHE8CZgWE351xxXS2?=
 =?us-ascii?Q?P0sNQ2Af6NU73+3MbenbFvjBqjKIbyAPf+4gXui6kpTRx1NOQ+Yc7slcRLnL?=
 =?us-ascii?Q?9XQbCeI13T2yVA08/1BVC33Lvrcto6I4vS6nRGY4gMqE0NzLA1Oqnq2Vd+tY?=
 =?us-ascii?Q?aupBf7yC+D5lSYieQWeb1U/nRc0uT0ZpPIzCxHbMnBEnXc5UcmUmQMm/WBEE?=
 =?us-ascii?Q?mg0efIHU/E2jetklQfQyQGVeHA/qfif0MirR2uM8DJhbv7JRMpwU+9FjBDs3?=
 =?us-ascii?Q?+QmfJaa9k+721pyg/8ZO8/j7nvbK6VbKvkLk4+V5DIj7LJKHnxfLEIM664zY?=
 =?us-ascii?Q?8SgDRWhV1C27XvUyKwlXvn/p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b9d26a-3d18-4a44-c0d2-08d921d8d032
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 13:02:14.0709
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0K1LqrHDnDCyB2n2RmUAAvkT5u874r2r4xQFjsKEK63e81K3nSzuk0VtoNJpV6H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 05:12:41PM -0700, Jakub Kicinski wrote:
> On Thu, 27 May 2021 10:30:11 -0700 Tony Nguyen wrote:
> > +static enum ice_status
> > +ice_aq_add_rdma_qsets(struct ice_hw *hw, u8 num_qset_grps,
> > +		      struct ice_aqc_add_rdma_qset_data *qset_list,
> > +		      u16 buf_size, struct ice_sq_cd *cd)
> > +{
> > +	struct ice_aqc_add_rdma_qset_data *list;
> > +	struct ice_aqc_add_rdma_qset *cmd;
> > +	struct ice_aq_desc desc;
> > +	u16 i, sum_size = 0;
> > +
> > +	cmd = &desc.params.add_rdma_qset;
> > +
> > +	ice_fill_dflt_direct_cmd_desc(&desc, ice_aqc_opc_add_rdma_qset);
> > +
> > +	if (!qset_list)
> 
> defensive programming
> 
> > +		return ICE_ERR_PARAM;
> 
> RDMA folks, are you okay with drivers inventing their own error
> codes?

Not really, I was ignoring it because it looks like big part of their
netdev driver layer.

> Having had to make tree-wide changes and deal with this cruft in 
> the past I've developed a strong dislike for it. But if you're okay
> I guess it can stay, these are RDMA functions after all.

I don't think it is a "RDMA" issue:

$ git grep ICE_ERR_PARAM | wc -l
168
$ git grep -l ICE_ERR_PARAM
drivers/net/ethernet/intel/ice/ice_common.c
drivers/net/ethernet/intel/ice/ice_controlq.c
drivers/net/ethernet/intel/ice/ice_dcb.c
drivers/net/ethernet/intel/ice/ice_fdir.c
drivers/net/ethernet/intel/ice/ice_flex_pipe.c
drivers/net/ethernet/intel/ice/ice_flow.c
drivers/net/ethernet/intel/ice/ice_lib.c
drivers/net/ethernet/intel/ice/ice_main.c
drivers/net/ethernet/intel/ice/ice_nvm.c
drivers/net/ethernet/intel/ice/ice_sched.c
drivers/net/ethernet/intel/ice/ice_sriov.c
drivers/net/ethernet/intel/ice/ice_status.h
drivers/net/ethernet/intel/ice/ice_switch.c
drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c

Jason
