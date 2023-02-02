Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5896885B1
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbjBBRoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbjBBRoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:44:10 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2058.outbound.protection.outlook.com [40.107.212.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D23F750;
        Thu,  2 Feb 2023 09:44:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j68gxn8hwBSP+R6li3eLQca8lEP3l6zrg0sO/bIbBANLgUgL5ZnCvLw/eRmIja2X8waZRvuMT2Qt0m1PovZAy9n/G71zGV4f40m8aLsHY8sC/0UJtX0TZQjmb0oNJix6ZTCuoLSiVGu8zQrZbCryeOF43Ei4wR9q9pY+U2i4ej+jGzKpZC//JZ83p+DIhfKM1yNSW2jZXWOP3kSI6k3Tvgx30AqOTSje5rns0kj/wR2toitv5mBZwlMAB6EdtItQwpNqvO9u60JC2E7Iki0V0CuJCDpZ7Ey6/2GdWhQ8w58XPN4OMyRJoy+uZmE2pDn3ZKSgLLrvKMbkYMlR1S17Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ys5hdXAIZEh5aiqSuOLThaZHHcgU/R/8gXuaoQ+NCkE=;
 b=gyZQc+fEp9Sbb4RIMlSHm4ZgOm6+pBQJ1/iL6F8qF5yHP/yG47Mh5KXoFIA8pzQkqz79iwbqVD5HYYy1ZgOK0Nk5sjEU0h/I6fYM9dIHPsWyQpmKoBvjGAbDXofTivCcQny+DD10SWZYICaSo8OCn6ggTmDChOLzZ+pOTraFS23Z0XwQvxngzYZjCZVQhYg+gVsZCdW2+VsNqcwoTjb27YrXAGWwfB2MnvNb81FqxqzOMNbnj/JFo7/pBxDo2C3E9M2k46UspDeF/LCmyLz8dr3a1Z31dp5VACXRl8NwcXgvdw1sKHVl/ph8cLXLnV6fBkRGDqDkWZsPGJs2dzTqbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ys5hdXAIZEh5aiqSuOLThaZHHcgU/R/8gXuaoQ+NCkE=;
 b=VcyDsWFCu7LsUcLAoj4sih3wFUAtcHxMKJSKBaRSZWq+wt7oDmLJceeKtn2gvdx9+kDNIA7S1UWBQw/5vbFJ8Q9sxpnCQlT1MgVJ3dh6N8pbdRjf85YgqplpynPtxSs8Wz21Lbk25+O+INf4k6zfmkbeOZCiSgPzpFF/NXnmKYk7seBgTpKvdwEyHKNCSi1hTpnFXQUQbFgzsplJqovirHNz+FxZg3ANmi4xOsGph/Lw/Ml+otUk9l/I/d33jOBZ6tP1dM9Yz7xpQNhWq+ziWFIqLmN/HWBvO4arbPCNowwOdxT+CZjitJI052zeGtpaY63jVVHCR9vMDpjbaFclpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH0PR12MB5058.namprd12.prod.outlook.com (2603:10b6:610:e1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 17:44:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.038; Thu, 2 Feb 2023
 17:44:07 +0000
Date:   Thu, 2 Feb 2023 13:44:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y9v2ZW3mahPBXbvg@nvidia.com>
References: <20230126230815.224239-1-saeed@kernel.org>
 <Y9tqQ0RgUtDhiVsH@unreal>
 <20230202091312.578aeb03@kernel.org>
 <Y9vvcSHlR5PW7j6D@nvidia.com>
 <20230202092507.57698495@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202092507.57698495@kernel.org>
X-ClientProxiedBy: BLAP220CA0005.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::10) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH0PR12MB5058:EE_
X-MS-Office365-Filtering-Correlation-Id: ddc39ad7-309c-4904-5f5d-08db0545150c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0DC1aKpVtJpPnF1RHFiYPWlEPoZ8JWRLViwNpqswJO2ItvT0mN/uSJ8RN9s0Bpge6WPocb/V05xVDGmVr4FVS74ujW/Das37NbN/Y631emgpVaLlrQoE+eng8kkK5eFnpO8+dLwg7rOSFWtVROWYQEQd9Uudk6YiC5k7/0WemuAMY6llbPeM9zSeEuynYlNGSxnHIwMTSkqUgbURvtYgzK+vQj+W7eo07Z8MhKLJJNO45z4MJYaTpXKusp5N8NKjnCjbhD1bzmyh7C8qlcZgu6iELdMHQsBnbZNEPvDyM8vdLd921xeeIX0Y6AAYkQXmwFb4FL1GW57SjgO2jNFpYeq7lIFjvaxED2NtYofnJ5mCQaxlskr8ZSbeD7KOq8fcHIt0hqOIY4drlHRH2ceh7JVbJpUjLpzkkSKDM6TUUkGOuN+GulznnMfpnQqDGfbgyd6TLI8IbQhVUSwOmyNV8bEL7U/7Jg+JJfQj9+uUdAlvgAAdxxIyoB/zl+Dh8rokwIMFQQtjSTUTpDDSf+s4CvJx0/m9yWyZUD+ic0nHzVOBz7q4VMSNYN1XGjm40X7+TChFjOKUXjy2kpgm/mKtzhQp0XkPfUBCnEiEyJyblnnjPORPZvTsdvdMITuyCI3X03j+A1TgNsJQpkFEvazl9ek7Owi+WBR8Jk3VpT/uG/RfSck8FluulcQQAj+f+vBozud+8kt+VL015FTH5adl25MOZj0CFRCWeW3A8Y9U8cA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199018)(6512007)(86362001)(6506007)(186003)(26005)(2616005)(6486002)(966005)(478600001)(38100700002)(66556008)(66476007)(66946007)(54906003)(2906002)(36756003)(4744005)(8676002)(8936002)(316002)(5660300002)(6916009)(4326008)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iZNDE1Nymq5mqQhWf0+/+RbWMaYz4pssWf67VBawIAe5TTz3wTFy3GKQUDlA?=
 =?us-ascii?Q?TjRMuHbq0zeoSRcuDITZ98qj3EpUOtaSiHJDS/csxxnRCRvbAITWke0JFRIg?=
 =?us-ascii?Q?4ouBwoyb8NekfoeQr6Zj+n0lDXRmcJB8xIJ5/59SmtqGs+aqwh3WzR+ai2cN?=
 =?us-ascii?Q?Mde1RU9NOo74jVpl9xtzGU4QmuY/PR6o6wyLGW5scTeFa2CflJD1T0lPU7zF?=
 =?us-ascii?Q?rKRvtAsvi+Entl5RInuvXusUddJhEJZ9a5LZQcb1dVha+lqyp1LJpO1273fJ?=
 =?us-ascii?Q?NcNIB5sJN5/EB7lb3yvB5MJJh4f/HmJrZkGCr6cdqd/OjFwJjldNtocGhwVS?=
 =?us-ascii?Q?SSRfdogyjfiQgiyoyLuQkgs5WbRHNJkCmjpbDNwsAcvkHfEZNIRlwpQxwZB3?=
 =?us-ascii?Q?lWOmswLtxlI9byVhRBAptNB6+i5xyKzF4yZ0XJyLTBIxH8vCjoUIH026jq7q?=
 =?us-ascii?Q?cmoJGbzASbA4AY6V77kWxhnBevBwXzlmutaLJFX+DyM+ruJMdgDW7mBTS07t?=
 =?us-ascii?Q?piLCBRdMmHJJHwsy1TYVxsUNnSrBDekRMv71SWMlTDfY97bGDgp2ONbhhVSL?=
 =?us-ascii?Q?AeQN7C8Tfjhg9QCYx7bvZVv5U1AwZC26ofedcGfNQh37oUEsDRgFnSUrhfvz?=
 =?us-ascii?Q?1RZpU1ZtUnqOI0RZ/inmvEGeclpFmk0gdD9pVsKGWEIfKQzdqrz+aJzxW+iu?=
 =?us-ascii?Q?7p1r+oMo0gG5R+AdOvl22eN/7Ssw4u5fu65SgpiwW1eL6IAXgNYn+Mtkx/ZV?=
 =?us-ascii?Q?LuDOwzK+L/xeRuiQ5QOMRnzeieO+yCh+KavHZplEuyVTFUNjuuuPhh518ylG?=
 =?us-ascii?Q?ZjWdbaOG1/h9RK+wJp9AxUJZy9YTD72sQVGSYn040pyFcU8ynu005MS3xoml?=
 =?us-ascii?Q?kzZ3Oa3PTssAok6QQypiWlPsCpvSn1ONcUSpbI4tlYt+GjshmeLPPMrv7JRa?=
 =?us-ascii?Q?h/hXPO7aM2NI6l4syzCCFqNM4AoicDsybdfodiPgwvyPMtoEatEmUuYf7px8?=
 =?us-ascii?Q?PtQ0M9AeczbszZk/IU5sXbGcqGPcnlQ517aGjvSMC8RYb9KCU0WIYl/0NKg0?=
 =?us-ascii?Q?ZJtn9CJYEF5qYJZVN3rvZEPI5JxDEAKitkzdCHs8OSlyw9/2phImPr8pxe05?=
 =?us-ascii?Q?qbgHftW6FV9MVTYBoVttfXlnZmYoBlgmrJaOuorYlRZhTnMUKw7g0/cAw3Fi?=
 =?us-ascii?Q?jqOmcuIn4eaDpGH2ffDa9YTEVBDAJ3zB2JDAS6EDOMuursXEylrQGYGDctj6?=
 =?us-ascii?Q?rKvArYw2BkQx6jyzw90WaijnLkBhXtRUwK6oGJbeyIqz7qoshrmIpHdO/PXq?=
 =?us-ascii?Q?nVtPDZvw+aoW0chRNV2B7IMXd660vriFLzQw476RqPzJsqcQuiHBqQQJ710s?=
 =?us-ascii?Q?ETpeJaii2R0Y5v6nfB9O/oqRxxD98xvv7kfx0dDgiY0ZCVuk+QTC6dbShu2b?=
 =?us-ascii?Q?r8bqbmf/KTbe9YOo4mZcIFVZr+3+STURx+YnF+0aw7xJNplJbAJwJOJTf4t5?=
 =?us-ascii?Q?tSKivyUgq5DKhH8LxQEPx6tRgvh93brhKsQPbuCG1SjIhRvRN3JmKHoepwcZ?=
 =?us-ascii?Q?cRuUWXOguQzmi3Ov7eKp8PK4aWLGzG1D3CKO74f3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddc39ad7-309c-4904-5f5d-08db0545150c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 17:44:06.8803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4PVhtAWaUpo2Ifzue1f1qwBNu0ltSaKUtIy7s1wEdr+2RC9jih+o9cSx3Hg4s2Yj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5058
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 09:25:07AM -0800, Jakub Kicinski wrote:
> On Thu, 2 Feb 2023 13:14:25 -0400 Jason Gunthorpe wrote:
> > On Thu, Feb 02, 2023 at 09:13:12AM -0800, Jakub Kicinski wrote:
> > > On Thu, 2 Feb 2023 09:46:11 +0200 Leon Romanovsky wrote:  
> > > > I don't see it in net-next yet, can you please pull it?
> > > > 
> > > > There are outstanding RDMA patches which depend on this shared branch.
> > > > https://lore.kernel.org/all/cover.1673960981.git.leon@kernel.org  
> > > 
> > > FWIW I'm not nacking this but I'm not putting my name on the merge,
> > > either. You need to convince one of the other netdev maintainers to
> > > pull.  
> > 
> > What is the issue with this PR?
> 
> You don't remember me trying to convince you to keep the RoCE stuff
> away from our open source IPsec implementation?

Huh? What does this:

https://lore.kernel.org/all/cover.1673960981.git.leon@kernel.org/

Have to do with IPsec?

Jason
