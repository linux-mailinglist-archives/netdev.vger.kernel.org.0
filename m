Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E52167D2E0
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 18:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbjAZRRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 12:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbjAZRRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 12:17:03 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F466952C;
        Thu, 26 Jan 2023 09:17:02 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30Q9uEkY008899;
        Thu, 26 Jan 2023 09:16:45 -0800
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3nbn722rr9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Jan 2023 09:16:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BkcImSbSw/uPUuNyo2fScX/Qyj/Ku9y6NO8AyqJOh7U3Rxkqcdom59GfkXfLwr1Vjb3hQo0rPWEM4QWhjoJD1UAc2HmXeaKGgn6trN0w0Gc33aBe9ELaZs3WNAltQ3M8HkSFQarnVfPG1lUZacpbOh+780UojVu2QLc27LGF9uVjUNCDvBeaM6N55KDCilYGhMB+mcn+UyLVBSaZ75Xp718pmWGHZsPvfaVNE4f53dhJCRaqo8ddJkdfCeRXGF3RAhWYtiTiRj+UXedOcazRTeTWHShPb3lGD6Q3u/pjVm4CgiawUyJigQNbZMQ/F6I9kqzy3gCEk098LZE7vZMxDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xt82A3ocFcgO1sB2Qhosc/p+e4HsClgfY4t/c6YOZZY=;
 b=nbrd3yYCifs4MIhKuEFs8piGzFCOm5rMZDM/w01AQOa0ooGdVCIQsGa0o5YjiS0Ro1HcDDHMyZy/5vTbDtUFjyEvxjlDolVugwAOfro1p730A5c7uLyP/3GmRqzIHXAE0nymPfepBBQ0rhUOwyJaPSGbfSajesG4rvoP8KgT9gX2UvwMahSQXUWgSHtlUwy71VragYrELdbqg/kJl35QsB5j1Mpr9oiRNqWG5FdKcNxck9NHmZhAyUNZAT1kdAnlF6tJNYdwNSDDUQP5BnWzhQeHufL6BEY1E3D8YJOPbRXKUD8Pwj7RB9h1KvkBeWkd5DQM5kYLxScwVB4+PFbI5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xt82A3ocFcgO1sB2Qhosc/p+e4HsClgfY4t/c6YOZZY=;
 b=A43Lq6xANT1OU0iWpqWZX7vI1kIH7D4Fv44EZVJ8PVEIvvEb8cQYAMxfF43febD37zKMqhEA45NXwsoqGeFbrpaB0f7vmby1O9MER1L4sjAmwbaWUwn1P5brQQqIH3dAvYlJstjoqPgfH0UTewdjbbBsuC9jlAW1evVek/1YxOU=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by PH0PR18MB3829.namprd18.prod.outlook.com (2603:10b6:510:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Thu, 26 Jan
 2023 17:16:42 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e%2]) with mapi id 15.20.6043.022; Thu, 26 Jan 2023
 17:16:42 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
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
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Thread-Topic: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Thread-Index: AQHZMan1TsAbEnDcTkCan9gbCeCC4A==
Date:   Thu, 26 Jan 2023 17:16:42 +0000
Message-ID: <PH0PR18MB44743FF147E3207CEDA58270DECF9@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <Y8hYlYk/7FfGdfy8@mail.gmail.com>
 <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y8qZNhUgsdOMavC4@mail.gmail.com>
 <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y803rePcLc97CGik@mail.gmail.com>
 <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y87onaDuo8NkFNqC@mail.gmail.com> <20230123144548.4a2c06ae@kernel.org>
 <Y88Rug7iaC0nOGvu@mail.gmail.com>
 <PH0PR18MB44748DFCCABCDC2806A2DC2CDEC99@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y8/W5dMmkqkYFNEb@mail.gmail.com>
In-Reply-To: <Y8/W5dMmkqkYFNEb@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMzBlZGVjM2UtOWQ5ZC0xMWVkLWI2ZDMtZDQzYjA0?=
 =?us-ascii?Q?N2UyYjlkXGFtZS10ZXN0XDMwZWRlYzQwLTlkOWQtMTFlZC1iNmQzLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmI5ZGJvZHkudHh0IiBzej0iNjY3MiIgdD0iMTMzMTkyMjY5OTg0OTkx?=
 =?us-ascii?Q?MzQ5IiBoPSJoUnB5bDlzZFRxZXVQMFpzbHcvejZabGVBRms9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQUIx?=
 =?us-ascii?Q?aUVqenFUSFpBUlJ6Y0NDeDBPSHZGSE53SUxIUTRlOE1BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFCb0J3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTNUekZBQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
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
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|PH0PR18MB3829:EE_
x-ms-office365-filtering-correlation-id: 8f8617ac-c651-4b4e-82df-08daffc11813
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JSivE8SPoZbahdLgaGTmrPQbmJNvP6y0pnsinG6sCxTqGSQ3564/gKPy/mb7FH5gdDPhz2/HON44CNUtFLT0wDNE8XxnZ9e9DsTYUoUVslCR6qCEqy+txdayuZwT7ORKGTOHp5j0prRsPAJNxnmeVv6uhY5w96QgdZLk9ELfAvEpHoTP+q4iTgMB/zOJxd4bYX9sJ5VlBGpK+PtoG3W3pPt7LDtHW8erelZazVcyaUGNr1Ni+q5020KSqMh3cgyOUYzqp/8goz9+XnmxIFxA7XujzH6YrLQBBd5F6Jmw0auB4Kw5Dn8yCGTYcGCzQW1aiawx8HTjvzPMBhZVf55+ItTO+vgkfHpDAa08Ti7z1HoJn6L8h4hS/i/TK6SlEa323UXfeZxfCxSoCqPlOdTKyml5Hf/Ttb4p0XQw2pJ060aBh0kBL/7ZFgnwM9qDcl6yRfXIpYI3CAvQ0gd9AX0pCFwD/UF+YaTBGcLFGlVgMM83SDpD5VDFc76WJBfs+ar3n24Vl0CVtrdmTvSy+2CGattgBUJbcAEsFNNRbWJ3zux2K6rh3Mkry3jLWs5dmKgr/dWnEk5/doErt2RuvUY82Yk68+D+O4Ul0Ak0SkSs9pZcnlQfAInJzy+YeWWdeyQWzlOkjzWQE7TD8YN+acxgue4JXNQEMz8KErsKFdkHd+Y+IBg3XuWppHWwKzUAlyvWq7BPM1qabmf/p6JIrhekhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199018)(33656002)(7696005)(71200400001)(8676002)(316002)(107886003)(6506007)(478600001)(5660300002)(7416002)(52536014)(4326008)(2906002)(66476007)(76116006)(66446008)(6916009)(64756008)(66556008)(66946007)(8936002)(41300700001)(38070700005)(86362001)(55016003)(38100700002)(122000001)(186003)(9686003)(54906003)(83380400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VmG4uMLhvVId6N5xgYssocuu63gyfQjfBbxw5gf2XH9BGgxrUSVbi+Hs7AJc?=
 =?us-ascii?Q?rsATd+VD2ADdrV8xZPn792UjGqRcNGwcaJti/DJdE9N0/pS09AG4LQ0JFSp6?=
 =?us-ascii?Q?FKbky0nE3MDLFc3NT5Ouu1LkdwIcgVBMvz5AcuTgP6uNxOTdYd20T8wHDNDc?=
 =?us-ascii?Q?1P8ijQUc3yXZCLQuMv3JMJ4j4WoFBWbwHdO79h15mlIU5CA20hfb4eNeHP3c?=
 =?us-ascii?Q?qRrfvvr2I/0VnTvs/gcfWsJkdRdOv9dgmQHq08VN/PpxJI8iOZoskAPE+lH0?=
 =?us-ascii?Q?kV3Yp2nbsy2jtYbU/0xxm5NHaiyoe1cNcZIgdpwjN3p6aTYwtTYwx3lvjcZd?=
 =?us-ascii?Q?F00L8rxu+nTslrUY6TWrOu7tUR9EwjfAMP/9wN8zchJdxljLS37brOG8e97R?=
 =?us-ascii?Q?Biqj2+fcsCA8Dg8JN0lV7idInrW/B5zP9ijs4kVGQwNqr1UuZIUNHM5mlng0?=
 =?us-ascii?Q?Yk3xzBxE8FG9spR9xPbUQmcRCevnMGBF/CsJ84sk8g5x1kLDrQO72/4b1kqS?=
 =?us-ascii?Q?tfey5KCNEwtI2P7ozzzy8Ik3o4OJqDUTQbENOA2R6ZpFcKvz2UIXVgJJ9tKb?=
 =?us-ascii?Q?cv2P83Sorq1U9va+0NdGp9rYOvUtF0d6w0u0NKpzMyjgOht5Tv3Zbl3X0PCj?=
 =?us-ascii?Q?NckbhfIR79GaaMZGbA8YIB2aUvOZ+F0RxnhOufq6wqfW/wVaByFxzScdKCRl?=
 =?us-ascii?Q?BHaa1scT058KywtNXsOSEkX5e7DCyDvHyPlh9gurRd8rREpFmHn7j4leiALz?=
 =?us-ascii?Q?+XxJsl9mZE6rFFyM+s+VnIxC3nZgvMee5WXh1IIplS0OMhJ15djZaftCoGAS?=
 =?us-ascii?Q?amGztWsOmqC9Re1xz3xhgeSdfKa+3cVvDCWpphZrtUaXPl7tgYW2dX3/xHac?=
 =?us-ascii?Q?Svaw2RzKBwX8hkMCmx57zbMBwMj4bKt73ejLmA04ZQ73S4qiqi9syIm1FLug?=
 =?us-ascii?Q?PSSpgK5X5WMDvQWsDcohgzH/KI3iu/camw5N63y7tB1b4ugcg/f0sP5qqNu+?=
 =?us-ascii?Q?hVprYDJouzbTBugPMPYvwEkmTJ5N+cAbvuKReNja4Zyy4EHF2G/366BSbZXu?=
 =?us-ascii?Q?4yLthZumOBznmSgE8P6RuO5DGSF55OVuDpzTBF6pFg2amZaqIp2SZba/vrWN?=
 =?us-ascii?Q?BTllGf9n01Mm/FdNNmCJs6FFa5fpFM79xKUB5wJKk4kjlYq7BSo8+9vnSgZF?=
 =?us-ascii?Q?eIcoVsw/AW17HQrx5w7kNcyZk6qCky75oY3LEhIIz1bNC2SNdSZmp0HlZ9cg?=
 =?us-ascii?Q?OU9eoj33thwkw5huWDyUj8xkBhjOlqcEOX1P0Z9QHgcDg+p+w2kFgXph5E8O?=
 =?us-ascii?Q?Lg7kwXP01721RgQ6IIHhYD3X6oCu/xUN7lFQ7uWebpfiv9KioIVpRB9353J8?=
 =?us-ascii?Q?SaJUQX2qd80hx2zikJMXdi0bWR1EbcXotHbbe/MKTGfBOI931KNWJiSKmQ0Q?=
 =?us-ascii?Q?OywRSFd+m4fkuGNfAkfaF4SB4WZcGBAUb9456D8upcWVeemrUGOIbz2oTqer?=
 =?us-ascii?Q?8PcfRYuvs9P1ibAECr6GvFPjPsOOXiMbJ9ucZLyIeyjzzb9syeDJ00O6dSJH?=
 =?us-ascii?Q?80RsOq5nCcR5REpeQlSxcKdkhj+YUcNPECrCWAOw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f8617ac-c651-4b4e-82df-08daffc11813
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2023 17:16:42.3736
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E0nAayDsA4OIuWEd8onOcVY5I2Np0LhOpZJGjPZ7Paopa2CybONCDMYnZLdIwA0wKWj84sulSwjfJWKZXzZ5XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB3829
X-Proofpoint-GUID: QUez6QcSV2_idDSV0wGRW5Vyes2q-Bzc
X-Proofpoint-ORIG-GUID: QUez6QcSV2_idDSV0wGRW5Vyes2q-Bzc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-26_07,2023-01-26_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Tue, Jan 24, 2023 at 11:49:48AM +0000, Hariprasad Kelam wrote:
> >
> >
> > > On Mon, Jan 23, 2023 at 02:45:48PM -0800, Jakub Kicinski wrote:
> > > > On Mon, 23 Jan 2023 22:05:58 +0200 Maxim Mikityanskiy wrote:
> > > > > OK, I seem to get it now, thanks for the explanation!
> > > > >
> > > > > How do you set the priority for HTB, though? You mentioned this
> > > > > command to set priority of unclassified traffic:
> > > > >
> > > > > devlink -p dev param set pci/0002:04:00.0 name tl1_rr_prio value
> > > > > 6 \ cmode runtime
> > > > >
> > > > > But what is the command to change priority for HTB?
> > > > >
> > > > > What bothers me about using devlink to configure HTB priority is:
> > > > >
> > > > > 1. Software HTB implementation doesn't have this functionality,
> > > > > and it always prioritizes unclassified traffic. As far as I
> > > > > understand, the rule for tc stuff is that all features must have
> > > > > a reference implementation in software.
> > > > >
> > > > > 2. Adding a flag (prefer unclassified vs prefer classified) to
> > > > > HTB itself may be not straightforward, because your devlink
> > > > > command has a second purpose of setting priorities between
> > > > > PFs/VFs, and it may conflict with the HTB flag.
> > > >
> > > > If there is a two-stage hierarchy the lower level should be
> > > > controlled by devlink-rate, no?
> > >
> > > From the last picture by Hariprasad, I understood that the user sets
> > > all priorities (for unclassified traffic per PF and VF, and for HTB
> > > traffic) on the same TL2 level, i.e. it's not two-stage. (Maybe I
> > > got it all wrong again?)
> > >
> > > I asked about the command to change the HTB priority, cause the
> > > parameters aren't easily guessed, but I assume it's also devlink (i.e=
.
> > > driver-specific).
> > >
> > Currently, we don't support changing HTB priority since TC_HTB_MODIFY i=
s
> not yet supported.
> > The driver implementation is inline with htb tc framework, below are
> > commands we use for setting htb priority
> >
> > ethtool -K eth0 hw-tc-offload on
> > tc qdisc replace dev eth0 root handle 1: htb offload tc class add dev
> > eth0 parent 1: classid 1:1 htb rate 10Gbit prio 2 tc class add dev
> > eth0 parent 1: classid 1:1 htb rate 10Gbit prio 3
>=20
> I thought there was a concept of a priority of the whole HTB tree in your
> implementation...
>=20
> So, if I run these commands:
>=20
> devlink -p dev param set pci/0002:04:00.0 name tl1_rr_prio value 2 cmode
> runtime tc class add dev eth0 parent 1: classid 1:1 htb rate 10Gbit prio =
1 tc
> class add dev eth0 parent 1: classid 1:2 htb rate 10Gbit prio 3
>=20
> Will it prioritize class 1:1 over unclassified traffic, and unclassified =
traffic over
> class 1:2?
>=20
> > > If there were two levels (the upper level chooses who goes first:
> > > HTB or unclassified, and the lower level sets priorities per PF and
> > > VF for unclassified traffic), that would be more straightforward to
> > > solve: the upper level should be controlled by a new HTB parameter,
> > > and the lower level is device-specific, thus it goes to devlink.
> >
> > The PF netdev and VFs share the same physical link and share the same T=
L1
> node.
> > Hardware supports one DWRR group and the rest are strict priority
> > nodes. Driver configures the priority set by devlink to PF and VF
> > traffic TL2 nodes such that traffic is forwarded to TL1 using DWRR algo=
rithm.
> >
> > Now that if we add htb command for unclassified traffic, at any given
> > point in time HTB rule only applies to a single interface, since we
> > require to set DWRR priority at TL1, which applies to both PF/VFs, we f=
eel
> it's a different use case altogether.
>=20
> Thanks, with the example above your explanation makes sense to me now.
>=20
> So, basically, in your implementation, entities prioritized by hardware
> are: each HTB class, each VF and PF; you want to keep user-assigned
> priorities for HTB classes, you want to let the user assign a priority fo=
r
> unclassified traffic, but the latter must be equal for all VFs and PF (fo=
r DWRR
> to work), correct? And that devlink command is only useful in the HTB
> scenario, i.e. it doesn't matter what tl1_rr_prio you set if HTB is not u=
sed,
> right?
>=20
> What I don't like in the current implementation is that it adds a feature=
 to
> HTB, bypassing HTB (also not providing a software equivalent of the featu=
re).
> I would expect the priority of unclassified traffic to be configured with=
 tc
> commands that set up HTB (by the way, HTB has a "default" option to choos=
e
> a class for unclassified traffic, and a priority can be set for this clas=
s - this
> functionality can be leveraged for this purpose, or a new option can be
> added, whatever looks more appropriate). On the other hand, I understand
> your hardware limitation requiring to have the same priority for all VFs =
and PF
> on the same port.

Thanks for pointing out the "default" option. we will explore this option i=
f we can fit this into our current implementation or not and get back.
Meanwhile,   there are comments on other patches in this series and as we a=
re in line with htb offload without the devlink option we will submit
 a new version of patches addressing the comments excluding this patch.

Thanks,
Hariprasad k




>=20
> It's hard to suggest something good here, actually... An obvious thought =
is to
> let the first netdev that configures HTB choose the priority for unclassi=
fied
> traffic, and block attempts from other netdevs to set a different one, bu=
t this
> approach also has obvious drawbacks: PF has no special powers here, and i=
t
> can't set the desired priority if PF itself doesn't use HTB (or doesn't c=
onfigure
> it first, before VFs).
>=20
> Another idea of mine is to keep the devlink command for enforcement
> purpose, and make the behavior as follows:
>=20
> 1. The user will pick a priority for unclassified traffic when attaching =
HTB.
>=20
> 2. If tl1_rr_prio was set with devlink, block attempts to attach HTB with=
 a
> different default priority.
>=20
> 3. If tl1_rr_prio wasn't set or was reset, allow attaching HTB to PF with=
 any
> default priority.
>=20
> This way, VFs can't attach HTB with arbitrary priorities, only with the o=
ne that
> the admin has enforced using devlink. At the same time, if VFs aren't use=
d,
> no extra steps are needed to just use HTB on a PF. On the other hand, it =
adds
> some complexity and may sound controversial to someone. Thoughts?
