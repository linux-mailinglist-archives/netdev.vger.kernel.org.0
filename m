Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FFF747239A
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 10:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbhLMJQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 04:16:59 -0500
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com ([104.47.59.176]:6195
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229697AbhLMJQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 04:16:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a9Qpwf/Y5LNS10GGLAjTqG4qGS/OILMjhEQB1FD3js93n5t8TmhYudu4gcr6+CgJRcRjyfJBxeHQ0vKvH90a54sqKjiWrSUHgrpHHNi8rSQA2/5mGpOv+Dwxm0Ll6wtF/iTgD7Bb9ZBLCtbceNou+bk0WgF2XCdOUu8u77OS0kR13sAXE4H2dAcgIiJirNONKOJ3YZ3H5iPjCh96sDTd9KIa27fJcRzKbYA0ijXi7uCfsD2CuusdTPOyT/J4pPPJAWqQaDyPRVSSAwOzuhe4xm4IwDTTAFocWg1v9voDDZyLgwYWkP1eSfC/strY+idO0CU3GEISwA2tPiaxZkoWkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aoZhXJtIAUN4wiDQ5dVZeyoT+9umcRNq24WvcqXTrg0=;
 b=WSKCahY8R/eEX3dcvpD8vuL68TveClcnol8FVkfRYxwOYYwoBPKaYwcxCIzkxUxO7f8F/02dv6O5WIWRxFjWq0TNOyIwg7FTt9mVtRzCQe99dKH1ZRVwVtArHH0wb2ikgE4sJ/AZGueyMruCtEf4eb+HognQjL5as/llLmpmn19lZ6w1hOGrhsm5fFh+CPxi96Vs/9kKuXbbOqFPMyMKEARvbJGKtYQv8zj/ASD9/paFYS2eYS2LvWkxH4i9sv9Oquz6aQ9OYkDGqtMjQkXZAACZSiZ52uhMmAU6QRhWGDADMhc7PENsidCBzIxvViRFzW8ui/98ZSjYHGw/hFQvFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aoZhXJtIAUN4wiDQ5dVZeyoT+9umcRNq24WvcqXTrg0=;
 b=ZhrXSVanYKkKRIEsvmjW4PoFV2v/SCp/vcPB/+RebTQv145+nxZx2N8YxZBOuYIZ4LIPTp3ZMZEMH/n32+ihOHum1Vj4f/xR34q57WnsTSnto2VnE5rKJPzs03i80hFHmNm0DdN+hu3Sljmg751Jh95fRQFzH19EBH53RUSFPNA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5478.namprd13.prod.outlook.com (2603:10b6:510:130::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.12; Mon, 13 Dec
 2021 09:16:54 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Mon, 13 Dec 2021
 09:16:54 +0000
Date:   Mon, 13 Dec 2021 10:16:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: Re: [PATCH v6 net-next 00/12] allow user to offload tc action to net
 device
Message-ID: <20211213091643.GA2266@corigine.com>
References: <20211209092806.12336-1-simon.horman@corigine.com>
 <7a3d97d0-85c3-842b-aba0-73e0cb4a925c@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a3d97d0-85c3-842b-aba0-73e0cb4a925c@mojatatu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: LO2P265CA0294.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a5::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2e39fcc-6608-43df-5a90-08d9be194dbc
X-MS-TrafficTypeDiagnostic: PH7PR13MB5478:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB5478FB7F2B7FDA26DD2A7ACCE8749@PH7PR13MB5478.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sTVtAiR/E2Et7k2Wjhq6YNMoUahds207/ZBkPLfkOVtnsyZWBu3rQK0roDOAfvAZZW+BzuAJUXF/NXhQG2MmLJ1ZvpWN6luQtv+Mlo5EfvI5Uzyp+t45o+Z/YlZNaBRX1ECn8sRGpNGIHs8qK8F8CemRK17xklCZo7vvfSV6LOYVimuG64dI+rkwL6MK/Pt6/CaqYfeTU/ZgHLORgVHJT9N5Tq+pOFJlmqTRyFRE4fMA8VjpOQJ8V+wATtlmoF20xKaP+tPkyiLK6+kX/uea2Q/7vG/A9hYQq8e7UniIzS4dlzPqTR1Eu0NHZpBrEAXcxpNTBUH7slD0UqyJOmfET6XJDyIIR1/xynYypNj44Wli8+nY08H5YXU8V5Eb8DMA0QDY3yp7Lk+pozhG0KrPoBc3ou9c1V/VFEijxmjuCVmTTnM97mmsxsNBJi/BFsu7RGTOEUcUiaj1iG6r7msniUTbnP3X2xb9fZF4CPOxHJD60eqXdxnaySuzPDovHWNfoWjMJsJGdk/AATK+DSks33EcicI77WSlE/2q5e6He6Z72sm6+isTc3xBj2H9iOZ8Gc+IegtzG1dgsouyRB9mPmJiVEU/k+H0JgKMuGga/hjUbje9IACbed+vcxb1CGtRR4F4nBvl5B+W4RYGMiE4FA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(376002)(396003)(39830400003)(136003)(38100700002)(1076003)(186003)(5660300002)(44832011)(36756003)(33656002)(2906002)(8676002)(4326008)(8936002)(66556008)(66476007)(86362001)(6486002)(6506007)(6666004)(6916009)(316002)(52116002)(2616005)(6512007)(107886003)(508600001)(66946007)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FZvei7IPWjOzBTOyGiOX0QYWuDkE8EqtirPkd+Ks7UUPZ+tBUDlu3+4zBm3P?=
 =?us-ascii?Q?08nF0XzVbjtXblKkFGb9MOYWvgxSfXl08BTVWq6jsF0gstb9aUmtFyIG3NIt?=
 =?us-ascii?Q?+U/Au/GZ7s+Bfe77rlOG/XM5htCGbXAdxpw3Q4pkp42OPmq/8vqZhU9DU0wA?=
 =?us-ascii?Q?3eoYNcn+yy2/jc++ah00NFzReq980HP8ZhV1KguMqWH2ttxmJFEPGUP0dzrD?=
 =?us-ascii?Q?4jC45R0DfxNsMDdetAnmDQ62RdR1jqhu4N3OZBs+tbcbHx/ieR2FldFeRUFe?=
 =?us-ascii?Q?3czOl6uDybUYK8sFGe07a/l1FXczraHEndNNfxXs6YocwIqm2hQ7Kv9d6oi1?=
 =?us-ascii?Q?rMYPefOzpz708JkSKQNy2v7JCOh0AzfMU5GHYDYFUECFa7lztkBgzpGKV2M7?=
 =?us-ascii?Q?JY5jjFcsikMKwSnqLNP3uIhngDwQRTfkJPyXbJuijXhF4qCpTJFxQJgE8G/w?=
 =?us-ascii?Q?24yymLA/WGsElsBrjbm+ym6pBhbs1gR0kqXv+A7Lf0cO51hyBMRm9cLKqkI9?=
 =?us-ascii?Q?5QaXyE863xuVEuMOmE4SzNzrUO5CkUO15SnaI7WNBEzxbd2PKu439ypgqlb3?=
 =?us-ascii?Q?1gk3Hur3hTagRdTteM3KHuyvvQfOlhaI35Aup0qpLWdesh/Jh1sQomK5ZjVL?=
 =?us-ascii?Q?Ci/cvWEwFI8Kxj8esP3r+1g9WaeEh9jkpKZGaEziK/NN+ldfqQMElFSMmKtA?=
 =?us-ascii?Q?fC5f1L+UBRz6GfH8IIR+iQhRadQnqoqIT1255+ccEGPiVEWeBfokwND7tvK1?=
 =?us-ascii?Q?hALPJ4SM+MJBGCEE7gqP9f1kWmZjFnhjWOGhp/H+j0TOKvBiUAFdgJCfcpK/?=
 =?us-ascii?Q?6KaOa7XnOsxPQuh0FISuvQuRskwR242wQ7eqxkMmf/oMu+7aKzZWsLEO2Cu/?=
 =?us-ascii?Q?O6myVn1yaM9P48kdX0d29YXD3DGZwrunf1nrdczSbiJS8JpVxaM10hVAmqIj?=
 =?us-ascii?Q?dG4XdCPr4uA6BOK0JY5yrFfGJyQWMgnHaNlOth2EIrbwxzlggzUzzWpbBeVC?=
 =?us-ascii?Q?HDKNyGuAJkiQlXKG4gm6VAuRDPzZXDLXjsSoQtSuHym+CqnE/LDi2Ej5Q+wq?=
 =?us-ascii?Q?CAjhYj3WW/aMqHvSrkqGP7Z4zRd+vFyJr72yTG54+5A8LRMv8CbU8hJfXq/l?=
 =?us-ascii?Q?TD85IV+nQJRhiZkPBsvdoJN3BY689kPvRpUKaxORkY6piewhxW+rhGC0jRXE?=
 =?us-ascii?Q?1O7LSaVfVE8NC28CMQgbVUABQFw3ovkavufqXzIqAlf5fWIknuqVOBllv/Rt?=
 =?us-ascii?Q?bn3hGorhLjNQK+denvK0a3nw/JX/y6J9j3xpBgJvYTh37ri3Oedhl8WGgrrC?=
 =?us-ascii?Q?zF6kOZR18JsXij2SG4fCL7e4IgPrYHRaTTIqLG3QbjEC5et0yu3hyS3AXHcY?=
 =?us-ascii?Q?m47v/n/qaT4edaEQyol3XxBzQjLKok2LrM1sh22oIFETikSGPcv/Ychsi4xR?=
 =?us-ascii?Q?Wj4Qc7UXcDQ5kfLWaxtODVGpXbo7iP9KjE3dnJMWOYs/2xRahWRMgZJgD32S?=
 =?us-ascii?Q?oqjw6n944gM6voUPC01WkFkFsGF/HNIvUInJMk6Ic7li+F7FUoXc2H5fyA9M?=
 =?us-ascii?Q?X3eu8CA7nv3UpO50GMgmdJiNFqWl08tEnJ64fxvOZAS0y1VR7K2mUdW6SJLa?=
 =?us-ascii?Q?VBUlzTRjRB38VLJmQHZlKGHXqmrL30vKaOfGfUy69eUdWqx4x/isYcLXJa0c?=
 =?us-ascii?Q?b7JMDX9HqJquocPr0r6aA5M9/ekcsJG7omHLmKbNgwBStXH1LUM+7zJRXfVF?=
 =?us-ascii?Q?WshEsk4A4w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2e39fcc-6608-43df-5a90-08d9be194dbc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 09:16:53.9565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJitEf5aV6Ei+N7S8CkpSurHKU7hhNbl0W+wBHXpEbaBUscVnnSORbM2ZzT0gHaBlZKtgnObNUUM4e4/PHTX0nSRH19GyqMpnXyJgl5PFBQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5478
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jamal,

thanks for your review.
We'll work on the issues raised in this thread.

On Sat, Dec 11, 2021 at 02:04:50PM -0500, Jamal Hadi Salim wrote:
> Hi,
> 
> I believe these patches are functionally ready. There is still some
> nitpick.
> 
> On the general patch: Why not Cc the maintainers for the drivers you
> are touching? I know the changes seem trivial but it is good courtesy.

Thanks. For some reason that had not occurred to me.
I'll try to make it so in v7.

> From your logs driver files touched:
> 
>    drivers/net/dsa/ocelot/felix_vsc9959.c        |   4 +-
>    drivers/net/dsa/sja1105/sja1105_flower.c      |   2 +-
>    drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
>    .../net/ethernet/freescale/enetc/enetc_qos.c  |   6 +-
>    .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
>    .../ethernet/mellanox/mlxsw/spectrum_flower.c |   2 +-
>    drivers/net/ethernet/mscc/ocelot_flower.c     |   2 +-
>    .../ethernet/netronome/nfp/flower/offload.c   |   3 +
> 
> Also - shouldnt the history be all inclusive? You obly have V5 here.
> Maybe with lore or patchwork this is no longer necessary and all
> history can be retrieved in the future?

Sure, can do.

...
