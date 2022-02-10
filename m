Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B34B0A8A
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 11:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239602AbiBJK2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 05:28:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238573AbiBJK2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 05:28:13 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD792C5;
        Thu, 10 Feb 2022 02:28:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=em+ayy0E3a52ONO4TcaDWqjH19MrlnV3pwTLkH+ANGd0pM1yRrR/Gi6g3mIW/+I51d+bIx1Z4b+YYxCQxalvOdl9LsDmFiWiKGTIV4WeqkiqLkCEjOFNI5yMX6o+xtgyYExAfH2Ntr4nArY8x4SSnvL5briNZofx888o/bdP9gutYVkUHWYfnuMSIZ2lMQhojdIkVxX87bL8Q7Ra955YjP1RbeEswvNccUy8Vu8uj7g/by9Rh0H3G3JdwHrGfWVG2aMatEwYlKlBokB4xPl8YWS+9io9cXiaCd8JLhtn4lYhjZCgjpNgm5cGi1SBL3uWpcBCk8XkWeurZy+eXz/MVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wSTQ4ZBqwOTc0Lr979S82i+t1LeSwdg+7to8XPUqGFA=;
 b=Pd2Ut69FCldUItFbzYa9/PDpKejHHiiOohf4oKKD6YWFkk5+FpwqFws+2iGliNCjkTUI8pNWrbgh08O0dIMgRNlasVQwx3WLgsvb1RHyboaGOAe2Z5Q0/f9sQ39nQZXxkL6LS2A4CKjsWu2arKHS+mqXGoPkD3WLUObST8WFE91MAuKuvi0Q5pV/e9xBTaoAAAgm0BkgHiOl9kblJZM5hONzAOL19zorAOIVhXNw4SAvp3Ni5BulpamXYqZX28zW8TYZi9X/Ad8h/1jt9Xhx4KhXfmDPKRa9fq5TsgahiQz55GW48LoAssKh7pobd1Lq7smWXTAKxoVxgwyyVCCQsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSTQ4ZBqwOTc0Lr979S82i+t1LeSwdg+7to8XPUqGFA=;
 b=SeZWXghe9SgaMSVp85bG3OO0BmewpmPCgJp1qXYRe4eaniyJ7ORqHP9QgXasdLme4Yf7ySJLCKYSNgBtsXzzWwXYcUTAyA9Z7O0KfwzBQ4vnx6D+bgOWfHbNLBQek5Nq/Y8M74r7OD1vybSZuL75QMnR1YB8/UPCfZH+6sQ4SoMmZbsjIix40AhLMD8W8At6qOtVovJ83cOpmMfRhaobKi1FcWcVSVDhPtU0Xz2dVEoXo4y1ydqEWgqCrAo00AASx3AQmCna0+7VoasWedeEAtJ077ltLWBeKq56w3dOG1M0uKVm27nfN5iUan4dGGrIJhpRuBP9FzZwBgGK5pEABQ==
Received: from DM5PR21CA0042.namprd21.prod.outlook.com (2603:10b6:3:ed::28) by
 BYAPR12MB3510.namprd12.prod.outlook.com (2603:10b6:a03:13a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Thu, 10 Feb
 2022 10:28:12 +0000
Received: from DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ed:cafe::c1) by DM5PR21CA0042.outlook.office365.com
 (2603:10b6:3:ed::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.6 via Frontend
 Transport; Thu, 10 Feb 2022 10:28:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT026.mail.protection.outlook.com (10.13.172.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Thu, 10 Feb 2022 10:28:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 10 Feb
 2022 10:28:11 +0000
Received: from [172.27.1.138] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 10 Feb 2022
 02:28:08 -0800
Message-ID: <b5b3b3c9-dd31-92ba-7704-c721a26aa805@nvidia.com>
Date:   Thu, 10 Feb 2022 12:28:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 0/4] net/mlx5: Introduce devlink param to disable
 SF aux dev probe
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
 <20220208212341.513e04bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgOQAZKnbm5IzbTy@nanopsycho>
 <20220209172525.19977e8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YgS4dFHFPPMITaoV@nanopsycho>
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <YgS4dFHFPPMITaoV@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d52831d7-fb48-4f84-e512-08d9ec800a2e
X-MS-TrafficTypeDiagnostic: BYAPR12MB3510:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3510290CE2239374A83D9F5FD42F9@BYAPR12MB3510.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pExNRUu+HRxv1qqZG5UgIc7v8Di74bRY2TbeIS8Qtje1w68dauSoHsO0H9cQ7YlUuQN4yPc9XyVdxT/W5HG4o2Ev2ix/OOLKZbRFYrVkBBhcyi4W8M6yii7tR5mr16kxrq/lizs6+f/XxmMP08gEuCCs8+5OX5/p4eJ0gRxVeZMcO1C9aIza1sbg9AJmug+C6SCdBNFFXI3p+LOEwpYNQJQLrx6TBrcisWrgw3CP9AvzyfkrwMuRU1shPA+18OwUl9h26aUu3joxP0Ldy4RCjqWMiA6rTwSJlBMyXiNQJTLqEDzDArS5KhqGrPB1JBqdQ67d3p3+BWkjGtC5KP/z5fdUSEFOQ3q0GtYg0tSsHCgTJNBYwBH6r4bjWjY7LIZqADeo1S23GZ2uRpDgsasRnXgTZ7Ekq9/emcE9C+K+wjVdIPml2AdDS8gS3dpvx1NhOTq++qmIGq9lCJkR6Sdi1qYEWsVfwtS4t8depmhmTXGfKabq0RntxSxvpv0i3zGxWIYt/RyMJWp5RHvRCeAmHZVkVYUyX7qLbjYbhDJ3PfQAvgMxx8cayxZXfv8NmkO8kyVJlurfVMMlEXvRrhtBstH19CN9UmiOIemr9a198VXqm4W/ei2vJOLyLdPmcUW1zogqh7sRsCTgFINBK0vDIUZZyGIPWMLuBKf53J4oWHrj2L/JtPr1pCRHjTPpjtAT1KuFrjFOI1I9RYn7aGlEtZgwJ5D0Y+YloHaa/PpuUG6mSkXMISYSg7yfRwIJ2m30
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(26005)(2616005)(36860700001)(186003)(16526019)(82310400004)(31686004)(316002)(16576012)(336012)(47076005)(426003)(86362001)(31696002)(5660300002)(2906002)(81166007)(36756003)(356005)(6666004)(508600001)(53546011)(40460700003)(8676002)(70586007)(70206006)(8936002)(54906003)(110136005)(4326008)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 10:28:11.9356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d52831d7-fb48-4f84-e512-08d9ec800a2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT026.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3510
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/10/2022 9:02 AM, Jiri Pirko wrote:
> Thu, Feb 10, 2022 at 02:25:25AM CET, kuba@kernel.org wrote:
>> On Wed, 9 Feb 2022 09:39:54 +0200 Moshe Shemesh wrote:
>>> Well we don't have the SFs at that stage, how can we tell which SF will
>>> use vnet and which SF will use eth ?
>> On Wed, 9 Feb 2022 10:57:21 +0100 Jiri Pirko wrote:
>>> It's a different user. One works with the eswitch and creates the port
>>> function. The other one takes the created instance and works with it.
>>> Note that it may be on a different host.
>> It is a little confusing, so I may well be misunderstanding but the
>> cover letter says:
>>
>> $ devlink dev param set pci/0000:08:00.0 name enable_sfs_aux_devs \
>>               value false cmode runtime
>>
>> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
>>
>> So both of these run on the same side, no?
Yes.
>> What I meant is make the former part of the latter:
>>
>> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11 noprobe
> I see. So it would not be "global policy" but per-instance option during
> creation. That makes sense. I wonder if the HW is capable of such flow,
> Moshe, Saeed?


LGTM. Thanks.

>
>>
>> Maybe worth clarifying - pci/0000:08:00.0 is the eswitch side and
>> auxiliary/mlx5_core.sf.1 is the... "customer" side, correct?
> Yep.
