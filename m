Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 178B569655F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 14:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbjBNNvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 08:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbjBNNu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 08:50:57 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on20615.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8d::615])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AF52822E
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 05:50:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SwTjGG3iGwzkBacMNxfhkw4uFRhcCnUFB1b0r1x6L7ZkRPmiql/bMdJA2x8ZupfImsSdN/8v+WSCaHoGr61Jh38aW5pB6G9Z8D0aA5VoF/cJv0PYl512Ek+OWl1Dv4EglgRozIxFyPIOXJL9a8hcADVjct3A8NOKpzeHnxrrUjWKrjBbWSe2JEA3sFBlfyQu2nkpvQJs/K3B2J8So/Od91l/s6AURA0JkEmwkRi2vSOvrjDHkrHhPL4qJCYOIU/Nf/Tq3q5nN6tkQendI9/RypbHWLVE25P4eRWGZoFvBuQ0qknmCWjqm7adDwmtG5SJlNVmKMLRxkZDJGr1JHRL9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfXEL3Hfme28eD18tTLSRmYqQUyFMIOI/CWHoYRKhFc=;
 b=KStAKsgHo1UsdES9BQmZHZCSQZtS9EPDefdOjVEmxGPv3d9N29rco9T9W+dxRkpOUCVTpAkihv0QqvnNaitklZgsnzbqYk7iyCJlzttZdXHoNg+PcQwppM2gq+xR/PyHzmUSJr4Dcl704FTPnZWTIhGatqmEofgk+V6EO2UYeYCwXFUK4tI24QNoDojSM0ERib0ek02iPAPgONCBXl1YSrNgrwrAzF0ulV8LGmvvUa+rBoluUGM2YYIh4vBfbCYOyyaJTBrV4lYzjzs4ubwERikQzpagYHhTIEdKGbv198Yb4F8Mo+DSBukvWmwWFx0ePYxak4lbdUmzlFGk+YqDtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfXEL3Hfme28eD18tTLSRmYqQUyFMIOI/CWHoYRKhFc=;
 b=A2BiiDCDDBAENxi/wKt0gsx2yDvCR4/OwiXn29+dSBixtyq/TznFphMEgmZhcbst+4NIPlcuES/H+WE7SW0fWBvXdNkBXLN15eBGK+2cg9caIdFYMfcw82fCwY2QIIbBgNGEaCeY99JNl+rCXgMesonutLttPU8PWR6yEXzlEjbPGgNyygTLtx04YDSxe6BAJZZS5E7A8iVBlUfmrNYpUCBFMBL9SeNYhUPsU2tpKgdukkZ1V4DVs9OPKIy5F5dFO8jwu23V1qTA//SJjoTN8EOhJZ6B4mkyaMgiYYI8jEQMUMkARJiN45zRWGLoEQaaahHYObIL/ATySsci2LII9A==
Received: from DM6PR21CA0020.namprd21.prod.outlook.com (2603:10b6:5:174::30)
 by DM4PR12MB8497.namprd12.prod.outlook.com (2603:10b6:8:180::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 13:49:05 +0000
Received: from DS1PEPF0000E637.namprd02.prod.outlook.com
 (2603:10b6:5:174:cafe::6a) by DM6PR21CA0020.outlook.office365.com
 (2603:10b6:5:174::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.3 via Frontend
 Transport; Tue, 14 Feb 2023 13:49:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E637.mail.protection.outlook.com (10.167.17.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.8 via Frontend Transport; Tue, 14 Feb 2023 13:49:05 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:48:57 -0800
Received: from [172.27.0.240] (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 14 Feb
 2023 05:48:55 -0800
Message-ID: <afc5c0af-9c40-3b69-d0ad-1418d3714c43@nvidia.com>
Date:   Tue, 14 Feb 2023 15:48:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next 04/10] devlink: health: Don't try to add trace
 with NULL msg
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
 <1676294058-136786-5-git-send-email-moshe@nvidia.com>
 <20230213222210.4f027963@kernel.org>
From:   Moshe Shemesh <moshe@nvidia.com>
In-Reply-To: <20230213222210.4f027963@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E637:EE_|DM4PR12MB8497:EE_
X-MS-Office365-Filtering-Correlation-Id: ce4d8737-8863-43e1-3769-08db0e923d31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jeWXL1Y+QcKu43Owgic9fkwmCACwmo+Shezv+W8uhnxGWoS9mtzpIPt/g/aC6Z/S6aRklBYYmdUTR853D6IDk1tHhSfHvQ4B1qZd/iyluktNEgoGSn9dZJ0aEqeujUAdbNSwwaWOBv4il8Uewi2dJB/5yy3pAoAOWXOHT2W3R0UYIrzji6TaZLA0+CkARhPOB1QTRbeBzJr4MdNrPTZGHQl+JxSKNvblWoQFYS5MjaM78S3YsKuNXNNFE6aLGLq1MIDvhS88A7kXh6Z8RWQQkHK26q2mx07lrJsQcdop7h80Ju9MMRKkPKyayYl+wTUHcNP5gCOqegRixAXYWKyGKX172zJ3ZCqYicJAsuipvVHAUpTOF/jhiL0natv081tMSRZs+r+EH/q6bYRVYcP7QY7RNH3uzGIwzcrJ4AEdxMMAsJskHuabdrOVhjoN+PsC7xiAx1l5unUm5I3XrpeaIJRiV9Wa3X+u5g5mxaHw6oJdDFfZPZweduxakZDnx4jjPf84dnnuWkYAsfxxB3mYuNnTHCKrD9Qb3Md8urQLtq/KpbLdt5HToxdakH89li1hk4j4Ws6Ce19AUTw8+vycDKb69onyVaeToTm/TBOa5geAn6HzqIMa0wF1rPxl4gw6K38EcRs6WjEDf6k9Z0SzzNpWJ/bK/94wNuG1IhgfjrFgMvcpZSK3v/PSUXpcDOLNWSFTcPKzwr11KLQTco0uRJ+xJUkGrg1q52RN/crn7LU=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(136003)(346002)(451199018)(40470700004)(36840700001)(46966006)(186003)(16526019)(26005)(6666004)(31686004)(478600001)(336012)(70586007)(4326008)(70206006)(6916009)(2616005)(16576012)(8676002)(53546011)(54906003)(83380400001)(316002)(5660300002)(41300700001)(36860700001)(8936002)(82740400003)(2906002)(356005)(7636003)(31696002)(86362001)(36756003)(47076005)(82310400005)(426003)(40480700001)(40460700003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 13:49:05.6144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ce4d8737-8863-43e1-3769-08db0e923d31
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E637.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8497
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 14/02/2023 8:22, Jakub Kicinski wrote:
> On Mon, 13 Feb 2023 15:14:12 +0200 Moshe Shemesh wrote:
>> In case devlink_health_report() msg argument is NULL a warning is
>> triggered, but then continue and try to print a trace with NULL pointer.
>>
>> Fix it to skip trace call if msg pointer is NULL.
> The trace macros take NULLs, can you double check?

Just tested it, so basically the trace will log "(null)" instead of msg.

But in this case, msg=NULL influence also reporter_name in the trace 
which led me to another fix :

diff --git a/include/trace/events/devlink.h b/include/trace/events/devlink.h
index 24969184c534..77ff7cfc6049 100644
--- a/include/trace/events/devlink.h
+++ b/include/trace/events/devlink.h
@@ -88,7 +88,7 @@ TRACE_EVENT(devlink_health_report,
                 __string(bus_name, devlink_to_dev(devlink)->bus->name)
                 __string(dev_name, dev_name(devlink_to_dev(devlink)))
                 __string(driver_name, 
devlink_to_dev(devlink)->driver->name)
-               __string(reporter_name, msg)
+               __string(reporter_name, reporter_name)
                 __string(msg, msg)
         ),

Here too, the trace logs part of reporter name and "(null)", not really 
harmful, but wrong, as we do have the reporter_name.

I will drop this patch as I think having a log with most data 
(timestamp, device, reporter name), but "(null)" instead of msg along 
with the warning is better then no log.

I will add a patch to fix the wrong trace point struct entry for 
reporter_name.

> Same story with adding a note why this is harmless as patch 2
