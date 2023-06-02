Return-Path: <netdev+bounces-7591-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AC65720BDC
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E92B281B22
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F096DC15B;
	Fri,  2 Jun 2023 22:23:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0EAC14C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:23:40 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787FE1B7;
	Fri,  2 Jun 2023 15:23:39 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352HexGU028551;
	Fri, 2 Jun 2023 22:23:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ag/iHAsYsEg7lFkhv8xhgWW2geipMQwjNisvDQK16h4=;
 b=YTWj1UMVLqwhltr/utrsKOrd1oCpkbDRHtN+7oTh2eQbOA1wtvmjF8LSEIsfZ5VQidG6
 GfZLXzI+pObWm8BRUD6jNUqzmjsP6jwo+C1EtTXsrpJG/2aiWoC+eBWfGYD9MjBtywvX
 g3SW6It86Ib1dbprCzhH00BfMxrrnmX/eAlAiSXf4L4mfu8oh1jqgtrZqZE+5FYkmMqa
 1UTvdIl41j+RRgzu6ENkdOyHojElBLKgW0OcMV6J+rYdFAKgiTHCVK1jWqysvXOAuS6m
 wCoqRowS+DCp6g8w7i3U1ownO9wfrO1oRyGgCnuXkBXm3NspHlmZS7+gTAc6xPUogKk9 qA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmeuv3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jun 2023 22:23:03 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 352MEECX031900;
	Fri, 2 Jun 2023 22:23:03 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8qdq7j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 02 Jun 2023 22:23:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MDLlgOKasn4OTOnnpboKKcP2jSjemM/f4F98RuxtneDxLksBkQskdd61EThbXLvMhFl20q8h3PzjR+YznpHPlMruf/9MOqdNC2OdfHglyX7pb52x9ykrClD1UbwvHVkfVPOVzlllSixP8JV8LIcnPsYPXKca501rOk6yoFFvGlwiVFE/KWM2c9xVI/dBt8AJzyYEW+jlVDLCNiqoRo3KoJU4V0FTx4A+QDp0jbdngwcj8VXa8wVc4SClmqnJWAaLPej2mMZmlxSoXrxQJLgPkBA2DSLiOXNozMf9dbmAj6lV1xjslulEEfSwbK4rBz8BnjZY/0i768B3NvyBE/MZNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ag/iHAsYsEg7lFkhv8xhgWW2geipMQwjNisvDQK16h4=;
 b=Fg/WNU1+xQAfIgyBv7T8F/Xv3Q+b24chCbZyfRSKwklZuqD8ofA424jOFkdoxrBJfWKe5EBl3I21nW7FqKvd3z3/YQyRCUTOQBweMopnEB5O4qgO/62DKlwOLOG6E7eaEnjann6GawVqMRdokxop6BCFlgi2A78E9qwMiZxdkQBa0pOU10L65lRo1b4uyWe64Q+sHXiXatVQVzUWOsADSUGFc2wuhU2NpJxpKTLHOLNgXC8Da0NOg7L9EwsoFsGHIIKvpNdmkDTcCBcif8ESgDgFr4xcrfAabTSjO61A9qh078TnFH52Ky4h52aCCfDpEkO3SwwHcfY0zaKtT85GdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ag/iHAsYsEg7lFkhv8xhgWW2geipMQwjNisvDQK16h4=;
 b=yx4G/fK7QiklKSbBgCks/bEat/+dW/2uAucHHrArzjW2XQ5WApUmE7jVaARWeG4FFQqcT+jhLvedTQTnM/h2igRmUwLJks+15wC0hTrunKUprl4Fza+AkvuJwItCMN6LoAtCb1vTq3UUsI8MM/meE5igfZVgY2Shz91CbH7wrls=
Received: from MN2PR10MB4144.namprd10.prod.outlook.com (2603:10b6:208:1d6::11)
 by BN0PR10MB5239.namprd10.prod.outlook.com (2603:10b6:408:12d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Fri, 2 Jun
 2023 22:23:01 +0000
Received: from MN2PR10MB4144.namprd10.prod.outlook.com
 ([fe80::7c6f:cba5:5e1f:ca27]) by MN2PR10MB4144.namprd10.prod.outlook.com
 ([fe80::7c6f:cba5:5e1f:ca27%5]) with mapi id 15.20.6433.022; Fri, 2 Jun 2023
 22:23:01 +0000
From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Evgeniy
 Polyakov <zbr@ioremap.net>,
        Christian Brauner <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org"
	<leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com"
	<petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] connector/cn_proc: Performance improvements
Thread-Topic: [PATCH v4 5/6] connector/cn_proc: Performance improvements
Thread-Index: 
 AQHZZCxMA20H0kIuSECLZNtWm5vHUK92gweAgAADfoCAAALogIAAAUyAgAAGMACAAehSAA==
Date: Fri, 2 Jun 2023 22:23:01 +0000
Message-ID: <F283FB65-7F15-4137-9182-0A20D6A0338D@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-6-anjali.k.kulkarni@oracle.com>
 <20230601092533.05270ab1@kernel.org>
 <B9B5E492-36A1-4ED5-97ED-1ED048F51FCF@oracle.com>
 <20230601094827.60bd8db1@kernel.org>
 <FD84A5B5-8C98-4796-8F69-5754C34D2172@oracle.com>
 <20230601101514.775c631a@kernel.org>
In-Reply-To: <20230601101514.775c631a@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR10MB4144:EE_|BN0PR10MB5239:EE_
x-ms-office365-filtering-correlation-id: 6a0ec0c9-b4a1-41f0-381e-08db63b7ed24
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 n4W7/bX1J1unsd2FoIQPo6A2P3jpR88Fw9FeLNS7mDLuk9gYS2vw99PDetA6KTO8yHiivTwCoob5SpXozTO/DASZHbYbQvfc+XWGByL/14Yzus/3bJ73Xbq/qnobixGH6VkIaFtky0EuBMrbGGMv0zUOcpJoWJjGF9zkT2WNKjHRK0Ured1NBQ/BS2qrcwsFciaC833TeEZRMpuK96a5kMuGqq63odbHali4KqqZr/y0MKMcHO7qORdutT/+TwMBpkt6ItZlzAmQjtXAYgkaSX4W7nr8cP18HYyupO076a5NGSTaEPQmxYB/uV6+QOsnFcSd2kDQc0YiGNziOBlsWVdhv87f2rK5y9bXd7XsFxu2QyrY62KSjmR8LYipQTcRU3+uRp8kG8PJV8Ay/6BfGFNDNVZlnN+7cn+gzzWD1SzPy57u+CF+ae+1JvviEPVHCkZi6EkFLza1a5jlH05WtTihXdt1GCuGDsj5OL14KplOHfYk+QEyAqrrDtWKGDBnexbkaWbpk5EVPbrcK3oAQbJdMFIGvElDqSRQjbbkVezD7F239Goz3a0uUgg96XPGJp6+O5f6wZkllc0d92eq6J3ri8qAErkjdeVzW2ltgF9NdiWygw3w/dGryaCgNBLk4bzA7XF9U4z9OoQ/3gFpRA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4144.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(396003)(39860400002)(136003)(451199021)(478600001)(54906003)(5660300002)(8676002)(8936002)(33656002)(41300700001)(6486002)(6916009)(86362001)(966005)(71200400001)(316002)(4326008)(6512007)(53546011)(186003)(7416002)(66556008)(66946007)(91956017)(76116006)(64756008)(66446008)(66476007)(26005)(6506007)(38070700005)(2616005)(2906002)(83380400001)(36756003)(38100700002)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?FTQsGpWtOxlHaGou/s7l7vzfDr3nRMyJ+9cOFHY9sdy7VQ/YSltoNeF4Xqx1?=
 =?us-ascii?Q?C6Z7T8C0NTPzqQVeFHJ0C/RcqFch0jOhskSwSw+kV+hHWwPET2jctaOwHSZm?=
 =?us-ascii?Q?Ej3VWXxnUWf9LBQKE/H6xAEed/GCz/ifn5MpI2vt8l91uVi+sCWgZEdFUXUq?=
 =?us-ascii?Q?8ZyNlCBQeNqeck2OjCh89HLzqKOEcZyicu0FsKDzYF1x3xyLtfGyYZQgtO6B?=
 =?us-ascii?Q?J4nAfh82zAoul3jwc2lrllV9wiyGem9y34vJ8q2m/7Rr8oRqqsFOKsjvZnmZ?=
 =?us-ascii?Q?VOeicvSI3FhT5Pb7z4CnlvXtxFKSJzOtLVcAapMDwZvaKMZoxRR8IYxF1u1K?=
 =?us-ascii?Q?byGhGqPYHTG+URZC7LDLHtklJq/C1qgDM6gJHNdpwpZPsVbQIRQ9RBhktjMB?=
 =?us-ascii?Q?Q9a8YQOSuLiuFaHj+snRGAEzKLJjn6/gGBzgiYukEN65+1hTUp49rVIRVDP/?=
 =?us-ascii?Q?1E/2FT3T7LDIawib+Onzrr0QyyE3KtK3JLUGSEmnJ0jGNkH/3BPlsVfnqZ6B?=
 =?us-ascii?Q?gqv4bws3OnFTamsK6CsrfJjqSXlDejwuhtM0ZTzORN4UjayUQYHndUFGeCk8?=
 =?us-ascii?Q?85JTwcpLVorCGqGAahzjFpGaZkfZ0H7TerwcuIN4YjIwlDZofMJtUvaflMCt?=
 =?us-ascii?Q?gfClmnpKDsxdXHWQccMKZKXjDxeYs+5851EQu9etIjlT6fGAouGZKsvqb7P7?=
 =?us-ascii?Q?xtD0iIhVAU/XhIvx9+UdGeVEZ7CYilBm+KcXzjI5iPIg8/fHAo4utZVmDosX?=
 =?us-ascii?Q?DCiMujUD09+L1qU/jCIoYvEIKocXuXwzgICVXGVa/S/33SyrYxpjUBMetFWP?=
 =?us-ascii?Q?PqGLgV6PVPUQe9QOEHesuV0+8XinyeHJHlD756ehJc+91ZWdZQxZ7pZg+FIa?=
 =?us-ascii?Q?YaI0I5Jw1cNRQ9/lDti+7WY57AeLWaXoc+UzQYJ1OSdD7k64DzH5AQy1Jy14?=
 =?us-ascii?Q?2D2oJ+WNyDijlZ2xksBe7yXg9VGVy/bs7/EXuv28nQfDlxICZNfpq2q3L4fV?=
 =?us-ascii?Q?r09gjzzJpnWovVFTBNGK3wR8v+4j+R21LhgFLz01c02WjntHZmC/jyO/96CW?=
 =?us-ascii?Q?KaiKS/fkvUkxObOcvD75INW1gFans0MVfG5hJJwSGfc8msXapOhqWteCP8iB?=
 =?us-ascii?Q?NWqEXw+VdCkzNma0WYO8i8KjYBkmqwUQpAtgmL5NZQKt17mhFNomrd2S3f0N?=
 =?us-ascii?Q?ESlPUpCtg4GMuwiE/g6thdksvt4JangQ8lzeErIvSrRpwgXtMz5b2alKcFjX?=
 =?us-ascii?Q?yhoORhjyWenqE/rINj6O479J8zW1Fa+FcV2PPas94IK67J2z4Z1qd18wwLo3?=
 =?us-ascii?Q?jBTbdf1t0xXvzgsiFCxl+6f99ZZwzK4TozyT9e2lIiQUSpik8FdXDzyzJABc?=
 =?us-ascii?Q?etQvH+sLrKhdsbOL1v1XERRlITZ6N8CFu03RrdcmkNDR/JlLKq+o8UBUGfeb?=
 =?us-ascii?Q?kHDTS9yT9Pg8zCd+6YVkBJcXgqtpr0STU1VLAGDm2oJDkwfwIc/3AbPrH9jb?=
 =?us-ascii?Q?UXEDFEcR7Ytz0Vof8zjERikBKpK2XIBe6vHDrU2ZxBx6vO5c4FUEuQ5T8aEo?=
 =?us-ascii?Q?cUOPGGn+faKTEhG9MreNTh7I4mEb1U2LyNTgS+AruddlafyhcrO/yhFmsZt4?=
 =?us-ascii?Q?fA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <81BDB68B01C97542BE85CF9AC41503FA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?xNHisM80l04w017DDmShCfQ61BevzWTdVBQi9gy9seU+VfUGGTq62LljBvm/?=
 =?us-ascii?Q?UZGyE86lmfTNfVuf5WSB6ME7dnSJYogMVd7yFin5KJPTHB2FBVbXWsAgmivf?=
 =?us-ascii?Q?Eh3d1KWFQ/bLsd64si6Rxt7g0ggnJ9ViO/jCDcxuCyTnt1bQZrFiRbycwKwX?=
 =?us-ascii?Q?39oqzhzdPuVCMC5jKn9pEz3JxFkZfC7r3x9rHJVT1JGHlmH3ijqCY7Rg13rz?=
 =?us-ascii?Q?6Rxzaq0lh4xuHtemQja+gRXj6PN1ZoBQxlrdWh0U+KhfxZHcH5/ZFmhNtmNd?=
 =?us-ascii?Q?XX4TDl02u7mdmNiR9Gwyu5DJhhi9pUERjrBsBdO8R7MdXaXYVQYHf1QgehbG?=
 =?us-ascii?Q?r1DS6mHIG0BPvgs9L38W4Uf9vjdqywgWD8LsfQmtwZR8E92B1nvD2chdCPuU?=
 =?us-ascii?Q?Iuamqn9MyYr3xXeIaOGs3eMg5d4krTX+2IpFcYeVrP8tKmA+uePi2OdZFR6K?=
 =?us-ascii?Q?DhKAadT0lxEngvF2mziFITUGBRM7JDsIEhlvFtRBufKCmL3ERBy0CpRBEKT5?=
 =?us-ascii?Q?wlMRmoyY7CHMJa5qTK9UGvpARZtD5fpeUaYIy6ncLrI/e+UDjNpJjPdhskia?=
 =?us-ascii?Q?1ovT4usXTrkmN1V+9koOQcpM3lx+gNx8hZ9Rb6hjVTFSM0lHuD4Qehj8GzV0?=
 =?us-ascii?Q?5OgrMtRwc+KaHkcn+gwhDQleQFF7n+uOJTo3Dq5oOFCQm2eZkipsHNofzFK6?=
 =?us-ascii?Q?ou8paBIK2q3bch0pb1d3K9cAockou7V8cgzvmhtCKlyLAlwtYFSSZ8+mtOjx?=
 =?us-ascii?Q?tOESUCtvXGDcQqf+LFFNk1pxYwQqu0SdbP5a2+NPxg4zEb+sXYSSw+o7GGb1?=
 =?us-ascii?Q?Klrzm4ZrxhtW/Aw+9L1ZCZ0g2PcbwZRANYLRYI+T4HLyeoW0r9el4koskwYx?=
 =?us-ascii?Q?1k5bXjIq5yoJYxLfVak8wQ78U8vs0ZmwSYW69xZ5kKxctr3YJBz9Hp43tjpz?=
 =?us-ascii?Q?7VnuiDxizBg4+yba8LdwrX1OSi3SE/AMh4D4VkkXDlA9jAq1meMEOTD8Abo4?=
 =?us-ascii?Q?PjtUNEyLW4YcYxc3LBeUUSWKhFgVNzMEAsHi8ioXY859Pl2MZi27yKq0mtfI?=
 =?us-ascii?Q?6PAfcRH2ffEDtmt8iKcZCvPE6369KA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4144.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0ec0c9-b4a1-41f0-381e-08db63b7ed24
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2023 22:23:01.1207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: inVeBTsrq72tQiYw2Lg6emEJm4rfRkk19TqdohssAbYEd0i9yJ5YNPxoa/y0uWQly9FIv+6I8c+sgf2gZbys6lTDxQTHkeUVTSyKomMC1lo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5239
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_16,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=976
 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306020175
X-Proofpoint-ORIG-GUID: hLnljra6JY0z98GxM6SV3dEm57H3hSxC
X-Proofpoint-GUID: hLnljra6JY0z98GxM6SV3dEm57H3hSxC
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 1, 2023, at 10:15 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Thu, 1 Jun 2023 16:53:07 +0000 Anjali Kulkarni wrote:
>>> Is it possible to recode the sample so the format can be decided based
>>> on cmd line argument? To be honest samples are kinda dead, it'd be best
>>> if the code was rewritten to act as a selftest. =20
>>=20
>> Yes, I can recode to use a cmd line argument. Where would a selftest
>> be committed?
>=20
> The path flow is the same as for the sample, the file just goes to
> tools/testing/selftests rather than samples/.
>=20
>> This is kind of a self test in the sense that this is
>> working code  to test the other kernel code. What else is needed to
>> make it a selftest?
>=20
> Not much, really. I think the requirement is to exit with a non-zero
> return code on failure, which you already do. 0 means success; 1 means
> failure; 2 means skip, IIRC.
>=20
> The main work in your case would be that the selftest needs to do its
> checking and exit, so the stimuli must be triggered automatically.
> (You can use a bash script to drive the events.)

Thanks! So this will be part of the kselftest infra right?=20
https://docs.kernel.org/dev-tools/kselftest.html ?


