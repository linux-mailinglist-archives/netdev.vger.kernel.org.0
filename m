Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784CE33D8C7
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 17:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbhCPQKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 12:10:35 -0400
Received: from mail-dm6nam11on2057.outbound.protection.outlook.com ([40.107.223.57]:23264
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235227AbhCPQKJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 12:10:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbdGYSCCaoq+uzb2BkV81guSEDEFS3u9AJQP8NKMZ5Afn70jbIhuJNv/5viMD4vM2UPZoohMiXC/4ey9w5uLmTQKzrmuTfCS4YxMtKV+rYl+G5QTRZGesVEWek+lKgolkEvdkKxVfbRloGN+sImfVUwm687IxpP31IMuws6DqHRaxJ1B2Ch73lLSRa8lcAa2CjzDiMTIaAy/DnUVW8Gho3I7Aeu2zHSZ+owSwoUHh4iXexmkpkCePv1awWjUz2QQRCsusyQv03k8+kS/bXiX60u5hoRFAm8NXjpT5aecDt1jj/IFdl8+kSQwReG8i/OH7EzTUPxjvfoNappiGrdcbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DT5jsuNMV7GZLXOjJ9IhDA/LgF/3UW3dQrdqTPLOvII=;
 b=El+55j4sg9NkETd+exzSN7+T0rGXMpmakhRp+KycQE6fl56KDgpn4vkq2kRuZ5uAl3fgv7vn9XIfu4sOsfgwC7SI7Mnla0LNlO1VJ6+wHPo5pN+caUpyDal9B3wNYMl5yXPjxn+U1rDxDCb+FAdDe6fvCsxPYI7q7mZa0rpopI9eDjWuTPLkSiVHSLoDSVF81U+EHNlfYpe5rVnyYX9lbJuhImgawlDaz6dBzLsiwcfEH46Dhd+sWGPc55cUpvRjwdVDfArSCirYr/6JiUTOzeTatyg6tVSythUevJTi0/1pBBMagNQ5plnXbbHsHVis/YEefWlNlWqcys+ztwPxkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DT5jsuNMV7GZLXOjJ9IhDA/LgF/3UW3dQrdqTPLOvII=;
 b=FgyNKdh7Pv9TQfefLp2frfcopngxV4B8ySsmojyoPGFn5auQ05oI1Z31NwG73rjrqEU21BShhsX9/SW9K7KGqGkDR1GXcXznlHwAlxBzGSErG2Dwcr9KBY2i/MdC8r9wU8SBAVc7raXblb6JuLt1O7tiWIo1eWsoM2oYzG8WYwn/YHhUovcPqgDcaSYfrNIh2i0L7b6miOCahMr9MpQ/+YCXWZQ+I4YqgbBgOFCocttrKYeICRihhsm9ExmLdE2aORE/iphAIKL1EyAgjUqcBmV07ENxiuxmF0fEoYkKZpvofO10qYBACXT4IXAnqz71x3lHWva5RmX41iGi5RT6TA==
Received: from BN9PR03CA0037.namprd03.prod.outlook.com (2603:10b6:408:fb::12)
 by MWHPR12MB1293.namprd12.prod.outlook.com (2603:10b6:300:9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 16:10:07 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fb:cafe::e) by BN9PR03CA0037.outlook.office365.com
 (2603:10b6:408:fb::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend
 Transport; Tue, 16 Mar 2021 16:10:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3933.31 via Frontend Transport; Tue, 16 Mar 2021 16:10:07 +0000
Received: from yaviefel (172.20.145.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Mar 2021 16:10:02
 +0000
References: <YE+z4GCI5opvNO2D@sleipnir.acausal.realm>
 <be8904d6-4313-250d-1557-10c759a36ff3@gmail.com>
User-agent: mu4e 1.4.10; emacs 27.1
From:   Petr Machata <petrm@nvidia.com>
To:     David Ahern <dsahern@gmail.com>
CC:     Tim Rice <trice@posteo.net>, <netdev@vger.kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [BUG] Iproute2 batch-mode fails to bring up veth
In-Reply-To: <be8904d6-4313-250d-1557-10c759a36ff3@gmail.com>
Date:   Tue, 16 Mar 2021 17:09:59 +0100
Message-ID: <87eegfgjvs.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd987a85-2417-4a4b-989b-08d8e895f77c
X-MS-TrafficTypeDiagnostic: MWHPR12MB1293:
X-Microsoft-Antispam-PRVS: <MWHPR12MB1293D5A5CCA7E5653B5B1386D66B9@MWHPR12MB1293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f/TEH6O/bkLNIwVjPZptI5XhMqlxdl72Sg7RnzUGKd01R2X00qVALbhjBV4WQqRcpkARHQqe7CSRAh4fCJEaqh6F65M0+dhJjPl7u6XRcr1/j7nxzTtyGwDjBm1buXw3mNhvwKhhLnDfCwc1VmpbN3lSnHWPGYzTT5pQHTfqoNqUnhwyliuu/bmqE+BE2ySdaqan4FO+vfzsoFIagnN2DKOFvizhMRNY95FXFM/3OoB7Fnjnk5jBLIp8AgbmMwWQ4A23CGypQ4SVqj7eYOAbuIElhk0OgivTIadYJnrI0WyTX1hgypPfrLeWDhpz3CcxiPMSdOd3KdMPbtuoAZdlsTOXthoBvgTRHDlMFvLxie6Jqs4yBDx4iPS9OQgAEPcECLimQZxotAjAjvX65gj0WxK2j1SB+17u7i9fvmd9Wv7HrPMQuVYpEGzdBOWr3QllPMVsb9bREnPAFDbtDdg9Or2vsmpjwvb+Y7pXEVEpQt5dkWYV/MpL6sKxg1NYWcrfgjmLO9ZNJ9q6no5rD0vKbefN7hEYj9bNPVO0dSty8Z40KHP75VYqKgXqYZCGl8/SeSvfFjmxiqwBaZm9kL9rt1E2FpBsxEImJsBlHLwe+UA4ir5F91Nf3NAvJu0bQgiETOivpM/UNQXKErFtgGrRhHNS2ix/7G7w4dnLMcY+IIQLQR60gi/Vkru6/XmnHbvs2T3TofAU0I8zXoJPHFrQ4kg0bsNqamPTDsME8cn14J43bfzkerjf3H6lFruevv2Eeq85YHwN2Nd4vng6cVsGcxvypIcyF9/OeGUFY0HbjG0=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(36840700001)(46966006)(2906002)(5660300002)(478600001)(70206006)(6916009)(336012)(70586007)(107886003)(4326008)(83380400001)(356005)(8676002)(54906003)(316002)(7636003)(426003)(82310400003)(34020700004)(2616005)(186003)(26005)(47076005)(4744005)(36756003)(8936002)(36906005)(16526019)(966005)(36860700001)(86362001)(6666004)(82740400003)(6606295002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 16:10:07.0305
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dd987a85-2417-4a4b-989b-08d8e895f77c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

>> Git bisect pinpoints this commit:
>> https://github.com/shemminger/iproute2/commit/1d9a81b8c9f30f9f4abeb875998262f61bf10577
>> 
>
> Petr, can you take a look at this regression?

Yes, see elsewhere in the thread:

    https://marc.info/?l=linux-netdev&m=161589291608081&w=2

I'm pretty sure this fixes the issue, and hopefully Tim can take it for
a spin and confirm. I'll send this formally afterwards.
