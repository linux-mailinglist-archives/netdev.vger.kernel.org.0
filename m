Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB62693871
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 17:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjBLQV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 11:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjBLQV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 11:21:27 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23846E95;
        Sun, 12 Feb 2023 08:21:26 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31CFuCvM002147;
        Sun, 12 Feb 2023 08:21:15 -0800
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3np98ujadh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 08:21:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyFBiU7Oc3rPRnnxlosn8N9X7iST/1MLUjHW+FOAF3RMyPZHEB4oEL2o3o93cjSkF61TR5ecLVoCM5VNUCJUcRqqmppQODFWYSAy1I71MvVQuuo8jY5X43tL9B2ZZfCEm7EiXPrFK4zGNyGx4ZY14860NQBf01gE2Rgg17pG3eECRDWNiTGFvKd5dcm7PDHy0QQHLhyV8izkLmO1VnW78TgqjUvF2qPTbTeeAw471aEYwaJ6FPMKnf6nVKZs26xTat3v9DgvVt30yJlzmVqXRgziCdzNQOdansSQ6ADZrCULp1DRvGXo1rdkWUIAbR0FxMiDicQIMREjr5YvVedgsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9lUEIApv8NLli5loieOAzPZ7H+2S77yKQOXCx0d9oI=;
 b=fJzpP5FmSrg6vVeZt3q+yPBufYG3b5lD1vN8IEWukR2AFCTfsQErQRJ4Zkexlt2s82h5PizQuIf6840W99V7sFSgImfoMGPYsPItGeSQZDyDEz7Bq8GUVIzCYLgIeXguRhfh5lGy7DLCkSxbyD90GUTvbcthHr4EfO6kEu+gjOHe4gEL8gkMra05Ln5GPI8a8mgkKgLYuJigjksRwQyC7ec1j5LAnw0uV/CDIZ6x9vzzglPSszOYiOW5kM0QbssWX0w+l7EAYWL9PXpWqz49qOdGOStzMrthf1GfEj5AOyMfVoGC0UzBxjdMOmC9K7PWfG5MsnTPabXnUIRmJX7e0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9lUEIApv8NLli5loieOAzPZ7H+2S77yKQOXCx0d9oI=;
 b=GIivKln6nEj77TGbR+gtFcQeNVNbLbvNf7aChc4F5NGtfjFrE1Y8XzJToWPyNuHx82zXvpGpbUN29BXRQrC2wDlkol53ZUal0DKy5H29N5UxUue3UOjjs7iiBoeacbdUQv3m3kHDlKva30xYaKm8FNsudQbe5LEiJ943NwRt9T4=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by DS0PR18MB5477.namprd18.prod.outlook.com (2603:10b6:8:162::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Sun, 12 Feb
 2023 16:21:12 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e%2]) with mapi id 15.20.6086.023; Sun, 12 Feb 2023
 16:21:12 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
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
Subject: Re: [net-next Patch V4 3/4] octeontx2-pf: Refactor schedular queue
 alloc/free calls
Thread-Topic: [net-next Patch V4 3/4] octeontx2-pf: Refactor schedular queue
 alloc/free calls
Thread-Index: AQHZPv4FNS+AGWAAjECq6I+pSwUS4Q==
Date:   Sun, 12 Feb 2023 16:21:12 +0000
Message-ID: <PH0PR18MB447442487D0968D52D3030ACDEDC9@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
 <20230210111051.13654-4-hkelam@marvell.com> <Y+Zdi48x+g/Ypre+@corigine.com>
In-Reply-To: <Y+Zdi48x+g/Ypre+@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctNDI1MTJkZjAtYWFmMS0xMWVkLWI2ZDQtZDQzYjA0?=
 =?us-ascii?Q?N2UyYmEwXGFtZS10ZXN0XDQyNTEyZGYyLWFhZjEtMTFlZC1iNmQ0LWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmJhMGJvZHkudHh0IiBzej0iMjk4NCIgdD0iMTMzMjA2OTI0NzA1MDc3?=
 =?us-ascii?Q?OTA1IiBoPSJvL2R0QXRod1FFYmcvd0REWDVFRVp6UWhsNzg9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUNS?=
 =?us-ascii?Q?R3FzRS9qN1pBZTRQdWxXMDBrVEk3Zys2VmJUU1JNZ05BQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUF3QUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
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
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|DS0PR18MB5477:EE_
x-ms-office365-filtering-correlation-id: e5a243fc-ab4d-419b-a56c-08db0d152852
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JgJG5o8rTO3sAk8RDzDSZ8r8eFsrKSQWSOYquCHZ+sFboxW5OcuJvSam1N8CrO9GTXjybiPv/k0fpKzttLPN3bpT4JKxXj6Ur5EbLSmxrQq2m4iE1+orrp8et6LHuK34M4S0JwsY0yDWJjGhuQGUb8eMgikOlfbGJwWUjVoN6A5zw9E8jWBtcajVn8C8mwwncvjjg6vxRQb00xisks0M3zOMoHgK4iW2j59KLvC2EUtBtHtET2xxz0INr09h76s+vWf+osFVAOmqFmnqn2K15lQoVjZ8EKGgVjZL7sGAbuP9s5PiOwP4AIVzyJxpSeCy6q3eghshENHUNyWFz9bWd3D/E+4AkZGrz0fojO0jhlsdG4Kg4b/Wl1oA89TVhcS6NMMOpfzHtv17n8VFUPxGm6/HT43QD8Fs6i2GU/cyaWP3N6x5ds851NiHVY8oNS0G3nI2hvATK96mIGUcajlWs/Hiqbvmk8NUvYV0k48U3QVfDd6O550T/QBg1mRkH3pae8tKnKyiAfot6vGHqEo6FZUtQ5PB40+oNduEM1bybCPsrirzRwcah/6dFSOinCBSskiJu7jJAL23hD8AkaCmg6mq4S2ac03P5UKTyWM9J5fhUBQlmnBH1hOUqDrOKgtyfgpT+h09wl6NVk8wWy2iif8tL+acLrs/l2Vsrdz92/EOAZVJgJB4vTgEqCUvn8RjgRINkrVXA19ti4DjYK3n5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(366004)(39850400004)(451199018)(5660300002)(316002)(54906003)(52536014)(66556008)(8676002)(66476007)(8936002)(4326008)(6916009)(66946007)(76116006)(7416002)(66446008)(64756008)(71200400001)(41300700001)(2906002)(7696005)(478600001)(186003)(6506007)(9686003)(26005)(33656002)(55016003)(83380400001)(86362001)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Alr3r1IZaPyb0YCuYcv7RbQzDkF5G7C6E1ke7WCqKJIbxidv7BEUew0H9bIh?=
 =?us-ascii?Q?MdE8OUKeo+LL75MBuNmCoRqfn5EOvQVbqiHsp5PDuNgPnVb9MX8d3gNzayTf?=
 =?us-ascii?Q?mWY8Ko5g2xV2zSJUcxe3c8ByI9/X3La/a8zN21vFzs4Ahm9LZTnLOegPzOrU?=
 =?us-ascii?Q?cpnOKsG6ANqSSBfg1HhMl97NOXOWLm8nV8Xlme/FVJ8Iks0SmLjfduxopmmQ?=
 =?us-ascii?Q?mL08tJQlaSfllGDgeQDJYnNXjPbAJYu0/bPx+o3VRgBzy4QbjIxPs18ifVN3?=
 =?us-ascii?Q?IFDcDBV6CXHPnbWkRxFWmG17EepywkvCAcJkD+2P90mFjc2vynac0g9GlZOC?=
 =?us-ascii?Q?d+oMiY8I4bhxjPO5yiACPrilBY5ir+LpbUsaBKA4f1sPPNItPfNzFGOmN3Nc?=
 =?us-ascii?Q?BqGsIap7RBqWAGeyaDv8Ch7CwurWMeA+GYLoO8HvJK8rwt06/tvdXSGdDEsi?=
 =?us-ascii?Q?7G6lMIL76Q8EfNSISN1FJ6UfJ4ElaBtVe4QTix2Wm7/3noBxugDX8vznV+nM?=
 =?us-ascii?Q?tNgYK2nZaiU7h1s4n4L4X+1Uke5UJO5MrJSzh8leG1vLTS9Buu6J6iLKwaoB?=
 =?us-ascii?Q?0Q22BXl5dUqLlo8kG00ye0xi+2fuKSwQsYA9xjLfw5UiPp9RwXEm2x6Vsgx3?=
 =?us-ascii?Q?7vfgUYqa4n79Cw9ACbJ+Quhb82dbig2K/Vq+p7Ppa8fwNViXC0A4MsmvLLGp?=
 =?us-ascii?Q?Z5H54Kmduas7hZ7GdyIDO7IBZNx0TmB9O8pwibJQUEuCvOXXZnX5IL1O3UYe?=
 =?us-ascii?Q?G00bu1vEB4zSuRzntt+ol0z5SKSOG4GL1hSfs7ERxKgL+RADxyamnid5xvq0?=
 =?us-ascii?Q?Z6ptp79k4SbSxJ6scbuEikKrQowRCJS9bxo5+dFu3kiybXyFW+yvs8slaaEF?=
 =?us-ascii?Q?CusBBfDyxsNNfn6Q90nm4FI9hKYgo7BUBZWdsxyeLOSGed1o76VquSudBIJO?=
 =?us-ascii?Q?+w2X3hTGQ2QOqoqlnP+73jxYRqnmamo0y/sTBRFE5Nz/GyGwPBPEpkU5FTf8?=
 =?us-ascii?Q?4bQG+6fEkNNwMhM6huQjSuKer4OICSzyHxLfzEeaIDXW/3evklU0/Ck/LeL+?=
 =?us-ascii?Q?Hg+XB9oa2oPeoOrW1J8bD7rpLvsfeCEpYzwqzce15F9v+Vvpv7u58PxlyF1z?=
 =?us-ascii?Q?Q1DpR7HYdb+g2lU/Q1pyOItF/qhkubdIwwHs6XFehLL57/G5ktDG6UnqbUG4?=
 =?us-ascii?Q?E6SmmPxsZNXr2SLaKKcYey7BXWZvzjHpBJKnrqY9DYxUCcqn2hzVNAfyHhgF?=
 =?us-ascii?Q?YzL0Ukxnz4W+daRm2hXTRVhIHqcU3H2uZekiSAjekHTvVO51rVBnjENdxy8r?=
 =?us-ascii?Q?ycmjKNUTzmaECh0iTL6xLz28lP5oQtAUSWmd1GdJVT3/xyqDVogeh6Si5dwl?=
 =?us-ascii?Q?EwUAcFYGXT7RjqwEeEIcHxl6244QA+10Lk6lEd198+ETfr7emgdNUfAhGl0e?=
 =?us-ascii?Q?i2uYTIOKdFmxc5NCXwW3OuwyHxaqX7F3UN3kavKGWDwRPZU6NROtqZIiUP/P?=
 =?us-ascii?Q?F+IhH/O2h3LHtnNXa5PCZwjq0IEG/coQ4ospCFqmv6i347kzKXJPioXZXS2x?=
 =?us-ascii?Q?voceQr8Gxw7FfA/mw5oUeDO1Y2S8tu/aKp74gPXw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5a243fc-ab4d-419b-a56c-08db0d152852
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2023 16:21:12.4879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MaI1GuFIF4SSbcP0OhU89Rw5IAbi0eOPut3PjG0JqcQ90bIttaB/w0wuAMzZpSsI3iAeGnyPSzev0nB95aqnaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR18MB5477
X-Proofpoint-GUID: ovJcgreWGaC5o6-SRfh-FK_hmLHdANaI
X-Proofpoint-ORIG-GUID: ovJcgreWGaC5o6-SRfh-FK_hmLHdANaI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_06,2023-02-09_03,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Fri, Feb 10, 2023 at 04:40:50PM +0530, Hariprasad Kelam wrote:
> > Multiple transmit scheduler queues can be configured at different
> > levels to support traffic shaping and scheduling. But on txschq free
> > requests, the transmit schedular config in hardware is not getting
> > reset. This patch adds support to reset the stale config.
> >
> > The txschq alloc response handler updates the default txschq array
> > which is used to configure the transmit packet path from SMQ to TL2
> > levels. However, for new features such as QoS offload that requires
> > it's own txschq queues, this handler is still invoked and results in
> > undefined behavior. The code now handles txschq response in the mbox
> > caller function.
> >
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > ---
> >  .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 45
> +++++++++++++++++++
> >  .../marvell/octeontx2/nic/otx2_common.c       | 36 ++++++++-------
> >  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  4 --
> > .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  4 --
> >  4 files changed, 64 insertions(+), 25 deletions(-)
>=20
> ...
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > index 73c8d36b6e12..4cb3fab8baae 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > @@ -716,7 +716,8 @@ EXPORT_SYMBOL(otx2_smq_flush);  int
> > otx2_txsch_alloc(struct otx2_nic *pfvf)  {
> >  	struct nix_txsch_alloc_req *req;
> > -	int lvl;
> > +	struct nix_txsch_alloc_rsp *rsp;
> > +	int lvl, schq, rc;
> >
> >  	/* Get memory to put this msg */
> >  	req =3D otx2_mbox_alloc_msg_nix_txsch_alloc(&pfvf->mbox);
> > @@ -726,8 +727,24 @@ int otx2_txsch_alloc(struct otx2_nic *pfvf)
> >  	/* Request one schq per level */
> >  	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
> >  		req->schq[lvl] =3D 1;
> > +	rc =3D otx2_sync_mbox_msg(&pfvf->mbox);
> > +	if (rc)
> > +		return rc;
> >
> > -	return otx2_sync_mbox_msg(&pfvf->mbox);
> > +	rsp =3D (struct nix_txsch_alloc_rsp *)
> > +	      otx2_mbox_get_rsp(&pfvf->mbox.mbox, 0, &req->hdr);
> > +	if (IS_ERR(rsp))
> > +		return PTR_ERR(rsp);
> > +
> > +	/* Setup transmit scheduler list */
> > +	for (lvl =3D 0; lvl < NIX_TXSCH_LVL_CNT; lvl++)
> > +		for (schq =3D 0; schq < rsp->schq[lvl]; schq++)
> > +			pfvf->hw.txschq_list[lvl][schq] =3D
> > +				rsp->schq_list[lvl][schq];
> > +
> > +	pfvf->hw.txschq_link_cfg_lvl     =3D rsp->link_cfg_lvl;
>=20
> nit: extra whitespace before '=3D'
>=20
ACK , will fix in next version.

Thanks,
Hariprasad k
> > +
> > +	return 0;
> >  }
