Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF614D7F04
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 10:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238114AbiCNJwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 05:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238075AbiCNJwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 05:52:18 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2063.outbound.protection.outlook.com [40.107.102.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D7A457A0
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 02:51:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWA/LmV+TDXPK7XlbDtxkALq+uZzoy9qldtVnYiaObYu+q9NChTxZ96PMsKQmH2Elc7AbDV+9PX4E4D5nfILpa4W4mW00YAw9+vjaamrYSQ7CnkS63cD+L5FLWpR6oUAocnxZClPPTC8/fap2Jstq16MQQpgAvKuPjeSIBFiCxjKxKj+35hBqixV0Awcwfd75fbcPdGrY9+VBzQKKP20/X3JJ/vTVCWDW+RKswsY1Uar6Rhc3rCIoM2YFRgIHoDbOpJR0SIXJ+nrIFCk27oQL4lKTBwyTBe6GgUojBvztOQAKe2NMhUId2C7+hBROKjSvhzUWoNlsJKxbvsVWTQtig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=om5fZle4PPhRqkYkM2tYTJ7OXneLD+fS6dgg+uQTxD4=;
 b=Lxq6ujm9nlN8IEwbHXOKpsGw3P6rL0zQU1LdQv2t9aekrWO2wXs/pl2p/3W/JlehK4uCVqrYiTMgs9Md+mV03FYaAT16j1XhgKNsTluHb4fCwrb3GlI7OFdQEMPXin3IjIgfjI0CSvB2yndF3xRcHseslj5uaq5MDfQn5KyGnbW/ouoLjgdLLcbqjj65KnncJuaucgQjOlw3P4hiHODDiV/TMPc2ha+Zm2uHLJtH0mmAwjM67r/OhcwjgS8SJDGRd3UkNmTGk9tx3IDB9Dwr9wCuDV75Bfwjcs7saUo+I/Dyk8KgcThQNsZIuvZP5Qx/zGdY1ItjyDbTw6Q7Zjpf0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=om5fZle4PPhRqkYkM2tYTJ7OXneLD+fS6dgg+uQTxD4=;
 b=lq35aJT3+E2BjW2sdSkray7G9H/E3QV7Q7gaJpgDakoMoXtPAuJhcrqOZoe4Ws3ay1NIG4L6mHWKcxjaRfBxn/qdktAuob17Fq/H686G1FxAoXgwbv77V2JHQvrsjjC76F2ppUa93tLzLHzRPa3voyh/mJvihJ0yzQgCZuVWJEAe+ecvgBDGkvwFNhUBmaFu6sbYAMGPOwMy268oxxfCGbiERyKV0buqZnfUD3e7wP2RNLdNFU062fofiu+n4lKviasrDAFOabT/I0EKiP4ihuwy0+l3WrHUs9g666dBtb80VUcNyZUIxZTvqrNhsVWbv8clxGR5C3twioMyIU+UFQ==
Received: from MW4PR02CA0008.namprd02.prod.outlook.com (2603:10b6:303:16d::27)
 by DM6PR12MB3195.namprd12.prod.outlook.com (2603:10b6:5:183::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.26; Mon, 14 Mar
 2022 09:51:07 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::1e) by MW4PR02CA0008.outlook.office365.com
 (2603:10b6:303:16d::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.25 via Frontend
 Transport; Mon, 14 Mar 2022 09:51:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Mon, 14 Mar 2022 09:51:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 14 Mar
 2022 09:51:05 +0000
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 14 Mar
 2022 02:51:03 -0700
References: <cover.1647009587.git.petrm@nvidia.com>
 <7480f1df343e383234e7f197d78c180eefe92e89.1647009587.git.petrm@nvidia.com>
 <20220311170948.613fd09c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next v2 1/3] netdevsim: Introduce support for L3
 offload xstats
Date:   Mon, 14 Mar 2022 10:47:12 +0100
In-Reply-To: <20220311170948.613fd09c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <87ee34981m.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49982ede-9220-4ed0-4412-08da05a02950
X-MS-TrafficTypeDiagnostic: DM6PR12MB3195:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB31956734FB4FD2DBB32F5847D60F9@DM6PR12MB3195.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uuj6wzDgFY73j2D9iaEKlGrhU0lgzEZ7t9HKW/wxw4rPQkpjbHnT9u7UxX5UKsj8MXiUAkroF0T7/lW8MKuevxtAF1c1EaziVZW4dd8dlO9WjXDRCr4aKBF9usW+BaSSqvfmmRwD/3keRoqYyw/tdM2p04NCz2DYPWxnkZwR2ouBH+6buiLXulkrXVwGz3RAMPBPVzVAxjjcEzMzomYIijh6FoOgBzPlHLeNAZBHcvxkGMqDD/ti07jXSti4R5beeLgDDhtmINpoOtO9SdY51YLG1vUWCMpWrygLdGKaG+ksy0pHdh/XHs1BgSl6fNqJJLFND8gJ94m4riqQjmJIgI4i0IEZMGnC6ye8/BugNGCq90qOuCmsuaTDp4GF4lN3cNPSgqmtjPqH2dzCHXWk13JjWm8Kk/IY2PDNkEZKuoRAE1sm71gt3ACJKFitEBt0i61qVzoDe4QxGlZvMGnV7P+XJdLvX4SuYshKgxy3puK43NdQO5obwF1WJJrXxuENEX2LrSWKs8TLpzdL1sNWjosj+qxVKcEAO7Nw3ZQF9RONM2Ye/GqzMRUe3rtwFFkSYwfnGqg5jDWPW5P/QJNmJKd3wyiI/HK8f89fL+z0uX4AGwgjVDmsvV4dG7Y25i965ABDTT40TQGO81NrrVP0FTvB3r6uHWyfV8zf8RkN/Bywvv0uOXTgyignsZLr9VlHFZT5hKx/urptIUrNHyZrFQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(81166007)(47076005)(356005)(6666004)(107886003)(426003)(26005)(86362001)(186003)(2616005)(2906002)(16526019)(336012)(508600001)(8676002)(70206006)(70586007)(5660300002)(36860700001)(4326008)(316002)(6916009)(36756003)(8936002)(40460700003)(54906003)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2022 09:51:07.1285
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49982ede-9220-4ed0-4412-08da05a02950
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3195
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 11 Mar 2022 15:41:22 +0100 Petr Machata wrote:
>> +static const struct file_operations nsim_dev_hwstats_generic_fops = {
>> +	.open = simple_open,
>> +	.write = nsim_dev_hwstats_do_write,
>> +	.llseek = generic_file_llseek,
>> +	.owner = THIS_MODULE,
>> +};
>> +
>> +static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_disable_fops = {
>> +	.fops = nsim_dev_hwstats_generic_fops,
>> +	.action = NSIM_DEV_HWSTATS_DO_DISABLE,
>> +	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
>> +};
>> +
>> +static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_enable_fops = {
>> +	.fops = nsim_dev_hwstats_generic_fops,
>> +	.action = NSIM_DEV_HWSTATS_DO_ENABLE,
>> +	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
>> +};
>> +
>> +static const struct nsim_dev_hwstats_fops nsim_dev_hwstats_l3_fail_fops = {
>> +	.fops = nsim_dev_hwstats_generic_fops,
>> +	.action = NSIM_DEV_HWSTATS_DO_FAIL,
>> +	.type = NETDEV_OFFLOAD_XSTATS_TYPE_L3,
>> +};
>
> clang is not on board :(
>
> drivers/net/netdevsim/hwstats.c:404:10: error: initializer element is not a compile-time constant
>         .fops = nsim_dev_hwstats_generic_fops,

OK, I'll figure out another way to do away with the redundancy. Or else
inline the definitions.
