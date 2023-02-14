Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC36696489
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbjBNNWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbjBNNWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:22:36 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1F327D42
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:22:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmhxtPtzOgUG7zWYRQEMfC91ynsybuQh/6oDtUzscAwG0+7bTiAMAk2tEtVyDIkuW9LDsGGOXzaSnTyukJPPPojh5wkP56Lip0otSSWd4rqIvlzrBT9QwLw16xTdJhoAv9x1Benfkt3xGtHj73b+u6dtRn6k97T0ipWFznrMhVeqNobr4ZvLhUHP7NIsZziviUSSSv0ZZix0ocPMyAprWw5lPtCLUSfv2TsTo3vFHo11/ou9kCI9m8eLsk+GwrdwapzvzQ+c+WUuE4dt74WTqAewrw4bM4Fwi7+nWzPuwqkUbqWqIukzDq4AC0TUdR5I7EUb3wGekv+XYY4+ZkZq4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZcZRQnIeO0Th8jfSVFBQxMXpfZBX5z+Jfm3kIcX/T8=;
 b=VUNFZlyNI2aPlhUCWKoo1Suz+lRDYGJsC5z1z/e897t1IeY2mhXLSZL86bmOREdRl3S4mSS2lVX56QRsV+OS2u8/9+sGpGlHyu7tOs4y6UHa91zkyclQaeEkA/dr55S/trFJYpvaRraMIQ4qGubHTB0RLvVQBQY4P2T6cZIYkp6VpX3ZfJUCo11G9KCKaCD7wu5E797FbuTI5whQCtIo+qZeUe8L4Tpx6X2YSMYb7c6HKhaYE+K3ociiwuh7WW9olDMgCylwBWYg9BBuT+9KRT0s4fi8NEKsQ0iiFoIfzx+S3JVN1wI4AQis96oAOqT5gps950vzZR+9YRT8PtvL+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZcZRQnIeO0Th8jfSVFBQxMXpfZBX5z+Jfm3kIcX/T8=;
 b=JVTrOfn6cpcImI1kerFNPzTwvpRAI1drdxDWm+stEuEm5KLP7BwjD/gct7iz+C+tXN0QWSv9PMlJSPDO5wp6K+XotF1Ojk2+L3hoLg/XoTSS8F0PKnDg7zGbRCUAfVavvggZBZaeZ2ez4H+CxgqL05EhgdZ7mT1QDnUgncPYZDivnnSwuFYIRc+WHuH9DqnY1YWQhr4HhwiZhjqUpqxifuOfeBeOsBEhnODQCQivR+4OHMluaSRJbNRuvVLtbO2g3ERuaGT2b7Uwcy14biWcMsSWSVq0a90HrEHnt1u1Pe4klwnHZnN7OcpJrDojrtIEXlbyw4SbMxNPNbPiDvtIHg==
Received: from DS7PR03CA0007.namprd03.prod.outlook.com (2603:10b6:5:3b8::12)
 by MN2PR12MB4485.namprd12.prod.outlook.com (2603:10b6:208:269::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 13:22:03 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b8:cafe::2e) by DS7PR03CA0007.outlook.office365.com
 (2603:10b6:5:3b8::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Tue, 14 Feb 2023 13:22:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Tue, 14 Feb 2023 13:22:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:21:56 -0800
Received: from [172.27.0.240] (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:21:54 -0800
Message-ID: <16cd6c89-94ae-ace7-c829-38148f3a192f@nvidia.com>
Date:   Tue, 14 Feb 2023 15:21:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next 02/10] devlink: health: Fix nla_nest_end in error
 flow
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
 <1676294058-136786-3-git-send-email-moshe@nvidia.com>
 <20230213221802.04cb7932@kernel.org>
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20230213221802.04cb7932@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT059:EE_|MN2PR12MB4485:EE_
X-MS-Office365-Filtering-Correlation-Id: 492b7df9-47fb-4e7e-6737-08db0e8e763a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OrUMnMifcfs+iHlAZXjTCar7kctA4UTdVvAiKou/sdyWrxd4BH+Y3+BYp+QMg/x3cQkWW8YrIRIXULuLPnNsiA9R6cLeKJSL2X8RisXGf0Sey1CNmEqA1jBUVMphsCamY1saOZfl+dE8yDsGzy5IqoMRulyfn0oYqAZKLxItTNKmzxe6rguSGgcPnOmRexLe5LGHMt5b8CwWEx1mrjW/npNqGJMVFgbi6cJvGqKSyYI381hlDmlXjr1KsNhcKgNTiwrpwLLYSMesvsr5gmdBD0zZOgWMlIJdHxxDEVemgj04d+Iwxcv8F4QBkdAZj+74y2mvPPg9kvoIIyehIHd6qgR1xTpm8VyoJ0DteN05xHRxv1FzDSRVrwShC1YIDq5/5D688Bl0Q8VvzIB215pZsP8TAveNLHcC/fkOao3Bko+/LMZCLiFq8Z9TE3qdQVHZ3H4ZwF2PTMqXMmcpW5AKy/AGcXknXdPEsF7mHNsn9QKkpMwDZG9g+tQVPt7M5ALiyR++ba/wf55CNC9unj4yEZjx64CawH9H3ObdnAguGS4t6Ded4IaV8Px1wPdapr1UiyBQJ6VQOkcPSQk+889Hf+YNeCwdF9hPjE/z7vTryBF7PUlTNhlMaILG4u+KvSXluCUny0tIq7/JTag2zAsFa6XjSQaegwopcrcVR4X5iBo1v831A/yUb4P7JrB7mA5cSGC9cTklmuyTRBhNooO6FWqjg8tCi6PlHjbZ3lDDtUQ=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199018)(46966006)(40470700004)(36840700001)(41300700001)(31686004)(36756003)(47076005)(70586007)(4326008)(6916009)(70206006)(8936002)(8676002)(16576012)(316002)(4744005)(40460700003)(54906003)(5660300002)(186003)(16526019)(26005)(36860700001)(426003)(83380400001)(336012)(40480700001)(2906002)(86362001)(82740400003)(31696002)(7636003)(478600001)(82310400005)(2616005)(53546011)(356005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 13:22:03.3178
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 492b7df9-47fb-4e7e-6737-08db0e8e763a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4485
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/02/2023 8:18, Jakub Kicinski wrote:
> On Mon, 13 Feb 2023 15:14:10 +0200 Moshe Shemesh wrote:
>> devlink_nl_health_reporter_fill() error flow calls nla_nest_end(). Fix
>> it to call nla_nest_cancel() instead.
> If you do respin please add a sentence to say that this is harmless
> because we cancel the entire message, anyway.

Ack.

That's why no fixes tag

