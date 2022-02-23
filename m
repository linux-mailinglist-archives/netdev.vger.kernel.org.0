Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186F74C0CBF
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 07:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiBWGrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 01:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbiBWGrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 01:47:08 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7244A3120E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 22:46:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645598798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NQZU8kfBVTzTUlBU1tSeuL7dyuBijWTPXpm5KvkUvAc=;
        b=CUSglJKLZfZx1rfK2wo3QSPmMDeormAjVszRrBQ+wDiMKn9q+NswfzC2bYr6PtinU5IQwj
        Y7bzgvMlAeUQhbVF/IY2fSE+tpUzVff6xSkYmaXao8hDtXdudzjAJMI2k11tqYgy6oKpYr
        hU9o9GhQuL+TIT2F/5hBYSVnoKUJJ/A=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2050.outbound.protection.outlook.com [104.47.2.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-2-7xc6fIHUM_uyL0RhSbW3UQ-1; Wed, 23 Feb 2022 07:46:37 +0100
X-MC-Unique: 7xc6fIHUM_uyL0RhSbW3UQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDmYhxUJdl100Y78SplUMEDHgvlbDdIOgdvinohDSF1RHkccfrZ4mUQLPtpYmUILreidp5b50/2bVVhZbBDWjQLLhMBnpOnGkGNEZH/mz+J6RAmNGxzrsh11IAL07mQQjU9eYnXj0etU9KBL+dcYNIjjPGdnwmFnGPY6MYS8P+1S2D5IRCK8OI7PonKXzWLViaedJJ58FXl6S3p27R1fF1rrh345dauwusj5p12Y6cUHqtCUOO3AQDqY493f/avqCtnXSiYKvf6vkje6rTEYb+oakwxLYLcwvQLZPgSx3narcsp8seRuw4+2NAf4HbtFEXLrMuuUd/4iTUd5CgDOkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7azOuiEaDsvcOh5nf6xeWLHtB66bL30pyan+xZXH5co=;
 b=hRGyTquHj9c1rJ/s/Ms9AXJ8nZWM4OTFuPiwhcQ7ZBALCTNNiRLgV2qlGfFUCVk1epOPeQGGaFwe8KrC5SvDh3wWOwgmNO8wPOaYG7Nlp5meOLGbLNVqsoJbih/A5fW0mqdUh9eQgnkVwWN4DgmdDN5CEFi8RVOJjmPW5XdJ634GMH2C70dvVrDEQtN5jVxXnfNf1G97DLWI5BclzdQgJDNlpO/GHxMlVO+HtBzFf1O5n+ZoBOHgnmRhPOw9IOVbj2sLY5X0mkkGH7Rfj/XW30Hd78ZvRoc4a8u9bQRYXlXM4V44a6B6Dyq+nIfDE26kE3RLGyIufUUDU8G4SghLlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by DU2PR04MB8808.eurprd04.prod.outlook.com (2603:10a6:10:2e3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 06:46:34 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 06:46:34 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev
Subject: [PATCH mptcp-next v3 0/3] mptcp: add the fullmesh flag setting support
Date:   Wed, 23 Feb 2022 14:47:05 +0800
Message-ID: <cover.1645598438.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0302CA0008.apcprd03.prod.outlook.com
 (2603:1096:202::18) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d78953c9-9f2f-4421-9383-08d9f6983b6c
X-MS-TrafficTypeDiagnostic: DU2PR04MB8808:EE_
X-Microsoft-Antispam-PRVS: <DU2PR04MB8808AFACB320505C2028473AF83C9@DU2PR04MB8808.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CzFf6B4cIa4ZckMUp8UHLQeBGlIvG3kX4A5LsOi4E7lsu3WSk6e53fOeAwfLvRrbFM0V1udJnDfWPPYhd0q0BCGtKeoXr2SXE8SHP3aykyFV9EOZV1dmo+jjRZ/+RPMQzYBbnc3SRmCsyonegn4X2/ChfeyE/umi30g88ENUza6f5mQYaKTZTAJ3AumlZcY0Fox8ERYr8ETcQA8bPjRBuLvO0weZ3yWgXibblWTyg9aquXv7pKj/WaUwwMUhliA+cG2Z6oDCbqU62O+RVedhgueJBB9ZhTsaqX5bH5hdkR+2xKBDE1BuOKger6dwZmCC1UOt2A/hG+E1lf+XA+mL8E0+xsyx5K4AM4QtTtUgcon4v5wkRVVU/7/AgSaNf1L7t36E9FAA1woftETnGT3KJrLsnPK5Dqwr3HTbSDBQoM6PpUVmtUjQr8H7jSYDjNEdE5hmgQm3zcK6V2cnvsBo5ncITQq1d6SAlQJppE5Ds+Pjrl81jjj5cNACNtaEJ9/KGU3kPqT/uq0J1c3DWD12OpZA8G6QjB942TzKA/BfQISRC2WG8AfiogjgasIkXNpFOsXkVFz2Elv4forbbsAwoz0C4l0UtYehskc3jMmoZ216gYbP8wXV3RMsSy1C+iLIk2iVZhdaM+nLyGvZz5jB0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(83380400001)(44832011)(5660300002)(4744005)(6506007)(110136005)(55236004)(508600001)(6512007)(6666004)(6486002)(36756003)(66556008)(66946007)(4326008)(8676002)(316002)(2616005)(26005)(186003)(66476007)(38100700002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LQGVlWgSbIKk9aYqOUorIxkV8F8K+kHfbmHvHwwB1UyxjufwR8QpzqRAB7zj?=
 =?us-ascii?Q?9SLHAI5SK5STLIHLdQsg6B5TgqEEyTmOo3q8FTn/2cg52jyao1o8CM5XIcn1?=
 =?us-ascii?Q?A7Jl3+dT8KtM9HlgUAQ+qu9MgJZ4VfV/4RBTXRZ8dAR1iUm1K6UwGW5LmwNn?=
 =?us-ascii?Q?8aPBdL4zfS3zrHBjC+Srl4YjAxwVmozM11lQPhZA9N9tXcDBiPn0tyDqW9gq?=
 =?us-ascii?Q?hut2G7naB+kdDoJUbaQpSkTMYS/1M0lOQ4y9+OCkaRGXQIcnabqIcueUIGGE?=
 =?us-ascii?Q?RKPePpOo5z2vmOr4uamTg+56uCeOm2gfRWnutSwPMPP4gr4Ha5HP5U3pbl/Q?=
 =?us-ascii?Q?ypfqfBJH/giAJ/9gQXTU9LSjIavLbNyPd1vq1p5SDBtebgC8x7zAHlJ+QY24?=
 =?us-ascii?Q?eXx6bLgHZ+48Npp8Ga5xEmoVeyeYqyHr8MtZ1/21fzsuI6wy1UduSycx6PHe?=
 =?us-ascii?Q?mrwX0Qm7ggjEOi7OpqljPZ7LSmgOvWpMbfYzJlbizQqzQjZgCa01PE7PigQq?=
 =?us-ascii?Q?Ed9aLjew1KbfeYcTmW2OmQsgqS/NUYaWGOu2Si6UnmBC5UXQXwxYCDsuxWML?=
 =?us-ascii?Q?d2ISEM0HCCnohaT6E2nX+rZRlCGwsoFX3VrIT9XjLcgCH2RXDsqCzjfpIDWN?=
 =?us-ascii?Q?iyy/z8h/1FHB/Z9sHuWBg8UD9QZuHCFt1FOPVUNjTSfxfvDZHkzshVkB+DbR?=
 =?us-ascii?Q?d1vU7wPFPZCXKoNSzeEQHZa15y9gZB5Tj4pYQDqAsnnXK9i4jS4nbwByoi6a?=
 =?us-ascii?Q?areLUWjR0FVwUNx1Fra3+9VlXWYf3dXXdB8Zfw15vLW5yJB3hnTD44ajMZwF?=
 =?us-ascii?Q?1SkWEggBNbHwrhnz2F9gkfBGAb+hRouMj1Lxp0IoxI7iWzWJTnh0KhwRAUVL?=
 =?us-ascii?Q?0J1x4oUZESPc4sBvFFRubAibOHGVIfoiEbI6RGBxZ3w08CyMQ7auEzA75D3A?=
 =?us-ascii?Q?vjvUnnBEHX6as4wpbAFCo2zThTzMD/2aOlrdnR9A32VPQBsX23v+VlURnb7X?=
 =?us-ascii?Q?QrO0YWSFAZIMgTBTxALDnnJROF+/KmK3MNTglTwtnkZRC+/6KU4iTyI2cWg5?=
 =?us-ascii?Q?MVlEKiXf2YE0GC3o/Vj+kZNHpp0GEY6Tyej34Odrx51iCBg7xLBRuXqlD0UL?=
 =?us-ascii?Q?mwHdKyRuIzU3XP2kPdf0itzPal+ppDZ7KQfPmokHVhDwkBBWSkKWxG+IyZNC?=
 =?us-ascii?Q?lZAlL97QcZm7aaCVl570S5WZMxPvSie9JQ0CJeVQ7lLvM87F4FxSHlGWAt/4?=
 =?us-ascii?Q?ARhSByxJldWitEXUn3GF+gWAMn7OFA//agzwnCEbOS+PMLEVDmfyekD2jPVP?=
 =?us-ascii?Q?oPH+nxZPkWoR7cNZ4AvQ5el1ZV5qKpDPKd0wCXHEGLEcsDRSnNYGeLsWFbZW?=
 =?us-ascii?Q?KDCzWk4sCFLGhf7hO93ECtNtXkCaDBchvz3zNbT6yEW0OMRQ2Lfmqain15fh?=
 =?us-ascii?Q?UFLXoc+JXt27hDrTaZSgfZi+ec3YaDZrShPgFh3PiIdm1P3HLFu20d2QtMLf?=
 =?us-ascii?Q?M/w6b6VOOTRtxkxloqkRUHPFEagFdvlth1v8A+H3PmRVv9L7e6gKXUEI4Mvj?=
 =?us-ascii?Q?OF7ibJcahPZQIlpo4q5Y2xzryLHsVzxuToYSDUsSMs0x9euhi/fqycoLsihd?=
 =?us-ascii?Q?QmmTuCB4v2EyFtjB1frDBGo=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d78953c9-9f2f-4421-9383-08d9f6983b6c
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 06:46:34.4256
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WzLEPP7nD5B2HBTgXZoCq2L2OYZq4ybCFv0PDRfkeeE3z1r2igHAEP7WyXnT28PsLiAr9ZioUIj4k2J/rTjmMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8808
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset added the fullmesh flags setting, the related flags checks
and updated the usage.

base-commit: e8fd4d4b8448c1e1dfe56b260af50c191a3f4cdd

v3:
 - drop duplicate newlines for invarg.
 - give more explanation to the user for invarg.

v2:
 - split into three patches, each one does one thing.
 - update the commit log.

Geliang Tang (3):
  mptcp: add fullmesh check for adding address
  mptcp: add fullmesh support for setting flags
  mptcp: add port support for setting flags

 ip/ipmptcp.c        | 30 +++++++++++++++++++++---------
 man/man8/ip-mptcp.8 | 17 ++++++++++++-----
 2 files changed, 33 insertions(+), 14 deletions(-)

--=20
2.34.1

