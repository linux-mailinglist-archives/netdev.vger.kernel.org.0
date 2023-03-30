Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1690A6CFC09
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjC3G5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjC3G5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:57:06 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A1519F;
        Wed, 29 Mar 2023 23:57:04 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32U6fIfd005539;
        Wed, 29 Mar 2023 23:56:57 -0700
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3pmhc4c96k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 23:56:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7ZG4wpGJ2nwRL3l5BR2tc8MVrRnFjdLokX6ZXt/z4ByS7UeAklauROLlNXmGp8KDja13J84e608zjiGKHvbNIwfD9a+VudRbYaqvu17X3y2as2E1gPOae34xk1rTPsf/GYgE0zr2APBUn6o5KGpQWcEYtExBMW3Oe5NGDgLrLL8aUe/IAaAaEHaGgdL7aVZ8ANIboSW5C/vE1OQC12QSTsDlwtf5PMq/1uBuQdpOV1pCzea6x4rvtjEfusDZkPzhHnKJDSF0aqsmqtIwXtLfMXbMm/8ByKcaMSIHfD9PZPKeeSDn1PKDJJNqi7z0TVs3qtJaUuEyCvmOQMNjeljwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQHxnazsQT1MAhJhhu4kwdKNUnAZNs0Is6ThEnHDBHw=;
 b=bYrawUwwQWq9HkD8CCroAVUuuJpn9zylp2sbuXgYcANOSPRjc1Eb3qLezWg+ZlYWLxVcuVg7eP71hQb+r5KYJ4/bLBpRTw72//SSogeQZcN/BMjTGv1XDMbxnqOGEj2Nn2YTcNYevswuiAuUhnXi3uJbg7MfWHIYYwVodqsn5npC9OXq0MRwnVIK3xVjPL9uFI6DrIJNexzxv+J+RJhMwKlIYw6MO4uv1t0wJLLz45oiTLRusIXKJyPXeLT06jcCOQguiZkjFwwRCsDszm8TN7xMkRG9xOaHaRp1z0su2jdQpk41b6xO+UmqFoEosenWDG0VShiZ5a459VI4jb7Xqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQHxnazsQT1MAhJhhu4kwdKNUnAZNs0Is6ThEnHDBHw=;
 b=rMYkzVk58NPT0oKa9LggJqROHXqPsOuk58j1YmRzbeR25Dvmi/F44y6bJ63WxZJZq/wvk8N97x39X8HyeFTPLNV7Ql/mxAXpPmw/M3PgC8K8ZcVb6h3Esfrj2UP8Dv2ePBaUxqqwG9l0ti5tiGAhNw3sBae4HO/0N4BNfu848rw=
Received: from DM6PR18MB2602.namprd18.prod.outlook.com (2603:10b6:5:15d::25)
 by BN9PR18MB4121.namprd18.prod.outlook.com (2603:10b6:408:132::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 06:56:55 +0000
Received: from DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7089:cecf:1b0a:b436]) by DM6PR18MB2602.namprd18.prod.outlook.com
 ([fe80::7089:cecf:1b0a:b436%6]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 06:56:55 +0000
From:   Geethasowjanya Akula <gakula@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Sai Krishna Gajula <saikrishnag@marvell.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
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
Thread-Index: AQHZYmDcLCUiV2jCj02anLGNhlsRqq8S07gAgAANe+A=
Date:   Thu, 30 Mar 2023 06:56:54 +0000
Message-ID: <DM6PR18MB2602944D58392C6FB6576BB8CD8E9@DM6PR18MB2602.namprd18.prod.outlook.com>
References: <20230329170619.183064-1-saikrishnag@marvell.com>
 <20230329170619.183064-2-saikrishnag@marvell.com>
 <20230330055532.GK831478@unreal>
In-Reply-To: <20230330055532.GK831478@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcZ2FrdWxhXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMGJlNjczODctY2VjOC0xMWVkLTk2MDItNDhhNDcy?=
 =?us-ascii?Q?MGFkNGE3XGFtZS10ZXN0XDBiZTY3Mzg4LWNlYzgtMTFlZC05NjAyLTQ4YTQ3?=
 =?us-ascii?Q?MjBhZDRhN2JvZHkudHh0IiBzej0iMzQyNyIgdD0iMTMzMjQ2MzMwMTIxNzMz?=
 =?us-ascii?Q?NjgzIiBoPSI4L1ZReGI1aUh1cG9vR0pyU29nUHNoMXNnaXM9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUF6?=
 =?us-ascii?Q?eG9mTzFHTFpBZUszc1FXOUhXL1A0cmV4QmIwZGI4OE5BQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
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
x-ms-traffictypediagnostic: DM6PR18MB2602:EE_|BN9PR18MB4121:EE_
x-ms-office365-filtering-correlation-id: 1768ccaa-4601-4238-c34b-08db30ebf2a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X+CTDQlQTiy4ZRm0C6OBS1xCg18x70IV3IdOHYQHhcLi2AHqOPLI2oF8KwaewDOgNAZI737+iLVw1L0kkaBk7t2iJ5HdoTDSfhaP2vsqdlWc5RYFIyfUR4FinfB0LpECIzKoIXSFSyUcI/3aguOn9BxUus06mweadTzxbafN8QCdgOCQ2zNUvMLH+u6dTQbrtKNPfIGIOC9u6EAQpukFqrr+THQ7jNAiHvslUpU88R2xayFQqZq24dQXZ5j2FKqX7Bxe7bgUjR8wXPL97CafraUOj9V67ScVOkEHgHikCrO3cFJIFhxVP/1YygAgrmhvIhIVU0nWBEyhhRL1HpNKOClv9bcSswLxAoirG2hQ6cPTy0WE/z5ySkAuUMyQV42mZzD/3dpChsMf/mH+ZO+nVErfgtfrSDzlLWhwBOj83NyO32NMO5FsLKX6Li9kXK24n+ptWHHcYcO+cOgAw9GHIKCkAd0e7JuBKQi7j86Lx+IxOkggvMgCTt5qM7zEKELXURKOjAz7vhugFeYwvujtUQZo4vwPbCVX8eQ2pit2ifpkUUziVEysmP/wAoSP4MJQ9vA0iyNhD14ctPsYE3fonqeyoK15sJXsyFMltQKeBiMsoNgmdSFG7E6d4JHHZJaU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2602.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(83380400001)(6506007)(122000001)(26005)(110136005)(54906003)(38070700005)(71200400001)(7696005)(316002)(52536014)(76116006)(6636002)(478600001)(8676002)(66556008)(4326008)(66946007)(64756008)(66446008)(66476007)(55016003)(41300700001)(86362001)(9686003)(38100700002)(2906002)(15650500001)(5660300002)(33656002)(8936002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Irz6FLGLTWqERtXoXTFxaggXN+NsyN7liiSlydY+ST+D0gAe/6aHDYT/DMYS?=
 =?us-ascii?Q?bs5OfjzrIFUYJOiJmLMRPxPy2uq2TNewTXnA2bG7rchbvhtYhsP1C+YmkyK8?=
 =?us-ascii?Q?Kx2paT1boUZh4/XWme9vL7DMMot6/FzIbwmSt/vYUS6P/543Z/6Yay3yuuUu?=
 =?us-ascii?Q?XoRngh+Z52TwMoiczvjHHH+W/TEwBQS1fxZAu0q2G0muNWKwvNKO6P/TYYoe?=
 =?us-ascii?Q?G3RDmqk6OHC19kGIrksKdYDnqH6EF0ut81AR3OgW1/nNdnDr1tDPQrEKplnL?=
 =?us-ascii?Q?ceU9/Ihsa8jD4TlyZg8zxzhDXfN/ryAIjp6b+eV0Y7oKJKhm7gshgp/pTUfW?=
 =?us-ascii?Q?p3WaW0aqjR3Hw2TSrbF4PZ1JriqsdtKg2vzEf2GEO0DC3EqFFvkyKCBPQ9gC?=
 =?us-ascii?Q?dyaVnDk8ydPY9g+LwBThguyiAgpdk1XKevRKpkcnVj3gLwXFokzASWG+BPbw?=
 =?us-ascii?Q?UsQLdJ5j8gg1fH1bhKnE92zL7Ynk8xS3BinZrb1+pPiFzYfQE998BqnysKkX?=
 =?us-ascii?Q?UF8UvX/BD4E2EH5C99NFvQdj9bJRr9j94CrS/ridg0Ikkt9ahYHGD0q/SSwW?=
 =?us-ascii?Q?8c7J6BTS2ohRtIrBwPZjZMpvrnQ1F/bTgVA+r4xduOksOgkeHQZ/bg/fUdwT?=
 =?us-ascii?Q?WQyeIWOuULKzZacTLtQdvnSO+i6tHjHXw6pJ5vTMDW2DpLM8EPo9DNW+hZ4g?=
 =?us-ascii?Q?W43CU/bQ1x3S1aohl0j+li+CPlqiVeaTkSt0Z42XjgOIopbwJpygE7g2AdgR?=
 =?us-ascii?Q?tdWl3p5nXL4dfsqikxk9QJXDnIQ+1X16hNe01oKIFYXvGW6fHa6fBYM2g/qY?=
 =?us-ascii?Q?86UWxwrTO+0oJnq8m6SmQATNVTgzvNylFLTr/Y4fPANLZdr54SgjPimIAzT1?=
 =?us-ascii?Q?0ZWIS7VXREuW32ZrJqNm58iSJ1rD+K/mZb/txzTSmru7M3mHGVhbDqjI2Air?=
 =?us-ascii?Q?tEn1HqM2SXTVcI+gsxMHThRnT8cAFg1hNexqW3EvqB37hn6nzfLWHWyTF4SP?=
 =?us-ascii?Q?yvAEqWDIG3C4dnZMlZTMhC51iSMPOGOW9TEoPWT9m/W+FQ559YWjPl1zY8bg?=
 =?us-ascii?Q?xQkYhWLGRl9xk1C6MKXMTTwBo6JaLaEAfovTfbwkLpDyljs03zX+280TBLie?=
 =?us-ascii?Q?U+8jTWwF8V9uydWnoT5ddBOoEP9Qsb09ZKAJom6CULIYrvSHbRqNgBiS2lRJ?=
 =?us-ascii?Q?Vzeg9Ct6WnImUPSNq1j+X3LCbw6kpZVJx9cEvskxmhxd1Cis0Lalj2lUNgI1?=
 =?us-ascii?Q?N/6i28zghprZ0zHOsjKhIVwDz5DSeUcjAyAkQBXuEi+4al4DOam3WU9K/Fqq?=
 =?us-ascii?Q?MtssedByPxNNMl13jeJtUwDhf7QUrA6SaeNwGVeLRGVUTQFEb0VsOCAJVY4T?=
 =?us-ascii?Q?CMefRD2KY2OmvXWhzkKXlv0/e7Id0rUzeMl4sNDoyHyvJKmT9rSKfXcuTYGl?=
 =?us-ascii?Q?/z7s+HabGAdl6vfgoyy5aetvV1lTHnxA5UmGDiZNHO5y8ZYntzDE0pJMNx1v?=
 =?us-ascii?Q?xpr6xftdUN7gEhAAKVe/HJLorHErF8kSt8Ptpp38c78qpvOf5Alcjf64jg3o?=
 =?us-ascii?Q?KKIih0qAHZYisdIzVEc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB2602.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1768ccaa-4601-4238-c34b-08db30ebf2a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 06:56:54.8960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JnMXQnQP4vJEIw8L14WFjIG+2WFSIvM0P0J22Z2tBOnNRJwM5Hko5KiiexxpcmXY0khGcIngJndRlsstRk+7hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR18MB4121
X-Proofpoint-ORIG-GUID: a_WWYU0lrbV0as-A2-let7zC0Ip-DVos
X-Proofpoint-GUID: a_WWYU0lrbV0as-A2-let7zC0Ip-DVos
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_02,2023-03-30_01,2023-02-09_01
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
>Sent: Thursday, March 30, 2023 11:26 AM
>To: Sai Krishna Gajula <saikrishnag@marvell.com>
>Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redh=
at.com; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Sunil Kovvuri=
 Goutham <sgoutham@marvell.com>; >richardcochran@gmail.com; Geethasowjanya =
Akula <gakula@marvell.com>
>Subject: [EXT] Re: [net PATCH 1/7] octeontx2-af: Secure APR table update w=
ith the lock

>External Email

>----------------------------------------------------------------------
>On Wed, Mar 29, 2023 at 10:36:13PM +0530, Sai Krishna wrote:
>> From: Geetha sowjanya <gakula@marvell.com>
>>=20
>> APR table contains the lmtst base address of PF/VFs.
>> These entries are updated by the PF/VF during the device probe. Due to=20
>> race condition while updating the entries are getting corrupted. Hence=20
>> secure the APR table update with the lock.

>However, I don't see rsrc_lock in probe path.
>otx2_probe()
>-> cn10k_lmtst_init()
> -> lmt_base/lmstst is updated with and without mbox.lock.

>Where did you take rsrc_lock in probe flow?

rsrc_lock is initialized in AF driver. PF/VF driver in cn10k_lmtst_init() s=
end a mbox request to AF to update the lmtst table.=20
mbox handler in AF takes rsrc_lock to update lmtst table.

Thanks,
Geetha.

>Thanks

>>=20
>> Fixes: 893ae97214c3 ("octeontx2-af: cn10k: Support configurable LMTST=20
>> regions")
>> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
>> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>> Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
>> ---
>>  drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c=20
>> b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
>> index 4ad9ff025c96..8530250f6fba 100644
>> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
>> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cn10k.c
>> @@ -142,16 +142,17 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *r=
vu,
>>  	 * region, if so, convert that IOVA to physical address and
>>  	 * populate LMT table with that address
>>  	 */
>> +	mutex_lock(&rvu->rsrc_lock);
>>  	if (req->use_local_lmt_region) {
>>  		err =3D rvu_get_lmtaddr(rvu, req->hdr.pcifunc,
>>  				      req->lmt_iova, &lmt_addr);
>>  		if (err < 0)
>> -			return err;
>> +			goto error;
>> =20
>>  		/* Update the lmt addr for this PFFUNC in the LMT table */
>>  		err =3D rvu_update_lmtaddr(rvu, req->hdr.pcifunc, lmt_addr);
>>  		if (err)
>> -			return err;
>> +			goto error;
>>  	}
>> =20
>>  	/* Reconfiguring lmtst map table in lmt region shared mode i.e. make=20
>> @@ -181,7 +182,7 @@ int rvu_mbox_handler_lmtst_tbl_setup(struct rvu *rvu=
,
>>  		 */
>>  		err =3D rvu_update_lmtaddr(rvu, req->hdr.pcifunc, val);
>>  		if (err)
>> -			return err;
>> +			goto error;
>>  	}
>> =20
>>  	/* This mailbox can also be used to update word1 of=20
>> APR_LMT_MAP_ENTRY_S @@ -230,6 +231,7 @@ int rvu_mbox_handler_lmtst_tbl_s=
etup(struct rvu *rvu,
>>  	}
>> =20
>>  error:
>> +	mutex_unlock(&rvu->rsrc_lock);
>>  	return err;
>>  }
>> =20
>> --
>> 2.25.1
>>=20
