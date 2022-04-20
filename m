Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93815508AA7
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 16:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245504AbiDTOXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 10:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238125AbiDTOXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 10:23:34 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DF6443C8
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 07:20:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9mp2FhCv7SKH/BDnLvRoNibWmR5xCaBpXducdfPo3GVocMBlxnkZobKLx5dQTLvhAvyGJ2tfucNlEkwm2gkewv5BOJIEWDVOccIrJJF2x9p71u8Q38cbhpOcqrlxaQQNlNmeZWyJrtNgghjUMTTFy2EhXrFOAqnckhwQW0eIapT8ounvmYYYVI5V9G0NR1WJXaBjmmQ9ZfloOZAoOMF5Y8ewWfk+9nz5v0TS+HuRgdPJD0ntqd7oWTzkM1UK1Bwz3cZKh42wsCSKl2AUiz3qYnBJOBnTxDXOIwUlXRcVT/MoU1OmMsJvIsR+F91lQVt5d2seChT7OC5BErizZQ8ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mzNqkmtNYqljPlg5diRfj9rAPRAp0GYWRdYrcHJTqy0=;
 b=dx7y+rgcZrXpvj6HlSxrBG8VT+y+E4rI92BZkBqOmw+F5jXOXXmtNgpv3xRm71GMkexBh8tAzgZbjCNpm+JBOKq4HCeDaHHo5TePFHVEdzgvpvRREF9/p/5Dr85m8+gUch3EIRPh7pXW6AhjjyJZAgiLp+/uwYXDPuaoGLar2hkZ74ccKV3LCDwh2XgEG9kaGBRYV3QxL2reW+z7UwJkIsEZB1TLf/MlYmZhW6sTisjji/u7zmtHEK95Qh/W2CxGrvWZ3vez6/KwBwR1cVZqRRTHbFHvBBd5UpgWYx/g+1sqAIbzePKtSpwCxeak8Rrxh92Mq+3ihP7W8PuEfjwo8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mzNqkmtNYqljPlg5diRfj9rAPRAp0GYWRdYrcHJTqy0=;
 b=jqOBk2ZLBx/XlCzPuDjxkcSeGBCS6Lm/8bdi9JL3jEJNJ/kfKgBVOPsHGoj4O6dWOwgDMclORewRAZ6gfl+CIh4KO25ekDtnpacvOmfSzn2WCAdBlYwWKnzTTHRfeuI9QjNWmgBIvKpveBez7ADionJ7HXsIffduOFcQOcyTC3Usa+iXViFbsg8Qp7ty9bstNDBQq2qvsK4XwpZSR73e6KuI/MIWPuazEGLvImF2YIBzFdzLj953SqvzoHaA1K0GmlnSVXt+B15ijT58oApN1abr2r5JPrPsr5kIHVLwoUF5g4erBbfAtN+DT7CNrgVCco0KTpHRl6yk4hF6YAzCoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by BYAPR12MB3624.namprd12.prod.outlook.com (2603:10b6:a03:aa::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 14:20:45 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%6]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 14:20:45 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] mlxsw: core_linecards: Fix size of array element during ini_files allocation
Date:   Wed, 20 Apr 2022 17:20:07 +0300
Message-Id: <20220420142007.3041173-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0189.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::46) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfd5b306-3dff-4959-7e14-08da22d8f57d
X-MS-TrafficTypeDiagnostic: BYAPR12MB3624:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB36241C57585CB2DE7D9CA713B2F59@BYAPR12MB3624.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qLpKpqz4u4T9PU4s2eIeoOQxgEdQHwIFBPONq5z6jqNDuUSPwnKfGUUD9mUL63sm393ILfsNOf8UaA9qxqf7RRYZdZlyL+OEzFvj92yES85b/Fgc3tsjM2uoEnuQ+M2AFAvz4AW8uRqRRXqV4HeJwPmJ1c+BiwR4NquVqiQ0/ioFqPyMVkn9Z0Ni+DwoXgQfte3f30tyd/yXAAwrV7oftKCT45VZh3+CarYBZ4m1OIS/VHY7AelR1IWR3c1iubNF82VaT5yTPs3UhdLWGUqw0MnYpFO4gtqHCYLz6DQhGp1jFdSw+TRaEZMGyEHjelFoDjjb6CJT/Zr+NrfD/odUjQAKCh/pOqySmDL2ifgxk+q8NlLaHPzvtijbf86vIWbHmq0mK92kqPb4iwFUdg9MiTE/ix03l3+DsC1qkj+HthFpK4gYIPtVobTd32Eqf9gLaOPU/gy3/3duziKzb3/BDwnAoi6lFiw6YuuFBP/t616XR9YTsSkBrzK6cLb70G3ThJTFPfG1jE0XKqWAUTHZguGGsB1/Ga25CPy0rCzRJRFIJkrJxtwDdzqI/+FSC4gbvUA2tb0ykPElQWVrungPeDDNI4gn58PJDh1Y4wmsHoZ4iRjT+usms3XxGUrK7723Y55hnCkFCxS/v+HhqN1qtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(36756003)(316002)(86362001)(66946007)(6512007)(6916009)(6666004)(6506007)(2906002)(26005)(66476007)(6486002)(83380400001)(66556008)(8676002)(2616005)(186003)(1076003)(4326008)(8936002)(508600001)(107886003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NWgWtkvz63i8cm0LT31/rutx92ou8ArZEKj06tkngOltSPP+HyK+u4dF7PEA?=
 =?us-ascii?Q?yARqCJNp6fxPajNFjkqUMuCPmHuRfxoCj6qzjWNuI0pjnMEAAjDS8VzWRqza?=
 =?us-ascii?Q?up4m2D1EOwl/b3+tj3HDYbR/DYNo6NSNKnAXXIb8UUalpuKc9SyOKtz/ctHC?=
 =?us-ascii?Q?ogy5Ag7SRvsu1XVWFWiBPsvAP89eJdi6SuUQZFj6AaA33CczWxdulFy7qlpb?=
 =?us-ascii?Q?9gz6jVGMAu+iIAZQGxZdCqcq6ZtTJ1Jj10zsbMrjqxbSGv79ZE3KF9v+5APV?=
 =?us-ascii?Q?P+qYvZzt0g1WDdkLxGxHcJva7sYidYvqh4pniH/iiybKoVcl3jllVhJtgtvD?=
 =?us-ascii?Q?uDZohTvC2C64TEmuNWx51C5sSrmbksqlNNuuApLQCXDbqVS/mofRejC3DZv2?=
 =?us-ascii?Q?kTlonlAyhod9sFnMGd51nSF8DsCTt5C+VdbeoYk824nFqZ3vWL1owg0gXK+0?=
 =?us-ascii?Q?fsXofvIjtx3pGfB/6Ae6NyQ42OCBr5orPignWF51Ym7PQRA02T3QVhOcNbSg?=
 =?us-ascii?Q?SPGuCV7M7c8NUz2ykRa1RyWkKBRVuHEIyQspDUNjW18uqoV1pfRdjB1k0jW1?=
 =?us-ascii?Q?oEN7G8kHGDYi6lPdBpw85HE9e/mKwWFGL1N4a6+UUnDTpQOAAOQu2BgqKK0t?=
 =?us-ascii?Q?W4rlOGUZYoynDI3qP6c0uCkVPwscxqeug6IVeYUg8uoChFLChFEzez3IxsjT?=
 =?us-ascii?Q?XJypEibqdrreb0JpCRgHRHVCSzsOis81a10TeuvyIGejQOGxxqaG9kVjwFdG?=
 =?us-ascii?Q?Rm94dMeThsO/wzkQ+hjz8CiOAaj5g+T1DG13+HZpKz/p6yiI1cR0guLX/vLL?=
 =?us-ascii?Q?SFjZJ+DiSc0E6yWmNkO5AY/0IlyYoGq52d47Xa5g+JcTTABV64x6WtOfZAZB?=
 =?us-ascii?Q?jidk5FgK9Eo44r6p45fqx+S8i3uRDczScez9uO7tP+mRYlnN/IaIljy//aZ0?=
 =?us-ascii?Q?yBUye98jT3nA+mV3TkxrAvm0KgUqpQO8PgiRtYtRN2LHIw8/VxN0/WCz9MwP?=
 =?us-ascii?Q?FmMxl6Q/6TjhZRvyYyNdQsPo7yVfDl4L17OmsgvWDvjrOL/A1ApoYQdEUbGb?=
 =?us-ascii?Q?a/Zmppr8boYEBC900ZmY8Z7jrdeXafO8PfHxYMJ1wioL+bPY6Ouy8MEH7Hco?=
 =?us-ascii?Q?EUWfwtllegqK+RxTw3BJ4rqTQsDTjzZBQcXpkyUzJ+hnGuMA9Hszp+44PNqD?=
 =?us-ascii?Q?pM+dfFXYMUR+p28Sx/edPCQcFJeKwiDEprRaEx2EJknSwP14vlFgydW3+HI9?=
 =?us-ascii?Q?Cz9+u6mAQf1QvIS4Y6dCq8qxtaCjmOX8xngOaT6ZgtoZVwgQLKUAPrgXxjyW?=
 =?us-ascii?Q?nFRMSSn9U2pxBFat4fa9gRHMBj5KaoUJIRZKP2x/lUfRWMiVrfn7su+zVbog?=
 =?us-ascii?Q?1xVcRn8LjLIJAtoxSvt2calu9XGOGjgYKuti9eXqLVCVsQk3JsS/20yQP6an?=
 =?us-ascii?Q?K5/0cMoGUjLE+Cp2dh0Jc/QWhnGtSyl4mlrzOxD6r1vnbONXUyXWdOMzDz20?=
 =?us-ascii?Q?40Q8jlRHaDuabODSz9Uk+VrnKmZcjvFYiN9OPRXzutbYGIjGOfzCBTHCjp/d?=
 =?us-ascii?Q?IR1aswFrLaA6iyK0CBI8rNSVXl2Pkc+uIxKs3G9sG/51KWPOuBKei4OP5S9E?=
 =?us-ascii?Q?+9zypim8clNugG8Za9WyEt2hzFEI5TzZuch/TLCFZtXXM90tYdASdgSnJisv?=
 =?us-ascii?Q?gFNLgHIgUPXsMKO+nGwY8hWtuMEhaSr7BLfMy/zr58Xcjf1e5y6Kazmajg9l?=
 =?us-ascii?Q?yQgEOii0iA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd5b306-3dff-4959-7e14-08da22d8f57d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 14:20:45.4687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Iemfo3Pc9/9Cg9lZJXhJLdkfTgIRAK4+k4N4vEgTiQzyhfLQk3VLC7xolBLFIV+K7MczP12YvP4GOKVsAjnpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3624
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

types_info->ini_files is an array of pointers
to struct mlxsw_linecard_ini_file.

Fix the kmalloc_array() argument to be of a size of a pointer.

Addresses-Coverity: ("Incorrect expression  (SIZEOF_MISMATCH)")
Fixes: b217127e5e4e ("mlxsw: core_linecards: Add line card objects and implement provisioning")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_linecards.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index 90e487cc2e2a..5c9869dcf674 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -1032,7 +1032,7 @@ static int mlxsw_linecard_types_init(struct mlxsw_core *mlxsw_core,
 	}
 
 	types_info->ini_files = kmalloc_array(types_info->count,
-					      sizeof(struct mlxsw_linecard_ini_file),
+					      sizeof(struct mlxsw_linecard_ini_file *),
 					      GFP_KERNEL);
 	if (!types_info->ini_files) {
 		err = -ENOMEM;
-- 
2.33.1

