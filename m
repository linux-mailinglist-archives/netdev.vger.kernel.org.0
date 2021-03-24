Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2FD3478AC
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 13:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233892AbhCXMjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 08:39:32 -0400
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:53408
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232658AbhCXMjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 08:39:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWWMuXczHP4+TARPd2ONhbiNIlA6hcZQYS9ougbdOY+G5Cp6Xi60gCV0OqMUEZ5vzvcHNmTFMV7i3X9CZtoSzcRaikXY4dLymPDgE+UCs21CRybOP0tZ7JrzzpWLgnhEacCz3OcomP4i7tQT6MEFcCCB3WepOKYaNf52HUhBVBnqpOtAa3JpkAkPnDWSFA8Nj+VrmSMkuccW0JIXnJXqnpwHF3K8HRLv9nE4xF/ysRuFWCjFDr7lc81iEi9N5bic6SjkiF4+Ekb/q6p+x8TDsQMvYZ55BjZ1agEpxflbSpWCi1BAoVfEKgIt0XZv/gECap9t/Y6aMpSubw6u3hmD4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enfJoRjarHJ1mLxyuWHAcs0u/1+oAf80jRbEZxjwWro=;
 b=dpor8qOUFFgFMxRby1NhKZQWJ876vM8XwCGzoBKEEqlJ+Wo3kAZlgqCU4sV3iLx5wK3B+03b6JisTVvkzC/qayqVpo4xt0gEyYIjodEvbGinReeQcM0GCrs7OWq2HXU5jhL+cMKgV0tRXfPFRFR2fahl8ipRa4d+Y9E8IqmlR42uV6K0WetPcXXLtIq/xJIZRmcEAUc/9QXk4qpisECMfF0v5HhBcrJ1rE7lnifqGwG/EeilVwYfbKBkPiP1pg1pfOteSw26jptYItJhO/LGcFEz+SXxtRWpqDUf+tPDA4qJrCpkiwHmPy/tbuY5GyY+sy14jibNPNz3sZ98kWDtdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enfJoRjarHJ1mLxyuWHAcs0u/1+oAf80jRbEZxjwWro=;
 b=owZQJ25Vzl2xR6hy5XL+W4EAMnXY/d4fBhUf4+m+bPH4L7l+A6D0Qbu0ZkTkFCeL7CyLHPIcAKezEyvCzeoxN7TXK329WG4FVDnPCKyGcqKe6/oSt8dt+i6yJdTKE3QDhgsilU/TY7qhY4XPM5ceKfUcZnMxOOibFjr/7K7lkRggYQSnrOrUL+NmANAKeg/NSZsVHLsqscedSBbyZOSVgG4wqKBqqDrQhTYGO1RHbOBcnSiimoHMKQC1TZDSdjEdU8CJ/3VT6fAcaTVUcuCWNX5Y3BTtJQqMzp84EqCE0mckxmQJZbbCxmr3UxrrdFbTN6jgmZAhSIqtzR6d1NKQ0w==
Received: from DM6PR18CA0023.namprd18.prod.outlook.com (2603:10b6:5:15b::36)
 by BN6PR12MB1796.namprd12.prod.outlook.com (2603:10b6:404:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 12:39:07 +0000
Received: from DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::4c) by DM6PR18CA0023.outlook.office365.com
 (2603:10b6:5:15b::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend
 Transport; Wed, 24 Mar 2021 12:39:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT066.mail.protection.outlook.com (10.13.173.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.3955.18 via Frontend Transport; Wed, 24 Mar 2021 12:39:06 +0000
Received: from [10.26.49.14] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Mar
 2021 12:39:04 +0000
Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
References: <708edb92-a5df-ecc4-3126-5ab36707e275@nvidia.com>
 <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <0d0ddc16-dc74-e589-1e59-91121c1ad4e0@nvidia.com>
Date:   Wed, 24 Mar 2021 12:39:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB679546EC2493ABC35414CCF9E6639@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1331b623-35f2-40d5-fbc8-08d8eec1d071
X-MS-TrafficTypeDiagnostic: BN6PR12MB1796:
X-Microsoft-Antispam-PRVS: <BN6PR12MB179621C0A3F199A85EFC0725D9639@BN6PR12MB1796.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rs3hRYzt5boXrhG4jlAuZ3Rb/5P8JMrJLrPnK508G3w9y+HA2yx9x3iK57JiDC6vwfgrCOx3xwp3Zfhn2e1SOfEMB4sKjFJgJfGGTltprmFAZ7pmR1kgzwyE0ksEvQov73klhzXcgNOn3f9b5pWTz7w29WH1mtogivIr56bzmQVZuijvDAoX9tGiBzntP0g6+F+ODD8IWRkkNKMwR+TQgD7cLZZVqX4Qy3yDrjOB2SJGJW8iVn+mMNq6XxtboYSKEsIJMf7upD7Hm7l7M8UM3AnlpWJyD0l2tb7E0HLdkL31zrxtdYVREapRVgLXmA+vD9qOZNeF+MCITfh6CBd+hUulGGwL80dJOTlxgfM/o3s9V4f0ceZ5bPcLPGW/68O3r/jJaDxYCZKuNM0kButg3AIhUnqcNfvHsnhu5oJ36AbcgzHW5zlM9LCltIACWiy5NLFeDg2XUz4L/dAav4Rk/HiObpgn1W7tKn9197w/3sHtvUpLmkOqcv6VI/nMUfZyT1A6FDCF4pAjnaajSJWgkWNNhG20xkkgSPCxso/kugwSfN7r6S5Ci0tadD4oz+BPpcxbrOLlzIVJipHmtJSgmtwEhjipxxGSTMF6ltNvxJNJgCNfcKwyHY4/3F7mD+GJLAqaGMwtBZjsTGcsIdzYHYgB8NyRghxs2xFC6EgJgMGM4BEl67EQLT0njkOz5jkU
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(36840700001)(46966006)(2906002)(36860700001)(86362001)(36906005)(426003)(2616005)(336012)(53546011)(356005)(82740400003)(54906003)(16526019)(478600001)(47076005)(7636003)(8936002)(6916009)(83380400001)(4326008)(186003)(70586007)(31686004)(26005)(5660300002)(8676002)(36756003)(316002)(4744005)(16576012)(31696002)(82310400003)(70206006)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 12:39:06.5105
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1331b623-35f2-40d5-fbc8-08d8eec1d071
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1796
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/03/2021 12:20, Joakim Zhang wrote:

...

> Sorry for this breakage at your side.
> 
> You mean one of your boards? Does other boards with STMMAC can work fine?

We have two devices with the STMMAC and one works OK and the other
fails. They are different generation of device and so there could be
some architectural differences which is causing this to only be seen on
one device.

> We do daily test with NFS to mount rootfs, on issue found. And I add this patch at the resume patch, and on error check, this should not break suspend.
> I even did the overnight stress test, there is no issue found.
> 
> Could you please do more test to see where the issue happen?

The issue occurs 100% of the time on the failing board and always on the
first resume from suspend. Is there any more debug I can enable to track
down what the problem is?

Jon

-- 
nvpublic
