Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422C66BCA3F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjCPJCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjCPJCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:02:38 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72BFAE137;
        Thu, 16 Mar 2023 02:02:37 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32G7PDua024068;
        Thu, 16 Mar 2023 02:01:00 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pbxq2rbsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Mar 2023 02:00:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ge0i2yke7CoAiHu9zn3aZK8oPVse5czlG+kjt2xqD+uFvEwf89uZltkVDc0Ihg0/hppQtojXUbEy1QGXsd9SHidBSBBMIoy1LOoaA+dLTXzAwOgn4weN7I41nMNUD/Fw+ML3Ztu4DUGexMhhjEB/trFP9cS/n5z063QoXki31/89IsLjMeQqOLYe+8br/SJwcnzBcmuOQDsg+j9vPMa31Tk0Vf67V2M5YLYm/A5mQQFkoaBaEvJmtZsU295U3Tmr+TPG1u2OkNztNr72q2JbVWVaItd++5Btnt6o8pRtfIb/NkxjGR/nNF+vBxYK/5otALTcYOfF4wi1KXJ9fVKorQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5gkclASfTHxHwXDmwjUT4OD/cGtRsGw4kCaGbQs618k=;
 b=UDqj4y5BSmUfcCkZu+m7EX1MlnOk03+0so9sCctBmo4vPJeLQci1AQO7ZZbOly7zIPsMsttfJco/ahlrxTa1v5iBG2YnojilV+F1/mRnNbRoD9syJb1VwjPLrYEAGOLpwimFLJkPeUH0YuNgEblHpORNDk1P+e045hvRh95gnKmNxfnYFHCVkNT+l1r9ybaI1Qv32uvFlVFropUrMTyDVcxeMPojioeugnOn455/EgiT4tU4//9J3fQpM5bHM7HKyKyT3gmFvGu+QUobiICog+1ifl+0QaxA6hAQkBFRR2aMDefZeWAqvjPt6HxTQvLVO4ZW2jzFfZV7bxxa46Fqkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gkclASfTHxHwXDmwjUT4OD/cGtRsGw4kCaGbQs618k=;
 b=oeOwW9Vc7k1i9saHWbzxQpS76LovH0JOxIn8s6036oq41VBXKcwVzBw0RqyeaG84Zl07XqtPj/t+CQiBkeLErzwcyUt6PQg3SoKf6xPGz7HHTdpVuAQuGWSQ387rxgnxdzNud8NP3AEXdvKTLZWxkl6eV4nfo6cOOQQH2QMzyCI=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by DM4PR18MB5146.namprd18.prod.outlook.com (2603:10b6:8:51::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.31; Thu, 16 Mar
 2023 09:00:57 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7089:cecf:1b0a:b436]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7089:cecf:1b0a:b436%6]) with mapi id 15.20.6178.024; Thu, 16 Mar 2023
 09:00:57 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>
CC:     Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH] octeontx2-vf: Add missing free for alloc_percpu
Thread-Topic: [EXT] Re: [PATCH] octeontx2-vf: Add missing free for
 alloc_percpu
Thread-Index: AQHZV97GqDznRcbEGkaO+A4Ix1oUDq79GmGQ
Date:   Thu, 16 Mar 2023 09:00:57 +0000
Message-ID: <DM6PR18MB2602F8A77B07FFDC1F2B07A4CDBC9@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <20230316023911.3615-1-jiasheng@iscas.ac.cn>
 <ZBLO3FSC4IhoBzl1@localhost.localdomain>
In-Reply-To: <ZBLO3FSC4IhoBzl1@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcZ2FrdWxhXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMGRlMmRjOTMtYzNkOS0xMWVkLTk1ZjctNDhhNDcy?=
 =?us-ascii?Q?MGFkNGE3XGFtZS10ZXN0XDBkZTJkYzk0LWMzZDktMTFlZC05NWY3LTQ4YTQ3?=
 =?us-ascii?Q?MjBhZDRhN2JvZHkudHh0IiBzej0iMjcxNCIgdD0iMTMzMjM0MzA4NTM5Mjky?=
 =?us-ascii?Q?ODAxIiBoPSIwZ2tQWjc0d2taTVpZeVhTTW1iL2FlTExJem89IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUNC?=
 =?us-ascii?Q?SEdIUTVWZlpBYXJVSnVCSVhza3dxdFFtNEVoZXlUQU5BQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUR3QUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
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
x-ms-traffictypediagnostic: DM6PR18MB2602:EE_|DM4PR18MB5146:EE_
x-ms-office365-filtering-correlation-id: ce54c7b5-54ae-413b-faa5-08db25fcf4e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oHPA/unNdqBDxwudnpt1XcpCSMz3Xr26vjCN45g+DGhfb2T/lZVuFnroQuDsCff1qx8J4HJjvgiD5Qp9dLsaEGwY5mOee3T2uVxU5nqDFNmeZ3UHc/Zaw6nqKvGnV1jwYM5w653swtsJzGU0+jXgEdGgshkfsJhMoZNnPnttOAvN+vhL3oyxu8pmqnylKFSpXJkoFi2nXjFCSSR7aqCL06WeesBzJHie8S51UfjeqbvDUeIXmqmmiwTMs5mUMyBjh/ncn/BmNSnyWIXcbTJM1DwS405vZshMrwa6CBaXOiRpCULDD95EGSs9nC4rXBYav16WHrOtyqTl+6a5NolVTvx9eSWG1Y1/TPfQasNTo1LcZ9NTrDyijjj+G+1a6eYOwqyOa/JdOFy2nodnLNGj3HMHYrJnpLDWTEYs8xy8gCCzooFobcXwJQ2upZcNL1leEA7H/ssXg4TqIJEbQjcJ8nHUNjgfHztbsCP++/l9ibwYGK1ZqElri9SZY5HX5Rbt8B2wl1n1BbTrF5RSu9pMaueOgCQXxPWUwK04u2RmdQdHTN9SfLSdWMD2ylIzMW3sB2YxCFAO+99olFTiik4LTYRgOxYB9q60cwrxy1MMdLRMOEtOx2l2iENCpI1W173e7h9gkT+aMDk+HImB2JlyQnKf++F44sbiY3lzATfRta6J2zJ1qRy+JEx4ZuJ124fKq/Q4iaR//O+knt2lCrtvRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199018)(86362001)(38070700005)(122000001)(38100700002)(33656002)(4326008)(2906002)(41300700001)(52536014)(8936002)(5660300002)(55016003)(26005)(9686003)(6506007)(186003)(83380400001)(316002)(54906003)(110136005)(76116006)(66946007)(66556008)(66446008)(64756008)(8676002)(66476007)(478600001)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x1UfvycFzEmzxMHNycneU6X3fymgJvRAhdv/CR2MQTM5aYhNvfk3IFFkW0op?=
 =?us-ascii?Q?jKOmPQ4UPX9Yw0HO2oHdHtfp9fa/1RV1D01zNsgn9fypEY1FpCSWBELuEci3?=
 =?us-ascii?Q?cfOy4c7JHEEnFX/n07YVN2ucmrlM+hMfo6EtFyj6iRHoNVqwZP+aK9LpWFuE?=
 =?us-ascii?Q?uwc9k197jsH9X3NM1xeSdAlIKwtvERvjgkpIJ4VX0Gr6eQcQoP3qexO0JBd1?=
 =?us-ascii?Q?iguauAcE/28pXPpAycpkCLGRxNxfp5Y0nxT86m1L/FWWfYTWD1wxxvz1c0jb?=
 =?us-ascii?Q?ta+g+S/Cp40Usjbo9x5JVYy1fkR9MaBPPUe1wcPvWIkd9d+gN+8SInGOhXxC?=
 =?us-ascii?Q?F2ZsdyceQUJmzi+1HLvp+Njl/+4bguHefRLgA+K0e+Q3pQyRnDMZyA9vowbi?=
 =?us-ascii?Q?KTqoIGOsqn8RL2wWfNKAKDgnG37mRnAr4xwsNwKGYnw1JCRdkgzyphjm/T/X?=
 =?us-ascii?Q?ZDrMeV797U3CKc67T2qnaDjoohCcMPW6WstlRUih2wNS403EuiXHFfE8tU7b?=
 =?us-ascii?Q?+VizzsHMNaUjSmTvDRIhcQ+Ak1RHR8a5tiYqcKQGUP8C+hk6MJeGxm4Jm6fg?=
 =?us-ascii?Q?AYHCQv38/5OfJRHdvAw1F8JEesvUS2PBqjPFeaYFLgfhLloIaK12Wj8erENL?=
 =?us-ascii?Q?voWygGEVTi0uuGtFpvWOpIvSZ6Pvm8Dp/4W8ZJLRtG2+93akNfxsPRpaSvuN?=
 =?us-ascii?Q?n85hbvmoHCJZFL7pj2bmny6ulGJh3DcizOb2nnAYOPvbyjCMgGMuujzm0p8+?=
 =?us-ascii?Q?5DEQ2VoaAvN+Zl2UdsYJZDaJ0IWQ9NyU80vMIozh2hg+QNYbBweKrCtOvNGI?=
 =?us-ascii?Q?N+OC5UtU0uU/5c0caSWBs5ibIlkz8frYQ6bVKecH2HlwIWveHVUMp8JcN8OE?=
 =?us-ascii?Q?tOXmw+8t4032hHRrJ6hiqpPNzGYW+5pWV5UcQsM4Ls59iCVqjpyR44eu7piN?=
 =?us-ascii?Q?b8nxpKPbfYMwDoMxipoWj6Tnn2SCKP4xpy/F9rtFv6Y+OW+qRFqcA5ZsQZDS?=
 =?us-ascii?Q?in4IHON2CeLkR2V4L+UtDMJxFY2dgGJH5+J/3AJ6qAF3mFtH3cx4LqOMHfvn?=
 =?us-ascii?Q?+a5YX0Bkb/6rWQ4ailuvTmfkD+dpz1iP6PjDQqMn/Golt0pnirkGgH1Dw3jh?=
 =?us-ascii?Q?P0u/EznbXGt+JZcmY4qtr2vkwdlvHS4vCdvODklRUwg+eI0PHYnpF06F+ile?=
 =?us-ascii?Q?Zfj/IWA+Wn99bceIJ+VBKHv/253o2pq6LUq4E+Gm8EcR703ZUVyuPB/+Y+7e?=
 =?us-ascii?Q?tr4sYnLfu7XEm7eQe5TREoMYgDRWx2+/K38YViPwyshcpkDSQaD+VmqDfsIt?=
 =?us-ascii?Q?79rAsyc5cO1x2iakF8eFdKP8YUMXXEx1ESUHI/mCwog/KpHDhJKJUPTUrSjY?=
 =?us-ascii?Q?lZbE8Pm7w1teU9Q5RLzuayarKqCt5jDmRFOXRm039X+4yyuLbq0G4veR9Iox?=
 =?us-ascii?Q?TKv5nwWeZl6ImJgevRpSE3dMz49rqHa3/zKfvnOUr6SRpNLa+jafbum1W9RW?=
 =?us-ascii?Q?oMxEL5RqhRl26qUOo9bDGdCKzymLuK64RAJlckoi32WeXieq5dG7JlQ/8bb0?=
 =?us-ascii?Q?CeuhfdlbbqgJQCPtxfkP7Oa2a7DDmxrLwWxB0BPD?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce54c7b5-54ae-413b-faa5-08db25fcf4e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 09:00:57.3181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6stuSEsWb+T2SqQn3qzincjgnuA6V0p2tNYfblAVy9x3ZVj1zK8klvv27cAmNepZr3F9SNlnUh0/6RSZ++muOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR18MB5146
X-Proofpoint-GUID: ybQI-JfV32GcvAKvvxjXQWcYh8vuHwsF
X-Proofpoint-ORIG-GUID: ybQI-JfV32GcvAKvvxjXQWcYh8vuHwsF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_06,2023-03-15_01,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>=20
>Sent: Thursday, March 16, 2023 1:40 PM
>To: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>Cc: Sunil Kovvuri Goutham <sgoutham@marvell.com>; Geethasowjanya Akula <ga=
kula@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Haripras=
ad Kelam <hkelam@marvell.com>; >davem@davemloft.net; edumazet@google.com; k=
uba@kernel.org; pabeni@redhat.com; richardcochran@gmail.com; netdev@vger.ke=
rnel.org; linux-kernel@vger.kernel.org
>Subject: [EXT] Re: [PATCH] octeontx2-vf: Add missing free for alloc_percpu

>External Email

>----------------------------------------------------------------------
>On Thu, Mar 16, 2023 at 10:39:11AM +0800, Jiasheng Jiang wrote:
>> Add the free_percpu for the allocated "vf->hw.lmt_info" in order to=20
>> avoid memory leak, same as the "pf->hw.lmt_info" in=20
>> `drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c`.
>>=20
>> Fixes: 5c0512072f65 ("octeontx2-pf: cn10k: Use runtime allocated=20
>> LMTLINE region")
>> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>> ---
>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>=20
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c=20
>> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
>> index 7f8ffbf79cf7..9db2e2d218bb 100644
>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
>> @@ -709,6 +709,8 @@ static int otx2vf_probe(struct pci_dev *pdev,=20
>> const struct pci_device_id *id)
>>  err_ptp_destroy:
>>  	otx2_ptp_destroy(vf);
>>  err_detach_rsrc:
>> +	if (vf->hw.lmt_info)
>> +		free_percpu(vf->hw.lmt_info);
>>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>>  		qmem_free(vf->dev, vf->dync_lmt);
>I wonder if it wouldn't be more error prune when You create a function to =
unroll cn10k_lmtst_init() like cn10k_lmtst_deinit(). These two if can be th=
ere, maybe also sth else is missing.

>Otherwise it is fine
>Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

>>  	otx2_detach_resources(&vf->mbox);
>> @@ -762,6 +764,8 @@ static void otx2vf_remove(struct pci_dev *pdev)
>>  	otx2_shutdown_tc(vf);
>>  	otx2vf_disable_mbox_intr(vf);
>>  	otx2_detach_resources(&vf->mbox);
>> +	if (vf->hw.lmt_info)
>> +		free_percpu(vf->hw.lmt_info);

Ack. Thanks for the patch.

>>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>>  		qmem_free(vf->dev, vf->dync_lmt);
>>  	otx2vf_vfaf_mbox_destroy(vf);
>> --
>> 2.25.1
>>=20

Geetha.
