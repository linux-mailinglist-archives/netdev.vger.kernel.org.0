Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED74F4C0CC5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 07:50:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbiBWGue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 01:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiBWGud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 01:50:33 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085516D96E
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 22:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645599005;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NQZU8kfBVTzTUlBU1tSeuL7dyuBijWTPXpm5KvkUvAc=;
        b=VEev7AatTw1EwYWa2TsmnMyzhnnrKl+/JDow1Qrpz1/4RSIVUCqnNRkf9bERwffGtdp3Ur
        P7WU/+1e3Kz1S8u4RO6JtNYhI9uBzUnE7O0EinOWgX++jgErt7zarbeCsKMFzgSUz0zhqN
        Y1SQiNg6lTs9lSb3dRQtMY0oxiC7BLI=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-17-QQbJ7atyPEGZTlmCtnUV6Q-1; Wed, 23 Feb 2022 07:50:04 +0100
X-MC-Unique: QQbJ7atyPEGZTlmCtnUV6Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnJ9p5Vah/P3hSxeJl0VzZxAlXN88hxhw7JWbImqnSdT84NeeJNdetoT9hqHhpjd4lrQSyPCq3jMMDCulor4Urp2o28mlSBr4GxxBxFXuBv9MXV01v1gS9+diiVfUYqMjUU5hpW3h6QggW+hUOODljM8u6b1k5Q+9FsTa/Y+1pjkxJwV6CQ5QV+yv5bpONJjYYzm7dTSeTiguR8HZ3+xnLyXjNwr9EZ5kVlC6cCRoKLRCIzDAXG7LZQBHyfHH4z67/2ofHjzIQlgPaiN5p+pPG4xk+RqQwmaJCRf63YtwV1GiDfbHshsL2LtJ98NJVI277oEZVw66+xwV2I1otO3Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7azOuiEaDsvcOh5nf6xeWLHtB66bL30pyan+xZXH5co=;
 b=KhkfnVbvt/HjNtID1sssiDD1XsKSiuFPzY4Kzi2fFiEsuOQdTKRxtHtwFMVC9fPP57vLQ8ksNU9h/4XzsCKsV5lMSmABBd1HkKvk9P8ay0cHsaBtsyW2ezyU+Nm6oPOogpR5A3cR33fWbnZnIlJr+bZAHm9b0FsVnJJiFsfLSQu8HOC81h3+YUQdaZ4cXKkvOpDm/rTfn961kxvokFCQvEKcsI+Qrul2dBLSGB8UreXAQEcmeM5h/l1WNWJxQSSOtca3VS5aLth7YF+/i9P2LKXZcxJv1mQiPZjM1aL1GlK807CF+671TiOvgXBXu4yxT/fgvJJnR/goX24hL8KkkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by HE1PR04MB3290.eurprd04.prod.outlook.com (2603:10a6:7:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 06:50:01 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 06:50:01 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev
Subject: [PATCH iproute2-next v3 0/3] mptcp: add the fullmesh flag setting support
Date:   Wed, 23 Feb 2022 14:50:36 +0800
Message-ID: <cover.1645598911.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK0PR03CA0102.apcprd03.prod.outlook.com
 (2603:1096:203:b0::18) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f84bc07c-5b4d-4c15-a2ef-08d9f698b715
X-MS-TrafficTypeDiagnostic: HE1PR04MB3290:EE_
X-Microsoft-Antispam-PRVS: <HE1PR04MB3290D15B94F583BAB157D33BF83C9@HE1PR04MB3290.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: otdcf9resIpgP7Ra/6IxyOuKndlbKpN7n5hOgcCxwFgTke63Z6hRD0zrWeCW7qnktUO6sSv/uGG4ychzTYdDRC+5E71mYTzpPtZJUdB8inOUM1GWRzeeTYFEcXnTmPQKXByQ96JK6j1/DqCla4/jilJ5EekfrtV3et13hnxKgnbLM0OJ5jXaQ/dFyS05PqZmGiaKepYkcxEyDePMoMN5l1Z3T2s/IIKDZxJPIDubcI2UB5A6IJ6d2UNjbQnxuRzfIpj6rk9SGbTpjgVIYlF8p9c0qsZHADGo0DjHzTyDL6lZKWPDViM/TwAykjQfkG73AGWPbpMQtPPWrDBjD7Q3JPVWps9OvQleGCjxsRbZkyLhxBZG31/6L/66Zj6CZwZRhldG6yUCaNRfohV8Z52eJIczKGZQcCWhPTIXtZdFlBfghVf+7RRoFUuFMmgQ+TqGb0nHTPY+FGWpzWvraCFJ297Gjy4jSGLDuYrL9eTL7lxTGWwk5YUSL7zZ8xast6zqmdUCQOYxz5ISHOU8iuYqqI1sZvFGpQR2speHb8KbDFjAfGBHP48ne+wg6vw+2OcS7BkeHY3NaIkXDzC1ytZqUVCxjcrRXEHiKby+B5IM2NiCeO/Mw9L8Ma/aCRuo6xTv1tQlJb0QSgZsL4UKjJNo4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66556008)(44832011)(4744005)(66476007)(66946007)(38100700002)(86362001)(4326008)(5660300002)(8936002)(2906002)(36756003)(6512007)(83380400001)(110136005)(186003)(26005)(2616005)(6486002)(508600001)(6506007)(55236004)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RvctvXhZfW6PN9zAK3E+UvoXi9gJCnsK+6AQAr8rpId0hC4FcS6uo5P3dEOY?=
 =?us-ascii?Q?hgDg+nR8/5hpJH0HyWGnRQjDDYp2yU8F4fpC2Us8yZko50jAhiZzkIrj/+IF?=
 =?us-ascii?Q?7R6VrE5xpakNFYIAC4ts+bwpnG0rxqQKdq7N6xv2veKGOhZlhrROC31nvnmK?=
 =?us-ascii?Q?EARSqeWIvUQRZjH6/NI085rymYor72rmvqC5ihkZLR0xYVf9fyF3VbOe5QQe?=
 =?us-ascii?Q?EIUz2FWqwsf3EN4M673w7D2v0mWFqhS4oRQVHcYFo/r1vEXwv4o/tR8SvdWP?=
 =?us-ascii?Q?WPG5Zqg3LcWoUd19bD2HXDyX4DkWKlfkVL7hBwMe88I4pO7J8q8S1a01Ed+K?=
 =?us-ascii?Q?ppqQbnKP8RQi3xugJk9x1j4Rc6v0TNVUn8mfxUc3tqnuinJoYTlsTs1Rzkpn?=
 =?us-ascii?Q?72kfSGvoIE1sO35Ids2TLwLnuuy0k3wjpUZPVP2D9dXuyaTwPAXeid6jEbNO?=
 =?us-ascii?Q?LPFs8l8tuKDKJmeCJTNIrHUNa6OaO6vq2b6Idt26nTQGEtbbNOInFRsieSR5?=
 =?us-ascii?Q?QeB5oy2uXEeV0DG0keZ/lEI3KUaAmjlUahIVhwf1FUEpwVUx1HT5iKgpkRSf?=
 =?us-ascii?Q?PsaWCWQciv5uFeMF30qEPkb3QN7lAkpYrMBrV0aZZfZgyWcUuO5Yt0cu9GRX?=
 =?us-ascii?Q?JjxCKkC5vYwZK22rFr8wYujrFN+ngnSpmGWiG6Q8Fn42915Pv9N8MUmG1lck?=
 =?us-ascii?Q?4bQ7zCDFsXZ0hQIb+SZxqFJofK2BQXZCz3pVQIlNTOpf9cmj5ctOM+zBt0Ps?=
 =?us-ascii?Q?4FU8woGQ/FBtM0LyHMnBVMyajCqmpv3sAgSOvDvS1TXeVUAp+6y8qZ8DFLIX?=
 =?us-ascii?Q?r2VV1xinU6ELqc1M7DfH84fnh6PXpQ7kHbT0WP8U2O5V0OhrpBu4kr0we/KL?=
 =?us-ascii?Q?/3ZHDgUGVhPU/ncbqJAngdoaP37clKAvphGyO4cTTF+6pysskd+PyeFKFmsd?=
 =?us-ascii?Q?kHMsGEC5M2PFxe+h9hwO8qe45BiKMMXa7otrXLGXOVK9m9T5ui8021AdHgUR?=
 =?us-ascii?Q?mBvg6aQmLMyiFbE0awQVexMkOlOKFvuYzvKlAS04iHvMuVVANxudyQarx7fu?=
 =?us-ascii?Q?FY7WzF+O1MUUYufxCqUCCkPhPuMssrP6pV/8DYpJy4OSzh3hmm9gj0gzMWcj?=
 =?us-ascii?Q?6H6oaQ4MV531LOSFwTdx1wIaoTyiVjlcmWFjBASsssskMcWE6KY/j6sfJcuz?=
 =?us-ascii?Q?QOKMziKsHNL1KwqLQZcN7if8CfJxiCACZ3EAOu3wGLeUqnZC+H1yC/0dRJM/?=
 =?us-ascii?Q?dzSB5reRZLkHqjBezwosheERsX4Gi48yrdwijreby81IJoFou3sq181gr1Mm?=
 =?us-ascii?Q?yoV8JINcfVkfrb/moU32GjuPaSfWM7FmfXzA/ZFtaHIMyQGUKSb7sWPkc73m?=
 =?us-ascii?Q?qMjsA/I1AaNkUfXjUf8UwwazsQPqQ/jnB74pC0LXeHEMFC6KhurqnBqHSSSb?=
 =?us-ascii?Q?FLn4tLWsjIqI06lAuX5RWPjDrfrmlYwArwvu2G/fYexBtE6wzCG3d9n1QPOW?=
 =?us-ascii?Q?QsSIFk+L0JvkwFPqxOhR8AcPUD3ve/YfoEW3XY6p4IbizBKMutOLaTailyru?=
 =?us-ascii?Q?TwB4zFBeFjVETuW3FwyAn70T8oI8nnJpBwL+1zAJpKgThf5xZR8qQFFtYdEq?=
 =?us-ascii?Q?gAUQsuexstuLmYXP1PhYLLo=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f84bc07c-5b4d-4c15-a2ef-08d9f698b715
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 06:50:01.7527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gyhpX1CgrBUE4az5HD86oIqFSHn44qKsrQYjRtYXtmLkuJ3cxM3kiNk79T4BTuEg+iRCjSCBnHNpoAlgxre4Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3290
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

