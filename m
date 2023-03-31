Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B3B6D1AF1
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjCaI5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjCaI5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:57:24 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E1B10E7;
        Fri, 31 Mar 2023 01:57:16 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32V5ZH0L012823;
        Fri, 31 Mar 2023 01:57:03 -0700
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pnsgc8maf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Mar 2023 01:57:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWKQXXgH8OxCeq7yA4BJtxPrzEqLKk4O0JQzh7tAloPQXN1wl9cPQjmNJJhYm+C9vjVcZkw9LMQAKJRD6NiPR1vA37qwJnkucF5sB7XzSmyf6V9RAd1gG6gt0HFMhpOlA35B7sxlJ/cW/E8YRkXA+rNOqYQ2ay6CFT0phF+xGFQ0B7ZuqugkJZXFusSZo2CmibW2b1Bo+jOViVMiNpWYLlic0QmHH9QRYxVyuEmp4OSTFhIkKnujTeVqHmNOZkRXTmUToG7jWkdj1xcdGU8LDnK3Y/1ph5bexo9pwJNUVxjXJJ1M2F+nvFIGeSZTazxdQetoxAU0T443rv6TfKKOIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OS9BRnWQ+Tg21N4OLoEEwUtXeA5LID4pJSQqPvzNzcM=;
 b=jVBWpbPFqeY6QuGdj19D/o0/PC6DSByv5in2i6fUv0ksTgx2SLkJHE+q7IoMJ5QW2Cc2yj/ljFyDfI8Srrb6zyqPutkX3i92nhkHgD5MONXXH/pi4qDU6VybHx6qUowcpc0ArbOonNN0zBJmscMI8zPnuvlRd57ntXAPanr9Ka7fKTPVpJt3Tsgt98zd0HNSAsC4oQyDgf/Wb3YHvjMvZXC97BZ8Gqb7JtVokFJ4H5deISMRKUPihZ6sBsptFhK7m6uEX/NIEG6mrR2CUhfpRwe/DwBcB3P6D2/Vl79tYY8c2W9JCpkAIim/B7pVoyqb7Q0Zam+7Xzt1vZ34dDQ92Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OS9BRnWQ+Tg21N4OLoEEwUtXeA5LID4pJSQqPvzNzcM=;
 b=CiufKRyIzguU2bgOBsZ6vCqZAWfWYUmfH2sIYurV/LuXIivK68whqk5izST4g8WG0RBbCSDRTglSfIYilSrWgnGMP7bK8bQHEaIEgPLR9x5UTAi5RjILD9WyGsMjWBLBoChsmTRl+9I0gOsqWzQnLMFKYskQCh4w1U+dmzya+s4=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by BN6PR18MB1009.namprd18.prod.outlook.com (2603:10b6:404:71::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 08:57:00 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7089:cecf:1b0a:b436]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7089:cecf:1b0a:b436%6]) with mapi id 15.20.6222.035; Fri, 31 Mar 2023
 08:56:59 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Sai Krishna Gajula <saikrishnag@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: RE: [EXT] Re: [net PATCH 1/7] octeontx2-af: Secure APR table update
 with the lock
Thread-Topic: [EXT] Re: [net PATCH 1/7] octeontx2-af: Secure APR table update
 with the lock
Thread-Index: AQHZYmDcLCUiV2jCj02anLGNhlsRqq8S07gAgAANe+CAAAkaAIAAR3yQ
Date:   Fri, 31 Mar 2023 08:56:59 +0000
Message-ID: <DM6PR18MB26023C300BF91C6A57591252CD8F9@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-2-saikrishnag@marvell.com>
 <20230330055532.GK831478@unreal>
 <DM6PR18MB2602944D58392C6FB6576BB8CD8E9@DM6PR18MB2602.namprd18.prod.outlook.com>
 <20230330071622.GT831478@unreal>
In-Reply-To: <20230330071622.GT831478@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcZ2FrdWxhXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctZmMzYTI3NzgtY2ZhMS0xMWVkLTk2MDMtNDhhNDcy?=
 =?us-ascii?Q?MGFkNGE3XGFtZS10ZXN0XGZjM2EyNzc5LWNmYTEtMTFlZC05NjAzLTQ4YTQ3?=
 =?us-ascii?Q?MjBhZDRhN2JvZHkudHh0IiBzej0iNTk1MCIgdD0iMTMzMjQ3MjY2MTU4NjI3?=
 =?us-ascii?Q?MTY5IiBoPSI0YnhsejJaRFhweEplR2hVYjNHcDc2a0lVVGM9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUJo?=
 =?us-ascii?Q?U2EyK3JtUFpBZVNSQ0tFY0V4Slc1SkVJb1J3VEVsWU5BQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUdnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
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
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR18MB2602:EE_|BN6PR18MB1009:EE_
x-ms-office365-filtering-correlation-id: 771baec7-ff0c-43a3-20bb-08db31c5e361
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P+MwucNtjjZD9AyMnwkUJzw2EezNrlX0GVLQE17QdKgo5wt5w17eQdVzUJ8QclvZMq9HScrHddR+cNWXVvKSROaHEh10euSPzoSSiRGWdw0+3df2vuCu1V1dDzj/I2h8gZB4bjSVykqrAcf2jr7UJJiioaIMdP6WV4Q4qh8x4TuVEuJkCdxKj2T9OaaQJTu0yBCeq8PFfAS6ffdvxs4AwTxuvPBkZKlSAugcK6BFRfcE+bj0aRAKzAOCzNwPD1sC94OBOTFlKsgd8X3vTEQPxxsJ4tKlswMIVg6zloGcuRvpQSMmcNFSRjfXzZIRbJsw5F12T0kICTasvldSXhm2oyEe+15nAqDWUiAZX0a6RCS1rHomsR2YzzvnyeijXgEWtc+THovBIXK4yOgKCb3e3DmLfM5FUjMl7556V92mHZuwlH2tXF1pkEEIz6r1/kZcT0JCM3jQkH9JC2Hwi+UedNjlXZ4VTsYQ9m5YT0lGzyk8PyZlhKVkwrr2grk75aTUJg/muZRnaPD4S6KPuLHG2AxqyZYNNxkH5insjKwtDDmeAp2Cv4yFgj2OEQXjRFrKi4Ux6I4oHXuhXBi3uZypQwFCwBC3syp+MWlNuCoACfFBtNYwfjJz4n/ztH8HC3ny
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(55016003)(71200400001)(7696005)(76116006)(66556008)(4326008)(66446008)(316002)(66946007)(38100700002)(8676002)(5660300002)(41300700001)(66476007)(186003)(122000001)(8936002)(64756008)(52536014)(54906003)(9686003)(83380400001)(478600001)(6506007)(6916009)(26005)(33656002)(15650500001)(86362001)(38070700005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hZwGR52+ONtpLpsxn3kmaz37xJcKGYRIYDzxYFAcd6v1l8jRs+K9x/AqPgl4?=
 =?us-ascii?Q?8WKxkYrDTSd+z2m28yJWsSSmzR3ncCpPnPomkSahsj0olGqKkRCtvN4A/c3K?=
 =?us-ascii?Q?Mnfqu/nrEyLvCFPZEkFgNIYckMYO8Jcckyu9aWJyMok9re1B47t8nrETsVEn?=
 =?us-ascii?Q?n29RtldwQ4hI7jK5v1ooLPQBTvC5W3rhmMy1w3FXmqmDrzqAybEp4viN0UiB?=
 =?us-ascii?Q?KQfiY1qOF5j+jVe+eneUQvg0I8dSDxhIdosv3Y/wAIPf01E8Yj2opqoaTOS6?=
 =?us-ascii?Q?fURHX3Ss0xnjPUdgihNodI1h0O8gIKgIMErgRRZUbmT2cjEOl5HDXd/sGpuh?=
 =?us-ascii?Q?9gIPq/QomcxrT+qD22/sNtwfKe/CEVM6bLS4WceSmpuKguOcamCKuWe62FBT?=
 =?us-ascii?Q?/fvX3tlj3Rdu2IvxKl1JdieZQPRxjLN6x2Jr2NVzEn4Si/gsrHQOmbhp/Jkf?=
 =?us-ascii?Q?6JlHejDE1dTzyWMjVAiunmIQeJCAM8CV5tYDEqzoxTzBUo3F42dyqq+JAFRZ?=
 =?us-ascii?Q?Fkfo83+oiTGVXW2Xo/l2l2ERk7409zFcHUJFJQs/txC00VZRRFDutmort3zq?=
 =?us-ascii?Q?bJOXFSx0YC4tjl+5eGCR7IH8h5jYFAGuDFVCyi62uleLe+9ACNA6PuQFVhjG?=
 =?us-ascii?Q?FpKcIjhKjlNaJr16wYi2VRvo8+9UYnvcDmDk1S5BRFs+ZxIUL5dmE/SG2pHX?=
 =?us-ascii?Q?YfDc0+WiH83ZkAVphCsyQgIWSYJGKQO+GXZlhkOBa80cGoI9QZVfVK6XOJ2X?=
 =?us-ascii?Q?9oxvWh6DRP9/Taz6yzMeoeCV2GWEceFg8/jfFYJA0nWE0zlJjJCI0MqfNfMy?=
 =?us-ascii?Q?aJvSeKz+tvSb0kwmShCRVZ6/y125Om/tEWn4qStPISPms8/1h9QSRAP5Gs3o?=
 =?us-ascii?Q?rabIElL+uxSotc3MhRjxRlLPv/Mer+7An1kDJ43yAmguxY85uFuLLZd5mbt5?=
 =?us-ascii?Q?DPodQPuc9MJ0KVpeqCAUDQpwQjYdoiQh/S7NI7xC/WSIAWF5hWtdP9Vesb3a?=
 =?us-ascii?Q?62wGR3kNzgpovOFtTJjEJyh6JG72Mf/YSqN5lCU2JBDV4/8+0r6ths31HMfg?=
 =?us-ascii?Q?LGVb5pWYf/Ga+eQgBuEV85f9QONVL7Hi2TFJkBQdAHyq56NTVPsf2Uk9qmE3?=
 =?us-ascii?Q?sjHAD3HTK7eM5GzeU4OouTNTLeeaeYmvN2RzimJaqxjT03qiGkfRU6VVehVh?=
 =?us-ascii?Q?9DnqZP4tTtyf8ovizEtDfqYzm4HJ1wiW9pZMbT0cwmuZ5W/px3fL/5+1uguA?=
 =?us-ascii?Q?iiyP+4j95Aw6wEGsIky39TOC1dKjf+ZIdaYm9lQKeV+ZzPRPy+1R7a5lm7Vk?=
 =?us-ascii?Q?x3hF4O2OdmIpl6RUA24OesAqD1xWvK2k59RrlYI36nyeqpmqR+KOTupytqmf?=
 =?us-ascii?Q?g+ylVUYxJNVyKVzLl6zaa724Fu9zYoeriZJkMJoaqeYIEJtjcq8zAH4kue/d?=
 =?us-ascii?Q?rC6g9Xem9blT/VrmiLvuzVN3Pd7qhxxl4jWUG36gAh6EN4uAMA4NAGKiynW6?=
 =?us-ascii?Q?DgF04GJgvTI7B1Vot3tkZ5C9F0MunFqThsLpG5AjOlFQNKdY3kkFBjfCdlGZ?=
 =?us-ascii?Q?eRnvr74PvdTXUtUkmuM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771baec7-ff0c-43a3-20bb-08db31c5e361
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 08:56:59.5594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mqk6u5JDO0nzrYAfB2mY6Ni611APYKhogAjOJ3A/+0AbekjVCuvl+iWQOyfXzNptudCqDiXqLI1+UwPpVWMN9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1009
X-Proofpoint-GUID: VokxcFplbSgukVyFUeDQiQZj-ajH9yB5
X-Proofpoint-ORIG-GUID: VokxcFplbSgukVyFUeDQiQZj-ajH9yB5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_04,2023-03-30_04,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Leon Romanovsky <leon@kernel.org>=20
>Sent: Thursday, March 30, 2023 12:46 PM
>To: Geethasowjanya Akula <gakula@marvell.com>
>Cc: Sai Krishna Gajula <saikrishnag@marvell.com>; davem@davemloft.net; edu=
mazet@google.com; kuba@kernel.org; pabeni@redhat.com; netdev@vger.kernel.or=
g; linux-kernel@vger.kernel.org; Sunil >Kovvuri Goutham <sgoutham@marvell.c=
om>; richardcochran@gmail.com
>Subject: Re: [EXT] Re: [net PATCH 1/7] octeontx2-af: Secure APR table upda=
te with the lock
>
>On Thu, Mar 30, 2023 at 06:56:54AM +0000, Geethasowjanya Akula wrote:
>>=20
>> >-----Original Message-----
>> >From: Leon Romanovsky <leon@kernel.org>
>> >Sent: Thursday, March 30, 2023 11:26 AM
>> >To: Sai Krishna Gajula <saikrishnag@marvell.com>
>> >Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org;=20
>> >pabeni@redhat.com; netdev@vger.kernel.org;=20
>> >linux-kernel@vger.kernel.org; Sunil Kovvuri Goutham=20
>> ><sgoutham@marvell.com>; >richardcochran@gmail.com; Geethasowjanya=20
>> >Akula <gakula@marvell.com>
>> >Subject: [EXT] Re: [net PATCH 1/7] octeontx2-af: Secure APR table=20
>> >update with the lock
>>=20
>> >External Email
>>=20
>> >---------------------------------------------------------------------
>> >- On Wed, Mar 29, 2023 at 10:36:13PM +0530, Sai Krishna wrote:
>> >> From: Geetha sowjanya <gakula@marvell.com>
>> >>=20
>> >> APR table contains the lmtst base address of PF/VFs.
>> >> These entries are updated by the PF/VF during the device probe. Due=20
>> >> to race condition while updating the entries are getting corrupted.=20
>> >> Hence secure the APR table update with the lock.
>>=20
>> >However, I don't see rsrc_lock in probe path.
>> >otx2_probe()
>> >-> cn10k_lmtst_init()
>> > -> lmt_base/lmstst is updated with and without mbox.lock.
>>=20
>> >Where did you take rsrc_lock in probe flow?
>>=20
>> rsrc_lock is initialized in AF driver. PF/VF driver in cn10k_lmtst_init(=
) send a mbox request to AF to update the lmtst table.=20
>> mbox handler in AF takes rsrc_lock to update lmtst table.

>Can you please present the stack trace of such flow? What are the actual v=
ariables/struct rsrc_lock is protecting?

The lock tries to protect the request and response register at line#73 and =
line#83 in below function, from getting overwritten when
Multiple PFs invokes rvu_get_lmtaddr() simultaneously.=20
For example, if PF1 submit the request at line#73 and got permitted before =
it reads the response at line#80.
PF2 got scheduled submit the request then the response of PF1 is overwritte=
n by the PF2 response. =20
When PF1 gets reschedule, it reads wrong data.

#static int rvu_get_lmtaddr(struct rvu *rvu, u16 pcifunc,
  59                            u64 iova, u64 *lmt_addr)
  60 {
  61        [...]
  68=20
  69         rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_REQ, iova);
  70         pf =3D rvu_get_pf(pcifunc) & 0x1F;
  71         val =3D BIT_ULL(63) | BIT_ULL(14) | BIT_ULL(13) | pf << 8 |
  72               ((pcifunc & RVU_PFVF_FUNC_MASK) & 0xFF);
  73         rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_TXN_REQ, val);
  74=20
  75         err =3D rvu_poll_reg(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_RSP_S=
TS, BIT_ULL(0), false);
  76         if (err) {
  77                 dev_err(rvu->dev, "%s LMTLINE iova transulation failed=
\n", __func__);
  78                 return err;
  79         }
  80         val =3D rvu_read64(rvu, BLKADDR_RVUM, RVU_AF_SMMU_ADDR_RSP_STS=
);
  81         if (val & ~0x1ULL) {
  82                 dev_err(rvu->dev, "%s LMTLINE iova transulation failed=
 err:%llx\n", __func__, val);
  83                 return -EIO;
  84         }
  85        =20
 =20
Thanks.
>>Thanks

>>=20
>> Thanks,
>> Geetha.
>>=20
>> >Thanks
>>=20
>> >>=20
>> >> Fixes: 893ae97214c3 ("octeontx2-af: cn10k: Support configurable=20
>> >> LMTST
>> >> regions")
>> >> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
>> >> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>> >> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
>> >> ---
>> >>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c | 8 +++++---
>> >>  1 file changed, 5 insertions(+), 3 deletions(-)
>> >>=20
>> >> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
>> >> b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
>> >> index 4ad9ff025c96..8530250f6fba 100644
>> >> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
>> >> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
>> >> @@ -142,16 +142,17 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu=
 *rvu,
>> >>  	 * region, if so, convert that IOVA to physical address and
>> >>  	 * populate LMT table with that address
>> >>  	 */
>> >> +	mutex_lock(&rvu->rsrc_lock);
>> >>  	if (req->use_local_lmt_region) {
>> >>  		err =3D rvu_get_lmtaddr(rvu, req->hdr.pcifunc,
>> >>  				      req->lmt_iova, &lmt_addr);
>> >>  		if (err < 0)
>> >> -			return err;
>> >> +			goto error;
>> >> =20
>> >>  		/* Update the lmt addr for this PFFUNC in the LMT table */
>> >>  		err =3D rvu_update_lmtaddr(rvu, req->hdr.pcifunc, lmt_addr);
>> >>  		if (err)
>> >> -			return err;
>> >> +			goto error;
>> >>  	}
>> >> =20
>> >>  	/* Reconfiguring lmtst map table in lmt region shared mode i.e.=20
>> >> make @@ -181,7 +182,7 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct =
rvu *rvu,
>> >>  		 */
>> >>  		err =3D rvu_update_lmtaddr(rvu, req->hdr.pcifunc, val);
>> >>  		if (err)
>> >> -			return err;
>> >> +			goto error;
>> >>  	}
>> >> =20
>> >>  	/* This mailbox can also be used to update word1 of=20
>> >> APR_LMT_MAP_ENTRY_S @@ -230,6 +231,7 @@ int rvu_mbox_handler_lmtst_tb=
l_setup(struct rvu *rvu,
>> >>  	}
>> >> =20
>> >>  error:
>> >> +	mutex_unlock(&rvu->rsrc_lock);
>> >>  	return err;
>> >>  }
>> >> =20
>> >> --
>> >> 2.25.1
>> >>=20
