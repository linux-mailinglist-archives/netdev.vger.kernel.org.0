Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0844B8653
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 11:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiBPK6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 05:58:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbiBPK6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 05:58:46 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2065.outbound.protection.outlook.com [40.107.223.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190379319D
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 02:58:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sx0Dc+j9iY6VsaBoRM+ANpr+JL02O4DTSpGgJK9mFiSCwz7vFlXl6kEPmJr1Etdy0r64w2N9gyogqV70S3Yc/tNxBHAcLOnHHGXeind55C2jgTO/kCEJhdiEnvfkab/i/2hvZn/XTwt5E8R9nJyXnCz9A/RoKsUDlL18O+DQufU1lY+QILyzb2vsydhQ2/6uC0VDsDiZLl9D4f/3Xpal8QlT8VNJaZxT/KuqTUaGF+wMciwGGSEp8DWnGq+YkZHH6VJLroA/vtCAa8DfkiJVWVg/dtepVNMgdO7PbbIylQWCXqzm/Xa+MQHbY6FycAV2XurWzorAwMPuwqtFSgJL4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uUlwO3q/rZd9cPus+S9vo7HQzya2QO4pzruuvj0xtY0=;
 b=dkZMKbz2LsgjSwnL30iR5Vm7h786D+Dfyq5NUx9P+qdgc063GBKbaT71dAjHK0n/DlKH7YJv6Zttq42GqcOTCY7b9pR+k3VIH+U8RycxVAFd4bJJNK8241S8sopqr87R2OYdYKm9rV4xgUo56533x6pVqmAQRBfMpCiUD3YL+JA3cQZ+DLa/gKP4hr+0+bEp0XCGuvQg6YiEdEqXJwSRnd4Z1+FDYwzNhEn1xdsTA7Vk1zYThRZlfW3fK2D9lXXdEm/Ul4ZMN3rnx7h0TDNjGTD9YIFu3caLjehrxGfZOZfSz/9BCc9WDXHZp31EdQnpLVV3NvnaP44o9PYxifRrNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUlwO3q/rZd9cPus+S9vo7HQzya2QO4pzruuvj0xtY0=;
 b=iF7CYBI/wl/2ffiO01Y1xnZMQdEpQNhS20qzgBsY7kjuurjOxqTgpbflaoLds6f64hjWlbJVtFZ9ecSZqFtaXFtVdckrRaWqrWHTz4tsiU6hXpCRbaymlcYPlyK053OYu3vK9mMjJpWeuah+l+8aZimWpjsnTi2NyJhrAqUKQWUrcY+a0GqgWkWPekNyuOHDhZoSeQKeoaNAdB1xy/1IwSq2gEeXGcKxI4P4Kn8vpXTM09Dn2dyun/ALqMu5J5gXwSwvpkW+xLjrT+DtObQiUQW2dlwKjaIh+sJnydM6t6redHe/5SLc2Tft5SRWOZv3OJ6XOHUi4BnaHcOMvrUXRQ==
Received: from MW4PR02CA0001.namprd02.prod.outlook.com (2603:10b6:303:16d::21)
 by MW2PR12MB2396.namprd12.prod.outlook.com (2603:10b6:907:9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 16 Feb
 2022 10:58:30 +0000
Received: from CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::3a) by MW4PR02CA0001.outlook.office365.com
 (2603:10b6:303:16d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14 via Frontend
 Transport; Wed, 16 Feb 2022 10:58:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT034.mail.protection.outlook.com (10.13.174.248) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Wed, 16 Feb 2022 10:58:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 16 Feb
 2022 10:58:29 +0000
Received: from [172.27.13.137] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Wed, 16 Feb 2022
 02:58:22 -0800
Message-ID: <4b64dd30-01c4-b6d5-0773-9d76916aa943@nvidia.com>
Date:   Wed, 16 Feb 2022 12:58:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 net-next 01/11] net: bridge: vlan: check early for lack
 of BRENTRY flag in br_vlan_add_existing
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Vivien Didelot" <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220215170218.2032432-1-vladimir.oltean@nxp.com>
 <20220215170218.2032432-2-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20220215170218.2032432-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9c55717-432e-4dea-fff2-08d9f13b4483
X-MS-TrafficTypeDiagnostic: MW2PR12MB2396:EE_
X-Microsoft-Antispam-PRVS: <MW2PR12MB2396401A5B4A2F26FF9EB058DF359@MW2PR12MB2396.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bvgtIkMb0eCNW5NYD3RwJSM3QH6HaxsUGiuHqKlVlUPkzPgRC1xkgaaqdVhMVmgDytZefXBAWbZhH5olCIRQZHpZpHhNwQnYHhSQ6RZXjdrvrrh72b6BVx82gOc89aUQt1SEEPxgiIYM+xOxMrjOsLr7B2y+oWB4RCOJqBerU4UCWtgEf0UNOlC+ISWi0QqhdV15+4FpkV24NLYGJjRxpjVtfvKF12gq6UzbQq2TgXHLWuRkew7OLmbTBlpxVJxJ5Ywb1Hv6Mym4BY/qp81hDcasEQu1bd0aUWaIRKVJwZWeis0CbJgLnv5bMOyDnUC7DcWi8PNxk529EY9NODlk9mEogdJjBgXGlGpP6m1i5NRL3ZvJMEOrvGKrB02akcLl5xXCwG8IiQ4iRTeY0HBX6vSoT1z47IGy1Bl3jLlbMwGBTc7kaUV0U9MuAk57wTku5RtwFx8r8foUI0YgoFjJzR5Y/CPR9jXH8W/1esegaZC4QLgQIgnzaurIS01t7Ub9zmmJfBma+9Y/txH55TDaRNzEZgzCx+bZgn3VrqQX7/PrmJqwK+uChiz4Mw2PqxR+bylpUB0WvHhMHvaNWmnEHFKQRNx9AJnVJ0Ms+GBrjlbpcHnjMVfnzkl43lJk0Ny7/WuS9nl3oHK963uZR02/uQz6mXl74QIreAzotVUxiLBfazG91gjOCYNrgdINMJ6tv+MKNQNvlX9dqgNCoR7Kgu8DE8fmDq1PbN0ptW5v0SLu/A/mpXIm4tq448ACUJKi
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(83380400001)(53546011)(316002)(16576012)(54906003)(36860700001)(8936002)(508600001)(6666004)(110136005)(82310400004)(47076005)(26005)(16526019)(426003)(186003)(336012)(2616005)(356005)(5660300002)(4744005)(31686004)(31696002)(4326008)(36756003)(86362001)(7416002)(70586007)(70206006)(2906002)(81166007)(8676002)(40460700003)(36900700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 10:58:30.3408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c55717-432e-4dea-fff2-08d9f13b4483
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2396
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/02/2022 19:02, Vladimir Oltean wrote:
> When a VLAN is added to a bridge port, a master VLAN gets created on the
> bridge for context, but it doesn't have the BRENTRY flag.
> 
> Then, when the same VLAN is added to the bridge itself, that enters
> through the br_vlan_add_existing() code path and gains the BRENTRY flag,
> thus it becomes "existing".
> 
> It seems natural to check for this condition early, because the current
> code flow is to notify switchdev of the addition of a VLAN that isn't a
> brentry, just to delete it immediately afterwards.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: patch is new
> 
>  net/bridge/br_vlan.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>

