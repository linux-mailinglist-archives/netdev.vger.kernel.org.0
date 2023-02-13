Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFC4693E2C
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 07:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjBMGWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 01:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjBMGWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 01:22:24 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EE126AE;
        Sun, 12 Feb 2023 22:22:23 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31D5tJdi009387;
        Sun, 12 Feb 2023 22:22:14 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3npbe1x0gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 22:22:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5Asi8aad2S1+r0/keeLPTub0Sk44VC4yD/lRRp43WHkSf5R6aK99KWZ8qZaRD4DcbhxBdu8oeIfnePS2H75PGLusNk0xyhMmmuqXrjqoreNPp+e5FpiztwzNYpumqf2VCXimSMyTbcnOR70lOtHQimRYJHb9tTMtUaJ/0j9ZaRi9hXKnWHVNt0ORQqP1/leI/NGlfN/QOk4u2JcjGHrDQSQVWJ0NNimMhU5kjeHzMSSLutzq+qiMiLkzwaoqe5srBxBV30h18AE5lFldeWVwlUYh6U7YeNIlhJYxLQP/7+FfIwEPrtDtk+qQ6OqmQolRaOR4/76bFzYQGLIAnlZCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cd0VUwz+k+LZzlKprWNSZw+Mx9ppp0yB+oanqDK2EPI=;
 b=Npj/fStBV3rtgZx3lhh6VZv1Cm3D+CRB50iRS0qpnxhWVOKMuvvXEolghoaZ5/QIGSN5oJbvoHk7pA1Dvz/9L1LDqhduo7MO0R1nuZHZGu4sjg+H9QbucDZ+NyKZ9HZIhiMnt9y73EdthZLeW7V5RZpdumDO8UKruzUY4YabkMNLZsdcpht/AEhZIIAL8pAE6xVmbkmBC9O53DpHzWqtmqEFI9P2WSPVbMXImFV5JMau5S/ZmYAlxlr3OZGeaZl9N0zdbnj9AbrYVATZuf16W+7UNkaKaOipIBeIC2wEHXGAVMcHBmuOD0YYRdQDiuxwC72QVgOiUrWiC64ckv9aHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cd0VUwz+k+LZzlKprWNSZw+Mx9ppp0yB+oanqDK2EPI=;
 b=Cm/XQtqJB5J6mzgqJ/gD83qKLrG+Qe5XvjR8F4edq5Pm0DF3QHYaoM/D+tyYwoQlbuEXEbtZt9CP2LCbVlBKLWzQZIfVIwny2z91E77KND5kcBEmHOQj1AfFvJCSvSPdeJE/55qp/99C7FJdTZT6MxqOmbu+LWoWOCsJ0QcjnvM=
Received: from CO6PR18MB4467.namprd18.prod.outlook.com (2603:10b6:5:355::12)
 by SN7PR18MB4016.namprd18.prod.outlook.com (2603:10b6:806:f6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 06:22:12 +0000
Received: from CO6PR18MB4467.namprd18.prod.outlook.com
 ([fe80::8c60:52c6:59eb:3696]) by CO6PR18MB4467.namprd18.prod.outlook.com
 ([fe80::8c60:52c6:59eb:3696%4]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 06:22:12 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "maxtram95@gmail.com" <maxtram95@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>
Subject: Re: [net-next Patch V4 0/4] octeontx2-pf: HTB offload support
Thread-Topic: [net-next Patch V4 0/4] octeontx2-pf: HTB offload support
Thread-Index: AQHZP3OCMLhOpRtKPUaeYRHHBQed/g==
Date:   Mon, 13 Feb 2023 06:22:12 +0000
Message-ID: <CO6PR18MB446772A3AA4FAC152919CD56DEDD9@CO6PR18MB4467.namprd18.prod.outlook.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
 <20230210163602.08d1ce5f@kernel.org>
In-Reply-To: <20230210163602.08d1ce5f@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctYmVjMGFjNWUtYWI2Ni0xMWVkLWI2ZDQtZDQzYjA0?=
 =?us-ascii?Q?N2UyYmEwXGFtZS10ZXN0XGJlYzBhYzYwLWFiNjYtMTFlZC1iNmQ0LWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmJhMGJvZHkudHh0IiBzej0iMTAzNiIgdD0iMTMzMjA3NDI5MzAzODk1?=
 =?us-ascii?Q?OTQ4IiBoPSJwaWdtNlZHak1KTFRDWjlJa0VsRFhXdHUxY0U9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUNN?=
 =?us-ascii?Q?QnhxQmN6L1pBU3dZKytoTE40c2tMQmo3NkVzM2l5UU5BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTFGSDNhQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFI?=
 =?us-ascii?Q?UUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJ?=
 =?us-ascii?Q?QVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR18MB4467:EE_|SN7PR18MB4016:EE_
x-ms-office365-filtering-correlation-id: 7a1f000b-5358-4da0-e8ad-08db0d8aa4b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DQMYT3kms0AzJacJ4CBV+5MtKC+7bn4/gI5zvja/wPtaJPL7R0Y9hE4NYeJxBBsVQjlcA7l7iuPhdhBycsSfdJJfYvLWudAGbri5Q0PCeDBAwfPo1KqVS6WQgh2f7JUhd+5Rw5MF6PdUW1SkKRPxgs9frnuYTHvNX7ZWpSKntWJq+F3EYARVIKIEouvXICAehtur6tLvG4iB6LluU+ZcVOasT2QXGMaGyNhQiragptzeDYvZa6Y5M8Ozlr8bNp/jJLGaCres983FhaLAbvWzt9HgprUfiaIxP1LWEOKZqeZbOq5FH4DtpUdOY9VDYsqpBvKCF66t31h+NqCW+VaASVdof7LPob1NOOaIan4LiSPy4ZJpDqdW0X1TeU4wWzhIeJPWxNNYBwHwHSRnwxCNZh+JTINLQW7/Atd8Mx1hvukwo6U50ZbnhGG9AntpWahMcci+wK1tfbiYPsaPoesGDrSstwh7/lpny2dyptOm1h+8+IgwApfLNjwpavSS1No29DwlWEt5LMW08Fyo3eGAbSh+Lh2naOQ9DvNpNP8x8CRrdCAlOCQUJRtLTyuImQCCVyxTuMnXkCbAgg+k5tgD3hGzTo5VJBGeozT0I4ChHBex6FmV0EHVNqKpNf7/VaC3kVdOeibtiI9QJ99EHwP1Amz/sBJ7ZQI6rYYaaWn4q2TfXRVX0n2zJG5ffIk1t2wtt/IBPl9EWj5ZCDgOnfSeSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4467.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199018)(41300700001)(54906003)(316002)(4326008)(52536014)(64756008)(66476007)(76116006)(8676002)(6916009)(66946007)(66556008)(66446008)(38070700005)(38100700002)(33656002)(55016003)(86362001)(122000001)(7696005)(71200400001)(186003)(26005)(6506007)(9686003)(2906002)(5660300002)(4744005)(8936002)(7416002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mw1MftmA5iAMBCoFUQCX+hx+yfpolB0bAOd2dTOwpOqyxiQo59j+uzJa+uBi?=
 =?us-ascii?Q?eto8vSyw1s9aDL4Z9F2VE0w1RA/PJfo0K+8zUIsJD3WuGszh5xkpQMZehv3y?=
 =?us-ascii?Q?2RPO2gx7p6WHYCERo3ryTC+ef1lcYXKjAs/BfCsNagTX5K8rulnhjXXfmKWS?=
 =?us-ascii?Q?ooo0m0m2+stQY3Lt4t9IVZ0JRq6GDmoiYXQhFs22PFMECaQIC/zLwqQ4Gx9U?=
 =?us-ascii?Q?sHlOyNdweRMEw1huImpEe5T5N6AfuqpdcXSfeIyE9q7qGSN9tu9k6SztHlqH?=
 =?us-ascii?Q?jnhxq+CHtEVsu1Jtsh3lgjsdS9WJ/XoC6DIowaxCh2rgoVPDlVUSN/RbCoPl?=
 =?us-ascii?Q?CBltbqyPYlKi9bENNaSgEr8ErpPjj0hRg6nYpp4vBay2y3pu/Wqsg6cihYBZ?=
 =?us-ascii?Q?K9mpKBsTxwG6Iu9V7EKgrVSl2eaO6J/DOKQLgdi+GVIMAxhxaIfH/7v2H9bk?=
 =?us-ascii?Q?IT8P4MkEUAhi0aKPT7PDARPfmJaXXiKYzU8vqOnCfzwAKFdixsVQ1QFpD+GU?=
 =?us-ascii?Q?DJys1qKklGsXu1lVFdKmJJcxYuM7gc/5437zv2msFBREtF3yIX/6wHGYPF9I?=
 =?us-ascii?Q?GRWEf1DsU0BmrnYNTeP+0oEh6hufCXmQCkKgFZ7pj92JVsHjMu+qz/REUJDX?=
 =?us-ascii?Q?CGdT6J8wbOjKfVpFWiJrNSXUJqe6lVWFVtFyKywjkKnpA0JoaftHltMnPTWZ?=
 =?us-ascii?Q?TBojRqcC8ednY05hYYbcrdrCDNp18EYRb+yPKBWAuaFNQ8m4VbqayKt/z1WW?=
 =?us-ascii?Q?uLAT+k7I9yczJhGk3n+jVsyOyJSqgD2GFZNdyK06+ACddTytsNz5gzbqf2yW?=
 =?us-ascii?Q?ZftrGAua3937mTqJ8tw4YLsAXaxtYATVmsjflZ2cRjeQKOaxrzxF6nZj2CTN?=
 =?us-ascii?Q?1vPwDAKQoonT1USv3K2acE920Kcd17zLIwGzutXQruZEKQPJEL+qf/q/b4wj?=
 =?us-ascii?Q?864l4zBTjiDEGpx5nFHvK8UEJla5rp2JabTx3mTM8g1jDh0X2kU1oicGfnTV?=
 =?us-ascii?Q?MdSHW+w7ghA/2SyZVEsvGic0T49yW6gzX/NQA1dwtr3rjr2dv3Y0hxUXShl+?=
 =?us-ascii?Q?tR2RM20XgCkOaPiLgwFHa00UV2eQHy96UUYOIjBHlIDF7nEnvOOP2A7ZWwRe?=
 =?us-ascii?Q?LBKPlfp7nRcruRGKcyZrITHVtSHPriAvLGd3kx+U8IjfJ/4zP3XZHRCQuSxW?=
 =?us-ascii?Q?aSV9K7qI1IDExb69az5anefMGvaFCYsh7TA6nGIWc2zRATCvbjhV1v6T7MdZ?=
 =?us-ascii?Q?F5+3bobB/KOLzxltr3/sKnCcXp5pAKqvmwENX73NOMK56AgSv/OBBqndD1nz?=
 =?us-ascii?Q?ZcNYFhbyIIw+Y89Iuej98n+H64iBqFBHbgO+o2L18j5NB0Q4Zfikajdh9dJ4?=
 =?us-ascii?Q?/bCto6UTCfaDCqF+Mpu07BJCC7b+Zu2rtw2mt9IiO1UinpqCB9vFGRMTMg28?=
 =?us-ascii?Q?1aUm2ydU7Ij1q4SwgX3VHL56kg3NC+kP//WlDusvFhbNERgNNn8vDQhJp8Jg?=
 =?us-ascii?Q?wPWqRY/2dBbQemmaqH4TIOILlTmuiF1M26e/BLwP7PI8vLELCXAvWQ+3xta4?=
 =?us-ascii?Q?hHpxXH4zhwnxrEzuJCYjSg1Ucnnop3L6cQeuYzTi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4467.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a1f000b-5358-4da0-e8ad-08db0d8aa4b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 06:22:12.2334
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TGzqWsAeoLW+c7MYmUoogWTxeBEvoiOLp1SVq8R6ZM1QD5PQbgACW+1vTjjDJupacdukr4tqnHZOlJ0crV5mvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR18MB4016
X-Proofpoint-GUID: zLJ3HVQseILcGaD0Dy2FJm4-I2_oYSX9
X-Proofpoint-ORIG-GUID: zLJ3HVQseILcGaD0Dy2FJm4-I2_oYSX9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-13_02,2023-02-09_03,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Fri, 10 Feb 2023 16:40:47 +0530 Hariprasad Kelam wrote:
> > octeontx2 silicon and CN10K transmit interface consists of five
> > transmit levels starting from MDQ, TL4 to TL1. Once packets are
> > submitted to MDQ, hardware picks all active MDQs using strict
> > priority, and MDQs having the same priority level are chosen using
> > round robin. Each packet will traverse MDQ, TL4 to TL1 levels.
> > Each level contains an array of queues to support scheduling and
> > shaping.
> >
> > As HTB supports classful queuing mechanism by supporting rate and ceil
> > and allow the user to control the absolute bandwidth to particular
> > classes of traffic the same can be achieved by configuring shapers and
> > schedulers on different transmit levels.
>=20
> Please provide or link to some user-facing documentation under
> Documentation/networking/device_drivers/ethernet/marvell/octeon...

ACK, will add in next version.
