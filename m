Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B98435D987
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 09:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242126AbhDMH7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 03:59:03 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:20864
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241950AbhDMH7C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 03:59:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJyOH8cMtpdfubEEjerS7ZbWjrZWTFhckyPNyGRM5dVQxK1mr7ycOxcBVxtYZ5O8mc/dtNXyI7Bc2yIdRL29io/0CD8ARe9tk78qNnl0LEYJjmRCrs86e3mrE4CGmRobBi7rN2W82GY9/6zaYeCcCerWG8Lb/+JV9IIp56QI80khVrbI7lhFCcxh/IJhPm5bQtehzEEP6IgohojVY7kRfL8Gys/tVsvdufmFKJ+7WLQaR+wYSYgCEojN1imwF0gq0FRcR9O1gxQ6ULf6j+mo/esjT/RkkC5bG3BGPkxPENbYgAVu25uigqDAckXpjhIOmR2z1b4uXje5TrkO8ryvKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2r3bAbyzPViZrizuIcBurhMmuB/aCYWXyFkRfAfMxc=;
 b=BVXP5/fpqgg784MHVo1Sxy69m+twOOvlv2uBRmcwwpz+D6QXgdG7dKLY6DG3bkcESNYlB78UkVlu10p3qXno0q15yJEDfYjL2zJ3uTrIsWzPyWo93ZMVtVfdocVxZiTfLV1PaGJp1te9WCb7pAz5g/UIrzIesyVAbtv+BG0OJ5NESjoNh3wC+sCpnBkID0q5VQjsba+pIKzR4/Om5zwj9MeOURl/rfZ81yRaTeqcxTSz2L0i9M1huE5YifSGbvWcaEQrJvqAcplLcTfOFo+bWVt4D3OqCKWjrtYX7aWUzQxjvLqR10fp1Kf6LuOIDu+cd+UjCuNH/8jGqOflSwKiww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=netfilter.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y2r3bAbyzPViZrizuIcBurhMmuB/aCYWXyFkRfAfMxc=;
 b=QsD2hBb4+scGd05D0X5Z2sVgkmlv1gcSS1YxCRMG6ps9Gxtn7TDI81Vl75VSfKubt4aem0gqAbPO8VwVDMjvlI3GRsaQC1bvNPeC6LfKtssYemndEDFeZIV4V/Yta5uK/m+wnA4S2UQGqBRxJtGl5SB5ZJSByOCnwkDKGYlvI4M4cDJk1n5laYoIZF7uR/VPbXRESJWJXBHwJ33jJUkN7vBd6KOWMl1hsEC2fPFUhkbkIoEMuln00aUiA5ccHFJaPiHjht/GZdYjmXoMtcFqp3u7BprfI+ZT0UXfJ0LPRAa5hoe8z3wqN0cXAWwEizay+gDnJttvbHCtCqEaVflm5g==
Received: from DM5PR06CA0061.namprd06.prod.outlook.com (2603:10b6:3:37::23) by
 CY4PR1201MB0181.namprd12.prod.outlook.com (2603:10b6:910:1f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Tue, 13 Apr
 2021 07:58:42 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:37:cafe::4) by DM5PR06CA0061.outlook.office365.com
 (2603:10b6:3:37::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend
 Transport; Tue, 13 Apr 2021 07:58:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 07:58:41 +0000
Received: from [10.223.0.73] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 13 Apr
 2021 07:58:39 +0000
Subject: Re: [PATCH net-next 1/1] netfilter: flowtable: Make sure dst_cache is
 valid before using it
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210411081334.1994938-1-roid@nvidia.com>
 <20210411105826.GB21185@salvia>
 <3c0b0f60-b7e1-eea3-383b-aba64df8e68e@nvidia.com>
 <20210412114249.GA1423@salvia>
From:   Roi Dayan <roid@nvidia.com>
Message-ID: <f5568a11-aea9-277d-cabc-8ea6a2987ec1@nvidia.com>
Date:   Tue, 13 Apr 2021 10:58:39 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210412114249.GA1423@salvia>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ec456de-1d8b-4cd9-3e01-08d8fe51f42d
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0181:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB01818CC2DBB55B8C2258FF3EB84F9@CY4PR1201MB0181.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LmRmyieJiaTpno22AD3Is1BUfqbzSFTg/2KfCRPRd/HXyf/tBbzgpfFnHI7b1HU61OxaEilQwNFaNSPeF6ijaBbtpOcRq+BrxeZG9+ZgtKVIaXr8rY50FkpxLOAO474Ch4MfnbJhTOB4dVOP6wvsTTAJsODPFEEex9f+LRkQQD8LuzNrcSmdJ6fIinXtsbOlhJNiqqdvmrjbLd08gc3ECsxYkHnxYUmsVkJ9vL5LRvv2zU5+x6gmBAZ7xYRw7J7Iz5egYScXMliPqXh8COfSR2nzYrGveE3Pzx+LtY/+v40Q6ufr2COHtsTUib837Un6fJs8Q4+GD8q1KxSeX4fWt29cxh7vf0oscbC/R17gbDQ8vNdIxWNsR50cnutcA5VwdgB7dI82Dwb8KBH5vsLkYccKwdmlJpUFIlerXGg9nyKDRQxm2O02RplyIziBDNORQ86oUJ8v9+5/GulO1A0qi2RVs+YruI5y2Ta7NHpx1Sn1b5/ic5G4m0qfGwq4isrQ0ZMeMvHl87UAgMu8rHuk2CPknRjNVogkYpAxCjTJzwcuP/AQwtsMuHX/uDwLb8Na6MkmQyLFYzUuqBmTa/MZOujW/fe6Dty6BYX/tdIU3KOq1JlMj6+XxpT1FY6SEgjSUpMFbsHwFGKvf0auVi0dV2rgJUbVSc+Mkui/NoZ1o4mtOJKCMll5vToYZBI65coN
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(36840700001)(46966006)(107886003)(36906005)(86362001)(316002)(47076005)(70206006)(54906003)(5660300002)(36860700001)(70586007)(336012)(31686004)(8936002)(82740400003)(36756003)(4326008)(186003)(426003)(6916009)(31696002)(16526019)(2616005)(478600001)(26005)(16576012)(53546011)(8676002)(82310400003)(2906002)(7636003)(356005)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 07:58:41.3647
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec456de-1d8b-4cd9-3e01-08d8fe51f42d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021-04-12 2:42 PM, Pablo Neira Ayuso wrote:
> On Mon, Apr 12, 2021 at 11:26:35AM +0300, Roi Dayan wrote:
>>
>>
>> On 2021-04-11 1:58 PM, Pablo Neira Ayuso wrote:
>>> Hi Roi,
>>>
>>> On Sun, Apr 11, 2021 at 11:13:34AM +0300, Roi Dayan wrote:
>>>> It could be dst_cache was not set so check it's not null before using
>>>> it.
>>>
>>> Could you give a try to this fix?
>>>
>>> net/sched/act_ct.c leaves the xmit_type as FLOW_OFFLOAD_XMIT_UNSPEC
>>> since it does not cache a route.
>>>
>>> Thanks.
>>>
>>
>> what do you mean? FLOW_OFFLOAD_XMIT_UNSPEC doesn't exists so default 0
>> is set.
>>
>> do you suggest adding that enum option as 0?
> 
> Yes. This could be FLOW_OFFLOAD_XMIT_TC instead if you prefer.
> 
> enum flow_offload_xmit_type {
>          FLOW_OFFLOAD_XMIT_TC        = 0,
>          FLOW_OFFLOAD_XMIT_NEIGH,
>          FLOW_OFFLOAD_XMIT_XFRM,
>          FLOW_OFFLOAD_XMIT_DIRECT,
> };
> 
> so there is no need to check for no route in the
> FLOW_OFFLOAD_XMIT_NEIGH case (it's assumed this type always has a
> route).
> 

thanks Pablo. were not sure I wanted to touch the enum.
I prefer unspec actually as you suggested initially.
it works fine by adding the enum.

i'll submit v2 with this suggestion.

