Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7EA689469
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbjBCJvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232802AbjBCJve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:51:34 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01olkn2057.outbound.protection.outlook.com [40.92.52.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027F479C8F
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:51:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VuFq7+D2jCO6eBa1Lnn1GfVXNqYOSYlRDmtaWAUbPm4vUdeuWpvLStPPpPYbFSVdf9hHMIsuoJt3YHBn1C2xEBP+H8F9ivIc/2V+q3/q7ouzgN1231rUAtDeGBj7f+i82ugN/OxpuN3hQ+8lvmXpeJ5/AAIM1qnFIhAsC2s4Jhn0ys2hnbko0blTf7bIvGc3+hstQ4uj/oIgiEqVt/U+YC6nMhiUq9a+7t5odm3KG2xIbwfVicklzDBfwO0gKCoSe0cbGYyqVBmQXLzprMKbdJ1LROvTedOTVR1J/S/QGZfztBrBgRGz8K/M+d5wYN9lxls5RDKrV8D4lSqb8XFt/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TIktibvj09H0PJfRnrngtBKN4QpUescl7Iqn/sv8HrY=;
 b=cNmTeeyyLxEXpFPu4J8mpVLbZzxmwoYWQopSvVnQ+JMBj43xHTOh9ajhG1IkB7WGeA4IcN/jW7l9S7M0VAT5XauzVX2GnfM3b4+3hXkHk4ZCySSDPJJMn/QTLTBM+b6gdMbqPYSdQQIsed90hBCetU/HEQ2vBZENS7b8MzgCFUQ+XiKsYgA5XkJ+pb6Npv9VjLSu8Nti9AJqlOR0CkYIbNzUyUse3FMySZD4YyJWwd6OR+H3qh6UjOF2Gyb8w9wysscFXx0U9W3GsTMtfrz9kJu92ppukuL00d7vqgVxea1/T1OpqliqAH177ocxdCB59IwLg3j7yTtLBzUI+v54WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TIktibvj09H0PJfRnrngtBKN4QpUescl7Iqn/sv8HrY=;
 b=T2VIKaEPVlZSZtrQH3wcLXFx5K40LbFvRd7KaVYOSHqJrQicX56j5BNji0P/FIbvrV9iFSkyLegQLXoU5qbyIj60TVooqTXB8DXiu3bDsnmq+zTOynETkd2QFkvss3/AJKDIXvos7eX+HGnQTNNapGsxyVLbIFRKB1NNZcgqrg2ZfhXIic0Zf3UpAwTgwEn2+Q2fFYxDz4QAcGVtCoIKE4CA/P/diS8zJVqYpbrB8Ge8Ddnnjk2FJWs2Z2VwfWpkmdJQ6r4o/OM0Z+mPdT+blqQ4dPHPI9n8MCClTR4ZAoTF1Kua+1EKTrO3cPNcyyFolirLxjldNNpud5EF2xtTVA==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYWP286MB3431.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:2ff::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.28; Fri, 3 Feb
 2023 09:51:31 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%8]) with mapi id 15.20.6064.022; Fri, 3 Feb 2023
 09:51:31 +0000
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
To:     netdev@vger.kernel.org
Cc:     Eddy Tao <taoyuan_eddy@hotmail.com>
Subject: [PATCH net-next v6 1/1] net:openvswitch:reduce cpu_used_mask memory
Date:   Fri,  3 Feb 2023 17:51:17 +0800
Message-ID: <OS3P286MB2295B86FBB3348F1C93FD1C1F5D79@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [OsgJp7/mNNO5VQjRsuWeIl7Q+lgF2dfC]
X-ClientProxiedBy: SG2PR01CA0184.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::9) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <20230203095118.276261-1-taoyuan_eddy@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYWP286MB3431:EE_
X-MS-Office365-Filtering-Correlation-Id: d8f4ae2d-80af-44fb-b2ce-08db05cc39ef
X-MS-Exchange-SLBlob-MailProps: QG/aTLqFmeg2Hzzzx9o+pqpoBBkXnrxEur4mQ8mXGwFUZMdqIJy4ygFZaQ3moZQwbWl5Cm9zHNQIYhYK7BwUS/Xdz2BPDan4uUwgxQ+Ov0dgnYt0TKJGDPZkqmKZLWQTRxsO1Mp1Ab0T/heRAmPHaR1l+n7yv7TKVZLwCSvhJUiAAPyvULUpUL6x9vALUilP6y0+MwYGDUirJFVo7qNiqMrnqM9Gs2qozgUISlREkaAPC8ftvguj+LCkIV33i1QmZj3sqngXTREAqfuKpa+9MK3fI1AyQ7F9VdOTtS+bGmcEdhT1xctL7299l1UrKIY4lW60+eUG3YWsAQG4uPY2NIKHz5qcBVT0sGGQ2FPL6ZDxKXRy+LhFNL3GuPQIDN7X9+HquYirn4OXLNF37N35YO1/mMkE4sSevWh92xYuPvkjwJMKMlEzwSD0XFkbBzT5DuMCW02oGn0mEgeQjeS7gTsGsozaC3uS6ScoE+0CdbOJdMNxMZaAI8vMVc1TwLq2dVsVt17a7RnJtXN3PgKYxzUeoGPlW0wkNtA5O98LHf2C9e8GcSVrz+NrxYJABCx4MfEIyZaHmUdoXYrk2BujsmqsB8QNR/3QH28aHH/wL0Yn4E19mHtcetBYhL+dQdqG57xEclnNEAKqh6IyyURu+5R16KrGxd1w
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmEDT7lYU6vTnSiPIAJ+QaHVSLL9xLtVOAlcFvQtimTpOVdRbYzlR/FKxSOWqI/2EkHPiv/N7AXGmwjXDwYggnTj4UnqUyp4UPSwix41+Uikrzx4wZkWnieoHWp1R4BawivP28bAufC5P91ZwnQml8/BWqnCf6219doAr+L9UVjYa5L/zQNXHq+q71iOgQF8nUjphAqImm+6MGRAVUFr4VEZj5CtPnKC9uUCUFoAH77t9vMzRYzXSzXjLejscUG4CzM3HQVc0+A5QqD5chRYpZCwr791+1onzTk7cSuswYcd+M0ytXgn8p2LpTTobCr5iRjdJldslHhaukgGVZUSaT+H3J34UrKr3hKUm1pgfme7tvyATB/bnkU+9+7Au9S7Ix6QUDbAivFD4AVTvtjesAN38pXKmpD6MMUJALpSnD4M7CX4skh6TSn5nPmI8UqwGcnFZgUpippUiCtk4HxCM4N9tWpRqFPGkwvJc7s35CcFXDVNiT7qLLvppnMgtBjftISO9w7Z+uW4koBk+xac60241Rjl+rvHdezfUoRHY5b8HWs2pir3++RO40rcqcjcFt14/Bt/zMwoWOWnh2cpuMjKvQQLGGgoY5rsjfDfeCJg7HVGoou0eoCqo0kRmwMxuua05A9+T6Yl5UkOn447Mw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?STZ5n6fehXZi1cRntAL5uOSFDPiEm5ssLCbQ7H01AbluRbQoZL8hYjLgAWNm?=
 =?us-ascii?Q?QdI/qKJHNeHgyLabTgYUqOGpwI5YiSlj4Qmfa1tBG+QHfJCFwdDIPEQ7gQcr?=
 =?us-ascii?Q?kc6C7YFvqGQa+4wenbJaAgMl9PINPmE2xMjX1qG1siYhRj7Z9f0CrUzSN0dQ?=
 =?us-ascii?Q?jbqpuhodB0vLvfO1kEfMYoUmMmT+61bNBZJMQV1Bdf/XVRRDJf3HuxMJIUEJ?=
 =?us-ascii?Q?4EAK/Rmd7fKht1uXCXKVrp31hfkQlvpvwKKZ0Q5dbUk0RAZxU6S/DRoJr9rv?=
 =?us-ascii?Q?kEXffQ0VRXZBvm5CB64k70wcqXFZQW1Hr5H4PsdYNOwoBXx4iHdl5yobEEUZ?=
 =?us-ascii?Q?PgNe7QOjazTOqos52FPEu8UEPUluFq0JNvwkEBRDT8BTEX0E0Obuft+h/PYz?=
 =?us-ascii?Q?bnDlTbpCupVSl6LusytjWijLTvMYEvkr97W7XNSPVW/0d8As04KSGMD2pRxH?=
 =?us-ascii?Q?Bsz5YXckJYfqjSIEJ8WkeC5GbBEL3QH1mPLQbi9FiloMatIslfwVmPlQbQqY?=
 =?us-ascii?Q?X5Rrs2b4tmllhOjICoUVLgNm6UGtjw0T7f4aB+NI3hpWZYZh3bV2eZ7qFueq?=
 =?us-ascii?Q?a917YEFA9SerurBVsxpSS5cnPHFwUdVWdAdCh3r4cJC3ML3qVrzD3p7A/MmG?=
 =?us-ascii?Q?yR/Un8Hb1UhAzl0nfA5ibzUrgScjOA8iwoL6ZpqEP8RLktZBlWf/prUNFJO6?=
 =?us-ascii?Q?7RM/NDN5tHaI5CP5ubvs+czDh1hTrWU/KEAEoFI7u8oG1GxEvdEUrusPGdkM?=
 =?us-ascii?Q?eoYQUhNg4XUf4y4dxg8Kwk1V28wmUHYPLSuBtTQ+RislDQxy+aFZ5QEcpSNx?=
 =?us-ascii?Q?83OjduIMcj0dMpJE/CxrngHGtTkeLJ9xJv8jygRiGFIFFCdJiTmd6q9qDr9v?=
 =?us-ascii?Q?pKlkgtGxakmKgtOv4V+R0u65ANYK8pfWP9dENxysMOoVx90h0Ojj8UcUWZCq?=
 =?us-ascii?Q?zNFKRDx4xox1o4BIxszLKLKHXSiGCMzZtXvlledBzuxp9y7ADM4Cm5L4Cwyj?=
 =?us-ascii?Q?P5Lo9WS4Le4zWZGuzkETLyzMGZtssjPBB5tZR1JkvFcecsdkUzXn7UjZI16Z?=
 =?us-ascii?Q?FfL7zDB+FC+C9dueOFDbIv6PNP4G26r/BClD6MdAALg/fafuKeihi6JKOnQN?=
 =?us-ascii?Q?aS48rY5I5jnI2yR+O8p9oTn6nZciJ1/NvdUTojUQ6sfiHerv7ZqAoUdc/ldN?=
 =?us-ascii?Q?v2ukck9QJeQxJgdZNzhPoKChtIc17K4rO+xGiy2pIxfZwd89GMfuUWWjj/+s?=
 =?us-ascii?Q?v9sQ6/QwVLDZTIKIo9PKb5K3GK21Q+SqA3NWA2kwLHf3TjTV+plhE99D+LQe?=
 =?us-ascii?Q?+dM=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: d8f4ae2d-80af-44fb-b2ce-08db05cc39ef
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 09:51:30.9829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWP286MB3431
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

change based on initial submission(v1)
1. cleanup comments
2. resolve max-line-length warning in checkpatch
3. revise commit log to use imperitive description 

Eddy Tao (1):
  net:openvswitch:reduce cpu_used_mask memory

 net/openvswitch/flow.c       | 9 ++++++---
 net/openvswitch/flow.h       | 2 +-
 net/openvswitch/flow_table.c | 8 +++++---
 3 files changed, 12 insertions(+), 7 deletions(-)

-- 
2.27.0

