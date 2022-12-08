Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E6C6467A1
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 04:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLHDRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 22:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiLHDRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 22:17:52 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16ED932063;
        Wed,  7 Dec 2022 19:17:49 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B80XY14002489;
        Wed, 7 Dec 2022 19:17:37 -0800
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3m86ushyrf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Dec 2022 19:17:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oBQqepeX45+kbXiuVqvXlc4Cb3uU37ln3SU6Lt1vXnTFfM832mdU6z5qA/9eov0ugBZTMnI3auNDvKg23Oe+zqswZMnjg1Kx2IemZwg8vkbWQ9CWxPJpzWAUsvulterfvpYEUXi9FS03Qg7iuC46+cdGKbnP9U1Iz37tO9K/Ox1O5GFmmvxoDm/7OqoKlB59ZvuM35EyriDwAbUp/mko+4yPknvJ+g52sXkVwQanhvAbSfe3eBov6IBoWbvZw7tUep7xBLGe/UMC7ReraNQsacdg+ZDQNngZ9HgSDSd8XBm4QM+uVrPCgbYO7wjGu6iqHZ7rkNBU1vTb8UbANz6ygQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhmqCFdIbapAfL1x6m3Vdw2CT1u4FpfsgKsAxApjNkk=;
 b=iC7buM+Z3ZhXn6bQ1OIff4HGujTTgcXi2kZ7Tz5jW5Flo9iiDtUdOXpEkSJ1tHPOvJMPIpyMORk+vP3qcrEaBuAfXGmOgyrejKQwR59eAcpYrZhn1l/mK1Cn8TNBZFageXpkALVCtbypvc3gv4k0hxMb/zBt2ASn9SmLHwJii/FqYr+LdSfOVgSk7sh9WIyUxwSNOANjMzkJHMrickLbjGum9FTjsUgFryhPAnBif9qNNttxIkBTWxm4kIXBtWsHREP907ndafnLopEAuGwFlHZFbI/kOwFbgRTR7s3J8TBQSXnjdhj3plj1EqZ27I0G2Txd9EEtWZNe4i6FnzaixA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhmqCFdIbapAfL1x6m3Vdw2CT1u4FpfsgKsAxApjNkk=;
 b=BNQ9/WwC6FwYUC5UCq3OnYwr7e2Y1mRXThqOvLrzrCrgCxWBj8RMCtXvvvp3lF4YXYA9lWn3RobNpMIcS22rq1jw5V1yVezUokj7AFbljFHQL1dOQy3WtPMc7zFihUO13wBCWqvY4hz+5uR7QjAVM27mCEvgCppr0mi5mqTHNBM=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by PH0PR18MB5192.namprd18.prod.outlook.com (2603:10b6:510:167::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 03:17:34 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::81c8:f21b:cf9e:df2d%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 03:17:33 +0000
From:   Veerasenareddy Burru <vburru@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liron Himi <lironh@marvell.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        Sathesh B Edara <sedara@marvell.com>,
        Satananda Burla <sburla@marvell.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Thread-Topic: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for control
 messages
Thread-Index: AQHZA/PZs+9RX6z1+0m5ZGIy8eBWva5XNNSAgABoFsCAARQmAIACoOYQgAOoOwCAAQ3cAIAAkfKAgACNHgCAABTMEIAAcicAgAAy6jA=
Date:   Thu, 8 Dec 2022 03:17:33 +0000
Message-ID: <BYAPR18MB24234AE72EF29F506E0B7480CC1D9@BYAPR18MB2423.namprd18.prod.outlook.com>
References: <20221129130933.25231-1-vburru@marvell.com>
        <20221129130933.25231-3-vburru@marvell.com>     <Y4cirWdJipOxmNaT@unreal>
        <BYAPR18MB242397C352B0086140106A46CC159@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y4hhpFVsENaM45Ho@unreal>
        <BYAPR18MB2423229A66D1C98C6C744EE1CC189@BYAPR18MB2423.namprd18.prod.outlook.com>
        <Y42nerLmNeAIn5w9@unreal>       <20221205161626.088e383f@kernel.org>
        <Y48ERxYICkG9lQc1@unreal>       <20221206092352.7a86a744@kernel.org>
        <BYAPR18MB24234E1E6566B47FCA609BF8CC1B9@BYAPR18MB2423.namprd18.prod.outlook.com>
 <20221206172652.34ed158a@kernel.org>
In-Reply-To: <20221206172652.34ed158a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcdmJ1cnJ1XGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctZDk0NDA4MDQtNzZhNi0xMWVkLTgzNzMtZjRhNDc1?=
 =?us-ascii?Q?OWE1OGFjXGFtZS10ZXN0XGQ5NDQwODA2LTc2YTYtMTFlZC04MzczLWY0YTQ3?=
 =?us-ascii?Q?NTlhNThhY2JvZHkudHh0IiBzej0iMTE2MCIgdD0iMTMzMTQ5NDMwNTEwNjAx?=
 =?us-ascii?Q?NDM2IiBoPSJzVng2RTliSjh1cG1qMFg1eWk3SXhuNjhuOE09IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQURj?=
 =?us-ascii?Q?UktHYnN3clpBVG93L1pGZGMxUnNPakQ5a1YxelZHd01BQUFBQUFBQUFBQUFB?=
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
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQURRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR18MB2423:EE_|PH0PR18MB5192:EE_
x-ms-office365-filtering-correlation-id: ca07b474-f745-41f0-eadf-08dad8cabfc9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CIWj9eJiJi3DM0IgiK0g8iRxzr5KI/Xm+hvSqTfnslM6h339cD4wxKgz7rUoECqyb3jUD2NlHOgCOc2s3Eybm9NZDNoygz/vBp+aAQf+DX+8ax6c8DSmMr+XAy6u0BPm1UNZas7qJVm2tvwJcMejJBS58IenGMu6SHZygqO2H504dmTMJnXzGcph0kPo7hW5G8FvjM48Qnxu7OmhJ0Pa0juZASZpEgBTt7g0XCSbgJxpGzzTmFjlrpGoJ0E0f+xchYg4GPp0EUmPoteEe/08WV0AsCoiQiQQxyQX9KYdTzZsy7bVi1RQzGoeHEWzQUY9UoPp2MMmmsEko/X6ua/FkS8oMEsukzeAtnXIp1nQY58d45jmNcEh5C19RV3Anch9hYkB3oubdgZPwsoDA+xs+wBq3Vjup4FH37Ka5zKHtiGft14pXHWIlqEW7a4CUjfAVTaXDcJQN+jznPZJLkvNfJh3X2kyq1A2iP20pajhF3nJO5FNuBl9AJC58H44GeeSn2t17fONok+MD04obKRE0z8xhTG3iExWQC24DdMIAnblGZsreiSbbyCDRphq7l2kiWUjQLmPoYDqBG6doJqHlgj4PSzu2z7Ps8IUm2ddUpm+I/FT/KmgsMUg7iDCxwdgupdaqHvHex79zvSvsZGkHftjDZ5azZCwNo3mGV0/zoMw0y7UnIiAkb19jx8M/sBUcWg5TSQDv686uYiHfUH53gWwZPpz9zwqT6wLvBPsfu0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(451199015)(54906003)(4744005)(2906002)(86362001)(8936002)(5660300002)(33656002)(4326008)(38070700005)(38100700002)(15650500001)(71200400001)(83380400001)(478600001)(122000001)(66946007)(66446008)(66556008)(6916009)(76116006)(316002)(55016003)(8676002)(52536014)(9686003)(41300700001)(6506007)(186003)(53546011)(64756008)(7696005)(66476007)(26005)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KucpEM4aUMX7807XSjfHma6Ob2n4O9OxqTaXgfrF/QmXyQ9FBpH6iHT4RIrw?=
 =?us-ascii?Q?xQuZbxir0rGLQa636HRl6lxOAyAwJhAOPR7T+E6J0RuFXXnJY1RV4b+9ag5f?=
 =?us-ascii?Q?qA35mRkaWNxOPOGW58jy/o7IPj6Xh3vozW+BQe2MxZAmOJo6oHMZtWHXQC7X?=
 =?us-ascii?Q?tQkKkXD7g1vtjGhz+Xo/zpEZJvUAenk78WLf5aLh5JciSfNsx514LTGW9BP6?=
 =?us-ascii?Q?LhJd6J6v7+J+Fam4pGGMuABWgmefrMPg6Wj/Vxrn/t/6LLp96X7rqEPSVogf?=
 =?us-ascii?Q?hetJdRFtg5PwoOu1GudO896eDZ7FtJFKhDG+S+hlXquTfnNwGaw7sDX2mk89?=
 =?us-ascii?Q?BPrfoyR9S8d2m8SoXOi+9x97mKNZVc/WO/H+Dz/1f/wFdXtBcscCD/p1/TMg?=
 =?us-ascii?Q?WXwjvKxx2UMTRyXkwiocusHmyMmSy5HtMZc+qW1JH3zTXTzpPOvovPy9ncPG?=
 =?us-ascii?Q?1X+UMS/1xow+OD2ty+S/It+kG/EoF979qV9HuG3pzEJRnxtNv98u0jh5ymK9?=
 =?us-ascii?Q?TdscImTmMzHrJVSKewv8PDwadrUO7zBhNrxsFDVeHuDvmuUVFW6SEEo6ohzy?=
 =?us-ascii?Q?9/ylZk2pJdpK157G/k3z4Ixw5/U2beLR+STuOc4YhQ8J83oGEho9zWxyL9m1?=
 =?us-ascii?Q?QUsZ4OJV6P9XwnuVXBswrUTjWHQhUSVcfg8yM5jVORVdC+y3ysK/KQLwyVu4?=
 =?us-ascii?Q?jr7yNiYUq7USGAP3drkgTMpdvIOAH2FQZWWw+xXaZ86t6Hr4h3kUrzNAfPiE?=
 =?us-ascii?Q?FGn/0x2QQMgWGNFpiduFIQeiJZJNG8iP7X42A/D2lw8FsY7Dyv1DFB5fBB89?=
 =?us-ascii?Q?6OIRXs6vI1hSPmfy2tXr1K4lQz99VSlI/5WujT5391TVe607LVvrHfBNJP98?=
 =?us-ascii?Q?3R5ryy4LC5xtjuLs16oAGWh7roWuzpyIOXS0srAdkawnh91bZ4a6tMPkH3B/?=
 =?us-ascii?Q?OJ7Y8axq6T5fBVWwk9Gbc3TtxxdjSNlDb7xXaVzmOU5Jrlc+HcUV1W4L/f02?=
 =?us-ascii?Q?MPQFpxfGx9r1unWu/LFMgyGhcWanRWm31SJT6BYaCsb9UfLjOeUEM/5Ro0FP?=
 =?us-ascii?Q?yAXp5Z07hpplJedLXzFFzQPq7TkekEcUCuRN/HLVTAi8eybzRav8Kb5jih4b?=
 =?us-ascii?Q?l8wIXhoqJyRuKzw7Xv91iIHPQGYFR/YUwTa7GHRPQEhsKeiep3BQ+4ZnI7Xm?=
 =?us-ascii?Q?nz0xEIaTK4Xp2ULTquO4cN0ZA+pQzKQMxLeaUJKkRMDLW41kcCXNlugO5Hmy?=
 =?us-ascii?Q?8QrfxclRPhzZNDAbybEXBJQmT8CvPVJL/2xiGnirYiW6BhtVtvB2nbcxkUZw?=
 =?us-ascii?Q?X8T0YsDJ9gaLiWluWye/YJwZhlYlX8dZaYNlGSh33B0Keq2AR5ERYZ0u7ynJ?=
 =?us-ascii?Q?JTvUGQ+wrIw+zj42fAkweUn+p67f6VrxZInIJOtzV5vXrgvryj+4Ymdt1tOY?=
 =?us-ascii?Q?yh/i9mg0dBRtz/1u+9VtWGm1/QOOdIQWcsT9oUuWcWb5HmQavVEDhUSB04kk?=
 =?us-ascii?Q?wdN2TA5yyWw7lztqy5HldKmeFHHcGHhEKgJkiaFiH1hejrY0zFdAx3L3f1ai?=
 =?us-ascii?Q?5qm9LJ0oULlxvDI1c+NrqFR66zliMC48Zz8Mr+3n?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca07b474-f745-41f0-eadf-08dad8cabfc9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 03:17:33.8396
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JYhUhvFiX2QMOWXlYVKYZpXn/PDv0OAo2yy7StVRackRSM78qc+1TMhj8TmtCRgvnP9CwZS34T3qGOFwUw8tGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB5192
X-Proofpoint-GUID: K5Ur00WpGgAITNWc3HSvzzYICH2SYSWH
X-Proofpoint-ORIG-GUID: K5Ur00WpGgAITNWc3HSvzzYICH2SYSWH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-07_11,2022-12-07_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, December 6, 2022 5:27 PM
> To: Veerasenareddy Burru <vburru@marvell.com>
> Cc: Leon Romanovsky <leon@kernel.org>; David S. Miller
> <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Paolo
> Abeni <pabeni@redhat.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Liron Himi <lironh@marvell.com>; Abhijit Ayarekar
> <aayarekar@marvell.com>; Sathesh B Edara <sedara@marvell.com>;
> Satananda Burla <sburla@marvell.com>; linux-doc@vger.kernel.org
> Subject: Re: [EXT] Re: [PATCH net-next v2 2/9] octeon_ep: poll for contro=
l
> messages
>=20
> On Tue, 6 Dec 2022 21:19:26 +0000 Veerasenareddy Burru wrote:
> > > That said, looking at what this set does - how are the VFs configured=
?
> > > That's the showstopper for the series in my mind.
> >
> > VFs are created by writing to sriov_numvfs.
>=20
> Configured, not enabled.

We have a follow up patch after this series implementing ndo_get_vf_xxx() a=
nd ndo_set_vf_xxx().

Thanks

