Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B584629B4C
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 14:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiKON62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 08:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiKON6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 08:58:25 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A131AB
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 05:58:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJR+//6e6gGcjELJ0YJDGOrL2Wkt/5POotLKjYg8KpKhPgkyPq+Y2JkQlqw3KHmTyIDvvPa0+k+t1jPswX2A0NuJ5ZmzLIm/NLzoRYQ3bwkuUvbL2gSHJPKFKEZBRFx+LlrRO47eW3E754DsDATL2Gj63Ln+cx1Ue5u10bDgU241hnUQrWg67MYAzMTqgUlZTODaG/RhaYufD5ZaWMRzTa/0kTzwMqWuTy+zFHIDeSys7CH0ahDIt8LAfpi6k84X/gQrop7FSmmLmYYZ2Rw8zcwB2jri8L55egkHzcE4Dcf04mX3jgZfa/zUtU6BHMG80kuBOeh2gVRM8MpUHdCiQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GYuWwG7asDV1uTg64E1ZfHZ4su6YMZN4hqlSltPSXTQ=;
 b=ED1DIVTniovDb7+4u6HTNZ6QOXVrPRh6kJ+1zl8w3j2bo75Mi4sWy0b+aBB35Wp2h9Av14nMAeROOtgtDP6WPtOOUkEEx8mmGyNMMD5hV5xJhpqZ+bAT/w3bnkX/kbp7eWfSIVIjSKloU1b63ivPsbeIQlOdEebzB/pPem/3HVk+SB8uis0dL/1HGsHT7dmfDE6BMuDbaOuXAqDsCU/Zq69B/ayTZfqgiZAV8xidMkZGrgTAc42/Q0L8AMLPc3A9tRfPV93u4edetS88aFFf2HcWo84qp4MXvHCJVX/0AqjO8r4M5GF7mcfK81p2/f/ouVx/12nMWw04vOPVTiQY3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GYuWwG7asDV1uTg64E1ZfHZ4su6YMZN4hqlSltPSXTQ=;
 b=FTBRFO5WGCNC+ffH7sgxx0JQr1l1k8/uKdwhREDVjacJ6ZSj99kc/YbX9hUIDa0wTz2MORQpmeDJSKh4byEVtTaqUyEA+UOeR5ol7dZWfCb6h8UxkRZfWpu2NMkwG2vbVAhLtgoAyQlwYxOA8M97oEM8Vf3R/usL2xsla8zQme3JUhGDIMy4KYNbOqbcUfXH3PR4VD7+EWHLaQ/6Z5WvC6TsZIUFrEKGU1uzj+DMHvwvs63ECXbjsuwjY/WQzN55WjuhpS6M7uLjKPQr4Cs8EmdokeVWWK694fJ8IjnqmJLkbSc+vmZCzVqv/YD2kPMV7Z/gtIBIS82o51IngKvYTw==
Received: from DS7PR05CA0027.namprd05.prod.outlook.com (2603:10b6:5:3b9::32)
 by DM6PR12MB4170.namprd12.prod.outlook.com (2603:10b6:5:219::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 13:58:22 +0000
Received: from DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b9:cafe::d7) by DS7PR05CA0027.outlook.office365.com
 (2603:10b6:5:3b9::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.8 via Frontend
 Transport; Tue, 15 Nov 2022 13:58:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT093.mail.protection.outlook.com (10.13.172.235) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.12 via Frontend Transport; Tue, 15 Nov 2022 13:58:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 15 Nov
 2022 05:58:08 -0800
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 15 Nov
 2022 05:58:06 -0800
References: <20221114213701.815132-1-jacob.e.keller@intel.com>
 <Y3NaqWlpp15fYJfb@shredder>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
CC:     Jacob Keller <jacob.e.keller@intel.com>, <netdev@vger.kernel.org>,
        "Amit Cohen" <amcohen@nvidia.com>, Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH net-next] mlxsw: update adjfine to use adjust_by_scaled_ppm
Date:   Tue, 15 Nov 2022 14:56:54 +0100
In-Reply-To: <Y3NaqWlpp15fYJfb@shredder>
Message-ID: <87zgcsl3pv.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT093:EE_|DM6PR12MB4170:EE_
X-MS-Office365-Filtering-Correlation-Id: 29643335-48c9-4c4b-06b8-08dac7117552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y39eg6PAx2Ganz2pOkR/3T4WO9mUaK/8Kf2MMLBTo761x+iW9u3eaJrz8L8ib8EtVDpBieP+7K5BTrd1tGQoqPZw18e0yjDOT2mHYzqwiq1HXe/Bb7lkvp8nNYYIj24jRcO65lA4oAI6n1R89uZc4i3Py8BG8QehnfRux2uVXbSerXiMHtzocRh0iN+SmJVdJfczKrfR44aUyTlp/q/5Fk/2DGI+zA1EUxCR5uyyGex9QC9zDuUdVLgzQsPX6QiqeyYj+GVlBU+epc3Oxz91eEsBIHlppdYiDsfvH9wEO7oZSc7jZC58+DtLysK9AdksutF0z+K7JgrOLGTpIjerJ7tOjuGD+6cQc/Td4uNCyczt/c5OUp+R7GHAmkYrIEX6FUASF5eA4TP12vwLcIPpXx09P01jnyHyCcnkWwp4l8ykLlJ3lQQUYVJUeC6tz5ccS1FY7eBYrs1j5h5Z+gVWwKh965ejkmUc9WuKrQJVjObP6shO7Ih9EcCz65vLX0neuekG1GJNG4YKGzFQETRm3573Gqd5FQnriDMuF3yLANmYN2q4/dDihEuQEds5MxYVh7qY0i+XazU/ka8FN+CbZ8Qu7eON3HmstrjDYl6i2QqN6ZHTF/yaW80ts1hzUvckdawoezwDQ8i2PYWxp6TTVHwA23RcAcTFYFllfH4DUIl6aFxtHvYVr7S6U7iNkwcyb0/MiHh8n6p2nUzc+aP2oUDOEyy81Al2eKsxo1IXn97wp8eKuATYiTHBs0E3B1ObyEyliAvypPhBLWcaf7MrKg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199015)(46966006)(36840700001)(40470700004)(107886003)(6666004)(478600001)(37006003)(54906003)(6636002)(16526019)(70586007)(70206006)(4326008)(336012)(5660300002)(26005)(6862004)(4744005)(316002)(8676002)(186003)(8936002)(41300700001)(40480700001)(36756003)(2616005)(40460700003)(82310400005)(7636003)(356005)(2906002)(47076005)(426003)(36860700001)(82740400003)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 13:58:22.1465
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29643335-48c9-4c4b-06b8-08dac7117552
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4170
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Ido Schimmel <idosch@nvidia.com> writes:

> On Mon, Nov 14, 2022 at 01:37:01PM -0800, Jacob Keller wrote:
>> The mlxsw adjfine implementation in the spectrum_ptp.c file converts
>> scaled_ppm into ppb before updating a cyclecounter multiplier using the
>> standard "base * ppb / 1billion" calculation.
>> 
>> This can be re-written to use adjust_by_scaled_ppm, directly using the
>> scaled parts per million and reducing the amount of code required to
>> express this calculation.
>> 
>> We still calculate the parts per billion for passing into
>> mlxsw_sp_ptp_phc_adjfreq because this function requires the input to be in
>> parts per billion.
>> 
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> Cc: Amit Cohen <amcohen@nvidia.com>
>> Cc: Ido Schimmel <idosch@nvidia.com>
>> Cc: Petr Machata <petrm@nvidia.com>
>
> Thanks for the patch, code looks good to me.
>
> Petr, please apply this patch to our tree for testing.

Applied. Jacob, we'll let you know tomorrow whether it exploded.
