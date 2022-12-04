Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5554E641C0D
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 10:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiLDJbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 04:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiLDJbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 04:31:21 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2077.outbound.protection.outlook.com [40.107.92.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AEF12D23
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 01:31:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kTm+bVkQzKHLSEcAFzHApR1sY7yzpyumvTOmm5vgQzpiI6ifsCpBjK70OhKMPqvI9zB90WCUDiK8PZXgSG+vDVAnWL45otfqdemLLNwDYIIShOIHjZVyZA5tA0Aic3EnFxz5Nl2DwWDNdoVQYbYFfv5h194r+s09LNGNZbWkQnLie4uM2hztiCV7rN/vqtW4/E3t+yjekhOYIkl3P/szC3NCPnUUc78F3jWwf+PMYcHWTmqGC20chyZ7yvv0+daRD2qEL1OfrXa67O/RHAAO3UOrf3DaiZipIdg6/mjRvtuQAxWaEam+a/xLjk0RJ0nRp+8EPtYkrRgvEYsQ/fsOYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=saVKKSZarStD/pTdy30KIl87E3dgMYB3IBDNaP7EvIg=;
 b=gh/t5V/bBKGhCK7TTMhzlnDJcTquQsc7gGBKesbM7JYbQ54uqG96OmcctMGGf+2gqMpDW0Ca/m3kZ4TI+97taZ25SWJ4GH4tJ+cJ/hBq+0yq0dfxMCwpB6TmVmxzPDHYKoUAepTrNhbCEUPDJCscuExonizEYCHNbFg8WvmSYLynZ6EmlTw7o5zJnRqYJIbhRpjEjSiAE+Hp0SH7NWmnOIbPw1daA1FlZWfznV9/B9XRT0CDBalSYn6zMM8fxZlfA9P5fWtIPmq+CsuyCzf57Zss2o0YxI3C8G51gSe8oNb5YYQPHQmA2HUXNaXWvTOIHSUTOfTSRlVF95JEbxV9Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=saVKKSZarStD/pTdy30KIl87E3dgMYB3IBDNaP7EvIg=;
 b=QyJmIKqXY2ZxoJi9orLGcleb3SIScjX1qpnYUQwhmsX0c2n4M/4UyOt+HejSi1ZWZMrJEQ3ua2OJrMrukLnTxFFj67GwxwnMTHh2wo8aJn3iBRUhIO++ibg6LdCf8OF1tMrW3PhouDwawX9dWp/fptwSbLbuIiNaVpF7EujtnVx0Oa+YetgESzj4PPFEkuapptKSisIPoztROjKij1INIQFu3JbyT3Vj3NlONtZqYzIOzzH1AEMhEWIhYW3MncD6j2KkNTHks4XtifzOf7dK6+xJIN1W+XUuvSi3qdm53b37JCN0zqUIwiFOQVA1IB60Vw2wXzIqVsnTcRTR8sFBag==
Received: from DM6PR11CA0034.namprd11.prod.outlook.com (2603:10b6:5:190::47)
 by SJ0PR12MB8116.namprd12.prod.outlook.com (2603:10b6:a03:4ec::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Sun, 4 Dec
 2022 09:31:19 +0000
Received: from DS1PEPF0000E644.namprd02.prod.outlook.com
 (2603:10b6:5:190:cafe::5c) by DM6PR11CA0034.outlook.office365.com
 (2603:10b6:5:190::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11 via Frontend
 Transport; Sun, 4 Dec 2022 09:31:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E644.mail.protection.outlook.com (10.167.17.200) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Sun, 4 Dec 2022 09:31:18 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 01:31:08 -0800
Received: from [172.27.1.194] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 01:31:04 -0800
Message-ID: <827e1903-e95a-4bc1-426b-cab4348ffd95@nvidia.com>
Date:   Sun, 4 Dec 2022 11:31:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next V2 7/8] devlink: Expose port function commands to
 control migratable
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
References: <20221202082622.57765-1-shayd@nvidia.com>
 <20221202082622.57765-8-shayd@nvidia.com> <Y4m/M+jeF+CBqTyW@nanopsycho>
 <20221202103948.714a0db4@kernel.org>
From:   Shay Drory <shayd@nvidia.com>
In-Reply-To: <20221202103948.714a0db4@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E644:EE_|SJ0PR12MB8116:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c802fa0-7021-462f-8a7e-08dad5da4c7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G7ykJ7sgJnlFJ47gvZn9NlW6RkNMyF1UoyD6fnKTxRy4sHdOVpNBLpUlQsrV2CKgpWlMHXK+czXQ9usi2uZws+zlZkEo8Q8sA/NrKbNGfFCUI3/Q10Cfyf3FaUTpk25qbz8h8HGBVJF+X+l9yul3TDn0kYEryFt2gO2TwJ1xEyQb+XQnWuUSyq46U0DdjNVdW2gbP1khnrqzphLyoRzXFUzD/Y9EF1WTWmqcq1zEeUDPmmfwt8cd0Jqi1b9XymlMUujvYs/9q1vFO9oHN+lRSzXVqF40AE8g3P71ZsagDkIIukxdbiop312ePJ1wWsqKpDvW9VXQcIGLn47u9NhLlkDNHAuIc12w9ITfcK4VGwT2gE1kHCZVdHPgvs17Yj9SCvEkEHut1DJbGtczrgUEMsb+zwXvT7PO/k1PcPDG3ZAJoU3TJJ/mhrSZPzCSCOJAyK4VUIA6zKW8NWyALEZVI+SbBHEkeQqSdlXBY5WubVNNIaaUwpdq1lgNTzAYsXoWu9oFt+xp14v6gFqJpV6N/sBuUO/KlRfyiKvp66Pkrb7iBCANDatrMEG/1PgSMsYm8VqJ1xaVscrrG+P+pYZ/f6ENJ9KSe+u0MwXlVJTuhbLJLr3Gf2gSZiCSdptC+Pq3Md9zJpK9fcd0BE+R1ecq3XWuwRYmfezUM6JGYz0ugR11ckYrY44JW6f1ikrHvDHCvO3eSMw5iLpuSWKC0beBWYeHSSjpDYcQrC85foT/HGc=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(70206006)(16576012)(26005)(40480700001)(70586007)(316002)(54906003)(110136005)(186003)(5660300002)(86362001)(8936002)(426003)(40460700003)(2906002)(47076005)(356005)(7636003)(4744005)(41300700001)(2616005)(8676002)(31696002)(36756003)(82740400003)(16526019)(4326008)(336012)(82310400005)(6666004)(107886003)(31686004)(478600001)(53546011)(36860700001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 09:31:18.7797
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c802fa0-7021-462f-8a7e-08dad5da4c7f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E644.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8116
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 02/12/2022 20:39, Jakub Kicinski wrote:
> External email: Use caution opening links or attachments
>
>
> On Fri, 2 Dec 2022 10:02:43 +0100 Jiri Pirko wrote:
>> I believe that you put reported by only to patches that fix the reported
>> issue which exists in-tree. It does not apply to issues found on
>> a submitted patch.
> +1, I also find adding the tag for previous-revision-issues
> misleading
will drop in next version
