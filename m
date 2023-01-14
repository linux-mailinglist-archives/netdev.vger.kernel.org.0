Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA2666AC1C
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 16:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjANPcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 10:32:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjANPc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 10:32:29 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466ED659F;
        Sat, 14 Jan 2023 07:32:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQTOdBuq/xVvSO54Jk4f/M3pjzdri/T7TeN0kcXSocVXScp4gpZjwg5vIVR3dMpyQb+fq5RHiLnxstdrlBwr1p/BErTprvmx8ve1Z/tHomRvXkR1Zol47dSV/ZMQxd1XvVa26jbpZiNFj+HUUahGvjodNdHMfJBMdFR91CVTUKKRi5t4eZzhvdZf0EUn0FekFxm0qkehezfxYZdf9+nslEN2Ut2RxoYQqD/On72UDnAKzwTNbAn3/5oc74DxdahweHQVE5NxY9lrhpR7TWVCWTCA9tnnBTyarsyAV7/+C8g2WTf2z0lCRsp1OgOH2pGnARyGdnatK/4xNpNrcR6Keg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8FI4oUWssmoR1Tj8aYGVJGI10SFug9WkV5wA47W0bk=;
 b=IoqbU0R1EmsIpKCgm2bbYGdY9tC5f7vRmowDJC+z0Z5mS28BRx4hNcxu9d/QYE2HsxsR/uVxnGxSvQzRuGHOlzSPurEKW/oRsGPGzUBohr+6z+/weOpwntf8XSK1g4FblEhKiCTSx5KDAdMhKDd5I3gw57ngaa/eGwbaiPHocNZlRWh9Wzl/XRoXSwcm0Kg5vg5tEkgC7tcwr0PmYZyRgyvmIDN1ohsifDFSGCodNxixdkB1EMAb1jiGD2c8ZAZY+EV9DYt6kKfs+pGT92GwC2WSbFSaEJMIGjL5mjU7wkFxQc+9abmzPGWep/57kt/lx4gOJ0IoBAIZkHfCLDLZFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8FI4oUWssmoR1Tj8aYGVJGI10SFug9WkV5wA47W0bk=;
 b=ox71Z1jvUx+p0zUIplkIveFrFY1wo+y6+98rYwkNewtWHUcjAuXnn0rJqgd1MtJ4N2j9E4sri8CUMibxcen5Xv0rBH2wvPArdyFMKduVqaE/TgYXd+bIGRvPckeKuoKZlOJIb+bOfyEh50Gre3/b6mRv70lp0vZe1KIjPoqDg+B+maOHEsp81Ke2TaS0yUMdjzPmnc74ICx16pYNGYkrScCEbSTjGYyGmkOoCIvbLtTGFYpIxImTCOyGcfUSNMlV92xXRc+dkuiNa2Ki0Q0xQRrpQivdbrSp15Asdi3nAz4bYCs3hmz+LmQJV6ZoSyV+Gopet02zORtsenHm/M0Vvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by LV2PR12MB5917.namprd12.prod.outlook.com (2603:10b6:408:175::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Sat, 14 Jan
 2023 15:32:26 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.6002.013; Sat, 14 Jan 2023
 15:32:26 +0000
Date:   Sat, 14 Jan 2023 17:32:19 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] devlink: remove some unnecessary code
Message-ID: <Y8LLA3WQG8h6B6br@shredder>
References: <Y8EJz8oxpMhfiPUb@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8EJz8oxpMhfiPUb@kili>
X-ClientProxiedBy: VI1PR08CA0212.eurprd08.prod.outlook.com
 (2603:10a6:802:15::21) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|LV2PR12MB5917:EE_
X-MS-Office365-Filtering-Correlation-Id: 3b870dd4-2210-448d-aaf2-08daf6448a1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZmdcih4vbqQU5OwaIOBa14IiUpC1ovasMsK56OAWw8v0Aj/vAedE0ff3HqDX5rOlo/DmI6UNCEBQrf4Li0KnsKWzkdmEYyDy0yKfth/Xz/gAEieWpEs4D4+B4cjxGvh+zKSU+Td/MdR7i7jjk6BycH1Kv0ghOzTnEgPrHEGWuBDw8G1450LGEBs4TMrv4Y6oh/aP7/i/rUgxZ5suwTy+bNoNvXXJIwiTB6xsnk5rDpnaMP/uD6rZJAZSo5B1b58Z5vFsRmE4cpUc/GARyuk0u/nYHxSRAtGijMhlzYGCZGEIHW9F4LXI7a7RgQ8/r5c2YUe72NmiJ91Yxdwoms9ZjrzAW4As4Q01muaoEOmo19h0gYKLFY5vU5h0/ezhD/PfD9jrX10JnmY0ouMVe7xldzWHLiIfFbwXOJwxxx7FtMbydlV2Bbn2A6LiY3y8vlG1kTggp4y8j0JbBR4cTVBgD3mZgtffA71+22kIVSYqT96nMJ6C1SlfIPIdx3KaVM4rPJebg5D5jRi+5f0KTAHWeQ/lvZeYnAxPrFytxRZY6Oi5YOWevgbXtsJDux81Ohq/nLPllwG4C15pj4WwRy5mleNmATcdCUtaeBFL2ODWc8vfspTz+Yl4Cttg+SK6tEHqSmEK+S/XfO/7Hiz64cj4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(39850400004)(396003)(136003)(376002)(366004)(451199015)(66556008)(41300700001)(54906003)(8676002)(6916009)(66946007)(316002)(66476007)(86362001)(8936002)(33716001)(83380400001)(38100700002)(4326008)(5660300002)(4744005)(2906002)(6506007)(6486002)(186003)(9686003)(478600001)(26005)(6666004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lRFqJVgA4H9h7D6gDapNmUhuUDVkpp5VeY3HvBsc9y46dIcNcb9QxI+ybucf?=
 =?us-ascii?Q?IyCpH9fwMiMZ5FsjvK51rAtHp7VaY91rrjrfTf8cazfNNU8+MRQNZea11Lzs?=
 =?us-ascii?Q?RYRanWiaP34RNOkyM7TRmbjVbbwuumFB4fDghR6JNxuiNuc4gR0D/wUoiPq8?=
 =?us-ascii?Q?aEz+Z6iSf1A7+Dxq+Ht9ZDF2UrniHN15Rwu64ujQEJNOgS5VOjiYlmLfhz9w?=
 =?us-ascii?Q?r95AYfrX+z/J+8Yti2UQomiNnsEGtCa+IvCEKQWlqX93f44AnP2cfJKeAKiv?=
 =?us-ascii?Q?GUWefSxMUelqpY6OfqUnH77w1P+OuQ5Mnza7Rt+qXMuZwmgnWa/SZlBFtVX9?=
 =?us-ascii?Q?L+z+N7zBgEdwED1UwuXRCArtAMVuTj58LA6Qx5MVa6aEzwBAB1xSQvgp66Rt?=
 =?us-ascii?Q?iZSm+oCh9b1BEj9qGmIyoVJjAlq/U5U753twT2Xlr6QFZATOc4qa5ojA4VyZ?=
 =?us-ascii?Q?I3LYP/v/5X1RqFZH0+btKAP3mV3tPSvE4dYQZ3ay8mTv9PWraP1BCgPAEVO+?=
 =?us-ascii?Q?MuUTiQSLJ8YSqQpF3uBaYaBf5Gw+VBMOw05T9Pm3dMlq6XcVZNnc0aVU/yYw?=
 =?us-ascii?Q?kkJmleqcE33Ve8E7gtrUR0cwiGaphe/p/17zbr5pb7r9CcpcQFop1ACspKaT?=
 =?us-ascii?Q?6uCkSQfj9MQCq8RCfVUeuyLSrsSeeDfixQOnpg72oDMR1IRP8cAy/Py5yfGf?=
 =?us-ascii?Q?wmKdgzBifW82Yngy2tFPp3vxsixqxWq91k342Y4u4MReBJk/2xrvmDUJIwCM?=
 =?us-ascii?Q?h+JXFQxYgGdZv/L8yBp2kZzbTHcBpQGoztuYjsws9T+8AS8BqQMfgksvUMdT?=
 =?us-ascii?Q?oRRLvSLrliG5K8IrqyuPzsz535PlN1iTR/KZorO4n7C+u7c6aAV0rHKQlvOV?=
 =?us-ascii?Q?u7iP7xQSg8To5nCNw3EPTIe6LJiPwzfFPc7Hcug//S8EnJJQou9HYw9ey1Gt?=
 =?us-ascii?Q?CAdHeQoNTWaPVVN/8Y+muaQDpyO7wrovkScsX8hYhDb7DKLAfNzlk2qdN0e1?=
 =?us-ascii?Q?6vvbdO+KWHqb1v8XUf9Tme3rgCfx/qxpgXrtpUJRSikdWVX0C/s9NBFOJkcj?=
 =?us-ascii?Q?AAWcvjezuJ4u7bQafjrA2XXc2LwXG9r4UeLVFdnnms19qtKzh+PY95/cEY9B?=
 =?us-ascii?Q?0UD1gkp9SUtMV8alCMp56aZWY0he9izd9WZES7tIoz/6+lzMRf7P2BRSEasN?=
 =?us-ascii?Q?9trevX3TztPgWPv3SVysMY+cCOaPJE07INUgvsTqYv2uKrSP0Z+97odw6Dcl?=
 =?us-ascii?Q?ax5GXHbEDkvhiJ6jH709f9sns74cny4XlJvCrp58eYHMkbC881dmttBfqzGv?=
 =?us-ascii?Q?Dy5f46MoA8P0Gv+eUvVLv6X5NYMAHoCCFM1VyhgOQDi70V5anyae2kB562T6?=
 =?us-ascii?Q?w52+ZbZSgukePbY/kjiBDjtgB32LAkPMSxrdNtqbFNlhyKHuvvjLX2z0xnMx?=
 =?us-ascii?Q?30XL+SgC7/P0SUBBEhAQ1QT/kYfX00wMSPs9TOBRnb2gT5P3sHclxgVsfLWN?=
 =?us-ascii?Q?IBY0VGpIOzXz/TUT6MqvZ3ibpjrjoi//jf2YI1ZQ8h5LaW4nm4zZ/vxX4HHP?=
 =?us-ascii?Q?hk9c9uoDEDx9QGllHXin/B7LgXpNV1jGgC1bsSSe?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b870dd4-2210-448d-aaf2-08daf6448a1b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2023 15:32:26.3186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZO1dHvG6GHSLm7FbBzj7jyhKV1q3JaDSGApHTth+KsqyuYh7TZbgkxkFXiOQ8/UiLcVqfT0aTFrL/WBxBaYf4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5917
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 10:35:43AM +0300, Dan Carpenter wrote:
> This code checks if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID]) twice.  Once
> at the start of the function and then a couple lines later.  Delete the
> second check since that one must be true.
> 
> Because the second condition is always true, it means the:
> 
> 	policer_item = group_item->policer_item;
> 
> assignment is immediately over-written.  Delete that as well.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
