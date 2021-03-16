Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E8433D273
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 12:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237086AbhCPLI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 07:08:26 -0400
Received: from mail-dm6nam12on2077.outbound.protection.outlook.com ([40.107.243.77]:9056
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237096AbhCPLIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 07:08:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=demUXy/0TmIrDmDY0wW+9neXGWYl57P64H6pMczbsESDtBFGHoZOgiVtFrwrexrRMn7zR+L0Jy8M1Ob69VxmC3rHSCfmNKDk75a2xASSpaZg+6cwWdegR1fp/OoEiF+hQYoPfyAzrK9X7KhGcNeZ6OQsRkF7a4y2seCXYOVLfkK8bekgN/90aNd950kVJL3c1+FSUV3+BdHaQLzLSwpfTIiiEojk1vmdTgL4okznIg3pKjyBkxlYKIaLoIEC9jEGwed5yxgTMTE04EUSApujylK0QIlVnfG34W9dzBHBzJbetsads/SXnKj1A/dfsOiz5z+vXiOWCK5lOOeBSrPWeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vxlmah+sX+mEYscIWmvLGmzuzz9Lk/mWZ+RuaPii2XY=;
 b=BpJs5UrIK97Jc+f/HLhKW8/12Ng975FjnYFABciCXXFttM2rkpSizJ09K5t5rhzMlUN2C4RRjMHfGjHbOJ0valYrMf5ZawklQCLkDNoBDIiycpQEOshccVZZ53VP+LTxu+c7a+2I6jBqpyXT7MTKlEVvnfycWto6R23vIzQi5FK2lctbriGHDADbRSLPhqtr0Yc/kRVshQqI8ObMH5pde5G+nRvrjoWwlPq53adGL/8nJlVf0/HDvb6wqQlR8rF214R8f08DDU7yjExk8pk/S68K9d+FtT4fQELs1PekGhxhmUVDtMRKaoXWbipRjXMSu22plmd3Slqga8MM6PpsDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=posteo.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vxlmah+sX+mEYscIWmvLGmzuzz9Lk/mWZ+RuaPii2XY=;
 b=o32dbtpW84ALkYn16JKBWzgHX0546othMsYNoegfD2YZ42AyOMwkMEyDykS/8m3GTMZijCBErRAt5cTV7FtbpKw37glW+j3OBVpzTaIB/OOs9PWiaQtxXa4KJyYOYgKNL8EnBhbH+KXomF1ioXBUaDLVnS18AHX/QnCCcF89WFg3jAPs2n/mXaz2mR9tntUsbqjoYFPASCwqiYhf+dZd6CWt/UvFPD/kYiYcBAtDDdA6g5kSGmgFY1z4ra/vzw3OuqL4CoXkE6Xf5Ghv2c/aAI5dIm9Mvm4JIZOirLKGfIcVx1L5AxvFogd7HmZggE1bJ1m6VwtY2csx/UCXvc+nDw==
Received: from DM6PR11CA0027.namprd11.prod.outlook.com (2603:10b6:5:190::40)
 by CH2PR12MB5004.namprd12.prod.outlook.com (2603:10b6:610:62::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Tue, 16 Mar
 2021 11:08:09 +0000
Received: from DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::36) by DM6PR11CA0027.outlook.office365.com
 (2603:10b6:5:190::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Tue, 16 Mar 2021 11:08:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; posteo.net; dkim=none (message not signed)
 header.d=none;posteo.net; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT008.mail.protection.outlook.com (10.13.172.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 11:08:08 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar 2021 11:08:06
 +0000
References: <YE+z4GCI5opvNO2D@sleipnir.acausal.realm>
 <YFBuv83HJLG0zMbw@shredder.lan>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     Tim Rice <trice@posteo.net>
CC:     Ido Schimmel <idosch@idosch.org>, <netdev@vger.kernel.org>
Subject: Re: [BUG] Iproute2 batch-mode fails to bring up veth
In-Reply-To: <YFBuv83HJLG0zMbw@shredder.lan>
Date:   Tue, 16 Mar 2021 12:08:02 +0100
Message-ID: <87h7lbgxv1.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0fb969b6-80e1-4dab-9b1b-08d8e86bc80e
X-MS-TrafficTypeDiagnostic: CH2PR12MB5004:
X-Microsoft-Antispam-PRVS: <CH2PR12MB50049DE4125E60F75FA4A5FBD66B9@CH2PR12MB5004.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4bdkDH/7VVyb8OK4Yc2DUDgNQGUnuzFKF5oUC1jz0mJqtO656NxTtr8pOmmhLiMoOQ4fWF+7fwOQx4njAhgBuowvct244gDzpwL3u1Uxlx8fdqbelxUVslW+qOMEXhzmCQh8IqWLQLQNgGjShF27dto65QFjhpf1U9RoWQ1nmMt7DAINoHV8HTkUSXSygN+i/WfP3D0CS6w4NUrX6fvlrdAjoltfJWfmHfJopPmS3jyj8crR/aar6TCtO92R76R9G8UH2QAlXzpgDQcJH7mFvMfd4SC2I9sBIBR9GIv7iEt1s73kCg1hi9gSoAeXxz0wuARTTpGBrcp3V8l6IOgKs/OOFvEJ9cTiK5HveCbPei3yJd/4AJpm1ryPTWkvNFs8qwTv2cMu8CeK2UKQY0hWzSw4BFupTZNHfxh10u6E9yqmxBsrzKAawuzaNy5Gwi8T9sihaIsJBM1dQgZvNRgKDk82NIEmcA26l8KQT6j9tb8V6P9U6dNZz6epG2i+vDyToWJAbUp8ekzcM0EntgVz6DM4Agfsf8Ob/A1TWwh5ilbpJFHdSXcmvDl5h732FJO2SeNyfbx6rH+udvEhlxh+7edcs/+OIk9Wo4P+JkLKG86wWZNqjsRjUu3zKVh2gk2q46TKg5RWAAnyIbM5vaJiPpflPwbQVyjUwXw2M+SCo6v/UnDcE3upUVkiFkzixTtfRcbcsCadEMldYrSVLAcJMUhGS8ST+H8R8FNBOVviAIqXhmPF+EXVgsTLujRqQbPgSss2KJCEKgK95LbM5YcLHA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(36840700001)(46966006)(186003)(6916009)(356005)(4326008)(47076005)(6666004)(70206006)(70586007)(2616005)(36756003)(82740400003)(316002)(36860700001)(36906005)(16526019)(82310400003)(34020700004)(2906002)(54906003)(558084003)(5660300002)(7636003)(8676002)(966005)(336012)(8936002)(426003)(86362001)(26005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 11:08:08.6561
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb969b6-80e1-4dab-9b1b-08d8e86bc80e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5004
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the report. Would you be able to test with the following
patch?

    https://github.com/pmachata/iproute2/commit/a12eeca9caf90b3ebe24bc121819d506c9072a34.patch

I believe it fixes the issue.
