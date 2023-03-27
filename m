Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA896CA061
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 11:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232413AbjC0Jn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 05:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232411AbjC0JnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 05:43:25 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF28D49EA
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 02:42:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZiWdl8qUCSgb9FWVbFM6XMDvrfOhQrEKC5OCeKZNOVQTO7pIp3Jab40eyGUIVUYSFZIKGy2086AEfJXlbrEZ/kAK+j7dU60IHTDMnI5b0eEt5DJe1VxuETETr4z4tXWWyw8r9lNKS1Cb1sJXrekbKwG+mXWt5/RRzpY3/3X5sRxHqmTutnLViWVnqHGIpYWrICT62Ev4VO/JpDO41EkbXR2nx9z0KvJfDrTCLHJf2Wsq6BF3YUCJGazk6khSs/AU4PhuEHig9jhQVtjKLopZ0qMmMh8dvSxGTB0oFPcCJYbmHiLOdww0MUQuvKuGRlDGkBMKSQl4VubGl+/bk0TNlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQgN8DvdYybwgeXlDNpPfzPmkXF2Pz9CBuyayGh9AGc=;
 b=W7ZiD+y6hqJYYxL24TWr52Qt/WHcLD2KdHVomoOr/zC0xbrRy2UIB6o6jKnz3TVOj4LG9jxxrBbyiNqIJZmxoGvZ3hwwTae1OcpMW5PR98dZFx8uunDlvRSh0RemEgSDy+acKCdEjQXiNXVau90FWzrCGWW2GkPci4ngARobfMIQQUZ2bp1hwmGQwDW3MppXsOssFElVOWpnQ4i/GKlrvIxcetwmtqOALMCFUeyR6qR1HUXiuVDpA/9QOcHwMd6T0ybn+pcdOEgjyj1qvneZZu2wEJIH97sjvekPXTSfWEPQRFuL8A3EiIBB2Fa/W1l3IvyNLNQLjsS+3Zr3uiadaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQgN8DvdYybwgeXlDNpPfzPmkXF2Pz9CBuyayGh9AGc=;
 b=GVJj/EJL2fryy+gnU7sZ9ZjZ2SNaJ0EHSehbCP686In1pkx5DNvNQNdotQ7Ouvjl9++thYLkSNTbklA0o08Fp6vAX/5RCdRd2k/tWfU+IwkHnM/o7cfRNUQkwWvs3md0mCvHJN0/L+HJsKZ4VSVK59443zzgFGXakj7dgxLLkNhQ/YUEms+YrRhCrQ3kGYaa16QZoZ0Lvlt4wPPi7w++YtNNDofTIbbzXC5QZqRYeG1bEgnh1geEP5E/iek+aJ694y8smtZ42A4c226Hs8u5RfqxT7HpiGMFJhCZT1hVjz1baLfZiZjXTTUsprBsxMDjb86/bMjd3w2g8bA/259FTg==
Received: from DS7PR05CA0020.namprd05.prod.outlook.com (2603:10b6:5:3b9::25)
 by SN7PR12MB7934.namprd12.prod.outlook.com (2603:10b6:806:346::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 09:42:46 +0000
Received: from DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::df) by DS7PR05CA0020.outlook.office365.com
 (2603:10b6:5:3b9::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.16 via Frontend
 Transport; Mon, 27 Mar 2023 09:42:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT073.mail.protection.outlook.com (10.13.173.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6254.9 via Frontend Transport; Mon, 27 Mar 2023 09:42:46 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Mon, 27 Mar 2023
 02:42:42 -0700
Received: from yaviefel (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Mon, 27 Mar
 2023 02:42:40 -0700
References: <cover.1679502371.git.petrm@nvidia.com>
 <21a273b68773c4cbc47dbc4521cbc7dedc3391c4.1679502371.git.petrm@nvidia.com>
 <ZCBQcoypD44Upn9w@corigine.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 2/6] mlxsw: reg: Add Management Capabilities
 Mask Register
Date:   Mon, 27 Mar 2023 11:35:24 +0200
In-Reply-To: <ZCBQcoypD44Upn9w@corigine.com>
Message-ID: <87jzz2o7hu.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT073:EE_|SN7PR12MB7934:EE_
X-MS-Office365-Filtering-Correlation-Id: a8611e5c-e5af-433d-3a5b-08db2ea79f04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R9KLZ92id//f3Q08rFagVpE/wHO7EKFBmt4se1cP350wFxEiYdgKc3QP6nOTro14+2HX61eNrfrZWn6btlS/AxAjbe8HH7JtKJsmaPmJRwnRe9rvINzHgoqpyLTJt22HnfKXE7K3wICWJliKGOpAVlvgJ1EWbPkNVoO/wGd1YBOW2uxQqtEKdkkM/Vi8Jm7C9gzeyE52OB16nfKHHmfR5FLKp916KjNNMgCagkC1OnL4F43IQPjom8hzLlJrHVwsZmMHDMkaeaOct40MweJWkUy5dW4r/CGmRYMLbaK0tGwhT8ICms1l8FO6MNMSHmkxDc7EsHeN5SyBEZAbXLeDe7P3FksAOx6PWQiEQcgCan9ZPEcpWCoX5rQPLP2iwKmKES5W/mRGp+Ij4nNm1PtQXtY0WOFeix/t96hLcl53Eb+vyn4aNsrAxRtO6snGppGNR1+64Jr2bSWGnQ/LLkwhL81zI2t7fA3QasDdIhsUXYEuiTwuMdqf3krHaqmaQpujX/C26wBfieu+OeMmxTOyVty3RmxcnovSz8kNziBzYm4OCAtxAaENAFkaJFO4bHzd4UPsMxuHdb7bEZWooWjHYg+6/vNuhjKvUBRfyIhfxo0hasjUWwtwy7ux8sfy9AHo/8kGHGkezZrbvwz+drlzrQKV+rsLKSK8uYvp+E/+Q8QYVRzcF9DuX/8Aa0hy7fOHAR+DIsujAVLwwcOzHqM6IjkkZsZ9f7A3XQx1jSllGOgwiI8Hen3GeeHleqjj0wyeuxcv9oXtgMVP6Y+0Q7eC8UEW+v5DGdaSBfJ1ouygOsU=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199021)(40470700004)(36840700001)(46966006)(5660300002)(316002)(70586007)(8676002)(6916009)(4326008)(107886003)(336012)(6666004)(7636003)(34020700004)(8936002)(83380400001)(26005)(36756003)(41300700001)(82310400005)(82740400003)(36860700001)(2616005)(66899021)(2906002)(70206006)(54906003)(47076005)(426003)(478600001)(356005)(86362001)(40460700003)(186003)(40480700001)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 09:42:46.3921
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8611e5c-e5af-433d-3a5b-08db2ea79f04
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7934
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Simon Horman <simon.horman@corigine.com> writes:

> On Wed, Mar 22, 2023 at 05:49:31PM +0100, Petr Machata wrote:
>> From: Amit Cohen <amcohen@nvidia.com>
>> 
>> MCAM register reports the device supported management features. Querying
>> this register exposes if features are supported with the current firmware
>> version in the current ASIC. Then, the drive can separate between different
>> implementations dynamically.
>> 
>> MCAM register supports querying whether a new reset flow (which includes
>> PCI reset) is supported or not. Add support for the register as preparation
>> for support of the new reset flow.
>> 
>> Note that the access to the bits in the field 'mng_feature_cap_mask' is
>> not same to other mask fields in other registers. In most of the cases
>> bit #0 is the first one in the last dword, in MCAM register, bits #0-#31
>> are in the first dword and so on. Declare the mask field using bits arrays
>> per dword to simplify the access.
>> 
>> Signed-off-by: Amit Cohen <amcohen@nvidia.com>
>> Reviewed-by: Petr Machata <petrm@nvidia.com>
>> Signed-off-by: Petr Machata <petrm@nvidia.com>
>
> I'm fine with this patch, and offered a Reviewed-by tag in another email.
> But when sending that I forgot the minor nit below.
> Please regard it as informational only.
>
>> ---
>>  drivers/net/ethernet/mellanox/mlxsw/reg.h | 74 +++++++++++++++++++++++
>>  1 file changed, 74 insertions(+)
>> 
>> diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
>> index 0d7d5e28945a..c4446085ebc5 100644
>> --- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
>> +++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
>
> ...
>
>> +static inline void
>> +mlxsw_reg_mcam_unpack(char *payload,
>> +		      enum mlxsw_reg_mcam_mng_feature_cap_mask_bits bit,
>> +		      bool *p_mng_feature_cap_val)
>> +{
>> +	int offset = bit % (MLXSW_REG_BYTES_PER_DWORD * BITS_PER_BYTE);
>> +	int dword = bit / (MLXSW_REG_BYTES_PER_DWORD * BITS_PER_BYTE);
>
> nit: checkpatch seems mildly upset that there is no blank line here.

Yes, thanks for pointing this out. I saw that, too. The complaint is
that there should be a blank line after the declaration block, but the
next line is still a part of the declaration block.

>> +	u8 (*getters[])(const char *, u16) = {
>> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw0_get,
>> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw1_get,
>> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw2_get,
>> +		mlxsw_reg_mcam_mng_feature_cap_mask_dw3_get,
>> +	};

