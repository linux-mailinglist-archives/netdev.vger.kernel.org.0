Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57F21640F05
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbiLBUQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234878AbiLBUP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:15:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F26F464B
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 12:15:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbXza5H3vBVVj5R2cd1AEKAWg9pJRYhijjfsaq4s33bq0ykvKCKK+HEiUuepipaEpWHWRq/kmT/UR0mi8YYiGY6YLf9giNE9OK8xj7QiP0fnL5U2WyvIKVdNkLFJUmolgNpUwWWNNNI7qVApj0NRzwH05Q7B183HjNIFYgAAh722n5k0aIiDacXRPgW+j6+26P9GEMdyaTtqtmet8EgytAG1pAvPC9NakMQHdHkjYZMKuI+8H+9GUdGu2SaUZ8TGScVR+EiUyZbJs6Gq1j7yvDASecziU9uee18E/3mJIvZJX0EzcLaA9iZPG4iF5aWdAvtA8Spwq6Qv9njZaVcXKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dHMrQZD9YMJVhFmEp+5t6PS4vdz5+9d6/T5KKarazpI=;
 b=mdSSlu0dtnzbgFvmHds5EPfEfM8LpyX3B2YstQYoxr350DY00lCWzX+7flHbpFR+k1zXpuMssird3UOWUeyavzh5g/laW4JsBsLpERVoR9ukv8Z98uzB3pCyBuDjE5LzucDXWTz681euwpGH9JXqkGCmGjfoGMj2OTGUVhFh4yj/0kLFXOoxH+xkkuMJApfr+ibBvwNvpyuPw8MCH/DPvNLKDahR6zo5mfFzRiKuvIqnnJV+QqGvUjfpd1hFpmzgbdd6dqScWe6XxzB0gwz6KBAOfJngZ48ljihjYayp98SLRBcZhhEv6G3n6IDzZ2qz//TMd7I3nNexF2pak2icrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHMrQZD9YMJVhFmEp+5t6PS4vdz5+9d6/T5KKarazpI=;
 b=Iecrnn243bjDzVrQLWv0IPRMPfrH3YW7zKBrUEqEhTMNl8oxoyIm8j5OgnnHs32FV6VTLNVhO+iEPG6/Qyi1ltRgiuWSvxmXP2IJGOb1voFV0Wo8PEiYjJX9ilCG0PytvYW5C+p6W7+xbaHV0RKYc+Z308pKEk5Lb4yP/uIizmSl7z4zUH9BQhmAGidzuIXcy1JBkUTp8Ah8KKjy2jQUz9pzgJs+GNWtQidTlhLdG9pZUS+IQ89/bRM+dHJ2UUkI3wwKwxepiNvMhA2qLkR0fPFIvGM+FDfxMJvL+vyeHr57UxMUuWsC8QKFAr0WRqxMhQFS3303IE8xZEYffxAE+Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by PH7PR12MB7308.namprd12.prod.outlook.com (2603:10b6:510:20c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8; Fri, 2 Dec
 2022 20:15:52 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f051:6bd:a5b2:175]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f051:6bd:a5b2:175%5]) with mapi id 15.20.5880.008; Fri, 2 Dec 2022
 20:15:52 +0000
From:   Rahul Rameshbabu <rrameshbabu@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Aya Levin <ayal@nvidia.com>, Gal Pressman <gal@nvidia.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] ptp: Introduce .getfine callback to ptp_clock_info
Date:   Fri,  2 Dec 2022 12:15:27 -0800
Message-Id: <20221202201528.26634-1-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.36.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0153.namprd05.prod.outlook.com
 (2603:10b6:a03:339::8) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|PH7PR12MB7308:EE_
X-MS-Office365-Filtering-Correlation-Id: a5d7ee20-8df0-479c-4e4e-08dad4a202a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PtK5hyocfBoDwgm1/J/UW6RnbTOXffvu9BNoHCBRd0em467buZvFjQjC0vSNiis5TO7QxgwtgifAnsNwrjpoOOe8BgPWHReoLAk/TCuBhHGcrLNMJn837UTqi88lUlZi3XD1OltxPNqoC/YIeAtd0VzMpVWGqTEHgINjxOO+PU1AitbQakiQlETHebNkCzA8Lt/td+AbPmFCpsr2tvRms9Jqy9BV8LqpUZq6KKzd9VSFUYaVtoLlwLPzH+FKvuNlCh0EoBpTy6eoGmzVpGe8PhkMY30GDkcyQTC+BvhGo5qi4yoeqNl1piOA7XDYcYZ9UI8bwZTbSXKhiD7eNOjhPZ4a6HGTDXVgT+Ul9xy4K2Gs84rNyzVhFCj+NiPo6H6pVcMcZ82PKCfXtGZPtSCQUdBhdmPzgps1Fweu7PSk1ZJW7LFAJ2hwq+XHVx1TpVKKW4c/OLz/8gPRGEW/m/4asJymNLC5/Cbu9cybCu6Gnu1W76J7gawG80l/7IAMSb3dCvWO4gHuIms8kFL8Q1KDgh/7qQArw9Nz7gKl+Yrcgfg11OPnmP/2wSMadm2HbpTWnglvs2/vgNIJJxQteeJEIiiQGStJ6GoZpZHYBq2mLQ0sqI0mG8ga6SSDJmi2q2c1uR3pV4DrUXfwZA2OxZE66bKiH3QeAxa1BOzy2+mR9fVcPEX92/JjYOVeLJ30ExDHdmL0kyadV7Dxg2y9BBAc+0tQ1clCkEyJ1Drjyq7TiuNYNOYX1Wo2gbjU5Tx0aBndaNqdTrzm5I8ui6YTgpcn/qg5GpSvGPio+Ud5+sBRjOI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(39860400002)(136003)(376002)(366004)(451199015)(1076003)(2616005)(921005)(6636002)(6486002)(316002)(966005)(110136005)(36756003)(86362001)(5660300002)(6506007)(6666004)(38100700002)(83380400001)(186003)(6512007)(2906002)(8936002)(478600001)(66476007)(66556008)(66946007)(41300700001)(8676002)(4326008)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xArV8HtvZLA56poGy3zNYKHLj2ZAQ672Jlj3M+/8VCaDn3v8MFPOZu0IHanC?=
 =?us-ascii?Q?ha/arD0ge+6dV7PMMy3Zc8Co6F7dKa4mtAzjdHokWMpL3BPBu+/iL+4Troya?=
 =?us-ascii?Q?n0rU2xfof4gDEMy6dHmN76FzVuhU6h1swLIBKGQlxjcRpHpRrDlIvAgolCL/?=
 =?us-ascii?Q?/1+yjsV/oXxqdl1S7g3mGUZPLhXmMLCxyK+ZM6WgEqKljdrf9rsGWIcDw6qg?=
 =?us-ascii?Q?VBPNczDj3Ilhcn5fszmqtnx/uLcQZNS1GgXYyYPc4WlOsl/NJaAxa20ZiBlX?=
 =?us-ascii?Q?kgARiX881AlQqqBcbhzkcQow+8dmRUY2GcYhsHo4U2r60dGMKeQy+5vy0Nuy?=
 =?us-ascii?Q?Lh8mYpACCcrYncM18Nhpeb2rUcon8UfTGJdbU/sMn0j4RgpVuiIu5kzhelcP?=
 =?us-ascii?Q?ERp2mrlINaid5i4ml3f//psmlSKfaVx4UY9F3/vgSaPhWcYV+MhMIZYV9J7p?=
 =?us-ascii?Q?N9AFW8MG+FxGGQHYbdDRd6X9hx0CARcE3I4krZd8Q/40n0vu8f1OL7/JMBFZ?=
 =?us-ascii?Q?TVot3M0UeomiRa7iM87gJLTOz7mdtPhL2qCbY+pJ+w1eubNn83KlHx/IUp0G?=
 =?us-ascii?Q?3N46fd+1kFXhVxxUlzyyBQ3P1ctIwVBSd+mn2qCGYZyb8p1dMxfzX/uiD+oI?=
 =?us-ascii?Q?UHTgzrApFQsIJeXGa/f461nLf/C9MjgA9fR1xHB4FkMjqAZobSuQAu4zxkCT?=
 =?us-ascii?Q?rgL2PTb3OdPFFFiEHY2xtyKWblosO7VVNsKx3Q2EANSBvSkwfUnJA10dRtP7?=
 =?us-ascii?Q?+V55dDIIhA9CcuK/M0ylHzWzC3fw1spb7LdxPRjULJvxRrgZBSuoKrYV8O0i?=
 =?us-ascii?Q?ClSw/eU3WETj5omu4S13y39dK4rU4xISAt5SdomvA7jfChFAVi7+WYv1Xl6T?=
 =?us-ascii?Q?jmnDl3j61/RTCge6EL66eyWVey4N14piTXR/yU4C1ZNI7lIOMs3X+gwiARK1?=
 =?us-ascii?Q?bl9HOtZhXuRagAXH0xN5lKebLGT4XQYWuNibuebJtAPVkSzJLdttNhBbBFPs?=
 =?us-ascii?Q?MD06FQdEmO4oe/ntyl+HW+hbeQRfACsOpQpteWx8gArug2cQ+djM+A1yhq5M?=
 =?us-ascii?Q?/nZRh2fCm3b9y9axlivc2RYxvhM2dyaiuFQ5XsBbUiYW5zfwzbYNexaXDKpi?=
 =?us-ascii?Q?rT2ptavQZ5C578SX0PlrkYmiuX4yTzGsdiSSqWjNkbglc15xxTgSDRbZzRaF?=
 =?us-ascii?Q?CqxPBwWEQnYU3nGodsaLoJwF2438w8W2L70vSHK/9qOVWsCXWaZwaDzmd+S/?=
 =?us-ascii?Q?hBOXz6ln0hyZob8QigueL3iYo5pLU8YwrYp1VHDApRvom5NYQVqo9qhXB1S3?=
 =?us-ascii?Q?Dj/ROvkWKMDKUZIzr4axD5Obp3FZWRqdUNTSJDLF2d4YHyEpm+w3MhGp0MmP?=
 =?us-ascii?Q?mVScAqTBHg9Buds+5zCfr0nuIVmMIa1Rb2Gq3eVVklyp/CnQ70B083mqz6NC?=
 =?us-ascii?Q?694X+BW4uJe6jF2+JxFR1xQH9zSD8DmtIgFNQPUapR3yRpvnDlBTqtWcNvlK?=
 =?us-ascii?Q?G4E1GuLkof2RufbcejfRJMlXw0aP84/5T0ztx3YU5kSa3gfoDfHZTrHxTjvr?=
 =?us-ascii?Q?RLwnuPBx1ZEmgQihdp9Jk5paEFbnAg4xW006Kkwsipyytfgdfq9D+PwFc/rC?=
 =?us-ascii?Q?pgXn62YNfk24aO3mQ5DWlNsmDYp8p7gs48mEiwoN4ZnZF7GUvt1sV/yWkQ2T?=
 =?us-ascii?Q?Jb6OnQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d7ee20-8df0-479c-4e4e-08dad4a202a6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:15:52.2152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Li4rYavt9Cfp1Dr+pHj63uGIeY45s0QzwtoSRmXFkBzZo7mNxX/mRcZIzKhnPNVpdVp/RJRY/eX/m9lc96oIxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7308
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current state of the ptp driver provides the ability to query the frequency
of the ptp clock device by caching the frequency values used in previous
adjustments done through the ptp driver. This works great when the ptp driver is
the only means for changing the clock frequency. However, some devices support
ways to adjust the frequency outside the ptp driver stack. When this occurs, the
ptp cached value is inaccurate. Also, if the device for some reason does not
start with a frequency of zero, the initial frequency queried before the first
frequency adjustment would be inaccurate.

The changes proposed enable a callback that various drivers can implement to
provide the frequency, in units of scaled ppm, of the ptp clock. When the
callback is implemented, it will be called to provide the frequency value
instead of the cached dialed_frequency value.

There are cases in linuxptp usage where the caching of the frequency has proven
to be inadequate. One example was the case where concurrent ptp4l processes
adjust frequency, but the cached frequency values in the ptp4l processes are
stale. Permitting implementers the ability to provide the frequency would
resolve issues involving stale frequency values due to changes occurring outside
the ptp driver stack.

https://sourceforge.net/p/linuxptp/mailman/message/37720193/

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Rahul Rameshbabu (2):
  ptp: Add .getfine function to support reporting frequency offset from
    hardware
  net/mlx5: Implement ptp_clock_info .getfine function

 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 35 +++++++++++++++++++
 drivers/ptp/ptp_clock.c                       | 18 +++++++++-
 include/linux/ptp_clock_kernel.h              |  6 ++++
 3 files changed, 58 insertions(+), 1 deletion(-)

-- 
2.36.2

