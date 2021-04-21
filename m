Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4AB367202
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243132AbhDURwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:52:42 -0400
Received: from mail-mw2nam10on2057.outbound.protection.outlook.com ([40.107.94.57]:50657
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245020AbhDURwl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:52:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SRJUAZ+MNd4DudthNRkhK5QgYCS8gMzfv4NCE0yAILZ/HDdbC5lILfg459tWkYXPdjPiLkQCYrOpg7rveM5bCKXV4jYNdyipnzuVrrlVFbmrD/uV8OTI48z0Tnv8WMKXrrp9X0ceMdy3vlTcYsJs+3N1N5fOoC5uWeHwFufAR+t7BWW+DXYBbXeOCiiVQsMr17vDmS/eY8M3tARVvGkQgrwpwpO5URf1L5Xs3L5WOlqpmJvsoTryM9o1UBIUIC8RtKMT6hNgBijbs7FTjQg1/AVAbWlZAga7Vh3KVE0Pz3YClndbGoTrLwcaDrzvhS32cNm9NT9f/A4M+u0UOeid7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQbpBLHtC38a1rGX21VmGAKOFWneQarFXZXigGICSoU=;
 b=ddRXddgRklkRtraBNcxBDFhb0xdnt+cvai2oaJ0Xj76auPhfn7UrxUcKjvXs6FqK8ySLxgdDbfFqI+JOCfBANDiMl4QtZOGNuXooLUfbG9uhJEofIfzmbrfzdurtzNUtdUtVbqibkeQJYCb/YriIvExsW5mZsof8Na8AJWrbraXKG152OuxkWdEikd4OHZOqr31hD2SaLbHyYmMfd716iGYYiMLcuJtYxPCqYADUbvY90u9D7QUG4JeH+k3C7yrnZseq8ZXq/GB/WkVPMRiVs7egJZAqLpTDHVRylx6JZ+b4JMOZVTQHkrAR+Z6Udu8eE8oj6VM/juLd7wJnGFI2Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQbpBLHtC38a1rGX21VmGAKOFWneQarFXZXigGICSoU=;
 b=PTSsqXFpYR58aRVrv63HW1oeSHSPyNsu716WebC37zEA2UdD6r/sjylpAkyukyaObd+7ggZtZa8ac0P0wastilhss+tC82YmBky628SIjYUw2ZBW+Pc8mtW9dvc2OxKENmm7YD9K0ZNm/70O8a2Xeq6s/7va0Y2ST/zqGbir+RYsifwqW8dAoxgGBqqFFPfgE3Z8xqGY8ucddUFH7MV4VXpFuvU5U935iTWMNB9aUgx5lv4bCVOJUNKISkDnxcdXUWik3kpiBpZFGyjNZTVGmqX279C+CrTlI+XSgiVm8bcjrPQnM7WahrifKpjBsC6V3wAOW7FWtEDE7D5ue8CPuA==
Received: from DM5PR11CA0019.namprd11.prod.outlook.com (2603:10b6:3:115::29)
 by BL0PR12MB4657.namprd12.prod.outlook.com (2603:10b6:207:1a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 21 Apr
 2021 17:52:06 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:115:cafe::f6) by DM5PR11CA0019.outlook.office365.com
 (2603:10b6:3:115::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend
 Transport; Wed, 21 Apr 2021 17:52:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 17:52:05 +0000
Received: from [172.27.15.78] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 17:52:03 +0000
Subject: Re: [net-next 07/15] net/mlx5: mlx5_ifc updates for flex parser
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210420032018.58639-1-saeed@kernel.org>
 <20210420032018.58639-8-saeed@kernel.org>
 <f21f0500-2150-9975-cfee-1629766634b8@intel.com>
 <de33839f-0bcc-f999-7348-6ffb54a10e35@nvidia.com>
 <f6ce8bc9-7ccb-036a-7d78-3f6bf052a515@intel.com>
From:   Yevgeny Kliteynik <kliteyn@nvidia.com>
Message-ID: <d203ec4a-1182-596d-fbef-ec9f29c21105@nvidia.com>
Date:   Wed, 21 Apr 2021 20:52:00 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <f6ce8bc9-7ccb-036a-7d78-3f6bf052a515@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9185e05-5486-483f-4e3c-08d904ee2d54
X-MS-TrafficTypeDiagnostic: BL0PR12MB4657:
X-Microsoft-Antispam-PRVS: <BL0PR12MB4657E10E267965F75BA72537C0479@BL0PR12MB4657.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D016cF1AtN2VWJpR05qudXq4MMUXO/wqBA7fbyv+iI8PhiS4YN1B7pYqlTs5n9w33HoAuvV2Xzxi6CDu4rgfeAW9sZ35LJiHg7rmu3eG52bYjsCxKkF9P6zN40QpL3p/J3/dSdTUk5ttTwiHGX5b4LVJyICS5iGQR7CDHv2xXpJGxrUcecKCeSHrdv18DPa69dPdiRlx6lYsFnHrWXJiJEB7n4Y4PYIoqBvHEK8QvMj3EFNKD5lipZZwndlG8nqWFHJI8pDM3BNLjl0rBP+Fkl2TB/eir7U1wPX+avnltVIgUplA0kOtMb3pZwkMRjU7Fqeye40SeSu5picE9p5VQxOthujWQIN3Ema6YC4O1zsIIg5rhpDnMyPjin57PkhWs3L7MqVg/J5QVfLAoD8QPku8k9c8CLcSPri38+RsXhGqBPibAx0Q6+YE5ERZiQ7bizh5p7Mkrb30SHvWK7IiKU+1zc2pwokG+ZfGL+OpbX2pm7O+viiA87ILOHMLaVjdX3rd5jVUa6cVdVtP70zAVr/Do9KbaF2+zcXa3UxVxqlWcvAHzycK2Twe8oKYsdLC7UdmRag2d1LUx1jqRExSrHn8ybEZxP76SyIdqDwwCSUcXDA/RrxTJuqy7RjbDUcMfHMCX+Ws0k3UeUV1moIHMJkPBIfgt6aF6J0aWjKi/03oKMJSrLvZKk7mLP5O1ToUTmZewCJLgg1gAgUMabzp21PlGngjxktTUhbm2nlh9PJ9nzUkjQ+zAlVVu1m4dBP+wFa6B6F+m86qCFH5sUvUCA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39850400004)(46966006)(36840700001)(31696002)(426003)(316002)(186003)(110136005)(53546011)(478600001)(82740400003)(356005)(70586007)(2906002)(7636003)(5660300002)(83380400001)(107886003)(966005)(70206006)(47076005)(31686004)(36906005)(54906003)(36860700001)(16526019)(26005)(36756003)(336012)(86362001)(8676002)(4326008)(2616005)(8936002)(16576012)(82310400003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 17:52:05.7703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9185e05-5486-483f-4e3c-08d904ee2d54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4657
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21-Apr-21 18:08, Samudrala, Sridhar wrote:
>>>> Added the required definitions for supporting more protocols by flex
>>>> parsers
>>>> (GTP-U, Geneve TLV options), and for using the right flex parser
>>>> that was
>>>> configured for this protocol.
>>> Are you planning to support adding flow rules to match on these protocol
>>> specific fields?
>>> If so,  are you planning to extend tc flower OR use other interfaces?
>>
>> Some of these are already supported through tc on DMFS.
>> This patch series adds support for SMFS: Geneve options and MPLS
>> both through tc and through rdma-core on root table,
>> and GTP-U is supported only through rdma-core on root table.
> 
> What is the interface for rdma-core to hook into the driver to add these
> rules?
> Is there an equivalent of ndo_setup_tc()  that is used with tc interface?

This is done through RDMA verbs.

Among other things, rdma-core provides an API for a user level 
application (such as DPDK) to control flow steering through verbs.

You can find more details here:
     https://github.com/linux-rdma/rdma-core

Flow steering API is here:
 
https://github.com/linux-rdma/rdma-core/blob/master/providers/mlx5/mlx5dv.h


>> -- YK
>>
>>>> Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
>>>> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>>>> ---
>>>> �  include/linux/mlx5/mlx5_ifc.h | 32 ++++++++++++++++++++++++++++----
>>>> �  1 file changed, 28 insertions(+), 4 deletions(-)
