Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A10E33A4C5
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 13:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhCNMdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 08:33:54 -0400
Received: from mail-mw2nam12on2048.outbound.protection.outlook.com ([40.107.244.48]:16736
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235313AbhCNMdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 08:33:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjqeEt9v7eLQO+Bp6NsMBnDRR6EoVptSwjX9lNiJYQIf5dZuU4a1TGmjG+hHLFyvhpJ5dNKSHV3cJG1MGAsnW4UWO029qQsQ7mM5uHuixEf0Dr+2cLBQ7lsh04yfyUmnlFT02kfwWx+OLFfrcm3FwgpOHrRo3DSPt8jHgpVpjPj4p1VJBLN2F0PU3/8ktzciqNzG3OL+/NmYB9zr2RmCx7XKNDcdQVEhPvhHU/bHgOb8jA63VdAk2wfrpztA9YRsdbtUTvyY1MXCBHrc18inAlNd2qawzUkshw6eKAJla/9G7tzFevQFHI96hlS6Rlx6uCQrySohW3vIPgEbs3AU6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+H47nl0XNLNnRVOALexUbJ1bdcQ0VYGDGESG3KZdZw0=;
 b=WkOLyGLgmwMSUsVXuaRbvJgmNMCO3TS95lwrygqzNNyTJ7YL2f1lYo2SGghEdneMHDM4UW04GzBMVEzrA9DwHz5S1ESXQJ+7A/8pjliNvEvxy3SNSNfJXvSAaWkuLSV0aoF78E6Dx2+UQ8JmPbKuQy5qvAqFrBBowfai29TqHKcIVYVGlLOtlfocEVXCZ+lmxABJFpCRPETX+3CEiTbCSYqmYAYjYq055O19462Ql6YuvhZE4kkE8iHm1IVqU1afkyRJFuDg8/b2pABYC9CK/bG5Kp95MZS2+rvpJ7Mn3ackaO8ei6AsUKVASTBuWZYoCIeKf9Gf4d6gmIZl/TCGug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=resnulli.us smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+H47nl0XNLNnRVOALexUbJ1bdcQ0VYGDGESG3KZdZw0=;
 b=bPGQ4PqemBNUoPl9xQBf6hRqhWYX/alke7mh3KFzR3kbFEt3uM3VC9AgTmuzjXGqI7dQuFtY7MACifFLSGX1Um8pwfvPofK1HrVGIzmswHqr0dM6KilSamRXxtNZ4snCYChFUh4tZr1btbirOnSgesF2Sr4iZrVzLij1jEop/X5ofVFlKN3IpiPggwdlDdoR7oBmfoh5caKzgHeeBQv2799/etnAI3kuSRphgsjfI7q6FeHiTCDA9mfhVwy8Am6LHBPnE0R9yo+UpSVcCH0cXFy5EoNWwD/NT865xdFl0BqrN/u2tsvu0aS1Ut+yXmnXfswQ9mVfRvmDMZ2q7vlZJA==
Received: from BN6PR12CA0040.namprd12.prod.outlook.com (2603:10b6:405:70::26)
 by BN9PR12MB5307.namprd12.prod.outlook.com (2603:10b6:408:104::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Sun, 14 Mar
 2021 12:33:17 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:70:cafe::cc) by BN6PR12CA0040.outlook.office365.com
 (2603:10b6:405:70::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Sun, 14 Mar 2021 12:33:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Sun, 14 Mar 2021 12:33:16 +0000
Received: from [172.27.13.14] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 14 Mar
 2021 12:33:13 +0000
Subject: Re: [RFC net-next v2 3/3] devlink: add more failure modes
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <jiri@resnulli.us>, <saeedm@nvidia.com>,
        <andrew.gospodarek@broadcom.com>, <jacob.e.keller@intel.com>,
        <guglielmo.morandin@broadcom.com>, <eugenem@fb.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
References: <20210311032613.1533100-1-kuba@kernel.org>
 <20210311032613.1533100-3-kuba@kernel.org>
 <8d61628c-9ca7-13ac-2dcd-97ecc9378a9e@nvidia.com>
 <20210311084922.12bc884b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eran Ben Elisha <eranbe@nvidia.com>
Message-ID: <8db7b4e5-bca2-715e-9cf0-948ca674b8a1@nvidia.com>
Date:   Sun, 14 Mar 2021 14:33:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210311084922.12bc884b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d3f5ba4-9bb8-4ff4-e0ae-08d8e6e557fb
X-MS-TrafficTypeDiagnostic: BN9PR12MB5307:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5307310E89C1EB3ED9E080C6B76D9@BN9PR12MB5307.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p+pFwdpU1d7x1YGtQup2f17I27EAX/WzA6eHYDJkjnUX9zaWcufjo8j9ou82ubYol7jFxQt3/5IgnJJMnYgCqKTJkapx8Ucav79x/aXnRq0gGy4mSIeGuXoPpp+XHDLy1SC30NjafOTNi0KQowNNyuUzAJhoo3/Xtmimqp/zfz0YWn6e0LByWlxS2FzACI9LXTtlL+7fM37Q74utO3DLjm9l6tkkXhZC+oiD9163f4jDMi2PO4fOvT5777cdy5v6kqZyMXii7iCCNlj4OYdh8fRuJKx77sWmWC0Y6HseKJHmrlSETYbWgZcwWDPlbevpdaapNGueKfS3S1RVb1tfDoHWbb3S7TZmW4fLfRNhTssoMkSq7v5HfhinF8djatmntz70T1Jb1oX1h9VNphwVyBz7ifHVkBhjTySMsyzA8bfxm0av0Z5C3PXavT9ZWi6evJQJuK0aCAK3sPdPg5Vsgbk+mpN3DUk38RjgmvGZJ4uGlt+jVmB2rh8vGUhdLVoUyaQxp7xmiSTsVy/hrXyPD+Tf/elVHSNDZqa+C7Kk25E35WplCavxFVdEeWGaCosDrGThnPMfEdw0Vb2aoC1ksZ+zhRJ5iqa8xfNI57Pq2Uc9gETI7ncAZT4gusyMvNFGfEiYBRnhvNwrMHQpJzfiisR0R+RyWzfnaTylFZ6rC3pyNi4F3gDxVELK7z3UNH4wRSBGyV5e87W560iWf+cugxRtfe1rOUzCfPfM8KCqLDw=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(346002)(396003)(46966006)(36840700001)(6916009)(36756003)(82740400003)(356005)(8676002)(8936002)(7636003)(478600001)(4326008)(36860700001)(2906002)(83380400001)(54906003)(107886003)(31696002)(86362001)(34020700004)(82310400003)(16576012)(426003)(186003)(336012)(70206006)(70586007)(5660300002)(316002)(53546011)(2616005)(31686004)(26005)(36906005)(47076005)(4744005)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2021 12:33:16.9380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d3f5ba4-9bb8-4ff4-e0ae-08d8e6e557fb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5307
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/2021 6:49 PM, Jakub Kicinski wrote:
> On Thu, 11 Mar 2021 16:23:09 +0200 Eran Ben Elisha wrote:
>> On 3/11/2021 5:26 AM, Jakub Kicinski wrote:
>>>>> Pending vendors adding the right reporters. <<
>> Would you like Nvidia to reply with the remedy per reporter or to
>> actually prepare the patch?
> You mean the patch adding .remedy? If you can that'd be helpful.
> 
> Or do you have HW error reporters to add?
> 

I meant a patch to add .remedy to existing mlx5* reporters to be part of 
your series.
