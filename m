Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87974614AE2
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 13:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiKAMkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 08:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbiKAMj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 08:39:58 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240EC26E6
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 05:39:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYL4q+Nyj+DNhXcqVIIY+86X8dCNO1nDoj9DtqQJvjItmkOr7wIzalJ4AUmV+2ExFql2EG7UVY46OuWgTolvSyfQkxuiVrfmlsOGh+IfcsELnXyK5TzGoGB0dnpsn/6GzZbrkqhiRXGBqUtaqjzC6IZb3F3KT3aa/Z1LHI1MSIXfgxhzW8RqAJXEfj/GQ2XWwqXr2UVjgnJnTgbH7pNXFf19eDq5iMJbVttS3HOz6+bTnTGEoz4zQQA/vxsgwlBuF76vS6CPjWrSIP29VwpjWVvHXvDI81HzDleB0bimb2cNpD5ane4rkX7JrYqKIKDP4QrhwINjZkLtux95GKNRqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yj8tVh6raZnxHN9orSr+4cP8L/rxGWkllEMxCQqY/4o=;
 b=VZ21z6ZPEAv8z2TOJeotaitRKbwnW26SfOHzpZBhAmdIlX2mxwSAMMUKZ2sfhFLyycs/cArFfqFkBCaykf+8/peNQc3ufrx9kOlVMX9N0MwqsIGwNUh8VWCoFQ+dM5ftxlP2JmneKLGswBUESzQL/MUVRhKjERoSfZ9+lHz2MX21n4/pQiuUuGCBJjwR8IIRsbgRgHTYv66zPaUqXX4u5psdN4797ld4jaw6M+3ZkpOcuN+X7xI1wX9pkL2VBFx/ed18A9PQUOXINJUsv3Ma3iG1orCjZ7eA6gGj5P+GUVyFYvaUyVu0H0JOuXj/pWFNNhiaRIMxPfxzqpGQ2uXzww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yj8tVh6raZnxHN9orSr+4cP8L/rxGWkllEMxCQqY/4o=;
 b=lSWYTzIu/petZKNr6oYDr/1Kdd9Hb/yoCFi1VWp94FxHN+j67uNVz8ZGGlR7SCAOS7oP1sfxHqi0xJLQ3G+gvbGQg8XWZyUHZ1abSzeyXz0k62twZyZnClxNSQpXW0sBJEoSy3JRAFVun7gg/DiQmFNCpW5pFPZsEpqHOThgkygnTfcelDj3zdlNnQpid/zkEDzb6VOERLdSYLyNa+RIbx8YvC7dmbN0GilioFDbFhdmfx0eUgB06M3903XqGNAc4q+NVP2/NxG2PK9zzm+tTxXkkuODbAUVjue2H+9KtqbaioUqanlyR/r3vaf5DBVR0cqoJ8I/7C/UQeOV7gTW8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN0PR12MB5834.namprd12.prod.outlook.com (2603:10b6:208:379::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Tue, 1 Nov
 2022 12:39:54 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5769.019; Tue, 1 Nov 2022
 12:39:54 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@resnulli.us, vladimir.oltean@nxp.com,
        netdev@kapio-technology.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 0/2] rocker: Two small changes
Date:   Tue,  1 Nov 2022 14:39:34 +0200
Message-Id: <20221101123936.1900453-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0220.eurprd08.prod.outlook.com
 (2603:10a6:802:15::29) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN0PR12MB5834:EE_
X-MS-Office365-Filtering-Correlation-Id: 894e0cf2-f464-44ff-0a0c-08dabc062d09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q52FVN47sZ1E8GpM6HOVsiR1pYcjhxl76pfqC27xOjYci3SGsA1h4DjBaGHZUio+OvDf5p3gh9Ovkj6zCvPyRMU/Jwa6lccBnXS7Rwr1I5DOJnxaPSJX+R8bMJTOYulcczzC6fqZIssnLj+ZjbvGCC0nusY0XZMc1x0pWXsbW6B54hS3hy33AmqqfqXSisclbQFO3PfCRP6sKlqXEtvsZrDz5tcNMdnY9XG12Vrdu42FeGI6j5j6mIhZ5OeyYZtqVV7WOkJwAqNpfWw9iAarxxKjpdHuEV4qkvwdrTritRbCj7VCzADbrNVKFeAf7K6Vsy3lQ7D4AkSF90nJbPAB4+GDfiyzBqNhW8m80Ffe2glLudDHPDkGYCrM1cQ7/zWesZlGm8w2ntIaj9dHYKkGPtA6AJTT9eowqIEjx4j0JUQljG0HmlXM3TCnnX4iu+LRfpy1Blv0JP8E35bQZ92xSAdoahj4xQ39m1uNzN70cifUGL2NXr6+F2x9gnDvYsg7ByUA/8YnwvEqM5jGYRI3JQuannYK55puTKH/hqa6waKgXA6ZuNHv32b0mLK8YNlPXuXbwFuRu251sJKhR2XZR0sXZlqK1xm+pIv75JSmudeYHGP2Z0mldAFvAqAXCHCi3Bgv0Yp7kdKnsU6HQeY1ibaAwx7/eytQRZywZH3tk5LFT2HLnVS1eECyd5f8HLFP/3noUpFfDfnZ9Ai2cmD8k+vSqiUAEAlxhrZoi+jouRC00suCAc+Cu6Wl683Fe0XnJKsnTDj+3OzKKgzMIMjmj7YEE/n1ndBJI4AoV30PSQ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199015)(2906002)(6916009)(4744005)(8936002)(41300700001)(478600001)(966005)(6486002)(6506007)(5660300002)(6666004)(107886003)(6512007)(186003)(1076003)(83380400001)(316002)(2616005)(36756003)(66946007)(26005)(38100700002)(66556008)(86362001)(66476007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ihygGDQEZzyLZSM8rCnWaw9lo6ekPZTi+MB6AhTl/usWxm+Xz3jbm8ANlVye?=
 =?us-ascii?Q?WRbvLx/qU2hLflNqzIIn7IrtuUQYKCPmuQWvJbvWBKZDdz1SSSBlQLWTEGjm?=
 =?us-ascii?Q?3YJeDefNjm0WQXV0e8XXk0ogbeu4lKZq7tXodQdqt7Wth+EfXhWkhgHoDXWU?=
 =?us-ascii?Q?+ASF69g9oxils8R6Y4U1XDRqk4B1tu0U6qMubb9Xo47cU6XGguSPKuThiIar?=
 =?us-ascii?Q?sDwgmwzqEISZUUW0AYpTlytzhw03Dj3b4k+nxJ8gXTKYrwj42roH/bg/W8Cs?=
 =?us-ascii?Q?wCecEhfGUmC0ml7kj4m+vutKzCD7k2Nhf2qIvcDCen7J+Vj+XTTigfs+CayQ?=
 =?us-ascii?Q?wvSL0iNpNw8DdTy9XrsfeAzhEJ8srtoTBN5Xu7TI5LDB4nsNFMVuYYaRhX4i?=
 =?us-ascii?Q?IPUNAZmZq1HtT2+4eVwwjxXoSDD5QOiXfs5YlxvxoDRDpR6HD1qbGZNeqbqm?=
 =?us-ascii?Q?QQLYW1jssMX6eNvUofB2WQpJUxPukXbe5+Kd234IGqKeUXTNuL2eYet6HPFZ?=
 =?us-ascii?Q?KAcnXjQWVUl7QETAVNu/fHDmAIOKf/FoaOtaOw9mqI1/qqHZBDdpB9vxzy6c?=
 =?us-ascii?Q?6wGt9T2plD7I2mlsU+uv6CNiW04IcvOqVmWPbNZ1ZhX5J0+UWydka5VKtkWu?=
 =?us-ascii?Q?z3eOVBAgiaVOZVT7vww7IpDApw/hOVSSIZxeM7rAcgvAqaLa6K5jhQoTSZfs?=
 =?us-ascii?Q?BGoq4WXiOCUxqpeowzdn/ikUIgtwkgYBHNf5pbsRf5Tu/nOv0gOTmWHAv8mh?=
 =?us-ascii?Q?P/yoCPG1+cVDKlsaNRMl9+6bnnTenTKNSDNFWn0QG8moobLQld6OKHC45cpz?=
 =?us-ascii?Q?elf/4gqpeomPa4vCqhuy9lnMjLnaE9cW7nsSNQzLe587wT6KyY59ChGLJ9MT?=
 =?us-ascii?Q?D9i7Wni7MZjr065MI89sslfdG4Y75iwlf7bTgH2N8NupTbaxLjdtvrya5LRX?=
 =?us-ascii?Q?ktEPC+5/Uzyxpn4499y5TP3UEyEg/E11ZDUDFztsAWUoWUonRQBVMdOHf1M5?=
 =?us-ascii?Q?pAawmCCN28ig8YIvlllgyMJ+24DpFAWPCF5+HknjqzgsV81KhZ+UUV/7Y7W6?=
 =?us-ascii?Q?BfHTYJOpRRQ4PTsjBgXJJ8OPHV1774rbfKHbPBHR1toet7S7mNRoWwBQoa01?=
 =?us-ascii?Q?UEFvK/R4cPwD4en7h4Bgl+n+x3fTrIS9FkoKOPO1IAizvzepYERHSHB1pmpu?=
 =?us-ascii?Q?ixglkGnnIKv7cuJoVipik/dFHENn3Lu9jfKCH1AYQ5dIYWbljVnAzU0/3M06?=
 =?us-ascii?Q?Ht/MYUCXxvK47ZckN9VIQ4/M8KImXdN9Lm/5YUaB32BQcimaLvfKlGVv2nGh?=
 =?us-ascii?Q?7Up6Trxl51oeax3JQsFSmrkOnx5aRtMCVULpGBASDC3R6PYKtKPQ3LTeGHa5?=
 =?us-ascii?Q?NKce/AmsbczpJAijEPD4NJjyOpSui+XKZ8KFAqer4P4szmUiO9Jnt1yMKvUG?=
 =?us-ascii?Q?r5slh/5iCq5JA2FzWwncXnKTNThf74jPb1zBTnrjVsnC6SkSTJIiDr68ZOMH?=
 =?us-ascii?Q?gy6x+1Z86S7L/53lV/EBZpkQlZFodEZNMkByWLov1aT/o4ars5zC5l8RPXpZ?=
 =?us-ascii?Q?JVaTbCsDINxaoVScavhv799YecDiRWFVag/4HOy6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 894e0cf2-f464-44ff-0a0c-08dabc062d09
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2022 12:39:53.9301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u3pEXrSwkyrSca2GMjJSUDoHZb9s6D/n6BnkZInYgeI+AxDyBfB3LAYbj41NBXSuiajPBXGMSRNvCwZPJJZvGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5834
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 avoids allocating and scheduling a work item when it is not
doing any work.

Patch #2 aligns rocker with other switchdev drivers to explicitly mark
FDB entries as offloaded. Needed for upcoming MAB offload [1].

[1] https://lore.kernel.org/netdev/20221025100024.1287157-1-idosch@nvidia.com/

Ido Schimmel (2):
  rocker: Avoid unnecessary scheduling of work item
  rocker: Explicitly mark learned FDB entries as offloaded

 drivers/net/ethernet/rocker/rocker_ofdpa.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

-- 
2.37.3

