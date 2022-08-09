Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D857358DA68
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 16:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242775AbiHIOei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 10:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237529AbiHIOeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 10:34:36 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2055.outbound.protection.outlook.com [40.107.92.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77554183B0
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 07:34:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUGHfDm9dPZf4oj9Qqq89veE+AwJDXhf875JA6FN/mQUp4v+gzyH089pulHFvyzI6qxd9R/iffKm2JT1HXiHbOecQMYJFNIYdOqYj+GIMcllNUKrjXybRQxDz5so97qIWrmy0U1oiAjcl0n+3eO/U3j5Jcm9UV6sndCwOPEMlMF/bFZJCnYUJ3ZABIjbVFi0tIOFs8BNqnFuM3C57riWB+5S0OBLQWxtOPfMz28Zc1oWAHf2H2HuSSj/9Wt0aZX7vuFNt3xMA4tm9TtYbpBIubTLc2F9FJNdOzf44nkufUobhXLijW5QhvgbVt1jK7b6aJkG96gpMtf63KKWPgHVqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hnmvUxzq7R9JwQX+604YnI703UDN0I/WE16znRqmRH8=;
 b=iX1urGLVXe6NWUw3/I+6AK1v807c1zbIRSS3XRRzqTgdvRyvs/geIi0apaqSl8aEHgSy1z6eU5+7xFjAfwuzxztIkUTP+Tu2ae1/HflbPwC7GBcWkvQtMasNueu+RrOAYLHUZYG/Ng2NdVt/i680c1UhGd9Ovjb3HrhEaxB8so0LJ4qxNyoVf1QWhFpfmtL0bvU99s0zLhGVVmnRw0nziJ+dnYbqIbFVzKTIEe0wODbR3JAxlteWNXMTS1ooYrh6XtcqFYfAAyy7pH5+8QqOCrmpdE8co/MlGxD9eBKoRyb9JMc5vIL3CFGh9VcZGAc260Ua75bpBtWFieuUA9/qOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hnmvUxzq7R9JwQX+604YnI703UDN0I/WE16znRqmRH8=;
 b=L8bfxU/WY/wh/oViTLTCzMieu9JjJCVX6pqVM+h2S9TLjjus+T49nZ+NG3PZssUgnakLh9LPKAwAKFqKujx+Gehdon6Z8iw2QKxuJsHUzSAVS/am301rfMiY+cTN/r8pOY2xqd6/3GZ/ZBmZuBWag/GhZ3Gvvzhx7biaEBXfI8IaVpviqWZ8nsV2pwBIeeA4yQkLjVZ2u8VWDmn21//1fBU6yi7B+JC+4Yl7/Jzv62cQuPd2fFOutvPbt+yXVMPFcsibLz7NX+t+V1HtdDRuiDLfTNKMmmMU1+tj9Qa/yPuvE58SGncEoxrRj5kfE1n7Kamd8/6zcllhxOLC6Cs4oQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM6PR12MB4778.namprd12.prod.outlook.com (2603:10b6:5:167::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Tue, 9 Aug
 2022 14:34:30 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.014; Tue, 9 Aug 2022
 14:34:30 +0000
Date:   Tue, 9 Aug 2022 17:34:24 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, dsahern@gmail.com,
        mlxsw@nvidia.com
Subject: Re: [patch iproute2-next] devlink: expose nested devlink for a line
 card object
Message-ID: <YvJwcAxZIY9XCZFN@shredder>
References: <20220809131730.2677759-1-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809131730.2677759-1-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR06CA0187.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::44) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f3a42be-3767-4f87-ed66-08da7a1444e3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4778:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GTu2vJx17kVOmMW5IW2jWsrSdQHo85ihk5WbuB1Gko2rfKTcvPPWES6AypvF0v7sORES0MDY1uTFe5s5yi1pKHLyhsnpP0I3upxqfcsRT7ZyG3fqQvvQyL+b5aWSOsR5DpsucgTMm2QveZ9NYBDD23Mlvrtf40BVltm37/2ThWzMV2z1PGapoG12wywbas0BAOLpoSvcYtP9q+sMxRYiNbSOSjI8CFXpcPp6KYmh2aSiD9XiPOfTw/aWWOWin0uonk5qmZYbDGUax4C8aPw9klIOODkdM3VNdWI5xkCr8J8G++HAw2ZfUI63XWE/S3uQLWRq1ots7Tc5Nc8+F0hI2rpR8Es0EtUUvyFtxenC04Dc+yRdTePQ+8mMxqJhqIWMtpA2qWWRR7qZpkj3wJLbN3rgoFP0M0EwVFGoK25e7w1ANgQmWGZ5eKyAIG4C8AoDe5GubrF3Z9s6nt6WS15g3ywfma+jElP0/jhiT5CFvTE2irt4hk/QvcVf8U/ArifTqVm0J9EKhmPRgJZxTkg0mDlTXF7JPMzVP3PnKwUzzNhWOM5Cv8HuadgIJO72/Y+zMKtCPpKw/77CJ6qK1tNKC3V26GpCw++Ttn8UaE2TID4kJOLxFklC9hDG74HiqdsccoIprpdyryIHcjFH5t4fzHEAZFJYU8RcUWzAUKIxk5fYJBTBPkuWe3xAOYHYJ6ycvWxeUA2+vCwtMGo2lpslzyKeP8BmuJDLahH0SR8XNb2kdb9nc6r7CZe95aO1tWuB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(136003)(376002)(346002)(39860400002)(396003)(86362001)(107886003)(186003)(6666004)(6506007)(478600001)(2906002)(26005)(33716001)(9686003)(6512007)(38100700002)(316002)(4326008)(8936002)(8676002)(4744005)(66946007)(66556008)(66476007)(6486002)(41300700001)(5660300002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8HL80va+xLXo2Q55Zc8kfapvPKVbu65cIyKNci3jVtMG2541LuJTgi7ONIQB?=
 =?us-ascii?Q?1PfUYyJ2jW2uXUqOZe1R84Hy3m3C5qsZg3czOwsAYmJoYHwEpASqgQkKn7VG?=
 =?us-ascii?Q?1NyGj5H6ljnZvgVF8BDZ+Li/JP5tBsdwWrMEG4Nab8h0Y0ygVQCy8mW7paqa?=
 =?us-ascii?Q?8crPY8fzb7EHFLz0Lof/792+nrp4ItdB6+zODYd5BRQAd9y4dSjH2inhNpQk?=
 =?us-ascii?Q?Y4SoNb2jlq220y51MQ+gDSH+kVa0dfNW6rWytPQpPF0IUyK8eg6L6uMHhSXL?=
 =?us-ascii?Q?yetDq7bUJqC4HsMWCIKMVVxUOQbKv+WwK7y+2dHB/63MAgdT1ktjEZJeo0k0?=
 =?us-ascii?Q?kZbRQ/sBvzJo22e+VauFJAPPODqc/xQ/gOWt8XP7BRB3zv1SgVDyvHdlS21D?=
 =?us-ascii?Q?+DWtqSYhIFBGMeMLRi7AzuI7T2UIo5tBflc/32OMb446Ki02c0BNnaxyMadD?=
 =?us-ascii?Q?9aJ34B5krQkfBVgZSHWZXNIeDIBFvuMS8xo6olemxQscOQEk5RIL/bqD/3Fl?=
 =?us-ascii?Q?32uREeSDbrocrCPh1TWLPprtIhw0jqU/5vtDKIwIuPP80KmSJ72noAN52E9U?=
 =?us-ascii?Q?7GAJmN6lDe0sNCaigPwLthIbkt4vNMlqlTm/2a/U1JeqZFu26K5LtPehxGqc?=
 =?us-ascii?Q?Erw8tGAtyuGFkl3QHgdxk+EkvJit3k/gxECKlQJnrtRf7LlRMmueNBUGaNwn?=
 =?us-ascii?Q?TkMMW+AnA8Tup+WhYwmNHhP8+v4OELdgy5wz7ICKGKIKCkd+cKIhXPCDz/PJ?=
 =?us-ascii?Q?l+YxcT6wu8pZ8FegetKdmKtBus7KBbtoicKb/bYOhqFNsp3PVg1p5P3wxmya?=
 =?us-ascii?Q?put6VrJ4i2kf1PpbN0zb51RpSjncRjS/rF25+4H662ueCKzTyjZ7yGbRqqLx?=
 =?us-ascii?Q?F35GWpuBFyO1dp/BD0ElZPLo2fdHRLFD4K8R0umJ2KF2Zcx1E6sLpEqOoFyC?=
 =?us-ascii?Q?0FGe/zfI5ZhOyH3CY+XXIMzSSVdzz+55ydlO+eRA+YY6enHaFsTJsxbYjYPG?=
 =?us-ascii?Q?qtXeldyweYNCKUo8ZC7YA9YJvlCKh3WGethQsNGn28MZalDwYeV28FmAnvY3?=
 =?us-ascii?Q?mQS0t8+MQLxGRX617105+UqiNdD7pfbZltHSxj1nV/65pd1KAipV2AXRtXSB?=
 =?us-ascii?Q?cS8CmFyBLq4FM/v25hHh+c05tBOauU3gNFImnIc9OKiI6yT9oreIfyDDR0bH?=
 =?us-ascii?Q?Tu08z4LmQqSqh4HA9U4ouDRI/AQxwleWUINHl0DV4s0p65XlOeXE5x1USD1e?=
 =?us-ascii?Q?BTOIt39nbaJAXK3X2fcFIwvOZ8stF8qdz7JxuSojH6ZYA1HrukCjdXQ4ozxE?=
 =?us-ascii?Q?CgYmBgArFycwRt9bz3zCdDkpQ6tKUfiqR84+Iv0Lu9r7ibd1pHb0CPJjMhwe?=
 =?us-ascii?Q?BdCE642IhJrR5zw48foKXk8MgvrNrA2/rvN3tsEijVSOKonJeJ3t64IceqIe?=
 =?us-ascii?Q?oD81F9G6qTvQa/cJPMYSN8JwirlITKFLgg92oCEe3hMgyMk8duAPN/Nhk6vE?=
 =?us-ascii?Q?kWgJncyI3tLDA48HysU98wiCDQI0eC469ecZwbF52Lk9WgjCSHue1tgSa2xG?=
 =?us-ascii?Q?DA7s92Loiy9zwntcLpVZOpbXb9J8X2P3DDtMtN8V?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3a42be-3767-4f87-ed66-08da7a1444e3
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 14:34:30.1162
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w4fR6hwGWlXpnVojl+v0bVOVo7dvcGfbHLn9Hc73syxjhoyGx+HkXzjKEVF4eB+/sE6BkBrIAGeoFujbWKAOxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4778
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 09, 2022 at 03:17:30PM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> If line card object contains a nested devlink, expose it.
> 
> Example:
> 
> $ devlink lc show pci/0000:01:00.0 lc 1
> pci/0000:01:00.0:
>   lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
>     supported_types:
>       16x100G
> $ devlink dev show auxiliary/mlxsw_core.lc.0
> auxiliary/mlxsw_core.lc.0
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
