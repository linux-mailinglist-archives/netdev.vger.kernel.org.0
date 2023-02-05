Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C4968B004
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjBENkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBENkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:40:22 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2116.outbound.protection.outlook.com [40.107.93.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EB71C7F8;
        Sun,  5 Feb 2023 05:40:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iogd0DL5Ra5bwnAiwOH/8aAqbhVfuHLym/YIutcnDJEQlXOU43iHe3MiCbi5VGobxZlxRRis69RYPi60LiLvN+lYAE2SA99ShKW4qxF91Sfhu6mipbgSUrdTTHfSVrhTNHF6LzuEe2veiWHep5+32Pa9je7WG/maTmeYGkEkKl5Bkgqv1O8i6hCv0FZURq+xdboiOr9zXnBr8Xr0t66hdWUFYyUTCMse1W6eQpkfKuyZYexCEOVvlGo83VTUmM5eHfRN6BNSELoBRKXqOX6f+onvi95IzXQ0C6XcApFqfQfdYCfvb8A96+dRVEephjSQPd/T2NqW9zLted5JAGG9Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYUZ9B6D0zGHtU2FKBpYUPB6fH02M8EBs2emmbzvkiM=;
 b=XKp/krd/DSW9Km/iAKlBwYZuEXt/hGMFR9Rz9HhILrC02TU3ZHKdGntZ96x03rSExtf5gJaBejpVTDsGPPjS5PCshmAdEiDzYs9+E9thW6lcrufHnVtuSqhTv5evqwFqnF8jRF0KKh2zvIWhrcmmzIUSORBZ48vhJZSJ/1yOsZ6ePntGQjscWF3kgy5FujS77d8mYh0Ny0C7rQLwU8+f3g3p5+ossi06GM88dfM30TNoUs4qexy36/AedDz8ljLpLYJ6/i4F9TbRQu+dSEVL6CIGOWEnUwR7IG5x1lnmp2xmkXUK4Uefc9Uz4pNrDWqyVEpMGtkmk3NigLqIM8mx7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYUZ9B6D0zGHtU2FKBpYUPB6fH02M8EBs2emmbzvkiM=;
 b=XPLD1ehIBwCzH3R7Ydsw2bQz3dmT7NqpCqx1CcYtHtelqrZXDuJUaTbAzN5qOKkYC4DIVMCTdw79COsTcTtq4Ecoz1E+Ul5/7d/z3xhJ1Wz89OjR/sY7xiDF/AZd29nxCmlQkhtFpp++VCMJ3t0rWYBuI3QwZizvIomvyiD0kLM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6114.namprd13.prod.outlook.com (2603:10b6:510:2bb::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Sun, 5 Feb
 2023 13:40:09 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6064.034; Sun, 5 Feb 2023
 13:40:09 +0000
Date:   Sun, 5 Feb 2023 14:40:02 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>, pkshih@realtek.com
Subject: Re: [PATCH v2 4/4] wifi: rtw88: mac: Use existing macros in
 rtw_pwr_seq_parser()
Message-ID: <Y9+xsisUsPNam4DH@corigine.com>
References: <20230204233001.1511643-1-martin.blumenstingl@googlemail.com>
 <20230204233001.1511643-5-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230204233001.1511643-5-martin.blumenstingl@googlemail.com>
X-ClientProxiedBy: AM4PR0202CA0022.eurprd02.prod.outlook.com
 (2603:10a6:200:89::32) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6114:EE_
X-MS-Office365-Filtering-Correlation-Id: 6bba343e-1426-4c52-600f-08db077e7f73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E78cwgPx4EBfWyJhIHDD67SQXe3IENuMZGEgotDjSaBLuMPcgpQYvIeIZ3LcdwZeqYDh3JFlY2bxMzEx5PWSynY8B5SoOUGaZjkcn2iAe368uy5T2TcfXYSxFf0eApOkP8qEAuGF3LnaDCxWH9tHd8L3b9zSFlpolCpKvQgR9+x0TrlY3q/W2Vwh1p/luflQ1tWGhGSOFButOk1N/24oVnbkmVeZ6SjKQ+kMsIy2LvHIqMx2JVGFMKv5EiO8bivpBQ9awqG9Ex3fq+yJv/RE4XV/Q+cGB6UYt/PhRN3TY2+/nm3k5IqTciLcFXzAxSs5dpat2cdSV9P6Ovb+4IHbsV5Bzyk6kBK/fLmw+xaSKiIfjAfaH7oNVO3RV8vtKw8bjR0qWew402/s0wmFydCr5XNY+5OKwnNlfR9hziSKHClQYr4jpbglrNRtGJuNaZ0GeQkWxgGJ9FV2xPGN8g2SEJEilag1pZaSfzkgj5II9ZgmAkYHNzoW23DcYCt6E7NkA4jYkNCTf6+En7y7FmGQzMFwIdvxh2kFVk1vT0vGuZlhigihjJjLz7uno6BHzNi07RbZlq4WItsFcypYlaMNEyJl1jmcbLBhHl4heG6h7AY17o//sUSB35Ir8ynBqfkMp3iknzYM02t62z4+sMyPJEnEcfSR0IeS4U7n7dv2ZVZpV8L3OXTIIhBghSGRYR/Tb6xA+1bAzqD4aNIxkJ2fSuSccV/bd8PcqSt9KmnlF8k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39830400003)(376002)(366004)(136003)(346002)(451199018)(4744005)(2616005)(38100700002)(8676002)(66946007)(6916009)(44832011)(41300700001)(8936002)(66476007)(66556008)(2906002)(86362001)(4326008)(5660300002)(6506007)(6486002)(478600001)(54906003)(186003)(6666004)(316002)(36756003)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gu8JW0do/FeYlll/Gv1fdFcTZclWhXBhnVumGWktfauHaNKfXXmC0XhI8m0j?=
 =?us-ascii?Q?VZCPNKqVkjGjeyX0WPkUmXLKQWKWleiGlK79qZKzEVWzhnhWSurNRh4zM+XX?=
 =?us-ascii?Q?8qfpDfbu7Ua09Qx1vCYsCE8PBzDIKMFF8gKPVtJzF2tsHTY2N+9tZ8OGjFRl?=
 =?us-ascii?Q?WUvZOqwfpT/iVrgZSRJirS0OHGXSivipwEfWl/amg1bRpD5rXQQ9swrrl6iW?=
 =?us-ascii?Q?lnCInHPsMAy2GWqYnLQ3BfUWBtuGBOrop8JB9hPz7FHVUFljk6BHp4g6RK6o?=
 =?us-ascii?Q?r2skSyzVMY1t3bBb81x/L+zsEc0DJj097ol4M4qsj/+I7vULu13YBNjGwGEa?=
 =?us-ascii?Q?7vcCACjvQR/2+KM9eRkUn+X54rioP79LEgBti1EMOKHg66L9RwN462YoJN0d?=
 =?us-ascii?Q?lusc4cdMfUX+ybjNzxYuuck8UU4P18VeirUrnONNPdhpUPZDPR5XAd9Dukyd?=
 =?us-ascii?Q?4mIca1J93xYltG+NtVG1PH4Tkto3FnSW0yEm3rJVvnixFgtC82vhUA0nwcll?=
 =?us-ascii?Q?6zX2+pJUM2fr8SKwGnM+yQ2Q6UdGFOlfL3i5HSnVyZBgDoGYk3u18AWvYDnT?=
 =?us-ascii?Q?7mWsSK/3TeHGhcLMzOpoFs9ZF0dEZ2mqFsoFpCPms9jA7WFnSAFka/bjfJiP?=
 =?us-ascii?Q?LYluXpD5OevvoZ62OCjiDCn7BlHQQ6Mc2ntxh8626hO6tGmazTEqVhslLwjy?=
 =?us-ascii?Q?mbhREUb8EoabJd9UlP1UhQFb868d7jfzA51LBHz/npRuuYInwaAvUGkVu++V?=
 =?us-ascii?Q?pq5mq+NjBRRPQPxoTVs51DcW9gJjYBAVHAAaLFQMDIRNT8NSbDp22B1QDFut?=
 =?us-ascii?Q?ufIWwG7i5WmynwD0Cf7umS1ced/QaVf3EpriVfg41F6bfPypByxC/AWIG1jY?=
 =?us-ascii?Q?klQm81B9N9z2P3FzVFpqr6mBDkmVf3uXkUd1zBuvtRb+Ma0dYL34AhuHnW9F?=
 =?us-ascii?Q?yZn04xwXF0FeJFzP0gNZfAGJuxjKz3OCwzCENwqomyrh+d86TgzaG1exusZD?=
 =?us-ascii?Q?515FhZHKnK/2R9pQJBl+tnt+jKHtM6SW2PCKW74z2X22+tAGlojjWC3PH+OG?=
 =?us-ascii?Q?aZ3xxe9bDINQAAEpQnYiyVp+JbnQJBGnnHS1SDvBe71GfI3V1JWtRo82dzjq?=
 =?us-ascii?Q?LdJ1lKYpM3/rNf9oq7Eoq1OeCMMTmwd66faKmosoNtTkBBoarJ5dhf6vpaAH?=
 =?us-ascii?Q?cdTIm9oM9YgUGirU/v0y6cQDvKwqO12a+DdhuCerkeWNoPPMVzQxa0Zeh689?=
 =?us-ascii?Q?ownwzV/18efi9xPtDSEPWhWjJxmyh4AXWLlQG2r2RVCjFzNjo4H3bPzNKZdE?=
 =?us-ascii?Q?AEPjYrWsa3RkwbBPLL/KrvACBVy8576/sp2n6udZn3mRPb690pEdPJF8KJA7?=
 =?us-ascii?Q?Xo2FxKYzy4oJllGO1/ygrbJM0u/tR9G5lVHYA65akSG8wIRsDJnEeEjPlCBi?=
 =?us-ascii?Q?W/wIl6pnIitP07jBko+wLw10UbQnjw3ZzsSnCYYiC+8SC9/4+WJ/52BRhutR?=
 =?us-ascii?Q?e9DxJZMs3FTnmuONm0IFF1X3t6W6O8otwQJCZtxp+y6DbuAk0a9hRMB1hhDN?=
 =?us-ascii?Q?csVL4jIa9uZuT7xbfOSpLuYJAsHTXtw/TQ3I/R3+7uovfgUzZstQcl5YaDR2?=
 =?us-ascii?Q?Qm61sYcx/V2rPrYEnppPH6kuE6e4SQUDxW1bHASPa7g9BM2S/4u7lOO3soqR?=
 =?us-ascii?Q?e3iTHw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bba343e-1426-4c52-600f-08db077e7f73
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:40:09.0629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yX+6R9UlYbI6BNEyofelq/uKq1mRYyc0T0/y6Hg1FVYPrvOv89qVSGKGkkGwJTwVbLSmZ0lypaLaiaPKqsfRMk8/U+TktdaFz1MqriCni3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6114
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 05, 2023 at 12:30:01AM +0100, Martin Blumenstingl wrote:
> Replace the magic numbers for the intf_mask with their existing
> RTW_PWR_INTF_PCI_MSK and RTW_PWR_INTF_USB_MSK macros to make the code
> easier to understand.
> 
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>
