Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966B86075FA
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 13:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbiJULUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 07:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiJULTz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 07:19:55 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2062.outbound.protection.outlook.com [40.107.223.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2018E6170B
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 04:19:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFiZSvcUdt/jYuQleXJZncr616va7MMYYbV1faGMVD9/NbeKWlHLOrjxulnfTXjctMVVk/br2k8W/aPRQZqbOigKuwHrg1Mr/FvMDfE+Obx8+o74kGJPVNUAdu1gSeMPQut+YfdmEyV+uNh8cJZ1GCnegouumNQduqqQGLlk3AM2U5sICQBuxgKGDlAVwh5RyG+84AUqeZxErOl0lkfZY1HVFzZc/uiYNirkJUjlP2a7+E0stxLAhzvwdhnLUKF2+tG9R2tIgxMt1CQgjwpj8t7qKhDFkI8yfK9Z6LVHByq1ud/viLp9C1jcrygmYrz64DV1GPwdxgqI1MH+0gvl/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hVoyD1Q6EFBTA4VL7KQRJf9SC5LDmjsqm9S9JnQSXOM=;
 b=XKJo4ChACSZNpSAcqcRuyF9zPjLnL6geVs7X6eobZ91r1iSN/IStJDydWROK3SZYQ98UHScr79gVB6WMuiO6ZpO55jIOjZWXhz/Xiz8zLDdRsuXeprM2vzjh6JsoPiDHxPt2GlSRmiFcFe1TBR6aVycd1Brkxv+HdCXcSdPytumXhrqLTONwlYrU3aSmsDAQndZITwbwBIPaVjH8UIJx4B+R267QPGdbzZ6v3N4xFcVQOQprlG3DrTH7N6oxiyMLhifpf5n4rWBA/kXQySCnzKz3bw3dVSGdDFc7hSvS4Pi3dTJFhvIyw8mwSCrfdrblTREtJd0dbSioV9U3Fr8hlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVoyD1Q6EFBTA4VL7KQRJf9SC5LDmjsqm9S9JnQSXOM=;
 b=g9KS2Qoo4TnrUM+6dD/ZQM4RMSEkbZUtLy7R4Qu1Do1apbeEqPHQveGrEHyeM1WJKYVgczJ7khwqZTBKAIACioUWJkDBNjUWrBrZQ7zd40f9DHu5708O0whV/QIeXIbfAfMe4IMnttthoe8ZEFFjQG7adgoys27S8P38Qb481+Humw4MZFRbxHM0J685wHys4vBhKsVk9hB6ENR6ZMo6tFA1TyyF0Ep7JOMyrRAkuwa5Mq/ALJry1eBgAxw4+CMxszn07eVCQT2F6j80CsChUp1G/dgLirKO3TqeTfQswcGJpD+X8NK1OWkoMfvg6MPlGdq5UHcfDhZwMu19Y5pZnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com (2603:10b6:a03:45e::8)
 by CH2PR12MB4924.namprd12.prod.outlook.com (2603:10b6:610:6b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Fri, 21 Oct
 2022 11:19:48 +0000
Received: from SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088]) by SJ1PR12MB6075.namprd12.prod.outlook.com
 ([fe80::b8be:60e9:7ad8:c088%3]) with mapi id 15.20.5723.033; Fri, 21 Oct 2022
 11:19:48 +0000
From:   Aurelien Aptel <aaptel@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, saeedm@nvidia.com, tariqt@nvidia.com,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        kbusch@kernel.org, axboe@fb.com, chaitanyak@nvidia.com,
        smalin@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        borisp@nvidia.com, aurelien.aptel@gmail.com, malin1024@gmail.com
Subject: Re: [PATCH v6 01/23] net: Introduce direct data placement tcp offload
In-Reply-To: <20221020220540.363b0d02@kernel.org>
References: <20221020101838.2712846-1-aaptel@nvidia.com>
 <20221020101838.2712846-2-aaptel@nvidia.com>
 <20221020220540.363b0d02@kernel.org>
Date:   Fri, 21 Oct 2022 14:19:43 +0300
Message-ID: <253y1t9v2y8.fsf@mtr-vdi-124.i-did-not-set--mail-host-address--so-tickle-me>
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0459.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::14) To SJ1PR12MB6075.namprd12.prod.outlook.com
 (2603:10b6:a03:45e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6075:EE_|CH2PR12MB4924:EE_
X-MS-Office365-Filtering-Correlation-Id: 8791e088-7358-4fe9-deab-08dab35629ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oXDFE0KGCfk9P+Q5ehmmz9GqPSENlEK8OHo8Zt1JEosGXxa591inGl8jgKRN5H4Kke/gdFbz2geqTF/sEqKq++14omnH90XRjFJvEZAN76dbp8H7YxM9g0cuvDEJOWGjFocMVHQ4PoJS9RFVQKpl+RlIpB+IDjuGcMEXqX3BVBKbll7wJZpC24eo5S3mHKUBS2dP77HGrsAws/HaCJzlb+V1nKnB11F71/WSDL+6vwL5NcWPCH2DS02BDcrE+NODrsqWzFdFrPBT8w6EgveUJYHzHePakQd+L7kZS4fGE5iyrK1q8uOh27nd2mgFBzXjcmazTNW5+xMfZmEeTcNIeMTjpm/KF0j8ClX2IH0k4TOo9Mb+meogxWj/7pI/rQcfuk8OqJIg8qKfn75yLE0TPJuXx+k0fvevc3YLOLtxJM3SqYEu9/n9B1joU8pcHk4m/3TdHfFUt2ZC9Xz/XiZF2Ve10RfeyciIj8sm5Kud5gfEew1WEfIuwtBjfPHJamdxaBjj/vbwLVml4lbYCEagoD6O5grdAbuXYDSKwFa0Zi+QEu78Y/CcSSPlxB8QIcriydKSEdTDOqg/41XdduhEgQKG/UN3txt81gF1mH5R8iHWUHSr0mZAh1ava8Krha+VT/RzaAJCuFQJc/FfLLxuX+G2xA5qXPzOaEQqgpPC2FVMUP7cPFtKeVMpE+Ugq6Ub61m94Tm5K2aFnWu7BPwWWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR12MB6075.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199015)(86362001)(38100700002)(5660300002)(6666004)(4744005)(26005)(6506007)(6512007)(186003)(83380400001)(7416002)(6486002)(316002)(66556008)(9686003)(2906002)(8676002)(478600001)(6916009)(41300700001)(66476007)(4326008)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cZ7oyMdpqfmZP8LBZrU8dPTfFSsesKAVcfnYnsO0gH9arPfkHp1q3a1FHaZK?=
 =?us-ascii?Q?TOt1cT+IBFVfrNPRSZdB36Abns9Iw05orL8L/R9YhErb69a9L+vFpQoNngiG?=
 =?us-ascii?Q?a693c7Pyhvybbg1etbVUb0+dKV3X6vjKfPtoB3Lys9EhSgeFq+EdaAuQDvXu?=
 =?us-ascii?Q?H3RvqYy+f5gpSkgigZFceZbalBE0ROaqukojTRnzRH7BtK4kcYOPMhxl31VW?=
 =?us-ascii?Q?UIcGyfCjh0jru8tO2GwvNqvNPeeG+zpSiGk46JW/9F8AYIyLwNlTuVZOPYV4?=
 =?us-ascii?Q?j28P7jDH2d3xlLnDQLetd4s/Py774VAlVs6InhoIqfvlLtHgY1BjL5PqVC9y?=
 =?us-ascii?Q?dt3AZvE53KuJ2ErsuRZthqAiPaPlmWo2NFvSqOKdIp8rBu2SfTrMRu3bfGSr?=
 =?us-ascii?Q?xpB35D1TBW157pl8UHaZTqPlw7N04HWjsLzCBxHC5mv3GVv9IKOahQeBRTuY?=
 =?us-ascii?Q?3AckDcbyxopcjF9tQ0Ls44k/jKtmaflBYGfN45b1IEgSF93d6DLSyJyedOaX?=
 =?us-ascii?Q?oZJoTMdG6d02m888xN5Db9yaxmim6RVoxlaKswPYYE78o0jD6OHr7EAi+dPQ?=
 =?us-ascii?Q?mVT3tXZAAtIt1vFxj86t2OrPUZYcDPaovEzKjPkJrIk0h0SjyL3c+OXFJSDc?=
 =?us-ascii?Q?IwA9xxuLc3Uc8CBMB3ketQnhmVPBPt5QQCSgMrUT37JbpNgrm7R0TbyBuerv?=
 =?us-ascii?Q?M0SsU1FkMmHtBNA8v4kNs47Sy3bpcqo5VJ0tzaVLuFTJgGKohRRvcDMVn4j8?=
 =?us-ascii?Q?X9FjlXvnE+zo6TV+SBpoa0v3QHzDap9KIwCfbAN+FfRMpxrtmNv2TkoLnPN9?=
 =?us-ascii?Q?2mLiTANXJ9fkDyobVa5CAxoeqYzPJ7Xe9TwSMTgkdR++zJgrNU4Rx9Nau9hH?=
 =?us-ascii?Q?/g29kR0b5A8xeQ21tBRE9NOxJ3Cp2UyZ8kLZb9rzRrCk5RLo9wA95lCYsNMP?=
 =?us-ascii?Q?hAw8Bjd7th7rMN5Uhc+FEXmU90aCYaXBCA2q8XwLWmLk3O7H6bmfZTsCfbls?=
 =?us-ascii?Q?uBgiVQabLPZe47njSdSgUmfCnzlBc1DUN2/3z4xmnVHmuWFOgsulQgfel6Aj?=
 =?us-ascii?Q?sjCZbu15dLOgrUPpGagnwj4RtK8tp7sHOqer70h5yq7CRDKpudGNBcAAdYn1?=
 =?us-ascii?Q?n3HrHmzKsGOAwecc7/NdFubT46wd/WMoWV8tRmJYME2Iz+SFGGuowP8PLXMB?=
 =?us-ascii?Q?ignoYJgTUo2wN+dBSF5KEAuzAbhqE4pQjG1El7+mV7afBsJy3UeKfbfrCtrW?=
 =?us-ascii?Q?YypQth+yH5XLiIO/GCLzCyp0ghYqeClhnCd0CZ/F1lZN906HgeqKDRwXgjlo?=
 =?us-ascii?Q?39ECEkEH8tesZETa/b7advTIDr43YXBvJPv6smUWPSt4Xuqf/hFulYJJGNEV?=
 =?us-ascii?Q?s4Rm9n+9gUIHkIcq3szN+vKlHn9QonzZjASk62Gq6xXP4uf84RzWD1ZJCGxX?=
 =?us-ascii?Q?HcQnSmj7bNR/rHavDJvlk4ZRZ2kuLeXCwshVz5XyyTYPr/DlRfodbWXh48hN?=
 =?us-ascii?Q?Tpiu1soL6bcUKgfnC79tY75dxuKK4xg3osXNwvT+r1AYlk+mLAQJbWt6cZpi?=
 =?us-ascii?Q?DeiDnbWW4Y9TtMo2c8Ku0EqDCkLiQxSqmvI3M06x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8791e088-7358-4fe9-deab-08dab35629ff
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR12MB6075.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 11:19:48.1259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKSrm5J1OIw80VMWtfctiW0rIytPMw81+sNNpjPNn65Lfm30J9KzjAGUKFskSWZG/V8WeG0xGYucK+OSxp0sIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4924
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Thanks for looking at this.

Jakub Kicinski <kuba@kernel.org> writes:
> This spews 10000 sparse warnings. I think it may be because of
> the struct_group() magic. Try moving the macros outside of the struct
> definition. And make it a static inline while at it, dunno why you used
> a define in the first place :S

Sure, we will update it.

> Please don't repost before Monday just for that, maybe someone will find
> time to review over the weekend...

Ok

Thanks,

