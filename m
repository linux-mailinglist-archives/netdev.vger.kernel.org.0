Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE464FE34F
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiDLN75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356429AbiDLN7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:59:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3E35C653;
        Tue, 12 Apr 2022 06:57:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1LyczLx5R3oetrgfpvPNWKofd62y3ehLw9TQnd2BbyDo7Gjyvx8bONMAcemh0LmUWN+TF8LY5+0eQAH8IugeOsA3t8eiiCq+8D2RLy3ffoWhzZrmaT+44z+jyTwA9OdYCJK0dtFd+VlXXqD4DB32lKlkquqsI9Zv9UoGhfnFk39VV+LbItsdaP8i5O3/lVrW9pK9of9TYDbktKP4qkbXhRkGOT2g1o/RvYD1h5r2bnWJ0fLIMYfhv7w8KOEso2XlnfwACKfUq/c/mg1rBqJQ1lyis/KC2qKTBA9GvpPo6gxa9cDCbjPBynRM0tUQN3B2CqxI07P3YLUxxX3Mf5V6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FFFDCeNNbGaq7Qn017NKvj37IQRKr+IcxEqxf2aWkQ=;
 b=O5NRZszH68qZt0VVBiscQy8jPGOc2e7YEFbOfm+zfBlvTVlQsGHF0cxYsP202rA9iLI44jkc90dkEJ3GCNHp4B+TuNIEZGNg82BGbBxouCNyCC6tQ0zSpbcjGNc87w1a9Jf8pYXxigbtGoMSU12ejabZKwiB69CeZtDdtflgm13NvtZydNerup3Xk4ShjIZtnpFcm3WZZcbHIGvJNRFgbipTr1EEZrVUS4Qqhw2/wOJ5rcdDnzlQKSu/VL3RoNeb1wHS5v/LPTEJVFgGOUyfogVfCzVL3VmBFc6jbzwfHm6lNS6Nyg4H2zMOQFxtZ1uv/geBbaVgrZ5dDRyfUOFgyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FFFDCeNNbGaq7Qn017NKvj37IQRKr+IcxEqxf2aWkQ=;
 b=Uq6OdtHQss0zqqDMIjYkNFRyX4qwXrf+hQ8vXlYiJfnLZa7n9ca11AXjtyxe6XrpAOyY1/JVqnmDsoWGfUnK67c5Vc03DsCKHeo5T3NQL/hATQR+Z4dQjbIqbJA7ki0tfbpg2idVbfPzatbfS4DK2OHZcVPzxSBrAzQ6hPvIlAIdrJozgdbbhjmic9BtXWFRckVITLVBAl6PzoA/W0+kF5spnrFc2Un+FAwuh1CItQ41GZVUJMRCNmccNzepURsYT5t+zCWL2cECN6HeP/ge3Uojt9Q554nvkuKZyTvfZjKnVmh+HDen8UOLmNZMXWDA/0mY6xLGAZ7Fl5Bi32Ac7w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by MN2PR12MB3424.namprd12.prod.outlook.com (2603:10b6:208:cc::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 13:57:17 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::c911:71b5:78e6:3a38]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::c911:71b5:78e6:3a38%8]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 13:57:17 +0000
Date:   Tue, 12 Apr 2022 10:57:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [GIT PULL] Please pull mlx5-next changes
Message-ID: <20220412135715.GA204876@nvidia.com>
References: <20220409055303.1223644-1-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409055303.1223644-1-leon@kernel.org>
X-ClientProxiedBy: BL1PR13CA0193.namprd13.prod.outlook.com
 (2603:10b6:208:2be::18) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c951ed8-cc3b-4496-c48d-08da1c8c5ad9
X-MS-TrafficTypeDiagnostic: MN2PR12MB3424:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB34246552D94C099C486A795DC2ED9@MN2PR12MB3424.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0F8pUcJGX712OfCxv4f6+gyf3HiFUgJpITKRdeMcZJQ5KrAnA7HCpmyxhjg0kF4CMN5lTeuLVVvsg9Al1XXgzXT6RoSTkPpl4Z0VVrhEPk/uEGHoi2Lr5Gva+QkWJu9QNPtLootYJQamtB6o8KYvKGxaTgzhGzGkJ0iPZ8jUjMOB2xWPAIU+Ft90ge6PnYDUIZCY5JjnOUxWt8GjWSswqDXPSXEEkMv4Yp08mjGO51JIDJQ5mgGKDmWfd8d3gQH6romKfdEJfPXQfxQme2bjLkvyYTW558F+yu7k8DoE2Cg+1dZk2IIz13EKKJzDTvNmVwDGJoGQixCxWQWC7X4OBnUPq+zgdww4Yz1ILN70EKzGTVnrjzWxp60ouT8kvSCk/hrT8FZnQJWBMDejSX7uEHyNS3mrnQzweYGEqrS76ySi4qgpEDhB/EZPSzI9vm1y1W1S4HKI1kdANM7Q++riMLlHT7mcob/yvPawf1CHmCXUXdDKXxJFkP49Tf3+X+bc9uvbrGTLOj+ZltMX+A9kB50zUPBpIIlN87+OnmVdeMf7g3p5OpHyV6pRvL0mv1tcVNR2KkOdIJ3PBggEMcuhfrSzQ/Lv2nw20Qp4wZODJGzuBOnEdv96kTr7kFlOHMDSzIhx6V8N+1aWM43/ElbZ88h68O6YQ+kIxwe2tTcu0/8RM79PLfe5Ie5t7fnB3RHyLm3+RAnjjzv2MdlC41RhpJlmRMAYepcgSAz3Pa/ngo0VAr/nNFieXGa7Y8nDnx/0gvOU9wTVtz8QPCQxhb7qSMKjEMZc1dP5OdDB8Wm7aA61HTpli5uQkMhxWgfMqgTe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(33656002)(66556008)(66946007)(66476007)(83380400001)(508600001)(966005)(8936002)(2616005)(107886003)(2906002)(6486002)(5660300002)(86362001)(6506007)(6512007)(1076003)(316002)(38100700002)(6916009)(54906003)(26005)(36756003)(186003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ekkFgGBb10vtAjJO6rN+iWMVLiI9ltEgg3jM4tVpMV0ssTQgD+TMOBJ9Er/?=
 =?us-ascii?Q?Gw8v3bgiNa58+SQfh4mCxnW7Z2NYmG9LTY788PKYIANgL/w71mO+HCe/FkH7?=
 =?us-ascii?Q?9BDUnWia9NA6GHFkdPT5OZ3fvjG85r16vrYgeWaPVnQCm1mNAJQAouEHysvu?=
 =?us-ascii?Q?wj+VhXrI7B0AAQgAziaBv/hcia3W0NCE4VsffhwNLvfdngsdZtOO+PjPpkjW?=
 =?us-ascii?Q?PKbGTfPfUUuEL/TMeyA2cdeh1CZ8weLJ+6zHppnjTGaAz17TE1icjx4Aen8e?=
 =?us-ascii?Q?EU0ZQzTc2kSjnV+Jd0n1zXteAxp8Uew3+JSoGRwm38fPihJzkdqybfb+5k5/?=
 =?us-ascii?Q?0LBXYEPfrEYLd+caOOwKvD0RWxOoxn6xht9ySxnWxTSNvj/0dZFkwbNBoKm7?=
 =?us-ascii?Q?JtPQb60Rk11lzBV2Su3GdTJW1snFDzPRr8ZNH2Qz4jKcinXs0Xse89sSvQYd?=
 =?us-ascii?Q?X5/UgUyHkP4MWZST8iDGjgecX3CtYlGsdI+3sZ1d9Ck3pjklkc6m2te/TALJ?=
 =?us-ascii?Q?livC4QyCzkW7KbNCJvnTOcK0e+L2v91OlhUG2Qyxkt6XFAGNW7Q6H72M/tMb?=
 =?us-ascii?Q?0DG7qUJ6TbAEuLZRKoLkigyNTudvmVNkh3VqZL6n4DFpAkLxIIr0zsEAP3ek?=
 =?us-ascii?Q?Cd/p/Qovq0U852AjD1GWV6g2KkJ5BZWVRwae05JtCBjxa8UoySqlNU2i53jP?=
 =?us-ascii?Q?spgJRKFtncldkIwjw/BdGS38h6dSTaeE/ncb7BURs8kb2kU+14jRe0ClD91R?=
 =?us-ascii?Q?oFPrymNLSlT3egNCNyMdXEI2WhA+1fgCChku5GGkLGjY6AUH6D1HBWACteMh?=
 =?us-ascii?Q?CXtFQw9UzERdVobL+f0BCsJvAX8DWr2d5IvBoA2jjdUCAEmxaLOnG0nnEKk1?=
 =?us-ascii?Q?RRTjx1fp28ykT8wmUNwlPSQrPTXZxY1zIIiOnpNPrrl2SIc7yt0kBb108/rP?=
 =?us-ascii?Q?yBUBogxKckCvzjyYUwgBMFc2gEXc3Tn/ZgCWiNAftysf7xAkqD1iqAO/uQDC?=
 =?us-ascii?Q?dUZl1HurZ2HbCyHdT516WTIT9sqfuDGNCvHKJQ3qMHm0XQ75uoYIa2njm2nl?=
 =?us-ascii?Q?J4o8M+eImfUFI/8rMZjcFJlLZd9GarWFPs+V+F3fhb1afAr6Ihjh7dFjpPUy?=
 =?us-ascii?Q?i1rSXomVM4ZXfn4gMeuavFibdVSuJNNn8X0YhTgXOfuWLMR1Mi3TLfJkuGZK?=
 =?us-ascii?Q?+V0Zw4MjAvtobP4Ue4pZ3aMO+YGx4q8v4RndJwuVe1RCUFjgD+VrkY/k1CP8?=
 =?us-ascii?Q?1JWQpG0AdPiqvhaWhIM1KXzYg30R22x1qesAfIUSUkCzrY/Bm91Uo6YC3oxe?=
 =?us-ascii?Q?q2qlJH1JQtsAas4yBW+rsDvyHqo5dUfbJoQneQQ8vBxB3E4Fe+yvzE7N1dSg?=
 =?us-ascii?Q?J0tUDFBdUzK7jd4yza1pGO5CePPjaF8I6Jvsz0sglBNNDXfEodDf/hcLgaQs?=
 =?us-ascii?Q?eO9mQJwAx8Zzmq7A25/pL4c8rWmcAivQVQJfkOPSo6xs7miJN1qO9CnTJiHK?=
 =?us-ascii?Q?CT380ooFXsQd1yDJhXYmy4RpG8JCJdMYZxf1dRsSQgG536maj7J/imvHcohw?=
 =?us-ascii?Q?TxLJ2LKJ53RNGgfEg3OphEqhpxDpGJPc7E/OtZLZqkoBCOSuv8TuyEi61iw6?=
 =?us-ascii?Q?d/JDWCQZ12lmP+M6P02nCQ8ja6IZY5JAU+ZPsR95Zzm1axoxKaEG8O8dOn7K?=
 =?us-ascii?Q?sR+kU2cSF1gEYrPKNdE/ocrXHmtFrL0QXytmpXjptpAgigXEASv0EebtfMIs?=
 =?us-ascii?Q?9WZIak3zfQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c951ed8-cc3b-4496-c48d-08da1c8c5ad9
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 13:57:17.2972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PjIHaeQIdu+N/8/TPvNrP0FwlCkacxk9XHAI9f7uSxOTMK+pVsw8w5BoU3rkBCu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3424
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 08:53:03AM +0300, Leon Romanovsky wrote:
> The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:
> 
>   Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next
> 
> for you to fetch changes up to 2984287c4c19949d7eb451dcad0bd5c54a2a376f:
> 
> net/mlx5: Remove not-implemented IPsec capabilities (2022-04-09 08:25:07 +0300)
> ----------------------------------------------------------------
> Mellanox shared branch that includes:
>  * Removal of FPGA TLS code https://lore.kernel.org/all/cover.1649073691.git.leonro@nvidia.com
> 
>   Mellanox INNOVA TLS cards are EOL in May, 2018 [1]. As such, the code
>   is unmaintained, untested and not in-use by any upstream/distro oriented
>   customers. In order to reduce code complexity, drop the kernel code,
>   clean build config options and delete useless kTLS vs. TLS separation.
> 
>   [1] https://network.nvidia.com/related-docs/eol/LCR-000286.pdf
> 
>  * Removal of FPGA IPsec code https://lore.kernel.org/all/cover.1649232994.git.leonro@nvidia.com
> 
>   Together with FPGA TLS, the IPsec went to EOL state in the November of
>   2019 [1]. Exactly like FPGA TLS, no active customers exist for this
>   upstream code and all the complexity around that area can be deleted.
> 
>   [2] https://network.nvidia.com/related-docs/eol/LCR-000535.pdf
>    
>  * Fix to undefined behavior from Borislav https://lore.kernel.org/all/20220405151517.29753-11-bp@alien8.de
> 
> Signed-of-by: Leon Romanovsky <leonro@nvidia.com>
> ----------------------------------------------------------------
> Borislav Petkov (1):
>       IB/mlx5: Fix undefined behavior due to shift overflowing the constant
> 
> Leon Romanovsky (22):
>       net/mlx5_fpga: Drop INNOVA TLS support
>       net/mlx5: Reliably return TLS device capabilities
>       net/mlx5: Remove indirection in TLS build
>       net/mlx5: Remove tls vs. ktls separation as it is the same
>       net/mlx5: Cleanup kTLS function names and their exposure
>       net/mlx5_fpga: Drop INNOVA IPsec support
>       net/mlx5: Delete metadata handling logic
>       net/mlx5: Remove not-used IDA field from IPsec struct
>       net/mlx5: Remove XFRM no_trailer flag
>       net/mlx5: Remove FPGA ipsec specific statistics
>       RDMA/mlx5: Delete never supported IPsec flow action
>       RDMA/mlx5: Drop crypto flow steering API
>       RDMA/core: Delete IPsec flow action logic from the core
>       net/mlx5: Remove ipsec vs. ipsec offload file separation
>       net/mlx5: Remove useless IPsec device checks
>       net/mlx5: Unify device IPsec capabilities check
>       net/mlx5: Align flow steering allocation namespace to common style
>       net/mlx5: Remove not-needed IPsec config
>       net/mlx5: Move IPsec file to relevant directory
>       net/mlx5: Reduce kconfig complexity while building crypto support
>       net/mlx5: Remove ipsec_ops function table
>       net/mlx5: Remove not-implemented IPsec capabilities

Pulled to rdma for-next

Thanks,
Jason
