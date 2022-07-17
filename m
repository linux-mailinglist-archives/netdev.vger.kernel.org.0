Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F45657780B
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiGQTwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGQTwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:52:34 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82F97259;
        Sun, 17 Jul 2022 12:52:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Guj4XjHE9kPMy+sLBC0AFCOk/iTnmqYUcRzugVKrBPrfKgVAHcklpTHNXdtL78I9s5gH0DhebZ4CYR6JYhisxArj+tlkiWcuFh9ApDBYkEkASf3VgeWHf0MGr1wI53nIDrP96pzgOkkrj5CNS4KkA7tNNlB8SdaWxmxT22uhaqUBgF5gG7ct0kItIgRfG+8zERNBDcYHLzTgiXdcZX1aQcAci+YWxcmgO2hGE49KrKGILLYlKuNPI/zryvjwa2DUHxPmIXeQftUqamGR/JA4jeEFrf1+ZaEw3/AQuA5zq3hUVDm7B1d9bC+tvabB55rvB6Am+VkG80lFJMZYSvprBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYATnSoBI2wXowiVB8hvv5eLh1yYAEc1PFlCiYeuSC8=;
 b=YsfaC6msWcqKDx2kmHN940nxgMlKGBdwWPK6j01OjEKlZLlfLRNNGpCM3YW08/4h5Wt1nYKbiPcNKDUic8qdtu9rN02REPvu2l8R6b/vuEhYLklz+vrtaJE1qqKxkxpC1G+1SdI6EQI57JnLMW9T89jyrou3l9qbe9fAf7NoAlJFflvuQjDK6obm84g9alFyrsB8ESZpoSsaD/o24WZyXLchngSdxCuxskpmq6l56HDgGqqzPKppuaMV+A0V7+v+r+uzlq2sO0/dbZ0GWF4WzEfsMAu3mMahHHm9uhxpDug2MwWiKPHFKXLuQk3RGI7SXk0UpEfdRTyOqZ294wXfMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYATnSoBI2wXowiVB8hvv5eLh1yYAEc1PFlCiYeuSC8=;
 b=k9XeR2paqSefHlnsRk5WRuRPoUl9vfgre3LdlpgfOOELJZGXAnYwWI9fnZHyaN7lk02RXF/CPaZE69XDrsZkb/PKWYyXm26FBZxbAHbz5GlapWXZgkZp7ecyMwNautvsyqg7iG7sWCaSkjfg1ftp+vNmXMsT0snjW/yYdSVXyfSslYb+sCwpHHUoVXja/jzOXFvIb4BHnKAURR/WnGaN8EOe/WHYJFQEZNbrswMPUia9Q4/VyWrPcWDRZ4P06aQ9ChDrqwpcmxN2/2e5CC5fSEExHMfBok9XukWlxB7wlVYdccYw4R4SkDF96e2oeJNF/bYgYCtIuga8o6hvBYiwUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by DM6PR12MB3372.namprd12.prod.outlook.com (2603:10b6:5:11b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Sun, 17 Jul
 2022 19:52:30 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::900e:a8f9:4d99:1cb1]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::900e:a8f9:4d99:1cb1%4]) with mapi id 15.20.5438.023; Sun, 17 Jul 2022
 19:52:30 +0000
Date:   Sun, 17 Jul 2022 12:52:29 -0700
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 5/5] RDMA/mlx5: Expose steering anchor to
 userspace
Message-ID: <20220717195229.padt5g6bl23eha3v@sx1>
References: <20220703205407.110890-1-saeed@kernel.org>
 <20220703205407.110890-6-saeed@kernel.org>
 <20220713223133.gbbt4fbphzpc42hx@sx1>
 <YtEgbZh63bs7w0v3@nvidia.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YtEgbZh63bs7w0v3@nvidia.com>
X-ClientProxiedBy: BY5PR16CA0023.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::36) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6347e7f5-a480-4b1f-e338-08da682de22c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3372:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NsAHFV4s0x9i+BTtKkZ0WG990v36mCw8KJxAFpwbotcGhG8Yn7F1MKYX/wBQsMPktwHh70AagVKNVJzkCnVmLB9UcQO36ROlJ8KY6gXHIuRf3O/CdLJrZFwcBi48grk/P/85XQX+S9bd5TKizp5kE31iqRhfIL6ffLnApkiJv5Qr932NHyTmbfqR48Cw7TMGH6BvyU37NtSzb+Fdp/XUHT/b3REeFdnJBEqDkNpdRR28EhUlwHiyRPXJrBSxETIPvh0tBcGTiOpITFnD8pZN3Hv7KlL5dtHHlu+tLajatAgLdiQEqg78R34wh2KDEsifxKSRFm36nJqtG4IfcnTKLXXfXcXh/9rMKhMEs+kapHcDnB+JdbI/YFUGXM+YXSp0GMAerkX3Y8nJBYUiZdDbm8RpKCraWehsY+XqkbWO5Yk2dawxUKFeKBgXZW1uXkGfChATtqNU6HcgLj2HedSdUxXl68J8lzxgEKybEQ5SeFJUOpXO+BnLnKOxE/cbfo/R1gMXcUms7QCU2rZ6LATuU4znc25ZrI2IqcSM6uOxkWoAWVrYGP+7ZRVhlrYtcuIlaiDGkh9lzXcObtX8kCMZ1I/Cjz9hk9K3YcDsaIGj9iscaZy78YZP4hNsnhcbjJ10brH4G5MDOnsdtCt5b4GdBlmj4T49zxM25PQuOyDMgNB2nbHuq9zZ3zXNE32LvQpMIEoxt5OF23znWSChwgFNzjqVTZWvZiNYSKWbDxplg6WI2NX32PihbBCgUVI7V/WR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(39860400002)(366004)(346002)(396003)(136003)(5660300002)(8936002)(6862004)(6486002)(6512007)(66946007)(186003)(38100700002)(9686003)(86362001)(478600001)(54906003)(26005)(6636002)(316002)(33716001)(66556008)(2906002)(4326008)(41300700001)(8676002)(107886003)(66476007)(6506007)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bXlVeDg91SIpeXQJTVxi5B+KycjUfPIKn3nB4fliplfiEDMS7dtFOeDek29p?=
 =?us-ascii?Q?JzFR9LIqOZWn9osPzpHVt7PibVLFpf1afV5gK7mNoLaXMXRPPkCHOwEjwJE5?=
 =?us-ascii?Q?xRSJMHfYVRYmxsy/JXkmUbHYYLxcbG+2QhewYXkf70vQ++Im6aOF0hvEbSJs?=
 =?us-ascii?Q?qNCDUxweUFmNWRch70AhrJejCpMj0/kK+6EJBw0rOETrT77rRCw9iMPmPFex?=
 =?us-ascii?Q?5FrTJ1ziCbjC1kDxE9GEdyobhVHitaaM+SUdaQZEPbVOTgWSqrg4riSbHt2E?=
 =?us-ascii?Q?/LY4eh1vXvolVeTPV+HVr8dA2gIxE5QRxZGLtohaVt+i2G4vzlBTqz/cyp65?=
 =?us-ascii?Q?2SUU6JtmSmLB8aTzOZM54tqU8Tz3Q6rzz9flNocL13TX+ViI7FpyXMmOGgvQ?=
 =?us-ascii?Q?yaa25M9JCB/ap6qvLgmaZi6TrNX4t6q6g3an/rTq9XmxLDBmHCwkcLSOKfu8?=
 =?us-ascii?Q?t17/78zNlpvHSGuyzOcRHv4P1VeUP00NXZcCCABSzLwvyB+iIOazQ1p+JLLv?=
 =?us-ascii?Q?C2gL+teJUJgjgFFS0D01eFvxHwxPb7rLDZzMKhtcrREozQ0UxlsBtOFR1Wm3?=
 =?us-ascii?Q?j5aPTAXrY7AxR/r3J2GS9FwaHEqlK2XewzLZTIIy2xHYZNICFKtORuXoBEJ+?=
 =?us-ascii?Q?sGqQCPsKXwEtnWCfpKW6IR782Qq5yStzRDFHLh2Nr9H4hUFeniAp0+qzMMB3?=
 =?us-ascii?Q?UnZkDVfi/wRo1p/9f9VKZqehaPgzYNrgI3rfvaMQYkQkb7IVC9dzazLyUTqM?=
 =?us-ascii?Q?w+f0U0jRwaVNMs1Hv+iZ9xAmkd51touMv5ATp+sjiqZtLAII7XZZgGqkCENJ?=
 =?us-ascii?Q?W85Hz30+D8zARtWePDa5SaVIzC/H4fF88tlnv08bQBEOhqwu4ViaILQiufwD?=
 =?us-ascii?Q?oXiJ76293XcBuSOIbxkg7/jDLPki66K0gA0zkrCor7D9wK5tjv+PcEbyUsZ9?=
 =?us-ascii?Q?TFqzqjclpoivmL92cL9mhLb0zxjXibyQ+kW5Me3o9NXEhk7NScx/OFxyeOcJ?=
 =?us-ascii?Q?M6CPhu9IKsosfIxio45+lbTq4ochcCWwRC4ePZ+rc7ehRGZvWdtCMixzmaOw?=
 =?us-ascii?Q?uy4XpIFrNFdcOHX/s/DVHpdRC4w52ufuMu1apzZ1vk2lb1ULq6wgWgpjbp5l?=
 =?us-ascii?Q?YtICEJgkx6c9l+K5sueyV3Pokp+oA2mVVKt7wvy9Lfq7O1c9sVScwtkeQRCC?=
 =?us-ascii?Q?j4YnkosdvRQytqWnmSIrO34WbBrISShvU4Cwy27CT1KdUz87cMlPDvmNGJtS?=
 =?us-ascii?Q?OqZEZfCwlIkUKaQooGk6dDVgQ1NV/xqjj4eHQrZkNg/KvwsLpIboocwCJ5du?=
 =?us-ascii?Q?ZsIveQ74BichQ+kgsHk+zRQB3lijrnbYMQody+UqjAuJq0UQDvIWsEicDBKo?=
 =?us-ascii?Q?FTS2rxdXcg+xrYEsKG6gtSvN0WmRTW8pJJNTeEGbTnNuX9L8SiVoeGkuA2y8?=
 =?us-ascii?Q?/ObC/hkqdEBqLHVUCqKAcIrD+V2BY2i1QQGDZWjtYcL20I6ikmAOmq7woXd+?=
 =?us-ascii?Q?LPTOhT1U5qkv3oTSyriJOF2JOTNLSigPwX+tFaXqbf/86scY3wuf7btIclvi?=
 =?us-ascii?Q?yPCHyPHtc3uu6HzdiA0VpQ3TbGSsMdHLSzT5wBRU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6347e7f5-a480-4b1f-e338-08da682de22c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 19:52:30.5800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3SXhvdQLhGZhEZe6HFB342QhkNui8PAhJ2eUMqYfTc7ms1jr83bc2hk01xHCOKlab1VWcF70gW8Vj99gqUsgcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3372
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15 Jul 05:08, Jason Gunthorpe wrote:
>On Wed, Jul 13, 2022 at 03:31:33PM -0700, Saeed Mahameed wrote:
>> On 03 Jul 13:54, Saeed Mahameed wrote:
>> > From: Mark Bloch <mbloch@nvidia.com>
>> >
>> > Expose a steering anchor per priority to allow users to re-inject
>> > packets back into default NIC pipeline for additional processing.
>> >
>> > MLX5_IB_METHOD_STEERING_ANCHOR_CREATE returns a flow table ID which
>> > a user can use to re-inject packets at a specific priority.
>> >
>> > A FTE (flow table entry) can be created and the flow table ID
>> > used as a destination.
>> >
>> > When a packet is taken into a RDMA-controlled steering domain (like
>> > software steering) there may be a need to insert the packet back into
>> > the default NIC pipeline. This exposes a flow table ID to the user that can
>> > be used as a destination in a flow table entry.
>> >
>> > With this new method priorities that are exposed to users via
>> > MLX5_IB_METHOD_FLOW_MATCHER_CREATE can be reached from a non-zero UID.
>> >
>> > As user-created flow tables (via RDMA DEVX) are created with a non-zero UID
>> > thus it's impossible to point to a NIC core flow table (core driver flow tables
>> > are created with UID value of zero) from userspace.
>> > Create flow tables that are exposed to users with the shared UID, this
>> > allows users to point to default NIC flow tables.
>> >
>> > Steering loops are prevented at FW level as FW enforces that no flow
>> > table at level X can point to a table at level lower than X.
>> >
>> > Signed-off-by: Mark Bloch <mbloch@nvidia.com>
>> > Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
>> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>> > ---
>> > drivers/infiniband/hw/mlx5/fs.c          | 138 ++++++++++++++++++++++-
>> > drivers/infiniband/hw/mlx5/mlx5_ib.h     |   6 +
>> > include/uapi/rdma/mlx5_user_ioctl_cmds.h |  17 +++
>>
>> Jason, Can you ack/nack ? This has uapi.. I need to move forward with this
>> submission.
>
>Yes, it looks fine, can you update the shared branch?
>

Applied to mlx5-next, you may pull.

>Jason
