Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA3224C09C6
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbiBWDAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237644AbiBWC77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:59:59 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C166C53E2B
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645585169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JF2uXJyb/XpIOFQNaV8dO0Sy7aK7kpMDU/to0BsVOEE=;
        b=XSOxx0Hqg/RgHuLduI+nN65BAaKdqRbts51mG5BvNB45B7FMix6Pl3NyKuEAQ0SLtd+vg4
        rJM4reNgv3pRGBpl22KpuoVEbROzKVtMW6oLd5DJL4FOkKzKmuL6qArm8CR3odJtFIUzT4
        1pUA+FJ12tHeYzLluk9JBsuZqaOUoAI=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-bWmD-U0eMJ68U-6toLpoRw-1; Wed, 23 Feb 2022 03:59:27 +0100
X-MC-Unique: bWmD-U0eMJ68U-6toLpoRw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXbuxslDEv+exnk1StXfuN9ToYgaw7cGJSPzAhu7l21UD/6iKFXZTLuJVNF5vxK2D1A+XWvCU6IukA1RP3VEEH5z1Ik/zRfQ2Xcoh7zXyfSshM6sFooV7TmWH5KQfQ6ljTeJRewm3to+rurkHRjS5ZWJJt36ZP8L54WXSMIf+naWvAmLuBgW9lWJpV5SAUPEQ9EqxPKhXzC/xqI9G6XVUv9TgYdug2nNz+iaWzzsX/Bs+qNCN+Vm5d5IleLLEru+H7QfRAiqQ9/FS08Wy50kZDMjkwQ4DLYHtYqwP5eE9Te5vzn/n7eWp+KgfE6noggUYBF8U8Xbvb1gP2apae3Yhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0vjQn3O3hToYfgb5WW0y4DdIFNbtM6baEZ437IMSgq8=;
 b=G/ydJ8iGyJIFWgW+YmXQHzE7v6y/fkWrUjopUD2VUK17Sk5SEpyYkY/V/BL0WF7xPMnqd0/A70LDXnwUA9Z7Mx3vm+q/Wm2FTFqe3hD4/WtZniBpuYtQDRi3LffQHdUhBcDiQRXikQvf+qFVYSwF1A3tw/fKNuy++TZPEqTeQHSn5utz5JJ5EbgxjhMc7DHh6toqGg/mxU3peUxeaRV5+neudFT0i34sUK5V0Cl9ipxLen3HAiUsc6X9fsQt1EVtZ26UWReUT03NDXatzHzbzn6os15NJc+pi7DtEVX2jK3stWGSsJx7SNt31Stg6SAqxmTXKU5ynPE2dKX6gVK96A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by DB8PR04MB6362.eurprd04.prod.outlook.com (2603:10a6:10:106::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 02:59:24 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 02:59:24 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev
Subject: [PATCH iproute2-next v2 0/3] mptcp: add the fullmesh flag setting support
Date:   Wed, 23 Feb 2022 10:59:46 +0800
Message-ID: <cover.1645584573.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK2PR02CA0204.apcprd02.prod.outlook.com
 (2603:1096:201:20::16) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98276802-c72d-4d88-9bb0-08d9f6787f11
X-MS-TrafficTypeDiagnostic: DB8PR04MB6362:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB63624F19FBD6EFDFDED7EC57F83C9@DB8PR04MB6362.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mnl7JoPNsxmncbWMPeR4BckAhNjWMIgGsweaPoKmx0IHn1rKyrpAZFgH6wZvRqIEvN7czgWSgNA+c4+raNZmP6whFYPLmGUIaH9W0WVx9a/RAHEHVGnlP6VUFHN5+PKhIvOtZ/uYX2lhPiu0groEPc99SdNkcwEms0Rc8iYnEPDNaQ/UIJwFupKKrHyrn2NaEEb7zEOsiHpxN4FgxgyhBG/PK9/UK6G05GUriklYoXo3dx7kRWNROLciEmB6WPhhhbi1+AO7xrKp4xfcACXsvGdCwlEbRvCMOLMydY0xEbANU6BrftNJeaZQN7JvFI557iKqiTemXv0oy4CznGXXg/+MbK+hjkd8yCgCK9PDw0Sjiy3AbQiNkuk+YlqEsAfeib4DWsbWC79SCSGK0002GFfU+fhvdcEH0NWjW9Qvw5LR18W3/TWkr9xHDpm8SVVBME7nhS1SNrfxGWgk2GNNp3o0Tzesm8n/sUTpeD3pmPnGx6jR0qjsfl2E/gkhP8YwvCo9aVVwpYBkJqcESNUBAxdJ5MkXPWGU1WmDf0af8ha12NK1Uh37HeS4GN27wNBte+R9Gulb9Ruw28egqsnfI0RZ1V9Ip+mPSjeGMkhsKvaBVhmy7kKabLOAXeEozD1rKWXFXVz03uWAg7Pfbpwi0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(2906002)(186003)(26005)(2616005)(36756003)(44832011)(4744005)(6512007)(6506007)(55236004)(110136005)(86362001)(8676002)(4326008)(38100700002)(316002)(5660300002)(6666004)(66946007)(6486002)(66476007)(66556008)(8936002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QhQ/h+tSObwmPVVOtpfw89NyBvR6i5lE+itS/qTh+PHh2DWi0Vl5GN68U4aG?=
 =?us-ascii?Q?RYqQI+aaaTDqsxomcEfdNE6KxqrBYPA8B+JkgADVETDVt4ndIuMb93cUm3KI?=
 =?us-ascii?Q?RkZUzQXDaul4ioysHxO4/ECDHcHuUSy8u6zIyufCg68eoifR/Kvnaj8cfI8g?=
 =?us-ascii?Q?PGvodPyO7vDsyB1iTlySRYifr1zgq5ZzkTvKxLaLKRVgEjC9IF76KVtWMBbs?=
 =?us-ascii?Q?NpMttNiEq7DfUXxZBQzOIOhCRv+LTbmvwKzqyo9yP+NN6zWb5sQWSSmZpLzN?=
 =?us-ascii?Q?OH5QT4RBkohVYGinkzFeozupWRsomZI8TGHoZPJhWJ1F9W3AUSgmlwUuwH+7?=
 =?us-ascii?Q?TjoMOVL97z5lk4btr1v6AKbky4YKqvXpdKJwW+BPlD3sYrInWUdjMCawYGn9?=
 =?us-ascii?Q?Wr0o983sTr5iY98oGabDEMxbhuPIuU2YX4OHMzgjMT83IgNtdNZxjdx/feNs?=
 =?us-ascii?Q?s0BaQFk1WgyCQ6gQvLSYRkIbpUZNcFj4rWpV7pJg2Fx/kjQZ6mNUEtGnxHjb?=
 =?us-ascii?Q?RDIVf0/1o+HZdplstOAYxXaTzaY88MbRtm/X81CS6F7L4ajjDYd0AyBtcthb?=
 =?us-ascii?Q?D9ogN2j1d8rkq0M4AoWYsHm83VmWDAONVGK3Nv/ijNWqxw/vcrp6ZeCx+x88?=
 =?us-ascii?Q?Nd44jZ9mzNK6rYjJqtLPF7EHg0dxt/vpQkx3hWr3Kg+ZTlW7tVYyPOr1gIpL?=
 =?us-ascii?Q?XQ+9ziXfqWMxwS9gC7NS5hbJnBPTA6+wpKBO5lgWQTABCLIfrEuPFmYq99Jk?=
 =?us-ascii?Q?mSsMDFe5oV6Jowie8MBvXK7RdKI8zp+vzwKTRKc++k5kmIPISLllc0xhaEjR?=
 =?us-ascii?Q?bj+MPvUXyHdFgEJ57GxfafixXefnbcI9zRJtJsCgOEoNqDuKsjuyH9hQWD6I?=
 =?us-ascii?Q?l0CNnGunlP02TzMqgf9+J2pbHlw6D10uoGzIq9DCNcdPIRlMq6lIAa6rQ7KT?=
 =?us-ascii?Q?8DL29cfbKS7R74dAaQMRQkNlTkHaPW5oi+uTQoN9a+x+YFNUiL7fGQeFtGy8?=
 =?us-ascii?Q?ZfRlm9tVcWoF+Vs6rEFlQ0hpmUM++5K36GYICtGjYDIzqlX38WjYTKm3EgJ/?=
 =?us-ascii?Q?O/orudHEbshm1usfLJuqdqZ3UKH9cKaSGFXq4trUP50VOEzWwn45Pq5gCZZq?=
 =?us-ascii?Q?O9pH/J1RwDMkutokxM+9d+Otk71OZN+70blcerZ0eh8lYYANHfWhhTe8FZqn?=
 =?us-ascii?Q?Q846XuIWBBwbpf57CdvRxKJMFF8qRv568e0l5t31aM/6b0EKFsJInEbHQ8v3?=
 =?us-ascii?Q?0EqjuSxhnA/Cu17EcrHbla7fWyFrBk2CtRoEfG0UzRdlg059qp7l0Mxp3zw8?=
 =?us-ascii?Q?PqYGhju2CWi0F/EnzAUUYIMowF9ySC/yKgPjnh7+wyRJs2yU80xfSRBa2hJZ?=
 =?us-ascii?Q?WoM2/5OgRchC1k9MjTDcopJWMQ++r1vCgRh5gQJULSXEs4Ha+dNIt0TUYO8V?=
 =?us-ascii?Q?aCcWQOGkOywC5JxJ7NrjRZAVFYuI43zH9EJlCKFTlA0zF/DHNmrOI5d7xnFP?=
 =?us-ascii?Q?TMyDMqsIhziib4570wIcb6Agty3mULXJB6EshRBVmh8X0ycSnaIe2dw5AysN?=
 =?us-ascii?Q?WWIwbF4gSbnvUkX4tcxqQdXgCE4y53jAd0/dh9B1dsTjXJOO8uP1NEP9ROmD?=
 =?us-ascii?Q?It7YsqgZ6FYDf3oJz5/sPCI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98276802-c72d-4d88-9bb0-08d9f6787f11
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 02:59:24.0660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L4y8489jjUYpAgcAYtCsuVKiqISU+WVzzfUsygXD6ZVecxHE4Yx9F+pfbv2st4mokcv3eFzUJbscWzY/ys1F+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6362
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

v2:
 - split into three patches, each one does one thing.
 - update the commit log.

base-commit: e8fd4d4b8448c1e1dfe56b260af50c191a3f4cdd

Geliang Tang (3):
  mptcp: add fullmesh check for adding address
  mptcp: add fullmesh support for setting flags
  mptcp: add port support for setting flags

 ip/ipmptcp.c        | 28 ++++++++++++++++++++--------
 man/man8/ip-mptcp.8 | 17 ++++++++++++-----
 2 files changed, 32 insertions(+), 13 deletions(-)

--=20
2.34.1

