Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955D34C50BD
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 22:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiBYVdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 16:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiBYVdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 16:33:44 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2058.outbound.protection.outlook.com [40.107.244.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275A21BD069
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 13:33:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UiiUZc1jdH3bYIyKNXc3a5tKCOsTLNA27XJUjVlw56IV80Gbm7IeXC62uDBbTSsi0578SUqiNvCTwK+jABVpkk+JRd2WwZA2WWKD0T4GLFhZRuoPjwzHFKqXp7MkvtMFg8w3WQU2wa2ym/aNJzoqkMCME4qtSXagTt0SCK3EbhIzp0sYYZ5SC+8rfoepQ/9/NiZzC8nctr4BW0FhCjv0l9K/fDTgElw/RGjnWYrdEuqGjzNP1TQ7O5Qr+yrZ/mN+ccfcn/Out7tpetyDnYvHD+pqKRLbMo0XBo7u9+EwOG2EI+dc65hBB55WmttKWWzQHHSz0vW0QAUYMbyRcxx0uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6svgpt6Htl7tmG7DhfPdkpecJdchBWHwBYqu1UeVcPM=;
 b=TpUUp+nXXNn8QWowXVe0ktCTlVRrOb9VUgrvY1ZJrgF1c+6Ncx5N26gRu+Rc8PfeRcoHRcgNOXlRYX/RhvOAWR3WOuD0XjY0rN2j+z+geFdAhRTQrVC/E5QwNBCjxwiQ4AQyBsyF9j4/aCkTjluVfr98TsJ64q5fKP4lPt98MUCt6ZQfeCNw+W25dKAmZbfKuDSErKgrp7n3pK3aSfMw0/KQGj44yfbVJGuS7YO/u0vgwC02iF4uI9l73h+xSyfCcQ6PcMSEjEKFQwknsrqvP9TxHeqoTeHLypS0vw7TzBMb/vNI8G0mtxFxHarO87FJ/7iVxV+vdruylMBKv9ruAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=nxp.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6svgpt6Htl7tmG7DhfPdkpecJdchBWHwBYqu1UeVcPM=;
 b=TkMONXzg2eLaARm3u0skk18Itu849FDtGh1kZByrJk4g6HJw5Q3XopTYrbdIyEBavwCfXgMVbsw2kSHxUEDZHyX435qt5cWhZY2DDOXwSWY/G2svegshdZBPy2FiMFvCVQV3AHM2rVwIPdXKhgt5XQmYkXf4AEUkkmIOV3sbNZq54bDW5GozhFa3JJ8jLhOPN+cRc65nqI5wLdK4FryAVqLfFUll5Fs/UyirBeRvKNi4L/aISneOdvyyR2dr9VPWMtu3c7K59n4nM7jGqTiV6/M6rrdPxq8V7WL4l1pLZdP7svcvaaE6nCK5eJ46S9uLYC7E2mRetlsVFsDLU3lKMA==
Received: from MWHPR1401CA0021.namprd14.prod.outlook.com
 (2603:10b6:301:4b::31) by MN2PR12MB3216.namprd12.prod.outlook.com
 (2603:10b6:208:102::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Fri, 25 Feb
 2022 21:33:09 +0000
Received: from CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:301:4b:cafe::2e) by MWHPR1401CA0021.outlook.office365.com
 (2603:10b6:301:4b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Fri, 25 Feb 2022 21:33:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT032.mail.protection.outlook.com (10.13.174.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Fri, 25 Feb 2022 21:33:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 25 Feb
 2022 21:33:09 +0000
Received: from yaviefel (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 25 Feb 2022
 13:33:06 -0800
References: <20220225171258.931054-1-vladimir.oltean@nxp.com>
 <20220225095154.7232777b@hermes.local>
User-agent: mu4e 1.6.6; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Petr Machata <petrm@nvidia.com>
Subject: Re: [PATCH iproute2] dcb: fix broken "show default-prio"
Date:   Fri, 25 Feb 2022 22:30:38 +0100
In-Reply-To: <20220225095154.7232777b@hermes.local>
Message-ID: <87sfs6d434.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eee3168-44f4-45aa-1111-08d9f8a66b36
X-MS-TrafficTypeDiagnostic: MN2PR12MB3216:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB321668C8211D6DA614EE2BDCD63E9@MN2PR12MB3216.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3uYZWBBIicfxVGQRVKr8npWqUshobjzMrvGRoPeG5ABk0vcpwom8SkUhgAWY9E0chTgUsI47c8jcjhY2zImeiV2jNJ0Z8T9bKoL1WkmHHsnrqrzEJ64grw+YKw+6eBYi9Q7eDo7EHdOZ7JbUqvWJpQXgES1C7zveRKAalBra4k8JEV/qL5fwR0PaDKP4bC7govNYdEPkeuIx/KgXZ4cuT65emh6Fae6PywIHnyPO1AjwtswUCve79r93lX5QLZzrdPZa1WkDUPtw3L+V5NPS4DF5j+RyB35WuXgMUH9ibUJoasbZSc5aUEB3EDsOEOheycyfpiV/ovWFuaLwWsghZ2aGkMb3UicKLGfyH6FBC5En+WvJLl/3inEumdqtgJj0AO28nY/rUCPPLCKEAkjofTclAA4QIlVBQf2NL5YFs/US+6uE8xHScKydf4pQgsyBt3Zzo/i8fmf0/M8bdderoPuQ8bU9qmAn6VabKv47NV01Q9Z+4QoFWGVKhr5NSsBU7LG9fyO0OorvYr/0VEVkrZQfOOfnfNmpqGHMosb6mhgycNYWsDWPn3VDGrRxMCsgjT8y7OUgdrOJNTMoI60ZAbJtJ7229THifUl2tGbqeo7bfsF+94RbVtCPfmTvym9trarZhFntXsTF72YIsxoSDdutbf1boZPV3hCgY6jf5gaqeWsK+CRN4W1uddbEqB17E5Nzm/FgPWyvCE1VrcFXwawZ+qE6oowz4ZbdrTZrjplJGA9eenJZ9lnnNSAzWkTV3hKmy+QEcnTzAOGp//I/lGsikIEAKRrjN1ztuY7cAyI=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(82310400004)(8936002)(81166007)(26005)(356005)(107886003)(186003)(2616005)(426003)(336012)(16526019)(966005)(6666004)(40460700003)(70206006)(6916009)(5660300002)(36756003)(70586007)(54906003)(316002)(36860700001)(83380400001)(4326008)(47076005)(8676002)(86362001)(2906002)(508600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2022 21:33:09.5507
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eee3168-44f4-45aa-1111-08d9f8a66b36
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3216
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Stephen Hemminger <stephen@networkplumber.org> writes:

> On Fri, 25 Feb 2022 19:12:58 +0200
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
>> diff --git a/dcb/dcb_app.c b/dcb/dcb_app.c
>> index 6bd64bbed0cc..c135e73acb76 100644
>> --- a/dcb/dcb_app.c
>> +++ b/dcb/dcb_app.c
>> @@ -646,6 +646,8 @@ static int dcb_cmd_app_show(struct dcb *dcb, const char *dev, int argc, char **a
>>  		if (matches(*argv, "help") == 0) {
>>  			dcb_app_help_show_flush();
>>  			goto out;
>> +		} else if (matches(*argv, "default-prio") == 0) {
>> +			dcb_app_print_default_prio(&tab);
>>  		} else if (matches(*argv, "ethtype-prio") == 0) {
>>  			dcb_app_print_ethtype_prio(&tab);
>>  		} else if (matches(*argv, "dscp-prio") == 0) {

A fix along these lines got merged recently:

    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=924f6b4a5d2b

> This is an example of why matches() sucks.
> If we add this patch, then the result of command where *argv == "d"
> will change.

To further drive this point, I made the exact same mistake in v1 of my
patch.
